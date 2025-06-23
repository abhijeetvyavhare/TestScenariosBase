public with sharing class JournalEntryDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults() {
        return new Map<String, Object>{
            'dmpl__Currency__c' => 'INR',
            'dmpl__DocumentDate__c' => Date.today(),
            'dmpl__ExternalId__c' => 'null',
            'dmpl__Notes__c' => ' test journal entry',
            'dmpl__PartnerAccountId__c' => null  
        };
    }
}