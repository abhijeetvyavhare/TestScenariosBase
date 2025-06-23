@isTest
public with sharing class PurchaseOrderLineDefaults implements TestFactory.FieldDefaults{
        public Map<String, Object> getFieldDefaults(){
            return new Map<String, Object>{ 
                'dmpl__Quantity__c' => 1,
                'dmpl__UnitCost__c' => 100,
                'dmpl__TaxGroupId__c' => null,
                'dmpl__SchemeDiscount__c' => 2,
                'dmpl__SchemeDiscountAmount__c' => 4,
                'dmpl__DiscountAmount__c' => 100
               
        };
    }

}