@isTest
public with sharing class FinancerSchemeDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults() {
        return new Map<String, Object>{ 
            'Name' => 'Scheme Insert Test',
            'dmpl__Description__c' => 'Test scheme insert',
            'dmpl__ExternalId__c' => 'EXT123',
            'dmpl__Features__c' => 'Some features here',
            'dmpl__InterestRate__c' => 5.25,
            'dmpl__MaximumAmount__c' => 100000,
            'dmpl__MinimumAmount__c' => 5000,
            'dmpl__MaximumTenure__c' => 60,
            'dmpl__MinimumTenure__c' => 12
        };
    }
}