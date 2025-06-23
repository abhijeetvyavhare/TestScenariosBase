@isTest
public with sharing class CreditLimitHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Account partnerAccount = TestDataHelpers.createPartnerAccount();
        Account customerAccount = TestDataHelpers.createCustomerAccount();
        CreditLimitDataHelper.createCreditLimit(partnerAccount.Id, customerAccount.Id);
    }

    @isTest
    static void createCreditLimitPositive() {
        dmpl__CreditLimit__c creditLimit = CreditLimitDataHelper.getCreditLimit();
        System.assert(creditLimit != null, 'Expected Credit Limit to be created.');
        System.assertEquals(100000, creditLimit.dmpl__CreditLimitAmount__c, 'Expected credit limit to match default.');
    }
    
    @isTest
    static void updateCreditLimitPositive() {
        dmpl__CreditLimit__c creditLimit = CreditLimitDataHelper.getCreditLimit();
        creditLimit.dmpl__CreditDays__c = 45;
        update creditLimit;
        dmpl__CreditLimit__c updated = CreditLimitDataHelper.getCreditLimit(creditLimit.Id);
        System.assertEquals(45, updated.dmpl__CreditDays__c, 'Expected updated credit days.');
    }

    @isTest
    static void deleteCreditLimit() {
        dmpl__CreditLimit__c creditLimit = CreditLimitDataHelper.getCreditLimit();
        System.assertNotEquals(creditLimit, null, 'CreditLimit should exist before delete.');
        delete creditLimit;
        dmpl__CreditLimit__c deletedLimit = null;
        try {
            deletedLimit = CreditLimitDataHelper.getCreditLimit(creditLimit.Id);
        } catch (Exception e) {
            deletedLimit = null;
        }
        System.assertEquals(null, deletedLimit, 'CreditLimit should be deleted and not found after deletion.');
    }

}