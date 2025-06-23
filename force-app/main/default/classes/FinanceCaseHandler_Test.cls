@isTest
public with sharing class FinanceCaseHandler_Test {
   
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
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceTestDataHelpers.createSaleInvoice(customerAccount, branch, saleOrder, priceList);
        dmpl__Financer__c financer = FinanceCaseDataHelper.createFinancer(customerAccount.Id);
        dmpl__FinancerScheme__c scheme = FinanceCaseDataHelper.createFinancerScheme(financer, null, null);
        FinanceCaseDataHelper.createFinanceCase(customerAccount, branch, saleOrder, saleInvoice, financer, scheme);
    }
    
    @isTest
    static void createFinanceCasePositive() {
        Test.startTest();
        Account customer = TestDataHelpers.getCustomerAccount();
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.getSaleOrder();
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceTestDataHelpers.getSaleInvoice();
        dmpl__Financer__c financer = FinanceCaseDataHelper.getFinancer();
        dmpl__FinancerScheme__c scheme = FinanceCaseDataHelper.getFinancerScheme();
        dmpl__FinanceCase__c financeCase = FinanceCaseDataHelper.createFinanceCase(
            customer,
            branch,
            saleOrder,
            saleInvoice,
            financer,
            scheme
        );
        Test.stopTest();
        System.assertNotEquals(null, financeCase.Id, 'Finance case should be inserted');
        System.assertEquals('Draft', financeCase.dmpl__Status__c, 'Finance case should default to Draft');
        System.assertEquals(saleOrder.Id, financeCase.dmpl__SaleOrderId__c, 'Sale Order reference should be correct');
    }
    
    @isTest
    static void updateFinanceCasePositive() {
        dmpl__FinanceCase__c fc = FinanceCaseDataHelper.getFinanceCase();
        fc.dmpl__RequestedAmount__c = 12000;
        update fc;
        dmpl__FinanceCase__c updated = FinanceCaseDataHelper.getFinanceCase(fc.Id);
        System.assertEquals(12000, updated.dmpl__RequestedAmount__c, 'Requested amount should update');
    }

    @isTest
    static void deleteFinanceCase() {
        dmpl__FinanceCase__c fc = FinanceCaseDataHelper.getFinanceCase();
        Id financeCaseId = fc.Id;
        delete fc;
        try {
            dmpl__FinanceCase__c deletedFinanceCase = FinanceCaseDataHelper.getFinanceCase(financeCaseId);
            System.assert(false, 'Expected finance case to be deleted, but record still exists.');
        } catch (QueryException e) {
            System.assert(true, 'Finance case successfully deleted.');
        }
    }
}