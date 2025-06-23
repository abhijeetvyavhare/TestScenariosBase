@isTest
public with sharing class StorageLocationHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Account partnerAccount = TestDataHelpers.createPartnerAccount();
        dmpl__Branch__c branch = TestDataHelpers.createBranch(partnerAccount);
        dmpl__StorageLocation__c storageLocation = TestDataHelpers.createStorageLocation(branch);
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
}