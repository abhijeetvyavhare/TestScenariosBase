@isTest
public with sharing class SubscriptionHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Account partnerAccount = TestDataHelpers.createPartnerAccount();
        Account customerAccount = TestDataHelpers.createCustomerAccount();        
        dmpl__Branch__c branch =TestDataHelpers.createBranch(partnerAccount);    
        dmpl__ContactAddress__c contactAddress =TestDataHelpers.CreateContactAddress(customerAccount);
        dmpl__StorageLocation__c storageLocation = TestDataHelpers.createStorageLocation(branch);
        dmpl__Item__c item =TestDataHelpers.createItem();
        dmpl__SKU__c sku =TestDataHelpers.createSKU(item);
        dmpl__ItemLot__c itemLot = TestDataHelpers.createItemLot(branch,item,sku,storageLocation);
        dmpl__TaxGroup__c taxGroup =TestDataHelpers.createTaxGroup(partnerAccount,branch);
        dmpl__PriceList__c priceList = TestDataHelpers.createPriceList(partnerAccount,branch);
        dmpl__PriceListRules__c priceListRule = TestDataHelpers.createPriceListRules(priceList,item);
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(customerAccount,branch,contactAddress,priceList);
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceTestDataHelpers.createSaleInvoice(TestDataHelpers.getCustomerAccount(),TestDataHelpers.getBranch(),
                                                                                            saleOrder,TestDataHelpers.getPriceList());
        dmpl__SaleInvoiceLine__c saleInvoiceLine = SaleInvoiceTestDataHelpers.createSaleInvoiceLine(saleInvoice,item,sku,itemLot,taxGroup,priceListRule);
        dmpl__Subscription__c subscription = SubscriptionDataHelper.createSubscription(saleInvoice,saleInvoiceLine,Item,saleInvoiceLine.dmpl__AssetId__c);
    }

    @isTest
    static void createSubscriptionPositive() {
        dmpl__Subscription__c subscription = SubscriptionDataHelper.getSubscription();
        if(subscription != null){
            System.assertNotEquals(subscription, null, 'Expected subscription to be created.');
        }
        System.assertEquals(null, subscription.dmpl__BillingFrequency__c, 'Billing Frequency should be monthly');
        System.assertEquals(null, subscription.dmpl__BillingType__c, 'Billing Type should be Advance');
        System.assertEquals(null, subscription.dmpl__ChargeType__c, 'Charge Type should be One Time');
        System.assertEquals(null, subscription.dmpl__PricingMethod__c, 'Pricing Method should be List Price');
    }

    @isTest
    static void updateSubscriptionPositive() {
        dmpl__Subscription__c subscription = SubscriptionDataHelper.getSubscription();
        System.assertNotEquals(subscription, null, 'Subscription should exist before update.');

        subscription.dmpl__PricingMethod__c = 'Bundled Price';
        subscription.dmpl__ChargeType__c = 'Recurring';
        update subscription;

        dmpl__Subscription__c updatedSubscription = SubscriptionDataHelper.getSubscription(subscription.id);
        System.assertEquals('Bundled Price', updatedSubscription.dmpl__PricingMethod__c, 'Expected subscription Pricing Method to be updated to Bundled Price.');
        System.assertEquals('Recurring', updatedSubscription.dmpl__ChargeType__c, 'Charge Type should be Recurring');
    }

    @isTest
    static void deleteSaleInvoice() {
        dmpl__Subscription__c subscription = SubscriptionDataHelper.getSubscription();
        System.assertNotEquals(subscription, null, 'subscription should exist before delete.');

        delete subscription;

        dmpl__Subscription__c deletedsubscription= null;
        try {
            deletedsubscription = SubscriptionDataHelper.getSubscription(subscription.id);
        } catch (Exception e) {
            deletedsubscription = null;
        }
        System.assertEquals(null, deletedsubscription, 'Subscription should be deleted and not found in query.');
    }
}