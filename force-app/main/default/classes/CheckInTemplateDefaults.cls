@isTest
public with sharing class CheckInTemplateDefaults implements TestFactory.FieldDefaults{
    public Map<String, Object> getFieldDefaults() {
        return new Map<String, Object>{
            'dmpl__ExternalId__c' => 'null'
        };
    }
}