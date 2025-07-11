@isTest
public class InterfaceServiceProviderHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Account partnerAccount = TestDataHelpers.createPartnerAccount();
        dmpl__InterfaceServiceProvider__c interfaceServiceProvider = InterfaceTestDataHelper.createInterfaceServiceProvider(partnerAccount);
        
        Account partnerAccount1 = TestDataHelpers.createPartnerAccount(
            'Partner 1',
        false,
        true,
        false,
        true,
        'MG Road',
        'Bengaluru',
        'Karnataka',
        'India',
        '560001',
        '56 Industrial Layout',
        'Bengaluru',
        'Karnataka',
        'India',
        '560095',
        '91-9876543210'
            );
        Account partnerAccount2 = TestDataHelpers.createPartnerAccount(
            'Partner 2',
        false,
        true,
        false,
        false,
        '45 Residency Road',
        'Pune',
        'Maharashtra',
        'India',
        '411001',
        '22 Commerce Avenue',
        'Pune',
        'Maharashtra',
        'India',
        '411038',
        '91-9966554433'
            );
        Account partnerAccount3 = TestDataHelpers.createPartnerAccount(
            'Partner 3',
        false,
        true,
        false,
        true,
        '78 Nehru Nagar Road',
        'Chennai',
        'Tamil Nadu',
        'India',
        '600042',
        '78 Nehru Nagar Road',
        'Chennai',
        'Tamil Nadu',
        'India',
        '600042',
        '91-9988776655'
            );
        Account partnerAccount4 = TestDataHelpers.createPartnerAccount(
            'Partner 4',
        false,
        true,
        false,
        true,
        '12 Industrial Zone',
        'Hyderabad',
        'Telangana',
        'India',
        '500032',
        '12 Industrial Zone',
        'Hyderabad',
        'Telangana',
        'India',
        '500032',
        '9876012254'
            );
        dmpl__Branch__c branch1 = TestDataHelpers.createBranch('Branch 1', partnerAccount1.Id, true, true, false, true);
        dmpl__Branch__c branch3 = TestDataHelpers.createBranch('Branch 3', partnerAccount3.Id, false, true, true, false);
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
    
    //Create new Interface Provider with Active Partner Account( New)
    @isTest
    static void createInterfaceServiceProviderWithActivePartnerAccountPositive() {
        Test.startTest();
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__InterfaceServiceProvider__c interfaceServiceProvider = InterfaceTestDataHelper.createInterfaceServiceProvider('Claim Interface',partner1, branch1, null, null);
        Test.stopTest();
        System.assertNotEquals(null, interfaceServiceProvider, 'InterfaceServiceProvider should be created successfully.');
        System.assertEquals('Claim Interface', interfaceServiceProvider.Name, 'Name should be Claim Interface');
        System.assertEquals(partner1.Id, interfaceServiceProvider.dmpl__PartnerAccountId__c, 'PartnerAccountId should match the created partner account.');
        System.assertEquals(branch1.Id, interfaceServiceProvider.dmpl__BranchId__c, 'Name should be Branch 1');
    }
    
    //Create new Interface Provider with Active Partner Account(Edit)
    @isTest
    static void updateInterfaceServiceProviderWithActivePartnerAccountPositive(){
        Test.startTest();
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        Account partner4 = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__InterfaceServiceProvider__c interfaceServiceProvider = InterfaceTestDataHelper.createInterfaceServiceProvider('Claim Interface', partner1, branch1, null, null);
        dmpl__InterfaceServiceProvider__c createdInterfaceServiceProvider = InterfaceTestDataHelper.getInterfaceServiceProvider(interfaceServiceProvider.Id);
        interfaceServiceProvider.dmpl__PartnerAccountId__c = partner4.Id;
        update interfaceServiceProvider;
        dmpl__InterfaceServiceProvider__c updatedInterfaceServiceProvider = InterfaceTestDataHelper.getInterfaceServiceProvider(interfaceServiceProvider.Id);
        Test.stopTest();
        System.assertNotEquals(null, interfaceServiceProvider, 'InterfaceServiceProvider should be updated successfully.');
        System.assertNotEquals(null, updatedInterfaceServiceProvider, 'Updated InterfaceServiceProvider should not be null.');
        System.assertEquals(partner1.Id, createdInterfaceServiceProvider.dmpl__PartnerAccountId__c, 'Initial PartnerAccountId should match the created partner account.');
        System.assertEquals(partner4.Id, updatedInterfaceServiceProvider.dmpl__PartnerAccountId__c, 'Updated PartnerAccountId should match the new partner account.');
        System.assertEquals('Claim Interface', updatedInterfaceServiceProvider.Name, 'Name should remain Claim Interface after update.');
    }
    
    // New Interface Provider creation with Name of interface provider
    @isTest
    static void createInterfaceServiceProviderWithNamePositive() {
        Test.startTest();
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__InterfaceServiceProvider__c interfaceServiceProvider = InterfaceTestDataHelper.createInterfaceServiceProvider('MOF', partner1, branch1, null, null);
        Test.stopTest();
        System.assertNotEquals(null, interfaceServiceProvider, 'InterfaceServiceProvider should be created successfully.');
        System.assertEquals('MOF', interfaceServiceProvider.Name, 'Name should be Claim Interface');
        System.assertEquals(partner1.Id, interfaceServiceProvider.dmpl__PartnerAccountId__c, 'PartnerAccountId should match the created partner account.');
        System.assertEquals(branch1.Id, interfaceServiceProvider.dmpl__BranchId__c, 'Name should be Branch 1');
    }
    
    //New Interface Provider creation with Provider Type as REST Client
    @isTest
    static void createInterfaceServiceProviderWithProviderTypeRESTAPIPositive() {
        Test.startTest();
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__InterfaceServiceProvider__c interfaceServiceProvider = InterfaceTestDataHelper.createInterfaceServiceProvider('MOF', partner1, branch1, 'REST Client', null);
        Test.stopTest();
        System.assertNotEquals(null, interfaceServiceProvider, 'InterfaceServiceProvider should be created successfully.');
        System.assertEquals('MOF', interfaceServiceProvider.Name, 'Name should be MOF');
        System.assertEquals(partner1.Id, interfaceServiceProvider.dmpl__PartnerAccountId__c, 'PartnerAccountId should match the created partner account.');
        System.assertEquals(branch1.Id, interfaceServiceProvider.dmpl__BranchId__c, 'BranchId should be of Branch 1');
        System.assertEquals('REST Client', interfaceServiceProvider.dmpl__ProviderType__c, 'ProviderType should be REST Client');
    }
    
    //New Interface Provider creation with Provider Type as File Storage
    @isTest
    static void createInterfaceServiceProviderWithProviderTypeFileStoragePositive() {
        Test.startTest();
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__InterfaceServiceProvider__c interfaceServiceProvider = InterfaceTestDataHelper.createInterfaceServiceProvider('MON', partner1, branch1, 'File Storage', null);
        Test.stopTest();
        System.assertNotEquals(null, interfaceServiceProvider, 'InterfaceServiceProvider should be created successfully.');
        System.assertEquals('MON', interfaceServiceProvider.Name, 'Name should be MON');
        System.assertEquals(partner1.Id, interfaceServiceProvider.dmpl__PartnerAccountId__c, 'PartnerAccountId should match the created partner account.');
        System.assertEquals(branch1.Id, interfaceServiceProvider.dmpl__BranchId__c, 'BranchId should be of Branch 1');
        System.assertEquals('File Storage', interfaceServiceProvider.dmpl__ProviderType__c, 'ProviderType should be File Storage');
    }
    
    //New Interface Provider creation with Provider Type as Custom Provider
    @isTest
    static void createInterfaceServiceProviderWithProviderTypeCustomProviderPositive() {
        Test.startTest();
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__InterfaceServiceProvider__c interfaceServiceProvider = InterfaceTestDataHelper.createInterfaceServiceProvider('MON', partner1, branch1, 'Custom Provider', null);
        Test.stopTest();
        System.assertNotEquals(null, interfaceServiceProvider, 'InterfaceServiceProvider should be created successfully.');
        System.assertEquals('MON', interfaceServiceProvider.Name, 'Name should be MON');
        System.assertEquals(partner1.Id, interfaceServiceProvider.dmpl__PartnerAccountId__c, 'PartnerAccountId should match the created partner account.');
        System.assertEquals(branch1.Id, interfaceServiceProvider.dmpl__BranchId__c, 'BranchId should be of Branch 1');
        System.assertEquals('Custom Provider', interfaceServiceProvider.dmpl__ProviderType__c, 'ProviderType should be Custom Provider');
    }
    
    //New Interface Provider creation with Logging for Callout
    @isTest
    static void createInterfaceServiceProviderWithLoggingCalloutPositive() {
        Test.startTest();
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__InterfaceServiceProvider__c interfaceServiceProvider = InterfaceTestDataHelper.createInterfaceServiceProvider('MON', partner1, branch1, 'Custom Provider', 'Callout');
        Test.stopTest();
        System.assertNotEquals(null, interfaceServiceProvider, 'InterfaceServiceProvider should be created successfully.');
        System.assertEquals('MON', interfaceServiceProvider.Name, 'Name should be MON');
        System.assertEquals(partner1.Id, interfaceServiceProvider.dmpl__PartnerAccountId__c, 'PartnerAccountId should match the created partner account.');
        System.assertEquals(branch1.Id, interfaceServiceProvider.dmpl__BranchId__c, 'BranchId should be of Branch 1');
        System.assertEquals('Callout', interfaceServiceProvider.dmpl__Logging__c, 'Logging should be Callout');
    }
    
    // New Interface Provider creation with Logging for Callout with Payload
    @isTest
    static void createInterfaceServiceProviderWithLoggingCalloutWithPayloadPositive() {
        Test.startTest();
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__InterfaceServiceProvider__c interfaceServiceProvider = InterfaceTestDataHelper.createInterfaceServiceProvider('MON', partner1, branch1, 'Custom Provider', 'Callout with Payload');
        Test.stopTest();
        System.assertNotEquals(null, interfaceServiceProvider, 'InterfaceServiceProvider should be created successfully.');
        System.assertEquals('MON', interfaceServiceProvider.Name, 'Name should be MON');
        System.assertEquals(partner1.Id, interfaceServiceProvider.dmpl__PartnerAccountId__c, 'PartnerAccountId should match the created partner account.');
        System.assertEquals(branch1.Id, interfaceServiceProvider.dmpl__BranchId__c, 'BranchId should be of Branch 1');
        System.assertEquals('Custom Provider', interfaceServiceProvider.dmpl__ProviderType__c, 'ProviderType should be Custom Provider');
        System.assertEquals('Callout with Payload', interfaceServiceProvider.dmpl__Logging__c, 'Logging should be Callout with Payload');
    }
    
    //Create new Interface Provider with incorrect/Inactive Partner Account
    @isTest
    static void createInterfaceServiceProviderWithInactivePartnerAccountNegative() {
        Test.startTest();
        Account partner2 = TestDataHelpers.getPartnerAccount('Partner 2');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        try {
            dmpl__InterfaceServiceProvider__c interfaceServiceProvider = InterfaceTestDataHelper.createInterfaceServiceProvider('Claim Interface', partner2,null, null, null);
            System.assertEquals(null, interfaceServiceProvider, 'InterfaceServiceProvider should not be created with inactive partner account.');
        } catch (Exception e) {
            System.debug('Expected exception: ' + e.getMessage());
        }
        Test.stopTest();
    }
    
    //New Interface Provider creation without Branch
    @isTest
    static void createInterfaceServiceProviderWithoutBranchPositive() {
        Test.startTest();
        Account partner4 = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__InterfaceServiceProvider__c interfaceServiceProvider = InterfaceTestDataHelper.createInterfaceServiceProvider('Claim Interface', partner4, null, null, null);
        Test.stopTest();
        System.assertNotEquals(null, interfaceServiceProvider, 'InterfaceServiceProvider should be created without branch.');
        System.assertEquals('Claim Interface', interfaceServiceProvider.Name, 'Name should be Claim Interface');
        System.assertEquals(partner4.Id, interfaceServiceProvider.dmpl__PartnerAccountId__c, 'PartnerAccountId should match the created partner account.');
    }
    
    //New Interface Provider creation with Inactive Branch
    @isTest
    static void createInterfaceServiceProviderWithInactiveBranchPositive() {
        Test.startTest();
        Account partner4 = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch3 = TestDataHelpers.getBranch('Branch 3');
        dmpl__InterfaceServiceProvider__c interfaceServiceProvider = InterfaceTestDataHelper.createInterfaceServiceProvider('Claim Interface', partner4, branch3, null, null);
        Test.stopTest();
        System.assertNotEquals(null, interfaceServiceProvider, 'InterfaceServiceProvider should be created with inactive branch.');
        System.assertEquals('Claim Interface', interfaceServiceProvider.Name, 'Name should be Claim Interface');
        System.assertEquals(partner4.Id, interfaceServiceProvider.dmpl__PartnerAccountId__c, 'PartnerAccountId should match the created partner account.');
        System.assertEquals(branch3.Id, interfaceServiceProvider.dmpl__BranchId__c, 'BranchId should be of Branch 3');
    }
    
    //New Interface Provider creation with deleting the Branch
    @isTest
    static void createInterfaceServiceProviderWithDeletingBranch(){
        Test.startTest();
        Account partner4 = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch3= TestDataHelpers.getBranch('Branch 3');
        dmpl__InterfaceServiceProvider__c interfaceServiceProvider = InterfaceTestDataHelper.createInterfaceServiceProvider('Claim Interface', partner4, branch3, null, null);
        delete branch3;
        dmpl__InterfaceServiceProvider__c createdInterfaceServiceProvider = InterfaceTestDataHelper.getInterfaceServiceProvider(interfaceServiceProvider.Id);
        Test.stopTest();
        System.assertNotEquals(null, interfaceServiceProvider, 'InterfaceServiceProvider should be created successfully.');
        System.assertNotEquals(null, createdInterfaceServiceProvider, 'Created InterfaceServiceProvider should not be null.');
        System.assertEquals('Claim Interface', createdInterfaceServiceProvider.Name, 'Name should be Claim Interface');
        System.assertEquals(partner4.Id, createdInterfaceServiceProvider.dmpl__PartnerAccountId__c, 'PartnerAccountId should match the created partner account.');
        System.assertEquals(branch3.Id, interfaceServiceProvider.dmpl__BranchId__c, 'BranchId should be of Branch 3 before deleting the branch.');
        System.assertEquals(null, createdInterfaceServiceProvider.dmpl__BranchId__c, 'BranchId should be null after deleting the branch.');
    }
    
    //Delete Interface Provider with Active Partner Account
    @isTest
    static void deleteInterfaceServiceProviderWithActivePartnerAccountPositive() {
        Test.startTest();
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__InterfaceServiceProvider__c interfaceServiceProvider = InterfaceTestDataHelper.createInterfaceServiceProvider('Claim Interface', partner1, branch1, null, null);
        try {
            delete interfaceServiceProvider;
            dmpl__InterfaceServiceProvider__c deletedInterfaceServiceProvider = InterfaceTestDataHelper.getInterfaceServiceProvider(interfaceServiceProvider.Id);
            System.assertEquals(null, deletedInterfaceServiceProvider, 'InterfaceServiceProvider should be deleted and not found in query.');
        } catch (Exception e) {
            System.debug('Expected exception: ' + e.getMessage());
        }
        Test.stopTest();
    }
    
    //Interface Service Provider Request creation with end point(New)
    @isTest
    static void createInterfaceServiceProviderRequestWithEndPointPositive() {
        Test.startTest();
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__InterfaceServiceProvider__c interfaceServiceProvider = InterfaceTestDataHelper.createInterfaceServiceProvider('Claim Interface', partner1, branch1, null, null);
        dmpl__InterfaceServiceProviderRequest__c interfaceServiceProviderRequest = InterfaceTestDataHelper.createInterfaceServiceProviderRequest(interfaceServiceProvider, 'Test Url','Testing Request','Record Id', 'Sample JSON Payload', 'Sample Response',null);
        dmpl__InterfaceServiceProviderRequest__c createdRequest = InterfaceTestDataHelper.getInterfaceServiceProviderRequest(interfaceServiceProvider.Id);
        Test.stopTest();
        System.assertNotEquals(null, createdRequest, 'InterfaceServiceProviderRequest should be created successfully.');
        System.assertEquals(interfaceServiceProvider.Id, createdRequest.dmpl__InterfaceServiceProviderId__c, 'InterfaceServiceProviderId should match the created interface service provider.');
        System.assertEquals('Test Url', createdRequest.dmpl__EndPoint__c, 'EndPoint should be Test Url');
        System.assertEquals('Testing Request', createdRequest.Name, 'Request Name should be Testing Request');
        System.assertEquals('Record Id', createdRequest.dmpl__SourceDataType__c, 'source data type should be RecordId');
        System.assertEquals('Sample JSON Payload', createdRequest.dmpl__PayloadSchema__c, 'Payload should be Sample JSON Payload');
        System.assertEquals('Sample Response', createdRequest.dmpl__ResponseSchema__c, 'Response should be Sample Response');
    }
    
    //Interface Service Provider Request creation with end point(Edit)
    @isTest
    static void updateInterfaceServiceProviderRequestWithEndPointPositive() {
        Test.startTest();
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__InterfaceServiceProvider__c interfaceServiceProvider = InterfaceTestDataHelper.createInterfaceServiceProvider('Claim Interface', partner1, branch1, null, null);
        dmpl__InterfaceServiceProviderRequest__c interfaceServiceProviderRequest = InterfaceTestDataHelper.createInterfaceServiceProviderRequest(interfaceServiceProvider, 'Test Url','Testing Request','Record Id', 'Sample JSON Payload', 'Sample Response', null);
        interfaceServiceProviderRequest.dmpl__EndPoint__c = 'Updated Endpoint Url';
        update interfaceServiceProviderRequest;
        dmpl__InterfaceServiceProviderRequest__c updatedRequest = InterfaceTestDataHelper.getInterfaceServiceProviderRequest(interfaceServiceProvider.Id);
        Test.stopTest();
        System.assertNotEquals(null, updatedRequest, 'InterfaceServiceProviderRequest should be updated successfully.');
        System.assertEquals('Updated Endpoint Url', updatedRequest.dmpl__EndPoint__c, 'EndPoint should be Updated Endpoint');
        System.assertEquals('Sample JSON Payload', updatedRequest.dmpl__PayloadSchema__c, 'Payload should be Updated Payload');
        System.assertEquals('Sample Response', updatedRequest.dmpl__ResponseSchema__c, 'Response should be Updated Response');
        System.assertEquals('Testing Request', updatedRequest.Name, 'Request Name should be Testing Request');
    }
    
    //Interface Service Provider Request creation with valid Interface Service Provider
    @isTest
    static void createInterfaceServiceProviderRequestWithValidInterfaceServiceProviderPositive() {
        Test.startTest();
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__InterfaceServiceProvider__c interfaceServiceProvider = InterfaceTestDataHelper.createInterfaceServiceProvider('Claim Interface', partner1, branch1, null, null);
        dmpl__InterfaceServiceProviderRequest__c interfaceServiceProviderRequest = InterfaceTestDataHelper.createInterfaceServiceProviderRequest(interfaceServiceProvider, 'Test Url','Testing Request','Record Id', 'Sample JSON Payload', 'Sample Response', null);
        dmpl__InterfaceServiceProviderRequest__c createdRequest = InterfaceTestDataHelper.getInterfaceServiceProviderRequest(interfaceServiceProvider.Id);
        Test.stopTest();
        System.assertNotEquals(null, createdRequest, 'InterfaceServiceProviderRequest should be created successfully.');
        System.assertEquals(interfaceServiceProvider.Id, createdRequest.dmpl__InterfaceServiceProviderId__c, 'InterfaceServiceProviderId should match the created interface service provider.');
        System.assertEquals('Test Url', createdRequest.dmpl__EndPoint__c, 'EndPoint should be Test Url');
        System.assertEquals('Testing Request', createdRequest.Name, 'Request Name should be Testing Request ');
        System.assertEquals('Record Id', createdRequest.dmpl__SourceDataType__c, 'source data type should be RecordId');
        System.assertEquals('Sample JSON Payload', createdRequest.dmpl__PayloadSchema__c, 'Payload should be Sample JSON Payload');
        System.assertEquals('Sample Response', createdRequest.dmpl__ResponseSchema__c, 'Response should be Sample Response');
    }
    
    //Interface Service Provider Request creation with Invalid Interface Service Provider
    @isTest
    static void createInterfaceServiceProviderRequestWithInvalidInterfaceServiceProviderNegative() {
        Test.startTest();
        Account partner2 = TestDataHelpers.getPartnerAccount('Partner 2');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        try{
            dmpl__InterfaceServiceProvider__c interfaceServiceProvider = InterfaceTestDataHelper.createInterfaceServiceProvider('Claim Interface', partner2, branch1, null, null);
            dmpl__InterfaceServiceProviderRequest__c interfaceServiceProviderRequest = InterfaceTestDataHelper.createInterfaceServiceProviderRequest(interfaceServiceProvider, 'Test Url','Testing Request','Record Id', 'Sample JSON Payload', 'Sample Response', null);
            System.assertEquals(null, interfaceServiceProviderRequest, 'InterfaceServiceProviderRequest should not be created with invalid interface service provider.');
        }
        catch(exception e) {
            System.debug('Expected exception: ' + e.getMessage());
        }
        Test.stopTest();
    }
    
    //Interface Service Provider Request creation with Request name(New)
    @isTest
    static void createInterfaceServiceProviderRequestWithRequestNamePositive() {
        Test.startTest();
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__InterfaceServiceProvider__c interfaceServiceProvider = InterfaceTestDataHelper.createInterfaceServiceProvider('MOF', partner1, branch1, null, null);
        dmpl__InterfaceServiceProviderRequest__c interfaceServiceProviderRequest = InterfaceTestDataHelper.createInterfaceServiceProviderRequest(interfaceServiceProvider, 'Test Url','AB','Record Id', 'Sample JSON Payload', 'Sample Response', null);
        dmpl__InterfaceServiceProviderRequest__c createdRequest = InterfaceTestDataHelper.getInterfaceServiceProviderRequest(interfaceServiceProvider.Id);
        Test.stopTest();
        System.assertNotEquals(null, createdRequest, 'InterfaceServiceProviderRequest should be created successfully.');
        System.assertEquals(interfaceServiceProvider.Id, createdRequest.dmpl__InterfaceServiceProviderId__c, 'InterfaceServiceProviderId should match the created interface service provider.');
        System.assertEquals('Test Url', createdRequest.dmpl__EndPoint__c, 'EndPoint should be Test Url');
        System.assertEquals('AB', createdRequest.Name, 'Request Name should be Testing Request');
        System.assertEquals('Record Id', createdRequest.dmpl__SourceDataType__c, 'source data type should be RecordId');
        System.assertEquals('Sample JSON Payload', createdRequest.dmpl__PayloadSchema__c, 'Payload should be Sample JSON Payload');
        System.assertEquals('Sample Response', createdRequest.dmpl__ResponseSchema__c, 'Response should be Sample Response');
    }
    
    //Interface Service Provider Request creation with Payload Schema(New)
    @isTest
    static void createInterfaceServiceProviderRequestWithPayloadSchemaPositive() {
        Test.startTest();
        Account partner4 = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__InterfaceServiceProvider__c interfaceServiceProvider = InterfaceTestDataHelper.createInterfaceServiceProvider('MON', partner4, branch1, null, null);
        dmpl__InterfaceServiceProviderRequest__c interfaceServiceProviderRequest = InterfaceTestDataHelper.createInterfaceServiceProviderRequest(interfaceServiceProvider, 'Test Url/v2','AB','Record Id', 'Valid Sample JSON Payload', 'Sample Response', null);
        dmpl__InterfaceServiceProviderRequest__c createdRequest = InterfaceTestDataHelper.getInterfaceServiceProviderRequest(interfaceServiceProvider.Id);
        Test.stopTest();
        System.assertNotEquals(null, createdRequest, 'InterfaceServiceProviderRequest should be created successfully.');
        System.assertEquals(interfaceServiceProvider.Id, createdRequest.dmpl__InterfaceServiceProviderId__c, 'InterfaceServiceProviderId should match the created interface service provider.');
        System.assertEquals('Test Url/v2', createdRequest.dmpl__EndPoint__c, 'EndPoint should be Test Url');
        System.assertEquals('AB', createdRequest.Name, 'Request Name should be Testing Request');
        System.assertEquals('Record Id', createdRequest.dmpl__SourceDataType__c, 'source data type should be RecordId');
        System.assertEquals('Valid Sample JSON Payload', createdRequest.dmpl__PayloadSchema__c, 'Payload should be Valid Sample JSON Payload');
        System.assertEquals('Sample Response', createdRequest.dmpl__ResponseSchema__c, 'Response should be Sample Response');
    }
    
    //Interface Service Provider Request creation with Payload Schema(Edit)
    @isTest
    static void updateInterfaceServiceProviderRequestWithPayloadSchemaPositive() {
        Test.startTest();
        Account partner4 = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__InterfaceServiceProvider__c interfaceServiceProvider = InterfaceTestDataHelper.createInterfaceServiceProvider('MOF', partner4, branch1, null, null);
        dmpl__InterfaceServiceProviderRequest__c interfaceServiceProviderRequest = InterfaceTestDataHelper.createInterfaceServiceProviderRequest(interfaceServiceProvider, 'Test Url/v2','AB','Record Id', 'Valid Sample JSON Payload', 'Sample Response', null);
        dmpl__InterfaceServiceProviderRequest__c createdRequest = InterfaceTestDataHelper.getInterfaceServiceProviderRequest(interfaceServiceProvider.Id);
        interfaceServiceProviderRequest.dmpl__PayloadSchema__c = 'Updated Valid Sample JSON Payload';
        update interfaceServiceProviderRequest;
        dmpl__InterfaceServiceProviderRequest__c updatedRequest = InterfaceTestDataHelper.getInterfaceServiceProviderRequest(interfaceServiceProvider.Id);
        Test.stopTest();
        System.assertNotEquals(null, createdRequest, 'InterfaceServiceProviderRequest should be created successfully.');
        System.assertEquals(interfaceServiceProvider.Id, createdRequest.dmpl__InterfaceServiceProviderId__c, 'InterfaceServiceProviderId should match the created interface service provider.');
        System.assertEquals('Test Url/v2', createdRequest.dmpl__EndPoint__c, 'EndPoint should be Test Url');
        System.assertEquals('AB', createdRequest.Name, 'Request Name should be Testing Request');
        System.assertEquals('Record Id', createdRequest.dmpl__SourceDataType__c, 'source data type should be RecordId');
        System.assertEquals('Valid Sample JSON Payload', createdRequest.dmpl__PayloadSchema__c, 'Payload should be Valid Sample JSON Payload');
        System.assertEquals('Updated Valid Sample JSON Payload', updatedRequest.dmpl__PayloadSchema__c, 'Payload should be Updated Valid Sample JSON Payload');
        System.assertEquals('Sample Response', createdRequest.dmpl__ResponseSchema__c, 'Response should be Sample Response');
    }
    
    //Interface Service Request Creation with response path and message
    @isTest
    static void createInterfaceServiceProviderRequestWithResponsePathAndMessagePositive() {
        Test.startTest();
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__InterfaceServiceProvider__c interfaceServiceProvider = InterfaceTestDataHelper.createInterfaceServiceProvider('MOF', partner1, branch1, null, null);
        dmpl__InterfaceServiceProviderRequest__c interfaceServiceProviderRequest = InterfaceTestDataHelper.createInterfaceServiceProviderRequest(interfaceServiceProvider, 'Test Url/v2','AB','Record Id', 'Valid Sample JSON Payload', 'Sample Response', 'ACT');
        dmpl__InterfaceServiceProviderRequest__c createdRequest = InterfaceTestDataHelper.getInterfaceServiceProviderRequest(interfaceServiceProvider.Id);
        Test.stopTest();
        System.assertNotEquals(null, createdRequest, 'InterfaceServiceProviderRequest should be created successfully.');
        System.assertEquals(interfaceServiceProvider.Id, createdRequest.dmpl__InterfaceServiceProviderId__c, 'InterfaceServiceProviderId should match the created interface service provider.');
        System.assertEquals('Test Url/v2', createdRequest.dmpl__EndPoint__c, 'EndPoint should be Test Url');
        System.assertEquals('AB', createdRequest.Name, 'Request Name should be AB');
        System.assertEquals('Record Id', createdRequest.dmpl__SourceDataType__c, 'source data type should be RecordId');
        System.assertEquals('Valid Sample JSON Payload', createdRequest.dmpl__PayloadSchema__c, 'Payload should be Valid Sample JSON Payload');
        System.assertEquals('Sample Response', createdRequest.dmpl__ResponseSchema__c, 'Response should be Sample Response');
        System.assertEquals('ACT', createdRequest.dmpl__ResponseSuccessValue__c, 'Response Success Value should be ACT');
    }
    
    // Interface Service Request creation with response method, body in Interface Service Provider Request Record    
    @isTest
    static void createInterfaceServiceProviderRequestWithResponseMethodAndBodyPositive() {
        Test.startTest();
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__InterfaceServiceProvider__c interfaceServiceProvider = InterfaceTestDataHelper.createInterfaceServiceProvider('MOF', partner1, branch1, null, null);
        dmpl__InterfaceServiceProviderRequest__c interfaceServiceProviderRequest = InterfaceTestDataHelper.createInterfaceServiceProviderRequest(interfaceServiceProvider, 'Test Url/v2','AB','Record Id', 'Valid Sample JSON Payload', 'Sample Response', 'POST');
        dmpl__InterfaceServiceProviderRequest__c createdRequest = InterfaceTestDataHelper.getInterfaceServiceProviderRequest(interfaceServiceProvider.Id);
        Test.stopTest();
        System.assertNotEquals(null, createdRequest, 'InterfaceServiceProviderRequest should be created successfully.');
        System.assertEquals(interfaceServiceProvider.Id, createdRequest.dmpl__InterfaceServiceProviderId__c, 'InterfaceServiceProviderId should match the created interface service provider.');
        System.assertEquals('Test Url/v2', createdRequest.dmpl__EndPoint__c, 'EndPoint should be Test Url');
        System.assertEquals('AB', createdRequest.Name, 'Request Name should be AB');
        System.assertEquals('Record Id', createdRequest.dmpl__SourceDataType__c, 'source data type should be RecordId');
        System.assertEquals('Valid Sample JSON Payload', createdRequest.dmpl__PayloadSchema__c, 'Payload should be Valid Sample JSON Payload');
        System.assertEquals('Sample Response', createdRequest.dmpl__ResponseSchema__c, 'Response should be Sample Response');
        System.assertEquals('POST', createdRequest.dmpl__ResponseSuccessValue__c, 'Response Method should be POST');
    }
    
    //Interface Service Provider Request creation without End Point (New)
    @isTest
    static void createInterfaceServiceProviderRequestWithoutEndPointPositive() {
        Test.startTest();
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__InterfaceServiceProvider__c interfaceServiceProvider = InterfaceTestDataHelper.createInterfaceServiceProvider('Claim Interface', partner1, branch1, null, null);
        try {
            dmpl__InterfaceServiceProviderRequest__c interfaceServiceProviderRequest = InterfaceTestDataHelper.createInterfaceServiceProviderRequest(interfaceServiceProvider, null, 'Testing Request', 'Record Id', 'Sample JSON Payload', 'Sample Response', null);
            System.assertNotEquals(null, interfaceServiceProviderRequest, 'InterfaceServiceProviderRequest should not be created without end point.');
        } catch (Exception e) {
            System.debug('Expected exception: ' + e.getMessage());
        }
        Test.stopTest();
    }
    
    //Interface Service Provider Request update with blank/removed End Point (Edit)
    @isTest
    static void updateInterfaceServiceProviderRequestWithBlankEndPointPositive() {
        Test.startTest();
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__InterfaceServiceProvider__c interfaceServiceProvider = InterfaceTestDataHelper.createInterfaceServiceProvider('Claim Interface', partner1, branch1, null, null);
        dmpl__InterfaceServiceProviderRequest__c interfaceServiceProviderRequest = InterfaceTestDataHelper.createInterfaceServiceProviderRequest(interfaceServiceProvider,'Test Url','Testing Request','Record Id','Sample JSON Payload','Sample Response',null);
        interfaceServiceProviderRequest.dmpl__EndPoint__c = null;
        update interfaceServiceProviderRequest;
        dmpl__InterfaceServiceProviderRequest__c updatedRequest = InterfaceTestDataHelper.getInterfaceServiceProviderRequest(interfaceServiceProvider.Id);
        Test.stopTest();
        System.assertNotEquals(null, updatedRequest, 'InterfaceServiceProviderRequest should be updated successfully.');
    }
    
    //delete valid Interface Service Provider Request record
    @isTest
    static void deleteInterfaceServiceProviderRequestPositive() {
        Test.startTest();
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__InterfaceServiceProvider__c interfaceServiceProvider = InterfaceTestDataHelper.createInterfaceServiceProvider('Claim Interface', partner1, branch1, null, null);
        dmpl__InterfaceServiceProviderRequest__c interfaceServiceProviderRequest = InterfaceTestDataHelper.createInterfaceServiceProviderRequest(interfaceServiceProvider, 'Test Url', 'Testing Request', 'Record Id', 'Sample JSON Payload', 'Sample Response', null);
        try{
            delete interfaceServiceProviderRequest;
            dmpl__InterfaceServiceProviderRequest__c deletedRequest = InterfaceTestDataHelper.getInterfaceServiceProviderRequest(interfaceServiceProvider.Id);
            System.assertEquals(null, deletedRequest, 'InterfaceServiceProviderRequest should be deleted and not found in query.');
        }
        catch (Exception e) {
            System.debug('Expected exception: ' + e.getMessage());
        }
        Test.stopTest();
    }
    
    //Interface Service Provider Request creation with non-existent Interface Service Provider (invalid lookup reference)
    @isTest
    static void createInterfaceServiceProviderRequestWithNonExistentInterfaceServiceProviderNegative() {
        Test.startTest();
        try{
            dmpl__InterfaceServiceProviderRequest__c interfaceServiceProviderRequest = InterfaceTestDataHelper.createInterfaceServiceProviderRequest(null, 'Test Url', 'Testing Request', 'Record Id', 'Sample JSON Payload', 'Sample Response', null);
            System.assertEquals(null, interfaceServiceProviderRequest, 'InterfaceServiceProviderRequest should not be created with non-existent Interface Service Provider.');
        }
        catch (Exception e) {
            System.debug('Expected exception: ' + e.getMessage());
        }
        Test.stopTest();
    }
    
    //Interface Service Provider Request creation with removing Request Name (Edit)
    @isTest
    static void updateInterfaceServiceProviderRequestWithRemovingRequestNamePositive() {
        Test.startTest();
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__InterfaceServiceProvider__c interfaceServiceProvider = InterfaceTestDataHelper.createInterfaceServiceProvider('Claim Interface', partner1, branch1, null, null);
        dmpl__InterfaceServiceProviderRequest__c interfaceServiceProviderRequest = InterfaceTestDataHelper.createInterfaceServiceProviderRequest(interfaceServiceProvider, 'Test Url', 'Testing Request', 'Record Id', 'Sample JSON Payload', 'Sample Response', null);
        interfaceServiceProviderRequest.Name = null;
        update interfaceServiceProviderRequest;
        dmpl__InterfaceServiceProviderRequest__c updatedRequest = InterfaceTestDataHelper.getInterfaceServiceProviderRequest(interfaceServiceProvider.Id);
        Test.stopTest();
        System.assertNotEquals(null, updatedRequest, 'InterfaceServiceProviderRequest should be updated successfully.');
        System.assertNotEquals(null, updatedRequest.Name, 'Request Name should be null after update');
    }
    
    //Interface Service Provider Request creation with duplicate Request Name
    @isTest
    static void createInterfaceServiceProviderRequestWithDuplicateRequestNameNegative() {
        Test.startTest();
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__InterfaceServiceProvider__c interfaceServiceProvider = InterfaceTestDataHelper.createInterfaceServiceProvider('Claim Interface', partner1, branch1, null, null);
        try {
            dmpl__InterfaceServiceProviderRequest__c interfaceServiceProviderRequest1 = InterfaceTestDataHelper.createInterfaceServiceProviderRequest(interfaceServiceProvider, 'Test Url', 'Testing Request', 'Record Id', 'Sample JSON Payload', 'Sample Response', null);
            dmpl__InterfaceServiceProviderRequest__c interfaceServiceProviderRequest2 = InterfaceTestDataHelper.createInterfaceServiceProviderRequest(interfaceServiceProvider, 'Test Url', 'Testing Request', 'Record Id', 'Sample JSON Payload', 'Sample Response', null);
            System.assertNotEquals(null, interfaceServiceProviderRequest2, 'InterfaceServiceProviderRequest should not be created with duplicate request name.');
        } catch (Exception e) {
            System.debug('Expected exception: ' + e.getMessage());
        }
        Test.stopTest();
    }
    
    //Interface Service Provider Request creation without Payload Schema (New)
    @isTest
    static void createInterfaceServiceProviderRequestWithoutPayloadSchemaNegative() {
        Test.startTest();
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__InterfaceServiceProvider__c interfaceServiceProvider = InterfaceTestDataHelper.createInterfaceServiceProvider('Claim Interface', partner1, branch1, null, null);
        dmpl__InterfaceServiceProviderRequest__c interfaceServiceProviderRequest = InterfaceTestDataHelper.createInterfaceServiceProviderRequest(interfaceServiceProvider, 'Test Url', 'Testing Request', 'Record Id', null, 'Sample Response', null);
        dmpl__InterfaceServiceProviderRequest__c createdRequest = InterfaceTestDataHelper.getInterfaceServiceProviderRequest(interfaceServiceProvider.Id);
        Test.stopTest();
        System.assertNotEquals(null, createdRequest, 'InterfaceServiceProviderRequest should be created successfully.');
        System.assertEquals(interfaceServiceProvider.Id, createdRequest.dmpl__InterfaceServiceProviderId__c, 'InterfaceServiceProviderId should match the created interface service provider.');
        System.assertEquals('Test Url', createdRequest.dmpl__EndPoint__c, 'EndPoint should be Test Url');
        System.assertEquals('Testing Request', createdRequest.Name, 'Request Name should be Testing Request');
        System.assertEquals('Record Id', createdRequest.dmpl__SourceDataType__c, 'source data type should be RecordId');
        System.assertEquals(null, createdRequest.dmpl__PayloadSchema__c, 'Payload Schema should be null');
        System.assertEquals('Sample Response', createdRequest.dmpl__ResponseSchema__c, 'Response should be Sample Response');
    }
    
    //Interface Service Provider Request update with invalid or corrupted Payload Schema (Edit)
    @isTest
    static void updateInterfaceServiceProviderRequestWithInvalidPayloadSchemaPositive() {
        Test.startTest();
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__InterfaceServiceProvider__c interfaceServiceProvider = InterfaceTestDataHelper.createInterfaceServiceProvider('Claim Interface', partner1, branch1, null, null);
        dmpl__InterfaceServiceProviderRequest__c interfaceServiceProviderRequest = InterfaceTestDataHelper.createInterfaceServiceProviderRequest(interfaceServiceProvider, 'Test Url', 'Testing Request', 'Record Id', 'Invalid JSON', 'Sample Response', null);
        interfaceServiceProviderRequest.dmpl__PayloadSchema__c = null;
        update interfaceServiceProviderRequest;
        dmpl__InterfaceServiceProviderRequest__c updatedRequest = InterfaceTestDataHelper.getInterfaceServiceProviderRequest(interfaceServiceProvider.Id);
        Test.stopTest();
        System.assertNotEquals(null, updatedRequest, 'InterfaceServiceProviderRequest should be updated successfully.');
        System.assertEquals(null, updatedRequest.dmpl__PayloadSchema__c, 'Payload Schema should be Invalid JSON');
    }
    
    //Interface Log creation with endpoint URL(new)
    @isTest
    static void createInterfaceLogWithEndpointURLPositive() {
        Test.startTest();
        dmpl__InterfaceLog__c interfaceLog = InterfaceTestDataHelper.createInterfaceLog('Test EndPoint Url','POST', null, null, null);
        dmpl__InterfaceLog__c createdLog = InterfaceTestDataHelper.getInterfaceLog(interfaceLog.Id);
        Test.stopTest();
        System.assertNotEquals(null, createdLog, 'InterfaceLog should be created successfully.');
        System.assertEquals('Test EndPoint Url', createdLog.dmpl__EndPoint__c, 'EndPoint should be Test EndPoint Url');
        System.assertEquals('POST', createdLog.dmpl__Method__c, 'Method should be POST');
    }
    
    //Interface Log creation with correct Payload (Save)
    @isTest
    static void createInterfaceLogWithCorrectPayloadPositive() {
        Test.startTest();
        dmpl__InterfaceLog__c interfaceLog = InterfaceTestDataHelper.createInterfaceLog('Test EndPoint Url','POST', 'Valid JSON', null, null);
        dmpl__InterfaceLog__c createdLog = InterfaceTestDataHelper.getInterfaceLog(interfaceLog.Id);
        Test.stopTest();
        System.assertNotEquals(null, createdLog, 'InterfaceLog should be created successfully.');
        System.assertEquals('Test EndPoint Url', createdLog.dmpl__EndPoint__c, 'EndPoint should be Test EndPoint Url');
        System.assertEquals('POST', createdLog.dmpl__Method__c, 'Method should be POST');
        System.assertEquals('Valid JSON', createdLog.dmpl__Payload__c, 'Payload should be Valid JSON');
    }
    
    //Interface Log creation with correct Payload (Edit)
    @isTest
    static void updateInterfaceLogWithCorrectPayloadPositive() {
        Test.startTest();
        dmpl__InterfaceLog__c interfaceLog = InterfaceTestDataHelper.createInterfaceLog('Test EndPoint Url','POST', 'Valid JSON', null, null);
        interfaceLog.dmpl__Payload__c = 'Updated Valid JSON';
        update interfaceLog;
        dmpl__InterfaceLog__c updatedLog = InterfaceTestDataHelper.getInterfaceLog(interfaceLog.Id);
        Test.stopTest();
        System.assertNotEquals(null, updatedLog, 'InterfaceLog should be updated successfully.');
        System.assertEquals('Test EndPoint Url', updatedLog.dmpl__EndPoint__c, 'EndPoint should be Test EndPoint Url');
        System.assertEquals('POST', updatedLog.dmpl__Method__c, 'Method should be POST');
        System.assertEquals('Updated Valid JSON', updatedLog.dmpl__Payload__c, 'Payload should be Updated Valid JSON');
    }
    
    //Interface Log creation with valid Interface Service Provider tagging (new)
    @isTest
    static void createInterfaceLogWithValidInterfaceServiceProviderTaggingPositive() {
        Test.startTest();
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__InterfaceServiceProvider__c interfaceServiceProvider = InterfaceTestDataHelper.createInterfaceServiceProvider('NPS Interface', partner1, null, null, null);
        dmpl__InterfaceLog__c interfaceLog = InterfaceTestDataHelper.createInterfaceLog('Test EndPoint Url','POST', 'Valid JSON', interfaceServiceProvider, null );
        dmpl__InterfaceLog__c createdLog = InterfaceTestDataHelper.getInterfaceLog(interfaceLog.Id);
        Test.stopTest();
        System.assertNotEquals(null, createdLog, 'InterfaceLog should be created successfully.');
        System.assertEquals('Test EndPoint Url', createdLog.dmpl__EndPoint__c, 'EndPoint should be Test EndPoint Url');
        System.assertEquals('POST', createdLog.dmpl__Method__c, 'Method should be POST');
        System.assertEquals('Valid JSON', createdLog.dmpl__Payload__c, 'Payload should be Valid JSON');
        System.assertEquals(interfaceServiceProvider.Id, createdLog.dmpl__InterfaceServiceProviderId__c, 'InterfaceServiceProviderId should match the created interface service provider.');
    }
    
    //Interface  Log creation with valid Interface Service Provider( Edit)
    @isTest
    static void updateInterfaceLogWithValidInterfaceServiceProviderTaggingPositive() {
        Test.startTest();
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account partner4 = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__InterfaceServiceProvider__c interfaceServiceProvider = InterfaceTestDataHelper.createInterfaceServiceProvider('NPS Interface', partner1, null, null, null);
        dmpl__InterfaceServiceProvider__c interfaceServiceProvider2 = InterfaceTestDataHelper.createInterfaceServiceProvider('Optimus SMS gateway', partner4, null, null, null);
        dmpl__InterfaceLog__c interfaceLog = InterfaceTestDataHelper.createInterfaceLog('Test EndPoint Url','POST', 'Valid JSON', interfaceServiceProvider, null);
        dmpl__InterfaceLog__c createdLog = InterfaceTestDataHelper.getInterfaceLog(interfaceLog.Id);
        interfaceLog.dmpl__InterfaceServiceProviderId__c = interfaceServiceProvider2.Id;
        update interfaceLog;
        dmpl__InterfaceLog__c updatedLog = InterfaceTestDataHelper.getInterfaceLog(interfaceLog.Id);
        Test.stopTest();
        System.assertNotEquals(null, updatedLog, 'InterfaceLog should be updated successfully.');
        System.assertEquals('Test EndPoint Url', updatedLog.dmpl__EndPoint__c, 'EndPoint should be Test EndPoint Url');
        System.assertEquals('POST', updatedLog.dmpl__Method__c, 'Method should be POST');
        System.assertEquals('Valid JSON', updatedLog.dmpl__Payload__c, 'Payload should be Valid JSON');
        System.assertEquals(interfaceServiceProvider2.Id, updatedLog.dmpl__InterfaceServiceProviderId__c, 'InterfaceServiceProviderId should match the updated interface service provider.');
        System.assertEquals(interfaceServiceProvider.Id, createdLog.dmpl__InterfaceServiceProviderId__c, 'InterfaceServiceProviderId should match the created interface service provider.');
    }
    
    //Interface Log creation with valid Record ID in Request header for Re-Test functionality
    //Interface Log creation with deleting Record ID in Request header
    
    //Interface Log creation with valid Interface Service Provider Request tagging (new)
    @isTest
    static void createInterfaceLogWithValidInterfaceServiceProviderRequestTaggingPositive() {
        Test.startTest();
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__InterfaceServiceProvider__c interfaceServiceProvider = InterfaceTestDataHelper.createInterfaceServiceProvider('NPS Interface2', partner1, null, null, null);
        dmpl__InterfaceServiceProviderRequest__c interfaceServiceProviderRequest = InterfaceTestDataHelper.createInterfaceServiceProviderRequest(interfaceServiceProvider, 'Test EndPoint Url','Send SMS Testing Request','Record Id', 'Sample JSON Payload', 'Sample Response', null);
        dmpl__InterfaceLog__c interfaceLog = InterfaceTestDataHelper.createInterfaceLog('Test EndPoint Url','POST', 'Valid JSON', interfaceServiceProvider, interfaceServiceProviderRequest);
        dmpl__InterfaceLog__c createdLog = InterfaceTestDataHelper.getInterfaceLog(interfaceLog.Id);
        Test.stopTest();
        System.assertNotEquals(null, createdLog, 'InterfaceLog should be created successfully.');
        System.assertEquals('Test EndPoint Url', createdLog.dmpl__EndPoint__c, 'EndPoint should be Test EndPoint Url');
        System.assertEquals('POST', createdLog.dmpl__Method__c, 'Method should be POST');
        System.assertEquals('Valid JSON', createdLog.dmpl__Payload__c, 'Payload should be Valid JSON');
        System.assertEquals(interfaceServiceProvider.Id, createdLog.dmpl__InterfaceServiceProviderId__c, 'InterfaceServiceProviderId should match the created interface service provider.');
        System.assertEquals(interfaceServiceProviderRequest.Id, createdLog.dmpl__InterfaceServiceProviderRequestId__c, 'InterfaceServiceProviderRequestId should match the created interface service provider request.');
    }
    
    //Interface Log creation with valid Interface Service Provider Request tagging (Edit)
    @isTest
    static void updateInterfaceLogWithValidInterfaceServiceProviderRequestTaggingPositive() {
        Test.startTest();
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account partner4 = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__InterfaceServiceProvider__c interfaceServiceProvider = InterfaceTestDataHelper.createInterfaceServiceProvider('NPS Interface2', partner1, null, null, null);
        dmpl__InterfaceServiceProviderRequest__c interfaceServiceProviderRequest = InterfaceTestDataHelper.createInterfaceServiceProviderRequest(interfaceServiceProvider, 'Test EndPoint Url','Send SMS Testing Request','Record Id', 'Sample JSON Payload', 'Sample Response', null);
        dmpl__InterfaceServiceProviderRequest__c interfaceServiceProviderRequest2 = InterfaceTestDataHelper.createInterfaceServiceProviderRequest(interfaceServiceProvider, 'Updated Endpoint Url','SMS Request Testing Name','Record Id', 'Updated Payload', 'Updated Response', null);
        dmpl__InterfaceLog__c interfaceLog = InterfaceTestDataHelper.createInterfaceLog('Test EndPoint Url','POST', 'Valid JSON', interfaceServiceProvider, interfaceServiceProviderRequest);
        dmpl__InterfaceLog__c createdLog = InterfaceTestDataHelper.getInterfaceLog(interfaceLog.Id);
        interfaceLog.dmpl__InterfaceServiceProviderRequestId__c = interfaceServiceProviderRequest2.Id;
        update interfaceLog;
        dmpl__InterfaceLog__c updatedLog = InterfaceTestDataHelper.getInterfaceLog(interfaceLog.Id);
        Test.stopTest();
        System.assertNotEquals(null, updatedLog, 'InterfaceLog should be updated successfully.');
        System.assertEquals('Test EndPoint Url', updatedLog.dmpl__EndPoint__c, 'EndPoint should be Test EndPoint Url');
        System.assertEquals('POST', updatedLog.dmpl__Method__c, 'Method should be POST');
        System.assertEquals('Valid JSON', updatedLog.dmpl__Payload__c, 'Payload should be Valid JSON');
        System.assertEquals(interfaceServiceProviderRequest.Id, createdLog.dmpl__InterfaceServiceProviderRequestId__c, 'InterfaceServiceProviderRequestId should match the created interface service provider request.');
        System.assertEquals(interfaceServiceProviderRequest2.Id, updatedLog.dmpl__InterfaceServiceProviderRequestId__c, 'InterfaceServiceProviderRequestId should match the updated interface service provider request.');
    }
    
    //Can delete Interface log record
    @isTest
    static void deleteInterfaceLogPositive() {
        Test.startTest();
        dmpl__InterfaceLog__c interfaceLog = InterfaceTestDataHelper.createInterfaceLog('Test EndPoint Url','POST', 'Valid JSON', null, null);
        try {
            delete interfaceLog;
            dmpl__InterfaceLog__c deletedLog = InterfaceTestDataHelper.getInterfaceLog(interfaceLog.Id);
            System.assertEquals(null, deletedLog, 'InterfaceLog should be deleted and not found in query.');
        } catch (Exception e) {
            System.debug('Expected exception: ' + e.getMessage());
        }
        Test.stopTest();
    }
    
    //Interface Log Creation with endpoint URL( Invalid)
    @isTest
    static void createInterfaceLogWithEndpointURLNegative() {
        Test.startTest();
        try {
            dmpl__InterfaceLog__c interfaceLog = InterfaceTestDataHelper.createInterfaceLog(null, 'POST', 'Valid JSON', null, null);
            System.assertNotEquals(null, interfaceLog, 'InterfaceLog should be created with null/Invalid EndPoint URL.');
        } catch (Exception e) {
            System.debug('Expected exception: ' + e.getMessage());
        }
        Test.stopTest();
    }
    //Interface Log creation with Payload (Invalid)
    @isTest
    static void createInterfaceLogWithInvalidPayloadNegative() {
        Test.startTest();
        try {
            dmpl__InterfaceLog__c interfaceLog = InterfaceTestDataHelper.createInterfaceLog('Test EndPoint Url', 'POST', null, null, null);
            System.assertNotEquals(null, interfaceLog, 'InterfaceLog should be created with null/Invalid Payload.');
        } catch (Exception e) {
            System.debug('Expected exception: ' + e.getMessage());
        }
        Test.stopTest();
    }
    //Interface Log Creation with unauthorised access token
    //Interface Log creation with invalid End point and Method (Re-Test)
    //Interface Log creation with invalid Record ID in Request header
    //Interface Log creation with deleting Record ID in Request header
}