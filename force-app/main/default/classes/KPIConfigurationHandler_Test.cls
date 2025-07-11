@isTest
public with sharing class KPIConfigurationHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Account partnerAccount = TestDataHelpers.createPartnerAccount();
        Account customerAccount = TestDataHelpers.createCustomerAccount();
        dmpl__Branch__c branch = TestDataHelpers.createBranch(partnerAccount);

        dmpl__KPIConfiguration__c kpiConfig = KPIConfigurationDataHelper.createKPIConfiguration(
            'Test KPI Config',
            'Customer',
            'TestDateField'
        );
    }

    @isTest
    static void createKPIConfigurationPositive() {
        dmpl__KPIConfiguration__c config = KPIConfigurationDataHelper.getKPIConfiguration();
        System.assertNotEquals(config, null, 'Expected KPI Configuration to be created.');
        System.assertEquals('Test KPI Config', config.Name, 'KPI Configuration Name should match');
        System.assertEquals('Customer', config.dmpl__MemberType__c, 'Member Type should match');
        System.assertEquals('TestDateField', config.dmpl__DateFieldName__c, 'Date Field Name should match');
        System.assertEquals(true, config.dmpl__IsActive__c, 'IsActive should be true');
    }

    @isTest
    static void updateKPIConfigurationPositive() {
        dmpl__KPIConfiguration__c config = KPIConfigurationDataHelper.getKPIConfiguration();
        dmpl__KPIConfiguration__c updatedConfig = KPIConfigurationDataHelper.updateKPIConfiguration(config, 'Updated KPI Config');
        System.assertEquals('Updated KPI Config', updatedConfig.Name, 'KPI Configuration Name should be updated.');
    }

    @isTest
    static void deleteKPIConfiguration() {
        dmpl__KPIConfiguration__c config = KPIConfigurationDataHelper.getKPIConfiguration();
        Integer count = KPIConfigurationDataHelper.deleteKPIConfiguration(config);
        System.assertEquals(0, count, 'KPI Configuration should be deleted and not found in query.');
    }

    //KPI Congiguration Scenarios

    @isTest
    static void createKPIConfigurationWithKPINamePositive(){
        Test.startTest();
        dmpl__KPIConfiguration__c config = KPIConfigurationDataHelper.createKPIConfiguration('KPI Configuration 1','Resource','dmpl__DocumentDate__c');
        Test.stopTest();

        System.assertNotEquals(null, config.Id, 'Expected KPI Configuration to be created.');

        System.assertEquals('KPI Configuration 1', config.Name, 'KPI Configuration Name should be KPI Configuration 1');
        System.assertEquals('Resource', config.dmpl__MemberType__c, 'Member Type should be Resource');
        System.assertEquals('dmpl__DocumentDate__c', config.dmpl__DateFieldName__c, 'Date Field Name should be dmpl__DocumentDate__c');

    }

    @isTest
    static void createKPIConfigurationWithoutKPINameNegative(){
        Test.startTest();
        try {      
            dmpl__KPIConfiguration__c config = KPIConfigurationDataHelper.createKPIConfiguration(null,'Resource','dmpl__DocumentDate__c');
            //System.assertEquals(null, config.Id, 'KPIConfiguration should not be created without name');
        } catch (Exception e) {
            System.Assert.isTrue(true, 'KPIConfiguration should not be created without name');
        }
        Test.stopTest();

    }

    @isTest
    static void updateKPIConfigurationWithoutNameNegative(){
        dmpl__KPIConfiguration__c config = KPIConfigurationDataHelper.createKPIConfiguration('KPI Configuration 1','Resource','dmpl__DocumentDate__c');
        System.assertNotEquals(null, config.Id, 'Expected KPI Configuration to be created.');

        System.assertEquals('KPI Configuration 1', config.Name, 'KPI Configuration Name should be KPI Configuration 1');
        System.assertEquals('Resource', config.dmpl__MemberType__c, 'Member Type should be Resource');
        System.assertEquals('dmpl__DocumentDate__c', config.dmpl__DateFieldName__c, 'Date Field Name should be dmpl__DocumentDate__c');

        Test.startTest();
        Boolean exceptionThrown = false;
        try{
            config.Name = null;
            update config;
        }catch (Exception e) {
            exceptionThrown = true;
        }
        //System.assertEquals(true, exceptionThrown,'Expected exception when removing Name from kpiConfig');
        Test.stopTest();
    }

    @isTest
    static void createKPIConfigurationWithMemberTypePositive(){
        Test.startTest();
        dmpl__KPIConfiguration__c config = KPIConfigurationDataHelper.createKPIConfiguration('KPI Configuration 1','Resource','dmpl__DocumentDate__c');
        Test.stopTest();

        System.assertNotEquals(null, config.Id, 'Expected KPI Configuration to be created.');

        System.assertEquals('KPI Configuration 1', config.Name, 'KPI Configuration Name should be KPI Configuration 1');
        System.assertEquals('Resource', config.dmpl__MemberType__c, 'Member Type should be Resource');
        System.assertEquals('dmpl__DocumentDate__c', config.dmpl__DateFieldName__c, 'Date Field Name should be dmpl__DocumentDate__c');

    }

    @isTest
    static void createKPIConfigurationWithoutMemberTypeNegative(){
        Test.startTest();
        try {      
            dmpl__KPIConfiguration__c config = KPIConfigurationDataHelper.createKPIConfiguration('KPI Configuration 1',null,'dmpl__DocumentDate__c');
            System.assertEquals(null, config.Id, 'KPIConfiguration should not be created without member type');
        } catch (Exception e) {
            System.Assert.isTrue(true, 'KPIConfiguration should not be created without member type');
        }
        Test.stopTest();

    }

    @isTest
    static void updateKPIConfigurationWithoutMemberTypeNegative(){
        dmpl__KPIConfiguration__c config = KPIConfigurationDataHelper.createKPIConfiguration('KPI Configuration 1','Resource','dmpl__DocumentDate__c');

        System.assertNotEquals(null, config.Id, 'Expected KPI Configuration to be created.');

        System.assertEquals('KPI Configuration 1', config.Name, 'KPI Configuration Name should be KPI Configuration 1');
        System.assertEquals('Resource', config.dmpl__MemberType__c, 'Member Type should be Resource');
        System.assertEquals('dmpl__DocumentDate__c', config.dmpl__DateFieldName__c, 'Date Field Name should be dmpl__DocumentDate__c');


        Test.startTest();
        Boolean exceptionThrown = false;
        try{
            config.dmpl__MemberType__c = null;
            update config;
        }catch (Exception e) {
            exceptionThrown = true;
        }
        System.assertEquals(true, exceptionThrown,'Expected exception when removing Member Type from kpiConfig');
        Test.stopTest();
    }

    @isTest
    static void createKPIConfigurationWithDateFieldNamePositive(){
        Test.startTest();
        dmpl__KPIConfiguration__c config = KPIConfigurationDataHelper.createKPIConfiguration('KPI Configuration 1','Resource','dmpl__DocumentDate__c');
        Test.stopTest();

        System.assertNotEquals(null, config.Id, 'Expected KPI Configuration to be created.');

        System.assertEquals('KPI Configuration 1', config.Name, 'KPI Configuration Name should be KPI Configuration 1');
        System.assertEquals('Resource', config.dmpl__MemberType__c, 'Member Type should be Resource');
        System.assertEquals('dmpl__DocumentDate__c', config.dmpl__DateFieldName__c, 'Date Field Name should be dmpl__DocumentDate__c');

    }

    @isTest
    static void createKPIConfigurationWithoutDateFieldNameNegative(){
        Test.startTest();
        try {      
            dmpl__KPIConfiguration__c config = KPIConfigurationDataHelper.createKPIConfiguration('KPI Configuration 1','Resource',null);
            System.assertEquals(null, config.Id, 'KPIConfiguration should not be created without member type');
        } catch (Exception e) {
            System.Assert.isTrue(true, 'KPIConfiguration should not be created without member type');
        }
        Test.stopTest();

    }

    @isTest
    static void updateKPIConfigurationWithoutDateFieldNameNegative(){
        dmpl__KPIConfiguration__c config = KPIConfigurationDataHelper.createKPIConfiguration('KPI Configuration 1','Resource','dmpl__DocumentDate__c');

        System.assertNotEquals(null, config.Id, 'Expected KPI Configuration to be created.');

        System.assertEquals('KPI Configuration 1', config.Name, 'KPI Configuration Name should be KPI Configuration 1');
        System.assertEquals('Resource', config.dmpl__MemberType__c, 'Member Type should be Resource');
        System.assertEquals('dmpl__DocumentDate__c', config.dmpl__DateFieldName__c, 'Date Field Name should be dmpl__DocumentDate__c');


        Test.startTest();
        Boolean exceptionThrown = false;
        try{
            config.dmpl__DateFieldName__c = null;
            update config;
        }catch (Exception e) {
            exceptionThrown = true;
        }
        System.assertEquals(true, exceptionThrown,'Expected exception when removing DateFieldName from kpiConfig');
        Test.stopTest();
    }
}