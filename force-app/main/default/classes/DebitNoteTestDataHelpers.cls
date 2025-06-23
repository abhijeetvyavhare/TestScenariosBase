public with sharing class DebitNoteTestDataHelpers {
    public static dmpl__DebitNote__c createDebitNote(
        Date dateToday
    ) {
        return (dmpl__DebitNote__c) TestFactory.createSObject(
            new dmpl__DebitNote__c(
                dmpl__DocumentDate__c = dateToday
            ),
            'DebitNoteDefaults',
            true
        );
    }
    
    public static dmpl__DebitNote__c getDebitNote() {
        return [
            SELECT Id, Name, dmpl__DocumentDate__c, dmpl__AdjustedAmount__c
            FROM dmpl__DebitNote__c
            LIMIT 1
        ];
    }
    
    public static dmpl__DebitNoteLines__c createDebitNoteLines(
        Id debitNoteId
    ) {
        return (dmpl__DebitNoteLines__c) TestFactory.createSObject(
            new dmpl__DebitNoteLines__c(
                dmpl__DebitNoteId__c = debitNoteId
            ),
            'DebitNoteLinesDefaults',
            true
        );
    }
    
    public static dmpl__DebitNoteLines__c getDebitNoteLines() {
        return [
            Select Id 
            FROM dmpl__DebitNoteLines__c
            LIMIT 1
        ];
    }
    
    public static List<dmpl__DebitNoteLines__c> getDebitNoteLines(Id id) {
        return [
            Select Id 
            FROM dmpl__DebitNoteLines__c
            WHERE Id = :id
        ];
    }
}