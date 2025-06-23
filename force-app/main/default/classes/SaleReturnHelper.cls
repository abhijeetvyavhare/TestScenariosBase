public with sharing class SaleReturnHelper {
   
    private static Boolean skipValidations = false;

    private static final String FIELD_SALERETURN_PERFORMRETURN = 'dmpl__PerformReturn__c';
    private static final String FIELD_SALERETURN_ISRETURNED = 'dmpl__IsReturned__c';
    private static final string OBJECT_SALERETURN = 'dmpl__SaleReturn__c';
    private static final string FIELD_SALERETURN_STATUS = 'dmpl__Status__c';
    private static final string FIELD_SALERETURN_PARTNERACCOUNTID = 'dmpl__PartnerAccountId__c';
    private static final string FIELD_SALERETURN_BRANCHID = 'dmpl__BranchId__c';
    private static final string FIELD_SALERETURN_ACCOUNTID ='dmpl__AccountId__c';
    private static final string FIELD_SALERETURN_DOCUMENTDATE ='dmpl__DocumentDate__c';
    private static final string FIELD_SALERETURN_ISGLPOSTED ='dmpl__IsGLPosted__c';
    private static final string FIELD_SALERETURN_ISGLPOSTINGAPPROVED ='dmpl__IsGLPostingApproved__c';
    private static final string FIELD_SALERETURN_GLID ='dmpl__GeneralLedgerId__c';
    private static final string FIELD_SALERETURNLINE_SALERETURNID ='dmpl__SaleReturnId__c';
    private static final string FIELD_SALERETURN_PERFORMGLPOSTING ='dmpl__PerformGLPosting__c';
    private static final string FIELD_SALERETURN_PERFORMILPOSTING ='dmpl__PerformInventoryPosting__c';
    private static final string FIELD_SALERETURN_RESOURCEID = 'dmpl__ResourceId__c';

    private static final List<String> LIST_NON_EDITABLE_FIELDS = new List<String>{FIELD_SALERETURN_ACCOUNTID, FIELD_SALERETURN_PARTNERACCOUNTID, FIELD_SALERETURN_BRANCHID, FIELD_SALERETURN_DOCUMENTDATE};
    private static final List<String> LIST_FIELDS_SOURCEPOULATED = new List<String>{FIELD_SALERETURN_PARTNERACCOUNTID, FIELD_SALERETURN_BRANCHID,FIELD_SALERETURN_ACCOUNTID};
    private static final List<String> LIST_FIELDS_SYSTEM = new List<String>{FIELD_SALERETURN_GLID, FIELD_SALERETURN_ISGLPOSTED, FIELD_SALERETURN_ISGLPOSTINGAPPROVED};
    
    public static void validateData(Boolean isInsert, Boolean isUpdate, Boolean isDelete, List<dmpl__SaleReturn__c> newEntries, List<dmpl__SaleReturn__c> oldEntries)
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
                StatusHelper.validateStatusNew(OBJECT_SALERETURN, FIELD_SALERETURN_STATUS, newEntries);
                ValidationHelper.validateResource(
                    FIELD_SALERETURN_RESOURCEID, 
                    newEntries);
            }else if(isUpdate){
                StatusHelper.validateStatusEdit(OBJECT_SALERETURN, FIELD_SALERETURN_STATUS, oldEntries, newEntries);
                DocumentHelper.validateChangeInSystemFields(LIST_FIELDS_SYSTEM, oldEntries, newEntries);
                DocumentHelper.validateChangeInKeyFields(LIST_NON_EDITABLE_FIELDS, oldEntries, newEntries,queryTransactedObjectIds(newEntries));
                dfsHelper.DocumentStatusRestrictEdits_Edit(OBJECT_SALERETURN, FIELD_SALERETURN_STATUS, oldEntries, newEntries);
                dfsHelper.DocumentStatusRestrictFieldsEdits(OBJECT_SALERETURN, FIELD_SALERETURN_STATUS, oldEntries, newEntries);
                ValidationHelper.validateResource(
                    FIELD_SALERETURN_RESOURCEID, 
                    newEntries);
            }else if(isDelete){
                dfsHelper.DocumentStatusRestrictEdits_Delete(OBJECT_SALERETURN, FIELD_SALERETURN_STATUS, oldEntries);
            }
        }catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }

    public static void postData(Boolean isInsert, Boolean isUpdate, Boolean isDelete, List<dmpl__SaleReturn__c> newEntries, List<dmpl__SaleReturn__c> oldEntries)
    {
        if(isInsert)
        {
    		DocumentNameHelper.generateDocumentName(newEntries);
            PriceListHelper.setDefaultPriceListIds(newEntries);
        }
        
        if(isUpdate)
        {
            List<dmpl__SaleReturn__c> modifiedObjects = DocumentHelper.getApprovedObjects(FIELD_SALERETURN_PERFORMRETURN, oldEntries, newEntries);
            if(modifiedObjects.size() > 0)
                performReturn(modifiedObjects);

            List<dmpl__SaleReturn__c> modifiedObjectsGL = DocumentHelper.getApprovedObjects(FIELD_SALERETURN_PERFORMGLPOSTING, oldEntries, newEntries);
            if(modifiedObjectsGL.size()>0){
                PostGL(modifiedObjectsGL);
            }

            List<dmpl__SaleReturn__c> modifiedObjectsIL = DocumentHelper.getApprovedObjects(FIELD_SALERETURN_PERFORMILPOSTING, oldEntries, newEntries);
            if(modifiedObjectsIL.size()>0){
                PostIL(modifiedObjectsIL);
            }
            RoundOffHelper.setRoundOff(
                    newEntries,
                    'dmpl__LineSubTotal__c',
                    'dmpl__TotalTaxAmount2__c');
        }
    }

    public static void createSaleReturnFromSaleInvoice(List<dmpl__SaleInvoice__c> saleInvoices){
        createSaleReturnFromSaleInvoiceInternal(querySaleInvoiceLines(DocumentHelper.extractIds(saleInvoices), null), null);
    }
    
    public static CreateRelatedResult createSaleReturnFromSaleInvoice(Id saleInvoiceId){
        return CreateRelatedResult.InitFrom(createSaleReturnFromSaleInvoiceInternal(querySaleInvoiceLines(New List<Id>{saleInvoiceId}, null), null));
    }
    
    public static CreateRelatedResult createSaleReturnFromSaleInvoice(List<SourceObjectInfo> invoiceLinesInfo, Id saleReturnId){
        return CreateRelatedResult.InitFrom(
            createSaleReturnLinesFromSaleInvoiceInternal(
                querySaleInvoiceLines(
                    (List<Id>)null, 
                    SourceObjectInfo.extractIds(invoiceLinesInfo)), 
                invoiceLinesInfo, saleReturnId));
    }

    public static void createSaleReturnFromDelivery(List<dmpl__DeliveryOrder__c> deliveryOrders){
        createSaleReturnFromDeliveryInternal(queryDeliveryLines(DocumentHelper.extractIds(deliveryOrders), null), null);
    }
    
    public static CreateRelatedResult createSaleReturnFromDelivery(Id deliveryId){
        return CreateRelatedResult.InitFrom(createSaleReturnFromDeliveryInternal(queryDeliveryLines(New List<Id>{deliveryId}, null), null));
    }
    
    public static CreateRelatedResult createSaleReturnFromDelivery(List<SourceObjectInfo> deliveryLinesInfo, Id saleReturnId){
        return CreateRelatedResult.InitFrom(
            createSaleReturnLinesFromDeliveryInternal(
                queryDeliveryLines(
                    (List<Id>)null, 
                    SourceObjectInfo.extractIds(deliveryLinesInfo)), 
                    deliveryLinesInfo, saleReturnId));
    }

    public static void afterPostData(Boolean isInsert, Boolean isUpdate, Boolean isDelete, List<dmpl__SaleReturn__c> newEntries, List<dmpl__SaleReturn__c> oldEntries)
    {
    }

    private static void PostGL(List<dmpl__SaleReturn__c> returns)
    {
        SecurityHelper.ensureCanWriteField('dmpl__IsGLPostingApproved__c', 'dmpl__SaleReturn__c');
        SecurityHelper.ensureCanWriteField('dmpl__PerformGLPosting__c', 'dmpl__SaleReturn__c');
        for(dmpl__SaleReturn__c document : returns){
            document.dmpl__IsGLPostingApproved__c = true;
            document.dmpl__PerformGLPosting__c = false;
        }
        SaleReturnLineHelper.approveSaleReturnLines(returns);
        //SaleReturnTaxHelper.approveSaleTaxLines(returns);
    }

    public static CreateRelatedResult postIL(Id hostId){
        return SaleReturnLineHelper.postIL(hostId);
    }

    public static CreateRelatedResult postIL(List<SourceObjectInfo> childObjectsInfo, Id hostId){
        return SaleReturnLineHelper.postIL(childObjectsInfo, hostId);
    }
    
    private static void PostIL(List<dmpl__SaleReturn__c> saleReturns)
    {
        SaleReturnLineHelper.postReturnLineInternal(saleReturns);
        //SaleReturnLineHelper.postReturnLines(modifiedDocuments);
        SecurityHelper.ensureCanWriteField('dmpl__PerformInventoryPosting__c', 'dmpl__SaleReturn__c');
       // SecurityHelper.ensureCanWriteField('dmpl__IsInventoryPosted__c', 'dmpl__SaleReturn__c');
        for(dmpl__SaleReturn__c document : saleReturns){
            document.dmpl__PerformInventoryPosting__c = false;
        }
    }
   
    private static void performReturn(List<dmpl__SaleReturn__c> modifiedObjects){
        // SaleOrderLineHelper.updateSaleReturnQuantity(modifiedObjects);
        // SaleInvoiceLineHelper.updateSaleReturnQuantity(modifiedObjects);
        SecurityHelper.ensureCanWriteField('dmpl__PerformReturn__c', 'dmpl__SaleReturn__c');
        SecurityHelper.ensureCanWriteField('dmpl__IsReturned__c', 'dmpl__SaleReturn__c');
        for(dmpl__SaleReturn__c lineEntry : modifiedObjects){
            lineEntry.dmpl__PerformReturn__c = false;
            lineEntry.dmpl__IsReturned__c = true;
	        }
    }

    @TestVisible
    private static Map<Id, dmpl__SaleReturn__c> createSaleReturnFromSaleInvoiceInternal(
        List<dmpl__SaleInvoiceLine__c> saleInvoiceLines,
        List<SourceObjectInfo> invoiceLineInfo){
        if(saleInvoiceLines.size() == 0){
            throw new DMPLException(
                String.format(
                    String.valueOf(System.Label.Generic_EmptyActionParam), 
                    new String[]{
                        dmpl__SaleInvoiceLine__c.class.getName()}));
        }

        Map<Id, dmpl__SaleReturn__c> saleReturns = new Map<Id,dmpl__SaleReturn__c>();
        Map<Id, List<dmpl__SaleReturnLine__c>> saleReturnLines = new Map<Id, List<dmpl__SaleReturnLine__c>>();
       
        for(dmpl__SaleInvoiceLine__c saleInvoiceLine : saleInvoiceLines){
            if(saleInvoiceLine.dmpl__EligibleReturnQuantity__c>0){

                dmpl__SaleReturn__c returnDocument = null;
                if(saleReturns.containsKey(saleInvoiceLine.dmpl__SaleInvoiceId__c)){
                    returnDocument = saleReturns.get(saleInvoiceLine.dmpl__SaleInvoiceId__c);
                }else {
                    returnDocument = createReturnDocumentFromSaleInvoice(saleInvoiceLine);
                    saleReturns.put(
                        saleInvoiceLine.dmpl__SaleInvoiceId__c, 
                        returnDocument);
                        saleReturnLines.put(
                        saleInvoiceLine.dmpl__SaleInvoiceId__c, 
                        new List<dmpl__SaleReturnLine__c>());
                }
        
                saleReturnLines.get(
                    saleInvoiceLine.dmpl__SaleInvoiceId__c).add(
                        createReturnLineFromSaleInvoiceLine(
                            saleInvoiceLine,
                            invoiceLineInfo));
            }
        }
        //
        if(saleReturnLines.size() >0){
            Savepoint sp = Database.setSavepoint();
            try {
                SecurityHelper.ensureCanCreateObject('dmpl__SaleReturn__c');
                SecurityHelper.ensureCanCreateFields(new string[]
                {
                    'dmpl__SaleInvoiceId__c',
                    'dmpl__BranchId__c',
                    'dmpl__PartnerAccountId__c',
                    'dmpl__DocumentDate__c',
                    'dmpl__AccountId__c'
                }, 'dmpl__SaleReturn__c');

                insert saleReturns.values();
                List<dmpl__SaleReturnLine__c> linesToInsert = new List<dmpl__SaleReturnLine__c>();
                for(Id soId : saleReturns.keySet()){
                    dmpl__SaleReturn__c saleReturn = saleReturns.get(soId);
                    List<dmpl__SaleReturnLine__c> docLines = saleReturnLines.get(soId);
                    for(dmpl__SaleReturnLine__c returnLine : docLines){
                        returnLine.dmpl__SaleReturnId__c = saleReturn.Id;
                        linesToInsert.add(returnLine);
                    }    
                }
                
                SecurityHelper.ensureCanCreateObject('dmpl__SaleReturnLine__c');
                SecurityHelper.ensureCanCreateFields(new string[]
                {
                    'dmpl__SaleReturnId__c',
                    'dmpl__ItemId__c',
                    'dmpl__SKUId__c',
                    'dmpl__Quantity__c'
                }, 'dmpl__SaleReturnLine__c');

                insert linesToInsert;
            } catch (Exception e) {
                Database.rollback(sp);
                throw e;
            }
        }

        return saleReturns;
    }

    @TestVisible
    private static Map<Id, dmpl__SaleReturn__c> createSaleReturnFromDeliveryInternal(
        List<dmpl__DeliveryOrderLine__c> deliveryLines,
        List<SourceObjectInfo> deliveryLineInfo){
        if(deliveryLines.size() == 0){
            throw new DMPLException(
                String.format(
                    String.valueOf(System.Label.Generic_EmptyActionParam), 
                    new String[]{
                        dmpl__DeliveryOrderLine__c.class.getName()}));
        }

        Map<Id, dmpl__SaleReturn__c> saleReturns = new Map<Id,dmpl__SaleReturn__c>();
        Map<Id, List<dmpl__SaleReturnLine__c>> saleReturnLines = new Map<Id, List<dmpl__SaleReturnLine__c>>();
       
        for(dmpl__DeliveryOrderLine__c deliveryLine : deliveryLines){
            if(deliveryLine.dmpl__EligibleReturnQuantity__c>0){

                dmpl__SaleReturn__c returnDocument = null;
                if(saleReturns.containsKey(deliveryLine.dmpl__DeliveryId__c)){
                    returnDocument = saleReturns.get(deliveryLine.dmpl__DeliveryId__c);
                }else {
                    returnDocument = createReturnDocumentFromDelivery(deliveryLine);
                    saleReturns.put(
                        deliveryLine.dmpl__DeliveryId__c, 
                        returnDocument);
                        saleReturnLines.put(
                        deliveryLine.dmpl__DeliveryId__c, 
                        new List<dmpl__SaleReturnLine__c>());
                }
        
                saleReturnLines.get(
                    deliveryLine.dmpl__DeliveryId__c).add(
                        createReturnLineFromDeliveryLine(
                            deliveryLine,
                            deliveryLineInfo));
            }
        }
        //
        if(saleReturnLines.size() >0){
            Savepoint sp = Database.setSavepoint();
            try {
                SecurityHelper.ensureCanCreateObject('dmpl__SaleReturn__c');
                SecurityHelper.ensureCanCreateFields(new string[]
                {
                    'dmpl__DeliveryOrderId__c',
                    'dmpl__BranchId__c',
                    'dmpl__PartnerAccountId__c',
                    'dmpl__DocumentDate__c',
                    'dmpl__AccountId__c'
                }, 'dmpl__SaleReturn__c');

                insert saleReturns.values();
                List<dmpl__SaleReturnLine__c> linesToInsert = new List<dmpl__SaleReturnLine__c>();
                for(Id soId : saleReturns.keySet()){
                    dmpl__SaleReturn__c saleReturn = saleReturns.get(soId);
                    List<dmpl__SaleReturnLine__c> docLines = saleReturnLines.get(soId);
                    for(dmpl__SaleReturnLine__c returnLine : docLines){
                        returnLine.dmpl__SaleReturnId__c = saleReturn.Id;
                        linesToInsert.add(returnLine);
                    }    
                }
                
                SecurityHelper.ensureCanCreateObject('dmpl__SaleReturnLine__c');
                SecurityHelper.ensureCanCreateFields(new string[]
                {
                    'dmpl__SaleReturnId__c',
                    'dmpl__ItemId__c',
                    'dmpl__SKUId__c',
                    'dmpl__Quantity__c'
                }, 'dmpl__SaleReturnLine__c');

                insert linesToInsert;
            } catch (Exception e) {
                Database.rollback(sp);
                throw e;
            }
        }

        return saleReturns;
    }

    @TestVisible
    private static Map<Id, dmpl__SaleReturnLine__c> createSaleReturnLinesFromSaleInvoiceInternal(
        List<dmpl__SaleInvoiceLine__c> saleInvoiceLines,
        List<SourceObjectInfo> invoiceLineInfo, Id saleReturnId){
        if(saleInvoiceLines.size() == 0){
            throw new DMPLException(
                String.format(
                    String.valueOf(System.Label.Generic_EmptyActionParam), 
                    new String[]{
                        dmpl__SaleInvoiceLine__c.class.getName()}));
        }

        List<dmpl__SaleReturnLine__c> saleReturnLines = new List<dmpl__SaleReturnLine__c>();
        for(dmpl__SaleInvoiceLine__c saleInvoiceLine : saleInvoiceLines){
            if(saleInvoiceLine.dmpl__EligibleReturnQuantity__c>0){
                    saleReturnLines.add(
                        createReturnLineFromSaleInvoiceLine(
                            saleInvoiceLine,
                            invoiceLineInfo));
            }
        }
        //
        if(saleReturnLines.size() >0){
            Savepoint sp = Database.setSavepoint();
            try {
                for(dmpl__SaleReturnLine__c returnLine : saleReturnLines){
                        returnLine.dmpl__SaleReturnId__c = saleReturnId;
                }    
                
                SecurityHelper.ensureCanCreateObject('dmpl__SaleReturnLine__c');
                SecurityHelper.ensureCanCreateFields(new string[]
                {
                    'dmpl__SaleReturnId__c',
                    'dmpl__ItemId__c',
                    'dmpl__SKUId__c',
                    'dmpl__Quantity__c'
                }, 'dmpl__SaleReturnLine__c');

                insert saleReturnLines;
            } catch (Exception e) {
                Database.rollback(sp);
                throw e;
            }
        }

        return new Map<Id, dmpl__SaleReturnLine__c>(saleReturnLines);
    }

    @TestVisible
    private static Map<Id, dmpl__SaleReturnLine__c> createSaleReturnLinesFromDeliveryInternal(
        List<dmpl__DeliveryOrderLine__c> deliveryOrderLines,
        List<SourceObjectInfo> deliveryLineInfo, Id saleReturnId){
        if(deliveryOrderLines.size() == 0){
            throw new DMPLException(
                String.format(
                    String.valueOf(System.Label.Generic_EmptyActionParam), 
                    new String[]{
                        dmpl__DeliveryOrderLine__c.class.getName()}));
        }

        List<dmpl__SaleReturnLine__c> saleReturnLines = new List<dmpl__SaleReturnLine__c>();
        for(dmpl__DeliveryOrderLine__c deliveryOrderLine : deliveryOrderLines){
            if(deliveryOrderLine.dmpl__EligibleReturnQuantity__c>0){
                    saleReturnLines.add(
                        createReturnLineFromDeliveryLine(
                            deliveryOrderLine,
                            deliveryLineInfo));
            }
        }
        //
        if(saleReturnLines.size() >0){
            Savepoint sp = Database.setSavepoint();
            try {
                for(dmpl__SaleReturnLine__c returnLine : saleReturnLines){
                        returnLine.dmpl__SaleReturnId__c = saleReturnId;
                }    
                
                SecurityHelper.ensureCanCreateObject('dmpl__SaleReturnLine__c');
                SecurityHelper.ensureCanCreateFields(new string[]
                {
                    'dmpl__SaleReturnId__c',
                    'dmpl__ItemId__c',
                    'dmpl__SKUId__c',
                    'dmpl__Quantity__c'
                }, 'dmpl__SaleReturnLine__c');

                insert saleReturnLines;
            } catch (Exception e) {
                Database.rollback(sp);
                throw e;
            }
        }

        return new Map<Id, dmpl__SaleReturnLine__c>(saleReturnLines);
    }

    private static dmpl__SaleReturn__c createReturnDocumentFromSaleInvoice(dmpl__SaleInvoiceLine__c saleInvoiceLine){
        return new dmpl__SaleReturn__c(
            dmpl__BranchId__c = saleInvoiceLine.dmpl__SaleInvoiceId__r.dmpl__BranchId__c,
            dmpl__PartnerAccountId__c = saleInvoiceLine.dmpl__SaleInvoiceId__r.dmpl__PartnerAccountId__c,
            dmpl__DocumentDate__c = saleInvoiceLine.dmpl__SaleInvoiceId__r.dmpl__DocumentDate__c,
            dmpl__AccountId__c = saleInvoiceLine.dmpl__SaleInvoiceId__r.dmpl__AccountId__c,
            dmpl__PriceListId__c = saleInvoiceLine.dmpl__SaleInvoiceId__r.dmpl__PriceListId__c,
            dmpl__GLAccountId__c = saleInvoiceLine.dmpl__SaleInvoiceId__r.dmpl__GLAccountId__c,
            dmpl__GeneralLedgerId__c = saleInvoiceLine.dmpl__SaleInvoiceId__r.dmpl__GeneralLedgerId__c,
            dmpl__DiscountGroupId__c = saleInvoiceLine.dmpl__SaleInvoiceId__r.dmpl__DiscountGroupId__c	
        );
    }

    private static dmpl__SaleReturn__c createReturnDocumentFromDelivery(dmpl__DeliveryOrderLine__c deliveryOrderLine){
        return new dmpl__SaleReturn__c(
            dmpl__BranchId__c = deliveryOrderLine.dmpl__DeliveryId__r.dmpl__BranchId__c,
            dmpl__PartnerAccountId__c = deliveryOrderLine.dmpl__DeliveryId__r.dmpl__PartnerAccountId__c,
            dmpl__DocumentDate__c = deliveryOrderLine.dmpl__DeliveryId__r.dmpl__DocumentDate__c,
            dmpl__AccountId__c = deliveryOrderLine.dmpl__DeliveryId__r.dmpl__AccountId__c,
            dmpl__PriceListId__c = deliveryOrderLine.dmpl__DeliveryId__r.dmpl__PriceListId__c,
            dmpl__DiscountGroupId__c = deliveryOrderLine.dmpl__DeliveryId__r.dmpl__DiscountGroupId__c	
        );
    }
