trigger SchemeTrigger on dmpl__Scheme__c (
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
            SchemeHelper.validateData(
                Trigger.isInsert, 
                Trigger.isDelete, 
                Trigger.isUpdate, 
                Trigger.old, 
                Trigger.new);
            SchemeHelper.postData(
                trigger.isInsert, 
                trigger.isDelete, 
                trigger.isUpdate, 
                trigger.old, 
                trigger.new);
        }else if(Trigger.isAfter){
            SchemeHelper.afterPostData(
                trigger.isInsert, 
                trigger.isDelete, 
                trigger.isUpdate, 
                trigger.old, 
                trigger.new);    
        }
        new MetadataTriggerHandler().run();
}