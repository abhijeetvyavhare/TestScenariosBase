@isTest
public class InventoryTestDataHelpers {
    public  static dmpl__InventoryStock__c CreateInventoryStock(
        dmpl__Branch__c branch,
        dmpl__Item__c item,
        dmpl__SKU__c sku,
        dmpl__StorageLocation__c storageLocation){
        return (dmpl__InventoryStock__c)TestFactory.createSObject(
                new dmpl__InventoryStock__c(
                  dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                  dmpl__BranchId__c = branch.Id,
                  dmpl__ItemId__c = item.Id,
                  dmpl__SKUId__c= sku.id,
                  dmpl__StorageLocationId__c = storageLocation.Id
                ),
                'InventoryStockDefaults',
                true
        );
    }

    public static dmpl__InventoryStock__c getInventoryStock(){
        return [SELECT Id,
        dmpl__BranchId__c,
        CreatedById,
        dmpl__ExternalId__c,
        dmpl__FinancialYear__c,
        dmpl__HashCode__c,
        dmpl__ItemId__c,
        dmpl__SKUId__c,
        LastModifiedById,
        Name,
        OwnerId,
        dmpl__PartnerAccountId__c,
        dmpl__QuantityAdjustedIn__c,
        dmpl__QuantityAdjustedOut__c,
        dmpl__QuantityAssembledIn__c,
        dmpl__QuantityAssembledOut__c,
        dmpl__QuantityAvailable__c,
        dmpl__QuantityDamaged__c,
        dmpl__QuantityExpired__c,
        dmpl__QuantityInHand__c	,
        dmpl__QuantityInPipeline__c,
        dmpl__QuantityInTransit__c,
        dmpl__QuantityOnAllocation__c,
        dmpl__QuantityOnFulfillment__c,
        dmpl__QuantityOnHold__c,	
        dmpl__QuantityOnInspection__c,
        dmpl__QuantityOnInward__c,
        dmpl__QuantityOnLoan__c,
        dmpl__QuantityOnOutward__c,
        dmpl__QuantityPicked__c,
        dmpl__QuantityProjected__c,
        dmpl__QuantityPurchaseReturned__c,
        dmpl__QuantityPurchased__c,
        dmpl__QuantitySaleReturned__c,
        dmpl__QuantitySold__c,
        dmpl__QuantityTransferIn__c,
        dmpl__QuantityTransferOut__c,
        dmpl__QuantityInPendingDeliveries__c,
        dmpl__StorageLocationId__c
        FROM dmpl__InventoryStock__c LIMIT 1];
    }

    public static dmpl__InventoryLedger__c createInventoryLedger(
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
            // 'InventoryLedgerDefaults',
            true
        );
    }

    public static dmpl__InventoryLedger__c getInventoryLedger(){
        return [SELECT Id,
        Name,
        dmpl__Quantity__c,
        dmpl__PartnerAccountId__c,
        dmpl__ItemId__c,
        dmpl__SKUId__c,
        dmpl__RelatedPartnerAccountId__c,
        dmpl__AllocatedQuantity__c,
        dmpl__BranchId__c,
        CreatedById,
        dmpl__PendingDeliveriesQuantity__c,
        dmpl__DamagedQuantity__c,
        dmpl__ExternalId__c,
        dmpl__HashCode__c,
        dmpl__InwardQuantity__c,
        dmpl__IsInventoryStockPosted__c,
        dmpl__ItemCode__c,
        dmpl__ItemLotId__c,
        dmpl__ItemLotTypeId__c,
        dmpl__PickedQuantity__c,
        LastModifiedById,
        dmpl__InventoryLedgerType__c,
        OwnerId,
        dmpl__DocumentDate__c,
        dmpl__RelatedBranchId__c,
        dmpl__RelatedItemLotId__c,
        dmpl__SourceDocument__c,
        dmpl__StorageLocationId__c,
        dmpl__UnitCost__c 
        FROM dmpl__InventoryLedger__c LIMIT 1];
    }

    public static Product2 CreateProduct(){
        return (Product2)TestFactory.createSObject(
            new Product2(
                Name = 'Test-Product',
                ProductCode = '754382',
                IsActive = true,
                Family = 'none'
            ),
            // 'Product2Defaults',
            true
        );
    }

    public static Product2 getProduct(){
        return [SELECT id, Name FROM  Product2 LIMIT 1];
    }
}