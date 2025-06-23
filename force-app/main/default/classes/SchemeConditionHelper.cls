public with sharing class SchemeConditionHelper {
    public static void postData(
        Boolean isInsert, 
        Boolean isDelete, 
        Boolean isUpdate, 
        List<dmpl__SchemeCondition__c> oldEntries, 
        List<dmpl__SchemeCondition__c> newEntries){
            if(isInsert){
                setItemData(
                    newEntries);
            }
            if(isUpdate){
                Map<Id, dmpl__Item__c> items = new Map<Id,dmpl__Item__c>(
                    ItemHelper.getCachedItems(
                    DocumentHelper.extractIds(
                        newEntries, 
                        'dmpl__ItemId__c')));
                           List<dmpl__SchemeCondition__c> modifiedObjects = DocumentHelper.getModifiedNewObjects(
                                new string[]{
                                    'dmpl__ConditionQuantity__c',
                                    'dmpl__UOM__c',
                                    'dmpl__UOM1__c', 
                                    'dmpl__UOMQuantity__c',
                                    'dmpl__UOMQuantity1__c'
                                }, 
                                oldEntries, 
                                newEntries); 
                        if(modifiedObjects.size()>0){
                            ItemHelper.setQuantityFromUOM(
                                newEntries, 
                                oldEntries, 
                                items,
                                'dmpl__ConditionQuantity__c',
                                null);
                        }

            }
        }
        private static void setItemData(
            List<dmpl__SchemeCondition__c> newEntries)
        {
            Map<Id, dmpl__Item__c> items = new Map<Id,dmpl__Item__c>(
                ItemHelper.getCachedItems(
                    DocumentHelper.extractIds(
                        newEntries, 
                        'dmpl__ItemId__c')));
                ItemHelper.setQuantityFromUOM(
                    newEntries, 
                    null,
                    items,
                    'dmpl__ConditionQuantity__c',
                    null);
        }
}