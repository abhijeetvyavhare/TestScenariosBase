@isTest
public with sharing class ShippingAssetLineHandler_Test {
    @TestSetup
    static void createRequiredData(){
        dmpl__AccountGroup__c accountGroup=TestDataHelpers.createAccountGroup();
        Account account=TestDataHelpers.createAccount(accountGroup);
        Account partnerAccount=TestDataHelpers.createPartnerAccount();
        Account supplierAccount=TestDataHelpers.createSupplierAccount();
        dmpl__Branch__c branch=TestDataHelpers.createBranch(partnerAccount);
        dmpl__Item__c item = TestDataHelpers.createItem();
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.createTaxGroup(partnerAccount, branch);
        dmpl__StorageLocation__c storageLocation = TestDataHelpers.createStorageLocation(branch);
        dmpl__SKU__c sku = TestDataHelpers.createSKU(item);
        dmpl__ItemLot__c itemLot = TestDataHelpers.createItemLot(branch,item,sku,storageLocation);
        dmpl__ItemLotType__c itemLotType = TestDataHelpers.CreateItemLotType(item);
        dmpl__PurchaseOrder__c purchaseOrder=PurchaseOrderTestDataHelpers.createPurchaseOrder(branch,supplierAccount);
        dmpl__PurchaseRequisition__c PurchaseRequisition=PurchaseOrderTestDataHelpers.createPurchaseRequisition(branch, supplierAccount);
        dmpl__PurchaseOrderLine__c purchaseOrderLine=PurchaseOrderTestDataHelpers.createPurchaseOrderLine(item,sku, purchaseOrder, taxGroup);
        Asset asset=AssetTestDataHelpers.CreateAsset(account, branch, item, itemLot, sku);
        dmpl__Shipment__c shipment = ShipmentTestDataHelper.createShipment(supplierAccount, branch, purchaseOrder);
        dmpl__ShipmentLine__c shipmentLine = ShipmentTestDataHelper.createShipmentLine(item, shipment, sku, purchaseOrderLine);
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
}