@isTest
public with sharing class SKUDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{ 
            'Name'=>'Test SKU',
            'dmpl__IsDefault__c'=>true
        };
    }
}