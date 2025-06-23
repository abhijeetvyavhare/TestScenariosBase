@isTest
public with sharing class QuoteHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Account partnerAccount = TestDataHelpers.createPartnerAccount();
        Account customerAccount = TestDataHelpers.createCustomerAccount();  
        Account supplierAccount =TestDataHelpers.createSupplierAccount();
        dmpl__Branch__c branch =TestDataHelpers.createBranch(partnerAccount);
        dmpl__StorageLocation__c storageLocation=TestDataHelpers.createStorageLocation(branch);
        dmpl__Item__c item =TestDataHelpers.createItem();
        dmpl__SKU__c sku =TestDataHelpers.createSKU(item);
        dmpl__ItemLot__c itemLot=TestDataHelpers.createItemLot(branch,item,sku,storageLocation);
        dmpl__TaxGroup__c taxGroup =TestDataHelpers.createTaxGroup(partnerAccount,branch);
        dmpl__Tax__c tax = TestDataHelpers.createTax(taxGroup);
        dmpl__PriceList__c priceList = TestDataHelpers.createPriceList(partnerAccount,branch);
        dmpl__PriceListRules__c priceListRule = TestDataHelpers.createPriceListRules(priceList,item);
        Asset asset=AssetTestDataHelpers.CreateAsset(customerAccount, branch, item, itemLot, sku);
        dmpl__BranchTimeSlot__c brTimeSlot = BranchTimeSlotDataHelper.createBranchTimeSlot(branch,item);
        dmpl__ServiceRequest__c ServiceRequest= ServiceRequestTestDataHelpers.createServiceRequest(customerAccount,branch,item,asset,brTimeSlot);
        dmpl__Quote__c quote =QuoteTestDataHelpers.CreateServiceEstimate(branch,customerAccount,priceList,asset,ServiceRequest,item);
        dmpl__QuoteLine__c quoteLine=QuoteTestDataHelpers.CreateServiceEstimateLine(item,priceListRule,taxGroup,null,quote);
        dmpl__QuoteTax__c quoteTax=QuoteTestDataHelpers.CreateServiceEstimateTax(quote,quoteLine,tax,taxGroup);
    }

    @isTest
    static void createQuotePositive() {
        dmpl__Quote__c quote = QuoteTestDataHelpers.getServiceEstimate();
        if(quote != null){
            System.assertNotEquals(quote, null, 'Expected Quote to be created.');
        }
        System.assertEquals(false, quote.dmpl__PerformApproval__c, 'PerformApproval should be false');
        System.assertEquals(false, quote.dmpl__PerformDecline__c, 'PerformDecline should be false');
    }

    @isTest
    static void updateQuotePositive() {
        dmpl__Quote__c quote = QuoteTestDataHelpers.getServiceEstimate();
        System.assertNotEquals(quote, null, 'Quote should exist before update.');
        quote.dmpl__TCSEligibleAmount__c=100;
        Test.startTest();
        update quote;
        Test.stopTest();
        dmpl__Quote__c updatedQuote = QuoteTestDataHelpers.getServiceEstimate();       
        System.assertEquals(100, updatedQuote.dmpl__TCSEligibleAmount__c, 'dmpl__TCSEligibleAmount__c should be 100');
    }

    @isTest
    static void deleteQuote() {
        dmpl__Quote__c quote = QuoteTestDataHelpers.getServiceEstimate();
        System.assertNotEquals(quote, null, 'Quote should exist before delete.');
        delete quote;
        dmpl__Quote__c deletedQuote = null;
        try {
            deletedQuote = QuoteTestDataHelpers.getServiceEstimate();
        } catch (Exception e) {
            deletedQuote = null;
        }
        System.assertEquals(null, deletedQuote, 'Quote should be deleted and not found in query.');
    }
    
    @isTest
    static void createQuoteLinePositive() {
        dmpl__QuoteLine__c quoteLine= QuoteTestDataHelpers.getServiceEstimateLine();
        if(quoteLine != null){
            System.assertNotEquals(quoteLine, null, 'Expected Quote to be created.');
        }
        System.assertEquals(true, quoteLine.dmpl__IncludeinPackage__c, 'IncludeinPackage should be false');
        System.assertEquals(false, quoteLine.dmpl__IsPackageService__c, 'IsPackageService should be false');
    }

    @isTest
    static void updateQuoteLinePositive() {
        dmpl__QuoteLine__c quoteLine= QuoteTestDataHelpers.getServiceEstimateLine();
        System.assertNotEquals(quoteLine, null, 'QuoteLine should exist before update.');        
        quoteLine.dmpl__UnitPrice__c=100;
        Test.startTest();
        update quoteLine;
        Test.stopTest();
        dmpl__QuoteLine__c updatedQuoteLine = QuoteTestDataHelpers.getServiceEstimateLine();       
        System.assertEquals(100, updatedQuoteLine.dmpl__UnitPrice__c, 'UnitPrice should be 100');
    }

    @isTest
    static void deleteQuoteLine() {
        dmpl__QuoteLine__c quoteLine= QuoteTestDataHelpers.getServiceEstimateLine();
        System.assertNotEquals(quoteLine, null, 'QuoteLine should exist before delete.');
        delete quoteLine;
        dmpl__QuoteLine__c deletedQuoteLine = null;
        try {
            deletedQuoteLine = QuoteTestDataHelpers.getServiceEstimateLine();
        } catch (Exception e) {
            deletedQuoteLine = null;
        }
        System.assertEquals(null, deletedQuoteLine, 'QuoteLine should be deleted and not found in query.');
    }
    @isTest
    static void createQuoteTaxPositive() {
        dmpl__QuoteTax__c quoteTax = QuoteTestDataHelpers.getServiceEstimateTax();
        if(quoteTax != null){
            System.assertNotEquals(quoteTax, null, 'Expected QuoteTax to be created.');
        }
        System.assertEquals(10, quoteTax.dmpl__TaxRate__c, 'TaxRate should be 10');
    }

    @isTest
    static void updateQuoteTaxPositive() {
        dmpl__QuoteTax__c quoteTax = QuoteTestDataHelpers.getServiceEstimateTax();
        System.assertNotEquals(quoteTax, null, 'QuoteTax should exist before update.');
        quoteTax.dmpl__TaxOnAmount__c=200;
        quoteTax.dmpl__TaxRate__c=20;
        Test.startTest();
        update quoteTax;
        Test.stopTest();
        dmpl__QuoteTax__c updatedQuoteTax = QuoteTestDataHelpers.getServiceEstimateTax();       
        System.assertEquals(200, updatedQuoteTax.dmpl__TaxOnAmount__c, 'TaxOnAmount should be 200');
        System.assertEquals(20, updatedQuoteTax.dmpl__TaxRate__c, 'TaxRate should be 20');
    }

    @isTest
    static void deleteQuoteTax() {
        dmpl__Quote__c quote =QuoteTestDataHelpers.getServiceEstimate();
        dmpl__QuoteTax__c quoteTax = QuoteTestDataHelpers.getServiceEstimateTax();
        System.assertNotEquals(quoteTax, null, 'QuoteTax should exist before delete.');
        Test.startTest();
        delete quote;
        Test.stopTest();
        dmpl__QuoteTax__c deletedQuoteTax = null;
        try {
            deletedQuoteTax =  QuoteTestDataHelpers.getServiceEstimateTax();
        } catch (Exception e) {
            deletedQuoteTax = null;
        }
        System.assertEquals(null, deletedQuoteTax, 'QuoteTax should be deleted and not found in query.');
    }
}