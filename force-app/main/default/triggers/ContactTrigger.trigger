trigger ContactTrigger on Contact (before insert, before update, before delete,after insert, after update, after delete) {
    if(OrgSettingHelper.IsTriggerDisabled()){
        return;
    }
    if(Trigger.isBefore)
    {
        ContactHelper.validateData(trigger.isInsert, trigger.isDelete, trigger.isUpdate, trigger.old, trigger.new);
        ContactHelper.postData(Trigger.isInsert, Trigger.isDelete, Trigger.isUpdate, Trigger.old, Trigger.new);    
    }
    else if(Trigger.isAfter)
    {
        ContactHelper.afterPostData(Trigger.isInsert, Trigger.isDelete, Trigger.isUpdate, Trigger.old, Trigger.new);    
    }
    new MetadataTriggerHandler().run();
}