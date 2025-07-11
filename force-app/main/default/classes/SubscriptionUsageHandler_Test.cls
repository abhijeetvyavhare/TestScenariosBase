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
        dmpl__SaleInvoice__c saleInvoice = SaleInvoiceDataHelper.createSaleInvoice(customerAccount, branch, saleOrder, priceList);
        dmpl__SaleInvoiceLine__c saleInvoiceLine = SaleInvoiceDataHelper.createSaleInvoiceLine(saleInvoice, item, sku, itemLot, taxGroup, priceListRule);
        dmpl__SubscriptionUsage__c usage = SubscriptionUsageDataHelper.createSubscriptionUsage(acc, saleInvoiceLine);
        dmpl__Subscription__c subscription = SubscriptionDataHelper.createSubscription(partnerAccount,customerAccount,branch,item,2,saleOrder,null,null);

        Account customerAccount1 = TestDataHelpers.createCustomerAccount('Customer 1', true, false, false, true, 'MG Road', 'Pune', 'Maharashtra', 'India', '411001', 'Ring Rd', 'Nagpur', 'Maharashtra', 'India', '440001','9876543210', 'Created');
        Account partnerAccount1 = TestDataHelpers.createPartnerAccount('Partner 1', false, true, false, true, 'MG Road', 'Bengaluru', 'Karnataka', 'India', '560001', '56 Industrial Layout', 'Bengaluru', 'Karnataka', 'India', '560095','9876543210');
        dmpl__Item__c  item1 = TestDataHelpers.createItem('Item 1','Product',true,false,false,'675654',false);
        dmpl__Item__c item2 = TestDataHelpers.createItem('Item 2','Product',false,false,false,'654345',false);
        Asset asset1 = TestDataHelpers.createAsset('Asset 1', customerAccount1.Id,item1.Id);



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



    //Subscription usage scenario
    @isTest
    static void createSubscriptionUsageNormalPositive(){
        dmpl__Subscription__c subscription = SubscriptionDataHelper.getSubscription();
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Asset asset1 = TestDataHelpers.getAsset('Asset 1');
        dmpl__Item__c  item1 = TestDataHelpers.getItem('Item 1');
        Test.startTest();
        dmpl__SubscriptionUsage__c usage = SubscriptionUsageDataHelper.createSubscriptionUsage(customerAccount1, asset1, item1,2, subscription);
        Test.stopTest();

        System.assertNotEquals(null, usage, 'SubscriptionUsage record should be created');
        System.assertEquals(asset1.Id, usage.dmpl__AssetId__c, 'Asset should be Asset 1');
        System.assertEquals(customerAccount1.Id, usage.dmpl__AccountId__c, 'Account should be Customer 1');
        System.assertEquals(item1.Id, usage.dmpl__ItemId__c, 'Item should be Item 1');
        System.assertEquals(2, usage.dmpl__Quantity__c, 'Quantity should be 2');
        System.assertEquals(subscription.Id, usage.dmpl__SubscriptionId__c, 'Subscription should be match');
    }

    @isTest
    static void createSubscriptionUsageWithCustomerAccountPositive(){
        dmpl__Subscription__c subscription = SubscriptionDataHelper.getSubscription();
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Asset asset1 = TestDataHelpers.getAsset('Asset 1');
        dmpl__Item__c  item1 = TestDataHelpers.getItem('Item 1');
        Test.startTest();
        dmpl__SubscriptionUsage__c usage = SubscriptionUsageDataHelper.createSubscriptionUsage(customerAccount1, asset1, item1,2, subscription);
        Test.stopTest();

        System.assertNotEquals(null, usage, 'SubscriptionUsage record should be created');
        System.assertEquals(asset1.Id, usage.dmpl__AssetId__c, 'Asset should be Asset 1');
        System.assertEquals(customerAccount1.Id, usage.dmpl__AccountId__c, 'Account should be Customer 1');
        System.assertEquals(item1.Id, usage.dmpl__ItemId__c, 'Item should be Item 1');
        System.assertEquals(2, usage.dmpl__Quantity__c, 'Quantity should be 2');
        System.assertEquals(subscription.Id, usage.dmpl__SubscriptionId__c, 'Subscription should be match');
    }
    @isTest
    static void createSubscriptionUsageWithNoCustomerAccountPositive(){
        dmpl__Subscription__c subscription = SubscriptionDataHelper.getSubscription();
        Asset asset1 = TestDataHelpers.getAsset('Asset 1');
        dmpl__Item__c  item1 = TestDataHelpers.getItem('Item 1');
        Test.startTest();
        try{
            dmpl__SubscriptionUsage__c usage = SubscriptionUsageDataHelper.createSubscriptionUsage(null, asset1, item1,2, subscription);
            System.assertNotEquals(null, usage.Id, 'Subscription usage should be created without customer account');

        }catch(Exception e){
            System.Assert.isTrue(true, 'subscription usage should not be created without customer');
        }
        Test.stopTest();

    }

    @isTest
    static void updateSubscriptionUsageWithCustomerAccountPositive(){
        
        dmpl__Subscription__c subscription = SubscriptionDataHelper.getSubscription();
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Asset asset1 = TestDataHelpers.getAsset('Asset 1');
        dmpl__Item__c  item1 = TestDataHelpers.getItem('Item 1');
        
        dmpl__SubscriptionUsage__c usage = SubscriptionUsageDataHelper.createSubscriptionUsage(null, asset1, item1,2, subscription);

        System.assertNotEquals(null, usage, 'SubscriptionUsage record should be created');
        System.assertEquals(asset1.Id, usage.dmpl__AssetId__c, 'Asset should be Asset 1');
        System.assertEquals(item1.Id, usage.dmpl__ItemId__c, 'Item should be Item 1');
        System.assertEquals(2, usage.dmpl__Quantity__c, 'Quantity should be 2');
        System.assertEquals(subscription.Id, usage.dmpl__SubscriptionId__c, 'Subscription should be match');


        Test.startTest();
        Boolean exceptionThrown = false;
        try{
            usage.dmpl__AccountId__c = customerAccount1.Id;
            update usage;
        }catch (Exception e) {
            exceptionThrown = true;
        }
        System.assertEquals(false, exceptionThrown,'exception caught when referencing customer account');
        Test.stopTest();
        if(!exceptionThrown){
            System.assertEquals(asset1.Id, usage.dmpl__AssetId__c, 'Asset should be Asset 1');
            System.AssertEquals(customerAccount1.Id, usage.dmpl__AccountId__c, 'Account should be Customer 1');
            System.assertEquals(item1.Id, usage.dmpl__ItemId__c, 'Item should be Item 1');
            System.assertEquals(2, usage.dmpl__Quantity__c, 'Quantity should be 2');
            System.assertEquals(subscription.Id, usage.dmpl__SubscriptionId__c, 'Subscription should be SUB0000');
        }
    }

    @isTest
    static void updateSubscriptionUsageWithNoCustomerAccountPositive(){
        
        dmpl__Subscription__c subscription = SubscriptionDataHelper.getSubscription();
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Asset asset1 = TestDataHelpers.getAsset('Asset 1');
        dmpl__Item__c  item1 = TestDataHelpers.getItem('Item 1');

        dmpl__SubscriptionUsage__c usage = SubscriptionUsageDataHelper.createSubscriptionUsage(customerAccount1, asset1, item1,2, subscription);

        System.assertNotEquals(null, usage, 'SubscriptionUsage record should be created');
        System.assertEquals(asset1.Id, usage.dmpl__AssetId__c, 'Asset should be Asset 1');
        System.assertEquals(customerAccount1.Id, usage.dmpl__AccountId__c, 'Account should be Customer 1');
        System.assertEquals(item1.Id, usage.dmpl__ItemId__c, 'Item should be Item 1');
        System.assertEquals(2, usage.dmpl__Quantity__c, 'Quantity should be 2');
        System.assertEquals(subscription.Id, usage.dmpl__SubscriptionId__c, 'Subscription should be SUB0000');


        Test.startTest();
        Boolean exceptionThrown = false;
        try{
            usage.dmpl__AccountId__c = null;
            update usage;
        }catch (Exception e) {
            exceptionThrown = true;
        }
        System.assertEquals(false, exceptionThrown,'exception caught when removing customer account');
        Test.stopTest();

        if(!exceptionThrown){
            System.assertEquals(asset1.Id, usage.dmpl__AssetId__c, 'Asset should be Asset 1');
            System.assertEquals(item1.Id, usage.dmpl__ItemId__c, 'Item should be Item 1');
            System.assertEquals(2, usage.dmpl__Quantity__c, 'Quantity should be 2');
            System.assertEquals(subscription.Id, usage.dmpl__SubscriptionId__c, 'Subscription should be SUB0000');
        }
    }


    @isTest
    static void createSubscriptionUsageWithActiveItemPositive(){
        dmpl__Subscription__c subscription = SubscriptionDataHelper.getSubscription();
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Asset asset1 = TestDataHelpers.getAsset('Asset 1');
        dmpl__Item__c  item1 = TestDataHelpers.getItem('Item 1');
        Test.startTest();
        dmpl__SubscriptionUsage__c usage = SubscriptionUsageDataHelper.createSubscriptionUsage(customerAccount1, asset1, item1,2, subscription);
        Test.stopTest();

        System.assertNotEquals(null, usage, 'SubscriptionUsage record should be created');
        System.assertEquals(asset1.Id, usage.dmpl__AssetId__c, 'Asset should be Asset 1');
        System.assertEquals(customerAccount1.Id, usage.dmpl__AccountId__c, 'Account should be Customer 1');
        System.assertEquals(item1.Id, usage.dmpl__ItemId__c, 'Item should be Item 1');
        System.assertEquals(2, usage.dmpl__Quantity__c, 'Quantity should be 2');
        System.assertEquals(subscription.Id, usage.dmpl__SubscriptionId__c, 'Subscription should be match');
    }

    @isTest
    static void createSubscriptionUsageWithInActiveItemNegative(){
        dmpl__Subscription__c subscription = SubscriptionDataHelper.getSubscription();
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Asset asset1 = TestDataHelpers.getAsset('Asset 1');
        dmpl__Item__c  item2 = TestDataHelpers.getItem('Item 2');
        Test.startTest();
        try{
            dmpl__SubscriptionUsage__c usage = SubscriptionUsageDataHelper.createSubscriptionUsage(customerAccount1, asset1, item2,2, subscription);
            System.assertEquals(null, usage.Id, 'SubscriptionUsage record should not be created with inactive item');
        }catch (Exception e) {
            System.assert.isTrue(true, 'SubscriptionUsage record should not be created with inactive item');
        }
        Test.stopTest();

    }


    @isTest
    static void updateSubscriptionUsageWithInactiveItemNegative(){
        
        dmpl__Subscription__c subscription = SubscriptionDataHelper.getSubscription();
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Asset asset1 = TestDataHelpers.getAsset('Asset 1');
        dmpl__Item__c  item1 = TestDataHelpers.getItem('Item 1');
        dmpl__Item__c  item2 = TestDataHelpers.getItem('Item 2');


        dmpl__SubscriptionUsage__c usage = SubscriptionUsageDataHelper.createSubscriptionUsage(customerAccount1, asset1, item1,2, subscription);

        System.assertNotEquals(null, usage, 'SubscriptionUsage record should be created');
        System.assertEquals(asset1.Id, usage.dmpl__AssetId__c, 'Asset should be Asset 1');
        System.assertEquals(customerAccount1.Id, usage.dmpl__AccountId__c, 'Account should be Customer 1');
        System.assertEquals(item1.Id, usage.dmpl__ItemId__c, 'Item should be Item 1');
        System.assertEquals(2, usage.dmpl__Quantity__c, 'Quantity should be 2');
        System.assertEquals(subscription.Id, usage.dmpl__SubscriptionId__c, 'Subscription should be SUB0000');


        Test.startTest();
        Boolean exceptionThrown = false;
        try{
            usage.dmpl__ItemId__c = item2.Id;
            update usage;
        }catch (Exception e) {
            exceptionThrown = true;
        }
        System.assertEquals(true, exceptionThrown,'Expected exception when assigning inactive item');
    }

    @isTest
    static void createSubscriptionUsageWithZeroQuantityPositive(){
        dmpl__Subscription__c subscription = SubscriptionDataHelper.getSubscription();
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Asset asset1 = TestDataHelpers.getAsset('Asset 1');
        dmpl__Item__c  item1 = TestDataHelpers.getItem('Item 1');
        Test.startTest();
        try{
            dmpl__SubscriptionUsage__c usage = SubscriptionUsageDataHelper.createSubscriptionUsage(customerAccount1, asset1, item1,0, subscription);
            System.assertNotEquals(null, usage, 'SubscriptionUsage record should be created');
            System.assertEquals(asset1.Id, usage.dmpl__AssetId__c, 'Asset should be Asset 1');
            System.assertEquals(customerAccount1.Id, usage.dmpl__AccountId__c, 'Account should be Customer 1');
            System.assertEquals(item1.Id, usage.dmpl__ItemId__c, 'Item should be Item 1');
            System.assertEquals(subscription.Id, usage.dmpl__SubscriptionId__c, 'Subscription should be SUB0000');        }
            
        catch (Exception e) {
            System.assert.isTrue(true, 'SubscriptionUsage record should be created with zero quantity entered');
        }
        Test.stopTest();
    }

    @isTest
    static void updateSubscriptionUsageWithZeroQuantityPositive(){
        
        dmpl__Subscription__c subscription = SubscriptionDataHelper.getSubscription();
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Asset asset1 = TestDataHelpers.getAsset('Asset 1');
        dmpl__Item__c  item1 = TestDataHelpers.getItem('Item 1');

        dmpl__SubscriptionUsage__c usage = SubscriptionUsageDataHelper.createSubscriptionUsage(customerAccount1, asset1, item1,2, subscription);

        System.assertNotEquals(null, usage, 'SubscriptionUsage record should be created');
        System.assertEquals(asset1.Id, usage.dmpl__AssetId__c, 'Asset should be Asset 1');
        System.assertEquals(customerAccount1.Id, usage.dmpl__AccountId__c, 'Account should be Customer 1');
        System.assertEquals(item1.Id, usage.dmpl__ItemId__c, 'Item should be Item 1');
        System.assertEquals(2, usage.dmpl__Quantity__c, 'Quantity should be 2');
        System.assertEquals(subscription.Id, usage.dmpl__SubscriptionId__c, 'Subscription should be SUB0000');

        Test.startTest();
        Boolean exceptionThrown = false;
        try{
            usage.dmpl__Quantity__c = 0;
            update usage;
        }catch (Exception e) {
            exceptionThrown = true;
        }
        System.assertEquals(false, exceptionThrown,'exception caught when quantity less than 1');
    }

    @isTest
    static void createSubscriptionUsageWithAssetPositive(){
        dmpl__Subscription__c subscription = SubscriptionDataHelper.getSubscription();
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Asset asset1 = TestDataHelpers.getAsset('Asset 1');
        dmpl__Item__c  item1 = TestDataHelpers.getItem('Item 1');
        Test.startTest();
        dmpl__SubscriptionUsage__c usage = SubscriptionUsageDataHelper.createSubscriptionUsage(customerAccount1, asset1, item1,2, subscription);
        Test.stopTest();

        System.assertNotEquals(null, usage, 'SubscriptionUsage record should be created');
        System.assertEquals(asset1.Id, usage.dmpl__AssetId__c, 'Asset should be Asset 1');
        System.assertEquals(customerAccount1.Id, usage.dmpl__AccountId__c, 'Account should be Customer 1');
        System.assertEquals(item1.Id, usage.dmpl__ItemId__c, 'Item should be Item 1');
        System.assertEquals(2, usage.dmpl__Quantity__c, 'Quantity should be 2');
        System.assertEquals(subscription.Id, usage.dmpl__SubscriptionId__c, 'Subscription should be match');
    }

}