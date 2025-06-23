public with sharing class TransferHelper {
    private static Boolean skipValidations = false;

    private static final string OBJECT_TRANSFER = 'dmpl__Transfer__c';
    private static final string FIELD_TRANSFER_STATUS = 'dmpl__Status__c';
    private static final string FIELD_TRANSFER_PARTNERACCOUNTID = 'dmpl__PartnerAccountId__c';
    private static final string FIELD_TRANSFER_BRANCHID = 'dmpl__BranchId__c';
    private static final string FIELD_TRANSFER_DOCUMENTDATE ='dmpl__DocumentDate__c';
    private static final string FIELD_TRANSFER_PERFORMOUTWARDRELEASE ='dmpl__PerformOutwardRelease__c';
    private static final string FIELD_TRANSFER_ISOUTWARDRELEASE ='dmpl__IsOutwardReleased__c';
    private static final string FIELD_TRANSFER_PERFROMINWARDRECEIVE ='dmpl__PerformInwardReceive__c';
    private static final string FIELD_TRANSFER_ISINWARDRECEIVED ='dmpl__IsInwardReceived__c';
    private static final string FIELD_TRANSFER_PERFROMINWARDPOSTING ='dmpl__PerformInwardPosting__c';
    private static final string FIELD_TRANSFER_ISINWARDPOSTED ='dmpl__IsInwardPosted__c';
    private static final string FIELD_TRANSFER_PERFORMILPOSTING ='dmpl__PerformILPosting__c';
    private static final string FIELD_TRANSFER_TRANSFERREDBYID = 'dmpl__TransferredById__c';
    private static final string FIELD_TRANSFER_RECEIVEDBYID = 'dmpl__ReceivedById__c';
    
    private static final List<String> LIST_NON_EDITABLE_FIELDS = new List<String>{
        FIELD_TRANSFER_BRANCHID, 
        FIELD_TRANSFER_DOCUMENTDATE, 
        FIELD_TRANSFER_PARTNERACCOUNTID,
        'dmpl__Type__c'};
    private static final List<String> LIST_FIELDS_SYSTEM = new List<String>{
        'dmpl__OutwardDocumentId__c',
        'dmpl__InwardDocumentId__c',
        FIELD_TRANSFER_ISINWARDPOSTED};
   
    public static void validateData(
        Boolean isInsert, 
        Boolean isDelete, 
        Boolean isUpdate, 
        List<dmpl__Transfer__c> oldEntries, 
        List<dmpl__Transfer__c> newEntries){
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
                    StatusHelper.validateStatusNew(
                        OBJECT_TRANSFER, 
                        FIELD_TRANSFER_STATUS, 
                        newEntries);
                    DocumentHelper.validateChangeInSystemFields(
                        LIST_FIELDS_SYSTEM, 
                        newEntries);
                    ValidationHelper.validatePartnerAndBranch(
                        FIELD_TRANSFER_PARTNERACCOUNTID, 
                        FIELD_TRANSFER_BRANCHID, 
                        newEntries);
                    ValidationHelper.validateResource(
                        FIELD_TRANSFER_TRANSFERREDBYID, 
                        newEntries);
                    ValidationHelper.validateResource(
                        FIELD_TRANSFER_RECEIVEDBYID, 
                        newEntries);
                }else if(isUpdate){
                    StatusHelper.validateStatusEdit(
                        OBJECT_TRANSFER, 
                        FIELD_TRANSFER_STATUS, 
                        oldEntries, 
                        newEntries);
                    DocumentHelper.validateChangeInKeyFields(
                        LIST_NON_EDITABLE_FIELDS, 
                        oldEntries, 
                        newEntries);
                    DocumentHelper.validateChangeInSystemFields(
                        LIST_FIELDS_SYSTEM, 
                        oldEntries, 
                        newEntries);
                    ValidationHelper.validateResource(
                        FIELD_TRANSFER_TRANSFERREDBYID, 
                        newEntries);
                    ValidationHelper.validateResource(
                        FIELD_TRANSFER_RECEIVEDBYID, 
                        newEntries);
                    dfsHelper.DocumentStatusRestrictEdits_Edit(
                        OBJECT_TRANSFER, 
                        FIELD_TRANSFER_STATUS, 
                        oldEntries, 
                        newEntries);
                    dfsHelper.DocumentStatusRestrictFieldsEdits(
                        OBJECT_TRANSFER, 
                        FIELD_TRANSFER_STATUS, 
                        oldEntries, 
                        newEntries);
                }else if(isDelete){
                    dfsHelper.DocumentStatusRestrictEdits_Delete(
                        OBJECT_TRANSFER, 
                        FIELD_TRANSFER_STATUS, 
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
        List<dmpl__Transfer__c> oldEntries, 
        List<dmpl__Transfer__c> newEntries){
            try{
                DocumentStatusDFSHelper dfsHelper = new DocumentStatusDFSHelper();
                if(isInsert){
                    DocumentNameHelper.generateDocumentName(
                        newEntries);
                }
                    
                if(isUpdate){
                    dfsHelper.DocumentStatusSetFlag(
                        OBJECT_TRANSFER, 
                        FIELD_TRANSFER_STATUS, 
                        oldEntries, 
                        newEntries);
                    dfsHelper.DocumentStatusReSetFlag(
                        OBJECT_TRANSFER, 
                        FIELD_TRANSFER_STATUS, 
                        oldEntries, 
                        newEntries);
                    List<dmpl__Transfer__c> modifiedDocs = DocumentHelper.getApprovedObjects(
                        FIELD_TRANSFER_PERFORMOUTWARDRELEASE, 
                        oldEntries,
                        newEntries);
                    if(modifiedDocs.size()>0){
                        releaseOutwardDocument(
                            modifiedDocs);
                    }
                    List<dmpl__Transfer__c> modifiedObjects = DocumentHelper.getApprovedObjects(
                        FIELD_TRANSFER_PERFORMILPOSTING, 
                        oldEntries, 
                        newEntries);
                        if(modifiedObjects.size()>0){
                            PostIL(modifiedObjects);
                        }
                    List<dmpl__Transfer__c> modifiedInwardReceiveDocs = DocumentHelper.getApprovedObjects(
                        FIELD_TRANSFER_PERFROMINWARDRECEIVE, 
                        oldEntries,
                        newEntries);
                    if(modifiedInwardReceiveDocs.size()>0){
                        receiveInwardDocument(
                            modifiedInwardReceiveDocs);
                    }

                    List<dmpl__Transfer__c> modifiedInwardPostingDocs = DocumentHelper.getApprovedObjects(
                        FIELD_TRANSFER_PERFROMINWARDPOSTING, 
                        oldEntries,
                        newEntries);
                    if(modifiedInwardPostingDocs.size()>0){
                        postInwardDocument(
                            modifiedInwardPostingDocs);
                    }
                }
            }catch (Exception error) {
                ExceptionLogHelper.logException(error);
                throw error;
            }
    }

    public static CreateRelatedResult releaseOutwardDocument(Id documentId){
        List<dmpl__Transfer__c> modifiedDocs = queryTransferDocuments(new List<Id>{ documentId });
        releaseOutwardDocumentInternal(modifiedDocs);
        try {
            skipValidations = true;
            update modifiedDocs;        
        } finally {
            skipValidations = false;
        }
        return TransferOutwardLineHelper.releaseOutwardDocument(documentId);
    }

    public static CreateRelatedResult releaseOutwardDocument(List<SourceObjectInfo> orderLinesInfo, Id documentId){
        List<dmpl__Transfer__c> modifiedDocs = queryTransferDocuments(new List<Id>{ documentId });
        releaseOutwardDocumentInternal(modifiedDocs);
        try {
            skipValidations = true;
            update modifiedDocs;        
        } finally {
            skipValidations = false;
        }
        return TransferOutwardLineHelper.releaseOutwardDocument(orderLinesInfo, documentId);
    }

    public static void releaseOutwardDocument(List<dmpl__Transfer__c> modifiedDocs){
        TransferOutwardLineHelper.releaseOutwardDocument(modifiedDocs);
        releaseOutwardDocumentInternal(modifiedDocs);
    }
	@testVisible
    private static void releaseOutwardDocumentInternal(List<dmpl__Transfer__c> modifiedDocs){
        createInwardDocument(modifiedDocs);
        SecurityHelper.ensureCanWriteField(
            'dmpl__PerformOutwardRelease__c', 
            'dmpl__Transfer__c');
        SecurityHelper.ensureCanWriteField(
            'dmpl__IsOutwardReleased__c', 
            'dmpl__Transfer__c');
        for(dmpl__Transfer__c document : modifiedDocs){
            document.dmpl__PerformOutwardRelease__c = false;
            document.dmpl__IsOutwardReleased__c = true;
        }
    }

    public static CreateRelatedResult receiveInwardDocument(Id documentId){
        List<dmpl__Transfer__c> modifiedDocs = queryTransferDocuments(
            new List<Id>{ documentId });
        receiveInwardDocumentInternal(
            modifiedDocs);
        try {
            skipValidations = true;
            update modifiedDocs;        
        } finally {
            skipValidations = false;
        }
        return TransferInwardLineHelper.receiveInwardDocument(
            modifiedDocs);
    }

    public static CreateRelatedResult receiveInwardDocument(
        List<SourceObjectInfo> orderLinesInfo, 
        Id documentId){
            List<dmpl__Transfer__c> modifiedDocs = queryTransferDocuments(
                new List<Id>{ documentId });
            receiveInwardDocumentInternal(
                modifiedDocs);
                try {
                    skipValidations = true;
                    update modifiedDocs;        
                } finally {
                    skipValidations = false;
                }
            return TransferInwardLineHelper.receiveInwardDocument(
                orderLinesInfo,
                documentId);
    }

    public static CreateRelatedResult receiveInwardDocument(List<dmpl__Transfer__c> documents){
        receiveInwardDocumentInternal(
            documents);
        return TransferInwardLineHelper.receiveInwardDocument(
            documents);
    }

    public static void receiveInwardDocumentInternal(List<dmpl__Transfer__c> documents){
        SecurityHelper.ensureCanWriteField(
            'dmpl__PerformInwardReceive__c', 
            'dmpl__Transfer__c');
        SecurityHelper.ensureCanWriteField(
            'dmpl__IsInwardReceived__c', 
            'dmpl__Transfer__c');
        for(dmpl__Transfer__c document : documents){
            if(document.dmpl__Type__c == 'Inward'){
                document.dmpl__PerformInwardReceive__c = false;
                document.dmpl__IsInwardReceived__c = true;
            }
        }
    }

    public static CreateRelatedResult postInwardDocument(
        Id documentId){
            List<dmpl__Transfer__c> modifiedDocs = queryTransferDocuments(
                new List<Id>{ documentId });
            postInwardDocumentInternal(
                modifiedDocs);
            try {
                skipValidations = true;
                update modifiedDocs;        
            } finally {
                skipValidations = false;
            }
            
            return TransferInwardLineHelper.postInwardDocument(
                modifiedDocs);
    }

    public static CreateRelatedResult postInwardDocument(
        List<SourceObjectInfo> orderLinesInfo, 
        Id documentId){
            List<dmpl__Transfer__c> modifiedDocs = queryTransferDocuments(
                new List<Id>{ documentId });
            postInwardDocumentInternal(
                modifiedDocs);
                try {
                    skipValidations = true;
                    update modifiedDocs;        
                } finally {
                    skipValidations = false;
                }
            return TransferInwardLineHelper.postInwardDocument(
                orderLinesInfo, 
                documentId);
    }

    public static CreateRelatedResult postInwardDocument(
        List<dmpl__Transfer__c> documents){
            postInwardDocumentInternal(
                documents);
            return TransferInwardLineHelper.postInwardDocument(
                documents);
    }
    
    public static void postInwardDocumentInternal(
        List<dmpl__Transfer__c> documents){
            SecurityHelper.ensureCanWriteField(
                'dmpl__PerformInwardPosting__c', 
                'dmpl__Transfer__c');
            SecurityHelper.ensureCanWriteField(
                'dmpl__IsInwardPosted__c', 
                'dmpl__Transfer__c');
            for(dmpl__Transfer__c document : documents){
                if(document.dmpl__Type__c == 'Inward'){
                    document.dmpl__PerformInwardPosting__c = false;
                    document.dmpl__IsInwardPosted__c = true;
                }
            }    
    }
    
    public static CreateRelatedResult createStockTransferFromRequisition(
        Id requisitionId){
        return CreateRelatedResult.InitFrom(createTransferFromRequisitionInternal(
            queryRequisitionLines(
                new List<Id>{ requisitionId }, 
                null),
            null));
    }

    public static CreateRelatedResult createStockTransferFromRequisition(
        List<SourceObjectInfo> orderLinesInfo){
        return CreateRelatedResult.InitFrom(
            createTransferFromRequisitionInternal(
                queryRequisitionLines(
                    (List<Id>)null, 
                    SourceObjectInfo.extractIds(orderLinesInfo)),
                orderLinesInfo));
    }

    public static CreateRelatedResult postIL(Id transferId){
        return TransferLineHelper.postIL(transferId);
    }
 
     public static CreateRelatedResult postIL(List<SourceObjectInfo> orderLinesInfo, Id transferId){
        return TransferLineHelper.postIL(orderLinesInfo, transferId);
    }
	
     @testVisible
    private static void PostIL(List<dmpl__Transfer__c> modifiedDocuments)
    {
        SecurityHelper.ensureCanWriteField('dmpl__PerformILPosting__c', 'dmpl__Transfer__c');
        for(dmpl__Transfer__c document : modifiedDocuments){
            document.dmpl__PerformILPosting__c = false;
        }
        TransferLineHelper.postTransferLines(modifiedDocuments);
    }

    private static List<dmpl__Transfer__c> createInwardDocument(List<dmpl__Transfer__c> newEntries){
        List<dmpl__Transfer__c> newInwards = new List<dmpl__Transfer__c>();
        List<dmpl__Resource__c> resources = queryResources(
            CollectionHelper.extractIds(
                newEntries,
                'dmpl__ReceivedById__c'));
        for(dmpl__Transfer__c entry : newEntries){
            dmpl__Resource__c resource = (dmpl__Resource__c)CollectionHelper.getObject(resources, entry.dmpl__ReceivedById__c);
            dmpl__Transfer__c inward = entry.clone(
                false,
                false,
                false,
                false);
            inward.dmpl__OutwardDocumentId__c = entry.Id;
            inward.dmpl__Type__c = 'Inward';
            if(resource!=null && resource.dmpl__UserId__c!=null){
                inward.OwnerId = resource.dmpl__UserId__c;
            }
            newInwards.add(inward);
        }

        try {
            skipValidations = true;
            insert newInwards;    
        } finally {
            skipValidations = false;
        }
        

        for(dmpl__Transfer__c entry : newEntries){
            dmpl__Transfer__c inwardDocument = (dmpl__Transfer__c)CollectionHelper.getObject(
                newInwards, 
                'dmpl__OutwardDocumentId__c', 
                entry.Id);
            entry.dmpl__InwardDocumentId__c = inwardDocument.Id;
        }
        return newInwards;
    }
	@testVisible
    private static Map<Id, dmpl__Transfer__c> createTransferFromRequisitionInternal(
        List<dmpl__PurchaseRequisitionLine__c> requisitionLines,
        List<SourceObjectInfo> sourceObjectLists){
            if(requisitionLines.size() == 0){
                throw new DMPLException(
                    String.format(
                        String.valueOf(
                            System.Label.Generic_EmptyActionParam), 
                            new String[]{
                                dmpl__PurchaseRequisitionLine__c.class.getName()}));
            }

            Map<Id, dmpl__Transfer__c> transferDocuments = new Map<Id, dmpl__Transfer__c>();
            Map<Id, List<dmpl__TransferOutwardLine__c>> transferLines = new Map<Id, List<dmpl__TransferOutwardLine__c>>();
            for(dmpl__PurchaseRequisitionLine__c requisitionLine : requisitionLines){
                if(requisitionLine.dmpl__ItemId__c !=null 
                    && requisitionLine.dmpl__PendingQuantity__c>0){

                    dmpl__Transfer__c transferDocument = null;
                    if(transferDocuments.containsKey(requisitionLine.dmpl__PurchaseRequisitionId__c)){
                        transferDocument = transferDocuments.get(requisitionLine.dmpl__PurchaseRequisitionId__c);
                    }else {
                        transferDocument = createTransferDocumentFromRequisition(requisitionLine);
                        transferDocuments.put(requisitionLine.dmpl__PurchaseRequisitionId__c, transferDocument);
                        transferLines.put(requisitionLine.dmpl__PurchaseRequisitionId__c, new List<dmpl__TransferOutwardLine__c>());
                    }
                    Decimal requestedQty = SourceObjectInfo.getRequestedQuantity(
                        sourceObjectLists, 
                        requisitionLine.Id);
                    transferLines.get(
                        requisitionLine.dmpl__PurchaseRequisitionId__c).add(
                            createTransferLineFromRequisitionLine(
                                requisitionLine,
                                requestedQty));
                }
            }
            //
            if(transferLines.size() >0){
                Savepoint sp = Database.setSavepoint();
                try {
                    SecurityHelper.ensureCanCreateObject('dmpl__Transfer__c');
                    SecurityHelper.ensureCanCreateFields(new string[]{
                        'dmpl__BranchId__c',
                        'dmpl__PartnerAccountId__c',
                        'dmpl__Remarks__c'
                    }, 'dmpl__Transfer__c');
                    insert transferDocuments.values();
                    List<dmpl__TransferOutwardLine__c> linesToInsert = new List<dmpl__TransferOutwardLine__c>();
                    for(Id orderId : transferDocuments.keySet()){
                        dmpl__Transfer__c trasferDocument = transferDocuments.get(orderId);
                        List<dmpl__TransferOutwardLine__c> docLines = transferLines.get(orderId);
                        for(dmpl__TransferOutwardLine__c trasferLine : docLines){
                            trasferLine.dmpl__TransferId__c = trasferDocument.Id;
                            linesToInsert.add(trasferLine);
                        }    
                    }

                    SecurityHelper.ensureCanCreateObject('dmpl__TransferOutwardLine__c');
                    SecurityHelper.ensureCanCreateFields(new string[]{
                        'dmpl__RequisitionLineId__c',
                        'dmpl__RequisitionId__c',
                        'dmpl__ItemId__c',
                        'dmpl__SKUId__c',
                        'dmpl__Quantity__c'
                    }, 'dmpl__TransferOutwardLine__c');
                    insert linesToInsert;
                } catch (Exception e) {
                    Database.rollback(sp);
                    throw new DMPLException(e.getMessage());
                }
            }
            return transferDocuments;
    }

    private static dmpl__Transfer__c createTransferDocumentFromRequisition(
        dmpl__PurchaseRequisitionLine__c requisitionLine){
            return new dmpl__Transfer__c(
                    dmpl__BranchId__c = requisitionLine.dmpl__PurchaseRequisitionId__r.dmpl__FromBranchId__c,
                    dmpl__ToBranchId__c = requisitionLine.dmpl__PurchaseRequisitionId__r.dmpl__BranchId__c,
                    dmpl__PartnerAccountId__c = requisitionLine.dmpl__PurchaseRequisitionId__r.dmpl__PartnerAccountId__c,
                    dmpl__PurchaseRequisitionId__c = requisitionLine.dmpl__PurchaseRequisitionId__c
                );
    }

    private static dmpl__TransferOutwardLine__c createTransferLineFromRequisitionLine(
        dmpl__PurchaseRequisitionLine__c requisitionLine,
        Decimal requestedQty){
            return new dmpl__TransferOutwardLine__c(
                dmpl__RequisitionLineId__c = requisitionLine.Id,
                dmpl__RequisitionId__c = requisitionLine.dmpl__PurchaseRequisitionId__c,
                dmpl__ItemId__c = requisitionLine.dmpl__ItemId__c,
                dmpl__SKUId__c = requisitionLine.dmpl__SKUId__c,
                dmpl__UnitCost__c = requisitionLine.dmpl__UnitCost__c,
                dmpl__Quantity__c = requestedQty > 0 ? requestedQty : requisitionLine.dmpl__PendingQuantity__c
            );
    }

    public static void createTransferForLoadFromFieldSales(List<dmpl__FieldSales__c> fieldSales){
        createTransferForLoadFromFieldSalesInternal(
            queryFieldSalesLines(
                DocumentHelper.extractIds(fieldSales), 
                null), 
            null,
            null);
    }
    
    public static CreateRelatedResult createTransferForLoadFromFieldSales(Id fieldSalesId){
        return CreateRelatedResult.InitFrom(
            createTransferForLoadFromFieldSalesInternal(
                queryFieldSalesLines(
                    new List<Id>{fieldSalesId},
                    null), 
                null,
                null));
    }
    
    public static CreateRelatedResult createTransferForLoadFromFieldSales(List<SourceObjectInfo> orderLinesInfo){
        return CreateRelatedResult.InitFrom(
            createTransferForLoadFromFieldSalesInternal(
                queryFieldSalesLines(
                    (List<Id>)null, 
                    SourceObjectInfo.extractIds(orderLinesInfo)), 
                null,
                orderLinesInfo));
    }

    private static Map<Id, dmpl__Transfer__c> createTransferForLoadFromFieldSalesInternal(
        List<dmpl__FieldSalesLine__c> fieldSalesLines,
        dmpl__Transfer__c existingDocument,
        List<SourceObjectInfo> orderLinesInfo){
        if(fieldSalesLines.size() == 0){
            throw new DMPLException(
                String.format(
                    String.valueOf(System.Label.Generic_EmptyActionParam), 
                    new String[]{
                        dmpl__FieldSalesLine__c.class.getName()}));
        }

        Map<Id, dmpl__Transfer__c> transferDocuments = new Map<Id,dmpl__Transfer__c>();
        Map<Id, List<dmpl__TransferLine__c>> transferLines = new Map<Id, List<dmpl__TransferLine__c>>();
        if(existingDocument != null){
            transferDocuments.put(fieldSalesLines[0].dmpl__FieldSalesId__c, existingDocument);
        }
        for(dmpl__FieldSalesLine__c fieldSalesLine : fieldSalesLines){
            if(fieldSalesLine.dmpl__ItemId__r != null){

                SourceObjectInfo objectInfo = SourceObjectInfo.getSourceObjectInfo(orderLinesInfo, fieldSalesLine.Id);
                dmpl__Transfer__c transferDocument = null;
                if(transferDocuments.containsKey(fieldSalesLine.dmpl__FieldSalesId__c)){
                    transferDocument = transferDocuments.get(fieldSalesLine.dmpl__FieldSalesId__c);
                }else if(objectInfo!=null){
                    transferDocument = queryTransferDocument(
                        objectInfo.getDestinationObjectId(
                            fieldSalesLine.dmpl__FieldSalesId__c));
                }
                if(transferDocument == null){
                    transferDocument = createTransferDocumentFromFieldSales(fieldSalesLine);
                }
                if(!transferDocuments.containsKey(fieldSalesLine.dmpl__FieldSalesId__c)){
                    transferDocuments.put(
                        fieldSalesLine.dmpl__FieldSalesId__c, 
                        transferDocument);
                }
                if(!transferLines.containsKey(fieldSalesLine.dmpl__FieldSalesId__c)){
                    transferLines.put(
                        fieldSalesLine.dmpl__FieldSalesId__c, 
                        new List<dmpl__TransferLine__c>());
                }
                transferLines.get(
                    fieldSalesLine.dmpl__FieldSalesId__c).add(
                        createTransferLinesForLoadFromFieldSalesLines(
                            fieldSalesLine,
                            orderLinesInfo));
            }
        }
        if(transferLines.size() >0){
            Savepoint sp = Database.setSavepoint();
            try {
                SecurityHelper.ensureCanCreateObject('dmpl__Transfer__c');
                SecurityHelper.ensureCanCreateFields(new string[]
                {
                    'dmpl__FieldSalesId__c',
                    'dmpl__BranchId__c',
                    'dmpl__PartnerAccountId__c',
                    'dmpl__DocumentDate__c'
                }, 'dmpl__Transfer__c');

                upsert transferDocuments.values();
                List<dmpl__TransferLine__c> linesToInsert = new List<dmpl__TransferLine__c>();
                for(Id soId : transferDocuments.keySet()){
                    dmpl__Transfer__c transferDocument = transferDocuments.get(soId);
                    List<dmpl__TransferLine__c> docLines = transferLines.get(soId);
                    for(dmpl__TransferLine__c transferLine : docLines){
                        transferLine.dmpl__TransferId__c = transferDocument.Id;
                        linesToInsert.add(transferLine);
                    }    
                }
                
                SecurityHelper.ensureCanCreateObject('dmpl__TransferLine__c');
                SecurityHelper.ensureCanCreateFields(new string[]
                {
                    'dmpl__FieldSalesLineId__c',
                    'dmpl__ItemId__c',
                    'dmpl__SKUId__c',
                    'dmpl__Quantity__c'
                }, 'dmpl__TransferLine__c');

                insert linesToInsert;
            } catch (Exception e) {
                Database.rollback(sp);
                throw e;
            }
        }

        return transferDocuments;
    }


    private static dmpl__TransferLine__c createTransferLinesForLoadFromFieldSalesLines(
        dmpl__FieldSalesLine__c fieldSalesLine,
        List<SourceObjectInfo> orderLinesInfo){
        return new dmpl__TransferLine__c(
            dmpl__FieldSalesLineId__c = fieldSalesLine.Id,
            dmpl__ItemId__c = fieldSalesLine.dmpl__ItemId__c,
            dmpl__SKUId__c = fieldSalesLine.dmpl__SKUId__c,
            dmpl__Quantity__c = fieldSalesLine.dmpl__Quantity__c,
            dmpl__ReceivedQuantity__c = fieldSalesLine.dmpl__Quantity__c,
            dmpl__DamagedQuantity__c = fieldSalesLine.dmpl__DamagedQuantity__c,
            dmpl__RelatedStorageLocationId__c = fieldSalesLine.dmpl__FieldSalesId__r.dmpl__StorageLocationId__c,
            dmpl__ItemLotId__c = fieldSalesLine.dmpl__ItemLotId__c,
            dmpl__RelatedItemLotId__c = fieldSalesLine.dmpl__RelatedItemLotId__c
        );
    }

    public static void createTransferForUnloadFromFieldSales(List<dmpl__FieldSales__c> fieldSales){
        createTransferForUnloadFromFieldSalesInternal(
            queryFieldSalesLines(
                DocumentHelper.extractIds(fieldSales), 
                null), 
            null,
            null);
    }
    
    public static CreateRelatedResult createTransferForUnloadFromFieldSales(Id fieldSalesId){
        return CreateRelatedResult.InitFrom(
            createTransferForUnloadFromFieldSalesInternal(
                queryFieldSalesLines(
                    new List<Id>{fieldSalesId},
                    null), 
                null,
                null));
    }
    
    public static CreateRelatedResult createTransferForUnloadFromFieldSales(List<SourceObjectInfo> orderLinesInfo){
        return CreateRelatedResult.InitFrom(
            createTransferForUnloadFromFieldSalesInternal(
                queryFieldSalesLines(
                    (List<Id>)null, 
                    SourceObjectInfo.extractIds(orderLinesInfo)), 
                null,
                orderLinesInfo));
    }

    private static Map<Id, dmpl__Transfer__c> createTransferForUnloadFromFieldSalesInternal(
        List<dmpl__FieldSalesLine__c> fieldSalesLines,
        dmpl__Transfer__c existingDocument,
        List<SourceObjectInfo> orderLinesInfo){
        if(fieldSalesLines.size() == 0){
            throw new DMPLException(
                String.format(
                    String.valueOf(System.Label.Generic_EmptyActionParam), 
                    new String[]{
                        dmpl__FieldSalesLine__c.class.getName()}));
        }

        Map<Id, dmpl__Transfer__c> transferDocuments = new Map<Id,dmpl__Transfer__c>();
        Map<Id, List<dmpl__TransferLine__c>> transferLines = new Map<Id, List<dmpl__TransferLine__c>>();
        if(existingDocument != null){
            transferDocuments.put(fieldSalesLines[0].dmpl__FieldSalesId__c, existingDocument);
        }
        for(dmpl__FieldSalesLine__c fieldSalesLine : fieldSalesLines){
            if(fieldSalesLine.dmpl__ItemId__r != null){

                SourceObjectInfo objectInfo = SourceObjectInfo.getSourceObjectInfo(orderLinesInfo, fieldSalesLine.Id);
                dmpl__Transfer__c transferDocument = null;
                if(transferDocuments.containsKey(fieldSalesLine.dmpl__FieldSalesId__c)){
                    transferDocument = transferDocuments.get(fieldSalesLine.dmpl__FieldSalesId__c);
                }else if(objectInfo!=null){
                    transferDocument = queryTransferDocument(
                        objectInfo.getDestinationObjectId(
                            fieldSalesLine.dmpl__FieldSalesId__c));
                }
                if(transferDocument == null){
                    transferDocument = createTransferDocumentFromFieldSales(fieldSalesLine);
                }
                if(!transferDocuments.containsKey(fieldSalesLine.dmpl__FieldSalesId__c)){
                    transferDocuments.put(
                        fieldSalesLine.dmpl__FieldSalesId__c, 
                        transferDocument);
                }
                if(!transferLines.containsKey(fieldSalesLine.dmpl__FieldSalesId__c)){
                    transferLines.put(
                        fieldSalesLine.dmpl__FieldSalesId__c, 
                        new List<dmpl__TransferLine__c>());
                }
                transferLines.get(
                    fieldSalesLine.dmpl__FieldSalesId__c).add(
                        createTransferLinesForUnloadFromFieldSalesLines(
                            fieldSalesLine,
                            orderLinesInfo));
            }
        }
        if(transferLines.size() >0){
            Savepoint sp = Database.setSavepoint();
            try {
                SecurityHelper.ensureCanCreateObject('dmpl__Transfer__c');
                SecurityHelper.ensureCanCreateFields(new string[]
                {
                    'dmpl__FieldSalesId__c',
                    'dmpl__BranchId__c',
                    'dmpl__PartnerAccountId__c',
                    'dmpl__DocumentDate__c'
                }, 'dmpl__Transfer__c');

                upsert transferDocuments.values();
                List<dmpl__TransferLine__c> linesToInsert = new List<dmpl__TransferLine__c>();
                for(Id soId : transferDocuments.keySet()){
                    dmpl__Transfer__c transferDocument = transferDocuments.get(soId);
                    List<dmpl__TransferLine__c> docLines = transferLines.get(soId);
                    for(dmpl__TransferLine__c transferLine : docLines){
                        transferLine.dmpl__TransferId__c = transferDocument.Id;
                        linesToInsert.add(transferLine);
                    }    
                }
                
                SecurityHelper.ensureCanCreateObject('dmpl__TransferLine__c');
                SecurityHelper.ensureCanCreateFields(new string[]
                {
                    'dmpl__FieldSalesLineId__c',
                    'dmpl__ItemId__c',
                    'dmpl__SKUId__c',
                    'dmpl__Quantity__c'
                }, 'dmpl__TransferLine__c');

                insert linesToInsert;
            } catch (Exception e) {
                Database.rollback(sp);
                throw e;
            }
        }

        return transferDocuments;
    }

    private static dmpl__Transfer__c createTransferDocumentFromFieldSales(dmpl__FieldSalesLine__c fieldSalesLine){
        return new dmpl__Transfer__c(
            dmpl__FieldSalesId__c = fieldSalesLine.dmpl__FieldSalesId__c,
            dmpl__BranchId__c = fieldSalesLine.dmpl__FieldSalesId__r.dmpl__BranchId__c,
            dmpl__PartnerAccountId__c = fieldSalesLine.dmpl__FieldSalesId__r.dmpl__PartnerAccountId__c,
            dmpl__DocumentDate__c = fieldSalesLine.dmpl__FieldSalesId__r.dmpl__DocumentDate__c,
            dmpl__ToBranchId__c = fieldSalesLine.dmpl__FieldSalesId__r.dmpl__BranchId__c,
            dmpl__Type__c = 'Single Step'
        );
    }

    private static dmpl__TransferLine__c createTransferLinesForUnloadFromFieldSalesLines(
        dmpl__FieldSalesLine__c fieldSalesLine,
        List<SourceObjectInfo> orderLinesInfo){
        return new dmpl__TransferLine__c(
            dmpl__FieldSalesLineId__c = fieldSalesLine.Id,
            dmpl__ItemId__c = fieldSalesLine.dmpl__ItemId__c,
            dmpl__SKUId__c = fieldSalesLine.dmpl__SKUId__c,
            dmpl__Quantity__c = fieldSalesLine.dmpl__ExpectedReceivedQuantity__c,
            dmpl__ReceivedQuantity__c = fieldSalesLine.dmpl__ReceivedQuantity__c,
            dmpl__DamagedQuantity__c = fieldSalesLine.dmpl__DamagedQuantity__c,
            dmpl__StorageLocationId__c = fieldSalesLine.dmpl__FieldSalesId__r.dmpl__StorageLocationId__c,
            dmpl__ItemLotId__c = fieldSalesLine.dmpl__RelatedItemLotId__c,
            dmpl__RelatedItemLotId__c = fieldSalesLine.dmpl__ItemLotId__c
        );
    }

    private static dmpl__Transfer__c queryTransferDocument(Id transferId){
        if(transferId == null){
            return null;
        }
        SecurityHelper.ensureCanReadFields(new string[]
         {'dmpl__FieldSalesId__c'
        }, 'dmpl__Transfer__c');
            return [
                SELECT
                    Id,
                    Name,
                    dmpl__BranchId__c,
                    dmpl__DocumentDate__c,
                    dmpl__ExternalId__c,
                    dmpl__InwardDocumentId__c,
                    dmpl__IsInwardPosted__c,
                    dmpl__IsInwardReceived__c,
                    dmpl__IsOutwardReleased__c,
                    dmpl__OutwardDocumentId__c,
                    dmpl__PartnerAccountId__c,
                    dmpl__PerformInwardPosting__c,
                    dmpl__PerformInwardReceive__c,
                    dmpl__PerformOutwardRelease__c,
                    dmpl__PurchaseRequisitionId__c,
                    dmpl__ReceivedById__c,
                    dmpl__ReceivedTime__c,
                    dmpl__ResourceId__c,
                    dmpl__Status__c,
                    dmpl__ToBranchId__c,
                    dmpl__ToPartnerAccountId__c,
                    dmpl__TransferredById__c,
                    dmpl__TransferTime__c,
                    dmpl__Type__c
                FROM dmpl__Transfer__c
                WHERE Id = :transferId
            ];
    }

    private static List<dmpl__Transfer__c> queryTransferDocuments(
        List<Id> Ids){
            return [
                SELECT
                    Id,
                    Name,
                    dmpl__BranchId__c,
                    dmpl__DocumentDate__c,
                    dmpl__ExternalId__c,
                    dmpl__InwardDocumentId__c,
                    dmpl__IsInwardPosted__c,
                    dmpl__IsInwardReceived__c,
                    dmpl__IsOutwardReleased__c,
                    dmpl__OutwardDocumentId__c,
                    dmpl__PartnerAccountId__c,
                    dmpl__PerformInwardPosting__c,
                    dmpl__PerformInwardReceive__c,
                    dmpl__PerformOutwardRelease__c,
                    dmpl__PurchaseRequisitionId__c,
                    dmpl__ReceivedById__c,
                    dmpl__ReceivedTime__c,
                    dmpl__ResourceId__c,
                    dmpl__Status__c,
                    dmpl__ToBranchId__c,
                    dmpl__ToPartnerAccountId__c,
                    dmpl__TransferredById__c,
                    dmpl__TransferTime__c,
                    dmpl__Type__c
                FROM dmpl__Transfer__c
                WHERE Id IN :Ids
            ];
    }
	@testvisible
    private static List<dmpl__PurchaseRequisitionLine__c> queryRequisitionLines(
        List<Id> requisitionIds, 
        List<Id> purchaseRequisitionLineIds){
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
                dmpl__PurchaseRequisitionId__r.dmpl__FromBranchId__c,
                dmpl__PurchaseRequisitionId__r.dmpl__SupplierAccountId__c,
                dmpl__PurchaseRequisitionId__r.dmpl__DocumentDate__c,
                dmpl__PurchaseRequisitionId__r.dmpl__Remarks__c
            FROM dmpl__PurchaseRequisitionLine__c
            WHERE dmpl__PurchaseRequisitionId__c in :requisitionIds OR Id IN :purchaseRequisitionLineIds];
    }

    private static List<dmpl__Resource__c> queryResources(List<Id> resourceIds){
        return [
            SELECT
                Id,
                dmpl__UserId__c
            FROM dmpl__Resource__c
            WHERE Id In :resourceIds
        ];
    }

    private static List<dmpl__FieldSalesLine__c> queryFieldSalesLines(
        List<Id> fieldSalesIds, 
        List<Id> fieldSalesLineIds)
    {
        if(fieldSalesLineIds == null){
            fieldSalesLineIds = new List<Id>();
        }
        if(fieldSalesIds == null){
            fieldSalesIds = new List<Id>();
        }
         SecurityHelper.ensureCanReadFields(new string[]
         {
            'dmpl__PartnerAccountId__c',
            'dmpl__BranchId__c,',
            'dmpl__DocumentDate__c'
        }, 'dmpl__FieldSales__c');
         SecurityHelper.ensureCanReadFields(new string[]
         {
            'dmpl__ItemId__c',
            'dmpl__FieldSalesId__c',
            'dmpl__SKUId__c',
            'dmpl__Quantity__c',
            'dmpl__DamagedQuantity__c',
            'dmpl__ExcessQuantity__c',
            'dmpl__ReceivedQuantity__c',
            'dmpl__ShortageQuantity__c',
            'dmpl__SoldQuantity__c'
        }, 'dmpl__FieldSalesLine__c');
        return [SELECT Id,
            Name,
            dmpl__ItemId__c,
            dmpl__SKUId__c,
            dmpl__Quantity__c,
            dmpl__DamagedQuantity__c,
            dmpl__ExcessQuantity__c,
            dmpl__ReceivedQuantity__c,
            dmpl__ShortageQuantity__c,
            dmpl__ExpectedReceivedQuantity__c,
            dmpl__ItemLotId__c,
            dmpl__RelatedItemLotId__c,
            dmpl__ItemId__r.dmpl__TrackInventory__c,
            dmpl__SoldQuantity__c,
            dmpl__FieldSalesId__c,
            dmpl__FieldSalesId__r.dmpl__PartnerAccountId__c,
            dmpl__FieldSalesId__r.dmpl__BranchId__c,
            dmpl__FieldSalesId__r.dmpl__DocumentDate__c,
            dmpl__FieldSalesId__r.dmpl__StorageLocationId__c
        FROM dmpl__FieldSalesLine__c
        WHERE dmpl__FieldSalesId__c IN :fieldSalesIds OR Id IN :fieldSalesLineIds
        ];
    }
}