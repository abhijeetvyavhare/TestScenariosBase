public with sharing class InventoryAdjustmentHelper {
    
    private static Boolean skipValidations = false;

    private static final string OBJECT_ADJUSTMENT = 'dmpl__InventoryAdjustment__c';
    private static final string FIELD_ADJUSTMENT_STATUS = 'dmpl__Status__c';
    private static final string FIELD_ADJUSTMENT_PARTNERACCOUNTID = 'dmpl__PartnerAccountId__c';
    private static final string FIELD_ADJUSTMENT_BRANCHID = 'dmpl__BranchId__c';
    private static final string FIELD_ADJUSTMENT_DOCUMENTDATE ='dmpl__DocumentDate__c';
    private static final string FIELD_ADJUSTMENT_CYCLECOUNTID ='dmpl__CycleCountId__c';
    private static final string FIELD_ADJUSTMENT_ISINVENTORYPOSTED ='dmpl__IsInventoryPosted__c';
    private static final string FIELD_ADJUSTMENT_PERFROMINVENTORYPOSTING ='dmpl__PerformInventoryPosting__c';

    private static final string FIELD_ADJUSTMENTLINE_ADJUSTMENTID ='dmpl__InventoryAdjustmentId__c';
    private static final string RELATION_ADJUSTMENT_ADJUSTMENTLINES = 'dmpl__AdjustmentLines__r';


    private static final List<String> LIST_NON_EDITABLE_FIELDS = new List<String>{FIELD_ADJUSTMENT_CYCLECOUNTID,FIELD_ADJUSTMENT_PARTNERACCOUNTID, FIELD_ADJUSTMENT_BRANCHID, FIELD_ADJUSTMENT_DOCUMENTDATE};
    private static final List<String> LIST_FIELDS_SOURCEPOULATED = new List<String>{FIELD_ADJUSTMENT_PARTNERACCOUNTID, FIELD_ADJUSTMENT_BRANCHID};
    private static final List<String> LIST_FIELDS_SYSTEM = new List<String>{FIELD_ADJUSTMENT_CYCLECOUNTID, FIELD_ADJUSTMENT_ISINVENTORYPOSTED};

    public static void validateData(Boolean isInsert, Boolean isDelete, Boolean isUpdate, List<dmpl__InventoryAdjustment__c> oldEntries, List<dmpl__InventoryAdjustment__c> newEntries)
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
            StatusHelper.validateStatusNew(OBJECT_ADJUSTMENT, FIELD_ADJUSTMENT_STATUS, newEntries);
            DocumentHelper.validateChangeInSystemFields(LIST_FIELDS_SYSTEM, newEntries);
            ValidationHelper.validatePartnerAndBranch(FIELD_ADJUSTMENT_PARTNERACCOUNTID, FIELD_ADJUSTMENT_BRANCHID, newEntries);
        }else if(isUpdate){
            StatusHelper.validateStatusEdit(OBJECT_ADJUSTMENT, FIELD_ADJUSTMENT_STATUS, oldEntries, newEntries);
            DocumentHelper.validateChangeInSystemFields(LIST_FIELDS_SYSTEM, oldEntries, newEntries);
            DocumentHelper.validateChangeInKeyFields(LIST_NON_EDITABLE_FIELDS, oldEntries, newEntries,queryTransactedObjectIds(newEntries));
            DocumentHelper.validateChangeInSourcePopulatedFields(LIST_FIELDS_SOURCEPOULATED, oldEntries, newEntries,FIELD_ADJUSTMENT_CYCLECOUNTID);
            dfsHelper.DocumentStatusRestrictEdits_Edit(OBJECT_ADJUSTMENT, FIELD_ADJUSTMENT_STATUS, oldEntries, newEntries);
            dfsHelper.DocumentStatusRestrictFieldsEdits(OBJECT_ADJUSTMENT, FIELD_ADJUSTMENT_STATUS, oldEntries, newEntries);
        }else if(isDelete){
            dfsHelper.DocumentStatusRestrictEdits_Delete(OBJECT_ADJUSTMENT, FIELD_ADJUSTMENT_STATUS, oldEntries);
        }
    } catch (Exception error) {
        ExceptionLogHelper.logException(error);
        throw error;
    }
    }

    public static void postData(Boolean isInsert, Boolean isDelete, Boolean isUpdate, List<dmpl__InventoryAdjustment__c> oldEntries, List<dmpl__InventoryAdjustment__c> newEntries)
    {
        try{
            DocumentStatusDFSHelper dfsHelper = new DocumentStatusDFSHelper();
            if(isInsert){
    		    DocumentNameHelper.generateDocumentName(newEntries);
            }
            
            if(isUpdate){
                dfsHelper.DocumentStatusSetFlag(OBJECT_ADJUSTMENT, FIELD_ADJUSTMENT_STATUS, newEntries);
                dfsHelper.DocumentStatusReSetFlag(OBJECT_ADJUSTMENT, FIELD_ADJUSTMENT_STATUS, newEntries);
                List<dmpl__InventoryAdjustment__c> modifiedDocs = DocumentHelper.getApprovedObjects(FIELD_ADJUSTMENT_PERFROMINVENTORYPOSTING, oldEntries,newEntries);
                if(modifiedDocs.size()>0){
                    InventoryAdjustmentLineHelper.postAdjustmentLines(modifiedDocs);
                    SecurityHelper.ensureCanWriteField('dmpl__PerformInventoryPosting__c', 'dmpl__InventoryAdjustment__c');
                    SecurityHelper.ensureCanWriteField('dmpl__IsInventoryPosted__c', 'dmpl__InventoryAdjustment__c');
                    for(dmpl__InventoryAdjustment__c document : modifiedDocs){
                        document.dmpl__PerformInventoryPosting__c = false;
                        document.dmpl__IsInventoryPosted__c = true;
                    }
                }
                List<dmpl__InventoryAdjustment__c> modifiedObjects = DocumentHelper.getModifiedNewObjects(
                    'dmpl__PriceAsOnDate__c', 
                    oldEntries, 
                    newEntries);
                if(modifiedObjects.size()>0){
                    InventoryAdjustmentLineHelper.performReprice(
                        CollectionHelper.extractIds(modifiedObjects));
                }
            }
        } catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }

    public static void createAdjustmentFromInventoryCycleCount(List<dmpl__InventoryCycleCount__c> inventoryCycleCounts){
        createAdjustment(inventoryCycleCounts);
    }

    public static void createAdjustmentFromClaim(List<dmpl__Claim__c> claims)
    {
        createAdjustment(claims);
    }

    public static void createAdjustmentFromClaimBatch(List<dmpl__ClaimBatch__c> claims)
    {
        createAdjustment(claims);
    }

    public static CreateRelatedResult postIL(Id adjustmentId){
       return InventoryAdjustmentLineHelper.postIL(adjustmentId);
    }

    public static CreateRelatedResult postIL(List<SourceObjectInfo> orderLinesInfo, Id adjustmentId){
        return InventoryAdjustmentLineHelper.postIL(orderLinesInfo, adjustmentId);
    }

    private static List<Id> queryTransactedObjectIds(List<dmpl__InventoryAdjustment__c> newEntries){
       
        SecurityHelper.ensureCanReadFields(new string[]{'dmpl__InventoryAdjustmentId__c'}, 'dmpl__InventoryAdjustmentLine__c');
        return DocumentHelper.extractIds([SELECT dmpl__InventoryAdjustmentId__c 
                FROM dmpl__InventoryAdjustmentLine__c
                WHERE dmpl__InventoryAdjustmentId__c IN:DocumentHelper.extractIds(newEntries)], FIELD_ADJUSTMENTLINE_ADJUSTMENTID);
    }

    @testvisible
    private static void createAdjustment(List<dmpl__InventoryCycleCount__c> inventoryCycleCounts){
        List<dmpl__InventoryAdjustment__c> newInventoryAdjustments = new List<dmpl__InventoryAdjustment__c>();

        for(dmpl__InventoryCycleCount__c inventoryCycleCount : inventoryCycleCounts){
            if(inventoryCycleCount.dmpl__AdjustmentId__c != null)
                continue;
            
            newInventoryAdjustments.add(new dmpl__InventoryAdjustment__c(
                    dmpl__CycleCountId__c = inventoryCycleCount.ID,
                    dmpl__BranchId__c = inventoryCycleCount.dmpl__BranchId__c,
                    dmpl__PartnerAccountId__c = inventoryCycleCount.dmpl__PartnerAccountId__c
            ));
        }

        if(newInventoryAdjustments.size() > 0)
        {
            try{
                SecurityHelper.ensureCanCreateObject('dmpl__InventoryAdjustment__c');
                SecurityHelper.ensureCanCreateObject('dmpl__InventoryAdjustmentLine__c');
                SecurityHelper.ensureCanCreateFields(new string[]{'dmpl__CycleCountId__c','dmpl__BranchId__c','dmpl__PartnerAccountId__c'}, 'dmpl__InventoryAdjustment__c');
                skipValidations = true;
                insert newInventoryAdjustments;
                InventoryAdjustmentLineHelper.createInventoryAdjustmentLinesFromInventoryAdjustment(newInventoryAdjustments);
            } catch(Exception error){
                ExceptionLogHelper.logException(error);
                throw error;
            } finally{
                skipValidations = false;
            }
        }
    }

    @testvisible
    private static void createAdjustment(List<dmpl__Claim__c> newEntries)
    {
        List<dmpl__InventoryAdjustment__c> newAdjustments = new List<dmpl__InventoryAdjustment__c>();
        Map<Id, Claim__c> claims = new Map<Id, dmpl__Claim__c>(queryClaims(DocumentHelper.extractIds(newEntries)));

        for(Claim__c claim : newEntries)
        {
            List<dmpl__ClaimLine__c> claimLines = claims.get(claim.ID)?.dmpl__Claim_Lines1__r;
            if(claimLines != null && claimLines.size() > 0 && canCreateAdjustment(claimLines))
                newAdjustments.Add(createAdjustment(claim));
        }

        if(newAdjustments.size() >0){
            Savepoint sp = Database.setSavepoint();
            try {
                    SecurityHelper.ensureCanCreateObject('dmpl__InventoryAdjustment__c');
                    SecurityHelper.ensureCanCreateFields(new string[]{'dmpl__PartnerAccountId__c','dmpl__BranchId__c','dmpl__ClaimId__c'}, 'dmpl__InventoryAdjustment__c');
                    insert newAdjustments;
                    InventoryAdjustmentLineHelper.createInventoryAdjustmentLinesFromClaim(newAdjustments, claims);
            } catch (Exception e) {
                Database.rollback(sp);
                throw e;
            }
        }
    }

    @testvisible
    private static void createAdjustment(List<dmpl__ClaimBatch__c> newEntries)
    {
        List<dmpl__InventoryAdjustment__c> newAdjustments = new List<dmpl__InventoryAdjustment__c>();
        Map<Id, dmpl__ClaimBatch__c> claimBatches = new Map<Id, dmpl__ClaimBatch__c>(queryClaimBatch(DocumentHelper.extractIds(newEntries)));

        for(dmpl__ClaimBatch__c claimBatch : newEntries)
        {
            List<dmpl__ClaimLine__c> claimLines = claimBatches.get(claimBatch.Id).dmpl__ClaimLines__r;
            if(claimLines != null && claimLines.size() > 0 && canCreateAdjustment(claimLines))
                newAdjustments.Add(createAdjustment(claimBatch));
        }

        if(newAdjustments.size() >0){
            Savepoint sp = Database.setSavepoint();
            try {
                    SecurityHelper.ensureCanCreateObject('dmpl__InventoryAdjustment__c');
                    SecurityHelper.ensureCanCreateFields(new string[]{'dmpl__PartnerAccountId__c','dmpl__BranchId__c','dmpl__ClaimBatchId__c'}, 'dmpl__InventoryAdjustment__c');
                    insert newAdjustments;
                    InventoryAdjustmentLineHelper.createInventoryAdjustmentLinesFromClaimBatch(newAdjustments, claimBatches);
            } catch (Exception e) {
                Database.rollback(sp);
                throw e;
            }
        }
    }

    @testvisible
    private static List<dmpl__ClaimBatch__c> queryClaimBatch(List<Id> claimBatchIds)
    {
        SecurityHelper.ensureCanReadFields(new string[]{'dmpl__IsReconciled__c','dmpl__ApproveAll__c','dmpl__BranchId__c','dmpl__DocumentDate__c','dmpl__IsClaimLinePopulated__c','dmpl__PartnerAccountId__c','dmpl__PerformPopulateClaimLines__c','dmpl__PerformReconciliation__c','dmpl__Remarks__c','dmpl__Status__c','dmpl__TotalApprovedAmount__c','dmpl__TotalApprovedQuantity__c'}, 'dmpl__ClaimBatch__c');
        SecurityHelper.ensureCanReadFields(new string[]{'dmpl__ApproveAmount__c','dmpl__ApproveQuantity__c','dmpl__BatchClaimId__c','dmpl__BranchId__c','dmpl__ClaimAmount__c','dmpl__ClaimBatchId__c','dmpl__ClaimBatchLineId__c','dmpl__ClaimId__c','dmpl__ClaimQuantity__c','dmpl__ClaimType__c','dmpl__ComplaintFaultCodeId__c','dmpl__ComplaintId__c','dmpl__ExternalId__c','dmpl__GoodsReceiptId__c','dmpl__GoodsReceiptLineId__c','dmpl__IsBatch__c','dmpl__IsClaimReconciliationCreated__c','dmpl__ItemCode__c','dmpl__ItemId__c','dmpl__PartnerAccountId__c','dmpl__RejectAmount__c','dmpl__RejectQuantity__c','dmpl__RepairOrderId__c','dmpl__RepairOrderLineId__c','dmpl__ServiceContractId__c','dmpl__Status__c','dmpl__TaxGroupId__c','dmpl__TechnicianId__c','dmpl__UnitPrice__c'}, 'dmpl__ClaimLine__c');
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

    @testvisible
    private static dmpl__InventoryAdjustment__c createAdjustment(Claim__c claim)
    {
        return new dmpl__InventoryAdjustment__c(
            dmpl__PartnerAccountId__c = claim.dmpl__PartnerAccountId__c,
            dmpl__BranchId__c = claim.dmpl__BranchId__c,
            dmpl__ClaimId__c = claim.Id
        );
    }

    @TestVisible
    private static dmpl__InventoryAdjustment__c createAdjustment(dmpl__ClaimBatch__c claimBatch)
    {
        return new dmpl__InventoryAdjustment__c(
            dmpl__PartnerAccountId__c = claimBatch.dmpl__PartnerAccountId__c,
            dmpl__BranchId__c = claimBatch.dmpl__BranchId__c,
            dmpl__ClaimBatchId__c = claimBatch.Id
        );
    }

    @TestVisible
    private static Boolean canCreateAdjustment(List<dmpl__ClaimLine__c> claimLines)
    {
        for(dmpl__ClaimLine__c claimLine : claimLines)
            if(claimLine.dmpl__ClaimType__c == 'Part to Part' && ClaimLine.dmpl__ApproveQuantity__c > 0)
                return true;
        return false;
    }

    private static List<dmpl__Claim__c> queryClaims(List<Id> claimIds)
    {
        SecurityHelper.ensureCanReadFields(new string[]{
        'dmpl__ApproveAll__c',
        'dmpl__AsOnDate__c',
        'dmpl__BranchId__c',
        'dmpl__ClaimBatchId__c',
        'dmpl__ClaimType__c',
        'dmpl__DocumentDate__c',
        'dmpl__ExternalId__c',
        'dmpl__GoodsReceiptId__c',
        'dmpl__IsLinePopulated__c',
        'dmpl__IsReconciled__c',
        'dmpl__PartnerAccountId__c',
        'dmpl__PerformPopulateLines__c',
        'dmpl__PerformReconciliation__c',
        'dmpl__RejectAll__c',
        'dmpl__Remarks__c',
        'dmpl__RepairOrderId__c',
        'dmpl__ServiceInvoiceAsOnDate__c',
        'dmpl__Status__c',
        'dmpl__SupplierNameId__c',
        'dmpl__TotalAmount__c',
        'dmpl__TotalApprovedAmount__c',
        'dmpl__TotalApprovedQuantity__c',
        'dmpl__TotalQuantity__c',
        'dmpl__TotalRejectedAmount__c',
        'dmpl__TotalRejectedQuantity__c'
        }, 
            'dmpl__Claim__c');
        SecurityHelper.ensureCanReadFields(new string[]{'dmpl__ApproveAmount__c','dmpl__ApproveQuantity__c','dmpl__BatchClaimId__c','dmpl__BranchId__c','dmpl__ClaimAmount__c','dmpl__ClaimBatchId__c','dmpl__ClaimBatchLineId__c','dmpl__ClaimId__c','dmpl__ClaimQuantity__c','dmpl__ClaimType__c','dmpl__ComplaintFaultCodeId__c','dmpl__ComplaintId__c','dmpl__ExternalId__c','dmpl__GoodsReceiptId__c','dmpl__GoodsReceiptLineId__c','dmpl__IsBatch__c','dmpl__IsClaimReconciliationCreated__c','dmpl__ItemCode__c','dmpl__ItemId__c','dmpl__PartnerAccountId__c','dmpl__RejectAmount__c','dmpl__RejectQuantity__c','dmpl__RepairOrderId__c','dmpl__RepairOrderLineId__c','dmpl__ServiceContractId__c','dmpl__Status__c','dmpl__TaxGroupId__c','dmpl__TechnicianId__c','dmpl__UnitPrice__c'}, 'dmpl__ClaimLine__c');
        return [SELECT
        dmpl__ApproveAll__c,
        dmpl__AsOnDate__c,
        dmpl__BranchId__c,
        dmpl__ClaimBatchId__c,
        dmpl__ClaimType__c,
        dmpl__DocumentDate__c,
        dmpl__ExternalId__c,
        dmpl__GoodsReceiptId__c,
        dmpl__IsLinePopulated__c,
        dmpl__IsReconciled__c,
        dmpl__PartnerAccountId__c,
        dmpl__PerformPopulateLines__c,
        dmpl__PerformReconciliation__c,
        dmpl__RejectAll__c,
        dmpl__Remarks__c,
        dmpl__RepairOrderId__c,
        dmpl__ServiceInvoiceAsOnDate__c,
        dmpl__Status__c,
        dmpl__SupplierNameId__c,
        dmpl__TotalAmount__c,
        dmpl__TotalApprovedAmount__c,
        dmpl__TotalApprovedQuantity__c,
        dmpl__TotalQuantity__c,
        dmpl__TotalRejectedAmount__c,
        dmpl__TotalRejectedQuantity__c,
        Id,
        Name,
        OwnerId,
        (
            SELECT
                dmpl__ApproveAmount__c,
                dmpl__ApproveQuantity__c,
                dmpl__BatchClaimId__c,
                dmpl__BranchId__c,
                dmpl__ClaimAmount__c,
                dmpl__ClaimBatchId__c,
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
                Id,
                Name
            FROM
                dmpl__Claim_Lines1__r
            WHERE 
                dmpl__IsClaimReconciliationCreated__c = false
        )
    FROM
        dmpl__Claim__c 
        WHERE Id IN : claimIds
        AND dmpl__IsReconciled__c = false];
    }
}