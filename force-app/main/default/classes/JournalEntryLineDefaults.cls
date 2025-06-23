public with sharing class JournalEntryLineDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults() {
        return new Map<String, Object>{
            'dmpl__Credit__c' => 100.00,
            'dmpl__Debit__c' => 0.00,
            'dmpl__Description__c' => 'Test Line',
            'dmpl__ExternalId__c' => 'null'
        };
    }
}