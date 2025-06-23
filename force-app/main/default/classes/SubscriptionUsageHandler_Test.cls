@isTest
public with sharing class SubscriptionUsageHandler_Test {

    @TestSetup
    static void createRequiredData() {
        Account partnerAccount = TestDataHelpers.createPartnerAccount();
        Account customerAccount = TestDataHelpers.createCustomerAccount();  
        dmpl__AccountGroup__c accGroup = TestDataHelpers.createAccountGroup();
        Account acc = TestDataHelpers.createAccount(accGroup);
        dmpl__Branch__c branch = TestDataHelpers.createBranch(partnerAccount);    
        dmpl__ContactAddress__c contactAddress = TestDataHelpers.CreateContactAddress(customerAccount);
        dmpl__StorageLocation__c storageLocation = TestDataHelpers.createStorageLocation(branch);
        dmpl__Item__c item = TestDataHelpers.createItem();
        dmpl__SKU__c sku = TestDataHelpers.createSKU(item);
        dmpl__ItemLot__c itemLot = TestDataHelpers.createItemLot(branch, item, sku, storageLocation);
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.createTaxGroup(partnerAccount, branch);
        dmpl__PriceList__c priceList = TestDataHelpers.createPriceList(partnerAccount, branch);
        dmpl__PriceListRules__c priceListRule = TestDataHelpers.createPriceListRules(priceList, item);
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(customerAccount, branch, contactAddress, priceList);
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceTestDataHelpers.createSaleInvoice(customerAccount, branch, saleOrder, priceList);
        dmpl__SaleInvoiceLine__c saleInvoiceLine = SaleInvoiceTestDataHelpers.createSaleInvoiceLine(saleInvoice, item, sku, itemLot, taxGroup, priceListRule);
        dmpl__SubscriptionUsage__c usage = SubscriptionUsageDataHelper.createSubscriptionUsage(acc, saleInvoiceLine);
    }

    @isTest
    static void createSubscriptionUsagePositive() {
        dmpl__SubscriptionUsage__c usage = SubscriptionUsageDataHelper.getSubscriptionUsage();
        System.assertNotEquals(usage, null, 'SubscriptionUsage should be created.');
        System.assertEquals(5, usage.dmpl__Quantity__c, 'Quantity should be 5 as per default.');
    }

    @isTest
    static void updateSubscriptionUsagePositive() {
        dmpl__SubscriptionUsage__c usage = SubscriptionUsageDataHelper.getSubscriptionUsage();
        System.assertNotEquals(usage, null, 'SubscriptionUsage should exist before update.');
        usage.dmpl__Quantity__c = 10;
        update usage;
        dmpl__SubscriptionUsage__c updatedUsage = SubscriptionUsageDataHelper.getSubscriptionUsage(usage);
        System.assertEquals(10, updatedUsage.dmpl__Quantity__c, 'Quantity should be updated to 10.');
    }

    @isTest
    static void deleteSubscriptionUsage() {
        dmpl__SubscriptionUsage__c usage = SubscriptionUsageDataHelper.getSubscriptionUsage();
        System.assertNotEquals(usage, null, 'SubscriptionUsage should exist before delete.');
        delete usage;
        dmpl__SubscriptionUsage__c deletedUsage = null;
        try {
            deletedUsage = SubscriptionUsageDataHelper.getSubscriptionUsage(usage);
        } catch (Exception e) {
            deletedUsage = null;
        }

        System.assertEquals(null, deletedUsage, 'SubscriptionUsage should be deleted and not found.');
    }
}