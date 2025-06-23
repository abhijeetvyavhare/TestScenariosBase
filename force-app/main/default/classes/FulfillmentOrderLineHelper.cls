public with sharing class FulfillmentOrderLineHelper {
    private static Boolean skipValidations = false;

    private static final string OBJECT_FULFILMENTORDER = 'dmpl__SaleOrder__c';
    private static final string OBJECT_FULFILMENTORDERLINE = 'dmpl__SaleOrderLine__c';
    private static final string FIELD_FULFILMENTORDERLINE_SALEORDERID = 'dmpl__SaleOrderId__c';
    private static final string FIELD_FULFILMENTORDERLINE_ITEMID = 'dmpl__ItemId__c';
    private static final string FIELD_FULFILMENTORDERLINE_ITEMLOTID = 'dmpl__ItemLotId__c';
    private static final string FIELD_FULFILMENTORDERLINE_SKUID = 'dmpl__SKUId__c';
    private static final string FIELD_FULFILMENTORDERLINE_ALLOCATEDQUANTITY = 'dmpl__AllocatedQuantity__c';
    private static final string FIELD_FULFILMENTORDERLINE_BACKORDERQUANTITY = 'dmpl__BackOrderQuantity__c';
    private static final string FIELD_FULFILMENTORDERLINE_CANCELLEDQUANTITY = 'dmpl__CancelledQuantity__c';
    private static final string FIELD_FULFILMENTORDERLINE_INVENTORYLEDGERID = 'dmpl__InventoryLedgerId__c';
    private static final string FIELD_FULFILMENTORDERLINE_ISILPOSTED = 'dmpl__IsILPosted__c';
    private static final string FIELD_FULFILMENTORDERLINE_ISILPOSTINGAPPROVED = 'dmpl__IsILPostingApproved__c';
    private static final string FIELD_FULFILMENTORDERLINE_QUANTITY = 'dmpl__Quantity__c';
    private static final string FIELD_FULFILMENTORDERLINE_REPAIRORDERLINEID = 'dmpl__RepairOrderLineId__c';
    private static final string FIELD_FULFILMENTORDERLINE_SALEORDERLINEID = 'dmpl__SaleOrderLineId__c';

    private static final string FIELD_AGG_FULFILLMENTORDERLINEID = 'FulfillmentOrderLineId';
    private static final string FIELD_AGG_TOTALQTY = 'TotalQuantity';

    private static final string RELATION_FULFILMENTORDER_STATUS = 'dmpl__FulfillmentId__r.dmpl__Status__c';

    private static final List<String> LIST_FIELDS_NONEDITABLE = new List<String>{
        FIELD_FULFILMENTORDERLINE_SALEORDERLINEID, 
        FIELD_FULFILMENTORDERLINE_REPAIRORDERLINEID};
    private static final List<String> LIST_FIELDS_SYSTEM = new List<String>{
        FIELD_FULFILMENTORDERLINE_ALLOCATEDQUANTITY,
        FIELD_FULFILMENTORDERLINE_BACKORDERQUANTITY, 
        FIELD_FULFILMENTORDERLINE_INVENTORYLEDGERID};
    private static final List<String> LIST_FIELDS_SOURCEPOULATED = new List<String>{
        FIELD_FULFILMENTORDERLINE_ITEMID,
        FIELD_FULFILMENTORDERLINE_ITEMLOTID,
        FIELD_FULFILMENTORDERLINE_SKUID};
    private static final List<String> LIST_FIELDS_LOCKEDIFTRANSACTED = new List<String>{
        FIELD_FULFILMENTORDERLINE_ITEMID,
        FIELD_FULFILMENTORDERLINE_ITEMLOTID,
        FIELD_FULFILMENTORDERLINE_SKUID,
        FIELD_FULFILMENTORDERLINE_SALEORDERLINEID, 
        FIELD_FULFILMENTORDERLINE_REPAIRORDERLINEID};

    private static final List<String> LIST_FIELDS_NEGATIVEANDZERONOTALLOWED = new List<String>{
        FIELD_FULFILMENTORDERLINE_QUANTITY
    };
    
    private static final List<String> LIST_FIELDS_NEGATIVENOTALLOWED = new List<String>{
        FIELD_FULFILMENTORDERLINE_BACKORDERQUANTITY,
        FIELD_FULFILMENTORDERLINE_CANCELLEDQUANTITY
    };

    public static void validateData(
        Boolean isInsert, 
        Boolean isDelete, 
        Boolean isUpdate, 
        List<dmpl__InventoryFulfillmentOrderLine__c> oldEntries, 
        List<dmpl__InventoryFulfillmentOrderLine__c> newEntries)
    {
        try{
            if(isInsert || isUpdate){
                if(isInsert){
                    FieldMappingHelper.copyFieldMappingData(
                        newEntries);
                }    
                ValidationHelper.validatePostiveDecimal(
                    LIST_FIELDS_NEGATIVEANDZERONOTALLOWED,
                    newEntries);
                ValidationHelper.validatePostiveOrZeroDecimal(
                    LIST_FIELDS_NEGATIVENOTALLOWED,
                    newEntries);
            }
            if(skipValidations){
                return;
            }
            if(isInsert){
                validateItem(newEntries);
                DocumentHelper.validateChangeInSystemFields(
                    LIST_FIELDS_SYSTEM, 
                    newEntries);
                (new DocumentStatusDFSHelper()).DocumentStatusRelatedObjectRestrictEdits_New(
                    OBJECT_FULFILMENTORDER, 
                    OBJECT_FULFILMENTORDERLINE, 
                    RELATION_FULFILMENTORDER_STATUS, 
                    newEntries);
            }else if(isUpdate){
                DocumentHelper.validateChangeInSystemFields(
                    LIST_FIELDS_SYSTEM, 
                    oldEntries, 
                    newEntries);
                DocumentHelper.validateChangeInKeyFields(
                    LIST_FIELDS_NONEDITABLE, 
                    oldEntries, 
                    newEntries);
                DocumentHelper.validateChangeInSourcePopulatedFields(
                    LIST_FIELDS_SOURCEPOULATED, 
                    oldEntries, 
                    newEntries, 
                    FIELD_FULFILMENTORDERLINE_SALEORDERLINEID);
                DocumentHelper.validateChangeInLockedIfTransactedFields(
                    LIST_FIELDS_LOCKEDIFTRANSACTED, 
                    oldEntries, 
                    newEntries, 
                    FIELD_FULFILMENTORDERLINE_ALLOCATEDQUANTITY);
                (new DocumentStatusDFSHelper()).DocumentStatusRelatedObjectRestrictEdits_Edit(
                    OBJECT_FULFILMENTORDER, 
                    OBJECT_FULFILMENTORDERLINE, 
                    RELATION_FULFILMENTORDER_STATUS, 
                    oldEntries, 
                    newEntries);
                validateChangeInQuantity(
                    oldEntries, 
                    newEntries);
            }else if(isDelete){
                DocumentHelper.validateCanBeDeleted(
                    oldEntries, 
                    FIELD_FULFILMENTORDERLINE_ALLOCATEDQUANTITY);
                (new DocumentStatusDFSHelper()).DocumentStatusRelatedObjectRestrictEdits_Delete(
                    OBJECT_FULFILMENTORDER, 
                    OBJECT_FULFILMENTORDERLINE, 
                    RELATION_FULFILMENTORDER_STATUS, 
                    oldEntries);
            }
        } catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }

    public static void postData(
        Boolean isInsert, 
        Boolean isDelete, 
        Boolean isUpdate, 
        List<dmpl__InventoryFulfillmentOrderLine__c> oldEntries, 
        List<dmpl__InventoryFulfillmentOrderLine__c> newEntries){
        try{
            if(isInsert){
                InventoryStockHelper.setStock(newEntries);
            }else if(isDelete){
                return;
            }
        } catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }

    public static void afterPostData(
        Boolean isInsert, 
        Boolean isDelete, 
        Boolean isUpdate, 
        List<dmpl__InventoryFulfillmentOrderLine__c> oldEntries, 
        List<dmpl__InventoryFulfillmentOrderLine__c> newEntries){
        try{
            if(isDelete){
                List<dmpl__InventoryFulfillmentOrderLine__c> newObjects = DocumentHelper.getObjectsWithNotNull(
                    oldEntries, 
                    FIELD_FULFILMENTORDERLINE_SALEORDERLINEID);
                if(newObjects.size() > 0)
                    SaleOrderLineHelper.updateFulfilmentOrderQuantity(
                        DocumentHelper.extractIds(
                            oldEntries, 
                            FIELD_FULFILMENTORDERLINE_SALEORDERLINEID));

                newObjects = DocumentHelper.getObjectsWithNotNull(
                    oldEntries, 
                    FIELD_FULFILMENTORDERLINE_REPAIRORDERLINEID);
                if(newObjects.size() > 0)
                {
                    RepairOrderLineHelper.updateFulfilmentOrderQuantity(
                        DocumentHelper.extractIds(
                            oldEntries, 
                            FIELD_FULFILMENTORDERLINE_REPAIRORDERLINEID));
                    RepairOrderLineHelper.updateAllocatedQuantity(
                        DocumentHelper.extractIds(
                            oldEntries, 
                            FIELD_FULFILMENTORDERLINE_REPAIRORDERLINEID));
                }
            }else if(isInsert){
                List<dmpl__InventoryFulfillmentOrderLine__c> newObjects = DocumentHelper.getObjectsWithNotNull(
                    newEntries, 
                    FIELD_FULFILMENTORDERLINE_SALEORDERLINEID);
                if(newObjects.size() > 0)
                    SaleOrderLineHelper.updateFulfilmentOrderQuantity(
                        DocumentHelper.extractIds(
                            newEntries, 
                            FIELD_FULFILMENTORDERLINE_SALEORDERLINEID));

                newObjects = DocumentHelper.getObjectsWithNotNull(
                    newEntries, 
                    FIELD_FULFILMENTORDERLINE_REPAIRORDERLINEID);
                if(newObjects.size() > 0){
                    RepairOrderLineHelper.updateFulfilmentOrderQuantity(
                        DocumentHelper.extractIds(
                            newEntries, 
                            FIELD_FULFILMENTORDERLINE_REPAIRORDERLINEID));
                    RepairOrderLineHelper.updateAllocatedQuantity(
                        DocumentHelper.extractIds(
                            newEntries, 
                            FIELD_FULFILMENTORDERLINE_REPAIRORDERLINEID));
                }

            }else if(isUpdate){
                List<Id> modifiedObjects = DocumentHelper.getModifiedNewObjectIds(
                    FIELD_FULFILMENTORDERLINE_QUANTITY, 
                    FIELD_FULFILMENTORDERLINE_SALEORDERLINEID, 
                    oldEntries, 
                    newEntries);
                if(modifiedObjects.size()>0){
                    SaleOrderLineHelper.updateFulfilmentOrderQuantity(
                        modifiedObjects);
                }

                modifiedObjects = DocumentHelper.getModifiedNewObjectIds(
                    FIELD_FULFILMENTORDERLINE_QUANTITY, 
                    FIELD_FULFILMENTORDERLINE_REPAIRORDERLINEID, 
                    oldEntries, 
                    newEntries);
                if(modifiedObjects.size()>0){
                    RepairOrderLineHelper.updateFulfilmentOrderQuantity(
                        modifiedObjects);
                }

                modifiedObjects = DocumentHelper.getModifiedNewObjectIds(
                    FIELD_FULFILMENTORDERLINE_ALLOCATEDQUANTITY, 
                    FIELD_FULFILMENTORDERLINE_REPAIRORDERLINEID, 
                    oldEntries, 
                    newEntries);
                if(modifiedObjects.size()>0){
                    RepairOrderLineHelper.updateAllocatedQuantity(
                        modifiedObjects);
                }

                modifiedObjects = DocumentHelper.getModifiedNewObjectIds(
                    FIELD_FULFILMENTORDERLINE_ALLOCATEDQUANTITY, 
                    FIELD_FULFILMENTORDERLINE_SALEORDERLINEID, 
                    oldEntries, 
                    newEntries);
                if(modifiedObjects.size()>0){
                    SaleOrderLineHelper.updateFulfilmentAllocatedQuantity(
                        modifiedObjects);
                }
            }
        } catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }

    private static void validateChangeInQuantity(
        List<dmpl__InventoryFulfillmentOrderLine__c> oldEntries, 
        List<dmpl__InventoryFulfillmentOrderLine__c> newEntries){
        Map<Id, dmpl__InventoryFulfillmentOrderLine__c> oldObjectsMap 
            = new Map<Id, dmpl__InventoryFulfillmentOrderLine__c>(oldEntries);
        for(dmpl__InventoryFulfillmentOrderLine__c lineEntry : newEntries){
            dmpl__InventoryFulfillmentOrderLine__c oldEntry = oldObjectsMap.get(lineEntry.Id);
            if(oldEntry != null){
                Double transactedQty = (oldEntry.dmpl__AllocatedQuantity__c==null) ? 0 : oldEntry.dmpl__AllocatedQuantity__c;
                transactedQty += (oldEntry.dmpl__CancelledQuantity__c==null) ? 0 : oldEntry.dmpl__CancelledQuantity__c;
                transactedQty += (oldEntry.dmpl__BackOrderQuantity__c==null) ? 0 : oldEntry.dmpl__BackOrderQuantity__c;
                if(oldEntry.dmpl__Quantity__c != lineEntry.dmpl__Quantity__c && lineEntry.dmpl__Quantity__c!=null
                    && lineEntry.dmpl__Quantity__c < transactedQty) {
                    lineEntry.addError(String.format(
                        String.valueOf(System.Label.IntegrityFailed_TransactedQuantityCanNotBeReduced), 
                        new String[]{String.valueOf(transactedQty)})); 
                } 
            }   
        }
    }

    public static void updateFulfillmentAllocatedQuantity(List<Id> fulfillmentOrderLineIds){
        try{
            skipValidations = true;
            SecurityHelper.ensureCanReadFields(new string[]{'dmpl__FulfillmentOrderLineId__c','dmpl__Quantity__c'}, 'dmpl__InventoryFulfillmentAllocationLine__c');
            List<AggregateResult> ffAggregates = 
                [SELECT dmpl__FulfillmentOrderLineId__c FulfillmentOrderLineId, SUM(dmpl__Quantity__c) TotalQuantity
                FROM dmpl__InventoryFulfillmentAllocationLine__c
                WHERE dmpl__FulfillmentOrderLineId__c IN :fulfillmentOrderLineIds
                WITH SECURITY_ENFORCED
                GROUP BY dmpl__FulfillmentOrderLineId__c];

            SecurityHelper.ensureCanReadFields(new string[]{'dmpl__AllocatedQuantity__c'}, 'dmpl__InventoryFulfillmentOrderLine__c');
            List<dmpl__InventoryFulfillmentOrderLine__c> orderLinesToUpdate = 
                [SELECT Id, dmpl__AllocatedQuantity__c
                FROM dmpl__InventoryFulfillmentOrderLine__c
                WHERE Id IN :fulfillmentOrderLineIds];
    
            for(dmpl__InventoryFulfillmentOrderLine__c orderLine : orderLinesToUpdate){
                for(AggregateResult result : ffAggregates){
                    if(result.get(FIELD_AGG_FULFILLMENTORDERLINEID) == orderLine.Id){
                        orderLine.dmpl__AllocatedQuantity__c = result.get(FIELD_AGG_TOTALQTY) ==null ? 0 : (Decimal)(result.get(FIELD_AGG_TOTALQTY));
                        break;
                    }
                }
            }

            SecurityHelper.ensureCanWriteFields(new string[]{'dmpl__AllocatedQuantity__c'}, 'dmpl__InventoryFulfillmentOrderLine__c');
            Update orderLinesToUpdate;
        }finally{
            skipValidations = false;
        }
    }

    public static void updatePurchaseOrderQuantity(List<Id> purchaseOrderLineIds)
    {
        try{
            if(purchaseOrderLineIds.size () == 0 || purchaseOrderLineIds == null)
                return;
            skipValidations = true;

            SecurityHelper.ensureCanReadFields(new string[]{'dmpl__FulfillmentOrderLineId__c','dmpl__Quantity__c'}, 'dmpl__InventoryFulfillmentAllocationLine__c');
            List<AggregateResult> ffAggregates = 
                [SELECT dmpl__FulfillmentOrderLineId__c FulfillmentOrderLineId, SUM(dmpl__Quantity__c) TotalQuantity
                FROM dmpl__PurchaseOrderLine__c
                WHERE dmpl__FulfillmentOrderLineId__c IN :purchaseOrderLineIds
                WITH SECURITY_ENFORCED
                GROUP BY dmpl__FulfillmentOrderLineId__c];

            SecurityHelper.ensureCanReadFields(new string[]{'dmpl__BackOrderQuantity__c'}, 'dmpl__InventoryFulfillmentOrderLine__c');
            List<dmpl__InventoryFulfillmentOrderLine__c> orderLinesToUpdate = 
                [SELECT Id, dmpl__BackOrderQuantity__c
                FROM dmpl__InventoryFulfillmentOrderLine__c
                WHERE Id IN :purchaseOrderLineIds];
    
            for(dmpl__InventoryFulfillmentOrderLine__c orderLine : orderLinesToUpdate){
                for(AggregateResult result : ffAggregates){
                    if(result.get(FIELD_AGG_FULFILLMENTORDERLINEID) == orderLine.Id){
                        orderLine.dmpl__BackOrderQuantity__c = result.get(FIELD_AGG_TOTALQTY) ==null ? 0 : (Decimal)(result.get(FIELD_AGG_TOTALQTY));
                        break;
                    }
                }
            }

            SecurityHelper.ensureCanWriteFields(new string[]{'dmpl__BackOrderQuantity__c'}, 'dmpl__InventoryFulfillmentOrderLine__c');
            Update orderLinesToUpdate;
        }finally{
            skipValidations = false;
        }
    }

    private static void validateItem(List<dmpl__InventoryFulfillmentOrderLine__c> newEntries){
        Map<Id, dmpl__Item__c> items = new Map<Id,dmpl__Item__c>(ItemHelper.getCachedItems(DocumentHelper.extractIds(newEntries, FIELD_FULFILMENTORDERLINE_ITEMID)));
        for(dmpl__InventoryFulfillmentOrderLine__c orderLine : newEntries){
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

    private static List<dmpl__InventoryFulfillment__c> queryFulfillments(List<Id> fulfillmentIds)
    {
        SecurityHelper.ensureCanReadFields(new string[]
        {
            'dmpl__RepairOrderId__c'
        }, 'dmpl__InventoryFulfillment__c');
        SecurityHelper.ensureCanReadFields(new string[]
        {
           'dmpl__ItemId__c',
           'dmpl__RepairOrderLineId__c,'
       }, 'dmpl__InventoryFulfillmentOrderLine__c');
        return [SELECT Id,
        Name,
        dmpl__RepairOrderId__c,
        (
            SELECT Id,
            Name,
            dmpl__ItemId__c,
            dmpl__RepairOrderLineId__c
            FROM FulfillmentOrderLines__r
        )
        FROM dmpl__InventoryFulfillment__c
        WHERE ID In : fulfillmentIds];
    }


}