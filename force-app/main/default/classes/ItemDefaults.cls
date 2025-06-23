@isTest
public with sharing class ItemDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{ 
            'Name' => 'Test Item',
            'dmpl__ItemCode__c' => 'TEST123',
            'dmpl__TrackLots__c' => false,
            'dmpl__ServiceDurationInMinutes__c' => 40,
            'dmpl__IsPackage__c' => true   
        };
    }
}