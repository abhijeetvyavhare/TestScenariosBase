trigger CreditNoteTrigger on dmpl__CreditNote__c (
    before insert, 
    before update, 
    before delete,
    after insert, 
    after update, 
    after delete) {
        new MetadataTriggerHandler().run();
}