@testVisible
    private static dmpl__SaleReturnLine__c createReturnLineFromSaleInvoiceLine(
        dmpl__SaleInvoiceLine__c saleInvoiceLine,
        List<SourceObjectInfo> invoiceLinesInfo){
        Decimal requestedQty = SourceObjectInfo.getRequestedQuantity(invoiceLinesInfo, saleInvoiceLine.Id);
        return new dmpl__SaleReturnLine__c(
            dmpl__SaleInvoiceLineId__c = saleInvoiceLine.Id,
            dmpl__ItemId__c = saleInvoiceLine.dmpl__ItemId__c,
            dmpl__SKUId__c = saleInvoiceLine.dmpl__SKUId__c,
            dmpl__AssetId__c = saleInvoiceLine.dmpl__AssetId__c,
            dmpl__Discount__c = saleInvoiceLine.dmpl__Discount__c,
            dmpl__Discount2__c = saleInvoiceLine.dmpl__Discount2__c,
            dmpl__DiscountAmount__c = saleInvoiceLine.dmpl__DiscountAmount__c,
            dmpl__DiscountAmount2__c = saleInvoiceLine.dmpl__DiscountAmount2__c,
            dmpl__ContractDiscount__c = saleInvoiceLine.dmpl__ContractDiscount__c,
            dmpl__ContractDiscountAmount__c = saleInvoiceLine.dmpl__ContractDiscountAmount__c,
            dmpl__GeneralLedgerId__c = saleInvoiceLine.dmpl__GeneralLedgerId__c,
            dmpl__GLAccountId__c = saleInvoiceLine.dmpl__GLAccountId__c,
            dmpl__InventoryLedgerId__c = saleInvoiceLine.dmpl__InventoryLedgerId__c,
            dmpl__ItemLotId__c = saleInvoiceLine.dmpl__ItemLotId__c,
            dmpl__SaleOrderLineId__c = saleInvoiceLine.dmpl__SaleOrderLineId__c,
            dmpl__SchemeDiscount__c = saleInvoiceLine.dmpl__SchemeDiscount__c,
            dmpl__SchemeDiscountAmount__c = saleInvoiceLine.dmpl__SchemeDiscountAmount__c,
            dmpl__SchemeRewardPoints__c = saleInvoiceLine.dmpl__SchemeRewardPoints__c,
            dmpl__StorageLocationId__c = saleInvoiceLine.dmpl__StorageLocationId__c,
            dmpl__TaxAmount__c = saleInvoiceLine.dmpl__TaxAmount__c,
            dmpl__TaxGroupId__c = saleInvoiceLine.dmpl__TaxGroupId__c,
            dmpl__UnitPrice__c = saleInvoiceLine.dmpl__UnitPrice__c,
            dmpl__UnitPrice2__c = saleInvoiceLine.dmpl__UnitPrice2__c,
            dmpl__RepairOrderLineId__c = saleInvoiceLine.dmpl__RepairOrderLineId__c,
            dmpl__SaleInvoiceId__c = saleInvoiceLine.dmpl__SaleInvoiceId__c,
            dmpl__SchemeLineId__c = saleInvoiceLine.dmpl__SchemeLineId__c,
            dmpl__Quantity__c = requestedQty >0 ? requestedQty : saleInvoiceLine.dmpl__EligibleReturnQuantity__c
        );
    }
