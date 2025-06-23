@isTest
public with sharing class InterfaceServiceProviderTestDataHelpers {
    public static dmpl__InterfaceServiceProvider__c createInterfaceServiceProvider(
        Account partnerAccount,
        dmpl__Branch__c branch
    ) {
        return (dmpl__InterfaceServiceProvider__c) TestFactory.createSObject(
            new dmpl__InterfaceServiceProvider__c(
                dmpl__PartnerAccountId__c = partnerAccount.Id,
                dmpl__BranchId__c = branch.Id,
                Name = 'Test1',
                dmpl__NamedCredentials__c='testCredentials',
                dmpl__Logging__c='Callout',
                dmpl__CustomCredentialsUrl__c='www.rk.com',
                dmpl__ProviderType__c='REST Client'
            ),
            true
        );
    }

    public static dmpl__InterfaceServiceProvider__c getInterfaceServiceProvider() {
        return [SELECT 
            Id, 
            Name, 
            dmpl__PartnerAccountId__c, 
            dmpl__BranchId__c, 
            dmpl__NamedCredentials__c, 
            dmpl__Logging__c, 
            dmpl__CustomCredentialsUrl__c, 
            dmpl__ProviderType__c
        FROM dmpl__InterfaceServiceProvider__c LIMIT 1];
    }

    public static dmpl__InterfaceServiceProviderRequest__c CreateInterfaceServiceProviderRequest(
        dmpl__InterfaceServiceProvider__c interfaceService
    ){
        return (dmpl__InterfaceServiceProviderRequest__c) TestFactory.createSObject(
            new dmpl__InterfaceServiceProviderRequest__c(
                dmpl__CustomFunction__c='TEXT1',
                dmpl__EndPoint__c='TEXT2',
                dmpl__Function__c='Custom Function',
                dmpl__HttpHeaders__c='tEST3',
                dmpl__IsAsynchronous__c=FALSE,
                dmpl__PayloadSchema__c='GFGFDHBDFJBD',
                dmpl__ResponseSchema__c='DBHDFBDBJSB',
                dmpl__StatusEndPoint__c='CHCVCVMCVNMCV',
                dmpl__StatusPayloadSchema__c='BCHCVHBVCJCBBCJBCJBC',
                dmpl__StatusResponseSchema__c='BB CB D C',
                dmpl__InterfaceServiceProviderId__c=interfaceService.Id,
                dmpl__HttpVerb__c='GET',
                dmpl__HttpQuery__c='vdhdvhd'
            ),
            true
        );
    }

    public static dmpl__InterfaceServiceProviderRequest__c getInterfaceServiceProviderRequest() {
        return [SELECT 
            Id, 
            Name, 
            dmpl__CustomFunction__c, 
            dmpl__EndPoint__c, 
            dmpl__Function__c, 
            dmpl__HttpHeaders__c, 
            dmpl__IsAsynchronous__c, 
            dmpl__PayloadSchema__c, 
            dmpl__ResponseSchema__c, 
            dmpl__StatusEndPoint__c, 
            dmpl__StatusPayloadSchema__c, 
            dmpl__StatusResponseSchema__c, 
            dmpl__InterfaceServiceProviderId__c, 
            dmpl__HttpVerb__c, 
            dmpl__HttpQuery__c
        FROM dmpl__InterfaceServiceProviderRequest__c LIMIT 1];
    }

    public static dmpl__InterfaceQueue__c createInterfaceQueue(
        dmpl__InterfaceServiceProvider__c interfaceService,
        dmpl__InterfaceServiceProviderRequest__c interfaceRequest
    ) {
        return (dmpl__InterfaceQueue__c) TestFactory.createSObject(
            new dmpl__InterfaceQueue__c(
                dmpl__InterfaceProviderId__c =interfaceService.Id,
                dmpl__QueueType__c = 'Queueable',
                dmpl__InterfaceRequestId__c = interfaceRequest.Id,
                dmpl__JobType__c = 'Account Group Member Processor'
            ),
            true
        );
    }

    public static dmpl__InterfaceQueue__c getInterfaceQueue() {
        return [SELECT 
            Id, 
            Name, 
            dmpl__InterfaceProviderId__c, 
            dmpl__QueueType__c, 
            dmpl__InterfaceRequestId__c, 
            dmpl__JobType__c
        FROM dmpl__InterfaceQueue__c LIMIT 1];
    }
}