public with sharing  class InventoryCycleCountHelper extends TriggerHandler {

    private static final Integer MAX_ITEM_COUNT = 2000;
    private static final List<String> LIST_FIELDS_SYSTEM = new List<String>{};
    private static final List<String> LIST_NON_EDITABLE_FIELDS = new List<String>{
        InventoryCycleCountService.FIELD_INVENTORYCYCLECOUNT_BRANCHID, 
        InventoryCycleCountService.FIELD_INVENTORYCYCLECOUNT_DOCUMENTDATE, 
        InventoryCycleCountService.FIELD_INVENTORYCYCLECOUNT_PARTNERACCOUNTID};
    
    private InventoryCycleCountService iccs;
    private List<dmpl__InventoryCycleCount__c> triggerNew;
    private List<dmpl__InventoryCycleCount__c> triggerOld;
    private Map<Id, dmpl__InventoryCycleCount__c> triggerMapNew;
    private Map<Id, dmpl__InventoryCycleCount__c> triggerMapOld;

    public InventoryCycleCountHelper() {
        this.iccs = new InventoryCycleCountService();
        this.triggerOld = (List<dmpl__InventoryCycleCount__c>) Trigger.old;
        this.triggerNew = (List<dmpl__InventoryCycleCount__c>) Trigger.new;
        this.triggerMapNew = (Map<Id, dmpl__InventoryCycleCount__c>) Trigger.newMap;
        this.triggerMapOld = (Map<Id, dmpl__InventoryCycleCount__c>) Trigger.oldMap;
    }

    public override void beforeInsert(){
        if(!IsValidationSkipped()){
            StatusHelper.validateStatusNew(
                InventoryCycleCountService.OBJECT_INVENTORYCYCLECOUNT, 
                InventoryCycleCountService.FIELD_INVENTORYCYCLECOUNT_STATUS, 
                triggerNew);
            DocumentHelper.validateChangeInSystemFields(
                LIST_FIELDS_SYSTEM, triggerNew);
            ValidationHelper.validatePartnerAndBranch(
                InventoryCycleCountService.FIELD_INVENTORYCYCLECOUNT_PARTNERACCOUNTID, 
                InventoryCycleCountService.FIELD_INVENTORYCYCLECOUNT_BRANCHID, 
                triggerNew);
            ValidationHelper.validateResource(
                InventoryCycleCountService.FIELD_INVENTORYCYCLECOUNT_ASSIGNEDTOID, 
                triggerNew);
        }
        DocumentNameHelper.generateDocumentName(triggerNew);
    }

    public override void beforeUpdate(){
        if(!IsValidationSkipped()){
            DocumentStatusDFSHelper dfsHelper = new DocumentStatusDFSHelper();
            StatusHelper.validateStatusEdit(
                InventoryCycleCountService.OBJECT_INVENTORYCYCLECOUNT, 
                InventoryCycleCountService.FIELD_INVENTORYCYCLECOUNT_STATUS, 
                triggerOld, 
                triggerNew);
            DocumentHelper.validateChangeInKeyFields(
                LIST_NON_EDITABLE_FIELDS, 
                triggerOld, 
                triggerNew);
            DocumentHelper.validateChangeInSystemFields(
                LIST_FIELDS_SYSTEM, 
                triggerOld, 
                triggerNew);
            dfsHelper.DocumentStatusRestrictEdits_Edit(
                InventoryCycleCountService.OBJECT_INVENTORYCYCLECOUNT, 
                InventoryCycleCountService.FIELD_INVENTORYCYCLECOUNT_STATUS, 
                triggerOld, 
                triggerNew);
            dfsHelper.DocumentStatusRestrictFieldsEdits(
                InventoryCycleCountService.OBJECT_INVENTORYCYCLECOUNT, 
                InventoryCycleCountService.FIELD_INVENTORYCYCLECOUNT_STATUS, 
                triggerOld, 
                triggerNew);
            ValidationHelper.validateResource(
                InventoryCycleCountService.FIELD_INVENTORYCYCLECOUNT_ASSIGNEDTOID, 
                triggerNew);
        }
        List<dmpl__InventoryCycleCount__c> modifiedObjects = DocumentHelper.getApprovedObjects(
            InventoryCycleCountService.FIELD_INVENTORYCYCLECOUNT_PERFORMSTARTCOUNTING, 
            triggerOld, 
            triggerNew);
        if(modifiedObjects.size() > 0){
            performStartCounting(modifiedObjects);
        }

        modifiedObjects = DocumentHelper.getApprovedObjects(
            InventoryCycleCountService.FIELD_INVENTORYCYCLECOUNT_PERFORMFINISHCOUNTING, 
            triggerOld, 
            triggerNew);
        if(modifiedObjects.size() > 0){
            performFinishCounting(modifiedObjects);
        }

        modifiedObjects = DocumentHelper.getApprovedObjects(
            InventoryCycleCountService.FIELD_INVENTORYCYCLECOUNT_PERFORMRELEASEADJUSTMENT, 
            triggerOld, 
            triggerNew);
        if(modifiedObjects.size() > 0){
            releaseAdjustment(modifiedObjects);
        }
    }

    public override void beforeDelete(){
        if(!IsValidationSkipped()){
            DocumentStatusDFSHelper dfsHelper = new DocumentStatusDFSHelper();
            dfsHelper.DocumentStatusRestrictEdits_Delete(
                InventoryCycleCountService.OBJECT_INVENTORYCYCLECOUNT, 
                InventoryCycleCountService.FIELD_INVENTORYCYCLECOUNT_STATUS, 
                triggerOld);
        }
    }
 
    public override void afterInsert(){
        List<dmpl__InventoryCycleCount__c> modifiedObjects 
            = (List<dmpl__InventoryCycleCount__c>)CollectionHelper.getObjectsWithNotNull(
                triggerNew,
                new List<String>{
                    InventoryCycleCountService.FIELD_INVENTORYCYCLECOUNTLINE_ITEMGROUPID,
                    InventoryCycleCountService.FIELD_INVENTORYCYCLECOUNTLINE_ITEMID,
                    InventoryCycleCountService.FIELD_INVENTORYCYCLECOUNT_ABCFILTER,
                    InventoryCycleCountService.FIELD_INVENTORYCYCLECOUNT_FSNFILTER
                });
        if(modifiedObjects.size() > 0){
            createCycleCountLines(modifiedObjects);
        }
    }

    @testvisible
    private void performStartCounting(
        List<dmpl__InventoryCycleCount__c> modifiedObjects){
            startCounting(
                modifiedObjects);
            for(dmpl__InventoryCycleCount__c lineEntry : modifiedObjects){
                lineEntry.dmpl__PerformStartCounting__c = false;
                lineEntry.dmpl__IsCountingStarted__c = true;
            }
            lockUnlockTransactions(
                true,
                CollectionHelper.getApprovedObjects(
                    InventoryCycleCountService.FIELD_INVENTORYCYCLECOUNT_LOCKINVETORY, 
                    modifiedObjects));
    }

    @testvisible
    private void performFinishCounting(
        List<dmpl__InventoryCycleCount__c> modifiedObjects){
            finishCounting(modifiedObjects);
            for(dmpl__InventoryCycleCount__c lineEntry : modifiedObjects){
                lineEntry.dmpl__PerformFinishCounting__c = false;
                lineEntry.dmpl__IsCountingFinished__c = true;    
            }
            lockUnlockTransactions(
                false,
                CollectionHelper.getApprovedObjects(
                    InventoryCycleCountService.FIELD_INVENTORYCYCLECOUNT_LOCKINVETORY, 
                    modifiedObjects));
    }

    private void lockUnlockTransactions(
        Boolean lock,
        List<dmpl__InventoryCycleCount__c> modifiedObjects){
            List<dmpl__InventoryCycleCountLine__c> lines = iccs.queryObjectsForType(
                'dmpl__InventoryCycleCountLine__c',
                new List<String> { 
                    'dmpl__InventoryStockId__c', 
                    'dmpl__ItemLotId__c'},
                'dmpl__CycleCountId__c',
                DocumentHelper.extractIds(
                    modifiedObjects));
            List<dmpl__InventoryStock__c> itemStocks = iccs.queryObjectsForType(
                'dmpl__InventoryStock__c',
                'dmpl__IsTransactionLocked__c',
                DocumentHelper.extractIds(
                    lines,
                    'dmpl__InventoryStockId__c'));
            for(dmpl__InventoryStock__c stock : itemStocks){
                stock.dmpl__IsTransactionLocked__c = lock;
            }

            InventoryStockHandler.skipLockCheck = true;
            update itemStocks;
            InventoryStockHandler.skipLockCheck = false;
            List<dmpl__ItemLot__c> itemLots = iccs.queryObjectsForType(
                'dmpl__ItemLot__c',
                'dmpl__IsTransactionLocked__c', 
                DocumentHelper.extractIds(
                    lines,
                    'dmpl__ItemLotId__c'));
            for(dmpl__ItemLot__c itemLot : itemLots){
                itemLot.dmpl__IsTransactionLocked__c = lock;
            }
            ItemLotHelper.skipLockCheck = true;
            update itemLots;
            ItemLotHelper.skipLockCheck = false;
    }

    @testvisible
    private void releaseAdjustment(
        List<dmpl__InventoryCycleCount__c> modifiedObjects){
            List<dmpl__InventoryCycleCountLine__c> relatedCycleCountLines = iccs.queryObjectsForType(
                InventoryCycleCountService.OBJECT_INVENTORYCYCLECOUNTLINE,
                InventoryCycleCountService.FIELD_INVENTORYCYCLECOUNTLINE_CYCLECOUNTID,
                InventoryCycleCountService.FIELD_INVENTORYCYCLECOUNTLINE_CYCLECOUNTID,
                DocumentHelper.extractIds(modifiedObjects));
            for(dmpl__InventoryCycleCount__c cycleCount : modifiedObjects){
                List<dmpl__InventoryCycleCountLine__c> currentCycleCountLines = DocumentHelper.getObjectsByFilter(
                    relatedCycleCountLines, 
                    InventoryCycleCountService.FIELD_INVENTORYCYCLECOUNTLINE_CYCLECOUNTID, 
                    cycleCount.Id);
                if(currentCycleCountLines.size() == 0){
                    cycleCount.addError(System.label.DocumentValidation_NoDiscrepancyFound);
                }
            }
            InventoryAdjustmentHelper.createAdjustmentFromInventoryCycleCount(modifiedObjects);
            for(dmpl__InventoryCycleCount__c lineEntry : modifiedObjects){
                lineEntry.dmpl__PerformReleaseAdjustment__c = false;
                lineEntry.dmpl__IsAdjustmentReleased__c = true;
            }
    }

    public void startCounting(
        List<dmpl__InventoryCycleCount__c> inventoryCycleCounts){
    }

    public void finishCounting(
        List<dmpl__InventoryCycleCount__c> inventoryCycleCounts){
        List<dmpl__InventoryCycleCountLine__c> inventoryCycleCountLines = iccs.queryObjectsForType(
            InventoryCycleCountService.OBJECT_INVENTORYCYCLECOUNTLINE,
            InventoryCycleCountService.FIELD_INVENTORYCYCLECOUNTLINE_ISAPPROVED,
            InventoryCycleCountService.FIELD_INVENTORYCYCLECOUNTLINE_CYCLECOUNTID,
            DocumentHelper.extractIds(inventoryCycleCounts));
        for(dmpl__InventoryCycleCountLine__c lineEntry : inventoryCycleCountLines){
            lineEntry.dmpl__IsApproved__c = true;
        }

        update inventoryCycleCountLines;
    }

    @testVisible
    private void createCycleCountLines(
        List<dmpl__InventoryCycleCount__c> inventoryCycleCounts){
        for(dmpl__InventoryCycleCount__c inventoryCycleCount : inventoryCycleCounts){
            List<dmpl__InventoryCycleCountLine__c> newLines 
                = new List<dmpl__InventoryCycleCountLine__c>();
            List<dmpl__Item__c> applicableItems = queryItems(
                inventoryCycleCount);
            for(dmpl__Item__c item : applicableItems){
                if(item.dmpl__ItemLots__r.size()>0){
                    newLines.addAll(
                        createCycleCountLinesForLot(
                            inventoryCycleCount, 
                            item));
                } else if(item.dmpl__Stock__r.size()>0){
                    newLines.addAll(
                        createCycleCountLineForStock(
                            inventoryCycleCount, 
                            item));
                } else {
                    newLines.add(
                        createCycleCountLine(
                            inventoryCycleCount, 
                            item));
                }
            }
            if(newLines.size() > 0){
                try {
                    SecurityHelper.ensureCanWriteFields(new string[]{
                        'dmpl__ItemId__c',
                        'dmpl__SKUId__c',
                        'dmpl__ItemLotTypeId__c',
                        'dmpl__StorageLocationId__c',
                        'dmpl__OnHandQuantity__c',
                        'dmpl__PickedQuantity__c',
                        'dmpl__ItemLotId__c',
                        'dmpl__UnitCost__c'
                    }, 'dmpl__InventoryCycleCountLine__c');
                    setSkipValidation();
                    insert newLines;
                } catch(Exception error){
                    ExceptionLogHelper.logException(error);
                    throw error;
                } finally{
                    clearSkipValidation();
                }
            }
        }
    }

    @testVisible 
    private dmpl__InventoryCycleCountLine__c createCycleCountLine(
        dmpl__InventoryCycleCount__c cycleCount,
        dmpl__Item__c item){
        return new dmpl__InventoryCycleCountLine__c(
            dmpl__CycleCountId__c = cycleCount.Id,
            dmpl__ItemId__c = item.Id,
            dmpl__OnHandQuantity__c = 0,
            dmpl__PickedQuantity__c = 0
        );
    }

    @testVisible 
    private List<dmpl__InventoryCycleCountLine__c> createCycleCountLineForStock(
        dmpl__InventoryCycleCount__c cycleCount,
        dmpl__Item__c item){
            List<dmpl__InventoryCycleCountLine__c> lines = new List<dmpl__InventoryCycleCountLine__c>();
            for(dmpl__InventoryStock__c stock : item.dmpl__Stock__r){
                lines.add(
                    new dmpl__InventoryCycleCountLine__c(
                        dmpl__InventoryStockId__c = stock.Id,
                        dmpl__CycleCountId__c = cycleCount.Id,
                        dmpl__ItemId__c = item.Id,
                        dmpl__SKUId__c = stock.dmpl__SKUId__c,
                        dmpl__StorageLocationId__c = stock.dmpl__StorageLocationId__c,
                        dmpl__OnHandQuantity__c = 
                        cycleCount.dmpl__CountQuantityType__c == 'Quantity Available' ? stock.dmpl__QuantityAvailable__c : 
                        cycleCount.dmpl__CountQuantityType__c == 'Actual Quantity' ?  stock.dmpl__QuantityInHand__c 
                            - (stock.dmpl__QuantityPicked__c == null ? 0 : stock.dmpl__QuantityPicked__c) 
                            - (stock.dmpl__QuantityInTransit__c == null ? 0 : stock.dmpl__QuantityInTransit__c) 
                            - (stock.dmpl__QuantityOnOutward__c == null ? 0 : stock.dmpl__QuantityOnOutward__c) :
                        stock.dmpl__QuantityInHand__c,
                        dmpl__PickedQuantity__c = 0
                    )
                );
            }
            return lines;
    }

    @testVisible 
    private List<dmpl__InventoryCycleCountLine__c> createCycleCountLinesForLot(
        dmpl__InventoryCycleCount__c cycleCount,
        dmpl__Item__c item){
            List<dmpl__InventoryCycleCountLine__c> lines = new List<dmpl__InventoryCycleCountLine__c>();
            for(dmpl__ItemLot__c itemLot : item.dmpl__ItemLots__r){
                lines.add(
                    new dmpl__InventoryCycleCountLine__c(
                        dmpl__CycleCountId__c = cycleCount.Id,
                        dmpl__ItemId__c = item.Id,
                        dmpl__SKUId__c = itemLot.dmpl__SKUId__c,
                        dmpl__ItemLotTypeId__c = itemLot.dmpl__ItemLotTypeId__c,
                        dmpl__StorageLocationId__c = itemLot.dmpl__StorageLocationId__c,
                        dmpl__OnHandQuantity__c = 
                        cycleCount.dmpl__CountQuantityType__c == 'Quantity Available' ? itemLot.dmpl__QuantityAvailable__c : 
                        cycleCount.dmpl__CountQuantityType__c == 'Actual Quantity' ? itemLot.dmpl__QuantityInHand__c 
                            - (itemLot.dmpl__QuantityPicked__c == null ? 0 : itemLot.dmpl__QuantityPicked__c) 
                            - (itemLot.dmpl__QuantityOnOutward__c == null ? 0 : itemLot.dmpl__QuantityOnOutward__c) :
                        itemLot.dmpl__QuantityInHand__c,
                        dmpl__PickedQuantity__c = 0,
                        dmpl__ItemLotId__c = itemLot.Id
                    )
                );
            }
            return lines;
    }

    public void deleteCycleCountLinesFromCycleCount(
        List<dmpl__InventoryCycleCount__c> cycleCounts){
        SecurityHelper.ensureCanDeleteObject('dmpl__InventoryCycleCountLine__c');
        DELETE [
            SELECT Id 
            FROM dmpl__InventoryCycleCountLine__c 
            WHERE 
                dmpl__CycleCountId__c IN : DocumentHelper.extractIds(cycleCounts)];
    }

    private List<dmpl__Item__c> queryItems(
        dmpl__InventoryCycleCount__c cycleCount){
        dmpl__InventoryCycleCount__c cc = cycleCount;
        Integer maxItems = cycleCount.dmpl__MaximumItems__c == null 
            ? MAX_ITEM_COUNT 
            : (Integer)cycleCount.dmpl__MaximumItems__c;
        SecurityHelper.ensureCanReadFields(new string[]{
            'dmpl__TrackInventory__c',
            'dmpl__TrackLots__c',
            'dmpl__ABCCategory__c',
            'dmpl__FSNCategory__c'
        }, 'dmpl__Item__c');
        String selectQuery = 'SELECT Id, Name,'
            + ' dmpl__TrackInventory__c, dmpl__TrackLots__c,'
            + ' dmpl__ABCCategory__c, dmpl__FSNCategory__c,'
            + ' (SELECT Id, Name, dmpl__ItemId__c, '
                + ' dmpl__ItemLotTypeId__c, dmpl__BranchId__c, '
                + ' dmpl__QuantityInHand__c, dmpl__QuantityAvailable__c,dmpl__QuantityInTransit__c, dmpl__QuantityPicked__c, dmpl__QuantityOnOutward__c, dmpl__Cost__c, '
                + ' dmpl__SKUId__c, dmpl__StorageLocationId__c, '
                + ' dmpl__UnitCost__c FROM dmpl__ItemLots__r ' 
                + ' WHERE dmpl__PartnerAccountId__c = \'' + cc.dmpl__PartnerAccountId__c + '\''
                + ' AND dmpl__BranchId__c = \'' + cc.dmpl__BranchId__c + '\'),'
            + ' (SELECT Id, Name, dmpl__BranchId__c, ' 
            + ' dmpl__ItemId__c, dmpl__QuantityInHand__c, dmpl__QuantityInTransit__c, dmpl__QuantityAvailable__c, dmpl__QuantityPicked__c, dmpl__QuantityOnOutward__c, '  
                + ' dmpl__SKUId__c, dmpl__StorageLocationId__c, ' 
                + ' dmpl__StorageLocationId__r.Name'
                + ' FROM dmpl__Stock__r' 
                + ' WHERE dmpl__PartnerAccountId__c = \'' + cc.dmpl__PartnerAccountId__c + '\''
                + ' AND dmpl__BranchId__c = \'' + cc.dmpl__BranchId__c + '\'';
        if(cycleCount.dmpl__StorageLocationId__c != null){
            selectQuery += ' AND dmpl__StorageLocationId__c = \'' + cc.dmpl__StorageLocationId__c + '\')';
        }else {
            selectQuery += ' )';
        }
        selectQuery += ' FROM dmpl__Item__c ';
        List<String> conditions = new List<String>{
            ' dmpl__TrackInventory__c = true '
        };
        if(cycleCount.dmpl__ItemId__c!=null){
            conditions.add(' Id = \'' + cc.dmpl__ItemId__c + '\'');
        }
        if(cycleCount.dmpl__ItemGroupId__c != null){
            conditions.add(' Id IN (SELECT dmpl__ItemId__c FROM dmpl__ItemGroupMember__c WHERE dmpl__ItemGroupId__c = \'' + cc.dmpl__ItemGroupId__c + '\')');
        }
        if(cycleCount.dmpl__FilterABC__c != null){
            conditions.add(' dmpl__ABCCategory__c = \'' + cc.dmpl__FilterABC__c + '\'');
        }
        if(cycleCount.dmpl__FilterFSN__c != null){
            conditions.add(' dmpl__FSNCategory__c = \'' + cc.dmpl__FilterFSN__c + '\'');
        }
        if(conditions.size() > 0){
            selectQuery += ' WHERE ' + String.join(conditions, ' AND ');
        }
        selectQuery +=  ' LIMIT ' + maxItems;
        System.debug(JSON.serializePretty(selectQuery));
        return (List<dmpl__Item__c>)Database.query(selectQuery);
        //ToDO
        //dmpl__PartCostFrom__c, dmpl__PartCostTo__c, dmpl__PartStockFrom__c, dmpl__PartStockTo__c
    }  
}