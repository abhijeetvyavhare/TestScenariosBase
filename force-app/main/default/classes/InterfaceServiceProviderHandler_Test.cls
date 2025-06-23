@isTest
public class InterfaceServiceProviderHandler_Test {
	@TestSetup
    static void createRequiredData() {
        Account partnerAccount = TestDataHelpers.createPartnerAccount();
        dmpl__InterfaceServiceProvider__c interfaceServiceProvider = InterfaceTestDataHelper.createInterfaceServiceProvider(partnerAccount);
    }

    @isTest
    static void createInterfaceServiceProviderPositive() {
        dmpl__InterfaceServiceProvider__c provider = InterfaceTestDataHelper.getInterfaceServiceProvider();
        System.assertNotEquals(provider, null, 'Expected InterfaceServiceProvider to be created.');
        System.assertEquals('Test1', provider.Name, 'Name should be Test1');
        System.assertEquals('tesrt', provider.dmpl__NamedCredentials__c, 'NamedCredentials should be tesrt');
        System.assertEquals('Callout', provider.dmpl__Logging__c, 'Logging should be Callout');
        System.assertEquals('www.rk.com', provider.dmpl__CustomCredentialsUrl__c, 'CustomCredentialsUrl should be www.rk.com');
        System.assertEquals('REST Client', provider.dmpl__ProviderType__c, 'ProviderType should be REST Client');
        System.assertNotEquals(provider.dmpl__PartnerAccountId__c, null, 'PartnerAccountId should be set');
    }

    @isTest
    static void updateInterfaceServiceProviderPositive() {
        dmpl__InterfaceServiceProvider__c provider = InterfaceTestDataHelper.getInterfaceServiceProvider();
        System.assertNotEquals(provider, null, 'InterfaceServiceProvider should exist before update.');

        provider.dmpl__Logging__c = 'None';
        provider.dmpl__CustomCredentialsUrl__c = 'https://updated-url.com';
        update provider;

        dmpl__InterfaceServiceProvider__c updatedProvider = InterfaceTestDataHelper.getInterfaceServiceProvider();
        System.assertEquals('None', updatedProvider.dmpl__Logging__c, 'Expected updated Logging value');
        System.assertEquals('https://updated-url.com', updatedProvider.dmpl__CustomCredentialsUrl__c, 'Expected updated CustomCredentialsUrl');
    }

    @isTest
    static void deleteInterfaceServiceProviderPositive() {
        dmpl__InterfaceServiceProvider__c provider = InterfaceTestDataHelper.getInterfaceServiceProvider();
        System.assertNotEquals(provider, null, 'InterfaceServiceProvider should exist before delete.');
        delete provider;
        dmpl__InterfaceServiceProvider__c deletedProvider = null;
        try {
            deletedProvider = InterfaceTestDataHelper.getInterfaceServiceProvider();
        } catch (Exception e) {
            deletedProvider = null;
        }

        System.assertEquals(null, deletedProvider, 'InterfaceServiceProvider should be deleted and not found in query.');
    }
}