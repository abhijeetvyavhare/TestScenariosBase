@isTest
public with sharing class SubscriptionUsageDataHelper {
    public static dmpl__SubscriptionUsage__c createSubscriptionUsage(
        Account acc,
        dmpl__SaleInvoiceLine__c saleInvoiceLine
    ) {
        return (dmpl__SubscriptionUsage__c) TestFactory.createSObject(
            new dmpl__SubscriptionUsage__c(
                dmpl__AccountId__c = acc.Id,
                dmpl__AssetId__c = saleInvoiceLine.dmpl__AssetId__c
            ),
            'SubscriptionUsageDefault',
            true
        );
    }

    public static dmpl__SubscriptionUsage__c updateSubscriptionUsage(
        Account acc,
        dmpl__SaleInvoiceLine__c saleInvoiceLine
    ) {
        return (dmpl__SubscriptionUsage__c) TestFactory.createSObject(
            new dmpl__SubscriptionUsage__c(
                dmpl__AccountId__c = acc.Id,
                dmpl__AssetId__c = saleInvoiceLine.dmpl__AssetId__c
            ),
            'SubscriptionUsageDefault',
            false
        );
    }

    public static dmpl__SubscriptionUsage__c getSubscriptionUsage(
    ) {
        return [Select 
            Id,
            Name,
            dmpl__Quantity__c
            FROM dmpl__SubscriptionUsage__c
            LIMIT 1
        ];
    }

    public static dmpl__SubscriptionUsage__c getSubscriptionUsage(
        dmpl__SubscriptionUsage__c subsUsage
    ) {
        return [Select 
            Id,
            Name,
            dmpl__Quantity__c
            FROM dmpl__SubscriptionUsage__c
            WHERE Id = :subsUsage.Id
            LIMIT 1
        ];
    }
}