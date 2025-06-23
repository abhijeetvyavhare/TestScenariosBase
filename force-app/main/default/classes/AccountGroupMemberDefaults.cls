@isTest
public with sharing class AccountGroupMemberDefaults implements TestFactory.FieldDefaults{
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{ 
            'dmpl__AccountGroupId__c' => 'null',
            'dmpl__BatchInstanceId__c' => 'null'
        };
    }
}