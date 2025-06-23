public with sharing class PurchaseRequisitionHelper {
    
    private static Boolean skipValidations = false;

    private static final string OBJECT_REQUISITION = 'dmpl__PurchaseRequisition__c';
    private static final string FIELD_REQUISITION_STATUS = 'dmpl__Status__c';
    private static final string FIELD_REQUISITION_PARTNERACCOUNTID = 'dmpl__PartnerAccountId__c';
    private static final string FIELD_REQUISITION_BRANCHID = 'dmpl__BranchId__c';
    private static final string FIELD_REQUISITION_SUPPLIERACCOUNTID ='dmpl__SupplierAccountId__c';
    private static final string FIELD_REQUISITION_DOCUMENTDATE ='dmpl__DocumentDate__c';
    private static final string FIELD_REQUISITION_REQUISITIONID = 'dmpl__PurchaseRequisitionId__c';
    private static final string FIELD_REQUISITION_PERFORMRELEASEORDER ='dmpl__PerformReleaseOrder__c';
    private static final string FIELD_REQUISITION_ISORDERRELEASED ='dmpl__IsOrderReleased__c';
    private static final string FIELD_REQUISITION_RESOURCEID = 'dmpl__ResourceId__c';

    private static final string RELATION_REQUISITION_LINES = 'dmpl__PurchaseRequisitionLines__r';
    private static final List<String> LIST_NON_EDITABLE_FIELDS = new List<String>{FIELD_REQUISITION_SUPPLIERACCOUNTID, FIELD_REQUISITION_BRANCHID, FIELD_REQUISITION_DOCUMENTDATE, FIELD_REQUISITION_PARTNERACCOUNTID};
    private static final List<String> LIST_FIELDS_SYSTEM = new List<String>();
   
    public static void validateData(Boolean isInsert, Boolean isDelete, Boolean isUpdate, List<dmpl__PurchaseRequisition__c> oldEntries, List<dmpl__PurchaseRequisition__c> newEntries)
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
            StatusHelper.validateStatusNew(OBJECT_REQUISITION, FIELD_REQUISITION_STATUS, newEntries);
            DocumentHelper.validateChangeInSystemFields(LIST_FIELDS_SYSTEM, newEntries);
            ValidationHelper.validatePartnerAndBranch(FIELD_REQUISITION_PARTNERACCOUNTID, FIELD_REQUISITION_BRANCHID, newEntries);
            ValidationHelper.validateResource(
                FIELD_REQUISITION_RESOURCEID, 
                newEntries);
        }else if(isUpdate){
            StatusHelper.validateStatusEdit(OBJECT_REQUISITION, FIELD_REQUISITION_STATUS, oldEntries, newEntries);
            DocumentHelper.validateChangeInKeyFields(LIST_NON_EDITABLE_FIELDS, oldEntries, newEntries);
            DocumentHelper.validateChangeInSystemFields(LIST_FIELDS_SYSTEM, oldEntries, newEntries);
            dfsHelper.DocumentStatusRestrictEdits_Edit(OBJECT_REQUISITION, FIELD_REQUISITION_STATUS, oldEntries, newEntries);
            dfsHelper.DocumentStatusRestrictFieldsEdits(OBJECT_REQUISITION, FIELD_REQUISITION_STATUS, oldEntries, newEntries);
            ValidationHelper.validateResource(
                FIELD_REQUISITION_RESOURCEID, 
                newEntries);
        }else if(isDelete){
            dfsHelper.DocumentStatusRestrictEdits_Delete(OBJECT_REQUISITION, FIELD_REQUISITION_STATUS, oldEntries);
        }

    } catch (Exception error) {
        ExceptionLogHelper.logException(error);
        throw error;
    }
    }

    public static void postData(Boolean isInsert, Boolean isDelete, Boolean isUpdate, List<dmpl__PurchaseRequisition__c> oldEntries, List<dmpl__PurchaseRequisition__c> newEntries)
    { 
        DocumentStatusDFSHelper dfsHelper = new DocumentStatusDFSHelper();
        if(isInsert)
    		DocumentNameHelper.generateDocumentName(newEntries);
        
        if(isUpdate){
            dfsHelper.DocumentStatusSetFlag(OBJECT_REQUISITION, FIELD_REQUISITION_STATUS, oldEntries, newEntries);
            dfsHelper.DocumentStatusReSetFlag(OBJECT_REQUISITION, FIELD_REQUISITION_STATUS, oldEntries, newEntries);
            List<dmpl__PurchaseRequisition__c> modifiedObjects = DocumentHelper.getApprovedObjects(FIELD_REQUISITION_PERFORMRELEASEORDER, oldEntries, newEntries);
            if(modifiedObjects.size()>0){
                    createPurchaseOrder(modifiedObjects);
                }    
            }
    }

    public static void createPurchaseOrder(List<SourceObjectInfo> requisitionLinesInfo){
        if(requisitionLinesInfo == null || requisitionLinesInfo.size() ==0){
            return;
        }
        PurchaseOrderHelper.createPurchaseOrderFromRequisition(requisitionLinesInfo);
    }

    public static void createPurchaseOrder(List<dmpl__PurchaseRequisition__c> lineEntries){
        SecurityHelper.ensureCanWriteField('dmpl__PerformReleaseOrder__c', 'dmpl__PurchaseRequisition__c');
        SecurityHelper.ensureCanWriteField('dmpl__IsOrderReleased__c', 'dmpl__PurchaseRequisition__c');
        for(dmpl__PurchaseRequisition__c lineEntry : lineEntries){
            lineEntry.dmpl__PerformReleaseOrder__c = false;
            lineEntry.dmpl__IsOrderReleased__c = true;
            }
        PurchaseOrderHelper.createPurchaseOrderFromRequisition(lineEntries);

    }
}