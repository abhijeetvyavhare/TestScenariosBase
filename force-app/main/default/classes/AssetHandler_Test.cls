@isTest
public with sharing class AssetHandler_Test {
    @TestSetup
    static void createRequiredData(){
        dmpl__AccountGroup__c accountGroup=TestDataHelpers.createAccountGroup();
        Account customerAccount = TestDataHelpers.createCustomerAccount();
        Account account=TestDataHelpers.createAccount(accountGroup);
        Account partnerAccount=TestDataHelpers.createPartnerAccount();
        Account supplierAccount=TestDataHelpers.createSupplierAccount();
        dmpl__Branch__c branch=TestDataHelpers.createBranch(partnerAccount);
        dmpl__Item__c item = TestDataHelpers.createItem();
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.createTaxGroup(partnerAccount, branch);
        dmpl__Resource__c resource = TestDataHelpers.createResource(partnerAccount, branch);
        dmpl__StorageLocation__c storageLocation = TestDataHelpers.createStorageLocation(branch);
        dmpl__SKU__c sku = TestDataHelpers.createSKU(item);
        dmpl__ItemLot__c itemLot = TestDataHelpers.createItemLot(branch,item,sku,storageLocation);
        dmpl__ItemLotType__c itemLotType = TestDataHelpers.CreateItemLotType(item);
        dmpl__PriceList__c priceList = TestDataHelpers.createPriceList(partnerAccount, branch);
 
        Asset asset=AssetTestDataHelpers.CreateAsset(
            account, 
            branch, 
            item, 
            itemLot, 
            sku
        );
        dmpl__Quote__c serviceEstimate = QuoteTestDataHelpers.CreateServiceEstimate(
            branch,
            customerAccount,
            priceList,
            asset,
            null,
            item
        );
 
        dmpl__RepairOrder__c repairOrder=RepairOrderTestDataHelpers.createRepairOrder(
            item,
            branch,
            asset,
            serviceEstimate,
            customerAccount,
            resource
        );
 
        dmpl__ServiceLead__c ServiceLead=ServiceLeadTestDataHelpers.createServiceLead(
            branch,
            customerAccount,
            resource
        );
 
        dmpl__ItemServiceContract__c ItemServiceContract=AssetTestDataHelpers.createItemServiceContract(
            item,
            sku
        );
 
        dmpl__ServiceCampaign__c serviceCampaign=CampaignTestDataHelpers.CreateServiceCompaign(
            ItemServiceContract,
            ServiceLead,
            item
        );
        dmpl__AssetServiceContract__c assetServiceContract = AssetTestDataHelpers.createAssetServiceContract(
            asset, 
            item
        );
        dmpl__AssetServiceContractLine__c assetServiceContractLine = AssetTestDataHelpers.createAssetServiceContractLine(
            assetServiceContract, 
            item
        );
        dmpl__AssetMaintenance__c assetMaintenance = AssetTestDataHelpers.createAssetMaintenance(
            asset,
            partnerAccount,
            branch,
            repairOrder,
            serviceCampaign,
            itemServiceContract,
            item
        );
 
        dmpl__AssetDiagnosticData__c assetDiagnosticData = AssetTestDataHelpers.createAssetDiagnosticData(
            asset, 
            item
        );
 
        dmpl__PurchaseOrder__c purchaseOrder=PurchaseOrderTestDataHelpers.createPurchaseOrder(
            branch,
            supplierAccount
        );
 
        dmpl__PurchaseRequisition__c PurchaseRequisition=PurchaseOrderTestDataHelpers.createPurchaseRequisition(
            branch, 
            supplierAccount
        );
 
        dmpl__PurchaseOrderLine__c purchaseOrderLine=PurchaseOrderTestDataHelpers.createPurchaseOrderLine(
            item,
            sku, 
            purchaseOrder, 
            taxGroup
        );
        dmpl__Shipment__c shipment = ShipmentTestDataHelper.createShipment(
            supplierAccount, 
            branch, 
            purchaseOrder
        );
        dmpl__ShipmentLine__c shipmentLine = ShipmentTestDataHelper.createShipmentLine(
            item, 
            shipment, 
            sku, 
            purchaseOrderLine
        );
 
        dmpl__ShippingAssetLine__c shippingAssetLine = AssetTestDataHelpers.createShippingAssetLine(
            asset,
            item,
            itemLot,
            itemLotType,
            sku,
            branch,
            partnerAccount,
            shipment,
            shipmentLine
        );
    }
 
    @isTest
    static void createAssetPositive() {
        Asset asset = AssetTestDataHelpers.getAsset();
        if(asset != null){
            System.assertNotEquals(asset, null, 'Expected asset to be created.');
        }
        System.assertNotEquals(asset.name, null, 'Name should not be null');
        System.assertEquals(asset.IsPDIDone__c,true,'IsPDIDone__c should be true');
    }
 
    @isTest
    static void updateAssetPositive() {
        Asset asset= AssetTestDataHelpers.getAsset();
        if(asset!=null){
            System.assertNotEquals(asset, null, 'Expected asset to be created before update.');
            asset.IsPDIDone__c = false;
            asset.dmpl__LastServiceBranchId__c = null;
            asset.RegistrationNumber__c = 'Axb300';
            update asset;
        }
        Asset updatedAsset=AssetTestDataHelpers.getAsset(asset.Id);
        if(updatedAsset != null){
            System.assertNotEquals(updatedAsset, null, 'Expected asset to be updated.');
            System.assertEquals(updatedAsset.IsPDIDone__c, false, 'Expected asset.IsPDIDone__c to be false');
            System.assertEquals(updatedAsset.RegistrationNumber__c, 'Axb300', 'Expected asset.RegistrationNumber__c to be Axb300');
        }
    }
 
    @isTest
    static void deleteAssetPositive() {
        Asset asset = AssetTestDataHelpers.getAsset();
        System.assertNotEquals(asset, null, 'Expected asset to be created before delete.');
        Asset deletedAsset=null;
        delete asset;
        try{
            deletedAsset=AssetTestDataHelpers.getAsset(asset.Id);
        }
        catch(Exception e) {
            deletedAsset=null;
        }
        System.assertEquals(null, deletedAsset, 'Expected asset to be deleted.');
    }
 
    @isTest
    static void createAssetServiceContractPositive() {
        dmpl__AssetServiceContract__c assetServiceContract = AssetTestDataHelpers.getAssetServiceContract();
        if(assetServiceContract != null){
            System.assertNotEquals(assetServiceContract, null, 'Expected assetServiceContract to be created.');
        }
        System.assertNotEquals(assetServiceContract.name, null, 'Name should not be null');
    }
 
    @isTest
    static void updateAssetServiceContractPositive() {
        dmpl__AssetServiceContract__c assetServiceContract = AssetTestDataHelpers.getAssetServiceContract();
        if(assetServiceContract != null){
            System.assertNotEquals(assetServiceContract, null, 'Expected assetServiceContract to be created before update.');
            assetServiceContract.dmpl__ActivatedDate__c = Datetime.now().addDays(30).Date();
            assetServiceContract.dmpl__ValidtillDate__c = Datetime.now().addDays(365).Date();
            assetServiceContract.dmpl__DueDate__c = Datetime.now().addDays(365).Date();
            update assetServiceContract;
        }
 
        dmpl__AssetServiceContract__c updatedAssetServiceContract=AssetTestDataHelpers.getAssetServiceContract(assetServiceContract.Id);
        if(updatedAssetServiceContract != null){
            System.assertNotEquals(updatedAssetServiceContract, null, 'Expected assetServiceContract to be updated.');
        }
        System.assertEquals(Datetime.now().addDays(30).Date(), updatedAssetServiceContract.dmpl__ActivatedDate__c, 'ActivatedDate should be updated');
        System.assertEquals(Datetime.now().addDays(365).Date(), updatedAssetServiceContract.dmpl__ValidtillDate__c, 'ValidtillDate should be updated');
        System.assertEquals(Datetime.now().addDays(365).Date(), updatedAssetServiceContract.dmpl__DueDate__c, 'DueDate should be updated');
    }
 
    @isTest
    static void deleteAssetServiceContractPositive() {
        dmpl__AssetServiceContract__c assetServiceContract = AssetTestDataHelpers.getAssetServiceContract();
        System.assertNotEquals(assetServiceContract, null, 'Expected assetServiceContract to be created before deleted.');
        dmpl__AssetServiceContract__c deletedAssetServiceContract=null;
        delete assetServiceContract;
        try{
            deletedAssetServiceContract=AssetTestDataHelpers.getAssetServiceContract(assetServiceContract.Id);
        }
        catch(Exception e){
            deletedAssetServiceContract=null;
        }
        System.assertEquals(null, deletedAssetServiceContract, 'Expected assetServiceContract to be deleted.');
    }
 
    @isTest
    static void createAssetServiceContractLinePositive() {
        dmpl__AssetServiceContractLine__c assetServiceContractLine = AssetTestDataHelpers.getAssetServiceContractLine();
        if(assetServiceContractLine != null){
            System.assertNotEquals(assetServiceContractLine, null, 'Expected assetServiceContractLine to be created.');
        }
        System.assertNotEquals(assetServiceContractLine.name, null, 'Name should not be null');
        System.assertNotEquals(assetServiceContractLine.dmpl__AssetServiceContractId__c, null, 'Expected dmpl__AssetServiceContractId__c to be set.');
        System.assertNotEquals(assetServiceContractLine.dmpl__ComponentItemId__c, null, 'Expected dmpl__ItemId__c to be set.');
        System.assertEquals(10, assetServiceContractLine.dmpl__Quantity__c, 'Expected dmpl__Quantity__c to be 10');
        System.assertEquals(5, assetServiceContractLine.dmpl__UtilizedQuantity__c, 'Expected dmpl__UtilizedQuantity__c to be 5');
        System.assertEquals(5, assetServiceContractLine.dmpl__PendingQuantity__c, 'Expected dmpl__PendingQuantity__c to be 5');
    }
 
    @isTest
    static void updateAssetServiceContractLinePositive() {
        dmpl__AssetServiceContractLine__c assetServiceContractLine = AssetTestDataHelpers.getAssetServiceContractLine();
        if(assetServiceContractLine != null){
            System.assertNotEquals(assetServiceContractLine, null, 'Expected assetServiceContractLine to be created before update.');
            assetServiceContractLine.dmpl__Quantity__c = 20;
            assetServiceContractLine.dmpl__UtilizedQuantity__c = 10;
            update assetServiceContractLine;
        }
 
        dmpl__AssetServiceContractLine__c updatedAssetServiceContractLine=AssetTestDataHelpers.getAssetServiceContractLine(assetServiceContractLine.Id);
        if(updatedAssetServiceContractLine != null){
            System.assertNotEquals(updatedAssetServiceContractLine, null, 'Expected assetServiceContractLine to be updated.');
        }
        System.assertEquals(20, updatedAssetServiceContractLine.dmpl__Quantity__c, 'Expected dmpl__Quantity__c to be updated to 20');
        System.assertEquals(10, updatedAssetServiceContractLine.dmpl__UtilizedQuantity__c, 'Expected dmpl__UtilizedQuantity__c to be updated to 10');
        System.assertEquals(10, updatedAssetServiceContractLine.dmpl__PendingQuantity__c, 'Expected dmpl__PendingQuantity__c to be updated to 10');
    }
 
    @isTest
    static void deleteAssetServiceContractLinePositive() {
        dmpl__AssetServiceContractLine__c assetServiceContractLine = AssetTestDataHelpers.getAssetServiceContractLine();
        System.assertNotEquals(assetServiceContractLine, null, 'Expected assetServiceContractLine to be created before delete.');
        dmpl__AssetServiceContractLine__c deletedAssetServiceContractLine=null;
        delete assetServiceContractLine;
        try{
            deletedAssetServiceContractLine=AssetTestDataHelpers.getAssetServiceContractLine(assetServiceContractLine.Id);
        }
        catch(Exception e) {
            deletedAssetServiceContractLine=null;
        }
        System.assertEquals(null, deletedAssetServiceContractLine, 'Expected assetServiceContractLine to be deleted.');
    }
 
    @isTest
    static void createAssetMaintenancePositive() {
        dmpl__AssetMaintenance__c assetMaintenance = AssetTestDataHelpers.getAssetMaintenance();
        if(assetMaintenance != null){
            System.assertNotEquals(assetMaintenance, null, 'Expected assetMaintenance to be created.');
        }
        System.assertEquals(false, assetMaintenance.dmpl__isExecuted__c, 'Expected dmpl__isExecuted__c to be false');
        System.assertEquals(false, assetMaintenance.dmpl__isMandatory__c, 'Expected dmpl__isMandatory__c to be false');
        System.assertNotEquals(assetMaintenance.dmpl__AssetId__c, null, 'Expected dmpl__Asset__c to be set.');
        System.assertNotEquals(assetMaintenance.dmpl__BranchId__c, null, 'Expected dmpl__Branch__c to be set.');
        System.assertNotEquals(assetMaintenance.dmpl__PartnerAccountId__c, null, 'Expected dmpl__PartnerAccount__c to be set.');
        System.assertNotEquals(assetMaintenance.dmpl__RepairOrderId__c, null, 'Expected dmpl__RepairOrder__c to be set.');
        System.assertNotEquals(assetMaintenance.dmpl__ServiceCampaignId__c, null, 'Expected dmpl__ServiceCampaign__c to be set.');
        System.assertNotEquals(assetMaintenance.dmpl__ItemServiceContractId__c, null, 'Expected dmpl__ItemServiceContract__c to be set.');
    }
 
    @isTest
    static void updateAssetMaintenancePositive() {
        dmpl__AssetMaintenance__c assetMaintenance = AssetTestDataHelpers.getAssetMaintenance();
        if(assetMaintenance != null){
            System.assertNotEquals(assetMaintenance, null, 'Expected assetMaintenance to be created before update.');
            assetMaintenance.dmpl__isExecuted__c = true;
            assetMaintenance.dmpl__isMandatory__c = true;
            update assetMaintenance;
        }
 
        dmpl__AssetMaintenance__c updatedAssetMaintenance = AssetTestDataHelpers.getAssetMaintenance(assetMaintenance.Id);
        if(updatedAssetMaintenance != null){
            System.assertNotEquals(updatedAssetMaintenance, null, 'Expected assetMaintenance to be updated.');
        }
        System.assertEquals(true, updatedAssetMaintenance.dmpl__isExecuted__c, 'Expected dmpl__isExecuted__c to be true');
        System.assertEquals(true, updatedAssetMaintenance.dmpl__isMandatory__c, 'Expected dmpl__isMandatory__c to be true');
    }
 
    @isTest
    static void deleteAssetMaintenancePositive() {
        dmpl__AssetMaintenance__c assetMaintenance = AssetTestDataHelpers.getAssetMaintenance();
        System.assertNotEquals(assetMaintenance, null, 'Expected asset to be created before delete.');
        dmpl__AssetMaintenance__c deletedAssetMaintenance = null;
        delete assetMaintenance;
        try{
            deletedAssetMaintenance = AssetTestDataHelpers.getAssetMaintenance(assetMaintenance.Id);
        }
        catch(Exception e) {
            deletedAssetMaintenance = null;
        }
        System.assertEquals(null, deletedAssetMaintenance, 'Expected assetMaintenance to be deleted.');
    }
 
    @isTest
    static void createShippingAssetLinePositive(){
        dmpl__ShippingAssetLine__c shippingAssetLine=AssetTestDataHelpers.getShippingAssetLine();
        if(shippingAssetLine != null){
            System.assertNotEquals(shippingAssetLine, null, 'Expected shippingAssetLine to be created.');
        }
        System.assertNotEquals(shippingAssetLine.name, null, 'Name should not be null');
        System.assertNotEquals(shippingAssetLine.dmpl__AssetId__c, null, 'Expected dmpl__AssetId__c to be set.');
        System.assertNotEquals(shippingAssetLine.dmpl__ItemId__c, null, 'Expected dmpl__ItemId__c to be set.');
        System.assertNotEquals(shippingAssetLine.dmpl__ItemLotId__c, null, 'Expected dmpl__ItemLotId__c to be set.');
        System.assertNotEquals(shippingAssetLine.dmpl__ItemLotTypeId__c, null, 'Expected dmpl__ItemLotTypeId__c to be set.');
        System.assertNotEquals(shippingAssetLine.dmpl__SKUId__c, null, 'Expected dmpl__SKUId__c to be set.');
        System.assertNotEquals(shippingAssetLine.dmpl__SellingBranchId__c, null, 'Expected dmpl__SellingBranchId__c to be set.');
        System.assertNotEquals(shippingAssetLine.dmpl__SellingPartnerAccountId__c, null, 'Expected dmpl__SellingPartnerAccountId__c to be set.');
        System.assertNotEquals(shippingAssetLine.dmpl__ShipmentId__c, null, 'Expected dmpl__ShipmentId__c to be set.');
        System.assertNotEquals(shippingAssetLine.dmpl__ShipmentLineId__c, null, 'Expected dmpl__ShipmentLineId__c to be set.');
        System.assertEquals(10, shippingAssetLine.dmpl__Quantity__c, 'Expected dmpl__Quantity__c to be 10');
        System.assertEquals('Lot123', shippingAssetLine.dmpl__LotNumber__c, 'Expected dmpl__LotNumber__c to be Lot123');
        System.assertEquals('SN1234', shippingAssetLine.dmpl__SerialNumber__c, 'Expected dmpl__SerialNumber__c to be SN1234');
        System.assertEquals('Shipped', shippingAssetLine.dmpl__Status__c, 'Expected dmpl__Status__c to be Shipped');
        System.assertEquals('Plant A', shippingAssetLine.dmpl__PlantName__c, 'Expected dmpl__PlantName__c to be Plant A');
        System.assertEquals('ENG12345', shippingAssetLine.dmpl__EngineNumber__c, 'Expected dmpl__EngineNumber__c to be ENG12345');
    }
 
    @isTest
    static void updateShippingAssetLinePositive(){
        dmpl__ShippingAssetLine__c shippingAssetLine=AssetTestDataHelpers.getShippingAssetLine();
        if(shippingAssetLine != null){
            System.assertNotEquals(shippingAssetLine, null, 'Expected shippingAssetLine to be created before update.');
            shippingAssetLine.dmpl__Quantity__c = 20;
            shippingAssetLine.dmpl__LotNumber__c = 'UpdatedLot123';
            shippingAssetLine.dmpl__SerialNumber__c = 'UpdatedSN1234';
            shippingAssetLine.dmpl__Status__c = 'Installed';
            shippingAssetLine.dmpl__PlantName__c = 'UpdatedPlant A';
            shippingAssetLine.dmpl__EngineNumber__c = 'UpdatedENG12345';
            update shippingAssetLine;
        }
 
        dmpl__ShippingAssetLine__c updatedShippingAssetLine=AssetTestDataHelpers.getShippingAssetLine(shippingAssetLine.Id);
        if(updatedShippingAssetLine != null){
            System.assertNotEquals(updatedShippingAssetLine, null, 'Expected shippingAssetLine to be updated.');
        }
        System.assertEquals(20, updatedShippingAssetLine.dmpl__Quantity__c, 'Expected dmpl__Quantity__c to be updated to 20');
        System.assertEquals('UpdatedLot123', updatedShippingAssetLine.dmpl__LotNumber__c, 'Expected dmpl__LotNumber__c to be UpdatedLot123');
        System.assertEquals('UpdatedSN1234', updatedShippingAssetLine.dmpl__SerialNumber__c, 'Expected dmpl__SerialNumber__c to be UpdatedSN1234');
        System.assertEquals('Installed', updatedShippingAssetLine.dmpl__Status__c, 'Expected dmpl__Status__c to be Installed');
        System.assertEquals('UpdatedPlant A', updatedShippingAssetLine.dmpl__PlantName__c, 'Expected dmpl__PlantName__c to be UpdatedPlant A');
        System.assertEquals('UpdatedENG12345', updatedShippingAssetLine.dmpl__EngineNumber__c, 'Expected dmpl__EngineNumber__c to be UpdatedENG12345');
    }
 
    @isTest
    static void deleteShippingAssetLinePositive(){
        dmpl__ShippingAssetLine__c shippingAssetLine=AssetTestDataHelpers.getShippingAssetLine();
        System.assertNotEquals(shippingAssetLine, null, 'Expected shippingAssetLine to be created before delete.');
        dmpl__ShippingAssetLine__c deletedShippingAssetLine=null;
        delete shippingAssetLine;
        try{
            deletedShippingAssetLine=AssetTestDataHelpers.getShippingAssetLine(shippingAssetLine.Id);
        }
        catch(Exception e) {
            deletedShippingAssetLine=null;
        }
        System.assertEquals(null, deletedShippingAssetLine, 'Expected shippingAssetLine to be deleted.');
    }
 
    @isTest
    static void createAssetDiagnosticDataPositive() {
        dmpl__AssetDiagnosticData__c assetDiagnosticData = AssetTestDataHelpers.getAssetDiagnosticData();
        if(assetDiagnosticData != null){
            System.assertNotEquals(assetDiagnosticData, null, 'Expected assetDiagnosticData to be created.');
        }
        System.assertNotEquals(assetDiagnosticData.name, null, 'Name should not be null');
        System.assertNotEquals(assetDiagnosticData.dmpl__AssetId__c, null, 'Expected dmpl__AssetId__c to be set.');
        System.assertNotEquals(assetDiagnosticData.dmpl__ItemId__c, null, 'Expected dmpl__ItemId__c to be set.');
        System.assertEquals('StandardValue', assetDiagnosticData.dmpl__StandardValue__c, 'Expected dmpl__StandardValue__c to be StandardValue');
        System.assertEquals('Remark', assetDiagnosticData.dmpl__Remarks__c, 'Expected dmpl__Remarks__c to be Remark');
        System.assertEquals(10.0, assetDiagnosticData.dmpl__MinValue__c, 'Expected dmpl__MinValue__c to be 10.0');
        System.assertEquals(100.0, assetDiagnosticData.dmpl__MaxValue__c, 'Expected dmpl__MaxValue__c to be 100.0');
    }
 
    @isTest
    static void updateAssetDiagnosticDataPositive() {
        dmpl__AssetDiagnosticData__c assetDiagnosticData = AssetTestDataHelpers.getAssetDiagnosticData();
        if(assetDiagnosticData != null){
            System.assertNotEquals(assetDiagnosticData, null, 'Expected assetDiagnosticData to be created before update.');
            assetDiagnosticData.dmpl__StandardValue__c = 'UpdatedStandardValue';
            assetDiagnosticData.dmpl__Remarks__c = 'UpdatedRemark';
            assetDiagnosticData.dmpl__MinValue__c = 20.0;
            assetDiagnosticData.dmpl__MaxValue__c = 200.0;
            update assetDiagnosticData;
        }
 
        dmpl__AssetDiagnosticData__c updatedAssetDiagnosticData=AssetTestDataHelpers.getAssetDiagnosticData(assetDiagnosticData.Id);
        if(updatedAssetDiagnosticData != null){
            System.assertNotEquals(updatedAssetDiagnosticData, null, 'Expected assetDiagnosticData to be updated.');
        }
        System.assertEquals('UpdatedStandardValue', updatedAssetDiagnosticData.dmpl__StandardValue__c, 'Expected dmpl__StandardValue__c to be UpdatedStandardValue');
        System.assertEquals('UpdatedRemark', updatedAssetDiagnosticData.dmpl__Remarks__c, 'Expected dmpl__Remarks__c to be UpdatedRemark');
        System.assertEquals(20.0, updatedAssetDiagnosticData.dmpl__MinValue__c, 'Expected dmpl__MinValue__c to be updated to 20.0');
        System.assertEquals(200.0, updatedAssetDiagnosticData.dmpl__MaxValue__c, 'Expected dmpl__MaxValue__c to be updated to 200.0');
    }
 
    @isTest
    static void deleteAssetDiagnosticDataPositive() {
        dmpl__AssetDiagnosticData__c assetDiagnosticData = AssetTestDataHelpers.getAssetDiagnosticData();
        System.assertNotEquals(assetDiagnosticData, null, 'Expected assetDiagnosticData to be created before delete.');
        dmpl__AssetDiagnosticData__c deletedAssetDiagnosticData=null;
        delete assetDiagnosticData;
        try{
            deletedAssetDiagnosticData=AssetTestDataHelpers.getAssetDiagnosticData(assetDiagnosticData.Id);
        }
        catch(Exception e) {
            deletedAssetDiagnosticData=null;
        }
        System.assertEquals(null, deletedAssetDiagnosticData, 'Expected assetDiagnosticData to be deleted.');
    }
}