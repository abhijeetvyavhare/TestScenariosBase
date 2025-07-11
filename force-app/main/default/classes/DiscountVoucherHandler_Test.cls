@isTest
public with sharing class DiscountVoucherHandler_Test {

    @TestSetup
    static void createRequiredData() {
        Account partnerAccount = TestDataHelpers.createPartnerAccount();
        dmpl__AccountGroup__c accountGroup = TestDataHelpers.createAccountGroup();
        Account customerAccount = TestDataHelpers.createCustomerAccount();
        dmpl__Branch__c branch = TestDataHelpers.createBranch(partnerAccount);        
        dmpl__DiscountVoucher__c dv = DiscountVoucherTestDataHelper.createDiscountVoucher(customerAccount, branch, partnerAccount);

         Account partnerAccount1 = TestDataHelpers.createPartnerAccount('Partner 1', false, true, false, true, 'MG Road', 'Bengaluru', 'Karnataka', 'India', '560001', '56 Industrial Layout', 'Bengaluru', 'Karnataka', 'India', '560095','9876543210');
        Account partnerAccount2 = TestDataHelpers.createPartnerAccount('Partner 2', false, true, false, true, '45 Residency Road', 'Pune', 'Maharashtra', 'India', '411001', '22 Commerce Avenue', 'Pune', 'Maharashtra', 'India', '411038','91-99665544433');
        Account partnerAccount3 = TestDataHelpers.createPartnerAccount('Partner 3', false, true, false, true, '78 Nehru Nagar Road', 'Chennai', 'Tamil Nadu', 'India', '600042', '78 Nehru Nagar Road', 'Chennai', 'Tamil Nadu', 'India', '600042', '91-9123456789');

        Account customerAccount1 = TestDataHelpers.createCustomerAccount('Customer 1', true, false, false, true, 'MG Road', 'Pune', 'Maharashtra', 'India', '411001', 'Ring Rd', 'Nagpur', 'Maharashtra', 'India', '440001','9876543210', 'Created');
        Account customerAccount2 = TestDataHelpers.createCustomerAccount('Customer 2', true, false, false, true, 'Park St', 'Kolkata', 'West Bengal', 'India', '700016', 'Lake Rd', 'Kolkata', 'West Bengal', 'India', '700029','9876543210', 'Created');
        Account customerAccount3 = TestDataHelpers.createCustomerAccount('Customer 3', true, false, false, true, 'Anna Salai', 'Chennai', 'Tamil Nadu', 'India', '600002', 'T Nagar', 'Chennai', 'Tamil Nadu', 'India', '600017','9012345678', 'Created');

        dmpl__Branch__c branch1=TestDataHelpers.createBranch('Branch 1', partnerAccount1.Id, true, true, false, true);
        dmpl__Branch__c branch3 = TestDataHelpers.createBranch('Branch 3', partnerAccount3.Id, false, true, true, false);
        
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

    // Discount Voucher creation with correct partner and branch (New)
    @isTest
    static void CreateDiscountVoucherWithCorrectPartnerAndBranchPositive() {
    Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
    Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
    dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');

    Test.startTest();
    dmpl__DiscountVoucher__c voucher = DiscountVoucherTestDataHelper.createDiscountVoucherById(partner, customer, branch);
    dmpl__DiscountVoucher__c fetchedVoucher = DiscountVoucherTestDataHelper.getDiscountVoucherById(voucher.Id);
    Test.stopTest();

    System.assertEquals(partner.Id, fetchedVoucher.dmpl__PartnerAccountId__c, 'Partner should match');
    System.assertEquals(branch.Id, fetchedVoucher.dmpl__BranchId__c, 'Branch should match');
    System.assertEquals(customer.Id, fetchedVoucher.dmpl__AccountId__c, 'Customer should match');
}
    // Discount Voucher creation with wrong partner account (New)
    @isTest
    static void CreateDiscountVoucherWithWrongPartnerPositive() {
    Account partner = TestDataHelpers.getPartnerAccount('Partner 3');
    Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
    dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');

    Test.startTest();
    dmpl__DiscountVoucher__c voucher = DiscountVoucherTestDataHelper.createDiscountVoucherById(partner, customer, branch);
    dmpl__DiscountVoucher__c fetchedVoucher = DiscountVoucherTestDataHelper.getDiscountVoucherById(voucher.Id);
    Test.stopTest();

    System.assertEquals(partner.Id, fetchedVoucher.dmpl__PartnerAccountId__c, 'Partner should match');
    System.assertEquals(branch.Id, fetchedVoucher.dmpl__BranchId__c, 'Branch should match');
    System.assertEquals(customer.Id, fetchedVoucher.dmpl__AccountId__c, 'Customer should match');
    }
    
    // Discount Voucher creation with wrong partner account (Edit)

@isTest
static void UpdateDiscountVoucherWithWrongPartnerPositive() {
    Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
    Account partner3 = TestDataHelpers.getPartnerAccount('Partner 3');
    Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
    dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');

    Test.startTest();
    dmpl__DiscountVoucher__c voucher = DiscountVoucherTestDataHelper.createDiscountVoucherById(partner1, customer1, branch1);
    dmpl__DiscountVoucher__c fetchedVoucher = DiscountVoucherTestDataHelper.getDiscountVoucherById(voucher.Id);

    System.assertEquals(partner1.Id, fetchedVoucher.dmpl__PartnerAccountId__c, 'Initial partner should be Partner 1');
    System.assertEquals(branch1.Id, fetchedVoucher.dmpl__BranchId__c, 'Branch should be Branch 1');
    System.assertEquals(customer1.Id, fetchedVoucher.dmpl__AccountId__c, 'Customer should be Customer 1');

    fetchedVoucher.dmpl__PartnerAccountId__c = partner3.Id;
    update fetchedVoucher;
    Test.stopTest();

    dmpl__DiscountVoucher__c updatedVoucher = DiscountVoucherTestDataHelper.getDiscountVoucherById(fetchedVoucher.Id);

    System.assertEquals(partner3.Id, updatedVoucher.dmpl__PartnerAccountId__c, 'Partner should be updated to Partner 3');
    System.assertEquals(branch1.Id, updatedVoucher.dmpl__BranchId__c, 'Branch should remain Branch 1');
    System.assertEquals(customer1.Id, updatedVoucher.dmpl__AccountId__c, 'Customer should remain Customer 1');
}

// Discount Voucher creation with inactive partner account (New)
    @isTest
        static void CreateDiscountVoucherWithActivePartnerWithoutBranchPositive() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');

        Test.startTest();
        dmpl__DiscountVoucher__c voucher = DiscountVoucherTestDataHelper.createDiscountVoucherById(partner, customer, null);
        dmpl__DiscountVoucher__c fetchedVoucher = DiscountVoucherTestDataHelper.getDiscountVoucherById(voucher.Id);
        Test.stopTest();

        System.assertEquals(partner.Id, fetchedVoucher.dmpl__PartnerAccountId__c, 'Partner should match');
        System.assertEquals(null, fetchedVoucher.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(customer.Id, fetchedVoucher.dmpl__AccountId__c, 'Customer should match');
    }
// Discount Voucher creation with inactive partner account (Edit)

@isTest
static void UpdateDiscountVoucherWithActivePartnerWithoutBranchPositive() {
    Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
    Account partner3 = TestDataHelpers.getPartnerAccount('Partner 3');
    Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
    dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
    dmpl__Branch__c branch3 = TestDataHelpers.getBranch('Branch 3');
    Test.startTest();
    dmpl__DiscountVoucher__c voucher = DiscountVoucherTestDataHelper.createDiscountVoucherById(partner1, customer1, branch1);
    dmpl__DiscountVoucher__c fetchedVoucher = DiscountVoucherTestDataHelper.getDiscountVoucherById(voucher.Id);


    System.assertEquals(partner1.Id, fetchedVoucher.dmpl__PartnerAccountId__c, 'Initial partner should be Partner 1');
    System.assertEquals(branch1.Id, fetchedVoucher.dmpl__BranchId__c, 'Branch should be Branch 1');
    System.assertEquals(customer1.Id, fetchedVoucher.dmpl__AccountId__c, 'Customer should be Customer 1');


    fetchedVoucher.dmpl__BranchId__c = null;
    update fetchedVoucher;
    Test.stopTest();

    dmpl__DiscountVoucher__c updatedVoucher = DiscountVoucherTestDataHelper.getDiscountVoucherById(fetchedVoucher.Id);

    System.assertEquals(partner1.Id, updatedVoucher.dmpl__PartnerAccountId__c, 'Partner should be updated to Partner 3');
    System.assertEquals(null, updatedVoucher.dmpl__BranchId__c, 'Branch should remain Branch 1');
    System.assertEquals(customer1.Id, updatedVoucher.dmpl__AccountId__c, 'Customer should remain Customer 1');
}
// Discount Voucher creation with wrong branch (New)
    @isTest
        static void CreateDiscountVoucherWithWrongBranchPositive() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 3');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');

        Test.startTest();
        dmpl__DiscountVoucher__c voucher = DiscountVoucherTestDataHelper.createDiscountVoucherById(partner, customer, branch);
        dmpl__DiscountVoucher__c fetchedVoucher = DiscountVoucherTestDataHelper.getDiscountVoucherById(voucher.Id);
        Test.stopTest();

        System.assertEquals(partner.Id, fetchedVoucher.dmpl__PartnerAccountId__c, 'Partner should match');
        System.assertEquals(branch.Id, fetchedVoucher.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(customer.Id, fetchedVoucher.dmpl__AccountId__c, 'Customer should match');
    }


@isTest
static void UpdateDiscountVoucherWithWrongBranchPositive() {
    Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
    Account partner3 = TestDataHelpers.getPartnerAccount('Partner 3');
    Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
    dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
    dmpl__Branch__c branch3 = TestDataHelpers.getBranch('Branch 3');

    Test.startTest();
    dmpl__DiscountVoucher__c voucher = DiscountVoucherTestDataHelper.createDiscountVoucherById(partner1, customer1, branch1);
    dmpl__DiscountVoucher__c fetchedVoucher = DiscountVoucherTestDataHelper.getDiscountVoucherById(voucher.Id);

    System.assertEquals(partner1.Id, fetchedVoucher.dmpl__PartnerAccountId__c, 'Initial partner should be Partner 1');
    System.assertEquals(branch1.Id, fetchedVoucher.dmpl__BranchId__c, 'Branch should be Branch 1');
    System.assertEquals(customer1.Id, fetchedVoucher.dmpl__AccountId__c, 'Customer should be Customer 1');

    fetchedVoucher.dmpl__BranchId__c = branch3.Id;
    update fetchedVoucher;
    Test.stopTest();

    dmpl__DiscountVoucher__c updatedVoucher = DiscountVoucherTestDataHelper.getDiscountVoucherById(fetchedVoucher.Id);

    System.assertEquals(partner1.Id, updatedVoucher.dmpl__PartnerAccountId__c, 'Partner should be updated to Partner 3');
    System.assertEquals(branch3.Id, updatedVoucher.dmpl__BranchId__c, 'Branch should remain Branch 1');
    System.assertEquals(customer1.Id, updatedVoucher.dmpl__AccountId__c, 'Customer should remain Customer 1');
}
// Discount Voucher creation with inactive branch (New)
    @isTest
        static void CreateDiscountVoucherWithInactiveBranchPositive() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch3 = TestDataHelpers.getBranch('Branch 3');

        Test.startTest();
        dmpl__DiscountVoucher__c voucher = DiscountVoucherTestDataHelper.createDiscountVoucherById(partner, customer, branch3);
        dmpl__DiscountVoucher__c fetchedVoucher = DiscountVoucherTestDataHelper.getDiscountVoucherById(voucher.Id);
        Test.stopTest();

        System.assertEquals(partner.Id, fetchedVoucher.dmpl__PartnerAccountId__c, 'Partner should match');
        System.assertEquals(branch3.Id, fetchedVoucher.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(customer.Id, fetchedVoucher.dmpl__AccountId__c, 'Customer should match');
    }
// Discount Voucher creation with inactive branch (Edit)

@isTest
static void UpdateDiscountVoucherWithInactiveBranchPositive() {
    Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
    Account partner3 = TestDataHelpers.getPartnerAccount('Partner 3');
    Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
    dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
    dmpl__Branch__c branch3 = TestDataHelpers.getBranch('Branch 3');

    Test.startTest();
    dmpl__DiscountVoucher__c voucher = DiscountVoucherTestDataHelper.createDiscountVoucherById(partner1, customer1, branch1);
    dmpl__DiscountVoucher__c fetchedVoucher = DiscountVoucherTestDataHelper.getDiscountVoucherById(voucher.Id);

    System.assertEquals(partner1.Id, fetchedVoucher.dmpl__PartnerAccountId__c, 'Initial partner should be Partner 1');
    System.assertEquals(branch1.Id, fetchedVoucher.dmpl__BranchId__c, 'Branch should be Branch 1');
    System.assertEquals(customer1.Id, fetchedVoucher.dmpl__AccountId__c, 'Customer should be Customer 1');


    fetchedVoucher.dmpl__PartnerAccountId__c = partner3.Id;
    fetchedVoucher.dmpl__BranchId__c=branch3.Id;
    update fetchedVoucher;
    Test.stopTest();

    dmpl__DiscountVoucher__c updatedVoucher = DiscountVoucherTestDataHelper.getDiscountVoucherById(fetchedVoucher.Id);

    System.assertEquals(partner3.Id, updatedVoucher.dmpl__PartnerAccountId__c, 'Partner should be updated to Partner 3');
    System.assertEquals(branch3.Id, updatedVoucher.dmpl__BranchId__c, 'Branch should remain Branch 1');
    System.assertEquals(customer1.Id, updatedVoucher.dmpl__AccountId__c, 'Customer should remain Customer 1');
}





}