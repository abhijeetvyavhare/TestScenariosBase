trigger CycleCountTrigger on InventoryCycleCount__c (
    before insert, 
    before update, 
    before delete, 
    after insert, 
    after update, 
    after delete) {
        new MetadataTriggerHandler().run();
}