@testVisible
    private static dmpl__SaleReturnLine__c createReturnLineFromDeliveryLine(
        dmpl__DeliveryOrderLine__c deliveryOrderLine,
        List<SourceObjectInfo> deliveryLinesInfo){
        Decimal requestedQty = SourceObjectInfo.getRequestedQuantity(deliveryLinesInfo, deliveryOrderLine.Id);
        return new dmpl__SaleReturnLine__c(
            dmpl__DeliveryOrderLineId__c = deliveryOrderLine.Id,
            dmpl__ItemId__c = deliveryOrderLine.dmpl__ItemId__c,
            dmpl__SKUId__c = deliveryOrderLine.dmpl__SKUId__c,
            dmpl__AssetId__c = deliveryOrderLine.dmpl__AssetId__c,
            dmpl__Discount__c = deliveryOrderLine.dmpl__Discount__c,
            dmpl__DiscountAmount__c = deliveryOrderLine.dmpl__DiscountAmount__c,
            dmpl__Discount2__c = deliveryOrderLine.dmpl__Discount2__c,
            dmpl__DiscountAmount2__c = deliveryOrderLine.dmpl__DiscountAmount2__c,
            dmpl__ContractDiscount__c = deliveryOrderLine.dmpl__ContractDiscount__c,
            dmpl__ContractDiscountAmount__c = deliveryOrderLine.dmpl__ContractDiscountAmount__c,
            dmpl__InventoryLedgerId__c = deliveryOrderLine.dmpl__InventoryLedgerId__c,
            dmpl__ItemLotId__c = deliveryOrderLine.dmpl__ItemLotId__c,
            dmpl__SaleOrderLineId__c = deliveryOrderLine.dmpl__SaleOrderLineId__c,
            dmpl__StorageLocationId__c = deliveryOrderLine.dmpl__StorageLocationId__c,
            dmpl__TaxAmount__c = deliveryOrderLine.dmpl__TaxAmount__c,
            dmpl__TaxGroupId__c = deliveryOrderLine.dmpl__TaxGroupId__c,
            dmpl__UnitPrice__c = deliveryOrderLine.dmpl__UnitPrice__c,
            dmpl__SaleInvoiceLineId__c = deliveryOrderLine.dmpl__SaleInvoiceLineId__c,
            dmpl__Quantity__c = requestedQty >0 ? requestedQty : deliveryOrderLine.dmpl__EligibleReturnQuantity__c
        );
    }

    private static List<Id> queryTransactedObjectIds(List<dmpl__SaleReturn__c> newEntries){
        SecurityHelper.ensureCanReadFields(new string[]{'dmpl__SaleReturnId__c'}, 'dmpl__SaleReturnLine__c');
        return DocumentHelper.extractIds([SELECT dmpl__SaleReturnId__c 
                FROM dmpl__SaleReturnLine__c
                WHERE dmpl__SaleReturnId__c IN:DocumentHelper.extractIds(newEntries)], FIELD_SALERETURNLINE_SALERETURNID);
    }
