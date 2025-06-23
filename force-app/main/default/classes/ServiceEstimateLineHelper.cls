public with sharing class ServiceEstimateLineHelper {

    private static Boolean skipValidations = false;
    private static Boolean skipComponentAddValidation = false;
    private static Boolean skipComponentDeleteValidation = false;

    private static final string OBJECT_QUOTE = 'dmpl__Quote__c';
    private static final string OBJECT_QUOTELINE = 'dmpl__QuoteLine__c';

    private static final string FIELD_QUOTE_SERVICEREQUESTID = 'dmpl__ServiceRequestId__c';

    private static final string FIELDNAME_QUOTELINE_PRICELISTRULEID = 'dmpl__PriceListRuleId__c';
    private static final string FIELD_QUOTELINE_QUOTEID = 'dmpl__QuoteId__c';
    private static final string FIELD_QUOTELINE_AMOUNT = 'dmpl__Amount__c';
    private static final string FIELD_QUOTELINE_DURATIONINHOURS = 'dmpl__DurationInHours__c';
    private static final string FIELD_QUOTELINE_HEALTHCHECKRECOMMENDATIONID = 'dmpl__HealthCheckRecommendationId__c';
    private static final string FIELD_QUOTELINE_INCLUDEINPACKAGE = 'dmpl__IncludeinPackage__c';
    private static final string FIELD_QUOTELINE_ISPACKAGESERVICE = 'dmpl__IsPackageService__c';
    private static final string FIELD_QUOTELINE_ITEMID = 'dmpl__ItemId__c';
    private static final string FIELD_QUOTELINE_SKUID = 'dmpl__SKUId__c';
    private static final string FIELD_QUOTELINE_PACKAGECLASSIFICATION = 'dmpl__PackageClassification__c';
    private static final string FIELD_QUOTELINE_QUANTITY = 'dmpl__Quantity__c';
    private static final string FIELD_QUOTELINE_RECOMMENDATIONTYPE = 'dmpl__RecommendationType__c';
    private static final string FIELD_QUOTELINE_SERVICECONTRACTID = 'dmpl__ServiceContractId__c';
    private static final string FIELD_QUOTELINE_TAXGROUPID = 'dmpl__TaxGroupId__c';
    private static final string FIELD_QUOTELINE_UNITPRICE = 'dmpl__UnitPrice__c';
    private static final string FIELD_QUOTELINE_USAGEREADING = 'dmpl__UsageReading__c';
    private static final string FIELD_QUOTELINE_USAGEREADINGHOURS = 'dmpl__UsageReadingHours__c';
    private static final string FIELD_QUOTELINE_SERVICEREQUESTLINEID = 'dmpl__ServiceRequestLineId__c';

    private static final string RELATION_QUOTE_STATUS = 'dmpl__QuoteId__r.dmpl__Status__c';

    private static final List<String> LIST_FIELDS_NONEDITABLE = new List<String>{FIELD_QUOTELINE_QUOTEID};
    private static final List<String> LIST_FIELDS_SYSTEM = new List<String>{FIELD_QUOTELINE_SERVICEREQUESTLINEID};
    private static final List<String> LIST_FIELDS_SOURCEPOULATED = new List<String>{ FIELD_QUOTELINE_ITEMID, FIELD_QUOTELINE_PACKAGECLASSIFICATION, FIELD_QUOTELINE_ISPACKAGESERVICE};
    private static final List<String> LIST_FIELDS_LOCKEDIFTRANSACTED = new List<String>{};

    public static void validateData(Boolean isInsert, Boolean isUpdate, Boolean isDelete, List<dmpl__QuoteLine__c> newEntries, List<dmpl__QuoteLine__c> oldEntries)
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
                (new DocumentStatusDFSHelper()).DocumentStatusRelatedObjectRestrictEdits_New(OBJECT_QUOTE, OBJECT_QUOTELINE, RELATION_QUOTE_STATUS, newEntries);
            }else if(isUpdate){
                DocumentHelper.validateChangeInSystemFields(LIST_FIELDS_SYSTEM, oldEntries, newEntries);
                DocumentHelper.validateChangeInKeyFields(LIST_FIELDS_NONEDITABLE, oldEntries, newEntries);
                DocumentHelper.validateChangeInSourcePopulatedFields(LIST_FIELDS_SOURCEPOULATED, oldEntries, newEntries, FIELD_QUOTELINE_QUOTEID);
                DocumentHelper.validateChangeInLockedIfTransactedFields(LIST_FIELDS_LOCKEDIFTRANSACTED, oldEntries, newEntries, FIELD_QUOTELINE_QUANTITY);
                (new DocumentStatusDFSHelper()).DocumentStatusRelatedObjectRestrictEdits_Edit(OBJECT_QUOTE, OBJECT_QUOTELINE, RELATION_QUOTE_STATUS, oldEntries, newEntries);
            }else if(isDelete){
                //DocumentHelper.validateCanBeDeleted(oldEntries, FIELD_QUOTELINE_QUANTITY);
                (new DocumentStatusDFSHelper()).DocumentStatusRelatedObjectRestrictEdits_Delete(OBJECT_QUOTE, OBJECT_QUOTELINE, RELATION_QUOTE_STATUS, oldEntries);
                if(!skipComponentDeleteValidation){
                    PackageHelper.validateComponentsDelete(
                        oldEntries, 
                        queryQuoteLines(
                            CollectionHelper.extractIds(
                                oldEntries, 
                                'dmpl__PackageQuoteLineId__c')));
                }
            }
        } catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }

    public static void postData(Boolean isInsert, Boolean isUpdate, Boolean isDelete, List<dmpl__QuoteLine__c> newEntries, List<dmpl__QuoteLine__c> oldEntries)
    {
        if(isInsert){
            setItemData(newEntries);
            setQuoteDiscount(
                newEntries);
            TaxHelper.setLinesTaxes(
                newEntries);
        }
        else if(isUpdate){
            List<dmpl__QuoteLine__c> modifiedObjects = DocumentHelper.getModifiedNewObjects(FIELDNAME_QUOTELINE_PRICELISTRULEID, oldEntries, newEntries);
            if(modifiedObjects.size()>0){
                Map<Id, dmpl__Item__c> items = new Map<Id,dmpl__Item__c>(ItemHelper.getCachedItems(DocumentHelper.extractIds(modifiedObjects, FIELD_QUOTELINE_ITEMID)));
                List<dmpl__Quote__c> serviceEstimateDocuments = queryServiceEstimates(DocumentHelper.extractIds(modifiedObjects, FIELD_QUOTELINE_QUOTEID));
                PriceListHelper.setApplicablePrices(modifiedObjects, serviceEstimateDocuments, items.values(), DocumentHelper.extractIds(modifiedObjects, FIELDNAME_QUOTELINE_PRICELISTRULEID),'dmpl__Quote__c');
            }

            modifiedObjects = DocumentHelper.getModifiedNewObjects(
                new List<String>{
                    'dmpl__PriceListId__c',
                    'dmpl__PriceAsOnDate__c'
                },
                oldEntries, 
                newEntries);
            if(modifiedObjects.size()>0){
                Map<Id, dmpl__Item__c> items = new Map<Id,dmpl__Item__c>(ItemHelper.getCachedItems(DocumentHelper.extractIds(modifiedObjects, FIELD_QUOTELINE_ITEMID)));
                List<dmpl__Quote__c> serviceEstimateDocuments = queryServiceEstimates(DocumentHelper.extractIds(modifiedObjects, FIELD_QUOTELINE_QUOTEID));
                PriceListHelper.setApplicablePrices(modifiedObjects, serviceEstimateDocuments, items.values(), true);
            }

            modifiedObjects = DocumentHelper.getModifiedNewObjects(new string[]{FIELD_QUOTELINE_TAXGROUPID,FIELD_QUOTELINE_ITEMID, FIELD_QUOTELINE_SKUID,FIELD_QUOTELINE_AMOUNT}, oldEntries, newEntries);
            if(modifiedObjects.size()>0){
                TaxHelper.createLinesTaxes(
                    isInsert, 
                    modifiedObjects);
            }
            TaxHelper.setLinesTaxes(
                    newEntries);
            updateDiscount(newEntries);
        }else if(isDelete){
            // ServiceEstimateTaxHelper.deleteApplicableTaxes(oldEntries);
            deletePackageItems(oldEntries);
        } 
    }

    public static void afterPostData(Boolean isInsert, Boolean isUpdate, Boolean isDelete, List<dmpl__QuoteLine__c> newEntries, List<dmpl__QuoteLine__c> oldEntries)
    {
        try {
            if(isInsert){
                TaxHelper.createLinesTaxes(
                    isInsert, 
                    newEntries);
                PackageHelper.populatePackageItems(newEntries);
            }else if(isUpdate){
                List<dmpl__QuoteLine__c> modifiedObjects = DocumentHelper.getModifiedNewObjects(new string[]{FIELD_QUOTELINE_TAXGROUPID,FIELD_QUOTELINE_ITEMID, FIELD_QUOTELINE_SKUID,FIELD_QUOTELINE_AMOUNT}, oldEntries, newEntries);
                if(modifiedObjects.size()>0){
                    TaxHelper.createLinesTaxes(
                    isInsert, 
                    modifiedObjects);
                }
            }else if(isDelete){
                //ServiceEstimateTaxHelper.deleteApplicableTaxes(oldEntries);
                TaxHelper.deleteLinesTaxes(oldEntries);
            }  
        } catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
        
    }

    public static void createQuoteLinesFromServiceRequest(List<dmpl__Quote__c> modifiedObjects)
    {
        Map<ID, dmpl__ServiceRequest__c> serviceRequests = new Map<ID, dmpl__ServiceRequest__c>(queryServiceRequests(DocumentHelper.extractIds(modifiedObjects, FIELD_QUOTE_SERVICEREQUESTID)));
        List<dmpl__QuoteLine__c> newServiceEstimateLines = new List<dmpl__QuoteLine__c>();
        for(dmpl__Quote__c lineEntry : modifiedObjects){
            dmpl__ServiceRequest__c serviceRequest = serviceRequests.get(lineEntry.dmpl__ServiceRequestId__c);
            if(serviceRequest != null){
                for(dmpl__ServiceRequestLine__c serviceRequestLine : serviceRequest.ServiceAppointmentLines__r){
                    if(lineEntry.dmpl__ItemServiceContractId__c != serviceRequestLine.dmpl__ItemServiceContractId__c){
                        continue;
                    }
                    newServiceEstimateLines.Add(new dmpl__QuoteLine__c(
                        dmpl__QuoteId__c = lineEntry.ID,
                        dmpl__ServiceRequestLineId__c = serviceRequestLine.ID,
                        dmpl__DurationInHours__c = serviceRequestLine.dmpl__DurationInHours__c,
                        dmpl__ItemId__c = serviceRequestLine.dmpl__ItemId__c,
                        dmpl__SKUId__c = serviceRequestLine.dmpl__SKUId__c,
                        dmpl__Quantity__c = serviceRequestLine.dmpl__Quantity__c,
                        dmpl__UnitPrice__c = serviceRequestLine.dmpl__UnitPrice__c,
                        dmpl__PackageClassification__c = serviceRequestLine.dmpl__PackageClassification__c,
                        dmpl__IsPackageService__c = serviceRequestLine.dmpl__IsPackageService__c,
                        dmpl__TaxGroupId__c = serviceRequestLine.dmpl__TaxGroupId__c,
                        dmpl__ItemServiceContractId__c = serviceRequestLine.dmpl__ItemServiceContractId__c,
                        dmpl__ServiceContractId__c = serviceRequestLine.dmpl__ServiceContractItemId__c,
                        dmpl__PostingType__c = serviceRequestLine.dmpl__PostingType__c,
                        dmpl__ServiceRecommendationId__c = serviceRequestLine.dmpl__ServiceRecommendationId__c,
                        dmpl__AssetServiceContractLineId__c = serviceRequestLine.dmpl__AssetServiceContractLineId__c,
                        dmpl__Discount__c = serviceRequestLine.dmpl__Discount__c,
                        dmpl__DiscountAmount__c = serviceRequestLine.dmpl__DiscountAmount__c,
                        dmpl__Discount2__c = serviceRequestLine.dmpl__Discount2__c,
                        dmpl__DiscountAmount2__c = serviceRequestLine.dmpl__DiscountAmount2__c,
                        dmpl__ContractDiscount__c = serviceRequestLine.dmpl__ContractDiscount__c,
                        dmpl__ContractDiscountAmount__c = serviceRequestLine.dmpl__ContractDiscountAmount__c
                    ));
                }
            }
        }
        
        if(newServiceEstimateLines.size() > 0)
        {
            try{
                skipValidations = true;
                SecurityHelper.ensureCanCreateObject(OBJECT_QUOTELINE);
                SecurityHelper.ensureCanWriteFields(new List<String>{
                    'dmpl__ServiceRequestLineId__c',
                    'dmpl__DurationInHours__c',
                    'dmpl__ItemId__c',
                    'dmpl__SKUId__c',
                    'dmpl__Quantity__c',
                    'dmpl__UnitPrice__c',
                    'dmpl__PackageClassification__c',
                    'dmpl__IsPackageService__c',
                    'dmpl__TaxGroupId__c',
                    'dmpl__ItemServiceContractId__c',
                    'dmpl__ServiceContractId__c',
                    'dmpl__PostingType__c',
                    'dmpl__ServiceRecommendationId__c',
                    'dmpl__AssetServiceContractLineId__c'
                }, OBJECT_QUOTELINE);
                insert newServiceEstimateLines;
            } catch(Exception error){
                ExceptionLogHelper.logException(error);
                throw error;
            } finally {
                skipValidations = false;
            }
        }
    }

    public static void createQuoteLinesFromRepairOrder(List<dmpl__Quote__c> modifiedObjects)
    {
        Map<ID, dmpl__RepairOrder__c> repairOrders = new Map<ID, dmpl__RepairOrder__c>(
            queryRepairOrders(
                DocumentHelper.extractIds(
                    modifiedObjects, 
                    'dmpl__RepairOrderId__c')));
        List<dmpl__QuoteLine__c> newServiceEstimateLines = new List<dmpl__QuoteLine__c>();
        for(dmpl__Quote__c lineEntry : modifiedObjects){
            dmpl__RepairOrder__c repairOrder = repairOrders.get(lineEntry.dmpl__RepairOrderId__c);
            if(repairOrder != null){
                for(dmpl__RepairOrderLine__c repairOrderLine : repairOrder.Repair_Order_lines1__r){
                    if(lineEntry.dmpl__ItemServiceContractId__c != repairOrderLine.dmpl__ItemServiceContractId__c){
                        continue;
                    }
                    newServiceEstimateLines.Add(new dmpl__QuoteLine__c(
                        dmpl__QuoteId__c = lineEntry.ID,
                        dmpl__RepairOrderLineId__c = repairOrderLine.ID,
                        dmpl__DurationInHours__c = repairOrderLine.dmpl__StandardDurationHours__c,
                        dmpl__ItemId__c = repairOrderLine.dmpl__ItemId__c,
                        dmpl__SKUId__c = repairOrderLine.dmpl__SKUId__c,
                        dmpl__Quantity__c = repairOrderLine.dmpl__Quantity__c,
                        dmpl__UnitPrice__c = repairOrderLine.dmpl__UnitPrice__c,
                        dmpl__PackageClassification__c = repairOrderLine.dmpl__PackageClassification__c,
                        dmpl__IsPackageService__c = repairOrderLine.dmpl__IsPackageService__c,
                        dmpl__TaxGroupId__c = repairOrderLine.dmpl__TaxGroupId__c,
                        dmpl__ItemServiceContractId__c = repairOrderLine.dmpl__ItemServiceContractId__c,
                        dmpl__ServiceContractId__c = repairOrderLine.dmpl__ServiceContractItemId__c,
                        dmpl__PostingType__c = repairOrderLine.dmpl__PostingType__c,
                        dmpl__ServiceRecommendationId__c = repairOrderLine.dmpl__ServiceRecommendationId__c,
                        dmpl__AssetServiceContractLineId__c = repairOrderLine.dmpl__AssetServiceContractLineId__c,
                        dmpl__Discount__c = repairOrderLine.dmpl__Discount__c,
                        dmpl__DiscountAmount__c = repairOrderLine.dmpl__DiscountAmount__c,
                        dmpl__Discount2__c = repairOrderLine.dmpl__Discount2__c,
                        dmpl__DiscountAmount2__c = repairOrderLine.dmpl__DiscountAmount2__c,
                        dmpl__ContractDiscount__c = repairOrderLine.dmpl__ContractDiscount__c,
                        dmpl__ContractDiscountAmount__c = repairOrderLine.dmpl__ContractDiscountAmount__c
                    ));
                }
            }
        }
        
        if(newServiceEstimateLines.size() > 0)
        {
            try{
                skipValidations = true;
                SecurityHelper.ensureCanCreateObject(OBJECT_QUOTELINE);
                SecurityHelper.ensureCanWriteFields(new List<String>{
                    'dmpl__ServiceRequestLineId__c',
                    'dmpl__DurationInHours__c',
                    'dmpl__ItemId__c',
                    'dmpl__SKUId__c',
                    'dmpl__Quantity__c',
                    'dmpl__UnitPrice__c',
                    'dmpl__PackageClassification__c',
                    'dmpl__IsPackageService__c',
                    'dmpl__TaxGroupId__c',
                    'dmpl__ItemServiceContractId__c',
                    'dmpl__ServiceContractId__c',
                    'dmpl__PostingType__c',
                    'dmpl__ServiceRecommendationId__c',
                    'dmpl__AssetServiceContractLineId__c'
                }, OBJECT_QUOTELINE);
                insert newServiceEstimateLines;
            } catch(Exception error){
                ExceptionLogHelper.logException(error);
                throw error;
            } finally {
                skipValidations = false;
            }
        }
    }

    public static void createServiceEstimateLinesFromContract(List<dmpl__Quote__c> modifiedObjects)
    {
        List<dmpl__QuoteLine__c> newServiceEstimateLines = new List<dmpl__QuoteLine__c>();
        List<dmpl__AssetServiceContract__c> assetServiceContracts = queryAssetServiceContracts(DocumentHelper.extractIds(modifiedObjects, 'dmpl__AssetId__c'));
        for(dmpl__Quote__c serviceEstimate : modifiedObjects){
            List<dmpl__AssetServiceContract__c> currentAssetServiceContracts = getEligibleAssetServiceContracts(assetServiceContracts, serviceEstimate);
            if(currentAssetServiceContracts.size() > 0)
            {
                for(dmpl__AssetServiceContract__c currentAssetServiceContract : currentAssetServiceContracts)
                {
                    for(dmpl__AssetServiceContractLine__c currentAssetServiceContractLine : currentAssetServiceContract.AssetServiceContractLines__r)
                    {
                        newServiceEstimateLines.add(new dmpl__QuoteLine__c(
                            dmpl__QuoteId__c = serviceEstimate.Id,
                            dmpl__ItemId__c = currentAssetServiceContractLine.dmpl__ComponentItemId__c,
                            dmpl__Quantity__c = currentAssetServiceContractLine.dmpl__PendingQuantity__c,
                            dmpl__PostingType__c = currentAssetServiceContract.dmpl__PostingType__c,
                            dmpl__ItemServiceContractId__c = currentAssetServiceContract.dmpl__ItemServiceContractId__c,
                            dmpl__ServiceContractId__c = currentAssetServiceContract.dmpl__ServiceContractItemId__c,
                            dmpl__AssetServiceContractLineId__c = currentAssetServiceContractLine.Id
                        ));
                    }
                }
            }
        }

        if(newServiceEstimateLines.size() > 0)
        {
            try{
                skipValidations = true;
                SecurityHelper.ensureCanCreateObject(OBJECT_QUOTELINE);
                SecurityHelper.ensureCanWriteFields(new List<String>{
                    'dmpl__QuoteId__c',
                    'dmpl__ItemId__c',
                    'dmpl__Quantity__c',
                    'dmpl__PostingType__c',
                    'dmpl__ItemServiceContractId__c',
                    'dmpl__ServiceContractItemId__c',
                    'dmpl__AssetServiceContractLineId__c'
                }, OBJECT_QUOTELINE);
                insert newServiceEstimateLines;
            } catch(Exception error){
                ExceptionLogHelper.logException(error);
                throw error;
            } finally {
                skipValidations = false;
            }
        }
    }

    public static void approveServiceEstimateLines(List<dmpl__Quote__c> serviceEstimates)
    {
        approveServiceEstimateLines(queryServiceEstimateLines(DocumentHelper.extractIds(serviceEstimates)));
    }

    public static void declineServiceEstimateLines(List<dmpl__Quote__c> serviceEstimates)
    {
        declineServiceEstimateLines(queryServiceEstimateLines(DocumentHelper.extractIds(serviceEstimates)));
    }

    public static void applyPackageConfiguration(
        dmpl__QuoteLine__c packageQuoteLine, 
        List<dmpl__QuoteLine__c> existingLines, 
        List<dmpl__ItemComponent__c> components)
    {
        
        List<dmpl__QuoteLine__c> orderLinesToCreate = new List<dmpl__QuoteLine__c>();
        List<dmpl__QuoteLine__c> orderLinesToUpdate = new List<dmpl__QuoteLine__c>();
        List<dmpl__QuoteLine__c> orderLinesToDelete = new List<dmpl__QuoteLine__c>();
        if(packageQuoteLine == null){
            throw new DMPLException(
                String.format(
                    String.valueOf(System.Label.Generic_MissingObject), 
                    new String[]{dmpl__Quote__c.class.getName()}));
        }
        for(dmpl__ItemComponent__c component : components){
            dmpl__QuoteLine__c exisitngLine = (dmpl__QuoteLine__c)CollectionHelper.getObject(
                existingLines, 
                'dmpl__ItemComponentId__c', 
                component.Id);
            if(exisitngLine == null){
                orderLinesToCreate.add(
                    createQuoteLine(
                        packageQuoteLine, 
                        component));
            }else if(component.dmpl__IsQuantityEditable__c){
                Decimal quantity = PackageHelper.getDefaultComponentQuantity(packageQuoteLine.dmpl__Quantity__c, component);
                if(exisitngLine.dmpl__Quantity__c != quantity){
                    exisitngLine.dmpl__Quantity__c = component.dmpl__Quantity__c;
                    orderLinesToUpdate.add(exisitngLine);
                }
            }
        }

        for(dmpl__QuoteLine__c line : existingLines){
            if(line.Id != packageQuoteLine.Id 
            && CollectionHelper.getObject(
                components, 
                line.dmpl__ItemComponentId__c) == null){
                orderLinesToDelete.add(line);
            }
        }

        if(orderLinesToCreate.size()>0){
            SecurityHelper.ensureCanCreateObject('dmpl__QuoteLine__c');
            SecurityHelper.ensureCanCreateFields(new List<String>{
                'dmpl__ItemId__c',
                'dmpl__SKUId__c',
                //'dmpl__PackageQuoteLineId__c',
                'dmpl__Quantity__c',
                'dmpl__QuoteId__c'    
            }, 'dmpl__QuoteLine__c');
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
                'dmpl__PackageQuoteLineId__c',
                'dmpl__Quantity__c'
            }, 'dmpl__QuoteLine__c');
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
           SecurityHelper.ensureCanDeleteObject(
            'dmpl__QuoteLine__c');
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

    public static void addPackageQuoteLines(Map<dmpl__QuoteLine__c, List<dmpl__ItemComponent__c>> packageLines){
        List<dmpl__QuoteLine__c> quoteLinesToCreate = new List<dmpl__QuoteLine__c>();
        for(dmpl__QuoteLine__c line : packageLines.keySet()){
            List<dmpl__ItemComponent__c> components = packageLines.get(line);
            for(dmpl__ItemComponent__c component : components){
                quoteLinesToCreate.add(
                    createQuoteLine(
                        line, 
                        component));
            }
        }

        if(quoteLinesToCreate.size()>0){
            SecurityHelper.ensureCanCreateObject('dmpl__QuoteLine__c');
            SecurityHelper.ensureCanCreateFields(new List<String>{
                'dmpl__ItemId__c',
                'dmpl__SKUId__c',
                'dmpl__PackageQuoteLineId__c',
                'dmpl__Quantity__c'
            }, 'dmpl__QuoteLine__c');
            try {
                skipValidations = true;
                skipComponentAddValidation = true;
                insert quoteLinesToCreate;
            } finally {
                skipValidations = false;
                skipComponentAddValidation = false;
            }
        }
    }

    public static void performReprice(Id serviceEstimateId){
        performReprice(new List<Id>{serviceEstimateId});
    }

    public static void performReprice(List<Id> serviceEstimateIds){
        List<dmpl__Quote__c> serviceEstimates = queryServiceEstimates(
            serviceEstimateIds);
        List<dmpl__QuoteLine__c> serviceEstimatLines = queryServiceEstimateLinesOfServiceEstimates(
            CollectionHelper.extractIds(
                serviceEstimates));
        Map<Id, dmpl__Item__c> items = new Map<Id,dmpl__Item__c>(
            ItemHelper.getCachedItems(
                DocumentHelper.extractIds(
                    serviceEstimatLines, 
                    FIELD_QUOTELINE_ITEMID)));

        PriceListHelper.setApplicablePrices(
            serviceEstimatLines, 
            serviceEstimates, 
            items.values(),
            true);
        update serviceEstimatLines;
    }

    @testVisible
    private static dmpl__QuoteLine__c createQuoteLine(
        dmpl__QuoteLine__c packageLine, 
        dmpl__ItemComponent__c component){
        return new dmpl__QuoteLine__c(
            dmpl__ItemComponentId__c = component.Id,    
            dmpl__ItemId__c = component.dmpl__ComponentItemId__c,
            dmpl__SKUId__c = component.dmpl__ComponentSKUId__c,
            dmpl__PackageQuoteLineId__c = packageLine.Id,
            dmpl__Quantity__c = PackageHelper.getDefaultComponentQuantity(
                packageLine.dmpl__Quantity__c, 
                component),
            dmpl__QuoteId__c =  packageLine.dmpl__QuoteId__c,
            dmpl__IsPriceBundled__c = component.dmpl__IsBundled__c
        );
    }
    private static void approveServiceEstimateLines(List<dmpl__QuoteLine__c> serviceEstimateLines)
    {
        for(dmpl__QuoteLine__c serviceEstimateLine : serviceEstimateLines){
            serviceEstimateLine.dmpl__IsApproved__c = true;
            serviceEstimateLine.dmpl__IsDeclined__c = false;
        }

        try{
            skipValidations = true;
            SecurityHelper.ensureCanCreateObject(OBJECT_QUOTELINE);
            SecurityHelper.ensureCanWriteFields(new List<String>{
                'dmpl__IsApproved__c',
                'dmpl__IsDeclined__c'
            }, OBJECT_QUOTELINE);
            update serviceEstimateLines;
        } catch(Exception error){
            ExceptionLogHelper.logException(error);
            throw error;
        } finally {
            skipValidations = false;
        }
    }


    private static void setQuoteDiscount(List<dmpl__QuoteLine__c> newEntries){
        for(dmpl__QuoteLine__c lineEntry : newEntries){
            if(lineEntry.dmpl__QuoteDiscount__c != null 
                && lineEntry.dmpl__QuoteDiscount__c >0){
                lineEntry.dmpl__Discount__c = (lineEntry.dmpl__QuoteDiscount__c/100);
            }
        }            
    }

    private static void updateDiscount(List<dmpl__QuoteLine__c> newEntries){
        for(dmpl__QuoteLine__c lineEntry : newEntries){
            if(lineEntry.dmpl__DiscountAmount__c > 0){
                lineEntry.dmpl__Discount__c = 0;
            }
        }
    }

    private static void declineServiceEstimateLines(List<dmpl__QuoteLine__c> serviceEstimateLines)
    {
        for(dmpl__QuoteLine__c serviceEstimateLine : serviceEstimateLines){
            serviceEstimateLine.dmpl__IsApproved__c = false;
            serviceEstimateLine.dmpl__IsDeclined__c = true;
        }

        try{
            skipValidations = true;
            SecurityHelper.ensureCanCreateObject(OBJECT_QUOTELINE);
            SecurityHelper.ensureCanWriteFields(new List<String>{
                'dmpl__IsApproved__c',
                'dmpl__IsDeclined__c'
            }, OBJECT_QUOTELINE);
            update serviceEstimateLines;
        } catch(Exception error){
            ExceptionLogHelper.logException(error);
            throw error;
        } finally {
            skipValidations = false;
        }
    }

    private static void deletePackageItems(List<dmpl__QuoteLine__c> oldEntries){
        SecurityHelper.ensureCanReadField('Id', 'dmpl__SaleOrderLine__c');
        List<dmpl__QuoteLine__c> linesToDelte = [SELECT Id 
            FROM dmpl__QuoteLine__c 
            WHERE dmpl__PackageQuoteLineId__c IN:CollectionHelper.extractIds(oldEntries)];

        try {
            skipComponentDeleteValidation = true;
            if(linesToDelte.size()>0){
                SecurityHelper.ensureCanDeleteObject('dmpl__QuoteLine__c');
                delete linesToDelte;
            }        
        } finally {
            skipComponentDeleteValidation = false;
        }
    }

    private static List<dmpl__QuoteLine__c> queryQuoteLines(
        List<ID> quoteLineIds){
        SecurityHelper.ensureCanReadFields(new List<String>
        {
            'Name', 
            'dmpl__ItemId__c',
            'dmpl__SKUId__c',
            'dmpl__Quantity__c'
        },'dmpl__QuoteLine__c');
        return [ SELECT ID, 
            Name, 
            dmpl__ItemId__c,
            dmpl__SKUId__c,
            dmpl__Quantity__c
        FROM dmpl__QuoteLine__c
        WHERE ID IN : quoteLineIds];
    }

    private static List<dmpl__ServiceRequest__c> queryServiceRequests(List<ID> serviceRequestIds)
    {
        SecurityHelper.ensureCanReadFields(new List<string>{
            'dmpl__DurationInHours__c',
            'dmpl__ItemId__c',
            'dmpl__SKUId__c',
            'dmpl__Quantity__c',
            'dmpl__UnitPrice__c',
            'dmpl__UnitPrice2__c',
            'dmpl__PackageClassification__c',
            'dmpl__IsPackageService__c',
            'dmpl__TaxGroupId__c',
            'dmpl__ItemServiceContractId__c',
            'dmpl__ServiceContractItemId__c',
            'dmpl__PostingType__c',
            'dmpl__ServiceRecommendationId__c',
            'dmpl__AssetServiceContractLineId__c'
            }, 'dmpl__ServiceRequestLine__c');
        return [SELECT ID,
        Name,
        (
            SELECT ID, 
            dmpl__DurationInHours__c,
            dmpl__ItemId__c,
            dmpl__SKUId__c,
            dmpl__Quantity__c,
            dmpl__UnitPrice__c,
            dmpl__UnitPrice2__c,
            dmpl__PackageClassification__c,
            dmpl__IsPackageService__c,
            dmpl__TaxGroupId__c,
            dmpl__ItemServiceContractId__c,
            dmpl__ServiceContractItemId__c,
            dmpl__PostingType__c,
            dmpl__ServiceRecommendationId__c,
            dmpl__AssetServiceContractLineId__c,
            dmpl__Discount__c,
            dmpl__DiscountAmount__c,
            dmpl__Discount2__c,
            dmpl__DiscountAmount2__c,
            dmpl__ContractDiscount__c,
            dmpl__ContractDiscountAmount__c
            FROM ServiceAppointmentLines__r
        )
        FROM dmpl__ServiceRequest__c
        WHERE ID IN : serviceRequestIds];
    }

    private static List<dmpl__RepairOrder__c> queryRepairOrders(List<ID> repairOrderIds)
    {
        return [SELECT ID,
        Name,
        (
            SELECT ID, 
                dmpl__StandardDurationHours__c,
                dmpl__ItemId__c,
                dmpl__SKUId__c,
                dmpl__Quantity__c,
                dmpl__UnitPrice__c,
                dmpl__UnitPrice2__c,
                dmpl__PackageClassification__c,
                dmpl__IsPackageService__c,
                dmpl__TaxGroupId__c,
                dmpl__ItemServiceContractId__c,
                dmpl__ServiceContractItemId__c,
                dmpl__PostingType__c,
                dmpl__ServiceRecommendationId__c,
                dmpl__AssetServiceContractLineId__c,
                dmpl__Discount__c,
                dmpl__DiscountAmount__c,
                dmpl__Discount2__c,
                dmpl__DiscountAmount2__c,
                dmpl__ContractDiscount__c,
                dmpl__ContractDiscountAmount__c
            FROM Repair_Order_lines1__r
            WHERE 
                dmpl__QuoteLineId__c = null
        )
        FROM dmpl__RepairOrder__c
        WHERE ID IN : repairOrderIds];
    }

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
        AND dmpl__PopulateContractLines__c = true];
    }

    private static List<dmpl__AssetServiceContract__c> getEligibleAssetServiceContracts(List<dmpl__AssetServiceContract__c> assetServiceContracts, dmpl__Quote__c serviceEstimate)
    {
        List<dmpl__AssetServiceContract__c> currentAssetServiceContracts = (List<dmpl__AssetServiceContract__c>)DocumentHelper.getObjectsByFilter(assetServiceContracts, 'dmpl__AssetId__c', serviceEstimate.dmpl__AssetId__c);
        currentAssetServiceContracts = (List<dmpl__AssetServiceContract__c>)DocumentHelper.getObjectsByFilter(currentAssetServiceContracts, 'dmpl__ServiceContractItemId__c', serviceEstimate.dmpl__ServiceContractItemId__c);
        currentAssetServiceContracts = (List<dmpl__AssetServiceContract__c>)DocumentHelper.getObjectsByFilter(currentAssetServiceContracts, 'dmpl__IsValid__c', true);
        return currentAssetServiceContracts;
    }

    private static List<dmpl__QuoteLine__c> queryServiceEstimateLines(List<ID> serviceEstimateIds)
    {
        SecurityHelper.ensureCanReadFields(new List<string>{'dmpl__IsApproved__c','dmpl__IsDeclined__c','dmpl__QuoteId__c'}, 'dmpl__QuoteLine__c');
        return [SELECT ID,
        Name,
        dmpl__IsApproved__c,
        dmpl__IsDeclined__c
        FROM dmpl__QuoteLine__c
        WHERE dmpl__QuoteId__c IN : serviceEstimateIds];
    }
    
    private static List<dmpl__QuoteLine__c> queryServiceEstimateLinesOfServiceEstimates(
        List<ID> quoteIds){
        SecurityHelper.ensureCanReadFields(new List<String>
        {
            'Name', 
            'dmpl__ItemId__c',
            'dmpl__SKUId__c',
            'dmpl__PriceListId__c',
            'dmpl__Quantity__c',
            'dmpl__UnitPrice__c',
            'dmpl__UnitPrice2__c',
            'dmpl__TaxGroupId__c',
            'dmpl__ItemLotTypeId__c',
            'dmpl__TaxAmount__c',
            'dmpl__QuoteId__c'
        },'dmpl__QuoteLine__c');
        return [ SELECT ID, 
            Name, 
            dmpl__ItemId__c,
            dmpl__SKUId__c,
            dmpl__Quantity__c,
            dmpl__UnitPrice__c,
            dmpl__UnitPrice2__c,
            dmpl__TaxGroupId__c,
            dmpl__PriceListId__c,    
            dmpl__ItemLotTypeId__c,
            dmpl__TaxAmount__c,
            dmpl__QuoteId__c,
            dmpl__PriceAsOnDate__c
        FROM dmpl__QuoteLine__c
        WHERE dmpl__QuoteId__c IN : quoteIds];
    }  

    private static void setItemData(List<dmpl__QuoteLine__c> newEntries)
    {
        Map<Id, dmpl__Item__c> items = new Map<Id,dmpl__Item__c>(
        ItemHelper.getCachedItems(DocumentHelper.extractIds(newEntries, FIELD_QUOTELINE_ITEMID)));
        List<dmpl__Quote__c> serviceEstimates = queryServiceEstimates(DocumentHelper.extractIds(newEntries, FIELD_QUOTELINE_QUOTEID));
        setAlternateItem(newEntries, items);
        TaxGroupHelper.setApplicableTaxGroups(newEntries, serviceEstimates, items.values());
        PriceListHelper.setApplicablePrices(
            newEntries, 
            serviceEstimates, 
            items.values(),
            false);
        DiscountGroupHelper.setApplicableDiscounts(newEntries, serviceEstimates, items.values());
        setStandardDuration(newEntries, items);
    }

    private static void setStandardDuration(List<dmpl__QuoteLine__c> newEntries, Map<Id, dmpl__Item__c> items){
        for(dmpl__QuoteLine__c lineEntry : newEntries){
            dmpl__Item__c currentItem =  items.get(lineEntry.dmpl__ItemId__c);
            if(currentItem != null){
                lineEntry.dmpl__DurationInHours__c = currentItem.dmpl__ServiceDurationInMinutes__c > 0 ? currentItem.dmpl__ServiceDurationInMinutes__c/60 : 0;
            }
        }
    }

    private static List<dmpl__Quote__c> queryServiceEstimates(List<Id> serviceEstimateIds)
    {
        SecurityHelper.ensureCanReadFields(new string[]
        {
            'dmpl__PartnerAccountId__c',
            'dmpl__DocumentDate__c',
            'dmpl__BranchId__c',  
            'dmpl__PriceListId__c',
            'dmpl__AccountId__c',
            'dmpl__TaxSupplyType__c',
            'dmpl__DiscountGroupId__c',
            'dmpl__PriceAsOnDate__c',
            'dmpl__TCSEligibleAmount__c'
        }, 'dmpl__Quote__c');
        return [SELECT Id,
        Name,
        dmpl__PartnerAccountId__c,
        dmpl__DocumentDate__c,
        dmpl__BranchId__c,  
        dmpl__PriceListId__c,
        dmpl__AccountId__c,
        dmpl__TaxSupplyType__c,
        dmpl__DiscountGroupId__c,
        dmpl__PriceAsOnDate__c,
        dmpl__TCSEligibleAmount__c
        FROM dmpl__Quote__c
        WHERE Id IN : serviceEstimateIds];
    }

    private static void setAlternateItem(List<dmpl__QuoteLine__c> newEntries, Map<Id, dmpl__Item__c> items)
    {
        for(dmpl__QuoteLine__c newEntry : newEntries)
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

        items = new Map<Id,dmpl__Item__c>(ItemHelper.getCachedItems(DocumentHelper.extractIds(newEntries, FIELD_QUOTELINE_ITEMID)));
    }
}