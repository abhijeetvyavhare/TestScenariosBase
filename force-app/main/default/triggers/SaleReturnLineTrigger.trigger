trigger SaleReturnLineTrigger on dmpl__SaleReturnLine__c (before insert,before update, before delete, after insert, after update, after delete){
    if(OrgSettingHelper.IsTriggerDisabled()){
        return;
    }
    if(Trigger.isBefore){
         SaleReturnLineHelper.validateData(trigger.isInsert, trigger.isUpdate, trigger.isDelete, trigger.new, trigger.old);
         SaleReturnLineHelper.postData(trigger.isInsert, trigger.isUpdate, trigger.isDelete, trigger.new, trigger.old);
     }
     else if(Trigger.isAfter){
         SaleReturnLineHelper.afterPostData(trigger.isInsert, trigger.isDelete, trigger.isUpdate,  trigger.old, trigger.new);
     }
    new MetadataTriggerHandler().run();
}