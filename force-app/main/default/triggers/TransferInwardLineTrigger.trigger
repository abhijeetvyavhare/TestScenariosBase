trigger TransferInwardLineTrigger on dmpl__TransferInwardLine__c (before insert, before update, before delete) {
    if(OrgSettingHelper.IsTriggerDisabled()){
        return;
    }
    TransferInwardLineHelper.validateData(trigger.isInsert, trigger.isDelete, trigger.isUpdate, trigger.old, trigger.new);
    TransferInwardLineHelper.postData(trigger.isInsert, trigger.isDelete, trigger.isUpdate, trigger.old, trigger.new);
    new MetadataTriggerHandler().run();
}