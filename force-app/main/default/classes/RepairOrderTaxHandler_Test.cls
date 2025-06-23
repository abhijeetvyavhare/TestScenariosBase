@isTest
private class RepairOrderTaxHandler_Test {
    
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
        
        
        dmpl__TaxGroup__c taxGroup = RepairOrderTaxTestDataHelpers.getOrCreateTaxGroup();
        dmpl__Tax__c tax = RepairOrderTaxTestDataHelpers.getOrCreateTax();
        
        
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
    static void createRepairOrderTaxPositive() {

        dmpl__RepairOrder__c repairOrder = RepairOrderTestDataHelpers.getRepairOrder();
        
        Test.startTest();

        dmpl__RepairOrderTax__c tax = RepairOrderTaxTestDataHelpers.createCleanRepairOrderTax(repairOrder);
        insert tax;
        Test.stopTest();

        dmpl__RepairOrderTax__c createdTax = RepairOrderTaxTestDataHelpers.getRepairOrderTax(tax.Id);
        
        System.assertEquals(10, createdTax.dmpl__TaxRate__c, 'Tax Rate should be 10');
        System.assertEquals(100, createdTax.dmpl__TaxAmount__c, 'Tax Amount should be 100');
        System.assertEquals(100, createdTax.dmpl__TaxOnAmount__c, 'Tax On Amount should be 100');
    }

    @isTest
    static void updateRepairOrderTaxPositive() {

        dmpl__RepairOrder__c repairOrder = RepairOrderTestDataHelpers.getRepairOrder();
        
        dmpl__RepairOrderTax__c tax = RepairOrderTaxTestDataHelpers.createCleanRepairOrderTax(repairOrder);
        insert tax;
        
        Test.startTest();

        tax.dmpl__TaxRate__c = 15;
        tax.dmpl__TaxAmount__c = 150;
        tax.dmpl__TaxOnAmount__c = 1000;
        update tax;
        Test.stopTest();

        dmpl__RepairOrderTax__c updatedTax = RepairOrderTaxTestDataHelpers.getRepairOrderTax(tax.Id);
        
        System.assertEquals(15, updatedTax.dmpl__TaxRate__c, 'Tax Rate should be 15');
        System.assertEquals(150, updatedTax.dmpl__TaxAmount__c, 'Tax Amount should be 150');
        System.assertEquals(1000, updatedTax.dmpl__TaxOnAmount__c, 'Tax On Amount should be 1000');
    }

    @isTest
    static void deleteRepairOrderTaxes() {
        dmpl__RepairOrder__c repairOrder = RepairOrderTestDataHelpers.getRepairOrder();
        
        dmpl__RepairOrderTax__c tax = RepairOrderTaxTestDataHelpers.createCleanRepairOrderTax(repairOrder);
        insert tax;
        
        Test.startTest();
        RepairOrderTaxTestDataHelpers.deleteRepairOrderTaxesByRepairOrder(repairOrder.Id);
        Test.stopTest();

        List<dmpl__RepairOrderTax__c> remainingTaxes = RepairOrderTaxTestDataHelpers.getRepairOrderTaxesByRepairOrder(repairOrder.Id);
        System.assertEquals(0, remainingTaxes.size(), 'Should have no tax records remaining');
    }
}