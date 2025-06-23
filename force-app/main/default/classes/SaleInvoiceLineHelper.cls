public with sharing class SaleInvoiceLineHelper {
    private static Boolean skipValidations = false;
    private static Boolean skipComponentDeleteValidation = false;
    private static Boolean skipComponentAddValidation = false;

    private static final string OBJECT_SALEINVOICE = 'dmpl__SaleInvoice__c';
    private static final string OBJECT_SALEINVOICELINE = 'dmpl__SaleInvoiceLine__c';
    private static final string FIELD_SALEINVOICELINELINE_SALEINVOICEID = 'dmpl__SaleInvoiceId__c';
    private static final string FIELD_SALEINVOICELINELINE_ASSETID = 'dmpl__AssetId__c';
    private static final string FIELD_SALEINVOICELINELINE_ITEMID = 'dmpl__ItemId__c';
    private static final string FIELD_SALEINVOICELINELINE_ITEMLOTID = 'dmpl__ItemLotId__c';
    private static final string FIELD_SALEINVOICELINELINE_SKUID = 'dmpl__SKUId__c';
    private static final string FIELD_SALEINVOICELINELINE_INVENTORYLEDGERID = 'dmpl__InventoryLedgerId__c';
    private static final string FIELD_SALEINVOICELINELINE_ISILPOSTED = 'dmpl__IsILPosted__c';
    private static final string FIELD_SALEINVOICELINELINE_ISILPOSTINGAPPROVED = 'dmpl__IsILPostingApproved__c';
    private static final string FIELD_SALEINVOICELINELINE_QUANTITY = 'dmpl__Quantity__c';
    private static final string FIELD_SALEINVOICELINELINE_GLID = 'dmpl__GeneralLedgerId__c';
    private static final string FIELD_SALEINVOICELINELINE_GLACCOUNTID = 'dmpl__GLAccountId__c';
    private static final string FIELD_SALEINVOICELINELINE_ISGLPOSTED = 'dmpl__IsGLPosted__c';
    private static final string FIELD_SALEINVOICELINELINE_ISGLPOSTINGAPPROVED = 'dmpl__IsGLPostingApproved__c';
    private static final string FIELD_SALEINVOICELINELINE_RETURNEDQUANTITY = 'dmpl__ReturnedQuantity__c';
    private static final string FIELD_SALEINVOICELINELINE_AMOUNT = 'dmpl__Amount__c';
    
    private static final string FIELDNAME_SALEINVOICELINE_PRICELISTRULEID = 'dmpl__PriceListRuleId__c';
    private static final string FIELD_SALEINVOICELINELINE_SALEORDERLINEID = 'dmpl__SaleOrderLineId__c';
    private static final string FIELD_SALEINVOICELINELINE_REPAIRORDERLINEID = 'dmpl__RepairOrderLineId__c';
    private static final string FIELD_SALEINVOICELINELINE_SCHEMEDISCOUNTAMOUNT = 'dmpl__SchemeDiscountAmount__c';
    private static final string FIELD_SALEINVOICELINELINE_SCHEMEDISCOUNTPERCENT = 'dmpl__SchemeDiscount__c';
    private static final string FIELD_SALEINVOICELINELINE_STORAGELOCATIONID = 'dmpl__StorageLocationId__c';
    private static final string FIELD_SALEINVOICELINELINE_TAXGROUPID = 'dmpl__TaxGroupId__c';
    private static final string FIELD_SALEINVOICELINELINE_FULFILLMENTALLOCATIONLINEID = 'dmpl__FulfillmentAllocationLineId__c';
    private static final string FIELD_SALEINVOICELINELINE_SUBSCRIPTIONID = 'dmpl__SubscriptionId__c';
    private static final string FIELD_SALEINVOICELINELINE_SUBSCRIPTIONUSAGESUMMARYID = 'dmpl__SubscriptionUsageSummaryId__c';
    private static final string FIELD_SALEINVOICELINELINE_PACKAGESALEINVOICELINEID = 'dmpl__PackageSaleInvoiceLineId__c';
    private static final string FIELD_AGG_SALEINVOICELINEID = 'SaleInvoiceLineId';
    private static final string FIELD_AGG_TOTALQTY = 'TotalQuantity';
    private static final string RELATION_SALEINVOICELINE_STATUS = 'dmpl__SaleOrderLineId__r.dmpl__Status__c';

    private static final string FIELD_SALEINVOICELINELINE_CONTRACTDISCOUNT = 'dmpl__ContractDiscount__c';
    private static final string FIELD_SALEINVOICELINELINE_DISCOUNT = 'dmpl__Discount__c';
    private static final string FIELD_SALEINVOICELINELINE_DISCOUNT2 = 'dmpl__Discount2__c';
    private static Boolean isAlreadyProcessing =false;

    private static final List<String> LIST_FIELDS_NONEDITABLE = new List<String>{
        FIELD_SALEINVOICELINELINE_ITEMID,
        FIELD_SALEINVOICELINELINE_SKUID
    };
    private static final List<String> LIST_FIELDS_SYSTEM = new List<String>{
        FIELD_SALEINVOICELINELINE_INVENTORYLEDGERID, 
        FIELD_SALEINVOICELINELINE_ISILPOSTED,
        FIELD_SALEINVOICELINELINE_ISILPOSTINGAPPROVED,
        FIELD_SALEINVOICELINELINE_GLID,
        FIELD_SALEINVOICELINELINE_ISGLPOSTED,
        FIELD_SALEINVOICELINELINE_RETURNEDQUANTITY
    };
    private static final List<String> LIST_FIELDS_SOURCEPOULATED = new List<String>{
        FIELD_SALEINVOICELINELINE_ITEMID,
        FIELD_SALEINVOICELINELINE_SKUID,
        FIELD_SALEINVOICELINELINE_TAXGROUPID
    };
    private static final List<String> LIST_FIELDS_LOCKEDIFTRANSACTED = new List<String>{
        FIELD_SALEINVOICELINELINE_STORAGELOCATIONID,
        FIELD_SALEINVOICELINELINE_GLACCOUNTID,
        // FIELD_SALEINVOICELINELINE_ASSETID,
        FIELD_SALEINVOICELINELINE_ITEMID,
        FIELD_SALEINVOICELINELINE_ITEMLOTID,
        FIELD_SALEINVOICELINELINE_SKUID,
        FIELD_SALEINVOICELINELINE_SALEORDERLINEID
    };

    private static final List<String> LIST_FIELDS_NEGATIVENOTALLOWED = new List<String>{
        'dmpl__AllocatedQuantity__c', 
        'dmpl__DeliveredQuantity__c', 
        'dmpl__EligibleReturnQuantity__c', 
        'dmpl__PickedQuantity__c', 
        'dmpl__SoftCommittedQuantity__c'
    };

    private static final List<String> LIST_FIELDS_ZERONOTALLOWED = new List<String>{

    };

    private static final List<String> LIST_FIELDS_PERCENT = new List<String>{
        FIELD_SALEINVOICELINELINE_CONTRACTDISCOUNT,
        FIELD_SALEINVOICELINELINE_DISCOUNT,
        FIELD_SALEINVOICELINELINE_DISCOUNT2,
        FIELD_SALEINVOICELINELINE_SCHEMEDISCOUNTPERCENT
    };

    public static void validateData(
        Boolean isInsert, 
        Boolean isDelete, 
        Boolean isUpdate, 
        List<dmpl__SaleInvoiceLine__c> oldEntries, 
        List<dmpl__SaleInvoiceLine__c> newEntries){
        try{
            if(isInsert){
                setRNASaleInvoiceId(newEntries);
                FieldMappingHelper.copyFieldMappingData(
                    newEntries);
            }
            if(isInsert || isUpdate){
                ValidationHelper.validateNonZeroDecimal(
                    LIST_FIELDS_ZERONOTALLOWED,
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
                dfsHelper.DocumentStatusRelatedObjectRestrictEdits_New(
                    OBJECT_SALEINVOICE, 
                    OBJECT_SALEINVOICELINE, 
                    RELATION_SALEINVOICELINE_STATUS, 
                    newEntries);
                validateBundledItemPrice(
                    newEntries);
                validateItem(
                    newEntries);
                if(!skipComponentAddValidation){
                    List<dmpl__SaleInvoiceLine__c> packgaeLines = DocumentHelper.getObjectsWithNotNull(
                        newEntries, 
                        FIELD_SALEINVOICELINELINE_PACKAGESALEINVOICELINEID);
                    if(packgaeLines.size()>0){
                        PackageHelper.validateComponentsAdd(
                            packgaeLines, 
                            querySaleInvoiceLines(
                                CollectionHelper.extractIds(
                                    newEntries, 
                                    FIELD_SALEINVOICELINELINE_PACKAGESALEINVOICELINEID)));
                    }    
                }
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
                    oldEntries, 
                    newEntries, 
                    FIELD_SALEINVOICELINELINE_SALEORDERLINEID);
                DocumentHelper.validateChangeInLockedIfPostedFields(
                    LIST_FIELDS_LOCKEDIFTRANSACTED, 
                    oldEntries, 
                    newEntries, 
                    FIELD_SALEINVOICELINELINE_ISGLPOSTINGAPPROVED);
                dfsHelper.DocumentStatusRelatedObjectRestrictEdits_Edit(
                    OBJECT_SALEINVOICE, 
                    OBJECT_SALEINVOICELINE, 
                    RELATION_SALEINVOICELINE_STATUS, 
                    oldEntries, 
                    newEntries);
                validateChangeInQuantity(
                    oldEntries, 
                    newEntries);
                validateItemLotAndAsset(
                    oldEntries, 
                    newEntries);
                List<dmpl__SaleInvoiceLine__c> modifiedObjects = DocumentHelper.getModifiedNewObjects(new string[]{
                    FIELD_SALEINVOICELINELINE_QUANTITY
                }, oldEntries, newEntries);
                if(modifiedObjects.size()>0){
                    PackageHelper.validateComponentQuantityEdit(
                        modifiedObjects, querySaleInvoiceLines(
                            CollectionHelper.extractIds(
                                oldEntries, 
                                FIELD_SALEINVOICELINELINE_PACKAGESALEINVOICELINEID)));
                }

                modifiedObjects = DocumentHelper.getModifiedNewObjects(new string[]{
                    'dmpl__UnitPrice__c'}, 
                    oldEntries, 
                    newEntries);
                if(modifiedObjects.size()>0){
                    validateBundledItemPrice(
                        modifiedObjects);
                }
            }else if(isDelete){
                DocumentHelper.validateCanBeDeleted(
                    oldEntries, 
                    FIELD_SALEINVOICELINELINE_RETURNEDQUANTITY);
                dfsHelper.DocumentStatusRelatedObjectRestrictEdits_Delete(
                    OBJECT_SALEINVOICE, 
                    OBJECT_SALEINVOICELINE, 
                    RELATION_SALEINVOICELINE_STATUS, 
                    oldEntries);
                if(!skipComponentDeleteValidation){
                    PackageHelper.validateComponentsDelete(
                        oldEntries, 
                        querySaleInvoiceLines(
                            CollectionHelper.extractIds(
                                oldEntries, 
                                FIELD_SALEINVOICELINELINE_PACKAGESALEINVOICELINEID)));
                }
            }
        } catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }

    public static void postData(
        Boolean isInsert, 
        Boolean isDelete, 
        Boolean isUpdate, 
        List<dmpl__SaleInvoiceLine__c> oldEntries, 
        List<dmpl__SaleInvoiceLine__c> newEntries){
        try{
            if(isInsert){
                setItemData(
                    newEntries);
                setInvoiceDiscount(
                    newEntries);
                TaxHelper.setLinesTaxes(
                    newEntries);
                setAllocationQuantities(
                    newEntries,
                    null);
            } else if(isUpdate){
                List<dmpl__SaleInvoiceLine__c> modifiedObjects = DocumentHelper.getModifiedNewObjects(
                    FIELDNAME_SALEINVOICELINE_PRICELISTRULEID, 
                    oldEntries, 
                    newEntries);
                if(modifiedObjects.size()>0){
                    Map<Id, dmpl__Item__c> items = new Map<Id,dmpl__Item__c>(
                        ItemHelper.getCachedItems(
                            DocumentHelper.extractIds(
                                modifiedObjects, 
                                FIELD_SALEINVOICELINELINE_ITEMID)));
                    List<dmpl__SaleInvoice__c> saleInvoiceDocuments = querySaleInvoiceDocument(
                        DocumentHelper.extractIds(
                            modifiedObjects, 
                            FIELD_SALEINVOICELINELINE_SALEINVOICEID));
                    PriceListHelper.setApplicablePrices(
                        modifiedObjects, 
                        saleInvoiceDocuments, 
                        items.values(), 
                        DocumentHelper.extractIds(
                            modifiedObjects, 
                            FIELDNAME_SALEINVOICELINE_PRICELISTRULEID),
                            'dmpl__SaleInvoiceId__c');
                }

                modifiedObjects = DocumentHelper.getModifiedNewObjects(
                    new List<String>{
                        'dmpl__PriceListId__c',
                        'dmpl__PriceAsOnDate__c'
                    },
                    oldEntries, 
                    newEntries);
                if(modifiedObjects.size()>0){
                    Map<Id, dmpl__Item__c> items = new Map<Id,dmpl__Item__c>(
                        ItemHelper.getCachedItems(
                            DocumentHelper.extractIds(
                                modifiedObjects, 
                                FIELD_SALEINVOICELINELINE_ITEMID)));
                    List<dmpl__SaleInvoice__c> saleInvoiceDocuments = querySaleInvoiceDocument(
                        DocumentHelper.extractIds(
                            modifiedObjects, 
                            FIELD_SALEINVOICELINELINE_SALEINVOICEID));
                    PriceListHelper.setApplicablePrices(
                        modifiedObjects, 
                        saleInvoiceDocuments, 
                        items.values(), 
                        true);
                }
                modifiedObjects = DocumentHelper.getApprovedObjects(
                    FIELD_SALEINVOICELINELINE_ISGLPOSTINGAPPROVED, 
                    oldEntries, 
                    newEntries);
                if(modifiedObjects.Size() > 0){
                    GeneralLedgerHelper.createLedger(
                        GeneralLedgerTypeEnums.InvoiceLine, 
                        isInsert, 
                        isDelete, 
                        isUpdate, 
                        oldEntries, 
                        newEntries);
                }
                modifiedObjects = DocumentHelper.getApprovedObjects(
                    FIELD_SALEINVOICELINELINE_ISILPOSTINGAPPROVED, 
                    oldEntries, 
                    newEntries);
                if(modifiedObjects.Size() > 0){
                    List<dmpl__SaleInvoiceLine__c> susbcriptionObjects = CollectionHelper.getObjectsWithNotNull(
                        newEntries, 
                        FIELD_SALEINVOICELINELINE_SUBSCRIPTIONID); 
                    if(susbcriptionObjects.Size() > 0)
                        subscriptionHelper.updateSubscriptionDetailsFromSaleInvoice(
                            susbcriptionObjects);
                    
                    susbcriptionObjects = CollectionHelper.getObjectsWithNotNull(
                        newEntries, 
                        FIELD_SALEINVOICELINELINE_SUBSCRIPTIONUSAGESUMMARYID); 
                    if(susbcriptionObjects.Size() > 0)
                        subscriptionHelper.updateSubscriptionUsageDetailsFromSaleInvoice(
                            susbcriptionObjects);
                }

                modifiedObjects = DocumentHelper.getModifiedNewObjects(
                    'dmpl__DiscountAmount__c', 
                    oldEntries, 
                    newEntries);
                if(modifiedObjects.size()>0){
                    updateDiscount(modifiedObjects);
                }
                modifiedObjects = DocumentHelper.getModifiedNewObjects(
                    new string[]{
                        FIELD_SALEINVOICELINELINE_TAXGROUPID,
                        FIELD_SALEINVOICELINELINE_ITEMID, 
                        FIELD_SALEINVOICELINELINE_SKUID,
                        FIELD_SALEINVOICELINELINE_AMOUNT
                    }, 
                    oldEntries, 
                    newEntries);
                if(modifiedObjects.size()>0){
                    TaxHelper.setLinesTaxes(
                        modifiedObjects);
                }
                setAllocationQuantities(
                    newEntries,
                    oldEntries);
               Map<Id, dmpl__Item__c> items = new Map<Id,dmpl__Item__c>(
                ItemHelper.getCachedItems(
                DocumentHelper.extractIds(
                    newEntries, 
                    FIELD_SALEINVOICELINELINE_ITEMID)));
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
                // SaleInvoiceTaxHelper.deleteApplicableTaxes(
                //     oldEntries);
                deletePackageItems(
                    oldEntries);
            }

            List<dmpl__SaleInvoiceLine__c> modifiedLedgerObjects = DocumentHelper.getPostedObjects(
                    FIELD_SALEINVOICELINELINE_ISILPOSTINGAPPROVED, 
                    oldEntries, 
                    newEntries);
            if(modifiedLedgerObjects.Size() > 0){
                if(isInsert || isUpdate){
                        InventoryLedgerHelper.createLedger(
                            InventoryLedgerTypeEnums.Sold, 
                            FIELD_SALEINVOICELINELINE_SALEINVOICEID, 
                            OBJECT_SALEINVOICE, 
                            isInsert, 
                            isDelete, 
                            isUpdate, 
                            oldEntries, 
                            modifiedLedgerObjects);
                }else {
                        InventoryLedgerHelper.createLedger(
                            InventoryLedgerTypeEnums.Sold, 
                            FIELD_SALEINVOICELINELINE_SALEINVOICEID, 
                            OBJECT_SALEINVOICE, 
                            isInsert, 
                            isDelete, 
                            isUpdate, 
                            modifiedLedgerObjects, 
                            newEntries);
                    }
            }

        } catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }

    public static void afterPostData(
        Boolean isInsert, 
        Boolean isDelete, 
        Boolean isUpdate, 
        List<dmpl__SaleInvoiceLine__c> oldEntries, 
        List<dmpl__SaleInvoiceLine__c> newEntries){
        try{
            if(isDelete){
                SaleOrderLineHelper.updateSaleInvoiceQuantity(
                    DocumentHelper.extractIds(
                        oldEntries, 
                        FIELD_SALEINVOICELINELINE_SALEORDERLINEID));
                SaleOrderLineHelper.updateSaleInvoiceQuantity(
                    DocumentHelper.extractIds(
                        oldEntries, 
                        FIELD_SALEINVOICELINELINE_SALEORDERLINEID), 
                        DocumentHelper.extractIds(
                            oldEntries, 
                            FIELD_SALEINVOICELINELINE_FULFILLMENTALLOCATIONLINEID));
                InventoryFulfillmentAllocationLineHelper.updateSaleInvoiceQuantity(
                    DocumentHelper.extractIds(
                        oldEntries, 
                        FIELD_SALEINVOICELINELINE_FULFILLMENTALLOCATIONLINEID));
                
                SaleDeliveryLineHelper.updateSaleInvoiceQuantity(
                    DocumentHelper.extractIds(
                        oldEntries, 
                        'dmpl__DeliveryOrderLineId__c'));
                // NEED TO TEST
                RepairOrderLineHelper.updateSaleInvoiceQuantity(
                    DocumentHelper.extractIds(
                        oldEntries, 
                        FIELD_SALEINVOICELINELINE_REPAIRORDERLINEID));
                RepairOrderLineHelper.updateSaleInvoiceQuantity(
                    DocumentHelper.extractIds(
                        oldEntries, 
                        FIELD_SALEINVOICELINELINE_REPAIRORDERLINEID), 
                        DocumentHelper.extractIds(
                            oldEntries, 
                            FIELD_SALEINVOICELINELINE_FULFILLMENTALLOCATIONLINEID));
                TaxHelper.deleteLinesTaxes(oldEntries);
            } else if(isInsert){
                SaleOrderLineHelper.updateSaleInvoiceQuantity(
                    DocumentHelper.extractIds(
                        newEntries, 
                        FIELD_SALEINVOICELINELINE_SALEORDERLINEID));
                SaleOrderLineHelper.updateSaleInvoiceQuantity(
                    DocumentHelper.extractIds(
                        newEntries, 
                        FIELD_SALEINVOICELINELINE_SALEORDERLINEID), 
                        DocumentHelper.extractIds(
                            newEntries, 
                            FIELD_SALEINVOICELINELINE_FULFILLMENTALLOCATIONLINEID));
                InventoryFulfillmentAllocationLineHelper.updateSaleInvoiceQuantity(
                    DocumentHelper.extractIds(
                        newEntries, 
                        FIELD_SALEINVOICELINELINE_FULFILLMENTALLOCATIONLINEID));
                SaleDeliveryLineHelper.updateSaleInvoiceQuantity(
                    DocumentHelper.extractIds(
                        newEntries, 
                        'dmpl__DeliveryOrderLineId__c'));
                TaxHelper.createLinesTaxes(
                    isInsert, 
                    newEntries);
                PackageHelper.populatePackageItems(
                    newEntries);
                // createDocumentServiceContract(
                //     newEntries);

                // NEED TO TEST
                RepairOrderLineHelper.updateSaleInvoiceQuantity(
                    DocumentHelper.extractIds(
                        newEntries, 
                        FIELD_SALEINVOICELINELINE_REPAIRORDERLINEID));
                RepairOrderLineHelper.updateSaleInvoiceQuantity(
                    DocumentHelper.extractIds(
                        newEntries, 
                        FIELD_SALEINVOICELINELINE_REPAIRORDERLINEID), 
                        DocumentHelper.extractIds(
                            newEntries, 
                            FIELD_SALEINVOICELINELINE_FULFILLMENTALLOCATIONLINEID));
            } else if(isUpdate){
                List<dmpl__SaleInvoiceLine__c> modifiedObjects = DocumentHelper.getModifiedNewObjects(
                    FIELD_SALEINVOICELINELINE_QUANTITY, 
                    oldEntries, 
                    newEntries);
                if(modifiedObjects.size()>0){
                    SaleOrderLineHelper.updateSaleInvoiceQuantity(
                        DocumentHelper.extractIds(
                            modifiedObjects, 
                            FIELD_SALEINVOICELINELINE_SALEORDERLINEID));
                    SaleOrderLineHelper.updateSaleInvoiceQuantity(
                        DocumentHelper.extractIds(
                            modifiedObjects, 
                            FIELD_SALEINVOICELINELINE_SALEORDERLINEID), 
                            DocumentHelper.extractIds(
                                modifiedObjects, 
                                FIELD_SALEINVOICELINELINE_FULFILLMENTALLOCATIONLINEID));
                    InventoryFulfillmentAllocationLineHelper.updateSaleInvoiceQuantity(
                        DocumentHelper.extractIds(
                            modifiedObjects, 
                            FIELD_SALEINVOICELINELINE_FULFILLMENTALLOCATIONLINEID));
                    SaleDeliveryLineHelper.updateSaleInvoiceQuantity(
                        DocumentHelper.extractIds(
                            newEntries, 
                            'dmpl__DeliveryOrderLineId__c'));

                    // NEED TO TEST
                    RepairOrderLineHelper.updateSaleInvoiceQuantity(
                        DocumentHelper.extractIds(
                            newEntries, 
                            FIELD_SALEINVOICELINELINE_REPAIRORDERLINEID));
                    RepairOrderLineHelper.updateSaleInvoiceQuantity(
                        DocumentHelper.extractIds(
                            newEntries, 
                            FIELD_SALEINVOICELINELINE_REPAIRORDERLINEID), 
                            DocumentHelper.extractIds(
                                newEntries, 
                                FIELD_SALEINVOICELINELINE_FULFILLMENTALLOCATIONLINEID));
                }
                
                modifiedObjects = DocumentHelper.getModifiedNewObjects(new string[]{
                    FIELD_SALEINVOICELINELINE_TAXGROUPID,
                    FIELD_SALEINVOICELINELINE_ITEMID, 
                    FIELD_SALEINVOICELINELINE_SKUID,
                    FIELD_SALEINVOICELINELINE_AMOUNT
                }, oldEntries, newEntries);
                if(modifiedObjects.size()>0){
                    TaxHelper.createLinesTaxes(
                        isInsert,
                        modifiedObjects);
                }
            }

            List<dmpl__SaleInvoiceLine__c> entries = isDelete ? oldEntries : newEntries;
            if(isUpdate){
                entries = DocumentHelper.getModifiedNewObjects(
                    new string[]{
                        FIELD_SALEINVOICELINELINE_TAXGROUPID,
                        FIELD_SALEINVOICELINELINE_ITEMID, 
                        FIELD_SALEINVOICELINELINE_SKUID,
                        FIELD_SALEINVOICELINELINE_AMOUNT,
                        FIELD_SALEINVOICELINELINE_QUANTITY
                    }, 
                    oldEntries, 
                    newEntries);
            }
            
            if(entries.size() > 0){
                List<dmpl__SaleInvoice__c> saleInvoiceDocuments = querySaleInvoiceDocument(
                    DocumentHelper.extractIds(
                        entries,
                        FIELD_SALEINVOICELINELINE_SALEINVOICEID));
                // SaleInvoiceTaxHelper.setApplicableTaxes(
                //     saleInvoiceDocuments);
                List<Id> saleInvoiceIds =  DocumentHelper.extractIds(
                    isDelete ? oldEntries : newEntries, 
                    FIELD_SALEINVOICELINELINE_SALEINVOICEID);
                dmpl__DMSOrgSetting__mdt  orgSetting = OrgSettingHelper.OrgSetting();
                    if(orgSetting != null && orgSetting.dmpl__ApplySchemeAsync__c && !isAlreadyProcessing && !system.isBatch() && !system.IsFuture()){
                        applySchemeAsync(saleInvoiceIds);
                    }else 
                    SchemeEngine.processSchemes(saleInvoiceDocuments);
                
            }
        } catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }

    @Future
    public static void applySchemeAsync(List<Id>saleInvoiceIds){
        isAlreadyProcessing = True;
        List<dmpl__SaleInvoice__c>saleInvoices = querySaleInvoiceDocument(saleInvoiceIds);
        SchemeEngine.processSchemes(saleInvoices);
        isAlreadyProcessing = false;
    }

    public static void addPackageSaleInvoiceLines(Map<dmpl__SaleInvoiceLine__c, List<dmpl__ItemComponent__c>> packageLines){
        List<dmpl__SaleInvoiceLine__c> invoiceLinesToCreate = new List<dmpl__SaleInvoiceLine__c>();
        for(dmpl__SaleInvoiceLine__c line : packageLines.keySet()){
            List<dmpl__ItemComponent__c> components = packageLines.get(line);
            for(dmpl__ItemComponent__c component : components){
                invoiceLinesToCreate.add(createSaleInvoiceLine(line, component));
            }
        }

        if(invoiceLinesToCreate.size()>0){
            SecurityHelper.ensureCanCreateObject('dmpl__SaleInvoiceLine__c');
            SecurityHelper.ensureCanCreateFields(new List<String>{
                'dmpl__ItemId__c',
                'dmpl__SKUId__c',
                'dmpl__PackageSaleInvoiceLineId__c',
                'dmpl__Quantity__c'
            }, 'dmpl__SaleInvoiceLine__c');
            try {
                skipValidations = true;
                skipComponentAddValidation = true;
                insert invoiceLinesToCreate;
            } finally {
                skipValidations = false;
                skipComponentAddValidation = false;
            }
        }
    }

    public static void applyPackageConfiguration(dmpl__SaleInvoiceLine__c packageSaleInvoiceLine, 
        List<dmpl__SaleInvoiceLine__c> existingLines, 
        List<dmpl__ItemComponent__c> components){
        List<dmpl__SaleInvoiceLine__c> orderLinesToCreate = new List<dmpl__SaleInvoiceLine__c>();
        List<dmpl__SaleInvoiceLine__c> orderLinesToUpdate = new List<dmpl__SaleInvoiceLine__c>();
        List<dmpl__SaleInvoiceLine__c> orderLinesToDelete = new List<dmpl__SaleInvoiceLine__c>();
        if(packageSaleInvoiceLine == null){
            throw new DMPLException(
                String.format(
                    String.valueOf(System.Label.Generic_MissingObject), 
                    new String[]{dmpl__SaleInvoiceLine__c.class.getName()}));
        }
        for(dmpl__ItemComponent__c component : components){
            dmpl__SaleInvoiceLine__c exisitngLine = (dmpl__SaleInvoiceLine__c)CollectionHelper.getObject(
                existingLines, 
                'dmpl__ItemComponentId__c', 
                component.Id);
            if(exisitngLine == null){
                orderLinesToCreate.add(createSaleInvoiceLine(packageSaleInvoiceLine, component));
            }else if(component.dmpl__IsQuantityEditable__c){
                Decimal quantity = PackageHelper.getDefaultComponentQuantity(packageSaleInvoiceLine.dmpl__Quantity__c, component);
                if(exisitngLine.dmpl__Quantity__c != quantity){
                    exisitngLine.dmpl__Quantity__c = component.dmpl__Quantity__c;
                    orderLinesToUpdate.add(exisitngLine);
                }
            }
        }

        for(dmpl__SaleInvoiceLine__c line : existingLines){
            if(line.Id != packageSaleInvoiceLine.Id && CollectionHelper.getObject(components, line.dmpl__ItemComponentId__c) == null){
                orderLinesToDelete.add(line);
            }
        }

        if(orderLinesToCreate.size()>0){
            SecurityHelper.ensureCanCreateObject('dmpl__SaleInvoiceLine__c');
            SecurityHelper.ensureCanCreateFields(new List<String>{
                'dmpl__ItemId__c',
                'dmpl__SKUId__c',
                'dmpl__PackageSaleInvoiceLineId__c',
                'dmpl__Quantity__c',
                'dmpl__SaleInvoiceId__c'    
            }, 'dmpl__SaleInvoiceLine__c');
            try {
                skipValidations = true;
                skipComponentAddValidation = true;
                insert orderLinesToCreate;
            } finally {
                skipValidations = false;
                skipComponentAddValidation = false;
            }
        }

        if(orderLinesToUpdate.size()>0){
            SecurityHelper.ensureCanWriteFields(new List<String>{
                'dmpl__ItemId__c',
                'dmpl__SKUId__c',
                'dmpl__PackageSaleInvoiceLineId__c',
                'dmpl__Quantity__c'
            }, 'dmpl__SaleInvoiceLine__c');
            try {
                skipValidations = true;
                skipComponentAddValidation = true;
                update orderLinesToUpdate;
            } finally {
                skipValidations = false;
                skipComponentAddValidation = false;
            }
        }

        if(orderLinesToDelete.size()>0){
            SecurityHelper.ensureCanDeleteObject('dmpl__SaleInvoiceLine__c');
            try {
                skipValidations = true;
                skipComponentAddValidation = true;
                delete orderLinesToDelete;
            } finally {
                skipValidations = false;
                skipComponentAddValidation = false;
            }
        }
    }

    public static void createSaleInvoiceFromSaleOrder(List<dmpl__SaleInvoiceLine__c> saleInvoiceLinesList){
        try {
            SecurityHelper.ensureCanCreateObject('dmpl__SaleInvoiceLine__c');
            SecurityHelper.ensureCanCreateFields(
                new string[]
                {
                    'dmpl__SaleOrderLineId__c',
                    'dmpl__ItemId__c',
                    'dmpl__SKUId__c',
                    'dmpl__UnitPrice__c',
                    'dmpl__Quantity__c',
                    'dmpl__TaxGroupId__c',
                    'dmpl__ItemLotId__c',
                    'dmpl__InventoryLedgerId__c',
                    'dmpl__StorageLocationId__c',
                    'dmpl__UnitCost__c'
                }, 'dmpl__SaleInvoiceLine__c');
            skipComponentDeleteValidation = true;
            skipComponentAddValidation = true;
            insert saleInvoiceLinesList;                
        } finally {
            skipComponentDeleteValidation = false;
            skipComponentAddValidation = false;
        }
    }

    
    // private static void createDocumentServiceContract(
    //     List<dmpl__SaleInvoiceLine__c> newEntries){
    //         List<Id> itemContractIds = CollectionHelper.extractIds(
    //             newEntries,
    //             'dmpl__ItemServiceContractId__c'
    //         );
    //         List<dmpl__ItemServiceContract__c> itemServiceContracts = queryItemServiceContractLines(
    //             itemContractIds);
    //         List<dmpl__DocumentServiceContract__c> documentServiceContract = new List<dmpl__DocumentServiceContract__c>();
    //         for(dmpl__SaleInvoiceLine__c entry :newEntries){
    //             if(entry.dmpl__ItemServiceContractId__c != null){
    //                 dmpl__ItemServiceContract__c itemContract = (dmpl__ItemServiceContract__c)CollectionHelper.getObject(itemServiceContracts,entry.dmpl__ItemServiceContractId__c);
    //                 for(dmpl__ItemServiceContractLine__c line : itemContract.dmpl__ItemServiceContractLines__r){
    //                     dmpl__DocumentServiceContract__c dsc = new dmpl__DocumentServiceContract__c(); 
    //                     dsc.dmpl__ComponentItemId__c =  line.dmpl__ComponentItemId__c;
    //                     dsc.dmpl__IsInScope__c = line.dmpl__IsInScope__c;
    //                     dsc.dmpl__Quantity__c = line.dmpl__Quantity__c;
    //                     dsc.dmpl__SaleInvoiceLineId__c = entry.Id;
    //                     documentServiceContract.add(dsc);
    //                 } 
    //             }
    //         }
    //         insert documentServiceContract;
    // }

    public static void approveSaleInvoiceLines(List<dmpl__SaleInvoice__c> invoices){
        List<dmpl__SaleInvoiceLine__c> invoiceLines = queryInvoiceLines(CollectionHelper.extractIds(invoices));
        updatePackageSaleInvoiceLineId(invoiceLines);
        AssetHelper.createAssets(invoices, invoiceLines);
        AssetServiceContractHelper.createAssetServiceContracts(invoices, invoiceLines);
        AssetServiceContractHelper.checkAndUpdateOriginalAssetContract(invoiceLines);
        SubscriptionHelper.createSubscription(invoices, invoiceLines);
        postSaleInvoiceLines(invoices, invoiceLines);
    }

    public static void createSaleInvoiceLinesFromClaim(
        List<dmpl__SaleInvoice__c> invoiceDocuments, 
        Map<Id,dmpl__Claim__c> claims,
        List<dmpl__InventoryFulfillmentAllocationLine__c> allocationLines){
        List<dmpl__SaleInvoiceLine__c> newSaleInvoiceLines = new List<dmpl__SaleInvoiceLine__c>();
        for(dmpl__SaleInvoice__c document : invoiceDocuments){
            dmpl__Claim__c claim = claims.get(document.dmpl__ClaimId__c);
            for(dmpl__ClaimLine__c claimLine : claim.dmpl__Claim_Lines1__r){
                if(claimLine.dmpl__ClaimType__c == 'Reimbursment' && claimLine.dmpl__ApproveQuantity__c > 0)
                    {
                        dmpl__InventoryFulfillmentAllocationLine__c relatedAllocationLine = (dmpl__InventoryFulfillmentAllocationLine__c)DocumentHelper.getObjectByFilter(
                            allocationLines, 
                            'dmpl__RepairOrderLineId__c', 
                            claimLine.dmpl__RepairOrderLineId__c);
                        dmpl__SaleInvoiceLine__c line = new dmpl__SaleInvoiceLine__c(
                            dmpl__SaleInvoiceId__c = document.ID,
                            dmpl__ItemId__c = claimLine.dmpl__ItemId__c,
                            dmpl__Quantity__c = claimLine.dmpl__ApproveQuantity__c,
                            dmpl__UnitPrice__c = claimLine.dmpl__UnitPrice__c,
                            dmpl__ClaimLineId__c = claimLine.Id,
                            dmpl__TaxGroupId__c = claimLine.dmpl__TaxGroupId__c,
                            dmpl__RepairOrderLineId__c = claimLine.dmpl__RepairOrderLineId__c,
                            dmpl__Discount__c = claimLine.dmpl__ApproveDiscount__c,
                            dmpl__DiscountAmount__c = claimLine.dmpl__ApproveDiscountAmount__c
                        );
                        if(relatedAllocationLine!=null){
                            line.dmpl__ItemLotTypeId__c = relatedAllocationLine.dmpl__ItemLotTypeId__c;
                            line.dmpl__ItemLotId__c = relatedAllocationLine.dmpl__ItemLotId__c;
                            line.dmpl__InventoryLedgerId__c = relatedAllocationLine.dmpl__InventoryLedgerId__c;
                            line.dmpl__StorageLocationId__c = relatedAllocationLine.dmpl__StorageLocationId__c;
                            line.dmpl__UnitCost__c = relatedAllocationLine.dmpl__UnitCost__c;
                            line.dmpl__FulfillmentAllocationLineId__c = relatedAllocationLine.Id;
                            //////
                            //////
                            ///line.dmpl__AllocatedQuantity__c = relatedAllocationLine.dmpl__PendingInvoiceQuantity__c;
                            // Decimal requestedQty = claimLine.dmpl__ApproveQuantity__c;
                            // line.dmpl__AllocatedQuantity__c = getAllocationQuantityOfAllocation(
                            //     requestedQty, 
                            //     relatedAllocationLine);
                            // line.dmpl__DeliveredQuantity__c = getDeliveredQuantityOfAllocation(
                            //     requestedQty, 
                            //     relatedAllocationLine);
                            // line.dmpl__PickedQuantity__c = getPickedQuantityOfAllocation(
                            //     requestedQty, 
                            //     relatedAllocationLine);
                            //////
                        }
                        newSaleInvoiceLines.add(line);
                    }
            }
        }

        if(newSaleInvoiceLines.size() > 0)
        {
            try{
                SecurityHelper.ensureCanReadFields(new string[]{'dmpl__SaleInvoiceId__c','dmpl__ItemId__c','dmpl__ClaimLineId__c','dmpl__Quantity__c','dmpl__UnitPrice__c'}, 'dmpl__SaleInvoiceLine__c');
                skipValidations = true;
                insert newSaleInvoiceLines;
            } catch(Exception error){
                ExceptionLogHelper.logException(error);
                throw error;
            } finally{
                skipValidations = false;
            }
        }
    }

    public static void createSaleInvoiceLinesFromClaimBatch(
        List<dmpl__SaleInvoice__c> invoiceDocuments, 
        Map<Id,dmpl__ClaimBatch__c> claimBatches,
        List<dmpl__InventoryFulfillmentAllocationLine__c> allocationLines){
        List<dmpl__SaleInvoiceLine__c> newSaleInvoiceLines = new List<dmpl__SaleInvoiceLine__c>();
        for(dmpl__SaleInvoice__c document : invoiceDocuments){
            dmpl__ClaimBatch__c claimBatch = claimBatches.get(document.dmpl__ClaimBatchId__c);
            for(dmpl__ClaimLine__c claimLine : claimBatch.dmpl__ClaimLines__r){
                if(claimLine.dmpl__ClaimType__c == 'Reimbursment' && claimLine.dmpl__ApproveQuantity__c > 0)
                    {
                        dmpl__InventoryFulfillmentAllocationLine__c relatedAllocationLine = (dmpl__InventoryFulfillmentAllocationLine__c)DocumentHelper.getObjectByFilter(
                            allocationLines, 
                            'dmpl__RepairOrderLineId__c', 
                            claimLine.dmpl__RepairOrderLineId__c);
                        dmpl__SaleInvoiceLine__c line = new dmpl__SaleInvoiceLine__c(
                            dmpl__SaleInvoiceId__c = document.ID,
                            dmpl__ItemId__c = claimLine.dmpl__ItemId__c,
                            dmpl__Quantity__c = claimLine.dmpl__ApproveQuantity__c,
                            dmpl__UnitPrice__c = claimLine.dmpl__UnitPrice__c,
                            dmpl__ClaimLineId__c = claimLine.Id,
                            dmpl__TaxGroupId__c = claimLine.dmpl__TaxGroupId__c,
                            dmpl__RepairOrderLineId__c = claimLine.dmpl__RepairOrderLineId__c,
                            dmpl__Discount__c = claimLine.dmpl__ApproveDiscount__c,
                            dmpl__DiscountAmount__c = claimLine.dmpl__ApproveDiscountAmount__c
                        );
                        if(relatedAllocationLine!=null){
                            line.dmpl__ItemLotTypeId__c = relatedAllocationLine.dmpl__ItemLotTypeId__c;
                            line.dmpl__ItemLotId__c = relatedAllocationLine.dmpl__ItemLotId__c;
                            line.dmpl__InventoryLedgerId__c = relatedAllocationLine.dmpl__InventoryLedgerId__c;
                            line.dmpl__StorageLocationId__c = relatedAllocationLine.dmpl__StorageLocationId__c;
                            line.dmpl__UnitCost__c = relatedAllocationLine.dmpl__UnitCost__c;
                            line.dmpl__FulfillmentAllocationLineId__c = relatedAllocationLine.Id;
                        }
                        newSaleInvoiceLines.add(line);
                    }
            }
        }

        if(newSaleInvoiceLines.size() > 0)
        {
            try{
                SecurityHelper.ensureCanReadFields(new string[]{'dmpl__SaleInvoiceId__c','dmpl__ItemId__c','dmpl__ClaimLineId__c','dmpl__Quantity__c','dmpl__UnitPrice__c'}, 'dmpl__SaleInvoiceLine__c');
                skipValidations = true;
                insert newSaleInvoiceLines;
            } catch(Exception error){
                ExceptionLogHelper.logException(error);
                throw error;
            } finally{
                skipValidations = false;
            }
        }
    }

    public static void markAsClaimed(List<dmpl__SaleInvoiceLine__c> saleInvoiceLines)
    {
        for(dmpl__SaleInvoiceLine__c saleInvoiceLine : saleInvoiceLines)
            saleInvoiceLine.dmpl__IsClaimed__c = true;

        if(saleInvoiceLines.size() > 0)
        {
            try{
                skipValidations = true;
                update saleInvoiceLines;
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

    public static void updateSaleReturnQuantity(List<Id> saleInvoiceLineIds)
    {
        try{
            skipValidations = true;
             
            SecurityHelper.ensureCanReadFields(new string[]{
                'dmpl__SaleInvoiceLineId__c',
                'dmpl__Quantity__c'
            }, 'dmpl__SaleReturnLine__c');
            List<AggregateResult> ffAggregates = 
                [SELECT 
                    dmpl__SaleInvoiceLineId__c SaleInvoiceLineId, 
                    SUM(dmpl__Quantity__c) TotalQuantity
                FROM 
                    dmpl__SaleReturnLine__c
                WHERE 
                dmpl__SaleInvoiceLineId__c IN :saleInvoiceLineIds
                WITH SECURITY_ENFORCED
                GROUP BY dmpl__SaleInvoiceLineId__c];
             
            SecurityHelper.ensureCanReadFields(new string[]{
                'dmpl__ReturnedQuantity__c'
            }, 'dmpl__SaleInvoiceLine__c');
            List<dmpl__SaleInvoiceLine__c> orderLinesToUpdate = 
                [SELECT 
                    Id, 
                    dmpl__ReturnedQuantity__c
                FROM 
                    dmpl__SaleInvoiceLine__c
                WHERE 
                    Id IN :saleInvoiceLineIds];
    
            for(dmpl__SaleInvoiceLine__c orderLine : orderLinesToUpdate){
                // if(ffAggregates.size() == 0)
                // {
                //     orderLine.dmpl__ReturnedQuantity__c = 0;
                //     break;
                // }
                Boolean isLineFound = false;
                for(AggregateResult result : ffAggregates){
                    if(result.get(FIELD_AGG_SALEINVOICELINEID) == orderLine.Id){
                        isLineFound = true;
                        orderLine.dmpl__ReturnedQuantity__c 
                            = result.get(FIELD_AGG_TOTALQTY) ==null ? 
                                0 : (Decimal)(result.get(FIELD_AGG_TOTALQTY));
                        break;
                    }
                }
                if(!isLineFound)
                    orderLine.dmpl__ReturnedQuantity__c = 0;
            }
            SecurityHelper.ensureCanWriteFields(new string[]{
                'dmpl__ReturnedQuantity__c'
            }, 'dmpl__SaleInvoiceLine__c');
            Update orderLinesToUpdate;
        }finally{
            skipValidations = false;
        }
    }

    public static void performReprice(Id saleInvoiceId){
        performReprice(new List<Id>{saleInvoiceId});
    }

    public static void performReprice(List<Id> saleInvoiceIds){
        List<dmpl__SaleInvoice__c> saleInvoiceDocuments = querySaleInvoiceDocument(
            saleInvoiceIds);
        List<dmpl__SaleInvoiceLine__c> saleInvoiceLines = querySaleInvoiceLinesOfSaleInvoices(
            CollectionHelper.extractIds(
                saleInvoiceDocuments));
        Map<Id, dmpl__Item__c> items = new Map<Id,dmpl__Item__c>(
            ItemHelper.getCachedItems(
                DocumentHelper.extractIds(
                    saleInvoiceLines, 
                    FIELD_SALEINVOICELINELINE_ITEMID)));

        PriceListHelper.setApplicablePrices(
            saleInvoiceLines, 
            saleInvoiceDocuments, 
            items.values(),
            true);
        update saleInvoiceLines;
    }

    public static CreateRelatedResult postGL(Id invoiceId){
        return postSaleInvoiceLinesInternal(queryInvoiceLines(new List<Id>{invoiceId}));
    }

    public static CreateRelatedResult postGL(List<SourceObjectInfo> orderLinesInfo, Id invoiceId){
        return postSaleInvoiceLinesInternal(queryInvoiceLinesForLineIds(SourceObjectInfo.extractIds(orderLinesInfo)));
    }

    public static void postSaleInvoiceLines(List<dmpl__SaleInvoice__c> invoices, List<dmpl__SaleInvoiceLine__c> invoiceLines){
        dmpl__CreateRelatedSetting__mdt setting = CreateRelatedSettingHelper.getCreateRelatedSettings(
            'dmpl__SaleInvoice__c',
            'Post GL');
        if(setting == null){
            postSaleInvoiceLinesInternal(invoiceLines);
        }else {
            for(dmpl__SaleInvoice__c invoice : invoices){
                DocumentSelectorController.releaseDocumentDirect(setting.Id, invoice.Id);
            }
        }
    }

    private static CreateRelatedResult postSaleInvoiceLinesInternal(List<dmpl__SaleInvoiceLine__c> invoiceLines){
        for(dmpl__SaleInvoiceLine__c invoiceLine : invoiceLines){
            //invoiceLine.dmpl__IsGLPostingApproved__c = true;
            invoiceLine.dmpl__IsILPostingApproved__c = true;
        }
        try {
            skipValidations = true;
            SecurityHelper.ensureCanWriteFields(new string[]{'dmpl__IsILPostingApproved__c','dmpl__IsGLPostingApproved__c'}, 'dmpl__SaleInvoiceLine__c');
            update invoiceLines;
            return CreateRelatedResult.SuccessResult();
        } finally {
            skipValidations = false;
        }
    }

    private static void updatePackageSaleInvoiceLineId(List<dmpl__SaleInvoiceLine__c> invoiceLines){
        for(dmpl__SaleInvoiceLine__c invoiceLine : invoiceLines){

            if(invoiceLine.dmpl__PackageSaleInvoiceLineId__c == null && invoiceLine.dmpl__PackageSaleOrderLineId__c != null)
            {
                dmpl__SaleInvoiceLine__c parentLine = (dmpl__SaleInvoiceLine__c)DocumentHelper.getObjectByFilter(invoiceLines, 'dmpl__SaleOrderLineId__c', invoiceLine.dmpl__PackageSaleOrderLineId__c);
                if(parentLine != null)
                    invoiceLine.dmpl__PackageSaleInvoiceLineId__c = parentLine.Id;
            }
        }
    }

    private static void deletePackageItems(List<dmpl__SaleInvoiceLine__c> oldEntries){
        SecurityHelper.ensureCanReadField('Id', 'dmpl__SaleInvoiceLine__c');
        List<dmpl__SaleInvoiceLine__c> linesToDelte = [SELECT Id 
            FROM dmpl__SaleInvoiceLine__c 
            WHERE dmpl__PackageSaleInvoiceLineId__c IN:CollectionHelper.extractIds(oldEntries)];

        try {
            skipComponentDeleteValidation = true;
            if(linesToDelte.size()>0){
                SecurityHelper.ensureCanDeleteObject('dmpl__SaleInvoiceLine__c');
                delete linesToDelte;
            }        
        } finally {
            skipComponentDeleteValidation = false;
        }
    }

    private static void validateBundledItemPrice(List<dmpl__SaleInvoiceLine__c> newEntries){
        for(dmpl__SaleInvoiceLine__c invoiceLine : newEntries){
            if(invoiceLine.dmpl__IsPriceBundled__c && invoiceLine.dmpl__UnitPrice__c>0){
                invoiceLine.addError(System.Label.PackageError_PriceNotApplicableToBundledItem);
            }
        }
    }

    private static void validateItem(List<dmpl__SaleInvoiceLine__c> newEntries){
        Map<Id, dmpl__Item__c> items = new Map<Id,dmpl__Item__c>(ItemHelper.getCachedItems(DocumentHelper.extractIds(newEntries, FIELD_SALEINVOICELINELINE_ITEMID)));
        for(dmpl__SaleInvoiceLine__c invoiceLine : newEntries){
            dmpl__Item__c item = items.get(invoiceLine.dmpl__ItemId__c);
            if(invoiceLine.dmpl__PackageSaleInvoiceLineId__c == null 
                && invoiceLine.dmpl__PackageSaleOrderLineId__c == null
                && item!=null 
                && item.dmpl__OnlySoldInPackage__c){
                invoiceLine.addError(System.Label.PackageError_ItemSoldOnlyInPackage);
            }
            if(invoiceLine.dmpl__SKUId__c == null 
                && item!=null 
                && item.dmpl__IsSKURequired__c){
                invoiceLine.addError(System.Label.Validation_SKURequired);
            }
            if(invoiceLine.dmpl__SKUId__c != null){
                dmpl__SKU__c sku = (dmpl__SKU__c)CollectionHelper.getObject(item.dmpl__SKUs__r, invoiceLine.dmpl__SKUId__c);
                if(sku ==null){
                    invoiceLine.addError(System.Label.Validation_SKUInvalid);
                }
            }
        }
    }
    
    private static dmpl__SaleInvoiceLine__c createSaleInvoiceLine(dmpl__SaleInvoiceLine__c packageLine, dmpl__ItemComponent__c component){
        return new dmpl__SaleInvoiceLine__c(
            dmpl__ItemComponentId__c = component.Id,    
            dmpl__ItemId__c = component.dmpl__ComponentItemId__c,
            dmpl__SKUId__c = component.dmpl__ComponentSKUId__c,
            dmpl__PackageSaleInvoiceLineId__c = packageLine.Id,
            dmpl__Quantity__c = PackageHelper.getDefaultComponentQuantity(packageLine.dmpl__Quantity__c, component),
            dmpl__SaleInvoiceId__c =  packageLine.dmpl__SaleInvoiceId__c,
            dmpl__IsPriceBundled__c = component.dmpl__IsBundled__c
        );
    }

    private static void setAllocationQuantities(
        List<dmpl__SaleInvoiceLine__c> newEntries,
        List<dmpl__SaleInvoiceLine__c> oldEntries){
        List<dmpl__InventoryFulfillmentAllocationLine__c> allocationLines = queryFulfillmentAllocationLines(
            DocumentHelper.extractIds(
                newEntries, 
                FIELD_SALEINVOICELINELINE_FULFILLMENTALLOCATIONLINEID));
        for(dmpl__SaleInvoiceLine__c invoiceLine : newEntries){
            dmpl__SaleInvoiceLine__c oldLine = null;
            if(oldEntries !=null ){ 
                oldLine = (dmpl__SaleInvoiceLine__c)CollectionHelper.getObject(
                    oldEntries, 
                    invoiceLine.Id);
            }
            dmpl__InventoryFulfillmentAllocationLine__c allocationLine = 
                (dmpl__InventoryFulfillmentAllocationLine__c)CollectionHelper.getObject(
                    allocationLines, 
                    invoiceLine.dmpl__FulfillmentAllocationLineId__c);
            if(allocationLine != null){
                invoiceLine.dmpl__AllocatedQuantity__c = getAllocationQuantityOfAllocation(
                    invoiceLine,
                    oldLine,
                    allocationLine);
                invoiceLine.dmpl__DeliveredQuantity__c = getDeliveredQuantityOfAllocation(
                    invoiceLine,
                    oldLine,
                    allocationLine);
                invoiceLine.dmpl__PickedQuantity__c = getPickedQuantityOfAllocation(
                    invoiceLine,
                    oldLine,
                    allocationLine);
            } else {
                invoiceLine.dmpl__AllocatedQuantity__c = 0;
                invoiceLine.dmpl__DeliveredQuantity__c = 0;
                invoiceLine.dmpl__PickedQuantity__c = 0;
            }
        }
    }

    private static Decimal getAllocationQuantityOfAllocation(
        dmpl__SaleInvoiceLine__c invoiceLine, 
        dmpl__SaleInvoiceLine__c oldLine, 
        dmpl__InventoryFulfillmentAllocationLine__c allocationLine){
            Decimal allocationQuantity = (allocationLine.dmpl__AllocatedQuantity__c == null ? 
                0 : allocationLine.dmpl__AllocatedQuantity__c) 
                - (allocationLine.dmpl__DeliveryQuantity__c == null ? 
                0 : allocationLine.dmpl__DeliveryQuantity__c)
                - (allocationLine.dmpl__PickedQuantity__c == null ? 
                0 : allocationLine.dmpl__PickedQuantity__c);
            if(oldLine != null){
                allocationQuantity += oldLine.dmpl__AllocatedQuantity__c == null ? 0 : oldLine.dmpl__AllocatedQuantity__c;
            }
            if(allocationQuantity > invoiceLine.dmpl__Quantity__c){
                return invoiceLine.dmpl__Quantity__c;
            }else{
                return allocationQuantity;
            }
        } 

    private static Decimal getDeliveredQuantityOfAllocation(
        dmpl__SaleInvoiceLine__c invoiceLine, 
        dmpl__SaleInvoiceLine__c oldLine, 
        dmpl__InventoryFulfillmentAllocationLine__c allocationLine){
            if(allocationLine.dmpl__DeliveryQuantity__c == null){
                return null;
            }
            Decimal pendingDeliveryInvoice = (allocationLine.dmpl__DeliveryQuantity__c == null ? 
                0 : allocationLine.dmpl__DeliveryQuantity__c) 
                - (allocationLine.dmpl__DeliveredInvoicedQuantity__c == null ? 
                0 : allocationLine.dmpl__DeliveredInvoicedQuantity__c)
                +(allocationLine.dmpl__PickedDeliveredQuantity__c == null ? 
                0 : allocationLine.dmpl__PickedDeliveredQuantity__c) 
                - (allocationLine.dmpl__PickedInvoiceQuantity__c == null ? 
                0 : allocationLine.dmpl__PickedInvoiceQuantity__c);

            if(oldLine != null){
                pendingDeliveryInvoice += oldLine.dmpl__DeliveredQuantity__c == null ? 0 : oldLine.dmpl__DeliveredQuantity__c;
            }
            if(pendingDeliveryInvoice > invoiceLine.dmpl__Quantity__c){
                return invoiceLine.dmpl__Quantity__c;
            }else{
                return pendingDeliveryInvoice;
            }
        } 

    private static Decimal getPickedQuantityOfAllocation(
        dmpl__SaleInvoiceLine__c invoiceLine, 
        dmpl__SaleInvoiceLine__c oldLine, 
        dmpl__InventoryFulfillmentAllocationLine__c allocationLine){
            if(allocationLine.dmpl__PickedQuantity__c == null){
                return null;
            }
            Decimal pendingPickedInvoice = (allocationLine.dmpl__PickedQuantity__c == null ? 
                0 : allocationLine.dmpl__PickedQuantity__c) 
                - (allocationLine.dmpl__PickedInvoiceQuantity__c == null ? 
                0 : allocationLine.dmpl__PickedInvoiceQuantity__c)
                - (allocationLine.dmpl__PickedDeliveredQuantity__c == null ? 
                0 : allocationLine.dmpl__PickedDeliveredQuantity__c);
            if(oldLine != null){
                pendingPickedInvoice += oldLine.dmpl__PickedQuantity__c == null ? 0 : oldLine.dmpl__PickedQuantity__c;
            }
            if(pendingPickedInvoice > invoiceLine.dmpl__Quantity__c){
                return invoiceLine.dmpl__Quantity__c;
            }else{
                return pendingPickedInvoice;
            }
        } 

    @testVisible
    private static void updateSaleReturn(List<dmpl__SaleReturnLine__c> saleReturnLines)
    {
        List<ID> saleInvoiceLineIds = DocumentHelper.extractIds(saleReturnLines, 'dmpl__SaleInvoiceLineId__c');
        Map<ID,dmpl__SaleInvoiceLine__c> saleInvoiceLines = new Map<ID, dmpl__SaleInvoiceLine__c>(querySaleInvoiceLines(saleInvoiceLineIds));

        for(dmpl__SaleReturnLine__c lineEntry : saleReturnLines)
        {
            dmpl__SaleInvoiceLine__c saleInvoiceLine = saleInvoiceLines.get(lineEntry.dmpl__SaleInvoiceLineId__c);
            if(saleInvoiceLine != null)
            {
                saleInvoiceLines.get(lineEntry.dmpl__SaleInvoiceLineId__c).dmpl__ReturnedQuantity__c = lineEntry.Quantity__c;
            }
        }

        if(saleInvoiceLines.size() > 0){
            try {
                SecurityHelper.ensureCanCreateObject('dmpl__SaleInvoiceLine__c');
                skipValidations = true;
                update saleInvoiceLines.values();       
            } finally {
                skipValidations = false;
            }
        }
    }

    private static void setItemData(List<dmpl__SaleInvoiceLine__c> newEntries)
    {
        Map<Id, dmpl__Item__c> items = new Map<Id,dmpl__Item__c>(
        ItemHelper.getCachedItems(DocumentHelper.extractIds(newEntries, FIELD_SALEINVOICELINELINE_ITEMID)));
        List<dmpl__SaleInvoice__c> saleInvoiceDocuments = querySaleInvoiceDocument(DocumentHelper.extractIds(newEntries, FIELD_SALEINVOICELINELINE_SALEINVOICEID));
        ItemHelper.setQuantityFromUOM(
            newEntries, 
            null,
            items);
        setAlternateItem(newEntries, items);
        setSubscriptionDetails(newEntries,items);
        TaxGroupHelper.setApplicableTaxGroups(newEntries, saleInvoiceDocuments, items.values());
        PriceListHelper.setApplicablePrices(
            newEntries, 
            saleInvoiceDocuments, 
            items.values(),
            false);
        DiscountGroupHelper.setApplicableDiscounts(newEntries, saleInvoiceDocuments, items.values());
    }

    private static void setRNASaleInvoiceId(List<dmpl__SaleInvoiceLine__c> newEntries){
        List<dmpl__SaleInvoiceLine__c> rnaLines = CollectionHelper.getObjectsWithNull(newEntries, 'dmpl__SaleInvoiceId__c');
        if(rnaLines.size() == 0)
            return;
        List<dmpl__SaleInvoice__c> rnaInvoices = querySaleInvoiceDocumentOnExternalId(
            CollectionHelper.extractStrings(rnaLines, 'dmpl__RNASaleInvoiceExternalId__c'));
        for(dmpl__SaleInvoiceLine__c entry :  rnaLines){
            for(dmpl__SaleInvoice__c rnaSaleInvoice : rnaInvoices){
                if(entry.dmpl__RNASaleInvoiceExternalId__c == rnaSaleInvoice.dmpl__RNAExternalId__c){
                    entry.dmpl__SaleInvoiceId__c = rnaSaleInvoice.Id;
                    break;
                }
            }
            if(entry.dmpl__SaleInvoiceId__c == null){
                entry.addError('RNA Sale Invoice Not Found!');
            }
        }
    }

    private static void setAlternateItem(List<dmpl__SaleInvoiceLine__c> newEntries,Map<Id, dmpl__Item__c> items)
    {
        for(dmpl__SaleInvoiceLine__c newEntry : newEntries)
        {
            dmpl__Item__c item = items.get(newEntry.dmpl__ItemId__c);

            for(dmpl__ItemAlternate__c alternateItem : item.dmpl__ItemsAlternates__r)
            {
                if(newEntry.dmpl__AlternateItemId__c != null && newEntry.dmpl__AlternateItemId__c == alternateItem.Id)
                {
                    newEntry.dmpl__OriginalItemId__c = newEntry.dmpl__ItemId__c;
                    newEntry.dmpl__ItemId__c = alternateItem.dmpl__AlternateItemId__c;
                    newEntry.dmpl__AlternateItemId__c = null;
                }

                if(alternateItem.dmpl__AlternateType__c == 'Superseded')
                {
                    newEntry.dmpl__ItemId__c = alternateItem.dmpl__AlternateItemId__c;
                    newEntry.dmpl__OriginalItemId__c = alternateItem.dmpl__ItemId__c;
                }
            }
        }

        items = new Map<Id,dmpl__Item__c>(ItemHelper.getCachedItems(DocumentHelper.extractIds(newEntries, FIELD_SALEINVOICELINELINE_ITEMID)));
    }

    private static void validateChangeInQuantity(List<dmpl__SaleInvoiceLine__c> oldEntries, List<dmpl__SaleInvoiceLine__c> newEntries){
        Map<Id, dmpl__SaleInvoiceLine__c> oldObjectsMap = new Map<Id, dmpl__SaleInvoiceLine__c>(oldEntries);
        for(dmpl__SaleInvoiceLine__c lineEntry : newEntries){
            dmpl__SaleInvoiceLine__c oldEntry = oldObjectsMap.get(lineEntry.Id);
            if(oldEntry != null){
                Double transactedQty = (oldEntry.dmpl__ReturnedQuantity__c==null) ? 0 : oldEntry.dmpl__ReturnedQuantity__c;
                if(oldEntry.dmpl__Quantity__c != lineEntry.dmpl__Quantity__c && lineEntry.dmpl__Quantity__c != null
                    && lineEntry.dmpl__Quantity__c < transactedQty) {
                    lineEntry.addError(String.format(
                        String.valueOf(System.Label.IntegrityFailed_TransactedQuantityCanNotBeReduced), 
                        new String[]{String.valueOf(transactedQty)})); 
                } 
            }   
        }
    }

    private static void validateItemLotAndAsset(List<dmpl__SaleInvoiceLine__c> oldEntries, List<dmpl__SaleInvoiceLine__c> newEntries){
        Map<Id, dmpl__SaleInvoiceLine__c> oldObjectsMap = new Map<Id, dmpl__SaleInvoiceLine__c>(oldEntries);
        Map<Id, dmpl__Item__c> items = new Map<Id,dmpl__Item__c>(ItemHelper.getCachedItems(DocumentHelper.extractIds(newEntries, FIELD_SALEINVOICELINELINE_ITEMID)));
        for(dmpl__SaleInvoiceLine__c lineEntry : newEntries){
            if(!lineEntry.dmpl__IsILPostingApproved__c){
                continue;
            }
            dmpl__SaleInvoiceLine__c oldEntry = oldObjectsMap.get(lineEntry.Id);
            if(oldEntry != null){
                if(oldEntry.dmpl__IsILPostingApproved__c != lineEntry.dmpl__IsILPostingApproved__c){
                    dmpl__Item__c item = items.get(lineEntry.dmpl__ItemId__c);
                    if(item!=null
                        && item.dmpl__TrackAsset__c 
                        && lineEntry.dmpl__ItemLotId__c == null)
                    lineEntry.addError(String.valueOf(System.Label.DomainValidation_InventoryLotRequired));                     
                } 
            }   
        }
    }

    private static void setSubscriptionDetails(
        List<dmpl__SaleInvoiceLine__c> newEntries,
        Map<Id, dmpl__Item__c> items){
        SecurityHelper.ensureCanWriteFields(
            new string[]{'dmpl__BillingType__c','dmpl__BillingFrequency__c','dmpl__ChargeType__c'}, 
            'dmpl__SaleInvoiceLine__c');
        for(dmpl__SaleInvoiceLine__c lineEntry : newEntries){
                dmpl__Item__c currentItem =  items.get(lineEntry.dmpl__ItemId__c);
                if(currentItem != null){
                    if(lineEntry.dmpl__BillingType__c == null)
                        lineEntry.dmpl__BillingType__c = currentItem.dmpl__BillingType__c;
                    if(lineEntry.dmpl__BillingFrequency__c == null)
                        lineEntry.dmpl__BillingFrequency__c = currentItem.dmpl__BillingFrequency__c;
                    if(lineEntry.dmpl__ChargeType__c == null)
                        lineEntry.dmpl__ChargeType__c = currentItem.dmpl__ChargeType__c;
                }
        }
    }

    private static void setInvoiceDiscount(List<dmpl__SaleInvoiceLine__c> newEntries)
    {
        for(dmpl__SaleInvoiceLine__c lineEntry : newEntries)
        if(lineEntry.dmpl__InvoiceDiscount__c != null 
            && lineEntry.dmpl__InvoiceDiscount__c > 0)
            lineEntry.dmpl__Discount__c = lineEntry.dmpl__InvoiceDiscount__c;
    }

    @testVisible
    private static void updateDiscount(List<dmpl__SaleInvoiceLine__c> newEntries)
    {
        for(dmpl__SaleInvoiceLine__c lineEntry : newEntries)
        {
            if(lineEntry.dmpl__DiscountAmount__c > 0)
                lineEntry.dmpl__Discount__c = 0;
            if(lineEntry.dmpl__DiscountAmount2__c > 0)
                lineEntry.dmpl__Discount2__c = 0;
        }
    }

	@testVisible    
    private static List<dmpl__ItemServiceContract__c> queryItemServiceContractLines(
        List<ID> contractIds){
            return[SELECT 
                ID,
                dmpl__ItemId__c,
                (
                    SELECT
                    ID,
                    dmpl__ComponentItemId__c,
                    dmpl__IsInScope__c,
                    dmpl__ItemServiceContractId__c,
                    dmpl__Quantity__c
                    FROM dmpl__ItemServiceContractLines__r
                )
            FROM dmpl__ItemServiceContract__c
            WHERE Id IN :contractIds
            ];
        }

    private static List<dmpl__SaleInvoice__c> querySaleInvoiceDocument(
        List<ID> saleInvoiceLineIds){
        SecurityHelper.ensureCanReadFields(new string[]{
            'dmpl__DocumentDate__c',
            'dmpl__DiscountGroupId__c',
            'dmpl__TaxSupplyType__c',
            'dmpl__BranchId__c',
            'dmpl__PriceListId__c',
            'dmpl__Status__c',
            'dmpl__PartnerAccountId__c',
            'dmpl__TaxGroupId__c',
            'dmpl__TaxId__c',
            'dmpl__TotalLineAmount__c',
            'dmpl__PriceAsOnDate__c',
            'dmpl__TransactionType__c',
            'dmpl__TCSEligibleAmount__c',
            'dmpl__SkipScheme__c'
        }, 'dmpl__SaleInvoice__c');
        return [
            SELECT 
                Id, 
                Name, 
                dmpl__DocumentDate__c,
                dmpl__Status__c,
                dmpl__PartnerAccountId__c,
                dmpl__BranchId__c,
                dmpl__PriceListId__c,
                dmpl__DiscountGroupId__c,
                dmpl__TaxSupplyType__c,
                dmpl__AccountId__c,
                dmpl__TaxGroupId__c,
                dmpl__TaxId__c,
                dmpl__TotalLineAmount__c,
                dmpl__PriceAsOnDate__c,
                dmpl__TransactionType__c,
                dmpl__TCSEligibleAmount__c,
                dmpl__SkipScheme__c
            FROM dmpl__SaleInvoice__c 
            WHERE ID IN : saleInvoiceLineIds ];
    }
    
    private static List<dmpl__SaleInvoice__c> querySaleInvoiceDocumentOnExternalId(
        List<String> saleInvoiceExternalIds)
    {
        return [
            SELECT 
                Id, 
                dmpl__RNAExternalId__c
            FROM dmpl__SaleInvoice__c 
            WHERE dmpl__RNAExternalId__c IN : saleInvoiceExternalIds ];
    }

    @testVisible
    private static List<dmpl__SaleReturnLine__c> querySaleReturnLines(List<ID> saleReturnIds)
    {
        SecurityHelper.ensureCanReadFields(new List<String>{
            'Name', 
            'dmpl__Quantity__c'
        },'dmpl__SaleReturnLine__c');
        return [SELECT ID,
        Name,
        Quantity__c
        FROM dmpl__SaleReturnLine__c
        WHERE ID IN : saleReturnIds];
    }

    private static List<dmpl__SaleInvoiceLine__c> querySaleInvoiceLines(List<ID> saleInvoiceLineIds)
    {
        SecurityHelper.ensureCanReadFields(new List<String>{
            'Name', 
            'dmpl__ReturnedQuantity__c',
            'dmpl__ItemId__c',
            'dmpl__SKUId__c',
            'dmpl__ItemLotId__c',
            'dmpl__Quantity__c',
            'dmpl__SaleInvoiceId__c'
        },'dmpl__SaleInvoiceLine__c');
        return [ SELECT ID, 
            Name, 
            dmpl__ReturnedQuantity__c,
            dmpl__ItemId__c,
            dmpl__SKUId__c,
            dmpl__Quantity__c,
            dmpl__SaleInvoiceId__c
        FROM dmpl__SaleInvoiceLine__c
        WHERE ID IN : saleInvoiceLineIds];
    }

    @TestVisible
    private static List<dmpl__SaleInvoiceLine__c> querySaleInvoiceLinesOfSaleInvoices(
        List<ID> saleInvoiceIds)
    {
        SecurityHelper.ensureCanReadFields(new List<String>
        {
            'Name', 
            'dmpl__ItemId__c',
            'dmpl__SKUId__c',
            'dmpl__Quantity__c',
            'dmpl__UnitPrice__c',
            'dmpl__UnitPrice2__c',
            'dmpl__TaxGroupId__c',
            'dmpl__ItemLotTypeId__c',
            'dmpl__TaxAmount__c',
            'dmpl__IsPriceBundled__c',
            'dmpl__SaleInvoiceId__c'
        },'dmpl__SaleInvoiceLine__c');
        return [ SELECT ID, 
            Name, 
            dmpl__ItemId__c,
            dmpl__SKUId__c,
            dmpl__Quantity__c,
            dmpl__UnitPrice__c,
            dmpl__UnitPrice2__c,
            dmpl__TaxGroupId__c,
            dmpl__ItemLotTypeId__c,
            dmpl__TaxAmount__c,
            dmpl__IsPriceBundled__c,
            dmpl__PriceListId__c,
            dmpl__SaleInvoiceId__c,
            dmpl__PriceAsOnDate__c
        FROM dmpl__SaleInvoiceLine__c
        WHERE dmpl__SaleInvoiceId__c IN : saleInvoiceIds];
    }  

    private static List<dmpl__SaleInvoiceLine__c> queryInvoiceLines(List<Id> documentIds){
        SecurityHelper.ensureCanReadFields(new string[]{
            'dmpl__SaleInvoiceId__c',
            'dmpl__IsILPostingApproved__c',
            'dmpl__IsGLPostingApproved__c',
            'dmpl__AssetId__c',
            'dmpl__ItemId__c',
            'dmpl__SKUId__c',
            'dmpl__ItemLotId__c',
            'dmpl__Amount__c',
            'dmpl__Quantity__c',
            'dmpl__PackageSaleInvoiceLineId__c',
            'dmpl__UnitPrice__c',
            'dmpl__UnitPrice2__c',
            'dmpl__SaleOrderLineId__c',
            'dmpl__PackageSaleOrderLineId__c',
            'dmpl__SubscriptionId__c',
            'dmpl__OriginalAssetId__c',
            'dmpl__FulfillmentAllocationLineId__c'
        }, 'dmpl__SaleInvoiceLine__c');
        return [
            SELECT 
                ID, 
                dmpl__SaleInvoiceId__c, 
                dmpl__IsILPostingApproved__c, 
                dmpl__IsGLPostingApproved__c,
                dmpl__AssetId__c,
                dmpl__ItemId__c,
                dmpl__SKUId__c,
                dmpl__ItemLotId__c,
                dmpl__Amount__c,
                dmpl__Quantity__c,
                dmpl__PackageSaleInvoiceLineId__c,
                dmpl__UnitPrice__c,
                dmpl__UnitPrice2__c,
                dmpl__SaleOrderLineId__c,
                dmpl__PackageSaleOrderLineId__c,
                dmpl__SubscriptionId__c,
                dmpl__OriginalAssetId__c,
                dmpl__FulfillmentAllocationLineId__c
            FROM dmpl__SaleInvoiceLine__c
            WHERE dmpl__SaleInvoiceId__c IN :documentIds
            ORDER BY dmpl__PackageSaleInvoiceLineId__c DESC];
    }

    private static List<dmpl__SaleInvoiceLine__c> queryInvoiceLinesForLineIds(List<Id> lineIds){
        SecurityHelper.ensureCanReadFields(new string[]{
            'dmpl__SaleInvoiceId__c',
            'dmpl__IsILPostingApproved__c',
            'dmpl__IsGLPostingApproved__c',
            'dmpl__AssetId__c',
            'dmpl__ItemId__c',
            'dmpl__SKUId__c',
            'dmpl__ItemLotId__c',
            'dmpl__Amount__c',
            'dmpl__Quantity__c',
            'dmpl__PackageSaleInvoiceLineId__c',
            'dmpl__UnitPrice__c',
            'dmpl__UnitPrice2__c',
            'dmpl__SaleOrderLineId__c',
            'dmpl__PackageSaleOrderLineId__c',
            'dmpl__SubscriptionId__c',
            'dmpl__OriginalAssetId__c',
            'dmpl__FulfillmentAllocationLineId__c'
        }, 'dmpl__SaleInvoiceLine__c');
        return [
            SELECT 
                ID, 
                dmpl__SaleInvoiceId__c, 
                dmpl__IsILPostingApproved__c, 
                dmpl__IsGLPostingApproved__c,
                dmpl__AssetId__c,
                dmpl__ItemId__c,
                dmpl__SKUId__c,
                dmpl__ItemLotId__c,
                dmpl__Amount__c,
                dmpl__Quantity__c,
                dmpl__PackageSaleInvoiceLineId__c,
                dmpl__UnitPrice__c,
                dmpl__UnitPrice2__c,
                dmpl__SaleOrderLineId__c,
                dmpl__PackageSaleOrderLineId__c,
                dmpl__SubscriptionId__c,
                dmpl__OriginalAssetId__c,
                dmpl__FulfillmentAllocationLineId__c
            FROM dmpl__SaleInvoiceLine__c
            WHERE Id IN :lineIds
            ORDER BY dmpl__PackageSaleInvoiceLineId__c DESC];
    }

    private static List<dmpl__InventoryFulfillmentAllocationLine__c> queryFulfillmentAllocationLines(
        List<Id> saleOrderLineIds){
        SecurityHelper.ensureCanReadFields(new string[]{
            'dmpl__Quantity__c',
            'dmpl__AllocatedQuantity__c',
            'dmpl__PickedQuantity__c',
            'dmpl__PendingInvoiceQuantity__c',
            'dmpl__DeliveredInvoicedQuantity__c',
            'dmpl__PickedDeliveredQuantity__c',
            'dmpl__DeliveryQuantity__c',
            'dmpl__PickedInvoiceQuantity__c'}, 
            'dmpl__InventoryFulfillmentAllocationLine__c');

        return [SELECT 
            Id,
            dmpl__Quantity__c,
            dmpl__AllocatedQuantity__c,
            dmpl__PickedQuantity__c,
            dmpl__PendingInvoiceQuantity__c,
            dmpl__DeliveredInvoicedQuantity__c,
            dmpl__PickedDeliveredQuantity__c,
            dmpl__DeliveryQuantity__c,
            dmpl__PickedInvoiceQuantity__c
        FROM dmpl__InventoryFulfillmentAllocationLine__c
        WHERE 
            Id IN :saleOrderLineIds];
    }

    private static List<dmpl__ItemUnitOfMeasure__c> queryItemUnitOfMeasures(Set<Id> itemIds) {
        return [
            SELECT
                Id,
                dmpl__ItemId__c,
                dmpl__QuantityUnitOfMeasure__c,
                Name,
                dmpl__ConversionRatio__c
            FROM dmpl__ItemUnitOfMeasure__c
            WHERE dmpl__ItemId__c IN :itemIds
        ];
    }
}