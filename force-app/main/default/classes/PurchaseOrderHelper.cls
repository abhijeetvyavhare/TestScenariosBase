public with sharing class PurchaseOrderHelper 
{

    private static Boolean skipValidations = false;

    private static final string OBJECT_PURCHASEORDER = 'dmpl__PurchaseOrder__c';
    private static final string FIELD_PURCHASEORDER_STATUS = 'dmpl__Status__c';
    private static final string FIELD_PURCHASEORDER_PARTNERACCOUNTID = 'dmpl__PartnerAccountId__c';
    private static final string FIELD_PURCHASEORDER_BRANCHID = 'dmpl__BranchId__c';
    private static final string FIELD_PURCHASEORDER_SUPPLIERACCOUNTID ='dmpl__SupplierAccountId__c';
    private static final string FIELD_PURCHASEORDER_DOCUMENTDATE ='dmpl__DocumentDate__c';
    private static final string FIELD_PURCHASEORDER_PRICELISTID ='dmpl__PriceListId__c';
    private static final string FIELD_PURCHASEORDERLINE_PURCHASEORDERID = 'dmpl__PurchaseOrderId__c';
    private static final string FIELD_PURCHASEORDER_PERFORMRELEASEINVOICE = 'dmpl__PerformReleaseInvoice__c';
    private static final string FIELD_PURCHASEORDER_PERFORMRELEASERECEIPT = 'dmpl__PerformReleaseReceipt__c';
    private static final string FIELD_PURCHASEORDER_PERFORMRELEASESALEORDER = 'dmpl__PerformReleaseSaleOrder__c';
    private static final string FIELD_PURCHASEORDER_PERFORMKPICALCULATION = 'dmpl__PerformKPICalculation__c';
    private static final string FIELD_PURCHASEORDER_RESOURCEID = 'dmpl__ResourceId__c';
    
    private static final string FIELD_PURCHASEORDER_BILLINGADDRESS ='dmpl__BillingAddress__c';
    private static final string FIELD_PURCHASEORDER_SHIPPINGADDRESS ='dmpl__ShippingAddress__c';
    private static final string FIELD_PURCHASEORDER_BILLINGADDRESSID ='dmpl__BillingAddressId__c';
    private static final string FIELD_PURCHASEORDER_SHIPPINGADDRESSID ='dmpl__ShippingAddressId__c';

    private static final string FIELD_PURCHASEORDER_TAXGROUPID = 'dmpl__TaxGroupId__c';
    private static final string FIELD_PURCHASEORDER_TAXID = 'dmpl__TaxId__c';
    private static final string FIELD_PURCHASEORDER_AMOUNT = 'dmpl__TotalLineAmount__c';
    private static final string FIELD_PURCHASEORDER_GROSSAMOUNT = 'dmpl__TotalLineGrossAmount__c';
    private static final string FIELD_PURCHASEORDER_TCSELIGIBLEAMOUNT = 'dmpl__TCSEligibleAmount__c';

    private static final string RELATION_PURCHASEORDER_PURCHASEORDERLINES = 'dmpl__PurchaseOrderId__r';
    private static final List<String> LIST_NON_EDITABLE_FIELDS = new List<String>{FIELD_PURCHASEORDER_BRANCHID, FIELD_PURCHASEORDER_DOCUMENTDATE, FIELD_PURCHASEORDER_PARTNERACCOUNTID};
    private static final List<String> LIST_FIELDS_SYSTEM = new List<String>{};
   

    public static void validateData(Boolean isInsert, Boolean isDelete, Boolean isUpdate, List<dmpl__PurchaseOrder__c> oldEntries, List<dmpl__PurchaseOrder__c> newEntries)
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
            StatusHelper.validateStatusNew(OBJECT_PURCHASEORDER, FIELD_PURCHASEORDER_STATUS, newEntries);
            DocumentHelper.validateChangeInSystemFields(LIST_FIELDS_SYSTEM, newEntries);
            ValidationHelper.validatePartnerAndBranch(FIELD_PURCHASEORDER_PARTNERACCOUNTID, FIELD_PURCHASEORDER_BRANCHID, newEntries);
            ValidationHelper.validateResource(
                    FIELD_PURCHASEORDER_RESOURCEID, 
                    newEntries);
        }else if(isUpdate){
            StatusHelper.validateStatusEdit(OBJECT_PURCHASEORDER, FIELD_PURCHASEORDER_STATUS, oldEntries, newEntries);
            DocumentHelper.validateChangeInKeyFields(LIST_NON_EDITABLE_FIELDS, oldEntries, newEntries);
            DocumentHelper.validateChangeInSystemFields(LIST_FIELDS_SYSTEM, oldEntries, newEntries);
            dfsHelper.DocumentStatusRestrictEdits_Edit(OBJECT_PURCHASEORDER, FIELD_PURCHASEORDER_STATUS, oldEntries, newEntries);
            dfsHelper.DocumentStatusRestrictFieldsEdits(OBJECT_PURCHASEORDER, FIELD_PURCHASEORDER_STATUS, oldEntries, newEntries);
            ValidationHelper.validateResource(
                    FIELD_PURCHASEORDER_RESOURCEID, 
                    newEntries);
        }else if(isDelete){
            dfsHelper.DocumentStatusRestrictEdits_Delete(OBJECT_PURCHASEORDER, FIELD_PURCHASEORDER_STATUS, oldEntries);
        }
    } catch (Exception error) {
        ExceptionLogHelper.logException(error);
        throw error;
    }
    }

    public static void postData(Boolean isInsert, Boolean isDelete, Boolean isUpdate, List<dmpl__PurchaseOrder__c> oldEntries, List<dmpl__PurchaseOrder__c> newEntries)
    { 
        DocumentStatusDFSHelper dfsHelper = new DocumentStatusDFSHelper();
        if(isInsert){
            dfsHelper.DocumentStatusSetFlag(OBJECT_PURCHASEORDER, FIELD_PURCHASEORDER_STATUS, newEntries);
            dfsHelper.DocumentStatusReSetFlag(OBJECT_PURCHASEORDER, FIELD_PURCHASEORDER_STATUS, newEntries);
            PriceListHelper.setDefaultPriceListIds(newEntries);
            DiscountGroupHelper.setDefaultDiscountGroupIds(newEntries);
            setDefaultAddress(newEntries);
            DocumentNameHelper.generateDocumentName(newEntries);
            TaxHelper.setHeaderTaxes(
                newEntries);
        }else if(isUpdate){
            dfsHelper.DocumentStatusSetFlag(OBJECT_PURCHASEORDER, FIELD_PURCHASEORDER_STATUS, oldEntries, newEntries);
            dfsHelper.DocumentStatusReSetFlag(OBJECT_PURCHASEORDER, FIELD_PURCHASEORDER_STATUS, oldEntries, newEntries);
            
            List<dmpl__PurchaseOrder__c> modifiedObjects = DocumentHelper.getApprovedObjects(FIELD_PURCHASEORDER_PERFORMRELEASEINVOICE, oldEntries, newEntries);
            if(modifiedObjects.size()>0){
                createPurchaseInvoice(modifiedObjects);
            }

            modifiedObjects = DocumentHelper.getApprovedObjects(FIELD_PURCHASEORDER_PERFORMRELEASERECEIPT, oldEntries, newEntries);
            if(modifiedObjects.size()>0){
                createGoodsReceipt(modifiedObjects);
            }

            modifiedObjects = DocumentHelper.getApprovedObjects(FIELD_PURCHASEORDER_PERFORMKPICALCULATION, oldEntries, newEntries);
            if(modifiedObjects.size()>0){
                updatePerformanceKPI(modifiedObjects);
            }
            modifiedObjects = DocumentHelper.getModifiedNewObjects(new string[]{
                FIELD_PURCHASEORDER_TAXGROUPID,
                FIELD_PURCHASEORDER_TAXID,
                FIELD_PURCHASEORDER_TCSELIGIBLEAMOUNT
                    }, oldEntries, newEntries);
                    if(modifiedObjects.size()>0){
                        TaxHelper.setHeaderTaxes(modifiedObjects);
                    }
            setDefaultAddress(newEntries, oldEntries);
            RoundOffHelper.setRoundOff(
                newEntries,
                'dmpl__TotalLineAmount__c',
                'dmpl__TotalTaxAmount2__c');
        }else if(isDelete){
            TaxHelper.deleteHeaderTaxes(oldEntries);
        }
    }

    public static void afterPostData(
        Boolean isInsert, 
        Boolean isDelete, 
        Boolean isUpdate, 
        List<dmpl__PurchaseOrder__c> oldEntries, 
        List<dmpl__PurchaseOrder__c> newEntries){ 
            if(isInsert){
                TaxHelper.createHeaderTaxes(
                    isInsert,
                    newEntries);
            } else if(isUpdate){
                List<dmpl__PurchaseOrder__c> modifiedObjects = DocumentHelper.getModifiedNewObjects(
                    'dmpl__PriceAsOnDate__c', 
                    oldEntries, 
                    newEntries);
                if(modifiedObjects.size()>0){
                    PurchaseOrderLineHelper.performReprice(
                        CollectionHelper.extractIds(modifiedObjects));
                }
                modifiedObjects = DocumentHelper.getModifiedNewObjects(new string[]{
                    FIELD_PURCHASEORDER_TAXGROUPID,
                    FIELD_PURCHASEORDER_TAXID,
                    FIELD_PURCHASEORDER_TCSELIGIBLEAMOUNT
                }, oldEntries, newEntries);
                if(modifiedObjects.size()>0){
                    TaxHelper.createHeaderTaxes(
                    isInsert, 
                    modifiedObjects);
                }
            }
    }

    private static void updatePerformanceKPI(List<dmpl__PurchaseOrder__c> newEntries)
    {
        PerformanceKPIHelper.upsertPerformanceKPI(OBJECT_PURCHASEORDER, 'SCHEME', newEntries);
        PerformanceKPIHelper.upsertPerformanceKPI(OBJECT_PURCHASEORDER, 'INCENTIVE', newEntries);
        for(dmpl__PurchaseOrder__c lineEntry : newEntries)
        {
            lineEntry.dmpl__PerformKPICalculation__c = false;
            lineEntry.dmpl__IsKPICalculated__c = true;
        }
    }

    public static void createPurchaseInvoice(List<SourceObjectInfo> orderLinesInfo){
        if(orderLinesInfo == null || orderLinesInfo.size() ==0){
            return;
        }
        BillHelper.createPurchaseInvoiceFromPurchaseOrder(orderLinesInfo);
    }

    public static void createPurchaseInvoice(List<dmpl__PurchaseOrder__c> lineEntries){
        BillHelper.createPurchaseInvoiceFromPurchaseOrder(lineEntries);
        SecurityHelper.ensureCanWriteField('dmpl__PerformReleaseInvoice__c', 'dmpl__PurchaseOrder__c');
        SecurityHelper.ensureCanWriteField('dmpl__IsInvoiceReleased__c', 'dmpl__PurchaseOrder__c');
        for(dmpl__PurchaseOrder__c lineEntry : lineEntries){
            lineEntry.dmpl__PerformReleaseInvoice__c = false;
            lineEntry.dmpl__IsInvoiceReleased__c = true;
        }
    }

    public static CreateRelatedResult createPurchaseOrderFromRequisition(
        Id requisitionId){
            return CreateRelatedResult.InitFrom(
                createPurchaseOrderFromRequisition(
                    queryPurchaseRequisitionLines(
                        new List<Id> {requisitionId}, 
                        null),
                    null,
                    null));
    }

    public static void createPurchaseOrderFromRequisition(
        List<dmpl__PurchaseRequisition__c> requisitions){
        createPurchaseOrderFromRequisition(
            queryPurchaseRequisitionLines(
                DocumentHelper.extractIds(requisitions), 
                null),
            null,
            null);
    }

    public static CreateRelatedResult createPurchaseOrderFromRequisition(
        List<SourceObjectInfo> orderLinesInfo){
            return CreateRelatedResult.InitFrom(
                createPurchaseOrderFromRequisition(
                    queryPurchaseRequisitionLines(
                        null, 
                        SourceObjectInfo.extractIds(orderLinesInfo)),
                orderLinesInfo,
                null));
    }

    public static CreateRelatedResult createPurchaseOrderFromRequisition(
        List<SourceObjectInfo> orderLinesInfo,
        Id purchaseOrderId){
            return CreateRelatedResult.InitFrom(
                createPurchaseOrderFromRequisition(
                    queryPurchaseRequisitionLines(
                        null, 
                        SourceObjectInfo.extractIds(orderLinesInfo)),
                orderLinesInfo,
                purchaseOrderId));
    }
    
    public static void createPurchaseOrderFromAutoPurchaseOrder(List<dmpl__AutoPurchaseOrder__c> autoPurchaseOrders){
        createPurchaseOrder(autoPurchaseOrders);
    }

    //(Depreciated)
    public static CreateRelatedResult createPurchaseOrderFromRepairOrder(
        List<dmpl__RepairOrder__c> repairOrders){
            return CreateRelatedResult.InitFrom(
                createPurchaseOrderFromFulfillmentInternal(
                    queryFulfillments(
                        null,
                        DocumentHelper.extractIds(repairOrders)),
                    null));
    }

    //(Depreciated)
    public static CreateRelatedResult createPurchaseOrderFromRepairOrder(
        Id repairOrderId){
            return CreateRelatedResult.InitFrom(
                createPurchaseOrderFromFulfillmentInternal(
                    queryFulfillments(
                        null,
                        new List<Id> {repairOrderId}),
                    null));
    }

    public static CreateRelatedResult createPurchaseOrderFromFulfillment(
        List<Id> fulfillmentIds){
            return CreateRelatedResult.InitFrom(
                createPurchaseOrderFromFulfillmentInternal(
                    queryFulfillments(
                        fulfillmentIds,
                        null),
                null));
    }

    public static CreateRelatedResult createPurchaseOrderFromFulfillment(
        Id fulfillmentId){
            return CreateRelatedResult.InitFrom(
                createPurchaseOrderFromFulfillmentInternal(
                    queryFulfillments(
                        new List<Id>{fulfillmentId},
                        null),
                    null));
    }

    public static CreateRelatedResult createPurchaseOrderFromFulfillment(
        List<SourceObjectInfo> orderLinesInfo){
            return CreateRelatedResult.InitFrom(
                createPurchaseOrderFromFulfillmentInternal(
                    queryFulfillments(
                        SourceObjectInfo.extractIds(orderLinesInfo)),
                    orderLinesInfo));
    }

    public static void createGoodsReceipt(List<SourceObjectInfo> orderLinesInfo){
        if(orderLinesInfo == null || orderLinesInfo.size() ==0){
            return;
        }
        GoodsReceiptHelper.createGoodsReceiptFromPurchaseOrder(orderLinesInfo);
    }

    public static void createGoodsReceipt(List<dmpl__PurchaseOrder__c> lineEntries){
        GoodsReceiptHelper.createGoodsReceiptFromPurchaseOrder(lineEntries);
        SecurityHelper.ensureCanWriteField('dmpl__PerformReleaseReceipt__c', 'dmpl__PurchaseOrder__c');
        SecurityHelper.ensureCanWriteField('dmpl__IsReceiptReleased__c', 'dmpl__PurchaseOrder__c');
        for(dmpl__PurchaseOrder__c lineEntry : lineEntries){
            lineEntry.dmpl__PerformReleaseReceipt__c = false;
            lineEntry.dmpl__IsReceiptReleased__c = true;
        }
    }

    @TestVisible
    private static Map<Id,dmpl__PurchaseOrder__c>  createPurchaseOrderFromFulfillmentInternal(
        List<dmpl__InventoryFulfillment__c> fulfillments,
        List<SourceObjectInfo> orderLinesInfo){
        List<dmpl__PurchaseOrder__c> newPurchaseOrders = new List<dmpl__PurchaseOrder__c>();
        newPurchaseOrders.addAll(createPurchaseOrderDocuments(
            fulfillments));

        if(newPurchaseOrders.size() > 0){
            try {
                SecurityHelper.ensureCanCreateObject('dmpl__PurchaseOrder__c');
                SecurityHelper.ensureCanCreateObject('dmpl__PurchaseOrderLine__c');
                skipValidations = true;
                SecurityHelper.ensureCanWriteFields(new string[]{'dmpl__BranchId__c','dmpl__PartnerAccountId__c','dmpl__SupplierAccountId__c','dmpl__RepairOrderId__c'}, 'dmpl__PurchaseOrder__c');
                insert newPurchaseOrders;            
                PurchaseOrderLineHelper.createPurchaseOrderLineFromFulfillment(
                    newPurchaseOrders, 
                    fulfillments,
                    orderLinesInfo);
            } finally {
                skipValidations = false;
            }
        }
        return new Map<Id,dmpl__PurchaseOrder__c>(newPurchaseOrders);
    }

    @testvisible
    private static void createPurchaseOrder(List<dmpl__AutoPurchaseOrder__c> autoPurchaseOrders){
        List<dmpl__PurchaseOrder__c> newPurchaseOrders = new List<dmpl__PurchaseOrder__c>();

        for(dmpl__AutoPurchaseOrder__c autoPurchaseOrder : autoPurchaseOrders){
            newPurchaseOrders.add(createPurchaseOrderDocument(autoPurchaseOrder));
        }

        if(newPurchaseOrders.size() > 0){
            try {
                SecurityHelper.ensureCanCreateObject('dmpl__PurchaseOrder__c');
                SecurityHelper.ensureCanCreateObject('dmpl__PurchaseOrderLine__c');
                skipValidations = true;
                SecurityHelper.ensureCanWriteFields(new string[]{'dmpl__BranchId__c','dmpl__PartnerAccountId__c','dmpl__SupplierAccountId__c','dmpl__AutoPurchaseOrderId__c'}, 'dmpl__PurchaseOrder__c');
                insert newPurchaseOrders;            
                PurchaseOrderLineHelper.createPurchaseOrderLineFromPurchaseOrder(newPurchaseOrders);
            } finally {
                skipValidations = false;
            }
        }
    }

    private static dmpl__PurchaseOrder__c createPurchaseOrderDocument(dmpl__AutoPurchaseOrder__c autoPurchaseOrder)
    {
        return new dmpl__PurchaseOrder__c(
            dmpl__BranchId__c = autoPurchaseOrder.dmpl__BranchId__c,
            dmpl__PartnerAccountId__c = autoPurchaseOrder.dmpl__PartnerAccountId__c,
            dmpl__SupplierAccountId__c = autoPurchaseOrder.dmpl__SupplierAccountId__c,
            dmpl__AutoPurchaseOrderId__c = autoPurchaseOrder.ID
        );
    }

    private static List<dmpl__PurchaseOrder__c> createPurchaseOrderDocuments(
        List<dmpl__InventoryFulfillment__c> fulfilments){
            List<dmpl__PurchaseOrder__c> purchaseOrders = new List<dmpl__PurchaseOrder__c>();
            for(dmpl__InventoryFulfillment__c fulfillment :  fulfilments){
                purchaseOrders.add(new dmpl__PurchaseOrder__c(
                    dmpl__BranchId__c = fulfillment.dmpl__BranchId__c,
                    dmpl__PartnerAccountId__c = fulfillment.dmpl__PartnerAccountId__c,
                    dmpl__RepairOrderId__c = fulfillment.dmpl__RepairOrderId__c,
                    dmpl__FulfillmentId__c = fulfillment.Id
                ));
            }
            return purchaseOrders;
    }

    private static Map<Id,dmpl__PurchaseOrder__c> createPurchaseOrderFromRequisition(
        List<dmpl__PurchaseRequisitionLine__c> requisitionLines,
        List<SourceObjectInfo> orderLinesInfo,
        Id purchaseOrderId){
            if(requisitionLines.size() == 0){
                throw new DMPLException(String.format(String.valueOf(System.Label.Generic_EmptyActionParam), new String[]{dmpl__PurchaseRequisitionLine__c.class.getName()}));
            }

            Map<Id, dmpl__PurchaseOrder__c> orderDocuments = new Map<Id,dmpl__PurchaseOrder__c>();
            Map<Id, List<dmpl__PurchaseOrderLine__c>> purchaseOrderLines = new Map<Id, List<dmpl__PurchaseOrderLine__c>>();
            for(dmpl__PurchaseRequisitionLine__c requisitionLine : requisitionLines){
                if(requisitionLine.dmpl__ItemId__c !=null 
                    && requisitionLine.dmpl__PendingQuantity__c>0){

                    dmpl__PurchaseOrder__c orderDocument = null;
                    Id usePOKey = purchaseOrderId != null ? purchaseOrderId : requisitionLine.dmpl__PurchaseRequisitionId__c;
                    if(orderDocuments.containsKey(usePOKey)){
                        orderDocument = orderDocuments.get(usePOKey);
                    }else {
                        if(purchaseOrderId!=null){
                            orderDocument = new dmpl__PurchaseOrder__c(Id = purchaseOrderId);
                        }else{
                            orderDocument = createPurchaseOrderDocumentFromRequisition(requisitionLine);
                        }
                        orderDocuments.put(
                            usePOKey, 
                            orderDocument);
                        purchaseOrderLines.put(
                            usePOKey, 
                            new List<dmpl__PurchaseOrderLine__c>());
                    }
                    Decimal requestedQty = SourceObjectInfo.getRequestedQuantity(
                        orderLinesInfo, 
                        requisitionLine.Id);
                    purchaseOrderLines.get(
                        usePOKey).add(
                            createPurchaseOrderLineFromRequisitionLine(
                                requisitionLine,
                                requestedQty));
                }
            }
            //
            if(purchaseOrderLines.size() >0){
                Savepoint sp = Database.setSavepoint();
                try {
                    SecurityHelper.ensureCanCreateObject('dmpl__PurchaseOrder__c');
                    SecurityHelper.ensureCanCreateFields(new string[]{'dmpl__BranchId__c','dmpl__PartnerAccountId__c','dmpl__SupplierAccountId__c','dmpl__Remarks__c'}, 'dmpl__PurchaseOrder__c');
                    upsert orderDocuments.values();
                    List<dmpl__PurchaseOrderLine__c> linesToInsert = new List<dmpl__PurchaseOrderLine__c>();
                    for(Id orderId : orderDocuments.keySet()){
                        dmpl__PurchaseOrder__c purchaseDocument = orderDocuments.get(orderId);
                        List<dmpl__PurchaseOrderLine__c> docLines = purchaseOrderLines.get(orderId);
                        for(dmpl__PurchaseOrderLine__c purchaseOrderLine : docLines){
                            purchaseOrderLine.dmpl__PurchaseOrderId__c = purchaseDocument.Id;
                            linesToInsert.add(purchaseOrderLine);
                        }    
                    }

                    SecurityHelper.ensureCanCreateObject('dmpl__PurchaseOrderLine__c');
                    SecurityHelper.ensureCanCreateFields(new string[]{'dmpl__PurchaseRequisitionLineId__c','dmpl__PurchaseRequisitionId__c','dmpl__ItemId__c','dmpl__SKUId__c','dmpl__Quantity__c'}, 'dmpl__PurchaseOrderLine__c');
                    insert linesToInsert;
                } catch (Exception e) {
                    Database.rollback(sp);
                    throw new DMPLException(e.getMessage());
                }
            }
            return orderDocuments;
    }

    private static dmpl__PurchaseOrder__c createPurchaseOrderDocumentFromRequisition(dmpl__PurchaseRequisitionLine__c requisitionLine)
    {
        return new dmpl__PurchaseOrder__c(
            dmpl__BranchId__c = requisitionLine.dmpl__PurchaseRequisitionId__r.dmpl__BranchId__c,
            dmpl__PartnerAccountId__c = requisitionLine.dmpl__PurchaseRequisitionId__r.dmpl__PartnerAccountId__c,
            dmpl__SupplierAccountId__c = requisitionLine.dmpl__PurchaseRequisitionId__r.dmpl__SupplierAccountId__c,
            dmpl__PurchaseRequisitionId__c = requisitionLine.dmpl__PurchaseRequisitionId__c
        );
    }

    private static dmpl__PurchaseOrderLine__c createPurchaseOrderLineFromRequisitionLine(
        dmpl__PurchaseRequisitionLine__c requisitionLine,
        Decimal requestedQty){
            return new dmpl__PurchaseOrderLine__c(
                dmpl__PurchaseRequisitionLineId__c = requisitionLine.Id,
                dmpl__PurchaseRequisitionId__c = requisitionLine.dmpl__PurchaseRequisitionId__c,
                dmpl__ItemId__c = requisitionLine.dmpl__ItemId__c,
                dmpl__SKUId__c = requisitionLine.dmpl__SKUId__c,
                dmpl__UnitCost__c = requisitionLine.dmpl__UnitCost__c,
                dmpl__Quantity__c = requestedQty > 0 ? requestedQty : requisitionLine.dmpl__PendingQuantity__c
            );
    }

    private static void setDefaultAddress(List<dmpl__PurchaseOrder__c> newEntries){
        SecurityHelper.ensureCanWriteFields(new List<String>
        {
            FIELD_PURCHASEORDER_SHIPPINGADDRESS,
            FIELD_PURCHASEORDER_BILLINGADDRESS,
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
        }, OBJECT_PURCHASEORDER);

        List<Account> accounts = AccountHelper.getCachedAccounts(CollectionHelper.extractIds(newEntries, FIELD_PURCHASEORDER_PARTNERACCOUNTID));
        for(dmpl__PurchaseOrder__c order : newEntries){
            Account account = (Account)CollectionHelper.getObject(accounts, order.dmpl__PartnerAccountId__c);
            if(account!=null){
                AccountHelper.setDefaultAddress(order, account);
            }
        }
    }

    private static void setDefaultAddress(List<dmpl__PurchaseOrder__c> newEntries, List<dmpl__PurchaseOrder__c> oldEntries){
        SecurityHelper.ensureCanWriteFields(new List<String>
        {
            FIELD_PURCHASEORDER_SHIPPINGADDRESS,
            FIELD_PURCHASEORDER_BILLINGADDRESS
        }, OBJECT_PURCHASEORDER);
        Account account = null;
        List<Account> accounts = AccountHelper.getCachedAccounts(CollectionHelper.extractIds(newEntries, FIELD_PURCHASEORDER_PARTNERACCOUNTID));
        List<dmpl__PurchaseOrder__c> modifiedOrders = DocumentHelper.getModifiedNewObjects(FIELD_PURCHASEORDER_BILLINGADDRESSID, oldEntries, newEntries);
        for(dmpl__PurchaseOrder__c order : modifiedOrders){
            account = (Account)CollectionHelper.getObject(accounts, order.dmpl__PartnerAccountId__c);
            if(account!=null){
                AccountHelper.setDefaultAddress(order, account);
            }
        }
        
        modifiedOrders = DocumentHelper.getModifiedNewObjects(FIELD_PURCHASEORDER_SHIPPINGADDRESSID, oldEntries, newEntries);
        for(dmpl__PurchaseOrder__c order : modifiedOrders){
            account = (Account)CollectionHelper.getObject(accounts, order.dmpl__PartnerAccountId__c);
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

    @testVisible
    private static List<Id> queryTransactedObjectIds(List<dmpl__PurchaseOrder__c> newEntries){
        SecurityHelper.ensureCanReadFields(new string[]{'dmpl__SaleOrderId__c','dmpl__SaleInvoiceId__c'}, 'dmpl__GoodsReceiptLine__c');
        return DocumentHelper.extractIds([SELECT dmpl__PurchaseOrderId__c 
                FROM dmpl__PurchaseOrderLine__c
                WHERE dmpl__PurchaseOrderId__c IN:DocumentHelper.extractIds(newEntries)], FIELD_PURCHASEORDERLINE_PURCHASEORDERID);
    }

    private static List<dmpl__PurchaseRequisitionLine__c> queryPurchaseRequisitionLines(List<Id> requisitionIds, List<Id> purchaseRequisitionLineIds)
    {
        if(purchaseRequisitionLineIds == null){
            purchaseRequisitionLineIds = new List<Id>();
        }
        if(requisitionIds == null){
            requisitionIds = new List<Id>();
        }
        SecurityHelper.ensureCanReadFields(new string[]{'dmpl__PartnerAccountId__c','dmpl__BranchId__c','dmpl__SupplierAccountId__c','dmpl__DocumentDate__c','dmpl__Remarks__c'}, 'dmpl__PurchaseRequisition__c');
        SecurityHelper.ensureCanReadFields(new string[]{'dmpl__ItemId__c','dmpl__SKUId__c','dmpl__Quantity__c','dmpl__PendingQuantity__c','dmpl__PurchaseRequisitionId__c'}, 'dmpl__PurchaseRequisitionLine__c');
        return [SELECT Id,
            Name,
            dmpl__ItemId__c,
            dmpl__SKUId__c,
            dmpl__Quantity__c,
            dmpl__UnitCost__c,
            dmpl__PendingQuantity__c,
            dmpl__PurchaseRequisitionId__c,
            dmpl__PurchaseRequisitionId__r.dmpl__PartnerAccountId__c,
            dmpl__PurchaseRequisitionId__r.dmpl__BranchId__c,
            dmpl__PurchaseRequisitionId__r.dmpl__SupplierAccountId__c,
            dmpl__PurchaseRequisitionId__r.dmpl__DocumentDate__c,
            dmpl__PurchaseRequisitionId__r.dmpl__Remarks__c
        FROM dmpl__PurchaseRequisitionLine__c
        WHERE dmpl__PurchaseRequisitionId__c in :requisitionIds OR Id IN :purchaseRequisitionLineIds
        ];
    }
    
    @testVisible
    private static List<dmpl__AutoPurchaseOrderLine__c> queryAutoPurchaseOrderLines(List<ID> autoPurchaseOrderIds){

        SecurityHelper.ensureCanReadFields(new string[]{'dmpl__Amount__c','dmpl__AutoPurchaseOrderId__c','dmpl__ItemId__c','dmpl__SKUId__c','dmpl__PendingQuantity__c','dmpl__PurchaseOrderQuantity__c','dmpl__Quantity__c','dmpl__SuggestedQuantity__c','dmpl__UnitCost__c'}, 'dmpl__AutoPurchaseOrderLine__c');
        return [SELECT ID, 
            Name, 
            dmpl__Amount__c,
            dmpl__AutoPurchaseOrderId__c,
            dmpl__ItemId__c,
            dmpl__SKUId__c,
            dmpl__PendingQuantity__c,
            dmpl__PurchaseOrderQuantity__c,
            dmpl__Quantity__c,
            dmpl__SuggestedQuantity__c,
            dmpl__UnitCost__c
            FROM
            dmpl__AutoPurchaseOrderLine__c
            WHERE 
            dmpl__AutoPurchaseOrderId__c IN : autoPurchaseOrderIds];
    }

   
    private static List<dmpl__InventoryFulfillment__c> queryFulfillments(
        List<Id> fulfilmentIds,
        List<Id> repairOrderIds){
            if(fulfilmentIds == null){
                fulfilmentIds = new List<Id>();
            }
            if(repairOrderIds == null){
                repairOrderIds = new List<Id>();
            }
        SecurityHelper.ensureCanReadFields(new String[]{
            'dmpl__AccountId__c',
            'dmpl__AllocatedById__c',
            'dmpl__BranchId__c',
            'dmpl__DocumentDate__c',
            'dmpl__ExternalId__c',
            'dmpl__IsAllocated__c',
            'dmpl__PartnerAccountId__c',
            'dmpl__PerformAllocation__c',
            'dmpl__PerformCancelAllocation__c',
            'dmpl__SaleOrderId__c',
            'dmpl__Status__c',
            'dmpl__RepairOrderId__c'
        }, 'dmpl__InventoryFulfillment__c');
        SecurityHelper.ensureCanReadFields(new String[]{
            'dmpl__AllocatedQuantity__c',
            'dmpl__BackOrderQuantity__c',
            'dmpl__CancelledQuantity__c',
            'dmpl__FulfillmentId__c',
            'dmpl__InventoryLedgerId__c',
            'dmpl__IsILPosted__c',
            'dmpl__IsILPostingApproved__c',
            'dmpl__ItemId__c',
            'dmpl__ItemLotId__c',
            'dmpl__PendingAllocationQuantity__c',
            'dmpl__Quantity__c',
            'dmpl__RepairOrderLineId__c',
            'dmpl__SaleOrderLineId__c',
            'dmpl__SKUId__c',
            'dmpl__StorageLocationId__c',
            'dmpl__UnitCost__c'
        }, 'dmpl__InventoryFulfillmentOrderLine__c');

        SecurityHelper.ensureCanReadFields(new String[]{
                'dmpl__AllocatedById__c',
                'dmpl__DocumentDate__c',
                'dmpl__ExternalId__c',
                'dmpl__FulfillmentOrderId__c',
                'dmpl__FulfillmentOrderLineId__c',
                'dmpl__InventoryLedgerId__c',
                'dmpl__IsClosed__c',
                'dmpl__IsILPosted__c',
                'dmpl__IsILPostingApproved__c',
                'dmpl__ItemId__c',
                'dmpl__ItemLotId__c',
                'dmpl__Quantity__c',
                'dmpl__SaleOrderLineId__c',
                'dmpl__SKUId__c',
                'dmpl__StockId__c',
                'dmpl__StorageLocationId__c',
                'dmpl__UnitCost__c'
        }, 'dmpl__InventoryFulfillmentAllocationLine__c');

        return [SELECT
            dmpl__AccountId__c,
            dmpl__AllocatedById__c,
            dmpl__BranchId__c,
            dmpl__DocumentDate__c,
            dmpl__ExternalId__c,
            dmpl__IsAllocated__c,
            dmpl__PartnerAccountId__c,
            dmpl__PerformAllocation__c,
            dmpl__PerformCancelAllocation__c,
            dmpl__SaleOrderId__c,
            dmpl__Status__c,
            Id,
            Name,
            dmpl__RepairOrderId__c,
            (SELECT
                dmpl__AllocatedQuantity__c,
                dmpl__BackOrderQuantity__c,
                dmpl__CancelledQuantity__c,
                dmpl__FulfillmentId__c,
                dmpl__InventoryLedgerId__c,
                dmpl__IsILPosted__c,
                dmpl__IsILPostingApproved__c,
                dmpl__ItemId__c,
                dmpl__ItemLotId__c,
                dmpl__PendingAllocationQuantity__c,
                dmpl__Quantity__c,
                dmpl__RepairOrderLineId__c,
                dmpl__SaleOrderLineId__c,
                dmpl__SKUId__c,
                dmpl__StorageLocationId__c,
                dmpl__UnitCost__c,
                Id,
                Name
            FROM
                dmpl__FulfillmentOrderLines__r),
            (SELECT
                dmpl__AllocatedById__c,
                dmpl__DocumentDate__c,
                dmpl__ExternalId__c,
                dmpl__FulfillmentOrderId__c,
                dmpl__FulfillmentOrderLineId__c,
                dmpl__InventoryLedgerId__c,
                dmpl__IsClosed__c,
                dmpl__IsILPosted__c,
                dmpl__IsILPostingApproved__c,
                dmpl__ItemId__c,
                dmpl__ItemLotId__c,
                dmpl__Quantity__c,
                dmpl__SaleOrderLineId__c,
                dmpl__SKUId__c,
                dmpl__StockId__c,
                dmpl__StorageLocationId__c,
                dmpl__UnitCost__c,
                Id,
                Name
            FROM
                dmpl__FulfillmentAllocationLines__r)
        FROM
            dmpl__InventoryFulfillment__c
        WHERE 
            dmpl__RepairOrderId__c IN : repairOrderIds
            OR Id IN : fulfilmentIds];
    }

    private static List<dmpl__InventoryFulfillment__c> queryFulfillments(
        List<Id> fulfilmentLineIds){
        List<Id> fulfilmentIds = DocumentHelper.extractIds([SELECT 
                    dmpl__FulfillmentId__c
                FROM
                    dmpl__InventoryFulfillmentOrderLine__c
                WHERE 
                    Id IN : fulfilmentLineIds],
            'dmpl__FulfillmentId__c');
        SecurityHelper.ensureCanReadFields(new String[]{
            'dmpl__AccountId__c',
            'dmpl__AllocatedById__c',
            'dmpl__BranchId__c',
            'dmpl__DocumentDate__c',
            'dmpl__ExternalId__c',
            'dmpl__IsAllocated__c',
            'dmpl__PartnerAccountId__c',
            'dmpl__PerformAllocation__c',
            'dmpl__PerformCancelAllocation__c',
            'dmpl__SaleOrderId__c',
            'dmpl__Status__c',
            'dmpl__RepairOrderId__c'
        }, 'dmpl__InventoryFulfillment__c');
        SecurityHelper.ensureCanReadFields(new String[]{
            'dmpl__AllocatedQuantity__c',
            'dmpl__BackOrderQuantity__c',
            'dmpl__CancelledQuantity__c',
            'dmpl__FulfillmentId__c',
            'dmpl__InventoryLedgerId__c',
            'dmpl__IsILPosted__c',
            'dmpl__IsILPostingApproved__c',
            'dmpl__ItemId__c',
            'dmpl__ItemLotId__c',
            'dmpl__PendingAllocationQuantity__c',
            'dmpl__Quantity__c',
            'dmpl__RepairOrderLineId__c',
            'dmpl__SaleOrderLineId__c',
            'dmpl__SKUId__c',
            'dmpl__StorageLocationId__c',
            'dmpl__UnitCost__c'
        }, 'dmpl__InventoryFulfillmentOrderLine__c');

        SecurityHelper.ensureCanReadFields(new String[]{
                'dmpl__AllocatedById__c',
                'dmpl__DocumentDate__c',
                'dmpl__ExternalId__c',
                'dmpl__FulfillmentOrderId__c',
                'dmpl__FulfillmentOrderLineId__c',
                'dmpl__InventoryLedgerId__c',
                'dmpl__IsClosed__c',
                'dmpl__IsILPosted__c',
                'dmpl__IsILPostingApproved__c',
                'dmpl__ItemId__c',
                'dmpl__ItemLotId__c',
                'dmpl__Quantity__c',
                'dmpl__SaleOrderLineId__c',
                'dmpl__SKUId__c',
                'dmpl__StockId__c',
                'dmpl__StorageLocationId__c',
                'dmpl__UnitCost__c'
        }, 'dmpl__InventoryFulfillmentAllocationLine__c');

        return [SELECT
            dmpl__AccountId__c,
            dmpl__AllocatedById__c,
            dmpl__BranchId__c,
            dmpl__DocumentDate__c,
            dmpl__ExternalId__c,
            dmpl__IsAllocated__c,
            dmpl__PartnerAccountId__c,
            dmpl__PerformAllocation__c,
            dmpl__PerformCancelAllocation__c,
            dmpl__SaleOrderId__c,
            dmpl__Status__c,
            Id,
            Name,
            dmpl__RepairOrderId__c,
            (SELECT
                dmpl__AllocatedQuantity__c,
                dmpl__BackOrderQuantity__c,
                dmpl__CancelledQuantity__c,
                dmpl__FulfillmentId__c,
                dmpl__InventoryLedgerId__c,
                dmpl__IsILPosted__c,
                dmpl__IsILPostingApproved__c,
                dmpl__ItemId__c,
                dmpl__ItemLotId__c,
                dmpl__PendingAllocationQuantity__c,
                dmpl__Quantity__c,
                dmpl__RepairOrderLineId__c,
                dmpl__SaleOrderLineId__c,
                dmpl__SKUId__c,
                dmpl__StorageLocationId__c,
                dmpl__UnitCost__c,
                Id,
                Name
            FROM
                dmpl__FulfillmentOrderLines__r
            WHERE Id IN : fulfilmentLineIds),
            (SELECT
                dmpl__AllocatedById__c,
                dmpl__DocumentDate__c,
                dmpl__ExternalId__c,
                dmpl__FulfillmentOrderId__c,
                dmpl__FulfillmentOrderLineId__c,
                dmpl__InventoryLedgerId__c,
                dmpl__IsClosed__c,
                dmpl__IsILPosted__c,
                dmpl__IsILPostingApproved__c,
                dmpl__ItemId__c,
                dmpl__ItemLotId__c,
                dmpl__Quantity__c,
                dmpl__SaleOrderLineId__c,
                dmpl__SKUId__c,
                dmpl__StockId__c,
                dmpl__StorageLocationId__c,
                dmpl__UnitCost__c,
                Id,
                Name
            FROM
                dmpl__FulfillmentAllocationLines__r)
        FROM
            dmpl__InventoryFulfillment__c
        WHERE 
            Id IN : fulfilmentIds];
    }
}