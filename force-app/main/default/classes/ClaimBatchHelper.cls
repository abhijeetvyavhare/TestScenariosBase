public with sharing class ClaimBatchHelper {

    private static Boolean skipValidations = false;

    private static final string FIELD_CLAIMBATCH_PARTNERACCOUNTID = 'dmpl__PartnerAccountId__c';
    private static final string FIELD_CLAIMBATCH_BRANCHID = 'dmpl__BranchId__c';
    private static final string OBJECT_CLAIMBATCH = 'dmpl__ClaimBatch__c';
    private static final string FIELD_CLAIMBATCH_STATUS = 'dmpl__Status__c';
    
    private static final string FIELD_PERFORMPOPULATECLAIMLINES = 'dmpl__PerformPopulateClaimLines__c';
    private static final string FIELD_ISCLAIMLINEPOPULATED = 'dmpl__IsClaimLinePopulated__c';

    private static final string FIELD_PREFORMRECONCILIATION = 'dmpl__PerformReconciliation__c';
    private static final string FIELD_ISRECONCILED = 'dmpl__IsReconciled__c';

    private static final List<String> LIST_NON_EDITABLE_FIELDS = new List<String>{FIELD_CLAIMBATCH_BRANCHID, FIELD_CLAIMBATCH_PARTNERACCOUNTID};
    private static final List<String> LIST_FIELDS_SYSTEM = new List<String>{};

    public static void validateData(Boolean isInsert, Boolean isUpdate, Boolean isDelete, List<dmpl__ClaimBatch__c> newEntries, List<dmpl__ClaimBatch__c> oldEntries)
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
                StatusHelper.validateStatusNew(OBJECT_CLAIMBATCH, FIELD_CLAIMBATCH_STATUS, newEntries);
                DocumentHelper.validateChangeInSystemFields(LIST_FIELDS_SYSTEM, newEntries);
                ValidationHelper.validatePartnerAndBranch(FIELD_CLAIMBATCH_PARTNERACCOUNTID, FIELD_CLAIMBATCH_BRANCHID, newEntries);
            }else if(isUpdate){
                StatusHelper.validateStatusEdit(OBJECT_CLAIMBATCH, FIELD_CLAIMBATCH_STATUS, oldEntries, newEntries);
                DocumentHelper.validateChangeInKeyFields(LIST_NON_EDITABLE_FIELDS, oldEntries, newEntries);
                DocumentHelper.validateChangeInSystemFields(LIST_FIELDS_SYSTEM, oldEntries, newEntries);
                dfsHelper.DocumentStatusRestrictEdits_Edit(OBJECT_CLAIMBATCH, FIELD_CLAIMBATCH_STATUS, oldEntries, newEntries);
                dfsHelper.DocumentStatusRestrictFieldsEdits(OBJECT_CLAIMBATCH, FIELD_CLAIMBATCH_STATUS, oldEntries, newEntries);
            }else if(isDelete){
                dfsHelper.DocumentStatusRestrictEdits_Delete(OBJECT_CLAIMBATCH, FIELD_CLAIMBATCH_STATUS, oldEntries);
            }
        } catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }

    public static void postData(Boolean isInsert, Boolean isUpdate, Boolean isDelete, List<dmpl__ClaimBatch__c> newEntries, List<dmpl__ClaimBatch__c> oldEntries)
    {
        if(isUpdate)
        {
            List<dmpl__ClaimBatch__c> modifiedRecords = DocumentHelper.getApprovedNewObjects(FIELD_PERFORMPOPULATECLAIMLINES, newEntries);
            if(modifiedRecords.size() > 0)
                populateClaimLines(modifiedRecords);

            modifiedRecords = DocumentHelper.getApprovedNewObjects(FIELD_PREFORMRECONCILIATION, newEntries);
            if(modifiedRecords.size() > 0)
                performReconciliation(modifiedRecords);
        }
    }

    public static void afterPostData(Boolean isInsert, Boolean isUpdate, Boolean isDelete, List<dmpl__ClaimBatch__c> newEntries, List<dmpl__ClaimBatch__c> oldEntries)
    {
        
    }

    private static void populateClaimLines(List<dmpl__ClaimBatch__c> newEntries)
    {
        SecurityHelper.ensureCanWriteField('dmpl__PerformPopulateClaimLines__c', 'dmpl__ClaimBatch__c');
        SecurityHelper.ensureCanWriteField('dmpl__IsClaimLinePopulated__c', 'dmpl__ClaimBatch__c');
        ClaimLineHelper.populateClaimLinesInClaimBatch(newEntries);
        for(dmpl__ClaimBatch__c lineEntry : newEntries)
        {
            lineEntry.dmpl__PerformPopulateClaimLines__c = false;
            lineEntry.dmpl__IsClaimLinePopulated__c = true;
        }
    }

    private static void performReconciliation(LIst<dmpl__ClaimBatch__c> newEntries)
    {
        SecurityHelper.ensureCanWriteField('dmpl__PerformReconciliation__c', 'dmpl__ClaimBatch__c');
        SecurityHelper.ensureCanWriteField('dmpl__IsReconciled__c', 'dmpl__ClaimBatch__c');
        InventoryAdjustmentHelper.createAdjustmentFromClaimBatch(newEntries);
        SaleInvoiceHelper.createSaleInvoiceFromClaimBatch(newEntries);
        ClaimLineHelper.markIsReconciliationCreated(newEntries);
        for(dmpl__ClaimBatch__c lineEntry : newEntries)
        {
            lineEntry.dmpl__PerformReconciliation__c = false;
            lineEntry.dmpl__IsReconciled__c = true;
        }
    }
}