@isTest
public with sharing class AccountRewardLedgerDefaults implements TestFactory.FieldDefaults{
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{ 
                'dmpl__DocumentDate__c'=>null,
                'dmpl__RewardPoints__c'=>100
        };
    }
}