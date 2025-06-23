@isTest
public with sharing class PartnerAccountMappingDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{ 
            'dmpl__FromDate__c' => Date.today(),
            'dmpl__ToDate__c' => Date.today().addDays(1)
        };
    }
}