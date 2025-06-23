@isTest
public with sharing class ResourceAssignmentRuleDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{ 
            'dmpl__AssignmentType__c' => null,
            'dmpl__FieldName__c' => 'Test Field',
            'dmpl__FieldValue__c' => 'Test Value', 
            'dmpl__Operation__c' => 'notEqual',
            'dmpl__PartnerResourceId__c' => null,
            'dmpl__SequenceNumber__c' => 1
        };
    }
}