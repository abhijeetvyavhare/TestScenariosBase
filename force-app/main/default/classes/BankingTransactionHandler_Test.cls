@isTest
public with sharing class BankingTransactionHandler_Test {
    @TestSetup
    static void createRequiredData(){
        dmpl__AccountGroup__c accGroup = TestDataHelpers.createAccountGroup();
        Account partnerAccount = TestDataHelpers.createPartnerAccount();
        dmpl__Branch__c branch = TestDataHelpers.createBranch(partnerAccount);
        dmpl__GLAccount__c glAccount = GLAccountDataHelper.createGLAccount(partnerAccount, branch, accGroup);
        dmpl__BankingTransaction__c bankingTransaction = BankingTransactionTestDataHelpers.createBankingTransaction(glAccount.Id);
    }

    @isTest
    static void createBankingTransactionPositive(){
        dmpl__BankingTransaction__c bankingTransaction = BankingTransactionTestDataHelpers.getBankingTransaction();
        System.assertNotEquals(bankingTransaction, null, 'BankingTransaction should be created.');
        System.assertEquals('Transaction1', bankingTransaction.Name, 'Name mismatch');
        System.assertEquals(Date.today(), bankingTransaction.dmpl__Date__c, 'Date mismatch');
        System.assertEquals(2000, bankingTransaction.dmpl__Deposit__c, 'Deposit mismatch');
        System.assertEquals('Shubham', bankingTransaction.dmpl__Payee__c, 'Payee mismatch');
        System.assertEquals(1000, bankingTransaction.dmpl__Withdrawal__c, 'Withdrawal mismatch');
        System.assertEquals('Categorized', bankingTransaction.dmpl__Status__c, 'Status mismatch');
    }
        
    @isTest
    static void updateBankingTransactionPositive() {
        dmpl__BankingTransaction__c bankingTransaction = BankingTransactionTestDataHelpers.getBankingTransaction();
        bankingTransaction.Name = 'Transaction';
        bankingTransaction.dmpl__Date__c = Date.today().addDays(1);
        bankingTransaction.dmpl__Deposit__c = 3000;
        bankingTransaction.dmpl__Payee__c = 'Shubham Singh';
        bankingTransaction.dmpl__Status__c = 'Pending';
        bankingTransaction.dmpl__Withdrawal__c = 1000;
    
        update bankingTransaction;
    
        dmpl__BankingTransaction__c updatedBankingTransaction = BankingTransactionTestDataHelpers.getBankingTransaction(bankingTransaction.Id);
        System.assertEquals('Transaction', updatedBankingTransaction.Name, 'Name should be updated.');
        System.assertEquals(Date.today().addDays(1), updatedBankingTransaction.dmpl__Date__c, 'Date should be updated.');
        System.assertEquals(3000, updatedBankingTransaction.dmpl__Deposit__c, 'Deposit should be updated.');
        System.assertEquals('Shubham Singh', updatedBankingTransaction.dmpl__Payee__c, 'Payee should be updated.');
        System.assertEquals('Pending', updatedBankingTransaction.dmpl__Status__c, 'Status should be updated.');
        System.assertEquals(1000, updatedBankingTransaction.dmpl__Withdrawal__c, 'Withdrawal should be updated.');
    }

    @isTest
    static void deleteBankingTransaction() {
        dmpl__BankingTransaction__c bankingTransaction = BankingTransactionTestDataHelpers.getBankingTransaction();
        System.assertNotEquals(bankingTransaction, null, 'BankingTransaction should exist before delete.');

        delete bankingTransaction;

        dmpl__BankingTransaction__c deletedBankingTransaction = null;
        try {
            deletedBankingTransaction = BankingTransactionTestDataHelpers.getBankingTransaction(bankingTransaction.Id);
        } catch (Exception e) {
            deletedBankingTransaction = null;
        }
        System.assertEquals(null, deletedBankingTransaction, 'BankingTransaction should be deleted and not found in query.');
    }
}