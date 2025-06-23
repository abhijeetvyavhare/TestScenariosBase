public with sharing class PaymentTestDataHelpers {

    public static dmpl__Payment__c createPayment(
        Account customerAccount,
        Account partnerAccount,
        dmpl__Branch__c branch,
        dmpl__SaleInvoice__c saleInvoice,
        Decimal amount
    ) {
        return (dmpl__Payment__c)TestFactory.createSObject(
            new dmpl__Payment__c(
                dmpl__AccountId__c = customerAccount.Id,
                dmpl__PartnerAccountId__c = partnerAccount.Id,
                dmpl__BranchId__c = branch.Id,
                dmpl__SaleInvoiceId__c = saleInvoice.Id,
                dmpl__Amount__c = amount,
                dmpl__Status__c = 'Draft'
            ),
            'PaymentDefaults',
            true
        );
    }

    public static dmpl__Payment__c updatePayment(
        Account customerAccount,
        Account partnerAccount,
        dmpl__Branch__c branch,
        dmpl__SaleInvoice__c saleInvoice,
        Decimal amount,
        dmpl__Payment__c payment
    ) {
        return (dmpl__Payment__c)TestFactory.createSObject(
            new dmpl__Payment__c(
                Id = payment.Id,
                dmpl__AccountId__c = customerAccount.Id,
                dmpl__PartnerAccountId__c = partnerAccount.Id,
                dmpl__BranchId__c = branch.Id,
                dmpl__SaleInvoiceId__c = saleInvoice.Id,
                dmpl__Amount__c = amount,
                dmpl__Status__c = 'Draft'
            ),
            'PaymentDefaults',
            false
        );
    }

    public static dmpl__Payment__c getPayment() {
        return [SELECT 
            Id,
            Name,
            dmpl__AccountId__c,
            dmpl__PartnerAccountId__c,
            dmpl__BranchId__c,
            dmpl__SaleInvoiceId__c,
            dmpl__Amount__c,
            dmpl__Status__c,
            dmpl__PaymentMode__c,
            dmpl__PaymentType__c,
            dmpl__PaymentDate__c,
            dmpl__IsGLPosted__c,
            dmpl__IsGLPostingApproved__c,
            dmpl__IsRelatedGLPosted__c
            FROM dmpl__Payment__c 
            LIMIT 1
        ];
    }

    public static dmpl__Payment__c getPayment(Id saleInvoiceId) {
        return [
            SELECT Id, Name, dmpl__Amount__c, dmpl__Status__c, dmpl__SaleInvoiceId__c, 
                   dmpl__PartnerAccountId__c, dmpl__PaymentMode__c, dmpl__PaymentType__c,
                   dmpl__PaymentDate__c, dmpl__IsGLPosted__c, dmpl__IsGLPostingApproved__c,
                   dmpl__IsRelatedGLPosted__c
            FROM dmpl__Payment__c
            WHERE dmpl__SaleInvoiceId__c = :saleInvoiceId
            LIMIT 1
        ];
    }

    public static List<dmpl__Payment__c> getPaymentsBySaleInvoice(Id saleInvoiceId) {
        return [
            SELECT Id, Name, dmpl__Amount__c, dmpl__Status__c, dmpl__SaleInvoiceId__c, 
                   dmpl__PartnerAccountId__c, dmpl__PaymentMode__c, dmpl__PaymentType__c,
                   dmpl__PaymentDate__c, dmpl__IsGLPosted__c, dmpl__IsGLPostingApproved__c,
                   dmpl__IsRelatedGLPosted__c
            FROM dmpl__Payment__c
            WHERE dmpl__SaleInvoiceId__c = :saleInvoiceId
        ];
    }

    public static List<dmpl__Payment__c> getPaymentsByAccount(Id accountId) {
        return [
            SELECT Id, Name, dmpl__Amount__c, dmpl__Status__c, dmpl__SaleInvoiceId__c, 
                   dmpl__PartnerAccountId__c, dmpl__PaymentMode__c, dmpl__PaymentType__c,
                   dmpl__PaymentDate__c, dmpl__IsGLPosted__c, dmpl__IsGLPostingApproved__c,
                   dmpl__IsRelatedGLPosted__c
            FROM dmpl__Payment__c
            WHERE dmpl__AccountId__c = :accountId
        ];
    }

    public static List<dmpl__Payment__c> getPaymentsByPartnerAccount(Id partnerAccountId) {
        return [
            SELECT Id, Name, dmpl__Amount__c, dmpl__Status__c, dmpl__SaleInvoiceId__c, 
                   dmpl__PartnerAccountId__c, dmpl__PaymentMode__c, dmpl__PaymentType__c,
                   dmpl__PaymentDate__c, dmpl__IsGLPosted__c, dmpl__IsGLPostingApproved__c,
                   dmpl__IsRelatedGLPosted__c
            FROM dmpl__Payment__c
            WHERE dmpl__PartnerAccountId__c = :partnerAccountId
        ];
    }

    public static List<dmpl__Payment__c> getPaymentsByBranch(Id branchId) {
        return [
            SELECT Id, Name, dmpl__Amount__c, dmpl__Status__c, dmpl__SaleInvoiceId__c, 
                   dmpl__PartnerAccountId__c, dmpl__PaymentMode__c, dmpl__PaymentType__c,
                   dmpl__PaymentDate__c, dmpl__IsGLPosted__c, dmpl__IsGLPostingApproved__c,
                   dmpl__IsRelatedGLPosted__c
            FROM dmpl__Payment__c
            WHERE dmpl__BranchId__c = :branchId
        ];
    }

    public static List<dmpl__Payment__c> getPaymentsByStatus(String status) {
        return [
            SELECT Id, Name, dmpl__Amount__c, dmpl__Status__c, dmpl__SaleInvoiceId__c, 
                   dmpl__PartnerAccountId__c, dmpl__PaymentMode__c, dmpl__PaymentType__c,
                   dmpl__PaymentDate__c, dmpl__IsGLPosted__c, dmpl__IsGLPostingApproved__c,
                   dmpl__IsRelatedGLPosted__c
            FROM dmpl__Payment__c
            WHERE dmpl__Status__c = :status
        ];
    }

    public static List<dmpl__Payment__c> getPaymentsByDateRange(Date startDate, Date endDate) {
        return [
            SELECT Id, Name, dmpl__Amount__c, dmpl__Status__c, dmpl__SaleInvoiceId__c, 
                   dmpl__PartnerAccountId__c, dmpl__PaymentMode__c, dmpl__PaymentType__c,
                   dmpl__PaymentDate__c, dmpl__IsGLPosted__c, dmpl__IsGLPostingApproved__c,
                   dmpl__IsRelatedGLPosted__c
            FROM dmpl__Payment__c
            WHERE dmpl__PaymentDate__c >= :startDate
            AND dmpl__PaymentDate__c <= :endDate
        ];
    }
}