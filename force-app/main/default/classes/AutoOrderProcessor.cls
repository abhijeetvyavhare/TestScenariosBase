public with sharing class AutoOrderProcessor implements Database.Batchable<SObject> {

    public static final Integer BATCH_SIZE = 200;
    private Id invokedQueueId;
    private Id autoOrderId;
    private String batchQuery;
    private dmpl__AutoPurchaseOrder__c autoOrder;
    private dmpl__AutoPurchaseOrder__c newAutoOrder;

    public static JobResponseResult perfromAction(
        Id recordId,
        Id queueId){
        try {
            dmpl__AutoPurchaseOrder__c autoOrderTemplate = queryAutoOrder(recordId);
            return processAutoOrder(recordId, queueId, autoOrderTemplate);
        } catch (Exception error) {
            ExceptionLogHelper.logException(error, queueId);
            throw error;
        }
    }

    public AutoOrderProcessor(
        Id agId,
        Id queueId,
        String query,
        dmpl__AutoPurchaseOrder__c autoOrderTemplate,
        dmpl__AutoPurchaseOrder__c newRecord){
            invokedQueueId = queueId;
            autoOrderId = agId;
            batchQuery = query;
            autoOrder = autoOrderTemplate;
            newAutoOrder = newRecord;
    }

    private static dmpl__AutoPurchaseOrder__c queryAutoOrder(Id autoOrderId)
    {
        SecurityHelper.ensureCanReadFields(new List<String>{
            'dmpl__AutoOrderType__c',
            'dmpl__AutoPurchaseOrderId__c',
            'dmpl__BranchId__c',
            'dmpl__BudgetAmount__c',
            'dmpl__DocumentDate__c',
            'dmpl__ExternalId__c',
            'dmpl__GeneratedById__c',
            'dmpl__IsOrderGenerated__c',
            'dmpl__IsTemplateCreated__c',
            'dmpl__LastAutoOrderDate__c',
            'dmpl__PartnerAccountId__c',
            'dmpl__PerformOrderGeneration__c',
            'dmpl__PriceListId__c',
            'dmpl__Remarks__c',
            'dmpl__Status__c',
            'dmpl__SupplierAccountId__c',
            'dmpl__ApplyInventoryAttributeSettings__c',
            'dmpl__ExcludeACategoryItems__c',
            'dmpl__ExcludeBCategoryItems__c',
            'dmpl__ExcludeCCategoryItems__c',
            'dmpl__ExcludeFastMovingItems__c',
            'dmpl__ExcludeSlowMovingItems__c',
            'dmpl__ExcludeNonMovingItems__c',
            'dmpl__IncludeInTransitShipments__c',
            'dmpl__IncludeOpenSaleOrders__c',
            'dmpl__IncludePendingPurchaseOrders__c',
            'dmpl__IncludeHighProbabilityQuote__c',
            'dmpl__IncludePurchaseRequisition__c',
            'dmpl__TotalAmount__c'}
            ,'dmpl__AutoPurchaseOrder__c');
            return [SELECT
            dmpl__AutoOrderType__c,
            dmpl__AutoPurchaseOrderId__c,
            dmpl__BranchId__c,
            dmpl__BudgetAmount__c,
            dmpl__DocumentDate__c,
            dmpl__ExternalId__c,
            dmpl__GeneratedById__c,
            dmpl__IsOrderGenerated__c,
            dmpl__IsTemplateCreated__c,
            dmpl__LastAutoOrderDate__c,
            dmpl__PartnerAccountId__c,
            dmpl__PerformOrderGeneration__c,
            dmpl__PriceListId__c,
            dmpl__Remarks__c,
            dmpl__Status__c,
            dmpl__SupplierAccountId__c,
            dmpl__ApplyInventoryAttributeSettings__c,
            dmpl__ExcludeACategoryItems__c,
            dmpl__ExcludeBCategoryItems__c,
            dmpl__ExcludeCCategoryItems__c,
            dmpl__ExcludeFastMovingItems__c,
            dmpl__ExcludeSlowMovingItems__c,
            dmpl__ExcludeNonMovingItems__c,
            dmpl__IncludeInTransitShipments__c,
            dmpl__IncludeOpenSaleOrders__c,
            dmpl__IncludePendingPurchaseOrders__c,
            dmpl__IncludeHighProbabilityQuote__c,
            dmpl__IncludePurchaseRequisition__c,
            dmpl__TotalAmount__c,
            Id,
            Name
        FROM
            dmpl__AutoPurchaseOrder__c
        WHERE 
            ID = : autoOrderId];
    }

    public Database.QueryLocator start(
        Database.BatchableContext bc){
            try {
                InterfaceQueueHelper.addStatusUpdate(
                        invokedQueueId,
                        'Starting Auto Order Batch'
                    );
                System.debug('Executing Batch Query' + batchQuery);
                return Database.getQueryLocator(batchQuery);
            } catch (Exception error) {
                ExceptionLogHelper.logException(error, invokedQueueId);
                throw error;
            }
    }

    public void execute(
        Database.BatchableContext bc, 
        List<SObject> scope){
        try {
            List<dmpl__AutoPurchaseOrderLine__c> newAutoOrderLines = new List<dmpl__AutoPurchaseOrderLine__c>();

            List<Id> itemIds = DocumentHelper.extractIds(scope, 'dmpl__ItemId__c');
            List<Id> skuIds = DocumentHelper.extractIds(scope, 'dmpl__SKUId__c');
            List<AggregateResult> itemAttributes = Database.query(getQuery(autoOrder, itemIds, skuIds));
            List<AggregateResult> pendingShipments = new List<AggregateResult>();
            List<AggregateResult> pendingSaleOrders = new List<AggregateResult>();
            List<AggregateResult> pendingPurchaseOrders = new List<AggregateResult>();
            List<AggregateResult> pendingPurchaseRequisitions = new List<AggregateResult>();

            List<AggregateResult> itemStock = queryItemStocks(autoOrder.dmpl__PartnerAccountId__c, autoOrder.dmpl__BranchId__c, itemIds);
            
            if(autoOrder.dmpl__IncludeInTransitShipments__c)
                pendingShipments = queryInTransitShipmentLines(autoOrder.dmpl__PartnerAccountId__c, autoOrder.dmpl__BranchId__c, itemIds);

            if(autoOrder.dmpl__IncludeOpenSaleOrders__c)
                pendingSaleOrders = queryOpenSaleOrders(autoOrder.dmpl__PartnerAccountId__c, autoOrder.dmpl__BranchId__c, itemIds);
            
            if(autoOrder.dmpl__IncludePendingPurchaseOrders__c)
                pendingPurchaseOrders = queryPendingPurchaseOrders(autoOrder.dmpl__PartnerAccountId__c, autoOrder.dmpl__BranchId__c, itemIds);

            if(autoOrder.dmpl__IncludePurchaseRequisition__c)
                pendingPurchaseRequisitions = queryPendingPurchaseRequisitions(autoOrder.dmpl__PartnerAccountId__c, autoOrder.dmpl__BranchId__c, itemIds);

            for(AggregateResult itemAttribute : itemAttributes)
            {
                // Available Stock + Pending Shipment Quantities + Pending Purchase order Quantities - Pending Requisition - Pending Sale Order Quantities - Pending Quote
                Decimal availableStock = getQuantity(itemStock, 'QuantityAvailable', itemAttribute);
                Decimal pendingShipmentQuantity = getQuantity(pendingShipments, 'TotalPendingQuantity', itemAttribute);
                Decimal pendingPurchaseOrderQuantity = getQuantity(pendingPurchaseOrders, 'TotalPendingQuantity', itemAttribute);
                Decimal pendingRequisitionQuantity = getQuantity(pendingPurchaseRequisitions, 'TotalPendingQuantity', itemAttribute);
                Decimal pendingSaleOrderQuantity = getQuantity(pendingSaleOrders, 'TotalPendingQuantity', itemAttribute);
                Decimal pendingQuoteQuantity = 0;
                Decimal minQuantity = getQuantity(itemAttributes, 'MinQuantity', itemAttribute);
                Decimal maxQuantity = getQuantity(itemAttributes, 'MaxQuantity', itemAttribute);
                Decimal projectedQuantity = availableStock 
                                            + pendingShipmentQuantity 
                                            + pendingPurchaseOrderQuantity 
                                            - pendingRequisitionQuantity
                                            - pendingSaleOrderQuantity 
                                            - pendingQuoteQuantity;

                // AggregateResult itemAttribute = (AggregateResult)getItemRecord(itemAttributes, itemId);
                Decimal reorderQuantity = ( Double.valueOf(itemAttribute.get('LeadTime'))) * (Double.valueOf(itemAttribute.get('AverageConsumption'))) 
                                            + minQuantity;

                String messages =
                                ' New Auto Order ' + newAutoOrder.Id + '\n'
                                + 'Item : ' +  (Id)itemAttribute.get('ItemId') + '\n'
                                // + 'Item Name : ' +  itemName + '\n'
                                + ' availableStock ' + availableStock + '\n'
                                + ' pendingQuoteQuantity ' + pendingQuoteQuantity  + '\n'
                                // + ' pendingRepairOrderQuantity ' + pendingRepairOrderQuantity + '\n'
                                + ' pendingSaleOrderQuantity ' + pendingSaleOrderQuantity + '\n'
                                + ' pendingRequisitionQuantity ' + pendingRequisitionQuantity + '\n'
                                + ' pendingPurchaseOrderQuantity ' + pendingPurchaseOrderQuantity + '\n'
                                + ' pendingShipmentQuantity ' + pendingShipmentQuantity + '\n'
                                + ' minQuantity ' + minQuantity  + '\n'
                                + ' maxQuantity ' + maxQuantity + '\n'
                                + ' LeadTime ' + itemAttribute.get('LeadTime')  + '\n'
                                // + ' Average Consu ' + avConsumption + '\n'
                                + ' projectedQuantity ' + projectedQuantity + '\n'
                                + ' reorderQuantity ' + reorderQuantity + '\n'
                                + ' orderQuantity ' + (maxQuantity - projectedQuantity);

                    ExceptionLogHelper.logMessage(
                                    messages);

                if(projectedQuantity > reorderQuantity)
                    continue;
                Decimal orderQuantity = maxQuantity - projectedQuantity;

                if(orderQuantity > 0)
                    newAutoOrderLines.add(new dmpl__AutoPurchaseOrderLine__c(
                        dmpl__AutoPurchaseOrderId__c = newAutoOrder.Id,
                        dmpl__ItemId__c = (Id)itemAttribute.get('ItemId'),
                        dmpl__SKUId__c = (Id)itemAttribute.get('SKUId'),
                        dmpl__Quantity__c = orderQuantity == null ? 0 : orderQuantity,
                        dmpl__SuggestedQuantity__c = orderQuantity == null ? 0 : orderQuantity,
                        dmpl__OpenOrderQuantity__c = pendingPurchaseOrderQuantity == null ? pendingPurchaseOrderQuantity : 0,
                        dmpl__QuantityAvailable__c = availableStock == null ? 0 : availableStock,
                        dmpl__PendingShipmentQuantity__c = pendingShipmentQuantity == null ? 0 : pendingShipmentQuantity,
                        dmpl__PendingPurchaseOrderQuantity__c = pendingPurchaseOrderQuantity == null ? 0 : pendingPurchaseOrderQuantity,
                        dmpl__PendingRequisitionQuantity__c = pendingRequisitionQuantity == null ? 0 : pendingRequisitionQuantity,
                        dmpl__PendingSaleOrderQuantity__c = pendingSaleOrderQuantity == null ? 0 : pendingSaleOrderQuantity,
                        dmpl__PendingQuoteQuantity__c = pendingQuoteQuantity == null ? 0 : pendingQuoteQuantity,
                        dmpl__MinimumQuantity__c = minQuantity == null ? 0 : minQuantity,
                        dmpl__MaximumQuantity__c = maxQuantity == null ? 0 : maxQuantity,
                        dmpl__LeadTime__c = Double.valueOf(itemAttribute.get('LeadTime') == null ? 0 : itemAttribute.get('LeadTime')),
                        dmpl__AverageConsumption__c = Double.valueOf(itemAttribute.get('AverageConsumption') == null ? 0 : itemAttribute.get('AverageConsumption'))
                    ));

            }
            
            Database.insert(newAutoOrderLines, false);

            InterfaceQueueHelper.addStatusUpdate(
                    invokedQueueId,
                    'Processed Batch Count ' + scope.size()
                );
        } catch (Exception error) {
            ExceptionLogHelper.logException(error, invokedQueueId);
            throw error;
        }
    }

    public void finish(
        Database.BatchableContext bc){
        try {
            InterfaceQueueHelper.addStatusUpdate(
                    invokedQueueId,
                    'Finished IG Batch'
                );
            // Database.executeBatch(
            //     new ItemGroupMemberCleaner(
            //         bc.getJobId(),
            //         invokedQueueId
            //     ), 
            //     BATCH_SIZE);
        } catch (Exception error) {
            ExceptionLogHelper.logException(error, invokedQueueId);
            throw error;
        }
    }

    public static JobResponseResult processAutoOrder(Id recordId, Id queueId, dmpl__AutoPurchaseOrder__c autoOrderTemplate)
    {
        // string query = getQuery(autoOrderTemplate);
        string query = getEligibleItemAttributesQuery(autoOrderTemplate);
        dmpl__AutoPurchaseOrder__c newRecord = new dmpl__AutoPurchaseOrder__c(dmpl__PartnerAccountId__c = autoOrderTemplate.dmpl__PartnerAccountId__c, dmpl__BranchId__c = autoOrderTemplate.dmpl__BranchId__c);
        insert newRecord;
        Id batchId = Database.executeBatch(
            new AutoOrderProcessor(
                recordId,
                queueId,
                query,
                autoOrderTemplate,
                newRecord
            ), 
            BATCH_SIZE);
        return new JobResponseResult(
            true, 
            null, 
            'Apex Batch Job Enqueued With Job Id ' + batchId);  
    }

    public static string getEligibleItemAttributesQuery(dmpl__AutoPurchaseOrder__c autoOrderTemplate)
    {
        string query = 'SELECT dmpl__ItemId__c, dmpl__SKUId__c FROM dmpl__ItemInventoryAttribute__c';
        List<String> whereClauseConditions = getConditions(autoOrderTemplate, new List<Id>(), new List<Id>());
        query = query + ' WHERE '+String.join(whereClauseConditions,' AND '); 
        return query;
    }

    public static string getQuery(dmpl__AutoPurchaseOrder__c autoOrderTemplate, List<Id> itemIds, List<Id> skuIds)
    {
        string query = 'SELECT dmpl__ItemId__c ItemId, dmpl__SKUId__c SKUId, AVG(dmpl__LeadTime__c) LeadTime, AVG(dmpl__AverageConsumption__c) AverageConsumption, AVG(dmpl__MinimumOrderQuantity__c) MinQuantity, AVG(dmpl__MaximumOrderQuantity__c) MaxQuantity FROM dmpl__ItemInventoryAttribute__c';
        string groupBy = ' GROUP BY dmpl__ItemId__c, dmpl__SKUId__c';
        List<String> whereClauseConditions = getConditions(autoOrderTemplate, itemIds, skuIds);
        query = query + ' WHERE '+String.join(whereClauseConditions,' AND ') + groupBy; 
        ExceptionLogHelper.logMessage('query '+query);
        return query;
    }

    private static List<String> getConditions(dmpl__AutoPurchaseOrder__c autoOrderTemplate, List<Id> itemIds, List<Id> skuIds)
    {
        List<String> conditions = new List<String>();

        conditions.add('(dmpl__PartnerAccountId__c = null OR dmpl__PartnerAccountId__c = \''+autoOrderTemplate.dmpl__PartnerAccountId__c+'\')');
        conditions.add('(dmpl__BranchId__c = null OR dmpl__BranchId__c = \''+autoOrderTemplate.dmpl__BranchId__c+'\')');

        if(autoOrderTemplate.dmpl__ExcludeFastMovingItems__c)
            conditions.add('dmpl__FSNCategory__c != \'Fast Moving\'');
        if(autoOrderTemplate.dmpl__ExcludeSlowMovingItems__c)
            conditions.add('dmpl__FSNCategory__c != \'Slow Moving\'');
        if(autoOrderTemplate.dmpl__ExcludeNonMovingItems__c)
            conditions.add('dmpl__FSNCategory__c != \'Non-Moving\'');

        if(autoOrderTemplate.dmpl__ExcludeACategoryItems__c)
            conditions.add('dmpl__ABCCategory__c != \'A Category\'');
        if(autoOrderTemplate.dmpl__ExcludeBCategoryItems__c)
            conditions.add('dmpl__ABCCategory__c != \'B Category\'');
        if(autoOrderTemplate.dmpl__ExcludeCCategoryItems__c)
            conditions.add('dmpl__ABCCategory__c != \'C Category\'');

        if(autoOrderTemplate.dmpl__ApplyInventoryAttributeSettings__c == 'Auto Min Max Settings' || autoOrderTemplate.dmpl__ApplyInventoryAttributeSettings__c == 'Prefer Auto')
            conditions.add('dmpl__PostingType__c = \'Auto\'');
        if(autoOrderTemplate.dmpl__ApplyInventoryAttributeSettings__c == 'Manual Min Max Settings')
            conditions.add('dmpl__PostingType__c = \'Manual\'');
        if(autoOrderTemplate.dmpl__ApplyInventoryAttributeSettings__c == 'Average of Auto & Manual Settings')
            conditions.add('dmpl__PostingType__c IN (\'Manual\', \'Auto\')');

        if(itemIds.size() > 0)
            conditions.add('dmpl__ItemId__c IN (\''+ String.join(itemIds, '\',\'') + '\')');
        if(skuIds.size() > 0)
            conditions.add('(dmpl__SKUId__c = null OR dmpl__SKUId__c IN (\''+ String.join(skuIds, '\',\'') + '\'))');

        return conditions;
    }

    private static List<AggregateResult> queryInTransitShipmentLines(Id partnerAccountId, Id branchId, List<Id> itemIds)
    {
        return [SELECT 
                    dmpl__ItemId__c ItemId,
                     SUM(dmpl__PendingQuantity__c) TotalPendingQuantity 
                     FROM dmpl__ShipmentLine__c 
                     WHERE dmpl__ShipmentId__r.dmpl__PartnerAccountId__c = : partnerAccountId 
                     AND dmpl__ShipmentId__r.dmpl__BranchId__c = : branchId 
                     AND dmpl__ItemId__c IN : itemIds 
                     AND dmpl__ExcludeInAutoOrder__c = false
                     GROUP BY dmpl__ItemId__c];
    }

    @testvisible
    private static List<AggregateResult> queryOpenSaleOrders(Id partnerAccountId, Id branchId, List<Id> itemIds)
    {
        return [SELECT dmpl__ItemId__c ItemId, 
                    SUM(dmpl__PendingInvoiceQuantity__c) TotalPendingQuantity 
                    FROM dmpl__SaleOrderLine__c 
                    WHERE dmpl__SaleOrderId__r.dmpl__PartnerAccountId__c = : partnerAccountId 
                    AND dmpl__SaleOrderId__r.dmpl__BranchId__c = : branchId 
                    AND dmpl__ItemId__c IN : itemIds 
                    AND dmpl__ExcludeInAutoOrder__c = false
                    GROUP BY dmpl__ItemId__c];
    }

    private static List<AggregateResult> queryItemStocks(Id partnerAccountId, Id branchId, List<Id> itemIds)
    {
        return ItemController.getItemStocks(itemIds, new List<Id>{partnerAccountId}, new List<Id>{branchId});
    }

    @testvisible
    private static List<AggregateResult> queryPendingPurchaseOrders(Id partnerAccountId, Id branchId, List<Id> itemIds)
    {
        return [SELECT 
            dmpl__ItemId__c ItemId, 
            SUM(dmpl__PendingQuantity__c) TotalPendingQuantity 
            FROM dmpl__PurchaseOrderLine__c 
            WHERE dmpl__PurchaseOrderId__r.dmpl__PartnerAccountId__c = : partnerAccountId 
            AND dmpl__PurchaseOrderId__r.dmpl__BranchId__c = : branchId 
            AND dmpl__ItemId__c IN : itemIds 
            AND dmpl__ExcludeInAutoOrder__c = false
            GROUP BY dmpl__ItemId__c];
    }

    @testvisible
    private static List<AggregateResult> queryPendingPurchaseRequisitions(Id partnerAccountId, Id branchId, List<Id> itemIds)
    {
        return [SELECT 
            dmpl__ItemId__c ItemId, 
            SUM(dmpl__PendingQuantity__c) TotalPendingQuantity 
            FROM dmpl__PurchaseRequisitionLine__c 
            WHERE dmpl__PurchaseRequisitionId__r.dmpl__PartnerAccountId__c = : partnerAccountId 
            AND dmpl__PurchaseRequisitionId__r.dmpl__BranchId__c = : branchId 
            AND dmpl__ItemId__c IN : itemIds 
            AND dmpl__ExcludeInAutoOrder__c = false
            GROUP BY dmpl__ItemId__c];
    }

    @testvisible
    private static AggregateResult getItemRecord(List<AggregateResult> records, Id itemId)
    {
        AggregateResult result = null;
        for(AggregateResult record : records)
        {
            if(record.get('ItemId') == itemId)
                result = record;
        }
        return result;
    }

    @testvisible
    private static Decimal getQuantity(List<AggregateResult> records, string fieldName, AggregateResult itemAttribute)
    {
        Decimal quantity = 0;
        for(AggregateResult record : records)
        {
            if(record.get('ItemId') == itemAttribute.get('ItemId') && ((itemAttribute.get('SKUId') != null && record.get('SKUId') == itemAttribute.get('SKUId')) || itemAttribute.get('SKUId') == null))
                quantity = quantity 
                            + (Double.valueOf(record.get(fieldName)) == null ? 0
                                : Double.valueOf(record.get(fieldName)));
        }
        return quantity;
    }
}