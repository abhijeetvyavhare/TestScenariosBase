@isTest
public with sharing class ItemRelationDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults() {
        return new Map<String, Object>{
            'dmpl__Price__c' => 100.0,
            'dmpl__Quantity__c' => 5.0
        };
    }
}