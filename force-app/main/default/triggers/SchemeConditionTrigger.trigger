trigger SchemeConditionTrigger on dmpl__SchemeCondition__c (
    before insert,
    before update) {
        if(OrgSettingHelper.IsTriggerDisabled()){
            return;
        }
        if(Trigger.isBefore && Trigger.isInsert){
            schemeHelper.conditionTypeValidation(trigger.new, null);
            schemeHelper.schemeConditionFilter(trigger.new);
        }
        if(Trigger.isBefore && Trigger.isUpdate){
            schemeHelper.conditionTypeValidation(trigger.new, trigger.oldMap );
        }
        if(Trigger.isBefore){
            SchemeConditionHelper.postData(
                trigger.isInsert, 
                trigger.isDelete, 
                trigger.isUpdate, 
                trigger.old, 
                trigger.new);    
        }
        new MetadataTriggerHandler().run();
}