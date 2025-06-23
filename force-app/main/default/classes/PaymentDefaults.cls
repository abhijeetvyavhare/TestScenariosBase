@isTest
public with sharing class PaymentDefaults implements TestFactory.FieldDefaults {
    
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{  
             'dmpl__AdjustedAmount__c' =>100
        };
    }
}