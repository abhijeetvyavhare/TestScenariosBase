@isTest
public with sharing class AccountHandler_Test {
    @TestSetup
    static void createRequiredData(){
        Account partnerAccount = AccountDataHelper.createPartnerAccount('PartnerAccount');
        Account customerAccount = AccountDataHelper.createCustomerAccount('CustomerAccount');
        Account supplierAccount = AccountDataHelper.createSupplierAccount('SupplierAccount');
        String setupAccountGroupName = 'Test Setup Account Group';
        dmpl__AccountGroup__c setupAccountGroup = AccountDataHelper.createAccountGroup(setupAccountGroupName);
        dmpl__AccountGroupRule__c accountGroupRule = AccountDataHelper.createAccountGroupRule(1, setupAccountGroup.Id);
        dmpl__AccountGroupMember__c accountGroupMember = AccountDataHelper.createAccountGroupMember(
            setupAccountGroup.Id, 
            'Test batch instance id'
        );
        String setupLocationName = 'Test Setup Location';
        dmpl__AccountLocations__c setupLocation = AccountDataHelper.createAccountLocation(setupLocationName);
        dmpl__AccountRewardLedger__c accountRewardLedger = AccountDataHelper.createAccountRewardLedger(customerAccount.Id, 200);
        dmpl__AccountStock__c accountStock = AccountDataHelper.createAccountStock(1000);
        Date startDate = Date.newInstance(2026, 1, 1);
        Date endDate = Date.newInstance(2026, 12, 31);
        dmpl__AccountUser__c accountUser = AccountDataHelper.createAccountUser(
            customerAccount.Id, 
            startDate,
            endDate
        );
        dmpl__GLAccount__c glAccount = AccountDataHelper.createGLAccount('Test GL Account');
        dmpl__AccountBalance__c accountBalance = AccountDataHelper.createAccountBalance(
            glAccount.Id, 
            1000
        );
    }

    @isTest
    static void createPartnerAccountPositive() {
        Account partnerAccount = AccountDataHelper.getAccountByName('PartnerAccount');
        System.assertNotEquals(partnerAccount, null, 'Expected partnerAccount to be created.');
    }

    @isTest
    static void createCustomerAccountPositive() {
        Account customerAccount = AccountDataHelper.getAccountByName('CustomerAccount');
        System.assertNotEquals(customerAccount, null, 'Expected customerAccount to be created.');
    }

    @isTest 
    static void createSupplierAccountPositive(){
        Account supplierAccount = AccountDataHelper.getAccountByName('SupplierAccount');
        System.assertNotEquals(supplierAccount, null, 'Expected supplier account to be created.');
    }

    @isTest 
    static void updatePartnerAccountPositive(){
        Account partnerAccount = AccountDataHelper.getAccountByName('PartnerAccount');
        partnerAccount.Name = 'UpdatedPartnerAccount';
        test.startTest();
        update partnerAccount;
        test.stopTest();
        Account updatedPartnerAccount = AccountDataHelper.getAccountById(partnerAccount.Id);
        System.assertEquals(
            String.valueOf(updatedPartnerAccount.Name),
            'UpdatedPartnerAccount',
            'Expected the account to be updated for partner account.'
        );
    }

    @isTest 
    static void updateCustomerAccountPositive(){
        Account customerAccount = AccountDataHelper.getAccountByName('CustomerAccount');
        customerAccount.Name = 'UpdatedCustomerAccount';
        test.startTest();
        update customerAccount;
        test.stopTest();
        Account updatedCustomerAccount = AccountDataHelper.getAccountById(customerAccount.Id);
        System.assertEquals(
            updatedCustomerAccount.Name,
            'UpdatedCustomerAccount',
            'Expected the account to be updated for customer account.'
        );
    }

    @isTest 
    static void updateSupplierAccountPositive(){
        Account supplierAccount = AccountDataHelper.getAccountByName('SupplierAccount');
        supplierAccount.Name = 'UpdatedSupplierAccount';
        test.startTest();
        update supplierAccount;
        test.stopTest();
        Account updatedSupplierAccount = AccountDataHelper.getAccountById(supplierAccount.Id);
        System.assertEquals(
            updatedSupplierAccount.Name,
            'UpdatedSupplierAccount',
            'Expected the supplier account to be updated.'
        );
    }

    @isTest 
    static void deletePartnerAccountPositive(){
        Account partnerAccount = AccountDataHelper.getAccountByName('PartnerAccount');
        test.startTest();
        delete partnerAccount;
        test.stopTest();
        Account deletedPartnerAccount = AccountDataHelper.getAccountById(partnerAccount.Id);
        System.assertEquals(
            deletedPartnerAccount,
            null,
            'Expected the partner account to be deleted.'
        );
    }

    @isTest
    static void deleteCustomerAccountPositive(){
        Account customerAccount = AccountDataHelper.getAccountByName('CustomerAccount');
        test.startTest();
        delete customerAccount;
        test.stopTest();
        Account deletedCustomerAccount = AccountDataHelper.getAccountById(customerAccount.Id);
        System.assertEquals(
            deletedCustomerAccount,
            null,
            'Expected the customer account to be deleted.'
        );
    }

    @isTest 
    static void deleteSupplierAccountPositive(){
        Account supplierAccount = AccountDataHelper.getAccountByName('SupplierAccount');
        test.startTest();
        delete supplierAccount;
        test.stopTest();
        Account deletedSupplierAccount = AccountDataHelper.getAccountById(supplierAccount.Id);
        System.assertEquals(
            deletedSupplierAccount,
            null,
            'Expected the supplier account to be deleted.'
        );
    }

    @isTest 
    static void createAccountGroupPositive() {
        dmpl__AccountGroup__c setupAccountGroup = AccountDataHelper.getAccountGroupByName('Test Setup Account Group');
        System.assertNotEquals(setupAccountGroup, null, 'Expected account group to be created.');
    }

    @isTest 
    static void updateAccountGroupPositive() {
        dmpl__AccountGroup__c setupAccountGroup = AccountDataHelper.getAccountGroupByName('Test Setup Account Group');
        setupAccountGroup.Name = 'Updated Name';
        Test.startTest();
        update setupAccountGroup;
        Test.stopTest();
        dmpl__AccountGroup__c updated = AccountDataHelper.getAccountGroupById(setupAccountGroup.Id);
        System.assertEquals(updated.Name, 'Updated Name', 'Account group name should be updated.');
    }

    @isTest 
    static void deleteAccountGroupPositive() {
        dmpl__AccountGroup__c setupAccountGroup = AccountDataHelper.getAccountGroupByName('Test Setup Account Group');
        Test.startTest();
        delete setupAccountGroup;
        Test.stopTest();
        dmpl__AccountGroup__c deletedGroups = AccountDataHelper.getAccountGroupById(setupAccountGroup.Id);
        System.assertEquals(deletedGroups, null, 'Account group should be deleted.');
    }

    @isTest 
    static void createAccountGroupRulePositive() {
        dmpl__AccountGroupRule__c accountGroupRule = AccountDataHelper.getAccountGroupRuleBySequenceNumber(1);
        System.assertNotEquals(accountGroupRule, null, 'Expected accountGroupRule to be created.');
    }

    @isTest
    static void updateAccountGroupRulePositive() {
        dmpl__AccountGroupRule__c accountGroupRule = AccountDataHelper.getAccountGroupRuleBySequenceNumber(1);
        accountGroupRule.dmpl__SequenceNumber__c = 5;
        Test.startTest();
        update accountGroupRule;
        Test.stopTest();
        dmpl__AccountGroupRule__c updated = AccountDataHelper.getAccountGroupRuleById(accountGroupRule.Id);
        System.assertEquals(updated.dmpl__SequenceNumber__c, 5, 'Account group rule sequence number should be updated.');
    }

    @isTest
    static void deleteAccountGroupRulePositive() {
        dmpl__AccountGroupRule__c accountGroupRule = AccountDataHelper.getAccountGroupRuleBySequenceNumber(1);
        Test.startTest();
        delete accountGroupRule;
        Test.stopTest();
        dmpl__AccountGroupRule__c deletedLines = AccountDataHelper.getAccountGroupRuleById(accountGroupRule.Id);
        System.assertEquals(deletedLines, null, 'Account group rule should be deleted.');
    }

    @isTest 
    static void createAccountGroupMemberPositive() {
        dmpl__AccountGroupMember__c accountGroupMember = AccountDataHelper.getAccountGroupMemberByBatchInstanceId('Test batch instance id');
        System.assertNotEquals(accountGroupMember, null, 'Expected accountGroupMember to be created.');
    }

    @isTest 
    static void updateAccountGroupMemberPositive() {
        dmpl__AccountGroupMember__c accountGroupMember = AccountDataHelper.getAccountGroupMemberByBatchInstanceId('Test batch instance id');
        accountGroupMember.dmpl__BatchInstanceId__c = 'Updated batch instance id';
        Test.startTest();
        update accountGroupMember;
        Test.stopTest();
        dmpl__AccountGroupMember__c updated = AccountDataHelper.getAccountGroupMemberById(accountGroupMember.Id);
        System.assertEquals(updated.dmpl__BatchInstanceId__c, 'Updated batch instance id', 'Account group member batch instance ID should be updated.');
    }

    @isTest
    static void deleteAccountGroupMemberPositive() {
        dmpl__AccountGroupMember__c accountGroupMember = AccountDataHelper.getAccountGroupMemberByBatchInstanceId('Test batch instance id');
        Test.startTest();
        delete accountGroupMember;
        Test.stopTest();
        dmpl__AccountGroupMember__c deletedMember = AccountDataHelper.getAccountGroupMemberById(accountGroupMember.Id);
        System.assertEquals(deletedMember, null, 'Account group member should be deleted.');
    }

    @isTest 
    static void createAccountLocationPositive() {
        dmpl__AccountLocations__c setUpLocation = AccountDataHelper.getAccountLocationByName('Test Setup Location');
        System.assertNotEquals(setUpLocation, null, 'Expected account location to be created.');
    }

    @isTest 
    static void updateAccountLocationPositive() {
        dmpl__AccountLocations__c setupLocation = AccountDataHelper.getAccountLocationByName('Test Setup Location');
        setupLocation.Name = 'Updated Name';
        Test.startTest();
        update setupLocation;
        Test.stopTest();
        dmpl__AccountLocations__c updated = AccountDataHelper.getAccountLocationById(setupLocation.Id);
        System.assertEquals(updated.Name, 'Updated Name', 'Account location name should be updated.');
    }

    @isTest 
    static void deleteAccountLocationPositive() {
        dmpl__AccountLocations__c setupLocation = AccountDataHelper.getAccountLocationByName('Test Setup Location');
        Test.startTest();
        delete setupLocation;
        Test.stopTest();
        dmpl__AccountLocations__c deletedLines = AccountDataHelper.getAccountLocationById(setupLocation.Id);
        System.assertEquals(deletedLines, null, 'Account location should be deleted.');
    }

    @isTest
    static void createAccountRewardLedgerPositive() {
        dmpl__AccountRewardLedger__c accountRewardLedger = AccountDataHelper.getAccountRewardLedgerByRewardPoints(200);
        System.assertNotEquals(accountRewardLedger, null, 'Expected account reward ledger to be created.');
    }

    @isTest
    static void updateAccountRewardLedgerPositive() {
        dmpl__AccountRewardLedger__c accountRewardLedger = AccountDataHelper.getAccountRewardLedgerByRewardPoints(200);
        accountRewardLedger.dmpl__RewardPoints__c = 300;
        Test.startTest();
        update accountRewardLedger;
        Test.stopTest();
        dmpl__AccountRewardLedger__c updated = AccountDataHelper.getAccountRewardLedgerById(accountRewardLedger.Id);
        System.assertEquals(updated.dmpl__RewardPoints__c, 300, 'Account reward ledger reward points should be updated.');
    }

    @isTest
    static void deleteAccountRewardLedgerPositive() {
        dmpl__AccountRewardLedger__c accountRewardLedger = AccountDataHelper.getAccountRewardLedgerByRewardPoints(200);
        Test.startTest();
        delete accountRewardLedger;
        Test.stopTest();
        dmpl__AccountRewardLedger__c deletedLines = AccountDataHelper.getAccountRewardLedgerById(accountRewardLedger.Id);
        System.assertEquals(deletedLines, null, 'Account reward ledger should be deleted.');
    }

    @isTest
    static void createAccountStockPositive() {
        dmpl__AccountStock__c accountStock = AccountDataHelper.getAccountStockByQuantity(1000);
        System.assertNotEquals(accountStock, null, 'Expected account stock to be created.');
    }

    @isTest
    static void updateAccountStockPositive() {
        dmpl__AccountStock__c accountStock = AccountDataHelper.getAccountStockByQuantity(1000);
        accountStock.dmpl__Quantity__c = 2000;
        Test.startTest();
        update accountStock;
        Test.stopTest();
        dmpl__AccountStock__c updated = AccountDataHelper.getAccountStockById(accountStock.Id);
        System.assertEquals(updated.dmpl__Quantity__c, 2000, 'Account stock quantity should be updated.');
    }

    @isTest
    static void deleteAccountStockPositive() {
        dmpl__AccountStock__c accountStock = AccountDataHelper.getAccountStockByQuantity(1000);
        Test.startTest();
        delete accountStock;
        Test.stopTest();
        dmpl__AccountStock__c deletedLines = AccountDataHelper.getAccountStockById(accountStock.Id);
        System.assertEquals(deletedLines, null, 'Account stock should be deleted.');
    }

    @isTest
    static void createAccountUserPositive(){
        dmpl__AccountUser__c accountUser = AccountDataHelper.getAccountUserByEffectiveFromDate(
            Date.newInstance(2026, 1, 1)
        );
        System.AssertNotEquals(accountUser, null, 'Expected account user to be created.');
    }

    @isTest
    static void updateAccountUserPositive(){
        dmpl__AccountUser__c accountUser = AccountDataHelper.getAccountUserByEffectiveFromDate(
            Date.newInstance(2026, 1, 1)
        );
        accountUser.dmpl__DateEffectiveFrom__c = Date.newInstance(2026, 2, 1);
        Test.startTest();
        update accountUser;
        Test.stopTest();
        dmpl__AccountUser__c updated = AccountDataHelper.getAccountUserById(accountUser.Id);
        System.assertEquals(
            updated.dmpl__DateEffectiveFrom__c, 
            Date.newInstance(2026, 2, 1), 
            'Account user effective from date should be updated.'
        );
    }

    @isTest
    static void deleteAccountUserPositive(){
        dmpl__AccountUser__c accountUser = AccountDataHelper.getAccountUserByEffectiveFromDate(
            Date.newInstance(2026, 1, 1)
        );
        Test.startTest();
        delete accountUser;
        Test.stopTest();
        dmpl__AccountUser__c deletedLines = AccountDataHelper.getAccountUserById(accountUser.Id);
        System.assertEquals(deletedLines, null, 'Account user should be deleted.');
    }

    @isTest
    static void createAccountBalancePositive() {
        dmpl__AccountBalance__c accountBalance = AccountDataHelper.getAccountBalanceByAmount(1000);
        System.assertNotEquals(accountBalance, null, 'Expected account balance to be created.');
    }

    @isTest
    static void updateAccountBalancePositive() {
        dmpl__AccountBalance__c accountBalance = AccountDataHelper.getAccountBalanceByAmount(1000);
        accountBalance.dmpl__Amount__c = 1500;
        Test.startTest();
        update accountBalance;
        Test.stopTest();
        dmpl__AccountBalance__c updated = AccountDataHelper.getAccountBalanceById(accountBalance.Id);
        System.assertEquals(updated.dmpl__Amount__c, 1500, 'Account balance amount should be updated.');
    }
    
    @isTest
    static void deleteAccountBalancePositive() {
        dmpl__AccountBalance__c accountBalance = AccountDataHelper.getAccountBalanceByAmount(1000);
        Test.startTest();
        delete accountBalance;
        Test.stopTest();
        dmpl__AccountBalance__c deletedLines = AccountDataHelper.getAccountBalanceById(accountBalance.Id);
        System.assertEquals(deletedLines, null, 'Account balance should be deleted.');
    }
}