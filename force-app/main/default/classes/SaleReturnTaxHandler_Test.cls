@isTest
public with sharing class SaleReturnTaxHandler_Test {

    @TestSetup
    static void makeData() {
        Account partnerAccount = TestDataHelpers.createPartnerAccount();
        Account customerAccount = TestDataHelpers.createCustomerAccount();        
        dmpl__Branch__c branch = TestDataHelpers.createBranch(partnerAccount);    
        dmpl__ContactAddress__c contactAddress = TestDataHelpers.CreateContactAddress(customerAccount);
        dmpl__Item__c item = TestDataHelpers.createItem();
        dmpl__SKU__c sku = TestDataHelpers.createSKU(item);
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.createTaxGroup(partnerAccount,branch);
        dmpl__PriceList__c priceList = TestDataHelpers.createPriceList(partnerAccount,branch);
        dmpl__PriceListRules__c priceListRule = TestDataHelpers.createPriceListRules(priceList,item);
        dmpl__SaleReturn__c saleReturn = SaleReturnDataHelperTest.createSaleReturn(customerAccount, branch, contactAddress, priceList);
        dmpl__SaleReturnLine__c saleReturnLine = SaleReturnDataHelperTest.createSaleReturnLine(saleReturn, item, sku, taxGroup);
        dmpl__SaleReturnTax__c saleReturnTax = SaleReturnDataHelperTest.createSaleReturnTax(saleReturn, saleReturnLine);
    }

    @isTest
    static void createSaleReturnTaxPositive() {
        dmpl__SaleReturn__c saleReturn = SaleReturnDataHelperTest.getSaleReturn();
        dmpl__SaleReturnLine__c line = SaleReturnDataHelperTest.getSaleReturnLine();
        dmpl__SaleReturnTax__c existingTax = SaleReturnDataHelperTest.getSaleReturnTax();
        
        Test.startTest();
        dmpl__SaleReturnTax__c tax = existingTax;
        Test.stopTest();

        dmpl__SaleReturnTax__c createdTax = SaleReturnDataHelperTest.getSaleReturnTax(tax.Id);
        System.assertNotEquals(null, createdTax.Id, 'Expected SaleReturnTax to be created');
        System.assertEquals(150, createdTax.dmpl__TaxAmount__c, 'Tax amount should be 150');
    }

    @isTest
    static void updateSaleReturnTaxPositive() {
        dmpl__SaleReturn__c saleReturn = SaleReturnDataHelperTest.getSaleReturn();
        dmpl__SaleReturnLine__c line = SaleReturnDataHelperTest.getSaleReturnLine();
        dmpl__SaleReturnTax__c tax = SaleReturnDataHelperTest.getSaleReturnTax();
        
        Test.startTest();
        tax.dmpl__TaxAmount__c = 200;
        tax.dmpl__TaxOnAmount__c = 2000;
        tax.dmpl__TaxRate__c = 10;
        update tax;
        Test.stopTest();

        dmpl__SaleReturnTax__c updatedTax = SaleReturnDataHelperTest.getSaleReturnTax(tax.Id);
        System.assertEquals(200, updatedTax.dmpl__TaxAmount__c, 'Tax amount should be updated to 200');
        System.assertEquals(2000, updatedTax.dmpl__TaxOnAmount__c, 'Tax on amount should be updated to 2000');
        System.assertEquals(10, updatedTax.dmpl__TaxRate__c, 'Tax rate should be updated to 10');
        System.assertEquals(saleReturn.Id, updatedTax.dmpl__SaleReturnId__c, 'Sale Return ID should match');
        System.assertEquals(line.Id, updatedTax.dmpl__SaleReturnLineId__c, 'Sale Return Line ID should match');
    }

    @isTest
    static void deleteSaleReturnTax() {
        dmpl__SaleReturn__c saleReturn = SaleReturnDataHelperTest.getSaleReturn();
        dmpl__SaleReturnLine__c line = SaleReturnDataHelperTest.getSaleReturnLine();
        dmpl__SaleReturnTax__c tax = SaleReturnDataHelperTest.getSaleReturnTax();

        Test.startTest();
        delete tax;
        Test.stopTest();

        dmpl__SaleReturnTax__c deletedTax = SaleReturnDataHelperTest.getSaleReturnTax(tax.Id);
        System.assertEquals(null, deletedTax, 'Tax record should be deleted');
    }
}