trigger VisitPlanTrigger on VisitPlan__c (before insert, before update, before delete, after insert, after update, after delete) 
{
    if(OrgSettingHelper.IsTriggerDisabled()){
        return;
    }
    if(Trigger.isBefore)
    {
        VisitPlanHelper.validateData(Trigger.isInsert, Trigger.isUpdate, Trigger.isDelete, Trigger.new, Trigger.old);
        VisitPlanHelper.postData(Trigger.isInsert, Trigger.isUpdate, Trigger.isDelete, Trigger.new, Trigger.old);
    }
    else if(Trigger.isAfter)
    {
        VisitPlanHelper.afterPostData(Trigger.isInsert, Trigger.isUpdate, Trigger.isDelete, Trigger.new, Trigger.old);
    }
    new MetadataTriggerHandler().run();
}