trigger BranchTimeSlotTrigger on  dmpl__BranchTimeSlot__c (
    before insert, 
    before update, 
    before delete) {
        if(OrgSettingHelper.IsTriggerDisabled()){
            return;
        }
        BranchTimeSlotHelper.validateData(trigger.isInsert, trigger.isDelete, trigger.isUpdate, trigger.old, trigger.new);
        new MetadataTriggerHandler().run();
}