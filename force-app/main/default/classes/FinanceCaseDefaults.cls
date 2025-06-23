@isTest
public with sharing class FinanceCaseDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults() {
        return new Map<String, Object>{
            'dmpl__AccountId__c' => null,
            'dmpl__ApprovalRemarks__c' => 'Pending review',
            'dmpl__ApprovedAmount__c' => 0.00,
            'dmpl__ApprovedById__c' => null,
            'dmpl__ApprovedDownPayment__c' => 0.00,
            'dmpl__ApprovedInterestRate__c' => 0.00,
            'dmpl__ApprovedTenureMonths__c' => 12,
            'dmpl__BranchId__c' => null,
            'dmpl__DeclinedById__c' => null,
            'dmpl__DeclinedRemarks__c' => null,
            'dmpl__DisbursedAmount__c' => 0.00,
            'dmpl__DisbursementDate__c' => null,
            'dmpl__DisbursementNumber__c' => null,
            'dmpl__EMIOnApprovedAmount__c' => 0.00,
            'dmpl__EMIOnRequestedAmount__c' => 0.00,
            'dmpl__ExternalId__c' => null,
            'dmpl__FinanceProviderId__c' => null,
            'dmpl__FinanceSchemeId__c' => null,
            'dmpl__OtherFinancer__c' => null,
            'dmpl__PartnerAccountId__c' => null,
            'dmpl__RequestedAmount__c' => 10000.00,
            'dmpl__RequestedDownPayment__c' => 1000.00,
            'dmpl__RequestedInterestRate__c' => 5.00,
            'dmpl__RequestedTenureMonths__c' => 12,
            'dmpl__SaleInvoiceId__c' => null,
            'dmpl__SaleOrderId__c' => null,
            'dmpl__Status__c' => 'Draft'
        };
    }
}