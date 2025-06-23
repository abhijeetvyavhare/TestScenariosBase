public with sharing class ErrorLogDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{
            'dmpl__Type__c' => 'Info',
            'dmpl__Message__c' => 'Error Message'
        };
    }
}