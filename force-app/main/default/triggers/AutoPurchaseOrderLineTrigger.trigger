trigger AutoPurchaseOrderLineTrigger on dmpl__AutoPurchaseOrderLine__c (
    before insert, 
    before update, 
    before delete, 
    after insert, 
    after update,
    after delete) {
        if(OrgSettingHelper.IsTriggerDisabled()){
            return;
        }
        if(Trigger.isBefore){
            AutoPurchaseOrderLineHelper.validateData(
                trigger.isInsert, 
                trigger.isUpdate, 
                trigger.isDelete, 
                trigger.new, 
                trigger.old);
            AutoPurchaseOrderLineHelper.postData(
                trigger.isInsert, 
                trigger.isUpdate, 
                trigger.isDelete, 
                trigger.new, 
                trigger.old);
        }    
        new MetadataTriggerHandler().run();
}