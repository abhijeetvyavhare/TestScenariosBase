@isTest 
public with sharing class JournalEntryHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Account partnerAccount = TestDataHelpers.createPartnerAccount();
        Id partnerAccountId = partnerAccount.Id;
        dmpl__JournalEntry__c journal = JournalEntryDataHelper.createJournalEntry(partnerAccountId);
        List<dmpl__JournalEntryLine__c> lines = JournalEntryDataHelper.createJournalEntryLines(journal.Id);
    }
     
    @isTest
    static void createJournalEntryPositive() {
        dmpl__JournalEntry__c journal = JournalEntryDataHelper.getJournalEntry();
        System.assertNotEquals(journal, null, 'Expected Journal Entry to be created.');
        System.assertEquals('INR', journal.dmpl__Currency__c, 'Expected currency to be INR.');
    }
     
    @isTest
    static void updateJournalEntryPositive() {
        dmpl__JournalEntry__c journal = JournalEntryDataHelper.getJournalEntry();
        journal.dmpl__Notes__c = 'Updated notes';
        update journal;        
        dmpl__JournalEntry__c updatedJournal = JournalEntryDataHelper.getJournalEntry(journal.Id);
        System.assertEquals('Updated notes', updatedJournal.dmpl__Notes__c, 'Expected notes to be updated.');
    }

    @isTest
    static void deleteJournalEntry() {
        dmpl__JournalEntry__c journal = JournalEntryDataHelper.getJournalEntry();
        delete journal;
        
        Integer count = [SELECT COUNT() FROM dmpl__JournalEntry__c WHERE Id = :journal.Id];
        System.assertEquals(0, count, 'Expected Journal Entry to be deleted.');
    }
     
    @isTest
    static void createJournalEntryLinesPositive() {
        dmpl__JournalEntry__c journal = JournalEntryDataHelper.getJournalEntry();
        List<dmpl__JournalEntryLine__c> lines = JournalEntryDataHelper.getJournalEntryLines(journal.Id);
        
        System.assert(lines.size() > 0, 'Expected at least one Journal Entry Line.');
    }
     
    @isTest
    static void updateJournalEntryLinePositive() {
        dmpl__JournalEntry__c journal = JournalEntryDataHelper.getJournalEntry();
        List<dmpl__JournalEntryLine__c> lines = JournalEntryDataHelper.getJournalEntryLines(journal.Id);
        if (!lines.isEmpty()) {
            dmpl__JournalEntryLine__c line = lines[0];
            
            line.dmpl__Credit__c = 500;
            update line;
            dmpl__JournalEntryLine__c updatedLine = JournalEntryDataHelper.getJournalEntryLine(line.Id);
            System.assertEquals(500, updatedLine.dmpl__Credit__c, 'Expected credit amount to be updated.');
        }
    }
     
    @isTest
    static void deleteJournalEntryLine() {
        dmpl__JournalEntry__c journal = JournalEntryDataHelper.getJournalEntry();
        List<dmpl__JournalEntryLine__c> lines = JournalEntryDataHelper.getJournalEntryLines(journal.Id);
        if (!lines.isEmpty()) {
            Id lineIdToDelete = lines[0].Id;
            delete lines[0];
            
            Integer count = [SELECT COUNT() FROM dmpl__JournalEntryLine__c WHERE Id = :lineIdToDelete];
            System.assertEquals(0, count, 'Expected Journal Entry Line to be deleted.');
        }
    }
}