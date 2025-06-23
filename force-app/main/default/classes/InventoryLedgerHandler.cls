public without sharing class InventoryLedgerHandler extends TriggerHandler {
    
    private static final List<String> LIST_FIELDS_SYSTEM = new List<String>{
        InventoryLedgerService.FIELD_INVENTORYLEDGER_UNITCOST,
        InventoryLedgerService.FIELD_INVENTORYLEDGER_STORAGELOCATIONID,
        InventoryLedgerService.FIELD_INVENTORYLEDGER_SOURCEDOCUMENT,
        InventoryLedgerService.FIELD_INVENTORYLEDGER_SKUID,
        InventoryLedgerService.FIELD_INVENTORYLEDGER_SHORTAGEQUANTITY,
        InventoryLedgerService.FIELD_INVENTORYLEDGER_RELATEDPARTNERACCOUNTID,
        InventoryLedgerService.FIELD_INVENTORYLEDGER_RELATEDITEMLOTID,
        InventoryLedgerService.FIELD_INVENTORYLEDGER_RELATEDBRANHCID,
        InventoryLedgerService.FIELD_INVENTORYLEDGER_QUANTITY,
        InventoryLedgerService.FIELD_INVENTORYLEDGER_PIPELINEQUANTITY,
        InventoryLedgerService.FIELD_INVENTORYLEDGER_PICKEDQUANTITY,
        InventoryLedgerService.FIELD_INVENTORYLEDGER_PENDINGDELIVERYQUANTITY,
        InventoryLedgerService.FIELD_INVENTORYLEDGER_PARTNERACCOUNTID,
        InventoryLedgerService.FIELD_INVENTORYLEDGER_ITEMLOTTYPEID,
        InventoryLedgerService.FIELD_INVENTORYLEDGER_ITEMLOTID,
        InventoryLedgerService.FIELD_INVENTORYLEDGER_ITEMID,
        InventoryLedgerService.FIELD_INVENTORYLEDGER_ITEMCODE,
        InventoryLedgerService.FIELD_INVENTORYLEDGER_ISSTOCKPOSTED,
        InventoryLedgerService.FIELD_INVENTORYLEDGER_INWARDQUANTITY,
        InventoryLedgerService.FIELD_INVENTORYLEDGER_INVENTORYLEDGERTYPE,
        InventoryLedgerService.FIELD_INVENTORYLEDGER_HASHCODE,
        InventoryLedgerService.FIELD_INVENTORYLEDGER_EXTERNALID,
        InventoryLedgerService.FIELD_INVENTORYLEDGER_DOCUMENTDATE,
        InventoryLedgerService.FIELD_INVENTORYLEDGER_DAMAGEDQUANTITY,
        InventoryLedgerService.FIELD_INVENTORYLEDGER_BRANCHID,
        InventoryLedgerService.FIELD_INVENTORYLEDGER_ALLOCATEDQUANTITY,
        InventoryLedgerService.FIELD_INVENTORYLEDGER_SOFTCOMMITTEDQUANTITY
    };

    private List<dmpl__InventoryLedger__c> triggerNew;
    private List<dmpl__InventoryLedger__c> triggerOld;
    private Map<Id, dmpl__InventoryLedger__c> triggerMapNew;
    private Map<Id, dmpl__InventoryLedger__c> triggerMapOld;

    public InventoryLedgerHandler() {
        this.triggerOld = (List<dmpl__InventoryLedger__c>) Trigger.old;
        this.triggerNew = (List<dmpl__InventoryLedger__c>) Trigger.new;
        this.triggerMapNew = (Map<Id, dmpl__InventoryLedger__c>) Trigger.newMap;
        this.triggerMapOld = (Map<Id, dmpl__InventoryLedger__c>) Trigger.oldMap;
    }

    public override void beforeInsert(){
        ValidationHelper.validatePartnerAndBranch(
            MetadataService.FIELD_PARTNER_ACCOUNT_ID,
            MetadataService.FIELD_BRANCH_ID,
            this.triggerNew);
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
        ValidationHelper.validatePartnerAndBranch(
            MetadataService.FIELD_PARTNER_ACCOUNT_ID,
            MetadataService.FIELD_BRANCH_ID,
            this.triggerNew);
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
        List<dmpl__InventoryLedger__c> oldEntries, 
        List<dmpl__InventoryLedger__c> newEntries)
    {
        ItemLotHelper.postInventoryLedgerRecords(
            isInsert, 
            isDelete, 
            isUpdate, 
            oldEntries, 
            newEntries);
        InventoryStockHelper.postInventoryLedgerRecords(
            isInsert, 
            isDelete, 
            isUpdate, 
            oldEntries, 
            newEntries);
    }
}