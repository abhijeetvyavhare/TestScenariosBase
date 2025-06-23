public with sharing class SkuHelper {
   
    private static Boolean skipValidations = false; 
    private static final string OBJECT_SKU = 'dmpl__SKU__c';
 
    private static final List<String> LIST_NON_EDITABLE_FIELDS = new List<String>{};
    private static final List<String> LIST_FIELDS_SYSTEM = new List<String>{};
    private static final List<String> LIST_FIELDS_LOCKEDIFTRANSACTED = new List<String>{
        'dmpl__QuantityUnitOfMeasure__c',
        'dmpl__ProductColor__c'
    };

    public static void validateData(Boolean isInsert, Boolean isDelete, Boolean isUpdate, List<dmpl__SKU__c> oldEntries, List<dmpl__SKU__c> newEntries)
    { 
        try{     
            if(isInsert){
                FieldMappingHelper.copyFieldMappingData(
                    newEntries);
            }
            if(skipValidations){
                return;
            }
            if(isInsert){
            }else if(isUpdate){
                DocumentHelper.validateChangeInSystemFields(LIST_FIELDS_SYSTEM, oldEntries, newEntries);
                DocumentHelper.validateChangeInKeyFields(LIST_NON_EDITABLE_FIELDS, oldEntries, newEntries);
                DocumentHelper.validateChangeInLockedIfTransactedFields(LIST_FIELDS_LOCKEDIFTRANSACTED, oldEntries, newEntries, queryTransactedItemIds(CollectionHelper.extractIds(oldEntries)));
            }else if(isDelete){
                DocumentHelper.validateCanBeDeleted(oldEntries, queryTransactedItemIds(CollectionHelper.extractIds(oldEntries)));
            }
        } catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }
    
    public static void postData(Boolean isInsert, Boolean isDelete, Boolean isUpdate, List<dmpl__SKU__c> oldEntries, List<dmpl__SKU__c> newEntries)
    {
        if(isUpdate){
            OrgCacheHelper.removeSObjects(newEntries);
        }
    }

    private static List<Id> queryTransactedItemIds(List<Id> itemIds){
        SecurityHelper.ensureCanReadField('dmpl__ItemId__c', 'dmpl__InventoryLedger__c');
        return CollectionHelper.extractIds([
            SELECT dmpl__ItemId__c
            FROM dmpl__InventoryLedger__c
            WHERE dmpl__ItemId__c IN:itemIds
        ]);
    }
}