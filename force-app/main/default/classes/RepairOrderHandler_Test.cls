@isTest
private class RepairOrderHandler_Test {
   
    @TestSetup
    static void createRequiredData() {
        Account partnerAccount = TestDataHelpers.createPartnerAccount();
        Account customerAccount = TestDataHelpers.createCustomerAccount();
        dmpl__Branch__c branch = TestDataHelpers.createBranch(partnerAccount);
        dmpl__Item__c item = TestDataHelpers.createItem();
        dmpl__SKU__c sku = TestDataHelpers.createSKU(item);
        dmpl__Resource__c resource = TestDataHelpers.createResource(partnerAccount, branch);
        dmpl__StorageLocation__c storageLocation = TestDataHelpers.createStorageLocation(branch);
        dmpl__ItemLot__c itemLot = TestDataHelpers.createItemLot(branch, item, sku, storageLocation);
        dmpl__PriceList__c priceList = TestDataHelpers.createPriceList(partnerAccount, branch);
        Asset asset = AssetTestDataHelpers.CreateAsset(customerAccount,branch,item,itemLot,sku);
        dmpl__Quote__c serviceEstimate = QuoteTestDataHelpers.CreateServiceEstimate(branch,customerAccount,priceList,asset,null,item);
        dmpl__RepairOrder__c repairOrder = RepairOrderTestDataHelpers.createRepairOrder(item,branch,asset,serviceEstimate,customerAccount,resource);
        dmpl__RepairOrderTax__c tax = RepairOrderTestDataHelpers.createRepairOrderTax(repairOrder);
     
        dmpl__RepairOrderTimeSheet__c timeSheet = RepairOrderTestDataHelpers.createTimeSheet(repairOrder);
        RepairOrderTestDataHelpers.createTimeSheetLine(timeSheet);
       
    }
 
    @isTest
    static void createRepairOrderPositive() {
        Account customerAccount = TestDataHelpers.getCustomerAccount();
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        dmpl__Item__c item = TestDataHelpers.getItem();
        dmpl__Resource__c resource = TestDataHelpers.getResource();
        Asset asset = AssetTestDataHelpers.getAsset();
        dmpl__PriceList__c priceList = TestDataHelpers.getPriceList();
        dmpl__RepairOrder__c createdOrder = RepairOrderTestDataHelpers.getRepairOrder();


        System.assertNotEquals(null, createdOrder.Id, 'Repair Order should be created');
        System.assertEquals(branch.Id, createdOrder.dmpl__BranchId__c, 'Branch should be linked');
    }
 
    @isTest
    static void updateRepairOrderPositive() {
        dmpl__RepairOrder__c existingOrder = RepairOrderTestDataHelpers.getRepairOrder();
 
        Test.startTest();
        existingOrder.dmpl__UsageReading__c = 70.00;
        update existingOrder;
        Test.stopTest();
 
        dmpl__RepairOrder__c updatedOrder = RepairOrderTestDataHelpers.getRepairOrder();
        System.assertEquals(70.00, updatedOrder.dmpl__UsageReading__c, 'Usage Reading should be updated to 70.00');
    }
 
    @isTest
    static void deleteRepairOrderPositive() {
        dmpl__RepairOrder__c existingOrder = RepairOrderTestDataHelpers.getRepairOrder();
        System.assertNotEquals(null, existingOrder.Id, 'Repair Order should exist before deletion');
 
        Test.startTest();
        delete existingOrder;
        Test.stopTest();
 
        List<dmpl__RepairOrder__c> remainingOrders = RepairOrderTestDataHelpers.getRepairOrdersById(existingOrder.Id);
        System.assertEquals(0, remainingOrders.size(), 'Repair Order should be deleted');
    }
 
