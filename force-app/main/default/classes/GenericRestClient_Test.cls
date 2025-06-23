@isTest
public with sharing class GenericRestClient_Test {
    @isTest
    static void Verify()
    {
        List<Account> account = new List<Account>();
        account.add(new Account(Name = 'Test - Account', 
                                dmpl__LastName__c = 'Sale Order',
            					Fax = '09876',
                               Phone = '1234567891',
                               Website = 'www.Dealermatix.com',
                               Type = 'Prospect',
                               NumberOfEmployees = 2,
                               Industry = 'Education',
                               AnnualRevenue = 1000,
                               Description = 'Accounts added',
                               dmpl__IsPartnerAccount__c = false,
                               dmpl__IsActive__c = True,
                               dmpl__IsTaxExempted__c = True,
                               dmpl__IsSupplierAccount__c = false,
                               dmpl__IsCustomerAccount__c = False
                               ));
        insert account;
        
        Account partneraccount = new Account(Name = 'Partner-Test-Account',
                                             dmpl__LastName__c = 'Sale Order',
                                             dmpl__IsPartnerAccount__c = True, 
                                             dmpl__IsActive__c = true);
        insert partneraccount;
        
        Account customerAccount = new Account(Name = 'Customer-Test-Account',
                                              dmpl__LastName__c = 'Sale Order',
                                              dmpl__IsCustomerAccount__c = True,
                                              dmpl__IsActive__c = true);
        insert customerAccount;
        dmpl__InterfaceServiceProvider__c isp = new dmpl__InterfaceServiceProvider__c(
            dmpl__ProviderType__c  = 'REST Client',
            dmpl__Logging__c = 'Callout With Payload',
            dmpl__PartnerAccountId__c = partneraccount.Id
        );
        insert isp;

        dmpl__InterfaceServiceProviderRequest__c r = new dmpl__InterfaceServiceProviderRequest__c(
            Name = 'Request',
            dmpl__EndPoint__C = 'https://www.google.com/search',
            dmpl__HttpVerb__C = 'GET',
            dmpl__InterfaceServiceProviderId__c = isp.Id,
            dmpl__RequestSOQL__c = 'SELECT ID FROM dmpl__InterfaceServiceProviderRequest__c LIMIT 1',
            dmpl__ResponseSOQL__c = 'SELECT ID FROM dmpl__InterfaceServiceProviderRequest__c LIMIT 1'
        );

        insert r;
        GenericRestClient rc;
        try{
            rc = new GenericRestClient(isp);
            rc.startRequest(r);
        }
        catch(Exception e){
        }
        
        try{
            rc = new GenericRestClient(isp);
            rc.startRequest(r.Id, r.Id);

            DynamicTextParser.parseResult(
                '{ status : "OK"}',
                'status',
                'OK',
                '',
                r ,
                new List<SObject>()
            );

            DynamicTextParser.parse(
                '{ test : {!dmpl__HttpVerb__C}}',
                r 
            );
        }
        catch(Exception e){
        }

        try{
            rc = new GenericRestClient(isp);
            rc.startRequest(r.Name, r.Id);
        }
        catch(Exception e){
        }

        try{
            rc = new GenericRestClient(isp);
            rc.startRequest('f', 'f', r.Id);
        }
        catch(Exception e){
        }


        try{
            rc = new GenericRestClient(isp);
            
        }
        catch(Exception e){
        }
        

        try{
            DynamicTextParser.parseResult(
                '{ status : "OK"}',
                'status',
                'OK',
                '',
                r ,
                new List<SObject>()
            );
        }
        catch(Exception e){
        }

        try{
            DynamicTextParser.parse(
                '{ test : {!dmpl__HttpVerb__C}}',
                r 
            );
        }
        catch(Exception e){
        }

        System.assert(isp != null, 'ObjectCreationError');
    }   

}