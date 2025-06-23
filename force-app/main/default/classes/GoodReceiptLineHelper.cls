public with sharing class GoodReceiptLineHelper {

    private static Boolean skipValidations = false;

    private static final string OBJECT_GOODSRECEIPT = 'dmpl__GoodsReceipt__c';
    private static final string OBJECT_GOODSRECEIPTLINE = 'dmpl__GoodsReceiptLine__c';
    private static final string FIELD_GOODSRECEIPTID = 'dmpl__GoodsReceiptId__c';

    private static final String FIELD_GOODSRECEIPTLINE_FULFILLMENTORDERLINEID = 'dmpl__FulfillmentOrderLineId__c';
    private static final String FIELD_GOODSRECEIPTLINE_INSPECTIONQUANTITY = 'dmpl__InspectionQuantity__c';
    private static final String FIELD_GOODSRECEIPTLINE_INVENTORYLEDGERID = 'dmpl__InventoryLedgerId__c';
    private static final String FIELD_GOODSRECEIPTLINE_INVENTORYLEDGERDAMAGEDID = 'dmpl__InventoryLedgerDamagedId__c';
    private static final String FIELD_GOODSRECEIPTLINE_INVENTORYLEDGERINSPECTIONID = 'dmpl__InventoryLedgerInspectionId__c';
    private static final String FIELD_GOODSRECEIPTLINE_INVENTORYLEDGERINSPECTIONADJUSTMENTID = 'dmpl__InventoryLedgerInspectionAdjustmentId__c';
    private static final String FIELD_GOODSRECEIPTLINE_INVOICEQUANTITY = 'dmpl__InvoiceQuantity__c';
    private static final String FIELD_GOODSRECEIPTLINE_ITEMID = 'dmpl__ItemId__c';
    private static final String FIELD_GOODSRECEIPTLINE_ITEMLOTID = 'dmpl__ItemLotId__c';
    private static final String FIELD_GOODSRECEIPTLINE_SKUID = 'dmpl__SKUId__c';
    private static final String FIELD_GOODSRECEIPTLINE_ORDEREDQUANTITY = 'dmpl__OrderedQuantity__c';
    private static final String FIELD_GOODSRECEIPTLINE_PENDINGINVOICEQUANTITY = 'dmpl__PendingInvoiceQuantity__c';
    private static final String FIELD_GOODSRECEIPTLINE_PURCHASEORDERLINEID = 'dmpl__PurchaseOrderLineId__c';
    private static final String FIELD_GOODSRECEIPTLINE_SHIPMENTLINEID = 'dmpl__ShipmentLineId__c';
    private static final String FIELD_GOODSRECEIPTLINE_RECEIVEDQUANTITY = 'dmpl__ReceivedQuantity__c';
    private static final String FIELD_GOODSRECEIPTLINE_RETURNEDQUANTITY = 'dmpl__ReturnedQuantity__c';
    private static final String FIELD_GOODSRECEIPTLINE_SERIALNUMBER = 'dmpl__SerialNumber__c';
    private static final String FIELD_GOODSRECEIPTLINE_STORAGEQUANTITY = 'dmpl__ShortageQuantity__c';
    private static final String FIELD_GOODSRECEIPTLINE_STORAGELOCATIONID = 'dmpl__StorageLocationId__c';
    private static final String FIELD_GOODSRECEIPTLINE_SUPPLIERQUANTITY = 'dmpl__SupplierQuantity__c';
    private static final String FIELD_GOODSRECEIPTLINE_TAXGROUPID = 'dmpl__TaxGroupId__c';
    private static final String FIELD_GOODSRECEIPTLINE_UNITCOST = 'dmpl__UnitCost__c';
    private static final String FIELD_GOODSRECEIPTLINE_ISAPPROVED = 'dmpl__IsApproved__c';
    private static final String FIELD_PURCHASERETURN_GOODSRECEIPTLINEID = 'dmpl__GoodsReceiptLineId__c';
    private static final string RELATION_GOODSRECEIPT_STATUS = 'dmpl__GoodsReceipt__r.dmpl__Status__c';
    private static final string FIELD_AGG_GOODSRECEIPTLINEID = 'GoodsReceiptLineId';
    private static final string FIELD_AGG_TOTALQTY = 'TotalQuantity';

    private static final List<String> LIST_FIELDS_NONEDITABLE = new List<String>{
        FIELD_GOODSRECEIPTLINE_FULFILLMENTORDERLINEID, 
        FIELD_GOODSRECEIPTLINE_INVENTORYLEDGERINSPECTIONID, 
        FIELD_GOODSRECEIPTLINE_INVENTORYLEDGERINSPECTIONADJUSTMENTID, 
        FIELD_GOODSRECEIPTLINE_ITEMID, 
        FIELD_GOODSRECEIPTLINE_SKUID
    };

    private static final List<String> LIST_FIELDS_SYSTEM = new List<String>{

    };

    private static final List<String> LIST_FIELDS_LOCKEDIFTRANSACTED = new List<String>{
        FIELD_GOODSRECEIPTLINE_ITEMID,
        FIELD_GOODSRECEIPTLINE_SKUID
    };

    private static final List<String> LIST_FIELDS_NEGATIVEANDZERONOTALLOWED = new List<String>{
    };
    
    private static final List<String> LIST_FIELDS_NEGATIVENOTALLOWED = new List<String>{
        'dmpl__ClaimableQuantity__c', 
        'dmpl__DamagedQuantity__c', 
        'dmpl__ExcessQuantity__c', 
        'dmpl__InspectionQuantity__c', 
        'dmpl__InvoiceQuantity__c', 
        'dmpl__OrderedQuantity__c', 
        'dmpl__PendingInvoiceQuantity__c', 
        'dmpl__PipelineQuantity__c', 
        'dmpl__ReceivedQuantity__c', 
        'dmpl__ReturnedQuantity__c', 
        'dmpl__ShortageQuantity__c', 
        'dmpl__StartedInspectionQuantity__c', 
        'dmpl__SupplierQuantity__c', 
        'dmpl__PendingInspectionQuantity__c'
    };

    public static void validateData(Boolean isInsert, Boolean isUpdate, Boolean isDelete, List<dmpl__GoodsReceiptLine__c> newEntries, List<dmpl__GoodsReceiptLine__c> oldEntries)
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
            }
            if(skipValidations){
                return;
            }
            DocumentStatusDFSHelper dfsHelper = new DocumentStatusDFSHelper();
            if(isInsert){
                validateItem(newEntries);
                DocumentHelper.validateChangeInSystemFields(LIST_FIELDS_SYSTEM, newEntries);
                dfsHelper.DocumentStatusRelatedObjectRestrictEdits_New(OBJECT_GOODSRECEIPT, OBJECT_GOODSRECEIPTLINE, RELATION_GOODSRECEIPT_STATUS, newEntries);
            }else if(isUpdate){
                DocumentHelper.validateChangeInSystemFields(LIST_FIELDS_SYSTEM, oldEntries, newEntries);
                DocumentHelper.validateChangeInKeyFields(LIST_FIELDS_NONEDITABLE, oldEntries, newEntries);
                dfsHelper.DocumentStatusRelatedObjectRestrictEdits_Edit(OBJECT_GOODSRECEIPT, OBJECT_GOODSRECEIPTLINE, RELATION_GOODSRECEIPT_STATUS, oldEntries, newEntries);
            }else if(isDelete){
                DocumentHelper.validateCanBeDeleted(oldEntries, FIELD_GOODSRECEIPTLINE_RECEIVEDQUANTITY);
                dfsHelper.DocumentStatusRelatedObjectRestrictEdits_Delete(OBJECT_GOODSRECEIPT, OBJECT_GOODSRECEIPTLINE, RELATION_GOODSRECEIPT_STATUS, oldEntries);
            }
        } catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }

    public static void postData(Boolean isInsert, Boolean isUpdate, Boolean isDelete, List<dmpl__GoodsReceiptLine__c> newEntries, List<dmpl__GoodsReceiptLine__c> oldEntries)
    {
        try{
            setItemData(
                newEntries);
            List<dmpl__GoodsReceiptLine__c> modifiedObjects = DocumentHelper.getApprovedObjects(FIELD_GOODSRECEIPTLINE_ISAPPROVED, oldEntries, newEntries);
            if(modifiedObjects.size() > 0)
            {
                InventoryLedgerHelper.createLedger(InventoryLedgerTypeEnums.Inward, 'dmpl__GoodsReceiptId__c', 'dmpl__GoodsReceipt__c', isInsert, isDelete, isUpdate, oldEntries, modifiedObjects);
                InventoryLedgerHelper.createLedger(InventoryLedgerTypeEnums.Damaged, 'dmpl__GoodsReceiptId__c', 'dmpl__GoodsReceipt__c', isInsert, isDelete, isUpdate, oldEntries, modifiedObjects);
                InventoryLedgerHelper.createLedger(InventoryLedgerTypeEnums.Shortage, 'dmpl__GoodsReceiptId__c', 'dmpl__GoodsReceipt__c', isInsert, isDelete, isUpdate, oldEntries, modifiedObjects);
                InventoryLedgerHelper.createLedger(InventoryLedgerTypeEnums.Excess, 'dmpl__GoodsReceiptId__c', 'dmpl__GoodsReceipt__c', isInsert, isDelete, isUpdate, oldEntries, modifiedObjects);
            }

            if(isUpdate || isDelete) {
                ItemLotHelper.updateOrDeleteItemLotsFromReceiptLines(isUpdate, isDelete, DocumentHelper.getObjectsWithNotNull(newEntries, FIELD_GOODSRECEIPTLINE_ITEMLOTID), DocumentHelper.getObjectsWithNotNull(oldEntries, FIELD_GOODSRECEIPTLINE_ITEMLOTID));
            }
            if(isUpdate){
                   modifiedObjects = DocumentHelper.getModifiedNewObjects(
                        new string[]{
                            'dmpl__ReceivedQuantity__c',
                            'dmpl__UOM__c',
                            'dmpl__UOM1__c', 
                            'dmpl__UOMQuantity__c',
                            'dmpl__UOMQuantity1__c'
                        }, 
                        oldEntries, 
                        newEntries); 
                    Map<Id, dmpl__Item__c> items = new Map<Id,dmpl__Item__c>(
                        ItemHelper.getCachedItems(
                        DocumentHelper.extractIds(
                            newEntries, 
                            'dmpl__ItemId__c')));
                            if(modifiedObjects.size()>0){
                            ItemHelper.setQuantityFromUOM(
                                newEntries, 
                                oldEntries, 
                                items,
                                'dmpl__ReceivedQuantity__c',
                                null);
                            }  
            }
        } catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }

    public static  void afterPostData(Boolean isInsert, Boolean isUpdate, Boolean isDelete, List<dmpl__GoodsReceiptLine__c> newEntries, List<dmpl__GoodsReceiptLine__c> oldEntries)
    {
        try{
            if(isInsert) {
                PurchaseOrderLineHelper.updatePurchaseReceiptQuantity(DocumentHelper.extractIds(newEntries, FIELD_GOODSRECEIPTLINE_PURCHASEORDERLINEID));
                ShipmentLineHelper.updateReceiptQuantity(DocumentHelper.extractIds(newEntries, FIELD_GOODSRECEIPTLINE_SHIPMENTLINEID));
             }
             else if(isUpdate)
             {
                List<Id> modifiedObjectIds = DocumentHelper.getModifiedNewObjectIds(FIELD_GOODSRECEIPTLINE_SUPPLIERQUANTITY, FIELD_GOODSRECEIPTLINE_PURCHASEORDERLINEID, oldEntries, newEntries);
                if(modifiedObjectIds.size()>0){
                    PurchaseOrderLineHelper.updatePurchaseReceiptQuantity(modifiedObjectIds);
                }

                modifiedObjectIds = DocumentHelper.getModifiedNewObjectIds(FIELD_GOODSRECEIPTLINE_SUPPLIERQUANTITY, FIELD_GOODSRECEIPTLINE_SHIPMENTLINEID, oldEntries, newEntries);
                if(modifiedObjectIds.size()>0){
                    ShipmentLineHelper.updateReceiptQuantity(modifiedObjectIds);
                }
             }
             else if(isDelete)
             {
                PurchaseOrderLineHelper.updatePurchaseReceiptQuantity(DocumentHelper.extractIds(oldEntries, FIELD_GOODSRECEIPTLINE_PURCHASEORDERLINEID)); 
                ShipmentLineHelper.updateReceiptQuantity(DocumentHelper.extractIds(newEntries, FIELD_GOODSRECEIPTLINE_SHIPMENTLINEID));

             }
        } catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }

    public static void receiveReceiptLinesFromGoodsReceipt(List<dmpl__GoodsReceipt__c> goodsReceipts){
        receiveReceiptLinesFromGoodsReceipt((List<dmpl__GoodsReceiptLine__c>)DocumentHelper.getObjectsByFilter(queryGoodsReceiptLines(DocumentHelper.extractIds(goodsReceipts), new List<ID>()), 'dmpl__IsApproved__c', false));
    }

    public static void markAsClaimed(List<dmpl__GoodsReceiptLine__c> goodsReceiptLines)
    {
        for(dmpl__GoodsReceiptLine__c goodsReceiptLine : goodsReceiptLines)
            goodsReceiptLine.dmpl__IsClaimed__c = true;

        if(goodsReceiptLines.size() > 0)
        {
            try{
                SecurityHelper.ensureCanWriteField('dmpl__IsClaimed__c', 'dmpl__GoodsReceiptLine__c');
                skipValidations = true;
                update goodsReceiptLines;
            }
            catch(Exception error)
            {
                ExceptionLogHelper.logException(error);
                throw error;
            }
            finally
            {
                skipValidations = false;
            }
        }
    }
   
    Private static void setItemData(List<dmpl__GoodsReceiptLine__c>newEntries){
        Map<Id, dmpl__Item__c> items = new Map<Id,dmpl__Item__c>(
            ItemHelper.getCachedItems(
                DocumentHelper.extractIds(
                    newEntries, 
                    FIELD_GOODSRECEIPTLINE_ITEMID)));
                ItemHelper.setQuantityFromUOM(
                    newEntries, 
                    null,
                    items,
                    'dmpl__ReceivedQuantity__c',
                    null);

    }
    public static void updatePurchaseReturnQuantity(List<Id> goodReceiptLineIds)
    {
        try{
            skipValidations = true;
             
            SecurityHelper.ensureCanReadFields(new string[]{
                'dmpl__GoodsReceiptLineId__c',
                'dmpl__Quantity__c'
            }, 'dmpl__PurchaseReturnLine__c');
            List<AggregateResult> ffAggregates = 
                [SELECT 
                dmpl__GoodsReceiptLineId__c GoodsReceiptLineId, 
                    SUM(dmpl__Quantity__c) TotalQuantity
                FROM 
                    dmpl__PurchaseReturnLine__c
                WHERE 
                dmpl__GoodsReceiptLineId__c IN :goodReceiptLineIds
                WITH SECURITY_ENFORCED
                GROUP BY dmpl__GoodsReceiptLineId__c];
             
            SecurityHelper.ensureCanReadFields(new string[]{
                'dmpl__ReturnedQuantity__c'
            }, 'dmpl__GoodsReceiptLine__c');
            List<dmpl__GoodsReceiptLine__c> orderLinesToUpdate = 
                [SELECT 
                    Id, 
                    dmpl__ReturnedQuantity__c
                FROM 
                dmpl__GoodsReceiptLine__c
                WHERE 
                    Id IN :goodReceiptLineIds];
    
            for(dmpl__GoodsReceiptLine__c orderLine : orderLinesToUpdate){
                for(AggregateResult result : ffAggregates){
                    if(result.get(FIELD_AGG_GOODSRECEIPTLINEID) == orderLine.Id){
                        orderLine.dmpl__ReturnedQuantity__c 
                            = result.get(FIELD_AGG_TOTALQTY) ==null ? 
                                0 : (Decimal)(result.get(FIELD_AGG_TOTALQTY));
                        break;
                    }
                }
            }
            SecurityHelper.ensureCanWriteFields(new string[]{
                'dmpl__ReturnedQuantity__c'
            }, 'dmpl__GoodsReceiptLine__c');
            Update orderLinesToUpdate;
        }finally{
            skipValidations = false;
        }
    }

    public static void updateBillReturnQuantity(List<Id> goodReceiptLineIds)
    {
        try{
            skipValidations = true;
             
            SecurityHelper.ensureCanReadFields(new string[]{
                'dmpl__GoodsReceiptLineId__c',
                'dmpl__Quantity__c'
            }, 'dmpl__BillReturnLine__c');
            List<AggregateResult> ffAggregates = 
                [SELECT 
                dmpl__GoodsReceiptLineId__c GoodsReceiptLineId, 
                    SUM(dmpl__Quantity__c) TotalQuantity
                FROM 
                    dmpl__BillReturnLine__c
                WHERE 
                dmpl__GoodsReceiptLineId__c IN :goodReceiptLineIds
                WITH SECURITY_ENFORCED
                GROUP BY dmpl__GoodsReceiptLineId__c];
             
            SecurityHelper.ensureCanReadFields(new string[]{
                'dmpl__ReturnedQuantity__c'
            }, 'dmpl__GoodsReceiptLine__c');
            List<dmpl__GoodsReceiptLine__c> orderLinesToUpdate = 
                [SELECT 
                    Id, 
                    dmpl__ReturnedQuantity__c
                FROM 
                dmpl__GoodsReceiptLine__c
                WHERE 
                    Id IN :goodReceiptLineIds];
    
            for(dmpl__GoodsReceiptLine__c orderLine : orderLinesToUpdate){
                for(AggregateResult result : ffAggregates){
                    if(result.get(FIELD_AGG_GOODSRECEIPTLINEID) == orderLine.Id){
                        orderLine.dmpl__ReturnedQuantity__c 
                            = result.get(FIELD_AGG_TOTALQTY) ==null ? 
                                0 : (Decimal)(result.get(FIELD_AGG_TOTALQTY));
                        break;
                    }
                }
            }
            SecurityHelper.ensureCanWriteFields(new string[]{
                'dmpl__ReturnedQuantity__c'
            }, 'dmpl__GoodsReceiptLine__c');
            Update orderLinesToUpdate;
        }finally{
            skipValidations = false;
        }
    }
    
    @testVisible
    public static CreateRelatedResult postIL(Id goodsReceiptId){
        return postGoodsReceiptLines(queryGoodsReceiptLines(new List<Id>{goodsReceiptId}));
    }

    @testVisible
    public static CreateRelatedResult postIL(List<SourceObjectInfo> orderLinesInfo, Id goodsReceiptId){
        return postGoodsReceiptLines(queryGoodsReceiptLinesForLines(SourceObjectInfo.extractIds(orderLinesInfo)));
    }

    public static void postGoodsReceiptLines(List<dmpl__GoodsReceipt__c> modifiedDocs){
        dmpl__CreateRelatedSetting__mdt setting = CreateRelatedSettingHelper.getCreateRelatedSettings(
            'dmpl__GoodsReceipt__c',
            'Post IL');
        if(setting == null){
            postGoodsReceiptLines(queryGoodsReceiptLines(DocumentHelper.extractIds(modifiedDocs)));
        }else {
            for(dmpl__GoodsReceipt__c goodsReceipt : modifiedDocs){
                DocumentSelectorController.releaseDocumentDirect(setting.Id, goodsReceipt.Id);
            }
        }
    }

    public static CreateRelatedResult postGoodsReceiptLines(List<dmpl__GoodsReceiptLine__c> goodsReceiptLines)
    {
        SecurityHelper.ensureCanWriteField('dmpl__IsILPostingApproved__c', 'dmpl__GoodsReceiptLine__c');
        SecurityHelper.ensureCanWriteField('dmpl__IsApproved__c', 'dmpl__GoodsReceiptLine__c');
        for(dmpl__GoodsReceiptLine__c goodsReceiptLine : goodsReceiptLines){
            goodsReceiptLine.dmpl__IsILPostingApproved__c = true;
            goodsReceiptLine.dmpl__IsApproved__c = true;
            goodsReceiptLine.dmpl__IsILPosted__c = true;
        }
        ItemLotHelper.createItemLotFromReceiptLines(goodsReceiptLines);
        try {
            skipValidations = true;
            SecurityHelper.ensureCanWriteFields(new string[]{'dmpl__IsILPosted__c','dmpl__IsILPostingApproved__c'}, 'dmpl__GoodsReceiptLine__c');
            return CreateRelatedResult.InitFrom(Database.update(goodsReceiptLines));            
        } finally {
            skipValidations = false;
        }
    }

    public static void receiveLinesFromReceiveGoodsBatch(List<dmpl__GoodsReceiptLine__c> goodsReceiptLines)
    {
        receiveReceiptLinesFromGoodsReceipt(goodsReceiptLines);
    }

    private static void receiveReceiptLinesFromGoodsReceipt(List<dmpl__GoodsReceiptLine__c> goodsReceiptLines){
        if(goodsReceiptLines.size() == 0){
            throw new DMPLException(String.format(String.valueOf(System.Label.Generic_EmptyActionParam), new String[]{dmpl__GoodsReceiptLine__c.class.getName()}));
        }
        
        if(goodsReceiptLines.size() >0){
            Savepoint sp = Database.setSavepoint();
            SecurityHelper.ensureCanWriteField('dmpl__IsILPostingApproved__c', 'dmpl__GoodsReceiptLine__c');
            SecurityHelper.ensureCanWriteField('dmpl__IsApproved__c', 'dmpl__GoodsReceiptLine__c');
            for(dmpl__GoodsReceiptLine__c goodsReceiptLine : goodsReceiptLines){
                goodsReceiptLine.dmpl__IsILPostingApproved__c = true;
                goodsReceiptLine.dmpl__IsApproved__c = true;
            }
            ItemLotHelper.createItemLotFromReceiptLines(goodsReceiptLines);
            try {
            skipValidations = true;
            SecurityHelper.ensureCanWriteFields(new String[]{'dmpl__IsApproved__c','dmpl__UnitCost__c','dmpl__InventoryLedgerInspectionId__c','dmpl__ItemLotId__c','dmpl__OrderedQuantity__c','dmpl__ReceivedQuantity__c','dmpl__StorageLocationId__c','dmpl__SupplierQuantity__c','dmpl__ComponentNumber__c','dmpl__ItemId__c','dmpl__MRP__c','dmpl__SKUId__c'}, 'dmpl__GoodsReceiptLine__c');
            update goodsReceiptLines;
            } catch (Exception e) {
            	Database.rollback(sp);
            	throw e;
            } finally{
            	skipValidations = false;
           }
        }
    }

    public static void updatePurchaseInvoiceQuantity(List<Id> goodsReceiptLineIds)
    {
        try{
            skipValidations = true;
            SecurityHelper.ensureCanReadFields(new string[]{'dmpl__GoodsReceiptLineId__c','dmpl__Quantity__c'}, 'dmpl__BillLine__c');
            List<AggregateResult> ffAggregates = 
                [SELECT dmpl__GoodsReceiptLineId__c GoodsReceiptLineId, SUM(dmpl__Quantity__c) TotalQuantity
                FROM dmpl__BillLine__c
                WHERE dmpl__GoodsReceiptLineId__c IN :goodsReceiptLineIds
                WITH SECURITY_ENFORCED
                GROUP BY dmpl__GoodsReceiptLineId__c];
    
            SecurityHelper.ensureCanReadFields(new string[]{'dmpl__InvoiceQuantity__c'}, 'dmpl__GoodsReceiptLine__c');
            List<dmpl__GoodsReceiptLine__c> orderLinesToUpdate = 
                [SELECT Id, dmpl__InvoiceQuantity__c
                FROM dmpl__GoodsReceiptLine__c
                WHERE Id IN :goodsReceiptLineIds];
    
            for(dmpl__GoodsReceiptLine__c orderLine : orderLinesToUpdate){
                for(AggregateResult result : ffAggregates){
                    if(result.get(FIELD_AGG_GOODSRECEIPTLINEID) == orderLine.Id){
                        orderLine.dmpl__InvoiceQuantity__c = result.get(FIELD_AGG_TOTALQTY) ==null ? 0 : (Decimal)(result.get(FIELD_AGG_TOTALQTY));
                        break;
                    }
                }
            }
            SecurityHelper.ensureCanWriteFields(new string[]{'dmpl__InvoiceQuantity__c'}, 'dmpl__GoodsReceiptLine__c');      
            Update orderLinesToUpdate;
        }finally{
            skipValidations = false;
        }
    }

    public static void updateDamagedQuantityFromInspection(List<Id> goodsReceiptLineIds)
    {
        try{
            skipValidations = true;
            SecurityHelper.ensureCanReadFields(new string[]{'dmpl__GoodsReceiptLineId__c','dmpl__DamagedQuantity__c'}, 'dmpl__InspectionLine__c');
            List<AggregateResult> ffAggregates = 
                [SELECT dmpl__ReceiptLineId__c GoodsReceiptLineId, SUM(dmpl__DamagedQuantity__c) TotalQuantity
                FROM dmpl__InspectionLine__c
                WHERE dmpl__ReceiptLineId__c IN :goodsReceiptLineIds
                WITH SECURITY_ENFORCED
                GROUP BY dmpl__ReceiptLineId__c];
    
            SecurityHelper.ensureCanReadFields(new string[]{'dmpl__DamagedQuantity__c'}, 'dmpl__GoodsReceiptLine__c');
            List<dmpl__GoodsReceiptLine__c> orderLinesToUpdate = 
                [SELECT Id, dmpl__DamagedQuantity__c
                FROM dmpl__GoodsReceiptLine__c
                WHERE Id IN :goodsReceiptLineIds];
    
            for(dmpl__GoodsReceiptLine__c orderLine : orderLinesToUpdate){
                for(AggregateResult result : ffAggregates){
                    if(result.get(FIELD_AGG_GOODSRECEIPTLINEID) == orderLine.Id){
                        orderLine.dmpl__DamagedQuantity__c = (orderLine.dmpl__DamagedQuantity__c  == null ? 0 : orderLine.dmpl__DamagedQuantity__c) + (result.get(FIELD_AGG_TOTALQTY) ==null ? 0 : (Decimal)(result.get(FIELD_AGG_TOTALQTY)));
                        break;
                    }
                }
            }
            SecurityHelper.ensureCanWriteFields(new string[]{'dmpl__DamagedQuantity__c'}, 'dmpl__GoodsReceiptLine__c');      
            Update orderLinesToUpdate;
        }finally{
            skipValidations = false;
        }
    }

    public static void updateStartedInspectionQuantityFromInspection(List<Id> goodsReceiptLineIds)
    {
        try{
            if(goodsReceiptLineIds.size() == 0)
                return;

            skipValidations = true;
            SecurityHelper.ensureCanReadFields(new string[]{'dmpl__GoodsReceiptLineId__c','dmpl__ReceivedQuantity__c'}, 'dmpl__InspectionLine__c');
            List<AggregateResult> ffAggregates = 
                [SELECT dmpl__ReceiptLineId__c GoodsReceiptLineId, SUM(dmpl__ReceivedQuantity__c) TotalQuantity
                FROM dmpl__InspectionLine__c
                WHERE dmpl__ReceiptLineId__c IN :goodsReceiptLineIds
                WITH SECURITY_ENFORCED
                GROUP BY dmpl__ReceiptLineId__c];
    
            SecurityHelper.ensureCanReadFields(new string[]{'dmpl__StartedInspectionQuantity__c'}, 'dmpl__GoodsReceiptLine__c');
            List<dmpl__GoodsReceiptLine__c> orderLinesToUpdate = 
                [SELECT Id, dmpl__StartedInspectionQuantity__c
                FROM dmpl__GoodsReceiptLine__c
                WHERE Id IN :goodsReceiptLineIds];
    
            for(dmpl__GoodsReceiptLine__c orderLine : orderLinesToUpdate){
                for(AggregateResult result : ffAggregates){
                    if(result.get(FIELD_AGG_GOODSRECEIPTLINEID) == orderLine.Id){
                        orderLine.dmpl__StartedInspectionQuantity__c = (result.get(FIELD_AGG_TOTALQTY) ==null ? 0 : (Decimal)(result.get(FIELD_AGG_TOTALQTY)));
                        break;
                    }
                }
            }
            SecurityHelper.ensureCanWriteFields(new string[]{'dmpl__InspectionQuantity__c'}, 'dmpl__GoodsReceiptLine__c');      
            Update orderLinesToUpdate;
        }finally{
            skipValidations = false;
        }
    }

    private static void validateItem(List<dmpl__GoodsReceiptLine__c> newEntries){
        Map<Id, dmpl__Item__c> items = new Map<Id,dmpl__Item__c>(ItemHelper.getCachedItems(DocumentHelper.extractIds(newEntries, FIELD_GOODSRECEIPTLINE_ITEMID)));
        for(dmpl__GoodsReceiptLine__c orderLine : newEntries){
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

    private static List<dmpl__GoodsReceiptLine__c> queryGoodsReceiptLines(List<ID> documentIds)
    {
        SecurityHelper.ensureCanReadFields(new string[]{'dmpl__IsILPosted__c','dmpl__IsILPostingApproved__c'}, 'dmpl__GoodsReceiptLine__c');
        return ([SELECT id,
            dmpl__IsILPosted__c,
            dmpl__IsILPostingApproved__c,
            Name,
            dmpl__IsApproved__c,
            dmpl__UnitCost__c,
            dmpl__InventoryLedgerInspectionId__c,
            dmpl__ItemLotId__c,
            dmpl__ItemLotId__r.Name,
            dmpl__OrderedQuantity__c,
            dmpl__ReceivedQuantity__c,
            dmpl__GoodsReceiptId__c,
            dmpl__SKUId__c,
            dmpl__ItemLotTypeId__c,
            dmpl__SerialNumber__c,
            dmpl__StorageLocationId__c,
            dmpl__SupplierQuantity__c,
            dmpl__ItemId__c,
            dmpl__ComponentNumber__c,
            dmpl__MRP__c,
            dmpl__ReturnedQuantity__c 
            FROM dmpl__GoodsReceiptLine__c WHERE dmpl__GoodsReceiptId__c IN :documentIds]);
    }

    private static List<dmpl__GoodsReceiptLine__c> queryGoodsReceiptLinesForLines(List<ID> lineIds)
    {
        SecurityHelper.ensureCanReadFields(new string[]{'dmpl__IsILPosted__c','dmpl__IsILPostingApproved__c'}, 'dmpl__GoodsReceiptLine__c');
        return ([SELECT id,
            dmpl__IsILPosted__c,
            dmpl__IsILPostingApproved__c,
            Name,
            dmpl__IsApproved__c,
            dmpl__UnitCost__c,
            dmpl__InventoryLedgerInspectionId__c,
            dmpl__ItemLotId__c,
            dmpl__ItemLotId__r.Name,
            dmpl__OrderedQuantity__c,
            dmpl__ReceivedQuantity__c,
            dmpl__GoodsReceiptId__c,
            dmpl__SKUId__c,
            dmpl__ItemLotTypeId__c,
            dmpl__SerialNumber__c,
            dmpl__StorageLocationId__c,
            dmpl__SupplierQuantity__c,
            dmpl__ItemId__c,
            dmpl__ComponentNumber__c,
            dmpl__MRP__c,
            dmpl__ReturnedQuantity__c 
            FROM dmpl__GoodsReceiptLine__c WHERE Id IN :lineIds]);
    }

    private static List<dmpl__GoodsReceiptLine__c> queryGoodsReceiptLines(List<Id> goodsReceiptIds, List<Id> goodsReceiptLineIds)
    {

        SecurityHelper.ensureCanReadFields(new string[]{'dmpl__IsApproved__c','dmpl__UnitCost__c','dmpl__InventoryLedgerInspectionId__c','dmpl__ItemLotId__c','dmpl__OrderedQuantity__c','dmpl__ReceivedQuantity__c','dmpl__GoodsReceiptId__c','dmpl__StorageLocationId__c','dmpl__SupplierQuantity__c','dmpl__ComponentNumber__c','dmpl__ItemId__c','dmpl__MRP__c','dmpl__SKUId__c','dmpl__ItemLotTypeId__c','dmpl__ReturnedQuantity__c'}, 'dmpl__GoodsReceiptLine__c');
        return [SELECT ID,
        Name,
        dmpl__IsApproved__c,
        dmpl__UnitCost__c,
        dmpl__InventoryLedgerInspectionId__c,
        dmpl__ItemLotId__c,
        dmpl__ItemLotId__r.Name,
        dmpl__OrderedQuantity__c,
        dmpl__ReceivedQuantity__c,
        dmpl__GoodsReceiptId__c,
        dmpl__SKUId__c,
        dmpl__ItemLotTypeId__c,
        dmpl__SerialNumber__c,
        dmpl__StorageLocationId__c,
        dmpl__SupplierQuantity__c,
        dmpl__ItemId__c,
        dmpl__ComponentNumber__c,
        dmpl__MRP__c,
        dmpl__ReturnedQuantity__c  
        FROM
        dmpl__GoodsReceiptLine__c WHERE dmpl__GoodsReceiptId__c IN : goodsReceiptIds OR ID IN : goodsReceiptLineIds];
    }

    @testVisible
    private static List<dmpl__PurchaseReturnLine__c> queryPurchaseReturnLines(List<ID> purchaseReturnIds){
        SecurityHelper.ensureCanReadFields(new string[]{'dmpl__GoodsReceiptLineId__c','dmpl__Quantity__c','dmpl__PurchaseReturnId__c'}, 'dmpl__PurchaseReturnLine__c');
        return [SELECT Id, Name, dmpl__GoodsReceiptLineId__c, dmpl__Quantity__c, dmpl__PurchaseReturnId__c FROM dmpl__PurchaseReturnLine__c WHERE dmpl__PurchaseReturnId__c IN : purchaseReturnIds];
    }
}