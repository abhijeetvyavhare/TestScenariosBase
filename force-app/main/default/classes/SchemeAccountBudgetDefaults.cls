@isTest
public with sharing class SchemeAccountBudgetDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults() {
        return new Map<String, Object>{
            'dmpl__BudgetAmount__c' => 10000.00,
            'dmpl__UtilizedAmount__c' => 2500.00
        };
    }
}