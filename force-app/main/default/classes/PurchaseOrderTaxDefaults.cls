@isTest
public with sharing class PurchaseOrderTaxDefaults implements TestFactory.FieldDefaults{
        public Map<String, Object> getFieldDefaults(){
            return new Map<String, Object>{ 
                'dmpl__TaxRate__c' => 10
        };
    }
}