public with sharing class ServiceRequestHelper 
{
    private static Boolean skipValidations = false;

    private static final string OBJECT_SERVICEREQUEST = 'dmpl__ServiceRequest__c';

    private static final string FIELD_SERVICEREQUEST_STATUS = 'dmpl__Status__c';
    private static final string FIELD_SERVICEREQUEST_PARTNERACCOUNTID = 'dmpl__PartnerAccountId__c';
    private static final string FIELD_SERVICEREQUEST_BRANCHID = 'dmpl__BranchId__c';
    private static final string FIELD_SERVICEREQUEST_ACCOUNTID = 'dmpl__AccountId__c';
    private static final string FIELD_SERVICEREQUEST_APPOINTMENTDATE = 'dmpl__AppointmentDate__c';
    private static final string FIELD_SERVICEREQUEST_APPOINTMENTDATETIME = 'dmpl__AppointmentDateTIme__c';
    private static final string FIELD_SERVICEREQUEST_SERVICEREQUESTTIMESLOTID = 'dmpl__AppointmentTimeSlotId__c';
    private static final string FIELD_SERVICEREQUEST_SERVICECONTRACTITEMID = 'dmpl__ServiceContractItemId__c';
    private static final string FIELD_SERVICEREQUEST_ITEMSERVICECONTRACTID = 'dmpl__ItemServiceContractId__c';
    private static final string FIELD_SERVICEREQUEST_ASSETID = 'dmpl__AssetId__c';
    private static final string FIELD_SERVICEREQUEST_SERVICEREQUESTID = 'dmpl__ServiceRequestId__c';
    private static final string FIELD_SERVICEREQUEST_SERVICEADVISORID = 'dmpl__ServiceAdvisorId__c';
    private static final string FIELD_SERVICEREQUEST_PICKUPASSIGNEDTOLD = 'dmpl__PickUpAssignedToId__c';

    private static final string FIELD_SERVICEREQUEST_PERFORMPOPULATELINES = 'dmpl__PerformPopulateLines__c';
    private static final string FIELD_SERVICEREQUEST_ISLINEPOPULATED = 'dmpl__IsLinePopulated__c';
    
    private static final string FIELD_SERVICEREQUEST_PERFORMGENERATEQUOTE = 'dmpl__PerformGenerateQuote__c';
    private static final string FIELD_SERVICEREQUEST_ISQUOTEGENERATED = 'dmpl__IsQuoteGenerated__c';

    private static final string FIELD_SERVICEREQUEST_PERFORMREPAIRORDERGENERATION = 'dmpl__PerformGenerateRepairOrder__c';
    private static final string FIELD_SERVICEREQUEST_ISREPAIRGENERATED = 'dmpl__IsRepairOrderGenerated__c';

    private static final string FIELD_SERVICEREQUEST_PERFORMSALEORDERGENERATION = 'dmpl__PerformGenerateSaleOrder__c';
    private static final string FIELD_SERVICEREQUEST_ISSALEORDERGENERATED = 'dmpl__IsSaleOrderGenerated__c';
    
    private static final string FIELD_SERVICEREQUEST_PERFORMCONFIRM = 'dmpl__PerformConfirm__c';
    private static final string FIELD_SERVICEREQUEST_ISCONFIRMED = 'dmpl__IsConfirmed__c';

    private static final string FIELD_SERVICEREQUEST_PERFORMCANCEL = 'dmpl__PerformCancel__c';
    private static final string FIELD_SERVICEREQUEST_ISCANCELLED = 'dmpl__IsCancelled__c';

    private static final string FIELD_SERVICEREQUEST_BILLINGADDRESS ='dmpl__BillingAddress__c';
    private static final string FIELD_SERVICEREQUEST_SHIPPINGADDRESS ='dmpl__ShippingAddress__c';
    private static final string FIELD_SERVICEREQUEST_BILLINGADDRESSID ='dmpl__BillingAddressId__c';
    private static final string FIELD_SERVICEREQUEST_SHIPPINGADDRESSID ='dmpl__ShippingAddressId__c';

    private static final string FIELD_SERVICEREQUEST_TAXGROUPID = 'dmpl__TaxGroupId__c';
    private static final string FIELD_SERVICEREQUEST_TAXID = 'dmpl__TaxId__c';
    private static final string FIELD_SERVICEREQUEST_AMOUNT = 'dmpl__LineSubTotal__c';
    private static final string FIELD_SERVICEREQUEST_GROSSAMOUNT = 'dmpl__TotalLineGrossAmount__c';
    private static final string FIELD_SERVICEREQUEST_TCSELIGIBLEAMOUNT = 'dmpl__TCSEligibleAmount__c';
    
    private static final string FIELD_SERVICEREQUEST_PERFORMKPICALCULATION = 'dmpl__PerformKPICalculation__c';

    private static final List<String> LIST_NON_EDITABLE_FIELDS = new List<String>{FIELD_SERVICEREQUEST_BRANCHID, FIELD_SERVICEREQUEST_PARTNERACCOUNTID, FIELD_SERVICEREQUEST_ISLINEPOPULATED, FIELD_SERVICEREQUEST_ISCONFIRMED, FIELD_SERVICEREQUEST_ISCANCELLED};
    private static final List<String> LIST_FIELDS_SYSTEM = new List<String>{FIELD_SERVICEREQUEST_APPOINTMENTDATETIME};

    public static void validateData(Boolean isInsert, Boolean isUpdate, Boolean isDelete, List<dmpl__ServiceRequest__c> newEntries, List<dmpl__ServiceRequest__c> oldEntries)
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
                //validateOnOpenServiceRequest(newEntries);
                StatusHelper.validateStatusNew(OBJECT_SERVICEREQUEST, FIELD_SERVICEREQUEST_STATUS, newEntries);
                DocumentHelper.validateChangeInSystemFields(LIST_FIELDS_SYSTEM, newEntries);
                ValidationHelper.validatePartnerAndBranch(FIELD_SERVICEREQUEST_PARTNERACCOUNTID, FIELD_SERVICEREQUEST_BRANCHID, newEntries);
                ValidationHelper.validateResource(FIELD_SERVICEREQUEST_SERVICEADVISORID, newEntries);
                ValidationHelper.validateResource(FIELD_SERVICEREQUEST_PICKUPASSIGNEDTOLD, newEntries);
                AssetHelper.validateUsageReadings(newEntries);
                AssetServiceContractHelper.validateHeaderItemServiceContract(
                    newEntries);
            }else if(isUpdate){
                StatusHelper.validateStatusEdit(OBJECT_SERVICEREQUEST, FIELD_SERVICEREQUEST_STATUS, oldEntries, newEntries);
                DocumentHelper.validateChangeInKeyFields(LIST_NON_EDITABLE_FIELDS, oldEntries, newEntries);
                DocumentHelper.validateChangeInSystemFields(LIST_FIELDS_SYSTEM, oldEntries, newEntries);
                dfsHelper.DocumentStatusRestrictEdits_Edit(OBJECT_SERVICEREQUEST, FIELD_SERVICEREQUEST_STATUS, oldEntries, newEntries);
                dfsHelper.DocumentStatusRestrictFieldsEdits(OBJECT_SERVICEREQUEST, FIELD_SERVICEREQUEST_STATUS, oldEntries, newEntries);
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
                ValidationHelper.validateResource(FIELD_SERVICEREQUEST_SERVICEADVISORID, newEntries);
                ValidationHelper.validateResource(FIELD_SERVICEREQUEST_PICKUPASSIGNEDTOLD, newEntries);
            }else if(isDelete){
                dfsHelper.DocumentStatusRestrictEdits_Delete(OBJECT_SERVICEREQUEST, FIELD_SERVICEREQUEST_STATUS, oldEntries);
            }
        } catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }

    public static void postData(Boolean isInsert, Boolean isUpdate, Boolean isDelete, List<dmpl__ServiceRequest__c> newEntries, List<dmpl__ServiceRequest__c> oldEntries)
    {
        DocumentStatusDFSHelper dfsHelper = new DocumentStatusDFSHelper();

        if(isInsert){
            dfsHelper.DocumentStatusSetFlag(OBJECT_SERVICEREQUEST, FIELD_SERVICEREQUEST_STATUS, newEntries);
            dfsHelper.DocumentStatusReSetFlag(OBJECT_SERVICEREQUEST, FIELD_SERVICEREQUEST_STATUS, newEntries);
            DocumentNameHelper.generateDocumentName(newEntries);
            assignResource(newEntries);
            DiscountGroupHelper.setDefaultDiscountGroupIds(newEntries);
            PriceListHelper.setDefaultPriceListIds(newEntries);
            setDefaultAddress(newEntries);
            // BranchTimeSlotBookingHelper.reserveServiceRequestTimeSlots(newEntries);
        }else if(isUpdate){
            setDefaultAddress(newEntries,oldEntries);
            RoundOffHelper.setRoundOff(
                newEntries,
                'dmpl__LineSubTotal__c',
                'dmpl__TotalTaxAmount2__c');
            dfsHelper.DocumentStatusSetFlag(OBJECT_SERVICEREQUEST, FIELD_SERVICEREQUEST_STATUS, oldEntries, newEntries);
            dfsHelper.DocumentStatusReSetFlag(OBJECT_SERVICEREQUEST, FIELD_SERVICEREQUEST_STATUS, oldEntries, newEntries);
            // List<dmpl__ServiceRequest__c> modifiedObjects = DocumentHelper.getModifiedNewObjects(new String[]{FIELD_SERVICEREQUEST_SERVICEREQUESTTIMESLOTID, FIELD_SERVICEREQUEST_APPOINTMENTDATE, FIELD_SERVICEREQUEST_ISCONFIRMED, FIELD_SERVICEREQUEST_ISCANCELLED}, oldEntries, newEntries);
            // if(modifiedObjects.size()>0){
            //     BranchTimeSlotBookingHelper.releaseServiceRequestTimeSlots(modifiedObjects);
            //     BranchTimeSlotBookingHelper.reserveServiceRequestTimeSlots(modifiedObjects);
            // }
            
            // List<dmpl__ServiceRequest__c> modifiedObjects = DocumentHelper.getModifiedNewObjects(FIELD_SERVICEREQUEST_ITEMSERVICECONTRACTID, oldEntries, newEntries);
            // if(modifiedObjects.size() > 0)
            //     populateServiceRequestLinesFromContract(modifiedObjects);

            List<dmpl__ServiceRequest__c> modifiedObjects = DocumentHelper.getApprovedObjects(FIELD_SERVICEREQUEST_PERFORMCONFIRM, oldEntries, newEntries);
            if(modifiedObjects.size() > 0)
                confirmServiceRequests(modifiedObjects);

            modifiedObjects = DocumentHelper.getApprovedObjects(FIELD_SERVICEREQUEST_PERFORMCANCEL, oldEntries, newEntries);
            if(modifiedObjects.size() > 0)
                cancelServiceRequests(modifiedObjects);
            
            modifiedObjects = DocumentHelper.getApprovedObjects(FIELD_SERVICEREQUEST_PERFORMGENERATEQUOTE, oldEntries, newEntries);
            if(modifiedObjects.size() > 0)
                generateQuote(modifiedObjects);
            
            modifiedObjects = DocumentHelper.getApprovedObjects(FIELD_SERVICEREQUEST_PERFORMREPAIRORDERGENERATION, oldEntries, newEntries);
            if(modifiedObjects.size() > 0) 
                createRepairOrder(modifiedObjects);
            
            modifiedObjects = DocumentHelper.getApprovedObjects(
                FIELD_SERVICEREQUEST_PERFORMSALEORDERGENERATION, 
                oldEntries, 
                newEntries);
            if(modifiedObjects.size() > 0) 
                createSaleOrder(
                    modifiedObjects);

            modifiedObjects = DocumentHelper.getApprovedObjects(FIELD_SERVICEREQUEST_PERFORMKPICALCULATION, oldEntries, newEntries);
            if(modifiedObjects.size()>0){
                updatePerformanceKPI(modifiedObjects);
            }
        }else if(isDelete){
            // BranchTimeSlotBookingHelper.releaseServiceRequestTimeSlots(oldEntries);
        }
    }

    public static void afterPostData(Boolean isInsert, Boolean isUpdate, Boolean isDelete, List<dmpl__ServiceRequest__c> newEntries, List<dmpl__ServiceRequest__c> oldEntries)
    {
        if(isInsert){
            ServiceRequestLineHelper.populateLinesForAssetMaintenance(
                newEntries,
                false);
            TaxHelper.createHeaderTaxes(
                isInsert, 
                newEntries);
            List<dmpl__ServiceRequest__c> serviceRequestsWithServiceContract = DocumentHelper.getObjectsWithNotNull(newEntries, FIELD_SERVICEREQUEST_ITEMSERVICECONTRACTID);
            if(serviceRequestsWithServiceContract.size() > 0)
                populateServiceRequestLinesFromContract(serviceRequestsWithServiceContract);
        }else if(isUpdate) {
            List<dmpl__ServiceRequest__c> modifiedObject = DocumentHelper.getModifiedNewObjects(FIELD_SERVICEREQUEST_ITEMSERVICECONTRACTID, oldEntries, newEntries);
            if(modifiedObject.size() > 0)
                populateServiceRequestLinesFromContract(modifiedObject);

            modifiedObject = DocumentHelper.getModifiedNewObjects(
                'dmpl__Discount__c', 
                oldEntries, 
                newEntries);

            if(modifiedObject.size()>0){
                updateDiscountInServiceRequestLines(modifiedObject);
            }

            List<dmpl__ServiceRequest__c> modifiedObjects = DocumentHelper.getModifiedNewObjects(
                'dmpl__PriceAsOnDate__c', 
                oldEntries, 
                newEntries);
            if(modifiedObjects.size()>0){
                ServiceRequestLineHelper.performReprice(
                    CollectionHelper.extractIds(modifiedObjects));
            }
            
            modifiedObjects = DocumentHelper.getModifiedNewObjects(new string[]{
                FIELD_SERVICEREQUEST_TAXGROUPID,
                FIELD_SERVICEREQUEST_TAXID,
                FIELD_SERVICEREQUEST_TCSELIGIBLEAMOUNT
            }, oldEntries, newEntries);
            if(modifiedObjects.size()>0){
                TaxHelper.createHeaderTaxes(
                    isInsert, 
                    modifiedObjects);
            }

            modifiedObjects = DocumentHelper.getApprovedObjects(
                'dmpl__PopulateAssetMaintenance__c',
                oldEntries, 
                newEntries);
            if(modifiedObjects.size()>0){
                ServiceRequestLineHelper.populateLinesForAssetMaintenance(
                    newEntries,
                    true);
            }
        }
    }

    public static void generateQuote(List<dmpl__ServiceRequest__c> lineEntries){
        ServiceEstimateHelper.createQuoteFromServiceRequest(lineEntries);
        SecurityHelper.ensureCanWriteField('dmpl__PerformGenerateQuote__c', 'dmpl__ServiceRequest__c');
        SecurityHelper.ensureCanWriteField('dmpl__IsQuoteGenerated__c', 'dmpl__ServiceRequest__c');
        for(dmpl__ServiceRequest__c lineEntry : lineEntries){
            lineEntry.dmpl__PerformGenerateQuote__c = false;
            lineEntry.dmpl__IsQuoteGenerated__c = true;
        }
    }

    public static void updateRepairOrderId(List<RepairOrder__c> repairOrders)
    {
        Map<ID, dmpl__ServiceRequest__c> serviceRequests = new Map<ID, dmpl__ServiceRequest__c>(queryServiceRequests(DocumentHelper.extractIds(repairOrders, FIELD_SERVICEREQUEST_SERVICEREQUESTID)));
        List<dmpl__ServiceRequest__c> serviceRequestToUpdate = new List<dmpl__ServiceRequest__c>();
        for(dmpl__RepairOrder__c lineEntry : repairOrders)
        {
            dmpl__ServiceRequest__c currentServiceRequest = serviceRequests.get(lineEntry.dmpl__ServiceRequestId__c);
            if(currentServiceRequest.dmpl__RepairOrderId__c == null && lineEntry.dmpl__ServiceEstimateId__c != null)
            {
                currentServiceRequest.dmpl__RepairOrderId__c = lineEntry.Id;
                serviceRequestToUpdate.add(currentServiceRequest);
            }
        }

        if(serviceRequestToUpdate.size() > 0)
        {
            try{
                skipValidations = true;
                SecurityHelper.ensureCanWriteObject(OBJECT_SERVICEREQUEST);
                SecurityHelper.ensureCanWriteFields(
                    new List<string>{
                    'dmpl__RepairOrderId__c'
                   }, OBJECT_SERVICEREQUEST);
                update serviceRequestToUpdate; 
            } catch(Exception error){
                ExceptionLogHelper.logException(error);
                throw error;
            } finally {
                skipValidations = false;
            }
        }
    }

    @testVisible
    private static void updateDiscountInServiceRequestLines(List<dmpl__ServiceRequest__c> modifiedObject)
    {
        Map<Id,dmpl__ServiceRequest__c> serviceRequests = new Map<Id,dmpl__ServiceRequest__c>(modifiedObject);
        List<dmpl__ServiceRequestLine__c> serviceRequestLines = [SELECT Id, Name, dmpl__ServiceRequestId__c,  dmpl__Discount__c FROM dmpl__ServiceRequestLine__c WHERE dmpl__ServiceRequestId__c IN : DocumentHelper.extractIds(modifiedObject)];
        if(serviceRequestLines.size() > 0){
            for(dmpl__ServiceRequestLine__c line : serviceRequestLines){
                dmpl__ServiceRequest__c order = serviceRequests.get(line.dmpl__ServiceRequestId__c);
                line.dmpl__Discount__c = order.dmpl__Discount__c;
            }
            SecurityHelper.ensureCanWriteFields(new string[]{'dmpl__Discount__c'}, 'dmpl__ServiceRequestLine__c');
            update serviceRequestLines;
        }
    }

    private static void createRepairOrder(List<dmpl__ServiceRequest__c> modifiedObjects)
    {
        List<dmpl__RepairOrder__c> newRepairOrders = RepairOrderHelper.createRepairOrderFromServicerequest(modifiedObjects);

        SecurityHelper.ensureCanWriteField('dmpl__PerformGenerateRepairOrder__c', 'dmpl__ServiceRequest__c');
        SecurityHelper.ensureCanWriteField('dmpl__IsRepairOrderGenerated__c', 'dmpl__ServiceRequest__c');
        SecurityHelper.ensureCanWriteField('dmpl__RepairOrderId__c', 'dmpl__ServiceRequest__c');

        for(dmpl__ServiceRequest__c lineEntry : modifiedObjects)
        {
            lineEntry.dmpl__PerformGenerateRepairOrder__c = false;
            lineEntry.dmpl__IsRepairOrderGenerated__c = true;
        }

        for(dmpl__RepairOrder__c repairOrder : newRepairOrders)
        {
            dmpl__ServiceRequest__c serviceRequest = new Map<Id,dmpl__ServiceRequest__c>(modifiedObjects).get(repairOrder.dmpl__ServiceRequestId__c);
            if(serviceRequest != null)
                serviceRequest.dmpl__RepairOrderId__c = repairOrder.Id;
        }
    }

    private static void createSaleOrder(
        List<dmpl__ServiceRequest__c> modifiedObjects)
    {
        List<dmpl__SaleOrder__c> newSaleOrders = SaleOrderHelper.createSaleOrderFromServicerequest(
            modifiedObjects);

        SecurityHelper.ensureCanWriteField(
            'dmpl__PerformGenerateSaleOrder__c', 
            'dmpl__ServiceRequest__c');
        SecurityHelper.ensureCanWriteField(
            'dmpl__IsSaleOrderGenerated__c', 
            'dmpl__ServiceRequest__c');
        SecurityHelper.ensureCanWriteField(
            'dmpl__SaleOrderId__c', 
            'dmpl__ServiceRequest__c');

        for(dmpl__ServiceRequest__c lineEntry : modifiedObjects){
            lineEntry.dmpl__PerformGenerateSaleOrder__c = false;
            lineEntry.dmpl__IsSaleOrderGenerated__c = true;
        }

        for(dmpl__SaleOrder__c saleOrder : newSaleOrders){
            dmpl__ServiceRequest__c serviceRequest = new Map<Id,dmpl__ServiceRequest__c>(
                modifiedObjects).get(
                    saleOrder.dmpl__ServiceRequestId__c);
            if(serviceRequest != null)
                serviceRequest.dmpl__SaleOrderId__c = saleOrder.Id;
        }
    }
    
    // private static void validateOnOpenServiceRequest(List<dmpl__ServiceRequest__c> newEntries)
    // {
    //     List<dmpl__ServiceRequest__c> existingServiceRequests = queryExistingServiceRequests(DocumentHelper.extractIds(newEntries, FIELD_SERVICEREQUEST_ASSETID));
    //     for(dmpl__ServiceRequest__c serviceRequest : newEntries)
    //     {
    //         if(DocumentHelper.getObjectsByFilter(existingServiceRequests, FIELD_SERVICEREQUEST_ASSETID, serviceRequest.dmpl__AssetId__c).size() > 0)
    //             serviceRequest.addError(System.Label.Validation_OpenServiceRequestFound);
    //     }
    // }

    private static void assignResource(
        List<ServiceRequest__c> newEntries){
        List<dmpl__PartnerResource__c> resources = ServiceLeadHelper.queryPartnerResource(
            CollectionHelper.extractIds(
                newEntries, 
                'dmpl__PartnerAccountId__c'),
            CollectionHelper.extractIds(
                newEntries, 
                'dmpl__BranchId__c'));
        for(ServiceRequest__c serviceRequest : newEntries){
            List<dmpl__PartnerResource__c> applicableResources = ServiceLeadHelper.getApplicablePartnerResources(
                resources,
                serviceRequest.dmpl__PartnerAccountId__c,
                serviceRequest.dmpl__BranchId__c);
                for(dmpl__PartnerResource__c resource : applicableResources){
                    if(resource.dmpl__RuleSuccessCriteria__c == null 
                        || resource.dmpl__RuleSuccessCriteria__c == 'All Rules Are Met'){
                        if(isAllRuleMet(
                            serviceRequest, 
                            resource)){
                                serviceRequest.dmpl__ServiceAdvisorId__c = resource.dmpl__ResourceId__c;
                                break;
                        }
                    }else if(resource.dmpl__RuleSuccessCriteria__c == 'Any Rule Is Met'){
                        if(isAnyRuleMet(
                            serviceRequest, 
                            resource)){
                                serviceRequest.dmpl__ServiceAdvisorId__c = resource.dmpl__ResourceId__c;
                                break;
                        }
                    }else if(resource.dmpl__RuleSuccessCriteria__c == 'Always (No Criteria)'){
                        serviceRequest.dmpl__ServiceAdvisorId__c = resource.dmpl__ResourceId__c;
                        break;
                    }
                }
        }

    }

    private static Boolean isAllRuleMet(ServiceRequest__c serviceRequest, dmpl__PartnerResource__c resource){
        if(resource.dmpl__ResourceAssignmentRules__r.size() == 0){
            return false;
        }
        Map<String, Schema.SObjectField> fieldMap = serviceRequest.getSObjectType().getDescribe().fields.getMap();
        for (dmpl__ResourceAssignmentRule__c rule :resource.dmpl__ResourceAssignmentRules__r){
            if(!evaluateRule(
                fieldMap.get(rule.dmpl__FieldName__c),
                serviceRequest,
                rule)){
                return false;
            }
        }
        return true;
    }

    private static Boolean isAnyRuleMet(ServiceRequest__c serviceRequest, dmpl__PartnerResource__c resource){
        if(resource.dmpl__ResourceAssignmentRules__r.size() == 0){
            return false;
        }
        Map<String, Schema.SObjectField> fieldMap = serviceRequest.getSObjectType().getDescribe().fields.getMap();
        for (dmpl__ResourceAssignmentRule__c rule :resource.dmpl__ResourceAssignmentRules__r){
            if(evaluateRule(
                fieldMap.get(rule.dmpl__FieldName__c),
                serviceRequest,
                rule)){
                return true;
            }
        }
        return false;
    }

    private static Boolean evaluateRule(
        Schema.SObjectField field,
        ServiceRequest__c serviceRequest, 
        dmpl__ResourceAssignmentRule__c rule){
        if(field == null){
            return false;
        }
        Schema.DisplayType dataType = field.getDescribe().getType();
        if(dataType == Schema.DisplayType.Double 
            || dataType == Schema.DisplayType.INTEGER 
            || dataType == Schema.DisplayType.LONG){
                return ServiceLeadHelper.evaluateNumnericValues(
                    dataType, 
                    rule.dmpl__Operation__c, 
                    serviceRequest.get(rule.dmpl__FieldName__c), 
                    rule.dmpl__FieldValue__c);
        }else if(dataType == Schema.DisplayType.DATE 
            || dataType == Schema.DisplayType.DATETIME){
                return ServiceLeadHelper.evaluateDateTimeValues(
                    dataType, 
                    rule.dmpl__Operation__c, 
                    serviceRequest.get(rule.dmpl__FieldName__c), 
                    rule.dmpl__FieldValue__c);
        }else{
            if(rule.dmpl__Operation__c == 'equals'){
                return serviceRequest.get(rule.dmpl__FieldName__c) == rule.dmpl__FieldValue__c;
            } else if(rule.dmpl__Operation__c == 'notEqual'){
                return serviceRequest.get(rule.dmpl__FieldName__c) != rule.dmpl__FieldValue__c;
            }    
        }
        return false;
    }
    
    private static void populateServiceRequestLinesFromContract(List<dmpl__ServiceRequest__c> modifiedObjects)
    {
        if(modifiedObjects.size() > 0)
            ServiceRequestLineHelper.createServiceRequestLinesFromServiceContract(modifiedObjects);
    }

    private static void updatePerformanceKPI(List<dmpl__ServiceRequest__c> newEntries)
    {
        PerformanceKPIHelper.upsertPerformanceKPI(OBJECT_SERVICEREQUEST, 'INCENTIVE', newEntries);
        for(dmpl__ServiceRequest__c lineEntry : newEntries)
        {
            lineEntry.dmpl__PerformKPICalculation__c = false;
            lineEntry.dmpl__IsKPICalculated__c = true;
        }
    }

    private static void confirmServiceRequests(List<dmpl__ServiceRequest__c> modifiedObjects)
    {
        ServiceRequestLineHelper.confirmServiceRequestLines(modifiedObjects);
        SecurityHelper.ensureCanWriteField('dmpl__PerformConfirm__c', 'dmpl__ServiceRequest__c');
        SecurityHelper.ensureCanWriteField('dmpl__IsConfirmed__c', 'dmpl__ServiceRequest__c');
        SecurityHelper.ensureCanWriteField('dmpl__IsCancelled__c', 'dmpl__ServiceRequest__c');
        for(dmpl__ServiceRequest__c lineEntry : modifiedObjects)
        {
            lineEntry.dmpl__PerformConfirm__c = false;
            lineEntry.dmpl__IsConfirmed__c = true;
            lineEntry.dmpl__IsCancelled__c = false;
        }
    }

    private static void setDefaultAddress(List<dmpl__ServiceRequest__c> newEntries){
        SecurityHelper.ensureCanWriteFields(new List<String>
        {
            FIELD_SERVICEREQUEST_SHIPPINGADDRESS,
            FIELD_SERVICEREQUEST_BILLINGADDRESS,
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
        }, OBJECT_SERVICEREQUEST);

        List<Account> accounts = AccountHelper.getCachedAccounts(CollectionHelper.extractIds(newEntries, FIELD_SERVICEREQUEST_ACCOUNTID));
        for(dmpl__ServiceRequest__c order : newEntries){
            Account account = (Account)CollectionHelper.getObject(accounts, order.dmpl__AccountId__c);
            if(account!=null){
                AccountHelper.setDefaultAddress(order, account);
            }
        }
    }

    private static void setDefaultAddress(List<dmpl__ServiceRequest__c> newEntries, List<dmpl__ServiceRequest__c> oldEntries){
        SecurityHelper.ensureCanWriteFields(new List<String>
        {
            FIELD_SERVICEREQUEST_SHIPPINGADDRESS,
            FIELD_SERVICEREQUEST_BILLINGADDRESS
        }, OBJECT_SERVICEREQUEST);
        Account account = null;
        List<Account> accounts = AccountHelper.getCachedAccounts(CollectionHelper.extractIds(newEntries, FIELD_SERVICEREQUEST_ACCOUNTID));
        List<dmpl__ServiceRequest__c> modifiedOrders = DocumentHelper.getModifiedNewObjects(FIELD_SERVICEREQUEST_BILLINGADDRESSID, oldEntries, newEntries);
        for(dmpl__ServiceRequest__c order : modifiedOrders){
            account = (Account)CollectionHelper.getObject(accounts, order.dmpl__AccountId__c);
            if(account!=null){
                AccountHelper.setDefaultAddress(order, account);
            }
        }
        
        modifiedOrders = DocumentHelper.getModifiedNewObjects(FIELD_SERVICEREQUEST_SHIPPINGADDRESSID, oldEntries, newEntries);
        for(dmpl__ServiceRequest__c order : modifiedOrders){
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

    private static void cancelServiceRequests(List<dmpl__ServiceRequest__c> modifiedObjects)
    {
        ServiceRequestLineHelper.cancelServiceRequestLines(modifiedObjects);
        SecurityHelper.ensureCanWriteField('dmpl__PerformCancel__c', 'dmpl__ServiceRequest__c');
        SecurityHelper.ensureCanWriteField('dmpl__IsConfirmed__c', 'dmpl__ServiceRequest__c');
        SecurityHelper.ensureCanWriteField('dmpl__IsCancelled__c', 'dmpl__ServiceRequest__c');
        for(dmpl__ServiceRequest__c lineEntry : modifiedObjects)
        {
            lineEntry.dmpl__PerformCancel__c = false;
            lineEntry.dmpl__IsCancelled__c = true;
            lineEntry.dmpl__IsConfirmed__c = false;
        }
    }

    // private static List<dmpl__ServiceRequest__c> queryExistingServiceRequests(List<Id> assetIds)
    // {
    //     SecurityHelper.ensureCanReadFields(new List<string>{'dmpl__AssetId__c'}, 'dmpl__ServiceRequest__c');
    //     return [SELECT Id,
    //     Name,
    //     dmpl__AssetId__c
    //     FROM dmpl__ServiceRequest__c
    //     WHERE dmpl__AssetId__c IN : assetIds
    //     AND dmpl__Status__c = 'Customer Requested'];
    // }

    private static List<dmpl__ServiceRequest__c> queryServiceRequests(List<ID> serviceRequestIds)
    {
        SecurityHelper.ensureCanReadFields(new List<String>{
            'dmpl__RepairOrderId__c'
            }, 'dmpl__ServiceRequest__c');
        return [SELECT ID,
        Name,
        dmpl__RepairOrderId__c
        FROM dmpl__ServiceRequest__c
        WHERE ID IN : serviceRequestIds];
    }
}