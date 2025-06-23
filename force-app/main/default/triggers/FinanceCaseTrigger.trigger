trigger FinanceCaseTrigger on dmpl__FinanceCase__c (before insert, before update, before delete, after insert, after update, after delete) {
    if(OrgSettingHelper.IsTriggerDisabled()){
        return;
    }
    if(Trigger.isBefore){
         FinanceCaseHelper.validateData(trigger.isInsert, trigger.isDelete, trigger.isUpdate, trigger.old, trigger.new);
             
     }
     else if(Trigger.isAfter){
         FinanceCaseHelper.afterPostData(trigger.isInsert, trigger.isDelete, trigger.isUpdate, trigger.old, trigger.new);
     }
     new MetadataTriggerHandler().run();
 }