@isTest
public with sharing class ItemGroupDefaults implements TestFactory.FieldDefaults{
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{ 
             'dmpl__Description__c' => 'Test Description'
        };
    }
}