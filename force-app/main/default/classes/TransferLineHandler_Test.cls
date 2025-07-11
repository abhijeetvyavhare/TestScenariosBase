@isTest
public with sharing class TransferLineHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Account partnerAccount = TestDataHelpers.createPartnerAccount();
        dmpl__Branch__c branch = TestDataHelpers.createBranch(partnerAccount);
        dmpl__Transfer__c transfer = TransferTestDataHelper.createTransfer(partnerAccount,branch);
        dmpl__TransferLine__c transferLine = TransferTestDataHelper.createTransferLine(transfer);


    }

    @isTest
    static void createTransferLinePositive() {
        dmpl__TransferLine__c transferLine = TransferTestDataHelper.getTransferLine();
        if (transferLine != null) {
            System.assertNotEquals(transferLine, null, 'Expected TransferLine to be created.');
            System.assertEquals(1, transferLine.dmpl__Quantity__c, 'Quantity should be 1');
            System.assertNotEquals(transferLine.dmpl__TransferId__c, null, 'TransferId should be set');
        } else {
            System.assert(false, 'TransferLine was not found during create test.');
        }
    }

    @isTest
    static void updateTransferLinePositive() {
        dmpl__TransferLine__c transferLine = TransferTestDataHelper.getTransferLine();
        System.assertNotEquals(transferLine, null, 'TransferLine should exist before update.');

        transferLine.dmpl__Quantity__c = 10;
        update transferLine;

        dmpl__TransferLine__c updatedTransferLine = TransferTestDataHelper.getTransferLine();
        System.assertEquals(10, updatedTransferLine.dmpl__Quantity__c, 'Expected Quantity to be updated to 10');
    }

     @isTest
     static void deleteTransferLineNegative() {
        dmpl__TransferLine__c transferLine = TransferTestDataHelper.getTransferLine();
        System.assertNotEquals(transferLine, null, 'TransferLine should exist before delete.');

        Test.startTest();
        try {
            delete transferLine;
            System.assert(false, 'Expected DML exception when deleting TransferLine');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('CANNOT_INSERT_UPDATE_ACTIVATE_ENTITY'), 
                'Expected CANNOT_INSERT_UPDATE_ACTIVATE_ENTITY error');
            System.assert(e.getMessage().contains('dmpl.TransferLineTrigger'), 
                'Error should be from TransferLineTrigger');
        }
        Test.stopTest();

       
        dmpl__TransferLine__c nonDeletedLine = TransferTestDataHelper.getTransferLine();
        System.assertNotEquals(null, nonDeletedLine, 'TransferLine should still exist after failed delete');
    }

	
}