@isTest
public with sharing class SchemePeriodDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults() {
        return new Map<String, Object>{
            'Name' => 'Test Scheme Period',
            'dmpl__DateFrom__c' => Date.today(),
            'dmpl__DateTo__c' => Date.today().addDays(30),
            'dmpl__Status__c' => 'Approved'
        };
    }
}