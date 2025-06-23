trigger ServiceLeadTrigger on ServiceLead__c (
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
        ServiceLeadHelper.validateData(
            Trigger.isInsert, 
            Trigger.isUpdate, 
            Trigger.isDelete, 
            Trigger.new, 
            Trigger.old);
        ServiceLeadHelper.postData(
            Trigger.isInsert, 
            Trigger.isUpdate, 
            Trigger.isDelete, 
            Trigger.new, 
            Trigger.old);
    }

    if(Trigger.isAfter){
        ServiceLeadHelper.afterPostData(
            Trigger.isInsert, 
            Trigger.isUpdate, 
            Trigger.isDelete, 
            Trigger.new, 
            Trigger.old);
    }
    new MetadataTriggerHandler().run();
}