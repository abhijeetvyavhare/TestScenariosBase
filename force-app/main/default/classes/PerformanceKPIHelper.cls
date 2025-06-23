public with sharing class PerformanceKPIHelper 
{
    private static final string OBJECT_SALEORDER = 'dmpl__SaleOrder__c';
    private static final string OBJECT_SALEINVOICE = 'dmpl__SaleInvoice__c';
    private static final string OBJECT_PURCHASEORDER = 'dmpl__PurchaseOrder__c';
    private static final string OBJECT_REPAIRORDER = 'dmpl__RepairOrder__c';
    private static final string OBJECT_BILL = 'dmpl__Bill__c';
    private static final string OBJECT_SERVICEREQUEST = 'dmpl__ServiceRequest__c';

    private static final string FIELD_SUPPLIERACCOUNTID = 'dmpl__SupplierAccountId__c';
    private static final string FIELD_PARTNERACCOUNTID = 'dmpl__PartnerAccountId__c';
    private static final string FIELD_ACCOUNTID = 'dmpl__AccountId__c';
    private static final string FIELD_SCHEMEID = 'dmpl__SchemeId__c';
    private static final string FIELD_BRANCHID = 'dmpl__BranchId__c';
    private static final string FIELD_DOCUMENTDATE = 'dmpl__DocumentDate__c';
    private static final String FIELDNAME_ID = 'Id';
    private static final string FIELD_ITEMID = 'dmpl__ItemId__c';
    private static final string FIELD_PERFORMANCEKPITYPE = 'dmpl__PerformanceKPIType__c';

    private static final String SCHEMETYPE_PER_SO = 'Per Sale Order';
    private static final String SCHEMETYPE_PER_SI = 'Per Sale Invoice';
    private static final String SCHEMETYPE_PER_PO = 'Per Purchase Order';
    private static final string SCHEMETYPE_PER_RO = 'Per Repair Order';
    private static final string SCHEMETYPE_PER_BILL = 'Per Bill';

    private static final String STATUS_APPROVED = 'Approved';
    private static final String PERFORMANCE_KPI_TYPE_SCHEME = 'SCHEME';
    private static final String PERFORMANCE_KPI_TYPE_INCENTIVE = 'INCENTIVE';

    private static Map<String, String> defaultResourceFieldAPIs = new Map<String, String>{
        OBJECT_SALEORDER => 'dmpl__SalesExecutiveId__c',
        OBJECT_SALEINVOICE => 'dmpl__SalesExecutiveId__c',
        OBJECT_SERVICEREQUEST => 'dmpl__ServiceAdvisorId__c',
        OBJECT_REPAIRORDER => 'dmpl__ServiceAdvisorId__c'
    };

    private static Map<String, String> defaultChildRelationNames = new Map<String, String>{
        OBJECT_SALEORDER => 'dmpl__SaleOrderLines__r',
        OBJECT_SALEINVOICE => 'dmpl__SaleInvoiceLines__r',
        OBJECT_PURCHASEORDER => 'dmpl__PurchaseOrderLines__r',
        OBJECT_BILL => 'dmpl__BillLines__r',
        OBJECT_REPAIRORDER => 'dmpl__Repair_Order_Lines1__r'
    };

    private static Map<String, String> defaultSchemeType = new Map<String, String>{
        OBJECT_SALEORDER => SCHEMETYPE_PER_SO,
        OBJECT_SALEINVOICE => SCHEMETYPE_PER_SI,
        OBJECT_PURCHASEORDER => SCHEMETYPE_PER_PO,
        OBJECT_BILL => SCHEMETYPE_PER_BILL,
        OBJECT_REPAIRORDER => SCHEMETYPE_PER_RO
    };

    private static Map<String, List<String>> defaultIncentiveTargetType = new Map<String, List<String>>{
        OBJECT_SALEORDER => new List<String>{'No Of Sale Orders','Sale Order Amount','Sale Order Quantity','Percentage of Unique Outlets','No Of Unique Items'},
        OBJECT_SALEINVOICE => new List<String>{'No Of Invoices','Sale Amount','Sale Invoice Quantity','Percentage of Unique Outlets','No Of Unique Invoices','No Of Unique Items'},
        OBJECT_PURCHASEORDER => new List<String>{'No Of Purchase Orders','Purchase Order Amount'},
        OBJECT_BILL => new List<String>{'No Of Bills','Bill Amount'},
        OBJECT_REPAIRORDER => new List<String>{'No of Repair Orders','Service Amount'}
    };

    private static List<String> schemeApplicableObjects = new List<String>{OBJECT_SALEORDER, OBJECT_SALEINVOICE, OBJECT_PURCHASEORDER, OBJECT_REPAIRORDER, OBJECT_BILL};

    public static void upsertPerformanceKPI(String objectAPIName, String performanceKPIType, List<SObject> records)
    {
        List<dmpl__PerformanceKPIEvent__e> newEvents = new List<dmpl__PerformanceKPIEvent__e>();
        for(SObject record : records)
            newEvents.add(new dmpl__PerformanceKPIEvent__e(dmpl__ObjectAPIName__c = objectAPIName, dmpl__PerformanceKPIType__c = performanceKPIType, dmpl__RecordId__c = record.Id));
        
        // processPerformanceKPI(newEvents);
        Database.SaveResult[] results = EventBus.publish(newEvents);
    }

    public static void processPerformanceKPI(List<dmpl__PerformanceKPIEvent__e> newEntries)
    {
        List<dmpl__PerformanceKPIEvent__e> filteredRecords = DocumentHelper.getObjectsByFilter(newEntries, FIELD_PERFORMANCEKPITYPE, PERFORMANCE_KPI_TYPE_SCHEME);
        if(filteredRecords.size() > 0)
            upsertSchemePerformanceKPI(filteredRecords);
        
        filteredRecords = DocumentHelper.getObjectsByFilter(newEntries, FIELD_PERFORMANCEKPITYPE, PERFORMANCE_KPI_TYPE_INCENTIVE);
        if(filteredRecords.size() > 0)
            upsertIncentivePerformanceKPI(filteredRecords);
    }

    public static void upsertSchemePerformanceKPI(List<dmpl__PerformanceKPIEvent__e> newEntries)
    {
        try
        {
            List<Id> saleOrderIds = extractIdsIfExists(DocumentHelper.getObjectsByFilter(newEntries,'dmpl__ObjectAPIName__c', OBJECT_SALEORDER),'dmpl__RecordId__c');
            List<Id> saleInvoiceIds = extractIdsIfExists(DocumentHelper.getObjectsByFilter(newEntries,'dmpl__ObjectAPIName__c', OBJECT_SALEINVOICE),'dmpl__RecordId__c');
            List<Id> purchaseOrderIds = extractIdsIfExists(DocumentHelper.getObjectsByFilter(newEntries,'dmpl__ObjectAPIName__c', OBJECT_PURCHASEORDER),'dmpl__RecordId__c');
            List<Id> repairOrderIds = extractIdsIfExists(DocumentHelper.getObjectsByFilter(newEntries,'dmpl__ObjectAPIName__c', OBJECT_REPAIRORDER),'dmpl__RecordId__c');
            List<Id> billIds = extractIdsIfExists(DocumentHelper.getObjectsByFilter(newEntries,'dmpl__ObjectAPIName__c', OBJECT_BILL),'dmpl__RecordId__c');

            if(saleOrderIds.size() > 0)
            {
                upsertSchemePerformanceKPIInternal(OBJECT_SALEORDER, querySaleOrders(saleOrderIds));
            }
            if(saleInvoiceIds.size() > 0)
            {
                upsertSchemePerformanceKPIInternal(OBJECT_SALEINVOICE, querySaleInvoices(saleInvoiceIds));
            }
            if(purchaseOrderIds.size() > 0)
            {
                upsertSchemePerformanceKPIInternal(OBJECT_PURCHASEORDER, queryPurchaseOrders(purchaseOrderIds));
            }
            if(repairOrderIds.size() > 0)
            {
                upsertSchemePerformanceKPIInternal(OBJECT_REPAIRORDER, queryRepairOrders(repairOrderIds));
            }
            if(billIds.size() > 0)
            {
                upsertSchemePerformanceKPIInternal(OBJECT_BILL, queryBills(billIds));
            }
        }
        catch(Exception ex)
        {
            ExceptionLogHelper.logException(ex);
        }
    }

    public static void upsertIncentivePerformanceKPI(List<dmpl__PerformanceKPIEvent__e> newEntries)
    {
        try
        {
            List<Id> saleOrderIds = extractIdsIfExists(DocumentHelper.getObjectsByFilter(newEntries,'dmpl__ObjectAPIName__c', OBJECT_SALEORDER),'dmpl__RecordId__c');
            List<Id> saleInvoiceIds = extractIdsIfExists(DocumentHelper.getObjectsByFilter(newEntries,'dmpl__ObjectAPIName__c', OBJECT_SALEINVOICE),'dmpl__RecordId__c');
            List<Id> serviceRequestIds = extractIdsIfExists(DocumentHelper.getObjectsByFilter(newEntries,'dmpl__ObjectAPIName__c', OBJECT_SERVICEREQUEST),'dmpl__RecordId__c');
            List<Id> repairOrderIds = extractIdsIfExists(DocumentHelper.getObjectsByFilter(newEntries,'dmpl__ObjectAPIName__c', OBJECT_REPAIRORDER),'dmpl__RecordId__c');
            List<Id> purchaseOrderIds = extractIdsIfExists(DocumentHelper.getObjectsByFilter(newEntries,'dmpl__ObjectAPIName__c', OBJECT_PURCHASEORDER),'dmpl__RecordId__c');
            List<Id> billIds = extractIdsIfExists(DocumentHelper.getObjectsByFilter(newEntries,'dmpl__ObjectAPIName__c', OBJECT_BILL),'dmpl__RecordId__c');

            if(saleOrderIds.size() > 0)
            {
                upsertIncentivePerformanceKPIInternal(OBJECT_SALEORDER, querySaleOrders(saleOrderIds));
            }
            if(saleInvoiceIds.size() > 0)
            {
                upsertIncentivePerformanceKPIInternal(OBJECT_SALEINVOICE, querySaleInvoices(saleInvoiceIds));
            }
            if(serviceRequestIds.size() > 0)
            {
                upsertIncentivePerformanceKPIInternal(OBJECT_SERVICEREQUEST, queryServiceRequests(serviceRequestIds));
            }
            if(repairOrderIds.size() > 0)
            {
                upsertIncentivePerformanceKPIInternal(OBJECT_REPAIRORDER, queryRepairOrders(repairOrderIds));
            }
            if(purchaseOrderIds.size() > 0)
            {
                upsertIncentivePerformanceKPIInternal(OBJECT_PURCHASEORDER, queryPurchaseOrders(purchaseOrderIds));
            }
            if(billIds.size() > 0)
            {
                upsertIncentivePerformanceKPIInternal(OBJECT_BILL, queryBills(billIds));
            }
        }
        catch(Exception ex)
        {
            ExceptionLogHelper.logException(ex);
        }
    }

    public static void upsertSchemePerformanceKPIInternal(String objectAPIName, List<SObject> records)
    {
        String childRelationshipName = defaultChildRelationNames.get(objectAPIName);
        // Get Min & Max Date
        List<Date> documentDates = DocumentHelper.extractUniqueDateValues(records, FIELD_DOCUMENTDATE);
        documentDates.sort();
        Date minDate = documentDates[0];
        Date maxDate = documentDates[documentDates.size() - 1];
        List<dmpl__SchemePeriod__c> schemePeriods = querySchemePeriods(minDate, maxDate);
        // Extract Ids
        List<Id> supplierAccountIds = extractIdsIfExists(records, FIELD_SUPPLIERACCOUNTID);
        List<Id> partnerAccountIds = extractIdsIfExists(records, FIELD_PARTNERACCOUNTID);
        List<Id> accountIds = extractIdsIfExists(records, FIELD_ACCOUNTID);
        List<Id> partnerSchemeGroupIds = DocumentHelper.extractIdsFromLookup(
                                            records, 
                                            (objectAPIName == OBJECT_PURCHASEORDER 
                                            || objectAPIName == OBJECT_BILL) ? 
                                            'dmpl__PartnerAccountId__r' 
                                            : 'dmpl__AccountId__r', 
                                            'dmpl__PartnerSchemeAccountGroupId__c');
        
        List<dmpl__SchemeLine__c> activeSchemeLines = queryActiveSchemeLines(
                                                        supplierAccountIds, 
                                                        partnerAccountIds, 
                                                        accountIds, 
                                                        partnerSchemeGroupIds, 
                                                        minDate, 
                                                        maxDate);
        List<Id> schemeIds = extractIdsIfExists(activeSchemeLines, FIELD_SCHEMEID);
        List<dmpl__PerformanceKPI__c> upsertPerformanceKPI = queryPerformanceKPIs(schemeIds, null, supplierAccountIds, partnerAccountIds, accountIds);
        for(SObject record : records)
        {
            List<dmpl__SchemePeriod__c> eligibleSchemePeriods = getEligibleSchemePeriod(schemePeriods, record);
            List<dmpl__SchemeLine__c> eligibleSchemeLines = getEligibleSchemeLines(
                                                                activeSchemeLines, 
                                                                extractIdsIfExists(activeSchemeLines, FIELD_SCHEMEID), 
                                                                record);
            List<Id> eligibleSchemeIds = extractIdsIfExists(eligibleSchemeLines, FIELD_SCHEMEID);
            List<Id> distinctItemGroupIds = DocumentHelper.extractIds(eligibleSchemeLines, 'dmpl__SchemeConditions__r', 'dmpl__ItemGroupId__c');
            Map<Id, dmpl__ItemGroup__c> itemGroups = new Map<Id, dmpl__ItemGroup__c>(queryItemGroups(distinctItemGroupIds));

            Map<String, Object> recordFieldsMap = record.getPopulatedFieldsAsMap();
            Boolean isFound = false;
            for(Id schemeId : eligibleSchemeIds)
            {
                dmpl__SchemePeriod__c schemePeriod = (dmpl__SchemePeriod__c)DocumentHelper.getObjectByFilter(eligibleSchemePeriods, 'dmpl__SchemeId__c', schemeId);
                List<SObject> childRecords = (List<SObject>)recordFieldsMap.get(childRelationshipName);
                List<Id> alreadyCountedRecords = new List<Id>();
                // Child Records
                for(SObject childRecord : childRecords)
                {
                    Boolean isChildFound = false;
                    Boolean isChildFoundWithItem = false;
                    for(dmpl__SchemeLine__c schemeLine : eligibleSchemeLines)
                    {
                        if(schemeLine.dmpl__SchemeId__c == schemeId)
                        {
                            List<Id> distinctItemIds = DocumentHelper.extractIds(schemeLine.dmpl__SchemeConditions__r, 'dmpl__ItemId__c');
                            //List<Id> distinctItemGroupIds = DocumentHelper.extractIds(schemeLine.dmpl__SchemeConditions__r, 'dmpl__ItemGroupId__c');

                            // DISTINCT ITEM IDs
                            if(distinctItemIds.size() > 0)
                                for(Id distinctItemId : distinctItemIds)
                                {
                                    // WITH ITEM
                                    for(dmpl__PerformanceKPI__c performanceKPI : upsertPerformanceKPI)
                                    {
                                        if(((recordFieldsMap.containsKey(FIELD_SUPPLIERACCOUNTID) && performanceKPI.dmpl__SupplierAccountId__c == record.get(FIELD_SUPPLIERACCOUNTID)) || performanceKPI.dmpl__SupplierAccountId__c == null)
                                            && ((recordFieldsMap.containsKey(FIELD_PARTNERACCOUNTID) && performanceKPI.dmpl__PartnerAccountId__c == record.get(FIELD_PARTNERACCOUNTID)) || performanceKPI.dmpl__PartnerAccountId__c == null)
                                            && ((recordFieldsMap.containsKey(FIELD_BRANCHID) && performanceKPI.dmpl__BranchId__c == record.get(FIELD_BRANCHID)) || performanceKPI.dmpl__BranchId__c == null)
                                            && ((recordFieldsMap.containsKey(FIELD_ACCOUNTID) && performanceKPI.dmpl__AccountId__c == record.get(FIELD_ACCOUNTID) ||  performanceKPI.dmpl__AccountId__c == null))
                                            && performanceKPI.dmpl__SchemeId__c == schemeId
                                            && ((schemePeriod != null && performanceKPI.dmpl__SchemePeriodId__c == schemePeriod.Id) || (performanceKPI.dmpl__SchemePeriodId__c == null && schemePeriod == null))
                                            && (((distinctItemId != null && distinctItemId == childRecord.get(FIELD_ITEMID) && performanceKPI.dmpl__ItemId__c == childRecord.get(FIELD_ITEMID))) )
                                            && !alreadyCountedRecords.contains(childRecord.Id))
                                        {
                                            alreadyCountedRecords.add(childRecord.Id);
                                            isChildFoundWithItem = true;
                                            performanceKPI.dmpl__TotalQuantity__c = (performanceKPI.dmpl__TotalQuantity__c == null ? 0 : performanceKPI.dmpl__TotalQuantity__c) + Double.valueOf(childRecord.get('dmpl__Quantity__c'));
                                            performanceKPI.dmpl__TotalSaleOrderQuantity__c = (performanceKPI.dmpl__TotalSaleOrderQuantity__c == null ? 0 : performanceKPI.dmpl__TotalSaleOrderQuantity__c) + (objectAPIName == OBJECT_SALEORDER ? Double.valueOf(childRecord.get('dmpl__Quantity__c')) : 0);
                                            performanceKPI.dmpl__TotalSaleInvoiceQuantity__c = (performanceKPI.dmpl__TotalSaleInvoiceQuantity__c == null ? 0 : performanceKPI.dmpl__TotalSaleInvoiceQuantity__c) + (objectAPIName == OBJECT_SALEINVOICE ? Double.valueOf(childRecord.get('dmpl__Quantity__c')) : 0);
                                            performanceKPI.dmpl__TotalPurchaseOrderQuantity__c = (performanceKPI.dmpl__TotalPurchaseOrderQuantity__c == null ? 0 : performanceKPI.dmpl__TotalPurchaseOrderQuantity__c) + (objectAPIName == OBJECT_PURCHASEORDER ? Double.valueOf(childRecord.get('dmpl__Quantity__c')) : 0);
                                            performanceKPI.dmpl__TotalBillQuantity__c = (performanceKPI.dmpl__TotalBillQuantity__c == null ? 0 : performanceKPI.dmpl__TotalBillQuantity__c) + (objectAPIName == OBJECT_BILL ? Double.valueOf(childRecord.get('dmpl__Quantity__c')) : 0);
                                            performanceKPI.dmpl__TotalRepairOrderQuantity__c = (performanceKPI.dmpl__TotalRepairOrderQuantity__c == null ? 0 : performanceKPI.dmpl__TotalRepairOrderQuantity__c) + (objectAPIName == OBJECT_REPAIRORDER ? Double.valueOf(childRecord.get('dmpl__Quantity__c')) : 0);

                                            if(objectAPIName != OBJECT_SERVICEREQUEST && performanceKPI.dmpl__ItemId__c != null)
                                            {
                                                performanceKPI.dmpl__TotalAmount__c = (performanceKPI.dmpl__TotalAmount__c == null ? 0 : performanceKPI.dmpl__TotalAmount__c) + Double.valueOf(childRecord.get('dmpl__Amount__c'));
                                                performanceKPI.dmpl__TotalSaleOrderAmount__c = (performanceKPI.dmpl__TotalSaleOrderAmount__c == null ? 0 : performanceKPI.dmpl__TotalSaleOrderAmount__c) + (objectAPIName == OBJECT_SALEORDER ? Double.valueOf(childRecord.get('dmpl__Amount__c')) : 0);
                                                performanceKPI.dmpl__TotalSaleInvoiceAmount__c = (performanceKPI.dmpl__TotalSaleInvoiceAmount__c == null ? 0 : performanceKPI.dmpl__TotalSaleInvoiceAmount__c) + (objectAPIName == OBJECT_SALEINVOICE ? Double.valueOf(childRecord.get('dmpl__Amount__c')) : 0);
                                                performanceKPI.dmpl__TotalPurchaseOrderAmount__c = (performanceKPI.dmpl__TotalPurchaseOrderAmount__c == null ? 0 : performanceKPI.dmpl__TotalPurchaseOrderAmount__c) + (objectAPIName == OBJECT_PURCHASEORDER ? Double.valueOf(childRecord.get('dmpl__Amount__c')) : 0);
                                                performanceKPI.dmpl__TotalBillAmount__c = (performanceKPI.dmpl__TotalBillAmount__c == null ? 0 : performanceKPI.dmpl__TotalBillAmount__c) + (objectAPIName == OBJECT_BILL ? Double.valueOf(childRecord.get('dmpl__Amount__c')) : 0);
                                                performanceKPI.dmpl__TotalRepairOrderAmount__c = (performanceKPI.dmpl__TotalRepairOrderAmount__c == null ? 0 : performanceKPI.dmpl__TotalRepairOrderAmount__c) + (objectAPIName == OBJECT_REPAIRORDER ? Double.valueOf(childRecord.get('dmpl__Amount__c')) : 0);
                                            }
                                        }
                                    }
                                    if(!isChildFoundWithItem)
                                    {
                                        if((distinctItemId != null && distinctItemId == (Id)childRecord.get(FIELD_ITEMID)) && !alreadyCountedRecords.contains(childRecord.Id))
                                        {
                                            alreadyCountedRecords.add(childRecord.Id);
                                            dmpl__PerformanceKPI__c newRecord =  new dmpl__PerformanceKPI__c(
                                                dmpl__SupplierAccountId__c = recordFieldsMap.containsKey(FIELD_SUPPLIERACCOUNTID) ? (Id)record.get(FIELD_SUPPLIERACCOUNTID) : null,
                                                dmpl__PartnerAccountId__c = (Id)record.get(FIELD_PARTNERACCOUNTID),
                                                dmpl__BranchId__c = (Id)record.get(FIELD_BRANCHID),
                                                dmpl__AccountId__c = recordFieldsMap.containsKey(FIELD_ACCOUNTID) ? (Id)record.get(FIELD_ACCOUNTID) : null,
                                                dmpl__SchemeId__c = schemeId,
                                                dmpl__SchemePeriodId__c = schemePeriod?.Id,
                                                dmpl__ItemId__c = (Id)childRecord.get(FIELD_ITEMID),
                                                dmpl__TotalAmount__c = Double.valueOf(childRecord.get('dmpl__Amount__c')),
                                                dmpl__TotalTaxAmount__c = 0,
                                                dmpl__TotalQuantity__c = Double.valueOf(childRecord.get('dmpl__Quantity__c')),
                                                dmpl__TotalSaleOrderAmount__c = objectAPIName == OBJECT_SALEORDER ? Double.valueOf(childRecord.get('dmpl__Amount__c')) : 0,
                                                dmpl__TotalSaleInvoiceAmount__c = objectAPIName == OBJECT_SALEINVOICE ? Double.valueOf(childRecord.get('dmpl__Amount__c')) : 0,
                                                dmpl__TotalPurchaseOrderAmount__c = objectAPIName == OBJECT_PURCHASEORDER ? Double.valueOf(childRecord.get('dmpl__Amount__c')) : 0,
                                                dmpl__TotalBillAmount__c = objectAPIName == OBJECT_BILL ? Double.valueOf(childRecord.get('dmpl__Amount__c')) : 0,
                                                dmpl__TotalRepairOrderAmount__c = objectAPIName == OBJECT_REPAIRORDER ? Double.valueOf(childRecord.get('dmpl__Amount__c')) : 0,
                                                dmpl__TotalSaleOrderQuantity__c = objectAPIName == OBJECT_SALEORDER ? Double.valueOf(childRecord.get('dmpl__Quantity__c')) : 0,
                                                dmpl__TotalSaleInvoiceQuantity__c = objectAPIName == OBJECT_SALEINVOICE ? Double.valueOf(childRecord.get('dmpl__Quantity__c')) : 0,
                                                dmpl__TotalPurchaseOrderQuantity__c = objectAPIName == OBJECT_PURCHASEORDER ? Double.valueOf(childRecord.get('dmpl__Quantity__c')) : 0,
                                                dmpl__TotalBillQuantity__c = objectAPIName == OBJECT_BILL ? Double.valueOf(childRecord.get('dmpl__Quantity__c')) : 0,
                                                dmpl__TotalRepairOrderQuantity__c = objectAPIName == OBJECT_REPAIRORDER ? Double.valueOf(childRecord.get('dmpl__Quantity__c')) : 0,
                                                dmpl__PostingType__c = 'KPI'
                                                );
                                            upsertPerformanceKPI.add(newRecord);
                                        }
                                    }
                                }

                            isChildFoundWithItem = false;
                            // DISTINCT ITEM GROUP IDs
                            if(distinctItemGroupIds.size() > 0)
                                for(Id distinctItemGroupId : distinctItemGroupIds)
                                {
                                    dmpl__ItemGroup__c currentItemGroup = itemGroups.get(distinctItemGroupId);
                                    List<Id> groupMemberItemIds = (List<Id>)DocumentHelper.extractIds(currentItemGroup.dmpl__ItemGroupMembers__r, 'dmpl__ItemId__c');
                                    // WITH ITEM GROUP ID
                                    for(dmpl__PerformanceKPI__c performanceKPI : upsertPerformanceKPI)
                                    {
                                        if(((recordFieldsMap.containsKey(FIELD_SUPPLIERACCOUNTID) && performanceKPI.dmpl__SupplierAccountId__c == record.get(FIELD_SUPPLIERACCOUNTID)) || performanceKPI.dmpl__SupplierAccountId__c == null)
                                            && ((recordFieldsMap.containsKey(FIELD_PARTNERACCOUNTID) && performanceKPI.dmpl__PartnerAccountId__c == record.get(FIELD_PARTNERACCOUNTID)) || performanceKPI.dmpl__PartnerAccountId__c == null)
                                            && ((recordFieldsMap.containsKey(FIELD_BRANCHID) && performanceKPI.dmpl__BranchId__c == record.get(FIELD_BRANCHID)) || performanceKPI.dmpl__BranchId__c == null)
                                            && ((recordFieldsMap.containsKey(FIELD_ACCOUNTID) && performanceKPI.dmpl__AccountId__c == record.get(FIELD_ACCOUNTID) ||  performanceKPI.dmpl__AccountId__c == null))
                                            && performanceKPI.dmpl__SchemeId__c == schemeId
                                            && ((schemePeriod != null && performanceKPI.dmpl__SchemePeriodId__c == schemePeriod.Id) || (performanceKPI.dmpl__SchemePeriodId__c == null && schemePeriod == null))
                                            && (
                                                (
                                                    (performanceKPI.dmpl__ItemId__c == childRecord.get(FIELD_ITEMID) 
                                                    && distinctItemGroupId != null 
                                                    // && childRecord.getSObject('dmpl__ItemId__r').get('dmpl__SchemeItemGroupId__c') != null 
                                                    && groupMemberItemIds.contains((Id)childRecord.get('dmpl__ItemId__c'))
                                                    //&& distinctItemGroupId == childRecord.getSObject('dmpl__ItemId__r').get('dmpl__SchemeItemGroupId__c') 
                                                    //&& performanceKPI.dmpl__ItemId__r.dmpl__SchemeItemGroupId__c == childRecord.getSObject('dmpl__ItemId__r').get('dmpl__SchemeItemGroupId__c')
                                                    )
                                                )
                                                )
                                            && !alreadyCountedRecords.contains(childRecord.Id))
                                        {
                                            isChildFoundWithItem = true;
                                            alreadyCountedRecords.add(childRecord.Id);


                                            performanceKPI.dmpl__TotalQuantity__c = (performanceKPI.dmpl__TotalQuantity__c == null ? 0 : performanceKPI.dmpl__TotalQuantity__c) + Double.valueOf(childRecord.get('dmpl__Quantity__c'));
                                            performanceKPI.dmpl__TotalSaleOrderQuantity__c = (performanceKPI.dmpl__TotalSaleOrderQuantity__c == null ? 0 : performanceKPI.dmpl__TotalSaleOrderQuantity__c) + (objectAPIName == OBJECT_SALEORDER ? Double.valueOf(childRecord.get('dmpl__Quantity__c')) : 0);
                                            performanceKPI.dmpl__TotalSaleInvoiceQuantity__c = (performanceKPI.dmpl__TotalSaleInvoiceQuantity__c == null ? 0 : performanceKPI.dmpl__TotalSaleInvoiceQuantity__c) + (objectAPIName == OBJECT_SALEINVOICE ? Double.valueOf(childRecord.get('dmpl__Quantity__c')) : 0);
                                            performanceKPI.dmpl__TotalPurchaseOrderQuantity__c = (performanceKPI.dmpl__TotalPurchaseOrderQuantity__c == null ? 0 : performanceKPI.dmpl__TotalPurchaseOrderQuantity__c) + (objectAPIName == OBJECT_PURCHASEORDER ? Double.valueOf(childRecord.get('dmpl__Quantity__c')) : 0);
                                            performanceKPI.dmpl__TotalBillQuantity__c = (performanceKPI.dmpl__TotalBillQuantity__c == null ? 0 : performanceKPI.dmpl__TotalBillQuantity__c) + (objectAPIName == OBJECT_BILL ? Double.valueOf(childRecord.get('dmpl__Quantity__c')) : 0);
                                            performanceKPI.dmpl__TotalRepairOrderQuantity__c = (performanceKPI.dmpl__TotalRepairOrderQuantity__c == null ? 0 : performanceKPI.dmpl__TotalRepairOrderQuantity__c) + (objectAPIName == OBJECT_REPAIRORDER ? Double.valueOf(childRecord.get('dmpl__Quantity__c')) : 0);

                                            if(objectAPIName != OBJECT_SERVICEREQUEST && performanceKPI.dmpl__ItemId__c != null)
                                            {

                                                performanceKPI.dmpl__TotalRepairOrderAmount__c = 
                                                                                                + (objectAPIName == OBJECT_REPAIRORDER ? Double.valueOf(childRecord.get('dmpl__Amount__c')) : 0);

                                                performanceKPI.dmpl__TotalAmount__c = (performanceKPI.dmpl__TotalAmount__c == null ? 0 : performanceKPI.dmpl__TotalAmount__c) + Double.valueOf(childRecord.get('dmpl__Amount__c'));
                                                performanceKPI.dmpl__TotalSaleOrderAmount__c = (performanceKPI.dmpl__TotalSaleOrderAmount__c == null ? 0 : performanceKPI.dmpl__TotalSaleOrderAmount__c) + (objectAPIName == OBJECT_SALEORDER ? Double.valueOf(childRecord.get('dmpl__Amount__c')) : 0);
                                                performanceKPI.dmpl__TotalSaleInvoiceAmount__c = (performanceKPI.dmpl__TotalSaleInvoiceAmount__c == null ? 0 : performanceKPI.dmpl__TotalSaleInvoiceAmount__c) + (objectAPIName == OBJECT_SALEINVOICE ? Double.valueOf(childRecord.get('dmpl__Amount__c')) : 0);
                                                performanceKPI.dmpl__TotalPurchaseOrderAmount__c = (performanceKPI.dmpl__TotalPurchaseOrderAmount__c == null ? 0 : performanceKPI.dmpl__TotalPurchaseOrderAmount__c) + (objectAPIName == OBJECT_PURCHASEORDER ? Double.valueOf(childRecord.get('dmpl__Amount__c')) : 0);
                                                performanceKPI.dmpl__TotalBillAmount__c = (performanceKPI.dmpl__TotalBillAmount__c == null ? 0 : performanceKPI.dmpl__TotalBillAmount__c) + (objectAPIName == OBJECT_BILL ? Double.valueOf(childRecord.get('dmpl__Amount__c')) : 0);
                                                performanceKPI.dmpl__TotalRepairOrderAmount__c = (performanceKPI.dmpl__TotalRepairOrderAmount__c == null ? 0 : performanceKPI.dmpl__TotalRepairOrderAmount__c) + (objectAPIName == OBJECT_REPAIRORDER ? Double.valueOf(childRecord.get('dmpl__Amount__c')) : 0);
                                            }
                                        }
                                    }
                                    if(!isChildFoundWithItem)
                                    {
                                        if((distinctItemGroupId != null 
                                        // && childRecord.getSObject('dmpl__ItemId__r').get('dmpl__SchemeItemGroupId__c') != null 
                                        // && distinctItemGroupId == childRecord.getSObject('dmpl__ItemId__r').get('dmpl__SchemeItemGroupId__c')) 
                                        && groupMemberItemIds.contains((Id)childRecord.get('dmpl__ItemId__c'))
                                        && !alreadyCountedRecords.contains(childRecord.Id)))
                                        {
                                            alreadyCountedRecords.add(childRecord.Id);
                                            dmpl__PerformanceKPI__c newRecord =  new dmpl__PerformanceKPI__c(
                                                dmpl__SupplierAccountId__c = recordFieldsMap.containsKey(FIELD_SUPPLIERACCOUNTID) ? (Id)record.get(FIELD_SUPPLIERACCOUNTID) : null,
                                                dmpl__PartnerAccountId__c = (Id)record.get(FIELD_PARTNERACCOUNTID),
                                                dmpl__BranchId__c = (Id)record.get(FIELD_BRANCHID),
                                                dmpl__AccountId__c = recordFieldsMap.containsKey(FIELD_ACCOUNTID) ? (Id)record.get(FIELD_ACCOUNTID) : null,
                                                dmpl__SchemeId__c = schemeId,
                                                dmpl__SchemePeriodId__c = schemePeriod?.Id,
                                                dmpl__ItemId__c = (Id)childRecord.get(FIELD_ITEMID),
                                                dmpl__TotalAmount__c = Double.valueOf(childRecord.get('dmpl__Amount__c')),
                                                dmpl__TotalTaxAmount__c = 0,
                                                dmpl__TotalQuantity__c = Double.valueOf(childRecord.get('dmpl__Quantity__c')),
                                                dmpl__TotalSaleOrderAmount__c = objectAPIName == OBJECT_SALEORDER ? Double.valueOf(childRecord.get('dmpl__Amount__c')) : 0,
                                                dmpl__TotalSaleInvoiceAmount__c = objectAPIName == OBJECT_SALEINVOICE ? Double.valueOf(childRecord.get('dmpl__Amount__c')) : 0,
                                                dmpl__TotalPurchaseOrderAmount__c = objectAPIName == OBJECT_PURCHASEORDER ? Double.valueOf(childRecord.get('dmpl__Amount__c')) : 0,
                                                dmpl__TotalBillAmount__c = objectAPIName == OBJECT_BILL ? Double.valueOf(childRecord.get('dmpl__Amount__c')) : 0,
                                                dmpl__TotalRepairOrderAmount__c = objectAPIName == OBJECT_REPAIRORDER ? Double.valueOf(childRecord.get('dmpl__Amount__c')) : 0,
                                                dmpl__TotalSaleOrderQuantity__c = objectAPIName == OBJECT_SALEORDER ? Double.valueOf(childRecord.get('dmpl__Quantity__c')) : 0,
                                                dmpl__TotalSaleInvoiceQuantity__c = objectAPIName == OBJECT_SALEINVOICE ? Double.valueOf(childRecord.get('dmpl__Quantity__c')) : 0,
                                                dmpl__TotalPurchaseOrderQuantity__c = objectAPIName == OBJECT_PURCHASEORDER ? Double.valueOf(childRecord.get('dmpl__Quantity__c')) : 0,
                                                dmpl__TotalBillQuantity__c = objectAPIName == OBJECT_BILL ? Double.valueOf(childRecord.get('dmpl__Quantity__c')) : 0,
                                                dmpl__TotalRepairOrderQuantity__c = objectAPIName == OBJECT_REPAIRORDER ? Double.valueOf(childRecord.get('dmpl__Quantity__c')) : 0,
                                                dmpl__PostingType__c = 'KPI'
                                                );
                                            upsertPerformanceKPI.add(newRecord);
                                        }
                                    }
                                }
                        }
                    }
                }
                // Parent Record
                for(dmpl__PerformanceKPI__c performanceKPI : upsertPerformanceKPI)
                {
                    if(
                        ((recordFieldsMap.containsKey(FIELD_SUPPLIERACCOUNTID) && performanceKPI.dmpl__SupplierAccountId__c == record.get(FIELD_SUPPLIERACCOUNTID)) || performanceKPI.dmpl__SupplierAccountId__c == null)
                        && ((recordFieldsMap.containsKey(FIELD_PARTNERACCOUNTID) && performanceKPI.dmpl__PartnerAccountId__c == record.get(FIELD_PARTNERACCOUNTID)) || performanceKPI.dmpl__PartnerAccountId__c == null)
                        && ((recordFieldsMap.containsKey(FIELD_BRANCHID) && performanceKPI.dmpl__BranchId__c == record.get(FIELD_BRANCHID)) || performanceKPI.dmpl__BranchId__c == null)
                        && ((recordFieldsMap.containsKey(FIELD_ACCOUNTID) && performanceKPI.dmpl__AccountId__c == record.get(FIELD_ACCOUNTID) ||  performanceKPI.dmpl__AccountId__c == null))
                        && performanceKPI.dmpl__SchemeId__c == schemeId
                        && ((schemePeriod != null && performanceKPI.dmpl__SchemePeriodId__c == schemePeriod.Id) || (performanceKPI.dmpl__SchemePeriodId__c == null && schemePeriod == null))
                        && performanceKPI.dmpl__ItemId__c == null)
                    {
                        isFound = true;
                        Decimal totalQuantity = getTotalQuantity(childRecords);
                        
                        performanceKPI.dmpl__TotalQuantity__c = (performanceKPI.dmpl__TotalQuantity__c == null ? 0 : performanceKPI.dmpl__TotalQuantity__c) + totalQuantity;
                        performanceKPI.dmpl__TotalSaleOrderQuantity__c = (performanceKPI.dmpl__TotalSaleOrderQuantity__c == null ? 0 : performanceKPI.dmpl__TotalSaleOrderQuantity__c) + (objectAPIName == OBJECT_SALEORDER ? totalQuantity : 0);
                        performanceKPI.dmpl__TotalSaleInvoiceQuantity__c = (performanceKPI.dmpl__TotalSaleInvoiceQuantity__c == null ? 0 : performanceKPI.dmpl__TotalSaleInvoiceQuantity__c) + (objectAPIName == OBJECT_SALEINVOICE ? totalQuantity : 0);
                        performanceKPI.dmpl__TotalPurchaseOrderQuantity__c = (performanceKPI.dmpl__TotalPurchaseOrderQuantity__c == null ? 0 : performanceKPI.dmpl__TotalPurchaseOrderQuantity__c) + (objectAPIName == OBJECT_PURCHASEORDER ? totalQuantity : 0);
                        performanceKPI.dmpl__TotalBillQuantity__c =  (performanceKPI.dmpl__TotalBillQuantity__c == null ? 0 : performanceKPI.dmpl__TotalBillQuantity__c) + (objectAPIName == OBJECT_BILL ? totalQuantity : 0);
                        performanceKPI.dmpl__TotalRepairOrderQuantity__c = (performanceKPI.dmpl__TotalRepairOrderQuantity__c == null ? 0 : performanceKPI.dmpl__TotalRepairOrderQuantity__c) + (objectAPIName == OBJECT_REPAIRORDER ? totalQuantity : 0);
                        if(objectAPIName == OBJECT_SALEORDER)
                        {
                            performanceKPI.dmpl__NumberOfOrders__c = (performanceKPI.dmpl__NumberOfOrders__c == null ? 0 : performanceKPI.dmpl__NumberOfOrders__c) + 1;
                            performanceKPI.dmpl__TotalAmount__c = (performanceKPI.dmpl__TotalAmount__c == null ? 0 : performanceKPI.dmpl__TotalAmount__c) + Double.valueOf(record.get('dmpl__LineSubTotal__c'));
                            performanceKPI.dmpl__TotalTaxAmount__c = (performanceKPI.dmpl__TotalTaxAmount__c == null ? 0 : performanceKPI.dmpl__TotalTaxAmount__c) + Double.valueOf(record.get('dmpl__TotalTaxAmount2__c'));
                            performanceKPI.dmpl__TotalSaleOrderAmount__c = (performanceKPI.dmpl__TotalSaleOrderAmount__c == null ? 0 : performanceKPI.dmpl__TotalSaleOrderAmount__c) + Double.valueOf(record.get('dmpl__LineSubTotal__c')) + Double.valueOf(record.get('dmpl__TotalTaxAmount2__c'));
                        }
                        if(objectAPIName == OBJECT_SALEINVOICE)
                        {
                            performanceKPI.dmpl__NumberOfInvoices__c = (performanceKPI.dmpl__NumberOfInvoices__c == null ? 0 : performanceKPI.dmpl__NumberOfInvoices__c) + 1;
                            performanceKPI.dmpl__TotalAmount__c = (performanceKPI.dmpl__TotalAmount__c == null ? 0 : performanceKPI.dmpl__TotalAmount__c) + Double.valueOf(record.get('dmpl__TotalLineAmount__c'));
                            performanceKPI.dmpl__TotalTaxAmount__c = (performanceKPI.dmpl__TotalTaxAmount__c == null ? 0 : performanceKPI.dmpl__TotalTaxAmount__c) + Double.valueOf(record.get('dmpl__TotalTaxAmount2__c'));
                            performanceKPI.dmpl__TotalSaleInvoiceAmount__c = (performanceKPI.dmpl__TotalSaleInvoiceAmount__c == null ? 0 : performanceKPI.dmpl__TotalSaleInvoiceAmount__c) + Double.valueOf(record.get('dmpl__TotalLineAmount__c')) + Double.valueOf(record.get('dmpl__TotalTaxAmount2__c'));
                        }
                        if(objectAPIName == OBJECT_PURCHASEORDER)
                        {
                            performanceKPI.dmpl__NumberOfPurchaseOrders__c = (performanceKPI.dmpl__NumberOfPurchaseOrders__c == null ? 0 : performanceKPI.dmpl__NumberOfPurchaseOrders__c) + 1;
                            performanceKPI.dmpl__TotalAmount__c = (performanceKPI.dmpl__TotalAmount__c == null ? 0 : performanceKPI.dmpl__TotalAmount__c)  + Double.valueOf(record.get('dmpl__TotalLineAmount__c'));
                            // performanceKPI.dmpl__TotalTaxAmount__c = performanceKPI.dmpl__TotalTaxAmount__c + Double.valueOf(record.get('dmpl__TotalTaxAmount2__c'));
                            performanceKPI.dmpl__TotalPurchaseOrderAmount__c = (performanceKPI.dmpl__TotalSaleInvoiceAmount__c == null ? 0 : performanceKPI.dmpl__TotalSaleInvoiceAmount__c) + Double.valueOf(record.get('dmpl__TotalLineAmount__c'));
                        }
                        if(objectAPIName == OBJECT_REPAIRORDER)
                        {
                            performanceKPI.dmpl__NumberOfRepairOrders__c = (performanceKPI.dmpl__NumberOfRepairOrders__c == null ? 0 : performanceKPI.dmpl__NumberOfRepairOrders__c ) + 1;
                            performanceKPI.dmpl__TotalAmount__c = (performanceKPI.dmpl__TotalAmount__c == null ? 0 : performanceKPI.dmpl__TotalAmount__c) + Double.valueOf(record.get('dmpl__TotalPartAmount__c')) + Double.valueOf(record.get('dmpl__TotalLabourAmount__c'));
                            performanceKPI.dmpl__TotalTaxAmount__c = (performanceKPI.dmpl__TotalTaxAmount__c == null ? 0 : performanceKPI.dmpl__TotalTaxAmount__c) + Double.valueOf(record.get('dmpl__TotalTax__c'));
                            performanceKPI.dmpl__TotalRepairOrderAmount__c = (performanceKPI.dmpl__TotalRepairOrderAmount__c == null ? 0 : performanceKPI.dmpl__TotalRepairOrderAmount__c) + Double.valueOf(record.get('dmpl__TotalPartAmount__c')) + Double.valueOf(record.get('dmpl__TotalLabourAmount__c')) + Double.valueOf(record.get('dmpl__TotalTax__c'));
                        }
                        if(objectAPIName == OBJECT_BILL)
                        {
                            performanceKPI.dmpl__NumberOfBills__c = (performanceKPI.dmpl__NumberOfBills__c == null ? 0 : performanceKPI.dmpl__NumberOfBills__c) + 1;
                            performanceKPI.dmpl__TotalAmount__c = (performanceKPI.dmpl__TotalAmount__c == null ? 0 : performanceKPI.dmpl__TotalAmount__c) + Double.valueOf(record.get('dmpl__TotalLineAmount__c'));
                            // performanceKPI.dmpl__TotalTaxAmount__c = performanceKPI.dmpl__TotalTaxAmount__c + Double.valueOf(record.get('dmpl__TotalLineAmount__c'));
                            performanceKPI.dmpl__TotalBillAmount__c =  (performanceKPI.dmpl__TotalBillAmount__c == null ? 0 : performanceKPI.dmpl__TotalBillAmount__c) + Double.valueOf(record.get('dmpl__TotalLineAmount__c'));
                        }
                    }
                }
                if(!isFound)
                {
                    dmpl__PerformanceKPI__c newRecord =  new dmpl__PerformanceKPI__c(
                        dmpl__SupplierAccountId__c = recordFieldsMap.containsKey(FIELD_SUPPLIERACCOUNTID) ? (Id)record.get(FIELD_SUPPLIERACCOUNTID) : null,
                        dmpl__PartnerAccountId__c = (Id)record.get(FIELD_PARTNERACCOUNTID),
                        dmpl__BranchId__c = (Id)record.get(FIELD_BRANCHID),
                        dmpl__AccountId__c = recordFieldsMap.containsKey(FIELD_ACCOUNTID) ? (Id)record.get(FIELD_ACCOUNTID) : null,
                        dmpl__SchemeId__c = schemeId,
                        dmpl__SchemePeriodId__c = schemePeriod?.Id,
                        dmpl__NumberOfInvoices__c = objectAPIName == OBJECT_SALEINVOICE ? 1 : 0,
                        dmpl__NumberOfOrders__c = objectAPIName == OBJECT_SALEORDER ? 1 : 0,
                        dmpl__NumberOfRepairOrders__c = objectAPIName == OBJECT_REPAIRORDER ? 1 : 0,
                        dmpl__NumberOfPurchaseOrders__c = objectAPIName == OBJECT_PURCHASEORDER ? 1 : 0,
                        dmpl__NumberOfBills__c = objectAPIName == OBJECT_BILL ? 1 : 0,
                        dmpl__TotalQuantity__c = getTotalQuantity(childRecords),
                        dmpl__TotalSaleOrderQuantity__c = objectAPIName == OBJECT_SALEORDER ? getTotalQuantity(childRecords) : 0,
                        dmpl__TotalSaleInvoiceQuantity__c = objectAPIName == OBJECT_SALEINVOICE ? getTotalQuantity(childRecords) : 0,
                        dmpl__TotalPurchaseOrderQuantity__c = objectAPIName == OBJECT_PURCHASEORDER ? getTotalQuantity(childRecords) : 0,
                        dmpl__TotalBillQuantity__c = objectAPIName == OBJECT_BILL ? getTotalQuantity(childRecords) : 0,
                        dmpl__TotalRepairOrderQuantity__c = objectAPIName == OBJECT_REPAIRORDER ? getTotalQuantity(childRecords) : 0,
                        dmpl__PostingType__c = 'KPI');

                    if(objectAPIName == OBJECT_SALEORDER)  {
                        newRecord.dmpl__TotalAmount__c = Double.valueOf(record.get('dmpl__LineSubTotal__c'));
                        newRecord.dmpl__TotalTaxAmount__c = Double.valueOf(record.get('dmpl__TotalTaxAmount2__c'));
                        newRecord.dmpl__TotalSaleOrderAmount__c = newRecord.dmpl__TotalAmount__c + newRecord.dmpl__TotalTaxAmount__c;
                    }
                    if(objectAPIName == OBJECT_SALEINVOICE) {
                        newRecord.dmpl__TotalAmount__c = Double.valueOf(record.get('dmpl__TotalLineAmount__c'));
                        newRecord.dmpl__TotalTaxAmount__c = Double.valueOf(record.get('dmpl__TotalTaxAmount2__c'));
                        newRecord.dmpl__TotalSaleInvoiceAmount__c = newRecord.dmpl__TotalAmount__c + newRecord.dmpl__TotalTaxAmount__c;
                    }
                    if(objectAPIName == OBJECT_PURCHASEORDER) {
                        newRecord.dmpl__TotalAmount__c = Double.valueOf(record.get('dmpl__TotalLineAmount__c'));
                        // newRecord.dmpl__TotalTaxAmount__c = Double.valueOf(record.get('dmpl__TotalLineAmount__c'));
                        newRecord.dmpl__TotalPurchaseOrderAmount__c = newRecord.dmpl__TotalAmount__c;
                    }
                    if(objectAPIName == OBJECT_REPAIRORDER) {
                        newRecord.dmpl__TotalAmount__c = Double.valueOf(record.get('dmpl__TotalPartAmount__c')) + Double.valueOf(record.get('dmpl__TotalLabourAmount__c'));
                        newRecord.dmpl__TotalTaxAmount__c = Double.valueOf(record.get('dmpl__TotalTax__c'));
                        newRecord.dmpl__TotalRepairOrderAmount__c = newRecord.dmpl__TotalAmount__c + newRecord.dmpl__TotalTaxAmount__c;
                    }
                    if(objectAPIName == OBJECT_BILL) {
                        newRecord.dmpl__TotalAmount__c = Double.valueOf(record.get('dmpl__TotalLineAmount__c'));
                        // newRecord.dmpl__TotalTaxAmount__c = Double.valueOf(record.get('dmpl__TotalLineAmount__c'));
                        newRecord.dmpl__TotalBillAmount__c = newRecord.dmpl__TotalAmount__c;
                    }
                    upsertPerformanceKPI.add(newRecord);
                }
            }
        }
        if(upsertPerformanceKPI.size() > 0)
        {
            upsert upsertPerformanceKPI;
        }
    }

    private static Decimal getTotalQuantity(List<SObject> childRecords)
    {
        Decimal totalCount = 0;
        for(SObject childRecord : childRecords)
        {
            if(childRecord.get('dmpl__Quantity__c') != null && Double.valueOf( childRecord.get('dmpl__Quantity__c')) > 0)
                totalCount = totalCount + Double.valueOf(childRecord.get('dmpl__Quantity__c'));
        }
        return totalCount;
    }

    private static void upsertIncentivePerformanceKPIInternal(String objectAPIName, List<SObject> records)
    {
        string resourceFieldAPI = defaultResourceFieldAPIs.get(objectAPIName);
        String childRelationshipName = defaultChildRelationNames.get(objectAPIName);
        // Get Min & Max Date
        List<Date> documentDates = DocumentHelper.extractUniqueDateValues(records, FIELD_DOCUMENTDATE);
        documentDates.sort();
        Date minDate = documentDates[0];
        Date maxDate = documentDates[documentDates.size() - 1];
        List<dmpl__IncentivePeriod__c> incentivePeriods = queryIncentivePeriods(minDate, maxDate);
        // Extract Ids
        List<Id> supplierAccountIds = extractIdsIfExists(records, FIELD_SUPPLIERACCOUNTID);
        List<Id> partnerAccountIds = extractIdsIfExists(records, FIELD_PARTNERACCOUNTID);
        List<Id> accountIds = extractIdsIfExists(records, FIELD_ACCOUNTID);
        List<Id> partnerSchemeGroupIds = DocumentHelper.extractIdsFromLookup(records, (objectAPIName == OBJECT_PURCHASEORDER || objectAPIName == OBJECT_BILL) ? 'dmpl__PartnerAccountId__r' : 'dmpl__AccountId__r', 'dmpl__PartnerSchemeAccountGroupId__c');
        List<Id> incentiveIds = extractIdsIfExists(incentivePeriods, 'dmpl__IncentivePlanId__c');
        System.debug('incentiveIds ' + incentiveIds);
        
        List<dmpl__IncentivePlan__c> incentivePlans = queryIncentivePlans(supplierAccountIds, 
                                                                            partnerAccountIds, 
                                                                            accountIds, 
                                                                            partnerSchemeGroupIds, 
                                                                            incentiveIds, 
                                                                            minDate, 
                                                                            maxDate, 
                                                                            defaultIncentiveTargetType.get(objectAPIName));

        List<dmpl__PerformanceKPI__c> upsertPerformanceKPI = queryPerformanceKPIs(null, incentiveIds, supplierAccountIds, partnerAccountIds, accountIds);

        for(SObject record : records)
        {
            List<dmpl__IncentivePeriod__c> eligibleIncentivePeriods = getEligibleIncentivePeriod(incentivePeriods, record);
            System.debug('incentivePlans ' + incentivePlans);
            
            List<dmpl__IncentivePlan__c> eligibleIncentivePlans = getEligibleIncentivePlans(incentivePlans, extractIdsIfExists(eligibleIncentivePeriods, 'dmpl__IncentivePlanId__c'), record);
            List<Id> eligibleIncentiveIds = DocumentHelper.extractIds(eligibleIncentivePlans);
            Map<Id, dmpl__IncentivePlan__c> eligibleIncentivePlansMap = new Map<Id, dmpl__IncentivePlan__c>(eligibleIncentivePlans);
            Map<String, Object> recordFieldsMap = record.getPopulatedFieldsAsMap();
            System.debug('eligibleIncentiveIds ' + eligibleIncentiveIds);
            for(Id incentiveId : eligibleIncentiveIds)
            {
                System.debug('3');

                Boolean isFound = false;
                dmpl__IncentivePeriod__c incentivePeriod = (dmpl__IncentivePeriod__c)DocumentHelper.getObjectByFilter(eligibleIncentivePeriods, 'dmpl__IncentivePlanId__c', incentiveId);
                List<SObject> childRecords = (List<SObject>)recordFieldsMap.get(childRelationshipName);
                dmpl__IncentivePlan__c currentIncentivePlan = eligibleIncentivePlansMap.get(incentiveId);
                List<dmpl__IncentiveTarget__c> eligibleIncentiveTargets = eligibleIncentivePlansMap.get(incentiveId).dmpl__IncentiveTargets__r;
                List<Id> distinctItemGroupIds = DocumentHelper.extractIds(eligibleIncentiveTargets, 'dmpl__ItemGroupId__c');
                Map<Id, dmpl__ItemGroup__c> itemGroups = new Map<Id, dmpl__ItemGroup__c>(queryItemGroups(distinctItemGroupIds));
                if(eligibleIncentiveTargets.size() > 0)
                {
                    for(SObject childRecord : childRecords)
                    {
                        for(dmpl__IncentiveTarget__c incentiveTarget : eligibleIncentiveTargets)
                        {
                            Boolean isChildFound = false;
                            Boolean isChildFoundWithItem = false;
                            dmpl__ItemGroup__c currentItemGroup = incentiveTarget.dmpl__ItemGroupId__c != null ? itemGroups.get(incentiveTarget.dmpl__ItemGroupId__c) : null;
                            List<Id> groupMemberItemIds = currentItemGroup != null && currentItemGroup.dmpl__ItemGroupMembers__r != null ? DocumentHelper.extractIds(currentItemGroup.dmpl__ItemGroupMembers__r, 'dmpl__ItemId__c') : new List<Id>();
                            if(incentiveTarget.dmpl__IncentivePlanId__c == incentiveId)
                            {
                                for(dmpl__PerformanceKPI__c performanceKPI : upsertPerformanceKPI)
                                {
                                    if(performanceKPI.dmpl__IncentivePlanId__c != incentiveId
                                    && performanceKPI.dmpl__IncentivePeriodId__c != incentivePeriod.Id
                                    && performanceKPI.dmpl__IncentiveTargetId__c != incentiveTarget.Id)
                                    continue;

                                    // System.debug('upsert kpi ' + performanceKPI);
                                    if(((recordFieldsMap.containsKey(FIELD_SUPPLIERACCOUNTID) 
                                            && performanceKPI.dmpl__SupplierAccountId__c == record.get(FIELD_SUPPLIERACCOUNTID)) 
                                                || performanceKPI.dmpl__SupplierAccountId__c == null)
                                        && ((recordFieldsMap.containsKey(FIELD_PARTNERACCOUNTID) 
                                                && performanceKPI.dmpl__PartnerAccountId__c == record.get(FIELD_PARTNERACCOUNTID)) 
                                                || performanceKPI.dmpl__PartnerAccountId__c == null)
                                        && ((recordFieldsMap.containsKey(FIELD_BRANCHID) 
                                                && performanceKPI.dmpl__BranchId__c == record.get(FIELD_BRANCHID)) 
                                                || performanceKPI.dmpl__BranchId__c == null)
                                        && (((recordFieldsMap.containsKey(FIELD_ACCOUNTID) 
                                                && performanceKPI.dmpl__AccountId__c == record.get(FIELD_ACCOUNTID) 
                                                && ((incentiveTarget.dmpl__AccountId__c != null 
                                                && incentiveTarget.dmpl__AccountId__c == performanceKPI.dmpl__AccountId__c) 
                                                || incentiveTarget.dmpl__AccountId__c == null)) 
                                                ||  performanceKPI.dmpl__AccountId__c == null) 
                                                || (!recordFieldsMap.containsKey(FIELD_ACCOUNTID)))
                                        && performanceKPI.dmpl__IncentivePlanId__c == incentiveId
                                        && performanceKPI.dmpl__IncentivePeriodId__c == incentivePeriod.Id
                                        && performanceKPI.dmpl__IncentiveTargetId__c == incentiveTarget.Id
                                        && (
                                            (incentiveTarget.dmpl__ItemId__c != null 
                                            && incentiveTarget.dmpl__ItemId__c == childRecord.get(FIELD_ITEMID) 
                                            && performanceKPI.dmpl__ItemId__c == incentiveTarget.dmpl__ItemId__c) 
                                            ||
                                             (incentiveTarget.dmpl__ItemGroupId__c != null 
                                             && currentItemGroup != null
                                             && performanceKPI.dmpl__ItemId__c == childRecord.get('dmpl__ItemId__c')
                                             && groupMemberItemIds.contains((Id)childRecord.get('dmpl__ItemId__c'))
                                             )
                                            )
                                        && ((currentIncentivePlan.dmpl__MemberType__c == 'Resource' && resourceFieldAPI != null 
                                                && record.get(resourceFieldAPI) != null 
                                                && performanceKPI.dmpl__ResourceId__c == record.get(resourceFieldAPI)) 
                                                    || ( currentIncentivePlan.dmpl__MemberType__c != 'Resource' 
                                                    && performanceKPI.dmpl__ResourceId__c == null)))
                                        {
                                            isChildFoundWithItem = true;

                                            performanceKPI.dmpl__TotalQuantity__c = (performanceKPI.dmpl__TotalQuantity__c == null ? 0 : performanceKPI.dmpl__TotalQuantity__c) + Double.valueOf(childRecord.get('dmpl__Quantity__c'));
                                            performanceKPI.dmpl__TotalSaleOrderQuantity__c = (performanceKPI.dmpl__TotalSaleOrderQuantity__c == null ? 0 : performanceKPI.dmpl__TotalSaleOrderQuantity__c) + (objectAPIName == OBJECT_SALEORDER ? Double.valueOf(childRecord.get('dmpl__Quantity__c')) : 0);
                                            performanceKPI.dmpl__TotalSaleInvoiceQuantity__c = (performanceKPI.dmpl__TotalSaleInvoiceQuantity__c == null ? 0 : performanceKPI.dmpl__TotalSaleInvoiceQuantity__c) + (objectAPIName == OBJECT_SALEINVOICE ? Double.valueOf(childRecord.get('dmpl__Quantity__c')) : 0);
                                            performanceKPI.dmpl__TotalPurchaseOrderQuantity__c = (performanceKPI.dmpl__TotalPurchaseOrderQuantity__c == null ? 0 : performanceKPI.dmpl__TotalPurchaseOrderQuantity__c) + (objectAPIName == OBJECT_PURCHASEORDER ? Double.valueOf(childRecord.get('dmpl__Quantity__c')) : 0);
                                            performanceKPI.dmpl__TotalBillQuantity__c = (performanceKPI.dmpl__TotalBillQuantity__c == null ? 0 : performanceKPI.dmpl__TotalBillQuantity__c) + (objectAPIName == OBJECT_BILL ? Double.valueOf(childRecord.get('dmpl__Quantity__c')) : 0);
                                            performanceKPI.dmpl__TotalRepairOrderQuantity__c = (performanceKPI.dmpl__TotalRepairOrderQuantity__c == null ? 0 : performanceKPI.dmpl__TotalRepairOrderQuantity__c) + (objectAPIName == OBJECT_REPAIRORDER ? Double.valueOf(childRecord.get('dmpl__Quantity__c')) : 0);

                                            if(objectAPIName != OBJECT_SERVICEREQUEST && performanceKPI.dmpl__ItemId__c != null)
                                            {

                                                performanceKPI.dmpl__TotalAmount__c = (performanceKPI.dmpl__TotalAmount__c == null ? 0 : performanceKPI.dmpl__TotalAmount__c) + Double.valueOf(childRecord.get('dmpl__Amount__c'));
                                                performanceKPI.dmpl__TotalSaleOrderAmount__c = (performanceKPI.dmpl__TotalSaleOrderAmount__c == null ? 0 : performanceKPI.dmpl__TotalSaleOrderAmount__c) + (objectAPIName == OBJECT_SALEORDER ? Double.valueOf(childRecord.get('dmpl__Amount__c')) : 0);
                                                performanceKPI.dmpl__TotalSaleInvoiceAmount__c = (performanceKPI.dmpl__TotalSaleInvoiceAmount__c == null ? 0 : performanceKPI.dmpl__TotalSaleInvoiceAmount__c) + (objectAPIName == OBJECT_SALEINVOICE ? Double.valueOf(childRecord.get('dmpl__Amount__c')) : 0);
                                                performanceKPI.dmpl__TotalPurchaseOrderAmount__c = (performanceKPI.dmpl__TotalPurchaseOrderAmount__c == null ? 0 : performanceKPI.dmpl__TotalPurchaseOrderAmount__c) + (objectAPIName == OBJECT_PURCHASEORDER ? Double.valueOf(childRecord.get('dmpl__Amount__c')) : 0);
                                                performanceKPI.dmpl__TotalBillAmount__c = (performanceKPI.dmpl__TotalBillAmount__c == null ? 0 : performanceKPI.dmpl__TotalBillAmount__c) + (objectAPIName == OBJECT_BILL ? Double.valueOf(childRecord.get('dmpl__Amount__c')) : 0);
                                                performanceKPI.dmpl__TotalRepairOrderAmount__c = (performanceKPI.dmpl__TotalRepairOrderAmount__c == null ? 0 : performanceKPI.dmpl__TotalRepairOrderAmount__c) + (objectAPIName == OBJECT_REPAIRORDER ? Double.valueOf(childRecord.get('dmpl__Amount__c')) : 0);
                                            }
                                        }
                                }
                                if(!isChildFoundWithItem)
                                {
                                    System.debug('child not found with ' + isChildFoundWithItem);

                                    if(((recordFieldsMap.containsKey(FIELD_SUPPLIERACCOUNTID) && currentIncentivePlan.dmpl__SupplierAccountId__c == record.get(FIELD_SUPPLIERACCOUNTID)) || currentIncentivePlan.dmpl__SupplierAccountId__c == null)
                                    && ((recordFieldsMap.containsKey(FIELD_PARTNERACCOUNTID) && currentIncentivePlan.dmpl__PartnerAccountId__c == record.get(FIELD_PARTNERACCOUNTID)) || currentIncentivePlan.dmpl__PartnerAccountId__c == null)
                                    && ((recordFieldsMap.containsKey(FIELD_ACCOUNTID) && record.get(FIELD_ACCOUNTID) != null) && ((incentiveTarget.dmpl__AccountId__c != null && incentiveTarget.dmpl__AccountId__c == record.get(FIELD_ACCOUNTID) || incentiveTarget.dmpl__AccountId__c == null)) || (!recordFieldsMap.containsKey(FIELD_ACCOUNTID)))
                                    && currentIncentivePlan.Id == incentiveId
                                    && incentivePeriod != null
                                    && incentiveTarget != null
                                    && (
                                        (incentiveTarget.dmpl__ItemId__c != null && incentiveTarget.dmpl__ItemId__c == childRecord.get(FIELD_ITEMID)) 
                                        ||
                                        (incentiveTarget.dmpl__ItemGroupId__c != null 
                                        && currentItemGroup != null
                                        && groupMemberItemIds.contains((Id)childRecord.get('dmpl__ItemId__c'))
                                        )
                                        )
                                        )
                                    {
                                    dmpl__PerformanceKPI__c newRecord =  new dmpl__PerformanceKPI__c(
                                        dmpl__SupplierAccountId__c = recordFieldsMap.containsKey(FIELD_SUPPLIERACCOUNTID) ? (Id)record.get(FIELD_SUPPLIERACCOUNTID) : null,
                                        dmpl__PartnerAccountId__c = (Id)record.get(FIELD_PARTNERACCOUNTID),
                                        dmpl__BranchId__c = (Id)record.get(FIELD_BRANCHID),
                                        dmpl__AccountId__c = recordFieldsMap.containsKey(FIELD_ACCOUNTID) ? (Id)record.get(FIELD_ACCOUNTID) : null,
                                        dmpl__IncentivePlanId__c = incentiveId,
                                        dmpl__IncentivePeriodId__c = incentivePeriod.Id,
                                        dmpl__IncentiveTargetId__c = incentiveTarget.Id,
                                        dmpl__ResourceId__c = resourceFieldAPI != null && currentIncentivePlan.dmpl__MemberType__c == 'Resource' ? (Id)record.get(resourceFieldAPI) : null,
                                        dmpl__TotalAmount__c = Double.valueOf(childRecord.get('dmpl__Amount__c')),
                                        dmpl__TotalQuantity__c = Double.valueOf(childRecord.get('dmpl__Quantity__c')),
                                        dmpl__ItemId__c = (Id)childRecord.get(FIELD_ITEMID),
                                        dmpl__TotalSaleOrderAmount__c = objectAPIName == OBJECT_SALEORDER ? Double.valueOf(childRecord.get('dmpl__Amount__c')) : 0,
                                        dmpl__TotalSaleInvoiceAmount__c = objectAPIName == OBJECT_SALEINVOICE ? Double.valueOf(childRecord.get('dmpl__Amount__c')) : 0,
                                        dmpl__TotalPurchaseOrderAmount__c = objectAPIName == OBJECT_PURCHASEORDER ? Double.valueOf(childRecord.get('dmpl__Amount__c')) : 0,
                                        dmpl__TotalBillAmount__c = objectAPIName == OBJECT_BILL ? Double.valueOf(childRecord.get('dmpl__Amount__c')) : 0,
                                        dmpl__TotalRepairOrderAmount__c = objectAPIName == OBJECT_REPAIRORDER ? Double.valueOf(childRecord.get('dmpl__Amount__c')) : 0,
                                        dmpl__TotalSaleOrderQuantity__c = objectAPIName == OBJECT_SALEORDER ? Double.valueOf(childRecord.get('dmpl__Quantity__c')) : 0,
                                        dmpl__TotalSaleInvoiceQuantity__c = objectAPIName == OBJECT_SALEINVOICE ? Double.valueOf(childRecord.get('dmpl__Quantity__c')) : 0,
                                        dmpl__TotalPurchaseOrderQuantity__c = objectAPIName == OBJECT_PURCHASEORDER ? Double.valueOf(childRecord.get('dmpl__Quantity__c')) : 0,
                                        dmpl__TotalBillQuantity__c = objectAPIName == OBJECT_BILL ? Double.valueOf(childRecord.get('dmpl__Quantity__c')) : 0,
                                        dmpl__TotalRepairOrderQuantity__c = objectAPIName == OBJECT_REPAIRORDER ? Double.valueOf(childRecord.get('dmpl__Quantity__c')) : 0,
                                        dmpl__PostingType__c = 'KPI');
                                        upsertPerformanceKPI.add(newRecord);
                                    }
                                }
                            }
                        }
                    }
                }
                // Parent Record
                if(eligibleIncentiveTargets.size() > 0)
                {
            System.debug('4');

                    for(dmpl__IncentiveTarget__c incentiveTarget : eligibleIncentiveTargets)
                    {
                        if(incentiveTarget.dmpl__IncentivePlanId__c == incentiveId)
                        {
                            for(dmpl__PerformanceKPI__c performanceKPI : upsertPerformanceKPI)
                            {
                                if(
                                    ((recordFieldsMap.containsKey(FIELD_SUPPLIERACCOUNTID) && performanceKPI.dmpl__SupplierAccountId__c == record.get(FIELD_SUPPLIERACCOUNTID)) || performanceKPI.dmpl__SupplierAccountId__c == null)
                                    && ((recordFieldsMap.containsKey(FIELD_PARTNERACCOUNTID) && performanceKPI.dmpl__PartnerAccountId__c == record.get(FIELD_PARTNERACCOUNTID)) || performanceKPI.dmpl__PartnerAccountId__c == null)
                                    && ((recordFieldsMap.containsKey(FIELD_BRANCHID) && performanceKPI.dmpl__BranchId__c == record.get(FIELD_BRANCHID)) || performanceKPI.dmpl__BranchId__c == null)
                                    && ((recordFieldsMap.containsKey(FIELD_ACCOUNTID) && performanceKPI.dmpl__AccountId__c == record.get(FIELD_ACCOUNTID)) ||  performanceKPI.dmpl__AccountId__c == null)
                                    && performanceKPI.dmpl__IncentivePlanId__c == incentiveId
                                    && performanceKPI.dmpl__IncentivePeriodId__c == incentivePeriod.Id
                                    && performanceKPI.dmpl__IncentiveTargetId__c == incentiveTarget.Id
                                    && performanceKPI.dmpl__ItemId__c == null
                                    && ((currentIncentivePlan.dmpl__MemberType__c == 'Resource' && resourceFieldAPI != null && record.get(resourceFieldAPI) != null && performanceKPI.dmpl__ResourceId__c == record.get(resourceFieldAPI)) || ( currentIncentivePlan.dmpl__MemberType__c != 'Resource' && performanceKPI.dmpl__ResourceId__c == null)))
                                {
                                    isFound = true;
                                    Decimal totalQuantity = getTotalQuantity(childRecords);
                                    performanceKPI.dmpl__TotalQuantity__c = (performanceKPI.dmpl__TotalQuantity__c == null ? 0 : performanceKPI.dmpl__TotalQuantity__c) + totalQuantity;
                                    performanceKPI.dmpl__TotalSaleOrderQuantity__c = (performanceKPI.dmpl__TotalSaleOrderQuantity__c == null 
                                                                                        ? 0 : performanceKPI.dmpl__TotalSaleOrderQuantity__c) 
                                                                                        + (objectAPIName == OBJECT_SALEORDER ? totalQuantity : 0);
                                    performanceKPI.dmpl__TotalSaleInvoiceQuantity__c = (performanceKPI.dmpl__TotalSaleInvoiceQuantity__c == null 
                                                                                        ? 0 : performanceKPI.dmpl__TotalSaleInvoiceQuantity__c)
                                                                                        + (objectAPIName == OBJECT_SALEINVOICE ? totalQuantity : 0);
                                    performanceKPI.dmpl__TotalPurchaseOrderQuantity__c = (performanceKPI.dmpl__TotalPurchaseOrderQuantity__c == null 
                                                                                            ? 0 : performanceKPI.dmpl__TotalPurchaseOrderQuantity__c)
                                                                                            + (objectAPIName == OBJECT_PURCHASEORDER ? totalQuantity : 0);
                                    performanceKPI.dmpl__TotalBillQuantity__c = (performanceKPI.dmpl__TotalBillQuantity__c == null 
                                                                                    ? 0 : performanceKPI.dmpl__TotalBillQuantity__c)
                                                                                    + (objectAPIName == OBJECT_BILL ? totalQuantity : 0);
                                    performanceKPI.dmpl__TotalRepairOrderQuantity__c = (performanceKPI.dmpl__TotalRepairOrderQuantity__c == null 
                                                                                        ? 0 : performanceKPI.dmpl__TotalRepairOrderQuantity__c)
                                                                                        + (objectAPIName == OBJECT_REPAIRORDER ? totalQuantity : 0);
                                    if(objectAPIName == OBJECT_SALEORDER)
                                    {
                                        performanceKPI.dmpl__NumberOfOrders__c = (performanceKPI.dmpl__NumberOfOrders__c == null ? 0 : performanceKPI.dmpl__NumberOfOrders__c) + 1;
                                        performanceKPI.dmpl__TotalAmount__c = performanceKPI.dmpl__TotalAmount__c + Double.valueOf(record.get('dmpl__LineSubTotal__c'));
                                        performanceKPI.dmpl__TotalTaxAmount__c = (performanceKPI.dmpl__TotalTaxAmount__c == null ? 0 : performanceKPI.dmpl__TotalTaxAmount__c)  + Double.valueOf(record.get('dmpl__TotalTaxAmount2__c'));
                                        performanceKPI.dmpl__TotalSaleOrderAmount__c = performanceKPI.dmpl__TotalSaleOrderAmount__c + Double.valueOf(record.get('dmpl__LineSubTotal__c')) + Double.valueOf(record.get('dmpl__TotalTaxAmount2__c'));
                                    }
                                    if(objectAPIName == OBJECT_SALEINVOICE)
                                    {
                                        performanceKPI.dmpl__NumberOfInvoices__c = (performanceKPI.dmpl__NumberOfInvoices__c == null ? 0 : performanceKPI.dmpl__NumberOfInvoices__c) + 1;
                                        performanceKPI.dmpl__TotalAmount__c = performanceKPI.dmpl__TotalAmount__c + Double.valueOf(record.get('dmpl__TotalAmount__c'));
                                        performanceKPI.dmpl__TotalTaxAmount__c = performanceKPI.dmpl__TotalTaxAmount__c + Double.valueOf(record.get('dmpl__TotalTaxAmount2__c'));
                                        performanceKPI.dmpl__TotalSaleInvoiceAmount__c = performanceKPI.dmpl__TotalSaleInvoiceAmount__c + Double.valueOf(record.get('dmpl__TotalLineAmount__c')) + Double.valueOf(record.get('dmpl__TotalTaxAmount2__c'));
                                    }
                                    if(objectAPIName == OBJECT_SERVICEREQUEST)
                                    {
                                        performanceKPI.dmpl__NumberOfServiceRequests__c = (performanceKPI.dmpl__NumberOfServiceRequests__c == null ? 0 : performanceKPI.dmpl__NumberOfServiceRequests__c) + 1;
                                    }
                                    if(objectAPIName == OBJECT_REPAIRORDER)
                                    {
                                        performanceKPI.dmpl__NumberOfRepairOrders__c = (performanceKPI.dmpl__NumberOfRepairOrders__c == null ? 0 : performanceKPI.dmpl__NumberOfRepairOrders__c) + 1;
                                        performanceKPI.dmpl__TotalAmount__c = performanceKPI.dmpl__TotalAmount__c + Double.valueOf(record.get('dmpl__TotalPartAmount__c')) + Double.valueOf(record.get('dmpl__TotalLabourAmount__c')) + Double.valueOf(record.get('dmpl__TotalTax__c'));
                                        performanceKPI.dmpl__TotalTaxAmount__c = performanceKPI.dmpl__TotalTaxAmount__c + Double.valueOf(record.get('dmpl__TotalTax__c'));
                                        performanceKPI.dmpl__TotalRepairOrderAmount__c = performanceKPI.dmpl__TotalRepairOrderAmount__c + Double.valueOf(record.get('dmpl__TotalPartAmount__c')) + Double.valueOf(record.get('dmpl__TotalLabourAmount__c')) + Double.valueOf(record.get('dmpl__TotalTax__c'));
                                    }
                                    if(objectAPIName == OBJECT_PURCHASEORDER)
                                    {
                                        performanceKPI.dmpl__NumberOfPurchaseOrders__c = (performanceKPI.dmpl__NumberOfPurchaseOrders__c == null ? 0 : performanceKPI.dmpl__NumberOfPurchaseOrders__c)+ 1;
                                        performanceKPI.dmpl__TotalAmount__c = performanceKPI.dmpl__TotalAmount__c + Double.valueOf(record.get('dmpl__TotalAmount__c'));
                                        // performanceKPI.dmpl__TotalTaxAmount__c = performanceKPI.dmpl__TotalTaxAmount__c + Double.valueOf(record.get('dmpl__TotalTaxAmount2__c'));
                                        performanceKPI.dmpl__TotalPurchaseOrderAmount__c = performanceKPI.dmpl__TotalSaleInvoiceAmount__c + Double.valueOf(record.get('dmpl__TotalLineAmount__c'));
                                    }
                                    if(objectAPIName == OBJECT_BILL)
                                    {
                                        performanceKPI.dmpl__NumberOfBills__c = (performanceKPI.dmpl__NumberOfBills__c == null ? 0 : performanceKPI.dmpl__NumberOfBills__c) + 1;
                                        performanceKPI.dmpl__TotalAmount__c = performanceKPI.dmpl__TotalAmount__c + Double.valueOf(record.get('dmpl__TotalLineAmount__c'));
                                        // performanceKPI.dmpl__TotalTaxAmount__c = performanceKPI.dmpl__TotalTaxAmount__c + Double.valueOf(record.get('dmpl__TotalLineAmount__c'));
                                        performanceKPI.dmpl__TotalBillAmount__c = performanceKPI.dmpl__TotalRepairOrderAmount__c + Double.valueOf(record.get('dmpl__TotalLineAmount__c'));
                                    }
                                }
                            }
                            if(!isFound)
                            {
                                dmpl__PerformanceKPI__c newRecord =  new dmpl__PerformanceKPI__c(
                                    dmpl__SupplierAccountId__c = recordFieldsMap.containsKey(FIELD_SUPPLIERACCOUNTID) ? (Id)record.get(FIELD_SUPPLIERACCOUNTID) : null,
                                    dmpl__PartnerAccountId__c = (Id)record.get(FIELD_PARTNERACCOUNTID),
                                    dmpl__BranchId__c = (Id)record.get(FIELD_BRANCHID),
                                    dmpl__AccountId__c = recordFieldsMap.containsKey(FIELD_ACCOUNTID) ? (Id)record.get(FIELD_ACCOUNTID) : null,
                                    dmpl__IncentivePlanId__c = incentiveId,
                                    dmpl__IncentivePeriodId__c = incentivePeriod.Id,
                                    dmpl__IncentiveTargetId__c = incentiveTarget.Id,
                                    dmpl__ResourceId__c = resourceFieldAPI != null && currentIncentivePlan.dmpl__MemberType__c == 'Resource' ? (Id)record.get(resourceFieldAPI) : null,
                                    dmpl__NumberOfInvoices__c = objectAPIName == OBJECT_SALEINVOICE ? 1 : 0,
                                    dmpl__NumberOfOrders__c = objectAPIName == OBJECT_SALEORDER ? 1 : 0,
                                    dmpl__NumberOfRepairOrders__c = objectAPIName == OBJECT_REPAIRORDER ? 1 : 0,
                                    dmpl__NumberOfPurchaseOrders__c = objectAPIName == OBJECT_PURCHASEORDER ? 1 : 0,
                                    dmpl__NumberOfServiceRequests__c = objectAPIName == OBJECT_SERVICEREQUEST ? 1 : 0,
                                    dmpl__NumberOfBills__c = objectAPIName == OBJECT_BILL ? 1 : 0,
                                    dmpl__TotalQuantity__c = getTotalQuantity(childRecords),
                                    dmpl__TotalSaleOrderQuantity__c = objectAPIName == OBJECT_SALEORDER ? getTotalQuantity(childRecords) : 0,
                                    dmpl__TotalSaleInvoiceQuantity__c = objectAPIName == OBJECT_SALEINVOICE ? getTotalQuantity(childRecords) : 0,
                                    dmpl__TotalPurchaseOrderQuantity__c = objectAPIName == OBJECT_PURCHASEORDER ? getTotalQuantity(childRecords) : 0,
                                    dmpl__TotalBillQuantity__c = objectAPIName == OBJECT_BILL ? getTotalQuantity(childRecords) : 0,
                                    dmpl__TotalRepairOrderQuantity__c = objectAPIName == OBJECT_REPAIRORDER ? getTotalQuantity(childRecords) : 0,
                                    dmpl__PostingType__c = 'KPI');

                                if(objectAPIName == OBJECT_SALEORDER)  {
                                    newRecord.dmpl__TotalAmount__c = Double.valueOf(record.get('dmpl__LineSubTotal__c'));
                                    newRecord.dmpl__TotalTaxAmount__c = Double.valueOf(record.get('dmpl__TotalTaxAmount2__c'));
                                    newRecord.dmpl__TotalSaleOrderAmount__c = newRecord.dmpl__TotalAmount__c + newRecord.dmpl__TotalTaxAmount__c;
                                }
                                if(objectAPIName == OBJECT_SALEINVOICE) {
                                    newRecord.dmpl__TotalAmount__c = Double.valueOf(record.get('dmpl__TotalLineAmount__c'));
                                    newRecord.dmpl__TotalTaxAmount__c = Double.valueOf(record.get('dmpl__TotalTaxAmount2__c'));
                                    newRecord.dmpl__TotalSaleInvoiceAmount__c = newRecord.dmpl__TotalAmount__c + newRecord.dmpl__TotalTaxAmount__c;
                                }
                                if(objectAPIName == OBJECT_PURCHASEORDER) {
                                    newRecord.dmpl__TotalAmount__c = Double.valueOf(record.get('dmpl__TotalLineAmount__c'));
                                    // newRecord.dmpl__TotalTaxAmount__c = Double.valueOf(record.get('dmpl__TotalLineAmount__c'));
                                    newRecord.dmpl__TotalPurchaseOrderAmount__c = newRecord.dmpl__TotalAmount__c;
                                }
                                if(objectAPIName == OBJECT_REPAIRORDER) {
                                    newRecord.dmpl__TotalAmount__c = Double.valueOf(record.get('dmpl__TotalPartAmount__c')) + Double.valueOf(record.get('dmpl__TotalLabourAmount__c'));
                                    newRecord.dmpl__TotalTaxAmount__c = Double.valueOf(record.get('dmpl__TotalTax__c'));
                                    newRecord.dmpl__TotalRepairOrderAmount__c = newRecord.dmpl__TotalAmount__c + newRecord.dmpl__TotalTaxAmount__c;
                                }
                                if(objectAPIName == OBJECT_BILL) {
                                    newRecord.dmpl__TotalAmount__c = Double.valueOf(record.get('dmpl__TotalLineAmount__c'));
                                    // newRecord.dmpl__TotalTaxAmount__c = Double.valueOf(record.get('dmpl__TotalLineAmount__c'));
                                    newRecord.dmpl__TotalBillAmount__c = newRecord.dmpl__TotalAmount__c;
                                }
                                upsertPerformanceKPI.add(newRecord);
                            }
                        }
                    }
                }
            }
        }
        if(upsertPerformanceKPI.size() > 0)
        {
            upsert upsertPerformanceKPI;
        }
    }

    private static List<dmpl__SchemePeriod__c> getEligibleSchemePeriod(List<dmpl__SchemePeriod__c> existingSchemePeriods, SObject currentSaleOrder)
    {
        List<dmpl__SchemePeriod__c> result = new List<dmpl__SchemePeriod__c>();
        for(dmpl__SchemePeriod__c schemePeriod : existingSchemePeriods)
        {
            if((schemePeriod.dmpl__DateFrom__c <= Date.valueOf(currentSaleOrder.get(FIELD_DOCUMENTDATE)) || schemePeriod.dmpl__DateFrom__c == null) 
            && (schemePeriod.dmpl__DateTo__c >= Date.valueOf(currentSaleOrder.get(FIELD_DOCUMENTDATE)) || schemePeriod.dmpl__DateTo__c == null))
                result.add(schemePeriod);
        }
        return result;
    }

    @testVisible
    private static List<dmpl__IncentivePeriod__c> getEligibleIncentivePeriod(List<dmpl__IncentivePeriod__c> existingIncentivePeriods, SObject currentSaleOrder)
    {
        List<dmpl__IncentivePeriod__c> result = new List<dmpl__IncentivePeriod__c>();
        for(dmpl__IncentivePeriod__c incentivePeriod : existingIncentivePeriods)
        {
            if((incentivePeriod.dmpl__DateFrom__c <= Date.valueOf(currentSaleOrder.get(FIELD_DOCUMENTDATE)) || incentivePeriod.dmpl__DateFrom__c == null) 
            && (incentivePeriod.dmpl__DateTo__c >= Date.valueOf(currentSaleOrder.get(FIELD_DOCUMENTDATE)) || incentivePeriod.dmpl__DateTo__c == null))
                result.add(incentivePeriod);
        }
        return result;
    }

    private static List<dmpl__SchemeLine__c> getEligibleSchemeLines(List<dmpl__SchemeLine__c> existingSchemeLines, List<Id> schemeIds, SObject currentRecord)
    {
        List<dmpl__SchemeLine__c> result = new List<dmpl__SchemeLine__c>();
        for(Id schemeId : schemeIds)
        {
            for(dmpl__SchemeLine__c schemeLine : existingSchemeLines)
            {
                Map<String, Object> currentRecordFields = currentRecord.getPopulatedFieldsAsMap();
                if(schemeLine.dmpl__SchemeId__c == schemeId 
                && ((currentRecordFields.containsKey(FIELD_SUPPLIERACCOUNTID) && schemeLine.dmpl__SchemeId__r.dmpl__SupplierAccountId__c == (Id)currentRecord.get(FIELD_SUPPLIERACCOUNTID))|| schemeLine.dmpl__SchemeId__r.dmpl__SupplierAccountId__c == null)
                && (schemeLine.dmpl__SchemeId__r.dmpl__PartnerAccountId__c == (Id)currentRecord.get(FIELD_PARTNERACCOUNTID) || schemeLine.dmpl__SchemeId__r.dmpl__PartnerAccountId__c == null)
                && (schemeLine.dmpl__SchemeId__r.dmpl__BranchId__c == (Id)currentRecord.get(FIELD_BRANCHID) || schemeLine.dmpl__SchemeId__r.dmpl__BranchId__c == null)
                && (schemeLine.dmpl__SchemeId__r.dmpl__ValidFrom__c <= Date.valueOf(currentRecord.get(FIELD_DOCUMENTDATE)) || schemeLine.dmpl__SchemeId__r.dmpl__ValidFrom__c == null)
                && (schemeLine.dmpl__SchemeId__r.dmpl__ValidTo__c >= Date.valueOf(currentRecord.get(FIELD_DOCUMENTDATE)) || schemeLine.dmpl__SchemeId__r.dmpl__ValidTo__c == null))
                    result.add(schemeLine);
            }
        }
        return result;
    }

    @testVisible
    private static List<dmpl__IncentivePlan__c> getEligibleIncentivePlans(List<dmpl__IncentivePlan__c> existingIncentivePlans, List<Id> incentiveIds, SObject currentRecord)
    {
        List<dmpl__IncentivePlan__c> result = new List<dmpl__IncentivePlan__c>();
        for(Id incentiveId : incentiveIds)
        {
            for(dmpl__IncentivePlan__c incentivePlan : existingIncentivePlans)
            {
                Map<String, Object> currentRecordFields = currentRecord.getPopulatedFieldsAsMap();
                if(incentivePlan.Id == incentiveId 
                && ((currentRecordFields.containsKey(FIELD_SUPPLIERACCOUNTID) && incentivePlan.dmpl__SupplierAccountId__c == (Id)currentRecord.get(FIELD_SUPPLIERACCOUNTID))|| incentivePlan.dmpl__SupplierAccountId__c == null)
                && (incentivePlan.dmpl__PartnerAccountId__c == (Id)currentRecord.get(FIELD_PARTNERACCOUNTID) || incentivePlan.dmpl__PartnerAccountId__c == null)
                && (incentivePlan.dmpl__BranchId__c == (Id)currentRecord.get(FIELD_BRANCHID) || incentivePlan.dmpl__BranchId__c == null)
                && (incentivePlan.dmpl__ValidFrom__c <= Date.valueOf(currentRecord.get(FIELD_DOCUMENTDATE)) || incentivePlan.dmpl__ValidFrom__c == null)
                && (incentivePlan.dmpl__ValidTo__c >= Date.valueOf(currentRecord.get(FIELD_DOCUMENTDATE)) || incentivePlan.dmpl__ValidTo__c == null))
                {
                    result.add(incentivePlan);
                }
            }
        }
        return result;
    }

    private static List<dmpl__PerformanceKPI__c> queryPerformanceKPIs(List<Id> schemeIds, List<Id> incentiveIds, List<Id> supplierAccountIds, List<Id> partnerAccountIds, List<Id> accountIds)
    {
        if(schemeIds == null)
            schemeIds = new List<Id>();
        if(incentiveIds == null)
            incentiveIds = new List<Id>();

        SecurityHelper.ensureCanReadFields(new string[]
        {
            'dmpl__SupplierAccountId__c',
            'dmpl__AccountId__c',
            'dmpl__BranchId__c',
            'dmpl__IncentivePlanId__c',
            'dmpl__IncentiveTargetId__c',
            'dmpl__NumberOfInvoices__c',
            'dmpl__NumberOfLeads__c',
            'dmpl__NumberOfOrders__c',
            'dmpl__NumberOfPurchaseOrders__c',
            'dmpl__NumberOfRepairOrders__c',
            'dmpl__NumberOfBills__c',
            'dmpl__NumberOfServiceRequests__c',
            'dmpl__PartnerAccountId__c',
            'dmpl__ResourceId__c',
            'dmpl__SchemeId__c',
            'dmpl__TotalAmount__c',
            'dmpl__TotalQuantity__c',
            'dmpl__ItemId__c',
            'dmpl__ResourceId__c',
            'dmpl__SchemePeriodId__c',
            'dmpl__TotalTaxAmount__c',
            'dmpl__TotalSaleInvoiceAmount__c',
            'dmpl__TotalSaleOrderAmount__c',
            'dmpl__TotalRepairOrderAmount__c',
            'dmpl__TotalPurchaseOrderAmount__c',
            'dmpl__TotalBillAmount__c',
            'dmpl__TotalSaleInvoiceQuantity__c',
            'dmpl__TotalSaleOrderQuantity__c',
            'dmpl__TotalRepairOrderQuantity__c',
            'dmpl__TotalPurchaseOrderQuantity__c',
            'dmpl__TotalBillQuantity__c'
        }, 'dmpl__PerformanceKPI__c');
        return [SELECT
            dmpl__SupplierAccountId__c,
            dmpl__AccountId__c,
            dmpl__BranchId__c,
            dmpl__IncentivePlanId__c,
            dmpl__IncentivePeriodId__c,
            dmpl__IncentiveTargetId__c,
            dmpl__NumberOfInvoices__c,
            dmpl__NumberOfLeads__c,
            dmpl__NumberOfOrders__c,
            dmpl__NumberOfPurchaseOrders__c,
            dmpl__NumberOfRepairOrders__c,
            dmpl__NumberOfBills__c,
            dmpl__NumberOfServiceRequests__c,
            dmpl__PartnerAccountId__c,
            dmpl__ResourceId__c,
            dmpl__SchemeId__c,
            dmpl__SchemePeriodId__c,
            dmpl__TotalAmount__c,
            dmpl__TotalQuantity__c,
            dmpl__ItemId__c,
            dmpl__ItemId__r.dmpl__SchemeItemGroupId__c,
            dmpl__TotalTaxAmount__c,
            dmpl__TotalSaleInvoiceAmount__c,
            dmpl__TotalSaleOrderAmount__c,
            dmpl__TotalRepairOrderAmount__c,
            dmpl__TotalPurchaseOrderAmount__c,
            dmpl__TotalBillAmount__c,
            dmpl__TotalSaleInvoiceQuantity__c,
            dmpl__TotalSaleOrderQuantity__c,
            dmpl__TotalRepairOrderQuantity__c,
            dmpl__TotalPurchaseOrderQuantity__c,
            dmpl__TotalBillQuantity__c,
            Id,
            Name
        FROM
            dmpl__PerformanceKPI__c
        WHERE
            (dmpl__SchemeId__c IN : schemeIds OR dmpl__IncentivePlanId__c IN : incentiveIds)
            AND (dmpl__PartnerAccountId__c IN : partnerAccountIds OR dmpl__PartnerAccountId__c = null)
            AND (dmpl__AccountId__c IN : accountIds OR dmpl__AccountId__c = null)
            AND (dmpl__SupplierAccountId__c IN : supplierAccountIds OR dmpl__SupplierAccountId__c = null)
            AND dmpl__PostingType__c = 'KPI'];
    }

    public static List<ID> extractIdsIfExists(List<SObject> records, string fieldName)
    {
        List<ID> resultIds = new List<ID>();
        for(SObject record : records){
            Map<String, Object> recordFields = record.getPopulatedFieldsAsMap();
            if(recordFields.containsKey(fieldName) && record.get(fieldName) != null && !resultIds.contains((ID)record.get(fieldName))){
                resultIds.Add((ID)record.get(fieldName));
            }
        }
        return resultIds;
    }

    private static List<dmpl__SchemePeriod__c> querySchemePeriods(Date minDate, Date maxDate)
    {
        SecurityHelper.ensureCanReadFields(new string[]
        {
            'dmpl__DateFrom__c',
            'dmpl__DateTo__c',
            'dmpl__SchemeId__c',
            'dmpl__Status__c'
        }, 'dmpl__SchemePeriod__c');
        SecurityHelper.ensureCanReadFields(new string[]
        {
            'dmpl__SchemeType__c'
        }, 'dmpl__Scheme__c');
        return [SELECT Id, Name, dmpl__DateFrom__c, dmpl__DateTo__c, dmpl__SchemeId__c, dmpl__Status__c FROM dmpl__SchemePeriod__c WHERE dmpl__DateFrom__c <= : minDate AND dmpl__DateTo__c >= : maxDate 
        // AND dmpl__SchemeId__r.dmpl__SchemeType__c = : schemeType 
        AND dmpl__SchemeId__r.dmpl__Status__c = 'Approved' ORDER BY dmpl__DateFrom__c];
    }

    private static List<dmpl__IncentivePeriod__c> queryIncentivePeriods(Date minDate, Date maxDate)
    {
        SecurityHelper.ensureCanReadFields(new string[]
        {
            'dmpl__DateFrom__c',
            'dmpl__DateTo__c',
            'dmpl__IncentivePlanId__c',
            'dmpl__Status__c'
        }, 'dmpl__IncentivePeriod__c');
       
        return [SELECT Id, Name, dmpl__DateFrom__c, dmpl__DateTo__c, dmpl__IncentivePlanId__c, dmpl__Status__c FROM dmpl__IncentivePeriod__c 
        WHERE  
        dmpl__IncentivePlanId__r.dmpl__Status__c = 'Approved'
        AND
        dmpl__DateFrom__c <= : minDate AND dmpl__DateTo__c >= : maxDate ORDER BY dmpl__DateFrom__c
        ];
    }

    private static List<dmpl__SchemeLine__c> queryActiveSchemeLines(
        List<Id> supplierAccountIds,
        List<Id> partnerAccountIds,
        List<Id> accountIds,
        List<Id> accountGroupIds,
        Date minDate,
        Date maxDate
    ){
        
        SecurityHelper.ensureCanReadFields(new string[]
        {
            'dmpl__SchemeType__c',
            'dmpl__PeriodType__c',
            'dmpl__MultipleFulfilmentTreatment__c'
        }, 'dmpl__Scheme__c');
        SecurityHelper.ensureCanReadFields(new string[]
            {
                'dmpl__DefinitionFilterCriteria__c',
                'dmpl__DefinitionCustomLogic__c',
                'dmpl__RewardApplicability__c'
            }, 'dmpl__SchemeLine__c');
            SecurityHelper.ensureCanReadFields(new string[]
            {
                'dmpl__ConditionType__c',
                'dmpl__ConditionOperator__c',
                'dmpl__AccountId__c',
                'dmpl__AccountGroupId__c',
                'dmpl__ItemId__c',
                'dmpl__ItemGroupId__c',
                'dmpl__ConditionQuantity__c',
                'dmpl__ConditionValue__c',
                'dmpl__SequenceNumber__c'
            }, 'dmpl__SchemeCondition__c');
            SecurityHelper.ensureCanReadFields(new string[]
            {
                'dmpl__SchemeLineId__c',
                'dmpl__DiscountAmount__c',
                'dmpl__DiscountPercent__c',
                'dmpl__DiscountedItemId__c',
                'dmpl__DiscountedItemSKUId__c',
                'dmpl__DiscountedItemGroupId__c',
                'dmpl__DiscountedItemQuantity__c',
                'dmpl__RewardPoints__c',
                'dmpl__RewardType__c',
                'dmpl__RepeatReward__c',
                'dmpl__ExcludeQualifyingItems__c',
                'dmpl__SequenceNumber__c'
            }, 'dmpl__SchemeBenefit__c');
            
        return 
        [
            SELECT
            Id,
            Name,
            dmpl__DefinitionFilterCriteria__c,
            dmpl__DefinitionCustomLogic__c,
            dmpl__RewardApplicability__c,
            dmpl__SchemeId__r.Id,
            dmpl__SchemeId__r.Name,
            dmpl__SchemeId__r.dmpl__SchemeType__c,
            dmpl__SchemeId__r.dmpl__PeriodType__c,
            dmpl__SchemeId__r.dmpl__MultipleFulfilmentTreatment__c,
            dmpl__SchemeId__r.dmpl__PartnerAccountId__c,
            dmpl__SchemeId__r.dmpl__SupplierAccountId__c,
            dmpl__SchemeId__r.dmpl__BranchId__c,
            dmpl__SchemeId__r.dmpl__ValidFrom__c,
            dmpl__SchemeId__r.dmpl__ValidTo__c,
            (
                SELECT 
                Id,
                Name,
                dmpl__ConditionType__c,
                dmpl__ConditionOperator__c,
                dmpl__AccountId__c,
                dmpl__AccountGroupId__c,
                dmpl__ItemId__c,
                dmpl__ItemId__r.dmpl__SchemeItemGroupId__c,
                dmpl__ItemSKUId__c,
                dmpl__ItemSKUId__r.Name,
                dmpl__ConditionQuantity__c,
                dmpl__ConditionValue__c,
                dmpl__ItemGroupId__c
            FROM 
                dmpl__SchemeConditions__r
            WHERE 
                (dmpl__PartnerAccountId__c = NULL OR dmpl__PartnerAccountId__c IN : partnerAccountIds)
                AND (dmpl__AccountId__c = NULL OR dmpl__AccountId__c IN : accountIds)
                AND (dmpl__AccountGroupId__c = NULL OR dmpl__AccountGroupId__c IN: accountGroupIds)
            ORDER BY dmpl__SequenceNumber__c ASC
                ),
            (
                SELECT
                Id,
                dmpl__SchemeLineId__c,
                Name,
                dmpl__DiscountAmount__c,
                dmpl__DiscountPercent__c,
                dmpl__DiscountedItemId__c,
                dmpl__DiscountedItemId__r.Name,
                dmpl__DiscountedItemSKUId__c,
                dmpl__DiscountedItemSKUId__r.Name,
                dmpl__DiscountedItemGroupId__c,
                dmpl__DiscountedItemGroupId__r.Name,
                dmpl__DiscountedItemQuantity__c,
                dmpl__RewardPoints__c,
                dmpl__RewardType__c,
                dmpl__RepeatReward__c,
                dmpl__ExcludeQualifyingItems__c,
                dmpl__DiscountedItemRanking__c
                FROM 
                    dmpl__SchemeBenefits__r
                ORDER BY dmpl__SequenceNumber__c ASC
            )
            FROM 
                dmpl__SchemeLine__c
            WHERE
                dmpl__SchemeId__c IN 
                (SELECT
                    Id
                FROM 
                    dmpl__Scheme__c
                WHERE
                    (dmpl__SupplierAccountId__c = NULL OR dmpl__SupplierAccountId__c IN: supplierAccountIds)
                    AND (dmpl__PartnerAccountId__c = NULL OR dmpl__PartnerAccountId__c IN: partnerAccountIds)
                    AND (dmpl__ValidFrom__c <= : minDate OR dmpl__ValidFrom__c = null)
                    AND (dmpl__ValidTo__c >= : maxDate OR dmpl__ValidTo__c = NULL)
                    AND dmpl__Status__c = :STATUS_APPROVED
                    // AND Id IN : eligibleSchemeIds
                    )
            ORDER BY 
                dmpl__SequenceNumber__c ASC
        ];
    }

    private static List<dmpl__IncentivePlan__c> queryIncentivePlans(
        List<Id> supplierAccountIds,
        List<Id> partnerAccountIds,
        List<Id> accountIds,
        List<Id> accountGroupIds,
        List<Id> eligibleIncentiveIds,
        Date minDate,
        Date maxDate,
        List<String> targetType
    )
    {
        return 
        [
            SELECT
            Id,
            Name,
            dmpl__SupplierAccountId__c,
            dmpl__PartnerAccountId__c,
            dmpl__BranchId__c,
            dmpl__ValidFrom__c,
            dmpl__ValidTo__c,
            dmpl__MemberType__c,
                (
                    SELECT
                        dmpl__AccountId__c,
                        dmpl__CustomKPIFieldName__c,
                        dmpl__FinancerId__c,
                        dmpl__FinancerSchemeId__c,
                        dmpl__IncentivePeriodId__c,
                        dmpl__IncentivePlanId__c,
                        //dmpl__IncentivePlanLineId__c,
                        dmpl__IncentiveResourceId__c,
                        dmpl__IncentiveTargetType__c,
                        dmpl__InsuranceSchemeId__c,
                        dmpl__InsurerId__c,
                        dmpl__ItemId__c,
                        dmpl__ItemId__r.dmpl__SchemeItemGroupId__c,
                        dmpl__ServiceContractId__c,
                        dmpl__SKUId__c,
                        dmpl__TargetType__c,
                        dmpl__Value__c,
                        Id,
                        Name,
                        dmpl__ItemGroupId__c
                    FROM
                        dmpl__IncentiveTargets__r
                    WHERE
                        (dmpl__AccountId__c IN : accountIds OR dmpl__AccountId__c IN : partnerAccountIds OR dmpl__AccountId__c = null)
                        // AND (dmpl__IncentiveTargetType__c IN : targetType OR dmpl__IncentiveTargetType__c = null)
                )
            FROM 
                dmpl__IncentivePlan__c
                WHERE 
                (dmpl__SupplierAccountId__c = NULL OR dmpl__SupplierAccountId__c IN: supplierAccountIds)
                AND (dmpl__PartnerAccountId__c = NULL OR dmpl__PartnerAccountId__c IN: partnerAccountIds)
                AND (dmpl__ValidFrom__c <= : minDate OR dmpl__ValidFrom__c = null)
                AND (dmpl__ValidTo__c >= : maxDate OR dmpl__ValidTo__c = NULL)
                AND dmpl__Status__c = :STATUS_APPROVED
                AND Id IN : eligibleIncentiveIds
        ];
    }

    private static List<dmpl__SaleOrder__c> querySaleOrders(List<String> saleOrderIds)
    {
        SecurityHelper.ensureCanReadFields(new string[]
        {
            'dmpl__AccountId__c',
            'dmpl__AmountPaid__c',
            'dmpl__BranchId__c',
            'dmpl__Discount__c',
            'dmpl__DiscountGroupId__c',
            'dmpl__DocumentDate__c',
            'dmpl__OutstandingAmount__c',
            'dmpl__PartnerAccountId__c',
            'dmpl__PriceListId__c',
            'dmpl__PromisedDate__c',
            'dmpl__RequiredDate__c',
            'dmpl__Status__c',
            'dmpl__TotalCreditAmount__c',
            'dmpl__TotalOrderAmount__c',
            'dmpl__TotalTaxAmount2__c',
            'dmpl__SalesExecutiveId__c',
            'dmpl__LineSubTotal__c'
        }, 'dmpl__SaleOrder__c');
        SecurityHelper.ensureCanReadFields(new string[]
        {
            'dmpl__PartnerSchemeAccountGroupId__c'
        }, 'Account');
        SecurityHelper.ensureCanReadFields(new string[]
        {
            'dmpl__ItemId__c',
            'dmpl__SKUId__c',
            'dmpl__Quantity__c'
        }, 'dmpl__SaleOrderLine__c');
        return [
            SELECT
            dmpl__AccountId__c,
            dmpl__AccountId__r.dmpl__PartnerSchemeAccountGroupId__c,
            dmpl__AmountPaid__c,
            dmpl__BranchId__c,
            dmpl__Discount__c,
            dmpl__DiscountGroupId__c,
            dmpl__DocumentDate__c,
            dmpl__OutstandingAmount__c,
            dmpl__PartnerAccountId__c,
            dmpl__PriceListId__c,
            dmpl__PromisedDate__c,
            dmpl__RequiredDate__c,
            dmpl__Status__c,
            dmpl__TotalCreditAmount__c,
            dmpl__TotalOrderAmount__c,
            dmpl__TotalTaxAmount__c,
            dmpl__TotalTaxAmount2__c,
            dmpl__SalesExecutiveId__c,
            dmpl__LineSubTotal__c,
            Id,
            Name,
            (
                SELECT
                    Id,
                    Name,
                    dmpl__ItemId__c,
                    dmpl__ItemId__r.dmpl__SchemeItemGroupId__c,
                    dmpl__SKUId__c,
                    dmpl__Quantity__c,
                    dmpl__Amount__c
                FROM
                    dmpl__SaleOrderLines__r
            )
        FROM
            dmpl__SaleOrder__c
        WHERE 
            Id IN : saleOrderIds
        ];
    }

    private static List<dmpl__SaleInvoice__c> querySaleInvoices(List<String> saleInvoiceIds)
    {
        SecurityHelper.ensureCanReadFields(new string[]
        {
            'dmpl__AccountId__c',
            'dmpl__AmountPaid__c',
            'dmpl__BranchId__c',
            'dmpl__PartnerAccountId__c',
            'dmpl__SupplierAccountId__c',
            'dmpl__TotalAmount__c',
            'dmpl__TotalCreditAmount__c',
            'dmpl__TotalLineAmount__c',
            'dmpl__TotalSchemeDiscountAmount__c',
            'dmpl__TotalTaxAmount__c',
            'dmpl__DocumentDate__c',
            'dmpl__SalesExecutiveId__c'
        }, 'dmpl__SaleInvoice__c');
        SecurityHelper.ensureCanReadFields(new string[]
        {
            'dmpl__PartnerSchemeAccountGroupId__c'
        }, 'Account');
        SecurityHelper.ensureCanReadFields(new string[]
        {
            'dmpl__ItemId__c',
            'dmpl__SKUId__c',
            'dmpl__Quantity__c'
        }, 'dmpl__SaleInvoiceLine__c');
        return [SELECT
            dmpl__AccountId__c,
            dmpl__AccountId__r.dmpl__PartnerSchemeAccountGroupId__c,
            dmpl__BranchId__c,
            dmpl__PartnerAccountId__c,
            dmpl__SupplierAccountId__c,
            dmpl__TotalAmount__c,
            dmpl__TotalCreditAmount__c,
            dmpl__TotalLineAmount__c,
            dmpl__TotalSchemeDiscountAmount__c,
            dmpl__TotalTaxAmount__c,
            dmpl__TotalTaxAmount2__c,
            dmpl__DocumentDate__c,
            dmpl__SalesExecutiveId__c,
            Id,
            Name,
            (
                SELECT
                    Id,
                    Name,
                    dmpl__ItemId__c,
                    dmpl__ItemId__r.dmpl__SchemeItemGroupId__c,
                    dmpl__SKUId__c,
                    dmpl__Quantity__c,
                    dmpl__Amount__c
                FROM
                    dmpl__SaleInvoiceLines__r
            )
        FROM
            dmpl__SaleInvoice__c
        WHERE
            Id IN : saleInvoiceIds];
    }

    private static List<dmpl__PurchaseOrder__c> queryPurchaseOrders(List<Id> purchaseOrderIds)
    {
        SecurityHelper.ensureCanReadFields(new string[]
        {
            'dmpl__AccountName__c',
            'dmpl__BranchId__c',
            'dmpl__DocumentDate__c',
            'dmpl__PartnerAccountId__c',
            'dmpl__SupplierAccountId__c',
            'dmpl__TotalAmount__c',
            'dmpl__TotalLineAmount__c',
            'dmpl__TotalPendingInvoiceQuantity__c',
            'dmpl__TotalQuantityPending__c'
        }, 'dmpl__PurchaseOrder__c');
        SecurityHelper.ensureCanReadFields(new string[]
        {
            'dmpl__Amount__c',
            'dmpl__BaseAmount__c',
            'dmpl__ItemId__c',
            'dmpl__OriginalItemId__c',
            'dmpl__PurchaseOrderId__c',
            'dmpl__Quantity__c',
            'dmpl__SKUId__c',
            'dmpl__UnitCost__c'
        }, 'dmpl__PurchaseOrderLine__c');
        SecurityHelper.ensureCanReadFields(new string[]
        {
            'dmpl__PartnerSchemeAccountGroupId__c'
        }, 'Account');
        return [SELECT
            dmpl__PartnerAccountId__r.dmpl__PartnerSchemeAccountGroupId__c,
            dmpl__AccountName__c,
            dmpl__BranchId__c,
            dmpl__DocumentDate__c,
            dmpl__PartnerAccountId__c,
            dmpl__SupplierAccountId__c,
            dmpl__TotalAmount__c,
            dmpl__TotalLineAmount__c,
            dmpl__TotalPendingInvoiceQuantity__c,
            dmpl__TotalQuantityPending__c,
            Id,
            Name,
            (
                SELECT
                    dmpl__Amount__c,
                    dmpl__BaseAmount__c,
                    dmpl__ItemId__c,
                    dmpl__ItemId__r.dmpl__SchemeItemGroupId__c,
                    dmpl__OriginalItemId__c,
                    dmpl__PurchaseOrderId__c,
                    dmpl__Quantity__c,
                    dmpl__SKUId__c,
                    dmpl__UnitCost__c,
                    Id,
                    Name
                FROM
                    dmpl__PurchaseOrderLines__r
            )
        FROM
            dmpl__PurchaseOrder__c
        WHERE 
        Id IN : purchaseOrderIds];
    }

    private static List<dmpl__RepairOrder__c> queryRepairOrders(List<Id> repairOrderIds)
    {
        SecurityHelper.ensureCanReadFields(new string[]
        {
            'dmpl__AccountId__c',
            'dmpl__BranchId__c',
            'dmpl__DocumentDate__c',
            'dmpl__OrderAmount__c',
            'dmpl__OutstandingAmount__c',
            'dmpl__PartnerAccountId__c',
            'dmpl__SupplierAccountId__c',
            'dmpl__TotalLabourAmount__c',
            'dmpl__TotalPackageItemsAmount__c',
            'dmpl__TotalPartAmount__c',
            'dmpl__TotalTax__c',
            'dmpl__ServiceAdvisorId__c'
        }, 'dmpl__RepairOrder__c');
        SecurityHelper.ensureCanReadFields(new string[]
        {
            'dmpl__PartnerSchemeAccountGroupId__c'
        }, 'Account');
        SecurityHelper.ensureCanReadFields(new string[]
        {
            'dmpl__Amount__c',
            'dmpl__BaseAmount__c',
            'dmpl__ItemId__c',
            'dmpl__OriginalItemId__c',
            'dmpl__Quantity__c'
        }, 'dmpl__RepairOrderLine__c');
        
        return [SELECT
            dmpl__AccountId__c,
            dmpl__AccountId__r.dmpl__PartnerSchemeAccountGroupId__c,
            dmpl__BranchId__c,
            dmpl__DocumentDate__c,
            dmpl__OrderAmount__c,
            dmpl__OutstandingAmount__c,
            dmpl__PartnerAccountId__c,
            dmpl__SupplierAccountId__c,
            dmpl__TotalLabourAmount__c,
            dmpl__TotalPackageItemsAmount__c,
            dmpl__TotalPartAmount__c,
            dmpl__TotalTax__c,
            dmpl__ServiceAdvisorId__c,
            Id,
            Name,
            (
                SELECT
                    dmpl__Amount__c,
                    dmpl__BaseAmount__c,
                    dmpl__ItemId__c,
                    dmpl__ItemId__r.dmpl__SchemeItemGroupId__c,
                    dmpl__OriginalItemId__c,
                    dmpl__Quantity__c,
                    Id,
                    Name
                FROM
                    dmpl__Repair_Order_Lines1__r
            )
        FROM
            dmpl__RepairOrder__c
        WHERE
            Id IN : repairOrderIds];
    }

    @testVisible
    private static List<dmpl__Bill__c> queryBills(List<Id> billIds)
    {
        SecurityHelper.ensureCanReadFields(new string[]
        {
            'dmpl__PartnerSchemeAccountGroupId__c'
        }, 'Account');
        SecurityHelper.ensureCanReadFields(new string[]
        {
            'dmpl__AccountName__c',
            'dmpl__BranchId__c',
            'dmpl__DocumentDate__c',
            'dmpl__PartnerAccountId__c',
            'dmpl__TotalAmount__c',
            'dmpl__TotalLineAmount__c',
            'dmpl__SupplierAccountId__c'
        }, 'dmpl__Bill__c');
        SecurityHelper.ensureCanReadFields(new string[]
        {
            'dmpl__AccountId__c',
            'dmpl__Amount__c',
            'dmpl__BaseAmount__c',
            'dmpl__PurchaseInvoiceId__c',
            'dmpl__PurchaseOrderLineId__c',
            'dmpl__Quantity__c',
            'dmpl__SupplierAccountId__c',
            'dmpl__SKUId__c',
            'dmpl__UnitCost__c'
        }, 'dmpl__BillLine__c');
        return [
            SELECT 
            dmpl__PartnerAccountId__r.dmpl__PartnerSchemeAccountGroupId__c,
            dmpl__AccountName__c,
            dmpl__BranchId__c,
            dmpl__DocumentDate__c,
            dmpl__PartnerAccountId__c,
            dmpl__TotalAmount__c,
            dmpl__TotalLineAmount__c,
            dmpl__SupplierAccountId__c,
            Id,
            Name,
            (
                SELECT
                    dmpl__AccountId__c,
                    dmpl__Amount__c,
                    dmpl__BaseAmount__c,
                    dmpl__ItemId__c,
                    dmpl__ItemId__r.dmpl__SchemeItemGroupId__c,
                    dmpl__PurchaseInvoiceId__c,
                    dmpl__PurchaseOrderLineId__c,
                    dmpl__Quantity__c,
                    dmpl__SKUId__c,
                    dmpl__UnitCost__c,
                    Id,
                    Name
                FROM
                    dmpl__BillLines__r
            )
            FROM dmpl__Bill__c
            WHERE Id IN : billIds
        ];
    }

    private static List<dmpl__ServiceRequest__c> queryServiceRequests(List<Id> serviceRequestIds)
    {
        SecurityHelper.ensureCanReadFields(new string[]
        {
            'dmpl__PartnerSchemeAccountGroupId__c'
        }, 'Account');
        SecurityHelper.ensureCanReadFields(new string[]
        {
            'dmpl__AccountId__c',
            'dmpl__BranchId__c',
            'dmpl__DocumentDate__c',
            'dmpl__PartnerAccountId__c',
            'dmpl__PickUpAddressId__c',
            'dmpl__ServiceAdvisorId__c'
        }, 'dmpl__ServiceRequest__c');
        return [
        SELECT
            dmpl__PartnerAccountId__r.dmpl__PartnerSchemeAccountGroupId__c,
            dmpl__AccountId__c,
            dmpl__BranchId__c,
            dmpl__DocumentDate__c,
            dmpl__PartnerAccountId__c,
            dmpl__PickUpAddressId__c,
            dmpl__ServiceAdvisorId__c,
            Id,
            Name
        FROM
            dmpl__ServiceRequest__c
        WHERE
        Id IN : serviceRequestIds
        ];
    }

    private static List<dmpl__ItemGroup__c> queryItemGroups(List<Id> itemGroupIds)
    {
        SecurityHelper.ensureCanReadFields(new string[]
        {
            'Name'
        }, 'dmpl__ItemGroup__c');
        SecurityHelper.ensureCanReadFields(new string[]
        {
            'dmpl__ItemId__c'
        }, 'dmpl__ItemGroupMember__c');
        return [
            SELECT
            Id,
            Name,
            (
                SELECT
                Id,
                Name,
                dmpl__ItemId__c
                FROM
                dmpl__ItemGroupMembers__r
            )
            FROM dmpl__ItemGroup__c
            WHERE Id IN : itemGroupIds
        ];
    }
}