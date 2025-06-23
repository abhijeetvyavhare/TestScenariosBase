public with sharing class RelatedListController {
    @AuraEnabled
    public static string updateRelatedRecords(String sObjectName, Object data) {
        List<SObject> recordsForUpdate = (List<SObject>) JSON.deserialize(
            JSON.serialize(data),
            System.Type.forName( 'List<' + sObjectName + '>' )
        );
        
        try {
            update recordsForUpdate;
            return 'Success: records updated successfully';
        }
        catch (Exception e) {
            return 'The following exception has occurred: ' + e.getMessage();
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
            return cdl.ContentDocumentId;
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