@isTest
public with sharing class AssetAccountHistoryDefaults implements TestFactory.FieldDefaults{

    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{ 
                'Name'=>'AssetAccountHistory1',
                'dmpl__Address__c'=>'Mohali, Punjab',
                'dmpl__AtUsageHour__c'=>'1000',
                'dmpl__AtUsageReading__c'=>'1000',
                'dmpl__OwnershipEnddate__c'=>null,
                'dmpl__OwnershipStartDate__c'=>null
        };
    }
}