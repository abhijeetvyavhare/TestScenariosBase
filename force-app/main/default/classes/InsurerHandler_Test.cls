@isTest
public with sharing class InsurerHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Account partnerAccount = TestDataHelpers.createPartnerAccount();
        Account customerAccount = TestDataHelpers.createCustomerAccount();
        dmpl__Branch__c branch = TestDataHelpers.createBranch(partnerAccount);
        dmpl__ContactAddress__c contactAddress = TestDataHelpers.CreateContactAddress(customerAccount);
        dmpl__Item__c item = TestDataHelpers.createItem();
        dmpl__SKU__c sku = TestDataHelpers.createSKU(item);
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.createTaxGroup(partnerAccount, branch);
        dmpl__PriceList__c priceList = TestDataHelpers.createPriceList(partnerAccount, branch);
        dmpl__PriceListRules__c priceListRule = TestDataHelpers.createPriceListRules(priceList, item);
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(customerAccount, branch, contactAddress, priceList);
        dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.createSaleOrderLine(saleOrder, item, sku, taxGroup);
        dmpl__Insurer__c insurer = InsurerDataHelper.createInsurer(customerAccount.Id);
        InsurerDataHelper.createInsuranceOrderLine(saleOrder.Id, saleOrderLine.Id, insurer.Id);
    }

    @isTest
    static void createInsurerPositive() {
        dmpl__Insurer__c insurer = InsurerDataHelper.getInsurer();
        System.assertNotEquals(null, insurer, 'Expected insurer to be created.');
    }

    @isTest
    static void updateInsurerPositive() {
        dmpl__Insurer__c insurer = InsurerDataHelper.getInsurer();
        insurer.Name = 'Updated Insurer Name';
        update insurer;

        dmpl__Insurer__c updatedInsurer = InsurerDataHelper.getInsurer(insurer.Id);
        System.assertEquals('Updated Insurer Name', updatedInsurer.Name, 'Expected insurer name to be updated.');
    }

    @isTest
    static void deleteInsurer() {
        dmpl__Insurer__c insurer = InsurerDataHelper.getInsurer();
        System.assertNotEquals(null, insurer, 'Insurer should exist before delete.');
        delete insurer;
        dmpl__Insurer__c deletedInsurer = null;
        try {
            deletedInsurer = InsurerDataHelper.getInsurer(insurer.Id);
        } catch (Exception e) {
            deletedInsurer = null;
        }
        System.assertEquals(null, deletedInsurer, 'Insurer should be deleted and not found.');
    }

    @isTest
    static void createInsuranceOrderLinePositive() {
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.getSaleOrder();
        dmpl__Insurer__c insurer = InsurerDataHelper.getInsurer();
        
        dmpl__InsuranceOrderLine__c line = InsurerDataHelper.getInsuranceOrderLine();
        System.assertNotEquals(null, line, 'Expected Insurance Order Line to be created.');
        System.assertEquals(saleOrder.Id, line.dmpl__SaleOrderId__c, 'Expected Sale Order reference.');
        System.assertEquals(insurer.Id, line.dmpl__InsurerId__c, 'Expected Insurer reference.');
    }

    @isTest
    static void updateInsuranceOrderLinePositive() {
        dmpl__InsuranceOrderLine__c line = InsurerDataHelper.getInsuranceOrderLine();
        line.dmpl__Remarks__c = 'Updated remarks';
        update line;
        
        dmpl__InsuranceOrderLine__c updated = InsurerDataHelper.getInsuranceOrderLine(line.Id);
        System.assertEquals('Updated remarks', updated.dmpl__Remarks__c, 'Expected remarks to be updated.');
    }
    
    @isTest
    static void deleteInsuranceOrderLine() {
        dmpl__InsuranceOrderLine__c line = InsurerDataHelper.getInsuranceOrderLine();
        delete line;
        List<dmpl__InsuranceOrderLine__c> remainingLines = InsurerDataHelper.getInsuranceOrderLines();
        System.assertEquals(0, remainingLines.size(), 'Expected Insurance Order Line to be deleted.');
    }
}