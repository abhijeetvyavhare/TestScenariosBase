@isTest
public with sharing class PerformanceKPIHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Account account = TestDataHelpers.createPartnerAccount();
        dmpl__Branch__c branch = TestDataHelpers.createBranch(account);
        dmpl__Item__c item = TestDataHelpers.createItem();
         Account partnerAccount2 = TestDataHelpers.createPartnerAccount('Partner 2', false, true, false, true, '45 Residency Road', 'Pune', 'Maharashtra', 'India', '411001', '22 Commerce Avenue', 'Pune', 'Maharashtra', 'India', '411038','91-99665544433');


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

    //KPI creation with all required fields (New)
    @isTest
    static void createKPIWithRequiredFieldsPositive(){
        Account account = TestDataHelpers.getPartnerAccount();
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        dmpl__Item__c item = TestDataHelpers.getItem();
        dmpl__PerformanceKPI__c PerformanceKpi= PerformanceKPIDataHelper.createPerformanceKPI(account, branch ,item , 100);
        dmpl__PerformanceKPI__c fetchedKpi = PerformanceKPIDataHelper.getPerformanceKPI(PerformanceKpi);
        System.assertEquals(account.Id, fetchedKpi.dmpl__AccountId__c, 'Partner Account should match');
        System.assertEquals(branch.Id, fetchedKpi.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(item.Id, fetchedKpi.dmpl__ItemId__c, 'Item should match');
       
    }

    //Create KPI with valid Partner Account and Branch (New)
    static void createKPIWithValidPartnerAccountAndBranchPositive(){
        Account account = TestDataHelpers.getPartnerAccount();
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        dmpl__Item__c item = TestDataHelpers.getItem();
        dmpl__PerformanceKPI__c PerformanceKpi= PerformanceKPIDataHelper.createPerformanceKPI(account, branch ,item , 100);
        dmpl__PerformanceKPI__c fetchedKpi = PerformanceKPIDataHelper.getPerformanceKPI(PerformanceKpi);
        System.assertEquals(account.Id, fetchedKpi.dmpl__AccountId__c, 'Partner Account should match');
        System.assertEquals(branch.Id, fetchedKpi.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(item.Id, fetchedKpi.dmpl__ItemId__c, 'Item should match');
        System.assertEquals(100, fetchedKpi.dmpl__TargetValue__c, 'Target Value should match');
    }
    
    //Create KPI with only required fields and save successfully (New)
    static void createKPIWithOnlyRequiredFieldsPositive(){
        Account account = TestDataHelpers.getPartnerAccount();
        dmpl__PerformanceKPI__c PerformanceKpi= PerformanceKPIDataHelper.createPerformanceKPI(account , 100);
        dmpl__PerformanceKPI__c fetchedKpi = PerformanceKPIDataHelper.getPerformanceKPI(PerformanceKpi);
        System.assertEquals(account.Id, fetchedKpi.dmpl__AccountId__c, 'Partner Account should match');
        System.assertEquals(100, fetchedKpi.dmpl__NumberOfServiceRequests__c, 'Target Value should match');
    }
   
    //Create KPI with minimum allowed value in all numeric fields
    @isTest
    static void createKPIWithMinimumAllowedNumericValuesPositive(){
        Account account = TestDataHelpers.getPartnerAccount();
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        dmpl__Item__c item = TestDataHelpers.getItem();
        dmpl__PerformanceKPI__c PerformanceKpi= PerformanceKPIDataHelper.createPerformanceKPI(account, branch ,item , 1);
        dmpl__PerformanceKPI__c fetchedKpi = PerformanceKPIDataHelper.getPerformanceKPI(PerformanceKpi);
        System.assertEquals(account.Id, fetchedKpi.dmpl__AccountId__c, 'Partner Account should match');
        System.assertEquals(branch.Id, fetchedKpi.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(item.Id, fetchedKpi.dmpl__ItemId__c, 'Item should match');
        System.assertEquals(1, fetchedKpi.dmpl__NumberOfServiceRequests__c, 'Target Value should match');
    }
    
    //Create KPI without Partner Account (New)
    @isTest
    static void createKPIWithoutPartnerAccountNegative(){
        Boolean exceptionThrown= false;
        Account account = TestDataHelpers.getPartnerAccount();
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        dmpl__Item__c item = TestDataHelpers.getItem();

        try {
            dmpl__PerformanceKPI__c PerformanceKpi= PerformanceKPIDataHelper.createPerformanceKPI(null, branch ,item , 1);
        } catch (Exception e) {
           exceptionThrown= true;
       System.debug('Expected exception caught: ' + e.getMessage());
        }
        System.assertEquals(true, exceptionThrown, 'Expected exception was not thrown when using null as Partner Account');
    }
    
    //Create KPI without Branch (New)
    @isTest
    static void createKPIWithoutBranchNegative(){
        Boolean exceptionThrown= false;
        Account account = TestDataHelpers.getPartnerAccount();
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        dmpl__Item__c item = TestDataHelpers.getItem();

        try {
            dmpl__PerformanceKPI__c PerformanceKpi= PerformanceKPIDataHelper.createPerformanceKPI(account, null ,item , 1);
        } catch (Exception e) {
           exceptionThrown= true;
       System.debug('Expected exception caught: ' + e.getMessage());
        }
        System.assertEquals(true, exceptionThrown, 'Expected exception was not thrown when using null for Branch');
    }

    //Create KPI using inactive Partner Account (New)
    @isTest
    static void createKPIWithInactivePartnerAccountNegative(){
        Boolean exceptionThrown=false;
        Account partnerAccount2 = TestDataHelpers.createPartnerAccount('Partner 2', false, true, false, true, '45 Residency Road', 'Pune', 'Maharashtra', 'India', '411001', '22 Commerce Avenue', 'Pune', 'Maharashtra', 'India', '411038','91-99665544433');
        Account account = TestDataHelpers.getPartnerAccount('Partner 2');
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        dmpl__Item__c item = TestDataHelpers.getItem();
        try {
            dmpl__PerformanceKPI__c PerformanceKpi= PerformanceKPIDataHelper.createPerformanceKPI(account, branch ,item , 1);
        } catch (Exception e) {
           exceptionThrown= true;
       System.debug('Expected exception caught: ' + e.getMessage());
        }
       // System.assertEquals(true, exceptionThrown, 'Expected exception was not thrown when using null for Branch');
    }

    //Create KPI using inactive Branch (New)
    @isTest
    static void createKPIWithInactiveBranchNegative(){
        Boolean exceptionThrown=false;
        Account account = TestDataHelpers.getPartnerAccount('Partner 2');
        dmpl__Branch__c branch3 = TestDataHelpers.createBranch('Branch 3', account.Id, false, true, true, false);
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 3');
        dmpl__Item__c item = TestDataHelpers.getItem();
        try {
            dmpl__PerformanceKPI__c PerformanceKpi= PerformanceKPIDataHelper.createPerformanceKPI(account, branch ,item , 1);
        } catch (Exception e) {
           exceptionThrown= true;
       System.debug('Expected exception caught: ' + e.getMessage());
        }
        //System.assertEquals(true, exceptionThrown, 'Expected exception was not thrown when using null for Branch');
    }

    //Edit KPI and remove Branch field (Edit)
    @isTest
    static void updateKPIWithBranchRemovedNegative(){
        Boolean exceptionThrown=false;
        Account account = TestDataHelpers.getPartnerAccount();
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        dmpl__Item__c item = TestDataHelpers.getItem();
        dmpl__PerformanceKPI__c PerformanceKpi= PerformanceKPIDataHelper.createPerformanceKPI(account, branch ,item , 1);
        try {
            PerformanceKpi.dmpl__BranchId__c= null;
            update PerformanceKpi;
        } catch (Exception e) {
           exceptionThrown= true;
       System.debug('Expected exception caught: ' + e.getMessage());
        }
       // System.assertEquals(true, exceptionThrown, 'Expected exception was not thrown when using null for Branch');
    }

    //Edit KPI and clear Partner Account field (Edit)
    @isTest
    static void updateKPIWithPartnerAccountRemovedNegative(){
        Boolean exceptionThrown=false;
        Account account = TestDataHelpers.getPartnerAccount();
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        dmpl__Item__c item = TestDataHelpers.getItem();
        dmpl__PerformanceKPI__c PerformanceKpi= PerformanceKPIDataHelper.createPerformanceKPI(account, branch ,item , 1);
        try {
            PerformanceKpi.dmpl__AccountId__c= null;
            update PerformanceKpi;
        } catch (Exception e) {
           exceptionThrown= true;
       System.debug('Expected exception caught: ' + e.getMessage());
        }
       // System.assertEquals(true, exceptionThrown, 'Expected exception was not thrown when using null for Branch');
    }

    //Edit the KPI and add the total amount (Edit)
    @isTest
    static void updateKPIAddTotalAmountPositive(){
        Account account = TestDataHelpers.getPartnerAccount();
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        dmpl__Item__c item = TestDataHelpers.getItem();
        dmpl__PerformanceKPI__c PerformanceKpi= PerformanceKPIDataHelper.createPerformanceKPI(account, branch ,item , 1);
        PerformanceKpi.dmpl__TotalAmount__c= 100;
        update PerformanceKpi;
        dmpl__PerformanceKPI__c fetchedPerformanceKpi= PerformanceKPIDataHelper.getPerformanceKPI(PerformanceKpi);
        System.Assert.areEqual(100, fetchedPerformanceKpi.dmpl__TotalAmount__c, 'Total Amount did not match');
    }

    //Creation of KPI without entering Total quantity (new)
    @isTest
    static void createKPIWithoutTotalQuantity(){
         Account account = TestDataHelpers.getPartnerAccount();
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        dmpl__Item__c item = TestDataHelpers.getItem();
        dmpl__PerformanceKPI__c PerformanceKpi= PerformanceKPIDataHelper.createPerformanceKPI(account, branch ,item , 100);
        dmpl__PerformanceKPI__c fetchedKpi = PerformanceKPIDataHelper.getPerformanceKPI(PerformanceKpi);
        System.assertEquals(account.Id, fetchedKpi.dmpl__AccountId__c, 'Partner Account should match');
        System.assertEquals(branch.Id, fetchedKpi.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(item.Id, fetchedKpi.dmpl__ItemId__c, 'Item should match');
        System.assertEquals(20, fetchedKpi.dmpl__TotalQuantity__c, 'Target Value should match');
    }
}