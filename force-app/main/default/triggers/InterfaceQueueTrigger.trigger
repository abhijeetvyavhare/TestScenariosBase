trigger InterfaceQueueTrigger on dmpl__InterfaceQueue__c (
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
        InterfaceQueueHelper.validateData(
            Trigger.isInsert, 
            Trigger.isDelete, 
            Trigger.isUpdate, 
            Trigger.old, 
            Trigger.new);        
        InterfaceQueueHelper.postData(
            Trigger.isInsert, 
            Trigger.isDelete, 
            Trigger.isUpdate, 
            Trigger.old, 
            Trigger.new);   
    } else if(Trigger.isAfter){
        InterfaceQueueHelper.afterPostData(
            Trigger.isInsert, 
            Trigger.isUpdate, 
            Trigger.isDelete, 
            Trigger.old, 
            Trigger.new);
    }
    new MetadataTriggerHandler().run(); 
}