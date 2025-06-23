public with sharing class PurchaseReturnLineHelper {


    private static Boolean skipValidations = false;
    private static final string OBJECT_PURCHASERETURN = 'dmpl__PurchaseReturn__c';
    
    private static final string OBJECT_PURCHASERETURNLINE = 'dmpl__PurchaseReturnLine__c';
    private static final string FIELD_PURCHASERETURNLINE_PURCHASERETURNID = 'dmpl__PurchaseReturnId__c';
    private static final string FIELD_PURCHASERETURNLINE_ASSETID = 'dmpl__AssetId__c';
    private static final string FIELD_PURCHASERETURNLINE_ITEMID = 'dmpl__ItemId__c';
    private static final string FIELD_PURCHASERETURNLINE_ITEMLOTID = 'dmpl__ItemLotId__c';
    private static final string FIELD_PURCHASERETURNLINE_SKUID = 'dmpl__SKUId__c';
    private static final string FIELD_PURCHASERETURNLINE_INVENTORYLEDGERID = 'dmpl__InventoryLedgerId__c';
    private static final string FIELD_PURCHASERETURNLINE_ISILPOSTED = 'dmpl__IsILPosted__c';
    private static final string FIELD_PURCHASERETURNLINE_ISILPOSTINGAPPROVED = 'dmpl__IsILPostingApproved__c';
    private static final string FIELD_PURCHASERETURNLINE_QUANTITY = 'dmpl__Quantity__c';
    private static final string FIELD_PURCHASERETURNLINE_GLID = 'dmpl__GeneralLedgerId__c';
    private static final string FIELD_PURCHASERETURNLINE_GLACCOUNTID = 'dmpl__GLAccountId__c';
    private static final string FIELD_PURCHASERETURNLINE_ISGLPOSTED = 'dmpl__IsGLPosted__c';
    private static final string FIELD_PURCHASERETURNLINE_ISGLPOSTINGAPPROVED = 'dmpl__IsGLPostingApproved__c';
    
    private static final string FIELD_PURCHASERETURNLINE_PURCHASEINVOICELINEID = 'dmpl__BillLineId__c';
    private static final string FIELD_PURCHASERETURNLINE_PURCHASEORDERLINEID = 'dmpl__PurchaseOrderLineId__c';
    private static final string FIELD_PURCHASERETURNLINE_GOODSRECEIPTLINEID = 'dmpl__GoodsReceiptLineId__c';
    // private static final string FIELD_PURCHASERETURNLINE_STORAGELOCATIONID = 'dmpl__StorageLocationId__c';
    private static final string FIELD_PURCHASERETURNLINE_TAXGROUPID = 'dmpl__TaxGroupId__c';

    private static final string RELATION_PURCHASERETURN_STATUS = 'dmpl__PurchaseReturnId__r.dmpl__Status__c';

    private static final List<String> LIST_FIELDS_NONEDITABLE = new List<String>{};
    private static final List<String> LIST_FIELDS_SYSTEM = new List<String>{FIELD_PURCHASERETURNLINE_INVENTORYLEDGERID, FIELD_PURCHASERETURNLINE_ISILPOSTED,FIELD_PURCHASERETURNLINE_ISILPOSTINGAPPROVED,FIELD_PURCHASERETURNLINE_GLID,FIELD_PURCHASERETURNLINE_ISGLPOSTED,FIELD_PURCHASERETURNLINE_ISGLPOSTINGAPPROVED};
    private static final List<String> LIST_FIELDS_SOURCEPOULATED = new List<String>{FIELD_PURCHASERETURNLINE_ITEMID,FIELD_PURCHASERETURNLINE_ITEMLOTID,FIELD_PURCHASERETURNLINE_SKUID,FIELD_PURCHASERETURNLINE_TAXGROUPID};
    private static final List<String> LIST_FIELDS_LOCKEDIFTRANSACTED = new List<String>{FIELD_PURCHASERETURNLINE_GLACCOUNTID,FIELD_PURCHASERETURNLINE_ITEMID,FIELD_PURCHASERETURNLINE_ITEMLOTID,FIELD_PURCHASERETURNLINE_SKUID,FIELD_PURCHASERETURNLINE_PURCHASEORDERLINEID,FIELD_PURCHASERETURNLINE_PURCHASEINVOICELINEID};

    public static void validateData(Boolean isInsert, Boolean isUpdate, Boolean isDelete, List<dmpl__PurchaseReturnLine__c> newEntries, List<dmpl__PurchaseReturnLine__c> oldEntries)
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
            dfsHelper.DocumentStatusRelatedObjectRestrictEdits_New(OBJECT_PURCHASERETURN, OBJECT_PURCHASERETURNLINE, RELATION_PURCHASERETURN_STATUS, newEntries);
        }else if(isUpdate){
            DocumentHelper.validateChangeInSystemFields(LIST_FIELDS_SYSTEM, oldEntries, newEntries);
            DocumentHelper.validateChangeInKeyFields(LIST_FIELDS_NONEDITABLE, oldEntries, newEntries);
            DocumentHelper.validateChangeInSourcePopulatedFields(LIST_FIELDS_SOURCEPOULATED, oldEntries, newEntries, FIELD_PURCHASERETURNLINE_PURCHASEINVOICELINEID);
            DocumentHelper.validateChangeInLockedIfTransactedFields(LIST_FIELDS_LOCKEDIFTRANSACTED, oldEntries, newEntries, FIELD_PURCHASERETURNLINE_QUANTITY);
            dfsHelper.DocumentStatusRelatedObjectRestrictEdits_Edit(OBJECT_PURCHASERETURN, OBJECT_PURCHASERETURNLINE, RELATION_PURCHASERETURN_STATUS, oldEntries, newEntries);
        }else if(isDelete){
            // DocumentHelper.validateCanBeDeleted(oldEntries, FIELD_PURCHASERETURNLINE_QUANTITY);
            dfsHelper.DocumentStatusRelatedObjectRestrictEdits_Delete(OBJECT_PURCHASERETURN, OBJECT_PURCHASERETURNLINE, RELATION_PURCHASERETURN_STATUS, oldEntries);
        }
    } catch (Exception error) {
        ExceptionLogHelper.logException(error);
        throw error;
    }
    }

    public static void postData(Boolean isInsert, Boolean isUpdate, Boolean isDelete, List<dmpl__PurchaseReturnLine__c> newEntries, List<dmpl__PurchaseReturnLine__c> oldEntries)
    {
        try{
            List<dmpl__PurchaseReturnLine__c> modifiedObjects = DocumentHelper.getPostedObjects(FIELD_PURCHASERETURNLINE_ISILPOSTINGAPPROVED, oldEntries, newEntries);
            if(modifiedObjects.Size() > 0)
            {
                List<dmpl__SaleReturnLine__c> returnLines = DocumentHelper.getObjectsByFilter(modifiedObjects, 'dmpl__ReturnType__c','Damaged');
                if(returnLines.size() > 0)
                    InventoryLedgerHelper.createLedger(InventoryLedgerTypeEnums.PurchaseReturn, 'dmpl__PurchaseReturnId__c', 'dmpl__PurchaseReturn__c', isInsert, isDelete, isUpdate, isDelete ? modifiedObjects : oldEntries, isInsert || isUpdate ? modifiedObjects : newEntries);

                returnLines = DocumentHelper.getObjectsByFilter(modifiedObjects, 'dmpl__ReturnType__c','Shortage');
                if(returnLines.size() > 0)
                    InventoryLedgerHelper.createLedger(InventoryLedgerTypeEnums.PurchaseReturn, 'dmpl__PurchaseReturnId__c', 'dmpl__PurchaseReturn__c', isInsert, isDelete, isUpdate, isDelete ? modifiedObjects : oldEntries, isInsert || isUpdate ? modifiedObjects : newEntries);
                    
                returnLines = DocumentHelper.getObjectsByFilter(modifiedObjects, 'dmpl__ReturnType__c','Excess');
                if(returnLines.size() > 0)
                    InventoryLedgerHelper.createLedger(InventoryLedgerTypeEnums.PurchaseReturn, 'dmpl__PurchaseReturnId__c', 'dmpl__PurchaseReturn__c', isInsert, isDelete, isUpdate, isDelete ? modifiedObjects : oldEntries, isInsert || isUpdate ? modifiedObjects : newEntries);
                
                returnLines = DocumentHelper.getObjectsWithNull(modifiedObjects, 'dmpl__ReturnType__c');
                if(returnLines.size() > 0)
                    InventoryLedgerHelper.createLedger(InventoryLedgerTypeEnums.PurchaseReturn, 'dmpl__PurchaseReturnId__c', 'dmpl__PurchaseReturn__c', isInsert, isDelete, isUpdate, isDelete ? modifiedObjects : oldEntries, isInsert || isUpdate ? modifiedObjects : newEntries);
            }
        } catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }

    public static void afterPostData(Boolean isInsert, Boolean isDelete, Boolean isUpdate, List<dmpl__PurchaseReturnLine__c> oldEntries, List<dmpl__PurchaseReturnLine__c> newEntries)
    {
        try{
        if(isDelete){
            BillLineHelper.updatePurchaseReturnQuantity(DocumentHelper.extractIds(oldEntries, FIELD_PURCHASERETURNLINE_PURCHASEINVOICELINEID));
            PurchaseOrderLineHelper.updatePurchaseReturnQuantity(DocumentHelper.extractIds(oldEntries, FIELD_PURCHASERETURNLINE_PURCHASEORDERLINEID));
            GoodReceiptLineHelper.updatePurchaseReturnQuantity(DocumentHelper.extractIds(oldEntries, FIELD_PURCHASERETURNLINE_GOODSRECEIPTLINEID));
        } else if(isInsert){
            BillLineHelper.updatePurchaseReturnQuantity(DocumentHelper.extractIds(newEntries, FIELD_PURCHASERETURNLINE_PURCHASEINVOICELINEID));
            PurchaseOrderLineHelper.updatePurchaseReturnQuantity(DocumentHelper.extractIds(newEntries, FIELD_PURCHASERETURNLINE_PURCHASEORDERLINEID));
            GoodReceiptLineHelper.updatePurchaseReturnQuantity(DocumentHelper.extractIds(newEntries, FIELD_PURCHASERETURNLINE_GOODSRECEIPTLINEID));
        } else if(isUpdate){
            List<dmpl__PurchaseReturnLine__c> modifiedObjects = DocumentHelper.getModifiedNewObjects(FIELD_PURCHASERETURNLINE_QUANTITY, oldEntries, newEntries);
            if(modifiedObjects.size()>0){
                BillLineHelper.updatePurchaseReturnQuantity(DocumentHelper.extractIds(modifiedObjects, FIELD_PURCHASERETURNLINE_PURCHASEINVOICELINEID));
            }
            modifiedObjects = DocumentHelper.getModifiedNewObjects(FIELD_PURCHASERETURNLINE_QUANTITY, oldEntries, newEntries);
            if(modifiedObjects.size()>0){
                PurchaseOrderLineHelper.updatePurchaseReturnQuantity(DocumentHelper.extractIds(modifiedObjects, FIELD_PURCHASERETURNLINE_PURCHASEORDERLINEID));
            }
            modifiedObjects = DocumentHelper.getModifiedNewObjects(FIELD_PURCHASERETURNLINE_QUANTITY, oldEntries, newEntries);
            if(modifiedObjects.size()>0){
                GoodReceiptLineHelper.updatePurchaseReturnQuantity(DocumentHelper.extractIds(modifiedObjects, FIELD_PURCHASERETURNLINE_GOODSRECEIPTLINEID));
            }
        }
    } catch (Exception error) {
        ExceptionLogHelper.logException(error);
        throw error;
    }
    }

    public static void approvePurchaseReturnLines(List<dmpl__PurchaseReturn__c> returns){
        List<dmpl__PurchaseReturnLine__c> returnLines = queryReturnLines(returns);
        for(dmpl__PurchaseReturn__c purchaseReturn : returns){
            approveReturnLines(DocumentHelper.getObjects(returnLines, FIELD_PURCHASERETURNLINE_PURCHASERETURNID, purchaseReturn.Id));
        }
        try {
            skipValidations = true;
            SecurityHelper.ensureCanWriteFields(new string[]{'dmpl__IsILPostingApproved__c','dmpl__IsGLPostingApproved__c'}, 'dmpl__PurchaseReturnLine__c');
            Update returnLines;
            
        } finally {
            skipValidations = false;
        }
    }

    public static void postReturnLines(List<dmpl__PurchaseReturn__c> modifiedDocuments)
    {
        List<dmpl__PurchaseReturnLine__c> returnLines = queryReturnLines(modifiedDocuments);
        SecurityHelper.ensureCanWriteField('dmpl__IsILPostingApproved__c', 'dmpl__PurchaseReturnLine__c');
        for(dmpl__PurchaseReturnLine__c returnLine : returnLines){
            returnLine.dmpl__IsILPostingApproved__c = true;
        }

        try {
            skipValidations = true;
            SecurityHelper.ensureCanWriteFields(new string[]{'dmpl__IsILPosted__c','dmpl__IsILPostingApproved__c'}, 'dmpl__PurchaseReturnLine__c');
            update returnLines;            
        } finally {
            skipValidations = false;
        }
    }

    public static void markAsClaimed(List<dmpl__PurchaseReturnLine__c> purchaseReturnLines)
    {
        for(dmpl__PurchaseReturnLine__c purchaseReturnLine : purchaseReturnLines)
            purchaseReturnLine.dmpl__IsClaimed__c = true;

        if(purchaseReturnLines.size() > 0)
        {
            try{
                skipValidations = true;
                SecurityHelper.ensureCanWriteFields(new string[]{'dmpl__IsClaimed__c'}, 'dmpl__PurchaseReturnLine__c');
                update purchaseReturnLines;
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

    private static void validateItem(List<dmpl__PurchaseReturnLine__c> newEntries){
        Map<Id, dmpl__Item__c> items = new Map<Id,dmpl__Item__c>(ItemHelper.getCachedItems(DocumentHelper.extractIds(newEntries, FIELD_PURCHASERETURNLINE_ITEMID)));
        for(dmpl__PurchaseReturnLine__c orderLine : newEntries){
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

    private static void approveReturnLines(List<dmpl__PurchaseReturnLine__c> documentReturnLines)
    {
        SecurityHelper.ensureCanWriteField('dmpl__IsGLPostingApproved__c', 'dmpl__PurchaseReturnLine__c');
        for(dmpl__PurchaseReturnLine__c returnLine : documentReturnLines){
            returnLine.dmpl__IsGLPostingApproved__c = true;
        }
    }

    private static List<dmpl__PurchaseReturnLine__c> queryReturnLines(List<dmpl__PurchaseReturn__c> documents){

        SecurityHelper.ensureCanReadFields(new string[]{'dmpl__PurchaseReturnId__c','dmpl__IsILPostingApproved__c','dmpl__IsGLPostingApproved__c','dmpl__IsILPosted__c'}, 'dmpl__PurchaseReturnLine__c');
        return [SELECT ID, dmpl__PurchaseReturnId__c, dmpl__IsILPostingApproved__c, dmpl__IsGLPostingApproved__c,dmpl__IsILPosted__c
                FROM dmpl__PurchaseReturnLine__c
                WHERE dmpl__PurchaseReturnId__c IN :DocumentHelper.extractIds(documents)];
    }
}