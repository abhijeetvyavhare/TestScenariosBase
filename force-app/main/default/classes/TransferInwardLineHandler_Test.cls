@isTest
public with sharing class TransferInwardLineHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Account partnerAccount = TestDataHelpers.createPartnerAccount();
        dmpl__Branch__c branch = TestDataHelpers.createBranch(partnerAccount);
        dmpl__Transfer__c transfer = TransferTestDataHelper.createTransfer(partnerAccount,branch);
        dmpl__Item__c item = TestDataHelpers.createItem();
        dmpl__TransferOutwardLine__c transferOutwardLine = TransferTestDataHelper.createTransferOutwardLine(transfer,item);
        dmpl__TransferInwardLine__c transferInwardLine = TransferTestDataHelper.createTransferInwardLine(transferOutwardLine,transfer,branch);
    
    }

    @isTest
    static void createTransferInwardLinePositive() {
        dmpl__TransferInwardLine__c line = TransferTestDataHelper.getTransferInwardLine();
        if (line != null) {
            System.assertNotEquals(line, null, 'Expected TransferInwardLine to be created.');
            System.assertEquals(1, line.dmpl__Quantity__c, 'Quantity should be 1');
            System.assertNotEquals(line.dmpl__TransferId__c, null, 'TransferId should not be null');
            System.assertNotEquals(line.dmpl__BranchId__c, null, 'BranchId should not be null');
        }
    }

    @isTest
    static void updateTransferInwardLinePositive() {
        dmpl__TransferInwardLine__c line = TransferTestDataHelper.getTransferInwardLine();
        System.assertNotEquals(line, null, 'TransferInwardLine should exist before update.');
        line.dmpl__Quantity__c = 5;
        update line;
        dmpl__TransferInwardLine__c updatedLine = TransferTestDataHelper.getTransferInwardLine();
        System.assertEquals(5, updatedLine.dmpl__Quantity__c, 'Quantity should be updated to 5');
    }

    @isTest
    static void deleteTransferInwardLineNegative() {
        dmpl__TransferInwardLine__c line = TransferTestDataHelper.getTransferInwardLine();
        System.assertNotEquals(line, null, 'TransferInwardLine should exist before delete.');
        Test.startTest();
        try {
            delete line;
            System.assert(false, 'Expected DML exception when deleting TransferInwardLine');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'), 
                'Expected FIELD_CUSTOM_VALIDATION_EXCEPTION error');
            System.assert(e.getMessage().contains('There are downstream transaction'), 
                'Error should mention downstream transactions');
        }
        Test.stopTest();
        dmpl__TransferInwardLine__c nonDeletedLine = TransferTestDataHelper.getTransferInwardLine();
        System.assertNotEquals(null, nonDeletedLine, 'TransferInwardLine should still exist after failed delete');
    }
}