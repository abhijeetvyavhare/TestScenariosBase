public with sharing class BillReturnHelper {

    
    private static Boolean skipValidations = false;
   
    private static final string FIELD_BILLRETURN_PERFORMRETURN = 'dmpl__PerformReturn__c';
    private static final string FIELD_BILLRETURN_ISRETURNED = 'dmpl__IsReturned__c';
    private static final string OBJECT_BILLRETURN = 'dmpl__BillReturn__c';
    private static final string FIELD_BILLRETURN_STATUS = 'dmpl__Status__c';
    private static final string FIELD_BILLRETURN_PARTNERACCOUNTID = 'dmpl__PartnerAccountId__c';
    private static final string FIELD_BILLRETURN_BRANCHID = 'dmpl__BranchId__c';
    private static final string FIELD_BILLRETURN_DOCUMENTDATE ='dmpl__DocumentDate__c';
    private static final string FIELD_BILLRETURN_ISGLPOSTED ='dmpl__IsGLPosted__c';
    private static final string FIELD_BILLRETURN_ISGLPOSTINGAPPROVED ='dmpl__IsGLPostingApproved__c';
    private static final string FIELD_BILLRETURN_GLID ='dmpl__GeneralLedgerId__c';
    private static final string FIELD_BILLRETURNLINE_BILLRETURNID ='dmpl__BillReturnId__c';
    private static final string FIELD_BILLRETURN_PERFORMGLPOSTING ='dmpl__PerformGLPosting__c';
    private static final string FIELD_BILLRETURN_PERFORMILPOSTING ='dmpl__PerformInventoryPosting__c';

    private static final List<String> LIST_NON_EDITABLE_FIELDS = new List<String>{ FIELD_BILLRETURN_PARTNERACCOUNTID, FIELD_BILLRETURN_BRANCHID, FIELD_BILLRETURN_DOCUMENTDATE};
    private static final List<String> LIST_FIELDS_SOURCEPOULATED = new List<String>{FIELD_BILLRETURN_PARTNERACCOUNTID, FIELD_BILLRETURN_BRANCHID};
    private static final List<String> LIST_FIELDS_SYSTEM = new List<String>{FIELD_BILLRETURN_GLID, FIELD_BILLRETURN_ISGLPOSTED, FIELD_BILLRETURN_ISGLPOSTINGAPPROVED};
    

    public static void validateData(Boolean isInsert, Boolean isUpdate, Boolean isDelete, List<dmpl__BillReturn__c> newEntries, List<dmpl__BillReturn__c> oldEntries)
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
                StatusHelper.validateStatusNew(OBJECT_BILLRETURN, FIELD_BILLRETURN_STATUS, newEntries);
            }else if(isUpdate){
                StatusHelper.validateStatusEdit(OBJECT_BILLRETURN, FIELD_BILLRETURN_STATUS, oldEntries, newEntries);
                DocumentHelper.validateChangeInSystemFields(LIST_FIELDS_SYSTEM, oldEntries, newEntries);
                DocumentHelper.validateChangeInKeyFields(LIST_NON_EDITABLE_FIELDS, oldEntries, newEntries,queryTransactedObjectIds(newEntries));
                dfsHelper.DocumentStatusRestrictEdits_Edit(OBJECT_BILLRETURN, FIELD_BILLRETURN_STATUS, oldEntries, newEntries);
                dfsHelper.DocumentStatusRestrictFieldsEdits(OBJECT_BILLRETURN, FIELD_BILLRETURN_STATUS, oldEntries, newEntries);
            }else if(isDelete){
                dfsHelper.DocumentStatusRestrictEdits_Delete(OBJECT_BILLRETURN, FIELD_BILLRETURN_STATUS, oldEntries);
            }
        }catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }
   
    public static void postData(Boolean isInsert, Boolean isUpdate, Boolean isDelete, List<dmpl__BillReturn__c> newEntries, List<dmpl__BillReturn__c> oldEntries)
    {
        if(isInsert)
        DocumentNameHelper.generateDocumentName(newEntries);
        
        if(isUpdate)
        {
            List<dmpl__BillReturn__c> modifiedObjectsGL = DocumentHelper.getApprovedObjects(FIELD_BILLRETURN_PERFORMGLPOSTING, oldEntries, newEntries);
            if(modifiedObjectsGL.size()>0){
                PostGL(modifiedObjectsGL);
            }

            List<dmpl__BillReturn__c> modifiedObjectsIL = DocumentHelper.getApprovedObjects(FIELD_BILLRETURN_PERFORMILPOSTING, oldEntries, newEntries);
            if(modifiedObjectsIL.size()>0){
                PostIL(modifiedObjectsIL);
            }

            List<dmpl__BillReturn__c> modifiedObjects = DocumentHelper.getApprovedObjects(FIELD_BILLRETURN_PERFORMRETURN, oldEntries, newEntries);
            if(modifiedObjects.size() > 0)
                performReturn(modifiedObjects);
        }
    }

  public static CreateRelatedResult createBillReturnFromBill(List<SourceObjectInfo> invoiceLinesInfo, Id billReturnId){
        return CreateRelatedResult.InitFrom(
            createBillReturnLinesFromInvoiceInternal(
                queryBillInvoiceLines(
                    (List<Id>)null, 
                    SourceObjectInfo.extractIds(invoiceLinesInfo)), 
                invoiceLinesInfo, billReturnId));
    }

    @testVisible
    private static Map<Id, dmpl__BillReturnLine__c> createBillReturnLinesFromInvoiceInternal(
        List<dmpl__BillLine__c> billLines,
        List<SourceObjectInfo> invoiceLineInfo, Id billReturnId){
        if(billLines.size() == 0){
            throw new DMPLException(
                String.format(
                    String.valueOf(System.Label.Generic_EmptyActionParam), 
                    new String[]{
                        dmpl__BillLine__c.class.getName()}));
        }

        List<dmpl__BillReturnLine__c> billReturnLines = new List<dmpl__BillReturnLine__c>();
        for(dmpl__BillLine__c billLine : billLines){
            if(billLine.dmpl__EligibleReturnQuantity__c>0){
                billReturnLines.add(
                        createReturnLineFromBillInvoiceLine(
                            billLine,
                            invoiceLineInfo));
            }
        }
        
        if(billReturnLines.size() >0){
            Savepoint sp = Database.setSavepoint();
            try {
                for(dmpl__BillReturnLine__c billReturnLine : billReturnLines){
                    billReturnLine.dmpl__BillReturnId__c = billReturnId;
                }    
                
                SecurityHelper.ensureCanCreateObject('dmpl__BillReturnLine__c');
                SecurityHelper.ensureCanCreateFields(new string[]
                {
                    'dmpl__GoodsReceiptLineId__c',
                    'dmpl__PurchaseOrderId__c',
                    'dmpl__BillId__c',
                    'dmpl__BillReturnId__c',
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
                    'dmpl__Discount__c',
                    'dmpl__DiscountAmount__c',
                    'dmpl__SchemeDiscount__c',
                    'dmpl__SchemeDiscountAmount__c',
                    'dmpl__SchemeLineId__c'
                }, 'dmpl__BillReturnLine__c');

                insert billReturnLines;
            } catch (Exception e) {
                Database.rollback(sp);
                throw e;
            }
        }
        return new Map<Id, dmpl__BillReturnLine__c>(billReturnLines);
    }

    @TestVisible
    private static dmpl__BillReturnLine__c createReturnLineFromBillInvoiceLine(
        dmpl__BillLine__c billLine,
        List<SourceObjectInfo> invoiceLinesInfo){
        Decimal requestedQty = SourceObjectInfo.getRequestedQuantity(invoiceLinesInfo, billLine.Id);
        return new dmpl__BillReturnLine__c(
            dmpl__BillLineId__c = billLine.Id,
            dmpl__BillId__c = billLine.dmpl__PurchaseInvoiceId__c,
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
            dmpl__GoodsReceiptLineId__c = billLine.dmpl__GoodsReceiptLineId__c,
            dmpl__Quantity__c = requestedQty >0 ? requestedQty : billLine.dmpl__EligibleReturnQuantity__c,
            dmpl__Discount__c = billLine.dmpl__Discount__c,
            dmpl__DiscountAmount__c = billLine.dmpl__DiscountAmount__c,
            dmpl__Discount2__c = billLine.dmpl__Discount2__c,
            dmpl__DiscountAmount2__c = billLine.dmpl__DiscountAmount2__c,
            dmpl__ContractDiscount__c = billLine.dmpl__ContractDiscount__c,
            dmpl__ContractDiscountAmount__c = billLine.dmpl__ContractDiscountAmount__c,
            dmpl__SchemeDiscount__c = billLine.dmpl__SchemeDiscount__c,
            dmpl__SchemeDiscountAmount__c = billLine.dmpl__SchemeDiscountAmount__c,
            // dmpl__TaxAmount__c = billLine.dmpl__TaxAmount__c,
            dmpl__SchemeLineId__c = billLine.dmpl__SchemeLineId__c
        );
    }

    private static void PostGL(List<dmpl__BillReturn__c> returns)
    {
        SecurityHelper.ensureCanWriteField('dmpl__IsGLPostingApproved__c', 'dmpl__BillReturn__c');
        SecurityHelper.ensureCanWriteField('dmpl__PerformGLPosting__c', 'dmpl__BillReturn__c');
        for(dmpl__BillReturn__c document : returns){
            document.dmpl__IsGLPostingApproved__c = true;
            document.dmpl__PerformGLPosting__c = false;
        }
        BillReturnLineHelper.approveBillReturnLines(returns);
        BillReturnTaxHelper.approveBillTaxLines(returns);
    }

    private static void POSTIL(List<dmpl__BillReturn__c> modifiedDocuments)
    {
        BillReturnLineHelper.postReturnLines(modifiedDocuments);
        SecurityHelper.ensureCanWriteField('dmpl__PerformInventoryPosting__c', 'dmpl__BillReturn__c');
        for(dmpl__BillReturn__c document : modifiedDocuments){
            document.dmpl__PerformInventoryPosting__c = false;
        }
    }

    public static CreateRelatedResult postIL(Id hostId){
        return BillReturnLineHelper.postIL(hostId);
    }

    public static CreateRelatedResult postIL(List<SourceObjectInfo> childObjectsInfo, Id hostId){
        return BillReturnLineHelper.postIL(childObjectsInfo, hostId);
    }

    public static void afterPostData(Boolean isInsert, Boolean isUpdate, Boolean isDelete, List<dmpl__BillReturn__c> newEntries, List<dmpl__BillReturn__c> oldEntries)
    {
        
    }

    private static void performReturn(List<dmpl__BillReturn__c> modifiedObjects){
        for(dmpl__BillReturn__c lineEntry : modifiedObjects){
            lineEntry.dmpl__PerformReturn__c = false;
            lineEntry.dmpl__IsReturned__c = true;
        }
        
    }

     private static List<Id> queryTransactedObjectIds(List<dmpl__BillReturn__c> newEntries){
        SecurityHelper.ensureCanReadFields(new string[]{'dmpl__BillReturnId__c'}, 'dmpl__BillReturnLine__c');
        return DocumentHelper.extractIds([SELECT dmpl__BillReturnId__c 
                FROM dmpl__BillReturnLine__c
                WHERE dmpl__BillReturnId__c IN:DocumentHelper.extractIds(newEntries)], FIELD_BILLRETURNLINE_BILLRETURNID);
    }

    private static List<dmpl__BillLine__c> queryBillInvoiceLines(List<Id> billInvoiceIds, List<Id> billInvoiceLineIds)
    {
        if(billInvoiceIds == null){
            billInvoiceIds = new List<Id>();
        }

        if(billInvoiceLineIds == null){
            billInvoiceLineIds = new List<Id>();
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
            'dmpl__SchemeDiscount__c',
            'dmpl__SchemeDiscountAmount__c',
            'dmpl__SchemeLineId__c',
            'dmpl__TaxAmount__c',
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
            dmpl__Discount2__c,
            dmpl__DiscountAmount2__c,
            dmpl__ContractDiscount__c,
            dmpl__ContractDiscountAmount__c,
            dmpl__GLAccountId__c,
            dmpl__InventoryLedgerId__c,
            dmpl__ItemLotId__c,
            dmpl__PurchaseInvoiceId__c,
            dmpl__StorageLocationId__c,
            dmpl__GeneralLedgerId__c,
            dmpl__GoodsReceiptLineId__c,
            dmpl__SchemeDiscount__c,
            dmpl__SchemeDiscountAmount__c,
            dmpl__SchemeLineId__c,
            dmpl__TaxAmount__c
        FROM dmpl__BillLine__c
        WHERE dmpl__PurchaseInvoiceId__c IN :billInvoiceIds OR Id IN :billInvoiceLineIds
        ];
    }
}