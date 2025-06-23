@isTest
public with sharing class CompensationSlabHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Account partnerAccount = TestDataHelpers.createPartnerAccount();
        Account customerAccount = TestDataHelpers.createCustomerAccount();
        dmpl__Branch__c branch = TestDataHelpers.createBranch(partnerAccount);

        dmpl__IncentivePlan__c incentivePlan = (dmpl__IncentivePlan__c) TestFactory.createSObject(
            new dmpl__IncentivePlan__c(Name = 'Test Plan'),
            'IncentivePlanDefaults',
            true
        );

        dmpl__IncentivePeriod__c incentivePeriod = (dmpl__IncentivePeriod__c) TestFactory.createSObject(
            new dmpl__IncentivePeriod__c(
                Name = 'Test Period',
                dmpl__IncentivePlanId__c = incentivePlan.Id
            ),
            'IncentivePeriodDefaults',
            true
        );

        CompensationSlabDataHelper.createCompensationSlab(
            incentivePlan.Id,
            incentivePeriod.Id,
            10,
            20,
            'Fixed Amount',
            1000,
            1
        );
    }

    @isTest
    static void createCompensationSlabPositive() {
        dmpl__IncentiveCompensationSlab__c slab = CompensationSlabDataHelper.getCompensationSlab();
        System.assertNotEquals(slab, null, 'Expected Compensation Slab to be created.');
        System.assertEquals(10, slab.dmpl__FromPercentage__c, 'From Percentage should match');
        System.assertEquals(20, slab.dmpl__ToPercentage__c, 'To Percentage should match');
        System.assertEquals('Fixed Amount', slab.dmpl__CompensationType__c, 'Compensation Type should match');
        System.assertEquals(1000, slab.dmpl__IncentiveFixedAmount__c, 'Incentive Fixed Amount should match');
        System.assertEquals(1, slab.dmpl__SequenceNumber__c, 'Sequence Number should match');
    }

    @isTest
    static void updateCompensationSlabPositive() {
        dmpl__IncentiveCompensationSlab__c slab = CompensationSlabDataHelper.getCompensationSlab();
        dmpl__IncentiveCompensationSlab__c updatedSlab = CompensationSlabDataHelper.updateCompensationSlab(slab, 2000);
        System.assertEquals(2000, updatedSlab.dmpl__IncentiveFixedAmount__c, 'Incentive Fixed Amount should be updated.');
    }

    @isTest
    static void deleteCompensationSlab() {
        dmpl__IncentiveCompensationSlab__c slab = CompensationSlabDataHelper.getCompensationSlab();
        System.assertNotEquals(slab, null, 'Compensation Slab should exist before delete.');

        Integer count = CompensationSlabDataHelper.deleteCompensationSlab(slab);
        System.assertEquals(0, count, 'Compensation Slab should be deleted and not found in query.');
    }
}