public with sharing class InspectionLineHelper {

    private static Boolean skipValidations = false;

    private static final string OBJECT_GOODSRECEIPT = 'dmpl__GoodsReceipt__c';
    private static final string OBJECT_GOODSRECEIPTLINE = 'dmpl__GoodsReceiptLine__c';
    private static final string OBJECT_INSPECTIONLINE = 'dmpl__InspectionLine__c';
    private static final string FIELD_GOODSRECEIPTLINEID = 'dmpl__ReceiptLineId__c';
    
    private static final String FIELD_INSPECTIONLINE_QUANTITY = 'dmpl__Quantity__c';
    private static final String FIELD_INSPECTIONLINE_ADJUSTMENTQUANTITY = 'dmpl__AdjustmentQuantity__c';
    private static final String FIELD_INSPECTIONLINE_DAMAGEDQUANTITY = 'dmpl__DamagedQuantity__c';
    private static final String FIELD_INSPECTIONLINE_EXCESSQUANTITY = 'dmpl__ExcessQuantity__c';
    private static final String FIELD_INSPECTIONLINE_INSPECTIONDONE = 'dmpl__InspectionDone__c';
    private static final String FIELD_INSPECTIONLINE_INSPECTIONQUANTITY = 'dmpl__InspectionQuantity__c';
    private static final String FIELD_INSPECTIONLINE_INVENTORYLEDGERID = 'dmpl__InventoryLedgerId__c';
    private static final String FIELD_INSPECTIONLINE_ISAPPROVED = 'dmpl__IsApproved__c';
    private static final String FIELD_INSPECTIONLINE_ISILPOSTED = 'dmpl__IsILPosted__c';
    private static final String FIELD_INSPECTIONLINE_ISILPOSTINGAPPROVED = 'dmpl__IsILPostingApproved__c';
    private static final String FIELD_INSPECTIONLINE_ITEMID = 'dmpl__ItemId__c';
    private static final String FIELD_INSPECTIONLINE_ITEMLOTID = 'dmpl__ItemLotId__c';
    private static final String FIELD_INSPECTIONLINE_ORDERQUANTITY = 'dmpl__OrderQuantity__c';
    private static final String FIELD_INSPECTIONLINE_RECEIPTID = 'dmpl__ReceiptId__c';
    private static final String FIELD_INSPECTIONLINE_RECEIPTLINEID = 'dmpl__ReceiptLineId__c';
    private static final String FIELD_INSPECTIONLINE_RECEIVEDQUANTITY = 'dmpl__ReceivedQuantity__c';
    private static final String FIELD_INSPECTIONLINE_SHORTAGEQUANTITY = 'dmpl__ShortageQuantity__c';
    private static final String FIELD_INSPECTIONLINE_SKUID = 'dmpl__SKUId__c';
    private static final String FIELD_INSPECTIONLINE_SUPPLIERINVOICEQUANTITY = 'dmpl__SupplierInvoiceQuantity__c';
    private static final String FIELD_INSPECTIONLINE_UNITCOST = 'dmpl__UnitCost__c';
    private static final string RELATION_GOODSRECEIPT_STATUS = 'dmpl__ReceiptId__r.dmpl__Status__c';
    private static final string FIELD_INSPECTIONLINE_PERFORMPOPULATECHECKLIST = 'dmpl__PerformPopulateChecklist__c';

    private static final List<String> LIST_FIELDS_NONEDITABLE = new List<String>{FIELD_INSPECTIONLINE_ITEMID, FIELD_INSPECTIONLINE_SKUID};
    private static final List<String> LIST_FIELDS_SYSTEM = new List<String>{FIELD_INSPECTIONLINE_SUPPLIERINVOICEQUANTITY, FIELD_INSPECTIONLINE_ISILPOSTED, FIELD_INSPECTIONLINE_INVENTORYLEDGERID};
    private static final List<String> LIST_FIELDS_LOCKEDIFTRANSACTED = new List<String>{FIELD_INSPECTIONLINE_ITEMID,FIELD_INSPECTIONLINE_SKUID};


    public void validateData(Boolean isInsert, Boolean isUpdate, Boolean isDelete, List<Dmpl__InspectionLine__c> newEntries, List<Dmpl__InspectionLine__c> oldEntries)
    {
        try{
            if(isInsert){
                FieldMappingHelper.copyFieldMappingData(
                    newEntries);
            }
            if(isUpdate){
                validateItem(newEntries);
            }
            if(skipValidations){
                return;
            }

            DocumentStatusDFSHelper dfsHelper = new DocumentStatusDFSHelper();
            if(isInsert){
                validateItem(newEntries);
                DocumentHelper.validateChangeInSystemFields(LIST_FIELDS_SYSTEM, newEntries);
                dfsHelper.DocumentStatusRelatedObjectRestrictEdits_New(OBJECT_GOODSRECEIPT, OBJECT_INSPECTIONLINE, RELATION_GOODSRECEIPT_STATUS, newEntries);
            }else if(isUpdate){
                DocumentHelper.validateChangeInSystemFields(LIST_FIELDS_SYSTEM, oldEntries, newEntries);
                DocumentHelper.validateChangeInKeyFields(LIST_FIELDS_NONEDITABLE, oldEntries, newEntries);
                dfsHelper.DocumentStatusRelatedObjectRestrictEdits_Edit(OBJECT_GOODSRECEIPT, OBJECT_INSPECTIONLINE, RELATION_GOODSRECEIPT_STATUS, oldEntries, newEntries);
            }else if(isDelete){
                DocumentHelper.validateCanBeDeleted(oldEntries, FIELD_INSPECTIONLINE_INSPECTIONQUANTITY);
                dfsHelper.DocumentStatusRelatedObjectRestrictEdits_Delete(OBJECT_GOODSRECEIPT, OBJECT_INSPECTIONLINE, RELATION_GOODSRECEIPT_STATUS, oldEntries);
            } 
            
        } catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }

    public void postData(Boolean isInsert, Boolean isUpdate, Boolean isDelete, List<Dmpl__InspectionLine__c> newEntries, List<Dmpl__InspectionLine__c> oldEntries)
    {
        try{
            InventoryLedgerHelper.createLedger(InventoryLedgerTypeEnums.Inspection, FIELD_INSPECTIONLINE_RECEIPTID, OBJECT_GOODSRECEIPT, isInsert, isDelete, isUpdate, oldEntries, newEntries);
            List<Dmpl__InspectionLine__c> modifiedObjects = DocumentHelper.getPostedObjects(FIELD_INSPECTIONLINE_INSPECTIONDONE, oldEntries, newEntries); 
                if(modifiedObjects.size() > 0){
                    InventoryLedgerHelper.createLedger(InventoryLedgerTypeEnums.InspectionAdjustment, FIELD_INSPECTIONLINE_RECEIPTID,OBJECT_GOODSRECEIPT, isInsert, isDelete, isUpdate, isDelete ? modifiedObjects : oldEntries, isInsert || isUpdate ? modifiedObjects : newEntries);
                    InventoryLedgerHelper.createLedger(InventoryLedgerTypeEnums.Damaged, FIELD_INSPECTIONLINE_RECEIPTID, OBJECT_GOODSRECEIPT, isInsert, isDelete, isUpdate, isDelete ? modifiedObjects : oldEntries, isInsert || isUpdate ? modifiedObjects : newEntries);
                    GoodReceiptLineHelper.updateDamagedQuantityFromInspection(DocumentHelper.extractIds(modifiedObjects, FIELD_GOODSRECEIPTLINEID));
                }
            
            if(isUpdate) {
                modifiedObjects = DocumentHelper.getApprovedObjects(FIELD_INSPECTIONLINE_PERFORMPOPULATECHECKLIST, oldEntries, newEntries);
                if(modifiedObjects.size()>0){
                    populateChecklistDetails(modifiedObjects);
                }
            }
        } catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }

    public void afterPostData(Boolean isInsert, Boolean isUpdate, Boolean isDelete, List<Dmpl__InspectionLine__c> newEntries, List<Dmpl__InspectionLine__c> oldEntries)
    {
        if(isInsert){
            RepairOrderHelper.createRepairOrderFromInspection(DocumentHelper.extractIds(newEntries));
            GoodReceiptLineHelper.updateStartedInspectionQuantityFromInspection(DocumentHelper.extractIds(DocumentHelper.getObjectsWithNotNull(newEntries,FIELD_GOODSRECEIPTLINEID),FIELD_GOODSRECEIPTLINEID));
        }
    }

    public static Map<Id, dmpl__InspectionLine__c> createInspectionLinesFromGoodsReceipt(List<dmpl__GoodsReceipt__c> goodsReceipts){
        return createInspectionLinesFromGoodsReceipt(queryGoodsReceiptLines(DocumentHelper.extractIds(goodsReceipts)), new List<SourceObjectInfo>());
    }

    public static Map<Id, dmpl__InspectionLine__c> createInspectionLinesFromGoodsReceiptLine(List<dmpl__GoodsReceiptLine__c> goodsReceiptLines, List<SourceObjectInfo> goodsReceiptLinesInfo){
        return createInspectionLinesFromGoodsReceipt(goodsReceiptLines, goodsReceiptLinesInfo);
    }

    public static Map<Id, dmpl__InspectionLine__c> completeInspectionFromGoodsReceipt(List<dmpl__GoodsReceipt__c> goodsReceipts){
        return completeInspection(queryInspectionLines(DocumentHelper.extractIds(goodsReceipts)));
    }

    public static void populateChecklistDetails(List<dmpl__InspectionLine__c> inspectionLines){
        ChecklistLineHelper.createChecklistLines(inspectionLines);
    }

    public static void updateIsRepairOrderClosedInInspectionLine(List<Id> inspectionLineIds){
        List<InspectionLine__c> inspectionLines = queryInspectionLinesFromId(inspectionLineIds);
        for(InspectionLine__c inspectionLine : inspectionLines)
            inspectionLine.dmpl__IsRepairOrderClosed__c = true;

        if(inspectionLines.size() > 0)
        {
            SecurityHelper.ensureCanWriteFields(new String[]{'dmpl__IsRepairOrderClosed__c'},'dmpl__InspectionLine__c');
            update inspectionLines;
        }
    }

    private static Map<Id, dmpl__InspectionLine__c> createInspectionLinesFromGoodsReceipt(List<dmpl__GoodsReceiptLine__c> goodsReceiptLines, List<SourceObjectInfo> goodsReceiptLinesInfo){
        Map<Id, dmpl__InspectionLine__c> result = new Map<Id, dmpl__InspectionLine__c>();
        if(goodsReceiptLines.size() == 0){
            throw new DMPLException(String.format(String.valueOf(System.Label.Generic_EmptyActionParam), new String[]{dmpl__GoodsReceiptLine__c.class.getName()}));
        }
        
        if(goodsReceiptLines.size() >0){
            Savepoint sp = Database.setSavepoint();
            List<dmpl__InspectionLine__c> newInspectionLines = new List<dmpl__InspectionLine__c>();
            for(dmpl__GoodsReceiptLine__c goodsReceiptLine : goodsReceiptLines){
                newInspectionLines.add(createNewInspectionLine(goodsReceiptLine, goodsReceiptLinesInfo));
            }

            try {
                skipValidations = true;
                SecurityHelper.ensureCanCreateObject('dmpl__InspectionLine__c');
                SecurityHelper.ensureCanCreateFields(new String[]{'dmpl__ReceiptLineId__c','dmpl__ItemId__c','dmpl__SKUId__c','dmpl__StorageLocationId__c','dmpl__UnitCost__c','dmpl__ItemLotId__c','dmpl__InventoryLedgerId__c','dmpl__ReceivedQuantity__c','dmpl__OrderQuantity__c','dmpl__ReceiptId__c','dmpl__SupplierInvoiceQuantity__c','dmpl__InspectionQuantity__c','dmpl__IsILPostingApproved__c','dmpl__IsPosted__c'},'dmpl__InspectionLine__c');
                insert newInspectionLines;
                result = new Map<Id, dmpl__InspectionLine__c>(newInspectionLines);
            } catch (Exception e) {
            	Database.rollback(sp);
            	throw e;
           	}
           finally{
           	    skipValidations = false;
           }
        }
        return result;
    }

    private static Map<Id, dmpl__InspectionLine__c> completeInspection(List<dmpl__InspectionLine__c> inspectionLines){
        Map<Id, dmpl__InspectionLine__c> result = new Map<Id, dmpl__InspectionLine__c>();
        if(inspectionLines.size() == 0){
            throw new DMPLException(String.format(String.valueOf(System.Label.Generic_EmptyActionParam), new String[]{dmpl__GoodsReceiptLine__c.class.getName()}));
        }

        if(inspectionLines.size() >0){
            Savepoint sp = Database.setSavepoint();
            for(dmpl__InspectionLine__c inspectionLine : inspectionLines){
                inspectionLine.dmpl__InspectionQuantity__c = (-1) * inspectionLine.dmpl__ReceivedQuantity__c;
                inspectionLine.dmpl__AdjustmentQuantity__c = 0;//   (inspectionLine.dmpl__SupplierInvoiceQuantity__c == null ? 0 : inspectionLine.dmpl__SupplierInvoiceQuantity__c) - (inspectionLine.dmpl__ReceivedQuantity__c == null ? 0 : inspectionLine.dmpl__ReceivedQuantity__c); 
                inspectionLine.dmpl__IsILPostingApproved__c = true;
                inspectionLine.dmpl__IsApproved__c = true;
                inspectionLine.dmpl__InspectionDone__c = true;
            }
            try {
                skipValidations = true;
                SecurityHelper.ensureCanWriteFields(new String[]{'dmpl__ReceiptLineId__c','dmpl__ItemId__c','dmpl__SKUId__c','dmpl__StorageLocationId__c','dmpl__UnitCost__c','dmpl__ItemLotId__c','DMPL__InventoryLedgerId__c','dmpl__ReceivedQuantity__c','dmpl__OrderQuantity__c','dmpl__SupplierInvoiceQuantity__c','dmpl__InspectionQuantity__c','dmpl__IsILPostingApproved__c','dmpl__IsPosted__c'},'dmpl__InspectionLine__c');
                update inspectionLines;
                result = new Map<Id, dmpl__InspectionLine__c>(inspectionLines);
            } catch (Exception e) {
            	Database.rollback(sp);
                throw new DMPLException(e.getMessage());
           } finally{
                skipValidations = false;
           }
        }
        return result;
    }

   @TestVisible private static void validateItem(List<dmpl__InspectionLine__c> newEntries){
        Map<Id, dmpl__Item__c> items = new Map<Id,dmpl__Item__c>(ItemHelper.getCachedItems(DocumentHelper.extractIds(newEntries, FIELD_INSPECTIONLINE_ITEMID)));
        for(dmpl__InspectionLine__c inspectionLine : newEntries){
            dmpl__Item__c item = items.get(inspectionLine.dmpl__ItemId__c);
            if(inspectionLine.dmpl__SKUId__c == null && item!=null && item.dmpl__IsSKURequired__c){
                inspectionLine.addError(System.Label.Validation_SKURequired);
            }
            if(inspectionLine.dmpl__SKUId__c != null){
                dmpl__SKU__c sku = (dmpl__SKU__c)CollectionHelper.getObject(item.dmpl__SKUs__r, inspectionLine.dmpl__SKUId__c);
                if(sku ==null){
                    inspectionLine.addError(System.Label.Validation_SKUInvalid);
                }
            }
            if(inspectionLine.dmpl__InspectionDone__c && item.dmpl__RequireRepairOrderOnReceipt__c && !inspectionLine.dmpl__IsRepairOrderClosed__c)
                inspectionLine.addError(System.Label.Close_Repair_Order_To_Complete_Inspection);
        }
    }

    private static dmpl__InspectionLine__c createNewInspectionLine(dmpl__GoodsReceiptLine__c goodsReceiptLine, List<SourceObjectInfo> goodsReceiptLinesInfo){
        Decimal requestedQty = SourceObjectInfo.getRequestedQuantity(goodsReceiptLinesInfo, goodsReceiptLine.Id);
        return new dmpl__InspectionLine__c(
            dmpl__ReceiptLineId__c = goodsReceiptLine.ID,
            dmpl__ItemId__c = goodsReceiptLine.dmpl__ItemId__c,
            dmpl__SKUId__c = goodsReceiptLine.dmpl__SKUId__c,
            DMPL__StorageLocationId__c = goodsReceiptLine.DMPL__StorageLocationId__c,
            dmpl__UnitCost__c = goodsReceiptLine.dmpl__UnitCost__c,
            dmpl__ItemLotId__c = goodsReceiptLine.dmpl__ItemLotId__c,
            DMPL__InventoryLedgerId__c = goodsReceiptLine.dmpl__InventoryLedgerInspectionId__c,
            dmpl__ReceivedQuantity__c = requestedQty == 0 ? (goodsReceiptLine.dmpl__PendingInspectionQuantity__c - (goodsReceiptLine.dmpl__DamagedQuantity__c == null ? 0 : goodsReceiptLine.dmpl__DamagedQuantity__c)) : requestedQty,
            dmpl__OrderQuantity__c	 = goodsReceiptLine.dmpl__OrderedQuantity__c,
            dmpl__ReceiptId__c = goodsReceiptLine.dmpl__GoodsReceiptId__c,
            dmpl__SupplierInvoiceQuantity__c = goodsReceiptLine.DMPL__SupplierQuantity__c,
            dmpl__InspectionQuantity__c = requestedQty == 0 ? (goodsReceiptLine.dmpl__PendingInspectionQuantity__c - (goodsReceiptLine.dmpl__DamagedQuantity__c == null ? 0 : goodsReceiptLine.dmpl__DamagedQuantity__c)) : requestedQty,
            dmpl__IsILPostingApproved__c = true,
            dmpl__IsPosted__c = false);
    }

    private static List<dmpl__GoodsReceiptLine__c> queryGoodsReceiptLines(List<Id> goodsReceiptIds)
    {
        SecurityHelper.ensureCanReadFields(new string[]{'dmpl__SKUId__c','dmpl__ItemId__c','dmpl__ReceivedQuantity__c','dmpl__GoodsReceiptId__c','dmpl__IsApproved__c','dmpl__InventoryLedgerInspectionId__c','dmpl__UnitCost__c','dmpl__ItemLotId__c','dmpl__OrderedQuantity__c','dmpl__PendingInspectionQuantity__c'}, 'dmpl__GoodsReceiptLine__c');
        return [SELECT ID,
        Name,
        dmpl__IsApproved__c,
        dmpl__UnitCost__c,
        dmpl__InventoryLedgerInspectionId__c,
        dmpl__ItemLotId__c,
        dmpl__OrderedQuantity__c,
        dmpl__ReceivedQuantity__c,
        dmpl__DamagedQuantity__c,
        dmpl__GoodsReceiptId__c,
        dmpl__SKUId__c,
        dmpl__StorageLocationId__c,
        dmpl__SupplierQuantity__c,
        dmpl__ItemId__c,
        dmpl__PendingInspectionQuantity__c
        FROM
        dmpl__GoodsReceiptLine__c 
        WHERE dmpl__GoodsReceiptId__c IN : goodsReceiptIds
        AND dmpl__ItemId__r.dmpl__RequireInspectionOnReceipt__c = true
        AND dmpl__PendingInspectionQuantity__c > 0
        ];
    }

    private static List<dmpl__InspectionLine__c> queryInspectionLines(List<ID> goodsReceiptIds)
    {
        SecurityHelper.ensureCanReadFields(new string[]{'dmpl__ItemId__c','dmpl__SKUId__c','dmpl__DamagedQuantity__c','dmpl__ExcessQuantity__c','dmpl__OrderQuantity__c','dmpl__ReceivedQuantity__c','dmpl__ReceiptId__c','dmpl__ShortageQuantity__c','dmpl__SupplierInvoiceQuantity__c','dmpl__InspectionDone__c','dmpl__IsApproved__c','dmpl__IsRepairOrderClosed__c'}, 'dmpl__InspectionLine__c');
        return [SELECT ID,
            Name,
            dmpl__DamagedQuantity__c,
            dmpl__ExcessQuantity__c,
            dmpl__OrderQuantity__c,
            dmpl__ReceiptId__c,
            dmpl__ReceivedQuantity__c,
            dmpl__ShortageQuantity__c,
            dmpl__SupplierInvoiceQuantity__c,
            dmpl__InspectionDone__c,
            dmpl__IsApproved__c,
            dmpl__ItemId__c,
            dmpl__SKUId__c,
            dmpl__IsRepairOrderClosed__c
        FROM 
            dmpl__InspectionLine__c 
        WHERE 
            dmpl__ReceiptId__c IN : goodsReceiptIds
            AND dmpl__InspectionQuantity__c > 0];
    }

    private static List<dmpl__InspectionLine__c> queryInspectionLinesFromId(List<ID> inspectionLineIds)
    {
        SecurityHelper.ensureCanReadFields(new string[]{'dmpl__IsRepairOrderClosed__c'}, 'dmpl__InspectionLine__c');
        return [SELECT ID,
            Name,
            dmpl__IsRepairOrderClosed__c
        FROM 
            dmpl__InspectionLine__c 
        WHERE 
            Id IN : inspectionLineIds];
    }
}