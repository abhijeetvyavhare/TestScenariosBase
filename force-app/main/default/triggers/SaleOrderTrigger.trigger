trigger SaleOrderTrigger on SaleOrder__c (
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
            SaleOrderHelper.validateData(
                Trigger.isInsert, 
                Trigger.isDelete, 
                Trigger.isUpdate, 
                Trigger.old, 
                Trigger.new);
            SaleOrderHelper.postData(
                Trigger.isInsert, 
                Trigger.isDelete, 
                Trigger.isUpdate, 
                Trigger.old, 
                Trigger.new);
        }
        else if(Trigger.isAfter){
            SaleOrderHelper.afterPostData(
                Trigger.isInsert, 
                Trigger.isDelete, 
                Trigger.isUpdate, 
                Trigger.old, 
                Trigger.new);
        }
        new MetadataTriggerHandler().run();
}