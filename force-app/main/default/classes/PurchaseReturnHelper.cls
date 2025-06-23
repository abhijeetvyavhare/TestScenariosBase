public with sharing class PurchaseReturnHelper {

    private static Boolean skipValidations = false;
   
    private static final string FIELD_PURCHASERETURN_PERFORMRETURN = 'dmpl__PerformReturn__c';
    private static final string FIELD_PURCHASERETURN_ISRETURNED = 'dmpl__IsReturned__c';
    private static final string OBJECT_PURCHASERETURN = 'dmpl__PurchaseReturn__c';
    private static final string FIELD_PURCHASERETURN_STATUS = 'dmpl__Status__c';
    private static final string FIELD_PURCHASERETURN_PARTNERACCOUNTID = 'dmpl__PartnerAccountId__c';
    private static final string FIELD_PURCHASERETURN_BRANCHID = 'dmpl__BranchId__c';
    private static final string FIELD_PURCHASERETURN_DOCUMENTDATE ='dmpl__DocumentDate__c';
    private static final string FIELD_PURCHASERETURN_ISGLPOSTED ='dmpl__IsGLPosted__c';
    private static final string FIELD_PURCHASERETURN_ISGLPOSTINGAPPROVED ='dmpl__IsGLPostingApproved__c';
    private static final string FIELD_PURCHASERETURN_GLID ='dmpl__GeneralLedgerId__c';
    private static final string FIELD_PURCHASERETURNLINE_PURCHASERETURNID ='dmpl__PurchaseReturnId__c';
    private static final string FIELD_PURCHASERETURN_PERFORMGLPOSTING ='dmpl__PerformGLPosting__c';
    private static final string FIELD_PURCHASERETURN_PERFORMILPOSTING ='dmpl__PerformInventoryPosting__c';
    private static final string FIELD_PURCHASERETURN_RESOURCEID = 'dmpl__ResourceId__c';

    private static final List<String> LIST_NON_EDITABLE_FIELDS = new List<String>{ FIELD_PURCHASERETURN_PARTNERACCOUNTID, FIELD_PURCHASERETURN_BRANCHID, FIELD_PURCHASERETURN_DOCUMENTDATE};
    private static final List<String> LIST_FIELDS_SOURCEPOULATED = new List<String>{FIELD_PURCHASERETURN_PARTNERACCOUNTID, FIELD_PURCHASERETURN_BRANCHID};
    private static final List<String> LIST_FIELDS_SYSTEM = new List<String>{FIELD_PURCHASERETURN_GLID, FIELD_PURCHASERETURN_ISGLPOSTED, FIELD_PURCHASERETURN_ISGLPOSTINGAPPROVED};
    

    public static void validateData(Boolean isInsert, Boolean isUpdate, Boolean isDelete, List<dmpl__PurchaseReturn__c> newEntries, List<dmpl__PurchaseReturn__c> oldEntries)
    {
        try{   
            if(isInsert){
                FieldMappingHelper.copyFieldMappingData(
                    newEntries);
            }
            if(skipValidations){
                return;
            }
    
            DocumentStatusDFSHelper dfsHelper = new DocumentStatusDFSHelper();
            if(isInsert){
                StatusHelper.validateStatusNew(OBJECT_PURCHASERETURN, FIELD_PURCHASERETURN_STATUS, newEntries);
                ValidationHelper.validateResource(
                    FIELD_PURCHASERETURN_RESOURCEID, 
                    newEntries);
            }else if(isUpdate){
                StatusHelper.validateStatusEdit(OBJECT_PURCHASERETURN, FIELD_PURCHASERETURN_STATUS, oldEntries, newEntries);
                DocumentHelper.validateChangeInSystemFields(LIST_FIELDS_SYSTEM, oldEntries, newEntries);
                DocumentHelper.validateChangeInKeyFields(LIST_NON_EDITABLE_FIELDS, oldEntries, newEntries,queryTransactedObjectIds(newEntries));
                dfsHelper.DocumentStatusRestrictEdits_Edit(OBJECT_PURCHASERETURN, FIELD_PURCHASERETURN_STATUS, oldEntries, newEntries);
                dfsHelper.DocumentStatusRestrictFieldsEdits(OBJECT_PURCHASERETURN, FIELD_PURCHASERETURN_STATUS, oldEntries, newEntries);
                ValidationHelper.validateResource(
                    FIELD_PURCHASERETURN_RESOURCEID, 
                    newEntries);
            }else if(isDelete){
                dfsHelper.DocumentStatusRestrictEdits_Delete(OBJECT_PURCHASERETURN, FIELD_PURCHASERETURN_STATUS, oldEntries);
            }
        }catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }
   
    public static void postData(Boolean isInsert, Boolean isUpdate, Boolean isDelete, List<dmpl__PurchaseReturn__c> newEntries, List<dmpl__PurchaseReturn__c> oldEntries)
    {
        if(isInsert)
    		DocumentNameHelper.generateDocumentName(newEntries);
        
        if(isUpdate)
        {
            List<dmpl__PurchaseReturn__c> modifiedObjectsGL = DocumentHelper.getApprovedObjects(FIELD_PURCHASERETURN_PERFORMGLPOSTING, oldEntries, newEntries);
            if(modifiedObjectsGL.size()>0){
                PostGL(modifiedObjectsGL);
            }

            List<dmpl__PurchaseReturn__c> modifiedObjectsIL = DocumentHelper.getApprovedObjects(FIELD_PURCHASERETURN_PERFORMILPOSTING, oldEntries, newEntries);
            if(modifiedObjectsIL.size()>0){
                PostIL(modifiedObjectsIL);
            }

            List<dmpl__PurchaseReturn__c> modifiedObjects = DocumentHelper.getApprovedObjects(FIELD_PURCHASERETURN_PERFORMRETURN, oldEntries, newEntries);
            if(modifiedObjects.size() > 0)
                performReturn(modifiedObjects);
        }
    }

    public static CreateRelatedResult createPurchaseReturnFromPurchaseInvoice(List<SourceObjectInfo> invoiceLinesInfo, Id purchaseReturnId){
        return CreateRelatedResult.InitFrom(
            createPurchaseReturnLinesFromInvoiceInternal(
                queryPurchaseInvoiceLines(
                    (List<Id>)null, 
                    SourceObjectInfo.extractIds(invoiceLinesInfo)), 
                invoiceLinesInfo, purchaseReturnId));
    }

    private static Map<Id, dmpl__PurchaseReturnLine__c> createPurchaseReturnLinesFromInvoiceInternal(
        List<dmpl__BillLine__c> billLines,
        List<SourceObjectInfo> invoiceLineInfo, Id purchaseReturnId){
        if(billLines.size() == 0){
            throw new DMPLException(
                String.format(
                    String.valueOf(System.Label.Generic_EmptyActionParam), 
                    new String[]{
                        dmpl__BillLine__c.class.getName()}));
        }

        List<dmpl__PurchaseReturnLine__c> purchaseReturnLines = new List<dmpl__PurchaseReturnLine__c>();
        for(dmpl__BillLine__c billLine : billLines){
            if(billLine.dmpl__EligibleReturnQuantity__c>0){
                purchaseReturnLines.add(
                        createReturnLineFromPurchaseInvoiceLine(
                            billLine,
                            invoiceLineInfo));
            }
        }
        
        if(purchaseReturnLines.size() >0){
            Savepoint sp = Database.setSavepoint();
            try {
                for(dmpl__PurchaseReturnLine__c purchaseReturnLine : purchaseReturnLines){
                    purchaseReturnLine.dmpl__PurchaseReturnId__c = purchaseReturnId;
                }    
                
                SecurityHelper.ensureCanCreateObject('dmpl__PurchaseReturnLine__c');
                SecurityHelper.ensureCanCreateFields(new string[]
                {
                    'dmpl__PurchaseReturnId__c',
                    'dmpl__ItemId__c',
                    'dmpl__SKUId__c',
                    'dmpl__Quantity__c',
                    'dmpl__GeneralLedgerId__c',
                    'dmpl__GLAccountId__c',
                    'dmpl__InventoryLedgerId__c',
                    'dmpl__ItemLotId__c',
                    'dmpl__PurchaseOrderLineId__c',
                    'dmpl__StorageLocationId__c',
                    'dmpl__TaxGroupId__c',
                    'dmpl__UnitCost__c',
                    'dmpl__GoodsReceiptLineId__c',
                    'dmpl__PurchaseInvoiceId__c'
                }, 'dmpl__PurchaseReturnLine__c');

                insert purchaseReturnLines;
            } catch (Exception e) {
                Database.rollback(sp);
                throw e;
            }
        }
        return new Map<Id, dmpl__PurchaseReturnLine__c>(purchaseReturnLines);
    }

    @TestVisible
    private static dmpl__PurchaseReturnLine__c createReturnLineFromPurchaseInvoiceLine(
        dmpl__BillLine__c billLine,
        List<SourceObjectInfo> invoiceLinesInfo){
        Decimal requestedQty = SourceObjectInfo.getRequestedQuantity(invoiceLinesInfo, billLine.Id);
        return new dmpl__PurchaseReturnLine__c(
            dmpl__BillLineId__c = billLine.Id,
            dmpl__ItemId__c = billLine.dmpl__ItemId__c,
            dmpl__SKUId__c = billLine.dmpl__SKUId__c,
            dmpl__GeneralLedgerId__c = billLine.dmpl__GeneralLedgerId__c,
            dmpl__GLAccountId__c = billLine.dmpl__GLAccountId__c,
            dmpl__InventoryLedgerId__c = billLine.dmpl__InventoryLedgerId__c,
            dmpl__ItemLotId__c = billLine.dmpl__ItemLotId__c,
            dmpl__PurchaseOrderLineId__c = billLine.dmpl__PurchaseOrderLineId__c,
            dmpl__StorageLocationId__c = billLine.dmpl__StorageLocationId__c,
            dmpl__TaxGroupId__c = billLine.dmpl__TaxGroupId__c,
            dmpl__UnitCost__c = billLine.dmpl__UnitCost__c,
            dmpl__PurchaseInvoiceId__c = billLine.dmpl__PurchaseInvoiceId__c,
            dmpl__GoodsReceiptLineId__c = billLine.dmpl__GoodsReceiptLineId__c,
            dmpl__Quantity__c = requestedQty >0 ? requestedQty : billLine.dmpl__EligibleReturnQuantity__c
        );
    }

    private static void PostGL(List<dmpl__PurchaseReturn__c> returns)
    {
        SecurityHelper.ensureCanWriteField('dmpl__IsGLPostingApproved__c', 'dmpl__PurchaseReturn__c');
        SecurityHelper.ensureCanWriteField('dmpl__PerformGLPosting__c', 'dmpl__PurchaseReturn__c');
        for(dmpl__PurchaseReturn__c document : returns){
            document.dmpl__IsGLPostingApproved__c = true;
            document.dmpl__PerformGLPosting__c = false;
        }
        PurchaseReturnLineHelper.approvePurchaseReturnLines(returns);
    }

    private static void POSTIL(List<dmpl__PurchaseReturn__c> modifiedDocuments)
    {
        PurchaseReturnLineHelper.postReturnLines(modifiedDocuments);
        SecurityHelper.ensureCanWriteField('dmpl__PerformInventoryPosting__c', 'dmpl__PurchaseReturn__c');
        //SecurityHelper.ensureCanWriteField('dmpl__IsInventoryPosted__c', 'dmpl__PurchaseReturn__c');
        for(dmpl__PurchaseReturn__c document : modifiedDocuments){
            document.dmpl__PerformInventoryPosting__c = false;
        }
    }

    public static void afterPostData(Boolean isInsert, Boolean isUpdate, Boolean isDelete, List<dmpl__PurchaseReturn__c> newEntries, List<dmpl__PurchaseReturn__c> oldEntries)
    {
        
    }

    private static void performReturn(List<dmpl__PurchaseReturn__c> modifiedObjects){
        // PurchaseOrderLineHelper.updateReturnQuantityFromPurchaseReturn(modifiedObjects);
        // GoodReceiptLineHelper.updateGoodsReceiptLinesFromPurchaseReturn(modifiedObjects);
        // BillLineHelper.updateBillLinesFromPurchaseReturn(modifiedObjects);
        SecurityHelper.ensureCanWriteField('dmpl__IsReturned__c', 'dmpl__PurchaseReturn__c');
        SecurityHelper.ensureCanWriteField('dmpl__PerformReturn__c', 'dmpl__PurchaseReturn__c');
        for(dmpl__PurchaseReturn__c lineEntry : modifiedObjects){
            lineEntry.dmpl__PerformReturn__c = false;
            lineEntry.dmpl__IsReturned__c = true;
        }
    }

     private static List<Id> queryTransactedObjectIds(List<dmpl__PurchaseReturn__c> newEntries){
        SecurityHelper.ensureCanReadFields(new string[]{'dmpl__PurchaseReturnId__c'}, 'dmpl__PurchaseReturnLine__c');
        return DocumentHelper.extractIds([SELECT dmpl__PurchaseReturnId__c 
                FROM dmpl__PurchaseReturnLine__c
                WHERE dmpl__PurchaseReturnId__c IN:DocumentHelper.extractIds(newEntries)], FIELD_PURCHASERETURNLINE_PURCHASERETURNID);
    }

    private static List<dmpl__BillLine__c> queryPurchaseInvoiceLines(List<Id> purchaseInvoiceIds, List<Id> purchaseInvoiceLineIds)
    {
        if(purchaseInvoiceIds == null){
            purchaseInvoiceIds = new List<Id>();
        }

        if(purchaseInvoiceLineIds == null){
            purchaseInvoiceLineIds = new List<Id>();
        }

        SecurityHelper.ensureCanReadFields(new string[]{
            'dmpl__PartnerAccountId__c',
            'dmpl__BranchId__c',
            'dmpl__SupplierAccountId__c',
            'dmpl__DocumentDate__c',
            'dmpl__GLAccountId__c',
            'dmpl__GeneralLedgerId__c'},
            'dmpl__Bill__c');
        SecurityHelper.ensureCanReadFields(new string[]{
            'dmpl__ItemId__c',
            'dmpl__SKUId__c',
            'dmpl__UnitCost__c',
            'dmpl__Quantity__c',
            'dmpl__TaxGroupId__c',
            'dmpl__EligibleReturnQuantity__c', 
            'dmpl__Discount__c', 
            'dmpl__DiscountAmount__c', 
            'dmpl__GLAccountId__c',
            'dmpl__InventoryLedgerId__c',
            'dmpl__ItemLotId__c',
            'dmpl__PriceListRuleId__c',
            'dmpl__PurchaseInvoiceId__c',
            'dmpl__StorageLocationId__c',
            'dmpl__GoodsReceiptLineId__c',
            'dmpl__PurchaseOrderLineId__c'}, 
            'dmpl__BillLine__c');

        return [SELECT Id,
            Name,
            dmpl__ItemId__c,
            dmpl__SKUId__c,
            dmpl__UnitCost__c,
            dmpl__Quantity__c,
            dmpl__EligibleReturnQuantity__c,
            dmpl__TaxGroupId__c,
            dmpl__PurchaseOrderLineId__c,
            dmpl__PurchaseInvoiceId__r.dmpl__PartnerAccountId__c,
            dmpl__PurchaseInvoiceId__r.dmpl__BranchId__c,
            dmpl__PurchaseInvoiceId__r.dmpl__SupplierAccountId__c,
            dmpl__PurchaseInvoiceId__r.dmpl__DocumentDate__c,
            dmpl__PurchaseInvoiceId__r.dmpl__GeneralLedgerId__c,
            dmpl__PurchaseInvoiceId__r.dmpl__GLAccountId__c,
            dmpl__Discount__c,
            dmpl__DiscountAmount__c,
            dmpl__GLAccountId__c,
            dmpl__InventoryLedgerId__c,
            dmpl__ItemLotId__c,
            dmpl__PurchaseInvoiceId__c,
            dmpl__StorageLocationId__c,
            dmpl__GeneralLedgerId__c,
            dmpl__GoodsReceiptLineId__c
        FROM dmpl__BillLine__c
        WHERE dmpl__PurchaseInvoiceId__c IN :purchaseInvoiceIds OR Id IN :purchaseInvoiceLineIds
        ];
    }
}