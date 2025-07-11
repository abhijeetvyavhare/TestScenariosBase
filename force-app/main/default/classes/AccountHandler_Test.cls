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
        
        Account partnerAccount1 = TestDataHelpers.createPartnerAccount('Partner 1', false, true, false, true, 'MG Road', 'Bengaluru', 'Karnataka', 'India', '560001', '56 Industrial Layout', 'Bengaluru', 'Karnataka', 'India', '560095','9876543210');
        Account partnerAccount2 = TestDataHelpers.createPartnerAccount('Partner 2', false, true, false, true, '45 Residency Road', 'Pune', 'Maharashtra', 'India', '411001', '22 Commerce Avenue', 'Pune', 'Maharashtra', 'India', '411038','91-99665544433');
        Account partnerAccount4 = TestDataHelpers.createPartnerAccount('Partner 4', false, true, false, true, '12 Industrial Zone', 'Hyderabad','Telangana', 'India', '500032', '12 Industrial Zone', 'Hyderabad', 'Telangana', 'India','500032','9876012345');
        
        Account customerAccount1 = TestDataHelpers.createCustomerAccount('Customer 1', true, false, false, true, 'MG Road', 'Pune', 'Maharashtra', 'India', '411001', 'Ring Rd', 'Nagpur', 'Maharashtra', 'India', '440001','9876543210', 'Created');
        Account customerAccount7=TestDataHelpers.createCustomerAccount('Customer 7', true, false, false, false, 'Mission Road', 'Bengaluru', 'Karnataka', 'India', '560027', 'Indiranagar', 'Bengaluru', 'Karnataka', 'India', '560038','9811122233', 'Created');
        
        
        dmpl__Branch__c branch1=TestDataHelpers.createBranch('Branch 1', partnerAccount1.Id, true, true, false, true);
        dmpl__Branch__c branch2 = TestDataHelpers.createBranch('Branch 2', partnerAccount2.Id, true, false, true, true);
        dmpl__Branch__c branch4 =TestDataHelpers.createBranch('Branch 4',partnerAccount4.Id,true,true,false,false);
        
        dmpl__Item__c  item1 = TestDataHelpers.createItem('Item 1','Product',true,false,false,'675654',false);
        dmpl__Item__c item4 = TestDataHelpers.createItem('Item 4','Product',true, false, false ,'765676',true);
        dmpl__Item__c item2 = TestDataHelpers.createItem('Item 2','Product',false,false,false,'654345',false);
        
        dmpl__Resource__c resource1 = TestDataHelpers.createResource(partnerAccount4,branch4);
        dmpl__Resource__c resource2 = TestDataHelpers.createResource(partnerAccount2, branch2);
        
        dmpl__AccountGroup__c accountGroup1 = TestDataHelpers.createAccountGroup('Account Group 1',null);
        
        dmpl__VisitRoute__c route =VisitPlanTestDataHelpers.CreateVisitRoute(accountGroup1,partnerAccount1,resource1);
        dmpl__VisitRouteStop__c routeStop=VisitPlanTestDataHelpers.CreateVisitRouteStop(customerAccount1,route);
        dmpl__VisitTaskTemplate__c taskTemplate=VisitPlanTestDataHelpers.CreateVisitTaskTemplate();
        dmpl__VisitPlan__c plans=VisitPlanTestDataHelpers.CreateVisitPlan(partnerAccount1,route,taskTemplate);
        dmpl__Visit__c visits=VisitPlanTestDataHelpers.CreateVisit(customerAccount1,plans,taskTemplate);
        dmpl__VisitTaskTemplateEntry__c entry=VisitPlanTestDataHelpers.CreateVisitTaskTemplateEntry(taskTemplate);
        dmpl__VisitTaskTemplateActivity__c taskTempActivity=VisitPlanTestDataHelpers.CreateVisitTaskTemplateActivity(entry);
        dmpl__VisitTask__c task=VisitPlanTestDataHelpers.CreateVisitTask(visits,entry);
        dmpl__VisitTaskActivity__c taskActivity=VisitPlanTestDataHelpers.CreateVisitTaskActivity(task);
        
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
    
    @isTest
    static void createAccountStockWithActivePartnerAccountPositive(){
        Account partnerAccount4 = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 4');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        
        dmpl__AccountStock__c accountStock  = AccountDataHelper.createAccountStock(
            partnerAccount4.id,
        null,
        branch4.id,
        item1.id,
        null,
        null,
        null,
        null,
        null,
        null
            );
        
        dmpl__AccountStock__c fetchaccountStock = AccountDataHelper.getAccountStockById(accountStock.Id);
        
        System.assertEquals(partnerAccount4.Id, fetchaccountStock.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch4.Id, fetchaccountStock.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(item1.Id, fetchaccountStock.dmpl__ItemId__c, 'Item should match');
    }
    
    @isTest
    static void createAccountStockCreationWithActiveItemPositive(){
        Account partnerAccount1 = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        
        dmpl__AccountStock__c accountStock  = AccountDataHelper.createAccountStock(
            partnerAccount1.id,
        null,
        branch1.id,
        item1.id,
        null,
        null,
        null,
        null,
        null,
        null
            );
        
        dmpl__AccountStock__c fetchaccountStock = AccountDataHelper.getAccountStockById(accountStock.Id);
        
        System.assertEquals(partnerAccount1.Id, fetchaccountStock.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch1.Id, fetchaccountStock.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(item1.Id, fetchaccountStock.dmpl__ItemId__c, 'Item should match');
        
    }
    
    @isTest
    static void createAccountStockWithVisitAndVisitPlanReferencesPositive(){
        Test.startTest();
        Account partnerAccount4 = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 4');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        dmpl__VisitPlan__c visitplan = VisitPlanTestDataHelpers.getVisitPlan();
        dmpl__Visit__c visit = VisitPlanTestDataHelpers.getVisit();
        
        dmpl__AccountStock__c accountStock  = AccountDataHelper.createAccountStock(
            partnerAccount4.id,
        null,
        branch4.id,
        item1.id,
        visit.Id,
        visitplan.Id,
        null,
        null,
        null,
        null
            );
        
        dmpl__AccountStock__c fetched = AccountDataHelper.getAccountStockById(accountStock.Id);
        Test.stopTest();
        
        
        System.assertEquals(partnerAccount4.Id, fetched.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch4.Id, fetched.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(item1.Id, fetched.dmpl__ItemId__c, 'Item should match');
        System.assertEquals(visit.Id, fetched.dmpl__VisitId__c, 'Visit should match');
        System.assertEquals(visitPlan.Id, fetched.dmpl__VisitPlanId__c, 'Visit Plan should match');
    }
    
    @isTest
    static void createAccountStockWithQuantitiesPositive(){
        Account partnerAccount4 = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 4');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        
        
        dmpl__AccountStock__c accountStock  = AccountDataHelper.createAccountStock(
            partnerAccount4.id,
        null,
        branch4.id,
        item1.id,
        null,
        null,
        null,
        null,
        4,
        2
            );
        
        dmpl__AccountStock__c fetchaccountStock = AccountDataHelper.getAccountStockById(accountStock.Id);
        System.assertEquals(partnerAccount4.Id, fetchaccountStock.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch4.Id, fetchaccountStock.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(item1.Id, fetchaccountStock.dmpl__ItemId__c, 'Item should match');
        System.assertEquals(4, fetchaccountStock.dmpl__UOMQuantity__c, 'UOMQuantity should be 4');
        System.assertEquals(2, fetchaccountStock.dmpl__UOMQuantity1__c, 'UOMQuantity1 should be 2');
    }
    
    @isTest
    static void createAccountStockWithReferenceToResourceIDPositive(){
        Account partnerAccount4 = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 4');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        dmpl__Resource__c resource1 = TestDataHelpers.getResource();
        
        dmpl__AccountStock__c accountStock  = AccountDataHelper.createAccountStock(
            partnerAccount4.id,
        null,
        branch4.id,
        item1.id,
        null,
        null,
        resource1.Id,
        null,
        4,
        2
            );
        
        dmpl__AccountStock__c fetchaccountStock = AccountDataHelper.getAccountStockById(accountStock.Id);
        System.assertEquals(partnerAccount4.Id, fetchaccountStock.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch4.Id, fetchaccountStock.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(item1.Id, fetchaccountStock.dmpl__ItemId__c, 'Item should match');
        System.assertEquals(4, fetchaccountStock.dmpl__UOMQuantity__c, 'UOMQuantity should be 4');
        System.assertEquals(2, fetchaccountStock.dmpl__UOMQuantity1__c, 'UOMQuantity1 should be 2');
        System.assertEquals(resource1.Id, fetchaccountStock.dmpl__ResourceId__c, 'Resource should match');
    }


    @isTest
    static void createAccountStockCreationWithReferenceToPartnerAccountPositive(){
        Account partnerAccount4 = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 4');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        
        dmpl__AccountStock__c accountStock  = AccountDataHelper.createAccountStock(
            partnerAccount4.id,
        null,
        branch4.id,
        item1.id,
        null,
        null,
        null,
        null,
        null,
        null
            );
        
        dmpl__AccountStock__c fetchaccountStock = AccountDataHelper.getAccountStockById(accountStock.Id);
        System.assertEquals(partnerAccount4.Id, fetchaccountStock.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch4.Id, fetchaccountStock.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(item1.Id, fetchaccountStock.dmpl__ItemId__c, 'Item should match');
    }
    
    @isTest
    static void createAccountStockWithDuplicateItemsForSameAccountPositive(){
        Account partnerAccount4 = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 4');
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        
        
        
        dmpl__AccountStock__c accountStock  = AccountDataHelper.createAccountStock(
            partnerAccount4.id,
        customerAccount1.Id,
        branch4.id,
        item1.id,
        null,
        null,
        null,
        null,
        null,
        null
            );
            dmpl__AccountStock__c accountStock1  = AccountDataHelper.createAccountStock(
            partnerAccount4.id,
        customerAccount1.Id,
        branch4.id,
        item1.id,
        null,
        null,
        null,
        null,
        null,
        null
            );
        
        dmpl__AccountStock__c fetchaccountStock = AccountDataHelper.getAccountStockById(accountStock.Id);
        System.assertEquals(partnerAccount4.Id, fetchaccountStock.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch4.Id, fetchaccountStock.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(item1.Id, fetchaccountStock.dmpl__ItemId__c, 'Item should match');
        System.assertEquals(customerAccount1.Id, fetchaccountStock.dmpl__AccountId__c, 'Customer Account should match');
    }
    
    @isTest
    static void createAccountStockWithoutQuantityPositive(){
        Account partnerAccount4 = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 4');
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        
        
        
        dmpl__AccountStock__c accountStock  = AccountDataHelper.createAccountStock(
            partnerAccount4.id,
        customerAccount1.Id,
        branch4.id,
        item1.id,
        null,
        null,
        null,
        null,
        0,
        0
            );
        
        dmpl__AccountStock__c fetchaccountStock = AccountDataHelper.getAccountStockById(accountStock.Id);
        System.assertEquals(partnerAccount4.Id, fetchaccountStock.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch4.Id, fetchaccountStock.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(item1.Id, fetchaccountStock.dmpl__ItemId__c, 'Item should match');
        System.assertEquals(customerAccount1.Id, fetchaccountStock.dmpl__AccountId__c, 'Customer Account should match');
        
        System.assertEquals(0, fetchaccountStock.dmpl__UOMQuantity__c, 'UOMQuantity should be 0');
        System.assertEquals(0, fetchaccountStock.dmpl__UOMQuantity1__c, 'UOMQuantity1 should be 0');
    }
    
    @isTest
    static void createAccountStockWithInactiveAccountNegative() {
        Account partnerAccount4 = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 4');
        Account customerAccount7 = TestDataHelpers.getCustomerAccount('Customer 7');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        
        Test.startTest();
        
        Boolean didThrowException = false;
        try {
            dmpl__AccountStock__c accountStock = AccountDataHelper.createAccountStock(
                partnerAccount4.id,
            customerAccount7.Id,
            branch4.id,
            item1.id,
            null,
            null,
            null,
            null,
            null,
            null
                );
            
            
        } catch (Exception e) {
            didThrowException = true;
            System.debug('Expected exception caught: ' + e.getMessage());
        }
        
        Test.stopTest();
        
        System.assert(didThrowException, 'Expected an exception due to missing required fields, but none was thrown.');
    }
    @isTest
    static void createAccountStockWithInactiveItemPositive() {
        Account partnerAccount4 = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 4');
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Item__c item2 = TestDataHelpers.getItem('Item 2');
        
        System.assertEquals(false, item2.dmpl__IsActive__c, 'Item 2 should be inactive for this negative test');
        
        Test.startTest();
        dmpl__AccountStock__c accountStock = new dmpl__AccountStock__c();
        Boolean didThrowException = false;
        try {
            accountStock = AccountDataHelper.createAccountStock(
                partnerAccount4.Id,
            customerAccount1.Id,
            branch4.Id,
            item2.Id,
            null,
            null,
            null,
            null,
            null,
            null
                );
        } catch (Exception e) {
            didThrowException = true;
            
        }
        System.assertEquals(partnerAccount4.Id, accountStock.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch4.Id, accountStock.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(item2.Id, accountStock.dmpl__ItemId__c, 'Item should match');
        System.assertEquals(customerAccount1.Id, accountStock.dmpl__AccountId__c, 'Customer Account should match');
        Test.stopTest();
        
    }
    
    @isTest
    static void createAccountStockWithInactivePartnerAccountReferencePositive() {
        
        Account partnerAccount2 = TestDataHelpers.getPartnerAccount('Partner 2');
        dmpl__Branch__c branch2 = TestDataHelpers.getBranch('Branch 2');
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Item__c item4 = TestDataHelpers.getItem('Item 4');
        
        
        Test.startTest();
        dmpl__AccountStock__c accountStock = new dmpl__AccountStock__c();
        Boolean didThrowException = false;
        try {
            
            accountStock = AccountDataHelper.createAccountStock(
                partnerAccount2.Id,
            customerAccount1.Id,
            branch2.Id,
            item4.Id,
            null,
            null,
            null,
            null,
            null,
            null
                );
            
        } catch (Exception e) {
            didThrowException = true;
            System.debug('Expected exception caught: ' + e.getMessage());
        }
        System.assertEquals(partnerAccount2.Id, accountStock.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch2.Id, accountStock.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(item4.Id, accountStock.dmpl__ItemId__c, 'Item should match');
        System.assertEquals(customerAccount1.Id, accountStock.dmpl__AccountId__c, 'Customer Account should match');
        Test.stopTest();
    
    }
    
    @isTest
    static void createAccountStockWithInactiveResourceIDPositive() {
        
        Account partnerAccount4 = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 4');
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Item__c item4 = TestDataHelpers.getItem('Item 4');
        dmpl__Resource__c resource2 = TestDataHelpers.getResource();
        
        
        Test.startTest();
        dmpl__AccountStock__c accountStock = new dmpl__AccountStock__c();
        Boolean didThrowException = false;
        try {
            accountStock = AccountDataHelper.createAccountStock(
                partnerAccount4.Id,
            customerAccount1.Id,
            branch4.Id,
            item4.Id,
            null,
            null,
            resource2.Id,
            null,
            null,
            null
                );
            
        } catch (Exception e) {
            didThrowException = true;
            System.debug('Expected exception caught: ' + e.getMessage());
        }
        System.assertEquals(partnerAccount4.Id, accountStock.dmpl__PartnerAccountId__c, 'Partner Account should match');
        System.assertEquals(branch4.Id, accountStock.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(item4.Id, accountStock.dmpl__ItemId__c, 'Item should match');
        System.assertEquals(customerAccount1.Id, accountStock.dmpl__AccountId__c, 'Customer Account should match');
        System.assertEquals(resource2.Id, accountStock.dmpl__ResourceId__c, 'Resource should match');

        Test.stopTest();
    }
    
    @isTest
    static void createAccountStockWithNegativeQuantityValuesNegative() {
        
        Account partnerAccount4 = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 4');
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        
        partnerAccount4.dmpl__IsActive__c = false;
        update partnerAccount4;
        
        System.assertEquals(false, partnerAccount4.dmpl__IsActive__c, 'Partner account should be inactive for this negative test');
        
        Test.startTest();
        Boolean didThrowException = false;
        try {
            dmpl__AccountStock__c accountStock = AccountDataHelper.createAccountStock(
                partnerAccount4.Id,
            customerAccount1.Id,
            branch4.Id,
            item1.Id,
            null,
            null,
            null,
            null,
            -2,
            null
                );
            
        } catch (Exception e) {
            didThrowException = true;
            System.debug('Expected exception caught: ' + e.getMessage());
        }
        Test.stopTest();
        
        System.assert(didThrowException, 'Expected an exception due to inactive partner account, but none was thrown.');
    }
    
    @isTest
    static void createAccountStockCreationWithOnlyPiecesPositive() {
        
        Account partnerAccount4 = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 4');
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        
        
        Test.startTest();
        Boolean didThrowException = false;
        dmpl__AccountStock__c accountStock;
        try {
             accountStock = AccountDataHelper.createAccountStock(
                partnerAccount4.Id,
            customerAccount1.Id,
            branch4.Id,
            item1.Id,
            null,
            null,
            null,
            null,
            null,
            4
                );
        }catch(Exception e){
            System.assert(accountStock != null, 'Expected to be craeted >> '+e.getMessage());
        }
            Test.stopTest();
        }
    @isTest
    static void createAccountStockWithOnlyCaseQuantityPositive() {
        
        Account partnerAccount4 = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 4');
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        
    
        Test.startTest();
        Boolean didThrowException = false;
        dmpl__AccountStock__c accountStock ;
        try {
             accountStock = AccountDataHelper.createAccountStock(
                partnerAccount4.Id,
            customerAccount1.Id,
            branch4.Id,
            item1.Id,
            null,
            null,
            null,
            null,
            2,
            null
                );
         } catch(Exception e){
            System.assert(accountStock != null, 'Expected to be craeted >> ' + e.getMessage());
        }
            Test.stopTest(); 
        
    }
    @isTest
    static void createAccountStockWithoutVisitReferencesPositive() {
        
        Account partnerAccount4 = TestDataHelpers.getPartnerAccount('Partner 4');
        dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 4');
        Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
          
        Test.startTest();
        Boolean didThrowException = false;
        dmpl__AccountStock__c accountStock;
        try {
             accountStock = AccountDataHelper.createAccountStock(
                partnerAccount4.Id,
            customerAccount1.Id,
            branch4.Id,
            item1.Id,
            null,
            null,
            null,
            null,
            null,
            null
                );

        }catch(Exception e){
            System.assert(accountStock!=null, 'Expected to be craeted >> '+  e.getMessage());
        }
            Test.stopTest();
        }
        @isTest
        static void createAccountStockRecordWithFutureDatedVisitPlanPositive() {
            
            Test.startTest();
            Account partnerAccount4 = TestDataHelpers.getPartnerAccount('Partner 4');
            Account partnerAccount2 = TestDataHelpers.getPartnerAccount('Partner 2');
            dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 4');
            dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
            dmpl__VisitPlan__c visitplan = VisitPlanTestDataHelpers.getVisitPlan();
            dmpl__VisitPlan__c futureVisitPlan = VisitPlanTestDataHelpers.getVisitPlan(); 
            dmpl__VisitRoute__c route = VisitPlanTestDataHelpers.getVisitRoute();
            dmpl__VisitTaskTemplate__c task = VisitPlanTestDataHelpers.getVisitTaskTemplate();
            dmpl__VisitPlan__c newPlans=VisitPlanTestDataHelpers.CreateVisitPlan(partnerAccount2,route,task);
            
            dmpl__AccountStock__c accountStock = AccountDataHelper.createAccountStock(
                partnerAccount4.Id,
            null,
            branch4.Id,
            item1.Id,
            null,
            visitplan.Id,
            null,
            null,
            null,
            null
                );
    
    dmpl__AccountStock__c fetched = AccountDataHelper.getAccountStockById(accountStock.Id);

    Test.stopTest();
    System.assertEquals(partnerAccount4.Id, fetched.dmpl__PartnerAccountId__c, 'Partner should be Partner 4');
    System.assertEquals(branch4.Id, fetched.dmpl__BranchId__c, 'Branch should be Branch 4');
    System.assertEquals(item1.Id, fetched.dmpl__ItemId__c, 'Item should be Item 1');
    System.assertEquals(visitplan.Id, fetched.dmpl__VisitPlanId__c, 'Initial Visit Plan should match');
    
    fetched.dmpl__VisitPlanId__c = futureVisitPlan.Id;
    update fetched;

    dmpl__AccountStock__c updated = AccountDataHelper.getAccountStockById(fetched.Id);
    System.assertEquals(futureVisitPlan.Id, updated.dmpl__VisitPlanId__c, 'Visit Plan should be updated to future plan');
            
    }

    @isTest
static void createAccountStockWithVisitPlanAndDifferentVisitNegative() { 
    
    Test.startTest();
    
    Account partnerAccount4 = TestDataHelpers.getPartnerAccount('Partner 4');
    Account customerAccount1 = TestDataHelpers.getCustomerAccount('Customer 1');
    dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 4');
    dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
    dmpl__Visit__c visit = VisitPlanTestDataHelpers.getVisit();
    dmpl__VisitPlan__c originalVisitPlan = VisitPlanTestDataHelpers.getVisitPlan();
    dmpl__VisitPlan__c futureVisitPlan = VisitPlanTestDataHelpers.getVisitPlan(); 
    
    
    dmpl__AccountStock__c accountStock = AccountDataHelper.createAccountStock(
        partnerAccount4.Id,
        customerAccount1.Id,
        branch4.Id,
        item1.Id,
        visit.Id,
        originalVisitPlan.Id,
        null,
        null,
        null,
        null
    );

  
    Boolean didThrowException = false;

    try {
        accountStock.dmpl__VisitPlanId__c = futureVisitPlan.Id;
        update accountStock; 
    } catch (Exception e) {
        didThrowException = true;
        System.debug('Expected exception caught when updating to a different VisitPlan: ' + e.getMessage());
    }
    Test.stopTest();

    }

}