trigger GoodsReceiptTrigger on dmpl__GoodsReceipt__c (before insert, before update, before delete) {
    if(OrgSettingHelper.IsTriggerDisabled()){
        return;
    }
    GoodsReceiptHelper goodReceipt = new GoodsReceiptHelper();
    goodReceipt.validateData(trigger.isInsert, trigger.isUpdate, trigger.isDelete, trigger.old, trigger.new);
    goodReceipt.postData(trigger.isInsert, trigger.isUpdate, trigger.isDelete, trigger.old, trigger.new);
    new MetadataTriggerHandler().run();
}