public with sharing class ServiceEstimateHelper 
{
    private static Boolean skipValidations = false;

    private static final string OBJECT_QUOTE = 'dmpl__Quote__c';
    private static final string OBJECT_QUOTELINE = 'dmpl__QuoteLine__c';

    private static final string FIELD_QUOTE_ACCOUNTID = 'dmpl__AccountId__c';
    private static final string FIELD_QUOTE_ASSETID = 'dmpl__AssetId__c';
    private static final string FIELD_QUOTE_COMPLAINTID = 'dmpl__ComplaintId__c';
    private static final string FIELD_QUOTE_CUSTOMERVOICE = 'dmpl__CustomerVoice__c';
    private static final string FIELD_QUOTE_ESTIMATEREJECTTIONREASON = 'dmpl__EstimateRejectionReason__c';
    private static final string FIELD_QUOTE_ESTIMATEDLABOURCOST = 'dmpl__EstimatedLabourCost__c';
    private static final string FIELD_QUOTE_ESTIMATEPARTCOST = 'dmpl__EstimatedPartCost__c';
    private static final string FIELD_QUOTE_PACKAGESERVICEID = 'dmpl__PackageServiceId__c';
    private static final string FIELD_QUOTE_PARTNERACCOUNTID = 'dmpl__PartnerAccountId__c';
    private static final string FIELD_QUOTE_REPAIRORDERID = 'dmpl__RepairOrderId__c';
    private static final string FIELD_QUOTE_SERVICEADVISORID = 'dmpl__ServiceAdvisorId__c';
    private static final string FIELD_QUOTE_SERVICEREQUESTID = 'dmpl__ServiceRequestId__c';
    private static final string FIELD_QUOTE_ESTIMATEDATE = 'dmpl__EstimateDate__c';
    private static final string FIELD_QUOTE_USAGEREADING = 'dmpl__UsageReading__c';
    private static final string FIELD_QUOTE_SERVICECONTRACTITEMID = 'dmpl__ServiceContractItemId__c';
    private static final string FIELD_QUOTE_ITEMSERVICECONTRACTID = 'dmpl__ItemServiceContractId__c';
    private static final string FIELD_QUOTE_BRANCHID = 'dmpl__BranchId__c';
    private static final string FIELD_QUOTE_STATUS = 'dmpl__Status__c';
    private static final string FIELD_QUOTE_REPAIRORDERSERVICEESTIMATEID = 'dmpl__ServiceEstimateId__c';

    private static final string FIELD_QUOTE_PERFORMESTIMATELINESGENERATION = 'dmpl__PerformEstimateLinesGeneration__c';
    private static final string FIELD_QUOTE_ISESTIMATELINESGENERATED = 'dmpl__IsEstimateLinesGenerated__c';
    private static final string FIELD_QUOTE_PERFORMAPPROVAL = 'dmpl__PerformApproval__c';
    private static final string FIELD_QUOTE_ISAPPROVED = 'dmpl__IsApproved__c';
    private static final string FIELD_QUOTE_PERFORMDECLINE = 'dmpl__PerformDecline__c';
    private static final string FIELD_QUOTE_ISDECLINED = 'dmpl__IsDeclined__c';
    private static final string FIELD_QUOTE_PERFORMREPAIRORDERGENERATION = 'dmpl__PerformRepairOrderGeneration__c';
    private static final string FIELD_QUOTE_PERFORMUPDATEREPAIRORDER = 'dmpl__PerformUpdateRepairOrder__c';
    private static final string FIELD_QUOTE_ISREPAIRORDERGENERATED = 'dmpl__IsRepairOrderGenerated__c';

    private static final string FIELD_QUOTE_BILLINGADDRESS ='dmpl__BillingAddress__c';
    private static final string FIELD_QUOTE_SHIPPINGADDRESS ='dmpl__ShippingAddress__c';
    private static final string FIELD_QUOTE_BILLINGADDRESSID ='dmpl__BillingAddressId__c';
    private static final string FIELD_QUOTE_SHIPPINGADDRESSID ='dmpl__ShippingAddressId__c';

    private static final string FIELD_QUOTE_TAXGROUPID = 'dmpl__TaxGroupId__c';
    private static final string FIELD_QUOTE_TAXID = 'dmpl__TaxId__c';
    private static final string FIELD_QUOTE_AMOUNT = 'dmpl__TotalLineAmount__c';
    private static final string FIELD_QUOTE_GROSSAMOUNT = 'dmpl__TotalLineGrossAmount__c';
    private static final string FIELD_QUOTE_TCSELIGIBLEAMOUNT = 'dmpl__TCSEligibleAmount__c';
    
    private static final string FIELD_QUOTE_PERFORMSALEORDERGENERATION = 'dmpl__PerformSaleOrderGeneration__c';
    private static final string FIELD_QUOTE_ISSALEORDERGENERATED = 'dmpl__IsSaleOrderGenerated__c';
    
    private static final List<String> LIST_FIELDS_SYSTEM = new List<String>{FIELD_QUOTE_ISESTIMATELINESGENERATED, FIELD_QUOTE_ISAPPROVED, FIELD_QUOTE_ISDECLINED};
    private static final List<String> LIST_NON_EDITABLE_FIELDS = new List<String>{FIELD_QUOTE_SERVICEREQUESTID,FIELD_QUOTE_ASSETID,FIELD_QUOTE_BRANCHID, FIELD_QUOTE_ACCOUNTID, FIELD_QUOTE_PARTNERACCOUNTID};
    
    public static void validateData(Boolean isInsert, Boolean isUpdate, Boolean isDelete, List<dmpl__Quote__c> newEntries, List<dmpl__Quote__c> oldEntries)
    {
        try{
            if(skipValidations){
                return;
            }
    
            DocumentStatusDFSHelper dfsHelper = new DocumentStatusDFSHelper();
            if(isInsert){
                FieldMappingHelper.copyFieldMappingData(
                    newEntries);
                StatusHelper.validateStatusNew(OBJECT_QUOTE, FIELD_QUOTE_STATUS, newEntries);
                DocumentHelper.validateChangeInSystemFields(LIST_FIELDS_SYSTEM, newEntries);
                ValidationHelper.validatePartnerAndBranch(FIELD_QUOTE_PARTNERACCOUNTID, FIELD_QUOTE_BRANCHID, newEntries);
                ValidationHelper.validateResource(FIELD_QUOTE_SERVICEADVISORID, newEntries);
            }else if(isUpdate){
                StatusHelper.validateStatusEdit(OBJECT_QUOTE, FIELD_QUOTE_STATUS, oldEntries, newEntries);
                DocumentHelper.validateChangeInKeyFields(LIST_NON_EDITABLE_FIELDS, oldEntries, newEntries);
                DocumentHelper.validateChangeInSystemFields(LIST_FIELDS_SYSTEM, oldEntries, newEntries);
                dfsHelper.DocumentStatusRestrictEdits_Edit(OBJECT_QUOTE, FIELD_QUOTE_STATUS, oldEntries, newEntries);
                dfsHelper.DocumentStatusRestrictFieldsEdits(OBJECT_QUOTE, FIELD_QUOTE_STATUS, oldEntries, newEntries);
                ValidationHelper.validateResource(FIELD_QUOTE_SERVICEADVISORID, newEntries);
            }else if(isDelete){
                dfsHelper.DocumentStatusRestrictEdits_Delete(OBJECT_QUOTE, FIELD_QUOTE_STATUS, oldEntries);
            }
        } catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }

    public static void postData(Boolean isInsert, Boolean isUpdate, Boolean isDelete, List<dmpl__Quote__c> newEntries, List<dmpl__Quote__c> oldEntries)
    {
        if(isInsert)
        {
            PriceListHelper.setDefaultPriceListIds(newEntries);
            DiscountGroupHelper.setDefaultDiscountGroupIds(newEntries);
            setDefaultAddress(newEntries);
        	DocumentNameHelper.generateDocumentName(newEntries);
        }
        else if(isUpdate)
        {
            List<dmpl__Quote__c> modifiedObjects = DocumentHelper.getApprovedObjects(FIELD_QUOTE_PERFORMAPPROVAL, oldEntries, newEntries);
            if(modifiedObjects.size() > 0)
                approveServiceEstimateLines(modifiedObjects);

            modifiedObjects = DocumentHelper.getApprovedObjects(FIELD_QUOTE_PERFORMDECLINE, oldEntries, newEntries);
            if(modifiedObjects.size() > 0) 
                declineServiceEstimateLines(modifiedObjects);

            modifiedObjects = DocumentHelper.getApprovedObjects(FIELD_QUOTE_PERFORMREPAIRORDERGENERATION, oldEntries, newEntries);
            if(modifiedObjects.size() > 0) 
                createRepairOrder(modifiedObjects);

            modifiedObjects = DocumentHelper.getApprovedObjects(FIELD_QUOTE_PERFORMSALEORDERGENERATION, oldEntries, newEntries);
            if(modifiedObjects.size() > 0) 
                createSaleOrder(modifiedObjects);
            setDefaultAddress(newEntries,oldEntries);
            RoundOffHelper.setRoundOff(
                newEntries,
                'dmpl__TotalLineAmount__c',
                'dmpl__TotalTaxAmount2__c');
        }
    }

    public static void afterPostData(Boolean isInsert, Boolean isUpdate, Boolean isDelete, List<dmpl__Quote__c> newEntries, List<dmpl__Quote__c> oldEntries)
    {
        if(isInsert){
            PackageHelper.populatePackageItems(newEntries);
            TaxHelper.createHeaderTaxes(
                isInsert, 
                newEntries);
        }
        if(isUpdate)
        {
            List<dmpl__Quote__c> modifiedObjects = DocumentHelper.getModifiedNewObjects(FIELD_QUOTE_SERVICEREQUESTID, oldEntries, newEntries);
            if(modifiedObjects.size() > 0)        
                ServiceEstimateLineHelper.createQuoteLinesFromServiceRequest(modifiedObjects);

           modifiedObjects = DocumentHelper.getModifiedNewObjects(FIELD_QUOTE_ITEMSERVICECONTRACTID, oldEntries, newEntries);
           if(modifiedObjects.size() > 0)
                ServiceEstimateLineHelper.createServiceEstimateLinesFromContract(modifiedObjects);

            modifiedObjects = DocumentHelper.getModifiedNewObjects('dmpl__Discount__c', oldEntries, newEntries);
            if(modifiedObjects.size()>0){
                updateDiscountInQuoteLines(modifiedObjects);
            }

            modifiedObjects = DocumentHelper.getModifiedNewObjects(new string[]{
                FIELD_QUOTE_TAXGROUPID,
                FIELD_QUOTE_TAXID,
                FIELD_QUOTE_TCSELIGIBLEAMOUNT
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
                ServiceEstimateLineHelper.performReprice(
                    CollectionHelper.extractIds(modifiedObjects));
            }
        }
    }

    public static void createQuoteFromServiceRequest(List<dmpl__ServiceRequest__c> modifiedObjects)
    {
        List<dmpl__Quote__c> quoteDocuments = new List<dmpl__Quote__c>();

        for(dmpl__ServiceRequest__c serviceRequest : modifiedObjects)
            quoteDocuments.add(createQuoteDocumentFromServiceRequest(serviceRequest));
        
        if(quoteDocuments.size() >0){
            Savepoint sp = Database.setSavepoint();
            try {
                    SecurityHelper.ensureCanCreateObject('dmpl__Quote__c');
                    SecurityHelper.ensureCanCreateFields(new string[]{'dmpl__AssetId__c','dmpl__AccountId__c','dmpl__CustomerVoice__c','dmpl__Remarks__c','dmpl__PartnerAccountId__c','dmpl__ServiceAdvisorId__c','dmpl__UsageReading__c','dmpl__UsageReadingHours__c','dmpl__ItemServiceContractId__c','dmpl__ServiceContractItemId__c','dmpl__IsPickUpRequired__c','dmpl__IsDropOffRequired__c','dmpl__IsFieldService__c'}, 'dmpl__Quote__c');
                    insert quoteDocuments;
                    ServiceEstimateLineHelper.createQuoteLinesFromServiceRequest(quoteDocuments);
            } catch (Exception e) {
                Database.rollback(sp);
                throw e;
            }
        }
    }

    private static dmpl__Quote__c createQuoteDocumentFromServiceRequest(dmpl__ServiceRequest__c serviceRequest)
    {
        return new dmpl__Quote__c(
            dmpl__AssetId__c = serviceRequest.dmpl__AssetId__c,
            dmpl__AccountId__c = serviceRequest.dmpl__AccountId__c,
            dmpl__CustomerVoice__c = serviceRequest.dmpl__CustomerVoice__c,
            dmpl__PartnerAccountId__c = serviceRequest.dmpl__PartnerAccountId__c,
            dmpl__BranchId__c = serviceRequest.dmpl__BranchId__c,
            dmpl__ServiceAdvisorId__c = serviceRequest.dmpl__ServiceAdvisorId__c,
            dmpl__UsageReading__c = serviceRequest.dmpl__UsageReading__c,
            dmpl__UsageReadingHours__c = serviceRequest.dmpl__UsageReadingHours__c,
            dmpl__ItemServiceContractId__c =  serviceRequest.dmpl__QuoteForItemServiceContractId__c,
            dmpl__ServiceContractItemId__c = serviceRequest.dmpl__ServiceContractItemId__c,
            dmpl__IsPickUpRequired__c = serviceRequest.dmpl__IsPickUpRequired__c,
            dmpl__IsDropOffRequired__c = serviceRequest.dmpl__IsDropOffRequired__c,
            dmpl__IsFieldService__c = serviceRequest.dmpl__IsFieldService__c,
            dmpl__ServiceRequestId__c = serviceRequest.Id,
            dmpl__ServiceType__c = serviceRequest.dmpl__ServiceType__c,
            dmpl__DocumentDate__c = serviceRequest.dmpl__AppointmentDate__c
        );
    }

    public static void createQuoteFromRepairOrder(List<dmpl__RepairOrder__c> modifiedObjects)
    {
        List<dmpl__Quote__c> quoteDocuments = new List<dmpl__Quote__c>();

        for(dmpl__RepairOrder__c repairOrder : modifiedObjects)
            quoteDocuments.add(createQuoteDocumentFromRepairOrder(repairOrder));
        
        if(quoteDocuments.size() >0){
            Savepoint sp = Database.setSavepoint();
            try {
                    SecurityHelper.ensureCanCreateObject('dmpl__Quote__c');
                    SecurityHelper.ensureCanCreateFields(new string[]{'dmpl__AssetId__c','dmpl__AccountId__c','dmpl__CustomerVoice__c','dmpl__Remarks__c','dmpl__PartnerAccountId__c','dmpl__ServiceAdvisorId__c','dmpl__UsageReading__c','dmpl__UsageReadingHours__c','dmpl__ItemServiceContractId__c','dmpl__ServiceContractItemId__c','dmpl__IsPickUpRequired__c','dmpl__IsDropOffRequired__c','dmpl__IsFieldService__c'}, 'dmpl__Quote__c');
                    insert quoteDocuments;
                    ServiceEstimateLineHelper.createQuoteLinesFromRepairOrder(quoteDocuments);
            } catch (Exception e) {
                Database.rollback(sp);
                throw e;
            }
        }
    }

    private static dmpl__Quote__c createQuoteDocumentFromRepairOrder(dmpl__RepairOrder__c repairOrder)
    {
        return new dmpl__Quote__c(
            dmpl__AssetId__c = repairOrder.dmpl__AssetId__c,
            dmpl__AccountId__c = repairOrder.dmpl__AccountId__c,
            dmpl__CustomerVoice__c = repairOrder.dmpl__CustomerVoice__c,
            dmpl__PartnerAccountId__c = repairOrder.dmpl__PartnerAccountId__c,
            dmpl__BranchId__c = repairOrder.dmpl__BranchId__c,
            dmpl__ServiceAdvisorId__c = repairOrder.dmpl__ServiceAdvisorId__c,
            dmpl__UsageReading__c = repairOrder.dmpl__UsageReading__c,
            dmpl__UsageReadingHours__c = repairOrder.dmpl__UsageReadingHours__c,
            dmpl__ItemServiceContractId__c =  repairOrder.dmpl__QuoteForItemServiceContractId__c,
            dmpl__ServiceContractItemId__c = repairOrder.dmpl__ServiceContractItemId__c,
            dmpl__RepairOrderId__c = repairOrder.Id,
            dmpl__ServiceType__c = repairOrder.dmpl__ServiceType__c,
            dmpl__DocumentDate__c = repairOrder.dmpl__DocumentDate__c
        );
    }

    private static void approveServiceEstimateLines(List<dmpl__Quote__c> modifiedObjects)
    {
        ServiceEstimateLineHelper.approveServiceEstimateLines(modifiedObjects);
        SecurityHelper.ensureCanWriteField('dmpl__PerformApproval__c', 'dmpl__Quote__c');
        SecurityHelper.ensureCanWriteField('dmpl__IsDeclined__c', 'dmpl__Quote__c');
        SecurityHelper.ensureCanWriteField('dmpl__IsApproved__c', 'dmpl__Quote__c');
        for(dmpl__Quote__c lineEntry : modifiedObjects)
        {
            lineEntry.dmpl__PerformApproval__c = false;
            lineEntry.dmpl__IsApproved__c = true;
            lineEntry.dmpl__IsDeclined__c = false;
        }
    }

    private static void declineServiceEstimateLines(List<dmpl__Quote__c> modifiedObjects)
    {
        ServiceEstimateLineHelper.declineServiceEstimateLines(modifiedObjects);
        SecurityHelper.ensureCanWriteField('dmpl__PerformDecline__c', 'dmpl__Quote__c');
        SecurityHelper.ensureCanWriteField('dmpl__IsDeclined__c', 'dmpl__Quote__c');
        SecurityHelper.ensureCanWriteField('dmpl__IsApproved__c', 'dmpl__Quote__c');
        for(dmpl__Quote__c lineEntry : modifiedObjects)
        {
            lineEntry.dmpl__PerformDecline__c = false;
            lineEntry.dmpl__IsDeclined__c = true;
            lineEntry.dmpl__IsApproved__c = false;
        }
    }

    private static void createRepairOrder(List<dmpl__Quote__c> modifiedObjects)
    {
        List<dmpl__Quote__c> quoteWithRepairOrder = new List<dmpl__Quote__c>();
        List<dmpl__Quote__c> quoteWithoutRepairOrder = new List<dmpl__Quote__c>();
        for(dmpl__Quote__c quote : modifiedObjects)
        {
            if(!quote.dmpl__IsDeclined__c && quote.dmpl__ServiceRequestRepairOrderId__c != null)
                quoteWithRepairOrder.add(quote);
            else if(!quote.dmpl__IsDeclined__c)
                quoteWithoutRepairOrder.add(quote);
        }

        SecurityHelper.ensureCanWriteField('dmpl__PerformRepairOrderGeneration__c', 'dmpl__Quote__c');
        SecurityHelper.ensureCanWriteField('dmpl__IsRepairOrderGenerated__c', 'dmpl__Quote__c');
        SecurityHelper.ensureCanWriteField('dmpl__RepairOrderId__c', 'dmpl__Quote__c');
        for(dmpl__Quote__c lineEntry : modifiedObjects)
        {
            lineEntry.dmpl__PerformRepairOrderGeneration__c = false;
            lineEntry.dmpl__IsRepairOrderGenerated__c = true;
        }

        if(quoteWithoutRepairOrder.size() > 0)
        {
            List<dmpl__RepairOrder__c> newRepairOrders = RepairOrderHelper.createRepairOrderFromServiceEstimate(quoteWithoutRepairOrder);
            for(dmpl__RepairOrder__c repairOrder : newRepairOrders)
            {
                dmpl__Quote__c quote = new Map<Id,dmpl__Quote__c>(modifiedObjects).get(repairOrder.dmpl__ServiceEstimateId__c);
                if(quote != null)
                    quote.dmpl__RepairOrderId__c = repairOrder.Id;
            }
        }
        if(quoteWithRepairOrder.size() > 0)
        {
            RepairOrderHelper.updateRepairOrderFromServiceEstimate(quoteWithRepairOrder);
            for(dmpl__Quote__c quote : quoteWithRepairOrder)
                quote.dmpl__RepairOrderId__c = quote.dmpl__ServiceRequestRepairOrderId__c ;
        }
    }

    private static void createSaleOrder(List<dmpl__Quote__c> modifiedObjects){
        List<dmpl__Quote__c> quoteWithoutSaleOrder = new List<dmpl__Quote__c>();
        for(dmpl__Quote__c quote : modifiedObjects){
            if(!quote.dmpl__IsDeclined__c)
                quoteWithoutSaleOrder.add(quote);
        }

        SecurityHelper.ensureCanWriteField('dmpl__PerformSaleOrderGeneration__c', 'dmpl__Quote__c');
        SecurityHelper.ensureCanWriteField('dmpl__IsSaleOrderGenerated__c', 'dmpl__Quote__c');
        SecurityHelper.ensureCanWriteField('dmpl__SaleOrderId__c', 'dmpl__Quote__c');
        for(dmpl__Quote__c lineEntry : modifiedObjects){
            lineEntry.dmpl__PerformSaleOrderGeneration__c = false;
            lineEntry.dmpl__IsSaleOrderGenerated__c = true;
        }

        if(quoteWithoutSaleOrder.size() > 0){
            List<dmpl__SaleOrder__c> newSaleOrders = SaleOrderHelper.createSaleOrderFromServiceEstimate(quoteWithoutSaleOrder);
            for(dmpl__SaleOrder__c saleOrder : newSaleOrders){
                dmpl__Quote__c quote = new Map<Id,dmpl__Quote__c>(modifiedObjects).get(saleOrder.dmpl__QuoteId__c);
                if(quote != null)
                    quote.dmpl__SaleOrderId__c = saleOrder.Id;
            }
        }
    }


    @testVisible
    private static void updateDiscountInQuoteLines(List<dmpl__Quote__c> modifiedObjects)
    {
        Map<Id,dmpl__Quote__c> quotes = new Map<Id,dmpl__Quote__c>(modifiedObjects);
        List<dmpl__QuoteLine__c> quoteLines = [SELECT Id, Name, dmpl__QuoteId__c, dmpl__Discount__c FROM dmpl__QuoteLine__c WHERE dmpl__QuoteId__c IN : DocumentHelper.extractIds(modifiedObjects)];
        if(quoteLines.size() > 0){
            for(dmpl__QuoteLine__c line : quoteLines){
                dmpl__Quote__c quote = quotes.get(line.dmpl__QuoteId__c);
                line.dmpl__Discount__c = quote.dmpl__Discount__c;
            }
            SecurityHelper.ensureCanWriteFields(new string[]{'dmpl__Discount__c'}, 'dmpl__QuoteLine__c');
            update quoteLines;
        }
    }

    private static void setDefaultAddress(List<dmpl__Quote__c> newEntries){
        SecurityHelper.ensureCanWriteFields(new List<String>
        {
            FIELD_QUOTE_SHIPPINGADDRESS,
            FIELD_QUOTE_BILLINGADDRESS,
            'dmpl__BillingCity__c',
            'dmpl__BillingCountry__c',
            'dmpl__BillingPostalCode__c',
            'dmpl__BillingRegion__c',
            'dmpl__Billing__c',
            'dmpl__BillingStreet__c',
            'dmpl__ShippingCity__c',
            'dmpl__ShippingCountry__c',
            'dmpl__ShippingPostalCode__c',
            'dmpl__ShippingRegion__c',
            'dmpl__ShippingState__c',
            'dmpl__ShippingStreet__c'
        }, OBJECT_QUOTE);

        List<Account> accounts = AccountHelper.getCachedAccounts(CollectionHelper.extractIds(newEntries, FIELD_QUOTE_ACCOUNTID));
        for(dmpl__Quote__c quote : newEntries){
            Account account = (Account)CollectionHelper.getObject(accounts, quote.dmpl__AccountId__c);
            if(account!=null){
                AccountHelper.setDefaultAddress(quote, account);
            }
        }
    }

    private static void setDefaultAddress(List<dmpl__Quote__c> newEntries, List<dmpl__Quote__c> oldEntries){
        SecurityHelper.ensureCanWriteFields(new List<String>
        {
            FIELD_QUOTE_SHIPPINGADDRESS,
            FIELD_QUOTE_BILLINGADDRESS
        }, OBJECT_QUOTE);
        Account account = null;
        List<Account> accounts = AccountHelper.getCachedAccounts(CollectionHelper.extractIds(newEntries, FIELD_QUOTE_ACCOUNTID));
        List<dmpl__Quote__c> modifiedOrders = DocumentHelper.getModifiedNewObjects(FIELD_QUOTE_BILLINGADDRESSID, oldEntries, newEntries);
        for(dmpl__Quote__c quote : modifiedOrders){
            account = (Account)CollectionHelper.getObject(accounts, quote.dmpl__AccountId__c);
            if(account!=null){
                AccountHelper.setDefaultAddress(quote, account);
            }
        }
        
        modifiedOrders = DocumentHelper.getModifiedNewObjects(FIELD_QUOTE_SHIPPINGADDRESSID, oldEntries, newEntries);
        for(dmpl__Quote__c quote : modifiedOrders){
            account = (Account)CollectionHelper.getObject(accounts, quote.dmpl__AccountId__c);
            if(account!=null){
                if(quote.dmpl__ShippingAddressId__c!=null){
                    dmpl__ContactAddress__c address = (dmpl__ContactAddress__c)CollectionHelper.getObject(account.dmpl__ContactAddress__r, quote.dmpl__ShippingAddressId__c);
                    if(address!=null){
                        quote.dmpl__ShippingAddress__c = AccountHelper.formatAddress(address);
                    }
                }else {
                    quote.dmpl__ShippingAddress__c = AccountHelper.formatAddress(account.ShippingAddress);
                }
            }
        }
    }

    @testVisible
    private static List<dmpl__Quote__c> queryServiceQuotes(List<ID> serviceQuoteIds)
    {
        SecurityHelper.ensureCanReadFields(new List<String>{
            'dmpl__RepairOrderId__c'
            }, 'dmpl__Quote__c');
        return [SELECT ID,
        Name,
        dmpl__RepairOrderId__c
        FROM dmpl__Quote__c
        WHERE ID IN : serviceQuoteIds];
    }
}