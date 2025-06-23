trigger RepairOrderTimeSheetTrigger on RepairOrderTimeSheet__c (before insert, before update, before delete, after insert, after update, after delete) {
    if(OrgSettingHelper.IsTriggerDisabled()){
        return;
    }
    if(Trigger.isBefore)
    {
        RepairOrderTimeSheetHelper.postData(Trigger.isInsert, Trigger.isDelete, Trigger.isUpdate, Trigger.old, Trigger.new);
    } else if(Trigger.isAfter)
    {
       RepairOrderTimeSheetHelper.afterPostData(Trigger.isInsert, Trigger.isDelete, Trigger.isUpdate, Trigger.old, Trigger.new);
    }
    new MetadataTriggerHandler().run();
}