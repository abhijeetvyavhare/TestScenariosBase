@isTest
public with sharing class InterfaceServiceProviderDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{
            'Name' => 'Test1',
            'dmpl__NamedCredentials__c' => 'tesrt',
            'dmpl__Logging__c' => 'Callout',
            'dmpl__CustomCredentialsUrl__c' => 'www.rk.com',
            'dmpl__ProviderType__c' => 'REST Client'
        };
    }
}