@isTest
public with sharing class ResourceDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{ 
            'Name' => 'Test - Resource',
            'dmpl__Type__c' => 'Manager',
            'dmpl__IsActive__c' => true,
            'dmpl__Phone__c' => '9999999999',
            'dmpl__EffectiveFromDate__c' => Date.today(),
            'dmpl__EffectiveTillDate__c' => Date.today().addYears(1)
        };
    }
}