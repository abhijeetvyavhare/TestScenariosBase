trigger InspectionLineTrigger on dmpl__InspectionLine__c (before insert, before update, before delete, after insert, after update, after delete) {
    if(OrgSettingHelper.IsTriggerDisabled()){
        return;
    }
    InspectionLineHelper inspectionLine = new InspectionLineHelper();
    if(Trigger.isBefore){
        inspectionLine.validateData(trigger.isInsert, trigger.isUpdate, trigger.isDelete, trigger.new, trigger.old);
        inspectionLine.postData(trigger.isInsert, trigger.isUpdate, trigger.isDelete, trigger.new, trigger.old);
    }
    else if(Trigger.isAfter){
        inspectionLine.afterPostData(trigger.isInsert, trigger.isUpdate, trigger.isDelete, trigger.new, trigger.old);
    }
    new MetadataTriggerHandler().run();
}