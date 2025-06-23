@isTest
public with sharing class ClaimLineDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{ 
            'dmpl__ClaimQuantity__c' => 2.0,
            'dmpl__ClaimType__c' => 'Part To Part',
            'dmpl__Discount__c' => 10.0,
            'dmpl__Status__c' => 'Draft',
            'dmpl__UnitPrice2__c' => 1000.0,
            'dmpl__UnitPrice__c' => 900.0
        };
    }
   
}