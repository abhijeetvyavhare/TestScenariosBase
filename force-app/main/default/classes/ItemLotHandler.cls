public without sharing class ItemLotHandler extends TriggerHandler {
    
    public static Boolean skipLockCheck = false;
    private static final List<String> LIST_FIELDS_SYSTEM = new List<String>{
        ItemLotService.FIELD_ITEMLOT_ISTRANSACTIONLOCKED,
        ItemLotService.FIELD_ITEMLOT_QTYADJUSTEDIN,
        ItemLotService.FIELD_ITEMLOT_QTYADJUSTEDOUT,
        ItemLotService.FIELD_ITEMLOT_QTYASSEMBLEDIN,
        ItemLotService.FIELD_ITEMLOT_QTYASSEMBLEDOUT,
        ItemLotService.FIELD_ITEMLOT_QTYDAMAGED,
        ItemLotService.FIELD_ITEMLOT_QTYEXPIRED,
        ItemLotService.FIELD_ITEMLOT_QTYINPENDINGDELIVERIES,
        ItemLotService.FIELD_ITEMLOT_QTYINTRANSIT,
        ItemLotService.FIELD_ITEMLOT_QTYONALLOCATION,
        ItemLotService.FIELD_ITEMLOT_QTYONFUILFILMENT,
        ItemLotService.FIELD_ITEMLOT_QTYONHOLD,
        ItemLotService.FIELD_ITEMLOT_QTYONINSPECTION,
        ItemLotService.FIELD_ITEMLOT_QTYONINWARD,
        ItemLotService.FIELD_ITEMLOT_QTYONLOAN,
        ItemLotService.FIELD_ITEMLOT_QTYONOUTWARD,
        ItemLotService.FIELD_ITEMLOT_QTYPICKED,
        ItemLotService.FIELD_ITEMLOT_QTYPURCHASED,
        ItemLotService.FIELD_ITEMLOT_QTYPURCHASERETURNED,
        ItemLotService.FIELD_ITEMLOT_QTYSALERETURNED,
        ItemLotService.FIELD_ITEMLOT_QTYSHORTAGE,
        ItemLotService.FIELD_ITEMLOT_QTYSOLD,
        ItemLotService.FIELD_ITEMLOT_QTYTRANSFERIN,
        ItemLotService.FIELD_ITEMLOT_QTYTRANSFEROUT
    };
    private static final List<String> LIST_FIELDS_LOCKIFTRANSACTED = new List<String>{
        ItemLotService.FIELD_ITEMLOT_BRANCHID,
        ItemLotService.FIELD_ITEMLOT_ITEMID,
        ItemLotService.FIELD_ITEMLOT_ITEMLOTTYPEID,
        ItemLotService.FIELD_ITEMLOT_PARTNERACCOUNTID,
        ItemLotService.FIELD_ITEMLOT_SKUID
        // ItemLotService.FIELD_ITEMLOT_STORAGELOCATIONID /*Commented due to OLA scenario (need to check)*/
    };

    private List<dmpl__ItemLot__c> triggerNew;
    private List<dmpl__ItemLot__c> triggerOld;
    private Map<Id, dmpl__ItemLot__c> triggerMapNew;
    private Map<Id, dmpl__ItemLot__c> triggerMapOld;

    public ItemLotHandler() {
        this.triggerOld = (List<dmpl__ItemLot__c>) Trigger.old;
        this.triggerNew = (List<dmpl__ItemLot__c>) Trigger.new;
        this.triggerMapNew = (Map<Id, dmpl__ItemLot__c>) Trigger.newMap;
        this.triggerMapOld = (Map<Id, dmpl__ItemLot__c>) Trigger.oldMap;
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
        DocumentHelper.validateChangeInLockedIfTransactedFields(
            LIST_FIELDS_LOCKIFTRANSACTED,
            this.triggerOld,
            this.triggerNew,
            ItemLotService.FIELD_ITEMLOT_QTYINHAND);
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
        List<dmpl__ItemLot__c> newEntries){
            if(skipLockCheck){
                return;
            }
            for(dmpl__ItemLot__c entry : newEntries){
                if(entry.dmpl__IsTransactionLocked__c){
                    entry.addError(
                        'Item is locked for transaction! Please contact your Administrator for more details.');
                }
            }
    }
}