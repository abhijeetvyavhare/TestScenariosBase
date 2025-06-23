@isTest
public with sharing class SkillLineDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults() {
        return new Map<String, Object>{
            'dmpl__WorkItemId__c' => null 
        };
    }
}