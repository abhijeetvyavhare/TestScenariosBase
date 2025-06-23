public with sharing class InventoryFulfillmentPickingLineHelper {

    private static Boolean skipValidations = false;

    private static final string FIELD_INVENTORYPICKINGLINE_ITEMID = 'dmpl__ItemId__c';
    private static final string FIELD_INVENTORYPICKINGLINE_SKUID = 'dmpl__SKUId__c';
    private static final string FIELD_INVENTORYPICKINGLINE_ITEMLOTTYPEID = 'dmpl__ItemLotTypeId__c';
    private static final string FIELD_FULFILLMENTPICKINGLINE_QUANTITY = 'dmpl__Quantity__c';
    private static final string FIELD_FULFILLMENTPICKINGLINE_RETURNEDQUANTITY = 'dmpl__ReturnedQuantity__c';
    private static final string FIELD_FULFILLMENTPICKINGLINE_REQUESTEDQUANTITY = 'dmpl__RequestedQuantity__c';
    private static final string FIELD_FULFILMENTPICKINGLINE_INVENTORYLEDGERID = 'dmpl__InventoryLedgerId__c';
    private static final string FIELD_FULFILMENTPICKINGLINE_ITEMLOTID = 'dmpl__ItemLotId__c';
    private static final string OBJECT_FULFILLMENT = 'dmpl__InventoryFulfillment__c';
    private static final string OBJECT_FULFILLMENTPICKINGLINE = 'dmpl__InventoryFulfillmentPickingLine__c';
    private static final string RELATION_FULFILLMENT_STATUS = 'dmpl__FulfillmentId__r.dmpl__Status__c';
    private static final string FIELD_INVENTORYPICKING_ALLOCATIONLINE_ID = 'dmpl__FulfillmentAllocationLineId__c';
    private static final string FIELD_INVENTORYPICKING_PARENTLINE_ID = 'dmpl__ParentFulfillmentPickingLineId__c';
    private static final string FIELD_AGG_PICKINGLINEID = 'PickingLineId';
    private static final string FIELD_AGG_TOTALQTY = 'TotalQuantity';

    private static final List<String> LIST_FIELDS_NONEDITABLE = new List<String>{
        FIELD_INVENTORYPICKING_ALLOCATIONLINE_ID
    };
    private static final List<String> LIST_FIELDS_SYSTEM = new List<String>{
        FIELD_FULFILMENTPICKINGLINE_INVENTORYLEDGERID
    };
    private static final List<String> LIST_FIELDS_SOURCEPOULATED = new List<String>{
        FIELD_INVENTORYPICKINGLINE_ITEMID,
        FIELD_FULFILMENTPICKINGLINE_ITEMLOTID,
        FIELD_INVENTORYPICKINGLINE_SKUID
    };
    private static final List<String> LIST_FIELDS_LOCKEDIFTRANSACTED = new List<String>{
        FIELD_INVENTORYPICKINGLINE_SKUID,
        FIELD_FULFILMENTPICKINGLINE_ITEMLOTID,
        FIELD_INVENTORYPICKINGLINE_SKUID,
        FIELD_INVENTORYPICKING_ALLOCATIONLINE_ID
    };

    private static final List<String> LIST_FIELDS_NEGATIVENOTALLOWED = new List<String>{
        'dmpl__CancelQuantity__c', 
        'dmpl__DeliveryQuantity__c', 
        // 'dmpl__PickedQuantity__c', 
        // 'dmpl__Quantity__c', 
        'dmpl__RequestedQuantity__c', 
        'dmpl__ReturnedQuantity__c'
    };

    private static final List<String> LIST_FIELDS_ZERONOTALLOWED = new List<String>{

    };

    public static void validateData(
        Boolean isInsert, 
        Boolean isUpdate, 
        Boolean isDelete, 
        List<dmpl__InventoryFulfillmentPickingLine__c> newEntries, 
        List<dmpl__InventoryFulfillmentPickingLine__c> oldEntries){   
        try{
            if(isInsert){
                FieldMappingHelper.copyFieldMappingData(
                    newEntries);
            }
            if(isInsert || isUpdate){
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
                validateFulfillmentAllocationLine(newEntries);
                DocumentHelper.validateChangeInSystemFields(
                    LIST_FIELDS_SYSTEM, newEntries);
                (new DocumentStatusDFSHelper()).DocumentStatusRelatedObjectRestrictEdits_New(
                    OBJECT_FULFILLMENT, 
                    OBJECT_FULFILLMENTPICKINGLINE, 
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
                    FIELD_INVENTORYPICKING_ALLOCATIONLINE_ID);
                DocumentHelper.validateChangeInLockedIfTransactedFields(
                    LIST_FIELDS_LOCKEDIFTRANSACTED, 
                    oldEntries, 
                    newEntries, 
                    FIELD_FULFILLMENTPICKINGLINE_QUANTITY);
                (new DocumentStatusDFSHelper()).DocumentStatusRelatedObjectRestrictEdits_Edit(
                    OBJECT_FULFILLMENT, 
                    OBJECT_FULFILLMENTPICKINGLINE, 
                    RELATION_FULFILLMENT_STATUS, 
                    oldEntries, 
                    newEntries);
            }else if(isDelete){
                DocumentHelper.validateCanBeDeleted(
                    oldEntries, 
                    FIELD_FULFILLMENTPICKINGLINE_QUANTITY);
                (new DocumentStatusDFSHelper()).DocumentStatusRelatedObjectRestrictEdits_Delete(
                    OBJECT_FULFILLMENT, 
                    OBJECT_FULFILLMENTPICKINGLINE, 
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
        List<dmpl__InventoryFulfillmentPickingLine__c> newEntries, 
        List<dmpl__InventoryFulfillmentPickingLine__c> oldEntries){       
            List<dmpl__InventoryFulfillmentPickingLine__c> modifiedLedgerObjects = DocumentHelper.getPostedObjects(
                    'dmpl__IsPickingConfirmed__c', 
                    oldEntries, 
                    newEntries);
                    if(modifiedLedgerObjects.size()>0){
                        InventoryLedgerHelper.createLedger(
                        InventoryLedgerTypeEnums.Picked, 
                        'dmpl__FulfillmentOrderId__c', 
                        'dmpl__InventoryFulfillment__c', 
                        isInsert, 
                        isDelete, 
                        isUpdate, 
                        isDelete ? modifiedLedgerObjects : oldEntries, 
                        isInsert || isUpdate ? modifiedLedgerObjects : newEntries);
                    }
    }

    public static void afterPostData(
        Boolean isInsert, 
        Boolean isUpdate, 
        Boolean isDelete, 
        List<dmpl__InventoryFulfillmentPickingLine__c> newEntries, 
        List<dmpl__InventoryFulfillmentPickingLine__c> oldEntries){
        try{
            if(isDelete){
                InventoryFulfillmentAllocationLineHelper.updateFulfillmentPickedQuantity(
                    DocumentHelper.extractIds(
                        oldEntries, 
                        FIELD_INVENTORYPICKING_ALLOCATIONLINE_ID));
                UpdatePickedReturnQuantity(DocumentHelper.extractIds(
                    oldEntries, 
                    FIELD_INVENTORYPICKING_PARENTLINE_ID));
            }else if(isInsert){
                InventoryFulfillmentAllocationLineHelper.updateFulfillmentPickedQuantity(
                    DocumentHelper.extractIds(
                        newEntries, 
                        FIELD_INVENTORYPICKING_ALLOCATIONLINE_ID));
                UpdatePickedReturnQuantity(DocumentHelper.extractIds(
                    newEntries, 
                    FIELD_INVENTORYPICKING_PARENTLINE_ID));
            }else if(isUpdate){
                List<Id> modifiedObjectIds = DocumentHelper.getModifiedNewObjectIds(
                    new List<String> {FIELD_FULFILLMENTPICKINGLINE_QUANTITY , FIELD_FULFILLMENTPICKINGLINE_REQUESTEDQUANTITY, FIELD_FULFILLMENTPICKINGLINE_RETURNEDQUANTITY}, 
                    FIELD_INVENTORYPICKING_ALLOCATIONLINE_ID, 
                    oldEntries, 
                    newEntries);
                if(modifiedObjectIds.size()>0){
                    InventoryFulfillmentAllocationLineHelper.updateFulfillmentPickedQuantity(
                        DocumentHelper.extractIds(
                            newEntries, 
                            FIELD_INVENTORYPICKING_ALLOCATIONLINE_ID));
                    }
                UpdatePickedReturnQuantity(DocumentHelper.extractIds(
                    newEntries, 
                    FIELD_INVENTORYPICKING_PARENTLINE_ID));
            }
        } catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }

    public static void createPickingFromFulfillment(
        List<dmpl__InventoryFulfillment__c> inventoryFulfillments){
        createPicking(
            queryAllocationLinesForPicking(
                DocumentHelper.extractIds(
                    inventoryFulfillments), 
                null), 
            null);
    }

    public static CreateRelatedResult createPickingFromFulfillment(
        List<SourceObjectInfo> orderLinesInfo){
        return CreateRelatedResult.InitFrom(
            createPicking(
                queryAllocationLinesForPicking(
                    null, 
                    SourceObjectInfo.extractIds(
                        orderLinesInfo)), 
                orderLinesInfo));
    }

    public static CreateRelatedResult createPickingFromFulfillment(
        Id inventoryFulfillmentId){
        return CreateRelatedResult.InitFrom(
            createPicking(
                queryAllocationLinesForPicking(
                    New List<Id>{inventoryFulfillmentId}, 
                    null), 
                null));
    }

    public static void confirmPickingFromFulfillment(
        List<dmpl__InventoryFulfillment__c> inventoryFulfillments){
        confirmPicking(
            queryPickingLines(
                DocumentHelper.extractIds(
                    inventoryFulfillments), 
                null), 
            null);
    }

    public static CreateRelatedResult confirmPickingFromFulfillment(
        List<SourceObjectInfo> orderLinesInfo,
        Id inventoryFulfillmentId){
        return confirmPicking(
            queryPickingLines(
                    null, 
                    SourceObjectInfo.extractIds(
                        orderLinesInfo)), 
                orderLinesInfo);
    }

    public static CreateRelatedResult confirmPickingFromFulfillment(
        Id inventoryFulfillmentId){
        return confirmPicking(
            queryPickingLines(
                    New List<Id>{inventoryFulfillmentId}, 
                    null), 
                null);
    }

    public static CreateRelatedResult cancelPickingFromFulfillment(
        Id inventoryFulfillmentId){
        return cancelPicking(
            queryPickingLines(
                new List<Id>{ inventoryFulfillmentId}, 
                null),
            null);
    }

    public static void cancelPickingFromFulfillment(
        List<dmpl__InventoryFulfillment__c> inventoryFulfillments){
        cancelPicking(
            queryPickingLines(
                DocumentHelper.extractIds(
                    inventoryFulfillments), 
                null),
            null);
    }

    public static CreateRelatedResult cancelPickingFromFulfillment(
        List<SourceObjectInfo> orderLinesInfo){
        return cancelPicking(
            queryPickingLines(
                null, 
                SourceObjectInfo.extractIds(
                    orderLinesInfo)),
            orderLinesInfo);
    }

    public static void updateSaleDeliveryQuantity(List<Id> pickingLineIds)
    {
        try{
            if(pickingLineIds.Size() == 0)
                return;
            skipValidations = true;
           
            SecurityHelper.ensureCanReadFields(new string[]{'dmpl__FulfillmentPickingLineId__c','dmpl__Quantity__c'}, 'dmpl__DeliveryOrderLine__c');
            List<AggregateResult> ffAggregates = 
                [SELECT 
                    dmpl__FulfillmentPickingLineId__c PickingLineId, 
                    SUM(dmpl__Quantity__c) TotalQuantity,
                    SUM(dmpl__ReturnedQuantity__c) ReturnQuantity
                FROM dmpl__DeliveryOrderLine__c
                WHERE dmpl__FulfillmentPickingLineId__c IN :pickingLineIds
                GROUP BY dmpl__FulfillmentPickingLineId__c];

            SecurityHelper.ensureCanReadFields(new string[]{'dmpl__DeliveryQuantity__c'}, 'dmpl__InventoryFulfillmentPickingLine__c');
            List<dmpl__InventoryFulfillmentPickingLine__c> pickingLinesToUpdate = 
                [SELECT Id, dmpl__DeliveryQuantity__c
                FROM dmpl__InventoryFulfillmentPickingLine__c
                WHERE Id IN :pickingLineIds];
    
            for(dmpl__InventoryFulfillmentPickingLine__c pickingLine : pickingLinesToUpdate){
                for(AggregateResult result : ffAggregates){
                    if(result.get('PickingLineId') == pickingLine.Id){
                        pickingLine.dmpl__DeliveryQuantity__c = result.get('TotalQuantity') ==null ? 0 : (Decimal)(result.get('TotalQuantity'));
                        pickingLine.dmpl__ReturnedQuantity__c = result.get('ReturnQuantity') ==null ? 0 : (Decimal)(result.get('ReturnQuantity'));
                        break;
                    }
                }
            }
            SecurityHelper.ensureCanWriteFields(new string[]{'dmpl__DeliveryQuantity__c'}, 'dmpl__InventoryFulfillmentPickingLine__c');
            Update pickingLinesToUpdate;
        }finally{
            skipValidations = false;
        }
    }

    public static void UpdatePickedReturnQuantity(
        List<Id> pickingLineIds){
        try{
            if(pickingLineIds.Size() == 0)
                return;
            skipValidations = true;
           
            SecurityHelper.ensureCanReadFields(new string[]{
                'dmpl__InventoryFulfillmentPickingLine__c',
                'dmpl__Quantity__c'
            }, 'dmpl__InventoryFulfillmentPickingLine__c');
            List<AggregateResult> ffAggregates = 
                [SELECT 
                    dmpl__ParentFulfillmentPickingLineId__c PickingLineId, 
                    SUM(dmpl__Quantity__c) TotalQuantity
                FROM 
                    dmpl__InventoryFulfillmentPickingLine__c
                WHERE 
                    dmpl__ParentFulfillmentPickingLineId__c IN :pickingLineIds
                WITH SECURITY_ENFORCED
                GROUP BY dmpl__ParentFulfillmentPickingLineId__c];

            SecurityHelper.ensureCanReadFields(new string[]{
                'dmpl__ReturnedQuantity__c'
            }, 'dmpl__InventoryFulfillmentPickingLine__c');
            List<dmpl__InventoryFulfillmentPickingLine__c> pickingLinesToUpdate = 
                [SELECT 
                    Id, 
                    dmpl__ReturnedQuantity__c
                FROM 
                    dmpl__InventoryFulfillmentPickingLine__c
                WHERE Id IN :pickingLineIds];
    
            for(dmpl__InventoryFulfillmentPickingLine__c pickingLine : pickingLinesToUpdate){
                for(AggregateResult result : ffAggregates){
                    if(result.get(FIELD_AGG_PICKINGLINEID) == pickingLine.Id){
                        pickingLine.dmpl__ReturnedQuantity__c = result.get(FIELD_AGG_TOTALQTY) == null ? 
                        0 : -1 * (Decimal)(result.get(FIELD_AGG_TOTALQTY));
                        break;
                    }
                }
            }
            SecurityHelper.ensureCanWriteFields(new string[]{
                'dmpl__ReturnedQuantity__c'
            }, 'dmpl__InventoryFulfillmentPickingLine__c');
            Update pickingLinesToUpdate;
        }finally{
            skipValidations = false;
        }
    }

    private static Map<Id, dmpl__InventoryFulfillmentPickingLine__c> createPicking(
        List<dmpl__InventoryFulfillmentAllocationLine__c> inventoryFulfillmentAllocationLines, 
        List<SourceObjectInfo> orderLinesInfo){
        if(inventoryFulfillmentAllocationLines.size() == 0){
            throw new DMPLException(
                String.format(
                    String.valueOf(
                        System.Label.Generic_EmptyActionParam), 
                    new String[]{dmpl__InventoryFulfillmentAllocationLine__c.class.getName()}));
        }
        List<dmpl__InventoryFulfillmentPickingLine__c> pickingLines = new List<dmpl__InventoryFulfillmentPickingLine__c>();
        for(dmpl__InventoryFulfillmentAllocationLine__c allocationLine : inventoryFulfillmentAllocationLines){
            Decimal pickingQty = null;
            if(orderLinesInfo!=null){
                pickingQty = SourceObjectInfo.getRequestedQuantity(
                    orderLinesInfo, 
                    allocationLine.Id);
            }
            if(pickingQty == null){
                pickingQty = allocationLine.dmpl__PendingPickingQuantity__c;
            }
            if(pickingQty > 0){
                pickingLines.add(
                    createPickingLineFromAllocation(
                        allocationLine,
                        pickingQty));    
            }
        }
        
        if(pickingLines.size() >0){
            Savepoint sp = Database.setSavepoint();
            try {
               skipValidations = true;
                 insert pickingLines;
            } catch (Exception e) {
                Database.rollback(sp);
                throw new DMPLException(e.getMessage());
            } finally{
                skipValidations = false;
            }
        }
        return new Map<Id, dmpl__InventoryFulfillmentPickingLine__c>(pickingLines);
    }

    private static CreateRelatedResult confirmPicking(
        List<dmpl__InventoryFulfillmentPickingLine__c> inventoryFulfillmentPickingLines,
        List<SourceObjectInfo> orderLinesInfo){
        if(inventoryFulfillmentPickingLines.size() == 0){
            throw new DMPLException(
                String.format(
                    String.valueOf(
                        System.Label.Generic_EmptyActionParam), 
                    new String[]{dmpl__InventoryFulfillmentPickingLine__c.class.getName()}));
        }
        List<dmpl__InventoryFulfillmentPickingLine__c> updatedLines = new List<dmpl__InventoryFulfillmentPickingLine__c>();
        for(dmpl__InventoryFulfillmentPickingLine__c pickingLine : inventoryFulfillmentPickingLines){
            Decimal requestedQty = null;
            if(pickingLine.dmpl__IsPickingConfirmed__c){
                continue;
            }
            if(orderLinesInfo!=null){
                requestedQty = SourceObjectInfo.getRequestedQuantity(orderLinesInfo, pickingLine.Id);
            }
            if(requestedQty==null){
                requestedQty = pickingLine.dmpl__RequestedQuantity__c;
            }
            if(requestedQty >0){
                pickingLine.dmpl__Quantity__c = requestedQty;
                pickingLine.dmpl__IsPickingConfirmed__c = true;
                pickingLine.dmpl__CancelQuantity__c = pickingLine.dmpl__RequestedQuantity__c - requestedQty;
                if(orderLinesInfo!=null){
                    SourceObjectInfo info = SourceObjectInfo.getSourceObjectInfo(orderLinesInfo, pickingLine.Id);
                    if(info.fields!=null){
                        for(SourceObjectField srcField : info.fields){
                            pickingLine.put(srcField.fieldName, srcField.fieldValue);
                        }
                    }
                }
                updatedLines.add(pickingLine);
            }
        }
        
        if(updatedLines.size() >0){
            Savepoint sp = Database.setSavepoint();
            try {
                skipValidations = true;
                update updatedLines;
                return CreateRelatedResult.SuccessResult();
            } catch (Exception e) {
                Database.rollback(sp);
                throw new DMPLException(e.getMessage());
            } finally{
                skipValidations = false;
            }
        }
        return CreateRelatedResult.FailedResult('No lines to confirm.');
    }

    private static CreateRelatedResult cancelPicking(
        List<dmpl__InventoryFulfillmentPickingLine__c> inventoryFulfillmentPickingLines,
        List<SourceObjectInfo> orderLinesInfo){
        if(inventoryFulfillmentPickingLines.size() == 0){
            throw new DMPLException(
                String.format(
                    String.valueOf(
                        System.Label.Generic_EmptyActionParam), 
                    new String[]{dmpl__InventoryFulfillmentPickingLine__c.class.getName()}));
        }
        List<dmpl__InventoryFulfillmentPickingLine__c> pickingLines = new List<dmpl__InventoryFulfillmentPickingLine__c>();
        for(dmpl__InventoryFulfillmentPickingLine__c pickingLine : inventoryFulfillmentPickingLines){
            if(pickingLine.dmpl__PickedQuantity__c > 0){
                Decimal requestedQty =0;
                if(orderLinesInfo!=null){
                    requestedQty = SourceObjectInfo.getRequestedQuantity(orderLinesInfo, pickingLine.Id);
                }else{
                    requestedQty = pickingLine.dmpl__PickedQuantity__c;
                }
                dmpl__InventoryFulfillmentPickingLine__c line = createPickingLineForCancellation(
                    pickingLine, 
                    requestedQty);
                if(orderLinesInfo!=null){
                    SourceObjectInfo info = SourceObjectInfo.getSourceObjectInfo(orderLinesInfo, pickingLine.Id);
                    if(info.fields!=null){
                        for(SourceObjectField srcField : info.fields){
                            line.put(srcField.fieldName, srcField.fieldValue);
                        }
                    }
                }
                pickingLines.add(line);    
            } 
        }
        
        if(pickingLines.size() >0){
            Savepoint sp = Database.setSavepoint();
            try {
                skipValidations = true;
                insert pickingLines;
                return CreateRelatedResult.SuccessResult();
            } catch (Exception e) {
                Database.rollback(sp);
                throw new DMPLException(e.getMessage());
            } finally{
                skipValidations = false;
            }
        }
        return CreateRelatedResult.FailedResult('No lines to cancel.');
    }

    private static List<dmpl__InventoryFulfillmentAllocationLine__c> queryAllocationLinesForPicking(
        List<Id> inventoryFulfillmentIds, 
        List<Id> inventoryFulfillmentAllocationLineIds){
        if(inventoryFulfillmentAllocationLineIds == null){
            inventoryFulfillmentAllocationLineIds = new List<Id>();
        }
        if(inventoryFulfillmentIds == null){
            inventoryFulfillmentIds = new List<Id>();
        }
        SecurityHelper.ensureCanReadFields(new string[]{
            'dmpl__BranchId__c',
            'dmpl__PartnerAccountId__c'
        }, 'dmpl__InventoryFulfillment__c');
        SecurityHelper.ensureCanReadFields(new string[]{
            'dmpl__Quantity__c',
            'dmpl__ItemId__c',
            'dmpl__SKUId__c',
            'dmpl__ItemLotId__c',
            'dmpl__ItemLotTypeId__c',
            'dmpl__PickedQuantity__c',
            'dmpl__PendingPickingQuantity__c',
            'dmpl__UnitCost__c',
            'dmpl__SaleOrderLineId__c',
            'dmpl__StorageLocationId__c'
        }, 'dmpl__InventoryFulfillmentAllocationLine__c');
        return [SELECT ID,
            Name,
            dmpl__FulfillmentOrderId__r.dmpl__BranchId__c,
            dmpl__FulfillmentOrderId__r.dmpl__PartnerAccountId__c,
            dmpl__PendingPickingQuantity__c,
            dmpl__PickedQuantity__c,
            dmpl__Quantity__c ,
            dmpl__ItemId__c,
            dmpl__ItemLotId__c,
            dmpl__SKUId__c,
            dmpl__ItemLotTypeId__c,
            dmpl__UnitCost__c,
            dmpl__SaleOrderLineId__c,
            dmpl__StorageLocationId__c
        FROM
            dmpl__InventoryFulfillmentAllocationLine__c 
        WHERE 
            dmpl__FulfillmentOrderId__c IN : inventoryFulfillmentIds 
            OR ID IN: inventoryFulfillmentAllocationLineIds];
    }

    private static List<dmpl__InventoryFulfillmentPickingLine__c> queryPickingLines(
        List<Id> inventoryFulfillmentIds, 
        List<Id> inventoryFulfillmentPickingLineIds)
    {
        if(inventoryFulfillmentIds == null){
            inventoryFulfillmentIds = new List<Id>();
        }

        if(inventoryFulfillmentPickingLineIds == null){
            inventoryFulfillmentPickingLineIds = new List<Id>();
        }

        SecurityHelper.ensureCanReadFields(new string[]{
            'dmpl__PickedQuantity__c',
            'dmpl__ItemId__c',
            'dmpl__SKUId__c',
            'dmpl__ItemLotTypeId__c',
            'dmpl__FulfillmentAllocationLineId__c',
            'dmpl__FulfillmentOrderId__c',
            'dmpl__ItemLotId__c',
            'dmpl__RequestedQuantity__c',
            'dmpl__Quantity__c',
            'dmpl__UnitCost__c',
            'dmpl__StorageLocationId__c',
            'dmpl__StockId__c',
            'dmpl__SaleOrderLineId__c',
            'dmpl__IsPickingConfirmed__c',
            'dmpl__ParentFulfillmentPickingLineId__c'
        }, 'dmpl__InventoryFulfillmentPickingLine__c');
        return [SELECT ID,
            Name,
            dmpl__FulfillmentAllocationLineId__c,
            dmpl__FulfillmentOrderId__c,
            dmpl__ItemId__c,
            dmpl__ItemLotId__c,
            dmpl__SKUId__c,
            dmpl__ItemLotTypeId__c,
            dmpl__RequestedQuantity__c,
            dmpl__Quantity__c,
            dmpl__PickedQuantity__c,
            dmpl__ReturnedQuantity__c,
            dmpl__StockId__c,
            dmpl__StorageLocationId__c,
            dmpl__UnitCost__c,
            dmpl__IsPickingConfirmed__c,
            dmpl__SaleOrderLineId__c,
            dmpl__ParentFulfillmentPickingLineId__c
        FROM
            dmpl__InventoryFulfillmentPickingLine__c 
        WHERE 
                dmpl__FulfillmentOrderId__c IN : inventoryFulfillmentIds 
                OR ID IN: inventoryFulfillmentPickingLineIds];
    }

    @testVisible 
    private static dmpl__InventoryFulfillmentPickingLine__c createPickingLineFromAllocation(
        dmpl__InventoryFulfillmentAllocationLine__c allocationLine,
        Decimal pickingQty){
        return new dmpl__InventoryFulfillmentPickingLine__c(
            dmpl__FulfillmentAllocationLineId__c = allocationLine.Id,
            dmpl__FulfillmentOrderId__c = allocationLine.dmpl__FulfillmentOrderId__c,
            dmpl__SaleOrderLineId__c = allocationLine.dmpl__SaleOrderLineId__c,
            dmpl__ItemId__c = allocationLine.dmpl__ItemId__c,
            dmpl__ItemLotId__c = allocationLine.dmpl__ItemLotId__c,
            dmpl__SKUId__c = allocationLine.dmpl__SKUId__c,
            dmpl__ItemLotTypeId__c = allocationLine.dmpl__ItemLotTypeId__c,
            dmpl__RequestedQuantity__c = pickingQty,
            dmpl__StorageLocationId__c = allocationLine.dmpl__StorageLocationId__c,
            dmpl__UnitCost__c = allocationLine.dmpl__UnitCost__c,
            dmpl__IsILPostingApproved__c = true
        );
    }

    @testVisible 
    private static dmpl__InventoryFulfillmentPickingLine__c createPickingLineForCancellation(
        dmpl__InventoryFulfillmentPickingLine__c pickingLine,
        Decimal requestedQty){
        return new dmpl__InventoryFulfillmentPickingLine__c(
            dmpl__FulfillmentAllocationLineId__c = pickingLine.dmpl__FulfillmentAllocationLineId__c,
            dmpl__FulfillmentOrderId__c = pickingLine.dmpl__FulfillmentOrderId__c,
            dmpl__ItemId__c = pickingLine.dmpl__ItemId__c,
            dmpl__ItemLotId__c = pickingLine.dmpl__ItemLotId__c,
            dmpl__SKUId__c = pickingLine.dmpl__SKUId__c,
            dmpl__ItemLotTypeId__c = pickingLine.dmpl__ItemLotTypeId__c,
            dmpl__Quantity__c = requestedQty * -1,
            dmpl__StorageLocationId__c = pickingLine.dmpl__StorageLocationId__c,
            dmpl__UnitCost__c = pickingLine.dmpl__UnitCost__c,
            dmpl__StockId__c = pickingLine.dmpl__StockId__c,
            dmpl__IsILPostingApproved__c = true,
            dmpl__IsPickingConfirmed__c = true,
            dmpl__ParentFulfillmentPickingLineId__c = pickingLine.Id
        );
    }

    private static void validateItem(
        List<dmpl__InventoryFulfillmentPickingLine__c> newEntries){
        Map<Id, dmpl__Item__c> items = new Map<Id,dmpl__Item__c>(
            ItemHelper.getCachedItems(
                DocumentHelper.extractIds(
                    newEntries, 
                    FIELD_INVENTORYPICKINGLINE_ITEMID)));
        for(dmpl__InventoryFulfillmentPickingLine__c orderLine : newEntries){
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

    private static void validateFulfillmentAllocationLine(
        List<dmpl__InventoryFulfillmentPickingLine__c> newEntries){
            for(dmpl__InventoryFulfillmentPickingLine__c orderLine : newEntries){
                if(orderLine.dmpl__FulfillmentAllocationLineId__c == null){
                    orderLine.addError('Picking can only be created from an Allocation Line!');
                }
            }
        }
}