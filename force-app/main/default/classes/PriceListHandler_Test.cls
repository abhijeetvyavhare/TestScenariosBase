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
        dmpl__PriceList__c priceList = PriceListDataHelper.createPriceList('T7',true);
        dmpl__PriceList__c fetchedpriceList = PriceListDataHelper.getPriceList(priceList.Id);
        Test.stopTest();
        System.assertEquals('T7', fetchedPriceList.Name, 'Price List Name should be T7.');
        System.assertEquals(true, fetchedPriceList.dmpl__IsActive__c, 'Price List should be active.');
    }
    
    //Price List with Price List Name(Edit)
    @isTest
    static void updatePriceListWithPriceListNamePositive(){
        Test.startTest();
        dmpl__PriceList__c priceList = PriceListDataHelper.createPriceList('T7',true);
        dmpl__PriceList__c fetchedpriceList = PriceListDataHelper.getPriceList(priceList.Id);
        fetchedpriceList.Name = 'T9';
        Update fetchedpriceList;
        dmpl__PriceList__c updatedpriceList = PriceListDataHelper.getPriceList(fetchedpriceList.Id);
        Test.stopTest();
        System.assertEquals('T9', fetchedPriceList.Name, 'Price List Name should be T9.');
        System.assertEquals(true, fetchedPriceList.dmpl__IsActive__c, 'Price List should be active.');
        
    }
    
    //Price List without Price List Name(New)
    @isTest
    static void createPriceListWithoutPriceListNameNegative(){
        try{
            Test.startTest();
            dmpl__PriceList__c priceList = PriceListDataHelper.createPriceList('',true);
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
        dmpl__PriceList__c priceList = PriceListDataHelper.createPriceList('T7',true);
        dmpl__PriceList__c fetchedpriceList = PriceListDataHelper.getPriceList(priceList.Id);
        Test.stopTest();
        System.assertEquals('T7', fetchedPriceList.Name, 'Price List Name should be T7.');
        System.assertEquals(true, fetchedPriceList.dmpl__IsActive__c, 'Price List should be active.');
    }

    //Price List with Is Active(Edit)
      @isTest
    static void updatePriceListWithPriceListNamePositive(){
        Test.startTest();
        dmpl__PriceList__c priceList = PriceListDataHelper.createPriceList('T7',true);
        dmpl__PriceList__c fetchedpriceList = PriceListDataHelper.getPriceList(priceList.Id);
        fetchedpriceList.dmpl__IsActive__c = false;
        Update fetchedpriceList;
        dmpl__PriceList__c updatedpriceList = PriceListDataHelper.getPriceList(fetchedpriceList.Id);
        Test.stopTest();
        System.assertEquals('T7', fetchedPriceList.Name, 'Price List Name should be T7.');
        System.assertEquals(false, fetchedPriceList.dmpl__IsActive__c, 'Price List should be active.');
        
    }
    
}