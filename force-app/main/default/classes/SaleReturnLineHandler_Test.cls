@isTest
public with sharing class SaleReturnLineHandler_Test {
    
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
        dmpl__SaleReturn__c saleReturn = SaleReturnDataHelperTest.createSaleReturn(TestDataHelpers.getCustomerAccount(), TestDataHelpers.getBranch(),
                                                                              TestDataHelpers.getContactAddress(), TestDataHelpers.getPriceList());
        dmpl__SaleReturnLine__c saleReturnLine = SaleReturnDataHelperTest.createSaleReturnLine(saleReturn, TestDataHelpers.getItem(),
                                                                                         TestDataHelpers.getSKU(), TestDataHelpers.getTaxGroup());
    }

    @isTest
    static void createSaleReturnLinePositive() {
        dmpl__SaleReturn__c saleReturn = SaleReturnDataHelperTest.getSaleReturn();
        dmpl__SaleReturnLine__c line = SaleReturnDataHelperTest.getSaleReturnLine();
        
        System.assertNotEquals(null, line.Id, 'Expected sale return line to be created');
        System.assertEquals(saleReturn.Id, line.dmpl__SaleReturnId__c, 'Sale Return ID should match');
    }

    @isTest
    static void updateSaleReturnLinePositive() {
        dmpl__SaleReturn__c saleReturn = SaleReturnDataHelperTest.getSaleReturn();
        dmpl__SaleReturnLine__c line = SaleReturnDataHelperTest.getSaleReturnLine();
        
        Test.startTest();
        line.dmpl__Quantity__c = 5;
        line.dmpl__UnitPrice__c = 200;
        update line;
        Test.stopTest();

        dmpl__SaleReturnLine__c updatedLine = SaleReturnDataHelperTest.getSaleReturnLine(line.dmpl__SaleReturnId__c);
        System.assertEquals(5, updatedLine.dmpl__Quantity__c, 'Quantity should be updated to 5');
        System.assertEquals(200, updatedLine.dmpl__UnitPrice__c, 'Unit price should be updated to 200');
    }

    @isTest
    static void deleteSaleReturnLine() {
        dmpl__SaleReturn__c saleReturn = SaleReturnDataHelperTest.getSaleReturn();
        dmpl__SaleReturnLine__c line = SaleReturnDataHelperTest.getSaleReturnLine();

        Test.startTest();
        delete line;
        Test.stopTest();

        dmpl__SaleReturnLine__c deletedLine = SaleReturnDataHelperTest.getSaleReturnLine(line.Id);
        System.assertEquals(null, deletedLine, 'Sale Return Line should be deleted');
    }
}