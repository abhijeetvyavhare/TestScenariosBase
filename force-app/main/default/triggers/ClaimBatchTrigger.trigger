trigger ClaimBatchTrigger on ClaimBatch__c (before insert, before update, before delete, after insert, after update, after delete) {
    if(OrgSettingHelper.IsTriggerDisabled()){
        return;
    }
    if(Trigger.isBefore)
    {
        ClaimBatchHelper.validateData(Trigger.isInsert, Trigger.isUpdate, Trigger.isDelete, Trigger.new, Trigger.old);
        ClaimBatchHelper.postData(Trigger.isInsert, Trigger.isUpdate, Trigger.isDelete, Trigger.new, Trigger.old);
    } else if(Trigger.isAfter)
    {
        ClaimBatchHelper.afterPostData(Trigger.isInsert, Trigger.isUpdate, Trigger.isDelete, Trigger.new, Trigger.old);
    }
    new MetadataTriggerHandler().run();
}