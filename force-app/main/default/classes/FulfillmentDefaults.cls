@isTest
public with sharing class FulfillmentDefaults implements TestFactory.FieldDefaults {
    
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{ 
            'dmpl__DocumentDate__c' =>System.today(), 
            'dmpl__IsInJobQueue__c' => true,
            'dmpl__IsPicked__c' => true,
            'dmpl__IsAllocated__c' => true,
            'dmpl__PerformAllocation__c' => true,
            'dmpl__PerformCancelAllocation__c' => true,
            'dmpl__PerformCancelPicking__c' => true,
            'dmpl__PerformPicking__c' => true,
            'dmpl__Status__c' => 'Draft'
        };
    }
}