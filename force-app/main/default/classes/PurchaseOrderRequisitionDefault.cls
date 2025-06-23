@isTest
public with sharing class PurchaseOrderRequisitionDefault implements TestFactory.FieldDefaults{
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{ 
            'dmpl__RequestedQuantity__c' => 5,
            'dmpl__OrderedQuantity__c' => 4
        };
    }
}