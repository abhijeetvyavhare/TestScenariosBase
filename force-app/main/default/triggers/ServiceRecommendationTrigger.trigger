trigger ServiceRecommendationTrigger on ServiceRecommendation__c (before insert, before update, before delete, after insert, after update, after delete) 
{
    if(OrgSettingHelper.IsTriggerDisabled()){
        return;
    }
    if(Trigger.isBefore)
    {
        ServiceRecommendationHelper.postData(Trigger.isInsert, Trigger.isUpdate, Trigger.isDelete, Trigger.new , Trigger.old);
    }
    new MetadataTriggerHandler().run();
}