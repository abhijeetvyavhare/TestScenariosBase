public with sharing class CheckInController {
   
    @AuraEnabled(cacheable = true)
    public static List<dmpl__CheckInTemplate__c> getCheckInTemplates(ID itemId)
    {
        SecurityHelper.ensureCanReadFields(new string[]{'dmpl__ApplicableItemId__c'},'dmpl__CheckInTemplate__c');
        return [SELECT Id, Name, dmpl__ApplicableItemId__c, (SELECT Id, dmpl__CheckInTemplateId__c, Name, dmpl__Issues__c, dmpl__SectionName__c, dmpl__SubSection__c FROM dmpl__Check_In_section_Templates__r ORDER BY ID) FROM dmpl__CheckInTemplate__c WHERE dmpl__ApplicableItemId__c =: itemId ORDER BY ID];
    }

    @AuraEnabled(cacheable = true)
    public static dmpl__CheckInInspection__c getCheckInInspection(ID recordId)
    {
        SecurityHelper.ensureCanReadFields(new string[]{'dmpl__AssetId__c'},'dmpl__CheckInInspection__c');
        return [SELECT Id, Name, dmpl__AssetId__c, (SELECT  dmpl__Section__c ,dmpl__SubSection__c, dmpl__Condition__c, Id, Name, dmpl__Remarks__c FROM dmpl__Check_In_Inspection_Lines__r) FROM dmpl__CheckInInspection__c WHERE Id =: recordId];
    }

    @AuraEnabled(cacheable=true)
    public static List<dmpl__CheckInInspectionLine__c> getCheckInAttachments(ID recordId)
    {
        SecurityHelper.ensureCanReadFields(new string[]{'Name'},'dmpl__CheckInInspectionLine__c');
        return [SELECT ID, Name, (Select Id, LinkedEntityId, ContentDocumentId,ContentDocument.LatestPublishedVersionId FROM ContentDocumentLinks) FROM dmpl__CheckInInspectionLine__c  WHERE ID = : recordId];
    }

    @AuraEnabled(cacheable=true)
    public static List<dmpl__CheckInTemplateLine__c> getCheckInTemplateLineAttachments(Id itemId)
    {
        SecurityHelper.ensureCanReadFields(new string[]{'dmpl__SectionName__c'},'dmpl__CheckInTemplateLine__c');
        return [SELECT ID, Name, dmpl__SectionName__c, dmpl__CheckInTemplateId__r.dmpl__ApplicableItemId__c, (Select Id, LinkedEntityId, ContentDocumentId,ContentDocument.LatestPublishedVersionId FROM ContentDocumentLinks) FROM dmpl__CheckInTemplateLine__c  WHERE dmpl__CheckInTemplateId__r.dmpl__ApplicableItemId__c = : itemId ORDER BY ID];
    }
}