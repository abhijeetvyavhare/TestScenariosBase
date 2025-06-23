public with sharing class AdjustmentDefaults implements TestFactory.FieldDefaults {
    
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{ 
            'Name'=>'Adjustment1',
            'dmpl__DocumentDate__c' =>System.today(),     
            'dmpl__IsInJobQueue__c'=>false,
            'dmpl__IsInventoryPosted__c'=>true,
            'dmpl__PerformInventoryPosting__c'=>true,
            'dmpl__PriceAsOnDate__c'=>null,
            'dmpl__Status__c'=>'draft'
        };
    }
  
}