public with sharing class SaleDeliveryHelper {
    
    private static Boolean skipValidations = false;

    private static final string OBJECT_SALEDELIVERY = 'dmpl__DeliveryOrder__c';
    private static final string FIELD_SALEDELIVERY_STATUS = 'dmpl__Status__c';
    private static final string FIELD_SALEDELIVERY_PARTNERACCOUNTID = 'dmpl__PartnerAccountId__c';
    private static final string FIELD_SALEDELIVERY_BRANCHID = 'dmpl__BranchId__c';
    private static final string FIELD_SALEDELIVERY_ACCOUNTID ='dmpl__AccountId__c';
    private static final string FIELD_SALEDELIVERY_DOCUMENTDATE ='dmpl__DocumentDate__c';
    private static final string FIELD_SALEDELIVERY_SALEORDERID ='dmpl__SaleOrderId__c';
    private static final string FIELD_SALEDELIVERY_ID ='Id';
    private static final string FIELD_SALEDELIVERYLINE_SALEDELIVERYID ='dmpl__DeliveryId__c';
    private static final string FIELD_SALEDELIVERY_PERFORMRELEASESHIPMENT ='dmpl__PerformReleaseShipment__c';
    private static final string FIELD_SALEDELIVERY_PERFORMPOPULATECHECKLIST = 'dmpl__PerformPopulateChecklist__c';
    private static final string FIELD_SALEDELIVERY_DELIVERYDONEBY = 'dmpl__DeliveryDoneBy__c';

    private static final string FIELD_SALEDELIVERY_BILLINGADDRESS ='dmpl__BillingAddress__c';
    private static final string FIELD_SALEDELIVERY_SHIPPINGADDRESS ='dmpl__ShippingAddress__c';
    private static final string FIELD_SALEDELIVERY_BILLINGADDRESSID ='dmpl__BillingAddressId__c';
    private static final string FIELD_SALEDELIVERY_SHIPPINGADDRESSID ='dmpl__ShippingAddressId__c';
    
    private static final List<String> LIST_NON_EDITABLE_FIELDS = new List<String>{FIELD_SALEDELIVERY_SALEORDERID,FIELD_SALEDELIVERY_ACCOUNTID, FIELD_SALEDELIVERY_PARTNERACCOUNTID, FIELD_SALEDELIVERY_BRANCHID, FIELD_SALEDELIVERY_DOCUMENTDATE};
    private static final List<String> LIST_FIELDS_SOURCEPOULATED = new List<String>{FIELD_SALEDELIVERY_PARTNERACCOUNTID, FIELD_SALEDELIVERY_BRANCHID,FIELD_SALEDELIVERY_ACCOUNTID};
    private static final List<String> LIST_FIELDS_SYSTEM = new List<String>{};
    
    public static void validateData(Boolean isInsert, Boolean isDelete, Boolean isUpdate, List<dmpl__DeliveryOrder__c> oldEntries, List<dmpl__DeliveryOrder__c> newEntries)
    { 
        try {     
            if(isInsert){
                FieldMappingHelper.copyFieldMappingData(
                    newEntries);
            }
        if(skipValidations) {
            return;
        }

        DocumentStatusDFSHelper dfsHelper = new DocumentStatusDFSHelper();
        if(isInsert) {
            StatusHelper.validateStatusNew(OBJECT_SALEDELIVERY, FIELD_SALEDELIVERY_STATUS, newEntries);
            ValidationHelper.validatePartnerAndBranch(FIELD_SALEDELIVERY_PARTNERACCOUNTID, FIELD_SALEDELIVERY_BRANCHID, newEntries);
            ValidationHelper.validateResource(FIELD_SALEDELIVERY_DELIVERYDONEBY, newEntries);
        } else if(isUpdate) {
            StatusHelper.validateStatusEdit(OBJECT_SALEDELIVERY, FIELD_SALEDELIVERY_STATUS, oldEntries, newEntries);
            DocumentHelper.validateChangeInSystemFields(LIST_FIELDS_SYSTEM, oldEntries, newEntries);
            DocumentHelper.validateChangeInKeyFields(LIST_NON_EDITABLE_FIELDS, oldEntries, newEntries,queryTransactedObjectIds(newEntries));
            DocumentHelper.validateChangeInSourcePopulatedFields(LIST_FIELDS_SOURCEPOULATED, oldEntries, newEntries, FIELD_SALEDELIVERY_SALEORDERID);
            dfsHelper.DocumentStatusRestrictEdits_Edit(OBJECT_SALEDELIVERY, FIELD_SALEDELIVERY_STATUS, oldEntries, newEntries);
            dfsHelper.DocumentStatusRestrictFieldsEdits(OBJECT_SALEDELIVERY, FIELD_SALEDELIVERY_STATUS, oldEntries, newEntries);
            ValidationHelper.validateResource(FIELD_SALEDELIVERY_DELIVERYDONEBY, newEntries);
        } else if(isDelete) {
            dfsHelper.DocumentStatusRestrictEdits_Delete(OBJECT_SALEDELIVERY, FIELD_SALEDELIVERY_STATUS, oldEntries);
        }
    }catch (Exception error) {
        ExceptionLogHelper.logException(error);
        throw error;
    }
    }

    public static void postData(Boolean isInsert, Boolean isDelete, Boolean isUpdate, List<dmpl__DeliveryOrder__c> oldEntries, List<dmpl__DeliveryOrder__c> newEntries)
    {
        DocumentStatusDFSHelper dfsHelper = new DocumentStatusDFSHelper();

        if(isInsert){
            dfsHelper.DocumentStatusSetFlag(OBJECT_SALEDELIVERY, FIELD_SALEDELIVERY_STATUS, newEntries);
            dfsHelper.DocumentStatusReSetFlag(OBJECT_SALEDELIVERY, FIELD_SALEDELIVERY_STATUS, newEntries);
            DocumentNameHelper.generateDocumentName(newEntries);
            setDefaultAddress(newEntries);
            DiscountGroupHelper.setDefaultDiscountGroupIds(newEntries);
            // BranchTimeSlotBookingHelper.reserveSaleDeliveryTimeSlots(newEntries);
        }else if(isUpdate){
            dfsHelper.DocumentStatusSetFlag(OBJECT_SALEDELIVERY, FIELD_SALEDELIVERY_STATUS, oldEntries, newEntries);
            dfsHelper.DocumentStatusReSetFlag(OBJECT_SALEDELIVERY, FIELD_SALEDELIVERY_STATUS, oldEntries, newEntries);
            // List<dmpl__DeliveryOrder__c> modifiedObjects = DocumentHelper.getModifiedNewObjects(new String[]{'dmpl__RequestedDeliveryTimeSlotId__c', 'dmpl__RequestedDeliveryDate__c', 'dmpl__IsConfirmed__c', 'dmpl__IsCancelled__c'}, oldEntries, newEntries);
            // if(modifiedObjects.size()>0){
            //     BranchTimeSlotBookingHelper.releaseSaleDeliveryTimeSlots(modifiedObjects);
            //     BranchTimeSlotBookingHelper.reserveSaleDeliveryTimeSlots(modifiedObjects);
            // }

            List<dmpl__DeliveryOrder__c>  modifiedObjects = DocumentHelper.getApprovedObjects(FIELD_SALEDELIVERY_PERFORMRELEASESHIPMENT, oldEntries, newEntries);
            if(modifiedObjects.size()>0){
                createShipmentDocument(modifiedObjects);
            }

            modifiedObjects = DocumentHelper.getApprovedObjects(FIELD_SALEDELIVERY_PERFORMPOPULATECHECKLIST, oldEntries, newEntries);
            if(modifiedObjects.size()>0){
                populateChecklistDetails(modifiedObjects);
            }

            modifiedObjects = DocumentHelper.getApprovedObjects('dmpl__IsILPostingApproved__c', oldEntries, newEntries);
            postIL(modifiedObjects);
            if(modifiedObjects.size()>0){
                for(dmpl__DeliveryOrder__c document : modifiedObjects){
                    document.dmpl__IsILPostingApproved__c = false;
                    document.dmpl__IsILPosted__c = true;
                }    
            }
            setDefaultAddress(newEntries,oldEntries);
            RoundOffHelper.setRoundOff(
                newEntries,
                'dmpl__TotalLineAmount__c',
                'dmpl__TotalTaxAmount2__c');
        }else if(isDelete){
                // BranchTimeSlotBookingHelper.releaseSaleDeliveryTimeSlots(oldEntries);
            }
    }

    public static void afterPostData(
        Boolean isInsert,
        Boolean isUpdate, 
        Boolean isDelete, 
        List<dmpl__DeliveryOrder__c> oldEntries,
        List<dmpl__DeliveryOrder__c> newEntries)
    {
        if(isUpdate)
        {
            List<dmpl__DeliveryOrder__c> modifiedObjects = DocumentHelper.getModifiedNewObjects('dmpl__Discount__c', oldEntries, newEntries);
            if(modifiedObjects.size()>0){
                updateDiscountInDeliveryOrderLines(modifiedObjects);
            }
        }
    }

    public static void createSaleDeliveryFromSaleOrder(List<dmpl__SaleOrder__c> saleOrders){
        createDeliveryFromSaleOrder(
            querySaleOrderLines(
                DocumentHelper.extractIds(saleOrders), 
                null),
            null);
    }

    public static CreateRelatedResult createSaleDeliveryFromSaleOrder(Id saleOrderId){
        return CreateRelatedResult.InitFrom(
            createDeliveryFromSaleOrder(
                querySaleOrderLines(
                    new List<Id>{saleOrderId}, 
                    null),
                null));
    }

    public static CreateRelatedResult createSaleDeliveryFromSaleOrder(List<SourceObjectInfo> orderLinesInfo){
        return CreateRelatedResult.InitFrom(
            createDeliveryFromSaleOrder(
                querySaleOrderLines(
                    null, 
                    SourceObjectInfo.extractIds(orderLinesInfo)),
                orderLinesInfo));
    }
    
    public static CreateRelatedResult createSaleDeliveryFromSaleOrder(Id deliveryOrderId, List<SourceObjectInfo> orderLinesInfo){
        return CreateRelatedResult.InitFrom(
            createDeliveryFromSaleOrder(
                deliveryOrderId, 
                querySaleOrderLines(null, SourceObjectInfo.extractIds(orderLinesInfo)),
                orderLinesInfo));
    }

    public static CreateRelatedResult createSaleDeliveryFromRepairOrder(List<dmpl__RepairOrder__c> repairOrders){
        throw new DMPLException('Not Supported');
        //return createDeliveryFromRepairOrderInternal(queryRepairOrderLines(DocumentHelper.extractIds(repairOrders), null));
    }

    public static CreateRelatedResult createSaleDeliveryFromRepairOrder(Id repairOrderId){
        throw new DMPLException('Not Supported');
        //return CreateRelatedResult.InitFrom(createDeliveryFromRepairOrderInternal(queryRepairOrderLines(new List<Id>{repairOrderId}, null)));
    }

    public static CreateRelatedResult createSaleDeliveryFromRepairOrder(List<SourceObjectInfo> orderLinesInfo){
        throw new DMPLException('Not Supported');
        // return CreateRelatedResult.InitFrom(
        //     createDeliveryFromRepairOrderInternal(queryRepairOrderLines(null, SourceObjectInfo.extractIds(orderLinesInfo))));
    }
    
    public static void createSaleDeliveryFromFulfillment(List<dmpl__InventoryFulfillment__c> fulfillments){
        createDeliveryFromFulfillment(
            queryFulfillmentAllocationLines(
                DocumentHelper.extractIds(fulfillments), null)
                ,null);
    }

    public static CreateRelatedResult createSaleDeliveryFromFulfillment(List<SourceObjectInfo> fulfillmentLineInfo){
        return CreateRelatedResult.InitFrom(
            createDeliveryFromFulfillment(
                queryFulfillmentAllocationLines(
                    null, 
                    SourceObjectInfo.extractIds(fulfillmentLineInfo)),
                fulfillmentLineInfo));
    }  

    public static CreateRelatedResult createSaleDeliveryFromFulfillment(Id fulfillmentId){
        return CreateRelatedResult.InitFrom(
            createDeliveryFromFulfillment(
                queryFulfillmentAllocationLines(New List<Id>{fulfillmentId}, null),null));
    }

    public static void createSaleDeliveryFromPicking(List<dmpl__InventoryFulfillment__c> fulfillments){
        createDeliveryFromPicking(
            queryFulfillmentPickingLines(
                DocumentHelper.extractIds(fulfillments), null)
                ,null);
    }

    public static CreateRelatedResult createSaleDeliveryFromPicking(List<SourceObjectInfo> fulfillmentLineInfo){
        return CreateRelatedResult.InitFrom(
            createDeliveryFromPicking(
                queryFulfillmentPickingLines(
                    null, 
                    SourceObjectInfo.extractIds(fulfillmentLineInfo)),
                fulfillmentLineInfo));
    }  

    public static CreateRelatedResult createSaleDeliveryFromPicking(Id fulfillmentId){
        return CreateRelatedResult.InitFrom(
            createDeliveryFromPicking(
                queryFulfillmentPickingLines(New List<Id>{fulfillmentId}, null),null));
    }

    public static CreateRelatedResult createSaleDeliveryFromPurchaseReturn(List<SourceObjectInfo> purchaseReturnLinesInfo){
        return CreateRelatedResult.InitFrom(
            createDeliveryFromPurchaseReturn(
                queryPurchaseReturnLines(
                    null, 
                    SourceObjectInfo.extractIds(purchaseReturnLinesInfo)),
                    purchaseReturnLinesInfo));
    }  

    public static CreateRelatedResult createSaleDeliveryFromBillReturn(List<SourceObjectInfo> billReturnLinesInfo){
        return CreateRelatedResult.InitFrom(
            createDeliveryFromBillReturn(
                queryBillReturnLines(
                    null, 
                    SourceObjectInfo.extractIds(billReturnLinesInfo)),
                    billReturnLinesInfo));
    }  

    public static CreateRelatedResult createSaleDeliveryFromPurchaseReturn(Id purchaseReturnId){
        return CreateRelatedResult.InitFrom(
            createDeliveryFromPurchaseReturn(
                queryPurchaseReturnLines(New List<Id>{purchaseReturnId}, null),null));
    }

    public static CreateRelatedResult createSaleDeliveryFromBillReturn(Id billReturnId){
        return CreateRelatedResult.InitFrom(
            createDeliveryFromBillReturn(
                queryBillReturnLines(New List<Id>{billReturnId}, null),null));
    }
    
    public static void createShipmentDocument(List<SourceObjectInfo> orderLinesInfo){
        if(orderLinesInfo == null || orderLinesInfo.size() ==0){
            return;
        }
        ShipmentHelper.createShipmentFromDelivery(orderLinesInfo);
    }

    public static void createShipmentDocument(List<dmpl__DeliveryOrder__c> lineEntries){
        ShipmentHelper.createShipmentFromDelivery(lineEntries);
        SecurityHelper.ensureCanWriteField('dmpl__PerformReleaseShipment__c', 'dmpl__DeliveryOrder__c');
        SecurityHelper.ensureCanWriteField('dmpl__IsShipmentReleased__c', 'dmpl__DeliveryOrder__c');
        for(dmpl__DeliveryOrder__c lineEntry : lineEntries){
            lineEntry.dmpl__PerformReleaseShipment__c = false;
            lineEntry.dmpl__IsShipmentReleased__c = true;
        }
    }

    public static CreateRelatedResult postIL(Id deliveryId){
        return postDeliveryDocument(queryDeliveryLines(new List<Id>{ deliveryId }));
     }
 
    public static CreateRelatedResult postIL(List<SourceObjectInfo> orderLinesInfo, Id deliveryId){
        return postDeliveryDocument(queryDeliveryLinesForLines(SourceObjectInfo.extractIds(orderLinesInfo)));
    }

    public static void postIL(List<dmpl__DeliveryOrder__c> modifiedDocs){
        dmpl__CreateRelatedSetting__mdt setting = CreateRelatedSettingHelper.getCreateRelatedSettings(
            'dmpl__DeliveryOrder__c',
            'Post IL');
        if(setting == null){
            postDeliveryDocument(queryDeliveryLines(DocumentHelper.extractIds(modifiedDocs)));
        }else {
            for(dmpl__DeliveryOrder__c delivery : modifiedDocs){
                DocumentSelectorController.releaseDocumentDirect(setting.Id, delivery.Id);
            }
        }
    }

    private static CreateRelatedResult postDeliveryDocument(List<dmpl__DeliveryOrderLine__c> deliveryLines){
        for(dmpl__DeliveryOrderLine__c line : deliveryLines){
            line.dmpl__IsILPostingApproved__c = true;
        }
        //
        try {
            skipValidations = true;
            return CreateRelatedResult.InitFrom(Database.update(deliveryLines)); 
        } finally {
            skipValidations = false;
        }
    }

    @testVisible
    private static void updateDiscountInDeliveryOrderLines(List<dmpl__DeliveryOrder__c> modifiedObjects)
    {
        Map<Id,dmpl__DeliveryOrder__c> deliveryOrders = new Map<Id,dmpl__DeliveryOrder__c>(modifiedObjects);
        List<dmpl__DeliveryOrderLine__c> deliveryOrderLines = [SELECT Id, Name, dmpl__DeliveryId__c,  dmpl__Discount__c FROM dmpl__DeliveryOrderLine__c WHERE dmpl__DeliveryId__c IN : DocumentHelper.extractIds(modifiedObjects)];
        if(deliveryOrderLines.size() > 0){
            for(dmpl__DeliveryOrderLine__c line : deliveryOrderLines){
                dmpl__DeliveryOrder__c order = deliveryOrders.get(line.dmpl__DeliveryId__c);
                line.dmpl__Discount__c = order.dmpl__Discount__c;
            }
            SecurityHelper.ensureCanWriteFields(new string[]{'dmpl__Discount__c'}, 'dmpl__DeliveryOrderLine__c');
            update deliveryOrderLines;
        }
    }

    public static void populateChecklistDetails(List<dmpl__DeliveryOrder__c> delveryOrders){
        ChecklistLineHelper.createChecklistLines(delveryOrders);
    }

    private static Map<Id, dmpl__DeliveryOrder__c> createDeliveryFromSaleOrder(
        List<dmpl__SaleOrderLine__c> saleOrderLines,
        List<SourceObjectInfo> saleOrderLineInfo){
        if(saleOrderLines.size() == 0){
            throw new DMPLException(String.format(String.valueOf(System.Label.Generic_EmptyActionParam), new String[]{dmpl__SaleOrderLine__c.class.getName()}));
        }

        Map<Id, dmpl__DeliveryOrder__c> deliverOrderDocuments = new Map<Id,dmpl__DeliveryOrder__c>();
        Map<Id, List<dmpl__DeliveryOrderLine__c>> deliverOrderLines = new Map<Id, List<dmpl__DeliveryOrderLine__c>>();
        Map<Id, dmpl__SaleInvoiceLine__c> saleInvoiceLines = queryRelatedSaleInvoiceLines(saleOrderLines);
        for(dmpl__SaleOrderLine__c saleOrderLine : saleOrderLines){
            if(saleOrderLine.dmpl__ItemId__r !=null 
                && saleOrderLine.dmpl__PendingDeliveryQuantity__c>0){
                dmpl__DeliveryOrder__c deliveryOrder = null;
                SourceObjectInfo objectInfo = SourceObjectInfo.getSourceObjectInfo(saleOrderLineInfo, saleOrderLine.Id);
                if(deliverOrderDocuments.containsKey(saleOrderLine.dmpl__SaleOrderId__c)){
                    deliveryOrder = deliverOrderDocuments.get(saleOrderLine.dmpl__SaleOrderId__c);
                }else if(objectInfo!=null){
                    deliveryOrder = queryDeliveryOrderDocument(
                        objectInfo.getDestinationObjectId(
                            saleOrderLine.dmpl__SaleOrderId__c));
                }
                if(deliveryOrder == null){
                    deliveryOrder = createDeliveryDocumentFromSaleOrder(saleOrderLine);
                }
                if(!deliverOrderDocuments.containsKey(saleOrderLine.dmpl__SaleOrderId__c)){
                    deliverOrderDocuments.put(saleOrderLine.dmpl__SaleOrderId__c, deliveryOrder);
                }
                if(!deliverOrderLines.containsKey(saleOrderLine.dmpl__SaleOrderId__c)){
                    deliverOrderLines.put(saleOrderLine.dmpl__SaleOrderId__c, new List<dmpl__DeliveryOrderLine__c>());
                }

                deliverOrderLines.get(saleOrderLine.dmpl__SaleOrderId__c).add(
                    createDeliveryOrderLineFromSaleOrderLine(
                        saleOrderLine,
                        saleInvoiceLines.get(saleOrderLine.Id), 
                        saleOrderLineInfo));
            }
        }
        //
        if(deliverOrderLines.size() >0){
            Savepoint sp = Database.setSavepoint();
            try {
                SecurityHelper.ensureCanCreateObject('dmpl__DeliveryOrder__c');
                SecurityHelper.ensureCanCreateFields(new string[]{'dmpl__SaleOrderId__c','dmpl__BranchId__c','dmpl__PartnerAccountId__c','dmpl__DocumentDate__c','dmpl__AccountId__c'}, 'dmpl__DeliveryOrder__c');
                upsert deliverOrderDocuments.values();
                List<dmpl__DeliveryOrderLine__c> linesToInsert = new List<dmpl__DeliveryOrderLine__c>();
                for(Id soId : deliverOrderDocuments.keySet()){
                    dmpl__DeliveryOrder__c deliveryOrder = deliverOrderDocuments.get(soId);
                    List<dmpl__DeliveryOrderLine__c> docLines = deliverOrderLines.get(soId);
                    for(dmpl__DeliveryOrderLine__c doLIne : docLines){
                        doLIne.dmpl__DeliveryId__c = deliveryOrder.Id;
                        linesToInsert.add(doLIne);
                    }    
                }
                SecurityHelper.ensureCanCreateObject('dmpl__DeliveryOrderLine__c');
                SecurityHelper.ensureCanCreateFields(new string[]{'dmpl__SaleOrderLineId__c','dmpl__ItemId__c','dmpl__SKUId__c','dmpl__Quantity__c','dmpl__AssetId__c'}, 'dmpl__DeliveryOrderLine__c');
                insert linesToInsert;
            } catch (Exception e) {
                Database.rollback(sp);
                throw e;
            }
        }
        return deliverOrderDocuments;
    }

    private static Map<Id, dmpl__DeliveryOrderLine__c>  createDeliveryFromSaleOrder(
        Id deliveryOrderId, 
        List<dmpl__SaleOrderLine__c> saleOrderLines, 
        List<SourceObjectInfo> saleOrderLineInfo){
        Map<Id, dmpl__DeliveryOrderLine__c> result = new Map<Id, dmpl__DeliveryOrderLine__c>();
        if(saleOrderLines.size() == 0){
            throw new DMPLException(String.format(String.valueOf(System.Label.Generic_EmptyActionParam), new String[]{dmpl__SaleOrderLine__c.class.getName()}));
        }
        Map<Id, dmpl__DeliveryOrder__c> deliverOrderDocuments = new Map<Id, dmpl__DeliveryOrder__c>([SELECT Id, Name FROM dmpl__DeliveryOrder__c WHERE Id = : deliveryOrderId]);
        List<dmpl__DeliveryOrderLine__c> deliverOrderLines = new List<dmpl__DeliveryOrderLine__c>();
        Map<Id, dmpl__SaleInvoiceLine__c> saleInvoiceLines = queryRelatedSaleInvoiceLines(saleOrderLines);
        for(dmpl__SaleOrderLine__c saleOrderLine : saleOrderLines){
            if(saleOrderLine.dmpl__ItemId__r !=null 
                && saleOrderLine.dmpl__PendingDeliveryQuantity__c>0){
                dmpl__DeliveryOrder__c deliveryOrder = deliverOrderDocuments.get(deliveryOrderId);
                deliverOrderLines.add(createDeliveryOrderLineFromSaleOrderLine(saleOrderLine,saleInvoiceLines.get(saleOrderLine.Id), saleOrderLineInfo));
            }
        }
        //
        if(deliverOrderLines.size() >0){
            Savepoint sp = Database.setSavepoint();
            try {
                SecurityHelper.ensureCanCreateObject('dmpl__DeliveryOrder__c');
                SecurityHelper.ensureCanCreateFields(new string[]{'dmpl__SaleOrderId__c','dmpl__BranchId__c','dmpl__PartnerAccountId__c','dmpl__DocumentDate__c','dmpl__AccountId__c'}, 'dmpl__DeliveryOrder__c');
                List<dmpl__DeliveryOrderLine__c> linesToInsert = new List<dmpl__DeliveryOrderLine__c>();
                for(Id doId : deliverOrderDocuments.keySet()){
                    dmpl__DeliveryOrder__c deliveryOrder = deliverOrderDocuments.get(doId);
                    for(dmpl__DeliveryOrderLine__c doLIne : deliverOrderLines){
                        doLIne.dmpl__DeliveryId__c = deliveryOrder.Id;
                        linesToInsert.add(doLIne);
                    }    
                }
                SecurityHelper.ensureCanCreateObject('dmpl__DeliveryOrderLine__c');
                SecurityHelper.ensureCanCreateFields(new string[]{'dmpl__SaleOrderLineId__c','dmpl__ItemId__c','dmpl__SKUId__c','dmpl__Quantity__c','dmpl__AssetId__c'}, 'dmpl__DeliveryOrderLine__c');
                insert linesToInsert;
                result = new Map<Id, dmpl__DeliveryOrderLine__c>(linesToInsert);
            } catch (Exception e) {
                Database.rollback(sp);
                throw e;
            }
        }
        return result;
    }

    private static Map<Id, dmpl__DeliveryOrder__c> createDeliveryFromFulfillment(
        List<dmpl__InventoryFulfillmentAllocationLine__c> fulfillmentAllocationLines, 
        List<SourceObjectInfo> allocationLinesInfo)
    {
        if(fulfillmentAllocationLines.size() == 0){
            throw new DMPLException(String.format(String.valueOf(System.Label.Generic_EmptyActionParam), new String[]{dmpl__InventoryFulfillmentAllocationLine__c.class.getName()}));
        }

        Map<Id, dmpl__DeliveryOrder__c> deliverOrderDocuments = new Map<Id,dmpl__DeliveryOrder__c>();
        Map<Id, List<dmpl__DeliveryOrderLine__c>> deliverOrderLines = new Map<Id, List<dmpl__DeliveryOrderLine__c>>();

        for(dmpl__InventoryFulfillmentAllocationLine__c fulfillmentAllocationLine : fulfillmentAllocationLines){
            if(fulfillmentAllocationLine.dmpl__PendingDeliveryQuantity__c>0){
                dmpl__DeliveryOrder__c deliveryOrder = null;
                SourceObjectInfo objectInfo = SourceObjectInfo.getSourceObjectInfo(allocationLinesInfo, fulfillmentAllocationLine.Id);
                if(deliverOrderDocuments.containsKey(fulfillmentAllocationLine.dmpl__FulfillmentOrderId__c)){
                    deliveryOrder = deliverOrderDocuments.get(fulfillmentAllocationLine.dmpl__FulfillmentOrderId__c);
                }else if(objectInfo!=null){
                    deliveryOrder = queryDeliveryOrderDocument(
                        objectInfo.getDestinationObjectId(
                            fulfillmentAllocationLine.dmpl__FulfillmentOrderId__c));
                }
                if(deliveryOrder == null){
                    deliveryOrder = createDeliveryDocumentFromFulfillment(fulfillmentAllocationLine);
                }
                if(!deliverOrderDocuments.containsKey(fulfillmentAllocationLine.dmpl__FulfillmentOrderId__c)){
                    deliverOrderDocuments.put(fulfillmentAllocationLine.dmpl__FulfillmentOrderId__c, deliveryOrder);
                }
                if(!deliverOrderLines.containsKey(fulfillmentAllocationLine.dmpl__FulfillmentOrderId__c)){
                    deliverOrderLines.put(fulfillmentAllocationLine.dmpl__FulfillmentOrderId__c, new List<dmpl__DeliveryOrderLine__c>());
                }
                deliverOrderLines.get(fulfillmentAllocationLine.dmpl__FulfillmentOrderId__c).add(
                    createDeliveryOrderLineFromFulfillmentAllocationLines(fulfillmentAllocationLine, allocationLinesInfo));
            }
        }
        //
        if(deliverOrderLines.size() >0){
            Savepoint sp = Database.setSavepoint();
            try {
                SecurityHelper.ensureCanCreateObject('dmpl__DeliveryOrder__c');
                SecurityHelper.ensureCanCreateFields(new string[]{'dmpl__FulfillmentId__c','dmpl__BranchId__c','dmpl__PartnerAccountId__c','dmpl__DocumentDate__c','dmpl__AccountId__c'}, 'dmpl__DeliveryOrder__c');
                upsert deliverOrderDocuments.values();
                List<dmpl__DeliveryOrderLine__c> linesToInsert = new List<dmpl__DeliveryOrderLine__c>();
                for(Id soId : deliverOrderDocuments.keySet()){
                    dmpl__DeliveryOrder__c deliveryOrder = deliverOrderDocuments.get(soId);
                    List<dmpl__DeliveryOrderLine__c> docLines = deliverOrderLines.get(soId);
                    for(dmpl__DeliveryOrderLine__c doLIne : docLines){
                        doLIne.dmpl__DeliveryId__c = deliveryOrder.Id;
                        linesToInsert.add(doLIne);
                    }    
                }
                SecurityHelper.ensureCanCreateObject('dmpl__DeliveryOrderLine__c');
                SecurityHelper.ensureCanCreateFields(new string[]{'dmpl__FulfillmentAllocationLineId__c','dmpl__SaleOrderLineId__c','dmpl__ItemId__c','dmpl__SKUId__c','dmpl__Quantity__c','dmpl__ItemLotId__c','dmpl__AssetId__c'}, 'dmpl__DeliveryOrderLine__c');

                insert linesToInsert;
            } catch (Exception e) {
                Database.rollback(sp);
                throw e;
            }
        }
        return deliverOrderDocuments;
    }
    
    private static Map<Id, dmpl__DeliveryOrder__c> createDeliveryFromPicking(
        List<dmpl__InventoryFulfillmentPickingLine__c> fulfillmentPickingLines, 
        List<SourceObjectInfo> pickingLinesInfo)
    {
        if(fulfillmentPickingLines.size() == 0){
            throw new DMPLException(
                String.format(
                    String.valueOf(
                        System.Label.Generic_EmptyActionParam), 
                        new String[]{dmpl__InventoryFulfillmentPickingLine__c.class.getName()}));
        }

        Map<Id, dmpl__DeliveryOrder__c> deliverOrderDocuments = new Map<Id,dmpl__DeliveryOrder__c>();
        Map<Id, List<dmpl__DeliveryOrderLine__c>> deliverOrderLines = new Map<Id, List<dmpl__DeliveryOrderLine__c>>();

        for(dmpl__InventoryFulfillmentPickingLine__c fulfillmentPickingLine : fulfillmentPickingLines){
            if(fulfillmentPickingLine.dmpl__PendingDeliveryQuantity__c>0){
                dmpl__DeliveryOrder__c deliveryOrder = null;
                SourceObjectInfo objectInfo = SourceObjectInfo.getSourceObjectInfo(pickingLinesInfo, fulfillmentPickingLine.Id);
                if(deliverOrderDocuments.containsKey(fulfillmentPickingLine.dmpl__FulfillmentOrderId__c)){
                    deliveryOrder = deliverOrderDocuments.get(fulfillmentPickingLine.dmpl__FulfillmentOrderId__c);
                }else if(objectInfo!=null){
                    deliveryOrder = queryDeliveryOrderDocument(
                        objectInfo.getDestinationObjectId(
                            fulfillmentPickingLine.dmpl__FulfillmentOrderId__c));
                }
                if(deliveryOrder == null){
                    deliveryOrder = createDeliveryDocumentFromFulfillment(fulfillmentPickingLine);
                }
                if(!deliverOrderDocuments.containsKey(fulfillmentPickingLine.dmpl__FulfillmentOrderId__c)){
                    deliverOrderDocuments.put(fulfillmentPickingLine.dmpl__FulfillmentOrderId__c, deliveryOrder);
                }
                if(!deliverOrderLines.containsKey(fulfillmentPickingLine.dmpl__FulfillmentOrderId__c)){
                    deliverOrderLines.put(fulfillmentPickingLine.dmpl__FulfillmentOrderId__c, new List<dmpl__DeliveryOrderLine__c>());
                }        
                deliverOrderLines.get(fulfillmentPickingLine.dmpl__FulfillmentOrderId__c).add(
                    createDeliveryOrderLineFromFulfillmentPickingLines(
                        fulfillmentPickingLine, 
                        pickingLinesInfo));
            }
        }
        //
        if(deliverOrderLines.size() >0){
            Savepoint sp = Database.setSavepoint();
            try {
                SecurityHelper.ensureCanCreateObject('dmpl__DeliveryOrder__c');
                SecurityHelper.ensureCanCreateFields(new string[]{'dmpl__FulfillmentId__c','dmpl__BranchId__c','dmpl__PartnerAccountId__c','dmpl__DocumentDate__c','dmpl__AccountId__c'}, 'dmpl__DeliveryOrder__c');
                upsert deliverOrderDocuments.values();
                List<dmpl__DeliveryOrderLine__c> linesToInsert = new List<dmpl__DeliveryOrderLine__c>();
                for(Id soId : deliverOrderDocuments.keySet()){
                    dmpl__DeliveryOrder__c deliveryOrder = deliverOrderDocuments.get(soId);
                    List<dmpl__DeliveryOrderLine__c> docLines = deliverOrderLines.get(soId);
                    for(dmpl__DeliveryOrderLine__c doLIne : docLines){
                        doLIne.dmpl__DeliveryId__c = deliveryOrder.Id;
                        linesToInsert.add(doLIne);
                    }    
                }
                SecurityHelper.ensureCanCreateObject('dmpl__DeliveryOrderLine__c');
                SecurityHelper.ensureCanCreateFields(new string[]{'dmpl__FulfillmentAllocationLineId__c','dmpl__SaleOrderLineId__c','dmpl__ItemId__c','dmpl__SKUId__c','dmpl__Quantity__c','dmpl__ItemLotId__c','dmpl__AssetId__c'}, 'dmpl__DeliveryOrderLine__c');

                insert linesToInsert;
            } catch (Exception e) {
                Database.rollback(sp);
                throw e;
            }
        }
        return deliverOrderDocuments;
    }

    private static Map<Id, dmpl__DeliveryOrder__c> createDeliveryFromPurchaseReturn(
        List<dmpl__PurchaseReturnLine__c> purchaseReturnLines, 
        List<SourceObjectInfo> purchaseReturnLinesInfo)
    {
        if(purchaseReturnLines.size() == 0){
            throw new DMPLException(String.format(String.valueOf(System.Label.Generic_EmptyActionParam), new String[]{dmpl__PurchaseReturnLine__c.class.getName()}));
        }

        Map<Id, dmpl__DeliveryOrder__c> deliverOrderDocuments = new Map<Id,dmpl__DeliveryOrder__c>();
        Map<Id, List<dmpl__DeliveryOrderLine__c>> deliverOrderLines = new Map<Id, List<dmpl__DeliveryOrderLine__c>>();

        for(dmpl__PurchaseReturnLine__c purchaseReturnLine : purchaseReturnLines){
            if(purchaseReturnLine.dmpl__PendingDeliveryQuantity__c>0){
                dmpl__DeliveryOrder__c deliveryOrder = null;
                if(deliverOrderDocuments.containsKey(purchaseReturnLine.dmpl__PurchaseReturnId__c)){
                    deliveryOrder = deliverOrderDocuments.get(purchaseReturnLine.dmpl__PurchaseReturnId__c);
                }else {
                    deliveryOrder = createDeliveryDocumentFromPurchaseReturn(purchaseReturnLine);
                    deliverOrderDocuments.put(purchaseReturnLine.dmpl__PurchaseReturnId__c, deliveryOrder);
                    deliverOrderLines.put(purchaseReturnLine.dmpl__PurchaseReturnId__c, new List<dmpl__DeliveryOrderLine__c>());
                }
        
                deliverOrderLines.get(purchaseReturnLine.dmpl__PurchaseReturnId__c).add(
                    createDeliveryOrderLineFromPurchaseReturnLine(purchaseReturnLine, purchaseReturnLinesInfo));
            }
        }
        //
        if(deliverOrderLines.size() >0){
            Savepoint sp = Database.setSavepoint();
            try {
                SecurityHelper.ensureCanCreateObject('dmpl__DeliveryOrder__c');
                SecurityHelper.ensureCanCreateFields(new string[]{'dmpl__FulfillmentId__c','dmpl__BranchId__c','dmpl__PartnerAccountId__c','dmpl__DocumentDate__c','dmpl__AccountId__c'}, 'dmpl__DeliveryOrder__c');
                insert deliverOrderDocuments.values();
                List<dmpl__DeliveryOrderLine__c> linesToInsert = new List<dmpl__DeliveryOrderLine__c>();
                for(Id soId : deliverOrderDocuments.keySet()){
                    dmpl__DeliveryOrder__c deliveryOrder = deliverOrderDocuments.get(soId);
                    List<dmpl__DeliveryOrderLine__c> docLines = deliverOrderLines.get(soId);
                    for(dmpl__DeliveryOrderLine__c doLIne : docLines){
                        doLIne.dmpl__DeliveryId__c = deliveryOrder.Id;
                        linesToInsert.add(doLIne);
                    }    
                }
                SecurityHelper.ensureCanCreateObject('dmpl__DeliveryOrderLine__c');
                SecurityHelper.ensureCanCreateFields(new string[]{'dmpl__FulfillmentAllocationLineId__c','dmpl__SaleOrderLineId__c','dmpl__ItemId__c','dmpl__SKUId__c','dmpl__Quantity__c','dmpl__ItemLotId__c','dmpl__AssetId__c'}, 'dmpl__DeliveryOrderLine__c');

                insert linesToInsert;
            } catch (Exception e) {
                Database.rollback(sp);
                throw e;
            }
        }
        return deliverOrderDocuments;
    }

    private static Map<Id, dmpl__DeliveryOrder__c> createDeliveryFromBillReturn(
        List<dmpl__BillReturnLine__c> BillReturnLines, 
        List<SourceObjectInfo> BillReturnLinesInfo)
    {
        if(BillReturnLines.size() == 0){
            throw new DMPLException(String.format(String.valueOf(System.Label.Generic_EmptyActionParam), new String[]{dmpl__BillReturnLine__c.class.getName()}));
        }

        Map<Id, dmpl__DeliveryOrder__c> deliverOrderDocuments = new Map<Id,dmpl__DeliveryOrder__c>();
        Map<Id, List<dmpl__DeliveryOrderLine__c>> deliverOrderLines = new Map<Id, List<dmpl__DeliveryOrderLine__c>>();

        for(dmpl__BillReturnLine__c BillReturnLine : BillReturnLines){
            if(BillReturnLine.dmpl__PendingDeliveryQuantity__c>0){
                dmpl__DeliveryOrder__c deliveryOrder = null;
                if(deliverOrderDocuments.containsKey(BillReturnLine.dmpl__BillReturnId__c)){
                    deliveryOrder = deliverOrderDocuments.get(BillReturnLine.dmpl__BillReturnId__c);
                }else {
                    deliveryOrder = createDeliveryDocumentFromBillReturn(BillReturnLine);
                    deliverOrderDocuments.put(BillReturnLine.dmpl__BillReturnId__c, deliveryOrder);
                    deliverOrderLines.put(BillReturnLine.dmpl__BillReturnId__c, new List<dmpl__DeliveryOrderLine__c>());
                }
        
                deliverOrderLines.get(BillReturnLine.dmpl__BillReturnId__c).add(
                    createDeliveryOrderLineFromBillReturnLine(BillReturnLine, BillReturnLinesInfo));
            }
        }
        //
        if(deliverOrderLines.size() >0){
            Savepoint sp = Database.setSavepoint();
            try {
                SecurityHelper.ensureCanCreateObject('dmpl__DeliveryOrder__c');
                SecurityHelper.ensureCanCreateFields(new string[]{'dmpl__BillReturnId__c','dmpl__BranchId__c','dmpl__PartnerAccountId__c','dmpl__DocumentDate__c','dmpl__AccountId__c'}, 'dmpl__DeliveryOrder__c');
                insert deliverOrderDocuments.values();
                List<dmpl__DeliveryOrderLine__c> linesToInsert = new List<dmpl__DeliveryOrderLine__c>();
                for(Id soId : deliverOrderDocuments.keySet()){
                    dmpl__DeliveryOrder__c deliveryOrder = deliverOrderDocuments.get(soId);
                    List<dmpl__DeliveryOrderLine__c> docLines = deliverOrderLines.get(soId);
                    for(dmpl__DeliveryOrderLine__c doLIne : docLines){
                        doLIne.dmpl__DeliveryId__c = deliveryOrder.Id;
                        linesToInsert.add(doLIne);
                    }    
                }
                SecurityHelper.ensureCanCreateObject('dmpl__DeliveryOrderLine__c');
                SecurityHelper.ensureCanCreateFields(new string[]{'dmpl__BillReturnLineId__c','dmpl__ItemId__c','dmpl__SKUId__c','dmpl__Quantity__c','dmpl__ItemLotId__c','dmpl__AssetId__c'}, 'dmpl__DeliveryOrderLine__c');

                insert linesToInsert;
            } catch (Exception e) {
                Database.rollback(sp);
                throw e;
            }
        }
        return deliverOrderDocuments;
    }

    private static dmpl__DeliveryOrder__c createDeliveryDocumentFromSaleOrder(dmpl__SaleOrderLine__c saleOrderLine)
    {
        return new dmpl__DeliveryOrder__c(
            dmpl__SaleOrderId__c = saleOrderLine.dmpl__SaleOrderId__c,
            dmpl__BranchId__c = saleOrderLine.dmpl__SaleOrderId__r.dmpl__BranchId__c,
            dmpl__PartnerAccountId__c = saleOrderLine.dmpl__SaleOrderId__r.dmpl__PartnerAccountId__c,
            dmpl__DocumentDate__c = date.today(),
            dmpl__AccountId__c = saleOrderLine.dmpl__SaleOrderId__r.dmpl__AccountId__c
        );
    }
   
    private static dmpl__DeliveryOrderLine__c createDeliveryOrderLineFromSaleOrderLine(
        dmpl__SaleOrderLine__c saleOrderLine, 
        dmpl__SaleInvoiceLine__c saleInvoiceLine, 
        List<SourceObjectInfo> saleOrderLineInfo){
        Decimal quantity = (saleOrderLineInfo != null && saleOrderLineInfo.size() > 0) ? 
            SourceObjectInfo.getRequestedQuantity(
                saleOrderLineInfo, 
                saleOrderLine.Id) : saleOrderLine.dmpl__PendingDeliveryQuantity__c;
        Decimal invoiceQuantity = quantity > saleOrderLine.dmpl__InvoiceQuantity__c ? 
            saleOrderLine.dmpl__InvoiceQuantity__c : quantity;
        return new dmpl__DeliveryOrderLine__c(
            dmpl__SaleOrderLineId__c = saleOrderLine.Id,
            dmpl__ItemId__c = saleOrderLine.dmpl__ItemId__c,
            dmpl__SKUId__c = saleOrderLine.dmpl__SKUId__c,
            dmpl__ItemLotId__c = (saleInvoiceLine != null) ? saleInvoiceLine.dmpl__ItemLotId__c : null,
            dmpl__ItemLotTypeId__c = saleOrderLine.dmpl__ItemLotTypeId__c,
            dmpl__Quantity__c = quantity,
            dmpl__InvoicedQuantity__c = saleInvoiceLine != null ? saleInvoiceLine.dmpl__Quantity__c : invoiceQuantity, 
            dmpl__PurchaseOrderLineId__c = saleOrderLine.dmpl__PurchaseOrderLineId__c,
            dmpl__AssetId__c = saleInvoiceLine != null && !String.IsBlank(saleInvoiceLine.dmpl__AssetId__c) ? saleInvoiceLine.dmpl__AssetId__c : null,
            dmpl__StorageLocationId__c = saleInvoiceLine != null ? saleInvoiceLine.dmpl__StorageLocationId__c : null,
            dmpl__SaleInvoiceLineId__c = saleInvoiceLine != null ? saleInvoiceLine.Id : null
        );
    }

    private static dmpl__DeliveryOrder__c createDeliveryDocumentFromFulfillment(dmpl__InventoryFulfillmentAllocationLine__c allocationLine)
    {
        return new dmpl__DeliveryOrder__c(
            dmpl__FulfillmentId__c = allocationLine.dmpl__FulfillmentOrderId__c,
            dmpl__BranchId__c = allocationLine.dmpl__FulfillmentOrderId__r.dmpl__BranchId__c,
            dmpl__PartnerAccountId__c = allocationLine.dmpl__FulfillmentOrderId__r.dmpl__PartnerAccountId__c,
            dmpl__DocumentDate__c = date.today(),
            dmpl__AccountId__c = allocationLine.dmpl__FulfillmentOrderId__r.dmpl__AccountId__c,
            dmpl__SaleOrderId__c = allocationLine.dmpl__FulfillmentOrderId__r?.dmpl__SaleOrderId__c,
            dmpl__RepairOrderId__c = allocationLine.dmpl__FulfillmentOrderId__r?.dmpl__RepairOrderId__c
        );
    }

    private static dmpl__DeliveryOrder__c createDeliveryDocumentFromFulfillment(
        dmpl__InventoryFulfillmentPickingLine__c pickingLine){
        return new dmpl__DeliveryOrder__c(
            dmpl__FulfillmentId__c = pickingLine.dmpl__FulfillmentOrderId__c,
            dmpl__BranchId__c =pickingLine.dmpl__FulfillmentOrderId__r.dmpl__BranchId__c,
            dmpl__PartnerAccountId__c = pickingLine.dmpl__FulfillmentOrderId__r.dmpl__PartnerAccountId__c,
            dmpl__DocumentDate__c = date.today(),
            dmpl__AccountId__c = pickingLine.dmpl__FulfillmentOrderId__r.dmpl__AccountId__c,
            dmpl__SaleOrderId__c = pickingLine.dmpl__FulfillmentOrderId__r?.dmpl__SaleOrderId__c,
            dmpl__RepairOrderId__c = pickingLine.dmpl__FulfillmentOrderId__r?.dmpl__RepairOrderId__c
        );
    }
    
    private static dmpl__DeliveryOrder__c createDeliveryDocumentFromPurchaseReturn(dmpl__PurchaseReturnLine__c purchaseReturnLine)
    {
        return new dmpl__DeliveryOrder__c(
            dmpl__PurchaseReturnId__c = purchaseReturnLine.dmpl__PurchaseReturnId__c,
            dmpl__BranchId__c = purchaseReturnLine.dmpl__PurchaseReturnId__r.dmpl__BranchId__c,
            dmpl__PartnerAccountId__c = purchaseReturnLine.dmpl__PurchaseReturnId__r.dmpl__PartnerAccountId__c,
            dmpl__DocumentDate__c = date.today()
            // dmpl__AccountId__c = purchaseReturnLine.dmpl__PurchaseReturnId__r.dmpl__SupplierAccountId__c
        );
    }

    private static dmpl__DeliveryOrder__c createDeliveryDocumentFromBillReturn(dmpl__BillReturnLine__c billReturnLine)
    {
        return new dmpl__DeliveryOrder__c(
            dmpl__BillReturnId__c = billReturnLine.dmpl__BillReturnId__c,
            dmpl__BranchId__c = billReturnLine.dmpl__BillReturnId__r.dmpl__BranchId__c,
            dmpl__PartnerAccountId__c = billReturnLine.dmpl__BillReturnId__r.dmpl__PartnerAccountId__c,
            dmpl__DocumentDate__c = date.today()
            // dmpl__AccountId__c = billReturnLine.dmpl__PurchaseReturnId__r.dmpl__SupplierAccountId__c
        );
    }

    private static dmpl__DeliveryOrderLine__c createDeliveryOrderLineFromFulfillmentAllocationLines(dmpl__InventoryFulfillmentAllocationLine__c allocationLine, List<SourceObjectInfo> allocationLinesInfo)
    {
        Decimal requestedQty = SourceObjectInfo.getRequestedQuantity(allocationLinesInfo, allocationLine.Id);
        return new dmpl__DeliveryOrderLine__c(
            dmpl__FulfillmentAllocationLineId__c = allocationLine.Id,
            dmpl__SaleOrderLineId__c = allocationLine.dmpl__SaleOrderLineId__c,
            dmpl__ItemId__c = allocationLine.dmpl__ItemId__c,
            dmpl__SKUId__c = allocationLine.dmpl__SKUId__c,
            dmpl__ItemLotId__c = allocationLine.dmpl__ItemLotId__c,
            dmpl__Quantity__c = requestedQty >0 ? requestedQty : allocationLine.dmpl__PendingDeliveryQuantity__c,
            dmpl__AllocatedQuantity__c = requestedQty >0 ? requestedQty : allocationLine.dmpl__PendingDeliveryQuantity__c,
            dmpl__StorageLocationId__c = allocationLine.dmpl__StorageLocationId__c
        );
    }
    
    private static dmpl__DeliveryOrderLine__c createDeliveryOrderLineFromFulfillmentPickingLines(
        dmpl__InventoryFulfillmentPickingLine__c pickingLine, 
        List<SourceObjectInfo> pickingLinesInfo){
        Decimal requestedQty = SourceObjectInfo.getRequestedQuantity(
            pickingLinesInfo, 
            pickingLine.Id);
        return new dmpl__DeliveryOrderLine__c(
            dmpl__FulfillmentPickingLineId__c = pickingLine.Id,
            dmpl__FulfillmentAllocationLineId__c = pickingLine.dmpl__FulfillmentAllocationLineId__c,
            dmpl__SaleOrderLineId__c = pickingLine.dmpl__SaleOrderLineId__c,
            dmpl__ItemId__c = pickingLine.dmpl__ItemId__c,
            dmpl__SKUId__c = pickingLine.dmpl__SKUId__c,
            dmpl__Quantity__c = requestedQty >0 ? requestedQty : pickingLine.dmpl__PendingDeliveryQuantity__c,
            dmpl__PickedQuantity__c = requestedQty >0 ? requestedQty : pickingLine.dmpl__PendingDeliveryQuantity__c,
            dmpl__ItemLotId__c = pickingLine.dmpl__ItemLotId__c,
            dmpl__StorageLocationId__c = pickingLine.dmpl__StorageLocationId__c
        );
    }

    private static dmpl__DeliveryOrderLine__c createDeliveryOrderLineFromPurchaseReturnLine(dmpl__PurchaseReturnLine__c purchaseReturnLine, List<SourceObjectInfo> purchaseReturnLinesInfo)
    {
        Decimal requestedQty = SourceObjectInfo.getRequestedQuantity(purchaseReturnLinesInfo, purchaseReturnLine.Id);
        return new dmpl__DeliveryOrderLine__c(
            dmpl__PurchaseReturnLineId__c = purchaseReturnLine.Id,
            dmpl__ItemId__c = purchaseReturnLine.dmpl__ItemId__c,
            dmpl__SKUId__c = purchaseReturnLine.dmpl__SKUId__c,
            dmpl__Quantity__c = requestedQty >0 ? requestedQty : purchaseReturnLine.dmpl__PendingDeliveryQuantity__c,
            dmpl__ItemLotId__c = purchaseReturnLine.dmpl__ItemLotId__c,
            dmpl__StorageLocationId__c = purchaseReturnLine.dmpl__StorageLocationId__c
        );
    }

    private static dmpl__DeliveryOrderLine__c createDeliveryOrderLineFromBillReturnLine(dmpl__BillReturnLine__c billReturnLine, List<SourceObjectInfo> billReturnLinesInfo)
    {
        Decimal requestedQty = SourceObjectInfo.getRequestedQuantity(billReturnLinesInfo, billReturnLine.Id);
        return new dmpl__DeliveryOrderLine__c(
            dmpl__BillReturnLineId__c = billReturnLine.Id,
            dmpl__ItemId__c = billReturnLine.dmpl__ItemId__c,
            dmpl__SKUId__c = billReturnLine.dmpl__SKUId__c,
            dmpl__Quantity__c = requestedQty >0 ? requestedQty : billReturnLine.dmpl__PendingDeliveryQuantity__c,
            dmpl__ItemLotId__c = billReturnLine.dmpl__ItemLotId__c,
            dmpl__StorageLocationId__c = billReturnLine.dmpl__StorageLocationId__c
        );
    }

    private static void setDefaultAddress(List<dmpl__DeliveryOrder__c> newEntries){
        SecurityHelper.ensureCanWriteFields(new List<String>
        {
            FIELD_SALEDELIVERY_SHIPPINGADDRESS,
            FIELD_SALEDELIVERY_BILLINGADDRESS,
            'dmpl__BillingCity__c',
            'dmpl__BillingCountry__c',
            'dmpl__BillingPostalCode__c',
            'dmpl__BillingRegion__c',
            'dmpl__BillingState__c',
            'dmpl__BillingStreet__c',
            'dmpl__ShippingCity__c',
            'dmpl__ShippingCountry__c',
            'dmpl__ShippingPostalCode__c',
            'dmpl__ShippingRegion__c',
            'dmpl__ShippingState__c',
            'dmpl__ShippingStreet__c'
        }, OBJECT_SALEDELIVERY);

        List<Account> accounts = AccountHelper.getCachedAccounts(CollectionHelper.extractIds(newEntries, FIELD_SALEDELIVERY_ACCOUNTID));
        for(dmpl__DeliveryOrder__c order : newEntries){
            Account account = (Account)CollectionHelper.getObject(accounts, order.dmpl__AccountId__c);
            if(account!=null){
                AccountHelper.setDefaultAddress(order, account);
            }
        }
    }

    private static void setDefaultAddress(List<dmpl__DeliveryOrder__c> newEntries, List<dmpl__DeliveryOrder__c> oldEntries){
        SecurityHelper.ensureCanWriteFields(new List<String>
        {
            FIELD_SALEDELIVERY_SHIPPINGADDRESS,
            FIELD_SALEDELIVERY_BILLINGADDRESS
        }, OBJECT_SALEDELIVERY);
        Account account = null;
        List<Account> accounts = AccountHelper.getCachedAccounts(CollectionHelper.extractIds(newEntries, FIELD_SALEDELIVERY_ACCOUNTID));
        List<dmpl__DeliveryOrder__c> modifiedOrders = DocumentHelper.getModifiedNewObjects(FIELD_SALEDELIVERY_BILLINGADDRESSID, oldEntries, newEntries);
        for(dmpl__DeliveryOrder__c order : modifiedOrders){
            account = (Account)CollectionHelper.getObject(accounts, order.dmpl__AccountId__c);
            if(account!=null){
                AccountHelper.setDefaultAddress(order, account);
            }
        }
        
        modifiedOrders = DocumentHelper.getModifiedNewObjects(FIELD_SALEDELIVERY_SHIPPINGADDRESSID, oldEntries, newEntries);
        for(dmpl__DeliveryOrder__c order : modifiedOrders){
            account = (Account)CollectionHelper.getObject(accounts, order.dmpl__AccountId__c);
            if(account!=null){
                if(order.dmpl__ShippingAddressId__c!=null){
                    dmpl__ContactAddress__c address = (dmpl__ContactAddress__c)CollectionHelper.getObject(account.dmpl__ContactAddress__r, order.dmpl__ShippingAddressId__c);
                    if(address!=null){
                        order.dmpl__ShippingAddress__c = AccountHelper.formatAddress(address);
                    }
                }else {
                    order.dmpl__ShippingAddress__c = AccountHelper.formatAddress(account.ShippingAddress);
                }
            }
        }
    }

    private static List<dmpl__SaleOrderLine__c> querySaleOrderLines(List<Id> saleOrderIds, List<Id> saleOrderLineIds)
    {
        if(saleOrderIds == null){
            saleOrderIds = new List<Id>();
        }
        if(saleOrderLineIds == null){
            saleOrderLineIds = new List<Id>();
        }

        SecurityHelper.ensureCanReadFields(new string[]{'dmpl__TrackInventory__c','dmpl__TrackAsset__c'}, 'dmpl__Item__c');
        SecurityHelper.ensureCanReadFields(new string[]{'dmpl__PartnerAccountId__c',' dmpl__BranchId__c,','dmpl__AccountId__c','dmpl__DocumentDate__c'}, 'dmpl__SaleOrder__c');
        SecurityHelper.ensureCanReadFields(new string[]{'dmpl__ItemId__c','dmpl__SKUId__c','dmpl__UnitPrice__c','dmpl__UnitPrice2__c','dmpl__Quantity__c','dmpl__TaxGroupId__c','dmpl__InvoiceGroup__c','dmpl__PendingInvoiceQuantity__c','dmpl__ItemLotTypeId__c'}, 'dmpl__SaleOrderLine__c');
        return [SELECT Id,
            Name,
            dmpl__ItemId__c,
            dmpl__SKUId__c,
            dmpl__UnitPrice__c,
            dmpl__UnitPrice2__c,
            dmpl__Quantity__c,
            dmpl__PendingDeliveryQuantity__c,
            dmpl__ItemId__r.dmpl__TrackInventory__c,
            dmpl__ItemId__r.dmpl__TrackAsset__c,
            dmpl__ItemLotTypeId__c,
            dmpl__SaleOrderId__c,
            dmpl__InvoiceQuantity__c,
            dmpl__PurchaseOrderLineId__c,
            dmpl__SaleOrderId__r.dmpl__PartnerAccountId__c,
            dmpl__SaleOrderId__r.dmpl__BranchId__c,
            dmpl__SaleOrderId__r.dmpl__AccountId__c,
            dmpl__SaleOrderId__r.dmpl__DocumentDate__c
        FROM dmpl__SaleOrderLine__c
        WHERE dmpl__SaleOrderId__c IN :saleOrderIds OR Id IN :saleOrderLineIds
        ];
    }

    private static Map<Id, dmpl__SaleInvoiceLine__c> queryRelatedSaleInvoiceLines(
        List<dmpl__SaleOrderLine__c> saleOrderLines){
        List<Id> saleOrderLineIds = CollectionHelper.extractIds(saleOrderLines);
        System.debug('orderLineIds: ' + saleOrderLineIds);
        //Not Sure Why this is needed
        // for(dmpl__SaleOrderLine__c saleOrderLine : saleOrderLines){
        //     if(saleOrderLine.dmpl__ItemId__r.dmpl__TrackAsset__c)
        //         saleOrderLineIds.add(saleOrderLine.Id);
        // }

        SecurityHelper.ensureCanReadFields(new string[]{
            'dmpl__ItemId__c',
            'dmpl__SKUId__c',
            'dmpl__UnitPrice__c',
            'dmpl__Quantity__c',
            'dmpl__TaxGroupId__c',
            'dmpl__InvoiceGroup__c',
            'dmpl__PendingInvoiceQuantity__c'}, 
        'dmpl__SaleOrderLine__c');
        List<dmpl__SaleInvoiceLine__c> saleInvoiceLines =  [SELECT 
            Id,
            Name,
            dmpl__ItemId__c,
            dmpl__ItemLotId__c,
            dmpl__Quantity__c,
            dmpl__AssetId__c,
            dmpl__StorageLocationId__c,
            dmpl__SaleOrderLineId__c
        FROM 
            dmpl__SaleInvoiceLine__c
        WHERE 
            dmpl__SaleOrderLineId__c IN :saleOrderLineIds];

        Map<Id, dmpl__SaleInvoiceLine__c> mappedSaleInvoiceLines = new Map<Id, dmpl__SaleInvoiceLine__c>();
        for(dmpl__SaleInvoiceLine__c saleInvoiceLine : saleInvoiceLines)
        {
            if(!mappedSaleInvoiceLines.containsKey(saleInvoiceLine.dmpl__SaleOrderLineId__c))
                mappedSaleInvoiceLines.put(saleInvoiceLine.dmpl__SaleOrderLineId__c, saleInvoiceLine);
        }

        return mappedSaleInvoiceLines;
    }

    private static List<Id> queryTransactedObjectIds(List<dmpl__DeliveryOrder__c> newEntries){
       
        SecurityHelper.ensureCanReadFields(new string[]{'dmpl__DeliveryId__c'}, 'dmpl__DeliveryOrderLine__c');
        return DocumentHelper.extractIds([SELECT dmpl__DeliveryId__c 
                FROM dmpl__DeliveryOrderLine__c
                WHERE dmpl__DeliveryId__c IN:DocumentHelper.extractIds(newEntries)], FIELD_SALEDELIVERYLINE_SALEDELIVERYID);
    }

    private static List<dmpl__InventoryFulfillmentAllocationLine__c> queryFulfillmentAllocationLines(List<Id> fulfillmentIds, List<Id> fulfillmentOrderLineIds)
    {
        if(fulfillmentIds == null){
            fulfillmentIds = new List<Id>();
        }

        if(fulfillmentOrderLineIds == null){
            fulfillmentOrderLineIds = new List<Id>();
        }

        SecurityHelper.ensureCanReadFields(new string[]{'dmpl__PartnerAccountId__c',' dmpl__BranchId__c,','dmpl__AccountId__c','dmpl__DocumentDate__c'}, 'dmpl__InventoryFulfillment__c');
        SecurityHelper.ensureCanReadFields(new string[]{
            'dmpl__ItemId__c',
            'dmpl__SKUId__c',
            'dmpl__PendingDeliveryQuantity__c',
            'dmpl__SaleOrderLineId__c'
        }, 'dmpl__InventoryFulfillmentAllocationLine__c');
        return [SELECT Id,
            Name,
            dmpl__ItemId__c,
            dmpl__SKUId__c,
            dmpl__ItemLotId__c,
            dmpl__StorageLocationId__c,
            dmpl__PendingDeliveryQuantity__c,
            dmpl__SaleOrderLineId__c,
            dmpl__FulfillmentOrderId__r.dmpl__PartnerAccountId__c,
            dmpl__FulfillmentOrderId__r.dmpl__BranchId__c,
            dmpl__FulfillmentOrderId__r.dmpl__AccountId__c,
            dmpl__FulfillmentOrderId__r.dmpl__DocumentDate__c,
            dmpl__FulfillmentOrderId__r.dmpl__SaleOrderId__c,
            dmpl__FulfillmentOrderId__r.dmpl__RepairOrderId__c
        FROM dmpl__InventoryFulfillmentAllocationLine__c
        WHERE dmpl__FulfillmentOrderId__c IN :fulfillmentIds OR Id IN :fulfillmentOrderLineIds
        ];
    }

    private static List<dmpl__InventoryFulfillmentPickingLine__c> queryFulfillmentPickingLines(
        List<Id> fulfillmentIds, 
        List<Id> fulfillmentpickingLineIds)
    {
        if(fulfillmentIds == null){
            fulfillmentIds = new List<Id>();
        }

        if(fulfillmentpickingLineIds == null){
            fulfillmentpickingLineIds = new List<Id>();
        }

        SecurityHelper.ensureCanReadFields(new string[]{
            'dmpl__PartnerAccountId__c',
            'dmpl__BranchId__c',
            'dmpl__AccountId__c',
            'dmpl__DocumentDate__c'
        }, 'dmpl__InventoryFulfillment__c');
        SecurityHelper.ensureCanReadFields(new string[]{
            'dmpl__ItemId__c',
            'dmpl__SKUId__c',
            'dmpl__PendingDeliveryQuantity__c',
            'dmpl__FulfillmentAllocationLineId__c',
            'dmpl__SaleOrderLineId__c'
        }, 'dmpl__InventoryFulfillmentPickingLine__c');
        return [SELECT Id,
            Name,
            dmpl__ItemId__c,
            dmpl__SKUId__c,
            dmpl__ItemLotId__c,
            dmpl__StorageLocationId__c,
            dmpl__PendingDeliveryQuantity__c,
            dmpl__SaleOrderLineId__c,
            dmpl__FulfillmentAllocationLineId__c,
            dmpl__FulfillmentOrderId__r.dmpl__PartnerAccountId__c,
            dmpl__FulfillmentOrderId__r.dmpl__BranchId__c,
            dmpl__FulfillmentOrderId__r.dmpl__AccountId__c,
            dmpl__FulfillmentOrderId__r.dmpl__DocumentDate__c,
            dmpl__FulfillmentOrderId__r.dmpl__SaleOrderId__c,
            dmpl__FulfillmentOrderId__r.dmpl__RepairOrderId__c
        FROM dmpl__InventoryFulfillmentPickingLine__c
        WHERE dmpl__FulfillmentOrderId__c IN :fulfillmentIds OR Id IN :fulfillmentpickingLineIds];
    }
    
    private static List<dmpl__PurchaseReturnLine__c> queryPurchaseReturnLines(List<Id> purchaseReturnIds, List<Id> purchaseReturnLineIds)
    {
        if(purchaseReturnIds == null){
            purchaseReturnIds = new List<Id>();
        }

        if(purchaseReturnLineIds == null){
            purchaseReturnLineIds = new List<Id>();
        }

        SecurityHelper.ensureCanReadFields(new string[]{'dmpl__PartnerAccountId__c',' dmpl__BranchId__c,','dmpl__AccountId__c','dmpl__DocumentDate__c'}, 'dmpl__PurchaseReturn__c');
        SecurityHelper.ensureCanReadFields(new string[]{'dmpl__ItemId__c','dmpl__SKUId__c','dmpl__PendingDeliveryQuantity__c','dmpl__PurchaseReturnId__c'}, 'dmpl__PurchaseReturnLine__c');
        return [SELECT Id,
            Name,
            dmpl__ItemId__c,
            dmpl__SKUId__c,
            dmpl__StorageLocationId__c,
            dmpl__PurchaseReturnId__c,
            dmpl__PendingDeliveryQuantity__c,
            dmpl__PurchaseReturnId__r.dmpl__PartnerAccountId__c,
            dmpl__PurchaseReturnId__r.dmpl__BranchId__c,
            dmpl__PurchaseReturnId__r.dmpl__SupplierAccountId__c,
            dmpl__PurchaseReturnId__r.dmpl__DocumentDate__c,
            dmpl__ItemLotId__c
        FROM dmpl__PurchaseReturnLine__c
        WHERE dmpl__PurchaseReturnId__c IN :purchaseReturnIds OR Id IN :purchaseReturnLineIds
        ];
    }

    private static List<dmpl__BillReturnLine__c> queryBillReturnLines(List<Id> billReturnIds, List<Id> billReturnLineIds)
    {
        if(billReturnIds == null){
            billReturnIds = new List<Id>();
        }

        if(billReturnLineIds == null){
            billReturnLineIds = new List<Id>();
        }

        SecurityHelper.ensureCanReadFields(new string[]{'dmpl__PartnerAccountId__c',' dmpl__BranchId__c,','dmpl__AccountId__c','dmpl__DocumentDate__c'}, 'dmpl__BillReturn__c');
        SecurityHelper.ensureCanReadFields(new string[]{'dmpl__ItemId__c','dmpl__SKUId__c','dmpl__PendingDeliveryQuantity__c','dmpl__BillReturnId__c'}, 'dmpl__BillReturnLine__c');
        return [SELECT Id,
            Name,
            dmpl__ItemId__c,
            dmpl__SKUId__c,
            dmpl__StorageLocationId__c,
            dmpl__BillReturnId__c,
            dmpl__PendingDeliveryQuantity__c,
            dmpl__BillReturnId__r.dmpl__PartnerAccountId__c,
            dmpl__BillReturnId__r.dmpl__BranchId__c,
            dmpl__BillReturnId__r.dmpl__SupplierAccountId__c,
            dmpl__BillReturnId__r.dmpl__DocumentDate__c,
            dmpl__ItemLotId__c
        FROM dmpl__BillReturnLine__c
        WHERE dmpl__BillReturnId__c IN :billReturnIds OR Id IN :billReturnLineIds
        ];
    }

    private static dmpl__DeliveryOrder__c queryDeliveryOrderDocument(Id orderId){
        if(orderId == null){
            return null;
        }
        return [SELECT 
                Id, 
                Name,
                dmpl__SaleOrderId__c,
                dmpl__BranchId__c,
                dmpl__PartnerAccountId__c,
                dmpl__DocumentDate__c,
                dmpl__AccountId__c
            FROM 
                dmpl__DeliveryOrder__c
            WHERE Id =:orderId];
    }

    private static List<dmpl__DeliveryOrderLine__c>  queryDeliveryLines(List<Id> documentIds)
    {
        return [SELECT 
            Id, 
            dmpl__IsILPostingApproved__c 
            FROM dmpl__DeliveryOrderLine__c
            WHERE dmpl__DeliveryId__c IN : documentIds];
    }
    
    private static List<dmpl__DeliveryOrderLine__c> queryDeliveryLinesForLines(List<Id> lineIds)
    {
        return [SELECT 
            Id, 
            dmpl__IsILPostingApproved__c 
            FROM dmpl__DeliveryOrderLine__c
            WHERE Id IN : lineIds];
    }
}