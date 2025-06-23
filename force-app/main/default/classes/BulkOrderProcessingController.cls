public with sharing class BulkOrderProcessingController 
{

    @AuraEnabled(cacheable = true)
    public static List<dmpl__Resource__c> getUserDefaults(){
        Id userId = UserInfo.getUserId();
        return [SELECT 
            Id,
            dmpl__DefaultBranchId__c,
            dmpl__DefaultPartnerAccountId__c,
            dmpl__Phone__c,
            dmpl__ResourceType__c
            FROM dmpl__Resource__c
            WHERE dmpl__UserId__c =:userId
            AND dmpl__DefaultPartnerAccountId__c != null
        ];
    }

    @AuraEnabled
    public static List<Sobject> getRelatedRecords(
        String whereClause, 
        String relatedObjectApiName, 
        List<String> queryFields
    ){
        try {
            whereClause = whereClause.replaceAll('"','');
            whereClause = whereClause != null && whereClause != '' ? ' WHERE '+ whereClause.replaceAll('"','') : '';
            String queryFieldsString = String.join(queryFields,',');
            String query = 'SELECT Id,'+queryFieldsString+' FROM '+relatedObjectApiName + whereClause + ' Limit 200';
            System.debug('query1 '+ query);
            return Database.query(query);
        } catch (Exception e) {
            ExceptionLogHelper.logException(e);
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled
    public static Map<String, List<SObject>> getLineRelatedRecords(
        String whereClause, 
        String orderByClause, 
        Boolean doNotShowPartialOrder, 
        String lineWhereClause, 
        String relatedObjectApiName, 
        List<String> queryFields, 
        List<String> selectedRecordIdsSalesPerson, 
        List<String> selectedRecordIds, 
        List<String> VisitRouteStopAccountIds
    ){
        try {
            List<dmpl__VisitRoute__c> visitRoutes = [SELECT Name FROM dmpl__VisitRoute__c WHERE Id IN :selectedRecordIds];
            String visitRouteAggregate='';
            
            for (Integer i=0;i<visitRoutes.size();i++) {
                if(i==0){
                    visitRouteAggregate+='(';
                }
                visitRouteAggregate+='\''+visitRoutes[i].Name+'\'';
                if(i==visitRoutes.size()-1){
                    visitRouteAggregate+=')';
                    break;
                }
                visitRouteAggregate+=',';
            }
            List<dmpl__JobQueueRecord__c> pendingOrderLines = [SELECT SaleOrderId__c FROM dmpl__JobQueueRecord__c WHERE dmpl__SaleOrderId__r.Status__c = 'Pending'];
            List<Id> pendingOrderIds = DocumentHelper.extractIds(pendingOrderLines, 'SaleOrderId__c');
            whereClause = whereClause.replaceAll('"','');
            whereClause = whereClause != null && whereClause != '' ? ' WHERE '+ whereClause.replaceAll('"','') : '';
            String queryFieldsString = String.join(queryFields,',');

            String salesPersonCondition = selectedRecordIdsSalesPerson != null && !selectedRecordIdsSalesPerson.isEmpty() ? 
            ' AND dmpl__SaleOrderId__r.dmpl__SalesExecutiveId__c IN: selectedRecordIdsSalesPerson ' : '';

            // String visitRouteCondition = visitRoutes.size()==0?'':' AND dmpl__SaleOrderId__r.BeatName__c IN  '+visitRouteAggregate;
           
            String query = 'SELECT Id, dmpl__LimitExpiryDays__c, ' + queryFieldsString + ' FROM ' + relatedObjectApiName + whereClause 
            + ' AND dmpl__SaleOrderId__r.dmpl__Status__c = \'Draft\' '//AND dmpl__SaleOrderId__r.IDTNumber__c = null
            + salesPersonCondition 
            // + visitRouteCond.ition 
            + ' AND dmpl__SaleOrderId__r.Id Not IN  (\'' + String.join(pendingOrderIds, '\',\'') + '\') ' + orderByClause + ' Limit 2000';// AND dmpl__SaleOrderId__r.IsProvision__c = false 
            
            if(doNotShowPartialOrder)
            {
                query = 'SELECT Id,dmpl__LimitExpiryDays__c,'+queryFieldsString+' FROM '+relatedObjectApiName + whereClause 
            + ' AND dmpl__SaleOrderId__r.dmpl__Status__c = '+ '\'Draft\'' +visitRouteAggregate+ salesPersonCondition +' AND dmpl__SaleOrderId__r.Id Not IN (\'' + String.Join(pendingOrderIds,'\',\'') + '\') ' + orderByClause + ' Limit 2000';// AND dmpl__SaleOrderId__r.IsProvision__c = false AND dmpl__SaleOrderId__r.IDTNumber__c = null AND dmpl__SaleOrderId__r.IsPartialOrder__c = false 

            }

            List<SObject> saleOrderLines =  Database.query(query);
            List<Id> saleOrderIds = DocumentHelper.extractIds(saleOrderLines, 'dmpl__SaleOrderId__c');

            List<dmpl__SaleOrder__c> orders = [Select Id from dmpl__SaleOrder__c Where Id  IN: saleOrderIds AND dmpl__Status__c = 'Draft' AND Id Not IN: pendingOrderIds order by CreatedDate desc];
            saleOrderIds = DocumentHelper.extractIds(orders);

            lineWhereClause = lineWhereClause.replaceAll('"','');
            lineWhereClause = lineWhereClause != null && lineWhereClause != '' ? ' WHERE '+ lineWhereClause.replaceAll('"','') : '';
            String query1 = 'SELECT Id,dmpl__ItemLotTypeId__c,dmpl__LimitExpiryDays__c,dmpl__SaleOrderId__r.dmpl__PartnerAccountId__c,dmpl__SaleOrderId__r.dmpl__BranchId__c,'+queryFieldsString+' FROM '+relatedObjectApiName + lineWhereClause + ' AND dmpl__ItemId__r.dmpl__IsActive__c = true'  + ' AND dmpl__SaleOrderId__c IN (\'' + String.Join(saleOrderIds,'\',\'') + '\') AND Id NOT IN (SELECT SaleOrderLineId__c FROM dmpl__JobQueueRecord__c WHERE Status__c = \'Pending\' OR Status__c = \'Processing\')';
            
            List<dmpl__SaleOrderLine__c> queriedSaleOrderLines = (List<dmpl__SaleOrderLine__c>)Database.query(query1);
        
            List<Id> itemIds = DocumentHelper.extractIds(queriedSaleOrderLines, 'dmpl__ItemId__c');
            List<Id> branchIds = DocumentHelper.extractIdsFromLookup(queriedSaleOrderLines,'dmpl__SaleOrderId__r','dmpl__BranchId__c');
            List<Id> partnerAccountIds = DocumentHelper.extractIdsFromLookup(queriedSaleOrderLines,'dmpl__SaleOrderId__r','dmpl__PartnerAccountId__c');
            Map<Id, dmpl__Item__c> items = new Map<Id,dmpl__Item__c>(queryItems(itemIds));


            List<Id> itemLotTypeIds = DocumentHelper.extractIds(queriedSaleOrderLines, 'dmpl__ItemLotTypeId__c');

            List<dmpl__ItemLot__c> itemLots = queryItemLots(itemIds, branchIds, partnerAccountIds, new List<Id>(), itemLotTypeIds);
            queriedSaleOrderLines = tagItemLots(queriedSaleOrderLines, items, itemLots);
            List<dmpl__JobQueueRecord__c> bulkSaleOrderLines = createBulkOrderLines(queriedSaleOrderLines);

            Map<String, List<SObject>> result = new Map<String, List<SObject>>();
            result.put('SaleOrderLines', queriedSaleOrderLines);
            result.put('BulkOrderLines', bulkSaleOrderLines);
            result.put('ItemLots', itemLots);
            ExceptionLogHelper.logMessage(String.valueOf(queriedSaleOrderLines));
            return result;

        } catch (Exception e) {
            ExceptionLogHelper.logException(e);
            throw new AuraHandledException(e.getMessage());
        }
    }
   
     private static List<dmpl__SaleOrderLine__c> tagItemLots(
        List<dmpl__SaleOrderLine__c> newEntries,
        Map<Id, dmpl__Item__c> items, 
        List<dmpl__ItemLot__c> itemLots)
    {

        Map<Id, Decimal> availableQuantityInLots = getLotAvailableQuantities(itemLots);

        for(dmpl__SaleOrderLine__c orderLine : newEntries){
            if(items.get(orderLine.dmpl__ItemId__c).dmpl__TrackLots__c){
                Decimal pendingQuantity = orderLine.dmpl__PendingInvoiceQuantity__c;
                while(pendingQuantity > 0){
                    dmpl__ItemLot__c eligibleItemLot = getFilteredItemLot(
                        itemLots, 
                        orderLine.dmpl__ItemId__c, 
                        orderLine.dmpl__SaleOrderId__r.dmpl__BranchId__c, 
                        orderLine.dmpl__SaleOrderId__r.dmpl__PartnerAccountId__c, 
                        // orderLine.dmpl__SKUId__c,
                        orderLine.dmpl__ItemLotTypeId__c, 
                        availableQuantityInLots, 
                        Integer.valueOf(orderLine.dmpl__LimitExpiryDays__c),
                        orderLine.dmpl__ItemLotId__c,
                        pendingQuantity);
                    if(eligibleItemLot != null){
                        orderLine.dmpl__ItemLotId__c = eligibleItemLot.Id;

                        Decimal currentAvailable = availableQuantityInLots.get(orderLine.dmpl__ItemLotId__c);
                        currentAvailable -= orderLine.dmpl__PendingInvoiceQuantity__c;
                        availableQuantityInLots.put(orderLine.dmpl__ItemLotId__c, currentAvailable);
                        //
                        pendingQuantity -= orderLine.dmpl__Quantity__c;
                    } else {
                        pendingQuantity = 0;
                    }
                }
            } 
        }

        return newEntries;
    }

    private static Map<Id, Decimal> getLotAvailableQuantities(List<dmpl__ItemLot__c> itemLots)
    {
        Map<Id, Decimal> result = new Map<Id, Decimal>();
        for(dmpl__ItemLot__c lot : itemLots)
        {
            result.put(lot.Id, lot.dmpl__QuantityAvailable__c == null ? 0 : (Decimal)lot.dmpl__QuantityAvailable__c);
        }
        return result;
    }

    public static List<dmpl__ItemLot__c> queryItemLots(List<Id> itemIds, List<Id> branchIds, List<Id> partnerAccountIds, List<Id> skuIds, List<Id> itemLotTypeIds)
    {
        String query = 'SELECT Id, Name,dmpl__ItemLotTypeId__r.dmpl__IsSample__c,dmpl__ItemLotTypeId__r.dmpl__IsSaleable__c,dmpl__BatchNo__c,dmpl__BranchId__c,dmpl__PartnerAccountId__c,dmpl__ComponentNumber__c,dmpl__Cost__c,dmpl__ItemId__c,dmpl__SKUId__c,dmpl__ItemLotTypeId__c,dmpl__QuantityAvailable__c,dmpl__QuantityInHand__c,dmpl__StorageLocationId__c,dmpl__UnitCost__c,dmpl__DateOfExpiry__c FROM dmpl__ItemLot__c WHERE dmpl__ItemId__c IN : itemIds AND dmpl__BranchId__c IN : branchIds        AND dmpl__PartnerAccountId__c IN : partnerAccountIds        AND dmpl__HoldCode__c = null        AND (dmpl__SKUId__c IN : skuIds OR dmpl__SKUId__c = null)';//AND (dmpl__ItemLotTypeId__c IN : itemLotTypeIds OR dmpl__ItemLotTypeId__c = null)
        return Database.query(query + getItemLotOrderByClause());
    }

    private static String getItemLotOrderByClause()
    {
        String orderByClause = ' ORDER BY CreatedDate';
        dmpl__DMSOrgSetting__mdt orgSetting = [SELECT 
        dmpl__CopyTaxesInSalesReturn__c,
        dmpl__CopyTaxesInPurchaseReturn__c,
        dmpl__SaleReturnTaxesValidity__c,
        dmpl__PurchaseReturnTaxesValidity__c,
        dmpl__ItemLotOrderByFields__c,
        dmpl__EnableAEPostingInSaleInvoice__c,
        dmpl__EnableAEPostingInPurchaseInvoice__c,
        dmpl__ConvertLeadStatus__c,
        dmpl__SchemeAdjustmentItemId__c,
        dmpl__DisableTriggers__c,
        dmpl__AuthoriseUser__c,
        dmpl__AuthoriseResource__c,
        dmpl__EnableRoundOff__c,
        dmpl__RoundOffDigits__c,
        dmpl__RoundOffType__c,
        dmpl__EnableMOQQuantityValidation__c
    FROM dmpl__DMSOrgSetting__mdt
    LIMIT 1];
        if(orgSetting != null && !String.isBlank(orgSetting.dmpl__ItemLotOrderByFields__c))
            orderByClause = ' ORDER BY '+orgSetting.dmpl__ItemLotOrderByFields__c;

        return orderByClause;
    }

    @testVisible
    private static dmpl__ItemLot__c getFilteredItemLot(
        List<dmpl__ItemLot__c> itemLots, 
        Id itemId, 
        Id branchId, 
        Id partnerAccountId, 
        // Id skuId, 
        Id itemLotTypeId, 
        Map<Id, Decimal> currentQuantityInItemLot, 
        Integer limitExpiryDays,
        Id preferedLotId,
        Decimal pendingQuantity){
            if(preferedLotId!=null){
                dmpl__ItemLot__c itemLot = (dmpl__ItemLot__c)CollectionHelper.getObject(itemLots, preferedLotId);
                if(itemLot !=null
               // && (itemLot.dmpl__QuantityAvailable__c - (itemLot.ReservedQuantity__c == null ? 0 : itemLot.ReservedQuantity__c)) >= pendingQuantity
                    && itemLot.dmpl__ItemId__c == itemId 
                    && itemLot.dmpl__BranchId__c == branchId 
                    && itemLot.dmpl__PartnerAccountId__c == partnerAccountId 
                    && (
                        (itemLotTypeId == null && (!itemLot.dmpl__ItemLotTypeId__r.dmpl__IsSample__c || itemLot.dmpl__ItemLotTypeId__c == null))
                                    || (itemLotTypeId != null && itemLot.dmpl__ItemLotTypeId__r.dmpl__IsSaleable__c  && itemLot.dmpl__ItemLotTypeId__c == itemLotTypeId))
                    && itemLot.dmpl__QuantityAvailable__c > 0 
                    && currentQuantityInItemLot.get(itemLot.Id) != null 
                    && currentQuantityInItemLot.get(itemLot.Id) > 0
                    && ((limitExpiryDays != null && limitExpiryDays > 0 && itemLot.dmpl__DateOfExpiry__c != null && itemLot.dmpl__DateOfExpiry__c <= Datetime.now().date().addDays(Integer.valueOf(limitExpiryDays)))
                        || ((limitExpiryDays == null || limitExpiryDays <= 0)))){
                        return itemLot;
                    }
            }

            for(dmpl__ItemLot__c itemLot : itemLots){
                if(itemLot.dmpl__ItemId__c == itemId 
                   // && (itemLot.dmpl__QuantityAvailable__c - (itemLot.ReservedQuantity__c == null ? 0 : itemLot.ReservedQuantity__c)) >= pendingQuantity
                    && itemLot.dmpl__BranchId__c == branchId 
                    && itemLot.dmpl__PartnerAccountId__c == partnerAccountId 
                    && (
                        (itemLotTypeId == null && (!itemLot.dmpl__ItemLotTypeId__r.dmpl__IsSample__c || itemLot.dmpl__ItemLotTypeId__c == null))
                                    || (itemLotTypeId != null && itemLot.dmpl__ItemLotTypeId__r.dmpl__IsSaleable__c  && itemLot.dmpl__ItemLotTypeId__c == itemLotTypeId))
                    && itemLot.dmpl__QuantityAvailable__c > 0 
                    && currentQuantityInItemLot.get(itemLot.Id) != null 
                    && currentQuantityInItemLot.get(itemLot.Id) > 0
                    && ((limitExpiryDays != null && limitExpiryDays > 0 && itemLot.dmpl__DateOfExpiry__c != null && itemLot.dmpl__DateOfExpiry__c <= Datetime.now().date().addDays(Integer.valueOf(limitExpiryDays)))
                        || ((limitExpiryDays == null || limitExpiryDays <= 0)))){
                    return itemLot;
                }
            }
        return null;
    }
   @testvisible
    private static List<dmpl__JobQueueRecord__c> createBulkOrderLines(List<dmpl__SaleOrderLine__c> saleOrderLines)
    {
        dmpl__InterfaceQueue__c newQueue = new dmpl__InterfaceQueue__c();
        newQueue.dmpl__JobType__c = 'Bulk Order Processor';
        newQueue.dmpl__QueueType__c = 'Manual';
        insert newQueue;
        List<dmpl__JobQueueRecord__c> newBulkOrderLines = new List<dmpl__JobQueueRecord__c>();
        for(dmpl__SaleOrderLine__c saleOrderLine : saleOrderLines)
            newBulkOrderLines.add(new dmpl__JobQueueRecord__c(
                SaleOrderId__c = saleOrderLine.dmpl__SaleOrderId__c, 
                SaleOrderLineId__c = saleOrderLine.Id, 
                Quantity__c = saleOrderLine.dmpl__PendingInvoiceQuantity__c, 
                ItemLotId__c = saleOrderLine.dmpl__ItemLotId__c,
                Status__c = 'Unsaved',
                dmpl__JobQueueId__c = newQueue.Id, 
                Message__c = null));

        if(newBulkOrderLines.size() > 0)
            insert newBulkOrderLines;

        return newBulkOrderLines;
    }

    @AuraEnabled
    public static Integer getRelatedRecordsCount(string whereClause, String relatedObjectApiName, List<String> queryFields){
        try {
            whereClause = whereClause.replaceAll('"','');
            whereClause = whereClause != null && whereClause != '' ? ' WHERE '+ whereClause.replaceAll('"','') : '';
            String queryFieldsString = String.join(queryFields,',');
            String query = 'SELECT Count() FROM '+relatedObjectApiName + whereClause + ' Limit 160' ;
            return Database.countQuery(query);
        } catch (Exception e) {
            ExceptionLogHelper.logException(e);
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Boolean bulkOrderLine(String jsonString)
    {
        Boolean isSuccessful = false;
        try 
        {
            Type sObjectType = Type.forName('dmpl__JobQueueRecord__c');
            List<Object> parsedData = (List<Object>)JSON.deserializeUntyped(
                    jsonString);
            List<SObject> recordsToUpdate = new List<SObject>();
            for(Object entry: parsedData){   
                SObject newObject = (SObject)sObjectType.newInstance();
                Map<String, Object> mapEntry = (Map<String, Object>)entry;
                for(String key : mapEntry.keySet())
                {
                    newObject.put(key, key =='Quantity__c' ? Decimal.valueOf((String)mapEntry.get(key)) : mapEntry.get(key));
                }
                recordsToUpdate.add(newObject);
            }
            update recordsToUpdate;
            isSuccessful = true;
        } 
        catch (Exception e) 
        {
            throw new AuraHandledException(e.getMessage());
        }
        return isSuccessful;
    }

    @AuraEnabled
    public static Boolean processBulkOrderLines(Id jobQueueId)
    {
        JobTypeHelper.executeQueue(
            jobQueueId);
        return true;
    }
    @AuraEnabled(cacheable=true)
    public static List<dmpl__VisitRoute__c> fetchVisitRoute(String searchKey, String currentPartnerAccount, String currentBranch,List<Id> selectedRecordIdsSalesPerson) {
        try {
            System.debug(searchKey+' '+currentPartnerAccount+' '+currentBranch+' '+selectedRecordIdsSalesPerson);
            List<dmpl__VisitRoute__c> visitRouteStops = new List<dmpl__VisitRoute__c>();
            if (String.isBlank(searchKey)) {
                return visitRouteStops;
            } else {
                String key = '%' + searchKey + '%';
                String objectApiName = 'dmpl__VisitRoute__c';
                String query = 'SELECT Id, Name FROM ' + objectApiName +
                               ' WHERE Name LIKE :key';
                if (!String.isBlank(currentPartnerAccount)) {
                    query += ' AND dmpl__PartnerAccountId__c = :currentPartnerAccount';
                }
                if (!String.isBlank(currentBranch)) {
                    query += ' AND BranchId__c = :currentBranch';
                }
                if(!selectedRecordIdsSalesPerson.isEmpty()){
                    query += ' AND ResourceId__c IN :selectedRecordIdsSalesPerson';
                }
                query += ' ORDER BY Name LIMIT 8';
                if (!String.isBlank(currentPartnerAccount) || !String.isBlank(currentBranch)) {
                    visitRouteStops = Database.query(query);
                }     
                return visitRouteStops;
            }
        }
        catch (Exception e) {
            ExceptionLogHelper.logException(e);
            throw new AuraHandledException(e.getMessage());
        } 
    }

    //to fetch SalesPerson
    @AuraEnabled(cacheable=true)
    public static List<dmpl__Resource__c> fetchSalesPerson(String searchKeySalesPerson, String currentPartnerAccount, String currentBranch) {
        try {
            System.debug(searchKeySalesPerson+' '+currentPartnerAccount+' '+currentBranch);
            List<dmpl__Resource__c> salesperson = new List<dmpl__Resource__c>();
            if (String.isBlank(searchKeySalesPerson)) {
                return salesperson;
            } else {
                String key = '%' + searchKeySalesPerson + '%';
                String objectApiName = 'dmpl__Resource__c';
                String query = 'SELECT Id, Name FROM ' + objectApiName +
                            ' WHERE Name LIKE :key';
                if (!String.isBlank(currentPartnerAccount)) {
                    query += ' AND dmpl__DefaultPartnerAccountId__c = :currentPartnerAccount';
                }
                if (!String.isBlank(currentBranch)) {
                    query += ' AND dmpl__DefaultBranchId__c = :currentBranch';
                }
                query += ' ORDER BY Name LIMIT 8';
                if (!String.isBlank(currentPartnerAccount) || !String.isBlank(currentBranch)) {
                    salesperson = Database.query(query);
                }
                return salesperson;
            }
        } catch (Exception e) {
            ExceptionLogHelper.logException(e);
            throw new AuraHandledException(e.getMessage());
        }
    }

    //query visit route stops
    @AuraEnabled
    public static List<Id> queryRouteAccountsCustom(List<Id> routeIds) {
        Map<Id, List<dmpl__VisitRouteStop__c>> routeStopMap = new Map<Id, List<dmpl__VisitRouteStop__c>>();
    
        try {
            List<dmpl__VisitRouteStop__c> visitRouteStops = [SELECT Id, 
                Name, 
                dmpl__AccountId__c, 
                dmpl__VisitRouteId__c 
                FROM dmpl__VisitRouteStop__c 
                WHERE dmpl__VisitRouteId__c IN :routeIds];
            return DocumentHelper.extractIds(visitRouteStops,'dmpl__AccountId__c');
        } catch (Exception e) {
            ExceptionLogHelper.logException(e);
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<AggregateResult> getItemStocks(List<Id> itemIds, List<Id> partnerAccountIds, List<Id> branchIds)
    {
        List<AggregateResult> result = new List<AggregateResult>();
        try
        {
            result.addAll(
            [SELECT
                SUM(dmpl__QuantityAvailable__c) QuantityAvailable,
                SUM(dmpl__QuantityInHand__c) QuantityInHand,
                dmpl__ItemId__c ItemId,
                dmpl__ItemId__r.Name ItemName,
                dmpl__SKUId__c SKUId,
                dmpl__SKUId__r.Name SKUName,
                dmpl__ItemLotTypeId__c LotTypeId,
                dmpl__ItemLotTypeId__r.Name LotTypeName,
                dmpl__BranchId__r.Name BranchName,
                dmpl__BranchId__c BranchId
            FROM
            dmpl__ItemLot__c
            WHERE
                dmpl__ItemId__c IN : itemIds
                AND dmpl__BranchId__c IN: branchIds
                AND (dmpl__ItemLotTypeId__r.dmpl__IsSaleable__c = true OR dmpl__ItemLotTypeId__c = null)
            GROUP BY
                dmpl__ItemId__c,
                dmpl__ItemId__r.Name,
                dmpl__SKUId__c,
                dmpl__SKUId__r.Name,
                dmpl__ItemLotTypeId__c,
                dmpl__ItemLotTypeId__r.Name,
                dmpl__BranchId__r.Name,
                dmpl__BranchId__c
            ]);
        }
        catch (Exception e)
        {
            ExceptionLogHelper.logException(e);
            throw new AuraHandledException(e.getMessage());
        }
        return result;
    }

    @TestVisible
    private static List<dmpl__Item__c> queryItems(List<Id> itemIds)
    {
        return 
        [
            SELECT
            Id,
            Name,
            dmpl__ItemCode__c,
            dmpl__TrackLots__c,
            dmpl__TrackInventory__c
            FROM
            dmpl__Item__c
            WHERE
            Id IN : itemIds
        ];
    }
    @AuraEnabled
    public static List<dmpl__SaleInvoice__c> createBulkInvoices(List<Id> saleOrderLineIds, List<SObject> saleOrderLineDraftValues, List<String> editableFields){
        List<dmpl__SaleInvoice__c> newSaleInvoices = new List<dmpl__SaleInvoice__c>();
        try {
            Map<Id, dmpl__SaleInvoice__c> newSaleInvoicesMap = SaleInvoiceHelper.createSaleInvoicesFromSelectedSaleOrderLines(saleOrderLineIds, saleOrderLineDraftValues, editableFields);
            newSaleInvoices = newSaleInvoicesMap.values();
        } catch (Exception e) {
            ExceptionLogHelper.logException(e);
            throw new AuraHandledException(e.getMessage());
        }
        return newSaleInvoices;
    }

    @AuraEnabled
    public static Boolean createBulkFulfilments(String objectAPIName, List<Id> recordIds){
        try {
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return true;
    }
}