    @isTest
    static void createRepairOrderTaxPositive() {
        dmpl__RepairOrder__c repairOrder = RepairOrderTestDataHelpers.getRepairOrder();
        dmpl__RepairOrderTax__c tax = RepairOrderTestDataHelpers.createRepairOrderTax(repairOrder);
        dmpl__RepairOrderTax__c createdTax = RepairOrderTestDataHelpers.getRepairOrderTax();

        System.assertEquals(10, createdTax.dmpl__TaxRate__c, 'Tax Rate should be 10');
        System.assertEquals(100, createdTax.dmpl__TaxAmount__c, 'Tax Amount should be 100');
        System.assertEquals(100, createdTax.dmpl__TaxOnAmount__c, 'Tax On Amount should be 100');
    }
 
    @isTest
    static void updateRepairOrderTaxPositive() {
        dmpl__RepairOrder__c repairOrder = RepairOrderTestDataHelpers.getRepairOrder();
        dmpl__RepairOrderTax__c tax = RepairOrderTestDataHelpers.getRepairOrderTax();
        Test.startTest();
        tax.dmpl__TaxAmount__c = 150;
        tax.dmpl__TaxOnAmount__c = 1000;
        update tax;
        Test.stopTest();
 
        dmpl__RepairOrderTax__c updatedTax = RepairOrderTestDataHelpers.getRepairOrderTax();
        System.assertEquals(150, updatedTax.dmpl__TaxAmount__c, 'Tax Amount should be 150');
        System.assertEquals(1000, updatedTax.dmpl__TaxOnAmount__c, 'Tax On Amount should be 1000');
    }
 
    @isTest
    static void deleteRepairOrderTaxePositive() {
        dmpl__RepairOrder__c repairOrder = RepairOrderTestDataHelpers.getRepairOrder();
        dmpl__RepairOrderTax__c tax = RepairOrderTestDataHelpers.createRepairOrderTax(repairOrder);
        
        Test.startTest();
        RepairOrderTestDataHelpers.deleteRepairOrderTaxesByRepairOrder(repairOrder.Id);
        Test.stopTest();
 
        List<dmpl__RepairOrderTax__c> remainingTaxes = RepairOrderTestDataHelpers.getRepairOrderTaxesByRepairOrder(repairOrder.Id);
        System.assertEquals(0, remainingTaxes.size(), 'Should have no tax records remaining');
    }
 
    @isTest
    static void createTimeSheetPositive() {
        dmpl__RepairOrder__c repairOrder = RepairOrderTestDataHelpers.getRepairOrder();
 
        Test.startTest();
        RepairOrderTestDataHelpers.createTimeSheet(repairOrder);
        Test.stopTest();
 
        List<dmpl__RepairOrderTimeSheet__c> timeSheets = RepairOrderTestDataHelpers.getTimeSheetsByRepairOrder(repairOrder.Id);
        System.assertEquals(2, timeSheets.size(), 'Should have two time sheets');
        dmpl__RepairOrderTimeSheet__c createdTimeSheet = timeSheets[1]; 
        System.assertNotEquals(null, createdTimeSheet.Id, 'Time Sheet should be created');
        System.assertEquals(repairOrder.Id, createdTimeSheet.dmpl__RepairOrderId__c, 'Repair Order should be linked');
        System.assertEquals(false, createdTimeSheet.dmpl__WorkEnded__c, 'Work Ended should be false');
        System.assertEquals(false, createdTimeSheet.dmpl__WorkPaused__c, 'Work Paused should be false');
        System.assertEquals(false, createdTimeSheet.dmpl__WorkStarted__c, 'Work Started should be false');
    }
 
