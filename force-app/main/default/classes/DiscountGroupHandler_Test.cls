@isTest
public with sharing class DiscountGroupHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Account partnerAccount = TestDataHelpers.createPartnerAccount();
        dmpl__AccountGroup__c accountGroup = TestDataHelpers.createAccountGroup();
        dmpl__Branch__c branch = TestDataHelpers.createBranch(partnerAccount);
        dmpl__DiscountGroup__c discountGroup = TestDataHelpers.createDiscountGroup(partnerAccount, accountGroup, branch);
        dmpl__DiscountGroup__c DisGroup1=DiscountDataHelper.createDiscountGroup('Discount Group 1', partnerAccount,branch);

        Account partnerAccount1 = TestDataHelpers.createPartnerAccount('Partner 1', false, true, false, true, 'MG Road', 'Bengaluru', 'Karnataka', 'India', '560001', '56 Industrial Layout', 'Bengaluru', 'Karnataka', 'India', '560095','9876543210');
        Account partnerAccount2 = TestDataHelpers.createPartnerAccount('Partner 2', false, true, false, true, '45 Residency Road', 'Pune', 'Maharashtra', 'India', '411001', '22 Commerce Avenue', 'Pune', 'Maharashtra', 'India', '411038','91-99665544433');
        Account partnerAccount3 = TestDataHelpers.createPartnerAccount('Partner 3', false, true, false, true, '78 Nehru Nagar Road', 'Chennai', 'Tamil Nadu', 'India', '600042', '78 Nehru Nagar Road', 'Chennai', 'Tamil Nadu', 'India', '600042', '91-9123456789');
        Account partnerAccount4 = TestDataHelpers.createPartnerAccount('Partner 4', false, true, false, true, '12 Industrial Zone', 'Hyderabad','Telangana', 'India', '500032', '12 Industrial Zone', 'Hyderabad', 'Telangana', 'India','500032','9876012345');
        
        dmpl__Branch__c branch1=TestDataHelpers.createBranch('Branch 1', partnerAccount1.Id, true, true, false, true);
        dmpl__Branch__c branch2 = TestDataHelpers.createBranch('Branch 2', partnerAccount2.Id, true, false, true, true);
        dmpl__Branch__c branch3 = TestDataHelpers.createBranch('Branch 3', partnerAccount3.Id, false, true, true, false);
        dmpl__Branch__c branch4 =TestDataHelpers.createBranch('Branch 4',partnerAccount4.Id,true,true,false,false);
   

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
    // Discount Group creation with correct partner and branch (New)
    @isTest
    static void createDiscountGroupWithCorrectPartnerandbranchPositive(){
    Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
    dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');

    Test.startTest();
    dmpl__DiscountGroup__c discountGroup = DiscountDataHelper.createDiscountGroup(
        'Discount 1',
        partner,
        branch
    );
    Test.stopTest();

    dmpl__DiscountGroup__c fetchedGroup = DiscountDataHelper.getDiscountGroup('Discount 1');

    System.assertEquals('Discount 1', fetchedGroup.Name, 'Name should match');
    System.assertEquals(partner.Id, fetchedGroup.dmpl__PartnerAccountId__c, 'Partner should match');
    System.assertEquals(branch.Id, fetchedGroup.dmpl__BranchId__c, 'Branch should match');
    }

    // Discount Group creation with wrong partner account (New)
    @isTest
    static void createDiscountGroupWithWrongPartnerAccountNegative() {
    Account partner = TestDataHelpers.getPartnerAccount('Partner 1'); 
    dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');

    Boolean exceptionThrown = false;

    Test.startTest();
    try {
        dmpl__DiscountGroup__c discountGroup = DiscountDataHelper.createDiscountGroup(
            'Discount 1',
            partner,
            branch
        );
    } catch (Exception e) {
        exceptionThrown = true;
    }
    Test.stopTest();

    System.assertEquals(true, exceptionThrown, 'Exception should be thrown for mismatched partner and branch.');
}
@isTest
static void updateDiscountGroupWithWrongPartnerAccountNegative() {
    Account correctPartner = TestDataHelpers.getPartnerAccount('Partner 4');
    Account wrongPartner = TestDataHelpers.getPartnerAccount('Partner 1');
    dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');

    
    dmpl__DiscountGroup__c discountGroup = DiscountDataHelper.createDiscountGroup(
        'Discount 1',
        correctPartner,
        branch
    );


    dmpl__DiscountGroup__c fetchedGroup = DiscountDataHelper.getDiscountGroup('Discount 1');

    System.assertEquals('Discount 1', fetchedGroup.Name, 'Name should match');
    System.assertEquals(correctPartner.Id, fetchedGroup.dmpl__PartnerAccountId__c, 'Partner should match before update');
    System.assertEquals(branch.Id, fetchedGroup.dmpl__BranchId__c, 'Branch should match before update');

    Boolean exceptionThrown = false;

    Test.startTest();
    try {
        fetchedGroup.dmpl__PartnerAccountId__c = wrongPartner.Id;
        update fetchedGroup;
    } catch (Exception e) {
        exceptionThrown = true;
    }
    Test.stopTest();

    System.assertEquals(true, exceptionThrown, 'Exception should be thrown when updating with wrong partner.');
}

