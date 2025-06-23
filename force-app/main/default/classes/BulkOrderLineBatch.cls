public with sharing class BulkOrderLineBatch implements Database.Batchable<sObject>
{
    public static final Integer BATCH_SIZE = 200;
    public Id partnerAccountId;
    private Id invokedQueueId;
    private String batchQuery;
 
    public BulkOrderLineBatch(
        string query,
        string queueId
    ){
        this.batchQuery = query;
        this.invokedQueueId = queueId;
    }

    public static JobResponseResult perfromAction(
        Id recordId,
        Id queueId
    ){
        try {
            return processJobQueueRecords(
                recordId,
                queueId);
        } catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }
    
    public static JobResponseResult processJobQueueRecords(
        Id recordId,
        Id queueId
    ){
        string query = getJobQueueRecordsQuery(
            queueId);
        Id batchId = Database.executeBatch(
            new BulkOrderLineBatch(
                query,
                queueId), 
            BATCH_SIZE);
        return new JobResponseResult(
            true, 
            null, 
            'Apex Batch Job Enqueued With Job Id ' + batchId);
    }

    private static string getJobQueueRecordsQuery(
        Id queueId
    ){
        return 'SELECT Id,'
        +'Name, '
        +'dmpl__SaleOrderId__c, '
        +'dmpl__SaleOrderLineId__c, '
        +'dmpl__Status__c '
        +'FROM dmpl__JobQueueRecord__c '
        +'WHERE dmpl__Status__c = \'Pending\' '
        +'AND dmpl__JobQueueId__c = \'' +queueId+ '\' '
        +'ORDER BY CreatedDate DESC';
    }

    public Database.QueryLocator start(
        Database.BatchableContext bc)
    {
        try {
            InterfaceQueueHelper.addStatusUpdate(
                invokedQueueId,
                'Starting Resource Availability Batch'
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
        List<dmpl__JobQueueRecord__c> bulkOrderLines
    ){
        List<dmpl__JobQueueRecord__c> processRelatedOrderLines = [SELECT Id, 
            Name, 
            dmpl__Quantity__c, 
            dmpl__SaleOrderId__c, 
            dmpl__SaleOrderLineId__c, 
            dmpl__Status__c, 
            dmpl__ItemLotId__c 
            FROM dmpl__JobQueueRecord__c 
            WHERE SaleOrderId__c IN : DocumentHelper.extractIds(bulkOrderLines, 'SaleOrderId__c') 
            AND Status__c = 'Pending' ORDER BY CreatedDate DESC];
 
        try
        {
            updateStatus(processRelatedOrderLines, 'Processing', null);
            ExceptionLogHelper.logMessage('Bulk Order Lines Records Count '+processRelatedOrderLines.size());
            Map<Id, dmpl__SaleInvoice__c> result = createSaleInvoiceFromBulkOrderLines(
                querySaleOrderLines(
                    new List<Id>(), DocumentHelper.extractIds(
                        processRelatedOrderLines,'SaleOrderLineId__c')), 
                    processRelatedOrderLines);
            List<dmpl__SaleInvoice__c> listOfsaleInvoice = result.values();
            List<dmpl__SaleInvoice__c> saleInvoiceToUpdate = new List<dmpl__SaleInvoice__c>();
            List<Id> branchIds = DocumentHelper.extractIds(listOfsaleInvoice,'dmpl__BranchId__c');
            Map<Id, dmpl__branch__c> mapOfBranch = new Map<Id, dmpl__branch__c>([SELECT Id, Name
                                                                                FROM dmpl__Branch__c
                                                                                WHERE Id IN :branchIds]);
            updateStatus(processRelatedOrderLines, 'Successful', null);
        }
        catch(Exception error)
        {
            updateStatus(processRelatedOrderLines, 'Failed', error.getMessage());
            ExceptionLogHelper.logException(error);
        }
    }
 
    private void updateStatus(
        List<dmpl__JobQueueRecord__c> bulkOrderLines, 
        String status, 
        String message
    ){
        for(dmpl__JobQueueRecord__c line : bulkOrderLines)
        {
                line.dmpl__Status__c = status;
                line.dmpl__Message__c = message;
        }
        update bulkOrderLines;
    }
 
    public void finish(
        Database.BatchableContext bc){
        try {
            InterfaceQueueHelper.addStatusUpdate(
                invokedQueueId,
                'Finished IG Batch');
        } catch (Exception error) {
            ExceptionLogHelper.logException(error, invokedQueueId);
            throw error;
        }
    }

    public static Map<Id, dmpl__SaleInvoice__c> createSaleInvoiceFromBulkOrderLines(
        List<dmpl__SaleOrderLine__c> selectedSaleOrderLines,
        List<dmpl__JobQueueRecord__c> bulkOrderLines
    ){
        List<dmpl__SaleOrderLine__c> pendingOrderLines = selectedSaleOrderLines;
        if(pendingOrderLines.size() == 0){
            throw new AuraHandledException('There is no pending lines.');
        }
 
        Map<String, dmpl__SaleInvoice__c> newSaleInvoices = new Map<String, dmpl__SaleInvoice__c>();
        Map<dmpl__SaleInvoiceLine__c, String> newSaleInvoiceLines = new Map<dmpl__SaleInvoiceLine__c, String>();
        for(dmpl__SaleOrderLine__c saleOrderLine : pendingOrderLines)
        {
            Boolean isFound = false;
            dmpl__SaleInvoice__c currentSaleInvoice = null;
            for(dmpl__SaleInvoice__c saleInvoice : newSaleInvoices.values())
            {
 
                if(saleInvoice.dmpl__PartnerAccountId__c == saleOrderLine.dmpl__SaleOrderId__r.dmpl__PartnerAccountId__c
                && saleInvoice.dmpl__BranchId__c == saleOrderLine.dmpl__SaleOrderId__r.dmpl__BranchId__c
                && saleInvoice.dmpl__AccountId__c == saleOrderLine.dmpl__SaleOrderId__r.dmpl__AccountId__c
                && saleInvoice.dmpl__InvoiceGroup__c == saleOrderLine.dmpl__InvoiceGroup__c)
                {
                    currentSaleInvoice = saleInvoice;
                    isFound = true;
                }
            }
 
            if(!isFound)
            {
                currentSaleInvoice = createSaleInvoiceDocument(saleOrderLine.dmpl__InvoiceGroup__c, saleOrderLine);
                newSaleInvoices.put(getNewSaleInvoiceKey(currentSaleInvoice), currentSaleInvoice);
            }
            dmpl__JobQueueRecord__c selectedBulkOrderLine = (dmpl__JobQueueRecord__c)DocumentHelper.getObjectByFilter(bulkOrderLines, 'SaleOrderLineId__c', saleOrderLine.Id);
            dmpl__SaleInvoiceLine__c newSaleInvoiceLine = createSaleInvoiceLine(saleOrderLine, selectedBulkOrderLine.Quantity__c);
            
            if(selectedBulkOrderLine.ItemLotId__c != null && newSaleInvoiceLine.dmpl__ItemLotId__c == null)
                newSaleInvoiceLine.dmpl__ItemLotId__c = selectedBulkOrderLine.ItemLotId__c;
                
            newSaleInvoiceLines.put(newSaleInvoiceLine, getNewSaleInvoiceKey(currentSaleInvoice));
        }
 
        if(newSaleInvoices.size() >0){
            Savepoint sp = Database.setSavepoint();
            try {
                    insert newSaleInvoices.values();
                    List<dmpl__SaleInvoiceLine__c> saleInvoiceLinesList = new List<dmpl__SaleInvoiceLine__c>();
                    for(dmpl__SaleInvoiceLine__c saleInvoiceLine : newSaleInvoiceLines.keySet()){
                        dmpl__SaleInvoice__c currentSaleInvoice = newSaleInvoices.get(newSaleInvoiceLines.get(saleInvoiceLine));
                        if(currentSaleInvoice != null)
                        {
                            saleInvoiceLine.dmpl__SaleInvoiceId__c = currentSaleInvoice.Id;
                            saleInvoiceLinesList.add(saleInvoiceLine);
                        }
                    }
 
                    if(saleInvoiceLinesList.size() > 0)
                    {
                        List<dmpl__SaleInvoiceLine__c> invoiceLineToInsert = setItemLot(saleInvoiceLinesList, new Map<Id, dmpl__SaleOrderLine__c>(pendingOrderLines));
                        insert invoiceLineToInsert;
                    }
                    for(dmpl__JobQueueRecord__c orderLine : bulkOrderLines)
                        orderLine.dmpl__Status__c = 'Successful';
            } catch (Exception e) {
                Database.rollback(sp);
                for(dmpl__JobQueueRecord__c orderLine : bulkOrderLines)
                {
                    orderLine.dmpl__Status__c = 'Failed';
                    orderLine.dmpl__Message__c = e.getMessage();
                }
                throw e;
            }
            finally{
                update bulkOrderLines;
            }
        }
        return new Map<Id, dmpl__SaleInvoice__c>(newSaleInvoices.values());
    }

    private static dmpl__SaleInvoice__c createSaleInvoiceDocument(String invoiceGroup, dmpl__SaleOrderLine__c saleOrderLine)
    {
        return new dmpl__SaleInvoice__c(
            dmpl__BranchId__c = saleOrderLine.dmpl__SaleOrderId__r.dmpl__BranchId__c,
            dmpl__PartnerAccountId__c = saleOrderLine.dmpl__SaleOrderId__r.dmpl__PartnerAccountId__c,
            dmpl__DocumentDate__c = System.today(),
            dmpl__AccountId__c = saleOrderLine.dmpl__SaleOrderId__r.dmpl__AccountId__c,
            dmpl__InvoiceGroup__c = (invoiceGroup == dmpl__SaleInvoice__c.class.getName()? null:invoiceGroup),
            dmpl__SaleOrderId__c = saleOrderLine.dmpl__SaleOrderId__c,
            dmpl__PriceListId__c = saleOrderLine.dmpl__SaleOrderId__r.dmpl__PriceListId__c,
            dmpl__DiscountGroupId__c = saleOrderLine.dmpl__SaleOrderId__r.dmpl__DiscountGroupId__c,
            dmpl__SalesExecutiveId__c = saleOrderLine.dmpl__SaleOrderId__r.dmpl__SalesExecutiveId__c,
            dmpl__Discount__c = saleOrderLine.dmpl__SaleOrderId__r.dmpl__Discount__c
        );
    }

    @testVisible
    private static string getNewSaleInvoiceKey(dmpl__SaleInvoice__c saleInvoice)
    {
        return saleInvoice.dmpl__PartnerAccountId__c+'-'+saleInvoice.dmpl__BranchId__c+'-'+saleInvoice.dmpl__AccountId__c+'-'+saleInvoice.dmpl__InvoiceGroup__c;
    }
 
    @testVisible
    private static dmpl__SaleInvoiceLine__c createSaleInvoiceLine(
        dmpl__SaleOrderLine__c orderLine,
        Decimal requestedQty){
        return new dmpl__SaleInvoiceLine__c(
            dmpl__SaleOrderLineId__c = orderLine.ID,
            dmpl__ItemId__c = orderLine.dmpl__ItemId__c,
            dmpl__SKUId__c = orderLine.dmpl__SKUId__c,
            dmpl__UnitPrice__c = orderLine.dmpl__UnitPrice__c,
            dmpl__UnitPrice2__c = orderLine.dmpl__UnitPrice2__c,
            dmpl__Quantity__c = requestedQty > 0 ? requestedQty : orderLine.dmpl__PendingFulfilmentOrderQuantity__c,
            dmpl__TaxGroupId__c = orderLine.dmpl__TaxGroupId__c,
            dmpl__IsPriceBundled__c= orderLine.dmpl__IsPriceBundled__c,
            dmpl__ItemComponentId__c = orderLine.dmpl__ItemComponentId__c,
            dmpl__PackageSaleOrderLineId__c = orderLine.dmpl__PackageSaleOrderLineId__c,
            dmpl__Discount__c = orderLine.dmpl__Discount__c,
            dmpl__Discount2__c = orderLine.dmpl__Discount2__c,
            dmpl__DiscountGroupRuleId__c = orderLine.dmpl__DiscountGroupRuleId__c,
            dmpl__DiscountAmount__c = orderLine.dmpl__DiscountAmount__c,
            dmpl__DiscountAmount2__c = orderLine.dmpl__DiscountAmount2__c,
           //dmpl__SchemeDiscount__c = orderLine.dmpl__SchemeDiscount__c,
           //dmpl__SchemeDiscountAmount__c = orderLine.dmpl__SchemeDiscountAmount__c,
            dmpl__BillingType__c = orderLine.dmpl__BillingType__c,
            dmpl__BillingFrequency__c = orderLine.dmpl__BillingFrequency__c,
            dmpl__ChargeType__c = orderLine.dmpl__ChargeType__c,
            dmpl__ItemLotTypeId__c = orderLine.dmpl__ItemLotTypeId__c
        );
    }

    private static List<dmpl__SaleInvoiceLine__c> setItemLot(List<dmpl__SaleInvoiceLine__c> newEntries, Map<Id, dmpl__SaleOrderLine__c> saleOrderLines)
    {
        List<Id> saleInvoiceIds = DocumentHelper.extractIds(newEntries, 'dmpl__SaleInvoiceId__c');
        Map<Id,dmpl__SaleInvoice__c> saleInvoices = new  Map<Id,dmpl__SaleInvoice__c> ([SELECT Id, 
            dmpl__BranchId__c,
            dmpl__PartnerAccountId__c
            FROM dmpl__SaleInvoice__c 
            WHERE Id IN: saleInvoiceIds]);
        List<Id> itemIds = DocumentHelper.extractIds(newEntries, 'dmpl__ItemId__c');
        List<Id> branchIds = DocumentHelper.extractIds(saleInvoices.values(), 'dmpl__BranchId__c');
        List<Id> partnerAccountIds = DocumentHelper.extractIds(saleInvoices.values(), 'dmpl__PartnerAccountId__c');
        Map<Id, dmpl__Item__c> items = new Map<Id,dmpl__Item__c>(queryItems(itemIds));
        List<Id> skuIds = DocumentHelper.extractIds(newEntries, 'dmpl__SKUId__c');
        List<Id> itemLotTypeIds = DocumentHelper.extractIds(newEntries, 'dmpl__ItemLotTypeId__c');
        List<dmpl__ItemLot__c> itemLots = queryItemLots(itemIds, branchIds, partnerAccountIds, skuIds, itemLotTypeIds);
        // List<dmpl__InventoryStock__c> itemsStock = queryInventoryStocks(itemIds, branchIds, partnerAccountIds, skuIds);
        Map<Id, Decimal> availableQuantityInLots = getLotAvailableQuantities(itemLots);
        List<dmpl__SaleInvoiceLine__c> saleInvoiceLines =  new List<dmpl__SaleInvoiceLine__c>();
 
        List<String> itemNames = new List<String>();
        for(dmpl__SaleInvoiceLine__c orderLine : newEntries){
            if(items.get(orderLine.dmpl__ItemId__c).dmpl__TrackLots__c){
                Decimal requestedQty = orderLine.dmpl__Quantity__c;
                Decimal pendingQuantity = orderLine.dmpl__Quantity__c;
                Integer counter = 0;
                while(pendingQuantity > 0){
                    counter += 1;
                    dmpl__SaleInvoice__c inv = saleInvoices.get(orderLine.dmpl__SaleInvoiceId__c);
                    
                    dmpl__SaleOrderLine__c saleOrderLine = saleOrderLines.get(orderline.dmpl__SaleOrderLineId__c);
                    dmpl__ItemLot__c eligibleItemLot = getFilteredItemLot(
                        itemLots, 
                        orderLine.dmpl__ItemId__c, 
                        inv.dmpl__BranchId__c, 
                        inv.dmpl__PartnerAccountId__c, 
                        orderLine.dmpl__SKUId__c,
                        saleOrderLine.dmpl__ItemLotTypeId__c, 
                        availableQuantityInLots, 
                        Integer.valueOf(orderLine.LimitExpiryDays__c),
                        orderLine.dmpl__Quantity__c);
                    if(eligibleItemLot != null){
                        if(counter == 1)
                        {
                            orderLine.dmpl__ItemLotId__c = eligibleItemLot.Id;
                            orderLine.dmpl__ItemLotTypeId__c = eligibleItemLot.dmpl__ItemLotTypeId__c;
                            orderLine.dmpl__StorageLocationId__c = eligibleItemLot.dmpl__StorageLocationId__c;
                            Decimal currentAvailable = availableQuantityInLots.get(orderLine.dmpl__ItemLotId__c);
                              if(currentAvailable <= orderLine.dmpl__Quantity__c)
                              {
                                orderLine.dmpl__Quantity__c = currentAvailable;
                                currentAvailable =0;
                              }
                              else {
                                currentAvailable -= orderLine.dmpl__Quantity__c;
                              }
                            availableQuantityInLots.put(orderLine.dmpl__ItemLotId__c, currentAvailable);
                            pendingQuantity -= orderLine.dmpl__Quantity__c;
                            System.debug(orderLine.dmpl__IsILPostingApproved__c+'1005');
                            saleInvoiceLines.add(orderLine);
                        }
                        else if(counter > 1)
                        {
                            dmpl__SaleInvoiceLine__c saleInvoiceLine = createNewSaleInvoiceLine(orderLine, saleOrderLine);
                            saleInvoiceLine.dmpl__Quantity__c = pendingQuantity;
                            saleInvoiceLine.dmpl__ItemLotId__c = eligibleItemLot.Id;
                            //saleInvoiceLine.dmpl__IsILPostingApproved__c = true;
                            saleInvoiceLine.dmpl__ItemLotTypeId__c = eligibleItemLot.dmpl__ItemLotTypeId__c;
                            saleInvoiceLine.dmpl__StorageLocationId__c = eligibleItemLot.dmpl__StorageLocationId__c;
                            Decimal currentAvailable = availableQuantityInLots.get(saleInvoiceLine.dmpl__ItemLotId__c);
                             if(currentAvailable <= saleInvoiceLine.dmpl__Quantity__c)
                             {
                                saleInvoiceLine.dmpl__Quantity__c = currentAvailable;
                                currentAvailable =0;
                             }
                             else {
                                    currentAvailable -= saleInvoiceLine.dmpl__Quantity__c;
                             }
                            saleInvoiceLines.add(saleInvoiceLine);
                            availableQuantityInLots.put(saleInvoiceLine.dmpl__ItemLotId__c, currentAvailable);
                            pendingQuantity -= saleInvoiceLine.dmpl__Quantity__c;
                        }
                    }
                    else {
                        pendingQuantity = 0;
                        dmpl__Item__c item = items.get(orderLine.dmpl__ItemId__c);
                        itemNames.add(item.Name);
                    }
                }
            }
            if(itemNames.size() > 0)
            {
                
                for(dmpl__SaleInvoiceLine__c invoiceLine : newEntries)
                    orderLine.addError('You can not create invoice for ' + string.join(itemNames,',') +  ' Item as stock is not available.');
            }
        }
        return saleInvoiceLines;
    }

    @testVisible
    private static dmpl__ItemLot__c getFilteredItemLot(
        List<dmpl__ItemLot__c> itemLots, 
        Id itemId, 
        Id branchId, 
        Id partnerAccountId, 
        Id skuId, 
        Id itemLotTypeId, 
        Map<Id, Decimal> currentQuantityInItemLot, 
        Integer limitExpiryDays, 
        Decimal quantity
    ){
        for(dmpl__ItemLot__c itemLot : itemLots)
            if(itemLot.dmpl__ItemId__c == itemId
            && itemLot.dmpl__BranchId__c == branchId
            && itemLot.dmpl__PartnerAccountId__c == partnerAccountId
            && itemLot.dmpl__SKUId__c == skuId
            // && ((itemLotTypeId != null && temLot.dmpl__ItemLotTypeId__c == itemLotTypeId) || (itemLotTypeId == null))
            // && (itemLot.dmpl__QuantityAvailable__c - (itemLot.ReservedQuantity__c == null ? 0 : itemLot.ReservedQuantity__c)) > 0
            && (itemLot.dmpl__QuantityAvailable__c) > 0
            // && itemLot.dmpl__QuantityAvailable__c >= quantity
            && currentQuantityInItemLot.get(itemLot.Id) != null
            && currentQuantityInItemLot.get(itemLot.Id) > 0
            && ((limitExpiryDays != null && limitExpiryDays > 0 && itemLot.dmpl__DateOfExpiry__c != null && itemLot.dmpl__DateOfExpiry__c <= Datetime.now().date().addDays(Integer.valueOf(limitExpiryDays)))
            || ((limitExpiryDays == null || limitExpiryDays <= 0)))
            && (
                (itemLotTypeId == null && (!itemLot.dmpl__ItemLotTypeId__r.dmpl__IsSample__c || itemLot.dmpl__ItemLotTypeId__c == null))
                            || (itemLotTypeId != null && itemLot.dmpl__ItemLotTypeId__r.dmpl__IsSaleable__c  && itemLot.dmpl__ItemLotTypeId__c == itemLotTypeId)
                            && (itemLotTypeId == null || itemLot.dmpl__ItemLotTypeId__c == itemLotTypeId))
 
            )
            {
                return itemLot;
            }
        return null;
    }

    private static Map<Id, Decimal> getLotAvailableQuantities(List<dmpl__ItemLot__c> itemLots)
    {
        Map<Id, Decimal> result = new Map<Id, Decimal>();
        for(dmpl__ItemLot__c lot : itemLots)
        {
            // result.put(lot.Id, lot.dmpl__QuantityAvailable__c == null ? 0 : (Decimal)lot.dmpl__QuantityAvailable__c - (lot.ReservedQuantity__c == null ? 0 : (Decimal)lot.ReservedQuantity__c));
            result.put(lot.Id, lot.dmpl__QuantityAvailable__c == null ? 0 : (Decimal)lot.dmpl__QuantityAvailable__c);
        }
        return result;
    }

    public static List<dmpl__SaleOrderLine__c> querySaleOrderLines(List<Id> saleOrderIds, List<Id> saleOrderLineIds)
    {
        if(saleOrderLineIds == null){
            saleOrderLineIds = new List<Id>();
        }
 
        if(saleOrderIds == null){
            saleOrderIds = new List<Id>();
        }
 
        return [SELECT Id,
            Name,
            dmpl__ItemId__c,
            dmpl__SKUId__c,
            dmpl__UnitPrice__c,
            dmpl__UnitPrice2__c,
            dmpl__Quantity__c,
            dmpl__PendingInvoiceQuantity__c,
            dmpl__FulfilmentAllocatedQuantity__c,
            dmpl__InvoiceGroup__c,
            dmpl__IsPriceBundled__c,
            dmpl__PackageSaleOrderLineId__c,
            dmpl__TaxGroupId__c,
            dmpl__ItemComponentId__c,
            dmpl__SaleOrderId__c,
            dmpl__SaleOrderId__r.dmpl__PartnerAccountId__c,
            dmpl__SaleOrderId__r.dmpl__BranchId__c,
            dmpl__SaleOrderId__r.dmpl__AccountId__c,
            dmpl__SaleOrderId__r.dmpl__DocumentDate__c,
            dmpl__SaleOrderId__r.dmpl__DiscountGroupId__c,
            dmpl__SaleOrderId__r.dmpl__PriceListId__c,
            dmpl__SaleOrderId__r.dmpl__SalesExecutiveId__c,
            dmpl__SaleOrderId__r.dmpl__Discount__c,
            dmpl__ItemId__r.dmpl__TrackInventory__c,
            dmpl__Discount__c,
            dmpl__Discount2__c,
            dmpl__DiscountGroupRuleId__c,
            dmpl__DiscountAmount__c,
            dmpl__DiscountAmount2__c,
            dmpl__SchemeDiscount__c,
            dmpl__SchemeDiscountAmount__c,
            dmpl__BillingType__c,
            dmpl__BillingFrequency__c,
            dmpl__ChargeType__c,
            dmpl__PendingAllocatedInvoicedQuantity__c,
            dmpl__PendingFulfilmentOrderQuantity__c,
            dmpl__ItemLotTypeId__c
        FROM dmpl__SaleOrderLine__c
        WHERE dmpl__SaleOrderId__c IN :saleOrderIds OR Id IN :saleOrderLineIds
        ];
    }

    private static List<dmpl__Item__c> queryItems(List<Id> itemIds)
    {
        return [SELECT Id,
            Name,
            dmpl__AllowService__c,
            dmpl__ClaimToAccountId__c,
            dmpl__ContractPostingTreatment__c,
            dmpl__DiscountItemGroupId__c,
            dmpl__InventoryValuationMethod__c,
            dmpl__InvoiceGroup__c,
            dmpl__IsActive__c,
            dmpl__IsRegistrationRequired__c,
            dmpl__ItemCode__c,
            dmpl__Description__c,
            dmpl__ItemSubType__c,
            dmpl__ItemType__c,
            dmpl__ProductMaintenanceScheduleId__c,
            dmpl__SchemeItemGroupId__c,
            dmpl__TaxItemGroupId__c,
            dmpl__TrackAsset__c,
            dmpl__TrackInventory__c,
            dmpl__TrackLots__c
           
        FROM dmpl__Item__c
        WHERE Id IN:itemIds];
    }

    private static List<dmpl__ItemLot__c> queryItemLots(List<Id> itemIds, List<Id> branchIds, List<Id> partnerAccountIds, List<Id> skuIds, List<Id> itemLotTypeIds)
    {
        String query = 'SELECT Id, Name,dmpl__BatchNo__c,dmpl__BranchId__c,dmpl__PartnerAccountId__c,dmpl__ComponentNumber__c,dmpl__Cost__c,dmpl__ItemId__c,dmpl__SKUId__c,dmpl__ItemLotTypeId__c,dmpl__ItemLotTypeId__r.dmpl__IsSaleable__c, dmpl__ItemLotTypeId__r.dmpl__IsSample__c,dmpl__QuantityAvailable__c,dmpl__QuantityInHand__c,dmpl__StorageLocationId__c,dmpl__UnitCost__c, dmpl__DateOfExpiry__c  FROM dmpl__ItemLot__c  WHERE dmpl__ItemId__c IN : itemIds AND dmpl__BranchId__c IN : branchIds AND dmpl__PartnerAccountId__c IN : partnerAccountIds AND dmpl__HoldCode__c = null AND (dmpl__SKUId__c IN : skuIds OR dmpl__SKUId__c = null) ORDER BY dmpl__DateOfExpiry__c,Name';
        return Database.query(query);
    }

    @testVisible
    private static dmpl__SaleInvoiceLine__c createNewSaleInvoiceLine(dmpl__SaleInvoiceLine__c orderLine, dmpl__SaleOrderLine__c saleOrderLine)
    {
        return new dmpl__SaleInvoiceLine__c(
        dmpl__SaleOrderLineId__c = orderLine.dmpl__SaleOrderLineId__c,
        dmpl__ItemId__c = orderLine.dmpl__ItemId__c,
        dmpl__UnitPrice__c = orderLine.dmpl__UnitPrice__c,
        dmpl__UnitPrice2__c = orderLine.dmpl__UnitPrice2__c,  
        dmpl__Quantity__c = orderLine.dmpl__Quantity__c,
        dmpl__TaxGroupId__c = orderLine.dmpl__TaxGroupId__c,
        dmpl__IsPriceBundled__c= orderLine.dmpl__IsPriceBundled__c,
        dmpl__ItemComponentId__c = orderLine.dmpl__ItemComponentId__c,
        dmpl__PackageSaleOrderLineId__c = orderLine.dmpl__PackageSaleOrderLineId__c,
        dmpl__Discount__c = orderLine.dmpl__Discount__c,
        dmpl__Discount2__c = orderLine.dmpl__Discount2__c,
        dmpl__DiscountGroupRuleId__c = orderLine.dmpl__DiscountGroupRuleId__c,
        dmpl__DiscountAmount__c = orderLine.dmpl__DiscountAmount__c,
        dmpl__DiscountAmount2__c = orderLine.dmpl__DiscountAmount2__c,
        dmpl__BillingType__c = orderLine.dmpl__BillingType__c,
        dmpl__BillingFrequency__c = orderLine.dmpl__BillingFrequency__c,
        dmpl__ChargeType__c = orderLine.dmpl__ChargeType__c,
        dmpl__ItemLotTypeId__c = saleOrderLine.dmpl__ItemLotTypeId__c,
        dmpl__SaleInvoiceId__c = orderLine.dmpl__SaleInvoiceId__c);
    }
}