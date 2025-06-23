trigger DebitNoteLineTrigger on dmpl__DebitNoteLines__c (
    before insert, 
    before update, 
    before delete,
    after insert, 
    after update, 
    after delete
) {
	new MetadataTriggerHandler().run();
}