@isTest
public with sharing class DeliveryOrderLineDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{ 
            'dmpl__Quantity__c' => 1,
            'dmpl__UnitPrice__c' => 10,
            'dmpl__Discount__c' => 3,
            'dmpl__TaxAmount__c' => 0
        };
    }
}