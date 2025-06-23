@isTest
public class SaleOrderTaxDataHelper {
    
    public static dmpl__SaleOrderTax__c createSaleOrderTax(
        dmpl__SaleOrder__c saleOrder,
        dmpl__SaleOrderLine__c line
    ) {
        dmpl__SaleOrderTax__c tax = (dmpl__SaleOrderTax__c)TestFactory.createSObject(
            new dmpl__SaleOrderTax__c(
                dmpl__SaleOrderId__c = saleOrder.Id,
                dmpl__SaleOrderLineId__c = line.Id
            ),
            'SaleOrderTaxDefaults',
            true
        );
        return tax;
    }

    public static dmpl__SaleOrderTax__c getSaleOrderTax(Id taxId) {
        return [SELECT 
                Id, 
                dmpl__TaxAmount__c,
                dmpl__SaleOrderId__c,
                dmpl__SaleOrderLineId__c
                FROM dmpl__SaleOrderTax__c 
                WHERE Id = :taxId
                LIMIT 1];
    }

    public static dmpl__SaleOrderTax__c getSaleOrderTax() {
        return [SELECT 
                Id, 
                dmpl__TaxAmount__c,
                dmpl__SaleOrderId__c,
                dmpl__SaleOrderLineId__c
                FROM dmpl__SaleOrderTax__c 
                LIMIT 1];
    }
}