public with sharing class PurchaseRequisitionLineHelper {
    
    private static Boolean skipValidations = false;

    private static final string OBJECT_PURCHASEREQUISITION = 'dmpl__PurchaseRequisition__c';
    private static final string OBJECT_PURCHASEREQUISITIONLINE = 'dmpl__PurchaseRequisitionLine__c';
    private static final string FIELD_REQUISITION_ID = 'dmpl__PurchaseRequisitionId__c';
    
    private static final string FIELD_REQUISITIONLINE_ORDERQUANTITY = 'dmpl__PurchaseOrderQuantity__c';
    private static final string FIELD_REQUISITIONLINE_ITEMID = 'dmpl__ItemId__c';
    private static final string FIELD_REQUISITIONLINE_SKUID = 'dmpl__SKUId__c';
    private static final string FIELD_REQUISITIONLINE_QUANTITY = 'dmpl__Quantity__c';
    private static final string FIELD_REQUISITIONLINE_AMOUNT = 'dmpl__Amount__c';

    private static final string RELATION_PURCHASEORDER_STATUS = 'dmpl__PurchaseRequisitionId__r.dmpl__Status__c';

    private static final List<String> LIST_FIELDS_NONEDITABLE = new List<String>{};
    private static final List<String> LIST_FIELDS_SYSTEM = new List<String>{ FIELD_REQUISITIONLINE_ORDERQUANTITY};
    private static final List<String> LIST_FIELDS_LOCKEDIFTRANSACTED = new List<String>{FIELD_REQUISITIONLINE_ITEMID,FIELD_REQUISITIONLINE_SKUID};

    public static void validateData(Boolean isInsert, Boolean isDelete, Boolean isUpdate, List<dmpl__PurchaseRequisitionLine__c> oldEntries, List<dmpl__PurchaseRequisitionLine__c> newEntries)
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
            validateItem(newEntries);
            DocumentHelper.validateChangeInSystemFields(LIST_FIELDS_SYSTEM, newEntries);
            dfsHelper.DocumentStatusRelatedObjectRestrictEdits_New(OBJECT_PURCHASEREQUISITION, OBJECT_PURCHASEREQUISITIONLINE, RELATION_PURCHASEORDER_STATUS, newEntries);
        }else if(isUpdate){
            DocumentHelper.validateChangeInSystemFields(LIST_FIELDS_SYSTEM, oldEntries, newEntries);
            DocumentHelper.validateChangeInKeyFields(LIST_FIELDS_NONEDITABLE, oldEntries, newEntries);
            dfsHelper.DocumentStatusRelatedObjectRestrictEdits_Edit(OBJECT_PURCHASEREQUISITION, OBJECT_PURCHASEREQUISITIONLINE, RELATION_PURCHASEORDER_STATUS, oldEntries, newEntries);
            validateChangeInQuantity(oldEntries, newEntries);
        }else if(isDelete){
            DocumentHelper.validateCanBeDeleted(oldEntries, FIELD_REQUISITIONLINE_ORDERQUANTITY);
            dfsHelper.DocumentStatusRelatedObjectRestrictEdits_Delete(OBJECT_PURCHASEREQUISITION, OBJECT_PURCHASEREQUISITIONLINE, RELATION_PURCHASEORDER_STATUS, oldEntries);
        }

    } catch (Exception error) {
        ExceptionLogHelper.logException(error);
        throw error;
    }
    }

    public static void updatePurchaseOrderQuantity(List<Id> requisitionLineIds)
    {
        try{
            if(requisitionLineIds.size () == 0 || requisitionLineIds == null)
                return;
            skipValidations = true;

            SecurityHelper.ensureCanReadFields(new string[]{'dmpl__PurchaseRequisitionLineId__c','dmpl__Quantity__c'}, 'dmpl__PurchaseOrderLine__c');
            List<AggregateResult> orderAggregates = 
                [SELECT dmpl__PurchaseRequisitionLineId__c RequisitionLineId, SUM(dmpl__Quantity__c) TotalOrderQuantity
                FROM dmpl__PurchaseOrderLine__c
                WHERE dmpl__PurchaseRequisitionLineId__c IN :requisitionLineIds
                WITH SECURITY_ENFORCED
                GROUP BY dmpl__PurchaseRequisitionLineId__c];

            SecurityHelper.ensureCanReadFields(new string[]{'dmpl__PurchaseOrderQuantity__c'}, 'dmpl__PurchaseRequisitionLine__c');
            List<dmpl__PurchaseRequisitionLine__c> requisitionLinesToUpdate = 
                [SELECT Id, dmpl__PurchaseOrderQuantity__c
                FROM dmpl__PurchaseRequisitionLine__c
                WHERE Id IN :requisitionLineIds];
    
            for(dmpl__PurchaseRequisitionLine__c requisitionLine : requisitionLinesToUpdate){
                for(AggregateResult result : orderAggregates){
                    if(result.get('RequisitionLineId') == requisitionLine.Id){
                        requisitionLine.dmpl__PurchaseOrderQuantity__c = result.get('TotalOrderQuantity') ==null ? 0 : (Decimal)(result.get('TotalOrderQuantity'));
                        break;
                    }
                }
            }

            SecurityHelper.ensureCanWriteFields(new string[]{'dmpl__PurchaseOrderQuantity__c'}, 'dmpl__PurchaseRequisitionLine__c');
            Update requisitionLinesToUpdate;
        }finally{
            skipValidations = false;
        }
    }

    public static void updateTransferQuantity(
        List<Id> requisitionLineIds){
            try{
                skipValidations = true;
                SecurityHelper.ensureCanReadFields(new string[]{
                    'dmpl__RequisitionLineId__c',
                    'dmpl__Quantity__c'
                }, 'dmpl__TransferOutwardLine__c');
                List<AggregateResult> orderAggregates = 
                    [SELECT dmpl__RequisitionLineId__c RequisitionLineId, SUM(dmpl__Quantity__c) TotalOrderQuantity
                    FROM dmpl__TransferOutwardLine__c
                    WHERE dmpl__RequisitionLineId__c IN :requisitionLineIds
                    WITH SECURITY_ENFORCED
                    GROUP BY dmpl__RequisitionLineId__c];

                List<dmpl__PurchaseRequisitionLine__c> requisitionLinesToUpdate = 
                    [SELECT Id, dmpl__StockTransferQuantity__c
                    FROM dmpl__PurchaseRequisitionLine__c
                    WHERE Id IN :requisitionLineIds];
        
                for(dmpl__PurchaseRequisitionLine__c requisitionLine : requisitionLinesToUpdate){
                    for(AggregateResult result : orderAggregates){
                        if(result.get('RequisitionLineId') == requisitionLine.Id){
                            requisitionLine.dmpl__StockTransferQuantity__c = result.get('TotalOrderQuantity') ==null ? 0 : (Decimal)(result.get('TotalOrderQuantity'));
                            break;
                        }
                    }
                }

                SecurityHelper.ensureCanWriteFields(new string[]{
                    'dmpl__StockTransferQuantity__c'
                }, 'dmpl__PurchaseRequisitionLine__c');
                Update requisitionLinesToUpdate;
            }finally{
                skipValidations = false;
            }
    }

    @testVisible
    private static void validateItem(List<dmpl__PurchaseRequisitionLine__c> newEntries){
        Map<Id, dmpl__Item__c> items = new Map<Id,dmpl__Item__c>(ItemHelper.getCachedItems(DocumentHelper.extractIds(newEntries, FIELD_REQUISITIONLINE_ITEMID)));
        for(dmpl__PurchaseRequisitionLine__c orderLine : newEntries){
            dmpl__Item__c item = items.get(orderLine.dmpl__ItemId__c);
            if(orderLine.dmpl__SKUId__c == null && item!=null && item.dmpl__IsSKURequired__c){
                orderLine.addError(System.Label.Validation_SKURequired);
            }
            if(orderLine.dmpl__SKUId__c != null){
                dmpl__SKU__c sku = (dmpl__SKU__c)CollectionHelper.getObject(item.dmpl__SKUs__r, orderLine.dmpl__SKUId__c);
                if(sku ==null){
                    orderLine.addError(System.Label.Validation_SKUInvalid);
                }
            }
        }
    }

    @testVisible
    private static void validateChangeInQuantity(List<dmpl__PurchaseRequisitionLine__c> oldEntries, List<dmpl__PurchaseRequisitionLine__c> newEntries){
        Map<Id, dmpl__PurchaseRequisitionLine__c> oldObjectsMap = new Map<Id, dmpl__PurchaseRequisitionLine__c>(oldEntries);
        for(dmpl__PurchaseRequisitionLine__c lineEntry : newEntries){
            dmpl__PurchaseRequisitionLine__c oldEntry = oldObjectsMap.get(lineEntry.Id);
            if(oldEntry != null){
                if(oldEntry.dmpl__Quantity__c != lineEntry.dmpl__Quantity__c) {
                    Double transactedQty = 0;
                    if(oldEntry.dmpl__PurchaseOrderQuantity__c!=null){
                        transactedQty +=oldEntry.dmpl__PurchaseOrderQuantity__c;
                    }
                    if(lineEntry.dmpl__Quantity__c < transactedQty){
                        lineEntry.addError(String.format(
                            String.valueOf(System.Label.IntegrityFailed_TransactedQuantityCanNotBeReduced), 
                            new String[]{String.valueOf(transactedQty)})); 
                    }
                } 
            }   
        }
    }
}