/****/
public with sharing class SaleOrderTestDataHelpers {
    public static dmpl__SaleOrder__c createSaleOrder(
        Account customerAccount,
        dmpl__Branch__c branch
     ) {
        return (dmpl__SaleOrder__c) TestFactory.createSObject(
            new dmpl__SaleOrder__c(
                dmpl__AccountId__c = customerAccount.Id,
                dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                dmpl__BranchId__c = branch.Id,
                dmpl__DocumentDate__c = Date.today(),
                dmpl__Status__c = 'Draft',
               // dmpl__BillingAddressId__c = contactAddress.Id,
                dmpl__RequiredDate__c = Date.today(),
                //dmpl__SalesExecutiveId__c = resource.Id,
                dmpl__BookingAmount__c = 100,
                dmpl__PromisedDate__c = Date.today(),
                dmpl__PerformReleaseFulfilment__c = false,
                dmpl__PerformReleaseInvoice__c = false,
                dmpl__PerformReleaseDelivery__c = false
            ),
            'SaleOrderDefaults',
            true
        );
    }
    public static dmpl__SaleOrder__c createSaleOrder(
        Account customerAccount,
        dmpl__ContactAddress__c contactAddress,
        dmpl__Branch__c branch
        
     ) {
        return (dmpl__SaleOrder__c) TestFactory.createSObject(
            new dmpl__SaleOrder__c(
                dmpl__AccountId__c = customerAccount.Id,
                dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                dmpl__BranchId__c = branch.Id,
                dmpl__DocumentDate__c = Date.today(),
                dmpl__Status__c = 'Draft',
                dmpl__BillingAddressId__c = contactAddress.Id,
                dmpl__RequiredDate__c = Date.today(),
                //dmpl__SalesExecutiveId__c = resource.Id,
                dmpl__BookingAmount__c = 100,
                dmpl__PromisedDate__c = Date.today(),
                dmpl__PerformReleaseFulfilment__c = false,
                dmpl__PerformReleaseInvoice__c = false,
                dmpl__PerformReleaseDelivery__c = false
            ),
            'SaleOrderDefaults',
            true
        );
    }
    public static dmpl__SaleOrder__c getSaleOrder() {
        return [SELECT 
                Id, 
                Name,
                dmpl__AccountId__c,
                dmpl__BranchId__c,
                dmpl__PartnerAccountId__c,
                dmpl__DocumentDate__c,
                dmpl__Discount__c,
                dmpl__PerformReleaseFulfilment__c,
                dmpl__PerformReleaseInvoice__c,
                dmpl__PerformReleaseDelivery__c,
                dmpl__TransactionType__c,
                (SELECT Id, 
                dmpl__Quantity__c,
                dmpl__PackageSaleOrderLineId__c 
                FROM SaleOrderLines__r)
                FROM dmpl__SaleOrder__c
                LIMIT 1
        ];
    }



    public static dmpl__SaleOrderLine__c createSaleOrderLine(
        dmpl__SaleOrder__c saleOrder,
        dmpl__Item__c item,
        dmpl__SKU__c sku,
        dmpl__TaxGroup__c taxGroup
    ) {
        return (dmpl__SaleOrderLine__c) TestFactory.createSObject(
            new dmpl__SaleOrderLine__c(dmpl__SaleOrderId__c = saleOrder.Id,
                                        dmpl__ItemId__c = item.Id,
                                        dmpl__SKUId__c = sku.Id,
                                        dmpl__Quantity__c = 15,
                                        dmpl__TaxGroupId__c = taxGroup.Id,
                                        dmpl__UnitPrice__c = 100,
                                        dmpl__Discount__c = 5,
                                        dmpl__DeliveryQuantity__c = 5
                                    ),
                                    'SaleOrderLineDefaults',
                                    true
            );
    }

    public static dmpl__SaleOrderLine__c getSaleOrderLine() {
        return [SELECT 
                Id, 
                Name,
                dmpl__UnitPrice__c, 
                dmpl__Quantity__c,
                dmpl__SaleOrderId__c,
                dmpl__PurchaseOrderLineId__c,
                dmpl__ReturnedQuantity__c,
                dmpl__SKUId__c,dmpl__ItemId__c,
                dmpl__ItemComponentId__c,
                dmpl__PackageSaleOrderLineId__c 
                FROM dmpl__SaleOrderLine__c
                LIMIT 1
        ];
    }

    public static dmpl__SaleOrder__c createSaleOrder1(
        dmpl__Branch__c branch,
        dmpl__ContactAddress__c contactAddress
    ){
       return (dmpl__SaleOrder__c)TestFactory.createSObject(
            new dmpl__SaleOrder__c(dmpl__AccountId__c = contactAddress.dmpl__AccountId__c,
                                    dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                    dmpl__BranchId__c = branch.Id,
                                    dmpl__DocumentDate__c = Date.today()+(7),
                                    dmpl__Status__c = 'Draft',
                                    dmpl__BillingAddressId__c = contactAddress.Id,
                                    dmpl__ShippingAddressId__c = contactAddress.Id,
                                    dmpl__RequiredDate__c = Date.today(),
                                    //dmpl__SalesExecutiveId__c = resource.Id,
                                    dmpl__BookingAmount__c = 100,
                                    dmpl__PromisedDate__c = Date.today(),
                                    dmpl__PerformReleaseFulfilment__c = false,
                                    dmpl__PerformReleaseInvoice__c = false,
                                    dmpl__PerformReleaseDelivery__c = false,
                                    dmpl__AmountPaid__c = 100
                                ),
                                'SaleOrderDefaults',
                                true
                                );
        
    }
    
    public static dmpl__SaleOrder__c getSaleOrder1(){
        return [
            SELECT Id, Name,dmpl__DocumentDate__c,dmpl__Discount__c
            FROM dmpl__SaleOrder__c
            LIMIT 1
        ];
    }

    public static dmpl__SaleOrder__c createSaleOrder2(
        dmpl__Branch__c branch,
        dmpl__ContactAddress__c contactAddress
    ){
       return (dmpl__SaleOrder__c)TestFactory.createSObject(
            new dmpl__SaleOrder__c(dmpl__AccountId__c = contactAddress.dmpl__AccountId__c,
                                    dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                    dmpl__BranchId__c = branch.Id,
                                    dmpl__DocumentDate__c = Date.today()-(7),
                                    dmpl__Status__c = 'Draft',
                                    dmpl__BillingAddressId__c = contactAddress.Id,
                                    dmpl__ShippingAddressId__c = contactAddress.Id,
                                    dmpl__RequiredDate__c = Date.today(),
                                    //dmpl__SalesExecutiveId__c = resource.Id,
                                    dmpl__BookingAmount__c = 100,
                                    dmpl__PromisedDate__c = Date.today(),
                                    dmpl__PerformReleaseFulfilment__c = false,
                                    dmpl__PerformReleaseInvoice__c = false,
                                    dmpl__PerformReleaseDelivery__c = false,
                                    dmpl__AmountPaid__c = 100
                                ),
                                'SaleOrderDefaults',
                                true
                                );
    }

    public static dmpl__SaleOrder__c getSaleOrder2(){
        return [
            SELECT Id, Name,dmpl__DocumentDate__c
            FROM dmpl__SaleOrder__c
            LIMIT 1
        ];
    }

    
    public static dmpl__SaleOrderLine__c createSaleOrderLine1(
        dmpl__SaleOrder__c saleOrder1
      ){
        return (dmpl__SaleOrderLine__c)TestFactory.createSObject(
              new dmpl__SaleOrderLine__c(
                dmpl__PackageSaleOrderLineId__c = saleOrder1.Id),
                'SaleOrderLineDefaults',
                true              
              );
    }
    public static dmpl__SaleOrderLine__c getSaleOrderLine1(){
        return [
            SELECT Id, Name
            FROM dmpl__SaleOrderLine__c
            LIMIT 1
        ];
    }

    public static dmpl__SaleOrderLine__c createSaleOrderLine2(
        dmpl__SaleOrder__c saleOrder2
      ){
        return (dmpl__SaleOrderLine__c)TestFactory.createSObject(
              new dmpl__SaleOrderLine__c(
                dmpl__PackageSaleOrderLineId__c = saleOrder2.Id
                ),
                'SaleOrderLineDefaults',
                true              
              );
    }
    public static dmpl__SaleOrderLine__c getSaleOrderLine2(){
        return [
            SELECT Id, Name,dmpl__FulfilmentAllocatedQuantity__c,
            dmpl__AllocatedInvoicedQuantity__c,
            dmpl__PendingAllocatedInvoicedQuantity__c 
            FROM dmpl__SaleOrderLine__c 
            WHERE dmpl__PendingAllocatedInvoicedQuantity__c != null 
            LIMIT 1
        ];
    }
}