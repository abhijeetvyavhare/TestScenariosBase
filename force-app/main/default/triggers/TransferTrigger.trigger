trigger TransferTrigger on dmpl__Transfer__C (before insert, before update, before delete) {
    if(OrgSettingHelper.IsTriggerDisabled()){
        return;
    }
    TransferHelper.validateData(trigger.isInsert, trigger.isDelete, trigger.isUpdate, trigger.old, trigger.new);
    TransferHelper.postData(trigger.isInsert, trigger.isDelete, trigger.isUpdate, trigger.old, trigger.new);
    new MetadataTriggerHandler().run();
}