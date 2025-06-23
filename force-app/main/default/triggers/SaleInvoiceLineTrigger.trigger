trigger SaleInvoiceLineTrigger on SaleInvoiceLine__c (before insert, before update, before delete, after insert, after update, after delete) {
    if(OrgSettingHelper.IsTriggerDisabled()){
        return;
    }
    if(Trigger.isBefore){
         SaleInvoiceLineHelper.validateData(trigger.isInsert, trigger.isDelete, trigger.isUpdate, trigger.old, trigger.new);
         SaleInvoiceLineHelper.postData(Trigger.isInsert, Trigger.isDelete, Trigger.isUpdate, Trigger.old, Trigger.new);    
     }
     else if(Trigger.isAfter){
         SaleInvoiceLineHelper.afterPostData(trigger.isInsert, trigger.isDelete, trigger.isUpdate, trigger.old, trigger.new);
     }
    new MetadataTriggerHandler().run();
 }