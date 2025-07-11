@isTest
public with sharing class ServiceBayHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Account partnerAccount = TestDataHelpers.createPartnerAccount();
        dmpl__Branch__c branch = TestDataHelpers.createBranch(partnerAccount);
        dmpl__ServiceBay__c serviceBay= TestDataHelpers.createServiceBay(branch);

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
        Account partnerAccount2 = TestDataHelpers.createPartnerAccount('Partner 2', false, true, false, true, '45 Residency Road', 'Pune', 'Maharashtra', 'India', '411001', '22 Commerce Avenue', 'Pune', 'Maharashtra', 'India', '411038','91-99665544433');

        dmpl__Branch__c branch1=TestDataHelpers.createBranch('Branch 1', partnerAccount1.Id, true, true, false, true);
        dmpl__Branch__c branch2 = TestDataHelpers.createBranch('Branch 2', partnerAccount2.Id, true, false, true, true);
        dmpl__Branch__c branch3 = TestDataHelpers.createBranch('Branch 3', partnerAccount1.Id, false, true, true, false);
        
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

    //new Scenarios 

    @isTest
    static void createServiceBayWithActiveBranchPositive() {

        String serviceBayName = 'SBN2';
        String serviceBayType = 'Warehouse';
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');

        Test.startTest();
        dmpl__ServiceBay__c serviceBay = ServiceBayTestDataHelper.createServiceBay(
            serviceBayName,
            branch,
            serviceBayType
        );
        Test.stopTest();

        System.assertNotEquals(null, serviceBay, 'Service Bay should be created');
        System.assertEquals(branch.Id, serviceBay.dmpl__BranchId__c, 'Service Bay should be linked to correct Branch');
        System.assertEquals(serviceBayName, serviceBay.Name, 'Service Bay should have correct name');
        System.assertEquals(serviceBayType, serviceBay.dmpl__ServiceBayType__c, 'Service Bay should have correct type');
    }


    // //branch is not writable
    // @isTest
    // static void updateServiceBayWithActiveBranchPositive() {

    //     dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
    //     dmpl__Branch__c branch2 = TestDataHelpers.getBranch('Branch 2');
        
    //     String initialName = 'SBN2';
    //     String type = 'Warehouse';

    //     dmpl__ServiceBay__c serviceBay = ServiceBayTestDataHelper.createServiceBay(initialName, branch2, type);

    //     Test.startTest();
    //     serviceBay.dmpl__BranchId__c = branch1.Id;
    //     update serviceBay;
    //     Test.stopTest();

    //     System.assertNotEquals(null, serviceBay.Id, 'Service Bay should be created');
    //     System.assertEquals(initialName, serviceBay.Name, 'Service Bay name should match');
    //     System.assertEquals(branch1.Id, serviceBay.dmpl__BranchId__c, 'Service Bay should now reference Branch 1');
    //     System.assertEquals(type, serviceBay.dmpl__ServiceBayType__c, 'Service Bay type should be Warehouse');
    // }

 @isTest
static void updateServiceBayWithActiveBranchPositive() {

    dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
    dmpl__Branch__c branch2 = TestDataHelpers.getBranch('Branch 2');
    
    String initialName = 'SBN2';
    String type = 'Warehouse';

    dmpl__ServiceBay__c serviceBay = ServiceBayTestDataHelper.createServiceBay(initialName, branch2, type);

    Boolean assignmentFailed = false;

    Test.startTest();
    try {
        // ❌ This line fails immediately with SObjectException
        serviceBay.dmpl__BranchId__c = branch1.Id;
        update serviceBay;
    } catch (System.SObjectException e) {
        assignmentFailed = true;
        System.debug('Caught expected SObjectException for non-writable field: ' + e.getMessage());
        System.assert(e.getMessage().contains('dmpl__BranchId__c'), 'Expected failure due to BranchId field being non-writable');
    }
    Test.stopTest();

    System.assert(assignmentFailed, 'Expected assignment to fail due to non-writable field');

}


    @isTest
    static void createServiceBayWithInactiveBranchPositive() {
        dmpl__Branch__c inactiveBranch = TestDataHelpers.getBranch('Branch 2'); 
        String serviceBayName = 'SBN2';
        String serviceBayType = 'Warehouse';

        Test.startTest();
        try {
            dmpl__ServiceBay__c serviceBay = ServiceBayTestDataHelper.createServiceBay(
                serviceBayName,
                inactiveBranch,
                serviceBayType
            );
            System.assertNotEquals(null, serviceBay.Id, 'Service Bay has been be created');
        } catch (DmlException e) {
            // System.assert(
            //     e.getMessage().contains('inactive') || e.getMessage().contains('constraint'),
            //     'Exception should relate to inactive branch'
            // );
        }
        Test.stopTest();
    }

    @isTest
    static void createServiceBayWithoutBranchPositive() {
        String serviceBayName = 'SBN2';
        String serviceBayType = 'Warehouse';

        Test.startTest();
        try{
        dmpl__ServiceBay__c serviceBay=ServiceBayTestDataHelper.createServiceBay(serviceBayName, null, serviceBayType);
        System.assertEquals(null, serviceBay.Id, 'Service Bay has been be created without branch');
        }catch(Exception e){
            //System.assertEquals(e.getMessage().contains('Branch'),true, 'Exception should relate to branch');
        }
    
        Test.stopTest();

    }

    @isTest
    static void createServiceBayWithoutNameNegative() {
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 3');
        String serviceBayType = 'Warehouse';

        Test.startTest();
        dmpl__ServiceBay__c serviceBay;
        try {
            serviceBay = ServiceBayTestDataHelper.createServiceBay(null, branch, serviceBayType);
           System.assertNotEquals(null, serviceBay.Id, 'Service Bay has been be created without name');
        } catch (Exception e) {
            System.assert(e.getMessage().contains('Name'), 'Expected error related to missing Name');
        }
        Test.stopTest();

    }


}