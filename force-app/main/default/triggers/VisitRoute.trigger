trigger VisitRoute on dmpl__VisitRoute__c (
    before insert, 
    before update, 
    before delete, 
    after insert, 
    after update, 
    after delete) {
        new MetadataTriggerHandler().run();                 
}