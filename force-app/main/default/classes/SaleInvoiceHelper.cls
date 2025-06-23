public with sharing class SaleInvoiceHelper {

    private static Boolean skipValidations = false;

    private static final string OBJECT_SALEINVOICE = 'dmpl__SaleInvoice__c';
    private static final string FIELD_SALEINVOICE_STATUS = 'dmpl__Status__c';
    private static final string FIELD_SALEINVOICE_PARTNERACCOUNTID = 'dmpl__PartnerAccountId__c';
    private static final string FIELD_SALEINVOICE_BRANCHID = 'dmpl__BranchId__c';
    private static final string FIELD_SALEINVOICE_ACCOUNTID ='dmpl__AccountId__c';
    private static final string FIELD_SALEINVOICE_DOCUMENTDATE ='dmpl__DocumentDate__c';
    private static final string FIELD_SALEINVOICE_SALEORDERID ='dmpl__SaleOrderId__c';
    private static final string FIELD_SALEINVOICE_ID ='Id';
    private static final string FIELD_SALEINVOICE_SERVICEADVISORID = 'dmpl__ServiceAdvisorId__c';
    private static final string FIELD_SALEINVOICE_SALESEXECUTIVEID = 'dmpl__SalesExecutiveId__c';

    private static final string FIELD_SALEINVOICE_AMOUNTPAID ='dmpl__AmountPaid__c';
    private static final string FIELD_SALEINVOICE_FINANCEAMOUNT ='dmpl__FinanceAmount__c';
    private static final string FIELD_SALEINVOICE_GLID ='dmpl__GeneralLedgerId__c';
    private static final string FIELD_SALEINVOICE_GLACCOUNTID ='dmpl__GLAccountId__c';
    private static final string FIELD_SALEINVOICE_INVOICEGROUP ='dmpl__InvoiceGroup__c';
    private static final string FIELD_SALEINVOICE_ISGLPOSTED ='dmpl__IsGLPosted__c';
    private static final string FIELD_SALEINVOICE_ISGLPOSTINGAPPROVED ='dmpl__IsGLPostingApproved__c';
    private static final string FIELD_SALEINVOICE_PRICELISTID ='dmpl__PriceListId__c';
    private static final string FIELD_SALEINVOICE_PERFORMGLPOSTING ='dmpl__PerformGLPosting__c';
    private static final string FIELD_SALEINVOICE_PERFORMKPICALCULATION = 'dmpl__PerformKPICalculation__c';
    
    private static final string FIELD_SALEINVOICE_TAXGROUPID = 'dmpl__TaxGroupId__c';
    private static final string FIELD_SALEINVOICE_TAXID = 'dmpl__TaxId__c';
    private static final string FIELD_SALEINVOICEL_AMOUNT = 'dmpl__TotalLineAmount__c';
    private static final string FIELD_SALEINVOICE_GROSSAMOUNT = 'dmpl__TotalLineGrossAmount__c';
    private static final string FIELD_SALEINVOICE_TCSELIGIBLEAMOUNT = 'dmpl__TCSEligibleAmount__c';
    
    private static final string FIELD_AGG_SALEINVOICEID ='SaleInvoiceId';
    private static final string FIELD_AGG_TOTALPAYMENTAMOUNT ='TotalPaymentAmount';

    private static final string FIELD_SALEINVOICE_BILLINGADDRESS ='dmpl__BillingAddress__c';
    private static final string FIELD_SALEINVOICE_SHIPPINGADDRESS ='dmpl__ShippingAddress__c';
    private static final string FIELD_SALEINVOICE_BILLINGADDRESSID ='dmpl__BillingAddressId__c';
    private static final string FIELD_SALEINVOICE_SHIPPINGADDRESSID ='dmpl__ShippingAddressId__c';

    private static final string FIELD_SALEINVOICELINE_SALEINVOICEID ='dmpl__SaleInvoiceId__c';
    private static final string RELATION_SALEINVOICE_SALEINVOICELINES = 'dmpl__SaleInvoiceLines__r';

    private static final List<String> LIST_NON_EDITABLE_FIELDS = new List<String>{
        FIELD_SALEINVOICE_SALEORDERID,
        FIELD_SALEINVOICE_ACCOUNTID, 
        FIELD_SALEINVOICE_PARTNERACCOUNTID, 
        FIELD_SALEINVOICE_BRANCHID, 
        FIELD_SALEINVOICE_DOCUMENTDATE};
    private static final List<String> LIST_FIELDS_SOURCEPOULATED = new List<String>{
        FIELD_SALEINVOICE_PARTNERACCOUNTID, 
        FIELD_SALEINVOICE_BRANCHID,
        FIELD_SALEINVOICE_ACCOUNTID};
    private static final List<String> LIST_FIELDS_SYSTEM = new List<String>{
        FIELD_SALEINVOICE_FINANCEAMOUNT,
        FIELD_SALEINVOICE_AMOUNTPAID, 
        FIELD_SALEINVOICE_GLID, 
        FIELD_SALEINVOICE_ISGLPOSTED};
    
    public static void validateData(
        Boolean isInsert, 
        Boolean isDelete, 
        Boolean isUpdate, 
        List<dmpl__SaleInvoice__c> oldEntries, 
        List<dmpl__SaleInvoice__c> newEntries){   
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
                    OBJECT_SALEINVOICE, 
                    FIELD_SALEINVOICE_STATUS, 
                    newEntries);
                ValidationHelper.validatePartnerAndBranch(
                    FIELD_SALEINVOICE_PARTNERACCOUNTID, 
                    FIELD_SALEINVOICE_BRANCHID, 
                    newEntries);
                ValidationHelper.validateResource(
                    FIELD_SALEINVOICE_SERVICEADVISORID, 
                    newEntries);
                ValidationHelper.validateResource(
                    FIELD_SALEINVOICE_SALESEXECUTIVEID, 
                    newEntries);
            }else if(isUpdate){
                StatusHelper.validateStatusEdit(
                    OBJECT_SALEINVOICE, 
                    FIELD_SALEINVOICE_STATUS, 
                    oldEntries, 
                    newEntries);
                DocumentHelper.validateChangeInSystemFields(
                    LIST_FIELDS_SYSTEM, 
                    oldEntries, 
                    newEntries);
                DocumentHelper.validateChangeInKeyFields(
                    LIST_NON_EDITABLE_FIELDS, 
                    oldEntries, 
                    newEntries,
                    queryTransactedObjectIds(
                        newEntries));
                DocumentHelper.validateChangeInSourcePopulatedFields(
                    LIST_FIELDS_SOURCEPOULATED, 
                    oldEntries, 
                    newEntries, 
                    FIELD_SALEINVOICE_SALEORDERID);
                dfsHelper.DocumentStatusRestrictEdits_Edit(
                    OBJECT_SALEINVOICE, 
                    FIELD_SALEINVOICE_STATUS, 
                    oldEntries, 
                    newEntries);
                dfsHelper.DocumentStatusRestrictFieldsEdits(
                    OBJECT_SALEINVOICE, 
                    FIELD_SALEINVOICE_STATUS, 
                    oldEntries, 
                    newEntries);
                ValidationHelper.validateResource(
                    FIELD_SALEINVOICE_SERVICEADVISORID, 
                    newEntries);
                ValidationHelper.validateResource(
                    FIELD_SALEINVOICE_SALESEXECUTIVEID, 
                    newEntries);
            }else if(isDelete){
                dfsHelper.DocumentStatusRestrictEdits_Delete(
                    OBJECT_SALEINVOICE, 
                    FIELD_SALEINVOICE_STATUS, 
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
        List<dmpl__SaleInvoice__c> oldEntries, 
        List<dmpl__SaleInvoice__c> newEntries){
        try{
            DocumentStatusDFSHelper dfsHelper = new DocumentStatusDFSHelper();
        if(isInsert){
            dfsHelper.DocumentStatusSetFlag(
                OBJECT_SALEINVOICE, 
                FIELD_SALEINVOICE_STATUS, 
                newEntries);
            dfsHelper.DocumentStatusReSetFlag(
                OBJECT_SALEINVOICE, 
                FIELD_SALEINVOICE_STATUS, 
                newEntries);
            PriceListHelper.setDefaultPriceListIds(
                newEntries);
            DiscountGroupHelper.setDefaultDiscountGroupIds(
                newEntries);
            FinanceCaseHelper.updateFinanceCaseTaggingToInvoice(
                newEntries);
            PaymentHelper.updatePaymentsTaggingToInvoice(
                newEntries);
            setDefaultAddress(
                newEntries);
            DocumentNameHelper.generateDocumentName(
                newEntries);
            TaxHelper.setHeaderTaxes(
                newEntries);
        }else if(isUpdate){
            dfsHelper.DocumentStatusSetFlag(
                OBJECT_SALEINVOICE, 
                FIELD_SALEINVOICE_STATUS, 
                oldEntries, 
                newEntries);
            dfsHelper.DocumentStatusReSetFlag(
                OBJECT_SALEINVOICE, 
                FIELD_SALEINVOICE_STATUS, 
                oldEntries, 
                newEntries);
            List<dmpl__SaleInvoice__c> modifiedObjects = DocumentHelper.getApprovedObjects(
                FIELD_SALEINVOICE_PERFORMGLPOSTING, 
                oldEntries, 
                newEntries);
            if(modifiedObjects.size()>0){
                PostGL(modifiedObjects);
            }
            modifiedObjects = DocumentHelper.getApprovedObjects(
                FIELD_SALEINVOICE_ISGLPOSTINGAPPROVED, 
                oldEntries, 
                newEntries);
            if(modifiedObjects.Size() > 0){
                GeneralLedgerHelper.createLedger(
                    GeneralLedgerTypeEnums.Invoice, 
                    isInsert, 
                    isDelete, 
                    isUpdate, 
                    oldEntries, 
                    newEntries);
            }
            modifiedObjects = DocumentHelper.getApprovedObjects(
                FIELD_SALEINVOICE_PERFORMKPICALCULATION, 
                oldEntries, 
                newEntries);
            if(modifiedObjects.size()>0){
                updatePerformanceKPI(
                    modifiedObjects);
            }
            modifiedObjects = DocumentHelper.getModifiedNewObjects(new string[]{
                FIELD_SALEINVOICE_TAXGROUPID,
                FIELD_SALEINVOICE_TAXID,
                FIELD_SALEINVOICE_TCSELIGIBLEAMOUNT
                    }, oldEntries, newEntries);
                    if(modifiedObjects.size()>0){
                        TaxHelper.setHeaderTaxes(
                            modifiedObjects);
                    }
            setDefaultAddress(
                newEntries, 
                oldEntries);
            RoundOffHelper.setRoundOff(
                newEntries,
                'dmpl__TotalLineAmount__c',
                'dmpl__TotalTaxAmount2__c');
        }else if(isDelete){
            TaxHelper.deleteHeaderTaxes(oldEntries);
        }
    }
        catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }

    public static void afterPostData(
        Boolean isInsert, 
        Boolean isDelete, 
        Boolean isUpdate, 
        List<dmpl__SaleInvoice__c> oldEntries, 
        List<dmpl__SaleInvoice__c> newEntries)
    {
        if(isInsert){
            TaxHelper.createHeaderTaxes(
                isInsert, 
                newEntries);
        }else if(isUpdate){
            List<dmpl__SaleInvoice__c> modifiedObjects = DocumentHelper.getModifiedNewObjects(
                'dmpl__Discount__c', 
                oldEntries, 
                newEntries);
            if(modifiedObjects.size()>0){
                updateDiscountInSaleInvoiceLines(modifiedObjects);
            }
            modifiedObjects = DocumentHelper.getModifiedNewObjects(new string[]{
                FIELD_SALEINVOICE_TAXGROUPID,
                FIELD_SALEINVOICE_TAXID,
                FIELD_SALEINVOICE_TCSELIGIBLEAMOUNT
            }, oldEntries, newEntries);
            if(modifiedObjects.size()>0){
                TaxHelper.createHeaderTaxes(
                    isInsert, 
                    modifiedObjects);
            }
            modifiedObjects = DocumentHelper.getModifiedNewObjects(
                'dmpl__PriceAsOnDate__c', 
                oldEntries, 
                newEntries);
            if(modifiedObjects.size()>0){
                SaleInvoiceLineHelper.performReprice(
                    CollectionHelper.extractIds(modifiedObjects));
            }

            modifiedObjects = DocumentHelper.getModifiedNewObjects(
                'dmpl__SkipScheme__c', 
                oldEntries, 
                newEntries);
            if(modifiedObjects.size()>0){
                SchemeEngine.processSchemes(modifiedObjects);
            }
        }
    }

    public static void createSaleInvoiceForAllFromSaleOrder(
        List<dmpl__SaleOrder__c> saleOrders){
        dmpl__CreateRelatedSetting__mdt setting = CreateRelatedSettingHelper.getCreateRelatedSettingsWithTag(
            'dmpl__SaleOrder__c',
            'Release',
            'dmpl__SaleInvoice__c',
            'OTC');
        if(setting == null){
            createSaleInvoiceForAllFromSaleOrder(
                querySaleOrderLines(
                    DocumentHelper.extractIds(
                        saleOrders), 
                    null));
        }else {
            for(dmpl__SaleOrder__c order : saleOrders){
                DocumentSelectorController.releaseDocumentDirect(setting.Id, order.Id);
            }
        }
    }

    //Not beging used from any external class
    public static void createSaleInvoiceFromSaleOrder(
        List<dmpl__SaleOrder__c> saleOrders){
        dmpl__CreateRelatedSetting__mdt setting = CreateRelatedSettingHelper.getCreateRelatedSettingsWithTag(
            'dmpl__SaleOrder__c',
            'Release',
            'dmpl__SaleInvoice__c',
            'OTC');
        if(setting == null){
            createSaleInvoiceFromSaleOrder(
                querySaleOrderLines(
                    DocumentHelper.extractIds(
                        saleOrders), 
                    null), 
                null);
        }else {
            for(dmpl__SaleOrder__c order : saleOrders){
                DocumentSelectorController.releaseDocumentDirect(setting.Id, order.Id);
            }
        }
    }
    
    public static CreateRelatedResult createSaleInvoiceFromSaleOrder(
        Id saleOrderId){
        dmpl__CreateRelatedSetting__mdt setting = CreateRelatedSettingHelper.getCreateRelatedSettingsWithTag(
            'dmpl__SaleOrder__c',
            'Release',
            'dmpl__SaleInvoice__c',
            'OTC');
        if(setting == null){
            return CreateRelatedResult.InitFrom(
                createSaleInvoiceFromSaleOrder(
                    querySaleOrderLines(
                        New List<Id>{
                            saleOrderId
                        }, 
                    null), 
                null));
        }else {
            return DocumentSelectorController.releaseDocumentDirect(setting.Id, saleOrderId);
        }
    }

    public static CreateRelatedResult createSaleInvoiceFromSaleOrder(
        List<SourceObjectInfo> orderLinesInfo){
        return CreateRelatedResult.InitFrom(
            createSaleInvoiceFromSaleOrder(
                querySaleOrderLines(
                    null, 
                    SourceObjectInfo.extractIds(
                        orderLinesInfo)), 
                orderLinesInfo));
    }

    public static CreateRelatedResult createSaleInvoiceFromSaleOrder(
        List<SourceObjectInfo> orderLinesInfo, 
        Id saleInvoiceId){
        return CreateRelatedResult.InitFrom(
            createSaleInvoiceLinesFromSaleOrderInternal(
                querySaleOrderLines(
                    null, 
                    SourceObjectInfo.extractIds(orderLinesInfo)),
                orderLinesInfo, 
                saleInvoiceId));
    }

    public static void createSaleInvoiceFromAllocatedLines(
        List<dmpl__SaleOrder__c> saleOrders){
        dmpl__CreateRelatedSetting__mdt setting = CreateRelatedSettingHelper.getCreateRelatedSettings(
            'dmpl__SaleOrder__c',
            'Release',
            'dmpl__SaleInvoice__c');
        if(setting == null){
            createSaleInvoiceFromAllocatedLines(
                querySaleOrderLines(
                    DocumentHelper.extractIds(saleOrders), 
                    null), 
                null);
        }else {
            for(dmpl__SaleOrder__c order : saleOrders){
                DocumentSelectorController.releaseDocumentDirect(setting.Id, order.Id);
            }
        }
    }

    public static CreateRelatedResult createSaleInvoiceFromAllocatedLines(
        List<SourceObjectInfo> orderLinesInfo){
        return CreateRelatedResult.InitFrom(
            createSaleInvoiceFromAllocatedLines(
                querySaleOrderLines(
                    null, 
                    SourceObjectInfo.extractIds(orderLinesInfo)), 
            orderLinesInfo));
    }

    public static CreateRelatedResult createSaleInvoiceFromAllocatedLines(
        Id saleOrderId){
        dmpl__CreateRelatedSetting__mdt setting = CreateRelatedSettingHelper.getCreateRelatedSettings(
            'dmpl__SaleOrder__c',
            'Release',
            'dmpl__SaleInvoice__c');
        if(setting == null){
            return CreateRelatedResult.InitFrom(
                createSaleInvoiceFromAllocatedLines(
                    querySaleOrderLines(
                        New List<Id>{saleOrderId}, 
                    null), 
                null));
        }else {
            return DocumentSelectorController.releaseDocumentDirect(setting.Id, saleOrderId);
        }
    }

    public static void createSaleInvoiceFromDeliveryOrder(
        List<dmpl__DeliveryOrder__c> deliveryOrders){
            dmpl__CreateRelatedSetting__mdt setting = CreateRelatedSettingHelper.getCreateRelatedSettings(
            'dmpl__DeliveryOrder__c',
            'Release',
            'dmpl__SaleInvoice__c');
            if(setting == null){
                List<dmpl__DeliveryOrderLine__c> deliveryLines = queryDeliveryOrderLines(
                    DocumentHelper.extractIds(deliveryOrders),
                        null);
                createSaleInvoiceFromDeliveryLines(
                    deliveryLines,
                    querySaleOrderLines(
                        null,
                        DocumentHelper.extractIds(
                            deliveryLines,
                            'dmpl__SaleOrderLineId__c')),
                    null);
            }else {
                for(dmpl__DeliveryOrder__c order : deliveryOrders){
                    DocumentSelectorController.releaseDocumentDirect(setting.Id, order.Id);
                }
            }
    }

    public static CreateRelatedResult createSaleInvoiceFromDeliveryOrder(
        List<SourceObjectInfo> orderLinesInfo){
            List<dmpl__DeliveryOrderLine__c> deliveryLines = queryDeliveryOrderLines(
                null,
                SourceObjectInfo.extractIds(orderLinesInfo));
            return CreateRelatedResult.InitFrom(
                createSaleInvoiceFromDeliveryLines(
                    deliveryLines,
                    querySaleOrderLines(
                        null, 
                        DocumentHelper.extractIds(
                            deliveryLines,
                            'dmpl__SaleOrderLineId__c')), 
                    orderLinesInfo));
    }

    public static CreateRelatedResult createSaleInvoiceFromDeliveryOrder(
        Id deliveryOrderId){
            dmpl__CreateRelatedSetting__mdt setting = CreateRelatedSettingHelper.getCreateRelatedSettings(
                'dmpl__DeliveryOrder__c',
                'Release',
                'dmpl__SaleInvoice__c');
            if(setting == null){
                List<dmpl__DeliveryOrderLine__c> deliveryLines = queryDeliveryOrderLines(
                new List<Id>{deliveryOrderId},
                null);
                return CreateRelatedResult.InitFrom(
                    createSaleInvoiceFromDeliveryLines(
                        deliveryLines,
                        querySaleOrderLines(
                            null,
                            DocumentHelper.extractIds(
                                deliveryLines,
                                'dmpl__SaleOrderLineId__c')),
                        null));
            }else {
                return DocumentSelectorController.releaseDocumentDirect(setting.Id, deliveryOrderId);
            }
    }

    public static CreateRelatedResult createServiceInvoice(
        List<dmpl__RepairOrder__c> repairOrders){
            return CreateRelatedResult.InitFrom(
                createServiceInvoiceInternal(
                    queryRepairOrderLines(
                        DocumentHelper.extractIds(repairOrders),
                        null),
                    null));
    }

    public static CreateRelatedResult createServiceInvoice(Id repairOrderId){
            return CreateRelatedResult.InitFrom(
                createServiceInvoiceInternal(
                    queryRepairOrderLines(
                        new List<Id>{repairOrderId}, 
                        null),
                    null));
    }

    public static CreateRelatedResult createServiceInvoice(List<SourceObjectInfo> orderLinesInfo){
        return CreateRelatedResult.InitFrom(
            createServiceInvoiceInternal(
                queryRepairOrderLines(
                    null, 
                    SourceObjectInfo.extractIds(orderLinesInfo)),
                orderLinesInfo));
    }

    public static void createSaleInvoiceFromClaim(
        List<dmpl__Claim__c> newEntries){
        createSaleInvoiceFromClaimDocument(
            newEntries);
    }

    public static void createSaleInvoiceFromClaimBatch(
        List<dmpl__ClaimBatch__c> newEntries){
        createSaleInvoiceFromClaimBatchDocument(newEntries);
    }

    public static Map<Id, dmpl__SaleInvoice__c> createSaleInvoicesFromSelectedSaleOrderLines(
        List<Id> saleOrderLineIds,
        List<dmpl__SaleOrderLine__c> saleOrderLinesDraftValues,
        List<String> editableFields){
        List<dmpl__SaleOrderLine__c> selectedSaleOrderLines = querySaleOrderLines(
            new List<Id>(), 
            saleOrderLineIds);
        List<dmpl__SaleOrderLine__c> pendingOrderLines = new List<dmpl__SaleOrderLine__c>();
        for(dmpl__SaleOrderLine__c saleOrderLine : selectedSaleOrderLines){
            if(saleOrderLine.dmpl__PendingFulfilmentOrderQuantity__c >0){
                pendingOrderLines.Add(saleOrderLine);
            }
        }
        if(pendingOrderLines.size() == 0){
            throw new DMPLException(
                String.format(
                    String.valueOf(System.Label.Generic_EmptyActionParam), new String[]{dmpl__SaleOrderLine__c.class.getName()}));
        }

        Map<String, dmpl__SaleInvoice__c> newSaleInvoices = new Map<String, dmpl__SaleInvoice__c>();
        Map<dmpl__SaleInvoiceLine__c, String> newSaleInvoiceLines = new Map<dmpl__SaleInvoiceLine__c, String>();
        for(dmpl__SaleOrderLine__c saleOrderLine : pendingOrderLines)
        {
            Boolean isFound = false;
            dmpl__SaleInvoice__c currentSaleInvoice = null;
            for(dmpl__SaleInvoice__c saleInvoice : newSaleInvoices.values())
            {

                if(saleInvoice.dmpl__PartnerAccountId__c == saleOrderLine.dmpl__SaleOrderId__r.dmpl__PartnerAccountId__c 
                && saleInvoice.dmpl__BranchId__c == saleOrderLine.dmpl__SaleOrderId__r.dmpl__BranchId__c
                && saleInvoice.dmpl__AccountId__c == saleOrderLine.dmpl__SaleOrderId__r.dmpl__AccountId__c
                && saleInvoice.dmpl__InvoiceGroup__c == saleOrderLine.dmpl__InvoiceGroup__c)
                {
                    currentSaleInvoice = saleInvoice;
                    isFound = true;
                }
            }

            if(!isFound)
            {
                currentSaleInvoice = createSaleInvoiceDocument(saleOrderLine.dmpl__InvoiceGroup__c, saleOrderLine);
                newSaleInvoices.put(getNewSaleInvoiceKey(currentSaleInvoice), currentSaleInvoice);
            }

            if(editableFields.size() > 0)
            {
                for(String editableField : editableFields)
                    for(dmpl__SaleOrderLine__c draftValue : saleOrderLinesDraftValues)
                        if(draftValue.Id == saleOrderLine.Id && draftValue.get(editableField) != null && draftValue.get(editableField) != saleOrderLine.get(editableField))
                            saleOrderLine.put(editableField, draftValue.get(editableField));
            }

            newSaleInvoiceLines.put(createSaleInvoiceLine(saleOrderLine, saleOrderLine.dmpl__Quantity__c > saleOrderLine.dmpl__PendingInvoiceQuantity__c ?  saleOrderLine.dmpl__PendingInvoiceQuantity__c : saleOrderLine.dmpl__Quantity__c), getNewSaleInvoiceKey(currentSaleInvoice));
        }

        if(newSaleInvoices.size() >0){
            Savepoint sp = Database.setSavepoint();
            try {
                    SecurityHelper.ensureCanCreateObject('dmpl__SaleInvoice__c');
                    SecurityHelper.ensureCanCreateFields(new string[]{'dmpl__BranchId__c','dmpl__PartnerAccountId__c','dmpl__DocumentDate__c','dmpl__AccountId__c','dmpl__InvoiceGroup__c','dmpl__SaleOrderId__c','dmpl__PriceListId__c','dmpl__DiscountGroupId__c'}, 'dmpl__SaleInvoice__c');
                    insert newSaleInvoices.values();
                    List<dmpl__SaleInvoiceLine__c> saleInvoiceLinesList = new List<dmpl__SaleInvoiceLine__c>();
                    for(dmpl__SaleInvoiceLine__c saleInvoiceLine : newSaleInvoiceLines.keySet()){
                        dmpl__SaleInvoice__c currentSaleInvoice = newSaleInvoices.get(newSaleInvoiceLines.get(saleInvoiceLine));
                        if(currentSaleInvoice != null)
                        {
                            saleInvoiceLine.dmpl__SaleInvoiceId__c = currentSaleInvoice.Id;
                            saleInvoiceLinesList.add(saleInvoiceLine);
                        }
                    }
                    SaleInvoiceLineHelper.createSaleInvoiceFromSaleOrder(saleInvoiceLinesList);
            } catch (Exception e) {
                Database.rollback(sp);
                throw e;
            }
        }
        return new Map<Id, dmpl__SaleInvoice__c>(newSaleInvoices.values());
    }

    @testVisible
    private static string getNewSaleInvoiceKey(dmpl__SaleInvoice__c saleInvoice)
    {
        return saleInvoice.dmpl__PartnerAccountId__c+'-'+saleInvoice.dmpl__BranchId__c+'-'+saleInvoice.dmpl__AccountId__c+'-'+saleInvoice.dmpl__InvoiceGroup__c;
    }

    private static void updatePerformanceKPI(List<dmpl__SaleInvoice__c> newEntries)
    {
        PerformanceKPIHelper.upsertPerformanceKPI(OBJECT_SALEINVOICE, 'SCHEME', newEntries);
        PerformanceKPIHelper.upsertPerformanceKPI(OBJECT_SALEINVOICE, 'INCENTIVE', newEntries);
        for(dmpl__SaleInvoice__c lineEntry : newEntries)
        {
            lineEntry.dmpl__PerformKPICalculation__c = false;
            lineEntry.dmpl__IsKPICalculated__c = true;
        }
    }

    private static void createSaleInvoiceFromClaimDocument(List<dmpl__Claim__c> newEntries)
    {
        List<dmpl__SaleInvoice__c> newInvoiceDocuments = new List<dmpl__SaleInvoice__c>();
        Map<Id, Claim__c> claims = new Map<Id, dmpl__Claim__c>(queryClaims(DocumentHelper.extractIds(newEntries)));

        for(Claim__c claim : newEntries)
        {
            List<dmpl__ClaimLine__c> claimLines = claims.get(claim.ID).dmpl__Claim_Lines1__r;
            if(claimLines != null && claimLines.size() > 0 && canCreateSaleInvoice(claimLines))
                newInvoiceDocuments.Add(createSaleInvoiceDocument(claim));
        }

        if(newInvoiceDocuments.size() >0){
            List<dmpl__InventoryFulfillmentAllocationLine__c> allocationLines = queryFulfillmentAllocationLines(
                DocumentHelper.extractIds(claims.values(), 'dmpl__Claim_Lines1__r', 'dmpl__RepairOrderLineId__c'));
            Savepoint sp = Database.setSavepoint();
            try {
                    SecurityHelper.ensureCanCreateObject('dmpl__SaleInvoice__c');
                    SecurityHelper.ensureCanCreateFields(new string[]{'dmpl__PartnerAccountId__c','dmpl__BranchId__c','dmpl__ClaimId__c','dmpl__DocumentDate__c','dmpl__SupplierAccountId__c'}, 'dmpl__SaleInvoice__c');
                    insert newInvoiceDocuments;
                    SaleInvoiceLineHelper.createSaleInvoiceLinesFromClaim(newInvoiceDocuments, claims, allocationLines);
            } catch (Exception e) {
                Database.rollback(sp);
                throw e;
            }
        }
    }

    private static void createSaleInvoiceFromClaimBatchDocument(List<dmpl__ClaimBatch__c> newEntries)
    {
        List<dmpl__SaleInvoice__c> newInvoiceDocuments = new List<dmpl__SaleInvoice__c>();
        Map<Id, dmpl__ClaimBatch__c> claimBatches = new Map<Id, dmpl__ClaimBatch__c>(queryClaimBatch(DocumentHelper.extractIds(newEntries)));

        for(dmpl__ClaimBatch__c claimBatch : newEntries)
        {
            List<dmpl__ClaimLine__c> claimLines = claimBatches.get(claimBatch.ID).dmpl__ClaimLines__r;
            if(claimLines != null && claimLines.size() > 0 && canCreateSaleInvoice(claimLines))
                newInvoiceDocuments.Add(createSaleInvoiceDocument(claimBatch));
        }

        if(newInvoiceDocuments.size() >0){
            Savepoint sp = Database.setSavepoint();
            try {
                List<dmpl__InventoryFulfillmentAllocationLine__c> allocationLines = queryFulfillmentAllocationLines(
                    DocumentHelper.extractIds(claimBatches.values(), 'dmpl__ClaimLines__r', 'dmpl__RepairOrderLineId__c'));
                    SecurityHelper.ensureCanCreateObject('dmpl__SaleInvoice__c');
                    SecurityHelper.ensureCanCreateFields(new string[]{'dmpl__PartnerAccountId__c','dmpl__BranchId__c','dmpl__ClaimBatchId__c','dmpl__DocumentDate__c','dmpl__SupplierAccountId__c'}, 'dmpl__SaleInvoice__c');
                    insert newInvoiceDocuments;
                    SaleInvoiceLineHelper.createSaleInvoiceLinesFromClaimBatch(newInvoiceDocuments, claimBatches, allocationLines);
            } catch (Exception e) {
                Database.rollback(sp);
                throw e;
            }
        }
    }

    @TestVisible
    private static dmpl__SaleInvoice__c createSaleInvoiceDocument(dmpl__Claim__c claim)
    {
        return new dmpl__SaleInvoice__c(
            dmpl__BranchId__c = claim.dmpl__BranchId__c,
            dmpl__PartnerAccountId__c = claim.dmpl__PartnerAccountId__c,
            dmpl__DocumentDate__c = System.today(),
            dmpl__SupplierAccountId__c = claim.dmpl__SupplierNameId__c,
            dmpl__ClaimId__c = claim.Id,
            dmpl__RepairOrderId__c = claim.dmpl__RepairOrderId__c
        );
    }

    @TestVisible
    private static dmpl__SaleInvoice__c createSaleInvoiceDocument(dmpl__ClaimBatch__c claimBatch)
    {
        return new dmpl__SaleInvoice__c(
            dmpl__BranchId__c = claimBatch.dmpl__BranchId__c,
            dmpl__PartnerAccountId__c = claimBatch.dmpl__PartnerAccountId__c,
            dmpl__DocumentDate__c = System.today(),
            dmpl__SupplierAccountId__c = claimBatch.dmpl__SupplierNameId__c,
            dmpl__ClaimBatchId__c = claimBatch.Id
        );
    }

    @testVisible
    private static Boolean canCreateSaleInvoice(List<dmpl__ClaimLine__c> claimLines)
    {
        for(dmpl__ClaimLine__c claimLine : claimLines)
            if(claimLine.dmpl__ClaimType__c == 'Reimbursment' && claimLine.dmpl__ApproveQuantity__c > 0)
                return true;
        return false;
    }

    public static void updatePaidAmount(List<Id> saleInvoiceIds){
        try{
            skipValidations = true;
            SecurityHelper.ensureCanReadFields(new string[]{'dmpl__SaleInvoiceId__c','dmpl__Amount__c'}, 'dmpl__Payment__c');
            List<AggregateResult> paymentAggregates = 
                [SELECT dmpl__SaleInvoiceId__c SaleInvoiceId, SUM(dmpl__Amount__c) TotalPaymentAmount
                FROM dmpl__Payment__c
                WHERE dmpl__SaleInvoiceId__c IN :saleInvoiceIds
                WITH SECURITY_ENFORCED
                GROUP BY dmpl__SaleInvoiceId__c];

            SecurityHelper.ensureCanReadFields(new string[]{'dmpl__AmountPaid__c'}, 'dmpl__SaleInvoice__c');
            List<dmpl__SaleInvoice__c> invoicesToUpdate = 
            [
                SELECT Id, dmpl__AmountPaid__c
                FROM dmpl__SaleInvoice__c
                WHERE Id IN :saleInvoiceIds
            ];

            for(dmpl__SaleInvoice__c invoice : invoicesToUpdate){
                invoice.dmpl__AmountPaid__c = 0;
                for(AggregateResult result : paymentAggregates){
                    if(result.get(FIELD_AGG_SALEINVOICEID) == invoice.Id){
                        invoice.dmpl__AmountPaid__c = result.get(FIELD_AGG_TOTALPAYMENTAMOUNT) ==null ? 0 : (Decimal)(result.get(FIELD_AGG_TOTALPAYMENTAMOUNT));
                        break;
                    }
                }
            }
            SecurityHelper.ensureCanWriteFields(new string[]{'dmpl__AmountPaid__c'}, 'dmpl__SaleInvoice__c');      
            Update invoicesToUpdate;
        }finally{
            skipValidations = false;
        }
    }

    public static void updateFinanceAmount(List<Id> saleInvoiceIds){
        try{
            skipValidations = true;
            SecurityHelper.ensureCanReadFields(new string[]{'dmpl__SaleInvoiceId__c','dmpl__DisbursedAmount__c'}, 'dmpl__FinanceCase__c');
            List<AggregateResult> paymentAggregates = 
                [SELECT dmpl__SaleInvoiceId__c SaleInvoiceId, SUM(dmpl__DisbursedAmount__c) TotalPaymentAmount
                FROM dmpl__FinanceCase__c
                WHERE dmpl__SaleInvoiceId__c IN :saleInvoiceIds
                WITH SECURITY_ENFORCED
                GROUP BY dmpl__SaleInvoiceId__c];

            SecurityHelper.ensureCanReadFields(new string[]{'dmpl__FinanceAmount__c'}, 'dmpl__SaleInvoice__c');
            List<dmpl__SaleInvoice__c> invoicesToUpdate = 
            [
                SELECT Id, dmpl__FinanceAmount__c
                FROM dmpl__SaleInvoice__c
                WHERE Id IN :saleInvoiceIds
            ];

            for(dmpl__SaleInvoice__c invoice : invoicesToUpdate){
                invoice.dmpl__FinanceAmount__c = 0;
                for(AggregateResult result : paymentAggregates){
                    if(result.get(FIELD_AGG_SALEINVOICEID) == invoice.Id){
                        invoice.dmpl__FinanceAmount__c = result.get(FIELD_AGG_TOTALPAYMENTAMOUNT) ==null ? 0 : (Decimal)(result.get(FIELD_AGG_TOTALPAYMENTAMOUNT));
                        break;
                    }
                }
            }
            SecurityHelper.ensureCanWriteFields(new string[]{'dmpl__FinanceAmount__c'}, 'dmpl__SaleInvoice__c');      
            Update invoicesToUpdate;
        }finally{
            skipValidations = false;
        }
    }

    @testVisible    
    private static Map<String, dmpl__SaleInvoice__c> createSaleInvoiceForAllFromSaleOrder(List<dmpl__SaleOrderLine__c> saleOrderLines)
    {
        if(saleOrderLines.size() == 0){
            throw new AuraException(String.format(String.valueOf(System.Label.Generic_EmptyActionParam), new String[]{dmpl__SaleOrderLine__c.class.getName()}));
        }

        List<dmpl__SaleOrderLine__c> pendingOrderLines = new List<dmpl__SaleOrderLine__c>();
        for(dmpl__SaleOrderLine__c saleOrderLine : saleOrderLines){
            if(saleOrderLine.dmpl__PendingFulfilmentOrderQuantity__c >0 || saleOrderLine.dmpl__PendingAllocatedInvoicedQuantity__c >0){
                pendingOrderLines.Add(saleOrderLine);
            }
        }
        if(pendingOrderLines.size() == 0){
            throw new AuraException(String.format(String.valueOf(System.Label.Generic_EmptyActionParam), new String[]{dmpl__SaleOrderLine__c.class.getName()}));
        }

        List<string> distinctInvoiceGroups = getDistinctInvoiceGroups(pendingOrderLines);
        List<dmpl__InventoryFulfillmentAllocationLine__c> allocationLines = queryFulfillmentAllocationLines(DocumentHelper.extractIds(pendingOrderLines));
        Map<String, dmpl__SaleInvoice__c> saleInvoices = new Map<String, dmpl__SaleInvoice__c>();
        Map<String, List<dmpl__SaleInvoiceLine__c>> allSaleInvoiceLines = new Map<String, List<dmpl__SaleInvoiceLine__c>>();
        for(string invoiceGroup : distinctInvoiceGroups){
            for(dmpl__SaleOrderLine__c saleOrderLine : pendingOrderLines){
                String lineInvoiceGroup = saleOrderLine.dmpl__InvoiceGroup__c == null? dmpl__SaleInvoice__c.class.getName() : saleOrderLine.dmpl__InvoiceGroup__c;
                if(lineInvoiceGroup != invoiceGroup){
                    continue;
                }

                String invoiceGroupBatch = invoiceGroup + String.valueOf(saleOrderLine.dmpl__SaleOrderId__c);
                List<dmpl__SaleInvoiceLine__c> saleInvoiceLines = allSaleInvoiceLines.get(invoiceGroupBatch);
                if(saleInvoiceLines == null){
                    saleInvoiceLines = new List<dmpl__SaleInvoiceLine__c>();
                    allSaleInvoiceLines.put(invoiceGroupBatch, saleInvoiceLines);
                }
                
                dmpl__SaleInvoice__c saleInvoiceDocument = saleInvoices.get(invoiceGroupBatch);
                if(saleInvoiceDocument == null){
                    saleInvoiceDocument = createSaleInvoiceDocument(invoiceGroup, saleOrderLine);
                    saleInvoices.put(invoiceGroupBatch, saleInvoiceDocument);
                }
                List<dmpl__InventoryFulfillmentAllocationLine__c> filterdAllocationLines = new List<dmpl__InventoryFulfillmentAllocationLine__c>();
                if(allocationLines.Size() > 0)
                    filterdAllocationLines = DocumentHelper.getObjectsByFilter(allocationLines,'dmpl__FulfillmentOrderLineId__r','dmpl__SaleOrderLineId__c', saleOrderLine.Id);
                
                Decimal requestedQty = 0;
                if(filterdAllocationLines.Size() > 0)
                    saleInvoiceLines.addAll(createSaleInvoiceLine(saleOrderLine, filterdAllocationLines, requestedQty));
                else
                    saleInvoiceLines.add(createSaleInvoiceLine(saleOrderLine, requestedQty));
            }
        }

        if(saleInvoices.size() >0){
            Savepoint sp = Database.setSavepoint();
            try {
                    SecurityHelper.ensureCanCreateObject('dmpl__SaleInvoice__c');
                    SecurityHelper.ensureCanCreateFields(new string[]{'dmpl__BranchId__c','dmpl__PartnerAccountId__c','dmpl__DocumentDate__c','dmpl__AccountId__c','dmpl__InvoiceGroup__c','dmpl__SaleOrderId__c','dmpl__PriceListId__c','dmpl__DiscountGroupId__c'}, 'dmpl__SaleInvoice__c');
                    upsert saleInvoices.values();
                    List<dmpl__SaleInvoiceLine__c> saleInvoiceLinesList = new List<dmpl__SaleInvoiceLine__c>();
                    for(string invoiceGroup : saleInvoices.keySet()){
                        dmpl__SaleInvoice__c saleInvoiceDocument = saleInvoices.get(invoiceGroup);
                        List<dmpl__SaleInvoiceLine__c> saleInvoiceLines = allSaleInvoiceLines.get(invoiceGroup);
                        for(dmpl__SaleInvoiceLine__c saleInvoiceLine : saleInvoiceLines){
                            saleInvoiceLine.dmpl__SaleInvoiceId__c = saleInvoiceDocument.Id;
                            saleInvoiceLinesList.add(saleInvoiceLine);
                        }
                    }
                    SaleInvoiceLineHelper.createSaleInvoiceFromSaleOrder(saleInvoiceLinesList);
            } catch (Exception e) {
                Database.rollback(sp);
                throw e;
            }
        }
        return saleInvoices;
    }

    private static Map<String, dmpl__SaleInvoice__c> createSaleInvoiceFromSaleOrder(
        List<dmpl__SaleOrderLine__c> saleOrderLines, 
        List<SourceObjectInfo> sourceObjectLists){
        if(saleOrderLines.size() == 0){
            throw new DMPLException(String.format(String.valueOf(System.Label.Generic_EmptyActionParam), new String[]{dmpl__SaleOrderLine__c.class.getName()}));
        }

        List<dmpl__SaleOrderLine__c> pendingOrderLines = new List<dmpl__SaleOrderLine__c>();
        for(dmpl__SaleOrderLine__c saleOrderLine : saleOrderLines){
            if(saleOrderLine.dmpl__PendingFulfilmentOrderQuantity__c >0){
                pendingOrderLines.Add(saleOrderLine);
            }
        }
        if(pendingOrderLines.size() == 0){
            throw new DMPLException(String.format(String.valueOf(System.Label.Generic_EmptyActionParam), new String[]{dmpl__SaleOrderLine__c.class.getName()}));
        }

        List<string> distinctInvoiceGroups = getDistinctInvoiceGroups(pendingOrderLines);
        Map<String, dmpl__SaleInvoice__c> saleInvoices = new Map<String, dmpl__SaleInvoice__c>();
        Map<String, List<dmpl__SaleInvoiceLine__c>> allSaleInvoiceLines = new Map<String, List<dmpl__SaleInvoiceLine__c>>();
        for(string invoiceGroup : distinctInvoiceGroups){
            for(dmpl__SaleOrderLine__c saleOrderLine : pendingOrderLines){
                String lineInvoiceGroup = saleOrderLine.dmpl__InvoiceGroup__c == null? dmpl__SaleInvoice__c.class.getName() : saleOrderLine.dmpl__InvoiceGroup__c;
                if(lineInvoiceGroup != invoiceGroup){
                    continue;
                }

                String invoiceGroupBatch = invoiceGroup + String.valueOf(saleOrderLine.dmpl__SaleOrderId__c);
                List<dmpl__SaleInvoiceLine__c> saleInvoiceLines = allSaleInvoiceLines.get(invoiceGroupBatch);
                if(saleInvoiceLines == null){
                    saleInvoiceLines = new List<dmpl__SaleInvoiceLine__c>();
                    allSaleInvoiceLines.put(invoiceGroupBatch, saleInvoiceLines);
                }
                
                SourceObjectInfo objectInfo = SourceObjectInfo.getSourceObjectInfo(sourceObjectLists, saleOrderLine.Id);
                dmpl__SaleInvoice__c saleInvoiceDocument = null;
                if(saleInvoices.containsKey(invoiceGroupBatch)){
                    saleInvoiceDocument = saleInvoices.get(invoiceGroupBatch);
                }else if(objectInfo!=null){
                    saleInvoiceDocument = querySaleInvoice(
                        objectInfo.getDestinationObjectId(invoiceGroupBatch));
                    
                }
                if(saleInvoiceDocument == null){
                    saleInvoiceDocument = createSaleInvoiceDocument(invoiceGroup, saleOrderLine);
                }
                if(!saleInvoices.containsKey(invoiceGroupBatch)){
                    saleInvoices.put(invoiceGroupBatch, saleInvoiceDocument);
                }
                saleInvoices.put(invoiceGroupBatch, saleInvoiceDocument);
                Decimal requestedQty = SourceObjectInfo.getRequestedQuantity(sourceObjectLists, saleOrderLine.Id);
                saleInvoiceLines.add(createSaleInvoiceLine(saleOrderLine, requestedQty));
            }
        }

        if(saleInvoices.size() >0){
            Savepoint sp = Database.setSavepoint();
            try {
                    SecurityHelper.ensureCanCreateObject('dmpl__SaleInvoice__c');
                    SecurityHelper.ensureCanCreateFields(new string[]{'dmpl__BranchId__c','dmpl__PartnerAccountId__c','dmpl__DocumentDate__c','dmpl__AccountId__c','dmpl__InvoiceGroup__c','dmpl__SaleOrderId__c','dmpl__PriceListId__c','dmpl__DiscountGroupId__c'}, 'dmpl__SaleInvoice__c');
                    upsert saleInvoices.values();
                    List<dmpl__SaleInvoiceLine__c> saleInvoiceLinesList = new List<dmpl__SaleInvoiceLine__c>();
                    for(string invoiceGroup : saleInvoices.keySet()){
                        dmpl__SaleInvoice__c saleInvoiceDocument = saleInvoices.get(invoiceGroup);
                        List<dmpl__SaleInvoiceLine__c> saleInvoiceLines = allSaleInvoiceLines.get(invoiceGroup);
                        for(dmpl__SaleInvoiceLine__c saleInvoiceLine : saleInvoiceLines){
                            saleInvoiceLine.dmpl__SaleInvoiceId__c = saleInvoiceDocument.Id;
                            saleInvoiceLinesList.add(saleInvoiceLine);
                        }
                    }
                    SaleInvoiceLineHelper.createSaleInvoiceFromSaleOrder(saleInvoiceLinesList);
            } catch (Exception e) {
                Database.rollback(sp);
                throw e;
            }
        }
        return saleInvoices;
    }

    @TestVisible
    private static Map<Id, dmpl__SaleInvoiceLine__c> createSaleInvoiceLinesFromSaleOrderInternal(
        List<dmpl__SaleOrderLine__c> saleOrderLines,
        List<SourceObjectInfo> orderLineInfo, Id saleInvoiceId){
        if(saleOrderLines.size() == 0){
            throw new DMPLException(
                String.format(
                    String.valueOf(System.Label.Generic_EmptyActionParam), 
                    new String[]{
                        dmpl__SaleOrderLine__c.class.getName()}));
        }

        List<dmpl__SaleInvoiceLine__c> saleInvoiceLines = new List<dmpl__SaleInvoiceLine__c>();
        for(dmpl__SaleOrderLine__c saleOrderLine : saleOrderLines){
            Decimal requestedQty = SourceObjectInfo.getRequestedQuantity(orderLineInfo, saleOrderLine.Id);
            saleInvoiceLines.add(createSaleInvoiceLine(saleOrderLine, requestedQty));
        }
        //
        if(saleInvoiceLines.size()>0){
            Savepoint sp = Database.setSavepoint();
            try {
                for(dmpl__SaleInvoiceLine__c invoiceLine : saleInvoiceLines){
                    invoiceLine.dmpl__SaleInvoiceId__c = saleInvoiceId;
                }    
                
                SaleInvoiceLineHelper.createSaleInvoiceFromSaleOrder(saleInvoiceLines);

            } catch (Exception e) {
                Database.rollback(sp);
                throw e;
            }
        }

        return new Map<Id, dmpl__SaleInvoiceLine__c>(saleInvoiceLines);
    }

    @TestVisible
    private static Map<String, dmpl__SaleInvoice__c> createSaleInvoiceFromAllocatedLines(List<dmpl__SaleOrderLine__c> saleOrderLines, List<SourceObjectInfo> orderLinesInfo)
    {
        System.debug('saleOrderLines '+saleOrderLines.size());
        if(saleOrderLines.size() == 0){
            throw new DMPLException(String.format(String.valueOf(System.Label.Generic_EmptyActionParam), new String[]{dmpl__SaleOrderLine__c.class.getName()}));
        }

        List<dmpl__SaleOrderLine__c> pendingOrderLines = new List<dmpl__SaleOrderLine__c>();
        for(dmpl__SaleOrderLine__c saleOrderLine : saleOrderLines){
            if(saleOrderLine.dmpl__PendingAllocatedInvoicedQuantity__c > 0){
                pendingOrderLines.Add(saleOrderLine);
            }
        }
        if(pendingOrderLines.size() == 0){
            throw new DMPLException(String.format(String.valueOf(System.Label.Generic_EmptyActionParam), new String[]{dmpl__SaleOrderLine__c.class.getName()}));
        }

        List<string> distinctInvoiceGroups = getDistinctInvoiceGroups(pendingOrderLines);
        List<dmpl__InventoryFulfillmentAllocationLine__c> allocationLines = queryFulfillmentAllocationLines(DocumentHelper.extractIds(pendingOrderLines));
        Map<String, dmpl__SaleInvoice__c> saleInvoices = new Map<String, dmpl__SaleInvoice__c>();
        Map<String, List<dmpl__SaleInvoiceLine__c>> allSaleInvoiceLines = new Map<String, List<dmpl__SaleInvoiceLine__c>>();
        for(string invoiceGroup : distinctInvoiceGroups){
            for(dmpl__SaleOrderLine__c saleOrderLine : pendingOrderLines){
                String lineInvoiceGroup = saleOrderLine.dmpl__InvoiceGroup__c == null? dmpl__SaleInvoice__c.class.getName() : saleOrderLine.dmpl__InvoiceGroup__c;
                if(lineInvoiceGroup != invoiceGroup){
                    continue;
                }

                String invoiceGroupBatch = invoiceGroup + String.valueOf(saleOrderLine.dmpl__SaleOrderId__c);
                SourceObjectInfo objectInfo = SourceObjectInfo.getSourceObjectInfo(orderLinesInfo, saleOrderLine.Id);
                List<dmpl__SaleInvoiceLine__c> saleInvoiceLines = allSaleInvoiceLines.get(invoiceGroupBatch);
                if(saleInvoiceLines == null){
                    saleInvoiceLines = new List<dmpl__SaleInvoiceLine__c>();
                    allSaleInvoiceLines.put(invoiceGroupBatch, saleInvoiceLines);
                }
                
                dmpl__SaleInvoice__c saleInvoiceDocument = saleInvoices.get(invoiceGroupBatch);
                if(saleInvoiceDocument == null && objectInfo!=null){
                    saleInvoiceDocument = querySaleInvoice(
                        objectInfo.getDestinationObjectId(invoiceGroupBatch));
                }
                if(saleInvoiceDocument == null){
                    saleInvoiceDocument = createSaleInvoiceDocument(invoiceGroup, saleOrderLine);
                }
                if(!saleInvoices.containsKey(invoiceGroupBatch)){
                    saleInvoices.put(invoiceGroupBatch, saleInvoiceDocument);
                }
                Decimal requestedQty = SourceObjectInfo.getRequestedQuantity(orderLinesInfo, saleOrderLine.Id);
                if(allocationLines.Size() > 0 && saleOrderLine.dmpl__ItemId__r.dmpl__TrackInventory__c == true){
                    saleInvoiceLines.addAll(createSaleInvoiceLine(saleOrderLine, allocationLines, requestedQty));
                }
                else if(saleOrderLine.dmpl__ItemId__r.dmpl__TrackInventory__c == false){
                    saleInvoiceLines.add(createSaleInvoiceLine(saleOrderLine, requestedQty));
                }
            }
        }

        if(saleInvoices.size() >0){
            Savepoint sp = Database.setSavepoint();
            try {
                    SecurityHelper.ensureCanCreateObject('dmpl__SaleInvoice__c');
                    SecurityHelper.ensureCanCreateFields(new string[]{'dmpl__BranchId__c','dmpl__PartnerAccountId__c','dmpl__DocumentDate__c','dmpl__AccountId__c','dmpl__InvoiceGroup__c','dmpl__SaleOrderId__c','dmpl__PriceListId__c','dmpl__DiscountGroupId__c'}, 'dmpl__SaleInvoice__c');
                    upsert saleInvoices.values();
                    List<dmpl__SaleInvoiceLine__c> saleInvoiceLinesList = new List<dmpl__SaleInvoiceLine__c>();
                    for(string invoiceGroup : saleInvoices.keySet()){
                        dmpl__SaleInvoice__c saleInvoiceDocument = saleInvoices.get(invoiceGroup);
                        List<dmpl__SaleInvoiceLine__c> saleInvoiceLines = allSaleInvoiceLines.get(invoiceGroup);
                        for(dmpl__SaleInvoiceLine__c saleInvoiceLine : saleInvoiceLines){
                            saleInvoiceLine.dmpl__SaleInvoiceId__c = saleInvoiceDocument.Id;
                            saleInvoiceLinesList.add(saleInvoiceLine);
                        }
                    }
                    SaleInvoiceLineHelper.createSaleInvoiceFromSaleOrder(saleInvoiceLinesList);
            } catch (Exception e) {
                Database.rollback(sp);
                throw e;
            }
        }
        return saleInvoices;
    }

    @TestVisible
    private static Map<String, dmpl__SaleInvoice__c> createSaleInvoiceFromDeliveryLines(
        List<dmpl__DeliveryOrderLine__c> deliveryOrderLines, 
        List<dmpl__SaleOrderLine__c> saleOrderLines, 
        List<SourceObjectInfo> orderLinesInfo){
        
        if(deliveryOrderLines.size() == 0){
            throw new DMPLException(String.format(String.valueOf(System.Label.Generic_EmptyActionParam), new String[]{dmpl__DeliveryOrderLine__c.class.getName()}));
        }
        if(saleOrderLines.size() == 0){
            throw new DMPLException(String.format(String.valueOf(System.Label.Generic_EmptyActionParam), new String[]{dmpl__SaleOrderLine__c.class.getName()}));
        }

        List<dmpl__SaleOrderLine__c> pendingOrderLines = new List<dmpl__SaleOrderLine__c>();
        for(dmpl__SaleOrderLine__c saleOrderLine : saleOrderLines){
            if(saleOrderLine.dmpl__PendingAllocatedInvoicedQuantity__c > 0){
                pendingOrderLines.add(saleOrderLine);
            }
        }
        List<dmpl__DeliveryOrderLine__c> pendingDeliveryLines = new List<dmpl__DeliveryOrderLine__c>();
        for(dmpl__DeliveryOrderLine__c deliveryOrderLine : deliveryOrderLines){
            if(deliveryOrderLine.dmpl__PendingInvoiceQuantity__c > 0){
                pendingDeliveryLines.add(deliveryOrderLine);
            }
        }
        if(pendingOrderLines.size() == 0){
            throw new DMPLException(String.format(String.valueOf(System.Label.Generic_EmptyActionParam), new String[]{dmpl__SaleOrderLine__c.class.getName()}));
        }
        if(pendingDeliveryLines.size() == 0){
            throw new DMPLException(String.format(String.valueOf(System.Label.Generic_EmptyActionParam), new String[]{dmpl__DeliveryOrderLine__c.class.getName()}));
        }

        List<string> distinctInvoiceGroups = getDistinctInvoiceGroups(pendingOrderLines);
        List<dmpl__InventoryFulfillmentAllocationLine__c> allocationLines = queryFulfillmentAllocationLinesFromIds(DocumentHelper.extractIds(deliveryOrderLines, 'dmpl__FulfillmentAllocationLineId__c'));
        Map<String, dmpl__SaleInvoice__c> saleInvoices = new Map<String, dmpl__SaleInvoice__c>();
        Map<String, List<dmpl__SaleInvoiceLine__c>> allSaleInvoiceLines = new Map<String, List<dmpl__SaleInvoiceLine__c>>();
        for(string invoiceGroup : distinctInvoiceGroups){
            for(dmpl__DeliveryOrderLine__c deliveryLine : deliveryOrderLines){
                if(!deliveryLine.dmpl__IsILPostingApproved__c && deliveryLine.dmpl__ItemId__r.dmpl__TrackInventory__c){
                    throw new DMPLException('DO Line not posted');
                }
                for(dmpl__SaleOrderLine__c saleOrderLine : pendingOrderLines){
                    if(deliveryLine.dmpl__SaleOrderLineId__c == saleOrderLine.Id){
                        String lineInvoiceGroup = saleOrderLine.dmpl__InvoiceGroup__c == null? dmpl__SaleInvoice__c.class.getName() : saleOrderLine.dmpl__InvoiceGroup__c;
                        if(lineInvoiceGroup != invoiceGroup){
                            continue;
                        }

                        String invoiceGroupBatch = invoiceGroup + String.valueOf(saleOrderLine.dmpl__SaleOrderId__c);
                        SourceObjectInfo objectInfo = SourceObjectInfo.getSourceObjectInfo(orderLinesInfo, deliveryLine.Id);
                        List<dmpl__SaleInvoiceLine__c> saleInvoiceLines = allSaleInvoiceLines.get(invoiceGroupBatch);
                        if(saleInvoiceLines == null){
                            saleInvoiceLines = new List<dmpl__SaleInvoiceLine__c>();
                            allSaleInvoiceLines.put(invoiceGroupBatch, saleInvoiceLines);
                        }
                        
                        dmpl__SaleInvoice__c saleInvoiceDocument = saleInvoices.get(invoiceGroupBatch);
                        if(saleInvoiceDocument == null && objectInfo!=null){
                            saleInvoiceDocument = querySaleInvoice(
                                objectInfo.getDestinationObjectId(invoiceGroupBatch));
                        }
                        if(saleInvoiceDocument == null){
                            saleInvoiceDocument = createSaleInvoiceDocument(invoiceGroup, saleOrderLine);
                        }
                        if(!saleInvoices.containsKey(invoiceGroupBatch)){
                            saleInvoices.put(invoiceGroupBatch, saleInvoiceDocument);
                        }
                    
                        Decimal requestedQty = SourceObjectInfo.getRequestedQuantity(orderLinesInfo, deliveryLine.Id);
                        if(requestedQty == null){
                            requestedQty = deliveryLine.dmpl__PendingInvoiceQuantity__c;
                        }

                        dmpl__InventoryFulfillmentAllocationLine__c allocationLine = (dmpl__InventoryFulfillmentAllocationLine__c)CollectionHelper.getObject(
                            allocationLines, 
                            deliveryLine.dmpl__FulfillmentAllocationLineId__c);

                        if(allocationLine!=null){
                            saleInvoiceLines.add(createSaleInvoiceLine(
                                deliveryLine,
                                saleOrderLine, 
                                allocationLine, 
                                requestedQty));
                        }
                        break;
                    }
                }
            }
        }

        if(saleInvoices.size() >0){
            Savepoint sp = Database.setSavepoint();
            try {
                    SecurityHelper.ensureCanCreateObject('dmpl__SaleInvoice__c');
                    SecurityHelper.ensureCanCreateFields(new string[]{'dmpl__BranchId__c','dmpl__PartnerAccountId__c','dmpl__DocumentDate__c','dmpl__AccountId__c','dmpl__InvoiceGroup__c','dmpl__SaleOrderId__c','dmpl__PriceListId__c','dmpl__DiscountGroupId__c'}, 'dmpl__SaleInvoice__c');
                    upsert saleInvoices.values();
                    List<dmpl__SaleInvoiceLine__c> saleInvoiceLinesList = new List<dmpl__SaleInvoiceLine__c>();
                    for(string invoiceGroup : saleInvoices.keySet()){
                        dmpl__SaleInvoice__c saleInvoiceDocument = saleInvoices.get(invoiceGroup);
                        List<dmpl__SaleInvoiceLine__c> saleInvoiceLines = allSaleInvoiceLines.get(invoiceGroup);
                        for(dmpl__SaleInvoiceLine__c saleInvoiceLine : saleInvoiceLines){
                            saleInvoiceLine.dmpl__SaleInvoiceId__c = saleInvoiceDocument.Id;
                            saleInvoiceLinesList.add(saleInvoiceLine);
                        }
                    }
                    SaleInvoiceLineHelper.createSaleInvoiceFromSaleOrder(saleInvoiceLinesList);
            } catch (Exception e) {
                Database.rollback(sp);
                throw e;
            }
        }
        return saleInvoices;
    }

    private static Map<String, dmpl__SaleInvoice__c> createServiceInvoiceInternal(
        List<dmpl__RepairOrderLine__c> repairOrderLines,
        List<SourceObjectInfo> orderLineInfo){
        List<string> distinctInvoiceGroups = getDistinctInvoiceGroups(repairOrderLines);
        List<Id> itemServiceContractIds = DocumentHelper.extractIds(
            repairOrderLines, 
            'dmpl__ItemServiceContractId__c');
        itemServiceContractIds.addAll(DocumentHelper.extractIds(
            repairOrderLines, 
            'dmpl__ItemServiceContractId2__c'));
        itemServiceContractIds.addAll(DocumentHelper.extractIds(
            repairOrderLines, 
            'dmpl__ItemServiceContractId3__c'));
        List<dmpl__ItemServiceContract__c> itemServiceContracts = queryItemServiceContracts(
                itemServiceContractIds);
        List<dmpl__InventoryFulfillmentAllocationLine__c> allocationLines = queryFulfillmentAllocationLines(
            DocumentHelper.extractIds(repairOrderLines));
        Map<String, dmpl__SaleInvoice__c> serviceInvoices = new Map<String, dmpl__SaleInvoice__c>();
        Map<String, List<dmpl__SaleInvoiceLine__c>> allServiceInvoiceLines = new Map<String, List<dmpl__SaleInvoiceLine__c>>();
        for(string invoiceGroup : distinctInvoiceGroups){
            for(dmpl__RepairOrderLine__c repairOrderLine : repairOrderLines){
                String lineInvoiceGroup = repairOrderLine.dmpl__InvoiceGroup__c == null? dmpl__SaleInvoice__c.class.getName() : repairOrderLine.dmpl__InvoiceGroup__c;
                String contractInvoiceGroup = lineInvoiceGroup;
                if(repairOrderLine.dmpl__ItemServiceContractId__c!=null){
                    contractInvoiceGroup  = lineInvoiceGroup + repairOrderLine.dmpl__ItemServiceContractId__c;
                }
                if(contractInvoiceGroup != invoiceGroup){
                    continue;
                }
                repairOrderLine.dmpl__IsInvoiced__c = true;
                if(repairOrderLine.dmpl__PostingType__c == null || repairOrderLine.dmpl__PostingType__c == 'Generate Invoices'){
                    String invoiceGroupBatch = contractInvoiceGroup + String.valueOf(repairOrderLine.dmpl__RepairOrderId__c);
                    List<dmpl__SaleInvoiceLine__c> serviceInvoiceLines = allServiceInvoiceLines.get(invoiceGroupBatch);
                    if(serviceInvoiceLines == null){
                        serviceInvoiceLines = new List<dmpl__SaleInvoiceLine__c>();
                        allServiceInvoiceLines.put(invoiceGroupBatch, serviceInvoiceLines);
                    }
                    dmpl__SaleInvoice__c serviceInvoiceDocument = serviceInvoices.get(invoiceGroupBatch);
                    SourceObjectInfo objectInfo = SourceObjectInfo.getSourceObjectInfo(orderLineInfo, repairOrderLine.Id);
                    if(serviceInvoiceDocument == null && objectInfo != null){
                        serviceInvoiceDocument = querySaleInvoice(
                            objectInfo.getDestinationObjectId(invoiceGroupBatch));
                    }
                    if(serviceInvoiceDocument == null){
                        Id billingAccountId = getBillingAccountId(
                            itemServiceContracts, 
                            repairOrderLine.dmpl__ItemServiceContractId__c, 
                            repairOrderLine.dmpl__RepairOrderId__r.dmpl__PartnerAccountId__c,
                            repairOrderLine.dmpl__RepairOrderId__r.dmpl__AccountId__c);
                        serviceInvoiceDocument = createServiceInvoiceDocument(
                            invoiceGroup, 
                            repairOrderLine, 
                            billingAccountId,
                            repairOrderLine.dmpl__ItemServiceContractId__c);
                    }
                    if(!serviceInvoices.containsKey(invoiceGroupBatch)){
                        serviceInvoices.put(invoiceGroupBatch, serviceInvoiceDocument);
                    }
                    dmpl__InventoryFulfillmentAllocationLine__c relatedAllocationLine = (dmpl__InventoryFulfillmentAllocationLine__c)DocumentHelper.getObjectByFilter(
                        allocationLines, 
                        'dmpl__RepairOrderLineId__c', 
                        repairOrderLine.Id);
                    if(relatedAllocationLine != null)
                        serviceInvoiceLines.addAll(createServiceInvoiceLine(repairOrderLine, relatedAllocationLine, orderLineInfo));
                    else
                        serviceInvoiceLines.add(createServiceInvoiceLine(repairOrderLine, orderLineInfo));    
                }
                
                if(repairOrderLine.dmpl__ServiceContractWeightage2__c >0
                    && repairOrderLine.dmpl__ItemServiceContractId2__c !=null){
                        dmpl__ItemServiceContract__c itemContract = (dmpl__ItemServiceContract__c)DocumentHelper.getObject(
                            itemServiceContracts,
                            repairOrderLine.dmpl__ItemServiceContractId2__c);
                        if(itemContract.dmpl__ContractPostingTreatment__c == 'Generate Invoices'){
                            String invoiceGroupBatch = lineInvoiceGroup + repairOrderLine.dmpl__ItemServiceContractId2__c + String.valueOf(repairOrderLine.dmpl__RepairOrderId__c);
                            List<dmpl__SaleInvoiceLine__c> serviceInvoiceLines = allServiceInvoiceLines.get(invoiceGroupBatch);
                            if(serviceInvoiceLines == null){
                                serviceInvoiceLines = new List<dmpl__SaleInvoiceLine__c>();
                                allServiceInvoiceLines.put(invoiceGroupBatch, serviceInvoiceLines);
                            }
                            
                            dmpl__SaleInvoice__c serviceInvoiceDocument = serviceInvoices.get(invoiceGroupBatch);
                            SourceObjectInfo objectInfo = SourceObjectInfo.getSourceObjectInfo(orderLineInfo, repairOrderLine.Id);
                            if(serviceInvoiceDocument == null && objectInfo!=null){
                                serviceInvoiceDocument = querySaleInvoice(
                                    objectInfo.getDestinationObjectId(invoiceGroupBatch));
                            }
                            if(serviceInvoiceDocument == null){
                                Id billingAccountId = getBillingAccountId(
                                    itemServiceContracts, 
                                    repairOrderLine.dmpl__ItemServiceContractId2__c, 
                                    repairOrderLine.dmpl__RepairOrderId__r.dmpl__PartnerAccountId__c,
                                    repairOrderLine.dmpl__RepairOrderId__r.dmpl__AccountId__c);
                                serviceInvoiceDocument = createServiceInvoiceDocument(
                                    invoiceGroup, 
                                    repairOrderLine, 
                                    billingAccountId,
                                    repairOrderLine.dmpl__ItemServiceContractId2__c);
                            }
                            if(!serviceInvoices.containsKey(invoiceGroupBatch)){
                                serviceInvoices.put(invoiceGroupBatch, serviceInvoiceDocument);
                            }
                            if(itemContract!=null && itemContract.dmpl__WeightageInvoiceChargeItem__c!=null){
                                dmpl__SaleInvoiceLine__c existingLine = (dmpl__SaleInvoiceLine__c)DocumentHelper.getObjectByFilter(
                                    serviceInvoiceLines,
                                    'dmpl__ItemId__c',
                                    itemContract.dmpl__WeightageInvoiceChargeItem__c);
                                Decimal requestedQty = null;
                                if(orderLineInfo != null) {
                                    requestedQty = SourceObjectInfo.getRequestedQuantity(orderLineInfo, repairOrderLine.Id);
                                }
                                if(requestedQty == null || requestedQty ==0){
                                    requestedQty = repairOrderLine.dmpl__Quantity__c;
                                } 
                                if(existingLine!=null){
                                    existingLine.dmpl__UnitPrice__c += requestedQty
                                        * repairOrderLine.dmpl__UnitPrice__c 
                                        * (repairOrderLine.dmpl__ServiceContractWeightage2__c/100);
                                }else {
                                    serviceInvoiceLines.add(
                                        createServiceInvoiceWeightageLine2(
                                            repairOrderLine,
                                            itemContract.dmpl__WeightageInvoiceChargeItem__c,
                                            requestedQty));            
                                }
                            }
                        }
                }
                if(repairOrderLine.dmpl__ServiceContractWeightage3__c >0
                    && repairOrderLine.dmpl__ItemServiceContractId3__c !=null){
                        dmpl__ItemServiceContract__c itemContract = (dmpl__ItemServiceContract__c)DocumentHelper.getObject(
                            itemServiceContracts,
                            repairOrderLine.dmpl__ItemServiceContractId3__c);
                        if(itemContract!=null && itemContract.dmpl__ContractPostingTreatment__c == 'Generate Invoices'){
                            String invoiceGroupBatch = lineInvoiceGroup + repairOrderLine.dmpl__ItemServiceContractId3__c + String.valueOf(repairOrderLine.dmpl__RepairOrderId__c);
                            List<dmpl__SaleInvoiceLine__c> serviceInvoiceLines = allServiceInvoiceLines.get(invoiceGroupBatch);
                            if(serviceInvoiceLines == null){
                                serviceInvoiceLines = new List<dmpl__SaleInvoiceLine__c>();
                                allServiceInvoiceLines.put(invoiceGroupBatch, serviceInvoiceLines);
                            }
                            
                            dmpl__SaleInvoice__c serviceInvoiceDocument = serviceInvoices.get(invoiceGroupBatch);
                            SourceObjectInfo objectInfo = SourceObjectInfo.getSourceObjectInfo(orderLineInfo, repairOrderLine.Id);
                            if(serviceInvoiceDocument == null && objectInfo!=null){
                                serviceInvoiceDocument = querySaleInvoice(
                                    objectInfo.getDestinationObjectId(invoiceGroupBatch));
                            }
                            if(serviceInvoiceDocument == null){
                                Id billingAccountId = getBillingAccountId(
                                    itemServiceContracts, 
                                    repairOrderLine.dmpl__ItemServiceContractId3__c, 
                                    repairOrderLine.dmpl__RepairOrderId__r.dmpl__PartnerAccountId__c,
                                    repairOrderLine.dmpl__RepairOrderId__r.dmpl__AccountId__c);
                                serviceInvoiceDocument = createServiceInvoiceDocument(
                                    invoiceGroup, 
                                    repairOrderLine, 
                                    billingAccountId,
                                    repairOrderLine.dmpl__ItemServiceContractId3__c);
                            }
                            if(!serviceInvoices.containsKey(invoiceGroupBatch)){
                                serviceInvoices.put(invoiceGroupBatch, serviceInvoiceDocument);
                            }
                            if(itemContract!=null && itemContract.dmpl__WeightageInvoiceChargeItem__c!=null){
                                dmpl__SaleInvoiceLine__c existingLine = (dmpl__SaleInvoiceLine__c)DocumentHelper.getObjectByFilter(
                                    serviceInvoiceLines,
                                    'dmpl__ItemId__c',
                                    itemContract.dmpl__WeightageInvoiceChargeItem__c);
                                Decimal requestedQty = null;
                                if(orderLineInfo != null) {
                                    requestedQty = SourceObjectInfo.getRequestedQuantity(orderLineInfo, repairOrderLine.Id);
                                }
                                if(requestedQty == null || requestedQty ==0){
                                    requestedQty = repairOrderLine.dmpl__Quantity__c;
                                } 
                                if(existingLine!=null){
                                    existingLine.dmpl__UnitPrice__c += requestedQty
                                        * repairOrderLine.dmpl__UnitPrice__c 
                                        * (repairOrderLine.dmpl__ServiceContractWeightage3__c/100);
                                }else{
                                    serviceInvoiceLines.add(
                                        createServiceInvoiceWeightageLine3(
                                            repairOrderLine,
                                            itemContract.dmpl__WeightageInvoiceChargeItem__c,
                                            requestedQty));    
                                }
                            }
                        }
                }
            }
        }

        if(serviceInvoices.size() >0){
            Savepoint sp = Database.setSavepoint();
            try {
                    SecurityHelper.ensureCanCreateObject('dmpl__SaleInvoice__c');
                    SecurityHelper.ensureCanCreateFields(new string[]{
                        'dmpl__BranchId__c',
                        'dmpl__PartnerAccountId__c',
                        'dmpl__DocumentDate__c',
                        'dmpl__AccountId__c',
                        'dmpl__InvoiceGroup__c',
                        'dmpl__RepairOrderId__c',
                        'dmpl__PriceListId__c',
                        'dmpl__DiscountGroupId__c',
                        'dmpl__ServiceAdvisorId__c',
                        'dmpl__ServiceContractItemId__c'
                    }, 'dmpl__SaleInvoice__c');
                    upsert serviceInvoices.values();
                    List<dmpl__SaleInvoiceLine__c> saleInvoiceLinesList = new List<dmpl__SaleInvoiceLine__c>();
                    for(string invoiceGroup : serviceInvoices.keySet()){
                        dmpl__SaleInvoice__c saleInvoiceDocument = serviceInvoices.get(invoiceGroup);
                        List<dmpl__SaleInvoiceLine__c> saleInvoiceLines = allServiceInvoiceLines.get(invoiceGroup);
                        for(dmpl__SaleInvoiceLine__c saleInvoiceLine : saleInvoiceLines){
                            saleInvoiceLine.dmpl__SaleInvoiceId__c = saleInvoiceDocument.Id;
                            saleInvoiceLinesList.add(saleInvoiceLine);
                        }
                    }
                    SaleInvoiceLineHelper.createSaleInvoiceFromSaleOrder(saleInvoiceLinesList);
                    // UpdateAssetContract(serviceInvoices.values(), saleInvoiceLinesList);
                    return serviceInvoices;
            } catch (Exception e) {
                Database.rollback(sp);
                throw e;
            }
        }
        return serviceInvoices;
    }

    private static List<string> getDistinctInvoiceGroups(List<dmpl__SaleOrderLine__c> saleOrderLines)
    {
        List<string> distinctInvoiceGroups = new List<string>();
        for(dmpl__SaleOrderLine__c saleOrderLine : saleOrderLines){
            String invoiceGroup = saleOrderLine.dmpl__InvoiceGroup__c == null? dmpl__SaleInvoice__c.class.getName() : saleOrderLine.dmpl__InvoiceGroup__c;
            if(!distinctInvoiceGroups.contains(invoiceGroup)){
                distinctInvoiceGroups.Add(invoiceGroup);
            }
        }
        return distinctInvoiceGroups;
    }

    private static List<string> getDistinctInvoiceGroups(List<dmpl__RepairOrderLine__c> repairOrderLines)
    {
        List<string> distinctInvoiceGroups = new List<string>();
        for(dmpl__RepairOrderLine__c repairOrderLine : repairOrderLines){
            String invoiceGroup = repairOrderLine.dmpl__InvoiceGroup__c == null? dmpl__SaleInvoice__c.class.getName() : repairOrderLine.dmpl__InvoiceGroup__c;
            if(repairOrderLine.dmpl__ItemServiceContractId__c !=null){
                if(!distinctInvoiceGroups.contains(invoiceGroup + repairOrderLine.dmpl__ItemServiceContractId__c)){
                    distinctInvoiceGroups.Add(invoiceGroup + repairOrderLine.dmpl__ItemServiceContractId__c);
                }
            }else{
                if(!distinctInvoiceGroups.contains(invoiceGroup)){
                    distinctInvoiceGroups.Add(invoiceGroup);}
            }
            
            if(repairOrderLine.dmpl__ItemServiceContractId2__c !=null){
                if(!distinctInvoiceGroups.contains(invoiceGroup + repairOrderLine.dmpl__ItemServiceContractId2__c)){
                    distinctInvoiceGroups.Add(invoiceGroup + repairOrderLine.dmpl__ItemServiceContractId2__c);
                }
            }
            
            if(repairOrderLine.dmpl__ItemServiceContractId3__c !=null){
                if(!distinctInvoiceGroups.contains(invoiceGroup + repairOrderLine.dmpl__ItemServiceContractId3__c)){
                    distinctInvoiceGroups.Add(invoiceGroup + repairOrderLine.dmpl__ItemServiceContractId3__c);
                }
            }
        }
        return distinctInvoiceGroups;
    }
    
    private static dmpl__SaleInvoice__c createSaleInvoiceDocument(String invoiceGroup, dmpl__SaleOrderLine__c saleOrderLine)
    {
        return new dmpl__SaleInvoice__c(
            dmpl__BranchId__c = saleOrderLine.dmpl__SaleOrderId__r.dmpl__BranchId__c,
            dmpl__PartnerAccountId__c = saleOrderLine.dmpl__SaleOrderId__r.dmpl__PartnerAccountId__c,
            dmpl__DocumentDate__c = System.today(),
            dmpl__AccountId__c = saleOrderLine.dmpl__SaleOrderId__r.dmpl__AccountId__c,
            dmpl__InvoiceGroup__c = (invoiceGroup == dmpl__SaleInvoice__c.class.getName()? null:invoiceGroup),
            dmpl__SaleOrderId__c = saleOrderLine.dmpl__SaleOrderId__c,
            dmpl__PriceListId__c = saleOrderLine.dmpl__SaleOrderId__r.dmpl__PriceListId__c,
            dmpl__DiscountGroupId__c = saleOrderLine.dmpl__SaleOrderId__r.dmpl__DiscountGroupId__c,
            dmpl__SalesExecutiveId__c = saleOrderLine.dmpl__SaleOrderId__r.dmpl__SalesExecutiveId__c,
            dmpl__Discount__c = saleOrderLine.dmpl__SaleOrderId__r.dmpl__Discount__c
        );
    }

    @testVisible
    private static dmpl__SaleInvoice__c createServiceInvoiceDocument(
        string invoiceGroup, 
        dmpl__RepairOrderLine__c repairOrderLine, 
        Id billingAccountId,
        Id itemServiceContractId){
        return new dmpl__SaleInvoice__c(
            dmpl__AssetId__c = repairOrderLine.dmpl__RepairOrderId__r.dmpl__AssetId__c,
            dmpl__BranchId__c = repairOrderLine.dmpl__RepairOrderId__r.dmpl__BranchId__c,
            dmpl__PartnerAccountId__c = repairOrderLine.dmpl__RepairOrderId__r.dmpl__PartnerAccountId__c,
            dmpl__DocumentDate__c = System.today(),
            dmpl__AccountId__c = billingAccountId,
            dmpl__ServiceAdvisorId__c = repairOrderLine.dmpl__RepairOrderId__r.dmpl__ServiceAdvisorId__c,
            dmpl__ServiceContractItemId__c = repairOrderLine.dmpl__RepairOrderId__r.dmpl__ServiceContractItemId__c,
            dmpl__ItemServiceContractId__c = itemServiceContractId,
            dmpl__InvoiceGroup__c = repairOrderLine.dmpl__InvoiceGroup__c,
            dmpl__RepairOrderId__c = repairOrderLine.dmpl__RepairOrderId__c,
            dmpl__PriceListId__c = repairOrderLine.dmpl__RepairOrderId__r.dmpl__PriceListId__c,
            dmpl__DiscountGroupId__c = repairOrderLine.dmpl__RepairOrderId__r.dmpl__DiscountGroupId__c,
            dmpl__Discount__c = repairOrderLine.dmpl__RepairOrderId__r.dmpl__Discount__c
        );
    }

    private static Id getBillingAccountId(
        List<dmpl__ItemServiceContract__c> itemServiceContracts, 
        Id itemServiceContractId, 
        Id partnerAccountId, 
        Id defaultBillingAccountId){
        Id billingAccountId = defaultBillingAccountId;
        for(dmpl__ItemServiceContract__c itemServiceContract : itemServiceContracts){
            if(itemServiceContract.Id == itemServiceContractId){
                if(itemServiceContract.dmpl__BillToPartnerAccount__c == true){
                    billingAccountId = partnerAccountId;
                }else if(itemServiceContract.dmpl__BillingAccountId__c != null){
                    billingAccountId = itemServiceContract.dmpl__BillingAccountId__c;
                }
                break;
            } 
        }
        return billingAccountId;
    }

    private static List<dmpl__ItemServiceContract__c> queryItemServiceContracts(
        List<Id> itemServiceContractIds){
        return [SELECT 
            Id, 
            Name, 
            dmpl__ContractPostingTreatment__c,
            dmpl__BillingAccountId__c, 
            dmpl__WeightageInvoiceChargeItem__c,
            dmpl__BillToPartnerAccount__c
        FROM 
            dmpl__ItemServiceContract__c 
        WHERE 
            Id IN : itemServiceContractIds];
    }

    @TestVisible
    private static List<dmpl__SaleInvoiceLine__c> createServiceInvoiceLine(
        dmpl__RepairOrderLine__c orderLine, 
        dmpl__InventoryFulfillmentAllocationLine__c allocationLine,
        List<SourceObjectInfo> orderLinesInfo)
    {
        Decimal requestedQty = null;
        if(orderLinesInfo != null){
            requestedQty = SourceObjectInfo.getRequestedQuantity(orderLinesInfo, orderLine.Id);
        }
        if(requestedQty == null){
            requestedQty = allocationLine.dmpl__AllocatedQuantity__c;
        }
        Decimal discount;
        Decimal discountAmount;
        if(orderLine.dmpl__DiscountAmount__c != null && orderLine.dmpl__DiscountAmount__c>0){
            discountAmount =  orderLine.dmpl__DiscountAmount__c * (requestedQty/orderLine.dmpl__Quantity__c) 
                + ((orderLine.dmpl__UnitPrice__c * requestedQty)
                    * (100 - orderLine.dmpl__ServiceContractWeightage__c)/100);
        }else if(orderLine.dmpl__Discount__c != null){
            discountAmount = (requestedQty * orderLine.dmpl__UnitPrice__c * (orderLine.dmpl__Discount__c/100));
            discountAmount = discountAmount + (
                ((requestedQty * orderLine.dmpl__UnitPrice__c) - discountAmount ) 
                    * (100 - orderLine.dmpl__ServiceContractWeightage__c)/100);
        }else{
            discount = 100 - orderLine.dmpl__ServiceContractWeightage__c;
        }

        List<dmpl__SaleInvoiceLine__c> newInvoiceLines = new List<dmpl__SaleInvoiceLine__c>();
        newInvoiceLines.Add(
            new dmpl__SaleInvoiceLine__c(
            dmpl__RepairOrderLineId__c = orderLine.ID,
            dmpl__ItemId__c = orderLine.dmpl__ItemId__c,
            dmpl__SKUId__c = orderLine.dmpl__SKUId__c,
            dmpl__UnitPrice__c = orderLine.dmpl__UnitPrice__c,
            dmpl__UnitPrice2__c = orderLine.dmpl__UnitPrice2__c,
            dmpl__Discount__c = discount,
            dmpl__DiscountAmount__c = discountAmount,
            dmpl__Discount2__c = orderLine.dmpl__Discount2__c,
            dmpl__DiscountAmount2__c = orderLine.dmpl__DiscountAmount2__c != null ? 
                orderLine.dmpl__DiscountAmount2__c * (requestedQty/orderLine.dmpl__Quantity__c) : null, 
            dmpl__ContractDiscount__c = orderLine.dmpl__ContractDiscount__c,
            dmpl__ContractDiscountAmount__c = orderLine.dmpl__ContractDiscountAmount__c !=null ?
                orderLine.dmpl__ContractDiscountAmount__c * (requestedQty/orderLine.dmpl__Quantity__c) : null, 
            dmpl__SchemeDiscount__c = orderLine.dmpl__SchemeDiscount__c,
            dmpl__SchemeDiscountAmount__c = orderLine.dmpl__SchemeDiscountAmount__c !=null ? 
                orderLine.dmpl__SchemeDiscountAmount__c  * (requestedQty/orderLine.dmpl__Quantity__c) : null, 
            dmpl__ItemLotTypeId__c = allocationLine.dmpl__ItemLotTypeId__c,
            dmpl__ItemLotId__c = allocationLine.dmpl__ItemLotId__c,
            dmpl__InventoryLedgerId__c = allocationLine.dmpl__InventoryLedgerId__c,
            dmpl__StorageLocationId__c = allocationLine.dmpl__StorageLocationId__c,
            dmpl__UnitCost__c = allocationLine.dmpl__UnitCost__c,
            dmpl__FulfillmentAllocationLineId__c = allocationLine.Id,
            dmpl__TaxGroupId__c = orderLine.dmpl__TaxGroupId__c,
            dmpl__Quantity__c = requestedQty
        ));
       return newInvoiceLines;
    }
    
    @testVisible
    private static dmpl__SaleInvoiceLine__c createServiceInvoiceLine(
        dmpl__RepairOrderLine__c orderLine, 
        List<SourceObjectInfo> orderLinesInfo){
        Decimal requestedQty = null;
        if(orderLinesInfo != null){ 
            requestedQty = SourceObjectInfo.getRequestedQuantity(orderLinesInfo, orderLine.Id);
        }
        if(requestedQty == null || requestedQty == 0){
            requestedQty = orderLine.dmpl__Quantity__c;
        }
        Decimal discount;
        Decimal discountAmount;
        if(orderLine.dmpl__DiscountAmount__c != null && orderLine.dmpl__DiscountAmount__c>0){
            discountAmount =  orderLine.dmpl__DiscountAmount__c * (requestedQty/orderLine.dmpl__Quantity__c) 
                + ((orderLine.dmpl__UnitPrice__c * requestedQty)
                    * (100 - orderLine.dmpl__ServiceContractWeightage__c)/100);
        }else if(orderLine.dmpl__Discount__c != null){
            discountAmount = (requestedQty * orderLine.dmpl__UnitPrice__c * (orderLine.dmpl__Discount__c/100));
            discountAmount = discountAmount + (
                ((requestedQty * orderLine.dmpl__UnitPrice__c) - discountAmount ) 
                    * (100 - orderLine.dmpl__ServiceContractWeightage__c)/100);
        }else{
            discount = 100 - orderLine.dmpl__ServiceContractWeightage__c;
        }

        return  new dmpl__SaleInvoiceLine__c(
            dmpl__RepairOrderLineId__c = orderLine.ID,
            dmpl__ItemId__c = orderLine.dmpl__ItemId__c,
            dmpl__SKUId__c = orderLine.dmpl__SKUId__c,
            dmpl__UnitPrice__c = orderLine.dmpl__UnitPrice__c,
            dmpl__UnitPrice2__c = orderLine.dmpl__UnitPrice2__c,
            dmpl__Discount__c = discount,
            dmpl__DiscountAmount__c = discountAmount,
            dmpl__Discount2__c = orderLine.dmpl__Discount2__c,
            dmpl__DiscountAmount2__c = orderLine.dmpl__DiscountAmount2__c != null ? 
                orderLine.dmpl__DiscountAmount2__c * (requestedQty/orderLine.dmpl__Quantity__c) : null, 
            dmpl__ContractDiscount__c = orderLine.dmpl__ContractDiscount__c,
            dmpl__ContractDiscountAmount__c = orderLine.dmpl__ContractDiscountAmount__c !=null ?
                orderLine.dmpl__ContractDiscountAmount__c * (requestedQty/orderLine.dmpl__Quantity__c) : null, 
            dmpl__SchemeDiscount__c = orderLine.dmpl__SchemeDiscount__c,
            dmpl__SchemeDiscountAmount__c = orderLine.dmpl__SchemeDiscountAmount__c !=null ? 
                orderLine.dmpl__SchemeDiscountAmount__c  * (requestedQty/orderLine.dmpl__Quantity__c) : null, 
            dmpl__Quantity__c = requestedQty,
            dmpl__TaxGroupId__c = orderLine.dmpl__TaxGroupId__c
        );
    }

    @testVisible
    private static dmpl__SaleInvoiceLine__c createServiceInvoiceWeightageLine2(
        dmpl__RepairOrderLine__c orderLine,
        Id weightageInvoiceChargeItem,
        Decimal requestedQty){
            return  new dmpl__SaleInvoiceLine__c(
                dmpl__RepairOrderLineId__c = orderLine.ID,
                dmpl__ItemId__c = weightageInvoiceChargeItem,
                dmpl__UnitPrice__c = requestedQty * orderLine.dmpl__UnitPrice__c * (orderLine.dmpl__ServiceContractWeightage2__c/100),
                dmpl__Quantity__c = 1,
                dmpl__TaxGroupId__c = orderLine.dmpl__TaxGroupId__c,
                dmpl__Discount__c = orderLine.dmpl__Discount__c
            );
    }

    @testVisible
    private static dmpl__SaleInvoiceLine__c createServiceInvoiceWeightageLine3(
        dmpl__RepairOrderLine__c orderLine,
        Id weightageInvoiceChargeItem,
        Decimal requestedQty){
            return  new dmpl__SaleInvoiceLine__c(
                dmpl__RepairOrderLineId__c = orderLine.ID,
                dmpl__ItemId__c = weightageInvoiceChargeItem,
                dmpl__UnitPrice__c = requestedQty * orderLine.dmpl__UnitPrice__c * (orderLine.dmpl__ServiceContractWeightage3__c/100),
                dmpl__Quantity__c = 1,
                dmpl__TaxGroupId__c = orderLine.dmpl__TaxGroupId__c,
                dmpl__Discount__c = orderLine.dmpl__Discount__c
            );
    }

    @testVisible
    private static dmpl__SaleInvoiceLine__c createSaleInvoiceLine(
        dmpl__SaleOrderLine__c orderLine, 
        Decimal requestedQty){
            Decimal quantityToInvoice = requestedQty > 0 ? requestedQty : orderLine.dmpl__PendingFulfilmentOrderQuantity__c;
        return new dmpl__SaleInvoiceLine__c(
            dmpl__SaleOrderLineId__c = orderLine.ID,
            dmpl__ItemId__c = orderLine.dmpl__ItemId__c,
            dmpl__SKUId__c = orderLine.dmpl__SKUId__c,
            dmpl__UnitPrice__c = orderLine.dmpl__UnitPrice__c,
            dmpl__UnitPrice2__c = orderLine.dmpl__UnitPrice2__c,
            dmpl__Quantity__c = quantityToInvoice,
            dmpl__TaxGroupId__c = orderLine.dmpl__TaxGroupId__c,
            dmpl__IsPriceBundled__c= orderLine.dmpl__IsPriceBundled__c,
            dmpl__ItemComponentId__c = orderLine.dmpl__ItemComponentId__c,
            dmpl__PackageSaleOrderLineId__c = orderLine.dmpl__PackageSaleOrderLineId__c,
            dmpl__Discount__c = orderLine.dmpl__Discount__c,
            dmpl__Discount2__c = orderLine.dmpl__Discount2__c,
            dmpl__DiscountGroupRuleId__c = orderLine.dmpl__DiscountGroupRuleId__c,
            dmpl__DiscountAmount__c = orderLine.dmpl__DiscountAmount__c != null ? 
                orderLine.dmpl__DiscountAmount__c * (quantityToInvoice/orderLine.dmpl__Quantity__c) : null,
            dmpl__DiscountAmount2__c = orderLine.dmpl__DiscountAmount2__c != null ? 
                orderLine.dmpl__DiscountAmount2__c * (quantityToInvoice/orderLine.dmpl__Quantity__c) : null, 
            dmpl__ContractDiscount__c = orderLine.dmpl__ContractDiscount__c,
            dmpl__ContractDiscountAmount__c = orderLine.dmpl__ContractDiscountAmount__c !=null ?
                orderLine.dmpl__ContractDiscountAmount__c * (quantityToInvoice/orderLine.dmpl__Quantity__c) : null, 
            dmpl__SchemeDiscount__c = orderLine.dmpl__SchemeDiscount__c,
            dmpl__SchemeDiscountAmount__c = orderLine.dmpl__SchemeDiscountAmount__c !=null ? 
                orderLine.dmpl__SchemeDiscountAmount__c  * (quantityToInvoice/orderLine.dmpl__Quantity__c) : null, 
            dmpl__BillingType__c = orderLine.dmpl__BillingType__c,
            dmpl__BillingFrequency__c = orderLine.dmpl__BillingFrequency__c,
            dmpl__ChargeType__c = orderLine.dmpl__ChargeType__c,
            dmpl__ItemLotTypeId__c = orderLine.dmpl__ItemLotTypeId__c
        );
    }

    @testVisible
    private static dmpl__SaleInvoiceLine__c createSaleInvoiceLine(
        dmpl__DeliveryOrderLine__c deliveryLine,
        dmpl__SaleOrderLine__c orderLine, 
        dmpl__InventoryFulfillmentAllocationLine__c allocationLine, 
        Decimal requestedQty){
            Decimal quantityToInvoice = requestedQty > 0 ? requestedQty : deliveryLine.dmpl__Quantity__c;
            return new dmpl__SaleInvoiceLine__c(
                dmpl__DeliveryOrderLineId__c = deliveryLine.Id,
                dmpl__SaleOrderLineId__c = orderLine.ID,
                dmpl__ItemId__c = orderLine.dmpl__ItemId__c,
                dmpl__SKUId__c = orderLine.dmpl__SKUId__c,
                dmpl__UnitPrice__c = orderLine.dmpl__UnitPrice__c,
                dmpl__UnitPrice2__c = orderLine.dmpl__UnitPrice2__c,
                dmpl__Quantity__c = quantityToInvoice,
                dmpl__DeliveredQuantity__c = quantityToInvoice,
                dmpl__ItemLotId__c = allocationLine.dmpl__ItemLotId__c,
                dmpl__InventoryLedgerId__c = allocationLine.dmpl__InventoryLedgerId__c,
                dmpl__StorageLocationId__c = allocationLine.dmpl__StorageLocationId__c,
                dmpl__UnitCost__c = allocationLine.dmpl__UnitCost__c,
                dmpl__FulfillmentAllocationLineId__c = allocationLine.Id,
                dmpl__TaxGroupId__c = orderLine.dmpl__TaxGroupId__c,
                dmpl__IsPriceBundled__c= orderLine.dmpl__IsPriceBundled__c,
                dmpl__PackageSaleOrderLineId__c = orderLine.dmpl__PackageSaleOrderLineId__c,
                dmpl__Discount__c = orderLine.dmpl__Discount__c,
                dmpl__Discount2__c = orderLine.dmpl__Discount2__c,
                dmpl__DiscountGroupRuleId__c = orderLine.dmpl__DiscountGroupRuleId__c,
                dmpl__DiscountAmount__c = orderLine.dmpl__DiscountAmount__c !=null ? 
                    orderLine.dmpl__DiscountAmount__c * (quantityToInvoice/orderLine.dmpl__Quantity__c) : null,
                dmpl__DiscountAmount2__c = orderLine.dmpl__DiscountAmount2__c !=null ?
                    orderLine.dmpl__DiscountAmount2__c * (quantityToInvoice/orderLine.dmpl__Quantity__c) : null,
                dmpl__ContractDiscount__c = orderLine.dmpl__ContractDiscount__c,
                dmpl__ContractDiscountAmount__c = orderLine.dmpl__ContractDiscountAmount__c !=null ?
                    orderLine.dmpl__ContractDiscountAmount__c * (quantityToInvoice/orderLine.dmpl__Quantity__c) : null,
                dmpl__SchemeDiscount__c = orderLine.dmpl__SchemeDiscount__c,
                dmpl__SchemeDiscountAmount__c = orderLine.dmpl__SchemeDiscountAmount__c !=null ?
                    orderLine.dmpl__SchemeDiscountAmount__c * (quantityToInvoice/orderLine.dmpl__Quantity__c) : null,
                dmpl__BillingType__c = orderLine.dmpl__BillingType__c,
                dmpl__BillingFrequency__c = orderLine.dmpl__BillingFrequency__c,
                dmpl__ChargeType__c = orderLine.dmpl__ChargeType__c,
                dmpl__ItemLotTypeId__c = allocationLine.dmpl__ItemLotTypeId__c);
    }

    @TestVisible
    private static List<dmpl__SaleInvoiceLine__c> createSaleInvoiceLine(
        dmpl__SaleOrderLine__c orderLine, 
        List<dmpl__InventoryFulfillmentAllocationLine__c> allocationLines, 
        Decimal requestedQty){
        List<dmpl__SaleInvoiceLine__c> newInvoiceLines = new List<dmpl__SaleInvoiceLine__c>();
        for(dmpl__InventoryFulfillmentAllocationLine__c allocationLine : allocationLines)
        {
            if(allocationLine.dmpl__SaleOrderLineId__c != orderLine.Id 
                && allocationLine.dmpl__FulfillmentOrderLineId__r.dmpl__SaleOrderLineId__c != orderLine.Id){
                    continue;
            }
            Decimal qtyToInvoice = requestedQty > 0 ? requestedQty : allocationLine.dmpl__PendingInvoiceQuantity__c;
            newInvoiceLines.Add(
                new dmpl__SaleInvoiceLine__c(
                dmpl__SaleOrderLineId__c = orderLine.ID,
                dmpl__ItemId__c = orderLine.dmpl__ItemId__c,
                dmpl__SKUId__c = orderLine.dmpl__SKUId__c,
                dmpl__UnitPrice__c = orderLine.dmpl__UnitPrice__c,
                dmpl__UnitPrice2__c = orderLine.dmpl__UnitPrice2__c,
                dmpl__Quantity__c = qtyToInvoice,
                dmpl__ItemLotId__c = allocationLine.dmpl__ItemLotId__c,
                dmpl__InventoryLedgerId__c = allocationLine.dmpl__InventoryLedgerId__c,
                dmpl__StorageLocationId__c = allocationLine.dmpl__StorageLocationId__c,
                dmpl__UnitCost__c = allocationLine.dmpl__UnitCost__c,
                dmpl__FulfillmentAllocationLineId__c = allocationLine.Id,
                dmpl__TaxGroupId__c = orderLine.dmpl__TaxGroupId__c,
                dmpl__IsPriceBundled__c= orderLine.dmpl__IsPriceBundled__c,
                dmpl__PackageSaleOrderLineId__c = orderLine.dmpl__PackageSaleOrderLineId__c,
                dmpl__Discount__c = orderLine.dmpl__Discount__c,
                dmpl__Discount2__c = orderLine.dmpl__Discount2__c,
                dmpl__DiscountGroupRuleId__c = orderLine.dmpl__DiscountGroupRuleId__c,
                dmpl__DiscountAmount__c = orderLine.dmpl__DiscountAmount__c !=null ?
                    orderLine.dmpl__DiscountAmount__c * qtyToInvoice/orderLine.dmpl__Quantity__c : null,
                dmpl__DiscountAmount2__c = orderLine.dmpl__DiscountAmount2__c !=null ?
                    orderLine.dmpl__DiscountAmount2__c * qtyToInvoice/orderLine.dmpl__Quantity__c : null,
                dmpl__ContractDiscount__c = orderLine.dmpl__ContractDiscount__c,
                dmpl__ContractDiscountAmount__c = orderLine.dmpl__ContractDiscountAmount__c !=null ?
                    orderLine.dmpl__ContractDiscountAmount__c * qtyToInvoice/orderLine.dmpl__Quantity__c : null,
                dmpl__SchemeDiscount__c = orderLine.dmpl__SchemeDiscount__c,
                dmpl__SchemeDiscountAmount__c = orderLine.dmpl__SchemeDiscountAmount__c !=null ?
                    orderLine.dmpl__SchemeDiscountAmount__c * qtyToInvoice/orderLine.dmpl__Quantity__c : null,
                dmpl__BillingType__c = orderLine.dmpl__BillingType__c,
                dmpl__BillingFrequency__c = orderLine.dmpl__BillingFrequency__c,
                dmpl__ChargeType__c = orderLine.dmpl__ChargeType__c,
                dmpl__ItemLotTypeId__c = orderLine.dmpl__ItemLotTypeId__c
            ));
        }
       return newInvoiceLines;
    }
    
    @testVisible
    private static void updateDiscountInSaleInvoiceLines(List<dmpl__SaleInvoice__c> modifiedObjects)
    {
        Map<Id,dmpl__SaleInvoice__c> saleInvoices = new Map<Id,dmpl__SaleInvoice__c>(modifiedObjects);
        List<dmpl__SaleInvoiceLine__c> saleInvoiceLines = [SELECT Id, Name, dmpl__SaleInvoiceId__c,  dmpl__Discount__c FROM dmpl__SaleInvoiceLine__c WHERE dmpl__SaleInvoiceId__c IN : modifiedObjects];
        if(saleInvoiceLines.size() > 0){
            for(dmpl__SaleInvoiceLine__c saleInvoiceLine : saleInvoiceLines){
                dmpl__SaleInvoice__c saleInvoice = saleInvoices.get(saleInvoiceLine.dmpl__SaleInvoiceId__c);
                saleInvoiceLine.dmpl__Discount__c = saleInvoice.dmpl__Discount__c;
            }
            SecurityHelper.ensureCanWriteFields(new string[]{'dmpl__Discount__c'}, 'dmpl__SaleInvoiceLine__c');
            update saleInvoiceLines;
        }
    }

    private static void setDefaultAddress(List<dmpl__SaleInvoice__c> newEntries){
        SecurityHelper.ensureCanWriteFields(new List<String>
        {
            FIELD_SALEINVOICE_SHIPPINGADDRESS,
            FIELD_SALEINVOICE_BILLINGADDRESS,
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
        }, OBJECT_SALEINVOICE);

        List<Account> accounts = AccountHelper.getCachedAccounts(CollectionHelper.extractIds(newEntries, FIELD_SALEINVOICE_ACCOUNTID));
        for(dmpl__SaleInvoice__c invoice : newEntries){
            Account account = (Account)CollectionHelper.getObject(accounts, invoice.dmpl__AccountId__c);
            if(account!=null){
                AccountHelper.setDefaultAddress(invoice, account);
            }
        }
    }

    private static void setDefaultAddress(List<dmpl__SaleInvoice__c> newEntries, List<dmpl__SaleInvoice__c> oldEntries){
        SecurityHelper.ensureCanWriteFields(new List<String>
        {
            FIELD_SALEINVOICE_SHIPPINGADDRESS,
            FIELD_SALEINVOICE_BILLINGADDRESS
        }, OBJECT_SALEINVOICE);
        Account account = null;
        List<Account> accounts = AccountHelper.getCachedAccounts(CollectionHelper.extractIds(newEntries, FIELD_SALEINVOICE_ACCOUNTID));
        List<dmpl__SaleInvoice__c> modifiedOrders = DocumentHelper.getModifiedNewObjects(FIELD_SALEINVOICE_BILLINGADDRESSID, oldEntries, newEntries);
        for(dmpl__SaleInvoice__c invoice : modifiedOrders){
            account = (Account)CollectionHelper.getObject(accounts, invoice.dmpl__AccountId__c);
            if(account!=null){
                AccountHelper.setDefaultAddress(invoice, account);
            }
        }
        
        modifiedOrders = DocumentHelper.getModifiedNewObjects(FIELD_SALEINVOICE_SHIPPINGADDRESSID, oldEntries, newEntries);
        for(dmpl__SaleInvoice__c invoice : modifiedOrders){
            account = (Account)CollectionHelper.getObject(accounts, invoice.dmpl__AccountId__c);
            if(account!=null){
                if(invoice.dmpl__ShippingAddressId__c!=null){
                    dmpl__ContactAddress__c address = (dmpl__ContactAddress__c)CollectionHelper.getObject(account.dmpl__ContactAddress__r, invoice.dmpl__ShippingAddressId__c);
                    if(address!=null){
                        invoice.dmpl__ShippingAddress__c = AccountHelper.formatAddress(address);
                    }
                }else {
                    invoice.dmpl__ShippingAddress__c = AccountHelper.formatAddress(account.ShippingAddress);
                }
            }
        }
    }

    private static List<dmpl__DeliveryOrderLine__c> queryDeliveryOrderLines(
        List<Id> deliveryOrderIds, 
        List<Id> deliveryOrderLineIds){
            if(deliveryOrderLineIds == null){
                deliveryOrderLineIds = new List<Id>();
            }
    
            if(deliveryOrderIds == null){
                deliveryOrderIds = new List<Id>();
            }

            return [SELECT 
                    Id,
                    Name,
                    dmpl__SaleOrderLineId__c,
                    dmpl__FulfillmentAllocationLineId__c,
                    dmpl__PendingInvoiceQuantity__c,
                    dmpl__FulfillmentPickingLineId__c,
                    dmpl__AllocatedQuantity__c,
                    dmpl__PickedQuantity__c,
                    dmpl__Quantity__c,
                    dmpl__IsILPosted__c,
                    dmpl__IsILPostingApproved__c,
                    dmpl__ItemId__r.dmpl__TrackInventory__c
                FROM dmpl__DeliveryOrderLine__c
                WHERE dmpl__DeliveryId__c IN :deliveryOrderIds OR Id IN :deliveryOrderLineIds];
        }

    private static List<dmpl__SaleOrderLine__c> querySaleOrderLines(List<Id> saleOrderIds, List<Id> saleOrderLineIds)
    {
        if(saleOrderLineIds == null){
            saleOrderLineIds = new List<Id>();
        }

        if(saleOrderIds == null){
            saleOrderIds = new List<Id>();
        }

        SecurityHelper.ensureCanReadFields(new string[]{
            'dmpl__TrackInventory__c'}, 
            'dmpl__Item__c');
        SecurityHelper.ensureCanReadFields(new string[]{
            'dmpl__PartnerAccountId__c',
            'dmpl__BranchId__c',
            'dmpl__AccountId__c',
            'dmpl__PriceListId__c',
            'dmpl__DocumentDate__c',
            'dmpl__DiscountGroupId__c',
            'dmpl__SalesExecutiveId__c',
            'dmpl__Discount__c'},
            'dmpl__SaleOrder__c');
        SecurityHelper.ensureCanReadFields(new string[]{
            'dmpl__ItemId__c',
            'dmpl__SKUId__c',
            'dmpl__UnitPrice__c',
            'dmpl__UnitPrice2__c',
            'dmpl__Quantity__c',
            'dmpl__TaxGroupId__c',
            'dmpl__InvoiceGroup__c',
            'dmpl__PendingInvoiceQuantity__c', 
            'dmpl__FulfilmentAllocatedQuantity__c',
            'dmpl__IsPriceBundled__c', 
            'dmpl__PackageSaleOrderLineId__c',
            'dmpl__BillingType__c',
            'dmpl__BillingFrequency__c',
            'dmpl__PendingAllocatedInvoicedQuantity__c',
            'dmpl__ChargeType__c',
            'dmpl__ItemLotTypeId__c'}, 
            'dmpl__SaleOrderLine__c');

        return [SELECT Id,
            Name,
            dmpl__ItemId__c,
            dmpl__SKUId__c,
            dmpl__UnitPrice__c,
            dmpl__UnitPrice2__c,
            dmpl__Quantity__c,
            dmpl__PendingInvoiceQuantity__c,
            dmpl__FulfilmentAllocatedQuantity__c,
            dmpl__InvoiceGroup__c,
            dmpl__IsPriceBundled__c,
            dmpl__PackageSaleOrderLineId__c,
            dmpl__TaxGroupId__c,
            dmpl__ItemComponentId__c,
            dmpl__SaleOrderId__c,
            dmpl__SaleOrderId__r.dmpl__PartnerAccountId__c,
            dmpl__SaleOrderId__r.dmpl__BranchId__c,
            dmpl__SaleOrderId__r.dmpl__AccountId__c,
            dmpl__SaleOrderId__r.dmpl__DocumentDate__c,
            dmpl__SaleOrderId__r.dmpl__DiscountGroupId__c,
            dmpl__SaleOrderId__r.dmpl__PriceListId__c,
            dmpl__SaleOrderId__r.dmpl__SalesExecutiveId__c,
            dmpl__SaleOrderId__r.dmpl__Discount__c,
            dmpl__SaleOrderId__r.dmpl__VisitId__c,
            dmpl__SaleOrderId__r.dmpl__VisitRouteId__c,
            dmpl__SaleOrderId__r.dmpl__VisitPlanId__c,
            dmpl__ItemId__r.dmpl__TrackInventory__c,
            dmpl__Discount__c,
            dmpl__Discount2__c,
            dmpl__DiscountGroupRuleId__c,
            dmpl__DiscountAmount__c,
            dmpl__DiscountAmount2__c,
            dmpl__ContractDiscount__c,
            dmpl__ContractDiscountAmount__c,
            dmpl__SchemeDiscount__c,
            dmpl__SchemeDiscountAmount__c,
            dmpl__BillingType__c,
            dmpl__BillingFrequency__c,
            dmpl__ChargeType__c,
            dmpl__PendingAllocatedInvoicedQuantity__c,
            dmpl__PendingFulfilmentOrderQuantity__c,
            dmpl__ItemLotTypeId__c,
            dmpl__ItemId__r.dmpl__ItemType__c
        FROM dmpl__SaleOrderLine__c
        WHERE dmpl__SaleOrderId__c IN :saleOrderIds OR Id IN :saleOrderLineIds
        ];
    }

    private static List<dmpl__InventoryFulfillmentAllocationLine__c> queryFulfillmentAllocationLines(List<Id> saleOrderLineIds)
    {
        SecurityHelper.ensureCanReadFields(new string[]{
            'dmpl__SaleOrderLineId__c',
            'dmpl__Quantity__c',
            'dmpl__AllocatedQuantity__c',
            'dmpl__PendingInvoiceQuantity__c',
            'dmpl__ItemLotTypeId__c',
            'dmpl__ItemLotId__c',
            'dmpl__InventoryLedgerId__c',
            'dmpl__StorageLocationId__c', 
            'dmpl__RepairOrderLineId__c',
            'dmpl__UnitCost__c'}, 
            'dmpl__InventoryFulfillmentAllocationLine__c');

        return [SELECT Id,
            Name,
            dmpl__Quantity__c,
            dmpl__AllocatedQuantity__c,
            dmpl__PickedQuantity__c,
            dmpl__PendingInvoiceQuantity__c,
            dmpl__DeliveredInvoicedQuantity__c,
            dmpl__PickedDeliveredQuantity__c,
            dmpl__ItemLotTypeId__c,
            dmpl__ItemLotId__c,
            dmpl__InventoryLedgerId__c,
            dmpl__StorageLocationId__c,
            dmpl__UnitCost__c,
            dmpl__SaleOrderLineId__c,
            dmpl__DeliveryQuantity__c,
            dmpl__RepairOrderLineId__c,
            dmpl__PickedInvoiceQuantity__c,
            dmpl__FulfillmentOrderLineId__r.dmpl__SaleOrderLineId__c
        FROM dmpl__InventoryFulfillmentAllocationLine__c
        WHERE 
            dmpl__AllocatedQuantity__c > 0 AND dmpl__PendingInvoiceQuantity__c > 0
            AND (dmpl__SaleOrderLineId__c IN: saleOrderLineIds
                OR dmpl__FulfillmentOrderLineId__r.dmpl__SaleOrderLineId__c IN: saleOrderLineIds
                OR dmpl__RepairOrderLineId__c IN: saleOrderLineIds
                OR dmpl__FulfillmentOrderLineId__r.dmpl__RepairOrderLineId__c IN: saleOrderLineIds)
            AND (dmpl__SaleOrderLineId__r.dmpl__PendingAllocatedInvoicedQuantity__c > 0
                OR dmpl__RepairOrderLineId__r.dmpl__IsInvoiced__c = false)
        ];
    }

    private static List<dmpl__InventoryFulfillmentAllocationLine__c> queryFulfillmentAllocationLinesFromIds(List<Id> allocationLineIds)
    {
        SecurityHelper.ensureCanReadFields(new string[]{
            'dmpl__SaleOrderLineId__c',
            'dmpl__Quantity__c',
            'dmpl__AllocatedQuantity__c',
            'dmpl__PendingInvoiceQuantity__c',
            'dmpl__ItemLotTypeId__c',
            'dmpl__ItemLotId__c',
            'dmpl__InventoryLedgerId__c',
            'dmpl__StorageLocationId__c', 
            'dmpl__RepairOrderLineId__c',
            'dmpl__UnitCost__c'}, 
            'dmpl__InventoryFulfillmentAllocationLine__c');

        return [SELECT Id,
            Name,
            dmpl__Quantity__c,
            dmpl__AllocatedQuantity__c,
            dmpl__PendingInvoiceQuantity__c,
            dmpl__DeliveredInvoicedQuantity__c,
            dmpl__PickedDeliveredQuantity__c,
            dmpl__PickedQuantity__c,
            dmpl__ItemLotTypeId__c,
            dmpl__ItemLotId__c,
            dmpl__InventoryLedgerId__c,
            dmpl__StorageLocationId__c,
            dmpl__UnitCost__c,
            dmpl__SaleOrderLineId__c,
            dmpl__DeliveryQuantity__c,
            dmpl__RepairOrderLineId__c,
            dmpl__PickedInvoiceQuantity__c,
            dmpl__FulfillmentOrderLineId__r.dmpl__SaleOrderLineId__c
        FROM dmpl__InventoryFulfillmentAllocationLine__c
        WHERE 
            Id IN :allocationLineIds
        ];
    }

    private static List<Id> queryTransactedObjectIds(List<dmpl__SaleInvoice__c> newEntries){
        SecurityHelper.ensureCanReadFields(new string[]{'dmpl__SaleInvoiceId__c'}, 'dmpl__SaleInvoiceLine__c');
        return DocumentHelper.extractIds([SELECT dmpl__SaleInvoiceId__c 
                FROM dmpl__SaleInvoiceLine__c
                WHERE dmpl__SaleInvoiceId__c IN:DocumentHelper.extractIds(newEntries)], FIELD_SALEINVOICELINE_SALEINVOICEID);
    }

    public static CreateRelatedResult postGL(Id invoiceId){
        return SaleInvoiceLineHelper.postGL(invoiceId);
     }
 
     public static CreateRelatedResult postGL(List<SourceObjectInfo> orderLinesInfo, Id invoiceId){
         return SaleInvoiceLineHelper.postGL(orderLinesInfo, invoiceId);
     }

    private static void PostGL(List<dmpl__SaleInvoice__c> invoices)
    {
        SecurityHelper.ensureCanWriteField('dmpl__IsGLPostingApproved__c', 'dmpl__SaleInvoice__c');
        SecurityHelper.ensureCanWriteField('dmpl__PerformGLPosting__c', 'dmpl__SaleInvoice__c');
        for(dmpl__SaleInvoice__c document : invoices){
            //document.dmpl__IsGLPostingApproved__c = true;
            document.dmpl__PerformGLPosting__c = false;
        }
        SaleInvoiceLineHelper.approveSaleInvoiceLines(invoices);
        //SaleInvoiceTaxHelper.approveSaleTaxLines(invoices);
    }

    private static dmpl__SaleInvoice__c querySaleInvoice(Id saleInvoiceId){
        if(saleInvoiceId == null){
            return null;
        }
        return [SELECT 
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
                dmpl__TransactionType__c
            FROM dmpl__SaleInvoice__c 
            WHERE ID = : saleInvoiceId];
    }
    
    private static List<dmpl__RepairOrderLine__c> queryRepairOrderLines(List<ID> repairOrderIds, List<Id> repairOrderLineIds)
    {
        if(repairOrderIds == null){
            repairOrderIds = new List<Id>();
        }
        if(repairOrderLineIds == null){
            repairOrderLineIds = new List<Id>();
        }
        SecurityHelper.ensureCanReadFields(new string[]{
            'dmpl__AssetId__c',
            'dmpl__BranchId__c',
            'dmpl__PartnerAccountId__c',
            'dmpl__DocumentDate__c',
            'dmpl__AccountId__c',
            'dmpl__ServiceAdvisorId__c',
            'dmpl__ServiceContractItemId__c',
            'dmpl__ItemServiceContractId__c',
            'dmpl__PriceListId__c',
            'dmpl__DiscountGroupId__c',
            'dmpl__Discount__c'},
            'dmpl__RepairOrder__c');
        SecurityHelper.ensureCanReadFields(new string[]{
        'dmpl__ItemId__c',
        'dmpl__SKUId__c',
        'dmpl__Quantity__c',
        'dmpl__AllocatedQuantity__c',
        'dmpl__UnitPrice__c',
        'dmpl__UnitPrice2__c',
        'dmpl__TaxGroupId__c',
        'dmpl__PostingType__c',
        'dmpl__IsInvoiced__c',
        'dmpl__RepairOrderId__c',
        'dmpl__InvoiceGroup__c',
        'dmpl__Discount__c',
        'dmpl__DiscountAmount__c'}, 
        'dmpl__RepairOrderLine__c');
        return [SELECT
        ID,
        Name,
        dmpl__ItemId__c,
        dmpl__SKUId__c,
        dmpl__Quantity__c,
        dmpl__AllocatedQuantity__c,
        dmpl__UnitPrice__c,
        dmpl__UnitPrice2__c,
        dmpl__TaxGroupId__c,
        dmpl__PostingType__c,
        dmpl__IsInvoiced__c,
        dmpl__RepairOrderId__c,
        dmpl__ItemServiceContractId__c,
        dmpl__ItemServiceContractId2__c,
        dmpl__ItemServiceContractId3__c,
        dmpl__ServiceContractWeightage__c,
        dmpl__ServiceContractWeightage2__c,
        dmpl__ServiceContractWeightage3__c,
        dmpl__RepairOrderId__r.dmpl__AssetId__c,
        dmpl__RepairOrderId__r.dmpl__BranchId__c,
        dmpl__RepairOrderId__r.dmpl__PartnerAccountId__c,
        dmpl__RepairOrderId__r.dmpl__DocumentDate__c,
        dmpl__RepairOrderId__r.dmpl__AccountId__c,
        dmpl__RepairOrderId__r.dmpl__ServiceAdvisorId__c,
        dmpl__RepairOrderId__r.dmpl__ServiceContractItemId__c,
        dmpl__RepairOrderId__r.dmpl__ItemServiceContractId__c,
        dmpl__RepairOrderId__r.dmpl__PriceListId__c,
        dmpl__RepairOrderId__r.dmpl__DiscountGroupId__c,
        dmpl__RepairOrderId__r.dmpl__Discount__c,
        dmpl__InvoiceGroup__c,
        dmpl__Discount__c,
        dmpl__DiscountAmount__c,
        dmpl__Discount2__c,
        dmpl__DiscountAmount2__c,
        dmpl__ContractDiscount__c,
        dmpl__ContractDiscountAmount__c,
        dmpl__SchemeDiscount__c,
        dmpl__SchemeDiscountAmount__c

        FROM dmpl__RepairOrderLine__c
        WHERE (dmpl__RepairOrderId__c IN : repairOrderIds OR Id IN : repairOrderLineIds)
        AND dmpl__dmpl_PendingInvoiceQuantity__c > 0
        AND (dmpl__PostingType__c = 'Generate Invoices' OR dmpl__PostingType__c = 'Generate Invoices'
        OR dmpl__ItemServiceContractId2__r.dmpl__ContractPostingTreatment__c  ='Generate Invoices'
        OR dmpl__ItemServiceContractId3__r.dmpl__ContractPostingTreatment__c = 'Generate Invoices')];
    }

    private static List<dmpl__Claim__c> queryClaims(List<Id> claimIds)
    {
        SecurityHelper.ensureCanReadFields(new string[]{
            'dmpl__BranchId__c',
            'dmpl__ClaimType__c',
            'dmpl__DocumentDate__c',
            'dmpl__PartnerAccountId__c',
            'dmpl__SupplierNameId__c'}, 
            'dmpl__Claim__c');
        SecurityHelper.ensureCanReadFields(new string[]{
            'dmpl__ApproveQuantity__c',
            'dmpl__BranchId__c',
            'dmpl__ClaimId__c',
            'dmpl__ClaimQuantity__c',
            'dmpl__ClaimType__c',
            'dmpl__IsClaimReconciliationCreated__c',
            'dmpl__ItemId__c',
            'dmpl__PartnerAccountId__c',
            'dmpl__ServiceContractId__c',
            'dmpl__Status__c',
            'dmpl__TaxGroupId__c',
            'dmpl__UnitPrice__c',
            'dmpl__UnitPrice2__c'}, 
            'dmpl__ClaimLine__c');

        return [SELECT
        dmpl__BranchId__c,
        dmpl__ClaimType__c,
        dmpl__DocumentDate__c,
        dmpl__PartnerAccountId__c,
        dmpl__RepairOrderId__c,
        dmpl__SupplierNameId__c,
        Id,
        Name,
        (
            SELECT
                dmpl__ApproveQuantity__c,
                dmpl__BranchId__c,
                dmpl__ClaimId__c,
                dmpl__ClaimQuantity__c,
                dmpl__ClaimType__c,
                dmpl__IsClaimReconciliationCreated__c,
                dmpl__ItemId__c,
                dmpl__PartnerAccountId__c,
                dmpl__ServiceContractId__c,
                dmpl__Status__c,
                dmpl__TaxGroupId__c,
                dmpl__UnitPrice__c,
                dmpl__UnitPrice2__c,
                dmpl__ApproveDiscount__c,
                dmpl__ApproveDiscountAmount__c,
                Id,
                Name,
                dmpl__RepairOrderLineId__c
            FROM
                dmpl__Claim_Lines1__r
            WHERE 
            dmpl__IsClaimReconciliationCreated__c = false
        )
    FROM
        dmpl__Claim__c 
        WHERE Id IN : claimIds
        And dmpl__IsReconciled__c = false];
    }

    private static List<dmpl__ClaimBatch__c> queryClaimBatch(List<Id> claimBatchIds)
    {
        SecurityHelper.ensureCanReadFields(new string[]{'dmpl__IsReconciled__c','dmpl__ApproveAll__c','dmpl__BranchId__c','dmpl__DocumentDate__c','dmpl__IsClaimLinePopulated__c','dmpl__PartnerAccountId__c','dmpl__PerformPopulateClaimLines__c','dmpl__PerformReconciliation__c','dmpl__Remarks__c','dmpl__Status__c','dmpl__TotalApprovedAmount__c','dmpl__TotalApprovedQuantity__c'}, 'dmpl__ClaimBatch__c');
        SecurityHelper.ensureCanReadFields(new string[]{'dmpl__ApproveAmount__c','dmpl__ApproveQuantity__c','dmpl__BatchClaimId__c','dmpl__BranchId__c','dmpl__ClaimAmount__c','dmpl__ClaimBatchId__c','dmpl__ClaimBatchLineId__c','dmpl__ClaimId__c','dmpl__ClaimQuantity__c','dmpl__ClaimType__c','dmpl__ComplaintFaultCodeId__c','dmpl__ComplaintId__c','dmpl__ExternalId__c','dmpl__GoodsReceiptId__c','dmpl__GoodsReceiptLineId__c','dmpl__IsBatch__c','dmpl__IsClaimReconciliationCreated__c','dmpl__ItemCode__c','dmpl__ItemId__c','dmpl__PartnerAccountId__c','dmpl__RejectAmount__c','dmpl__RejectQuantity__c','dmpl__RepairOrderId__c','dmpl__RepairOrderLineId__c','dmpl__ServiceContractId__c','dmpl__Status__c','dmpl__TaxGroupId__c','dmpl__TechnicianId__c','dmpl__UnitPrice__c','dmpl__UnitPrice2__c'}, 'dmpl__ClaimLine__c');
        return [SELECT
        dmpl__IsReconciled__c,
        Name,
        dmpl__ApproveAll__c,
        dmpl__BranchId__c,
        dmpl__DocumentDate__c,
        dmpl__IsClaimLinePopulated__c,
        dmpl__PartnerAccountId__c,
        dmpl__PerformPopulateClaimLines__c,
        dmpl__PerformReconciliation__c,
        dmpl__Remarks__c,
        dmpl__Status__c,
        dmpl__TotalApprovedAmount__c,
        dmpl__TotalApprovedQuantity__c,
        (
            SELECT
                dmpl__ApproveAmount__c,
                dmpl__ApproveQuantity__c,
                dmpl__BatchClaimId__c,
                dmpl__BranchId__c,
                dmpl__ClaimAmount__c,
                dmpl__ClaimBatchId__c,
                dmpl__ClaimBatchLineId__c,
                dmpl__ClaimId__c,
                dmpl__ClaimQuantity__c,
                dmpl__ClaimType__c,
                dmpl__ComplaintFaultCodeId__c,
                dmpl__ComplaintId__c,
                dmpl__ExternalId__c,
                dmpl__GoodsReceiptId__c,
                dmpl__GoodsReceiptLineId__c,
                dmpl__IsBatch__c,
                dmpl__IsClaimReconciliationCreated__c,
                dmpl__ItemCode__c,
                dmpl__ItemId__c,
                dmpl__PartnerAccountId__c,
                dmpl__RejectAmount__c,
                dmpl__RejectQuantity__c,
                dmpl__RepairOrderId__c,
                dmpl__RepairOrderLineId__c,
                dmpl__ServiceContractId__c,
                dmpl__Status__c,
                dmpl__TaxGroupId__c,
                dmpl__TechnicianId__c,
                dmpl__UnitPrice__c,
                dmpl__UnitPrice2__c,
                dmpl__ApproveDiscount__c,
                dmpl__ApproveDiscountAmount__c,
                Id,
                Name
            FROM
                dmpl__ClaimLines__r
        )
    FROM
        dmpl__ClaimBatch__c
    WHERE 
        Id IN : claimBatchIds];
    }
}