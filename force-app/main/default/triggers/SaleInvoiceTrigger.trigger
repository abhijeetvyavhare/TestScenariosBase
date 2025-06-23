trigger SaleInvoiceTrigger on SaleInvoice__c (before insert, before update, before delete, after insert, after update, after delete) {
    if(OrgSettingHelper.IsTriggerDisabled()){
        return;
    }
    if(Trigger.isBefore)
    {
        SaleInvoiceHelper.validateData(Trigger.isInsert, Trigger.isDelete, Trigger.isUpdate, Trigger.old, Trigger.new);
        SaleInvoiceHelper.postData(trigger.isInsert, trigger.isDelete, trigger.isUpdate, trigger.old, trigger.new);
    }
    else if(Trigger.isAfter)
    {
        SaleInvoiceHelper.afterPostData(trigger.isInsert, trigger.isDelete, trigger.isUpdate, trigger.old, trigger.new);    
    }
    new MetadataTriggerHandler().run();
}