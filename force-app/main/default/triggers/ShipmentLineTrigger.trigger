trigger ShipmentLineTrigger on dmpl__ShipmentLine__c (before insert, before update, before delete,after insert, after update, after delete) {
    if(OrgSettingHelper.IsTriggerDisabled()){
        return;
    }
    if(Trigger.isBefore){
        ShipmentLineHelper.validateData(trigger.isInsert, trigger.isDelete, trigger.isUpdate, trigger.old, trigger.new);
        ShipmentLineHelper.postData(Trigger.isInsert, Trigger.isDelete, Trigger.isUpdate, Trigger.old, Trigger.new);
    }
    else if(Trigger.isAfter){
        ShipmentLineHelper.afterPostData(trigger.isInsert, trigger.isDelete, trigger.isUpdate, trigger.old, trigger.new);
    }
    new MetadataTriggerHandler().run();
 }