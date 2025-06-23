@isTest
public with sharing class InventoryAdjustmentDefaults  implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{ 
            'dmpl__DocumentDate__c' => System.today(),     
            'dmpl__IsInJobQueue__c' => false,
            'dmpl__PerformInventoryPosting__c' => true,
            'dmpl__PriceAsOnDate__c' => System.today(),
            'dmpl__Status__c' => 'Draft'
        };
    }  
}