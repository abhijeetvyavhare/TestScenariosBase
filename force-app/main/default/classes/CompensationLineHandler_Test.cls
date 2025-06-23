@isTest
public with sharing class CompensationLineHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Account partnerAccount = TestDataHelpers.createPartnerAccount();
        Account customerAccount = TestDataHelpers.createCustomerAccount();
        dmpl__Branch__c branch = TestDataHelpers.createBranch(partnerAccount);
        dmpl__Item__c item = TestDataHelpers.createItem();
        dmpl__SKU__c sku = TestDataHelpers.createSKU(item);

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

        dmpl__IncentiveCompensation__c compensation = (dmpl__IncentiveCompensation__c) TestFactory.createSObject(
            new dmpl__IncentiveCompensation__c(
                dmpl__AccountId__c = customerAccount.Id,
                dmpl__BranchId__c = branch.Id,
                dmpl__PartnerAccountId__c = partnerAccount.Id,
                dmpl__IncentivePeriodId__c = incentivePeriod.Id,
                dmpl__IncentivePlanId__c = incentivePlan.Id,
                dmpl__Status__c = 'Draft'
            ),
            'CompensationDefaults',
            true
        );

        CompensationLineDataHelper.createCompensationLine(
            compensation.Id,
            incentivePlan.Id,
            incentivePeriod.Id,
            item.Id,
            sku.Id,
            500,
            'Approved'
        );
    }

    @isTest
    static void createCompensationLinePositive() {
        dmpl__IncentiveCompensationLine__c line = CompensationLineDataHelper.getCompensationLine();
        System.assertNotEquals(line, null, 'Expected Compensation Line to be created.');
        System.assertEquals(500, line.dmpl__IncentiveAmount__c, 'Incentive Amount should match');
        System.assertEquals('Approved', line.dmpl__Status__c, 'Status should be Draft');
    }

    @isTest
    static void updateCompensationLinePositive() {
        dmpl__IncentiveCompensationLine__c line = CompensationLineDataHelper.getCompensationLine();
        dmpl__IncentiveCompensationLine__c updatedLine = CompensationLineDataHelper.updateCompensationLine(line, 1000);
        System.assertEquals(1000, updatedLine.dmpl__IncentiveAmount__c, 'Incentive Amount should be updated.');
    }

    @isTest
    static void deleteCompensationLine() {
        dmpl__IncentiveCompensationLine__c line = CompensationLineDataHelper.getCompensationLine();
        Integer count = CompensationLineDataHelper.deleteCompensationLine(line);
        System.assertEquals(0, count, 'Compensation Line should be deleted and not found in query.');
    }
}