    @isTest
    static void updateTimeSheetPositive() {
        dmpl__RepairOrderTimeSheet__c existingTimeSheet = RepairOrderTestDataHelpers.getTimeSheet();
        System.assertNotEquals(null, existingTimeSheet, 'Time sheet should exist from test setup');
 
        Test.startTest();
        existingTimeSheet.dmpl__WorkStarted__c = true;
        existingTimeSheet.dmpl__WorkPaused__c = true;       
        existingTimeSheet.dmpl__WorkEnded__c = true;
        update existingTimeSheet;
        Test.stopTest();
 
        dmpl__RepairOrderTimeSheet__c updatedTimeSheet = RepairOrderTestDataHelpers.getTimeSheet();
        System.assertEquals(true, updatedTimeSheet.dmpl__WorkStarted__c, 'Work Started should be updated to true');
        System.assertEquals(true, updatedTimeSheet.dmpl__WorkPaused__c, 'Work Paused should be updated to true');
        System.assertEquals(true, updatedTimeSheet.dmpl__WorkEnded__c, 'Work Ended should be updated to true');
    }
 
    @isTest
    static void deleteRepairOrderTimeSheetPositive() {
        dmpl__RepairOrderTimeSheet__c existingTimeSheet = RepairOrderTestDataHelpers.getTimeSheet();
        System.assertNotEquals(null, existingTimeSheet.Id, 'Repair Order Time Sheet should exist before deletion');
 
        Test.startTest();
        delete existingTimeSheet;
        Test.stopTest();
 
        List<dmpl__RepairOrderTimeSheet__c> remainingTimeSheets = RepairOrderTestDataHelpers.getRepairOrderTimeSheetsById(existingTimeSheet.Id);
        System.assertEquals(0, remainingTimeSheets.size(), 'Repair Order Time Sheet should be deleted');
    }
 
    @isTest
    static void createTimeSheetLinePositive() {
        dmpl__RepairOrderTimeSheet__c timeSheet = RepairOrderTestDataHelpers.getTimeSheet();
 
        Test.startTest();
        RepairOrderTestDataHelpers.createTimeSheetLine(timeSheet);
        Test.stopTest();
 
        List<dmpl__RepairOrderTimeSheetLine__c> timeSheetLines = RepairOrderTestDataHelpers.getTimeSheetLinesByTimeSheet(timeSheet.Id);
        System.assertEquals(2, timeSheetLines.size(), 'Should have two time sheet lines');
        dmpl__RepairOrderTimeSheetLine__c createdLine = timeSheetLines[1]; 
        System.assertNotEquals(null, createdLine.Id, 'Time Sheet Line should be created');
        System.assertEquals(timeSheet.Id, createdLine.dmpl__RepairOrderTimeSheetId__c, 'Time Sheet should be linked');
        System.assertEquals(1.00, createdLine.dmpl__ActualDurationHours__c, 'Actual Duration Hours should be 1.00');
    }
 
    @isTest
    static void updateTimeSheetLinePositive() {
        dmpl__RepairOrderTimeSheetLine__c existingLine = RepairOrderTestDataHelpers.getTimeSheetLine();
        System.assertNotEquals(null, existingLine, 'Time sheet line should exist from test setup');
 
        Test.startTest();
        existingLine.dmpl__ActualDurationHours__c = 2.50;
        update existingLine;
        Test.stopTest();
 
        dmpl__RepairOrderTimeSheetLine__c updatedLine = RepairOrderTestDataHelpers.getTimeSheetLine();
        System.assertEquals(2.50, updatedLine.dmpl__ActualDurationHours__c, 'Actual Duration Hours should be updated to 2.50');
    }
   
    @isTest
    static void deleteTimeSheetLinePositive() {
        dmpl__RepairOrderTimeSheetLine__c existingLine = RepairOrderTestDataHelpers.getTimeSheetLine();
        System.assertNotEquals(null, existingLine.Id, 'Time Sheet Line should exist before deletion');
 
        Test.startTest();
        delete existingLine;
        Test.stopTest();
 
        List<dmpl__RepairOrderTimeSheetLine__c> remainingLines = RepairOrderTestDataHelpers.getTimeSheetLinesById(existingLine.Id);
        System.assertEquals(0, remainingLines.size(), 'Time Sheet Line should be deleted');
    }
}