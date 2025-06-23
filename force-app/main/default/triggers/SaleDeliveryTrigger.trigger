trigger SaleDeliveryTrigger on dmpl__DeliveryOrder__c (
    before insert, 
    before update, 
    before delete){
        if(OrgSettingHelper.IsTriggerDisabled()){
            return;
        }
        if(Trigger.isBefore)
        {
            SaleDeliveryHelper.validateData(
                Trigger.isInsert, 
                Trigger.isDelete, 
                Trigger.isUpdate, 
                Trigger.old, 
                Trigger.new);
            SaleDeliveryHelper.postData(
                Trigger.isInsert, 
                Trigger.isDelete, 
                Trigger.isUpdate, 
                Trigger.old, 
                Trigger.new);
        } else if(Trigger.isAfter){
            SaleDeliveryHelper.afterPostData(
                Trigger.isInsert, 
                Trigger.isDelete, 
                Trigger.isUpdate, 
                Trigger.old, 
                Trigger.new);
        }  
        new MetadataTriggerHandler().run(); 
}