public with sharing class CreditNoteDataHelper {
    public static dmpl__CreditNote__c createCreditNote(Id partnerAccountId, Id branchId) {
        return (dmpl__CreditNote__c) TestFactory.createSObject(
            new dmpl__CreditNote__c(
                dmpl__PartnerAccountId__c = partnerAccountId,
                dmpl__BranchId__c = branchId
            ),
            'CreditNoteDefaults',
            true
        );
    }
    public static dmpl__CreditNote__c getCreditNote() {
        return [
            SELECT Id, Name, dmpl__Currency__c, dmpl__DocumentDate__c, dmpl__Notes__c,
                   dmpl__PartnerAccountId__c, dmpl__ExternalId__c, dmpl__IsGLPosted__c,
                   dmpl__IsGLPostingApproved__c, dmpl__PerformGLPosting__c
            FROM dmpl__CreditNote__c
            LIMIT 1
        ];
    }
    public static dmpl__CreditNote__c getCreditNote(Id creditNoteId) {
    return [
        SELECT Id, dmpl__Notes__c
        FROM dmpl__CreditNote__c
        WHERE Id = :creditNoteId
        LIMIT 1
    ];
    }

   
    public static List<dmpl__CreditNoteLine__c> createCreditNoteLines(Id creditNoteId) {
        List<dmpl__CreditNoteLine__c> lines = new List<dmpl__CreditNoteLine__c>();        
        for(Integer i = 0; i < 2; i++) {
            dmpl__CreditNoteLine__c line = (dmpl__CreditNoteLine__c) TestFactory.createSObject(
                new dmpl__CreditNoteLine__c(
                    dmpl__CreditNoteId__c = creditNoteId
                ),
                'CreditNoteLineDefaults',
                true
            );
            lines.add(line);
        }
        return lines;
    }
    public static dmpl__CreditNoteLine__c createCreditNoteLine(
        Id creditNoteId,
        Id glAccountId,
        Id accountId
    ) {
        return (dmpl__CreditNoteLine__c) TestFactory.createSObject(
            new dmpl__CreditNoteLine__c(
                dmpl__CreditNoteId__c = creditNoteId,
                dmpl__GLAccountId__c = glAccountId,
                dmpl__AccountId__c = accountId
            ),
            'CreditNoteLineDefaults',
            true
        );
    }
    public static List<dmpl__CreditNoteLine__c> getCreditNoteLines(Id creditNoteId) {
        return [
            SELECT Id, Name, dmpl__Amount__c, dmpl__Description__c, dmpl__ExternalId__c,
                   dmpl__CreditNoteId__c, dmpl__GLAccountId__c, dmpl__AccountId__c,
                   dmpl__GeneralLedgerId__c, dmpl__GLAmount__c, dmpl__IsGLPosted__c,
                   dmpl__IsGLPostingApproved__c, dmpl__BranchId__c, dmpl__PartnerAccountId__c
            FROM dmpl__CreditNoteLine__c
            WHERE dmpl__CreditNoteId__c = :creditNoteId
        ];
    }
    
    public static dmpl__CreditNoteLine__c getCreditNoteLine(Id id) {
        return [
            SELECT Id, Name, dmpl__Amount__c, dmpl__Description__c, dmpl__ExternalId__c,
                   dmpl__CreditNoteId__c, dmpl__GLAccountId__c, dmpl__AccountId__c,
                   dmpl__GeneralLedgerId__c, dmpl__GLAmount__c, dmpl__IsGLPosted__c,
                   dmpl__IsGLPostingApproved__c, dmpl__BranchId__c, dmpl__PartnerAccountId__c
            FROM dmpl__CreditNoteLine__c
            WHERE Id = :id
            LIMIT 1
        ];
    }


    public static dmpl__CreditNote__c createCreditNoteWithDate(Id partnerAccountId, Id branchId,Id AccountId,Date Documentdate) {
        return (dmpl__CreditNote__c) TestFactory.createSObject(
            new dmpl__CreditNote__c(
                dmpl__PartnerAccountId__c = partnerAccountId,
                dmpl__BranchId__c = branchId,
                dmpl__AccountId__c=AccountId,
                dmpl__DocumentDate__c=Documentdate
                ),
            'CreditNoteDefaults',
            true
        );
    }

    public static dmpl__CreditNote__c getCreditNoteWithDate(Id creditNoteId) {
    return [
        SELECT 
            Id, 
            dmpl__PartnerAccountId__c,
            dmpl__BranchId__c,
            dmpl__AccountId__c,
            dmpl__DocumentDate__c,
            dmpl__Amount__c,
            dmpl__GLAmount__c,
            dmpl__OpenAmount__c
        FROM dmpl__CreditNote__c 
        WHERE Id=:creditNoteId
        LIMIT 1
    ];
    }
        public static List<dmpl__CreditNoteLine__c> getCreditNoteLinesAllDetails(Id creditNoteId) {
        return [
            SELECT Id, Name, dmpl__Amount__c, dmpl__Description__c, dmpl__ExternalId__c,
                   dmpl__CreditNoteId__c, dmpl__GLAccountId__c, dmpl__AccountId__c,
                   dmpl__GeneralLedgerId__c, dmpl__GLAmount__c, dmpl__IsGLPosted__c,
                   dmpl__IsGLPostingApproved__c, dmpl__BranchId__c, dmpl__PartnerAccountId__c
            FROM dmpl__CreditNoteLine__c
            WHERE dmpl__CreditNoteId__c = :creditNoteId
        ];
    }

}