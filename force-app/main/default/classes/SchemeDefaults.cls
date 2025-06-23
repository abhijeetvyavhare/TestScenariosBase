@isTest
public with sharing class SchemeDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults() {
        return new Map<String, Object>{
            'Name' => 'Test Scheme',
            'dmpl__ApplicableTransactionType__c' => 'Sample',
            'dmpl__Application__c' => 'Auto Apply',
            'dmpl__ClaimGenerationFrequency__c' => 'Monthly',
            'dmpl__ClaimablePercentage__c' => 75.00,
            'dmpl__IgnoreBudget__c' => false,
            'dmpl__IncludeChildAccountTransactions__c' => false,
            'dmpl__IncludeRelatedAccountTransactions__c' => false,
            'dmpl__IsClaimable__c' => true,
            'dmpl__MultipleFulfilmentTreatment__c' => 'Apply All Fulfilled',
            'dmpl__PerformCloneScheme__c' => false,
            'dmpl__PeriodEndDate__c' => Date.today().addMonths(3),
            'dmpl__PeriodStartDate__c' => Date.today(),
            'dmpl__PeriodType__c' => 'Quarterly',
            'dmpl__RoundOffType__c' => 'ceil',
            'dmpl__SchemeBudget__c' => 100000,
            'dmpl__SchemeQuota__c' => 80.00,
            'dmpl__SchemeType__c' => 'Per Period Bill',
            'dmpl__SequenceNumber__c' => 1,
            'dmpl__Status__c' => 'Active',
            'dmpl__UtilizedAmount__c' => 0,
            'dmpl__ValidCount__c' => 10,
            'dmpl__ValidFrom__c' => Date.today(),
            'dmpl__ValidTo__c' => Date.today().addYears(1)
        };
    }
}