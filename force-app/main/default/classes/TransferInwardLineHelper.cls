public with sharing class TransferInwardLineHelper {
    private static Boolean skipValidations = false;

    private static final string OBJECT_TRANSFER = 'dmpl__Transfer__c';
    private static final string OBJECT_TRANSFERINWARDLINE = 'dmpl__TransferOutwardLine__c';
    private static final string FIELD_TRANSFERINWARDTRANSFERID = 'dmpl__TransferId__c';
    
    private static final string FIELD_TRANSFERINWARDLINE_ITEMID = 'dmpl__ItemId__c';
    private static final string FIELD_TRANSFERINWARDLINE_SKUID = 'dmpl__SKUId__c';
    private static final string FIELD_TRANSFERINWARDLINE_QUANTITY = 'dmpl__Quantity__c';
    private static final string FIELD_TRANSFERINWARDLINE_ISAPPROVED = 'dmpl__IsApproved__c';

    private static final string RELATION_TRANSFER_STATUS = 'dmpl__TransferId__r.dmpl__Status__c';

    private static final List<String> LIST_FIELDS_NONEDITABLE = new List<String>{

    };
    private static final List<String> LIST_FIELDS_SYSTEM = new List<String>{

    };
    private static final List<String> LIST_FIELDS_LOCKEDIFTRANSACTED = new List<String>{
        FIELD_TRANSFERINWARDLINE_ITEMID,
        FIELD_TRANSFERINWARDLINE_SKUID
    };

    private static final List<String> LIST_FIELDS_NEGATIVEANDZERONOTALLOWED = new List<String>{
        
    };
    
    private static final List<String> LIST_FIELDS_NEGATIVENOTALLOWED = new List<String>{
        'Quantity__c'
    };

    public static void validateData(Boolean isInsert, Boolean isDelete, Boolean isUpdate, List<dmpl__TransferInwardLine__c> oldEntries, List<dmpl__TransferInwardLine__c> newEntries)
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
                dfsHelper.DocumentStatusRelatedObjectRestrictEdits_New(OBJECT_TRANSFER, FIELD_TRANSFERINWARDLINE_ITEMID, RELATION_TRANSFER_STATUS, newEntries);
            }else if(isUpdate){
                DocumentHelper.validateChangeInSystemFields(LIST_FIELDS_SYSTEM, oldEntries, newEntries);
                DocumentHelper.validateChangeInKeyFields(LIST_FIELDS_NONEDITABLE, oldEntries, newEntries);
                dfsHelper.DocumentStatusRelatedObjectRestrictEdits_Edit(OBJECT_TRANSFER, FIELD_TRANSFERINWARDLINE_ITEMID, RELATION_TRANSFER_STATUS, oldEntries, newEntries);
            }else if(isDelete){
                DocumentHelper.validateCanBeDeleted(oldEntries, FIELD_TRANSFERINWARDLINE_QUANTITY);
                dfsHelper.DocumentStatusRelatedObjectRestrictEdits_Delete(OBJECT_TRANSFER, FIELD_TRANSFERINWARDLINE_ITEMID, RELATION_TRANSFER_STATUS, oldEntries);
            }
        }catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }

    public static void postData(Boolean isInsert, Boolean isDelete, Boolean isUpdate, List<dmpl__TransferInwardLine__c> oldEntries, List<dmpl__TransferInwardLine__c> newEntries)
    {
        try{
            if(isInsert){
                setStock(newEntries);
            }
            TransferOutwardLineHelper.updateOutwardTransferLine(isInsert, isDelete, isUpdate, oldEntries, newEntries);
            List<dmpl__TransferInwardLine__c> modifiedObjects = DocumentHelper.getApprovedObjects(
                FIELD_TRANSFERINWARDLINE_ISAPPROVED, 
                oldEntries, 
                newEntries);
            if(modifiedObjects.size() > 0)
            {
            InventoryLedgerHelper.createLedger(
                InventoryLedgerTypeEnums.TransferInward, 
                FIELD_TRANSFERINWARDTRANSFERID, 
                OBJECT_TRANSFER, 
                isInsert, 
                isDelete, 
                isUpdate, 
                oldEntries, 
                newEntries);
            InventoryLedgerHelper.createLedger(
                InventoryLedgerTypeEnums.Damaged, 
                FIELD_TRANSFERINWARDTRANSFERID, 
                OBJECT_TRANSFER, 
                isInsert, 
                isDelete, 
                isUpdate, 
                oldEntries, 
                newEntries);
            InventoryLedgerHelper.createLedger(
                InventoryLedgerTypeEnums.Shortage, 
                FIELD_TRANSFERINWARDTRANSFERID, 
                OBJECT_TRANSFER, 
                isInsert, 
                isDelete, 
                isUpdate, 
                oldEntries, 
                newEntries); 
            InventoryLedgerHelper.createLedger(
                InventoryLedgerTypeEnums.Excess, 
                FIELD_TRANSFERINWARDTRANSFERID, 
                OBJECT_TRANSFER, 
                isInsert, 
                isDelete, 
                isUpdate, 
                oldEntries, 
                newEntries);  
            }
        }catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }


    public static CreateRelatedResult receiveInwardDocument(Id documentId){
        return receiveInwardDocument(
            queryOutwardLines(new List<Id>{documentId}));
    }

    public static CreateRelatedResult receiveInwardDocument(
        List<SourceObjectInfo> orderLinesInfo, 
        Id documentId){
        return receiveInwardDocument(
            queryOutwardLinesForLines(SourceObjectInfo.extractIds(orderLinesInfo)));
    }

    public static CreateRelatedResult receiveInwardDocument(List<dmpl__Transfer__c> documents){
            return receiveInwardDocument(
                queryOutwardLines(DocumentHelper.extractIds(documents)));
    }

    public static CreateRelatedResult receiveInwardDocument(
        List<dmpl__TransferOutwardLine__c> outwardLines){
        List<dmpl__TransferInwardLine__c> createdInwardLines = new List<dmpl__TransferInwardLine__c>();
        for(dmpl__TransferOutwardLine__c line : outwardLines){
            dmpl__TransferInwardLine__c inwardLine = createInwardLine(line);
            createdInwardLines.Add(inwardLine);
        }
        try {
            TransferInwardLineHelper.skipValidations = true;
            SecurityHelper.ensureCanCreateObject('dmpl__TransferInwardLine__c');
            SecurityHelper.ensureCanCreateFields(new string[]{'dmpl__ItemId__c','dmpl__RelatedBranchId__c','dmpl__BranchId__c','dmpl__IsILPosted__c','dmpl__IsILPostingApproved__c','dmpl__TransferId__c','dmpl__SKUId__c','dmpl__ItemLotTypeId__c','dmpl__RelatedItemLotId__c','dmpl__ItemLotId__c','dmpl__Quantity__c','dmpl__UnitCost__c'}, 'dmpl__TransferInwardLine__c');
            List<Database.SaveResult> results = Database.insert(createdInwardLines); 
            TransferOutwardLineHelper.updateClosedQuantity(
                DocumentHelper.extractIdsFromLookup(
                    outwardLines, 
                    'dmpl__TransferId__r',
                    'dmpl__InwardDocumentId__c'));
            return CreateRelatedResult.InitFrom(results);
        } finally {
            TransferInwardLineHelper.skipValidations = false;
        }
    }

    public static CreateRelatedResult postInwardDocument(Id documentId){
        return postInwardDocument(queryInwardLines(new List<Id>{documentId}));
    }

    public static CreateRelatedResult postInwardDocument(List<SourceObjectInfo> orderLinesInfo, Id documentId){
        return postInwardDocument(queryInwardLinesForLines(SourceObjectInfo.extractIds(orderLinesInfo)));
    }

    public static CreateRelatedResult postInwardDocument(List<dmpl__Transfer__c> documents){
        return postInwardDocument(queryInwardLines(DocumentHelper.extractIds(documents)));
    }

    public static CreateRelatedResult postInwardDocument(List<dmpl__TransferInwardLine__c> inwardLines)
    {
        for(dmpl__TransferInwardLine__c line : inwardLines){
            line.dmpl__IsILPostingApproved__c = true;
            line.dmpl__IsApproved__c = true;
        }
        //
        try {
            skipValidations = true;
            SecurityHelper.ensureCanWriteFields(new string[]{'dmpl__ItemId__c','dmpl__RelatedBranchId__c','dmpl__BranchId__c','dmpl__IsILPosted__c','dmpl__IsILPostingApproved__c','dmpl__SKUId__c','dmpl__ItemLotTypeId__c','dmpl__RelatedItemLotId__c','dmpl__ItemLotId__c','dmpl__Quantity__c','dmpl__UnitCost__c'}, 'dmpl__TransferInwardLine__c');
            return CreateRelatedResult.InitFrom(Database.update(inwardLines));
        } finally {
            skipValidations = false;
        }
    }

    @testvisible
    private static dmpl__TransferInwardLine__c createInwardLine(
        dmpl__TransferOutwardLine__c outwardLine)
    {
        dmpl__TransferInwardLine__c inwardLine = new dmpl__TransferInwardLine__c();
        inwardLine.dmpl__BranchId__c = outwardLine.dmpl__RelatedBranchId__c;
        inwardLine.dmpl__RelatedBranchId__c = outwardLine.dmpl__BranchId__c;
        inwardLine.dmpl__ItemId__c = outwardLine.dmpl__ItemId__c;
        inwardLine.dmpl__SKUId__c = outwardLine.dmpl__SKUId__c;
        inwardLine.dmpl__ItemLotTypeId__c = outwardLine.dmpl__ItemLotTypeId__c;
        inwardLine.dmpl__ItemLotId__c = outwardLine.dmpl__RelatedItemLotId__c;
        inwardLine.dmpl__Quantity__c = outwardLine.dmpl__Quantity__c;
        inwardLine.dmpl__ReceivedQuantity__c = outwardLine.dmpl__Quantity__c;
        inwardLine.dmpl__UnitCost__c = outwardLine.dmpl__UnitCost__c;
        inwardLine.dmpl__TransferOutwardLineId__c = outwardLine.Id;
        inwardLine.dmpl__TransferId__c = outwardLine.dmpl__TransferId__r.dmpl__InwardDocumentId__c;
        inwardLine.dmpl__TransferType__c = outwardLine.dmpl__TransferType__c;
        //
        return inwardLine;
    }


    private static void validateItem(List<dmpl__TransferInwardLine__c> newEntries){
        Map<Id, dmpl__Item__c> items = new Map<Id,dmpl__Item__c>(ItemHelper.getCachedItems(DocumentHelper.extractIds(newEntries, FIELD_TRANSFERINWARDLINE_ITEMID)));
        for(dmpl__TransferInwardLine__c orderLine : newEntries){
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

    private static void setStock(List<dmpl__TransferInwardLine__c> newEntries){
        List<dmpl__InventoryStock__c> stocks = [SELECT 
                Id,
                dmpl__ItemId__c,
                dmpl__SKUId__c,
                dmpl__ItemLotTypeId__c
            FROM 
                dmpl__InventoryStock__c 
            WHERE 
                dmpl__ItemId__c IN : CollectionHelper.extractIds(newEntries, 'dmpl__ItemId__c')
                AND dmpl__BranchId__c IN : CollectionHelper.extractIds(newEntries, 'dmpl__BranchId__c')
                ];
        for(dmpl__TransferInwardLine__c entry :  newEntries){
            for(dmpl__InventoryStock__c stock : stocks){
                if(stock.dmpl__ItemId__c == entry.dmpl__ItemId__c
                    && stock.dmpl__SKUId__c == entry.dmpl__SKUId__c
                    && stock.dmpl__ItemLotTypeId__c == entry.dmpl__ItemLotTypeId__c){
                        entry.dmpl__InventoryStockId__c = stock.Id;
                        break;
                    }
            }
        }
    }

    private static List<dmpl__TransferOutwardLine__c> queryOutwardLines(List<Id>  documentIds)
    {
        SecurityHelper.ensureCanReadFields(new string[]{'dmpl__ItemId__c','dmpl__RelatedBranchId__c','dmpl__BranchId__c','dmpl__IsILPosted__c','dmpl__IsILPostingApproved__c','dmpl__TransferId__c','dmpl__SKUId__c','dmpl__ItemLotTypeId__c','dmpl__RelatedItemLotId__c','dmpl__ItemLotId__c','dmpl__Quantity__c','dmpl__UnitCost__c'}, 'dmpl__TransferOutwardLine__c');
        return [SELECT 
            Id,
            dmpl__TransferId__c,
            dmpl__ItemId__c,
            dmpl__SKUId__c,
            dmpl__ItemLotTypeId__c,
            dmpl__RelatedItemLotId__c,
            dmpl__ItemLotId__c,
            dmpl__Quantity__c,
            dmpl__UnitCost__c,
            dmpl__IsILPostingApproved__c,
            dmpl__IsILPosted__c,
            dmpl__BranchId__c,
            dmpl__RelatedBranchId__c,
            dmpl__TransferType__c,
            dmpl__TransferId__r.dmpl__InwardDocumentId__c
            FROM dmpl__TransferOutwardLine__c
            WHERE dmpl__TransferId__r.dmpl__InwardDocumentId__c IN :documentIds];
    }

    private static List<dmpl__TransferOutwardLine__c> queryOutwardLinesForLines(List<Id>  lineIds)
    {
        SecurityHelper.ensureCanReadFields(new string[]{'dmpl__ItemId__c','dmpl__RelatedBranchId__c','dmpl__BranchId__c','dmpl__IsILPosted__c','dmpl__IsILPostingApproved__c','dmpl__TransferId__c','dmpl__SKUId__c','dmpl__ItemLotTypeId__c','dmpl__RelatedItemLotId__c','dmpl__ItemLotId__c','dmpl__Quantity__c','dmpl__UnitCost__c'}, 'dmpl__TransferOutwardLine__c');
        return [SELECT 
            Id,
            dmpl__TransferId__c,
            dmpl__ItemId__c,
            dmpl__SKUId__c,
            dmpl__ItemLotTypeId__c,
            dmpl__RelatedItemLotId__c,
            dmpl__ItemLotId__c,
            dmpl__Quantity__c,
            dmpl__UnitCost__c,
            dmpl__IsILPostingApproved__c,
            dmpl__IsILPosted__c,
            dmpl__BranchId__c,
            dmpl__RelatedBranchId__c,
            dmpl__TransferType__c,
            dmpl__TransferId__r.dmpl__InwardDocumentId__c
            FROM dmpl__TransferOutwardLine__c
            WHERE Id IN :lineIds];
    }

    private static List<dmpl__TransferInwardLine__c> queryInwardLines(List<Id> documentIds)
    {
        SecurityHelper.ensureCanReadFields(new string[]{'dmpl__ItemId__c','dmpl__RelatedBranchId__c','dmpl__BranchId__c','dmpl__IsILPosted__c','dmpl__IsILPostingApproved__c','dmpl__TransferId__c','dmpl__SKUId__c','dmpl__ItemLotTypeId__c','dmpl__RelatedItemLotId__c','dmpl__ItemLotId__c','dmpl__Quantity__c','dmpl__UnitCost__c'}, 'dmpl__TransferInwardLine__c');
      
        return [SELECT id,
            dmpl__ItemId__c,
            dmpl__SKUId__c,
            dmpl__ItemLotTypeId__c,
            dmpl__RelatedItemLotId__c,
            dmpl__ItemLotId__c,
            dmpl__Quantity__c,
            dmpl__TransferId__c,
            dmpl__IsILPostingApproved__c,
            dmpl__IsILPosted__c,
            dmpl__BranchId__c,
            dmpl__UnitCost__c,
            dmpl__RelatedBranchId__c
            FROM dmpl__TransferInwardLine__c
            WHERE dmpl__TransferId__c IN :documentIds];
    }


    private static List<dmpl__TransferInwardLine__c> queryInwardLinesForLines(List<Id> lineIds)
    {
        SecurityHelper.ensureCanReadFields(new string[]{'dmpl__ItemId__c','dmpl__RelatedBranchId__c','dmpl__BranchId__c','dmpl__IsILPosted__c','dmpl__IsILPostingApproved__c','dmpl__TransferId__c','dmpl__SKUId__c','dmpl__ItemLotTypeId__c','dmpl__RelatedItemLotId__c','dmpl__ItemLotId__c','dmpl__Quantity__c','dmpl__UnitCost__c'}, 'dmpl__TransferInwardLine__c');
      
        return [SELECT id,
            dmpl__ItemId__c,
            dmpl__SKUId__c,
            dmpl__ItemLotTypeId__c,
            dmpl__RelatedItemLotId__c,
            dmpl__ItemLotId__c,
            dmpl__Quantity__c,
            dmpl__TransferId__c,
            dmpl__IsILPostingApproved__c,
            dmpl__IsILPosted__c,
            dmpl__BranchId__c,
            dmpl__UnitCost__c,
            dmpl__RelatedBranchId__c
            FROM dmpl__TransferInwardLine__c
            WHERE Id IN :lineIds];
    }
    
}