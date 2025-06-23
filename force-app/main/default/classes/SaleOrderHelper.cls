public with sharing class SaleOrderHelper {
    
    private static Boolean skipValidations = false;

    private static final string OBJECT_SALEORDER = 'dmpl__SaleOrder__c';
    private static final string OBJECT_PAYMENT = 'dmpl__Payment__c';
    
    private static final string FIELD_SALEORDER_STATUS = 'dmpl__Status__c';
    
    private static final string FIELD_SALEORDER_PARTNERACCOUNTID = 'dmpl__PartnerAccountId__c';
    private static final string FIELD_SALEORDER_BRANCHID = 'dmpl__BranchId__c';
    private static final string FIELD_SALEORDER_ACCOUNTID ='dmpl__AccountId__c';
    private static final string FIELD_SALEORDER_DOCUMENTDATE ='dmpl__DocumentDate__c';
    private static final string FIELD_SALEORDER_PRICELISTID ='dmpl__PriceListId__c';
    private static final string FIELD_SALEORDER_AMOUNTPAID ='dmpl__AmountPaid__c';
    private static final string FIELD_SALEORDERLINE_SALEORDERID = 'dmpl__SaleOrderId__c';
    private static final string FIELD_SALEORDER_PERFORMLRELEASEFULFILMENT ='dmpl__PerformReleaseFulfilment__c';
    private static final string FIELD_SALEORDER_PERFORMRELEASEINVOICE ='dmpl__PerformReleaseInvoice__c';
    private static final string FIELD_SALEORDER_PERFORMRELEASEINVOICEALLOCATEDLINES ='dmpl__PerformReleaseInvoiceAllocatedLines__c';
    private static final string FIELD_SALEORDER_ISFULFILMENTRELEASED ='dmpl__IsFulfilmentReleased__c';
    private static final string FIELD_SALEORDER_ISINVOICERELEASED ='dmpl__IsInvoiceReleased__c';
    private static final string FIELD_SALEORDER_PERFORMRELEADELIVERY ='dmpl__PerformReleaseDelivery__c';
    private static final string FIELD_SALEORDER_ISDELIVERYRELEASED ='dmpl__IsDeliveryReleased__c';
    private static final string FIELD_SALEORDER_BILLINGADDRESS ='dmpl__BillingAddress__c';
    private static final string FIELD_SALEORDER_SHIPPINGADDRESS ='dmpl__ShippingAddress__c';
    private static final string FIELD_SALEORDER_BILLINGADDRESSID ='dmpl__BillingAddressId__c';
    private static final string FIELD_SALEORDER_SHIPPINGADDRESSID ='dmpl__ShippingAddressId__c';
    private static final string RELATION_SALEORDER_SALEORDERLINES = 'dmpl__SaleOrderLines__r';
    private static final string FIELD_SALEORDER_PERFORMCREATEDEALERSALEORDER ='dmpl__PerformCreateDealerSaleOrder__c';
    private static final string FIELD_SALEORDER_ORDERDATE = 'dmpl__DocumentDate__c';
    private static final string FIELD_SALEORDER_SALESEXECUTIVEID = 'dmpl__SalesExecutiveId__c';
    private static final string FIELD_SALEORDER_PERFORMKPICALCULATION = 'dmpl__PerformKPICalculation__c';
    
    private static final string FIELD_SALEORDER_TAXGROUPID = 'dmpl__TaxGroupId__c';
    private static final string FIELD_SALEORDER_TAXID = 'dmpl__TaxId__c';
    private static final string FIELD_SALEORDER_AMOUNT = 'dmpl__LineSubTotal__c';
    private static final string FIELD_SALEORDER_GROSSAMOUNT = 'dmpl__TotalLineGrossAmount__c';
    private static final string FIELD_SALEORDER_TCSELIGIBLEMOUNT = 'dmpl__TCSEligibleAmount__c';
    

    private static final List<String> LIST_NON_EDITABLE_FIELDS = new List<String>
    {
        FIELD_SALEORDER_ACCOUNTID,
        FIELD_SALEORDER_BRANCHID,
        FIELD_SALEORDER_DOCUMENTDATE,
        FIELD_SALEORDER_ORDERDATE
    };
    private static final List<String> LIST_FIELDS_SYSTEM = new List<String>
    {
        FIELD_SALEORDER_ISINVOICERELEASED,
        FIELD_SALEORDER_ISDELIVERYRELEASED,
        FIELD_SALEORDER_ISFULFILMENTRELEASED,
        FIELD_SALEORDER_BILLINGADDRESS,
        FIELD_SALEORDER_SHIPPINGADDRESS
    };
   
    public static void validateData(
        Boolean isInsert, 
        Boolean isDelete, 
        Boolean isUpdate, 
        List<dmpl__SaleOrder__c> oldEntries, 
        List<dmpl__SaleOrder__c> newEntries){
        try {
            if(isInsert){
                FieldMappingHelper.copyFieldMappingData(
                    newEntries);
            }
            if(skipValidations){
                return;
            }
            DocumentStatusDFSHelper dfsHelper = new DocumentStatusDFSHelper();
            if(isInsert){
                StatusHelper.validateStatusNew(OBJECT_SALEORDER, FIELD_SALEORDER_STATUS, newEntries);
                DocumentHelper.validateChangeInSystemFields(LIST_FIELDS_SYSTEM, newEntries);
                ValidationHelper.validatePartnerAndBranch(FIELD_SALEORDER_PARTNERACCOUNTID, FIELD_SALEORDER_BRANCHID, newEntries);
                ValidationHelper.validateResource(FIELD_SALEORDER_SALESEXECUTIVEID, newEntries);
            }else if(isUpdate){
                StatusHelper.validateStatusEdit(OBJECT_SALEORDER, FIELD_SALEORDER_STATUS, oldEntries, newEntries);
                DocumentHelper.validateChangeInKeyFields(LIST_NON_EDITABLE_FIELDS, oldEntries, newEntries);
                DocumentHelper.validateChangeInSystemFields(LIST_FIELDS_SYSTEM, oldEntries, newEntries);
                dfsHelper.DocumentStatusRestrictEdits_Edit(OBJECT_SALEORDER, FIELD_SALEORDER_STATUS, oldEntries, newEntries);
                dfsHelper.DocumentStatusRestrictFieldsEdits(OBJECT_SALEORDER, FIELD_SALEORDER_STATUS, oldEntries, newEntries);
                ValidationHelper.validatePartnerAndBranch(FIELD_SALEORDER_PARTNERACCOUNTID, FIELD_SALEORDER_BRANCHID, newEntries);
                ValidationHelper.validateResource(FIELD_SALEORDER_SALESEXECUTIVEID, newEntries);
            }else if(isDelete){
                dfsHelper.DocumentStatusRestrictEdits_Delete(OBJECT_SALEORDER, FIELD_SALEORDER_STATUS, oldEntries);
            }
        } catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }

    public static void postData(Boolean isInsert, Boolean isDelete, Boolean isUpdate, List<dmpl__SaleOrder__c> oldEntries, List<dmpl__SaleOrder__c> newEntries)
    { 
        try {
            DocumentStatusDFSHelper dfsHelper = new DocumentStatusDFSHelper();
            if(isInsert){
                dfsHelper.DocumentStatusSetFlag(OBJECT_SALEORDER, FIELD_SALEORDER_STATUS, newEntries);
                dfsHelper.DocumentStatusReSetFlag(OBJECT_SALEORDER, FIELD_SALEORDER_STATUS, newEntries);
                PriceListHelper.setDefaultPriceListIds(newEntries);
                DiscountGroupHelper.setDefaultDiscountGroupIds(newEntries);
                setDefaultAddress(newEntries);
                DocumentNameHelper.generateDocumentName(newEntries);
                TaxHelper.setHeaderTaxes(newEntries);
            }else if(isUpdate){
                dfsHelper.DocumentStatusSetFlag(OBJECT_SALEORDER, FIELD_SALEORDER_STATUS, oldEntries, newEntries);
                dfsHelper.DocumentStatusReSetFlag(OBJECT_SALEORDER, FIELD_SALEORDER_STATUS, oldEntries, newEntries);
                List<dmpl__SaleOrder__c> modifiedObjects = DocumentHelper.getApprovedObjects(FIELD_SALEORDER_PERFORMLRELEASEFULFILMENT, oldEntries, newEntries);
                if(modifiedObjects.size()>0){
                    createFulfilment(modifiedObjects);
                }

                modifiedObjects = DocumentHelper.getApprovedObjects(FIELD_SALEORDER_PERFORMCREATEDEALERSALEORDER, oldEntries, newEntries);
                if(modifiedObjects.size()>0){
                    createSaleOrderLinesFromPurchaseOrder(modifiedObjects);
                }
    
                modifiedObjects = DocumentHelper.getApprovedObjects(FIELD_SALEORDER_PERFORMRELEASEINVOICE, oldEntries, newEntries);
                if(modifiedObjects.size()>0){
                    createSaleInvoice(modifiedObjects);
                }

                modifiedObjects = DocumentHelper.getApprovedObjects(FIELD_SALEORDER_PERFORMRELEASEINVOICEALLOCATEDLINES, oldEntries, newEntries);
                if(modifiedObjects.size()>0){
                    createSaleInvoiceForAllocatedLines(modifiedObjects);
                }
    
                modifiedObjects = DocumentHelper.getApprovedObjects(FIELD_SALEORDER_PERFORMRELEADELIVERY, oldEntries, newEntries);
                if(modifiedObjects.size()>0){
                    createDeliveryOrder(modifiedObjects);
                }

                modifiedObjects = DocumentHelper.getApprovedObjects(FIELD_SALEORDER_PERFORMKPICALCULATION, oldEntries, newEntries);
                if(modifiedObjects.size()>0){
                    updatePerformanceKPI(modifiedObjects);
                }

                List<dmpl__SaleOrder__c>  modifiedDocs = DocumentHelper.getApprovedObjects(
                    'dmpl__PerformInventoryPosting__c', 
                    oldEntries,
                    newEntries);
                if(modifiedDocs.size()>0){
                    postSaleOrderDocuments(modifiedDocs);
                }

                modifiedObjects = DocumentHelper.getModifiedNewObjects(new string[]{
                    FIELD_SALEORDER_TAXGROUPID,
                    FIELD_SALEORDER_TAXID,
                    FIELD_SALEORDER_TCSELIGIBLEMOUNT
                        }, oldEntries, newEntries);
                        if(modifiedObjects.size()>0){
                            TaxHelper.setHeaderTaxes(modifiedObjects);
                        }
                
                setDefaultAddress(newEntries, oldEntries);
                RoundOffHelper.setRoundOff(
                    newEntries,
                    'dmpl__LineSubTotal__c',
                    'dmpl__TotalTaxAmount2__c');
            } 
        } catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }

    public static void afterPostData(Boolean isInsert, Boolean isDelete, Boolean isUpdate, List<dmpl__SaleOrder__c> oldEntries, List<dmpl__SaleOrder__c> newEntries)
    {
        if(isInsert){
            if(newEntries.size() > 0){
                SaleOrderLineHelper.createSaleOrderLinesFromSaleOrder(newEntries);
            }
            TaxHelper.createHeaderTaxes(
                isInsert, 
                newEntries);
        } else if(isUpdate){
            List<dmpl__SaleOrder__c> modifiedObjects = DocumentHelper.getModifiedNewObjects('dmpl__Discount__c', oldEntries, newEntries);
            if(modifiedObjects.size()>0){
                updateDiscountInSaleOrderLines(modifiedObjects);
            }
            modifiedObjects = DocumentHelper.getModifiedNewObjects(
                'dmpl__PriceAsOnDate__c', 
                oldEntries, 
                newEntries);
            if(modifiedObjects.size()>0){
                SaleOrderLineHelper.performReprice(
                    CollectionHelper.extractIds(modifiedObjects));
            }
            modifiedObjects = DocumentHelper.getModifiedNewObjects(new string[]{
                FIELD_SALEORDER_TAXGROUPID,
                FIELD_SALEORDER_TAXID,
                FIELD_SALEORDER_TCSELIGIBLEMOUNT
            }, oldEntries, newEntries);
            if(modifiedObjects.size()>0){
                TaxHelper.createHeaderTaxes(
                    isInsert, 
                    modifiedObjects);
            }

            modifiedObjects = DocumentHelper.getModifiedNewObjects(
                'dmpl__SkipScheme__c', 
                oldEntries, 
                newEntries);
            if(modifiedObjects.size()>0){
                SchemeEngine.processSchemes(modifiedObjects);
            }
        } else if(isDelete){
            TaxHelper.deleteHeaderTaxes(oldEntries);
        }
    }

    public static void createSaleOrderLinesFromPurchaseOrder(List<dmpl__SaleOrder__c> saleOrders){
        createSaleOrderFromPurchaseOrder(queryPurchaseOrderLines(DocumentHelper.extractIds(saleOrders, FIELD_SALEORDER_ACCOUNTID)), saleOrders);

        for(dmpl__SaleOrder__c lineEntry : saleOrders){
            lineEntry.dmpl__PerformCreateDealerSaleOrder__c = false;
            lineEntry.dmpl__IsDealerSaleOrderCreated__c = true;
        }
    }
    
    public static void createSaleOrderFromPurchaseOrder(List<dmpl__PurchaseOrderLine__c> purchaseOrderLines, dmpl__SaleOrder__c saleOrder){
        createSaleOrderLineFromPurchaseOrder(purchaseOrderLines, saleOrder);
    }

    public static List<dmpl__SaleOrder__c> createSaleOrderFromServiceRequest(
        List<dmpl__ServiceRequest__c> serviceRequests)
    {
        List<dmpl__SaleOrder__c> newSaleOrders = new List<dmpl__SaleOrder__c>();
        for(dmpl__ServiceRequest__c serviceRequest : serviceRequests){
            if(serviceRequest.dmpl__SaleOrderId__c != null)
                continue;
            newSaleOrders.add(
                new dmpl__SaleOrder__c(
                    dmpl__AccountId__c = serviceRequest.dmpl__AccountId__c,
                    dmpl__AccountName__c = serviceRequest.dmpl__AccountName__c,
                    dmpl__BranchId__c = serviceRequest.dmpl__BranchId__c,
                    dmpl__PartnerAccountId__c = serviceRequest.dmpl__PartnerAccountId__c,
                    dmpl__SalesExecutiveId__c = serviceRequest.dmpl__ServiceAdvisorId__c,
                    dmpl__ServiceRequestId__c = serviceRequest.Id,
                    dmpl__DocumentDate__c = date.today()
                )
            );
        }
        if(newSaleOrders.size() > 0){
            try{
                skipValidations = true;
                SecurityHelper.ensureCanCreateObject(OBJECT_SALEORDER);
                SecurityHelper.ensureCanWriteFields(
                    new List<string>{
                    'dmpl__AccountId__c',
                    'dmpl__AccountName__c',
                    'dmpl__BranchId__c',
                    'dmpl__PartnerAccountId__c',
                    'dmpl__SalesExecutiveId__c',
                    'dmpl__ServiceRequestId__c',
                    'dmpl__Remark__c',
                    'dmpl__DocumentDate__c'
                }, OBJECT_SALEORDER);
                insert newSaleOrders;
                return newSaleOrders;
            } catch(Exception error) {
                ExceptionLogHelper.logException(error);
                throw error;
            } finally {
                skipValidations = false;
            }
        }
        else {
            return newSaleOrders;
        }
    }

    public static  List<dmpl__SaleOrder__c> createSaleOrderFromServiceEstimate(List<dmpl__Quote__c> quotes)
    {
        List<dmpl__SaleOrder__c> newSaleOrders = new List<dmpl__SaleOrder__c>();
        for(dmpl__Quote__c quote : quotes)
        {
            if(quote.dmpl__SaleOrderId__c != null)
                continue;
                newSaleOrders.add(
                new dmpl__SaleOrder__c(
                    dmpl__AccountId__c = quote.dmpl__AccountId__c,
                    dmpl__BranchId__c = quote.dmpl__BranchId__c,
                    dmpl__PartnerAccountId__c = quote.dmpl__PartnerAccountId__c,
                    dmpl__ServiceRequestId__c = quote.dmpl__ServiceRequestId__c,
                    dmpl__QuoteId__c = quote.Id,
                    dmpl__DocumentDate__c = date.today()
                )
            );
        }
        if(newSaleOrders.size() > 0)
        {
            try{
                skipValidations = true;
                SecurityHelper.ensureCanCreateObject(OBJECT_SALEORDER);
                SecurityHelper.ensureCanWriteFields(
                    new List<string>{
                    'dmpl__AccountId__c',
                    'dmpl__BranchId__c',
                    'dmpl__PartnerAccountId__c',
                    'dmpl__ServiceRequestId__c',
                    'dmpl__QuoteId__c',
                    'dmpl__Remark__c',
                    'dmpl__DocumentDate__c'
                }, OBJECT_SALEORDER);
                insert newSaleOrders;
                return newSaleOrders;
            } catch(Exception error) {
                ExceptionLogHelper.logException(error);
                throw error;
            } finally {
                skipValidations = false;
            }
        }
        else {
            return newSaleOrders;
        }
    }

    private static void createSaleOrderFromPurchaseOrder(List<dmpl__PurchaseOrderLine__c> purchaseOrderLines, List<dmpl__SaleOrder__c> saleOrders)
    {
        if(purchaseOrderLines.size() == 0){
            return;
            // throw new DMPLException(String.format(String.valueOf(System.Label.Generic_EmptyActionParam), new String[]{dmpl__PurchaseOrderLine__c.class.getName()}));
        }

         List<dmpl__SaleOrderLine__c> saleOrderLines = new List<dmpl__SaleOrderLine__c>();

        for(dmpl__PurchaseOrderLine__c orderLine : purchaseOrderLines){
            if(orderLine.dmpl__ItemId__c !=null 
                && orderLine.dmpl__PendingQuantity__c>0){
                    for(dmpl__SaleOrder__c saleOrder : saleOrders)
                    {
                        if(saleOrder.dmpl__PartnerAccountId__c == orderLine.dmpl__PurchaseOrderId__r.dmpl__SupplierAccountId__c && saleOrder.dmpl__AccountId__c == orderLine.dmpl__PurchaseOrderId__r.dmpl__PartnerAccountId__c)
                        {
                            saleOrderLines.add(createSaleOderLinesFromPurchaseOrderLine(orderLine, saleOrder.Id));
                        }
                    }
            }
        }

        if(saleOrderLines.size() >0)
        {
            SecurityHelper.ensureCanCreateObject('dmpl__SaleOrderLine__c');
            SecurityHelper.ensureCanCreateFields(new string[]{'dmpl__ItemId__c','dmpl__SKUId__c','dmpl__Quantity__c','dmpl__TaxGroupId__c','dmpl__PurchaseOrderLineId__c','dmpl__SaleOrderId'}, 'dmpl__SaleOrderLine__c');
            insert saleOrderLines;
        }
    }

    private static void createSaleOrderLineFromPurchaseOrder(List<dmpl__PurchaseOrderLine__c> purchaseOrderLines, dmpl__SaleOrder__c saleOrder)
    {
        if(purchaseOrderLines.size() == 0){
            throw new DMPLException(String.format(String.valueOf(System.Label.Generic_EmptyActionParam), new String[]{dmpl__PurchaseOrderLine__c.class.getName()}));
        }

        List<dmpl__PurchaseOrderLine__c> pendingOrderLines = new List<dmpl__PurchaseOrderLine__c>();
        for(dmpl__PurchaseOrderLine__c purchaseOrderLine : purchaseOrderLines){
            if(purchaseOrderLine.dmpl__PendingQuantity__c>0){
                pendingOrderLines.Add(purchaseOrderLine);
            }
        }
        if(pendingOrderLines.size() == 0){
            throw new DMPLException(String.format(String.valueOf(System.Label.Generic_EmptyActionParam), new String[]{dmpl__PurchaseOrderLine__c.class.getName()}));
        }

        List<dmpl__SaleOrderLine__c> saleOrderLines = new List<dmpl__SaleOrderLine__c>();
        for(dmpl__PurchaseOrderLine__c orderLine : pendingOrderLines){
            if(orderLine.dmpl__ItemId__c !=null 
                && orderLine.dmpl__PendingQuantity__c>0){

                saleOrderLines.add(createSaleOderLinesFromPurchaseOrderLine(orderLine,saleOrder.Id));
            }
        }

        if(saleOrderLines.size() >0){
            Savepoint sp = Database.setSavepoint();
            try {
                SecurityHelper.ensureCanCreateObject('dmpl__SaleOrderLine__c');
                SecurityHelper.ensureCanCreateFields(new string[]{'dmpl__ItemId__c','dmpl__SKUId__c','dmpl__Quantity__c','dmpl__TaxGroupId__c'}, 'dmpl__SaleOrderLine__c');
                insert saleOrderLines;
            } catch (Exception e) {
                Database.rollback(sp);
                throw e;
            }
        }
    }

    private static dmpl__SaleOrderLine__c createSaleOderLinesFromPurchaseOrderLine(dmpl__PurchaseOrderLine__c orderLine, Id saleOrderId)
    {
        return new dmpl__SaleOrderLine__c(
            dmpl__ItemId__c = orderLine.dmpl__ItemId__c,
            dmpl__SKUId__c = orderLine.dmpl__SKUId__c,
            dmpl__Quantity__c = orderLine.dmpl__PendingQuantity__c,
            dmpl__TaxGroupId__c = orderLine.dmpl__TaxGroupId__c,
            dmpl__PurchaseOrderLineId__c= orderLine.Id,
            dmpl__SaleOrderId__c = saleOrderId
        );
    }

    public static void createFulfilment(
        List<SourceObjectInfo> orderLinesInfo){
        if(orderLinesInfo == null 
            || orderLinesInfo.size() ==0){
            return;
        }
        FulfillmentHelper.createFulfillmentFromSaleOrder(
            orderLinesInfo);
    }

    public static void createFulfilment(List<dmpl__SaleOrder__c> lineEntries){
        FulfillmentHelper.createFulfillmentFromSaleOrder(lineEntries);
        SecurityHelper.ensureCanWriteField('dmpl__PerformReleaseFulfilment__c', 'dmpl__SaleOrder__c');
        SecurityHelper.ensureCanWriteField('dmpl__IsFulfilmentReleased__c', 'dmpl__SaleOrder__c');
        for(dmpl__SaleOrder__c lineEntry : lineEntries){
            lineEntry.dmpl__PerformReleaseFulfilment__c = false;
            lineEntry.dmpl__IsFulfilmentReleased__c = true;    
        }
    }

    private static void updatePerformanceKPI(List<dmpl__SaleOrder__c> newEntries)
    {
        PerformanceKPIHelper.upsertPerformanceKPI(OBJECT_SALEORDER, 'SCHEME', newEntries);
        PerformanceKPIHelper.upsertPerformanceKPI(OBJECT_SALEORDER, 'INCENTIVE', newEntries);
        for(dmpl__SaleOrder__c lineEntry : newEntries)
        {
            lineEntry.dmpl__PerformKPICalculation__c = false;
            lineEntry.dmpl__IsKPICalculated__c = true;
        }
    }
    
    private static void postSaleOrderDocuments(List<dmpl__SaleOrder__c> modifiedDocs){
        SaleOrderLineHelper.postSaleOrderLines(modifiedDocs);
        SecurityHelper.ensureCanWriteField('dmpl__PerformInventoryPosting__c', OBJECT_SALEORDER);
        SecurityHelper.ensureCanWriteField('dmpl__IsILPosted__c', OBJECT_SALEORDER);
        for(dmpl__SaleOrder__c document : modifiedDocs){
            document.dmpl__PerformInventoryPosting__c = false;
            document.dmpl__IsILPosted__c = true;
        }
    }
    
    public static CreateRelatedResult postIL(Id saleOrderId){
        return SaleOrderLineHelper.postIL(saleOrderId);
     }
 
    public static CreateRelatedResult postIL(
        List<SourceObjectInfo> orderLinesInfo, 
        Id saleOrderId){
        return SaleOrderLineHelper.postIL(
            orderLinesInfo, 
            saleOrderId);
    }

    public static void createSaleInvoice(List<SourceObjectInfo> orderLinesInfo){
        if(orderLinesInfo == null || orderLinesInfo.size() ==0){
            return;
        }
        SaleInvoiceHelper.createSaleInvoiceFromSaleOrder(orderLinesInfo);
    }

    public static void createSaleInvoice(List<dmpl__SaleOrder__c> lineEntries){
        SaleInvoiceHelper.createSaleInvoiceForAllFromSaleOrder(lineEntries);
        SecurityHelper.ensureCanWriteField('dmpl__PerformReleaseInvoice__c', 'dmpl__SaleOrder__c');
        SecurityHelper.ensureCanWriteField('dmpl__IsInvoiceReleased__c', 'dmpl__SaleOrder__c');
        for(dmpl__SaleOrder__c lineEntry : lineEntries){
            lineEntry.dmpl__PerformReleaseInvoice__c = false;
            lineEntry.dmpl__IsInvoiceReleased__c = true;
        }
    }

    public static void createSaleInvoiceForAllocatedLines(List<SourceObjectInfo> orderLinesInfo){
        if(orderLinesInfo == null || orderLinesInfo.size() ==0){
            return;
        }
        SaleInvoiceHelper.createSaleInvoiceFromAllocatedLines(orderLinesInfo);
    }

    public static void createSaleInvoiceForAllocatedLines(List<dmpl__SaleOrder__c> lineEntries){
        SaleInvoiceHelper.createSaleInvoiceFromAllocatedLines(lineEntries);
        SecurityHelper.ensureCanWriteField('dmpl__PerformReleaseInvoiceAllocatedLines__c', 'dmpl__SaleOrder__c');
        SecurityHelper.ensureCanWriteField('dmpl__IsInvoiceReleased__c', 'dmpl__SaleOrder__c');
        for(dmpl__SaleOrder__c lineEntry : lineEntries){
            lineEntry.dmpl__PerformReleaseInvoiceAllocatedLines__c = false;
            lineEntry.dmpl__IsInvoiceReleased__c = true;
        }
    }

    public static void createDeliveryOrder(List<SourceObjectInfo> orderLinesInfo){
        if(orderLinesInfo == null || orderLinesInfo.size() ==0){
            return;
        }
        SaleDeliveryHelper.createSaleDeliveryFromSaleOrder(orderLinesInfo);
    }

    public static void createDeliveryOrder(List<dmpl__SaleOrder__c> lineEntries){
        SaleDeliveryHelper.createSaleDeliveryFromSaleOrder(lineEntries);
        SecurityHelper.ensureCanWriteField('dmpl__PerformReleaseDelivery__c', 'dmpl__SaleOrder__c');
        SecurityHelper.ensureCanWriteField('dmpl__IsDeliveryReleased__c', 'dmpl__SaleOrder__c');
        for(dmpl__SaleOrder__c lineEntry : lineEntries){
            lineEntry.dmpl__PerformReleaseDelivery__c = false;
            lineEntry.dmpl__IsDeliveryReleased__c = true;
        }
    }

    public static void updatePaidAmount(List<Id> saleOrderIds){
        try{
            skipValidations = true;
            SecurityHelper.ensureCanReadFields(new string[]{'dmpl__SaleOrderId__c','dmpl__Amount__c'}, OBJECT_PAYMENT);
            List<AggregateResult> paymentAggregates = 
                [SELECT dmpl__SaleOrderId__c SaleOrderId, SUM(dmpl__Amount__c) TotalPaymentAmount
                FROM dmpl__Payment__c
                WHERE dmpl__SaleOrderId__c IN :saleOrderIds
                WITH SECURITY_ENFORCED
                GROUP BY dmpl__SaleOrderId__c];

            SecurityHelper.ensureCanReadFields(new string[]{'dmpl__AmountPaid__c'}, OBJECT_SALEORDER);
            List<dmpl__SaleOrder__c> ordersToUpdate = 
            [
                SELECT Id, dmpl__AmountPaid__c
                FROM dmpl__SaleOrder__c
                WHERE Id IN :saleOrderIds
            ];

            for(dmpl__SaleOrder__c order : ordersToUpdate){
                order.dmpl__AmountPaid__c = 0;
                for(AggregateResult result : paymentAggregates){
                    if(result.get('SaleOrderId') == order.Id){
                        order.dmpl__AmountPaid__c = result.get('TotalPaymentAmount') ==null ? 0 : (Decimal)(result.get('TotalPaymentAmount'));
                        break;
                    }
                }
            }
            
            SecurityHelper.ensureCanWriteFields(new string[]{'dmpl__AmountPaid__c'}, OBJECT_SALEORDER);
            Update ordersToUpdate;
        }finally{
            skipValidations = false;
        }
    }

    public static void updateFinanceAmount(List<Id> saleOrderIds){        
        try{
            skipValidations = true;
            SecurityHelper.ensureCanReadFields(new string[]{'dmpl__SaleOrderId__c','dmpl__DisbursedAmount__c'}, 'dmpl__FinanceCase__c');
            List<AggregateResult> financeAggregates = 
                [SELECT dmpl__SaleOrderId__c SaleOrderId, SUM(dmpl__DisbursedAmount__c) TotalPaymentAmount
                FROM dmpl__FinanceCase__c
                WHERE dmpl__SaleOrderId__c IN (:String.join(saleOrderIds,','))
                GROUP BY dmpl__SaleOrderId__c];

            SecurityHelper.ensureCanReadFields(new string[]{'dmpl__FinanceAmount__c'}, OBJECT_SALEORDER);
            List<dmpl__SaleOrder__c> ordersToUpdate = 
                [SELECT Id, dmpl__FinanceAmount__c
                FROM dmpl__SaleOrder__c
                WHERE Id IN (:String.join(saleOrderIds,','))];

            for(dmpl__SaleOrder__c order : ordersToUpdate){
                order.dmpl__FinanceAmount__c = 0;
                for(AggregateResult result : financeAggregates){
                    if(result.get('SaleOrderId') == order.Id){
                        order.dmpl__FinanceAmount__c = result.get('TotalPaymentAmount')==null ? 0 : (Decimal)(result.get('TotalPaymentAmount'));
                        break;
                    }
                }
            }

            SecurityHelper.ensureCanWriteFields(new string[]{'dmpl__FinanceAmount__c'}, OBJECT_SALEORDER);
            Update ordersToUpdate;
        }finally{
            skipValidations = false;
        }
    }

    @testVisible
    private static void updateDiscountInSaleOrderLines(List<dmpl__SaleOrder__c> modifiedObjects)
    {
        Map<Id,dmpl__SaleOrder__c> saleOrders = new Map<Id,dmpl__SaleOrder__c>(modifiedObjects);
        List<dmpl__SaleOrderLine__c> saleOrderLines = [SELECT Id, Name, dmpl__SaleOrderId__c,  dmpl__Discount__c FROM dmpl__SaleOrderLine__c WHERE dmpl__SaleOrderId__c IN : DocumentHelper.extractIds(modifiedObjects)];
        if(saleOrderLines.size() > 0){
            for(dmpl__SaleOrderLine__c line : saleOrderLines){
                dmpl__SaleOrder__c order = saleOrders.get(line.dmpl__SaleOrderId__c);
                line.dmpl__Discount__c = order.dmpl__Discount__c;
            }
            SecurityHelper.ensureCanWriteFields(new string[]{'dmpl__Discount__c'}, 'dmpl__SaleOrderLine__c');
            update saleOrderLines;
        }
    }

    private static void setDefaultAddress(List<dmpl__SaleOrder__c> newEntries){
        SecurityHelper.ensureCanWriteFields(new List<String>
        {
            FIELD_SALEORDER_SHIPPINGADDRESS,
            FIELD_SALEORDER_BILLINGADDRESS,
            'dmpl__BillingCity__c',
            'dmpl__BillingCityPlaceId__c',
            'dmpl__BillingCountry__c',
            'dmpl__BillingPostalCode__c',
            'dmpl__BillingRegion__c',
            'dmpl__BillingState__c',
            'dmpl__BillingStreet__c',
            'dmpl__ShippingCity__c',
            'dmpl__ShippingCityPlaceId__c',
            'dmpl__ShippingCountry__c',
            'dmpl__ShippingPostalCode__c',
            'dmpl__ShippingRegion__c',
            'dmpl__ShippingState__c',
            'dmpl__ShippingStreet__c'
        }, OBJECT_SALEORDER);

        List<Account> accounts = AccountHelper.getCachedAccounts(CollectionHelper.extractIds(newEntries, FIELD_SALEORDER_ACCOUNTID));
        for(dmpl__SaleOrder__c order : newEntries){
            Account account = (Account)CollectionHelper.getObject(accounts, order.dmpl__AccountId__c);
            if(account!=null){
                AccountHelper.setDefaultAddress(order, account);
            }
        }
    }

    private static void setDefaultAddress(List<dmpl__SaleOrder__c> newEntries, List<dmpl__SaleOrder__c> oldEntries){
        SecurityHelper.ensureCanWriteFields(new List<String>
        {
            FIELD_SALEORDER_SHIPPINGADDRESS,
            FIELD_SALEORDER_BILLINGADDRESS
        }, OBJECT_SALEORDER);
        Account account = null;
        List<Account> accounts = AccountHelper.getCachedAccounts(CollectionHelper.extractIds(newEntries, FIELD_SALEORDER_ACCOUNTID));
        List<dmpl__SaleOrder__c> modifiedOrders = DocumentHelper.getModifiedNewObjects(FIELD_SALEORDER_BILLINGADDRESSID, oldEntries, newEntries);
        modifiedOrders.addAll((List<dmpl__SaleOrder__c>)DocumentHelper.getModifiedNewObjects(FIELD_SALEORDER_SHIPPINGADDRESSID, oldEntries, newEntries));
        for(dmpl__SaleOrder__c order : modifiedOrders){
            account = (Account)CollectionHelper.getObject(accounts, order.dmpl__AccountId__c);
            if(account!=null){
                AccountHelper.setDefaultAddress(order, account);
            }
        }
    }

    private static List<dmpl__PurchaseOrderLine__c> queryPurchaseOrderLines(List<Id> partnerAccountIds)
    {
        SecurityHelper.ensureCanReadFields(new string[]{'dmpl__PartnerAccountId__c','dmpl__BranchId__c','dmpl__SupplierAccountId__c','dmpl__DocumentDate__c'},'dmpl__PurchaseOrder__c');
        SecurityHelper.ensureCanReadFields(new string[]{'dmpl__ItemId__c','dmpl__PurchaseOrderId__c','dmpl__TaxGroupId__c','dmpl__SKUId__c','dmpl__PendingQuantity__c'}, 'dmpl__PurchaseOrderLine__c');
        return [SELECT Id,
            Name,
            dmpl__ItemId__c,
            dmpl__SKUId__c,
            dmpl__PendingQuantity__c,
            dmpl__TaxGroupId__c,
            dmpl__PurchaseOrderId__c,
            dmpl__PurchaseOrderId__r.dmpl__PartnerAccountId__c,
            dmpl__PurchaseOrderId__r.dmpl__BranchId__c,
            dmpl__PurchaseOrderId__r.dmpl__SupplierAccountId__c,
            dmpl__PurchaseOrderId__r.dmpl__DocumentDate__c
        FROM dmpl__PurchaseOrderLine__c
        WHERE dmpl__PurchaseOrderId__r.dmpl__PartnerAccountId__c IN : partnerAccountIds AND  dmpl__PendingQuantity__c > 0
        ];
    }

    @testVisible
    private static Map<Id, SObject>  queryDefaultBranches(List<PurchaseOrder__c> purchaseOrder)
    {
        List<Id> partnerAccountIds = CollectionHelper.extractIds(purchaseOrder, 'dmpl__SupplierAccountId__c');

        
        SecurityHelper.ensureCanReadFields(new string[]{'dmpl__PartnerAccountId__c'},'dmpl__Branch__c');
        List<dmpl__Branch__c> branches = [SELECT Id,
            Name,
            dmpl__PartnerAccountId__c
        FROM dmpl__Branch__c
        WHERE dmpl__PartnerAccountId__c IN :partnerAccountIds
        AND dmpl__AllowSales__c = true
        ];

        Map<Id, SObject> mappedBranches = CollectionHelper.idMapFromCollectionByKey(FIELD_SALEORDER_PARTNERACCOUNTID, branches);
        return mappedBranches;
    }

    @testVisible
    private static Map<Id, SObject>  queryDefaultSalesExecutive(List<PurchaseOrder__c> purchaseOrder)
    {
        List<Id> partnerAccountIds = CollectionHelper.extractIds(purchaseOrder, 'dmpl__SupplierAccountId__c');

        
        SecurityHelper.ensureCanReadFields(new string[]{'dmpl__DefaultPartnerAccountId__c'},'dmpl__Resource__c');
        List<dmpl__Resource__c> resources = [SELECT Id,
            Name,
            dmpl__DefaultPartnerAccountId__c
        FROM dmpl__Resource__c
        WHERE dmpl__DefaultPartnerAccountId__c IN :partnerAccountIds
        ];

        Map<Id, SObject> mappedResources = CollectionHelper.idMapFromCollectionByKey('dmpl__DefaultPartnerAccountId__c', resources);
        return mappedResources;
    }
}