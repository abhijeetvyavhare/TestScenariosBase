@isTest
public with sharing class ProductDemoHandler_Test {
    @TestSetup
    static void createRequiredData(){
        Account partnerAccount = TestDataHelpers.createPartnerAccount();
        Account customerAccount = TestDataHelpers.createCustomerAccount();
        dmpl__Branch__c branch = TestDataHelpers.createBranch(partnerAccount);
        dmpl__Resource__c resource = TestDataHelpers.createResource(partnerAccount, branch);
        dmpl__ProductDemo__c productDemo = ProductDemoDataHelper.createProductDemo(partnerAccount, customerAccount, branch, resource);
    }

    @isTest
    static void testInsertProductDemo() {
        dmpl__ProductDemo__c productDemo = ProductDemoDataHelper.getProductDemo();
        System.assert(productDemo != null && productDemo.Id != null, 'Product Demo should be inserted.');
    }

    @isTest
    static void testUpdateProductDemo() {
        dmpl__ProductDemo__c productDemo = ProductDemoDataHelper.getProductDemo();
        productDemo.dmpl__CancellationReason__c = 'Lapsed';
        productDemo.dmpl__CustomerVoice__c = 'Voice2';
        productDemo.dmpl__DemoAddress__c = 'Address2';
        productDemo.dmpl__DemoAssetNumber__c = '2';
        productDemo.dmpl__DemoRating__c = '4';
        productDemo.dmpl__ExternalId__c = '5678';
        productDemo.dmpl__Status__c = 'Completed';
        productDemo.dmpl__KYCDocumentNumber__c = '2';
        productDemo.dmpl__Remarks__c = 'Remarks2';
        productDemo.dmpl__UsageReadingEnd__c = 5;
        productDemo.dmpl__UsageReadingStart__c = 2;
        update productDemo;
        dmpl__ProductDemo__c updatedDemo = ProductDemoDataHelper.getProductDemo();
        System.assertEquals('Lapsed', updatedDemo.dmpl__CancellationReason__c, 'CancellationReason should be Lapsed');
        System.assertEquals('Voice2', updatedDemo.dmpl__CustomerVoice__c, 'CustomerVoice should be Voice2');
        System.assertEquals('Address2', updatedDemo.dmpl__DemoAddress__c, 'DemoAddress should be Address2');
        System.assertEquals('2', updatedDemo.dmpl__DemoAssetNumber__c, 'DemoAssetNumber should be 2');
        System.assertEquals('4', updatedDemo.dmpl__DemoRating__c, 'DemoRating should be 4');
        System.assertEquals('Completed', updatedDemo.dmpl__Status__c, 'Status should be Completed');
        System.assertEquals('5678', updatedDemo.dmpl__ExternalId__c, 'ExternalId should be 5678');
        System.assertEquals('2', updatedDemo.dmpl__KYCDocumentNumber__c, 'KYCDocumentNumber should be 2');
        System.assertEquals('Remarks2', updatedDemo.dmpl__Remarks__c, 'Remarks should be Remarks2');
        System.assertEquals(5, updatedDemo.dmpl__UsageReadingEnd__c, 'UsageReadingEnd should be UsageReading2');
        System.assertEquals(2, updatedDemo.dmpl__UsageReadingStart__c, 'UsageReadingStart should be UsageReadingStart2');
    }

    @isTest
    static void testDeleteProductDemo() {
        dmpl__ProductDemo__c productDemo = ProductDemoDataHelper.getProductDemo();
        Id demoId = productDemo.Id;
        delete productDemo;
        List<dmpl__ProductDemo__c> deletedDemo = [SELECT Id FROM dmpl__ProductDemo__c WHERE Id = :demoId];
        System.assertEquals(0, deletedDemo.size(), 'Product Demo should be deleted.');
    }
}