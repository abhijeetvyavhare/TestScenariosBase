trigger ItemMaintenanceScheduleTrigger on ItemMaintenanceSchedule__c (before insert, before update, before delete, after insert, after update, after delete) {
    if(OrgSettingHelper.IsTriggerDisabled()){
        return;
    }
    if(Trigger.isBefore){
       ItemMaintenanceScheduleHelper.validateData(trigger.isInsert, trigger.isDelete, trigger.isUpdate, trigger.old, trigger.new);   
       ItemMaintenanceScheduleHelper.postData(trigger.isInsert, trigger.isDelete, trigger.isUpdate, trigger.old, trigger.new);     
     }
     new MetadataTriggerHandler().run();
 }