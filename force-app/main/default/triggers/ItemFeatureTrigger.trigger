trigger ItemFeatureTrigger on ItemFeature__c (before insert, before update, before delete, after insert, after update, after delete) {
    if(OrgSettingHelper.IsTriggerDisabled()){
      return;
    }
    if(Trigger.isBefore){
       ItemFeatureHelper.validateData(trigger.isInsert, trigger.isDelete, trigger.isUpdate, trigger.old, trigger.new);   
       ItemFeatureHelper.postData(trigger.isInsert, trigger.isDelete, trigger.isUpdate, trigger.old, trigger.new);     
     }
     new MetadataTriggerHandler().run();
 }