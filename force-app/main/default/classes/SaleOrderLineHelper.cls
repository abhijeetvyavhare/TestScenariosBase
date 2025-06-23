public class SaleOrderLineHelper {

    private static Boolean skipValidations = false;
    private static Boolean skipComponentDeleteValidation = false;
    private static Boolean skipComponentAddValidation = false;

    private static final string OBJECT_SALEORDER = 'dmpl__SaleOrder__c';
    private static final string OBJECT_SALEORDERLINE = 'dmpl__SaleOrderLine__c';
    private static final string FIELD_SALEORDER_ID = 'dmpl__SaleOrderId__c';
    private static final string FIELD_SALEORDER_SERVICEREQUESTID = 'dmpl__ServiceRequestId__c';
    private static final string FIELD_SALEORDER_SERVICEESTIMATEID = 'dmpl__QuoteId__c';

    private static final string FIELD_SALEORDELINE_CANCELLEDQUANTITY = 'dmpl__CancelledQuantity__c';
    private static final string FIELD_SALEORDELINE_FULFILMENTORDERQUANTITY = 'dmpl__FulfilmentOrderQuantity__c';
    private static final string FIELD_SALEORDELINE_FULFILMENTALLOCATEDQUANTITY = 'dmpl__FulfilmentAllocatedQuantity__c';
    private static final string FIELD_SALEORDELINE_INVOICEQUANTITY = 'dmpl__InvoiceQuantity__c';
    private static final string FIELD_SALEORDELINE_ITEMID = 'dmpl__ItemId__c';
    private static final string FIELD_SALEORDELINE_SKUID = 'dmpl__SKUId__c';
    private static final string FIELD_SALEORDELINE_QUANTITY = 'dmpl__Quantity__c';
    private static final string FIELD_SALEORDELINE_TAXAMOUNT = 'dmpl__TaxAmount__c';
    private static final string FIELD_SALEORDELINE_RETURNEDQUANTITY = 'dmpl__ReturnedQuantity__c';
    private static final string FIELD_SALEORDELINE_SCHEMEDISCOUNTAMOUNT = 'dmpl__SchemeDiscountAmount__c';
    private static final string FIELD_SALEORDELINE_SCHEMELINEID = 'dmpl__SchemeLineId__c';
    private static final string FIELD_SALEORDELINE_TAXGROUPID = 'dmpl__TaxGroupId__c';
    private static final string FIELD_SALEORDELINE_AMOUNT = 'dmpl__Amount__c';
    private static final string FIELD_SALEORDELINE_ISPRICEBUNDLED = 'dmpl__IsPriceBundled__c';
    private static final string FIELD_SALEORDELINE_PURCHASEORDERLINEID = 'dmpl__PurchaseOrderLineId__c';
    private static final string FIELD_AGG_SALEORDERLINEID = 'SaleOrderLineId';
    private static final string FIELD_AGG_TOTALQTY = 'TotalQuantity';
    private static final string FIELD_AGG_TOTALALLOCATEDQTY = 'TotalAllocatedQuantity';
    private static final string FIELDNAME_SALEORDERLINE_PRICELISTRULEID = 'dmpl__PriceListRuleId__c';
    private static final string RELATION_SALEORDER_STATUS = 'dmpl__SaleOrderId__r.dmpl__Status__c';
    private static final string FIELD_SALEORDELINE_ALLOCATEDINVOICEDQUANTITY = 'dmpl__AllocatedInvoicedQuantity__c';
    private static final string FIELD_SALEORDELINE_ITEMALIASID = 'dmpl__ItemAliasId__c';
    private static final string FIELD_SALEORDELINE_CANCELQUANTITY = 'dmpl__CancelledQuantity__c';
    private static final string FIELD_SALEORDELINE_PENDINGFULFILMENTORDERQUANTITY = 'dmpl__PendingFulfilmentOrderQuantity__c';
    private static final string FIELD_SALEORDELINE_DELIVERYQUANTITY = 'dmpl__DeliveryQuantity__c';
    private static final string FIELD_SALEORDELINE_OTCINVOICEQTY = 'dmpl__OTCInvoicedQuantity__c';

    private static final string FIELD_SALEORDELINE_CONTRACTDISCOUNT = 'dmpl__ContractDiscount__c';
    private static final string FIELD_SALEORDELINE_DISCOUNT = 'dmpl__Discount__c';
    private static final string FIELD_SALEORDELINE_DISCOUNT2 = 'dmpl__Discount2__c';
    private static final string FIELD_SALEORDELINE_SCHEMEDISCOUNT = 'dmpl__SchemeDiscount__c';
    private static Boolean isAlreadyProcessing =false;

    private static final List<String> LIST_FIELDS_KEY = new List<String>{
        FIELD_SALEORDELINE_ITEMID,
        FIELD_SALEORDELINE_SKUID
    };

    private static final List<String> LIST_FIELDS_SYSTEM = new List<String>{
        FIELD_SALEORDELINE_FULFILMENTORDERQUANTITY,
        FIELD_SALEORDELINE_FULFILMENTALLOCATEDQUANTITY,
        //FIELD_SALEORDELINE_INVOICEQUANTITY,
        FIELD_SALEORDELINE_RETURNEDQUANTITY,
        FIELD_SALEORDELINE_ISPRICEBUNDLED,
        FIELD_SALEORDELINE_ALLOCATEDINVOICEDQUANTITY,
        FIELD_SALEORDELINE_DELIVERYQUANTITY,
        FIELD_SALEORDELINE_OTCINVOICEQTY,
        FIELD_SALEORDELINE_TAXAMOUNT,
        'dmpl__InventoryLedgerId__c', 
        'dmpl__IsILPosted__c',
        'dmpl__IsILPostingApproved__c'
    };

    private static final List<String> LIST_FIELDS_NEGATIVEANDZERONOTALLOWED = new List<String>{
        //FIELD_SALEORDELINE_QUANTITY
    };
    
    private static final List<String> LIST_FIELDS_NEGATIVENOTALLOWED = new List<String>{
        FIELD_SALEORDELINE_FULFILMENTALLOCATEDQUANTITY,
        FIELD_SALEORDELINE_ALLOCATEDINVOICEDQUANTITY,
        FIELD_SALEORDELINE_CANCELLEDQUANTITY,
        FIELD_SALEORDELINE_DELIVERYQUANTITY,
        FIELD_SALEORDELINE_FULFILMENTORDERQUANTITY,
        FIELD_SALEORDELINE_INVOICEQUANTITY,
        FIELD_SALEORDELINE_OTCINVOICEQTY,
        FIELD_SALEORDELINE_RETURNEDQUANTITY,
        'dmpl__PendingAllocatedInvoicedQuantity__c',
        'dmpl__PendingDeliveryQuantity__c',
        'dmpl__PendingFulfilmentAllocationQuantity__c',
        'dmpl__PendingFulfilmentOrderQuantity__c',
        'dmpl__PendingInvoiceQuantity__c'
        //'dmpl__UnitPrice__c'
    };

    private static final List<String> LIST_FIELDS_PERCENT = new List<String>{
        FIELD_SALEORDELINE_CONTRACTDISCOUNT,
        FIELD_SALEORDELINE_DISCOUNT,
        FIELD_SALEORDELINE_DISCOUNT2,
        FIELD_SALEORDELINE_SCHEMEDISCOUNT
    };
    
    private static SaleOrderService sos = new SaleOrderService();

    public static void validateData(
        Boolean isInsert, 
        Boolean isDelete, 
        Boolean isUpdate, 
        List<dmpl__SaleOrderLine__c> oldEntries, 
        List<dmpl__SaleOrderLine__c> newEntries){
        try {   
            if(isInsert){
                setRNASaleOrderId(newEntries);
                FieldMappingHelper.copyFieldMappingData(
                    newEntries);
            } 
            if(isInsert || isUpdate){   
                ValidationHelper.validatePostiveDecimal(
                    LIST_FIELDS_NEGATIVEANDZERONOTALLOWED,
                    newEntries);
                ValidationHelper.validatePostiveOrZeroDecimal(
                    LIST_FIELDS_NEGATIVENOTALLOWED,
                    newEntries);
                ValidationHelper.validateValidPercent(
                    LIST_FIELDS_PERCENT, 
                    newEntries);
                List<dmpl__SaleOrderLine__c> modifiedObjects = DocumentHelper.getApprovedObjects(
                    'dmpl__IsILPostingApproved__c', 
                    oldEntries, 
                    newEntries);
                if(modifiedObjects.size()>0){
                    DocumentHelper.validateCanBePosted(modifiedObjects, 'dmpl__FulfilmentAllocatedQuantity__c');
                    DocumentHelper.validateCanBePosted(modifiedObjects, 'dmpl__OTCInvoicedQuantity__c');
                }
            }
            if(skipValidations){
                return;
            }
            DocumentStatusDFSHelper dfsHelper = new DocumentStatusDFSHelper();
            if(isInsert){
                DocumentHelper.validateChangeInSystemFields(
                    LIST_FIELDS_SYSTEM, 
                    newEntries);
                dfsHelper.DocumentStatusRelatedObjectRestrictEdits_New(
                    OBJECT_SALEORDER, 
                    OBJECT_SALEORDERLINE, 
                    RELATION_SALEORDER_STATUS, 
                    newEntries);
                validateBundledItemPrice(newEntries);
                validateItem(newEntries);
                if(!skipComponentAddValidation){
                    List<dmpl__SaleOrderLine__c> packgaeLines = DocumentHelper.getObjectsWithNotNull(
                        newEntries, 
                        'dmpl__PackageSaleOrderLineId__c');
                    if(packgaeLines.size()>0){
                        PackageHelper.validateComponentsAdd(
                            packgaeLines, 
                            querySaleOrderLines(
                                CollectionHelper.extractIds(
                                    newEntries, 
                                    'dmpl__PackageSaleOrderLineId__c')));
                    }    
                }
            }else if(isUpdate){
                DocumentHelper.validateChangeInSystemFields(
                    LIST_FIELDS_SYSTEM, 
                    oldEntries, 
                    newEntries);
                validateChangeInKeyFields(
                    oldEntries, 
                    newEntries);
                dfsHelper.DocumentStatusRelatedObjectRestrictEdits_Edit(
                    OBJECT_SALEORDER, 
                    OBJECT_SALEORDERLINE, 
                    RELATION_SALEORDER_STATUS, 
                    oldEntries, 
                    newEntries);
                validateChangeInQuantity(
                    oldEntries, 
                    newEntries);
                List<dmpl__SaleOrderLine__c> modifiedObjects = DocumentHelper.getModifiedNewObjects(
                    new string[]{
                        FIELD_SALEORDELINE_QUANTITY
                    }, 
                    oldEntries, 
                    newEntries);
                if(modifiedObjects.size()>0){
                    PackageHelper.validateComponentQuantityEdit(
                        modifiedObjects, 
                        querySaleOrderLines(
                            CollectionHelper.extractIds(
                                oldEntries, 
                                'dmpl__PackageSaleOrderLineId__c')));
                }

                modifiedObjects = DocumentHelper.getModifiedNewObjects(
                    new string[]{'dmpl__UnitPrice__c'}, 
                    oldEntries, 
                    newEntries);
                if(modifiedObjects.size()>0){
                    validateBundledItemPrice(modifiedObjects);
                }
            }else if(isDelete){
                DocumentHelper.validateCanBeDeleted(
                    oldEntries, 
                    FIELD_SALEORDELINE_FULFILMENTORDERQUANTITY);
                DocumentHelper.validateCanBeDeleted(
                        oldEntries, 
                        FIELD_SALEORDELINE_INVOICEQUANTITY);
                dfsHelper.DocumentStatusRelatedObjectRestrictEdits_Delete(
                    OBJECT_SALEORDER, 
                    OBJECT_SALEORDERLINE, 
                    RELATION_SALEORDER_STATUS, 
                    oldEntries);
                if(!skipComponentDeleteValidation){
                    PackageHelper.validateComponentsDelete(
                        oldEntries, 
                        querySaleOrderLines(
                            CollectionHelper.extractIds(
                                oldEntries, 
                                'dmpl__PackageSaleOrderLineId__c')));
                }
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
        List<dmpl__SaleOrderLine__c> oldEntries, 
        List<dmpl__SaleOrderLine__c> newEntries){
        try {
            if(isInsert){
                setItemData(
                    newEntries);
                setOrderDiscount(
                    newEntries);
                TaxHelper.setLinesTaxes(newEntries);
            }
            else if(isUpdate){
                List<dmpl__SaleOrderLine__c> modifiedObjects = DocumentHelper.getModifiedNewObjects(
                    FIELDNAME_SALEORDERLINE_PRICELISTRULEID, 
                    oldEntries, 
                    newEntries);
                if(modifiedObjects.size()>0){
                    Map<Id, dmpl__Item__c> items = new Map<Id,dmpl__Item__c>(
                        ItemHelper.getCachedItems(
                            DocumentHelper.extractIds(
                                modifiedObjects, 
                                FIELD_SALEORDELINE_ITEMID)));
                    List<dmpl__SaleOrder__c> saleOrderDocuments = querySaleOrderDocument(
                        DocumentHelper.extractIds(
                            modifiedObjects, 
                            FIELD_SALEORDER_ID));
                    PriceListHelper.setApplicablePrices(
                        modifiedObjects, 
                        saleOrderDocuments, 
                        items.values(), 
                        DocumentHelper.extractIds(
                            modifiedObjects, 
                            FIELDNAME_SALEORDERLINE_PRICELISTRULEID),
                            'SaleOrderId__c');
                }

                modifiedObjects = DocumentHelper.getModifiedNewObjects(
                    new List<String>{
                        'dmpl__PriceListId__c',
                        'dmpl__PriceAsOnDate__c'
                    }, 
                    oldEntries, 
                    newEntries);
                if(modifiedObjects.size()>0){
                    Map<Id, dmpl__Item__c> items = new Map<Id,dmpl__Item__c>(
                        ItemHelper.getCachedItems(
                            DocumentHelper.extractIds(
                                modifiedObjects, 
                                FIELD_SALEORDELINE_ITEMID)));
                    List<dmpl__SaleOrder__c> saleOrderDocuments = querySaleOrderDocument(
                        DocumentHelper.extractIds(
                            modifiedObjects, 
                            FIELD_SALEORDER_ID));
                    PriceListHelper.setApplicablePrices(
                        modifiedObjects, 
                        saleOrderDocuments, 
                        items.values(), 
                        true);
                }
                updateDiscount(newEntries);
                modifiedObjects = DocumentHelper.getModifiedNewObjects(
                    new string[]{
                        'dmpl__TaxGroupId__c',
                        'dmpl__ItemId__c', 
                        'dmpl__SKUId__c',
                        'dmpl__Amount__c'
                    }, 
                    oldEntries, 
                    newEntries);
                if(modifiedObjects.size()>0){
                    TaxHelper.setLinesTaxes(modifiedObjects);
                }
                Map<Id, dmpl__Item__c> items = new Map<Id,dmpl__Item__c>(
                ItemHelper.getCachedItems(
                DocumentHelper.extractIds(
                    newEntries, 
                    FIELD_SALEORDELINE_ITEMID)));
                        modifiedObjects = DocumentHelper.getModifiedNewObjects(
                            new string[]{
                                'dmpl__Quantity__c',
                                'dmpl__UOM__c',
                                'dmpl__UOM1__c', 
                                'dmpl__UOMQuantity__c',
                                'dmpl__UOMQuantity1__c'
                            }, 
                            oldEntries, 
                            newEntries); 
                    if(modifiedObjects.size()>0){
                        ItemHelper.setQuantityFromUOM(newEntries, oldEntries, items);
                    }
            }else if(isDelete){
                //SaleOrderTaxHelper.deleteApplicableTaxes(oldEntries);
                deletePackageItems(oldEntries);
            }

            List<dmpl__SaleOrderLine__c> modifiedObjects = DocumentHelper.getPostedObjects(
                    'dmpl__IsILPostingApproved__c', 
                    oldEntries, 
                    newEntries);
            if(modifiedObjects.Size() > 0){
                InventoryLedgerHelper.createLedger(
                    InventoryLedgerTypeEnums.SoftCommit, 
                    FIELD_SALEORDER_ID, 
                    OBJECT_SALEORDER, 
                    isInsert, 
                    isDelete, 
                    isUpdate, 
                    oldEntries, 
                    newEntries);
            }
        } catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }
    
    public static void afterPostData(
        Boolean isInsert, 
        Boolean isDelete, 
        Boolean isUpdate, 
        List<dmpl__SaleOrderLine__c> oldEntries, 
        List<dmpl__SaleOrderLine__c> newEntries){
        try {
            if(isInsert){
                TaxHelper.createLinesTaxes(
                    isInsert, 
                    newEntries);
                PackageHelper.populatePackageItems(newEntries);
                PurchaseOrderLineHelper.updateSaleOrderQuantity(
                    DocumentHelper.extractIds(
                        newEntries, 
                        FIELD_SALEORDELINE_PURCHASEORDERLINEID));
            }else if(isUpdate){
                List<dmpl__SaleOrderLine__c> modifiedObjects = DocumentHelper.getModifiedNewObjects(
                    new string[]{
                        FIELD_SALEORDELINE_TAXGROUPID,
                        FIELD_SALEORDELINE_ITEMID, 
                        FIELD_SALEORDELINE_SKUID,
                        FIELD_SALEORDELINE_AMOUNT
                    }, 
                    oldEntries, 
                    newEntries);
                if(modifiedObjects.size()>0){
                    TaxHelper.createLinesTaxes(
                        isInsert, 
                        modifiedObjects);
                }
                modifiedObjects = DocumentHelper.getModifiedNewObjects(
                    new string[]{
                        FIELD_SALEORDELINE_QUANTITY, 
                        FIELD_SALEORDELINE_PURCHASEORDERLINEID
                    }, 
                    oldEntries, 
                    newEntries);
                if(modifiedObjects.size()>0){
                    PurchaseOrderLineHelper.updateSaleOrderQuantity(
                        DocumentHelper.extractIds(
                            modifiedObjects, 
                            FIELD_SALEORDELINE_PURCHASEORDERLINEID));
                }
                modifiedObjects = DocumentHelper.getModifiedNewObjects(
                    new string[]{
                        FIELD_SALEORDELINE_TAXGROUPID,
                        FIELD_SALEORDELINE_ITEMID, 
                        FIELD_SALEORDELINE_SKUID,
                        FIELD_SALEORDELINE_AMOUNT,
                        FIELD_SALEORDELINE_QUANTITY
                    }, 
                    oldEntries, 
                    newEntries);
                if(modifiedObjects.size() > 0 && !isAlreadyProcessing && !system.isBatch() && !system.IsFuture()){                    
                    dmpl__DMSOrgSetting__mdt  orgSetting = OrgSettingHelper.OrgSetting();
                    if(orgSetting != null && orgSetting.dmpl__ApplySchemeAsync__c){
                        List<Id> saleOrderIds =  DocumentHelper.extractIds(newEntries, 
                            FIELD_SALEORDER_ID);
                        applySchemeAsync(saleOrderIds);
                    }else{ 
                        isAlreadyProcessing = true;
                        List<dmpl__SaleOrder__c> saleOrderDocuments = querySaleOrderDocument(
                            DocumentHelper.extractIds(
                                modifiedObjects, 
                                FIELD_SALEORDER_ID));
                        SchemeEngine.processSchemes(saleOrderDocuments);
                        isAlreadyProcessing = false;
                    }   
                }
            }else if(isDelete){
                TaxHelper.deleteLinesTaxes(oldEntries);
                PurchaseOrderLineHelper.updateSaleOrderQuantity(
                    DocumentHelper.extractIds(
                        oldEntries, 
                        FIELD_SALEORDELINE_PURCHASEORDERLINEID));
            }

            if(!isAlreadyProcessing && (isInsert || isDelete)){  
                List<dmpl__SaleOrder__c> saleOrderDocuments = querySaleOrderDocument(
                    DocumentHelper.extractIds(
                        isDelete ? oldEntries : newEntries, 
                        FIELD_SALEORDER_ID));
                dmpl__DMSOrgSetting__mdt  orgSetting = OrgSettingHelper.OrgSetting();
                if(orgSetting != null && orgSetting.dmpl__ApplySchemeAsync__c && !system.isBatch() && !system.IsFuture()){
                    List<Id> saleOrderIds =  DocumentHelper.extractIds(
                        isDelete ? oldEntries : newEntries, 
                        FIELD_SALEORDER_ID);
                     applySchemeAsync(saleOrderIds);
                }else{ 
                    isAlreadyProcessing = true;
                    SchemeEngine.processSchemes(saleOrderDocuments);
                    isAlreadyProcessing = false;
                }
            }
        } catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }

    @testVisible
    private static void validateQuantityField(
        List<dmpl__SaleOrderLine__c> newEntries){
        for(dmpl__SaleOrderLine__c lineEntry : newEntries){
            if((lineEntry.dmpl__Quantity__c 
            - lineEntry.dmpl__AllocatedInvoicedQuantity__c 
            - lineEntry.dmpl__InvoiceQuantity__c) > (lineEntry.dmpl__CancelledQuantity__c)){
                lineEntry.addError(
                    String.valueOf(
                        System.Label.DocumentValidation_QuantityCannotGreaterThanCancelledQuantity));
            }
        }
    }
    @Future
    public static void applySchemeAsync(List<Id>saleOrderLineId){
        isAlreadyProcessing = true;
        List<dmpl__SaleOrder__c>saleOrders = querySaleOrderDocument(saleOrderLineId);
        SchemeEngine.processSchemes(saleOrders);
        isAlreadyProcessing = false;
    }
    
    public static CreateRelatedResult postIL(Id saleOrderId){
        return postSaleOrderLines(
            querySaleOrderLinesOfSaleOrders(
                new List<Id>{saleOrderId}));
    }

    public static CreateRelatedResult postIL(
        List<SourceObjectInfo> orderLinesInfo, 
        Id shipmentId){
        return postSaleOrderLines(
            querySaleOrderLines(
                SourceObjectInfo.extractIds(orderLinesInfo)));
    }

    public static void postSaleOrderLines(
        List<dmpl__SaleOrder__c> modifiedDocs){
        dmpl__CreateRelatedSetting__mdt setting = CreateRelatedSettingHelper.getCreateRelatedSettings(
            'dmpl__SaleOrder__c',
            'Post IL');
        if(setting == null){
            postSaleOrderLines(
                querySaleOrderLinesOfSaleOrders(
                    DocumentHelper.extractIds(modifiedDocs)));
        }else {
            for(dmpl__SaleOrder__c saleOrder : modifiedDocs){
                DocumentSelectorController.releaseDocumentDirect(
                    setting.Id, 
                    saleOrder.Id);
            }
        }
    }

    public static CreateRelatedResult postSaleOrderLines(
        List<dmpl__SaleOrderLine__c> saleOrderLines){
        SecurityHelper.ensureCanWriteField(
            'dmpl__IsILPostingApproved__c', 
            'dmpl__SaleOrderLine__c');
        for(dmpl__SaleOrderLine__c saleOrderLine : saleOrderLines){
            saleOrderLine.dmpl__IsILPostingApproved__c = true;
        }

        try {
            skipValidations = true;
            SecurityHelper.ensureCanWriteFields(
                new string[]{
                    'dmpl__IsILPosted__c',
                    'dmpl__IsILPostingApproved__c'}, 
                'dmpl__SaleOrderLine__c');
            return CreateRelatedResult.InitFrom(
                Database.update(
                    saleOrderLines));            
        } finally {
            skipValidations = false;
        }
    }

    public static void updateFulfilmentOrderQuantity(
        List<Id> saleOrderLineIds){
        try{
            skipValidations = true;
            SecurityHelper.ensureCanReadFields(
                new string[]{
                    'dmpl__SaleOrderLineId__c',
                    'dmpl__Quantity__c'
                }, 
                'dmpl__InventoryFulfillmentOrderLine__c');
            List<AggregateResult> ffAggregates = 
                [SELECT 
                    dmpl__SaleOrderLineId__c SaleOrderLineId, 
                    SUM(dmpl__Quantity__c) TotalQuantity
                FROM 
                    dmpl__InventoryFulfillmentOrderLine__c
                WHERE 
                    dmpl__SaleOrderLineId__c IN :saleOrderLineIds
                WITH SECURITY_ENFORCED
                GROUP BY dmpl__SaleOrderLineId__c];
    
            SecurityHelper.ensureCanReadFields(new string[]{
                'dmpl__FulfilmentOrderQuantity__c'
            }, OBJECT_SALEORDERLINE);
            List<dmpl__SaleOrderLine__c> orderLinesToUpdate = 
                [SELECT 
                    Id, 
                    dmpl__FulfilmentOrderQuantity__c
                FROM 
                    dmpl__SaleOrderLine__c
                WHERE 
                    Id IN :saleOrderLineIds];
    
            for(dmpl__SaleOrderLine__c orderLine : orderLinesToUpdate){
                for(AggregateResult result : ffAggregates){
                    if(result.get(FIELD_AGG_SALEORDERLINEID) == orderLine.Id){
                        orderLine.dmpl__FulfilmentOrderQuantity__c = 
                            result.get(FIELD_AGG_TOTALQTY) ==null ? 0 : (Decimal)(result.get(FIELD_AGG_TOTALQTY));
                        break;
                    }
                }
            }
            SecurityHelper.ensureCanWriteFields(new string[]{
                'dmpl__FulfilmentOrderQuantity__c'
            }, OBJECT_SALEORDERLINE);
            Update orderLinesToUpdate;
        }finally{
            skipValidations = false;
        }
    }

    public static void updateFulfilmentAllocatedQuantity(List<Id> saleOrderLineIds)
    {
        try{
            skipValidations = true;
            SecurityHelper.ensureCanReadFields(new string[]{
                'dmpl__SaleOrderLineId__c',
                'dmpl__Quantity__c',
                'dmpl__AllocatedQuantity__c'
            }, 'dmpl__InventoryFulfillmentOrderLine__c');
            List<AggregateResult> ffAggregates = 
                [SELECT 
                    dmpl__SaleOrderLineId__c SaleOrderLineId, 
                    SUM(dmpl__Quantity__c) TotalQuantity, 
                    SUM(dmpl__AllocatedQuantity__c) TotalAllocatedQuantity
                FROM 
                    dmpl__InventoryFulfillmentOrderLine__c
                WHERE 
                    dmpl__SaleOrderLineId__c IN :saleOrderLineIds
                    AND 
                    dmpl__SaleOrderLineId__c != null
                WITH SECURITY_ENFORCED
                GROUP BY dmpl__SaleOrderLineId__c];
    
            SecurityHelper.ensureCanReadFields(new string[]{
                'dmpl__FulfilmentOrderQuantity__c',
                'dmpl__FulfilmentAllocatedQuantity__c'
            }, OBJECT_SALEORDERLINE);
            List<dmpl__SaleOrderLine__c> orderLinesToUpdate = 
                [SELECT 
                    Id, 
                    dmpl__FulfilmentOrderQuantity__c
                FROM 
                    dmpl__SaleOrderLine__c
                WHERE 
                    Id IN :saleOrderLineIds];
    
            for(dmpl__SaleOrderLine__c orderLine : orderLinesToUpdate){
                for(AggregateResult result : ffAggregates){
                    if(result.get(FIELD_AGG_SALEORDERLINEID) == orderLine.Id){
                        orderLine.dmpl__FulfilmentOrderQuantity__c 
                            = result.get(FIELD_AGG_TOTALQTY) ==null ? 
                                0 : (Decimal)(result.get(FIELD_AGG_TOTALQTY));
                        orderLine.dmpl__FulfilmentAllocatedQuantity__c 
                            = result.get(FIELD_AGG_TOTALALLOCATEDQTY) == null ? 
                                0 : (Decimal)(result.get(FIELD_AGG_TOTALALLOCATEDQTY));
                        break;
                    }
                }
            }
            SecurityHelper.ensureCanWriteFields(new string[]{
                'dmpl__FulfilmentOrderQuantity__c',
                'dmpl__FulfilmentAllocatedQuantity__c'
            }, OBJECT_SALEORDERLINE);
            Update orderLinesToUpdate;
        }finally{
            skipValidations = false;
        }
    }

    public static void updateSaleReturnQuantity(List<Id> saleOrderLineIds)
    {
        try{
            skipValidations = true;
             
            SecurityHelper.ensureCanReadFields(new string[]{
                'dmpl__SaleOrderLineId__c',
                'dmpl__Quantity__c'
            }, 'dmpl__SaleReturnLine__c');
            List<AggregateResult> ffAggregates = 
                [SELECT 
                    dmpl__SaleOrderLineId__c SaleOrderLineId, 
                    SUM(dmpl__Quantity__c) TotalQuantity
                FROM 
                    dmpl__SaleReturnLine__c
                WHERE 
                dmpl__SaleOrderLineId__c IN :saleOrderLineIds
                WITH SECURITY_ENFORCED
                GROUP BY dmpl__SaleOrderLineId__c];
             
            SecurityHelper.ensureCanReadFields(new string[]{
                'dmpl__ReturnedQuantity__c'
            }, 'dmpl__SaleOrderLine__c');
            List<dmpl__SaleOrderLine__c> orderLinesToUpdate = 
                [SELECT 
                    Id, 
                    dmpl__ReturnedQuantity__c
                FROM 
                dmpl__SaleOrderLine__c
                WHERE 
                    Id IN :saleOrderLineIds];
    
            for(dmpl__SaleOrderLine__c orderLine : orderLinesToUpdate){
                for(AggregateResult result : ffAggregates){
                    if(result.get(FIELD_AGG_SALEORDERLINEID) == orderLine.Id){
                        orderLine.dmpl__ReturnedQuantity__c 
                            = result.get(FIELD_AGG_TOTALQTY) ==null ? 
                                0 : (Decimal)(result.get(FIELD_AGG_TOTALQTY));
                        break;
                    }
                }
            }
            SecurityHelper.ensureCanWriteFields(new string[]{
                'dmpl__ReturnedQuantity__c'
            }, 'dmpl__SaleOrderLine__c');
            Update orderLinesToUpdate;
        }finally{
            skipValidations = false;
        }
    }


    public static void addPackageSaleOrderLines(
        Map<dmpl__SaleOrderLine__c, 
        List<dmpl__ItemComponent__c>> packageLines){
        List<dmpl__SaleOrderLine__c> orderLinesToCreate = new List<dmpl__SaleOrderLine__c>();
        for(dmpl__SaleOrderLine__c line : packageLines.keySet()){
            List<dmpl__ItemComponent__c> components = packageLines.get(line);
            for(dmpl__ItemComponent__c component : components){
                orderLinesToCreate.add(
                    createSaleOrderLine(
                        line, 
                        component));
            }
        }

        if(orderLinesToCreate.size()>0){
            SecurityHelper.ensureCanCreateObject('dmpl__SaleOrderLine__c');
            SecurityHelper.ensureCanCreateFields(new List<String>{
                'dmpl__ItemId__c',
                'dmpl__SKUId__c',
                'dmpl__PackageSaleOrderLineId__c',
                'dmpl__Quantity__c',
                'dmpl__SaleOrderId__c'    
            }, 'dmpl__SaleOrderLine__c');
            try {
                skipValidations = true;
                skipComponentAddValidation = true;
                insert orderLinesToCreate;
            } finally {
                skipValidations = false;
                skipComponentAddValidation = false;
            }
        }
    }

    public static void applyPackageConfiguration(
        dmpl__SaleOrderLine__c packageSaleOrderLine, 
        List<dmpl__SaleOrderLine__c> existingLines, 
        List<dmpl__ItemComponent__c> components){
        List<dmpl__SaleOrderLine__c> orderLinesToCreate = new List<dmpl__SaleOrderLine__c>();
        List<dmpl__SaleOrderLine__c> orderLinesToUpdate = new List<dmpl__SaleOrderLine__c>();
        List<dmpl__SaleOrderLine__c> orderLinesToDelete = new List<dmpl__SaleOrderLine__c>();
        if(packageSaleOrderLine == null){
            throw new DMPLException(
                String.format(
                    String.valueOf(
                        System.Label.Generic_MissingObject), 
                        new String[]{dmpl__SaleOrderLine__c.class.getName()}));
        }
        for(dmpl__ItemComponent__c component : components){
            dmpl__SaleOrderLine__c exisitngLine = (dmpl__SaleOrderLine__c)CollectionHelper.getObject(
                existingLines, 
                'dmpl__ItemComponentId__c', 
                component.Id);
            if(exisitngLine == null){
                orderLinesToCreate.add(
                    createSaleOrderLine(
                        packageSaleOrderLine, 
                        component));
            }else if(component.dmpl__IsQuantityEditable__c){
                Decimal quantity = PackageHelper.getDefaultComponentQuantity(
                    packageSaleOrderLine.dmpl__Quantity__c, 
                    component);
                if(exisitngLine.dmpl__Quantity__c != quantity){
                    exisitngLine.dmpl__Quantity__c = component.dmpl__Quantity__c;
                    orderLinesToUpdate.add(exisitngLine);
                }
            }
        }

        for(dmpl__SaleOrderLine__c line : existingLines){
            if(line.Id != packageSaleOrderLine.Id 
                && CollectionHelper.getObject(
                    components, 
                    line.dmpl__ItemComponentId__c) == null){
                orderLinesToDelete.add(line);
            }
        }

        if(orderLinesToCreate.size()>0){
            SecurityHelper.ensureCanCreateObject('dmpl__SaleOrderLine__c');
            SecurityHelper.ensureCanCreateFields(new List<String>{
                'dmpl__ItemId__c',
                'dmpl__SKUId__c',
                'dmpl__PackageSaleOrderLineId__c',
                'dmpl__Quantity__c',
                'dmpl__SaleOrderId__c'    
            }, 'dmpl__SaleOrderLine__c');
            try {
                skipValidations = true;
                skipComponentAddValidation = true;
                insert orderLinesToCreate;
            } finally {
                skipValidations = false;
                skipComponentAddValidation = false;
            }
        }

        if(orderLinesToUpdate.size()>0){
            SecurityHelper.ensureCanWriteFields(new List<String>{
                'dmpl__ItemId__c',
                'dmpl__SKUId__c',
                'dmpl__PackageSaleOrderLineId__c',
                'dmpl__Quantity__c'
            }, 'dmpl__SaleOrderLine__c');
            try {
                skipValidations = true;
                skipComponentAddValidation = true;
                update orderLinesToUpdate;
            } finally {
                skipValidations = false;
                skipComponentAddValidation = false;
            }
        }

        if(orderLinesToDelete.size()>0){
            SecurityHelper.ensureCanDeleteObject('dmpl__SaleOrderLine__c');
            try {
                skipValidations = true;
                skipComponentAddValidation = true;
                delete orderLinesToDelete;
            } finally {
                skipValidations = false;
                skipComponentAddValidation = false;
            }
        }
    }

    public static void updateSaleInvoiceQuantity(List<Id> saleOrderLineIds)
    {
        try{
            skipValidations = true;
             
            SecurityHelper.ensureCanReadFields(new string[]{
                'dmpl__SaleOrderLineId__c',
                'dmpl__Quantity__c'
            }, 'dmpl__SaleInvoiceLine__c');
            List<AggregateResult> ffAggregates = 
                [SELECT 
                    dmpl__SaleOrderLineId__c SaleOrderLineId, 
                    SUM(dmpl__Quantity__c) TotalQuantity
                FROM 
                    dmpl__SaleInvoiceLine__c
                WHERE 
                    dmpl__SaleOrderLineId__c IN :saleOrderLineIds
                WITH SECURITY_ENFORCED
                GROUP BY dmpl__SaleOrderLineId__c];
             
            SecurityHelper.ensureCanReadFields(new string[]{
                'dmpl__InvoiceQuantity__c'
            }, 'dmpl__SaleOrderLine__c');
            List<dmpl__SaleOrderLine__c> orderLinesToUpdate = 
                [SELECT 
                    Id, 
                    dmpl__InvoiceQuantity__c
                FROM 
                    dmpl__SaleOrderLine__c
                WHERE 
                    Id IN :saleOrderLineIds];
    
            for(dmpl__SaleOrderLine__c orderLine : orderLinesToUpdate){
                for(AggregateResult result : ffAggregates){
                    if(result.get(FIELD_AGG_SALEORDERLINEID) == orderLine.Id){
                        orderLine.dmpl__InvoiceQuantity__c 
                            = result.get(FIELD_AGG_TOTALQTY) ==null ? 
                                0 : (Decimal)(result.get(FIELD_AGG_TOTALQTY));
                        break;
                    }
                }
            }
            SecurityHelper.ensureCanWriteFields(new string[]{
                'dmpl__InvoiceQuantity__c'
            }, 'dmpl__SaleOrderLine__c');
            Update orderLinesToUpdate;
        }finally{
            skipValidations = false;
        }
    }

    public static void updateSaleInvoiceQuantity(List<Id> saleOrderLineIds, List<Id> allocationLineIds)
    {
        try{
            skipValidations = true;
            // if(allocationLineIds.size() == 0)
            //     return;
             
            SecurityHelper.ensureCanReadFields(new string[]{
                'dmpl__SaleOrderLineId__c',
                'dmpl__FulfillmentAllocationLineId__c',
                'dmpl__Quantity__c'
            }, 'dmpl__SaleInvoiceLine__c');
            List<AggregateResult> ffAggregates = 
                [SELECT 
                    dmpl__SaleOrderLineId__c SaleOrderLineId,
                    dmpl__FulfillmentAllocationLineId__c AllocationLineId, 
                    SUM(dmpl__Quantity__c) TotalQuantity
                FROM 
                    dmpl__SaleInvoiceLine__c
                WHERE 
                    dmpl__SaleOrderLineId__c IN :saleOrderLineIds
                // AND
                //     dmpl__FulfillmentAllocationLineId__c IN: allocationLineIds
                GROUP BY dmpl__SaleOrderLineId__c, dmpl__FulfillmentAllocationLineId__c];
             
            SecurityHelper.ensureCanReadFields(new string[]{
                'dmpl__AllocatedInvoicedQuantity__c','dmpl__OTCInvoicedQuantity__c'
            }, 'dmpl__SaleOrderLine__c');
            List<dmpl__SaleOrderLine__c> orderLinesToUpdate = 
                [SELECT 
                    Id, 
                    dmpl__AllocatedInvoicedQuantity__c,
                    dmpl__OTCInvoicedQuantity__c
                FROM 
                    dmpl__SaleOrderLine__c
                WHERE 
                    Id IN :saleOrderLineIds];

            for(dmpl__SaleOrderLine__c orderLine : orderLinesToUpdate){
                List<AggregateResult> filteredResult =
                                         DocumentHelper.getObjectsWithNotNull(ffAggregates, 'AllocationLineId');
                Decimal invoicedQuantity = 0;
                for(AggregateResult result : filteredResult){
                    if(result.get(FIELD_AGG_SALEORDERLINEID) == orderLine.Id){
                        invoicedQuantity = invoicedQuantity + (result.get(FIELD_AGG_TOTALQTY) == null ? 
                                                0 : (Decimal)(result.get(FIELD_AGG_TOTALQTY)));
                    }
                }
                orderLine.dmpl__AllocatedInvoicedQuantity__c = invoicedQuantity;
            }

            for(dmpl__SaleOrderLine__c orderLine : orderLinesToUpdate){
                List<AggregateResult> filteredResult =
                                         DocumentHelper.getObjectsWithNull(ffAggregates, 'AllocationLineId');
                Decimal invoicedQuantity = 0;
                for(AggregateResult result : filteredResult){
                    if(result.get(FIELD_AGG_SALEORDERLINEID) == orderLine.Id){
                        invoicedQuantity = invoicedQuantity + (result.get(FIELD_AGG_TOTALQTY) == null ? 
                                                0 : (Decimal)(result.get(FIELD_AGG_TOTALQTY)));
                    }
                }
                orderLine.dmpl__OTCInvoicedQuantity__c = invoicedQuantity;
            }
            
            SecurityHelper.ensureCanWriteFields(new string[]{
                'dmpl__AllocatedInvoicedQuantity__c','dmpl__OTCInvoicedQuantity__c'
            }, 'dmpl__SaleOrderLine__c');
            Update orderLinesToUpdate;
        }finally{
            skipValidations = false;
        }
    }

    public static void updateSaleDeliveryQuantity(List<Id> saleOrderLineIds)
    {
        try{
            skipValidations = true;
           
            SecurityHelper.ensureCanReadFields(new string[]{
                'dmpl__SaleOrderLineId__c',
                'dmpl__Quantity__c'
            }, 'dmpl__DeliveryOrderLine__c');
            List<AggregateResult> ffAggregates = 
                [SELECT 
                    dmpl__SaleOrderLineId__c SaleOrderLineId, 
                    SUM(dmpl__Quantity__c) TotalQuantity
                FROM 
                    dmpl__DeliveryOrderLine__c
                WHERE 
                    dmpl__SaleOrderLineId__c IN :saleOrderLineIds
                WITH SECURITY_ENFORCED
                GROUP BY 
                    dmpl__SaleOrderLineId__c];

            SecurityHelper.ensureCanReadFields(new string[]{
                FIELD_SALEORDELINE_DELIVERYQUANTITY
            }, 'dmpl__SaleOrderLine__c');
            List<dmpl__SaleOrderLine__c> orderLinesToUpdate = 
                [SELECT 
                    Id, 
                    dmpl__DeliveryQuantity__c
                FROM 
                    dmpl__SaleOrderLine__c
                WHERE 
                    Id IN :saleOrderLineIds];
    
            for(dmpl__SaleOrderLine__c orderLine : orderLinesToUpdate){
                for(AggregateResult result : ffAggregates){
                    if(result.get(FIELD_AGG_SALEORDERLINEID) == orderLine.Id){
                        orderLine.dmpl__DeliveryQuantity__c 
                            = result.get(FIELD_AGG_TOTALQTY) ==null ? 
                                0 : (Decimal)(result.get(FIELD_AGG_TOTALQTY));
                        break;
                    }
                }
            }
            SecurityHelper.ensureCanWriteFields(new string[]{
                FIELD_SALEORDELINE_DELIVERYQUANTITY
            }, 'dmpl__SaleOrderLine__c');
            Update orderLinesToUpdate;
        }finally{
            skipValidations = false;
        }
    }

    public static void updateSaleReturnQuantity(List<dmpl__SaleReturn__c> saleReturns)
    {
        updateSaleReturn(
            querySaleReturnLines(
                DocumentHelper.extractIds(saleReturns)));
    }

    public static void performReprice(Id saleOrderId){
        performReprice(
            new List<Id>{saleOrderId});
    }

    public static void performReprice(List<Id> saleOrderIds){
        List<dmpl__SaleOrder__c> saleOrderDocuments = querySaleOrderDocument(
            saleOrderIds);
        List<dmpl__SaleOrderLine__c> saleOrderLines = querySaleOrderLinesOfSaleOrders(
            CollectionHelper.extractIds(
                saleOrderDocuments));
        Map<Id, dmpl__Item__c> items = new Map<Id,dmpl__Item__c>(
            ItemHelper.getCachedItems(
                DocumentHelper.extractIds(
                    saleOrderLines, 
                    FIELD_SALEORDELINE_ITEMID)));

        PriceListHelper.setApplicablePrices(
            saleOrderLines, 
            saleOrderDocuments, 
            items.values(),
            true);
        update saleOrderLines;
    }

    public static CreateRelatedResult createSaleOrderLinesFromPurchaseOrder(
        List<SourceObjectInfo> orderLinesInfo, 
        Id saleOrderId){
            return CreateRelatedResult.InitFrom(
                createSaleOrderLineFromPurchaseOrder(
                    queryPurchaseOrderLines(
                        SourceObjectInfo.extractIds(orderLinesInfo)), 
                    orderLinesInfo, 
                    saleOrderId));
     }
    
    public static void createSaleOrderLinesFromSaleOrder(
        List<dmpl__SaleOrder__c> saleOrders){
        List<dmpl__SaleOrder__c> sourceAsEstimate = DocumentHelper.getObjectsWithNotNull(
            saleOrders, 
            FIELD_SALEORDER_SERVICEESTIMATEID);
        if(sourceAsEstimate.size() > 0)
            populateLinesFromServiceEstimate(sourceAsEstimate);

        List<dmpl__SaleOrder__c> sourceAsServiceRequest = DocumentHelper.getObjectsWithNotNull(
            saleOrders, 
            FIELD_SALEORDER_SERVICEREQUESTID);
        if(sourceAsServiceRequest.size() > 0)
            populateLinesFromServiceRequest(sourceAsServiceRequest);
    }

    public static CreateRelatedResult cancelSaleOrderLines(
        List<SourceObjectInfo> orderLinesInfo, 
        Id saleOrderId){
            return CancelSaleOrderLinesInternal(
                SaleOrderLineHelper.sos.queryObjectsForType(
                    OBJECT_SALEORDERLINE, 
                    new List<String>{
                        FIELD_SALEORDELINE_CANCELQUANTITY,
                        FIELD_SALEORDELINE_PENDINGFULFILMENTORDERQUANTITY},
                    SourceObjectInfo.extractIds(
                        orderLinesInfo)),
                orderLinesInfo);
        }

    public static CreateRelatedResult cancelSaleOrderLines(
        Id saleOrderId){
            return CancelSaleOrderLinesInternal(
                SaleOrderLineHelper.sos.queryObjectsForType(
                    OBJECT_SALEORDERLINE, 
                    new List<String>{
                        FIELD_SALEORDELINE_CANCELQUANTITY,
                        FIELD_SALEORDELINE_PENDINGFULFILMENTORDERQUANTITY},
                    FIELD_SALEORDER_ID, 
                    saleOrderId),
                null);
        }

    @testVisible
    private static CreateRelatedResult cancelSaleOrderLinesInternal(
        List<dmpl__SaleOrderLine__c> lines,
        List<SourceObjectInfo> orderLinesInfo){
            for(dmpl__SaleOrderLine__c line : lines){
                decimal cancelQty = line.dmpl__PendingFulfilmentOrderQuantity__c;
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
                SaleOrderLineHelper.sos.updateObjects(lines)
            );
        }

    private static void populateLinesFromServiceRequest(
        List<dmpl__SaleOrder__c> sourceAsServiceRequest){
        List<dmpl__SaleOrderLine__c> newSaleOrderLines = new List<dmpl__SaleOrderLine__c>();
        Map<ID, dmpl__ServiceRequest__c> serviceRequests = new Map<ID, dmpl__ServiceRequest__c>(
            queryServiceRequests(
                DocumentHelper.extractIds(
                    sourceAsServiceRequest, 
                    FIELD_SALEORDER_SERVICEREQUESTID)));
        
        for(dmpl__SaleOrder__c lineEntry : sourceAsServiceRequest){
            if(lineEntry.dmpl__QuoteId__c != null)
                continue;
            dmpl__ServiceRequest__c currentServiceRequest = serviceRequests.get(
                lineEntry.dmpl__ServiceRequestId__c);
            if(currentServiceRequest != null){
                for(dmpl__ServiceRequestLine__c serviceRequestLine : currentServiceRequest.ServiceAppointmentLines__r){
                    newSaleOrderLines.add(new dmpl__SaleOrderLine__c(
                        dmpl__SaleOrderId__c = lineEntry.Id,
                        dmpl__ItemId__c = serviceRequestLine.dmpl__ItemId__c,
                        dmpl__Quantity__c = serviceRequestLine.dmpl__Quantity__c,
                        dmpl__TaxGroupId__c = serviceRequestLine.dmpl__TaxGroupId__c,
                        dmpl__UnitPrice__c = serviceRequestLine.dmpl__UnitPrice__c,
                        dmpl__UnitPrice2__c = serviceRequestLine.dmpl__UnitPrice2__c,
                        dmpl__SKUId__c = serviceRequestLine.dmpl__SKUId__c,
                        dmpl__ItemLotTypeId__c = serviceRequestLine.dmpl__ItemLotTypeId__c,
                        dmpl__ServiceRequestLineId__c = serviceRequestLine.Id,
                        dmpl__DiscountAmount__c = serviceRequestLine.dmpl__DiscountAmount__c,
                        dmpl__Discount__c = serviceRequestLine.dmpl__Discount__c,
                        dmpl__Discount2__c = serviceRequestLine.dmpl__Discount2__c,
                        dmpl__DiscountAmount2__c = serviceRequestLine.dmpl__DiscountAmount2__c,
                        dmpl__ContractDiscount__c = serviceRequestLine.dmpl__ContractDiscount__c,
                        dmpl__ContractDiscountAmount__c = serviceRequestLine.dmpl__ContractDiscountAmount__c
                    ));
                }
            }
        }

        if(newSaleOrderLines.size() > 0){
            try{
                skipValidations = true;
                SecurityHelper.ensureCanWriteObject(OBJECT_SALEORDERLINE);
                SecurityHelper.ensureCanWriteFields(
                    new List<string>{
                        'dmpl__ItemId__c',
                        'dmpl__Quantity__c',
                        'dmpl__TaxGroupId__c',
                        'dmpl__UnitPrice__c',
                        'dmpl__UnitPrice2__c',
                        'dmpl__SKUId__c',
                        'dmpl__ItemLotTypeId__c'
                    }, OBJECT_SALEORDERLINE);
                insert newSaleOrderLines; 
            } catch(Exception error){
                ExceptionLogHelper.logException(error);
                throw error;
            } finally {
                skipValidations = false;
            }
        }
    }

    private static void populateLinesFromServiceEstimate(
        List<dmpl__SaleOrder__c> sourceAsEstimate){
        List<dmpl__SaleOrderLine__c> newSaleOrderLines = new List<dmpl__SaleOrderLine__c>();
        Map<ID, dmpl__Quote__c> serviceEstimates = new Map<ID, dmpl__Quote__c>(
            queryServiceEstimates(
                DocumentHelper.extractIds(
                    sourceAsEstimate, 
                    FIELD_SALEORDER_SERVICEESTIMATEID)));
        
        for(dmpl__SaleOrder__c lineEntry : sourceAsEstimate){
            dmpl__Quote__c currentServiceEstimate = serviceEstimates.get(
                lineEntry.dmpl__QuoteId__c);
            if(currentServiceEstimate != null){
                for(dmpl__QuoteLine__c serviceEstimateLine : currentServiceEstimate.dmpl__QuoteLines__r){
                    newSaleOrderLines.add(new dmpl__SaleOrderLine__c(
                        dmpl__SaleOrderId__c = lineEntry.Id,
                        dmpl__ItemId__c = serviceEstimateLine.dmpl__ItemId__c,
                        dmpl__Quantity__c = serviceEstimateLine.dmpl__Quantity__c,
                        dmpl__TaxGroupId__c = serviceEstimateLine.dmpl__TaxGroupId__c,
                        dmpl__UnitPrice__c = serviceEstimateLine.dmpl__UnitPrice__c,
                        dmpl__UnitPrice2__c = serviceEstimateLine.dmpl__UnitPrice2__c,
                        dmpl__SKUId__c = serviceEstimateLine.dmpl__SKUId__c,
                        dmpl__QuoteLineId__c = serviceEstimateLine.Id,
                        dmpl__DiscountAmount__c = serviceEstimateLine.dmpl__DiscountAmount__c,
                        dmpl__Discount__c = serviceEstimateLine.dmpl__Discount__c,
                        dmpl__Discount2__c = serviceEstimateLine.dmpl__Discount2__c,
                        dmpl__DiscountAmount2__c = serviceEstimateLine.dmpl__DiscountAmount2__c,
                        dmpl__ContractDiscount__c = serviceEstimateLine.dmpl__ContractDiscount__c,
                        dmpl__ContractDiscountAmount__c = serviceEstimateLine.dmpl__ContractDiscountAmount__c,
                        dmpl__ItemLotTypeId__c = serviceEstimateLine.dmpl__ItemLotTypeId__c
                    ));
                }
            }
        }

        if(newSaleOrderLines.size() > 0){
            try{
                skipValidations = true;
                SecurityHelper.ensureCanWriteObject(OBJECT_SALEORDERLINE);
                SecurityHelper.ensureCanWriteFields(new List<string>{
                    'dmpl__ItemId__c',
                    'dmpl__Quantity__c',
                    'dmpl__TaxGroupId__c',
                    'dmpl__UnitPrice__c',
                    'dmpl__UnitPrice2__c',
                    'dmpl__SKUId__c'
                }, OBJECT_SALEORDERLINE);
                insert newSaleOrderLines; 
            } catch(Exception error){
                ExceptionLogHelper.logException(error);
                throw error;
            } finally {
                skipValidations = false;
            }
        }
    }

    private static Map<Id, dmpl__SaleOrderLine__c> createSaleOrderLineFromPurchaseOrder(List<dmpl__PurchaseOrderLine__c> purchaseOrderLines, List<SourceObjectInfo> sourceObjectsList, Id saleOrderId)
    {
        if(purchaseOrderLines.size() == 0){
            throw new DMPLException(String.format(String.valueOf(System.Label.Generic_EmptyActionParam), new String[]{dmpl__PurchaseOrderLine__c.class.getName()}));
        }

        List<dmpl__PurchaseOrderLine__c> pendingOrderLines = new List<dmpl__PurchaseOrderLine__c>();
        for(dmpl__PurchaseOrderLine__c purchaseOrderLine : purchaseOrderLines){
            if(purchaseOrderLine.dmpl__PendingQuantity__c>0){
                pendingOrderLines.Add(purchaseOrderLine);
            }
        }
        if(pendingOrderLines.size() == 0){
            throw new DMPLException(String.format(String.valueOf(System.Label.Generic_EmptyActionParam), new String[]{dmpl__PurchaseOrderLine__c.class.getName()}));
        }

        List<dmpl__SaleOrderLine__c> saleOrderLines = new List<dmpl__SaleOrderLine__c>();
        for(dmpl__PurchaseOrderLine__c orderLine : pendingOrderLines){
            if(orderLine.dmpl__ItemId__c !=null 
                && orderLine.dmpl__PendingQuantity__c>0){
                Decimal requestedQty = SourceObjectInfo.getRequestedQuantity(sourceObjectsList, saleOrderId);
                saleOrderLines.add(createSaleOderLinesFromPurchaseOrderLine(orderLine, saleOrderId, requestedQty));
            }
        }

        if(saleOrderLines.size() >0){
            Savepoint sp = Database.setSavepoint();
            try {
                SecurityHelper.ensureCanCreateObject('dmpl__SaleOrderLine__c');
                SecurityHelper.ensureCanCreateFields(new string[]{'dmpl__ItemId__c','dmpl__SKUId__c','dmpl__Quantity__c','dmpl__TaxGroupId__c'}, 'dmpl__SaleOrderLine__c');
                insert saleOrderLines;
            } catch (Exception e) {
                Database.rollback(sp);
                throw e;
            }
        }
        return new Map<Id, dmpl__SaleOrderLine__c>(saleOrderLines);
    }

    private static List<dmpl__ItemServiceContract__c> queryItemServiceContractLines(
        List<ID> contractIds){
            return[SELECT 
                ID,
                dmpl__ItemId__c,
                (
                    SELECT
                    ID,
                    dmpl__ComponentItemId__c,
                    dmpl__IsInScope__c,
                    dmpl__ItemServiceContractId__c,
                    dmpl__Quantity__c
                    FROM dmpl__ItemServiceContractLines__r
                )
            FROM dmpl__ItemServiceContract__c
            WHERE Id IN :contractIds
            ];
        }
 
     private static List<dmpl__PurchaseOrderLine__c> queryPurchaseOrderLines(List<Id> purchaseOrderLineIds)
     {
         SecurityHelper.ensureCanReadFields(new string[]{'dmpl__PartnerAccountId__c','dmpl__BranchId__c','dmpl__SupplierAccountId__c','dmpl__DocumentDate__c'},'dmpl__PurchaseOrder__c');
         SecurityHelper.ensureCanReadFields(new string[]{'dmpl__ItemId__c','dmpl__PurchaseOrderId__c','dmpl__TaxGroupId__c','dmpl__SKUId__c','dmpl__PendingQuantity__c'}, 'dmpl__PurchaseOrderLine__c');
         return [SELECT Id,
             Name,
             dmpl__ItemId__c,
             dmpl__SKUId__c,
             dmpl__PendingQuantity__c,
             dmpl__TaxGroupId__c,
             dmpl__PurchaseOrderId__c,
             dmpl__PurchaseOrderId__r.dmpl__PartnerAccountId__c,
             dmpl__PurchaseOrderId__r.dmpl__BranchId__c,
             dmpl__PurchaseOrderId__r.dmpl__SupplierAccountId__c,
             dmpl__PurchaseOrderId__r.dmpl__DocumentDate__c
         FROM dmpl__PurchaseOrderLine__c
         WHERE Id IN : purchaseOrderLineIds
         ];
     }
 
    @testVisible
     private static dmpl__SaleOrderLine__c createSaleOderLinesFromPurchaseOrderLine(dmpl__PurchaseOrderLine__c orderLine, Id saleOrderId, Decimal requestedQty)
     {
         return new dmpl__SaleOrderLine__c(
             dmpl__ItemId__c = orderLine.dmpl__ItemId__c,
             dmpl__SKUId__c = orderLine.dmpl__SKUId__c,
             dmpl__Quantity__c = requestedQty > 0 ? requestedQty : orderLine.dmpl__PendingQuantity__c,
             dmpl__TaxGroupId__c = orderLine.dmpl__TaxGroupId__c,
             dmpl__PurchaseOrderLineId__c= orderLine.Id,
             dmpl__SaleOrderId__c = saleOrderId
         );
     }

    private static void deletePackageItems(List<dmpl__SaleOrderLine__c> oldEntries){
        SecurityHelper.ensureCanReadField('Id', 'dmpl__SaleOrderLine__c');
        List<dmpl__SaleOrderLine__c> linesToDelte = [SELECT Id 
            FROM dmpl__SaleOrderLine__c 
            WHERE dmpl__PackageSaleOrderLineId__c IN:CollectionHelper.extractIds(oldEntries)];

        try {
            skipComponentDeleteValidation = true;
            if(linesToDelte.size()>0){
                SecurityHelper.ensureCanDeleteObject('dmpl__SaleOrderLine__c');
                delete linesToDelte;
            }        
        } finally {
            skipComponentDeleteValidation = false;
        }
    }

    private static void validateBundledItemPrice(List<dmpl__SaleOrderLine__c> newEntries){
        for(dmpl__SaleOrderLine__c orderLine : newEntries){
            if(orderLine.dmpl__IsPriceBundled__c 
                && orderLine.dmpl__UnitPrice__c>0){
                orderLine.addError(System.Label.PackageError_PriceNotApplicableToBundledItem);
            }
        }
    }

    private static void validateItem(List<dmpl__SaleOrderLine__c> newEntries){
        Map<Id, dmpl__Item__c> items = new Map<Id,dmpl__Item__c>(
            ItemHelper.getCachedItems(
                DocumentHelper.extractIds(
                    newEntries, 
                    FIELD_SALEORDELINE_ITEMID)));
        for(dmpl__SaleOrderLine__c orderLine : newEntries){
            dmpl__Item__c item = items.get(orderLine.dmpl__ItemId__c);
            if(orderLine.dmpl__PackageSaleOrderLineId__c == null 
                && item!=null && item.dmpl__OnlySoldInPackage__c){
                orderLine.addError(System.Label.PackageError_ItemSoldOnlyInPackage);
            }
            if(orderLine.dmpl__SKUId__c == null && item!=null && item.dmpl__IsSKURequired__c){
                orderLine.addError(System.Label.Validation_SKURequired);
            }
            if(orderLine.dmpl__SKUId__c != null){
                dmpl__SKU__c sku = (dmpl__SKU__c)CollectionHelper.getObject(
                    item.dmpl__SKUs__r, 
                    orderLine.dmpl__SKUId__c);
                if(sku ==null){
                    orderLine.addError(System.Label.Validation_SKUInvalid);
                }
            }
        }
    }
    
    @testVisible
    private static dmpl__SaleOrderLine__c createSaleOrderLine(
        dmpl__SaleOrderLine__c packageLine, 
        dmpl__ItemComponent__c component){
        return new dmpl__SaleOrderLine__c(
            dmpl__ItemComponentId__c = component.Id,    
            dmpl__ItemId__c = component.dmpl__ComponentItemId__c,
            dmpl__SKUId__c = component.dmpl__ComponentSKUId__c,
            dmpl__PackageSaleOrderLineId__c = packageLine.Id,
            dmpl__Quantity__c = PackageHelper.getDefaultComponentQuantity(
                packageLine.dmpl__Quantity__c, 
                component),
            dmpl__SaleOrderId__c =  packageLine.dmpl__SaleOrderId__c,
            dmpl__IsPriceBundled__c = component.dmpl__IsBundled__c
        );
    }

    @testVisible
    private static void updateSaleReturn(List<dmpl__SaleReturnLine__c> saleReturnLines)
    {
        List<ID> saleOrderLineIds = DocumentHelper.extractIds(
            saleReturnLines, 
            'dmpl__SaleOrderLineId__c');
        Map<ID,dmpl__SaleOrderLine__c> saleOrderLines = new Map<ID, dmpl__SaleOrderLine__c>(
            querySaleOrderLines(saleOrderLineIds));
        for(dmpl__SaleReturnLine__c lineEntry : saleReturnLines)
        {
            dmpl__SaleOrderLine__c saleOrderLine = saleOrderLines.get(lineEntry.dmpl__SaleOrderLineId__c);
            if(saleOrderLine != null)
            {
                saleOrderLine.dmpl__ReturnedQuantity__c = lineEntry.Quantity__c;
            }
        }

        if(saleOrderLines.size() > 0){
            try {
                SecurityHelper.ensureCanCreateObject('dmpl__SaleOrderLine__c');
                skipValidations = true;
                update saleOrderLines.values();       
            } finally {
                skipValidations = false;
            }
        }
    }
    
    private static void setItemData(
        List<dmpl__SaleOrderLine__c> newEntries)
    {
        setItemAliasData(newEntries);
        Map<Id, dmpl__Item__c> items = new Map<Id,dmpl__Item__c>(
            ItemHelper.getCachedItems(
                DocumentHelper.extractIds(
                    newEntries, 
                    FIELD_SALEORDELINE_ITEMID)));
        List<dmpl__SaleOrder__c> saleOrderDocuments = querySaleOrderDocument(
            DocumentHelper.extractIds(
                newEntries, 
                FIELD_SALEORDER_ID));
        setDefaultSKU(
            newEntries, 
            items);
        ItemHelper.setQuantityFromUOM(
            newEntries, 
            null,
            items);
        setAlternateItem(
            newEntries, 
            items);
        setInvoiceGroup(
            newEntries,
            items);
        setSubscriptionDetails(
            newEntries,
            items);
        PriceListHelper.setApplicablePrices(
            newEntries, 
            saleOrderDocuments, 
            items.values(),
            false);
        TaxGroupHelper.setApplicableTaxGroups(
            newEntries, 
            saleOrderDocuments, 
            items.values());
        // SaleOrderTaxHelper.setLineLevelTaxAmount(
        //     newEntries);
        DiscountGroupHelper.setApplicableDiscounts(
            newEntries, 
            saleOrderDocuments, 
            items.values());
        InventoryStockHelper.setStock(newEntries);
    }

    private static void setRNASaleOrderId(List<dmpl__SaleOrderLine__c> newEntries){
        List<dmpl__SaleOrderLine__c> rnaLines = CollectionHelper.getObjectsWithNull(newEntries, 'dmpl__SaleOrderId__c');
        if(rnaLines.size() == 0)
            return;
        List<dmpl__SaleOrder__c> rnaOrders = querySaleOrderDocumentOnExternalId(
            CollectionHelper.extractStrings(rnaLines, 'dmpl__RNASaleOrderExternalId__c'));
        for(dmpl__SaleOrderLine__c entry :  rnaLines){
            for(dmpl__SaleOrder__c rnaSaleOrder : rnaOrders){
                if(entry.dmpl__RNASaleOrderExternalId__c == rnaSaleOrder.dmpl__RNAExternalId__c){
                    entry.dmpl__SaleOrderId__c = rnaSaleOrder.Id;
                    break;
                }
            }
            if(entry.dmpl__SaleOrderId__c == null){
                entry.addError('RNA Sale Order Not Found!');
            }
        }
    }
    
    private static void setItemAliasData(List<dmpl__SaleOrderLine__c> newEntries)
    {
        List<Id> itemAliasIds = DocumentHelper.extractIds( DocumentHelper.getObjectsWithNotNull(newEntries, FIELD_SALEORDELINE_ITEMALIASID), FIELD_SALEORDELINE_ITEMALIASID);
        Map<Id, dmpl__ItemAlias__c> itemAliases = new Map<Id, dmpl__ItemAlias__c>([SELECT Id, Name, dmpl__ItemId__c, dmpl__SKUId__c, dmpl__PartnerAccountId__c, dmpl__ItemLotTypeId__c FROM dmpl__ItemAlias__c WHERE Id IN : itemAliasIds]);
        for(dmpl__SaleOrderLine__c lineEntry : newEntries)
        {
            if(!String.isBlank(lineEntry.dmpl__ItemAliasId__c))
            {
                dmpl__ItemAlias__c currentItemAlias = itemAliases.get(lineEntry.dmpl__ItemAliasId__c);
                if(currentItemAlias != null)
                {
                    if(lineEntry.dmpl__ItemId__c != null && currentItemAlias.dmpl__ItemId__c != null && lineEntry.dmpl__ItemId__c != currentItemAlias.dmpl__ItemId__c)
                        lineEntry.addError(String.format(String.valueOf(System.Label.DocumentValidation_IncorrectItemAlias), new String[]{String.valueOf(FIELD_SALEORDELINE_ITEMID)})); 
                    if(lineEntry.dmpl__SKUId__c != null && currentItemAlias.dmpl__SKUId__c != null && lineEntry.dmpl__SKUId__c != currentItemAlias.dmpl__SKUId__c)
                        lineEntry.addError(String.format(String.valueOf(System.Label.DocumentValidation_IncorrectItemAlias), new String[]{String.valueOf(FIELD_SALEORDELINE_SKUID)})); 

                    if(lineEntry.dmpl__ItemId__c == null)
                        lineEntry.dmpl__ItemId__c = currentItemAlias.dmpl__ItemId__c;
                    if(lineEntry.dmpl__SKUId__c == null)
                        lineEntry.dmpl__SKUId__c = currentItemAlias.dmpl__SKUId__c;
                    if(lineEntry.dmpl__ItemLotTypeId__c == null)
                        lineEntry.dmpl__ItemLotTypeId__c = currentItemAlias.dmpl__ItemLotTypeId__c;
                }
            }
        }
    }

    private static void setDefaultSKU(
        List<dmpl__SaleOrderLine__c> newEntries, 
        Map<Id, dmpl__Item__c> items){
        // for(dmpl__SaleOrderLine__c lineEntry : newEntries){
        //     dmpl__Item__c item = items.get(lineEntry.dmpl__ItemId__c);
        //     if(item !=null 
        //         && lineEntry.dmpl__SKUId__c == null 
        //         && item.dmpl__IsSKURequired__c == true){
        //         for(dmpl__SKU__c sku : item.dmpl__SKUs__r){
        //             if(sku.dmpl__IsDefault){
        //                 lineEntry.dmpl__SKUId__c = sku.Id;
        //                 break;
        //             }
        //         }
        //     }
        // }
    }

    private static void setInvoiceGroup(
        List<dmpl__SaleOrderLine__c> newEntries,
        Map<Id, dmpl__Item__c> items){
        SecurityHelper.ensureCanWriteField(
            'dmpl__InvoiceGroup__c', 
            'dmpl__SaleOrderLine__c');
        for(dmpl__SaleOrderLine__c lineEntry : newEntries){
            dmpl__Item__c currentItem =  items.get(lineEntry.dmpl__ItemId__c);
            if(lineEntry.dmpl__InvoiceGroup__c == null && currentItem != null){
                lineEntry.dmpl__InvoiceGroup__c = currentItem.dmpl__InvoiceGroup__c;
            }
        }
    }

    private static void setSubscriptionDetails(
        List<dmpl__SaleOrderLine__c> newEntries,
        Map<Id, dmpl__Item__c> items){
        SecurityHelper.ensureCanWriteFields(new string[]{
            'dmpl__BillingType__c',
            'dmpl__BillingFrequency__c',
            'dmpl__ChargeType__c'
        }, 'dmpl__SaleOrderLine__c');
        for(dmpl__SaleOrderLine__c lineEntry : newEntries){
                dmpl__Item__c currentItem =  items.get(lineEntry.dmpl__ItemId__c);
                if(currentItem != null){
                    if(lineEntry.dmpl__BillingType__c == null)
                        lineEntry.dmpl__BillingType__c = currentItem.dmpl__BillingType__c;
                    if(lineEntry.dmpl__BillingFrequency__c == null)
                        lineEntry.dmpl__BillingFrequency__c = currentItem.dmpl__BillingFrequency__c;
                    if(lineEntry.dmpl__ChargeType__c == null)
                        lineEntry.dmpl__ChargeType__c = currentItem.dmpl__ChargeType__c;
                }
        }
    }

    private static void setAlternateItem(
        List<dmpl__SaleOrderLine__c> newEntries, 
        Map<Id, dmpl__Item__c> items){
        for(dmpl__SaleOrderLine__c newEntry : newEntries){
            dmpl__Item__c item = items.get(newEntry.dmpl__ItemId__c);
            if(item?.dmpl__ItemsAlternates__r == null){
                continue;
            }
            for(dmpl__ItemAlternate__c alternateItem : item.dmpl__ItemsAlternates__r){
                if(newEntry.dmpl__AlternateItemId__c != null 
                    && newEntry.dmpl__AlternateItemId__c == alternateItem.Id){
                    newEntry.dmpl__OriginalItemId__c = newEntry.dmpl__ItemId__c;
                    newEntry.dmpl__ItemId__c = alternateItem.dmpl__AlternateItemId__c;
                    newEntry.dmpl__AlternateItemId__c = null;
                }

                if(alternateItem.dmpl__AlternateType__c == 'Superseded'){
                    newEntry.dmpl__ItemId__c = alternateItem.dmpl__AlternateItemId__c;
                    newEntry.dmpl__OriginalItemId__c = alternateItem.dmpl__ItemId__c;
                }
            }
        }
        items = new Map<Id,dmpl__Item__c>(
            ItemHelper.getCachedItems(
                DocumentHelper.extractIds(
                    newEntries, 
                    FIELD_SALEORDELINE_ITEMID)));
    }

    private static void validateChangeInQuantity(
        List<dmpl__SaleOrderLine__c> oldEntries, 
        List<dmpl__SaleOrderLine__c> newEntries){
        Map<Id, dmpl__SaleOrderLine__c> oldObjectsMap = new Map<Id, dmpl__SaleOrderLine__c>(oldEntries);
        for(dmpl__SaleOrderLine__c lineEntry : newEntries){
            dmpl__SaleOrderLine__c oldEntry = oldObjectsMap.get(lineEntry.Id);
            if(oldEntry != null){
                if(oldEntry.dmpl__Quantity__c != lineEntry.dmpl__Quantity__c) {
                    Double transactedQty = 0;
                    if(oldEntry.dmpl__FulfilmentOrderQuantity__c!=null){
                        transactedQty +=oldEntry.dmpl__FulfilmentOrderQuantity__c;
                    }
                    if(oldEntry.dmpl__CancelledQuantity__c!=null){
                        transactedQty +=oldEntry.dmpl__CancelledQuantity__c;
                    }
                    if(oldEntry.dmpl__ReturnedQuantity__c!=null){
                        transactedQty +=oldEntry.dmpl__ReturnedQuantity__c;
                    }
                    if(lineEntry.dmpl__Quantity__c < transactedQty){
                        lineEntry.addError(String.format(
                            String.valueOf(
                                System.Label.IntegrityFailed_TransactedQuantityCanNotBeReduced), 
                            new String[]{String.valueOf(transactedQty)})); 
                    }
                } 

                if(oldEntry.dmpl__CancelledQuantity__c != lineEntry.dmpl__CancelledQuantity__c) {
                    if(lineEntry.dmpl__CancelledQuantity__c > oldEntry.dmpl__PendingInvoiceQuantity__c
                        && lineEntry.dmpl__CancelledQuantity__c > oldEntry.dmpl__PendingFulfilmentOrderQuantity__c){
                        lineEntry.addError(
                            String.valueOf(
                                System.Label.IntegrityFailed_CanNotCancelledQuantity)); 
                    }
                } 
            }   
        }
    }

    private static void validateChangeInKeyFields(
        List<dmpl__SaleOrderLine__c> oldEntries, 
        List<dmpl__SaleOrderLine__c> newEntries){
        Map<Id, dmpl__Item__c> items = new Map<Id,dmpl__Item__c>(
            ItemHelper.getCachedItems(
                DocumentHelper.extractIds(
                    oldEntries, 
                    FIELD_SALEORDELINE_ITEMID)));
        List<dmpl__SaleOrderLine__c> modifiedObjects = DocumentHelper.getModifiedNewObjects(
            LIST_FIELDS_KEY, 
            oldEntries, 
            newEntries);
        Map<Id, dmpl__SaleOrderLine__c> oldObjectsMap = new Map<Id, dmpl__SaleOrderLine__c>(oldEntries);
        for(dmpl__SaleOrderLine__c newEntry : modifiedObjects){
            dmpl__SaleOrderLine__c oldEntry = oldObjectsMap.get(newEntry.Id);
            dmpl__Item__c item = items.get(oldEntry.dmpl__ItemId__c);
            if(item.dmpl__IsPackage__c 
                || oldEntry.dmpl__PackageSaleOrderLineId__c != null)
            {
                newEntry.addError(String.format(
                        String.valueOf(System.Label.IntegrityFailed_KeyFieldNotEditable), 
                        new String[]{'Item, SKU'})); 
            }
        }
    }

    // private static void createDocumentServiceContract(
    //     List<dmpl__SaleOrderLine__c> newEntries){
    //         List<Id> itemContractIds = CollectionHelper.extractIds(
    //             newEntries,
    //             'dmpl__ItemServiceContractId__c'
    //         );
    //         List<dmpl__ItemServiceContract__c> itemServiceContracts = queryItemServiceContractLines(
    //             itemContractIds);
    //         List<dmpl__DocumentServiceContract__c> documentServiceContract = new List<dmpl__DocumentServiceContract__c>();
    //         for(dmpl__SaleOrderLine__c entry :newEntries){
    //             if(entry.dmpl__ItemServiceContractId__c != null){
    //                 dmpl__ItemServiceContract__c itemContract = (dmpl__ItemServiceContract__c)CollectionHelper.getObject(itemServiceContracts,entry.dmpl__ItemServiceContractId__c);
    //                 for(dmpl__ItemServiceContractLine__c line : itemContract.dmpl__ItemServiceContractLines__r){
    //                     dmpl__DocumentServiceContract__c dsc = new dmpl__DocumentServiceContract__c(); 
    //                     dsc.dmpl__ComponentItemId__c =  line.dmpl__ComponentItemId__c;
    //                     dsc.dmpl__IsInScope__c = line.dmpl__IsInScope__c;
    //                     dsc.dmpl__Quantity__c = line.dmpl__Quantity__c;
    //                     dsc.dmpl__SaleOrderLineId__c = entry.Id;
    //                     documentServiceContract.add(dsc);
    //                 } 
    //             }
    //         }
    //         insert documentServiceContract;
    //     }


    private static List<dmpl__SaleOrder__c> querySaleOrderDocument(
        List<ID> saleOrderLineIds)
    {
        SecurityHelper.ensureCanReadFields(
            new string[]
            {
                'dmpl__DocumentDate__c',
                'dmpl__Status__c',
                'dmpl__AccountId__c',
                'dmpl__PartnerAccountId__c',
                'dmpl__BranchId__c',
                'dmpl__PriceListId__c',
                'dmpl__DiscountGroupId__c',
                'dmpl__TaxSupplyType__c',
                'dmpl__PriceAsOnDate__c',
                'dmpl__TransactionType__c',
                'dmpl__SkipScheme__c'
            }, 'dmpl__SaleOrder__c');
        return [
            SELECT 
                Id, 
                Name, 
                dmpl__DocumentDate__c,
                dmpl__Status__c,
                dmpl__AccountId__c,
                dmpl__PartnerAccountId__c,
                dmpl__BranchId__c,
                dmpl__PriceListId__c,
                dmpl__DiscountGroupId__c,
                dmpl__TaxSupplyType__c,
                dmpl__PriceAsOnDate__c,
                dmpl__TransactionType__c,
                dmpl__SkipScheme__c
            FROM dmpl__SaleOrder__c 
            WHERE ID IN : saleOrderLineIds ];
    }

    private static List<dmpl__SaleOrder__c> querySaleOrderDocumentOnExternalId(
        List<String> saleOrderExternalIds)
    {
        return [
            SELECT 
                Id, 
                dmpl__RNAExternalId__c
            FROM dmpl__SaleOrder__c 
            WHERE dmpl__RNAExternalId__c IN : saleOrderExternalIds ];
    }

    private static List<dmpl__SaleReturnLine__c> querySaleReturnLines(
        List<ID> saleReturnIds)
    {
        SecurityHelper.ensureCanReadFields(new List<String>
        {
            'Name', 
            'dmpl__Quantity__c'
        },'dmpl__SaleReturnLine__c');
        return [SELECT ID,
        Name,
        Quantity__c
        FROM dmpl__SaleReturnLine__c
        WHERE ID IN : saleReturnIds];
    }

    private static List<dmpl__SaleOrderLine__c> querySaleOrderLines(
        List<ID> saleOrderLineIds)
    {
        SecurityHelper.ensureCanReadFields(new List<String>
        {
            'Name', 
            'dmpl__ReturnedQuantity__c',
            'dmpl__ItemId__c',
            'dmpl__SKUId__c',
            'dmpl__Quantity__c'
        },'dmpl__SaleOrderLine__c');
        return [ SELECT ID, 
            Name, 
            dmpl__ReturnedQuantity__c,
            dmpl__ItemId__c,
            dmpl__SKUId__c,
            dmpl__Quantity__c,
            dmpl__IsILPostingApproved__c,
            dmpl__IsILPosted__c
        FROM dmpl__SaleOrderLine__c
        WHERE ID IN : saleOrderLineIds];
    }   

    private static List<dmpl__SaleOrderLine__c> querySaleOrderLinesOfSaleOrders(
        List<ID> saleOrderIds)
    {
        SecurityHelper.ensureCanReadFields(new List<String>
        {
            'Name', 
            'dmpl__ItemId__c',
            'dmpl__SKUId__c',
            'dmpl__Quantity__c',
            'dmpl__UnitPrice__c',
            'dmpl__UnitPrice2__c',
            'dmpl__TaxGroupId__c',
            'dmpl__ItemLotTypeId__c',
            'dmpl__TaxAmount__c',
            'dmpl__SaleOrderId__c',
            'dmpl__PriceListId__c',
            'dmpl__IsPriceBundled__c'
        },'dmpl__SaleOrderLine__c');
        return [ SELECT ID, 
            Name, 
            dmpl__ItemId__c,
            dmpl__SKUId__c,
            dmpl__Quantity__c,
            dmpl__UnitPrice__c,
            dmpl__UnitPrice2__c,
            dmpl__TaxGroupId__c,
            dmpl__ItemLotTypeId__c,
            dmpl__TaxAmount__c,
            dmpl__SaleOrderId__c,
            dmpl__PriceListId__c,
            dmpl__IsPriceBundled__c,
            dmpl__PriceAsOnDate__c,
            dmpl__IsILPostingApproved__c,
            dmpl__IsILPosted__c
        FROM dmpl__SaleOrderLine__c
        WHERE dmpl__SaleOrderId__c IN : saleOrderIds];
    }  

    private static void setOrderDiscount(List<dmpl__SaleOrderLine__c> newEntries){
        for(dmpl__SaleOrderLine__c lineEntry : newEntries){
            if(lineEntry.dmpl__OrderDiscount__c != null
                && lineEntry.dmpl__OrderDiscount__c >0){
                lineEntry.dmpl__Discount__c = (lineEntry.dmpl__OrderDiscount__c/100);
            }
        }
    }

    private static void updateDiscount(List<dmpl__SaleOrderLine__c> newEntries){
        for(dmpl__SaleOrderLine__c lineEntry : newEntries){
            if(lineEntry.dmpl__DiscountAmount__c > 0){
                lineEntry.dmpl__Discount__c = 0;
            }
            if(lineEntry.dmpl__DiscountAmount2__c > 0){
                lineEntry.dmpl__Discount2__c = 0;
            }
        }
    }

    private static List<dmpl__ServiceRequest__c> queryServiceRequests(
        List<ID> serviceRequestIds){
        SecurityHelper.ensureCanReadFields(new List<String>{
            'dmpl__Amount__c',
            'dmpl__ItemId__c',
            'dmpl__SKUId__c',
            'dmpl__Quantity__c',
            'dmpl__ServiceRequestId__c',
            'dmpl__TaxGroupId__c',
            'dmpl__UnitPrice__c',
            'dmpl__UnitPrice2__c',
            'dmpl__ItemLotTypeId__c'
            }, 'dmpl__ServiceRequestLine__c');
        return [SELECT ID,
        Name,
        (
            SELECT
            ID,
            dmpl__Amount__c,
            dmpl__ItemId__c,
            dmpl__SKUId__c,
            dmpl__Quantity__c,
            dmpl__ServiceRequestId__c,
            dmpl__TaxGroupId__c,
            dmpl__UnitPrice__c,
            dmpl__UnitPrice2__c,
            dmpl__ItemLotTypeId__c,
            dmpl__DiscountAmount__c,
            dmpl__Discount__c,
            dmpl__Discount2__c,
            dmpl__DiscountAmount2__c,
            dmpl__ContractDiscount__c,
            dmpl__ContractDiscountAmount__c
            FROM ServiceAppointmentLines__r
        )
        FROM dmpl__ServiceRequest__c
        WHERE ID IN : serviceRequestIds];
    }

    private static List<dmpl__Quote__c> queryServiceEstimates(List<ID> serviceEstimateIds){
        SecurityHelper.ensureCanReadFields(new List<String>{
            'dmpl__Amount__c',
            'dmpl__IsApproved__c',
            'dmpl__IsDeclined__c',
            'dmpl__ItemId__c',
            'dmpl__SKUId__c',
            'dmpl__Quantity__c',
            'dmpl__QuoteId__c',
            'dmpl__Discount__c',
            'dmpl__ServiceRequestLineId__c',
            'dmpl__TaxGroupId__c',
            'dmpl__UnitPrice__c',
            'dmpl__UnitPrice2__c',
            'dmpl__ItemLotTypeId__c'
        }, 'dmpl__QuoteLine__c');
        return [SELECT 
        ID,
        Name,
        (
            SELECT
            ID,
            Name,
            dmpl__Amount__c,
            dmpl__IsApproved__c,
            dmpl__IsDeclined__c,
            dmpl__ItemId__c,
            dmpl__SKUId__c,
            dmpl__Quantity__c,
            dmpl__QuoteId__c,
            dmpl__Discount__c,
            dmpl__DiscountAmount__c,
            dmpl__Discount2__c,
            dmpl__DiscountAmount2__c,
            dmpl__ContractDiscount__c,
            dmpl__ContractDiscountAmount__c,
            dmpl__ServiceRequestLineId__c,
            dmpl__TaxGroupId__c,
            dmpl__UnitPrice__c,
            dmpl__UnitPrice2__c,
            dmpl__ItemLotTypeId__c
            FROM dmpl__QuoteLines__r
        )
        FROM dmpl__Quote__c
        WHERE ID IN : serviceEstimateIds];
    }
}