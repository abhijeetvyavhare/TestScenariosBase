@isTest
public with sharing class ServiceRecommendationRuleTestDataHelper {
    public static dmpl__ServiceRecommendationRule__c createServiceRecommendationRule(
        dmpl__CheckListTemplateLine__c checklistTemplateLine,
        dmpl__Item__c item
    ) {
        return (dmpl__ServiceRecommendationRule__c) TestFactory.createSObject(
            new dmpl__ServiceRecommendationRule__c(
                dmpl__ChecklistTemplateLineId__c = checklistTemplateLine.Id,
                dmpl__ItemId__c = item.Id
            ),
            'ServiceRecommendationRuleDefaults',
            true
        );
    }
 
    public static dmpl__ServiceRecommendationRule__c getServiceRecommendationRule() {
        return [
            SELECT 
                Id,
                Name,
                dmpl__ChecklistTemplateLineId__c,
                dmpl__Quantity__c,
                dmpl__ValueGreaterThan__c,
                dmpl__ValueLessThan__c,
                dmpl__RAGValue__c,
                dmpl__RecommendationType__c,
                dmpl__ItemId__c
            FROM dmpl__ServiceRecommendationRule__c 
            LIMIT 1
        ];
    }
    
    public static dmpl__ServiceRecommendationRule__c getServiceRecommendationRule(Id serviceRecommendationRuleId) {
        return [
            SELECT 
                Id,
                Name,
                dmpl__ChecklistTemplateLineId__c,
                dmpl__Quantity__c,
                dmpl__ValueGreaterThan__c,
                dmpl__ValueLessThan__c,
                dmpl__RAGValue__c,
                dmpl__RecommendationType__c,
                dmpl__ItemId__c
            FROM dmpl__ServiceRecommendationRule__c 
            WHERE ID = :serviceRecommendationRuleId 
            LIMIT 1
        ];
    }
}