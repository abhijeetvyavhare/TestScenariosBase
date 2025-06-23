@isTest
public class FieldSalesDataHelper {    
    public static dmpl__FieldSales__c createFieldSales(Account partnerAccount, dmpl__Branch__c branch, dmpl__Resource__c resource) {
        return (dmpl__FieldSales__c) TestFactory.createSObject(
            new dmpl__FieldSales__c(
                dmpl__BranchId__c = branch.Id,
                dmpl__PartnerAccountId__c = partnerAccount.Id,
                dmpl__ResourceId__c = resource.Id,
                dmpl__DocumentDate__c = System.today(),
                dmpl__IsLoadReleased__c = false,
                dmpl__IsPlanReleased__c = false,
                dmpl__IsUnloadReleased__c = false,
                dmpl__PerformLoad__c = false,
                dmpl__PerformReleaseLoad__c = false,
                dmpl__PerformReleaseUnload__c = false,
                dmpl__PerformReleaseVisitPlan__c = false,
                dmpl__PerformUnload__c = false
            ),
            'FieldSalesDefault',
            true
        );
    }

    public static dmpl__FieldSalesLine__c createFieldSalesLine(dmpl__FieldSales__c fieldSales, dmpl__Item__c item, dmpl__SKU__c sku) {
        return (dmpl__FieldSalesLine__c) TestFactory.createSObject(
            new dmpl__FieldSalesLine__c(
                dmpl__FieldSalesId__c = fieldSales.Id,
                dmpl__ItemId__c = item.Id,
                dmpl__SKUId__c = sku.Id,
                dmpl__Quantity__c = 1
            ),
            'FieldSalesLineDefaults',
            true
        );
    }

    public static dmpl__FieldSalesInvoice__c createFieldSalesInvoice(dmpl__FieldSales__c fieldSales, Account account, dmpl__SaleInvoice__c invoice) {
        return (dmpl__FieldSalesInvoice__c) TestFactory.createSObject(
            new dmpl__FieldSalesInvoice__c(
                dmpl__FieldSalesId__c = fieldSales.Id,
                dmpl__AccountId__c = account.Id,
                dmpl__InvoiceId__c = invoice.Id,
                dmpl__CollectedAmount__c = 100.00,
                dmpl__InvoiceAmount__c = 100.00
            ),
            'FieldSalesInvoiceDefaults',
            true
        );
    }

    public static dmpl__FieldSalesInvoice__c getFieldSalesInvoice() {
        return [SELECT Id, Name, dmpl__FieldSalesId__c, dmpl__AccountId__c, dmpl__InvoiceId__c, 
                dmpl__CollectedAmount__c, dmpl__InvoiceAmount__c
                FROM dmpl__FieldSalesInvoice__c LIMIT 1];
    }

    public static dmpl__FieldSalesInvoice__c getFieldSalesInvoice(Id fieldSalesInvoiceId) {
        return [SELECT Id, Name, dmpl__FieldSalesId__c, dmpl__AccountId__c, dmpl__InvoiceId__c,
                dmpl__CollectedAmount__c, dmpl__InvoiceAmount__c 
                FROM dmpl__FieldSalesInvoice__c 
                WHERE Id = :fieldSalesInvoiceId LIMIT 1];
    }

    public static dmpl__FieldSales__c getFieldSales() {
        return [SELECT Id, dmpl__BranchId__c, dmpl__PartnerAccountId__c, dmpl__ResourceId__c, dmpl__Status__c, dmpl__DocumentDate__c
                FROM dmpl__FieldSales__c LIMIT 1];
    }

    public static dmpl__FieldSales__c getFieldSales(Id fieldSalesId) {
        return [SELECT Id, dmpl__BranchId__c, dmpl__PartnerAccountId__c, dmpl__ResourceId__c, dmpl__Status__c, dmpl__DocumentDate__c
                FROM dmpl__FieldSales__c WHERE Id = :fieldSalesId LIMIT 1];
    }

    public static dmpl__FieldSalesLine__c getFieldSalesLine() {
        return [SELECT Id, dmpl__FieldSalesId__c, dmpl__ItemId__c, dmpl__SKUId__c, dmpl__Quantity__c
                FROM dmpl__FieldSalesLine__c LIMIT 1];
    }

    public static dmpl__FieldSalesLine__c getFieldSalesLine(Id fieldSalesId) {
        return [SELECT Id, dmpl__FieldSalesId__c, dmpl__ItemId__c, dmpl__SKUId__c, dmpl__Quantity__c, dmpl__ReceivedQuantity__c, dmpl__SoldQuantity__c, dmpl__DamagedQuantity__c
                FROM dmpl__FieldSalesLine__c 
                WHERE dmpl__FieldSalesId__c = :fieldSalesId LIMIT 1];
    }
}