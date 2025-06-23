trigger ServiceCampaignTrigger on ServiceCampaign__c (before insert, before update, before delete, after insert, after update, after delete) {
    if(OrgSettingHelper.IsTriggerDisabled()){
        return;
    }
    if(Trigger.isBefore){
        ServiceCampaignHelper.postData(Trigger.isInsert, Trigger.isUpdate, Trigger.isDelete, Trigger.new, Trigger.old);
    } 
    new MetadataTriggerHandler().run();
}