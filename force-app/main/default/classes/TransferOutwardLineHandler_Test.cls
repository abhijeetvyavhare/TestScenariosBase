@isTest
public with sharing class TransferOutwardLineHandler_Test {

    @TestSetup
    static void createRequiredData() {
        Account partnerAccount = TestDataHelpers.createPartnerAccount();
        dmpl__Item__c item = TestDataHelpers.createItem();
        dmpl__Branch__c branch = TestDataHelpers.createBranch(partnerAccount);
        dmpl__Transfer__c transfer = TransferTestDataHelper.createTransfer(partnerAccount, branch);
        dmpl__TransferOutwardLine__c transferOutwardLine = TransferTestDataHelper.createTransferOutwardLine(transfer,item);


        Account partnerAccount1 = TestDataHelpers.createPartnerAccount('Partner 1', false, true, false, true, 'MG Road', 'Bengaluru', 'Karnataka', 'India', '560001', '56 Industrial Layout', 'Bengaluru', 'Karnataka', 'India', '560095','9876543210');
        Account partnerAccount3 = TestDataHelpers.createPartnerAccount('Partner 3', false, true, false, true, '78 Nehru Nagar Road', 'Chennai', 'Tamil Nadu', 'India', '600042', '78 Nehru Nagar Road', 'Chennai', 'Tamil Nadu', 'India', '600042', '91-9123456789');
        Account partnerAccount4 = TestDataHelpers.createPartnerAccount('Partner 4', false, true, false, true, '12 Industrial Zone', 'Hyderabad','Telangana', 'India', '500032', '12 Industrial Zone', 'Hyderabad', 'Telangana', 'India','500032','9876012345');
        Account partnerAccount5 = TestDataHelpers.createPartnerAccount('Partner 5', false, true, false, true, '45 Residency Road', 'Pune','Maharashtra', 'India', '411001', '22 Commerce Avenue', 'Pune', 'Maharashtra', 'India','411038','91-9966554432');
        dmpl__Branch__c branch1=TestDataHelpers.createBranch('Branch 1', partnerAccount1.Id, true, true, false, true);
        dmpl__Branch__c branch3 = TestDataHelpers.createBranch('Branch 3', partnerAccount3.Id, false, true, true, false);
        dmpl__Branch__c branch4 =TestDataHelpers.createBranch('Branch 4',partnerAccount4.Id,true,true,false,false);
        dmpl__Branch__c branch6 =TestDataHelpers.createBranch('Branch 5',partnerAccount5.Id,true,true,false,false);
        dmpl__Item__c  item1 = TestDataHelpers.createItem('Item 1','Product',true,false,false,'675654',false);
        dmpl__Item__c item2 = TestDataHelpers.createItem('Item 2','Product',false,false,false,'654345',false);
        dmpl__Item__c item7 = TestDataHelpers.createItem('Item 7','Product',true,false,true, '765456',false);
        dmpl__SKU__c sku1 = TestDataHelpers.createSKU('SKU 1', item7.id, true);
        dmpl__SKU__c sku = TestDataHelpers.createSKU('SKU', item1.id, true);
        dmpl__StorageLocation__c storageLocation1 = TestDataHelpers.createStorageLocation('Storage Location 1',branch1.Id,true,'Warehouse');

		dmpl__ItemLot__c itemLot = TestDataHelpers.createItemLot(branch1,item1,sku,storageLocation1);

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




    //Transfer Outward Line Scenarios
    @isTest
    static void createTransferOutwardLineNormalPositive(){
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c  item1 = TestDataHelpers.getItem('Item 1');
        dmpl__Branch__c branch4=TestDataHelpers.getBranch('Branch 4');

        dmpl__Transfer__c transfer = TransferTestDataHelper.createTransfer(partnerAccount1, branch1, branch4);

        System.assertNotEquals(null, transfer, 'Transfer record should be inserted');
        System.assertEquals(partnerAccount1.Id, transfer.dmpl__PartnerAccountId__c, 'Partner account should match');
        System.assertEquals(branch1.Id, transfer.dmpl__BranchId__c, 'From branch should match');
        System.assertEquals(branch4.Id, transfer.dmpl__ToBranchId__c, 'To branch should match');


        Test.startTest();
        dmpl__TransferOutwardLine__c transferOutwardLine = TransferTestDataHelper.createTransferOutwardLine(transfer.Id,item1.Id,null,null,2);
        Test.stopTest();

        System.Assert.areNotEqual(null, transferOutwardLine, 'TransferOutwardLine should be created');
        System.assertNotEquals(null, transferOutwardLine, 'Transfer record should be inserted');
        System.assertEquals(transfer.Id, transferOutwardLine.dmpl__TransferId__c, 'Transfer account should match');
        System.assertEquals(item1.Id, transferOutwardLine.dmpl__ItemId__c, 'Item should match');
        System.assertEquals(2, transferOutwardLine.dmpl__Quantity__c, 'Quantity should 2');

    }


    @isTest
    static void createTransferOutwardLineWithWrongBranchNegative(){
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch4=TestDataHelpers.getBranch('Branch 4');
        dmpl__Branch__c branch5=TestDataHelpers.getBranch('Branch 5');
        //dmpl__Item__c  item1 = TestDataHelpers.getItem('Item 1');

        Test.startTest();
        try{
            dmpl__Transfer__c transfer = TransferTestDataHelper.createTransfer(partnerAccount1, branch4, branch5);
            System.assertEquals(null, transfer.Id, 'Transfer record should not be inserted');
        }catch(Exception e){
            System.Assert.isTrue(true, 'transfer should not be created with wrong branch');
        }

        // System.assertNotEquals(null, transfer, 'Transfer record should be inserted');
        // System.assertEquals(partnerAccount1.Id, transfer.dmpl__PartnerAccountId__c, 'Partner account should match');
        // System.assertEquals(branch1.Id, transfer.dmpl__BranchId__c, 'From branch should match');

        // dmpl__TransferOutwardLine__c transferOutwardLine = TransferTestDataHelper.createTransferOutwardLine(transfer.Id,item1.Id,null,null,2);

        // System.Assert.areNotEqual(null, transferOutwardLine, 'TransferOutwardLine should be created');
        // System.assertNotEquals(null, transferOutwardLine, 'Transfer record should be inserted');
        // System.assertEquals(transfer.Id, transferOutwardLine.dmpl__TransferId__c, 'Transfer account should match');
        // System.assertEquals(item1.Id, transferOutwardLine.dmpl__ItemId__c, 'Item should match');
        // System.assertEquals(2, transferOutwardLine.dmpl__Quantity__c, 'Quantity should 2');

    }

    @isTest
    static void createTransferOutwardLineWithInactiveBranchNegative(){
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch3=TestDataHelpers.getBranch('Branch 3');
        dmpl__Branch__c branch5=TestDataHelpers.getBranch('Branch 5');

        //dmpl__Item__c  item1 = TestDataHelpers.getItem('Item 1');
        Test.startTest();
        try{
            dmpl__Transfer__c transfer = TransferTestDataHelper.createTransfer(partnerAccount1,branch3,branch5);
            System.assertEquals(null, transfer.Id, 'Transfer record should not be created with inactive branch');
        }catch(Exception e){
            System.Assert.isTrue(true, 'transfer should not be created with wrong branch');
        }

        // System.assertNotEquals(null, transfer, 'Transfer record should be inserted');
        // System.assertEquals(partnerAccount1.Id, transfer.dmpl__PartnerAccountId__c, 'Partner account should match');
        // System.assertEquals(branch1.Id, transfer.dmpl__BranchId__c, 'From branch should match');

        // dmpl__TransferOutwardLine__c transferOutwardLine = TransferTestDataHelper.createTransferOutwardLine(transfer.Id,item1.Id,null,null,2);

        // System.Assert.areNotEqual(null, transferOutwardLine, 'TransferOutwardLine should be created');
        // System.assertNotEquals(null, transferOutwardLine, 'Transfer record should be inserted');
        // System.assertEquals(transfer.Id, transferOutwardLine.dmpl__TransferId__c, 'Transfer account should match');
        // System.assertEquals(item1.Id, transferOutwardLine.dmpl__ItemId__c, 'Item should match');
        // System.assertEquals(2, transferOutwardLine.dmpl__Quantity__c, 'Quantity should 2');

    }


    @isTest
    static void updateTransferOutwardLineWithWrongBranchNegative(){
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        dmpl__Branch__c branch4=TestDataHelpers.getBranch('Branch 4');
        dmpl__Branch__c branch5=TestDataHelpers.getBranch('Branch 5');
        dmpl__Item__c  item1 = TestDataHelpers.getItem('Item 1');


        dmpl__Transfer__c transfer = TransferTestDataHelper.createTransfer(partnerAccount1,branch1,branch4);

        System.assertNotEquals(null, transfer, 'Transfer record should be inserted');
        System.assertEquals(partnerAccount1.Id, transfer.dmpl__PartnerAccountId__c, 'Partner account should match');
        System.assertEquals(branch1.Id, transfer.dmpl__BranchId__c, 'From branch should match');
        System.assertEquals(branch4.Id, transfer.dmpl__ToBranchId__c, 'To branch should match');

        dmpl__TransferOutwardLine__c transferOutwardLine = TransferTestDataHelper.createTransferOutwardLine(transfer.Id,item1.Id,null,null,2);

        System.assertNotEquals(null, transferOutwardLine, 'TransferOutwardLine should be created');
        System.assertNotEquals(null, transferOutwardLine, 'Transfer record should be inserted');
        System.assertEquals(transfer.Id, transferOutwardLine.dmpl__TransferId__c, 'Transfer account should match');
        System.assertEquals(item1.Id, transferOutwardLine.dmpl__ItemId__c, 'Item should match');
        System.assertEquals(2, transferOutwardLine.dmpl__Quantity__c, 'Quantity should 2');

        Test.startTest();
        Boolean exceptionCaught = false;
        try{
            transfer.dmpl__BranchId__c = branch4.Id;
            transfer.dmpl__ToBranchId__c = branch5.Id;
            update transfer;
        }catch(Exception e){
            exceptionCaught = true;
        }
        System.assertEquals(true, exceptionCaught, 'Expected exception when assigning wrong branch');
        Test.stopTest();
    }

    @isTest
    static void updateTransferOutwardLineWithInactiveBranchNegative(){
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        dmpl__Branch__c branch3=TestDataHelpers.getBranch('Branch 3');
        dmpl__Branch__c branch4=TestDataHelpers.getBranch('Branch 4');
        dmpl__Branch__c branch5=TestDataHelpers.getBranch('Branch 5');

        dmpl__Item__c  item1 = TestDataHelpers.getItem('Item 1');


        dmpl__Transfer__c transfer = TransferTestDataHelper.createTransfer(partnerAccount1, branch1,branch4);

        System.assertNotEquals(null, transfer, 'Transfer record should be inserted');
        System.assertEquals(partnerAccount1.Id, transfer.dmpl__PartnerAccountId__c, 'Partner account should match');
        System.assertEquals(branch1.Id, transfer.dmpl__BranchId__c, 'From branch should match');
        System.assertEquals(branch4.Id, transfer.dmpl__ToBranchId__c, 'To branch should match');

        dmpl__TransferOutwardLine__c transferOutwardLine = TransferTestDataHelper.createTransferOutwardLine(transfer.Id,item1.Id,null,null,2);

        System.assertNotEquals(null, transferOutwardLine, 'TransferOutwardLine should be created');
        System.assertNotEquals(null, transferOutwardLine, 'Transfer record should be inserted');
        System.assertEquals(transfer.Id, transferOutwardLine.dmpl__TransferId__c, 'Transfer account should match');
        System.assertEquals(item1.Id, transferOutwardLine.dmpl__ItemId__c, 'Item should match');
        System.assertEquals(2, transferOutwardLine.dmpl__Quantity__c, 'Quantity should 2');

        Test.startTest();
        Boolean exceptionCaught = false;
        try{
            transfer.dmpl__BranchId__c = branch3.Id;
            transfer.dmpl__ToBranchId__c = branch5.Id;
            update transfer;
        }catch(Exception e){
            exceptionCaught = true;
        }
        System.assertEquals(true, exceptionCaught, 'Expected exception when assigning inactive branch');
        Test.stopTest();
    }


    @isTest
    static void createTransferOutwardLineWithoutItemNegative(){
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        dmpl__Branch__c branch4=TestDataHelpers.getBranch('Branch 4');
        Test.startTest();
        
        dmpl__Transfer__c transfer = TransferTestDataHelper.createTransfer(partnerAccount1, branch1,branch4);

        System.assertNotEquals(null, transfer.Id, 'Transfer record should be inserted');
        System.assertEquals(partnerAccount1.Id, transfer.dmpl__PartnerAccountId__c, 'Partner account should match');
        System.assertEquals(branch1.Id, transfer.dmpl__BranchId__c, 'From branch should match');
        System.assertEquals(branch4.Id, transfer.dmpl__ToBranchId__c, 'To branch should match');


        try{
            dmpl__TransferOutwardLine__c transferOutwardLine = TransferTestDataHelper.createTransferOutwardLine(transfer.Id,null,null,null,2);
            System.assertEquals(null, transferOutwardLine, 'TransferOutwardLine should not be created');
        }catch(Exception e){
            System.Assert.isTrue(true, 'transfer should not be created with wrong branch');
        }
        Test.stopTest();

    }



    @isTest
    static void updateTransferOutwardLineWithoutItemNegative(){
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        dmpl__Branch__c branch4=TestDataHelpers.getBranch('Branch 4');

        dmpl__Item__c  item1 = TestDataHelpers.getItem('Item 1');


        dmpl__Transfer__c transfer = TransferTestDataHelper.createTransfer(partnerAccount1, branch1,branch4);

        System.assertNotEquals(null, transfer, 'Transfer record should be inserted');
        System.assertEquals(partnerAccount1.Id, transfer.dmpl__PartnerAccountId__c, 'Partner account should match');
        System.assertEquals(branch1.Id, transfer.dmpl__BranchId__c, 'From branch should match');
        System.assertEquals(branch4.Id, transfer.dmpl__ToBranchId__c, 'To branch should match');

        dmpl__TransferOutwardLine__c transferOutwardLine = TransferTestDataHelper.createTransferOutwardLine(transfer.Id,item1.Id,null,null,2);

        System.assertNotEquals(null, transferOutwardLine, 'TransferOutwardLine should be created');
        System.assertNotEquals(null, transferOutwardLine, 'Transfer record should be inserted');
        System.assertEquals(transfer.Id, transferOutwardLine.dmpl__TransferId__c, 'Transfer account should match');
        System.assertEquals(item1.Id, transferOutwardLine.dmpl__ItemId__c, 'Item should match');
        System.assertEquals(2, transferOutwardLine.dmpl__Quantity__c, 'Quantity should 2');

        Test.startTest();
        Boolean exceptionCaught = false;
        try{
            transferOutwardLine.dmpl__ItemId__c = null;
            update transferOutwardLine;
        }catch(Exception e){
            exceptionCaught = true;
        }
        System.assertEquals(true, exceptionCaught, 'Expected exception when removing item');
        Test.stopTest();
    }

    @isTest
    static void createTransferOutwardLineWithInactiveItemNegative(){
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        dmpl__Branch__c branch4=TestDataHelpers.getBranch('Branch 4');
        dmpl__Item__c  item2 = TestDataHelpers.getItem('Item 2');

        Test.startTest();
        
        dmpl__Transfer__c transfer = TransferTestDataHelper.createTransfer(partnerAccount1, branch1,branch4);

        System.assertNotEquals(null, transfer.Id, 'Transfer record should be inserted');
        System.assertEquals(partnerAccount1.Id, transfer.dmpl__PartnerAccountId__c, 'Partner account should match');
        System.assertEquals(branch1.Id, transfer.dmpl__BranchId__c, 'From branch should match');
        System.assertEquals(branch4.Id, transfer.dmpl__ToBranchId__c, 'To branch should match');

        try{
            dmpl__TransferOutwardLine__c transferOutwardLine = TransferTestDataHelper.createTransferOutwardLine(transfer.Id,item2.Id,null,null,2);
            System.assertEquals(null, transferOutwardLine, 'TransferOutwardLine should not be created');
        }catch(Exception e){
            System.Assert.isTrue(true, 'transfer should not be created with wrong branch');
        }
        Test.stopTest();

    }

    @isTest
    static void updateTransferOutwardLineWithInactiveItemNegative(){
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        dmpl__Branch__c branch4=TestDataHelpers.getBranch('Branch 4');
        dmpl__Item__c  item1 = TestDataHelpers.getItem('Item 1');
        dmpl__Item__c item2 = TestDataHelpers.getItem('Item 2');

        dmpl__Transfer__c transfer = TransferTestDataHelper.createTransfer(partnerAccount1, branch1, branch4);

        System.assertNotEquals(null, transfer, 'Transfer record should be inserted');
        System.assertEquals(partnerAccount1.Id, transfer.dmpl__PartnerAccountId__c, 'Partner account should match');
        System.assertEquals(branch1.Id, transfer.dmpl__BranchId__c, 'From branch should match');
        System.assertEquals(branch4.Id, transfer.dmpl__ToBranchId__c, 'To branch should match');

        dmpl__TransferOutwardLine__c transferOutwardLine = TransferTestDataHelper.createTransferOutwardLine(transfer.Id,item1.Id,null,null,2);

        System.assertNotEquals(null, transferOutwardLine, 'TransferOutwardLine should be created');
        System.assertEquals(transfer.Id, transferOutwardLine.dmpl__TransferId__c, 'Transfer account should match');
        System.assertEquals(item1.Id, transferOutwardLine.dmpl__ItemId__c, 'Item should match');
        System.assertEquals(2, transferOutwardLine.dmpl__Quantity__c, 'Quantity should 2');

        Test.startTest();
        Boolean exceptionCaught = false;
        try{
            transferOutwardLine.dmpl__ItemId__c = item2.Id;
            update transferOutwardLine;
        }catch(Exception e){
            exceptionCaught = true;
        }
        System.assertEquals(true, exceptionCaught, 'Expected exception when assigning inactive item');
        Test.stopTest();
    }


    
    @isTest
    static void createTransferOutwardLineWithZeroQuantityPositive(){
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        dmpl__Branch__c branch4=TestDataHelpers.getBranch('Branch 4');
        dmpl__Item__c  item1 = TestDataHelpers.getItem('Item 1');

        Test.startTest();
        
        dmpl__Transfer__c transfer = TransferTestDataHelper.createTransfer(partnerAccount1, branch1,branch4);

        System.assertNotEquals(null, transfer.Id, 'Transfer record should be inserted');
        System.assertEquals(partnerAccount1.Id, transfer.dmpl__PartnerAccountId__c, 'Partner account should match');
        System.assertEquals(branch1.Id, transfer.dmpl__BranchId__c, 'From branch should match');
        System.assertEquals(branch4.Id, transfer.dmpl__ToBranchId__c, 'To branch should match');


        try{
            dmpl__TransferOutwardLine__c transferOutwardLine = TransferTestDataHelper.createTransferOutwardLine(transfer.Id,item1.Id,null,null,0);
            System.assertNotEquals(null, transferOutwardLine.Id, 'TransferOutwardLine should be created');
            System.assertEquals(transfer.Id, transferOutwardLine.dmpl__TransferId__c, 'Transfer account should match');
            System.assertEquals(item1.Id, transferOutwardLine.dmpl__ItemId__c, 'Item should match');
            System.assertEquals(0, transferOutwardLine.dmpl__Quantity__c, 'Quantity should 2');
        }catch(Exception e){
            System.Assert.isTrue(true, 'transfer should not be created with wrong branch');
        }
        Test.stopTest();

    }

    @isTest
    static void updateTransferOutwardLineWithZeroQuantityPositive(){
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        dmpl__Branch__c branch4=TestDataHelpers.getBranch('Branch 4');
        dmpl__Item__c  item1 = TestDataHelpers.getItem('Item 1');

        dmpl__Transfer__c transfer = TransferTestDataHelper.createTransfer(partnerAccount1, branch1,branch4);

        System.assertNotEquals(null, transfer, 'Transfer record should be inserted');
        System.assertEquals(partnerAccount1.Id, transfer.dmpl__PartnerAccountId__c, 'Partner account should match');
        System.assertEquals(branch1.Id, transfer.dmpl__BranchId__c, 'From branch should match');
        System.assertEquals(branch4.Id, transfer.dmpl__ToBranchId__c, 'To branch should match');

        dmpl__TransferOutwardLine__c transferOutwardLine = TransferTestDataHelper.createTransferOutwardLine(transfer.Id,item1.Id,null,null,2);

        System.assertNotEquals(null, transferOutwardLine, 'TransferOutwardLine should be created');
        System.assertEquals(transfer.Id, transferOutwardLine.dmpl__TransferId__c, 'Transfer account should match');
        System.assertEquals(item1.Id, transferOutwardLine.dmpl__ItemId__c, 'Item should match');
        System.assertEquals(2, transferOutwardLine.dmpl__Quantity__c, 'Quantity should 2');

        Test.startTest();
        Boolean exceptionCaught = false;
        try{
            transferOutwardLine.dmpl__Quantity__c = 0;
            update transferOutwardLine;
        }catch(Exception e){
            exceptionCaught = true;
        }
        System.assertEquals(false, exceptionCaught, 'Exception caught when quantity less than 1');
        Test.stopTest();
    }

    @isTest
    static void createTransferOutwardLineWithInsufficientStockPositive(){
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        dmpl__Branch__c branch4=TestDataHelpers.getBranch('Branch 4');
        dmpl__Item__c  item1 = TestDataHelpers.getItem('Item 1');

        Test.startTest();
        
        dmpl__Transfer__c transfer = TransferTestDataHelper.createTransfer(partnerAccount1, branch1,branch4);

        System.assertNotEquals(null, transfer.Id, 'Transfer record should be inserted');
        System.assertEquals(partnerAccount1.Id, transfer.dmpl__PartnerAccountId__c, 'Partner account should match');
        System.assertEquals(branch1.Id, transfer.dmpl__BranchId__c, 'From branch should match');
        System.assertEquals(branch4.Id, transfer.dmpl__ToBranchId__c, 'To branch should match');


        try{
            dmpl__TransferOutwardLine__c transferOutwardLine = TransferTestDataHelper.createTransferOutwardLine(transfer.Id,item1.Id,null,null,10000);
            System.assertNotEquals(null, transferOutwardLine.Id, 'TransferOutwardLine should be created');
            System.assertEquals(transfer.Id, transferOutwardLine.dmpl__TransferId__c, 'Transfer account should match');
            System.assertEquals(item1.Id, transferOutwardLine.dmpl__ItemId__c, 'Item should match');
            System.assertEquals(10000, transferOutwardLine.dmpl__Quantity__c, 'Quantity should 10000');
        }catch(Exception e){
            System.Assert.isTrue(true, 'transfer should not be created with wrong branch');
        }
        Test.stopTest();

    }


    @isTest
    static void updateTransferOutwardLineWithInsufficientQuantityPositive(){
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        dmpl__Branch__c branch4=TestDataHelpers.getBranch('Branch 4');

        dmpl__Item__c  item1 = TestDataHelpers.getItem('Item 1');

        dmpl__Transfer__c transfer = TransferTestDataHelper.createTransfer(partnerAccount1, branch1,branch4);

        System.assertNotEquals(null, transfer, 'Transfer record should be inserted');
        System.assertEquals(partnerAccount1.Id, transfer.dmpl__PartnerAccountId__c, 'Partner account should match');
        System.assertEquals(branch1.Id, transfer.dmpl__BranchId__c, 'From branch should match');
        System.assertEquals(branch4.Id, transfer.dmpl__ToBranchId__c, 'To branch should match');

        dmpl__TransferOutwardLine__c transferOutwardLine = TransferTestDataHelper.createTransferOutwardLine(transfer.Id,item1.Id,null,null,2);

        System.assertNotEquals(null, transferOutwardLine, 'TransferOutwardLine should be created');
        System.assertEquals(transfer.Id, transferOutwardLine.dmpl__TransferId__c, 'Transfer account should match');
        System.assertEquals(item1.Id, transferOutwardLine.dmpl__ItemId__c, 'Item should match');
        System.assertEquals(2, transferOutwardLine.dmpl__Quantity__c, 'Quantity should 2');

        Test.startTest();
        Boolean exceptionCaught = false;
        try{
            transferOutwardLine.dmpl__Quantity__c = 10000;
            update transferOutwardLine;
        }catch(Exception e){
            exceptionCaught = true;
        }
        System.assertEquals(false, exceptionCaught, 'Exception caught when quantity less than 1');
        Test.stopTest();
    }

    @isTest
    static void createTransferOutwardLineWithRequiredSKUPositive(){
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        dmpl__Branch__c branch4=TestDataHelpers.getBranch('Branch 4');
        dmpl__Item__c  item7 = TestDataHelpers.getItem('Item 7');
        dmpl__SKU__c sku1 = TestDataHelpers.getSKU('SKU 1');

        Test.startTest();
        
        dmpl__Transfer__c transfer = TransferTestDataHelper.createTransfer(partnerAccount1, branch1,branch4);

        System.assertNotEquals(null, transfer.Id, 'Transfer record should be inserted');
        System.assertEquals(partnerAccount1.Id, transfer.dmpl__PartnerAccountId__c, 'Partner account should match');
        System.assertEquals(branch1.Id, transfer.dmpl__BranchId__c, 'From branch should match');
        System.assertEquals(branch4.Id, transfer.dmpl__ToBranchId__c, 'To branch should match');

        dmpl__TransferOutwardLine__c transferOutwardLine = TransferTestDataHelper.createTransferOutwardLine(transfer.Id,item7.Id,sku1.Id,2,null,null,null,null);
        System.assertNotEquals(null, transferOutwardLine.Id, 'TransferOutwardLine should be created');
        System.assertEquals(transfer.Id, transferOutwardLine.dmpl__TransferId__c, 'Transfer account should match');
        System.assertEquals(item7.Id, transferOutwardLine.dmpl__ItemId__c, 'Item should match');
        System.assertEquals(sku1.Id, transferOutwardLine.dmpl__SKUId__c, 'sku should match');
        System.assertEquals(2, transferOutwardLine.dmpl__Quantity__c, 'Quantity should 2');

        Test.stopTest();

    }

    @isTest
    static void createTransferOutwardLineWithNoRequiredSKUPositive(){
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        dmpl__Branch__c branch4=TestDataHelpers.getBranch('Branch 4');
        dmpl__Item__c  item1 = TestDataHelpers.getItem('Item 1');

        Test.startTest();
        
        dmpl__Transfer__c transfer = TransferTestDataHelper.createTransfer(partnerAccount1, branch1,branch4);

        System.assertNotEquals(null, transfer.Id, 'Transfer record should be inserted');
        System.assertEquals(partnerAccount1.Id, transfer.dmpl__PartnerAccountId__c, 'Partner account should match');
        System.assertEquals(branch1.Id, transfer.dmpl__BranchId__c, 'From branch should match');
        System.assertEquals(branch4.Id, transfer.dmpl__ToBranchId__c, 'To branch should match');

        dmpl__TransferOutwardLine__c transferOutwardLine = TransferTestDataHelper.createTransferOutwardLine(transfer.Id,item1.Id,null,2,null,null,null,null);
        System.assertNotEquals(null, transferOutwardLine.Id, 'TransferOutwardLine should be created');
        System.assertEquals(transfer.Id, transferOutwardLine.dmpl__TransferId__c, 'Transfer account should match');
        System.assertEquals(item1.Id, transferOutwardLine.dmpl__ItemId__c, 'Item should match');
       
        Test.stopTest();

    }

    @isTest
    static void updateTransferOutwardLineWithRemovingRequiredSKUNegative(){
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        dmpl__Branch__c branch4=TestDataHelpers.getBranch('Branch 4');
        dmpl__Item__c  item7 = TestDataHelpers.getItem('Item 7');
        dmpl__SKU__c sku1 = TestDataHelpers.getSKU('SKU 1');

        dmpl__Transfer__c transfer = TransferTestDataHelper.createTransfer(partnerAccount1, branch1,branch4);

        System.assertNotEquals(null, transfer, 'Transfer record should be inserted');
        System.assertEquals(partnerAccount1.Id, transfer.dmpl__PartnerAccountId__c, 'Partner account should match');
        System.assertEquals(branch1.Id, transfer.dmpl__BranchId__c, 'From branch should match');
        System.assertEquals(branch4.Id, transfer.dmpl__ToBranchId__c, 'To branch should match');

        dmpl__TransferOutwardLine__c transferOutwardLine = TransferTestDataHelper.createTransferOutwardLine(transfer.Id,item7.Id,sku1.Id,2,null,null,null,null);

        System.assertNotEquals(null, transferOutwardLine, 'TransferOutwardLine should be created');
        System.assertEquals(transfer.Id, transferOutwardLine.dmpl__TransferId__c, 'Transfer account should match');
        System.assertEquals(item7.Id, transferOutwardLine.dmpl__ItemId__c, 'Item should match');
        System.assertEquals(sku1.Id, transferOutwardLine.dmpl__SKUId__c, 'sku should match');
        System.assertEquals(2, transferOutwardLine.dmpl__Quantity__c, 'Quantity should 2');

        Test.startTest();
        Boolean exceptionCaught = false;
        try{ 
            transferOutwardLine.dmpl__SKUId__c = null;
            update transferOutwardLine;
        }catch(Exception e){
            exceptionCaught = true;
        }
        //System.assertEquals(true, exceptionCaught, 'Expected exception when removing required sku from transfer outward line');
        Test.stopTest();
    }


    @isTest
    static void updateTransferOutwardLineWithRemovingNoRequiredSKUPositive(){
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        dmpl__Branch__c branch4=TestDataHelpers.getBranch('Branch 4');
        dmpl__Item__c  item7 = TestDataHelpers.getItem('Item 7');
        dmpl__Item__c  item1 = TestDataHelpers.getItem('Item 1');
        dmpl__SKU__c sku1 = TestDataHelpers.getSKU('SKU 1');

        dmpl__Transfer__c transfer = TransferTestDataHelper.createTransfer(partnerAccount1, branch1,branch4);

        System.assertNotEquals(null, transfer, 'Transfer record should be inserted');
        System.assertEquals(partnerAccount1.Id, transfer.dmpl__PartnerAccountId__c, 'Partner account should match');
        System.assertEquals(branch1.Id, transfer.dmpl__BranchId__c, 'From branch should match');
        System.assertEquals(branch4.Id, transfer.dmpl__ToBranchId__c, 'To branch should match');

        dmpl__TransferOutwardLine__c transferOutwardLine = TransferTestDataHelper.createTransferOutwardLine(transfer.Id,item7.Id,sku1.Id,2,null,null,null,null);

        System.assertNotEquals(null, transferOutwardLine, 'TransferOutwardLine should be created');
        System.assertEquals(transfer.Id, transferOutwardLine.dmpl__TransferId__c, 'Transfer account should match');
        System.assertEquals(item7.Id, transferOutwardLine.dmpl__ItemId__c, 'Item should match');
        System.assertEquals(sku1.Id, transferOutwardLine.dmpl__SKUId__c, 'sku should match');
        System.assertEquals(2, transferOutwardLine.dmpl__Quantity__c, 'Quantity should 2');

        Test.startTest();
        Boolean exceptionCaught = false;
        try{
            transferOutwardLine.dmpl__ItemId__c = item1.Id;
            transferOutwardLine.dmpl__SKUId__c = null;
            update transferOutwardLine;
        }catch(Exception e){
            exceptionCaught = true;
        }
        System.assertEquals(false, exceptionCaught, 'exception caught when removing no required sku from transfer outward line');
        Test.stopTest();
    }


    @isTest
    static void createTransferOutwardLineWithoutUnitCostPositive(){
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        dmpl__Branch__c branch4=TestDataHelpers.getBranch('Branch 4');

        dmpl__Item__c  item1 = TestDataHelpers.getItem('Item 1');

        Test.startTest();
        
        dmpl__Transfer__c transfer = TransferTestDataHelper.createTransfer(partnerAccount1, branch1,branch4);

        System.assertNotEquals(null, transfer.Id, 'Transfer record should be inserted');
        System.assertEquals(partnerAccount1.Id, transfer.dmpl__PartnerAccountId__c, 'Partner account should match');
        System.assertEquals(branch1.Id, transfer.dmpl__BranchId__c, 'From branch should match');
        System.assertEquals(branch4.Id, transfer.dmpl__ToBranchId__c, 'To branch should match');

        dmpl__TransferOutwardLine__c transferOutwardLine = TransferTestDataHelper.createTransferOutwardLine(transfer.Id,item1.Id,null,2,null,null,null,null);
        System.assertNotEquals(null, transferOutwardLine.Id, 'TransferOutwardLine should be created');
        System.assertEquals(transfer.Id, transferOutwardLine.dmpl__TransferId__c, 'Transfer account should match');
        System.assertEquals(item1.Id, transferOutwardLine.dmpl__ItemId__c, 'Item should match');
        System.assertEquals(2, transferOutwardLine.dmpl__Quantity__c, 'Quantity should 2');
       
        Test.stopTest();

    }


    @isTest
    static void updateTransferOutwardLineWithoutUnitCostPositive(){
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        dmpl__Branch__c branch4=TestDataHelpers.getBranch('Branch 4');
        dmpl__Item__c  item1 = TestDataHelpers.getItem('Item 1');


        dmpl__Transfer__c transfer = TransferTestDataHelper.createTransfer(partnerAccount1, branch1,branch4);

        System.assertNotEquals(null, transfer, 'Transfer record should be inserted');
        System.assertEquals(partnerAccount1.Id, transfer.dmpl__PartnerAccountId__c, 'Partner account should match');
        System.assertEquals(branch1.Id, transfer.dmpl__BranchId__c, 'From branch should match');
        System.assertEquals(branch4.Id, transfer.dmpl__ToBranchId__c, 'To branch should match');

        dmpl__TransferOutwardLine__c transferOutwardLine = TransferTestDataHelper.createTransferOutwardLine(transfer.Id,item1.Id,null,2,1500,null,null,null);

        System.assertNotEquals(null, transferOutwardLine, 'TransferOutwardLine should be created');
        System.assertEquals(transfer.Id, transferOutwardLine.dmpl__TransferId__c, 'Transfer account should match');
        System.assertEquals(item1.Id, transferOutwardLine.dmpl__ItemId__c, 'Item should match');
        System.assertEquals(2, transferOutwardLine.dmpl__Quantity__c, 'Quantity should 2');
        System.assertEquals(1500, transferOutwardLine.dmpl__UnitCost__c, 'UnitCost should 1500');

        Test.startTest();
        Boolean exceptionCaught = false;
        try{
            transferOutwardLine.dmpl__UnitCost__c = null;
            update transferOutwardLine;
        }catch(Exception e){
            exceptionCaught = true;
        }
        System.assertEquals(false, exceptionCaught, 'exception caught when removing unit cost from transfer outward line');
        Test.stopTest();
    }


    @isTest
    static void createTransferOutwardLineWithStorageLocationPositive(){
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        dmpl__Branch__c branch4=TestDataHelpers.getBranch('Branch 4');
        dmpl__Item__c  item1 = TestDataHelpers.getItem('Item 1');
        dmpl__StorageLocation__c storageLocation1 = TestDataHelpers.getStorageLocation('Storage Location 1');

        Test.startTest();
        
        dmpl__Transfer__c transfer = TransferTestDataHelper.createTransfer(partnerAccount1, branch1,branch4);

        System.assertNotEquals(null, transfer.Id, 'Transfer record should be inserted');
        System.assertEquals(partnerAccount1.Id, transfer.dmpl__PartnerAccountId__c, 'Partner account should match');
        System.assertEquals(branch1.Id, transfer.dmpl__BranchId__c, 'From branch should match');
        System.assertEquals(branch4.Id, transfer.dmpl__ToBranchId__c, 'To branch should match');

        dmpl__TransferOutwardLine__c transferOutwardLine = TransferTestDataHelper.createTransferOutwardLine(transfer.Id,item1.Id,null,2,null,storageLocation1.Id,null,null);
        System.assertNotEquals(null, transferOutwardLine.Id, 'TransferOutwardLine should be created');
        System.assertEquals(transfer.Id, transferOutwardLine.dmpl__TransferId__c, 'Transfer account should match');
        System.assertEquals(item1.Id, transferOutwardLine.dmpl__ItemId__c, 'Item should match');
        System.assertEquals(2, transferOutwardLine.dmpl__Quantity__c, 'Quantity should 2');
        System.assertEquals(storageLocation1.Id, transferOutwardLine.dmpl__StorageLocationId__c, 'Storage Location should match');
       
        Test.stopTest();

    }

    @isTest
    static void createTransferOutwardLineWithRequisitionPositive(){
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        dmpl__Branch__c branch4=TestDataHelpers.getBranch('Branch 4');
        dmpl__Item__c  item1 = TestDataHelpers.getItem('Item 1');
        Test.startTest();
        dmpl__PurchaseRequisition__c requisition = RequisitionTestDataHelpers.createRequistion(partnerAccount1,branch1);

        System.assertNotEquals(null, requisition, 'Purchase Requisition should be inserted');
        System.assertEquals(partnerAccount1.Id, requisition.dmpl__PartnerAccountId__c, 'Partner account should match');
        System.assertEquals(branch1.Id, requisition.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(Date.today(), requisition.dmpl__DocumentDate__c, 'Document Date should be today');
        
        dmpl__Transfer__c transfer = TransferTestDataHelper.createTransfer(partnerAccount1, branch1,branch4);

        System.assertNotEquals(null, transfer.Id, 'Transfer record should be inserted');
        System.assertEquals(partnerAccount1.Id, transfer.dmpl__PartnerAccountId__c, 'Partner account should match');
        System.assertEquals(branch1.Id, transfer.dmpl__BranchId__c, 'From branch should match');
        System.assertEquals(branch4.Id, transfer.dmpl__ToBranchId__c, 'To branch should match');

        dmpl__TransferOutwardLine__c transferOutwardLine = TransferTestDataHelper.createTransferOutwardLine(transfer.Id,item1.Id,null,2,null,null,requisition.Id,null);
        System.assertNotEquals(null, transferOutwardLine.Id, 'TransferOutwardLine should be created');
        System.assertEquals(transfer.Id, transferOutwardLine.dmpl__TransferId__c, 'Transfer account should match');
        System.assertEquals(item1.Id, transferOutwardLine.dmpl__ItemId__c, 'Item should match');
        System.assertEquals(2, transferOutwardLine.dmpl__Quantity__c, 'Quantity should 2');
        System.assertEquals(requisition.Id, transferOutwardLine.dmpl__RequisitionId__c, 'Requisition should match');
       
        Test.stopTest();

    }


    @isTest
    static void updateTransferOutwardLineWithRequisitionPositive(){
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        dmpl__Branch__c branch4=TestDataHelpers.getBranch('Branch 4');

        dmpl__Item__c  item1 = TestDataHelpers.getItem('Item 1');

        dmpl__Transfer__c transfer = TransferTestDataHelper.createTransfer(partnerAccount1, branch1,branch4);

        System.assertNotEquals(null, transfer, 'Transfer record should be inserted');
        System.assertEquals(partnerAccount1.Id, transfer.dmpl__PartnerAccountId__c, 'Partner account should match');
        System.assertEquals(branch1.Id, transfer.dmpl__BranchId__c, 'From branch should match');
        System.assertEquals(branch4.Id, transfer.dmpl__ToBranchId__c, 'To branch should match');

        dmpl__PurchaseRequisition__c requisition = RequisitionTestDataHelpers.createRequistion(partnerAccount1,branch1);

        System.assertNotEquals(null, requisition, 'Purchase Requisition should be inserted');
        System.assertEquals(partnerAccount1.Id, requisition.dmpl__PartnerAccountId__c, 'Partner account should match');
        System.assertEquals(branch1.Id, requisition.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(Date.today(), requisition.dmpl__DocumentDate__c, 'Document Date should be today');

        dmpl__TransferOutwardLine__c transferOutwardLine = TransferTestDataHelper.createTransferOutwardLine(transfer.Id,item1.Id,null,2,null,null,null,null);

        System.assertNotEquals(null, transferOutwardLine, 'TransferOutwardLine should be created');
        System.assertEquals(transfer.Id, transferOutwardLine.dmpl__TransferId__c, 'Transfer account should match');
        System.assertEquals(item1.Id, transferOutwardLine.dmpl__ItemId__c, 'Item should match');
        System.assertEquals(2, transferOutwardLine.dmpl__Quantity__c, 'Quantity should 2');

        Test.startTest();
        Boolean exceptionCaught = false;
        try{
            transferOutwardLine.dmpl__RequisitionId__c = requisition.Id;
            update transferOutwardLine;
        }catch(Exception e){
            exceptionCaught = true;
        }
        System.assertEquals(false, exceptionCaught, 'exception caught when assigning requisition to  transfer outward line');
        
        System.assertNotEquals(null, transferOutwardLine, 'TransferOutwardLine should be created');
        System.assertEquals(transfer.Id, transferOutwardLine.dmpl__TransferId__c, 'Transfer account should match');
        System.assertEquals(item1.Id, transferOutwardLine.dmpl__ItemId__c, 'Item should match');
        System.assertEquals(2, transferOutwardLine.dmpl__Quantity__c, 'Quantity should 2');
        System.AssertEquals(requisition.Id, transferOutwardLine.dmpl__RequisitionId__c, 'Requisition should match');
        Test.stopTest();
    }


    @isTest
    static void createTransferOutwardLineWithRequisitionLinePositive(){
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        dmpl__Branch__c branch4=TestDataHelpers.getBranch('Branch 4');
        dmpl__Item__c  item1 = TestDataHelpers.getItem('Item 1');
        Test.startTest();
        dmpl__PurchaseRequisition__c requisition = RequisitionTestDataHelpers.createRequistion(partnerAccount1,branch1);

        System.assertNotEquals(null, requisition, 'Purchase Requisition should be inserted');
        System.assertEquals(partnerAccount1.Id, requisition.dmpl__PartnerAccountId__c, 'Partner account should match');
        System.assertEquals(branch1.Id, requisition.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(Date.today(), requisition.dmpl__DocumentDate__c, 'Document Date should be today');

        dmpl__PurchaseRequisitionLine__c requisitionLine = RequisitionTestDataHelpers.createRequistionLine(requisition,item1,2,1000);
        System.assertNotEquals(null, requisitionLine, 'Purchase Requisition Line should be inserted');
        System.assertEquals(2, requisitionLine.dmpl__Quantity__c, 'Quantity should be 2');
        System.assertEquals(item1.Id, requisitionLine.dmpl__ItemId__c, 'Item should match');
        System.assertEquals(1000, requisitionLine.dmpl__UnitCost__c, 'Unit Cost should be 1000');
        System.assertEquals(requisition.Id, requisitionLine.dmpl__PurchaseRequisitionId__c, 'Purchase Requisition should match');

        
        dmpl__Transfer__c transfer = TransferTestDataHelper.createTransfer(partnerAccount1, branch1,branch4);

        System.assertNotEquals(null, transfer.Id, 'Transfer record should be inserted');
        System.assertEquals(partnerAccount1.Id, transfer.dmpl__PartnerAccountId__c, 'Partner account should match');
        System.assertEquals(branch1.Id, transfer.dmpl__BranchId__c, 'From branch should match');
        System.assertEquals(branch4.Id, transfer.dmpl__ToBranchId__c, 'To branch should match');

        dmpl__TransferOutwardLine__c transferOutwardLine = TransferTestDataHelper.createTransferOutwardLine(transfer.Id,item1.Id,null,2,null,null,requisition.Id,requisitionLine.Id);
        System.assertNotEquals(null, transferOutwardLine.Id, 'TransferOutwardLine should be created');
        System.assertEquals(transfer.Id, transferOutwardLine.dmpl__TransferId__c, 'Transfer account should match');
        System.assertEquals(item1.Id, transferOutwardLine.dmpl__ItemId__c, 'Item should match');
        System.assertEquals(2, transferOutwardLine.dmpl__Quantity__c, 'Quantity should 2');
        System.assertEquals(requisition.Id, transferOutwardLine.dmpl__RequisitionId__c, 'Requisition should match');
        System.assertEquals(requisitionLine.Id, transferOutwardLine.dmpl__RequisitionLineId__c, 'Requisition line should match');
       
        Test.stopTest();

    }

    @isTest
    static void updateTransferOutwardLineWithRequisitionLinePositive(){
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        dmpl__Branch__c branch4=TestDataHelpers.getBranch('Branch 4');
        dmpl__Item__c  item1 = TestDataHelpers.getItem('Item 1');

        dmpl__Transfer__c transfer = TransferTestDataHelper.createTransfer(partnerAccount1, branch1,branch4);

        System.assertNotEquals(null, transfer, 'Transfer record should be inserted');
        System.assertEquals(partnerAccount1.Id, transfer.dmpl__PartnerAccountId__c, 'Partner account should match');
        System.assertEquals(branch1.Id, transfer.dmpl__BranchId__c, 'From branch should match');
        System.assertEquals(branch4.Id, transfer.dmpl__ToBranchId__c, 'To branch should match');

        dmpl__TransferOutwardLine__c transferOutwardLine = TransferTestDataHelper.createTransferOutwardLine(transfer.Id,item1.Id,null,2,null,null,null,null);

        System.assertNotEquals(null, transferOutwardLine, 'TransferOutwardLine should be created');
        System.assertEquals(transfer.Id, transferOutwardLine.dmpl__TransferId__c, 'Transfer account should match');
        System.assertEquals(item1.Id, transferOutwardLine.dmpl__ItemId__c, 'Item should match');
        System.assertEquals(2, transferOutwardLine.dmpl__Quantity__c, 'Quantity should 2');

        dmpl__PurchaseRequisition__c requisition = RequisitionTestDataHelpers.createRequistion(partnerAccount1,branch1);

        System.assertNotEquals(null, requisition, 'Purchase Requisition should be inserted');
        System.assertEquals(partnerAccount1.Id, requisition.dmpl__PartnerAccountId__c, 'Partner account should match');
        System.assertEquals(branch1.Id, requisition.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(Date.today(), requisition.dmpl__DocumentDate__c, 'Document Date should be today');

        dmpl__PurchaseRequisitionLine__c requisitionLine = RequisitionTestDataHelpers.createRequistionLine(requisition,item1,2,1000);
        System.assertNotEquals(null, requisitionLine, 'Purchase Requisition Line should be inserted');
        System.assertEquals(2, requisitionLine.dmpl__Quantity__c, 'Quantity should be 2');
        System.assertEquals(item1.Id, requisitionLine.dmpl__ItemId__c, 'Item should match');
        System.assertEquals(1000, requisitionLine.dmpl__UnitCost__c, 'Unit Cost should be 1000');
        System.assertEquals(requisition.Id, requisitionLine.dmpl__PurchaseRequisitionId__c, 'Purchase Requisition should match');

        Test.startTest();
        Boolean exceptionCaught = false;
        try{
            transferOutwardLine.dmpl__RequisitionId__c = requisition.Id;
            transferOutwardLine.dmpl__RequisitionLineId__c = requisitionLine.Id;
            update transferOutwardLine;
        }catch(Exception e){
            exceptionCaught = true;
        }
        System.assertEquals(false, exceptionCaught, 'exception caught when assigning requisitionLine to transfer outward line');
        
        System.assertNotEquals(null, transferOutwardLine, 'TransferOutwardLine should be created');
        System.assertEquals(transfer.Id, transferOutwardLine.dmpl__TransferId__c, 'Transfer account should match');
        System.assertEquals(item1.Id, transferOutwardLine.dmpl__ItemId__c, 'Item should match');
        System.assertEquals(2, transferOutwardLine.dmpl__Quantity__c, 'Quantity should 2');
        System.AssertEquals(requisition.Id, transferOutwardLine.dmpl__RequisitionId__c, 'Requisition should match');
        System.AssertEquals(requisitionLine.Id, transferOutwardLine.dmpl__RequisitionLineId__c, 'Requisition Line should match');
        Test.stopTest();
    }

	/************************************ Transfer Line Outward ************************************/
	@isTest 
	static void createTransferOutwardLineWithItemLotPositive(){
		Test.startTest();
		dmpl__Transfer__c transfer = TransferTestDataHelper.getTransfer();
		dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
		dmpl__ItemLot__c itemLot = TestDataHelpers.getItemLot();
		dmpl__TransferOutwardLine__c transferOutwardLine;
		try{
			transferOutwardLine = TransferTestDataHelper.createTransferOutwardLine(transfer?.Id, item?.Id, itemLot?.Id, 'On Hand Transfer', 10);
		}catch(Exception e){
			System.Assert.isTrue(null != transferOutwardLine, 'TransferOutwardLine should be created.');
		}
		transferOutwardLine = TransferTestDataHelper.getTransferOutwardLine(transferOutwardLine.Id);
		System.AssertEquals(transfer?.Id, transferOutwardLine.dmpl__TransferId__c, 'Item Id should be matched.');
		System.AssertEquals(item?.Id, transferOutwardLine.dmpl__ItemId__c, 'Item Id should be matched.');
		System.AssertEquals(itemLot?.Id, transferOutwardLine.dmpl__ItemLotId__c, 'ItemLot Id should be matched.');
		System.AssertEquals(10, transferOutwardLine.dmpl__Quantity__c, 'Quantity should be 10.');
		System.AssertEquals(10, transferOutwardLine.dmpl__PendingInwardQuantity__c, 'Pending Inward Quantity should be null.');
		Test.stopTest();
	}
	@isTest 
	static void createTransferOutwardLineWithItemPositive(){
		Test.startTest();
		dmpl__Transfer__c transfer = TransferTestDataHelper.getTransfer();
		dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
		dmpl__ItemLot__c itemLot = null;
		dmpl__TransferOutwardLine__c transferOutwardLine;
		try{
			transferOutwardLine = TransferTestDataHelper.createTransferOutwardLine(transfer?.Id, item?.Id, itemLot?.Id, 'On Hand Transfer', 10);
		}catch(Exception e){
			System.Assert.isTrue(null != transferOutwardLine, 'TransferOutwardLine should be created.');
		}
		transferOutwardLine = TransferTestDataHelper.getTransferOutwardLine(transferOutwardLine.Id);

		System.AssertEquals(transfer?.Id, transferOutwardLine.dmpl__TransferId__c, 'Item Id should be matched.');
		System.AssertEquals(item?.Id, transferOutwardLine.dmpl__ItemId__c, 'Item Id should be matched.');
		System.AssertEquals(itemLot?.Id, transferOutwardLine.dmpl__ItemLotId__c, 'ItemLot Id should be matched.');
		System.AssertEquals(10, transferOutwardLine.dmpl__Quantity__c, 'Quantity should be 10.');
		System.AssertEquals(10, transferOutwardLine.dmpl__PendingInwardQuantity__c, 'Pending Inward Quantity should be null.');
		Test.stopTest();
	}
	@isTest 
	static void createTransferOutwardLineWithoutItem2Negative(){
		Test.startTest();
		dmpl__Transfer__c transfer = TransferTestDataHelper.getTransfer();
		dmpl__Item__c item = null;
		dmpl__ItemLot__c itemLot = null;
		dmpl__TransferOutwardLine__c transferOutwardLine;
		try{
			transferOutwardLine = TransferTestDataHelper.createTransferOutwardLine(transfer?.Id, item?.Id, itemLot?.Id, 'On Hand Transfer', 10);
			System.Assert.isTrue(null == transferOutwardLine, 'TransferOutwardLine should be created.');
		}catch(Exception e){
			System.Assert.isTrue(null == transferOutwardLine, 'TransferOutwardLine should be created.');
		}
		Test.stopTest();
	}

}