@isTest
public with sharing class CheckInInspectionDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults() {
        return new Map<String, Object>{
            'dmpl__CheckInType__c' => 'None',
            'dmpl__CheckInDateTime__c' => null
        };
    }
}