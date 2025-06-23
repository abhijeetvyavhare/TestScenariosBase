trigger VisitTrigger on Visit__c (
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
        VisitHelper.validateData(
            Trigger.isInsert, 
            Trigger.isUpdate, 
            Trigger.isDelete, 
            Trigger.new, 
            Trigger.old);
        VisitHelper.postData(
            Trigger.isInsert, 
            Trigger.isUpdate, 
            Trigger.isDelete, 
            Trigger.new, 
            Trigger.old);
    }
    if(Trigger.isAfter){
        VisitHelper.afterPostData(
            Trigger.isInsert, 
            Trigger.isUpdate, 
            Trigger.isDelete, 
            Trigger.new, 
            Trigger.old);
    }
    new MetadataTriggerHandler().run();
}