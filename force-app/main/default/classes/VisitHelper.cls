@namespaceAccessible
public with sharing class VisitHelper {

    private static Boolean skipValidations = false;

    private static final string FIELD_VISITTASKTEMPLATEID = 'dmpl__VisitTaskTemplateId__c';

    private static final string OBJECT_VISIT = 'dmpl__Visit__c';
    private static final string OBJECT_VISITTASK = 'dmpl__VisitTask__c';
    private static final string OBJECT_VISITTASKTEMPLATE = 'dmpl__VisitTaskTemplate__c';
    private static final string OBJECT_VISITTASKTEMPLATEENTRY = 'dmpl__VisitTaskTemplateEntry__c';
    
    private static final string FIELD_VISIT_STATUS = 'dmpl__VisitStatus__c';

    public static void validateData(
        Boolean isInsert,
        Boolean isUpdate, 
        Boolean isDelete, 
        List<dmpl__Visit__c> newEntries, 
        List<dmpl__Visit__c> oldEntries ){
        try {
            if(isInsert){
                FieldMappingHelper.copyFieldMappingData(
                    newEntries);
            }
            if(skipValidations){
                return;
            }
            if(isInsert){

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
        List<dmpl__Visit__c> newEntries,
        List<dmpl__Visit__c> oldEntries){
            try{
                if(isInsert){
                    DocumentNameHelper.generateDocumentName(newEntries);
                }else if(isUpdate){
                    List<dmpl__Visit__c> modifiedDocs = DocumentHelper.getModifiedNewObjects(
                        FIELD_VISIT_STATUS, 
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

    public static void afterPostData(Boolean isInsert, Boolean isUpdate, Boolean isDelete, List<dmpl__Visit__c> newEntries, List<dmpl__Visit__c> oldEntries)
    {
        if(isInsert)
        {
            populateVisitTaskTemplateDetails(DocumentHelper.getObjectsWithNotNull(newEntries, FIELD_VISITTASKTEMPLATEID));
        }
        if(isUpdate)
        {
            populateVisitTaskTemplateDetails(DocumentHelper.getModifiedNewObjects(FIELD_VISITTASKTEMPLATEID, oldEntries, newEntries));
        }
    }

    private static void setStatusTimeStamps(
        List<dmpl__Visit__c> modifiedEntries, 
        List<dmpl__Visit__c> oldEntries){
            for(dmpl__Visit__c visit : modifiedEntries){
                dmpl__Visit__c oldVisit = (dmpl__Visit__c)CollectionHelper.getObject(oldEntries, visit.Id);
                if(visit.dmpl__VisitStatus__c == 'Started' && oldVisit.dmpl__VisitStatus__c != 'Started'){
                    visit.dmpl__DocumentDate__c = Date.today();
                    visit.dmpl__StartTime__c = Datetime.now().time();
                } else if(visit.dmpl__VisitStatus__c == 'Completed' && oldVisit.dmpl__VisitStatus__c != 'Completed'){
                    visit.dmpl__EndTime__c = Datetime.now().time();
                }
            }
    }

    private static void populateVisitTaskTemplateDetails(List<dmpl__Visit__c> modifiedEntries)
    {
        if(modifiedEntries.size() == 0)
            return;

        List<dmpl__VisitTask__c> deleteVisitTasks = queryVisitTasks(DocumentHelper.extractIds(modifiedEntries));
        if(deleteVisitTasks.size() > 0)
            DELETE deleteVisitTasks;

        List<dmpl__VisitTaskTemplateEntry__c> visitTaskTemplates = queryVisitTaskTemplates(DocumentHelper.extractIds(modifiedEntries, FIELD_VISITTASKTEMPLATEID));
        List<dmpl__VisitTask__c> insertVisitTasks = new List<dmpl__VisitTask__c>();
        List<dmpl__VisitTaskActivity__c> insertVisitTaskActivites = new List<dmpl__VisitTaskActivity__c>();
        for(dmpl__Visit__c visit : modifiedEntries){
            List<dmpl__VisitTaskTemplateEntry__c> filteredEntries = (List<dmpl__VisitTaskTemplateEntry__c>)CollectionHelper.getObjectsByFilter(
                visitTaskTemplates, 
                'dmpl__VisitTaskTemplateId__c', 
                visit.dmpl__VisitTaskTemplateId__c);
            for(dmpl__VisitTaskTemplateEntry__c entry : filteredEntries){
                dmpl__VisitTask__c task = new dmpl__VisitTask__c(
                    dmpl__TaskName__c = entry.Name,
                    dmpl__VisitId__c = visit.Id,
                    dmpl__TaskType__c = entry.dmpl__TaskType__c,
                    dmpl__SequenceNumber__c = entry.dmpl__SequenceNumber__c,
                    dmpl__VisitTaskTemplateEntryId__c = entry.Id,
                    dmpl__IsHidden__c =  entry.dmpl__IsHidden__c
                );
                insertVisitTasks.add(task);
            }
        }
        //
        if(insertVisitTasks.size() > 0){
            try 
            {
                SecurityHelper.ensureCanCreateObject(OBJECT_VISITTASK);
                SecurityHelper.ensureCanCreateFields(new String[]{'dmpl__VisitId__c','dmpl__TaskType__c','dmpl__SequenceNumber__c','dmpl__VisitTaskTemplateEntryId__c'}, OBJECT_VISITTASK);
                INSERT insertVisitTasks;
            } 
            catch (Exception error) 
            {
                ExceptionLogHelper.logException(error);
                throw error;
            }
        }
    }

    private static List<dmpl__VisitTask__c> queryVisitTasks(List<Id> visitIds)
    {
        SecurityHelper.ensureCanReadFields(new String[]{'Name','dmpl__VisitId__c'}, OBJECT_VISITTASK);
        return [SELECT Id, Name FROM dmpl__VisitTask__c WHERE dmpl__VisitId__c IN : visitIds];
    }

    private static List<dmpl__VisitTaskTemplateEntry__c> queryVisitTaskTemplates(List<Id> visitTaskTemplateIds)
    {
        SecurityHelper.ensureCanReadFields(new String[]{'dmpl__Description__c','dmpl__Duration__c'}, OBJECT_VISITTASKTEMPLATE);
        SecurityHelper.ensureCanReadFields(new String[]{'dmpl__Description__c','dmpl__SequenceNumber__c','dmpl__TaskDuration__c','dmpl__TaskType__c','dmpl__VisitTaskTemplateId__c'}, OBJECT_VISITTASKTEMPLATEENTRY);
        return [
            SELECT
            Id,
            Name,
            dmpl__Description__c,
            dmpl__SequenceNumber__c,
            dmpl__TaskDuration__c,
            dmpl__TaskType__c,
            dmpl__IsHidden__c,
            dmpl__VisitTaskTemplateId__c,
            dmpl__VisitTaskTemplateId__r.dmpl__Description__c,
            dmpl__VisitTaskTemplateId__r.dmpl__Duration__c,
            dmpl__VisitTaskTemplateId__r.Name
        FROM
            dmpl__VisitTaskTemplateEntry__c
        WHERE
            dmpl__VisitTaskTemplateId__c IN : visitTaskTemplateIds
        ];
    }

    @namespaceAccessible
    public static List<dmpl__VisitTask__c> getVisitTasks(Id recordId){
        return [SELECT
                    dmpl__TaskName__c,
                    dmpl__Duration__c,
                    dmpl__EndTime__c,
                    dmpl__PlannedDuration__c,
                    dmpl__PlannedEndTime__c,
                    dmpl__PlannedStartTime__c,
                    dmpl__SequenceNumber__c,
                    dmpl__StartTime__c,
                    dmpl__Status__c,
                    dmpl__TaskType__c,
                    dmpl__VisitId__c,
                    dmpl__IsHidden__c,
                    dmpl__VisitTaskTemplateEntryId__c,
                    dmpl__VisitTaskTemplateEntryId__r.dmpl__IsMandatory__c,
                    dmpl__VisitTaskTemplateEntryId__r.dmpl__CanExecuteOutOfSequence__c,
                    dmpl__VisitTaskTemplateEntryId__r.dmpl__TaskDuration__c,
                    dmpl__VisitTaskTemplateEntryId__r.dmpl__Description__c,
                    dmpl__VisitId__r.dmpl__DeliveryOrderId__c,
                    dmpl__VisitId__r.dmpl__DeliveryOrderId__r.Name,
                    dmpl__VisitId__r.dmpl__SaleOrderId__c,
                    dmpl__VisitId__r.dmpl__AppointmentId__c,
                    dmpl__VisitId__r.dmpl__RepairOrderId__c,
                    dmpl__VisitId__r.dmpl__InvoiceId__c,
                    dmpl__VisitId__r.dmpl__PaymentId__c,
                    dmpl__VisitId__r.dmpl__PartnerAccountId__c,
                    dmpl__VisitId__r.dmpl__AccountId__c,
                    dmpl__VisitId__r.dmpl__BranchId__c,
                    dmpl__VisitId__r.dmpl__VisitStatus__c,
                    Id,
                    Name,
                    (SELECT
                        Id,
                        Name,
                        dmpl__SequenceNumber__c,
                        dmpl__ActivityName__c,
                        dmpl__ActivityType__c,
                        dmpl__PlannedDuration__c,
                        dmpl__PlannedStartTime__c,
                        dmpl__PlannedEndTime__c,
                        dmpl__StartTime__c,
                        dmpl__EndTime__c,
                        dmpl__Duration__c,
                        dmpl__Email__c,
                        dmpl__Phone__c,
                        dmpl__BooleanValue__c,
                        dmpl__CurrencyValue__c,
                        dmpl__DateTimeValue__c,
                        dmpl__Date__c,
                        dmpl__DecimalValue__c,
                        dmpl__GeolocationValue__c,
                        dmpl__LongTextValue__c,
                        dmpl__NumericValue__c,
                        dmpl__PerformAutomatically__c,
                        dmpl__Status__c,
                        dmpl__TextValue__c,
                        dmpl__URL__c,
                        dmpl__ObjectName__c,
                        dmpl__FieldName__c,
                        dmpl__FieldValue__c,
                        dmpl__SaleOrderId__c,
                        dmpl__RepairOrderId__c,
                        dmpl__InvoiceId__c,
                        dmpl__DeliveryOrderId__c,
                        dmpl__ProductDemoId__c,
                        dmpl__PaymentId__c,
                        dmpl__IsHidden__c,
                        dmpl__IsDisabled__c,
                        dmpl__VisitTaskTemplateActivityId__r.dmpl__IsMandatory__c,
                        dmpl__VisitTaskTemplateActivityId__r.dmpl__RelatedVisitTaskTemplateActivityId__c,
                        dmpl__VisitTaskTemplateActivityId__r.dmpl__RelatedActivityAction__c
                    FROM
                        dmpl__VisitTaskActivities__r 
                    ORDER BY dmpl__SequenceNumber__c
                    )
                FROM
                    dmpl__VisitTask__c
                WHERE 
                    dmpl__VisitId__c = :recordId
                ORDER BY 
                    dmpl__SequenceNumber__c];
    }
}