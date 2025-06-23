trigger BranchTrigger on   dmpl__Branch__c (before insert, before update, before delete) {
    if(OrgSettingHelper.IsTriggerDisabled()){
        return;
    }
    BranchHelper.validateData(trigger.isInsert, trigger.isUpdate, trigger.isDelete, trigger.new, trigger.old);
    BranchHelper.postData(Trigger.isInsert, Trigger.isDelete, Trigger.isUpdate, Trigger.old, Trigger.new);    
    new MetadataTriggerHandler().run();
}