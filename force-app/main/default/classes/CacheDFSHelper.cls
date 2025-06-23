@namespaceAccessible
public with sharing class CacheDFSHelper extends DomainFeatureSettingHelper{
    private static final string FEATURE_DisableCache = 'Cache : Disable';
  
    @namespaceAccessible
    public static Boolean isCacheDisabled(string objectApiName){
        Map<String, Boolean> dfsSettings = getDfsValues();
        return(dfsSettings!=null && dfsSettings.containsKey(objectApiName));
    }

    private static Map<String, Boolean> getDfsValues() {
        if (OrgCacheHelper.isPlatformCacheEnabled()) {
            return (Map<String, Boolean>) OrgCacheHelper.getOrgPartition()
                .get(CacheDFSCache.class, 'default');
        } else {
            return new CacheDFSCache().calculateDFS('default');
        }
    }

    private class CacheDFSCache implements Cache.CacheBuilder {
        public Object doLoad(String key) {
            return calculateDFS(key);
        }

        public Map<String, Boolean> calculateDFS(String key) {
            Map<String, Boolean> results = new Map<String, Boolean>();
            List<dmpl__DomainSetting__mdt> featureSettings = getDomainSettings(FEATURE_DisableCache);
            for(dmpl__DomainSetting__mdt fs : featureSettings){
                if(!String.isEmpty(fs.dmpl__ObjectNameId__r?.QualifiedApiName)){
                    results.put(fs.dmpl__ObjectNameId__r?.QualifiedApiName, true);
                }
            }
            return results;
        }

        private List<dmpl__DomainSetting__mdt> getDomainSettings(string featureName){
            return [SELECT
                    dmpl__PartnerAccountId__c,
                    dmpl__BranchId__c,
                    dmpl__Status__c,
                    dmpl__ObjectNameId__r.QualifiedApiName,
                    dmpl__FieldNameId__r.QualifiedApiName
                FROM dmpl__DomainSetting__mdt
                WHERE dmpl__Feature__c =:featureName];
        }
    }
}