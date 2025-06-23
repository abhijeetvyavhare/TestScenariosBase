trigger PurchaseReturnLineTrigger on dmpl__PurchaseReturnLine__c (before insert, before update, before delete, after insert, after update, after delete) {
    if(OrgSettingHelper.IsTriggerDisabled()){
        return;
    }
    if(Trigger.isBefore){
         PurchaseReturnLineHelper.validateData(trigger.isInsert, trigger.isUpdate, trigger.isDelete, trigger.new, trigger.old);
         PurchaseReturnLineHelper.postData(trigger.isInsert, trigger.isUpdate, trigger.isDelete, trigger.new, trigger.old);
     }
     else if(Trigger.isAfter){
         PurchaseReturnLineHelper.afterPostData(trigger.isInsert, trigger.isDelete, trigger.isUpdate, trigger.old, trigger.new);
     }
    new MetadataTriggerHandler().run();
}