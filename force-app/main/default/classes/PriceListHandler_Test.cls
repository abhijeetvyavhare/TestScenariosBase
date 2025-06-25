@isTest
public with sharing class PriceListHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Account partnerAccount = TestDataHelpers.createPartnerAccount();
        Account customerAccount = TestDataHelpers.createCustomerAccount();
        dmpl__Branch__c branch = TestDataHelpers.createBranch(partnerAccount);
        dmpl__PriceList__c priceList = PriceListDataHelper.createPriceList(partnerAccount, branch);
        dmpl__Item__c item = TestDataHelpers.createItem();
        dmpl__SKU__c sku = TestDataHelpers.createSKU(item);
        dmpl__PriceListRules__c priceListRule = PriceListDataHelper.createPriceListRule(priceList, item, sku);
        dmpl__Item__c  item1 = TestDataHelpers.createItem('Item 1','Product',true,false,false,'675654',false);
        dmpl__Item__c item3 = TestDataHelpers.createItem('Item 3','Charge Item',true, false, false ,'765434',true);
        Account partnerAccount1 = TestDataHelpers.createPartnerAccount('Partner 1', false, true, false, true, 'MG Road', 'Bengaluru', 'Karnataka', 'India', '560001', '56 Industrial Layout', 'Bengaluru', 'Karnataka', 'India', '560095','9876543210');
        dmpl__Branch__c branch1=TestDataHelpers.createBranch('Branch 1', partnerAccount1.Id, true, true, false, true);
        
    }
    
    @isTest
    static void createPriceListPositive() {
        dmpl__PriceList__c priceList = PriceListDataHelper.getPriceList();
        System.assertNotEquals(null, priceList.Id, 'Expected PriceList to be created');
        System.assertEquals(true, priceList.dmpl__IsActive__c, 'Price List should be active');
        System.assertEquals(true, priceList.dmpl__IsDefault__c, 'Price List should be default');
    }
    
    @isTest
    static void createPriceListRulePositive() {
        dmpl__PriceListRules__c priceListRule = PriceListDataHelper.getPriceListRule();
        System.assertNotEquals(null, priceListRule.Id, 'Expected PriceListRule to be created');
        System.assertEquals(100, priceListRule.dmpl__Price__c, 'Unit price should be 100');
        System.assertEquals(System.today(), priceListRule.dmpl__DateEffectiveFrom__c, 'Date effective from should be today');
        System.assertEquals(Date.today().addYears(1), priceListRule.dmpl__DateEffectiveTill__c, 'Date effective till should be 1 year from today');
    }
    
    @isTest
    static void updatePriceListRulePositive() {
        dmpl__PriceListRules__c priceListRule = PriceListDataHelper.getPriceListRule();
        
        Test.startTest();
        priceListRule.dmpl__DateEffectiveFrom__c = Date.today()+1;
        priceListRule.dmpl__DateEffectiveTill__c = Date.today()+2;
        update priceListRule;
        Test.stopTest();
        
        dmpl__PriceListRules__c updatedPriceListRule = PriceListDataHelper.getPriceListRule(priceListRule.Id);
        System.assertEquals(Date.today() + 1, priceListRule.dmpl__DateEffectiveFrom__c, 'DateEffectiveFrom mismatch');
        System.assertEquals(Date.today() + 2, priceListRule.dmpl__DateEffectiveTill__c, 'DateEffectiveTill mismatch');
    }
    
    @isTest
    static void updatePriceListPositive() {
        dmpl__PriceList__c priceList = PriceListDataHelper.getPriceList();
        
        Test.startTest();
        priceList.dmpl__PriceListType__c = PriceListHelper.PRICELIST_TYPE_PURCHASE;
        priceList.dmpl__IsActive__c = false;
        priceList.dmpl__IsDefault__c = false;
        priceList.Name = 'Updated Price List';
        update priceList;
        Test.stopTest();
        
        dmpl__PriceList__c updatedPriceList = PriceListDataHelper.getPriceList(priceList.Id);
        System.assertEquals(PriceListHelper.PRICELIST_TYPE_PURCHASE, updatedPriceList.dmpl__PriceListType__c, 'Price List type should be updated to Purchase Price');
        System.assertEquals(false, updatedPriceList.dmpl__IsActive__c, 'Price List should be inactive');
        System.assertEquals(false, updatedPriceList.dmpl__IsDefault__c, 'Price List should not be default');
        System.assertEquals('Updated Price List', updatedPriceList.Name, 'Price List name should be updated');
    }
    
    @isTest
    static void deletePriceListRule() {
        dmpl__PriceListRules__c priceListRule = PriceListDataHelper.getPriceListRule();
        
        Test.startTest();
        delete priceListRule;
        Test.stopTest();
        
        try {
            dmpl__PriceListRules__c deletedPriceListRule = PriceListDataHelper.getPriceListRule(priceListRule.Id);
            System.assertEquals(null, deletedPriceListRule.Id, 'Price List Rule should be deleted');
        } catch (QueryException e) {
            System.assert(true, 'Expected exception on querying deleted Price List Rule');
        }
    }
    
    @isTest
    static void deletePriceList() {
        dmpl__PriceList__c priceList = PriceListDataHelper.getPriceList();
        
        Test.startTest();
        delete priceList;
        Test.stopTest();
        
        try {
            dmpl__PriceList__c deletedPriceList = PriceListDataHelper.getPriceList(priceList.Id);
            System.assertEquals(null, deletedPriceList.Id, 'Price List Rule should be deleted');
        } catch (QueryException e) {
            System.assert(true, 'Expected exception on querying deleted price list');
        }
    }
    
    //Price List with Price List Name(New)
    @isTest
    static void createPriceListWithPriceListNamePositive(){
        Test.startTest();
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__PriceList__c priceList = PriceListDataHelper.createPriceList('T7',true,partnerAccount1.Id,branch1.Id);
        dmpl__PriceList__c fetchedpriceList = PriceListDataHelper.getPriceList(priceList.Id);
        Test.stopTest();
        System.assertEquals('T7', fetchedPriceList.Name, 'Price List Name should be T7.');
        System.assertEquals(true, fetchedPriceList.dmpl__IsActive__c, 'Price List should be active.');
        System.assertEquals(branch1.Id, fetchedPriceList.dmpl__BranchId__c, 'Price List should be active.');
        System.assertEquals(partnerAccount1.Id, fetchedPriceList.dmpl__PartnerAccountId__c, 'Price List should be active.');
        
    }
    
    //Price List with Price List Name(Edit)
    @isTest
    static void updatePriceListWithPriceListNamePositive(){
        Test.startTest();
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__PriceList__c priceList = PriceListDataHelper.createPriceList('T7',true,partnerAccount1.Id,branch1.Id);
        dmpl__PriceList__c fetchedpriceList = PriceListDataHelper.getPriceList(priceList.Id);
        fetchedpriceList.Name = 'T9';
        Update fetchedpriceList;
        dmpl__PriceList__c updatedpriceList = PriceListDataHelper.getPriceList(fetchedpriceList.Id);
        Test.stopTest();
        System.assertEquals('T9', updatedpriceList.Name, 'Price List Name should be T9.');
        System.assertEquals(true, updatedpriceList.dmpl__IsActive__c, 'Price List should be active.');
        System.assertEquals(branch1.Id, updatedpriceList.dmpl__BranchId__c, 'Price List should be active.');
        System.assertEquals(partnerAccount1.Id, updatedpriceList.dmpl__PartnerAccountId__c, 'Price List should be active.');
        
    }
    
    //Price List without Price List Name(New)
    @isTest
    static void createPriceListWithoutPriceListNameNegative(){
        Boolean exceptionThrown = false;
        try{
            Test.startTest();
            dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
            Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
            dmpl__PriceList__c priceList = PriceListDataHelper.createPriceList('',true,partnerAccount1.Id,branch1.Id);
            
            Test.stopTest();
        } catch (DmlException e) {
            exceptionThrown = true;
        }
        
        System.assertEquals(true, exceptionThrown, 'Exception should be thrown when Price List Name is empty.');
        
    }
    
    //Price List with Is Active(New)
    @isTest
    static void createPriceListWithisActivePositive(){
        Test.startTest();
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__PriceList__c priceList = PriceListDataHelper.createPriceList('T7',true,partnerAccount1.Id,branch1.Id);
        
        dmpl__PriceList__c fetchedpriceList = PriceListDataHelper.getPriceList(priceList.Id);
        Test.stopTest();
        System.assertEquals('T7', fetchedPriceList.Name, 'Price List Name should be T7.');
        System.assertEquals(true, fetchedPriceList.dmpl__IsActive__c, 'Price List should be active.');
        System.assertEquals(branch1.Id, fetchedPriceList.dmpl__BranchId__c, 'Price List should be active.');
        System.assertEquals(partnerAccount1.Id, fetchedPriceList.dmpl__PartnerAccountId__c, 'Price List should be active.');
        
    }
    
    //Price List with Is Active(Edit)
    @isTest
    static void updatePriceListWithPriceLisIsActivePositive(){
        Test.startTest();
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__PriceList__c priceList = PriceListDataHelper.createPriceList('T7',true,partnerAccount1.Id,branch1.Id);
        dmpl__PriceList__c fetchedpriceList = PriceListDataHelper.getPriceList(priceList.Id);
        fetchedpriceList.dmpl__IsActive__c = false;
        Update fetchedpriceList;
        dmpl__PriceList__c updatedpriceList = PriceListDataHelper.getPriceList(fetchedpriceList.Id);
        Test.stopTest();
        System.assertEquals('T7', updatedpriceList.Name, 'Price List Name should be T7.');
        System.assertEquals(false, updatedpriceList.dmpl__IsActive__c, 'Price List should be active.');
        System.assertEquals(branch1.Id, updatedpriceList.dmpl__BranchId__c, 'Branch should be Macthed.');
        System.assertEquals(partnerAccount1.Id, updatedpriceList.dmpl__PartnerAccountId__c, 'Partner Account should be active.');
        
    }
    
    
    //Price List with Partner Account(New)
    static void createPriceListWithPartnerAccountPositive(){
        Test.startTest();
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__PriceList__c priceList = PriceListDataHelper.createPriceList('T7',true,partnerAccount1.Id,branch1.Id);
        
        dmpl__PriceList__c fetchedpriceList = PriceListDataHelper.getPriceList(priceList.Id);
        Test.stopTest();
        System.assertEquals('T7', fetchedPriceList.Name, 'Price List Name should be T7.');
        System.assertEquals(true, fetchedPriceList.dmpl__IsActive__c, 'Price List should be active.');
        System.assertEquals(branch1.Id, fetchedPriceList.dmpl__BranchId__c, 'Price List should be active.');
        System.assertEquals(partnerAccount1.Id, fetchedPriceList.dmpl__PartnerAccountId__c, 'Price List should be active.');
        
    }
    
    
    //Price List with Partner Account(Edit)
    @isTest
    static void updatePriceListWithPriceListPartnerAccountPositive(){
        Test.startTest();
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account partnerAccount3 = TestDataHelpers.createPartnerAccount('Partner 3', false, true, false, true, '78 Nehru Nagar Road', 'Chennai', 'Tamil Nadu', 'India', '600042', '78 Nehru Nagar Road', 'Chennai', 'Tamil Nadu', 'India', '600042', '91-9123456789');
        dmpl__PriceList__c priceList = PriceListDataHelper.createPriceList('T7',true,partnerAccount1.Id,branch1.Id);
        dmpl__PriceList__c fetchedpriceList = PriceListDataHelper.getPriceList(priceList.Id);
        fetchedpriceList.dmpl__PartnerAccountId__c = partnerAccount3.Id;
        Update fetchedpriceList;
        dmpl__PriceList__c updatedpriceList = PriceListDataHelper.getPriceList(fetchedpriceList.Id);
        Test.stopTest();
        System.assertEquals('T7', updatedpriceList.Name, 'Price List Name should be T7.');
        System.assertEquals(true, updatedpriceList.dmpl__IsActive__c, 'Price List should be active.');
        System.assertEquals(branch1.Id, updatedpriceList.dmpl__BranchId__c, 'Price List should be active.');
        System.assertEquals(partnerAccount3.Id, updatedpriceList.dmpl__PartnerAccountId__c, 'Price List should be active.');
        
    }
    
    //Price List without Partner Account(new)
    @isTest
    static void createPriceListWithoutPartnerAccountNegative(){
        Boolean exceptionThrown = false;
        
        try{
            Test.startTest();
            dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
            Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
            dmpl__PriceList__c priceList = PriceListDataHelper.createPriceList('T1',true,null,branch1.Id);
            
            Test.stopTest();
        } catch (DmlException e) {
            exceptionThrown = true;
        }
        
        System.assertEquals(true, exceptionThrown, 'Exception should be thrown when Price List partner account is empty.');
        
    }
    
    //Price List with branch(New)
    static void createPriceListWithBranchPositive(){
        Test.startTest();
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__PriceList__c priceList = PriceListDataHelper.createPriceList('T7',true,partnerAccount1.Id,branch1.Id);
        
        dmpl__PriceList__c fetchedpriceList = PriceListDataHelper.getPriceList(priceList.Id);
        Test.stopTest();
        System.assertEquals('T7', fetchedPriceList.Name, 'Price List Name should be T7.');
        System.assertEquals(true, fetchedPriceList.dmpl__IsActive__c, 'Price List should be active.');
        System.assertEquals(branch1.Id, fetchedPriceList.dmpl__BranchId__c, 'Price List should be active.');
        System.assertEquals(partnerAccount1.Id, fetchedPriceList.dmpl__PartnerAccountId__c, 'Price List should be active.');
        
    }
    
    //Price List with branch(Edit)
    @isTest
    static void updatePriceListWithPriceListBranchPositive(){
        Test.startTest();
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account partnerAccount3 = TestDataHelpers.createPartnerAccount('Partner 3', false, true, false, true, '78 Nehru Nagar Road', 'Chennai', 'Tamil Nadu', 'India', '600042', '78 Nehru Nagar Road', 'Chennai', 'Tamil Nadu', 'India', '600042', '91-9123456789');
        dmpl__Branch__c branch3 = TestDataHelpers.createBranch('Branch 3', partnerAccount3.Id, false, true, true, false);
        dmpl__PriceList__c priceList = PriceListDataHelper.createPriceList('T7',true,partnerAccount1.Id,branch1.Id);
        dmpl__PriceList__c fetchedpriceList = PriceListDataHelper.getPriceList(priceList.Id);
        fetchedpriceList.dmpl__BranchId__c = branch3.Id;
        Update fetchedpriceList;
        dmpl__PriceList__c updatedpriceList = PriceListDataHelper.getPriceList(fetchedpriceList.Id);
        Test.stopTest();
        System.assertEquals('T7', updatedpriceList.Name, 'Price List Name should be T7.');
        System.assertEquals(true, updatedpriceList.dmpl__IsActive__c, 'Price List should be active.');
        System.assertEquals(branch3.Id, updatedpriceList.dmpl__BranchId__c, 'Price List should be active.');
        System.assertEquals(partnerAccount1.Id, updatedpriceList.dmpl__PartnerAccountId__c, 'Price List should be active.');
        
    }
    //Price List without Branch(new)
    @isTest
    static void createPriceListWithoutBranchNegative(){
        try{
            Boolean exceptionThrown = false;
            
            Test.startTest();
            dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
            Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
            dmpl__PriceList__c priceList = PriceListDataHelper.createPriceList('T7',true,partnerAccount1.Id,null);
            
            Test.stopTest();
        } catch (DmlException e) {
            exceptionThrown = true;
        }
        
        System.assertEquals(true, exceptionThrown, 'Exception should be thrown when Price List branch is empty.');
        
    }
    
    //Price List Rule with Item(New)
    @isTest
    static void createPriceListRuleWithItemPositive(){
        Test.startTest();
        dmpl__Item__c  item1 = TestDataHelpers.getItem('Item 1');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__PriceList__c priceList = PriceListDataHelper.createPriceList('T7',true,partnerAccount1.Id,branch1.Id);        dmpl__PriceListRules__c rule = PriceListDataHelper.createPriceListRule(priceList.Id,item1.Id,1000,Date.today(),Date.today().addMonths(1));
        dmpl__PriceListRules__c fetchedrule = PriceListDataHelper.getPriceListRule(rule.Id);
        Test.stopTest();
        System.assertEquals(item1.Id, fetchedRule.dmpl__ItemId__c, 'Item should match.');
        System.assertEquals(priceList.Id, fetchedRule.dmpl__PriceListId__c, 'Price List should match.');
        System.assertEquals(Date.today(), fetchedRule.dmpl__DateEffectiveFrom__c, 'Effective From date should match.');
        System.assertEquals(Date.today().addMonths(1), fetchedRule.dmpl__DateEffectiveTill__c, 'Effective From date should match.');
        System.assertEquals(1000, fetchedRule.dmpl__Price__c, 'Price should be 1000.');
    }
    
    //Price List Rule with Item(Edit)
    @isTest
    static void updatePriceListRuleWithItemPositive(){
        Test.startTest();
        dmpl__Item__c  item1 = TestDataHelpers.getItem('Item 1');
        dmpl__Item__c  item3 = TestDataHelpers.getItem('Item 3');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__PriceList__c priceList = PriceListDataHelper.createPriceList('T7',true,partnerAccount1.Id,branch1.Id);
        dmpl__PriceListRules__c rule = PriceListDataHelper.createPriceListRule(priceList.Id,item1.Id,1000,Date.today(),Date.today().addMonths(1));
        dmpl__PriceListRules__c fetchedrule = PriceListDataHelper.getPriceListRule(rule.Id);
        fetchedrule.dmpl__ItemId__c = item3.Id;
        Update fetchedrule;
        dmpl__PriceListRules__c updateddrule = PriceListDataHelper.getPriceListRule(fetchedrule.Id);
        
        Test.stopTest();
        System.assertEquals(item3.Id, updateddrule.dmpl__ItemId__c, 'Item should match.');
        System.assertEquals(priceList.Id, updateddrule.dmpl__PriceListId__c, 'Price List should match.');
        System.assertEquals(Date.today(), updateddrule.dmpl__DateEffectiveFrom__c, 'Effective From date should match.');
        System.assertEquals(Date.today().addMonths(1), updateddrule.dmpl__DateEffectiveTill__c, 'Effective From date should match.');
        System.assertEquals(1000, updateddrule.dmpl__Price__c, 'Price should be 1000.');
    }
    
    //Price List Rule without Item(New)
    @isTest
    static void createPriceListRuleWithoutItemNegative(){
        Boolean exceptionThrown = false;
        Test.startTest();
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__PriceList__c priceList = PriceListDataHelper.createPriceList('T7',true,partnerAccount1.Id,branch1.Id);
        try{
            dmpl__PriceListRules__c rule = PriceListDataHelper.createPriceListRule(priceList.Id,null,1000,Date.today(),Date.today().addMonths(1));
        } catch (DmlException e) {
            exceptionThrown = true;
        }
        Test.stopTest();
        
        System.assertEquals(true, exceptionThrown, 'Exception should be thrown when Item is missing in Price List Rule.');
        
    }
    
    //Price List Rule with price(New)
    @isTest
    static void createPriceListRuleWithPricePositive(){
        Test.startTest();
        dmpl__Item__c  item1 = TestDataHelpers.getItem('Item 1');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__PriceList__c priceList = PriceListDataHelper.createPriceList('T7',true,partnerAccount1.Id,branch1.Id);
        dmpl__PriceListRules__c rule = PriceListDataHelper.createPriceListRule(priceList.Id,item1.Id,1000,Date.today(),Date.today().addMonths(1));
        dmpl__PriceListRules__c fetchedrule = PriceListDataHelper.getPriceListRule(rule.Id);
        Test.stopTest();
        System.assertEquals(item1.Id, fetchedRule.dmpl__ItemId__c, 'Item should match.');
        System.assertEquals(priceList.Id, fetchedRule.dmpl__PriceListId__c, 'Price List should match.');
        System.assertEquals(Date.today(), fetchedRule.dmpl__DateEffectiveFrom__c, 'Effective From date should match.');
        System.assertEquals(Date.today().addMonths(1), fetchedRule.dmpl__DateEffectiveTill__c, 'Effective From date should match.');
        System.assertEquals(1000, fetchedRule.dmpl__Price__c, 'Price should be 1000.');
    }
    
    //Price List Rule with price(Edit)
    @isTest
    static void updatePriceListRuleWithPricePositive(){
        Test.startTest();
        dmpl__Item__c  item1 = TestDataHelpers.getItem('Item 1');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__PriceList__c priceList = PriceListDataHelper.createPriceList('T7',true,partnerAccount1.Id,branch1.Id);
        dmpl__PriceListRules__c rule = PriceListDataHelper.createPriceListRule(priceList.Id,item1.Id,1000,Date.today(),Date.today().addMonths(1));
        dmpl__PriceListRules__c fetchedrule = PriceListDataHelper.getPriceListRule(rule.Id);
        fetchedrule.dmpl__Price__c = 2000;
        Update fetchedrule;
        dmpl__PriceListRules__c updateddrule = PriceListDataHelper.getPriceListRule(fetchedrule.Id);
        
        Test.stopTest();
        System.assertEquals(item1.Id, updateddrule.dmpl__ItemId__c, 'Item should match.');
        System.assertEquals(priceList.Id, updateddrule.dmpl__PriceListId__c, 'Price List should match.');
        System.assertEquals(Date.today(), updateddrule.dmpl__DateEffectiveFrom__c, 'Effective From date should match.');
        System.assertEquals(Date.today().addMonths(1), updateddrule.dmpl__DateEffectiveTill__c, 'Effective From date should match.');
        System.assertEquals(2000, updateddrule.dmpl__Price__c, 'Price should be 1000.');
    }
    
    //Price List Rule without price(New)
    @isTest
    static void updatePriceListRuleWithoutPriceNegative(){
        Boolean exceptionThrown = false;
        
        Test.startTest();
        dmpl__Item__c  item1 = TestDataHelpers.getItem('Item 1');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__PriceList__c priceList = PriceListDataHelper.createPriceList('T7',true,partnerAccount1.Id,branch1.Id);
        try{
            dmpl__PriceListRules__c rule = PriceListDataHelper.createPriceListRule(priceList.Id,item1.Id,null,Date.today(),Date.today().addMonths(1));
        } catch (DmlException e) {
            exceptionThrown = true;
        }
        Test.stopTest();
        
        System.assertEquals(true, exceptionThrown, 'Exception should be thrown when Price is missing.');
        
    }
    
    //Price List Rule with Date Effective From(New)
    @isTest
    static void createPriceListRuleWithEffectiveFromPositive(){
        Test.startTest();
        dmpl__Item__c  item1 = TestDataHelpers.getItem('Item 1');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__PriceList__c priceList = PriceListDataHelper.createPriceList('T7',true,partnerAccount1.Id,branch1.Id);
        dmpl__PriceListRules__c rule = PriceListDataHelper.createPriceListRule(priceList.Id,item1.Id,1000,Date.today(),Date.today().addMonths(1));
        dmpl__PriceListRules__c fetchedrule = PriceListDataHelper.getPriceListRule(rule.Id);
        Test.stopTest();
        System.assertEquals(item1.Id, fetchedRule.dmpl__ItemId__c, 'Item should match.');
        System.assertEquals(priceList.Id, fetchedRule.dmpl__PriceListId__c, 'Price List should match.');
        System.assertEquals(Date.today(), fetchedRule.dmpl__DateEffectiveFrom__c, 'Effective From date should match.');
        System.assertEquals(Date.today().addMonths(1), fetchedRule.dmpl__DateEffectiveTill__c, 'Effective From date should match.');
        System.assertEquals(1000, fetchedRule.dmpl__Price__c, 'Price should be 1000.');
    }
    
    //Price List Rule with Date Effective From(New)
    @isTest
    static void updatePriceListRuleWithEffectiveFromPositive(){
        Test.startTest();
        dmpl__Item__c  item1 = TestDataHelpers.getItem('Item 1');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__PriceList__c priceList = PriceListDataHelper.createPriceList('T7',true,partnerAccount1.Id,branch1.Id);
        dmpl__PriceListRules__c rule = PriceListDataHelper.createPriceListRule(priceList.Id,item1.Id,1000,Date.today(),Date.today().addMonths(1));
        dmpl__PriceListRules__c fetchedrule = PriceListDataHelper.getPriceListRule(rule.Id);
        fetchedrule.dmpl__DateEffectiveFrom__c = Date.today().addDays(7);
        Update fetchedrule;
        dmpl__PriceListRules__c updateddrule = PriceListDataHelper.getPriceListRule(fetchedrule.Id);
        
        Test.stopTest();
        System.assertEquals(item1.Id, updateddrule.dmpl__ItemId__c, 'Item should match.');
        System.assertEquals(priceList.Id, updateddrule.dmpl__PriceListId__c, 'Price List should match.');
        System.assertEquals(Date.today().addDays(7), updateddrule.dmpl__DateEffectiveFrom__c, 'Effective From date should match.');
        System.assertEquals(Date.today().addMonths(1), updateddrule.dmpl__DateEffectiveTill__c, 'Effective From date should match.');
        System.assertEquals(2000, updateddrule.dmpl__Price__c, 'Price should be 1000.');
    }
    
    //Price List Rule without Date Effective From(New)
    @isTest
    static void createPriceListRuleWithoutEffectiveFromNegative(){
        Boolean exceptionThrown = false;
        
        Test.startTest();
        dmpl__Item__c  item1 = TestDataHelpers.getItem('Item 1');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__PriceList__c priceList = PriceListDataHelper.createPriceList('T7',true,partnerAccount1.Id,branch1.Id);
        try{
            dmpl__PriceListRules__c rule = PriceListDataHelper.createPriceListRule(priceList.Id,item1.Id,1000,null,Date.today().addMonths(1));
        } catch (DmlException e) {
            exceptionThrown = true;
        }
        Test.stopTest();
        
        System.assertEquals(true, exceptionThrown, 'Exception should be thrown when Date Effective From is missing.');
        
    }
    
    //Price List Rule with Price List(New)
    @isTest
    static void createPriceListRuleWithPriceListPositive(){
        Test.startTest();
        dmpl__Item__c  item1 = TestDataHelpers.getItem('Item 1');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__PriceList__c priceList = PriceListDataHelper.createPriceList('T7',true,partnerAccount1.Id,branch1.Id);
        dmpl__PriceListRules__c rule = PriceListDataHelper.createPriceListRule(priceList.Id,item1.Id,1000,Date.today(),Date.today().addMonths(1));
        dmpl__PriceListRules__c fetchedrule = PriceListDataHelper.getPriceListRule(rule.Id);
        Test.stopTest();
        System.assertEquals(item1.Id, fetchedRule.dmpl__ItemId__c, 'Item should match.');
        System.assertEquals(priceList.Id, fetchedRule.dmpl__PriceListId__c, 'Price List should match.');
        System.assertEquals(Date.today(), fetchedRule.dmpl__DateEffectiveFrom__c, 'Effective From date should match.');
        System.assertEquals(Date.today().addMonths(1), fetchedRule.dmpl__DateEffectiveTill__c, 'Effective From date should match.');
        System.assertEquals(1000, fetchedRule.dmpl__Price__c, 'Price should be 1000.');
    }
    
    //Price List Rule with Price List(Edit)
    @isTest
    static void updatePriceListRuleWithPriceListPositive(){
        Test.startTest();
        dmpl__Item__c  item1 = TestDataHelpers.getItem('Item 1');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        dmpl__Branch__c branch2=TestDataHelpers.getBranch('Branch 2');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account partnerAccount2 = TestDataHelpers.getPartnerAccount('Partner 2');
        dmpl__PriceList__c priceList = PriceListDataHelper.createPriceList('T7',true,partnerAccount1.Id,branch1.Id);
        dmpl__PriceList__c priceList1 = PriceListDataHelper.createPriceList('T8',true,partnerAccount2.Id,branch2.Id);
        dmpl__PriceListRules__c rule = PriceListDataHelper.createPriceListRule(priceList.Id,item1.Id,1000,Date.today(),Date.today().addMonths(1));
        fetchedrule.dmpl__PriceListId__c = priceList1.Id;
        Update fetchedrule;
        dmpl__PriceListRules__c updateddrule = PriceListDataHelper.getPriceListRule(fetchedrule.Id);
        
        Test.stopTest();
        System.assertEquals(item1.Id, updateddrule.dmpl__ItemId__c, 'Item should match.');
        System.assertEquals(priceList1.Id, updateddrule.dmpl__PriceListId__c, 'Price List should match.');
        System.assertEquals(Date.today().addDays(7), updateddrule.dmpl__DateEffectiveFrom__c, 'Effective From date should match.');
        System.assertEquals(Date.today().addMonths(1), updateddrule.dmpl__DateEffectiveTill__c, 'Effective From date should match.');
        System.assertEquals(2000, updateddrule.dmpl__Price__c, 'Price should be 1000.');
    }
    
    //Price List Rule without Price List(New)
    @isTest
    static void createPriceListRuleWithoutPriceListNegative(){
        Boolean exceptionThrown = false;
        
        Test.startTest();
        dmpl__Item__c  item1 = TestDataHelpers.getItem('Item 1');
        try{
            dmpl__PriceListRules__c rule = PriceListDataHelper.createPriceListRule(null,item1.Id,1000,Date.today(),Date.today().addMonths(1));
        } catch (DmlException e) {
            exceptionThrown = true;
        }
        Test.stopTest();
        
        System.assertEquals(true, exceptionThrown, 'Exception should be thrown when Date Effective From is missing.');
        
    }
    
    //Price List Rule with Date Effective From and Date Effective To(New)
    @isTest
    static void createPriceListRuleWithDateEffectiveFromAndDateEffectiveToPositive(){
        Test.startTest();
        dmpl__Item__c  item1 = TestDataHelpers.getItem('Item 1');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__PriceList__c priceList = PriceListDataHelper.createPriceList('T7',true,partnerAccount1.Id,branch1.Id);
        dmpl__PriceListRules__c rule = PriceListDataHelper.createPriceListRule(priceList.Id,item1.Id,1000,Date.today(),Date.today().addMonths(1));
        dmpl__PriceListRules__c fetchedrule = PriceListDataHelper.getPriceListRule(rule.Id);
        Test.stopTest();
        System.assertEquals(item1.Id, fetchedRule.dmpl__ItemId__c, 'Item should match.');
        System.assertEquals(priceList.Id, fetchedRule.dmpl__PriceListId__c, 'Price List should match.');
        System.assertEquals(Date.today(), fetchedRule.dmpl__DateEffectiveFrom__c, 'Effective From date should match.');
        System.assertEquals(Date.today().addMonths(1), fetchedRule.dmpl__DateEffectiveTill__c, 'Effective From date should match.');
        System.assertEquals(1000, fetchedRule.dmpl__Price__c, 'Price should be 1000.');
    }
    
    //Price List Rule with Date Effective To before Date Effective From(New)
    @isTest
    static void createPriceListRuleWithDateEffectiveToBeforeDateEffectiveFromNegative(){
        Boolean exceptionThrown = false;
        
        Test.startTest();
        dmpl__Item__c  item1 = TestDataHelpers.getItem('Item 1');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__PriceList__c priceList = PriceListDataHelper.createPriceList('T7',true,partnerAccount1.Id,branch1.Id);
        try{
            dmpl__PriceListRules__c rule = PriceListDataHelper.createPriceListRule(priceList.Id,item1.Id,1000,Date.today(),Date.today(-1));
        } catch (DmlException e) {
            exceptionThrown = true;
        }
        Test.stopTest();
        
        System.assertEquals(true, exceptionThrown, 'Exception should be thrown when Date Effective till is less than Date Effective From .');
    }
    
    //Price List Rule with Date Effective To same as Date Effective From(New)
    @isTest
    static void createPriceListRuleWithDateEffectiveToSameAsDateEffectiveFromNegative(){
        Boolean exceptionThrown = false;
        Test.startTest();
        dmpl__Item__c  item1 = TestDataHelpers.getItem('Item 1');
        dmpl__Branch__c branch1=TestDataHelpers.getBranch('Branch 1');
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__PriceList__c priceList = PriceListDataHelper.createPriceList('T7',true,partnerAccount1.Id,branch1.Id);
        try{
            dmpl__PriceListRules__c rule = PriceListDataHelper.createPriceListRule(priceList.Id,item1.Id,1000,Date.today(),Date.today());
        } catch (DmlException e) {
            exceptionThrown = true;
        }
        Test.stopTest();
        
        System.assertEquals(true, exceptionThrown, 'Exception should be thrown when Date Effective till is same Date Effective From .');
    }
}