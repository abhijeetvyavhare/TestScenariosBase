public with sharing class SaleDeliveryLineHelper {
    private static Boolean skipValidations = false;

    private static final string OBJECT_SALEDELIVERY = 'dmpl__DeliveryOrder__c';
    private static final string OBJECT_SALEDELIVERYLINE = 'dmpl__DeliveryOrderLine__c';
    private static final string FIELD_SALEDELIVERYLINE_SALEDELIVERYID = 'dmpl__DeliveryId__c';
    private static final string FIELD_SALEDELIVERYLINE_ASSETID = 'dmpl__AssetId__c';
    private static final string FIELD_SALEDELIVERYLINE_ITEMID = 'dmpl__ItemId__c';
    private static final string FIELD_SALEDELIVERYLINE_ITEMLOTID = 'dmpl__ItemLotId__c';
    private static final string FIELD_SALEDELIVERYLINE_SKUID = 'dmpl__SKUId__c';
    private static final string FIELD_SALEDELIVERYLINE_QUANTITY = 'dmpl__Quantity__c';
    private static final string FIELD_SALEDELIVERYLINE_RETURNQUANTITY = 'dmpl__ReturnedQuantity__c';
    private static final string FIELD_SALEDELIVERYLINE_AMOUNT = 'dmpl__Amount__c';
    private static final string FIELD_SALEDELIVERYLINE_TAXGROUPID = 'dmpl__TaxGroupId__c';
    private static final string FIELD_SALEDELIVERYLINE_ITEMALIASID = 'dmpl__ItemAliasId__c';
    private static final string FIELDNAME_SALEDELIVERYLINE_PRICELISTRULEID = 'dmpl__PriceListRuleId__c';
    
    private static final string FIELD_SALEDELIVERYLINE_FULFILLMENTALLOCATIONLINEID = 'dmpl__FulfillmentAllocationLineId__c';
    private static final string FIELD_SALEDELIVERYLINE_FULFILLMENTPICKINGLINEID = 'dmpl__FulfillmentPickingLineId__c';
    private static final string FIELD_SALEDELIVERYLINE_SALEORDERLINEID = 'dmpl__SaleOrderLineId__c';
    private static final string FIELD_SALEDELIVERYLINE_BILLRETURNLINEID = 'dmpl__BillReturnLineId__c';
    private static final string RELATION_SALEDELIVERYLINE_STATUS = 'dmpl__SaleDeliveryId__r.dmpl__Status__c';
    private static final string FIELD_AGG_DELIVERYORDERLINEID = 'DeliveryOrderLineId';
    private static final string FIELD_AGG_TOTALQTY = 'TotalQuantity';
    private static final string FIELD_AGG_DELIVERYLINEID = 'DeliveryOrderLineId';


    private static final List<String> LIST_FIELDS_NONEDITABLE = new List<String>{};
    private static final List<String> LIST_FIELDS_SYSTEM = new List<String>{};
    private static final List<String> LIST_FIELDS_SOURCEPOULATED = new List<String>{
        FIELD_SALEDELIVERYLINE_ITEMID,
        FIELD_SALEDELIVERYLINE_ITEMLOTID,
        FIELD_SALEDELIVERYLINE_SKUID};
    private static final List<String> LIST_FIELDS_LOCKEDIFTRANSACTED = new List<String>{};

    private static final List<String> LIST_FIELDS_NEGATIVENOTALLOWED = new List<String>{
        'dmpl__AllocatedQuantity__c', 
        'dmpl__InvoicedQuantity__c', 
        'dmpl__PendingInvoiceQuantity__c', 
        'dmpl__PendingShippedQuantity__c', 
        'dmpl__EligibleReturnQuantity__c', 
        'dmpl__PickedQuantity__c', 
        'dmpl__ReturnedQuantity__c'
    };

    private static final List<String> LIST_FIELDS_ZERONOTALLOWED = new List<String>{

    };

    public static void validateData(
        Boolean isInsert, 
        Boolean isDelete, 
        Boolean isUpdate, 
        List<dmpl__DeliveryOrderLine__c> oldEntries, 
        List<dmpl__DeliveryOrderLine__c> newEntries)
    {
        try{
            if(isInsert){
                FieldMappingHelper.copyFieldMappingData(
                    newEntries);
            }
            if(isInsert || isUpdate){
                ValidationHelper.validateNonZeroDecimal(
                    LIST_FIELDS_ZERONOTALLOWED,
                    newEntries);
                ValidationHelper.validatePostiveOrZeroDecimal(
                    LIST_FIELDS_NEGATIVENOTALLOWED,
                    newEntries);
            }
            if(skipValidations){
                return;
            }
            DocumentStatusDFSHelper dfsHelper = new DocumentStatusDFSHelper();
            if(isInsert){
                validateItem(newEntries);
                dfsHelper.DocumentStatusRelatedObjectRestrictEdits_New(
                    OBJECT_SALEDELIVERY, 
                    OBJECT_SALEDELIVERYLINE, 
                    RELATION_SALEDELIVERYLINE_STATUS, 
                    newEntries);
            }else if(isUpdate){
                DocumentHelper.validateChangeInSystemFields(
                    LIST_FIELDS_SYSTEM, 
                    oldEntries, 
                    newEntries);
                DocumentHelper.validateChangeInKeyFields(
                    LIST_FIELDS_NONEDITABLE, 
                    oldEntries, 
                    newEntries);
                DocumentHelper.validateChangeInSourcePopulatedFields(
                    LIST_FIELDS_SOURCEPOULATED, 
                    oldEntries, 
                    newEntries,
                    FIELD_SALEDELIVERYLINE_SALEORDERLINEID);
                DocumentHelper.validateChangeInLockedIfTransactedFields(
                    LIST_FIELDS_LOCKEDIFTRANSACTED,
                    oldEntries,
                    newEntries,
                    FIELD_SALEDELIVERYLINE_QUANTITY);
                dfsHelper.DocumentStatusRelatedObjectRestrictEdits_Edit(
                    OBJECT_SALEDELIVERY, 
                    OBJECT_SALEDELIVERYLINE,
                    RELATION_SALEDELIVERYLINE_STATUS, 
                    oldEntries, 
                    newEntries);
            }else if(isDelete){
                DocumentHelper.validateCanBeDeleted(
                    oldEntries, 
                    FIELD_SALEDELIVERYLINE_QUANTITY);
                dfsHelper.DocumentStatusRelatedObjectRestrictEdits_Delete(
                    OBJECT_SALEDELIVERY, 
                    OBJECT_SALEDELIVERYLINE, 
                    RELATION_SALEDELIVERYLINE_STATUS, 
                    oldEntries);
            }
        }catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }

    public static void postData(
        Boolean isInsert, 
        Boolean isDelete, 
        Boolean isUpdate, 
        List<dmpl__DeliveryOrderLine__c> oldEntries, 
        List<dmpl__DeliveryOrderLine__c> newEntries){
        try {
            if(isInsert){
                setItemData(
                    newEntries);
                setOrderDiscount(
                    newEntries);
                TaxHelper.setLinesTaxes(
                    newEntries);
            } else if(isUpdate){
                List<dmpl__DeliveryOrderLine__c> modifiedObjects = DocumentHelper.getModifiedNewObjects(
                    FIELDNAME_SALEDELIVERYLINE_PRICELISTRULEID, 
                    oldEntries, 
                    newEntries);
                if(modifiedObjects.size()>0){
                    Map<Id, dmpl__Item__c> items = new Map<Id,dmpl__Item__c>(
                        ItemHelper.getCachedItems(
                            DocumentHelper.extractIds(
                                modifiedObjects, 
                                FIELD_SALEDELIVERYLINE_ITEMID)));
                    List<dmpl__DeliveryOrder__c> deliveryOrderDocuments = queryDeliveryOrderDocument(
                        DocumentHelper.extractIds(
                            modifiedObjects, 
                            FIELD_SALEDELIVERYLINE_SALEDELIVERYID));
                    PriceListHelper.setApplicablePrices(
                        modifiedObjects, 
                        deliveryOrderDocuments, 
                        items.values(), 
                        DocumentHelper.extractIds(
                            modifiedObjects, 
                            FIELDNAME_SALEDELIVERYLINE_PRICELISTRULEID),
                            'SaleDeliveryId__c');
                }
                modifiedObjects = DocumentHelper.getModifiedNewObjects(
                    'dmpl__DiscountAmount__c', 
                    oldEntries, 
                    newEntries);
                if(modifiedObjects.size()>0){
                    updateDiscount(modifiedObjects);
                }
                modifiedObjects = DocumentHelper.getModifiedNewObjects(
                    new string[]{
                        FIELD_SALEDELIVERYLINE_TAXGROUPID,
                        FIELD_SALEDELIVERYLINE_ITEMID, 
                        FIELD_SALEDELIVERYLINE_SKUID,
                        FIELD_SALEDELIVERYLINE_AMOUNT
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
                    FIELD_SALEDELIVERYLINE_ITEMID)));
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
                //SaleDeliveryTaxHelper.deleteApplicableTaxes(oldEntries);
            }

            InventoryLedgerHelper.createLedger(
                InventoryLedgerTypeEnums.Outward, 
                FIELD_SALEDELIVERYLINE_SALEDELIVERYID, 
                OBJECT_SALEDELIVERY, 
                isInsert, 
                isDelete, 
                isUpdate, 
                oldEntries, 
                newEntries);
        } catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }
    
    public static void afterPostData(
        Boolean isInsert, 
        Boolean isDelete, 
        Boolean isUpdate, 
        List<dmpl__DeliveryOrderLine__c> oldEntries, 
        List<dmpl__DeliveryOrderLine__c> newEntries)
    {
        try{
        if(isDelete){
            SaleOrderLineHelper.updateSaleDeliveryQuantity(DocumentHelper.extractIds(
                oldEntries, 
                FIELD_SALEDELIVERYLINE_SALEORDERLINEID));
            InventoryFulfillmentAllocationLineHelper.updateSaleDeliveryQuantity(DocumentHelper.extractIds(
                oldEntries, 
                FIELD_SALEDELIVERYLINE_FULFILLMENTALLOCATIONLINEID));
            InventoryFulfillmentPickingLineHelper.updateSaleDeliveryQuantity(DocumentHelper.extractIds(
                    oldEntries, 
                    FIELD_SALEDELIVERYLINE_FULFILLMENTPICKINGLINEID));
            BillReturnLineHelper.updateSaleDeliveryQuantity(DocumentHelper.extractIds(
                oldEntries, 
                FIELD_SALEDELIVERYLINE_BILLRETURNLINEID));
                TaxHelper.deleteLinesTaxes(oldEntries);
        }else if(isInsert){
            SaleOrderLineHelper.updateSaleDeliveryQuantity(DocumentHelper.extractIds(
                newEntries, 
                FIELD_SALEDELIVERYLINE_SALEORDERLINEID));
            InventoryFulfillmentAllocationLineHelper.updateSaleDeliveryQuantity(DocumentHelper.extractIds(
                newEntries,
                FIELD_SALEDELIVERYLINE_FULFILLMENTALLOCATIONLINEID));
            InventoryFulfillmentPickingLineHelper.updateSaleDeliveryQuantity(DocumentHelper.extractIds(
                newEntries, 
                FIELD_SALEDELIVERYLINE_FULFILLMENTPICKINGLINEID));
            BillReturnLineHelper.updateSaleDeliveryQuantity(DocumentHelper.extractIds(
                newEntries, 
                FIELD_SALEDELIVERYLINE_BILLRETURNLINEID));
                TaxHelper.createLinesTaxes(
                    isInsert, 
                    newEntries);
        }else if(isUpdate){
            List<dmpl__DeliveryOrderLine__c> modifiedObjects = DocumentHelper.getModifiedNewObjects(
                new string[]{
                    FIELD_SALEDELIVERYLINE_TAXGROUPID,
                    FIELD_SALEDELIVERYLINE_ITEMID, 
                    FIELD_SALEDELIVERYLINE_SKUID,
                    FIELD_SALEDELIVERYLINE_AMOUNT
                }, 
                oldEntries, 
                newEntries);
            if(modifiedObjects.size()>0){
                TaxHelper.createLinesTaxes(
                    isInsert,
                    modifiedObjects);
            }
            List<Id> modifiedObjectIds = DocumentHelper.getModifiedNewObjectIds(
                new List<String>{FIELD_SALEDELIVERYLINE_QUANTITY, FIELD_SALEDELIVERYLINE_RETURNQUANTITY},
                FIELD_SALEDELIVERYLINE_SALEORDERLINEID, 
                oldEntries, 
                newEntries);
            if(modifiedObjectIds.size()>0){
                SaleOrderLineHelper.updateSaleDeliveryQuantity(modifiedObjectIds);
            }            
            modifiedObjectIds = DocumentHelper.getModifiedNewObjectIds(
                new List<String>{FIELD_SALEDELIVERYLINE_QUANTITY, FIELD_SALEDELIVERYLINE_RETURNQUANTITY},
                FIELD_SALEDELIVERYLINE_FULFILLMENTALLOCATIONLINEID, 
                oldEntries, 
                newEntries);
            if(modifiedObjectIds.size()>0){
                InventoryFulfillmentAllocationLineHelper.updateSaleDeliveryQuantity(modifiedObjectIds);
            } 
            modifiedObjectIds = DocumentHelper.getModifiedNewObjectIds(
                new List<String>{FIELD_SALEDELIVERYLINE_QUANTITY, FIELD_SALEDELIVERYLINE_RETURNQUANTITY},
                FIELD_SALEDELIVERYLINE_FULFILLMENTPICKINGLINEID, 
                oldEntries, 
                newEntries);
            if(modifiedObjectIds.size()>0){
                InventoryFulfillmentPickingLineHelper.updateSaleDeliveryQuantity(modifiedObjectIds);
            }
            modifiedObjectIds = DocumentHelper.getModifiedNewObjectIds(
                new List<String>{FIELD_SALEDELIVERYLINE_QUANTITY, FIELD_SALEDELIVERYLINE_RETURNQUANTITY},
                FIELD_SALEDELIVERYLINE_BILLRETURNLINEID, 
                oldEntries, 
                newEntries);
            if(modifiedObjectIds.size()>0){
                BillReturnLineHelper.updateSaleDeliveryQuantity(modifiedObjectIds);
            }            
        }
    } catch (Exception error) {
        ExceptionLogHelper.logException(error);
        throw error;
    }
    }

    public static void updateSaleInvoiceQuantity(List<Id> deliveryLineIds)
    {
        try{
            if(deliveryLineIds.Size() == 0)
                return;
            skipValidations = true;
            List<AggregateResult> ffAggregates = 
                [SELECT dmpl__DeliveryOrderLineId__c DeliveryLineId, SUM(dmpl__Quantity__c) TotalQuantity
                FROM dmpl__SaleInvoiceLine__c
                WHERE dmpl__DeliveryOrderLineId__c IN :deliveryLineIds
                WITH SECURITY_ENFORCED
                GROUP BY dmpl__DeliveryOrderLineId__c];
            List<dmpl__DeliveryOrderLine__c> deliveryLinesToUpdate = 
                [SELECT Id, dmpl__DeliveredInvoiceQuantity__c
                FROM dmpl__DeliveryOrderLine__c
                WHERE Id IN :deliveryLineIds];
    
            for(dmpl__DeliveryOrderLine__c deliveryLine : deliveryLinesToUpdate){
                for(AggregateResult result : ffAggregates){
                    if(result.get('DeliveryLineId') == deliveryLine.Id){
                        deliveryLine.dmpl__DeliveredInvoiceQuantity__c = result.get(FIELD_AGG_TOTALQTY) ==null ? 0 : (Decimal)(result.get(FIELD_AGG_TOTALQTY));
                        break;
                    }
                }
            }
            Update deliveryLinesToUpdate;
        }finally{
            skipValidations = false;
        }
    }
    
    public static void updateSaleReturnQuantity(List<Id> deliveryLineIds)
    {
        try{
            skipValidations = true;
             
            SecurityHelper.ensureCanReadFields(new string[]{
                'dmpl__DeliveryOrderLineId__c',
                'dmpl__Quantity__c'
            }, 'dmpl__SaleReturnLine__c');
            List<AggregateResult> ffAggregates = 
                [SELECT 
                dmpl__DeliveryOrderLineId__c DeliveryOrderLineId, 
                    SUM(dmpl__Quantity__c) TotalQuantity
                FROM 
                    dmpl__SaleReturnLine__c
                WHERE 
                dmpl__DeliveryOrderLineId__c IN :deliveryLineIds
                WITH SECURITY_ENFORCED
                GROUP BY dmpl__DeliveryOrderLineId__c];
             
            SecurityHelper.ensureCanReadFields(new string[]{
                'dmpl__ReturnedQuantity__c'
            }, 'dmpl__DeliveryOrderLine__c');
            List<dmpl__DeliveryOrderLine__c> orderLinesToUpdate = 
                [SELECT 
                    Id, 
                    dmpl__ReturnedQuantity__c
                FROM 
                    dmpl__DeliveryOrderLine__c
                WHERE 
                    Id IN :deliveryLineIds];
    
            for(dmpl__DeliveryOrderLine__c orderLine : orderLinesToUpdate){
                Boolean isLineFound = false;
                for(AggregateResult result : ffAggregates){
                    if(result.get(FIELD_AGG_DELIVERYLINEID) == orderLine.Id){
                        isLineFound = true;
                        orderLine.dmpl__ReturnedQuantity__c 
                            = result.get(FIELD_AGG_TOTALQTY) ==null ? 
                                0 : (Decimal)(result.get(FIELD_AGG_TOTALQTY));
                        break;
                    }
                }
                if(!isLineFound)
                    orderLine.dmpl__ReturnedQuantity__c = 0;
            }
            SecurityHelper.ensureCanWriteFields(new string[]{
                'dmpl__ReturnedQuantity__c'
            }, 'dmpl__DeliveryOrderLine__c');
            Update orderLinesToUpdate;
        }finally{
            skipValidations = false;
        }
    }

    private static void setItemData(
        List<dmpl__DeliveryOrderLine__c> newEntries)
    {
        setItemAliasData(newEntries);
        Map<Id, dmpl__Item__c> items = new Map<Id,dmpl__Item__c>(
            ItemHelper.getCachedItems(
                DocumentHelper.extractIds(
                    newEntries, 
                    FIELD_SALEDELIVERYLINE_ITEMID)));
        List<dmpl__DeliveryOrder__c> deliveryOrderDocuments = queryDeliveryOrderDocument(
            DocumentHelper.extractIds(
                newEntries, 
                FIELD_SALEDELIVERYLINE_SALEDELIVERYID));
        setDefaultSKU(
            newEntries, 
            items);
        ItemHelper.setQuantityFromUOM(
            newEntries, 
            null,
            items);
        setInvoiceGroup(
            newEntries,
            items);
        setSubscriptionDetails(
                newEntries,
                items);
        TaxGroupHelper.setApplicableTaxGroups(
            newEntries, 
            deliveryOrderDocuments, 
            items.values());
        PriceListHelper.setApplicablePrices(
            newEntries, 
            deliveryOrderDocuments, 
            items.values());
        DiscountGroupHelper.setApplicableDiscounts(
            newEntries, 
            deliveryOrderDocuments, 
            items.values());
    }

    private static void setItemAliasData(List<dmpl__DeliveryOrderLine__c> newEntries)
    {
        List<Id> itemAliasIds = DocumentHelper.extractIds( DocumentHelper.getObjectsWithNotNull(newEntries, FIELD_SALEDELIVERYLINE_ITEMALIASID), FIELD_SALEDELIVERYLINE_ITEMALIASID);
        Map<Id, dmpl__ItemAlias__c> itemAliases = new Map<Id, dmpl__ItemAlias__c>([SELECT Id, Name, dmpl__ItemId__c, dmpl__SKUId__c, dmpl__PartnerAccountId__c, dmpl__ItemLotTypeId__c FROM dmpl__ItemAlias__c WHERE Id IN : itemAliasIds]);
        for(dmpl__DeliveryOrderLine__c lineEntry : newEntries)
        {
            if(!String.isBlank(lineEntry.dmpl__ItemAliasId__c))
            {
                dmpl__ItemAlias__c currentItemAlias = itemAliases.get(lineEntry.dmpl__ItemAliasId__c);
                if(currentItemAlias != null)
                {
                    if(lineEntry.dmpl__ItemId__c != null && currentItemAlias.dmpl__ItemId__c != null && lineEntry.dmpl__ItemId__c != currentItemAlias.dmpl__ItemId__c)
                        lineEntry.addError(String.format(String.valueOf(System.Label.DocumentValidation_IncorrectItemAlias), new String[]{String.valueOf(FIELD_SALEDELIVERYLINE_ITEMID)})); 
                    if(lineEntry.dmpl__SKUId__c != null && currentItemAlias.dmpl__SKUId__c != null && lineEntry.dmpl__SKUId__c != currentItemAlias.dmpl__SKUId__c)
                        lineEntry.addError(String.format(String.valueOf(System.Label.DocumentValidation_IncorrectItemAlias), new String[]{String.valueOf(FIELD_SALEDELIVERYLINE_SKUID)})); 

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
        List<dmpl__DeliveryOrderLine__c> newEntries, 
        Map<Id, dmpl__Item__c> items){
        // for(dmpl__DeliveryOrderLine__c lineEntry : newEntries){
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
        List<dmpl__DeliveryOrderLine__c> newEntries,
        Map<Id, dmpl__Item__c> items){
        // SecurityHelper.ensureCanWriteField(
        //     'dmpl__InvoiceGroup__c', 
        //     'dmpl__DeliveryOrderLine__c');
        // for(dmpl__DeliveryOrderLine__c lineEntry : newEntries){
        //     dmpl__Item__c currentItem =  items.get(lineEntry.dmpl__ItemId__c);
        //     if(lineEntry.dmpl__InvoiceGroup__c == null && currentItem != null){
        //         lineEntry.dmpl__InvoiceGroup__c = currentItem.dmpl__InvoiceGroup__c;
        //     }
        // }
    }

    private static void setSubscriptionDetails(
        List<dmpl__DeliveryOrderLine__c> newEntries,
        Map<Id, dmpl__Item__c> items){
        // SecurityHelper.ensureCanWriteFields(new string[]{
        //     'dmpl__BillingType__c',
        //     'dmpl__BillingFrequency__c',
        //     'dmpl__ChargeType__c'
        // }, 'dmpl__DeliveryOrderLine__c');
        // for(dmpl__DeliveryOrderLine__c lineEntry : newEntries){
        //         dmpl__Item__c currentItem =  items.get(lineEntry.dmpl__ItemId__c);
        //         if(currentItem != null){
        //             if(lineEntry.dmpl__BillingType__c == null)
        //                 lineEntry.dmpl__BillingType__c = currentItem.dmpl__BillingType__c;
        //             if(lineEntry.dmpl__BillingFrequency__c == null)
        //                 lineEntry.dmpl__BillingFrequency__c = currentItem.dmpl__BillingFrequency__c;
        //             if(lineEntry.dmpl__ChargeType__c == null)
        //                 lineEntry.dmpl__ChargeType__c = currentItem.dmpl__ChargeType__c;
        //         }
        // }
    }

    private static void setOrderDiscount(
        List<dmpl__DeliveryOrderLine__c> newEntries)
    {
        for(dmpl__DeliveryOrderLine__c lineEntry : newEntries)
            lineEntry.dmpl__Discount__c = ((
                lineEntry.dmpl__DeliveryOrderDiscount__c == null || lineEntry.dmpl__DeliveryOrderDiscount__c == 0) ? ((
                    lineEntry.dmpl__Discount__c == null || lineEntry.dmpl__Discount__c == 0) ? 0 : lineEntry.dmpl__Discount__c) :  lineEntry.dmpl__DeliveryOrderDiscount__c/ 100); 
    }

    private static void updateDiscount(
        List<dmpl__DeliveryOrderLine__c> newEntries)
    {
        for(dmpl__DeliveryOrderLine__c lineEntry : newEntries)
            if(lineEntry.dmpl__DiscountAmount__c > 0)
                lineEntry.dmpl__Discount__c = 0;
    }
    
    public static void updateShippedQuantity(List<Id> deliveryLineIds)
    {
        try{
            skipValidations = true;
           
            SecurityHelper.ensureCanReadFields(new string[]{
                'dmpl__DeliveryOrderLineId__c',
                'dmpl__Quantity__c'},
                'dmpl__ShipmentLine__c');
            List<AggregateResult> ffAggregates = 
                [SELECT 
                dmpl__DeliveryOrderLineId__c DeliveryOrderLineId, SUM(dmpl__Quantity__c) TotalQuantity
                FROM dmpl__ShipmentLine__c
                WHERE dmpl__DeliveryOrderLineId__c IN :deliveryLineIds
                WITH SECURITY_ENFORCED
                GROUP BY dmpl__DeliveryOrderLineId__c];

            SecurityHelper.ensureCanReadFields(new string[]{
                'dmpl__ShippedQuantity__c'}, 
                'dmpl__DeliveryOrderLine__c');
            List<dmpl__DeliveryOrderLine__c> orderLinesToUpdate = 
                [SELECT 
                Id, 
                dmpl__ShippedQuantity__c
                FROM dmpl__DeliveryOrderLine__c
                WHERE Id IN :deliveryLineIds];
    
            for(dmpl__DeliveryOrderLine__c orderLine : orderLinesToUpdate){
                for(AggregateResult result : ffAggregates){
                    if(result.get(FIELD_AGG_DELIVERYORDERLINEID) == orderLine.Id){
                        orderLine.dmpl__ShippedQuantity__c = result.get(FIELD_AGG_TOTALQTY) ==null ? 0 : (Decimal)(result.get(FIELD_AGG_TOTALQTY));
                        break;
                    }
                }
            }
            SecurityHelper.ensureCanWriteFields(new string[]{
                'dmpl__ShippedQuantity__c'},
                'dmpl__DeliveryOrderLine__c');
            Update orderLinesToUpdate;
        }finally{
            skipValidations = false;
        }
    }

    private static void validateItem(List<dmpl__DeliveryOrderLine__c> newEntries){
        Map<Id, dmpl__Item__c> items = new Map<Id,dmpl__Item__c>(
            ItemHelper.getCachedItems(
            DocumentHelper.extractIds(
            newEntries, 
            FIELD_SALEDELIVERYLINE_ITEMID)));
        for(dmpl__DeliveryOrderLine__c orderLine : newEntries){
            dmpl__Item__c item = items.get(orderLine.dmpl__ItemId__c);
            // if(orderLine.dmpl__PackageSaleOrderLineId__c == null && item!=null && item.dmpl__OnlySoldInPackage__c){
            //     orderLine.addError(System.Label.PackageError_ItemSoldOnlyInPackage);
            // }
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

    private static List<dmpl__DeliveryOrder__c> queryDeliveryOrderDocument(
        List<ID> deliveryOrderLineIds)
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
                'dmpl__TaxSupplyType__c'
            }, 'dmpl__DeliveryOrder__c');
        return [
            SELECT 
                Id, 
                Name, 
                dmpl__DocumentDate__c,
                dmpl__Status__c,
                dmpl__AccountId__c,
                dmpl__PartnerAccountId__c,
                dmpl__BranchId__c,
                dmpl__TaxSupplyType__c,
                dmpl__PriceAsOnDate__c,
                dmpl__PriceListId__c,
                dmpl__DiscountGroupId__c
            FROM dmpl__DeliveryOrder__c 
            WHERE ID IN : deliveryOrderLineIds ];
    }
}