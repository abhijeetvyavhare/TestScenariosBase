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
}