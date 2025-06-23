trigger BillReturnLineTrigger on dmpl__BillReturnLine__c (
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
            BillReturnLineHelper.validateData(
                trigger.isInsert, 
                trigger.isUpdate, 
                trigger.isDelete, 
                trigger.new, 
                trigger.old);
            BillReturnLineHelper.postData(
                trigger.isInsert, 
                trigger.isUpdate, 
                trigger.isDelete, 
                trigger.new, 
                trigger.old);
        }
        else if(Trigger.isAfter){
            BillReturnLineHelper.afterPostData(
                trigger.isInsert, 
                trigger.isDelete, 
                trigger.isUpdate, 
                trigger.old, 
                trigger.new);
        }
        new MetadataTriggerHandler().run();
}