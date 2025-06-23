@isTest
public with sharing class LeaveRequestDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults() {
        return new Map<String, Object>{
            'dmpl__ApplyFor__c' => 'Full Day',
            'dmpl__FromDate__c' => Date.today(),
            'dmpl__ToDate__c' => Date.today().addDays(2),
            'dmpl__Reason__c' => 'Personal reason',
            'dmpl__Status__c' => 'Pending Approval'
        };
    }
}