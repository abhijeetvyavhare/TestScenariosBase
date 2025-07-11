@isTest
public with sharing class SchemeBenefitDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults() {
        return new Map<String, Object>{
            'dmpl__ConversionRatio__c' => 1.5,
            'dmpl__ConversionRatio1__c' => 2.0,
            'dmpl__DiscountAmount__c' => 500.00,
            'dmpl__DiscountPercent__c' => 10.00,
            'dmpl__DiscountedItemQuantity__c' => 5.0,
            'dmpl__DiscountedItemRanking__c' => 'High To Low',
            'dmpl__ExcludeQualifyingItems__c' => false,
            'dmpl__LimitExpiryDays__c' => 30,
            'dmpl__RepeatReward__c' => true,
            'dmpl__RepeatRewardsInRatio__c' => false,
            'dmpl__RewardPoints__c' => 100,
            'dmpl__RewardType__c' => 'Reward Points',
            'dmpl__SequenceNumber__c' => 1,
            'dmpl__Title__c' => 'Special Festive Discount',
            'dmpl__UOM__c' => 'Each',
            'dmpl__UOMQuantity__c' => 10.00,
            'dmpl__UOMQuantity1__c' => 2.00,
            'dmpl__UOM1__c' => 'Box'
        };
    }
}