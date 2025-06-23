trigger PaymentTrigger on Payment__c (
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
        PaymentHelper.validateData(
            trigger.isInsert, 
            trigger.isDelete, 
            trigger.isUpdate, 
            trigger.old, 
            trigger.new);    
        PaymentHelper.postData(
            trigger.isInsert, 
            trigger.isDelete, 
            trigger.isUpdate, 
            trigger.old, 
            trigger.new);    
    }else if(Trigger.isAfter){
        PaymentHelper.afterPostData(
            trigger.isInsert, 
            trigger.isDelete, 
            trigger.isUpdate, 
            trigger.old, 
            trigger.new);
    }
    new MetadataTriggerHandler().run();
 }