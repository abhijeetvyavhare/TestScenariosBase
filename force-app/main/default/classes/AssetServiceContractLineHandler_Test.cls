@isTest
public with sharing class AssetServiceContractLineHandler_Test {
    @TestSetup
    static void createRequiredData() {
        dmpl__AccountGroup__c accountGroup=TestDataHelpers.createAccountGroup();
        Account account=TestDataHelpers.createAccount(accountGroup);
        Account partnerAccount=TestDataHelpers.createPartnerAccount();
        dmpl__Branch__c branch=TestDataHelpers.createBranch(partnerAccount);
        dmpl__Item__c item = TestDataHelpers.createItem();
        dmpl__StorageLocation__c storageLocation = TestDataHelpers.createStorageLocation(branch);
        dmpl__SKU__c sku = TestDataHelpers.createSKU(item);
        dmpl__ItemLot__c itemLot = TestDataHelpers.createItemLot(branch,item,sku,storageLocation);
        Asset asset=AssetTestDataHelpers.CreateAsset(account, branch, item, itemLot, sku);
        dmpl__AssetServiceContract__c assetServiceContract = AssetTestDataHelpers.createAssetServiceContract(asset, item);
        dmpl__AssetServiceContractLine__c assetServiceContractLine = AssetTestDataHelpers.createAssetServiceContractLine(assetServiceContract, item);
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
}