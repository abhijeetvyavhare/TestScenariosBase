@isTest
public class AssetServiceContractHandler_Test {
    @TestSetup
    static void createRequiredData(){
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
}