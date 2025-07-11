@isTest
public with sharing class SubscriptionDataHelper {
    public static dmpl__Subscription__c createSubscription(
        dmpl__SaleInvoice__c saleInvoice,
        dmpl__SaleInvoiceLine__c saleInvoiceLine,
        dmpl__Item__c item,
        Id parentItemId
    ) {
        return (dmpl__Subscription__c) TestFactory.createSObject(
            new dmpl__Subscription__c(
                dmpl__AccountId__c = saleInvoice.dmpl__AccountId__c,
                dmpl__BillingFrequency__c = item.dmpl__BillingFrequency__c,
                dmpl__BillingType__c = item.dmpl__BillingType__c,
                dmpl__PartnerAccountId__c= saleInvoice.dmpl__PartnerAccountId__c,
                dmpl__BranchId__c= saleInvoice.dmpl__BranchId__c,
                dmpl__ChargeType__c= item.dmpl__ChargeType__c,
                dmpl__StartDate__c = saleInvoice.dmpl__DocumentDate__c,
                dmpl__UnitPrice__c = saleInvoiceLine.dmpl__UnitPrice__c,
                dmpl__ItemId__c = saleInvoiceLine.dmpl__ItemId__c,
                dmpl__MarkupRate__c = item.dmpl__MarkupRate__c,
                dmpl__PricingMethod__c = item.dmpl__PricingMethod__c,
                dmpl__Quantity__c = saleInvoiceLine.dmpl__Quantity__c,
                dmpl__SaleOrderId__c = saleInvoice.dmpl__SaleOrderId__c,
                dmpl__SaleOrderLineId__c = saleInvoiceLine.dmpl__SaleOrderLineId__c
            ),
            'SubscriptionDefaults',
            true
        );
    }

    public static dmpl__Subscription__c createSubscription(
        Account partnerAccount,
        Account customerAccount,
        dmpl__Branch__c branch,
        dmpl__Item__c item,
        Decimal quantity,
        dmpl__SaleOrder__c saleOrder,
        dmpl__SaleOrderLine__c saleOrderLine,
        Decimal unitPrice
        
    ) {
        return (dmpl__Subscription__c) TestFactory.createSObject(
            new dmpl__Subscription__c(
                dmpl__PartnerAccountId__c= partnerAccount != null ? partnerAccount.Id : null,
                dmpl__AccountId__c = customerAccount != null ? customerAccount.Id : null,
                dmpl__BranchId__c= branch != null ? branch.Id : null,
                dmpl__ItemId__c = item != null ? item.Id : null,
                dmpl__Quantity__c = quantity != null ? quantity : null,
                dmpl__SaleOrderId__c = saleOrder != null ? saleOrder.Id : null,
                dmpl__SaleOrderLineId__c = saleOrderLine != null ? saleOrderLine.Id : null,
                dmpl__UnitPrice__c = unitPrice != null ? unitPrice : null 
                
            ),
            //'SubscriptionDefaults',
            true
        );
    }

    public static dmpl__Subscription__c updateSubscription(
        dmpl__SaleInvoice__c saleInvoice,
        dmpl__SaleInvoiceLine__c saleInvoiceLine,
        dmpl__Item__c item,
        Id parentItemId,
        dmpl__Subscription__c subscription
    ) {
        return (dmpl__Subscription__c) TestFactory.createSObject(
            new dmpl__Subscription__c(
                dmpl__AccountId__c = saleInvoice.dmpl__AccountId__c,
                dmpl__BillingFrequency__c = item.dmpl__BillingFrequency__c,
                dmpl__BillingType__c = item.dmpl__BillingType__c,
                dmpl__PartnerAccountId__c= saleInvoice.dmpl__PartnerAccountId__c,
                dmpl__BranchId__c= saleInvoice.dmpl__BranchId__c,
                dmpl__ChargeType__c= item.dmpl__ChargeType__c,
                dmpl__StartDate__c = saleInvoice.dmpl__DocumentDate__c,
                dmpl__UnitPrice__c = saleInvoiceLine.dmpl__UnitPrice__c,
                dmpl__ItemId__c = saleInvoiceLine.dmpl__ItemId__c,
                dmpl__MarkupRate__c = item.dmpl__MarkupRate__c,
                dmpl__PricingMethod__c = item.dmpl__PricingMethod__c,
                dmpl__Quantity__c = saleInvoiceLine.dmpl__Quantity__c,
                dmpl__SaleOrderId__c = saleInvoice.dmpl__SaleOrderId__c,
                dmpl__SaleOrderLineId__c = saleInvoiceLine.dmpl__SaleOrderLineId__c
            ),
            'SubscriptionDefaults',
            false
        );
    }

    public static dmpl__Subscription__c getSubscription() {
        return [SELECT 
            Id,
            Name,
            dmpl__NextBillingDate__c,
            dmpl__BillingFrequency__c,
            dmpl__ChargeType__c,
            dmpl__BillingType__c,
            dmpl__PricingMethod__c
            FROM dmpl__Subscription__c
            LIMIT 1
        ];
    }

    public static dmpl__Subscription__c getSubscription(Id subscriptionId) {
        return [SELECT 
            Id,
            Name,
            dmpl__NextBillingDate__c,
            dmpl__Quantity__c,
            dmpl__ItemId__c,
            dmpl__BranchId__c,
            dmpl__PartnerAccountId__c,
            dmpl__AccountId__c,
            dmpl__UnitPrice__c,
            dmpl__SaleOrderId__c,
            dmpl__SaleOrderLineId__c,
            dmpl__BillingFrequency__c,
            dmpl__ChargeType__c,
            dmpl__BillingType__c,
            dmpl__PricingMethod__c
            FROM dmpl__Subscription__c
            WHERE Id = :subscriptionId
            LIMIT 1
        ];
    }
    public static dmpl__SubscriptionUsageSumary__c createSubscriptionUsageSummary(Id Subscription,Integer BilledQuantity){
        return (dmpl__SubscriptionUsageSumary__c) TestFactory.createSObject(
            new dmpl__SubscriptionUsageSumary__c(
                dmpl__SubscriptionId__c = Subscription,
                dmpl__BilledQuantity__c = BilledQuantity
            ),
            true
        );
    }
 
     public static dmpl__SubscriptionUsageSumary__c  getSubscriptionUsageSummary(Id SubscriptionUsageSummary) {
        return [SELECT
            Id,
            dmpl__BilledQuantity__c,
            dmpl__SubscriptionId__c
            FROM dmpl__SubscriptionUsageSumary__c
            WHERE Id = :SubscriptionUsageSummary
            LIMIT 1
        ];
    }

}