@isTest
public with sharing class CheckInInspectionLineDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults() {
        return new Map<String, Object>{
            'dmpl__Condition__c' => 'Dent'
        };
    }
}