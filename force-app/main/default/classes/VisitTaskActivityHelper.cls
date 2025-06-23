public with sharing class VisitTaskActivityHelper 
{
    
    private static string OBJECT_VISITTASKACTIVITY = 'dmpl__VisitTaskActivity__c';
    private static final string FIELD_VISITTASKACTIVITY_STATUS = 'dmpl__Status__c';

        public static void validateData(
        Boolean isInsert, 
        Boolean isUpdate, 
        Boolean isDelete, 
        List<dmpl__VisitTaskActivity__c> newEntries,
        List<dmpl__VisitTaskActivity__c> oldEntries){
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
        List<dmpl__VisitTaskActivity__c> newEntries,
        List<dmpl__VisitTaskActivity__c> oldEntries){
            try{
                if(isInsert){

                }else if(isUpdate){
                    setAvtivityStatus(
                        newEntries,
                        oldEntries);
                    List<dmpl__VisitTaskActivity__c> modifiedDocs = DocumentHelper.getModifiedNewObjects(
                        FIELD_VISITTASKACTIVITY_STATUS, 
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

    public static void afterPostData(
        Boolean isInsert, 
        Boolean isUpdate, 
        Boolean isDelete, 
        List<dmpl__VisitTaskActivity__c> newEntries,
        List<dmpl__VisitTaskActivity__c> oldEntries){
            try{
                if(isInsert){

                }else if(isUpdate){
                    setActivityActions(newEntries);
                }
            }catch (Exception error) {
                ExceptionLogHelper.logException(error);
                throw error;
            }
    }

    private static void setAvtivityStatus(
        List<dmpl__VisitTaskActivity__c> newEntries, 
        List<dmpl__VisitTaskActivity__c> oldEntries){
        //List<dmpl__VisitTaskActivity__c> relatedActivities = queryRelatedActivities(CollectionHelper.extractId(newEntries, 'dmpl__RelatedVisitTaskTemplateActivityId__c'));
            for(dmpl__VisitTaskActivity__c activity : newEntries){
                dmpl__VisitTaskActivity__c oldActivity = (dmpl__VisitTaskActivity__c)CollectionHelper.getObject(oldEntries, activity.Id);
                if((oldActivity.dmpl__Status__c != 'Completed') 
                    && (activity.dmpl__Email__c != oldActivity.dmpl__Email__c
                    || activity.dmpl__Phone__c != oldActivity.dmpl__Phone__c
                    || activity.dmpl__BooleanValue__c != oldActivity.dmpl__BooleanValue__c
                    || activity.dmpl__CurrencyValue__c != oldActivity.dmpl__CurrencyValue__c
                    || activity.dmpl__DateTimeValue__c != oldActivity.dmpl__DateTimeValue__c
                    || activity.dmpl__Date__c != oldActivity.dmpl__Date__c
                    || activity.dmpl__DecimalValue__c != oldActivity.dmpl__DecimalValue__c
                    || activity.dmpl__GeolocationValue__c != oldActivity.dmpl__GeolocationValue__c
                    || activity.dmpl__LongTextValue__c != oldActivity.dmpl__LongTextValue__c
                    || activity.dmpl__NumericValue__c != oldActivity.dmpl__NumericValue__c
                    || activity.dmpl__PerformAutomatically__c != oldActivity.dmpl__PerformAutomatically__c
                    || activity.dmpl__Status__c != oldActivity.dmpl__Status__c
                    || activity.dmpl__TextValue__c!= oldActivity.dmpl__TextValue__c
                    || activity.dmpl__URL__c!= oldActivity.dmpl__URL__c
                    || activity.dmpl__FieldValue__c!= oldActivity.dmpl__FieldValue__c
                    || activity.dmpl__SaleOrderId__c!= oldActivity.dmpl__SaleOrderId__c
                    || activity.dmpl__RepairOrderId__c!= oldActivity.dmpl__RepairOrderId__c
                    || activity.dmpl__InvoiceId__c!= oldActivity.dmpl__InvoiceId__c
                    || activity.dmpl__DeliveryOrderId__c!= oldActivity.dmpl__DeliveryOrderId__c
                    || activity.dmpl__ProductDemoId__c!= oldActivity.dmpl__ProductDemoId__c
                    || activity.dmpl__PaymentId__c!= oldActivity.dmpl__PaymentId__c)
                ){
                    activity.dmpl__Status__c = 'Completed';
                }
            }
    }

    private static void setActivityActions(
        List<dmpl__VisitTaskActivity__c> activities){
            List<dmpl__VisitTaskTemplateActivity__c> templates = [SELECT 
                Id, Name, dmpl__RelatedActivityAction__c, dmpl__RelatedVisitTaskTemplateActivityId__c FROM dmpl__VisitTaskTemplateActivity__c 
                WHERE Id IN : CollectionHelper.extractIds(activities, 'dmpl__VisitTaskTemplateActivityId__c')];
            List<dmpl__VisitTaskActivity__c> allActivities = queryAllActivities(activities);
            for(dmpl__VisitTaskActivity__c activity : activities){
                dmpl__VisitTaskTemplateActivity__c template = (dmpl__VisitTaskTemplateActivity__c)CollectionHelper.getObject(
                    templates, 
                    activity.dmpl__VisitTaskTemplateActivityId__c);
                if(template!=null && template.dmpl__RelatedVisitTaskTemplateActivityId__c != null){
                    if(template.dmpl__RelatedActivityAction__c == 'Repeat By Value'){
                        performRepeatAction(activity, template, allActivities);  
                    }else if(template.dmpl__RelatedActivityAction__c == 'Visible By Value'){
                        performVisibleAction(activity, template, allActivities);
                    }else if(template.dmpl__RelatedActivityAction__c == 'Enabled By Value'){
                        performEnabledAction(activity, template, allActivities);
                    }
                }
            }
    }

    private static List<dmpl__VisitTaskActivity__c> queryAllActivities(List<dmpl__VisitTaskActivity__c> activities){
        return [SELECT 
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
            dmpl__VisitTaskTemplateActivityId__c
            FROM dmpl__VisitTaskActivity__c 
            WHERE dmpl__VisitId__c IN : CollectionHelper.extractIds(activities, 'dmpl__VisitId__c')];
    }

    @testVisible
    private static void performRepeatAction(
        dmpl__VisitTaskActivity__c activity,
        dmpl__VisitTaskTemplateActivity__c template,
        List<dmpl__VisitTaskActivity__c> allActivities){
            if(activity.dmpl__NumericValue__c == null ||
                activity.dmpl__NumericValue__c <= 0){
                return;
            }
            List<dmpl__VisitTaskActivity__c> insertedActivities = new List<dmpl__VisitTaskActivity__c>();
            List<dmpl__VisitTaskActivity__c> targetActivities = CollectionHelper.getObjectsByFilter(
                allActivities, 
                'dmpl__VisitTaskTemplateActivityId__c', 
                template.Id);
            for(dmpl__VisitTaskActivity__c targetActivity : targetActivities){
                for(Integer i=0; i< activity.dmpl__NumericValue__c; i++) {
                    insertedActivities.add(targetActivity.clone(
                        false, 
                        true, 
                        true, 
                        false));
                }
            }
    }
 
    @testVisible
    private static void performVisibleAction(
        dmpl__VisitTaskActivity__c activity,
        dmpl__VisitTaskTemplateActivity__c template,
        List<dmpl__VisitTaskActivity__c> allActivities){
            if(activity.dmpl__BooleanValue__c == null){
                return;
            }       
            List<dmpl__VisitTaskActivity__c> updatedActivities = new List<dmpl__VisitTaskActivity__c>();
            List<dmpl__VisitTaskActivity__c> targetActivities = CollectionHelper.getObjectsByFilter(
                allActivities, 
                'dmpl__VisitTaskTemplateActivityId__c', 
                template.Id);
            for(dmpl__VisitTaskActivity__c targetActivity : targetActivities){
                targetActivity.dmpl__IsHidden__c = (!activity.dmpl__BooleanValue__c);
                updatedActivities.add(targetActivity);
            }
    }
    
    @testVisible
    private static void performEnabledAction(
        dmpl__VisitTaskActivity__c activity,
        dmpl__VisitTaskTemplateActivity__c template,
        List<dmpl__VisitTaskActivity__c> allActivities){
            if(activity.dmpl__BooleanValue__c == null){
                return;
            }       
            List<dmpl__VisitTaskActivity__c> updatedActivities = new List<dmpl__VisitTaskActivity__c>();
            List<dmpl__VisitTaskActivity__c> targetActivities = CollectionHelper.getObjectsByFilter(
                allActivities, 
                'dmpl__VisitTaskTemplateActivityId__c', 
                template.Id);
            for(dmpl__VisitTaskActivity__c targetActivity : targetActivities){
                targetActivity.dmpl__IsDisabled__c = (!activity.dmpl__BooleanValue__c);
                updatedActivities.add(targetActivity);
            }
    }

    @testVisible
    private static void setStatusTimeStamps(
        List<dmpl__VisitTaskActivity__c> modifiedEntries, 
        List<dmpl__VisitTaskActivity__c> oldEntries){
            for(dmpl__VisitTaskActivity__c activity : modifiedEntries){
                dmpl__VisitTaskActivity__c oldActivity = (dmpl__VisitTaskActivity__c)CollectionHelper.getObject(oldEntries, activity.Id);
                if(activity.dmpl__Status__c == 'Started' && oldActivity.dmpl__Status__c != 'Started'){
                    activity.dmpl__StartTime__c = Datetime.now().time();
                } else if(activity.dmpl__Status__c == 'Completed' && oldActivity.dmpl__Status__c != 'Completed'){
                    activity.dmpl__EndTime__c = Datetime.now().time();
                }
            }
    }
}