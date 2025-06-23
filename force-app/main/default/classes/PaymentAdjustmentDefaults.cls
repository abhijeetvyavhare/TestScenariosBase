@isTest
public with sharing class PaymentAdjustmentDefaults implements TestFactory.FieldDefaults {
    
    public Map<String, Object> getFieldDefaults() {
        return new Map<String, Object>{
            'dmpl__AdjustmentAmount__c' => 500
        };
    }
}