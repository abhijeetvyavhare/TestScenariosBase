public without sharing class InventoryLedgerHelper extends TriggerHandler {
    
    private static InventoryLedgerService ils;

    public static void createLedger(
        InventoryLedgerTypeEnums ledgerType, 
        string masterFieldName, 
        string masterObjectName, 
        Boolean isInsert, 
        Boolean isDelete, 
        Boolean isUpdate, 
        List<sObject> oldEntries, 
        List<sObject> newEntries)
    {
        ils = new InventoryLedgerService();
        Map<Id, dmpl__InventoryLedger__c> itemLedgers = ils.queryLedgerRecords(
            newEntries, 
            oldEntries, 
            ledgerType);
        Map<Id, dmpl__Item__c> items = ils.queryItems(
            newEntries, 
            oldEntries);

        if(isUpdate){
            updateLedger(
                ledgerType, 
                masterFieldName, 
                masterObjectName, 
                oldEntries, 
                newEntries,
                itemLedgers,
                items);
        }else if(isDelete){
            deleteLedger(
                ledgerType, 
                masterFieldName, 
                masterObjectName, 
                oldEntries,
                itemLedgers);
        }

        if(isInsert || isUpdate){
            insertLedger(
                isUpdate,
                ledgerType, 
                masterFieldName, 
                masterObjectName, 
                oldEntries, 
                newEntries,
                itemLedgers,
                items);
        }
    }
    
    public static void insertLedger(
        Boolean isUpdate,
        InventoryLedgerTypeEnums ledgerType, 
        string masterFieldName, 
        string masterObjectName, 
        List<sObject> oldEntries, 
        List<sObject> newEntries,
        Map<Id, dmpl__InventoryLedger__c> itemLedgers,
        Map<Id, dmpl__Item__c> items){
            Map<SObject, dmpl__InventoryLedger__c> insertedItemLedgers = new Map<SObject, dmpl__InventoryLedger__c>();
            List<ID> documentIds = DocumentHelper.extractIds(
                newEntries, 
                masterFieldName);
            List<sObject> masterDocuments = ils.queryMasterDocuments(
                ledgerType, 
                documentIds, 
                masterObjectName);
            for(sObject lineEntry : newEntries){
                dmpl__Item__c item = items.get((ID)lineEntry.get('dmpl__ItemId__c'));
                if(item == null){
                    lineEntry.addError(System.Label.IntegrityFailed_MssingProduct);
                } else if(!isApproved(lineEntry)
                    || !isPostingRequired(ledgerType, lineEntry, item)
                    || (!item.dmpl__TrackInventory__c)){
                        lineEntry.put('dmpl__IsILPosted__c',false);
                        continue;
                } else if (isUpdate && IsPosted(getCorrespondingLineEntry(oldEntries, lineEntry))){
                    continue;
                } else if(item.dmpl__TrackLots__c && lineEntry.Get('dmpl__ItemLotId__c') == null){
                    lineEntry.addError(System.Label.IntegrityFailed_MssingProductLot);
                } else {
                    sObject document = findMasterDocument(
                        masterDocuments, 
                        (ID)lineEntry.get(masterFieldName));
                    dmpl__InventoryLedger__c itemLedger= createItemLedger(
                        ledgerType, 
                        lineEntry, 
                        masterFieldName, 
                        masterObjectName, 
                        item, 
                        null, 
                        document);
                    if(itemLedger!=null){
                        insertedItemLedgers.put(
                            lineEntry,
                            itemLedger);
                    }
                }
            }
            //
            try {
                TriggerHandler.skipValidations = true;
                if(insertedItemLedgers.values().size()>0){
                    insert insertedItemLedgers.values();
                }
            } finally{
                TriggerHandler.skipValidations = false;
            }
            //
            for(sObject lineEntry : newEntries){
                dmpl__InventoryLedger__c itemLedger = insertedItemLedgers.get(lineEntry);
                if(itemLedger!=null){
                    lineEntry.put(
                        InventoryLedgerService.FIELD_OBJECT_INVENTORYLEDGERID, 
                        itemLedger.Id);
                }
            }
    }

    public static void updateLedger(
        InventoryLedgerTypeEnums ledgerType, 
        string masterFieldName, 
        string masterObjectName, 
        List<sObject> oldEntries, 
        List<sObject> newEntries,
        Map<Id, dmpl__InventoryLedger__c> itemLedgers,
        Map<Id, dmpl__Item__c> items){
            List<dmpl__InventoryLedger__c> updatedItemLedgers = new List<dmpl__InventoryLedger__c>();    
            List<dmpl__InventoryLedger__c> deletedItemLedgers = new List<dmpl__InventoryLedger__c>();
            List<ID> documentIds = DocumentHelper.extractIds(
                oldEntries, 
                masterFieldName);
            List<sObject> masterDocuments = ils.queryMasterDocuments(
                ledgerType, 
                documentIds, 
                masterObjectName);
            for(sObject lineEntry : oldEntries){
                if(!isPosted(lineEntry)){
                    continue;
                }
                //                
                dmpl__InventoryLedger__c itemLedger = getItemLedger(
                    ledgerType, 
                    lineEntry, 
                    itemLedgers);    
                sObject newLineEntry = getCorrespondingLineEntry(
                    newEntries, 
                    lineEntry);
                if(newLineEntry == null){
                    lineEntry.addError(
                        System.Label.IntegrityFailed_MssingNewLine);
                }

                if(!IsApproved(newLineEntry)){
                    if(itemLedger!=null){
                        deletedItemLedgers.Add(itemLedger);
                    }
                }else {
                    dmpl__Item__c item = items.get(
                        (ID)lineEntry.get(MetadataService.FIELD_ITEM_ID));
                    if(item == null){
                        lineEntry.addError(
                            System.Label.IntegrityFailed_MssingProduct);
                        continue;
                    }
                    else if(!isPostingRequired(
                            ledgerType, 
                            lineEntry, 
                            item) 
                        || !item.TrackInventory__c){
                            continue;
                    }
                    else if(item.dmpl__TrackLots__c 
                        && lineEntry.get('dmpl__ItemLotId__c') ==null){
                            lineEntry.addError(
                                System.Label.IntegrityFailed_MssingProductLot);
                        continue;
                    }else if(newLineEntry.Get(InventoryLedgerService.FIELD_OBJECT_INVENTORYLEDGERID)!=null 
                        && itemLedger.Id!= (ID)newLineEntry.Get(InventoryLedgerService.FIELD_OBJECT_INVENTORYLEDGERID)){
                            lineEntry.addError(
                                System.Label.IntegrityFailed_LedgerIdTempered);
                            continue;
                    }

                    sObject document = findMasterDocument(
                        masterDocuments, 
                        (ID)newLineEntry.get(masterFieldName));    
                    itemLedger = createItemLedger(
                        ledgerType, 
                        newLineEntry, 
                        masterFieldName, 
                        masterObjectName, 
                        item, 
                        itemLedger, 
                        document);
                    if(itemLedger !=null){
                        updatedItemLedgers.add(itemLedger);
                    }
                }
            }
            try {
                TriggerHandler.skipValidations = true;
                if(deletedItemLedgers.size()>0){
                    delete deletedItemLedgers;
                }
                if(updatedItemLedgers.size()>0){
                    update updatedItemLedgers;
                }
            } finally{
                TriggerHandler.skipValidations = false;
            }
        }

    public static void deleteLedger(
        InventoryLedgerTypeEnums ledgerType, 
        string masterFieldName, 
        string masterObjectName, 
        List<sObject> oldEntries,
        Map<Id, dmpl__InventoryLedger__c> itemLedgers){

        List<dmpl__InventoryLedger__c> deletedItemLedgers = new List<dmpl__InventoryLedger__c>();
        List<ID> documentIds = DocumentHelper.extractIds(
            oldEntries, 
            masterFieldName);
        List<sObject> masterDocuments = ils.queryMasterDocuments(
            ledgerType, 
            documentIds, 
            masterObjectName);
        for(sObject lineEntry : oldEntries){
            if(!isPosted(lineEntry)){
                continue;
            }
            dmpl__InventoryLedger__c itemLedger = getItemLedger(
                ledgerType, 
                lineEntry, 
                itemLedgers);    
            deletedItemLedgers.add(itemLedger);   
        }   
        try {
            TriggerHandler.skipValidations = true;
            if(deletedItemLedgers.size()>0){
                delete deletedItemLedgers;
            }
        } finally{
            TriggerHandler.skipValidations = false;
        }     
    }

    public static InventoryLedgerTypeEnums getLedgerType(String ldegerTypeName){
        if(String.isBlank(ldegerTypeName)){
            return InventoryLedgerTypeEnums.None;
        }

        for (InventoryLedgerTypeEnums enumValue : InventoryLedgerTypeEnums.values()){
            if(String.valueOf(enumValue) == ldegerTypeName){
                return enumValue;
            }
        }
        return InventoryLedgerTypeEnums.None;
    }

    private static dmpl__InventoryLedger__c getItemLedger(
        InventoryLedgerTypeEnums ledgerType, 
        SObject lineEntry, 
        Map<Id, dmpl__InventoryLedger__c> itemLedgers){
            if(ledgerType == InventoryLedgerTypeEnums.Inspection){
                Set<string> fields = lineEntry.getSobjectType().getDescribe().fields.getMap().keySet();
                if(fields.contains('dmpl__InventoryLedgerInspectionId__c') 
                    && (Double)lineEntry.Get('dmpl__InspectionQuantity__c') != 0){
                    return itemLedgers.Get((ID)lineEntry.Get('dmpl__InventoryLedgerInspectionId__c'));
                }
            }
            return itemLedgers.Get((ID)lineEntry.Get('dmpl__InventoryLedgerId__c'));
    }

    private static dmpl__InventoryLedger__c createItemLedger(
        InventoryLedgerTypeEnums ledgerType, 
        sObject sourceEntry, 
        string masterFieldName, 
        string masterObjectName, 
        dmpl__Item__c item, 
        dmpl__InventoryLedger__c oldItemLedger, 
        sObject document){
        //
        DescribeSObjectResult describeResult = sourceEntry.getSObjectType().getDescribe();
        List<String> fieldNames = new List<String>(describeResult.fields.getMap().keySet());
        dmpl__InventoryLedger__c itemLedger = oldItemLedger;
        if(itemLedger == null){
            itemLedger = new dmpl__InventoryLedger__c();
            itemLedger.dmpl__DocumentDate__c = Date.today(); //(Date)document.Get('dmpl__DocumentDate__c');
        }
        if(document == null){
            sourceEntry.addError(System.Label.InventoryLedger_MssingSourceDocument);
            return null;
        }
        //
        itemLedger.dmpl__SourceDocument__c = (string)document.Get('Name');
        itemLedger.dmpl__ItemId__c = (ID) sourceEntry.Get('dmpl__ItemId__c');
        itemLedger.dmpl__SKUId__c = (ID)sourceEntry.Get('dmpl__SKUId__c');
        itemLedger.dmpl__ItemLotTypeId__c = (ID)sourceEntry.Get('dmpl__ItemLotTypeId__c');
        itemLedger.dmpl__StorageLocationId__c = (ID)sourceEntry.Get('dmpl__StorageLocationId__c');
        itemLedger.dmpl__ItemLotId__c = (ID)sourceEntry.Get('dmpl__ItemLotId__c');
        itemLedger.dmpl__InventoryLedgerType__c = ledgerType.Name();
        itemLedger.dmpl__PartnerAccountId__c = (ID)document.Get('dmpl__PartnerAccountId__c');
        itemLedger.dmpl__BranchId__c = (ID)document.Get('dmpl__BranchId__c');
        itemLedger.dmpl__HashCode__c = getHashCode();
        //
        if(fieldNames.contains('dmpl__UnitCost__c')){
            itemLedger.dmpl__UnitCost__c = (Double)sourceEntry.Get('dmpl__UnitCost__c');
        }
        //
        sourceEntry.put('dmpl__IsILPosted__c',true);
        //
        setBranchRelatedFields(
            ledgerType, 
            sourceEntry, 
            itemLedger, 
            document);
        setLocation(
            ledgerType, 
            sourceEntry, 
            itemLedger, 
            document);            
        setLedgerQuantities(
            ledgerType, 
            sourceEntry, 
            itemLedger,
            document);
        return itemLedger;
    }
    
    private static Double getHashCode(){
        return Datetime.now().getTime() + Math.random() * 1000000;
    }

    private static void setBranchRelatedFields(
        InventoryLedgerTypeEnums ledgerType, 
        sObject lineEntry,
        dmpl__InventoryLedger__c itemLedger,
        sObject document){
        if(ledgerType == InventoryLedgerTypeEnums.TransferInward
            || ledgerType == InventoryLedgerTypeEnums.TransferOutward) {
            if(lineEntry.Get('dmpl__BranchId__c')!=null){
                itemLedger.dmpl__BranchId__c = (ID)lineEntry.Get('dmpl__BranchId__c');
            }
            if(lineEntry.Get('dmpl__RelatedBranchId__c')!=null){
                itemLedger.dmpl__RelatedBranchId__c = (ID)lineEntry.Get('dmpl__RelatedBranchId__c');
            }
            if(lineEntry.Get('dmpl__PartnerAccountId__c')!=null){
                itemLedger.dmpl__PartnerAccountId__c  = (ID)lineEntry.Get('dmpl__PartnerAccountId__c');
            }
            if(lineEntry.Get('dmpl__RelatedPartnerAccountId__c')!=null){
                itemLedger.dmpl__RelatedPartnerAccountId__c  = (ID)lineEntry.Get('dmpl__RelatedPartnerAccountId__c');
            }
            if(lineEntry.Get('dmpl__RelatedItemLotId__c')!=null){
                itemLedger.dmpl__RelatedItemLotId__c = (ID)lineEntry.Get('dmpl__RelatedItemLotId__c');
            }
            if(lineEntry.Get('dmpl__Type__c')=='Single Step' && ledgerType == InventoryLedgerTypeEnums.TransferInward){
                itemLedger.dmpl__RelatedItemLotId__c = (ID)lineEntry.Get('dmpl__ItemLotId__c');
                itemLedger.dmpl__ItemLotId__c = (ID)lineEntry.Get('dmpl__RelatedItemLotId__c');
            }
    }
}

private static void setLocation(
        InventoryLedgerTypeEnums ledgerType, 
        sObject lineEntry,
        dmpl__InventoryLedger__c itemLedger,
        sObject document){
        if(ledgerType == InventoryLedgerTypeEnums.TransferInward) {
            if (lineEntry.getSObjectType().getDescribe().fields.getMap().containsKey('dmpl__RelatedStorageLocationId__c')) {
                itemLedger.dmpl__StorageLocationId__c = (ID)lineEntry.get('dmpl__RelatedStorageLocationId__c');
            }else {
                if(lineEntry.Get('dmpl__StorageLocationId__c')!=null){
                    itemLedger.dmpl__StorageLocationId__c = (ID)lineEntry.Get('dmpl__StorageLocationId__c');
                }
            }
        }
        if(ledgerType == InventoryLedgerTypeEnums.TransferOutward) {    
            // if (lineEntry.getSObjectType().getDescribe().fields.getMap().containsKey('dmpl__RelatedStorageLocationId__c')) {
            //         itemLedger.dmpl__StorageLocationId__c = (ID)lineEntry.get('dmpl__RelatedStorageLocationId__c');
            // }else {
                if (lineEntry.get('dmpl__StorageLocationId__c') != null) {
                    itemLedger.dmpl__StorageLocationId__c = (ID)lineEntry.get('dmpl__StorageLocationId__c');
            // }
            }
        }
        if(ledgerType == InventoryLedgerTypeEnums.Damaged 
            || ledgerType == InventoryLedgerTypeEnums.Shortage 
            || ledgerType == InventoryLedgerTypeEnums.Excess) {
                if (lineEntry.getSObjectType().getDescribe().fields.getMap().containsKey('dmpl__Type__c')) {
                    if (lineEntry.get('dmpl__Type__c') == 'Single Step') {
                        itemLedger.dmpl__StorageLocationId__c = (ID)lineEntry.get('dmpl__RelatedStorageLocationId__c');
                        itemLedger.dmpl__ItemLotId__c = (ID)lineEntry.get('dmpl__RelatedItemLotId__c');
                    }
                }
            }
        }

    private static void setLedgerQuantities(
        InventoryLedgerTypeEnums ledgerType, 
        sObject lineEntry,
        dmpl__InventoryLedger__c itemLedger,
        sObject document){
        //
        switch on ledgerType {
            when Sold {
                itemLedger.dmpl__Quantity__c =  (Double)lineEntry.Get('dmpl__Quantity__c');
                itemLedger.dmpl__AllocatedQuantity__c = (Double)lineEntry.Get('dmpl__AllocatedQuantity__c');
                itemLedger.dmpl__PickedQuantity__c = (Double)lineEntry.Get('dmpl__PickedQuantity__c');
                itemLedger.dmpl__DeliveredQuantity__c = (Double)lineEntry.Get('dmpl__DeliveredQuantity__c');
                itemLedger.dmpl__PendingDeliveriesQuantity__c = ((Double)lineEntry.Get('dmpl__Quantity__c')) 
                    - (lineEntry.Get('dmpl__DeliveredQuantity__c') == null ? 
                        0 : (Double)lineEntry.Get('dmpl__DeliveredQuantity__c'));
                itemLedger.dmpl__SoftCommittedQuantity__c =  (Double)lineEntry.Get('dmpl__SoftCommittedQuantity__c') * -1;
            }
            when Outward{
                itemLedger.dmpl__Quantity__c =  (((Double)lineEntry.Get('dmpl__Quantity__c')) 
                    - (lineEntry.Get('dmpl__InvoicedQuantity__c') !=null ? 
                        (Double)lineEntry.Get('dmpl__InvoicedQuantity__c') : 0));
                itemLedger.dmpl__AllocatedQuantity__c = (Double)lineEntry.Get('dmpl__AllocatedQuantity__c');
                itemLedger.dmpl__PickedQuantity__c = (Double)lineEntry.Get('dmpl__PickedQuantity__c');
                itemLedger.dmpl__PendingDeliveriesQuantity__c = (lineEntry.Get('dmpl__InvoicedQuantity__c') == null ? 
                    0 : (Double)lineEntry.Get('dmpl__InvoicedQuantity__c'));
            }
            when Inspection {
                itemLedger.dmpl__Quantity__c = (Double)lineEntry.Get('dmpl__InspectionQuantity__c');
            }
            when Purchased{
                itemLedger.dmpl__Quantity__c =  (Double)lineEntry.Get('dmpl__Quantity__c');
                if(lineEntry.Get('dmpl__GoodsReceiptLineId__c')!=null){
                    itemLedger.dmpl__InwardQuantity__c = (Double)lineEntry.Get('dmpl__Quantity__c') * -1;
                }
            }
            when Inward{
                itemLedger.dmpl__Quantity__c =  (Double)lineEntry.Get('dmpl__SupplierQuantity__c');
                itemLedger.dmpl__PipelineQuantity__c = (Double)lineEntry.Get('dmpl__PipelineQuantity__c') * -1;
            }
            when PurchaseReturn {
                itemLedger.dmpl__Quantity__c =  (Double)lineEntry.Get('dmpl__Quantity__c');
                //Code Commented on 4th July
                // if(lineEntry.Get('dmpl__ReturnType__c') =='Damaged'){
                //     itemLedger.dmpl__DamagedQuantity__c = (Double)lineEntry.Get('dmpl__Quantity__c') * -1;
                // }else if(lineEntry.Get('dmpl__ReturnType__c') =='Shortage'){
                //     itemLedger.dmpl__ShortageQuantity__c = (Double)lineEntry.Get('dmpl__Quantity__c') * -1;
                // }
            }
            when TransferInward {
                if (lineEntry.Get('dmpl__TransferType__c') == 'Pending Deliveries Transfer') {
                    itemLedger.dmpl__Quantity__c = 0;
                    itemLedger.dmpl__PendingDeliveriesQuantity__c = (Double)lineEntry.Get('dmpl__Quantity__c');
                // }else if(lineEntry.Get('dmpl__ReceivedQuantity__c') != null && (Double)lineEntry.Get('dmpl__ReceivedQuantity__c') >= 0) {
                //         itemLedger.dmpl__Quantity__c = (Double)lineEntry.Get('dmpl__ReceivedQuantity__c');
                    }else {
                        itemLedger.dmpl__Quantity__c = (Double)lineEntry.Get('dmpl__Quantity__c');
                } 
            }              
            when TransferOutward{
                if(lineEntry.Get('dmpl__TransferType__c') == 'Pending Deliveries Transfer'){
                    itemLedger.dmpl__Quantity__c =  0;
                    itemLedger.dmpl__PendingDeliveriesQuantity__c =  (Double)lineEntry.Get('dmpl__Quantity__c');
                } else {
                    itemLedger.dmpl__Quantity__c =  (Double)lineEntry.Get('dmpl__Quantity__c');
                }
            }
            when SaleReturn{
                itemLedger.dmpl__Quantity__c =  (Double)lineEntry.Get('dmpl__Quantity__c');
                if(lineEntry.Get('dmpl__DeliveryOrderLineId__c')!=null ){
                    itemLedger.dmpl__AllocatedQuantity__c = (Double)lineEntry.Get('dmpl__Quantity__c');
                }
            }
            when Damaged{
                if (lineEntry.get('dmpl__DamagedQuantity__c') != null) {
                itemLedger.dmpl__Quantity__c =  (Double)lineEntry.Get('dmpl__DamagedQuantity__c');
                }
            }
            when Shortage{
                itemLedger.dmpl__Quantity__c =  (Double)lineEntry.Get('dmpl__ShortageQuantity__c');
            }
            when Expired{
                itemLedger.dmpl__Quantity__c =  (Double)lineEntry.Get('dmpl__ExpiredQuantity__c');
            }
            when Excess{
                itemLedger.dmpl__Quantity__c =  (Double)lineEntry.Get('dmpl__ExcessQuantity__c');
            }
            when InspectionAdjustment{
                itemLedger.dmpl__Quantity__c =  (Double)lineEntry.Get('dmpl__AdjustmentQuantity__c');
            } 
            when Fulfillment{
                itemLedger.dmpl__Quantity__c =  (Double)lineEntry.Get('dmpl__FulfillmentQuantity__c');
            }
            when SoftCommit{
                itemLedger.dmpl__Quantity__c =  (Double)lineEntry.Get('dmpl__Quantity__c') 
                    - (lineEntry.Get('dmpl__CancelledQuantity__c') == null ? 
                        0 : (Double)lineEntry.Get('dmpl__CancelledQuantity__c'));
            }
            when Pipeline{
                itemLedger.dmpl__Quantity__c =  (Double)lineEntry.Get('dmpl__Quantity__c') 
                    - (lineEntry.Get('dmpl__CancelledQuantity__c') == null ? 
                        0 : (Double)lineEntry.Get('dmpl__CancelledQuantity__c'));
            }
            when Allocation{
                itemLedger.dmpl__Quantity__c =  (Double)lineEntry.Get('dmpl__Quantity__c');
                itemLedger.dmpl__SoftCommittedQuantity__c =  (Double)lineEntry.Get('dmpl__SoftCommittedQuantity__c') * -1;
            }
            when else {
                itemLedger.dmpl__Quantity__c =  (Double)lineEntry.Get('dmpl__Quantity__c');
            }
        }
    }

    private static Boolean isApproved(sObject lineEntry){
        Boolean isApproved = true;
        if(lineEntry.Get('dmpl__IsILPostingApproved__c') !=null){
            isApproved = (Boolean)lineEntry.Get('dmpl__IsILPostingApproved__c');
        }
        return isApproved;
    }
    
    private static Boolean IsPosted(sObject lineEntry){
        Boolean isPosted = true;
        if(lineEntry.Get('dmpl__IsILPosted__c') !=null){
            isPosted = (Boolean)lineEntry.Get('dmpl__IsILPosted__c');
        }
        return isPosted;
    }

    private static Boolean isPostingRequired(
        InventoryLedgerTypeEnums ledgerType, 
        sObject lineEntry, 
        dmpl__Item__c item){
        if(ledgerType == InventoryLedgerTypeEnums.Inspection){
            return (Double)lineEntry.Get('dmpl__InspectionQuantity__c') != 0;
        }else if(ledgerType == InventoryLedgerTypeEnums.Damaged){
            return (Double)lineEntry.Get('dmpl__DamagedQuantity__c') != 0;
        }else if(ledgerType == InventoryLedgerTypeEnums.Shortage){
            return (Double)lineEntry.Get('dmpl__ShortageQuantity__c') != 0;
        }else if(ledgerType == InventoryLedgerTypeEnums.Excess){
                return (Double)lineEntry.Get('dmpl__ExcessQuantity__c') != 0;
        }else if(ledgerType == InventoryLedgerTypeEnums.InspectionAdjustment){
            return (Double)lineEntry.Get('dmpl__AdjustmentQuantity__c') != 0;
        }else if(ledgerType == InventoryLedgerTypeEnums.Allocation){
            return (Double)lineEntry.Get('dmpl__Quantity__c') != 0;
        }else if(ledgerType == InventoryLedgerTypeEnums.Picked){
            return (Double)lineEntry.Get('dmpl__Quantity__c') != 0;
        }else if(ledgerType == InventoryLedgerTypeEnums.Pipeline){
            return (Double)lineEntry.Get('dmpl__Quantity__c') 
                    - (lineEntry.Get('dmpl__CancelledQuantity__c') == null ? 
                        0 : (Double)lineEntry.Get('dmpl__CancelledQuantity__c')) > 0;
        }else if(ledgerType == InventoryLedgerTypeEnums.Fulfillment){
            return (Double)lineEntry.Get('dmpl__FulfillmentQuantity__c') != 0;
        }else if(ledgerType == InventoryLedgerTypeEnums.Outward){
            return ((Double)lineEntry.Get('dmpl__Quantity__c') > 0)
                && ((Double)lineEntry.Get('dmpl__AllocatedQuantity__c') > 0
                || (Double)lineEntry.Get('dmpl__PickedQuantity__c') > 0
                || (Double)lineEntry.Get('dmpl__InvoicedQuantity__c') > 0);
        }
        //
        return true;
    }
    
    private static sObject getCorrespondingLineEntry(
        List<sObject> newEntries, 
        sObject oldEntry)
    {
        for(sObject newEntry: newEntries){
            if(newEntry.Id == oldEntry.Id){
                return newEntry;
            }
        }
        return null;
    }

    private static sObject findMasterDocument(
        List<sObject> masterDocuments, 
        ID documentId){
        for(sObject document : masterDocuments){
            if(document.Id == documentId){
                return document;
            }
        }
        return null;
    }
}