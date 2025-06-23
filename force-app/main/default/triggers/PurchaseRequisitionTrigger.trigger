trigger PurchaseRequisitionTrigger on PurchaseRequisition__c (before insert, before update, before delete) {
    if(OrgSettingHelper.IsTriggerDisabled()){
        return;
    }
    PurchaseRequisitionHelper.validateData(Trigger.isInsert, Trigger.isDelete, Trigger.isUpdate, Trigger.old, Trigger.new);
    PurchaseRequisitionHelper.postData(Trigger.isInsert, Trigger.isDelete, Trigger.isUpdate, Trigger.old, Trigger.new);
    // new MetadataTriggerHandler().run();
}