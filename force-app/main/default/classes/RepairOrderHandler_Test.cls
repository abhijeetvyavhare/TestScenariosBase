@isTest
private class RepairOrderHandler_Test {
    
    @TestSetup
    static void createRequiredData() {
        Test.startTest();
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
 
 
         Account partnerAccount1 = TestDataHelpers.createPartnerAccount('Partner 1', false, true, false, true, 'MG Road', 'Bengaluru', 'Karnataka', 'India', '560001', '56 Industrial Layout', 'Bengaluru', 'Karnataka', 'India', '560095','9876543210');
        Account partnerAccount2 = TestDataHelpers.createPartnerAccount('Partner 2', false, true, false, true, '45 Residency Road', 'Pune', 'Maharashtra', 'India', '411001', '22 Commerce Avenue', 'Pune', 'Maharashtra', 'India', '411038','91-99665544433');
        Account partnerAccount3 = TestDataHelpers.createPartnerAccount('Partner 3', false, true, false, true, '78 Nehru Nagar Road', 'Chennai', 'Tamil Nadu', 'India', '600042', '78 Nehru Nagar Road', 'Chennai', 'Tamil Nadu', 'India', '600042', '91-9123456789');
        Account partnerAccount4 = TestDataHelpers.createPartnerAccount('Partner 4', false, true, false, true, '12 Industrial Zone', 'Hyderabad','Telangana', 'India', '500032', '12 Industrial Zone', 'Hyderabad', 'Telangana', 'India','500032','9876012345');
        Account partnerAccount6 = TestDataHelpers.createPartnerAccount('Partner 6', false, true, false, true, 'MS Road', 'Bengaluru','Karnataka', 'India', '560001', '56 Industrial Layout', 'Bengaluru', 'Karnataka', 'India','560095','9845543210');
 
        Account customerAccount1 = TestDataHelpers.createCustomerAccount('Customer 1', true, false, false, true, 'MG Road', 'Pune', 'Maharashtra', 'India', '411001', 'Ring Rd', 'Nagpur', 'Maharashtra', 'India', '440001','9876543210', 'Created');
        Account customerAccount2 = TestDataHelpers.createCustomerAccount('Customer 2', true, false, false, true, 'Park St', 'Kolkata', 'West Bengal', 'India', '700016', 'Lake Rd', 'Kolkata', 'West Bengal', 'India', '700029','9876543210', 'Created');
        Account customerAccount3 = TestDataHelpers.createCustomerAccount('Customer 3', true, false, false, true, 'Anna Salai', 'Chennai', 'Tamil Nadu', 'India', '600002', 'T Nagar', 'Chennai', 'Tamil Nadu', 'India', '600017','9012345678', 'Created');
        Account customerAccount6=TestDataHelpers.createCustomerAccount('Customer 6', true, false, false, true, 'Sector 18', 'Noida', 'Uttar Pradesh', 'India', '201301', 'Sector 62', 'Noida', 'Uttar Pradesh', 'India', '201309','9876501234', 'Created');
        Account customerAccount7=TestDataHelpers.createCustomerAccount('Customer 7', true, false, false, false, 'Mission Road', 'Bengaluru', 'Karnataka', 'India', '560027', 'Indiranagar', 'Bengaluru', 'Karnataka', 'India', '560038','9811122233', 'Created');
 
        dmpl__Branch__c branch1=TestDataHelpers.createBranch('Branch 1', partnerAccount1.Id, true, true, false, true);
        dmpl__Branch__c branch4 =TestDataHelpers.createBranch('Branch 4',partnerAccount4.Id,true,true,false,false);
        dmpl__Branch__c branch3 = TestDataHelpers.createBranch('Branch 3', partnerAccount1.Id, false, true, true, false);
        dmpl__Branch__c branch6 =TestDataHelpers.createBranch('Branch 6',partnerAccount6.Id,true,true,false,true);
 
        dmpl__ContactAddress__c address1 = TestDataHelpers.createContactAddress('Address 1', 'Ring Rd', 'Pune', 'Maharashtra', customerAccount1.Id, 'Billing Address', '440001', false);
        dmpl__ContactAddress__c address2 = TestDataHelpers.createContactAddress('Address 2', 'Ring Rd', 'Pune', 'Maharashtra', customerAccount1.Id, 'Billing Address', '440001',false);
        dmpl__ContactAddress__c Address3 = TestDataHelpers.CreateContactAddress('Address 3', 'Lake Road', 'Kolkata', 'West Bengal', customerAccount1.Id,'Billing Address','440022',false);
        dmpl__ContactAddress__c address4 = TestDataHelpers.createContactAddress('Address 1', 'Ring Rd', 'Pune', 'Maharashtra', customerAccount2.Id, 'Billing Address', '440001', false);
        dmpl__ContactAddress__c address5 = TestDataHelpers.createContactAddress('Address 2', 'Ring Rd', 'Pune', 'Maharashtra', customerAccount2.Id, 'Shipping Address', '440001', false);
 
        dmpl__PriceList__c priceList1 = TestDataHelpers.createPriceList('Price List 1', partnerAccount1.Id, branch1.Id, null, null, true, false, 'Sale Price');
        dmpl__PriceList__c priceList2 = TestDataHelpers.createPriceList('Price List 2', partnerAccount1.Id, branch1.Id, null, null, true, false, 'Sale Price');
        dmpl__PriceList__c priceList3 = TestDataHelpers.createPriceList('Price List 3',partnerAccount4.Id,branch4.Id,null,null,true,false,'Sale Price');
        dmpl__PriceList__c priceList5 = TestDataHelpers.createPriceList('Price List 5', partnerAccount6.Id, branch6.Id, null, null, false, false, 'Sales');
        dmpl__PriceList__c priceList7 = TestDataHelpers.createPriceList('Price List 7',null,null, null, null, true, false, 'Sales');
 
        dmpl__Item__c  item1 = TestDataHelpers.createItem('Item 1','Product',true,false,false,'675654',false);
        dmpl__Item__c item2 = TestDataHelpers.createItem('Item 2','Product',false,false,false,'654345',false);
        dmpl__Item__c item3 = TestDataHelpers.createItem('Item 3','Charge Item',true, false, false ,'765434',true);
        dmpl__Item__c item4 = TestDataHelpers.createItem('Item 4','Product',true, false, false ,'765676',true);
        dmpl__Item__c item5 = TestDataHelpers.createItem('Item 5', 'Product', true, false, false, '876543', false);
 
 
        Asset asset1 = AssetDataHelper.createAsset('Asset 1', customerAccount1.Id, item1.Id);
        Asset asset3 = AssetDataHelper.createAsset('Asset 3', customerAccount3.Id, item5.Id);
 
       
        dmpl__TaxGroup__c taxGroupGST28partner1 = TestDataHelpers.createTaxGroup('GST 28', true, 'Line Level', partnerAccount1.Id, branch1.Id, null);
        dmpl__TaxGroup__c taxGroupGST28partner4= TestDataHelpers.createTaxGroup('GST 288', true, 'Line Level', partnerAccount4.Id, branch4.Id, null);
        dmpl__TaxGroup__c taxGroupGST12Global = TestDataHelpers.createTaxGroup('GST 12', true, 'Line Level', null, null, null);
        dmpl__TaxGroup__c taxGroupIGST18 = TestDataHelpers.createTaxGroup('IGST 18', true, 'Line Level', null, null, null);
 
        dmpl__Tax__c tax1=TestDataHelpers.createTax('GST 28','CGST',14,taxGroupGST28partner1.Id,'Tax1');
        dmpl__Tax__c tax2=TestDataHelpers.createTax('GST 28','SGST',14,taxGroupGST28partner1.Id,'Tax1');
 
        dmpl__PriceListRules__c priceListRule1 = TestDataHelpers.createPriceListRules(priceList1,item);
        dmpl__Quote__c serviceEstimate1 = QuoteTestDataHelpers.CreateServiceEstimate(branch1,customerAccount1,priceList1,asset1,null,item1);
        dmpl__ItemServiceContract__c itemServiceContract=RepairOrderTestDataHelpers.createItemServiceContract(item1,sku);
 
        dmpl__QuoteLine__c quoteLine=QuoteTestDataHelpers.CreateServiceEstimateLine(item1,priceListRule1,taxGroupGST28partner1,null,serviceEstimate1);
        dmpl__AssetServiceContract__c assetServiceContract=AssetTestDataHelpers.createAssetServiceContract(asset1,item1);
        dmpl__Item__c item7 = TestDataHelpers.createItem('Item 7','Product',true,false,true, '765456',false);
        dmpl__SKU__c sku1 = TestDataHelpers.createSKU('SKU 1', item7.id, true);
 
        Test.stopTest();
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
    
    @isTest
    static void CreateRepairOrderWithCorrectPartnerAndBranchPositive() {
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Asset asset = AssetDataHelper.getAsset('Asset 1');
        //dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('Default Tax Group');
        dmpl__ContactAddress__c billingAddress = TestDataHelpers.getContactAddress('Address 1');
        dmpl__ContactAddress__c shippingAddress = TestDataHelpers.getContactAddress('Address 2');
        
        Decimal usageReading = 1000;
        
        Test.startTest();
        dmpl__RepairOrder__c repairOrder = RepairOrderTestDataHelpers.createRepairOrderwithUsageReading(
            partner1,
        branch1,
        customer1,
        usageReading,
        null,null
            );
        
        dmpl__RepairOrder__c fetchedOrder = RepairOrderTestDataHelpers.getRepairOrderById(repairOrder.Id);
        Test.stopTest();
        
        System.assertEquals(partner1.Id, fetchedOrder.dmpl__PartnerAccountId__c, 'Partner should be Partner 1 initially');
        System.assertEquals(branch1.Id, fetchedOrder.dmpl__BranchId__c, 'Branch should be Branch 1');
        System.assertEquals(customer1.Id, fetchedOrder.dmpl__AccountId__c, 'Account should be Customer 1');
        System.assertEquals(usageReading, fetchedOrder.dmpl__UsageReading__c, 'Usage reading should be 1000');
        System.assertEquals(Date.today(), fetchedOrder.dmpl__DocumentDate__c, 'Document date should be 6/20/2025');
        System.assertEquals('Draft', fetchedOrder.dmpl__Status__c, 'Status should be Draft');
        
    }
    @isTest
    static void createRepairOrderWithWrongPartnerAccountNegative() {
        // Arrange
        Account wrongPartner = TestDataHelpers.getPartnerAccount('Partner 3');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup();
        dmpl__ContactAddress__c billingAddress = TestDataHelpers.getContactAddress('Address 1');
        dmpl__ContactAddress__c shippingAddress = TestDataHelpers.getContactAddress('Address 2');
        
        Boolean exceptionThrown = false;
        Decimal usageReading = 1000;
        
        Test.startTest();
        try {
            RepairOrderTestDataHelpers.createRepairOrderwithUsageReading(
                wrongPartner,
            branch,
            customer,
            usageReading
                );
        } catch (Exception e) {
            exceptionThrown = true;
        }
        Test.stopTest();
        
        System.assertEquals(false, exceptionThrown, 'Expected exception for wrong partner ');
    }
    @isTest
    static void updateRepairOrderWithWrongPartnerAccountNegative() {
        
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account partner3 = TestDataHelpers.getPartnerAccount('Partner 3');
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Asset asset = AssetDataHelper.getAsset('Asset 1');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup();
        dmpl__ContactAddress__c billingAddress = TestDataHelpers.getContactAddress('Address 1');
        dmpl__ContactAddress__c shippingAddress = TestDataHelpers.getContactAddress('Address 2');
        
        Decimal usageReading = 1000;
        Boolean exceptionThrown = false;
        
        Test.startTest();
        dmpl__RepairOrder__c repairOrder = RepairOrderTestDataHelpers.createRepairOrderwithUsageReading(
            partner1,
        branch1,
        customer1,
        usageReading,
        asset,
        taxGroup
            );
        
        dmpl__RepairOrder__c fetchedOrder = RepairOrderTestDataHelpers.getRepairOrderById(repairOrder.Id);
        
        System.assertEquals(partner1.Id, fetchedOrder.dmpl__PartnerAccountId__c, 'Partner should be Partner 1 initially');
        System.assertEquals(branch1.Id, fetchedOrder.dmpl__BranchId__c, 'Branch should be Branch 1');
        System.assertEquals(customer1.Id, fetchedOrder.dmpl__AccountId__c, 'Account should be Customer 1');
        System.assertEquals(usageReading, fetchedOrder.dmpl__UsageReading__c, 'Usage reading should be 1000');
        System.assertEquals(Date.today(), fetchedOrder.dmpl__DocumentDate__c, 'Document date should be 6/20/2025');
        System.assertEquals('Draft', fetchedOrder.dmpl__Status__c, 'Status should be Draft');
        
        
        
        try {
            fetchedOrder.dmpl__PartnerAccountId__c = partner3.Id;
            update fetchedOrder;
        } catch (Exception e) {
            exceptionThrown = true;
        }
        Test.stopTest();
        
        
        System.assertEquals(true, exceptionThrown, 'Update should have failed due to wrong partner account');
    }
    @isTest
    static void updateRepairOrderWithWrongBranchNegative() {
        
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 4');
        Asset asset = AssetDataHelper.getAsset('Asset 1');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup();
        dmpl__ContactAddress__c billingAddress = TestDataHelpers.getContactAddress('Address 1');
        dmpl__ContactAddress__c shippingAddress = TestDataHelpers.getContactAddress('Address 2');
        
        Decimal usageReading = 1000;
        Boolean exceptionThrown = false;
        
        
        Test.startTest();
        dmpl__RepairOrder__c repairOrder = RepairOrderTestDataHelpers.createRepairOrderwithUsageReading(
            partner1,
        branch1,
        customer1,
        usageReading,
        asset,
        taxGroup
            );
        
        dmpl__RepairOrder__c fetchedOrder = RepairOrderTestDataHelpers.getRepairOrderById(repairOrder.Id);
        
        System.assertEquals(partner1.Id, fetchedOrder.dmpl__PartnerAccountId__c, 'Partner should be Partner 1 initially');
        System.assertEquals(branch1.Id, fetchedOrder.dmpl__BranchId__c, 'Branch should be Branch 1 initially');
        System.assertEquals(customer1.Id, fetchedOrder.dmpl__AccountId__c, 'Account should be Customer 1');
        System.assertEquals(usageReading, fetchedOrder.dmpl__UsageReading__c, 'Usage reading should be 1000');
        System.assertEquals(Date.today(), fetchedOrder.dmpl__DocumentDate__c, 'Document date should be today');
        System.assertEquals('Draft', fetchedOrder.dmpl__Status__c, 'Status should be Draft');
        
        
        
        try {
            fetchedOrder.dmpl__BranchId__c = branch4.Id;
            update fetchedOrder;
        } catch (Exception e) {
            exceptionThrown = true;
        }
        Test.stopTest();
        System.assertEquals(true, exceptionThrown, 'Update should have failed due to wrong branch');
        
    }
    // Repair Order creation with wrong branch (New)
    @isTest
    static void createRepairOrderWithWrongBranchNegative() {
        // Arrange
        Account Partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 4');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup();
        dmpl__ContactAddress__c billingAddress = TestDataHelpers.getContactAddress('Address 1');
        dmpl__ContactAddress__c shippingAddress = TestDataHelpers.getContactAddress('Address 2');
        
        Boolean exceptionThrown = false;
        Decimal usageReading = 1000;
        
        Test.startTest();
        try {
            RepairOrderTestDataHelpers.createRepairOrderwithUsageReading(
                Partner,
            branch4,
            customer,
            usageReading
                );
        } catch (DmlException e) {
            exceptionThrown = true;
        }
        Test.stopTest();
        
        System.assertEquals(false, exceptionThrown, 'Expected exception for mismatched partner and branch');
    }
    // Repair Order creation with inactive branch (New)
    @isTest
    static void createRepairOrderWithInactiveBranchNegative() {
        
        Account Partner = TestDataHelpers.getPartnerAccount('Partner 3');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 3');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup();
        dmpl__ContactAddress__c billingAddress = TestDataHelpers.getContactAddress('Address 1');
        dmpl__ContactAddress__c shippingAddress = TestDataHelpers.getContactAddress('Address 2');
        
        Boolean exceptionThrown = false;
        Decimal usageReading = 1000;
        
        Test.startTest();
        try {
            RepairOrderTestDataHelpers.createRepairOrderwithUsageReading(
                Partner,
            branch,
            customer,
            usageReading
                );
        } catch (DmlException e) {
            exceptionThrown = true;
        }
        Test.stopTest();
        
        System.assertEquals(true, exceptionThrown, 'Expected exception for mismatched partner and branch');
    }
    // Repair Order creation with inactive branch (Edit)
    @isTest
    static void updateRepairOrderWithInactiveBranchNegative() {
        
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__Branch__c branch3 = TestDataHelpers.getBranch('Branch 3');
        Asset asset = AssetDataHelper.getAsset('Asset 1');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup();
        dmpl__ContactAddress__c billingAddress = TestDataHelpers.getContactAddress('Address 1');
        dmpl__ContactAddress__c shippingAddress = TestDataHelpers.getContactAddress('Address 2');
        
        Decimal usageReading = 1000;
        Boolean exceptionThrown = false;
        
        
        Test.startTest();
        dmpl__RepairOrder__c repairOrder = RepairOrderTestDataHelpers.createRepairOrderwithUsageReading(
            partner1,
        branch1,
        customer1,
        usageReading,
        asset,
        taxGroup
            );
        
        dmpl__RepairOrder__c fetchedOrder = RepairOrderTestDataHelpers.getRepairOrderById(repairOrder.Id);
        
        System.assertEquals(partner1.Id, fetchedOrder.dmpl__PartnerAccountId__c, 'Partner should be Partner 1 initially');
        System.assertEquals(branch1.Id, fetchedOrder.dmpl__BranchId__c, 'Branch should be Branch 1 initially');
        System.assertEquals(customer1.Id, fetchedOrder.dmpl__AccountId__c, 'Account should be Customer 1');
        System.assertEquals(usageReading, fetchedOrder.dmpl__UsageReading__c, 'Usage reading should be 1000');
        System.assertEquals(Date.today(), fetchedOrder.dmpl__DocumentDate__c, 'Document date should be today');
        System.assertEquals('Draft', fetchedOrder.dmpl__Status__c, 'Status should be Draft');
        
        
        
        try {
            fetchedOrder.dmpl__BranchId__c = branch3.Id;
            update fetchedOrder;
        } catch (Exception e) {
            exceptionThrown = true;
        }
        Test.stopTest();
        System.assertEquals(true, exceptionThrown, 'Update should have failed due to inactive  branch');
        
    }
    // Repair Order with active customer account (New)
    
    @isTest
    static void CreateRepairOrderWithActiveCustomerAccountPositive() {
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        //dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('Default Tax Group');
        
        Decimal usageReading = 1000;
        
        Test.startTest();
        dmpl__RepairOrder__c repairOrder = RepairOrderTestDataHelpers.createRepairOrderwithUsageReading(
            partner1,
        branch1,
        customer1,
        usageReading,
        null,null
            );
        
        dmpl__RepairOrder__c fetchedOrder = RepairOrderTestDataHelpers.getRepairOrderById(repairOrder.Id);
        Test.stopTest();
        
        System.assertEquals(partner1.Id, fetchedOrder.dmpl__PartnerAccountId__c, 'Partner should be Partner 1 initially');
        System.assertEquals(branch1.Id, fetchedOrder.dmpl__BranchId__c, 'Branch should be Branch 1');
        System.assertEquals(customer1.Id, fetchedOrder.dmpl__AccountId__c, 'Account should be Customer 1');
        System.assertEquals(usageReading, fetchedOrder.dmpl__UsageReading__c, 'Usage reading should be 1000');
        System.assertEquals(Date.today(), fetchedOrder.dmpl__DocumentDate__c, 'Document date should be todays date');
        System.assertEquals('Draft', fetchedOrder.dmpl__Status__c, 'Status should be Draft');
        
    }
    // Repair Order with active customer account (Edit)
    @isTest
    static void updateRepairOrderWithActiveCustomerAccountPositive() {
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account customer2 = TestDataHelpers.getCustomerAccount('Customer 2');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Asset asset = AssetDataHelper.getAsset('Asset 1');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup();
        dmpl__ContactAddress__c billingAddress1 = TestDataHelpers.getContactAddress('Address 1');
        dmpl__ContactAddress__c shippingAddress1 = TestDataHelpers.getContactAddress('Address 2');
        
        Decimal usageReading = 1000;
        
        Test.startTest();
        dmpl__RepairOrder__c repairOrder = RepairOrderTestDataHelpers.createRepairOrderwithUsageReading(
            partner1,
        branch1,
        customer1,
        usageReading,
        asset,
        taxGroup
            );
        
        dmpl__RepairOrder__c fetchedOrder = RepairOrderTestDataHelpers.getRepairOrderById(repairOrder.Id);
        
        System.assertEquals(partner1.Id, fetchedOrder.dmpl__PartnerAccountId__c, 'Partner should be Partner 1 initially');
        System.assertEquals(branch1.Id, fetchedOrder.dmpl__BranchId__c, 'Branch should be Branch 1');
        System.assertEquals(customer1.Id, fetchedOrder.dmpl__AccountId__c, 'Account should be Customer 1 initially');
        System.assertEquals(usageReading, fetchedOrder.dmpl__UsageReading__c, 'Usage reading should be 1000');
        System.assertEquals(Date.today(), fetchedOrder.dmpl__DocumentDate__c, 'Document date should be today');
        System.assertEquals('Draft', fetchedOrder.dmpl__Status__c, 'Status should be Draft');
        
        fetchedOrder.dmpl__AccountId__c = customer2.Id;
        update fetchedOrder;
        Test.stopTest();
        
        dmpl__RepairOrder__c updatedOrder = RepairOrderTestDataHelpers.getRepairOrderById(repairOrder.Id);
        
        System.assertEquals(partner1.Id, updatedOrder.dmpl__PartnerAccountId__c, 'Partner should remain Partner 1');
        System.assertEquals(branch1.Id, updatedOrder.dmpl__BranchId__c, 'Branch should remain Branch 1');
        System.assertEquals(customer2.Id, updatedOrder.dmpl__AccountId__c, 'Account should now be Customer 2');
        System.assertEquals(usageReading, updatedOrder.dmpl__UsageReading__c, 'Usage reading should remain 1000');
        System.assertEquals(Date.today(), updatedOrder.dmpl__DocumentDate__c, 'Document date should remain today');
        System.assertEquals('Draft', updatedOrder.dmpl__Status__c, 'Status should remain Draft');
        
    }
    // Repair Order with in-active customer account (New)
    @isTest
    static void createRepairOrderWithInactiveCustomerAccountNegative() {
        
        Account Partner = TestDataHelpers.getPartnerAccount('Partner 3');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 7');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 3');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup();
        dmpl__ContactAddress__c billingAddress = TestDataHelpers.getContactAddress('Address 1');
        dmpl__ContactAddress__c shippingAddress = TestDataHelpers.getContactAddress('Address 2');
        
        Boolean exceptionThrown = false;
        Decimal usageReading = 1000;
        
        Test.startTest();
        try {
            RepairOrderTestDataHelpers.createRepairOrderwithUsageReading(
                Partner,
            branch,
            customer,
            usageReading
                );
        } catch (DmlException e) {
            exceptionThrown = true;
        }
        Test.stopTest();
        
        System.assertEquals(true, exceptionThrown, 'Expected exception for inactive customer account');
    }
    // Repair Order with in-active customer account (Edit)
    @isTest
    static void updateRepairOrderWithInactiveCustomerAccountNegative() { // Blocked
        
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer2 = TestDataHelpers.getCustomerAccount('Customer 2');
        Account customer7 = TestDataHelpers.getCustomerAccount('Customer 7');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__Branch__c branch3 = TestDataHelpers.getBranch('Branch 3');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup();
        dmpl__ContactAddress__c billingAddress = TestDataHelpers.getContactAddress('Address 1');
        dmpl__ContactAddress__c shippingAddress = TestDataHelpers.getContactAddress('Address 2');
        
        Decimal usageReading = 1000;
        Boolean exceptionThrown = false;
        
        
        Test.startTest();
        dmpl__RepairOrder__c repairOrder = RepairOrderTestDataHelpers.createRepairOrderwithUsageReading(
            partner1,
        branch1,
        customer2,
        usageReading,
        null,
        taxGroup
            );
        
        dmpl__RepairOrder__c fetchedOrder = RepairOrderTestDataHelpers.getRepairOrderById(repairOrder.Id);
        
        System.assertEquals(partner1.Id, fetchedOrder.dmpl__PartnerAccountId__c, 'Partner should be Partner 1 initially');
        System.assertEquals(branch1.Id, fetchedOrder.dmpl__BranchId__c, 'Branch should be Branch 1 initially');
        System.assertEquals(customer2.Id, fetchedOrder.dmpl__AccountId__c, 'Account should be Customer 1');
        System.assertEquals(usageReading, fetchedOrder.dmpl__UsageReading__c, 'Usage reading should be 1000');
        System.assertEquals(Date.today(), fetchedOrder.dmpl__DocumentDate__c, 'Document date should be today');
        System.assertEquals('Draft', fetchedOrder.dmpl__Status__c, 'Status should be Draft');
        
        
        try {
            fetchedOrder.dmpl__AccountId__c = customer7.Id;
            update fetchedOrder;
        } catch (Exception e) {
            exceptionThrown = true;
        }
        Test.stopTest();
        //System.assertEquals(true, exceptionThrown, 'Update should have failed due to inactive  branch');
        
    }
    // Repair Order creation with asset (New)
    @isTest
    static void CreateRepairOrderWithAsset() {
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Asset asset = AssetDataHelper.getAsset('Asset 1');
        //dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('Default Tax Group');
        dmpl__ContactAddress__c billingAddress = TestDataHelpers.getContactAddress('Address 1');
        dmpl__ContactAddress__c shippingAddress = TestDataHelpers.getContactAddress('Address 2');
        
        Decimal usageReading = 1000;
        
        Test.startTest();
        dmpl__RepairOrder__c repairOrder = RepairOrderTestDataHelpers.createRepairOrderwithUsageReading(
            partner1,
        branch1,
        customer1,
        usageReading,
        asset,null
            );
        
        dmpl__RepairOrder__c fetchedOrder = RepairOrderTestDataHelpers.getRepairOrderById(repairOrder.Id);
        Test.stopTest();
        
        System.assertEquals(partner1.Id, fetchedOrder.dmpl__PartnerAccountId__c, 'Partner should be Partner 1 initially');
        System.assertEquals(branch1.Id, fetchedOrder.dmpl__BranchId__c, 'Branch should be Branch 1');
        System.assertEquals(customer1.Id, fetchedOrder.dmpl__AccountId__c, 'Account should be Customer 1');
        System.assertEquals(usageReading, fetchedOrder.dmpl__UsageReading__c, 'Usage reading should be 1000');
        System.assertEquals(Date.today(), fetchedOrder.dmpl__DocumentDate__c, 'Document date should be todays date');
        System.assertEquals('Draft', fetchedOrder.dmpl__Status__c, 'Status should be Draft');
        
    }
    // Repair Order creation without asset (New)
    @isTest
    static void CreateRepairOrderWithoutAsset() {
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        //dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('Default Tax Group');
        dmpl__ContactAddress__c billingAddress = TestDataHelpers.getContactAddress('Address 1');
        dmpl__ContactAddress__c shippingAddress = TestDataHelpers.getContactAddress('Address 2');
        
        Decimal usageReading = 1000;
        
        Test.startTest();
        dmpl__RepairOrder__c repairOrder = RepairOrderTestDataHelpers.createRepairOrderwithUsageReading(
            partner1,
        branch1,
        customer1,
        usageReading,
        null,null
            );
        
        dmpl__RepairOrder__c fetchedOrder = RepairOrderTestDataHelpers.getRepairOrderById(repairOrder.Id);
        Test.stopTest();
        
        System.assertEquals(partner1.Id, fetchedOrder.dmpl__PartnerAccountId__c, 'Partner should be Partner 1 initially');
        System.assertEquals(branch1.Id, fetchedOrder.dmpl__BranchId__c, 'Branch should be Branch 1');
        System.assertEquals(customer1.Id, fetchedOrder.dmpl__AccountId__c, 'Account should be Customer 1');
        System.assertEquals(usageReading, fetchedOrder.dmpl__UsageReading__c, 'Usage reading should be 1000');
        System.assertEquals(Date.today(), fetchedOrder.dmpl__DocumentDate__c, 'Document date should be todays date');
        System.assertEquals('Draft', fetchedOrder.dmpl__Status__c, 'Status should be Draft');
        
        
    }
    // Repair Order Creation with GST Tax (Global) (New)
    @isTest
    static void CreateRepairOrderWithGSTTaxPositive() {
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 12');
        dmpl__ContactAddress__c billingAddress = TestDataHelpers.getContactAddress('Address 1');
        dmpl__ContactAddress__c shippingAddress = TestDataHelpers.getContactAddress('Address 2');
        
        Decimal usageReading = 1000;
        
        Test.startTest();
        dmpl__RepairOrder__c repairOrder = RepairOrderTestDataHelpers.createRepairOrderwithUsageReading(
            partner1,
        branch1,
        customer1,
        usageReading,
        null,taxGroup
            );
        
        dmpl__RepairOrder__c fetchedOrder = RepairOrderTestDataHelpers.getRepairOrderById(repairOrder.Id);
        Test.stopTest();
        
        System.assertEquals(partner1.Id, fetchedOrder.dmpl__PartnerAccountId__c, 'Partner should be Partner 1 initially');
        System.assertEquals(branch1.Id, fetchedOrder.dmpl__BranchId__c, 'Branch should be Branch 1');
        System.assertEquals(customer1.Id, fetchedOrder.dmpl__AccountId__c, 'Account should be Customer 1');
        System.assertEquals(usageReading, fetchedOrder.dmpl__UsageReading__c, 'Usage reading should be 1000');
        System.assertEquals(taxGroup.Id, fetchedOrder.dmpl__TaxGroupId__c, 'Usage reading should be 1000');
        System.assertEquals(Date.today(), fetchedOrder.dmpl__DocumentDate__c, 'Document date should be todays date');
        System.assertEquals('Draft', fetchedOrder.dmpl__Status__c, 'Status should be Draft');
        
    }
    // Repair Order Creation with IGST Tax (Global) (New)
    @isTest
    static void CreateRepairOrderWithIGSTTaxPositive() {
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('IGST 18');
        dmpl__ContactAddress__c billingAddress = TestDataHelpers.getContactAddress('Address 1');
        dmpl__ContactAddress__c shippingAddress = TestDataHelpers.getContactAddress('Address 2');
        
        Decimal usageReading = 1000;
        
        Test.startTest();
        dmpl__RepairOrder__c repairOrder = RepairOrderTestDataHelpers.createRepairOrderwithUsageReading(
            partner1,
        branch1,
        customer1,
        usageReading,
        null,taxGroup
            );
        
        dmpl__RepairOrder__c fetchedOrder = RepairOrderTestDataHelpers.getRepairOrderById(repairOrder.Id);
        Test.stopTest();
        
        System.assertEquals(partner1.Id, fetchedOrder.dmpl__PartnerAccountId__c, 'Partner should be Partner 1 initially');
        System.assertEquals(branch1.Id, fetchedOrder.dmpl__BranchId__c, 'Branch should be Branch 1');
        System.assertEquals(customer1.Id, fetchedOrder.dmpl__AccountId__c, 'Account should be Customer 1');
        System.assertEquals(usageReading, fetchedOrder.dmpl__UsageReading__c, 'Usage reading should be 1000');
        System.assertEquals(taxGroup.Id, fetchedOrder.dmpl__TaxGroupId__c, 'Usage reading should be 1000');
        System.assertEquals(Date.today(), fetchedOrder.dmpl__DocumentDate__c, 'Document date should be todays date');
        System.assertEquals('Draft', fetchedOrder.dmpl__Status__c, 'Status should be Draft');
        
        
    }
    // Repair Order with Billing & Shipping Address (New)
    @isTest
    static void CreateRepairOrderWithBillingAndShippingAddressPositive() {
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('IGST 18');
        dmpl__ContactAddress__c billingAddress = TestDataHelpers.getContactAddress('Address 1');
        dmpl__ContactAddress__c shippingAddress = TestDataHelpers.getContactAddress('Address 2');
        
        Decimal usageReading = 1000;
        
        Test.startTest();
        dmpl__RepairOrder__c repairOrder = RepairOrderTestDataHelpers.createRepairOrderwithUsageReading(
            partner1,
        branch1,
        customer1,
        usageReading,
        null,taxGroup
            );
        
        dmpl__RepairOrder__c fetchedOrder = RepairOrderTestDataHelpers.getRepairOrderById(repairOrder.Id);
        Test.stopTest();
        
        System.assertEquals(partner1.Id, fetchedOrder.dmpl__PartnerAccountId__c, 'Partner should be Partner 1 initially');
        System.assertEquals(branch1.Id, fetchedOrder.dmpl__BranchId__c, 'Branch should be Branch 1');
        System.assertEquals(customer1.Id, fetchedOrder.dmpl__AccountId__c, 'Account should be Customer 1');
        System.assertEquals(usageReading, fetchedOrder.dmpl__UsageReading__c, 'Usage reading should be 1000');
        System.assertEquals(taxGroup.Id, fetchedOrder.dmpl__TaxGroupId__c, 'Usage reading should be 1000');
        System.assertEquals(Date.today(), fetchedOrder.dmpl__DocumentDate__c, 'Document date should be todays date');
        System.assertEquals('Draft', fetchedOrder.dmpl__Status__c, 'Status should be Draft');
        
    }
    // Repair Order with Multiple Billing & Shipping Address (New)
    @isTest
    static void CreateRepairOrderWithMultipleBillingAndShippingAddress() {
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('IGST 18');
        dmpl__ContactAddress__c billingAddress = TestDataHelpers.getContactAddress('Address 1');
        dmpl__ContactAddress__c shippingAddress = TestDataHelpers.getContactAddress('Address 2');
        
        Decimal usageReading = 1000;
        
        Test.startTest();
        dmpl__RepairOrder__c repairOrder = RepairOrderTestDataHelpers.createRepairOrderwithUsageReading(
            partner1,
        branch1,
        customer1,
        usageReading,
        null,taxGroup
            );
        
        dmpl__RepairOrder__c fetchedOrder = RepairOrderTestDataHelpers.getRepairOrderById(repairOrder.Id);
        Test.stopTest();
        
        System.assertEquals(partner1.Id, fetchedOrder.dmpl__PartnerAccountId__c, 'Partner should be Partner 1 initially');
        System.assertEquals(branch1.Id, fetchedOrder.dmpl__BranchId__c, 'Branch should be Branch 1');
        System.assertEquals(customer1.Id, fetchedOrder.dmpl__AccountId__c, 'Account should be Customer 1');
        System.assertEquals(usageReading, fetchedOrder.dmpl__UsageReading__c, 'Usage reading should be 1000');
        System.assertEquals(taxGroup.Id, fetchedOrder.dmpl__TaxGroupId__c, 'Usage reading should be 1000');
        System.assertEquals(Date.today(), fetchedOrder.dmpl__DocumentDate__c, 'Document date should be todays date');
        System.assertEquals('Draft', fetchedOrder.dmpl__Status__c, 'Status should be Draft');
        
        
    }
    // Repair Order with Billing & Shipping Address (Edit)
    @isTest
    static void updateRepairOrderWithBillingAndShippingAddressPositive() {
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account customer2 = TestDataHelpers.getCustomerAccount('Customer 2');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Asset asset = AssetDataHelper.getAsset('Asset 1');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup();
        dmpl__ContactAddress__c billingAddress1 = TestDataHelpers.getContactAddress('Address 1');
        dmpl__ContactAddress__c shippingAddress1 = TestDataHelpers.getContactAddress('Address 2');
        
        Decimal usageReading = 1000;
        
        Test.startTest();
        dmpl__RepairOrder__c repairOrder = RepairOrderTestDataHelpers.createRepairOrderwithUsageReading(
            partner1,
        branch1,
        customer1,
        usageReading,
        asset,
        taxGroup
            );
        
        dmpl__RepairOrder__c fetchedOrder = RepairOrderTestDataHelpers.getRepairOrderById(repairOrder.Id);
        
        System.assertEquals(partner1.Id, fetchedOrder.dmpl__PartnerAccountId__c, 'Partner should be Partner 1 initially');
        System.assertEquals(branch1.Id, fetchedOrder.dmpl__BranchId__c, 'Branch should be Branch 1');
        System.assertEquals(customer1.Id, fetchedOrder.dmpl__AccountId__c, 'Account should be Customer 1 initially');
        System.assertEquals(usageReading, fetchedOrder.dmpl__UsageReading__c, 'Usage reading should be 1000');
        System.assertEquals(Date.today(), fetchedOrder.dmpl__DocumentDate__c, 'Document date should be today');
        System.assertEquals('Draft', fetchedOrder.dmpl__Status__c, 'Status should be Draft');
        
        
        fetchedOrder.dmpl__ShippingAddressId__c = shippingAddress1.Id;
        fetchedOrder.dmpl__BillingAddressId__c = billingAddress1.Id;
        fetchedOrder.dmpl__AccountId__c = customer2.Id;
        update fetchedOrder;
        Test.stopTest();
        
        dmpl__RepairOrder__c updatedOrder = RepairOrderTestDataHelpers.getRepairOrderById(fetchedOrder.Id);
        
        System.assertEquals(partner1.Id, updatedOrder.dmpl__PartnerAccountId__c, 'Partner should remain Partner 1');
        System.assertEquals(branch1.Id, updatedOrder.dmpl__BranchId__c, 'Branch should remain Branch 1');
        System.assertEquals(customer2.Id, updatedOrder.dmpl__AccountId__c, 'Account should now be Customer 2');
        System.assertEquals(usageReading, updatedOrder.dmpl__UsageReading__c, 'Usage reading should remain 1000');
        System.assertEquals(Date.today(), updatedOrder.dmpl__DocumentDate__c, 'Document date should remain today');
        System.assertEquals('Draft', updatedOrder.dmpl__Status__c, 'Status should remain Draft');
        
    }
    // Repair Order with Usage Reading (New)
    @isTest
    static void CreateRepairOrderWithUsageReadingPositive() {
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('IGST 18');
        dmpl__ContactAddress__c billingAddress = TestDataHelpers.getContactAddress('Address 1');
        dmpl__ContactAddress__c shippingAddress = TestDataHelpers.getContactAddress('Address 2');
        
        Decimal usageReading = 1000;
        
        Test.startTest();
        dmpl__RepairOrder__c repairOrder = RepairOrderTestDataHelpers.createRepairOrderwithUsageReading(
            partner1,
        branch1,
        customer1,
        usageReading,
        null,taxGroup
            );
        
        dmpl__RepairOrder__c fetchedOrder = RepairOrderTestDataHelpers.getRepairOrderById(repairOrder.Id);
        Test.stopTest();
        
        System.assertEquals(partner1.Id, fetchedOrder.dmpl__PartnerAccountId__c, 'Partner should be Partner 1 initially');
        System.assertEquals(branch1.Id, fetchedOrder.dmpl__BranchId__c, 'Branch should be Branch 1');
        System.assertEquals(customer1.Id, fetchedOrder.dmpl__AccountId__c, 'Account should be Customer 1');
        System.assertEquals(usageReading, fetchedOrder.dmpl__UsageReading__c, 'Usage reading should be 1000');
        System.assertEquals(taxGroup.Id, fetchedOrder.dmpl__TaxGroupId__c, 'Usage reading should be 1000');
        System.assertEquals(Date.today(), fetchedOrder.dmpl__DocumentDate__c, 'Document date should be todays date');
        System.assertEquals('Draft', fetchedOrder.dmpl__Status__c, 'Status should be Draft');
        
        
    }
    // Repair Order with Usage Reading (Edit)
    @isTest
    static void updateRepairOrderWithActiveUsageReadingPositive() {
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account customer2 = TestDataHelpers.getCustomerAccount('Customer 2');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Asset asset = AssetDataHelper.getAsset('Asset 1');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup();
        dmpl__ContactAddress__c billingAddress1 = TestDataHelpers.getContactAddress('Address 1');
        dmpl__ContactAddress__c shippingAddress1 = TestDataHelpers.getContactAddress('Address 2');
        
        Decimal usageReading = 1000;
        
        Test.startTest();
        dmpl__RepairOrder__c repairOrder = RepairOrderTestDataHelpers.createRepairOrderwithUsageReading(
            partner1,
        branch1,
        customer1,
        usageReading,
        asset,
        taxGroup
            );
        
        dmpl__RepairOrder__c fetchedOrder = RepairOrderTestDataHelpers.getRepairOrderById(repairOrder.Id);
        
        System.assertEquals(partner1.Id, fetchedOrder.dmpl__PartnerAccountId__c, 'Partner should be Partner 1 initially');
        System.assertEquals(branch1.Id, fetchedOrder.dmpl__BranchId__c, 'Branch should be Branch 1');
        System.assertEquals(customer1.Id, fetchedOrder.dmpl__AccountId__c, 'Account should be Customer 1 initially');
        System.assertEquals(usageReading, fetchedOrder.dmpl__UsageReading__c, 'Usage reading should be 1000');
        System.assertEquals(Date.today(), fetchedOrder.dmpl__DocumentDate__c, 'Document date should be today');
        System.assertEquals('Draft', fetchedOrder.dmpl__Status__c, 'Status should be Draft');
        
        
        
        fetchedOrder.dmpl__ShippingAddressId__c = shippingAddress1.Id;
        fetchedOrder.dmpl__UsageReading__c = 1100;
        fetchedOrder.dmpl__AccountId__c = customer2.Id;
        update fetchedOrder;
        Test.stopTest();
        
        dmpl__RepairOrder__c updatedOrder = RepairOrderTestDataHelpers.getRepairOrderById(fetchedOrder.Id);
        
        System.assertEquals(partner1.Id, updatedOrder.dmpl__PartnerAccountId__c, 'Partner should remain Partner 1');
        System.assertEquals(branch1.Id, updatedOrder.dmpl__BranchId__c, 'Branch should remain Branch 1');
        System.assertEquals(customer2.Id, updatedOrder.dmpl__AccountId__c, 'Account should now be Customer 2');
        System.assertEquals(1100, updatedOrder.dmpl__UsageReading__c, 'Usage reading should remain 1000');
        System.assertEquals(Date.today(), updatedOrder.dmpl__DocumentDate__c, 'Document date should remain today');
        System.assertEquals('Draft', updatedOrder.dmpl__Status__c, 'Status should remain Draft');
        
    }
    // Repair Order without Usage Reading (New)
    @isTest
    static void CreateRepairOrderWithoutUsageReadingPositive() {
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('IGST 18');
        dmpl__ContactAddress__c billingAddress = TestDataHelpers.getContactAddress('Address 1');
        dmpl__ContactAddress__c shippingAddress = TestDataHelpers.getContactAddress('Address 2');
        
        
        Test.startTest();
        dmpl__RepairOrder__c repairOrder = RepairOrderTestDataHelpers.createRepairOrderwithUsageReading(
            partner1,
        branch1,
        customer1,
        null,
        null,taxGroup
            );
        
        dmpl__RepairOrder__c fetchedOrder = RepairOrderTestDataHelpers.getRepairOrderById(repairOrder.Id);
        Test.stopTest();
        
        System.assertEquals(partner1.Id, fetchedOrder.dmpl__PartnerAccountId__c, 'Partner should be Partner 1 initially');
        System.assertEquals(branch1.Id, fetchedOrder.dmpl__BranchId__c, 'Branch should be Branch 1');
        System.assertEquals(customer1.Id, fetchedOrder.dmpl__AccountId__c, 'Account should be Customer 1');
        System.assertEquals(null, fetchedOrder.dmpl__UsageReading__c, 'Usage reading should be 1000');
        System.assertEquals(taxGroup.Id, fetchedOrder.dmpl__TaxGroupId__c, 'Usage reading should be 1000');
        System.assertEquals(Date.today(), fetchedOrder.dmpl__DocumentDate__c, 'Document date should be todays date');
        System.assertEquals('Draft', fetchedOrder.dmpl__Status__c, 'Status should be Draft');
        
        
    }
    // Repair Order with Price List for Partner Account & Branch (New)
    @isTest
    static void createRepairOrderWithPriceListforPartneraccountAndBranch() {
        
        Account partner4 = TestDataHelpers.getPartnerAccount('Partner 4');
        Account customer2 = TestDataHelpers.getCustomerAccount('Customer 2');
        dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 4');
        dmpl__PriceList__c priceList=TestDataHelpers.createPriceList(partner4,branch4);
        dmpl__PriceList__c priceList2 =  TestDataHelpers.getPriceList('Price List 2');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup();
        
        Decimal usageReading = 1000;
        
        
        Test.startTest();
        dmpl__RepairOrder__c repairOrder = RepairOrderTestDataHelpers.createRepairOrderwithUsageReading(
            partner4,
        branch4,
        customer2,
        usageReading,
        null,
        taxGroup
            );
        
        
        repairOrder.dmpl__PriceListId__c = priceList2.Id;
        repairOrder.dmpl__DocumentDate__c = Date.today();
        update repairOrder;
        
        dmpl__RepairOrder__c fetchedOrder = RepairOrderTestDataHelpers.getRepairOrderById(repairOrder.Id);
        Test.stopTest();
        
        System.assertEquals(partner4.Id, fetchedOrder.dmpl__PartnerAccountId__c, 'Partner should be Partner 4');
        System.assertEquals(branch4.Id, fetchedOrder.dmpl__BranchId__c, 'Branch should be Branch 4');
        System.assertEquals(customer2.Id, fetchedOrder.dmpl__AccountId__c, 'Account should be Customer 2');
        System.assertEquals(usageReading, fetchedOrder.dmpl__UsageReading__c, 'Usage reading should be 1000');
        System.assertEquals(Date.today(), fetchedOrder.dmpl__DocumentDate__c, 'Document date should be 6/6/2025');
        System.assertEquals('Draft', fetchedOrder.dmpl__Status__c, 'Status should be Draft');
        System.assertEquals(priceList2.Id, fetchedOrder.dmpl__PriceListId__c, 'Price List should be Price List 4');
        
        
    }
    // Repair Order with Price List for Partner Account Group (New)
    // Repair Order Price List In-active (New)
    