// Discount Group creation with active partner account and without branch (New)
    @isTest
    static void createDiscountGroupWithActivePartnerandWithoutbranchPositive(){
    Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
    dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');

    Test.startTest();
    dmpl__DiscountGroup__c discountGroup = DiscountDataHelper.createDiscountGroup(
        'Discount 1',
        partner,
        null
    );
    Test.stopTest();

    dmpl__DiscountGroup__c fetchedGroup = DiscountDataHelper.getDiscountGroup('Discount 1');

    System.assertEquals('Discount 1', fetchedGroup.Name, 'Name should match');
    System.assertEquals(partner.Id, fetchedGroup.dmpl__PartnerAccountId__c, 'Partner should match');
    System.assertEquals(null, fetchedGroup.dmpl__BranchId__c, 'Branch should be nul');
    }
    @isTest
    static void updateDiscountGroupWithActivePartnerandWithoutbranch(){
    Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
    dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');

    Test.startTest();
    dmpl__DiscountGroup__c discountGroup = DiscountDataHelper.createDiscountGroup(
        'Discount 1',
        partner,
        branch
    );
    Test.stopTest();

    discountGroup.dmpl__BranchId__c=null;
    update discountGroup;

    dmpl__DiscountGroup__c fetchedGroup = DiscountDataHelper.getDiscountGroup('Discount 1');

    System.assertEquals('Discount 1', fetchedGroup.Name, 'Name should match');
    System.assertEquals(partner.Id, fetchedGroup.dmpl__PartnerAccountId__c, 'Partner should match');
    System.assertEquals(null, fetchedGroup.dmpl__BranchId__c, 'Branch should be nul');
    }


