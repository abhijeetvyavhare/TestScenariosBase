trigger ItemLotTrigger on ItemLot__c (before insert, before update, before delete) {
    if(OrgSettingHelper.IsTriggerDisabled()){
        return;
    }
    ItemLotHelper.validateData(Trigger.isInsert, Trigger.isDelete, Trigger.isUpdate, Trigger.old, Trigger.new);
    new MetadataTriggerHandler().run();
}