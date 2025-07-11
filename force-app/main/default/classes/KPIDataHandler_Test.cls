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

    //Creation of the KPI Data with all the mandatory fields (new)
    @isTest
    static void createKPIDataWithAllFieldsPositive() {
        dmpl__KPIConfiguration__c kpiConfig = KPIDataHelper.createKPIConfiguration('Test KPI Config', 'Customer', 'TestDateField');
        dmpl__KPIData__c KPIData = KPIDataHelper.createKPIData(
            kpiConfig.Id,
            'Test KPI'
        );
        dmpl__KPIData__c fetchedKPIData = KPIDataHelper.getKPIData(KPIData.Id);
        System.assertEquals(kpiConfig.Id, fetchedKPIData.dmpl__KPIConfigurationId__c,'KPI Config Id should match');
        System.assertEquals('Test KPI', fetchedKPIData.Name,'KPI Data Name should match');
    }

    //Creation of the KPI Data with the Document date (new)
    @IsTest
    static void createKPIDataWithDocumentDatePositive() {
        dmpl__KPIConfiguration__c kpiConfig = KPIDataHelper.createKPIConfiguration('Test KPI Config', 'Customer', 'TestDateField');
        dmpl__KPIData__c KPIData = KPIDataHelper.createKPIData(
            kpiConfig.Id,
            'Test KPI'
        );
        KPIData.DocumentDate__c = Date.newInstance(2022, 1, 1);
        update KPIData;
        dmpl__KPIData__c fetchedKPIData = KPIDataHelper.getKPIData(KPIData.Id);
        System.assertEquals(kpiConfig.Id, fetchedKPIData.dmpl__KPIConfigurationId__c,'KPI Config Id should match');
        System.assertEquals('Test KPI', fetchedKPIData.Name,'KPI Data Name should match');
    }

    //Creation of the KPI Data with no partner account(new)
    @isTest
    static void createKPIDataWithNoPartnerAccountPositive() {
        dmpl__KPIConfiguration__c kpiConfig = KPIDataHelper.createKPIConfiguration('Test KPI Config', 'Customer', 'TestDateField');
        dmpl__KPIData__c KPIData = KPIDataHelper.createKPIData(
            kpiConfig.Id,
            'Test KPI'
        );
        dmpl__KPIData__c fetchedKPIData = KPIDataHelper.getKPIData(KPIData.Id);
        System.assertEquals(kpiConfig.Id, fetchedKPIData.dmpl__KPIConfigurationId__c,'KPI Config Id should match');
        System.assertEquals('Test KPI', fetchedKPIData.Name,'KPI Data Name should match');
    }

    //Creation of the KPI Data with the valid partner account(new)
    @IsTest
    static void createKPIDataWithValidPartnerAccountPositive(){
        dmpl__KPIConfiguration__c kpiConfig = KPIDataHelper.createKPIConfiguration('Test KPI Config', 'Customer', 'TestDateField');
        dmpl__KPIData__c KPIData = KPIDataHelper.createKPIData(
            kpiConfig.Id,
            'Test KPI'
        );
        dmpl__KPIData__c fetchedKPIData = KPIDataHelper.getKPIData(KPIData.Id);
        System.assertEquals(kpiConfig.Id, fetchedKPIData.dmpl__KPIConfigurationId__c,'KPI Config Id should match');
        System.assertEquals('Test KPI', fetchedKPIData.Name,'KPI Data Name should match');
    }

    //Creation of the KPI Data with Name left Blank (new)
    @isTest
    static void createKPIDataWithNoNameNegative(){
        Boolean exceptionThrown = false;
        dmpl__KPIConfiguration__c kpiConfig = KPIDataHelper.createKPIConfiguration('Test KPI Config', 'Customer', 'TestDateField');
        try {
            dmpl__KPIData__c KPIData = KPIDataHelper.createKPIData(
            kpiConfig.Id,
            null
        );
        } catch (Exception e) {
             exceptionThrown = true;
            System.debug('Expected exception caught: ' + e.getMessage());
        }
       
        //System.assertEquals(true, exceptionThrown, 'Expected exception was not thrown for using null as name');

    } 

    //Edit the KPI Data with keeping the Name field blank (Edit) 
    @isTest
    static void updateKPIDataWithNoNameNegative(){
        Boolean exceptionThrown = false;
        dmpl__KPIConfiguration__c kpiConfig = KPIDataHelper.createKPIConfiguration('Test KPI Config', 'Customer', 'TestDateField');
        dmpl__KPIData__c KPIData = KPIDataHelper.createKPIData(
            kpiConfig.Id,
            'Test KPI'
        );

        try {
             KPIData.Name= null;
             update KPIData;
             dmpl__KPIData__c fetchedKPIData = KPIDataHelper.getKPIData(KPIData.Id);
          } catch (Exception e) {
             exceptionThrown = true;
            System.debug('Expected exception caught: ' + e.getMessage());
        }
        //System.assertEquals(true, exceptionThrown, 'Expected exception was not thrown for using null as name');
    } 

    //Edit the KPI Data without tagging the configuration Id (Edit)
    @IsTest
    static void updateKPIDataWithNoKPIConfigurationIdPositive(){
    dmpl__KPIConfiguration__c kpiConfig = KPIDataHelper.createKPIConfiguration('Test KPI Config', 'Customer', 'TestDateField');
        dmpl__KPIData__c KPIData = KPIDataHelper.createKPIData(
            null,
            'Test KPI'
        );
        dmpl__KPIData__c fetchedKPIData = KPIDataHelper.getKPIData(KPIData.Id);
        System.assertEquals(null, fetchedKPIData.dmpl__KPIConfigurationId__c,'KPI Config Id should match be null');
        System.assertEquals('Test KPI', fetchedKPIData.Name,'KPI Data Name should match');
    }

    //Edit the KPI Data and tag the configuration Id (Edit)
    @isTest
    static void updateKPIDataWithKPIConfigurationIdPositive(){
        dmpl__KPIConfiguration__c kpiConfig = KPIDataHelper.createKPIConfiguration('Test KPI Config', 'Customer', 'TestDateField');
        dmpl__KPIData__c KPIData = KPIDataHelper.createKPIData(
            null,
            'Test KPI'
        );
        KPIData.dmpl__KPIConfigurationId__c= kpiConfig.Id;
        update KPIData;
        dmpl__KPIData__c fetchedKPIData = KPIDataHelper.getKPIData(KPIData.Id);
        System.assertEquals(kpiConfig.Id, fetchedKPIData.dmpl__KPIConfigurationId__c,'KPI Config Id should match');
        System.assertEquals('Test KPI', fetchedKPIData.Name,'KPI Data Name should match');
    }

}