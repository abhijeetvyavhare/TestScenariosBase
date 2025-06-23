public with sharing class GeneralLedgerService extends MetadataService {
    
    public static final String OBJECT_INVENTORYLEDGER = 'dmpl__InventoryLedger__c';

    public static final String FIELD_OBJECT_GENERALACCOUNTID =  'dmpl__GLAccountId__c';
    public static final String FIELD_OBJECT_GENERALLEDGERID =  'dmpl__GeneralLedgerId__c';
    public static final String FIELD_OBJECT_RELEATEDGENERALLEDGERID =  'dmpl__RelatedGeneralLedgerId__c';

    public GeneralLedgerService(){
        super(OBJECT_INVENTORYLEDGER);
    }
    
    public Map<Id, dmpl__GeneralLedger__c> queryLedgerRecords(
        List<string> lineIds){
        return new Map<Id,dmpl__GeneralLedger__c>([SELECT 
            Id,
            dmpl__AccountId__c,
            dmpl__Amount__c,
            dmpl__Credit__c,
            dmpl__Debit__c,
            dmpl__Details__c,
            dmpl__DocumentDate__c,
            dmpl__ExternalId__c,
            dmpl__GLAccountId__c,
            dmpl__PartnerAccountId__c,
            dmpl__Reference__c,
            dmpl__SourceDocumentName__c,
            dmpl__TransactionType__c
            FROM dmpl__GeneralLedger__c
            WHERE Id IN : lineIds]);
    }

    public List<dmpl__GLAccount__c> queryGLAccounts(
        List<Id> partnerAccountIds){
        return 
            [SELECT 
                dmpl__AccountType__c,
                dmpl__Currency__c,
                dmpl__IsActive__c,
                dmpl__IsSystem__c,
                dmpl__PartnerAccountId__c,
                dmpl__BranchId__c,
                dmpl__PostingType__c,
                dmpl__SystemCode__c
            FROM 
                dmpl__GLAccount__c
            WHERE 
                dmpl__PartnerAccountId__c IN:partnerAccountIds
            ORDER BY dmpl__BranchId__c DESC NULLS LAST]; 
    }
    
    public Map<Id, Account> queryPartnerAccounts(
        List<Id> partnerAccountIds){
        return new Map<Id, Account>(
            [SELECT 
                Id,
                dmpl__IsGLPostingEnabled__c
            FROM 
                Account
            WHERE 
                Id IN:partnerAccountIds]); 
    }
}