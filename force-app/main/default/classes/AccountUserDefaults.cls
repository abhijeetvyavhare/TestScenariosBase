@isTest
public with sharing class AccountUserDefaults implements TestFactory.FieldDefaults{
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{ 
                'dmpl__DateEffectiveFrom__c'=>null,
                'dmpl__DateEffectiveTill__c'=>null
        };
    }
}