trigger AutoPurchaseOrderTrigger on AutoPurchaseOrder__c (
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
            AutoPurchaseOrderHelper.validateData(
                trigger.isInsert, 
                trigger.isUpdate, 
                trigger.isDelete, 
                trigger.new, 
                trigger.old);
            AutoPurchaseOrderHelper.postData(
                trigger.isInsert, 
                trigger.isUpdate, 
                trigger.isDelete, 
                trigger.new, 
                trigger.old);    
        }
        else if(Trigger.isAfter){
            AutoPurchaseOrderHelper.afterPostData(
                trigger.isInsert, 
                trigger.isUpdate, 
                trigger.isDelete, 
                trigger.new, 
                trigger.old);
        }
        new MetadataTriggerHandler().run();
}