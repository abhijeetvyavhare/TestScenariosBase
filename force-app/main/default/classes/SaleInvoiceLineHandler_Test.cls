@isTest
public with sharing class SaleInvoiceLineHandler_Test {
    
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
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceTestDataHelpers.createSaleInvoice(customerAccount, branch, saleOrder, priceList);
        dmpl__SaleInvoiceLine__c saleInvoiceLine = SaleInvoiceTestDataHelpers.createSaleInvoiceLine(saleInvoice, item, sku, null, taxGroup, priceListRule);
    }

    @isTest 
    static void createSaleInvoiceLinePositive() {
        Test.startTest();
        dmpl__SaleInvoiceLine__c line = SaleInvoiceTestDataHelpers.getSaleInvoiceLine();
        Test.stopTest();
        System.assertNotEquals(line, null, 'Expected sale invoice line to be created');
        System.assertEquals(10, line.dmpl__Quantity__c, 'Quantity should be 10');
        System.assertEquals(0, line.dmpl__AllocatedQuantity__c, 'AllocatedQuantity should be 0');
        System.assertEquals(100, line.dmpl__DiscountAmount__c, 'DiscountAmount should be 100');
    }

    @isTest
    static void updateSaleInvoiceLinePositive() {
        dmpl__SaleInvoiceLine__c line = SaleInvoiceTestDataHelpers.getSaleInvoiceLine();
        
        line.dmpl__Quantity__c = 20;
        line.dmpl__Discount__c = 5;
        line.dmpl__SchemeDiscount__c = 15;
        line.dmpl__ContractDiscount__c = 20;
        update line;

        Test.startTest();
        dmpl__SaleInvoiceLine__c updatedLine = SaleInvoiceTestDataHelpers.getSaleInvoiceLine();
        Test.stopTest();
        System.assertEquals(5, updatedLine.dmpl__Discount__c, 'Discount should be updated to 5');
        System.assertEquals(15, updatedLine.dmpl__SchemeDiscount__c, 'SchemeDiscount should be updated to 15');
        System.assertEquals(20, updatedLine.dmpl__ContractDiscount__c, 'ContractDiscount should be updated to 20');
        System.assertEquals(20, updatedLine.dmpl__Quantity__c, 'Quantity should be updated to 20');
    }

    @isTest
    static void deleteSaleInvoiceLine() {
        dmpl__SaleInvoiceLine__c line = SaleInvoiceTestDataHelpers.getSaleInvoiceLine();
        System.assertNotEquals(line, null, 'SaleInvoiceLine should exist before delete.');

        Test.startTest();
        try {
            delete line;
            System.assert(false, 'Expected DMLException when deleting SaleInvoiceLine');
        } catch (DMLException e) {
            System.assertEquals('There are downstream transaction. The object can not be deleted.', e.getDmlMessage(0), 
                'Expected IntegrityFailed_TransactedObjectNotDeletable error message');
        }
        Test.stopTest();
        dmpl__SaleInvoiceLine__c existingLine = SaleInvoiceTestDataHelpers.getSaleInvoiceLine();
        System.assertNotEquals(null, existingLine, 'SaleInvoiceLine should still exist after failed delete');
    }
}