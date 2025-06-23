public with sharing class InventoryRuleDFSHelper extends DomainFeatureSettingHelper{
    
    private static final String FIELD_ITEMID = 'dmpl__ItemId__c';
    private static final String FIELD_SKUID = 'dmpl__SKUId__c';
    private static final String FIELD_LOTID = 'dmpl__ItemLotId__c';
    private static final String FIELD_STORAGELOCATIONID = 'dmpl__StorageLocationId__c';

    private static final String FIELD_TRACKINVENTORY = 'dmpl__TrackInventory__c';
    private static final String FIELD_TRACKLOTS = 'dmpl__TrackLots__c';

    public void checkInventoryLotTracking(List<SObject> newEntries, List<Item__c> items){
        Map<Id,dmpl__Item__c> itemsMap = new Map<Id,dmpl__Item__c>(items);
        for(SObject newEntry : newEntries){
            dmpl__Item__c item = itemsMap.get((Id)newEntry.get(FIELD_ITEMID));
            if(item!=null 
                && (Boolean)item.get(FIELD_TRACKLOTS) 
                && newEntry.get(FIELD_LOTID) == null){
                newEntry.addError(System.Label.DomainValidation_InventoryLotRequired); 
            }
        }
    }

    public void checkInventoryTracking(List<SObject> newEntries, List<Item__c> items){
        Map<Id,dmpl__Item__c> itemsMap = new Map<Id,dmpl__Item__c>(items);
        for(SObject newEntry : newEntries){
            dmpl__Item__c item = itemsMap.get((Id)newEntry.get(FIELD_ITEMID));
            if(item!=null && !(Boolean)item.get(FIELD_TRACKINVENTORY)){
                newEntry.addError(System.Label.DomainValidation_InventoryNotTracked); 
            }
        }
    }
}