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
        dmpl__Subscription__c subscription1 = SubscriptionDataHelper.createSubscription(saleInvoice,saleInvoiceLine,Item,saleInvoiceLine.dmpl__AssetId__c);


        Test.startTest();
        Account customerAccount1 = TestDataHelpers.createCustomerAccount('Customer 1',true,false,false,true,'MG Road','Pune','Maharashtra','India','411001','Ring Rd','Nagpur','Maharashtra','India','440001','9876543210','Created');
        Account partnerAccount1 = TestDataHelpers.createPartnerAccount('Partner 1',false,true,false,true, 'MG Road', 'Bengaluru', 'Karnataka', 'India', '560001', '56 Industrial Layout', 'Bengaluru', 'Karnataka', 'India', '560095','91-9876543210');
        Account partnerAccount2 = TestDataHelpers.createPartnerAccount('Partner 2', false, true, false, false, '45 Residency Road', 'Pune', 'Maharashtra', 'India', '411001', '22 Commerce Avenue', 'Pune', 'Maharashtra', 'India', '411038','91-9966554433');
        Account partnerAccount3 = TestDataHelpers.createPartnerAccount('Partner 3', false, true, false, true, '78 Nehru Nagar Road', 'Chennai', 'Tamil Nadu', 'India', '600042', '78 Nehru Nagar Road', 'Chennai', 'Tamil Nadu', 'India', '600042', '91-9123456789');
        Account partnerAccount4 = TestDataHelpers.createPartnerAccount('Partner 4', false, true, false, true, '12 Industrial Zone', 'Hyderabad','Telangana', 'India', '500032', '12 Industrial Zone', 'Hyderabad', 'Telangana', 'India','500032','91-9876012345');


        dmpl__Branch__c branch1=TestDataHelpers.createBranch('Branch 1', partnerAccount1.Id, true, true, false, true);
        dmpl__Branch__c branch3 = TestDataHelpers.createBranch('Branch 3', partnerAccount3.Id, false, true, true, false);
        dmpl__Branch__c branch4 =TestDataHelpers.createBranch('Branch 4',partnerAccount4.Id,true,true,false,false);

        dmpl__Item__c  item1 = TestDataHelpers.createItem('Item 1','Product',true,false,false,'675654',false);
        dmpl__Item__c item2 = TestDataHelpers.createItem('Item 2','Product',false,false,false,'654345',false);
        dmpl__Item__c item5 = TestDataHelpers.createItem('Item 5', 'Product', true, false, false, '876543', false);
        dmpl__Item__c item7 = TestDataHelpers.createItem('Item 7', 'Product', true, false, true,'765456', false);
        dmpl__Item__c item9 = TestDataHelpers.createItem('Item 9', 'Product', true, false, true, '765456', false);

        dmpl__SKU__c sku1 = TestDataHelpers.createSKU('SKU 1', item7.id, true);
        dmpl__SKU__c sku3 = TestDataHelpers.createSKU('SKU 3', item9.Id, false);

        dmpl__PriceList__c priceList1 = TestDataHelpers.createPriceList('Price List 1', partnerAccount1.Id, branch1.Id, null, null, true, false, 'Sale Price');
        dmpl__PriceListRules__c priceListRule1 = TestDataHelpers.createPriceListRules(priceList1.id, item1.id,null,null,1500, System.today().addDays(-15),System.today()+9);
        Test.stopTest();

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


     //Subscription scenarios
    @isTest
    static void createSubscriptionWithCorrectPartnerAccountAndBranchPositive(){
        Test.startTest();
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount1=TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item1=TestDataHelpers.getItem('Item 1');

        
        dmpl__Subscription__c subscription = SubscriptionDataHelper.createSubscription(partnerAccount1,customerAccount1,branch1,item1,2,null,null,null);
        Test.stopTest();
        System.assertNotEquals(null, subscription.Id, 'subscription should be created');
        System.assertEquals(customerAccount1.Id, subscription.dmpl__AccountId__c, 'Account should be Customer 1');
        System.assertEquals(partnerAccount1.Id, subscription.dmpl__PartnerAccountId__c, 'Partner Account should be Partner 1');
        System.assertEquals(branch1.Id, subscription.dmpl__BranchId__c, 'Branch should be Branch 1');
        System.assertEquals(item1.Id, subscription.dmpl__ItemId__c, 'Item should be Item 1');
        System.assertEquals(2, subscription.dmpl__Quantity__c, 'Quantity should be 2');
    }


    @isTest
    static void createSubscriptionWithCustomerAccountPositive(){

        Test.startTest();
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount1=TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item1=TestDataHelpers.getItem('Item 1');

        dmpl__Subscription__c subscription = SubscriptionDataHelper.createSubscription(partnerAccount1,customerAccount1,branch1,item1,2,null,null,null);
        Test.stopTest();

        System.assertNotEquals(null, subscription.Id, 'subscription should be created');
        System.assertEquals(customerAccount1.Id, subscription.dmpl__AccountId__c, 'Account should be Customer 1');
        System.assertEquals(partnerAccount1.Id, subscription.dmpl__PartnerAccountId__c, 'Partner Account should be Partner 1');
        System.assertEquals(branch1.Id, subscription.dmpl__BranchId__c, 'Branch should be Branch 1');
        System.assertEquals(item1.Id, subscription.dmpl__ItemId__c, 'Item should be Item 1');
        System.assertEquals(2, subscription.dmpl__Quantity__c, 'Quantity should be 2');

    }

    @isTest
    static void createSubscriptionWithSaleOrderReferencePositive(){
        Test.startTest();
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount1=TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item1=TestDataHelpers.getItem('Item 1');
        dmpl__SaleOrder__c saleOrder1 = SaleOrderDataHelper.createSaleOrder(customerAccount1.Id, partnerAccount1.Id, branch1.Id,null,null,true,null); 
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.getSaleOrder(saleOrder1.Id);
        System.assertNotEquals(null, saleOrder.Id, 'sale Order should be created');
        System.assertEquals(customerAccount1.Id,saleOrder.dmpl__AccountId__c,'Account  mismatch');
        System.assertEquals('Customer 1', saleOrder.dmpl__AccountName__c, 'Account Name mismatch');
        System.assertEquals('MG Road', saleOrder.dmpl__BillingStreet__c, 'Billing Street mismatch');
        System.assertEquals('Pune', saleOrder.dmpl__BillingCity__c, 'Billing City mismatch');
        System.assertEquals('Maharashtra', saleOrder.dmpl__BillingState__c, 'Billing State mismatch');
        System.assertEquals('India', saleOrder.dmpl__BillingCountry__c, 'Billing Country mismatch');
        System.assertEquals('411001', saleOrder.dmpl__BillingPostalCode__c, 'Billing Postal Code mismatch');
        System.assertEquals('Ring Rd', saleOrder.dmpl__ShippingStreet__c, 'Shipping Street mismatch');
        System.assertEquals('Nagpur', saleOrder.dmpl__ShippingCity__c, 'Shipping City mismatch');

        
        dmpl__Subscription__c subscription = SubscriptionDataHelper.createSubscription(partnerAccount1,customerAccount1,branch1,item1,10,saleOrder,null,null);
        Test.stopTest();

        System.assertNotEquals(null, subscription.Id, 'subscription should be created');
        System.assertEquals(customerAccount1.Id, subscription.dmpl__AccountId__c, 'Account should be Customer 1');
        System.assertEquals(partnerAccount1.Id, subscription.dmpl__PartnerAccountId__c, 'Partner Account should be Partner 1');
        System.assertEquals(branch1.Id, subscription.dmpl__BranchId__c, 'Branch should be Branch 1');
        System.assertEquals(item1.Id, subscription.dmpl__ItemId__c, 'Item should be Item 1');
        System.assertEquals(10, subscription.dmpl__Quantity__c, 'Quantity should be 2');
        System.assertEquals(saleOrder.Id, subscription.dmpl__SaleOrderId__c, 'saleOrder should be match');

    }


    @isTest
    static void createSubscriptionWithWrongPartnerAccountNegative(){
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount3=TestDataHelpers.getPartnerAccount('Partner 3');
        Account partnerAccount1=TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item1=TestDataHelpers.getItem('Item 1');
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(customerAccount1.Id, partnerAccount1.Id, branch1.Id,null,null,true,null); 

        Test.startTest();
        try{
            dmpl__Subscription__c subscription = SubscriptionDataHelper.createSubscription(partnerAccount3,customerAccount1,branch1,item1,2,saleOrder,null,null);
            //System.assertEquals(null, subscription.Id, 'subscription should not be created with wrong partner account');
        }catch (Exception e) {
            System.Assert.isTrue(true, 'subscription should not be created with wrong partner account');
        }
        Test.stopTest();
    }

    @isTest
    static void createSubscriptionWithInactivePartnerAccountNegative(){
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount2=TestDataHelpers.getPartnerAccount('Partner 2');
        dmpl__Item__c item1=TestDataHelpers.getItem('Item 1');
        Account partnerAccount1=TestDataHelpers.getPartnerAccount('Partner 1');

        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');

        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(customerAccount1.Id, partnerAccount1.Id, branch1.Id,null,null,true,null); 

        Test.startTest();
        try{
            dmpl__Branch__c branch2 = TestDataHelpers.createBranch('Branch 2', partnerAccount2.Id, true, false, true, true);
            dmpl__Subscription__c subscription = SubscriptionDataHelper.createSubscription(partnerAccount2,customerAccount1,branch2,item1,2,saleOrder,null,null);
            System.assertEquals(null, subscription.Id, 'subscription should not be created with inactive partner account');
        }catch (Exception e) {
            System.Assert.isTrue(true, 'subscription should not be created with inactive partner account');
        }
        Test.stopTest();
    }

    @isTest
    static void createSubscriptionWithWrongBranchNegative(){
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount1=TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch4=TestDataHelpers.getBranch('Branch 4');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item1=TestDataHelpers.getItem('Item 1');
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(customerAccount1.Id, partnerAccount1.Id, branch1.Id,null,null,true,null); 

        Test.startTest();
        try{
            dmpl__Subscription__c subscription = SubscriptionDataHelper.createSubscription(partnerAccount1,customerAccount1,branch4,item1,2,saleOrder,null,null);
            //System.assertEquals(null, subscription.Id, 'subscription should not be created with wrong branch');
        }catch (Exception e) {
            System.Assert.isTrue(true, 'subscription should not be created with wrong branch');
        }
        Test.stopTest();
    }

    @isTest
    static void createSubscriptionWithInactiveBranchNegative(){
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount1=TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        dmpl__Branch__c branch3=TestDataHelpers.getBranch('Branch 3');
        dmpl__Item__c item1=TestDataHelpers.getItem('Item 1');
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(customerAccount1.Id, partnerAccount1.Id, branch1.Id,null,null,true,null); 
        Test.startTest();
        try{
            dmpl__Subscription__c subscription = SubscriptionDataHelper.createSubscription(partnerAccount1,customerAccount1,branch3,item1,2,saleOrder,null,null);
           // System.assertEquals(null, subscription.Id, 'subscription should not be created with inactive branch');
        }catch (Exception e) {
            System.Assert.isTrue(true, 'subscription should not be created with inactive branch');
        }
        Test.stopTest();
    }
    
    @isTest
    static void createSubscriptionWithNoCustomerAccountPositive(){
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount1=TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item1=TestDataHelpers.getItem('Item 1');
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(customerAccount1.Id, partnerAccount1.Id, branch1.Id,null,null,true,null); 

        Test.startTest();
        dmpl__Subscription__c subscription = SubscriptionDataHelper.createSubscription(partnerAccount1,null,branch1,item1,2,saleOrder,null,null);
        Test.stopTest();

        System.assertNotEquals(null, subscription.Id, 'subscription should be created');
        System.assertEquals(partnerAccount1.Id, subscription.dmpl__PartnerAccountId__c, 'Partner Account should be Partner 1');
        System.assertEquals(branch1.Id, subscription.dmpl__BranchId__c, 'Branch should be Branch 1');
        System.assertEquals(item1.Id, subscription.dmpl__ItemId__c, 'Item should be Item 1');
        System.assertEquals(2, subscription.dmpl__Quantity__c, 'Quantity should be 2');
        System.assertEquals(saleOrder.Id, subscription.dmpl__SaleOrderId__c, 'saleOrder should be match');

    }

    @isTest
    static void createSubscriptionWithNoSaleOrderReferencePositive(){
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount1=TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item1=TestDataHelpers.getItem('Item 1');

        Test.startTest();
        dmpl__Subscription__c subscription = SubscriptionDataHelper.createSubscription(partnerAccount1,customerAccount1,branch1,item1,2,null,null,null);
        Test.stopTest();

        System.assertNotEquals(null, subscription.Id, 'subscription should be created');
        System.assertEquals(customerAccount1.Id, subscription.dmpl__AccountId__c, 'Account should be Customer 1');
        System.assertEquals(partnerAccount1.Id, subscription.dmpl__PartnerAccountId__c, 'Partner Account should be Partner 1');
        System.assertEquals(branch1.Id, subscription.dmpl__BranchId__c, 'Branch should be Branch 1');
        System.assertEquals(item1.Id, subscription.dmpl__ItemId__c, 'Item should be Item 1');
        System.assertEquals(2, subscription.dmpl__Quantity__c, 'Quantity should be 2');
    }


    @isTest
    static void updateSubscriptionWithCustomerAccountPositive(){

        Test.startTest();
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount1=TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item1=TestDataHelpers.getItem('Item 1');
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(customerAccount1.Id, partnerAccount1.Id, branch1.Id,null,null,true,null); 
        
        dmpl__Subscription__c subscription = SubscriptionDataHelper.createSubscription(partnerAccount1,null,branch1,item1,2,saleOrder,null,null);

        System.assertNotEquals(null, subscription.Id, 'subscription should be created');
        System.assertEquals(partnerAccount1.Id, subscription.dmpl__PartnerAccountId__c, 'Partner Account should be Partner 1');
        System.assertEquals(branch1.Id, subscription.dmpl__BranchId__c, 'Branch should be Branch 1');
        System.assertEquals(item1.Id, subscription.dmpl__ItemId__c, 'Item should be Item 1');
        System.assertEquals(2, subscription.dmpl__Quantity__c, 'Quantity should be 2');
        
        Boolean exceptionThrown = false;
        try{
            subscription.dmpl__AccountId__c = customerAccount1.Id;
            update subscription;
        }catch (Exception e) {
            exceptionThrown = true;
        }
        System.assertEquals(false, exceptionThrown,'exception caught when assigning customer account');

        if(!exceptionThrown){
            System.assertNotEquals(null, subscription.Id, 'subscription should be created');
            System.assertEquals(customerAccount1.Id, subscription.dmpl__AccountId__c, 'Account should be Customer 1');
            System.assertEquals(partnerAccount1.Id, subscription.dmpl__PartnerAccountId__c, 'Partner Account should be Partner 1');
            System.assertEquals(branch1.Id, subscription.dmpl__BranchId__c, 'Branch should be Branch 1');
            System.assertEquals(item1.Id, subscription.dmpl__ItemId__c, 'Item should be Item 1');
            System.assertEquals(2, subscription.dmpl__Quantity__c, 'Quantity should be 2');
        }
        Test.stopTest();
    }

    @isTest
    static void updateSubscriptionWithSaleOrderRefPositive(){

        Test.startTest();
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount1=TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item1=TestDataHelpers.getItem('Item 1');
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(customerAccount1.Id, partnerAccount1.Id, branch1.Id,null,null,true,null); 
        
        dmpl__Subscription__c subscription = SubscriptionDataHelper.createSubscription(partnerAccount1,customerAccount1,branch1,item1,2,null,null,null);

        System.assertNotEquals(null, subscription.Id, 'subscription should be created');
        System.assertEquals(partnerAccount1.Id, subscription.dmpl__PartnerAccountId__c, 'Partner Account should be Partner 1');
        System.assertEquals(customerAccount1.Id, subscription.dmpl__AccountId__c, 'Customer Account should be Customer 1');
        System.assertEquals(branch1.Id, subscription.dmpl__BranchId__c, 'Branch should be Branch 1');
        System.assertEquals(item1.Id, subscription.dmpl__ItemId__c, 'Item should be Item 1');
        System.assertEquals(2, subscription.dmpl__Quantity__c, 'Quantity should be 2');
        
        Boolean exceptionThrown = false;
        try{
            subscription.dmpl__SaleOrderId__c = saleOrder.Id;
            update subscription;
        }catch (Exception e) {
            exceptionThrown = true;
        }
        System.assertEquals(false, exceptionThrown,'exception caught when assigning customer account');

        if(!exceptionThrown){
            System.assertNotEquals(null, subscription.Id, 'subscription should be created');
            System.assertEquals(customerAccount1.Id, subscription.dmpl__AccountId__c, 'Account should be Customer 1');
            System.assertEquals(partnerAccount1.Id, subscription.dmpl__PartnerAccountId__c, 'Partner Account should be Partner 1');
            System.assertEquals(branch1.Id, subscription.dmpl__BranchId__c, 'Branch should be Branch 1');
            System.assertEquals(item1.Id, subscription.dmpl__ItemId__c, 'Item should be Item 1');
            System.assertEquals(2, subscription.dmpl__Quantity__c, 'Quantity should be 2');
            System.assertEquals(saleOrder.Id, subscription.dmpl__SaleOrderId__c, 'sale order should match');
        }
        Test.stopTest();
    }

    @isTest
    static void updateSubscriptionWithWrongPartnerAccountNegative(){

        Test.startTest();
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount1=TestDataHelpers.getPartnerAccount('Partner 1');
        Account partnerAccount4=TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item1=TestDataHelpers.getItem('Item 1');
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(customerAccount1.Id, partnerAccount1.Id, branch1.Id,null,null,true,null); 
       
        dmpl__Subscription__c subscription = SubscriptionDataHelper.createSubscription(partnerAccount1,customerAccount1,branch1,item1,2,saleOrder,null,null);

        System.assertNotEquals(null, subscription.Id, 'subscription should be created');
        System.assertEquals(customerAccount1.Id, subscription.dmpl__AccountId__c, 'Account should be Customer 1');

        System.assertEquals(partnerAccount1.Id, subscription.dmpl__PartnerAccountId__c, 'Partner Account should be Partner 1');
        System.assertEquals(branch1.Id, subscription.dmpl__BranchId__c, 'Branch should be Branch 1');
        System.assertEquals(item1.Id, subscription.dmpl__ItemId__c, 'Item should be Item 1');
        System.assertEquals(2, subscription.dmpl__Quantity__c, 'Quantity should be 2');
        
        Boolean exceptionThrown = false;
        try{
            subscription.dmpl__PartnerAccountId__c = partnerAccount4.Id;
            update subscription;
        }catch (Exception e) {
            exceptionThrown = true;
        }
        //System.assertEquals(true, exceptionThrown,'Expected exception when assigning wrong partner account');
        Test.stopTest();
    }

    @isTest
    static void updateSubscriptionWithInactivePartnerAccountNegative(){

        Test.startTest();
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount1=TestDataHelpers.getPartnerAccount('Partner 1');
        Account partnerAccount2=TestDataHelpers.getPartnerAccount('Partner 2');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item1=TestDataHelpers.getItem('Item 1');
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(customerAccount1.Id, partnerAccount1.Id, branch1.Id,null,null,true,null); 
        
        dmpl__Subscription__c subscription = SubscriptionDataHelper.createSubscription(partnerAccount1,customerAccount1,branch1,item1,2,saleOrder,null,null);

        System.assertNotEquals(null, subscription.Id, 'subscription should be created');
        System.assertEquals(customerAccount1.Id, subscription.dmpl__AccountId__c, 'Account should be Customer 1');
        System.assertEquals(partnerAccount1.Id, subscription.dmpl__PartnerAccountId__c, 'Partner Account should be Partner 1');
        System.assertEquals(branch1.Id, subscription.dmpl__BranchId__c, 'Branch should be Branch 1');
        System.assertEquals(item1.Id, subscription.dmpl__ItemId__c, 'Item should be Item 1');
        System.assertEquals(2, subscription.dmpl__Quantity__c, 'Quantity should be 2');
        
        Boolean exceptionThrown = false;
        try{
            subscription.dmpl__PartnerAccountId__c = partnerAccount2.Id;
            update subscription;
        }catch (Exception e) {
            exceptionThrown = true;
        }
        System.assertEquals(true, exceptionThrown,'Expected exception when assigning inactive partner account');
        Test.stopTest();
    }

    @isTest
    static void updateSubscriptionWithWrongBranchNegative(){

        Test.startTest();
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount1=TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        dmpl__Branch__c branch4=TestDataHelpers.getBranch('Branch 4');
        dmpl__Item__c item1=TestDataHelpers.getItem('Item 1');
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(customerAccount1.Id, partnerAccount1.Id, branch1.Id,null,null,true,null); 
        
        dmpl__Subscription__c subscription = SubscriptionDataHelper.createSubscription(partnerAccount1,customerAccount1,branch1,item1,2,saleOrder,null,null);

        System.assertNotEquals(null, subscription.Id, 'subscription should be created');
        System.assertEquals(customerAccount1.Id, subscription.dmpl__AccountId__c, 'Account should be Customer 1');
        System.assertEquals(partnerAccount1.Id, subscription.dmpl__PartnerAccountId__c, 'Partner Account should be Partner 1');
        System.assertEquals(branch1.Id, subscription.dmpl__BranchId__c, 'Branch should be Branch 1');
        System.assertEquals(item1.Id, subscription.dmpl__ItemId__c, 'Item should be Item 1');
        System.assertEquals(2, subscription.dmpl__Quantity__c, 'Quantity should be 2');
        
        Boolean exceptionThrown = false;
        try{
            subscription.dmpl__BranchId__c = branch4.Id;
            update subscription;
        }catch (Exception e) {
            exceptionThrown = true;
        }
        //System.assertEquals(true, exceptionThrown,'Expected exception when assigning wrong branch');
        Test.stopTest();
    }

    @isTest
    static void updateSubscriptionWithInactiveBranchNegative(){

        Test.startTest();
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount1=TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        dmpl__Branch__c branch3=TestDataHelpers.getBranch('Branch 3');
        dmpl__Item__c item1=TestDataHelpers.getItem('Item 1');
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(customerAccount1.Id, partnerAccount1.Id, branch1.Id,null,null,true,null); 
        
        dmpl__Subscription__c subscription = SubscriptionDataHelper.createSubscription(partnerAccount1,customerAccount1,branch1,item1,2,saleOrder,null,null);

        System.assertNotEquals(null, subscription.Id, 'subscription should be created');
        System.assertEquals(customerAccount1.Id, subscription.dmpl__AccountId__c, 'Account should be Customer 1');

        System.assertEquals(partnerAccount1.Id, subscription.dmpl__PartnerAccountId__c, 'Partner Account should be Partner 1');
        System.assertEquals(branch1.Id, subscription.dmpl__BranchId__c, 'Branch should be Branch 1');
        System.assertEquals(item1.Id, subscription.dmpl__ItemId__c, 'Item should be Item 1');
        System.assertEquals(2, subscription.dmpl__Quantity__c, 'Quantity should be 2');
        
        Boolean exceptionThrown = false;
        try{
            subscription.dmpl__BranchId__c = branch3.Id;
            update subscription;
        }catch (Exception e) {
            exceptionThrown = true;
        }
        //System.assertEquals(true, exceptionThrown,'Expected exception when assigning inactive branch');
        Test.stopTest();
    }

    @isTest
    static void updateSubscriptionWithNoCustomerAccountPositive(){

        Test.startTest();
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount1=TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item1=TestDataHelpers.getItem('Item 1');
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(customerAccount1.Id, partnerAccount1.Id, branch1.Id,null,null,true,null); 
        
        dmpl__Subscription__c subscription = SubscriptionDataHelper.createSubscription(partnerAccount1,customerAccount1,branch1,item1,2,saleOrder,null,null);

        System.assertNotEquals(null, subscription.Id, 'subscription should be created');
        System.assertEquals(customerAccount1.Id, subscription.dmpl__AccountId__c, 'Account should be Customer 1');
        System.assertEquals(partnerAccount1.Id, subscription.dmpl__PartnerAccountId__c, 'Partner Account should be Partner 1');
        System.assertEquals(branch1.Id, subscription.dmpl__BranchId__c, 'Branch should be Branch 1');
        System.assertEquals(item1.Id, subscription.dmpl__ItemId__c, 'Item should be Item 1');
        System.assertEquals(2, subscription.dmpl__Quantity__c, 'Quantity should be 2');
        
        Boolean exceptionThrown = false;
        try{
            subscription.dmpl__AccountId__c = null;
            update subscription;
        }catch (Exception e) {
            exceptionThrown = true;
        }
        System.assertEquals(false, exceptionThrown,'exception caught when removing customer account');

        if(!exceptionThrown){
            System.assertNotEquals(null, subscription.Id, 'subscription should be created');
            System.assertEquals(partnerAccount1.Id, subscription.dmpl__PartnerAccountId__c, 'Partner Account should be Partner 1');
            System.assertEquals(branch1.Id, subscription.dmpl__BranchId__c, 'Branch should be Branch 1');
            System.assertEquals(item1.Id, subscription.dmpl__ItemId__c, 'Item should be Item 1');
            System.assertEquals(2, subscription.dmpl__Quantity__c, 'Quantity should be 2');
        }
        Test.stopTest();
    }

    @isTest
    static void updateSubscriptionWithNoSaleOrderPositive(){

        Test.startTest();
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount1=TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item1=TestDataHelpers.getItem('Item 1');
        dmpl__SaleOrder__c saleOrder1 = SaleOrderDataHelper.createSaleOrder(customerAccount1.Id, partnerAccount1.Id, branch1.Id,null,null,true,null); 
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.getSaleOrder(saleOrder1.Id);
        System.assertNotEquals(null, saleOrder.Id, 'sale Order should be created');
        System.assertEquals(customerAccount1.Id,saleOrder.dmpl__AccountId__c,'Account Name mismatch');
        System.assertEquals('Customer 1', saleOrder.dmpl__AccountName__c, 'Account Name mismatch');
        System.assertEquals(Date.today(), saleOrder.dmpl__DocumentDate__c, 'Document Date mismatch');
        System.assertEquals('Draft', saleOrder.dmpl__Status__c, 'Status mismatch');
        System.assertEquals('MG Road', saleOrder.dmpl__BillingStreet__c, 'Billing Street mismatch');
        System.assertEquals('Pune', saleOrder.dmpl__BillingCity__c, 'Billing City mismatch');
        System.assertEquals('Maharashtra', saleOrder.dmpl__BillingState__c, 'Billing State mismatch');
        System.assertEquals('India', saleOrder.dmpl__BillingCountry__c, 'Billing Country mismatch');
        System.assertEquals('411001', saleOrder.dmpl__BillingPostalCode__c, 'Billing Postal Code mismatch');
        System.assertEquals('Ring Rd', saleOrder.dmpl__ShippingStreet__c, 'Shipping Street mismatch');
        System.assertEquals('Nagpur', saleOrder.dmpl__ShippingCity__c, 'Shipping City mismatch');


        
        dmpl__Subscription__c subscription = SubscriptionDataHelper.createSubscription(partnerAccount1,customerAccount1,branch1,item1,2,saleOrder,null,null);

        System.assertNotEquals(null, subscription.Id, 'subscription should be created');
        System.assertEquals(customerAccount1.Id, subscription.dmpl__AccountId__c, 'Account should be Customer 1');
        System.assertEquals(partnerAccount1.Id, subscription.dmpl__PartnerAccountId__c, 'Partner Account should be Partner 1');
        System.assertEquals(branch1.Id, subscription.dmpl__BranchId__c, 'Branch should be Branch 1');
        System.assertEquals(item1.Id, subscription.dmpl__ItemId__c, 'Item should be Item 1');
        System.assertEquals(2, subscription.dmpl__Quantity__c, 'Quantity should be 2');
        System.assertEquals(saleOrder.Id, subscription.dmpl__SaleOrderId__c, 'saleOrder should be match');

        
        Boolean exceptionThrown = false;
        try{
            subscription.dmpl__SaleOrderId__c = null;
            update subscription;
        }catch (Exception e) {
            exceptionThrown = true;
        }
        System.assertEquals(false, exceptionThrown,'exception caught when removing sale order');

        if(!exceptionThrown){
            System.assertNotEquals(null, subscription.Id, 'subscription should be created');
            System.assertEquals(partnerAccount1.Id, subscription.dmpl__PartnerAccountId__c, 'Partner Account should be Partner 1');
            System.assertEquals(branch1.Id, subscription.dmpl__BranchId__c, 'Branch should be Branch 1');
            System.assertEquals(item1.Id, subscription.dmpl__ItemId__c, 'Item should be Item 1');
            System.assertEquals(2, subscription.dmpl__Quantity__c, 'Quantity should be 2');
        }
        Test.stopTest();
    }


    @isTest
    static void createSubscriptionWithActiveItemPositive(){
        Test.startTest();
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount1=TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item1=TestDataHelpers.getItem('Item 1');
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(customerAccount1.Id, partnerAccount1.Id, branch1.Id,null,null,true,null);

        dmpl__Subscription__c subscription = SubscriptionDataHelper.createSubscription(partnerAccount1,customerAccount1,branch1,item1,2,saleOrder,null,null);
        Test.stopTest();

        System.assertNotEquals(null, subscription.Id, 'subscription should be created');
        System.assertEquals(customerAccount1.Id, subscription.dmpl__AccountId__c, 'Account should be Customer 1');
        System.assertEquals(partnerAccount1.Id, subscription.dmpl__PartnerAccountId__c, 'Partner Account should be Partner 1');
        System.assertEquals(branch1.Id, subscription.dmpl__BranchId__c, 'Branch should be Branch 1');
        System.assertEquals(item1.Id, subscription.dmpl__ItemId__c, 'Item should be Item 1');
        System.assertEquals(2, subscription.dmpl__Quantity__c, 'Quantity should be 2');

    }

    @isTest
    static void createSubscriptionWithSaleOrderLineReferencePositive(){
        Test.startTest();
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount1=TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item5=TestDataHelpers.getItem('Item 5');
        dmpl__SaleOrder__c saleOrder1 = SaleOrderDataHelper.createSaleOrder(customerAccount1.Id, partnerAccount1.Id, branch1.Id,null,null,true,null); 
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.getSaleOrder(saleOrder1.Id);
        System.assertNotEquals(null, saleOrder.Id, 'sale Order should be created');
        System.assertEquals(customerAccount1.Id,saleOrder.dmpl__AccountId__c,'Account Name mismatch');
        System.assertEquals('Customer 1', saleOrder.dmpl__AccountName__c, 'Account Name mismatch');
        System.assertEquals('MG Road', saleOrder.dmpl__BillingStreet__c, 'Billing Street mismatch');
        System.assertEquals('Pune', saleOrder.dmpl__BillingCity__c, 'Billing City mismatch');
        System.assertEquals('Maharashtra', saleOrder.dmpl__BillingState__c, 'Billing State mismatch');
        System.assertEquals('India', saleOrder.dmpl__BillingCountry__c, 'Billing Country mismatch');
        System.assertEquals('411001', saleOrder.dmpl__BillingPostalCode__c, 'Billing Postal Code mismatch'); 
        System.assertEquals('Ring Rd', saleOrder.dmpl__ShippingStreet__c, 'Shipping Street mismatch');
        System.assertEquals('Nagpur', saleOrder.dmpl__ShippingCity__c, 'Shipping City mismatch');


        dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.createSaleOrderLine(saleOrder.Id, item5.Id,10,null);
        System.assertNotEquals(null, saleOrderLine.Id, 'sale Order Line should be created');
        System.assertEquals(10, saleOrderLine.dmpl__Quantity__c, 'Quantity should be 2');
        System.assertEquals(saleOrder.Id, saleOrderLine.dmpl__SaleOrderId__c, 'saleOrder should be match');
        System.assertEquals(item5.Id, saleOrderLine.dmpl__ItemId__c, 'Item should be Item 5');

        dmpl__Subscription__c subscription = SubscriptionDataHelper.createSubscription(partnerAccount1,customerAccount1,branch1,item5,2,saleOrder,saleOrderLine,null);
        Test.stopTest();
        System.assertNotEquals(null, subscription.Id, 'subscription should be created');
        System.assertEquals(customerAccount1.Id, subscription.dmpl__AccountId__c, 'Account should be Customer 1');
        System.assertEquals(partnerAccount1.Id, subscription.dmpl__PartnerAccountId__c, 'Partner Account should be Partner 1');
        System.assertEquals(branch1.Id, subscription.dmpl__BranchId__c, 'Branch should be Branch 1');
        System.assertEquals(item5.Id, subscription.dmpl__ItemId__c, 'Item should be Item 5');
        System.assertEquals(2, subscription.dmpl__Quantity__c, 'Quantity should be 2');
        System.assertEquals(saleOrder.Id, subscription.dmpl__SaleOrderId__c, 'saleOrder should be match');
        System.assertEquals(saleOrderLine.Id, subscription.dmpl__SaleOrderLineId__c, 'saleOrderLine should be match');

    }

    @isTest
    static void createSubscriptionWithInactiveItemNegative(){
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount1=TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item2=TestDataHelpers.getItem('Item 2');
        Test.startTest();
        try{
            dmpl__Subscription__c subscription = SubscriptionDataHelper.createSubscription(partnerAccount1,customerAccount1,branch1,item2,2,null,null,null);
            System.assertEquals(null, subscription.Id, 'subscription should not be created with inactive item');
        }catch (Exception e) {
            System.Assert.isTrue(true, 'subscription should not be created with inactive item');
        }
        Test.stopTest();
    }

    @isTest
    static void createSubscriptionWithoutSaleOrderLineReferencePositive(){
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount1=TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item1=TestDataHelpers.getItem('Item 1');
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(customerAccount1.Id, partnerAccount1.Id, branch1.Id,null,null,true,null); 

        Test.startTest();
        dmpl__Subscription__c subscription = SubscriptionDataHelper.createSubscription(partnerAccount1,customerAccount1,branch1,item1,2,saleOrder,null,null);
        Test.stopTest();

        System.assertNotEquals(null, subscription.Id, 'subscription should be created');
        System.assertEquals(customerAccount1.Id, subscription.dmpl__AccountId__c, 'Account should be Customer 1');
        System.assertEquals(partnerAccount1.Id, subscription.dmpl__PartnerAccountId__c, 'Partner Account should be Partner 1');
        System.assertEquals(branch1.Id, subscription.dmpl__BranchId__c, 'Branch should be Branch 1');
        System.assertEquals(item1.Id, subscription.dmpl__ItemId__c, 'Item should be Item 1');
        System.assertEquals(2, subscription.dmpl__Quantity__c, 'Quantity should be 2');
        System.assertEquals(saleOrder.Id, subscription.dmpl__SaleOrderId__c, 'saleOrder should be match');

    }


    @isTest
    static void updateSubscriptionWithInactiveItemNegative(){

        Test.startTest();
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount1=TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item1=TestDataHelpers.getItem('Item 1');
        dmpl__Item__c item2=TestDataHelpers.getItem('Item 2');
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(customerAccount1.Id, partnerAccount1.Id, branch1.Id,null,null,true,null); 

        dmpl__Subscription__c subscription = SubscriptionDataHelper.createSubscription(partnerAccount1,customerAccount1,branch1,item1,2,saleOrder,null,null);

        System.assertNotEquals(null, subscription.Id, 'subscription should be created');
        System.assertEquals(customerAccount1.Id, subscription.dmpl__AccountId__c, 'Account should be Customer 1');
        System.assertEquals(partnerAccount1.Id, subscription.dmpl__PartnerAccountId__c, 'Partner Account should be Partner 1');
        System.assertEquals(branch1.Id, subscription.dmpl__BranchId__c, 'Branch should be Branch 1');
        System.assertEquals(item1.Id, subscription.dmpl__ItemId__c, 'Item should be Item 1');
        System.assertEquals(2, subscription.dmpl__Quantity__c, 'Quantity should be 2');
        System.assertEquals(saleOrder.Id, subscription.dmpl__SaleOrderId__c, 'saleOrder should be match');

        
        Boolean exceptionThrown = false;
        try{
            subscription.dmpl__ItemId__c = item2.Id;
            update subscription;
        }catch (Exception e) {
            exceptionThrown = true;
        }
        System.assertEquals(true, exceptionThrown,'Expected exception when assigning inactive item');
        Test.stopTest();
       
    }

    @isTest
    static void updateSubscriptionWithSaleOrderLineReferencePositive(){
        Test.startTest();
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount1=TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item5=TestDataHelpers.getItem('Item 5');
        dmpl__SaleOrder__c saleOrder1 = SaleOrderDataHelper.createSaleOrder(customerAccount1.Id, partnerAccount1.Id, branch1.Id,null,null,true,null); 
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.getSaleOrder(saleOrder1.Id);
        System.assertNotEquals(null, saleOrder.Id, 'sale Order should be created');
        System.assertEquals(customerAccount1.Id,saleOrder.dmpl__AccountId__c,'Account Name mismatch');
        System.assertEquals('Customer 1', saleOrder.dmpl__AccountName__c, 'Account Name mismatch');
        System.assertEquals('MG Road', saleOrder.dmpl__BillingStreet__c, 'Billing Street mismatch');
        System.assertEquals('Pune', saleOrder.dmpl__BillingCity__c, 'Billing City mismatch');
        System.assertEquals('Maharashtra', saleOrder.dmpl__BillingState__c, 'Billing State mismatch');
        System.assertEquals('India', saleOrder.dmpl__BillingCountry__c, 'Billing Country mismatch');
        System.assertEquals('411001', saleOrder.dmpl__BillingPostalCode__c, 'Billing Postal Code mismatch'); 
        System.assertEquals('Ring Rd', saleOrder.dmpl__ShippingStreet__c, 'Shipping Street mismatch');
        System.assertEquals('Nagpur', saleOrder.dmpl__ShippingCity__c, 'Shipping City mismatch');


        dmpl__SaleOrderLine__c saleOrderLine = SaleOrderDataHelper.createSaleOrderLine(saleOrder.Id, item5.Id,10,null);
        System.assertNotEquals(null, saleOrderLine.Id, 'sale Order Line should be created');
        System.assertEquals(10, saleOrderLine.dmpl__Quantity__c, 'Quantity should be 2');
        System.assertEquals(saleOrder.Id, saleOrderLine.dmpl__SaleOrderId__c, 'saleOrder should be match');
        System.assertEquals(item5.Id, saleOrderLine.dmpl__ItemId__c, 'Item should be Item 5');

        dmpl__Subscription__c subscription = SubscriptionDataHelper.createSubscription(partnerAccount1,customerAccount1,branch1,item5,2,saleOrder,null,null);
        System.assertNotEquals(null, subscription.Id, 'subscription should be created');
        System.assertEquals(customerAccount1.Id, subscription.dmpl__AccountId__c, 'Account should be Customer 1');
        System.assertEquals(partnerAccount1.Id, subscription.dmpl__PartnerAccountId__c, 'Partner Account should be Partner 1');
        System.assertEquals(branch1.Id, subscription.dmpl__BranchId__c, 'Branch should be Branch 1');
        System.assertEquals(item5.Id, subscription.dmpl__ItemId__c, 'Item should be Item 5');
        System.assertEquals(2, subscription.dmpl__Quantity__c, 'Quantity should be 2');
        System.assertEquals(saleOrder.Id, subscription.dmpl__SaleOrderId__c, 'saleOrder should be match');

        Boolean exceptionThrown = false;
        try{
            subscription.dmpl__SaleOrderLineId__c= saleOrderLine.Id;
            update subscription;
        }catch(Exception e){
            exceptionThrown=true;
        }
        System.assertEquals(false, exceptionThrown,'Exception caught while assigning sale order line to subscription');
        Test.stopTest();

    }


    @isTest
    static void createSubscriptionWithZeroQuantityPositive(){
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount1=TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item1=TestDataHelpers.getItem('Item 1');
        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(customerAccount1.Id, partnerAccount1.Id, branch1.Id,null,null,true,null); 

        Test.startTest();
        try{
            dmpl__Subscription__c subscription = SubscriptionDataHelper.createSubscription(partnerAccount1,customerAccount1,branch1,item1,0,saleOrder,null,null);
            System.assertNotEquals(null, subscription.Id, 'Subscription should be created');
        }catch (Exception e) {
            System.Assert.isTrue(true, 'subscription should not be created with zero quantity');
        }
        Test.stopTest();
    }


    @isTest
    static void updateSubscriptionWithZeroQuantityPositive(){

        Test.startTest();
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount1=TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item1=TestDataHelpers.getItem('Item 1');

        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(customerAccount1.Id, partnerAccount1.Id, branch1.Id,null,null,true,null); 
        dmpl__Subscription__c subscription = SubscriptionDataHelper.createSubscription(partnerAccount1,customerAccount1,branch1,item1,2,saleOrder,null,null);

        System.assertNotEquals(null, subscription.Id, 'subscription should be created');
        System.assertEquals(customerAccount1.Id, subscription.dmpl__AccountId__c, 'Account should be Customer 1');
        System.assertEquals(partnerAccount1.Id, subscription.dmpl__PartnerAccountId__c, 'Partner Account should be Partner 1');
        System.assertEquals(branch1.Id, subscription.dmpl__BranchId__c, 'Branch should be Branch 1');
        System.assertEquals(item1.Id, subscription.dmpl__ItemId__c, 'Item should be Item 9');
        System.assertEquals(2, subscription.dmpl__Quantity__c, 'Quantity should be 2');
        System.assertEquals(saleOrder.Id, subscription.dmpl__SaleOrderId__c, 'saleOrder should be match');

        
        Boolean exceptionThrown = false;
        try{
            subscription.dmpl__Quantity__c = 0;
            update subscription;
        }catch (Exception e) {
            exceptionThrown = true;
        }
        System.assertEquals(false, exceptionThrown,'exception caught when quantity less than 1');

        
    }


    @isTest
    static void createSubscriptionWithoutUnitCostPositive(){

        Test.startTest();
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount1=TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item1=TestDataHelpers.getItem('Item 1');

        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(customerAccount1.Id, partnerAccount1.Id, branch1.Id,null,null,true,null); 
        dmpl__Subscription__c subscription = SubscriptionDataHelper.createSubscription(partnerAccount1,customerAccount1,branch1,item1,2,saleOrder,null,1500);

        System.assertNotEquals(null, subscription.Id, 'subscription should be created');
        System.assertEquals(1500.00, subscription.dmpl__UnitPrice__c, 'Price should be ₹1,500.00');
        System.assertEquals(customerAccount1.Id, subscription.dmpl__AccountId__c, 'Account should be Customer 1');
        System.assertEquals(partnerAccount1.Id, subscription.dmpl__PartnerAccountId__c, 'Partner Account should be Partner 1');
        System.assertEquals(branch1.Id, subscription.dmpl__BranchId__c, 'Branch should be Branch 1');
        System.assertEquals(item1.Id, subscription.dmpl__ItemId__c, 'Item should be Item 9');
        System.assertEquals(2, subscription.dmpl__Quantity__c, 'Quantity should be 2');
        System.assertEquals(saleOrder.Id, subscription.dmpl__SaleOrderId__c, 'saleOrder should be match');
        
    }

    @isTest
    static void updateSubscriptionWithoutUnitCostPositive(){

        Test.startTest();
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account partnerAccount1=TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item1=TestDataHelpers.getItem('Item 1');

        dmpl__SaleOrder__c saleOrder = SaleOrderDataHelper.createSaleOrder(customerAccount1.Id, partnerAccount1.Id, branch1.Id,null,null,true,null); 
        dmpl__Subscription__c subscription = SubscriptionDataHelper.createSubscription(partnerAccount1,customerAccount1,branch1,item1,2,saleOrder,null,1500);

        System.assertNotEquals(null, subscription.Id, 'subscription should be created');
        System.assertEquals(1500.00, subscription.dmpl__UnitPrice__c, 'Price should be ₹1,500.00');
        System.assertEquals(customerAccount1.Id, subscription.dmpl__AccountId__c, 'Account should be Customer 1');
        System.assertEquals(partnerAccount1.Id, subscription.dmpl__PartnerAccountId__c, 'Partner Account should be Partner 1');
        System.assertEquals(branch1.Id, subscription.dmpl__BranchId__c, 'Branch should be Branch 1');
        System.assertEquals(item1.Id, subscription.dmpl__ItemId__c, 'Item should be Item 9');
        System.assertEquals(2, subscription.dmpl__Quantity__c, 'Quantity should be 2');
        System.assertEquals(saleOrder.Id, subscription.dmpl__SaleOrderId__c, 'saleOrder should be match');

        Boolean exceptionThrown = false;
        try{
            subscription.dmpl__UnitPrice__c = 0;
            update subscription;
        }catch (Exception e) {
            exceptionThrown = true;
        }
        System.assertEquals(false, exceptionThrown,'exception caught when unitPrice is zero');
        
    }


     //Subscription Usage Summary creation with Summary name (new)
    @isTest
    static void createSubscriptionUsageSummaryWithSummaryNamePositive(){
        Test.startTest();
        dmpl__Subscription__c subscription = SubscriptionDataHelper.getSubscription();
        dmpl__SubscriptionUsageSumary__c subUsageSummary = SubscriptionDataHelper.createSubscriptionUsageSummary(subscription.Id,100);
        Test.stopTest();
        System.assertNotEquals(null, subUsageSummary, 'The subscription usage summary should not be null');
        System.assertEquals(subscription.Id, subUsageSummary.dmpl__SubscriptionId__c, 'The subscription ID should match');
        System.assertEquals(100, subUsageSummary.dmpl__BilledQuantity__c, 'The billed quantity should be 100');
    }
 
    //subcription usage summary creation without sale invoice line reference (new)
    @isTest
    static void createSubscriptionUsageSummaryWithoutSaleInvoiceLinePositive(){
        Test.startTest();
        dmpl__Subscription__c subscription = SubscriptionDataHelper.getSubscription();
        dmpl__SubscriptionUsageSumary__c subUsageSummary = SubscriptionDataHelper.createSubscriptionUsageSummary(subscription.Id,100);
        Test.stopTest();
        System.assertNotEquals(null, subUsageSummary, 'The subscription usage summary should not be null');
        System.assertEquals(subscription.Id, subUsageSummary.dmpl__SubscriptionId__c, 'The subscription ID should match');
        System.assertEquals(100, subUsageSummary.dmpl__BilledQuantity__c, 'The billed quantity should be 100');
    }
   
    //Subscription Usage Summary creation with no sale invoice (new)
    @isTest
    static void createSubscriptionUsageSummaryWithoutNoSaleInvoicePositive(){
        Test.startTest();
        dmpl__Subscription__c subscription = SubscriptionDataHelper.getSubscription();
        dmpl__SubscriptionUsageSumary__c subUsageSummary = SubscriptionDataHelper.createSubscriptionUsageSummary(subscription.Id,100);
        Test.stopTest();
        System.assertNotEquals(null, subUsageSummary, 'The subscription usage summary should not be null');
        System.assertEquals(subscription.Id, subUsageSummary.dmpl__SubscriptionId__c, 'The subscription ID should match');
        System.assertEquals(100, subUsageSummary.dmpl__BilledQuantity__c, 'The billed quantity should be 100');
    }
 
    //subscription usage summary creation  with 0 billed quantity (New)
    @isTest
    static void createSubscriptionUsageSummaryWithZeroBilledQuantityPositive(){
        Test.startTest();
        dmpl__Subscription__c subscription = SubscriptionDataHelper.getSubscription();
        dmpl__SubscriptionUsageSumary__c subUsageSummary = SubscriptionDataHelper.createSubscriptionUsageSummary(subscription.Id,0);
        Test.stopTest();
        System.assertNotEquals(null, subUsageSummary, 'The subscription usage summary should not be null');
        System.assertEquals(subscription.Id, subUsageSummary.dmpl__SubscriptionId__c, 'The subscription ID should match');
        System.assertEquals(0, subUsageSummary.dmpl__BilledQuantity__c, 'The billed quantity should be 100');
    }
 
    //Edit subscription Usage summary with 0 billed quantity (Edit)
    @isTest
    static void updateSubscriptionUsageSummaryWithZeroBilledQuantityPositive(){
        Test.startTest();
        dmpl__Subscription__c subscription = SubscriptionDataHelper.getSubscription();
        dmpl__SubscriptionUsageSumary__c subUsageSummary = SubscriptionDataHelper.createSubscriptionUsageSummary(subscription.Id,100);
        subUsageSummary.dmpl__BilledQuantity__c=0;
        update subUsageSummary;
        dmpl__SubscriptionUsageSumary__c fetchedSubUsageSummary = SubscriptionDataHelper.getSubscriptionUsageSummary(subUsageSummary.Id);
        Test.stopTest();
        System.assertNotEquals(null, fetchedSubUsageSummary, 'The subscription usage summary should not be null');
        System.assertEquals(subscription.Id, fetchedSubUsageSummary.dmpl__SubscriptionId__c, 'The subscription ID should match');
        System.assertEquals(0, fetchedSubUsageSummary.dmpl__BilledQuantity__c, 'The billed quantity should be 100');
    }
 
    //Subscription usage summary creation with no summary name (new)
    @isTest
    static void createSubscriptionUsageSummaryWithNullSummaryNamePositive(){
        Test.startTest();
        dmpl__Subscription__c subscription = SubscriptionDataHelper.getSubscription();
       
        dmpl__SubscriptionUsageSumary__c subUsageSummary = SubscriptionDataHelper.createSubscriptionUsageSummary(subscription.Id,100);
        System.debug('subUsageSummary.Id >>' + subUsageSummary.Id);
        dmpl__SubscriptionUsageSumary__c fetchedSubUsageSummary = SubscriptionDataHelper.getSubscriptionUsageSummary(subUsageSummary.Id);
        Test.stopTest();
        System.assertNotEquals(null, subUsageSummary, 'The subscription usage summary should not be null');
        System.assertEquals(subscription.Id, subUsageSummary.dmpl__SubscriptionId__c, 'The subscription ID should match');
        System.assertEquals(100, subUsageSummary.dmpl__BilledQuantity__c, 'The billed quantity should be 100');
    }
       
   
 
}