public with sharing class SaleReturnLineHelper {

    private static Boolean skipValidations = false;
    private static final string OBJECT_SALERETURN = 'dmpl__SaleReturn__c';
    
    private static final string OBJECT_SALERETURNLINE = 'dmpl__SaleReturnLine__c';
    private static final string FIELD_SALERETURNLINE_SALERETURNID = 'dmpl__SaleReturnId__c';
    private static final string FIELD_SALERETURNLINE_ASSETID = 'dmpl__AssetId__c';
    private static final string FIELD_SALERETURNLINE_ITEMID = 'dmpl__ItemId__c';
    private static final string FIELD_SALERETURNLINE_ITEMLOTID = 'dmpl__ItemLotId__c';
    private static final string FIELD_SALERETURNLINE_SKUID = 'dmpl__SKUId__c';
    private static final string FIELD_SALERETURNLINE_INVENTORYLEDGERID = 'dmpl__InventoryLedgerId__c';
    private static final string FIELD_SALERETURNLINE_ISILPOSTED = 'dmpl__IsILPosted__c';
    private static final string FIELD_SALERETURNLINE_ISILPOSTINGAPPROVED = 'dmpl__IsILPostingApproved__c';
    private static final string FIELD_SALERETURNLINE_QUANTITY = 'dmpl__Quantity__c';
    private static final string FIELD_SALERETURNLINE_GLID = 'dmpl__GeneralLedgerId__c';
    private static final string FIELD_SALERETURNLINE_GLACCOUNTID = 'dmpl__GLAccountId__c';
    private static final string FIELD_SALERETURNLINE_ISGLPOSTED = 'dmpl__IsGLPosted__c';
    private static final string FIELD_SALERETURNLINE_ISGLPOSTINGAPPROVED = 'dmpl__IsGLPostingApproved__c';
    private static final string FIELD_SALERETURNLINELINE_AMOUNT = 'dmpl__Amount__c';
    
    private static final string FIELD_SALERETURNLINE_SALEINVOICELINEID = 'dmpl__SaleInvoiceLineId__c';
    private static final string FIELD_SALERETURNLINE_DELIVERYORDERLINEID = 'dmpl__DeliveryOrderLineId__c';
    private static final string FIELD_SALERETURNLINE_SALEORDERLINEID = 'dmpl__SaleOrderLineId__c';
    private static final string FIELD_SALERETURNLINE_STORAGELOCATIONID = 'dmpl__StorageLocationId__c';
    private static final string FIELD_SALERETURNLINE_TAXGROUPID = 'dmpl__TaxGroupId__c';
    private static final string FIELD_SALERETURNLINE_PRICELISTRULEID = 'dmpl__PriceListRuleId__c';

    private static final string RELATION_SALERETURN_STATUS = 'dmpl__SaleReturnId__r.dmpl__Status__c';

    private static final List<String> LIST_FIELDS_NONEDITABLE = new List<String>{};
    private static final List<String> LIST_FIELDS_SYSTEM = new List<String>{
        FIELD_SALERETURNLINE_INVENTORYLEDGERID, 
        FIELD_SALERETURNLINE_ISILPOSTED,
        FIELD_SALERETURNLINE_ISILPOSTINGAPPROVED,
        FIELD_SALERETURNLINE_GLID,
        FIELD_SALERETURNLINE_ISGLPOSTED,
        FIELD_SALERETURNLINE_ISGLPOSTINGAPPROVED};
    private static final List<String> LIST_FIELDS_SOURCEPOULATED = new List<String>{
        FIELD_SALERETURNLINE_ITEMID,
        FIELD_SALERETURNLINE_ITEMLOTID,
        FIELD_SALERETURNLINE_SKUID,
        FIELD_SALERETURNLINE_TAXGROUPID};
    private static final List<String> LIST_FIELDS_LOCKEDIFTRANSACTED = new List<String>{
        FIELD_SALERETURNLINE_STORAGELOCATIONID,
        FIELD_SALERETURNLINE_GLACCOUNTID,
        FIELD_SALERETURNLINE_ASSETID,
        FIELD_SALERETURNLINE_ITEMID,
        FIELD_SALERETURNLINE_ITEMLOTID,
        FIELD_SALERETURNLINE_SKUID,
        FIELD_SALERETURNLINE_SALEORDERLINEID,
        FIELD_SALERETURNLINE_SALEINVOICELINEID};


    public static void validateData(
        Boolean isInsert, 
        Boolean isUpdate, 
        Boolean isDelete, 
        List<dmpl__SaleReturnLine__c> newEntries, 
        List<dmpl__SaleReturnLine__c> oldEntries)
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
            dfsHelper.DocumentStatusRelatedObjectRestrictEdits_New(
                OBJECT_SALERETURN, OBJECT_SALERETURNLINE, 
                RELATION_SALERETURN_STATUS, newEntries);
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
                oldEntries, newEntries, 
                FIELD_SALERETURNLINE_SALEINVOICELINEID);
            DocumentHelper.validateChangeInLockedIfTransactedFields(
                LIST_FIELDS_LOCKEDIFTRANSACTED, 
                oldEntries, 
                newEntries, 
                FIELD_SALERETURNLINE_QUANTITY);
            dfsHelper.DocumentStatusRelatedObjectRestrictEdits_Edit(
                OBJECT_SALERETURN, 
                OBJECT_SALERETURNLINE, 
                RELATION_SALERETURN_STATUS, 
                oldEntries, 
                newEntries);
            // validateChangeInQuantity(oldEntries, newEntries);
        }else if(isDelete){
            // DocumentHelper.validateCanBeDeleted(oldEntries, FIELD_SALERETURNLINE_QUANTITY);
            dfsHelper.DocumentStatusRelatedObjectRestrictEdits_Delete(
                OBJECT_SALERETURN, 
                OBJECT_SALERETURNLINE, 
                RELATION_SALERETURN_STATUS, oldEntries);
        }
    } catch (Exception error) {
        ExceptionLogHelper.logException(error);
        throw error;
    }
    }

    public static void postData(
        Boolean isInsert, 
        Boolean isUpdate, 
        Boolean isDelete, 
        List<dmpl__SaleReturnLine__c> newEntries, 
        List<dmpl__SaleReturnLine__c> oldEntries){
        try{
            List<dmpl__SaleReturnLine__c> approvedObjects = DocumentHelper.getPostedObjects(
                FIELD_SALERETURNLINE_ISILPOSTINGAPPROVED, 
                oldEntries, 
                newEntries); 
            if(approvedObjects.size() > 0){
                InventoryLedgerHelper.createLedger(
                    InventoryLedgerTypeEnums.SaleReturn, 
                    'dmpl__SaleReturnId__c', 
                    'dmpl__SaleReturn__c', 
                    isInsert, 
                    isDelete, 
                    isUpdate, 
                    oldEntries, 
                    newEntries);

                List<dmpl__SaleReturnLine__c> returnEntries = DocumentHelper.getObjectsByFilter(
                    approvedObjects, 
                    'dmpl__ReturnType__c',
                    'Damaged');
                if(returnEntries.size() > 0)
                    InventoryLedgerHelper.createLedger(
                        InventoryLedgerTypeEnums.Damaged, 
                        'dmpl__SaleReturnId__c', 
                        'dmpl__SaleReturn__c', 
                        isInsert, 
                        isDelete, 
                        isUpdate, 
                        isDelete ? returnEntries : oldEntries, 
                        isInsert || isUpdate ? returnEntries : newEntries);
                
                returnEntries = DocumentHelper.getObjectsByFilter(
                    approvedObjects, 
                    'dmpl__ReturnType__c',
                    'Expired');
                if(returnEntries.size() > 0)
                    InventoryLedgerHelper.createLedger(
                        InventoryLedgerTypeEnums.Expired, 
                        'dmpl__SaleReturnId__c', 
                        'dmpl__SaleReturn__c', 
                        isInsert, 
                        isDelete, 
                        isUpdate, 
                        isDelete ? returnEntries : oldEntries, 
                        isInsert || isUpdate ? returnEntries : newEntries);
            }
            if(isInsert){
                setItemData(
                    newEntries);
                TaxHelper.setLinesTaxes(
                    newEntries);
            }else if(isUpdate){
                List<dmpl__SaleReturnLine__c> modifiedObjects = DocumentHelper.getModifiedNewObjects(
                    FIELD_SALERETURNLINE_PRICELISTRULEID, 
                        oldEntries, 
                        newEntries);
                if(modifiedObjects.size()>0){
                    Map<Id, dmpl__Item__c> items = new Map<Id,dmpl__Item__c>(
                    ItemHelper.getCachedItems(
                        DocumentHelper.extractIds(
                            modifiedObjects, 
                            FIELD_SALERETURNLINE_ITEMID)));
                List<dmpl__SaleReturn__c> saleReturnDocuments = querySaleReturnDocument(
                    DocumentHelper.extractIds(
                        modifiedObjects, 
                        FIELD_SALERETURNLINE_SALERETURNID));
                PriceListHelper.setApplicablePrices(
                    modifiedObjects, 
                    saleReturnDocuments, 
                    items.values(), 
                    DocumentHelper.extractIds(
                         modifiedObjects, 
                         FIELD_SALERETURNLINE_PRICELISTRULEID),
                                'dmpl__SaleReturnId__c');
                }
                modifiedObjects = DocumentHelper.getModifiedNewObjects(
                    new string[]{
                        FIELD_SALERETURNLINE_TAXGROUPID,
                        FIELD_SALERETURNLINE_ITEMID, 
                        FIELD_SALERETURNLINE_SKUID,
                        FIELD_SALERETURNLINELINE_AMOUNT
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
                    FIELD_SALERETURNLINE_ITEMID)));
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
                //SaleReturnTaxHelper.deleteApplicableTaxes(oldEntries);
            }
        } catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }

    public static void afterPostData(Boolean isInsert, Boolean isDelete, Boolean isUpdate, List<dmpl__SaleReturnLine__c> oldEntries, List<dmpl__SaleReturnLine__c> newEntries)
    {
        try{
            if(isDelete){
                SaleInvoiceLineHelper.updateSaleReturnQuantity(
                    DocumentHelper.extractIds(
                        oldEntries, FIELD_SALERETURNLINE_SALEINVOICELINEID));
                SaleDeliveryLineHelper.updateSaleReturnQuantity(
                    DocumentHelper.extractIds(
                        oldEntries, FIELD_SALERETURNLINE_DELIVERYORDERLINEID));
                SaleOrderLineHelper.updateSaleReturnQuantity(
                    DocumentHelper.extractIds(
                        oldEntries, 
                        FIELD_SALERETURNLINE_SALEORDERLINEID));
                TaxHelper.deleteLinesTaxes(oldEntries);
            } else if(isInsert){
                SaleInvoiceLineHelper.updateSaleReturnQuantity(DocumentHelper.extractIds(newEntries, FIELD_SALERETURNLINE_SALEINVOICELINEID));
                SaleDeliveryLineHelper.updateSaleReturnQuantity(DocumentHelper.extractIds(newEntries, FIELD_SALERETURNLINE_DELIVERYORDERLINEID));
                SaleOrderLineHelper.updateSaleReturnQuantity(DocumentHelper.extractIds(newEntries, FIELD_SALERETURNLINE_SALEORDERLINEID));
                TaxHelper.createLinesTaxes(
                    isInsert, 
                    newEntries);
            } else if(isUpdate){
                List<dmpl__SaleReturnLine__c> modifiedObjects = DocumentHelper.getModifiedNewObjects(FIELD_SALERETURNLINE_QUANTITY, oldEntries, newEntries);
                if(modifiedObjects.size()>0){
                    SaleInvoiceLineHelper.updateSaleReturnQuantity(DocumentHelper.extractIds(modifiedObjects, FIELD_SALERETURNLINE_SALEINVOICELINEID));
                    SaleDeliveryLineHelper.updateSaleReturnQuantity(DocumentHelper.extractIds(modifiedObjects, FIELD_SALERETURNLINE_DELIVERYORDERLINEID));
                }
                modifiedObjects = DocumentHelper.getModifiedNewObjects(FIELD_SALERETURNLINE_QUANTITY, oldEntries, newEntries);
                if(modifiedObjects.size()>0){
                    SaleOrderLineHelper.updateSaleReturnQuantity(DocumentHelper.extractIds(modifiedObjects, FIELD_SALERETURNLINE_SALEORDERLINEID));
                }

                modifiedObjects = DocumentHelper.getModifiedNewObjects(new string[]{FIELD_SALERETURNLINE_TAXGROUPID,FIELD_SALERETURNLINE_ITEMID, FIELD_SALERETURNLINE_SKUID,FIELD_SALERETURNLINELINE_AMOUNT}, oldEntries, newEntries);
                if(modifiedObjects.size()>0){
                    TaxHelper.createLinesTaxes(
                        isInsert,
                        modifiedObjects);
                }
            }

            List<dmpl__SaleReturn__c> saleReturnDocuments = null;
            if(isInsert || isDelete){
                saleReturnDocuments = querySaleReturnDocument(
                    DocumentHelper.extractIds(
                        isDelete ? oldEntries : newEntries, 
                        'dmpl__SaleReturnId__c'));
            }else if(isUpdate) {
                saleReturnDocuments = querySaleReturnDocument(
                    DocumentHelper.extractIds(
                        DocumentHelper.getModifiedNewObjects(
                        new string[]{
                            FIELD_SALERETURNLINELINE_AMOUNT}, 
                        oldEntries, newEntries),
                        'dmpl__SaleReturnId__c'));
            }
            // if(saleReturnDocuments.size() >0){
            //     SchemeReturnEngine.processSchemeReturn(
            //         saleReturnDocuments);
            //     SchemeEngine.postSaleReturnSchemeLeders(
            //         saleReturnDocuments);
            // }
        } catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }

    public static void approveSaleReturnLines(List<dmpl__SaleReturn__c> returns){
        List<dmpl__SaleReturnLine__c> returnLines = queryReturnLines(DocumentHelper.extractIds(returns));
        for(dmpl__SaleReturn__c saleReturn : returns){
            approveReturnLines(DocumentHelper.getObjects(returnLines, FIELD_SALERETURNLINE_SALERETURNID, saleReturn.Id));
        }
        try {
            skipValidations = true;
            SecurityHelper.ensureCanWriteFields(new string[]{'dmpl__IsILPostingApproved__c','dmpl__IsGLPostingApproved__c'}, 'dmpl__SaleReturnLine__c');
            Update returnLines;
            
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

    public static void postReturnLineInternal(List<dmpl__SaleReturn__c> saleReturns)
    {
        dmpl__CreateRelatedSetting__mdt setting = CreateRelatedSettingHelper.getCreateRelatedSettings(
            'dmpl__SaleReturn__c',
            'Post IL');
        if(setting == null){
            postReturnLineInternal(queryReturnLines(DocumentHelper.extractIds(saleReturns)));
        }else {
            for(dmpl__SaleReturn__c saleReturn : saleReturns){
                DocumentSelectorController.releaseDocumentDirect(setting.Id, saleReturn.Id);
            }
        }  
    }

    private static CreateRelatedResult postReturnLineInternal(List<dmpl__SaleReturnLine__c> saleReturnLines)
    {
        SecurityHelper.ensureCanWriteField('dmpl__IsILPostingApproved__c', 'dmpl__SaleReturnLine__c');
        for(dmpl__SaleReturnLine__c returnLine : saleReturnLines){
            returnLine.dmpl__IsILPostingApproved__c = true;
        }

        try {
            skipValidations = true;
            SecurityHelper.ensureCanWriteFields(new string[]{'dmpl__IsILPosted__c','dmpl__IsILPostingApproved__c'}, 'dmpl__SaleReturnLine__c');
            return CreateRelatedResult.InitFrom(Database.update(saleReturnLines));        
        } finally {
            skipValidations = false;
        }
    }

    @testVisible
    private static void setItemData(List<dmpl__SaleReturnLine__c> newEntries)
    {
        Map<Id, dmpl__Item__c> items = new Map<Id,dmpl__Item__c>(
        ItemHelper.getCachedItems(DocumentHelper.extractIds(newEntries, FIELD_SALERETURNLINE_ITEMID)));
        List<dmpl__SaleReturn__c> saleReturnDocuments = querySaleReturnDocument(DocumentHelper.extractIds(newEntries, FIELD_SALERETURNLINE_SALERETURNID));
        ItemHelper.setQuantityFromUOM(
            newEntries, 
            null,
            items);
        TaxGroupHelper.setApplicableTaxGroups(newEntries, saleReturnDocuments, items.values());
        PriceListHelper.setApplicablePrices(
            newEntries, 
            saleReturnDocuments, 
            items.values(),
            false);
    }

    private static void approveReturnLines(List<dmpl__SaleReturnLine__c> documentReturnLines)
    {
        for(dmpl__SaleReturnLine__c returnLine : documentReturnLines){
            returnLine.dmpl__IsGLPostingApproved__c = true;
        }
    }

    private static List<dmpl__SaleReturnLine__c> queryReturnLines(List<Id> documentIds){

        SecurityHelper.ensureCanReadFields(new string[]{'dmpl__SaleReturnId__c','dmpl__IsILPostingApproved__c','dmpl__IsGLPostingApproved__c','dmpl__IsILPosted__c'}, 'dmpl__SaleReturnLine__c');
        return [SELECT ID, dmpl__SaleReturnId__c, dmpl__IsILPostingApproved__c, dmpl__IsGLPostingApproved__c,dmpl__IsILPosted__c
                FROM dmpl__SaleReturnLine__c
                WHERE dmpl__SaleReturnId__c IN :documentIds];
    }

    private static List<dmpl__SaleReturnLine__c> queryReturnLinesForLineIds(List<Id> lineIds){

        SecurityHelper.ensureCanReadFields(new string[]{'dmpl__SaleReturnId__c','dmpl__IsILPostingApproved__c','dmpl__IsGLPostingApproved__c','dmpl__IsILPosted__c'}, 'dmpl__SaleReturnLine__c');
        return [SELECT ID, dmpl__SaleReturnId__c, dmpl__IsILPostingApproved__c, dmpl__IsGLPostingApproved__c,dmpl__IsILPosted__c
                FROM dmpl__SaleReturnLine__c
                WHERE Id IN :lineIds];
    }
    
    private static void validateItem(List<dmpl__SaleReturnLine__c> newEntries){
        Map<Id, dmpl__Item__c> items = new Map<Id,dmpl__Item__c>(ItemHelper.getCachedItems(DocumentHelper.extractIds(newEntries, FIELD_SALERETURNLINE_ITEMID)));
        for(dmpl__SaleReturnLine__c orderLine : newEntries){
            dmpl__Item__c item = items.get(orderLine.dmpl__ItemId__c);
            // if(orderLine.dmpl__PackageSaleOrderLineId__c == null && item!=null && item.dmpl__OnlySoldInPackage__c){
            //     orderLine.addError(System.Label.PackageError_ItemSoldOnlyInPackage);
            // }
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

    private static List<dmpl__SaleReturn__c> querySaleReturnDocument(List<ID> saleReturnLineIds)
    {
        SecurityHelper.ensureCanReadFields(new string[]{'dmpl__DocumentDate__c','dmpl__TaxSupplyType__c','dmpl__BranchId__c','dmpl__PriceListId__c','dmpl__Status__c','dmpl__PartnerAccountId__c'}, 'dmpl__SaleReturn__c');
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
                dmpl__PriceAsOnDate__c,
                dmpl__SaleInvoiceId__c,
                dmpl__PriceListRuleId__c,
                dmpl__AccountId__c
            FROM dmpl__SaleReturn__c 
            WHERE ID IN : saleReturnLineIds ];
    }

}