@isTest
public with sharing class DiscountVoucherDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults() {
        return new Map<String, Object>{
            'dmpl__AccountId__c' => null,
            'dmpl__Amount__c' => 100.00,
            'dmpl__BranchId__c' => null,
            'dmpl__CreditNoteId__c' => null,
            'dmpl__DiscountVoucherType__c' => 'Standard',
            'dmpl__DocumentDate__c' => Date.today(),
            'dmpl__GiftType__c' => 'None',
            'dmpl__PartnerAccountId__c' => null,
            'dmpl__RedeemedPoints__c' => 50,
            'dmpl__VoucherType__c' => 'Discount'
        };
    }
}