@isTest
public with sharing class TransferOutwardLineDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{
            'dmpl__Quantity__c' => 1,
            'dmpl__UnitCost__c' => 10
        };
    }
}