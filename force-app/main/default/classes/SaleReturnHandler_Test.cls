@isTest
public with sharing class SaleReturnHandler_Test {

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
        dmpl__SaleReturn__c saleReturn = SaleReturnDataHelper.createSaleReturn(TestDataHelpers.getCustomerAccount(), TestDataHelpers.getBranch(),
                                                                              TestDataHelpers.getContactAddress(), TestDataHelpers.getPriceList());
        dmpl__SaleReturnLine__c saleReturnLine = SaleReturnDataHelper.createSaleReturnLine(saleReturn, TestDataHelpers.getItem(), TestDataHelpers.getSKU(), TestDataHelpers.getTaxGroup());
        dmpl__SaleReturnTax__c saleReturnTax = SaleReturnDataHelper.createSaleReturnTax(saleReturn, saleReturnLine);
    }
    
    @isTest
    static void createSaleReturnPositive() {
        dmpl__SaleReturn__c saleReturn = SaleReturnDataHelper.getSaleReturn();
        System.assertNotEquals(saleReturn, null, 'Expected sale return to be created.');
        System.assertEquals('Draft', saleReturn.dmpl__Status__c, 'Status should be Draft');
        System.assertEquals(false, saleReturn.dmpl__IsReturned__c, 'IsReturned should be false');
        System.assertEquals(false, saleReturn.dmpl__PerformInventoryPosting__c, 'PerformInventoryPosting should be false');
    }
    
    @isTest
    static void createSaleReturnLinePositive() {
        dmpl__SaleReturnLine__c retrievedLine = SaleReturnDataHelper.getSaleReturnLine();
        System.assertNotEquals(null, retrievedLine, 'Expected sale return line to be created');
        System.assertEquals(1, retrievedLine.dmpl__Quantity__c, 'Quantity should be 1');
        System.assertEquals(100, retrievedLine.dmpl__UnitPrice__c, 'Unit price should be 100');
        System.assertEquals(10, retrievedLine.dmpl__Discount2__c, 'Discount2 should be 10');
        System.assertEquals(10, retrievedLine.dmpl__ContractDiscount__c, 'Contract discount should be 10');
    }
    
    @isTest
    static void createSaleReturnTaxPositive() {
        dmpl__SaleReturn__c saleReturn = SaleReturnDataHelper.getSaleReturn();
        dmpl__SaleReturnLine__c line = SaleReturnDataHelper.getSaleReturnLine();
        dmpl__SaleReturnTax__c tax = SaleReturnDataHelper.getSaleReturnTax();
        System.assertNotEquals(null, tax.Id, 'Expected SaleReturnTax to be created');
        System.assertEquals(150, tax.dmpl__TaxAmount__c, 'Tax amount should be 150');
    }

    @isTest
    static void updateSaleReturnPositive() {
        dmpl__SaleReturn__c saleReturn = SaleReturnDataHelper.getSaleReturn();
        saleReturn.dmpl__TransactionType__c = 'Sample'; 
        saleReturn.dmpl__Remarks__c = 'Remark1';
        update saleReturn;
        dmpl__SaleReturn__c saleReturnUpdated = SaleReturnDataHelper.getSaleReturn(saleReturn.Id);
        System.assertEquals('Sample', saleReturnUpdated.dmpl__TransactionType__c, 'Transaction Type not updated correctly');
        System.assertEquals('Remark1', saleReturnUpdated.dmpl__Remarks__c, 'Remarks not updated correctly');
    }
    
    @isTest
    static void updateSaleReturnLinePositive() {
        dmpl__SaleReturnLine__c existingLine = SaleReturnDataHelper.getSaleReturnLine();
        
        Test.startTest();
        existingLine.dmpl__Quantity__c = 2;
        existingLine.dmpl__UnitPrice__c = 200;
        existingLine.dmpl__ContractDiscount__c = 20;
        update existingLine;
        Test.stopTest();

        dmpl__SaleReturnLine__c retrievedLine = SaleReturnDataHelper.getSaleReturnLine(existingLine.dmpl__SaleReturnId__c);
        System.assertNotEquals(null, retrievedLine, 'Sale Return Line should not be null after update');
        System.assertEquals(2, retrievedLine.dmpl__Quantity__c, 'Quantity should be updated to 2');
        System.assertEquals(200, retrievedLine.dmpl__UnitPrice__c, 'Unit price should be updated to 200');
        System.assertEquals(20, retrievedLine.dmpl__ContractDiscount__c, 'Discount should be updated to 20');
    }
    
    @isTest
    static void updateSaleReturnTaxPositive() {
        dmpl__SaleReturn__c saleReturn = SaleReturnDataHelper.getSaleReturn();
        dmpl__SaleReturnLine__c line = SaleReturnDataHelper.getSaleReturnLine();
        dmpl__SaleReturnTax__c tax = SaleReturnDataHelper.getSaleReturnTax();
        
        Test.startTest();
        tax.dmpl__TaxAmount__c = 200;
        tax.dmpl__TaxOnAmount__c = 2000;
        tax.dmpl__TaxRate__c = 10;
        update tax;
        Test.stopTest();

        dmpl__SaleReturnTax__c updatedTax = SaleReturnDataHelper.getSaleReturnTax(tax.Id);
        System.assertEquals(200, updatedTax.dmpl__TaxAmount__c, 'Tax amount should be updated to 200');
        System.assertEquals(2000, updatedTax.dmpl__TaxOnAmount__c, 'Tax on amount should be updated to 2000');
        System.assertEquals(10, updatedTax.dmpl__TaxRate__c, 'Tax rate should be updated to 10');
        System.assertEquals(saleReturn.Id, updatedTax.dmpl__SaleReturnId__c, 'Sale Return ID should match');
        System.assertEquals(line.Id, updatedTax.dmpl__SaleReturnLineId__c, 'Sale Return Line ID should match');
    }
    
    @isTest
    static void deleteSaleReturnTax() {
        dmpl__SaleReturn__c saleReturn = SaleReturnDataHelper.getSaleReturn();
        dmpl__SaleReturnLine__c line = SaleReturnDataHelper.getSaleReturnLine();
        dmpl__SaleReturnTax__c tax = SaleReturnDataHelper.getSaleReturnTax();

        Test.startTest();
        delete tax;
        Test.stopTest();

        dmpl__SaleReturnTax__c deletedTax = null;
        try {
            deletedTax = SaleReturnDataHelper.getSaleReturnTax(tax.Id);
        } catch (QueryException e) {
            deletedTax = null;
        }
        System.assertEquals(null, deletedTax, 'Tax record should be deleted');
    }
    
    @isTest
    static void deleteSaleReturnLine() {
        dmpl__SaleReturnLine__c existingLine = SaleReturnDataHelper.getSaleReturnLine();
        
        Test.startTest();
        delete existingLine;
        Test.stopTest();

        dmpl__SaleReturnLine__c deletedLine = null;
        try {
            deletedLine = SaleReturnDataHelper.getSaleReturnLine(existingLine.Id);
        } catch (Exception e) {
            deletedLine = null;
        }
        System.assertEquals(null, deletedLine, 'Sale Return Line should be deleted');
    }

    @isTest
    static void testDeleteSaleReturn() {
        dmpl__SaleReturn__c saleReturn = SaleReturnDataHelper.getSaleReturn();
        System.assertNotEquals(saleReturn, null, 'SaleReturn should exist before delete.');

        delete saleReturn;

        dmpl__SaleReturn__c deletedReturn = null;
        try {
            deletedReturn = SaleReturnDataHelper.getSaleReturn();
        } catch (Exception e) {
            deletedReturn = null;
        }
        System.assertEquals(null, deletedReturn, 'SaleReturn should be deleted and not found in query.');
    }
}