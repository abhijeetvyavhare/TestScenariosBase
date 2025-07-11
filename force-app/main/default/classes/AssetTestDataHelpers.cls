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
        dmpl__MaxValue__c,
        dmpl__ValueType__c
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
        dmpl__MaxValue__c,
        dmpl__ValueType__c
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









    //New Methods
    public static Asset createAsset(
        String assetName,
        Account account,
        dmpl__Item__c item,
        Date saleDate,
        String serialNumber,
        String componentNumber
    ) {
        return (Asset) TestFactory.createSObject(
            new Asset(
                Name = assetName,
                AccountId = account != null ? account.Id : null,
                dmpl__ItemId__c = item != null ? item.Id : null,
                dmpl__SaleDate__c = saleDate,
                SerialNumber = serialNumber,
                dmpl__ComponentNumber__c = componentNumber
            ),
            //'AssetDefaults',
            true
        );
    }

    public static Asset getAssetBySerialNumber(String serialNumber) {
        return [
            SELECT Id, Name, AccountId, dmpl__ItemId__c, dmpl__SaleDate__c, SerialNumber, dmpl__ComponentNumber__c
            FROM Asset
            WHERE SerialNumber = :serialNumber
            LIMIT 1
        ];
    }

    public static Asset getAssetByComponentNumber(String componentNumber) {
        return [
            SELECT Id, Name, AccountId, dmpl__ItemId__c, dmpl__SaleDate__c, SerialNumber, dmpl__ComponentNumber__c
            FROM Asset
            WHERE dmpl__ComponentNumber__c = :componentNumber
            LIMIT 1
        ];
    }

    public static dmpl__AssetAccountHistory__c createAssetAccountHistory(
        Asset asset,
        Account account,
        String externalId,
        Decimal usageReading,
        Decimal usageHour,
        Date startDate,
        Date endDate,
        String address
    ) {
        return (dmpl__AssetAccountHistory__c) TestFactory.createSObject(
            new dmpl__AssetAccountHistory__c(
                dmpl__InstallbaseId__c = asset != null ? asset.Id : null,
                dmpl__AccountId__c = account != null ? account.Id : null,
                dmpl__ExternalId__c = externalId,
                dmpl__AtUsageReading__c = usageReading,
                dmpl__AtUsageHour__c = usageHour,
                dmpl__OwnershipStartDate__c = startDate,
                dmpl__OwnershipEnddate__c = endDate,
                dmpl__Address__c = address
            ),
            //'AssetAccountHistoryDefaults',
            true
        );
    }

    public static dmpl__AssetAccountHistory__c getAssetAccountHistoryByAsset(Id assetId) {
        return [
            SELECT Id, Name, dmpl__InstallbaseId__c, dmpl__AccountId__c,
                   dmpl__AtUsageReading__c, dmpl__AtUsageHour__c,
                   dmpl__OwnershipStartDate__c, dmpl__OwnershipEnddate__c, dmpl__ExternalId__c
            FROM dmpl__AssetAccountHistory__c
            WHERE dmpl__InstallbaseId__c = :assetId
            LIMIT 1
        ];
    }

    // Create method for Asset Diagnostic Data
    public static dmpl__AssetDiagnosticData__c createAssetDiagnosticData(
        Asset asset,
        dmpl__Item__c item,
        Id itemHealthCheckId,
        String externalId,
        String valueType,
        String condition,
        Decimal minValue,
        Decimal maxValue,
        Decimal lastValue,
        String standardValue,
        String remarks
    ) {
        return (dmpl__AssetDiagnosticData__c) TestFactory.createSObject(
            new dmpl__AssetDiagnosticData__c(
                dmpl__AssetId__c = asset != null ? asset.Id : null,
                dmpl__ItemId__c = item != null ? item.Id : null,
                dmpl__ItemHealthCheckId__c = itemHealthCheckId,
                dmpl__ExternalId__c = externalId != null ? externalId : 'EXT-' + String.valueOf(Math.random()),
                dmpl__ValueType__c = valueType != null ? valueType : 'RAG',
                dmpl__Condition__c = condition != null ? condition : 'Green',
                dmpl__MinValue__c = minValue != null ? minValue : 0,
                dmpl__MaxValue__c = maxValue != null ? maxValue : 100,
                dmpl__LastValue__c = lastValue != null ? lastValue : 50,
                dmpl__StandardValue__c = standardValue != null ? standardValue : '50',
                dmpl__Remarks__c = remarks
            ),
            true
        );
    }

    public static dmpl__AssetDiagnosticData__c getAssetDiagnosticDataByAsset(Id assetId) {
        return [
            SELECT Id, Name, dmpl__AssetId__c, dmpl__ItemId__c, dmpl__ValueType__c,
                   dmpl__Condition__c, dmpl__MinValue__c, dmpl__MaxValue__c,
                   dmpl__LastValue__c, dmpl__StandardValue__c, dmpl__Remarks__c,
                   dmpl__ExternalId__c
            FROM dmpl__AssetDiagnosticData__c
            WHERE dmpl__AssetId__c = :assetId
            LIMIT 1
        ];
    }

    // CREATE METHOD
    public static dmpl__AssetMaintenance__c createAssetMaintenance(
        Asset asset,
        Account partnerAccount,
        Id branchId,
        dmpl__Item__c item,
        Id repairOrderId,
        Id repairOrderLineId,
        Id itemServiceContractId,
        Id serviceCampaignId,
        Id serviceCampaignItemId,
        Id serviceCampaignMemberId,
        String campaignBatchInstanceId,
        Boolean isMandatory,
        Decimal quantity
    ) {
        return (dmpl__AssetMaintenance__c) TestFactory.createSObject(
            new dmpl__AssetMaintenance__c(
                dmpl__AssetId__c = asset != null ? asset.Id : null,
                dmpl__PartnerAccountId__c = partnerAccount != null ? partnerAccount.Id : null,
                dmpl__BranchId__c = branchId,
                dmpl__ItemId__c = item != null ? item.Id : null,
                dmpl__RepairOrderId__c = repairOrderId,
                dmpl__RepairOrderLineId__c = repairOrderLineId,
                dmpl__ItemServiceContractId__c = itemServiceContractId,
                dmpl__ServiceCampaignId__c = serviceCampaignId,
                dmpl__ServiceCampaignItemId__c = serviceCampaignItemId,
                dmpl__ServiceCampaignMemberId__c = serviceCampaignMemberId,
                dmpl__ServiceCampaignBatchInstanceId__c = campaignBatchInstanceId,
                dmpl__IsMandatory__c = isMandatory,
                dmpl__Quantity__c = quantity
            ),
            //'AssetMaintenanceDefaults',
            true
        );
    }

    // GET METHOD BY ASSET
    public static dmpl__AssetMaintenance__c getAssetMaintenanceByAsset(Id assetId) {
        return [
            SELECT Id, Name, dmpl__AssetId__c, dmpl__ItemId__c, dmpl__PartnerAccountId__c,
                   dmpl__BranchId__c, dmpl__IsMandatory__c, dmpl__Quantity__c,
                   dmpl__ServiceCampaignId__c, dmpl__ServiceCampaignItemId__c,
                   dmpl__ServiceCampaignMemberId__c
            FROM dmpl__AssetMaintenance__c
            WHERE dmpl__AssetId__c = :assetId
            LIMIT 1
        ];
    }

    // GET METHOD BY SERVICE CAMPAIGN
    public static List<dmpl__AssetMaintenance__c> getByServiceCampaign(Id campaignId) {
        return [
            SELECT Id, Name, dmpl__ServiceCampaignId__c
            FROM dmpl__AssetMaintenance__c
            WHERE dmpl__ServiceCampaignId__c = :campaignId
        ];
    }

    // GET METHOD BY Service Campaign Member
    public static List<dmpl__AssetMaintenance__c> getByCampaignMember(Id campaignMemberId) {
        return [
            SELECT Id, Name, dmpl__ServiceCampaignMemberId__c
            FROM dmpl__AssetMaintenance__c
            WHERE dmpl__ServiceCampaignMemberId__c = :campaignMemberId
        ];
    }

    // CREATE
    public static dmpl__AssetServiceContract__c createAssetServiceContract(
        Asset asset,
        Account billingAccount,
        dmpl__Item__c item,
        Id serviceContractId,
        String externalId,
        Date dueDate,
        Decimal dueInHours,
        Decimal graceUsageDays,
        Decimal graceUsageHours,
        Decimal graceUsageReading,
        Date activatedDate,
        Date validTillDate,
        Decimal validTillHours,
        Decimal validTillUsageReading,
        Boolean isUtilized
    ) {
        return (dmpl__AssetServiceContract__c) TestFactory.createSObject(
            new dmpl__AssetServiceContract__c(
                dmpl__AssetId__c = asset != null ? asset.Id : null,
                dmpl__BillingAccountId__c = billingAccount != null ? billingAccount.Id : null,
                dmpl__ItemId__c = item != null ? item.Id : null,
                dmpl__ItemServiceContractId__c = serviceContractId,
                dmpl__ExternalId__c = externalId != null ? externalId : 'EXT-' + String.valueOf(Math.random()),
                dmpl__DueDate__c = dueDate != null ? dueDate : Date.today().addDays(30),
                dmpl__DueInHours__c = dueInHours != null ? dueInHours : 10,
                dmpl__GraceUsageDays__c = graceUsageDays != null ? graceUsageDays : 5,
                dmpl__GraceUsageHours__c = graceUsageHours != null ? graceUsageHours : 5,
                dmpl__GraceUsageReading__c = graceUsageReading != null ? graceUsageReading : 5,
                dmpl__ActivatedDate__c = activatedDate != null ? activatedDate : Date.today(),
                dmpl__ValidTillDate__c = validTillDate != null ? validTillDate : Date.today().addMonths(6),
                dmpl__ValidTillHours__c = validTillHours != null ? validTillHours : 100,
                dmpl__ValidTillUsageReading__c = validTillUsageReading != null ? validTillUsageReading : 100,
                dmpl__IsUtilized__c = isUtilized != null ? isUtilized : false
            ),
            true
        );
    }

    // GET BY SERVICE CONTRACT
    public static List<dmpl__AssetServiceContract__c> getAssetServiceContractByServiceContract(Id serviceContractId) {
        return [
            SELECT Id, Name, dmpl__ItemServiceContractId__c, dmpl__ItemId__c, dmpl__AssetId__c
            FROM dmpl__AssetServiceContract__c
            WHERE dmpl__ItemServiceContractId__c = :serviceContractId
        ];
    }

    // GET BY ITEM
    public static List<dmpl__AssetServiceContract__c> getAssetServiceContractByItem(Id itemId) {
        return [
            SELECT Id, Name, dmpl__ItemId__c, dmpl__AssetId__c, dmpl__ItemServiceContractId__c
            FROM dmpl__AssetServiceContract__c
            WHERE dmpl__ItemId__c = :itemId
        ];
    }

    // GET BY EXTERNAL ID
    public static dmpl__AssetServiceContract__c getByExternalId(String externalId) {
        return [
            SELECT Id, Name, dmpl__ExternalId__c
            FROM dmpl__AssetServiceContract__c
            WHERE dmpl__ExternalId__c = :externalId
            LIMIT 1
        ];
    }

    public static ServiceContract createServiceContract(
        Account account,
        String contractName,
        Date startDate,
        Date endDate,
        String status
    ) {
        return (ServiceContract) TestFactory.createSObject(
            new ServiceContract(
                Name = contractName,
                AccountId = account != null ? account.Id : null,
                StartDate = startDate != null ? startDate : Date.today(),
                EndDate = endDate != null ? endDate : Date.today().addMonths(6)
                //Status = status != null ? status : 'Draft'
            ),
            true 
        );
    }

    public static ServiceContract getServiceContractByName(String name) {
        return [
            SELECT Id, Name, AccountId, StartDate, EndDate, Status
            FROM ServiceContract
            WHERE Name = :name
            LIMIT 1
            ALL ROWS
        ];
    }

    public static List<ServiceContract> getServiceContractsByAccount(Id accountId) {
        return [
            SELECT Id, Name, Status, StartDate, EndDate
            FROM ServiceContract
            WHERE AccountId = :accountId
            ALL ROWS
        ];
    }

   public static dmpl__ProductHealthCheck__c createProductHealthCheck(
        Account partnerAccount,
        dmpl__Branch__c branch,
        Account customer,
        Asset asset,
        String externalId,
        String name 
    ) {
        return (dmpl__ProductHealthCheck__c) TestFactory.createSObject(
            new dmpl__ProductHealthCheck__c(
                dmpl__PartnerAccountId__c = partnerAccount != null ? partnerAccount.Id : null,
                dmpl__BranchId__c = branch != null ? branch.Id : null,
                dmpl__AccountId__c = customer != null ? customer.Id : null,
                dmpl__AssetId__c = asset != null ? asset.Id : null,
                dmpl__ExternalId__c = externalId
            ),
            true
        );
    }

    // Asset Service contract line
    public static dmpl__AssetServiceContractLine__c createAssetServiceContractLine(
        dmpl__Item__c item,
        dmpl__AssetServiceContract__c assetServiceContract,
        dmpl__Item__c componentItem,
        Decimal quantity,
        Decimal utilizedQuantity
    ) {
        return (dmpl__AssetServiceContractLine__c) TestFactory.createSObject(
            new dmpl__AssetServiceContractLine__c(
                dmpl__AssetServiceContractId__c = assetServiceContract != null ? assetServiceContract.Id : null,
                dmpl__ComponentItemId__c = componentItem != null ? componentItem.Id : null,
                dmpl__Quantity__c = quantity != null ? quantity : 1,
                dmpl__UtilizedQuantity__c = utilizedQuantity != null ? utilizedQuantity : 0
            ),
            true
        );
    }
    public static Asset createAsset(String name, Id accountId, Id itemId) {
        return (Asset) TestFactory.createSObject(
            new Asset(
                Name = name,
                AccountId = accountId,
                dmpl__ItemId__c = itemId,
                dmpl__SaleDate__c = Date.newInstance(2025, 1, 6)
            ),
            // 'AssetDefaults',
            true
        );
    }
    public static Asset getAsset(String name) {
        return [
            SELECT Id, Name, AccountId, dmpl__ItemId__c, dmpl__SaleDate__c
            FROM Asset 
            WHERE Name = :name
            LIMIT 1
        ];
    }

}