@isTest
public with sharing class PriceListRulesHandler_Test {

    @TestSetup
    static void setup() {
        PriceListRulesDataHelper.createRequiredData();
    }

    @isTest
    static void createPriceListRulesPositive() {
        dmpl__PriceListRules__c rule = PriceListRulesDataHelper.getRule();
        System.assertNotEquals(null, rule, 'Rule should exist');
        System.assertNotEquals(null, rule.Id, 'Rule should be inserted');
    }

    @isTest
    static void updatePriceListRulesPositive() {
        dmpl__PriceListRules__c rule = PriceListRulesDataHelper.getRule();
        rule.dmpl__Price__c = 150.00;
        rule.dmpl__Price2__c = 160.0001;
        update rule;

        dmpl__PriceListRules__c updated = PriceListRulesDataHelper.getRuleById(rule.Id);
        System.assertEquals(150.00, updated.dmpl__Price__c);
        System.assertEquals(160.0001, updated.dmpl__Price2__c);
    }

    @isTest
    static void deletePriceListRulesPositive() {
        dmpl__PriceListRules__c rule = PriceListRulesDataHelper.getRule();
        delete rule;
        Boolean exists = PriceListRulesDataHelper.existsRule(rule.Id);
        System.assertEquals(false, exists, 'Rule should be deleted');
    }
}