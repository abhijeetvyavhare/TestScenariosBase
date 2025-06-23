@isTest
public with sharing class ItemFeatureDefaults implements TestFactory.FieldDefaults{
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{ 
            'Name' => 'Test Feature',
            'dmpl__MaxComponentCount__c' => 1,
            'dmpl__MinComponentCount__c' => 1
              
        };  
}
}