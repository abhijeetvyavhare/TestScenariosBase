trigger GoodsReceiptLineTrigger on GoodsReceiptLine__c (before insert, before update, before delete, after insert, after update, after delete) {
    if(OrgSettingHelper.IsTriggerDisabled()){
        return;
    }
    if(Trigger.isBefore){
         GoodReceiptLineHelper.validateData(Trigger.isInsert, Trigger.isUpdate, Trigger.isDelete, Trigger.new, Trigger.old);
         GoodReceiptLineHelper.postData(Trigger.isInsert, Trigger.isUpdate, Trigger.isDelete, Trigger.new,Trigger.old);    
     }
     else if(Trigger.isAfter){
         GoodReceiptLineHelper.afterPostData(trigger.isInsert, trigger.isUpdate,trigger.isDelete,trigger.new,trigger.old);
     }
    new MetadataTriggerHandler().run();
 }