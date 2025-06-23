@isTest
public with sharing class SaleOrderLineHandler_Test {

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
    }

    @isTest
    static void createSaleOrderLinePositive() {
        dmpl__SaleOrderLine__c line = SaleOrderDataHelper.createSaleOrderLine(
            SaleOrderDataHelper.getSaleOrder(),
            TestDataHelpers.getItem(),
            TestDataHelpers.getSKU(),
            TestDataHelpers.getTaxGroup()
        );
        System.assertEquals(15, line.dmpl__Quantity__c, 'Quantity should be 15');
        System.assertEquals(5, line.dmpl__Discount__c, 'Discount should be 5');
        System.assertNotEquals(line, null, 'Expected line to be created.');
    }

    @isTest
    static void updateSaleOrderLinePositive() {
        dmpl__SaleOrderLine__c line = SaleOrderDataHelper.updateSaleOrderLine(
            SaleOrderDataHelper.getSaleOrder(),
            TestDataHelpers.getItem(),
            TestDataHelpers.getSKU(),
            TestDataHelpers.getTaxGroup(),
            SaleOrderDataHelper.getSaleOrderLine()
        );

        line.dmpl__Quantity__c = 2;
        line.dmpl__UnitPrice__c = 200;
        update line;

        dmpl__SaleOrderLine__c updatedLine = SaleOrderDataHelper.getSaleOrderLine(line.dmpl__SaleOrderId__c);

        System.assertEquals(2, updatedLine.dmpl__Quantity__c, 'Quantity not updated correctly');
        System.assertEquals(200, updatedLine.dmpl__UnitPrice__c, 'Unit price not updated correctly');
        System.assertEquals(380, updatedLine.dmpl__Amount__c, 'Amount calculation should be BaseAmount - NetSchemeDiscount - NetDiscount');
    }

    @isTest
    static void deleteSaleOrderLinePositive() {
        dmpl__SaleOrderLine__c line = SaleOrderDataHelper.getSaleOrderLine();
        System.assertNotEquals(line, null, 'SaleOrderLine should exist before delete.');

        Test.startTest();
        delete line;
        Test.stopTest();

        dmpl__SaleOrderLine__c deletedLine;
        try {
            deletedLine = SaleOrderDataHelper.getSaleOrderLine(line.Id);
        } catch(Exception e) {
            deletedLine = null;
        }
        System.assertEquals(null, deletedLine, 'SaleOrderLine should be deleted');
    }
}