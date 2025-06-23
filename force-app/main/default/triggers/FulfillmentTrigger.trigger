trigger FulfillmentTrigger on dmpl__InventoryFulfillment__c (
        before insert, 
        before update, 
        before delete) {
        if(OrgSettingHelper.IsTriggerDisabled()){
                return;
        }
        FulfillmentHelper.validateData(trigger.isInsert, trigger.isDelete, trigger.isUpdate,  trigger.old, trigger.new);
        FulfillmentHelper.postData(trigger.isInsert, trigger.isDelete, trigger.isUpdate,  trigger.old, trigger.new );
        new MetadataTriggerHandler().run();
}