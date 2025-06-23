@isTest
public with sharing class PurchaseRequisitionDefaults implements TestFactory.FieldDefaults {

    public Map<String, Object> getFieldDefaults() {
        return new Map<String, Object>{
            'dmpl__DocumentDate__c' => Date.today(),
            'dmpl__Description__c' => 'Sample Purchase Requisition', 
            'dmpl__Status__c' => 'Draft', 
            'dmpl__IsOrderReleased__c' => false, 
            'dmpl__PerformReleaseOrder__c' => false 
        };
    }
}