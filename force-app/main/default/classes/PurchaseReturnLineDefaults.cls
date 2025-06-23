@isTest
public with sharing class PurchaseReturnLineDefaults  implements TestFactory.FieldDefaults
{    
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{ 
            'dmpl__Quantity__c' => 2,
            'dmpl__UnitCost__c' => 100.0,
            'dmpl__SKUId__c' => null,
            'dmpl__PurchaseInvoiceId__c' => null,
            'dmpl__PurchaseReturnId__c' => null,
            'dmpl__ReturnType__c' => 'Damaged'

        };
    }
}