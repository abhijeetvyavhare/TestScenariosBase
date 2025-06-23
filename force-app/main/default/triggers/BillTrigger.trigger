trigger BillTrigger on dmpl__Bill__c (
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
            BillHelper.validateData(
                trigger.isInsert, 
                trigger.isDelete, 
                trigger.isUpdate, 
                trigger.old, 
                trigger.new);
            BillHelper.postData(
                Trigger.isInsert, 
                Trigger.isDelete, 
                Trigger.isUpdate, 
                Trigger.old,
                Trigger.new);    
        }else if(Trigger.isAfter){
            BillHelper.afterPostData(
                trigger.isInsert, 
                trigger.isDelete, 
                trigger.isUpdate, 
                trigger.old, 
                trigger.new);
        }
        new MetadataTriggerHandler().run();
}