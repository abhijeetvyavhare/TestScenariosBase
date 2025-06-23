@isTest
public with sharing class InterfaceServiceProviderRequestDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{
            'dmpl__FileName__c' => 'File1',
            'dmpl__EndPoint__c' => 'Endpoint1'
        };
    }
}