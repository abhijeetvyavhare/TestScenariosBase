@namespaceAccessible
public with sharing class ResourceGroupHelper {
    private static final string OBJECT_RESOURCEGROUP = 'dmpl__ResourceGroup__c';

    public static HeadlessActionResult processMembers(Id recordId){
        dmpl__InterfaceQueue__c queue = new dmpl__InterfaceQueue__c(
            dmpl__JobType__c = 'Resource Group Member Processor',
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
    public static List<Id> getCachedResourceGroupIds(String groupType, Id ResourceId){
        if (!SessionCacheHelper.isPlatformCacheEnabled(OBJECT_RESOURCEGROUP)){
            return queryCachedResourceGroupIds(groupType, ResourceId);
        }
        String key = OrgCacheHelper.generateKey(OBJECT_RESOURCEGROUP, 'FA' + groupType, ResourceId);
        List<Id> ResourceGroupIds = (List<Id>)OrgCacheHelper.getObject(key);
        if(ResourceGroupIds == null){
            ResourceGroupIds = queryCachedResourceGroupIds(groupType, ResourceId);
            OrgCacheHelper.setObject(
                key, 
                ResourceGroupIds);
        }
        return ResourceGroupIds;
    }

    @namespaceAccessible
    public static Map<Id, List<Id>> getCachedResourceGroupIds(String groupType, List<Id> ResourceIds){
        if (!SessionCacheHelper.isPlatformCacheEnabled(OBJECT_RESOURCEGROUP)){
            return queryCachedResourceGroupIds(groupType, ResourceIds);
        }
        Map<Id, List<Id>> ResourceGroupMaps = new Map<Id, List<Id>>();
        List<Id> missingIds = new List<Id>();
        for(Id ResourceId : ResourceIds){
            String key = OrgCacheHelper.generateKey(OBJECT_RESOURCEGROUP, 'FA' + groupType, ResourceId);
            List<Id> ResourceGroupIds = (List<Id>)OrgCacheHelper.getObject(key);
            if(ResourceGroupIds == null){
                missingIds.add(ResourceId);
            } else{
                ResourceGroupMaps.put(ResourceId, ResourceGroupIds);
            }
        }

        if(missingIds.size()>0){
            Map<Id,List<Id>> missingResourceGroupIds = queryCachedResourceGroupIds(groupType, missingIds);
            ResourceGroupMaps.putAll(missingResourceGroupIds);
        }
        return ResourceGroupMaps;
    }

    private static List<Id> queryCachedResourceGroupIds(String groupType, Id ResourceId){
        return CollectionHelper.extractIds(
            [SELECT 
                dmpl__ResourceGroupId__c 
            FROM 
                dmpl__ResourceGroupMember__c 
            WHERE 
                dmpl__ResourceGroupId__r.dmpl__ResourceGroupType__c = :groupType
                AND dmpl__ResourceId__c = :ResourceId],
            'dmpl__ResourceGroupId__c'
        );    
    }

    private static Map<Id,List<Id>> queryCachedResourceGroupIds(String groupType, List<Id> ResourceIds){
        return CollectionHelper.mapFromCollectionWithCollectionIdValues(
            'dmpl__ResourceId__c',
            'dmpl__ResourceGroupId__c',
            [SELECT 
                dmpl__ResourceId__c,
                dmpl__ResourceGroupId__c
            FROM 
                dmpl__ResourceGroupMember__c 
            WHERE 
                dmpl__ResourceGroupId__r.dmpl__ResourceGroupType__c = :groupType
                AND dmpl__ResourceId__c IN :ResourceIds]
        );    
    }
    
}