trigger RepairOrderLineTrigger on RepairOrderLine__c (before insert, before update, before delete, after insert, after update, after delete) {
    if(OrgSettingHelper.IsTriggerDisabled()){
        return;
    }
    if(Trigger.isBefore)
    {
        RepairOrderLineHelper.validateData(Trigger.isInsert, Trigger.isUpdate, Trigger.isDelete, Trigger.new, Trigger.old);                
        RepairOrderLineHelper.postData(Trigger.isInsert, Trigger.isUpdate, Trigger.isDelete, Trigger.new, Trigger.old);
    } else if(Trigger.isAfter) 
    {
        RepairOrderLineHelper.afterPostData(Trigger.isInsert, Trigger.isUpdate, Trigger.isDelete, Trigger.new, Trigger.old);    
    }
    new MetadataTriggerHandler().run();
}