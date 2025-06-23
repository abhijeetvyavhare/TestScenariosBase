trigger ClaimLine on ClaimLine__c (
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
        ClaimLineHelper.validateData(
            Trigger.isInsert, 
            Trigger.isUpdate, 
            Trigger.isDelete, 
            Trigger.new, 
            Trigger.old);
        ClaimLineHelper.postData(
            Trigger.isInsert, 
            Trigger.isUpdate, 
            Trigger.isDelete, 
            Trigger.new, 
            Trigger.old);    
    }

    if(Trigger.isAfter){
        ClaimLineHelper.afterPostData(
            Trigger.isInsert, 
            Trigger.isUpdate, 
            Trigger.isDelete, 
            Trigger.new, 
            Trigger.old);
    }
    new MetadataTriggerHandler().run();
}