public with sharing class TransferLineHelper {
    private static Boolean skipValidations = false;

    private static final string OBJECT_TRANSFER = 'dmpl__Transfer__c';
    private static final string FIELD_TRANSFERID = 'dmpl__TransferId__c';
    
    private static final string FIELD_TRANSFERLINE_ITEMID = 'dmpl__ItemId__c';
    private static final string FIELD_TRANSFERLINE_SKUID = 'dmpl__SKUId__c';
    private static final string FIELD_TRANSFERLINE_QUANTITY = 'dmpl__Quantity__c';
    private static final string FIELD_TRANSFERLINE_ISPOSTINGAPPROVED = 'dmpl__IsILPostingApproved__c';
    
    private static final string RELATION_TRANSFER_STATUS = 'dmpl__TransferId__r.dmpl__Status__c';

    private static final List<String> LIST_FIELDS_NONEDITABLE = new List<String>{

    };
    private static final List<String> LIST_FIELDS_SYSTEM = new List<String>{

    };
    private static final List<String> LIST_FIELDS_LOCKEDIFTRANSACTED = new List<String>{
        FIELD_TRANSFERLINE_ITEMID,
        FIELD_TRANSFERLINE_SKUID
    };

    private static final List<String> LIST_FIELDS_NEGATIVEANDZERONOTALLOWED = new List<String>{
        
    };
    
    private static final List<String> LIST_FIELDS_NEGATIVENOTALLOWED = new List<String>{
        'Quantity__c'
    };

    public static void validateData(
        Boolean isInsert, 
        Boolean isDelete, 
        Boolean isUpdate, 
        List<dmpl__TransferLine__c> oldEntries, 
        List<dmpl__TransferLine__c> newEntries)
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
                DocumentHelper.validateChangeInSystemFields(
                    LIST_FIELDS_SYSTEM, 
                    newEntries);
                dfsHelper.DocumentStatusRelatedObjectRestrictEdits_New(
                    OBJECT_TRANSFER, 
                    FIELD_TRANSFERLINE_ITEMID, 
                    RELATION_TRANSFER_STATUS, 
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
                dfsHelper.DocumentStatusRelatedObjectRestrictEdits_Edit(
                    OBJECT_TRANSFER, 
                    FIELD_TRANSFERLINE_ITEMID, 
                    RELATION_TRANSFER_STATUS, 
                    oldEntries, 
                    newEntries);
            }else if(isDelete){
                DocumentHelper.validateCanBeDeleted(
                    oldEntries, 
                    FIELD_TRANSFERLINE_QUANTITY);
                dfsHelper.DocumentStatusRelatedObjectRestrictEdits_Delete(
                    OBJECT_TRANSFER, 
                    FIELD_TRANSFERLINE_ITEMID, 
                    RELATION_TRANSFER_STATUS, 
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
        List<dmpl__TransferLine__c> oldEntries, 
        List<dmpl__TransferLine__c> newEntries)
    {
        try{
            postTransferLine(isInsert, isDelete, isUpdate, oldEntries, newEntries);
            List<dmpl__TransferLine__c> modifiedObjects = DocumentHelper.getApprovedObjects(
                FIELD_TRANSFERLINE_ISPOSTINGAPPROVED, 
                oldEntries, 
                newEntries);
            if(modifiedObjects.size() > 0)
            {
                InventoryLedgerHelper.createLedger(
                    InventoryLedgerTypeEnums.TransferOutward, 
                    FIELD_TRANSFERID,OBJECT_TRANSFER, 
                    isInsert, 
                    isDelete, 
                    isUpdate, 
                    oldEntries, 
                    newEntries); 
                InventoryLedgerHelper.createLedger(
                    InventoryLedgerTypeEnums.TransferInward, 
                    FIELD_TRANSFERID, 
                    OBJECT_TRANSFER, 
                    isInsert, 
                    isDelete, 
                    isUpdate, 
                    oldEntries, 
                    modifiedObjects);     
                InventoryLedgerHelper.createLedger(
                    InventoryLedgerTypeEnums.Damaged,
                    FIELD_TRANSFERID, OBJECT_TRANSFER, 
                    isInsert, 
                    isDelete, 
                    isUpdate, 
                    oldEntries,
                    modifiedObjects);
                InventoryLedgerHelper.createLedger(
                    InventoryLedgerTypeEnums.Shortage, FIELD_TRANSFERID, 
                    OBJECT_TRANSFER, 
                    isInsert, 
                    isDelete, 
                    isUpdate,
                    oldEntries, 
                    modifiedObjects);
                InventoryLedgerHelper.createLedger(
                    InventoryLedgerTypeEnums.Excess, 
                    FIELD_TRANSFERID, 
                    OBJECT_TRANSFER, 
                    isInsert, 
                    isDelete, 
                    isUpdate, 
                    oldEntries, 
                    modifiedObjects);                  
            }
        } catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }

    @testVisible
    public static CreateRelatedResult postIL(
        Id documentId){
        return postTransferLinesInternal(
            queryTransferLines(
                new List<Id>{documentId}));
    }

    @testVisible
    public static CreateRelatedResult postIL(
        List<SourceObjectInfo> orderLinesInfo, 
        Id documentId){
        return postTransferLinesInternal(
            queryTransferLinesForLines(
                SourceObjectInfo.extractIds(orderLinesInfo)));
    }

    public static void postTransferLines(List<dmpl__Transfer__c> transfers){
        List<dmpl__TransferLine__c> transferLines = queryTransferLines(transfers);
            for(dmpl__TransferLine__c transferLine : transferLines){
                transferLine.dmpl__IsILPostingApproved__c = true;
            }

            try {
                skipValidations = true;
                SecurityHelper.ensureCanWriteFields(new string[]{'dmpl__IsILPosted__c','dmpl__IsILPostingApproved__c'}, 'dmpl__TransferLine__c');
                update transferLines;            
            } finally {
                skipValidations = false;
            }
        }

    public static CreateRelatedResult postTransferLinesInternal(List<dmpl__TransferLine__c> transferLines)
    {
        SecurityHelper.ensureCanWriteField('dmpl__IsILPostingApproved__c', 'dmpl__TransferLine__c');
        for(dmpl__TransferLine__c transferLine : transferLines){
            transferLine.dmpl__IsILPostingApproved__c = true;
        }
        try {
            skipValidations = true;
            SecurityHelper.ensureCanWriteFields(new string[]{'dmpl__IsILPosted__c','dmpl__IsILPostingApproved__c'}, 'dmpl__TransferLine__c');
            return CreateRelatedResult.InitFrom(Database.update(transferLines));          
        } finally {
            skipValidations = false;
        }
    }

    private static void postTransferLine(
        Boolean isInsert, 
        Boolean isDelete, 
        Boolean isUpdate, 
        List<dmpl__TransferLine__c> oldEntries, 
        List<dmpl__TransferLine__c> newEntries)
    {
        Map<Id, dmpl__ItemLot__c> itemLots = getRelatedLots(
            newEntries, 
            oldEntries);
        List<dmpl__ItemLot__c> insertedItemLots = new List<dmpl__ItemLot__c>();
        List<dmpl__ItemLot__c> updatedItemLots = new List<dmpl__ItemLot__c>();
        Map<ID, dmpl__Transfer__c> transferDocuments = queryTransferDocuments(
            DocumentHelper.extractIds(
                newEntries, 
                FIELD_TRANSFERID));
        if(isInsert || isUpdate){
            for(dmpl__TransferLine__c lineEntry : newEntries){
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
                dmpl__ItemLot__c oldItemLot = null;
                if(isUpdate){
                    dmpl__TransferLine__c oldEntry = getOldTransferLine(oldEntries, lineEntry);
                    oldItemLot = itemLots.get(oldEntry.dmpl__RelatedItemLotId__c);
                }
                If(lineEntry.dmpl__RelatedItemLotId__c == null){
                dmpl__ItemLot__c itemLot = createItemLot(
                    lineEntry, 
                    sourceItemLot, 
                    oldItemLot, 
                    transferDocument);
                if(itemLot!=null){
                    lineEntry.dmpl__RelatedItemLotId__r = itemLot;
                    if(itemLot.Id !=null)
                        updatedItemLots.Add(itemLot);
                    else
                        insertedItemLots.Add(itemLot);
                    }
                }
            }
            try {
                ItemLotHelper.skipValidations = true;
                TransferLineHelper.skipValidations = true;
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
                TransferLineHelper.skipValidations = false;
            }
            for(dmpl__TransferLine__c lineEntry : newEntries){
                if(lineEntry.dmpl__RelatedItemLotId__r!=null){
                    SecurityHelper.ensureCanWriteField('dmpl__RelatedItemLotId__c','dmpl__TransferOutwardLine__c');
                    lineEntry.dmpl__RelatedItemLotId__c = lineEntry.dmpl__RelatedItemLotId__r.Id;
                }
            }
        }
    }

    private static Map<Id, dmpl__ItemLot__c> getRelatedLots(
        List<dmpl__TransferLine__c> newLineEntries, 
        List<dmpl__TransferLine__c> oldLineEntries)
    {
        List<ID> itemLotIds = new List<ID>();
        if(newLineEntries!=null)
        {
            for(dmpl__TransferLine__c lineEntry : newLineEntries)
            {
                if(lineEntry.dmpl__ItemLotId__c!=null && !itemLotIds.Contains(lineEntry.dmpl__ItemLotId__c))
                    itemLotIds.Add(lineEntry.dmpl__ItemLotId__c);
                if(lineEntry.dmpl__RelatedItemLotId__c!=null && !itemLotIds.Contains(lineEntry.dmpl__RelatedItemLotId__c))
                    itemLotIds.Add(lineEntry.dmpl__RelatedItemLotId__c);
            }
        }
        if(oldLineEntries!=null)
        {
            for(dmpl__TransferLine__c lineEntry : oldLineEntries)
            {
                if(!itemLotIds.Contains(lineEntry.dmpl__ItemLotId__c))
                    itemLotIds.Add(lineEntry.dmpl__ItemLotId__c);
                if(lineEntry.dmpl__RelatedItemLotId__c!=null && !itemLotIds.Contains(lineEntry.dmpl__RelatedItemLotId__c))
                    itemLotIds.Add(lineEntry.dmpl__RelatedItemLotId__c);
            }
        }
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

    private static dmpl__TransferLine__c getOldTransferLine(
        List<dmpl__TransferLine__c> oldEntries,
        dmpl__TransferLine__c lineEntry)
    {
        for(dmpl__TransferLine__c oldEntry : oldEntries)
            if(oldEntry.Id == lineEntry.Id )            
                return oldEntry;
        return null;
    }

    private static dmpl__ItemLot__c createItemLot(
        dmpl__TransferLine__c sourceEntry, 
        dmpl__ItemLot__c sourceItemLot, 
        dmpl__ItemLot__c oldItemLot, 
        dmpl__Transfer__c transferDocument) 
    {
        dmpl__ItemLot__c itemLot = oldItemLot;
        if(itemLot == null)
        {
            itemLot = new dmpl__ItemLot__c();
            itemLot.dmpl__StorageLocationId__c = sourceEntry.dmpl__RelatedStorageLocationId__c;
        }
        if(transferDocument.dmpl__ToPartnerAccountId__c != null){
            itemLot.dmpl__PartnerAccountId__c = transferDocument.dmpl__ToPartnerAccountId__c;
        }else{
            itemLot.dmpl__PartnerAccountId__c = transferDocument.dmpl__PartnerAccountId__c;
        }
        itemLot.dmpl__BranchId__c = transferDocument.dmpl__ToBranchId__c;
        itemLot.dmpl__RelatedItemLotId__c = sourceItemLot.Id;
        itemLot.dmpl__RelatedItemLotId__r = sourceItemLot;
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

    private static List<dmpl__TransferLine__c> queryTransferLinesForLines(
        List<ID> transferIds)
    {
        SecurityHelper.ensureCanReadFields(new List<String>
        {
            'Name', 
            'dmpl__ItemId__c',
            'dmpl__SKUId__c',
            'dmpl__Quantity__c',
            'dmpl__TransferrId__c'
        },'dmpl__TransferLine__c');
        return [ SELECT ID, 
            Name, 
            dmpl__ItemId__c,
            dmpl__SKUId__c,
            dmpl__Quantity__c,
            dmpl__IsILPostingApproved__c,
            dmpl__IsILPosted__c
        FROM dmpl__TransferLine__c
        WHERE Id IN : transferIds];
    }

    private static List<dmpl__TransferLine__c> queryTransferLines(
        List<ID> transferLineIds)
    {
        SecurityHelper.ensureCanReadFields(new List<String>
        {
            'Name', 
            'dmpl__IsILPostingApproved__c',
            'dmpl__IsILPosted__c'
        },'dmpl__TransferLine__c');
        return [ SELECT ID, 
            Name, 
            dmpl__IsILPostingApproved__c,
            dmpl__IsILPosted__c
        FROM dmpl__TransferLine__c
        WHERE dmpl__TransferId__c IN : transferLineIds];
    }   
    private static List<dmpl__TransferLine__c> queryTransferLines(
        List<dmpl__Transfer__c> transferLineIds)
    {
        SecurityHelper.ensureCanReadFields(new List<String>
        {
            'Name', 
            'dmpl__IsILPostingApproved__c',
            'dmpl__IsILPosted__c'
        },'dmpl__TransferLine__c');
        return [ SELECT ID, 
            Name, 
            dmpl__IsILPostingApproved__c,
            dmpl__IsILPosted__c
        FROM dmpl__TransferLine__c
        WHERE dmpl__TransferId__c IN : transferLineIds];
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
}