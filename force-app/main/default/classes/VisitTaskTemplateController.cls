public with sharing class VisitTaskTemplateController {
    @AuraEnabled(cacheable = true)
    public static List<dmpl__VisitTaskTemplateEntry__c> VisitTaskTemplateEntries(Id recordId){
        try {
            return [
                SELECT 
                    Id,
                    Name,
                    dmpl__SequenceNumber__c,
                    dmpl__IsMandatory__c,
                    dmpl__IsHidden__c,
                    dmpl__TaskType__c,
                    dmpl__Description__c,
                    dmpl__CanExecuteOutOfSequence__c,
                    dmpl__UniqueIdentifier__c,
                    dmpl__RecordId__c,
                    dmpl__VisitTaskTemplateId__c,
                    dmpl__VisitTaskTemplateId__r.Name,
                    dmpl__VisitTaskTemplateId__r.dmpl__Description__c,
                    dmpl__VisitTaskTemplateId__r.dmpl__Duration__c,
                    (
                        SELECT 
                            Id,
                            Name,
                            dmpl__ActivityType__c,
                            dmpl__ChecklistTemplateId__c,
                            dmpl__DashboardURL__c,
                            dmpl__Description__c,
                            dmpl__Duration__c,
                            dmpl__FieldName__c,
                            dmpl__FieldValue__c,
                            dmpl__RecordId__c,
                            dmpl__IsHidden__c,
                            dmpl__IsMandatory__c,
                            dmpl__ObjectName__c,
                            dmpl__ObjectApiName__c,
                            dmpl__PerformAutomatically__c,
                            dmpl__PicklistValues__c,
                            dmpl__RelatedActivityAction__c,
                            dmpl__RelatedVisitTaskTemplateActivityId__c,
                            dmpl__ReportURL__c,
                            dmpl__SequenceNumber__c,
                            dmpl__VisibilityFilter__c,
                            dmpl__UniqueIdentifier__c,
                            dmpl__Settings__c,
                            dmpl__ShowDetails__c
                        FROM
                            dmpl__VisitTaskTemplateActivities__r
                        ORDER BY
                            dmpl__SequenceNumber__c
                    )
                FROM 
                    dmpl__VisitTaskTemplateEntry__c
                WHERE 
                    dmpl__VisitTaskTemplateId__c =:recordId
                ORDER BY
                    dmpl__SequenceNumber__c
            ];
        } catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }
}