public with sharing class FulfillmentHelper {
   
    /************************************************************************************************
     * Private Scope Constants
     ************************************************************************************************/
    private static final string OBJECT_FULFILMENT = 'dmpl__InventoryFulfillment__c';
    private static final string FIELD_FULFILMENT_STATUS = 'dmpl__Status__c';
    private static final string FIELD_FULFILMENT_PARTNERACCOUNTID = 'dmpl__PartnerAccountId__c';
    private static final string FIELD_FULFILMENT_BRANCHID = 'dmpl__BranchId__c';
    private static final string FIELD_FULFILMENT_ACCOUNTID ='dmpl__AccountId__c';
    private static final string FIELD_FULFILMENT_DOCUMENTDATE ='dmpl__DocumentDate__c';
    private static final string FIELD_FULFILMENT_SALEORDERID ='dmpl__SaleOrderId__c';
    private static final string FIELD_FULFILMENT_REPAIRORDERID ='dmpl__RepairOrderId__c';
    private static final string FIELD_FULFILMENT_ALLOCATEDBYID ='dmpl__AllocatedById__c';
    private static final String FIELD_ALLOCATIONLINE_ISALLOCATED = 'dmpl__IsAllocated__c';
    private static final string FIELD_FULFILMENTORDERLINE_FULFILMENTORDERID ='dmpl__FulfillmentId__c';
    public static final string FIELD_ALLOCATIONLINE_PERFORMALLOCATION = 'dmpl__PerformAllocation__c';
    private static final string RELATION_FULFILMENT_SALEORDERLINES = 'dmpl__FulfillmentOrderLines__r';
    private static final List<String> LIST_FIELDS_SOURCEPOULATED = new List<String>{
        FIELD_FULFILMENT_PARTNERACCOUNTID, 
        FIELD_FULFILMENT_BRANCHID,
        FIELD_FULFILMENT_ACCOUNTID};
    private static final List<String> LIST_NON_EDITABLE_FIELDS = new List<String>{
        FIELD_FULFILMENT_PARTNERACCOUNTID, 
        FIELD_FULFILMENT_BRANCHID, 
        FIELD_FULFILMENT_DOCUMENTDATE, 
        FIELD_FULFILMENT_ACCOUNTID, 
        FIELD_FULFILMENT_SALEORDERID};
    private static final List<String> LIST_FIELDS_SYSTEM = new List<String>{

    };
    

    /************************************************************************************************
     * Public Scope Functions
     ************************************************************************************************/
    public static void validateData(
        Boolean isInsert, 
        Boolean isDelete, 
        Boolean isUpdate, 
        List<dmpl__InventoryFulfillment__c> oldEntries, 
        List<dmpl__InventoryFulfillment__c> newEntries)
    {
        try{      
        DocumentStatusDFSHelper dfsHelper = new DocumentStatusDFSHelper();
        if(isInsert){
            FieldMappingHelper.copyFieldMappingData(
                newEntries);
            StatusHelper.validateStatusNew(
                OBJECT_FULFILMENT, 
                FIELD_FULFILMENT_STATUS, 
                newEntries);
            DocumentHelper.validateChangeInSystemFields(
                LIST_FIELDS_SYSTEM, 
                newEntries);
            ValidationHelper.validatePartnerAndBranch(
                FIELD_FULFILMENT_PARTNERACCOUNTID, 
                FIELD_FULFILMENT_BRANCHID, 
                newEntries);
            ValidationHelper.validateResource(
                FIELD_FULFILMENT_ALLOCATEDBYID, 
                newEntries);
        }else if(isUpdate){
            StatusHelper.validateStatusEdit(
                OBJECT_FULFILMENT, 
                FIELD_FULFILMENT_STATUS, 
                oldEntries, 
                newEntries);
            DocumentHelper.validateChangeInSystemFields(
                LIST_FIELDS_SYSTEM, 
                oldEntries, 
                newEntries);
            DocumentHelper.validateChangeInKeyFields(
                LIST_NON_EDITABLE_FIELDS, 
                oldEntries, 
                newEntries, 
                queryTransactedObjectIds(newEntries));
            DocumentHelper.validateChangeInSourcePopulatedFields(
                LIST_FIELDS_SOURCEPOULATED, 
                oldEntries, 
                newEntries, 
                FIELD_FULFILMENT_SALEORDERID);
            dfsHelper.DocumentStatusRestrictEdits_Edit(
                OBJECT_FULFILMENT, 
                FIELD_FULFILMENT_STATUS, 
                oldEntries, 
                newEntries);
            dfsHelper.DocumentStatusRestrictFieldsEdits(
                OBJECT_FULFILMENT, 
                FIELD_FULFILMENT_STATUS, 
                oldEntries, 
                newEntries);
            ValidationHelper.validateResource(
                FIELD_FULFILMENT_ALLOCATEDBYID, 
                newEntries);
        }else if(isDelete){
            dfsHelper.DocumentStatusRestrictEdits_Delete(
                OBJECT_FULFILMENT, 
                FIELD_FULFILMENT_STATUS, 
                oldEntries);
        }
    } catch (Exception error) {
        ExceptionLogHelper.logException(error);
        throw error;
    }
    }

    public static void postData(
        Boolean isInsert, 
        Boolean isDelete, 
        Boolean isUpdate, 
        List<dmpl__InventoryFulfillment__c> oldEntries, 
        List<dmpl__InventoryFulfillment__c> newEntries)
        {
        DocumentStatusDFSHelper dfsHelper = new DocumentStatusDFSHelper();
        try{
            if(isInsert)
    		DocumentNameHelper.generateDocumentName(newEntries);
            
            if(isUpdate){
                dfsHelper.DocumentStatusSetFlag(
                    OBJECT_FULFILMENT, 
                    FIELD_FULFILMENT_STATUS, 
                    oldEntries, newEntries);
                dfsHelper.DocumentStatusReSetFlag(
                    OBJECT_FULFILMENT, 
                    FIELD_FULFILMENT_STATUS, 
                    oldEntries, 
                    newEntries);
                List<dmpl__InventoryFulfillment__c> modifiedDocuments = DocumentHelper.getApprovedObjects(
                    FIELD_ALLOCATIONLINE_PERFORMALLOCATION, 
                    oldEntries, 
                    newEntries);
                if(modifiedDocuments.size() > 0){
                    allocateLines(modifiedDocuments);
                }
                modifiedDocuments = DocumentHelper.getApprovedObjects(
                    'dmpl__PerformPicking__c', 
                    oldEntries, 
                    newEntries);
                if(modifiedDocuments.size() > 0){
                    pickLines(modifiedDocuments);
                }
                modifiedDocuments = DocumentHelper.getApprovedObjects(
                    'dmpl__PerformCancelAllocation__c', 
                    oldEntries, 
                    newEntries);
                if(modifiedDocuments.size() > 0){
                    cancelAllocation(modifiedDocuments);
                }
                modifiedDocuments = DocumentHelper.getApprovedObjects(
                    'dmpl__PerformCancelPicking__c', 
                    oldEntries, 
                    newEntries);
                if(modifiedDocuments.size() > 0){
                    cancelPicking(modifiedDocuments);
                }
            }
        } catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }

    public static void createFulfillmentFromSaleOrder(List<dmpl__SaleOrder__c> saleOrders){
        createFulfillmentFromSaleOrderInternal(
            querySaleOrderLines(
                DocumentHelper.extractIds(saleOrders), 
                null), 
            null,
            null);
    }
    
    public static CreateRelatedResult createFulfillmentFromSaleOrder(Id saleOrderId){
        return CreateRelatedResult.InitFrom(
            createFulfillmentFromSaleOrderInternal(
                querySaleOrderLines(
                    new List<Id>{saleOrderId},
                    null), 
                null,
                null));
    }
    
    public static CreateRelatedResult createFulfillmentFromSaleOrder(List<SourceObjectInfo> orderLinesInfo){
        return CreateRelatedResult.InitFrom(
            createFulfillmentFromSaleOrderInternal(
                querySaleOrderLines(
                    (List<Id>)null, 
                    SourceObjectInfo.extractIds(orderLinesInfo)), 
                null,
                orderLinesInfo));
    }

    public static void createFulfillmentFromSaleOrderAndAllocate(List<dmpl__SaleOrder__c> saleOrders){
        Map<Id, dmpl__InventoryFulfillment__c> fulfilments = createFulfillmentFromSaleOrderInternal(
            querySaleOrderLines(
                DocumentHelper.extractIds(saleOrders), 
                null), 
            null,
            null);
        allocateLines(fulfilments.values());
    }
    
    public static CreateRelatedResult createFulfillmentFromSaleOrderAndAllocate(Id saleOrderId){
        Map<Id, dmpl__InventoryFulfillment__c> fulfilments = createFulfillmentFromSaleOrderInternal(
                querySaleOrderLines(
                    new List<Id>{saleOrderId},
                    null), 
                null,
                null);
        allocateLines(fulfilments.values());
        return CreateRelatedResult.InitFrom(fulfilments);
    }
    
    public static CreateRelatedResult createFulfillmentFromSaleOrderAndAllocate(List<SourceObjectInfo> orderLinesInfo){
        Map<Id, dmpl__InventoryFulfillment__c> fulfilments = createFulfillmentFromSaleOrderInternal(
                querySaleOrderLines(
                    (List<Id>)null, 
                    SourceObjectInfo.extractIds(orderLinesInfo)), 
                null,
                orderLinesInfo);
        allocateLines(fulfilments.values());
        return CreateRelatedResult.InitFrom(fulfilments);
    }

    public static CreateRelatedResult populateFulfillmentFromSaleOrder(
        List<SourceObjectInfo> orderLinesInfo, 
        Id fulfillmentDocumentId){
            return CreateRelatedResult.InitFrom(
                createFulfillmentFromSaleOrderInternal(
                    querySaleOrderLines(
                        (List<Id>)null, 
                        SourceObjectInfo.extractIds(orderLinesInfo)),
                    queryFulfillmentDocument(fulfillmentDocumentId),
                    null));
    }

    public static CreateRelatedResult populateFulfillmentFromRepairOrder(
        List<SourceObjectInfo> orderLinesInfo, 
        Id fulfillmentDocumentId){
            return CreateRelatedResult.InitFrom(
                createFulfillmentFromRepairOrderInternal(
                    queryRepairOrderLines(
                        (List<Id>)null, 
                        SourceObjectInfo.extractIds(orderLinesInfo)),
                    queryFulfillmentDocument(fulfillmentDocumentId),
                    null,
                    false));
    }

    public static CreateRelatedResult createFulfillmentFromRepairOrder(Id repairOrderId){
        return CreateRelatedResult.InitFrom(
                createFulfillmentFromRepairOrderInternal(
                    queryRepairOrderLines(
                        new List<Id>{ repairOrderId}, 
                        null),
                    null,
                    null,
                    true));
    }

    public static CreateRelatedResult createNewFulfillmentFromRepairOrder(Id repairOrderId){
        return CreateRelatedResult.InitFrom(
                createFulfillmentFromRepairOrderInternal(
                    queryRepairOrderLines(
                        new List<Id>{ repairOrderId}, 
                        null),
                    null,
                    null,
                    false));
    }

    public static CreateRelatedResult createFulfillmentFromRepairOrder(List<dmpl__RepairOrder__c> repairOrders){
        return CreateRelatedResult.InitFrom(
                createFulfillmentFromRepairOrderInternal(
                    queryRepairOrderLines(
                        DocumentHelper.extractIds(repairOrders), 
                        null),
                    null,
                    null,
                    false));
    }

    public static CreateRelatedResult createFulfillmentFromRepairOrder(List<SourceObjectInfo> orderLinesInfo){
        return CreateRelatedResult.InitFrom(
            createFulfillmentFromRepairOrderInternal(
                queryRepairOrderLines(
                    (List<Id>)null, 
                    SourceObjectInfo.extractIds(orderLinesInfo)),
                null,
                orderLinesInfo,
                true));
    }

    public static CreateRelatedResult createNewFulfillmentFromRepairOrder(List<SourceObjectInfo> orderLinesInfo){
        return CreateRelatedResult.InitFrom(
            createFulfillmentFromRepairOrderInternal(
                queryRepairOrderLines(
                    (List<Id>)null, 
                    SourceObjectInfo.extractIds(orderLinesInfo)),
                null,
                orderLinesInfo,
                false));
    }

    public static CreateRelatedResult createFulfillmentFromRepairOrderAndAllocate(Id repairOrderId){
        Map<Id, dmpl__InventoryFulfillment__c> fulfilments = createFulfillmentFromRepairOrderInternal(
                queryRepairOrderLines(
                    new List<Id> {repairOrderId}, 
                    null), 
                null,
                null,
                true);
        allocateLines(fulfilments.values());
        return CreateRelatedResult.InitFrom(fulfilments);
    }

    public static CreateRelatedResult createNewFulfillmentFromRepairOrderAndAllocate(Id repairOrderId){
        Map<Id, dmpl__InventoryFulfillment__c> fulfilments = createFulfillmentFromRepairOrderInternal(
                queryRepairOrderLines(
                    new List<Id> {repairOrderId}, 
                    null), 
                null,
                null,
                false);
        allocateLines(fulfilments.values());
        return CreateRelatedResult.InitFrom(fulfilments);
    }

    public static CreateRelatedResult createFulfillmentFromRepairOrderAndAllocate(List<dmpl__RepairOrder__c> repairOrders){
        Map<Id, dmpl__InventoryFulfillment__c> fulfilments = createFulfillmentFromRepairOrderInternal(
                queryRepairOrderLines(
                    DocumentHelper.extractIds(repairOrders), 
                    null), 
                null,
                null,
                false);
        allocateLines(fulfilments.values());
        return CreateRelatedResult.InitFrom(fulfilments);
    }

    public static CreateRelatedResult createFulfillmentFromRepairOrderAndAllocate(
        List<SourceObjectInfo> orderLinesInfo){
            Map<Id, dmpl__InventoryFulfillment__c> fulfilments = createFulfillmentFromRepairOrderInternal(
                    queryRepairOrderLines(
                        (List<Id>)null, 
                        SourceObjectInfo.extractIds(orderLinesInfo)),
                    null,
                    orderLinesInfo,
                    true);
        allocateLines(fulfilments.values());
        return CreateRelatedResult.InitFrom(fulfilments);
    }

    public static CreateRelatedResult createNewFulfillmentFromRepairOrderAndAllocate(
        List<SourceObjectInfo> orderLinesInfo){
            Map<Id, dmpl__InventoryFulfillment__c> fulfilments = createFulfillmentFromRepairOrderInternal(
                    queryRepairOrderLines(
                        (List<Id>)null, 
                        SourceObjectInfo.extractIds(orderLinesInfo)),
                    null,
                    null,
                    false);
        allocateLines(fulfilments.values());
        return CreateRelatedResult.InitFrom(fulfilments);
    }

    public static CreateRelatedResult createFulfillmentFromRepairOrderAndAllocate(
        List<SourceObjectInfo> orderLinesInfo, 
        Id fulfillmentDocumentId){
            Map<Id, dmpl__InventoryFulfillment__c> fulfilments =  createFulfillmentFromRepairOrderInternal(
                    queryRepairOrderLines(
                        (List<Id>)null, 
                        SourceObjectInfo.extractIds(orderLinesInfo)),
                    queryFulfillmentDocument(fulfillmentDocumentId),
                    null,
                    false);
        allocateLines(fulfilments.values());
        return CreateRelatedResult.InitFrom(fulfilments);
    }

    public static void allocateLines(List<dmpl__InventoryFulfillment__c> inventoryFulfillments){
        InventoryFulfillmentAllocationLineHelper.createAllocationFromFulfillment(
            inventoryFulfillments);
        SecurityHelper.ensureCanWriteField(
            'dmpl__PerformAllocation__c', 
            'dmpl__InventoryFulfillment__c');
        SecurityHelper.ensureCanWriteField(
            'dmpl__IsAllocated__c', 
            'dmpl__InventoryFulfillment__c');
        for(dmpl__InventoryFulfillment__c inventoryFulfillment : inventoryFulfillments){
            inventoryFulfillment.dmpl__PerformAllocation__c = false;
            inventoryFulfillment.dmpl__IsAllocated__c = true;
        }
    }

    public static void pickLines(List<dmpl__InventoryFulfillment__c> inventoryFulfillments){
        InventoryFulfillmentPickingLineHelper.createPickingFromFulfillment(
            inventoryFulfillments);
        SecurityHelper.ensureCanWriteField(
            'dmpl__PerformPicking__c', 
            'dmpl__InventoryFulfillment__c');
        SecurityHelper.ensureCanWriteField(
            'dmpl__IsPicked__c', 
            'dmpl__InventoryFulfillment__c');
        for(dmpl__InventoryFulfillment__c inventoryFulfillment : inventoryFulfillments){
            inventoryFulfillment.dmpl__PerformPicking__c = false;
            inventoryFulfillment.dmpl__IsPicked__c = true;
        }
    }

    public static CreateRelatedResult cancelAllocation(Id inventoryFulfillmentId){
        return InventoryFulfillmentAllocationLineHelper.cancelAllocationFromFulfillment(inventoryFulfillmentId);
    }

    public static void cancelAllocation(List<dmpl__InventoryFulfillment__c> inventoryFulfillments){
        InventoryFulfillmentAllocationLineHelper.cancelAllocationFromFulfillment(inventoryFulfillments);
        SecurityHelper.ensureCanWriteField(
            'dmpl__PerformCancelAllocation__c', 
            'dmpl__InventoryFulfillment__c');
        for(dmpl__InventoryFulfillment__c inventoryFulfillment : inventoryFulfillments){
            inventoryFulfillment.dmpl__PerformCancelAllocation__c = false;
        }
    }

    public static CreateRelatedResult cancelAllocation(List<SourceObjectInfo> orderLinesInfo){
        if(orderLinesInfo == null || orderLinesInfo.size() ==0){
            return null;
        }
        return InventoryFulfillmentAllocationLineHelper.cancelAllocationFromFulfillment(orderLinesInfo);
    }

    public static CreateRelatedResult cancelPicking(Id inventoryFulfillmentId){
        return InventoryFulfillmentPickingLineHelper.cancelPickingFromFulfillment(inventoryFulfillmentId);
    }

    public static void cancelPicking(List<dmpl__InventoryFulfillment__c> inventoryFulfillments){
        InventoryFulfillmentPickingLineHelper.cancelPickingFromFulfillment(inventoryFulfillments);
        SecurityHelper.ensureCanWriteField(
            'dmpl__PerformCancelPicking__c', 
            'dmpl__InventoryFulfillment__c');
        for(dmpl__InventoryFulfillment__c inventoryFulfillment : inventoryFulfillments){
            inventoryFulfillment.dmpl__PerformCancelPicking__c = false;
        }
    }

    public static CreateRelatedResult cancelPicking(List<SourceObjectInfo> orderLinesInfo){
        if(orderLinesInfo == null || orderLinesInfo.size() ==0){
            return null;
        }
        return InventoryFulfillmentPickingLineHelper.cancelPickingFromFulfillment(orderLinesInfo);
    }

    /************************************************************************************************
     * Private Scope Functions
     ************************************************************************************************/
    
    private static Map<Id, dmpl__InventoryFulfillment__c> createFulfillmentFromSaleOrderInternal(
        List<dmpl__SaleOrderLine__c> saleOrderLines,
        dmpl__InventoryFulfillment__c existingDocument,
        List<SourceObjectInfo> orderLinesInfo){
        if(saleOrderLines.size() == 0){
            throw new DMPLException(
                String.format(
                    String.valueOf(System.Label.Generic_EmptyActionParam), 
                    new String[]{
                        dmpl__SaleOrderLine__c.class.getName()}));
        }

        Map<Id, dmpl__InventoryFulfillment__c> fulfillmentDocuments = new Map<Id,dmpl__InventoryFulfillment__c>();
        Map<Id, List<dmpl__InventoryFulfillmentOrderLine__c>> fulfillmentOrderLines = new Map<Id, List<dmpl__InventoryFulfillmentOrderLine__c>>();
        if(existingDocument != null){
            fulfillmentDocuments.put(saleOrderLines[0].dmpl__SaleOrderId__c, existingDocument);
        }
        for(dmpl__SaleOrderLine__c saleOrderLine : saleOrderLines){
            if(saleOrderLine.dmpl__ItemId__r != null 
                && saleOrderLine.dmpl__ItemId__r.dmpl__TrackInventory__c
                && saleOrderLine.dmpl__PendingFulfilmentOrderQuantity__c>0){

                SourceObjectInfo objectInfo = SourceObjectInfo.getSourceObjectInfo(orderLinesInfo, saleOrderLine.Id);
                dmpl__InventoryFulfillment__c fulfillmentDocument = null;
                if(fulfillmentDocuments.containsKey(saleOrderLine.dmpl__SaleOrderId__c)){
                    fulfillmentDocument = fulfillmentDocuments.get(saleOrderLine.dmpl__SaleOrderId__c);
                }else if(objectInfo!=null){
                    fulfillmentDocument = queryFulfillmentDocument(
                        objectInfo.getDestinationObjectId(
                            saleOrderLine.dmpl__SaleOrderId__c));
                }
                if(fulfillmentDocument == null){
                    fulfillmentDocument = createFulfillmentDocumentFromSaleOrder(saleOrderLine);
                }
                if(!fulfillmentDocuments.containsKey(saleOrderLine.dmpl__SaleOrderId__c)){
                    fulfillmentDocuments.put(
                        saleOrderLine.dmpl__SaleOrderId__c, 
                        fulfillmentDocument);
                }
                if(!fulfillmentOrderLines.containsKey(saleOrderLine.dmpl__SaleOrderId__c)){
                    fulfillmentOrderLines.put(
                        saleOrderLine.dmpl__SaleOrderId__c, 
                        new List<dmpl__InventoryFulfillmentOrderLine__c>());
                }
                fulfillmentOrderLines.get(
                    saleOrderLine.dmpl__SaleOrderId__c).add(
                        createFulfillmentOrderLineFromSaleOrderLine(
                            saleOrderLine,
                            orderLinesInfo));
            }
        }
        //
        if(fulfillmentOrderLines.size() >0){
            Savepoint sp = Database.setSavepoint();
            try {
                SecurityHelper.ensureCanCreateObject('dmpl__InventoryFulfillment__c');
                SecurityHelper.ensureCanCreateFields(new string[]
                {
                    'dmpl__SaleOrderId__c',
                    'dmpl__BranchId__c',
                    'dmpl__PartnerAccountId__c',
                    'dmpl__DocumentDate__c',
                    'dmpl__AccountId__c'
                }, 'dmpl__InventoryFulfillment__c');

                upsert fulfillmentDocuments.values();
                List<dmpl__InventoryFulfillmentOrderLine__c> linesToInsert = new List<dmpl__InventoryFulfillmentOrderLine__c>();
                for(Id soId : fulfillmentDocuments.keySet()){
                    dmpl__InventoryFulfillment__c fulfillmentDocument = fulfillmentDocuments.get(soId);
                    List<dmpl__InventoryFulfillmentOrderLine__c> docLines = fulfillmentOrderLines.get(soId);
                    for(dmpl__InventoryFulfillmentOrderLine__c fulfillmentOrderLine : docLines){
                        fulfillmentOrderLine.dmpl__FulfillmentId__c = fulfillmentDocument.Id;
                        linesToInsert.add(fulfillmentOrderLine);
                    }    
                }
                
                SecurityHelper.ensureCanCreateObject('dmpl__InventoryFulfillmentOrderLine__c');
                SecurityHelper.ensureCanCreateFields(new string[]
                {
                    'dmpl__SaleOrderLineId__c',
                    'dmpl__ItemId__c',
                    'dmpl__SKUId__c',
                    'dmpl__Quantity__c'
                }, 'dmpl__InventoryFulfillmentOrderLine__c');

                insert linesToInsert;
            } catch (Exception e) {
                Database.rollback(sp);
                throw e;
            }
        }

        return fulfillmentDocuments;
    }

    @testVisible
    private static Map<Id, dmpl__InventoryFulfillment__c> createFulfillmentFromRepairOrderInternal(
        List<dmpl__RepairOrderLine__c> repairOrderLines,
        dmpl__InventoryFulfillment__c existingDocument,
        List<SourceObjectInfo> orderLinesInfo,
        Boolean addToExisting){
        if(repairOrderLines.size() == 0){
            throw new DMPLException(
                String.format(
                    String.valueOf(System.Label.Generic_EmptyActionParam), 
                    new String[]{
                        dmpl__RepairOrderLine__c.class.getName()}));
        }

        Map<Id, dmpl__InventoryFulfillment__c> fulfillmentDocuments = new Map<Id,dmpl__InventoryFulfillment__c>();
        Map<Id, List<dmpl__InventoryFulfillmentOrderLine__c>> fulfillmentOrderLines = new Map<Id, List<dmpl__InventoryFulfillmentOrderLine__c>>();
        if(addToExisting){
            List<dmpl__RepairOrder__c> repairOrdersList = queryRepairOrders(
                DocumentHelper.extractIds(repairOrderLines, 'dmpl__RepairOrderId__c'));
            for(dmpl__RepairOrder__c repairOrder : repairOrdersList){
                if(!fulfillmentDocuments.containsKey(repairOrder.Id) 
                    && repairOrder.Fulfillments__r!=null 
                    && repairOrder.Fulfillments__r.size()>0){
                        fulfillmentDocuments.put(repairOrder.Id, repairOrder.Fulfillments__r[repairOrder.Fulfillments__r.size()-1]);
                }
            }    
        }

        if(existingDocument!=null){ 
            if(fulfillmentDocuments.containsKey(existingDocument.dmpl__RepairOrderId__c)){
                fulfillmentDocuments.remove(existingDocument.dmpl__RepairOrderId__c);
            }
            fulfillmentDocuments.put(existingDocument.dmpl__RepairOrderId__c, existingDocument);
        }
        for(dmpl__RepairOrderLine__c repairOrderLine : repairOrderLines){
            if(repairOrderLine.dmpl__ItemId__r !=null 
                && repairOrderLine.dmpl__ItemId__r.dmpl__TrackInventory__c
                && repairOrderLine.dmpl__PendingFulfilmentOrderQuantity__c>0){

                dmpl__InventoryFulfillment__c fulfillmentDocument = null;
                SourceObjectInfo objectInfo = SourceObjectInfo.getSourceObjectInfo(orderLinesInfo, repairOrderLine.Id);
                if(fulfillmentDocuments.containsKey(repairOrderLine.dmpl__RepairOrderId__c)){
                    fulfillmentDocument = fulfillmentDocuments.get(repairOrderLine.dmpl__RepairOrderId__c);
                }else if(objectInfo !=null){
                    fulfillmentDocument = queryFulfillmentDocument(
                        objectInfo.getDestinationObjectId(
                            repairOrderLine.Id));
                }
                
                if(fulfillmentDocument == null){
                    fulfillmentDocument = createFulfillmentDocumentFromRepairOrder(repairOrderLine);
                }
                if(!fulfillmentDocuments.containsKey(repairOrderLine.dmpl__RepairOrderId__c)){
                    fulfillmentDocuments.put(
                            repairOrderLine.dmpl__RepairOrderId__c, 
                            fulfillmentDocument);
                        }
                if(!fulfillmentOrderLines.containsKey(repairOrderLine.dmpl__RepairOrderId__c)){
                    fulfillmentOrderLines.put(repairOrderLine.dmpl__RepairOrderId__c, 
                        new List<dmpl__InventoryFulfillmentOrderLine__c>());
                }

                fulfillmentOrderLines.get(
                    repairOrderLine.dmpl__RepairOrderId__c).add(
                        createFulfillmentOrderLineFromRepairOrderLine(
                            repairOrderLine,
                            orderLinesInfo));
            }
        }
        //
        if(fulfillmentOrderLines.size() >0){
            Savepoint sp = Database.setSavepoint();
            try {
                SecurityHelper.ensureCanCreateObject('dmpl__InventoryFulfillment__c');
                SecurityHelper.ensureCanCreateFields(new string[]
                {
                    'dmpl__RepairOrderId__c',
                    'dmpl__BranchId__c',
                    'dmpl__PartnerAccountId__c',
                    'dmpl__DocumentDate__c',
                    'dmpl__AccountId__c'
                }, 'dmpl__InventoryFulfillment__c');

                upsert fulfillmentDocuments.values();
                List<dmpl__InventoryFulfillmentOrderLine__c> linesToInsert = new List<dmpl__InventoryFulfillmentOrderLine__c>();
                for(Id soId : fulfillmentDocuments.keySet()){
                    dmpl__InventoryFulfillment__c fulfillmentDocument = fulfillmentDocuments.get(soId);
                    List<dmpl__InventoryFulfillmentOrderLine__c> docLines = fulfillmentOrderLines.get(soId);
                    for(dmpl__InventoryFulfillmentOrderLine__c fulfillmentOrderLine : docLines){
                        fulfillmentOrderLine.dmpl__FulfillmentId__c = fulfillmentDocument.Id;
                        linesToInsert.add(fulfillmentOrderLine);
                    }    
                }
                
                SecurityHelper.ensureCanCreateObject('dmpl__InventoryFulfillmentOrderLine__c');
                SecurityHelper.ensureCanCreateFields(new string[]
                {
                    'dmpl__RepairOrderLineId__c',
                    'dmpl__ItemId__c',
                    'dmpl__SKUId__c',
                    'dmpl__Quantity__c'
                }, 'dmpl__InventoryFulfillmentOrderLine__c');

                insert linesToInsert;
            } catch (Exception e) {
                Database.rollback(sp);
                throw e;
            }
        }

        return fulfillmentDocuments;
    }

    private static dmpl__InventoryFulfillment__c createFulfillmentDocumentFromSaleOrder(dmpl__SaleOrderLine__c saleOrderLine){
        return new dmpl__InventoryFulfillment__c(
            dmpl__SaleOrderId__c = saleOrderLine.dmpl__SaleOrderId__c,
            dmpl__BranchId__c = saleOrderLine.dmpl__SaleOrderId__r.dmpl__BranchId__c,
            dmpl__PartnerAccountId__c = saleOrderLine.dmpl__SaleOrderId__r.dmpl__PartnerAccountId__c,
            dmpl__DocumentDate__c = saleOrderLine.dmpl__SaleOrderId__r.dmpl__DocumentDate__c,
            dmpl__AccountId__c = saleOrderLine.dmpl__SaleOrderId__r.dmpl__AccountId__c
        );
    }

    @testVisible
    private static dmpl__InventoryFulfillment__c createFulfillmentDocumentFromRepairOrder(dmpl__RepairOrderLine__c repairOrderLine){
        return new dmpl__InventoryFulfillment__c(
            dmpl__RepairOrderId__c = repairOrderLine.dmpl__RepairOrderId__c,
            dmpl__BranchId__c = repairOrderLine.dmpl__RepairOrderId__r.dmpl__BranchId__c,
            dmpl__PartnerAccountId__c = repairOrderLine.dmpl__RepairOrderId__r.dmpl__PartnerAccountId__c,
            dmpl__DocumentDate__c = repairOrderLine.dmpl__RepairOrderId__r.dmpl__DocumentDate__c,
            dmpl__AccountId__c = repairOrderLine.dmpl__RepairOrderId__r.dmpl__AccountId__c
        );
    }

    private static dmpl__InventoryFulfillmentOrderLine__c createFulfillmentOrderLineFromSaleOrderLine(
        dmpl__SaleOrderLine__c saleOrderLine,
        List<SourceObjectInfo> orderLinesInfo){
        Decimal requestedQty = SourceObjectInfo.getRequestedQuantity(orderLinesInfo, saleOrderLine.Id);
        return new dmpl__InventoryFulfillmentOrderLine__c(
            dmpl__SaleOrderLineId__c = saleOrderLine.Id,
            dmpl__ItemId__c = saleOrderLine.dmpl__ItemId__c,
            dmpl__SKUId__c = saleOrderLine.dmpl__SKUId__c,
            dmpl__Quantity__c = requestedQty >0 ? requestedQty : saleOrderLine.dmpl__PendingFulfilmentOrderQuantity__c,
            dmpl__ItemLotTypeId__c = saleOrderLine.dmpl__ItemLotTypeId__c,
            dmpl__LimitExpiryDays__c = saleOrderLine.dmpl__LimitExpiryDays__c
        );
    }

    @testVisible
    private static dmpl__InventoryFulfillmentOrderLine__c createFulfillmentOrderLineFromRepairOrderLine(
        dmpl__RepairOrderLine__c repairOrderLine,
        List<SourceObjectInfo> orderLinesInfo){
        Decimal requestedQty = SourceObjectInfo.getRequestedQuantity(orderLinesInfo, repairOrderLine.Id);
        return new dmpl__InventoryFulfillmentOrderLine__c(
            dmpl__RepairOrderLineId__c = repairOrderLine.Id,
            dmpl__ItemId__c = repairOrderLine.dmpl__ItemId__c,
            dmpl__SKUId__c = repairOrderLine.dmpl__SKUId__c,
            dmpl__Quantity__c = requestedQty > 0 ? requestedQty : repairOrderLine.dmpl__PendingFulfilmentOrderQuantity__c
        );
    }


    /************************************************************************************************
     * Private Scope Database Queries 
     ************************************************************************************************/
    private static List<dmpl__SaleOrderLine__c> querySaleOrderLines(
        List<Id> saleOrderIds, 
        List<Id> saleOrderLineIds)
    {
        if(saleOrderLineIds == null){
            saleOrderLineIds = new List<Id>();
        }
        if(saleOrderIds == null){
            saleOrderIds = new List<Id>();
        }
         SecurityHelper.ensureCanReadFields(new string[]
         {
            'dmpl__TrackInventory__c'
        }, 'dmpl__Item__c');
         SecurityHelper.ensureCanReadFields(new string[]
         {
            'dmpl__PartnerAccountId__c',
            'dmpl__BranchId__c,',
            'dmpl__AccountId__c',
            'dmpl__DocumentDate__c'
        }, 'dmpl__SaleOrder__c');
         SecurityHelper.ensureCanReadFields(new string[]
         {
            'dmpl__ItemId__c',
            'dmpl__ItemLotTypeId__c',
            'dmpl__LimitExpiryDays__c',
            'dmpl__SaleOrderId__c',
            'dmpl__SKUId__c',
            'dmpl__UnitPrice__c',
            'dmpl__UnitPrice2__c',
            'dmpl__Quantity__c',
            'dmpl__PendingFulfilmentOrderQuantity__c'
        }, 'dmpl__SaleOrderLine__c');
        return [SELECT Id,
            Name,
            dmpl__ItemId__c,
            dmpl__SKUId__c,
            dmpl__UnitPrice__c,
            dmpl__UnitPrice2__c,
            dmpl__Quantity__c,
            dmpl__PendingFulfilmentOrderQuantity__c,
            dmpl__ItemId__r.dmpl__TrackInventory__c,
            dmpl__ItemLotTypeId__c,
            dmpl__LimitExpiryDays__c,
            dmpl__SaleOrderId__c,
            dmpl__SaleOrderId__r.dmpl__PartnerAccountId__c,
            dmpl__SaleOrderId__r.dmpl__BranchId__c,
            dmpl__SaleOrderId__r.dmpl__AccountId__c,
            dmpl__SaleOrderId__r.dmpl__DocumentDate__c
        FROM dmpl__SaleOrderLine__c
        WHERE dmpl__SaleOrderId__c IN :saleOrderIds OR Id IN :saleOrderLineIds
        ];
    }

    private static List<dmpl__RepairOrderLine__c> queryRepairOrderLines(
        List<Id> repairOrderIds, 
        List<Id> repairOrderLineIds)
    {
        if(repairOrderLineIds == null){
            repairOrderLineIds = new List<Id>();
        }
        if(repairOrderIds == null){
            repairOrderIds = new List<Id>();
        }
         SecurityHelper.ensureCanReadFields(new string[]
         {
            'dmpl__TrackInventory__c'
        }, 'dmpl__Item__c');
         SecurityHelper.ensureCanReadFields(new string[]
         {
            'dmpl__PartnerAccountId__c',
            'dmpl__BranchId__c,',
            'dmpl__AccountId__c',
            'dmpl__DocumentDate__c'
        }, 'dmpl__RepairOrder__c');
         SecurityHelper.ensureCanReadFields(new string[]
         {
            'dmpl__ItemId__c',
            'dmpl__SaleOrderId__c',
            'dmpl__SKUId__c',
            'dmpl__UnitPrice__c',
            'dmpl__UnitPrice2__c',
            'dmpl__Quantity__c',
            'dmpl__PendingFulfilmentOrderQuantity__c'
        }, 'dmpl__RepairOrderLine__c');
        return [SELECT Id,
            Name,
            dmpl__ItemId__c,
            dmpl__SKUId__c,
            dmpl__UnitPrice__c,
            dmpl__UnitPrice2__c,
            dmpl__Quantity__c,
            dmpl__PendingFulfilmentOrderQuantity__c,
            dmpl__ItemId__r.dmpl__TrackInventory__c,
            dmpl__RepairOrderId__c,
            dmpl__RepairOrderId__r.dmpl__PartnerAccountId__c,
            dmpl__RepairOrderId__r.dmpl__BranchId__c,
            dmpl__RepairOrderId__r.dmpl__AccountId__c,
            dmpl__RepairOrderId__r.dmpl__DocumentDate__c
        FROM dmpl__RepairOrderLine__c
        WHERE (dmpl__RepairOrderId__c IN :repairOrderIds OR Id IN :repairOrderLineIds)
        AND dmpl__PendingFulfilmentOrderQuantity__c > 0
        ];
    }

    private static List<Id> queryTransactedObjectIds(List<dmpl__InventoryFulfillment__c> newEntries){
        SecurityHelper.ensureCanReadFields(new string[]
        {
            'dmpl__FulfillmentId__c'
        }, 'dmpl__InventoryFulfillmentOrderLine__c');
        return DocumentHelper.extractIds([SELECT dmpl__FulfillmentId__c 
                FROM dmpl__InventoryFulfillmentOrderLine__c
                WHERE dmpl__FulfillmentId__c IN:DocumentHelper.extractIds(newEntries)], FIELD_FULFILMENTORDERLINE_FULFILMENTORDERID);
    }

    private static List<dmpl__RepairOrder__c> queryRepairOrders(List<Id> repairOrderIds)
    {
        SecurityHelper.ensureCanReadFields(new string[]
        {
           'dmpl__PartnerAccountId__c',
           'dmpl__BranchId__c,',
           'dmpl__AccountId__c',
           'dmpl__DocumentDate__c'
       }, 'dmpl__RepairOrder__c');
        return [SELECT 
        Id,
        Name,
        dmpl__BranchId__c,
        dmpl__PartnerAccountId__c,
        dmpl__DocumentDate__c,
        dmpl__AccountId__c,
        (
            SELECT Id,
            Name, 
            dmpl__ItemId__c,
            dmpl__ItemId__r.dmpl__TrackInventory__c,
            dmpl__Quantity__c
            FROM Repair_Order_Lines1__r
        ),
        (
            SELECT Id,
            Name
            FROM Fulfillments__r
        )
        FROM dmpl__RepairOrder__c
        WHERE Id IN : repairOrderIds];
    }
    
    private static dmpl__InventoryFulfillment__c queryFulfillmentDocument(Id fulfilmentId){
        if(fulfilmentId == null){
            return null;
        }
        SecurityHelper.ensureCanReadFields(new string[]
         {'dmpl__SaleOrderId__c','dmpl__RepairOrderId__c'
        }, 'dmpl__InventoryFulfillment__c');
        return [SELECT 
            Id,
            Name,
            dmpl__RepairOrderId__c,
            dmpl__SaleOrderId__c
        FROM dmpl__InventoryFulfillment__c
        WHERE Id = : fulfilmentId];
    }



    // public static CreateRelatedResult createInStockFulfillmentFromSaleOrder(Id saleOrderId){
    //     return createFulfillmentFromSaleOrder(
    //         getInStockQuantities(
    //             saleOrderId));
    // }

    // private static List<SourceObjectInfo> getInStockQuantities(Id saleOrderId){
    //     dmpl__SaleOrder__c order = [
    //         SELECT 
    //             Id,
    //             dmpl__BranchId__c,
    //             dmpl__PartnerAccountId__c,
    //             (SELECT
    //                 Id,
    //                 dmpl__ItemId__c,
    //                 dmpl__PendingFulfilmentOrderQuantity__c
    //               FROM 
    //                 dmpl__SaleOrderLines__r)
    //         FROM
    //             dmpl__SaleOrder__c
    //         WHERE
    //             Id =:saleOrderId];

    //     List<dmpl__InventoryStock__c> stocks = [
    //         SELECT 
    //             dmpl__ItemId__c,
    //             dmpl__QuantityAvailable__c
    //         FROM dmpl__InventoryStock__c
    //         WHERE 
    //             dmpl__BranchId__c = :order.dmpl__BranchId__c
    //             AND dmpl__PartnerAccountId__c = :order.dmpl__PartnerAccountId__c
    //             AND dmpl__ItemId__c IN : CollectionHelper.extractIds(
    //                 order.dmpl__SaleOrderLines__r,
    //                 'dmpl__ItemId__c')];

    //     List<SourceObjectInfo> infos = new List<SourceObjectInfo>();
    //     for(dmpl__SaleOrderLine__c line : order.dmpl__SaleOrderLines__r){
    //         dmpl__InventoryStock__c stock = (dmpl__InventoryStock__c)CollectionHelper.getObject(
    //             stocks,
    //             'dmpl__ItemId__c',
    //             line.dmpl__ItemId__c);
    //         if(stock !=null){
    //             Double fulfilmentQty = 0;
    //             if(stock.dmpl__QuantityAvailable__c>line.dmpl__PendingFulfilmentOrderQuantity__c){
    //                 fulfilmentQty = line.dmpl__PendingFulfilmentOrderQuantity__c;
    //             }else {
    //                 fulfilmentQty = stock.dmpl__QuantityAvailable__c;
    //             }
    //             infos.add(new SourceObjectInfo(
    //                 'dmpl__SaleOrderLine__c',
    //                 line.Id,
    //                 fulfilmentQty,
    //                 ''));
    //         }
    //     }
    //     return infos;
    // }
}