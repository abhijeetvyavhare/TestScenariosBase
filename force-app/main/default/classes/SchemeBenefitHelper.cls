public with sharing class SchemeBenefitHelper {
    public static void postData(
        Boolean isInsert, 
        Boolean isDelete, 
        Boolean isUpdate, 
        List<dmpl__SchemeBenefit__c> oldEntries, 
        List<dmpl__SchemeBenefit__c> newEntries){
            if(isInsert){
                setItemData(
                    newEntries);
            }
            if(isUpdate){
                Map<Id, dmpl__Item__c> items = new Map<Id,dmpl__Item__c>(
                    ItemHelper.getCachedItems(
                    DocumentHelper.extractIds(
                        newEntries, 
                        'dmpl__DiscountedItemId__c')));
                           List<dmpl__SchemeBenefit__c> modifiedObjects = DocumentHelper.getModifiedNewObjects(
                                new string[]{
                                    'dmpl__DiscountedItemQuantity__c',
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
                                'dmpl__DiscountedItemQuantity__c',
                                'dmpl__DiscountedItemId__c');
                        }

            }
        }
        private static void setItemData(
            List<dmpl__SchemeBenefit__c> newEntries)
        {
            Map<Id, dmpl__Item__c> items = new Map<Id,dmpl__Item__c>(
                ItemHelper.getCachedItems(
                    DocumentHelper.extractIds(
                        newEntries, 
                        'dmpl__DiscountedItemId__c')));
                ItemHelper.setQuantityFromUOM(
                newEntries, 
                null,
                items,
                'dmpl__DiscountedItemQuantity__c',
                'dmpl__DiscountedItemId__c');
        }
   
}