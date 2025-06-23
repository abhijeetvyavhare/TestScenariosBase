public without sharing class GeneralLedgerHandler extends TriggerHandler {
    
    private static final List<String> LIST_FIELDS_SYSTEM = new List<String>{
        GeneralLedgerService.FIELD_OBJECT_GENERALACCOUNTID,
        'dmpl__PartnerAccountId__c',
        'dmpl__AccountId__c',
        'dmpl__GLAccountId__c',
        'dmpl__Amount__c'
    };

    private List<dmpl__GeneralLedger__c> triggerNew;
    private List<dmpl__GeneralLedger__c> triggerOld;
    private Map<Id, dmpl__GeneralLedger__c> triggerMapNew;
    private Map<Id, dmpl__GeneralLedger__c> triggerMapOld;

    public GeneralLedgerHandler() {
        this.triggerOld = (List<dmpl__GeneralLedger__c>) Trigger.old;
        this.triggerNew = (List<dmpl__GeneralLedger__c>) Trigger.new;
        this.triggerMapNew = (Map<Id, dmpl__GeneralLedger__c>) Trigger.newMap;
        this.triggerMapOld = (Map<Id, dmpl__GeneralLedger__c>) Trigger.oldMap;
    }

    public override void beforeInsert(){
        if(!IsValidationSkipped()){
            DocumentHelper.validateChangeInSystemFields(
                LIST_FIELDS_SYSTEM, 
                this.triggerNew);
        }
        postData(
            true, 
            false, 
            false, 
            null, 
            this.triggerNew);
    }

    public override void beforeUpdate(){
        if(!IsValidationSkipped()){
            DocumentHelper.validateChangeInSystemFields(
                LIST_FIELDS_SYSTEM, 
                this.triggerOld, 
                this.triggerNew);
        }
        postData(
            false, 
            false, 
            true, 
            this.triggerOld, 
            this.triggerNew);
    }

    public override void beforeDelete(){
        if(!IsValidationSkipped()){
            DocumentHelper.validateCantBeDeleted(
                this.triggerOld);
        }
        postData(
            false, 
            true, 
            false, 
            this.triggerOld, 
            null);
    }
    
    
    /**
     * Helper Functions
     */

    private void postData(
        Boolean isInsert, 
        Boolean isDelete, 
        Boolean isUpdate, 
        List<dmpl__GeneralLedger__c> oldEntries, 
        List<dmpl__GeneralLedger__c> newEntries)
    {
        AccountBalanceHelper.postGeneralLedgerRecords(
            isInsert, 
            isDelete, 
            isUpdate, 
            oldEntries, 
            newEntries);
    }
}