@isTest
public with sharing class GLAccountHandler_Test {
    @TestSetup
    static void createRequiredData(){
        dmpl__AccountGroup__c accGroup = TestDataHelpers.createAccountGroup();
        Account partnerAccount = TestDataHelpers.createPartnerAccount();
        dmpl__Branch__c branch = TestDataHelpers.createBranch(partnerAccount);
        dmpl__GLAccount__c glAccount = GLAccountDataHelper.createGLAccount(partnerAccount, branch, accGroup);
    }

    @isTest
    static void testInsertGLAccount() {
        dmpl__GLAccount__c glAccount = GLAccountDataHelper.getGLAccount();
        System.assert(glAccount != null && glAccount.Id != null, 'GL Account should be inserted.');
        System.assertEquals('123', glAccount.dmpl__AccountNumber__c, 'AccountNumber should match default');
        System.assertEquals('Fixed Assets', glAccount.dmpl__AccountType__c, 'AccountType should match default');
        System.assertEquals('INR', glAccount.dmpl__Currency__c, 'Currency should match default');
        System.assertEquals('Description Value', glAccount.dmpl__Description__c, 'Description should match default');
        System.assertEquals('890', glAccount.dmpl__ExternalId__c, 'ExternalId should match default');
        System.assertEquals('Testing GL Account', glAccount.Name, 'Name should match default');
        System.assertEquals(false, glAccount.dmpl__IsActive__c, 'IsActive should match default');
        System.assertEquals(false, glAccount.dmpl__IsSystem__c, 'IsSystem should match default');
        System.assertEquals('SGST', glAccount.dmpl__TaxType__c, 'TaxType should match default');
    }

    @isTest
    static void testUpdateGLAccount() {
        dmpl__GLAccount__c glAccount = GLAccountDataHelper.getGLAccount();
        glAccount.dmpl__AccountNumber__c = '456';
        glAccount.dmpl__AccountType__c = 'Current Assets';
        glAccount.dmpl__Currency__c = 'USD';
        glAccount.dmpl__Description__c = 'Updated Description';
        glAccount.dmpl__ExternalId__c = '999';
        glAccount.Name = 'Updated GL Name';
        glAccount.dmpl__IsActive__c = true;
        glAccount.dmpl__IsSystem__c = true;
        glAccount.dmpl__TaxType__c = 'IGST';
        update glAccount;
        dmpl__GLAccount__c updatedGL = GLAccountDataHelper.getGLAccount();
        System.assertEquals('456', updatedGL.dmpl__AccountNumber__c, 'AccountNumber should be updated');
        System.assertEquals('Current Assets', updatedGL.dmpl__AccountType__c, 'AccountType should be updated');
        System.assertEquals('USD', updatedGL.dmpl__Currency__c, 'Currency should be updated');
        System.assertEquals('Updated Description', updatedGL.dmpl__Description__c, 'Description should be updated');
        System.assertEquals('999', updatedGL.dmpl__ExternalId__c, 'ExternalId should be updated');
        System.assertEquals('Updated GL Name', updatedGL.Name, 'Name should be updated');
        System.assertEquals(true, updatedGL.dmpl__IsActive__c, 'IsActive should be updated');
        System.assertEquals(true, updatedGL.dmpl__IsSystem__c, 'IsSystem should be updated');
        System.assertEquals('IGST', updatedGL.dmpl__TaxType__c, 'TaxType should be updated');
    }

    @isTest
    static void testDeleteGLAccount() {
        dmpl__GLAccount__c glAccount = GLAccountDataHelper.getGLAccount();
        Id glId = glAccount.Id;
        delete glAccount;
        Integer countGL = [SELECT COUNT() FROM dmpl__GLAccount__c WHERE Id = :glId];
        System.assertEquals(0, countGL, 'GL Account should be deleted');
    }
}