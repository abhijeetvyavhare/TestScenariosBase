public with sharing class ShipmentHelper {

    private static Boolean skipValidations = false;

    private static final string OBJECT_SHIPMENT = 'dmpl__Shipment__c';
    private static final string FIELD_SHIPMENT_STATUS = 'dmpl__Status__c';
    private static final string FIELD_SHIPMENT_PARTNERACCOUNTID = 'dmpl__PartnerAccountId__c';
    private static final string FIELD_SHIPMENT_BRANCHID = 'dmpl__BranchId__c';
    private static final string FIELD_SHIPMENT_SUPPLIERACCOUNTID ='dmpl__SupplierAccountId__c';
    private static final string FIELD_SHIPMENT_DOCUMENTDATE ='dmpl__DocumentDate__c';
    private static final string FIELD_SHIPMENT_PERFORMRELEASERECEIPT ='dmpl__PerformReleaseReceipt__c';
    
    private static final List<String> LIST_NON_EDITABLE_FIELDS = new List<String>{FIELD_SHIPMENT_BRANCHID, FIELD_SHIPMENT_DOCUMENTDATE, FIELD_SHIPMENT_PARTNERACCOUNTID};
    private static final List<String> LIST_FIELDS_SYSTEM = new List<String>();
   

    public static void validateData(Boolean isInsert, Boolean isDelete, Boolean isUpdate, List<dmpl__Shipment__c> oldEntries, List<dmpl__Shipment__c> newEntries)
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
            StatusHelper.validateStatusNew(OBJECT_SHIPMENT, FIELD_SHIPMENT_STATUS, newEntries);
            DocumentHelper.validateChangeInSystemFields(LIST_FIELDS_SYSTEM, newEntries);
            ValidationHelper.validatePartnerAndBranch(FIELD_SHIPMENT_PARTNERACCOUNTID, FIELD_SHIPMENT_BRANCHID, newEntries);
        }else if(isUpdate){
            StatusHelper.validateStatusEdit(OBJECT_SHIPMENT, FIELD_SHIPMENT_STATUS, oldEntries, newEntries);
            DocumentHelper.validateChangeInKeyFields(LIST_NON_EDITABLE_FIELDS, oldEntries, newEntries);
            DocumentHelper.validateChangeInSystemFields(LIST_FIELDS_SYSTEM, oldEntries, newEntries);
            dfsHelper.DocumentStatusRestrictEdits_Edit(OBJECT_SHIPMENT, FIELD_SHIPMENT_STATUS, oldEntries, newEntries);
            dfsHelper.DocumentStatusRestrictFieldsEdits(OBJECT_SHIPMENT, FIELD_SHIPMENT_STATUS, oldEntries, newEntries);
        }else if(isDelete){
            dfsHelper.DocumentStatusRestrictEdits_Delete(OBJECT_SHIPMENT, FIELD_SHIPMENT_STATUS, oldEntries);
        }
    }catch (Exception error) {
        ExceptionLogHelper.logException(error);
        throw error;
    }
    }

    public static void postData(Boolean isInsert, Boolean isDelete, Boolean isUpdate, List<dmpl__Shipment__c> oldEntries, List<dmpl__Shipment__c> newEntries)
    {
        try{ 

            DocumentStatusDFSHelper dfsHelper = new DocumentStatusDFSHelper();
            if(isInsert)
    		DocumentNameHelper.generateDocumentName(newEntries);
            
            if(isUpdate){
                dfsHelper.DocumentStatusSetFlag(OBJECT_SHIPMENT, FIELD_SHIPMENT_STATUS, oldEntries, newEntries);
                dfsHelper.DocumentStatusReSetFlag(OBJECT_SHIPMENT, FIELD_SHIPMENT_STATUS, oldEntries, newEntries);
                List<dmpl__Shipment__c> modifiedObjects = DocumentHelper.getApprovedObjects(FIELD_SHIPMENT_PERFORMRELEASERECEIPT, oldEntries, newEntries);
                if(modifiedObjects.size()>0){
                    createGoodsReceipt(modifiedObjects);
                }    
                List<dmpl__Shipment__c> modifiedDocs = DocumentHelper.getApprovedObjects(
                    'dmpl__PerformInventoryPosting__c', 
                    oldEntries,
                    newEntries);
                if(modifiedDocs.size()>0){
                    ShipmentLineHelper.postShipmentLines(modifiedDocs);
                    SecurityHelper.ensureCanWriteField('dmpl__PerformInventoryPosting__c', 'dmpl__Shipment__c');
                    SecurityHelper.ensureCanWriteField('dmpl__IsInventoryPosted__c', 'dmpl__Shipment__c');
                    for(dmpl__Shipment__c document : modifiedDocs){
                        document.dmpl__PerformInventoryPosting__c = false;
                        document.dmpl__IsInventoryPosted__c = true;
                    }
                }
            }
        }catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }

    public static CreateRelatedResult postIL(Id shipmentId){
        return ShipmentLineHelper.postIL(shipmentId);
     }
 
    public static CreateRelatedResult postIL(
        List<SourceObjectInfo> orderLinesInfo, 
        Id shipmentId){
        return ShipmentLineHelper.postIL(
            orderLinesInfo, 
            shipmentId);
    }

    public static void createGoodsReceipt(List<SourceObjectInfo> orderLinesInfo){
        if(orderLinesInfo == null || orderLinesInfo.size() ==0){
            return;
        }
        GoodsReceiptHelper.createGoodsReceiptFromShipment(orderLinesInfo);
    }

    public static void createGoodsReceipt(List<dmpl__Shipment__c> lineEntries){
        GoodsReceiptHelper.createGoodsReceiptFromShipment(lineEntries);
        SecurityHelper.ensureCanWriteField('dmpl__PerformReleaseReceipt__c', 'dmpl__Shipment__c');
        SecurityHelper.ensureCanWriteField('dmpl__IsReceiptReleased__c', 'dmpl__Shipment__c');
        for(dmpl__Shipment__c lineEntry : lineEntries){
            lineEntry.dmpl__PerformReleaseReceipt__c = false;
            lineEntry.dmpl__IsReceiptReleased__c = true;
        }
    }

    public static void createShipmentFromDelivery(List<dmpl__DeliveryOrder__c> deliveryOrders){
        createShipmentFromDelivery(queryDeliveryOrderLines(DocumentHelper.extractIds(deliveryOrders), null));
    }

    public static void createShipmentFromDelivery(List<SourceObjectInfo> orderLinesInfo){
        createShipmentFromDelivery(queryDeliveryOrderLines(null, SourceObjectInfo.extractIds(orderLinesInfo)));
    }  

    private static void createShipmentFromDelivery(List<dmpl__DeliveryOrderLine__c> deliveryLines)
    {
        if(deliveryLines.size() == 0){
            throw new DMPLException(String.format(String.valueOf(System.Label.Generic_EmptyActionParam), new String[]{dmpl__Shipment__c.class.getName()}));
        }

        Map<Id, dmpl__Shipment__c> shipmentDocuments = new Map<Id,dmpl__Shipment__c>();
        Map<Id, List<dmpl__ShipmentLine__c>> shipmentLines = new Map<Id, List<dmpl__ShipmentLine__c>>();
        Map<Id,dmpl__PurchaseOrderLine__c> purchaseOrderLines = queryPurchaseOrderLines(CollectionHelper.extractIds(deliveryLines, 'dmpl__PurchaseOrderLineId__c'));
        if(purchaseOrderLines.size() == 0)
            throw new DMPLException(String.format(String.valueOf(System.Label.Generic_EmptyActionParam), new String[]{dmpl__Shipment__c.class.getName()}));

        for(dmpl__DeliveryOrderLine__c deliveryLine : deliveryLines){
            if(deliveryLine.dmpl__ItemId__c !=null 
                && deliveryLine.dmpl__PendingShippedQuantity__c>0){
                    dmpl__Shipment__c shipmentDocument = null;
                if(shipmentDocuments.containsKey(deliveryLine.dmpl__DeliveryId__c)){
                    shipmentDocument = shipmentDocuments.get(deliveryLine.dmpl__DeliveryId__c);
                }else {
                    shipmentDocument = createShipmentDocumentFromDelivery(deliveryLine, purchaseOrderLines.get(deliveryLine.dmpl__PurchaseOrderLineId__c));
                    shipmentDocuments.put(deliveryLine.dmpl__DeliveryId__c, shipmentDocument);
                    shipmentLines.put(deliveryLine.dmpl__DeliveryId__c, new List<dmpl__ShipmentLine__c>());
                }
        
                shipmentLines.get(deliveryLine.dmpl__DeliveryId__c).add(createShipmentLineFromDeliveryLine(deliveryLine));
            }
        }
        //
        if(shipmentLines.size() >0){
            Savepoint sp = Database.setSavepoint();
            try {
                SecurityHelper.ensureCanCreateObject('dmpl__Shipment__c');
                SecurityHelper.ensureCanCreateFields(new string[]{'dmpl__BranchId__c','dmpl__PartnerAccountId__c','dmpl__SupplierAccountId__c','dmpl__DeliveryOrderDate__c','dmpl__DeliveryOrderNumber__c'}, 'dmpl__Shipment__c');
                insert shipmentDocuments.values();
                List<dmpl__ShipmentLine__c> linesToInsert = new List<dmpl__ShipmentLine__c>();
                for(Id soId : shipmentDocuments.keySet()){
                    dmpl__Shipment__c shipment = shipmentDocuments.get(soId);
                    List<dmpl__ShipmentLine__c> docLines = shipmentLines.get(soId);
                    for(dmpl__ShipmentLine__c doLIne : docLines){
                        doLIne.dmpl__ShipmentId__c = shipment.Id;
                        linesToInsert.add(doLIne);
                    }    
                }
                SecurityHelper.ensureCanCreateObject('dmpl__ShipmentLine__c');
                SecurityHelper.ensureCanCreateFields(new string[]{'dmpl__DeliveryOrderLineId__c','dmpl__ItemId__c','dmpl__SKUId__c','dmpl__Quantity__c','dmpl__PurchaseOrderLineId__c'}, 'dmpl__ShipmentLine__c');
                insert linesToInsert;
            } catch (Exception e) {
                Database.rollback(sp);
                throw e;
            }
        }
    }

    private static dmpl__Shipment__c createShipmentDocumentFromDelivery(dmpl__DeliveryOrderLine__c deliveryOrderLine, dmpl__PurchaseOrderLine__c purchaseOrderLine)
    {
        return new dmpl__Shipment__c(
            // dmpl__DeliveryId__c = deliveryOrderLine.dmpl__DeliveryId__c,
            dmpl__BranchId__c = purchaseOrderLine != null ? purchaseOrderLine.dmpl__PurchaseOrderId__r.dmpl__BranchId__c : deliveryOrderLine.dmpl__DeliveryId__r.dmpl__BranchId__c,
            dmpl__PartnerAccountId__c = deliveryOrderLine.dmpl__DeliveryId__r.dmpl__AccountId__c,
            // dmpl__DocumentDate__c = deliveryOrderLine.dmpl__DeliveryOrderId__r.dmpl__DocumentDate__c,
            dmpl__SupplierAccountId__c = deliveryOrderLine.dmpl__DeliveryId__r.dmpl__PartnerAccountId__c,
            dmpl__DeliveryOrderDate__c = deliveryOrderLine.dmpl__DeliveryId__r.dmpl__DocumentDate__c,
            dmpl__DeliveryOrderNumber__c = deliveryOrderLine.dmpl__DeliveryId__r.Name
        );
    }

    private static dmpl__ShipmentLine__c createShipmentLineFromDeliveryLine(dmpl__DeliveryOrderLine__c deliveryOrderLine)
    {
        return new dmpl__ShipmentLine__c(
            dmpl__DeliveryOrderLineId__c = deliveryOrderLine.Id,
            dmpl__ItemId__c = deliveryOrderLine.dmpl__ItemId__c,
            dmpl__SKUId__c = deliveryOrderLine.dmpl__SKUId__c,
            dmpl__Quantity__c = deliveryOrderLine.dmpl__PendingShippedQuantity__c,
            dmpl__PurchaseOrderLineId__c = deliveryOrderLine.dmpl__PurchaseOrderLineId__c
        );
    }

    private static List<dmpl__DeliveryOrderLine__c> queryDeliveryOrderLines(List<Id> deliveryOrderIds, List<Id> deliveryOrderLineIds)
    {
        if(deliveryOrderLineIds == null){
            deliveryOrderLineIds = new List<Id>();
        }

        SecurityHelper.ensureCanReadFields(new string[]{'dmpl__PartnerAccountId__c',' dmpl__BranchId__c,','dmpl__AccountId__c','dmpl__DocumentDate__c'}, 'dmpl__DeliveryOrder__c');
        SecurityHelper.ensureCanReadFields(new string[]{'dmpl__ItemId__c','dmpl__SKUId__c','dmpl__Quantity__c','dmpl__PendingShippedQuantity__c'}, 'dmpl__DeliveryOrderLine__c');
        return [SELECT Id,
            Name,
            dmpl__ItemId__c,
            dmpl__SKUId__c,
            dmpl__Quantity__c,
            dmpl__PendingShippedQuantity__c,
            dmpl__PurchaseOrderLineId__c,
            dmpl__DeliveryId__r.dmpl__PartnerAccountId__c,
            dmpl__DeliveryId__r.dmpl__BranchId__c,
            dmpl__DeliveryId__r.dmpl__AccountId__c,
            dmpl__DeliveryId__r.dmpl__DocumentDate__c,
            dmpl__DeliveryId__r.Name
        FROM dmpl__DeliveryOrderLine__c
        WHERE dmpl__DeliveryId__c IN :deliveryOrderIds OR Id IN :deliveryOrderLineIds
        ];
    }

    private static Map<Id,dmpl__PurchaseOrderLine__c> queryPurchaseOrderLines(List<Id> purchaseOrderLineIds)
    {
        SecurityHelper.ensureCanReadFields(new string[]{'dmpl__PartnerAccountId__c',' dmpl__BranchId__c'}, 'dmpl__PurchaseOrder__c');
        return new Map<Id,dmpl__PurchaseOrderLine__c>([SELECT Id,
            Name,
            dmpl__PurchaseOrderId__r.dmpl__BranchId__c,
            dmpl__PurchaseOrderId__r.dmpl__PartnerAccountId__c
        FROM dmpl__PurchaseOrderLine__c
        WHERE Id IN :purchaseOrderLineIds
        ]);
    }

}