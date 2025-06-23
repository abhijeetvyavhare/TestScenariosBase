@isTest
public with sharing class AssetTestDataHelpers {
    public static Asset CreateAsset(
        Account account,
        dmpl__Branch__c branch,
        dmpl__Item__c item,
        dmpl__ItemLot__c itemLot,
        dmpl__SKU__c sku
    ){
        return (Asset) TestFactory.createSObject(
            new Asset(
                Name = 'Test-Asset',
                AccountId = account.Id,
                dmpl__LastServiceBranchId__c = branch.Id,
                dmpl__ItemId__c = item.Id,
                dmpl__ItemLotId__c = itemLot.Id,
                dmpl__SKUId__c = sku.Id,
                dmpl__IsPDIDone__c=true,
                dmpl__RegistrationNumber__c = 'Axb371',
                dmpl__SaleDate__c = date.today()
            ),
            'AssetDefaults',
            true
        );
    }

    public static Asset getAsset() {
        return [
            SELECT Id, Name,dmpl__IsPDIDone__c,
        dmpl__RegistrationNumber__c
            FROM Asset
            LIMIT 1
        ];
    }

    public static Asset getAsset(Id assetId) {
        return [
            SELECT Id, Name,dmpl__IsPDIDone__c,
        dmpl__RegistrationNumber__c
            FROM Asset 
            WHERE Id = :assetId
            LIMIT 1
        ];
    }

    public static dmpl__AssetServiceContract__c createAssetServiceContract(
        Asset asset,
        dmpl__Item__c item){
        return (dmpl__AssetServiceContract__c)TestFactory.createSObject(
            new dmpl__AssetServiceContract__c(
                dmpl__AssetId__c = asset.Id,
                dmpl__ItemId__c = item.Id,
                dmpl__ServiceContractItemId__c = item.Id,
                dmpl__ActivatedDate__c = Datetime.now().Date(),
                dmpl__ValidtillDate__c = Datetime.now().addDays(365).Date(),
                dmpl__DueDate__c = Datetime.now().addDays(365).Date()),
            
                true
        );
    }

    public static dmpl__AssetServiceContract__c getAssetServiceContract(){
        return [SELECT
        Id,
        name,
        dmpl__ActivatedDate__c,
        dmpl__ValidtillDate__c,
        dmpl__DueDate__c
        FROM
        dmpl__AssetServiceContract__c LIMIT 1];
    }

    public static dmpl__AssetServiceContract__c getAssetServiceContract(id assetServiceContractId){
        return [SELECT
        Id,
        name,
        dmpl__ActivatedDate__c,
        dmpl__ValidtillDate__c,
        dmpl__DueDate__c
        FROM
        dmpl__AssetServiceContract__c where Id= :assetServiceContractId LIMIT 1];
    }

    public static dmpl__AssetServiceContractLine__c createAssetServiceContractLine(
        dmpl__AssetServiceContract__c assetServiceContract,
        dmpl__Item__c item){
        return (dmpl__AssetServiceContractLine__c)TestFactory.createSObject(
            new dmpl__AssetServiceContractLine__c(
                dmpl__AssetServiceContractId__c = assetServiceContract.Id,
                dmpl__ComponentItemId__c = item.Id,
                dmpl__Quantity__c = 10,
                dmpl__UtilizedQuantity__c = 5
                ),
                true
        );
    }

    public static dmpl__AssetServiceContractLine__c getAssetServiceContractLine(){
        return [SELECT
        Id,
        name,
        dmpl__ComponentItemId__c,
        dmpl__AssetServiceContractId__c,
        dmpl__Quantity__c,
        dmpl__UtilizedQuantity__c,
        dmpl__PendingQuantity__c
        FROM
        dmpl__AssetServiceContractLine__c LIMIT 1];
    }
    public static dmpl__AssetServiceContractLine__c getAssetServiceContractLine(id assetServiceContractLineId){
        return [SELECT
        Id,
        name,
        dmpl__ComponentItemId__c,
        dmpl__AssetServiceContractId__c,
        dmpl__Quantity__c,
        dmpl__UtilizedQuantity__c,
        dmpl__PendingQuantity__c
        FROM
        dmpl__AssetServiceContractLine__c where Id= :assetServiceContractLineId LIMIT 1];
    }

    public static dmpl__AssetMaintenance__c createAssetMaintenance(
        Asset asset,
        Account partnerAccount,
        dmpl__Branch__c branch,
        dmpl__RepairOrder__c repairOrder,
        dmpl__ServiceCampaign__c serviceCampaign,
        dmpl__ItemServiceContract__c itemServiceContract,
        dmpl__Item__c item){
        return (dmpl__AssetMaintenance__c)TestFactory.createSObject(
            new dmpl__AssetMaintenance__c(
                dmpl__AssetId__c = asset.Id,
                dmpl__PartnerAccountId__c = partnerAccount.Id,
                dmpl__BranchId__c = branch.Id,
                dmpl__RepairOrderId__c = repairOrder.Id,
                dmpl__ItemServiceContractId__c = itemServiceContract.Id,
                dmpl__ServiceCampaignId__c = serviceCampaign.Id,
                dmpl__ItemId__c = item.Id,
                dmpl__isExecuted__c=false,
                dmpl__isMandatory__c=false
            ),
              
                true
        );
    }

    public static dmpl__AssetMaintenance__c getAssetMaintenance(){
        return [SELECT
        Id,
        name,
        dmpl__AssetId__c,
        dmpl__PartnerAccountId__c,
        dmpl__BranchId__c,
        dmpl__RepairOrderId__c,
        dmpl__ItemServiceContractId__c,
        dmpl__ServiceCampaignId__c,
        dmpl__ItemId__c,
        dmpl__isExecuted__c,
        dmpl__isMandatory__c
        FROM
        dmpl__AssetMaintenance__c LIMIT 1];
    }
    public static dmpl__AssetMaintenance__c getAssetMaintenance(id assetMaintenanceId){
        return [SELECT
        Id,
        name,
        dmpl__AssetId__c,
        dmpl__PartnerAccountId__c,
        dmpl__BranchId__c,
        dmpl__RepairOrderId__c,
        dmpl__ItemServiceContractId__c,
        dmpl__ServiceCampaignId__c,
        dmpl__ItemId__c,
        dmpl__isExecuted__c,
        dmpl__isMandatory__c
        FROM
        dmpl__AssetMaintenance__c where Id= :assetMaintenanceId LIMIT 1];
    }

    public static dmpl__AssetDiagnosticData__c createAssetDiagnosticData(
        Asset asset,
        dmpl__Item__c item){
        return (dmpl__AssetDiagnosticData__c)TestFactory.createSObject(
            new dmpl__AssetDiagnosticData__c(
                dmpl__AssetId__c = asset.Id,
                dmpl__ItemId__c = item.Id,
                dmpl__StandardValue__c='StandardValue',
                dmpl__Remarks__c='Remark',
                dmpl__MinValue__c=10.0,
                dmpl__MaxValue__c=100.0
            ),
       
            true
        );
    }

    public static dmpl__AssetDiagnosticData__c getAssetDiagnosticData(){
        return [SELECT
        Id,
        name,
        dmpl__ItemId__c,
        dmpl__AssetId__c,
        dmpl__StandardValue__c,
        dmpl__Remarks__c,
        dmpl__MinValue__c,
        dmpl__MaxValue__c
        FROM
        dmpl__AssetDiagnosticData__c LIMIT 1];
    }

    public static dmpl__AssetDiagnosticData__c getAssetDiagnosticData(id assetDiagnosticDataId){
        return [SELECT
        Id,
        name,
        dmpl__ItemId__c,
        dmpl__AssetId__c,
        dmpl__StandardValue__c,
        dmpl__Remarks__c,
        dmpl__MinValue__c,
        dmpl__MaxValue__c
        FROM
        dmpl__AssetDiagnosticData__c where Id= :assetDiagnosticDataId LIMIT 1];
    }

    public static dmpl__ShippingAssetLine__c createShippingAssetLine(
        Asset asset,
        dmpl__Item__c item,
        dmpl__ItemLot__c itemLot,
        dmpl__ItemLotType__c itemLotType,
        dmpl__SKU__c sku,
        dmpl__Branch__c branch,
        Account partnerAccount,
        dmpl__Shipment__c shipment,
        dmpl__ShipmentLine__c shipmentLine
    ){
        return (dmpl__ShippingAssetLine__c)TestFactory.createSObject(
            new dmpl__ShippingAssetLine__c(
                dmpl__AssetId__c = asset.Id,
                dmpl__ItemId__c = item.Id,
                dmpl__ItemLotId__c = itemLot.Id,
                dmpl__ItemLotTypeId__c = itemLotType.Id,
                dmpl__SKUId__c = sku.Id,
                dmpl__SellingBranchId__c = branch.Id,
                dmpl__SellingPartnerAccountId__c = partnerAccount.Id,
                dmpl__ShipmentId__c = shipment.Id,
                dmpl__ShipmentLineId__c = shipmentLine.Id,
                dmpl__DeliveryDate__c = Date.today(),
                dmpl__Quantity__c = 10,
                dmpl__LotNumber__c = 'Lot123',
                dmpl__ManufacturingMonth__c = Date.today().month(),
                dmpl__PlantName__c = 'Plant A',
                dmpl__EngineNumber__c = 'ENG12345',
                dmpl__SerialNumber__c = 'SN1234',
                dmpl__Status__c='Shipped'
            ),
            true
        );
    }

    public static dmpl__ShippingAssetLine__c getShippingAssetLine(){
        return [SELECT
        Id,
        name,
        dmpl__AssetId__c,
        dmpl__ItemId__c,
        dmpl__ItemLotId__c,
        dmpl__ItemLotTypeId__c,
        dmpl__SKUId__c,
        dmpl__SellingBranchId__c,
        dmpl__SellingPartnerAccountId__c,
        dmpl__ShipmentId__c,
        dmpl__ShipmentLineId__c,
        dmpl__Quantity__c,
        dmpl__LotNumber__c,
        dmpl__PlantName__c,
        dmpl__EngineNumber__c,
        dmpl__SerialNumber__c,
        dmpl__Status__c
        FROM
        dmpl__ShippingAssetLine__c LIMIT 1];
    }

    public static dmpl__ShippingAssetLine__c getShippingAssetLine(id shippingAssetLineId){
        return [SELECT
        Id,
        name,
        dmpl__AssetId__c,
        dmpl__ItemId__c,
        dmpl__ItemLotId__c,
        dmpl__ItemLotTypeId__c,
        dmpl__SKUId__c,
        dmpl__SellingBranchId__c,
        dmpl__SellingPartnerAccountId__c,
        dmpl__ShipmentId__c,
        dmpl__ShipmentLineId__c,
        dmpl__DeliveryDate__c,
        dmpl__Quantity__c,
        dmpl__LotNumber__c,
        dmpl__ManufacturingMonth__c,
        dmpl__PlantName__c,
        dmpl__EngineNumber__c,
        dmpl__SerialNumber__c,
        dmpl__Status__c
        FROM
        dmpl__ShippingAssetLine__c where Id= :shippingAssetLineId LIMIT 1];
    }

    public static dmpl__ItemServiceContract__c createItemServiceContract(
        dmpl__Item__c item,
        dmpl__SKU__c sku
    ){
        return (dmpl__ItemServiceContract__c) TestFactory.createSObject(
            new dmpl__ItemServiceContract__c(
                dmpl__DateEffectiveFrom__c = date.today(),
                dmpl__DateEffectiveTill__c = date.today() + 7,
                dmpl__ItemId__c = item.Id,
                dmpl__SKUId__c = sku.Id,
                dmpl__PopulateContractLines__c = true
            ),
            true
        );
    }

    public static dmpl__ItemServiceContract__c getItemServiceContract() {
        return [
            SELECT Id, Name,dmpl__GraceUsageDays__c,dmpl__ItemId__c,dmpl__GraceUsageReading__c,dmpl__GraceUsageHours__c,dmpl__MaximumUsageHours__c,dmpl__FromDays__c,dmpl__ToDays__c,dmpl__MinimumUsageHours__c,dmpl__MinimumUsageReading__c,dmpl__MaximumUsageReading__c,dmpl__RestrictAssetContractLinesGeneration__c,
            (select Id,Name,dmpl__ComponentItemId__c,dmpl__Quantity__c from dmpl__ItemServiceContractLines__r)
            FROM dmpl__ItemServiceContract__c
            LIMIT 1
        ];
    }
}