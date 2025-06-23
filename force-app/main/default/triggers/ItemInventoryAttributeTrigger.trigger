trigger ItemInventoryAttributeTrigger on ItemInventoryAttribute__c (before insert, before update, before delete, after insert, after update, after delete) {
    if(OrgSettingHelper.IsTriggerDisabled()){
        return;
    }
    if(Trigger.isBefore){
       ItemInventoryAttributeHelper.validateData(trigger.isInsert, trigger.isDelete, trigger.isUpdate, trigger.old, trigger.new);   
       ItemInventoryAttributeHelper.postData(trigger.isInsert, trigger.isDelete, trigger.isUpdate, trigger.old, trigger.new);     
     }
     new MetadataTriggerHandler().run();
 }