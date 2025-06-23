@isTest
public with sharing class FulfillmentPickingLineDefaults implements TestFactory.FieldDefaults {
    
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{ 
            'dmpl__CancelQuantity__c' => 1, 
            //'dmpl__Quantity__c' => 1,
            'dmpl__DeliveryQuantity__c' => 1,
            'dmpl__DocumentDate__c' => null,
            'dmpl__IsILPosted__c' => true,
            'dmpl__IsILPostingApproved__c' => true,
            'dmpl__IsPickingConfirmed__c' => true,
            'dmpl__RequestedQuantity__c' => 1,
            //'dmpl__ReturnedQuantity__c' => 1,
            'dmpl__UnitCost__c' => 100
        };
    }
}