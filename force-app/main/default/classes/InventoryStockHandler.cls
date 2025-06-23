public without sharing class InventoryStockHandler extends TriggerHandler {
    
    public static Boolean skipLockCheck = false;
    private static final List<String> LIST_FIELDS_SYSTEM = new List<String>{
        InventoryStockService.FIELD_INVENTORYSTOCK_BRANCHID,
        InventoryStockService.FIELD_INVENTORYSTOCK_FINANCIALYEAR,
        InventoryStockService.FIELD_INVENTORYSTOCK_HASHCODE,
        InventoryStockService.FIELD_INVENTORYSTOCK_ISTRANSACTIONLOCKED,
        InventoryStockService.FIELD_INVENTORYSTOCK_ITEMID,
        InventoryStockService.FIELD_INVENTORYSTOCK_ITEMLOTYPEID,
        InventoryStockService.FIELD_INVENTORYSTOCK_PARTNERACCOUNTID,
        InventoryStockService.FIELD_INVENTORYSTOCK_QTYADJUSTEDIN,
        InventoryStockService.FIELD_INVENTORYSTOCK_QTYADJUSTEDOUT,
        InventoryStockService.FIELD_INVENTORYSTOCK_QTYASSEMBLEDIN,
        InventoryStockService.FIELD_INVENTORYSTOCK_QTYASSEMBLEDOUT,
        InventoryStockService.FIELD_INVENTORYSTOCK_QTYDAMAGED,
        InventoryStockService.FIELD_INVENTORYSTOCK_QTYEXPIRED,
        InventoryStockService.FIELD_INVENTORYSTOCK_QTYINPENDINGDELIVERIES,
        InventoryStockService.FIELD_INVENTORYSTOCK_QTYINPIPELINE,
        InventoryStockService.FIELD_INVENTORYSTOCK_QTYINTRANSIT,
        InventoryStockService.FIELD_INVENTORYSTOCK_QTYONALLOCATION,
        InventoryStockService.FIELD_INVENTORYSTOCK_QTYONFULFILMENT,
        InventoryStockService.FIELD_INVENTORYSTOCK_QTYONHOLD,
        InventoryStockService.FIELD_INVENTORYSTOCK_QTYONINSPECTION,
        InventoryStockService.FIELD_INVENTORYSTOCK_QTYONINWARD,
        InventoryStockService.FIELD_INVENTORYSTOCK_QTYONLOAN,
        InventoryStockService.FIELD_INVENTORYSTOCK_QTYONOUTWARD,
        InventoryStockService.FIELD_INVENTORYSTOCK_QTYPICKED,
        InventoryStockService.FIELD_INVENTORYSTOCK_QTYPURCHASED,
        InventoryStockService.FIELD_INVENTORYSTOCK_QTYPURCHASEDRETURN,
        InventoryStockService.FIELD_INVENTORYSTOCK_QTYSALERETURNED,
        InventoryStockService.FIELD_INVENTORYSTOCK_QTYSHORTAGE,
        InventoryStockService.FIELD_INVENTORYSTOCK_QTYSOLD,
        InventoryStockService.FIELD_INVENTORYSTOCK_QTYTRANSFEREDIN,
        InventoryStockService.FIELD_INVENTORYSTOCK_QTYTRANSFEREDOUT,
        InventoryStockService.FIELD_INVENTORYSTOCK_SKUID,
        InventoryStockService.FIELD_INVENTORYSTOCK_STORAGELOCATION  
    };

    private List<dmpl__InventoryStock__c> triggerNew;
    private List<dmpl__InventoryStock__c> triggerOld;
    private Map<Id, dmpl__InventoryStock__c> triggerMapNew;
    private Map<Id, dmpl__InventoryStock__c> triggerMapOld;

    public InventoryStockHandler() {
        this.triggerOld = (List<dmpl__InventoryStock__c>) Trigger.old;
        this.triggerNew = (List<dmpl__InventoryStock__c>) Trigger.new;
        this.triggerMapNew = (Map<Id, dmpl__InventoryStock__c>) Trigger.newMap;
        this.triggerMapOld = (Map<Id, dmpl__InventoryStock__c>) Trigger.oldMap;
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
            checkForLockedTransactions(this.triggerNew);
        }
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
            checkForLockedTransactions(this.triggerNew);
        }
    }

    public override void beforeDelete(){
        if(!IsValidationSkipped()){
            DocumentHelper.validateCantBeDeleted(
                this.triggerOld);
            checkForLockedTransactions(this.triggerOld);
        }
    }
    
    
    /**
     * Helper Functions
     */
    
     private static void checkForLockedTransactions(
        List<dmpl__InventoryStock__c> newEntries){
            if(skipLockCheck){
                return;
            }
            for(dmpl__InventoryStock__c entry : newEntries){
                if(entry.dmpl__IsTransactionLocked__c){
                    entry.addError(
                        'Item is locked for transaction! Please contact your Administrator for more details.');
                }
            }
    }
}