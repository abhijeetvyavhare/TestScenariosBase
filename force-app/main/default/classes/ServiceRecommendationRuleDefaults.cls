@isTest
public with sharing class ServiceRecommendationRuleDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{
            'dmpl__Quantity__c'=>3,
            'dmpl__ValueGreaterThan__c'=>5,
            'dmpl__ValueLessThan__c'=>2,
            'dmpl__RAGValue__c'=>'Red',
            'dmpl__RecommendationType__c'=>'Mandatory'
        };
    }
}