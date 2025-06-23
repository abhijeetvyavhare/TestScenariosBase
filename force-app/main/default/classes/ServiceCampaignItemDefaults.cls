@isTest
public with sharing class ServiceCampaignItemDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{ 
            'dmpl__IsMandatory__c'=>true,
            'dmpl__Quantity__c'=>4
        };
    }
}