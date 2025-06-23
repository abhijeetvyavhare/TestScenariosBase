public with sharing class InventoryCycleCountLineHelper extends TriggerHandler {
    private static final List<String> LIST_FIELDS_NONEDITABLE = new List<String>{
        InventoryCycleCountService.FIELD_INVENTORYCYCLECOUNTLINE_CYCLECOUNTID};
    private static final List<String> LIST_FIELDS_SYSTEM = new List<String>{};
    private static final List<String> LIST_FIELDS_SOURCEPOULATED = new List<String>{
        InventoryCycleCountService.FIELD_INVENTORYCYCLECOUNTLINE_ITEMID,
        InventoryCycleCountService.FIELD_INVENTORYCYCLECOUNTLINE_SKUID};
    private static final List<String> LIST_FIELDS_LOCKEDIFTRANSACTED = new List<String>{
        InventoryCycleCountService.FIELD_INVENTORYCYCLECOUNTLINE_ITEMID,
        InventoryCycleCountService.FIELD_INVENTORYCYCLECOUNTLINE_SKUID};

    private InventoryCycleCountService iccs;
    private List<dmpl__InventoryCycleCountLine__c> triggerNew;
    private List<dmpl__InventoryCycleCountLine__c> triggerOld;
    private Map<Id, dmpl__InventoryCycleCountLine__c> triggerMapNew;
    private Map<Id, dmpl__InventoryCycleCountLine__c> triggerMapOld;

    public InventoryCycleCountLineHelper() {
        this.iccs = new InventoryCycleCountService();
        this.triggerOld = (List<dmpl__InventoryCycleCountLine__c>) Trigger.old;
        this.triggerNew = (List<dmpl__InventoryCycleCountLine__c>) Trigger.new;
        this.triggerMapNew = (Map<Id, dmpl__InventoryCycleCountLine__c>) Trigger.newMap;
        this.triggerMapOld = (Map<Id, dmpl__InventoryCycleCountLine__c>) Trigger.oldMap;
    }

    public override void beforeInsert(){
        if(!IsValidationSkipped()){
            validateItem(triggerNew);
            setItemData(triggerNew);
            DocumentHelper.validateChangeInSystemFields(
                LIST_FIELDS_SYSTEM, 
                triggerNew);
            (new DocumentStatusDFSHelper()).DocumentStatusRelatedObjectRestrictEdits_New(
                InventoryCycleCountService.OBJECT_INVENTORYCYCLECOUNT, 
                InventoryCycleCountService.OBJECT_INVENTORYCYCLECOUNTLINE, 
                InventoryCycleCountService.RELATION_INVENTORYCYCLECOUNT_STATUS, 
                triggerNew);    
        }
    }

    public override void beforeUpdate(){
        if(!IsValidationSkipped()){
            DocumentHelper.validateChangeInSystemFields(
                LIST_FIELDS_SYSTEM, 
                triggerOld, 
                triggerNew);
            DocumentHelper.validateChangeInKeyFields(
                LIST_FIELDS_NONEDITABLE, 
                triggerOld, 
                triggerNew);
            //DocumentHelper.validateChangeInSourcePopulatedFields(
                // LIST_FIELDS_SOURCEPOULATED, 
                // triggerOld, 
                // triggerNew, 
                // FIELD_INVENTORYCYCLECOUNTLINE_ITEMLOTID);
            (new DocumentStatusDFSHelper()).DocumentStatusRelatedObjectRestrictEdits_Edit(
                InventoryCycleCountService.OBJECT_INVENTORYCYCLECOUNT, 
                InventoryCycleCountService.OBJECT_INVENTORYCYCLECOUNTLINE, 
                InventoryCycleCountService.RELATION_INVENTORYCYCLECOUNT_STATUS, 
                triggerOld, 
                triggerNew);
        }
    }

    public override void beforeDelete(){
        DocumentHelper.validateCanBeDeleted(
            triggerOld, 
            InventoryCycleCountService.FIELD_INVENTORYCYCLECOUNTLINE_DISCREPENCYQUANTITY);
        (new DocumentStatusDFSHelper()).DocumentStatusRelatedObjectRestrictEdits_Delete(
            InventoryCycleCountService.OBJECT_INVENTORYCYCLECOUNT, 
            InventoryCycleCountService.OBJECT_INVENTORYCYCLECOUNTLINE, 
            InventoryCycleCountService.RELATION_INVENTORYCYCLECOUNT_STATUS, 
            triggerOld);
    }
    
    private void validateItem(
        List<dmpl__InventoryCycleCountLine__c> newEntries){
        Map<Id, dmpl__Item__c> items = new Map<Id,dmpl__Item__c>(
            ItemHelper.getCachedItems(
                DocumentHelper.extractIds(
                    triggerNew, 
                    InventoryCycleCountService.FIELD_INVENTORYCYCLECOUNTLINE_ITEMID)));
        for(dmpl__InventoryCycleCountLine__c orderLine : newEntries){
            dmpl__Item__c item = items.get(
                orderLine.dmpl__ItemId__c);
           if(orderLine.dmpl__SKUId__c == null 
                && item!=null && item.dmpl__IsSKURequired__c){
                orderLine.addError(
                    System.Label.Validation_SKURequired);
            }
            if(orderLine.dmpl__SKUId__c != null){
                dmpl__SKU__c sku = (dmpl__SKU__c)CollectionHelper.getObject(
                    item.dmpl__SKUs__r, 
                    orderLine.dmpl__SKUId__c);
                if(sku ==null){
                    orderLine.addError(
                        System.Label.Validation_SKUInvalid);
                }
            }
        }
    }
    private static void setItemData(
        List<dmpl__InventoryCycleCountLine__c> newEntries)
    {
        Map<Id, dmpl__Item__c> items = new Map<Id,dmpl__Item__c>(
            ItemHelper.getCachedItems(
                DocumentHelper.extractIds(
                    newEntries, 
                    InventoryCycleCountService.FIELD_INVENTORYCYCLECOUNTLINE_ITEMID)));
        ItemHelper.setQuantityFromUOM(
            newEntries, 
            null,
            items);
    }
}