@testVisible
    private static List<dmpl__DeliveryOrderLine__c> queryDeliveryLines(List<Id> deliveryIds, List<Id> deliveryLineIds)
    {
        if(deliveryIds == null){
            deliveryIds = new List<Id>();
        }

        if(deliveryLineIds == null){
            deliveryLineIds = new List<Id>();
        }

        SecurityHelper.ensureCanReadFields(new string[]{
            'dmpl__PartnerAccountId__c',
            'dmpl__BranchId__c',
            'dmpl__AccountId__c',
            'dmpl__PriceListId__c',
            'dmpl__DocumentDate__c',
            'dmpl__DiscountGroupId__c'},
            'dmpl__DeliveryOrder__c');
        SecurityHelper.ensureCanReadFields(new string[]{
            'dmpl__ItemId__c',
            'dmpl__SKUId__c',
            'dmpl__UnitPrice__c',
            'dmpl__UnitPrice2__c',
            'dmpl__Quantity__c',
            'dmpl__TaxGroupId__c',
            'dmpl__TaxAmount__c',
            'dmpl__EligibleReturnQuantity__c', 
            'dmpl__Discount__c', 
            'dmpl__DiscountAmount__c', 
            'dmpl__InventoryLedgerId__c',
            'dmpl__ItemLotId__c',
            'dmpl__PriceListRuleId__c',
            'dmpl__SaleInvoiceId__c',
            'dmpl__DeliveryId__c',
            'dmpl__StorageLocationId__c',
            'dmpl__SaleOrderLineId__c'}, 
            'dmpl__DeliveryOrderLine__c');

        return [SELECT Id,
            Name,
            dmpl__ItemId__c,
            dmpl__SKUId__c,
            dmpl__UnitPrice__c,
            dmpl__UnitPrice2__c,
            dmpl__Quantity__c,
            dmpl__EligibleReturnQuantity__c,
            dmpl__TaxGroupId__c,
            dmpl__TaxAmount__c,
            dmpl__SaleOrderLineId__c,
            dmpl__DeliveryId__r.dmpl__PartnerAccountId__c,
            dmpl__DeliveryId__r.dmpl__BranchId__c,
            dmpl__DeliveryId__r.dmpl__AccountId__c,
            dmpl__DeliveryId__r.dmpl__DocumentDate__c,
            dmpl__DeliveryId__r.dmpl__DiscountGroupId__c,
            dmpl__DeliveryId__r.dmpl__PriceListId__c,
            dmpl__Discount__c,
            dmpl__DiscountAmount__c,
            dmpl__Discount2__c,
            dmpl__DiscountAmount2__c,
            dmpl__ContractDiscount__c,
            dmpl__ContractDiscountAmount__c,
            dmpl__InventoryLedgerId__c,
            dmpl__ItemLotId__c,
            dmpl__PriceListRuleId__c,
            // dmpl__SaleInvoiceId__c,
            dmpl__SaleInvoiceLineId__c,
            dmpl__DeliveryId__c,
            dmpl__StorageLocationId__c,
            dmpl__AssetId__c
        FROM dmpl__DeliveryOrderLine__c
        WHERE dmpl__DeliveryId__c IN :deliveryIds OR Id IN :deliveryLineIds
        ];
    }
