trigger InventoryAdjustmentTrigger on InventoryAdjustment__c (before insert, before update, before delete) {
   if(OrgSettingHelper.IsTriggerDisabled()){
      return;
   }
   InventoryAdjustmentHelper.validateData(Trigger.isInsert, Trigger.isDelete, Trigger.isUpdate, Trigger.old, Trigger.new);
   InventoryAdjustmentHelper.postData(Trigger.isInsert, Trigger.isDelete, Trigger.isUpdate, Trigger.old, Trigger.new);
   new MetadataTriggerHandler().run();
}