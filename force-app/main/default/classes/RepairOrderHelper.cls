public with sharing class RepairOrderHelper {

    private static Boolean skipValidations = false;

    private static final string OBJECT_REPAIRORDER = 'dmpl__RepairOrder__c';

    private static final string FIELD_REPAIRORDER_ACCOUNTID = 'dmpl__AccountId__c';
    private static final string FIELD_REPAIRORDER_ASSETID = 'dmpl__AssetId__c';
    private static final string FIELD_REPAIRORDER_BRANCHID = 'dmpl__BranchId__c';
    private static final string FIELD_REPAIRORDER_CANCELPENDINGQUANTITY = 'dmpl__CancelPendingQuantity__c';
    private static final string FIELD_REPAIRORDER_PACKAGESERVICEID = 'dmpl__PackageServiceId__c';
    private static final string FIELD_REPAIRORDER_PARTNERACCOUNTID = 'dmpl__PartnerAccountId__c';
    private static final string FIELD_REPAIRORDER_SERVICEESTIMATEID = 'dmpl__ServiceEstimateId__c';
    private static final string FIELD_REPAIRORDER_SERVICEREQUESTID = 'dmpl__ServiceRequestId__c';
    private static final string FIELD_REPAIRORDER_SERVICECONTRACTITEMID = 'dmpl__ServiceContractItemId__c';
    private static final string FIELD_REPAIRORDER_ITEMSERVICECONTRACTID = 'dmpl__ItemServiceContractId__c';
    private static final string FIELD_REPAIRORDER_STATUS = 'dmpl__Status__c';
    private static final string FIELD_REPAIRORDER_SERVICEREQUESTREPAIRORDERID = 'dmpl__RepairOrderId__c';
    private static final string FIELD_REPAIRORDER_TECHNICIANID = 'dmpl__TechnicianId__c';
    private static final string FIELD_REPAIRORDER_SERVICEADVISORID = 'dmpl__ServiceAdvisorId__c';

    private static final string FIELD_REPAIRORDER_PERFORMGENERATEQUOTE = 'dmpl__PerformGenerateQuote__c';
    
    private static final string FIELD_REPAIRORDER_PERFORMPOPULATELINES = 'dmpl__PerformPopulateLines__c';
    private static final string FIELD_REPAIRORDER_ISLINEPOPULATED = 'dmpl__IsLinePopulated__c';
    private static final string FIELD_REPAIRORDER_PERFORMRELEASEFORFULFILLMENT = 'dmpl__PerformReleaseForFulfillment__c';
    private static final string FIELD_REPAIRORDER_ISRELEASEDFORFULFILLMENT = 'dmpl__IsReleasedForFulfillment__c';
    private static final string FIELD_REPAIRORDER_PERFORMWORKSTART = 'dmpl__PerformWorkStart__c';
    private static final string FIELD_REPAIRORDER_ISWORKSTARTED = 'dmpl__IsWorkStarted__c';
    private static final string FIELD_REPAIRORDER_PERFORMWORKEND = 'dmpl__PerformWorkEnd__c';
    private static final string FIELD_REPAIRORDER_ISWORKENDED = 'dmpl__IsWorkEnded__c';
    private static final string FIELD_REPAIRORDER_PERFORMINVOICEGENERATION = 'dmpl__PerformInvoiceGeneration__c';
    private static final string FIELD_REPAIRORDER_ISINVOICEGENERATED = 'dmpl__IsInvoiceGenerated__c';
    private static final string FIELD_REPAIRORDER_PERFORMPOPULATECHECKLIST = 'dmpl__PerformPopulateChecklist__c';
    private static final string FIELD_REPAIRORDER_PERFORMKPICALCULATION = 'dmpl__PerformKPICalculation__c';

    private static final string FIELD_REPAIRORDER_PERFORMVORORDERGENERATION = 'dmpl__PerformVOROrderGeneration__c';
    private static final string FIELD_REPAIRORDER_PERFORMVSERVICEINVOICE = 'dmpl__PerformServiceInvoice__c';
    private static final string FIELD_REPAIRORDER_ISVORORDERGENERATED = 'dmpl__IsVOROrderGenerated__c';

    private static final string FIELD_REPAIRORDER_BILLINGADDRESS ='dmpl__BillingAddress__c';
    private static final string FIELD_REPAIRORDER_SHIPPINGADDRESS ='dmpl__ShippingAddress__c';
    private static final string FIELD_REPAIRORDER_BILLINGADDRESSID ='dmpl__BillingAddressId__c';
    private static final string FIELD_REPAIRORDER_SHIPPINGADDRESSID ='dmpl__ShippingAddressId__c';

    private static final string FIELD_REPAIRORDER_TAXGROUPID = 'dmpl__TaxGroupId__c';
    private static final string FIELD_REPAIRORDER_TAXID = 'dmpl__TaxId__c';
    private static final string FIELD_REPAIRORDER_AMOUNT = 'dmpl__TotalLineAmount__c';
    
    private static final List<String> LIST_NON_EDITABLE_FIELDS = new List<String>{FIELD_REPAIRORDER_BRANCHID, FIELD_REPAIRORDER_PARTNERACCOUNTID};
    private static final List<String> LIST_FIELDS_SYSTEM = new List<String>{FIELD_REPAIRORDER_ISLINEPOPULATED, FIELD_REPAIRORDER_ISRELEASEDFORFULFILLMENT, FIELD_REPAIRORDER_ISWORKSTARTED, FIELD_REPAIRORDER_ISWORKENDED, FIELD_REPAIRORDER_ISINVOICEGENERATED};

    public static void validateData(Boolean isInsert, Boolean isUpdate, Boolean isDelete, List<dmpl__RepairOrder__c> newEntries, List<dmpl__RepairOrder__c> oldEntries)
    {
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
                StatusHelper.validateStatusNew(OBJECT_REPAIRORDER, FIELD_REPAIRORDER_STATUS, newEntries);
                DocumentHelper.validateChangeInSystemFields(LIST_FIELDS_SYSTEM, newEntries);
                ValidationHelper.validatePartnerAndBranch(FIELD_REPAIRORDER_PARTNERACCOUNTID, FIELD_REPAIRORDER_BRANCHID, newEntries);
                ValidationHelper.validateResource(FIELD_REPAIRORDER_TECHNICIANID, newEntries);
                ValidationHelper.validateResource(FIELD_REPAIRORDER_SERVICEADVISORID, newEntries);
                AssetHelper.validateUsageReadings(newEntries);
                AssetServiceContractHelper.validateHeaderItemServiceContract(
                    newEntries);
            }else if(isUpdate){
                //StatusHelper.validateStatusEdit(OBJECT_REPAIRORDER, FIELD_REPAIRORDER_STATUS, oldEntries, newEntries);
                DocumentHelper.validateChangeInKeyFields(LIST_NON_EDITABLE_FIELDS, oldEntries, newEntries);
                DocumentHelper.validateChangeInSystemFields(LIST_FIELDS_SYSTEM, oldEntries, newEntries);
                dfsHelper.DocumentStatusRestrictEdits_Edit(OBJECT_REPAIRORDER, FIELD_REPAIRORDER_STATUS, oldEntries, newEntries);
                dfsHelper.DocumentStatusRestrictFieldsEdits(OBJECT_REPAIRORDER, FIELD_REPAIRORDER_STATUS, oldEntries, newEntries);
                AssetHelper.validateUsageReadings(
                    DocumentHelper.getModifiedNewObjects(
                        new List<String>{
                            'dmpl__UsageReading__c', 
                            'dmpl__UsageReadingHours__c'}, 
                        oldEntries, 
                        newEntries));
                AssetServiceContractHelper.validateHeaderItemServiceContract(
                    DocumentHelper.getModifiedNewObjects(
                        'dmpl__ItemServiceContractId__c', 
                        oldEntries, 
                        newEntries));
                ValidationHelper.validateResource(FIELD_REPAIRORDER_TECHNICIANID, newEntries);
                ValidationHelper.validateResource(FIELD_REPAIRORDER_SERVICEADVISORID, newEntries);
            }else if(isDelete){
                dfsHelper.DocumentStatusRestrictEdits_Delete(OBJECT_REPAIRORDER, FIELD_REPAIRORDER_STATUS, oldEntries);
            }
        } catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }

    public static void postData(Boolean isInsert, Boolean isUpdate, Boolean isDelete, List<dmpl__RepairOrder__c> newEntries, List<dmpl__RepairOrder__c> oldEntries)
    {
        if(isInsert){
            PriceListHelper.setDefaultPriceListIds(newEntries);
            DiscountGroupHelper.setDefaultDiscountGroupIds(newEntries);
    		DocumentNameHelper.generateDocumentName(newEntries);
            setDefaultAddress(newEntries);
        } else if(isUpdate){
            List<dmpl__RepairOrder__c> modifiedObjects = DocumentHelper.getApprovedObjects(FIELD_REPAIRORDER_PERFORMRELEASEFORFULFILLMENT, oldEntries, newEntries);
            if(modifiedObjects.size() > 0)
                releaseForFulfillment(modifiedObjects);

            modifiedObjects = DocumentHelper.getApprovedObjects(FIELD_REPAIRORDER_PERFORMPOPULATECHECKLIST, oldEntries, newEntries);
            if(modifiedObjects.size()>0)
                populateChecklistDetails(modifiedObjects);

            // (Depreciated)
            modifiedObjects = DocumentHelper.getApprovedObjects(FIELD_REPAIRORDER_PERFORMVORORDERGENERATION, oldEntries, newEntries);
            if(modifiedObjects.size()>0)
                createPurchaseOrderFromRepairOrderInternal(modifiedObjects);
            
            modifiedObjects = DocumentHelper.getApprovedObjects(FIELD_REPAIRORDER_PERFORMINVOICEGENERATION, oldEntries, newEntries);
            if(modifiedObjects.size()>0)
            {
                createServiceInvoice(modifiedObjects);
            }

            modifiedObjects = DocumentHelper.getApprovedObjects(FIELD_REPAIRORDER_PERFORMKPICALCULATION, oldEntries, newEntries);
            if(modifiedObjects.size()>0){
                updatePerformanceKPI(modifiedObjects);
            }

            List<dmpl__RepairOrder__c> modifiedDocs = DocumentHelper.getApprovedObjects(
                'dmpl__PerformInventoryPosting__c', 
                oldEntries,
                newEntries);
            if(modifiedDocs.size()>0){
                postRepairOrderDocuments(modifiedDocs);
            }

            modifiedObjects = DocumentHelper.getApprovedObjects(FIELD_REPAIRORDER_PERFORMGENERATEQUOTE, oldEntries, newEntries);
            if(modifiedObjects.size() > 0)
                generateQuote(modifiedObjects);
         
            setDefaultAddress(newEntries,oldEntries);
            RoundOffHelper.setRoundOff(
                newEntries,
                'dmpl__TotalLineAmount__c',
                'dmpl__TotalTaxAmount2__c');
        }
    }

    public static void afterPostData(Boolean isInsert, Boolean isUpdate, Boolean isDelete, List<dmpl__RepairOrder__c> newEntries, List<dmpl__RepairOrder__c> oldEntries)
    {
        if(isInsert)
        {
            if(newEntries.size() > 0){
                RepairOrderLineHelper.createRepairOrderLinesFromRepairOrder(newEntries);
            }
            RepairOrderLineHelper.populateLinesForAssetMaintenance(
                newEntries,
                false);
            List<dmpl__RepairOrder__c> newObjects = DocumentHelper.getObjectsWithNotNull(newEntries, FIELD_REPAIRORDER_SERVICEREQUESTID);
            if(newObjects.size() > 0){
                ServiceRequestHelper.updateRepairOrderId(newObjects);
            }
            TaxHelper.createHeaderTaxes(
                isInsert, 
                newEntries);
        }
        else if(isUpdate)
        {
            List<dmpl__RepairOrder__c> modifiedObjects = DocumentHelper.getModifiedNewObjects(FIELD_REPAIRORDER_SERVICEREQUESTID, oldEntries, newEntries);
            if(modifiedObjects.size() > 0)        
                RepairOrderLineHelper.populateLinesFromServiceRequest(modifiedObjects);
            
            modifiedObjects = DocumentHelper.getModifiedNewObjects(FIELD_REPAIRORDER_SERVICEESTIMATEID, oldEntries, newEntries);
            if(modifiedObjects.size() > 0)        
                RepairOrderLineHelper.populateLinesFromServiceEstimate(modifiedObjects);

            modifiedObjects = DocumentHelper.getModifiedNewObjects(FIELD_REPAIRORDER_ITEMSERVICECONTRACTID, oldEntries, newEntries);
            if(modifiedObjects.size() > 0)
                    RepairOrderLineHelper.populateLinesFromServiceContractItem(modifiedObjects);
            
            modifiedObjects = DocumentHelper.getApprovedObjects('dmpl__IsDelivered__c', oldEntries, newEntries);
            if(modifiedObjects.size()>0)
            {
                updatePDIDoneInAssets(modifiedObjects);
                InspectionLineHelper.updateIsRepairOrderClosedInInspectionLine(DocumentHelper.extractIds(modifiedObjects, 'dmpl__InspectionLineId__c'));
            }

            modifiedObjects = DocumentHelper.getModifiedNewObjects('dmpl__Discount__c', oldEntries, newEntries);
            if(modifiedObjects.size()>0)
            {
                updateDiscountInRepairOrderLines(modifiedObjects);
            }
                       
            modifiedObjects = DocumentHelper.getModifiedNewObjects(
                'dmpl__PriceAsOnDate__c', 
                oldEntries, 
                newEntries);
            if(modifiedObjects.size()>0){
                RepairOrderLineHelper.performReprice(
                    CollectionHelper.extractIds(modifiedObjects));
            }

            modifiedObjects = DocumentHelper.getApprovedObjects(
                'dmpl__PopulateAssetMaintenance__c',
                oldEntries, 
                newEntries);
            if(modifiedObjects.size()>0){
                RepairOrderLineHelper.populateLinesForAssetMaintenance(
                    newEntries,
                    true);
            }

            modifiedObjects = DocumentHelper.getModifiedNewObjects(new string[]{
                FIELD_REPAIRORDER_TAXGROUPID,
                FIELD_REPAIRORDER_TAXID,
                FIELD_REPAIRORDER_AMOUNT
            }, oldEntries, newEntries);
            if(modifiedObjects.size()>0){
                TaxHelper.createHeaderTaxes(
                    isInsert,
                    modifiedObjects);
            }
        }
    }

    public static void createServiceInvoice(List<dmpl__RepairOrder__c> repairOrders){
        dmpl__CreateRelatedSetting__mdt setting = CreateRelatedSettingHelper.getCreateRelatedSettings(
            'dmpl__RepairOrder__c',
            'Post GL');
        if(setting == null){
            createServiceInvoiceInternal(queryRepairOrders(DocumentHelper.extractIds(repairOrders)), null);
        }else {
            for(dmpl__RepairOrder__c order : repairOrders){
                DocumentSelectorController.releaseDocumentDirect(setting.Id, order.Id);
            }
        }
    }

    public static CreateRelatedResult createServiceInvoice(Id repairOrderId){
        return createServiceInvoiceInternal(queryRepairOrders(new List<Id>{repairOrderId}), null);
    }

    public static CreateRelatedResult createServiceInvoice(List<SourceObjectInfo> orderLinesInfo, Id repairOrderId){
        return createServiceInvoiceInternal(queryRepairOrders(new List<Id>{repairOrderId}), orderLinesInfo);
    }

    public static CreateRelatedResult createServiceInvoiceInternal(List<dmpl__RepairOrder__c> repairOrders, List<SourceObjectInfo> orderLinesInfo){
        CreateRelatedResult invoiceResult = null;
        CreateRelatedResult claimResult = null;
        if(orderLinesInfo == null){
            invoiceResult = SaleInvoiceHelper.createServiceInvoice(repairOrders);
            claimResult = ClaimHelper.createClaims(repairOrders);
        }else{
            invoiceResult = SaleInvoiceHelper.createServiceInvoice(orderLinesInfo);
            claimResult = ClaimHelper.createClaims(orderLinesInfo);
        }
        updateServiceRecommendations(repairOrders);
        UpdateAsset(repairOrders);
        updateAssetContract(repairOrders);
        SecurityHelper.ensureCanWriteField('dmpl__PerformInvoiceGeneration__c', 'dmpl__RepairOrder__c');
        SecurityHelper.ensureCanWriteField('dmpl__IsInvoiceGenerated__c', 'dmpl__RepairOrder__c');
        for(dmpl__RepairOrder__c lineEntry : repairOrders){
            lineEntry.dmpl__PerformInvoiceGeneration__c = false;
            lineEntry.dmpl__IsInvoiceGenerated__c = true;
        }
        CreateRelatedResult result = CreateRelatedResult.SuccessResult();
        result.resultDocuments = new Map<String,SObject>();
        if(claimResult?.resultDocuments != null){
            result.resultDocuments.putAll(claimResult.resultDocuments);
        }
        if(invoiceResult?.resultDocuments !=null){
            result.resultDocuments.putAll(invoiceResult.resultDocuments);
        }
        return result;
    }

    private static void updatePerformanceKPI(List<dmpl__RepairOrder__c> newEntries)
    {
        PerformanceKPIHelper.upsertPerformanceKPI(OBJECT_REPAIRORDER, 'SCHEME', newEntries);
        PerformanceKPIHelper.upsertPerformanceKPI(OBJECT_REPAIRORDER, 'INCENTIVE', newEntries);
        for(dmpl__RepairOrder__c lineEntry : newEntries)
        {
            lineEntry.dmpl__PerformKPICalculation__c = false;
            lineEntry.dmpl__IsKPICalculated__c = true;
        }
    }

    private static void postRepairOrderDocuments(List<dmpl__RepairOrder__c> modifiedDocs){
        RepairOrderLineHelper.postRepairOrderLines(modifiedDocs);
        SecurityHelper.ensureCanWriteField('dmpl__PerformInventoryPosting__c', OBJECT_REPAIRORDER);
        SecurityHelper.ensureCanWriteField('dmpl__IsILPosted__c', OBJECT_REPAIRORDER);
        for(dmpl__RepairOrder__c document : modifiedDocs){
            document.dmpl__PerformInventoryPosting__c = false;
            document.dmpl__IsILPosted__c = true;
        }
    }

    public static CreateRelatedResult postIL(Id repairOrderId){
        return RepairOrderLineHelper.postIL(repairOrderId);
     }
 
    public static CreateRelatedResult postIL(
        List<SourceObjectInfo> orderLinesInfo, 
        Id repairOrderId){
        return RepairOrderLineHelper.postIL(
            orderLinesInfo, 
            repairOrderId);
    }

    public static void updateServiceRecommendations(List<dmpl__RepairOrder__c> lineEntries){
        ServiceRecommendationHelper.updateServiceRecommendationFromRepairOrder(lineEntries);
    }

    public static void updateAsset(List<dmpl__RepairOrder__c> lineEntries){
        AssetHelper.updateAssetFromRepairOrder(lineEntries);
        AssetHelper.updateAssetMaintenanceFromRepairOrder(lineEntries);
    }

    public static void populateChecklistDetails(List<dmpl__RepairOrder__c> repairOrders){
        ChecklistLineHelper.createChecklistLines(repairOrders);
    }

    public static void createRepairOrderFromInspection(List<Id> inspectionLineIds)
    {
        List<dmpl__InspectionLine__c> inspectionLines = queryInspectionLines(inspectionLineIds);
        List<dmpl__RepairOrder__c> repairOrdersToCreate = new List<dmpl__RepairOrder__c>();
        for(dmpl__InspectionLine__c inspectionLine : inspectionLines)
        {
            if(inspectionLine.dmpl__ItemId__r.dmpl__RequireRepairOrderOnReceipt__c)
            {
                repairOrdersToCreate.add(new dmpl__RepairOrder__c(
                    dmpl__PartnerAccountId__c = inspectionLine.dmpl__ReceiptId__r.dmpl__PartnerAccountId__c,
                    dmpl__BranchId__c = inspectionLine.dmpl__ReceiptId__r.dmpl__BranchId__c,
                    dmpl__ItemLotId__c = inspectionLine.dmpl__ItemLotId__c,
                    dmpl__InspectionLineId__c = inspectionLine.Id
                ));
            }
        }

        if(repairOrdersToCreate.size() > 0)
            SecurityHelper.ensureCanCreateFields(new string[]{'dmpl__PartnerAccountId__c','dmpl__BranchId__c','dmpl__ItemLotId__c','dmpl__InspectionLineId__c'}, 'dmpl__RepairOrder__c');
            insert repairOrdersToCreate;
    }

    public static void updatePaidAmount(List<Id> repairOrderIds){
        try{
            skipValidations = true;
            SecurityHelper.ensureCanReadFields(new string[]{'dmpl__RepairOrderId__c','dmpl__Amount__c'}, OBJECT_REPAIRORDER);
            List<AggregateResult> paymentAggregates = 
                [SELECT dmpl__RepairOrderId__c RepairOrderId, SUM(dmpl__Amount__c) TotalPaymentAmount
                FROM dmpl__Payment__c
                WHERE dmpl__RepairOrderId__c IN :repairOrderIds
                WITH SECURITY_ENFORCED
                GROUP BY dmpl__RepairOrderId__c];

            SecurityHelper.ensureCanReadFields(new string[]{'dmpl__AmountPaid__c'}, OBJECT_REPAIRORDER);
            List<dmpl__RepairOrder__c> ordersToUpdate = 
            [
                SELECT Id, dmpl__AmountPaid__c
                FROM dmpl__RepairOrder__c
                WHERE Id IN :repairOrderIds
            ];

            for(dmpl__RepairOrder__c order : ordersToUpdate){
                order.dmpl__AmountPaid__c = 0;
                for(AggregateResult result : paymentAggregates){
                    if(result.get('RepairOrderId') == order.Id){
                        order.dmpl__AmountPaid__c = result.get('TotalPaymentAmount') ==null ? 0 : (Decimal)(result.get('TotalPaymentAmount'));
                        break;
                    }
                }
            }
            
            SecurityHelper.ensureCanWriteFields(new string[]{'dmpl__AmountPaid__c'}, OBJECT_REPAIRORDER);
            Update ordersToUpdate;
        }finally{
            skipValidations = false;
        }
    }

    public static void generateQuote(List<dmpl__RepairOrder__c> lineEntries){
        ServiceEstimateHelper.createQuoteFromRepairOrder(lineEntries);
        SecurityHelper.ensureCanWriteField('dmpl__PerformGenerateQuote__c', 'dmpl__RepairOrder__c');
        SecurityHelper.ensureCanWriteField('dmpl__IsQuoteGenerated__c', 'dmpl__RepairOrder__c');
        for(dmpl__RepairOrder__c lineEntry : lineEntries){
            lineEntry.dmpl__PerformGenerateQuote__c = false;
            lineEntry.dmpl__IsQuoteGenerated__c = true;
        }
    }

    // (Depreciated)
    private static void createPurchaseOrderFromRepairOrderInternal(List<dmpl__RepairOrder__c> repairOrders){
        PurchaseOrderHelper.createPurchaseOrderFromRepairOrder(
            repairOrders);
        for(dmpl__RepairOrder__c repairOrder : repairOrders){
            repairOrder.dmpl__PerformVOROrderGeneration__c = false;
            repairOrder.dmpl__IsVOROrderGenerated__c = true;
        }
    }

    private static void updateAssetContract(List<RepairOrder__c> repairOrders)
    {
        List<dmpl__RepairOrderLine__c> repairOrderLines = queryRepairOrderLines(DocumentHelper.extractIds(repairOrders));
        Map<Id, dmpl__AssetServiceContractLine__c> assetContractLines = queryAssetServiceContractLines(DocumentHelper.extractIds(repairOrderLines,'dmpl__AssetServiceContractLineId__c'));
        List<dmpl__AssetServiceContractLine__c> contractLinesToUpdate = new List<dmpl__AssetServiceContractLine__c>();
        for(dmpl__RepairOrderLine__c line : repairOrderLines)
        {
            dmpl__AssetServiceContractLine__c assetContractLine = assetContractLines.get(line.dmpl__AssetServiceContractLineId__c);
            if(assetContractLine != null)
            {
                assetContractLine.dmpl__UtilizedQuantity__c = assetContractLine.dmpl__UtilizedQuantity__c == null ? line.dmpl__Quantity__c : assetContractLine.dmpl__UtilizedQuantity__c + line.dmpl__Quantity__c;
                if(!contractLinesToUpdate.contains(assetContractLine))
                    contractLinesToUpdate.add(assetContractLine);
            }
        }

        if(contractLinesToUpdate.Size() > 0)
        {
            SecurityHelper.ensureCanWriteFields(new string[]{
                'dmpl__UtilizedQuantity__c'
            }, 'dmpl__AssetServiceContractLine__c');      
            update contractLinesToUpdate;
        }
    }

    @testVisible
    private static void populateLines(List<dmpl__RepairOrder__c> repairOrders)
    {
        RepairOrderLineHelper.createRepairOrderLinesFromRepairOrder(repairOrders);
    }

    private static void updatePDIDoneInAssets(List<dmpl__RepairOrder__c> repairOrders)
    {
        dmpl__DMSSetting__mdt dmsSetting =  new DMSSettings().getDMSSetting('PDIServiceTypeId');
        if(dmsSetting == null)
            return;

        List<Id> assetIds = new List<Id>();
        for(dmpl__RepairOrder__c repairOrder : repairOrders)
        {
            if(repairOrder.dmpl__ServiceType__c == dmsSetting.dmpl__TextValue__c)
                assetIds.add(repairOrder.dmpl__AssetId__c);
        }
        if(assetIds.Size() > 0)
            AssetHelper.markPDIDone(assetIds);
    }

    private static void releaseForFulfillment(List<dmpl__RepairOrder__c> repairOrders)
    {
        FulfillmentHelper.createFulfillmentFromRepairOrder(repairOrders);
        for(dmpl__RepairOrder__c repairOrder : repairOrders)
        {
            repairOrder.dmpl__PerformReleaseForFulfillment__c = false;
            repairOrder.dmpl__IsReleasedForFulfillment__c = true;
        }
    }

    public static  List<dmpl__RepairOrder__c> createRepairOrderFromServiceEstimate(List<dmpl__Quote__c> quotes)
    {
        List<dmpl__RepairOrder__c> newRepairOrders = new List<dmpl__RepairOrder__c>();

       
        for(dmpl__Quote__c quote : quotes)
        {
            if(quote.dmpl__RepairOrderId__c != null)
                continue;
            newRepairOrders.add(
                new dmpl__RepairOrder__c(
                    dmpl__AccountId__c = quote.dmpl__AccountId__c,
                    dmpl__AssetId__c = quote.dmpl__AssetId__c,
                    dmpl__BranchId__c = quote.dmpl__BranchId__c,
                    dmpl__CustomerVoice__c = quote.dmpl__CustomerVoice__c,
                    dmpl__PartnerAccountId__c = quote.dmpl__PartnerAccountId__c,
                    dmpl__ServiceAdvisorId__c = quote.dmpl__ServiceAdvisorId__c,
                    dmpl__ServiceRequestId__c = quote.dmpl__ServiceRequestId__c,
                    dmpl__ServiceEstimateId__c = quote.Id,
                    dmpl__UsageReading__c = quote.dmpl__UsageReading__c,
                    dmpl__UsageReadingHours__c = quote.dmpl__UsageReadingHours__c,
                    dmpl__ItemServiceContractId__c = quote.dmpl__ItemServiceContractId__c,
                    dmpl__ServiceContractItemId__c = quote.dmpl__ServiceContractItemId__c,
                    dmpl__ServiceType__c = quote.dmpl__ServiceType__c,
                    dmpl__DocumentDate__c = date.today()
                )
            );
        }
        if(newRepairOrders.size() > 0)
        {
            try{
                skipValidations = true;
                SecurityHelper.ensureCanCreateObject(OBJECT_REPAIRORDER);
                SecurityHelper.ensureCanWriteFields(
                    new List<string>{
                    'dmpl__AccountId__c',
                    'dmpl__AssetId__c',
                    'dmpl__BranchId__c',
                    'dmpl__CustomerVoice__c',
                    'dmpl__PartnerAccountId__c',
                    'dmpl__ServiceAdvisorId__c',
                    'dmpl__ServiceRequestId__c',
                    'dmpl__ServiceEstimateId__c',
                    'dmpl__UsageReading__c',
                    'dmpl__Remarks__c',
                    'dmpl__UsageReadingHours__c',
                    'dmpl__ItemServiceContractId__c',
                    'dmpl__ServiceContractItemId__c',
                    'dmpl__ServiceType__c',
                    'dmpl__DocumentDate__c'
                }, OBJECT_REPAIRORDER);
                insert newRepairOrders;
                return newRepairOrders;
            } catch(Exception error) {
                ExceptionLogHelper.logException(error);
                throw error;
            } finally {
                skipValidations = false;
            }
        }
        else {
            return newRepairOrders;
        }
    }

    public static List<dmpl__RepairOrder__c> createRepairOrderFromServiceRequest(List<dmpl__ServiceRequest__c> serviceRequests)
    {
        List<dmpl__RepairOrder__c> newRepairOrders = new List<dmpl__RepairOrder__c>();
        for(dmpl__ServiceRequest__c serviceRequest : serviceRequests)
        {
            if(serviceRequest.dmpl__RepairOrderId__c != null)
                continue;
            newRepairOrders.add(
                new dmpl__RepairOrder__c(
                    dmpl__AccountId__c = serviceRequest.dmpl__AccountId__c,
                    dmpl__AccountName__c = serviceRequest.dmpl__AccountName__c,
                    dmpl__AssetId__c = serviceRequest.dmpl__AssetId__c,
                    dmpl__BranchId__c = serviceRequest.dmpl__BranchId__c,
                    dmpl__CustomerVoice__c = serviceRequest.dmpl__CustomerVoice__c,
                    dmpl__PartnerAccountId__c = serviceRequest.dmpl__PartnerAccountId__c,
                    dmpl__ServiceAdvisorId__c = serviceRequest.dmpl__ServiceAdvisorId__c,
                    dmpl__ServiceRequestId__c = serviceRequest.Id,
                    dmpl__UsageReading__c = serviceRequest.dmpl__UsageReading__c,
                    dmpl__UsageReadingHours__c = serviceRequest.dmpl__UsageReadingHours__c,
                    dmpl__ItemServiceContractId__c = serviceRequest.dmpl__ItemServiceContractId__c,
                    dmpl__AssetServiceContractId__c = serviceRequest.dmpl__AssetServiceContractId__c,
                    dmpl__ServiceContractItemId__c = serviceRequest.dmpl__ServiceContractItemId__c,
                    dmpl__ServiceType__c = serviceRequest.dmpl__ServiceType__c,
                    dmpl__DocumentDate__c = date.today()
                )
            );
        }
        if(newRepairOrders.size() > 0)
        {
            try{
                skipValidations = true;
                SecurityHelper.ensureCanCreateObject(OBJECT_REPAIRORDER);
                SecurityHelper.ensureCanWriteFields(
                    new List<string>{
                    'dmpl__AccountId__c',
                    'dmpl__AssetId__c',
                    'dmpl__BranchId__c',
                    'dmpl__CustomerVoice__c',
                    'dmpl__PartnerAccountId__c',
                    'dmpl__ServiceAdvisorId__c',
                    'dmpl__ServiceContractItemId__c',
                    'dmpl__ServiceRequestId__c',
                    'dmpl__UsageReading__c',
                    'dmpl__Remarks__c',
                    'dmpl__UsageReadingHours__c',
                    'dmpl__ItemServiceContractId__c',
                    'dmpl__ServiceContractItemId__c',
                    'dmpl__ServiceType__c',
                    'dmpl__DocumentDate__c'
                }, OBJECT_REPAIRORDER);
                insert newRepairOrders;
                return newRepairOrders;
            } catch(Exception error) {
                ExceptionLogHelper.logException(error);
                throw error;
            } finally {
                skipValidations = false;
            }
        }
        else 
            return newRepairOrders;
    }

    public static void updateRepairOrderFromServiceEstimate(List<dmpl__Quote__c> modifiedObjects)
    {
        List<dmpl__RepairOrder__c> repairOrderToUpdate = new List<dmpl__RepairOrder__c>();
        Map<ID, dmpl__RepairOrder__c> existingRepairOrders = new Map<ID, dmpl__RepairOrder__c>(queryRepairOrders(DocumentHelper.extractIds(modifiedObjects, 'dmpl__ServiceRequestRepairOrderId__c')));

        for(dmpl__Quote__c lineQuote : modifiedObjects)
        {
            dmpl__RepairOrder__c  repairOrder = existingRepairOrders.get(lineQuote.dmpl__ServiceRequestRepairOrderId__c);
            if(repairOrder != null)
            {
                repairOrder.dmpl__ServiceRequestId__c = lineQuote.dmpl__ServiceRequestId__c;
                repairOrder.dmpl__ServiceEstimateId__c = lineQuote.Id;
                repairOrderToUpdate.add(repairOrder);
            }
        }
        
        if(repairOrderToUpdate.size() > 0)
        {
            try{
                skipValidations = true;
                SecurityHelper.ensureCanCreateObject(OBJECT_REPAIRORDER);
                SecurityHelper.ensureCanWriteFields(
                    new List<string>{
                    'dmpl__ServiceRequestId__c',
                    'dmpl__ServiceEstimateId__c'
                }, OBJECT_REPAIRORDER);
                Update repairOrderToUpdate;
            } catch(Exception error) {
                ExceptionLogHelper.logException(error);
                throw error;
            } finally {
                skipValidations = false;
            }
        }
    }
     @testVisible
    private static void updateDiscountInRepairOrderLines(List<dmpl__RepairOrder__c> modifiedObjects)
    {
        Map<Id, dmpl__RepairOrder__c> repairOrders = new Map<Id,dmpl__RepairOrder__c>(modifiedObjects);
        List<dmpl__RepairOrderLine__c> repairOrderLines = [SELECT Id, Name, dmpl__RepairOrderId__c,  dmpl__Discount__c FROM dmpl__RepairOrderLine__c WHERE dmpl__RepairOrderId__c IN : modifiedObjects];
        if(repairOrderLines.size() > 0){
            for(dmpl__RepairOrderLine__c line : repairOrderLines){
                dmpl__RepairOrder__c repairOrder = repairOrders.get(line.dmpl__RepairOrderId__c);
                line.dmpl__Discount__c = repairOrder.dmpl__Discount__c;
            }
            SecurityHelper.ensureCanWriteFields(
                new List<string>{
                'dmpl__Discount__c'
            }, 'dmpl__RepairOrderLine__c');
            update repairOrderLines;
        }
    }

    private static void setDefaultAddress(List<dmpl__RepairOrder__c> newEntries){
        SecurityHelper.ensureCanWriteFields(new List<String>
        {
            FIELD_REPAIRORDER_SHIPPINGADDRESS,
            FIELD_REPAIRORDER_BILLINGADDRESS,
            'dmpl__BillingCity__c',
            'dmpl__BillingCountry__c',
            'dmpl__BillingPostalCode__c',
            'dmpl__BillingRegion__c',
            'dmpl__BillingState__c',
            'dmpl__BillingStreet__c',
            'dmpl__ShippingCity__c',
            'dmpl__ShippingCountry__c',
            'dmpl__ShippingPostalCode__c',
            'dmpl__ShippingRegion__c',
            'dmpl__ShippingState__c',
            'dmpl__ShippingStreet__c'
        }, OBJECT_REPAIRORDER);

        List<Account> accounts = AccountHelper.getCachedAccounts(CollectionHelper.extractIds(newEntries, FIELD_REPAIRORDER_ACCOUNTID));
        for(dmpl__RepairOrder__c order : newEntries){
            Account account = (Account)CollectionHelper.getObject(accounts, order.dmpl__AccountId__c);
            if(account!=null){
                AccountHelper.setDefaultAddress(order, account);
            }
        }
    }

    private static void setDefaultAddress(List<dmpl__RepairOrder__c> newEntries, List<dmpl__RepairOrder__c> oldEntries){
        SecurityHelper.ensureCanWriteFields(new List<String>
        {
            FIELD_REPAIRORDER_SHIPPINGADDRESS,
            FIELD_REPAIRORDER_BILLINGADDRESS
        }, OBJECT_REPAIRORDER);
        Account account = null;
        List<Account> accounts = AccountHelper.getCachedAccounts(CollectionHelper.extractIds(newEntries, FIELD_REPAIRORDER_ACCOUNTID));
        List<dmpl__RepairOrder__c> modifiedOrders = DocumentHelper.getModifiedNewObjects(FIELD_REPAIRORDER_BILLINGADDRESSID, oldEntries, newEntries);
        for(dmpl__RepairOrder__c order : modifiedOrders){
            account = (Account)CollectionHelper.getObject(accounts, order.dmpl__AccountId__c);
            if(account!=null){
                AccountHelper.setDefaultAddress(order, account);
            }
        }
        
        modifiedOrders = DocumentHelper.getModifiedNewObjects(FIELD_REPAIRORDER_SHIPPINGADDRESSID, oldEntries, newEntries);
        for(dmpl__RepairOrder__c order : modifiedOrders){
            account = (Account)CollectionHelper.getObject(accounts, order.dmpl__AccountId__c);
            if(account!=null){
                if(order.dmpl__ShippingAddressId__c!=null){
                    dmpl__ContactAddress__c address = (dmpl__ContactAddress__c)CollectionHelper.getObject(account.dmpl__ContactAddress__r, order.dmpl__ShippingAddressId__c);
                    if(address!=null){
                        order.dmpl__ShippingAddress__c = AccountHelper.formatAddress(address);
                    }
                }else {
                    order.dmpl__ShippingAddress__c = AccountHelper.formatAddress(account.ShippingAddress);
                }
            }
        }
    }

    private static List<dmpl__RepairOrder__c> queryRepairOrders(List<ID> repairOrderIds)
    {
        SecurityHelper.ensureCanReadFields(new List<string>{
            'dmpl__ServiceRequestId__c',
            'dmpl__ServiceEstimateId__c'
            }, 'dmpl__RepairOrder__c');

        return [SELECT 
        ID,
        Name,
        dmpl__DocumentDate__c,
        dmpl__FailureDate__c,
        dmpl__AccountId__c,
        dmpl__PartnerAccountId__c,
        dmpl__BranchId__c,
        dmpl__ServiceRequestId__c,
        dmpl__ServiceEstimateId__c,
        dmpl__PerformInvoiceGeneration__c,
        dmpl__IsInvoiceGenerated__c,
        dmpl__AssetId__c,
        dmpl__ResetUsageHours__c,
        dmpl__UsageReadingHours__c,
        dmpl__UsageReading__c,
        dmpl__ResetUsageReading__c
        FROM dmpl__RepairOrder__c
        WHERE Id IN : repairOrderIds];
    }

    private static List<dmpl__InspectionLine__c> queryInspectionLines(List<ID> inspectionLineIds)
    {
        SecurityHelper.ensureCanReadFields(new List<string>{
            'dmpl__ItemLotId__c'
            }, 'dmpl__InspectionLine__c');

        SecurityHelper.ensureCanReadFields(new List<string>{
            'dmpl__RequireRepairOrderOnReceipt__c'
            }, 'dmpl__Item__c');

        SecurityHelper.ensureCanReadFields(new List<string>{
            'dmpl__PartnerAccountId__c',
            'dmpl__BranchId__c'
            }, 'dmpl__GoodsReceipt__c');
    
        return [SELECT 
        ID,
        Name,
        dmpl__ReceiptId__r.dmpl__PartnerAccountId__c,
        dmpl__ReceiptId__r.dmpl__BranchId__c,
        dmpl__ItemId__r.dmpl__RequireRepairOrderOnReceipt__c,
        dmpl__ItemLotId__c
        FROM dmpl__InspectionLine__c
        WHERE Id IN : inspectionLineIds];
    }

    private static List<dmpl__RepairOrderLine__c> queryRepairOrderLines(List<ID> repairOrderIds)
    {
        SecurityHelper.ensureCanReadFields(new string[]{
            'dmpl__ItemId__c',
            'dmpl__Quantity__c',
            'dmpl__RepairOrderId__c',
            'dmpl__ItemServiceContractId__c',
            'dmpl__AssetServiceContractLineId__c'}, 
            'dmpl__RepairOrderLine__c');

        return [SELECT
        ID,
        dmpl__ItemId__c,
        dmpl__Quantity__c,
        dmpl__RepairOrderId__c,
        dmpl__ItemServiceContractId__c,
        dmpl__AssetServiceContractLineId__c
        FROM dmpl__RepairOrderLine__c
        WHERE dmpl__RepairOrderId__c IN : repairOrderIds];
    }

    private static Map<Id, dmpl__AssetServiceContractLine__c> queryAssetServiceContractLines(List<ID> assetServiceContractLineIds)
    {
        SecurityHelper.ensureCanReadFields(new string[]{'dmpl__ComponentItemId__c','dmpl__UtilizedQuantity__c'}, 'dmpl__AssetServiceContractLine__c');
        SecurityHelper.ensureCanReadFields(new string[]{'dmpl__AssetId__c','dmpl__ItemServiceContractId__c'}, 'dmpl__AssetServiceContract__c');
        return new Map<Id, dmpl__AssetServiceContractLine__c>([SELECT
        ID,
        dmpl__ComponentItemId__c,
        dmpl__UtilizedQuantity__c,
        dmpl__AssetServiceContractId__r.dmpl__AssetId__c,
        dmpl__AssetServiceContractId__r.dmpl__ItemServiceContractId__c
        FROM dmpl__AssetServiceContractLine__c
        WHERE ID IN : assetServiceContractLineIds]);
    }
    
}