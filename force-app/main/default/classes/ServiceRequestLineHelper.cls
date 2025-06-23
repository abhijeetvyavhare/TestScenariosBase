public with sharing class ServiceRequestLineHelper 
{

    private static Boolean skipValidations = false;
    private static Boolean skipComponentDeleteValidation = false;
    private static Boolean skipComponentAddValidation = false;

    private static final string OBJECT_SERVICEREQUEST = 'dmpl__ServiceRequest__c';
    private static final string OBJECT_SERVICEREQUESTLINE = 'dmpl__ServiceRequestLine__c';

    private static final string FIELD_SERVICEREQUESTLINE_SERVICEREQUESTID = 'dmpl__ServiceRequestId__c';
    private static final string FIELD_SERVICEREQUESTLINE_ITEMID = 'dmpl__ItemId__c';
    private static final string FIELD_SERVICEREQUESTLINE_SKUID = 'dmpl__SKUId__c';
    private static final string FIELD_SERVICEREQUESTLINE_AMOUNT = 'dmpl__Amount__c';
    private static final string FIELD_SERVICEREQUESTLINE_TAXGROUPID = 'dmpl__TaxGroupId__c';
    private static final string FIELD_SERVICEREQUESTLINE_QUANTITY = 'dmpl__Quantity__c';
    private static final string FIELD_SERVICEREQUESTLINE_ITEMALIASID = 'dmpl__ItemAliasId__c';
    private static final string FIELDNAME_SERVICEREQUESTLINE_PRICELISTRULEID = 'dmpl__PriceListRuleId__c';
    private static final string FIELD_SERVICEREQUESTLINE_CANCELLEDQUANTITY = 'dmpl__CancelledQuantity__c';
    private static final string FIELD_SERVICEREQUESTLINE_ITEMSERVICEONTRACTID = 'dmpl__ItemServiceContractId__c';

    private static final string RELATION_SERVICEREQUEST_STATUS = 'dmpl__ServiceRequestId__r.dmpl__Status__c';

    private static final List<String> LIST_FIELDS_NONEDITABLE = new List<String>{FIELD_SERVICEREQUESTLINE_SERVICEREQUESTID};
    private static final List<String> LIST_FIELDS_SYSTEM = new List<String>{};
    private static final List<String> LIST_FIELDS_SOURCEPOULATED = new List<String>{};
    private static final List<String> LIST_FIELDS_LOCKEDIFTRANSACTED = new List<String>{FIELD_SERVICEREQUESTLINE_ITEMID};

    public static void validateData(
        Boolean isInsert, 
        Boolean isUpdate, 
        Boolean isDelete, 
        List<dmpl__ServiceRequestLine__c> newEntries, 
        List<dmpl__ServiceRequestLine__c> oldEntries)
    {
        try{
            if(isInsert){
                FieldMappingHelper.copyFieldMappingData(
                    newEntries);
            }
            if(skipValidations){
                return;
            }
    
            if(isInsert){
                DocumentHelper.validateChangeInSystemFields(LIST_FIELDS_SYSTEM, newEntries);
                validateItem(newEntries);
                (new DocumentStatusDFSHelper()).DocumentStatusRelatedObjectRestrictEdits_New(OBJECT_SERVICEREQUEST, OBJECT_SERVICEREQUESTLINE, RELATION_SERVICEREQUEST_STATUS, newEntries);
                AssetServiceContractHelper.validateLineItemServiceContract(
                    newEntries, 
                    'dmpl__ServiceRequest__c',
                    'dmpl__ServiceRequestId__c');
            }else if(isUpdate){
                DocumentHelper.validateChangeInSystemFields(LIST_FIELDS_SYSTEM, oldEntries, newEntries);
                DocumentHelper.validateChangeInKeyFields(LIST_FIELDS_NONEDITABLE, oldEntries, newEntries);
                DocumentHelper.validateChangeInLockedIfTransactedFields(LIST_FIELDS_LOCKEDIFTRANSACTED, oldEntries, newEntries, FIELD_SERVICEREQUESTLINE_QUANTITY);
                validateCampaignLineUpdate(newEntries, oldEntries);
                (new DocumentStatusDFSHelper()).DocumentStatusRelatedObjectRestrictEdits_Edit(OBJECT_SERVICEREQUEST, OBJECT_SERVICEREQUESTLINE, RELATION_SERVICEREQUEST_STATUS, oldEntries, newEntries);
                AssetServiceContractHelper.validateLineItemServiceContract(
                    newEntries, 
                    'dmpl__ServiceRequest__c',
                    'dmpl__ServiceRequestId__c');
            }else if(isDelete){
                validateCampaignLineDelete(oldEntries);
                DocumentHelper.validateCanBeDeleted(oldEntries, DocumentHelper.extractIds(DocumentHelper.getObjectsByFilter(oldEntries, 'dmpl__IsConfirmed__c', true)));
                (new DocumentStatusDFSHelper()).DocumentStatusRelatedObjectRestrictEdits_Delete(OBJECT_SERVICEREQUEST, OBJECT_SERVICEREQUESTLINE, RELATION_SERVICEREQUEST_STATUS, oldEntries);
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
        List<dmpl__ServiceRequestLine__c> newEntries, 
        List<dmpl__ServiceRequestLine__c> oldEntries){ 
        try {
            if(isInsert){
                setItemData(
                    newEntries);
                setOrderDiscount(
                    newEntries);
                TaxHelper.setLinesTaxes(
                    newEntries);
            }
            else if(isUpdate){
                List<dmpl__ServiceRequestLine__c> modifiedObjects = DocumentHelper.getModifiedNewObjects(
                    FIELDNAME_SERVICEREQUESTLINE_PRICELISTRULEID, 
                    oldEntries, 
                    newEntries);
                if(modifiedObjects.size()>0){
                    Map<Id, dmpl__Item__c> items = new Map<Id,dmpl__Item__c>(
                        ItemHelper.getCachedItems(
                            DocumentHelper.extractIds(
                                modifiedObjects, 
                                FIELD_SERVICEREQUESTLINE_ITEMID)));
                    List<dmpl__ServiceRequest__c> serviceRequestDocuments = queryServiceRequestDocument(
                        DocumentHelper.extractIds(
                            modifiedObjects, 
                            FIELD_SERVICEREQUESTLINE_SERVICEREQUESTID));
                    PriceListHelper.setApplicablePrices(
                        modifiedObjects, 
                        serviceRequestDocuments, 
                        items.values(), 
                        DocumentHelper.extractIds(
                            modifiedObjects, 
                            FIELDNAME_SERVICEREQUESTLINE_PRICELISTRULEID),
                            'ServiceRequestId__c');}
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
                                FIELD_SERVICEREQUESTLINE_ITEMID)));
                    List<dmpl__ServiceRequest__c> serviceRequestDocuments = queryServiceRequestDocument(
                        DocumentHelper.extractIds(
                            modifiedObjects, 
                            FIELD_SERVICEREQUESTLINE_SERVICEREQUESTID));
                    PriceListHelper.setApplicablePrices(
                        modifiedObjects, 
                        serviceRequestDocuments, 
                        items.values(),
                        true);
                }
                modifiedObjects = DocumentHelper.getModifiedNewObjects(
                    new string[]{
                        FIELD_SERVICEREQUESTLINE_TAXGROUPID,
                        FIELD_SERVICEREQUESTLINE_ITEMID, 
                        FIELD_SERVICEREQUESTLINE_SKUID,
                        FIELD_SERVICEREQUESTLINE_AMOUNT
                    }, 
                    oldEntries, 
                    newEntries);
                if(modifiedObjects.size()>0){
                    TaxHelper.setLinesTaxes(
                        newEntries);
                }
                updateDiscount(newEntries);
                }
            else if(isDelete){
                //ServiceRequestTaxHelper.deleteApplicableTaxes(oldEntries);
            }
        } catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }

        }

    public static void afterPostData(
        Boolean isInsert, 
        Boolean isUpdate, 
        Boolean isDelete, 
        List<dmpl__ServiceRequestLine__c> newEntries, 
        List<dmpl__ServiceRequestLine__c> oldEntries)
    {
        try {
    
            if(isInsert){
                PackageHelper.populatePackageItems(newEntries);
                // createDocumentServiceContract(
                //     newEntries);
                TaxHelper.createLinesTaxes(
                    isInsert, 
                    newEntries);
            }else if(isUpdate){
                List<dmpl__ServiceRequestLine__c> modifiedObjects = DocumentHelper.getModifiedNewObjects(
                    new string[]{
                        FIELD_SERVICEREQUESTLINE_TAXGROUPID,
                        FIELD_SERVICEREQUESTLINE_ITEMID, 
                        FIELD_SERVICEREQUESTLINE_SKUID,
                        FIELD_SERVICEREQUESTLINE_AMOUNT
                    }, 
                    oldEntries, 
                    newEntries);
                if(modifiedObjects.size()>0){
                    TaxHelper.createLinesTaxes(
                        isInsert,
                        modifiedObjects);
                }
            }else if(isDelete){
                TaxHelper.deleteLinesTaxes(oldEntries);
            }  
        } catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }  
    }

    public static void createServiceRequestLinesFromServiceContract(List<dmpl__ServiceRequest__c> modifiedObjects)
    {
        List<dmpl__ServiceRequestLine__c> newServiceRequestLines = new List<dmpl__ServiceRequestLine__c>();
        List<dmpl__AssetServiceContract__c> assetServiceContracts = queryAssetServiceContracts(DocumentHelper.extractIds(modifiedObjects, 'dmpl__AssetId__c'));
        for(dmpl__ServiceRequest__c serviceRequest : modifiedObjects){
            List<dmpl__AssetServiceContract__c> currentAssetServiceContracts = getEligibleAssetServiceContracts(assetServiceContracts, serviceRequest);
            if(currentAssetServiceContracts.size() > 0)
            {
                for(dmpl__AssetServiceContract__c currentAssetServiceContract : currentAssetServiceContracts)
                {
                    for(dmpl__AssetServiceContractLine__c currentAssetServiceContractLine : currentAssetServiceContract.AssetServiceContractLines__r)
                    {
                        newServiceRequestLines.add(new dmpl__ServiceRequestLine__c(
                            dmpl__ServiceRequestId__c = serviceRequest.Id,
                            dmpl__ItemId__c = currentAssetServiceContractLine.dmpl__ComponentItemId__c,
                            dmpl__Quantity__c = currentAssetServiceContractLine.dmpl__PendingQuantity__c,
                            dmpl__PostingType__c = currentAssetServiceContract.dmpl__PostingType__c,
                            dmpl__ItemServiceContractId__c = currentAssetServiceContract.dmpl__ItemServiceContractId__c,
                            dmpl__AssetServiceContractLineId__c = currentAssetServiceContractLine.Id,
                            dmpl__ServiceContractItemId__c = currentAssetServiceContract.dmpl__ServiceContractItemId__c
                        ));
                    }
                }
            }
        }

        if(newServiceRequestLines.size() > 0)
        {
            try{
                skipValidations = true;
                SecurityHelper.ensureCanCreateObject(OBJECT_SERVICEREQUESTLINE);
                SecurityHelper.ensureCanWriteFields(new List<String>{
                    'dmpl__ItemId__c',
                    'dmpl__Quantity__c',
                    'dmpl__PostingType__c',
                    'dmpl__ItemServiceContractId__c',
                    'dmpl__ServiceContractItemId__c',
                    'dmpl__AssetServiceContractLineId__c'
                }, OBJECT_SERVICEREQUESTLINE);
                insert newServiceRequestLines;
            } catch(Exception error){
                ExceptionLogHelper.logException(error);
                throw error;
            } finally {
                skipValidations = false;
            }
        }
    }

    public static void populateLinesForAssetMaintenance(
        List<dmpl__ServiceRequest__c> serviceRequests,
        Boolean manualAssetAction){
        List<dmpl__ServiceRequestLine__c> newServiceRequestLines = new List<dmpl__ServiceRequestLine__c>();
        List<dmpl__AssetMaintenance__c> assetMaintenanceItems = [
            SELECT 
                Id,
                dmpl__AssetId__c,
                dmpl__BranchId__c,
                dmpl__IsMandatory__c,
                dmpl__ItemId__c,
                dmpl__ItemServiceContractId__c,
                dmpl__PartnerAccountId__c,
                dmpl__Quantity__c,
                dmpl__ServiceCampaignId__c,
                dmpl__ServiceCampaignBatchInstanceId__c,
                dmpl__ServiceCampaignMemberId__c,
                dmpl__ServiceCampaignItemId__c
            FROM
                dmpl__AssetMaintenance__c
            WHERE
                dmpl__IsExecuted__c = false
                AND dmpl__ServiceCampaignId__r.dmpl__ManualAssetAction__c = :manualAssetAction 
                AND dmpl__ServiceCampaignId__r.dmpl__IsActive__c = True
                AND (dmpl__ServiceCampaignId__r.dmpl__StartDate__c =  null OR dmpl__ServiceCampaignId__r.dmpl__StartDate__c <= TODAY)
                AND (dmpl__ServiceCampaignId__r.dmpl__EndDate__c =  null OR dmpl__ServiceCampaignId__r.dmpl__EndDate__c >= TODAY)
                AND dmpl__AssetId__c IN: CollectionHelper.extractIds(
                    serviceRequests, 
                    'dmpl__AssetId__c')];
        for(dmpl__ServiceRequest__c request : serviceRequests){
            List<dmpl__AssetMaintenance__c> assetItems = CollectionHelper.getObjects(
                assetMaintenanceItems,
                'dmpl__AssetId__c',
                request.dmpl__AssetId__c);
            for(dmpl__AssetMaintenance__c assetItem : assetItems){
                newServiceRequestLines.add(new dmpl__ServiceRequestLine__c(
                    dmpl__ServiceRequestId__c = request.Id,
                    dmpl__ItemId__c = assetItem.dmpl__ItemId__c,
                    dmpl__Quantity__c = assetItem.dmpl__Quantity__c,
                    dmpl__ItemServiceContractId__c = assetItem.dmpl__ItemServiceContractId__c,
                    dmpl__IsServiceCampaignMandatory__c = assetItem.dmpl__IsMandatory__c,
                    dmpl__ServiceCampaignId__c = assetItem.dmpl__ServiceCampaignId__c,
                    dmpl__ServiceCampaignItemId__c = assetItem.dmpl__ServiceCampaignItemId__c,
                    dmpl__AssetMaintenanceId__c = assetItem.Id
                ));
            }
        }

        if(newServiceRequestLines.size() > 0){
            try{
                skipValidations = true;
                SecurityHelper.ensureCanWriteObject(OBJECT_SERVICEREQUESTLINE);
                SecurityHelper.ensureCanWriteFields(new List<string>{
                    'dmpl__ItemId__c',
                    'dmpl__Quantity__c',
                    'dmpl__ItemServiceContractId__c',
                    'dmpl__ServiceCampaignId__c',
                    'dmpl__ServiceCampaignItemId__c',
                    'dmpl__IsServiceCampaignMandatory__c'
                }, OBJECT_SERVICEREQUESTLINE);
                insert newServiceRequestLines; 
            } catch(Exception error){
                ExceptionLogHelper.logException(error);
                throw error;
            } finally {
                skipValidations = false;
            }
        }
    }

    private static void setItemData(
        List<dmpl__ServiceRequestLine__c> newEntries){
        setItemAliasData(newEntries);
        Map<Id, dmpl__Item__c> items = new Map<Id,dmpl__Item__c>(
            ItemHelper.getCachedItems(
                DocumentHelper.extractIds(
                    newEntries, 
                    FIELD_SERVICEREQUESTLINE_ITEMID)));
        List<dmpl__ServiceRequest__c> serviceRequestDocuments = queryServiceRequestDocument(
            DocumentHelper.extractIds(
                newEntries, 
                FIELD_SERVICEREQUESTLINE_SERVICEREQUESTID));
        setDefaultSKU(
            newEntries, 
            items);
        setAlternateItem(
            newEntries, 
            items);
        setInvoiceGroup(
            newEntries,
            items);
        setSubscriptionDetails(
                newEntries,
                items);
        TaxGroupHelper.setApplicableTaxGroups(
            newEntries, 
            serviceRequestDocuments, 
            items.values());
        PriceListHelper.setApplicablePrices(
            newEntries, 
            serviceRequestDocuments, 
            items.values(),
            false);
        DiscountGroupHelper.setApplicableDiscounts(
            newEntries, 
            serviceRequestDocuments, 
            items.values());
    }

    private static void setItemAliasData(List<dmpl__ServiceRequestLine__c> newEntries)
    {
        List<Id> itemAliasIds = DocumentHelper.extractIds( DocumentHelper.getObjectsWithNotNull(newEntries, FIELD_SERVICEREQUESTLINE_ITEMALIASID), FIELD_SERVICEREQUESTLINE_ITEMALIASID);
        Map<Id, dmpl__ItemAlias__c> itemAliases = new Map<Id, dmpl__ItemAlias__c>([SELECT Id, Name, dmpl__ItemId__c, dmpl__SKUId__c, dmpl__PartnerAccountId__c, dmpl__ItemLotTypeId__c FROM dmpl__ItemAlias__c WHERE Id IN : itemAliasIds]);
        for(dmpl__ServiceRequestLine__c lineEntry : newEntries)
        {
            if(!String.isBlank(lineEntry.dmpl__ItemAliasId__c))
            {
                dmpl__ItemAlias__c currentItemAlias = itemAliases.get(lineEntry.dmpl__ItemAliasId__c);
                if(currentItemAlias != null)
                {
                    if(lineEntry.dmpl__ItemId__c != null && currentItemAlias.dmpl__ItemId__c != null && lineEntry.dmpl__ItemId__c != currentItemAlias.dmpl__ItemId__c)
                        lineEntry.addError(String.format(String.valueOf(System.Label.DocumentValidation_IncorrectItemAlias), new String[]{String.valueOf(FIELD_SERVICEREQUESTLINE_ITEMID)})); 
                    if(lineEntry.dmpl__SKUId__c != null && currentItemAlias.dmpl__SKUId__c != null && lineEntry.dmpl__SKUId__c != currentItemAlias.dmpl__SKUId__c)
                        lineEntry.addError(String.format(String.valueOf(System.Label.DocumentValidation_IncorrectItemAlias), new String[]{String.valueOf(FIELD_SERVICEREQUESTLINE_SKUID)})); 

                    if(lineEntry.dmpl__ItemId__c == null)
                        lineEntry.dmpl__ItemId__c = currentItemAlias.dmpl__ItemId__c;
                    if(lineEntry.dmpl__SKUId__c == null)
                        lineEntry.dmpl__SKUId__c = currentItemAlias.dmpl__SKUId__c;
                    if(lineEntry.dmpl__ItemLotTypeId__c == null)
                        lineEntry.dmpl__ItemLotTypeId__c = currentItemAlias.dmpl__ItemLotTypeId__c;
                }
            }
        }
    }

    private static void setDefaultSKU(
        List<dmpl__ServiceRequestLine__c> newEntries, 
        Map<Id, dmpl__Item__c> items){
        // for(dmpl__ServiceRequestLine__c lineEntry : newEntries){
        //     dmpl__Item__c item = items.get(lineEntry.dmpl__ItemId__c);
        //     if(item !=null 
        //         && lineEntry.dmpl__SKUId__c == null 
        //         && item.dmpl__IsSKURequired__c == true){
        //         for(dmpl__SKU__c sku : item.dmpl__SKUs__r){
        //             if(sku.dmpl__IsDefault){
        //                 lineEntry.dmpl__SKUId__c = sku.Id;
        //                 break;
        //             }
        //         }
        //     }
        // }
    }

    private static void setInvoiceGroup(
        List<dmpl__ServiceRequestLine__c> newEntries,
        Map<Id, dmpl__Item__c> items){
        // SecurityHelper.ensureCanWriteField(
        //     'dmpl__InvoiceGroup__c', 
        //     'dmpl__ServiceRequestLine__c');
        // for(dmpl__ServiceRequestLine__c lineEntry : newEntries){
        //     dmpl__Item__c currentItem =  items.get(lineEntry.dmpl__ItemId__c);
        //     if(lineEntry.dmpl__InvoiceGroup__c == null && currentItem != null){
        //         lineEntry.dmpl__InvoiceGroup__c = currentItem.dmpl__InvoiceGroup__c;
        //     }
        // }
    }

    private static void setSubscriptionDetails(
        List<dmpl__ServiceRequestLine__c> newEntries,
        Map<Id, dmpl__Item__c> items){
        // SecurityHelper.ensureCanWriteFields(new string[]{
        //     'dmpl__BillingType__c',
        //     'dmpl__BillingFrequency__c',
        //     'dmpl__ChargeType__c'
        // }, 'dmpl__ServiceRequestLine__c');
        // for(dmpl__ServiceRequestLine__c lineEntry : newEntries){
        //         dmpl__Item__c currentItem =  items.get(lineEntry.dmpl__ItemId__c);
        //         if(currentItem != null){
        //             if(lineEntry.dmpl__BillingType__c == null)
        //                 lineEntry.dmpl__BillingType__c = currentItem.dmpl__BillingType__c;
        //             if(lineEntry.dmpl__BillingFrequency__c == null)
        //                 lineEntry.dmpl__BillingFrequency__c = currentItem.dmpl__BillingFrequency__c;
        //             if(lineEntry.dmpl__ChargeType__c == null)
        //                 lineEntry.dmpl__ChargeType__c = currentItem.dmpl__ChargeType__c;
        //         }
        // }
    }

    private static void setAlternateItem(
        List<dmpl__ServiceRequestLine__c> newEntries, 
        Map<Id, dmpl__Item__c> items){
        for(dmpl__ServiceRequestLine__c newEntry : newEntries){
            dmpl__Item__c item = items.get(newEntry.dmpl__ItemId__c);
            for(dmpl__ItemAlternate__c alternateItem : item.dmpl__ItemsAlternates__r){
                if(newEntry.dmpl__AlternateItemId__c != null 
                    && newEntry.dmpl__AlternateItemId__c == alternateItem.Id){
                    newEntry.dmpl__OriginalItemId__c = newEntry.dmpl__ItemId__c;
                    newEntry.dmpl__ItemId__c = alternateItem.dmpl__AlternateItemId__c;
                    newEntry.dmpl__AlternateItemId__c = null;
                }

                if(alternateItem.dmpl__AlternateType__c == 'Superseded'){
                    newEntry.dmpl__ItemId__c = alternateItem.dmpl__AlternateItemId__c;
                    newEntry.dmpl__OriginalItemId__c = alternateItem.dmpl__ItemId__c;
                }
            }
        }
        items = new Map<Id,dmpl__Item__c>(
            ItemHelper.getCachedItems(
                DocumentHelper.extractIds(
                    newEntries, 
                    FIELD_SERVICEREQUESTLINE_ITEMID)));
    }

    public static void addPackageServiceRequestLines(
        Map<dmpl__ServiceRequestLine__c, 
        List<dmpl__ItemComponent__c>> packageLines){
        List<dmpl__ServiceRequestLine__c> orderLinesToCreate = new List<dmpl__ServiceRequestLine__c>();
        for(dmpl__ServiceRequestLine__c line : packageLines.keySet()){
            List<dmpl__ItemComponent__c> components = packageLines.get(line);
            for(dmpl__ItemComponent__c component : components){
                orderLinesToCreate.add(
                    createServiceRequestLine(
                        line, 
                        component));
            }
        }

        if(orderLinesToCreate.size()>0){
            SecurityHelper.ensureCanCreateObject('dmpl__ServiceRequestLine__c');
            SecurityHelper.ensureCanCreateFields(new List<String>{
                'dmpl__ItemId__c',
                'dmpl__SKUId__c',
                'dmpl__PackageServiceRequestLineId__c',
                'dmpl__Quantity__c',
                'dmpl__ServiceRequestId__c'    
            }, 'dmpl__ServiceRequestLine__c');
            try {
                skipValidations = true;
                skipComponentAddValidation = true;
                insert orderLinesToCreate;
            } finally {
                skipValidations = false;
                skipComponentAddValidation = false;
            }
        }
    }

    public static void applyPackageConfiguration(
        dmpl__ServiceRequestLine__c packageServiceRequestLine, 
        List<dmpl__ServiceRequestLine__c> existingLines, 
        List<dmpl__ItemComponent__c> components){
        List<dmpl__ServiceRequestLine__c> orderLinesToCreate = new List<dmpl__ServiceRequestLine__c>();
        List<dmpl__ServiceRequestLine__c> orderLinesToUpdate = new List<dmpl__ServiceRequestLine__c>();
        List<dmpl__ServiceRequestLine__c> orderLinesToDelete = new List<dmpl__ServiceRequestLine__c>();
        if(packageServiceRequestLine == null){
            throw new DMPLException(
                String.format(
                    String.valueOf(
                        System.Label.Generic_MissingObject), 
                        new String[]{dmpl__ServiceRequestLine__c.class.getName()}));
        }
        for(dmpl__ItemComponent__c component : components){
            dmpl__ServiceRequestLine__c exisitngLine = (dmpl__ServiceRequestLine__c)CollectionHelper.getObject(
                existingLines, 
                'dmpl__ItemComponentId__c', 
                component.Id);
            if(exisitngLine == null){
                orderLinesToCreate.add(
                    createServiceRequestLine(
                        packageServiceRequestLine, 
                        component));
            }else if(component.dmpl__IsQuantityEditable__c){
                Decimal quantity = PackageHelper.getDefaultComponentQuantity(
                    packageServiceRequestLine.dmpl__Quantity__c, 
                    component);
                if(exisitngLine.dmpl__Quantity__c != quantity){
                    exisitngLine.dmpl__Quantity__c = component.dmpl__Quantity__c;
                    orderLinesToUpdate.add(exisitngLine);
                }
            }
        }

        for(dmpl__ServiceRequestLine__c line : existingLines){
            if(line.Id != packageServiceRequestLine.Id 
                && CollectionHelper.getObject(
                    components, 
                    line.dmpl__ItemComponentId__c) == null){
                orderLinesToDelete.add(line);
            }
        }

        if(orderLinesToCreate.size()>0){
            // SecurityHelper.ensureCanCreateObject('dmpl__ServiceRequestLine__c');
            // SecurityHelper.ensureCanCreateFields(new List<String>{
            //     'dmpl__ItemId__c',
            //     'dmpl__SKUId__c',
            //     'dmpl__PackageServiceRequestLineId__c',
            //     'dmpl__Quantity__c',
            //     'dmpl__ServiceRequestId__c'    
            // }, 'dmpl__ServiceRequestLine__c');
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
                'dmpl__PackageServiceRequestLineId__c',
                'dmpl__Quantity__c'
            }, 'dmpl__ServiceRequestLine__c');
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
            SecurityHelper.ensureCanDeleteObject('dmpl__ServiceRequestLine__c');
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

    private static void validateItem(List<dmpl__ServiceRequestLine__c> newEntries){
        Map<Id, dmpl__Item__c> items = new Map<Id,dmpl__Item__c>(
            ItemHelper.getCachedItems(
                DocumentHelper.extractIds(
                    newEntries, 
                    FIELD_SERVICEREQUESTLINE_ITEMID)));
        for(dmpl__ServiceRequestLine__c orderLine : newEntries){
            dmpl__Item__c item = items.get(orderLine.dmpl__ItemId__c);
            if(orderLine.dmpl__PackageServiceRequestLineId__c == null 
                && item!=null && item.dmpl__OnlySoldInPackage__c){
                orderLine.addError(System.Label.PackageError_ItemSoldOnlyInPackage);
            }
            if(orderLine.dmpl__SKUId__c == null && item!=null && item.dmpl__IsSKURequired__c){
                orderLine.addError(System.Label.Validation_SKURequired);
            }
            if(orderLine.dmpl__SKUId__c != null){
                dmpl__SKU__c sku = (dmpl__SKU__c)CollectionHelper.getObject(
                    item.dmpl__SKUs__r, 
                    orderLine.dmpl__SKUId__c);
                if(sku ==null){
                    orderLine.addError(System.Label.Validation_SKUInvalid);
                }
            }
        }
    }

    private static void setOrderDiscount(List<dmpl__ServiceRequestLine__c> newEntries){
        for(dmpl__ServiceRequestLine__c lineEntry : newEntries){
            if(lineEntry.dmpl__ServiceRequestDiscount__c != null
                && lineEntry.dmpl__ServiceRequestDiscount__c>0){
                lineEntry.dmpl__Discount__c = (lineEntry.dmpl__ServiceRequestDiscount__c/100);
            }
        }            
    }

    private static void updateDiscount(List<dmpl__ServiceRequestLine__c> newEntries){
        for(dmpl__ServiceRequestLine__c lineEntry : newEntries){
            if(lineEntry.dmpl__DiscountAmount__c > 0){
                lineEntry.dmpl__Discount__c = 0;
            }
        }
    }

    // private static void createDocumentServiceContract(
    //     List<dmpl__ServiceRequestLine__c> newEntries){
    //         List<Id> itemContractIds = CollectionHelper.extractIds(
    //             newEntries,
    //             'dmpl__ItemServiceContractId__c'
    //         );
    //         List<dmpl__ItemServiceContract__c> itemServiceContracts = queryItemServiceContractLines(
    //             itemContractIds);
    //         List<dmpl__DocumentServiceContract__c> documentServiceContract = new List<dmpl__DocumentServiceContract__c>();
    //         for(dmpl__ServiceRequestLine__c entry :newEntries){
    //             if(entry.dmpl__ItemServiceContractId__c != null){
    //                 dmpl__ItemServiceContract__c itemContract = (dmpl__ItemServiceContract__c)CollectionHelper.getObject(itemServiceContracts,entry.dmpl__ItemServiceContractId__c);
    //                 for(dmpl__ItemServiceContractLine__c line : itemContract.dmpl__ItemServiceContractLines__r){
    //                     dmpl__DocumentServiceContract__c dsc = new dmpl__DocumentServiceContract__c(); 
    //                     dsc.dmpl__ComponentItemId__c =  line.dmpl__ComponentItemId__c;
    //                     dsc.dmpl__IsInScope__c = line.dmpl__IsInScope__c;
    //                     dsc.dmpl__Quantity__c = line.dmpl__Quantity__c;
    //                     dsc.dmpl__ServiceRequestLineId__c = entry.Id;
    //                     documentServiceContract.add(dsc);
    //                 } 
    //             }
    //         }
    //         insert documentServiceContract;
    //     }

    private static List<dmpl__AssetServiceContract__c> queryAssetServiceContracts(List<ID> assetIds)
    {
        SecurityHelper.ensureCanReadFields(new List<String>{
            'dmpl__ActivatedDate__c',
            'dmpl__AssetId__c',
            'dmpl__DueDate__c',
            'dmpl__DueOnUsageReading__c',
            'dmpl__DueInHours__c',
            'dmpl__GraceUsageDays__c',
            'dmpl__GraceUsageHours__c',
            'dmpl__GraceUsageReading__c',
            'dmpl__IsUtilized__c',
            'dmpl__IsValid__c',
            'dmpl__ItemId__c',
            'dmpl__ServiceContractItemId__c',
            'dmpl__ItemServiceContractId__c',
            'dmpl__ValidtillDate__c',
            'dmpl__ValidtillHours__c',
            'dmpl__ValidtillUsageReading__c',
            'dmpl__Description__c',
            'dmpl__PostingType__c',
            'dmpl__PopulateContractLines__c'
            }, 'dmpl__AssetServiceContract__c');
        SecurityHelper.ensureCanReadFields(new List<String>{
            'dmpl__ComponentItemId__c',
            'dmpl__Quantity__c',
            'dmpl__PendingQuantity__c'
            }, 'dmpl__AssetServiceContractLine__c');
        return [SELECT 
        ID,
        Name,
        dmpl__ActivatedDate__c,
        dmpl__AssetId__c,
        dmpl__DueDate__c,
        dmpl__DueOnUsageReading__c,
        dmpl__DueInHours__c,
        dmpl__GraceUsageDays__c,
        dmpl__GraceUsageHours__c,
        dmpl__GraceUsageReading__c,
        dmpl__IsUtilized__c,
        dmpl__IsValid__c,
        dmpl__ItemId__c,
        dmpl__ServiceContractItemId__c,
        dmpl__ItemServiceContractId__c,
        dmpl__ValidtillDate__c,
        dmpl__ValidtillHours__c,
        dmpl__ValidtillUsageReading__c,
        dmpl__Description__c,
        dmpl__PostingType__c,
        dmpl__PopulateContractLines__c,
        (
            SELECT
            ID,
            Name,
            dmpl__ComponentItemId__c,
            dmpl__Quantity__c,
            dmpl__PendingQuantity__c
            FROM AssetServiceContractLines__r
            WHERE dmpl__PendingQuantity__c > 0
        )
        FROM dmpl__AssetServiceContract__c
        WHERE dmpl__AssetId__c IN : assetIds
        AND dmpl__PopulateContractLines__c = true
        ];
    }

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

    public static void confirmServiceRequestLines(List<dmpl__ServiceRequest__c> serviceRequests)
    {
        confirmServiceRequestLines(queryServiceRequestLines(DocumentHelper.extractIds(serviceRequests)));
    }

    public static void cancelServiceRequestLines(List<dmpl__ServiceRequest__c> serviceRequests)
    {
        cancelServiceRequestLines(queryServiceRequestLines(DocumentHelper.extractIds(serviceRequests)));
    }

    public static void performReprice(Id serviceRequestId){
        performReprice(new List<Id>{serviceRequestId});
    }

    public static void performReprice(List<Id> serviceRequestIds){
        List<dmpl__ServiceRequest__c> serviceRequestDocuments = queryServiceRequestDocument(
            serviceRequestIds);
        List<dmpl__ServiceRequestLine__c> serviceRequestLines = queryServiceRequestLinesOfServiceRequests(
            CollectionHelper.extractIds(
                serviceRequestDocuments));
        Map<Id, dmpl__Item__c> items = new Map<Id,dmpl__Item__c>(
            ItemHelper.getCachedItems(
                DocumentHelper.extractIds(
                    serviceRequestLines, 
                    FIELD_SERVICEREQUESTLINE_ITEMID)));

        PriceListHelper.setApplicablePrices(
            serviceRequestLines, 
            serviceRequestDocuments, 
            items.values(),
            true);
        update serviceRequestLines;
    }

    private static dmpl__ServiceRequestLine__c createServiceRequestLine(
        dmpl__ServiceRequestLine__c packageLine, 
        dmpl__ItemComponent__c component){
        return new dmpl__ServiceRequestLine__c(
            dmpl__ItemComponentId__c = component.Id,    
            dmpl__ItemId__c = component.dmpl__ComponentItemId__c,
            dmpl__SKUId__c = component.dmpl__ComponentSKUId__c,
            dmpl__PackageServiceRequestLineId__c = packageLine.Id,
            dmpl__Quantity__c = PackageHelper.getDefaultComponentQuantity(
                packageLine.dmpl__Quantity__c, 
                component),
            dmpl__ServiceRequestId__c =  packageLine.dmpl__ServiceRequestId__c,
            dmpl__IsPriceBundled__c = component.dmpl__IsBundled__c
        );
    }

    private static void confirmServiceRequestLines(List<dmpl__ServiceRequestLine__c> serviceRequestLines)
    {
        for(dmpl__ServiceRequestLine__c line : serviceRequestLines)
        {
            line.dmpl__IsConfirmed__c = true;
            line.dmpl__IsCancelled__c = false;
        }

        try{
            skipValidations = true;
            SecurityHelper.ensureCanWriteFields(new string[]{
                'dmpl__IsConfirmed__c',
                'dmpl__IsCancelled__c'
            }, 'dmpl__ServiceRequestLine__c');
            update serviceRequestLines;
        } catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        } finally {
            skipValidations = false;
        }
    }

    private static void cancelServiceRequestLines(List<dmpl__ServiceRequestLine__c> serviceRequestLines)
    {
        for(dmpl__ServiceRequestLine__c line : serviceRequestLines)
        {
            line.dmpl__IsCancelled__c = true;
            line.dmpl__IsConfirmed__c = false;
        }

        try{
            skipValidations = true;
            SecurityHelper.ensureCanWriteFields(new string[]{
                'dmpl__IsConfirmed__c',
                'dmpl__IsCancelled__c'
            }, 'dmpl__ServiceRequestLine__c');
            update serviceRequestLines;
        } catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        } finally {
            skipValidations = false;
        }
    }

    private static List<dmpl__ServiceRequest__c> queryServiceRequestDocument(
        List<ID> serviceRequestLineIds)
    {
        SecurityHelper.ensureCanReadFields(
            new string[]
            {
                'dmpl__DocumentDate__c',
                'dmpl__Status__c',
                'dmpl__AccountId__c',
                'dmpl__PartnerAccountId__c',
                'dmpl__BranchId__c',
                'dmpl__PriceListId__c',
                'dmpl__DiscountGroupId__c',
                'dmpl__TaxSupplyType__c',
                'dmpl__PriceAsOnDate__c',
                'dmpl__TCSEligibleAmount__c'
            }, 'dmpl__ServiceRequest__c');
        return [
            SELECT 
                Id, 
                Name, 
                dmpl__DocumentDate__c,
                dmpl__FailureDate__c,
                dmpl__Status__c,
                dmpl__AccountId__c,
                dmpl__PartnerAccountId__c,
                dmpl__BranchId__c,
                dmpl__TaxSupplyType__c,
                dmpl__Discount__c,
                dmpl__PriceListId__c,
                dmpl__DiscountGroupId__c,
                dmpl__PriceAsOnDate__c,
                dmpl__TCSEligibleAmount__c
            FROM dmpl__ServiceRequest__c 
            WHERE ID IN : serviceRequestLineIds ];
    }

    private static List<dmpl__ServiceRequestLine__c> queryServiceRequestLines(List<Id> serviceRequestIds)
    {
        SecurityHelper.ensureCanReadFields(new List<string>{'dmpl__IsConfirmed__c','dmpl__IsCancelled__c','dmpl__ServiceRequestId__c'}, 'dmpl__ServiceRequestLine__c');
        return [Select Id,
        Name,
        dmpl__IsConfirmed__c,
        dmpl__IsCancelled__c
        FROM dmpl__ServiceRequestLine__c
        WHERE dmpl__ServiceRequestId__c IN : serviceRequestIds];
    }

    private static List<dmpl__ServiceRequestLine__c> queryServiceRequestLinesOfServiceRequests(
        List<ID> serviceRequestIds)
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
            'dmpl__PriceListId__c',
            'dmpl__ServiceRequestId__c'
        },'dmpl__ServiceRequestLine__c');
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
            dmpl__PriceListId__c,
            dmpl__PriceListRuleId__c,
            dmpl__DiscountGroupRule__c,
            dmpl__ServiceRequestId__c,
            dmpl__PriceAsOnDate__c
        FROM dmpl__ServiceRequestLine__c
        WHERE dmpl__ServiceRequestId__c IN : serviceRequestIds];
    }  

    private static List<dmpl__AssetServiceContract__c> getEligibleAssetServiceContracts(List<dmpl__AssetServiceContract__c> assetServiceContracts, dmpl__ServiceRequest__c serviceRequest)
    {
        List<dmpl__AssetServiceContract__c> currentAssetServiceContracts = (List<dmpl__AssetServiceContract__c>)DocumentHelper.getObjectsByFilter(assetServiceContracts, 'dmpl__AssetId__c', serviceRequest.dmpl__AssetId__c);
        currentAssetServiceContracts = (List<dmpl__AssetServiceContract__c>)DocumentHelper.getObjectsByFilter(currentAssetServiceContracts, 'dmpl__ItemServiceContractId__c', serviceRequest.dmpl__ItemServiceContractId__c);
        currentAssetServiceContracts = (List<dmpl__AssetServiceContract__c>)DocumentHelper.getObjectsByFilter(currentAssetServiceContracts, 'dmpl__IsValid__c', true);
        return currentAssetServiceContracts;
    }

    private static void validateCampaignLineUpdate(
        List<dmpl__ServiceRequestLine__c> newEntries,
        List<dmpl__ServiceRequestLine__c> oldEntries){
        List<dmpl__ServiceRequestLine__c> modifiedObjects = DocumentHelper.getModifiedNewObjects(
            new string[]{
                FIELD_SERVICEREQUESTLINE_ITEMID, 
                FIELD_SERVICEREQUESTLINE_ITEMSERVICEONTRACTID,
                FIELD_SERVICEREQUESTLINE_QUANTITY}, oldEntries, newEntries);
        for(dmpl__ServiceRequestLine__c line : modifiedObjects){
            if(line.dmpl__IsServiceCampaignMandatory__c){
                line.addError('Campaign Mandated Items can not be modified!');
            }
        }
    }

    private static void validateCampaignLineDelete(
        List<dmpl__ServiceRequestLine__c>  oldEntries){
        for(dmpl__ServiceRequestLine__c line : oldEntries){
            if(line.dmpl__IsServiceCampaignMandatory__c){
                line.addError('Campaign Mandated Items can not be delted!');
            }
        }
    }
}