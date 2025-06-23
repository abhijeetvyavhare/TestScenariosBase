@isTest
public with sharing class AssetDataHelper_Test {
    public AssetDataHelper_Test() {

    }
    @TestSetup
    static void makeData(){
        Account partnerAccount = TestDataHelpers.createPartnerAccount();
        Account customerAccount = TestDataHelpers.createCustomerAccount();        
        dmpl__Branch__c branch =TestDataHelpers.createBranch(partnerAccount);    
        dmpl__ContactAddress__c contactAddress =TestDataHelpers.CreateContactAddress(customerAccount);
        dmpl__Item__c item =TestDataHelpers.createItem();
        dmpl__SKU__c sku =TestDataHelpers.createSKU(item);
        dmpl__StorageLocation__c storageLocation = TestDataHelpers.createStorageLocation(branch);
        dmpl__ItemLot__c itemLot = TestDataHelpers.createItemLot(branch , item ,sku ,storageLocation);
    }

    @isTest
    static void TestCreateAsset(){

        Asset testAsset = AssetDataHelper.createAsset(TestDataHelpers.getCustomerAccount() ,TestDataHelpers.getBranch(), TestDataHelpers.getItem() ,TestDataHelpers.getSKU() ,TestDataHelpers.getItemLot());
        System.assertEquals(testAsset.Name,'Test-Asset');
        //System.assertEquals(testAsset.dmpl__SKUId__c , sku.Id);
    } 
}