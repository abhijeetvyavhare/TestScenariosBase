public with sharing class ResourceLeaveDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{ 
            'dmpl__Available__c' => 10,
            'dmpl__Balance__c' => 10
        };
    }
}