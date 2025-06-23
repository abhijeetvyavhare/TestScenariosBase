@isTest
public with sharing class ItemComponentDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults() {
        return new Map<String, Object>{
            'dmpl__ItemId__c' => null,
            'dmpl__ComponentItemId__c' => null,
            'dmpl__FeatureId__c' => null,
            'dmpl__PackageType__c' => 'Multiple Of Package',
            'dmpl__Quantity__c' => 1
        };
    }
}