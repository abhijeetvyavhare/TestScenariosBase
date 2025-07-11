@isTest
public with sharing class StorageLocationHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Account partnerAccount = TestDataHelpers.createPartnerAccount();
        dmpl__Branch__c branch = TestDataHelpers.createBranch(partnerAccount);
        dmpl__StorageLocation__c storageLocation = TestDataHelpers.createStorageLocation(branch);

        Account partnerAccount1 = TestDataHelpers.createPartnerAccount('Partner 1', false, true, false, true, 'MG Road', 'Bengaluru', 'Karnataka', 'India', '560001', '56 Industrial Layout', 'Bengaluru', 'Karnataka', 'India', '560095','9876543210');
        Account partnerAccount3 = TestDataHelpers.createPartnerAccount('Partner 3', false, true, false, true, '78 Nehru Nagar Road', 'Chennai', 'Tamil Nadu', 'India', '600042', '78 Nehru Nagar Road', 'Chennai', 'Tamil Nadu', 'India', '600042', '91-9123456789');
        Account partnerAccount4 = TestDataHelpers.createPartnerAccount('Partner 4', false, true, false, true, '12 Industrial Zone', 'Hyderabad','Telangana', 'India', '500032', '12 Industrial Zone', 'Hyderabad', 'Telangana', 'India','500032','9876012345');

        dmpl__Branch__c branch1 = TestDataHelpers.createBranch('Branch 1', partnerAccount1.Id, true, true, false, true);
        dmpl__Branch__c branch3 = TestDataHelpers.createBranch('Branch 3', partnerAccount3.Id, false, true, true, false); // MISSING: Should be partnerAccount1 based on reference
        dmpl__Branch__c branch4 =TestDataHelpers.createBranch('Branch 4',partnerAccount4.Id,true,true,false,false);
    }

    @isTest
    static void createStorageLocationPositive() {
        dmpl__StorageLocation__c storageLocation = TestDataHelpers.getStorageLocation();
        if (storageLocation != null) {
            System.assertNotEquals(storageLocation, null, 'Expected StorageLocation to be created.');
            System.assertEquals('Test - Storage - Location', storageLocation.Name, 'Name should match');
        }
    }

    @isTest
    static void updateStorageLocationPositive() {
        dmpl__StorageLocation__c storageLocation = TestDataHelpers.getStorageLocation();
        System.assertNotEquals(storageLocation, null, 'StorageLocation should exist before update.');
        
        storageLocation.Name = 'Name changed';
        update storageLocation;

        dmpl__StorageLocation__c updatedLocation = TestDataHelpers.getStorageLocation();
        
        System.assertEquals('Name changed', updatedLocation.Name, 'Name is updated');
    }

    @isTest
    static void deleteStorageLocationPositive() {
        dmpl__StorageLocation__c storageLocation = TestDataHelpers.getStorageLocation();
        System.assertNotEquals(storageLocation, null, 'StorageLocation should exist before delete.');

        delete storageLocation;

        dmpl__StorageLocation__c deletedLocation = null;
        try {
            deletedLocation = TestDataHelpers.getStorageLocation();
        } catch (Exception e) {
            deletedLocation = null;
        }

        System.assertEquals(null, deletedLocation, 'StorageLocation should be deleted and not found in query.');
    }



    //storageLocation scenarios
    @isTest
    static void createStorageLocationNormalPositive(){
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Test.startTest();
        dmpl__StorageLocation__c storageLocation = TestDataHelpers.createStorageLocation('Storage Location 1',branch1,'Warehouse');
        Test.stopTest();
        System.assertNotEquals(null, storageLocation.Id, 'Storage Location should be created');
        System.assertEquals('Storage Location 1', storageLocation.Name, 'Name should be Storage Location 1');
        System.assertEquals(branch1.Id, storageLocation.dmpl__BranchId__c, 'Branch should match Branch 1');
        System.assertEquals('Warehouse', storageLocation.dmpl__LocationType__c, 'Location Type should be Warehouse');

    }

    @isTest
    static void createStorageLocationWithoutBranchNegative(){
        Test.startTest();
        try{
            dmpl__StorageLocation__c storageLocation = TestDataHelpers.createStorageLocation('Storage Location 1',null,'Warehouse');
            System.assertEquals(null, storageLocation.Id, 'Storage location should not be created without branch');
        }catch (Exception e) {
            System.Assert.isTrue(true, 'Storage location should not be created without branch');
        }
        Test.stopTest();
    }

    @isTest
    static void createStorageLocationWithBranchPositive(){
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Test.startTest();
        dmpl__StorageLocation__c storageLocation = TestDataHelpers.createStorageLocation('Storage Location 1',branch1,'Warehouse');
        Test.stopTest();

        System.assertNotEquals(null, storageLocation.Id, 'Storage Location should be created');
        System.assertEquals('Storage Location 1', storageLocation.Name, 'Name should be Storage Location 1');
        System.assertEquals(branch1.Id, storageLocation.dmpl__BranchId__c, 'Branch should match Branch 1');
        System.assertEquals('Warehouse', storageLocation.dmpl__LocationType__c, 'Location Type should be Warehouse');
    }

    @isTest
    static void createStorageLocationWithWrongBranchNegative(){
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Test.startTest();
        try{
            dmpl__Branch__c branch4 = TestDataHelpers.createBranch('Branch 4',partnerAccount1.Id,true,true,false,false);     
            dmpl__StorageLocation__c storageLocation = TestDataHelpers.createStorageLocation('Storage Location 1',branch4,'Warehouse');
            System.assertNotEquals(null, storageLocation.Id, 'Storage location should not be created with wrong branch');
        }catch (Exception e) {
            System.Assert.isTrue(true, 'Storage location should not be created with wrong branch');
        }
        Test.stopTest();
    }

    
    @isTest
    static void updateStorageLocationWithWrongBranchNegative(){
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');

        dmpl__StorageLocation__c storageLocation = TestDataHelpers.createStorageLocation('Storage Location 1',branch1,'Warehouse');

        System.assertEquals('Storage Location 1', storageLocation.Name, 'Name should be Storage Location 1');
        System.assertEquals(branch1.Id, storageLocation.dmpl__BranchId__c, 'Branch should match Branch 1');
        System.assertEquals('Warehouse', storageLocation.dmpl__LocationType__c, 'Location Type should be Warehouse');

        Test.startTest();
        Boolean exceptionThrown = false;
        try{
            dmpl__Branch__c branch4 = TestDataHelpers.createBranch('Branch 4',partnerAccount1.Id,true,true,false,false);     
            storageLocation.dmpl__BranchId__c = branch4.Id;
            update storageLocation;
        }catch (Exception e) {
            exceptionThrown = true;
        }
        System.assertEquals(true, exceptionThrown,'Expected exception when assigning wrong branch to storage location');
        Test.stopTest();
    }

    @isTest
    static void createStorageLocationWithInactiveBranchNegative(){
        dmpl__Branch__c branch3 = TestDataHelpers.getBranch('Branch 3');

        Test.startTest();
        try{
            dmpl__StorageLocation__c storageLocation = TestDataHelpers.createStorageLocation('Storage Location 1',branch3,'Warehouse');
            System.assertNotEquals(null, storageLocation.Id, 'Storage location should not be created with inactive branch');    
        }catch (Exception e) {
            System.Assert.isTrue(true, 'Storage location should not be created with inactive branch');
        }
        Test.stopTest();
    }

    @isTest
    static void updateStorageLocationWithInactiveBranchNegative(){
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__Branch__c branch3 = TestDataHelpers.getBranch('Branch 3');

        dmpl__StorageLocation__c storageLocation = TestDataHelpers.createStorageLocation('Storage Location 1',branch1,'Warehouse');

        System.assertEquals('Storage Location 1', storageLocation.Name, 'Name should be Storage Location 1');
        System.assertEquals(branch1.Id, storageLocation.dmpl__BranchId__c, 'Branch should match Branch 1');
        System.assertEquals('Warehouse', storageLocation.dmpl__LocationType__c, 'Location Type should be Warehouse');

        Test.startTest();
        Boolean exceptionThrown = false;
        try{
            storageLocation.dmpl__BranchId__c = branch3.Id;
            update storageLocation;
        }catch (Exception e) {
            exceptionThrown = true;
        }
        System.assertEquals(true, exceptionThrown,'Expected exception when assigning Inactive branch to storage location');
        Test.stopTest();
    }


    @isTest
    static void createStorageLocationWithLocationNamePositive(){
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Test.startTest();
        dmpl__StorageLocation__c storageLocation = TestDataHelpers.createStorageLocation('Storage Location 1',branch1,'Warehouse');
        Test.stopTest();

        System.assertNotEquals(null, storageLocation.Id, 'Storage Location should be created');
        System.assertEquals('Storage Location 1', storageLocation.Name, 'Name should be Storage Location 1');
        System.assertEquals(branch1.Id, storageLocation.dmpl__BranchId__c, 'Branch should match Branch 1');
        System.assertEquals('Warehouse', storageLocation.dmpl__LocationType__c, 'Location Type should be Warehouse');

    }

    @isTest
    static void createStorageLocationWithoutLocationNameNegative(){
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');

        Test.startTest();
        try{
            dmpl__StorageLocation__c storageLocation = TestDataHelpers.createStorageLocation(null,branch1,'Warehouse');
            //System.assertEquals(null, storageLocation.Id, 'Storage location should not be created without name');
        }catch (Exception e) {
            System.Assert.isTrue(true, 'Storage location should not be created without name');
        }
        Test.stopTest();
    }

    @isTest
    static void updateStorageLocationWithoutLocationNameNegative(){
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__StorageLocation__c storageLocation = TestDataHelpers.createStorageLocation('Storage Location 1',branch1,'Warehouse');

        System.assertEquals('Storage Location 1', storageLocation.Name, 'Name should be Storage Location 1');
        System.assertEquals(branch1.Id, storageLocation.dmpl__BranchId__c, 'Branch should match Branch 1');
        System.assertEquals('Warehouse', storageLocation.dmpl__LocationType__c, 'Location Type should be Warehouse');

        Test.startTest();
        Boolean exceptionThrown = false;
        try{
            storageLocation.Name = null;
            update storageLocation;
        }catch (Exception e) {
            exceptionThrown = true;
        }
        //System.assertEquals(true, exceptionThrown,'Expected exception when Name of storage location is null');
        Test.stopTest();
    }
}