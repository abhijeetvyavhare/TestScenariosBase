public with sharing class BillHelper {
    
    private static Boolean skipValidations = false;

    private static final string OBJECT_BILL = 'dmpl__Bill__c';
    private static final string FIELD_BILL_STATUS = 'dmpl__Status__c';
    private static final string FIELD_BILL_PARTNERACCOUNTID = 'dmpl__PartnerAccountId__c';
    private static final string FIELD_BILL_BRANCHID = 'dmpl__BranchId__c';
    private static final string FIELD_BILL_SUPPLIERACCOUNTID ='dmpl__SupplierAccountId__c';
    private static final string FIELD_BILL_DOCUMENTDATE ='dmpl__DocumentDate__c';
    private static final string FIELD_BILL_PURCHASEORDERID ='dmpl__PurchaseOrderId__c';
    private static final string FIELD_BILL_ID ='Id';
    
    private static final string FIELD_BILL_TAXGROUPID = 'dmpl__TaxGroupId__c';
    private static final string FIELD_BILL_TAXID = 'dmpl__TaxId__c';
    private static final string FIELD_BILL_AMOUNT = 'dmpl__TotalLineAmount__c';
    private static final string FIELD_BILL_GROSSAMOUNT = 'dmpl__TotalLineGrossAmount__c';
    private static final string FIELD_BILL_TCSELIGIBLEAMOUNT = 'dmpl__TCSEligibleAmount__c';

    private static final string FIELD_BILL_AMOUNTPAID ='dmpl__AmountPaid__c';
    private static final string FIELD_BILL_SUPPLIERINVOICEAMOUNT ='dmpl__SupplierInvoiceAmount__c';
    private static final string FIELD_BILL_GLID ='dmpl__GeneralLedgerId__c';
    private static final string FIELD_BILL_GLACCOUNTID ='dmpl__GLAccountId__c';
    private static final string FIELD_BILL_ISGLPOSTED ='dmpl__IsGLPosted__c';
    private static final string FIELD_BILL_ISGLPOSTINGAPPROVED ='dmpl__IsGLPostingApproved__c';
    private static final string FIELD_BILL_PERFORMGLPOSTING ='dmpl__PerformGLPosting__c';
    private static final string FIELD_BILL_PERFORMKPICALCULATION = 'dmpl__PerformKPICalculation__c';
   
    private static final string FIELD_BILL_PRICELISTID ='dmpl__PriceListId__c';

    private static final string FIELD_BILLLINE_BILLID ='dmpl__PurchaseInvoiceId__c';
    private static final string FIELD_BILL_GOODSRECEIPTID = 'dmpl__GoodsReceiptId__c';
    private static final string RELATION_BILL_BILLLINES = 'dmpl__BillLines__r';

    private static final string FIELD_BILL_BILLINGADDRESS ='dmpl__BillingAddress__c';
    private static final string FIELD_BILL_SHIPPINGADDRESS ='dmpl__ShippingAddress__c';
    private static final string FIELD_BILL_BILLINGADDRESSID ='dmpl__BillingAddressId__c';
    private static final string FIELD_BILL_SHIPPINGADDRESSID ='dmpl__ShippingAddressId__c';

    private static final List<String> LIST_NON_EDITABLE_FIELDS = new List<String>{FIELD_BILL_PURCHASEORDERID,FIELD_BILL_SUPPLIERACCOUNTID, FIELD_BILL_PARTNERACCOUNTID, FIELD_BILL_BRANCHID, FIELD_BILL_DOCUMENTDATE};
    private static final List<String> LIST_FIELDS_SOURCEPOULATED = new List<String>{FIELD_BILL_PARTNERACCOUNTID, FIELD_BILL_BRANCHID,FIELD_BILL_SUPPLIERACCOUNTID};
    private static final List<String> LIST_FIELDS_SYSTEM = new List<String>{
        FIELD_BILL_AMOUNTPAID, 
        FIELD_BILL_GLID, 
        FIELD_BILL_ISGLPOSTED
    };
    
    public static void validateData(Boolean isInsert, Boolean isDelete, Boolean isUpdate, List<dmpl__Bill__c> oldEntries, List<dmpl__Bill__c> newEntries)
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
            StatusHelper.validateStatusNew(OBJECT_BILL, FIELD_BILL_STATUS, newEntries);
            ValidationHelper.validatePartnerAndBranch(FIELD_BILL_PARTNERACCOUNTID, FIELD_BILL_BRANCHID, newEntries);
        }else if(isUpdate){
            StatusHelper.validateStatusEdit(OBJECT_BILL, FIELD_BILL_STATUS, oldEntries, newEntries);
            DocumentHelper.validateChangeInSystemFields(LIST_FIELDS_SYSTEM, oldEntries, newEntries);
            DocumentHelper.validateChangeInKeyFields(LIST_NON_EDITABLE_FIELDS, oldEntries, newEntries,queryTransactedObjectIds(newEntries));
            DocumentHelper.validateChangeInSourcePopulatedFields(LIST_FIELDS_SOURCEPOULATED, oldEntries, newEntries, FIELD_BILL_GOODSRECEIPTID);
            dfsHelper.DocumentStatusRestrictEdits_Edit(OBJECT_BILL, FIELD_BILL_STATUS, oldEntries, newEntries);
            dfsHelper.DocumentStatusRestrictFieldsEdits(OBJECT_BILL, FIELD_BILL_STATUS, oldEntries, newEntries);
        }else if(isDelete){
            dfsHelper.DocumentStatusRestrictEdits_Delete(OBJECT_BILL, FIELD_BILL_STATUS, oldEntries);
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
        List<dmpl__Bill__c> oldEntries, 
        List<dmpl__Bill__c> newEntries){
        DocumentStatusDFSHelper dfsHelper = new DocumentStatusDFSHelper();
        try{
            if(isInsert){
                PriceListHelper.setDefaultPriceListIds(
                    newEntries);
                DiscountGroupHelper.setDefaultDiscountGroupIds(
                    newEntries);
                dfsHelper.DocumentStatusSetFlag(
                    OBJECT_BILL, 
                    FIELD_BILL_STATUS, 
                    newEntries);
                dfsHelper.DocumentStatusReSetFlag(
                    OBJECT_BILL, 
                    FIELD_BILL_STATUS, 
                    newEntries);
                DocumentNameHelper.generateDocumentName(
                    newEntries);
                setDefaultAddress(newEntries);
            }else if(isUpdate){
                dfsHelper.DocumentStatusSetFlag(
                    OBJECT_BILL, 
                    FIELD_BILL_STATUS, 
                    oldEntries, 
                    newEntries);
                dfsHelper.DocumentStatusReSetFlag(
                    OBJECT_BILL, 
                    FIELD_BILL_STATUS, 
                    oldEntries, 
                    newEntries);
                List<dmpl__Bill__c> modifiedObjects = DocumentHelper.getApprovedObjects(
                    FIELD_BILL_PERFORMGLPOSTING, 
                    oldEntries, 
                    newEntries);
                if(modifiedObjects.size()>0){
                    PostGL(
                        modifiedObjects);
                }
                modifiedObjects = DocumentHelper.getApprovedObjects(
                    FIELD_BILL_PERFORMKPICALCULATION, 
                    oldEntries, 
                    newEntries);
                if(modifiedObjects.size()>0){
                    updatePerformanceKPI(
                        modifiedObjects);
                }

                List<dmpl__Bill__c> modifiedBills = DocumentHelper.getPostedObjects(
                    FIELD_BILL_ISGLPOSTINGAPPROVED, 
                    oldEntries, 
                    newEntries);
                if(modifiedBills.Size() > 0){
                    GeneralLedgerHelper.createLedger(
                        GeneralLedgerTypeEnums.Bill, 
                        isInsert, 
                        isDelete, 
                        isUpdate, 
                        oldEntries, 
                        newEntries);
                }

                setDefaultAddress(newEntries,oldEntries);
                RoundOffHelper.setRoundOff(
                    newEntries,
                    'dmpl__TotalLineAmount__c',
                    'dmpl__TotalTaxAmount2__c');
            }else if(isDelete){
                TaxHelper.deleteHeaderTaxes(oldEntries);
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
        List<dmpl__Bill__c> oldEntries, 
        List<dmpl__Bill__c> newEntries){
            if(isInsert){
                TaxHelper.createHeaderTaxes(
                isInsert, 
                newEntries);
            }else if(isUpdate){
                List<dmpl__Bill__c> modifiedObjects = DocumentHelper.getModifiedNewObjects(new string[]{
                    FIELD_BILL_TAXGROUPID,
                    FIELD_BILL_TAXID,
                    FIELD_BILL_TCSELIGIBLEAMOUNT
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
                    BillLineHelper.performReprice(
                        CollectionHelper.extractIds(modifiedObjects));
                }
            }
    }

    private static List<Id> queryTransactedObjectIds(List<dmpl__Bill__c> newEntries){

        SecurityHelper.ensureCanReadFields(new string[]{'dmpl__PurchaseInvoiceId__c'}, 'dmpl__BillLine__c');
        return DocumentHelper.extractIds([SELECT dmpl__PurchaseInvoiceId__c 
                FROM dmpl__BillLine__c
                WHERE dmpl__PurchaseInvoiceId__c IN:DocumentHelper.extractIds(newEntries)], FIELD_BILLLINE_BILLID);
    }

    private static void PostGL(List<dmpl__Bill__c> invoices)
    {
        SecurityHelper.ensureCanWriteFields(new string[]{'dmpl__IsGLPostingApproved__c','dmpl__PerformGLPosting__c'}, 'dmpl__Bill__c');
        for(dmpl__Bill__c document : invoices){
            //document.dmpl__IsGLPostingApproved__c = true;
            document.dmpl__PerformGLPosting__c = false;
        }
        BillLineHelper.approvePurchaseInvoiceLines(invoices);
        //PurchaseInvoiceTaxHelper.approvePurchaseTaxLines(invoices);
    }

    private static void updatePerformanceKPI(List<dmpl__Bill__c> newEntries)
    {
        PerformanceKPIHelper.upsertPerformanceKPI(OBJECT_BILL, 'SCHEME', newEntries);
        PerformanceKPIHelper.upsertPerformanceKPI(OBJECT_BILL, 'INCENTIVE', newEntries);
        for(dmpl__Bill__c lineEntry : newEntries)
        {
            lineEntry.dmpl__PerformKPICalculation__c = false;
            lineEntry.dmpl__IsKPICalculated__c = true;
        }
    }

    public static void createPurchaseInvoiceFromPurchaseOrder(List<dmpl__PurchaseOrder__c> purchaseOrders){
        createPurchaseInvoiceFromPurchaseOrder(queryPurchaseOrderLines(DocumentHelper.extractIds(purchaseOrders), null));
    }

    public static void createBillFromGoodsReceipt(List<dmpl__GoodsReceipt__c> goodsReceipts){
        createBillFromGoodsReceipt(queryGoodsReceiptLines(new List<Id>(), DocumentHelper.extractIds(goodsReceipts)));
    }

    public static void createPurchaseInvoiceFromPurchaseOrder(List<SourceObjectInfo> orderLinesInfo){
        createPurchaseInvoiceFromPurchaseOrder(queryPurchaseOrderLines(null, SourceObjectInfo.extractIds(orderLinesInfo)));
    }  
    
    //public static void createPurchaseInvoiceFromGoodsReceipt(List<dmpl__Good__c> purchaseOrders){
      //  createPurchaseInvoiceFromPurchaseOrder(queryPurchaseOrderLines(DocumentHelper.extractIds(purchaseOrders), null));
    //}

    private static void createPurchaseInvoiceFromPurchaseOrder(List<dmpl__PurchaseOrderLine__c> purchaseOrderLines)
    {
        if(purchaseOrderLines.size() == 0){
            throw new DMPLException(String.format(String.valueOf(System.Label.Generic_EmptyActionParam), new String[]{dmpl__PurchaseOrderLine__c.class.getName()}));
        }

        List<dmpl__PurchaseOrderLine__c> pendingOrderLines = new List<dmpl__PurchaseOrderLine__c>();
        for(dmpl__PurchaseOrderLine__c purchaseOrderLine : purchaseOrderLines){
            if(purchaseOrderLine.dmpl__PendingInvoiceQuantity__c>0){
                pendingOrderLines.Add(purchaseOrderLine);
            }
        }
        if(pendingOrderLines.size() == 0){
            throw new DMPLException(String.format(String.valueOf(System.Label.Generic_EmptyActionParam), new String[]{dmpl__PurchaseOrderLine__c.class.getName()}));
        }

        Map<Id, dmpl__Bill__c> billDocuments = new Map<Id,dmpl__Bill__c>();
        Map<Id, List<dmpl__BillLine__c>> billLines = new Map<Id, List<dmpl__BillLine__c>>();
        List<dmpl__GoodsReceiptLine__c> receiptLines = queryGoodsReceiptLines(DocumentHelper.extractIds(pendingOrderLines), new List<Id>());

        for(dmpl__PurchaseOrderLine__c orderLine : pendingOrderLines){
            if(orderLine.dmpl__ItemId__c !=null 
                && orderLine.dmpl__PendingInvoiceQuantity__c>0){

                dmpl__Bill__c billDocument = null;
                if(billDocuments.containsKey(orderLine.dmpl__PurchaseOrderId__c)){
                    billDocument = billDocuments.get(orderLine.dmpl__PurchaseOrderId__c);
                }else {
                    billDocument = createPurchaseInvoiceDocumentFromOrder(orderLine);
                    billDocuments.put(orderLine.dmpl__PurchaseOrderId__c, billDocument);
                    billLines.put(orderLine.dmpl__PurchaseOrderId__c, new List<dmpl__BillLine__c>());
                }
                List<dmpl__GoodsReceiptLine__c> filterdReceiptLines = new List<dmpl__GoodsReceiptLine__c>();
                if(receiptLines.Size() > 0)
                    filterdReceiptLines = DocumentHelper.getObjectsByFilter(receiptLines,'dmpl__PurchaseOrderLineId__c', orderLine.Id);

                if(filterdReceiptLines.Size() > 0)
                    billLines.get(orderLine.dmpl__PurchaseOrderId__c).addAll(createPurchaseInvoiceLinesFromReceiptLines(orderLine, filterdReceiptLines));
                else 
                    billLines.get(orderLine.dmpl__PurchaseOrderId__c).add(createPurchaseInvoiceLinesFromOrderLine(orderLine));
            }
        }

        if(billDocuments.size() >0){
            Savepoint sp = Database.setSavepoint();
            try {
                SecurityHelper.ensureCanCreateObject('dmpl__Bill__c');
                SecurityHelper.ensureCanCreateFields(new string[]{'dmpl__BranchId__c','dmpl__PartnerAccountId__c','dmpl__DocumentDate__c','dmpl__SupplierAccountId__c'}, 'dmpl__Bill__c');
                insert billDocuments.values();
                List<dmpl__BillLine__c> billLineList = new List<dmpl__BillLine__c>();
                for(Id orderId : billDocuments.keySet()){
                    dmpl__Bill__c invoiceDocument = billDocuments.get(orderId);
                    List<dmpl__BillLine__c> purchaseInvoiceLines = billLines.get(orderId);
                    for(dmpl__BillLine__c purchaseInvoiceLine : purchaseInvoiceLines){
                        purchaseInvoiceLine.dmpl__PurchaseInvoiceId__c = invoiceDocument.Id;
                        billLineList.add(purchaseInvoiceLine);
                    }
                }
                SecurityHelper.ensureCanCreateObject('dmpl__BillLine__c');
                SecurityHelper.ensureCanCreateFields(new string[]{'dmpl__ItemId__c','dmpl__SKUId__c','dmpl__Quantity__c','dmpl__TaxGroupId__c','dmpl__PurchaseOrderLineId__c'}, 'dmpl__BillLine__c');
                insert billLineList;
            } catch (Exception e) {
                Database.rollback(sp);
                throw e;
            }
        }
    }

    private static void createBillFromGoodsReceipt(List<dmpl__GoodsReceiptLine__c> goodsReceiptLines)
    {
        if(goodsReceiptLines.size() == 0){
            throw new DMPLException(String.format(String.valueOf(System.Label.Generic_EmptyActionParam), new String[]{dmpl__GoodsReceiptLine__c.class.getName()}));
        }

        List<dmpl__GoodsReceiptLine__c> pendingGoodsReceiptLines = new List<dmpl__GoodsReceiptLine__c>();
        for(dmpl__GoodsReceiptLine__c goodsReceiptLine : goodsReceiptLines){
            if(goodsReceiptLine.dmpl__PendingInvoiceQuantity__c>0){
                pendingGoodsReceiptLines.Add(goodsReceiptLine);
            }
        }
        if(pendingGoodsReceiptLines.size() == 0){
            throw new DMPLException(String.format(String.valueOf(System.Label.Generic_EmptyActionParam), new String[]{dmpl__GoodsReceiptLine__c.class.getName()}));
        }

        Map<Id, dmpl__Bill__c> billDocuments = new Map<Id,dmpl__Bill__c>();
        Map<Id, List<dmpl__BillLine__c>> billLines = new Map<Id, List<dmpl__BillLine__c>>();
        // List<dmpl__GoodsReceiptLine__c> receiptLines = queryGoodsReceiptLines(DocumentHelper.extractIds(pendingOrderLines));

        for(dmpl__GoodsReceiptLine__c pendingGoodsReceiptLine : pendingGoodsReceiptLines)
        {
            if(pendingGoodsReceiptLine.dmpl__ItemId__c !=null && pendingGoodsReceiptLine.dmpl__PendingInvoiceQuantity__c > 0)
            {
                dmpl__Bill__c billDocument = null;
                if(billDocuments.containsKey(pendingGoodsReceiptLine.dmpl__GoodsReceiptId__c)){
                    billDocument = billDocuments.get(pendingGoodsReceiptLine.dmpl__GoodsReceiptId__c);
                }else {
                    billDocument = createBillFromGoodsReceipt(pendingGoodsReceiptLine);
                    billDocuments.put(pendingGoodsReceiptLine.dmpl__GoodsReceiptId__c, billDocument);
                    billLines.put(pendingGoodsReceiptLine.dmpl__GoodsReceiptId__c, new List<dmpl__BillLine__c>());
                }
                // List<dmpl__GoodsReceiptLine__c> filterdReceiptLines = new List<dmpl__GoodsReceiptLine__c>();
                // if(pendingGoodsReceiptLines.Size() > 0)
                //     filterdReceiptLines = DocumentHelper.getObjectsByFilter(receiptLines,'dmpl__PurchaseOrderLineId__c', orderLine.Id);

                // if(filterdReceiptLines.Size() > 0)
                //     billLines.get(orderLine.dmpl__PurchaseOrderId__c).addAll(createPurchaseInvoiceLinesFromReceiptLines(orderLine, filterdReceiptLines));
                // else 
                List<dmpl__BillLine__c> currentBillLines = billLines.get(pendingGoodsReceiptLine.dmpl__GoodsReceiptId__c);
                if(currentBillLines != null)
                {
                    currentBillLines.add(createBillLinesFromGoodsReceiptLine(pendingGoodsReceiptLine));
                    billLines.put(pendingGoodsReceiptLine.dmpl__GoodsReceiptId__c, currentBillLines);
                }
                else{
                    currentBillLines = new List<dmpl__BillLine__c>();
                    currentBillLines.add(createBillLinesFromGoodsReceiptLine(pendingGoodsReceiptLine));
                    billLines.put(pendingGoodsReceiptLine.dmpl__GoodsReceiptId__c, currentBillLines);
                }
            }
        }

        if(billDocuments.size() >0){
            Savepoint sp = Database.setSavepoint();
            try {
                SecurityHelper.ensureCanCreateObject('dmpl__Bill__c');
                SecurityHelper.ensureCanCreateFields(new string[]{'dmpl__BranchId__c','dmpl__PartnerAccountId__c','dmpl__DocumentDate__c','dmpl__SupplierAccountId__c'}, 'dmpl__Bill__c');
                insert billDocuments.values();
                List<dmpl__BillLine__c> billLineList = new List<dmpl__BillLine__c>();
                for(Id orderId : billDocuments.keySet()){
                    dmpl__Bill__c invoiceDocument = billDocuments.get(orderId);
                    List<dmpl__BillLine__c> purchaseInvoiceLines = billLines.get(orderId);
                    for(dmpl__BillLine__c purchaseInvoiceLine : purchaseInvoiceLines){
                        purchaseInvoiceLine.dmpl__PurchaseInvoiceId__c = invoiceDocument.Id;
                        billLineList.add(purchaseInvoiceLine);
                    }
                }
                SecurityHelper.ensureCanCreateObject('dmpl__BillLine__c');
                SecurityHelper.ensureCanCreateFields(new string[]{'dmpl__ItemId__c','dmpl__SKUId__c','dmpl__Quantity__c','dmpl__TaxGroupId__c','dmpl__PurchaseOrderLineId__c'}, 'dmpl__BillLine__c');
                insert billLineList;
            } catch (Exception e) {
                Database.rollback(sp);
                throw e;
            }
        }
    }
    
	@TestVisible
    private static dmpl__Bill__c createPurchaseInvoiceDocumentFromOrder(dmpl__PurchaseOrderLine__c orderLine)
    {
        return new dmpl__Bill__c(
            dmpl__BranchId__c = orderLine.dmpl__PurchaseOrderId__r.dmpl__BranchId__c,
            dmpl__PartnerAccountId__c = orderLine.dmpl__PurchaseOrderId__r.dmpl__PartnerAccountId__c,
            dmpl__DocumentDate__c = orderLine.dmpl__PurchaseOrderId__r.dmpl__DocumentDate__c,
            dmpl__SupplierAccountId__c = orderLine.dmpl__PurchaseOrderId__r.dmpl__SupplierAccountId__c,
            dmpl__PurchaseOrderId__c = orderLine.dmpl__PurchaseOrderId__c
        );
    }

    private static dmpl__Bill__c createBillFromGoodsReceipt(dmpl__GoodsReceiptLine__c goodsReceiptLine)
    {
        return new dmpl__Bill__c(
            dmpl__BranchId__c = goodsReceiptLine.dmpl__GoodsReceiptId__r.dmpl__BranchId__c,
            dmpl__PartnerAccountId__c = goodsReceiptLine.dmpl__GoodsReceiptId__r.dmpl__PartnerAccountId__c,
            dmpl__DocumentDate__c = goodsReceiptLine.dmpl__GoodsReceiptId__r.dmpl__DocumentDate__c,
            dmpl__SupplierAccountId__c = goodsReceiptLine.dmpl__GoodsReceiptId__r.dmpl__SupplierAccountId__c,
            dmpl__GoodsReceiptId__c = goodsReceiptLine.dmpl__GoodsReceiptId__c
        );
    }
	@TestVisible
    private static dmpl__BillLine__c createPurchaseInvoiceLinesFromOrderLine(dmpl__PurchaseOrderLine__c orderLine)
    {
        return new dmpl__BillLine__c(
            dmpl__ItemId__c = orderLine.dmpl__ItemId__c,
            dmpl__SKUId__c = orderLine.dmpl__SKUId__c,
            dmpl__Quantity__c = orderLine.dmpl__PendingInvoiceQuantity__c,
            dmpl__TaxGroupId__c = orderLine.dmpl__TaxGroupId__c,
            dmpl__PurchaseOrderLineId__c= orderLine.Id
        );
    }

    private static dmpl__BillLine__c createBillLinesFromGoodsReceiptLine(dmpl__GoodsReceiptLine__c goodsReceiptLine)
    {
        return new dmpl__BillLine__c(
            dmpl__ItemId__c = goodsReceiptLine.dmpl__ItemId__c,
            dmpl__SKUId__c = goodsReceiptLine.dmpl__SKUId__c,
            dmpl__Quantity__c = goodsReceiptLine.dmpl__PendingInvoiceQuantity__c,
            dmpl__TaxGroupId__c = goodsReceiptLine.dmpl__TaxGroupId__c,
            dmpl__ItemLotId__c = goodsReceiptLine.dmpl__ItemLotId__c,
            dmpl__ItemLotTypeId__c = goodsReceiptLine.dmpl__ItemLotTypeId__c,
            dmpl__GoodsReceiptLineId__c= goodsReceiptLine.Id
        );
    }

    @TestVisible
    private static List<dmpl__BillLine__c> createPurchaseInvoiceLinesFromReceiptLines(dmpl__PurchaseOrderLine__c orderLine, List<dmpl__GoodsReceiptLine__c> receiptLines)
    {
        List<dmpl__BillLine__c> newBillLines = new List<dmpl__BillLine__c>();
        for(dmpl__GoodsReceiptLine__c receiptLine : receiptLines)
        {
            if(receiptLine.dmpl__PurchaseOrderLineId__c != orderLine.Id)
                continue;
            newBillLines.add(new dmpl__BillLine__c(
            dmpl__ItemId__c = orderLine.dmpl__ItemId__c,
            dmpl__SKUId__c = orderLine.dmpl__SKUId__c,
            dmpl__TaxGroupId__c = orderLine.dmpl__TaxGroupId__c,
            dmpl__PurchaseOrderLineId__c= orderLine.Id,
            dmpl__Quantity__c = receiptLine.dmpl__ReceivedQuantity__c,
            dmpl__ItemLotId__c = receiptLine.dmpl__ItemLotId__c,
            dmpl__ItemLotTypeId__c = receiptLine.dmpl__ItemLotTypeId__c,
            dmpl__InventoryLedgerId__c = receiptLine.dmpl__InventoryLedgerId__c,
            dmpl__StorageLocationId__c = receiptLine.dmpl__StorageLocationId__c,
            dmpl__UnitCost__c = receiptLine.dmpl__UnitCost__c,
            dmpl__GoodsReceiptLineId__c	 = receiptLine.Id));
        }
        return newBillLines;
    }

    private static void setDefaultAddress(List<dmpl__Bill__c> newEntries){
        SecurityHelper.ensureCanWriteFields(new List<String>
        {
            FIELD_BILL_SHIPPINGADDRESS,
            FIELD_BILL_BILLINGADDRESS,
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
        }, OBJECT_BILL);

        List<Account> accounts = AccountHelper.getCachedAccounts(CollectionHelper.extractIds(newEntries, FIELD_BILL_PARTNERACCOUNTID));
        for(dmpl__Bill__c bill : newEntries){
            Account account = (Account)CollectionHelper.getObject(accounts, bill.dmpl__PartnerAccountId__c);
            if(account!=null){
                AccountHelper.setDefaultAddress(bill, account);
            }
        }
    }

    private static void setDefaultAddress(List<dmpl__Bill__c> newEntries, List<dmpl__Bill__c> oldEntries){
        SecurityHelper.ensureCanWriteFields(new List<String>
        {
            FIELD_BILL_SHIPPINGADDRESS,
            FIELD_BILL_BILLINGADDRESS
        }, OBJECT_BILL);
        Account account = null;
        List<Account> accounts = AccountHelper.getCachedAccounts(CollectionHelper.extractIds(newEntries, FIELD_BILL_PARTNERACCOUNTID));
        List<dmpl__Bill__c> modifiedOrders = DocumentHelper.getModifiedNewObjects(FIELD_BILL_BILLINGADDRESSID, oldEntries, newEntries);
        for(dmpl__Bill__c bill : modifiedOrders){
            account = (Account)CollectionHelper.getObject(accounts, bill.dmpl__PartnerAccountId__c);
            if(account!=null){
                AccountHelper.setDefaultAddress(bill, account);
            }
        }
        
        modifiedOrders = DocumentHelper.getModifiedNewObjects(FIELD_BILL_SHIPPINGADDRESSID, oldEntries, newEntries);
        for(dmpl__Bill__c bill : modifiedOrders){
            account = (Account)CollectionHelper.getObject(accounts, bill.dmpl__PartnerAccountId__c);
            if(account!=null){
                if(bill.dmpl__ShippingAddressId__c!=null){
                    dmpl__ContactAddress__c address = (dmpl__ContactAddress__c)CollectionHelper.getObject(account.dmpl__ContactAddress__r, bill.dmpl__ShippingAddressId__c);
                    if(address!=null){
                        bill.dmpl__ShippingAddress__c = AccountHelper.formatAddress(address);
                    }
                }else {
                    bill.dmpl__ShippingAddress__c = AccountHelper.formatAddress(account.ShippingAddress);
                }
            }
        }
    }

    private static List<dmpl__PurchaseOrderLine__c> queryPurchaseOrderLines(List<Id> purchaseOrderIds, List<Id> purchaseOrderLineIds)
    {
        if(purchaseOrderLineIds == null){
            purchaseOrderLineIds = new List<Id>();
        }
        
        SecurityHelper.ensureCanReadFields(new string[]{'dmpl__PartnerAccountId__c','dmpl__BranchId__c','dmpl__SupplierAccountId__c','dmpl__DocumentDate__c'},'dmpl__PurchaseOrder__c');
        SecurityHelper.ensureCanReadFields(new string[]{'dmpl__TrackInventory__c'},'dmpl__Item__c');
        SecurityHelper.ensureCanReadFields(new string[]{'dmpl__ItemId__c','dmpl__PurchaseOrderId__c','dmpl__TaxGroupId__c','dmpl__SKUId__c','dmpl__ReceiptQuantity__c','dmpl__PendingInvoiceQuantity__c'}, 'dmpl__PurchaseOrderLine__c');
        return [SELECT Id,
            Name,
            dmpl__ItemId__c,
            dmpl__SKUId__c,
            dmpl__ReceiptQuantity__c,
            dmpl__PendingInvoiceQuantity__c,
            dmpl__TaxGroupId__c,
            dmpl__PurchaseOrderId__c,
            dmpl__PurchaseOrderId__r.dmpl__PartnerAccountId__c,
            dmpl__PurchaseOrderId__r.dmpl__BranchId__c,
            dmpl__PurchaseOrderId__r.dmpl__SupplierAccountId__c,
            dmpl__PurchaseOrderId__r.dmpl__DocumentDate__c,
            dmpl__ItemId__r.dmpl__TrackInventory__c
        FROM dmpl__PurchaseOrderLine__c
        WHERE dmpl__PurchaseOrderId__c IN :purchaseOrderIds OR Id IN :purchaseOrderLineIds
        ];
    }

    private static List<dmpl__GoodsReceiptLine__c> queryGoodsReceiptLines(List<Id> purchaseOrderLineIds, List<Id> goodsReceiptIds)
    {
        SecurityHelper.ensureCanReadFields(new string[]{
            'dmpl__PartnerAccountId__c',
            'dmpl__BranchId__c',
            'dmpl__SupplierAccountId__c',
            'dmpl__DocumentDate__c'}, 
            'dmpl__GoodsReceipt__c');

        SecurityHelper.ensureCanReadFields(new string[]{
            'dmpl__ItemId__c',
            'dmpl__SKUId__c',
            'dmpl__PurchaseOrderLineId__c',
            'dmpl__PendingInvoiceQuantity__c',
            'dmpl__OrderedQuantity__c',
            'dmpl__ReceivedQuantity__c',
            'dmpl__ItemLotId__c',
            'dmpl__ItemLotTypeId__c',
            'dmpl__InventoryLedgerId__c',
            'dmpl__StorageLocationId__c',
            'dmpl__ShipmentLineId__c',
            'dmpl__GoodsReceiptId__c', 
            'dmpl__TaxGroupId__c', 
            'dmpl__UnitCost__c'}, 
            'dmpl__GoodsReceiptLine__c');

        return [SELECT Id,
            Name,
            dmpl__ItemId__c,
            dmpl__SKUId__c,
            dmpl__OrderedQuantity__c,
            dmpl__PendingInvoiceQuantity__c,
            dmpl__ReceivedQuantity__c,
            dmpl__ItemLotId__c,
            dmpl__ItemLotTypeId__c,
            dmpl__InventoryLedgerId__c,
            dmpl__StorageLocationId__c,
            dmpl__UnitCost__c,
            dmpl__ShipmentLineId__c,
            dmpl__PurchaseOrderLineId__c,
            dmpl__TaxGroupId__c, 
            dmpl__GoodsReceiptId__c,
            dmpl__GoodsReceiptId__r.dmpl__PartnerAccountId__c,
            dmpl__GoodsReceiptId__r.dmpl__BranchId__c,
            dmpl__GoodsReceiptId__r.dmpl__SupplierAccountId__c,
            dmpl__GoodsReceiptId__r.dmpl__DocumentDate__c
        FROM dmpl__GoodsReceiptLine__c
        WHERE (dmpl__ReceivedQuantity__c > 0 AND dmpl__PurchaseOrderLineId__c IN: purchaseOrderLineIds)
        OR (dmpl__PendingInvoiceQuantity__c > 0 AND dmpl__GoodsReceiptId__c IN : goodsReceiptIds)
        ];
    }
}