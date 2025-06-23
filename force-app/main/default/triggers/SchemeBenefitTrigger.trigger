trigger SchemeBenefitTrigger on dmpl__SchemeBenefit__c (before insert,before update) {
  if(OrgSettingHelper.IsTriggerDisabled()){
      return;
  }
  if(Trigger.isBefore && Trigger.isInsert){
      schemeHelper.rewardTypeValidation(trigger.new, null);
  }
  if(Trigger.isBefore && Trigger.isUpdate){
      schemeHelper.rewardTypeValidation(trigger.new, trigger.oldMap );
  }
  if(Trigger.isBefore){
    SchemeBenefitHelper.postData(
        trigger.isInsert, 
        trigger.isDelete, 
        trigger.isUpdate, 
        trigger.old, 
        trigger.new);    
}
  new MetadataTriggerHandler().run();
}