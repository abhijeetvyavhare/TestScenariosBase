public with sharing class CreditNoteDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults() {
        return new Map<String, Object>{
            'dmpl__Currency__c' => 'INR',
            'dmpl__DocumentDate__c' => Date.today(),
            'dmpl__ExternalId__c' => 'null',
            'dmpl__Notes__c' => 'test credit note',
            'dmpl__PartnerAccountId__c' => null,
            'dmpl__IsGLPosted__c' => false,
            'dmpl__IsGLPostingApproved__c' => false,
            'dmpl__PerformGLPosting__c' => false,
            'dmpl__BranchId__c'=>null
        };
    }
}