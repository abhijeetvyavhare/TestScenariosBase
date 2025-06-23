public with sharing class PerformanceKPIDataHelper {
    public static dmpl__PerformanceKPI__c createPerformanceKPI(
        Account account,
        dmpl__Branch__c branch,
        dmpl__Item__c item
    ) {
        return (dmpl__PerformanceKPI__c) TestFactory.createSObject(
            new dmpl__PerformanceKPI__c(
                dmpl__AccountId__c = account.Id,
                dmpl__BranchId__c = branch.Id,
                dmpl__ItemId__c = item.Id,
                dmpl__NumberOfBills__c = 5,
                dmpl__NumberOfInvoices__c = 10,
                dmpl__TotalAmount__c = 1000,
                dmpl__TotalQuantity__c = 20,
                dmpl__PostingType__c = 'KPI'
            ),
            'PerformanceKPIDefaults',
            true
        );
    }

    public static dmpl__PerformanceKPI__c updatePerformanceKPI(
        dmpl__PerformanceKPI__c kpi,
        Integer numberOfBills
    ) {
        kpi.dmpl__NumberOfBills__c = numberOfBills;
        update kpi;
        return kpi;
    }

    public static Integer deletePerformanceKPI(dmpl__PerformanceKPI__c kpi) {
        Id kpiId = kpi.Id;
        delete kpi;
        return [
            SELECT COUNT() FROM dmpl__PerformanceKPI__c WHERE Id = :kpiId
        ];
    }

    public static dmpl__PerformanceKPI__c getPerformanceKPI() {
        return [
            SELECT 
                Id, 
                dmpl__AccountId__c, 
                dmpl__BranchId__c, 
                dmpl__ItemId__c, 
                dmpl__NumberOfBills__c, 
                dmpl__TotalAmount__c
            FROM dmpl__PerformanceKPI__c
            LIMIT 1
        ];
    }
}