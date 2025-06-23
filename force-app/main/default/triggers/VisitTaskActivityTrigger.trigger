trigger VisitTaskActivityTrigger on VisitTaskActivity__c (
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
        VisitTaskActivityHelper.validateData(
            Trigger.isInsert, 
            Trigger.isUpdate, 
            Trigger.isDelete, 
            Trigger.new, 
            Trigger.old);
        VisitTaskActivityHelper.postData(
            Trigger.isInsert, 
            Trigger.isUpdate, 
            Trigger.isDelete, 
            Trigger.new, 
            Trigger.old);
    }
    if(Trigger.isAfter){
        VisitTaskActivityHelper.afterPostData(
            Trigger.isInsert, 
            Trigger.isUpdate, 
            Trigger.isDelete, 
            Trigger.new, 
            Trigger.old);
    }
    new MetadataTriggerHandler().run();
}