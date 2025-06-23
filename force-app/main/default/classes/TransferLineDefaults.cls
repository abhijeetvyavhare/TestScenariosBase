@isTest
public with sharing class TransferLineDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{
            'dmpl__Quantity__c' => 1
            
        };
    }
}