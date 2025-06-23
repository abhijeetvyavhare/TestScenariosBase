trigger ClaimTrigger on dmpl__Claim__c (before insert, before update, before delete, after insert, after update, after delete) {
    if(OrgSettingHelper.IsTriggerDisabled()){
        return;
    }
    if(Trigger.isBefore)
    {
        ClaimHelper.validateData(Trigger.isInsert, Trigger.isUpdate, Trigger.isDelete, Trigger.new, Trigger.old);
        ClaimHelper.postData(Trigger.isInsert, Trigger.isUpdate, Trigger.isDelete, Trigger.new, Trigger.old);
    } else if(Trigger.isAfter)
    {
        ClaimHelper.afterPostData(Trigger.isInsert, Trigger.isUpdate, Trigger.isDelete, Trigger.new, Trigger.old);
    }
    new MetadataTriggerHandler().run();
}