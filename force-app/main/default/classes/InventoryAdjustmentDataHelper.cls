@isTest
public class InventoryAdjustmentDataHelper {
    public static dmpl__InventoryAdjustment__c CreateAdjustment(dmpl__Branch__c branch) {
        return (dmpl__InventoryAdjustment__c)TestFactory.createSObject(
            new dmpl__InventoryAdjustment__c(
                dmpl__BranchId__c = branch.Id,
                dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c
            ),
            'InventoryAdjustmentDefaults',
            true
        );
    }

      public static dmpl__InventoryAdjustment__c CreateAdjustment(
        Id branchId,
        Id partnerId,
        Date documentDate
        ) {
        return (dmpl__InventoryAdjustment__c)TestFactory.createSObject(
            new dmpl__InventoryAdjustment__c(
                dmpl__BranchId__c = branchId,
                dmpl__PartnerAccountId__c = partnerId,
                dmpl__Documentdate__c = documentDate
            ),
            'InventoryAdjustmentDefaults',
            true
        );
    }

    public static dmpl__InventoryAdjustmentLine__c CreateAdjustmentLine(
        dmpl__Item__c item,
        dmpl__SKU__c sku,
        dmpl__StorageLocation__c storageLocation,
        dmpl__ItemLot__c ItemLot,
        dmpl__InventoryAdjustment__c adjustment
    ) {
       return (dmpl__InventoryAdjustmentLine__c)TestFactory.createSObject(
        new dmpl__InventoryAdjustmentLine__c(
            dmpl__ItemId__c = item.Id,
            dmpl__SKUId__c = sku.Id,
            dmpl__StorageLocationId__c = storageLocation.Id,
            dmpl__Quantity__c = 4,
            dmpl__TotalCost__c = 100,
            dmpl__ItemLotId__c = itemLot.Id,
            dmpl__Remarks__c = 'Test - Remarks',
            dmpl__InventoryAdjustmentId__c = adjustment.Id,
            dmpl__AdjustmentType__c = 'Assemble'
        ),
        'InventoryAdjustmentLineDefaults',
        true
       );
    }

    public static dmpl__InventoryAdjustmentLine__c CreateAdjustmentLine(
        Id item,
        Integer quantity,
        Id adjustment
    ) {
       return (dmpl__InventoryAdjustmentLine__c)TestFactory.createSObject(
        new dmpl__InventoryAdjustmentLine__c(
            dmpl__ItemId__c = item,
            dmpl__Quantity__c = quantity,
            dmpl__TotalCost__c = 100,
            dmpl__Remarks__c = 'Test - Remarks',
            dmpl__InventoryAdjustmentId__c = adjustment,
            dmpl__AdjustmentType__c = 'Assemble'
        ),
        'InventoryAdjustmentLineDefaults',
        true
       );
    }

    public static dmpl__InventoryAdjustment__c getAdjustment() {
        return [SELECT 
        Id, 
        name,
        dmpl__Status__c,
        dmpl__PerformInventoryPosting__c,
        PartnerAccountId__c,
        BranchId__c,
        dmpl__PriceListId__c,
        dmpl__ClaimId__c,
        dmpl__ClaimBatchId__c
        FROM dmpl__InventoryAdjustment__c LIMIT 1];
    }
    
    public static dmpl__InventoryAdjustment__c getAdjustment(Id id) {
        return [SELECT 
        Id, 
        name,
        dmpl__Status__c,
        dmpl__PerformInventoryPosting__c,
        dmpl__PartnerAccountId__c,
        dmpl__BranchId__c,
        dmpl__PriceListId__c,
        dmpl__Documentdate__c,
        dmpl__ClaimId__c,
        dmpl__ClaimBatchId__c
        FROM dmpl__InventoryAdjustment__c
        WHERE Id = :id LIMIT 1];
    }

    public static dmpl__InventoryAdjustmentLine__c getAdjustmentLine(){
        return [SELECT 
        id, 
        name,
        dmpl__SKUId__c,
        dmpl__AdjustmentType__c,
        dmpl__ItemId__c,
        dmpl__IsILPostingApproved__c,
        dmpl__Quantity__c,
        dmpl__TotalCost__c,
        dmpl__InventoryAdjustmentId__c
        FROM dmpl__InventoryAdjustmentLine__c LIMIT 1];
    }

    public static dmpl__InventoryAdjustmentLine__c getAdjustmentLine(Id id){
        return [SELECT 
        id, 
        name,
        dmpl__SKUId__c,
        dmpl__AdjustmentType__c,
        dmpl__ItemId__c,
        dmpl__IsILPostingApproved__c,
        dmpl__Quantity__c,
        dmpl__TotalCost__c,
        dmpl__InventoryAdjustmentId__c
        FROM dmpl__InventoryAdjustmentLine__c
        WHERE Id = :id LIMIT 1];
    }

    public static dmpl__InventoryLedger__c CreateInventoryLedger(
        dmpl__Branch__c branch,
        dmpl__Item__c item,
        dmpl__SKU__c sku,
        dmpl__ItemLot__c itemLot,
        dmpl__StorageLocation__c storageLocation
    ){
        return (dmpl__InventoryLedger__c)TestFactory.createSObject(
            new dmpl__InventoryLedger__c(
                dmpl__BranchId__c = branch.Id,
                dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                dmpl__InventoryLedgerType__c = ' Adjustment ',
                dmpl__SourceDocument__c = ' Test - Source - Document',
                dmpl__IsInventoryStockPosted__c = false,
                dmpl__ItemId__c = item.Id,
                dmpl__SKUId__c = sku.Id,
                dmpl__ItemLotId__c = itemLot.Id,
                dmpl__StorageLocationId__c = storageLocation.Id,
                dmpl__Quantity__c = 10,
                dmpl__UnitCost__c = 100,
                dmpl__DocumentDate__c = Date.today()
            ),
            'InventoryLedgerDefaults',
            true
        );
    }

    public static dmpl__InventoryLedger__c getInventoryLedger(){
        return [SELECT 
        id,
        Name,
        dmpl__InventoryLedgerType__c,
        dmpl__Quantity__c,
        dmpl__PartnerAccountId__c,
        dmpl__BranchId__c,
        dmpl__ItemId__c,
        dmpl__SKUId__c
        FROM dmpl__InventoryLedger__c LIMIT 1];
    }
}