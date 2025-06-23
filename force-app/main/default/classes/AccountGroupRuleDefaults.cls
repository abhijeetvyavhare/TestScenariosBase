@isTest
public with sharing class AccountGroupRuleDefaults implements TestFactory.FieldDefaults{
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{ 
                'dmpl__FieldName__c'=>'Amount',
                'dmpl__FieldValue__c'=>'1000',
                'dmpl__Operation__c'=>'equals',
                'dmpl__SequenceNumber__c'=>1
        };
    }
}