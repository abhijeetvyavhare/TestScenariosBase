@isTest
public class CycleCountTestDataHelpers {

    public static dmpl__InventoryCycleCount__c createCycleCount(
        dmpl__Branch__c branch,
        dmpl__Item__c item
    ) {
        return (dmpl__InventoryCycleCount__c)TestFactory.createSObject(
            new dmpl__InventoryCycleCount__c(
                dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                dmpl__BranchId__c = branch.Id,
                dmpl__PerformStartCounting__c = false,
                dmpl__PerformFinishCounting__c = false,                                                 
                dmpl__PerformReleaseAdjustment__c = false,                                                 
                dmpl__ItemId__c = item.Id,
                dmpl__MaximumItems__c = 2,
                dmpl__ManufacturingDateFrom__c = date.today(),
                dmpl__ManufacturingDateTo__c = date.today(),
                dmpl__PartCostFrom__c = 40,
                dmpl__PartCostTo__c = 50,
                dmpl__PartStockFrom__c = 40,
                dmpl__PartStockTo__c = 50),
                'InventoryCycleCountDefaults',
                true
        );
    }

    public static dmpl__InventoryCycleCount__c getCycleCount() {
        return  [SELECT 
        id, 
        Name,
        dmpl__BranchId__c,
        dmpl__StorageLocationId__c,
        dmpl__MaximumItems__c,
        dmpl__PartnerAccountId__c,
        dmpl__ItemGroupId__c,
        dmpl__AdjustmentId__c,
        dmpl__CountQuantityType__c,
        dmpl__FilterABC__c,
        dmpl__FilterFSN__c,
        dmpl__ItemId__c,
        dmpl__PerformStartCounting__c,
        dmpl__PerformReleaseAdjustment__c,
        dmpl__PerformFinishCounting__c,
        dmpl__LockInventory__c
        FROM dmpl__InventoryCycleCount__c LIMIT 1];
    }

     public static dmpl__InventoryCycleCount__c getCycleCount(Id cycleCountId) {
        return  [SELECT 
        id, 
        Name,
        dmpl__BranchId__c,
        dmpl__StorageLocationId__c,
        dmpl__MaximumItems__c,
        dmpl__PartnerAccountId__c,
        dmpl__ItemGroupId__c,
        dmpl__AdjustmentId__c,
        dmpl__CountQuantityType__c,
        dmpl__FilterABC__c,
        dmpl__FilterFSN__c,
        dmpl__ItemId__c,
        dmpl__PerformStartCounting__c,
        dmpl__PerformReleaseAdjustment__c,
        dmpl__PerformFinishCounting__c,
        dmpl__LockInventory__c
        FROM dmpl__InventoryCycleCount__c WHERE id= :cycleCountId LIMIT 1];
    }

    public static dmpl__InventoryCycleCountLine__c createCycleCountLine(
        dmpl__InventoryCycleCount__c cycleCount,
        dmpl__ItemLot__c itemLot
    ){
        return (dmpl__InventoryCycleCountLine__c)TestFactory.createSObject(
            new dmpl__InventoryCycleCountLine__c(
                dmpl__IsApproved__c = true,
                dmpl__ItemId__c = itemLot.dmpl__ItemId__c,
                dmpl__SKUId__c = itemLot.dmpl__SKUId__c,
                dmpl__ItemLotId__c = itemLot.Id,
                dmpl__UnitCost__c = 100,
                dmpl__OnHandQuantity__c = 10,
                dmpl__PickedQuantity__c = 5,
                dmpl__RecordedQuantity__c = 10,
                dmpl__RecordedDamagedQuantity__c = 1,
                dmpl__RecordedExpiredQuantity__c = 2,
                dmpl__CycleCountId__c = cycleCount.Id,
                dmpl__Remarks__c = 'Successfully Created'),
                true    
        );
    }

