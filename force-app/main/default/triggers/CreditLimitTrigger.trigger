trigger CreditLimitTrigger on CreditLimit__c (before insert, before update, before delete) {
    if(OrgSettingHelper.IsTriggerDisabled()){
        return;
    }
    CreditLimitHelper.validateData(trigger.isInsert, trigger.isDelete, trigger.isUpdate, trigger.old, trigger.new);
    new MetadataTriggerHandler().run();
}