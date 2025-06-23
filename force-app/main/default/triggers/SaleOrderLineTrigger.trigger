trigger SaleOrderLineTrigger on SaleOrderLine__c (before insert, before update, before delete, after insert, after update, after delete) {
    if(OrgSettingHelper.IsTriggerDisabled()){
        return;
    }
    if(Trigger.isBefore){
        SaleOrderLineHelper.validateData(trigger.isInsert, trigger.isDelete, trigger.isUpdate, trigger.old, trigger.new);
        SaleOrderLineHelper.postData(Trigger.isInsert, Trigger.isDelete, Trigger.isUpdate, Trigger.old, Trigger.new);    
     }
     else if(Trigger.isAfter){
        SaleOrderLineHelper.afterPostData(trigger.isInsert, trigger.isDelete, trigger.isUpdate, trigger.old, trigger.new);
     }
    new MetadataTriggerHandler().run();
 }