    public static dmpl__InventoryCycleCountLine__c getCycleCountLine(){
        return [SELECT 
				id,
				name,
				dmpl__PickedQuantity__c,
				dmpl__CycleCountId__c,
				dmpl__ItemId__c,
				dmpl__ItemLotTypeId__c,
				dmpl__OnHandQuantity__c,
				dmpl__DiscrepencyQuantity__c,
				dmpl__ExpectedQuantity__c,
				dmpl__DiscrepancyCostValue__c,
				dmpl__UnitCost__c
        FROM dmpl__InventoryCycleCountLine__c LIMIT 1];
    }
    
    public static dmpl__InventoryCycleCountLine__c getCycleCountLine(Id cycleCountLineId){
        return [SELECT 
				id,
				name,
				dmpl__PickedQuantity__c,
				dmpl__CycleCountId__c,
				dmpl__ItemId__c,
				dmpl__ItemLotTypeId__c,
				dmpl__OnHandQuantity__c,
				dmpl__DiscrepencyQuantity__c,
				dmpl__ExpectedQuantity__c,
				dmpl__DiscrepancyCostValue__c,
				dmpl__UnitCost__c
        FROM dmpl__InventoryCycleCountLine__c where id= :cycleCountLineId LIMIT 1];
    }
    
    public static dmpl__InventoryCycleCountRule__c createCycleCountRule(
        dmpl__InventoryCycleCount__c cycleCount
    ){
        return (dmpl__InventoryCycleCountRule__c)TestFactory.createSObject(
            new dmpl__InventoryCycleCountRule__c(
                dmpl__CycleCountId__c = cycleCount.Id,
                dmpl__FieldName__c = 'dmpl__ItemId__c',
                dmpl__FieldValue__c = 'TestValue',
                dmpl__Operation__c = 'equals'
            ),
            true    
        );
    }

    public static dmpl__InventoryCycleCountRule__c getCycleCountRule(){
        return [SELECT 
        id,
        name,
        dmpl__FieldName__c,
        dmpl__FieldValue__c,
        dmpl__Operation__c,
        dmpl__CycleCountId__c
        FROM dmpl__InventoryCycleCountRule__c LIMIT 1];
    }

    public static dmpl__InventoryCycleCountRule__c getCycleCountRule(Id cycleCountRuleId){
        return [SELECT 
        id,
        name,
        dmpl__FieldName__c,
        dmpl__FieldValue__c,
        dmpl__Operation__c,
        dmpl__CycleCountId__c
        FROM dmpl__InventoryCycleCountRule__c where id= :cycleCountRuleId LIMIT 1];
    }


	 public static dmpl__InventoryCycleCount__c createCycleCount(
		Id partnerAccountId,
        Id branchId,
        Id itemGroupId,
		Id storageLocationId,
		String CountQuantityType
    ) {
        return (dmpl__InventoryCycleCount__c)TestFactory.createSObject(
            new dmpl__InventoryCycleCount__c(
                dmpl__PartnerAccountId__c = partnerAccountId,
                dmpl__BranchId__c = branchId,                                              
                dmpl__ItemGroupId__c = itemGroupId,
				dmpl__StorageLocationId__c = storageLocationId,
				dmpl__CountQuantityType__c = CountQuantityType
                ),
                'InventoryCycleCountDefaults',
                true
        );
    }

	public static dmpl__InventoryCycleCountLine__c createCycleCountLine(
        Id cycleCountId,
        Id itemId,
		Id itemLotTypeId,
	Decimal recordedQuantity,
        Decimal onHandQuantity,
		Decimal unitCost
    ){
        return (dmpl__InventoryCycleCountLine__c)TestFactory.createSObject(
            new dmpl__InventoryCycleCountLine__c(
                dmpl__CycleCountId__c = cycleCountId,
                dmpl__ItemId__c = itemId,
				dmpl__ItemLotTypeId__c = itemLotTypeId,
                dmpl__RecordedQuantity__c = recordedQuantity,
                dmpl__OnHandQuantity__c = onHandQuantity ,
				dmpl__UnitCost__c = unitCost
        		),
                true
        );
    }
}