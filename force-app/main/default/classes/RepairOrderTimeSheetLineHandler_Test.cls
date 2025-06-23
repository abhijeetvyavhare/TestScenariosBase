@isTest
private class RepairOrderTimeSheetLineHandler_Test {
    
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
        dmpl__RepairOrderTimeSheet__c timeSheet = RepairOrderTimeSheetTestDataHelpers.createTimeSheet(repairOrder);
        
        // Create a timesheet line in test setup
        RepairOrderTimeSheetLineTestDataHelpers.createTimeSheetLine(timeSheet);
    }

    @isTest
    static void createTimeSheetLinePositive() {
        dmpl__RepairOrderTimeSheet__c timeSheet = RepairOrderTimeSheetTestDataHelpers.getTimeSheet();

        Test.startTest();
        RepairOrderTimeSheetLineTestDataHelpers.createTimeSheetLine(timeSheet);
        Test.stopTest();

        List<dmpl__RepairOrderTimeSheetLine__c> timeSheetLines = RepairOrderTimeSheetLineTestDataHelpers.getTimeSheetLinesByTimeSheet(timeSheet.Id);
        System.assertEquals(2, timeSheetLines.size(), 'Should have two time sheet lines');
        dmpl__RepairOrderTimeSheetLine__c createdLine = timeSheetLines[1]; // Get the newly created one
        System.assertNotEquals(null, createdLine.Id, 'Time Sheet Line should be created');
        System.assertEquals(timeSheet.Id, createdLine.dmpl__RepairOrderTimeSheetId__c, 'Time Sheet should be linked');
        System.assertEquals(1.00, createdLine.dmpl__ActualDurationHours__c, 'Actual Duration Hours should be 1.00');
    }

    @isTest
    static void updateTimeSheetLinePositive() {
        dmpl__RepairOrderTimeSheetLine__c existingLine = RepairOrderTimeSheetLineTestDataHelpers.getTimeSheetLine();
        System.assertNotEquals(null, existingLine, 'Time sheet line should exist from test setup');

        Test.startTest();
        existingLine.dmpl__ActualDurationHours__c = 2.50;
        update existingLine;
        Test.stopTest();

        dmpl__RepairOrderTimeSheetLine__c updatedLine = RepairOrderTimeSheetLineTestDataHelpers.getTimeSheetLine();
        System.assertEquals(2.50, updatedLine.dmpl__ActualDurationHours__c, 'Actual Duration Hours should be updated to 2.50');
    }
    
    @isTest
    static void deleteTimeSheetLinePositive() {
        dmpl__RepairOrderTimeSheetLine__c existingLine = RepairOrderTimeSheetLineTestDataHelpers.getTimeSheetLine();
        System.assertNotEquals(null, existingLine.Id, 'Time Sheet Line should exist before deletion');

        Test.startTest();
        delete existingLine;
        Test.stopTest();

        List<dmpl__RepairOrderTimeSheetLine__c> remainingLines = RepairOrderTimeSheetLineTestDataHelpers.getTimeSheetLinesById(existingLine.Id);
        System.assertEquals(0, remainingLines.size(), 'Time Sheet Line should be deleted');
    }
}