// Discount Group creation with wrong branch (New)
@isTest
    static void createDiscountGroupWithWrongBranchNegative() {
    Account partner = TestDataHelpers.getPartnerAccount('Partner 4'); 
    dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 2');

    Boolean exceptionThrown = false;

    Test.startTest();
    try {
        dmpl__DiscountGroup__c discountGroup = DiscountDataHelper.createDiscountGroup(
            'Discount 1',
            partner,
            branch
        );
    } catch (Exception e) {
        exceptionThrown = true;
    }
    Test.stopTest();

    System.assertEquals(true, exceptionThrown, 'Exception should be thrown for mismatched partner and branch.');
}
// Discount Group creation with wrong branch (Edit)
@isTest
static void updateDiscountGroupWithWrongBranchNegative() {
    Account Partner4 = TestDataHelpers.getPartnerAccount('Partner 4');
    Account Partner2 = TestDataHelpers.getPartnerAccount('Partner 2');
    dmpl__Branch__c branch4= TestDataHelpers.getBranch('Branch 4');
    dmpl__Branch__c branch2 = TestDataHelpers.getBranch('Branch 2');
    
    dmpl__DiscountGroup__c discountGroup = DiscountDataHelper.createDiscountGroup(
        'Discount 1',
        Partner4,
        branch4
    );


    dmpl__DiscountGroup__c fetchedGroup = DiscountDataHelper.getDiscountGroup('Discount 1');

    System.assertEquals('Discount 1', fetchedGroup.Name, 'Name should match');
    System.assertEquals(Partner4.Id, fetchedGroup.dmpl__PartnerAccountId__c, 'Partner should match before update');
    System.assertEquals(branch4.Id, fetchedGroup.dmpl__BranchId__c, 'Branch should match before update');

    Boolean exceptionThrown = false;

    Test.startTest();
    try {
        fetchedGroup.dmpl__BranchId__c=branch2.Id;
        update fetchedGroup;
    } catch (Exception e) {
        exceptionThrown = true;
    }
    Test.stopTest();

    System.assertEquals(true, exceptionThrown, 'Exception should be thrown when updating with Inactive partner.');
}
// Discount Group creation with inactive branch (New)
    @isTest
    static void createDiscountGroupWithInactiveBranchPositive(){
    Account partner = TestDataHelpers.getPartnerAccount('Partner 3');
    dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 3');

    Test.startTest();
    dmpl__DiscountGroup__c discountGroup = DiscountDataHelper.createDiscountGroup(
        'Discount 1',
        partner,
        branch
    );
    Test.stopTest();

    dmpl__DiscountGroup__c fetchedGroup = DiscountDataHelper.getDiscountGroup('Discount 1');

    System.assertEquals('Discount 1', fetchedGroup.Name, 'Name should match');
    System.assertEquals(partner.Id, fetchedGroup.dmpl__PartnerAccountId__c, 'Partner should match');
    System.assertEquals(branch.Id, fetchedGroup.dmpl__BranchId__c, 'Branch should match');
    }
// Discount Group creation with inactive branch (Edit)
@isTest
static void updateDiscountGroupWithInactiveBranchPositive() {
    Account partner4 = TestDataHelpers.getPartnerAccount('Partner 4');
    Account partner3 = TestDataHelpers.getPartnerAccount('Partner 3');
    dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 4');
    dmpl__Branch__c branch3 = TestDataHelpers.getBranch('Branch 3');

    Test.startTest();
    dmpl__DiscountGroup__c discountGroup = DiscountDataHelper.createDiscountGroup('Discount 1', partner4, branch4);
    

    dmpl__DiscountGroup__c fetchedGroup = DiscountDataHelper.getDiscountGroup('Discount 1');

    System.assertEquals('Discount 1', fetchedGroup.Name);
    System.assertEquals(partner4.Id, fetchedGroup.dmpl__PartnerAccountId__c);
    System.assertEquals(branch4.Id, fetchedGroup.dmpl__BranchId__c);

    fetchedGroup.dmpl__PartnerAccountId__c = partner3.Id;
    fetchedGroup.dmpl__BranchId__c = branch3.Id;
    update fetchedGroup;
    Test.stopTest();

    dmpl__DiscountGroup__c updatedGroup = DiscountDataHelper.getDiscountGroup('Discount 1');

    System.assertEquals('Discount 1', updatedGroup.Name);
    System.assertEquals(partner3.Id, updatedGroup.dmpl__PartnerAccountId__c);
    System.assertEquals(branch3.Id, updatedGroup.dmpl__BranchId__c);
}

