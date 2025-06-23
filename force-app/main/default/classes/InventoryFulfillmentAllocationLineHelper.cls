public with sharing class InventoryFulfillmentAllocationLineHelper {

    private static Boolean skipValidations = false;

    private static final string FIELD_INVENTORYALLOCATIONLINE_ITEMID = 'dmpl__ItemId__c';
    private static final string FIELD_INVENTORYALLOCATIONLINE_SKUID = 'dmpl__SKUId__c';
    private static final string FIELD_INVENTORYALLOCATIONLINE_ITEMLOTTYPEID = 'dmpl__ItemLotTypeId__c';
    private static final string FIELD_FULFILLMENTALLOCATIONLINE_QUANTITY = 'dmpl__Quantity__c';
    private static final string FIELD_FULFILMENTALLOCATIONLINE_INVENTORYLEDGERID = 'dmpl__InventoryLedgerId__c';
    private static final string FIELD_FULFILMENTALLOCATIONLINE_ITEMLOTID = 'dmpl__ItemLotId__c';
    private static final string OBJECT_FULFILLMENT = 'dmpl__InventoryFulfillment__c';
    private static final string OBJECT_FULFILLMENTALLOCATIONLINE = 'dmpl__InventoryFulfillmentAllocationLine__c';
    private static final string RELATION_FULFILLMENT_STATUS = 'dmpl__FulfillmentId__r.dmpl__Status__c';
    private static final string FIELD_INVENTORYALLOCATION_ORDERLINE_ID = 'dmpl__FulfillmentOrderLineId__c';
    private static final string FIELD_INVENTORYALLOCATION_PARENTLINE_ID = 'dmpl__ParentFulfillmentAllocationLineId__c';
    private static final string FIELD_AGG_ALLOCATIONLINEID = 'AllocationLineId';
    private static final string FIELD_AGG_TOTALQTY = 'TotalQuantity';
    private static final string FIELD_INVENTORYALLOCATION_INVOICEQUANTITY = 'dmpl__InvoiceQuantity__c';

    private static final List<String> LIST_FIELDS_NONEDITABLE = new List<String>{
        FIELD_INVENTORYALLOCATION_ORDERLINE_ID
    };
    private static final List<String> LIST_FIELDS_SYSTEM = new List<String>{
        FIELD_FULFILMENTALLOCATIONLINE_INVENTORYLEDGERID,
        FIELD_INVENTORYALLOCATION_INVOICEQUANTITY
    };
    private static final List<String> LIST_FIELDS_SOURCEPOULATED = new List<String>{
        FIELD_INVENTORYALLOCATIONLINE_ITEMID,
        FIELD_FULFILMENTALLOCATIONLINE_ITEMLOTID,
        FIELD_INVENTORYALLOCATIONLINE_SKUID
    };
    private static final List<String> LIST_FIELDS_LOCKEDIFTRANSACTED = new List<String>{
        FIELD_INVENTORYALLOCATIONLINE_SKUID,
        FIELD_FULFILMENTALLOCATIONLINE_ITEMLOTID,
        FIELD_INVENTORYALLOCATIONLINE_SKUID,
        FIELD_INVENTORYALLOCATION_ORDERLINE_ID
    };

    private static final List<String> LIST_FIELDS_NEGATIVENOTALLOWED = new List<String>{
        'dmpl__DeliveredInvoicedQuantity__c',
        'dmpl__DeliveryQuantity__c',
        'dmpl__DeliveryReturnQuantity__c',
        'dmpl__InvoiceQuantity__c',
        'dmpl__PendingDeliveryQuantity__c',
        'dmpl__PendingInvoiceQuantity__c',
        'dmpl__PendingPickingQuantity__c',
        'dmpl__PickedDeliveredQuantity__c',
        'dmpl__PickedInvoiceQuantity__c',
        'dmpl__PickedQuantity__c',
        'dmpl__PickingCancelQuantity__c',
        'dmpl__PickingRequestedQuantity__c',
        'dmpl__PickingReturnQuantity__c',
        'dmpl__ReturnedQuantity__c',
        'dmpl__EligibleReturnQuantity__c'
    };

    private static final List<String> LIST_FIELDS_ZERONOTALLOWED = new List<String>{
        'dmpl__Quantity__c'
    };//,'dmpl__AllocatedQuantity__c'

    public static void validateData(Boolean isInsert, Boolean isUpdate, Boolean isDelete, List<dmpl__InventoryFulfillmentAllocationLine__c> newEntries, List<dmpl__InventoryFulfillmentAllocationLine__c> oldEntries)
    {   
        try{
            if(isInsert || isUpdate){
                if(isInsert){
                    FieldMappingHelper.copyFieldMappingData(
                        newEntries);
                }
                ValidationHelper.validateNonZeroDecimal(
                    LIST_FIELDS_ZERONOTALLOWED,
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
                    OBJECT_FULFILLMENT, 
                    OBJECT_FULFILLMENTALLOCATIONLINE, 
                    RELATION_FULFILLMENT_STATUS, 
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
                    FIELD_INVENTORYALLOCATION_ORDERLINE_ID);
                DocumentHelper.validateChangeInLockedIfTransactedFields(
                    LIST_FIELDS_LOCKEDIFTRANSACTED, 
                    oldEntries, 
                    newEntries, 
                    FIELD_FULFILLMENTALLOCATIONLINE_QUANTITY);
                (new DocumentStatusDFSHelper()).DocumentStatusRelatedObjectRestrictEdits_Edit(
                    OBJECT_FULFILLMENT, 
                    OBJECT_FULFILLMENTALLOCATIONLINE, 
                    RELATION_FULFILLMENT_STATUS, 
                    oldEntries, 
                    newEntries);
            }else if(isDelete){
                DocumentHelper.validateCanBeDeleted(
                    oldEntries, 
                    FIELD_FULFILLMENTALLOCATIONLINE_QUANTITY);
                (new DocumentStatusDFSHelper()).DocumentStatusRelatedObjectRestrictEdits_Delete(
                    OBJECT_FULFILLMENT, 
                    OBJECT_FULFILLMENTALLOCATIONLINE, 
                    RELATION_FULFILLMENT_STATUS, 
                    oldEntries);
            }
    } catch (Exception error) {
        ExceptionLogHelper.logException(error);
        throw error;
    }

    }

    public  static void postData(
        Boolean isInsert, 
        Boolean isUpdate, 
        Boolean isDelete, 
        List<dmpl__InventoryFulfillmentAllocationLine__c> newEntries, 
        List<dmpl__InventoryFulfillmentAllocationLine__c> oldEntries){    
        InventoryLedgerHelper.createLedger(
            InventoryLedgerTypeEnums.Allocation, 
            'dmpl__FulfillmentOrderId__c', 
            'dmpl__InventoryFulfillment__c', 
            isInsert, 
            isDelete, 
            isUpdate, 
            oldEntries, 
            newEntries);
    }

    public static void afterPostData(
        Boolean isInsert, 
        Boolean isUpdate, 
        Boolean isDelete, 
        List<dmpl__InventoryFulfillmentAllocationLine__c> newEntries, 
        List<dmpl__InventoryFulfillmentAllocationLine__c> oldEntries){
        try{
        if(isDelete){
            FulfillmentOrderLineHelper.updateFulfillmentAllocatedQuantity(
                DocumentHelper.extractIds(
                    oldEntries, 
                    FIELD_INVENTORYALLOCATION_ORDERLINE_ID));
        }else if(isInsert){
            FulfillmentOrderLineHelper.updateFulfillmentAllocatedQuantity(
                DocumentHelper.extractIds(
                    newEntries, 
                    FIELD_INVENTORYALLOCATION_ORDERLINE_ID));
            UpdateAllocationReturnQuantity(DocumentHelper.extractIds(
                newEntries, 
                FIELD_INVENTORYALLOCATION_PARENTLINE_ID));
        }else if(isUpdate){
            List<Id> modifiedObjectIds = DocumentHelper.getModifiedNewObjectIds(
                FIELD_FULFILLMENTALLOCATIONLINE_QUANTITY, 
                FIELD_INVENTORYALLOCATION_ORDERLINE_ID, 
                oldEntries, 
                newEntries);
            if(modifiedObjectIds.size()>0){
                FulfillmentOrderLineHelper.updateFulfillmentAllocatedQuantity(
                    modifiedObjectIds);
            }
        }
    } catch (Exception error) {
        ExceptionLogHelper.logException(error);
        throw error;
    }

    }

    public static void createAllocationFromFulfillment(
        List<dmpl__InventoryFulfillment__c> inventoryFulfillments){
        createAllocation(
            queryOrderLinesForAllocation(
                DocumentHelper.extractIds(
                    inventoryFulfillments), 
                null), 
                null);
    }

    public static CreateRelatedResult createAllocationFromFulfillment(
        List<SourceObjectInfo> orderLinesInfo){
        return CreateRelatedResult.InitFrom(
            createAllocation(
                queryOrderLinesForAllocation(
                    null, 
                    SourceObjectInfo.extractIds(orderLinesInfo)),
                    orderLinesInfo));
    }

    public static CreateRelatedResult createAllocationFromFulfillment(
        Id inventoryFulfillmentId){
        return CreateRelatedResult.InitFrom(
            createAllocation(
                queryOrderLinesForAllocation(
                    New List<Id>{ 
                        inventoryFulfillmentId 
                    }, 
                null), 
            null));
    }

    public static void createAllocationFromGoodsReceipt(
        List<dmpl__GoodsReceiptLine__c> goodsReceiptLines){
        createAllocation(queryOrderLinesForAllocation(
            new List<Id>(), 
            getFulfillmentOrderLineIds(
                goodsReceiptLines)), 
            null);
    }
   
    public static CreateRelatedResult cancelAllocationFromFulfillment(
        Id inventoryFulfillmentId){
        return cancelAllocation(
            queryAllocationLines(
                new List<Id>{inventoryFulfillmentId}, 
                null),
            null);
    }

    public static CreateRelatedResult cancelAllocationFromFulfillment(
        List<dmpl__InventoryFulfillment__c> inventoryFulfillments){
        return cancelAllocation(
            queryAllocationLines(
                DocumentHelper.extractIds(
                    inventoryFulfillments), 
                    null),
            null);
    }

    public static CreateRelatedResult cancelAllocationFromFulfillment(
        List<SourceObjectInfo> orderLinesInfo){
        return cancelAllocation(
            queryAllocationLines(
                null, 
                SourceObjectInfo.extractIds(
                    orderLinesInfo)),
            orderLinesInfo);
    }

    public static void updateFulfillmentPickedQuantity(
        List<Id> fulfillmentAllocationLineIds){
        try{
            skipValidations = true;
            SecurityHelper.ensureCanReadFields(new string[]{
                'dmpl__FulfillmentAllocationLineId__c',
                'dmpl__Quantity__c',
                'dmpl__CancelQuantity__c',
                'dmpl__ReturnedQuantity__c',
                'dmpl__RequestedQuantity__c'
            }, 'dmpl__InventoryFulfillmentPickingLine__c');
            List<AggregateResult> ffAggregates = 
                [SELECT 
                    dmpl__FulfillmentAllocationLineId__c FulfillmentAllocationLineId, 
                    SUM(dmpl__Quantity__c) TotalQuantity,
                    SUM(dmpl__CancelQuantity__c) TotalCancelQuantity,
                    SUM(dmpl__ReturnedQuantity__c) TotalReturnQuantity,
                    SUM(dmpl__RequestedQuantity__c) TotalRequestedQuantity
                FROM 
                    dmpl__InventoryFulfillmentPickingLine__c
                WHERE 
                    dmpl__FulfillmentAllocationLineId__c IN :fulfillmentAllocationLineIds
                    AND dmpl__Quantity__c >0
                WITH SECURITY_ENFORCED
                GROUP BY dmpl__FulfillmentAllocationLineId__c];

            SecurityHelper.ensureCanReadFields(new string[]{
                'dmpl__PickedQuantity__c',
                'dmpl__PickingRequestedQuantity__c',
                'dmpl__PickingCancelQuantity__c',
                'dmpl__PickingReturnQuantity__c'
            }, 'dmpl__InventoryFulfillmentAllocationLine__c');
            List<dmpl__InventoryFulfillmentAllocationLine__c> orderLinesToUpdate = 
                [SELECT 
                    Id, 
                    dmpl__PickedQuantity__c,
                    dmpl__PickingRequestedQuantity__c,
                    dmpl__PickingCancelQuantity__c,
                    dmpl__PickingReturnQuantity__c
                FROM 
                    dmpl__InventoryFulfillmentAllocationLine__c
                WHERE 
                    Id IN :fulfillmentAllocationLineIds];
    
            for(dmpl__InventoryFulfillmentAllocationLine__c orderLine : orderLinesToUpdate){
                orderLine.dmpl__PickedQuantity__c = 0;
                orderLine.dmpl__PickingRequestedQuantity__c = 0;
                orderLine.dmpl__PickingCancelQuantity__c = 0;
                orderLine.dmpl__PickingReturnQuantity__c = 0;
                for(AggregateResult result : ffAggregates){
                    if(result.get('FulfillmentAllocationLineId') == orderLine.Id){
                        orderLine.dmpl__PickedQuantity__c = result.get(FIELD_AGG_TOTALQTY) ==null ? 
                        0 : (Decimal)(result.get(FIELD_AGG_TOTALQTY));

                        orderLine.dmpl__PickingRequestedQuantity__c = result.get('TotalRequestedQuantity') ==null ? 
                        0 : (Decimal)(result.get('TotalRequestedQuantity'));

                        orderLine.dmpl__PickingCancelQuantity__c = result.get('TotalCancelQuantity') ==null ? 
                        0 : (Decimal)(result.get('TotalCancelQuantity'));
                        
                        orderLine.dmpl__PickingReturnQuantity__c = result.get('TotalReturnQuantity') ==null ? 
                        0 : (Decimal)(result.get('TotalReturnQuantity'));
                        break;
                    }
                }
            }

            SecurityHelper.ensureCanWriteFields(new string[]{
                'dmpl__PickedQuantity__c',
                'dmpl__PickingRequestedQuantity__c'
            }, 'dmpl__InventoryFulfillmentAllocationLine__c');
            Update orderLinesToUpdate;
        }finally{
            skipValidations = false;
        }
    }

    public static void updateAllocationReturnQuantity(
        List<Id> allocationLineIds){
        try{
            if(allocationLineIds.Size() == 0)
                return;
            skipValidations = true;
           
            SecurityHelper.ensureCanReadFields(new string[]{'dmpl__InventoryFulfillmentAllocationLine__c','dmpl__Quantity__c'}, 'dmpl__InventoryFulfillmentAllocationLine__c');
            List<AggregateResult> ffAggregates = 
                [SELECT dmpl__ParentFulfillmentAllocationLineId__c AllocationLineId, SUM(dmpl__Quantity__c) TotalQuantity
                FROM dmpl__InventoryFulfillmentAllocationLine__c
                WHERE dmpl__ParentFulfillmentAllocationLineId__c IN :allocationLineIds
                WITH SECURITY_ENFORCED
                GROUP BY dmpl__ParentFulfillmentAllocationLineId__c];

            SecurityHelper.ensureCanReadFields(new string[]{'dmpl__ReturnedQuantity__c'}, 'dmpl__InventoryFulfillmentAllocationLine__c');
            List<dmpl__InventoryFulfillmentAllocationLine__c> allocationLinesToUpdate = 
                [SELECT Id, dmpl__ReturnedQuantity__c
                FROM dmpl__InventoryFulfillmentAllocationLine__c
                WHERE Id IN :allocationLineIds];
    
            for(dmpl__InventoryFulfillmentAllocationLine__c allocationLine : allocationLinesToUpdate){
                for(AggregateResult result : ffAggregates){
                    if(result.get(FIELD_AGG_ALLOCATIONLINEID) == allocationLine.Id){
                        allocationLine.dmpl__ReturnedQuantity__c = result.get(FIELD_AGG_TOTALQTY) ==null ? 0 : -1 * (Decimal)(result.get(FIELD_AGG_TOTALQTY));
                        break;
                    }
                }
            }
            SecurityHelper.ensureCanWriteFields(new string[]{'dmpl__ReturnedQuantity__c'}, 'dmpl__InventoryFulfillmentAllocationLine__c');
            Update allocationLinesToUpdate;
        }finally{
            skipValidations = false;
        }
    }

    public static void updateSaleInvoiceQuantity(List<Id> allocationLineIds)
    {
        try{
            if(allocationLineIds.Size() == 0)
                return;
            skipValidations = true;
           
            SecurityHelper.ensureCanReadFields(new string[]{'dmpl__FulfillmentAllocationLineId__c','dmpl__Quantity__c'}, 'dmpl__SaleInvoiceLine__c');
            List<AggregateResult> ffAggregates = 
                [SELECT 
                    dmpl__FulfillmentAllocationLineId__c AllocationLineId, 
                    SUM(dmpl__Quantity__c) TotalQuantity,
                    SUM(dmpl__DeliveredQuantity__c) TotalDeliveredQuantity,
                    SUM(dmpl__PickedQuantity__c) TotalPickedQuantity
                FROM dmpl__SaleInvoiceLine__c
                WHERE dmpl__FulfillmentAllocationLineId__c IN :allocationLineIds
                WITH SECURITY_ENFORCED
                GROUP BY dmpl__FulfillmentAllocationLineId__c];

            SecurityHelper.ensureCanReadFields(new string[]{'dmpl__InvoiceQuantity__c'}, 'dmpl__InventoryFulfillmentAllocationLine__c');
            List<dmpl__InventoryFulfillmentAllocationLine__c> allocationLinesToUpdate = 
                [SELECT Id, dmpl__InvoiceQuantity__c
                FROM dmpl__InventoryFulfillmentAllocationLine__c
                WHERE Id IN :allocationLineIds];
    
            for(dmpl__InventoryFulfillmentAllocationLine__c allocationLine : allocationLinesToUpdate){
                for(AggregateResult result : ffAggregates){
                    if(result.get(FIELD_AGG_ALLOCATIONLINEID) == allocationLine.Id){
                        allocationLine.dmpl__PickedInvoiceQuantity__c = result.get('TotalPickedQuantity') ==null ? 0 : (Decimal)(result.get('TotalPickedQuantity'));
                        allocationLine.dmpl__DeliveredInvoicedQuantity__c = result.get('TotalDeliveredQuantity') ==null ? 0 : (Decimal)(result.get('TotalDeliveredQuantity'));
                        allocationLine.dmpl__InvoiceQuantity__c = result.get(FIELD_AGG_TOTALQTY) ==null ? 0 : (Decimal)(result.get(FIELD_AGG_TOTALQTY)) 
                            - allocationLine.dmpl__PickedInvoiceQuantity__c
                            - allocationLine.dmpl__DeliveredInvoicedQuantity__c;
                        
                        break;
                    }
                }
            }
            SecurityHelper.ensureCanWriteFields(new string[]{'dmpl__InvoiceQuantity__c'}, 'dmpl__InventoryFulfillmentAllocationLine__c');
            Update allocationLinesToUpdate;
        }finally{
            skipValidations = false;
        }
    }

    public static void updateSaleDeliveryQuantity(List<Id> allocationLineIds)
    {
        try{
            if(allocationLineIds.Size() == 0)
                return;
            skipValidations = true;
           
            SecurityHelper.ensureCanReadFields(new string[]{'dmpl__FulfillmentAllocationLineId__c','dmpl__Quantity__c'}, 'dmpl__DeliveryOrderLine__c');
            List<AggregateResult> ffAggregates = 
                [SELECT 
                    dmpl__FulfillmentAllocationLineId__c AllocationLineId, 
                    dmpl__FulfillmentPickingLineId__c PickingLineId, 
                    SUM(dmpl__Quantity__c) TotalQuantity,
                    SUM(dmpl__ReturnedQuantity__c) ReturnQuantity
                FROM dmpl__DeliveryOrderLine__c
                WHERE dmpl__FulfillmentAllocationLineId__c IN :allocationLineIds
                GROUP BY dmpl__FulfillmentAllocationLineId__c, dmpl__FulfillmentPickingLineId__c];

            SecurityHelper.ensureCanReadFields(new string[]{'dmpl__DeliveryQuantity__c'}, 'dmpl__InventoryFulfillmentAllocationLine__c');
            List<dmpl__InventoryFulfillmentAllocationLine__c> allocationLinesToUpdate = 
                [SELECT Id, dmpl__DeliveryQuantity__c, dmpl__PickedDeliveredQuantity__c
                FROM dmpl__InventoryFulfillmentAllocationLine__c
                WHERE Id IN :allocationLineIds];
    
            for(dmpl__InventoryFulfillmentAllocationLine__c allocationLine : allocationLinesToUpdate){
                allocationLine.dmpl__PickedDeliveredQuantity__c = 0;
                allocationLine.dmpl__DeliveryQuantity__c = 0;
                for(AggregateResult result : ffAggregates){
                    if(result.get(FIELD_AGG_ALLOCATIONLINEID) == allocationLine.Id){
                        if(result.get('PickingLineId') !=null){
                            allocationLine.dmpl__PickedDeliveredQuantity__c += ((result.get(FIELD_AGG_TOTALQTY) ==null ? 0 : (Decimal)(result.get(FIELD_AGG_TOTALQTY)))
                            - (result.get('ReturnQuantity') ==null ? 0 : (Decimal)(result.get('ReturnQuantity'))));
                        }else{
                            allocationLine.dmpl__DeliveryQuantity__c += ((result.get(FIELD_AGG_TOTALQTY) ==null ? 0 : (Decimal)(result.get(FIELD_AGG_TOTALQTY)))
                                - (result.get('ReturnQuantity') ==null ? 0 : (Decimal)(result.get('ReturnQuantity'))));
                        }
                    }
                }
            }
            SecurityHelper.ensureCanWriteFields(new string[]{'dmpl__DeliveryQuantity__c'}, 'dmpl__InventoryFulfillmentAllocationLine__c');
            Update allocationLinesToUpdate;
        }finally{
            skipValidations = false;
        }
    }

    private static Map<Id, dmpl__InventoryFulfillmentAllocationLine__c> createAllocation(
        List<dmpl__InventoryFulfillmentOrderLine__c> inventoryFulfillmentOrderLines, 
        List<SourceObjectInfo> orderLinesInfo){
        if(inventoryFulfillmentOrderLines.size() == 0){
            throw new DMPLException(String.format(String.valueOf(System.Label.Generic_EmptyActionParam), new String[]{dmpl__InventoryFulfillmentOrderLine__c.class.getName()}));
        }
        List<Id> itemIds = DocumentHelper.extractIds(inventoryFulfillmentOrderLines, FIELD_INVENTORYALLOCATIONLINE_ITEMID);
        List<Id> branchIds = getBranchIds(inventoryFulfillmentOrderLines);
        List<Id> partnerAccountIds = getPartnerAccountIds(inventoryFulfillmentOrderLines);
        Map<Id, dmpl__Item__c> items = new Map<Id,dmpl__Item__c>(
        ItemHelper.getCachedItems(DocumentHelper.extractIds(inventoryFulfillmentOrderLines, FIELD_INVENTORYALLOCATIONLINE_ITEMID)));
        List<Id> skuIds = DocumentHelper.extractIds(inventoryFulfillmentOrderLines, FIELD_INVENTORYALLOCATIONLINE_SKUID);
        List<Id> itemLotTypeIds = DocumentHelper.extractIds(inventoryFulfillmentOrderLines, FIELD_INVENTORYALLOCATIONLINE_ITEMLOTTYPEID);
        List<dmpl__ItemLot__c> itemLots = queryItemLots(itemIds, branchIds, partnerAccountIds, skuIds, itemLotTypeIds);
        List<dmpl__InventoryStock__c> itemsStock = queryInventoryStocks(itemIds, branchIds, partnerAccountIds, skuIds);
        List<dmpl__InventoryFulfillmentAllocationLine__c> allocationLines = new List<dmpl__InventoryFulfillmentAllocationLine__c>();

        Map<Id, Decimal> availableQuantityInLots = getLotAvailableQuantities(itemLots);
        Map<Id, Decimal> availableQuantityInStocks = getStockAvailableQuantities(itemsStock);

        for(dmpl__InventoryFulfillmentOrderLine__c orderLine : inventoryFulfillmentOrderLines){
            if(items.get(orderLine.dmpl__ItemId__c).dmpl__TrackLots__c){
                Decimal requestedQty = SourceObjectInfo.getRequestedQuantity(orderLinesInfo, orderLine.Id);
                Decimal pendingQuantity = requestedQty > 0 ? requestedQty : orderLine.dmpl__PendingAllocationQuantity__c;
                while(pendingQuantity > 0){
                    dmpl__ItemLot__c eligibleItemLot = getFilteredItemLot(
                        itemLots, 
                        orderLine.dmpl__ItemId__c, 
                        orderLine.dmpl__FulfillmentId__r.dmpl__BranchId__c, 
                        orderLine.dmpl__FulfillmentId__r.dmpl__PartnerAccountId__c, 
                        orderLine.dmpl__SKUId__c,
                        orderLine.dmpl__ItemLotTypeId__c, 
                        availableQuantityInLots, 
                        Integer.valueOf(orderLine.dmpl__LimitExpiryDays__c),
                        orderLine.dmpl__ItemLotId__c);
                    if(eligibleItemLot != null){
                        dmpl__InventoryFulfillmentAllocationLine__c allocationLine = createAllocationFromLot(orderLine, eligibleItemLot, pendingQuantity, availableQuantityInLots);
                        allocationLines.add(allocationLine);
                        //
                        Decimal currentAvailable = availableQuantityInLots.get(allocationLine.dmpl__ItemLotId__c);
                        currentAvailable -= allocationLine.dmpl__Quantity__c;
                        availableQuantityInLots.put(allocationLine.dmpl__ItemLotId__c, currentAvailable);
                        //
                        pendingQuantity -= allocationLine.dmpl__Quantity__c;
                    } else {
                        pendingQuantity = 0;
                    }
                }
            } else if(!items.get(orderLine.dmpl__ItemId__c).dmpl__TrackLots__c && items.get(orderLine.dmpl__ItemId__c).dmpl__TrackInventory__c){
                Decimal requestedQty = SourceObjectInfo.getRequestedQuantity(orderLinesInfo, orderLine.Id);
                Decimal pendingQuantity = requestedQty > 0 ? requestedQty : orderLine.dmpl__PendingAllocationQuantity__c;
                while(pendingQuantity > 0){
                   dmpl__InventoryStock__c eligibleInventoryStock = getFilteredInventoryStock(itemsStock, orderLine.dmpl__ItemId__c, orderLine.dmpl__FulfillmentId__r.dmpl__BranchId__c, orderLine.dmpl__FulfillmentId__r.dmpl__PartnerAccountId__c, orderLine.dmpl__SKUId__c, availableQuantityInStocks);
                    if(eligibleInventoryStock != null){
                        dmpl__InventoryFulfillmentAllocationLine__c allocationLine = createAllocationFromInventory(orderLine, eligibleInventoryStock, pendingQuantity, availableQuantityInStocks);
                        allocationLines.add(allocationLine);
                        //
                        Decimal currentAvailable = availableQuantityInStocks.get(allocationLine.dmpl__StockId__c);
                        currentAvailable -= allocationLine.dmpl__Quantity__c;
                        availableQuantityInStocks.put(allocationLine.dmpl__StockId__c, currentAvailable);
                        //
                        pendingQuantity -= allocationLine.dmpl__Quantity__c;
                    } else {
                        pendingQuantity = 0;
                    }
                }
            }
        }
        
        if(allocationLines.size() >0){
            Savepoint sp = Database.setSavepoint();
            try {
                skipValidations = true;
                insert allocationLines;
            } catch (Exception e) {
                Database.rollback(sp);
                throw new DMPLException(e.getMessage());
            } finally{
                skipValidations = false;
            }
        }

        return new Map<Id, dmpl__InventoryFulfillmentAllocationLine__c>(allocationLines);
    }

    private static Map<Id, Decimal> getLotAvailableQuantities(List<dmpl__ItemLot__c> itemLots)
    {
        Map<Id, Decimal> result = new Map<Id, Decimal>();
        for(dmpl__ItemLot__c lot : itemLots)
        {
            result.put(lot.Id, lot.dmpl__QuantityAvailable__c == null ? 0 : (Decimal)lot.dmpl__QuantityAvailable__c);
        }
        return result;
    }

    private static Map<Id, Decimal> getStockAvailableQuantities(List<dmpl__InventoryStock__c> itemStocks)
    {
        Map<Id, Decimal> result = new Map<Id, Decimal>();
        for(dmpl__InventoryStock__c stock : itemStocks)
        {
            result.put(stock.Id, stock.dmpl__QuantityAvailable__c == null ? 0 : (Decimal)stock.dmpl__QuantityAvailable__c);
        }
        return result;
    }

    private static CreateRelatedResult cancelAllocation(
        List<dmpl__InventoryFulfillmentAllocationLine__c> inventoryFulfillmentAllocationLines,
        List<SourceObjectInfo> orderLinesInfo){
        if(inventoryFulfillmentAllocationLines.size() == 0){
            throw new DMPLException(String.format(String.valueOf(System.Label.Generic_EmptyActionParam), new String[]{dmpl__InventoryFulfillmentOrderLine__c.class.getName()}));
        }

        List<dmpl__InventoryFulfillmentAllocationLine__c> allocationLines = new List<dmpl__InventoryFulfillmentAllocationLine__c>();
        for(dmpl__InventoryFulfillmentAllocationLine__c allocationLine : inventoryFulfillmentAllocationLines){
            Decimal retuenQty = allocationLine.dmpl__EligibleReturnQuantity__c * -1;
            if(orderLinesInfo !=null){
                retuenQty = SourceObjectInfo.getRequestedQuantity(orderLinesInfo, allocationLine.Id) * -1;
            }
            dmpl__InventoryFulfillmentAllocationLine__c line = createAllocationLineForCancellation(
                allocationLine,
                retuenQty);
            if(orderLinesInfo !=null){
                SourceObjectInfo info = SourceObjectInfo.getSourceObjectInfo(orderLinesInfo, allocationLine.Id);
                if(info.fields!=null){
                    for(SourceObjectField srcField : info.fields){
                        line.put(srcField.fieldName, srcField.fieldValue);
                    }
                }
            }
            allocationLines.add(line);
        }
        
        if(allocationLines.size() >0){
            Savepoint sp = Database.setSavepoint();
            try {
                skipValidations = true;
                insert allocationLines;
                return CreateRelatedResult.SuccessResult();
            } catch (Exception e) {
                Database.rollback(sp);
                throw new DMPLException(e.getMessage());
            } finally{
                skipValidations = false;
            }
        }
        return CreateRelatedResult.FailedResult('No lines to cancel!');
    }

    private static List<dmpl__InventoryFulfillmentOrderLine__c> queryOrderLinesForAllocation(List<Id> inventoryFulfillmentIds, List<Id> inventoryFulfillmentOrderLineIds)
    {
        if(inventoryFulfillmentOrderLineIds == null){
            inventoryFulfillmentOrderLineIds = new List<Id>();
        }
        if(inventoryFulfillmentIds == null){
            inventoryFulfillmentIds = new List<Id>();
        }
        SecurityHelper.ensureCanReadFields(new string[]{'dmpl__BranchId__c','dmpl__PartnerAccountId__c'}, 'dmpl__InventoryFulfillment__c');
        SecurityHelper.ensureCanReadFields(new string[]{'dmpl__Quantity__c','dmpl__ItemId__c','dmpl__SKUId__c','dmpl__ItemLotTypeId__c','dmpl__AllocatedQuantity__c','dmpl__PendingAllocationQuantity__c','dmpl__BackOrderQuantity__c','dmpl__CancelledQuantity__c','dmpl__UnitCost__c','dmpl__SaleOrderLineId__c','dmpl__RepairOrderLineId__c','dmpl__LimitExpiryDays__c'}, 'dmpl__InventoryFulfillmentOrderLine__c');
        return [SELECT ID,
        Name,
        dmpl__FulfillmentId__r.dmpl__BranchId__c,
        dmpl__FulfillmentId__r.dmpl__PartnerAccountId__c,
        dmpl__PendingAllocationQuantity__c,
        dmpl__AllocatedQuantity__c,
        dmpl__BackOrderQuantity__c,
        dmpl__CancelledQuantity__c,
        dmpl__Quantity__c ,
        dmpl__ItemId__c,
        dmpl__SKUId__c,
        dmpl__ItemLotTypeId__c,
        dmpl__UnitCost__c,
        dmpl__SaleOrderLineId__c,
        dmpl__RepairOrderLineId__c,
        dmpl__LimitExpiryDays__c,
        dmpl__ItemLotId__c
        FROM
        dmpl__InventoryFulfillmentOrderLine__c WHERE dmpl__FulfillmentId__c IN : inventoryFulfillmentIds OR ID IN: inventoryFulfillmentOrderLineIds];
    }

    private static List<dmpl__InventoryFulfillmentAllocationLine__c> queryAllocationLines(
        List<Id> inventoryFulfillmentIds, 
        List<Id> inventoryFulfillmentAllocationLineIds)
    {
        if(inventoryFulfillmentIds == null){
            inventoryFulfillmentIds = new List<Id>();
        }
        if(inventoryFulfillmentAllocationLineIds == null){
            inventoryFulfillmentAllocationLineIds = new List<Id>();
        }

        SecurityHelper.ensureCanReadFields(new string[]{'dmpl__AllocatedQuantity__c','dmpl__ItemId__c','dmpl__SKUId__c','dmpl__ItemLotTypeId__c','dmpl__FulfillmentOrderLineId__c','dmpl__FulfillmentOrderId__c','dmpl__SaleOrderLineId__c','dmpl__ItemLotId__c','dmpl__UnitCost__c','dmpl__StorageLocationId__c','dmpl__StockId__c','dmpl__RepairOrderLineId__c','dmpl__ParentFulfillmentAllocationLineId__c'}, 'dmpl__InventoryFulfillmentAllocationLine__c');
        return [SELECT ID,
        Name,
        dmpl__FulfillmentOrderLineId__c,
        dmpl__FulfillmentOrderId__c,
        dmpl__ItemId__c,
        dmpl__ItemLotId__c,
        dmpl__SKUId__c,
        dmpl__ItemLotTypeId__c,
        dmpl__AllocatedQuantity__c,
        dmpl__ReturnedQuantity__c,
        dmpl__SaleOrderLineId__c ,
        dmpl__RepairOrderLineId__c ,
        dmpl__StockId__c,
        dmpl__StorageLocationId__c,
        dmpl__UnitCost__c,
        dmpl__EligibleReturnQuantity__c,
        dmpl__ParentFulfillmentAllocationLineId__c
        FROM
        dmpl__InventoryFulfillmentAllocationLine__c WHERE dmpl__AllocatedQuantity__c > 0 AND (dmpl__FulfillmentOrderId__c IN : inventoryFulfillmentIds OR ID IN: inventoryFulfillmentAllocationLineIds)];
    }

    public static List<dmpl__ItemLot__c> queryItemLots(List<Id> itemIds, List<Id> branchIds, List<Id> partnerAccountIds, List<Id> skuIds, List<Id> itemLotTypeIds)
    {
        SecurityHelper.ensureCanReadFields(new string[]{'dmpl__QuantityAvailable__c','dmpl__UnitCost__c','dmpl__StorageLocationId__c','dmpl__QuantityInHand__c','dmpl__BatchNo__c','dmpl__BranchId__c','dmpl__PartnerAccountId__c','dmpl__ComponentNumber__c','dmpl__Cost__c','dmpl__ItemId__c','dmpl__SKUId__c','dmpl__ItemLotTypeId__c','dmpl__HoldCode__c','dmpl__DateOfExpiry__c'}, 'dmpl__ItemLot__c');
        String query = 'SELECT Id, Name,dmpl__BatchNo__c,dmpl__BranchId__c,dmpl__PartnerAccountId__c,dmpl__ComponentNumber__c,dmpl__Cost__c,dmpl__ItemId__c,dmpl__SKUId__c,dmpl__ItemLotTypeId__c,dmpl__QuantityAvailable__c,dmpl__QuantityInHand__c,dmpl__StorageLocationId__c,dmpl__UnitCost__c,dmpl__DateOfExpiry__c FROM dmpl__ItemLot__c WHERE dmpl__ItemId__c IN : itemIds AND dmpl__BranchId__c IN : branchIds        AND dmpl__PartnerAccountId__c IN : partnerAccountIds        AND dmpl__HoldCode__c = null        AND (dmpl__SKUId__c IN : skuIds OR dmpl__SKUId__c = null)';//AND (dmpl__ItemLotTypeId__c IN : itemLotTypeIds OR dmpl__ItemLotTypeId__c = null)
        return Database.query(query + getItemLotOrderByClause());
    }

    private static String getItemLotOrderByClause()
    {
        String orderByClause = ' ORDER BY dmpl__StorageLocationId__r.dmpl__FulfillmentSequenceNo__c,CreatedDate';
        dmpl__DMSOrgSetting__mdt orgSetting = OrgSettingHelper.OrgSetting();
        if(orgSetting != null && !String.isBlank(orgSetting.dmpl__ItemLotOrderByFields__c))
            orderByClause = ' ORDER BY dmpl__StorageLocationId__r.dmpl__FulfillmentSequenceNo__c, '+orgSetting.dmpl__ItemLotOrderByFields__c;

        return orderByClause;
    }

    private static List<dmpl__InventoryStock__c> queryInventoryStocks(List<Id> itemIds, List<Id> branchIds, List<Id> partnerAccountIds, List<Id> skuIds) {
      
        SecurityHelper.ensureCanReadFields(new string[]{'dmpl__BranchId__c','dmpl__StorageLocationId__c','dmpl__QuantityOnInspection__c','dmpl__QuantityOnHold__c','dmpl__QuantityOnFulfillment__c','dmpl__QuantityOnAllocation__c','dmpl__QuantityInTransit__c','dmpl__QuantityInHand__c','dmpl__PartnerAccountId__c','dmpl__ItemId__c','dmpl__SKUId__c','dmpl__QuantityAdjustedIn__c','dmpl__QuantityAdjustedOut__c','dmpl__QuantityAssembledIn__c','dmpl__QuantityAssembledOut__c','dmpl__QuantityAvailable__c','dmpl__QuantityDamaged__c','dmpl__QuantityExpired__c'}, 'dmpl__InventoryStock__c');
        return [SELECT Id, Name,
        dmpl__BranchId__c,
        dmpl__PartnerAccountId__c,
        dmpl__ItemId__c,
        dmpl__SKUId__c,
        dmpl__QuantityAdjustedIn__c,
        dmpl__QuantityAdjustedOut__c,
        dmpl__QuantityAssembledIn__c,
        dmpl__QuantityAssembledOut__c,
        dmpl__QuantityAvailable__c,
        dmpl__QuantityDamaged__c,
        dmpl__QuantityExpired__c,
        dmpl__QuantityInHand__c,
        dmpl__QuantityInTransit__c,
        dmpl__QuantityOnAllocation__c,
        dmpl__QuantityOnFulfillment__c,
        dmpl__QuantityOnHold__c,
        dmpl__QuantityOnInspection__c,
        dmpl__StorageLocationId__c
        FROM dmpl__InventoryStock__c
        WHERE dmpl__ItemId__c IN : itemIds
        AND dmpl__BranchId__c IN : branchIds
        AND dmpl__PartnerAccountId__c IN : partnerAccountIds
        AND (dmpl__SKUId__c IN : skuIds OR dmpl__SKUId__c = null)];
    }

    @testVisible
    private static dmpl__ItemLot__c getFilteredItemLot(
        List<dmpl__ItemLot__c> itemLots, 
        Id itemId, 
        Id branchId, 
        Id partnerAccountId, 
        Id skuId, 
        Id itemLotTypeId, 
        Map<Id, Decimal> currentQuantityInItemLot, 
        Integer limitExpiryDays,
        Id preferedLotId){
            if(preferedLotId!=null){
                dmpl__ItemLot__c itemLot = (dmpl__ItemLot__c)CollectionHelper.getObject(itemLots, preferedLotId);
                if(itemLot !=null
                    && itemLot.dmpl__ItemId__c == itemId 
                    && itemLot.dmpl__BranchId__c == branchId 
                    && itemLot.dmpl__PartnerAccountId__c == partnerAccountId 
                    && itemLot.dmpl__SKUId__c == skuId 
                    && ((itemLotTypeId != null && itemLot.dmpl__ItemLotTypeId__c == itemLotTypeId) || (itemLotTypeId == null))
                    && itemLot.dmpl__QuantityAvailable__c > 0 
                    && currentQuantityInItemLot.get(itemLot.Id) != null 
                    && currentQuantityInItemLot.get(itemLot.Id) > 0
                    && ((limitExpiryDays != null && limitExpiryDays > 0 && itemLot.dmpl__DateOfExpiry__c != null && itemLot.dmpl__DateOfExpiry__c <= Datetime.now().date().addDays(Integer.valueOf(limitExpiryDays)))
                        || ((limitExpiryDays == null || limitExpiryDays <= 0)))){
                        return itemLot;
                    }
            }

            for(dmpl__ItemLot__c itemLot : itemLots){
                if(itemLot.dmpl__ItemId__c == itemId 
                    && itemLot.dmpl__BranchId__c == branchId 
                    && itemLot.dmpl__PartnerAccountId__c == partnerAccountId 
                    && itemLot.dmpl__SKUId__c == skuId 
                    && ((itemLotTypeId != null && itemLot.dmpl__ItemLotTypeId__c == itemLotTypeId) || (itemLotTypeId == null))
                    && itemLot.dmpl__QuantityAvailable__c > 0 
                    && currentQuantityInItemLot.get(itemLot.Id) != null 
                    && currentQuantityInItemLot.get(itemLot.Id) > 0
                    && ((limitExpiryDays != null && limitExpiryDays > 0 && itemLot.dmpl__DateOfExpiry__c != null && itemLot.dmpl__DateOfExpiry__c <= Datetime.now().date().addDays(Integer.valueOf(limitExpiryDays)))
                        || ((limitExpiryDays == null || limitExpiryDays <= 0)))){
                    return itemLot;
                }
            }
        return null;
    }

    @TestVisible private static dmpl__InventoryStock__c getFilteredInventoryStock(List<dmpl__InventoryStock__c> inventoryStocks, Id itemId, Id branchId, Id partnerAccountId, Id skuId, Map<Id, Decimal> currentQuantityInItemStock){
        for(dmpl__InventoryStock__c inventoryStock : inventoryStocks)
            if(inventoryStock.dmpl__ItemId__c == itemId && inventoryStock.dmpl__BranchId__c == branchId && inventoryStock.dmpl__PartnerAccountId__c == partnerAccountId && inventoryStock.dmpl__SKUId__c == skuId && inventoryStock.dmpl__QuantityAvailable__c > 0 && currentQuantityInItemStock.get(inventoryStock.Id) != null && currentQuantityInItemStock.get(inventoryStock.Id) > 0)
            {
                return inventoryStock;
            }
        return null;
    }

    @TestVisible private static dmpl__InventoryFulfillmentAllocationLine__c createAllocationFromLot(dmpl__InventoryFulfillmentOrderLine__c orderLine, dmpl__ItemLot__c itemLot, Decimal pendingQuantity, Map<Id, Decimal> currentQuantityInItemLot){
        return new dmpl__InventoryFulfillmentAllocationLine__c(
            dmpl__FulfillmentOrderLineId__c = orderLine.Id,
            dmpl__FulfillmentOrderId__c = orderLine.dmpl__FulfillmentId__c,
            dmpl__ItemId__c = orderLine.dmpl__ItemId__c,
            dmpl__ItemLotId__c = itemLot.Id,
            dmpl__SKUId__c = orderLine.dmpl__SKUId__c,
            dmpl__ItemLotTypeId__c = itemLot.dmpl__ItemLotTypeId__c,
            dmpl__Quantity__c = pendingQuantity > currentQuantityInItemLot.get(itemLot.Id) ? currentQuantityInItemLot.get(itemLot.Id) : pendingQuantity,
            dmpl__StorageLocationId__c = itemLot.dmpl__StorageLocationId__c,
            dmpl__UnitCost__c = itemLot.dmpl__UnitCost__c,
            dmpl__SaleOrderLineId__c = orderLine.dmpl__SaleOrderLineId__c,
            dmpl__RepairOrderLineId__c = orderLine.dmpl__RepairOrderLineId__c,
            dmpl__IsILPostingApproved__c = true
        );
    }

    @TestVisible private static dmpl__InventoryFulfillmentAllocationLine__c createAllocationLineForCancellation(
        dmpl__InventoryFulfillmentAllocationLine__c allocationLine,
        Decimal returnQuantity){
        return new dmpl__InventoryFulfillmentAllocationLine__c(
            dmpl__FulfillmentOrderLineId__c = allocationLine.dmpl__FulfillmentOrderLineId__c,
            dmpl__FulfillmentOrderId__c = allocationLine.dmpl__FulfillmentOrderId__c,
            dmpl__ItemId__c = allocationLine.dmpl__ItemId__c,
            dmpl__ItemLotId__c = allocationLine.dmpl__ItemLotId__c,
            dmpl__SKUId__c = allocationLine.dmpl__SKUId__c,
            dmpl__ItemLotTypeId__c = allocationLine.dmpl__ItemLotTypeId__c,
            dmpl__Quantity__c = returnQuantity,
            dmpl__StorageLocationId__c = allocationLine.dmpl__StorageLocationId__c,
            dmpl__UnitCost__c = allocationLine.dmpl__UnitCost__c,
            dmpl__StockId__c = allocationLine.dmpl__StockId__c,
            dmpl__IsILPostingApproved__c = true,
            dmpl__ParentFulfillmentAllocationLineId__c = allocationLine.Id
        );
    }

    private static void validateItem(List<dmpl__InventoryFulfillmentAllocationLine__c> newEntries){
        Map<Id, dmpl__Item__c> items = new Map<Id,dmpl__Item__c>(ItemHelper.getCachedItems(DocumentHelper.extractIds(newEntries, FIELD_INVENTORYALLOCATIONLINE_ITEMID)));
        for(dmpl__InventoryFulfillmentAllocationLine__c orderLine : newEntries){
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

    @TestVisible 
    private static dmpl__InventoryFulfillmentAllocationLine__c createAllocationFromInventory(dmpl__InventoryFulfillmentOrderLine__c orderLine, dmpl__InventoryStock__c inventoryStock, Decimal pendingQuantity, Map<Id, Decimal> currentQuantityInItemStock){
        return new dmpl__InventoryFulfillmentAllocationLine__c(
            dmpl__FulfillmentOrderLineId__c = orderLine.Id,
            dmpl__FulfillmentOrderId__c = orderLine.dmpl__FulfillmentId__c,
            dmpl__ItemId__c = orderLine.dmpl__ItemId__c,
            dmpl__StockId__c = inventoryStock.Id,
            dmpl__SKUId__c = orderLine.dmpl__SKUId__c,
            dmpl__Quantity__c = pendingQuantity > currentQuantityInItemStock.get(inventoryStock.Id) ? currentQuantityInItemStock.get(inventoryStock.Id) : pendingQuantity,
            dmpl__StorageLocationId__c = inventoryStock.dmpl__StorageLocationId__c,
            dmpl__UnitCost__c = orderLine.dmpl__UnitCost__c,
            dmpl__SaleOrderLineId__c = orderLine.dmpl__SaleOrderLineId__c,
            dmpl__RepairOrderLineId__c = orderLine.dmpl__RepairOrderLineId__c,
            dmpl__IsILPostingApproved__c = true
        );
    }

    private static List<Id> getFulfillmentOrderLineIds(List<dmpl__GoodsReceiptLine__c> goodsReceiptLines)
    {
        List<Id> result = new List<Id>();
        for(dmpl__GoodsReceiptLine__c goodsReceiptLine : goodsReceiptLines)
        {
            if(goodsReceiptLine.dmpl__PurchaseOrderLineId__c != null && goodsReceiptLine.dmpl__PurchaseOrderLineId__r.dmpl__FulfillmentOrderLineId__c != null)
            {
                result.add(goodsReceiptLine.dmpl__PurchaseOrderLineId__r.dmpl__FulfillmentOrderLineId__c);
            }
        }
        return result;
    }

    private Static List<Id> getBranchIds(List<dmpl__InventoryFulfillmentOrderLine__c> fulfillmentOrderLines)
    {
        List<Id> result = new List<Id>();
        for(dmpl__InventoryFulfillmentOrderLine__c fulfillmentOrderLine : fulfillmentOrderLines)
        {
            if(fulfillmentOrderLine.dmpl__FulfillmentId__c != null && fulfillmentOrderLine.dmpl__FulfillmentId__r.dmpl__BranchId__c != null && !result.contains(fulfillmentOrderLine.dmpl__FulfillmentId__r.dmpl__BranchId__c))
                result.add(fulfillmentOrderLine.dmpl__FulfillmentId__r.dmpl__BranchId__c);
        }
        return result;
    }

    private Static List<Id> getPartnerAccountIds(List<dmpl__InventoryFulfillmentOrderLine__c> fulfillmentOrderLines)
    {
        List<Id> result = new List<Id>();
        for(dmpl__InventoryFulfillmentOrderLine__c fulfillmentOrderLine : fulfillmentOrderLines)
        {
            if(fulfillmentOrderLine.dmpl__FulfillmentId__c != null && fulfillmentOrderLine.dmpl__FulfillmentId__r.dmpl__PartnerAccountId__c != null && !result.contains(fulfillmentOrderLine.dmpl__FulfillmentId__r.dmpl__PartnerAccountId__c))
                result.add(fulfillmentOrderLine.dmpl__FulfillmentId__r.dmpl__PartnerAccountId__c);
        }
        return result;
    }
}