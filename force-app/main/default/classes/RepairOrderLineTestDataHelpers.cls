@isTest
public class RepairOrderLineTestDataHelpers {
    public static dmpl__TaxGroup__c createTaxGroup() {
        return new dmpl__TaxGroup__c(
            Name = 'Test Tax Group',
            dmpl__IsActive__c = true
        );
    }

    public static dmpl__TaxGroup__c getTaxGroup() {
        return [SELECT Id FROM dmpl__TaxGroup__c LIMIT 1];
    }

    public static dmpl__ItemServiceContract__c createItemServiceContract(dmpl__Item__c item) {
        return new dmpl__ItemServiceContract__c(
            dmpl__ItemId__c = item.Id,
            dmpl__IsActive__c = true
        );
    }

    public static dmpl__ItemServiceContract__c getItemServiceContract() {
        return [SELECT Id FROM dmpl__ItemServiceContract__c LIMIT 1];
    }

    public static dmpl__RepairOrderLine__c createRepairOrderLine(
        dmpl__RepairOrder__c repairOrder,
        dmpl__Item__c item,
        dmpl__SKU__c sku, 
        dmpl__StorageLocation__c storageLocation,
        dmpl__TaxGroup__c taxGroup,
        dmpl__ItemServiceContract__c itemServiceContract,
        String postingType
    ) {
        dmpl__RepairOrderLine__c repairOrderLine = (dmpl__RepairOrderLine__c) TestFactory.createSObject(
            new dmpl__RepairOrderLine__c(
                dmpl__ItemId__c = item.Id,
                dmpl__SKUId__c = sku.Id,
                dmpl__ItemServiceContractId__c = itemServiceContract.Id,
                dmpl__StorageLocationId__c = storageLocation.Id,
                dmpl__TaxGroupId__c = taxGroup.Id,
                dmpl__RepairOrderId__c = repairOrder.Id,
                dmpl__PostingType__c = postingType
            ),
            'RepairOrderLineDefaults',
            true
        );
        return repairOrderLine;
    }

    public static dmpl__RepairOrderLine__c getRepairOrderLine() {
        return [SELECT
                Id,
                Name,
                dmpl__RepairOrderId__c,
                dmpl__ItemId__c,
                dmpl__SKUId__c,
                dmpl__Quantity__c,
                dmpl__UnitPrice__c,
                dmpl__PackageClassification__c,
                dmpl__ActionTaken__c,
                dmpl__StandardDurationHours__c,
                dmpl__ActualDurationHours__c,
                dmpl__CancelledQuantity__c,
                dmpl__ClaimedQuantity__c,
                dmpl__FulfilmentOrderQuantity__c,
                dmpl__RepairOrderId__r.dmpl__AccountId__c
                FROM dmpl__RepairOrderLine__c
                LIMIT 1
            ];
    }

    public static dmpl__RepairOrderLine__c getRepairOrderLineForUpdate() {
        return [SELECT 
            Id, 
            dmpl__Quantity__c,
            dmpl__CancelledQuantity__c,
            dmpl__ClaimedQuantity__c
            FROM dmpl__RepairOrderLine__c 
            LIMIT 1];
    }

    public static dmpl__RepairOrderLine__c getRepairOrderLineById(Id lineId) {
        return [SELECT 
            Id, 
            dmpl__Quantity__c,
            dmpl__CancelledQuantity__c,
            dmpl__ClaimedQuantity__c
            FROM dmpl__RepairOrderLine__c 
            WHERE Id = :lineId];
    }

    public static List<dmpl__RepairOrderLine__c> getRepairOrderLinesById(Id lineId) {
        return [SELECT Id FROM dmpl__RepairOrderLine__c WHERE Id = :lineId];
    }
}