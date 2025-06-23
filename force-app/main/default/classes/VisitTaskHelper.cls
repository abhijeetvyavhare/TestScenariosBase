public with sharing class VisitTaskHelper 
{

    private static string OBJECT_VISITTASKACTIVITY = 'dmpl__VisitTaskActivity__c';
    private static final string FIELD_VISITTASKTEMPLATEENTRYID = 'dmpl__VisitTaskTemplateEntryId__c';
    
    private static final string FIELD_VISITTASK_STATUS = 'dmpl__Status__c';

      public static void validateData(
        Boolean isInsert, 
        Boolean isUpdate, 
        Boolean isDelete, 
        List<dmpl__VisitTask__c> newEntries,
        List<dmpl__VisitTask__c> oldEntries){
            try {
                if(isInsert){
                    FieldMappingHelper.copyFieldMappingData(
                        newEntries);
                }
            } catch (Exception error) {
                ExceptionLogHelper.logException(error);
                throw error;
            }
        }
    
    public static void postData(
        Boolean isInsert, 
        Boolean isUpdate, 
        Boolean isDelete, 
        List<dmpl__VisitTask__c> newEntries,
        List<dmpl__VisitTask__c> oldEntries){
            try{
                if(isInsert){

                }else if(isUpdate){
                    List<dmpl__VisitTask__c> modifiedDocs = DocumentHelper.getModifiedNewObjects(
                        FIELD_VISITTASK_STATUS, 
                        oldEntries,
                        newEntries);
                    if(modifiedDocs.size()>0){
                        setStatusTimeStamps(modifiedDocs, oldEntries);
                    }
                }
            }catch (Exception error) {
                ExceptionLogHelper.logException(error);
                throw error;
            }
    }

    public static void afterPostData(Boolean isInsert, Boolean isUpdate, Boolean isDelete, List<dmpl__VisitTask__c> newEntries, List<dmpl__VisitTask__c> oldEntries)
    {
        if(isInsert)
        {
            populateVisitTaskTemplateEntryDetails(DocumentHelper.getObjectsWithNotNull(newEntries, FIELD_VISITTASKTEMPLATEENTRYID));
        }
        if(isUpdate)
        {
            populateVisitTaskTemplateEntryDetails(DocumentHelper.getModifiedNewObjects(FIELD_VISITTASKTEMPLATEENTRYID, oldEntries, newEntries));
        }
    }

    @testVisible
    private static void setStatusTimeStamps(
        List<dmpl__VisitTask__c> modifiedEntries, 
        List<dmpl__VisitTask__c> oldEntries){
            for(dmpl__VisitTask__c visit : modifiedEntries){
                dmpl__VisitTask__c oldVisit = (dmpl__VisitTask__c)CollectionHelper.getObject(oldEntries, visit.Id);
                if(visit.dmpl__Status__c == 'Started' && oldVisit.dmpl__Status__c != 'Started'){
                    visit.dmpl__StartTime__c = Datetime.now().time();
                } else if(visit.dmpl__Status__c == 'Completed' && oldVisit.dmpl__Status__c != 'Completed'){
                    visit.dmpl__EndTime__c = Datetime.now().time();
                }
            }
    }

    private static void populateVisitTaskTemplateEntryDetails(List<dmpl__VisitTask__c> modifiedEntries)
    {
        if(modifiedEntries.size() == 0)
            return;

        List<dmpl__VisitTaskActivity__c> deleteVisitTaskActivities = queryVisitTaskActivities(DocumentHelper.extractIds(modifiedEntries));
        if(deleteVisitTaskActivities.size() > 0)
            DELETE deleteVisitTaskActivities;

        List<dmpl__VisitTaskActivity__c> insertVisitTaskActivities = createVisitTaskActivitiesFromTaskTemplateActivities(modifiedEntries);
        if(insertVisitTaskActivities.size() > 0)
        {
            try 
            {
                SecurityHelper.ensureCanCreateObject(OBJECT_VISITTASKACTIVITY);
                SecurityHelper.ensureCanCreateFields(new String[]{'dmpl__VisitId__c','dmpl__TaskType__c','dmpl__SequenceNumber__c','dmpl__VisitTaskTemplateEntryId__c'}, OBJECT_VISITTASKACTIVITY);
                INSERT insertVisitTaskActivities;
            } 
            catch (Exception error) 
            {
                ExceptionLogHelper.logException(error);
                throw error;
            }
        }
    }

    private static List<dmpl__VisitTaskActivity__c> queryVisitTaskActivities(List<Id> visitTaskIds)
    {
        SecurityHelper.ensureCanReadFields(new String[]{'Name','dmpl__VisitTaskId__c'}, OBJECT_VISITTASKACTIVITY);
        return [SELECT Id, Name FROM dmpl__VisitTaskActivity__c WHERE dmpl__VisitTaskId__c IN : visitTaskIds];
    }

    private static List<dmpl__VisitTaskActivity__c> createVisitTaskActivitiesFromTaskTemplateActivities(List<dmpl__VisitTask__c> modifiedEntries)
    {
        Map<Id, dmpl__VisitTaskTemplateEntry__c> visitTaskTemplateEntries = new Map<Id, dmpl__VisitTaskTemplateEntry__c>(queryVisitTaskTemplatesEntry(DocumentHelper.extractIds(modifiedEntries, FIELD_VISITTASKTEMPLATEENTRYID)));
        List<dmpl__VisitTaskActivity__c> insertVisitTaskActivities = new List<dmpl__VisitTaskActivity__c>();
        for(dmpl__VisitTask__c visitTask : modifiedEntries)
        {
            dmpl__VisitTaskTemplateEntry__c currentVisitTaskTemplateEntry = visitTaskTemplateEntries.get(visitTask.dmpl__VisitTaskTemplateEntryId__c);
            if(currentVisitTaskTemplateEntry != null && currentVisitTaskTemplateEntry.dmpl__VisitTaskTemplateActivities__r.size() > 0)
            {
                for(dmpl__VisitTaskTemplateActivity__c visitTaskTemplateEntryActivity : currentVisitTaskTemplateEntry.dmpl__VisitTaskTemplateActivities__r)
                {
                    insertVisitTaskActivities.add(
                        new dmpl__VisitTaskActivity__c(
                            dmpl__VisitTaskId__c = visitTask.Id,
                            dmpl__VisitId__c = visitTask.dmpl__VisitId__c,
                            dmpl__ActivityName__c = visitTaskTemplateEntryActivity.Name,
                            dmpl__ActivityType__c = visitTaskTemplateEntryActivity.dmpl__ActivityType__c,
                            dmpl__FieldName__c = visitTaskTemplateEntryActivity.dmpl__FieldName__c,
                            dmpl__FieldValue__c = visitTaskTemplateEntryActivity.dmpl__FieldValue__c,
                            dmpl__ObjectName__c = visitTaskTemplateEntryActivity.dmpl__ObjectName__c,
                            dmpl__PerformAutomatically__c = visitTaskTemplateEntryActivity.dmpl__PerformAutomatically__c,
                            dmpl__SequenceNumber__c = visitTaskTemplateEntryActivity.dmpl__SequenceNumber__c,
                            dmpl__URL__c = visitTaskTemplateEntryActivity.dmpl__ReportURL__c,
                            dmpl__ChecklistTemplateId__c = visitTaskTemplateEntryActivity.dmpl__ChecklistTemplateId__c,
                            dmpl__VisitTaskTemplateActivityId__c = visitTaskTemplateEntryActivity.Id,
                            dmpl__IsHidden__c =  visitTaskTemplateEntryActivity.dmpl__IsHidden__c
                        )
                    );
                }
            }
        }
        return insertVisitTaskActivities;
    }

    private static List<dmpl__VisitTaskTemplateEntry__c> queryVisitTaskTemplatesEntry(List<Id> visitTaskTemplateEntryIds)
    {
        return [
            SELECT
            dmpl__Description__c,
            dmpl__SequenceNumber__c,
            dmpl__TaskDuration__c,
            dmpl__TaskType__c,
            dmpl__VisitTaskTemplateId__c,
            Id,
            IsDeleted,
            Name,
            (
                SELECT
                    dmpl__ActivityType__c,
                    dmpl__DashboardURL__c,
                    dmpl__Description__c,
                    dmpl__Duration__c,
                    dmpl__FieldName__c,
                    dmpl__FieldValue__c,
                    dmpl__ObjectName__c,
                    dmpl__PerformAutomatically__c,
                    dmpl__ReportURL__c,
                    dmpl__SequenceNumber__c,
                    dmpl__VisitTaskTemplateEntryId__c,
                    dmpl__ChecklistTemplateId__c,
                    dmpl__IsHidden__c,
                    Id,
                    IsDeleted,
                    Name
                FROM
                    dmpl__VisitTaskTemplateActivities__r
            )
        FROM
            dmpl__VisitTaskTemplateEntry__c
        WHERE
            ID IN : visitTaskTemplateEntryIds
        ];
    }
}