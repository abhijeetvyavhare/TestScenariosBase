@isTest
public with sharing class PerformanceKPIHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Account account = TestDataHelpers.createPartnerAccount();
        dmpl__Branch__c branch = TestDataHelpers.createBranch(account);
        dmpl__Item__c item = TestDataHelpers.createItem();

        PerformanceKPIDataHelper.createPerformanceKPI(account, branch, item);
    }

    @isTest
    static void createPerformanceKPIPositive() {
        dmpl__PerformanceKPI__c kpi = PerformanceKPIDataHelper.getPerformanceKPI();
        System.assertNotEquals(null, kpi, 'Performance KPI should be created.');
        System.assertEquals(5, kpi.dmpl__NumberOfBills__c, 'NumberOfBills should be 5');
        System.assertEquals(1000, kpi.dmpl__TotalAmount__c, 'TotalAmount should be 1000');
    }

    @isTest
    static void updatePerformanceKPIPositive() {
        dmpl__PerformanceKPI__c kpi = PerformanceKPIDataHelper.getPerformanceKPI();
        dmpl__PerformanceKPI__c updated = PerformanceKPIDataHelper.updatePerformanceKPI(kpi, 99);
        System.assertEquals(99, updated.dmpl__NumberOfBills__c, 'NumberOfBills should be updated.');
    }

    @isTest
    static void deletePerformanceKPI() {
        dmpl__PerformanceKPI__c kpi = PerformanceKPIDataHelper.getPerformanceKPI();
        Integer count = PerformanceKPIDataHelper.deletePerformanceKPI(kpi);
        System.assertEquals(0, count, 'Performance KPI should be deleted.');
    }
}