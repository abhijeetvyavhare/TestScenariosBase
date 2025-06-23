trigger IncentiveTargetTrigger on dmpl__IncentiveTarget__c (
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
            IncentiveTargetHelper.validateData(
                Trigger.isInsert, 
                Trigger.isDelete, 
                Trigger.isUpdate, 
                Trigger.old, 
                Trigger.new);
            IncentiveTargetHelper.postData(
                trigger.isInsert, 
                trigger.isDelete, 
                trigger.isUpdate, 
                trigger.old, 
                trigger.new);
        }else if(Trigger.isAfter){
            IncentiveTargetHelper.afterPostData(
                trigger.isInsert, 
                trigger.isDelete, 
                trigger.isUpdate, 
                trigger.old, 
                trigger.new);    
        }
        new MetadataTriggerHandler().run();
}