@testVisible
    private static List<dmpl__SaleInvoiceLine__c> querySaleInvoiceLines(List<Id> saleInvoiceIds, List<Id> saleInvoiceLineIds)
    {
        if(saleInvoiceIds == null){
            saleInvoiceIds = new List<Id>();
        }

        if(saleInvoiceLineIds == null){
            saleInvoiceLineIds = new List<Id>();
        }

        SecurityHelper.ensureCanReadFields(new string[]{
            'dmpl__PartnerAccountId__c',
            'dmpl__BranchId__c',
            'dmpl__AccountId__c',
            'dmpl__PriceListId__c',
            'dmpl__DocumentDate__c',
            'dmpl__GLAccountId__c',
            'dmpl__GeneralLedgerId__c',
            'dmpl__DiscountGroupId__c'},
            'dmpl__SaleInvoice__c');
        SecurityHelper.ensureCanReadFields(new string[]{
            'dmpl__ItemId__c',
            'dmpl__SKUId__c',
            'dmpl__UnitPrice__c',
            'dmpl__UnitPrice2__c',
            'dmpl__Quantity__c',
            'dmpl__TaxGroupId__c',
            'dmpl__TaxAmount__c',
            'dmpl__EligibleReturnQuantity__c', 
            'dmpl__Discount__c', 
            'dmpl__Discount2__c', 
            'dmpl__DiscountAmount__c', 
            'dmpl__DiscountAmount2__c', 
            'dmpl__GLAccountId__c',
            'dmpl__InventoryLedgerId__c',
            'dmpl__ItemLotId__c',
            'dmpl__PriceListRuleId__c',
            'dmpl__RepairOrderLineId__c',
            'dmpl__SaleInvoiceId__c',
            'dmpl__SchemeDiscount__c',
            'dmpl__SchemeDiscountAmount__c',
            'dmpl__SchemeRewardPoints__c',
            'dmpl__SchemeLineId__c',
            'dmpl__StorageLocationId__c',
            'dmpl__SaleOrderLineId__c'}, 
            'dmpl__SaleInvoiceLine__c');

        return [SELECT Id,
            Name,
            dmpl__ItemId__c,
            dmpl__SKUId__c,
            dmpl__UnitPrice__c,
            dmpl__UnitPrice2__c,
            dmpl__Quantity__c,
            dmpl__EligibleReturnQuantity__c,
            dmpl__TaxGroupId__c,
            dmpl__TaxAmount__c,
            dmpl__SaleOrderLineId__c,
            dmpl__SaleInvoiceId__r.dmpl__PartnerAccountId__c,
            dmpl__SaleInvoiceId__r.dmpl__BranchId__c,
            dmpl__SaleInvoiceId__r.dmpl__AccountId__c,
            dmpl__SaleInvoiceId__r.dmpl__DocumentDate__c,
            dmpl__SaleInvoiceId__r.dmpl__DiscountGroupId__c,
            dmpl__SaleInvoiceId__r.dmpl__PriceListId__c,
            dmpl__SaleInvoiceId__r.dmpl__GeneralLedgerId__c,
            dmpl__SaleInvoiceId__r.dmpl__GLAccountId__c,
            dmpl__Discount__c,
            dmpl__Discount2__c,
            dmpl__DiscountAmount__c,
            dmpl__DiscountAmount2__c,
            dmpl__ContractDiscount__c,
            dmpl__ContractDiscountAmount__c,
            dmpl__GLAccountId__c,
            dmpl__InventoryLedgerId__c,
            dmpl__ItemLotId__c,
            dmpl__PriceListRuleId__c,
            dmpl__RepairOrderLineId__c,
            dmpl__SaleInvoiceId__c,
            dmpl__SchemeDiscount__c,
            dmpl__SchemeDiscountAmount__c,
            dmpl__SchemeRewardPoints__c,
            dmpl__SchemeLineId__c,
            dmpl__StorageLocationId__c,
            dmpl__AssetId__c,
            dmpl__GeneralLedgerId__c
        FROM dmpl__SaleInvoiceLine__c
        WHERE dmpl__SaleInvoiceId__c IN :saleInvoiceIds OR Id IN :saleInvoiceLineIds
        ];
    }
}