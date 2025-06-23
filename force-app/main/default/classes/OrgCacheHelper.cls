@namespaceAccessible
public with sharing class OrgCacheHelper {
    private static final String PARTITION_NAME = 'dmpl.DMSCache';
    private static Cache.OrgPartition orgPartition;
 
    @namespaceAccessible
    public static Boolean isPlatformCacheEnabled() {
        Cache.OrgPartition defaultCachePartition = getOrgPartition();
        return defaultCachePartition != null;
    }
    
    @namespaceAccessible
    public static Boolean isPlatformCacheEnabled(string objectApiName) {
        return isPlatformCacheEnabled() && (!CacheDFSHelper.isCacheDisabled(objectApiName));
    }

    @namespaceAccessible
    public static SObject getSObject(String objectApiName, Id objectId){
        return (SObject)getOrgPartition().get(getKey(objectApiName, objectId));
    }
    
    @namespaceAccessible
    public static Object getObject(String key){
        try {
            return getOrgPartition().get(key);    
        } catch (Exception ex) {
            return null;
        }
    }

    @namespaceAccessible
    public static void setSObject(SObject aObject){
        getOrgPartition().put(getKey(aObject.getSObjectType().getDescribe().getName(), aObject.Id), aObject);
    }

    @namespaceAccessible
    public static void removeSObject(SObject aObject){
        getOrgPartition().remove(getKey(aObject.getSObjectType().getDescribe().getName(), aObject.Id));
    }

    @namespaceAccessible
    public static void removeSObject(String sObjectApiName, Id sObjectIds){
        getOrgPartition().remove(getKey(sObjectApiName, sObjectIds));
    }

    @namespaceAccessible
    public static void setSObjects(List<SObject> sObjects){
        Cache.OrgPartition partition = getOrgPartition();
        String objectApiName = sObjects.size()>0?sObjects[0].getSObjectType().getDescribe().getName():null;
        for(SObject aObject : sObjects){
            partition.put(getKey(objectApiName, aObject.Id),aObject);
        }
    }
    
    @namespaceAccessible
    public static void setObject(String key, Object aObject){
        try {
            getOrgPartition().put(key, aObject);
        } catch (Exception e) {
            // do nothing
        }
    }

    @namespaceAccessible
    public static void removeSObjects(List<SObject> sObjects){
        Cache.OrgPartition partition = getOrgPartition();
        String objectApiName = sObjects.size()>0?sObjects[0].getSObjectType().getDescribe().getName():null;
        for(SObject aObject : sObjects){
            partition.remove(getKey(objectApiName, aObject.Id));
        }
    }

    @namespaceAccessible
    public static void removeSObjects(String sObjectApiName, List<Id> sObjectIds){
        Cache.OrgPartition partition = getOrgPartition();
        for(Id sObjectId : sObjectIds){
            partition.remove(getKey(sObjectApiName, sObjectId));
        }
    }

    @namespaceAccessible
    public static void removeObject(string key){
        getOrgPartition().remove(key);
    }

    @namespaceAccessible
    public static void removeObjects(string keyEndingWith){
        Set<String> keys = getOrgPartition().getKeys();
        for(String key : keys){
            if(key.endsWith(keyEndingWith)){
                removeObject(key);
            }
        }
    }

    @namespaceAccessible
    public static Cache.OrgPartition getOrgPartition(){
        try {
            if(orgPartition == null){
                orgPartition = Cache.Org.getPartition(PARTITION_NAME);
            }
        } catch (Exception e) {
        }

        return orgPartition;
    }

    private static String getKey(String objectApiName, Id objectId){
        return String.join(new String[]{objectApiName.remove('_'), objectId},'');
    }

    public static String generateKey(String objectApiName, String keyType, Id objectId){
        return String.join(new String[]{objectApiName.remove('_'), keyType, objectId},'');
    }

    public static String generateKey(String objectApiName, String keyType){
        return String.join(new String[]{objectApiName.remove('_'), keyType},'');
    }
}