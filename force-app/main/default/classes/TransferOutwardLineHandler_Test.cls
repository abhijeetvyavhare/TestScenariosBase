@isTest
public with sharing class TransferOutwardLineHandler_Test {

    @TestSetup
    static void createRequiredData() {
        Account partnerAccount = TestDataHelpers.createPartnerAccount();
        dmpl__Item__c item = TestDataHelpers.createItem();
        dmpl__Branch__c branch = TestDataHelpers.createBranch(partnerAccount);
        dmpl__Transfer__c transfer = TransferTestDataHelper.createTransfer(partnerAccount, branch);
        dmpl__TransferOutwardLine__c transferOutwardLine = TransferTestDataHelper.createTransferOutwardLine(transfer,item);
    }

    @isTest
    static void createTransferOutwardLinePositive() {
        dmpl__TransferOutwardLine__c outwardLine = TransferTestDataHelper.getTransferOutwardLine();
        System.assertNotEquals(null, outwardLine, 'TransferOutwardLine should be created');
        System.assertEquals(1, outwardLine.dmpl__Quantity__c, 'Quantity should be 1');
        System.assertEquals(10, outwardLine.dmpl__UnitCost__c, 'UnitCost should be 10');
        System.assertNotEquals(null, outwardLine.dmpl__TransferId__c, 'TransferId should be populated');
    }

    @isTest
    static void updateTransferOutwardLinePositive() {
        dmpl__TransferOutwardLine__c outwardLine = TransferTestDataHelper.getTransferOutwardLine();
        System.assertNotEquals(null, outwardLine, 'TransferOutwardLine should exist before update');

        outwardLine.dmpl__Quantity__c = 5;
        outwardLine.dmpl__UnitCost__c = 20;
        update outwardLine;

        dmpl__TransferOutwardLine__c updatedOutwardLine = TransferTestDataHelper.getTransferOutwardLine();
        System.assertEquals(5, updatedOutwardLine.dmpl__Quantity__c, 'Expected updated Quantity value');
        System.assertEquals(20, updatedOutwardLine.dmpl__UnitCost__c, 'Expected updated UnitCost value');
    }

   
     @isTest
    static void deleteTransferOutwardLineNegative() {
        dmpl__TransferOutwardLine__c outwardLine = TransferTestDataHelper.getTransferOutwardLine();
        System.assertNotEquals(null, outwardLine, 'TransferOutwardLine should exist before delete');

        Test.startTest();
        try {
            delete outwardLine;
            System.assert(false, 'Expected DML exception when deleting TransferOutwardLine');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('CANNOT_INSERT_UPDATE_ACTIVATE_ENTITY'), 
                'Expected CANNOT_INSERT_UPDATE_ACTIVATE_ENTITY error');
            System.assert(e.getMessage().contains('dmpl.TransferOutwardLineTrigger'), 
                'Error should be from TransferOutwardLineTrigger');
        }
        Test.stopTest();

      
        dmpl__TransferOutwardLine__c nonDeletedLine = TransferTestDataHelper.getTransferOutwardLine();
        System.assertNotEquals(null, nonDeletedLine, 'TransferOutwardLine should still exist after failed delete');
    }
}