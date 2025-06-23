@isTest
public with sharing class ServiceBayHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Account partnerAccount = TestDataHelpers.createPartnerAccount();
        dmpl__Branch__c branch = TestDataHelpers.createBranch(partnerAccount);
        dmpl__ServiceBay__c serviceBay= TestDataHelpers.createServiceBay(branch);
    }

    @isTest
    static void createServiceBayPositive() {
        dmpl__ServiceBay__c serviceBay = TestDataHelpers.getServiceBay();
        if(serviceBay != null){
            System.assertNotEquals(serviceBay, null, 'Expected serviceBay to be created.');
        }
        System.assertEquals('Test - ServiceBay', serviceBay.Name, 'Name not matched');
    }

    @isTest
    static void updateServiceBayPositive() {
        dmpl__ServiceBay__c serviceBay = TestDataHelpers.getServiceBay();
        System.assertNotEquals(serviceBay, null, 'ServiceBay should exist before update.');
        serviceBay.Name = 'Updated - ServiceBay';
        update serviceBay;
        dmpl__ServiceBay__c updatedServiceBay = TestDataHelpers.getServiceBay();
        System.assertEquals('Updated - ServiceBay', updatedServiceBay.Name, 'Expected Name to be updated.');
    }

    @isTest
    static void deleteServiceBayPositive() {
        dmpl__ServiceBay__c serviceBay = TestDataHelpers.getServiceBay();
        System.assertNotEquals(serviceBay, null, 'ServiceBay should exist before delete.');
        delete serviceBay;
        dmpl__ServiceBay__c deletedServiceBay;
        try {
            deletedServiceBay = TestDataHelpers.getServiceBay();
        } catch (Exception e) {
            deletedServiceBay = null;
        }
        System.assertEquals(null, deletedServiceBay, 'Expected ServiceBay to be deleted.');
    }


}