public with sharing class SubscriptionInvoiceHelper {
    
    public static void generateUsageInvoiceSummary()
    {
        List<dmpl__SubscriptionUsageSumary__c> usageSummary = querySubscriptionUsageSummary();
        List<Id> itemIds = new List<Id>();

        for(dmpl__SubscriptionUsageSumary__c usage : usageSummary)
        {
            itemIds.add(usage.dmpl__SubscriptionId__r.dmpl__ItemId__c);
        }

        List<dmpl__ItemConsumptionSchedule__c> consumptionSchedules = queryItemConsumptionSchedule(itemIds);
        Map<Id, dmpl__SaleInvoice__c> invoiceDocuments = new Map<Id,dmpl__SaleInvoice__c>();
        Map<Id, List<dmpl__SaleInvoiceLine__c>> invoiceLines = new Map<Id, List<dmpl__SaleInvoiceLine__c>>();

        for(dmpl__SubscriptionUsageSumary__c usage : usageSummary)
        {
            Decimal consumptionPrice = getConsumptionPrice(
            usage.dmpl__UnbilledQuantity__c,
            usage.dmpl__SubscriptionId__r.dmpl__ItemId__c,
            consumptionSchedules);

            dmpl__SaleInvoice__c invoiceDocument = null;
            if(invoiceDocuments.containsKey(usage.dmpl__SubscriptionId__c)){
                invoiceDocument = invoiceDocuments.get(usage.dmpl__SubscriptionId__c);
            }else {
                invoiceDocument = createSaleInvoiceDocumentFromSubscription(usage.dmpl__SubscriptionId__r.dmpl__BranchId__c,usage.dmpl__SubscriptionId__r.dmpl__PartnerAccountId__c,usage.dmpl__SubscriptionId__r.dmpl__AccountId__c, usage.dmpl__SubscriptionId__c);
                invoiceDocuments.put(usage.dmpl__SubscriptionId__c, invoiceDocument);
                invoiceLines.put(usage.dmpl__SubscriptionId__c, new List<dmpl__SaleInvoiceLine__c>());
            }
            invoiceLines.get(usage.dmpl__SubscriptionId__c).add(createSaleInvoiceLinesFromSubscription(usage.dmpl__SubscriptionId__r.dmpl__ItemId__c, 1, consumptionPrice, usage.Id, usage.dmpl__SubscriptionId__c));
        }

        if(invoiceDocuments.size() >0){
            Savepoint sp = Database.setSavepoint();
            try {
                SecurityHelper.ensureCanCreateObject('dmpl__SaleInvoice__c');
                SecurityHelper.ensureCanCreateFields(new string[]{'dmpl__BranchId__c','dmpl__PartnerAccountId__c','dmpl__DocumentDate__c','dmpl__AccountId__c'}, 'dmpl__SaleInvoice__c');
                insert invoiceDocuments.values();
                List<dmpl__SaleInvoiceLine__c> invoiceLineList = new List<dmpl__SaleInvoiceLine__c>();
                for(Id orderId : invoiceDocuments.keySet()){
                    dmpl__SaleInvoice__c invoice = invoiceDocuments.get(orderId);
                    List<dmpl__SaleInvoiceLine__c> saleInvoiceLines = invoiceLines.get(orderId);
                    for(dmpl__SaleInvoiceLine__c saleInvoiceLine : saleInvoiceLines){
                        saleInvoiceLine.dmpl__SaleInvoiceId__c = invoice.Id;
                        invoiceLineList.add(saleInvoiceLine);
                    }
                }
                SecurityHelper.ensureCanCreateObject('dmpl__SaleInvoiceLine__c');
                SecurityHelper.ensureCanCreateFields(new string[]{'dmpl__ItemId__c','dmpl__Quantity__c','dmpl__SaleInvoiceId__c','dmpl__UnitPrice__c'}, 'dmpl__SaleInvoiceLine__c');
                insert invoiceLineList;
            } catch (Exception e) {
                Database.rollback(sp);
                throw e;
            }
        }
    }

    public static void generateRecurringInvoiceSummary()
    {
        List<dmpl__Subscription__c> subscriptions = querySubscription();
        Map<Id, dmpl__SaleInvoice__c> invoiceDocuments = new Map<Id,dmpl__SaleInvoice__c>();
        Map<Id, List<dmpl__SaleInvoiceLine__c>> invoiceLines = new Map<Id, List<dmpl__SaleInvoiceLine__c>>();

        for(dmpl__Subscription__c subscription : subscriptions)
        {
            dmpl__SaleInvoice__c invoiceDocument = null;
            if(invoiceDocuments.containsKey(subscription.Id)){
                invoiceDocument = invoiceDocuments.get(subscription.Id);
            }else {
                invoiceDocument = createSaleInvoiceDocumentFromSubscription(subscription.dmpl__BranchId__c, subscription.dmpl__PartnerAccountId__c, subscription.dmpl__AccountId__c, subscription.Id);
                invoiceDocuments.put(subscription.Id, invoiceDocument);
                invoiceLines.put(subscription.Id, new List<dmpl__SaleInvoiceLine__c>());
            }
            invoiceLines.get(subscription.Id).add(createSaleInvoiceLinesFromSubscription(subscription.dmpl__ItemId__c, subscription.dmpl__Quantity__c, subscription.dmpl__UnitPrice__c, null, subscription.Id));
        }

        if(invoiceDocuments.size() >0){
            Savepoint sp = Database.setSavepoint();
            try {
                SecurityHelper.ensureCanCreateObject('dmpl__SaleInvoice__c');
                SecurityHelper.ensureCanCreateFields(new string[]{'dmpl__BranchId__c','dmpl__PartnerAccountId__c','dmpl__DocumentDate__c','dmpl__AccountId__c'}, 'dmpl__SaleInvoice__c');
                insert invoiceDocuments.values();
                List<dmpl__SaleInvoiceLine__c> invoiceLineList = new List<dmpl__SaleInvoiceLine__c>();
                for(Id orderId : invoiceDocuments.keySet()){
                    dmpl__SaleInvoice__c invoice = invoiceDocuments.get(orderId);
                    List<dmpl__SaleInvoiceLine__c> saleInvoiceLines = invoiceLines.get(orderId);
                    for(dmpl__SaleInvoiceLine__c saleInvoiceLine : saleInvoiceLines){
                        saleInvoiceLine.dmpl__SaleInvoiceId__c = invoice.Id;
                        invoiceLineList.add(saleInvoiceLine);
                    }
                }
                SecurityHelper.ensureCanCreateObject('dmpl__SaleInvoiceLine__c');
                SecurityHelper.ensureCanCreateFields(new string[]{'dmpl__ItemId__c','dmpl__Quantity__c','dmpl__SaleInvoiceId__c','dmpl__UnitPrice__c'}, 'dmpl__SaleInvoiceLine__c');
                insert invoiceLineList;
            } catch (Exception e) {
                Database.rollback(sp);
                throw e;
            }
        }

    }
    @testvisible
    private static Decimal getConsumptionPrice(Decimal consumedQuantity, Id itemid, 
        List<dmpl__ItemConsumptionSchedule__c> consumptionSchedules){

            List<dmpl__ItemConsumptionSchedule__c> filteredConsumptionSchedules = 
                        DocumentHelper.getObjectsByFilter(consumptionSchedules,'dmpl__ItemId__c', itemId);

            Decimal balanceQuantity = consumedQuantity;
            Decimal calculatedQuantity;
            Decimal finalPrice = 0;
            for(dmpl__ItemConsumptionRate__c consumptionRate : filteredConsumptionSchedules[0].dmpl__ItemConsumptionRates__r)
            {
                if(balanceQuantity > 0)
                {
                    if(consumptionRate.dmpl__UpperBound__c != null)
                    {
                        if(balanceQuantity >= (consumptionRate.dmpl__UpperBound__c - consumptionRate.dmpl__LowerBound__c + 1))
                        {
                            calculatedQuantity = (consumptionRate.dmpl__UpperBound__c - consumptionRate.dmpl__LowerBound__c + 1);
                            balanceQuantity = balanceQuantity - (consumptionRate.dmpl__UpperBound__c - consumptionRate.dmpl__LowerBound__c + 1);
                        }
                        else
                        {
                            calculatedQuantity = balanceQuantity;
                            balanceQuantity = 0;
                        }

                        if(consumptionRate.dmpl__PricingMethod__c == 'Flat Fee' && calculatedQuantity > 0)
                            finalPrice += consumptionRate.dmpl__Price__c;
                        else if(consumptionRate.dmpl__PricingMethod__c == 'Per Unit' && calculatedQuantity > 0)
                            finalPrice += consumptionRate.dmpl__Price__c * calculatedQuantity;

                    }
                    
                }
            }
            return finalPrice;
    }

    @TestVisible
    private static dmpl__SaleInvoice__c createSaleInvoiceDocumentFromSubscription(Id branchId, Id partnerAccountId, Id accountId, Id susbcriptionId)
    {
        return new dmpl__SaleInvoice__c(
            dmpl__BranchId__c = branchId,
            dmpl__PartnerAccountId__c = partnerAccountId,
            dmpl__DocumentDate__c = Datetime.now().date(),
            dmpl__AccountId__c = accountId,
            dmpl__SubscriptionId__c = susbcriptionId
        );
    }
    
    @TestVisible
    private static dmpl__SaleInvoiceLine__c createSaleInvoiceLinesFromSubscription(Id itemId, Decimal quantity, Decimal unitPrice, Id subscriptionUsageId, Id susbcriptionId)
    {
        return new dmpl__SaleInvoiceLine__c(
            dmpl__ItemId__c = itemId,
            dmpl__Quantity__c = quantity,
            dmpl__UnitPrice__c = unitPrice,
            dmpl__SubscriptionUsageSummaryId__c = subscriptionUsageId,
            dmpl__SubscriptionId__c = susbcriptionId
        );
    }

    private static List<dmpl__SubscriptionUsageSumary__c> querySubscriptionUsageSummary()
    {
        Date currentDate = Date.today();
        SecurityHelper.ensureCanReadFields(new string[]{
            'dmpl__BilledQuantity__c',
            'dmpl__UnbilledQuantity__c',
            'dmpl__SummaryEndDate__c',
            'dmpl__SummaryStartDate__c',
            'dmpl__OverrideQuantity__c',
            'dmpl__OverrideAmount__c',
            'dmpl__NextBillingDate__c',
            'dmpl__SubscriptionId__c'
        }, 'dmpl__SubscriptionUsageSumary__c');
        SecurityHelper.ensureCanReadFields(new string[]{
            'dmpl__AccountId__c',
            'dmpl__BranchId__c',
            'dmpl__ItemId__c',
            'dmpl__PartnerAccountId__c',
            'dmpl__PriceListId__c',
            'dmpl__ChargeType__c',
            'dmpl__BillingType__c',
            'dmpl__StartDate__c',
            'dmpl__TerminatedDate__c',
            'dmpl__UnitPrice__c',
            'dmpl__Quantity__c'
        }, 'dmpl__Subscription__c');
        return [SELECT 
        Id,
        Name,
        dmpl__BilledQuantity__c,
        dmpl__UnbilledQuantity__c,
        dmpl__SummaryEndDate__c,
        dmpl__SummaryStartDate__c,
        dmpl__OverrideQuantity__c,
        dmpl__OverrideAmount__c,
        dmpl__NextBillingDate__c,
        dmpl__SubscriptionId__c,
        dmpl__SubscriptionId__r.dmpl__AccountId__c,
        dmpl__SubscriptionId__r.dmpl__BillingType__c,//monthly
        dmpl__SubscriptionId__r.dmpl__BranchId__c,
        dmpl__SubscriptionId__r.dmpl__ChargeType__c,//recurring,usage
        dmpl__SubscriptionId__r.dmpl__EndDate__c,
        dmpl__SubscriptionId__r.dmpl__ItemId__c,
        dmpl__SubscriptionId__r.dmpl__PartnerAccountId__c,
        dmpl__SubscriptionId__r.dmpl__PriceListId__c,
        dmpl__SubscriptionId__r.dmpl__StartDate__c,
        dmpl__SubscriptionId__r.dmpl__TerminatedDate__c,
        dmpl__SubscriptionId__r.dmpl__UnitPrice__c,
        dmpl__SubscriptionId__r.dmpl__UnitCost__c
        FROM dmpl__SubscriptionUsageSumary__c
        WHERE dmpl__SubscriptionId__r.dmpl__ChargeType__c = 'Usage'
        AND (dmpl__NextBillingDate__c =: currentDate OR dmpl__SubscriptionId__r.dmpl__NextBillingDate__c =: currentDate)
        AND  (dmpl__SubscriptionId__r.dmpl__TerminatedDate__c = null OR  dmpl__SubscriptionId__r.dmpl__TerminatedDate__c >=: currentDate)
        AND (dmpl__SubscriptionId__r.dmpl__EndDate__c = null OR dmpl__SubscriptionId__r.dmpl__EndDate__c >=: currentDate)
        AND (dmpl__SubscriptionId__r.dmpl__StartDate__c = null OR dmpl__SubscriptionId__r.dmpl__StartDate__c <=: currentDate)
        ];
    }

    @TestVisible
    private static List<dmpl__Subscription__c> querySubscription()
    {
        Date currentDate = Date.today();

        SecurityHelper.ensureCanReadFields(new string[]{
            'dmpl__AccountId__c',
            'dmpl__BranchId__c',
            'dmpl__ItemId__c',
            'dmpl__PartnerAccountId__c',
            'dmpl__PriceListId__c',
            'dmpl__StartDate__c',
            'dmpl__TerminatedDate__c',
            'dmpl__UnitPrice__c',
            'dmpl__Quantity__c'
        }, 'dmpl__Subscription__c');
        return [SELECT 
        Id,
        Name,
        dmpl__AccountId__c,
        dmpl__BranchId__c,
        dmpl__ItemId__c,
        dmpl__PartnerAccountId__c,
        dmpl__PriceListId__c,
        dmpl__StartDate__c,
        dmpl__TerminatedDate__c,
        dmpl__UnitPrice__c,
        dmpl__Quantity__c
        FROM dmpl__Subscription__c
        WHERE dmpl__NextBillingDate__c =: currentDate
        And dmpl__ChargeType__c = 'Recurring'
        AND  (dmpl__TerminatedDate__c = null OR  dmpl__TerminatedDate__c >=: currentDate)
        AND (dmpl__EndDate__c = null OR dmpl__EndDate__c >=: currentDate)
        AND (dmpl__StartDate__c = null OR dmpl__StartDate__c <=: currentDate)
        ];
    }

    private static List<dmpl__ItemConsumptionSchedule__c> queryItemConsumptionSchedule(List<Id> itemIds)
    {
        SecurityHelper.ensureCanReadFields(new string[]{
            'dmpl__PartnerAccountId__c',
            'dmpl__UnitOfMeasure__c',
            'dmpl__BillingTerm__c',
            'dmpl__BillingTermUnit__c',
            'dmpl__ItemId__c'
        }, 'dmpl__ItemConsumptionSchedule__c');
        
        SecurityHelper.ensureCanReadFields(new string[]{
                    'dmpl__LowerBound__c',
                    'dmpl__UpperBound__c',
                    'dmpl__PricingMethod__c',
                    'dmpl__Price__c'
        }, 'dmpl__ItemConsumptionRate__c');
        return [SELECT 
                ID,
                Name,
                dmpl__PartnerAccountId__c,
                dmpl__UnitOfMeasure__c,
                dmpl__BillingTerm__c,
                dmpl__BillingTermUnit__c,
                dmpl__ItemId__c,
                (
                    Select Id,
                    Name,
                    dmpl__LowerBound__c,
                    dmpl__UpperBound__c,
                    dmpl__PricingMethod__c,
                    dmpl__Price__c
                    FROM 
                    dmpl__ItemConsumptionRates__r
                    Order by dmpl__LowerBound__c
                )
                FROM dmpl__ItemConsumptionSchedule__c
                WHERE dmpl__ItemId__c IN: itemIds];
    }

}