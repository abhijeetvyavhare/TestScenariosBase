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
        Test.StopTest();
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
}