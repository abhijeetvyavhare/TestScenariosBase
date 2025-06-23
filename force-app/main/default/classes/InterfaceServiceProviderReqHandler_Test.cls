@isTest
public with sharing class InterfaceServiceProviderReqHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Account partnerAccount = TestDataHelpers.createPartnerAccount();
        dmpl__InterfaceServiceProvider__c interfaceServiceProvider = InterfaceTestDataHelper.createInterfaceServiceProvider(partnerAccount);
        dmpl__InterfaceServiceProviderRequest__c interfaceServiceProviderRequest = InterfaceTestDataHelper.createInterfaceServiceProviderRequest(interfaceServiceProvider);
    }

    @isTest
    static void createInterfaceServiceProviderRequestPositive() {
        dmpl__InterfaceServiceProviderRequest__c request = InterfaceTestDataHelper.getInterfaceServiceProviderRequest();
        if (request != null) {
        System.assertNotEquals(request, null, 'Expected request to be created.');
    }
        System.assertNotEquals(request, null, 'Expected InterfaceServiceProviderRequest to be created.');
        System.assertEquals('File1', request.dmpl__FileName__c, 'FileName should be File1');
        System.assertEquals('Endpoint1', request.dmpl__EndPoint__c, 'EndPoint should be Endpoint1');
        System.assertNotEquals(request.dmpl__InterfaceServiceProviderId__c, null, 'InterfaceServiceProviderId should be set');
    }

    @isTest
    static void updateInterfaceServiceProviderRequestPositive() {
        dmpl__InterfaceServiceProviderRequest__c request = InterfaceTestDataHelper.getInterfaceServiceProviderRequest();
        System.assertNotEquals(request, null, 'InterfaceServiceProviderRequest should exist before update.');
        request.dmpl__FileName__c = 'UpdatedFile';
        request.dmpl__EndPoint__c = 'UpdatedEndpoint';
        update request;
        dmpl__InterfaceServiceProviderRequest__c updatedRequest = InterfaceTestDataHelper.getInterfaceServiceProviderRequest();
        System.assertEquals('UpdatedFile', updatedRequest.dmpl__FileName__c, 'Expected updated FileName');
        System.assertEquals('UpdatedEndpoint', updatedRequest.dmpl__EndPoint__c, 'Expected updated EndPoint');
    }

    @isTest
    static void deleteInterfaceServiceProviderRequestPositive() {
        dmpl__InterfaceServiceProviderRequest__c request = InterfaceTestDataHelper.getInterfaceServiceProviderRequest();
        System.assertNotEquals(request, null, 'InterfaceServiceProviderRequest should exist before delete.');
        delete request;
        dmpl__InterfaceServiceProviderRequest__c deletedRequest = null;
        try {
            deletedRequest = InterfaceTestDataHelper.getInterfaceServiceProviderRequest();
        } catch (Exception e) {
            deletedRequest = null;
        }
        System.assertEquals(null, deletedRequest, 'InterfaceServiceProviderRequest should be deleted and not found in query.');
    }
}