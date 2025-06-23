@isTest
public with sharing class ServiceRecommendationRuleHandler_Test {
    @TestSetup
    static void createRequiredData() {
        dmpl__AccountGroup__c accountGroup = TestDataHelpers.createAccountGroup();
        Account account = TestDataHelpers.createAccount(accountGroup);
        Account partnerAccount = TestDataHelpers.createPartnerAccount();
        dmpl__Branch__c branch =TestDataHelpers.createBranch(partnerAccount);   
        dmpl__Item__c item = TestDataHelpers.createItem();
        dmpl__Resource__c resource = TestDataHelpers.createResource(partnerAccount, branch);
        dmpl__ChecklistTemplate__c checklistTemplate = ChecklistTemplateTestDataHelpers.createChecklistTemplate(resource, item, partnerAccount, account, accountGroup);
        dmpl__CheckListTemplateLine__c checklistTemplateLine =  ChecklistTemplateTestDataHelpers.createChecklistTemplateLine(checkListTemplate);
        dmpl__ServiceRecommendationRule__c serviceRecommendationRule = ServiceRecommendationRuleTestDataHelper.createServiceRecommendationRule(checklistTemplateLine, item);
    }

    @isTest
    static void createServiceRecommendationRulePositive() {
        dmpl__ServiceRecommendationRule__c serviceRecommendationRule = ServiceRecommendationRuleTestDataHelper.getServiceRecommendationRule();
        System.assertNotEquals(serviceRecommendationRule, null, 'Expected Service Recommendation Rule to be created.');

        System.assertEquals(serviceRecommendationRule.dmpl__Quantity__c, 3, 'Quantity should be 3.');
        System.assertEquals(serviceRecommendationRule.dmpl__ValueGreaterThan__c, 5, 'Value greater than should be 5.');
        System.assertEquals(serviceRecommendationRule.dmpl__ValueLessThan__c, 2, 'Value less than should be 2.');
        System.assertEquals(serviceRecommendationRule.dmpl__RAGValue__c, 'Red', 'RAG Value should be Red.');
        System.assertEquals(serviceRecommendationRule.dmpl__RecommendationType__c, 'Mandatory', 'Recommendation Type should be Mandatory.');
    }

    @isTest
    static void updateServiceRecommendationRulePositive() {
        dmpl__ServiceRecommendationRule__c serviceRecommendationRule = ServiceRecommendationRuleTestDataHelper.getServiceRecommendationRule();
        System.assertNotEquals(serviceRecommendationRule, null, 'Service Recommendation Rule should exist before update.');
        serviceRecommendationRule.dmpl__Quantity__c = 4;
        serviceRecommendationRule.dmpl__ValueGreaterThan__c = 6;
        serviceRecommendationRule.dmpl__ValueLessThan__c = 3;
        serviceRecommendationRule.dmpl__RAGValue__c = 'Amber';
        serviceRecommendationRule.dmpl__RecommendationType__c = 'Optional';
        update serviceRecommendationRule;

        dmpl__ServiceRecommendationRule__c updatedServiceRecommendationRule = ServiceRecommendationRuleTestDataHelper.getServiceRecommendationRule();
        System.assertEquals(updatedServiceRecommendationRule.dmpl__Quantity__c, 4, 'Quantity should be 4 after update.');
        System.assertEquals(updatedServiceRecommendationRule.dmpl__ValueGreaterThan__c, 6, 'Value greater than should be 6 after update.');
        System.assertEquals(updatedServiceRecommendationRule.dmpl__ValueLessThan__c, 3, 'Value less than should be 3 after update.');
        System.assertEquals(updatedServiceRecommendationRule.dmpl__RAGValue__c, 'Amber', 'RAG Value should be Amber after update.');
        System.assertEquals(updatedServiceRecommendationRule.dmpl__RecommendationType__c, 'Optional', 'Recommendation Type should be Optional after update.');
    }

    @isTest
    static void deleteServiceRecommendationRule() {
        dmpl__ServiceRecommendationRule__c serviceRecommendationRule = ServiceRecommendationRuleTestDataHelper.getServiceRecommendationRule();
        System.assertNotEquals(serviceRecommendationRule, null, 'Service Recommendation Rule should exist before delete.');
        Id serviceRecommendationRuleId = serviceRecommendationRule.Id;
        delete serviceRecommendationRule;
        dmpl__ServiceRecommendationRule__c deletedServiceRecommendationRule = null;
        try {
            deletedServiceRecommendationRule = ServiceRecommendationRuleTestDataHelper.getServiceRecommendationRule(serviceRecommendationRuleId);
        } catch (Exception e) {
            deletedServiceRecommendationRule = null;
        }
        System.assertEquals(deletedServiceRecommendationRule, null, 'Service Recommendation Rule should be deleted and not found in query.');
    }
}