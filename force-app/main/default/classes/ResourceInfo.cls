public with sharing class ResourceInfo {
    
    @AuraEnabled
    public dmpl__Resource__c resourceData;

    @AuraEnabled
    public Boolean isResourceAvailable;

    public ResourceInfo(
        Boolean isResourceAvailable,
        dmpl__Resource__c resourceData){
        this.isResourceAvailable = isResourceAvailable;
        this.resourceData = resourceData;
    }
}