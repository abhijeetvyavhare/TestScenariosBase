@isTest
public with sharing class DiscountVoucherHandler_Test {

    @TestSetup
    static void createRequiredData() {
        Account partnerAccount = TestDataHelpers.createPartnerAccount();
        dmpl__AccountGroup__c accountGroup = TestDataHelpers.createAccountGroup();
        Account customerAccount = TestDataHelpers.createCustomerAccount();
        dmpl__Branch__c branch = TestDataHelpers.createBranch(partnerAccount);        
        dmpl__DiscountVoucher__c dv = DiscountVoucherTestDataHelper.createDiscountVoucher(customerAccount, branch, partnerAccount);
    }

    @isTest
    static void createDiscountVoucher() {
        dmpl__DiscountVoucher__c dv = DiscountVoucherTestDataHelper.getDiscountVoucher();
        System.assertNotEquals(null, dv, 'Discount Voucher should be created');
        System.assertEquals(100.00, dv.dmpl__Amount__c, 'Discount Voucher amount should be 100');
        System.assertNotEquals(null, dv.dmpl__AccountId__c, 'Account lookup should not be null');
        System.assertNotEquals(null, dv.dmpl__BranchId__c, 'Branch lookup should not be null');
        System.assertNotEquals(null, dv.dmpl__PartnerAccountId__c, 'Partner Account lookup should not be null');
    }

    @isTest
    static void updateDiscountVoucherPositive() {
        dmpl__DiscountVoucher__c dv = DiscountVoucherTestDataHelper.getDiscountVoucher();
        System.assertNotEquals(null, dv, 'Discount Voucher should exist before update');

        dv.dmpl__Amount__c = 150.00;
        update dv;

        dmpl__DiscountVoucher__c updatedDV = DiscountVoucherTestDataHelper.getDiscountVoucher();
        System.assertEquals(150.00, updatedDV.dmpl__Amount__c, 'Discount Voucher amount should be updated to 150');
    }

    @isTest
    static void deleteDiscountVoucher() {
        dmpl__DiscountVoucher__c dv = DiscountVoucherTestDataHelper.getDiscountVoucher();
        System.assertNotEquals(null, dv, 'Discount Voucher should exist before delete');

        delete dv;

        dmpl__DiscountVoucher__c deletedDV;
        try {
            deletedDV = DiscountVoucherTestDataHelper.getDiscountVoucher();
        } catch (Exception e) {
            deletedDV = null;
        }
        System.assertEquals(null, deletedDV, 'Discount Voucher should be deleted and not found in query');
    }
}