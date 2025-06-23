@isTest
public with sharing class InterfaceTestDataHelper {
    public static dmpl__InterfaceLog__c createInterfaceLog() {
        return (dmpl__InterfaceLog__c) TestFactory.createSObject(
            new dmpl__InterfaceLog__c(
                dmpl__EndPoint__c = 'InterfaceLog EndPoint',
                dmpl__Method__c = 'Demo1',
                dmpl__HttpResponseCode__c = 'Log Response Code'
            ),
            'InterfaceLogDefaults',
            true
        );
    }

    public static dmpl__InterfaceLog__c getInterfaceLog() {
        return [
            SELECT 
             dmpl__EndPoint__c,
             dmpl__Method__c,
             dmpl__HttpResponseCode__c
            FROM dmpl__InterfaceLog__c LIMIT 1
        ];
        
    }

    public static dmpl__InterfaceServiceProvider__c createInterfaceServiceProvider(Account partnerAccount){
        return (dmpl__InterfaceServiceProvider__c) TestFactory.createSObject(
            new dmpl__InterfaceServiceProvider__c(
                dmpl__PartnerAccountId__c = partnerAccount.Id,
                Name = 'Test1',
                dmpl__NamedCredentials__c='tesrt',
                dmpl__Logging__c='Callout',
                dmpl__CustomCredentialsUrl__c='www.rk.com',
                dmpl__ProviderType__c='REST Client'
            ),
            'InterfaceServiceProviderDefaults',
            true
        );
    }

    public static dmpl__InterfaceServiceProvider__c getInterfaceServiceProvider() {
        return [
            SELECT 
            dmpl__PartnerAccountId__c,
            Name,
            dmpl__NamedCredentials__c,
            dmpl__Logging__c,
            dmpl__CustomCredentialsUrl__c,
            dmpl__ProviderType__c
            FROM dmpl__InterfaceServiceProvider__c 
            LIMIT 1
        ];
        
    }

    public static dmpl__InterfaceServiceProviderRequest__c createInterfaceServiceProviderRequest(dmpl__InterfaceServiceProvider__c interfaceServiceProvider){
        return (dmpl__InterfaceServiceProviderRequest__c) TestFactory.createSObject(
            new dmpl__InterfaceServiceProviderRequest__c(
                dmpl__InterfaceServiceProviderId__c= interfaceServiceProvider.Id,
                dmpl__FileName__c = 'File1',
                dmpl__EndPoint__c = 'Endpoint1'
                
            ),
            'InterfaceServiceProviderRequestDefaults',
            true
        );
    }

    public static dmpl__InterfaceServiceProviderRequest__c getInterfaceServiceProviderRequest() {
        return [
            SELECT 
            dmpl__InterfaceServiceProviderId__c,
            dmpl__FileName__c,
            dmpl__EndPoint__c
            FROM dmpl__InterfaceServiceProviderRequest__c LIMIT 1
        ];
        
    }
}