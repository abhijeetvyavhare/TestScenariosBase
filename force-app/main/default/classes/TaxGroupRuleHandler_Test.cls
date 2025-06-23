@isTest
public with sharing class TaxGroupRuleHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Account partnerAccount = TestDataHelpers.createPartnerAccount();
        dmpl__Branch__c branch = TestDataHelpers.createBranch(partnerAccount);
        dmpl__PriceList__c priceList = TestDataHelpers.createPriceList(partnerAccount, branch);
        dmpl__Item__c item = TestDataHelpers.createItem();
        dmpl__SKU__c sku = TestDataHelpers.createSKU(item);
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.createTaxGroup(partnerAccount, branch);
        dmpl__ItemGroup__c itemGroup = TaxGroupRuleTestDataHelper.createItemGroup();

        dmpl__TaxGroupRule__c taxGroupRule = TaxGroupRuleTestDataHelper.createTaxGroupRule(item, sku, taxGroup, itemGroup);
    }

    @isTest
    static void createTaxGroupRulePositive() {
        dmpl__TaxGroupRule__c rule = TaxGroupRuleTestDataHelper.getTaxGroupRule();
        System.assertNotEquals(null, rule, 'Expected TaxGroupRule to be created.');
        System.assertEquals('Within State', rule.dmpl__PlaceOfSupplyType__c, 'Expected correct PlaceOfSupplyType.');
        System.assert(rule.dmpl__DateEffectiveTill__c > rule.dmpl__DateEffectiveFrom__c, 'Effective Till should be after From.');
    }

    @isTest
    static void updateTaxGroupRuleFields() {
        dmpl__TaxGroupRule__c rule = TaxGroupRuleTestDataHelper.getTaxGroupRule();
        System.assertNotEquals(null, rule, 'TaxGroupRule should exist before update.');

        Date newEffectiveTill = Date.today().addDays(30);
        rule.dmpl__DateEffectiveTill__c = newEffectiveTill;
        update rule;

        dmpl__TaxGroupRule__c updatedRule = TaxGroupRuleTestDataHelper.getTaxGroupRule();
        System.assertEquals(newEffectiveTill, updatedRule.dmpl__DateEffectiveTill__c, 'DateEffectiveTill should be updated.');
    }

    @isTest
    static void deleteTaxGroupRule() {
        dmpl__TaxGroupRule__c rule = TaxGroupRuleTestDataHelper.getTaxGroupRule();
        System.assertNotEquals(null, rule, 'TaxGroupRule should exist before delete.');
        
        delete rule;

        dmpl__TaxGroupRule__c deletedRule;
        try {
            deletedRule = [SELECT Id FROM dmpl__TaxGroupRule__c WHERE Id = :rule.Id];
        } catch (Exception e) {
            deletedRule = null;
        }

        System.assertEquals(null, deletedRule, 'TaxGroupRule should be deleted and not found in query.');
    }

}