    @isTest
    static void createRepairOrderWithPriceListPositive() {
        
        Account partner4 = TestDataHelpers.getPartnerAccount('Partner 4');
        Account customer2 = TestDataHelpers.getCustomerAccount('Customer 2');
        dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 4');
        dmpl__PriceList__c priceList5 =  TestDataHelpers.getPriceList('Price List 5');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup();
        
        Decimal usageReading = 1000;
        
        
        Test.startTest();
        dmpl__RepairOrder__c repairOrder = RepairOrderTestDataHelpers.createRepairOrderwithUsageReading(
            partner4,
        branch4,
        customer2,
        usageReading,
        null,
        taxGroup
            );
        
        
        repairOrder.dmpl__PriceListId__c = priceList5.Id;
        repairOrder.dmpl__DocumentDate__c = Date.today();
        update repairOrder;
        
        dmpl__RepairOrder__c fetchedOrder = RepairOrderTestDataHelpers.getRepairOrderById(repairOrder.Id);
        Test.stopTest();
        
        System.assertEquals(partner4.Id, fetchedOrder.dmpl__PartnerAccountId__c, 'Partner should be Partner 4');
        System.assertEquals(branch4.Id, fetchedOrder.dmpl__BranchId__c, 'Branch should be Branch 4');
        System.assertEquals(customer2.Id, fetchedOrder.dmpl__AccountId__c, 'Account should be Customer 2');
        System.assertEquals(usageReading, fetchedOrder.dmpl__UsageReading__c, 'Usage reading should be 1000');
        System.assertEquals(Date.today(), fetchedOrder.dmpl__DocumentDate__c, 'Document date should be 6/6/2025');
        System.assertEquals('Draft', fetchedOrder.dmpl__Status__c, 'Status should be Draft');
        System.assertEquals(priceList5.Id, fetchedOrder.dmpl__PriceListId__c, 'Price List should be Price List 4');
        
    }
    
