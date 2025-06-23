trigger QuoteLineTrigger on dmpl__QuoteLine__c (before insert, before update, before delete, after insert, after update, after delete) {
    if(OrgSettingHelper.IsTriggerDisabled()){
        return;
    }
    if(Trigger.isBefore)
    {
       ServiceEstimateLineHelper.validateData(Trigger.isInsert, Trigger.isUpdate, Trigger.isDelete, Trigger.new, Trigger.old);                
       ServiceEstimateLineHelper.postData(Trigger.isInsert, Trigger.isUpdate, Trigger.isDelete, Trigger.new, Trigger.old);
    } else if(Trigger.isAfter) 
    {
        ServiceEstimateLineHelper.afterPostData(Trigger.isInsert, Trigger.isUpdate, Trigger.isDelete, Trigger.new, Trigger.old);    
    }
    new MetadataTriggerHandler().run();
}