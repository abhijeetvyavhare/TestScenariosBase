trigger PurchaseRequisitionLineTrigger on dmpl__PurchaseRequisitionLine__c (
    before insert, 
    before update, 
    before delete,
    after insert,
    after update,
    after delete) {
    new MetadataTriggerHandler().run();
}