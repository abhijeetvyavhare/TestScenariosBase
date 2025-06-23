@isTest
public with sharing class LeaveEntitlementDefault implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults() {
        return new Map<String, Object>{
            'dmpl__FixedCount__c' => 12
        };
    }
}