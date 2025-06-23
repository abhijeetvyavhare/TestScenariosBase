@isTest
public with sharing class TaxHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Account partnerAccount = TestDataHelpers.createPartnerAccount();
        dmpl__AccountGroup__c partnerAccountGroup = TestDataHelpers.createAccountGroup();
        dmpl__Branch__c branch = TestDataHelpers.createBranch(partnerAccount);
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.createTaxGroup(partnerAccount, branch);
        dmpl__Tax__c tax = TestDataHelpers.createTax(taxGroup);
    }

    @isTest
    static void createTaxPositive() {
        dmpl__Tax__c tax = TestDataHelpers.getTax();
        System.assertNotEquals(null, tax, 'Expected Tax record to be created.');
        System.assertEquals('Test - Tax', tax.Name, 'Tax Name should match.');
        System.assertEquals(10, tax.dmpl__Rate__c, 'Tax Rate should be 10.');
    }

    @isTest
    static void updateTaxPositive() {
        dmpl__Tax__c tax = TestDataHelpers.getTax();
        System.assertNotEquals(null, tax, 'Tax should exist before update.');

        tax.dmpl__Rate__c = 15;
        update tax;

        dmpl__Tax__c updatedTax = TestDataHelpers.getTax();
        System.assertEquals(15, updatedTax.dmpl__Rate__c, 'Tax rate should be updated to 15.');
    }

    @isTest
    static void deleteTax() {
        dmpl__Tax__c tax = TestDataHelpers.getTax();
        System.assertNotEquals(null, tax, 'Tax should exist before delete.');

        delete tax;

        dmpl__Tax__c deletedTax;
        try {
            deletedTax = TestDataHelpers.getTax();
        } catch (Exception e) {
            deletedTax = null;
        }
        System.assertEquals(null, deletedTax, 'Tax should be deleted and not found in query.');
    }
}