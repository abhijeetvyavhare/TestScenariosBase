@isTest
public with sharing class LeaveTypeDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults() {
        return new Map<String, Object>{
            'Name' => 'Leave Type Insert Test',
            'dmpl__EntitlementType__c' => 'Annual',  
            'dmpl__Type__c' => 'Paid'
        };
    }
}