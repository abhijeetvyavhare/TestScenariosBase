@isTest
public with sharing class FulfillmentOrderLineDefaults implements TestFactory.FieldDefaults {
    
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{ 
            'dmpl__CancelledQuantity__c' => 1,
            'dmpl__IsILPosted__c' => true,
            'dmpl__IsILPostingApproved__c' => true,
            'dmpl__LimitExpiryDays__c' => null,
            //'dmpl__Quantity__c' => 1,
            'dmpl__UnitCost__c' => 100
        };
    }
}