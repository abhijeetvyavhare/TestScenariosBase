trigger FieldSalesLineTrigger on dmpl__FieldSalesLine__c (before insert, before update, before delete) {
   if(OrgSettingHelper.IsTriggerDisabled()){
        return;
    }
    if(Trigger.isBefore){
        FieldSalesLineHelper.postData(trigger.isInsert, trigger.isDelete, trigger.isUpdate, trigger.old, trigger.new);
     }
     new MetadataTriggerHandler().run();
}