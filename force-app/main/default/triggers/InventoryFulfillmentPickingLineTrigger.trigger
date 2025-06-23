trigger InventoryFulfillmentPickingLineTrigger on InventoryFulfillmentPickingLine__c (
    before insert, 
    before update, 
    before delete, 
    after insert, 
    after update, 
    after delete) {
    if(OrgSettingHelper.IsTriggerDisabled()){
        return;
    }
    if(Trigger.isBefore){
        InventoryFulfillmentPickingLineHelper.validateData(trigger.isInsert, trigger.isUpdate, trigger.isDelete, trigger.new, trigger.old);
        InventoryFulfillmentPickingLineHelper.postData(trigger.isInsert, trigger.isUpdate, trigger.isDelete, trigger.new, trigger.old);
    }
    else if(Trigger.isAfter){
        InventoryFulfillmentPickingLineHelper.afterPostData(trigger.isInsert, trigger.isUpdate, trigger.isDelete, trigger.new, trigger.old);
    }
    new MetadataTriggerHandler().run();
}