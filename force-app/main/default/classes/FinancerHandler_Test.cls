@isTest
public with sharing class FinancerHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Account partnerAccount = TestDataHelpers.createPartnerAccount();
        Account customerAccount = TestDataHelpers.createCustomerAccount();
        dmpl__AccountGroup__c accGroup = TestDataHelpers.createAccountGroup();
        dmpl__Branch__c branch = TestDataHelpers.createBranch(partnerAccount);
        dmpl__ContactAddress__c contactAddress = TestDataHelpers.CreateContactAddress(customerAccount);
        dmpl__Item__c item = TestDataHelpers.createItem();
        dmpl__SKU__c sku = TestDataHelpers.createSKU(item);
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.createTaxGroup(partnerAccount, branch);
        dmpl__PriceList__c priceList = TestDataHelpers.createPriceList(partnerAccount, branch);
        dmpl__PriceListRules__c priceListRule = TestDataHelpers.createPriceListRules(priceList, item);
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(customerAccount, branch, contactAddress, priceList);
        dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.createSaleOrderLine(saleOrder, item, sku, taxGroup);
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.createSaleInvoice(customerAccount, branch, saleOrder, priceList);
        dmpl__Financer__c financer = FinancerDataHelper.createFinancer(customerAccount.Id);
        dmpl__FinancerScheme__c scheme = FinancerDataHelper.createFinancerScheme(financer, partnerAccount.ID, accGroup.Id);
        dmpl__FinanceCase__c financeCase = FinancerDataHelper.createFinanceCase(customerAccount, branch, saleOrder, saleInvoice, financer, scheme);
    }

    @isTest
    static void createFinanceCasePositive() {
        Test.startTest();
        dmpl__FinanceCase__c financeCase = FinancerDataHelper.getFinanceCase();
        Test.stopTest();
        System.assertNotEquals(null, financeCase.Id, 'Finance case should be inserted');
        System.assertEquals('Draft', financeCase.dmpl__Status__c, 'Finance case should default to Draft');
    }

    @isTest
    static void updateFinanceCasePositive() {
        dmpl__FinanceCase__c fc = FinancerDataHelper.getFinanceCase();
        fc.dmpl__RequestedAmount__c = 12000;
        update fc;
        dmpl__FinanceCase__c updated = FinancerDataHelper.getFinanceCase(fc.Id);
        System.assertEquals(12000, updated.dmpl__RequestedAmount__c, 'Requested amount should update');
    }

    @isTest
    static void deleteFinanceCase() {
        dmpl__FinanceCase__c fc = FinancerDataHelper.getFinanceCase();
        Id financeCaseId = fc.Id;
        delete fc;

        try {
            dmpl__FinanceCase__c deletedCase = FinancerDataHelper.getFinanceCase(financeCaseId);
            System.assert(false, 'Expected Finance Case to be deleted, but record still exists.');
        } catch (QueryException e) {
            System.assert(true, 'Finance Case successfully deleted.');
        }
    }

    @isTest
    static void createFinancerPositive() {
        dmpl__Financer__c f1 = FinancerDataHelper.getFinancer();
        System.assertNotEquals(f1, null, 'Expected financer to be created.');
    }

    @isTest
    static void updateFinancerPositive() {
        dmpl__Financer__c f1 = FinancerDataHelper.getFinancer();
        f1.Name = 'updated-financer';
        update f1;
        dmpl__Financer__c updated = FinancerDataHelper.getFinancer(f1.Id);
        System.assertEquals('updated-financer', updated.Name, 'Expected financer name to be updated.');
    }

    @isTest
    static void deleteFinancer() {
        dmpl__Financer__c f1 = FinancerDataHelper.getFinancer();
        Id financerId = f1.Id;
        delete f1;

        try {
            dmpl__Financer__c deleted = FinancerDataHelper.getFinancer(financerId);
            System.assert(false, 'Expected Financer to be deleted, but record still exists.');
        } catch (QueryException ex) {
            System.assert(true, 'Financer successfully deleted.');
        }
    }

    @isTest
    static void createFinancerSchemePositive() {
        dmpl__FinancerScheme__c fs = FinancerDataHelper.getFinancerScheme();
        System.assert(fs != null, 'Financer Scheme should be retrieved');
        System.assert(fs.Id != null, 'Financer Scheme should be inserted');
    }

    @isTest
    static void updateFinancerSchemePositive() {
        dmpl__FinancerScheme__c fs = FinancerDataHelper.getFinancerScheme();
        fs.Name = 'Updated Scheme Name';
        update fs;
        dmpl__FinancerScheme__c updated = FinancerDataHelper.getFinancerScheme(fs.Id);
        System.assertEquals('Updated Scheme Name', updated.Name);
    }

    @isTest
    static void deleteFinancerScheme() {
        dmpl__FinancerScheme__c fs = FinancerDataHelper.getFinancerScheme();
        Id schemeId = fs.Id;
        delete fs;
        try {
            dmpl__FinancerScheme__c deleted = FinancerDataHelper.getFinancerScheme(schemeId);
            System.assert(false, 'Expected Financer Scheme to be deleted, but record still exists.');
        } catch (QueryException e) {
            System.assert(true, 'Financer Scheme successfully deleted.');
        }
    }
}