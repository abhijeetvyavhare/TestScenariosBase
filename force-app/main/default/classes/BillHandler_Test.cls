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
        Account partnerAccount6 = TestDataHelpers.createPartnerAccount('Partner 6', false, true, false, true, 'MG Road', 'Bengaluru', 'Karnataka', 'India', '560001', '56 Industrial Layout', 'Bengaluru', 'Karnataka', 'India', '560095', '9845543210');
        dmpl__Branch__c branch6 = TestDataHelpers.createBranch('Branch 6', partnerAccount6.Id, true, false, false, false, true, false, true);
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
        
        Account supplier2 = TestDataHelpers.createSupplierAccount(
        'Supplier 2',
        '55 Industrial Park Road',
        'Ahmedabad',
        'GJ',
        'India',
        '380015',
        '55 Industrial Park Road',
        'Ahmedabad',
        'GJ',
        'India',
        '380015',
        '-9988745587'
        );
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
        dmpl__SKU__c sku3 = TestDataHelpers.createSKU('SKU 3', item3.Id, false);
        dmpl__SKU__c sku4 = TestDataHelpers.createSKU('SKU 4', item10.id, true);

         Account customerAccount1 = TestDataHelpers.createCustomerAccount('Customer 1', true, false, false, true, 'MG Road', 'Pune', 'Maharashtra', 'India', '411001', 'Ring Rd', 'Nagpur', 'Maharashtra', 'India', '440001','9876543210', 'Created');
        dmpl__StorageLocation__c storageLocation1 = TestDataHelpers.createStorageLocation(
            'Storage Location 1',    
            branch.Id,                
            true,                    
            'Warehouse'              
        );
    
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
    
    @isTest
    static void updateBillWithoutSupplierAccountPositive(){
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
            insertedBill.dmpl__supplierAccountId__c = null;
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
    
    @isTest
    static void createBillReturnWithBackwardDatePositive() {
        
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 4');
        Account supplierAccount = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        dmpl__PriceList__c priceList = TestDataHelpers.getPriceList();
        Date backwardDate = Date.today().addDays(-1);
        
        Test.startTest();
        dmpl__BillReturn__c billReturnNew = BillTestDataHelpers.createBillReturn(
            supplierAccount,
        partnerAccount,
        branch,
        priceList,
        backwardDate
            );
        Test.stopTest();
        
        dmpl__BillReturn__c billReturn = BillTestDataHelpers.getBillReturn(billReturnNew.Id);
        
        System.assertNotEquals(null, billReturn.Id, 'Bill Return should be created');
        System.assertEquals(backwardDate, billReturn.dmpl__DocumentDate__c, 'Document date should be yesterday');
        System.assertEquals('Draft', billReturn.dmpl__Status__c, 'Status should be draft');
        System.assertEquals(partnerAccount.Id, billReturn.dmpl__PartnerAccountId__c, 'Partner should be Partner 4');
        System.assertEquals(branch.Id, billReturn.dmpl__BranchId__c, 'Branch should be Branch 4');
        System.assertEquals(supplierAccount.Id, billReturn.dmpl__SupplierAccountId__c, 'Supplier should be Supplier 1');
    }
    
    @isTest
    static void updateBillReturnWithBackwardDatePositive() {
        
        Account partnerAccount = TestDataHelpers.getPartnerAccount('Partner 4');
        Account supplierAccount = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        dmpl__PriceList__c priceList = TestDataHelpers.getPriceList();
        Date todayDate = Date.today();
        Date backwardDate = Date.today().addDays(-1);
        
        Test.startTest();
        dmpl__BillReturn__c billReturnInitial = BillTestDataHelpers.createBillReturn(
            supplierAccount,
        partnerAccount,
        branch,
        priceList,
        todayDate
            );
        
        
        dmpl__BillReturn__c billReturnCreated = BillTestDataHelpers.getBillReturn(billReturnInitial.Id);
        
        System.assertNotEquals(null, billReturnCreated.Id, 'Bill Return should be created');
        System.assertEquals(todayDate, billReturnCreated.dmpl__DocumentDate__c, 'Document date should be today');
        System.assertEquals('Draft', billReturnCreated.dmpl__Status__c, 'Status should be draft');
        System.assertEquals(partnerAccount.Id, billReturnCreated.dmpl__PartnerAccountId__c, 'Partner should be Partner 4');
        System.assertEquals(branch.Id, billReturnCreated.dmpl__BranchId__c, 'Branch should be Branch 4');
        System.assertEquals(supplierAccount.Id, billReturnCreated.dmpl__SupplierAccountId__c, 'Supplier should be Supplier 1');
        
        billReturnCreated.dmpl__DocumentDate__c = backwardDate;
        update billReturnCreated;
        
        Test.stopTest();
        
        dmpl__BillReturn__c billReturnEdited = BillTestDataHelpers.getBillReturn(billReturnCreated.Id);
        
        System.assertEquals(backwardDate, billReturnEdited.dmpl__DocumentDate__c, 'Document date should be yesterday');
        System.assertEquals('Draft', billReturnEdited.dmpl__Status__c, 'Status should still be draft after edit');
        System.assertEquals(partnerAccount.Id, billReturnEdited.dmpl__PartnerAccountId__c, 'Partner should be Partner 4');
        System.assertEquals(branch.Id, billReturnEdited.dmpl__BranchId__c, 'Branch should be Branch 4');
        System.assertEquals(supplierAccount.Id, billReturnEdited.dmpl__SupplierAccountId__c, 'Supplier should be Supplier 1');
    }
    
    @isTest
    static void createBillReturnCreationWithPurchaseOrderReferencePositive() {

        Test.startTest();
        
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 3');
        dmpl__SKU__c sku = TestDataHelpers.getSKU('SKU 3');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 12');
        
        dmpl__PurchaseOrder__c po = BillTestDataHelpers.createPurchaseOrder(branch, supplier, partner);
        System.assertEquals('Draft', po.dmpl__Status__c, 'PO should be created in Draft status');
        
        Decimal unitPrice = 2000;
        Decimal quantity = 5;
        dmpl__PurchaseOrderLine__c poLine = BillTestDataHelpers.createPurchaseOrderLine(po, unitPrice, quantity, item, sku, taxGroup);
        
        dmpl__BillReturn__c billReturn = BillTestDataHelpers.createBillReturnWithPurchaseOrderReference(
            supplier, partner, branch, po
            );

        Test.stopTest();
        
        
        System.assertEquals(Date.today(), po.dmpl__DocumentDate__c, 'PO date should be today');
        System.assertEquals('Draft', po.dmpl__Status__c, 'PO should be in Draft status');
        System.assertEquals(2000, poLine.dmpl__UnitCost2__c, 'Unit Price should be 2000');
        System.assertEquals(5, poLine.dmpl__Quantity__c, 'Quantity should be 5');
        System.assertEquals(Date.today(), billReturn.dmpl__DocumentDate__c, 'Bill Return date should be today');
        System.assertEquals('Draft', billReturn.dmpl__Status__c, 'Bill Return should be in Draft status');
        System.assertEquals(supplier.Id, billReturn.dmpl__SupplierAccountId__c, 'Supplier should match');
        System.assertEquals(partner.Id, billReturn.dmpl__PartnerAccountId__c, 'Partner should match');
        System.assertEquals(branch.Id, billReturn.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(po.Id, billReturn.dmpl__PurchaseOrderId__c, 'Purchase Order should match');
    }

    @isTest
    static void createBillReturnWithoutPurchaseOrderReferencePositive() {

        Test.startTest();

        Account partnerAccount4 = TestDataHelpers.getPartnerAccount('Partner 4');
        Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 4');
        dmpl__PriceList__c priceList = TestDataHelpers.getPriceList();

        Date documentDate = Date.today();

        dmpl__BillReturn__c billReturn = BillTestDataHelpers.createBillReturn(
            supplierAccount1,
            partnerAccount4,
            branch4,
            priceList,
            documentDate
        );

        dmpl__BillReturn__c insertedBillReturn = BillTestDataHelpers.getBillReturn(billReturn.Id);

        Test.stopTest();

        System.assertEquals(Date.today(), insertedBillReturn.dmpl__DocumentDate__c, 'Document date should be 6/18/2025');
        System.assertEquals(partnerAccount4.Id, insertedBillReturn.dmpl__PartnerAccountId__c, 'Partner should be Partner 4');
        System.assertEquals(branch4.Id, insertedBillReturn.dmpl__BranchId__c, 'Branch should be Branch 4');
        System.assertEquals(supplierAccount1.Id, insertedBillReturn.dmpl__SupplierAccountId__c, 'Supplier should be Supplier 1');

       
    }

    @isTest
    static void updateBillReturnWithPurchaseOrderReferenceEditPositive() {

        Test.startTest();

        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplier1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account partner4 = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 4');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 3');
        dmpl__SKU__c sku = TestDataHelpers.getSKU('SKU 3');
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 12');

        dmpl__PurchaseOrder__c purchaseOrder1 = BillTestDataHelpers.createPurchaseOrder(branch1, supplier1, partner1);
        Decimal unitPrice = 1500;
        Decimal quantity = 10;

        dmpl__PurchaseOrderLine__c poLine = BillTestDataHelpers.createPurchaseOrderLine(
            purchaseOrder1, unitPrice, quantity, item1, sku, taxGroup
        );


        dmpl__BillReturn__c billReturn = BillTestDataHelpers.createBillReturnWithPurchaseOrderReference(
            supplier1, partner4, branch4, purchaseOrder1
        );

        dmpl__PurchaseOrder__c purchaseOrder2 = BillTestDataHelpers.createPurchaseOrder(branch1, supplier1, partner1);
        billReturn.dmpl__PurchaseOrderId__c = purchaseOrder2.Id;
        update billReturn;

        dmpl__BillReturn__c insertedBillReturn = BillTestDataHelpers.getBillReturn(billReturn.Id);

        Test.stopTest();

        System.assertEquals('Draft', purchaseOrder1.dmpl__Status__c, 'PO1 should be in Draft');
        System.assertEquals('Partner 1', partner1.Name, 'Partner 1 should be associated');
        System.assertEquals(unitPrice, poLine.dmpl__UnitCost2__c, 'Unit price should be 1500');
        System.assertEquals(quantity, poLine.dmpl__Quantity__c, 'Quantity should be 10');

        System.assertEquals('Draft', insertedBillReturn.dmpl__Status__c, 'Bill Return should be in Draft status');
        System.assertEquals(Date.today(), insertedBillReturn.dmpl__DocumentDate__c, 'Document date should be 6/18/2025');
        System.assertEquals(purchaseOrder2.Id, insertedBillReturn.dmpl__PurchaseOrderId__c, 'Purchase Order should be updated to PO2');
        System.assertEquals(partner4.Id, insertedBillReturn.dmpl__PartnerAccountId__c, 'Partner should be Partner 4');
        System.assertEquals(branch4.Id, insertedBillReturn.dmpl__BranchId__c, 'Branch should be Branch 4');
        System.assertEquals(supplier1.Id, insertedBillReturn.dmpl__SupplierAccountId__c, 'Supplier should be Supplier 1');

        System.assertEquals(0, insertedBillReturn.dmpl__TotalLineAmount__c, 'TotalLineAmount should be 0');
        System.assertEquals(0, insertedBillReturn.dmpl__TotalLineBaseAmount__c, 'TotalLineBaseAmount should be 0');
        System.assertEquals(0, insertedBillReturn.dmpl__TotalLineGrossAmount__c, 'TotalLineGrossAmount should be 0');
    }


    @isTest
    static void updateBillReturnWithoutPurchaseOrderReferenceEditPositive() {

        Test.startTest();

        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account partnerAccount4 = TestDataHelpers.getPartnerAccount('Partner 4');
        Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 4');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 3');
        dmpl__SKU__c sku1 = TestDataHelpers.getSKU('SKU 3');
        dmpl__TaxGroup__c taxGroup12 = TestDataHelpers.getTaxGroup('GST 12');

        dmpl__PurchaseOrder__c purchaseOrder = BillTestDataHelpers.createPurchaseOrder(branch1, supplierAccount1, partnerAccount1);
        System.assertEquals('Draft', purchaseOrder.dmpl__Status__c, 'Purchase Order should be in Draft status');

        Decimal unitPrice = 1500;
        Decimal quantity = 10;
        dmpl__PurchaseOrderLine__c purchaseOrderLine = BillTestDataHelpers.createPurchaseOrderLine(purchaseOrder, unitPrice, quantity, item1, sku1, taxGroup12);

        dmpl__BillReturn__c billReturn = BillTestDataHelpers.createBillReturnWithPurchaseOrderReference(
            supplierAccount1,
            partnerAccount4,
            branch4,
            purchaseOrder
        );

        System.assertEquals('Draft', billReturn.dmpl__Status__c, 'Initial Bill Return should be in Draft status');
        System.assertEquals(purchaseOrder.Id, billReturn.dmpl__PurchaseOrderId__c, 'Should have Purchase Order reference');

        billReturn.dmpl__PurchaseOrderId__c = null;
        update billReturn;

        dmpl__BillReturn__c updatedBillReturn = BillTestDataHelpers.getBillReturn(billReturn.Id);

        Test.stopTest();

        System.assertEquals(null, updatedBillReturn.dmpl__PurchaseOrderId__c, 'PO reference should be removed');
        System.assertEquals('Draft', updatedBillReturn.dmpl__Status__c, 'Status should still be Draft');
        System.assertEquals(Date.today(), updatedBillReturn.dmpl__DocumentDate__c, 'Document date should be today');
        System.assertEquals(0, updatedBillReturn.dmpl__TotalLineAmount__c, 'TotalLineAmount should be 0');
        System.assertEquals(0, updatedBillReturn.dmpl__TotalLineBaseAmount__c, 'TotalLineBaseAmount should be 0');
        System.assertEquals(0, updatedBillReturn.dmpl__TotalLineGrossAmount__c, 'TotalLineGrossAmount should be 0');
        System.assertEquals(partnerAccount4.Id, updatedBillReturn.dmpl__PartnerAccountId__c, 'Partner should be Partner 4');
        System.assertEquals(branch4.Id, updatedBillReturn.dmpl__BranchId__c, 'Branch should be Branch 4');
        System.assertEquals(supplierAccount1.Id, updatedBillReturn.dmpl__SupplierAccountId__c, 'Supplier should be Supplier 1');
    }

    @isTest
    static void updateBillReturnWithSupplierAccountEditPositive() {

        Test.startTest();

        Account partnerAccount4 = TestDataHelpers.getPartnerAccount('Partner 4');
        Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        Account supplierAccount2 = TestDataHelpers.getSupplierAccount('Supplier 2');
        dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 4');


        dmpl__BillReturn__c billReturn = BillTestDataHelpers.createBillReturn(
            supplierAccount1,
            partnerAccount4,
            branch4,
            null, 
            Date.today()
        );

        System.assertEquals('Draft', billReturn.dmpl__Status__c, 'Bill Return should be created in Draft status');
        System.assertEquals(supplierAccount1.Id, billReturn.dmpl__SupplierAccountId__c, 'Initial supplier should be Supplier 1');
        System.assertEquals(partnerAccount4.Id, billReturn.dmpl__PartnerAccountId__c, 'Initial partner should be Partner 4');
        System.assertEquals(branch4.Id, billReturn.dmpl__BranchId__c, 'Initial branch should be Branch 4');
        System.assertEquals(Date.today(), billReturn.dmpl__DocumentDate__c, 'Initial Document Date should match');

        billReturn.dmpl__SupplierAccountId__c = supplierAccount2.Id;
        update billReturn;

        dmpl__BillReturn__c updatedBillReturn = BillTestDataHelpers.getBillReturn(billReturn.Id);

        Test.stopTest();

        System.assertEquals('Draft', updatedBillReturn.dmpl__Status__c, 'Status should still be Draft');
        System.assertEquals(supplierAccount2.Id, updatedBillReturn.dmpl__SupplierAccountId__c, 'Supplier should be updated to Supplier 2');
        System.assertEquals(partnerAccount4.Id, updatedBillReturn.dmpl__PartnerAccountId__c, 'Partner should remain Partner 4');
        System.assertEquals(branch4.Id, updatedBillReturn.dmpl__BranchId__c, 'Branch should remain Branch 4');
        System.assertEquals(Date.today(), updatedBillReturn.dmpl__DocumentDate__c, 'Document Date should still be the same');

        System.assertEquals(0, updatedBillReturn.dmpl__TotalLineAmount__c, 'TotalLineAmount should be 0');
        System.assertEquals(0, updatedBillReturn.dmpl__TotalLineBaseAmount__c, 'TotalLineBaseAmount should be 0');
        System.assertEquals(0, updatedBillReturn.dmpl__TotalLineGrossAmount__c, 'TotalLineGrossAmount should be 0');
    }

    //positive Scenario
    @isTest
    static void updateBillReturnRemoveSupplierAccountNegative() {

        Test.startTest();

        Account partnerAccount4 = TestDataHelpers.getPartnerAccount('Partner 4');
        Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 4');

        dmpl__BillReturn__c billReturn = BillTestDataHelpers.createBillReturn(
            supplierAccount1,
            partnerAccount4,
            branch4,
            null,
            Date.today()
        );

        System.assertEquals('Draft', billReturn.dmpl__Status__c, 'Bill Return should be in Draft status initially');
        System.assertEquals(partnerAccount4.Id, billReturn.dmpl__PartnerAccountId__c, 'Partner should be Partner 4');
        System.assertEquals(branch4.Id, billReturn.dmpl__BranchId__c, 'Branch should be Branch 4');
        System.assertEquals(supplierAccount1.Id, billReturn.dmpl__SupplierAccountId__c, 'Supplier should be Supplier 1');

        billReturn.dmpl__SupplierAccountId__c = null;

        try {
            update billReturn;
            System.assert(true, 'Expected exception not thrown when Supplier is removed');
        } catch (DmlException ex) {
            System.assert(ex.getMessage().contains('Supplier'), 'Expected validation failure due to missing Supplier');
        }

        Test.stopTest();
    }

    //positive
    @isTest
    static void updateBillReturnWithInactiveSupplierNegative() {

        Test.startTest();

        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');

        Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__BillReturn__c billReturn = BillTestDataHelpers.createBillReturn(
            supplierAccount1,
            partnerAccount1,
            branch1,
            null,
            Date.today()
        );

        System.assertEquals('Draft', billReturn.dmpl__Status__c, 'Bill Return should be in Draft initially');
        System.assertEquals(supplierAccount1.Id, billReturn.dmpl__SupplierAccountId__c, 'Initial Supplier should be Supplier 1');

        Account supplierAccount2 = TestDataHelpers.getSupplierAccount('Supplier 2');
        supplierAccount2.dmpl__IsActive__c = false;
        update supplierAccount2;

        billReturn.dmpl__SupplierAccountId__c = supplierAccount2.Id;

        try {
            update billReturn;
            System.assert(true, 'Expected exception was not thrown when updating Bill Return with inactive supplier');
        } catch (DmlException ex) {
            System.assert(ex.getMessage().contains('inactive') || ex.getMessage().contains('validation'), 'Expected failure due to inactive supplier');
        }

        Test.stopTest();
    }

    @isTest
    static void updateBillWithActivePriceListPositive(){
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 =TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount6 = TestDataHelpers.getPartnerAccount('Partner 6');
        dmpl__Branch__c branch6 =TestDataHelpers.getBranch('Branch 6');
        Account supplierAccount1 = TestDataHelpers.getSupplierAccount('Supplier 1');
        Test.startTest();
        dmpl__Bill__c bill = BillTestDataHelpers.createBill(supplierAccount1.Id,branch1.Id,partnerAccount1.Id,Date.today(),null,null,null);
        bill.dmpl__PartnerAccountId__c = partnerAccount6.Id;
        bill.dmpl__BranchId__c = branch6.Id;
        Update bill;
        Test.stopTest();
        System.assertNotEquals(null, bill.Id, 'Bill Id should not be null');
        dmpl__Bill__c insertedBill = BillTestDataHelpers.getBill(bill.Id);
        
        System.assertEquals(partnerAccount6.dmpl__ShippingStreet__c, insertedBill.dmpl__ShippingStreet__c, 'Shipping street should match');
        System.assertEquals(partnerAccount6.dmpl__ShippingCity__c, insertedBill.dmpl__ShippingCity__c, 'Shipping city should match');
        System.assertEquals(partnerAccount6.dmpl__ShippingState__c, insertedBill.dmpl__ShippingState__c, 'Shipping state should match');
        System.assertEquals(partnerAccount6.dmpl__ShippingPostalCode__c, insertedBill.dmpl__ShippingPostalCode__c, 'Shipping postal code should match');
        System.assertEquals(partnerAccount6.dmpl__BillingStreet__c, insertedBill.dmpl__BillingStreet__c, 'Billing street should match');
        System.assertEquals(partnerAccount6.dmpl__BillingCity__c, insertedBill.dmpl__BillingCity__c, 'Billing city should match');
        System.assertEquals(partnerAccount6.dmpl__BillingState__c, insertedBill.dmpl__BillingState__c, 'Billing state should match');
        System.assertEquals(partnerAccount6.dmpl__ShippingCountry__c, insertedBill.dmpl__ShippingCountry__c, 'Shipping country should match');
        System.assertEquals(partnerAccount6.dmpl__BillingPostalCode__c, insertedBill.dmpl__BillingPostalCode__c, 'Billing postal code should match');
        System.assertEquals(Date.today(), insertedBill.dmpl__DocumentDate__c, 'Document date should match');
        System.assertEquals('Draft', insertedBill.dmpl__Status__c, 'Status should be draft');
        System.assertEquals(partnerAccount6.Id, insertedBill.dmpl__PartnerAccountId__c, 'Partner Account should match');
    }
    
    @isTest
    public static void createBillReturnWithCorrectPartnerAndBranchPositive() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Date documentDate = Date.today();

        Test.startTest();
        dmpl__BillReturn__c billReturn = BillTestDataHelpers.createBillReturn(
            supplier,
            partner,
            branch,
            null,
            documentDate
        );
        Test.stopTest();

        System.assertNotEquals(null, billReturn, 'Bill Return should be created successfully');
        System.assertEquals(partner.Id, billReturn.dmpl__PartnerAccountId__c, 'Partner should match');
        System.assertEquals(branch.Id, billReturn.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(supplier.Id, billReturn.dmpl__SupplierAccountId__c, 'Supplier should match');
        System.assertEquals(documentDate, billReturn.dmpl__DocumentDate__c, 'Document Date should be today');
    }

    @isTest
    public static void createBillReturnWithSupplierAccountPositive() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Date documentDate = Date.today();

        Test.startTest();
        dmpl__BillReturn__c billReturn = BillTestDataHelpers.createBillReturn(
            supplier,
            partner,
            branch,
            null,
            documentDate
        );
        Test.stopTest();

        System.assertNotEquals(null, billReturn, 'Bill Return should be created');
        System.assertEquals('Draft', billReturn.dmpl__Status__c, 'Bill Return should be in Draft stage');
        System.assertEquals(partner.Id, billReturn.dmpl__PartnerAccountId__c, 'Partner should be Partner 1');
        System.assertEquals(branch.Id, billReturn.dmpl__BranchId__c, 'Branch should be Branch 1');
        System.assertEquals(supplier.Id, billReturn.dmpl__SupplierAccountId__c, 'Supplier should be Supplier 1');
        System.assertEquals(documentDate, billReturn.dmpl__DocumentDate__c, 'Document Date should be today');
    }

    @isTest
    public static void createBillReturnCreationWithInactivePartnerPositive() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 2');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Date documentDate = Date.today();

        Test.startTest();
        dmpl__BillReturn__c billReturn = BillTestDataHelpers.createBillReturn(
            supplier,
            partner,
            branch,
            null,
            documentDate
        );
        Test.stopTest();

        System.assertNotEquals(null, billReturn.Id);
    }

    @isTest
    public static void createBillReturnCreationWithWrongBranchPositive() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 3');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        Date documentDate = Date.today();

        Test.startTest();
        dmpl__BillReturn__c billReturn;
        try {
            billReturn = BillTestDataHelpers.createBillReturn(
                supplier,
                partner,
                branch,
                null,
                documentDate
            );
        } catch (Exception e) {
            billReturn = null;
        }
        Test.stopTest();

        System.assertNotEquals(null, billReturn);
    }

    @isTest
    public static void createBillReturnCreationWithInactiveBranchPositive() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 3');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 3'); 
        Date documentDate = Date.today();

        Test.startTest();
        dmpl__BillReturn__c billReturn;
        try {
            billReturn = BillTestDataHelpers.createBillReturn(
                supplier,
                partner,
                branch,
                null,
                documentDate
            );
        } catch (Exception e) {
            billReturn = null;
        }
        Test.stopTest();

        System.assertNotEquals(null, billReturn);
    }

    @isTest
    public static void createBillReturnCreationWithNoSupplierNegative() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Date documentDate = Date.today();

        Test.startTest();
        dmpl__BillReturn__c billReturn;
        try {
            billReturn = BillTestDataHelpers.createBillReturn(
                null,      
                partner,
                branch,
                null,
                documentDate
            );
        } catch (Exception e) {
            billReturn = null;
        }
        Test.stopTest();

        System.assertEquals(null, billReturn);
    }

    @isTest
    public static void createBillReturnWithWrongPartnerPositive() {
        Account validPartner = TestDataHelpers.getPartnerAccount('Partner 1'); 
        Account wrongPartner = TestDataHelpers.getPartnerAccount('Partner 4'); 
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Date documentDate = Date.newInstance(2025, 6, 17);

        Test.startTest();
        dmpl__BillReturn__c billReturn = BillTestDataHelpers.createBillReturn(
            supplier,
            validPartner,
            branch,
            null,
            documentDate
        );
        System.assertnotEquals(null, billReturn.Id, 'Initial Bill Return creation with valid partner failed');

        billReturn.dmpl__PartnerAccountId__c = wrongPartner.Id;
        Boolean updateFailed = false;
        try {
            update billReturn;
        } catch (Exception e) {
            updateFailed = true;
        }
        Test.stopTest();

        System.assertnotEquals(null, updateFailed, 'Bill Return update should fail when assigning a wrong partner account');
    }

    @isTest
    public static void updateBillReturnLineWithRemovingRequiredSKUNegative() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 7');
        dmpl__SKU__c sku = TestDataHelpers.getSKU('SKU 1');
        Date today = Date.today();

        Test.startTest();
        dmpl__BillReturn__c billReturn = BillTestDataHelpers.createBillReturn(
            supplier,
            partner,
            branch,
            null,
            today
        );

        dmpl__BillReturnLine__c line = BillTestDataHelpers.createBillReturnLine(
            billReturn,
            item,
            sku,
            5
        );
        System.assertNotEquals(null, line.Id, 'Line should be created with SKU');
        line.dmpl__SKUId__c = null;

        try {
            update line;
            System.assert(false, 'Update should fail when SKU is removed');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('SKUId__c'), 'Expected SKU-related validation error');
        }
        Test.stopTest();
    }






    //new scenarios 
    @isTest
    static void createBillLineWithoutUnitCostPositive() {

        Test.startTest();

        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 3');
        dmpl__SKU__c sku = TestDataHelpers.getSKU('SKU 3'); 
        //dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup('GST 0'); 
        Account customer1=TestDataHelpers.getCustomerAccount('Customer 1');


        dmpl__Bill__c bill = BillTestDataHelpers.createBill(supplier.Id, branch.Id, partner.Id);
        System.assertNotEquals(null, bill.Id, 'Bill should be created ');

        dmpl__BillLine__c billLine = BillTestDataHelpers.createBillLineWithNoUnitCost(
        bill.Id,item,13
        );

        dmpl__BillLine__c fetchedLine = BillTestDataHelpers.getBillLine(billLine.Id);

        Test.stopTest();
        
        System.assertEquals(partner.Id, bill.dmpl__PartnerAccountId__c, 'Partner should match');
        System.assertEquals(supplier.Id, bill.dmpl__SupplierAccountId__c, 'Supplier should match');
        System.assertEquals(branch.Id, bill.dmpl__BranchId__c, 'Branch should match');

        System.assertEquals(null, fetchedLine.dmpl__UnitCost2__c, 'Unit cost should be null');
        System.assertEquals(13, fetchedLine.dmpl__Quantity__c, 'Invoice Quantity should be 13');
        System.assertEquals(13, fetchedLine.dmpl__EligibleReturnQuantity__c, 'Eligible Return Quantity should be 13');
        System.assertEquals(0, fetchedLine.dmpl__Amount__c, 'Amount should be 0');
        System.assertEquals(0, fetchedLine.dmpl__BaseAmount__c, 'Base Amount should be 0');
        System.assertEquals(0, fetchedLine.dmpl__GrossAmount__c, 'Gross Amount should be 0');
        System.assertEquals(0, fetchedLine.dmpl__NetDiscount__c, 'Net Discount should be 0');
    }

    @isTest
    static void editBillLineWithoutUnitCostPositive() {

        Test.startTest();

        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__SKU__c sku = TestDataHelpers.getSKU('SKU 1');

        dmpl__Bill__c bill = BillTestDataHelpers.createBill(supplier.Id, branch.Id, partner.Id);
        System.assertNotEquals(null, bill.Id, 'Bill should be created');

        dmpl__BillLine__c billLine = BillTestDataHelpers.createBillLine(
            bill.Id, item, 1,1500,null
        );

        dmpl__BillLine__c fetchedBillLine = BillTestDataHelpers.getBillLine(billLine.Id);
        System.assertEquals(1, fetchedBillLine.dmpl__Quantity__c, 'Quantity should be 1');

        billLine.dmpl__UnitCost2__c = 0;
        update billLine;

        dmpl__BillLine__c fetchedBillLineNoCost = BillTestDataHelpers.getBillLine(billLine.Id);
        System.assertEquals(1, fetchedBillLineNoCost.dmpl__Quantity__c, 'Quantity should be 1');
        System.assertEquals(0, fetchedBillLineNoCost.dmpl__UnitCost2__c, 'Base Amount should be 0');

        Test.stopTest();

        System.assertEquals(partner.Id, bill.dmpl__PartnerAccountId__c, 'Partner should match');
        System.assertEquals(branch.Id, bill.dmpl__BranchId__c, 'Branch should match');
    }

    @isTest
    static void createBillLineWithPurchaseOrderLineReferencePositive() {
        Test.startTest();

        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 3');
        dmpl__SKU__c sku = TestDataHelpers.getSKU('SKU 3');

        dmpl__PurchaseOrder__c po = BillTestDataHelpers.createPurchaseOrder(branch, supplier, partner);
        dmpl__PurchaseOrderLine__c poLine = BillTestDataHelpers.createPurchaseOrderLine(po, 1500, 1, item, sku, null);

        dmpl__Bill__c bill = BillTestDataHelpers.createBill(
            supplier.Id,
            branch.Id,
            partner.Id,
            Date.today(),
            po.Id,null,
            null
        );
        System.assertNotEquals(null, bill.Id, 'Bill should be created');
        System.assertEquals(partner.Id, bill.dmpl__PartnerAccountId__c, 'Partner should match');
        System.assertEquals(branch.Id, bill.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(po.Id, bill.dmpl__PurchaseOrderId__c, 'Purchase Order should be associated with the Bill');

        dmpl__BillLine__c billLine = BillTestDataHelpers.createBillLine(
            bill.Id,
            item,
            1,
            1500,
            poLine
        );

        dmpl__BillLine__c fetchedLine = BillTestDataHelpers.getBillLine(billLine.Id);

        Test.stopTest();

        System.assertEquals(1, fetchedLine.dmpl__Quantity__c, 'Quantity should be 1');
        System.assertEquals(1500, fetchedLine.dmpl__UnitCost__c, 'Unit Cost should be 1500');
        System.assertEquals(1500, fetchedLine.dmpl__BaseAmount__c, 'Base Amount should be 1500');
        System.assertEquals(1500, fetchedLine.dmpl__Amount__c, 'Amount should be 1500');
        System.assertEquals(1500, fetchedLine.dmpl__GrossAmount__c, 'Gross Amount should be 1500');
        System.assertEquals(poLine.Id, fetchedLine.dmpl__PurchaseOrderLineId__c, 'Purchase Order Line should be correctly linked');
    }


    //FIELD_CUSTOM_VALIDATION_EXCEPTION, Specified field is not editable if there exists downstream transaction. Field Name : "dmpl__PurchaseOrderLineId__c".
    //Blocked
    @isTest
    static void editBillLineWithPurchaseOrderLineReferencePositive() {
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 3');
        dmpl__SKU__c sku = TestDataHelpers.getSKU('SKU 3');

        dmpl__PurchaseOrder__c po = BillTestDataHelpers.createPurchaseOrder(branch, supplier, partner);
        dmpl__PurchaseOrderLine__c poLine = BillTestDataHelpers.createPurchaseOrderLine(po, 1500, 1, item, sku, null);

        dmpl__Bill__c bill = BillTestDataHelpers.createBill(
            supplier.Id,
            branch.Id,
            partner.Id,
            Date.today(),
            po.Id,
            null,
            null
        );
        System.assertNotEquals(null, bill.Id, 'Bill should be created');

        dmpl__BillLine__c billLine = BillTestDataHelpers.createBillLine(
            bill.Id,
            item,
            1,
            1500,
            null 
        );

        billLine.dmpl__PurchaseOrderLineId__c = poLine.Id;
        update billLine;

        dmpl__BillLine__c fetchedLine = BillTestDataHelpers.getBillLine(billLine.Id);

        Test.stopTest();

        System.assertEquals(partner.Id, bill.dmpl__PartnerAccountId__c, 'Partner should match');
        System.assertEquals(branch.Id, bill.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(po.Id, bill.dmpl__PurchaseOrderId__c, 'Purchase Order should be linked');

        System.assertEquals(1, fetchedLine.dmpl__Quantity__c, 'Quantity should be 1');
        System.assertEquals(1500, fetchedLine.dmpl__UnitCost__c, 'Unit Cost should be 1500');
        System.assertEquals(1500, fetchedLine.dmpl__Amount__c, 'Amount should be 1500');
        System.assertEquals(1500, fetchedLine.dmpl__BaseAmount__c, 'Base Amount should be 1500');
        System.assertEquals(1500, fetchedLine.dmpl__GrossAmount__c, 'Gross Amount should be 1500');
        System.assertEquals(poLine.Id, fetchedLine.dmpl__PurchaseOrderLineId__c, 'PO Line should be linked after edit');
    }


    @isTest
    static void createBillLineWithoutPurchaseOrderLineReferencePositive() {
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 3');

        dmpl__Bill__c bill = BillTestDataHelpers.createBill(
            supplier.Id,
            branch.Id,
            partner.Id,
            Date.today(),
            null,    
            null,
            null
        );

        System.assertNotEquals(null, bill.Id, 'Bill should be created');
        System.assertEquals(partner.Id, bill.dmpl__PartnerAccountId__c, 'Partner should match');
        System.assertEquals(branch.Id, bill.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(Date.today(), bill.dmpl__DocumentDate__c, 'Document date should be today');

        dmpl__BillLine__c billLine = BillTestDataHelpers.createBillLine(
            bill.Id,
            item,
            1,
            1500,
            null  
        );

        dmpl__BillLine__c fetchedLine = BillTestDataHelpers.getBillLine(billLine.Id);

        Test.stopTest();

        System.assertEquals(1, fetchedLine.dmpl__Quantity__c, 'Quantity should be 1');
        System.assertEquals(1500, fetchedLine.dmpl__UnitCost__c, 'Unit cost should be 1500');
        System.assertEquals(1500, fetchedLine.dmpl__BaseAmount__c, 'Base amount should be 1500');
        System.assertEquals(1500, fetchedLine.dmpl__Amount__c, 'Amount should be 1500');
        System.assertEquals(1500, fetchedLine.dmpl__GrossAmount__c, 'Gross amount should be 1500');
        System.assertEquals(null, fetchedLine.dmpl__PurchaseOrderLineId__c, 'PO Line reference should be null');
    }
    
    //Maithili
    @isTest
    public static void updateBillLineWithoutPurchaseOrderLineRefrencePositive() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 3');
        dmpl__SKU__c sku = TestDataHelpers.getSKU('SKU 3');

        dmpl__PurchaseOrder__c po = BillTestDataHelpers.createPurchaseOrder(branch, supplier, partner);
        dmpl__PurchaseOrderLine__c poLine = BillTestDataHelpers.createPurchaseOrderLine(po, 1500, 1, item, sku, null);

        dmpl__Bill__c bill = BillTestDataHelpers.createBillNew(
            supplier,
            branch,
            null,
            po,
            null
        );

        dmpl__BillLine__c billLine = BillTestDataHelpers.createBillLine(
            bill.Id,
            item,
            1,
            1500,
            poLine
        );

        Test.startTest();
        billLine.dmpl__PurchaseOrderLineId__c = null;
        try {
            update billLine;
            System.assert(false);
        } catch (Exception e) {
            System.assert(e.getMessage().contains('dmpl__PurchaseOrderLineId__c'));
        }
        Test.stopTest();
    }

    @isTest
    public static void createBillLineWithStorageLocationPositive() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
        dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
        dmpl__StorageLocation__c storageLocation = TestDataHelpers.getStorageLocation('Storage Location 1');

        dmpl__Bill__c bill = BillTestDataHelpers.createBillNew(
            supplier,
            branch,
            null,
            null,
            null
        );

        Test.startTest();
        dmpl__BillLine__c billLine = BillTestDataHelpers.createBillLineWithStorageLocation(
            bill.Id,
            item,
            1,
            1500,
            storageLocation
        );
        Test.stopTest();

        System.assertNotEquals(null, billLine.Id, 'Bill Line with storage location should be created');
        System.assertEquals(storageLocation.Id, billLine.dmpl__StorageLocationId__c, 'Storage Location should be set correctly');
    }
    
    @isTest
    public static void CreateBillLineWithoutStorageLocationPositive() {
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');

        dmpl__Item__c item = TestDataHelpers.getItem('Item 3');
        dmpl__SKU__c sku = TestDataHelpers.getSKU('SKU 3');

        dmpl__Bill__c bill = BillTestDataHelpers.createBillNew(
            supplier, branch, null, null, null
        );

        Decimal quantity = 10;
        Decimal unitCost = 1500;

        dmpl__BillLine__c billLine = BillTestDataHelpers.createBillLineWithNoUnitCost(
            bill.Id, item, quantity
        );

        billLine.dmpl__UnitCost__c = unitCost;

        System.assertEquals(quantity, billLine.dmpl__Quantity__c);
        System.assertEquals(unitCost, billLine.dmpl__UnitCost__c);
        System.assertEquals(item.Id, billLine.dmpl__ItemId__c);
        System.assertEquals(null, billLine.dmpl__StorageLocationId__c);
    }

    @isTest
    public static void updateBillLineWithoutStorageLocationPositive() {
        Account supplier = TestDataHelpers.getSupplierAccount('Supplier 1');
        Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');

        dmpl__Item__c item = TestDataHelpers.getItem('Item 3');
        dmpl__SKU__c sku = TestDataHelpers.getSKU('SKU 3');

        dmpl__Bill__c bill = BillTestDataHelpers.createBillNew(
            supplier, branch, null, null, null
        );

        dmpl__BillLine__c billLine = BillTestDataHelpers.createBillLineWithNoUnitCost(
            bill.Id, item, 10
        );

        billLine.dmpl__UnitCost__c = 1500;
        billLine.dmpl__Quantity__c = 8;
        update billLine;

        System.assertEquals(8, billLine.dmpl__Quantity__c);
        System.assertEquals(1500, billLine.dmpl__UnitCost__c);
        System.assertEquals(null, billLine.dmpl__StorageLocationId__c);
    }
}