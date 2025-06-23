public with sharing class BankingTransactionTestDataHelpers {
    public static dmpl__BankingTransaction__c createBankingTransaction(
        Id glAccountId
    ) {
        return (dmpl__BankingTransaction__c)TestFactory.createSObject(
            new dmpl__BankingTransaction__c(
                dmpl__GLAccountId__c = glAccountId
            ),
            'BankingTransactionDefaults',
            true
        );
    }

    public static dmpl__BankingTransaction__c getBankingTransaction(){
        return [
            SELECT     	
                Id, 
                Name, 
                dmpl__Status__c, 
                dmpl__Withdrawal__c, 
                dmpl__Payee__c, 
                dmpl__Deposit__c, 
                dmpl__GLAccountId__c, 
                dmpl__Date__c 
            FROM dmpl__BankingTransaction__c 
            LIMIT 1
        ];
    }

    public static dmpl__BankingTransaction__c getBankingTransaction(Id id){
        return [
            SELECT 
                Id, 
                Name, 
                dmpl__Status__c, 
                dmpl__Withdrawal__c, 
                dmpl__Payee__c, 
                dmpl__Deposit__c, 
                dmpl__GLAccountId__c, 
                dmpl__Date__c 
            FROM dmpl__BankingTransaction__c 
            WHERE Id = :id 
            LIMIT 1
        ];
    }
}