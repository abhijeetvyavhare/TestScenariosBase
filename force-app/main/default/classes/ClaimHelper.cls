public with sharing class ClaimHelper {

    private static final string CLAIMTYPE_SALE = 'Sale';
    private static final string CLAIMTYPE_SERVICE = 'Service';
    private static final string CLAIMTYPE_PURCHASE = 'Purchase';

    private static final string FIELD_CLAIMTYPE = 'dmpl__ClaimType__c';
    private static final string FIELD_PERFORMPOPULATELINES = 'dmpl__PerformPopulateLines__c';
    private static final string FIELD_ISLINEPOPULATED = 'dmpl__IsLinePopulated__c';

    private static final string FIELD_PERFORMRECONCILIATION = 'dmpl__PerformReconciliation__c';
    private static final string FIELD_ISRECONCILED = 'dmpl__IsReconciled__c';
    private static final string FIELD_APPROVEALL = 'dmpl__ApproveAll__c';
    private static final string FIELD_REJECTALL = 'dmpl__RejectAll__c';

    public static void validateData(Boolean isInsert, Boolean isUpdate, Boolean isDelete, List<dmpl__Claim__c> newEntries, List<dmpl__Claim__c> oldEntries)
    {
        if(isInsert){
            FieldMappingHelper.copyFieldMappingData(
                newEntries);
        }
    }

    public static void postData(Boolean isInsert, Boolean isUpdate, Boolean isDelete, List<dmpl__Claim__c> newEntries, List<dmpl__Claim__c> oldEntries)
    {
        if(isInsert)
    		DocumentNameHelper.generateDocumentName(newEntries);
        
        if(isUpdate)
        {
            List<dmpl__Claim__c> modifiedObjects = DocumentHelper.getApprovedObjects(FIELD_PERFORMPOPULATELINES, oldEntries, newEntries);
            if(modifiedObjects.size() > 0)
                populateClaimLines(modifiedObjects);

            modifiedObjects = DocumentHelper.getModifiedNewObjects(FIELD_PERFORMRECONCILIATION, oldEntries, newEntries);
            if(modifiedObjects.size() > 0)
                reconcile(modifiedObjects);

            modifiedObjects = DocumentHelper.getModifiedNewObjects(FIELD_APPROVEALL, oldEntries, newEntries);
            if(modifiedObjects.size() > 0)
                claimLineHelper.markAllClaimLines(new Map<Id, dmpl__Claim__c>(modifiedObjects));
            
            modifiedObjects = DocumentHelper.getModifiedNewObjects(FIELD_REJECTALL, oldEntries, newEntries);
            if(modifiedObjects.size() > 0)
                claimLineHelper.markAllClaimLines(new Map<Id, dmpl__Claim__c>(modifiedObjects));
        }
    }

    public static void afterPostData(Boolean isInsert, Boolean isUpdate, Boolean isDelete, List<dmpl__Claim__c> newEntries, List<dmpl__Claim__c> oldEntries)
    {
        if(isUpdate)
        {
            // List<dmpl__Claim__c> modifiedObjects = DocumentHelper.getApprovedObjects(FIELD_ISLINEPOPULATED, oldEntries, newEntries);
            // if(modifiedObjects.size() > 0)
            //     populateLines(modifiedObjects);
        }
    }

    public static CreateRelatedResult createClaims(
        List<dmpl__RepairOrder__c> repairOrders){
            return CreateRelatedResult.InitFrom(
                ClaimLineHelper.createClaimLinesFromClaim(
                    createClaimsFromRepairOrders(
                        queryRepairOrderLines(
                            CollectionHelper.extractIds(repairOrders),
                            null),
                        null),
                    null));
    }

    public static CreateRelatedResult createClaims(Id repairOrderId){
        return CreateRelatedResult.InitFrom(
            ClaimLineHelper.createClaimLinesFromClaim(
                createClaimsFromRepairOrders(
                    queryRepairOrderLines(
                        new List<Id>{ repairOrderId},
                        null),
                    null),
                null));
    }

    public static CreateRelatedResult createClaims(List<SourceObjectInfo> orderLinesInfo){
        return CreateRelatedResult.InitFrom(
            ClaimLineHelper.createClaimLinesFromClaim(
                createClaimsFromRepairOrders(
                    queryRepairOrderLines(
                        null,
                        SourceObjectInfo.extractIds(orderLinesInfo)),
                    orderLinesInfo),
                orderLinesInfo));
    }

    private static void populateClaimLines(List<dmpl__Claim__c> claims)
    {
        ClaimLineHelper.createClaimLinesFromClaim(claims, null);
        SecurityHelper.ensureCanWriteField('dmpl__PerformPopulateLines__c', 'dmpl__Claim__c');
        SecurityHelper.ensureCanWriteField('dmpl__IsLinePopulated__c', 'dmpl__Claim__c');
        for(dmpl__Claim__c lineEntry : claims)
        {
            lineEntry.dmpl__PerformPopulateLines__c = false;
            lineEntry.dmpl__IsLinePopulated__c = true;
        }
    }

    private static void reconcile(List<dmpl__Claim__c> claims)
    {
        InventoryAdjustmentHelper.createAdjustmentFromClaim(claims);
        SaleInvoiceHelper.createSaleInvoiceFromClaim(claims);
        markClaimToReconciled(claims);
        //ClaimLineHelper.markIsReconciliationCreated(claims);
    }

    private static void markClaimToReconciled(List<dmpl__Claim__c> claims)
    {
        for(dmpl__Claim__c claim : claims)
        {
            claim.dmpl__PerformReconciliation__c = false;
            // claim.dmpl__IsReconciled__c = true;
        }
    }

    private static List<dmpl__Claim__c> createClaimsFromRepairOrders(
        List<dmpl__RepairOrderLine__c> repairOrderLines,
        List<SourceObjectInfo> orderLineInfo){
        List<dmpl__RepairOrderLine__c> pendingOrderLines = new List<dmpl__RepairOrderLine__c>();
        for(dmpl__RepairOrderLine__c repairOrderLine : repairOrderLines){
            if(!repairOrderLine.dmpl__IsClaimed__c){
                pendingOrderLines.Add(repairOrderLine);
                repairOrderLine.dmpl__IsClaimed__c = true;
            }
            
        }
        List<string> distinctInvoiceGroups = getDistinctInvoiceGroups(pendingOrderLines);
        List<Id> itemServiceIds = DocumentHelper.extractIds(
            repairOrderLines, 
            'dmpl__ItemServiceContractId__c');
        itemServiceIds.addAll(DocumentHelper.extractIds(
            repairOrderLines, 
            'dmpl__ItemServiceContractId2__c'));
        itemServiceIds.addAll(DocumentHelper.extractIds(
            repairOrderLines, 
            'dmpl__ItemServiceContractId3__c'));
        List<dmpl__AssetServiceContract__c> assetServiceContracts = queryAssetServiceContracts(
            DocumentHelper.extractIdsFromLookup(
                repairOrderLines, 
                'dmpl__RepairOrderId__r',
                'dmpl__AssetId__c'), 
            itemServiceIds);
            
        List<dmpl__ItemServiceContract__c> itemServiceContracts = queryItemServiceContracts(itemServiceIds);
        Map<String, dmpl__Claim__c> claims = new Map<String, dmpl__Claim__c>();
        for(string invoiceGroup : distinctInvoiceGroups){
            for(dmpl__RepairOrderLine__c repairOrderLine : pendingOrderLines){
                if(orderLineInfo!=null && SourceObjectInfo.getRequestedQuantity(orderLineInfo, repairOrderLine.Id) ==0){
                    continue;
                }
                String lineInvoiceGroup = repairOrderLine.dmpl__InvoiceGroup__c == null? dmpl__Claim__c.class.getName() : repairOrderLine.dmpl__InvoiceGroup__c;
                if(repairOrderLine.dmpl__ItemServiceContractId__c !=null 
                    && repairOrderLine.dmpl__PostingType__c == 'Auto Generate Claims'
                    && lineInvoiceGroup + repairOrderLine.dmpl__ItemServiceContractId__c == invoiceGroup){
                    String invoiceGroupBatch = invoiceGroup + String.valueOf(repairOrderLine.dmpl__RepairOrderId__c);
                    SourceObjectInfo objectInfo = SourceObjectInfo.getSourceObjectInfo(orderLineInfo, repairOrderLine.Id);
                    dmpl__Claim__c claim = claims.get(invoiceGroupBatch);
                    if(claim == null && objectInfo!=null){
                        claim = queryClaimDocument(objectInfo.getDestinationObjectId(invoiceGroupBatch));
                    }
                    if(claim == null){
                        Id billingAccountId = getBillingAccountId(
                            assetServiceContracts,
                            itemServiceContracts, 
                            repairOrderLine.dmpl__RepairOrderId__r.dmpl__AssetId__c, 
                            repairOrderLine.dmpl__ItemServiceContractId__c, 
                            repairOrderLine.dmpl__RepairOrderId__r.dmpl__AccountId__c);
                        claim = createClaimDocument(
                            invoiceGroup, 
                            repairOrderLine, 
                            billingAccountId,
                            repairOrderLine.dmpl__ItemServiceContractId__c);
                    }
                    if(!claims.containsKey(invoiceGroupBatch)){
                        claims.put(invoiceGroupBatch, claim);
                    }
                }
                if(repairOrderLine.dmpl__ServiceContractWeightage2__c >0 
                    && repairOrderLine.dmpl__ItemServiceContractId2__c !=null
                    && repairOrderLine.dmpl__ItemServiceContractId2__r.dmpl__ContractPostingTreatment__c  =='Auto Generate Claims'
                    && lineInvoiceGroup + repairOrderLine.dmpl__ItemServiceContractId2__c == invoiceGroup){

                    String invoiceGroupBatch = invoiceGroup + String.valueOf(repairOrderLine.dmpl__RepairOrderId__c);
                    SourceObjectInfo objectInfo = SourceObjectInfo.getSourceObjectInfo(orderLineInfo, repairOrderLine.Id);
                    dmpl__Claim__c claim = claims.get(invoiceGroupBatch);
                    if(claim == null && objectInfo!=null){
                        claim = queryClaimDocument(objectInfo.getDestinationObjectId(invoiceGroupBatch));
                    }
                    if(claim == null){
                        Id billingAccountId = getBillingAccountId(
                            assetServiceContracts,
                            itemServiceContracts, 
                            repairOrderLine.dmpl__RepairOrderId__r.dmpl__AssetId__c, 
                            repairOrderLine.dmpl__ItemServiceContractId2__c, 
                            repairOrderLine.dmpl__RepairOrderId__r.dmpl__AccountId__c);
                        claim = createClaimDocument(
                            invoiceGroup, 
                            repairOrderLine, 
                            billingAccountId,
                            repairOrderLine.dmpl__ItemServiceContractId2__c);
                    }
                    if(!claims.containsKey(invoiceGroupBatch)){
                        claims.put(invoiceGroupBatch, claim);
                    }
                }
                if(repairOrderLine.dmpl__ServiceContractWeightage3__c >0 &&
                    repairOrderLine.dmpl__ItemServiceContractId3__c !=null 
                    && repairOrderLine.dmpl__ItemServiceContractId3__r.dmpl__ContractPostingTreatment__c  =='Auto Generate Claims'
                    && lineInvoiceGroup + repairOrderLine.dmpl__ItemServiceContractId3__c == invoiceGroup){

                    String invoiceGroupBatch = invoiceGroup + String.valueOf(repairOrderLine.dmpl__RepairOrderId__c);
                    SourceObjectInfo objectInfo = SourceObjectInfo.getSourceObjectInfo(orderLineInfo, repairOrderLine.Id);
                    dmpl__Claim__c claim = claims.get(invoiceGroupBatch);
                    if(claim == null && objectInfo!=null){
                        claim = queryClaimDocument(objectInfo.getDestinationObjectId(invoiceGroupBatch));
                    }
                    if(claim == null){
                        Id billingAccountId = getBillingAccountId(
                            assetServiceContracts,
                            itemServiceContracts, 
                            repairOrderLine.dmpl__RepairOrderId__r.dmpl__AssetId__c, 
                            repairOrderLine.dmpl__ItemServiceContractId3__c, 
                            repairOrderLine.dmpl__RepairOrderId__r.dmpl__AccountId__c);
                        claim = createClaimDocument(
                            invoiceGroup, 
                            repairOrderLine, 
                            billingAccountId,
                            repairOrderLine.dmpl__ItemServiceContractId3__c);
                    }
                    if(!claims.containsKey(invoiceGroupBatch)){
                        claims.put(invoiceGroupBatch, claim);
                    }
                }
            }
        }

        if(claims.size() >0){
            Savepoint sp = Database.setSavepoint();
            try {
                    upsert claims.values();
                    return claims.values();
            } catch (Exception e) {
                Database.rollback(sp);
                throw e;
            }
        }
        return new List<dmpl__Claim__c>();
    }

    @testVisible
    private static Id getBillingAccountId(
        List<dmpl__AssetServiceContract__c> assetServiceContracts, 
        List<dmpl__ItemServiceContract__c> itemServiceContracts,
        Id assetId, 
        Id itemServiceContractId, 
        Id defaultBillingAccountId){
        for(dmpl__AssetServiceContract__c assetServiceContract : assetServiceContracts){
            if(assetServiceContract.dmpl__AssetId__c == assetId 
                && assetServiceContract.dmpl__ItemServiceContractId__c == itemServiceContractId 
                && assetServiceContract.dmpl__BillingAccountId__c != null)
                return assetServiceContract.dmpl__BillingAccountId__c;
        }
        for(dmpl__ItemServiceContract__c itemServiceContract : itemServiceContracts){
            if(itemServiceContract.Id == itemServiceContractId 
                && itemServiceContract.dmpl__BillingAccountId__c != null)
                return itemServiceContract.dmpl__BillingAccountId__c;
        }
        return defaultBillingAccountId;
    }

    private static List<string> getDistinctInvoiceGroups(List<dmpl__RepairOrderLine__c> repairOrderLines)
    {
        List<string> distinctInvoiceGroups = new List<string>();
        for(dmpl__RepairOrderLine__c repairOrderLine : repairOrderLines){
            String invoiceGroup = repairOrderLine.dmpl__InvoiceGroup__c == null? dmpl__Claim__c.class.getName() : repairOrderLine.dmpl__InvoiceGroup__c;
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

    private static List<dmpl__ItemServiceContract__c> queryItemServiceContracts(List<Id> itemServiceContractIds)
    {
        SecurityHelper.ensureCanReadFields(new string[]{
            'dmpl__BillingAccountId__c',
            'dmpl__BillToPartnerAccount__c',
            'dmpl__ContractPostingTreatment__c'}, 
            'dmpl__ItemServiceContract__c');
        return [SELECT 
                Id, 
                Name, 
                dmpl__BillingAccountId__c,
                dmpl__BillToPartnerAccount__c,
                dmpl__ContractPostingTreatment__c
            FROM 
                dmpl__ItemServiceContract__c 
            WHERE Id IN : itemServiceContractIds];
    }

    private static List<dmpl__AssetServiceContract__c> queryAssetServiceContracts(List<Id> assetIds, List<Id> itemServiceContractIds)
    {
        SecurityHelper.ensureCanReadFields(new string[]{
            'dmpl__AssetId__c','dmpl__BillingAccountId__c','dmpl__ItemServiceContractId__c','dmpl__ServiceContractItemId__c'}, 
            'dmpl__AssetServiceContract__c');
        return [SELECT Id, Name, dmpl__AssetId__c, dmpl__BillingAccountId__c, dmpl__ItemServiceContractId__c, dmpl__ServiceContractItemId__c FROM dmpl__AssetServiceContract__c WHERE dmpl__AssetId__c IN : assetIds AND dmpl__ItemServiceContractId__c IN : itemServiceContractIds];
    }
    
    @testVisible
    private static dmpl__Claim__c createClaimDocument(
        string invoiceGroup, 
        dmpl__RepairOrderLine__c repairOrderLine, 
        Id billingAccountId,
        Id itemServiceContractId){
        return new dmpl__Claim__c(
            dmpl__BranchId__c = repairOrderLine.dmpl__RepairOrderId__r.dmpl__BranchId__c,
            dmpl__PartnerAccountId__c = repairOrderLine.dmpl__RepairOrderId__r.dmpl__PartnerAccountId__c,
            dmpl__DocumentDate__c = System.today(),
            dmpl__SupplierNameId__c = billingAccountId,
            dmpl__ItemServiceContractId__c = itemServiceContractId,
            dmpl__InvoiceGroup__c = repairOrderLine.dmpl__InvoiceGroup__c,
            dmpl__RepairOrderId__c = repairOrderLine.dmpl__RepairOrderId__c,
            dmpl__ClaimType__c = 'Service'
        );
    }

    @testVisible
    private static dmpl__Claim__c queryClaimDocument(Id claimId){
        if(claimId == null){
            return null;
        }
        return [SELECT 
            Id,
            dmpl__BranchId__c,
            dmpl__PartnerAccountId__c,
            dmpl__DocumentDate__c,
            dmpl__SupplierNameId__c,
            dmpl__ItemServiceContractId__c,
            dmpl__InvoiceGroup__c,
            dmpl__RepairOrderId__c,
            dmpl__ClaimType__c
        FROM dmpl__Claim__c WHERE Id =:claimId];
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
            dmpl__IsClaimed__c,
            dmpl__ItemServiceContractId__c,
            dmpl__ItemServiceContractId2__c,
            dmpl__ItemServiceContractId3__c,
            dmpl__ServiceContractWeightage__c,
            dmpl__ServiceContractWeightage2__c,
            dmpl__ServiceContractWeightage3__c,
            dmpl__ItemServiceContractId2__r.dmpl__ContractPostingTreatment__c,
            dmpl__ItemServiceContractId3__r.dmpl__ContractPostingTreatment__c
        FROM dmpl__RepairOrderLine__c
        WHERE (dmpl__RepairOrderId__c IN : repairOrderIds OR Id IN : repairOrderLineIds)
        AND (dmpl__PostingType__c = 'Auto Generate Claims'
        OR dmpl__ItemServiceContractId2__r.dmpl__ContractPostingTreatment__c  ='Auto Generate Claims'
        OR dmpl__ItemServiceContractId3__r.dmpl__ContractPostingTreatment__c = 'Auto Generate Claims')];
    }
}