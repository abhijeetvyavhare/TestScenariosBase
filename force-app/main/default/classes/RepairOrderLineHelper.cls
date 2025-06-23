public with sharing class RepairOrderLineHelper 
{
    private static Boolean skipValidations = false;

    private static final string OBJECT_REPAIRORDER = 'dmpl__RepairOrder__c';
    private static final string OBJECT_REPAIRORDERLINE = 'dmpl__RepairOrderLine__c';

    private static final string FIELD_REPAIRORDERLINE_ACTIONTAKEN = 'dmpl__ActionTaken__c';
    private static final string FIELD_REPAIRORDERLINE_ACTUALDURATIONHOURS = 'dmpl__ActualDurationHours__c';
    private static final string FIELD_REPAIRORDERLINE_ALLOCATEDQUANTITY = 'dmpl__AllocatedQuantity__c';
    private static final string FIELD_REPAIRORDERLINE_CANCELLEDQUANTITY = 'dmpl__CancelledQuantity__c';
    private static final string FIELD_REPAIRORDERLINE_QUANTITY = 'dmpl__Quantity__c';
    private static final string FIELD_REPAIRORDERLINE_COMPLAINTCODEID = 'dmpl__ComplaintCodeId__c';
    private static final string FIELD_REPAIRORDERLINE_COMPLAINTFAULTCODEID = 'dmpl__ComplaintFaultCodeId__c';
    private static final string FIELD_REPAIRORDERLINE_INCLUDEDINPACKAGE = 'dmpl__IncludedInPackage__c';
    private static final string FIELD_REPAIRORDERLINE_ISINVOICED = 'dmpl__IsInvoiced__c';
    private static final string FIELD_REPAIRORDERLINE_ISPACKAGESERVICE = 'dmpl__IsPackageService__c';
    private static final string FIELD_REPAIRORDERLINE_ITEMID = 'dmpl__ItemId__c';
    private static final string FIELD_REPAIRORDERLINE_SKUID = 'dmpl__SKUId__c';
    private static final string FIELD_REPAIRORDERLINE_TAXGROUPID = 'dmpl__TaxGroupId__c';
    private static final string FIELD_REPAIRORDERLINE_AMOUNT = 'dmpl__Amount__c';
    private static final string FIELD_REPAIRORDERLINE_PACKAGECLASSIFICATION = 'dmpl__PackageClassification__c';
    private static final string FIELD_REPAIRORDERLINE_REPAIRORDERID = 'dmpl__RepairOrderId__c';

    private static final string FIELD_AGG_REPAIRORDERLINEID = 'RepairOrderLineId';
    private static final string FIELD_AGG_TOTALQTY = 'TotalQuantity';

    private static final string FIELDNAME_REPAIRORDERLINE_PRICELISTRULEID = 'dmpl__PriceListRuleId__c';
    private static final string FIELD_REPAIRORDER_SERVICEESTIMATEID = 'dmpl__ServiceEstimateId__c';
    private static final string FIELD_REPAIRORDER_SERVICEREQUESTID = 'dmpl__ServiceRequestId__c';
    private static final string FIELD_REPAIRORDER_SERVICECONTRACTITEMID = 'dmpl__ServiceContractItemId__c';
    private static final string FIELD_REPAIRORDER_ITEMSERVICEONTRACTID = 'dmpl__ItemServiceContractId__c';
    private static final string FIELD_REPAIRORDER_ASSETID = 'dmpl__AssetId__c';

    private static final string RELATION_REPAIRORDER_STATUS = 'dmpl__RepairOrder__r.dmpl__Status__c';
    
    private static final string FIELD_REPAIRORDERLINE_CONTRACTDISCOUNT = 'dmpl__ContractDiscount__c';
    private static final string FIELD_REPAIRORDERLINE_DISCOUNT = 'dmpl__Discount__c';
    private static final string FIELD_REPAIRORDERLINE_DISCOUNT2 = 'dmpl__Discount2__c';
    private static final string FIELD_REPAIRORDERLINE_SCHEMEDISCOUNT = 'dmpl__SchemeDiscount__c';

    private static final List<String> LIST_FIELDS_NONEDITABLE = new List<String>{
        FIELD_REPAIRORDERLINE_REPAIRORDERID
    };
    private static final List<String> LIST_FIELDS_SYSTEM = new List<String>{
        FIELD_REPAIRORDERLINE_ALLOCATEDQUANTITY,
        'dmpl__InventoryLedgerId__c', 
        'dmpl__IsILPosted__c',
        'dmpl__IsILPostingApproved__c'
    };
    private static final List<String> LIST_FIELDS_SOURCEPOULATED = new List<String>{
        FIELD_REPAIRORDERLINE_ACTUALDURATIONHOURS, 
        FIELD_REPAIRORDERLINE_PACKAGECLASSIFICATION
    };
    private static final List<String> LIST_FIELDS_LOCKEDIFTRANSACTED = new List<String>{
        FIELD_REPAIRORDERLINE_ITEMID
    };

    private static final List<String> LIST_FIELDS_NEGATIVENOTALLOWED = new List<String>{
        'dmpl__AllocatedInvoicedQuantity__c', 
        'dmpl__AllocatedQuantity__c', 
        'dmpl__CancelledQuantity__c', 
        'dmpl__ClaimableQuantity__c', 
        'dmpl__ClaimedQuantity__c', 
        'dmpl__DeliveryQuantity__c', 
        'dmpl__dmpl_PendingInvoiceQuantity__c', 
        'dmpl__FailedItemDeliveredQuantity__c', 
        'dmpl__FulfilmentOrderQuantity__c', 
        'dmpl__Quantity__c'
    };

    private static final List<String> LIST_FIELDS_NEGATIVEANDZERONOTALLOWED = new List<String>{

    };

    private static final List<String> LIST_FIELDS_PERCENT = new List<String>{
        FIELD_REPAIRORDERLINE_CONTRACTDISCOUNT,
        FIELD_REPAIRORDERLINE_DISCOUNT,
        FIELD_REPAIRORDERLINE_DISCOUNT2,
        FIELD_REPAIRORDERLINE_SCHEMEDISCOUNT
    };

    public static void validateData(Boolean isInsert, Boolean isUpdate, Boolean isDelete, List<dmpl__RepairOrderLine__c> newEntries, List<dmpl__RepairOrderLine__c> oldEntries)
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
            if(isInsert){
                DocumentHelper.validateChangeInSystemFields(LIST_FIELDS_SYSTEM, newEntries);
                (new DocumentStatusDFSHelper()).DocumentStatusRelatedObjectRestrictEdits_New(OBJECT_REPAIRORDER, OBJECT_REPAIRORDERLINE, RELATION_REPAIRORDER_STATUS, newEntries);
                AssetServiceContractHelper.validateLineItemServiceContract(
                    newEntries, 
                    'dmpl__RepairOrder__c',
                    'dmpl__RepairOrderId__c');
            }else if(isUpdate){
                DocumentHelper.validateChangeInSystemFields(LIST_FIELDS_SYSTEM, oldEntries, newEntries);
                DocumentHelper.validateChangeInKeyFields(LIST_FIELDS_NONEDITABLE, oldEntries, newEntries);
                DocumentHelper.validateChangeInLockedIfTransactedFields(LIST_FIELDS_LOCKEDIFTRANSACTED, oldEntries, newEntries, FIELD_REPAIRORDERLINE_ALLOCATEDQUANTITY);
                (new DocumentStatusDFSHelper()).DocumentStatusRelatedObjectRestrictEdits_Edit(OBJECT_REPAIRORDER, OBJECT_REPAIRORDERLINE, RELATION_REPAIRORDER_STATUS, oldEntries, newEntries);
                validateCampaignLineUpdate(newEntries, oldEntries);
                AssetServiceContractHelper.validateLineItemServiceContract(
                    newEntries, 
                    'dmpl__RepairOrder__c',
                    'dmpl__RepairOrderId__c');
                
                List<dmpl__RepairOrderLine__c> modifiedObjects = DocumentHelper.getApprovedObjects(
                    'dmpl__IsILPostingApproved__c', 
                    oldEntries, 
                    newEntries);
                if(modifiedObjects.size()>0){
                    DocumentHelper.validateCanBePosted(modifiedObjects, 'dmpl__AllocatedQuantity__c');
                    DocumentHelper.validateCanBePosted(modifiedObjects, 'dmpl__OTCInvoicedQuantity__c');
                }
            }else if(isDelete){
                DocumentHelper.validateCanBeDeleted(oldEntries, FIELD_REPAIRORDERLINE_ALLOCATEDQUANTITY);
                (new DocumentStatusDFSHelper()).DocumentStatusRelatedObjectRestrictEdits_Delete(OBJECT_REPAIRORDER, OBJECT_REPAIRORDERLINE, RELATION_REPAIRORDER_STATUS, oldEntries);
                validateCampaignLineDelete(oldEntries);
            }
        } catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }

    public static void postData(Boolean isInsert, Boolean isUpdate, Boolean isDelete, List<dmpl__RepairOrderLine__c> newEntries, List<dmpl__RepairOrderLine__c> oldEntries)
    {
        if(isInsert){
            setItemData(newEntries);
            setRepairOrderDiscount(newEntries);
            TaxHelper.setLinesTaxes(
                newEntries);
        }
        else if(isUpdate){
            List<dmpl__RepairOrderLine__c> modifiedObjects = DocumentHelper.getModifiedNewObjects(FIELDNAME_REPAIRORDERLINE_PRICELISTRULEID, oldEntries, newEntries);
            if(modifiedObjects.size()>0){
                Map<Id, dmpl__Item__c> items = new Map<Id,dmpl__Item__c>(ItemHelper.getCachedItems(DocumentHelper.extractIds(modifiedObjects, FIELD_REPAIRORDERLINE_ITEMID)));
                List<dmpl__RepairOrder__c> repairOrderDocuments = queryRepairOrders(DocumentHelper.extractIds(modifiedObjects, FIELD_REPAIRORDERLINE_REPAIRORDERID));
                PriceListHelper.setApplicablePrices(modifiedObjects, repairOrderDocuments, items.values(), DocumentHelper.extractIds(modifiedObjects, FIELDNAME_REPAIRORDERLINE_PRICELISTRULEID),'dmpl__RepairOrderId__c');
            }

            modifiedObjects = DocumentHelper.getModifiedNewObjects(
                new List<String>{
                    'dmpl__PriceListId__c',
                    'dmpl__PriceAsOnDate__c'
                },
                oldEntries, 
                newEntries);
            if(modifiedObjects.size()>0){
                Map<Id, dmpl__Item__c> items = new Map<Id,dmpl__Item__c>(ItemHelper.getCachedItems(DocumentHelper.extractIds(modifiedObjects, FIELD_REPAIRORDERLINE_ITEMID)));
                List<dmpl__RepairOrder__c> repairOrderDocuments = queryRepairOrders(DocumentHelper.extractIds(modifiedObjects, FIELD_REPAIRORDERLINE_REPAIRORDERID));
                PriceListHelper.setApplicablePrices(modifiedObjects, repairOrderDocuments, items.values(), true);
            }

            updateDiscount(newEntries);
            modifiedObjects = DocumentHelper.getModifiedNewObjects(
                new string[]{
                    FIELD_REPAIRORDERLINE_TAXGROUPID,
                    FIELD_REPAIRORDERLINE_ITEMID, 
                    FIELD_REPAIRORDERLINE_SKUID,
                    FIELD_REPAIRORDERLINE_AMOUNT
                }, 
                oldEntries, 
                newEntries);
            if(modifiedObjects.size()>0){
                TaxHelper.setLinesTaxes(
                    newEntries);
            }
        }else if(isDelete){
            //RepairOrderTaxHelper.deleteApplicableTaxes(oldEntries);
        }

        List<dmpl__SaleOrderLine__c> modifiedObjects = DocumentHelper.getPostedObjects(
            'dmpl__IsILPostingApproved__c', 
            oldEntries, 
            newEntries);
        if(modifiedObjects.Size() > 0){
            InventoryLedgerHelper.createLedger(
                InventoryLedgerTypeEnums.SoftCommit, 
                FIELD_REPAIRORDERLINE_REPAIRORDERID, 
                OBJECT_REPAIRORDER, 
                isInsert, 
                isDelete, 
                isUpdate, 
                oldEntries, 
                newEntries);
        }
    }

    public static void afterPostData(
        Boolean isInsert, 
        Boolean isUpdate, 
        Boolean isDelete, 
        List<dmpl__RepairOrderLine__c> newEntries, 
        List<dmpl__RepairOrderLine__c> oldEntries){
        try {
            if(isInsert){
                //SchemeHelper.processLines(newEntries);
                TaxHelper.createLinesTaxes(
                    isInsert, 
                    newEntries);
            }else if(isUpdate){
                List<dmpl__RepairOrderLine__c> modifiedObjects = DocumentHelper.getModifiedNewObjects(
                    new string[]{
                        FIELD_REPAIRORDERLINE_TAXGROUPID,
                        FIELD_REPAIRORDERLINE_ITEMID, 
                        FIELD_REPAIRORDERLINE_SKUID,
                        FIELD_REPAIRORDERLINE_AMOUNT}, oldEntries, newEntries);
                if(modifiedObjects.size()>0){
                    TaxHelper.createLinesTaxes(
                    isInsert, 
                    modifiedObjects);
                }
                //SchemeHelper.processLines(newEntries);
            }else if(isDelete){
                TaxHelper.deleteLinesTaxes(oldEntries);
            }
        } catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }

    public static CreateRelatedResult postIL(Id repairOrderId){
        return postRepairOrderLines(
            queryRepairOrderLinesOfRepairOrders(
                new List<Id>{repairOrderId}));
    }

    public static CreateRelatedResult postIL(
        List<SourceObjectInfo> orderLinesInfo, 
        Id repairOrderId){
        return postRepairOrderLines(
            queryRepairOrderLines(
                SourceObjectInfo.extractIds(orderLinesInfo)));
    }

    public static void postRepairOrderLines(
        List<dmpl__RepairOrder__c> modifiedDocs){
        dmpl__CreateRelatedSetting__mdt setting = CreateRelatedSettingHelper.getCreateRelatedSettings(
            'dmpl__RepairOrder__c',
            'Post IL');
        if(setting == null){
            postRepairOrderLines(
                queryRepairOrderLinesOfRepairOrders(
                    DocumentHelper.extractIds(modifiedDocs)));
        }else {
            for(dmpl__RepairOrder__c repairOrder : modifiedDocs){
                DocumentSelectorController.releaseDocumentDirect(
                    setting.Id, 
                    repairOrder.Id);
            }
        }
    }

    public static CreateRelatedResult postRepairOrderLines(
        List<dmpl__RepairOrderLine__c> repairOrderLines){
        SecurityHelper.ensureCanWriteField(
            'dmpl__IsILPostingApproved__c', 
            'dmpl__RepairOrderLine__c');
        for(dmpl__RepairOrderLine__c repairOrderLine : repairOrderLines){
            repairOrderLine.dmpl__IsILPostingApproved__c = true;
        }

        try {
            skipValidations = true;
            SecurityHelper.ensureCanWriteFields(
                new string[]{
                    'dmpl__IsILPosted__c',
                    'dmpl__IsILPostingApproved__c'}, 
                'dmpl__RepairOrderLine__c');
            return CreateRelatedResult.InitFrom(
                Database.update(
                    repairOrderLines));            
        } finally {
            skipValidations = false;
        }
    }

    public static void createRepairOrderLinesFromRepairOrder(List<dmpl__RepairOrder__c> repairOrders)
    {
        List<dmpl__RepairOrder__c> sourceAsEstimate = DocumentHelper.getObjectsWithNotNull(repairOrders, FIELD_REPAIRORDER_SERVICEESTIMATEID);
        if(sourceAsEstimate.size() > 0)
            populateLinesFromServiceEstimate(sourceAsEstimate);

        List<dmpl__RepairOrder__c> sourceAsServiceRequest = DocumentHelper.getObjectsWithNotNull(repairOrders, FIELD_REPAIRORDER_SERVICEREQUESTID);
        if(sourceAsServiceRequest.size() > 0)
            populateLinesFromServiceRequest(sourceAsServiceRequest);
            
        List<dmpl__RepairOrder__c> sourceAsServiceContractItem = DocumentHelper.getObjectsWithNotNull(repairOrders, FIELD_REPAIRORDER_ITEMSERVICEONTRACTID);
        if(sourceAsServiceContractItem.size() > 0)
            populateLinesFromServiceContractItem(sourceAsServiceContractItem);
    }

    public static void updateAllocatedQuantity(List<Id> repairOrderLineIds)
    {
        try{
            skipValidations = true;
            SecurityHelper.ensureCanReadFields(new string[]{'dmpl__RepairOrderLineId__c','dmpl__AllocatedQuantity__c'}, 'dmpl__InventoryFulfillmentOrderLine__c');
            List<AggregateResult> ffAggregates = 
                [SELECT 
                    dmpl__RepairOrderLineId__c RepairOrderLineId, 
                    SUM(dmpl__Quantity__c) TotalQuantity, 
                    SUM(dmpl__AllocatedQuantity__c) TotalAllocatedQuantity
                FROM 
                    dmpl__InventoryFulfillmentOrderLine__c
                WHERE 
                    dmpl__RepairOrderLineId__c IN :repairOrderLineIds
                    AND 
                    dmpl__RepairOrderLineId__c != NULL
                WITH SECURITY_ENFORCED
                GROUP BY dmpl__RepairOrderLineId__c];
    
            SecurityHelper.ensureCanReadFields(new string[]{'dmpl__AllocatedQuantity__c'}, 'dmpl__RepairOrderLine__c');
            List<dmpl__RepairOrderLine__c> orderLinesToUpdate = 
                [SELECT Id, dmpl__AllocatedQuantity__c
                FROM dmpl__RepairOrderLine__c
                WHERE Id IN :repairOrderLineIds];
    
            for(dmpl__RepairOrderLine__c orderLine : orderLinesToUpdate){
                for(AggregateResult result : ffAggregates){
                    if(result.get('RepairOrderLineId') == orderLine.Id){
                        orderLine.dmpl__AllocatedQuantity__c = result.get('TotalAllocatedQuantity') == null ? 0 : (Decimal)(result.get('TotalAllocatedQuantity'));
                        break;
                    }
                }
            }
            SecurityHelper.ensureCanWriteFields(new string[]{'dmpl__AllocatedQuantity__c'}, 'dmpl__RepairOrderLine__c');
            if(orderLinesToUpdate.Size() > 0)
            	Update orderLinesToUpdate;
        }finally{
            skipValidations = false;
        }
    }

    // NEED TO TEST
    public static void updateFulfilmentOrderQuantity(List<Id> repairOrderLineIds)
    {
        try{
            skipValidations = true;
            SecurityHelper.ensureCanReadFields(new string[]{'dmpl__RepairOrderLineId__c','dmpl__Quantity__c'}, 'dmpl__InventoryFulfillmentOrderLine__c');
            List<AggregateResult> ffAggregates = 
                [SELECT 
                    dmpl__RepairOrderLineId__c RepairOrderLineId, 
                    SUM(dmpl__Quantity__c) TotalQuantity
                FROM 
                    dmpl__InventoryFulfillmentOrderLine__c
                WHERE 
                    dmpl__RepairOrderLineId__c IN :repairOrderLineIds
                WITH SECURITY_ENFORCED
                GROUP BY dmpl__RepairOrderLineId__c];
    
            SecurityHelper.ensureCanReadFields(new string[]{'dmpl__FulfilmentOrderQuantity__c'}, 'dmpl__RepairOrderLine__c');
            List<dmpl__RepairOrderLine__c> orderLinesToUpdate = 
                [SELECT Id, dmpl__FulfilmentOrderQuantity__c
                FROM dmpl__RepairOrderLine__c
                WHERE Id IN :repairOrderLineIds];
    
            for(dmpl__RepairOrderLine__c orderLine : orderLinesToUpdate){
                for(AggregateResult result : ffAggregates){
                    if(result.get('RepairOrderLineId') == orderLine.Id){
                        orderLine.dmpl__FulfilmentOrderQuantity__c = result.get('TotalQuantity') == null ? 0 : (Decimal)(result.get('TotalQuantity'));
                        break;
                    }
                }
            }
            SecurityHelper.ensureCanWriteFields(new string[]{'dmpl__FulfilmentOrderQuantity__c'}, 'dmpl__RepairOrderLine__c');
            if(orderLinesToUpdate.Size() > 0)
            	Update orderLinesToUpdate;
        }finally{
            skipValidations = false;
        }
    }

    public static void applyRecommendation(
        dmpl__ServiceRecommendation__c recomendation){
            dmpl__RepairOrderLine__c line = new dmpl__RepairOrderLine__c(
                        dmpl__RepairOrderId__c = recomendation.dmpl__RepairOrderId__c,
                        dmpl__ItemId__c = recomendation.dmpl__ItemId__c,
                        dmpl__Quantity__c = recomendation.dmpl__Quantity__c,
                        dmpl__ServiceRecommendationId__c = recomendation.Id);
            insert line;
        }

    public static void populateLinesFromServiceEstimate(List<dmpl__RepairOrder__c> sourceAsEstimate)
    {
        List<dmpl__RepairOrderLine__c> newRepairOrderLines = new List<dmpl__RepairOrderLine__c>();
        Map<ID, dmpl__Quote__c> serviceEstimates = new Map<ID, dmpl__Quote__c>(queryServiceEstimates(DocumentHelper.extractIds(sourceAsEstimate, FIELD_REPAIRORDER_SERVICEESTIMATEID)));
        
        for(dmpl__RepairOrder__c lineEntry : sourceAsEstimate)
        {
            dmpl__Quote__c currentServiceEstimate = serviceEstimates.get(lineEntry.dmpl__ServiceEstimateId__c);
            if(currentServiceEstimate != null)
            {
                for(dmpl__QuoteLine__c serviceEstimateLine : currentServiceEstimate.dmpl__QuoteLines__r)
                {
                    newRepairOrderLines.add(new dmpl__RepairOrderLine__c(
                        dmpl__RepairOrderId__c = lineEntry.Id,
                        dmpl__ItemId__c = serviceEstimateLine.dmpl__ItemId__c,
                        dmpl__Quantity__c = serviceEstimateLine.dmpl__Quantity__c,
                        dmpl__RecommendationType__c = serviceEstimateLine.dmpl__RecommendationType__c,
                        dmpl__TaxGroupId__c = serviceEstimateLine.dmpl__TaxGroupId__c,
                        dmpl__UnitPrice__c = serviceEstimateLine.dmpl__UnitPrice__c,
                        dmpl__UnitPrice2__c = serviceEstimateLine.dmpl__UnitPrice2__c,
                        dmpl__StandardDurationHours__c = serviceEstimateLine.dmpl__DurationInHours__c,
                        dmpl__SKUId__c = serviceEstimateLine.dmpl__SKUId__c,
                        dmpl__ItemServiceContractId__c = serviceEstimateLine.dmpl__ItemServiceContractId__c,
                        dmpl__ServiceContractItemId__c = serviceEstimateLine.dmpl__ServiceContractId__c,
                        dmpl__PostingType__c = serviceEstimateLine.dmpl__PostingType__c,
                        dmpl__ServiceRecommendationId__c = serviceEstimateLine.dmpl__ServiceRecommendationId__c,
                        dmpl__AssetServiceContractLineId__c = serviceEstimateLine.dmpl__AssetServiceContractLineId__c,
                        dmpl__QuoteLineId__c = serviceEstimateLine.Id,
                        dmpl__Discount__c = serviceEstimateLine.dmpl__Discount__c,
                        dmpl__DiscountAmount__c = serviceEstimateLine.dmpl__DiscountAmount__c,
                        dmpl__Discount2__c = serviceEstimateLine.dmpl__Discount2__c,
                        dmpl__DiscountAmount2__c = serviceEstimateLine.dmpl__DiscountAmount2__c,
                        dmpl__ContractDiscount__c = serviceEstimateLine.dmpl__ContractDiscount__c,
                        dmpl__ContractDiscountAmount__c = serviceEstimateLine.dmpl__ContractDiscountAmount__c
                    ));
                }
            }
        }

        if(newRepairOrderLines.size() > 0)
        {
            try{
                skipValidations = true;
                SecurityHelper.ensureCanWriteObject(OBJECT_REPAIRORDERLINE);
                SecurityHelper.ensureCanWriteFields(new List<string>{
                    'dmpl__ItemId__c',
                    'dmpl__Quantity__c',
                    'dmpl__RecommendationType__c',
                    'dmpl__TaxGroupId__c',
                    'dmpl__UnitPrice__c',
                    'dmpl__StandardDurationHours__c',
                    'dmpl__SKUId__c',
                    'dmpl__ItemServiceContractId__c',
                    'dmpl__ServiceContractItemId__c',
                    'dmpl__PostingType__c',
                    'dmpl__ServiceRecommendationId__c',
                    'dmpl__AssetServiceContractLineId__c'
                }, OBJECT_REPAIRORDERLINE);
                insert newRepairOrderLines; 
            } catch(Exception error){
                ExceptionLogHelper.logException(error);
                throw error;
            } finally {
                skipValidations = false;
            }
        }
    }

    public static void populateLinesForAssetMaintenance(
        List<dmpl__RepairOrder__c> repairOrders,
        Boolean manualAssetAction){
        List<dmpl__RepairOrderLine__c> newRepairOrderLines = new List<dmpl__RepairOrderLine__c>();
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
                    repairOrders, 
                    'dmpl__AssetId__c')];
        
        List<dmpl__RepairOrderLine__c> orderLines = [SELECT
            dmpl__AssetMaintenanceId__c
            FROM dmpl__RepairOrderLine__c
            WHERE dmpl__RepairOrderId__c IN :CollectionHelper.extractIds(repairOrders)];

        for(dmpl__RepairOrder__c order : repairOrders){
            List<dmpl__AssetMaintenance__c> assetItems = CollectionHelper.getObjects(
                assetMaintenanceItems,
                'dmpl__AssetId__c',
                order.dmpl__AssetId__c);
            for(dmpl__AssetMaintenance__c assetItem : assetItems){
                if(CollectionHelper.getObject(orderLines, 'dmpl__AssetMaintenanceId__c', assetItem.Id) != null){
                    continue;
                }
                newRepairOrderLines.add(new dmpl__RepairOrderLine__c(
                    dmpl__RepairOrderId__c = order.Id,
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

        if(newRepairOrderLines.size() > 0){
            try{
                skipValidations = true;
                SecurityHelper.ensureCanWriteObject(OBJECT_REPAIRORDERLINE);
                SecurityHelper.ensureCanWriteFields(new List<string>{
                    'dmpl__ItemId__c',
                    'dmpl__Quantity__c',
                    'dmpl__ItemServiceContractId__c',
                    'dmpl__ServiceCampaignId__c',
                    'dmpl__ServiceCampaignItemId__c',
                    'dmpl__IsServiceCampaignMandatory__c'
                }, OBJECT_REPAIRORDERLINE);
                insert newRepairOrderLines; 
            } catch(Exception error){
                ExceptionLogHelper.logException(error);
                throw error;
            } finally {
                skipValidations = false;
            }
        }
    }

    public static void populateLinesFromServiceRequest(List<dmpl__RepairOrder__c> sourceAsServiceRequest)
    {
        List<dmpl__RepairOrderLine__c> newRepairOrderLines = new List<dmpl__RepairOrderLine__c>();
        Map<ID, dmpl__ServiceRequest__c> serviceRequests = new Map<ID, dmpl__ServiceRequest__c>(queryServiceRequests(DocumentHelper.extractIds(sourceAsServiceRequest, FIELD_REPAIRORDER_SERVICEREQUESTID)));
        for(dmpl__RepairOrder__c lineEntry : sourceAsServiceRequest)
        {
            if(lineEntry.dmpl__ServiceEstimateId__c != null)
                continue;
            dmpl__ServiceRequest__c currentServiceRequest = serviceRequests.get(lineEntry.dmpl__ServiceRequestId__c);
            if(currentServiceRequest != null)
            {
                for(dmpl__ServiceRequestLine__c serviceRequestLine : currentServiceRequest.ServiceAppointmentLines__r)
                {
                    newRepairOrderLines.add(new dmpl__RepairOrderLine__c(
                        dmpl__RepairOrderId__c = lineEntry.Id,
                        dmpl__ItemId__c = serviceRequestLine.dmpl__ItemId__c,
                        dmpl__Quantity__c = serviceRequestLine.dmpl__Quantity__c,
                        dmpl__TaxGroupId__c = serviceRequestLine.dmpl__TaxGroupId__c,
                        dmpl__UnitPrice__c = serviceRequestLine.dmpl__UnitPrice__c,
                        dmpl__UnitPrice2__c = serviceRequestLine.dmpl__UnitPrice2__c,
                        dmpl__StandardDurationHours__c = serviceRequestLine.dmpl__DurationInHours__c,
                        dmpl__SKUId__c = serviceRequestLine.dmpl__SKUId__c,
                        dmpl__ItemServiceContractId__c = serviceRequestLine.dmpl__ItemServiceContractId__c,
                        dmpl__AssetServiceContractId__c = serviceRequestLine.dmpl__AssetServiceContractId__c,
                        dmpl__ServiceContractItemId__c = serviceRequestLine.dmpl__ServiceContractItemId__c,
                        dmpl__PostingType__c = serviceRequestLine.dmpl__PostingType__c,
                        dmpl__ServiceRecommendationId__c = serviceRequestLine.dmpl__ServiceRecommendationId__c,
                        dmpl__AssetServiceContractLineId__c = serviceRequestLine.dmpl__AssetServiceContractLineId__c,
                        dmpl__ServiceRequestLineId__c = serviceRequestLine.Id,
                        dmpl__IsServiceCampaignMandatory__c = serviceRequestLine.dmpl__IsServiceCampaignMandatory__c,
                        dmpl__ServiceCampaignId__c = serviceRequestLine.dmpl__ServiceCampaignId__c,
                        dmpl__ServiceCampaignItemId__c = serviceRequestLine.dmpl__ServiceCampaignItemId__c,
                        dmpl__AssetMaintenanceId__c = serviceRequestLine.dmpl__AssetMaintenanceId__c,
                        dmpl__DiscountAmount__c = serviceRequestLine.dmpl__DiscountAmount__c,
                        dmpl__Discount__c = serviceRequestLine.dmpl__Discount__c,
                        dmpl__Discount2__c = serviceRequestLine.dmpl__Discount2__c,
                        dmpl__DiscountAmount2__c = serviceRequestLine.dmpl__DiscountAmount2__c,
                        dmpl__ContractDiscount__c = serviceRequestLine.dmpl__ContractDiscount__c,
                        dmpl__ContractDiscountAmount__c = serviceRequestLine.dmpl__ContractDiscountAmount__c
                    ));
                }
            }
        }

        if(newRepairOrderLines.size() > 0)
        {
            try{
                skipValidations = true;
                SecurityHelper.ensureCanWriteObject(OBJECT_REPAIRORDERLINE);
                SecurityHelper.ensureCanWriteFields(
                    new List<string>{
                    'dmpl__IsPackageService__c',
                    'dmpl__ItemId__c',
                    'dmpl__Quantity__c',
                    'dmpl__TaxGroupId__c',
                    'dmpl__UnitPrice__c',
                    'dmpl__StandardDurationHours__c',
                    'dmpl__SKUId__c',
                    'dmpl__ItemServiceContractId__c',
                    'dmpl__ServiceContractItemId__c',
                    'dmpl__ServiceRecommendationId__c',
                    'dmpl__AssetServiceContractLineId__c',
                    'dmpl__PostingType__c'}, OBJECT_REPAIRORDERLINE);
                insert newRepairOrderLines; 
            } catch(Exception error){
                ExceptionLogHelper.logException(error);
                throw error;
            } finally {
                skipValidations = false;
            }
        }
    }

    public static void populateLinesFromServiceContractItem(List<dmpl__RepairOrder__c> sourceAsServiceContractItem)
    {
        List<dmpl__RepairOrderLine__c> newRepairOrderLines = new List<dmpl__RepairOrderLine__c>();
        Map<Id, dmpl__AssetServiceContract__c> assetServiceContracts = new Map<Id, dmpl__AssetServiceContract__c>(queryAssetServiceContract(DocumentHelper.extractIds(sourceAsServiceContractItem, FIELD_REPAIRORDER_ASSETID)));

        for(dmpl__RepairOrder__c repairOrder : sourceAsServiceContractItem)
        {
            if(repairOrder.dmpl__ServiceEstimateId__c != null || repairOrder.dmpl__ServiceRequestId__c != null)
                continue;

            List<dmpl__AssetServiceContract__c> currentAssetServiceContracts = DocumentHelper.getObjectsByFilter(assetServiceContracts.values(), 'dmpl__AssetId__c', repairOrder.dmpl__AssetId__c);
            if(currentAssetServiceContracts != null && currentAssetServiceContracts.size() > 0)
            {
                currentAssetServiceContracts = DocumentHelper.getObjectsByFilter(currentAssetServiceContracts, 'dmpl__ItemServiceContractId__c', repairOrder.dmpl__ItemServiceContractId__c);
                currentAssetServiceContracts = currentAssetServiceContracts.size() > 0 ? DocumentHelper.getObjectsByFilter(currentAssetServiceContracts, 'dmpl__IsValid__c', true) : new List<dmpl__AssetServiceContract__c>();
                if(currentAssetServiceContracts != null && currentAssetServiceContracts.size() > 0)
                {
                    for(dmpl__AssetServiceContract__c currentAssetServiceContract : currentAssetServiceContracts)
                    {
                        for(dmpl__AssetServiceContractLine__c currentAssetServiceContractLine : currentAssetServiceContract.AssetServiceContractLines__r)
                        {
                            newRepairOrderLines.add(new dmpl__RepairOrderLine__c(
                            dmpl__RepairOrderId__c = repairOrder.Id,
                            dmpl__ItemId__c = currentAssetServiceContractLine.dmpl__ComponentItemId__c,
                            dmpl__Quantity__c = currentAssetServiceContractLine.dmpl__PendingQuantity__c,
                            dmpl__PostingType__c = currentAssetServiceContract.dmpl__PostingType__c,
                            dmpl__ItemServiceContractId__c = currentAssetServiceContract.dmpl__ItemServiceContractId__c,
                            dmpl__ServiceContractItemId__c = currentAssetServiceContract.dmpl__ServiceContractItemId__c,
                            dmpl__AssetServiceContractLineId__c = currentAssetServiceContractLine.Id
                            ));
                        }
                    }
                }
            }
        }

        if(newRepairOrderLines.size() > 0)
        {
            try{
                skipValidations = true;
                SecurityHelper.ensureCanWriteObject(OBJECT_REPAIRORDERLINE);
                SecurityHelper.ensureCanWriteFields(
                    new List<string>{
                    'dmpl__ItemId__c',
                    'dmpl__Quantity__c',
                    'dmpl__PostingType__c',
                    'dmpl__ItemServiceContractId__c',
                    'dmpl__ServiceContractItemId__c',
                    'dmpl__AssetServiceContractLineId__c'
                }, OBJECT_REPAIRORDERLINE);
                insert newRepairOrderLines;
            } catch(Exception error) {
                ExceptionLogHelper.logException(error);
                throw error;
            } finally {
                skipValidations = false;
            }
        }
    }

    public static void updateClaimedQuantity(List<Id> repairOrderLineIds)
    {
        try{
            if(repairOrderLineIds.size () == 0 || repairOrderLineIds == null)
                return;
            skipValidations = true;
             
            SecurityHelper.ensureCanReadFields(new string[]{
                'dmpl__RepairOrderLineId__c',
                'dmpl__ClaimQuantity__c'
            }, 'dmpl__ClaimLine__c');
            List<AggregateResult> ffAggregates = 
                [SELECT 
                    dmpl__RepairOrderLineId__c RepairOrderLineId, 
                    SUM(dmpl__ClaimQuantity__c) TotalQuantity
                FROM 
                    dmpl__ClaimLine__c
                WHERE 
                    dmpl__RepairOrderLineId__c IN :repairOrderLineIds
                WITH SECURITY_ENFORCED
                GROUP BY dmpl__RepairOrderLineId__c];
             
            SecurityHelper.ensureCanReadFields(new string[]{
                'dmpl__ClaimedQuantity__c'
            }, 'dmpl__RepairOrderLine__c');
            List<dmpl__RepairOrderLine__c> orderLinesToUpdate = 
                [SELECT 
                    Id, 
                    dmpl__ClaimedQuantity__c,
                    dmpl__IsClaimed__c
                FROM 
                    dmpl__RepairOrderLine__c
                WHERE 
                    Id IN :repairOrderLineIds];
    
            for(dmpl__RepairOrderLine__c orderLine : orderLinesToUpdate){
                for(AggregateResult result : ffAggregates){
                    if(result.get(FIELD_AGG_REPAIRORDERLINEID) == orderLine.Id){
                        orderLine.dmpl__ClaimedQuantity__c 
                            = result.get(FIELD_AGG_TOTALQTY) ==null ? 
                                0 : (Decimal)(result.get(FIELD_AGG_TOTALQTY));
                        orderLine.dmpl__IsClaimed__c = orderLine.dmpl__ClaimedQuantity__c > 0;
                        break;
                    }
                }
            }
            // SecurityHelper.ensureCanWriteFields(new string[]{
            //     'dmpl__ClaimedQuantity__c'
            // }, 'dmpl__SaleOrderLine__c');
            Update orderLinesToUpdate;
        }finally{
            skipValidations = false;
        }
    }

    // NEED TO TEST
    public static void updateSaleInvoiceQuantity(List<Id> repairOrderLineIds)
    {
        try{
            if(repairOrderLineIds.size () == 0 || repairOrderLineIds == null)
                return;
            skipValidations = true;
             
            SecurityHelper.ensureCanReadFields(new string[]{
                'dmpl__RepairOrderLineId__c',
                'dmpl__Quantity__c'
            }, 'dmpl__SaleInvoiceLine__c');
            List<AggregateResult> ffAggregates = 
                [SELECT 
                    dmpl__RepairOrderLineId__c RepairOrderLineId, 
                    dmpl__ItemId__c ItemId,
                    SUM(dmpl__Quantity__c) TotalQuantity
                FROM 
                    dmpl__SaleInvoiceLine__c
                WHERE 
                    dmpl__RepairOrderLineId__c IN :repairOrderLineIds
                WITH SECURITY_ENFORCED
                GROUP BY dmpl__RepairOrderLineId__c, dmpl__ItemId__c];
             
            SecurityHelper.ensureCanReadFields(new string[]{
                'dmpl__InvoiceQuantity__c'
            }, 'dmpl__RepairOrderLine__c');
            List<dmpl__RepairOrderLine__c> orderLinesToUpdate = 
                [SELECT 
                    Id, 
                    dmpl__ItemId__c,
                    dmpl__InvoiceQuantity__c,
                    dmpl__IsInvoiced__c
                FROM 
                    dmpl__RepairOrderLine__c
                WHERE 
                    Id IN :repairOrderLineIds];
    
            for(dmpl__RepairOrderLine__c orderLine : orderLinesToUpdate){
                for(AggregateResult result : ffAggregates){
                    if(result.get(FIELD_AGG_REPAIRORDERLINEID) == orderLine.Id
                        && result.get('ItemId') == orderLine.dmpl__ItemId__c){
                        orderLine.dmpl__InvoiceQuantity__c 
                            = result.get(FIELD_AGG_TOTALQTY) ==null ? 
                                0 : (Decimal)(result.get(FIELD_AGG_TOTALQTY));
                        orderLine.dmpl__IsInvoiced__c = orderLine.dmpl__InvoiceQuantity__c >0;
                        break;
                    }
                }
            }
            SecurityHelper.ensureCanWriteFields(new string[]{
                'dmpl__InvoiceQuantity__c'
            }, 'dmpl__SaleOrderLine__c');
            Update orderLinesToUpdate;
        }finally{
            skipValidations = false;
        }
    }

    // NEED TO TEST
    public static void updateSaleInvoiceQuantity(List<Id> repairOrderLineIds, List<Id> allocationLineIds)
    {
        try{
            skipValidations = true;
            // if(allocationLineIds.size() == 0)
            //     return;
             
            SecurityHelper.ensureCanReadFields(new string[]{
                'dmpl__RepairOrderLineId__c',
                'dmpl__FulfillmentAllocationLineId__c',
                'dmpl__Quantity__c'
            }, 'dmpl__RepairOrderLine__c');
            List<AggregateResult> ffAggregates = 
                [SELECT 
                    dmpl__RepairOrderLineId__c RepairOrderLineId,
                    dmpl__FulfillmentAllocationLineId__c AllocationLineId, 
                    dmpl__ItemId__c ItemId,
                    SUM(dmpl__Quantity__c) TotalQuantity
                FROM 
                    dmpl__SaleInvoiceLine__c
                WHERE 
                    dmpl__RepairOrderLineId__c IN : repairOrderLineIds
                GROUP BY 
                    dmpl__RepairOrderLineId__c, dmpl__FulfillmentAllocationLineId__c, dmpl__ItemId__c];
             
            SecurityHelper.ensureCanReadFields(new string[]{
                'dmpl__AllocatedInvoicedQuantity__c','dmpl__OTCInvoicedQuantity__c'
            }, 'dmpl__RepairOrderLine__c');
            List<dmpl__RepairOrderLine__c> orderLinesToUpdate = 
                [SELECT 
                    Id, 
                    dmpl__ItemId__c,
                    dmpl__AllocatedInvoicedQuantity__c,
                    dmpl__OTCInvoicedQuantity__c
                FROM 
                    dmpl__RepairOrderLine__c
                WHERE 
                    Id IN : repairOrderLineIds];

            for(dmpl__RepairOrderLine__c orderLine : orderLinesToUpdate){
                List<AggregateResult> filteredResult = DocumentHelper.getObjectsWithNotNull(ffAggregates, 'AllocationLineId');
                Decimal invoicedQuantity = 0;
                for(AggregateResult result : filteredResult){
                    if(result.get(FIELD_AGG_REPAIRORDERLINEID) == orderLine.Id
                        && result.get('ItemId') == orderLine.dmpl__ItemId__c){
                        invoicedQuantity = invoicedQuantity + (result.get(FIELD_AGG_TOTALQTY) == null ? 0 : (Decimal)(result.get(FIELD_AGG_TOTALQTY)));
                    }
                }
                orderLine.dmpl__AllocatedInvoicedQuantity__c = invoicedQuantity;
            }

            for(dmpl__RepairOrderLine__c orderLine : orderLinesToUpdate){
                List<AggregateResult> filteredResult = DocumentHelper.getObjectsWithNull(ffAggregates, 'AllocationLineId');
                Decimal invoicedQuantity = 0;
                for(AggregateResult result : filteredResult){
                    if(result.get(FIELD_AGG_REPAIRORDERLINEID) == orderLine.Id
                        && result.get('ItemId') == orderLine.dmpl__ItemId__c){
                        invoicedQuantity = invoicedQuantity + (result.get(FIELD_AGG_TOTALQTY) == null ? 0 : (Decimal)(result.get(FIELD_AGG_TOTALQTY)));
                    }
                }
                orderLine.dmpl__OTCInvoicedQuantity__c = invoicedQuantity;
                orderLine.dmpl__IsInvoiced__c = orderLine.dmpl__AllocatedInvoicedQuantity__c >0 || orderLine.dmpl__OTCInvoicedQuantity__c >0;
            }
            
            SecurityHelper.ensureCanWriteFields(
                new string[]
                {
                    'dmpl__AllocatedInvoicedQuantity__c',
                    'dmpl__OTCInvoicedQuantity__c'
                }, 
                'dmpl__RepairOrderLine__c');
            Update orderLinesToUpdate;
        }finally{
            skipValidations = false;
        }
    }

    public static void performReprice(Id repairOrderId){
        performReprice(new List<Id>{repairOrderId});
    }

    public static void performReprice(List<Id> repairOrderIds){
        List<dmpl__RepairOrder__c> repairOrderDocuments = queryRepairOrders(
            repairOrderIds);
        List<dmpl__RepairOrderLine__c> repairOrderLines = queryRepairOrderLinesOfRepairOrders(
            CollectionHelper.extractIds(
                repairOrderDocuments));
        Map<Id, dmpl__Item__c> items = new Map<Id,dmpl__Item__c>(
            ItemHelper.getCachedItems(
                DocumentHelper.extractIds(
                    repairOrderLines, 
                    FIELD_REPAIRORDERLINE_ITEMID)));

        PriceListHelper.setApplicablePrices(
            repairOrderLines, 
            repairOrderDocuments, 
            items.values(),
            true);
        update repairOrderLines;
    }

    private static void setItemData(List<dmpl__RepairOrderLine__c> newEntries)
    {
        Map<Id, dmpl__Item__c> items = new Map<Id,dmpl__Item__c>(
        ItemHelper.getCachedItems(DocumentHelper.extractIds(newEntries, FIELD_REPAIRORDERLINE_ITEMID)));
        List<dmpl__RepairOrder__c> repairOrders = queryRepairOrders(DocumentHelper.extractIds(newEntries, FIELD_REPAIRORDERLINE_REPAIRORDERID));
        setAlternateItem(newEntries, items);
        TaxGroupHelper.setApplicableTaxGroups(newEntries, repairOrders, items.values());
        PriceListHelper.setApplicablePrices(
            newEntries, 
            repairOrders, 
            items.values(),
            false);
        DiscountGroupHelper.setApplicableDiscounts(newEntries, repairOrders, items.values());
        setStandardDuration(newEntries, items);
        InventoryStockHelper.setStock(newEntries);
    }

    private static void setStandardDuration(List<dmpl__RepairOrderLine__c> newEntries, Map<Id, dmpl__Item__c> items){
        for(dmpl__RepairOrderLine__c lineEntry : newEntries){
            dmpl__Item__c currentItem =  items.get(lineEntry.dmpl__ItemId__c);
            if(currentItem != null){
                lineEntry.dmpl__StandardDurationHours__c = currentItem.dmpl__ServiceDurationInMinutes__c > 0 ? currentItem.dmpl__ServiceDurationInMinutes__c/60 : 0;
            }
        }
    }

    private static void validateCampaignLineUpdate(
        List<dmpl__RepairOrderLine__c> newEntries,
        List<dmpl__RepairOrderLine__c> oldEntries){
        List<dmpl__RepairOrderLine__c> modifiedObjects = DocumentHelper.getModifiedNewObjects(
            new string[]{
                FIELD_REPAIRORDERLINE_ITEMID, 
                FIELD_REPAIRORDERLINE_CANCELLEDQUANTITY,
                FIELD_REPAIRORDER_ITEMSERVICEONTRACTID,
                FIELD_REPAIRORDERLINE_QUANTITY}, oldEntries, newEntries);
        for(dmpl__RepairOrderLine__c line : modifiedObjects){
            if(line.dmpl__IsServiceCampaignMandatory__c){
                line.addError('Campaign Mandated Items can not be modified!');
            }
        }
    }

    private static void validateCampaignLineDelete(
        List<dmpl__RepairOrderLine__c>  oldEntries){
        for(dmpl__RepairOrderLine__c line : oldEntries){
            if(line.dmpl__IsServiceCampaignMandatory__c){
                line.addError('Campaign Mandated Items can not be delted!');
            }
        }
    }

    private static List<dmpl__Quote__c> queryServiceEstimates(List<ID> serviceEstimateIds)
    {
        SecurityHelper.ensureCanReadFields(new List<String>{
        'dmpl__Amount__c',
        'dmpl__DurationInHours__c',
        'dmpl__IsApproved__c',
        'dmpl__IsDeclined__c',
        'dmpl__ItemId__c',
        'dmpl__SKUId__c',
        'dmpl__Quantity__c',
        'dmpl__RecommendationType__c',
        'dmpl__ServiceContractId__c',
        'dmpl__ItemServiceContractId__c',
        'dmpl__QuoteId__c',
        'dmpl__ServiceRequestLineId__c',
        'dmpl__TaxGroupId__c',
        'dmpl__UnitPrice__c',
        'dmpl__UnitPrice2__c',
        'dmpl__UsageReading__c',
        'dmpl__PostingType__c',
        'dmpl__ServiceRecommendationId__c',
        'dmpl__AssetServiceContractLineId__c',
        'dmpl__ItemLotTypeId__c',
        'dmpl__UsageReadingHours__c'}, 'dmpl__QuoteLine__c');
        return [SELECT 
        ID,
        Name,
        (
            SELECT
            ID,
            Name,
            dmpl__Amount__c,
            dmpl__DurationInHours__c,
            dmpl__IsApproved__c,
            dmpl__IsDeclined__c,
            dmpl__ItemId__c,
            dmpl__SKUId__c,
            dmpl__Quantity__c,
            dmpl__RecommendationType__c,
            dmpl__ServiceContractId__c,
            dmpl__ItemServiceContractId__c,
            dmpl__QuoteId__c,
            dmpl__ServiceRequestLineId__c,
            dmpl__TaxGroupId__c,
            dmpl__UnitPrice__c,
            dmpl__UnitPrice2__c,
            dmpl__UsageReading__c,
            dmpl__UsageReadingHours__c,
            dmpl__PostingType__c,
            dmpl__ServiceRecommendationId__c,
            dmpl__AssetServiceContractLineId__c,
            dmpl__DiscountAmount__c,
            dmpl__Discount__c,
            dmpl__Discount2__c,
            dmpl__DiscountAmount2__c,
            dmpl__ContractDiscount__c,
            dmpl__ContractDiscountAmount__c,
            dmpl__ItemLotTypeId__c
            FROM dmpl__QuoteLines__r
        )
        FROM dmpl__Quote__c
        WHERE ID IN : serviceEstimateIds];
    }

    private static List<dmpl__ServiceRequest__c> queryServiceRequests(List<ID> serviceRequestIds)
    {
        SecurityHelper.ensureCanReadFields(new List<String>{
            'dmpl__Amount__c',
            'dmpl__DurationInHours__c',
            'dmpl__ItemId__c',
            'dmpl__SKUId__c',
            'dmpl__Quantity__c',
            'dmpl__ServiceRequestId__c',
            'dmpl__TaxGroupId__c',
            'dmpl__UnitPrice__c',
            'dmpl__UnitPrice2__c',
            'dmpl__ServiceContractItemId__c',
            'dmpl__PostingType__c',
            'dmpl__ItemServiceContractId__c',
            'dmpl__ServiceRecommendationId__c',
            'dmpl__AssetServiceContractLineId__c',
            'dmpl__ItemLotTypeId__c'
            }, 'dmpl__ServiceRequestLine__c');
        return [SELECT ID,
        Name,
        (
            SELECT
            ID,
            dmpl__Amount__c,
            dmpl__DurationInHours__c,
            dmpl__ItemId__c,
            dmpl__SKUId__c,
            dmpl__Quantity__c,
            dmpl__ServiceRequestId__c,
            dmpl__TaxGroupId__c,
            dmpl__UnitPrice__c,
            dmpl__UnitPrice2__c,
            dmpl__ServiceContractItemId__c,
            dmpl__ItemServiceContractId__c,
            dmpl__PostingType__c,
            dmpl__ServiceRecommendationId__c,
            dmpl__AssetServiceContractId__c,
            dmpl__AssetServiceContractLineId__c,
            dmpl__ItemLotTypeId__c,
            dmpl__IsServiceCampaignMandatory__c,
            dmpl__ServiceCampaignId__c,
            dmpl__ServiceCampaignItemId__c,
            dmpl__AssetMaintenanceId__c,
            dmpl__DiscountAmount__c,
            dmpl__Discount__c,
            dmpl__Discount2__c,
            dmpl__DiscountAmount2__c,
            dmpl__ContractDiscount__c,
            dmpl__ContractDiscountAmount__c
            FROM ServiceAppointmentLines__r
        )
        FROM dmpl__ServiceRequest__c
        WHERE ID IN : serviceRequestIds];
    }

    private static List<dmpl__AssetServiceContract__c> queryAssetServiceContract(List<Id> assetIds)
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
            'dmpl__PostingType__c',
            'dmpl__PopulateContractLines__c'
            }, 'dmpl__AssetServiceContract__c');
        SecurityHelper.ensureCanReadFields(new List<String>{
            'dmpl__AssetServiceContractId__c',
            'dmpl__ComponentItemId__c',
            'dmpl__Quantity__c',
            'dmpl__UtilizedQuantity__c',
            'dmpl__PendingQuantity__c'
            }, 'dmpl__AssetServiceContractLine__c');
        return [
            SELECT Id,
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
                dmpl__PostingType__c,
                dmpl__ValidtillDate__c,
                dmpl__ValidtillHours__c,
                dmpl__ValidtillUsageReading__c,
                (
                    SELECT Id,
                    Name,
                    dmpl__AssetServiceContractId__c,
                    dmpl__ComponentItemId__c,
                    dmpl__Quantity__c,
                    dmpl__PendingQuantity__c,
                    dmpl__UtilizedQuantity__c
                    FROM AssetServiceContractLines__r
                    WHERE dmpl__PendingQuantity__c > 0
                )
            FROM dmpl__AssetServiceContract__c
            WHERE dmpl__AssetId__c IN : assetIds
            AND dmpl__PopulateContractLines__c = true];
    }
    
    private static list<dmpl__RepairOrder__c> queryRepairOrders(List<Id> repairOrderIds)
    {
        SecurityHelper.ensureCanReadFields(new List<string>{
            'dmpl__DocumentDate__c',
            'dmpl__Status__c',
            'dmpl__PartnerAccountId__c',
            'dmpl__BranchId__c',
            'dmpl__TaxSupplyType__c',
            'dmpl__DiscountGroupId__c',
            'dmpl__PriceAsOnDate__c'
        }, 'dmpl__RepairOrder__c');
        return [SELECT Id, 
        Name,
        dmpl__DocumentDate__c,
        dmpl__FailureDate__c,
        dmpl__Status__c,
        dmpl__PriceListId__c,
        dmpl__PartnerAccountId__c,
        dmpl__BranchId__c,        
        dmpl__TaxSupplyType__c,
        dmpl__DiscountGroupId__c,
        dmpl__PriceAsOnDate__c
        FROM dmpl__RepairOrder__c
        WHERE Id IN : repairOrderIds];
    }

    private static List<dmpl__RepairOrderLine__c> queryRepairOrderLinesOfRepairOrders(
        List<ID> repairOrderIds)
    {
        SecurityHelper.ensureCanReadFields(new List<String>
        {
            'Name', 
            'dmpl__ItemId__c',
            'dmpl__SKUId__c',
            'dmpl__Quantity__c',
            'dmpl__UnitPrice__c',
            'dmpl__UnitPrice2__c',
            'dmpl__PriceListId__c',
            'dmpl__TaxGroupId__c',
            'dmpl__ItemLotTypeId__c',
            'dmpl__TaxAmount__c',
            'dmpl__RepairOrderId__c'
        },'dmpl__RepairOrderLine__c');
        return [ SELECT ID, 
            Name, 
            dmpl__ItemId__c,
            dmpl__SKUId__c,
            dmpl__Quantity__c,
            dmpl__UnitPrice__c,
            dmpl__UnitPrice2__c,
            dmpl__PriceListId__c,    
            dmpl__TaxGroupId__c,
            dmpl__ItemLotTypeId__c,
            dmpl__TaxAmount__c,
            dmpl__RepairOrderId__c,
            dmpl__PriceAsOnDate__c,
            dmpl__IsILPostingApproved__c,
            dmpl__IsILPosted__c
        FROM dmpl__RepairOrderLine__c
        WHERE dmpl__RepairOrderId__c IN : repairOrderIds];
    }

    private static List<dmpl__RepairOrderLine__c> queryRepairOrderLines(
        List<ID> repairOrderLineIds)
    {
        SecurityHelper.ensureCanReadFields(new List<String>
        {
            'Name', 
            'dmpl__IsILPostingApproved__c',
            'dmpl__IsILPosted__c'
        },'dmpl__RepairOrderLine__c');
        return [ SELECT ID, 
            Name, 
            dmpl__IsILPostingApproved__c,
            dmpl__IsILPosted__c
        FROM dmpl__RepairOrderLine__c
        WHERE ID IN : repairOrderLineIds];
    }   

    private static void setRepairOrderDiscount(List<dmpl__RepairOrderLine__c> newEntries)
    {
        for(dmpl__RepairOrderLine__c lineEntry : newEntries)
        if(lineEntry.dmpl__RepairOrderDiscount__c > 0)
            lineEntry.dmpl__Discount__c = lineEntry.dmpl__RepairOrderDiscount__c;
    }

    private static void updateDiscount(List<dmpl__RepairOrderLine__c> newEntries)
    {
        for(dmpl__RepairOrderLine__c lineEntry : newEntries)
            if(lineEntry.dmpl__DiscountAmount__c > 0)
                lineEntry.dmpl__Discount__c = 0;
    }

    private static void setAlternateItem(List<dmpl__RepairOrderLine__c> newEntries, Map<Id, dmpl__Item__c> items)
    {
        for(dmpl__RepairOrderLine__c newEntry : newEntries)
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

        items = new Map<Id,dmpl__Item__c>(ItemHelper.getCachedItems(DocumentHelper.extractIds(newEntries, FIELD_REPAIRORDERLINE_ITEMID)));
    }
}