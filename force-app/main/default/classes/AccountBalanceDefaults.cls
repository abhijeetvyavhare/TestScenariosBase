@isTest
public with sharing class AccountBalanceDefaults implements TestFactory.FieldDefaults{
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{
            'dmpl__GLAccountId__c' => 'null',
            'dmpl__Amount__c' => 1000
        };
    }
}