public with sharing class CreditNoteLineDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults() {
        return new Map<String, Object>{
            'dmpl__Amount__c' => 100,
            'dmpl__Description__c' => 'Test Credit Note Line',
            'dmpl__ExternalId__c' => 'ext-id-line-001',
            'dmpl__GLAccountId__c' => null,
            'dmpl__GeneralLedgerId__c' => null,
            'dmpl__CreditNoteId__c' => null
        };
    }
}