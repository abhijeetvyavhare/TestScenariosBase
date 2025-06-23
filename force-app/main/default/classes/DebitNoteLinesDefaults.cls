@isTest
public with sharing class DebitNoteLinesDefaults implements TestFactory.FieldDefaults{
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{ 
            'dmpl__Amount__c' => 20,
            'dmpl__Description__c' => 'Test'
        };
    }
}