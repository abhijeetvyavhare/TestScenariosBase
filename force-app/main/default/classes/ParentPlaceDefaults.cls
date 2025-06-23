@isTest
public with sharing class ParentPlaceDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{
            'dmpl__Level__c' => 22,
            'dmpl__PlaceType__c' => 'City'
        };
    }
}