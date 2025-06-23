public with sharing class TransferOutwardLineHelper {
    private static Boolean skipValidations = false;

    private static final string OBJECT_TRANSFER = 'dmpl__Transfer__c';
    private static final string OBJECT_TRANSFEROUTWARDLINE = 'dmpl__TransferOutwardLine__c';
    private static final string FIELD_TRANSFEROUTWARDTRANSFERID = 'dmpl__TransferId__c';
    private static final string FIELD_TRANSFEROUTWARD_REQUISITIONLINEID = 'dmpl__RequisitionLineId__c';
    
    private static final string FIELD_TRANSFEROUTWARDLINE_CLOSEDQUANTITY = 'dmpl__ClosedQuantity__c';
    private static final string FIELD_TRANSFEROUTWARDLINE_ITEMID = 'dmpl__ItemId__c';
    private static final string FIELD_TRANSFEROUTWARDLINE_SKUID = 'dmpl__SKUId__c';
    private static final string FIELD_TRANSFEROUTWARDLINE_QUANTITY = 'dmpl__Quantity__c';

    private static final string RELATION_TRANSFER_STATUS = 'dmpl__TransferId__r.dmpl__Status__c';

    private static final List<String> LIST_FIELDS_NONEDITABLE = new List<String>{};
    private static final List<String> LIST_FIELDS_SYSTEM = new List<String>{
        FIELD_TRANSFEROUTWARDLINE_CLOSEDQUANTITY
    };
    private static final List<String> LIST_FIELDS_LOCKEDIFTRANSACTED = new List<String>{
        FIELD_TRANSFEROUTWARDLINE_ITEMID,
        FIELD_TRANSFEROUTWARDLINE_SKUID
    };

    private static final List<String> LIST_FIELDS_NEGATIVEANDZERONOTALLOWED = new List<String>{
        
    };
    
    private static final List<String> LIST_FIELDS_NEGATIVENOTALLOWED = new List<String>{
        'dmpl__ClosedQuantity__c', 
        'dmpl__PendingInwardQuantity__c', 
        'dmpl__Quantity__c'
    };

    public static void validateData(Boolean isInsert, Boolean isDelete, Boolean isUpdate, List<dmpl__TransferOutwardLine__c> oldEntries, List<dmpl__TransferOutwardLine__c> newEntries)
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
                dfsHelper.DocumentStatusRelatedObjectRestrictEdits_New(OBJECT_TRANSFER, OBJECT_TRANSFEROUTWARDLINE, RELATION_TRANSFER_STATUS, newEntries);
            }else if(isUpdate){
                DocumentHelper.validateChangeInSystemFields(LIST_FIELDS_SYSTEM, oldEntries, newEntries);
                DocumentHelper.validateChangeInKeyFields(LIST_FIELDS_NONEDITABLE, oldEntries, newEntries);
                dfsHelper.DocumentStatusRelatedObjectRestrictEdits_Edit(OBJECT_TRANSFER, OBJECT_TRANSFEROUTWARDLINE, RELATION_TRANSFER_STATUS, oldEntries, newEntries);
            }else if(isDelete){
                DocumentHelper.validateCanBeDeleted(oldEntries, FIELD_TRANSFEROUTWARDLINE_QUANTITY);
                dfsHelper.DocumentStatusRelatedObjectRestrictEdits_Delete(OBJECT_TRANSFER, OBJECT_TRANSFEROUTWARDLINE, RELATION_TRANSFER_STATUS, oldEntries);
            }
        }catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }

    public static void postData(Boolean isInsert, Boolean isDelete, Boolean isUpdate, List<dmpl__TransferOutwardLine__c> oldEntries, List<dmpl__TransferOutwardLine__c> newEntries)
    {
        try{
            if(isInsert){
                InventoryStockHelper.setStock(newEntries);
            }
            postTransferLine(isInsert, isDelete, isUpdate, oldEntries, newEntries);
            InventoryLedgerHelper.createLedger(InventoryLedgerTypeEnums.TransferOutward, FIELD_TRANSFEROUTWARDTRANSFERID,OBJECT_TRANSFER, isInsert, isDelete, isUpdate, oldEntries, newEntries);
        }catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }
    
    public static void afterPostData(
        Boolean isInsert, 
        Boolean isDelete, 
        Boolean isUpdate, 
        List<dmpl__TransferOutwardLine__c> oldEntries, 
        List<dmpl__TransferOutwardLine__c> newEntries){
            try{
                if(isDelete){
                    PurchaseRequisitionLineHelper.updateTransferQuantity(
                        DocumentHelper.extractIds(
                            oldEntries, 
                            FIELD_TRANSFEROUTWARD_REQUISITIONLINEID));
                }else if(isInsert){
                    PurchaseRequisitionLineHelper.updateTransferQuantity(
                        DocumentHelper.extractIds(
                            newEntries, 
                            FIELD_TRANSFEROUTWARD_REQUISITIONLINEID));
                }else if(isUpdate){
                    List<Id> modifiedObjectIds = DocumentHelper.getModifiedNewObjectIds(
                        FIELD_TRANSFEROUTWARDLINE_QUANTITY, 
                        FIELD_TRANSFEROUTWARD_REQUISITIONLINEID, 
                        oldEntries, 
                        newEntries);
                    if(modifiedObjectIds.size()>0){
                        PurchaseRequisitionLineHelper.updateTransferQuantity(
                            modifiedObjectIds);
                    }
                }
            } catch (Exception error) {
                ExceptionLogHelper.logException(error);
                throw error;
            }
    }

    public static CreateRelatedResult releaseOutwardDocument(Id documentId){
        return releaseOutwardDocument(queryOutwardLines(new List<Id>{documentId}));
    }

    public static CreateRelatedResult releaseOutwardDocument(List<SourceObjectInfo> orderLinesInfo, Id documentId){
        return releaseOutwardDocument(queryOutwardLinesForLines(SourceObjectInfo.extractIds(orderLinesInfo)));
    }

    public static void releaseOutwardDocument(List<dmpl__Transfer__c> documents){
        releaseOutwardDocument(queryOutwardLines(DocumentHelper.extractIds(documents)));
    }

    public static CreateRelatedResult releaseOutwardDocument(List<dmpl__TransferOutwardLine__c> outwardLines)
    {
        for(dmpl__TransferOutwardLine__c line : outwardLines){
            SecurityHelper.ensureCanWriteField('dmpl__IsILPostingApproved__c', 'dmpl__TransferOutwardLine__c');
            line.dmpl__IsILPostingApproved__c = true;
        }
        try {
            TransferOutwardLineHelper.skipValidations = true;
            SecurityHelper.ensureCanWriteFields(new string[]{'dmpl__ItemId__c','dmpl__IsILPosted__c','dmpl__IsILPostingApproved__c','dmpl__SKUId__c','dmpl__RelatedItemLotId__c','dmpl__ItemLotId__c','dmpl__Quantity__c','dmpl__UnitCost__c'}, 'dmpl__TransferOutwardLine__c');
            return CreateRelatedResult.InitFrom(Database.update(outwardLines));            
        } finally {
            TransferOutwardLineHelper.skipValidations = false;
        }
    }
        public static void updateOutwardTransferLine(

        Boolean isInsert, 
        Boolean isDelete, 
        Boolean isUpdate, 
        List<dmpl__TransferInwardLine__c> oldEntries, 
        List<dmpl__TransferInwardLine__c> newEntries)
    {
        Map<Id, dmpl__ItemLot__c> itemLots = getRelatedLots(
            newEntries, 
            oldEntries);
        Map<Id, dmpl__TransferOutwardLine__c> sourceLines = getSourceTansferLines(
            newEntries, 
            oldEntries);
        //
        List<dmpl__ItemLot__c> updatedItemLots = new List<dmpl__ItemLot__c>();
        List<dmpl__TransferOutwardLine__c> updatedOutwardLines = new List<dmpl__TransferOutwardLine__c>();
        //
        
        if(isInsert || isUpdate)
        {
            for(dmpl__TransferInwardLine__c lineEntry : newEntries)
            {
                dmpl__TransferOutwardLine__c sourceLine = sourceLines.Get(
                    lineEntry.dmpl__TransferOutwardLineId__c);
                if(sourceLine == null)
                {
                    lineEntry.addError(
                        String.format(
                            String.valueOf(
                                System.Label.Generic_MissingObject),
                                new string[]{dmpl__TransferOutwardLine__c.class.getName()}));
                    return;
                }
                if(lineEntry.dmpl__ItemLotId__c == null)
                    continue;
                dmpl__ItemLot__c itemLot = itemLots.get(lineEntry.dmpl__ItemLotId__c);
                if(itemLot == null)
                {
                    lineEntry.addError(String.format(String.valueOf(System.Label.Generic_MissingObject), new string[]{dmpl__ItemLot__c.class.getName()}));
                    return;
                }
                itemLot.dmpl__StorageLocationId__c = lineEntry.dmpl__StorageLocationId__c;
                if(!updatedItemLots.Contains(itemLot))
                    updatedItemLots.Add(itemLot);
            }
            //
            try {
                ItemLotHelper.skipValidations = true;
                TransferOutwardLineHelper.skipValidations = true;
                SecurityHelper.ensureCanWriteFields(new string[]{'dmpl__ItemId__c','dmpl__SKUId__c','dmpl__MRP__c','dmpl__DateOfSupplierInvoice__c','dmpl__DateOfReceipt__c','dmpl__SupplierInvoiceNumber__c','dmpl__BatchNo__c','dmpl__ComponentNumber__c','dmpl__DateOfExpiry__c','dmpl__Cost__c','dmpl__DateOfMfg__c','dmpl__DateOfSupplierDispatch__c'}, 'dmpl__ItemLot__c');
                update updatedItemLots;
            } finally {
                ItemLotHelper.skipValidations = false;
                TransferOutwardLineHelper.skipValidations = false;
            }
        }
    }

    public static void updateClosedQuantity(
        List<Id> inwardTransferIds){
        try{
            skipValidations = true;
            SecurityHelper.ensureCanReadFields(
                new string[]{
                    'dmpl__TransferOutwardLineId__c',
                    'dmpl__Quantity__c'
                }, 
                'dmpl__TransferInwardLine__c');
            List<AggregateResult> ffAggregates = 
                [SELECT 
                dmpl__TransferOutwardLineId__c OutwardLineId, 
                    SUM(dmpl__Quantity__c) TotalQuantity
                FROM 
                dmpl__TransferInwardLine__c
                WHERE 
                dmpl__TransferId__c IN :inwardTransferIds
                WITH SECURITY_ENFORCED
                GROUP BY dmpl__TransferOutwardLineId__c];
    
            SecurityHelper.ensureCanReadFields(new string[]{
                'dmpl__ClosedQuantity__c'
            }, 'dmpl__TransferOutwardLine__c');
            List<dmpl__TransferOutwardLine__c> orderLinesToUpdate = 
                [SELECT 
                    Id, 
                    dmpl__ClosedQuantity__c
                FROM 
                    dmpl__TransferOutwardLine__c
                WHERE 
                    Id IN :DocumentHelper.extractIds(ffAggregates,'OutwardLineId')];
    
            for(dmpl__TransferOutwardLine__c orderLine : orderLinesToUpdate){
                for(AggregateResult result : ffAggregates){
                    if(result.get('OutwardLineId') == orderLine.Id){
                        orderLine.dmpl__ClosedQuantity__c = 
                            result.get('TotalQuantity') ==null ? 0 : (Decimal)(result.get('TotalQuantity'));
                        break;
                    }
                }
            }
            SecurityHelper.ensureCanWriteFields(new string[]{
                'dmpl__ClosedQuantity__c'
            }, 'dmpl__TransferOutwardLine__c');
            Update orderLinesToUpdate;
        }finally{
            skipValidations = false;
        }
    }

    private static void postTransferLine(Boolean isInsert, Boolean isDelete, Boolean isUpdate, List<dmpl__TransferOutwardLine__c> oldEntries, List<dmpl__TransferOutwardLine__c> newEntries)
    {
        Map<Id, dmpl__ItemLot__c> itemLots = getRelatedLots(newEntries, oldEntries);
        //
        List<dmpl__ItemLot__c> insertedItemLots = new List<dmpl__ItemLot__c>();
        List<dmpl__ItemLot__c> updatedItemLots = new List<dmpl__ItemLot__c>();
        //
        Map<ID, dmpl__Transfer__c> transferDocuments = queryTransferDocuments(DocumentHelper.extractIds(newEntries, FIELD_TRANSFEROUTWARDTRANSFERID));
        if(isInsert || isUpdate){
            for(dmpl__TransferOutwardLine__c lineEntry : newEntries){
                if(!lineEntry.dmpl__IsILPostingApproved__c){
                    continue;
                }
                dmpl__Transfer__c transferDocument = transferDocuments.get(lineEntry.dmpl__TransferId__c);
                if(transferDocument == null)
                    lineEntry.addError(String.format(String.valueOf(System.Label.Generic_MissingObject), new string[]{dmpl__ItemLot__c.class.getName()}));
                if(lineEntry.dmpl__ItemLotId__c == null)
                    continue;
                dmpl__ItemLot__c sourceItemLot = itemLots.get(lineEntry.dmpl__ItemLotId__c);
                if(sourceItemLot==null)
                    lineEntry.addError(String.format(String.valueOf(System.Label.Generic_MissingObject), new string[]{dmpl__ItemLot__c.class.getName()}));
                //
                dmpl__ItemLot__c oldItemLot = null;
                if(isUpdate){
                    dmpl__TransferOutwardLine__c oldEntry = getOldTransferLine(oldEntries, lineEntry);
                    oldItemLot = itemLots.get(oldEntry.dmpl__RelatedItemLotId__c);
                }
                //
                dmpl__ItemLot__c itemLot = createItemLot(lineEntry, sourceItemLot, oldItemLot, transferDocument);
                if(itemLot!=null){
                    lineEntry.dmpl__RelatedItemLotId__r =  itemLot;
                    if(itemLot.Id !=null)
                        updatedItemLots.Add(itemLot);
                    else
                        insertedItemLots.Add(itemLot);
                }
            }
            //
            try {
                ItemLotHelper.skipValidations = true;
                TransferOutwardLineHelper.skipValidations = true;
                if (insertedItemLots.size()>0) {
                    SecurityHelper.ensureCanCreateObject('dmpl__ItemLot__c');
                    SecurityHelper.ensureCanCreateFields(new string[]{'dmpl__ItemId__c','dmpl__SKUId__c','dmpl__MRP__c','dmpl__DateOfSupplierInvoice__c','dmpl__DateOfReceipt__c','dmpl__SupplierInvoiceNumber__c','dmpl__BatchNo__c','dmpl__ComponentNumber__c','dmpl__DateOfExpiry__c','dmpl__Cost__c','dmpl__DateOfMfg__c','dmpl__DateOfSupplierDispatch__c'}, 'dmpl__ItemLot__c');
                    insert insertedItemLots;                
                }
                if(updatedItemLots.size()>0){
                    SecurityHelper.ensureCanWriteFields(new string[]{'dmpl__ItemId__c','dmpl__SKUId__c','dmpl__MRP__c','dmpl__DateOfSupplierInvoice__c','dmpl__DateOfReceipt__c','dmpl__SupplierInvoiceNumber__c','dmpl__BatchNo__c','dmpl__ComponentNumber__c','dmpl__DateOfExpiry__c','dmpl__Cost__c','dmpl__DateOfMfg__c','dmpl__DateOfSupplierDispatch__c'}, 'dmpl__ItemLot__c');
                    update updatedItemLots;
                }                    
            } finally {
                ItemLotHelper.skipValidations = false;
                TransferOutwardLineHelper.skipValidations = false;
            }
            //
            for(dmpl__TransferOutwardLine__c lineEntry : newEntries){
                if(lineEntry.dmpl__RelatedItemLotId__r!=null){
                    SecurityHelper.ensureCanWriteField('dmpl__RelatedItemLotId__c','dmpl__TransferOutwardLine__c');
                    lineEntry.dmpl__RelatedItemLotId__c = lineEntry.dmpl__RelatedItemLotId__r.Id;
                }
            }
        }
    }
    
    private static dmpl__TransferOutwardLine__c getOldTransferLine(List<dmpl__TransferOutwardLine__c> oldEntries,dmpl__TransferOutwardLine__c lineEntry)
    {
        for(dmpl__TransferOutwardLine__c oldEntry : oldEntries)
            if(oldEntry.Id == lineEntry.Id )            
                return oldEntry;
        //
        return null;
    }

    private static dmpl__ItemLot__c createItemLot(dmpl__TransferOutwardLine__c sourceEntry, dmpl__ItemLot__c sourceItemLot, dmpl__ItemLot__c oldItemLot, dmpl__Transfer__c transferDocument) 
    {
        dmpl__ItemLot__c itemLot = oldItemLot;
        if(itemLot == null)
            itemLot = new dmpl__ItemLot__c();
        //
        if(transferDocument.dmpl__ToPartnerAccountId__c != null){
            itemLot.dmpl__PartnerAccountId__c = transferDocument.dmpl__ToPartnerAccountId__c;
        }else{
            itemLot.dmpl__PartnerAccountId__c = transferDocument.dmpl__PartnerAccountId__c;
        }
        itemLot.dmpl__BranchId__c = transferDocument.dmpl__ToBranchId__c;
        itemLot.dmpl__RelatedItemLotId__c = sourceItemLot.Id;
        itemLot.dmpl__RelatedItemLotId__r = sourceItemLot;
        //
        itemLot.dmpl__BatchNo__c = sourceItemLot.dmpl__BatchNo__c;
        itemLot.dmpl__SerialNumber__c = sourceItemLot.dmpl__SerialNumber__c;
        itemLot.dmpl__ComponentNumber__c = sourceItemLot.dmpl__ComponentNumber__c;
        itemLot.dmpl__RegistrationNumber__c = sourceItemLot.dmpl__RegistrationNumber__c;
        itemLot.dmpl__SupplierInvoiceNumber__c = sourceItemLot.dmpl__SupplierInvoiceNumber__c;

        itemLot.dmpl__DateOfSupplierInvoice__c = sourceItemLot.dmpl__DateOfSupplierInvoice__c;
        itemLot.dmpl__DateOfSupplierDispatch__c = sourceItemLot.dmpl__DateOfSupplierDispatch__c;
        itemLot.dmpl__PurchaseDate__c = sourceItemLot.dmpl__PurchaseDate__c;

        itemLot.dmpl__Cost__c = sourceItemLot.dmpl__Cost__c;
        itemLot.dmpl__DateOfExpiry__c = sourceItemLot.dmpl__DateOfExpiry__c;
        itemLot.dmpl__DateOfMfg__c = sourceItemLot.dmpl__DateOfMfg__c;
        itemLot.dmpl__DateOfSupplierDispatch__c = sourceItemLot.dmpl__DateOfSupplierDispatch__c;
        itemLot.dmpl__DateOfSupplierInvoice__c = sourceItemLot.dmpl__DateOfSupplierInvoice__c;
        itemLot.dmpl__SupplierInvoiceNumber__c = sourceItemLot.dmpl__SupplierInvoiceNumber__c;
        itemLot.dmpl__DateOfReceipt__c = sourceItemLot.dmpl__DateOfReceipt__c;
        itemLot.dmpl__ItemId__c = sourceItemLot.dmpl__ItemId__c;
        itemLot.dmpl__MRP__c = sourceItemLot.dmpl__MRP__c;
        itemLot.dmpl__SKUId__c = sourceItemLot.dmpl__SKUId__c;
        itemLot.dmpl__ItemLotTypeId__c = sourceItemLot.dmpl__ItemLotTypeId__c;
        return itemLot;
    }

    private static Map<Id, dmpl__ItemLot__c> getRelatedLots(List<dmpl__TransferOutwardLine__c> newLineEntries, List<dmpl__TransferOutwardLine__c> oldLineEntries)
    {
        List<ID> itemLotIds = new List<ID>();
        //
        if(newLineEntries!=null)
        {
            for(dmpl__TransferOutwardLine__c lineEntry : newLineEntries)
            {
                if(lineEntry.dmpl__ItemLotId__c!=null && !itemLotIds.Contains(lineEntry.dmpl__ItemLotId__c))
                    itemLotIds.Add(lineEntry.dmpl__ItemLotId__c);
                if(lineEntry.dmpl__RelatedItemLotId__c!=null && !itemLotIds.Contains(lineEntry.dmpl__RelatedItemLotId__c))
                    itemLotIds.Add(lineEntry.dmpl__RelatedItemLotId__c);
            }
        }
        //
        if(oldLineEntries!=null)
        {
            for(dmpl__TransferOutwardLine__c lineEntry : oldLineEntries)
            {
                if(!itemLotIds.Contains(lineEntry.dmpl__ItemLotId__c))
                    itemLotIds.Add(lineEntry.dmpl__ItemLotId__c);
                if(lineEntry.dmpl__RelatedItemLotId__c!=null && !itemLotIds.Contains(lineEntry.dmpl__RelatedItemLotId__c))
                    itemLotIds.Add(lineEntry.dmpl__RelatedItemLotId__c);
            }
        }
        //
        SecurityHelper.ensureCanReadFields(new string[]{'dmpl__ItemId__c','dmpl__PurchaseDate__c','dmpl__RegistrationNumber__c','dmpl__SerialNumber__c','dmpl__SKUId__c','dmpl__ItemLotTypeId__c','dmpl__MRP__c','dmpl__DateOfSupplierInvoice__c','dmpl__DateOfReceipt__c','dmpl__SupplierInvoiceNumber__c','dmpl__BatchNo__c','dmpl__ComponentNumber__c','dmpl__DateOfExpiry__c','dmpl__Cost__c','dmpl__DateOfMfg__c','dmpl__DateOfSupplierDispatch__c'}, 'dmpl__ItemLot__c');
        return new Map<Id,dmpl__ItemLot__c>([SELECT id,
            dmpl__BatchNo__c,
            dmpl__ComponentNumber__c,
            dmpl__Cost__c,
            dmpl__SerialNumber__c,
            dmpl__PurchaseDate__c,
            dmpl__RegistrationNumber__c,
            dmpl__DateOfExpiry__c,
            dmpl__DateOfMfg__c,
            dmpl__DateOfSupplierDispatch__c,
            dmpl__DateOfSupplierInvoice__c,
            dmpl__SupplierInvoiceNumber__c,
            dmpl__DateOfReceipt__c,
            dmpl__ItemId__c,
            dmpl__MRP__c,
            Name,
            dmpl__SKUId__c,
            dmpl__ItemLotTypeId__c
            FROM dmpl__ItemLot__c WHERE id IN : itemLotIds]);
    }

    private static Map<ID, dmpl__Transfer__c> queryTransferDocuments(List<ID> documentIds)
    {
        SecurityHelper.ensureCanReadFields(new string[]{
            'dmpl__PartnerAccountId__c',
            'dmpl__ToPartnerAccountId__c',
            'dmpl__BranchId__c',
            'dmpl__ToBranchId__c',
            'dmpl__DocumentDate__c',
            'dmpl__Status__c'
        }, 'dmpl__Transfer__c');
        return new Map<ID, dmpl__Transfer__c>([SELECT id,
        dmpl__PartnerAccountId__c,
        dmpl__ToPartnerAccountId__c,
        dmpl__BranchId__c,
        dmpl__ToBranchId__c,
        dmpl__DocumentDate__c,
        dmpl__Status__c
        FROM dmpl__Transfer__c
        WHERE Id IN : documentIds]);
    }
    private static Map<Id, dmpl__ItemLot__c> getRelatedLots(List<dmpl__TransferInwardLine__c> newLineEntries, List<dmpl__TransferInwardLine__c> oldLineEntries)
    {
        List<ID> itemLotIds = new List<ID>();
        //
        if(newLineEntries!=null)
        {
            for(dmpl__TransferInwardLine__c lineEntry : newLineEntries)
            {
                if(!itemLotIds.Contains(lineEntry.dmpl__ItemLotId__c))
                    itemLotIds.Add(lineEntry.dmpl__ItemLotId__c);
                if(lineEntry.dmpl__RelatedItemLotId__c!=null && !itemLotIds.Contains(lineEntry.dmpl__RelatedItemLotId__c))
                    itemLotIds.Add(lineEntry.dmpl__RelatedItemLotId__c);
            }
        }
        //
        if(oldLineEntries!=null)
        {
            for(dmpl__TransferInwardLine__c lineEntry : oldLineEntries)
            {
                if(!itemLotIds.Contains(lineEntry.dmpl__ItemLotId__c))
                    itemLotIds.Add(lineEntry.dmpl__ItemLotId__c);
                if(lineEntry.dmpl__RelatedItemLotId__c!=null && !itemLotIds.Contains(lineEntry.dmpl__RelatedItemLotId__c))
                    itemLotIds.Add(lineEntry.dmpl__RelatedItemLotId__c);
            }
        }
        //
        SecurityHelper.ensureCanReadFields(new string[]{'dmpl__ItemId__c','dmpl__PurchaseDate__c','dmpl__RegistrationNumber__c','dmpl__SKUId__c','dmpl__ItemLotTypeId__c','dmpl__MRP__c','dmpl__DateOfSupplierInvoice__c','dmpl__DateOfReceipt__c','dmpl__SupplierInvoiceNumber__c','dmpl__BatchNo__c','dmpl__ComponentNumber__c','dmpl__DateOfExpiry__c','dmpl__Cost__c','dmpl__DateOfMfg__c','dmpl__SerialNumber__c','dmpl__DateOfSupplierDispatch__c'}, 'dmpl__ItemLot__c');
        return new Map<Id,dmpl__ItemLot__c>([SELECT id,
            dmpl__BatchNo__c,
            dmpl__ComponentNumber__c,
            dmpl__Cost__c,
            dmpl__DateOfExpiry__c,
            dmpl__PurchaseDate__c,
            dmpl__SerialNumber__c,
            dmpl__RegistrationNumber__c,
            dmpl__DateOfMfg__c,
            dmpl__DateOfSupplierDispatch__c,
            dmpl__DateOfSupplierInvoice__c,
            dmpl__SupplierInvoiceNumber__c,
            dmpl__DateOfReceipt__c,
            dmpl__ItemId__c,
            dmpl__MRP__c,
            Name,
            dmpl__SKUId__c,
            dmpl__ItemLotTypeId__c
            FROM dmpl__ItemLot__c WHERE id IN : itemLotIds]);
    }


    private static void validateItem(List<dmpl__TransferOutwardLine__c> newEntries){
        Map<Id, dmpl__Item__c> items = new Map<Id,dmpl__Item__c>(ItemHelper.getCachedItems(DocumentHelper.extractIds(newEntries, FIELD_TRANSFEROUTWARDLINE_ITEMID)));
        for(dmpl__TransferOutwardLine__c orderLine : newEntries){
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

    private static Map<Id, dmpl__TransferOutwardLine__c> getSourceTansferLines(List<dmpl__TransferInwardLine__c> newLineEntries, List<dmpl__TransferInwardLine__c> oldLineEntries)
    {
        List<ID> transferLineIds = new List<ID>();
        //
        if(newLineEntries!=null)
        {
            for(dmpl__TransferInwardLine__c lineEntry : newLineEntries)
            {
                if(lineEntry.dmpl__TransferOutwardLineId__c!=null)
                    transferLineIds.Add(lineEntry.dmpl__TransferOutwardLineId__c);
            }
        }
        if(oldLineEntries!=null)
        {
            for(dmpl__TransferInwardLine__c lineEntry : oldLineEntries)
            {
                if(lineEntry.dmpl__TransferOutwardLineId__c!=null)
                    transferLineIds.Add(lineEntry.dmpl__TransferOutwardLineId__c);
            }
        }
        //
       
        SecurityHelper.ensureCanReadFields(new string[]{'dmpl__ItemId__c','dmpl__ClosedQuantity__c','dmpl__SKUId__c','dmpl__ItemLotTypeId__c','dmpl__RelatedItemLotId__c','dmpl__ItemLotId__c','dmpl__Quantity__c'}, 'dmpl__TransferOutwardLine__c');
        return new Map<Id,dmpl__TransferOutwardLine__c>([SELECT id,
            dmpl__ItemId__c,    
            dmpl__SKUId__c,
            dmpl__ItemLotId__c,
            dmpl__ItemLotTypeId__c,
            dmpl__RelatedItemLotId__c,
            dmpl__Quantity__c,
            dmpl__ClosedQuantity__c
            FROM dmpl__TransferOutwardLine__c WHERE id IN : transferLineIds]);
    }
@testvisible
    private static List<dmpl__TransferOutwardLine__c> queryOutwardLines(List<Id>  documentIds)
    {
        SecurityHelper.ensureCanReadFields(new string[]{'dmpl__ItemId__c','dmpl__ItemLotTypeId__c','dmpl__RelatedBranchId__c','dmpl__BranchId__c','dmpl__IsILPosted__c','dmpl__IsILPostingApproved__c','dmpl__TransferId__c','dmpl__SKUId__c','dmpl__RelatedItemLotId__c','dmpl__ItemLotId__c','dmpl__Quantity__c','dmpl__UnitCost__c'}, 'dmpl__TransferOutwardLine__c');
        return [SELECT id,
            dmpl__ItemId__c,
            dmpl__SKUId__c,
            dmpl__RelatedItemLotId__c,
            dmpl__ItemLotId__c,
            dmpl__ItemLotTypeId__c,
            dmpl__Quantity__c,
            dmpl__UnitCost__c,
            dmpl__TransferId__c,
            dmpl__IsILPostingApproved__c,
            dmpl__IsILPosted__c,
            dmpl__BranchId__c,
            dmpl__RelatedBranchId__c
            FROM dmpl__TransferOutwardLine__c
            WHERE dmpl__TransferId__c IN :documentIds];
    }
@testvisible
    private static List<dmpl__TransferOutwardLine__c> queryOutwardLinesForLines(List<Id>  lineIds)
    {
        SecurityHelper.ensureCanReadFields(new string[]{'dmpl__ItemId__c','dmpl__ItemLotTypeId__c','dmpl__RelatedBranchId__c','dmpl__BranchId__c','dmpl__IsILPosted__c','dmpl__IsILPostingApproved__c','dmpl__TransferId__c','dmpl__SKUId__c','dmpl__RelatedItemLotId__c','dmpl__ItemLotId__c','dmpl__Quantity__c','dmpl__UnitCost__c'}, 'dmpl__TransferOutwardLine__c');
        return [SELECT id,
            dmpl__ItemId__c,
            dmpl__SKUId__c,
            dmpl__RelatedItemLotId__c,
            dmpl__ItemLotId__c,
            dmpl__ItemLotTypeId__c,
            dmpl__Quantity__c,
            dmpl__UnitCost__c,
            dmpl__TransferId__c,
            dmpl__IsILPostingApproved__c,
            dmpl__IsILPosted__c,
            dmpl__BranchId__c,
            dmpl__RelatedBranchId__c
            FROM dmpl__TransferOutwardLine__c
            WHERE Id IN :lineIds];
    }
}