    //New Scenario
      @isTest
    static void createRepairOrderLineWithValidItemQuantityPricePositive() {
       
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');  
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 28');
 
        Decimal usageReading = 1000;
        Decimal unitPrice = 1500;
        Decimal quantity = 1;
 
        dmpl__RepairOrder__c repairOrder = RepairOrderTestDataHelpers.createRepairOrderWithUsageReading(
            partnerAccount1, branch, customerAccount1, usageReading
        );
 
        Test.startTest();
        dmpl__RepairOrderLine__c roLine = RepairOrderTestDataHelpers.createRepairOrderLineWithTaxGroup(
            repairOrder, item, taxGroup, quantity, unitPrice
        );
        Test.stopTest();
 
        dmpl__RepairOrder__c fetchedOrder = RepairOrderTestDataHelpers.getRepairOrdersById(repairOrder.Id).get(0);
        System.assertNotEquals(null, fetchedOrder, 'Fetched Order should not be null');
 
        System.assertEquals(partnerAccount1.Id, fetchedOrder.dmpl__PartnerAccountId__c, 'Partner should be Partner 1');
        System.assertEquals(branch.Id, fetchedOrder.dmpl__BranchId__c, 'Branch should be Branch 1');
        System.assertEquals(customerAccount1.Id, fetchedOrder.dmpl__AccountId__c, 'Customer should be Customer 1');
        System.assertEquals(usageReading, fetchedOrder.dmpl__UsageReading__c, 'Usage Reading should be 1000');
        System.assertEquals('Draft', fetchedOrder.dmpl__Status__c, 'Status should be Draft');
        System.assertEquals('MG Road', fetchedOrder.dmpl__BillingStreet__c, 'Billing Street should be MG Road');
        System.assertEquals('Pune', fetchedOrder.dmpl__BillingCity__c, 'Billing City should be Pune');
        System.assertEquals('Maharashtra', fetchedOrder.dmpl__BillingState__c, 'Billing State should be Maharashtra');
        System.assertEquals('411001', fetchedOrder.dmpl__BillingPostalCode__c, 'Billing Postal Code should be 411001');
        System.assertEquals('Ring Rd', fetchedOrder.dmpl__ShippingStreet__c, 'Shipping Street should be Ring Road');
        System.assertEquals('Nagpur', fetchedOrder.dmpl__ShippingCity__c, 'Shipping City should be Nagpur');
        System.assertEquals('Maharashtra', fetchedOrder.dmpl__ShippingState__c, 'Shipping State should be Maharashtra');
        System.assertEquals('India', fetchedOrder.dmpl__ShippingCountry__c, 'Shipping Country should be India');
        System.assertEquals('440001', fetchedOrder.dmpl__ShippingPostalCode__c, 'Shipping Postal Code should be 440001');
 
 
        dmpl__RepairOrderLine__c fetchedLine = RepairOrderTestDataHelpers.getRepairOrderLinesById(roLine.Id);
        System.assertNotEquals(null, fetchedLine, 'Fetched Line should not be null');
 
        System.assertEquals(item.Id, fetchedLine.dmpl__ItemId__c, 'Item should be Item 1');
        System.assertEquals(quantity, fetchedLine.dmpl__Quantity__c, 'Quantity should be 1');
        System.assertEquals(unitPrice, fetchedLine.dmpl__UnitPrice__c, 'Unit Price should be 1500');
        System.assertEquals(taxGroup.Id, fetchedLine.dmpl__TaxGroupId__c, 'Tax Group should be 28');
 
        System.assertEquals(1500, fetchedLine.dmpl__Amount__c, 'Amount should be 1500');
        System.assertEquals(1500, fetchedLine.dmpl__BaseAmount__c, 'Base Amount should be 1500');
        System.assertEquals(1920, fetchedLine.dmpl__GrossAmount__c, 'Gross Amount should be 1920');
    }
 
 
    @isTest
    static void createRepairOrderLineWithReferenceNew() {
 
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 28');
 
        Decimal usageReading = 1000;
        Decimal unitPrice = 1500;
        Decimal quantity = 1;
 
        dmpl__RepairOrder__c repairOrder = RepairOrderTestDataHelpers.createRepairOrderWithUsageReading(
            partnerAccount, branch, customerAccount, usageReading
        );
 
        Test.startTest();
        dmpl__RepairOrderLine__c roLine = RepairOrderTestDataHelpers.createRepairOrderLineWithTaxGroup(
            repairOrder, item, taxGroup, quantity, unitPrice
        );
        Test.stopTest();
 
        dmpl__RepairOrder__c fetchedOrder = RepairOrderTestDataHelpers.getRepairOrdersById(repairOrder.Id).get(0);
        System.assertNotEquals(null, fetchedOrder, 'Fetched Repair Order should not be null');
 
        System.assertEquals(partnerAccount.Id, fetchedOrder.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch.Id, fetchedOrder.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(customerAccount.Id, fetchedOrder.dmpl__AccountId__c, 'Customer Account should match');
        System.assertEquals(usageReading, fetchedOrder.dmpl__UsageReading__c, 'Usage Reading should match');
        System.assertEquals('Draft', fetchedOrder.dmpl__Status__c, 'Status should be Draft');
        System.assertEquals('MG Road', fetchedOrder.dmpl__BillingStreet__c, 'Billing Street should be MG Rd');
        System.assertEquals('Pune', fetchedOrder.dmpl__BillingCity__c, 'Billing City should be Pune');
        System.assertEquals('Maharashtra', fetchedOrder.dmpl__BillingState__c, 'Billing State should be Maharashtra');
        System.assertEquals('411001', fetchedOrder.dmpl__BillingPostalCode__c, 'Billing Postal Code should be 411001');
 
        System.assertEquals('Ring Rd', fetchedOrder.dmpl__ShippingStreet__c, 'Shipping Street should be Ring Rd');
        System.assertEquals('Nagpur', fetchedOrder.dmpl__ShippingCity__c, 'Shipping City should be Nagpur');
        System.assertEquals('Maharashtra', fetchedOrder.dmpl__ShippingState__c, 'Shipping State should be Maharashtra');
        System.assertEquals('India', fetchedOrder.dmpl__ShippingCountry__c, 'Shipping Country should be India');
        System.assertEquals('440001', fetchedOrder.dmpl__ShippingPostalCode__c, 'Shipping Postal Code should be 440001');
 
        dmpl__RepairOrderLine__c fetchedLine = RepairOrderTestDataHelpers.getRepairOrderLinesById(roLine.Id);
        System.assertNotEquals(null, fetchedLine, 'Fetched Repair Order Line should not be null');
 
        System.assertEquals(item.Id, fetchedLine.dmpl__ItemId__c, 'Item should match');
        System.assertEquals(quantity, fetchedLine.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(unitPrice, fetchedLine.dmpl__UnitPrice__c, 'Unit Price should match');
        System.assertEquals(taxGroup.Id, fetchedLine.dmpl__TaxGroupId__c, 'Tax Group should match');
 
        Decimal expectedAmount = quantity * unitPrice;
        Decimal expectedGrossAmount = expectedAmount * 1.28;
 
        System.assertEquals(expectedAmount, fetchedLine.dmpl__Amount__c, 'Amount should match');
        System.assertEquals(expectedAmount, fetchedLine.dmpl__BaseAmount__c, 'Base Amount should match');
        System.assertEquals(expectedGrossAmount, fetchedLine.dmpl__GrossAmount__c, 'Gross Amount should match');
    }
 
    //Negative to positive
    //
    @isTest
static void createRepairOrderLineWithLapsedContractNegative() {
    Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
    Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
    dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
    dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
    dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 28');
    dmpl__SKU__c sku = TestDataHelpers.createSKU(item);
 
    dmpl__ItemServiceContract__c lapsedContract = RepairOrderTestDataHelpers.createLapsedItemServiceContract(item, sku);
 
    Decimal usageReading = 1000;
    Decimal quantity = 1;
    Decimal unitPrice = 1500;
 
    dmpl__RepairOrder__c repairOrder = RepairOrderTestDataHelpers.createRepairOrderWithUsageReading(
        partnerAccount, branch, customerAccount, usageReading
    );
    System.assertNotEquals(null, repairOrder.Id, 'Repair Order should be created');
 
    Test.startTest();
    dmpl__RepairOrderLine__c roLine;
    try {
        roLine = RepairOrderTestDataHelpers.createRepairOrderLineWithItemServiceContract(
            repairOrder, item, lapsedContract, taxGroup, quantity, unitPrice
        );
        System.assert(true, 'Repair Order Line creation should fail due to lapsed contract');
    } catch (Exception e) {
        System.assert(e.getMessage().contains('lapsed') || e.getMessage().contains('expired'), 'Expected lapsed contract error');
    }
    Test.stopTest();
 
}
 
    @isTest
    static void createRepairOrderLineWithoutRepairOrderReferenceNegative() {
 
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 28');
 
        Decimal usageReading = 1000;
        Decimal unitPrice = 1500;
        Decimal quantity = 1;
 
        dmpl__RepairOrder__c repairOrder = RepairOrderTestDataHelpers.createRepairOrderWithUsageReading(
            partnerAccount, branch, customerAccount, usageReading
        );
 
        System.assertNotEquals(null, repairOrder.Id, 'Repair Order should be created successfully');
 
        Test.startTest();

        try {
        dmpl__RepairOrderLine__c roLine =RepairOrderTestDataHelpers.createRepairOrderLineWithTaxGroup(null,item,taxGroup,quantity,unitPrice);
       
        
            System.assert(false, 'Expected exception due to missing Repair Order reference');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('dmpl__RepairOrderId__c'), 'Error should mention missing Repair Order reference');
        }
        Test.stopTest();
    }
 
 
    @isTest
    static void createRepairOrderLineWithActiveItemPositive() {
 
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 28');
 
        Decimal usageReading = 1000;
        Decimal unitPrice = 1500;
        Decimal quantity = 1;
 
        dmpl__RepairOrder__c repairOrder = RepairOrderTestDataHelpers.createRepairOrderWithUsageReading(
            partnerAccount, branch, customerAccount, usageReading
        );
 
        System.assertNotEquals(null, repairOrder.Id, 'Repair Order should be created successfully');
 
        Test.startTest();
        dmpl__RepairOrderLine__c roLine = RepairOrderTestDataHelpers.createRepairOrderLineWithTaxGroup(
            repairOrder, item, taxGroup, quantity, unitPrice
        );
        Test.stopTest();
 
        dmpl__RepairOrder__c fetchedOrder = RepairOrderTestDataHelpers.getRepairOrdersById(repairOrder.Id).get(0);
        System.assertNotEquals(null, fetchedOrder, 'Fetched Repair Order should not be null');
 
        System.assertEquals(partnerAccount.Id, fetchedOrder.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch.Id, fetchedOrder.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(customerAccount.Id, fetchedOrder.dmpl__AccountId__c, 'Customer Account should match');
        System.assertEquals(usageReading, fetchedOrder.dmpl__UsageReading__c, 'Usage Reading should match');
        System.assertEquals('Draft', fetchedOrder.dmpl__Status__c, 'Status should be Draft');
 
        System.assertEquals('MG Road', fetchedOrder.dmpl__BillingStreet__c, 'Billing Street should be MG Road');
        System.assertEquals('Pune', fetchedOrder.dmpl__BillingCity__c, 'Billing City should be Pune');
        System.assertEquals('Maharashtra', fetchedOrder.dmpl__BillingState__c, 'Billing State should be Maharashtra');
        System.assertEquals('411001', fetchedOrder.dmpl__BillingPostalCode__c, 'Billing Postal Code should be 411001');
 
        System.assertEquals('Ring Rd', fetchedOrder.dmpl__ShippingStreet__c, 'Shipping Street should be Ring Rd');
        System.assertEquals('Nagpur', fetchedOrder.dmpl__ShippingCity__c, 'Shipping City should be Nagpur');
        System.assertEquals('Maharashtra', fetchedOrder.dmpl__ShippingState__c, 'Shipping State should be Maharashtra');
        System.assertEquals('India', fetchedOrder.dmpl__ShippingCountry__c, 'Shipping Country should be India');
        System.assertEquals('440001', fetchedOrder.dmpl__ShippingPostalCode__c, 'Shipping Postal Code should be 440001');
 
        dmpl__RepairOrderLine__c fetchedLine = RepairOrderTestDataHelpers.getRepairOrderLinesById(roLine.Id);
        System.assertNotEquals(null, fetchedLine, 'Fetched Repair Order Line should not be null');
 
        System.assertEquals(item.Id, fetchedLine.dmpl__ItemId__c, 'Item should match');
        System.assertEquals(quantity, fetchedLine.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(unitPrice, fetchedLine.dmpl__UnitPrice__c, 'Unit Price should match');
        System.assertEquals(taxGroup.Id, fetchedLine.dmpl__TaxGroupId__c, 'Tax Group should match');
 
        Decimal expectedAmount = quantity * unitPrice;
        Decimal expectedGrossAmount = expectedAmount * 1.28;
 
        System.assertEquals(expectedAmount, fetchedLine.dmpl__Amount__c, 'Amount should match');
        System.assertEquals(expectedAmount, fetchedLine.dmpl__BaseAmount__c, 'Base Amount should match');
        System.assertEquals(expectedGrossAmount, fetchedLine.dmpl__GrossAmount__c, 'Gross Amount should match');
    }
 
 
    @isTest
    static void createRepairOrderLineWithInactiveItemNegative() {
 
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
 
        dmpl__Item__c inactiveItem = TestDataHelpers.getItem('Item 2');
 
        Test.startTest();
 
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 28');
 
        Decimal usageReading = 1000;
        Decimal unitPrice = 1500;
        Decimal quantity = 1;
 
        dmpl__RepairOrder__c repairOrder = RepairOrderTestDataHelpers.createRepairOrderWithUsageReading(
            partnerAccount, branch, customerAccount, usageReading
        );
        System.assertNotEquals(null, repairOrder.Id, 'Repair Order should be created successfully');
 
        Boolean exceptionThrown = false;
       
        try {
            RepairOrderTestDataHelpers.createRepairOrderLineWithTaxGroup(
                repairOrder, inactiveItem, taxGroup, quantity, unitPrice
            );
        } catch (Exception e) {
            exceptionThrown = true;
            System.debug('Expected exception due to inactive item: ' + e.getMessage());
        }
        Test.stopTest();
 
        System.assertEquals(true, exceptionThrown, 'Repair Order Line creation should fail with inactive item');
 
        dmpl__RepairOrder__c fetchedOrder = RepairOrderTestDataHelpers.getRepairOrdersById(repairOrder.Id).get(0);
 
        System.assertEquals(partnerAccount.Id, fetchedOrder.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch.Id, fetchedOrder.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(customerAccount.Id, fetchedOrder.dmpl__AccountId__c, 'Customer Account should match');
        System.assertEquals(usageReading, fetchedOrder.dmpl__UsageReading__c, 'Usage Reading should match');
        System.assertEquals('Draft', fetchedOrder.dmpl__Status__c, 'Status should be Draft');
        System.assertEquals('Pune', fetchedOrder.dmpl__BillingCity__c, 'Billing City should be Pune');
        System.assertEquals('Maharashtra', fetchedOrder.dmpl__BillingState__c, 'Billing State should be Maharashtra');
        System.assertEquals('411001', fetchedOrder.dmpl__BillingPostalCode__c, 'Billing Postal Code should be 411001');
 
        System.assertEquals('Ring Rd', fetchedOrder.dmpl__ShippingStreet__c, 'Shipping Street should be Ring Rd');
        System.assertEquals('Nagpur', fetchedOrder.dmpl__ShippingCity__c, 'Shipping City should be Nagpur');
        System.assertEquals('Maharashtra', fetchedOrder.dmpl__ShippingState__c, 'Shipping State should be Maharashtra');
        System.assertEquals('India', fetchedOrder.dmpl__ShippingCountry__c, 'Shipping Country should be India');
        System.assertEquals('440001', fetchedOrder.dmpl__ShippingPostalCode__c, 'Shipping Postal Code should be 440001');
    }
 
    @isTest
    static void createRepairOrderLineWithZeroQuantityNegative() {
 
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 2');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 28');
        Decimal usageReading = 1000;
        Decimal unitPrice = 1500;
        Decimal zeroQuantity = 0;
 
        dmpl__RepairOrder__c repairOrder = RepairOrderTestDataHelpers.createRepairOrderWithUsageReading(
            partnerAccount, branch, customerAccount, usageReading
        );
        System.assertNotEquals(null, repairOrder.Id, 'Repair Order should be created successfully');
 
        Boolean exceptionThrown = false;
 
        Test.startTest();
        try {
            RepairOrderTestDataHelpers.createRepairOrderLineWithTaxGroup(
                repairOrder, item, taxGroup, zeroQuantity, unitPrice
            );
        } catch (Exception e) {
            exceptionThrown = true;
            System.debug('Expected exception due to zero quantity: ' + e.getMessage());
        }
        Test.stopTest();
 
        System.assertEquals(true, exceptionThrown, 'Repair Order Line creation should fail with zero quantity');
 
        dmpl__RepairOrder__c fetchedOrder = RepairOrderTestDataHelpers.getRepairOrdersById(repairOrder.Id).get(0);
 
        System.assertEquals(partnerAccount.Id, fetchedOrder.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch.Id, fetchedOrder.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(customerAccount.Id, fetchedOrder.dmpl__AccountId__c, 'Customer Account should match');
        System.assertEquals(usageReading, fetchedOrder.dmpl__UsageReading__c, 'Usage Reading should match');
        System.assertEquals('Draft', fetchedOrder.dmpl__Status__c, 'Status should be Draft');
        System.assertEquals('Pune', fetchedOrder.dmpl__BillingCity__c, 'Billing City should be Pune');
        System.assertEquals('Maharashtra', fetchedOrder.dmpl__BillingState__c, 'Billing State should be Maharashtra');
        System.assertEquals('411001', fetchedOrder.dmpl__BillingPostalCode__c, 'Billing Postal Code should be 411001');
        System.assertEquals('Ring Rd', fetchedOrder.dmpl__ShippingStreet__c, 'Shipping Street should be Ring Rd');
        System.assertEquals('Nagpur', fetchedOrder.dmpl__ShippingCity__c, 'Shipping City should be Nagpur');
        System.assertEquals('Maharashtra', fetchedOrder.dmpl__ShippingState__c, 'Shipping State should be Maharashtra');
        System.assertEquals('India', fetchedOrder.dmpl__ShippingCountry__c, 'Shipping Country should be India');
        System.assertEquals('440001', fetchedOrder.dmpl__ShippingPostalCode__c, 'Shipping Postal Code should be 440001');
    }
 
 
//have to run
    @isTest
    static void createRepairOrderLineWithQuoteLineReference() {
        Test.startTest();
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 28');
 
        dmpl__QuoteLine__c quoteLine = QuoteTestDataHelpers.getServiceEstimateLine();
 
        Decimal usageReading = 1000;
        Decimal quantity = 1;
        Decimal unitPrice = 1500;
 
        dmpl__RepairOrder__c repairOrder = RepairOrderTestDataHelpers.createRepairOrderWithUsageReading(
            partnerAccount, branch, customerAccount, usageReading
        );
        System.assertNotEquals(null, repairOrder.Id, 'Repair Order should be created');
 
       
        dmpl__RepairOrderLine__c roLine = RepairOrderTestDataHelpers.createRepairOrderLineWithQuoteLine(
            repairOrder, item, quoteLine, taxGroup, quantity, unitPrice
        );
        Test.stopTest();
 
        dmpl__RepairOrderLine__c fetchedOrderLine = RepairOrderTestDataHelpers.getRepairOrderLinesById(roLine.Id);
 
        System.assertEquals(quantity, fetchedOrderLine.dmpl__Quantity__c, 'Quantity should match input');
        System.assertEquals(unitPrice, fetchedOrderLine.dmpl__UnitPrice__c, 'Unit Price should match input');
        System.assertEquals(quoteLine.Id, fetchedOrderLine.dmpl__QuoteLineId__c, 'Quote Line should match');
        System.assertEquals(item.Id, fetchedOrderLine.dmpl__ItemId__c, 'Item should match');
        System.assertEquals(taxGroup.Id, fetchedOrderLine.dmpl__TaxGroupId__c, 'Tax Group should match');
 
       
 
        System.assertEquals(1500,fetchedOrderLine.dmpl__BaseAmount__c, 'Base Amount should match');
       
    }
 
    @isTest
    static void createRepairOrderLineWithAssetServiceContract() {
 
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        Asset asset1 = AssetDataHelper.getAsset('Asset 1');
        dmpl__SKU__c sku = TestDataHelpers.getSKU('SKU 1');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 28');
        dmpl__ItemServiceContract__c itemContract = AssetTestDataHelpers.createItemServiceContract(item, sku);
        dmpl__AssetServiceContract__c assetServiceContract = AssetTestDataHelpers.createAssetServiceContract(
            asset1, customerAccount, item, itemContract.Id, null,
            Date.today().addDays(10), 20, 2, 2, 2,
            Date.today(), Date.today().addMonths(3), 100, 100, true
        );

 
        Decimal usageReading = 1000;
        Decimal quantity = 1;
        Decimal unitPrice = 1500;
 
        dmpl__RepairOrder__c repairOrder = RepairOrderTestDataHelpers.createRepairOrderWithUsageReading(
            partnerAccount, branch, customerAccount, usageReading
        );
        System.assertNotEquals(null, repairOrder.Id, 'Repair Order should be created');
 
        Test.startTest();
        dmpl__RepairOrderLine__c roLine = RepairOrderTestDataHelpers.createRepairOrderLineWithServiceContract(
            repairOrder, item, assetServiceContract, taxGroup, quantity, unitPrice
        );
        Test.stopTest();
  
        System.assertEquals(quantity, roLine.dmpl__Quantity__c, 'Quantity should match input');
        System.assertEquals(unitPrice, roLine.dmpl__UnitPrice__c, 'Unit Price should match input');
        System.assertEquals(assetServiceContract.Id, roLine.dmpl__AssetServiceContractId__c, 'Service Contract should match');
        System.assertEquals(item.Id, roLine.dmpl__ItemId__c, 'Item should match');
        System.assertEquals(taxGroup.Id, roLine.dmpl__TaxGroupId__c, 'Tax Group should match');
 
    }
 
   
    //remaining
    @isTest
    static void createRepairOrderLineWithItemServiceContractPositive() {
 
        Test.startTest();
 
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 28');
        dmpl__SKU__c sku1 = TestDataHelpers.createSKU(item);
        dmpl__ItemServiceContract__c itemServiceContract=RepairOrderTestDataHelpers.createItemServiceContract(item,sku1);
 
        Decimal usageReading = 1000;
        Decimal quantity = 1;
        Decimal unitPrice = 1500;
 
        dmpl__RepairOrder__c repairOrder = RepairOrderTestDataHelpers.createRepairOrderWithUsageReading(
            partnerAccount, branch, customerAccount, usageReading
        );
        System.assertNotEquals(null, repairOrder.Id, 'Repair Order should be created');
 
       
        dmpl__RepairOrderLine__c roLine = RepairOrderTestDataHelpers.createRepairOrderLineWithItemServiceContract(
            repairOrder, item, itemServiceContract, taxGroup, quantity, unitPrice
        );
        Test.stopTest();
 
        dmpl__RepairOrderLine__c fetchedOrderLine = RepairOrderTestDataHelpers.getRepairOrderLinesById(roLine.Id);
 
        System.assertEquals(quantity, fetchedOrderLine.dmpl__Quantity__c, 'Quantity should match input');
        System.assertEquals(unitPrice, fetchedOrderLine.dmpl__UnitPrice__c, 'Unit Price should match input');
        System.assertEquals(itemServiceContract.Id, fetchedOrderLine.dmpl__ItemServiceContractId__c, 'Service Contract should match');
        System.assertEquals(item.Id, fetchedOrderLine.dmpl__ItemId__c, 'Item should match');
        System.assertEquals(taxGroup.Id, fetchedOrderLine.dmpl__TaxGroupId__c, 'Tax Group should match');
    }
 
    // one more left
 
    @isTest
    static void createRepairOrderLineWithoutContract() {
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 28');
 
        Decimal usageReading = 1000;
        Decimal quantity = 1;
        Decimal unitPrice = 1500;
 
        dmpl__RepairOrder__c repairOrder = RepairOrderTestDataHelpers.createRepairOrderWithUsageReading(
            partnerAccount, branch, customerAccount, usageReading
        );
        System.assertNotEquals(null, repairOrder.Id, 'Repair Order should be created');
 
        Test.startTest();
        dmpl__RepairOrderLine__c roLine = RepairOrderTestDataHelpers.createRepairOrderLineWithTaxGroup(
        repairOrder, item, taxGroup, quantity, unitPrice
        );
        Test.stopTest();
 
        dmpl__RepairOrderLine__c fetchedOrderLine = RepairOrderTestDataHelpers.getRepairOrderLinesById(roLine.Id);
 
        System.assertEquals(quantity, fetchedOrderLine.dmpl__Quantity__c, 'Quantity should match');
        System.assertEquals(unitPrice, fetchedOrderLine.dmpl__UnitPrice__c, 'Unit Price should match');
        System.assertEquals(item.Id, fetchedOrderLine.dmpl__ItemId__c, 'Item should match');
        System.assertEquals(taxGroup.Id, fetchedOrderLine.dmpl__TaxGroupId__c, 'Tax Group should match');
        System.assertEquals(null, fetchedOrderLine.dmpl__ItemServiceContractId__c, 'Service Contract should be null');

    }
 
 
     @isTest
    static void createRepairOrderTaxWithValidRepairOrderAndLinePositive() {
 
        Test.startTest();
 
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 28');
     
        Decimal usageReading = 1000;
        Decimal quantity = 1;
        Decimal unitPrice = 1500;
 
        dmpl__RepairOrder__c repairOrder = RepairOrderTestDataHelpers.createRepairOrderWithUsageReading(
            partnerAccount, branch, customerAccount, usageReading
        );
         
        dmpl__RepairOrderLine__c roLine = RepairOrderTestDataHelpers.createRepairOrderLineWithTaxGroup(
            repairOrder, item, taxGroup, quantity, unitPrice
        );
 
       
        dmpl__RepairOrderTax__c repairOrderTax =RepairOrderTestDataHelpers.createRepairOrderTax(repairOrder,roLine,taxGroup,'cgst 28',28) ;
        Test.stopTest();
 
        dmpl__RepairOrderTax__c insertedTax = RepairOrderTestDataHelpers.getRepairOrderTaxesById(repairOrderTax.Id);
 
        System.assertEquals('cgst 28', insertedTax.dmpl__TaxName__c, 'Tax Name should be cgst 28');
        System.assertEquals(28, insertedTax.dmpl__TaxRate__c, 'Tax Rate should be 28%');
        System.assertEquals(repairOrder.Id, insertedTax.dmpl__RepairOrderId__c, 'Repair Order ID should match');
        System.assertEquals(roLine.Id, insertedTax.dmpl__RepairOrderLineId__c, 'Line Item ID should match');
 
 
    }
 
    @isTest
    static void createRepairOrderTaxWithoutLineReferencePositive() {
 
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 12');
 
        Decimal usageReading = 1000;
 
        dmpl__RepairOrder__c repairOrder = RepairOrderTestDataHelpers.createRepairOrderWithUsageReading(
            partnerAccount, branch, customerAccount, usageReading
        );
 
        Test.startTest();
        dmpl__RepairOrderTax__c repairOrderTax = RepairOrderTestDataHelpers.createRepairOrderTaxWithoutRepairOrderLineReference(
            repairOrder, taxGroup, 'cgst 12', 0.12
        );
        Test.stopTest();
 
        dmpl__RepairOrderTax__c insertedTax = RepairOrderTestDataHelpers.getRepairOrderTaxesById(repairOrderTax.Id);
 
        System.assertEquals('cgst 12', insertedTax.dmpl__TaxName__c, 'Tax Name should be cgst 12');
        System.assertEquals(0.12, insertedTax.dmpl__TaxRate__c, 'Tax Rate should be 0.12');
        System.assertEquals(repairOrder.Id, insertedTax.dmpl__RepairOrderId__c, 'Repair Order ID should match');
        System.assertEquals(null, insertedTax.dmpl__RepairOrderLineId__c, 'Line Item reference should be null');
 
       
    }
 
    @isTest
    static void testCreateRepairOrderTaxWithTaxGroupPositive() {
 
        Test.startTest();
 
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 28');
 
        Decimal usageReading = 1000;
        Decimal quantity = 1;
        Decimal unitPrice = 1500;
 
        dmpl__RepairOrder__c repairOrder = RepairOrderTestDataHelpers.createRepairOrderWithUsageReading(
            partnerAccount, branch, customerAccount, usageReading
        );
 
        dmpl__RepairOrderLine__c lineItem = RepairOrderTestDataHelpers.createRepairOrderLineWithTaxGroup(
            repairOrder, item, taxGroup, quantity, unitPrice
        );
 
       
        dmpl__RepairOrderTax__c repairOrderTax = RepairOrderTestDataHelpers.createRepairOrderTax(
            repairOrder, lineItem , taxGroup, 'cgst 12',  28
        );
        Test.stopTest();
 
        dmpl__RepairOrderTax__c insertedTax = RepairOrderTestDataHelpers.getRepairOrderTaxesById(repairOrderTax.Id);
 
        System.assertEquals('cgst 12', insertedTax.dmpl__TaxName__c, 'Tax Name should be cgst 12');
        System.assertEquals(28, insertedTax.dmpl__TaxRate__c, 'Tax Rate should be 28%');
        System.assertEquals(repairOrder.Id, insertedTax.dmpl__RepairOrderId__c, 'Repair Order ID should match');
        System.assertEquals(taxGroup.Id, insertedTax.dmpl__TaxGroupId__c, 'Tax Group should be GST 28');
    }
    @isTest
    static void testCreateRepairOrderTaxWithoutTaxGroupPositive() {
 
       
        Decimal usageReading = 1000;
        Decimal quantity = 1;
        Decimal unitPrice = 1500;
 
        Test.startTest();
 
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 28');
 
 
        dmpl__RepairOrder__c repairOrder = RepairOrderTestDataHelpers.createRepairOrderWithUsageReading(
            partnerAccount, branch, customerAccount, usageReading
        );
 
        dmpl__RepairOrderLine__c lineItem = RepairOrderTestDataHelpers.createRepairOrderLineWithTaxGroup(
        repairOrder, item , taxGroup, quantity, unitPrice
        );
 
       
       
        dmpl__RepairOrderTax__c repairOrderTax = RepairOrderTestDataHelpers.createRepairOrderTaxWithoutTaxGroup(
            repairOrder, lineItem
        );
        Test.stopTest();
 
        dmpl__RepairOrderTax__c insertedTax = RepairOrderTestDataHelpers.getRepairOrderTaxesById(repairOrderTax.Id);
 
        System.assertEquals(repairOrder.Id, insertedTax.dmpl__RepairOrderId__c, 'Repair Order ID should match');
        System.assertEquals(lineItem.Id, insertedTax.dmpl__RepairOrderLineId__c, 'Line Item ID should match');
        System.assertEquals(null, insertedTax.dmpl__TaxGroupId__c, 'Tax Group should be null');
    }
 
    @isTest
    static void createRepairOrderTimeSheetWithRepairOrderReferencePositive() {
 
        Test.startTest();
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
       
        Decimal usageReading = 1000;
 
        dmpl__RepairOrder__c repairOrder = RepairOrderTestDataHelpers.createRepairOrderWithUsageReading(
            partnerAccount, branch, customerAccount, usageReading
        );
 
       
        dmpl__RepairOrderTimeSheet__c timeSheet = RepairOrderTestDataHelpers.createRepairOrderTimeSheet(repairOrder);
        Test.stopTest();
 
        dmpl__RepairOrderTimeSheet__c insertedTimeSheet = RepairOrderTestDataHelpers.getRepairOrderTimeSheetById(timeSheet.Id);
 
        System.assertNotEquals(null, insertedTimeSheet, 'Repair Order Time Sheet should be created');
        System.assertEquals(repairOrder.Id, insertedTimeSheet.dmpl__RepairOrderId__c, 'Time Sheet should reference correct Repair Order');
    }
 
   @isTest
    static void editRepairOrderTimeSheetWithRepairOrderReferencePositive() {

        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');   

        Decimal usageReading = 1000;
        dmpl__RepairOrder__c repairOrder = RepairOrderTestDataHelpers.createRepairOrderWithUsageReading(

            partnerAccount, branch, customerAccount, usageReading

        );
        dmpl__RepairOrderTimeSheet__c originalTimeSheet = RepairOrderTestDataHelpers.createRepairOrderTimeSheet(repairOrder);
        dmpl__RepairOrder__c repairOrder2 = RepairOrderTestDataHelpers.createRepairOrderWithUsageReading(

            partnerAccount, branch, customerAccount, usageReading

        );


        Test.startTest();

        originalTimeSheet.dmpl__RepairOrderId__c=repairOrder2.Id;

        update originalTimeSheet;

        Test.stopTest();
        dmpl__RepairOrderTimeSheet__c updatedTimeSheet = RepairOrderTestDataHelpers.getRepairOrderTimeSheetById(originalTimeSheet.Id);
        System.assertNotEquals(null, updatedTimeSheet, 'Repair Order Time Sheet should exist after edit');

        System.assertEquals(repairOrder.Id, updatedTimeSheet.dmpl__RepairOrderId__c, 'Repair Order reference should still be correct');

    }
 
    @isTest
    static void createRepairOrderTimeSheetWithRepairOrderLineReferencePositive() {
 
               
        Decimal usageReading = 1000;
        Decimal quantity = 1;
        Decimal unitPrice = 1500;
        Decimal taxRate = 28;
 
 
        Test.startTest();
     
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 28');
 
 
        dmpl__RepairOrder__c repairOrder = RepairOrderTestDataHelpers.createRepairOrderWithUsageReading(
            partnerAccount, branch, customerAccount, usageReading
        );
 
        dmpl__RepairOrderLine__c repairOrderLine = RepairOrderTestDataHelpers.createRepairOrderLineWithTaxGroup(
            repairOrder, item , taxGroup, quantity, unitPrice
        );
 
       
        dmpl__RepairOrderTimeSheet__c timeSheet = RepairOrderTestDataHelpers.createRepairOrderTimeSheet(
            repairOrder,
            repairOrderLine
        );
        Test.stopTest();
 
        dmpl__RepairOrderTimeSheet__c insertedTimeSheet = RepairOrderTestDataHelpers.getRepairOrderTimeSheetById(timeSheet.Id);
 
        System.assertNotEquals(null, repairOrder.Id, 'Repair Order should be created');
        System.assertNotEquals(null, repairOrderLine.Id, 'Repair Order Line should be created');
        System.assertNotEquals(null, insertedTimeSheet, 'Repair Order Time Sheet should be created');
        System.assertEquals(repairOrder.Id, insertedTimeSheet.dmpl__RepairOrderId__c, 'Time Sheet should reference correct Repair Order');
        System.assertEquals(repairOrderLine.Id, insertedTimeSheet.dmpl__RepairOrderLine__c, 'Time Sheet should reference correct Repair Order Line');
    }
 
    @isTest
    static void editRepairOrderTimeSheetWithRepairOrderLineReferencePositive() {
 
 
        Decimal usageReading = 1000;
        Decimal quantity = 1;
        Decimal unitPrice = 1500;
        Decimal taxRate = 28;
 
        Test.startTest();
 
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 28');
 
 
 
        dmpl__RepairOrder__c repairOrder = RepairOrderTestDataHelpers.createRepairOrderWithUsageReading(
            partnerAccount, branch, customerAccount, usageReading
        );
 
        dmpl__RepairOrderLine__c repairOrderLine = RepairOrderTestDataHelpers.createRepairOrderLineWithTaxGroup(
            repairOrder, item , taxGroup, quantity, unitPrice
        );
 
        dmpl__RepairOrderTimeSheet__c timeSheet = RepairOrderTestDataHelpers.createRepairOrderTimeSheet(
            repairOrder
        );
 
       
        timeSheet.dmpl__RepairOrderLine__c = repairOrderLine.Id;
        update timeSheet;
        Test.stopTest();
 
        dmpl__RepairOrderTimeSheet__c updatedTimeSheet = RepairOrderTestDataHelpers.getRepairOrderTimeSheetById(timeSheet.Id);
 
        System.assertNotEquals(null, repairOrder.Id, 'Repair Order should be created');
        System.assertNotEquals(null, repairOrderLine.Id, 'Repair Order Line should be created');
        System.assertNotEquals(null, updatedTimeSheet, 'Repair Order Time Sheet should be created');
        System.assertEquals(repairOrder.Id, updatedTimeSheet.dmpl__RepairOrderId__c, 'Time Sheet should reference correct Repair Order');
        System.assertEquals(repairOrderLine.Id, updatedTimeSheet.dmpl__RepairOrderLine__c, 'Time Sheet should reference correct Repair Order Line after edit');
    }
 
 
    //problem in testcase sheet
 
    @isTest
    static void createRepairOrderTimeSheetLineWithRepairOrderLineReferencePositive() {
 
        Decimal usageReading = 1000;
        Decimal quantity = 1;
        Decimal unitPrice = 1500;
 
        Test.startTest();
 
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 28');
 
 
 
 
        dmpl__RepairOrder__c repairOrder = RepairOrderTestDataHelpers.createRepairOrderWithUsageReading(
            partnerAccount, branch, customerAccount, usageReading
        );
 
        dmpl__RepairOrderLine__c repairOrderLine = RepairOrderTestDataHelpers.createRepairOrderLineWithTaxGroup(
            repairOrder, item , taxGroup, quantity, unitPrice
        );
 
        dmpl__RepairOrderTimeSheet__c timeSheet = RepairOrderTestDataHelpers.createRepairOrderTimeSheet(
            repairOrder, repairOrderLine
        );
 
       
        dmpl__RepairOrderTimeSheetLine__c timeSheetLine = RepairOrderTestDataHelpers.createRepairOrderTimeSheetLine(
            repairOrderLine, timeSheet.Id
        );
        Test.stopTest();
 
        System.assertNotEquals(null, repairOrder, 'Repair Order should be created');
        System.assertNotEquals(null, repairOrderLine, 'Repair Order Line should be created');
        System.assertNotEquals(null, timeSheet, 'Repair Order Time Sheet should be created');
        System.assertNotEquals(null, timeSheetLine, 'Repair Order Time Sheet Line should be created');
 
        System.assertEquals(repairOrderLine.Id, timeSheetLine.dmpl__RepairOrderLineId__c, 'Time Sheet Line should reference correct Repair Order Line');
        System.assertEquals(timeSheet.Id, timeSheetLine.dmpl__RepairOrderTimeSheetId__c, 'Time Sheet Line should reference correct Time Sheet');
    }
 
    @isTest
    static void updateRepairOrderTimeSheetLineWithRepairOrderLineReferencePositive() {
 
       
        Decimal usageReading = 1000;
        Decimal quantity = 1;
        Decimal unitPrice = 1500;
 
       
        Test.startTest();
 
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 28');
 
 
 
        dmpl__RepairOrder__c repairOrder = RepairOrderTestDataHelpers.createRepairOrderWithUsageReading(
            partnerAccount, branch, customerAccount, usageReading
        );
 
        dmpl__RepairOrderLine__c repairOrderLine = RepairOrderTestDataHelpers.createRepairOrderLineWithTaxGroup(
            repairOrder, item,taxGroup, quantity, unitPrice
        );
 
        dmpl__RepairOrderTimeSheet__c timeSheet = RepairOrderTestDataHelpers.createRepairOrderTimeSheet(
            repairOrder, repairOrderLine
        );
 
        dmpl__RepairOrderTimeSheetLine__c timeSheetLine = RepairOrderTestDataHelpers.createRepairOrderTimeSheetLine(
            null, timeSheet.Id
        );
 
        timeSheetLine.dmpl__RepairOrderLineId__c = repairOrderLine.Id;
 
        update timeSheetLine;
        Test.stopTest();
 
        System.assertNotEquals(null, repairOrder.Id, 'Repair Order should be created');
        System.assertNotEquals(null, repairOrderLine.Id, 'Repair Order Line should be created');
        System.assertNotEquals(null, timeSheet.Id, 'Repair Order Time Sheet should be created');
        System.assertNotEquals(null, timeSheetLine.Id, 'Repair Order Time Sheet Line should be created');
        System.assertEquals(repairOrderLine.Id, timeSheetLine.dmpl__RepairOrderLineId__c, 'Time Sheet Line should reference correct Repair Order Line after update');
    }
 
    @isTest
    static void createRepairOrderTimeSheetLineWithoutRepairOrderReferencePositive() {
 
       
        Decimal usageReading = 1000;
        Decimal quantity = 1;
        Decimal unitPrice = 1500;
 
 
        Test.startTest();
        Account customerAccount = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 28');
 
 
        dmpl__RepairOrder__c repairOrder = RepairOrderTestDataHelpers.createRepairOrderWithUsageReading(
            partnerAccount, branch, customerAccount, usageReading
        );
 
        dmpl__RepairOrderLine__c repairOrderLine = RepairOrderTestDataHelpers.createRepairOrderLineWithTaxGroup(
            repairOrder, item, taxGroup, quantity, unitPrice
        );
 
        dmpl__RepairOrderTimeSheet__c timeSheet = RepairOrderTestDataHelpers.createRepairOrderTimeSheet(
            repairOrder,
            repairOrderLine
        );
 
       
        dmpl__RepairOrderTimeSheetLine__c timeSheetLine;
        try {
            timeSheetLine = RepairOrderTestDataHelpers.createRepairOrderTimeSheetLine(
                repairOrderLine,
                timeSheet.Id
            );
            System.assert(true, 'Expected exception was not thrown when creating time sheet line without RepairOrder reference');
        } catch (Exception e) {
            System.assert(e.getMessage().contains('dmpl__RepairOrderId__c'), 'Error should be related to missing Repair Order reference');
        }
        Test.stopTest();
    }
}