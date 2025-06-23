@isTest
public with sharing class DiscountGroupRuleDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults() {
        return new Map<String, Object>{
            'dmpl__ClaimablePercentage__c' => 50,
            'dmpl__DateEffectiveFrom__c' => Date.today(),
            'dmpl__DateEffectiveTill__c' => Date.today().addMonths(1),
            'dmpl__DiscountPercent__c' => 15.25,
            'dmpl__ExternalId__c' => 'DISCOUNTRULE-TEST-001'
        };
    }
}