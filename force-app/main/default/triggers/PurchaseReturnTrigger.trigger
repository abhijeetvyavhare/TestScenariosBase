trigger PurchaseReturnTrigger on PurchaseReturn__c (before insert, before update, before delete, after insert, after update, after delete) {
    if(OrgSettingHelper.IsTriggerDisabled()){
        return;
    } 
    if(Trigger.isBefore){
         PurchaseReturnHelper.validateData(trigger.isInsert, trigger.isUpdate, trigger.isDelete, trigger.new, trigger.old);
         PurchaseReturnHelper.postData(trigger.isInsert, trigger.isUpdate, trigger.isDelete, trigger.new, trigger.old);    
     }
     else if(Trigger.isAfter){
         PurchaseReturnHelper.afterPostData(trigger.isInsert, trigger.isUpdate, trigger.isDelete, trigger.new, trigger.old);
     }
    new MetadataTriggerHandler().run();
}