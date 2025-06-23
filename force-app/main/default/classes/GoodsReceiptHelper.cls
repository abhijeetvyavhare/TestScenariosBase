public with sharing class GoodsReceiptHelper {

    private static Boolean skipValidations = false;

    private static final string OBJECT_GOODSRECEIPT = 'dmpl__GoodsReceipt__c';
    private static final string FIELD_GOODSRECEIPT_BRANCHID = 'dmpl__BranchId__c';
    private static final string FIELD_GOODSRECEIPT_DOCUMENTDATE ='dmpl__DocumentDate__c';
    private static final string FIELD_GOODSRECEIPT_STATUS = 'dmpl__Status__c';
    private static final string FIELD_GOODSRECEIPT_PARTNERACCOUNTID = 'dmpl__PartnerAccountId__c';
    private static final string FIELD_GOODSRECEIPT_SUPPLIERACCOUNTID = 'dmpl__SupplierAccountId__c';
    
    private static final string FIELD_GOODSRECEIPT_ISRECEIVED ='dmpl__IsReceived__c';
    private static final string FIELD_GOODSRECEIPT_ISINSPECTED ='dmpl__IsInspected__c';
    private static final string FIELD_GOODSRECEIPT_ISINSPECTIONCOMPLETED ='dmpl__IsInspectionCompleted__c';
    private static final string FIELD_GOODSRECEIPT_ISINVOICERELEASED ='dmpl__IsInvoiceReleased__c';

    public static final string FIELD_GOODSRECEIPT_PERFORMRECEIVE ='dmpl__PerformReceive__c';
    public static final string FIELD_GOODSRECEIPT_PERFORMRECEIVEASYNC ='dmpl__PerformReceiveAsync__c';
    public static final string FIELD_GOODSRECEIPT_PERFORMINSPECTION ='dmpl__PerformInspection__c';
    public static final string FIELD_GOODSRECEIPT_PERFROMINSPECTIONCOMPLETE ='dmpl__PerformInspectionComplete__c';
    private static final string FIELD_GOODSRECEIPT_PERFORMPOPULATECHECKLIST = 'dmpl__PerformPopulateChecklist__c';
    private static final string FIELD_GOODSRECEIPT_PERFORMALLOCATION = 'dmpl__PerformAllocation__c';
    private static final string FIELD_GOODSRECEIPT_PERFORMRELEASEBILL = 'dmpl__PerformReleaseBill__c';

    private static final List<String> LIST_NON_EDITABLE_FIELDS = new List<String>{FIELD_GOODSRECEIPT_BRANCHID, FIELD_GOODSRECEIPT_DOCUMENTDATE, FIELD_GOODSRECEIPT_PARTNERACCOUNTID, FIELD_GOODSRECEIPT_SUPPLIERACCOUNTID};
    private static final List<String> LIST_FIELDS_SYSTEM = new List<String>{FIELD_GOODSRECEIPT_ISRECEIVED, FIELD_GOODSRECEIPT_ISINSPECTED};

    public void validateData(Boolean isInsert, Boolean isUpdate, Boolean isDelete, List<dmpl__GoodsReceipt__c> oldEntries, List<dmpl__GoodsReceipt__c> newEntries)
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
            StatusHelper.validateStatusNew(OBJECT_GOODSRECEIPT, FIELD_GOODSRECEIPT_STATUS, newEntries);
            DocumentHelper.validateChangeInSystemFields(LIST_FIELDS_SYSTEM, newEntries);
            ValidationHelper.validatePartnerAndBranch(FIELD_GOODSRECEIPT_PARTNERACCOUNTID, FIELD_GOODSRECEIPT_BRANCHID, newEntries);
        }else if(isUpdate){
            StatusHelper.validateStatusEdit(OBJECT_GOODSRECEIPT, FIELD_GOODSRECEIPT_STATUS, oldEntries, newEntries);
            DocumentHelper.validateChangeInKeyFields(LIST_NON_EDITABLE_FIELDS, oldEntries, newEntries);
            DocumentHelper.validateChangeInSystemFields(LIST_FIELDS_SYSTEM, oldEntries, newEntries);
            dfsHelper.DocumentStatusRestrictEdits_Edit(OBJECT_GOODSRECEIPT, FIELD_GOODSRECEIPT_STATUS, oldEntries, newEntries);
            dfsHelper.DocumentStatusRestrictFieldsEdits(OBJECT_GOODSRECEIPT, FIELD_GOODSRECEIPT_STATUS, oldEntries, newEntries);
        }else if(isDelete){
            dfsHelper.DocumentStatusRestrictEdits_Delete(OBJECT_GOODSRECEIPT, FIELD_GOODSRECEIPT_STATUS, oldEntries);
        }
    } catch (Exception error) {
        ExceptionLogHelper.logException(error);
        throw error;
    }
    }

    public void postData(Boolean isInsert, Boolean isUpdate, Boolean isDelete, List<dmpl__GoodsReceipt__c> oldEntries, List<dmpl__GoodsReceipt__c> newEntries)
    {
        try{
            DocumentStatusDFSHelper dfsHelper = new DocumentStatusDFSHelper();
            if(isInsert)
    		    DocumentNameHelper.generateDocumentName(newEntries);
            
            if (isUpdate) {

                dfsHelper.DocumentStatusSetFlag(OBJECT_GOODSRECEIPT, FIELD_GOODSRECEIPT_STATUS, oldEntries, newEntries);
                dfsHelper.DocumentStatusReSetFlag(OBJECT_GOODSRECEIPT, FIELD_GOODSRECEIPT_STATUS, oldEntries, newEntries);
                List<dmpl__GoodsReceipt__c> modifiedObjects = new List<dmpl__GoodsReceipt__c>();

                modifiedObjects = DocumentHelper.getApprovedObjects(FIELD_GOODSRECEIPT_PERFORMRECEIVE, oldEntries, newEntries);
                if(modifiedObjects.size()>0){
                    receiveGoodsReceiptLines(modifiedObjects);
                }

                modifiedObjects = DocumentHelper.getApprovedObjects(FIELD_GOODSRECEIPT_PERFORMINSPECTION, oldEntries, newEntries);
                if(modifiedObjects.size()>0){
                    createInspectionLines(modifiedObjects);
                }

                modifiedObjects = DocumentHelper.getApprovedObjects(FIELD_GOODSRECEIPT_PERFROMINSPECTIONCOMPLETE, oldEntries, newEntries);
                if(modifiedObjects.size()>0){
                    completeInspection(modifiedObjects);
                }

                modifiedObjects = DocumentHelper.getApprovedObjects(FIELD_GOODSRECEIPT_PERFORMPOPULATECHECKLIST, oldEntries, newEntries);
                if(modifiedObjects.size()>0){
                    populateChecklistDetails(modifiedObjects);
                }

                modifiedObjects = DocumentHelper.getApprovedObjects(FIELD_GOODSRECEIPT_PERFORMALLOCATION, oldEntries, newEntries);
                if(modifiedObjects.size()>0){
                    performAllocation(modifiedObjects);
                }

                modifiedObjects = DocumentHelper.getApprovedObjects(FIELD_GOODSRECEIPT_PERFORMRELEASEBILL, oldEntries, newEntries);
                if(modifiedObjects.size()>0){
                    performReleaseBill(modifiedObjects);
                }

                modifiedObjects = DocumentHelper.getApprovedObjects(FIELD_GOODSRECEIPT_PERFORMRECEIVEASYNC, oldEntries, newEntries);
                if(modifiedObjects.size()>0){
                    receiveGoodsReceiptLinesAsync(modifiedObjects);
                }
            }
        } catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }
   
    public static CreateRelatedResult postIL(Id goodsReceiptId){
        return GoodReceiptLineHelper.postIL(goodsReceiptId);
    }
 
     public static CreateRelatedResult postIL(List<SourceObjectInfo> orderLinesInfo, Id goodsReceiptId){
        return GoodReceiptLineHelper.postIL(orderLinesInfo, goodsReceiptId);
    }

    public static void receiveGoodsReceiptLines(List<dmpl__GoodsReceipt__c> lineEntries){
        GoodReceiptLineHelper.receiveReceiptLinesFromGoodsReceipt(lineEntries);
        SecurityHelper.ensureCanWriteField('dmpl__PerformReceive__c', 'dmpl__GoodsReceipt__c');
        SecurityHelper.ensureCanWriteField('dmpl__IsReceived__c', 'dmpl__GoodsReceipt__c');
        for(dmpl__GoodsReceipt__c lineEntry : lineEntries){
            lineEntry.dmpl__PerformReceive__c = false;
            lineEntry.dmpl__IsReceived__c = true;    
        }
    }

    public static void receiveGoodsReceiptLinesAsync(List<dmpl__GoodsReceipt__c> lineEntries){
        createInterfaceQueue(DocumentHelper.extractIds(lineEntries));
        SecurityHelper.ensureCanWriteField('dmpl__PerformReceiveAsync__c', 'dmpl__GoodsReceipt__c');
        SecurityHelper.ensureCanWriteField('dmpl__IsReceived__c', 'dmpl__GoodsReceipt__c');
        for(dmpl__GoodsReceipt__c lineEntry : lineEntries){
            lineEntry.dmpl__PerformReceiveAsync__c = false;
            lineEntry.dmpl__IsReceived__c = true;    
        }
    }
    
    public static Map<Id, dmpl__InspectionLine__c> createInspectionLines(List<dmpl__GoodsReceipt__c> goodsReceipts){
        Map<Id, dmpl__InspectionLine__c> result = InspectionLineHelper.createInspectionLinesFromGoodsReceipt(goodsReceipts);
        SecurityHelper.ensureCanWriteField('dmpl__PerformInspection__c', 'dmpl__GoodsReceipt__c');
        SecurityHelper.ensureCanWriteField('dmpl__IsInspected__c', 'dmpl__GoodsReceipt__c');
        for(dmpl__GoodsReceipt__c lineEntry : goodsReceipts){
            lineEntry.dmpl__PerformInspection__c = false;
            lineEntry.dmpl__IsInspected__c = true;    
        }
        return result;
    }

    public static Map<Id, dmpl__InspectionLine__c> createInspectionLines(List<dmpl__GoodsReceiptLine__c> goodsReceiptLines, List<SourceObjectInfo> goodsReceiptLinesInfo){
        Map<Id, dmpl__InspectionLine__c> result = InspectionLineHelper.createInspectionLinesFromGoodsReceiptLine(goodsReceiptLines, goodsReceiptLinesInfo);
        SecurityHelper.ensureCanWriteField('dmpl__PerformInspection__c', 'dmpl__GoodsReceipt__c');
        SecurityHelper.ensureCanWriteField('dmpl__IsInspected__c', 'dmpl__GoodsReceipt__c');
        // for(dmpl__GoodsReceipt__c lineEntry : goodsReceipts){
        //     lineEntry.dmpl__PerformInspection__c = false;
        //     lineEntry.dmpl__IsInspected__c = true;    
        // }
        return result;
    }

    public static CreateRelatedResult createInspectionLines(Id goodsReceiptId){
        return CreateRelatedResult.InitFrom(createInspectionLines(queryGoodsReceipts(New List<Id>{goodsReceiptId})));
    }

    public static CreateRelatedResult createInspectionLines(List<SourceObjectInfo> goodsReceiptLinesInfo){
        return CreateRelatedResult.InitFrom(createInspectionLines(queryGoodsReceiptLines(new List<Id>(), SourceObjectInfo.extractIds(goodsReceiptLinesInfo)), goodsReceiptLinesInfo));
    }

    public static Map<Id, dmpl__InspectionLine__c> completeInspection(List<dmpl__GoodsReceipt__c> goodsReceipts){
        Map<Id, dmpl__InspectionLine__c> result = InspectionLineHelper.completeInspectionFromGoodsReceipt(goodsReceipts);
        SecurityHelper.ensureCanWriteField('dmpl__PerformInspectionComplete__c', 'dmpl__GoodsReceipt__c');
        SecurityHelper.ensureCanWriteField('dmpl__IsInspectionCompleted__c', 'dmpl__GoodsReceipt__c');
        for(dmpl__GoodsReceipt__c lineEntry : goodsReceipts){
            lineEntry.dmpl__PerformInspectionComplete__c = false;
            lineEntry.dmpl__IsInspectionCompleted__c = true;    
        }
        return result;
    }

    public static CreateRelatedResult completeInspection(Id goodsReceiptId){
        return CreateRelatedResult.InitFrom(completeInspection(queryGoodsReceipts(New List<Id>{goodsReceiptId})));
    }

    public static void createGoodsReceiptFromShipment(List<dmpl__Shipment__c> shipments){
        createGoodsReceiptFromShipment(queryShipmentLines(DocumentHelper.extractIds(shipments), null));
    }

    public static void createGoodsReceiptFromShipment(List<SourceObjectInfo> shipmentsInfo){
        createGoodsReceiptFromShipment(queryShipmentLines(null, SourceObjectInfo.extractIds(shipmentsInfo)));
    }  

    public static void createGoodsReceiptFromPurchaseOrder(List<dmpl__PurchaseOrder__c> purchaseOrders){
        createGoodsReceiptFromPurchaseOrder(queryPurchaseOrderLines(DocumentHelper.extractIds(purchaseOrders), null));
    }

    public static void createGoodsReceiptFromPurchaseOrder(List<SourceObjectInfo> purchaseOrderInfo){
        createGoodsReceiptFromPurchaseOrder(queryPurchaseOrderLines(null, SourceObjectInfo.extractIds(purchaseOrderInfo)));
    } 

    public static void populateChecklistDetails(List<dmpl__GoodsReceipt__c> goodsReceipt){
        ChecklistLineHelper.createChecklistLines(goodsReceipt);
    }

    public static void performAllocation(List<dmpl__GoodsReceipt__c> goodsReceipts)
    {
        InventoryFulfillmentAllocationLineHelper.createAllocationFromGoodsReceipt(queryGoodsReceiptLines(DocumentHelper.extractIds(goodsReceipts), new List<Id>()));
        for(dmpl__GoodsReceipt__c goodsReceipt : goodsReceipts)
        {
            goodsReceipt.dmpl__PerformAllocation__c = false;
            goodsReceipt.dmpl__IsAllocated__c = true;   
        }
    }

    public static void performReleaseBill(List<dmpl__GoodsReceipt__c> goodsReceipts)
    {
        BillHelper.createBillFromGoodsReceipt(goodsReceipts);
        for(dmpl__GoodsReceipt__c goodsReceipt : goodsReceipts)
        {
            goodsReceipt.dmpl__PerformReleaseBill__c = false;
            goodsReceipt.dmpl__IsBillGenerated__c = true;   
        }
    }

    public static void updateIsClaimedFromClaim(List<Id> goodsReceiptIds, Boolean isClaimed)
    {
        try{
            skipValidations = true;
            SecurityHelper.ensureCanReadFields(new string[]{'dmpl__IsClaimed__c'}, 'dmpl__GoodsReceipt__c');
            List<dmpl__GoodsReceipt__c> goodsReceipts = 
                [SELECT Id, dmpl__IsClaimed__c
                FROM dmpl__GoodsReceipt__c
                WHERE Id IN :goodsReceiptIds];
    
            for(dmpl__GoodsReceipt__c receipt : goodsReceipts)
            receipt.dmpl__IsClaimed__c = isClaimed;

            SecurityHelper.ensureCanWriteFields(new string[]{'dmpl__IsClaimed__c'}, 'dmpl__GoodsReceipt__c');
            Update goodsReceipts;
        }finally{
            skipValidations = false;
        }
    }

    private static void createGoodsReceiptFromShipment(List<dmpl__ShipmentLine__c> shipmentLines)
    {
        if(shipmentLines.size() == 0){
            throw new DMPLException(String.format(String.valueOf(System.Label.Generic_EmptyActionParam), new String[]{dmpl__ShipmentLine__c.class.getName()}));
        }

        Map<Id, dmpl__GoodsReceipt__c> receiptDocuments = new Map<Id,dmpl__GoodsReceipt__c>();
        Map<Id, List<dmpl__GoodsReceiptLine__c>> receiptLines = new Map<Id, List<dmpl__GoodsReceiptLine__c>>();
        for(dmpl__ShipmentLine__c shipmentLine : shipmentLines){
            if(shipmentLine.dmpl__ItemId__c !=null ){

                dmpl__GoodsReceipt__c receiptDocument = null;
                if(receiptDocuments.containsKey(shipmentLine.dmpl__ShipmentId__c)){
                    receiptDocument = receiptDocuments.get(shipmentLine.dmpl__ShipmentId__c);
                }else {
                    receiptDocument = createReceiptDocumentFromShipment(shipmentLine);
                    receiptDocuments.put(shipmentLine.dmpl__ShipmentId__c, receiptDocument);
                    receiptLines.put(shipmentLine.dmpl__ShipmentId__c, new List<dmpl__GoodsReceiptLine__c>());
                }
                receiptLines.get(shipmentLine.dmpl__ShipmentId__c).add(createReceiptLineFromShipmentLine(shipmentLine));
            }
        }
        //
        if(receiptLines.size() >0){
            Savepoint sp = Database.setSavepoint();
            try {
                SecurityHelper.ensureCanCreateObject('dmpl__GoodsReceipt__c');
                SecurityHelper.ensureCanCreateFields(new string[]{'dmpl__BranchId__c','dmpl__PartnerAccountId__c','dmpl__SupplierAccountId__c','dmpl__SupplierInvoiceDate__c','dmpl__SupplierInvoiceNumber__c','dmpl__TransporterName__c','dmpl__TransporterRefrenceNumber__c'}, 'dmpl__GoodsReceipt__c');
                insert receiptDocuments.values();
                List<dmpl__GoodsReceiptLine__c> linesToInsert = new List<dmpl__GoodsReceiptLine__c>();
                for(Id receiptId : receiptDocuments.keySet()){
                    dmpl__GoodsReceipt__c receiptDocument = receiptDocuments.get(receiptId);
                    List<dmpl__GoodsReceiptLine__c> docLines = receiptLines.get(receiptId);
                    for(dmpl__GoodsReceiptLine__c receiptLine : docLines){
                        receiptLine.dmpl__GoodsReceiptId__c = receiptDocument.Id;
                        linesToInsert.add(receiptLine);
                    }    
                }
                SecurityHelper.ensureCanCreateObject('dmpl__GoodsReceiptLine__c');
                SecurityHelper.ensureCanCreateFields(new string[]{'dmpl__PurchaseOrderLineId__c','dmpl__ShipmentLineId__c','dmpl__ItemId__c','dmpl__SKUId__c','dmpl__InvoiceQuantity__c','dmpl__OrderedQuantity__c'}, 'dmpl__GoodsReceiptLine__c');
                insert linesToInsert;
            } catch (Exception e) {
                Database.rollback(sp);
                throw new DMPLException(e.getMessage());
            }
        }
    }

    private static void createGoodsReceiptFromPurchaseOrder(List<dmpl__PurchaseOrderLine__c> orderLines)
    {
        if(orderLines.size() == 0){
            throw new DMPLException(String.format(String.valueOf(System.Label.Generic_EmptyActionParam), new String[]{dmpl__PurchaseOrderLine__c.class.getName()}));
        }

        Map<Id, dmpl__GoodsReceipt__c> receiptDocuments = new Map<Id,dmpl__GoodsReceipt__c>();
        Map<Id, List<dmpl__GoodsReceiptLine__c>> receiptLines = new Map<Id, List<dmpl__GoodsReceiptLine__c>>();
        for(dmpl__PurchaseOrderLine__c orderLine : orderLines){
            if(orderLine.dmpl__ItemId__c !=null ){

                dmpl__GoodsReceipt__c receiptDocument = null;
                if(receiptDocuments.containsKey(orderLine.dmpl__PurchaseOrderId__c)){
                    receiptDocument = receiptDocuments.get(orderLine.dmpl__PurchaseOrderId__c);
                }else {
                    receiptDocument = createReceiptDocumentFromPurchaseOrder(orderLine);
                    receiptDocuments.put(orderLine.dmpl__PurchaseOrderId__c, receiptDocument);
                    receiptLines.put(orderLine.dmpl__PurchaseOrderId__c, new List<dmpl__GoodsReceiptLine__c>());
                }
                receiptLines.get(orderLine.dmpl__PurchaseOrderId__c).add(createReceiptLineFromPurchaseOrderLine(orderLine));
            }
        }
        //
        if(receiptLines.size() >0){
            Savepoint sp = Database.setSavepoint();
            try {
                SecurityHelper.ensureCanCreateObject('dmpl__GoodsReceipt__c');
                SecurityHelper.ensureCanCreateFields(new string[]{'dmpl__BranchId__c','dmpl__PartnerAccountId__c','dmpl__SupplierAccountId__c','dmpl__SupplierInvoiceDate__c','dmpl__SupplierInvoiceNumber__c','dmpl__TransporterName__c','dmpl__TransporterRefrenceNumber__c'}, 'dmpl__GoodsReceipt__c');
                insert receiptDocuments.values();
                List<dmpl__GoodsReceiptLine__c> linesToInsert = new List<dmpl__GoodsReceiptLine__c>();
                for(Id receiptId : receiptDocuments.keySet()){
                    dmpl__GoodsReceipt__c receiptDocument = receiptDocuments.get(receiptId);
                    List<dmpl__GoodsReceiptLine__c> docLines = receiptLines.get(receiptId);
                    for(dmpl__GoodsReceiptLine__c receiptLine : docLines){
                        receiptLine.dmpl__GoodsReceiptId__c = receiptDocument.Id;
                        linesToInsert.add(receiptLine);
                    }    
                }
                SecurityHelper.ensureCanCreateObject('dmpl__GoodsReceiptLine__c');
                SecurityHelper.ensureCanCreateFields(new string[]{'dmpl__PurchaseOrderLineId__c','dmpl__ItemId__c','dmpl__SKUId__c','dmpl__InvoiceQuantity__c','dmpl__OrderedQuantity__c'}, 'dmpl__GoodsReceiptLine__c');
                insert linesToInsert;
            } catch (Exception e) {
                Database.rollback(sp);
                throw new DMPLException(e.getMessage());
            }
        }
    }

    private static dmpl__GoodsReceipt__c createReceiptDocumentFromShipment(dmpl__ShipmentLine__c shipmentLine)
    {
        return new dmpl__GoodsReceipt__c(
            dmpl__ShipmentId__c = shipmentLine.dmpl__ShipmentId__c,
            dmpl__BranchId__c = shipmentLine.dmpl__ShipmentId__r.dmpl__BranchId__c,
            dmpl__PartnerAccountId__c = shipmentLine.dmpl__ShipmentId__r.dmpl__PartnerAccountId__c,
            dmpl__SupplierAccountId__c = shipmentLine.dmpl__ShipmentId__r.dmpl__SupplierAccountId__c,
            dmpl__SupplierInvoiceDate__c = shipmentLine.dmpl__ShipmentId__r.dmpl__SupplierInvoiceDate__c,
            dmpl__SupplierInvoiceNumber__c = shipmentLine.dmpl__ShipmentId__r.dmpl__SupplierInvoiceNumber__c,
            dmpl__TransporterName__c = shipmentLine.dmpl__ShipmentId__r.dmpl__TransporterName__c,
            dmpl__TransporterRefrenceNumber__c =shipmentLine.dmpl__ShipmentId__r.dmpl__TransporterReferenceNo__c
        );
        
    }

    @testVisible
    private static dmpl__GoodsReceipt__c createReceiptDocumentFromPurchaseOrder(dmpl__PurchaseOrderLine__c orderLine)
    {
        return new dmpl__GoodsReceipt__c(
            dmpl__BranchId__c = orderLine.dmpl__PurchaseOrderId__r.dmpl__BranchId__c,
            dmpl__PartnerAccountId__c = orderLine.dmpl__PurchaseOrderId__r.dmpl__PartnerAccountId__c,
            dmpl__SupplierAccountId__c = orderLine.dmpl__PurchaseOrderId__r.dmpl__SupplierAccountId__c,
            dmpl__PurchaseOrderId__c = orderLine.dmpl__PurchaseOrderId__c
        );
    }

    private static dmpl__GoodsReceiptLine__c createReceiptLineFromShipmentLine(dmpl__ShipmentLine__c shipmentLine)
    {
        return new dmpl__GoodsReceiptLine__c(
            dmpl__PurchaseOrderLineId__c = shipmentLine.dmpl__PurchaseOrderLineId__c,
            dmpl__ShipmentLineId__c = shipmentLine.Id,
            dmpl__ItemId__c = shipmentLine.dmpl__ItemId__c,
            dmpl__SKUId__c = shipmentLine.dmpl__SKUId__c,
            dmpl__OrderedQuantity__c = shipmentLine.dmpl__PurchaseOrderLineId__r.dmpl__Quantity__c,
            dmpl__SupplierQuantity__c = shipmentLine.dmpl__PendingQuantity__c
        );
    }

    @testVisible
    private static dmpl__GoodsReceiptLine__c createReceiptLineFromPurchaseOrderLine(dmpl__PurchaseOrderLine__c orderLine)
    {
        return new dmpl__GoodsReceiptLine__c(
            dmpl__PurchaseOrderLineId__c = orderLine.Id,
            dmpl__ItemId__c = orderLine.dmpl__ItemId__c,
            dmpl__SKUId__c = orderLine.dmpl__SKUId__c,
            dmpl__OrderedQuantity__c = orderLine.dmpl__PendingQuantity__c
        );
    }

    private static List<dmpl__ShipmentLine__c> queryShipmentLines(List<Id> shipmentIds, List<Id> shipmentLineIds)
    {
        if(shipmentLineIds == null){
            shipmentLineIds = new List<Id>();
        }

        SecurityHelper.ensureCanReadFields(new string[]{'dmpl__PartnerAccountId__c','dmpl__BranchId__c','dmpl__SupplierAccountId__c','dmpl__SupplierInvoiceDate__c','dmpl__SupplierInvoiceNumber__c','dmpl__TransporterName__c','dmpl__TransporterReferenceNo__c'},'dmpl__Shipment__c');
        SecurityHelper.ensureCanReadFields(new string[]{'dmpl__ItemId__c','dmpl__SKUId__c','dmpl__Quantity__c','dmpl__PendingQuantity__c','dmpl__ShipmentId__c','dmpl__PurchaseOrderId__c','dmpl__PurchaseOrderLineId__c'}, 'dmpl__ShipmentLine__c');
        SecurityHelper.ensureCanReadFields(new string[]{'dmpl__Quantity__c'}, 'dmpl__PurchaseOrderLine__c');
        return [SELECT Id,
            Name,
            dmpl__ItemId__c,
            dmpl__SKUId__c,
            dmpl__Quantity__c,
            dmpl__PendingQuantity__c,
            dmpl__ShipmentId__c,
            dmpl__PurchaseOrderId__c,
            dmpl__PurchaseOrderLineId__c,
            dmpl__PurchaseOrderLineId__r.dmpl__Quantity__c,
            dmpl__ShipmentId__r.dmpl__PartnerAccountId__c,
            dmpl__ShipmentId__r.dmpl__BranchId__c,
            dmpl__ShipmentId__r.dmpl__SupplierAccountId__c,
            dmpl__ShipmentId__r.dmpl__SupplierInvoiceDate__c,
            dmpl__ShipmentId__r.dmpl__SupplierInvoiceNumber__c,
            dmpl__ShipmentId__r.dmpl__TransporterName__c,
            dmpl__ShipmentId__r.dmpl__TransporterReferenceNo__c
        FROM dmpl__ShipmentLine__c
        WHERE (dmpl__ShipmentId__c in :shipmentIds OR Id IN :shipmentLineIds)
        AND dmpl__PendingQuantity__c > 0
        ];
    }

    @testVisible
    private static List<dmpl__PurchaseOrderLine__c> queryPurchaseOrderLines(List<Id> orderIds, List<Id> orderLineIds)
    {
        if(orderLineIds == null){
            orderLineIds = new List<Id>();
        }

        SecurityHelper.ensureCanReadFields(new string[]{'dmpl__PartnerAccountId__c','dmpl__BranchId__c','dmpl__SupplierAccountId__c'},'dmpl__PurchaseOrder__c');
        SecurityHelper.ensureCanReadFields(new string[]{'dmpl__ItemId__c','dmpl__SKUId__c','dmpl__Quantity__c','dmpl__PendingQuantity__c','dmpl__PurchaseOrderId__c'}, 'dmpl__PurchaseOrderLine__c');
        return [SELECT Id,
            Name,
            dmpl__ItemId__c,
            dmpl__SKUId__c,
            dmpl__Quantity__c,
            dmpl__PendingQuantity__c,
            dmpl__PurchaseOrderId__c,
            dmpl__PurchaseOrderId__r.dmpl__PartnerAccountId__c,
            dmpl__PurchaseOrderId__r.dmpl__BranchId__c,
            dmpl__PurchaseOrderId__r.dmpl__SupplierAccountId__c
        FROM dmpl__PurchaseOrderLine__c
        WHERE (dmpl__PurchaseOrderId__c in :orderIds OR Id IN :orderLineIds)
        AND dmpl__PendingQuantity__c > 0
        ];
    }

    private static List<dmpl__GoodsReceiptLine__c> queryGoodsReceiptLines(List<Id> goodsReceiptIds, List<Id> goodsReceiptLineIds)
    {
        SecurityHelper.ensureCanReadFields(new string[]{'dmpl__RepairOrderLineId__c','dmpl__FulfillmentOrderLineId__c'},'dmpl__PurchaseOrderLine__c');
        SecurityHelper.ensureCanReadFields(new string[]{'dmpl__DamagedQuantity__c','dmpl__ReceivedQuantity__c','dmpl__OrderedQuantity__c','dmpl__GoodsReceiptId__c','dmpl__PurchaseOrderLineId__c','dmpl__ItemId__c','dmpl__SKUId__c','dmpl__StorageLocationId__c','dmpl__UnitCost__c','dmpl__IsApproved__c','dmpl__InventoryLedgerInspectionId__c','dmpl__ItemLotId__c'}, 'dmpl__GoodsReceiptLine__c');
        return [SELECT Id, 
        Name,
        dmpl__GoodsReceiptId__c,
        dmpl__PurchaseOrderLineId__c,
        dmpl__PurchaseOrderLineId__r.dmpl__RepairOrderLineId__c,
        dmpl__PurchaseOrderLineId__r.dmpl__FulfillmentOrderLineId__c,
        dmpl__ItemId__c,
        dmpl__SKUId__c,
        dmpl__StorageLocationId__c,
        dmpl__UnitCost__c,
        dmpl__IsApproved__c,
        dmpl__InventoryLedgerInspectionId__c,
        dmpl__ItemLotId__c,
        dmpl__OrderedQuantity__c,
        dmpl__ReceivedQuantity__c,
        dmpl__DamagedQuantity__c,
        dmpl__ShortageQuantity__c,
        dmpl__SupplierQuantity__c
        FROM dmpl__GoodsReceiptLine__c
        WHERE dmpl__GoodsReceiptId__c IN : goodsReceiptIds OR Id IN : goodsReceiptLineIds];
    }

    private static List<dmpl__GoodsReceipt__c> queryGoodsReceipts(List<Id> goodsReceiptIds){
        SecurityHelper.ensureCanReadFields(new string[]{'dmpl__PerformInspection__c'},'dmpl__GoodsReceipt__c');
        return[
            SELECT
            Id,
            Name,
            dmpl__PerformInspection__c
            FROM dmpl__GoodsReceipt__c
            WHERE Id IN : goodsReceiptIds
        ];
    }

    private static void createInterfaceQueue(List<Id> goodsReceiptIds)
    {
        List<dmpl__InterfaceQueue__c> newInterfaceQueues = new List<dmpl__InterfaceQueue__c>();
        for(Id goodsReceiptId : goodsReceiptIds)
        {
            newInterfaceQueues.add(new dmpl__InterfaceQueue__c(
                dmpl__JobType__c = 'Receive Goods Receipt Line Processor',
                dmpl__InterfaceRecordId__c = goodsReceiptId,
                dmpl__QueueType__c = 'Queueable'
            ));
        }

        SecurityHelper.ensureCanCreateObject('dmpl__InterfaceQueue__c');
        SecurityHelper.ensureCanCreateFields(
            new string[]{
                'dmpl__JobType__c',
                'dmpl__InterfaceRecordId__c',
                'dmpl__QueueType__c'
            }, 'dmpl__InterfaceQueue__c');

        insert newInterfaceQueues;
    }
}