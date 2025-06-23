@isTest
public with sharing class ItemAlternateDefaults implements TestFactory.FieldDefaults{
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{
            'dmpl__QuantityAvailable__c' => 100.0,
            'dmpl__QuantityInHand__c' => 50.0
        };
    }
}