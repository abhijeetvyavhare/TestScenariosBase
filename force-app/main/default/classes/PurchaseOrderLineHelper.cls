public with sharing class PurchaseOrderLineHelper {

    private static Boolean skipValidations = false;
    private static Boolean skipComponentDeleteValidation = false;
    private static Boolean skipComponentAddValidation = false;

    private static final string OBJECT_PURCHASEORDER = 'dmpl__PurchaseOrder__c';
    private static final string OBJECT_PURCHASEORDERLINE = 'dmpl__PurchaseOrderLine__c';
    private static final string FIELD_PURCHASEORDER_ID = 'dmpl__PurchaseOrderId__c';

    private static final string FIELD_PURCHASEORDERLINE_ITEMID = 'dmpl__ItemId__c';
    private static final string FIELD_PURCHASEORDERLINE_SKUID = 'dmpl__SKUId__c';

    private static final string FIELD_PURCHASEORDERLINE_INVOICEQUANTITY = 'dmpl__InvoiceQuantity__c';
    private static final string FIELD_PURCHASEORDERLINE_RECEIPTQUANTITY = 'dmpl__ReceiptQuantity__c';
    private static final string FIELD_PURCHASEORDERLINE_RETURNEDQUANTITY = 'dmpl__ReturnedQuantity__c';
    private static final string FIELD_PURCHASEORDERLINE_QUANTITY = 'dmpl__Quantity__c';
    private static final string FIELD_PURCHASEORDERLINE_REQUISITIONLINEID = 'dmpl__PurchaseRequisitionLineId__c';
    private static final string FIELD_PURCHASEORDERLINE_AUTOORDERLINEID = 'dmpl__AutoPurchaseOrderLineId__c';
    private static final string FIELD_PURCHASEORDERLINE_REQUISITIONID = 'dmpl__PurchaseRequisitionId__c';
    private static final string FIELD_PURCHASEORDRELINE_TAXGROUPID = 'dmpl__TaxGroupId__c';
    private static final string FIELD_PURCHASEORDRELINE_AMOUNT = 'dmpl__Amount__c';
    private static final string RELATION_PURCHASEORDER_STATUS = 'dmpl__PurchaseOrderId__r.dmpl__Status__c';

    private static final string FIELDNAME_PURCHASEORDERLINE_PRICELISTRULEID = 'dmpl__PriceListRuleId__c';
    private static final string FIELD_PURCHASEORDER_AUTOPURCHASEORDERID = 'dmpl__AutoPurchaseOrderId__c';

    private static final string FIELD_AGG_PURCHASEORDERLINEID = 'PurchaseOrderLineId';
    private static final string FIELD_AGG_TOTALQTY = 'TotalQuantity';


    private static final string FIELD_PURCHASEORDRELINE_CONTRACTDISCOUNT = 'dmpl__ContractDiscount__c';
    private static final string FIELD_PURCHASEORDRELINE_DISCOUNT = 'dmpl__Discount__c';
    private static final string FIELD_PURCHASEORDRELINE_DISCOUNT2 = 'dmpl__Discount2__c';
    private static final string FIELD_PURCHASEORDRELINE_SCHEMEDISCOUNT = 'dmpl__SchemeDiscount__c';
    private static Boolean isAlreadyProcessing =false;

    private static final List<String> LIST_FIELDS_NONEDITABLE = new List<String>{
        FIELD_PURCHASEORDER_ID
    };

    private static final List<String> LIST_FIELDS_SYSTEM = new List<String>{
        FIELD_PURCHASEORDERLINE_INVOICEQUANTITY,
        FIELD_PURCHASEORDERLINE_RECEIPTQUANTITY,
        FIELD_PURCHASEORDERLINE_RETURNEDQUANTITY
    };
    
    private static final List<String> LIST_FIELDS_SOURCEPOULATED = new List<String>{
        FIELD_PURCHASEORDERLINE_ITEMID,
        FIELD_PURCHASEORDERLINE_SKUID
    };
    
    private static final List<String> LIST_FIELDS_LOCKEDIFTRANSACTED = new List<String>{
        FIELD_PURCHASEORDERLINE_ITEMID,
        FIELD_PURCHASEORDERLINE_SKUID,
        FIELD_PURCHASEORDERLINE_REQUISITIONLINEID
    };

    private static final List<String> LIST_FIELDS_NEGATIVEANDZERONOTALLOWED = new List<String>{
    };
    
    private static final List<String> LIST_FIELDS_NEGATIVENOTALLOWED = new List<String>{
        'dmpl__InvoiceQuantity__c', 
        'dmpl__PendingQuantity__c', 
        'dmpl__PendingSaleOrderQuantity__c', 
        'dmpl__Quantity__c', 
        'dmpl__ReceiptQuantity__c', 
        'dmpl__ReturnedQuantity__c', 
        'dmpl__SaleOrderQuantity__c'
    };

    private static final List<String> LIST_FIELDS_PERCENT = new List<String>{
        FIELD_PURCHASEORDRELINE_CONTRACTDISCOUNT,
        FIELD_PURCHASEORDRELINE_DISCOUNT,
        FIELD_PURCHASEORDRELINE_DISCOUNT2,
        FIELD_PURCHASEORDRELINE_SCHEMEDISCOUNT
    };

    public static void validateData(Boolean isInsert, Boolean isDelete, Boolean isUpdate, List<dmpl__PurchaseOrderLine__c> oldEntries, List<dmpl__PurchaseOrderLine__c> newEntries)
    {
        try{
            if(isInsert){
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
            }

            if(skipValidations){
                return;
            }

            if(isInsert){
                validateItem(newEntries);
                validateOrderQuantity(newEntries);
                DocumentHelper.validateChangeInSystemFields(LIST_FIELDS_SYSTEM, newEntries);
                ValidationHelper.validatePostiveDecimal(FIELD_PURCHASEORDERLINE_QUANTITY, newEntries);

                (new DocumentStatusDFSHelper()).DocumentStatusRelatedObjectRestrictEdits_New(OBJECT_PURCHASEORDER, OBJECT_PURCHASEORDERLINE, RELATION_PURCHASEORDER_STATUS, newEntries);
            }else if(isUpdate){
                DocumentHelper.validateChangeInSystemFields(LIST_FIELDS_SYSTEM, oldEntries, newEntries);
                DocumentHelper.validateChangeInKeyFields(LIST_FIELDS_NONEDITABLE, oldEntries, newEntries);
                DocumentHelper.validateChangeInSourcePopulatedFields(LIST_FIELDS_SOURCEPOULATED, oldEntries, newEntries, FIELD_PURCHASEORDERLINE_REQUISITIONLINEID);
                ValidationHelper.validatePostiveDecimal(FIELD_PURCHASEORDERLINE_QUANTITY, newEntries);
                DocumentHelper.validateChangeInLockedIfTransactedFields(LIST_FIELDS_LOCKEDIFTRANSACTED, oldEntries, newEntries, FIELD_PURCHASEORDERLINE_RECEIPTQUANTITY);
                (new DocumentStatusDFSHelper()).DocumentStatusRelatedObjectRestrictEdits_Edit(OBJECT_PURCHASEORDER, OBJECT_PURCHASEORDERLINE, RELATION_PURCHASEORDER_STATUS, oldEntries, newEntries);
                validateChangeInQuantity(oldEntries, newEntries);
                List<dmpl__PurchaseOrderLine__c> modifiedObjects = DocumentHelper.getModifiedNewObjects(
                        new string[]{
                            FIELD_PURCHASEORDERLINE_QUANTITY
                        }, 
                        oldEntries, 
                        newEntries);
                    if(modifiedObjects.size()>0){
                        PackageHelper.validateComponentQuantityEdit(modifiedObjects, queryPurchaseOrderLines(CollectionHelper.extractIds(oldEntries, 'dmpl__PackagePurchaseOrderLineId__c')));
                        validateOrderQuantity(modifiedObjects);
                    }

            }else if(isDelete){
                DocumentHelper.validateCanBeDeleted(oldEntries, FIELD_PURCHASEORDERLINE_RECEIPTQUANTITY);
                (new DocumentStatusDFSHelper()).DocumentStatusRelatedObjectRestrictEdits_Delete(OBJECT_PURCHASEORDER, OBJECT_PURCHASEORDERLINE, RELATION_PURCHASEORDER_STATUS, oldEntries);
                if(!skipComponentDeleteValidation){
                    PackageHelper.validateComponentsDelete(
                        oldEntries, 
                        queryPurchaseOrderLines(
                            CollectionHelper.extractIds(
                                oldEntries, 
                                'dmpl__PackagePurchaseOrderLineId__c')));
                }
            }
        } catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }

    public static void postData(Boolean isInsert, Boolean isDelete, Boolean isUpdate, List<dmpl__PurchaseOrderLine__c> oldEntries, List<dmpl__PurchaseOrderLine__c> newEntries)
    {
        try{
        if(isInsert){
            setItemData(newEntries);
            TaxHelper.setLinesTaxes(
                newEntries);
        }
        else if(isUpdate){
            List<dmpl__PurchaseOrderLine__c> modifiedObjects = DocumentHelper.getModifiedNewObjects(FIELDNAME_PURCHASEORDERLINE_PRICELISTRULEID, oldEntries, newEntries);
            if(modifiedObjects.size()>0){
                Map<Id, dmpl__Item__c> items = new Map<Id,dmpl__Item__c>(ItemHelper.getCachedItems(DocumentHelper.extractIds(modifiedObjects, FIELD_PURCHASEORDERLINE_ITEMID)));
                List<dmpl__PurchaseOrder__c> purchaseOrderDocuments = queryPurchaseOrderDocument(DocumentHelper.extractIds(modifiedObjects, FIELD_PURCHASEORDER_ID));
                PriceListHelper.setApplicablePrices(modifiedObjects, purchaseOrderDocuments, items.values(), DocumentHelper.extractIds(modifiedObjects, FIELDNAME_PURCHASEORDERLINE_PRICELISTRULEID),'dmpl__PurchaseOrderId__c');
            }

            modifiedObjects = DocumentHelper.getModifiedNewObjects(
                new List<String>{
                    'dmpl__PriceListId__c',
                    'dmpl__PriceAsOnDate__c'
                },
                oldEntries, 
                newEntries);
            if(modifiedObjects.size()>0){
                Map<Id, dmpl__Item__c> items = new Map<Id,dmpl__Item__c>(ItemHelper.getCachedItems(DocumentHelper.extractIds(modifiedObjects, FIELD_PURCHASEORDERLINE_ITEMID)));
                List<dmpl__PurchaseOrder__c> purchaseOrderDocuments = queryPurchaseOrderDocument(DocumentHelper.extractIds(modifiedObjects, FIELD_PURCHASEORDER_ID));
                PriceListHelper.setApplicablePrices(modifiedObjects, purchaseOrderDocuments, items.values(), true);
            }

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
                TaxHelper.setLinesTaxes(
                    newEntries);
            }
         Map<Id, dmpl__Item__c> items = new Map<Id,dmpl__Item__c>(
                ItemHelper.getCachedItems(
                DocumentHelper.extractIds(
                    newEntries, 
                    FIELD_PURCHASEORDERLINE_ITEMID)));
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
        } else if(isDelete){
            //PurchaseOrderTaxHelper.deleteApplicableTaxes(oldEntries);
            deletePackageItems(oldEntries);
        }
    } catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }

    }

    public static void afterPostData(Boolean isInsert, Boolean isDelete, Boolean isUpdate, List<dmpl__PurchaseOrderLine__c> oldEntries, List<dmpl__PurchaseOrderLine__c> newEntries)
    {
        try{
            if(isDelete){
                PurchaseRequisitionLineHelper.updatePurchaseOrderQuantity(DocumentHelper.extractIds(oldEntries, FIELD_PURCHASEORDERLINE_REQUISITIONLINEID));
                AutoPurchaseOrderLineHelper.updatePurchaseOrderQuantity(DocumentHelper.extractIds(oldEntries, FIELD_PURCHASEORDERLINE_AUTOORDERLINEID));
                FulfillmentOrderLineHelper.updatePurchaseOrderQuantity(DocumentHelper.extractIds(oldEntries, 'dmpl__FulfillmentOrderLineId__c'));
                TaxHelper.deleteLinesTaxes(oldEntries);
            }else if(isInsert){
                TaxHelper.createLinesTaxes(
                    isInsert,
                    newEntries);
                PackageHelper.populatePackageItems(newEntries);
                PurchaseRequisitionLineHelper.updatePurchaseOrderQuantity(DocumentHelper.extractIds(newEntries, FIELD_PURCHASEORDERLINE_REQUISITIONLINEID));
                AutoPurchaseOrderLineHelper.updatePurchaseOrderQuantity(DocumentHelper.extractIds(newEntries, FIELD_PURCHASEORDERLINE_AUTOORDERLINEID));
                FulfillmentOrderLineHelper.updatePurchaseOrderQuantity(DocumentHelper.extractIds(newEntries, 'dmpl__FulfillmentOrderLineId__c'));
            }else if(isUpdate){
                List<Id> modifiedObjectIds = DocumentHelper.getModifiedNewObjectIds(FIELD_PURCHASEORDERLINE_QUANTITY, FIELD_PURCHASEORDERLINE_REQUISITIONLINEID, oldEntries, newEntries);
                if(modifiedObjectIds.size()>0){
                    PurchaseRequisitionLineHelper.updatePurchaseOrderQuantity(modifiedObjectIds);
                }

                modifiedObjectIds = DocumentHelper.getModifiedNewObjectIds(FIELD_PURCHASEORDERLINE_QUANTITY, FIELD_PURCHASEORDERLINE_AUTOORDERLINEID, oldEntries, newEntries);
                if(modifiedObjectIds.size()>0){
                    AutoPurchaseOrderLineHelper.updatePurchaseOrderQuantity(modifiedObjectIds);
                }

                modifiedObjectIds = DocumentHelper.getModifiedNewObjectIds(FIELD_PURCHASEORDERLINE_QUANTITY, 'dmpl__FulfillmentOrderLineId__c', oldEntries, newEntries);
                if(modifiedObjectIds.size()>0){
                    FulfillmentOrderLineHelper.updatePurchaseOrderQuantity(DocumentHelper.extractIds(newEntries, 'dmpl__FulfillmentOrderLineId__c'));
                }

                List<dmpl__PurchaseOrderLine__c> modifiedObjects = DocumentHelper.getModifiedNewObjects(new string[]{FIELD_PURCHASEORDRELINE_TAXGROUPID,FIELD_PURCHASEORDERLINE_ITEMID, FIELD_PURCHASEORDERLINE_SKUID,FIELD_PURCHASEORDRELINE_AMOUNT}, oldEntries, newEntries);
                if(modifiedObjects.size()>0){
                    TaxHelper.createLinesTaxes(
                        isInsert,
                        modifiedObjects);
                }

                modifiedObjects = DocumentHelper.getModifiedNewObjects(
                    new string[]{
                        FIELD_PURCHASEORDRELINE_TAXGROUPID,
                        FIELD_PURCHASEORDERLINE_ITEMID, 
                        FIELD_PURCHASEORDERLINE_SKUID,
                        FIELD_PURCHASEORDRELINE_AMOUNT,
                        FIELD_PURCHASEORDERLINE_QUANTITY
                    }, 
                    oldEntries, 
                    newEntries);
                if(modifiedObjects.size() > 0)
                {
                    List<dmpl__PurchaseOrder__c> purchaseOrderDocuments = queryPurchaseOrderDocument(
                    DocumentHelper.extractIds(
                        modifiedObjects, 
                        FIELD_PURCHASEORDER_ID));
                        List<Id> purchaseOrderIds =  DocumentHelper.extractIds(
                    isDelete ? oldEntries : newEntries, 
                    FIELD_PURCHASEORDER_ID);
                    dmpl__DMSOrgSetting__mdt  orgSetting = OrgSettingHelper.OrgSetting();
                    if(orgSetting != null && orgSetting.dmpl__ApplySchemeAsync__c && !isAlreadyProcessing && !system.isBatch() && !system.IsFuture()){
                        applySchemeAsync(purchaseOrderIds);
                    }else 
                    SchemeEngine.processSchemes(purchaseOrderDocuments);
                    
                }
            }
            if(isInsert || isDelete)
            {  
                List<dmpl__PurchaseOrder__c> purchaseOrderDocuments = queryPurchaseOrderDocument(
                DocumentHelper.extractIds(
                    isDelete ? oldEntries : newEntries, 
                    FIELD_PURCHASEORDER_ID));
                SchemeEngine.processSchemes(purchaseOrderDocuments);
                List<Id> purchaseOrderIds =  DocumentHelper.extractIds(
                    isDelete ? oldEntries : newEntries, 
                    FIELD_PURCHASEORDER_ID);
                dmpl__DMSOrgSetting__mdt  orgSetting = OrgSettingHelper.OrgSetting();
                    if(orgSetting != null && orgSetting.dmpl__ApplySchemeAsync__c && !isAlreadyProcessing && !system.isBatch() && !system.IsFuture()){
                        applySchemeAsync(purchaseOrderIds);
                    }else 
                    SchemeEngine.processSchemes(purchaseOrderDocuments);
            }

        } catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }

    public static void createPurchaseOrderLineFromPurchaseOrder(List<dmpl__PurchaseOrder__c> purchaseOrders){
        createPurchaseOrderLines(
            purchaseOrders, 
            queryAutoPurchaseOrderLines(DocumentHelper.extractIds(purchaseOrders, FIELD_PURCHASEORDER_AUTOPURCHASEORDERID)));
    }

    public static void createPurchaseOrderLineFromFulfillment(
        List<dmpl__PurchaseOrder__c> purchaseOrders, 
        List<dmpl__InventoryFulfillment__c> fulfillments,
        List<SourceObjectInfo> orderLinesInfo){
        createPurchaseOrderLines(
            purchaseOrders, 
            fulfillments,
            orderLinesInfo);
    }

    public static void updatePurchaseReturnQuantity(List<Id> purchaseOrderLineIds)
    {
        try{
            skipValidations = true;
             
            SecurityHelper.ensureCanReadFields(new string[]{
                'dmpl__PurchaseOrderLineId__c',
                'dmpl__Quantity__c'
            }, 'dmpl__PurchaseReturnLine__c');
            List<AggregateResult> ffAggregates = 
                [SELECT 
                    dmpl__PurchaseOrderLineId__c PurchaseOrderLineId, 
                    SUM(dmpl__Quantity__c) TotalQuantity
                FROM 
                dmpl__PurchaseReturnLine__c
                WHERE 
                dmpl__PurchaseOrderLineId__c IN :purchaseOrderLineIds
                WITH SECURITY_ENFORCED
                GROUP BY dmpl__PurchaseOrderLineId__c];
             
            SecurityHelper.ensureCanReadFields(new string[]{
                'dmpl__ReturnedQuantity__c'
            }, 'dmpl__PurchaseOrderLine__c');
            List<dmpl__PurchaseOrderLine__c> orderLinesToUpdate = 
                [SELECT 
                    Id, 
                    dmpl__ReturnedQuantity__c
                FROM 
                dmpl__PurchaseOrderLine__c
                WHERE 
                    Id IN :purchaseOrderLineIds];
    
            for(dmpl__PurchaseOrderLine__c orderLine : orderLinesToUpdate){
                for(AggregateResult result : ffAggregates){
                    if(result.get(FIELD_AGG_PURCHASEORDERLINEID) == orderLine.Id){
                        orderLine.dmpl__ReturnedQuantity__c 
                            = result.get(FIELD_AGG_TOTALQTY) ==null ? 
                                0 : (Decimal)(result.get(FIELD_AGG_TOTALQTY));
                        break;
                    }
                }
            }
            SecurityHelper.ensureCanWriteFields(new string[]{
                'dmpl__ReturnedQuantity__c'
            }, 'dmpl__PurchaseOrderLine__c');
            Update orderLinesToUpdate;
        }finally{
            skipValidations = false;
        }
    }

    @Future
    public static void applySchemeAsync(List<Id>purchaseOrderLineId){
        isAlreadyProcessing = True;
        List<dmpl__PurchaseOrder__c>purchaseOrders = queryPurchaseOrderDocument(purchaseOrderLineId);
        SchemeEngine.processSchemes(purchaseOrders);
        isAlreadyProcessing = false;
    }

    public static void updateBillReturnQuantity(List<Id> purchaseOrderLineIds)
    {
        try{
            skipValidations = true;
             
            SecurityHelper.ensureCanReadFields(new string[]{
                'dmpl__PurchaseOrderLineId__c',
                'dmpl__Quantity__c'
            }, 'dmpl__BillReturnLine__c');
            List<AggregateResult> ffAggregates = 
                [SELECT 
                    dmpl__PurchaseOrderLineId__c PurchaseOrderLineId, 
                    SUM(dmpl__Quantity__c) TotalQuantity
                FROM 
                dmpl__BillReturnLine__c
                WHERE 
                dmpl__PurchaseOrderLineId__c IN :purchaseOrderLineIds
                WITH SECURITY_ENFORCED
                GROUP BY dmpl__PurchaseOrderLineId__c];
             
            SecurityHelper.ensureCanReadFields(new string[]{
                'dmpl__ReturnedQuantity__c'
            }, 'dmpl__PurchaseOrderLine__c');
            List<dmpl__PurchaseOrderLine__c> orderLinesToUpdate = 
                [SELECT 
                    Id, 
                    dmpl__ReturnedQuantity__c
                FROM 
                dmpl__PurchaseOrderLine__c
                WHERE 
                    Id IN :purchaseOrderLineIds];
    
            for(dmpl__PurchaseOrderLine__c orderLine : orderLinesToUpdate){
                for(AggregateResult result : ffAggregates){
                    if(result.get(FIELD_AGG_PURCHASEORDERLINEID) == orderLine.Id){
                        orderLine.dmpl__ReturnedQuantity__c 
                            = result.get(FIELD_AGG_TOTALQTY) ==null ? 
                                0 : (Decimal)(result.get(FIELD_AGG_TOTALQTY));
                        break;
                    }
                }
            }
            SecurityHelper.ensureCanWriteFields(new string[]{
                'dmpl__ReturnedQuantity__c'
            }, 'dmpl__PurchaseOrderLine__c');
            Update orderLinesToUpdate;
        }finally{
            skipValidations = false;
        }
    }

    public static void addPackagePurchaseOrderLines(
        Map<dmpl__PurchaseOrderLine__c, 
        List<dmpl__ItemComponent__c>> packageLines){
        List<dmpl__PurchaseOrderLine__c> orderLinesToCreate = new List<dmpl__PurchaseOrderLine__c>();
        for(dmpl__PurchaseOrderLine__c line : packageLines.keySet()){
            List<dmpl__ItemComponent__c> components = packageLines.get(line);
            for(dmpl__ItemComponent__c component : components){
                orderLinesToCreate.add(
                    createPurchaseOrderLine(
                        line, 
                        component));
            }
        }

        if(orderLinesToCreate.size()>0){
            SecurityHelper.ensureCanCreateObject('dmpl__PurchaseOrderLine__c');
            SecurityHelper.ensureCanCreateFields(new List<String>{
                'dmpl__ItemId__c',
                'dmpl__SKUId__c',
                'dmpl__PackagePurchaseOrderLineId__c',
                'dmpl__Quantity__c',
                'dmpl__PurchaseOrderId__c'    
            }, 'dmpl__PurchaseOrderLine__c');
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
        dmpl__PurchaseOrderLine__c packagePurchaseOrderLine, 
        List<dmpl__PurchaseOrderLine__c> existingLines, 
        List<dmpl__ItemComponent__c> components){
        List<dmpl__PurchaseOrderLine__c> orderLinesToCreate = new List<dmpl__PurchaseOrderLine__c>();
        List<dmpl__PurchaseOrderLine__c> orderLinesToUpdate = new List<dmpl__PurchaseOrderLine__c>();
        List<dmpl__PurchaseOrderLine__c> orderLinesToDelete = new List<dmpl__PurchaseOrderLine__c>();
        if(packagePurchaseOrderLine == null){
            throw new DMPLException(
                String.format(
                    String.valueOf(
                        System.Label.Generic_MissingObject), 
                        new String[]{dmpl__PurchaseOrderLine__c.class.getName()}));
        }
        for(dmpl__ItemComponent__c component : components){
            dmpl__PurchaseOrderLine__c exisitngLine = (dmpl__PurchaseOrderLine__c)CollectionHelper.getObject(
                existingLines, 
                'dmpl__ItemComponentId__c', 
                component.Id);
            if(exisitngLine == null){
                orderLinesToCreate.add(
                    createPurchaseOrderLine(
                        packagePurchaseOrderLine, 
                        component));
            }else if(component.dmpl__IsQuantityEditable__c){
                Decimal quantity = PackageHelper.getDefaultComponentQuantity(
                    packagePurchaseOrderLine.dmpl__Quantity__c, 
                    component);
                if(exisitngLine.dmpl__Quantity__c != quantity){
                    exisitngLine.dmpl__Quantity__c = component.dmpl__Quantity__c;
                    orderLinesToUpdate.add(exisitngLine);
                }
            }
        }

        for(dmpl__PurchaseOrderLine__c line : existingLines){
            if(line.Id != packagePurchaseOrderLine.Id 
                && CollectionHelper.getObject(
                    components, 
                    line.dmpl__ItemComponentId__c) == null){
                orderLinesToDelete.add(line);
            }
        }

        if(orderLinesToCreate.size()>0){
            SecurityHelper.ensureCanCreateObject('dmpl__PurchaseOrderLine__c');
            SecurityHelper.ensureCanCreateFields(new List<String>{
                'dmpl__ItemId__c',
                'dmpl__SKUId__c',
                'dmpl__PackagePurchaseOrderLineId__c',
                'dmpl__Quantity__c',
                'dmpl__PurchaseOrderId__c'    
            }, 'dmpl__PurchaseOrderLine__c');
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
                'dmpl__PackagePurchaseOrderLineId__c',
                'dmpl__Quantity__c'
            }, 'dmpl__PurchaseOrderLine__c');
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
            SecurityHelper.ensureCanDeleteObject('dmpl__PurchaseOrderLine__c');
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

    private static void deletePackageItems(List<dmpl__PurchaseOrderLine__c> oldEntries){
        SecurityHelper.ensureCanReadField('Id', 'dmpl__PurchaseOrderLine__c');
        List<dmpl__PurchaseOrderLine__c> linesToDelte = [SELECT Id 
            FROM dmpl__PurchaseOrderLine__c 
            WHERE dmpl__PackagePurchaseOrderLineId__c IN:CollectionHelper.extractIds(oldEntries)];

        try {
            skipComponentDeleteValidation = true;
            if(linesToDelte.size()>0){
                SecurityHelper.ensureCanDeleteObject('dmpl__PurchaseOrderLine__c');
                delete linesToDelte;
            }        
        } finally {
            skipComponentDeleteValidation = false;
        }
    }

    @testVisible
    private static dmpl__PurchaseOrderLine__c createPurchaseOrderLine(
        dmpl__PurchaseOrderLine__c packageLine, 
        dmpl__ItemComponent__c component){
        return new dmpl__PurchaseOrderLine__c(
            dmpl__ItemComponentId__c = component.Id,    
            dmpl__ItemId__c = component.dmpl__ComponentItemId__c,
            dmpl__SKUId__c = component.dmpl__ComponentSKUId__c,
            dmpl__PackagePurchaseOrderLineId__c = packageLine.Id,
            dmpl__Quantity__c = PackageHelper.getDefaultComponentQuantity(
                packageLine.dmpl__Quantity__c, 
                component),
            dmpl__PurchaseOrderId__c =  packageLine.dmpl__PurchaseOrderId__c
            // dmpl__IsPriceBundled__c = component.dmpl__IsBundled__c
        );
    }


    private static void createPurchaseOrderLines(
        List<dmpl__PurchaseOrder__c> purchaseOrders, 
        List<dmpl__InventoryFulfillment__c> fulfillments,
        List<SourceObjectInfo> orderLinesInfo){
        List<dmpl__PurchaseOrderLine__c> newPurchaseOrderLines = new List<dmpl__PurchaseOrderLine__c>();
        for(dmpl__PurchaseOrder__c purchaseOrder : purchaseOrders){
            for(dmpl__InventoryFulfillment__c fulfillment : fulfillments){
                if(purchaseOrder.dmpl__FulfillmentId__c == fulfillment.Id){
                    for(dmpl__InventoryFulfillmentOrderLine__c fulfillmentOrderLine : fulfillment.dmpl__FulfillmentOrderLines__r){
                        Decimal requestedQuantity = orderLinesInfo == null ? 
                            fulfillmentOrderLine.dmpl__PendingAllocationQuantity__c : SourceObjectInfo.getRequestedQuantity(orderLinesInfo, fulfillmentOrderLine.Id);
                        if(requestedQuantity > 0){
                            newPurchaseOrderLines.add(new dmpl__PurchaseOrderLine__c(
                                dmpl__PurchaseOrderId__c = purchaseOrder.Id,
                                dmpl__ItemId__c = fulfillmentOrderLine.dmpl__ItemId__c,
                                dmpl__Quantity__c = requestedQuantity,
                                dmpl__RepairOrderLineId__c = fulfillmentOrderLine.dmpl__RepairOrderLineId__c,
                                dmpl__FulfillmentOrderLineId__c = fulfillmentOrderLine.Id,
                                dmpl__UnitCost__c = fulfillmentOrderLine.dmpl__UnitCost__c,
                                dmpl__SKUId__c = fulfillmentOrderLine.dmpl__SKUId__c
                            ));
                        }
                    }
                }
            }
        }

        if(newPurchaseOrderLines.size() > 0)
        {
            SecurityHelper.ensureCanCreateFields(new string[]{'dmpl__PurchaseOrderId__c','dmpl__SKUId__c','dmpl__UnitCost__c','dmpl__ItemId__c','dmpl__Quantity__c','dmpl__RepairOrderLineId__c','dmpl__FulfillmentOrderLineId__c'}, 'dmpl__PurchaseOrderLine__c');
            insert newPurchaseOrderLines;
        }
    }

    // private static void updateReturnQuantity(List<dmpl__PurchaseReturnLine__c> purchaseReturnLines){
    //     Map<ID, dmpl__PurchaseOrderLine__c> purchaseOrderLines = queryPurchaseOrderLines(DocumentHelper.extractIds(purchaseReturnLines, 'dmpl__PurchaseOrderLineId__c'));

    //     for(dmpl__PurchaseReturnLine__c lineEntry : purchaseReturnLines){
    //         if(lineEntry.dmpl__PurchaseOrderLineId__c != null){
    //             purchaseOrderLines.get(lineEntry.dmpl__PurchaseOrderLineId__c).dmpl__ReturnedQuantity__c = lineEntry.dmpl__Quantity__c;
    //         }
    //     }
        
    //     if(purchaseOrderLines.size() > 0){
    //         try {
    //             SecurityHelper.ensureCanCreateObject('dmpl__PurchaseOrderLine__c');
    //             skipValidations = true;
    //             update purchaseOrderLines.values();       
    //         } finally {
    //             skipValidations = false;
    //         }
    //     }
    // }

    public static void updateSaleOrderQuantity(List<Id> purchaseOrderLineIds)
    {
        try{
            skipValidations = true;
            SecurityHelper.ensureCanReadFields(new string[]{'dmpl__PurchaseOrderLineId__c','dmpl__Quantity__c'}, 'dmpl__SaleOrderLine__c');
            List<AggregateResult> ffAggregates = 
                [SELECT dmpl__PurchaseOrderLineId__c PurchaseOrderLineId, SUM(dmpl__Quantity__c) TotalQuantity
                FROM dmpl__SaleOrderLine__c
                WHERE dmpl__PurchaseOrderLineId__c IN :purchaseOrderLineIds
                WITH SECURITY_ENFORCED
                GROUP BY dmpl__PurchaseOrderLineId__c];

            SecurityHelper.ensureCanReadFields(new string[]{'dmpl__SaleOrderQuantity__c'}, 'dmpl__PurchaseOrderLine__c');
            List<dmpl__PurchaseOrderLine__c> orderLinesToUpdate = 
                [SELECT Id, dmpl__SaleOrderQuantity__c
                FROM dmpl__PurchaseOrderLine__c
                WHERE Id IN :purchaseOrderLineIds];
    
            for(dmpl__PurchaseOrderLine__c orderLine : orderLinesToUpdate){
                for(AggregateResult result : ffAggregates){
                    if(result.get(FIELD_AGG_PURCHASEORDERLINEID) == orderLine.Id){
                        orderLine.dmpl__SaleOrderQuantity__c = result.get(FIELD_AGG_TOTALQTY) == null ? 0 : (Decimal)(result.get(FIELD_AGG_TOTALQTY));
                        break;
                    }
                }
            }
            SecurityHelper.ensureCanWriteFields(new string[]{'dmpl__SaleOrderQuantity__c'}, 'dmpl__PurchaseOrderLine__c');
            Update orderLinesToUpdate;
        }finally{
            skipValidations = false;
        }
    }

    public static void performReprice(Id purchaseOrderId){
        performReprice(new List<Id>{purchaseOrderId});
    }

    public static void performReprice(List<Id> purchaseOrderIds){
        List<dmpl__PurchaseOrder__c> purchaseOrderDocuments = queryPurchaseOrderDocument(
            purchaseOrderIds);
        List<dmpl__PurchaseOrderLine__c> purchaseOrderLines = queryPurchaseOrderLinesOfPurchaseOrders(
            CollectionHelper.extractIds(
                purchaseOrderDocuments));
        Map<Id, dmpl__Item__c> items = new Map<Id,dmpl__Item__c>(
            ItemHelper.getCachedItems(
                DocumentHelper.extractIds(
                    purchaseOrderLines, 
                    FIELD_PURCHASEORDERLINE_ITEMID)));

        PriceListHelper.setApplicablePrices(
            purchaseOrderLines, 
            purchaseOrderDocuments, 
            items.values(),
            true);
        update purchaseOrderLines;
    }

    private static void createPurchaseOrderLines(List<dmpl__PurchaseOrder__c> purchaseOrders, List<dmpl__AutoPurchaseOrderLine__c> autoPurchaseOrderLines){
        List<dmpl__PurchaseOrderLine__c> newPurchaseOrderLines = new List<dmpl__PurchaseOrderLine__c>();
        for(dmpl__PurchaseOrder__c purchaseOrder : purchaseOrders){

            List<dmpl__AutoPurchaseOrderLine__c> filteredAutoPurchaseOrderLines = DocumentHelper.getObjectsByFilter(autoPurchaseOrderLines, FIELD_PURCHASEORDER_AUTOPURCHASEORDERID, purchaseOrder.dmpl__AutoPurchaseOrderId__c);
            for(dmpl__AutoPurchaseOrderLine__c autoPurchaseOrderLine : filteredAutoPurchaseOrderLines)
            {
                if(autoPurchaseOrderLine.dmpl__PendingQuantity__c > 0)
                    newPurchaseOrderLines.add(new dmpl__PurchaseOrderLine__c(
                        dmpl__PurchaseOrderId__c = purchaseOrder.Id,
                        dmpl__ItemId__c = autoPurchaseOrderLine.dmpl__ItemId__c,
                        dmpl__Quantity__c = autoPurchaseOrderLine.dmpl__DerivedQuantity__c, // dmpl__PendingQuantity__c
                        dmpl__AutoPurchaseOrderLineId__c = autoPurchaseOrderLine.ID,
                        dmpl__UnitCost__c = autoPurchaseOrderLine.dmpl__UnitCost__c,
                        dmpl__SKUId__c = autoPurchaseOrderLine.dmpl__SKUId__c
                    ));
            }
        }

        if(newPurchaseOrderLines.size() > 0){
            try {
                SecurityHelper.ensureCanCreateObject('dmpl__PurchaseOrderLine__c');
                skipValidations = true;
                SecurityHelper.ensureCanWriteFields(new string[]{'dmpl__ItemId__c','dmpl__Quantity__c','dmpl__AutoPurchaseOrderLineId__c','dmpl__UnitCost__c','dmpl__SKUId__c'}, 'dmpl__PurchaseOrderLine__c');
                insert newPurchaseOrderLines;
            } finally {
                skipValidations = false;
            }
        }
    }

    private static List<dmpl__AutoPurchaseOrderLine__c> queryAutoPurchaseOrderLines(List<ID> autoPurchaseOrderIds){

        SecurityHelper.ensureCanReadFields(new string[]{'dmpl__Amount__c','dmpl__AutoPurchaseOrderId__c','dmpl__ItemId__c','dmpl__SKUId__c','dmpl__PendingQuantity__c','dmpl__PurchaseOrderQuantity__c','dmpl__Quantity__c','dmpl__SuggestedQuantity__c','dmpl__UnitCost__c','dmpl__DerivedQuantity__c'}, 'dmpl__AutoPurchaseOrderLine__c');
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
            dmpl__UnitCost__c,
            dmpl__DerivedQuantity__c
            FROM
            dmpl__AutoPurchaseOrderLine__c
            WHERE 
            dmpl__AutoPurchaseOrderId__c IN : autoPurchaseOrderIds];
    }

    private static void validateChangeInQuantity(List<dmpl__PurchaseOrderLine__c> oldEntries, List<dmpl__PurchaseOrderLine__c> newEntries){
        Map<Id, dmpl__PurchaseOrderLine__c> oldObjectsMap = new Map<Id, dmpl__PurchaseOrderLine__c>(oldEntries);
        for(dmpl__PurchaseOrderLine__c lineEntry : newEntries){
            dmpl__PurchaseOrderLine__c oldEntry = oldObjectsMap.get(lineEntry.Id);
            if(oldEntry != null){
                Double transactedQty = (oldEntry.dmpl__ReceiptQuantity__c == null) ? 0 : oldEntry.dmpl__ReceiptQuantity__c;
                transactedQty += (oldEntry.dmpl__ReturnedQuantity__c == null) ? 0 : oldEntry.dmpl__ReturnedQuantity__c;
                if(oldEntry.dmpl__Quantity__c != lineEntry.dmpl__Quantity__c && lineEntry.dmpl__Quantity__c !=null
                    && lineEntry.dmpl__Quantity__c < transactedQty) {
                    lineEntry.addError(String.format(
                        String.valueOf(System.Label.IntegrityFailed_TransactedQuantityCanNotBeReduced), 
                        new String[]{String.valueOf(transactedQty)})); 
                } 
            }   
        }
    }

    private static void validateItem(List<dmpl__PurchaseOrderLine__c> newEntries){
        Map<Id, dmpl__Item__c> items = new Map<Id,dmpl__Item__c>(ItemHelper.getCachedItems(DocumentHelper.extractIds(newEntries, FIELD_PURCHASEORDERLINE_ITEMID)));
        for(dmpl__PurchaseOrderLine__c orderLine : newEntries){
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

    private static void validateOrderQuantity(List<dmpl__PurchaseOrderLine__c> newEntries){
        dmpl__DMSOrgSetting__mdt  orgSetting = OrgSettingHelper.OrgSetting();
        List<dmpl__PurchaseOrder__c> purchaseOrderDocuments = queryPurchaseOrderDocument(
            DocumentHelper.extractIds(
                newEntries, 
                FIELD_PURCHASEORDER_ID));
        List<dmpl__ItemInventoryAttribute__c> attributes = queryItemInventoryAttribute(
            CollectionHelper.extractIds(
                newEntries, 
                FIELD_PURCHASEORDERLINE_ITEMID),
            CollectionHelper.extractIds(
                purchaseOrderDocuments, 
                'dmpl__PartnerAccountId__c'),
            CollectionHelper.extractIds(
                purchaseOrderDocuments, 
                'dmpl__BranchId__c'));
        for(dmpl__PurchaseOrderLine__c line : newEntries){
            dmpl__PurchaseOrder__c order = (dmpl__PurchaseOrder__c)CollectionHelper.getObject(
                purchaseOrderDocuments, line.dmpl__PurchaseOrderId__c);
            for(dmpl__ItemInventoryAttribute__c attrib : attributes){
                if(attrib.dmpl__ItemId__c == line.dmpl__ItemId__c
                    && (attrib.dmpl__PartnerAccountId__c == order.dmpl__PartnerAccountId__c 
                        || attrib.dmpl__PartnerAccountId__c == null)
                    && (attrib.dmpl__BranchId__c == order.dmpl__BranchId__c
                        || attrib.dmpl__BranchId__c == null)){
                        if(orgSetting != null && orgSetting.dmpl__EnableMOQQuantityValidation__c){
                        if(attrib.dmpl__MaximumOrderQuantity__c !=null 
                            && line.dmpl__Quantity__c > attrib.dmpl__MaximumOrderQuantity__c){
                                line.addError(
                                    String.format(
                                        'Order Quantity ({0}) can\'t be more then Maximum Order Quantity ({1}).', 
                                        new String[]{
                                            String.valueOf(line.dmpl__Quantity__c), 
                                            String.valueOf(attrib.dmpl__MaximumOrderQuantity__c)})); 
                        }
                        if(attrib.dmpl__MinimumOrderQuantity__c !=null 
                            && line.dmpl__Quantity__c < attrib.dmpl__MinimumOrderQuantity__c){
                                line.addError(
                                    String.format(
                                        'Order Quantity ({0}) can\'t be less then Minimum Order Quantity ({1}).', 
                                        new String[]{
                                            String.valueOf(line.dmpl__Quantity__c), 
                                            String.valueOf(attrib.dmpl__MinimumOrderQuantity__c)})); 
                        }
                        if(attrib.dmpl__LotQuantity__c !=null 
                            && Math.mod((Integer)line.dmpl__Quantity__c, (Integer)attrib.dmpl__LotQuantity__c)!= 0){
                                line.addError(
                                    String.format(
                                        'Order Quantity ({0}) needs to be in multiple of Lot Quantity ({1}).', 
                                        new String[]{
                                            String.valueOf(line.dmpl__Quantity__c), 
                                            String.valueOf(attrib.dmpl__LotQuantity__c)})); 
                        }
                        break;
                    }
                }
            }
        }
    }
    
    private static void setItemData(List<dmpl__PurchaseOrderLine__c> newEntries)
    {
        Map<Id, dmpl__Item__c> items = new Map<Id,dmpl__Item__c>(
        ItemHelper.getCachedItems(DocumentHelper.extractIds(newEntries, FIELD_PURCHASEORDERLINE_ITEMID)));
        List<dmpl__PurchaseOrder__c> purchaseOrderDocuments = queryPurchaseOrderDocument(DocumentHelper.extractIds(newEntries, FIELD_PURCHASEORDER_ID));
        setAlternateItem(newEntries, items);
        ItemHelper.setQuantityFromUOM(
            newEntries, 
            null,
            items);
        TaxGroupHelper.setApplicableTaxGroups(newEntries, purchaseOrderDocuments, items.values());
        PriceListHelper.setApplicablePrices(
            newEntries, 
            purchaseOrderDocuments, 
            items.values(),
            false);
        DiscountGroupHelper.setApplicableDiscounts(newEntries, purchaseOrderDocuments, items.values());
        InventoryStockHelper.setStock(newEntries);
    }

    private static void setAlternateItem(List<dmpl__PurchaseOrderLine__c> newEntries,Map<Id, dmpl__Item__c> items)
    {
        for(dmpl__PurchaseOrderLine__c newEntry : newEntries)
        {
            dmpl__Item__c item = items.get(newEntry.dmpl__ItemId__c);

            for(dmpl__ItemAlternate__c alternateItem : item.dmpl__ItemsAlternates__r)
            {
                if(newEntry.dmpl__AlternateItemId__c != null && newEntry.dmpl__AlternateItemId__c == alternateItem.Id)
                {
                    newEntry.dmpl__OriginalItemId__c = newEntry.dmpl__ItemId__c;
                    newEntry.dmpl__ItemId__c = alternateItem.dmpl__AlternateItemId__c;
                    newEntry.dmpl__AlternateItemId__c = null;
                }

                if(alternateItem.dmpl__AlternateType__c == 'Superseded')
                {
                    newEntry.dmpl__ItemId__c = alternateItem.dmpl__AlternateItemId__c;
                    newEntry.dmpl__OriginalItemId__c = alternateItem.dmpl__ItemId__c;
                }
            }
        }

        items = new Map<Id,dmpl__Item__c>(ItemHelper.getCachedItems(DocumentHelper.extractIds(newEntries, FIELD_PURCHASEORDERLINE_ITEMID)));
    }

    private static List<dmpl__PurchaseOrder__c> queryPurchaseOrderDocument(List<ID> purchaseOrderLineIds)
    {

        SecurityHelper.ensureCanReadFields(new string[]{
            'dmpl__DocumentDate__c',
            'dmpl__Status__c',
            'dmpl__PartnerAccountId__c',
            'dmpl__BranchId__c',
            'dmpl__PriceListId__c',
            'dmpl__TaxSupplyType__c',
            'dmpl__DiscountGroupId__c',
            'dmpl__PriceAsOnDate__c',
            'dmpl__TransactionType__c',
            'dmpl__TCSEligibleAmount__c',
            'dmpl__SkipScheme__c'
        }, 'dmpl__PurchaseOrder__c');
        return [
            SELECT 
                Id, 
                Name, 
                dmpl__DocumentDate__c,
                dmpl__Status__c,
                dmpl__PartnerAccountId__c,
                dmpl__SupplierAccountId__c,
                dmpl__BranchId__c,
                dmpl__PriceListId__c,
                dmpl__TaxSupplyType__c,
                dmpl__DiscountGroupId__c,
                dmpl__PriceAsOnDate__c,
                dmpl__TransactionType__c,
                dmpl__TCSEligibleAmount__c,
                dmpl__SkipScheme__c
            FROM dmpl__PurchaseOrder__c 
            WHERE ID IN : purchaseOrderLineIds ];
    }

    // @testVisible
    // private static Map<ID, dmpl__PurchaseOrderLine__c> queryPurchaseOrderLines(List<ID> purchaseOrderIds)
    // {
    //     SecurityHelper.ensureCanReadFields(new string[]{'dmpl__Quantity__c','dmpl__ReceiptQuantity__c'}, 'dmpl__PurchaseOrderLine__c');
    //     return new Map<ID, dmpl__PurchaseOrderLine__c>(
    //         [SELECT
    //         ID,
    //         Name,
    //         dmpl__Quantity__c,
    //         dmpl__ReceiptQuantity__c
    //         FROM dmpl__PurchaseOrderLine__c
    //         WHERE dmpl__PurchaseOrderId__c IN : purchaseOrderIds]
    //     );
    // }

    @testVisible
    private static List<dmpl__PurchaseOrderLine__c> queryPurchaseOrderLines(
        List<ID> purchaseOrderLineIds)
    {
        SecurityHelper.ensureCanReadFields(new List<String>
        {
            'Name', 
            'dmpl__ItemId__c',
            'dmpl__SKUId__c',
            'dmpl__Quantity__c'
        },'dmpl__PurchaseOrderLine__c');
        return [ SELECT ID, 
            Name, 
            dmpl__ItemId__c,
            dmpl__SKUId__c,
            dmpl__Quantity__c
        FROM dmpl__PurchaseOrderLine__c
        WHERE ID IN : purchaseOrderLineIds];
    }    

    private static List<dmpl__PurchaseOrderLine__c> queryPurchaseOrderLinesOfPurchaseOrders(
        List<ID> purchaseOrderIds)
    {
        SecurityHelper.ensureCanReadFields(new List<String>
        {
            'Name', 
            'dmpl__ItemId__c',
            'dmpl__SKUId__c',
            'dmpl__Quantity__c',
            'dmpl__PriceListId__c',
            'dmpl__UnitCost__c',
            'dmpl__TaxGroupId__c',
            'dmpl__ItemLotTypeId__c',
            'dmpl__TaxAmount__c',
            'dmpl__PurchaseOrderId__c'
        },'dmpl__PurchaseOrderLine__c');
        return [ SELECT ID, 
            Name, 
            dmpl__ItemId__c,
            dmpl__SKUId__c,
            dmpl__PriceListId__c,
            dmpl__Quantity__c,
            dmpl__UnitCost__c,
            dmpl__TaxGroupId__c,
            dmpl__ItemLotTypeId__c,
            dmpl__TaxAmount__c,
            dmpl__PurchaseOrderId__c,
            dmpl__PriceAsOnDate__c
        FROM dmpl__PurchaseOrderLine__c
        WHERE dmpl__PurchaseOrderId__c IN : purchaseOrderIds];
    }

    @testVisible
    private static List<dmpl__PurchaseReturnLine__c> queryPurchaseReturnLines(List<ID> purchaseReturnIds)
    {
        SecurityHelper.ensureCanReadFields(new string[]{'dmpl__GoodsReceiptLineId__c','dmpl__Quantity__c','dmpl__PurchaseReturnId__c', 'dmpl__PurchaseOrderLineId__c'}, 'dmpl__PurchaseReturnLine__c');
        
        return [SELECT Id, 
        Name, 
        dmpl__GoodsReceiptLineId__c, 
        dmpl__Quantity__c, 
        dmpl__PurchaseReturnId__c, 
        dmpl__PurchaseOrderLineId__c 
        FROM dmpl__PurchaseReturnLine__c 
        WHERE dmpl__PurchaseReturnId__c IN : purchaseReturnIds];
    }

    public static void updatePurchaseInvoiceQuantity(List<Id> purchaseOrderLineIds)
    {
        try{
            skipValidations = true;
            SecurityHelper.ensureCanReadFields(new string[]{'dmpl__PurchaseOrderLineId__c','dmpl__Quantity__c'}, 'dmpl__BillLine__c');
            List<AggregateResult> ffAggregates = 
                [SELECT dmpl__PurchaseOrderLineId__c PurchaseOrderLineId, SUM(dmpl__Quantity__c) TotalQuantity
                FROM dmpl__BillLine__c
                WHERE dmpl__PurchaseOrderLineId__c IN :purchaseOrderLineIds
                WITH SECURITY_ENFORCED
                GROUP BY dmpl__PurchaseOrderLineId__c];

            SecurityHelper.ensureCanReadFields(new string[]{'dmpl__InvoiceQuantity__c'}, 'dmpl__PurchaseOrderLine__c');
            List<dmpl__PurchaseOrderLine__c> orderLinesToUpdate = 
                [SELECT Id, dmpl__InvoiceQuantity__c
                FROM dmpl__PurchaseOrderLine__c
                WHERE Id IN :purchaseOrderLineIds];
    
            for(dmpl__PurchaseOrderLine__c orderLine : orderLinesToUpdate){
                for(AggregateResult result : ffAggregates){
                    if(result.get(FIELD_AGG_PURCHASEORDERLINEID) == orderLine.Id){
                        orderLine.dmpl__InvoiceQuantity__c = result.get(FIELD_AGG_TOTALQTY) ==null ? 0 : (Decimal)(result.get(FIELD_AGG_TOTALQTY));
                        break;
                    }
                }
            }
            SecurityHelper.ensureCanWriteFields(new string[]{'dmpl__InvoiceQuantity__c'}, 'dmpl__PurchaseOrderLine__c');
            Update orderLinesToUpdate;
        }finally{
            skipValidations = false;
        }
    }

    public static void updatePurchaseReceiptQuantity(List<Id> purchaseOrderLineIds)
    {
        try{
            skipValidations = true;
            SecurityHelper.ensureCanReadFields(new string[]{'dmpl__PurchaseOrderLineId__c','dmpl__SupplierQuantity__c'}, 'dmpl__GoodsReceiptLine__c');
            List<AggregateResult> ffAggregates = 
                [SELECT dmpl__PurchaseOrderLineId__c PurchaseOrderLineId, SUM(dmpl__SupplierQuantity__c) TotalQuantity
                FROM dmpl__GoodsReceiptLine__c
                WHERE dmpl__PurchaseOrderLineId__c IN :purchaseOrderLineIds
                WITH SECURITY_ENFORCED
                GROUP BY dmpl__PurchaseOrderLineId__c];

            SecurityHelper.ensureCanReadFields(new string[]{'dmpl__ReceiptQuantity__c'}, 'dmpl__PurchaseOrderLine__c');
            List<dmpl__PurchaseOrderLine__c> orderLinesToUpdate = 
                [SELECT Id, dmpl__ReceiptQuantity__c
                FROM dmpl__PurchaseOrderLine__c
                WHERE Id IN :purchaseOrderLineIds];
    
            for(dmpl__PurchaseOrderLine__c orderLine : orderLinesToUpdate){
                for(AggregateResult result : ffAggregates){
                    if(result.get(FIELD_AGG_PURCHASEORDERLINEID) == orderLine.Id){
                        orderLine.dmpl__ReceiptQuantity__c = result.get(FIELD_AGG_TOTALQTY) == null ? 0 : (Decimal)(result.get(FIELD_AGG_TOTALQTY));
                        break;
                    }
                }
            }
            SecurityHelper.ensureCanWriteFields(new string[]{'dmpl__ReceiptQuantity__c'}, 'dmpl__PurchaseOrderLine__c');
            Update orderLinesToUpdate;
        }finally{
            skipValidations = false;
        }
    }

    private static List<dmpl__ItemInventoryAttribute__c> queryItemInventoryAttribute(
        List<Id> itemIds,
        List<Id> partnerAccountIds,
        List<Id> branchIds){
        return [SELECT
                Id,
                dmpl__ItemId__c,
                dmpl__SKUId__c,
                dmpl__ItemLotTypeId__c,
                dmpl__LotQuantity__c,
                dmpl__MaximumOrderQuantity__c,
                dmpl__MinimumOrderQuantity__c,
                dmpl__PartnerAccountId__c,
                dmpl__BranchId__c
            FROM dmpl__ItemInventoryAttribute__c
            WHERE 
                dmpl__ItemId__c IN :itemIds
                AND (dmpl__PartnerAccountId__c = null 
                    OR dmpl__PartnerAccountId__c IN :partnerAccountIds)
                AND (dmpl__BranchId__c = null 
                    OR dmpl__BranchId__c IN :branchIds)
            ORDER BY dmpl__ItemId__c, dmpl__PartnerAccountId__c, dmpl__BranchId__c
            NULLS LAST];
    }

    private static List<dmpl__ItemUnitOfMeasure__c> queryItemUnitOfMeasures(Set<Id> itemIds) {
        return [
            SELECT
                Id,
                dmpl__ItemId__c,
                dmpl__QuantityUnitOfMeasure__c,
                Name,
                dmpl__ConversionRatio__c
            FROM dmpl__ItemUnitOfMeasure__c
            WHERE dmpl__ItemId__c IN :itemIds
        ];
    }
}