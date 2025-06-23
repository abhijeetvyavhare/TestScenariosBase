@isTest
private class RepairOrderTimeSheetHandler_Test {
    
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
        
        Asset asset = AssetTestDataHelpers.CreateAsset(
            customerAccount,
            branch,
            item,
            itemLot,
            sku
        );
        
        dmpl__Quote__c serviceEstimate = QuoteTestDataHelpers.CreateServiceEstimate(
            branch,
            customerAccount,
            priceList,
            asset,
            null, // serviceRequest
            item
        );
        
        dmpl__RepairOrder__c repairOrder = RepairOrderTestDataHelpers.createRepairOrder(
            item,
            branch,
            asset,
            serviceEstimate,
            customerAccount,
            resource
        );
        
        // Create a timesheet in test setup
        RepairOrderTimeSheetTestDataHelpers.createTimeSheet(repairOrder);
    }

    @isTest
    static void createTimeSheetPositive() {
        dmpl__RepairOrder__c repairOrder = RepairOrderTestDataHelpers.getRepairOrder();

        Test.startTest();
        RepairOrderTimeSheetTestDataHelpers.createTimeSheet(repairOrder);
        Test.stopTest();

        List<dmpl__RepairOrderTimeSheet__c> timeSheets = RepairOrderTimeSheetTestDataHelpers.getTimeSheetsByRepairOrder(repairOrder.Id);
        System.assertEquals(2, timeSheets.size(), 'Should have two time sheets');
        dmpl__RepairOrderTimeSheet__c createdTimeSheet = timeSheets[1]; // Get the newly created one
        System.assertNotEquals(null, createdTimeSheet.Id, 'Time Sheet should be created');
        System.assertEquals(repairOrder.Id, createdTimeSheet.dmpl__RepairOrderId__c, 'Repair Order should be linked');
        System.assertEquals(false, createdTimeSheet.dmpl__WorkEnded__c, 'Work Ended should be false');
        System.assertEquals(false, createdTimeSheet.dmpl__WorkPaused__c, 'Work Paused should be false');
        System.assertEquals(false, createdTimeSheet.dmpl__WorkStarted__c, 'Work Started should be false');
    }

    @isTest
    static void updateTimeSheetPositive() {
        dmpl__RepairOrderTimeSheet__c existingTimeSheet = RepairOrderTimeSheetTestDataHelpers.getTimeSheet();
        System.assertNotEquals(null, existingTimeSheet, 'Time sheet should exist from test setup');

        Test.startTest();
        existingTimeSheet.dmpl__WorkStarted__c = true;
        update existingTimeSheet;
        
        existingTimeSheet.dmpl__WorkPaused__c = true;
        update existingTimeSheet;
        
        existingTimeSheet.dmpl__WorkEnded__c = true;
        update existingTimeSheet;
        Test.stopTest();

        dmpl__RepairOrderTimeSheet__c updatedTimeSheet = RepairOrderTimeSheetTestDataHelpers.getTimeSheet();
        System.assertEquals(true, updatedTimeSheet.dmpl__WorkStarted__c, 'Work Started should be updated to true');
        System.assertEquals(true, updatedTimeSheet.dmpl__WorkPaused__c, 'Work Paused should be updated to true');
        System.assertEquals(true, updatedTimeSheet.dmpl__WorkEnded__c, 'Work Ended should be updated to true');
    }

    @isTest
    static void deleteRepairOrderTimeSheetPositive() {
        dmpl__RepairOrderTimeSheet__c existingTimeSheet = RepairOrderTimeSheetTestDataHelpers.getTimeSheet();
        System.assertNotEquals(null, existingTimeSheet.Id, 'Repair Order Time Sheet should exist before deletion');

        Test.startTest();
        delete existingTimeSheet;
        Test.stopTest();

        List<dmpl__RepairOrderTimeSheet__c> remainingTimeSheets = RepairOrderTimeSheetTestDataHelpers.getRepairOrderTimeSheetsById(existingTimeSheet.Id);
        System.assertEquals(0, remainingTimeSheets.size(), 'Repair Order Time Sheet should be deleted');
    }
}