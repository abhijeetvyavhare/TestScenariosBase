trigger SkuTrigger on dmpl__SKU__c (before insert, before update, before delete) {
    if(OrgSettingHelper.IsTriggerDisabled()){
        return;
    }
    SkuHelper.validateData(trigger.isInsert, trigger.isDelete, trigger.isUpdate, trigger.old, trigger.new);
    SkuHelper.postData(Trigger.isInsert, Trigger.isDelete, Trigger.isUpdate, Trigger.old, Trigger.new);
    new MetadataTriggerHandler().run();
}