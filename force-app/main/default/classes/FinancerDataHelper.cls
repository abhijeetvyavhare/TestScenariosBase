@isTest
public with sharing class FinancerDataHelper {
    public static dmpl__Financer__c createFinancer(Id customerAccountId) {
        return (dmpl__Financer__c) TestFactory.createSObject(
            new dmpl__Financer__c(
                dmpl__AccountId__c = customerAccountId
            ),
            'FinancerDefaults',
            true
        );
    }

    public static dmpl__Financer__c getFinancer() {
        return [
            SELECT Id, dmpl__Address__c, Name
            FROM dmpl__Financer__c
            LIMIT 1
        ];
    }

    public static dmpl__Financer__c getFinancer(Id financerId) {
        return [
            SELECT Id, dmpl__Address__c, Name
            FROM dmpl__Financer__c
            WHERE Id = :financerId
            LIMIT 1
        ];
    }

    public static List<dmpl__Financer__c> getFinancers() {
        return [
            SELECT Id, dmpl__Address__c, Name
            FROM dmpl__Financer__c
        ];
    }

    public static dmpl__FinancerScheme__c createFinancerScheme(
        dmpl__Financer__c financer,
        Id applicablePartnerAccountId,
        Id applicableToPartnerAccountGroupId
    ) {
        return (dmpl__FinancerScheme__c) TestFactory.createSObject(
            new dmpl__FinancerScheme__c(
                dmpl__FinancerId__c = financer.Id,
                dmpl__ApplicablePartnerAccountId__c = applicablePartnerAccountId,
                dmpl__ApplicableToPartnerAccountGroupId__c = applicableToPartnerAccountGroupId
            ),
            'FinancerSchemeDefaults',
            true
        );
    }

    public static dmpl__FinancerScheme__c getFinancerScheme() {
        return [
            SELECT Id, Name, dmpl__FinancerId__c, dmpl__ApplicablePartnerAccountId__c, dmpl__ApplicableToPartnerAccountGroupId__c
            FROM dmpl__FinancerScheme__c
            LIMIT 1
        ];
    }

    public static dmpl__FinancerScheme__c getFinancerScheme(Id schemeId) {
        return [
            SELECT Id, Name, dmpl__FinancerId__c, dmpl__ApplicablePartnerAccountId__c, dmpl__ApplicableToPartnerAccountGroupId__c
            FROM dmpl__FinancerScheme__c
            WHERE Id = :schemeId
            LIMIT 1
        ];
    }

    public static List<dmpl__FinancerScheme__c> getFinancerSchemes() {
        return [
            SELECT Id, Name, dmpl__FinancerId__c, dmpl__ApplicablePartnerAccountId__c, dmpl__ApplicableToPartnerAccountGroupId__c
            FROM dmpl__FinancerScheme__c
        ];
    }

    public static dmpl__FinanceCase__c createFinanceCase(
        Account customerAccount,
        dmpl__Branch__c branch,
        dmpl__SaleOrder__c saleOrder,
        dmpl__SaleInvoice__c saleInvoice,
        dmpl__Financer__c financer,
        dmpl__FinancerScheme__c scheme
    ) {
        dmpl__FinanceCase__c financeCase = new dmpl__FinanceCase__c(
            dmpl__AccountId__c = customerAccount.Id,
            dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
            dmpl__BranchId__c = branch.Id,
            dmpl__SaleOrderId__c = saleOrder.Id,
            dmpl__SaleInvoiceId__c = saleInvoice != null ? saleInvoice.Id : null,
            dmpl__FinanceProviderId__c = financer.Id,
            dmpl__FinanceSchemeId__c = scheme.Id,
            dmpl__RequestedAmount__c = 10000,
            dmpl__RequestedDownPayment__c = 1000,
            dmpl__RequestedInterestRate__c = 5,
            dmpl__RequestedTenureMonths__c = 12,
            dmpl__Status__c = 'Draft'
        );
        insert financeCase;
        return financeCase;
    }

    public static dmpl__FinanceCase__c getFinanceCase() {
        return [
            SELECT Id, dmpl__AccountId__c, dmpl__BranchId__c, dmpl__SaleOrderId__c, dmpl__SaleInvoiceId__c,
                   dmpl__FinanceProviderId__c, dmpl__FinanceSchemeId__c, dmpl__RequestedAmount__c,
                   dmpl__RequestedDownPayment__c, dmpl__RequestedInterestRate__c, dmpl__RequestedTenureMonths__c,
                   dmpl__Status__c
            FROM dmpl__FinanceCase__c
            LIMIT 1
        ];
    }

    public static dmpl__FinanceCase__c getFinanceCase(Id financeCaseId) {
        return [
            SELECT Id, dmpl__AccountId__c, dmpl__BranchId__c, dmpl__SaleOrderId__c, dmpl__SaleInvoiceId__c,
                   dmpl__FinanceProviderId__c, dmpl__FinanceSchemeId__c, dmpl__RequestedAmount__c,
                   dmpl__RequestedDownPayment__c, dmpl__RequestedInterestRate__c, dmpl__RequestedTenureMonths__c,
                   dmpl__Status__c
            FROM dmpl__FinanceCase__c
            WHERE Id = :financeCaseId
            LIMIT 1
        ];
    }

    public static List<dmpl__FinanceCase__c> getFinanceCases() {
        return [
            SELECT Id, dmpl__AccountId__c, dmpl__BranchId__c, dmpl__SaleOrderId__c, dmpl__SaleInvoiceId__c,
                   dmpl__FinanceProviderId__c, dmpl__FinanceSchemeId__c, dmpl__RequestedAmount__c,
                   dmpl__RequestedDownPayment__c, dmpl__RequestedInterestRate__c, dmpl__RequestedTenureMonths__c,
                   dmpl__Status__c
            FROM dmpl__FinanceCase__c
        ];
    }
}