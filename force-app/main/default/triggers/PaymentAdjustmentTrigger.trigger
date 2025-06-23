trigger PaymentAdjustmentTrigger on dmpl__PaymentAdjustment__c(
    before insert, 
    before update, 
    before delete) {
        if(OrgSettingHelper.IsTriggerDisabled()){
            return;
        }
        PaymentAdjustmentHelper.validateData(
            trigger.isInsert, 
            trigger.isDelete, 
            trigger.isUpdate, 
            trigger.old, 
            trigger.new);

        PaymentAdjustmentHelper.postData(
            Trigger.isInsert, 
            Trigger.isDelete, 
            Trigger.isUpdate, 
            Trigger.old, 
            Trigger.new);   
        new MetadataTriggerHandler().run();
}