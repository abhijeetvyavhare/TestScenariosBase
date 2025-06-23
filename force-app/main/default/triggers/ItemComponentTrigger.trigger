trigger ItemComponentTrigger on ItemComponent__c (before insert, before update, before delete, after insert, after update, after delete) {
    if(OrgSettingHelper.IsTriggerDisabled()){
        return;
    }
    if(Trigger.isBefore){
       ItemComponentHelper.validateData(trigger.isInsert, trigger.isDelete, trigger.isUpdate, trigger.old, trigger.new);   
       ItemComponentHelper.postData(trigger.isInsert, trigger.isDelete, trigger.isUpdate, trigger.old, trigger.new);     
     }
     new MetadataTriggerHandler().run();
 }