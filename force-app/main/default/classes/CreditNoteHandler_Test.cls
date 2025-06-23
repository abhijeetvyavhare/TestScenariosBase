@isTest
public with sharing class CreditNoteHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Account partnerAccount = TestDataHelpers.createPartnerAccount();
        Id partnerAccountId = partnerAccount.Id;
        dmpl__Branch__c branch = TestDataHelpers.createBranch(partnerAccount);
        dmpl__CreditNote__c creditNote = CreditNoteDataHelper.createCreditNote(partnerAccountId, branch.Id);
        List<dmpl__CreditNoteLine__c> lines = CreditNoteDataHelper.createCreditNoteLines(creditNote.Id);
    }  

    @isTest
    static void createCreditNotePositive() {
        dmpl__CreditNote__c note = CreditNoteDataHelper.getCreditNote();
        System.assertNotEquals(note, null, 'Expected Credit Note to be created.');
        System.assertEquals('INR', note.dmpl__Currency__c, 'Expected currency to be INR.');
    }
    
    @isTest
    static void updateCreditNotePositive() {
        dmpl__CreditNote__c note = CreditNoteDataHelper.getCreditNote();
        note.dmpl__Notes__c = 'Updated credit note';
        update note;

        dmpl__CreditNote__c updatedNote = CreditNoteDataHelper.getCreditNote(note.Id);
        System.assertEquals('Updated credit note', updatedNote.dmpl__Notes__c, 'Expected note update.');
    }
    
    @isTest
    static void deleteCreditNote() {
        dmpl__CreditNote__c note = CreditNoteDataHelper.getCreditNote();
        delete note;

        Integer count = [SELECT COUNT() FROM dmpl__CreditNote__c WHERE Id = :note.Id];
        System.assertEquals(0, count, 'Expected Credit Note to be deleted.');
    }

    @isTest
    static void createCreditNoteLinesPositive() {
        dmpl__CreditNote__c note = CreditNoteDataHelper.getCreditNote();
        List<dmpl__CreditNoteLine__c> lines = CreditNoteDataHelper.getCreditNoteLines(note.Id);
        
        System.assert(lines.size() > 0, 'Expected at least one Credit Note Line.');
        for(dmpl__CreditNoteLine__c line : lines) {
            System.assertEquals(note.Id, line.dmpl__CreditNoteId__c, 'Expected Credit Note Line to be associated with Credit Note.');
        }
    }
    
    @isTest
    static void updateCreditNoteLinePositive() {
        dmpl__CreditNote__c note = CreditNoteDataHelper.getCreditNote();
        List<dmpl__CreditNoteLine__c> lines = CreditNoteDataHelper.getCreditNoteLines(note.Id);
        if (!lines.isEmpty()) {
            dmpl__CreditNoteLine__c line = lines[0];            
            line.dmpl__Amount__c = 250;
            line.dmpl__Description__c = 'Updated Credit Note Line Description';
            update line;
            dmpl__CreditNoteLine__c updatedLine = CreditNoteDataHelper.getCreditNoteLine(line.Id);
            System.assertEquals(250, updatedLine.dmpl__Amount__c, 'Expected amount to be updated.');
            System.assertEquals('Updated Credit Note Line Description', updatedLine.dmpl__Description__c, 'Expected description to be updated.');
        }
    }
    
    @isTest
    static void deleteCreditNoteLine() {
        dmpl__CreditNote__c note = CreditNoteDataHelper.getCreditNote();
        List<dmpl__CreditNoteLine__c> lines = CreditNoteDataHelper.getCreditNoteLines(note.Id);
        if (!lines.isEmpty()) {
            Id lineIdToDelete = lines[0].Id;
            delete lines[0];
            Integer count = [SELECT COUNT() FROM dmpl__CreditNoteLine__c WHERE Id = :lineIdToDelete];
            System.assertEquals(0, count, 'Expected Credit Note Line to be deleted.');
        }
    }
}