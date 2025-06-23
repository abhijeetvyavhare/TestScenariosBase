@isTest
public with sharing class CompensationHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Account partnerAccount = TestDataHelpers.createPartnerAccount();
        Account customerAccount = TestDataHelpers.createCustomerAccount();
        dmpl__Branch__c branch = TestDataHelpers.createBranch(partnerAccount);
        dmpl__Item__c item = TestDataHelpers.createItem();
        dmpl__SKU__c sku = TestDataHelpers.createSKU(item);

        dmpl__IncentivePlan__c incentivePlan = IncentivePlanDataHelper.createIncentivePlan(
            'Monthly',
            'Resource',
            'Draft',
            Date.today(),
            Date.today().addMonths(1).addDays(-1),
            null, 
            partnerAccount.Id,
            null
        );

        dmpl__IncentivePeriod__c incentivePeriod = IncentivePlanDataHelper.createIncentivePeriod(
            incentivePlan.Id,
            Date.today(),
            Date.today().addMonths(1).addDays(-1),
            'Test Period',
            'Approved'
        );

        dmpl__IncentiveCompensation__c compensation = CompensationDataHelper.createCompensation(
            customerAccount,
            branch,
            partnerAccount,
            incentivePeriod.Id,
            incentivePlan.Id,
            'Draft'
        );

        CompensationDataHelper.createCompensationLine(
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
    static void createCompensationPositive() {
        dmpl__IncentiveCompensation__c compensation = CompensationDataHelper.getCompensation();
        System.assertNotEquals(compensation, null, 'Expected Compensation to be created.');
        System.assertEquals('Draft', compensation.dmpl__Status__c, 'Status should be Draft');
    }

    @isTest
    static void updateCompensationPositive() {
        dmpl__IncentiveCompensation__c compensation = CompensationDataHelper.getCompensation();
        dmpl__IncentiveCompensation__c updatedComp = CompensationDataHelper.updateCompensation(compensation, 'Approved');
        System.assertEquals('Approved', updatedComp.dmpl__Status__c, 'Status should be updated.');
    }

    @isTest
    static void deleteCompensation() {
        dmpl__IncentiveCompensation__c compensation = CompensationDataHelper.getCompensation();
        System.assertNotEquals(compensation, null, 'Compensation should exist before delete.');
        Boolean deleted = CompensationDataHelper.deleteCompensation(compensation);
        System.assertEquals(true, deleted, 'Compensation should be deleted.');
    }

    @isTest
    static void createCompensationLinePositive() {
        dmpl__IncentiveCompensationLine__c line = CompensationDataHelper.getCompensationLine();
        System.assertNotEquals(line, null, 'Expected Compensation Line to be created.');
        System.assertEquals(500, line.dmpl__IncentiveAmount__c, 'Incentive Amount should match');
        System.assertEquals('Approved', line.dmpl__Status__c, 'Status should match');
    }

    @isTest
    static void updateCompensationLinePositive() {
        dmpl__IncentiveCompensationLine__c line = CompensationDataHelper.getCompensationLine();
        dmpl__IncentiveCompensationLine__c updatedLine = CompensationDataHelper.updateCompensationLine(line, 1000);
        System.assertEquals(1000, updatedLine.dmpl__IncentiveAmount__c, 'Incentive Amount should be updated.');
    }

    @isTest
    static void deleteCompensationLine() {
        dmpl__IncentiveCompensationLine__c line = CompensationDataHelper.getCompensationLine();
        Integer count = CompensationDataHelper.deleteCompensationLine(line);
        System.assertEquals(0, count, 'Compensation Line should be deleted and not found in query.');
    }
}