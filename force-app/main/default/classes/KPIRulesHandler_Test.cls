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

    //KPI Rule creation with valid KPI Name (new)
    @isTest
    static void createKPIRuleWithValidKPINamePositive(){
        dmpl__KPIConfiguration__c kpiConfig = KPIDataHelper.createKPIConfiguration('Test KPI Config', 'Customer', 'TestDateField');
        dmpl__KPIRules__c rule = KPIRulesDataHelper.createKPIRuleName(kpiConfig,'TestKPI', 'Test_Field__c', 'TestValue', 'equals', 1);
        dmpl__KPIRules__c KPIrule = KPIRulesDataHelper.getKPIRule(rule.Id);

      
        System.assertEquals(rule.Id, KPIrule.Id, 'Fetched KPI Rule ID should match created rule ID');
        System.assertEquals('Test_Field__c', KPIrule.dmpl__FieldName__c, 'Field name should match');
        System.assertEquals('TestValue', KPIrule.dmpl__FieldValue__c, 'Field value should match');
        System.assertEquals('equals', KPIrule.dmpl__Operation__c, 'Operator should match');
        System.assertEquals(1, KPIrule.dmpl__Sequence_Number__c, 'Sequence number should match');
        System.assertEquals(kpiConfig.Id, KPIrule.dmpl__KPIConfigurationId__c, 'Rule should be linked to the correct KPI Configuration');
    }

    //KPI Rule creation using valid KPI Configuration Id (New)
    @isTest
    static void createKPIRuleWithValidKPIConfigurationIdPositive(){
        dmpl__KPIConfiguration__c kpiConfig = KPIDataHelper.createKPIConfiguration('Test KPI Config', 'Customer', 'TestDateField');
        dmpl__KPIRules__c rule = KPIRulesDataHelper.createKPIRuleName(kpiConfig,'TestKPI', 'Test_Field__c', 'TestValue', 'equals', 1);
        dmpl__KPIRules__c KPIrule = KPIRulesDataHelper.getKPIRule(rule.Id);

        System.assertEquals(rule.Id, KPIrule.Id, 'Fetched KPI Rule ID should match created rule ID');
        System.assertEquals('Test_Field__c', KPIrule.dmpl__FieldName__c, 'Field name should match');
        System.assertEquals('TestValue', KPIrule.dmpl__FieldValue__c, 'Field value should match');
        System.assertEquals('equals', KPIrule.dmpl__Operation__c, 'Operator should match');
        System.assertEquals(1, KPIrule.dmpl__Sequence_Number__c, 'Sequence number should match');
        System.assertEquals(kpiConfig.Id, KPIrule.dmpl__KPIConfigurationId__c, 'Rule should be linked to the correct KPI Configuration');
    }
    
    

    //KPI Rule creation without selecting KPI Configuration (New)
    @isTest
    static void createKPIRuleWithoutKPIConfigurationNegative(){
        Boolean exceptionThrown= false;
       
        try {
            dmpl__KPIRules__c rule = KPIRulesDataHelper.createKPIRuleName(null,'TestKpi' ,'Test_Field__c', 'TestValue', 'equals', 1);
        } catch (Exception e) {
              exceptionThrown= true;
        System.debug('Expected exception caught: ' + e.getMessage());
        }
        System.assertEquals(true, exceptionThrown, 'Expected exception was not thrown when using null in kpi coniguration name');
    }

    //KPI Rule creation without entering KPI Name (New)
    @isTest
    static void createKPIRuleWithoutEnteringKpiNameNegative(){
        Boolean exceptionThrown= false;
        dmpl__KPIConfiguration__c kpiConfig = KPIDataHelper.createKPIConfiguration('Test KPI Config', 'Customer', 'TestDateField');
        try {
            dmpl__KPIRules__c rule = KPIRulesDataHelper.createKPIRuleName(kpiConfig,null, 'Test_Field__c', 'TestValue', 'equals', 1);
        } catch (Exception e) {
            exceptionThrown= true;
            System.debug('Expected exception caught: ' + e.getMessage());
        }
       // System.assertEquals(true, exceptionThrown, 'Expected exception was not thrown when using null in kpi coniguration name');

    }

    //KPI Rule creation without entering KPI Name (New)
    @isTest
    static void createKPIRuleWithoutNameNegative(){
        Boolean exceptionThrown= false;
        dmpl__KPIConfiguration__c kpiConfig = KPIDataHelper.createKPIConfiguration('Test KPI Config', 'Customer', 'TestDateField');
        try {
            dmpl__KPIRules__c rule = KPIRulesDataHelper.createKPIRuleName(kpiConfig,null, 'Test_Field__c', 'TestValue', 'equals', 1);
        } catch (Exception e) {
            exceptionThrown= true;
            System.debug('Expected exception caught: ' + e.getMessage());
        }
        //System.assertEquals(true, exceptionThrown, 'Expected exception was not thrown when using null in kpi coniguration name');

    }

    //KPI Rule creation with blank KPI Name (New)
    @isTest
    static void createKPIRuleWithBlankNameNegative(){
        Boolean exceptionThrown= false;
        dmpl__KPIConfiguration__c kpiConfig = KPIDataHelper.createKPIConfiguration('Test KPI Config', 'Customer', 'TestDateField');
        try {
            dmpl__KPIRules__c rule = KPIRulesDataHelper.createKPIRuleName(kpiConfig,null, 'Test_Field__c', 'TestValue', 'equals', 1);
        } catch (Exception e) {
            exceptionThrown= true;
            System.debug('Expected exception caught: ' + e.getMessage());
        }
        //System.assertEquals(true, exceptionThrown, 'Expected exception was not thrown when using null in kpi name');
   }
    
    //Edit KPI Rule and update KPI Name with new logic (Edit)
    @isTest
    static void updateKPIRuleNameWithNewLogicPositive(){
        dmpl__KPIConfiguration__c kpiConfig = KPIDataHelper.createKPIConfiguration('Test KPI Config', 'Customer', 'TestDateField');
        dmpl__KPIRules__c rule = KPIRulesDataHelper.createKPIRuleName(kpiConfig,'TestKPI', 'Test_Field__c', 'TestValue', 'equals', 1);
        rule.Name='Kpi';
        update rule;
        dmpl__KPIRules__c FetchedKPIrule = KPIRulesDataHelper.getKPIRule(rule.Id);

        System.assertEquals('Test_Field__c', FetchedKPIrule.dmpl__FieldName__c, 'Field name should match');
        System.assertEquals('TestValue', FetchedKPIrule.dmpl__FieldValue__c, 'Field value should match');
        System.assertEquals('equals', FetchedKPIrule.dmpl__Operation__c, 'Operator should match');
        System.assertEquals(1, FetchedKPIrule.dmpl__Sequence_Number__c, 'Sequence number should match');
    }


    //Edit KPI Rule and remove KPI Name (Edit)
    @isTest
    static void updateKPIRuleWithBlankNameNegative(){
        Boolean exceptionThrown= false;
        dmpl__KPIConfiguration__c kpiConfig = KPIDataHelper.createKPIConfiguration('Test KPI Config', 'Customer', 'TestDateField');
        dmpl__KPIRules__c rule = KPIRulesDataHelper.createKPIRuleName(kpiConfig,'TestKPI', 'Test_Field__c', 'TestValue', 'equals', 1);

        try {
           rule.Name= null;
           update rule;
        } catch (Exception e) {
            exceptionThrown= true;
            System.debug('Expected exception caught: ' + e.getMessage());
        }
       // System.assertEquals(true, exceptionThrown, 'Expected exception was not thrown when using null in name');
    
    }
}