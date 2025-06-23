public with sharing class BillLineHelper {
    
    private static Boolean skipValidations = false;

    private static final string OBJECT_PURCHASEINVOICE = 'dmpl__Bill__c';
    private static final string OBJECT_PURCHASEINVOICELINE = 'dmpl__BillLine__c';
    private static final string FIELD_PURCHASEINVOICELINE_PURCHASEINVOICEID = 'dmpl__PurchaseInvoiceId__c';
    private static final string FIELD_PURCHASEINVOICELINE_ITEMID = 'dmpl__ItemId__c';
    private static final string FIELD_PURCHASEINVOICELINE_ITEMLOTID = 'dmpl__ItemLotId__c';
    private static final string FIELD_PURCHASEINVOICELINE_SKUID = 'dmpl__SKUId__c';
    private static final string FIELD_PURCHASEINVOICELINE_QUANTITY = 'dmpl__Quantity__c';
    private static final string FIELD_PURCHASEINVOICELINE_GLID = 'dmpl__GeneralLedgerId__c';
    private static final string FIELD_PURCHASEINVOICELINE_GLACCOUNTID = 'dmpl__GLAccountId__c';
    private static final string FIELD_PURCHASEINVOICELINE_ISGLPOSTED = 'dmpl__IsGLPosted__c';
    private static final string FIELD_PURCHASEINVOICELINE_ISGLPOSTINGAPPROVED = 'dmpl__IsGLPostingApproved__c';
    private static final string FIELD_PURCHASEINVOICELINELINE_ISILPOSTINGAPPROVED = 'dmpl__IsILPostingApproved__c';
    private static final string FIELD_PURCHASEINVOICELINELINE_ISGLPOSTINGAPPROVED ='dmpl__IsGLPostingApproved__c';
    private static final string FIELD_PURCHASEINVOICELINE_RETURNEDQUANTITY = 'dmpl__ReturnedQuantity__c';
    private static final string FIELD_PURCHASEINVOICELINE_AMOUNT = 'dmpl__Amount__c';
    private static final string FIELD_AGG_PURCHASEINVOICELINEID = 'PurchaseInvoiceLineId';
    private static final string FIELD_AGG_TOTALQTY = 'TotalQuantity';
    
    private static final string FIELDNAME_PURCHASEINVOICELINE_PRICELISTRULEID = 'dmpl__PriceListRuleId__c';
    private static final string FIELD_PURCHASEINVOICELINE_PURCHASEORDERLINEID = 'dmpl__PurchaseOrderLineId__c';
    private static final string FIELD_PURCHASEINVOICELINE_RECEIPTLINEID = 'dmpl__GoodsReceiptLineId__c';
    private static final string FIELD_PURCHASEINVOICELINE_TAXGROUPID = 'dmpl__TaxGroupId__c';

    private static final string RELATION_PURCHASEINVOICELINE_STATUS = 'dmpl__PurchaseInvoiceId__r.dmpl__Status__c';
    
    private static final string FIELD_PURCHASEINVOICELINE_CONTRACTDISCOUNT = 'dmpl__ContractDiscount__c';
    private static final string FIELD_PURCHASEINVOICELINE_DISCOUNT = 'dmpl__Discount__c';
    private static final string FIELD_PURCHASEINVOICELINE_DISCOUNT2 = 'dmpl__Discount2__c';
    private static final string FIELD_PURCHASEINVOICELINE_SCHEMEDISCOUNT = 'dmpl__SchemeDiscount__c';

    private static final List<String> LIST_FIELDS_NONEDITABLE = new List<String>{
        FIELD_PURCHASEINVOICELINE_PURCHASEINVOICEID
    };
    private static final List<String> LIST_FIELDS_SYSTEM = new List<String>{
        FIELD_PURCHASEINVOICELINE_GLID,
        FIELD_PURCHASEINVOICELINE_ISGLPOSTED,
        FIELD_PURCHASEINVOICELINE_RETURNEDQUANTITY
    };
    private static final List<String> LIST_FIELDS_SOURCEPOULATED = new List<String>{
        FIELD_PURCHASEINVOICELINE_ITEMID,
        FIELD_PURCHASEINVOICELINE_ITEMLOTID,
        FIELD_PURCHASEINVOICELINE_SKUID,
        FIELD_PURCHASEINVOICELINE_TAXGROUPID
    };
    private static final List<String> LIST_FIELDS_LOCKEDIFTRANSACTED = new List<String>{
        FIELD_PURCHASEINVOICELINE_ITEMID,
        FIELD_PURCHASEINVOICELINE_ITEMLOTID,
        FIELD_PURCHASEINVOICELINE_SKUID,
        FIELD_PURCHASEINVOICELINE_RECEIPTLINEID,
        FIELD_PURCHASEINVOICELINE_PURCHASEORDERLINEID
    };

    private static final List<String> LIST_FIELDS_NEGATIVEANDZERONOTALLOWED = new List<String>{
    };
    
    private static final List<String> LIST_FIELDS_NEGATIVENOTALLOWED = new List<String>{
        'dmpl__EligibleReturnQuantity__c', 
        'dmpl__InvoiceQuantity__c', 
        'dmpl__Quantity__c', 
        'dmpl__ReturnedQuantity__c'
    };

    private static final List<String> LIST_FIELDS_PERCENT = new List<String>{
        FIELD_PURCHASEINVOICELINE_CONTRACTDISCOUNT,
        FIELD_PURCHASEINVOICELINE_DISCOUNT,
        FIELD_PURCHASEINVOICELINE_DISCOUNT2,
        FIELD_PURCHASEINVOICELINE_SCHEMEDISCOUNT
    };

    public static void validateData(Boolean isInsert, Boolean isDelete, Boolean isUpdate, List<dmpl__BillLine__c> oldEntries, List<dmpl__BillLine__c> newEntries)
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
                ValidationHelper.validateValidPercent(
                    LIST_FIELDS_PERCENT, 
                    newEntries);
            }

            if(skipValidations){
                return;
            }

            DocumentStatusDFSHelper dfsHelper = new DocumentStatusDFSHelper();
            if(isInsert){
                validateItem(newEntries);
                dfsHelper.DocumentStatusRelatedObjectRestrictEdits_New(OBJECT_PURCHASEINVOICE, OBJECT_PURCHASEINVOICELINE, RELATION_PURCHASEINVOICELINE_STATUS, newEntries);
            }else if(isUpdate){
                DocumentHelper.validateChangeInSystemFields(LIST_FIELDS_SYSTEM, oldEntries, newEntries);
                DocumentHelper.validateChangeInKeyFields(LIST_FIELDS_NONEDITABLE, oldEntries, newEntries);
                DocumentHelper.validateChangeInSourcePopulatedFields(LIST_FIELDS_SOURCEPOULATED, oldEntries, newEntries, FIELD_PURCHASEINVOICELINE_RECEIPTLINEID);
                DocumentHelper.validateChangeInLockedIfTransactedFields(LIST_FIELDS_LOCKEDIFTRANSACTED, oldEntries, newEntries, FIELD_PURCHASEINVOICELINE_QUANTITY);
                dfsHelper.DocumentStatusRelatedObjectRestrictEdits_Edit(OBJECT_PURCHASEINVOICE, OBJECT_PURCHASEINVOICELINE, RELATION_PURCHASEINVOICELINE_STATUS, oldEntries, newEntries);
                validateChangeInQuantity(oldEntries, newEntries);
            }else if(isDelete){
                DocumentHelper.validateCanBeDeleted(oldEntries, FIELD_PURCHASEINVOICELINE_RETURNEDQUANTITY);
                dfsHelper.DocumentStatusRelatedObjectRestrictEdits_Delete(OBJECT_PURCHASEINVOICE, OBJECT_PURCHASEINVOICELINE, RELATION_PURCHASEINVOICELINE_STATUS, oldEntries);
            }
        } catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }

    public static void postData(Boolean isInsert, Boolean isDelete, Boolean isUpdate, List<dmpl__BillLine__c> oldEntries, List<dmpl__BillLine__c> newEntries)
    {
        try{
            if(isInsert){
                setItemData(newEntries);
                TaxHelper.setLinesTaxes(newEntries);
            }else if(isUpdate){
                List<dmpl__BillLine__c> modifiedObjects = DocumentHelper.getModifiedNewObjects(FIELDNAME_PURCHASEINVOICELINE_PRICELISTRULEID, oldEntries, newEntries);
                if(modifiedObjects.size()>0){
                    Map<Id, dmpl__Item__c> items = new Map<Id,dmpl__Item__c>(ItemHelper.getCachedItems(DocumentHelper.extractIds(modifiedObjects, FIELD_PURCHASEINVOICELINE_ITEMID)));
                    List<dmpl__Bill__c> billDocuments = queryPurchaseInvoiceDocument(DocumentHelper.extractIds(modifiedObjects, FIELD_PURCHASEINVOICELINE_PURCHASEINVOICEID));
                    PriceListHelper.setApplicablePrices(
                        modifiedObjects, 
                        billDocuments, 
                        items.values(), 
                        DocumentHelper.extractIds(
                            modifiedObjects, 
                            FIELDNAME_PURCHASEINVOICELINE_PRICELISTRULEID),
                        'dmpl__PurchaseInvoiceId__c');
                }
                
                modifiedObjects = DocumentHelper.getModifiedNewObjects(
                    new List<String>{
                        'dmpl__PriceListId__c',
                        'dmpl__PriceAsOnDate__c'
                    },
                    oldEntries, 
                    newEntries);
                if(modifiedObjects.size()>0){
                    Map<Id, dmpl__Item__c> items = new Map<Id,dmpl__Item__c>(ItemHelper.getCachedItems(
                        DocumentHelper.extractIds(
                            modifiedObjects, 
                            FIELD_PURCHASEINVOICELINE_ITEMID)));
                    List<dmpl__Bill__c> billDocuments = queryPurchaseInvoiceDocument(
                        DocumentHelper.extractIds(
                            modifiedObjects, 
                            FIELD_PURCHASEINVOICELINE_PURCHASEINVOICEID));
                    PriceListHelper.setApplicablePrices(
                        modifiedObjects, 
                        billDocuments, 
                        items.values(), 
                        true);
                }

                List<dmpl__BillLine__c> modifiedBills = DocumentHelper.getPostedObjects(
                    FIELD_PURCHASEINVOICELINELINE_ISGLPOSTINGAPPROVED, 
                    oldEntries, 
                    newEntries);
                if(modifiedBills.Size() > 0){
                    GeneralLedgerHelper.createLedger(
                        GeneralLedgerTypeEnums.BillLine, 
                        isInsert, 
                        isDelete, 
                        isUpdate, 
                        oldEntries, 
                        newEntries);
                }

                modifiedObjects = DocumentHelper.getModifiedNewObjects(
                    new string[]{
                        'dmpl__TaxGroupId__c',
                        'dmpl__ItemId__c', 
                        'dmpl__SKUId__c',
                        'dmpl__Amount__c'
                    }, 
                    oldEntries, 
                    newEntries);
                if(modifiedObjects.size()>0){
                    TaxHelper.setLinesTaxes(newEntries);
                }
                Map<Id, dmpl__Item__c> items = new Map<Id,dmpl__Item__c>(
                ItemHelper.getCachedItems(
                DocumentHelper.extractIds(
                    newEntries, 
                    FIELD_PURCHASEINVOICELINE_ITEMID)));
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
            }
            else if(isDelete){
            }

            List<dmpl__BillLine__c> modifiedLedgerObjects = DocumentHelper.getPostedObjects(FIELD_PURCHASEINVOICELINELINE_ISILPOSTINGAPPROVED, oldEntries, newEntries);
            if(modifiedLedgerObjects.Size() > 0){
                if(isInsert || isUpdate){
                    InventoryLedgerHelper.createLedger(InventoryLedgerTypeEnums.Purchased, FIELD_PURCHASEINVOICELINE_PURCHASEINVOICEID, OBJECT_PURCHASEINVOICE, isInsert, isDelete, isUpdate, oldEntries, modifiedLedgerObjects);
                } else {
                    InventoryLedgerHelper.createLedger(InventoryLedgerTypeEnums.Purchased, FIELD_PURCHASEINVOICELINE_PURCHASEINVOICEID, OBJECT_PURCHASEINVOICE, isInsert, isDelete, isUpdate, modifiedLedgerObjects, newEntries);
                }
            }
        } catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }

    public static void afterPostData(Boolean isInsert, Boolean isDelete, Boolean isUpdate, List<dmpl__BillLine__c> oldEntries, List<dmpl__BillLine__c> newEntries)
    {
        try{
            if(isDelete){
                PurchaseOrderLineHelper.updatePurchaseInvoiceQuantity(DocumentHelper.extractIds(oldEntries, FIELD_PURCHASEINVOICELINE_PURCHASEORDERLINEID));
                GoodReceiptLineHelper.updatePurchaseInvoiceQuantity(DocumentHelper.extractIds(oldEntries, FIELD_PURCHASEINVOICELINE_RECEIPTLINEID));
                TaxHelper.deleteLinesTaxes(oldEntries);
            }else if(isInsert){
                // PurchaseOrderLineHelper.updatePurchaseInvoiceQuantity(DocumentHelper.extractIds(newEntries, FIELD_PURCHASEINVOICELINE_PURCHASEORDERLINEID));
                // GoodReceiptLineHelper.updatePurchaseInvoiceQuantity(DocumentHelper.extractIds(newEntries, FIELD_PURCHASEINVOICELINE_RECEIPTLINEID));
                TaxHelper.createLinesTaxes(
                    isInsert, 
                    newEntries);
            }else if(isUpdate){
                List<dmpl__BillLine__c> modifiedObjects = DocumentHelper.getApprovedObjects(FIELD_PURCHASEINVOICELINE_ISGLPOSTINGAPPROVED, oldEntries, newEntries);
                if(modifiedObjects.size()>0){
                    PurchaseOrderLineHelper.updatePurchaseInvoiceQuantity(DocumentHelper.extractIds(modifiedObjects, FIELD_PURCHASEINVOICELINE_PURCHASEORDERLINEID));
                    GoodReceiptLineHelper.updatePurchaseInvoiceQuantity(DocumentHelper.extractIds(modifiedObjects, FIELD_PURCHASEINVOICELINE_RECEIPTLINEID));
                }
                
                modifiedObjects = DocumentHelper.getModifiedNewObjects(new string[]{FIELD_PURCHASEINVOICELINE_TAXGROUPID,FIELD_PURCHASEINVOICELINE_ITEMID, FIELD_PURCHASEINVOICELINE_SKUID,FIELD_PURCHASEINVOICELINE_AMOUNT}, oldEntries, newEntries);
                if(modifiedObjects.size()>0){
                    TaxHelper.createLinesTaxes(
                        isInsert,
                        modifiedObjects);
                }
            }

            List<dmpl__BillLine__c> entries = isDelete ? oldEntries : newEntries; 
            if(isUpdate){
                entries = DocumentHelper.getModifiedNewObjects(
                    new string[]{
                        FIELD_PURCHASEINVOICELINE_TAXGROUPID,
                        FIELD_PURCHASEINVOICELINE_ITEMID, 
                        FIELD_PURCHASEINVOICELINE_SKUID,
                        FIELD_PURCHASEINVOICELINE_AMOUNT}, 
                    oldEntries, 
                    newEntries);
            }  
            if(entries.size()>0){
                // List<dmpl__Bill__c> billDocuments = queryPurchaseInvoiceDocument(
                //     DocumentHelper.extractIds(
                //         entries,
                //         FIELD_PURCHASEINVOICELINE_PURCHASEINVOICEID));
                // PurchaseInvoiceTaxHelper.setApplicableTaxes(
                //     billDocuments);

                List<dmpl__Bill__c> invoiceDocuments = queryPurchaseInvoiceDocument(
                    DocumentHelper.extractIds(
                        entries,
                        FIELD_PURCHASEINVOICELINE_PURCHASEINVOICEID));
                    SchemeEngine.processSchemes(invoiceDocuments);
            }
        } catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }

    public static void approvePurchaseInvoiceLines(List<dmpl__Bill__c> invoices){
        List<dmpl__BillLine__c> invoiceLines = queryInvoiceLines(invoices);
        for(dmpl__Bill__c invoice : invoices){
            approveInvoiceLines(DocumentHelper.getObjects(invoiceLines, FIELD_PURCHASEINVOICELINE_PURCHASEINVOICEID, invoice.Id));
        }
        try {
            skipValidations = true;
            SecurityHelper.ensureCanWriteFields(new String[]{'dmpl__IsILPostingApproved__c','dmpl__IsGLPostingApproved__c'}, 'dmpl__BillLine__c');
            Update invoiceLines;
            
        } finally {
            skipValidations = false;
        }
    }

    // public static void updateBillLinesFromPurchaseReturn(List<dmpl__PurchaseReturn__c> purchaseReturns){
    //     updateBillLines(queryPurchaseReturnLines(DocumentHelper.extractIds(purchaseReturns)));
    // }

    public static void updatePurchaseReturnQuantity(List<Id> purchaseInvoiceLineIds)
    {
        try{
            if(purchaseInvoiceLineIds.size() == 0 || purchaseInvoiceLineIds == null)
                return;
            skipValidations = true;
             
            SecurityHelper.ensureCanReadFields(new string[]{
                'dmpl__BillLineId__c',
                'dmpl__Quantity__c'
            }, 'dmpl__PurchaseReturnLine__c');
            List<AggregateResult> ffAggregates = 
                [SELECT 
                dmpl__BillLineId__c PurchaseInvoiceLineId, 
                    SUM(dmpl__Quantity__c) TotalQuantity
                FROM 
                    dmpl__PurchaseReturnLine__c
                WHERE 
                dmpl__BillLineId__c IN :purchaseInvoiceLineIds
                WITH SECURITY_ENFORCED
                GROUP BY dmpl__BillLineId__c];
             
            SecurityHelper.ensureCanReadFields(new string[]{
                'dmpl__ReturnedQuantity__c'
            }, 'dmpl__BillLine__c');
            List<dmpl__BillLine__c> orderLinesToUpdate = 
                [SELECT 
                    Id, 
                    dmpl__ReturnedQuantity__c
                FROM 
                dmpl__BillLine__c
                WHERE 
                    Id IN :purchaseInvoiceLineIds];
    
            for(dmpl__BillLine__c orderLine : orderLinesToUpdate){
                for(AggregateResult result : ffAggregates){
                    if(result.get(FIELD_AGG_PURCHASEINVOICELINEID) == orderLine.Id){
                        orderLine.dmpl__ReturnedQuantity__c 
                            = result.get(FIELD_AGG_TOTALQTY) ==null ? 
                                0 : (Decimal)(result.get(FIELD_AGG_TOTALQTY));
                        break;
                    }
                }
            }
            SecurityHelper.ensureCanWriteFields(new string[]{
                'dmpl__ReturnedQuantity__c'
            }, 'dmpl__BillLine__c');
            Update orderLinesToUpdate;
        }finally{
            skipValidations = false;
        }
    }

    public static void updateBillReturnQuantity(List<Id> purchaseInvoiceLineIds)
    {
        try{
            if(purchaseInvoiceLineIds.size() == 0 || purchaseInvoiceLineIds == null)
                return;
            skipValidations = true;
             
            SecurityHelper.ensureCanReadFields(new string[]{
                'dmpl__BillLineId__c',
                'dmpl__Quantity__c'
            }, 'dmpl__BillReturnLine__c');
            List<AggregateResult> ffAggregates = 
                [SELECT 
                dmpl__BillLineId__c PurchaseInvoiceLineId, 
                    SUM(dmpl__Quantity__c) TotalQuantity
                FROM 
                dmpl__BillReturnLine__c
                WHERE 
                dmpl__BillLineId__c IN :purchaseInvoiceLineIds
                WITH SECURITY_ENFORCED
                GROUP BY dmpl__BillLineId__c];
             
            SecurityHelper.ensureCanReadFields(new string[]{
                'dmpl__ReturnedQuantity__c'
            }, 'dmpl__BillLine__c');
            List<dmpl__BillLine__c> orderLinesToUpdate = 
                [SELECT 
                    Id, 
                    dmpl__ReturnedQuantity__c
                FROM 
                dmpl__BillLine__c
                WHERE 
                    Id IN :purchaseInvoiceLineIds];
    
            for(dmpl__BillLine__c orderLine : orderLinesToUpdate){
                for(AggregateResult result : ffAggregates){
                    if(result.get(FIELD_AGG_PURCHASEINVOICELINEID) == orderLine.Id){
                        orderLine.dmpl__ReturnedQuantity__c 
                            = result.get(FIELD_AGG_TOTALQTY) ==null ? 
                                0 : (Decimal)(result.get(FIELD_AGG_TOTALQTY));
                        break;
                    }
                }
            }
            SecurityHelper.ensureCanWriteFields(new string[]{
                'dmpl__ReturnedQuantity__c'
            }, 'dmpl__BillLine__c');
            Update orderLinesToUpdate;
        }finally{
            skipValidations = false;
        }
    }

    public static void performReprice(Id billId){
        performReprice(new List<Id>{billId});
    }

    public static void performReprice(List<Id> billIds){
        List<dmpl__Bill__c> billDocuments = queryPurchaseInvoiceDocument(
            billIds);
        List<dmpl__BillLine__c> billLines = queryBillLinesOfBills(
            CollectionHelper.extractIds(
                billDocuments));
        Map<Id, dmpl__Item__c> items = new Map<Id,dmpl__Item__c>(
            ItemHelper.getCachedItems(
                DocumentHelper.extractIds(
                    billLines, 
                    FIELD_PURCHASEINVOICELINE_ITEMID)));

        PriceListHelper.setApplicablePrices(
            billLines, 
            billDocuments, 
            items.values(),
            true);
        update billLines;
    }

    private static void approveInvoiceLines(List<dmpl__BillLine__c> documentInvoiceLines)
    {
        for(dmpl__BillLine__c invoiceLine : documentInvoiceLines){
            //invoiceLine.dmpl__IsGLPostingApproved__c = true;
            invoiceLine.dmpl__IsILPostingApproved__c = true;
        }
    }

    // private static void updateBillLines(List<dmpl__PurchaseReturnLine__c> purchaseReturnLines){
    //     Map<ID,dmpl__BillLine__c> billLines = new Map<ID, dmpl__BillLine__c>(queryBillLines(DocumentHelper.extractIds(purchaseReturnLines, 'dmpl__BillLineId__c')));
    //     for(dmpl__PurchaseReturnLine__c lineEntry : purchaseReturnLines)
    //         billLines.get(lineEntry.dmpl__BillLineId__c).dmpl__ReturnedQuantity__c = lineEntry.dmpl__Quantity__c;
            
    //     try{    
    //         skipValidations = true;
    //         update billLines.values();
    //     }catch(Exception error){
    //         ExceptionLogHelper.logException(error);
    //         throw error;
    //     }finally{
    //         skipValidations = false;
    //     }
    // }

    private static void validateItem(List<dmpl__BillLine__c> newEntries){
        Map<Id, dmpl__Item__c> items = new Map<Id,dmpl__Item__c>(ItemHelper.getCachedItems(DocumentHelper.extractIds(newEntries, FIELD_PURCHASEINVOICELINE_ITEMID)));
        for(dmpl__BillLine__c orderLine : newEntries){
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

    private static List<dmpl__BillLine__c> queryInvoiceLines(List<dmpl__Bill__c> documents){
        SecurityHelper.ensureCanReadFields(new String[]{'dmpl__PurchaseInvoiceId__c','dmpl__IsGLPostingApproved__c','dmpl__IsILPostingApproved__c'}, 'dmpl__BillLine__c');
        return [SELECT ID, dmpl__PurchaseInvoiceId__c, dmpl__IsGLPostingApproved__c,dmpl__IsILPostingApproved__c
                FROM dmpl__BillLine__c
                WHERE dmpl__PurchaseInvoiceId__c IN :DocumentHelper.extractIds(documents)];
    }

    @testVisible
    private static List<dmpl__PurchaseReturnLine__c> queryPurchaseReturnLines(List<ID> purchaseReturnIds){
        SecurityHelper.ensureCanReadFields(new String[]{'dmpl__GoodsReceiptLineId__c','dmpl__Quantity__c','dmpl__PurchaseReturnId__c','dmpl__BillLineId__c','dmpl__PurchaseInvoiceId__c'}, 'dmpl__PurchaseReturnLine__c');
        return [SELECT Id, Name, dmpl__GoodsReceiptLineId__c, dmpl__Quantity__c, dmpl__PurchaseReturnId__c, dmpl__BillLineId__c, dmpl__PurchaseInvoiceId__c FROM dmpl__PurchaseReturnLine__c WHERE dmpl__PurchaseReturnId__c IN : purchaseReturnIds];
    }

    @testVisible
    private static List<dmpl__BillLine__c> queryBillLines(List<ID> billLineIds){
        SecurityHelper.ensureCanReadFields(new String[]{'dmpl__ReturnedQuantity__c'}, 'dmpl__BillLine__c');
        return [SELECT ID, 
        Name, 
        dmpl__ReturnedQuantity__c
        FROM dmpl__BillLine__c
        WHERE ID IN : billLineIds];
    }

    private static void setItemData(List<dmpl__BillLine__c> newEntries)
    {
        Map<Id, dmpl__Item__c> items = new Map<Id,dmpl__Item__c>(
        ItemHelper.getCachedItems(DocumentHelper.extractIds(newEntries, FIELD_PURCHASEINVOICELINE_ITEMID)));
        List<dmpl__Bill__c> purchaseInvoiceDocuments = queryPurchaseInvoiceDocument(DocumentHelper.extractIds(newEntries, FIELD_PURCHASEINVOICELINE_PURCHASEINVOICEID));
        ItemHelper.setQuantityFromUOM(
            newEntries, 
            null,
            items);
        TaxGroupHelper.setApplicableTaxGroups(newEntries, purchaseInvoiceDocuments, items.values());
        PriceListHelper.setApplicablePrices(
            newEntries, 
            purchaseInvoiceDocuments, 
            items.values(),
            false);
        DiscountGroupHelper.setApplicableDiscounts(newEntries, purchaseInvoiceDocuments, items.values());
    }

    private static void validateChangeInQuantity(List<dmpl__BillLine__c> oldEntries, List<dmpl__BillLine__c> newEntries){
        Map<Id, dmpl__BillLine__c> oldObjectsMap = new Map<Id, dmpl__BillLine__c>(oldEntries);
        for(dmpl__BillLine__c lineEntry : newEntries){
            dmpl__BillLine__c oldEntry = oldObjectsMap.get(lineEntry.Id);
            if(oldEntry != null){
                Double transactedQty = oldEntry.dmpl__ReturnedQuantity__c == null ? 0 : oldEntry.dmpl__ReturnedQuantity__c;
                if(oldEntry.dmpl__Quantity__c != lineEntry.dmpl__Quantity__c && lineEntry.dmpl__Quantity__c!=null
                    && lineEntry.dmpl__Quantity__c < transactedQty) {
                    lineEntry.addError(String.format(
                        String.valueOf(System.Label.IntegrityFailed_TransactedQuantityCanNotBeReduced), 
                        new String[]{String.valueOf(transactedQty)})); 
                } 
            }   
        }
    }

    private static List<dmpl__Bill__c> queryPurchaseInvoiceDocument(
        List<ID> purchaseInvoiceLineIds){
        SecurityHelper.ensureCanReadFields(new string[]{
            'dmpl__DocumentDate__c',
            'dmpl__BranchId__c',
            'dmpl__Status__c',
            'dmpl__PartnerAccountId__c',
            'dmpl__TaxSupplyType__c',
            'dmpl__TaxGroupId__c',
            'dmpl__TaxId__c',
            'dmpl__TotalLineAmount__c',
            'dmpl__DiscountGroupId__c',
            'dmpl__SupplierAccountId__c',
            'dmpl__PriceAsOnDate__c',
            'dmpl__TransactionType__c',
            'dmpl__TCSEligibleAmount__c',
            'dmpl__SkipScheme__c'
        }, 'dmpl__Bill__c');
        return [
            SELECT 
                Id, 
                Name, 
                dmpl__DocumentDate__c,
                dmpl__Status__c,
                dmpl__PriceListId__c,
                dmpl__PartnerAccountId__c,
                dmpl__BranchId__c,
                dmpl__TaxSupplyType__c,
                dmpl__TaxGroupId__c,
                dmpl__TaxId__c,
                dmpl__TotalLineAmount__c,
                dmpl__DiscountGroupId__c,
                dmpl__SupplierAccountId__c,
                dmpl__PriceAsOnDate__c,
                dmpl__TransactionType__c,
                dmpl__TCSEligibleAmount__c,
                dmpl__SkipScheme__c
            FROM dmpl__Bill__c 
            WHERE ID IN : purchaseInvoiceLineIds ];
    }
    
    private static List<dmpl__BillLine__c> queryBillLinesOfBills(
        List<ID> purchaseInvoiceIds)
    {
        SecurityHelper.ensureCanReadFields(new List<String>
        {
            'Name', 
            'dmpl__ItemId__c',
            'dmpl__SKUId__c',
            'dmpl__Quantity__c',
            'dmpl__PriceListId__c',
            'dmpl__UnitCost__c',
            'dmpl__TaxGroupId__c',
            'dmpl__ItemLotTypeId__c',
            'dmpl__TaxAmount__c',
            'dmpl__PurchaseInvoiceId__c'
        },'dmpl__BillLine__c');
        return [ SELECT ID, 
            Name, 
            dmpl__ItemId__c,
            dmpl__SKUId__c,
            dmpl__PriceListId__c,
            dmpl__Quantity__c,
            dmpl__UnitCost__c,
            dmpl__TaxGroupId__c,
            dmpl__ItemLotTypeId__c,
            dmpl__TaxAmount__c,
            dmpl__PurchaseInvoiceId__c,
            dmpl__PriceAsOnDate__c
        FROM dmpl__BillLine__c
        WHERE dmpl__PurchaseInvoiceId__c IN : purchaseInvoiceIds];
    }
}