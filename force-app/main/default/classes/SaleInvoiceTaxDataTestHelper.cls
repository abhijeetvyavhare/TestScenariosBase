@isTest
public class SaleInvoiceTaxDataTestHelper {
    
    public static dmpl__SaleInvoiceTax__c createSaleInvoiceTax(
        dmpl__SaleInvoice__c saleInvoice,
        dmpl__SaleInvoiceLine__c line
    ) {
        dmpl__SaleInvoiceTax__c tax = new dmpl__SaleInvoiceTax__c(
            dmpl__SaleInvoiceId__c = saleInvoice.Id,
            dmpl__SaleInvoiceLineId__c = line.Id,
            dmpl__TaxAmount__c = 100,
            dmpl__IsGLPosted__c = false,
            dmpl__IsGLPostingApproved__c = false
        );
        insert tax;
        return tax;
    }

    public static dmpl__SaleInvoiceTax__c getSaleInvoiceTax(Id taxId) {
        return [SELECT 
                Id, 
                dmpl__TaxAmount__c,
                dmpl__SaleInvoiceId__c,
                dmpl__SaleInvoiceLineId__c
                FROM dmpl__SaleInvoiceTax__c 
                WHERE Id = :taxId
                LIMIT 1];
    }

    public static dmpl__SaleInvoiceTax__c getSaleInvoiceTax() {
        return [SELECT 
                Id, 
                dmpl__TaxAmount__c,
                dmpl__SaleInvoiceId__c,
                dmpl__SaleInvoiceLineId__c
                FROM dmpl__SaleInvoiceTax__c 
                LIMIT 1];
    }
}