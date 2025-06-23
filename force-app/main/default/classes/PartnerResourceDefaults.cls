@isTest
public with sharing class PartnerResourceDefaults implements TestFactory.FieldDefaults {
    
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{ 
            'dmpl__AssignmentSequenceNumber__c' => 1,
            'dmpl__FromDate__c' => null,
            //'Name' => '',
            'dmpl__RuleSuccessCriteria__c' => null,
            'dmpl__RuleSuccessCustomLogic__c' => null,
            'dmpl__ToDate__c' => null
        };
    }
}