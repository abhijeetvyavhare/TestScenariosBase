@isTest
public with sharing class SaleOrderTaxDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{ 
            'dmpl__TaxRate__c' => 3,
            'dmpl__TaxAmount__c' => 150,
            'dmpl__TaxOnAmount__c' => 100
        };
    }
}