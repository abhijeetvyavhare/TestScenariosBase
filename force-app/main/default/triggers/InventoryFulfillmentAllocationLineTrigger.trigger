trigger InventoryFulfillmentAllocationLineTrigger on InventoryFulfillmentAllocationLine__c (before insert, before update, before delete, after insert, after update, after delete) {
    if(OrgSettingHelper.IsTriggerDisabled()){
        return;
    }
    if(Trigger.isBefore){
        InventoryFulfillmentAllocationLineHelper.validateData(trigger.isInsert, trigger.isUpdate, trigger.isDelete, trigger.new, trigger.old);
        InventoryFulfillmentAllocationLineHelper.postData(trigger.isInsert, trigger.isUpdate, trigger.isDelete, trigger.new, trigger.old);
    }
    else if(Trigger.isAfter){
        InventoryFulfillmentAllocationLineHelper.afterPostData(trigger.isInsert, trigger.isUpdate, trigger.isDelete, trigger.new, trigger.old);
    }
    new MetadataTriggerHandler().run();
}