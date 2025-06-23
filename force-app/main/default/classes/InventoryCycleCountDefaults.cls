@isTest
public with sharing class InventoryCycleCountDefaults implements TestFactory.FieldDefaults {
    
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{ 
            'dmpl__PerformStartCounting__c' => false,
            'dmpl__PerformFinishCounting__c' => false,                                                 
            'dmpl__PerformReleaseAdjustment__c' => false,
            'dmpl__PartCostFrom__c' => 40,
            'dmpl__PartCostTo__c' => 50
        };
    }
}