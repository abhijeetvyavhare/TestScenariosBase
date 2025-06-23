@isTest
public with sharing class AutoPurchaseOrderLineRelationDefault implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object> {
            'dmpl__OrderQuantity__c' => 100,
            'dmpl__PurchaseOrderQuantity__c' => 10,
            'dmpl__UnitCost__c' => 1000
           
        };
    }
}