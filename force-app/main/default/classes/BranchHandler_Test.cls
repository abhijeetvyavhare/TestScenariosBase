@isTest
public with sharing class BranchHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Account partnerAccount = TestDataHelpers.createPartnerAccount();
        dmpl__Branch__c branch = TestDataHelpers.createBranch(partnerAccount);
    }

    @isTest
    static void createBranchPositive() {
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        System.assertNotEquals(branch, null, 'Expected branch to be created.');
        System.assertEquals('TheBestAccount', branch.Name, 'Name not matched.');
        System.assertNotEquals(branch.dmpl__PartnerAccountId__c, null, 'Expected dmpl__PartnerAccountId__c to be set.');
    }

    @isTest
    static void updateBranchPositive() {
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        System.assertNotEquals(branch, null, 'Branch should exist before update.');
        branch.Name = 'UpdatedBranch';
        update branch;
        dmpl__Branch__c updatedBranch = TestDataHelpers.getBranch();
        System.assertEquals('UpdatedBranch', updatedBranch.Name, 'Expected Name to be updated to UpdatedBranch.');
    }

    @isTest
    static void deleteBranchPositive() {
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        System.assertNotEquals(branch, null, 'Branch should exist before delete.');
        delete branch;
        dmpl__Branch__c deletedBranch;
        try {
            deletedBranch = TestDataHelpers.getBranch();
        } catch (Exception e) {
            deletedBranch = null;
        }

        System.assertEquals(null, deletedBranch, 'Expected Branch to be deleted and not found.');
    }


  
   
}