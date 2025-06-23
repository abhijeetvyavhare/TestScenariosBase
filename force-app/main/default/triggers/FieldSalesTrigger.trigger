trigger FieldSalesTrigger on dmpl__FieldSales__c (
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
            FieldSalesHelper.validateData(
                trigger.isInsert, 
                trigger.isDelete, 
                trigger.isUpdate, 
                trigger.old, 
                trigger.new);
            FieldSalesHelper.postData(
                trigger.isInsert, 
                trigger.isDelete, 
                trigger.isUpdate, 
                trigger.old, 
                trigger.new);    
        }
        new MetadataTriggerHandler().run();
}