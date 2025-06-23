@isTest
public with sharing class DebitNoteHandler_Test {
    @TestSetup
    static void createRequiredData(){
        Account partnerAccount = TestDataHelpers.createPartnerAccount();
        dmpl__Branch__c branch =TestDataHelpers.createBranch(partnerAccount);    
        dmpl__DebitNote__c debitNote = DebitNoteTestDataHelpers.createDebitNote(Date.today());
    }

    @isTest
    static void createDebitNotePositive() {
        dmpl__DebitNote__c debitNote = DebitNoteTestDataHelpers.getDebitNote();
        System.assertEquals(200, debitNote.dmpl__AdjustedAmount__c, 'Adjusted amount mismatch');
    }
    
    @isTest
    static void createDebitNoteLinesPositive() {
        dmpl__DebitNote__c debitNote = DebitNoteTestDataHelpers.getDebitNote();
        dmpl__DebitNoteLines__c debitNoteLines = DebitNoteTestDataHelpers.createDebitNoteLines(debitNote.Id);
        System.assertEquals(20, debitNoteLines.dmpl__Amount__c, 'Amount mismatch');
        System.assertEquals('Test', debitNoteLines.dmpl__Description__c, 'Description mismatch');
    }
    
    @isTest
    static void updateDebitNotePositive() {
        dmpl__DebitNote__c debitNote = DebitNoteTestDataHelpers.getDebitNote();
        debitNote.dmpl__AdjustedAmount__c = 300;
        update debitNote;

        dmpl__DebitNote__c updatedDebitNote = DebitNoteTestDataHelpers.getDebitNote();
        System.assertEquals(300, updatedDebitNote.dmpl__AdjustedAmount__c, 'Adjusted amount should be updated to 300');
    }
    
    @isTest
    static void updateDebitNoteLinesPositive() {
        dmpl__DebitNote__c debitNote = DebitNoteTestDataHelpers.getDebitNote();
        dmpl__DebitNoteLines__c debitNoteLines = DebitNoteTestDataHelpers.createDebitNoteLines(debitNote.Id);
        debitNoteLines.dmpl__Amount__c = 30;
        debitNoteLines.dmpl__Description__c = 'Changed';
        update debitNoteLines;
        
        System.assertEquals(30, debitNoteLines.dmpl__Amount__c, 'Amount mismatch');
        System.assertEquals('Changed', debitNoteLines.dmpl__Description__c, 'Description mismatch');
    }
    
    @isTest
    static void deleteDebitNote() {
        dmpl__DebitNote__c debitNote = DebitNoteTestDataHelpers.getDebitNote();
        System.assertNotEquals(debitNote, null, 'Debit Note should exist before delete.');

        delete debitNote;

        dmpl__DebitNote__c deletedDebitNote = null;

        try {
            deletedDebitNote = DebitNoteTestDataHelpers.getDebitNote();
        } catch (Exception e) {   
            deletedDebitNote = null;
        }
        System.assertEquals(null, deletedDebitNote, 'Debit Note should be deleted and not found in query.');
    } 
    
    @isTest
    static void deleteDebitNoteLines() {
        dmpl__DebitNote__c debitNote = DebitNoteTestDataHelpers.getDebitNote();
        dmpl__DebitNoteLines__c debitNoteLines = DebitNoteTestDataHelpers.createDebitNoteLines(debitNote.Id);
    
        Id debitNoteLineId = debitNoteLines.Id;
        
        System.assertNotEquals(null, debitNoteLines, 'Debit Note Line should exist before delete.');
    
        delete debitNoteLines;
    
        List<dmpl__DebitNoteLines__c> deletedDebitNoteLines = DebitNoteTestDataHelpers.getDebitNoteLines(debitNoteLineId);
    
        System.assertEquals(0, deletedDebitNoteLines.size(), 'Debit Note Line should be deleted and not found in query.');
    }

}