@isTest
public with sharing class AutoPurchaseOrderLineDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{ 
            'dmpl__Quantity__c' => 1,
            'dmpl__MaximumQuantity__c' => 1,
            'dmpl__MinimumQuantity__c' => 1
        
        };
    }
}