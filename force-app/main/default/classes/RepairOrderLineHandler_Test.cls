@isTest
private class RepairOrderLineHandler_Test {
    
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
        
        dmpl__TaxGroup__c taxGroup = RepairOrderLineTestDataHelpers.createTaxGroup();
        insert taxGroup;
        
        dmpl__ItemServiceContract__c itemServiceContract = RepairOrderLineTestDataHelpers.createItemServiceContract(item);
        insert itemServiceContract;
        
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
        
        RepairOrderLineTestDataHelpers.createRepairOrderLine(
            repairOrder,
            item,
            sku,
            storageLocation,
            taxGroup,
            itemServiceContract,
            'Generate Claims'
        );
    }

    @isTest
    static void createRepairOrderLinePositive() {
        dmpl__RepairOrder__c repairOrder = RepairOrderTestDataHelpers.getRepairOrder();
        dmpl__Item__c item = TestDataHelpers.getItem();
        dmpl__SKU__c sku = TestDataHelpers.getSKU();
        dmpl__StorageLocation__c storageLocation = TestDataHelpers.getStorageLocation();
        dmpl__TaxGroup__c taxGroup = RepairOrderLineTestDataHelpers.getTaxGroup();
        dmpl__ItemServiceContract__c itemServiceContract = RepairOrderLineTestDataHelpers.getItemServiceContract();

        Test.startTest();
        RepairOrderLineTestDataHelpers.createRepairOrderLine(
            repairOrder,
            item,
            sku,
            storageLocation,
            taxGroup,
            itemServiceContract,
            'Generate Claims'
        );
        Test.stopTest();

        dmpl__RepairOrderLine__c createdLine = RepairOrderLineTestDataHelpers.getRepairOrderLine();
        System.assertNotEquals(null, createdLine.Id, 'Repair Order Line should be created');
        System.assertEquals(repairOrder.Id, createdLine.dmpl__RepairOrderId__c, 'Repair Order should be linked');
    }

    @isTest
    static void updateRepairOrderLinePositive() {
        dmpl__RepairOrderLine__c existingLine = RepairOrderLineTestDataHelpers.getRepairOrderLineForUpdate();

        Test.startTest();
        // Update quantities to maintain positive claimable quantity
        existingLine.dmpl__Quantity__c = 500.00;
        existingLine.dmpl__CancelledQuantity__c = 30.00;
        existingLine.dmpl__ClaimedQuantity__c = 10.00;
        update existingLine;
        Test.stopTest();

        dmpl__RepairOrderLine__c updatedLine = RepairOrderLineTestDataHelpers.getRepairOrderLineById(existingLine.Id);
        System.assertEquals(500.00, updatedLine.dmpl__Quantity__c, 'Quantity should be updated to 500.00');
        System.assertEquals(30.00, updatedLine.dmpl__CancelledQuantity__c, 'Cancelled Quantity should be 30.00');
        System.assertEquals(10.00, updatedLine.dmpl__ClaimedQuantity__c, 'Claimed Quantity should be 10.00');
    }

    @isTest
    static void deleteRepairOrderLinePositive() {
        dmpl__RepairOrderLine__c existingLine = RepairOrderLineTestDataHelpers.getRepairOrderLine();
        System.assertNotEquals(null, existingLine.Id, 'Repair Order Line should exist before deletion');

        Test.startTest();
        delete existingLine;
        Test.stopTest();

        List<dmpl__RepairOrderLine__c> remainingLines = RepairOrderLineTestDataHelpers.getRepairOrderLinesById(existingLine.Id);
        System.assertEquals(0, remainingLines.size(), 'Repair Order Line should be deleted');
    }
}