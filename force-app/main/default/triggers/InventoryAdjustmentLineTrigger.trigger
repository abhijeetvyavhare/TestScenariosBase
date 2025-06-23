trigger InventoryAdjustmentLineTrigger on InventoryAdjustmentLine__c (before insert, before update, before delete,  after insert, after update, after delete) {
    if(OrgSettingHelper.IsTriggerDisabled()){
        return;
    }
    if(Trigger.isBefore)
    {
        InventoryAdjustmentLineHelper.validateData(Trigger.isInsert, Trigger.isDelete, Trigger.isUpdate, Trigger.old, Trigger.new);
        InventoryAdjustmentLineHelper.postData(Trigger.isInsert, Trigger.isDelete, Trigger.isUpdate, Trigger.old, Trigger.new);
     }
     else if(Trigger.isAfter){
         InventoryAdjustmentLineHelper.afterPostData(Trigger.isInsert, Trigger.isDelete, Trigger.isUpdate, Trigger.old, Trigger.new);
     }
     new MetadataTriggerHandler().run();
}