trigger SaleReturnTrigger on SaleReturn__c (before insert, before update, before delete, after insert, after update, after delete) {
    if(OrgSettingHelper.IsTriggerDisabled()){
        return;
    }
    if(Trigger.isBefore){
         SaleReturnHelper.validateData(trigger.isInsert, trigger.isUpdate, trigger.isDelete, trigger.new, trigger.old);
         SaleReturnHelper.postData(trigger.isInsert, trigger.isUpdate, trigger.isDelete, trigger.new, trigger.old);
     }
     else if(Trigger.isAfter){
         SaleReturnHelper.afterPostData(trigger.isInsert, trigger.isUpdate, trigger.isDelete, trigger.new, trigger.old);
     }
    new MetadataTriggerHandler().run();
}