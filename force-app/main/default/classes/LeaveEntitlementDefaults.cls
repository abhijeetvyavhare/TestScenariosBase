@isTest
public with sharing class LeaveEntitlementDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults() {
        return new Map<String, Object>{
            'dmpl__FixedCount__c' => 12
        };
    }
}