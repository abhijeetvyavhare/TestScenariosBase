@isTest
public with sharing class ClaimReconciliationDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults() {
        return new Map<String, Object>{
            'dmpl__CreditNoteAmount__c' => 1200.50,
            'dmpl__ReconciledAmount__c' => 1000.00,
            'dmpl__DocumentDate__c' => Date.today(),
            'dmpl__Status__c' => 'Draft'
        };
    }
}