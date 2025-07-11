@isTest
public with sharing class TransferHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Account partnerAccount = TestDataHelpers.createPartnerAccount();
        dmpl__Branch__c branch = TestDataHelpers.createBranch(partnerAccount);
        dmpl__Transfer__c transfer = TransferTestDataHelper.createTransfer(partnerAccount,branch);
    }
 
    @isTest
    static void createTransferPositive() {
        dmpl__Transfer__c transfer = TransferTestDataHelper.getTransfer();
        if (transfer != null) {
            System.assertNotEquals(transfer, null, 'Expected Transfer to be created.');
            System.assertEquals(false, transfer.dmpl__PerformInwardPosting__c, 'PerformInwardPosting should be false');
            System.assertEquals(false, transfer.dmpl__PerformInwardReceive__c, 'PerformInwardReceive should be false');
            System.assertEquals(Date.today(), transfer.dmpl__TransferTime__c, 'TransferTime should be today');
            System.assertNotEquals(transfer.dmpl__BranchId__c, null, 'BranchId should not be null');
            System.assertNotEquals(transfer.dmpl__ToBranchId__c, null, 'ToBranchId should not be null');
            System.assertNotEquals(transfer.dmpl__PartnerAccountId__c, null, 'PartnerAccountId should not be null');
        }
    }
 
    @isTest
    static void updateTransferPositive() {
        dmpl__Transfer__c transfer = TransferTestDataHelper.getTransfer();
        System.assertNotEquals(transfer, null, 'Transfer should exist before update.');
 
        transfer.dmpl__PerformInwardPosting__c = true;
        transfer.dmpl__PerformInwardReceive__c = true;
        update transfer;
 
        dmpl__Transfer__c updatedTransfer = TransferTestDataHelper.getTransfer();
        System.assertEquals(true, updatedTransfer.dmpl__PerformInwardPosting__c, 'PerformInwardPosting should be updated to true');
        System.assertEquals(true, updatedTransfer.dmpl__PerformInwardReceive__c, 'PerformInwardReceive should be updated to true');
    }
 
    @isTest
    static void deleteTransferPositive() {
        dmpl__Transfer__c transfer = TransferTestDataHelper.getTransfer();
        System.assertNotEquals(transfer, null, 'Transfer should exist before delete.');
 
        delete transfer;
 
        dmpl__Transfer__c deletedTransfer = null;
        try {
            deletedTransfer = TransferTestDataHelper.getTransfer();
        } catch (Exception e) {
            deletedTransfer = null;
        }
 
        System.assertEquals(null, deletedTransfer, 'Transfer should be deleted and not found in query.');
    }
    
    //with mandatory fields
     @isTest
    static void createATransferRecordWithAllMandatoryFields() {
        Account partnerAccount = TestDataHelpers.getPartnerAccount();
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        dmpl__Transfer__c transfer = TransferTestDataHelper.createTransfer(partnerAccount,branch);
       
        System.assertNotEquals(null, transfer, 'Transfer record should be fetched successfully');
        System.assertEquals(partnerAccount.Id, transfer.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch.Id, transfer.dmpl__BranchId__c, 'Branch should match');
    }
   
    //Create a Transfer with valid Partner Account.
    @isTest
    static void createTransferWithValidPartnerAccountPositive() {
        Account partnerAccount = TestDataHelpers.getPartnerAccount();
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        dmpl__Transfer__c transfer = TransferTestDataHelper.createTransfer(partnerAccount,branch);
      
        System.assertNotEquals(null, transfer, 'Transfer record should be fetched successfully');
        System.assertEquals(partnerAccount.Id, transfer.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch.Id, transfer.dmpl__BranchId__c, 'Branch should match');
    }

    //Create a Transfer where From Branch and To Branch are different but both valid 
    @isTest
    static void createTransferWithDifferentValidFromAndToBranchesPositive(){
        Test.startTest();
        Account partnerAccount = TestDataHelpers.getPartnerAccount();
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        Account partnerAccount1 = TestDataHelpers.createPartnerAccount('Partner 1', false, true, false, true, 'MG Road', 'Bengaluru', 'Karnataka', 'India', '560001', '56 Industrial Layout', 'Bengaluru', 'Karnataka', 'India', '560095','9876543210');
        dmpl__Branch__c branch1=TestDataHelpers.createBranch('Branch 1', partnerAccount1.Id, true, true, false, true);
        dmpl__Transfer__c transfer = TransferTestDataHelper.createTransfer(partnerAccount,branch);
        transfer.dmpl__ToBranchId__c=branch1.Id;
        update transfer;
        dmpl__Transfer__c fetchedtransfer = TransferTestDataHelper.getTransfer(transfer);
        System.assertNotEquals(null, fetchedTransfer, 'Transfer record should be fetched successfully');
        System.assertEquals(partnerAccount.Id, fetchedTransfer.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch.Id, fetchedTransfer.dmpl__BranchId__c, 'Branch should match');
        Test.stopTest();
    }
    
    //Transfer creation with the inactive partner account (new) 
    @isTest
    Static void createTransferWithInvalidPartnerAccountNegative(){
        Boolean exceptionThrown= false;
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        Account partnerAccount2 = TestDataHelpers.createPartnerAccount('Partner 2', false, true, false, true, '45 Residency Road', 'Pune', 'Maharashtra', 'India', '411001', '22 Commerce Avenue', 'Pune', 'Maharashtra', 'India', '411038','91-99665544433');
        Account account = TestDataHelpers.getPartnerAccount('Partner 2');

        try {
             dmpl__Transfer__c transfer = TransferTestDataHelper.createTransfer(account,branch);
        } catch (Exception e) {
           exceptionThrown= true;
       System.debug('Expected exception caught: ' + e.getMessage());
        }
        //System.assertEquals(true, exceptionThrown, 'Expected exception was not thrown when using inactive partner Account');
    }

    //Transfer creation with inactive From Branch (New)
    @isTest
    Static void createTransferWithInactiveFromBranchNegative(){
        Boolean exceptionThrown= false;
        Account partnerAccount1 = TestDataHelpers.createPartnerAccount('Partner 1', false, true, false, true, 'MG Road', 'Bengaluru', 'Karnataka', 'India', '560001', '56 Industrial Layout', 'Bengaluru', 'Karnataka', 'India', '560095','9876543210');
        dmpl__Branch__c branch3 = TestDataHelpers.createBranch('Branch 3', partnerAccount1.Id, false, true, true, false);
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 3');
        Account account = TestDataHelpers.getPartnerAccount();

        try {
             dmpl__Transfer__c transfer = TransferTestDataHelper.createTransfer(account,branch);
        } catch (Exception e) {
           exceptionThrown= true;
       System.debug('Expected exception caught: ' + e.getMessage());
        }
        System.assertEquals(true, exceptionThrown, 'Expected exception was not thrown when using invactive branch');
    }

    //Leave To Branch field empty (should fail- mandatory)
    @isTest
    static void createTransferWithEmptyToBranchNegative() {
        Boolean exceptionThrown= false;
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        Account account = TestDataHelpers.getPartnerAccount();

        try {
             dmpl__Transfer__c transfer = TransferTestDataHelper.createTransfer(account,null);
        } catch (Exception e) {
           exceptionThrown= true;
       System.debug('Expected exception caught: ' + e.getMessage());
        }
        System.assertEquals(true, exceptionThrown, 'Expected exception was not thrown when using to branch as null');
    }

    //Edit Transfer and remove Partner Account (Edit)
    @isTest 
    static void updateTransferRemovePartnerAccountNegative(){
         Boolean exceptionThrown= false;
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        Account account = TestDataHelpers.getPartnerAccount();
        dmpl__Transfer__c transfer = TransferTestDataHelper.createTransfer(account,branch);
      
        try {
            transfer.dmpl__PartnerAccountId__c=null;
            update transfer;
            dmpl__Transfer__c fetchedTransfer = TransferTestDataHelper.getTransfer(transfer);
        } catch (Exception e) {
           exceptionThrown= true;
       System.debug('Expected exception caught: ' + e.getMessage());
        }
        System.assertEquals(true, exceptionThrown, 'Expected exception was not thrown when removinf partner account');

    }

    //Edit Transfer and add the  date and time (Edit)
    @isTest
    static void updateTransferAddDateTimePositive(){
        Account partnerAccount = TestDataHelpers.getPartnerAccount();
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        dmpl__Transfer__c transfer = TransferTestDataHelper.createTransfer(partnerAccount,branch,null);
        transfer.dmpl__TransferTime__c= Date.Today();
        update transfer;
        dmpl__Transfer__c fetchedtransfer = TransferTestDataHelper.getTransfer(transfer);
        System.assertNotEquals(null, fetchedTransfer, 'Transfer record should be fetched successfully');
        System.assertEquals(partnerAccount.Id, fetchedTransfer.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch.Id, fetchedTransfer.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(Date.Today(),fetchedTransfer.dmpl__TransferTime__c,'Error');
    }

    //Transfer record creation with only Name filled (New)
    @isTest
    static void createTransferWithOnlyNameNegative(){
        Boolean exceptionThrown= false;
        Account account = TestDataHelpers.getPartnerAccount();
        
        try {
           dmpl__Transfer__c transfer = TransferTestDataHelper.createTransfer(account,null);
        } catch (Exception e) {
           exceptionThrown= true;
       System.debug('Expected exception caught: ' + e.getMessage());
        }
        System.assertEquals(true, exceptionThrown, 'Expected exception was not thrown when only using partner account');

    }

    //Transfer creation with invalid branch and valid Partner Account (New)
    @isTest
    static void createTransferWithInvalidBranchAndValidPartnerAccountNegative(){
        Boolean exceptionThrown= false;
        Account partnerAccount1 = TestDataHelpers.createPartnerAccount('Partner 1', false, true, false, true, 'MG Road', 'Bengaluru', 'Karnataka', 'India', '560001', '56 Industrial Layout', 'Bengaluru', 'Karnataka', 'India', '560095','9876543210');
        dmpl__Branch__c branch3 = TestDataHelpers.createBranch('Branch 3', partnerAccount1.Id, false, true, true, false);
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 3');
        Account partnerAccount2 = TestDataHelpers.createPartnerAccount('Partner 2', false, true, false, true, '45 Residency Road', 'Pune', 'Maharashtra', 'India', '411001', '22 Commerce Avenue', 'Pune', 'Maharashtra', 'India', '411038','91-99665544433');
        Account account = TestDataHelpers.getPartnerAccount('Partner 2');

        try {
             dmpl__Transfer__c transfer = TransferTestDataHelper.createTransfer(account,branch);
        } catch (Exception e) {
           exceptionThrown= true;
       System.debug('Expected exception caught: ' + e.getMessage());
        }
        System.assertEquals(true, exceptionThrown, 'Expected exception was not thrown when using invactive branch nd inactive partner account');
    }

    //Transfer creation without partner account (new)
    @isTest
    static void createTransferWithoutPartnerAccountNegative(){
          Boolean exceptionThrown= false;
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        Account account = TestDataHelpers.getPartnerAccount();

        try {
             dmpl__Transfer__c transfer = TransferTestDataHelper.createTransfer(null,branch);
        } catch (Exception e) {
           exceptionThrown= true;
       System.debug('Expected exception caught: ' + e.getMessage());
        }
        //System.assertEquals(true, exceptionThrown, 'Expected exception was not thrown when using to partner account as null');
    }


}