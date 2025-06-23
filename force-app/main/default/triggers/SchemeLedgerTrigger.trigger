trigger SchemeLedgerTrigger on dmpl__SchemeLedger__c (
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
        SchemeLedgerHelper.validateData(
            trigger.isInsert, 
            trigger.isDelete, 
            trigger.isUpdate, 
            trigger.old, 
            trigger.new);    
    }
    
     if(Trigger.isBefore){
        SchemeLedgerHelper.postData(
            trigger.isInsert, 
            trigger.isDelete, 
            trigger.isUpdate, 
            trigger.old, 
            trigger.new);    
    }

    if(Trigger.isAfter){
            SchemeLedgerHelper.afterPostData(
                trigger.isInsert, 
                trigger.isDelete, 
                trigger.isUpdate, 
                trigger.old, 
                trigger.new);    
        }
        new MetadataTriggerHandler().run();
}