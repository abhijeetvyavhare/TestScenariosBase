@isTest
public with sharing class BankingTransactionDefaults implements TestFactory.FieldDefaults{
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{ 
            'Name' => 'Transaction1',
            'dmpl__Date__c' => Date.today(),
            'dmpl__Deposit__c' => 2000,
            'dmpl__Payee__c' => 'Shubham',
            'dmpl__Withdrawal__c' => 1000,
            'dmpl__Status__c' => 'Categorized'
        };
    }
}