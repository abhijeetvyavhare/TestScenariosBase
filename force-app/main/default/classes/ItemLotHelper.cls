public without sharing class ItemLotHelper {

    public static Boolean skipValidations = true;
    public static Boolean skipLockCheck = false;
    
    public static void validateData(
        Boolean isInsert, 
        Boolean isDelete, 
        Boolean isUpdate, 
        List<dmpl__ItemLot__c> oldEntries, 
        List<dmpl__ItemLot__c> newEntries)
    {
        if(isInsert){
            FieldMappingHelper.copyFieldMappingData(
                newEntries);
            checkForLockedTransactions(newEntries);
            setHashCodes(newEntries);
        }else if(isUpdate){
            checkForLockedTransactions(newEntries);
        }else if(isDelete){
            checkForLockedTransactions(oldEntries);
        }
    }

    public static void postInventoryLedgerRecords(
        Boolean isInsert, 
        Boolean isDelete, 
        Boolean isUpdate, 
        List<dmpl__InventoryLedger__c> oldEntries, 
        List<dmpl__InventoryLedger__c> newEntries)
    {
        Map<Id, dmpl__ItemLot__c> itemLots = getLedgerRelatedLots(newEntries, oldEntries);
        Map<Id, dmpl__Item__c> items = getRelatedItemRecords(newEntries, oldEntries);
        Map<Id, dmpl__ItemLot__c> updatedItemLots = new Map<Id, dmpl__ItemLot__c>();
        if(isDelete || isUpdate )
        {
            for(dmpl__InventoryLedger__c ledgerEntry : oldEntries)
            {
                if(isUpdate && !areKeyFieldsModified(newEntries, ledgerEntry))
                    continue;
                //
                dmpl__Item__c item = items.Get(ledgerEntry.dmpl__ItemId__c);
                if(item == null)
                    throwDmplException(System.Label.IntegrityFailed_MssingProduct);
                else if(!item.dmpl__TrackInventory__c || !item.dmpl__TrackLots__c)
                    continue;
                else if(ledgerEntry.dmpl__ItemLotId__c == null)
                    throwDmplException(System.Label.IntegrityFailed_MssingProductLot);
                else
                {
                    dmpl__ItemLot__c itemLot = itemLots.get(ledgerEntry.dmpl__ItemLotId__c);
                    dmpl__ItemLot__c relatedItemLot = ledgerEntry.dmpl__RelatedItemLotId__c != null ? itemLots.get(ledgerEntry.dmpl__RelatedItemLotId__c) : null;
                    if(itemLot == null){
                        throwDmplException(System.Label.IntegrityFailed_MssingProductLot);
                    }else if(isLotLocationInValid(itemLot, ledgerEntry)){
                        throwDmplException(System.Label.IntegrityFailed_InvalidProductLot);
                    }else if(unDoLotLedgerEntry(ledgerEntry, itemLot, relatedItemLot)){
                        if(!updatedItemLots.ContainsKey(itemLot.Id))
                            updatedItemLots.Put(itemLot.Id, itemLot);
                        if(relatedItemLot!=null && !updatedItemLots.ContainsKey(relatedItemLot.Id))
                            updatedItemLots.Put(relatedItemLot.Id, relatedItemLot);
                    }
                }
            }
        }

        if(isInsert || isUpdate )
        {
            for(dmpl__InventoryLedger__c ledgerEntry : newEntries)
            {
                if(isUpdate && !areKeyFieldsModified(oldEntries, ledgerEntry))
                    continue;
                //
                dmpl__Item__c item = items.get(ledgerEntry.dmpl__ItemId__c);
                if(item == null)
                    throwDmplException(System.Label.IntegrityFailed_MssingProduct);
                else if(!item.dmpl__TrackInventory__c || !item.dmpl__TrackLots__c)
                    continue;
                else if(ledgerEntry.dmpl__ItemLotId__c == null)
                    throwDmplException(System.Label.IntegrityFailed_MssingProductLot);
                else
                {
                    dmpl__ItemLot__c itemLot = itemLots.get(ledgerEntry.dmpl__ItemLotId__c);
                    dmpl__ItemLot__c relatedItemLot = ledgerEntry.dmpl__RelatedItemLotId__c!=null ? itemLots.get(ledgerEntry.dmpl__RelatedItemLotId__c) : null;
                    if(itemLot == null){
                        throwDmplException(System.Label.IntegrityFailed_MssingProductLot);
                    }else if(isLotLocationInValid(itemLot, ledgerEntry)){
                        throwDmplException(System.Label.IntegrityFailed_InvalidProductLot);
                    }else if(doLotLedgerEntry(ledgerEntry, itemLot, relatedItemLot)){
                        itemLot.RecalculateFormulas();
                        if(!updatedItemLots.ContainsKey(itemLot.Id))
                            updatedItemLots.Put(itemLot.Id, itemLot);
                        if(relatedItemLot!=null)
                        { 
                            relatedItemLot.RecalculateFormulas();
                            if(!updatedItemLots.ContainsKey(relatedItemLot.Id))
                                updatedItemLots.Put(relatedItemLot.Id, relatedItemLot);
                        }
                    }
                }
            }
        }
        
        try {
            skipValidations = true;
            update updatedItemLots.Values();
        } finally {
            skipValidations = false;
        }
        
    } 

    private static Boolean areKeyFieldsModified(
        List<dmpl__InventoryLedger__c> oldEntries, 
        dmpl__InventoryLedger__c newEntry)
    {
        dmpl__InventoryLedger__c oldEntry = GetOldEntry(oldEntries, newEntry);
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
            ||oldEntry.dmpl__DeliveredQuantity__c != newEntry.dmpl__DeliveredQuantity__c
            ||oldEntry.dmpl__RelatedItemLotId__c != newEntry.dmpl__RelatedItemLotId__c
            ||oldEntry.dmpl__RelatedPartnerAccountId__c != newEntry.dmpl__RelatedPartnerAccountId__c);
    }
    
    private static Boolean isLotLocationInValid(
        dmpl__ItemLot__c itemLot, 
        dmpl__InventoryLedger__c ledgerEntry){
        return itemLot.dmpl__PartnerAccountId__c != ledgerEntry.dmpl__PartnerAccountId__c
            || itemLot.dmpl__BranchId__c != ledgerEntry.dmpl__BranchId__c
            || itemLot.dmpl__ItemId__c != ledgerEntry.dmpl__ItemId__c
            || itemLot.dmpl__StorageLocationId__c != ledgerEntry.dmpl__StorageLocationId__c;
    }

    private static dmpl__InventoryLedger__c getOldEntry(
        List<dmpl__InventoryLedger__c> oldEntries, 
        dmpl__InventoryLedger__c newEntry)
    {
        for(dmpl__InventoryLedger__c oldEntry : oldEntries)
            if(oldEntry.Id == newEntry.Id)
                return oldEntry;
        //
        return null;
    }

    private static Boolean doLotLedgerEntry(
        dmpl__InventoryLedger__c ledgerEntry, 
        dmpl__ItemLot__c lotEntry, 
        dmpl__ItemLot__c  relatedLotEntry)
    {
        InventoryLedgerTypeEnums ledgerType = InventoryLedgerHelper.getLedgerType(ledgerEntry.dmpl__InventoryLedgerType__c);

        if(ledgerType == InventoryLedgerTypeEnums.Adjustment || ledgerType == InventoryLedgerTypeEnums.InspectionAdjustment)
            return doAdjustmentLedgerEntry(ledgerEntry, lotEntry);
        else if(ledgerType == InventoryLedgerTypeEnums.TransferOutward)
            return doTransferOutwardLedgerEntry(ledgerEntry, lotEntry, relatedLotEntry);
        else if(ledgerType == InventoryLedgerTypeEnums.TransferInward)
            return doTransferInwardLedgerEntry(ledgerEntry, lotEntry, relatedLotEntry);
        else if(ledgerType == InventoryLedgerTypeEnums.Inward)
            return doInwardLedgerEntry(ledgerEntry, lotEntry);
        else if(ledgerType == InventoryLedgerTypeEnums.Outward)
            return doOutwardLedgerEntry(ledgerEntry, lotEntry);
        else if(ledgerType == InventoryLedgerTypeEnums.Assemble)
            return doAssembleLedgerEntry(ledgerEntry, lotEntry);
        else if(ledgerType == InventoryLedgerTypeEnums.Fulfillment)
            return doFulfillmentLedgerEntry(ledgerEntry, lotEntry);
        else if(ledgerType == InventoryLedgerTypeEnums.Allocation)
            return doAllocationLedgerEntry(ledgerEntry, lotEntry);
        else if(ledgerType == InventoryLedgerTypeEnums.Picked)
            return doPickedLedgerEntry(ledgerEntry, lotEntry);
        else if(ledgerType == InventoryLedgerTypeEnums.Purchased)
            return doPurchasedLedgerEntry(ledgerEntry, lotEntry);
        else if(ledgerType == InventoryLedgerTypeEnums.Sold)
            return doSoldLedgerEntry(ledgerEntry, lotEntry);
        else if(ledgerType == InventoryLedgerTypeEnums.Damaged)
            return doDamagedLedgerEntry(ledgerEntry, lotEntry);
        else if(ledgerType == InventoryLedgerTypeEnums.Shortage)
            return doShortageLedgerEntry(ledgerEntry, lotEntry);
        else if(ledgerType == InventoryLedgerTypeEnums.Excess)
            return doExcessLedgerEntry(ledgerEntry, lotEntry);
        else if(ledgerType == InventoryLedgerTypeEnums.Expired)
            return doExpiredLedgerEntry(ledgerEntry, lotEntry);
        else if(ledgerType == InventoryLedgerTypeEnums.OnHold)
            return doHoldLedgerEntry(ledgerEntry, lotEntry);
        else if(ledgerType == InventoryLedgerTypeEnums.OnLoan)
            return doLoanLedgerEntry(ledgerEntry, lotEntry);
        else if(ledgerType == InventoryLedgerTypeEnums.Inspection)
            return doInspectionLedgerEntry(ledgerEntry, lotEntry);
        else if(ledgerType == InventoryLedgerTypeEnums.SaleReturn)
            return doSaleReturnLedgerEntry(ledgerEntry, lotEntry);
        else if(ledgerType == InventoryLedgerTypeEnums.PurchaseReturn)
            return doPurchaseReturnLedgerEntry(ledgerEntry, lotEntry);
        else if(ledgerType == InventoryLedgerTypeEnums.SoftCommit)
            return doPurchaseReturnLedgerEntry(ledgerEntry, lotEntry);
        else 
            throwDmplException(System.Label.ProductLot_InvalidLedgerType);
        
            return false;
    }

    private static Boolean unDoLotLedgerEntry(dmpl__InventoryLedger__c ledgerEntry, dmpl__ItemLot__c lotEntry, dmpl__ItemLot__c  relatedLotEntry)
    {
        InventoryLedgerTypeEnums ledgerType = InventoryLedgerHelper.getLedgerType(ledgerEntry.dmpl__InventoryLedgerType__c);

        if(ledgerType == InventoryLedgerTypeEnums.Adjustment || ledgerType == InventoryLedgerTypeEnums.InspectionAdjustment)
            return unDoAdjustmentLedgerEntry(ledgerEntry, lotEntry);
        else if(ledgerType == InventoryLedgerTypeEnums.TransferOutward)
            return unDoTransferOutwardLedgerEntry(ledgerEntry, lotEntry, relatedLotEntry);
        else if(ledgerType == InventoryLedgerTypeEnums.TransferInward)
            return unDoTransferInwardLedgerEntry(ledgerEntry, lotEntry, relatedLotEntry);
        else if(ledgerType == InventoryLedgerTypeEnums.Inward)
            return unDoInwardLedgerEntry(ledgerEntry, lotEntry);
        else if(ledgerType == InventoryLedgerTypeEnums.Outward)
            return unDoOutwardLedgerEntry(ledgerEntry, lotEntry);
        else if(ledgerType == InventoryLedgerTypeEnums.Assemble)
            return unDoAssembleLedgerEntry(ledgerEntry, lotEntry);
        else if(ledgerType == InventoryLedgerTypeEnums.Fulfillment)
            return unDoFulfillmentLedgerEntry(ledgerEntry, lotEntry);
        else if(ledgerType == InventoryLedgerTypeEnums.Allocation)
            return unDoAllocationLedgerEntry(ledgerEntry, lotEntry);
        else if(ledgerType == InventoryLedgerTypeEnums.Picked)
            return unDoPickedLedgerEntry(ledgerEntry, lotEntry);
        else if(ledgerType == InventoryLedgerTypeEnums.Purchased)
            return unDoPurchasedLedgerEntry(ledgerEntry, lotEntry);
        else if(ledgerType == InventoryLedgerTypeEnums.Sold)
            return unDoSoldLedgerEntry(ledgerEntry, lotEntry);
        else if(ledgerType == InventoryLedgerTypeEnums.Damaged)
            return unDoDamagedLedgerEntry(ledgerEntry, lotEntry);
        else if(ledgerType == InventoryLedgerTypeEnums.Shortage)
            return unDoShortageLedgerEntry(ledgerEntry, lotEntry);
        else if(ledgerType == InventoryLedgerTypeEnums.Excess)
            return unDoExcessLedgerEntry(ledgerEntry, lotEntry);
        else if(ledgerType == InventoryLedgerTypeEnums.Expired)
            return unDoExpiredLedgerEntry(ledgerEntry, lotEntry);
        else if(ledgerType == InventoryLedgerTypeEnums.OnHold)
            return unDoHoldLedgerEntry(ledgerEntry, lotEntry);
        else if(ledgerType == InventoryLedgerTypeEnums.OnLoan)
            return unDoLoanLedgerEntry(ledgerEntry, lotEntry);
        else if(ledgerType == InventoryLedgerTypeEnums.Inspection)
            return unDoInspectionLedgerEntry(ledgerEntry, lotEntry);
        else if(ledgerType == InventoryLedgerTypeEnums.SaleReturn)
            return unDoSaleReturnLedgerEntry(ledgerEntry, lotEntry);
        else if(ledgerType == InventoryLedgerTypeEnums.PurchaseReturn)
            return unDoPurchaseReturnLedgerEntry(ledgerEntry, lotEntry);
            else if(ledgerType == InventoryLedgerTypeEnums.SoftCommit)
                return doPurchaseReturnLedgerEntry(ledgerEntry, lotEntry);
        else 
            throwDmplException(System.Label.ProductLot_InvalidLedgerType);
        
            return false;
    }

    private static Boolean doTransferOutwardLedgerEntry(dmpl__InventoryLedger__c ledgerEntry, dmpl__ItemLot__c lotEntry, dmpl__ItemLot__c relatedLotEntry)
    {
        lotEntry.dmpl__QuantityTransferOut__c = (lotEntry.dmpl__QuantityTransferOut__c == null ? 0 : lotEntry.dmpl__QuantityTransferOut__c) + Math.Abs(ledgerEntry.dmpl__Quantity__c);
        lotEntry.dmpl__QuantityInPendingDeliveries__c = (lotEntry.dmpl__QuantityInPendingDeliveries__c == null ? 0 : lotEntry.dmpl__QuantityInPendingDeliveries__c) - (ledgerEntry.dmpl__PendingDeliveriesQuantity__c == null ? 0 : ledgerEntry.dmpl__PendingDeliveriesQuantity__c);
        if(relatedLotEntry ==null)
            throwDmplException(System.Label.IntegrityFailed_MssingProductLot);
        doTransitLedgerEntry(ledgerEntry, relatedLotEntry);
        return true;
    }
    
	@TestVisible
    private static Boolean unDoTransferOutwardLedgerEntry(dmpl__InventoryLedger__c ledgerEntry, dmpl__ItemLot__c lotEntry, dmpl__ItemLot__c relatedLotEntry)
    {
        lotEntry.dmpl__QuantityTransferOut__c = (lotEntry.dmpl__QuantityTransferOut__c == null ? 0 : lotEntry.dmpl__QuantityTransferOut__c) - Math.Abs(ledgerEntry.dmpl__Quantity__c);
        lotEntry.dmpl__QuantityInPendingDeliveries__c = (lotEntry.dmpl__QuantityInPendingDeliveries__c == null ? 0 : lotEntry.dmpl__QuantityInPendingDeliveries__c) + (ledgerEntry.dmpl__PendingDeliveriesQuantity__c == null ? 0 : ledgerEntry.dmpl__PendingDeliveriesQuantity__c);
        if(relatedLotEntry ==null)
            throwDmplException(System.Label.IntegrityFailed_MssingProductLot);
        unDoTransitLedgerEntry(ledgerEntry, relatedLotEntry);
        return true;
    }

    private static Boolean doTransferInwardLedgerEntry(dmpl__InventoryLedger__c ledgerEntry, dmpl__ItemLot__c lotEntry, dmpl__ItemLot__c relatedLotEntry)
    {
        lotEntry.dmpl__QuantityTransferIn__c = (lotEntry.dmpl__QuantityTransferIn__c == null ? 0 : lotEntry.dmpl__QuantityTransferIn__c) + ledgerEntry.dmpl__Quantity__c;
        lotEntry.dmpl__QuantityInPendingDeliveries__c = (lotEntry.dmpl__QuantityInPendingDeliveries__c == null ? 0 : lotEntry.dmpl__QuantityInPendingDeliveries__c) + (ledgerEntry.dmpl__PendingDeliveriesQuantity__c == null ? 0 : ledgerEntry.dmpl__PendingDeliveriesQuantity__c);
        unDoTransitLedgerEntry(ledgerEntry, lotEntry);        
        return true;
    }

    @TestVisible
    private static Boolean unDoTransferInwardLedgerEntry(dmpl__InventoryLedger__c ledgerEntry, dmpl__ItemLot__c lotEntry, dmpl__ItemLot__c relatedLotEntry)
    {
        lotEntry.dmpl__QuantityTransferIn__c = (lotEntry.dmpl__QuantityTransferIn__c == null ? 0 : lotEntry.dmpl__QuantityTransferIn__c) - ledgerEntry.dmpl__Quantity__c;
        lotEntry.dmpl__QuantityInPendingDeliveries__c = (lotEntry.dmpl__QuantityInPendingDeliveries__c == null ? 0 : lotEntry.dmpl__QuantityInPendingDeliveries__c) - (ledgerEntry.dmpl__PendingDeliveriesQuantity__c == null ? 0 : ledgerEntry.dmpl__PendingDeliveriesQuantity__c);
        DoTransitLedgerEntry(ledgerEntry, lotEntry);
        return true;
    }

    private static Boolean doAdjustmentLedgerEntry(dmpl__InventoryLedger__c ledgerEntry, dmpl__ItemLot__c lotEntry)
    {
        if(ledgerEntry.dmpl__Quantity__c > 0)
            lotEntry.dmpl__QuantityAdjustedIn__c = (lotEntry.dmpl__QuantityAdjustedIn__c == null ? 0 : lotEntry.dmpl__QuantityAdjustedIn__c) + ledgerEntry.dmpl__Quantity__c;
        else if(ledgerEntry.dmpl__Quantity__c < 0)
            lotEntry.dmpl__QuantityAdjustedOut__c = (lotEntry.dmpl__QuantityAdjustedOut__c == null ? 0 : lotEntry.dmpl__QuantityAdjustedOut__c) + Math.Abs(ledgerEntry.dmpl__Quantity__c);

        return true;
    }

    private static Boolean unDoAdjustmentLedgerEntry(dmpl__InventoryLedger__c ledgerEntry, dmpl__ItemLot__c lotEntry)
    {
        if(ledgerEntry.dmpl__Quantity__c > 0)
            lotEntry.dmpl__QuantityAdjustedIn__c = (lotEntry.dmpl__QuantityAdjustedIn__c == null ? 0 : lotEntry.dmpl__QuantityAdjustedIn__c) - ledgerEntry.dmpl__Quantity__c;
        else if(ledgerEntry.dmpl__Quantity__c < 0)
            lotEntry.dmpl__QuantityAdjustedOut__c = (lotEntry.dmpl__QuantityAdjustedOut__c == null ? 0 : lotEntry.dmpl__QuantityAdjustedOut__c) - Math.Abs(ledgerEntry.dmpl__Quantity__c);

        return true;
    }

    private static Boolean doInwardLedgerEntry(
        dmpl__InventoryLedger__c ledgerEntry, 
        dmpl__ItemLot__c lotEntry){
        if(ledgerEntry.dmpl__Quantity__c > 0)
        lotEntry.dmpl__QuantityOnInward__c = (lotEntry.dmpl__QuantityOnInward__c == null ? 
            0 : lotEntry.dmpl__QuantityOnInward__c) 
            + ledgerEntry.dmpl__Quantity__c;
        return true;
    }

    @testVisible
    private static Boolean unDoInwardLedgerEntry(
        dmpl__InventoryLedger__c ledgerEntry, 
        dmpl__ItemLot__c lotEntry){
        lotEntry.dmpl__QuantityOnInward__c = (lotEntry.dmpl__QuantityOnInward__c == null ? 
            0 : lotEntry.dmpl__QuantityOnInward__c) 
            - ledgerEntry.dmpl__Quantity__c;
        return true;
    }

    @testVisible
    private static Boolean doOutwardLedgerEntry(
        dmpl__InventoryLedger__c ledgerEntry, 
        dmpl__ItemLot__c lotEntry){
        lotEntry.dmpl__QuantityOnOutward__c = (lotEntry.dmpl__QuantityOnOutward__c == null ? 
            0 : lotEntry.dmpl__QuantityOnOutward__c) 
            + ledgerEntry.dmpl__Quantity__c;
        lotEntry.dmpl__QuantityOnAllocation__c = (lotEntry.dmpl__QuantityOnAllocation__c == null ? 
            0 : lotEntry.dmpl__QuantityOnAllocation__c) 
            - (ledgerEntry.dmpl__AllocatedQuantity__c == null ? 
            0 : ledgerEntry.dmpl__AllocatedQuantity__c);
        lotEntry.dmpl__QuantityPicked__c = (lotEntry.dmpl__QuantityPicked__c == null ? 
            0 : lotEntry.dmpl__QuantityPicked__c) 
            - (ledgerEntry.dmpl__PickedQuantity__c == null ? 
            0 : ledgerEntry.dmpl__PickedQuantity__c);
        lotEntry.dmpl__QuantityInPendingDeliveries__c = (lotEntry.dmpl__QuantityInPendingDeliveries__c == null ? 
            0 : lotEntry.dmpl__QuantityInPendingDeliveries__c) 
            - (ledgerEntry.dmpl__PendingDeliveriesQuantity__c == null ? 
            0 : ledgerEntry.dmpl__PendingDeliveriesQuantity__c);
        return true;
    }

    @testVisible
    private static Boolean unDoOutwardLedgerEntry(
        dmpl__InventoryLedger__c ledgerEntry, 
        dmpl__ItemLot__c lotEntry){
        lotEntry.dmpl__QuantityOnOutward__c = (lotEntry.dmpl__QuantityOnOutward__c == null ? 
            0 : lotEntry.dmpl__QuantityOnOutward__c) 
            - ledgerEntry.dmpl__Quantity__c;
        lotEntry.dmpl__QuantityOnAllocation__c = (lotEntry.dmpl__QuantityOnAllocation__c == null ? 
            0 : lotEntry.dmpl__QuantityOnAllocation__c) 
            + (ledgerEntry.dmpl__AllocatedQuantity__c == null ? 
            0 : ledgerEntry.dmpl__AllocatedQuantity__c);
        lotEntry.dmpl__QuantityPicked__c = (lotEntry.dmpl__QuantityPicked__c == null ? 
            0 : lotEntry.dmpl__QuantityPicked__c) 
            + (ledgerEntry.dmpl__PickedQuantity__c == null ? 
            0 : ledgerEntry.dmpl__PickedQuantity__c);
        lotEntry.dmpl__QuantityInPendingDeliveries__c = (lotEntry.dmpl__QuantityInPendingDeliveries__c == null ? 
            0 : lotEntry.dmpl__QuantityInPendingDeliveries__c) 
            + (ledgerEntry.dmpl__PendingDeliveriesQuantity__c == null ? 
            0 : ledgerEntry.dmpl__PendingDeliveriesQuantity__c);
        return true;
    }

    @TestVisible
    private static Boolean DoAssembleLedgerEntry(dmpl__InventoryLedger__c ledgerEntry, dmpl__ItemLot__c lotEntry)
    {
        if(ledgerEntry.dmpl__Quantity__c > 0)
            lotEntry.dmpl__QuantityAssembledIn__c = (lotEntry.dmpl__QuantityAssembledIn__c == null ? 0 : lotEntry.dmpl__QuantityAssembledIn__c) + ledgerEntry.dmpl__Quantity__c;
        else if(ledgerEntry.dmpl__Quantity__c < 0)
            lotEntry.dmpl__QuantityAssembledOut__c = (lotEntry.dmpl__QuantityAssembledOut__c == null ? 0 : lotEntry.dmpl__QuantityAssembledOut__c) + Math.Abs(ledgerEntry.dmpl__Quantity__c);

        return true;
    }

    @TestVisible
    private static Boolean unDoAssembleLedgerEntry(dmpl__InventoryLedger__c ledgerEntry, dmpl__ItemLot__c lotEntry)
    {
        if(ledgerEntry.dmpl__Quantity__c > 0)
            lotEntry.dmpl__QuantityAssembledIn__c = (lotEntry.dmpl__QuantityAssembledIn__c == null ? 0 : lotEntry.dmpl__QuantityAssembledIn__c) - ledgerEntry.dmpl__Quantity__c;
        else if(ledgerEntry.dmpl__Quantity__c < 0)
            lotEntry.dmpl__QuantityAssembledOut__c = (lotEntry.dmpl__QuantityAssembledOut__c == null ? 0 : lotEntry.dmpl__QuantityAssembledOut__c) - Math.Abs(ledgerEntry.dmpl__Quantity__c);

        return true;
    }


    private static Boolean DoTransitLedgerEntry(dmpl__InventoryLedger__c ledgerEntry, dmpl__ItemLot__c lotEntry)
    {
        lotEntry.dmpl__QuantityInTransit__c = (lotEntry.dmpl__QuantityInTransit__c == null ? 0 : lotEntry.dmpl__QuantityInTransit__c) + (ledgerEntry.dmpl__Quantity__c == null ? 0 :  Math.Abs(ledgerEntry.dmpl__Quantity__c));
        return true;
    }

    private static Boolean unDoTransitLedgerEntry(dmpl__InventoryLedger__c ledgerEntry, dmpl__ItemLot__c lotEntry)
    {
        lotEntry.dmpl__QuantityInTransit__c = (lotEntry.dmpl__QuantityInTransit__c == null ? 0 : lotEntry.dmpl__QuantityInTransit__c) - Math.Abs(ledgerEntry.dmpl__Quantity__c);
        return true;
    }
 
    @TestVisible
    private static Boolean DoFulfillmentLedgerEntry(dmpl__InventoryLedger__c ledgerEntry, dmpl__ItemLot__c lotEntry)
    {
        lotEntry.dmpl__QuantityOnFulfillment__c = (lotEntry.dmpl__QuantityOnFulfillment__c == null ? 0 : lotEntry.dmpl__QuantityOnFulfillment__c) + ledgerEntry.dmpl__Quantity__c;
        return true;
    }

    @TestVisible
    private static Boolean unDoFulfillmentLedgerEntry(dmpl__InventoryLedger__c ledgerEntry, dmpl__ItemLot__c lotEntry)
    {
        lotEntry.dmpl__QuantityOnFulfillment__c = (lotEntry.dmpl__QuantityOnFulfillment__c == null ? 0 : lotEntry.dmpl__QuantityOnFulfillment__c) - ledgerEntry.dmpl__Quantity__c;
        return true;
    }
    
    private static Boolean doAllocationLedgerEntry(dmpl__InventoryLedger__c ledgerEntry, dmpl__ItemLot__c lotEntry)
    {
        lotEntry.dmpl__QuantityOnAllocation__c = (lotEntry.dmpl__QuantityOnAllocation__c == null ? 0 : lotEntry.dmpl__QuantityOnAllocation__c) + ledgerEntry.dmpl__Quantity__c;
        return true;
    }

    private static Boolean unDoAllocationLedgerEntry(dmpl__InventoryLedger__c ledgerEntry, dmpl__ItemLot__c lotEntry)
    {
        lotEntry.dmpl__QuantityOnAllocation__c = (lotEntry.dmpl__QuantityOnAllocation__c == null ? 0 : lotEntry.dmpl__QuantityOnAllocation__c) - ledgerEntry.dmpl__Quantity__c;
        return true;
    }
    
    private static Boolean doPickedLedgerEntry(dmpl__InventoryLedger__c ledgerEntry, dmpl__ItemLot__c lotEntry)
    {
        lotEntry.dmpl__QuantityPicked__c = (lotEntry.dmpl__QuantityPicked__c == null ? 0 : lotEntry.dmpl__QuantityPicked__c) + ledgerEntry.dmpl__Quantity__c;
        lotEntry.dmpl__QuantityOnAllocation__c = (lotEntry.dmpl__QuantityOnAllocation__c == null ? 0 : lotEntry.dmpl__QuantityOnAllocation__c) - ledgerEntry.dmpl__Quantity__c;
        return true;
    }

    @testVisible
    private static Boolean unDoPickedLedgerEntry(dmpl__InventoryLedger__c ledgerEntry, dmpl__ItemLot__c lotEntry)
    {
        lotEntry.dmpl__QuantityPicked__c = (lotEntry.dmpl__QuantityPicked__c == null ? 0 : lotEntry.dmpl__QuantityPicked__c) - ledgerEntry.dmpl__Quantity__c;
        lotEntry.dmpl__QuantityOnAllocation__c = (lotEntry.dmpl__QuantityOnAllocation__c == null ? 0 : lotEntry.dmpl__QuantityOnAllocation__c) + ledgerEntry.dmpl__Quantity__c;
        return true;
    }
    
    private static Boolean doPurchasedLedgerEntry(
        dmpl__InventoryLedger__c ledgerEntry, 
        dmpl__ItemLot__c lotEntry){
        lotEntry.dmpl__QuantityPurchased__c = (lotEntry.dmpl__QuantityPurchased__c == null ? 
            0 : lotEntry.dmpl__QuantityPurchased__c) 
            + ledgerEntry.dmpl__Quantity__c;
        lotEntry.dmpl__QuantityOnInward__c = (lotEntry.dmpl__QuantityOnInward__c == null ? 
            0 : lotEntry.dmpl__QuantityOnInward__c) 
            +  (ledgerEntry.dmpl__InwardQuantity__c == null ? 
                0 : ledgerEntry.dmpl__InwardQuantity__c);

        return true;
    }

    private static Boolean unDoPurchasedLedgerEntry(
        dmpl__InventoryLedger__c ledgerEntry, 
        dmpl__ItemLot__c lotEntry){
        lotEntry.dmpl__QuantityPurchased__c = (lotEntry.dmpl__QuantityPurchased__c == null ? 
            0 : lotEntry.dmpl__QuantityPurchased__c) 
            - ledgerEntry.dmpl__Quantity__c;
        lotEntry.dmpl__QuantityOnInward__c = (lotEntry.dmpl__QuantityOnInward__c == null ? 
            0 : lotEntry.dmpl__QuantityOnInward__c) 
            - (ledgerEntry.dmpl__InwardQuantity__c == null ? 
                0 : ledgerEntry.dmpl__InwardQuantity__c);
        return true;
    }
    
    @testVisible
    private static Boolean doPurchaseReturnLedgerEntry(dmpl__InventoryLedger__c ledgerEntry, dmpl__ItemLot__c lotEntry)
    {
        lotEntry.QuantityPurchaseReturned__c = (lotEntry.QuantityPurchaseReturned__c == null ? 0 : lotEntry.QuantityPurchaseReturned__c) + ledgerEntry.dmpl__Quantity__c;
        lotEntry.dmpl__QuantityOnInward__c = (lotEntry.dmpl__QuantityOnInward__c == null ? 0 : lotEntry.dmpl__QuantityOnInward__c) + (ledgerEntry.dmpl__InwardQuantity__c == null ? 0 : ledgerEntry.dmpl__InwardQuantity__c);
        return true;
    }

    @testVisible
    private static Boolean unDoPurchaseReturnLedgerEntry(dmpl__InventoryLedger__c ledgerEntry, dmpl__ItemLot__c lotEntry)
    {
        lotEntry.QuantityPurchaseReturned__c = (lotEntry.QuantityPurchaseReturned__c == null ? 0 : lotEntry.QuantityPurchaseReturned__c) - ledgerEntry.dmpl__Quantity__c;
        lotEntry.dmpl__QuantityOnInward__c = (lotEntry.dmpl__QuantityOnInward__c == null ? 0 : lotEntry.dmpl__QuantityOnInward__c) - (ledgerEntry.dmpl__InwardQuantity__c == null ? 0 : ledgerEntry.dmpl__InwardQuantity__c);
        return true;
    }

    private static Boolean doSoldLedgerEntry(dmpl__InventoryLedger__c ledgerEntry, dmpl__ItemLot__c lotEntry)
    {
        lotEntry.dmpl__QuantitySold__c = (lotEntry.dmpl__QuantitySold__c == null ? 
            0 : lotEntry.dmpl__QuantitySold__c) 
            + ledgerEntry.dmpl__Quantity__c;
        lotEntry.dmpl__QuantityOnAllocation__c = (lotEntry.dmpl__QuantityOnAllocation__c == null ? 
            0 : lotEntry.dmpl__QuantityOnAllocation__c) 
            - (ledgerEntry.dmpl__AllocatedQuantity__c == null ? 
            0 : ledgerEntry.dmpl__AllocatedQuantity__c);
        lotEntry.dmpl__QuantityPicked__c = (lotEntry.dmpl__QuantityPicked__c == null ? 
            0 : lotEntry.dmpl__QuantityPicked__c) 
            - (ledgerEntry.dmpl__PickedQuantity__c == null ? 
            0 : ledgerEntry.dmpl__PickedQuantity__c);
        lotEntry.dmpl__QuantityOnOutward__c = (lotEntry.dmpl__QuantityOnOutward__c == null ? 
            0 : lotEntry.dmpl__QuantityOnOutward__c) 
            - (ledgerEntry.dmpl__DeliveredQuantity__c == null ? 
            0 : ledgerEntry.dmpl__DeliveredQuantity__c);
        lotEntry.dmpl__QuantityInPendingDeliveries__c = (lotEntry.dmpl__QuantityInPendingDeliveries__c == null ? 
            0 : lotEntry.dmpl__QuantityInPendingDeliveries__c) 
            + (ledgerEntry.dmpl__PendingDeliveriesQuantity__c == null ? 
            0 : ledgerEntry.dmpl__PendingDeliveriesQuantity__c);
        return true;
    }

    private static Boolean unDoSoldLedgerEntry(dmpl__InventoryLedger__c ledgerEntry, dmpl__ItemLot__c lotEntry)
    {
        lotEntry.dmpl__QuantitySold__c = (lotEntry.dmpl__QuantitySold__c == null ? 
            0 : lotEntry.dmpl__QuantitySold__c) 
            - ledgerEntry.dmpl__Quantity__c;
        lotEntry.dmpl__QuantityOnAllocation__c = (lotEntry.dmpl__QuantityOnAllocation__c == null ? 
            0 : lotEntry.dmpl__QuantityOnAllocation__c) 
            + (ledgerEntry.dmpl__AllocatedQuantity__c == null ? 
            0 : ledgerEntry.dmpl__AllocatedQuantity__c);
        lotEntry.dmpl__QuantityPicked__c = (lotEntry.dmpl__QuantityPicked__c == null ? 
            0 : lotEntry.dmpl__QuantityPicked__c) 
            + (ledgerEntry.dmpl__PickedQuantity__c == null ? 
            0 : ledgerEntry.dmpl__PickedQuantity__c);
        lotEntry.dmpl__QuantityOnOutward__c = (lotEntry.dmpl__QuantityOnOutward__c == null ? 
            0 : lotEntry.dmpl__QuantityOnOutward__c) 
            + (ledgerEntry.dmpl__DeliveredQuantity__c == null ? 
            0 : ledgerEntry.dmpl__DeliveredQuantity__c);
        lotEntry.dmpl__QuantityInPendingDeliveries__c = (lotEntry.dmpl__QuantityInPendingDeliveries__c == null ? 
            0 : lotEntry.dmpl__QuantityInPendingDeliveries__c) 
            - (ledgerEntry.dmpl__PendingDeliveriesQuantity__c == null ? 
            0 : ledgerEntry.dmpl__PendingDeliveriesQuantity__c);
        return true;
    }

    @testVisible
    private static Boolean doSaleReturnLedgerEntry(dmpl__InventoryLedger__c ledgerEntry, dmpl__ItemLot__c lotEntry)
    {
        if(ledgerEntry.dmpl__AllocatedQuantity__c > 0){
            lotEntry.dmpl__QuantityOnAllocation__c = (lotEntry.dmpl__QuantityOnAllocation__c == null ? 0 : lotEntry.dmpl__QuantityOnAllocation__c) + (ledgerEntry.dmpl__AllocatedQuantity__c == null ? 0 : ledgerEntry.dmpl__AllocatedQuantity__c);
            lotEntry.dmpl__QuantityOnOutward__c = (lotEntry.dmpl__QuantityOnOutward__c == null ? 0 : lotEntry.dmpl__QuantityOnOutward__c) - (ledgerEntry.dmpl__AllocatedQuantity__c == null ? 0 : ledgerEntry.dmpl__AllocatedQuantity__c);
        }else{
            lotEntry.QuantitySaleReturned__c = (lotEntry.QuantitySaleReturned__c == null ? 0 : lotEntry.QuantitySaleReturned__c) + ledgerEntry.dmpl__Quantity__c;
        }

        return true;
    }

    @testVisible
    private static Boolean unDoSaleReturnLedgerEntry(dmpl__InventoryLedger__c ledgerEntry, dmpl__ItemLot__c lotEntry)
    {
        if(ledgerEntry.dmpl__AllocatedQuantity__c > 0){
            lotEntry.dmpl__QuantityOnAllocation__c = (lotEntry.dmpl__QuantityOnAllocation__c == null ? 0 : lotEntry.dmpl__QuantityOnAllocation__c) - (ledgerEntry.dmpl__AllocatedQuantity__c == null ? 0 : ledgerEntry.dmpl__AllocatedQuantity__c);
            lotEntry.dmpl__QuantityOnOutward__c = (lotEntry.dmpl__QuantityOnOutward__c == null ? 0 : lotEntry.dmpl__QuantityOnOutward__c) + (ledgerEntry.dmpl__AllocatedQuantity__c == null ? 0 : ledgerEntry.dmpl__AllocatedQuantity__c);
        }else {
            lotEntry.QuantitySaleReturned__c = (lotEntry.QuantitySaleReturned__c == null ? 0 : lotEntry.QuantitySaleReturned__c) - ledgerEntry.dmpl__Quantity__c;
        }
        return true;
    }

    private static Boolean doDamagedLedgerEntry(dmpl__InventoryLedger__c ledgerEntry, dmpl__ItemLot__c lotEntry)
    {
        lotEntry.dmpl__QuantityDamaged__c = (lotEntry.dmpl__QuantityDamaged__c == null ? 0 : lotEntry.dmpl__QuantityDamaged__c) + ledgerEntry.dmpl__Quantity__c;
        return true;
    }

    private static Boolean unDoDamagedLedgerEntry(dmpl__InventoryLedger__c ledgerEntry, dmpl__ItemLot__c lotEntry)
    {
        lotEntry.dmpl__QuantityDamaged__c = (lotEntry.dmpl__QuantityDamaged__c == null ? 0 : lotEntry.dmpl__QuantityDamaged__c) - ledgerEntry.dmpl__Quantity__c;
        return true;
    }

    private static Boolean doShortageLedgerEntry(dmpl__InventoryLedger__c ledgerEntry, dmpl__ItemLot__c lotEntry)
    {
        lotEntry.dmpl__QuantityShortage__c = (lotEntry.dmpl__QuantityShortage__c == null ? 0 : lotEntry.dmpl__QuantityShortage__c) + ledgerEntry.dmpl__Quantity__c;
        return true;
    }

    private static Boolean unDoShortageLedgerEntry(dmpl__InventoryLedger__c ledgerEntry, dmpl__ItemLot__c lotEntry)
    {
        lotEntry.dmpl__QuantityShortage__c = (lotEntry.dmpl__QuantityShortage__c == null ? 0 : lotEntry.dmpl__QuantityShortage__c) - ledgerEntry.dmpl__Quantity__c;
        return true;
    }

    private static Boolean doExcessLedgerEntry(dmpl__InventoryLedger__c ledgerEntry, dmpl__ItemLot__c lotEntry)
    {
        lotEntry.dmpl__QuantityExcess__c = (lotEntry.dmpl__QuantityExcess__c == null ? 0 : lotEntry.dmpl__QuantityExcess__c) + ledgerEntry.dmpl__Quantity__c;
        return true;
    }

    private static Boolean unDoExcessLedgerEntry(dmpl__InventoryLedger__c ledgerEntry, dmpl__ItemLot__c lotEntry)
    {
        lotEntry.dmpl__QuantityExcess__c = (lotEntry.dmpl__QuantityExcess__c == null ? 0 : lotEntry.dmpl__QuantityExcess__c) - ledgerEntry.dmpl__Quantity__c;
        return true;
    }

    private static Boolean DoExpiredLedgerEntry(dmpl__InventoryLedger__c ledgerEntry, dmpl__ItemLot__c lotEntry)
    {
        lotEntry.dmpl__QuantityExpired__c = (lotEntry.dmpl__QuantityExpired__c == null ? 0 : lotEntry.dmpl__QuantityExpired__c) + ledgerEntry.dmpl__Quantity__c;
        return true;
    }

    @testVisible
    private static Boolean unDoExpiredLedgerEntry(dmpl__InventoryLedger__c ledgerEntry, dmpl__ItemLot__c lotEntry)
    {
        lotEntry.dmpl__QuantityExpired__c = (lotEntry.dmpl__QuantityExpired__c == null ? 0 : lotEntry.dmpl__QuantityExpired__c) - ledgerEntry.dmpl__Quantity__c;
        return true;
    }

    private static Boolean DoHoldLedgerEntry(dmpl__InventoryLedger__c ledgerEntry, dmpl__ItemLot__c lotEntry)
    {
        lotEntry.dmpl__QuantityOnHold__c = (lotEntry.dmpl__QuantityOnHold__c == null ? 0 : lotEntry.dmpl__QuantityOnHold__c) + ledgerEntry.dmpl__Quantity__c;
        return true;
    }

    @testVisible
    private static Boolean unDoHoldLedgerEntry(dmpl__InventoryLedger__c ledgerEntry, dmpl__ItemLot__c lotEntry)
    {
        lotEntry.dmpl__QuantityOnHold__c = (lotEntry.dmpl__QuantityOnHold__c == null ? 0 : lotEntry.dmpl__QuantityOnHold__c) - ledgerEntry.dmpl__Quantity__c;
        return true;
    }

    private static Boolean DoLoanLedgerEntry(dmpl__InventoryLedger__c ledgerEntry, dmpl__ItemLot__c lotEntry)
    {
        lotEntry.dmpl__QuantityOnLoan__c = (lotEntry.dmpl__QuantityOnLoan__c == null ? 0 : lotEntry.dmpl__QuantityOnLoan__c) + ledgerEntry.dmpl__Quantity__c;
        return true;
    }

    @testVisible
    private static Boolean unDoLoanLedgerEntry(dmpl__InventoryLedger__c ledgerEntry, dmpl__ItemLot__c lotEntry)
    {
        lotEntry.dmpl__QuantityOnLoan__c = (lotEntry.dmpl__QuantityOnLoan__c == null ? 0 : lotEntry.dmpl__QuantityOnLoan__c) - ledgerEntry.dmpl__Quantity__c;
        return true;
    }

    private static Boolean doInspectionLedgerEntry(dmpl__InventoryLedger__c ledgerEntry, dmpl__ItemLot__c lotEntry)
    {
        lotEntry.dmpl__QuantityOnInspection__c = (lotEntry.dmpl__QuantityOnInspection__c == null ? 0 : lotEntry.dmpl__QuantityOnInspection__c) + ledgerEntry.dmpl__Quantity__c;
        return true;
    }

    private static Boolean unDoInspectionLedgerEntry(dmpl__InventoryLedger__c ledgerEntry, dmpl__ItemLot__c lotEntry)
    {
        lotEntry.dmpl__QuantityOnInspection__c = (lotEntry.dmpl__QuantityOnInspection__c == null ? 0 : lotEntry.dmpl__QuantityOnInspection__c) - ledgerEntry.dmpl__Quantity__c;
        return true;
    }

    private static Map<Id, dmpl__ItemLot__c> getLedgerRelatedLots(
        List<dmpl__InventoryLedger__c> newLedgerEntries, 
        List<dmpl__InventoryLedger__c> oldLedgerEntries)
    {
        List<ID> itemLotIds = new List<ID>();
        //
        if(newLedgerEntries!=null)
            for(dmpl__InventoryLedger__c ledgerEntry : newLedgerEntries)
            {
                itemLotIds.Add(ledgerEntry.dmpl__ItemLotId__c);
                if(ledgerEntry.dmpl__RelatedItemLotId__c!=null && !itemLotIds.Contains(ledgerEntry.dmpl__RelatedItemLotId__c))
                    itemLotIds.Add(ledgerEntry.dmpl__RelatedItemLotId__c);
            }
        //
        if(oldLedgerEntries!=null)
            for(dmpl__InventoryLedger__c ledgerEntry : oldLedgerEntries)
            {
                itemLotIds.Add(ledgerEntry.dmpl__ItemLotId__c);
                if(ledgerEntry.dmpl__RelatedItemLotId__c!=null && !itemLotIds.Contains(ledgerEntry.dmpl__RelatedItemLotId__c))
                    itemLotIds.Add(ledgerEntry.dmpl__RelatedItemLotId__c);
            }
        return new Map<Id,dmpl__ItemLot__c>([SELECT id,
            dmpl__QuantityAdjustedIn__c,
            dmpl__QuantityAdjustedOut__c,
            dmpl__QuantityAssembledIn__c,
            dmpl__QuantityAssembledOut__c,
            dmpl__QuantityInTransit__c,
            dmpl__QuantityOnFulfillment__c,
            dmpl__QuantityOnAllocation__c,
            dmpl__QuantityPicked__c,
            dmpl__QuantityPurchased__c,
            dmpl__QuantityPurchaseReturned__c,
            dmpl__QuantitySold__c,
            dmpl__QuantitySaleReturned__c,
            dmpl__QuantityTransferIn__c,
            dmpl__QuantityTransferOut__c,
            dmpl__QuantityOnInward__c,
            dmpl__QuantityOnOutward__c,
            dmpl__RelatedItemLotId__c,
            dmpl__QuantityInHand__c,
            dmpl__QuantityOnInspection__c,
            dmpl__PartnerAccountId__c,
            dmpl__BranchId__c,
            dmpl__ItemId__c,
            dmpl__StorageLocationId__c,
            dmpl__QuantityDamaged__c ,
            dmpl__QuantityShortage__c,
            dmpl__QuantityExcess__c,
            dmpl__QuantityOnHold__c,
            dmpl__QuantityExpired__c,
            dmpl__QuantityOnLoan__c,
            dmpl__QuantityInPendingDeliveries__c
            FROM dmpl__ItemLot__c WHERE id IN : itemLotIds FOR UPDATE]);
    }

    private static Map<Id, dmpl__Item__c> getRelatedItemRecords(
        List<dmpl__InventoryLedger__c> newLedgerEntries, 
        List<dmpl__InventoryLedger__c> oldLedgerEntries)
    {
        List<string> lineIds = new List<string>();
        //
        if(newLedgerEntries!=null)
            for(dmpl__InventoryLedger__c ledgerLine : newLedgerEntries)
                lineIds.Add(ledgerLine.dmpl__ItemId__c);
        if(oldLedgerEntries!=null)
            for(dmpl__InventoryLedger__c ledgerLine : oldLedgerEntries)
                lineIds.Add(ledgerLine.dmpl__ItemId__c);
        
        return new Map<Id,dmpl__Item__c>([SELECT Id,
            Name,
            dmpl__ItemCode__c,
            dmpl__IsActive__c,
            dmpl__TrackInventory__c,
            dmpl__TrackLots__c
            FROM dmpl__Item__c
            WHERE Id in : lineIds]);
    }

    public static void createItemLotFromReceiptLines(List<dmpl__GoodsReceiptLine__c> goodsReceiptLines)
    {
        Map<Id, dmpl__ItemLot__c> itemLots = queryRelatedLotRecords(goodsReceiptLines, new List<dmpl__GoodsReceiptLine__c>());
        Map<Id, dmpl__Item__c> ItemsCache = queryItemRecordsForObjects(goodsReceiptLines, new List<dmpl__GoodsReceiptLine__c>());
        List<dmpl__ItemLot__c> insertedItemLots = new List<dmpl__ItemLot__c>();
        Map<ID, dmpl__GoodsReceipt__c> receiptDocuments = queryGoodsReceipts(DocumentHelper.extractIds(goodsReceiptLines,'dmpl__GoodsReceiptId__c'));
        for(dmpl__GoodsReceiptLine__c lineEntry : goodsReceiptLines)
        {
            dmpl__Item__c item = ItemsCache.Get((ID)lineEntry.Get('dmpl__ItemId__c'));
            if(item == null)
                throwDmplException(System.Label.IntegrityFailed_MssingProduct);
            else if(!item.dmpl__TrackInventory__c)
                continue;
            else if(item.dmpl__TrackLots__c && lineEntry.Get('dmpl__ItemLotId__c') != null)
                continue;
                // throwDmplException(System.Label.IntegrityFailed_InvalidProductLot);
            else
            {
                if(item.dmpl__RequireInspectionOnReceipt__c){
                    lineEntry.dmpl__InspectionQuantity__c = lineEntry.dmpl__ReceivedQuantity__c;
                }
                if(item.dmpl__TrackLots__c) 
                {
                    dmpl__ItemLot__c itemLot = ItemLotHelper.createItemLot(lineEntry, item, null, receiptDocuments.get(lineEntry.dmpl__GoodsReceiptId__c));
                    if(itemLot!=null)
                    {
                        lineEntry.putSObject('dmpl__ItemLotId__r', itemLot);
                        insertedItemLots.Add(itemLot);
                    }
                }
            }
        }
        //
        insert insertedItemLots;
        //
        for(sObject lineEntry : goodsReceiptLines)
        {
            dmpl__ItemLot__c itemLot = (dmpl__ItemLot__c)lineEntry.GetsObject('dmpl__ItemLotId__r');
            if(itemLot!=null){
                lineEntry.Put('dmpl__ItemLotId__c', itemLot.Id);
            }
        }
    }

    public static void updateOrDeleteItemLotsFromReceiptLines(Boolean isUpdate, Boolean isDelete, List<dmpl__GoodsReceiptLine__c> newEntries, List<dmpl__GoodsReceiptLine__c> oldEntries)
    {
        Map<Id, dmpl__ItemLot__c> itemLots = queryRelatedLotRecords(newEntries, oldEntries);
        Map<Id, dmpl__Item__c> ItemsCache = queryItemRecordsForObjects(newEntries, oldEntries);
        //
        List<dmpl__ItemLot__c> deletedItemLots = new List<dmpl__ItemLot__c>();
        List<dmpl__ItemLot__c> updatedItemLots = new List<dmpl__ItemLot__c>();
        //
        Map<ID, dmpl__GoodsReceipt__c> receiptDocuments = queryGoodsReceipts(DocumentHelper.extractIds(isDelete ? oldEntries : newEntries,'dmpl__GoodsReceiptId__c'));
        if(isDelete || isUpdate)
        {
            for(dmpl__GoodsReceiptLine__c lineEntry : oldEntries)
            {
                dmpl__Item__c item = ItemsCache.Get((ID)lineEntry.Get('dmpl__ItemId__c'));
                if(item == null)
                    throwDmplException(System.Label.IntegrityFailed_MssingProduct);
                else if(!item.dmpl__TrackInventory__c)
                    continue;
                else 
                {
                    if(isUpdate && item.dmpl__RequireInspectionOnReceipt__c)
                    {
                        dmpl__GoodsReceiptLine__c newLineEntry = getCorrespondingLineEntry(newEntries, lineEntry);
                        // newLineEntry.dmpl__InspectionQuantity__c = newLineEntry.dmpl__ReceivedQuantity__c;
                        newLineEntry.dmpl__InspectionQuantity__c = newLineEntry.dmpl__StartedInspectionQuantity__c;
                    }
                    //
                  if(item.dmpl__TrackLots__c) 
                    {
                        dmpl__ItemLot__c itemLot = itemLots.Get(lineEntry.dmpl__ItemLotId__c);    
                        if(itemLot == null)
                            throwDmplException(System.Label.IntegrityFailed_MssingProductLot);
                        else
                        {
                            if(isDelete)
                                deletedItemLots.Add(itemLot);
                            else
                            {
                                dmpl__GoodsReceiptLine__c newLineEntry = getCorrespondingLineEntry(newEntries, lineEntry);
                                if(newLineEntry == null)
                                    throwDmplException(System.Label.IntegrityFailed_MssingNewLine);
                                else
                                {
                                    itemLot = createItemLot(newLineEntry, item, itemLot, receiptDocuments.get(newLineEntry.dmpl__GoodsReceiptId__c));
                                    if(itemLot!=null)
                                        updatedItemLots.Add(itemLot);
                                }
                            }
                        }
                    }
                }
            }
            //
            delete deletedItemLots;
            update updatedItemLots;
        }
    }

    @testVisible
    private static Map<Id, dmpl__ItemLot__c> queryRelatedLotRecords(List<sObject> newEntries, List<sObject> oldEntries)
    {
        List<string> lineIds = new List<string>();
        //
        if(newEntries!=null)
            for(sObject newLine : newEntries)
                lineIds.Add((ID)newLine.Get('dmpl__ItemLotId__c'));
        if(oldEntries!=null)
            for(sObject oldLine : oldEntries)
                lineIds.Add((ID)oldLine.Get('dmpl__ItemLotId__c'));
        //
        return new Map<Id,dmpl__ItemLot__c>([SELECT id,
            dmpl__BranchId__c,
            dmpl__BatchNo__c,
            dmpl__ComponentNumber__c,
            dmpl__UnitCost__c,
            dmpl__DateOfExpiry__c,
            dmpl__DateOfMfg__c,
            dmpl__DateofSupplierDispatch__c,
            dmpl__DateofSupplierInvoice__c,
            dmpl__SupplierInvoiceNumber__c,
            dmpl__DateOfReceipt__c,
            dmpl__ItemId__c,
            dmpl__MRP__c,
            Name,
            dmpl__SKUId__c,
            dmpl__ItemLotTypeId__c,
            dmpl__StorageLocationId__c
            FROM dmpl__ItemLot__c
            WHERE Id in : lineIds]);
    }

    @testVisible
    private static Map<Id, dmpl__Item__c> queryItemRecordsForObjects(List<sObject> newEntries, List<sObject> oldEntries)
    {
        List<string> lineIds = new List<string>();
        //
        if(newEntries!=null)
            for(sObject newLine : newEntries)
                lineIds.Add((ID)newLine.Get('dmpl__ItemId__c'));
        if(oldEntries!=null)
            for(sObject oldLine : oldEntries)
                lineIds.Add((ID)oldLine.Get('dmpl__ItemId__c'));
        //
        return new Map<Id,dmpl__Item__c>([SELECT id,
            Name,
            dmpl__IsActive__c,
            dmpl__TrackInventory__c,
            dmpl__TrackLots__c, 
            dmpl__RequireInspectionOnReceipt__c
            FROM dmpl__Item__c
            WHERE Id in : lineIds]);
    }

    @testVisible
    private static Map<ID, dmpl__GoodsReceipt__c> queryGoodsReceipts(List<ID> goodsReceiptIds)
    {
        return new Map<ID, dmpl__GoodsReceipt__c>([SELECT  
        dmpl__BranchId__c,
        dmpl__BranchId__r.dmpl__PartnerAccountId__c,
        dmpl__DocumentDate__c,
        dmpl__SupplierDispatchDate__c,
        dmpl__SupplierInvoiceDate__c,
        dmpl__SupplierInvoiceNumber__c,
        dmpl__Status__c
        FROM dmpl__GoodsReceipt__c WHERE ID IN : goodsReceiptIds]);
    }

    @testVisible
    private static dmpl__GoodsReceiptLine__c getCorrespondingLineEntry(List<dmpl__GoodsReceiptLine__c> newEntries, dmpl__GoodsReceiptLine__c oldEntry)
    {
        for(dmpl__GoodsReceiptLine__c newEntry: newEntries)
            if(newEntry.Id == oldEntry.Id)
                return newEntry;
        return null;
    }

    public static dmpl__ItemLot__c createItemLot(dmpl__GoodsReceiptLine__c sourceEntry, dmpl__Item__c sourceItem, dmpl__ItemLot__c existingItemLot, dmpl__GoodsReceipt__c document)
    {
        dmpl__ItemLot__c itemLot = existingItemLot;
        if(itemLot == null){
            itemLot = new dmpl__ItemLot__c();
        }
        itemLot.dmpl__PartnerAccountId__c = document.dmpl__BranchId__r.dmpl__PartnerAccountId__c;
        itemLot.dmpl__BranchId__c = document.dmpl__BranchId__c;
        itemLot.dmpl__ComponentNumber__c = sourceEntry.dmpl__ComponentNumber__c;
        itemLot.dmpl__SerialNumber__c = sourceEntry.dmpl__SerialNumber__c;
        itemLot.dmpl__UnitCost__c = sourceEntry.dmpl__UnitCost__c;
        itemLot.dmpl__DateOfSupplierDispatch__c = document.dmpl__SupplierDispatchDate__c;
        itemLot.dmpl__DateOfSupplierInvoice__c = document.dmpl__SupplierInvoiceDate__c;
        itemLot.dmpl__SupplierInvoiceNumber__c = document.dmpl__SupplierInvoiceNumber__c;
        itemLot.dmpl__DateOfReceipt__c = document.dmpl__DocumentDate__c;
        itemLot.dmpl__ItemId__c = sourceEntry.dmpl__ItemId__c;
        itemLot.dmpl__MRP__c = sourceEntry.dmpl__MRP__c;
        itemLot.dmpl__SKUId__c = sourceEntry.dmpl__SKUId__c;
        itemLot.dmpl__ItemLotTypeId__c = sourceEntry.dmpl__ItemLotTypeId__c;
        itemLot.dmpl__StorageLocationId__c = sourceEntry.dmpl__StorageLocationId__c;
        itemLot.dmpl__HashCode__c = getHashCode();
        return itemLot;
    }

    private static void setHashCodes(List<dmpl__ItemLot__c> itemLots){
        for(dmpl__ItemLot__c itemLot : itemLots){
            if(itemLot.dmpl__HashCode__c == null){
                itemLot.dmpl__HashCode__c = getHashCode();
            }
        }
    }
    
    private static Double getHashCode(){
        return Datetime.now().getTime() + Math.random() * 1000000;
    }

    private static void checkForLockedTransactions(
        List<dmpl__ItemLot__c> newEntries){
            if(skipLockCheck){
                return;
            }
            for(dmpl__ItemLot__c entry : newEntries){
                if(entry.dmpl__IsTransactionLocked__c){
                    entry.addError('Item is locked for transaction! Please contact your Administrator for more details.');
                }
            }
    }

    private static void throwDmplException(String message){
        throw new DMPLException(message);
    }
}