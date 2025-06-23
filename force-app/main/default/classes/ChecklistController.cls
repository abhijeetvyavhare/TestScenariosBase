public with sharing class ChecklistController {
   
    @AuraEnabled(cacheable = true)
    public static List<dmpl__ChecklistTemplate__c> getChecklistTemplates(Id templateId){
    try
        {
            return (List<dmpl__ChecklistTemplate__c>) 
            new MetadataService('dmpl__ChecklistTemplate__c').queryObjectsWithRelation(
                new string[]{
                    'dmpl__Type__c',
                    'dmpl__ParentChecklistId__c',
                    'dmpl__ItemId__c',
                    'dmpl__Code__c'}, 
                'dmpl__CheckList_Template_Lines__r', 
                new string[]{
                    'dmpl__DataType__c', 
                    'dmpl__DefaultValue__c', 
                    'dmpl__GroupBy__c' 
                }, 
                templateId);
        }
        catch(Exception e)
        {
            throw new DMPLException(e.getMessage());
        }
    }
    
    @AuraEnabled(cacheable = true)
    public static List<dmpl__CheckListLines__c> getChecklistLines(
        String parentFieldName,
        Id parentRecordId){
        try {
            MetadataService ms = new MetadataService('dmpl__CheckListLines__c');
            return (List<dmpl__CheckListLines__c>) ms.queryObjects(
                new string[]{
                    'dmpl__BooleanValue__c',
                    'dmpl__BranchId__c',
                    'dmpl__ChecklistTemplateId__c',
                    'dmpl__CheckListTemplateLineId__c',
                    'dmpl__DataType__c',
                    'dmpl__DeliveryOrderId__c',
                    'dmpl__GoodsReceiptId__c',
                    'dmpl__NumericValue__c',
                    'dmpl__PartnerAccountId__c',
                    'dmpl__RAGValue__c',
                    'dmpl__Remarks__c',
                    'dmpl__DecimalValue__c',
                    'dmpl__DateValue__c',
                    'dmpl__DateTimeValue__c',
                    'dmpl__CurrencyValue__c',
                    'dmpl__Phone__c',
                    'dmpl__URL__c',
                    'dmpl__RepairOrderId__c',
                    'dmpl__ServiceRequestId__c',
                    'dmpl__TextValue__c',
                    'dmpl__TimeValue__c',
                    'dmpl__Email__c',
                    'dmpl__InspectionLineId__c'},
                parentFieldName,
                parentRecordId);
        } catch (Exception error) {
                ExceptionLogHelper.logException(error);
                throw error;
        }
    }
    @AuraEnabled
    public static String uploadFile(
        Id recordId, 
        String base64, 
        String filename) {
            ContentVersion cv = createContentVersion(base64, filename);
            ContentDocumentLink cdl = createContentLink(cv.Id, recordId);
            if (cv == null || cdl == null) {
                return null; }
            return cdl.Id;
    }

    @testvisible
    private static ContentVersion createContentVersion(
        String base64, 
        String filename) {
        ContentVersion cv = new ContentVersion();
        cv.VersionData = EncodingUtil.base64Decode(base64);
        cv.Title = filename;
        cv.PathOnClient = filename;
        try {
            insert cv;
            return cv;
        } catch(DMLException e) {
            ExceptionLogHelper.logException(e);
            throw e;
        }
    }

    @testvisible
    private static ContentDocumentLink createContentLink(String contentVersionId, String recordId) {
        if (contentVersionId == null 
            || recordId == null) { 
                return null; 
        }
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = [SELECT 
                ContentDocumentId 
            FROM ContentVersion 
            WHERE Id =: contentVersionId].ContentDocumentId;
        cdl.LinkedEntityId = recordId;
        cdl.ShareType = 'V';
        try {
            insert cdl;
            return cdl;
        } catch(DMLException e) {
            ExceptionLogHelper.logException(e);
            throw e;
        }
    }
}