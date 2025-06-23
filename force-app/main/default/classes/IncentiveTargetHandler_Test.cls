@isTest
public with sharing class IncentiveTargetHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Account partnerAccount = TestDataHelpers.createPartnerAccount();
        Account customerAccount = TestDataHelpers.createCustomerAccount();
        dmpl__Branch__c branch = TestDataHelpers.createBranch(partnerAccount);
        dmpl__Item__c item = TestDataHelpers.createItem();
        dmpl__SKU__c sku = TestDataHelpers.createSKU(item);
        dmpl__IncentivePlan__c incentivePlan = IncentiveTargetDataHelper.createIncentivePlan();
        dmpl__IncentivePeriod__c incentivePeriod = IncentiveTargetDataHelper.createIncentivePeriod(incentivePlan.Id);
        dmpl__IncentiveTarget__c target = IncentiveTargetDataHelper.createIncentiveTarget(
            incentivePlan.Id,
            incentivePeriod.Id,
            item.Id,
            sku.Id,
            100,
            'No of Leads',     
            'Resource Target' 
        );
        dmpl__IncentiveResource__c resource = IncentiveTargetDataHelper.createIncentiveResource(incentivePlan.Id);
        dmpl__KPIConfiguration__c kpiConfig = KPIDataHelper.createKPIConfiguration('Test KPI Config', 'Customer', 'TestDateField');
        dmpl__IncentiveResourceTarget__c incentiveResourceTarget = IncentiveTargetDataHelper.createIncentiveResourceTarget(
            target.Id,
            incentivePeriod.Id,
            resource.Id,
            kpiConfig.Id,
            200
        );
    }

    @isTest
    static void createIncentiveTargetPositive() {
        dmpl__IncentiveTarget__c target = IncentiveTargetDataHelper.getIncentiveTarget();
        System.assertNotEquals(target, null, 'Expected Incentive Target to be created.');
        System.assertEquals(100, target.dmpl__Value__c, 'Value should match');
        System.assertEquals('No of Leads', target.dmpl__TargetType__c, 'TargetType should match');
        System.assertEquals('Resource Target', target.dmpl__TargetValueType__c, 'TargetValueType should match');
    }

    @isTest
    static void updateIncentiveTargetPositive() {
        dmpl__IncentiveTarget__c target = IncentiveTargetDataHelper.getIncentiveTarget();
        dmpl__IncentiveTarget__c updatedTarget = IncentiveTargetDataHelper.updateIncentiveTarget(target, 150);
        System.assertEquals(150, updatedTarget.dmpl__Value__c, 'Value should be updated.');
    }

    @isTest
    static void deleteIncentiveTarget() {
        dmpl__IncentiveTarget__c target = IncentiveTargetDataHelper.getIncentiveTarget();
        Integer count = IncentiveTargetDataHelper.deleteIncentiveTarget(target);
        System.assertEquals(0, count, 'Incentive Target should be deleted and not found in query.');
    }

    @isTest
    static void createIncentiveResourceTargetPositive() {
        dmpl__IncentiveResourceTarget__c resourceTarget = IncentiveTargetDataHelper.getIncentiveResourceTarget();
        System.assertNotEquals(resourceTarget, null, 'Expected Incentive Resource Target to be created.');
        System.assertEquals(200, resourceTarget.dmpl__Value__c, 'Value should match');
    }

    @isTest
    static void updateIncentiveResourceTargetPositive() {
        dmpl__IncentiveResourceTarget__c resourceTarget = IncentiveTargetDataHelper.getIncentiveResourceTarget();
        dmpl__IncentiveResourceTarget__c updatedResourceTarget = IncentiveTargetDataHelper.updateIncentiveResourceTarget(resourceTarget, 250);
        System.assertEquals(250, updatedResourceTarget.dmpl__Value__c, 'Value should be updated.');
    }

    @isTest
    static void deleteIncentiveResourceTarget() {
        dmpl__IncentiveResourceTarget__c resourceTarget = IncentiveTargetDataHelper.getIncentiveResourceTarget();
        Integer count = IncentiveTargetDataHelper.deleteIncentiveResourceTarget(resourceTarget);
        System.assertEquals(0, count, 'Incentive Resource Target should be deleted and not found in query.');
    }
}