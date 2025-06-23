public with sharing class BillReturnLineHelper {


    private static Boolean skipValidations = false;
    private static final string OBJECT_BILLRETURN = 'dmpl__BillReturn__c';
    
    private static final string OBJECT_BILLRETURNLINE = 'dmpl__BillReturnLine__c';
    private static final string FIELD_BILLRETURNLINE_BILLRETURNID = 'dmpl__BillReturnId__c';
    private static final string FIELD_BILLRETURNLINE_ASSETID = 'dmpl__AssetId__c';
    private static final string FIELD_BILLRETURNLINE_ITEMID = 'dmpl__ItemId__c';
    private static final string FIELD_BILLRETURNLINE_ITEMLOTID = 'dmpl__ItemLotId__c';
    private static final string FIELD_BILLRETURNLINE_SKUID = 'dmpl__SKUId__c';
    private static final string FIELD_BILLRETURNLINE_INVENTORYLEDGERID = 'dmpl__InventoryLedgerId__c';
    private static final string FIELD_BILLRETURNLINE_ISILPOSTED = 'dmpl__IsILPosted__c';
    private static final string FIELD_BILLRETURNLINE_ISILPOSTINGAPPROVED = 'dmpl__IsILPostingApproved__c';
    private static final string FIELD_BILLRETURNLINE_QUANTITY = 'dmpl__Quantity__c';
    private static final string FIELD_BILLRETURNLINE_GLID = 'dmpl__GeneralLedgerId__c';
    private static final string FIELD_BILLRETURNLINE_GLACCOUNTID = 'dmpl__GLAccountId__c';
    private static final string FIELD_BILLRETURNLINE_ISGLPOSTED = 'dmpl__IsGLPosted__c';
    private static final string FIELD_BILLRETURNLINE_ISGLPOSTINGAPPROVED = 'dmpl__IsGLPostingApproved__c';
    private static final string FIELD_BILLRETURNLINELINE_AMOUNT = 'dmpl__Amount__c';
    
    private static final string FIELD_BILLRETURNLINE_BILLINVOICELINEID = 'dmpl__BillLineId__c';
    private static final string FIELD_BILLRETURNLINE_BILLORDERLINEID = 'dmpl__PurchaseOrderLineId__c';
    private static final string FIELD_BILLRETURNLINE_GOODSRECEIPTLINEID = 'dmpl__GoodsReceiptLineId__c';
    // private static final string FIELD_BILLRETURNLINE_STORAGELOCATIONID = 'dmpl__StorageLocationId__c';
    private static final string FIELD_BILLRETURNLINE_TAXGROUPID = 'dmpl__TaxGroupId__c';
    private static final string FIELD_BILLRETURNLINE_PRICELISTRULEID = 'dmpl__PriceListRuleId__c';
    
    private static final string FIELD_AGG_BILLRETURNLINEID = 'BillReturnLineId';
    private static final string FIELD_AGG_TOTALQTY = 'TotalQuantity';


    private static final string RELATION_BILLRETURN_STATUS = 'dmpl__BillReturnId__r.dmpl__Status__c';

    private static final List<String> LIST_FIELDS_NONEDITABLE = new List<String>{};
    private static final List<String> LIST_FIELDS_SYSTEM = new List<String>{FIELD_BILLRETURNLINE_INVENTORYLEDGERID, FIELD_BILLRETURNLINE_ISILPOSTED,FIELD_BILLRETURNLINE_ISILPOSTINGAPPROVED,FIELD_BILLRETURNLINE_GLID,FIELD_BILLRETURNLINE_ISGLPOSTED,FIELD_BILLRETURNLINE_ISGLPOSTINGAPPROVED};
    private static final List<String> LIST_FIELDS_SOURCEPOULATED = new List<String>{FIELD_BILLRETURNLINE_ITEMID,FIELD_BILLRETURNLINE_ITEMLOTID,FIELD_BILLRETURNLINE_SKUID,FIELD_BILLRETURNLINE_TAXGROUPID};
    private static final List<String> LIST_FIELDS_LOCKEDIFTRANSACTED = new List<String>{FIELD_BILLRETURNLINE_GLACCOUNTID,FIELD_BILLRETURNLINE_ITEMID,FIELD_BILLRETURNLINE_ITEMLOTID,FIELD_BILLRETURNLINE_SKUID,FIELD_BILLRETURNLINE_BILLORDERLINEID,FIELD_BILLRETURNLINE_BILLINVOICELINEID};

    public static void validateData(Boolean isInsert, Boolean isUpdate, Boolean isDelete, List<dmpl__BillReturnLine__c> newEntries, List<dmpl__BillReturnLine__c> oldEntries)
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
                validateItem(newEntries);
                dfsHelper.DocumentStatusRelatedObjectRestrictEdits_New(OBJECT_BILLRETURN, OBJECT_BILLRETURNLINE, RELATION_BILLRETURN_STATUS, newEntries);
            }else if(isUpdate){
                DocumentHelper.validateChangeInSystemFields(LIST_FIELDS_SYSTEM, oldEntries, newEntries);
                DocumentHelper.validateChangeInKeyFields(LIST_FIELDS_NONEDITABLE, oldEntries, newEntries);
                DocumentHelper.validateChangeInSourcePopulatedFields(LIST_FIELDS_SOURCEPOULATED, oldEntries, newEntries, FIELD_BILLRETURNLINE_BILLINVOICELINEID);
                DocumentHelper.validateChangeInLockedIfTransactedFields(LIST_FIELDS_LOCKEDIFTRANSACTED, oldEntries, newEntries, FIELD_BILLRETURNLINE_QUANTITY);
                dfsHelper.DocumentStatusRelatedObjectRestrictEdits_Edit(OBJECT_BILLRETURN, OBJECT_BILLRETURNLINE, RELATION_BILLRETURN_STATUS, oldEntries, newEntries);
            }else if(isDelete){
                // DocumentHelper.validateCanBeDeleted(oldEntries, FIELD_BILLRETURNLINE_QUANTITY);
                dfsHelper.DocumentStatusRelatedObjectRestrictEdits_Delete(OBJECT_BILLRETURN, OBJECT_BILLRETURNLINE, RELATION_BILLRETURN_STATUS, oldEntries);
            }
        } catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }

    public static void postData(Boolean isInsert, Boolean isUpdate, Boolean isDelete, List<dmpl__BillReturnLine__c> newEntries, List<dmpl__BillReturnLine__c> oldEntries)
    {
        try{
            if(isInsert){
                setItemData(newEntries);
                TaxHelper.setLinesTaxes(
                    newEntries);
                List<dmpl__BillReturnLine__c> modifiedObjects = DocumentHelper.getPostedObjects(FIELD_BILLRETURNLINE_ISILPOSTINGAPPROVED, oldEntries, newEntries);
                if(modifiedObjects.Size() > 0){
                    List<dmpl__BillReturnLine__c> returnLines = DocumentHelper.getObjectsByFilter(modifiedObjects, 'dmpl__ReturnType__c','Damaged');
                    if(returnLines.size() > 0)
                        InventoryLedgerHelper.createLedger(InventoryLedgerTypeEnums.Damaged, 'dmpl__BillReturnId__c', 'dmpl__BillReturn__c', isInsert, isDelete, isUpdate, isDelete ? modifiedObjects : oldEntries, isInsert || isUpdate ? modifiedObjects : newEntries);

                    returnLines = DocumentHelper.getObjectsByFilter(modifiedObjects, 'dmpl__ReturnType__c','Excess');
                    if(returnLines.size() > 0)
                        InventoryLedgerHelper.createLedger(InventoryLedgerTypeEnums.Excess, 'dmpl__BillReturnId__c', 'dmpl__BillReturn__c', isInsert, isDelete, isUpdate, isDelete ? modifiedObjects : oldEntries, isInsert || isUpdate ? modifiedObjects : newEntries);
                    
                    returnLines = DocumentHelper.getObjectsByFilter(modifiedObjects, 'dmpl__ReturnType__c','Shortage');
                    if(returnLines.size() > 0)
                        InventoryLedgerHelper.createLedger(InventoryLedgerTypeEnums.Shortage, 'dmpl__BillReturnId__c', 'dmpl__BillReturn__c', isInsert, isDelete, isUpdate, isDelete ? modifiedObjects : oldEntries, isInsert || isUpdate ? modifiedObjects : newEntries);

                    returnLines = DocumentHelper.getObjectsByFilter(modifiedObjects, 'dmpl__ReturnType__c','Expired');
                    if(returnLines.size() > 0)
                        InventoryLedgerHelper.createLedger(InventoryLedgerTypeEnums.Expired, 'dmpl__BillReturnId__c', 'dmpl__BillReturn__c', isInsert, isDelete, isUpdate, isDelete ? modifiedObjects : oldEntries, isInsert || isUpdate ? modifiedObjects : newEntries);
                        
                    returnLines = DocumentHelper.getObjectsWithNull(modifiedObjects, 'dmpl__ReturnType__c');
                    if(returnLines.size() > 0)
                        InventoryLedgerHelper.createLedger(InventoryLedgerTypeEnums.PurchaseReturn, 'dmpl__BillReturnId__c', 'dmpl__BillReturn__c', isInsert, isDelete, isUpdate, isDelete ? modifiedObjects : oldEntries, isInsert || isUpdate ? modifiedObjects : newEntries);
                }
            }else if(isUpdate || isDelete){
                List<dmpl__BillReturnLine__c> modifiedObjects = DocumentHelper.getPostedObjects(FIELD_BILLRETURNLINE_ISILPOSTINGAPPROVED, oldEntries, newEntries);
                if(modifiedObjects.Size() > 0){
                    List<dmpl__BillReturnLine__c> returnLines = DocumentHelper.getObjectsByFilter(modifiedObjects, 'dmpl__ReturnType__c','Damaged');
                    if(returnLines.size() > 0){
                        InventoryLedgerHelper.createLedger(InventoryLedgerTypeEnums.Damaged, 'dmpl__BillReturnId__c', 'dmpl__BillReturn__c', isInsert, isDelete, isUpdate, isDelete ? modifiedObjects : oldEntries, isInsert || isUpdate ? modifiedObjects : newEntries);
                        InventoryLedgerHelper.createLedger(InventoryLedgerTypeEnums.PurchaseReturn, 'dmpl__BillReturnId__c', 'dmpl__BillReturn__c', isInsert, isDelete, isUpdate, isDelete ? modifiedObjects : oldEntries, isInsert || isUpdate ? modifiedObjects : newEntries);
                    }
    
                    returnLines = DocumentHelper.getObjectsByFilter(modifiedObjects, 'dmpl__ReturnType__c','Excess');
                    if(returnLines.size() > 0){
                        InventoryLedgerHelper.createLedger(InventoryLedgerTypeEnums.Excess, 'dmpl__BillReturnId__c', 'dmpl__BillReturn__c', isInsert, isDelete, isUpdate, isDelete ? modifiedObjects : oldEntries, isInsert || isUpdate ? modifiedObjects : newEntries);
                    }
                    
                    returnLines = DocumentHelper.getObjectsByFilter(modifiedObjects, 'dmpl__ReturnType__c','Shortage');
                    if(returnLines.size() > 0){
                        InventoryLedgerHelper.createLedger(InventoryLedgerTypeEnums.Shortage, 'dmpl__BillReturnId__c', 'dmpl__BillReturn__c', isInsert, isDelete, isUpdate, isDelete ? modifiedObjects : oldEntries, isInsert || isUpdate ? modifiedObjects : newEntries);
                        InventoryLedgerHelper.createLedger(InventoryLedgerTypeEnums.PurchaseReturn, 'dmpl__BillReturnId__c', 'dmpl__BillReturn__c', isInsert, isDelete, isUpdate, isDelete ? modifiedObjects : oldEntries, isInsert || isUpdate ? modifiedObjects : newEntries);
                    }

                    returnLines = DocumentHelper.getObjectsByFilter(modifiedObjects, 'dmpl__ReturnType__c','Expired');
                    if(returnLines.size() > 0){
                        InventoryLedgerHelper.createLedger(InventoryLedgerTypeEnums.Expired, 'dmpl__BillReturnId__c', 'dmpl__BillReturn__c', isInsert, isDelete, isUpdate, isDelete ? modifiedObjects : oldEntries, isInsert || isUpdate ? modifiedObjects : newEntries);
                        InventoryLedgerHelper.createLedger(InventoryLedgerTypeEnums.PurchaseReturn, 'dmpl__BillReturnId__c', 'dmpl__BillReturn__c', isInsert, isDelete, isUpdate, isDelete ? modifiedObjects : oldEntries, isInsert || isUpdate ? modifiedObjects : newEntries);
                    }

                        
                    returnLines = DocumentHelper.getObjectsWithNull(modifiedObjects, 'dmpl__ReturnType__c');
                    if(returnLines.size() > 0){
                        InventoryLedgerHelper.createLedger(InventoryLedgerTypeEnums.PurchaseReturn, 'dmpl__BillReturnId__c', 'dmpl__BillReturn__c', isInsert, isDelete, isUpdate, isDelete ? modifiedObjects : oldEntries, isInsert || isUpdate ? modifiedObjects : newEntries);
                    }
                }
            }

            if(isUpdate){
                List<dmpl__BillReturnLine__c> modifiedObject = DocumentHelper.getModifiedNewObjects(
                    FIELD_BILLRETURNLINE_PRICELISTRULEID, 
                        oldEntries, 
                        newEntries);
                if(modifiedObject.size()>0){
                    Map<Id, dmpl__Item__c> items = new Map<Id,dmpl__Item__c>(
                    ItemHelper.getCachedItems(
                        DocumentHelper.extractIds(
                            modifiedObject, 
                            FIELD_BILLRETURNLINE_ITEMID)));
                    List<dmpl__BillReturn__c> billReturnDocuments = queryBillReturnDocument(
                        DocumentHelper.extractIds(
                            modifiedObject, 
                            FIELD_BILLRETURNLINE_BILLRETURNID));
                    PriceListHelper.setApplicablePrices(
                        modifiedObject, 
                        billReturnDocuments, 
                        items.values(), 
                        DocumentHelper.extractIds(
                                modifiedObject, 
                                FIELD_BILLRETURNLINE_PRICELISTRULEID),
                                    'dmpl__BillReturnId__c');
                }

                List<dmpl__BillReturnLine__c> modifiedObjects = DocumentHelper.getModifiedNewObjects(
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
                    FIELD_BILLRETURNLINE_ITEMID)));
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
                //BillReturnTaxHelper.deleteApplicableTaxes(oldEntries);
            }
        }catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }

    public static void afterPostData(Boolean isInsert, Boolean isDelete, Boolean isUpdate, List<dmpl__BillReturnLine__c> oldEntries, List<dmpl__BillReturnLine__c> newEntries)
    {
        try{
        if(isDelete){
            BillLineHelper.updateBillReturnQuantity(DocumentHelper.extractIds(oldEntries, FIELD_BILLRETURNLINE_BILLINVOICELINEID));
            PurchaseOrderLineHelper.updateBillReturnQuantity(DocumentHelper.extractIds(oldEntries, FIELD_BILLRETURNLINE_BILLORDERLINEID));
            GoodReceiptLineHelper.updateBillReturnQuantity(DocumentHelper.extractIds(oldEntries, FIELD_BILLRETURNLINE_GOODSRECEIPTLINEID));
            TaxHelper.deleteLinesTaxes(oldEntries);
        } else if(isInsert){
            BillLineHelper.updateBillReturnQuantity(DocumentHelper.extractIds(newEntries, FIELD_BILLRETURNLINE_BILLINVOICELINEID));
            PurchaseOrderLineHelper.updateBillReturnQuantity(DocumentHelper.extractIds(newEntries, FIELD_BILLRETURNLINE_BILLORDERLINEID));
            GoodReceiptLineHelper.updateBillReturnQuantity(DocumentHelper.extractIds(newEntries, FIELD_BILLRETURNLINE_GOODSRECEIPTLINEID));
            TaxHelper.createLinesTaxes(
                    isInsert, 
                    newEntries);
        } else if(isUpdate){
            List<dmpl__BillReturnLine__c> modifiedObjects = DocumentHelper.getModifiedNewObjects(FIELD_BILLRETURNLINE_QUANTITY, oldEntries, newEntries);
            if(modifiedObjects.size()>0){
                BillLineHelper.updateBillReturnQuantity(DocumentHelper.extractIds(modifiedObjects, FIELD_BILLRETURNLINE_BILLINVOICELINEID));
            }
            modifiedObjects = DocumentHelper.getModifiedNewObjects(FIELD_BILLRETURNLINE_QUANTITY, oldEntries, newEntries);
            if(modifiedObjects.size()>0){
                PurchaseOrderLineHelper.updateBillReturnQuantity(DocumentHelper.extractIds(modifiedObjects, FIELD_BILLRETURNLINE_BILLORDERLINEID));
            }
            modifiedObjects = DocumentHelper.getModifiedNewObjects(FIELD_BILLRETURNLINE_QUANTITY, oldEntries, newEntries);
            if(modifiedObjects.size()>0){
                GoodReceiptLineHelper.updateBillReturnQuantity(DocumentHelper.extractIds(modifiedObjects, FIELD_BILLRETURNLINE_GOODSRECEIPTLINEID));
            }

            modifiedObjects = DocumentHelper.getModifiedNewObjects(
                new string[]{
                    FIELD_BILLRETURNLINE_TAXGROUPID,
                    FIELD_BILLRETURNLINE_ITEMID, 
                    FIELD_BILLRETURNLINE_SKUID,
                    FIELD_BILLRETURNLINELINE_AMOUNT}, 
                oldEntries, 
                newEntries);
            if(modifiedObjects.size()>0){
                TaxHelper.createLinesTaxes(
                        isInsert,
                        modifiedObjects);
            }
        }
    } catch (Exception error) {
        ExceptionLogHelper.logException(error);
        throw error;
    }
    }

    public static void approveBillReturnLines(List<dmpl__BillReturn__c> returns){
        List<dmpl__BillReturnLine__c> returnLines = queryReturnLines(returns);
        for(dmpl__BillReturn__c billReturn : returns){
            approveReturnLines(DocumentHelper.getObjects(returnLines, FIELD_BILLRETURNLINE_BILLRETURNID, billReturn.Id));
        }
        try {
            skipValidations = true;
            SecurityHelper.ensureCanWriteFields(new string[]{'dmpl__IsILPostingApproved__c','dmpl__IsGLPostingApproved__c'}, 'dmpl__BillReturnLine__c');
            Update returnLines;
            
        } finally {
            skipValidations = false;
        }
    }

    public static void postReturnLines(List<dmpl__BillReturn__c> modifiedDocuments)
    {
        List<dmpl__BillReturnLine__c> returnLines = queryReturnLines(modifiedDocuments);
        SecurityHelper.ensureCanWriteField('dmpl__IsILPostingApproved__c', 'dmpl__BillReturnLine__c');
        for(dmpl__BillReturnLine__c returnLine : returnLines){
            returnLine.dmpl__IsILPostingApproved__c = true;
        }

        try {
            skipValidations = true;
            SecurityHelper.ensureCanWriteFields(new string[]{'dmpl__IsILPosted__c','dmpl__IsILPostingApproved__c'}, 'dmpl__BillReturnLine__c');
            update returnLines;            
        } finally {
            skipValidations = false;
        }
    }

    public static CreateRelatedResult postIL(Id hostId){
        return postReturnLineInternal(queryReturnLines(new List<Id>{hostId}));
    }

    public static CreateRelatedResult postIL(List<SourceObjectInfo> childObjectsInfo, Id hostId){
        return postReturnLineInternal(queryReturnLinesForLineIds(SourceObjectInfo.extractIds(childObjectsInfo)));
    }
    
	@TestVisible
    private static CreateRelatedResult postReturnLineInternal(List<dmpl__BillReturnLine__c> billReturnLines)
    {
        SecurityHelper.ensureCanWriteField('dmpl__IsILPostingApproved__c', 'dmpl__BillReturnLine__c');
        for(dmpl__BillReturnLine__c returnLine : billReturnLines){
            returnLine.dmpl__IsILPostingApproved__c = true;
        }

        try {
            skipValidations = true;
            SecurityHelper.ensureCanWriteFields(new string[]{'dmpl__IsILPosted__c','dmpl__IsILPostingApproved__c'}, 'dmpl__BillReturnLine__c');
            return CreateRelatedResult.InitFrom(Database.update(billReturnLines));        
        } finally {
            skipValidations = false;
        }
    }

    public static void updateSaleDeliveryQuantity(List<Id> billReturnLineIds)
    {
        try{
            skipValidations = true;
           
            SecurityHelper.ensureCanReadFields(new string[]{
                'dmpl__BillReturnLineId__c',
                'dmpl__Quantity__c'
            }, 'dmpl__DeliveryOrderLine__c');
            List<AggregateResult> ffAggregates = 
                [SELECT 
                    dmpl__BillReturnLineId__c BillReturnLineId, 
                    SUM(dmpl__Quantity__c) TotalQuantity
                FROM 
                    dmpl__DeliveryOrderLine__c
                WHERE 
                    dmpl__BillReturnLineId__c IN :billReturnLineIds
                WITH SECURITY_ENFORCED
                GROUP BY 
                    dmpl__BillReturnLineId__c];

            SecurityHelper.ensureCanReadFields(new string[]{
                'dmpl__DeliveryQuantity__c'
            }, 'dmpl__BillReturnLine__c');
            List<dmpl__BillReturnLine__c> billReturnLinesToUpdate = 
                [SELECT 
                    Id, 
                    dmpl__DeliveryQuantity__c
                FROM 
                    dmpl__BillReturnLine__c
                WHERE 
                    Id IN :billReturnLineIds];
    
            for(dmpl__BillReturnLine__c billReturnLine : billReturnLinesToUpdate){
                for(AggregateResult result : ffAggregates){
                    if(result.get(FIELD_AGG_BILLRETURNLINEID) == billReturnLine.Id){
                        billReturnLine.dmpl__DeliveryQuantity__c 
                            = result.get(FIELD_AGG_TOTALQTY) ==null ? 
                                0 : (Decimal)(result.get(FIELD_AGG_TOTALQTY));
                        break;
                    }
                }
            }
            SecurityHelper.ensureCanWriteFields(new string[]{
                'dmpl__DeliveryQuantity__c'
            }, 'dmpl__SaleOrderLine__c');
            Update billReturnLinesToUpdate;
        }finally{
            skipValidations = false;
        }
    }

    public static void markAsClaimed(List<dmpl__BillReturnLine__c> billReturnLines)
    {
        for(dmpl__BillReturnLine__c billReturnLine : billReturnLines)
            billReturnLine.dmpl__IsClaimed__c = true;

        if(billReturnLines.size() > 0)
        {
            try{
                skipValidations = true;
                SecurityHelper.ensureCanWriteFields(new string[]{'dmpl__IsClaimed__c'}, 'dmpl__BillReturnLine__c');
                update billReturnLines;
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

    private static void validateItem(List<dmpl__BillReturnLine__c> newEntries){
        Map<Id, dmpl__Item__c> items = new Map<Id,dmpl__Item__c>(ItemHelper.getCachedItems(DocumentHelper.extractIds(newEntries, FIELD_BILLRETURNLINE_ITEMID)));
        for(dmpl__BillReturnLine__c orderLine : newEntries){
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

    private static void approveReturnLines(List<dmpl__BillReturnLine__c> documentReturnLines)
    {
        SecurityHelper.ensureCanWriteField('dmpl__IsGLPostingApproved__c', 'dmpl__BillReturnLine__c');
        for(dmpl__BillReturnLine__c returnLine : documentReturnLines){
            returnLine.dmpl__IsGLPostingApproved__c = true;
        }

    }

    private static void setItemData(List<dmpl__BillReturnLine__c> newEntries)
    {
        Map<Id, dmpl__Item__c> items = new Map<Id,dmpl__Item__c>(
        ItemHelper.getCachedItems(DocumentHelper.extractIds(newEntries, FIELD_BILLRETURNLINE_ITEMID)));
        List<dmpl__BillReturn__c> billReturnDocuments = queryBillReturnDocument(DocumentHelper.extractIds(newEntries, FIELD_BILLRETURNLINE_BILLRETURNID));
        ItemHelper.setQuantityFromUOM(
            newEntries, 
            null,
            items);
        TaxGroupHelper.setApplicableTaxGroups(newEntries, billReturnDocuments, items.values());
        PriceListHelper.setApplicablePrices(
            newEntries, 
            billReturnDocuments, 
            items.values(),
            false);
    }

    private static List<dmpl__BillReturnLine__c> queryReturnLines(List<dmpl__BillReturn__c> documents){

        SecurityHelper.ensureCanReadFields(new string[]{'dmpl__BillReturnId__c','dmpl__IsILPostingApproved__c','dmpl__IsGLPostingApproved__c','dmpl__IsILPosted__c'}, 'dmpl__BillReturnLine__c');
        return [SELECT ID, dmpl__BillReturnId__c, dmpl__IsILPostingApproved__c, dmpl__IsGLPostingApproved__c,dmpl__IsILPosted__c
                FROM dmpl__BillReturnLine__c
                WHERE dmpl__BillReturnId__c IN :DocumentHelper.extractIds(documents)];
    }
    
	@Testvisible
    private static List<dmpl__BillReturnLine__c> queryReturnLines(List<Id> documentIds){

        SecurityHelper.ensureCanReadFields(new string[]{'dmpl__BillReturnId__c','dmpl__IsILPostingApproved__c','dmpl__IsGLPostingApproved__c','dmpl__IsILPosted__c'}, 'dmpl__BillReturnLine__c');
        return [SELECT ID, dmpl__BillReturnId__c, dmpl__IsILPostingApproved__c, dmpl__IsGLPostingApproved__c,dmpl__IsILPosted__c
                FROM dmpl__BillReturnLine__c
                WHERE dmpl__BillReturnId__c IN :documentIds];
    }

    private static List<dmpl__BillReturnLine__c> queryReturnLinesForLineIds(List<Id> lineIds){

        SecurityHelper.ensureCanReadFields(new string[]{'dmpl__BillReturnId__c','dmpl__IsILPostingApproved__c','dmpl__IsGLPostingApproved__c','dmpl__IsILPosted__c'}, 'dmpl__BillReturnLine__c');
        return [SELECT ID, dmpl__BillReturnId__c, dmpl__IsILPostingApproved__c, dmpl__IsGLPostingApproved__c,dmpl__IsILPosted__c
                FROM dmpl__BillReturnLine__c
                WHERE Id IN :lineIds];
    }

    private static List<dmpl__BillReturn__c> queryBillReturnDocument(List<ID> billReturnLineIds)
    {
        SecurityHelper.ensureCanReadFields(new string[]{'dmpl__DocumentDate__c','dmpl__TaxSupplyType__c','dmpl__BranchId__c','dmpl__PriceListId__c','dmpl__Status__c','dmpl__PartnerAccountId__c'}, 'dmpl__BillReturn__c');
        return [
            SELECT 
                Id, 
                Name, 
                dmpl__DocumentDate__c,
                dmpl__Status__c,
                dmpl__PartnerAccountId__c,
                dmpl__BranchId__c,
                dmpl__PriceListId__c,
                dmpl__TaxSupplyType__c,
                dmpl__PriceListRuleId__c,
                dmpl__PriceAsOnDate__c,
                dmpl__SupplierAccountId__c
            FROM dmpl__BillReturn__c 
            WHERE ID IN : billReturnLineIds ];
    }
}