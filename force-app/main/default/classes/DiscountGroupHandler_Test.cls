@isTest
public with sharing class DiscountGroupHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Account partnerAccount = TestDataHelpers.createPartnerAccount();
        dmpl__AccountGroup__c accountGroup = TestDataHelpers.createAccountGroup();
        dmpl__Branch__c branch = TestDataHelpers.createBranch(partnerAccount);
        dmpl__DiscountGroup__c discountGroup = TestDataHelpers.createDiscountGroup(partnerAccount, accountGroup, branch);
    }
    
    @isTest
    static void createDiscountGroupPositive() {
        dmpl__DiscountGroup__c discountGroup = TestDataHelpers.getDiscountGroup();
        System.assertNotEquals(discountGroup, null, 'Expected DiscountGroup to be created.');
        System.assertEquals('Discount-Test', discountGroup.Name, 'Expected DiscountGroup name to be Discount-Test.');
    }
    
    @isTest
    static void updateDiscountGroupPositive() {
        dmpl__DiscountGroup__c discountGroup = TestDataHelpers.getDiscountGroup();
        System.assertNotEquals(discountGroup, null, 'DiscountGroup should exist before update.');
        
        discountGroup.Name = 'Updated Discount';
        update discountGroup;
        
        dmpl__DiscountGroup__c updatedGroup =  TestDataHelpers.getDiscountGroup();
        System.assertEquals('Updated Discount', updatedGroup.Name, 'DiscountGroup name should be updated.');
    }
    
    @isTest
    static void deleteDiscountGroup() {
        dmpl__DiscountGroup__c discountGroup = TestDataHelpers.getDiscountGroup();
        System.assertNotEquals(discountGroup, null, 'DiscountGroup should exist before delete.');
        
        delete discountGroup;
        
        dmpl__DiscountGroup__c deletedGroup = null;
        try {
            deletedGroup =  TestDataHelpers.getDiscountGroup();
        } catch (Exception e) {
            deletedGroup = null;
        }
        System.assertEquals(null, deletedGroup, 'DiscountGroup should be deleted and not found.');
    }
}