public with sharing class SchemeAccountBudgetDataHelper {

    public static dmpl__SchemeAccountBudget__c createSchemeAccountBudget() {
        return (dmpl__SchemeAccountBudget__c) TestFactory.createSObject(
            new dmpl__SchemeAccountBudget__c(),
            'SchemeAccountBudgetDefaults',
            true
        );
    }

    public static dmpl__SchemeAccountBudget__c getSchemeAccountBudget() {
        return [
            SELECT Id, dmpl__BudgetAmount__c, dmpl__UtilizedAmount__c, dmpl__SchemeId__c
            FROM dmpl__SchemeAccountBudget__c
            LIMIT 1
        ];
    }

    public static dmpl__SchemeAccountBudget__c getSchemeAccountBudget(Id recordId) {
        return [
            SELECT Id, dmpl__BudgetAmount__c, dmpl__UtilizedAmount__c, dmpl__SchemeId__c
            FROM dmpl__SchemeAccountBudget__c
            WHERE Id = :recordId
            LIMIT 1
        ];
    }

    public static dmpl__Scheme__c createScheme() {
        dmpl__Scheme__c scheme = new dmpl__Scheme__c(
            Name = 'Test Scheme',
            dmpl__PeriodType__c = 'Monthly',
            dmpl__SchemeType__c = 'Per Bill'
        );
        insert scheme;
        return scheme;
    }

    public static dmpl__Scheme__c getScheme() {
        return [
            SELECT Id
            FROM dmpl__Scheme__c
            LIMIT 1
        ];
    }
}