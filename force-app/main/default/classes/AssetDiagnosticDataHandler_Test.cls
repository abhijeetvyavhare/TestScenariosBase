@isTest
public with sharing class AssetDiagnosticDataHandler_Test {
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
      dmpl__AssetDiagnosticData__c assetDiagnosticData = AssetTestDataHelpers.createAssetDiagnosticData(asset, item);
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