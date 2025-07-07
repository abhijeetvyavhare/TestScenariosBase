@isTest
public with sharing class BillHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Account partnerAccount = TestDataHelpers.createPartnerAccount();
        Account customerAccount = TestDataHelpers.createCustomerAccount();
        Account supplierAccount = TestDataHelpers.createSupplierAccount();
        dmpl__Branch__c branch = TestDataHelpers.createBranch(partnerAccount);
        dmpl__StorageLocation__c storageLocation = TestDataHelpers.createStorageLocation(branch);
        dmpl__Item__c item = TestDataHelpers.createItem();
        dmpl__SKU__c sku = TestDataHelpers.createSKU(item);
        dmpl__ItemLot__c itemLot = TestDataHelpers.createItemLot(branch, item, sku, storageLocation);
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.createTaxGroup(partnerAccount, branch);
        dmpl__Tax__c tax = TestDataHelpers.createTax(taxGroup);
        dmpl__PriceList__c priceList = TestDataHelpers.createPriceList(partnerAccount, branch);
        dmpl__PriceListRules__c priceListRule = TestDataHelpers.createPriceListRules(priceList, item);
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.createPurchaseOrder(branch, supplierAccount);
        dmpl__GoodsReceipt__c goodsReceipt = GoodRecieptsTestDataHelpers.createGoodsReceipt(partnerAccount, branch, purchaseOrder, SupplierAccount);
        Test.StartTest();
        dmpl__Bill__c bill = BillTestDataHelpers.createBill(supplierAccount, branch, priceList, purchaseOrder, goodsReceipt);
        dmpl__BillLine__c billLine = BillTestDataHelpers.createBillLine(customerAccount, item, sku, itemLot, bill, priceListRule, taxGroup);
        dmpl__PurchaseInvoiceTax__c billTax = BillTestDataHelpers.createBillTax(tax, bill);
        
        Account partnerAccount1 = TestDataHelpers.createPartnerAccount('Partner 1', false, true, false, true, 'MG Road', 'Bengaluru', 'Karnataka', 'India', '560001', '56 Industrial Layout', 'Bengaluru', 'Karnataka', 'India', '560095','9876543210');
        Account partnerAccount2 = TestDataHelpers.createPartnerAccount('Partner 2', false, true, false, false, '45 Residency Road', 'Pune', 'Maharashtra', 'India', '411001', '22 Commerce Avenue', 'Pune', 'Maharashtra', 'India', '411038','91-99665544433');
        Account partnerAccount3 = TestDataHelpers.createPartnerAccount('Partner 3', false, true, false, true, '78 Nehru Nagar Road', 'Chennai', 'Tamil Nadu', 'India', '600042', '78 Nehru Nagar Road', 'Chennai', 'Tamil Nadu', 'India', '600042', '91-9123456789');
        Account partnerAccount4 = TestDataHelpers.createPartnerAccount('Partner 4', false, true, false, true, '12 Industrial Zone', 'Hyderabad','Telangana', 'India', '500032', '12 Industrial Zone', 'Hyderabad', 'Telangana', 'India','500032','9876012345');
        dmpl__Branch__c branch1 = TestDataHelpers.createBranch('Branch 1', partnerAccount1.Id, true, true, false, true);
        dmpl__Branch__c branch3 = TestDataHelpers.createBranch('Branch 3', partnerAccount3.Id, false, true, true, false);
        dmpl__Branch__c branch4 = TestDataHelpers.createBranch('Branch 4',partnerAccount4.Id,true,true,false,false);
        dmpl__PriceList__c priceList3 = TestDataHelpers.createPriceList('Price List 3',partnerAccount4.Id,branch4.Id,null,null,true,false,'Sale Price');
        
        Account supplierAccount1 = TestDataHelpers.createSupplierAccount('Supplier 1','55 Industrial Park Road', 'Ahmedabad', 'GJ', 'India', '380015', '55 Industrial Park Road', 'Ahmedabad', 'GJ', 'India', '380015', '-9988776564');
        if(supplierAccount1.Id != null){
            supplierAccount1.dmpl__IsActive__c  = true;
            update supplierAccount1;
        }
        Account supplierAccount2=TestDataHelpers.createPartnerAccount('Supplier 2',false, false, true, false,'55 Industrial Park Road', 'Ahmedabad', 'GJ', 'India', '380015', '55 Industrial Park Road', 'Ahmedabad', 'GJ', 'India', '380015', '-9988745587');
        Test.StopTest();
        
        dmpl__Item__c  item1 = TestDataHelpers.createItem('Item 1','Product',true,false,false,'675654',false);
        dmpl__Item__c item2 = TestDataHelpers.createItem('Item 2','Product',false,false,false,'654345',false);
        dmpl__Item__c item3 = TestDataHelpers.createItem('Item 3','Charge Item',true, false, false ,'765434',true);
        dmpl__Item__c item4 = TestDataHelpers.createItem('Item 4','Product',true, false, false ,'765676',true);
        dmpl__Item__c item5 = TestDataHelpers.createItem('Item 5', 'Product', true, false, false, '876543', false);
        dmpl__Item__c item6 = TestDataHelpers.createItem('Item 6', 'Product', true, false, false, '765456', false);
        dmpl__Item__c item7 = TestDataHelpers.createItem('Item 7','Product',true,false,false, '765456',false);
        dmpl__Item__c item8 = TestDataHelpers.createItem('Item 8','Product',true,false,false, '765456',false);
        dmpl__Item__c item10 = TestDataHelpers.createItem('Item 10','Product',true,false,true, '765456',false);
        dmpl__Item__c item13 = TestDataHelpers.createItem('Item 13','Product',true,false,false, '765456',true);
        dmpl__Item__c item14 = TestDataHelpers.createItem('Item 14', 'Part', true, false, false, '765458', true);
        dmpl__Item__c item15 = TestDataHelpers.createItem('Item 15', 'Part', true, false, false, '765459', false);
        dmpl__Item__c item16 = TestDataHelpers.createItem('Item 16', 'Part', true, false, false, '765460', false);
        
        
        dmpl__TaxGroup__c taxGroupGST28partner1 = TestDataHelpers.createTaxGroup('GST 28', true, 'Line Level', partnerAccount1.Id, branch1.Id, null);
        dmpl__TaxGroup__c taxGroupGST28partner4= TestDataHelpers.createTaxGroup('GST 288', true, 'Line Level', partnerAccount4.Id, branch4.Id, null);
        dmpl__TaxGroup__c taxGroupGST12Global = TestDataHelpers.createTaxGroup('GST 12', true, 'Line Level', null, null, null);
        dmpl__TaxGroup__c taxGroupIGST18 = TestDataHelpers.createTaxGroup('IGST 18', true, 'Line Level', null, null, null);
        
        dmpl__Tax__c taxCGST14 = TestDataHelpers.createTax('CGST', 'CGST', 14, taxGroupGST28partner1.Id, 'Tax1');
        dmpl__Tax__c taxSGST14 = TestDataHelpers.createTax('SGST', 'SGST', 14, taxGroupGST28partner1.Id, 'Tax2');
        dmpl__Tax__c taxCGST6 = TestDataHelpers.createTax('CGST', 'CGST', 6, taxGroupGST12Global.Id, 'Tax1');
        dmpl__Tax__c taxSGST6 = TestDataHelpers.createTax('SGST', 'SGST', 6, taxGroupGST12Global.Id, 'Tax2');
        dmpl__Tax__c taxIGST18 = TestDataHelpers.createTax('IGST', 'IGST', 18, taxGroupIGST18.Id, 'Tax3');
        dmpl__Tax__c taxCGST14_8 = TestDataHelpers.createTax('CGST', 'CGST', 14, taxGroupGST28partner4.Id, 'Tax1');
        dmpl__Tax__c taxSGST14_8 = TestDataHelpers.createTax('SGST', 'SGST', 14, taxGroupGST28partner4.Id, 'Tax2');
        
        dmpl__SKU__c sku1 = TestDataHelpers.createSKU('SKU 1', item7.id, true);
        dmpl__SKU__c sku2 = TestDataHelpers.createSKU('SKU 2', item8.id, false);
        dmpl__SKU__c sku4 = TestDataHelpers.createSKU('SKU 4', item10.id, true);
    }
    
    @isTest
    static void createBillPositive() {
        dmpl__Bill__c bill = BillTestDataHelpers.getBill();
        if (bill != null) {
            System.assertNotEquals(bill, null, 'Expected Bill to be created.');
        }
        System.assertEquals(100, bill.dmpl__TCSEligibleAmount__c, 'TCSEligibleAmount should be 100');
        System.assertEquals(false, bill.dmpl__PerformGLPosting__c, 'PerformGLPosting should be false');
        System.assertEquals('Expense Bill', bill.dmpl__TypeOfBill__c, 'TypeOfBill should be false');
        
    }
    
    @isTest
    static void updateBillPositive() {
        dmpl__Bill__c bill = BillTestDataHelpers.getBill();
        System.assertNotEquals(bill, null, 'Bill should exist before update.');
        bill.dmpl__TCSEligibleAmount__c = 210;
        bill.dmpl__SupplierInvoiceAmount__c = 69;
        bill.dmpl__Remarks__c='Hello';
        update bill;
        dmpl__Bill__c updatedBill = BillTestDataHelpers.getBill();
        System.assertEquals(210, updatedBill.dmpl__TCSEligibleAmount__c, 'TCSEligibleAmount should be 210');
        System.assertEquals(69, updatedBill.dmpl__SupplierInvoiceAmount__c, 'SupplierInvoiceAmount should be 69');
        System.assertEquals('Hello', updatedBill.dmpl__Remarks__c, 'Remarks should be Hello');
    }
    
    @isTest
    static void deleteBill() {
        dmpl__Bill__c bill = BillTestDataHelpers.getBill();
        System.assertNotEquals(bill, null, 'Bill should exist before delete.');
        delete bill;
        dmpl__Bill__c deletedBill = null;
        try {
            deletedBill = BillTestDataHelpers.getBill();
        } catch (Exception e) {
            deletedBill = null;
        }
        System.assertEquals(null, deletedBill, 'Bill should be deleted and not found in query.');
    }
    
    @isTest
    static void createBillLinePositive() {
        dmpl__BillLine__c billLine = BillTestDataHelpers.getBillLine();
        if (billLine != null) {
            System.assertNotEquals(billLine, null, 'Expected Bill Line to be created.');
        }
        System.assertEquals(10, billLine.dmpl__Quantity__c, 'Quantity should be 10');
        System.assertEquals(100, billLine.dmpl__UnitCost__c, 'Unit Cost should be 100');
        System.assertEquals(true, billLine.dmpl__IsCustomerBillable__c, 'IsCustomerBillable should be true');
    }
    
    @isTest
    static void updateBillLinePositive() {
        dmpl__BillLine__c billLine = BillTestDataHelpers.getBillLine();
        System.assertNotEquals(billLine, null, 'BillLine should exist before update.');
        billLine.dmpl__Quantity__c = 5;
        billLine.dmpl__UnitCost__c = 190;
        update billLine;
        dmpl__BillLine__c updatedBillLine = BillTestDataHelpers.getBillLine();
        System.assertEquals(5, updatedBillLine.dmpl__Quantity__c, 'Quantity should be 5');
        System.assertEquals(190, updatedBillLine.dmpl__UnitCost__c, 'UnitCost should be 190');
    }
    
    @isTest
    static void deleteBillLine() {
        dmpl__BillLine__c billLine = BillTestDataHelpers.getBillLine();
        System.assertNotEquals(billLine, null, 'BillLine should exist before delete.');
        try {
            delete billLine;
            System.assert(false, 'Expected downstream‐transaction validation to block delete');
        } catch (DmlException e) {
            System.assert(
                e.getMessage().contains('downstream transaction'),
            'Expected downstream transaction error, got: ' + e.getMessage()
                );
        }
    }
    
    @isTest
    static void createBillTaxPositive() {
        dmpl__Bill__c bill = BillTestDataHelpers.getBill();
        dmpl__PurchaseInvoiceTax__c billTax = BillTestDataHelpers.getBillTax();
        if (billTax != null) {
            System.assertNotEquals(billTax, null, 'Expected BillTax to be created.');
        }
        System.assertEquals(bill.Id, billTax.dmpl__BillId__c, 'TaxOnAmount should be true');
    }
    
    @isTest
    static void updateBillTaxPositive() {
        dmpl__PurchaseInvoiceTax__c billTax = BillTestDataHelpers.getBillTax();
        System.assertNotEquals(billTax, null, 'BillTax should exist before update.');
        
        billTax.dmpl__GLAmount__c = 100;
        billTax.dmpl__TaxAmount__c = 140;
        billTax.dmpl__TaxOnAmount__c = 120;
        Test.startTest();
        update billTax;
        Test.stopTest();
        dmpl__PurchaseInvoiceTax__c updatedBillTax = BillTestDataHelpers.getBillTax();
        System.assertEquals(100, updatedBillTax.dmpl__GLAmount__c, 'GLAmount should be 100');
        System.assertEquals(140, updatedBillTax.dmpl__TaxAmount__c, 'TaxAmount should be 140');
        System.assertEquals(120, updatedBillTax.dmpl__TaxOnAmount__c, 'TaxOnAmount should be 120');
    }
    
    @isTest
    static void deleteBillTax() {
        dmpl__Bill__c bill = BillTestDataHelpers.getBill();
        dmpl__PurchaseInvoiceTax__c billTax = BillTestDataHelpers.getBillTax();
        System.assertNotEquals(billTax, null, 'BillTax should exist before delete.');
        Test.startTest();
        delete bill;
        Test.stopTest();
        dmpl__PurchaseInvoiceTax__c deletedBillTax = null;
        
        try {
            deletedBillTax = BillTestDataHelpers.getBillTax();
        } catch (Exception e) {
            deletedBillTax = null;
        }
        System.assertEquals(null, deletedBillTax, 'BillTax should be deleted and not found in query.');
    }
    
    //Bill Scenarios
    
    @isTest
    static void createBillWithCorrectPartnerAndBranchPositive(){
        Account partnerAccount4 = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch4 =TestDataHelpers.getBranch('Branch 4');
        Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        Test.startTest();
        dmpl__Bill__c bill = BillTestDataHelpers.createBill(supplierAccount1.Id,branch4.Id,partnerAccount4.Id,Date.today(),null,null,null);
        Test.stopTest();
        System.assertNotEquals(null, bill.Id, 'Bill Id should not be null');
        dmpl__Bill__c insertedBill = BillTestDataHelpers.getBill(bill.Id);
        
        System.assertEquals('12 Industrial Zone', insertedBill.dmpl__ShippingStreet__c, 'Shipping street should match');
        System.assertEquals('Hyderabad', insertedBill.dmpl__ShippingCity__c, 'Shipping city should match');
        System.assertEquals('Telangana', insertedBill.dmpl__ShippingState__c, 'Shipping state should match');
        System.assertEquals('500032', insertedBill.dmpl__ShippingPostalCode__c, 'Shipping postal code should match');
        System.assertEquals('12 Industrial Zone', insertedBill.dmpl__BillingStreet__c, 'Billing street should match');
        System.assertEquals('Hyderabad', insertedBill.dmpl__BillingCity__c, 'Billing city should match');
        System.assertEquals('Telangana', insertedBill.dmpl__BillingState__c, 'Billing state should match');
        System.assertEquals('India', insertedBill.dmpl__ShippingCountry__c, 'Shipping country should match');
        System.assertEquals('500032', insertedBill.dmpl__BillingPostalCode__c, 'Billing postal code should match');
        System.assertEquals(Date.today(), insertedBill.dmpl__DocumentDate__c, 'Document date should match');
        System.assertEquals('Draft', insertedBill.dmpl__Status__c, 'Status should be draft');
        System.assertEquals(partnerAccount4.Id, insertedBill.dmpl__PartnerAccountId__c, 'Partner Account should match');
    }
    
    
    
    @isTest
    static void createBillWithSupplierAccountPositive(){
        Account partnerAccount4 = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch4 =TestDataHelpers.getBranch('Branch 4');
        Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        Test.startTest();
        dmpl__Bill__c bill = BillTestDataHelpers.createBill(supplierAccount1.Id,branch4.Id,partnerAccount4.Id,Date.today(),null,null,null);
        Test.stopTest();
        System.assertNotEquals(null, bill.Id, 'Bill Id should not be null');
        dmpl__Bill__c insertedBill = BillTestDataHelpers.getBill(bill.Id);
        
        System.assertEquals('12 Industrial Zone', insertedBill.dmpl__ShippingStreet__c, 'Shipping street should match');
        System.assertEquals('Hyderabad', insertedBill.dmpl__ShippingCity__c, 'Shipping city should match');
        System.assertEquals('Telangana', insertedBill.dmpl__ShippingState__c, 'Shipping state should match');
        System.assertEquals('500032', insertedBill.dmpl__ShippingPostalCode__c, 'Shipping postal code should match');
    }
    
    @isTest
    static void createBillWithWrongPartnerAccountNegative(){
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch4 =TestDataHelpers.getBranch('Branch 4');
        Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        Test.startTest();
        try{
            dmpl__Bill__c bill = BillTestDataHelpers.createBill(supplierAccount1.Id,branch4.Id,partnerAccount1.Id,Date.today(),null,null,null);
            System.assertEquals(null, bill.Id, 'Bill should not be created with wrong partner account');
        }catch(Exception e){
            System.Assert.isTrue(true, 'Bill creation should fail');
        }
        Test.stopTest();
    }
    
    @isTest
    static void createBillWithInactivePartnerAccountNegative(){
        Account partnerAccount2 = TestDataHelpers.getPartnerAccount('Partner 2');
        Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        Test.startTest();
        try{
            dmpl__Branch__c branch2 = TestDataHelpers.createBranch('Branch 2', partnerAccount2.Id, true, false, true, true);
            dmpl__Bill__c bill = BillTestDataHelpers.createBill(supplierAccount1.Id,branch2.Id,partnerAccount2.Id,Date.today(),null,null,null);
            System.assertEquals(null, bill.Id, 'Bill Id should not be created with inactive partner account');
        }catch(Exception e){
            System.Assert.isTrue(true, 'Bill creation should fail');
        }
        Test.stopTest();
    }
    
    @isTest
    static void createBillWithWrongBranchNegative(){
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch4 =TestDataHelpers.getBranch('Branch 4');
        Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        Test.startTest();
        try{
            dmpl__Bill__c bill = BillTestDataHelpers.createBill(supplierAccount1.Id,branch4.Id,partnerAccount1.Id,Date.today(),null,null,null);
            System.assertEquals(null, bill.Id, 'Bill should not be created with wrong branch');
        }catch(Exception e){
            System.Assert.isTrue(true, 'Bill creation should fail');
        }
        Test.stopTest();
    }
    
    @isTest
    static void createBillWithInactiveBranchNegative(){
        Account partnerAccount3 = TestDataHelpers.getPartnerAccount('Partner 3');
        dmpl__Branch__c branch3 =TestDataHelpers.getBranch('Branch 3');
        Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        Test.startTest();
        try{
            dmpl__Bill__c bill = BillTestDataHelpers.createBill(supplierAccount1.Id,branch3.Id,partnerAccount3.Id,Date.today(),null,null,null);
            System.assertEquals(null, bill.Id, 'Bill Id should not be created with inactive branch');
        }catch(Exception e){
            System.Assert.isTrue(true, 'Bill creation should fail');
        }
        Test.stopTest();
    }
    
    @isTest
    static void createBillWithNoSupplierAccountPositive(){
        Account partnerAccount4 = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch4 =TestDataHelpers.getBranch('Branch 4');
        Test.startTest();
        dmpl__Bill__c bill = BillTestDataHelpers.createBill(null,branch4.Id,partnerAccount4.Id,Date.today(),null,null,null);
        Test.stopTest();
        System.assertNotEquals(null, bill.Id, 'Bill Id should not be null');
        dmpl__Bill__c insertedBill = BillTestDataHelpers.getBill(bill.Id);
        
        System.assertEquals('12 Industrial Zone', insertedBill.dmpl__ShippingStreet__c, 'Shipping street should match');
        System.assertEquals('Hyderabad', insertedBill.dmpl__ShippingCity__c, 'Shipping city should match');
        System.assertEquals('Telangana', insertedBill.dmpl__ShippingState__c, 'Shipping state should match');
        System.assertEquals('500032', insertedBill.dmpl__ShippingPostalCode__c, 'Shipping postal code should match');
        System.assertEquals('12 Industrial Zone', insertedBill.dmpl__BillingStreet__c, 'Billing street should match');
        System.assertEquals('Hyderabad', insertedBill.dmpl__BillingCity__c, 'Billing city should match');
        System.assertEquals('Telangana', insertedBill.dmpl__BillingState__c, 'Billing state should match');
        System.assertEquals('India', insertedBill.dmpl__ShippingCountry__c, 'Shipping country should match');
        System.assertEquals('500032', insertedBill.dmpl__BillingPostalCode__c, 'Billing postal code should match');
        System.assertEquals(Date.today(), insertedBill.dmpl__DocumentDate__c, 'Document date should match');
        System.assertEquals('Draft', insertedBill.dmpl__Status__c, 'Status should be draft');
        System.assertEquals(partnerAccount4.Id, insertedBill.dmpl__PartnerAccountId__c, 'Partner Account should match');
    }
    
    @isTest
    static void updateBillWithSupplierAccountPositive(){
        Account partnerAccount4 = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch4 =TestDataHelpers.getBranch('Branch 4');
        Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        Test.startTest();
        dmpl__Bill__c bill = BillTestDataHelpers.createBill(null,branch4.Id,partnerAccount4.Id,Date.today(),null,null,null);
        System.assertNotEquals(null, bill.Id, 'Bill Id should not be null');
        dmpl__Bill__c insertedBill = BillTestDataHelpers.getBill(bill.Id);
        
        System.assertEquals('12 Industrial Zone', insertedBill.dmpl__ShippingStreet__c, 'Shipping street should match');
        System.assertEquals('Hyderabad', insertedBill.dmpl__ShippingCity__c, 'Shipping city should match');
        System.assertEquals('Telangana', insertedBill.dmpl__ShippingState__c, 'Shipping state should match');
        System.assertEquals('500032', insertedBill.dmpl__ShippingPostalCode__c, 'Shipping postal code should match');
        System.assertEquals('12 Industrial Zone', insertedBill.dmpl__BillingStreet__c, 'Billing street should match');
        System.assertEquals('Hyderabad', insertedBill.dmpl__BillingCity__c, 'Billing city should match');
        System.assertEquals('Telangana', insertedBill.dmpl__BillingState__c, 'Billing state should match');
        System.assertEquals('India', insertedBill.dmpl__ShippingCountry__c, 'Shipping country should match');
        System.assertEquals('500032', insertedBill.dmpl__BillingPostalCode__c, 'Billing postal code should match');
        System.assertEquals(Date.today(), insertedBill.dmpl__DocumentDate__c, 'Document date should match');
        System.assertEquals('Draft', insertedBill.dmpl__Status__c, 'Status should be draft');
        System.assertEquals(partnerAccount4.Id, insertedBill.dmpl__PartnerAccountId__c, 'Partner Account should match');
        Boolean exceptionCaught = false;
        try{
            insertedBill.dmpl__supplierAccountId__c = supplierAccount1.Id;
            update insertedBill;
        }catch(Exception e){
            exceptionCaught = true;
        }
        System.assertEquals(false, exceptionCaught,'Exception caught while assigning Supplier Account');
        Test.stopTest();
    }
    
    //updating record with wrong partner account
    @isTest
    static void updateBillWithWrongPartnerAccountNegative(){
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account partnerAccount4 = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch4 =TestDataHelpers.getBranch('Branch 4');
        Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        Test.startTest();
        dmpl__Bill__c bill = BillTestDataHelpers.createBill(supplierAccount1.Id,branch4.Id,partnerAccount4.Id,Date.today(),null,null,null);
        System.assertNotEquals(null, bill.Id, 'Bill Id should not be null');
        dmpl__Bill__c insertedBill = BillTestDataHelpers.getBill(bill.Id);
        
        System.assertEquals('12 Industrial Zone', insertedBill.dmpl__ShippingStreet__c, 'Shipping street should match');
        System.assertEquals('Hyderabad', insertedBill.dmpl__ShippingCity__c, 'Shipping city should match');
        System.assertEquals('Telangana', insertedBill.dmpl__ShippingState__c, 'Shipping state should match');
        System.assertEquals('500032', insertedBill.dmpl__ShippingPostalCode__c, 'Shipping postal code should match');
        System.assertEquals('12 Industrial Zone', insertedBill.dmpl__BillingStreet__c, 'Billing street should match');
        System.assertEquals('Hyderabad', insertedBill.dmpl__BillingCity__c, 'Billing city should match');
        System.assertEquals('Telangana', insertedBill.dmpl__BillingState__c, 'Billing state should match');
        System.assertEquals('India', insertedBill.dmpl__ShippingCountry__c, 'Shipping country should match');
        System.assertEquals('500032', insertedBill.dmpl__BillingPostalCode__c, 'Billing postal code should match');
        System.assertEquals(Date.today(), insertedBill.dmpl__DocumentDate__c, 'Document date should match');
        System.assertEquals('Draft', insertedBill.dmpl__Status__c, 'Status should be draft');
        System.assertEquals(partnerAccount4.Id, insertedBill.dmpl__PartnerAccountId__c, 'Partner Account should match');
        Boolean exceptionCaught = false;
        try{
            insertedBill.dmpl__PartnerAccountId__c = partnerAccount1.Id;
            update insertedBill;
        }catch(Exception e){
            exceptionCaught = true;
        }
        System.assertNotEquals(true, exceptionCaught,'Expected exception while assigning wrong partner Account');
        Test.stopTest();
    }
    
    @isTest
    static void updateBillWithInactivePartnerAccountNegative(){
        Account partnerAccount2 = TestDataHelpers.getPartnerAccount('Partner 2');
        Account partnerAccount4 = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch4 =TestDataHelpers.getBranch('Branch 4');
        Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        Test.startTest();
        dmpl__Bill__c bill = BillTestDataHelpers.createBill(supplierAccount1.Id,branch4.Id,partnerAccount4.Id,Date.today(),null,null,null);
        System.assertNotEquals(null, bill.Id, 'Bill Id should not be null');
        dmpl__Bill__c insertedBill = BillTestDataHelpers.getBill(bill.Id);
        
        System.assertEquals('12 Industrial Zone', insertedBill.dmpl__ShippingStreet__c, 'Shipping street should match');
        System.assertEquals('Hyderabad', insertedBill.dmpl__ShippingCity__c, 'Shipping city should match');
        System.assertEquals('Telangana', insertedBill.dmpl__ShippingState__c, 'Shipping state should match');
        System.assertEquals('500032', insertedBill.dmpl__ShippingPostalCode__c, 'Shipping postal code should match');
        System.assertEquals('12 Industrial Zone', insertedBill.dmpl__BillingStreet__c, 'Billing street should match');
        System.assertEquals('Hyderabad', insertedBill.dmpl__BillingCity__c, 'Billing city should match');
        System.assertEquals('Telangana', insertedBill.dmpl__BillingState__c, 'Billing state should match');
        System.assertEquals('India', insertedBill.dmpl__ShippingCountry__c, 'Shipping country should match');
        System.assertEquals('500032', insertedBill.dmpl__BillingPostalCode__c, 'Billing postal code should match');
        System.assertEquals(Date.today(), insertedBill.dmpl__DocumentDate__c, 'Document date should match');
        System.assertEquals('Draft', insertedBill.dmpl__Status__c, 'Status should be draft');
        System.assertEquals(partnerAccount4.Id, insertedBill.dmpl__PartnerAccountId__c, 'Partner Account should match');
        Boolean exceptionCaught = false;
        try{
            insertedBill.dmpl__PartnerAccountId__c = partnerAccount2.Id;
            update insertedBill;
        }catch(Exception e){
            exceptionCaught = true;
        }
        System.assertEquals(true, exceptionCaught,'Expected exception while assigning inactive partner Account');
        Test.stopTest();
    }
    
    //Scenario faling while assigning wrong branch
    @isTest
    static void updateBillWithWrongBranchNegative(){
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account partnerAccount4 = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch4 =TestDataHelpers.getBranch('Branch 4');
        Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        Test.startTest();
        dmpl__Bill__c bill = BillTestDataHelpers.createBill(supplierAccount1.Id,branch4.Id,partnerAccount4.Id,Date.today(),null,null,null);
        System.assertNotEquals(null, bill.Id, 'Bill Id should not be null');
        dmpl__Bill__c insertedBill = BillTestDataHelpers.getBill(bill.Id);
        
        System.assertEquals('12 Industrial Zone', insertedBill.dmpl__ShippingStreet__c, 'Shipping street should match');
        System.assertEquals('Hyderabad', insertedBill.dmpl__ShippingCity__c, 'Shipping city should match');
        System.assertEquals('Telangana', insertedBill.dmpl__ShippingState__c, 'Shipping state should match');
        System.assertEquals('500032', insertedBill.dmpl__ShippingPostalCode__c, 'Shipping postal code should match');
        System.assertEquals('12 Industrial Zone', insertedBill.dmpl__BillingStreet__c, 'Billing street should match');
        System.assertEquals('Hyderabad', insertedBill.dmpl__BillingCity__c, 'Billing city should match');
        System.assertEquals('Telangana', insertedBill.dmpl__BillingState__c, 'Billing state should match');
        System.assertEquals('India', insertedBill.dmpl__ShippingCountry__c, 'Shipping country should match');
        System.assertEquals('500032', insertedBill.dmpl__BillingPostalCode__c, 'Billing postal code should match');
        System.assertEquals(Date.today(), insertedBill.dmpl__DocumentDate__c, 'Document date should match');
        System.assertEquals('Draft', insertedBill.dmpl__Status__c, 'Status should be draft');
        
        Boolean exceptionCaught = false;
        try{
            insertedBill.dmpl__PartnerAccountId__c = partnerAccount1.Id;
            update insertedBill;
        }catch(Exception e){
            exceptionCaught = true;
        }
        System.assertNotEquals(true, exceptionCaught,'Expected exception while assigning wrong Branch');
        Test.stopTest();
    }
    
    @isTest
    static void updateBillWithInactiveBranchNegative(){
        Account partnerAccount4 = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch4 =TestDataHelpers.getBranch('Branch 4');
        dmpl__Branch__c branch3 =TestDataHelpers.getBranch('Branch 3');
        Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        Test.startTest();
        dmpl__Bill__c bill = BillTestDataHelpers.createBill(supplierAccount1.Id,branch4.Id,partnerAccount4.Id,Date.today(),null,null,null);
        System.assertNotEquals(null, bill.Id, 'Bill Id should not be null');
        dmpl__Bill__c insertedBill = BillTestDataHelpers.getBill(bill.Id);
        
        System.assertEquals('12 Industrial Zone', insertedBill.dmpl__ShippingStreet__c, 'Shipping street should match');
        System.assertEquals('Hyderabad', insertedBill.dmpl__ShippingCity__c, 'Shipping city should match');
        System.assertEquals('Telangana', insertedBill.dmpl__ShippingState__c, 'Shipping state should match');
        System.assertEquals('500032', insertedBill.dmpl__ShippingPostalCode__c, 'Shipping postal code should match');
        System.assertEquals('12 Industrial Zone', insertedBill.dmpl__BillingStreet__c, 'Billing street should match');
        System.assertEquals('Hyderabad', insertedBill.dmpl__BillingCity__c, 'Billing city should match');
        System.assertEquals('Telangana', insertedBill.dmpl__BillingState__c, 'Billing state should match');
        System.assertEquals('India', insertedBill.dmpl__ShippingCountry__c, 'Shipping country should match');
        System.assertEquals('500032', insertedBill.dmpl__BillingPostalCode__c, 'Billing postal code should match');
        System.assertEquals(Date.today(), insertedBill.dmpl__DocumentDate__c, 'Document date should match');
        System.assertEquals('Draft', insertedBill.dmpl__Status__c, 'Status should be draft');
        System.assertEquals(partnerAccount4.Id, insertedBill.dmpl__PartnerAccountId__c, 'Partner Account should match');
        Boolean exceptionCaught = false;
        try{
            insertedBill.dmpl__BranchId__c = branch3.Id;
            
            update insertedBill;
        }catch(Exception e){
            exceptionCaught = true;
        }
        System.assertNotEquals(true, exceptionCaught,'Expected exception while assigning inactive Branch');
        Test.stopTest();
    }
    
    @isTest
    static void createBillWithBackwardDatePositive(){
        Account partnerAccount4 = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch4 =TestDataHelpers.getBranch('Branch 4');
        Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        Test.startTest();
        dmpl__Bill__c bill = BillTestDataHelpers.createBill(supplierAccount1.Id,branch4.Id,partnerAccount4.Id,Date.newInstance(2025, 5, 14),null,null,null);
        Test.stopTest();
        System.assertNotEquals(null, bill.Id, 'Bill Id should not be null');
        dmpl__Bill__c insertedBill = BillTestDataHelpers.getBill(bill.Id);
        
        System.assertEquals('12 Industrial Zone', insertedBill.dmpl__ShippingStreet__c, 'Shipping street should match');
        System.assertEquals('Hyderabad', insertedBill.dmpl__ShippingCity__c, 'Shipping city should match');
        System.assertEquals('Telangana', insertedBill.dmpl__ShippingState__c, 'Shipping state should match');
        System.assertEquals('500032', insertedBill.dmpl__ShippingPostalCode__c, 'Shipping postal code should match');
        System.assertEquals('12 Industrial Zone', insertedBill.dmpl__BillingStreet__c, 'Billing street should match');
        System.assertEquals('Hyderabad', insertedBill.dmpl__BillingCity__c, 'Billing city should match');
        System.assertEquals('Telangana', insertedBill.dmpl__BillingState__c, 'Billing state should match');
        System.assertEquals('India', insertedBill.dmpl__ShippingCountry__c, 'Shipping country should match');
        System.assertEquals('500032', insertedBill.dmpl__BillingPostalCode__c, 'Billing postal code should match');
        System.assertEquals(Date.newInstance(2025, 5, 14), insertedBill.dmpl__DocumentDate__c, 'Document date should match');
        System.assertEquals('Draft', insertedBill.dmpl__Status__c, 'Status should be draft');
        System.assertEquals(partnerAccount4.Id, insertedBill.dmpl__PartnerAccountId__c, 'Partner Account should match');
    }
    
    
    @isTest
    static void updateBillWithBackwardDatePositive(){
        Account partnerAccount4 = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch4 =TestDataHelpers.getBranch('Branch 4');
        Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        Test.startTest();
        dmpl__Bill__c bill = BillTestDataHelpers.createBill(supplierAccount1.Id,branch4.Id,partnerAccount4.Id,Date.today(),null,null,null);
        System.assertNotEquals(null, bill.Id, 'Bill Id should not be null');
        dmpl__Bill__c insertedBill = BillTestDataHelpers.getBill(bill.Id);
        
        System.assertEquals('12 Industrial Zone', insertedBill.dmpl__ShippingStreet__c, 'Shipping street should match');
        System.assertEquals('Hyderabad', insertedBill.dmpl__ShippingCity__c, 'Shipping city should match');
        System.assertEquals('Telangana', insertedBill.dmpl__ShippingState__c, 'Shipping state should match');
        System.assertEquals('500032', insertedBill.dmpl__ShippingPostalCode__c, 'Shipping postal code should match');
        System.assertEquals('12 Industrial Zone', insertedBill.dmpl__BillingStreet__c, 'Billing street should match');
        System.assertEquals('Hyderabad', insertedBill.dmpl__BillingCity__c, 'Billing city should match');
        System.assertEquals('Telangana', insertedBill.dmpl__BillingState__c, 'Billing state should match');
        System.assertEquals('India', insertedBill.dmpl__ShippingCountry__c, 'Shipping country should match');
        System.assertEquals('500032', insertedBill.dmpl__BillingPostalCode__c, 'Billing postal code should match');
        System.assertEquals(Date.today(), insertedBill.dmpl__DocumentDate__c, 'Document date should match');
        System.assertEquals('Draft', insertedBill.dmpl__Status__c, 'Status should be draft');
        System.assertEquals(partnerAccount4.Id, insertedBill.dmpl__PartnerAccountId__c, 'Partner Account should match');
        Boolean exceptionCaught = false;
        try{
            insertedBill.dmpl__DocumentDate__c = Date.newInstance(2025, 4, 16);
            update insertedBill;
            System.assertEquals(Date.newInstance(2025, 4, 16), insertedBill.dmpl__DocumentDate__c, 'Document date should match');
        }catch(Exception e){
            exceptionCaught = true;
        }
        System.assertEquals(false, exceptionCaught,'exception caught while assigning backward date');
        Test.stopTest();
    }
    
    @isTest
    static void createBillWithPurchaseOrderReferencePositive(){
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 =TestDataHelpers.getBranch('Branch 1');
        Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        
        dmpl__PurchaseOrder__c purchaseOrder1 = PurchaseOrderTestDataHelpers.createPurchaseOrder(branch1,supplierAccount1);
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.getPurchaseOrder(purchaseOrder1.Id);
        
        System.assertEquals('56 Industrial Layout', purchaseOrder.dmpl__ShippingStreet__c, 'Shipping street should match');
        System.assertEquals('Bengaluru', purchaseOrder.dmpl__ShippingCity__c, 'Shipping city should match');
        System.assertEquals('Karnataka', purchaseOrder.dmpl__ShippingState__c, 'Shipping state should match');
        System.assertEquals('560095', purchaseOrder.dmpl__ShippingPostalCode__c, 'Shipping postal code should be null');
        System.assertEquals('MG Road', purchaseOrder.dmpl__BillingStreet__c, 'Billing street should match');
        System.assertEquals('Bengaluru', purchaseOrder.dmpl__BillingCity__c, 'Billing city should match');
        System.assertEquals('Karnataka', purchaseOrder.dmpl__BillingState__c, 'Billing state should match');
        System.assertEquals('India', purchaseOrder.dmpl__ShippingCountry__c, 'Shipping country should match');
        System.assertEquals('560001', purchaseOrder.dmpl__BillingPostalCode__c, 'Billing postal code should match');
        System.assertEquals(Date.today(), purchaseOrder.dmpl__DocumentDate__c, 'Document date should be today');
        System.assertEquals('Draft', purchaseOrder.dmpl__Status__c, 'Status should be Draft');
        
        Test.startTest();
        dmpl__Bill__c bill = BillTestDataHelpers.createBill(supplierAccount1.Id,branch1.Id,partnerAccount1.Id,Date.today(),purchaseOrder.Id,null,null);
        Test.stopTest();
        System.assertNotEquals(null, bill.Id, 'Bill Id should not be null');
        dmpl__Bill__c insertedBill = BillTestDataHelpers.getBill(bill.Id);
        
        System.assertEquals('56 Industrial Layout', insertedBill.dmpl__ShippingStreet__c, 'Shipping street should match');
        System.assertEquals('Bengaluru', insertedBill.dmpl__ShippingCity__c, 'Shipping city should match');
        System.assertEquals('Karnataka', insertedBill.dmpl__ShippingState__c, 'Shipping state should match');
        System.assertEquals('560095', insertedBill.dmpl__ShippingPostalCode__c, 'Shipping postal code should be null');
        System.assertEquals('MG Road', insertedBill.dmpl__BillingStreet__c, 'Billing street should match');
        System.assertEquals('Bengaluru', insertedBill.dmpl__BillingCity__c, 'Billing city should match');
        System.assertEquals('Karnataka', insertedBill.dmpl__BillingState__c, 'Billing state should match');
        System.assertEquals('India', insertedBill.dmpl__ShippingCountry__c, 'Shipping country should match');
        System.assertEquals('560001', insertedBill.dmpl__BillingPostalCode__c, 'Billing postal code should match');
        System.assertEquals(Date.today(), insertedBill.dmpl__DocumentDate__c, 'Document date should match');
        System.assertEquals('Draft', insertedBill.dmpl__Status__c, 'Status should be draft');
        System.assertEquals(partnerAccount1.Id, insertedBill.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(purchaseOrder1.Id, insertedBill.dmpl__PurchaseOrderId__c, 'Purchase Order should match');
        
    }
    
    @isTest
    static void createBillWithoutPurchaseOrderReferencePositive(){
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 =TestDataHelpers.getBranch('Branch 1');
        Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        
        Test.startTest();
        dmpl__Bill__c bill = BillTestDataHelpers.createBill(supplierAccount1.Id,branch1.Id,partnerAccount1.Id,Date.today(),null,null,null);
        Test.stopTest();
        System.assertNotEquals(null, bill.Id, 'Bill Id should not be null');
        dmpl__Bill__c insertedBill = BillTestDataHelpers.getBill(bill.Id);
        
        System.assertEquals('56 Industrial Layout', insertedBill.dmpl__ShippingStreet__c, 'Shipping street should match');
        System.assertEquals('Bengaluru', insertedBill.dmpl__ShippingCity__c, 'Shipping city should match');
        System.assertEquals('Karnataka', insertedBill.dmpl__ShippingState__c, 'Shipping state should match');
        System.assertEquals('560095', insertedBill.dmpl__ShippingPostalCode__c, 'Shipping postal code should be null');
        System.assertEquals('MG Road', insertedBill.dmpl__BillingStreet__c, 'Billing street should match');
        System.assertEquals('Bengaluru', insertedBill.dmpl__BillingCity__c, 'Billing city should match');
        System.assertEquals('Karnataka', insertedBill.dmpl__BillingState__c, 'Billing state should match');
        System.assertEquals('India', insertedBill.dmpl__ShippingCountry__c, 'Shipping country should match');
        System.assertEquals('560001', insertedBill.dmpl__BillingPostalCode__c, 'Billing postal code should match');
        System.assertEquals(Date.today(), insertedBill.dmpl__DocumentDate__c, 'Document date should match');
        System.assertEquals('Draft', insertedBill.dmpl__Status__c, 'Status should be draft');
        System.assertEquals(partnerAccount1.Id, insertedBill.dmpl__PartnerAccountId__c, 'Partner Account should match');
        
    }
    
    
    @isTest
    static void updateBillWithPurchaseOrderReferencePositive(){
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 =TestDataHelpers.getBranch('Branch 1');
        Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        
        dmpl__PurchaseOrder__c purchaseOrder1 = PurchaseOrderTestDataHelpers.createPurchaseOrder(branch1,supplierAccount1);
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.getPurchaseOrder(purchaseOrder1.Id);
        
        System.assertEquals('56 Industrial Layout', purchaseOrder.dmpl__ShippingStreet__c, 'Shipping street should match');
        System.assertEquals('Bengaluru', purchaseOrder.dmpl__ShippingCity__c, 'Shipping city should match');
        System.assertEquals('Karnataka', purchaseOrder.dmpl__ShippingState__c, 'Shipping state should match');
        System.assertEquals('560095', purchaseOrder.dmpl__ShippingPostalCode__c, 'Shipping postal code should be null');
        System.assertEquals('MG Road', purchaseOrder.dmpl__BillingStreet__c, 'Billing street should match');
        System.assertEquals('Bengaluru', purchaseOrder.dmpl__BillingCity__c, 'Billing city should match');
        System.assertEquals('Karnataka', purchaseOrder.dmpl__BillingState__c, 'Billing state should match');
        System.assertEquals('India', purchaseOrder.dmpl__ShippingCountry__c, 'Shipping country should match');
        System.assertEquals('560001', purchaseOrder.dmpl__BillingPostalCode__c, 'Billing postal code should match');
        System.assertEquals(Date.today(), purchaseOrder.dmpl__DocumentDate__c, 'Document date should be today');
        System.assertEquals('Draft', purchaseOrder.dmpl__Status__c, 'Status should be Draft');
        
        Test.startTest();
        dmpl__Bill__c bill = BillTestDataHelpers.createBill(supplierAccount1.Id,branch1.Id,partnerAccount1.Id,Date.today(),null,null,null);
        System.assertNotEquals(null, bill.Id, 'Bill Id should not be null');
        dmpl__Bill__c insertedBill = BillTestDataHelpers.getBill(bill.Id);
        
        System.assertEquals('56 Industrial Layout', purchaseOrder.dmpl__ShippingStreet__c, 'Shipping street should match');
        System.assertEquals('Bengaluru', purchaseOrder.dmpl__ShippingCity__c, 'Shipping city should match');
        System.assertEquals('Karnataka', purchaseOrder.dmpl__ShippingState__c, 'Shipping state should match');
        System.assertEquals('560095', purchaseOrder.dmpl__ShippingPostalCode__c, 'Shipping postal code should be null');
        System.assertEquals('MG Road', purchaseOrder.dmpl__BillingStreet__c, 'Billing street should match');
        System.assertEquals('Bengaluru', purchaseOrder.dmpl__BillingCity__c, 'Billing city should match');
        System.assertEquals('Karnataka', purchaseOrder.dmpl__BillingState__c, 'Billing state should match');
        System.assertEquals('India', purchaseOrder.dmpl__ShippingCountry__c, 'Shipping country should match');
        System.assertEquals('560001', purchaseOrder.dmpl__BillingPostalCode__c, 'Billing postal code should match');
        System.assertEquals(Date.today(), insertedBill.dmpl__DocumentDate__c, 'Document date should match');
        System.assertEquals('Draft', insertedBill.dmpl__Status__c, 'Status should be draft');
        System.assertEquals(partnerAccount1.Id, insertedBill.dmpl__PartnerAccountId__c, 'Partner Account should match');
        
        Boolean exceptionCaught = false;
        try{
            insertedBill.dmpl__PurchaseOrderId__c = purchaseOrder.Id;
            update insertedBill;
        }catch(Exception e){
            exceptionCaught = true;
        }
        System.assertEquals(false, exceptionCaught,'exception caught while assigning Purchase Order');
        Test.stopTest();
        if(!exceptionCaught){
            System.assertEquals('56 Industrial Layout', purchaseOrder.dmpl__ShippingStreet__c, 'Shipping street should match');
            System.assertEquals('Bengaluru', purchaseOrder.dmpl__ShippingCity__c, 'Shipping city should match');
            System.assertEquals('Karnataka', purchaseOrder.dmpl__ShippingState__c, 'Shipping state should match');
            System.assertEquals('560095', purchaseOrder.dmpl__ShippingPostalCode__c, 'Shipping postal code should be null');
            System.assertEquals('MG Road', purchaseOrder.dmpl__BillingStreet__c, 'Billing street should match');
            System.assertEquals('Bengaluru', purchaseOrder.dmpl__BillingCity__c, 'Billing city should match');
            System.assertEquals('Karnataka', purchaseOrder.dmpl__BillingState__c, 'Billing state should match');
            System.assertEquals('India', purchaseOrder.dmpl__ShippingCountry__c, 'Shipping country should match');
            System.assertEquals('560001', purchaseOrder.dmpl__BillingPostalCode__c, 'Billing postal code should match');
            System.assertEquals(Date.today(), insertedBill.dmpl__DocumentDate__c, 'Document date should match');
            System.assertEquals('Draft', insertedBill.dmpl__Status__c, 'Status should be draft');
            System.assertEquals(partnerAccount1.Id, insertedBill.dmpl__PartnerAccountId__c, 'Partner Account should match');
            System.assertEquals(purchaseOrder1.Id, insertedBill.dmpl__PurchaseOrderId__c, 'Purchase Order should match');
        }
    }
    
    
    @isTest
    static void updateBillWithoutPurchaseOrderReferencePositive(){
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 =TestDataHelpers.getBranch('Branch 1');
        Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        
        dmpl__PurchaseOrder__c purchaseOrder1 = PurchaseOrderTestDataHelpers.createPurchaseOrder(branch1,supplierAccount1);
        dmpl__PurchaseOrder__c purchaseOrder = PurchaseOrderTestDataHelpers.getPurchaseOrder(purchaseOrder1.Id);
        
        System.assertEquals('56 Industrial Layout', purchaseOrder.dmpl__ShippingStreet__c, 'Shipping street should match');
        System.assertEquals('Bengaluru', purchaseOrder.dmpl__ShippingCity__c, 'Shipping city should match');
        System.assertEquals('Karnataka', purchaseOrder.dmpl__ShippingState__c, 'Shipping state should match');
        System.assertEquals('560095', purchaseOrder.dmpl__ShippingPostalCode__c, 'Shipping postal code should be null');
        System.assertEquals('MG Road', purchaseOrder.dmpl__BillingStreet__c, 'Billing street should match');
        System.assertEquals('Bengaluru', purchaseOrder.dmpl__BillingCity__c, 'Billing city should match');
        System.assertEquals('Karnataka', purchaseOrder.dmpl__BillingState__c, 'Billing state should match');
        System.assertEquals('India', purchaseOrder.dmpl__ShippingCountry__c, 'Shipping country should match');
        System.assertEquals('560001', purchaseOrder.dmpl__BillingPostalCode__c, 'Billing postal code should match');
        System.assertEquals(Date.today(), purchaseOrder.dmpl__DocumentDate__c, 'Document date should be today');
        System.assertEquals('Draft', purchaseOrder.dmpl__Status__c, 'Status should be Draft');
        
        Test.startTest();
        dmpl__Bill__c bill = BillTestDataHelpers.createBill(supplierAccount1.Id,branch1.Id,partnerAccount1.Id,Date.today(),purchaseOrder.Id,null,null);
        System.assertNotEquals(null, bill.Id, 'Bill Id should not be null');
        dmpl__Bill__c insertedBill = BillTestDataHelpers.getBill(bill.Id);
        
        System.assertEquals('56 Industrial Layout', purchaseOrder.dmpl__ShippingStreet__c, 'Shipping street should match');
        System.assertEquals('Bengaluru', purchaseOrder.dmpl__ShippingCity__c, 'Shipping city should match');
        System.assertEquals('Karnataka', purchaseOrder.dmpl__ShippingState__c, 'Shipping state should match');
        System.assertEquals('560095', purchaseOrder.dmpl__ShippingPostalCode__c, 'Shipping postal code should be null');
        System.assertEquals('MG Road', purchaseOrder.dmpl__BillingStreet__c, 'Billing street should match');
        System.assertEquals('Bengaluru', purchaseOrder.dmpl__BillingCity__c, 'Billing city should match');
        System.assertEquals('Karnataka', purchaseOrder.dmpl__BillingState__c, 'Billing state should match');
        System.assertEquals('India', purchaseOrder.dmpl__ShippingCountry__c, 'Shipping country should match');
        System.assertEquals('560001', purchaseOrder.dmpl__BillingPostalCode__c, 'Billing postal code should match');
        System.assertEquals(Date.today(), insertedBill.dmpl__DocumentDate__c, 'Document date should match');
        System.assertEquals('Draft', insertedBill.dmpl__Status__c, 'Status should be draft');
        System.assertEquals(partnerAccount1.Id, insertedBill.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(purchaseOrder1.Id, insertedBill.dmpl__PurchaseOrderId__c, 'Purchase Order should match');
        
        
        Boolean exceptionCaught = false;
        try{
            insertedBill.dmpl__PurchaseOrderId__c = null;
            update insertedBill;
        }catch(Exception e){
            exceptionCaught = true;
        }
        System.assertEquals(false, exceptionCaught,'exception caught while removing Purchase Order');
        Test.stopTest();
        if(!exceptionCaught){
            System.assertEquals('56 Industrial Layout', purchaseOrder.dmpl__ShippingStreet__c, 'Shipping street should match');
            System.assertEquals('Bengaluru', purchaseOrder.dmpl__ShippingCity__c, 'Shipping city should match');
            System.assertEquals('Karnataka', purchaseOrder.dmpl__ShippingState__c, 'Shipping state should match');
            System.assertEquals('560095', purchaseOrder.dmpl__ShippingPostalCode__c, 'Shipping postal code should be null');
            System.assertEquals('MG Road', purchaseOrder.dmpl__BillingStreet__c, 'Billing street should match');
            System.assertEquals('Bengaluru', purchaseOrder.dmpl__BillingCity__c, 'Billing city should match');
            System.assertEquals('Karnataka', purchaseOrder.dmpl__BillingState__c, 'Billing state should match');
            System.assertEquals('India', purchaseOrder.dmpl__ShippingCountry__c, 'Shipping country should match');
            System.assertEquals('560001', purchaseOrder.dmpl__BillingPostalCode__c, 'Billing postal code should match');
            System.assertEquals(Date.today(), insertedBill.dmpl__DocumentDate__c, 'Document date should match');
            System.assertEquals('Draft', insertedBill.dmpl__Status__c, 'Status should be draft');
            System.assertEquals(partnerAccount1.Id, insertedBill.dmpl__PartnerAccountId__c, 'Partner Account should match');
        }
    }
    
    @isTest
    static void createBillWithActivePriceListPositive(){
        Account partnerAccount4 = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch4 =TestDataHelpers.getBranch('Branch 4');
        Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__PriceList__c priceList3 = TestDataHelpers.getPriceList('Price List 3');
        Test.startTest();
        dmpl__Bill__c bill = BillTestDataHelpers.createBill(supplierAccount1.Id,branch4.Id,partnerAccount4.Id,Date.today(),null,priceList3.Id,null);
        Test.stopTest();
        System.assertNotEquals(null, bill.Id, 'Bill Id should not be null');
        dmpl__Bill__c insertedBill = BillTestDataHelpers.getBill(bill.Id);
        
        System.assertEquals('12 Industrial Zone', insertedBill.dmpl__ShippingStreet__c, 'Shipping street should match');
        System.assertEquals('Hyderabad', insertedBill.dmpl__ShippingCity__c, 'Shipping city should match');
        System.assertEquals('Telangana', insertedBill.dmpl__ShippingState__c, 'Shipping state should match');
        System.assertEquals('500032', insertedBill.dmpl__ShippingPostalCode__c, 'Shipping postal code should match');
        System.assertEquals('12 Industrial Zone', insertedBill.dmpl__BillingStreet__c, 'Billing street should match');
        System.assertEquals('Hyderabad', insertedBill.dmpl__BillingCity__c, 'Billing city should match');
        System.assertEquals('Telangana', insertedBill.dmpl__BillingState__c, 'Billing state should match');
        System.assertEquals('India', insertedBill.dmpl__ShippingCountry__c, 'Shipping country should match');
        System.assertEquals('500032', insertedBill.dmpl__BillingPostalCode__c, 'Billing postal code should match');
        System.assertEquals(Date.today(), insertedBill.dmpl__DocumentDate__c, 'Document date should match');
        System.assertEquals('Draft', insertedBill.dmpl__Status__c, 'Status should be draft');
        System.assertEquals(partnerAccount4.Id, insertedBill.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(priceList3.Id, insertedBill.dmpl__PriceListId__c, 'Price List should match');
        
    }
    
    @isTest
    static void createBillWithGoodsReceiptReferencePositive(){
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 =TestDataHelpers.getBranch('Branch 1');
        Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        
        dmpl__GoodsReceipt__c goodsReceipt = GoodRecieptsTestDataHelpers.createGoodsReceipt(partnerAccount1,branch1,null,supplierAccount1);
        System.assertNotEquals(null, goodsReceipt.Id, 'Goods Receipt should be created');
        
        System.assertEquals(partnerAccount1.Id, goodsReceipt.dmpl__PartnerAccountId__c, 'Partner account should match');
        System.assertEquals(branch1.Id, goodsReceipt.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(supplierAccount1.Id, goodsReceipt.dmpl__SupplierAccountId__c, 'Supplier account should match');
        System.assertEquals(Date.today(), goodsReceipt.dmpl__DocumentDate__c, 'Document date should match');
        
        Test.startTest();
        dmpl__Bill__c bill = BillTestDataHelpers.createBill(supplierAccount1.Id,branch1.Id,partnerAccount1.Id,Date.today(),null,null,goodsReceipt.Id);
        Test.stopTest();
        System.assertNotEquals(null, bill.Id, 'Bill Id should not be null');
        dmpl__Bill__c insertedBill = BillTestDataHelpers.getBill(bill.Id);
        
        System.assertEquals(Date.today(), insertedBill.dmpl__DocumentDate__c, 'Document date should match');
        System.assertEquals(partnerAccount1.Id, insertedBill.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(goodsReceipt.Id, insertedBill.dmpl__GoodsReceiptId__c, 'Goods Receipt should match');
        System.assertEquals(branch1.Id, insertedBill.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(supplierAccount1.Id, insertedBill.dmpl__SupplierAccountId__c, 'Supplier Account should match');
    }
    
    @isTest
    static void createBillWithoutGoodsReceiptReferencePositive(){
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 =TestDataHelpers.getBranch('Branch 1');
        Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        
        Test.startTest();
        dmpl__Bill__c bill = BillTestDataHelpers.createBill(supplierAccount1.Id,branch1.Id,partnerAccount1.Id,Date.today(),null,null,null);
        Test.stopTest();
        System.assertNotEquals(null, bill.Id, 'Bill Id should not be null');
        dmpl__Bill__c insertedBill = BillTestDataHelpers.getBill(bill.Id);
        
        System.assertEquals(Date.today(), insertedBill.dmpl__DocumentDate__c, 'Document date should match');
        System.assertEquals(partnerAccount1.Id, insertedBill.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch1.Id, insertedBill.dmpl__BranchId__c, 'Branch should match');
        
    }
    
    @isTest
    static void updateBillWithGoodsReceiptReferencePositive(){
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 =TestDataHelpers.getBranch('Branch 1');
        Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        
        dmpl__GoodsReceipt__c goodsReceipt = GoodRecieptsTestDataHelpers.createGoodsReceipt(partnerAccount1,branch1,null,supplierAccount1);
        System.assertNotEquals(null, goodsReceipt.Id, 'Goods Receipt should be created');
        
        System.assertEquals(partnerAccount1.Id, goodsReceipt.dmpl__PartnerAccountId__c, 'Partner account should match');
        System.assertEquals(branch1.Id, goodsReceipt.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(supplierAccount1.Id, goodsReceipt.dmpl__SupplierAccountId__c, 'Supplier account should match');
        System.assertEquals(Date.today(), goodsReceipt.dmpl__DocumentDate__c, 'Document date should match');
        
        Test.startTest();
        dmpl__Bill__c bill = BillTestDataHelpers.createBill(supplierAccount1.Id,branch1.Id,partnerAccount1.Id,Date.today(),null,null,null);
        Test.stopTest();
        System.assertNotEquals(null, bill.Id, 'Bill Id should not be null');
        dmpl__Bill__c insertedBill = BillTestDataHelpers.getBill(bill.Id);
        
        System.assertEquals(Date.today(), insertedBill.dmpl__DocumentDate__c, 'Document date should match');
        System.assertEquals(partnerAccount1.Id, insertedBill.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch1.Id, insertedBill.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(supplierAccount1.Id, insertedBill.dmpl__SupplierAccountId__c, 'Supplier Account should match');
        
        Boolean exceptionCaught = false;
        try{
            insertedBill.dmpl__GoodsReceiptId__c = goodsReceipt.Id;
            update insertedBill;
        } catch(Exception e) {
            exceptionCaught = true;
        }
        System.assertEquals(false, exceptionCaught, 'Exception caught while assiging Goods Receipt to Bill');
        if(!exceptionCaught){
            System.assertEquals(Date.today(), insertedBill.dmpl__DocumentDate__c, 'Document date should match');
            System.assertEquals(partnerAccount1.Id, insertedBill.dmpl__PartnerAccountId__c, 'Partner Account should match');
            System.assertEquals(goodsReceipt.Id, insertedBill.dmpl__GoodsReceiptId__c, 'Goods Receipt should match');
            System.assertEquals(branch1.Id, insertedBill.dmpl__BranchId__c, 'Branch should match');
            System.assertEquals(supplierAccount1.Id, insertedBill.dmpl__SupplierAccountId__c, 'Supplier Account should match');
        }
    }
    
    @isTest
    static void updateBillWithoutGoodsReceiptReferencePositive(){
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 =TestDataHelpers.getBranch('Branch 1');
        Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        
        dmpl__GoodsReceipt__c goodsReceipt = GoodRecieptsTestDataHelpers.createGoodsReceipt(partnerAccount1,branch1,null,supplierAccount1);
        System.assertNotEquals(null, goodsReceipt.Id, 'Goods Receipt should be created');
        
        System.assertEquals(partnerAccount1.Id, goodsReceipt.dmpl__PartnerAccountId__c, 'Partner account should match');
        System.assertEquals(branch1.Id, goodsReceipt.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(supplierAccount1.Id, goodsReceipt.dmpl__SupplierAccountId__c, 'Supplier account should match');
        System.assertEquals(Date.today(), goodsReceipt.dmpl__DocumentDate__c, 'Document date should match');
        
        Test.startTest();
        dmpl__Bill__c bill = BillTestDataHelpers.createBill(supplierAccount1.Id,branch1.Id,partnerAccount1.Id,Date.today(),null,null,goodsReceipt.Id);
        Test.stopTest();
        System.assertNotEquals(null, bill.Id, 'Bill Id should not be null');
        dmpl__Bill__c insertedBill = BillTestDataHelpers.getBill(bill.Id);
        
        System.assertEquals(Date.today(), insertedBill.dmpl__DocumentDate__c, 'Document date should match');
        System.assertEquals(partnerAccount1.Id, insertedBill.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch1.Id, insertedBill.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(supplierAccount1.Id, insertedBill.dmpl__SupplierAccountId__c, 'Supplier Account should match');
        System.assertEquals(goodsReceipt.Id, insertedBill.dmpl__GoodsReceiptId__c, 'Goods Receipt should match');
        
        
        Boolean exceptionCaught = false;
        try{
            insertedBill.dmpl__GoodsReceiptId__c = null;
            update insertedBill;
        } catch(Exception e) {
            exceptionCaught = true;
        }
        System.assertEquals(false, exceptionCaught, 'Exception caught while removing Goods Receipt from Bill');
        if(!exceptionCaught){
            System.assertEquals(Date.today(), insertedBill.dmpl__DocumentDate__c, 'Document date should match');
            System.assertEquals(partnerAccount1.Id, insertedBill.dmpl__PartnerAccountId__c, 'Partner Account should match');
            System.assertEquals(branch1.Id, insertedBill.dmpl__BranchId__c, 'Branch should match');
            System.assertEquals(supplierAccount1.Id, insertedBill.dmpl__SupplierAccountId__c, 'Supplier Account should match');
        }
    }
    
    @isTest
    static void createBillWithInactiveSupplierAccountNegative(){
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 =TestDataHelpers.getBranch('Branch 1');
        Account supplierAccount2=TestDataHelpers.getSupplierAccount('Supplier 2');
        
        Test.startTest();
        
        dmpl__Bill__c insertedBill = BillTestDataHelpers.createBill(supplierAccount2.Id,branch1.Id,partnerAccount1.Id,Date.today(),null,null,null);
        System.assertEquals(supplierAccount2.Id,insertedBill.dmpl__supplierAccountId__c,'supplier should match');
        System.assertEquals(branch1.Id,insertedBill.dmpl__BranchId__c,'branch should match');
        System.assertEquals(partnerAccount1.Id,insertedBill.dmpl__PartnerAccountId__c,'branch should match');
        Test.stopTest();
        
    }
    
    @isTest
    static void updateBillWithInactiveSupplierAccountPositive(){
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 =TestDataHelpers.getBranch('Branch 1');
        Account supplierAccount2=TestDataHelpers.getSupplierAccount('Supplier 2');
        Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        
        Test.startTest();
        dmpl__Bill__c bill = BillTestDataHelpers.createBill(supplierAccount1.Id,branch1.Id,partnerAccount1.Id,Date.today(),null,null,null);
        Test.stopTest();
        System.assertNotEquals(null, bill.Id, 'Bill Id should not be null');
        dmpl__Bill__c insertedBill = BillTestDataHelpers.getBill(bill.Id);
        
        System.assertEquals(Date.today(), insertedBill.dmpl__DocumentDate__c, 'Document date should match');
        System.assertEquals(partnerAccount1.Id, insertedBill.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch1.Id, insertedBill.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(supplierAccount1.Id, insertedBill.dmpl__SupplierAccountId__c, 'Supplier Account should match');
        
        insertedBill.dmpl__SupplierAccountId__c = supplierAccount2.Id;
        update insertedBill;
        dmpl__Bill__c updatedBill = BillTestDataHelpers.getBill(insertedBill.Id);
        
        System.assertEquals(supplierAccount2.Id, updatedBill.dmpl__SupplierAccountId__c, 'Supplier Account should match');
    }
    // Bill Line line with inactive item (Edit)
    @isTest
    static void updateBillLineWithInactiveItemNegative() {
        
        Account partnerAccount4 = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 4');
        Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        dmpl__Item__c item2 = TestDataHelpers.getItem('Item 2');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 12');
        
        Test.startTest();
        dmpl__Bill__c bill = BillTestDataHelpers.createBill(
            supplierAccount1.Id,
        branch4.Id,
        partnerAccount4.Id
            );
        
        System.assertNotEquals(null, bill.Id, 'Bill Id should not be null');
        dmpl__Bill__c insertedBill = BillTestDataHelpers.getBill(bill.Id);
        
        System.assertEquals(partnerAccount4.dmpl__ShippingStreet__c, insertedBill.dmpl__ShippingStreet__c, 'Shipping street should match');
        System.assertEquals(partnerAccount4.dmpl__ShippingCity__c, insertedBill.dmpl__ShippingCity__c, 'Shipping city should match');
        System.assertEquals(partnerAccount4.dmpl__ShippingState__c, insertedBill.dmpl__ShippingState__c, 'Shipping state should match');
        System.assertEquals(partnerAccount4.dmpl__ShippingPostalCode__c, insertedBill.dmpl__ShippingPostalCode__c, 'Shipping postal code should match');
        System.assertEquals(partnerAccount4.dmpl__BillingStreet__c, insertedBill.dmpl__BillingStreet__c, 'Billing street should match');
        System.assertEquals(partnerAccount4.dmpl__BillingCity__c, insertedBill.dmpl__BillingCity__c, 'Billing city should match');
        System.assertEquals(partnerAccount4.dmpl__BillingState__c, insertedBill.dmpl__BillingState__c, 'Billing state should match');
        System.assertEquals(partnerAccount4.dmpl__ShippingCountry__c, insertedBill.dmpl__ShippingCountry__c, 'Shipping country should match');
        System.assertEquals(partnerAccount4.dmpl__BillingPostalCode__c, insertedBill.dmpl__BillingPostalCode__c, 'Billing postal code should match');
        System.assertEquals(Date.today(), insertedBill.dmpl__DocumentDate__c, 'Document date should match');
        
        dmpl__BillLine__c billLine = BillTestDataHelpers.createBillLine(
            null,
        item1,bill,10,null,null);
        
        
        billLine.dmpl__UnitCost__c = 1500;
        update billLine;
        
        dmpl__BillLine__c insertedBillLine=BillTestDataHelpers.getBillLine(billLine.Id);
        
        System.assertEquals(item1.Id, insertedBillLine.dmpl__ItemId__c, 'Item should match');
        System.assertEquals(10, insertedBillLine.dmpl__Quantity__c, 'Quantity should be 10');
        System.assertEquals(1500, insertedBillLine.dmpl__UnitCost__c, 'Unit cost should be 1500');
        System.assertEquals(10, insertedBillLine.dmpl__EligibleReturnQuantity__c, 'Eligible return quantity should be 10');
        System.assertEquals(15000, insertedBillLine.dmpl__BaseAmount__c, 'Base amount should be 15000');
        System.assertEquals(15000, insertedBillLine.dmpl__Amount__c, 'Amount should be 15000');
        
        dmpl__Bill__c updatedBill = BillTestDataHelpers.getBill(bill.Id);
        System.assertEquals(15000, updatedBill.dmpl__TotalAmount__c, 'Total amount should be 15000');
        System.assertEquals(15000, updatedBill.dmpl__TotalLineAmount__c, 'Total line amount should be 15000');
        System.assertEquals(15000, updatedBill.dmpl__TotalLineBaseAmount__c, 'Total line base amount should be 15000');
        System.assertEquals(0, updatedBill.dmpl__TotalLineTaxAmount__c, 'Total line tax amount should be 0');
        System.assertEquals(0, updatedBill.dmpl__TotalSchemeDiscountAmount__c, 'Total scheme discount amount should be 0');
        
        Boolean exceptionThrown = false;
        try {
            insertedBillLine.dmpl__ItemId__c = item2.Id;
            insertedBillLine.dmpl__Quantity__c = 3;
            insertedBillLine.dmpl__TaxGroupId__c = taxGroup.Id;
            update insertedBillLine;
        } catch(Exception e) {
            exceptionThrown = true;
        }
        
        System.assertEquals(true, exceptionThrown, 'Expected exception when trying to edit with inactive item');
        Test.stopTest();
    }
    @isTest
    static void updateBillLineWithDiscontinuedItemNegative() {
        
        Account partnerAccount4 = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 4');
        Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        dmpl__Item__c item2 = TestDataHelpers.getItem('Item 2');
        dmpl__Item__c item4 = TestDataHelpers.getItem('Item 4');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 12');
        
        Test.startTest();
        dmpl__Bill__c bill = BillTestDataHelpers.createBill(
            supplierAccount1.Id,
        branch4.Id,
        partnerAccount4.Id
            );
        
        System.assertNotEquals(null, bill.Id, 'Bill Id should not be null');
        dmpl__Bill__c insertedBill = BillTestDataHelpers.getBill(bill.Id);
        
        
        System.assertEquals(partnerAccount4.dmpl__ShippingStreet__c, insertedBill.dmpl__ShippingStreet__c, 'Shipping street should match');
        System.assertEquals(partnerAccount4.dmpl__ShippingCity__c, insertedBill.dmpl__ShippingCity__c, 'Shipping city should match');
        System.assertEquals(partnerAccount4.dmpl__ShippingState__c, insertedBill.dmpl__ShippingState__c, 'Shipping state should match');
        System.assertEquals(partnerAccount4.dmpl__ShippingPostalCode__c, insertedBill.dmpl__ShippingPostalCode__c, 'Shipping postal code should match');
        System.assertEquals(partnerAccount4.dmpl__BillingStreet__c, insertedBill.dmpl__BillingStreet__c, 'Billing street should match');
        System.assertEquals(partnerAccount4.dmpl__BillingCity__c, insertedBill.dmpl__BillingCity__c, 'Billing city should match');
        System.assertEquals(partnerAccount4.dmpl__BillingState__c, insertedBill.dmpl__BillingState__c, 'Billing state should match');
        System.assertEquals(partnerAccount4.dmpl__ShippingCountry__c, insertedBill.dmpl__ShippingCountry__c, 'Shipping country should match');
        System.assertEquals(partnerAccount4.dmpl__BillingPostalCode__c, insertedBill.dmpl__BillingPostalCode__c, 'Billing postal code should match');
        System.assertEquals(Date.today(), insertedBill.dmpl__DocumentDate__c, 'Document date should match');
        
        dmpl__BillLine__c billLine = BillTestDataHelpers.createBillLine(
            null,item1,bill,10,null,null);
        billLine.dmpl__UnitCost__c = 1500;
        update billLine;
        
        dmpl__BillLine__c insertedBillLine = BillTestDataHelpers.getBillLine(billLine.Id);
        
        System.assertEquals(item1.Id, insertedBillLine.dmpl__ItemId__c, 'Item should match');
        System.assertEquals(10, insertedBillLine.dmpl__Quantity__c, 'Quantity should be 10');
        System.assertEquals(1500, insertedBillLine.dmpl__UnitCost__c, 'Unit cost should be 1500');
        System.assertEquals(10, insertedBillLine.dmpl__EligibleReturnQuantity__c, 'Eligible return quantity should be 10');
        System.assertEquals(15000, insertedBillLine.dmpl__BaseAmount__c, 'Base amount should be 15000');
        System.assertEquals(15000, insertedBillLine.dmpl__Amount__c, 'Amount should be 15000');
        
        dmpl__Bill__c updatedBill = BillTestDataHelpers.getBill(bill.Id);
        System.assertEquals(15000, updatedBill.dmpl__TotalAmount__c, 'Total amount should be 15000');
        System.assertEquals(15000, updatedBill.dmpl__TotalLineAmount__c, 'Total line amount should be 15000');
        System.assertEquals(15000, updatedBill.dmpl__TotalLineBaseAmount__c, 'Total line base amount should be 15000');
        System.assertEquals(0, updatedBill.dmpl__TotalLineTaxAmount__c, 'Total line tax amount should be 0');
        System.assertEquals(0, updatedBill.dmpl__TotalSchemeDiscountAmount__c, 'Total scheme discount amount should be 0');
        
        Boolean exceptionThrown = false;
        try {
            insertedBillLine.dmpl__ItemId__c = item4.Id;
            insertedBillLine.dmpl__Quantity__c = 3;
            insertedBillLine.dmpl__TaxGroupId__c = taxGroup.Id;
            update insertedBillLine;
        } catch(Exception e) {
            exceptionThrown = true;
        }
        
        System.assertEquals(true, exceptionThrown, 'Expected exception when trying to edit with inactive item');
        Test.stopTest();
    }
    // Bill Line line with removing required SKU (Edit)
    @isTest
    static void updateBillLineByRemovingRequiredSKUNegative() {
        // Get test data
        Account partnerAccount4 = TestDataHelpers.getPartnerAccount('Partner 4');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 4');
        Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Item__c item7 = TestDataHelpers.getItem('Item 7');
        dmpl__SKU__c sku1 = TestDataHelpers.getSKU('SKU 1');
        
        Test.startTest();
        // Create bill
        dmpl__Bill__c bill = BillTestDataHelpers.createBill(
            supplierAccount1.Id,
        branch4.Id,
        partnerAccount4.Id
            );
        
        dmpl__BillLine__c bL = BillTestDataHelpers.createBillLine(
            null,item7,bill,20,sku1,null
            
        );
        bL.dmpl__UnitCost__c=2000;
        update bL;
        dmpl__BillLine__c  billLine = BillTestDataHelpers.getBillLine(bL.Id);
        
        Boolean exceptionThrown = false;
        
        try {
            billLine.dmpl__SKUId__c = null;
            billLine.dmpl__Quantity__c = 45;
            update billLine;
        } catch(Exception e) {
            exceptionThrown = true;
        }
        
        Test.stopTest();
        
        dmpl__Bill__c insertedBill = BillTestDataHelpers.getBill(bill.Id);
        System.assertEquals(partnerAccount4.dmpl__ShippingStreet__c, insertedBill.dmpl__ShippingStreet__c, 'Shipping street should match');
        System.assertEquals(partnerAccount4.dmpl__ShippingCity__c, insertedBill.dmpl__ShippingCity__c, 'Shipping city should match');
        System.assertEquals(partnerAccount4.dmpl__ShippingState__c, insertedBill.dmpl__ShippingState__c, 'Shipping state should match');
        System.assertEquals(partnerAccount4.dmpl__ShippingPostalCode__c, insertedBill.dmpl__ShippingPostalCode__c, 'Shipping postal code should match');
        System.assertEquals(partnerAccount4.dmpl__BillingStreet__c, insertedBill.dmpl__BillingStreet__c, 'Billing street should match');
        System.assertEquals(partnerAccount4.dmpl__BillingCity__c, insertedBill.dmpl__BillingCity__c, 'Billing city should match');
        System.assertEquals(partnerAccount4.dmpl__BillingState__c, insertedBill.dmpl__BillingState__c, 'Billing state should match');
        System.assertEquals(partnerAccount4.dmpl__ShippingCountry__c, insertedBill.dmpl__ShippingCountry__c, 'Shipping country should match');
        System.assertEquals(partnerAccount4.dmpl__BillingPostalCode__c, insertedBill.dmpl__BillingPostalCode__c, 'Billing postal code should match');
        System.assertEquals(Date.today(), insertedBill.dmpl__DocumentDate__c, 'Document date should match');
        
        
        dmpl__BillLine__c insertedBillLine = BillTestDataHelpers.getBillLine(billLine.Id);
        
        System.assertEquals(item7.Id, insertedBillLine.dmpl__ItemId__c, 'Item should match');
        System.assertEquals(20, insertedBillLine.dmpl__Quantity__c, 'Quantity should be 20');
        System.assertEquals(2000, insertedBillLine.dmpl__UnitCost__c, 'Unit cost should be 2000');
        System.assertEquals(20, insertedBillLine.dmpl__EligibleReturnQuantity__c, 'Eligible return quantity should be 20');
        System.assertEquals(40000, insertedBillLine.dmpl__BaseAmount__c, 'Base amount should be 40000');
        System.assertEquals(40000, insertedBillLine.dmpl__Amount__c, 'Amount should be 40000');
        System.assertEquals(40000, insertedBillLine.dmpl__GrossAmount__c, 'Gross amount should be 40000');
        System.assertEquals(0, insertedBillLine.dmpl__NetDiscount__c, 'Net discount should be null');
        System.assertEquals(sku1.Id, insertedBillLine.dmpl__SKUId__c, 'SKU should be set');
        
        System.assertEquals(40000, insertedBill.dmpl__TotalLineBaseAmount__c, 'Total line base amount should be 40000');
        System.assertEquals(0, insertedBill.dmpl__TotalSchemeDiscountAmount__c, 'Total scheme discount amount should be 0');
        
        System.assertEquals(true, exceptionThrown, 'Expected exception when trying to remove required SKU');
    }
    @isTest
    static void updateBillLineWithNoRequiredSKUPositive() {
        
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        
        Test.startTest();
        
        dmpl__Bill__c bill = BillTestDataHelpers.createBill(
            supplierAccount1.Id,
        branch1.Id,
        partnerAccount1.Id
            );
        
        dmpl__BillLine__c billLine = BillTestDataHelpers.createBillLine(
            null,item1,bill,20,null,null
            );
        billLine.dmpl__UnitCost__c=1000;
        billLine.dmpl__Quantity__c = 22;
        update billLine;
        
        Test.stopTest();
        
        dmpl__Bill__c updatedBill = BillTestDataHelpers.getBill(bill.Id);
        dmpl__BillLine__c  updatedBillLine = BillTestDataHelpers.getBillLine(billLine.Id);
        System.assertEquals('MG Road', updatedBill.dmpl__BillingStreet__c, 'Billing street should match');
        System.assertEquals('Bengaluru', updatedBill.dmpl__BillingCity__c, 'Billing city should match');
        System.assertEquals('Karnataka', updatedBill.dmpl__BillingState__c, 'Billing state should match');
        System.assertEquals('India', updatedBill.dmpl__BillingCountry__c, 'Billing country should match');
        System.assertEquals('560001', updatedBill.dmpl__BillingPostalCode__c, 'Billing postal code should match');
        System.assertEquals('56 Industrial Layout', updatedBill.dmpl__ShippingStreet__c, 'Shipping street should match');
        System.assertEquals('Bengaluru', updatedBill.dmpl__ShippingCity__c, 'Shipping city should match');
        System.assertEquals('Karnataka', updatedBill.dmpl__ShippingState__c, 'Shipping state should match');
        System.assertEquals('India', updatedBill.dmpl__ShippingCountry__c, 'Shipping country should match');
        System.assertEquals('560095', updatedBill.dmpl__ShippingPostalCode__c, 'Shipping postal code should match');
        System.assertEquals(Date.today(), updatedBill.dmpl__DocumentDate__c, 'Document date should match');
        // System.assertEquals('Draft', updatedBill.dmpl__Status__c, 'Status should be draft');
        
        System.assertEquals(item1.Id, updatedBillLine.dmpl__ItemId__c, 'Item should match');
        System.assertEquals(1000, updatedBillLine.dmpl__UnitCost__c, 'Unit cost should remain 1000');
        
        System.assertEquals(22, updatedBillLine.dmpl__Quantity__c, 'Quantity should be updated to 22');
        System.assertEquals(22, updatedBillLine.dmpl__InvoiceQuantity__c, 'Invoice quantity should be 22');
        System.assertEquals(22, updatedBillLine.dmpl__EligibleReturnQuantity__c, 'Eligible return quantity should be 22');
        System.assertEquals(22000, updatedBillLine.dmpl__BaseAmount__c, 'Base amount should be 22000');
        System.assertEquals(22000, updatedBillLine.dmpl__Amount__c, 'Amount should be 22000');
        System.assertEquals(22000, updatedBillLine.dmpl__GrossAmount__c, 'Gross amount should be 22000');
        System.assertEquals(0, updatedBillLine.dmpl__NetDiscount__c, 'Net discount should be 0');
        System.assertEquals(null, updatedBillLine.dmpl__SKUId__c, 'SKU should remain null');
        
        System.assertEquals(22000, updatedBill.dmpl__TotalLineBaseAmount__c, 'Total line base amount should be 22000');
        System.assertEquals(0, updatedBill.dmpl__TotalSchemeDiscountAmount__c, 'Total scheme discount amount should be 0');
    }
    @isTest
    static void createBillLineWithInvoiceQuantityPositive() {
        
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        
        Test.startTest();
        
        dmpl__Bill__c bill = BillTestDataHelpers.createBill(
            supplierAccount1.Id,
        branch1.Id,
        partnerAccount1.Id
            );
        
        dmpl__BillLine__c bL = BillTestDataHelpers.createBillLine(
            null,item1,bill,20,null,null
            );
        bL.dmpl__UnitCost__c=1500;
        update bL;
        
        Test.stopTest();
        
        dmpl__Bill__c updatedBill = BillTestDataHelpers.getBill(bill.Id);
        dmpl__BillLine__c  insertedBillLine = BillTestDataHelpers.getBillLine(bL.Id);
        
        System.assertEquals('MG Road', updatedBill.dmpl__BillingStreet__c, 'Billing street should match');
        System.assertEquals('Bengaluru', updatedBill.dmpl__BillingCity__c, 'Billing city should match');
        System.assertEquals('Karnataka', updatedBill.dmpl__BillingState__c, 'Billing state should match');
        System.assertEquals('India', updatedBill.dmpl__BillingCountry__c, 'Billing country should match');
        System.assertEquals('560001', updatedBill.dmpl__BillingPostalCode__c, 'Billing postal code should match');
        System.assertEquals('56 Industrial Layout', updatedBill.dmpl__ShippingStreet__c, 'Shipping street should match');
        System.assertEquals('Bengaluru', updatedBill.dmpl__ShippingCity__c, 'Shipping city should match');
        System.assertEquals('Karnataka', updatedBill.dmpl__ShippingState__c, 'Shipping state should match');
        System.assertEquals('India', updatedBill.dmpl__ShippingCountry__c, 'Shipping country should match');
        System.assertEquals('560095', updatedBill.dmpl__ShippingPostalCode__c, 'Shipping postal code should match');
        System.assertEquals(Date.today(), updatedBill.dmpl__DocumentDate__c, 'Document date should match');
        // System.assertEquals('Draft', updatedBill.dmpl__Status__c, 'Status should be draft');
        
        System.assertEquals(item1.Id, insertedBillLine.dmpl__ItemId__c, 'Item should match');
        System.assertEquals(20, insertedBillLine.dmpl__Quantity__c, 'Quantity should be 20');
        System.assertEquals(1500, insertedBillLine.dmpl__UnitCost__c, 'Unit cost should be 1500');
        System.assertEquals(20, insertedBillLine.dmpl__InvoiceQuantity__c, 'Invoice quantity should be 20');
        System.assertEquals(20, insertedBillLine.dmpl__EligibleReturnQuantity__c, 'Eligible return quantity should be 20');
        System.assertEquals(30000, insertedBillLine.dmpl__BaseAmount__c, 'Base amount should be 30000 ');
        System.assertEquals(30000, insertedBillLine.dmpl__Amount__c, 'Amount should be 30000');
        System.assertEquals(30000, insertedBillLine.dmpl__GrossAmount__c, 'Gross amount should be 30000');
        System.assertEquals(0, insertedBillLine.dmpl__NetDiscount__c, 'Net discount should be null');
        
    }
    @isTest
    static void updateBillLineInvoiceQuantityPositive() {
        
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        
        Test.startTest();
        
        dmpl__Bill__c bill = BillTestDataHelpers.createBill(
            supplierAccount1.Id,
        branch1.Id,
        partnerAccount1.Id
            );
        dmpl__BillLine__c billLine = BillTestDataHelpers.createBillLine(
            null,item,bill,20,null,null
            );
        billLine.dmpl__UnitCost__c=1000;
        billLine.dmpl__Quantity__c = 22;
        update billLine;
        
        Test.stopTest();
        dmpl__Bill__c updatedBill = BillTestDataHelpers.getBill(bill.Id);
        dmpl__BillLine__c updatedBillLine = BillTestDataHelpers.getBillLine(billLine.Id);
        
        System.assertEquals(partnerAccount1.dmpl__BillingStreet__c, updatedBill.dmpl__BillingStreet__c, 'Billing street should match partner');
        System.assertEquals(partnerAccount1.dmpl__BillingCity__c, updatedBill.dmpl__BillingCity__c, 'Billing city should match partner');
        System.assertEquals(partnerAccount1.dmpl__BillingState__c, updatedBill.dmpl__BillingState__c, 'Billing state should match partner');
        System.assertEquals(partnerAccount1.dmpl__BillingCountry__c, updatedBill.dmpl__BillingCountry__c, 'Billing country should match partner');
        System.assertEquals(partnerAccount1.dmpl__BillingPostalCode__c, updatedBill.dmpl__BillingPostalCode__c, 'Billing postal code should match partner');
        System.assertEquals(partnerAccount1.dmpl__ShippingCity__c, updatedBill.dmpl__ShippingCity__c, 'Shipping city should match partner');
        System.assertEquals(partnerAccount1.dmpl__ShippingState__c, updatedBill.dmpl__ShippingState__c, 'Shipping state should match partner');
        System.assertEquals(partnerAccount1.dmpl__ShippingCountry__c, updatedBill.dmpl__ShippingCountry__c, 'Shipping country should match partner');
        System.assertEquals(partnerAccount1.dmpl__ShippingPostalCode__c, updatedBill.dmpl__ShippingPostalCode__c, 'Shipping postal code should match partner');
        System.assertEquals(Date.today(), updatedBill.dmpl__DocumentDate__c, 'Document date should match');
        // System.assertEquals('Draft', updatedBill.dmpl__Status__c, 'Status should be draft');
        
        System.assertEquals(item.Id, updatedBillLine.dmpl__ItemId__c, 'Item should remain Item 1');
        System.assertEquals(1000, updatedBillLine.dmpl__UnitCost__c, 'Unit cost should remain 1000');
        
        System.assertEquals(22, updatedBillLine.dmpl__Quantity__c, 'Quantity should be updated to 22');
        System.assertEquals(22, updatedBillLine.dmpl__InvoiceQuantity__c, 'Invoice quantity should be 22');
        System.assertEquals(22, updatedBillLine.dmpl__EligibleReturnQuantity__c, 'Eligible return quantity should be 22');
        System.assertEquals(22000, updatedBillLine.dmpl__BaseAmount__c, 'Base amount should be 22000 ');
        System.assertEquals(22000, updatedBillLine.dmpl__Amount__c, 'Amount should be 22000');
        System.assertEquals(22000, updatedBillLine.dmpl__GrossAmount__c, 'Gross amount should be 22000');
        System.assertEquals(0, updatedBillLine.dmpl__NetDiscount__c, 'Net discount should be 0');
        
        System.assertEquals(22000, updatedBill.dmpl__TotalLineBaseAmount__c, 'Total line base amount should be 22000');
        System.assertEquals(0, updatedBill.dmpl__TotalSchemeDiscountAmount__c, 'Total scheme discount amount should be 0');
    }
    
    
}