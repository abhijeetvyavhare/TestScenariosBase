@namespaceAccessible
public with sharing class RecordFormDFSHelper extends DomainFeatureSettingHelper{
    @namespaceAccessible
    public List<dmpl__DomainSetting__mdt> getActionDomainSetting(string featureName, string objectApiName){
        return getDomainSetting(featureName, objectApiName);
    }
    
    @namespaceAccessible
    public List<dmpl__DomainSetting__mdt> getActionDomainSetting(string featureName, string objectApiName, string relatedObjectApiName){
        return getDomainSetting(featureName, objectApiName, relatedObjectApiName);
    }
}