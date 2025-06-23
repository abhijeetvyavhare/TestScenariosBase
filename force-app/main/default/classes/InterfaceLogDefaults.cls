@isTest
public with sharing class InterfaceLogDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{
            'dmpl__EndPoint__c' => 'InterfaceLog EndPoint',
            'dmpl__Method__c' => 'Demo1',
            'dmpl__HttpResponseCode__c' => 'Log Response Code'
        };
    }
}