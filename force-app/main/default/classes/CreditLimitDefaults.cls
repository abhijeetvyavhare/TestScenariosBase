@isTest
public with sharing class CreditLimitDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults() {
        return new Map<String, Object>{
            'dmpl__CreditLimitAmount__c' => 100000,
            'dmpl__CreditDays__c' => 30,
            'dmpl__UtilizedLimit__c' => 20000,
            'dmpl__PartnerAccountId__c' => null,
            'dmpl__AccountId__c' => null
        };
    }
}