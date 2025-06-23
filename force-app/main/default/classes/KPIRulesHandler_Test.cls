@isTest
public with sharing class KPIRulesHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Account partnerAccount = TestDataHelpers.createPartnerAccount();
        Account customerAccount = TestDataHelpers.createCustomerAccount();
        dmpl__Branch__c branch = TestDataHelpers.createBranch(partnerAccount);
        dmpl__KPIConfiguration__c kpiConfig = KPIDataHelper.createKPIConfiguration('Test KPI Config', 'Customer', 'TestDateField');
        dmpl__KPIRules__c rule = KPIRulesDataHelper.createKPIRule(kpiConfig, 'Test_Field__c', 'TestValue', 'equals', 1);
    }

    @isTest
    static void createKPIRulePositive() {
        dmpl__KPIRules__c rule = KPIRulesDataHelper.getKPIRule();
        System.assertNotEquals(rule, null, 'Expected KPI Rule to be created.');
        System.assertEquals('Test KPI Rule', rule.Name, 'KPI Rule Name should match');
        System.assertEquals('Test_Field__c', rule.dmpl__FieldName__c, 'Field Name should match');
        System.assertEquals('TestValue', rule.dmpl__FieldValue__c, 'Field Value should match');
        System.assertEquals('equals', rule.dmpl__Operation__c, 'Operation should match');
        System.assertEquals(1, rule.dmpl__Sequence_Number__c, 'Sequence Number should match');
    }

    @isTest
    static void updateKPIRulePositive() {
        dmpl__KPIRules__c rule = KPIRulesDataHelper.getKPIRule();
        dmpl__KPIRules__c updatedRule = KPIRulesDataHelper.updateKPIRule(rule, 'UpdatedValue');
        System.assertEquals('UpdatedValue', updatedRule.dmpl__FieldValue__c, 'Field Value should be updated.');
    }

    @isTest
    static void deleteKPIRule() {
        dmpl__KPIRules__c rule = KPIRulesDataHelper.getKPIRule();
        Integer count = KPIRulesDataHelper.deleteKPIRule(rule);
        System.assertEquals(0, count, 'KPI Rule should be deleted and not found in query.');
    }
}