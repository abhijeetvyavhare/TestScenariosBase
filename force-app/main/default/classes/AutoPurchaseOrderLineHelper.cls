public with sharing class AutoPurchaseOrderLineHelper {

    private static Boolean skipValidations = false;

    private static final string OBJECT_AUTOPURCHASEORDER = 'dmpl__AutoPurchaseOrder__c';
    private static final string OBJECT_AUTOPURCHASEORDERLINE = 'dmpl__AutoPurchaseOrderLine__c';

    private static final string FIELD_AUTOPURCHASEORDERLINE_BRANCHID = 'dmpl__BranchId__c';
    private static final string FIELD_AUTOPURCHASEORDERLINE_ITEMID = 'dmpl__ItemId__c';
    private static final string FIELD_AUTOPURCHASEORDERLINE_SKUID = 'dmpl__SKUId__c';
    private static final string FIELD_AUTOPURCHASEORDERLINE_QUANTITY = 'dmpl__Quantity__c';
    private static final string FIELD_AUTOPURCHASEORDERLINE_SUGGESTEDQUANTITY = 'dmpl__SuggestedQuantity__c';
    private static final string FIELD_AUTOPURCHASEORDERLINE_AUTOPURCHASEORDERID = 'dmpl__AutoPurchaseOrderId__c';
    private static final string FIELDNAME_AUTOPURCHASEORDERLINE_PRICELISTRULEID = 'dmpl__PriceListRuleId__c';

    private static final string RELATION_AUTOPURCHASEORDER_STATUS = 'dmpl__AutoPurchaseOrderId__r.dmpl__Status__c';

    private static final string FIELD_INVENTORYSTOCK_BRANCHID = 'dmpl__BranchId__c';
    private static final string FIELD_INVENTORYSTOCK_ITEMID = 'dmpl__ItemId__c';
    private static final string FIELD_INVENTORYSTOCK_QUANTITYAVAILABLE = 'dmpl__QuantityAvailable__c';

    private static final string FIELD_INVENTORYORDERLINE_ITEMID = 'dmpl__ItemId__c';
    private static final string FIELD_INVENTORYORDERLINE_SKUID = 'dmpl__SKUId__c';
    private static final string FIELD_INVENTORYORDERLINE_QUANTITYALLOCATED = 'dmpl__AllocatedQuantity__c';
    
    private static final List<String> LIST_FIELDS_NONEDITABLE = new List<String>{
        FIELD_AUTOPURCHASEORDERLINE_AUTOPURCHASEORDERID
    };
    private static final List<String> LIST_FIELDS_SYSTEM = new List<String>{};
    private static final List<String> LIST_FIELDS_SOURCEPOULATED = new List<String>{
        FIELD_AUTOPURCHASEORDERLINE_ITEMID,
        FIELD_AUTOPURCHASEORDERLINE_SKUID
    };
    private static final List<String> LIST_FIELDS_LOCKEDIFTRANSACTED = new List<String>{
        FIELD_AUTOPURCHASEORDERLINE_ITEMID,
        FIELD_AUTOPURCHASEORDERLINE_SKUID
    };

    public static void validateData(
        Boolean isInsert, 
        Boolean isUpdate, 
        Boolean isDelete, 
        List<dmpl__AutoPurchaseOrderLine__c> newEntries, 
        List<dmpl__AutoPurchaseOrderLine__c> oldEntries){
        try{
            if(isInsert){
                FieldMappingHelper.copyFieldMappingData(
                    newEntries);
            }
            if(skipValidations){
                return;
            }
    
            if(isInsert){
                validateItem(newEntries);
                DocumentHelper.validateChangeInSystemFields(LIST_FIELDS_SYSTEM, newEntries);
                (new DocumentStatusDFSHelper()).DocumentStatusRelatedObjectRestrictEdits_New(
                    OBJECT_AUTOPURCHASEORDER, 
                    OBJECT_AUTOPURCHASEORDERLINE, 
                    RELATION_AUTOPURCHASEORDER_STATUS, 
                    newEntries);
            }else if(isUpdate){
                DocumentHelper.validateChangeInSystemFields(LIST_FIELDS_SYSTEM, oldEntries, newEntries);
                DocumentHelper.validateChangeInKeyFields(LIST_FIELDS_NONEDITABLE, oldEntries, newEntries);
                DocumentHelper.validateChangeInLockedIfTransactedFields(
                    LIST_FIELDS_LOCKEDIFTRANSACTED, 
                    oldEntries, 
                    newEntries, 
                    FIELD_AUTOPURCHASEORDERLINE_QUANTITY);
                (new DocumentStatusDFSHelper()).DocumentStatusRelatedObjectRestrictEdits_Edit(
                    OBJECT_AUTOPURCHASEORDER, 
                    OBJECT_AUTOPURCHASEORDERLINE, 
                    RELATION_AUTOPURCHASEORDER_STATUS, 
                    oldEntries, 
                    newEntries);
            }else if(isDelete){
                DocumentHelper.validateCanBeDeleted(
                    oldEntries, 
                    FIELD_AUTOPURCHASEORDERLINE_QUANTITY);
                (new DocumentStatusDFSHelper()).DocumentStatusRelatedObjectRestrictEdits_Delete(
                    OBJECT_AUTOPURCHASEORDER, 
                    OBJECT_AUTOPURCHASEORDERLINE, 
                    RELATION_AUTOPURCHASEORDER_STATUS, 
                    oldEntries);
            }
        } catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }

    public static void postData(
        Boolean isInsert, 
        Boolean isUpdate, 
        Boolean isDelete, 
        List<dmpl__AutoPurchaseOrderLine__c> newEntries, 
        List<dmpl__AutoPurchaseOrderLine__c> oldEntries){
            try{
                if(isInsert){
                    setItemData(newEntries);
                }
                else if(isUpdate){
                    List<dmpl__AutoPurchaseOrderLine__c> modifiedObjects = DocumentHelper.getModifiedNewObjects(FIELDNAME_AUTOPURCHASEORDERLINE_PRICELISTRULEID, oldEntries, newEntries);
                    if(modifiedObjects.size()>0){
                        Map<Id, dmpl__Item__c> items = new Map<Id,dmpl__Item__c>(ItemHelper.getCachedItems(DocumentHelper.extractIds(modifiedObjects, FIELD_AUTOPURCHASEORDERLINE_ITEMID)));
                        List<dmpl__AutoPurchaseOrder__c> autoPurchaseOrderDocuments = queryAutoPurchaseOrderDocument(DocumentHelper.extractIds(modifiedObjects, OBJECT_AUTOPURCHASEORDER));
                        PriceListHelper.setApplicablePrices(modifiedObjects, autoPurchaseOrderDocuments, items.values(), DocumentHelper.extractIds(modifiedObjects, FIELDNAME_AUTOPURCHASEORDERLINE_PRICELISTRULEID),'dmpl__AutoPurchaseOrderId__c');
                    }
        
                    modifiedObjects = DocumentHelper.getModifiedNewObjects(
                        new List<String>{
                            'dmpl__PriceListId__c'
                        },
                        oldEntries, 
                        newEntries);
                    if(modifiedObjects.size()>0){
                        Map<Id, dmpl__Item__c> items = new Map<Id,dmpl__Item__c>(ItemHelper.getCachedItems(DocumentHelper.extractIds(modifiedObjects, FIELD_AUTOPURCHASEORDERLINE_ITEMID)));
                        List<dmpl__AutoPurchaseOrder__c> autoPurchaseOrderDocuments = queryAutoPurchaseOrderDocument(DocumentHelper.extractIds(modifiedObjects, OBJECT_AUTOPURCHASEORDER));
                        PriceListHelper.setApplicablePrices(modifiedObjects, autoPurchaseOrderDocuments, items.values(), true);
                    }
                }
            } catch (Exception error) {
                    ExceptionLogHelper.logException(error);
                    throw error;
                }
        
            }

    public static void createMinimumStockAutoOrderLineFromAutoOrder(List<dmpl__AutoPurchaseOrder__c> autoPurchaseOrders){
        createMinimumStockAutoOrderLine(autoPurchaseOrders);
    }

    public static void createReplenishAutoOrderLineFromAutoOrder(List<dmpl__AutoPurchaseOrder__c> autoPurchaseOrders){
        createReplenishAutoOrderLine(autoPurchaseOrders);
    }

    public static void updatePurchaseOrderQuantity(List<Id> autoOrderLineIds)
    {
        try{
            if(autoOrderLineIds.size () == 0 || autoOrderLineIds == null)
                return;
            skipValidations = true;

            SecurityHelper.ensureCanReadFields(new string[]{'dmpl__PurchaseRequisitionLineId__c','dmpl__Quantity__c'}, 'dmpl__PurchaseOrderLine__c');
            List<AggregateResult> orderAggregates = 
                [SELECT dmpl__AutoPurchaseOrderLineId__c AutoOrderLineId, SUM(dmpl__Quantity__c) TotalOrderQuantity
                FROM dmpl__PurchaseOrderLine__c
                WHERE dmpl__AutoPurchaseOrderLineId__c IN :autoOrderLineIds
                WITH SECURITY_ENFORCED
                GROUP BY dmpl__AutoPurchaseOrderLineId__c];

            SecurityHelper.ensureCanReadFields(new string[]{'dmpl__PurchaseOrderQuantity__c'}, 'dmpl__PurchaseRequisitionLine__c');
            List<dmpl__AutoPurchaseOrderLine__c> autoOrderLinesToUpdate = 
                [SELECT Id, dmpl__PurchaseOrderQuantity__c
                FROM dmpl__AutoPurchaseOrderLine__c
                WHERE Id IN :autoOrderLineIds];
    
            for(dmpl__AutoPurchaseOrderLine__c autoOrderLine : autoOrderLinesToUpdate){
                for(AggregateResult result : orderAggregates){
                    if(result.get('AutoOrderLineId') == autoOrderLine.Id){
                        autoOrderLine.dmpl__PurchaseOrderQuantity__c = result.get('TotalOrderQuantity') ==null ? 0 : (Decimal)(result.get('TotalOrderQuantity'));
                        break;
                    }
                }
            }

            SecurityHelper.ensureCanWriteFields(new string[]{'dmpl__PurchaseOrderQuantity__c'}, 'dmpl__AutoPurchaseOrderLine__c');
            Update autoOrderLinesToUpdate;
        }finally{
            skipValidations = false;
        }
    }

    private static void createReplenishAutoOrderLine(List<dmpl__AutoPurchaseOrder__c> autoPurchaseOrders){

        // GET OPEN ORDER QUANTITY
        List<AggregateResult> openOrderQuantityResult = queryOpenOrderQuantity(DocumentHelper.extractIds(DocumentHelper.getApprovedNewObjects('dmpl__PerformOpenOrderCalculation__c', autoPurchaseOrders), 'dmpl__BranchId__c'));

        // GET LAST AUTOORDER DOCUMENT DATE
        List<AggregateResult> lastAutoOrderDates = queryLastAutoPurchaseOrders(DocumentHelper.extractIds(autoPurchaseOrders, 'dmpl__BranchId__c'));    

        List<dmpl__AutoPurchaseOrderLine__c> newAutoPurchaseOrderLines = new List<dmpl__AutoPurchaseOrderLine__c>();
        for(dmpl__AutoPurchaseOrder__c autoPurchaseOrder : autoPurchaseOrders){
            AggregateResult lastAutoOrderRecord = (AggregateResult)DocumentHelper.getObjectByFilter(lastAutoOrderDates, 'dmpl__BranchId__c', autoPurchaseOrder.dmpl__BranchId__c);
            Date lastAutoOrderDate = lastAutoOrderRecord != null ? (Date)lastAutoOrderRecord.get('MaxDocumentDate') : Datetime.newInstance(1900, 1, 1).date();
            List<AggregateResult> inventoryOrderLines = queryInventoryOrderLine(lastAutoOrderDate, autoPurchaseOrder.dmpl__BranchId__c);
            for(AggregateResult inventoryOrderLine : inventoryOrderLines){
                newAutoPurchaseOrderLines.add(new dmpl__AutoPurchaseOrderLine__c(
                    dmpl__AutoPurchaseOrderId__c = autoPurchaseOrder.ID,
                    dmpl__ItemId__c = (ID)inventoryOrderLine.get(FIELD_INVENTORYORDERLINE_ITEMID),
                    dmpl__Quantity__c = (Decimal)inventoryOrderLine.get(FIELD_INVENTORYORDERLINE_QUANTITYALLOCATED) == null ? 1 : (Decimal)inventoryOrderLine.get(FIELD_INVENTORYORDERLINE_QUANTITYALLOCATED),
                    dmpl__SuggestedQuantity__c = (Decimal)inventoryOrderLine.get(FIELD_INVENTORYORDERLINE_QUANTITYALLOCATED),
                    dmpl__SKUId__c = (ID)inventoryOrderLine.get(FIELD_INVENTORYORDERLINE_SKUID),
                    dmpl__OpenOrderQuantity__c = (Decimal)getOpenOrderQuantity(openOrderQuantityResult, autoPurchaseOrder.dmpl__PartnerAccountId__c, autoPurchaseOrder.dmpl__BranchId__c, (ID)inventoryOrderLine.get(FIELD_INVENTORYORDERLINE_ITEMID), (ID)inventoryOrderLine.get(FIELD_INVENTORYORDERLINE_SKUID))
                ));
            }
        }
        createAutoPurchaseOrderLines(newAutoPurchaseOrderLines);
    }

    private static void createMinimumStockAutoOrderLine(List<dmpl__AutoPurchaseOrder__c> autoPurchaseOrders){
    
        List<dmpl__AutoPurchaseOrderLine__c> newAutoPurchaseOrderLines = new List<dmpl__AutoPurchaseOrderLine__c>();
        LIst<ID> branchIds = DocumentHelper.extractIds(autoPurchaseOrders, FIELD_AUTOPURCHASEORDERLINE_BRANCHID);
        List<dmpl__ItemInventoryAttribute__c> itemStockSettings = queryItemStockSetting(branchIds);
        List<Id> itemIds = DocumentHelper.extractIds(itemStockSettings ,FIELD_AUTOPURCHASEORDERLINE_ITEMID);
        List<AggregateResult> inventoryStocks = queryInventoryStock(DocumentHelper.extractIds(itemStockSettings,FIELD_AUTOPURCHASEORDERLINE_ITEMID), branchIds);
        List<AggregateResult> openOrderQuantityResult = queryOpenOrderQuantity(DocumentHelper.extractIds(DocumentHelper.getApprovedNewObjects('dmpl__PerformOpenOrderCalculation__c', autoPurchaseOrders), FIELD_AUTOPURCHASEORDERLINE_BRANCHID), itemIds);
        //
        for(dmpl__AutoPurchaseOrder__c autoPurchaseOrder : autoPurchaseOrders)
        {
            for(dmpl__ItemInventoryAttribute__c itemStockSetting : itemStockSettings)
            {
                Boolean itemFound = false;
                for(AggregateResult inventoryStock : inventoryStocks)
                {
                    
                    if(inventoryStock.get(FIELD_INVENTORYSTOCK_ITEMID) == itemStockSetting.dmpl__ItemId__c)
                        itemFound = true;
                    
                    if(inventoryStock.get(FIELD_INVENTORYSTOCK_ITEMID) == itemStockSetting.dmpl__ItemId__c 
                        && (inventoryStock.get(FIELD_INVENTORYSTOCK_BRANCHID) == itemStockSetting.dmpl__BranchId__c || itemStockSetting.dmpl__BranchId__c == null || String.isBlank(itemStockSetting.dmpl__BranchId__c))
                        && Integer.valueOf(inventoryStock.get(FIELD_INVENTORYSTOCK_QUANTITYAVAILABLE)) < itemStockSetting.dmpl__MinimumStockLevel__c)
                    {
                        newAutoPurchaseOrderLines.Add(new dmpl__AutoPurchaseOrderLine__c
                        (
                            dmpl__AutoPurchaseOrderId__c = autoPurchaseOrder.ID,
                            dmpl__ItemId__c = String.valueof(inventoryStock.get(FIELD_INVENTORYSTOCK_ITEMID)),
                            dmpl__SKUId__c = String.valueof(inventoryStock.get(FIELD_INVENTORYORDERLINE_SKUID)),
                            Quantity__c = itemStockSetting.dmpl__ReorderQuantity__c > 0 ? itemStockSetting.dmpl__ReorderQuantity__c : itemStockSetting.dmpl__MinimumStockLevel__c - Integer.valueOf(inventoryStock.get(FIELD_INVENTORYSTOCK_QUANTITYAVAILABLE)),
                            dmpl__SuggestedQuantity__c = itemStockSetting.dmpl__ReorderQuantity__c > 0 ? itemStockSetting.dmpl__ReorderQuantity__c : itemStockSetting.dmpl__MinimumStockLevel__c - Integer.valueOf(inventoryStock.get(FIELD_INVENTORYSTOCK_QUANTITYAVAILABLE)),
                            dmpl__OpenOrderQuantity__c = (Decimal)getOpenOrderQuantity(openOrderQuantityResult, autoPurchaseOrder.dmpl__PartnerAccountId__c, autoPurchaseOrder.dmpl__BranchId__c, String.valueof(inventoryStock.get(FIELD_INVENTORYSTOCK_ITEMID)), String.valueof(inventoryStock.get(FIELD_INVENTORYORDERLINE_SKUID)))
                        ));
                    }
                }
                if(!itemFound)
                {
                    newAutoPurchaseOrderLines.Add(new dmpl__AutoPurchaseOrderLine__c
                    (
                        dmpl__AutoPurchaseOrderId__c = autoPurchaseOrder.ID,
                        dmpl__ItemId__c = String.valueof(itemStockSetting.get(FIELD_INVENTORYSTOCK_ITEMID)),
                        dmpl__SKUId__c = String.valueof(itemStockSetting.get(FIELD_INVENTORYORDERLINE_SKUID)),
                        Quantity__c = itemStockSetting.dmpl__ReorderQuantity__c > 0 ? itemStockSetting.dmpl__ReorderQuantity__c : itemStockSetting.dmpl__MinimumStockLevel__c,
                        dmpl__SuggestedQuantity__c = itemStockSetting.dmpl__ReorderQuantity__c > 0 ? itemStockSetting.dmpl__ReorderQuantity__c : itemStockSetting.dmpl__MinimumStockLevel__c,
                        dmpl__OpenOrderQuantity__c = (Decimal)getOpenOrderQuantity(openOrderQuantityResult, autoPurchaseOrder.dmpl__PartnerAccountId__c, autoPurchaseOrder.dmpl__BranchId__c, itemStockSetting.dmpl__ItemId__c, itemStockSetting.dmpl__SKUId__c)
                    ));
                }
            }
        }
        createAutoPurchaseOrderLines(newAutoPurchaseOrderLines);
    }
    
    private static void createAutoPurchaseOrderLines(List<dmpl__AutoPurchaseOrderLine__c> newAutoPurchaseOrderLines){
        if(newAutoPurchaseOrderLines.size() > 0){
            try {
                skipValidations = true;
                SecurityHelper.ensureCanWriteFields(new string[]{'dmpl__ItemId__c','dmpl__Quantity__c','dmpl__SuggestedQuantity__c','dmpl__SKUId__c'}, 'dmpl__AutoPurchaseOrderLine__c');
                insert newAutoPurchaseOrderLines;            
            } 
            finally {
                skipValidations = false;
            }
        }
    }

    private static void validateItem(List<dmpl__AutoPurchaseOrderLine__c> newEntries){
        Map<Id, dmpl__Item__c> items = new Map<Id,dmpl__Item__c>(ItemHelper.getCachedItems(DocumentHelper.extractIds(newEntries, FIELD_AUTOPURCHASEORDERLINE_ITEMID)));
        for(dmpl__AutoPurchaseOrderLine__c orderLine : newEntries){
            dmpl__Item__c item = items.get(orderLine.dmpl__ItemId__c);
            if(orderLine.dmpl__SKUId__c == null && item!=null && item.dmpl__IsSKURequired__c){
                orderLine.addError(System.Label.Validation_SKURequired);
            }
            if(orderLine.dmpl__SKUId__c != null){
                dmpl__SKU__c sku = (dmpl__SKU__c)CollectionHelper.getObject(item.dmpl__SKUs__r, orderLine.dmpl__SKUId__c);
                if(sku ==null){
                    orderLine.addError(System.Label.Validation_SKUInvalid);
                }
            }
        }
    }

    private static void setItemData(List<dmpl__AutoPurchaseOrderLine__c> newEntries)
    {
        Map<Id, dmpl__Item__c> items = new Map<Id,dmpl__Item__c>(
        ItemHelper.getCachedItems(DocumentHelper.extractIds(newEntries, FIELD_AUTOPURCHASEORDERLINE_ITEMID)));
        List<dmpl__AutoPurchaseOrder__c> autoPurchaseOrderDocuments = queryAutoPurchaseOrderDocument(DocumentHelper.extractIds(newEntries, FIELD_AUTOPURCHASEORDERLINE_AUTOPURCHASEORDERID));
        PriceListHelper.setApplicablePrices(
            newEntries, 
            autoPurchaseOrderDocuments, 
            items.values(),
            false);
    }

    private static Decimal getOpenOrderQuantity(List<AggregateResult> openOrderLines, Id partnerAccountId, Id branchId, Id itemId, Id skuId)
    {
        Decimal result = 0;
        for(AggregateResult openOrderLine : openOrderLines)
        {
            System.debug('partnerAccountId '+partnerAccountId);
            System.debug('branchId '+branchId);
            System.debug('itemId '+itemId);
            System.debug('openOrderLine'+openOrderLine.get('TotalQuantity'));
            if(openOrderLine.get('PartnerAccountId') == partnerAccountId 
            && openOrderLine.get('BranchId') == branchId 
            && openOrderLine.get('dmpl__ItemId__c') == itemId 
            && openOrderLine.get('dmpl__SKUId__c') == skuId)
                result = (Decimal)openOrderLine.get('TotalQuantity');
        }
        System.debug('result'+result);
        return result;
    }

    private static List<AggregateResult> queryOpenOrderQuantity(List<Id> branchIds)
    {
        SecurityHelper.ensureCanReadFields(new string[]{
            'dmpl__PartnerAccountId__c',
            'dmpl__BranchId__c'},
            'dmpl__PurchaseOrder__c');
        SecurityHelper.ensureCanReadFields(new string[]{
            'dmpl__PurchaseOrderId__r',
            'dmpl__ItemId__c',
            'dmpl__PendingQuantity__c',
            'dmpl__SKUId__c'}, 
            'dmpl__PurchaseOrderLine__c');
        return new List<AggregateResult>([SELECT 
            SUM(dmpl__PendingQuantity__c) TotalQuantity, 
            dmpl__PurchaseOrderId__r.dmpl__PartnerAccountId__c PartnerAccountId, 
            dmpl__PurchaseOrderId__r.dmpl__BranchId__c BranchId, 
            dmpl__ItemId__c, 
            dmpl__ItemId__r.Name ItemName, 
            dmpl__SKUId__c, 
            dmpl__SKUId__r.Name SKUName 
        FROM dmpl__PurchaseOrderLine__c 
        WHERE 
            dmpl__PendingQuantity__c > 0 
            AND dmpl__PurchaseOrderId__r.dmpl__BranchId__c IN : branchIds
        GROUP BY 
            dmpl__PurchaseOrderId__r.dmpl__PartnerAccountId__c, 
            dmpl__PurchaseOrderId__r.dmpl__BranchId__c, 
            dmpl__ItemId__c, 
            dmpl__ItemId__r.Name, 
            dmpl__SKUId__c, 
            dmpl__SKUId__r.Name]);
    }

    private static List<AggregateResult> queryOpenOrderQuantity(List<Id> branchIds, List<Id> itemIds)
    {
        SecurityHelper.ensureCanReadFields(new string[]{
            'dmpl__PartnerAccountId__c',
            'dmpl__BranchId__c'},
            'dmpl__PurchaseOrder__c');
        SecurityHelper.ensureCanReadFields(new string[]{
            'dmpl__PurchaseOrderId__r',
            'dmpl__ItemId__c',
            'dmpl__PendingQuantity__c',
            'dmpl__SKUId__c'}, 
            'dmpl__PurchaseOrderLine__c');

        return new List<AggregateResult>([SELECT 
            SUM(dmpl__PendingQuantity__c) TotalQuantity, 
            dmpl__PurchaseOrderId__r.dmpl__PartnerAccountId__c PartnerAccountId, 
            dmpl__PurchaseOrderId__r.dmpl__BranchId__c BranchId, 
            dmpl__ItemId__c, 
            dmpl__ItemId__r.Name ItemName, 
            dmpl__SKUId__c, 
            dmpl__SKUId__r.Name SKUName 
        FROM dmpl__PurchaseOrderLine__c 
        WHERE 
            dmpl__PendingQuantity__c > 0 
            AND dmpl__PurchaseOrderId__r.dmpl__BranchId__c IN : branchIds
            AND dmpl__ItemId__c IN : itemIds
        GROUP BY 
            dmpl__PurchaseOrderId__r.dmpl__PartnerAccountId__c, 
            dmpl__PurchaseOrderId__r.dmpl__BranchId__c, 
            dmpl__ItemId__c, 
            dmpl__ItemId__r.Name, 
            dmpl__SKUId__c, 
            dmpl__SKUId__r.Name]);
    }

    private static List<dmpl__ItemInventoryAttribute__c> queryItemStockSetting(List<ID> branchIds)
    {
        SecurityHelper.ensureCanReadFields(new string[]{'dmpl__ItemId__c','dmpl__SKUId__c','dmpl__BranchId__c','dmpl__MaximumOrderQuantity__c','dmpl__MinimumOrderQuantity__c','dmpl__MinimumStockLevel__c','dmpl__ReorderQuantity__c'}, 'dmpl__ItemInventoryAttribute__c');
        return [SELECT
        Id, 
        Name, 
        dmpl__ItemId__c,
        dmpl__SKUId__c, 
        dmpl__BranchId__c,
        dmpl__MaximumOrderQuantity__c, 
        dmpl__MinimumOrderQuantity__c, 
        dmpl__MinimumStockLevel__c, 
        dmpl__ReorderQuantity__c 
        FROM dmpl__ItemInventoryAttribute__c
        WHERE dmpl__BranchId__c IN : branchIds];
    }

    private static List<AggregateResult> queryInventoryStock(List<ID> itemIds, List<ID> branchIds)
    {
        SecurityHelper.ensureCanReadFields(new string[]{'dmpl__ItemId__c','dmpl__SKUId__c','dmpl__BranchId__c','dmpl__QuantityAvailable__c'}, 'dmpl__InventoryStock__c');
        return [Select
        dmpl__ItemId__c,
        dmpl__SKUId__c, 
        dmpl__BranchId__c, 
        SUM(dmpl__QuantityAvailable__c) dmpl__QuantityAvailable__c
        FROM 
        dmpl__InventoryStock__c
        WHERE dmpl__ItemId__c IN : itemIds 
        AND (dmpl__BranchId__c IN : (branchIds) OR dmpl__BranchId__c = null)
        Group By dmpl__ItemId__c,dmpl__SKUId__c,dmpl__BranchId__c];
    }

    private static List<AggregateResult> queryLastAutoPurchaseOrders(List<Id> branchIds)
    {
        SecurityHelper.ensureCanReadFields(new string[]{'dmpl__DocumentDate__c','dmpl__BranchId__c','dmpl__AutoOrderType__c'}, 'dmpl__AutoPurchaseOrder__c');
        Date today = Datetime.now().date();
        return [
            SELECT 
                dmpl__BranchId__c,
                MAX(dmpl__DocumentDate__c) MaxDocumentDate
            FROM 
                dmpl__AutoPurchaseOrder__c 
            WHERE 
                dmpl__BranchId__c IN : branchIds 
                AND dmpl__AutoOrderType__c = 'Replenish' 
                AND dmpl__DocumentDate__c < : today
            GROUP BY dmpl__BranchId__c
        ];
    }

    private static List<AggregateResult> queryInventoryOrderLine(Date lastDocumentDate, ID branchId)
    {
        SecurityHelper.ensureCanReadFields(new string[]{'dmpl__ItemId__c','dmpl__SKUId__c','dmpl__AllocatedQuantity__c'}, 'dmpl__InventoryFulfillmentOrderLine__c');
        SecurityHelper.ensureCanReadFields(new string[]{'dmpl__BranchId__c','dmpl__DocumentDate__c'}, 'dmpl__InventoryFulfillment__c');
        return 
        [Select  dmpl__ItemId__c, 
        dmpl__FulfillmentId__r.dmpl__BranchId__c,
        dmpl__SKUId__c,  
        SUM(dmpl__AllocatedQuantity__c) dmpl__AllocatedQuantity__c
        FROM 
        dmpl__InventoryFulfillmentOrderLine__c
        WHERE dmpl__FulfillmentId__r.dmpl__DocumentDate__c >= : lastDocumentDate AND dmpl__FulfillmentId__r.dmpl__BranchId__c = : branchId
        Group By dmpl__ItemId__c, dmpl__FulfillmentId__r.dmpl__BranchId__c,dmpl__SKUId__c
        ];
    }

    private static List<dmpl__AutoPurchaseOrder__c> queryAutoPurchaseOrderDocument(List<ID> autoPurchaseOrderLineIds)
    {

        SecurityHelper.ensureCanReadFields(new string[]{
            'dmpl__DocumentDate__c',
            'dmpl__Status__c',
            'dmpl__PartnerAccountId__c',
            'dmpl__BranchId__c',
            'dmpl__PriceAsOnDate__c',
            'dmpl__PriceListId__c'
        }, 'dmpl__AutoPurchaseOrder__c');
        return [
            SELECT 
                Id, 
                Name, 
                dmpl__DocumentDate__c,
                dmpl__Status__c,
                dmpl__PartnerAccountId__c,
                dmpl__SupplierAccountId__c,
                dmpl__BranchId__c,
                dmpl__PriceAsOnDate__c,
                dmpl__PriceListId__c
            FROM dmpl__AutoPurchaseOrder__c 
            WHERE ID IN : autoPurchaseOrderLineIds ];
    }
}