@namespaceAccessible
public with sharing class ItemGroupHelper {
    private static final string OBJECT_ITEMGROUP = 'dmpl__ItemGroup__c';
    
    public static HeadlessActionResult processMembers(Id recordId){
        dmpl__InterfaceQueue__c queue = new dmpl__InterfaceQueue__c(
            dmpl__JobType__c = 'Item Group Member Processor',
            dmpl__InterfaceRecordId__c = recordId,
            dmpl__QueueType__c = 'Queueable'
        );
        SecurityHelper.ensureCanCreateObject('dmpl__InterfaceQueue__c');
        SecurityHelper.ensureCanCreateFields(
            new string[]{
                'dmpl__JobType__c',
                'dmpl__InterfaceRecordId__c',
                'dmpl__QueueType__c'
            }, 'dmpl__InterfaceQueue__c');
        
        insert queue;

        return new HeadlessActionResult(true, 'The operation was Queued. Please check back in some time. (Queue Id : ' + queue.Id + ')');
    }

    @namespaceAccessible
    public static List<dmpl__ItemGroupMember__c> getCachedItemGroupIds(
        String groupType, 
        Id itemId){
        if (!SessionCacheHelper.isPlatformCacheEnabled(OBJECT_ITEMGROUP)){
            return queryCachedItemGroupIds(
                groupType, 
                itemId);
        }
        String key = OrgCacheHelper.generateKey(
            OBJECT_ITEMGROUP, 
            'FI' + groupType, 
            itemId);
        List<dmpl__ItemGroupMember__c> itemGroupIds = (List<dmpl__ItemGroupMember__c>)OrgCacheHelper.getObject(key);
        if(itemGroupIds == null){
            itemGroupIds = queryCachedItemGroupIds(
                groupType, 
                itemId);
            OrgCacheHelper.setObject(
                key, 
                itemGroupIds);
        }
        return itemGroupIds;
    }

    @namespaceAccessible
    public static List<dmpl__ItemGroupMember__c> getCachedItemGroupIds(String groupType, List<Id> itemIds){
        if (!SessionCacheHelper.isPlatformCacheEnabled(OBJECT_ITEMGROUP)){
            return queryCachedItemGroupIds(groupType, itemIds);
        }
        List<dmpl__ItemGroupMember__c> itemGroupMaps = new List<dmpl__ItemGroupMember__c>();
        List<Id> missingIds = new List<Id>();
        for(Id itemId : itemIds){
            String key = OrgCacheHelper.generateKey(OBJECT_ITEMGROUP, 'FI' + groupType, itemId);
            List<dmpl__ItemGroupMember__c> itemGroupIds = (List<dmpl__ItemGroupMember__c>)OrgCacheHelper.getObject(key);
            if(itemGroupIds == null){
                missingIds.add(itemId);
            } else{
                itemGroupMaps.addAll(itemGroupIds);
            }
        }

        if(missingIds.size()>0){
            List<dmpl__ItemGroupMember__c> missingItemGroupIds = queryCachedItemGroupIds(groupType, missingIds);
            itemGroupMaps.addAll(missingItemGroupIds);
            List<Id> items = new List<Id>();
            for(dmpl__ItemGroupMember__c missingItemGroupId : missingItemGroupIds)
            {
                if(items.contains(missingItemGroupId.dmpl__ItemId__c))
                    continue;

                List<dmpl__ItemGroupMember__c> itemGroupMembers = DocumentHelper.getObjectsByFilter(missingItemGroupIds, 'dmpl__ItemId__c', missingItemGroupId.dmpl__ItemId__c);
                String key = OrgCacheHelper.generateKey(OBJECT_ITEMGROUP, 'FI' + groupType, missingItemGroupId.dmpl__ItemId__c);
                OrgCacheHelper.setObject(
                    key, 
                    itemGroupMembers);
                //
                items.add(missingItemGroupId.dmpl__ItemId__c);
            }
        }
        return itemGroupMaps;
    }

    private static List<dmpl__ItemGroupMember__c> queryCachedItemGroupIds(
        String groupType, 
        Id itemId){
        return [SELECT 
            dmpl__ItemId__c,
            dmpl__SKUId__c,
            dmpl__LotTypeId__c,
            dmpl__ItemGroupId__c
        FROM 
            dmpl__ItemGroupMember__c 
        WHERE 
            dmpl__ItemGroupId__r.dmpl__ItemGroupType__c = :groupType
            AND dmpl__ItemId__c = :itemId];
    }

    private static List<dmpl__ItemGroupMember__c> queryCachedItemGroupIds(String groupType, List<Id> itemIds){
        return [SELECT 
                dmpl__ItemId__c,
                dmpl__SKUId__c,
                dmpl__LotTypeId__c,
                dmpl__ItemGroupId__c
            FROM 
                dmpl__ItemGroupMember__c 
            WHERE 
                dmpl__ItemGroupId__r.dmpl__ItemGroupType__c = :groupType
                AND dmpl__ItemId__c IN :itemIds];
    }
}