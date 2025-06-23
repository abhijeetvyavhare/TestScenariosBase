@isTest
public with sharing class CheckInTemplateLineDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults() {
        return new Map<String, Object>{
            'dmpl__SectionName__c' => 'Front'
        };
    }
}