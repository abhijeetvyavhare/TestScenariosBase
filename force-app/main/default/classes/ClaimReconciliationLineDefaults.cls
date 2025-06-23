@isTest
public with sharing class ClaimReconciliationLineDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{
            'dmpl__ClaimId__c' => null,
            'dmpl__ClaimLineId__c' => null,
            'dmpl__ClaimQuantity__c' => 10,
            'dmpl__ItemId__c' => null,
            'dmpl__ReconciliationId__c' => null,
            'dmpl__RejectedAmount__c' => 0,
            'dmpl__RejectionReason__c' => null,
            'dmpl__RejectQuantity__c' => 0,
            'dmpl__Remarks__c' => 'Test Remarks',
            'dmpl__Status__c' => 'Pending',
            'dmpl__UnitPrice__c' => 10
        };
    }
}