public with sharing class BranchTimeSlotHelper {
    private static Boolean skipValidations = false;
    private static final string OBJECT_BRANCHTS = 'dmpl__BranchTimeSlot__c';
    private static final string FIELD_BRANCHTS_ITEMID = 'dmpl__ApplicableToItem__c';
    private static final string FIELD_BRANCHTS_ITEMGROUPID = 'dmpl__ApplicableToItemGroup__c';

    private static final List<String> LIST_NON_EDITABLE_FIELDS = new List<String>{};
    private static final List<String> LIST_FIELDS_SYSTEM = new List<String>{};

    public static void validateData(Boolean isInsert, Boolean isDelete, Boolean isUpdate, List<dmpl__BranchTimeSlot__c> oldEntries, List<dmpl__BranchTimeSlot__c> newEntries)
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
                ValidationHelper.validateItemOrItemGroup(FIELD_BRANCHTS_ITEMID, FIELD_BRANCHTS_ITEMGROUPID, newEntries);
            }else if(isUpdate){
                DocumentHelper.validateChangeInSystemFields(LIST_FIELDS_SYSTEM, oldEntries, newEntries);
                ValidationHelper.validateItemOrItemGroup(FIELD_BRANCHTS_ITEMID, FIELD_BRANCHTS_ITEMGROUPID, newEntries);
            }else if(isDelete){
            }
        } catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }
}