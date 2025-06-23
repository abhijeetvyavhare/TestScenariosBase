trigger SubscriptionTrigger on Subscription__c (before insert, before update, before delete, after insert, after update, after delete) {
    if(OrgSettingHelper.IsTriggerDisabled()){
        return;
    }
    if(Trigger.isBefore){
         SubscriptionHelper.validateData(trigger.isInsert, trigger.isUpdate, trigger.isDelete, trigger.old, trigger.new);   
    }
    new MetadataTriggerHandler().run();
}