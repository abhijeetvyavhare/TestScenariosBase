public with sharing class SubscriptionHelper {

    private static Boolean skipValidations = false; 
    private static final string OBJECT_SUBSCRIPTION = 'dmpl__Subscription__c';
    private static final string FIELD_SALEINVOICELINELINE_SALEINVOICEID = 'dmpl__SaleInvoiceId__c';

    private static final List<String> LIST_NON_EDITABLE_FIELDS = new List<String>{};
    private static final List<String> LIST_FIELDS_SYSTEM = new List<String>{};
    private static final List<String> LIST_FIELDS_LOCKEDIFTRANSACTED = new List<String>{};

    public static void validateData(Boolean isInsert, Boolean isDelete, Boolean isUpdate, List<dmpl__Subscription__c> oldEntries, List<dmpl__Subscription__c> newEntries)
    { 
        try{     
            if(isInsert){
                FieldMappingHelper.copyFieldMappingData(
                    newEntries);
            }
            if(skipValidations){
                return;
            }
            if(isInsert){
            }else if(isUpdate){
            }else if(isDelete){
            }
        } catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }

    public static void createSubscription(List<dmpl__SaleInvoice__c> invoices, List<dmpl__SaleInvoiceLine__c> invoiceLines){
        Map<Id, dmpl__Item__c> items = new Map<Id, dmpl__Item__c>(
            ItemHelper.getCachedItems(
                DocumentHelper.extractIds(invoiceLines, 'dmpl__ItemId__c')));

        List<dmpl__Subscription__c> subscriptionsToCreate = new List<dmpl__Subscription__c>();
        for(dmpl__SaleInvoice__c invoice : invoices)
        {
            for(dmpl__SaleInvoiceLine__c invoiceLine : (List<dmpl__SaleInvoiceLine__c>)DocumentHelper.getObjects(
                                                        invoiceLines, 
                                                        FIELD_SALEINVOICELINELINE_SALEINVOICEID, 
                                                        invoice.Id))
            {
                System.debug(invoiceLine.dmpl__SubscriptionId__c);
                if(invoiceLine.dmpl__SubscriptionId__c != null)
                    continue;
                dmpl__Item__c item = items.get(invoiceLine.dmpl__ItemId__c);
                if(item == null){
                    throw new AuraHandledException(
                        String.format(
                            String.valueOf(System.Label.Generic_MissingObject), 
                            new String[]{dmpl__Item__c.class.getName()}));
                }

                if(item.dmpl__ItemType__c == ItemHelper.ITEM_TYPE_SUBSCRIPTION)
                {
                    Id assetId = invoiceLine.dmpl__AssetId__c;
                    Id parentItemId = null;
                    if(assetId == null && invoiceLine.dmpl__PackageSaleInvoiceLineId__c!=null)
                    {
                        dmpl__SaleInvoiceLine__c parentLine = (dmpl__SaleInvoiceLine__c)CollectionHelper.getObject(invoiceLines, invoiceLine.dmpl__PackageSaleInvoiceLineId__c);
                        if(parentLine!=null)
                        {
                            assetId = parentLine.dmpl__AssetId__c;
                            parentItemId = parentLine.dmpl__ItemId__c;
                        }
                    }
                    subscriptionsToCreate.add(
                        newSubscription(invoice, invoiceLine, item, parentItemId, assetId));
                }
            }
        }
        
        createSubscriptions(subscriptionsToCreate);
    }

    public static void updateSubscriptionDetailsFromSaleInvoice(List<dmpl__SaleInvoiceLine__c> saleInvoiceLines)
    {
        Map<Id, dmpl__Subscription__c> existingSubscriptions = querySubscriptions(DocumentHelper.extractIds(saleInvoiceLines, 'dmpl__SubscriptionId__c'));
        List<dmpl__Subscription__c> susbcriptionsToUpdate = new List<dmpl__Subscription__c>();
        for(dmpl__SaleInvoiceLine__c saleInvoiceLine : saleInvoiceLines)
        {
            dmpl__Subscription__c subscription = existingSubscriptions.get(saleInvoiceLine.dmpl__SubscriptionId__c);
            if(subscription != null)
            {
                if(subscription.dmpl__BillingFrequency__c == 'Monthly')
                    subscription.dmpl__NextBillingDate__c = saleInvoiceLine.CreatedDate.addMonths(1).date();
                else if(subscription.dmpl__BillingFrequency__c == 'Quarterly')
                    subscription.dmpl__NextBillingDate__c = saleInvoiceLine.CreatedDate.addMonths(3).date();
                else if(subscription.dmpl__BillingFrequency__c == 'Semiannual')
                    subscription.dmpl__NextBillingDate__c = saleInvoiceLine.CreatedDate.addMonths(6).date();
                else if(subscription.dmpl__BillingFrequency__c == 'Annual')
                    subscription.dmpl__NextBillingDate__c = saleInvoiceLine.CreatedDate.addMonths(12).date();
                
                subscription.dmpl__LastBillingDate__c = saleInvoiceLine.CreatedDate.date();
                susbcriptionsToUpdate.add(subscription);
            }
        }
        if(susbcriptionsToUpdate.Size() > 0){
            SecurityHelper.ensureCanWriteFields(new string[]{
                'dmpl__LastBillingDate__c',
                'dmpl__BillingFrequency__c',
                'dmpl__NextBillingDate__c'
            }, 'dmpl__Subscription__c');
            update susbcriptionsToUpdate;    
        }
    }

    public static void updateSubscriptionUsageDetailsFromSaleInvoice(List<dmpl__SaleInvoiceLine__c> saleInvoiceLines)
    {
        Map<Id, dmpl__SubscriptionUsageSumary__c> existingSubscriptionUsage = querySubscriptionUsage(DocumentHelper.extractIds(saleInvoiceLines, 'dmpl__SubscriptionUsageSummaryId__c'));
        List<dmpl__SubscriptionUsageSumary__c> susbcriptionUsageToUpdate = new List<dmpl__SubscriptionUsageSumary__c>();
        for(dmpl__SaleInvoiceLine__c saleInvoiceLine : saleInvoiceLines)
        {
            dmpl__SubscriptionUsageSumary__c subscriptionUsage = existingSubscriptionUsage.get(saleInvoiceLine.dmpl__SubscriptionUsageSummaryId__c);
            if(subscriptionUsage != null)
            {
                subscriptionUsage.dmpl__BilledQuantity__c = subscriptionUsage.dmpl__UnbilledQuantity__c;
                subscriptionUsage.dmpl__SaleInvoiceId__c = saleInvoiceLine.dmpl__SaleInvoiceId__c;
                subscriptionUsage.dmpl__SaleInvoiceLineId__c = saleInvoiceLine.Id;
                susbcriptionUsageToUpdate.add(subscriptionUsage);
            }
        }
        if(susbcriptionUsageToUpdate.Size() > 0){
            SecurityHelper.ensureCanWriteFields(new string[]{
                'dmpl__BilledQuantity__c',
                'dmpl__SaleInvoiceId__c',
                'dmpl__SaleInvoiceLineId__c'
            }, 'dmpl__SubscriptionUsageSumary__c');
            update susbcriptionUsageToUpdate;            
        }
    }

    @testVisible
    private static dmpl__Subscription__c newSubscription(
                                    dmpl__SaleInvoice__c invoice, 
                                    dmpl__SaleInvoiceLine__c invoiceLine, 
                                    dmpl__Item__c item,
                                    Id parentItemId,
                                    Id assetId)
    {
        dmpl__Subscription__c subscription =  new dmpl__Subscription__c(
            dmpl__AccountId__c = invoice.dmpl__AccountId__c,
            dmpl__AssetId__c = assetId,
            dmpl__BillingFrequency__c = item.dmpl__BillingFrequency__c,
            dmpl__BillingType__c = item.dmpl__BillingType__c,
            dmpl__PartnerAccountId__c= invoice.dmpl__PartnerAccountId__c,
            dmpl__BranchId__c= invoice.dmpl__BranchId__c,
            dmpl__ChargeType__c= item.dmpl__ChargeType__c,
            dmpl__StartDate__c = invoice.dmpl__DocumentDate__c,
            dmpl__UnitPrice__c = invoiceLine.dmpl__UnitPrice__c,
            dmpl__ItemId__c = invoiceLine.dmpl__ItemId__c,
            // dmpl__ItemComponentId__c = invoiceLine.dmpl__ItemId__c,
            // dmpl__MarkupAmount__c = item.dmpl__MarkupAmount__c,
            dmpl__MarkupRate__c = item.dmpl__MarkupRate__c,
            dmpl__PricingMethod__c = item.dmpl__PricingMethod__c,
            dmpl__Quantity__c = invoiceLine.dmpl__Quantity__c,
            dmpl__SaleOrderId__c = invoice.dmpl__SaleOrderId__c,
            dmpl__SaleOrderLineId__c = invoiceLine.dmpl__SaleOrderLineId__c
        );
        if(item.dmpl__SubscriptionDurationInMonths__c !=null){
            subscription.dmpl__EndDate__c = invoice.dmpl__DocumentDate__c.addMonths(Integer.valueOf(item.dmpl__SubscriptionDurationInMonths__c)) - 1;
        }

        if(item.dmpl__BillingFrequency__c == 'Monthly')
            subscription.dmpl__NextBillingDate__c = invoice.dmpl__DocumentDate__c.addMonths(1);
        else if(item.dmpl__BillingFrequency__c == 'Quarterly')
            subscription.dmpl__NextBillingDate__c = invoice.dmpl__DocumentDate__c.addMonths(3);
        else if(item.dmpl__BillingFrequency__c == 'Semiannual')
            subscription.dmpl__NextBillingDate__c = invoice.dmpl__DocumentDate__c.addMonths(6);
        else if(item.dmpl__BillingFrequency__c == 'Annual')
            subscription.dmpl__NextBillingDate__c = invoice.dmpl__DocumentDate__c.addMonths(12);
        
        return subscription;
    }

    private static void createSubscriptions(List<dmpl__Subscription__c> subscriptions){
        SecurityHelper.ensureCanCreateObject(OBJECT_SUBSCRIPTION);
        SecurityHelper.ensureCanCreateFields(new List<String>
        {
            'dmpl__AccountId__c',
            'dmpl__AssetId__c',
            'dmpl__BillingFrequency__c',
            'dmpl__BillingType__c',
            'dmpl__BranchId__c',
            'dmpl__PartnerAccountId__c',
            'dmpl__ChargeType__c',
            'dmpl__EndDate__c',
            'dmpl__StartDate__c',
            'dmpl__UnitPrice__c',
            'dmpl__ItemId__c',
            'dmpl__ItemComponentId__c',
            // 'dmpl__MarkupAmount__c',
            'dmpl__MarkupRate__c',
            'dmpl__PricingMethod__c',
            'dmpl__Quantity__c',
            'dmpl__SaleOrderId__c',
            'dmpl__SaleOrderLineId__c'
        }, OBJECT_SUBSCRIPTION);

        insert subscriptions;
    }

    private static Map<Id, dmpl__Subscription__c> querySubscriptions(List<Id> subscriptionId)
    {
        SecurityHelper.ensureCanReadFields(new string[]{
            'dmpl__LastBillingDate__c',
            'dmpl__BillingFrequency__c'
        }, 'dmpl__Subscription__c');
        return new Map<Id, dmpl__Subscription__c>([SELECT 
        Id,
        Name,
        dmpl__NextBillingDate__c,
        dmpl__BillingFrequency__c
        FROM dmpl__Subscription__c
        WHERE Id IN: subscriptionId
        ]);
    }

    private static Map<Id, dmpl__SubscriptionUsageSumary__c> querySubscriptionUsage(List<Id> subscriptionUsageId)
    {
        SecurityHelper.ensureCanReadFields(new string[]{
            'dmpl__SubscriptionId__c',
            'dmpl__SaleInvoiceId__c',
            'dmpl__SaleInvoiceLineId__c',
            'dmpl__BilledQuantity__c',
            'dmpl__UnbilledQuantity__c'
        }, 'dmpl__SubscriptionUsageSumary__c');
        return new Map<Id, dmpl__SubscriptionUsageSumary__c>([SELECT 
        Id,
        Name,
        dmpl__SubscriptionId__c,
        dmpl__SaleInvoiceId__c,
        dmpl__SaleInvoiceLineId__c,
        dmpl__BilledQuantity__c,
        dmpl__UnbilledQuantity__c
        FROM dmpl__SubscriptionUsageSumary__c
        WHERE Id IN: subscriptionUsageId
        ]);
    }
    
}