public with sharing class ResourceBusinessHoursDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{ 
            'dmpl__FromDate__c' => null,
            'dmpl__BusinessHoursId__c' => null,
            'dmpl__ResourceId__c' => null,
            'dmpl__ToDate__c' => null
        };
    }
}