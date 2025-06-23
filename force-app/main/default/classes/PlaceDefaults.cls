public with sharing class PlaceDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{
            'dmpl__Level__c' => 2,
            'Name' => 'Places Test',
            'dmpl__PlaceType__c' => 'City'
        };
    }
}