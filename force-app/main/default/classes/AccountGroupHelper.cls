@namespaceAccessible
public with sharing class AccountGroupHelper {
    private static final string OBJECT_ACCOUNTGROUP = 'dmpl__AccountGroup__c';

    public static HeadlessActionResult processMembers(Id recordId){
        dmpl__InterfaceQueue__c queue = new dmpl__InterfaceQueue__c(
            dmpl__JobType__c = 'Account Group Member Processor',
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
    public static List<Id> getCachedAccountGroupIds(String groupType, Id accountId){
        if (!SessionCacheHelper.isPlatformCacheEnabled(OBJECT_ACCOUNTGROUP)){
            return queryCachedAccountGroupIds(groupType, accountId);
        }
        String key = OrgCacheHelper.generateKey(OBJECT_ACCOUNTGROUP, 'FA' + groupType, accountId);
        List<Id> accountGroupIds = (List<Id>)OrgCacheHelper.getObject(key);
        if(accountGroupIds == null){
            accountGroupIds = queryCachedAccountGroupIds(groupType, accountId);
            OrgCacheHelper.setObject(
                key, 
                accountGroupIds);
        }
        return accountGroupIds;
    }

    @namespaceAccessible
    public static Map<Id, List<Id>> getCachedAccountGroupIds(String groupType, List<Id> accountIds){
        if (!SessionCacheHelper.isPlatformCacheEnabled(OBJECT_ACCOUNTGROUP)){
            return queryCachedAccountGroupIds(groupType, accountIds);
        }
        Map<Id, List<Id>> accountGroupMaps = new Map<Id, List<Id>>();
        List<Id> missingIds = new List<Id>();
        for(Id accountId : accountIds){
            String key = OrgCacheHelper.generateKey(OBJECT_ACCOUNTGROUP, 'FA' + groupType, accountId);
            List<Id> accountGroupIds = (List<Id>)OrgCacheHelper.getObject(key);
            if(accountGroupIds == null){
                missingIds.add(accountId);
            } else{
                accountGroupMaps.put(accountId, accountGroupIds);
            }
        }

        if(missingIds.size()>0){
            Map<Id,List<Id>> missingAccountGroupIds = queryCachedAccountGroupIds(groupType, missingIds);
            accountGroupMaps.putAll(missingAccountGroupIds);
        }
        return accountGroupMaps;
    }

    private static List<Id> queryCachedAccountGroupIds(String groupType, Id accountId){
        return CollectionHelper.extractIds(
            [SELECT 
                dmpl__AccountGroupId__c 
            FROM 
                dmpl__AccountGroupMember__c 
            WHERE 
                dmpl__AccountGroupId__r.dmpl__AccountGroupType__c = :groupType
                AND dmpl__AccountId__c = :accountId],
            'dmpl__AccountGroupId__c'
        );    
    }

    private static Map<Id,List<Id>> queryCachedAccountGroupIds(String groupType, List<Id> accountIds){
        return CollectionHelper.mapFromCollectionWithCollectionIdValues(
            'dmpl__AccountId__c',
            'dmpl__AccountGroupId__c',
            [SELECT 
                dmpl__AccountId__c,
                dmpl__AccountGroupId__c
            FROM 
                dmpl__AccountGroupMember__c 
            WHERE 
                dmpl__AccountGroupId__r.dmpl__AccountGroupType__c = :groupType
                AND dmpl__AccountId__c IN :accountIds]
        );    
    }
    
}