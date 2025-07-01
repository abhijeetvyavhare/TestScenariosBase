@isTest
public with sharing class TaxHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Account partnerAccount = TestDataHelpers.createPartnerAccount();
        dmpl__AccountGroup__c partnerAccountGroup = TestDataHelpers.createAccountGroup();
        dmpl__Branch__c branch = TestDataHelpers.createBranch(partnerAccount);
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.createTaxGroup(partnerAccount, branch);
        dmpl__Tax__c tax = TestDataHelpers.createTax(taxGroup);
        dmpl__Item__c item = TestDataHelpers.createItem();
        dmpl__SKU__c sku = TestDataHelpers.createSKU(item);
        dmpl__ItemGroup__c itemGroup = TestDataHelpers.createItemGroup();     
        dmpl__TaxGroupRule__c taxGroupRule = TestDataHelpers.createTaxGroupRule(item, sku, taxGroup, itemGroup);
    }
    
    @isTest
    static void createTaxGroupPositive() {
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup();
        System.assertNotEquals(null, taxGroup, 'Expected tax group to be created.');
        System.assertEquals('Test - Tax Group', taxGroup.Name, 'Tax group name should match.');
    }

    @isTest
    static void updateTaxGroupPositive() {
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup();
        System.assertNotEquals(null, taxGroup, 'TaxGroup should exist before update.');

        taxGroup.Name = 'Updated Tax Group';
        update taxGroup;

        dmpl__TaxGroup__c updatedGroup = TestDataHelpers.getTaxGroup(taxGroup.Name);
        System.assertEquals('Updated Tax Group', updatedGroup.Name, 'Tax group name should be updated.');
    }

    @isTest
    static void deleteTaxGroup() {
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.getTaxGroup();
        System.assertNotEquals(null, taxGroup, 'TaxGroup should exist before delete.');

        delete taxGroup;

        dmpl__TaxGroup__c deletedGroup;
        try {
            deletedGroup = TestDataHelpers.getTaxGroup(taxGroup.Name);
        } catch (Exception e) {
            deletedGroup = null;
        }
        System.assertEquals(null, deletedGroup, 'TaxGroup should be deleted and not found in query.');
    }


    @isTest
    static void createTaxGroupRulePositive() {
        dmpl__TaxGroupRule__c rule = TestDataHelpers.getTaxGroupRule();
        System.assertNotEquals(null, rule, 'Expected TaxGroupRule to be created.');
        System.assertEquals('Within State', rule.dmpl__PlaceOfSupplyType__c, 'Expected correct PlaceOfSupplyType.');
        System.assert(rule.dmpl__DateEffectiveTill__c > rule.dmpl__DateEffectiveFrom__c, 'Effective Till should be after From.');
    }

    @isTest
    static void updateTaxGroupRule() {
        dmpl__TaxGroupRule__c rule = TestDataHelpers.getTaxGroupRule();
        System.assertNotEquals(null, rule, 'TaxGroupRule should exist before update.');

        Date newEffectiveTill = Date.today().addDays(30);
        rule.dmpl__DateEffectiveTill__c = newEffectiveTill;
        update rule;

        dmpl__TaxGroupRule__c updatedRule = TestDataHelpers.getTaxGroupRule();
        System.assertEquals(newEffectiveTill, updatedRule.dmpl__DateEffectiveTill__c, 'DateEffectiveTill should be updated.');
    }

    @isTest
    static void deleteTaxGroupRule() {
        dmpl__TaxGroupRule__c rule = TestDataHelpers.getTaxGroupRule();
        System.assertNotEquals(null, rule, 'TaxGroupRule should exist before delete.');
        
        delete rule;

        dmpl__TaxGroupRule__c deletedRule;
        try {
            deletedRule =  TestDataHelpers.getTaxGroupRule();
        } catch (Exception e) {
            deletedRule = null;
        }

        System.assertEquals(null, deletedRule, 'TaxGroupRule should be deleted and not found in query.');
    }


    @isTest
    static void createTaxPositive() {
        dmpl__Tax__c tax = TestDataHelpers.getTax();
        System.assertNotEquals(null, tax, 'Expected Tax record to be created.');
        System.assertEquals('Test - Tax', tax.Name, 'Tax Name should match.');
        System.assertEquals(10, tax.dmpl__Rate__c, 'Tax Rate should be 10.');
    }

    @isTest
    static void updateTaxPositive() {
        dmpl__Tax__c tax = TestDataHelpers.getTax();
        System.assertNotEquals(null, tax, 'Tax should exist before update.');

        tax.dmpl__Rate__c = 15;
        update tax;

        dmpl__Tax__c updatedTax = TestDataHelpers.getTax();
        System.assertEquals(15, updatedTax.dmpl__Rate__c, 'Tax rate should be updated to 15.');
    }

    @isTest
    static void deleteTax() {
        dmpl__Tax__c tax = TestDataHelpers.getTax();
        System.assertNotEquals(null, tax, 'Tax should exist before delete.');

        delete tax;

        dmpl__Tax__c deletedTax;
        try {
            deletedTax = TestDataHelpers.getTax();
        } catch (Exception e) {
            deletedTax = null;
        }
        System.assertEquals(null, deletedTax, 'Tax should be deleted and not found in query.');
    }
}