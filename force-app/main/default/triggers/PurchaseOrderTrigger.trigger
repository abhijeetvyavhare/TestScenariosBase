trigger PurchaseOrderTrigger on dmpl__PurchaseOrder__c (before insert, before update, before delete, after insert, after update, after delete) 
{
    if(OrgSettingHelper.IsTriggerDisabled()){
        return;
    }
    if(Trigger.isBefore)
    {
        PurchaseOrderHelper.validateData(trigger.isInsert, trigger.isDelete, trigger.isUpdate, trigger.old, trigger.new);
        PurchaseOrderHelper.postData(Trigger.isInsert, Trigger.isDelete, Trigger.isUpdate, Trigger.old, Trigger.new);
    }
    else if(Trigger.isAfter)
    {
        PurchaseOrderHelper.afterPostData(Trigger.isInsert, Trigger.isDelete, Trigger.isUpdate, Trigger.old, Trigger.new);
    }
    new MetadataTriggerHandler().run();
}