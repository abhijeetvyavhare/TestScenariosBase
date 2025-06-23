@isTest
public with sharing class KPIDataHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Account partnerAccount = TestDataHelpers.createPartnerAccount();
        Account customerAccount = TestDataHelpers.createCustomerAccount();
        dmpl__Branch__c branch = TestDataHelpers.createBranch(partnerAccount);
        dmpl__Resource__c resource = TestDataHelpers.createResource(partnerAccount, branch);
        dmpl__KPIConfiguration__c kpiConfig = KPIDataHelper.createKPIConfiguration('Test KPI Config', 'Customer', 'TestDateField');
        dmpl__KPIData__c kpiData = KPIDataHelper.createKPIData(
            kpiConfig,
            customerAccount,
            branch,
            partnerAccount,
            resource
        );
    }

    @isTest
    static void createKPIDataPositive() {
        dmpl__KPIData__c kpiData = KPIDataHelper.getKPIData();
        System.assertNotEquals(kpiData, null, 'Expected KPI Data to be created.');
        System.assertEquals('Test-KPI-Data', kpiData.Name, 'KPI Data Name should match');
        System.assertEquals(100, kpiData.dmpl__KPIValue__c, 'KPI Value should match');
        System.assertEquals(50, kpiData.dmpl__RewardValue__c, 'Reward Value should match');
    }

    @isTest
    static void updateKPIDataPositive() {
        dmpl__KPIData__c kpiData = KPIDataHelper.getKPIData();
        dmpl__KPIData__c updatedKPIData = KPIDataHelper.updateKPIData(kpiData, 200);
        System.assertEquals(200, updatedKPIData.dmpl__KPIValue__c, 'KPI Value should be updated.');
    }

    @isTest
    static void deleteKPIData() {
        dmpl__KPIData__c kpiData = KPIDataHelper.getKPIData();
        System.assertNotEquals(kpiData, null, 'KPI Data should exist before delete.');

        delete kpiData;

        dmpl__KPIData__c deletedKPIData = null;
        try {
            deletedKPIData = KPIDataHelper.getKPIData(kpiData.Id);
        } catch (Exception e) {
            deletedKPIData = null;
        }
        System.assertEquals(null, deletedKPIData, 'KPI Data should be deleted and not found in query.');
    }
}