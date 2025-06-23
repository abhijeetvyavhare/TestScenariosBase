trigger SaleDeliveryLineTrigger on dmpl__DeliveryOrderLine__c (
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
         SaleDeliveryLineHelper.validateData(
            trigger.isInsert, 
            trigger.isDelete, 
            trigger.isUpdate, 
            trigger.old, 
            trigger.new); 
         SaleDeliveryLineHelper.postData(
            trigger.isInsert, 
            trigger.isDelete, 
            trigger.isUpdate, 
            trigger.old, 
            trigger.new);   
     }
     else if(Trigger.isAfter){
         SaleDeliveryLineHelper.afterPostData(
            trigger.isInsert, 
            trigger.isDelete, 
            trigger.isUpdate, 
            trigger.old, 
            trigger.new);
     }
     new MetadataTriggerHandler().run();
 }