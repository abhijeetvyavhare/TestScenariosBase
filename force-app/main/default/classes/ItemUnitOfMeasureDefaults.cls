@isTest
public with sharing class ItemUnitOfMeasureDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{ 
            'dmpl__ConversionRatio__c' => 1,
            'Name' => 'Test UOM'
            
        };
    }
}