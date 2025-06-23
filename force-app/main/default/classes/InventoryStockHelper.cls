public without sharing class InventoryStockHelper {
     
    public static void postInventoryLedgerRecords(
        Boolean isInsert, 
        Boolean isDelete, 
        Boolean isUpdate, 
        List<dmpl__InventoryLedger__c> oldEntries, 
        List<dmpl__InventoryLedger__c> newEntries)
    {
        List<dmpl__InventoryStock__c> stockLocations = GetLedgerRelatedLocations(
            newEntries, 
            oldEntries);
        Map<ID, dmpl__InventoryStock__c> updatedstockLocations = new Map<ID, dmpl__InventoryStock__c>();
        List<dmpl__InventoryStock__c> insertedstockLocations = new List<dmpl__InventoryStock__c>();
        //
        if(isDelete || isUpdate ){
            for(dmpl__InventoryLedger__c ledgerEntry : oldEntries){
                if((!ledgerEntry.IsInventoryStockPosted__c)
                    || (isUpdate && !areKeyFieldsModified(newEntries, ledgerEntry)))
                    continue;
                //
                dmpl__InventoryStock__c stockLocation = getStockLocation(ledgerEntry, stockLocations);
                if(stockLocation == null){
                    throwDmplException(System.Label.IntegrityFailed_MssingInventoryStock);
                }else if(undoLocationLedgerEntry(ledgerEntry, stockLocation)){
                    if(!updatedstockLocations.ContainsKey(stockLocation.Id)){
                        updatedstockLocations.Put(stockLocation.Id, stockLocation);
                    }
                }
                //
                if(ledgerEntry.RelatedBranchId__c !=null){
                    stockLocation = getRelatedBranchItemLocation(ledgerEntry, stockLocations);
                    if(!stockLocations.Contains(stockLocation)){
                        stockLocations.Add(stockLocation);
                    }
                    dmpl__InventoryStock__c nullStorageLocation = getCurrentBranchNullStorageItemLocation(ledgerEntry, stockLocations);
                    if(!stockLocations.Contains(nullStorageLocation)){
                        stockLocations.Add(nullStorageLocation);
                    }
                    if(stockLocation == null){
                        throwDmplException(System.Label.IntegrityFailed_MssingInventoryStock);
                    }else if(unDoRelatedBranchLocationLedgerEntry(ledgerEntry, stockLocation, nullStorageLocation)){
                        if(nullStorageLocation.Id!=null){
                            if(!updatedstockLocations.ContainsKey(nullStorageLocation.Id))
                                updatedstockLocations.Put(nullStorageLocation.Id, nullStorageLocation);
                        }else{
                            if(!insertedstockLocations.Contains(nullStorageLocation))
                                insertedstockLocations.add(nullStorageLocation);
                        }
                        if(!updatedstockLocations.ContainsKey(stockLocation.Id))
                            updatedstockLocations.Put(stockLocation.Id, stockLocation);
                    }
                }
            }
        }
        //
        if(isInsert || isUpdate ){
            for(dmpl__InventoryLedger__c ledgerEntry : newEntries){
                if(isUpdate && !areKeyFieldsModified(oldEntries, ledgerEntry)){
                    continue;
                }
                //
                dmpl__InventoryStock__c stockLocation = getStockLocation(ledgerEntry, stockLocations);
                if(stockLocation == null){
                    stockLocation= createStockLocation(ledgerEntry);
                    stockLocations.Add(stockLocation);
                }
                //
                if(doLocationLedgerEntry(ledgerEntry, stockLocation)){
                    if(!updatedstockLocations.ContainsKey(stockLocation.Id)
                        && !insertedstockLocations.Contains(stockLocation)){
                            if(stockLocation.Id == null){
                                insertedstockLocations.Add(stockLocation);
                            }else{
                                updatedstockLocations.Put(stockLocation.Id, stockLocation);
                            }
                        }
                    ledgerEntry.IsInventoryStockPosted__c = true;
                }
                //
                if(ledgerEntry.RelatedBranchId__c !=null){
                    stockLocation = getRelatedBranchItemLocation(ledgerEntry, stockLocations);
                    if(!stockLocations.Contains(stockLocation)){
                        stockLocations.Add(stockLocation);
                    }
                    dmpl__InventoryStock__c nullStorageLocation = getCurrentBranchNullStorageItemLocation(ledgerEntry, stockLocations);
                    if(!stockLocations.Contains(nullStorageLocation)){
                        stockLocations.Add(nullStorageLocation);
                    }
                    //
                    if(doRelatedBranchLocationLedgerEntry(ledgerEntry, stockLocation, nullStorageLocation)){
                        if(nullStorageLocation.Id == null){
                            if(!insertedstockLocations.Contains(nullStorageLocation)){
                                insertedstockLocations.Add(nullStorageLocation);
                            }
                        }else If(!updatedstockLocations.ContainsKey(nullStorageLocation.Id)){
                            updatedstockLocations.Put(nullStorageLocation.Id, nullStorageLocation);
                        }

                        if(stockLocation.Id == null){
                            if(!insertedstockLocations.Contains(stockLocation)){
                                insertedstockLocations.Add(stockLocation);
                            }
                        }else if(!updatedstockLocations.ContainsKey(stockLocation.Id)){
                            updatedstockLocations.Put(stockLocation.Id, stockLocation);
                        }
 
                    }
                }
            }
        }
        
        try {
            TriggerHandler.skipValidations = true;
            update updatedstockLocations.Values();
            insert insertedstockLocations;    
        } finally {
            TriggerHandler.skipValidations = false;
        }
    }

    private static Boolean areKeyFieldsModified(List<dmpl__InventoryLedger__c> oldEntries, dmpl__InventoryLedger__c newEntry){
        dmpl__InventoryLedger__c oldEntry = getOldEntry(oldEntries, newEntry);
        return (oldEntry.dmpl__ItemId__c != newEntry.dmpl__ItemId__c 
            ||oldEntry.dmpl__SKUId__c != newEntry.dmpl__SKUId__c 
            ||oldEntry.dmpl__ItemLotId__c != newEntry.dmpl__ItemLotId__c 
            ||oldEntry.dmpl__BranchId__c != newEntry.dmpl__BranchId__c 
            ||oldEntry.dmpl__StorageLocationId__c != newEntry.dmpl__StorageLocationId__c 
            ||oldEntry.dmpl__DocumentDate__c != newEntry.dmpl__DocumentDate__c 
            ||oldEntry.dmpl__Quantity__c != newEntry.dmpl__Quantity__c 
            ||oldEntry.dmpl__RelatedBranchId__c != newEntry.dmpl__RelatedBranchId__c 
            ||oldEntry.dmpl__DamagedQuantity__c != newEntry.dmpl__DamagedQuantity__c
            ||oldEntry.dmpl__ShortageQuantity__c != newEntry.dmpl__ShortageQuantity__c
            ||oldEntry.dmpl__InwardQuantity__c != newEntry.dmpl__InwardQuantity__c
            ||oldEntry.dmpl__InventoryLedgerType__c != newEntry.dmpl__InventoryLedgerType__c
            ||oldEntry.dmpl__PartnerAccountId__c != newEntry.dmpl__PartnerAccountId__c
            ||oldEntry.dmpl__PendingDeliveriesQuantity__c != newEntry.dmpl__PendingDeliveriesQuantity__c
            ||oldEntry.dmpl__PickedQuantity__c != newEntry.dmpl__PickedQuantity__c
            ||oldEntry.dmpl__PipelineQuantity__c != newEntry.dmpl__PipelineQuantity__c
            ||oldEntry.dmpl__AllocatedQuantity__c != newEntry.dmpl__AllocatedQuantity__c
            ||oldEntry.dmpl__SoftCommittedQuantity__c != newEntry.dmpl__SoftCommittedQuantity__c
            ||oldEntry.dmpl__DeliveredQuantity__c != newEntry.dmpl__DeliveredQuantity__c
            ||oldEntry.dmpl__RelatedItemLotId__c != newEntry.dmpl__RelatedItemLotId__c
            ||oldEntry.dmpl__RelatedItemLotId__c != newEntry.dmpl__RelatedItemLotId__c
            ||oldEntry.dmpl__RelatedPartnerAccountId__c != newEntry.dmpl__RelatedPartnerAccountId__c);
    }

    private static dmpl__InventoryLedger__c getOldEntry(List<dmpl__InventoryLedger__c> oldEntries, dmpl__InventoryLedger__c newEntry){
        for(dmpl__InventoryLedger__c oldEntry : oldEntries){
            if(oldEntry.Id == newEntry.Id){
                return oldEntry;
            }
        }
        //
        return null;
    }

    private static Boolean doLocationLedgerEntry(dmpl__InventoryLedger__c ledgerEntry, dmpl__InventoryStock__c locationEntry){
        InventoryLedgerTypeEnums ledgerType = InventoryLedgerHelper.getLedgerType(ledgerEntry.InventoryLedgerType__c);
        locationEntry.HashCode__c = getHashCode();
        if(ledgerType == InventoryLedgerTypeEnums.Adjustment || ledgerType == InventoryLedgerTypeEnums.InspectionAdjustment){
            return doAdjustmentLedgerEntry(ledgerEntry, locationEntry);
        }else if(ledgerType == InventoryLedgerTypeEnums.TransferOutward){
            return doTransferOutwardLedgerEntry(ledgerEntry, locationEntry);
        }else if(ledgerType == InventoryLedgerTypeEnums.TransferInward){
            return doTransferInwardLedgerEntry(ledgerEntry, locationEntry);
        }else if(ledgerType == InventoryLedgerTypeEnums.Inward){
            return doInwardLedgerEntry(ledgerEntry, locationEntry);
        }else if(ledgerType == InventoryLedgerTypeEnums.Outward){
            return doOutwardLedgerEntry(ledgerEntry, locationEntry);
        }else if(ledgerType == InventoryLedgerTypeEnums.Assemble){
            return doAssembleLedgerEntry(ledgerEntry, locationEntry);
        }else if(ledgerType == InventoryLedgerTypeEnums.Fulfillment){
            return doFulfillmentLedgerEntry(ledgerEntry, locationEntry);
        }else if(ledgerType == InventoryLedgerTypeEnums.Allocation){
            return doAllocationLedgerEntry(ledgerEntry, locationEntry);
        }else if(ledgerType == InventoryLedgerTypeEnums.Picked){
            return doPickedLedgerEntry(ledgerEntry, locationEntry);
        }else if(ledgerType == InventoryLedgerTypeEnums.Purchased){
            return doPurchasedLedgerEntry(ledgerEntry, locationEntry);
        }else if(ledgerType == InventoryLedgerTypeEnums.Sold){
            return doSoldLedgerEntry(ledgerEntry, locationEntry);
        }else if(ledgerType == InventoryLedgerTypeEnums.Damaged){
            return DoDamagedLedgerEntry(ledgerEntry, locationEntry);
        }else if(ledgerType == InventoryLedgerTypeEnums.Shortage){
            return DoShortageLedgerEntry(ledgerEntry, locationEntry);
        }else if(ledgerType == InventoryLedgerTypeEnums.Excess){
            return DoExcessLedgerEntry(ledgerEntry, locationEntry);
        }else if(ledgerType == InventoryLedgerTypeEnums.Expired){
            return DoExpiredLedgerEntry(ledgerEntry, locationEntry);
        }else if(ledgerType == InventoryLedgerTypeEnums.OnHold){
            return DoHoldLedgerEntry(ledgerEntry, locationEntry);
        }else if(ledgerType == InventoryLedgerTypeEnums.OnLoan){
            return DoLoanLedgerEntry(ledgerEntry, locationEntry);
        }else if(ledgerType == InventoryLedgerTypeEnums.Inspection){
            return doInspectionLedgerEntry(ledgerEntry, locationEntry);
        }else if(ledgerType == InventoryLedgerTypeEnums.SaleReturn){
            return doSaleReturnLedgerEntry(ledgerEntry, locationEntry);
        }else if(ledgerType == InventoryLedgerTypeEnums.PurchaseReturn){
            return doPurchaseReturnLedgerEntry(ledgerEntry, locationEntry);
        }else if(ledgerType == InventoryLedgerTypeEnums.Pipeline){
            return doPipelineLedgerEntry(ledgerEntry, locationEntry);
        }else if(ledgerType == InventoryLedgerTypeEnums.SoftCommit){
            return doSoftCommitLedgerEntry(ledgerEntry, locationEntry);
        }else {
            throwDmplException(System.Label.InventoryStock_InvalidLedgerType);
        }
        return false;
    }

    private static Boolean unDoLocationLedgerEntry(dmpl__InventoryLedger__c ledgerEntry, dmpl__InventoryStock__c locationEntry)
    {
        InventoryLedgerTypeEnums ledgerType = InventoryLedgerHelper.getLedgerType(ledgerEntry.InventoryLedgerType__c);
        locationEntry.HashCode__c = getHashCode();
        if(ledgerType == InventoryLedgerTypeEnums.Adjustment || ledgerType == InventoryLedgerTypeEnums.InspectionAdjustment){
            return unDoAdjustmentLedgerEntry(ledgerEntry, locationEntry);
        }else if(ledgerType == InventoryLedgerTypeEnums.TransferOutward){
            return unDoTransferOutwardLedgerEntry(ledgerEntry, locationEntry);
        }else if(ledgerType == InventoryLedgerTypeEnums.TransferInward){
            return unDoTransferInwardLedgerEntry(ledgerEntry, locationEntry);
        }else if(ledgerType == InventoryLedgerTypeEnums.Inward){
            return unDoInwardLedgerEntry(ledgerEntry, locationEntry);
        }else if(ledgerType == InventoryLedgerTypeEnums.Outward){
            return unDoOutwardLedgerEntry(ledgerEntry, locationEntry);
        }else if(ledgerType == InventoryLedgerTypeEnums.Assemble){
            return unDoAssembleLedgerEntry(ledgerEntry, locationEntry);
        }else if(ledgerType == InventoryLedgerTypeEnums.Fulfillment){
            return unDoFulfillmentLedgerEntry(ledgerEntry, locationEntry);
        }else if(ledgerType == InventoryLedgerTypeEnums.Allocation){
            return unDoAllocationLedgerEntry(ledgerEntry, locationEntry);
        }else if(ledgerType == InventoryLedgerTypeEnums.Picked){
            return unDoPickedLedgerEntry(ledgerEntry, locationEntry);
        }else if(ledgerType == InventoryLedgerTypeEnums.Purchased){
            return unDoPurchasedLedgerEntry(ledgerEntry, locationEntry);
        }else if(ledgerType == InventoryLedgerTypeEnums.Sold){
            return unDoSoldLedgerEntry(ledgerEntry, locationEntry);
        }else if(ledgerType == InventoryLedgerTypeEnums.Damaged){
            return unDoDamagedLedgerEntry(ledgerEntry, locationEntry);
        }else if(ledgerType == InventoryLedgerTypeEnums.Shortage){
            return unDoShortageLedgerEntry(ledgerEntry, locationEntry);
        }else if(ledgerType == InventoryLedgerTypeEnums.Excess){
            return unDoExcessLedgerEntry(ledgerEntry, locationEntry);
        }else if(ledgerType == InventoryLedgerTypeEnums.Expired){
            return unDoExpiredLedgerEntry(ledgerEntry, locationEntry);
        }else if(ledgerType == InventoryLedgerTypeEnums.OnHold){
            return unDoHoldLedgerEntry(ledgerEntry, locationEntry);
        }else if(ledgerType == InventoryLedgerTypeEnums.OnLoan){
            return unDoLoanLedgerEntry(ledgerEntry, locationEntry);
        }else if(ledgerType == InventoryLedgerTypeEnums.Inspection){
            return unDoInspectionLedgerEntry(ledgerEntry, locationEntry);
        }else if(ledgerType == InventoryLedgerTypeEnums.SaleReturn){
            return unDoSaleReturnLedgerEntry(ledgerEntry, locationEntry);
        }else if(ledgerType == InventoryLedgerTypeEnums.PurchaseReturn){
            return unDoPurchaseReturnLedgerEntry(ledgerEntry, locationEntry);
        }else if(ledgerType == InventoryLedgerTypeEnums.Pipeline){
            return unDoPipelineLedgerEntry(ledgerEntry, locationEntry);
        }else if(ledgerType == InventoryLedgerTypeEnums.SoftCommit){
            return unDoSoftCommitLedgerEntry(ledgerEntry, locationEntry);
        }else {
            throwDmplException(System.Label.InventoryStock_InvalidLedgerType);
        }
        return false;
    }

    @testVisible
    private static Boolean doRelatedBranchLocationLedgerEntry(dmpl__InventoryLedger__c ledgerEntry, dmpl__InventoryStock__c locationEntry, dmpl__InventoryStock__c nullStorageLocation)
    {
        InventoryLedgerTypeEnums ledgerType = InventoryLedgerHelper.getLedgerType(ledgerEntry.InventoryLedgerType__c);
        if(ledgerType == InventoryLedgerTypeEnums.TransferInward)
            unDoTransitLedgerEntry(ledgerEntry, nullStorageLocation);
        else if(ledgerType == InventoryLedgerTypeEnums.TransferOutward)
            doTransitLedgerEntry(ledgerEntry, locationEntry);
        //
        return true;
    }

    @TestVisible
    private static Boolean unDoRelatedBranchLocationLedgerEntry(dmpl__InventoryLedger__c ledgerEntry, dmpl__InventoryStock__c locationEntry, dmpl__InventoryStock__c nullStorageLocation)
    {
        InventoryLedgerTypeEnums ledgerType = InventoryLedgerHelper.getLedgerType(ledgerEntry.InventoryLedgerType__c);
        if(ledgerType == InventoryLedgerTypeEnums.TransferInward)
            doTransitLedgerEntry(ledgerEntry, nullStorageLocation);
        else if(ledgerType == InventoryLedgerTypeEnums.TransferOutward)
            unDoTransitLedgerEntry(ledgerEntry, locationEntry);
        //
        return true;
    }

   @TestVisible private static Boolean doTransferOutwardLedgerEntry(dmpl__InventoryLedger__c ledgerEntry, dmpl__InventoryStock__c locationEntry)
    {
        locationEntry.dmpl__QuantityTransferOut__c = (locationEntry.dmpl__QuantityTransferOut__c == null ? 0 : locationEntry.dmpl__QuantityTransferOut__c) + ledgerEntry.dmpl__Quantity__c;
        locationEntry.dmpl__QuantityInPendingDeliveries__c = (locationEntry.dmpl__QuantityInPendingDeliveries__c == null ? 0 : locationEntry.dmpl__QuantityInPendingDeliveries__c) - (ledgerEntry.dmpl__PendingDeliveriesQuantity__c == null ? 0 : ledgerEntry.dmpl__PendingDeliveriesQuantity__c);
        return true;
    }

    @testVisible
    private static Boolean unDoTransferOutwardLedgerEntry(dmpl__InventoryLedger__c ledgerEntry, dmpl__InventoryStock__c locationEntry)
    {
        locationEntry.dmpl__QuantityTransferOut__c = (locationEntry.dmpl__QuantityTransferOut__c == null ? 0 : locationEntry.dmpl__QuantityTransferOut__c) - ledgerEntry.dmpl__Quantity__c;
        locationEntry.dmpl__QuantityInPendingDeliveries__c = (locationEntry.dmpl__QuantityInPendingDeliveries__c == null ? 0 : locationEntry.dmpl__QuantityInPendingDeliveries__c) + (ledgerEntry.dmpl__PendingDeliveriesQuantity__c == null ? 0 : ledgerEntry.dmpl__PendingDeliveriesQuantity__c);
        return true;
    }

    private static Boolean doTransferInwardLedgerEntry(dmpl__InventoryLedger__c ledgerEntry, dmpl__InventoryStock__c locationEntry)
    {
        locationEntry.dmpl__QuantityTransferIn__c = (locationEntry.dmpl__QuantityTransferIn__c == null ? 0 : locationEntry.dmpl__QuantityTransferIn__c) + ledgerEntry.dmpl__Quantity__c;
        locationEntry.dmpl__QuantityInPendingDeliveries__c = (locationEntry.dmpl__QuantityInPendingDeliveries__c == null ? 0 : locationEntry.dmpl__QuantityInPendingDeliveries__c) + (ledgerEntry.dmpl__PendingDeliveriesQuantity__c == null ? 0 : ledgerEntry.dmpl__PendingDeliveriesQuantity__c);
        return true;
    }

   @TestVisible private static Boolean unDoTransferInwardLedgerEntry(dmpl__InventoryLedger__c ledgerEntry, dmpl__InventoryStock__c locationEntry)
    {
        locationEntry.dmpl__QuantityTransferIn__c = (locationEntry.dmpl__QuantityTransferIn__c == null ? 0 : locationEntry.dmpl__QuantityTransferIn__c) - ledgerEntry.dmpl__Quantity__c;
        locationEntry.dmpl__QuantityInPendingDeliveries__c = (locationEntry.dmpl__QuantityInPendingDeliveries__c == null ? 0 : locationEntry.dmpl__QuantityInPendingDeliveries__c) - (ledgerEntry.dmpl__PendingDeliveriesQuantity__c == null ? 0 : ledgerEntry.dmpl__PendingDeliveriesQuantity__c);
        return true;
    }
    
    @testVisible
    private static Boolean doTransitLedgerEntry(dmpl__InventoryLedger__c ledgerEntry, dmpl__InventoryStock__c locationEntry)
    {
        locationEntry.dmpl__QuantityInTransit__c = (locationEntry.dmpl__QuantityInTransit__c == null ? 0 : locationEntry.dmpl__QuantityInTransit__c) + ledgerEntry.dmpl__Quantity__c;
        return true;
    }

    @testVisible
    private static Boolean unDoTransitLedgerEntry(dmpl__InventoryLedger__c ledgerEntry, dmpl__InventoryStock__c locationEntry)
    {
        locationEntry.dmpl__QuantityInTransit__c = (locationEntry.dmpl__QuantityInTransit__c == null ? 0 : locationEntry.dmpl__QuantityInTransit__c) - ledgerEntry.dmpl__Quantity__c;
        return true;
    }
    
    private static Boolean doAdjustmentLedgerEntry(dmpl__InventoryLedger__c ledgerEntry, dmpl__InventoryStock__c locationEntry)
    {
        if(ledgerEntry.dmpl__Quantity__c > 0)
            locationEntry.dmpl__QuantityAdjustedIn__c = (locationEntry.dmpl__QuantityAdjustedIn__c == null ? 0 : locationEntry.dmpl__QuantityAdjustedIn__c) + ledgerEntry.dmpl__Quantity__c;
        else if(ledgerEntry.dmpl__Quantity__c < 0)
            locationEntry.dmpl__QuantityAdjustedOut__c = (locationEntry.dmpl__QuantityAdjustedOut__c == null ? 0 : locationEntry.dmpl__QuantityAdjustedOut__c) + Math.Abs(ledgerEntry.dmpl__Quantity__c);

        return true;
    }

    private static Boolean unDoAdjustmentLedgerEntry(dmpl__InventoryLedger__c ledgerEntry, dmpl__InventoryStock__c locationEntry)
    {
        if(ledgerEntry.dmpl__Quantity__c > 0)
            locationEntry.dmpl__QuantityAdjustedIn__c = (locationEntry.dmpl__QuantityAdjustedIn__c == null ? 0 : locationEntry.dmpl__QuantityAdjustedIn__c) - ledgerEntry.dmpl__Quantity__c;
        else if(ledgerEntry.dmpl__Quantity__c < 0)
            locationEntry.dmpl__QuantityAdjustedOut__c = (locationEntry.dmpl__QuantityAdjustedOut__c == null ? 0 : locationEntry.dmpl__QuantityAdjustedOut__c) - Math.Abs(ledgerEntry.dmpl__Quantity__c);

        return true;
    }

    private static Boolean doInwardLedgerEntry(dmpl__InventoryLedger__c ledgerEntry, dmpl__InventoryStock__c locationEntry)
    {
        if(ledgerEntry.dmpl__Quantity__c > 0)
        locationEntry.dmpl__QuantityOnInward__c = 
            (locationEntry.dmpl__QuantityOnInward__c == null ? 0 
                : locationEntry.dmpl__QuantityOnInward__c) 
            + ledgerEntry.dmpl__Quantity__c;
        locationEntry.dmpl__QuantityInPipeline__c = 
            (locationEntry.dmpl__QuantityInPipeline__c == null ? 0 
                : locationEntry.dmpl__QuantityInPipeline__c) 
            + (ledgerEntry.dmpl__PipelineQuantity__c == null ? 0 
                : ledgerEntry.dmpl__PipelineQuantity__c);
        return true;
    }

    @testVisible
    private static Boolean unDoInwardLedgerEntry(dmpl__InventoryLedger__c ledgerEntry, dmpl__InventoryStock__c locationEntry)
    {
        locationEntry.dmpl__QuantityOnInward__c = 
            (locationEntry.dmpl__QuantityOnInward__c == null ? 0 
                : locationEntry.dmpl__QuantityOnInward__c) 
            - ledgerEntry.dmpl__Quantity__c;
        locationEntry.dmpl__QuantityInPipeline__c = 
            (locationEntry.dmpl__QuantityInPipeline__c == null ? 0 
                : locationEntry.dmpl__QuantityInPipeline__c) 
            - (ledgerEntry.dmpl__PipelineQuantity__c == null ? 0 
                : ledgerEntry.dmpl__PipelineQuantity__c);
        return true;
    }

    @testVisible
    private static Boolean doOutwardLedgerEntry(
        dmpl__InventoryLedger__c ledgerEntry, 
        dmpl__InventoryStock__c locationEntry){
        locationEntry.dmpl__QuantityOnOutward__c = (locationEntry.dmpl__QuantityOnOutward__c == null ? 
            0 : locationEntry.dmpl__QuantityOnOutward__c) 
            + (ledgerEntry.dmpl__Quantity__c == null ? 
            0 : ledgerEntry.dmpl__Quantity__c);
        locationEntry.dmpl__QuantityOnAllocation__c = (locationEntry.dmpl__QuantityOnAllocation__c == null ? 
            0 : locationEntry.dmpl__QuantityOnAllocation__c) 
            - (ledgerEntry.dmpl__AllocatedQuantity__c == null ? 
            0 : ledgerEntry.dmpl__AllocatedQuantity__c);
        locationEntry.dmpl__QuantityPicked__c = (locationEntry.dmpl__QuantityPicked__c == null ? 
            0 : locationEntry.dmpl__QuantityPicked__c) 
            - (ledgerEntry.dmpl__PickedQuantity__c == null ? 
            0 : ledgerEntry.dmpl__PickedQuantity__c);
        locationEntry.dmpl__QuantityInPendingDeliveries__c = (locationEntry.dmpl__QuantityInPendingDeliveries__c == null ? 
            0 : locationEntry.dmpl__QuantityInPendingDeliveries__c) 
            - (ledgerEntry.dmpl__PendingDeliveriesQuantity__c == null ? 
            0 : ledgerEntry.dmpl__PendingDeliveriesQuantity__c);
        return true;
    }

    @testVisible
    private static Boolean unDoOutwardLedgerEntry(
        dmpl__InventoryLedger__c ledgerEntry, 
        dmpl__InventoryStock__c locationEntry){
        locationEntry.dmpl__QuantityOnOutward__c = (locationEntry.dmpl__QuantityOnOutward__c == null ? 
            0 : locationEntry.dmpl__QuantityOnOutward__c) 
            - (ledgerEntry.dmpl__Quantity__c == null ? 
            0 : ledgerEntry.dmpl__Quantity__c);
        locationEntry.dmpl__QuantityOnAllocation__c = (locationEntry.dmpl__QuantityOnAllocation__c == null ? 
            0 : locationEntry.dmpl__QuantityOnAllocation__c) 
            + (ledgerEntry.dmpl__AllocatedQuantity__c == null ? 
            0 : ledgerEntry.dmpl__AllocatedQuantity__c);
        locationEntry.dmpl__QuantityPicked__c = (locationEntry.dmpl__QuantityPicked__c == null ? 
            0 : locationEntry.dmpl__QuantityPicked__c) 
            + (ledgerEntry.dmpl__PickedQuantity__c == null ? 
            0 : ledgerEntry.dmpl__PickedQuantity__c);
        locationEntry.dmpl__QuantityInPendingDeliveries__c = (locationEntry.dmpl__QuantityInPendingDeliveries__c == null ? 
            0 : locationEntry.dmpl__QuantityInPendingDeliveries__c) 
            + (ledgerEntry.dmpl__PendingDeliveriesQuantity__c == null ? 
            0 : ledgerEntry.dmpl__PendingDeliveriesQuantity__c);
        return true;
    }

    @testVisible   
    private static Boolean doAssembleLedgerEntry(dmpl__InventoryLedger__c ledgerEntry, dmpl__InventoryStock__c locationEntry)
    {
        if(ledgerEntry.dmpl__Quantity__c > 0)
            locationEntry.dmpl__QuantityAssembledIn__c = (locationEntry.dmpl__QuantityAssembledIn__c == null ? 0 : locationEntry.dmpl__QuantityAssembledIn__c) + ledgerEntry.dmpl__Quantity__c;
        else if(ledgerEntry.dmpl__Quantity__c < 0)
            locationEntry.dmpl__QuantityAssembledOut__c = (locationEntry.dmpl__QuantityAssembledOut__c == null ? 0 : locationEntry.dmpl__QuantityAssembledOut__c) + Math.Abs(ledgerEntry.dmpl__Quantity__c);

        return true;
    }

 @TestVisible   private static Boolean unDoAssembleLedgerEntry(dmpl__InventoryLedger__c ledgerEntry, dmpl__InventoryStock__c locationEntry)
    {
        if(ledgerEntry.dmpl__Quantity__c > 0)
            locationEntry.dmpl__QuantityAssembledIn__c = (locationEntry.dmpl__QuantityAssembledIn__c == null ? 0 : locationEntry.dmpl__QuantityAssembledIn__c) - ledgerEntry.dmpl__Quantity__c;
        else if(ledgerEntry.dmpl__Quantity__c < 0)
            locationEntry.dmpl__QuantityAssembledOut__c = (locationEntry.dmpl__QuantityAssembledOut__c == null ? 0 : locationEntry.dmpl__QuantityAssembledOut__c) - Math.Abs(ledgerEntry.dmpl__Quantity__c);

        return true;
    }
    
 @TestVisible   private static Boolean doFulfillmentLedgerEntry(dmpl__InventoryLedger__c ledgerEntry, dmpl__InventoryStock__c locationEntry)
    {
        locationEntry.dmpl__QuantityOnFulfillment__c = (locationEntry.dmpl__QuantityOnFulfillment__c == null ? 0 : locationEntry.dmpl__QuantityOnFulfillment__c) + ledgerEntry.dmpl__Quantity__c;
        return true;
    }

  @TestVisible  
    private static Boolean unDoFulfillmentLedgerEntry(dmpl__InventoryLedger__c ledgerEntry, dmpl__InventoryStock__c locationEntry)
    {
        locationEntry.dmpl__QuantityOnFulfillment__c = (locationEntry.dmpl__QuantityOnFulfillment__c == null ? 0 : locationEntry.dmpl__QuantityOnFulfillment__c) - ledgerEntry.dmpl__Quantity__c;
        return true;
    }
    
  @testVisible  
  private static Boolean doAllocationLedgerEntry(
    dmpl__InventoryLedger__c ledgerEntry, 
    dmpl__InventoryStock__c locationEntry){
        locationEntry.dmpl__QuantityOnAllocation__c = (locationEntry.dmpl__QuantityOnAllocation__c == null ? 
                0 : locationEntry.dmpl__QuantityOnAllocation__c) 
                    + ledgerEntry.dmpl__Quantity__c;

        locationEntry.dmpl__QuantitySoftCommitted__c = (locationEntry.dmpl__QuantitySoftCommitted__c == null ? 
                0 : locationEntry.dmpl__QuantitySoftCommitted__c) 
            + (ledgerEntry.dmpl__SoftCommittedQuantity__c == null ? 
                0 : ledgerEntry.dmpl__SoftCommittedQuantity__c);
        return true;
    }

  @testVisible  
  private static Boolean unDoAllocationLedgerEntry(
    dmpl__InventoryLedger__c ledgerEntry, 
    dmpl__InventoryStock__c locationEntry){
        locationEntry.dmpl__QuantityOnAllocation__c = (locationEntry.dmpl__QuantityOnAllocation__c == null ? 
                0 : locationEntry.dmpl__QuantityOnAllocation__c) 
                    - ledgerEntry.dmpl__Quantity__c;
        locationEntry.dmpl__QuantitySoftCommitted__c = (locationEntry.dmpl__QuantitySoftCommitted__c == null ? 
                0 : locationEntry.dmpl__QuantitySoftCommitted__c) 
            - (ledgerEntry.dmpl__SoftCommittedQuantity__c == null ? 
                0 : ledgerEntry.dmpl__SoftCommittedQuantity__c);
        return true;
    }
    
 @TestVisible   private static Boolean doPickedLedgerEntry(dmpl__InventoryLedger__c ledgerEntry, dmpl__InventoryStock__c locationEntry)
    {
        locationEntry.dmpl__QuantityPicked__c = (locationEntry.dmpl__QuantityPicked__c == null ? 0 : locationEntry.dmpl__QuantityPicked__c) + ledgerEntry.dmpl__Quantity__c;
        locationEntry.dmpl__QuantityOnAllocation__c = (locationEntry.dmpl__QuantityOnAllocation__c == null ? 0 : locationEntry.dmpl__QuantityOnAllocation__c) - ledgerEntry.dmpl__Quantity__c;
        return true;
    }

 @TestVisible   private static Boolean unDoPickedLedgerEntry(dmpl__InventoryLedger__c ledgerEntry, dmpl__InventoryStock__c locationEntry)
    {
        locationEntry.dmpl__QuantityPicked__c = (locationEntry.dmpl__QuantityPicked__c == null ? 0 : locationEntry.dmpl__QuantityPicked__c) - ledgerEntry.dmpl__Quantity__c;
        locationEntry.dmpl__QuantityOnAllocation__c = (locationEntry.dmpl__QuantityOnAllocation__c == null ? 0 : locationEntry.dmpl__QuantityOnAllocation__c) + ledgerEntry.dmpl__Quantity__c;
        return true;
    }
    
  @TestVisible  private static Boolean doPurchasedLedgerEntry(dmpl__InventoryLedger__c ledgerEntry, dmpl__InventoryStock__c locationEntry)
    {
        locationEntry.dmpl__QuantityPurchased__c = (locationEntry.dmpl__QuantityPurchased__c == null ? 0 : locationEntry.dmpl__QuantityPurchased__c) + ledgerEntry.dmpl__Quantity__c;
        locationEntry.dmpl__QuantityOnInward__c = (locationEntry.dmpl__QuantityOnInward__c == null ? 0 : locationEntry.dmpl__QuantityOnInward__c) +  (ledgerEntry.dmpl__InwardQuantity__c == null ? 0 : ledgerEntry.dmpl__InwardQuantity__c);
        return true;
    }

  @TestVisible  
    private static Boolean unDoPurchasedLedgerEntry(dmpl__InventoryLedger__c ledgerEntry, dmpl__InventoryStock__c locationEntry)
    {
        locationEntry.dmpl__QuantityPurchased__c = (locationEntry.dmpl__QuantityPurchased__c == null ? 0 : locationEntry.dmpl__QuantityPurchased__c) - ledgerEntry.dmpl__Quantity__c;
        locationEntry.dmpl__QuantityOnInward__c = (locationEntry.dmpl__QuantityOnInward__c == null ? 0 : locationEntry.dmpl__QuantityOnInward__c) - (ledgerEntry.dmpl__InwardQuantity__c == null ? 0 : ledgerEntry.dmpl__InwardQuantity__c);

        return true;
    }

    @TestVisible  
    private static Boolean doPurchaseReturnLedgerEntry(dmpl__InventoryLedger__c ledgerEntry, dmpl__InventoryStock__c locationEntry)
    {
        locationEntry.dmpl__QuantityPurchaseReturned__c = (locationEntry.dmpl__QuantityPurchaseReturned__c == null ? 0 : locationEntry.dmpl__QuantityPurchaseReturned__c) + ledgerEntry.dmpl__Quantity__c;
        return true;
    }

    @TestVisible  
    private static Boolean unDoPurchaseReturnLedgerEntry(dmpl__InventoryLedger__c ledgerEntry, dmpl__InventoryStock__c locationEntry)
    {
        locationEntry.dmpl__QuantityPurchaseReturned__c = (locationEntry.dmpl__QuantityPurchaseReturned__c == null ? 0 : locationEntry.dmpl__QuantityPurchaseReturned__c) - ledgerEntry.dmpl__Quantity__c;
        return true;
    }
    
    @testVisible  
    private static Boolean doSoldLedgerEntry(
        dmpl__InventoryLedger__c ledgerEntry, 
        dmpl__InventoryStock__c locationEntry){
        locationEntry.dmpl__QuantitySold__c = (locationEntry.dmpl__QuantitySold__c == null ? 
            0 : locationEntry.dmpl__QuantitySold__c) 
            + ledgerEntry.dmpl__Quantity__c;
        locationEntry.dmpl__QuantityOnAllocation__c = (locationEntry.dmpl__QuantityOnAllocation__c == null ? 
            0 : locationEntry.dmpl__QuantityOnAllocation__c) 
            - (ledgerEntry.dmpl__AllocatedQuantity__c == null ? 
            0 : ledgerEntry.dmpl__AllocatedQuantity__c);
        locationEntry.dmpl__QuantityPicked__c = (locationEntry.dmpl__QuantityPicked__c == null ? 
            0 : locationEntry.dmpl__QuantityPicked__c) 
            - (ledgerEntry.dmpl__PickedQuantity__c == null ? 
            0 : ledgerEntry.dmpl__PickedQuantity__c);
        locationEntry.dmpl__QuantityOnOutward__c = (locationEntry.dmpl__QuantityOnOutward__c == null ? 
            0 : locationEntry.dmpl__QuantityOnOutward__c) 
            - (ledgerEntry.dmpl__DeliveredQuantity__c == null ? 
            0 : ledgerEntry.dmpl__DeliveredQuantity__c);
        locationEntry.dmpl__QuantityInPendingDeliveries__c = (locationEntry.dmpl__QuantityInPendingDeliveries__c == null 
            ? 0 : locationEntry.dmpl__QuantityInPendingDeliveries__c) 
            + (ledgerEntry.dmpl__PendingDeliveriesQuantity__c == null ? 
            0 : ledgerEntry.dmpl__PendingDeliveriesQuantity__c);
        locationEntry.dmpl__QuantitySoftCommitted__c = (locationEntry.dmpl__QuantitySoftCommitted__c == null ? 
            0 : locationEntry.dmpl__QuantitySoftCommitted__c) 
            + (ledgerEntry.dmpl__SoftCommittedQuantity__c == null ? 
            0 : ledgerEntry.dmpl__SoftCommittedQuantity__c);
        return true;
    }

    @testVisible   
    private static Boolean unDoSoldLedgerEntry(
        dmpl__InventoryLedger__c ledgerEntry, 
        dmpl__InventoryStock__c locationEntry){
        locationEntry.dmpl__QuantitySold__c = (locationEntry.dmpl__QuantitySold__c == null ? 
            0 : locationEntry.dmpl__QuantitySold__c) 
            - ledgerEntry.dmpl__Quantity__c;
        locationEntry.dmpl__QuantityOnAllocation__c = (locationEntry.dmpl__QuantityOnAllocation__c == null ? 
            0 : locationEntry.dmpl__QuantityOnAllocation__c) 
            + (ledgerEntry.dmpl__AllocatedQuantity__c == null ? 
            0 : ledgerEntry.dmpl__AllocatedQuantity__c);
        locationEntry.dmpl__QuantityPicked__c = (locationEntry.dmpl__QuantityPicked__c == null ? 
            0 : locationEntry.dmpl__QuantityPicked__c) 
            + (ledgerEntry.dmpl__PickedQuantity__c == null ? 
            0 : ledgerEntry.dmpl__PickedQuantity__c);
        locationEntry.dmpl__QuantityOnOutward__c = (locationEntry.dmpl__QuantityOnOutward__c == null ? 
            0 : locationEntry.dmpl__QuantityOnOutward__c) 
            + (ledgerEntry.dmpl__DeliveredQuantity__c == null ? 
            0 : ledgerEntry.dmpl__DeliveredQuantity__c);
        locationEntry.dmpl__QuantityInPendingDeliveries__c = (locationEntry.dmpl__QuantityInPendingDeliveries__c == null ? 
            0 : locationEntry.dmpl__QuantityInPendingDeliveries__c) 
            - (ledgerEntry.dmpl__PendingDeliveriesQuantity__c == null ? 
            0 : ledgerEntry.dmpl__PendingDeliveriesQuantity__c);
        locationEntry.dmpl__QuantitySoftCommitted__c = (locationEntry.dmpl__QuantitySoftCommitted__c == null ? 
            0 : locationEntry.dmpl__QuantitySoftCommitted__c) 
            - (ledgerEntry.dmpl__SoftCommittedQuantity__c == null ? 
            0 : ledgerEntry.dmpl__SoftCommittedQuantity__c);
        return true;
    }

    @TestVisible  
    private static Boolean doSaleReturnLedgerEntry(dmpl__InventoryLedger__c ledgerEntry, dmpl__InventoryStock__c locationEntry)
    {
        if(ledgerEntry.dmpl__AllocatedQuantity__c > 0){
            // This is a DO return without invoice
            //locationEntry.dmpl__QuantityInPendingDeliveries__c = (locationEntry.dmpl__QuantityInPendingDeliveries__c == null ? 0 : locationEntry.dmpl__QuantityInPendingDeliveries__c) + (ledgerEntry.dmpl__PendingDeliveriesQuantity__c == null ? 0 : ledgerEntry.dmpl__PendingDeliveriesQuantity__c);
            locationEntry.dmpl__QuantityOnAllocation__c = (locationEntry.dmpl__QuantityOnAllocation__c == null ? 0 : locationEntry.dmpl__QuantityOnAllocation__c) + (ledgerEntry.dmpl__AllocatedQuantity__c == null ? 0 : ledgerEntry.dmpl__AllocatedQuantity__c);
            locationEntry.dmpl__QuantityOnOutward__c = (locationEntry.dmpl__QuantityOnOutward__c == null ? 0 : locationEntry.dmpl__QuantityOnOutward__c) - (ledgerEntry.dmpl__AllocatedQuantity__c == null ? 0 : ledgerEntry.dmpl__AllocatedQuantity__c);
        }
        else
            locationEntry.dmpl__QuantitySaleReturned__c = (locationEntry.dmpl__QuantitySaleReturned__c == null ? 0 : locationEntry.dmpl__QuantitySaleReturned__c) + ledgerEntry.dmpl__Quantity__c;

        return true;
    }

 @TestVisible   
    private static Boolean unDoSaleReturnLedgerEntry(dmpl__InventoryLedger__c ledgerEntry, dmpl__InventoryStock__c locationEntry)
    {
        if(ledgerEntry.dmpl__AllocatedQuantity__c > 0){
            // This is a DO return without invoice
            //locationEntry.dmpl__QuantityInPendingDeliveries__c = (locationEntry.dmpl__QuantityInPendingDeliveries__c == null ? 0 : locationEntry.dmpl__QuantityInPendingDeliveries__c) - (ledgerEntry.dmpl__PendingDeliveriesQuantity__c == null ? 0 : ledgerEntry.dmpl__PendingDeliveriesQuantity__c);
            locationEntry.dmpl__QuantityOnAllocation__c = (locationEntry.dmpl__QuantityOnAllocation__c == null ? 0 : locationEntry.dmpl__QuantityOnAllocation__c) - (ledgerEntry.dmpl__AllocatedQuantity__c == null ? 0 : ledgerEntry.dmpl__AllocatedQuantity__c);
            locationEntry.dmpl__QuantityOnOutward__c = (locationEntry.dmpl__QuantityOnOutward__c == null ? 0 : locationEntry.dmpl__QuantityOnOutward__c) + (ledgerEntry.dmpl__AllocatedQuantity__c == null ? 0 : ledgerEntry.dmpl__AllocatedQuantity__c);

        }
        else
            locationEntry.dmpl__QuantitySaleReturned__c = (locationEntry.dmpl__QuantitySaleReturned__c == null ? 0 : locationEntry.dmpl__QuantitySaleReturned__c) - ledgerEntry.dmpl__Quantity__c;
        return true;
    }
    
    private static Boolean doDamagedLedgerEntry(dmpl__InventoryLedger__c ledgerEntry, dmpl__InventoryStock__c locationEntry)
    {
        locationEntry.dmpl__QuantityDamaged__c = (locationEntry.dmpl__QuantityDamaged__c == null ? 0 : locationEntry.dmpl__QuantityDamaged__c) + ledgerEntry.dmpl__Quantity__c;
        return true;
    }

    @testVisible
    private static Boolean unDoDamagedLedgerEntry(dmpl__InventoryLedger__c ledgerEntry, dmpl__InventoryStock__c locationEntry)
    {
        locationEntry.dmpl__QuantityDamaged__c = (locationEntry.dmpl__QuantityDamaged__c == null ? 0 : locationEntry.dmpl__QuantityDamaged__c) - ledgerEntry.dmpl__Quantity__c;
        return true;
    }
    private static Boolean doShortageLedgerEntry(dmpl__InventoryLedger__c ledgerEntry, dmpl__InventoryStock__c locationEntry)
    {
        locationEntry.dmpl__QuantityShortage__c = (locationEntry.dmpl__QuantityShortage__c == null ? 0 : locationEntry.dmpl__QuantityShortage__c) + ledgerEntry.dmpl__Quantity__c;
        return true;
    }

    @testVisible
    private static Boolean unDoShortageLedgerEntry(dmpl__InventoryLedger__c ledgerEntry, dmpl__InventoryStock__c locationEntry)
    {
        locationEntry.dmpl__QuantityShortage__c = (locationEntry.dmpl__QuantityShortage__c == null ? 0 : locationEntry.dmpl__QuantityShortage__c) - ledgerEntry.dmpl__Quantity__c;
        return true;
    }

    private static Boolean doExcessLedgerEntry(dmpl__InventoryLedger__c ledgerEntry, dmpl__InventoryStock__c locationEntry)
    {
        locationEntry.dmpl__QuantityExcess__c = (locationEntry.dmpl__QuantityExcess__c == null ? 0 : locationEntry.dmpl__QuantityExcess__c) + ledgerEntry.dmpl__Quantity__c;
        return true;
    }

    @testVisible
    private static Boolean unDoExcessLedgerEntry(dmpl__InventoryLedger__c ledgerEntry, dmpl__InventoryStock__c locationEntry)
    {
        locationEntry.dmpl__QuantityExcess__c = (locationEntry.dmpl__QuantityExcess__c == null ? 0 : locationEntry.dmpl__QuantityExcess__c) - ledgerEntry.dmpl__Quantity__c;
        return true;
    }

    @testVisible
    private static Boolean doExpiredLedgerEntry(dmpl__InventoryLedger__c ledgerEntry, dmpl__InventoryStock__c locationEntry)
    {
        locationEntry.dmpl__QuantityExpired__c = (locationEntry.dmpl__QuantityExpired__c == null ? 0 : locationEntry.dmpl__QuantityExpired__c) + ledgerEntry.dmpl__Quantity__c;
        return true;
    }

    @testVisible
    private static Boolean unDoExpiredLedgerEntry(dmpl__InventoryLedger__c ledgerEntry, dmpl__InventoryStock__c locationEntry)
    {
        locationEntry.dmpl__QuantityExpired__c = (locationEntry.dmpl__QuantityExpired__c == null ? 0 : locationEntry.dmpl__QuantityExpired__c) - ledgerEntry.dmpl__Quantity__c;
        return true;
    }

    @testVisible
    private static Boolean doHoldLedgerEntry(dmpl__InventoryLedger__c ledgerEntry, dmpl__InventoryStock__c locationEntry)
    {
        locationEntry.dmpl__QuantityOnHold__c = (locationEntry.dmpl__QuantityOnHold__c == null ? 0 : locationEntry.dmpl__QuantityOnHold__c) + ledgerEntry.dmpl__Quantity__c;
        return true;
    }

    @testVisible
    private static Boolean unDoHoldLedgerEntry(dmpl__InventoryLedger__c ledgerEntry, dmpl__InventoryStock__c locationEntry)
    {
        locationEntry.dmpl__QuantityOnHold__c = (locationEntry.dmpl__QuantityOnHold__c == null ? 0 : locationEntry.dmpl__QuantityOnHold__c) - ledgerEntry.dmpl__Quantity__c;
        return true;
    }

    @testVisible
    private static Boolean doLoanLedgerEntry(dmpl__InventoryLedger__c ledgerEntry, dmpl__InventoryStock__c locationEntry)
    {
        locationEntry.QuantityOnLoan__c = (locationEntry.QuantityOnLoan__c == null ? 0 : locationEntry.QuantityOnLoan__c) + ledgerEntry.dmpl__Quantity__c;
        return true;
    }

    @testVisible
    private static Boolean unDoLoanLedgerEntry(dmpl__InventoryLedger__c ledgerEntry, dmpl__InventoryStock__c locationEntry)
    {
        locationEntry.QuantityOnLoan__c = (locationEntry.QuantityOnLoan__c == null ? 0 : locationEntry.QuantityOnLoan__c) - ledgerEntry.dmpl__Quantity__c;
        return true;
    }

    private static Boolean doInspectionLedgerEntry(dmpl__InventoryLedger__c ledgerEntry, dmpl__InventoryStock__c locationEntry)
    {
        locationEntry.dmpl__QuantityOnInspection__c = (locationEntry.dmpl__QuantityOnInspection__c == null ? 0 : locationEntry.dmpl__QuantityOnInspection__c) + ledgerEntry.dmpl__Quantity__c;
        return true;
    }

    @testVisible
    private static Boolean unDoInspectionLedgerEntry(dmpl__InventoryLedger__c ledgerEntry, dmpl__InventoryStock__c locationEntry)
    {
        locationEntry.dmpl__QuantityOnInspection__c = (locationEntry.dmpl__QuantityOnInspection__c == null ? 0 : locationEntry.dmpl__QuantityOnInspection__c) - ledgerEntry.dmpl__Quantity__c;
        return true;
    }

    @testVisible
    private static Boolean doPipelineLedgerEntry(
        dmpl__InventoryLedger__c ledgerEntry, 
        dmpl__InventoryStock__c locationEntry){
        locationEntry.dmpl__QuantityInPipeline__c = 
            (locationEntry.dmpl__QuantityInPipeline__c == null ? 0 
                : locationEntry.dmpl__QuantityInPipeline__c) + ledgerEntry.dmpl__Quantity__c;
        return true;
    }

    @testVisible
    private static Boolean unDoPipelineLedgerEntry(
        dmpl__InventoryLedger__c ledgerEntry, 
        dmpl__InventoryStock__c locationEntry){
        locationEntry.dmpl__QuantityInPipeline__c = 
            (locationEntry.dmpl__QuantityInPipeline__c == null ? 0 
                : locationEntry.dmpl__QuantityInPipeline__c) - ledgerEntry.dmpl__Quantity__c;
        return true;
    }

    @testVisible
    private static Boolean doSoftCommitLedgerEntry(
        dmpl__InventoryLedger__c ledgerEntry, 
        dmpl__InventoryStock__c locationEntry){
        locationEntry.dmpl__QuantitySoftCommitted__c = 
            (locationEntry.dmpl__QuantitySoftCommitted__c == null ? 0 
                : locationEntry.dmpl__QuantitySoftCommitted__c) + ledgerEntry.dmpl__Quantity__c;
        return true;
    }

    @testVisible
    private static Boolean unDoSoftCommitLedgerEntry(
        dmpl__InventoryLedger__c ledgerEntry, 
        dmpl__InventoryStock__c locationEntry){
        locationEntry.dmpl__QuantitySoftCommitted__c = 
            (locationEntry.dmpl__QuantitySoftCommitted__c == null ? 0 
                : locationEntry.dmpl__QuantitySoftCommitted__c) - ledgerEntry.dmpl__Quantity__c;
        return true;
    }
    
    private static dmpl__InventoryStock__c getStockLocation(
        dmpl__InventoryLedger__c ledgerEntry, 
        List<dmpl__InventoryStock__c> loadedstockLocations){
        for(dmpl__InventoryStock__c stockLocation : loadedstockLocations){
            if(stockLocation.dmpl__PartnerAccountId__c == ledgerEntry.dmpl__PartnerAccountId__c 
                && stockLocation.dmpl__BranchId__c == ledgerEntry.dmpl__BranchId__c 
                && stockLocation.dmpl__StorageLocationId__c == ledgerEntry.dmpl__StorageLocationId__c
                && stockLocation.dmpl__ItemId__c == ledgerEntry.dmpl__ItemId__c 
                && stockLocation.dmpl__SKUId__c == ledgerEntry.dmpl__SKUId__c){
                    return stockLocation;
                }
        }
        return null;
    }

    private static dmpl__InventoryStock__c createStockLocation(dmpl__InventoryLedger__c itemLedger)
    {
        dmpl__InventoryStock__c stockLocation = new dmpl__InventoryStock__c();
        stockLocation.dmpl__PartnerAccountId__c = itemLedger.dmpl__PartnerAccountId__c;
        stockLocation.dmpl__BranchId__c = itemLedger.dmpl__BranchId__c;
        stockLocation.dmpl__StorageLocationId__c = itemLedger.dmpl__StorageLocationId__c;
        stockLocation.dmpl__ItemId__c = itemLedger.dmpl__ItemId__c;
        stockLocation.dmpl__SKUId__c = itemLedger.dmpl__SKUId__c;
        stockLocation.dmpl__HashCode__c = getHashCode();
        return stockLocation;
    }

    private static Double getHashCode(){
        return Datetime.now().getTime() + Math.random() * 1000000;
    }

    @testVisible
    private static dmpl__InventoryStock__c getRelatedBranchItemLocation(
        dmpl__InventoryLedger__c ledgerEntry, 
        List<dmpl__InventoryStock__c> loadedstockLocations){
        for(dmpl__InventoryStock__c stockLocation : loadedstockLocations){
            if(stockLocation.dmpl__BranchId__c == ledgerEntry.RelatedBranchId__c 
                && stockLocation.dmpl__StorageLocationId__c == null
                && stockLocation.dmpl__ItemId__c == ledgerEntry.dmpl__ItemId__c 
                && stockLocation.dmpl__SKUId__c == ledgerEntry.dmpl__SKUId__c){
                    return stockLocation;
            }
        }

        dmpl__InventoryStock__c stockLocation = new dmpl__InventoryStock__c();
        if(ledgerEntry.dmpl__RelatedPartnerAccountId__c != null){
            stockLocation.dmpl__PartnerAccountId__c = ledgerEntry.dmpl__RelatedPartnerAccountId__c;
        }else {
            stockLocation.dmpl__PartnerAccountId__c = ledgerEntry.dmpl__PartnerAccountId__c;
        }
        stockLocation.dmpl__BranchId__c = ledgerEntry.RelatedBranchId__c;
        stockLocation.dmpl__ItemId__c = ledgerEntry.dmpl__ItemId__c;
        stockLocation.dmpl__SKUId__c = ledgerEntry.dmpl__SKUId__c;
        loadedstockLocations.Add(stockLocation);
        return stockLocation;
    }
    
  @TestVisible  private static dmpl__InventoryStock__c getCurrentBranchNullStorageItemLocation(dmpl__InventoryLedger__c ledgerEntry, List<dmpl__InventoryStock__c> loadedstockLocations)
    {
        for(dmpl__InventoryStock__c stockLocation : loadedstockLocations)
            if(stockLocation.dmpl__BranchId__c == ledgerEntry.dmpl__BranchId__c && stockLocation.dmpl__StorageLocationId__c == null
                && stockLocation.dmpl__ItemId__c == ledgerEntry.dmpl__ItemId__c && stockLocation.dmpl__SKUId__c == ledgerEntry.dmpl__SKUId__c)
                return stockLocation;
        
        dmpl__InventoryStock__c stockLocation = new dmpl__InventoryStock__c();
        stockLocation.dmpl__BranchId__c = ledgerEntry.dmpl__BranchId__c;
        stockLocation.dmpl__PartnerAccountId__c = ledgerEntry.dmpl__PartnerAccountId__c;
        stockLocation.dmpl__ItemId__c = ledgerEntry.dmpl__ItemId__c;
        stockLocation.dmpl__SKUId__c = ledgerEntry.dmpl__SKUId__c;
        stockLocation.dmpl__StorageLocationId__c = null;
        stockLocation.dmpl__HashCode__c = getHashCode();
        loadedstockLocations.Add(stockLocation);
        return stockLocation;
    }

    private static List<dmpl__InventoryStock__c> getLedgerRelatedLocations(
        List<dmpl__InventoryLedger__c> newLedgerEntries, 
        List<dmpl__InventoryLedger__c> oldLedgerEntries){
        string condition = '(dmpl__BranchId__c = {0} AND (dmpl__StorageLocationId__c = {1} OR dmpl__StorageLocationId__c = null) AND dmpl__ItemId__c = {2} AND dmpl__SKUId__c = {3} AND dmpl__PartnerAccountId__c = {4})';
        string relatedCondition = '((dmpl__BranchId__c = {0} OR dmpl__BranchId__c = {1}) AND dmpl__StorageLocationId__c = {2}  AND dmpl__ItemId__c = {3} AND dmpl__SKUId__c = {4} AND (dmpl__PartnerAccountId__c = {5} OR dmpl__PartnerAccountId__c = {6}))';
        List<String> conditions = new List<string>();
        //
        if(newLedgerEntries!=null){
            for(dmpl__InventoryLedger__c ledgerEntry : newLedgerEntries){
                string aCondtion = string.Format(
                    condition, 
                    new string[]{
                        ledgerEntry.dmpl__BranchId__c == null ? 
                            null : '\'' + ledgerEntry.dmpl__BranchId__c +'\'', 
                        ledgerEntry.dmpl__StorageLocationId__c == null ? 
                            null : '\'' + ledgerEntry.dmpl__StorageLocationId__c + '\'', 
                        '\'' + ledgerEntry.dmpl__ItemId__c + '\'', 
                        ledgerEntry.dmpl__SKUId__c == null ? 
                            null : '\'' + ledgerEntry.dmpl__SKUId__c + '\'',
                        ledgerEntry.dmpl__PartnerAccountId__c == null ? 
                            null : '\'' + ledgerEntry.dmpl__PartnerAccountId__c + '\''
                    });
                if(!conditions.Contains(aCondtion)){
                    conditions.Add(aCondtion);
                }
                if(ledgerEntry.RelatedBranchId__c !=null){
                    string bCondtion = string.Format(
                        relatedCondition, 
                        new string[]{
                            ledgerEntry.dmpl__BranchId__c== null ? 
                                null : '\'' + ledgerEntry.dmpl__BranchId__c + '\'', 
                            '\'' + ledgerEntry.RelatedBranchId__c + '\'',
                            null, 
                            '\'' + ledgerEntry.dmpl__ItemId__c + '\'', 
                            ledgerEntry.dmpl__SKUId__c == null ? 
                                null : '\'' + ledgerEntry.dmpl__SKUId__c + '\'',
                            ledgerEntry.dmpl__PartnerAccountId__c == null ? 
                                null : '\'' + ledgerEntry.dmpl__PartnerAccountId__c + '\'',
                            ledgerEntry.dmpl__RelatedPartnerAccountId__c == null ? 
                            null : '\'' + ledgerEntry.dmpl__RelatedPartnerAccountId__c + '\''
                    });
                    if(!conditions.Contains(bCondtion)){
                        conditions.Add(bCondtion);
                    }
                }
            }
        }
        //        
        if(oldLedgerEntries!=null){
            for(dmpl__InventoryLedger__c ledgerEntry : oldLedgerEntries){
                string aCondtion = string.Format(
                    condition, 
                    new string[]{
                        ledgerEntry.dmpl__BranchId__c== null ? 
                            null :'\''+ledgerEntry.dmpl__BranchId__c+'\'', 
                        ledgerEntry.dmpl__StorageLocationId__c == null ? 
                            null : '\''+ledgerEntry.dmpl__StorageLocationId__c+'\'', 
                        '\''+ledgerEntry.dmpl__ItemId__c +'\'', 
                        ledgerEntry.dmpl__SKUId__c == null ? 
                            null : '\''+ledgerEntry.dmpl__SKUId__c+'\'',
                        ledgerEntry.dmpl__PartnerAccountId__c == null ? 
                            null : '\''+ledgerEntry.dmpl__PartnerAccountId__c+'\''
                    });
                if(!conditions.Contains(aCondtion)){
                    conditions.Add(aCondtion);
                }
                if(ledgerEntry.RelatedBranchId__c !=null){
                    string bCondtion = string.Format(
                        relatedCondition, new string[]{
                            ledgerEntry.dmpl__BranchId__c== null ? 
                                null :'\''+ledgerEntry.dmpl__BranchId__c +'\'', 
                            '\''+ledgerEntry.RelatedBranchId__c+'\'', 
                            null, 
                            '\''+ledgerEntry.dmpl__ItemId__c +'\'', 
                            ledgerEntry.dmpl__SKUId__c == null ? 
                                null : '\''+ledgerEntry.dmpl__SKUId__c+'\'',
                            ledgerEntry.dmpl__PartnerAccountId__c == null ? 
                                null : '\''+ledgerEntry.dmpl__PartnerAccountId__c+'\'',
                            ledgerEntry.dmpl__RelatedPartnerAccountId__c == null ? 
                                null : '\''+ledgerEntry.dmpl__RelatedPartnerAccountId__c+'\''
                        });
                    if(!conditions.Contains(bCondtion)){
                        conditions.Add(bCondtion);
                    }
                }
            }
        }
        //
        string dynamicSOQL =  String.Join(conditions, ' OR ');
        dynamicSOQL = 'SELECT id, dmpl__BranchId__c,dmpl__PartnerAccountId__c, dmpl__StorageLocationId__c, dmpl__ItemId__c, dmpl__SKUId__c, dmpl__QuantityAdjustedIn__c, dmpl__QuantityAdjustedOut__c, dmpl__QuantityAssembledIn__c, QuantityAssembledOut__c, dmpl__QuantityInTransit__c, dmpl__QuantityOnFulfillment__c, dmpl__QuantityPicked__c, dmpl__QuantityOnAllocation__c, dmpl__QuantityPurchased__c, dmpl__QuantitySold__c, dmpl__QuantityTransferIn__c, dmpl__QuantityTransferOut__c, dmpl__QuantityOnInward__c, dmpl__QuantityOnOutward__c, dmpl__QuantityInHand__c, QuantityOnLoan__c, dmpl__QuantityOnHold__c, dmpl__QuantityExpired__c, dmpl__QuantityDamaged__c,dmpl__QuantityShortage__c, dmpl__QuantityExcess__c, dmpl__QuantityOnInspection__c, dmpl__QuantitySaleReturned__c, dmpl__QuantityPurchaseReturned__c, dmpl__QuantityInPendingDeliveries__c, dmpl__QuantityInPipeline__c, dmpl__QuantitySoftCommitted__c  FROM dmpl__InventoryStock__c WHERE ' + dynamicSOQL + ' For Update'; 
        return Database.query(dynamicSOQL);
    }

    public static void setStock(List<SObject> newEntries){
        List<dmpl__InventoryStock__c> stocks = [SELECT 
                Id,
                dmpl__ItemId__c,
                dmpl__SKUId__c,
                dmpl__ItemLotTypeId__c
            FROM 
                dmpl__InventoryStock__c 
            WHERE 
                dmpl__ItemId__c IN : CollectionHelper.extractIds(newEntries, 'dmpl__ItemId__c')
                AND dmpl__PartnerAccountId__c IN : CollectionHelper.extractIds(newEntries, 'dmpl__PartnerAccountId__c')
                AND dmpl__BranchId__c IN : CollectionHelper.extractIds(newEntries, 'dmpl__BranchId__c')
                ];
        for(SObject entry :  newEntries){
            for(dmpl__InventoryStock__c stock : stocks){
                if(stock.dmpl__ItemId__c == entry.get('dmpl__ItemId__c')
                    && stock.dmpl__SKUId__c == entry.get('dmpl__SKUId__c')
                    && stock.dmpl__ItemLotTypeId__c == entry.get('dmpl__ItemLotTypeId__c')){
                        entry.put('dmpl__InventoryStockId__c' , stock.Id);
                        break;
                    }
            }
        }
    }

    @testVisible
    private static void throwDmplException(String message){
        throw new DMPLException(message);
    }
}