@isTest
public with sharing class DiscountGroupDefaults implements TestFactory.FieldDefaults {

    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{ 
            'Name' => 'Test - Discount - Group',
            'dmpl__DiscountType__c' => 'Sale Price',
            'dmpl__IsDefault__c' => true,
            'dmpl__IsActive__c' => true
        };
    }
}