@isTest
public with sharing class ShipmentLineDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{
            'dmpl__Quantity__c' => 1,
            'dmpl__UnitPrice__c' => 1000.00
        };
    }
}