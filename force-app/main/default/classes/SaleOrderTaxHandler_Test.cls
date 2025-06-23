@isTest
public with sharing class SaleOrderTaxHandler_Test {
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
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(customerAccount, branch, contactAddress, priceList);
        dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.createSaleOrderLine(saleOrder, item, sku, taxGroup);
        dmpl__SaleOrderTax__c saleOrderTax = SaleOrderTaxDataHelper.createSaleOrderTax(saleOrder, saleOrderLine);
    }

    @isTest
    static void createSaleOrderTaxPositive() {
        dmpl__SaleOrder__c saleOrder = SaleOrderTestDataHelpers.getSaleOrder();
        dmpl__SaleOrderLine__c line = SaleOrderTestDataHelpers.getSaleOrderLine();
        dmpl__SaleOrderTax__c existingTax = SaleOrderTaxDataHelper.getSaleOrderTax();
        
        Test.startTest();
        dmpl__SaleOrderTax__c tax = existingTax;
        Test.stopTest();

        dmpl__SaleOrderTax__c createdTax = SaleOrderTaxDataHelper.getSaleOrderTax(tax.Id);
        System.assertNotEquals(null, createdTax.Id, 'Expected SaleOrderTax to be created');
        System.assertEquals(150, createdTax.dmpl__TaxAmount__c, 'Tax amount should be 150');
    }

    @isTest
    static void updateSaleOrderTaxPositive() {
        dmpl__SaleOrder__c saleOrder = SaleOrderTestDataHelpers.getSaleOrder();
        dmpl__SaleOrderLine__c line = SaleOrderTestDataHelpers.getSaleOrderLine();
        dmpl__SaleOrderTax__c tax = SaleOrderTaxDataHelper.getSaleOrderTax();
        
        Test.startTest();
        tax.dmpl__TaxAmount__c = 200;
        update tax;
        Test.stopTest();

        dmpl__SaleOrderTax__c updatedTax = SaleOrderTaxDataHelper.getSaleOrderTax(tax.Id);
        System.assertEquals(200, updatedTax.dmpl__TaxAmount__c, 'Tax amount should be updated to 200');
        System.assertEquals(saleOrder.Id, updatedTax.dmpl__SaleOrderId__c, 'Sale Order ID should match');
        System.assertEquals(line.Id, updatedTax.dmpl__SaleOrderLineId__c, 'Sale Order Line ID should match');
    }

    @isTest
    static void deleteSaleOrderTax() {
        dmpl__SaleOrder__c saleOrder = SaleOrderTestDataHelpers.getSaleOrder();
        dmpl__SaleOrderLine__c line = SaleOrderTestDataHelpers.getSaleOrderLine();
        dmpl__SaleOrderTax__c tax = SaleOrderTaxDataHelper.getSaleOrderTax();
        
        Test.startTest();
        delete tax;
        Test.stopTest();
        
        dmpl__SaleOrderTax__c deletedTax = null;
        
        try {
            deletedTax = SaleOrderTaxDataHelper.getSaleOrderTax(tax.Id);
        } catch (QueryException e) {
            deletedTax = null;
        }
        
        System.assertEquals(null, deletedTax, 'Tax record should be deleted');
    }
}