trigger IncentivePlanTrigger on dmpl__IncentivePlan__c (
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
            IncentivePlanHelper.validateData(
                Trigger.isInsert, 
                Trigger.isDelete, 
                Trigger.isUpdate, 
                Trigger.old, 
                Trigger.new);
            IncentivePlanHelper.postData(
                trigger.isInsert, 
                trigger.isDelete, 
                trigger.isUpdate, 
                trigger.old, 
                trigger.new);
        }else if(Trigger.isAfter){
            IncentivePlanHelper.afterPostData(
                trigger.isInsert, 
                trigger.isDelete, 
                trigger.isUpdate, 
                trigger.old, 
                trigger.new);    
        }
        new MetadataTriggerHandler().run();
}