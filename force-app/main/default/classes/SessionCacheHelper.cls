@namespaceAccessible
public with sharing class SessionCacheHelper {
    private static final String PARTITION_NAME = 'dmpl.DMSCache';

    static Cache.SessionPartition sessionPartition;
 
    @namespaceAccessible
    public static Boolean isPlatformCacheEnabled() {
        Cache.SessionPartition defaultCachePartition = getSessionPartition();
        return defaultCachePartition != null && defaultCachePartition.isAvailable();
    }

    @namespaceAccessible
    public static Boolean isPlatformCacheEnabled(string objectApiName) {
        return isPlatformCacheEnabled() && (!CacheDFSHelper.isCacheDisabled(objectApiName));
    }

    @namespaceAccessible
    public static SObject getSObject(String objectApiName, Id objectId){
        return (SObject)getSessionPartition().get(getKey(objectApiName, objectId));
    }
    
    @namespaceAccessible
    public static Object getObject(String key){
        return getSessionPartition().get(key);
    }

    @namespaceAccessible
    public static void setSObject(SObject aObject){
        getSessionPartition().put(getKey(aObject.getSObjectType().getDescribe().getName(), aObject.Id), aObject);
    }

    @namespaceAccessible
    public static void setObject(String key, Object aObject){
        getSessionPartition().put(key, aObject);
    }

    @namespaceAccessible
    public static void removeSObject(SObject aObject){
        getSessionPartition().remove(getKey(aObject.getSObjectType().getDescribe().getName(), aObject.Id));
    }

    @namespaceAccessible
    public static void removeObject(string key){
        getSessionPartition().remove(key);
    }

    @namespaceAccessible
    public static void setSObjects(List<SObject> sObjects){
        Cache.SessionPartition partition = getSessionPartition();
        if(partition!=null){
            String objectApiName = sObjects.size()>0?sObjects[0].getSObjectType().getDescribe().getName():null;
            for(SObject aObject : sObjects){
                partition.put(getKey(objectApiName, aObject.Id),aObject);
            }    
        }
    }
    
    @namespaceAccessible
    public static void removeSObjects(List<SObject> sObjects){
        Cache.SessionPartition partition = getSessionPartition();
        if(partition!=null){
            String objectApiName = sObjects.size()>0?sObjects[0].getSObjectType().getDescribe().getName():null;
            for(SObject aObject : sObjects){
                partition.remove(getKey(objectApiName, aObject.Id));
            }    
        }
    }

    @namespaceAccessible
    public static void removeSObjects(String sObjectApiName, List<Id> sObjectIds){
        Cache.SessionPartition partition = getSessionPartition();
        if(partition!=null){
            for(Id sObjectId : sObjectIds){
                partition.remove(getKey(sObjectApiName, sObjectId));
            }    
        }
    }

    @namespaceAccessible
    public static Cache.SessionPartition getSessionPartition(){
        try {
            if(sessionPartition == null){
                sessionPartition = Cache.Session.getPartition(PARTITION_NAME);
            }
        } catch (Exception e) {
        }

        return sessionPartition;
    }

    private static String getKey(String objectApiName, Id objectId){
        String key = String.join(new String[]{objectApiName.remove('_'), objectId},'');
        return String.join(new String[]{objectApiName.remove('_'), objectId},'');
    }
}