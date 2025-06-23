@isTest
public with sharing class SchemeLedgerDefaults implements TestFactory.FieldDefaults {
    
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{ 
            //'dmpl__PartnerAccountId__c' => account.Id,
            //'dmpl__BranchId__c' => branch.Id,
            // 'dmpl__Description__c' => null,
            // 'dmpl__Discount__c' => '5',
            // 'dmpl__DiscountAmount__c' => '100',
            // 'dmpl__LineAmount__c' => '2399',
            // 'dmpl__RewardPoints__c' => '10'
            //'dmpl__SaleInvoiceId__c' => invoiceLine.'dmpl__SaleInvoiceId__c',
            //'dmpl__SaleInvoiceLineId__c' => invoiceLine.Id,
            //'dmpl__AccountId__c' => act.Id
        };
    }
}