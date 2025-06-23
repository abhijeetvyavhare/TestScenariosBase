trigger CaseTrigger on dmpl__Case__c(
    before insert, 
    before update, 
    before delete, 
    after insert, 
    after update, 
    after delete){
        if(OrgSettingHelper.IsTriggerDisabled()){
            return;
        }
        if(Trigger.isBefore){
            CaseHelper.validateData(
                Trigger.isInsert, 
                Trigger.isUpdate, 
                Trigger.isDelete, 
                Trigger.new, 
                Trigger.old);
            CaseHelper.postData(
                Trigger.isInsert, 
                Trigger.isUpdate, 
                Trigger.isDelete, 
                Trigger.new, 
                Trigger.old);
        }

        if(Trigger.isAfter){
            CaseHelper.afterPostData(
                Trigger.isInsert, 
                Trigger.isUpdate, 
                Trigger.isDelete, 
                Trigger.new, 
                Trigger.old);
        }
        new MetadataTriggerHandler().run();
}