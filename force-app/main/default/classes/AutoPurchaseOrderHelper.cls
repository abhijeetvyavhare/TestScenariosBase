public with sharing class AutoPurchaseOrderHelper 
{
    private static Boolean skipValidations = false;

    private static final string OBJECT_AUTOPURCHASEORDER = 'dmpl__AutoPurchaseOrder__c';
    private static final string OBJECT_AUTOPURCHASEORDERLINE = 'dmpl__AutoPurchaseOrderLine__c';

    private static final string FIELD_AUTOPURCHASEORDER_AUTOORDERTYPE = 'dmpl__AutoOrderType__c';
    private static final string FIELD_AUTOPURCHASEORDER_AUTOPURCHASEORDERID = 'dmpl__AutoPurchaseOrderId__c';
    private static final string FIELD_AUTOPURCHASEORDER_BRANCHID = 'dmpl__BranchId__c';
    private static final string FIELD_AUTOPURCHASEORDER_BUDGETAMOUNT = 'dmpl__BudgetAmount__c';
    private static final string FIELD_AUTOPURCHASEORDER_ISTEMPLATECREATED = 'dmpl__IsTemplateCreated__c';
    private static final string FIELD_AUTOPURCHASEORDER_DOCUMENTDATE = 'dmpl__DocumentDate__c';
    private static final string FIELD_AUTOPURCHASEORDER_GENERATEDBYID = 'dmpl__GeneratedById__c';
    private static final string FIELD_AUTOPURCHASEORDER_LASTAUTORORDERDATE = 'dmpl__LastAutoOrderDate__c';
    private static final string FIELD_AUTOPURCHASEORDER_PARTNERACCOUNTID = 'dmpl__PartnerAccountId__c';
    private static final string FIELD_AUTOPURCHASEORDER_PRICELISTID = 'dmpl__PriceListId__c';
    private static final string FIELD_AUTOPURCHASEORDER_REMARKS = 'dmpl__Remarks__c';
    private static final string FIELD_AUTOPURCHASEORDER_STATUS = 'dmpl__Status__c';
    private static final string FIELD_AUTOPURCHASEORDER_SUPPLIERACCOUNTID = 'dmpl__SupplierAccountId__c';
    private static final string FIELD_AUTOPURCHASEORDER_TOTALAMOUNT = 'dmpl__TotalAmount__c';

    private static final string FIELD_AUTOPURCHASEORDER_PERFORMORDERGENERATION = 'dmpl__PerformOrderGeneration__c';
    private static final string FIELD_AUTOPURCHASEORDER_ISORDERGENERATED = 'dmpl__IsOrderGenerated__c';
    
    private static final string FIELD_AUTOPURCHASEORDER_AUTOORDERTYPE_BACKORDER = 'Back Order';
    private static final string FIELD_AUTOPURCHASEORDER_AUTOORDERTYPE_MINIMUMSTOCKLEVEL = 'Minimum Stock Level';
    private static final string FIELD_AUTOPURCHASEORDER_AUTOORDERTYPE_FORCASTING = 'Forecasting';
    private static final string FIELD_AUTOPURCHASEORDER_AUTOORDERTYPE_TEMPLATE = 'Template';
    private static final string FIELD_AUTOPURCHASEORDER_AUTOORDERTYPE_REPLENISH = 'Replenish';

    private static final List<String> LIST_FIELDS_SYSTEM = new List<String>
    {
        FIELD_AUTOPURCHASEORDER_ISORDERGENERATED
    };
    private static final List<String> LIST_NON_EDITABLE_FIELDS = new List<String>
    {
        FIELD_AUTOPURCHASEORDER_SUPPLIERACCOUNTID, 
        FIELD_AUTOPURCHASEORDER_BRANCHID, 
        FIELD_AUTOPURCHASEORDER_DOCUMENTDATE, 
        FIELD_AUTOPURCHASEORDER_PARTNERACCOUNTID
    };

    public static void validateData(
        Boolean isInsert, 
        Boolean isUpdate, 
        Boolean isDelete, 
        List<dmpl__AutoPurchaseOrder__c> newEntries, 
        List<dmpl__AutoPurchaseOrder__c> oldEntries)
        {
        try{
            if(isInsert){
                FieldMappingHelper.copyFieldMappingData(
                    newEntries);
            }
            if(skipValidations){
                return;
            }
    
            DocumentStatusDFSHelper dfsHelper = new DocumentStatusDFSHelper();
            if(isInsert){
                StatusHelper.validateStatusNew(OBJECT_AUTOPURCHASEORDER, FIELD_AUTOPURCHASEORDER_STATUS, newEntries);
                DocumentHelper.validateChangeInSystemFields(LIST_FIELDS_SYSTEM, newEntries);
                ValidationHelper.validatePartnerAndBranch(FIELD_AUTOPURCHASEORDER_PARTNERACCOUNTID, FIELD_AUTOPURCHASEORDER_BRANCHID, newEntries);
                ValidationHelper.validateResource(FIELD_AUTOPURCHASEORDER_GENERATEDBYID, newEntries);
            }else if(isUpdate){
                StatusHelper.validateStatusEdit(OBJECT_AUTOPURCHASEORDER, FIELD_AUTOPURCHASEORDER_STATUS, oldEntries, newEntries);
                DocumentHelper.validateChangeInKeyFields(LIST_NON_EDITABLE_FIELDS, oldEntries, newEntries);
                DocumentHelper.validateChangeInSystemFields(LIST_FIELDS_SYSTEM, oldEntries, newEntries);
                dfsHelper.DocumentStatusRestrictEdits_Edit(OBJECT_AUTOPURCHASEORDER, FIELD_AUTOPURCHASEORDER_STATUS, oldEntries, newEntries);
                dfsHelper.DocumentStatusRestrictFieldsEdits(OBJECT_AUTOPURCHASEORDER, FIELD_AUTOPURCHASEORDER_STATUS, oldEntries, newEntries);
                validateOnTotalPendingQuantity(DocumentHelper.getApprovedObjects(FIELD_AUTOPURCHASEORDER_PERFORMORDERGENERATION, oldEntries, newEntries));
                ValidationHelper.validateResource(FIELD_AUTOPURCHASEORDER_GENERATEDBYID, newEntries);
            }else if(isDelete){
                dfsHelper.DocumentStatusRestrictEdits_Delete(OBJECT_AUTOPURCHASEORDER, FIELD_AUTOPURCHASEORDER_STATUS, oldEntries);
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
        List<dmpl__AutoPurchaseOrder__c> newEntries, 
        List<dmpl__AutoPurchaseOrder__c> oldEntries)
    {
        DocumentStatusDFSHelper dfsHelper = new DocumentStatusDFSHelper();
        if(isInsert){
    		DocumentNameHelper.generateDocumentName(newEntries);
            PriceListHelper.setDefaultPriceListIds(newEntries);
        }
        
        if(isUpdate)
        {
            dfsHelper.DocumentStatusSetFlag(OBJECT_AUTOPURCHASEORDER, FIELD_AUTOPURCHASEORDER_STATUS, oldEntries, newEntries);
            dfsHelper.DocumentStatusReSetFlag(OBJECT_AUTOPURCHASEORDER, FIELD_AUTOPURCHASEORDER_STATUS, oldEntries, newEntries);
            List<dmpl__AutoPurchaseOrder__c> modifiedObjects = DocumentHelper.getApprovedObjects(FIELD_AUTOPURCHASEORDER_PERFORMORDERGENERATION, oldEntries, newEntries);
            if(modifiedObjects.size() > 0)
            {
                generatePurchaseOrder(modifiedObjects);
            }
        }
    }

    public static void afterPostData(
        Boolean isInsert, 
        Boolean isUpdate, 
        Boolean isDelete, 
        List<dmpl__AutoPurchaseOrder__c> newEntries, 
        List<dmpl__AutoPurchaseOrder__c> oldEntries)
        {
        if(isInsert){
            List<dmpl__AutoPurchaseOrder__c> modifiedObjects = DocumentHelper.getObjectsByFilter(newEntries, FIELD_AUTOPURCHASEORDER_AUTOORDERTYPE, FIELD_AUTOPURCHASEORDER_AUTOORDERTYPE_MINIMUMSTOCKLEVEL);
            if(modifiedObjects.size() > 0){
                AutoPurchaseOrderLineHelper.createMinimumStockAutoOrderLineFromAutoOrder(modifiedObjects);
            }

            modifiedObjects = DocumentHelper.getObjectsByFilter(newEntries, FIELD_AUTOPURCHASEORDER_AUTOORDERTYPE, FIELD_AUTOPURCHASEORDER_AUTOORDERTYPE_REPLENISH);
            if(modifiedObjects.size() > 0){
                AutoPurchaseOrderLineHelper.createReplenishAutoOrderLineFromAutoOrder(modifiedObjects);
            }
        }
    }

    private static void generatePurchaseOrder(List<dmpl__AutoPurchaseOrder__c> autoPurchaseOrders)
    {
        PurchaseOrderHelper.createPurchaseOrderFromAutoPurchaseOrder(autoPurchaseOrders);
        for(dmpl__AutoPurchaseOrder__c autoPurchaseOrder : autoPurchaseOrders){
            autoPurchaseOrder.dmpl__PerformOrderGeneration__c = false;
            autoPurchaseOrder.dmpl__IsOrderGenerated__c = true;
        }
    }

    private static void validateOnTotalPendingQuantity(List<dmpl__AutoPurchaseOrder__c> autoPurchaseOrders)
    {
        Map<Id, dmpl__AutoPurchaseOrder__c> autoPurchaseOrdersMap = new Map<Id, dmpl__AutoPurchaseOrder__c>(autoPurchaseOrders);
        List<AggregateResult> result = queryTotalPendingAutoOrderQuantity(DocumentHelper.extractIds(autoPurchaseOrders));

        List<Id> fetchedAutoOrderIds = DocumentHelper.extractIds(result, 'AutoOrderId');
        for(dmpl__AutoPurchaseOrder__c lineEntry : autoPurchaseOrders)
            if(!fetchedAutoOrderIds.contains(lineEntry.Id))
                lineEntry.addError(System.label.AutoOrder_InvalidPendingQuantity);

        for(AggregateResult lineEntry : result)
            if(lineEntry.get('TotalPendingQuantity') == null || lineEntry.get('TotalPendingQuantity') == 0)
                autoPurchaseOrdersMap.get((Id)lineEntry.get('AutoOrderId')).addError(System.label.AutoOrder_InvalidPendingQuantity);
    }

    private static List<AggregateResult> queryTotalPendingAutoOrderQuantity(List<Id> autoOrderIds)
    {
        SecurityHelper.ensureCanReadFields(new string[]{'dmpl__AutoPurchaseOrderId__c'}, 'dmpl__AutoPurchaseOrderLine__c');
        return 
        [SELECT dmpl__AutoPurchaseOrderId__c AutoOrderId, SUM(dmpl__PendingQuantity__c) TotalPendingQuantity
        FROM dmpl__AutoPurchaseOrderLine__c
        WHERE dmpl__AutoPurchaseOrderId__c IN :autoOrderIds
        GROUP BY dmpl__AutoPurchaseOrderId__c];
    }
}