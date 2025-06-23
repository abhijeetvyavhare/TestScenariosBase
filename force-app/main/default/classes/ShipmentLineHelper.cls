public with sharing class ShipmentLineHelper {
    private static Boolean skipValidations = false;
    
    private static final string OBJECT_SHIPMENT = 'dmpl__Shipment__c';
    private static final string OBJECT_SHIPMENTLINE = 'dmpl__ShipmentLine__c';
    private static final string FIELD_SHIPMENT_ID = 'dmpl__ShipmentId__c';

    private static final string FIELD_SHIPMENTLINE_CANCELLEDQUANTITY = 'dmpl__CancelledQuantity__c';
    private static final string FIELD_SHIPMENTLINE_PENDINGQUANTITY = 'dmpl__PendingQuantity__c';
    private static final string FIELD_SHIPMENTLINE_PURCHASEORDERID = 'dmpl__PurchaseOrderId__c';
    private static final string FIELD_SHIPMENTLINE_ITEMID = 'dmpl__ItemId__c';
    private static final string FIELD_SHIPMENTLINE_SKUID = 'dmpl__SKUId__c';
    private static final string FIELD_SHIPMENTLINE_QUANTITY = 'dmpl__Quantity__c';
    private static final string FIELD_SHIPMENTLINE_RECEIPTQUANTITY = 'dmpl__ReceiptQuantity__c';
    private static final string RELATION_SHIPMENT_STATUS = 'dmpl__ShipmentId__r.dmpl__Status__c';
    private static final string FIELD_SHIPMENTLINE_PURCHASEORDERLINEID = 'dmpl__PurchaseOrderLineId__c';
    private static final string FIELD_SHIPMENTLINE_DELIVERYORDERLINEID = 'dmpl__DeliveryOrderLineId__c';
    
    private static final string FIELD_AGG_SHIPMENTLINEID = 'ShipmentLineId';
    private static final string FIELD_AGG_TOTALQTY = 'TotalQuantity';
    
    private static final List<String> LIST_FIELDS_NONEDITABLE = new List<String>{
        FIELD_SHIPMENTLINE_PURCHASEORDERID
    };
    private static final List<String> LIST_FIELDS_SYSTEM = new List<String>{
        FIELD_SHIPMENTLINE_RECEIPTQUANTITY,
        'dmpl__InventoryLedgerId__c', 
        'dmpl__IsILPosted__c',
        'dmpl__IsILPostingApproved__c'
    };
    private static final List<String> LIST_FIELDS_SOURCEPOULATED = new List<String>{
        FIELD_SHIPMENTLINE_ITEMID,
        FIELD_SHIPMENTLINE_SKUID
    };
    private static final List<String> LIST_FIELDS_LOCKEDIFTRANSACTED = new List<String>{
        FIELD_SHIPMENTLINE_ITEMID,
        FIELD_SHIPMENTLINE_SKUID
    };

    private static final List<String> LIST_FIELDS_NEGATIVEANDZERONOTALLOWED = new List<String>{
    };
    
    private static final List<String> LIST_FIELDS_NEGATIVENOTALLOWED = new List<String>{
        'dmpl__PendingQuantity__c', 
        'dmpl__Quantity__c', 
        'dmpl__ReceiptQuantity__c'
    };

    private static ShipmentService sos = new ShipmentService();

    public static void validateData(Boolean isInsert, Boolean isDelete, Boolean isUpdate, List<dmpl__ShipmentLine__c> oldEntries, List<dmpl__ShipmentLine__c> newEntries)
    {
        try{
            if(isInsert){
                FieldMappingHelper.copyFieldMappingData(
                    newEntries);
            }else if(isUpdate){
                List<dmpl__ShipmentLine__c> modifiedObjects = DocumentHelper.getApprovedObjects(
                    'dmpl__IsILPostingApproved__c', 
                    oldEntries, 
                    newEntries);
                if(modifiedObjects.size()>0){
                    DocumentHelper.validateCanBePosted(modifiedObjects, 'dmpl__ReceiptQuantity__c');
                }
            }else if(isDelete){
                DocumentHelper.validateCanBeDeleted(oldEntries, 'dmpl__ReceiptQuantity__c');
            }
            if(isInsert || isUpdate){   
                ValidationHelper.validatePostiveDecimal(
                    LIST_FIELDS_NEGATIVEANDZERONOTALLOWED,
                    newEntries);
                ValidationHelper.validatePostiveOrZeroDecimal(
                    LIST_FIELDS_NEGATIVENOTALLOWED,
                    newEntries);
            }
            //
            if(skipValidations){
                return;
            }
            //
            if(isInsert){
                validateItem(newEntries);
                DocumentHelper.validateChangeInSystemFields(LIST_FIELDS_SYSTEM, newEntries);
                (new DocumentStatusDFSHelper()).DocumentStatusRelatedObjectRestrictEdits_New(OBJECT_SHIPMENT, OBJECT_SHIPMENTLINE, RELATION_SHIPMENT_STATUS, newEntries);
                validateStorageLocationIsNull(newEntries);
            }else if(isUpdate){
                DocumentHelper.validateChangeInSystemFields(LIST_FIELDS_SYSTEM, oldEntries, newEntries);
                DocumentHelper.validateChangeInKeyFields(LIST_FIELDS_NONEDITABLE, oldEntries, newEntries);
                DocumentHelper.validateChangeInSourcePopulatedFields(LIST_FIELDS_SOURCEPOULATED, oldEntries, newEntries, FIELD_SHIPMENTLINE_PURCHASEORDERLINEID);
                (new DocumentStatusDFSHelper()).DocumentStatusRelatedObjectRestrictEdits_Edit(OBJECT_SHIPMENT, OBJECT_SHIPMENTLINE, RELATION_SHIPMENT_STATUS, oldEntries, newEntries);
                validateStorageLocationIsNull(newEntries);
            }else if(isDelete){
                (new DocumentStatusDFSHelper()).DocumentStatusRelatedObjectRestrictEdits_Delete(OBJECT_SHIPMENT, OBJECT_SHIPMENTLINE, RELATION_SHIPMENT_STATUS, oldEntries);
            }
        }catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }

    public static void postData(Boolean isInsert, Boolean isDelete, Boolean isUpdate, List<dmpl__ShipmentLine__c> oldEntries, List<dmpl__ShipmentLine__c> newEntries)
    {
        try{
            InventoryLedgerHelper.createLedger(
                InventoryLedgerTypeEnums.Pipeline, 
                'dmpl__ShipmentId__c', 
                'dmpl__Shipment__c', 
                isInsert, 
                isDelete, 
                isUpdate, 
                oldEntries, 
                newEntries);
        }catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }

    public static void afterPostData(Boolean isInsert, Boolean isDelete, Boolean isUpdate, List<dmpl__ShipmentLine__c> oldEntries, List<dmpl__ShipmentLine__c> newEntries)
    {
        try{
        if(isDelete){
            SaleDeliveryLineHelper.updateShippedQuantity(DocumentHelper.extractIds(oldEntries, FIELD_SHIPMENTLINE_DELIVERYORDERLINEID));
        }else if(isInsert){
            SaleDeliveryLineHelper.updateShippedQuantity(DocumentHelper.extractIds(newEntries, FIELD_SHIPMENTLINE_DELIVERYORDERLINEID));
        }else if(isUpdate){
            List<Id> modifiedObjectIds = DocumentHelper.getModifiedNewObjectIds(FIELD_SHIPMENTLINE_QUANTITY, FIELD_SHIPMENTLINE_DELIVERYORDERLINEID, oldEntries, newEntries);
            if(modifiedObjectIds.size()>0){
                SaleDeliveryLineHelper.updateShippedQuantity(modifiedObjectIds);
            }            
        }
    } catch (Exception error) {
        ExceptionLogHelper.logException(error);
        throw error;
    }
    }

    public static CreateRelatedResult postIL(Id shipmentId){
        return postShipmentLines(
            queryShipmentLines(
                new List<Id>{shipmentId}));
    }

    public static CreateRelatedResult postIL(
        List<SourceObjectInfo> orderLinesInfo, 
        Id shipmentId){
        return postShipmentLines(
            queryShipmentLinesForLines(
                SourceObjectInfo.extractIds(orderLinesInfo)));
    }

    public static void postShipmentLines(
        List<dmpl__Shipment__c> modifiedDocs){
        dmpl__CreateRelatedSetting__mdt setting = CreateRelatedSettingHelper.getCreateRelatedSettings(
            'dmpl__Shipment__c',
            'Post IL');
        if(setting == null){
            postShipmentLines(
                queryShipmentLines(
                    DocumentHelper.extractIds(modifiedDocs)));
        }else {
            for(dmpl__Shipment__c shipment : modifiedDocs){
                DocumentSelectorController.releaseDocumentDirect(
                    setting.Id, 
                    shipment.Id);
            }
        }
    }

    public static CreateRelatedResult postShipmentLines(
        List<dmpl__ShipmentLine__c> shipmentLines){
        SecurityHelper.ensureCanWriteField(
            'dmpl__IsILPostingApproved__c', 
            'dmpl__ShipmentLine__c');
        for(dmpl__ShipmentLine__c shipmentLine : shipmentLines){
            shipmentLine.dmpl__IsILPostingApproved__c = true;
        }

        try {
            skipValidations = true;
            SecurityHelper.ensureCanWriteFields(
                new string[]{
                    'dmpl__IsILPosted__c',
                    'dmpl__IsILPostingApproved__c'}, 
                'dmpl__ShipmentLine__c');
            return CreateRelatedResult.InitFrom(
                Database.update(
                    shipmentLines));            
        } finally {
            skipValidations = false;
        }
    }

    public static CreateRelatedResult cancelShipmentLines(
        List<SourceObjectInfo> orderLinesInfo, 
        Id shipmentId){
            return CancelShipmentLinesInternal(
                ShipmentLineHelper.sos.queryObjectsForType(
                    OBJECT_SHIPMENTLINE, 
                    new List<String>{
                        FIELD_SHIPMENTLINE_CANCELLEDQUANTITY,
                        FIELD_SHIPMENTLINE_PENDINGQUANTITY},
                    SourceObjectInfo.extractIds(
                        orderLinesInfo)),
                orderLinesInfo);
        }

    public static CreateRelatedResult cancelShipmentLines(
        Id shipmentId){
            return CancelShipmentLinesInternal(
                ShipmentLineHelper.sos.queryObjectsForType(
                    OBJECT_SHIPMENTLINE, 
                    new List<String>{
                        FIELD_SHIPMENTLINE_CANCELLEDQUANTITY,
                        FIELD_SHIPMENTLINE_PENDINGQUANTITY},
                    FIELD_SHIPMENT_ID, 
                    shipmentId),
                null);
        }

    @testVisible
    private static CreateRelatedResult cancelShipmentLinesInternal(
        List<dmpl__ShipmentLine__c> lines,
        List<SourceObjectInfo> orderLinesInfo){
            for(dmpl__ShipmentLine__c line : lines){
                decimal cancelQty = line.dmpl__PendingQuantity__c;
                if(orderLinesInfo!=null){
                    cancelQty = SourceObjectInfo.getRequestedQuantity(orderLinesInfo, line.Id);
                    SourceObjectInfo info = SourceObjectInfo.getSourceObjectInfo(orderLinesInfo, line.Id);
                    if(info.fields!=null){
                        for(SourceObjectField srcField : info.fields){
                            line.put(srcField.fieldName, srcField.fieldValue);
                        }
                    }
                }
                line.dmpl__CancelledQuantity__c = cancelQty 
                    + (line.dmpl__CancelledQuantity__c == null ? 
                        0 : line.dmpl__CancelledQuantity__c);
            }
            return CreateRelatedResult.InitFrom(
                ShipmentLineHelper.sos.updateObjects(lines)
            );
        }

    public static void updateReceiptQuantity(List<Id> shipmentLineIds)
    {
        try{
            skipValidations = true;
            SecurityHelper.ensureCanReadFields(new string[]{'dmpl__ShipmentLineId__c','dmpl__SupplierQuantity__c'}, 'dmpl__GoodsReceiptLine__c');
            List<AggregateResult> ffAggregates = 
                [SELECT dmpl__ShipmentLineId__c ShipmentLineId, SUM(dmpl__SupplierQuantity__c) TotalQuantity
                FROM dmpl__GoodsReceiptLine__c
                WHERE dmpl__ShipmentLineId__c IN :shipmentLineIds
                GROUP BY dmpl__ShipmentLineId__c];

            SecurityHelper.ensureCanReadFields(new string[]{'dmpl__ReceiptQuantity__c'}, 'dmpl__ShipmentLine__c');
            List<dmpl__ShipmentLine__c> shipmentLinesToUpdate = 
                [SELECT Id, dmpl__ReceiptQuantity__c
                FROM dmpl__ShipmentLine__c
                WHERE Id IN :shipmentLineIds];
    
            for(dmpl__ShipmentLine__c shipmentLine : shipmentLinesToUpdate){
                for(AggregateResult result : ffAggregates){
                    if(result.get(FIELD_AGG_SHIPMENTLINEID) == shipmentLine.Id){
                        shipmentLine.dmpl__ReceiptQuantity__c = result.get(FIELD_AGG_TOTALQTY) == null ? 0 : (Decimal)(result.get(FIELD_AGG_TOTALQTY));
                        break;
                    }
                }
            }
            SecurityHelper.ensureCanWriteFields(new string[]{'dmpl__ReceiptQuantity__c'}, 'dmpl__ShipmentLine__c');
            Update shipmentLinesToUpdate;
        }finally{
            skipValidations = false;
        }
    }

    private static void validateItem(List<dmpl__ShipmentLine__c> newEntries){
        Map<Id, dmpl__Item__c> items = new Map<Id,dmpl__Item__c>(ItemHelper.getCachedItems(DocumentHelper.extractIds(newEntries, FIELD_SHIPMENTLINE_ITEMID)));
        for(dmpl__ShipmentLine__c orderLine : newEntries){
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

    private static void validateStorageLocationIsNull(List<dmpl__ShipmentLine__c> newEntries){
        for(dmpl__ShipmentLine__c shipmentLine : newEntries){
            if(shipmentLine.dmpl__StorageLocationId__c != null){
                shipmentLine.addError(System.Label.Validation_StorageLocationNotRequired);
            }
        }
        for(dmpl__ShipmentLine__c shipmentLine : newEntries){
            if(shipmentLine.dmpl__ItemLotId__c != null){
                shipmentLine.addError(System.Label.Validation_StorageLocationNotRequired);
            }
        }
    }

    private static List<dmpl__ShipmentLine__c> queryShipmentLines(List<ID> documentIds)
    {
        SecurityHelper.ensureCanReadFields(new string[]{
            'dmpl__IsILPosted__c',
            'dmpl__IsILPostingApproved__c'}, 
        'dmpl__ShipmentLine__c');
        return ([SELECT id,
            dmpl__IsILPosted__c,
            dmpl__IsILPostingApproved__c
            FROM dmpl__ShipmentLine__c WHERE dmpl__ShipmentId__c IN :documentIds]);
    }

    private static List<dmpl__ShipmentLine__c> queryShipmentLinesForLines(List<ID> lineIds)
    {
        SecurityHelper.ensureCanReadFields(
            new string[]{
                'dmpl__IsILPosted__c',
                'dmpl__IsILPostingApproved__c'}, 
            'dmpl__ShipmentLine__c');
        return ([SELECT id,
            dmpl__IsILPosted__c,
            dmpl__IsILPostingApproved__c
            FROM dmpl__ShipmentLine__c WHERE Id IN :lineIds]);
    }
}