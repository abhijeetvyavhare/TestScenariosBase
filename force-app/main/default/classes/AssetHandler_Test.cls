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
        
        
        //New Data
        Account partnerAccount1 = TestDataHelpers.createPartnerAccount(
            'Partner 1',
        true,
        true,
        false,
        true,
        '123 Billing Street',
        'Pune',
        'Maharashtra',
        'India',
        '411001',
        '456 Shipping Street',
        'Pune',
        'Maharashtra',
        'India',
        '411001',
        '9876543210'
            );
        dmpl__Branch__c branch1 = TestDataHelpers.createBranch('Branch 1', partnerAccount1.Id, true, true, false, true);
        Account customerAccount1 = TestDataHelpers.createCustomerAccount(
            'Customer 1',
        true,
        false,
        false,
        true,
        'MG Road',
        'Pune',
        'Maharashtra',
        'India',
        '411001',
        'Ring Rd',
        'Nagpur',
        'Maharashtra',
        'India',
        '440001',
        '9876543210',
        'Created'
            );
        Account customerAccount7 = TestDataHelpers.createCustomerAccount('Customer 7', true, false, false, false, 'Mission Road', 'Bengaluru', 'Karnataka', 'India', '560027', 'Indiranagar', 'Bengaluru', 'Karnataka', 'India', '560038','9811122233', 'Created');
        dmpl__Item__c item1 = TestDataHelpers.createItem('Item 1', 'Product', true, false, false, '675654', false);
        dmpl__Item__c item2 = TestDataHelpers.createItem('Item 2', 'Product', false, false, false, '654345', false);
        dmpl__Item__c item4 = TestDataHelpers.createItem('Item 4', 'Product', true, false, false, '765676', true);
        dmpl__Item__c item7 = TestDataHelpers.createItem('Item 7', 'Product',true, false, false, '765456',false);
        dmpl__SKU__c sku1 = TestDataHelpers.createSKU('SKU 1', item7.id, true);
        Asset asset1 = FulfillmentTestDataHelpers.createAsset(
            'Asset 1',
        customerAccount1,
        item1
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
    
    
    
    
    
    
    
    //New Method
    // // Account History
    @isTest
    public static void createAssetAccountHistoryWithAssetPositive() {
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        
        Test.startTest();
        Asset asset = AssetTestDataHelpers.createAsset(
            'Asset 2',
            partner1,
            null,
            Date.today(),
            null, 
            null
            );
        dmpl__AssetAccountHistory__c assetHistory = AssetTestDataHelpers.createAssetAccountHistory(
            asset,
        null,
        null, null, null,
        null, null, null
            );
        Test.stopTest();
        
        dmpl__AssetAccountHistory__c fetchedHistory = [
            SELECT Id, Name, dmpl__InstallbaseId__c
            FROM dmpl__AssetAccountHistory__c
            WHERE Id = :assetHistory.Id
        ];
        
        System.assertNotEquals(null, fetchedHistory, 'Asset Account History record should be fetched.');
        System.assertEquals(asset.Id, fetchedHistory.dmpl__InstallbaseId__c, 'Asset should be linked to the Account History correctly.');
    }
    
    @isTest
    public static void updateAssetAccountHistoryFieldsPositive() {
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        
        Test.startTest();
        Asset asset = AssetTestDataHelpers.createAsset('Asset 1', partner1, null, Date.today(), null, null);
        dmpl__AssetAccountHistory__c history = AssetTestDataHelpers.createAssetAccountHistory(
            asset, customer1, 'EXT-H123', 100, 10, Date.today().addDays(-5), Date.today(), 'Test Address'
            );
        history.dmpl__AtUsageReading__c = 150;
        history.dmpl__OwnershipEnddate__c = Date.today().addDays(10);
        update history;
        Test.stopTest();
        
        dmpl__AssetAccountHistory__c updatedHistory = [
            SELECT Id, dmpl__InstallbaseId__c, dmpl__AtUsageReading__c, dmpl__OwnershipEnddate__c
            FROM dmpl__AssetAccountHistory__c
            WHERE Id = :history.Id
        ];
        System.assertNotEquals(null, updatedHistory.Id, 'Asset Account History should exist');
        System.assertEquals(asset.Id, updatedHistory.dmpl__InstallbaseId__c, 'Asset should remain unchanged');
        System.assertEquals(150, updatedHistory.dmpl__AtUsageReading__c, 'Usage Reading should be updated');
        System.assertEquals(Date.today().addDays(10), updatedHistory.dmpl__OwnershipEnddate__c, 'Ownership end date should be updated');
    }
    
    @isTest
    public static void createAssetAccountHistoryWithAccountPositive() {
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        
        Test.startTest();
        Asset asset = AssetTestDataHelpers.createAsset(
            'Asset 2',
        partner1,
        null,
        Date.today(),
        null, null
            );
        dmpl__AssetAccountHistory__c history = AssetTestDataHelpers.createAssetAccountHistory(
            asset,
        customer1,
        'HA25060000',
        null, null,
        null, null,
        null
            );
        Test.stopTest();
        
        dmpl__AssetAccountHistory__c fetchedHistory = [
            SELECT Id, Name, dmpl__InstallbaseId__c, dmpl__AccountId__c
            FROM dmpl__AssetAccountHistory__c
            WHERE Id = :history.Id
        ];
        
        System.assertNotEquals(null, fetchedHistory, 'Asset Account History should be created.');
        System.assertEquals(asset.Id, fetchedHistory.dmpl__InstallbaseId__c, 'Asset should be linked correctly.');
        System.assertEquals(customer1.Id, fetchedHistory.dmpl__AccountId__c, 'Customer Account should be linked correctly.');
    }
    
    @isTest
    public static void createAssetAccountHistoryWithDiscontinuedItemNegative() {
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item4 = TestDataHelpers.getItem('Item 4'); 

        Test.startTest();
        Asset asset = AssetTestDataHelpers.createAsset(
            'Asset - Discontinued',
            partner1,
            item4,
            Date.today(),
            null,
            null
        );
        Test.stopTest();

        System.assertNotEquals(null, asset.Id, 'Asset should be created successfully even with a discontinued item.');
        System.assertEquals(item4.Id, asset.dmpl__ItemId__c, 'Asset should reference the correct item.');
    }
    
    @isTest
    public static void createAssetAccountHistoryWithStartDateGreaterThanEndDatePositive() {
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        
        Asset asset = AssetTestDataHelpers.createAsset(
            'Asset 2',
        partner1,
        null,
        Date.today(),
        null,
        null
            );
        
        Date ownershipStartDate = Date.newInstance(2025, 6, 30);
        Date ownershipEndDate = Date.newInstance(2025, 6, 1);
        
        Test.startTest();
        dmpl__AssetAccountHistory__c history = AssetTestDataHelpers.createAssetAccountHistory(
            asset,
        customer1,
        'HA25060000',
        null,
        null,
        ownershipStartDate,
        ownershipEndDate,
        null
            );
        Test.stopTest();
        
        System.assertNotEquals(null, history.Id);
        System.assertEquals(ownershipStartDate, history.dmpl__OwnershipStartDate__c);
        System.assertEquals(ownershipEndDate, history.dmpl__OwnershipEnddate__c);
    }
    
    @isTest
    public static void updateAssetAccountHistoryWithAtUsageReadingAsMinusOnePositive() {
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        
        Asset asset = AssetTestDataHelpers.createAsset(
            'Asset 2',
        partner1,
        null,
        Date.today(),
        null,
        null
            );
        
        dmpl__AssetAccountHistory__c history = AssetTestDataHelpers.createAssetAccountHistory(
            asset,
        customer1,
        'HA25060000',
        null,
        null,
        Date.today().addDays(-5),
        Date.today(),
        null
            );
        
        Test.startTest();
        history.dmpl__AtUsageReading__c = -1;
        update history;
        Test.stopTest();
        
        dmpl__AssetAccountHistory__c updated = [
            SELECT Id, dmpl__AtUsageReading__c
            FROM dmpl__AssetAccountHistory__c
            WHERE Id = :history.Id
        ];
        
        System.assertEquals(-1, updated.dmpl__AtUsageReading__c);
    }
    
    @isTest
    public static void updateAssetAccountHistoryWithAtUsageHourAsMinusOnePositive() {
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        
        Asset asset = AssetTestDataHelpers.createAsset(
            'Asset 2',
        partner1,
        null,
        Date.today(),
        null,
        null
            );
        
        dmpl__AssetAccountHistory__c history = AssetTestDataHelpers.createAssetAccountHistory(
            asset,
        customer1,
        'HA25060000',
        null,
        null,
        Date.today().addDays(-5),
        Date.today(),
        null
            );
        
        Test.startTest();
        history.dmpl__AtUsageHour__c = -1;
        update history;
        Test.stopTest();
        
        dmpl__AssetAccountHistory__c updated = [
            SELECT Id, dmpl__AtUsageHour__c
            FROM dmpl__AssetAccountHistory__c
            WHERE Id = :history.Id
        ];
        
        System.assertEquals(-1, updated.dmpl__AtUsageHour__c, 'Usage Hour should be updated to -1');
    }
    
    @isTest
    public static void updateAssetAccountHistoryWithInactiveCustomerNegative() {
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account customer7 = TestDataHelpers.getCustomerAccount('Customer 7');
        
        customer7.dmpl__IsActive__c = false;
        update customer7;
        
        Asset asset = AssetTestDataHelpers.createAsset(
            'Asset 2',
        partner1,
        null,
        Date.today(),
        null,
        null
            );
        
        dmpl__AssetAccountHistory__c history = AssetTestDataHelpers.createAssetAccountHistory(
            asset,
        customer1,
        'HA25060000',
        null,
        null,
        Date.today().addDays(-5),
        Date.today(),
        null
            );
        
        Boolean updateFailed = false;
        Test.startTest();
        try {
            history.dmpl__AccountId__c = customer7.Id;
            update history;
        } catch (Exception e) {
            updateFailed = true;
        }
        Test.stopTest();
        
        System.assertEquals(true, updateFailed);
    }
    
    //AccountDiagnostic
    @isTest
    public static void createAssetDiagnosticDataWithAssetPositive() {
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        Asset asset = AssetTestDataHelpers.createAsset(
            'Asset 2',
        partner1,
        item1,
        Date.today(),
        'SN-001',
        'COMP-001'
            );
        dmpl__AssetDiagnosticData__c diagnostic = AssetTestDataHelpers.createAssetDiagnosticData(
            asset,
        item1,
        null,
        'HCD25060000',
        'RAG',
        'Green',
        10,
        100,
        50,
        '50',
        'Initial'
            );
        dmpl__AssetDiagnosticData__c inserted = [
            SELECT Id, Name, dmpl__AssetId__c, dmpl__ItemId__c, dmpl__ValueType__c, dmpl__Condition__c
            FROM dmpl__AssetDiagnosticData__c
            WHERE Id = :diagnostic.Id
            LIMIT 1
        ];
        
        System.assertNotEquals(null, inserted.Id, 'Asset Diagnostic Data should be inserted');
        System.assertEquals(asset.Id, inserted.dmpl__AssetId__c, 'Asset reference should match');
        System.assertEquals(item1.Id, inserted.dmpl__ItemId__c, 'Item reference should match');
        System.assertEquals('RAG', inserted.dmpl__ValueType__c, 'Value Type should be Reading');
        System.assertEquals('Green', inserted.dmpl__Condition__c, 'Condition should be Normal');
    }
    
    @isTest
    public static void updateAssetDiagnosticDataWithNewItemPositive() {
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        dmpl__Item__c item2 = TestDataHelpers.getItem('Item 2');
        Asset asset = AssetTestDataHelpers.createAsset('Asset 2', partner1, item1, Date.today(), null, null);
        
        dmpl__AssetDiagnosticData__c data = AssetTestDataHelpers.createAssetDiagnosticData(
            asset, item1, null, 'HCD25060000', 'RAG', 'Green', 10, 100, 50, '50', 'Initial');
        
        Test.startTest();
        data.dmpl__ItemId__c = item2.Id;
        update data;
        Test.stopTest();
        
        System.assertEquals(item2.Id, [SELECT dmpl__ItemId__c FROM dmpl__AssetDiagnosticData__c WHERE Id = :data.Id].dmpl__ItemId__c);
    }
    
    @isTest
    public static void updateAssetDiagnosticDataWithHealthCheckPositive() {
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        Asset asset = AssetTestDataHelpers.createAsset('Asset 2', partner1, item1, Date.today(), null, null);
        
        dmpl__AssetDiagnosticData__c diagnosticData = AssetTestDataHelpers.createAssetDiagnosticData(
            asset, item1, null, 'HCD25060000', 'RAG', 'Green', 10, 100, 50, '50', 'Initial');
        
        dmpl__ProductHealthCheck__c healthCheck = AssetTestDataHelpers.createProductHealthCheck(
            partner1, branch1, customer1, asset, 'xx1', 'HC25060000');
        
        Test.startTest();
        diagnosticData.dmpl__ItemHealthCheckId__c = healthCheck.Id;
        update diagnosticData;
        Test.stopTest();
        
        System.assertEquals(healthCheck.Id, [SELECT dmpl__ItemHealthCheckId__c FROM dmpl__AssetDiagnosticData__c WHERE Id = :diagnosticData.Id].dmpl__ItemHealthCheckId__c);
    }
    
    @isTest
    public static void updateAssetDiagnosticDataWithValueTypeRAGPositive() {
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        Asset asset = TestDataHelpers.getAsset('Asset 1');
        
        dmpl__AssetDiagnosticData__c diagnosticData = AssetTestDataHelpers.createAssetDiagnosticData(
            asset, item1, null, 'HCD25060000', 'RAG', 'Green', 10, 100, 50, '50', 'Initial');

        Test.startTest();
        diagnosticData.dmpl__ValueType__c = 'RAG';
        update diagnosticData;
        dmpl__AssetDiagnosticData__c getdiagnosticData = AssetTestDataHelpers.getAssetDiagnosticData(diagnosticData.Id);
        Test.stopTest();
        
        System.assertEquals('RAG', getdiagnosticData.dmpl__ValueType__c);
    }
    
    @isTest
    public static void updateAssetDiagnosticDataWithNegativeStandardValuePositive() {
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        Asset asset = AssetTestDataHelpers.createAsset('Asset 2', partner1, item1, Date.today(), null, null);
        
        dmpl__AssetDiagnosticData__c diagnosticData = AssetTestDataHelpers.createAssetDiagnosticData(
            asset, item1, null, 'HCD25060000', 'RAG', 'Green', 10, 100, 50, '0', 'Initial');
        
        Test.startTest();
        diagnosticData.dmpl__StandardValue__c = '-1'; 
        update diagnosticData;
        Test.stopTest();

        dmpl__AssetDiagnosticData__c updated = [
            SELECT Id, dmpl__StandardValue__c
            FROM dmpl__AssetDiagnosticData__c
            WHERE Id = :diagnosticData.Id
        ];

        System.assertEquals('-1', updated.dmpl__StandardValue__c);
    }
    
    @isTest
    public static void updateAssetDiagnosticDataWithInvalidMinMaxNegative() {
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        Asset asset = AssetTestDataHelpers.createAsset('Asset 2', partner1, item1, Date.today(), null, null);
        
        dmpl__AssetDiagnosticData__c diagnosticData = AssetTestDataHelpers.createAssetDiagnosticData(
            asset, item1, null, 'HCD25060000', 'RAG', 'Green', 10, 100, 50, '50', 'Initial');
        
        Boolean failed = false;
        Test.startTest();
        try {
            diagnosticData.dmpl__MinValue__c = 90;
            diagnosticData.dmpl__MaxValue__c = 10;
            update diagnosticData;
        } catch (DmlException e) {
            failed = true;
        }
        Test.stopTest();
        
        System.assertEquals(true, failed, 'Update should fail when Min Value is greater than Max Value');
    }
    
    @isTest
    public static void updateAssetDiagnosticDataWithNegativeLastValuePositive() {
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        Asset asset = AssetTestDataHelpers.createAsset('Asset 2', partner1, item1, Date.today(), null, null);

        dmpl__AssetDiagnosticData__c diagnostic = AssetTestDataHelpers.createAssetDiagnosticData(
            asset, item1, null, 'HCD25060000', 'RAG', 'Green', 10, 100, 50, '50', 'Initial');

        Test.startTest();
        diagnostic.dmpl__LastValue__c = -1;
        update diagnostic;
        Test.stopTest();

        dmpl__AssetDiagnosticData__c updated = [
            SELECT Id, dmpl__LastValue__c
            FROM dmpl__AssetDiagnosticData__c
            WHERE Id = :diagnostic.Id
        ];

        System.assertEquals(-1, updated.dmpl__LastValue__c);
    }
    
    @isTest
    public static void updateAssetDiagnosticDataWithNegativeMinValueNegative() {
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        Asset asset = AssetTestDataHelpers.createAsset('Asset 2', partner1, item1, Date.today(), null, null);
        
        dmpl__AssetDiagnosticData__c diagnostic = AssetTestDataHelpers.createAssetDiagnosticData(
            asset, item1, null, 'HCD25060000', 'RAG', 'Green', 10, 100, 50, '50', 'Initial');
        
        Boolean failed = false;
        Test.startTest();
        try {
            diagnostic.dmpl__MinValue__c = -1;
            update diagnostic;
        } catch (DmlException e) {
            failed = true;
        }
        Test.stopTest();
        
        System.assertEquals(true, failed, 'Update should fail when Min Value is negative');
    }
    
    //Asset Maintenance
    @isTest
    public static void createAssetMaintenanceWithAssetPositive() {
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        Asset asset = AssetTestDataHelpers.createAsset('Asset 2', partner1, item1, Date.today(), null, null);
        
        Test.startTest();
        dmpl__AssetMaintenance__c maintenance = AssetTestDataHelpers.createAssetMaintenance(
            asset,
        partner1,
        branch1.Id,
        item1,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        false,
        1
            );
        Test.stopTest();
        
        dmpl__AssetMaintenance__c fetched = [
            SELECT Id, dmpl__AssetId__c
            FROM dmpl__AssetMaintenance__c
            WHERE Id = :maintenance.Id
        ];
        
        System.assertNotEquals(null, fetched);
        System.assertEquals(asset.Id, fetched.dmpl__AssetId__c);
    }
    
    @isTest
    static void updateAssetMaintenanceWithServiceCampaignPositive() {
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        Asset asset = AssetTestDataHelpers.createAsset('Asset 2', partner1, item, Date.today(), null, null);
        
        dmpl__AssetMaintenance__c maintenance = AssetTestDataHelpers.createAssetMaintenance(
            asset,
        partner1,
        branch1.Id,
        item,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        true,
        1
            );
        
        dmpl__ServiceCampaign__c campaign = (dmpl__ServiceCampaign__c) TestFactory.createSObject(
            new dmpl__ServiceCampaign__c(),
        true
            );
        
        Test.startTest();
        maintenance.dmpl__ServiceCampaignId__c = campaign.Id;
        update maintenance;
        Test.stopTest();
        
        dmpl__AssetMaintenance__c updated = [
            SELECT Id, dmpl__ServiceCampaignId__c
            FROM dmpl__AssetMaintenance__c
            WHERE Id = :maintenance.Id
        ];
        
        System.assertEquals(campaign.Id, updated.dmpl__ServiceCampaignId__c);
    }
    
    @isTest
    static void updateAssetMaintenanceWithServiceCampaignItemPositive() {
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        Asset asset = AssetTestDataHelpers.createAsset('Asset 2', partner1, item, Date.today(), null, null);
        
        dmpl__AssetMaintenance__c maintenance = AssetTestDataHelpers.createAssetMaintenance(
            asset,
        partner1,
        branch1.Id,
        item,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        true,
        1
            );
        
        dmpl__ServiceCampaign__c campaign = (dmpl__ServiceCampaign__c) TestFactory.createSObject(
            new dmpl__ServiceCampaign__c(),
        true
            );
        
        dmpl__ServiceCampaignItem__c campaignItem = (dmpl__ServiceCampaignItem__c) TestFactory.createSObject(
            new dmpl__ServiceCampaignItem__c(dmpl__ServiceCampaignId__c = campaign.Id),
        true
            );
        
        Test.startTest();
        maintenance.dmpl__ServiceCampaignItemId__c = campaignItem.Id;
        update maintenance;
        Test.stopTest();
        
        dmpl__AssetMaintenance__c updated = [
            SELECT Id, dmpl__ServiceCampaignItemId__c
            FROM dmpl__AssetMaintenance__c
            WHERE Id = :maintenance.Id
        ];
        
        System.assertEquals(campaignItem.Id, updated.dmpl__ServiceCampaignItemId__c);
    }
    
    @isTest
    static void updateAssetMaintenanceWithServiceCampaignMemberPositive() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        Asset asset = AssetTestDataHelpers.createAsset('Asset 2', partner, item, Date.today(), null, null);
        
        dmpl__AssetMaintenance__c maintenance = AssetTestDataHelpers.createAssetMaintenance(
            asset,
        partner,
        branch.Id,
        item,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        true,
        1
            );
        
        dmpl__ServiceCampaign__c campaign = (dmpl__ServiceCampaign__c) TestFactory.createSObject(
            new dmpl__ServiceCampaign__c(),
        true
            );
        
        dmpl__ServiceCampaignMember__c member = (dmpl__ServiceCampaignMember__c) TestFactory.createSObject(
            new dmpl__ServiceCampaignMember__c(dmpl__ServiceCampaignId__c = campaign.Id),
        true
            );
        
        Test.startTest();
        maintenance.dmpl__ServiceCampaignMemberId__c = member.Id;
        update maintenance;
        Test.stopTest();
        
        dmpl__AssetMaintenance__c updated = [
            SELECT Id, dmpl__ServiceCampaignMemberId__c
            FROM dmpl__AssetMaintenance__c
            WHERE Id = :maintenance.Id
        ];
        
        System.assertEquals(member.Id, updated.dmpl__ServiceCampaignMemberId__c);
    }
    
    @isTest
    static void updateAssetMaintenanceWithIsMandatoryTruePositive() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        Asset asset = AssetTestDataHelpers.createAsset('Asset 2', partner, item, Date.today(), null, null);
        
        dmpl__AssetMaintenance__c maintenance = AssetTestDataHelpers.createAssetMaintenance(
            asset,
        partner,
        branch.Id,
        item,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        false,
        1
            );
        
        Test.startTest();
        maintenance.dmpl__IsMandatory__c = true;
        update maintenance;
        Test.stopTest();
        
        dmpl__AssetMaintenance__c updated = [
            SELECT Id, dmpl__IsMandatory__c
            FROM dmpl__AssetMaintenance__c
            WHERE Id = :maintenance.Id
        ];
        
        System.assertEquals(true, updated.dmpl__IsMandatory__c);
    }
    
    @isTest
    static void createAssetMaintenanceWithNegativeQuantityPositive() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        Asset asset = AssetTestDataHelpers.createAsset('Asset 2', partner, item, Date.today(), null, null);

        Test.startTest();
        dmpl__AssetMaintenance__c maintenance = AssetTestDataHelpers.createAssetMaintenance(
            asset,
            partner,
            branch.Id,
            item,
            null,
            null,
            null,
            null,
            null,
            null,
            null,
            false,
            -1
        );
        Test.stopTest();

        System.assertNotEquals(null, maintenance.Id);
        System.assertEquals(-1, maintenance.dmpl__Quantity__c);
    }
    
    //Asset Service Contract
    @isTest
    static void createAssetServiceContractWithServiceContractPositive() {
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__SKU__c sku = TestDataHelpers.getSKU('SKU 1');
        dmpl__ItemServiceContract__c contract = AssetTestDataHelpers.createItemServiceContract(item, sku);
        
        Test.startTest();
        dmpl__AssetServiceContract__c assetServiceContract = AssetTestDataHelpers.createAssetServiceContract(
            null,
        customer,
        item,
        contract.Id,
        'SC25060002',
        null, null, null, null, null,
        null, null, null, null,
        null
            );
        Test.stopTest();
        
        System.assertNotEquals(null, assetServiceContract.Id);
        System.assertEquals('SC25060002', assetServiceContract.dmpl__ExternalId__c);
        System.assertEquals(item.Id, assetServiceContract.dmpl__ItemId__c);
        System.assertEquals(contract.Id, assetServiceContract.dmpl__ItemServiceContractId__c);
    }
    
    @isTest
    static void updateAssetServiceContractWithNewItemPositive() {
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        dmpl__Item__c item2 = TestDataHelpers.getItem('Item 2');
        dmpl__SKU__c sku = TestDataHelpers.getSKU('SKU 1');
        dmpl__ItemServiceContract__c contract = AssetTestDataHelpers.createItemServiceContract(item1, sku);
        
        dmpl__AssetServiceContract__c assetSC = AssetTestDataHelpers.createAssetServiceContract(
            null, customer, item1, contract.Id, 'SC25060002', null, null, null, null, null, null, null, null, null, null
            );
        
        Test.startTest();
        assetSC.dmpl__ItemId__c = item2.Id;
        update assetSC;
        Test.stopTest();
        
        dmpl__AssetServiceContract__c updated = [
            SELECT Id, dmpl__ItemId__c, dmpl__ItemServiceContractId__c, dmpl__BillingAccountId__c, dmpl__ExternalId__c
            FROM dmpl__AssetServiceContract__c
            WHERE Id = :assetSC.Id
        ];
        
        System.assertEquals(item2.Id, updated.dmpl__ItemId__c);
        System.assertEquals(contract.Id, updated.dmpl__ItemServiceContractId__c);
        System.assertEquals(customer.Id, updated.dmpl__BillingAccountId__c);
        System.assertEquals('SC25060002', updated.dmpl__ExternalId__c);
    }
    
    @isTest
    static void updateAssetServiceContractWithNewBillingAccountPositive() {
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__SKU__c sku = TestDataHelpers.getSKU('SKU 1');
        dmpl__ItemServiceContract__c contract = AssetTestDataHelpers.createItemServiceContract(item, sku);
        
        dmpl__AssetServiceContract__c assetSC = AssetTestDataHelpers.createAssetServiceContract(
            null, customer, item, contract.Id, 'SC25060002', null, null, null, null, null, null, null, null, null, null
            );
        
        Test.startTest();
        assetSC.dmpl__BillingAccountId__c = partner.Id;
        update assetSC;
        Test.stopTest();
        
        dmpl__AssetServiceContract__c updated = [
            SELECT Id, dmpl__ItemId__c, dmpl__ItemServiceContractId__c, dmpl__BillingAccountId__c, dmpl__ExternalId__c
            FROM dmpl__AssetServiceContract__c
            WHERE Id = :assetSC.Id
        ];
        
        System.assertEquals(partner.Id, updated.dmpl__BillingAccountId__c);
        System.assertEquals(item.Id, updated.dmpl__ItemId__c);
        System.assertEquals(contract.Id, updated.dmpl__ItemServiceContractId__c);
        System.assertEquals('SC25060002', updated.dmpl__ExternalId__c);
    }
    
    @isTest
    static void updateAssetServiceContractWithDueDateEarlierThanCurrentDateNegative() {
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__SKU__c sku = TestDataHelpers.getSKU('SKU 1');
        dmpl__ItemServiceContract__c contract = AssetTestDataHelpers.createItemServiceContract(item, sku);
        
        dmpl__AssetServiceContract__c assetSC = AssetTestDataHelpers.createAssetServiceContract(
            null, customer, item, contract.Id, 'SC25060002', Date.today().addDays(-5), null, null, null, null, null, null, null, null, null
            );
        
        System.assertNotEquals(null, assetSC.Id);
        System.assert(assetSC.dmpl__DueDate__c < Date.today());
    }
    
    @isTest
    static void updateAssetServiceContractWithDueInHoursAsMinusOneNegative() {
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__SKU__c sku = TestDataHelpers.getSKU('SKU 1');
        dmpl__ItemServiceContract__c contract = AssetTestDataHelpers.createItemServiceContract(item, sku);
        
        dmpl__AssetServiceContract__c assetSC = AssetTestDataHelpers.createAssetServiceContract(
            null, customer, item, contract.Id, 'SC25060002', null, -1, null, null, null, null, null, null, null, null
            );
        
        System.assertEquals(-1, assetSC.dmpl__DueInHours__c);
    }
    
    @isTest
    static void updateAssetServiceContractWithGraceUsageHoursAsMinusOneNegative() {
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__SKU__c sku = TestDataHelpers.getSKU('SKU 1');
        dmpl__ItemServiceContract__c contract = AssetTestDataHelpers.createItemServiceContract(item, sku);
        
        dmpl__AssetServiceContract__c assetSC = AssetTestDataHelpers.createAssetServiceContract(
            null, customer, item, contract.Id, 'SC25060002', null, null, null, -1, null, null, null, null, null, null
            );
        
        System.assertEquals(-1, assetSC.dmpl__GraceUsageHours__c);
    }
    
    @isTest
    static void updateAssetServiceContractWithValidTillHoursAsMinusOneNegative() {
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__SKU__c sku = TestDataHelpers.getSKU('SKU 1');
        dmpl__ItemServiceContract__c contract = AssetTestDataHelpers.createItemServiceContract(item, sku);
        
        Decimal invalidHours = -1;
        
        dmpl__AssetServiceContract__c assetSC = AssetTestDataHelpers.createAssetServiceContract(
            null, customer, item, contract.Id, 'SC25060002', null, null, null, null, null, null, null, invalidHours, null, null
            );
        
        System.assertEquals(invalidHours, assetSC.dmpl__ValidTillHours__c);
    }
    
    @isTest
    static void updateAssetServiceContractWithActivatedDateLessThanCurrentDatePositive() {
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__SKU__c sku = TestDataHelpers.getSKU('SKU 1');
        dmpl__ItemServiceContract__c contract = AssetTestDataHelpers.createItemServiceContract(item, sku);
        
        Date pastDate = Date.today().addDays(-10);
        dmpl__AssetServiceContract__c assetSC = AssetTestDataHelpers.createAssetServiceContract(
            null, customer, item, contract.Id, 'SC25060002', null, null, null, null, null, pastDate, null, null, null, null
            );
        
        System.assertEquals(pastDate, assetSC.dmpl__ActivatedDate__c);
    }
    
    @isTest
    static void updateAssetServiceContractWithValidTillBeforeActivatedDatePositive() {
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__SKU__c sku = TestDataHelpers.getSKU('SKU 1');
        dmpl__ItemServiceContract__c contract = AssetTestDataHelpers.createItemServiceContract(item, sku);
        
        Date activated = Date.today();
        Date validTill = activated.addDays(-5);
        dmpl__AssetServiceContract__c assetSC = AssetTestDataHelpers.createAssetServiceContract(
            null, customer, item, contract.Id, 'SC25060002', null, null, null, null, null, activated, validTill, null, null, null
            );
        
        System.assertEquals(validTill, assetSC.dmpl__ValidTillDate__c);
    }
    
    @isTest
    static void updateAssetServiceContractWithNegativeGraceUsageDaysNegative() {
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__SKU__c sku = TestDataHelpers.getSKU('SKU 1');
        dmpl__ItemServiceContract__c contract = AssetTestDataHelpers.createItemServiceContract(item, sku);
        dmpl__AssetServiceContract__c assetSC;
        try{
             assetSC = AssetTestDataHelpers.createAssetServiceContract(
                null, customer, item, contract.Id, 'SC25060002', null, null, -1, null, null, null, null, null, null, null
                );
        }catch(Exception e){}
        
        System.assertEquals(null, assetSC,'Asset Service should not get created');
    }
    
    
    //Asset Service Contract Line
    @isTest
    static void createAssetServiceContractLineUsingAssetServiceContractPositive() {
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__SKU__c sku = TestDataHelpers.getSKU('SKU 1');

        dmpl__ItemServiceContract__c itemContract = AssetTestDataHelpers.createItemServiceContract(item, sku);

        Asset asset = AssetTestDataHelpers.createAsset(
            'Asset-01', customer, item, Date.today(), 'SN-001', 'CMP-001'
        );

        dmpl__AssetServiceContract__c assetContract = AssetTestDataHelpers.createAssetServiceContract(
            asset,
            customer,
            item,
            itemContract.Id,
            'SC-0001',
            Date.today().addDays(10),
            20,
            2, 2, 2,
            Date.today(),
            Date.today().addMonths(3),
            100, 100,
            false
        );

        dmpl__AssetServiceContractLine__c contractLine = AssetTestDataHelpers.createAssetServiceContractLine(
            item,
            assetContract,
            item,
            5,
            1
        );

        System.assertNotEquals(null, assetContract.Id);
        System.assertEquals(item.Id, assetContract.dmpl__ItemId__c);
        System.assertNotEquals(null, contractLine.Id);
        System.assertEquals(assetContract.Id, contractLine.dmpl__AssetServiceContractId__c);
    }

    @isTest
    static void updateAssetServiceContractLineWithValidAssetContractPositive() {
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__SKU__c sku = TestDataHelpers.getSKU('SKU 1');

        dmpl__ItemServiceContract__c itemContract = AssetTestDataHelpers.createItemServiceContract(item, sku);

        Asset asset = AssetTestDataHelpers.createAsset(
            'Asset-01', customer, item, Date.today(), 'SN-001', 'CMP-001'
        );

        dmpl__AssetServiceContract__c assetContract = AssetTestDataHelpers.createAssetServiceContract(
            asset,
            customer,
            item,
            itemContract.Id,
            'SC25060002',
            Date.today().addDays(10),
            20, 2, 2, 2,
            Date.today(),
            Date.today().addMonths(3),
            100, 100,
            false
        );

        dmpl__AssetServiceContractLine__c contractLine = AssetTestDataHelpers.createAssetServiceContractLine(
            item,
            assetContract,
            item,
            5,
            1
        );

        contractLine.dmpl__Quantity__c = 10;

        Test.startTest();
        update contractLine;
        Test.stopTest();

        dmpl__AssetServiceContractLine__c updatedLine = [
            SELECT Id, dmpl__Quantity__c
            FROM dmpl__AssetServiceContractLine__c
            WHERE Id = :contractLine.Id
        ];

        System.assertEquals(10, updatedLine.dmpl__Quantity__c, 'Contract line should be updated with new quantity');
    }


    @isTest
    static void createAssetServiceContractLineWithComponentItemPositive() {
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__SKU__c sku = TestDataHelpers.getSKU('SKU 1');

        dmpl__ItemServiceContract__c itemContract = AssetTestDataHelpers.createItemServiceContract(item, sku);

        Asset asset = AssetTestDataHelpers.createAsset(
            'Asset-01', customer, item, Date.today(), 'SN-001', 'CMP-001'
        );

        dmpl__AssetServiceContract__c assetContract = AssetTestDataHelpers.createAssetServiceContract(
            asset,
            customer,
            item,
            itemContract.Id,
            'SC25060002',
            Date.today().addDays(10),
            20, 2, 2, 2,
            Date.today(),
            Date.today().addMonths(3),
            100, 100,
            false
        );

        dmpl__AssetServiceContractLine__c contractLine = AssetTestDataHelpers.createAssetServiceContractLine(
            item,
            assetContract,
            item,
            5,
            1
        );

        System.assertNotEquals(null, contractLine.Id);
        System.assertEquals(assetContract.Id, contractLine.dmpl__AssetServiceContractId__c);
        System.assertEquals(item.Id, contractLine.dmpl__ComponentItemId__c);
    }

    @isTest
    static void updateAssetServiceContractLineWithValidComponentItemPositive() {
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__SKU__c sku = TestDataHelpers.getSKU('SKU 1');

        dmpl__ItemServiceContract__c itemContract = AssetTestDataHelpers.createItemServiceContract(item, sku);

        Asset asset = AssetTestDataHelpers.createAsset(
            'Asset-01', customer, item, Date.today(), 'SN-001', 'CMP-001'
        );

        dmpl__AssetServiceContract__c assetContract = AssetTestDataHelpers.createAssetServiceContract(
            asset, customer, item, itemContract.Id, 'SC25060002',
            Date.today().addDays(10), 20, 2, 2, 2,
            Date.today(), Date.today().addMonths(3), 100, 100, false
        );

        dmpl__AssetServiceContractLine__c contractLine = AssetTestDataHelpers.createAssetServiceContractLine(
            item, assetContract, item, 5, 1
        );

        dmpl__Item__c newComponentItem = TestDataHelpers.getItem('Item 1');
        contractLine.dmpl__ComponentItemId__c = newComponentItem.Id;

        Test.startTest();
        update contractLine;
        Test.stopTest();

        dmpl__AssetServiceContractLine__c updated = [
            SELECT Id, dmpl__ComponentItemId__c FROM dmpl__AssetServiceContractLine__c WHERE Id = :contractLine.Id
        ];
        System.assertEquals(newComponentItem.Id, updated.dmpl__ComponentItemId__c, 'Component Item should be updated');
    }

    @isTest
    static void updateAssetServiceContractLineWithValidQuantityPositive() {
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__SKU__c sku = TestDataHelpers.getSKU('SKU 1');

        dmpl__ItemServiceContract__c itemContract = AssetTestDataHelpers.createItemServiceContract(item, sku);

        Asset asset = AssetTestDataHelpers.createAsset(
            'Asset-01', customer, item, Date.today(), 'SN-001', 'CMP-001'
        );

        dmpl__AssetServiceContract__c assetContract = AssetTestDataHelpers.createAssetServiceContract(
            asset, customer, item, itemContract.Id, 'SC25060002',
            Date.today().addDays(10), 20, 2, 2, 2,
            Date.today(), Date.today().addMonths(3), 100, 100, false
        );

        dmpl__AssetServiceContractLine__c contractLine = AssetTestDataHelpers.createAssetServiceContractLine(
            item, assetContract, item, 2, 0
        );

        contractLine.dmpl__Quantity__c = 3;

        Test.startTest();
        update contractLine;
        Test.stopTest();

        dmpl__AssetServiceContractLine__c updated = [
            SELECT Id, dmpl__Quantity__c FROM dmpl__AssetServiceContractLine__c WHERE Id = :contractLine.Id
        ];
        System.assertEquals(3, updated.dmpl__Quantity__c, 'Quantity should be updated to 3');
    }

    @isTest
    static void updateAssetServiceContractLineWithValidUtilizedQuantityPositive() {
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__SKU__c sku = TestDataHelpers.getSKU('SKU 1');
        dmpl__ItemServiceContract__c itemContract = AssetTestDataHelpers.createItemServiceContract(item, sku);

        dmpl__AssetServiceContract__c assetSC = AssetTestDataHelpers.createAssetServiceContract(
            null, customer, item, itemContract.Id, 'SC25060002', null, null, null, null, null, null, null, null, null, null
        );

        dmpl__AssetServiceContractLine__c ascLine = AssetTestDataHelpers.createAssetServiceContractLine(
            item, assetSC, item, 2, 1
        );

        ascLine.dmpl__UtilizedQuantity__c = 2;

        Test.startTest();
        update ascLine;
        Test.stopTest();

        dmpl__AssetServiceContractLine__c updated = [
            SELECT Id, dmpl__UtilizedQuantity__c FROM dmpl__AssetServiceContractLine__c WHERE Id = :ascLine.Id
        ];
        System.assertEquals(2, updated.dmpl__UtilizedQuantity__c, 'Utilized Quantity should be updated to 2');
    }

}