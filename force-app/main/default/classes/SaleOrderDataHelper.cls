@isTest
public with sharing class SaleOrderDataHelper {


        public static dmpl__SaleOrder__c createSaleOrder(
        Account customerAccount,
        dmpl__Branch__c branch,
        dmpl__ContactAddress__c contactAddress,
        dmpl__PriceList__c priceList
    ) {
        return (dmpl__SaleOrder__c) TestFactory.createSObject(
            new dmpl__SaleOrder__c(
                dmpl__AccountId__c = customerAccount.Id,
                dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                dmpl__BranchId__c = branch.Id,
                dmpl__DocumentDate__c = Date.today(),
                dmpl__Status__c = 'Draft',
                dmpl__RequiredDate__c = Date.today(),
                dmpl__PriceListId__c = priceList.Id,
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
    
    public static dmpl__SaleOrder__c createSaleOrderById(
        Account customerAccount,
        dmpl__Branch__c branch,
        dmpl__ContactAddress__c contactAddress,
        dmpl__PriceList__c priceList
    ) {
        return (dmpl__SaleOrder__c) TestFactory.createSObject(
            new dmpl__SaleOrder__c(
                dmpl__AccountId__c                  = customerAccount != null ? customerAccount.Id : null,
                dmpl__PartnerAccountId__c           = branch != null ? branch.dmpl__PartnerAccountId__c : null,
                dmpl__BranchId__c                   = branch != null ? branch.Id : null,
                dmpl__DocumentDate__c               = Date.today(),
                dmpl__Status__c                     = 'Draft',
                dmpl__RequiredDate__c               = Date.today(),
                dmpl__PriceListId__c                = priceList != null ? priceList.Id : null,
                dmpl__BookingAmount__c              = 100,
                dmpl__PromisedDate__c               = Date.today(),
                dmpl__PerformReleaseFulfilment__c   = false,
                dmpl__PerformReleaseInvoice__c      = false,
                dmpl__PerformReleaseDelivery__c     = false
            ),
            'SaleOrderDefaults',
            true
        );
    }


    public static dmpl__SaleOrder__c createSaleOrder(
        Id customerAccountId,
        Id partnerAccountId, 
        Id branchId,
        Id billingAddressId,
        Id shippingAddressId,
        Boolean skipScheme,
        Id resourceId
    ) {
        return (dmpl__SaleOrder__c) TestFactory.createSObject(
            new dmpl__SaleOrder__c(
                dmpl__PartnerAccountId__c = partnerAccountId,
                dmpl__BranchId__c = branchId,
                dmpl__AccountId__c = customerAccountId,
                dmpl__ShippingAddressId__c = shippingAddressId,
                dmpl__BillingAddressId__c =  billingAddressId,
                dmpl__SkipScheme__c = skipScheme,
                dmpl__SalesExecutiveId__c = resourceId
            ),
            'SaleOrderDefaults',
            true
        );
    }
    
      public static dmpl__SaleOrder__c createSaleOrder(
        Id customerAccountId,
        Id partnerAccountId,
        Id branchId,
        Id billingAddressId,
        Id shippingAddressId,
        Boolean skipScheme,
        Id resourceId,
        String taxSupplyType
    ) {
        return (dmpl__SaleOrder__c) TestFactory.createSObject(
            new dmpl__SaleOrder__c(
                dmpl__PartnerAccountId__c = partnerAccountId,
                dmpl__BranchId__c = branchId,
                dmpl__AccountId__c = customerAccountId,
                dmpl__ShippingAddressId__c = shippingAddressId,
                dmpl__BillingAddressId__c =  billingAddressId,
                dmpl__SkipScheme__c = skipScheme,
                dmpl__SalesExecutiveId__c = resourceId,
                dmpl__TaxSupplyType__c = taxSupplyType
            ),
            'SaleOrderDefaults',
            true
        );
    }

    public static dmpl__SaleOrder__c updateSaleOrder(
        Account customerAccount,
        dmpl__Branch__c branch,
        dmpl__ContactAddress__c contactAddress,
         dmpl__PriceList__c priceList,
         dmpl__SaleOrder__c saleOrder
    ) {
        return (dmpl__SaleOrder__c) TestFactory.createSObject(
            new dmpl__SaleOrder__c(
                id = saleOrder.id,
                dmpl__AccountId__c = customerAccount.Id,
                dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                dmpl__BranchId__c = branch.Id,
                dmpl__DocumentDate__c = Date.today(),
                dmpl__Status__c = 'Booked',
                dmpl__BillingAddressId__c = contactAddress.Id,
                dmpl__RequiredDate__c = Date.today()+2,
                dmpl__BookingAmount__c = 200,
                dmpl__PromisedDate__c = Date.today(),
                dmpl__PerformReleaseFulfilment__c = false,
                dmpl__PerformReleaseInvoice__c = false,
                dmpl__PerformReleaseDelivery__c = false
            ),
            'SaleOrderDefaults',
            false
        );
    }

    public static dmpl__PriceListRules__c getpriceListrule(Id pricelistId , Id Itemid)
    {    return 
            [
                SELECT Id, 
                        dmpl__Price__c,
                        dmpl__ItemId__c
                FROM dmpl__PriceListRules__c
                WHERE dmpl__PriceListId__c =:pricelistId
                AND dmpl__ItemId__c =: Itemid
                LIMIT 1
            ];
    }

    public static dmpl__PriceList__c getpriceList(Id pricelistId)
    {    return 
            [
                SELECT Id
                FROM dmpl__PriceList__c
                WHERE Id =:pricelistId
                LIMIT 1
            ];
    }

    public static dmpl__SaleOrder__c getSaleOrder() {
        return [
            SELECT Id, 
                   Name, 
                   dmpl__TotalOrderAmount__c, 
                   dmpl__PriceListId__c, 
                   dmpl__Status__c, 
                   dmpl__BookingAmount__c, 
                   dmpl__LineSubTotal__c
            FROM dmpl__SaleOrder__c
            LIMIT 1
        ];
    }
    
    public static dmpl__SaleOrder__c getSaleOrder(Id saleOrderId) {
    return [
        SELECT 
            Id, 
            Name,
            dmpl__PartnerAccountId__c, 
            dmpl__BranchId__c, 
            dmpl__AccountId__c,
            dmpl__AccountName__c, 
            dmpl__AccountPhone__c, 
            dmpl__PriceListId__c, 
            dmpl__PriceListId__r.Name,
            dmpl__TaxGroupId__c, 
            dmpl__TaxGroupId__r.Name, 
            dmpl__TaxSupplyType__c,
            dmpl__BillingStreet__c, 
            dmpl__BillingCity__c, 
            dmpl__BillingState__c,
            dmpl__BillingCountry__c, 
            dmpl__BillingPostalCode__c,
            dmpl__ShippingStreet__c, 
            dmpl__ShippingCity__c, 
            dmpl__ShippingState__c,
            dmpl__ShippingPostalCode__c, 
            dmpl__ShippingCountry__c,
            dmpl__BillingAddressId__c, 
            dmpl__ShippingAddressId__c,
            dmpl__Status__c, 
            dmpl__DocumentDate__c,
            dmpl__BookingAmount__c, 
            dmpl__TotalOrderAmount__c, 
            dmpl__LineSubTotal__c,
            dmpl__TotalLineBaseAmount__c, 
            dmpl__TotalLineGrossAmount__c, 
            dmpl__TotalTaxAmount__c,
            dmpl__TotalLineTaxAmount__c, 
            dmpl__TotalDiscountAmount__c, 
            dmpl__TotalSchemeDiscountAmount__c,
            dmpl__OutstandingAmount__c, 
            dmpl__OpenAmount__c,
            dmpl__DiscountGroupId__c,
            dmpl__DiscountGroupId__r.Name,
            dmpl__TotalTaxAmount2__c,
            dmpl__ContactNumber__c,
            dmpl__ContactName__c,
            dmpl__ContactId__c
        FROM dmpl__SaleOrder__c
        WHERE Id = :saleOrderId
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
                                                     dmpl__Discount__c = 5
                                                    ),
            true
        );
    }

    public static dmpl__SaleOrderLine__c createSaleOrderLine(
        Id saleOrderId,
        Id itemId,
        Integer quantity,
        Id skuId
    ) {
        return (dmpl__SaleOrderLine__c) TestFactory.createSObject(
            new dmpl__SaleOrderLine__c(dmpl__SaleOrderId__c = saleOrderId,
                                                     dmpl__ItemId__c = itemId, 
                                                     dmpl__Quantity__c = quantity,
                                                     dmpl__SKUId__c=skuId
                                                    ),
            true
        );
    }

     public static dmpl__SKU__c createSKU(String Name,Id item , Boolean isDefault) {
        return (dmpl__SKU__c) TestFactory.createSObject(
            new dmpl__SKU__c(
                Name = Name,
                dmpl__IsDefault__c = isDefault,
                dmpl__ItemId__c = item
            ),
            'SKUDefaults',
            true
        );
    }

    public static dmpl__SKU__c getSKU(Id itemId) {
        return [SELECT Id, Name,dmpl__ItemId__c,dmpl__IsDefault__c FROM dmpl__SKU__c LIMIT 1];
    }
 

    public static dmpl__SaleOrderLine__c updateSaleOrderLine(
        dmpl__SaleOrder__c saleOrder,
        dmpl__Item__c item,
        dmpl__SKU__c sku,
        dmpl__TaxGroup__c taxGroup,
        dmpl__SaleOrderLine__c saleOrderLine
    ) {
        return (dmpl__SaleOrderLine__c) TestFactory.createSObject(
            new dmpl__SaleOrderLine__c(id = saleOrderLine.id,dmpl__SaleOrderId__c = saleOrder.Id,
                                                     dmpl__ItemId__c = item.Id,
                                                     dmpl__SKUId__c = sku.Id,
                                                     dmpl__Quantity__c = 15,
                                                     dmpl__TaxGroupId__c = taxGroup.Id,
                                                     dmpl__UnitPrice__c = 500,
                                                     dmpl__Discount__c = 5
                                                    ),
            'SaleOrderLineDefaults',
            false
        );
    }
    
    public static dmpl__SaleOrderTax__c createSaleOrderTax(
        dmpl__SaleOrder__c saleOrder,
        dmpl__SaleOrderLine__c line
    ) {
        dmpl__SaleOrderTax__c tax = (dmpl__SaleOrderTax__c)TestFactory.createSObject(
            new dmpl__SaleOrderTax__c(
                dmpl__SaleOrderId__c = saleOrder.Id,
                dmpl__SaleOrderLineId__c = line.Id,
                dmpl__TaxAmount__c = 150,
                dmpl__TaxGroupId__c = line.dmpl__TaxGroupId__c,
                dmpl__TaxOnAmount__c = 100,
                dmpl__TaxRate__c = 3
            ),
            'SaleOrderTaxDefaults', 
            true
        );
        return tax;
    }

    public static dmpl__SaleOrderTax__c getSaleOrderTax() {
        return [SELECT 
                Id,
                dmpl__TaxAmount__c,
                dmpl__SaleOrderId__c,
                dmpl__SaleOrderLineId__c,
                dmpl__TaxGroupId__c,
                dmpl__TaxOnAmount__c,
                dmpl__TaxRate__c
                FROM dmpl__SaleOrderTax__c 
                LIMIT 1];
    }

    public static dmpl__SaleOrderTax__c getSaleOrderTax(Id taxId) {
        return [SELECT 
                Id,
                dmpl__TaxAmount__c,
                dmpl__SaleOrderId__c,
                dmpl__SaleOrderLineId__c,
                dmpl__TaxGroupId__c,
                dmpl__TaxOnAmount__c,
                dmpl__TaxRate__c
                FROM dmpl__SaleOrderTax__c 
                WHERE Id = :taxId
                LIMIT 1];
    }
    
    public static dmpl__SaleOrderTax__c getSaleOrderTaxes(Id saleOrderId){
        return [
            SELECT Id,
                dmpl__TaxId__c,
                dmpl__TaxAmount__c,
                dmpl__TaxOnAmount__c,
                dmpl__TaxGroupId__c,
                dmpl__TaxRate__c,
                dmpl__SaleOrderId__c,
                dmpl__SaleOrderLineId__c,
                dmpl__TaxGroupId__r.Name
                from dmpl__SaleOrderTax__c
                WHERE dmpl__SaleOrderId__c = :SaleOrderId
                LIMIT 1
        ];
    }

    public static dmpl__SaleOrderLine__c getSaleOrderLine() {
        return [
            SELECT 
                Id, 
                Name,
                dmpl__ItemId__c,
                dmpl__Amount__c, 
                dmpl__Quantity__c, 
                dmpl__Discount__c, 
                dmpl__UnitPrice__c, 
                dmpl__TaxGroupId__c, 
                dmpl__SaleOrderId__c
            FROM dmpl__SaleOrderLine__c
            LIMIT 1
        ];
    }

    public static dmpl__SaleOrderLine__c getSaleOrderLine(Id saleOrderId) {
        return [
            SELECT 
                Id,
                Name,
                dmpl__ItemId__c,
                dmpl__ItemId__r.Name,
                dmpl__Amount__c,
                dmpl__Quantity__c,
                dmpl__UnitPrice__c,
                dmpl__UnitPrice2__c,
                dmpl__Discount__c,
                dmpl__NetDiscount__c,
                dmpl__BaseAmount__c,
                dmpl__TaxAmount__c,
                dmpl__SKUId__c,
                dmpl__GrossAmount__c,
                dmpl__TaxGroupId__c,
                dmpl__TaxGroupId__r.Name,
                dmpl__Tax1__c,
                dmpl__Tax1Rate__c,
                dmpl__Tax1Type__c,
                dmpl__Tax1Name__c,
                dmpl__Tax2__c,
                dmpl__Tax2Rate__c,
                dmpl__Tax2Type__c,
                dmpl__Tax2Name__c,
                dmpl__SchemeLineId__c,
                dmpl__SchemeLineId__r.Name,
                dmpl__SchemeDiscount__c,
                dmpl__SchemeDiscountAmount__c,
                dmpl__NetSchemeDiscount__c,
                dmpl__BenefitId__c,
                dmpl__SaleOrderId__c
            FROM dmpl__SaleOrderLine__c
            WHERE dmpl__SaleOrderId__c = :saleOrderId
            LIMIT 1
        ];
    }

    public static dmpl__SaleOrderLine__c createSaleOrderLineById(
    Id saleOrderId,
    Id itemId,
    Integer quantity,
    Id skuId
) {
    return (dmpl__SaleOrderLine__c) TestFactory.createSObject(
        new dmpl__SaleOrderLine__c(
            dmpl__SaleOrderId__c = saleOrderId != null ? saleOrderId : null,
            dmpl__ItemId__c      = itemId != null ? itemId : null,
            dmpl__Quantity__c    = quantity,
            dmpl__SKUId__c       = skuId != null ? skuId : null
        ),
        true
    );
}


    public static List<dmpl__SaleOrderLine__c> getSaleOrderLines(Id saleOrderId) {
        return [
            SELECT 
                Id, 
                Name,
                dmpl__ItemId__c,
                dmpl__Amount__c, 
                dmpl__Quantity__c, 
                dmpl__UnitPrice__c, 
                dmpl__TaxGroupId__c, 
                dmpl__SaleOrderId__c, 
                dmpl__Discount__c,
                dmpl__BaseAmount__c,
                dmpl__TaxAmount__c,
                dmpl__SchemeLineId__c,
                dmpl__GrossAmount__c,
                dmpl__UnitPrice2__c, 
                dmpl__Tax1__c, 
                dmpl__Tax2__c,
                dmpl__Tax1Rate__c,
                dmpl__Tax1Type__c,
                dmpl__Tax1Name__c,
                dmpl__Tax2Name__c,
                dmpl__Tax2Rate__c,
                dmpl__Tax2Type__c,
                dmpl__NetSchemeDiscount__c,
                dmpl__NetDiscount__c,
                dmpl__TaxGroupId__r.Name,
                dmpl__SchemeDiscountAmount__c,
                dmpl__SchemeDiscount__c,
                dmpl__BenefitId__c
            FROM dmpl__SaleOrderLine__c
            WHERE dmpl__SaleOrderId__c = :saleOrderId
            ORDER BY CreatedDate ASC
        ];
    }
}