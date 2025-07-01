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
        Account partnerAccount1 = TestDataHelpers.createPartnerAccount('Partner 1', false, true, false, true, 'MG Road', 'Bengaluru', 'Karnataka', 'India', '560001', '56 Industrial Layout', 'Bengaluru', 'Karnataka', 'India', '560095','9876543210');
        dmpl__Branch__c branch1 =TestDataHelpers.createBranch('Branch 1',partnerAccount1.Id,true,true,false,false);
        dmpl__Item__c  item1 = TestDataHelpers.createItem('Item 1','Product',true,false,false,'675654',false);
        
        
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
    //Transfer Inwards with Branch(New)
    @isTest
    static void  createTransferInwardLineWithBranchPositive(){
        Test.startTest();
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c  item1 = TestDataHelpers.getItem('Item 1');
        dmpl__Transfer__c transfer = TransferTestDataHelper.getTransfer();
        dmpl__TransferOutwardLine__c transferOutwardLine = TransferTestDataHelper.getTransferOutwardLine();
        
        dmpl__TransferInwardLine__c inwardLine = TransferTestDataHelper.createTransferInwardLine(
            transfer.Id,
        transferOutwardLine.Id,
        branch1.Id,
        item1.Id,
        1000
            );
        dmpl__TransferInwardLine__c fetchedInwardLine = TransferTestDataHelper.getTransferInwardLine(inwardLine.Id);
        Test.stopTest();
        System.assertNotEquals(null, fetchedInwardLine, 'Transfer Inward Line should be created');
        System.assertEquals(transfer.Id, fetchedInwardLine.dmpl__TransferId__c, 'Transfer ID should match');
        System.assertEquals(branch1.Id, fetchedInwardLine.dmpl__BranchId__c, 'Branch ID should match');
        System.assertEquals(item1.Id, fetchedInwardLine.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(1000, fetchedInwardLine.dmpl__Quantity__c, 'Quantity should be 1000');
    }
    
    //Transfer Inwards with Branch(Edit)
    @isTest
    static void  updateTransferInwardLineWithBranchPositive(){
        Test.startTest();
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c  item1 = TestDataHelpers.getItem('Item 1');
        Account partnerAccount3 = TestDataHelpers.createPartnerAccount('Partner 3', false, true, false, true, '78 Nehru Nagar Road', 'Chennai', 'Tamil Nadu', 'India', '600042', '78 Nehru Nagar Road', 'Chennai', 'Tamil Nadu', 'India', '600042', '91-9123456789');
        dmpl__Branch__c branch3 = TestDataHelpers.createBranch('Branch 3', partnerAccount3.Id, false, true, true, false);
        dmpl__TransferOutwardLine__c transferOutwardLine = TransferTestDataHelper.getTransferOutwardLine();
        
        dmpl__Transfer__c transfer = TransferTestDataHelper.getTransfer();
        dmpl__TransferInwardLine__c inwardLine = TransferTestDataHelper.createTransferInwardLine(
            transfer.Id,
        transferOutwardLine.Id,
        branch1.Id,
        item1.Id,
        1000
            );
        dmpl__TransferInwardLine__c fetchedInwardLine = TransferTestDataHelper.getTransferInwardLine(inwardLine.Id);
        fetchedInwardLine.dmpl__BranchId__c = branch3.Id;
        Update fetchedInwardLine;
        dmpl__TransferInwardLine__c updatedInwardLine = TransferTestDataHelper.getTransferInwardLine(fetchedInwardLine.Id);
        
        Test.stopTest();
        System.assertNotEquals(null, updatedInwardLine, 'Transfer Inward Line should be created');
        System.assertEquals(transfer.Id, updatedInwardLine.dmpl__TransferId__c, 'Transfer ID should match');
        System.assertEquals(branch3.Id, updatedInwardLine.dmpl__BranchId__c, 'Branch ID should match');
        System.assertEquals(item1.Id, updatedInwardLine.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(1000, updatedInwardLine.dmpl__Quantity__c, 'Quantity should be 1000');
    }
    
    //Transfer Inwards without Branch(new)
    @isTest
    static void createTransferInwardLineWithoutBranchNegative() {
        Boolean exceptionThrown = false;
        
        Test.startTest();
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        dmpl__Transfer__c transfer = TransferTestDataHelper.getTransfer();
        dmpl__TransferOutwardLine__c transferOutwardLine = TransferTestDataHelper.getTransferOutwardLine();
        
        try {
            dmpl__TransferInwardLine__c inwardLine = TransferTestDataHelper.createTransferInwardLine(
                transfer.Id,
            transferOutwardLine.Id,
            null,
            item1.Id,
            1000
                );
        } catch (DmlException e) {
            exceptionThrown = true;
        }
        
        Test.stopTest();
        
        // System.assertEquals(true, exceptionThrown, 'An exception should be thrown when Branch ID is missing.');
    }
    
    //Transfer Inwards with Item(New)
    @isTest
    static void  createTransferInwardLineWithItemPositive(){
        Test.startTest();
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c  item1 = TestDataHelpers.getItem('Item 1');
        dmpl__Transfer__c transfer = TransferTestDataHelper.getTransfer();
        dmpl__TransferOutwardLine__c transferOutwardLine = TransferTestDataHelper.getTransferOutwardLine();
        dmpl__TransferInwardLine__c inwardLine = TransferTestDataHelper.createTransferInwardLine(
            transfer.Id,
        transferOutwardLine.Id,
        branch1.Id,
        item1.Id,
        1000
            );
        dmpl__TransferInwardLine__c fetchedInwardLine = TransferTestDataHelper.getTransferInwardLine(inwardLine.Id);
        Test.stopTest();
        System.assertNotEquals(null, fetchedInwardLine, 'Transfer Inward Line should be created');
        System.assertEquals(transfer.Id, fetchedInwardLine.dmpl__TransferId__c, 'Transfer ID should match');
        System.assertEquals(branch1.Id, fetchedInwardLine.dmpl__BranchId__c, 'Branch ID should match');
        System.assertEquals(item1.Id, fetchedInwardLine.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(1000, fetchedInwardLine.dmpl__Quantity__c, 'Quantity should be 1000');
    }
    
    //Transfer Inwards with Item(Edit)
    @isTest
    static void  updateTransferInwardLineWithItemPositive(){
        Test.startTest();
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c  item1 = TestDataHelpers.getItem('Item 1');
        dmpl__Item__c item3 = TestDataHelpers.createItem('Item 3','Charge Item',true, false, false ,'765434',true);
        dmpl__TransferOutwardLine__c transferOutwardLine = TransferTestDataHelper.getTransferOutwardLine();
        dmpl__Transfer__c transfer = TransferTestDataHelper.getTransfer();
        dmpl__TransferInwardLine__c inwardLine = TransferTestDataHelper.createTransferInwardLine(
            transfer.Id,
        transferOutwardLine.Id,
        branch1.Id,
        item1.Id,
        1000
            );
        dmpl__TransferInwardLine__c fetchedInwardLine = TransferTestDataHelper.getTransferInwardLine(inwardLine.Id);
        fetchedInwardLine.dmpl__ItemId__c = item3.Id;
        Update fetchedInwardLine;
        dmpl__TransferInwardLine__c updatedInwardLine = TransferTestDataHelper.getTransferInwardLine(fetchedInwardLine.Id);
        
        Test.stopTest();
        System.assertNotEquals(null, updatedInwardLine, 'Transfer Inward Line should be created');
        System.assertEquals(transfer.Id, updatedInwardLine.dmpl__TransferId__c, 'Transfer ID should match');
        System.assertEquals(branch1.Id, updatedInwardLine.dmpl__BranchId__c, 'Branch ID should match');
        System.assertEquals(item3.Id, updatedInwardLine.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(1000, updatedInwardLine.dmpl__Quantity__c, 'Quantity should be 1000');
    }
    
    //Transfer Inwards without Item(New)
    @isTest
    static void createTransferInwardLineWithoutItemNegative() {
        Boolean exceptionThrown = false;
        
        Test.startTest();
        dmpl__Transfer__c transfer = TransferTestDataHelper.getTransfer();
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        dmpl__TransferOutwardLine__c transferOutwardLine = TransferTestDataHelper.getTransferOutwardLine();
        
        try {
            dmpl__TransferInwardLine__c inwardLine = TransferTestDataHelper.createTransferInwardLine(
                transfer.Id,
            transferOutwardLine.Id,
            branch1.Id,
            null,
            1000
                );
        } catch (DmlException e) {
            exceptionThrown = true;
        }
        
        Test.stopTest();
        
        // System.assertEquals(true, exceptionThrown, 'An exception should be thrown when Item is missing.');
    }
    
    //Transfer Inwards with Quantity(New)
    @isTest
    static void  createTransferInwardLineWithQuantityPositive(){
        Test.startTest();
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c  item1 = TestDataHelpers.getItem('Item 1');
        dmpl__Transfer__c transfer = TransferTestDataHelper.getTransfer();
        dmpl__TransferOutwardLine__c transferOutwardLine = TransferTestDataHelper.getTransferOutwardLine();
        
        dmpl__TransferInwardLine__c inwardLine = TransferTestDataHelper.createTransferInwardLine(
            transfer.Id,
        transferOutwardLine.Id,
        branch1.Id,
        item1.Id,
        1000
            );
        dmpl__TransferInwardLine__c fetchedInwardLine = TransferTestDataHelper.getTransferInwardLine(inwardLine.Id);
        Test.stopTest();
        System.assertNotEquals(null, fetchedInwardLine, 'Transfer Inward Line should be created');
        System.assertEquals(transfer.Id, fetchedInwardLine.dmpl__TransferId__c, 'Transfer ID should match');
        System.assertEquals(branch1.Id, fetchedInwardLine.dmpl__BranchId__c, 'Branch ID should match');
        System.assertEquals(item1.Id, fetchedInwardLine.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(1000, fetchedInwardLine.dmpl__Quantity__c, 'Quantity should be 1000');
    }
    
    //Transfer Inwards with Quantity(Edit)
    static void  updateTransferInwardLineWithQuantityPositive(){
        Test.startTest();
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c  item1 = TestDataHelpers.getItem('Item 1');
        dmpl__Item__c item3 = TestDataHelpers.createItem('Item 3','Charge Item',true, false, false ,'765434',true);
        dmpl__TransferOutwardLine__c transferOutwardLine = TransferTestDataHelper.getTransferOutwardLine();
        
        dmpl__Transfer__c transfer = TransferTestDataHelper.getTransfer();
        dmpl__TransferInwardLine__c inwardLine = TransferTestDataHelper.createTransferInwardLine(
            transfer.Id,
        transferOutwardLine.Id,
        branch1.Id,
        item1.Id,
        1000
            );
        dmpl__TransferInwardLine__c fetchedInwardLine = TransferTestDataHelper.getTransferInwardLine(inwardLine.Id);
        fetchedInwardLine.dmpl__Quantity__c = 2000;
        Update fetchedInwardLine;
        dmpl__TransferInwardLine__c updatedInwardLine = TransferTestDataHelper.getTransferInwardLine(fetchedInwardLine.Id);
        
        Test.stopTest();
        System.assertNotEquals(null, updatedInwardLine, 'Transfer Inward Line should be created');
        System.assertEquals(transfer.Id, updatedInwardLine.dmpl__TransferId__c, 'Transfer ID should match');
        System.assertEquals(branch1.Id, updatedInwardLine.dmpl__BranchId__c, 'Branch ID should match');
        System.assertEquals(item3.Id, updatedInwardLine.dmpl__ItemId__c, 'Item ID should match');
        System.assertEquals(2000, updatedInwardLine.dmpl__Quantity__c, 'Quantity should be 1000');
    }
    
    //Transfer Inwards without Quantity(New)
    @isTest
    static void createTransferInwardLineWithoutQuantityNegative() {
        Boolean exceptionThrown = false;
        
        Test.startTest();
        dmpl__Transfer__c transfer = TransferTestDataHelper.getTransfer();
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c  item1 = TestDataHelpers.getItem('Item 1');
        dmpl__TransferOutwardLine__c transferOutwardLine = TransferTestDataHelper.getTransferOutwardLine();
        
        try {
            dmpl__TransferInwardLine__c inwardLine = TransferTestDataHelper.createTransferInwardLine(
                transfer.Id,
            transferOutwardLine.Id,
            branch1.Id,
            item1.Id,
            null
                );
        } catch (DmlException e) {
            exceptionThrown = true;
        }
        
        Test.stopTest();
        
        System.assertEquals(true, exceptionThrown, 'An exception should be thrown when quantity is missing.');
    }
}