// Discount Group creation with Sale Price discount type (New)
@isTest
static void createDiscountGroupWithSalePriceDiscountTypePositive() {
    Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
    dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');

    Test.startTest();
    dmpl__DiscountGroup__c discountGroup = (dmpl__DiscountGroup__c) TestFactory.createSObject(
        new dmpl__DiscountGroup__c(
            Name = 'Discount 1',
            dmpl__PartnerAccountId__c = partner.Id,
            dmpl__BranchId__c = branch.Id,
            dmpl__DiscountType__c = 'Sale Price'
        ),
        'DiscountGroupDefaults',
        true
    );
    Test.stopTest();

    dmpl__DiscountGroup__c fetchedGroup = DiscountDataHelper.getDiscountGroup('Discount 1');

    System.assertEquals('Discount 1', fetchedGroup.Name, 'Name should match');
    System.assertEquals(partner.Id, fetchedGroup.dmpl__PartnerAccountId__c, 'Partner should match');
    System.assertEquals(branch.Id, fetchedGroup.dmpl__BranchId__c, 'Branch should match');
    System.assertEquals('Sale Price', fetchedGroup.dmpl__DiscountType__c, 'Discount Type should be Sale Price');
}
// Discount Group creation with Sale Price discount type (Edit)
@isTest
static void updateDiscountGroupWithSalePriceDiscountTypePositive() {
    Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
    dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');


    dmpl__DiscountGroup__c discountGroup = (dmpl__DiscountGroup__c) TestFactory.createSObject(
        new dmpl__DiscountGroup__c(
            Name = 'Discount 1',
            dmpl__PartnerAccountId__c = partner.Id,
            dmpl__BranchId__c = branch.Id,
            dmpl__DiscountType__c = 'Purchase Price'
        ),
        'DiscountGroupDefaults',
        true
    );

    dmpl__DiscountGroup__c fetchedGroup = DiscountDataHelper.getDiscountGroup('Discount 1');

    System.assertEquals('Purchase Price', fetchedGroup.dmpl__DiscountType__c, 'Discount type should initially be Purchase Price');

    Test.startTest();
    fetchedGroup.dmpl__DiscountType__c = 'Sale Price';
    update fetchedGroup;
    Test.stopTest();

    dmpl__DiscountGroup__c updatedGroup = DiscountDataHelper.getDiscountGroup('Discount 1');
    System.assertEquals('Sale Price', updatedGroup.dmpl__DiscountType__c, 'Discount type should be updated to Sale Price');
}
// Discount Group creation with purchase Price discount type (New)
@isTest
static void createDiscountGroupWithPurchasePriceDiscountTypePositive() {
    Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
    dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');

    Test.startTest();
    dmpl__DiscountGroup__c discountGroup = (dmpl__DiscountGroup__c) TestFactory.createSObject(
        new dmpl__DiscountGroup__c(
            Name = 'Discount 2',
            dmpl__PartnerAccountId__c = partner.Id,
            dmpl__BranchId__c = branch.Id,
            dmpl__DiscountType__c = 'Purchase Price'
        ),
        'DiscountGroupDefaults',
        true
    );
    Test.stopTest();

    dmpl__DiscountGroup__c fetchedGroup = DiscountDataHelper.getDiscountGroup('Discount 2');

    System.assertEquals('Discount 2', fetchedGroup.Name, 'Name should match');
    System.assertEquals(partner.Id, fetchedGroup.dmpl__PartnerAccountId__c, 'Partner should match');
    System.assertEquals(branch.Id, fetchedGroup.dmpl__BranchId__c, 'Branch should match');
    System.assertEquals('Purchase Price', fetchedGroup.dmpl__DiscountType__c, 'Discount Type should be Sale Price');
}
// Discount Group creation with Purchase Price discount type (Edit)
@isTest
static void updateDiscountGroupWithPurchasePriceDiscountTypePositive() {
    Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
    dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');


    dmpl__DiscountGroup__c discountGroup = (dmpl__DiscountGroup__c) TestFactory.createSObject(
        new dmpl__DiscountGroup__c(
            Name = 'Discount 2',
            dmpl__PartnerAccountId__c = partner.Id,
            dmpl__BranchId__c = branch.Id,
            dmpl__DiscountType__c = 'Sale Price'
        ),
        'DiscountGroupDefaults',
        true
    );

    dmpl__DiscountGroup__c fetchedGroup = DiscountDataHelper.getDiscountGroup('Discount 2');

    System.assertEquals('Sale Price', fetchedGroup.dmpl__DiscountType__c, 'Discount type should initially be Purchase Price');

    Test.startTest();
    fetchedGroup.dmpl__DiscountType__c = 'Purchase Price';
    update fetchedGroup;
    Test.stopTest();

    dmpl__DiscountGroup__c updatedGroup = DiscountDataHelper.getDiscountGroup('Discount 2');
    System.assertEquals('Purchase Price', updatedGroup.dmpl__DiscountType__c, 'Discount type should be updated to Sale Price');
}

}