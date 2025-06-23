public with sharing class DocumentAmountResult {

    @AuraEnabled
    public List<DocumentAmountTaxResult> documentTaxes {get; set;}

    @AuraEnabled
    public List<Payment__c> documentPayments {get; set;}

    @AuraEnabled
    public List<FinanceCase__c> documentFinanceCases {get; set;}

    @AuraEnabled
    public List<dmpl__PaymentAdjustment__c> documentAdjustments {get; set;}

}