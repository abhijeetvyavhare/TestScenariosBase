public with sharing class InventoryAdjustmentLineHelper {
    
    private static Boolean skipValidations = false;
    private static Boolean skipComponentDeleteValidation = false;

    private static final string OBJECT_ADJUSTMENT = 'dmpl__InventoryAdjustment__c';
    private static final string OBJECT_ADJUSTMENTLINE = 'dmpl__InventoryAdjustmentLine__c';
    private static final string FIELD_ADJUSTMENTLINE_INVENTORYLEDGERID = 'dmpl__InventoryLedgerId__c';
    private static final string FIELD_ADJUSTMENTLINE_ISILPOSTED = 'dmpl__IsILPosted__c';
    private static final string FIELD_ADJUSTMENTLINE_ISILPOSTINGAPPROVED ='dmpl__IsILPostingApproved__c';
    private static final string FIELD_ADJUSTMENTLINE_ITEMID ='dmpl__ItemId__c';
    private static final string FIELD_ADJUSTMENTLINE_ITEMLOTID ='dmpl__ItemLotId__c';
    private static final string FIELD_ADJUSTMENTLINE_SKUID ='dmpl__SKUId__c';
    private static final string FIELD_ADJUSTMENTLINE_QUANTITY ='dmpl__Quantity__c';
    private static final string FIELD_ADJUSTMENTLINE_STORAGELOCATIONID ='dmpl__StorageLocationId__c';
    private static final string FIELD_ADJUSTMENTLINE_ADJUSTMENTTYPE ='dmpl__AdjustmentType__c';
    private static final string FIELD_INVENTORYCYCLECOUNTLINE_CYCLECOUNTID = 'dmpl__CycleCountId__c';

    private static final string FIELD_ADJUSTMENTLINELINE_ADJUSTMENTID ='dmpl__InventoryAdjustmentId__c';
    private static final string RELATION_ADJUSTMENTLINE_ADJUSTMENT = 'dmpl__InventoryAdjustmentId__r';
    private static final string RELATION_ADJUSTMENT_STATUS = 'dmpl__InventoryAdjustmentId__r.dmpl__Status__c';
    
    private static final List<String> LIST_FIELDS_SOURCEPOULATED = new List<String>{
        FIELD_ADJUSTMENTLINE_ITEMID, 
        FIELD_ADJUSTMENTLINE_ITEMLOTID,
        FIELD_ADJUSTMENTLINE_SKUID,
        FIELD_ADJUSTMENTLINE_STORAGELOCATIONID
    };
    
    private static final List<String> LIST_FIELDS_SYSTEM = new List<String>{
        FIELD_ADJUSTMENTLINE_INVENTORYLEDGERID,
        FIELD_ADJUSTMENTLINE_ISILPOSTED
    };

    private static final List<String> LIST_FIELDS_NEGATIVEANDZERONOTALLOWED = new List<String>{
        
    };
    
    private static final List<String> LIST_FIELDS_NEGATIVENOTALLOWED = new List<String>{
        
    };

    private static final Decimal ASYNC_POST_THRESHOLD = 10;

    public static void validateData(
        Boolean isInsert, 
        Boolean isDelete, 
        Boolean isUpdate, 
        List<dmpl__InventoryAdjustmentLine__c> oldEntries, 
        List<dmpl__InventoryAdjustmentLine__c> newEntries){ 
        try {
            if(isInsert){
                FieldMappingHelper.copyFieldMappingData(
                    newEntries);
            }
            if(isInsert || isUpdate){   
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
            DocumentStatusDFSHelper dfsHelper = new DocumentStatusDFSHelper();
            InventoryRuleDFSHelper ifsHelper = new InventoryRuleDFSHelper();
            if(isInsert){
                validateItem(newEntries);
                List<Item__c> items = queryItems(newEntries);
                ifsHelper.checkInventoryTracking(newEntries, items);
                ifsHelper.checkInventoryLotTracking(newEntries, items);
                dfsHelper.DocumentStatusRelatedObjectRestrictEdits_New(OBJECT_ADJUSTMENT, OBJECT_ADJUSTMENTLINE, RELATION_ADJUSTMENT_STATUS, newEntries);
            }else if(isUpdate){
                List<Item__c> items = queryItems(newEntries);
                ifsHelper.checkInventoryTracking(newEntries, items);
                ifsHelper.checkInventoryLotTracking(newEntries, items);
                DocumentHelper.validateChangeInSystemFields(LIST_FIELDS_SYSTEM, oldEntries, newEntries);
                DocumentHelper.validateChangeInSourcePopulatedFields(LIST_FIELDS_SOURCEPOULATED, oldEntries, newEntries, querySourcePopulatedEntries(DocumentHelper.extractIds(newEntries)), FIELD_ADJUSTMENTLINELINE_ADJUSTMENTID);
                dfsHelper.DocumentStatusRelatedObjectRestrictEdits_Edit(OBJECT_ADJUSTMENT, OBJECT_ADJUSTMENTLINE, RELATION_ADJUSTMENT_STATUS, oldEntries, newEntries);
            }else if(isDelete){
                dfsHelper.DocumentStatusRelatedObjectRestrictEdits_Delete(OBJECT_ADJUSTMENT, OBJECT_ADJUSTMENTLINE, RELATION_ADJUSTMENT_STATUS, oldEntries);
            }
        } catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }

    public static void postData(Boolean isInsert, Boolean isDelete, Boolean isUpdate, List<dmpl__InventoryAdjustmentLine__c> oldEntries, List<dmpl__InventoryAdjustmentLine__c> newEntries)
    {
        try{
            List<dmpl__InventoryAdjustmentLine__c> modifiedObjects = new List<dmpl__InventoryAdjustmentLine__c>();
            if(isInsert){
                setItemData(
                    newEntries);
                PriceListHelper.setApplicablePrices(
                    newEntries, 
                    queryAdjustmentDocument(
                        DocumentHelper.extractIds(
                            newEntries, 
                            'dmpl__InventoryAdjustmentId__c')), 
                    ItemHelper.getCachedItems(
                        DocumentHelper.extractIds(
                            newEntries, 
                            'dmpl__ItemId__c')),
                    false);
            } else if(isUpdate){
                modifiedObjects = DocumentHelper.getModifiedNewObjects(
                    new List<String>{
                        'dmpl__PriceListId__c',
                        'dmpl__PriceAsOnDate__c'
                    }, 
                    oldEntries, 
                    newEntries);
                if(modifiedObjects.size()>0){
                    PriceListHelper.setApplicablePrices(
                        modifiedObjects, 
                        queryAdjustmentDocument(
                            DocumentHelper.extractIds(
                                modifiedObjects, 
                                'dmpl__InventoryAdjustmentId__c')), 
                        ItemHelper.getCachedItems(
                            DocumentHelper.extractIds(
                                modifiedObjects, 
                                'dmpl__ItemId__c')), 
                        true);
                }   
                 modifiedObjects = DocumentHelper.getModifiedNewObjects(
                        new string[]{
                            'dmpl__Quantity__c',
                            'dmpl__UOM__c',
                            'dmpl__UOM1__c', 
                            'dmpl__UOMQuantity__c',
                            'dmpl__UOMQuantity1__c'
                        }, 
                        oldEntries, 
                        newEntries); 
                    Map<Id, dmpl__Item__c> items = new Map<Id,dmpl__Item__c>(
                        ItemHelper.getCachedItems(
                        DocumentHelper.extractIds(
                            newEntries, 
                            'dmpl__ItemId__c')));
                            if(modifiedObjects.size()>0){
                                ItemHelper.setQuantityFromUOM(newEntries, oldEntries, items);
                            }                                   
            }


            modifiedObjects = DocumentHelper.getPostedObjects(FIELD_ADJUSTMENTLINE_ISILPOSTINGAPPROVED, oldEntries, newEntries); 
            if(modifiedObjects.size() > 0)
            {
                List<dmpl__InventoryAdjustmentLine__c> adjustmentEntries = DocumentHelper.getObjectsByFilter(modifiedObjects, 'dmpl__AdjustmentType__c','Damaged');
                if(adjustmentEntries.size() > 0)
                    InventoryLedgerHelper.createLedger(InventoryLedgerTypeEnums.Damaged, 'dmpl__InventoryAdjustmentId__c', 'dmpl__InventoryAdjustment__c', isInsert, isDelete, isUpdate, isDelete ? adjustmentEntries : oldEntries, isInsert || isUpdate ? adjustmentEntries : newEntries);
                
                adjustmentEntries = DocumentHelper.getObjectsByFilter(modifiedObjects, 'dmpl__AdjustmentType__c','Shortage');
                if(adjustmentEntries.size() > 0)
                    InventoryLedgerHelper.createLedger(InventoryLedgerTypeEnums.Shortage, 'dmpl__InventoryAdjustmentId__c', 'dmpl__InventoryAdjustment__c', isInsert, isDelete, isUpdate, isDelete ? adjustmentEntries : oldEntries, isInsert || isUpdate ? adjustmentEntries : newEntries);
                
                adjustmentEntries = DocumentHelper.getObjectsByFilter(modifiedObjects, 'dmpl__AdjustmentType__c','Excess');
                if(adjustmentEntries.size() > 0)
                    InventoryLedgerHelper.createLedger(InventoryLedgerTypeEnums.Excess, 'dmpl__InventoryAdjustmentId__c', 'dmpl__InventoryAdjustment__c', isInsert, isDelete, isUpdate, isDelete ? adjustmentEntries : oldEntries, isInsert || isUpdate ? adjustmentEntries : newEntries);

                adjustmentEntries = DocumentHelper.getObjectsByFilter(modifiedObjects, 'dmpl__AdjustmentType__c','Expired');
                if(adjustmentEntries.size() > 0)
                    InventoryLedgerHelper.createLedger(InventoryLedgerTypeEnums.Expired, 'dmpl__InventoryAdjustmentId__c', 'dmpl__InventoryAdjustment__c', isInsert, isDelete, isUpdate, isDelete ? adjustmentEntries : oldEntries, isInsert || isUpdate ? adjustmentEntries : newEntries);
                
                adjustmentEntries = DocumentHelper.getObjectsByFilter(modifiedObjects, 'dmpl__AdjustmentType__c','On Hold');
                if(adjustmentEntries.size() > 0)
                    InventoryLedgerHelper.createLedger(InventoryLedgerTypeEnums.OnHold, 'dmpl__InventoryAdjustmentId__c', 'dmpl__InventoryAdjustment__c', isInsert, isDelete, isUpdate, isDelete ? adjustmentEntries : oldEntries, isInsert || isUpdate ? adjustmentEntries : newEntries);
                    
                adjustmentEntries = DocumentHelper.getObjectsByFilter(modifiedObjects, 'dmpl__AdjustmentType__c','On Loan');
                if(adjustmentEntries.size() > 0)
                    InventoryLedgerHelper.createLedger(InventoryLedgerTypeEnums.OnLoan, 'dmpl__InventoryAdjustmentId__c', 'dmpl__InventoryAdjustment__c', isInsert, isDelete, isUpdate, isDelete ? adjustmentEntries : oldEntries, isInsert || isUpdate ? adjustmentEntries : newEntries);

                adjustmentEntries = DocumentHelper.getObjectsWithNull(modifiedObjects, 'dmpl__AdjustmentType__c');
                if(adjustmentEntries.size() > 0)
                    InventoryLedgerHelper.createLedger(InventoryLedgerTypeEnums.Adjustment, 'dmpl__InventoryAdjustmentId__c', 'dmpl__InventoryAdjustment__c', isInsert, isDelete, isUpdate, isDelete ? adjustmentEntries : oldEntries, isInsert || isUpdate ? adjustmentEntries : newEntries);
                
                adjustmentEntries = DocumentHelper.getObjectsByFilter(modifiedObjects, 'dmpl__AdjustmentType__c','Assemble');
                if(adjustmentEntries.size() > 0)
                    InventoryLedgerHelper.createLedger(InventoryLedgerTypeEnums.Assemble, 'dmpl__InventoryAdjustmentId__c', 'dmpl__InventoryAdjustment__c', isInsert, isDelete, isUpdate, isDelete ? adjustmentEntries : oldEntries, isInsert || isUpdate ? adjustmentEntries : newEntries);

                adjustmentEntries = DocumentHelper.getObjectsByFilter(modifiedObjects, 'dmpl__AdjustmentType__c','Disassemble');
                if(adjustmentEntries.size() > 0)
                    InventoryLedgerHelper.createLedger(InventoryLedgerTypeEnums.Assemble, 'dmpl__InventoryAdjustmentId__c', 'dmpl__InventoryAdjustment__c', isInsert, isDelete, isUpdate, isDelete ? adjustmentEntries : oldEntries, isInsert || isUpdate ? adjustmentEntries : newEntries);

            }
            
            if(isDelete){
                deleteBOMItems(oldEntries);
            }

    } catch (Exception error) {
        ExceptionLogHelper.logException(error);
        throw error;
    }
    }

    public static void afterPostData(Boolean isInsert, Boolean isDelete, Boolean isUpdate, List<dmpl__InventoryAdjustmentLine__c> oldEntries, List<dmpl__InventoryAdjustmentLine__c> newEntries)
    {
        try{
            if(isInsert)
            {
                List<dmpl__InventoryAdjustmentLine__c> bomObjects = DocumentHelper.getObjectsByFilter(newEntries, FIELD_ADJUSTMENTLINE_ADJUSTMENTTYPE, 'Assemble');
                if(bomObjects.size() > 0)
                    populateBOMComponents(bomObjects);

                bomObjects = DocumentHelper.getObjectsByFilter(newEntries, FIELD_ADJUSTMENTLINE_ADJUSTMENTTYPE, 'Disassemble');
                if(bomObjects.size() > 0)
                    populateBOMComponents(bomObjects);
            }
                
    } catch (Exception error) {
        ExceptionLogHelper.logException(error);
        throw error;
    }
    }

    private static void setItemData(
        List<dmpl__InventoryAdjustmentLine__c> newEntries)
    {
        Map<Id, dmpl__Item__c> items = new Map<Id,dmpl__Item__c>(
            ItemHelper.getCachedItems(
                DocumentHelper.extractIds(
                    newEntries, 
                    FIELD_ADJUSTMENTLINE_ITEMID)));
        ItemHelper.setQuantityFromUOM(
            newEntries, 
            null,
            items);
    }



    public static CreateRelatedResult postIL(Id adjustmentId){
        return postAdjustmentLines(queryAdjustmentLines(new List<Id>{adjustmentId}));
    }

    public static CreateRelatedResult postIL(List<SourceObjectInfo> orderLinesInfo, Id adjustmentId){
        return postAdjustmentLines(queryAdjustmentLinesForLines(SourceObjectInfo.extractIds(orderLinesInfo)));
    }

    public static void postAdjustmentLines(List<dmpl__InventoryAdjustment__c> modifiedDocs){
        dmpl__CreateRelatedSetting__mdt setting = CreateRelatedSettingHelper.getCreateRelatedSettings(
            'dmpl__InventoryAdjustment__c',
            'Post IL');
        if(setting == null){
            postAdjustmentLines(queryAdjustmentLines(DocumentHelper.extractIds(modifiedDocs)));
        }else {
            for(dmpl__InventoryAdjustment__c adjustment : modifiedDocs){
                DocumentSelectorController.releaseDocumentDirect(setting.Id, adjustment.Id);
            }
        }
    }

    public static CreateRelatedResult postAdjustmentLines(List<dmpl__InventoryAdjustmentLine__c> adjustmentLines)
    {
        SecurityHelper.ensureCanWriteField('dmpl__IsILPostingApproved__c', 'dmpl__InventoryAdjustmentLine__c');
        for(dmpl__InventoryAdjustmentLine__c adjustmentLine : adjustmentLines){
            adjustmentLine.dmpl__IsILPostingApproved__c = true;
        }

        try {
            skipValidations = true;
            SecurityHelper.ensureCanWriteFields(new string[]{'dmpl__IsILPosted__c','dmpl__IsILPostingApproved__c'}, 'dmpl__InventoryAdjustmentLine__c');
            return CreateRelatedResult.InitFrom(Database.update(adjustmentLines));            
        } finally {
            skipValidations = false;
        }
    }

    public static void createInventoryAdjustmentLinesFromInventoryAdjustment(List<dmpl__InventoryAdjustment__c> inventoryAdjustments){
        createInventoryAdjustmentLines(inventoryAdjustments);
    }

    public static void createInventoryAdjustmentLinesFromClaim(List<dmpl__InventoryAdjustment__c> inventoryAdjustments, Map<Id,dmpl__Claim__c> claims){
        List<dmpl__InventoryAdjustmentLine__c> newInventoryAdjustmentLines = new List<dmpl__InventoryAdjustmentLine__c>();

        for(dmpl__InventoryAdjustment__c inventoryAdjustment : inventoryAdjustments){
            dmpl__Claim__c claim = claims.get(inventoryAdjustment.dmpl__ClaimId__c);
            for(dmpl__ClaimLine__c claimLine : claim.dmpl__Claim_Lines1__r){
                if(claimLine.dmpl__ClaimType__c == 'Part to Part')
                    {
                        newInventoryAdjustmentLines.add(new dmpl__InventoryAdjustmentLine__c(
                            dmpl__InventoryAdjustmentId__c = inventoryAdjustment.ID,
                            dmpl__ItemId__c = claimLine.dmpl__ItemId__c,
                            dmpl__Quantity__c = claimLine.dmpl__ApproveQuantity__c,
                            dmpl__UnitCost__c = claimLine.dmpl__UnitPrice__c,
                            dmpl__ClaimLineId__c = claimLine.Id,
                            dmpl__ClaimId__c = claim.Id
                        ));
                    }
            }
        }

        if(newInventoryAdjustmentLines.size() > 0)
        {
            try{
                SecurityHelper.ensureCanCreateFields(new string[]{'dmpl__InventoryAdjustmentId__c','dmpl__ItemId__c','dmpl__ClaimId__c','dmpl__ClaimLineId__c','dmpl__Quantity__c','dmpl__UnitCost__c'}, 'dmpl__InventoryAdjustmentLine__c');
                skipValidations = true;
                insert newInventoryAdjustmentLines;
            } catch(Exception error){
                ExceptionLogHelper.logException(error);
                throw error;
            } finally{
                skipValidations = false;
            }
        }
    }

    public static void createInventoryAdjustmentLinesFromClaimBatch(List<dmpl__InventoryAdjustment__c> inventoryAdjustments, Map<Id, dmpl__ClaimBatch__c> claimBatches){
        List<dmpl__InventoryAdjustmentLine__c> newInventoryAdjustmentLines = new List<dmpl__InventoryAdjustmentLine__c>();

        for(dmpl__InventoryAdjustment__c inventoryAdjustment : inventoryAdjustments){
            dmpl__ClaimBatch__c claimBatch = claimBatches.get(inventoryAdjustment.dmpl__ClaimBatchId__c);
            for(dmpl__ClaimLine__c claimLine : claimBatch.dmpl__ClaimLines__r){
                if(claimLine.dmpl__ClaimType__c == 'Part to Part')
                    {
                        newInventoryAdjustmentLines.add(new dmpl__InventoryAdjustmentLine__c(
                            dmpl__InventoryAdjustmentId__c = inventoryAdjustment.ID,
                            dmpl__ItemId__c = claimLine.dmpl__ItemId__c,
                            dmpl__Quantity__c = claimLine.dmpl__ApproveQuantity__c,
                            dmpl__UnitCost__c = claimLine.dmpl__UnitPrice__c,
                            dmpl__ClaimLineId__c = claimLine.Id,
                            dmpl__ClaimId__c = claimLine.dmpl__ClaimId__c,
                            dmpl__ClaimBatchId__c = claimBatch.Id
                        ));
                    }
            }
        }

        if(newInventoryAdjustmentLines.size() > 0)
        {
            try{
                SecurityHelper.ensureCanCreateFields(new string[]{'dmpl__InventoryAdjustmentId__c','dmpl__ItemId__c','dmpl__ClaimId__c','dmpl__ClaimBatchId__c','dmpl__ClaimLineId__c','dmpl__Quantity__c','dmpl__UnitCost__c'}, 'dmpl__InventoryAdjustmentLine__c');
                skipValidations = true;
                insert newInventoryAdjustmentLines;
            } catch(Exception error){
                ExceptionLogHelper.logException(error);
                throw error;
            } finally{
                skipValidations = false;
            }
        }
    }

    public static void performReprice(Id adjustmentId){
        performReprice(
            new List<Id>{adjustmentId});
    }

    public static void performReprice(List<Id> adjustmentIds){
        List<dmpl__InventoryAdjustmentLine__c> adjustmentLines = queryAdjustmentLinesOfAdjustments(
            adjustmentIds);
        PriceListHelper.setApplicablePrices(
            adjustmentLines, 
            queryAdjustmentDocument(
                adjustmentIds), 
            ItemHelper.getCachedItems(
                DocumentHelper.extractIds(
                    adjustmentLines, 
                    'dmpl__ItemId__c')),
            true);
        update adjustmentLines;
    }

    @TestVisible
    private static void populateBOMComponents(List<dmpl__InventoryAdjustmentLine__c> newEntries)
    {
        List<dmpl__InventoryAdjustmentLine__c> newInventoryAdjustmentLines = new List<dmpl__InventoryAdjustmentLine__c>();
        Map<Id, dmpl__Item__c> items = new Map<Id,dmpl__Item__c>(
            ItemHelper.getCachedItems(
                DocumentHelper.extractIds(
                    newEntries, 
                    FIELD_ADJUSTMENTLINE_ITEMID)));

        for(dmpl__InventoryAdjustmentLine__c newEntry : newEntries){
            if(newEntry.dmpl__AdjustmentType__c != 'Assemble' && newEntry.dmpl__AdjustmentType__c != 'Disassemble')
                continue;

            dmpl__Item__c item = items.get(newEntry.dmpl__ItemId__c);
            List<dmpl__ItemComponent__c> components = getApplicableItemFeatures(item, newEntry.dmpl__SKUId__c);
            
            for(dmpl__ItemComponent__c component : components)
            {
                newInventoryAdjustmentLines.add(new dmpl__InventoryAdjustmentLine__c(
                            dmpl__InventoryAdjustmentId__c = newEntry.dmpl__InventoryAdjustmentId__c,
                            dmpl__ItemId__c = component.dmpl__ComponentItemId__c,
                            dmpl__SKUId__c = component.dmpl__ComponentSKUId__c,
                            dmpl__ItemComponentId__c = component.Id,
                            dmpl__Quantity__c = (newEntry.dmpl__AdjustmentType__c == 'Assemble' ? -1 : 1 ) 
                                                        * component.dmpl__Quantity__c,
                            dmpl__AdjustmentType__c = newEntry.dmpl__AdjustmentType__c == 'Assemble' ? 'Disassemble' : 'Assemble',
                            dmpl__ParentLineId__c = newEntry.Id
                        ));
            }
        }

        if(newInventoryAdjustmentLines.size() > 0)
            insert newInventoryAdjustmentLines;
    }

    private static void deleteBOMItems(List<dmpl__InventoryAdjustmentLine__c> oldEntries){
        SecurityHelper.ensureCanReadField('Id', 'dmpl__SaleOrderLine__c');
        List<dmpl__InventoryAdjustmentLine__c> linesToDelte = [SELECT Id 
            FROM dmpl__InventoryAdjustmentLine__c 
            WHERE dmpl__ParentLineId__c IN:CollectionHelper.extractIds(oldEntries)];

        try {
            skipComponentDeleteValidation = true;
            if(linesToDelte.size()>0){
                SecurityHelper.ensureCanDeleteObject('dmpl__InventoryAdjustmentLine__c');
                delete linesToDelte;
            }        
        } finally {
            skipComponentDeleteValidation = false;
        }
    }

    @testVisible
    private static List<dmpl__ItemComponent__c> getApplicableItemFeatures(dmpl__Item__c item, Id skuId){
        List<dmpl__ItemComponent__c> components = new List<dmpl__ItemComponent__c>();
        for(dmpl__ItemComponent__c component : item.dmpl__ItemComponents__r){
            if(
                (component.dmpl__SKUId__c == skuId 
                    || component.dmpl__SKUId__c == null)
                && component.dmpl__FeatureType__c == 'BOM'
                ){
                components.add(component);
            }
        }
        return components;
    }

    private static void createInventoryAdjustmentLines(List<dmpl__InventoryAdjustment__c> inventoryAdjustments){
        List<dmpl__InventoryAdjustmentLine__c> newInventoryAdjustmentLines = new List<dmpl__InventoryAdjustmentLine__c>();

        List<dmpl__InventoryCycleCountLine__c> inventoryCycleCountLines = queryInventoryCycleCountLines(DocumentHelper.extractIds(inventoryAdjustments, FIELD_INVENTORYCYCLECOUNTLINE_CYCLECOUNTID));

        for(dmpl__InventoryAdjustment__c inventoryAdjustment : inventoryAdjustments){
            for(dmpl__InventoryCycleCountLine__c inventoryCycleCountLine : inventoryCycleCountLines){
                if(inventoryAdjustment.dmpl__CycleCountId__c == inventoryCycleCountLine.dmpl__CycleCountId__c)
                {
                    if(inventoryCycleCountLine.dmpl__DiscrepencyQuantity__c != 0)
                    {
                        newInventoryAdjustmentLines.add(new dmpl__InventoryAdjustmentLine__c(
                            dmpl__InventoryAdjustmentId__c = inventoryAdjustment.ID,
                            dmpl__ItemId__c = inventoryCycleCountLine.dmpl__ItemId__c,
                            dmpl__SKUId__c = inventoryCycleCountLine.dmpl__SKUId__c,
                            dmpl__ItemLotTypeId__c = inventoryCycleCountLine.dmpl__ItemLotTypeId__c,
                            dmpl__StorageLocationId__c = inventoryCycleCountLine.dmpl__StorageLocationId__c,
                            dmpl__ItemLotId__c = inventoryCycleCountLine.dmpl__ItemLotId__c,
                            dmpl__Quantity__c = inventoryCycleCountLine.dmpl__DiscrepencyQuantity__c,
                            dmpl__UnitCost__c = inventoryCycleCountLine.dmpl__UnitCost__c,
                            dmpl__CycleCountLineId__c = inventoryCycleCountLine.Id
                        ));
                    }

                    if(inventoryCycleCountLine.dmpl__RecordedDamagedQuantity__c > 0)
                    {
                        newInventoryAdjustmentLines.add(new dmpl__InventoryAdjustmentLine__c(
                            dmpl__AdjustmentType__c = 'Damaged',
                            dmpl__InventoryAdjustmentId__c = inventoryAdjustment.ID,
                            dmpl__ItemId__c = inventoryCycleCountLine.dmpl__ItemId__c,
                            dmpl__SKUId__c = inventoryCycleCountLine.dmpl__SKUId__c,
                            dmpl__ItemLotTypeId__c = inventoryCycleCountLine.dmpl__ItemLotTypeId__c,
                            dmpl__StorageLocationId__c = inventoryCycleCountLine.dmpl__StorageLocationId__c,
                            dmpl__ItemLotId__c = inventoryCycleCountLine.dmpl__ItemLotId__c,
                            dmpl__Quantity__c = inventoryCycleCountLine.dmpl__RecordedDamagedQuantity__c,
                            dmpl__UnitCost__c = inventoryCycleCountLine.dmpl__UnitCost__c,
                            dmpl__CycleCountLineId__c = inventoryCycleCountLine.Id
                        ));
                    }

                    if(inventoryCycleCountLine.dmpl__RecordedExpiredQuantity__c > 0)
                    {
                        newInventoryAdjustmentLines.add(new dmpl__InventoryAdjustmentLine__c(
                            dmpl__AdjustmentType__c = 'Expired',
                            dmpl__InventoryAdjustmentId__c = inventoryAdjustment.ID,
                            dmpl__ItemId__c = inventoryCycleCountLine.dmpl__ItemId__c,
                            dmpl__SKUId__c = inventoryCycleCountLine.dmpl__SKUId__c,
                            dmpl__ItemLotTypeId__c = inventoryCycleCountLine.dmpl__ItemLotTypeId__c,
                            dmpl__StorageLocationId__c = inventoryCycleCountLine.dmpl__StorageLocationId__c,
                            dmpl__ItemLotId__c = inventoryCycleCountLine.dmpl__ItemLotId__c,
                            dmpl__Quantity__c = inventoryCycleCountLine.dmpl__RecordedExpiredQuantity__c,
                            dmpl__UnitCost__c = inventoryCycleCountLine.dmpl__UnitCost__c,
                            dmpl__CycleCountLineId__c = inventoryCycleCountLine.Id
                        ));
                    }
                }
            }
        }

        if(newInventoryAdjustmentLines.size() > 0)
        {
            try{
                // SecurityHelper.ensureCanWriteFields(new string[]{'dmpl__InventoryAdjustmentId__c','dmpl__ItemId__c','dmpl__SKUId__c','dmpl__StorageLocationId__c','dmpl__ItemLotId__c','dmpl__Quantity__c','dmpl__UnitCost__c'}, 'dmpl__InventoryAdjustmentLine__c');
                skipValidations = true;
                insert newInventoryAdjustmentLines;
            } catch(Exception error){
                ExceptionLogHelper.logException(error);
                throw error;
            } finally{
                skipValidations = false;
            }
        }
    }

    private static List<dmpl__InventoryAdjustmentLine__c> queryAdjustmentLines(List<ID> documentIds)
    {
        SecurityHelper.ensureCanReadFields(new string[]{'dmpl__IsILPosted__c','dmpl__IsILPostingApproved__c'}, 'dmpl__InventoryAdjustmentLine__c');
        return ([SELECT id,
            dmpl__IsILPosted__c,
            dmpl__IsILPostingApproved__c
            FROM dmpl__InventoryAdjustmentLine__c WHERE dmpl__InventoryAdjustmentId__c IN :documentIds]);
    }

    private static List<dmpl__InventoryAdjustmentLine__c> queryAdjustmentLinesForLines(List<ID> lineIds)
    {
        SecurityHelper.ensureCanReadFields(new string[]{'dmpl__IsILPosted__c','dmpl__IsILPostingApproved__c'}, 'dmpl__InventoryAdjustmentLine__c');
        return ([SELECT id,
            dmpl__IsILPosted__c,
            dmpl__IsILPostingApproved__c
            FROM dmpl__InventoryAdjustmentLine__c WHERE Id IN :lineIds]);
    }

    private static List<Id> querySourcePopulatedEntries(List<Id> documentIds){
       
        SecurityHelper.ensureCanReadFields(new string[]{'dmpl__InventoryAdjustmentId__c'}, 'dmpl__InventoryAdjustmentLine__c');
        return DocumentHelper.extractIds([SELECT dmpl__InventoryAdjustmentId__c FROM dmpl__InventoryAdjustmentLine__c WHERE ID IN:documentIds],FIELD_ADJUSTMENTLINELINE_ADJUSTMENTID);
    }

    private static List<dmpl__Item__c> queryItems(List<dmpl__InventoryAdjustmentLine__c> linentries){
       
        SecurityHelper.ensureCanReadFields(new string[]{'dmpl__TrackInventory__c','dmpl__TrackLots__c'}, 'dmpl__Item__c');
        return [SELECT Id, dmpl__TrackInventory__c, dmpl__TrackLots__c 
            FROM dmpl__Item__c 
            WHERE Id IN :DocumentHelper.extractIds(linentries, FIELD_ADJUSTMENTLINE_ITEMID)];
    }

    private static void validateItem(List<dmpl__InventoryAdjustmentLine__c> newEntries){
        Map<Id, dmpl__Item__c> items = new Map<Id,dmpl__Item__c>(ItemHelper.getCachedItems(DocumentHelper.extractIds(newEntries, FIELD_ADJUSTMENTLINE_ITEMID)));
        for(dmpl__InventoryAdjustmentLine__c orderLine : newEntries){
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

    private static List<dmpl__InventoryCycleCountLine__c> queryInventoryCycleCountLines(List<ID> inventoryCycleCountIds){

        SecurityHelper.ensureCanReadFields(new string[]{
                                            'dmpl__ItemId__c',
                                            'dmpl__SKUId__c',
                                            'dmpl__ItemLotTypeId__c',
                                            'dmpl__StorageLocationId__c',
                                            'dmpl__ItemLotId__c',
                                            'dmpl__DiscrepencyQuantity__c',
                                            'dmpl__UnitCost__c',
                                            'dmpl__DiscrepancyCostValue__c',
                                            'dmpl__CycleCountId__c',
                                            'dmpl__RecordedDamagedQuantity__c', 
                                            'dmpl__RecordedExpiredQuantity__c'}, 
                                            'dmpl__InventoryCycleCountLine__c');
        return [SELECT ID,
        Name,
        dmpl__ItemId__c,
        dmpl__SKUId__c,
        dmpl__ItemLotTypeId__c,
        dmpl__StorageLocationId__c,
        dmpl__ItemLotId__c,
        dmpl__DiscrepencyQuantity__c,
        dmpl__UnitCost__c,
        dmpl__DiscrepancyCostValue__c,
        dmpl__CycleCountId__c,
        dmpl__RecordedDamagedQuantity__c,
        dmpl__RecordedExpiredQuantity__c
        FROM dmpl__InventoryCycleCountLine__c
        WHERE dmpl__CycleCountId__c IN : inventoryCycleCountIds];
    }


    private static List<dmpl__InventoryAdjustment__c> queryAdjustmentDocument(
        List<ID> adjustmentLineIds)
    {
        SecurityHelper.ensureCanReadFields(
            new string[]
            {
                'dmpl__DocumentDate__c',
                'dmpl__PartnerAccountId__c',
                'dmpl__BranchId__c',
                'dmpl__PriceListId__c',
                'dmpl__PriceAsOnDate__c'
            }, 'dmpl__InventoryAdjustment__c');
        return [
            SELECT 
                Id, 
                Name, 
                dmpl__DocumentDate__c,
                dmpl__PartnerAccountId__c,
                dmpl__BranchId__c,
                dmpl__PriceListId__c,
                dmpl__PriceAsOnDate__c
            FROM dmpl__InventoryAdjustment__c 
            WHERE ID IN : adjustmentLineIds ];
    }

    private static List<dmpl__InventoryAdjustmentLine__c> queryAdjustmentLinesOfAdjustments(
        List<ID> adjustmentIds)
    {
        SecurityHelper.ensureCanReadFields(new List<String>
        {
            'Name', 
            'dmpl__ItemId__c',
            'dmpl__SKUId__c',
            'dmpl__Quantity__c',
            'dmpl__UnitCost__c',
            'dmpl__SaleOrderId__c',
            'dmpl__PriceListId__c'
        },'dmpl__InventoryAdjustmentLine__c');
        return [ SELECT ID, 
            Name, 
            dmpl__ItemId__c,
            dmpl__SKUId__c,
            dmpl__ItemLotTypeId__c,
            dmpl__Quantity__c,
            dmpl__UnitCost__c,
            dmpl__InventoryAdjustmentId__c,
            dmpl__PriceListId__c,
            dmpl__PriceAsOnDate__c
        FROM dmpl__InventoryAdjustmentLine__c
        WHERE dmpl__InventoryAdjustmentId__c IN : adjustmentIds];
    }  
}