@isTest
public with sharing class SaleInvoiceTaxHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Account partnerAccount = TestDataHelpers.createPartnerAccount();
        Account customerAccount = TestDataHelpers.createCustomerAccount();        
        dmpl__Branch__c branch = TestDataHelpers.createBranch(partnerAccount);    
        dmpl__ContactAddress__c contactAddress = TestDataHelpers.CreateContactAddress(customerAccount);
        dmpl__Item__c item = TestDataHelpers.createItem();
        dmpl__SKU__c sku = TestDataHelpers.createSKU(item);
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.createTaxGroup(partnerAccount,branch);
        dmpl__PriceList__c priceList = TestDataHelpers.createPriceList(partnerAccount,branch);
        dmpl__PriceListRules__c priceListRule = TestDataHelpers.createPriceListRules(priceList,item);
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceTestDataHelpers.createSaleInvoice(customerAccount, branch, null, priceList);
        dmpl__SaleInvoiceLine__c saleInvoiceLine = SaleInvoiceTestDataHelpers.createSaleInvoiceLine(saleInvoice, item, sku, null, taxGroup, priceListRule);
    }

    @isTest
    static void createSaleInvoiceTaxPositive() {
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceTestDataHelpers.getSaleInvoice();
        dmpl__SaleInvoiceLine__c line = SaleInvoiceTestDataHelpers.getSaleInvoiceLine();
        
        Test.startTest();
        dmpl__SaleInvoiceTax__c tax = SaleInvoiceTaxDataTestHelper.createSaleInvoiceTax(saleInvoice, line);
        Test.stopTest();
        dmpl__SaleInvoiceTax__c createdTax = SaleInvoiceTaxDataTestHelper.getSaleInvoiceTax(tax.Id);
        System.assertNotEquals(null, createdTax.Id, 'Expected SaleInvoiceTax to be created');
        System.assertEquals(100, createdTax.dmpl__TaxAmount__c, 'Tax amount should be 100');
    }

    @isTest
    static void updateSaleInvoiceTaxPositive() {
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceTestDataHelpers.getSaleInvoice();
        dmpl__SaleInvoiceLine__c line = SaleInvoiceTestDataHelpers.getSaleInvoiceLine();
        
        dmpl__SaleInvoiceTax__c tax = SaleInvoiceTaxDataTestHelper.createSaleInvoiceTax(saleInvoice, line);

        Test.startTest();
        tax.dmpl__TaxAmount__c = 200;
        update tax;
        Test.stopTest();

        System.assertEquals(200, tax.dmpl__TaxAmount__c, 'Tax amount should be updated to 200');
        System.assertEquals(saleInvoice.Id, tax.dmpl__SaleInvoiceId__c, 'Sale Invoice ID should match');
        System.assertEquals(line.Id, tax.dmpl__SaleInvoiceLineId__c, 'Sale Invoice Line ID should match');
    }

    @isTest
    static void deleteSaleInvoiceTax() {
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceTestDataHelpers.getSaleInvoice();
        dmpl__SaleInvoiceLine__c line = SaleInvoiceTestDataHelpers.getSaleInvoiceLine();
        
        dmpl__SaleInvoiceTax__c tax = SaleInvoiceTaxDataTestHelper.createSaleInvoiceTax(saleInvoice, line);

        Test.startTest();
        delete tax;
        Test.stopTest();

        dmpl__SaleInvoiceTax__c deletedTax = null;
        try {
            deletedTax = SaleInvoiceTaxDataTestHelper.getSaleInvoiceTax(tax.Id);
        } catch (Exception e) {
            
        }
        System.assertEquals(null, deletedTax, 'SaleInvoiceTax should be deleted');
    }
}