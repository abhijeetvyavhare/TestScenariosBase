@isTest
public with sharing class JournalEntryDataHelper {
    public static dmpl__JournalEntry__c createJournalEntry(Id partnerAccountId) {
        return (dmpl__JournalEntry__c) TestFactory.createSObject(
            new dmpl__JournalEntry__c(
                dmpl__PartnerAccountId__c = partnerAccountId
            ),
            'JournalEntryDefaults',
            true
        );
    }

    public static dmpl__JournalEntry__c getJournalEntry() {
        return [
            SELECT Id, Name, dmpl__Currency__c, dmpl__DocumentDate__c, dmpl__Notes__c, 
                   dmpl__PartnerAccountId__c, dmpl__ExternalId__c
            FROM dmpl__JournalEntry__c
            LIMIT 1
        ];
    }

    public static dmpl__JournalEntry__c getJournalEntry(Id journalId) {
    return [
        SELECT Id, Name, dmpl__Currency__c, dmpl__DocumentDate__c, dmpl__Notes__c, 
               dmpl__PartnerAccountId__c, dmpl__ExternalId__c
        FROM dmpl__JournalEntry__c
        WHERE Id = :journalId
        LIMIT 1
    ];
    }

    public static List<dmpl__JournalEntryLine__c> createJournalEntryLines(Id journalEntryId) {
        List<dmpl__JournalEntryLine__c> lines = new List<dmpl__JournalEntryLine__c>();        
        for(Integer i = 0; i < 2; i++) {
            dmpl__JournalEntryLine__c line = (dmpl__JournalEntryLine__c) TestFactory.createSObject(
                new dmpl__JournalEntryLine__c(
                    dmpl__JournalEntryId__c = journalEntryId
                ),
                'JournalEntryLineDefaults',
                true
            );
            lines.add(line);
        }
        return lines;
    }
     
    public static dmpl__JournalEntryLine__c createJournalEntryLine(
        Id journalEntryId,
        Id glAccountId,
        Id accountId
    ) {
        return (dmpl__JournalEntryLine__c) TestFactory.createSObject(
            new dmpl__JournalEntryLine__c(
                dmpl__JournalEntryId__c = journalEntryId,
                dmpl__GLAccountId__c = glAccountId,
                dmpl__AccountId__c = accountId
            ),
            'JournalEntryLineDefaults',
            true
        );
    }

    public static List<dmpl__JournalEntryLine__c> getJournalEntryLines(Id journalEntryId) {
        return [
            SELECT Id, Name, dmpl__Amount__c, dmpl__Credit__c, dmpl__Debit__c,
                   dmpl__Description__c, dmpl__ExternalId__c, dmpl__JournalEntryId__c
            FROM dmpl__JournalEntryLine__c
            WHERE dmpl__JournalEntryId__c = :journalEntryId
        ];
    }

    public static dmpl__JournalEntryLine__c getJournalEntryLine(Id id) {
        return [
            SELECT Id, Name, dmpl__Amount__c, dmpl__Credit__c, dmpl__Debit__c,
                   dmpl__Description__c, dmpl__ExternalId__c, dmpl__JournalEntryId__c
            FROM dmpl__JournalEntryLine__c
            WHERE Id = :id
            LIMIT 1
        ];
    }
}