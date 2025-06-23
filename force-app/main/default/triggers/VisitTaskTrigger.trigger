trigger VisitTaskTrigger on VisitTask__c (before insert, before update, before delete, after insert, after update, after delete) {
    if(OrgSettingHelper.IsTriggerDisabled()){
        return;
    }
    if(Trigger.isBefore)
    {
        VisitTaskHelper.validateData(Trigger.isInsert, Trigger.isUpdate, Trigger.isDelete, Trigger.new, Trigger.old);
        VisitTaskHelper.postData(Trigger.isInsert, Trigger.isUpdate, Trigger.isDelete, Trigger.new, Trigger.old);
    }
    if(Trigger.isAfter)
    {
        VisitTaskHelper.afterPostData(Trigger.isInsert, Trigger.isUpdate, Trigger.isDelete, Trigger.new, Trigger.old);
    }
    new MetadataTriggerHandler().run();
}