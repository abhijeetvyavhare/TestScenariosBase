@isTest
public with sharing class SchemeConditionDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults() {
        return new Map<String, Object>{
            'dmpl__ConversionRatio__c' => 1.0,
            'dmpl__ConversionRatio1__c' => 2.5,
            'dmpl__ConditionOperator__c' => 'Equals',
            'dmpl__ConditionType__c' => 'Quantity',
            'dmpl__ConditionValue__c' => 100.00,
            'dmpl__SequenceNumber__c' => 1,
            'dmpl__Title__c' => 'Early Purchase Offer',
            'dmpl__UOM__c' => 'Pack',
            'dmpl__UOMQuantity__c' => 25.0,
            'dmpl__UOMQuantity1__c' => 5.0,
            'dmpl__UOM1__c' => 'Pack'
        };
    }
}