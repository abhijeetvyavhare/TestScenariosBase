@isTest
public with sharing class DiscountGroupRuleHandler_Test {

    @TestSetup
    static void createRequiredData() {
        Account partnerAccount = TestDataHelpers.createPartnerAccount();
        dmpl__AccountGroup__c accountGroup = TestDataHelpers.createAccountGroup();
        dmpl__Branch__c branch = TestDataHelpers.createBranch(partnerAccount);
        dmpl__DiscountGroup__c discountGroup = TestDataHelpers.createDiscountGroup(partnerAccount, accountGroup, branch);
        dmpl__Item__c item = TestDataHelpers.createItem();
        dmpl__SKU__c sku = TestDataHelpers.createSKU(item);
        dmpl__PriceList__c priceList = TestDataHelpers.createPriceList(partnerAccount, branch);
        dmpl__ItemLotType__c itemLotType = TestDataHelpers.createItemLotType(item);
        
        dmpl__ItemGroup__c itemGroup2 = TestDataHelpers.createItemGroup('Item Group 2','Tax');
        

         Account partnerAccount1 = TestDataHelpers.createPartnerAccount('Partner 1', false, true, false, true, 'MG Road', 'Bengaluru', 'Karnataka', 'India', '560001', '56 Industrial Layout', 'Bengaluru', 'Karnataka', 'India', '560095','9876543210');
        Account partnerAccount2 = TestDataHelpers.createPartnerAccount('Partner 2', false, true, false, false, '45 Residency Road', 'Pune', 'Maharashtra', 'India', '411001', '22 Commerce Avenue', 'Pune', 'Maharashtra', 'India', '411038','91-99665544433');
        Account partnerAccount3 = TestDataHelpers.createPartnerAccount('Partner 3', false, true, false, true, '78 Nehru Nagar Road', 'Chennai', 'Tamil Nadu', 'India', '600042', '78 Nehru Nagar Road', 'Chennai', 'Tamil Nadu', 'India', '600042', '91-9123456789');
		 Account partnerAccount4 = TestDataHelpers.createPartnerAccount('Partner 4', false, true, false, true, '12 Industrial Zone', 'Hyderabad','Telangana', 'India', '500032', '12 Industrial Zone', 'Hyderabad', 'Telangana', 'India','500032','9876012345');
         Account partnerAccount6 = TestDataHelpers.createPartnerAccount('Partner 6', false, true, false, true, 'MS Road', 'Bengaluru','Karnataka', 'India', '560001', '56 Industrial Layout', 'Bengaluru', 'Karnataka', 'India','560095','9845543210');
        
        dmpl__Branch__c branch1=TestDataHelpers.createBranch('Branch 1', partnerAccount1.Id, true, true, false, true);
        dmpl__Branch__c branch3 = TestDataHelpers.createBranch('Branch 3', partnerAccount3.Id, false, true, true, false);
        dmpl__Branch__c branch4 =TestDataHelpers.createBranch('Branch 4',partnerAccount4.Id,true,true,false,false);
        dmpl__Branch__c branch6 =TestDataHelpers.createBranch('Branch 6',partnerAccount6.Id,true,true,false,true);

        dmpl__Item__c  item1 = TestDataHelpers.createItem('Item 1','Product',true,false,false,'675654',false);
        dmpl__Item__c item2 = TestDataHelpers.createItem('Item 2','Product',false,false,false,'654345',false);
        dmpl__Item__c item8 = TestDataHelpers.createItem('Item 8','Product',true,false,false, '765456',false);
        dmpl__Item__c item10 = TestDataHelpers.createItem('Item 10','Product',true,false,true, '765456',false);
        dmpl__Item__c item7 = TestDataHelpers.createItem('Item 7','Product',true,false,false, '765456',false);

        dmpl__SKU__c sku1 = TestDataHelpers.createSKU('SKU 1', item7.id, true);
        dmpl__SKU__c sku2 = TestDataHelpers.createSKU('SKU 2', item8.id, false);
        dmpl__SKU__c sku4 = TestDataHelpers.createSKU('SKU 4', item10.id, true);

    }
    
@isTest
    static void createDiscountGroupRulePositive() {
        dmpl__DiscountGroupRule__c rule = DiscountGroupRuleTestDataHelper.getDiscountGroupRule();
        System.assertNotEquals(null, rule, 'Discount Group Rule should be created');
        System.assertNotEquals(null, rule.dmpl__DiscountGroupId__c, 'Discount Group should not be null');
        System.assertNotEquals(null, rule.dmpl__SKUId__c, 'SKU should not be null');
        System.assertNotEquals(null, rule.dmpl__PriceListId__c, 'Price List should not be null');
        System.assertNotEquals(null, rule.dmpl__ItemLotTypeId__c, 'Item Lot Type should not be null');

        System.assertEquals(null, rule.dmpl__ItemGroupId__c, 'Item Group is optional and should be null here');
    }

    @isTest
    static void updateDiscountGroupRulePositive() {
        dmpl__DiscountGroupRule__c rule = DiscountGroupRuleTestDataHelper.getDiscountGroupRule();
        System.assertNotEquals(null, rule, 'Discount Group Rule should exist before update');

        rule.dmpl__DiscountPercent__c = 25.5;
        update rule;

        dmpl__DiscountGroupRule__c updatedRule = DiscountGroupRuleTestDataHelper.getDiscountGroupRule();
        System.assertEquals(25.5, updatedRule.dmpl__DiscountPercent__c, 'Discount Percentage should be updated to 25.5');
    }

    @isTest
    static void deleteDiscountGroupRule() {
        dmpl__DiscountGroupRule__c rule = DiscountGroupRuleTestDataHelper.getDiscountGroupRule();
        System.assertNotEquals(null, rule, 'Discount Group Rule should exist before delete');

        Id ruleId = rule.Id;
        delete rule;

        List<dmpl__DiscountGroupRule__c> ruleAfterDelete = [
            SELECT Id FROM dmpl__DiscountGroupRule__c WHERE Id = :ruleId
        ];
    }

    @isTest
    static void CreateDiscountGroupRuleWithDiscountGroupReferencePositive() {
    Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
    dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');

    Test.startTest();
    dmpl__DiscountGroup__c discountGroup = DiscountGroupDataHelper.createDiscountGroup(
        'Discount 1',
        partner,
        branch
    );
    discountGroup.dmpl__DiscountType__c = 'Purchase Price';
    update discountGroup;

    dmpl__DiscountGroup__c fetchedGroup = DiscountGroupDataHelper.getDiscountGroup('Discount 1');

    System.assertEquals('Discount 1', fetchedGroup.Name, 'Name should match');
    System.assertEquals(partner.Id, fetchedGroup.dmpl__PartnerAccountId__c, 'Partner should match');
    System.assertEquals(branch.Id, fetchedGroup.dmpl__BranchId__c, 'Branch should match');
    System.assertEquals('Purchase Price', fetchedGroup.dmpl__DiscountType__c, 'Discount Type should match');

    Date fromDate = Date.newInstance(2025, 5, 1);
    Date tillDate = Date.newInstance(2025, 7, 30);

    dmpl__DiscountGroupRule__c rule = DiscountGroupRuleTestDataHelper.createDiscountGroupRule(
        discountGroup,
        4,
        fromDate,
        tillDate,
        null, null, null, null, null
    );
    Test.stopTest();
    List<dmpl__DiscountGroupRule__c> rules = DiscountGroupRuleTestDataHelper.getDiscountGroupRulesByGroupId(discountGroup.Id);

    dmpl__DiscountGroupRule__c fetchedRule = rules[0];

    System.assertEquals(discountGroup.Id, fetchedRule.dmpl__DiscountGroupId__c, 'Discount Group reference should match');
    System.assertEquals(4, fetchedRule.dmpl__DiscountPercent__c, 'Discount percent should be 4');
    System.assertEquals(fromDate, fetchedRule.dmpl__DateEffectiveFrom__c, 'Effective From date should match');
    System.assertEquals(tillDate, fetchedRule.dmpl__DateEffectiveTill__c, 'Effective Till date should match');
}
// Discount Group rule creation with Discount rule reference (Edit)
@isTest
static void UpdateDiscountGroupRuleWithDiscountGroupNegative() {
    Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
    dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');

    dmpl__DiscountGroup__c discountGroup1 = DiscountGroupDataHelper.createDiscountGroup(
        'Discount 1',
        partner,
        branch
    );

    dmpl__DiscountGroup__c fetchedGroup1 = DiscountGroupDataHelper.getDiscountGroup('Discount 1');
    System.assertEquals('Discount 1', fetchedGroup1.Name);
    System.assertEquals(partner.Id, fetchedGroup1.dmpl__PartnerAccountId__c);
    System.assertEquals(branch.Id, fetchedGroup1.dmpl__BranchId__c);

    Date fromDate = Date.newInstance(2025, 5, 1);
    Date tillDate = Date.newInstance(2025, 7, 30);

    dmpl__DiscountGroupRule__c rule = DiscountGroupRuleTestDataHelper.createDiscountGroupRule(
        fetchedGroup1,
        4,
        fromDate,
        tillDate,
        null,
        null,
        null,
        null,
        null
    );

    List<dmpl__DiscountGroupRule__c> rules = DiscountGroupRuleTestDataHelper.getDiscountGroupRulesByGroupId(fetchedGroup1.Id);

    dmpl__DiscountGroup__c discountGroup2 = DiscountGroupDataHelper.createDiscountGroup(
        'Discount 2',
        partner,
        branch
    );

    dmpl__DiscountGroup__c fetchedGroup2 = DiscountGroupDataHelper.getDiscountGroup('Discount 2');
    System.assertEquals('Discount 2', fetchedGroup2.Name);

    Boolean exceptionThrown = false;

    Test.startTest();
    try {
        dmpl__DiscountGroupRule__c ruleToUpdate = rules[0];
        ruleToUpdate.dmpl__DiscountGroupId__c = fetchedGroup2.Id;
        ruleToUpdate.dmpl__DateEffectiveFrom__c = Date.newInstance(2025, 6, 5);
        ruleToUpdate.dmpl__DateEffectiveTill__c = Date.newInstance(2025, 11, 30);
        update ruleToUpdate;
    } catch (Exception e) {
        exceptionThrown = true;
    }
    Test.stopTest();

    System.assertEquals(true, exceptionThrown, 'Exception should be thrown due to changing Discount Group reference.');
}



// Discount Group rule creation with Discount Percentage (New)
@isTest
static void CreateDiscountGroupRuleWithDiscountPercentagePositive() {
    Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
    dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');

    Test.startTest();
    dmpl__DiscountGroup__c discountGroup = DiscountGroupDataHelper.createDiscountGroup(
        'Discount 1',
        partner,
        branch
    );
    discountGroup.dmpl__DiscountType__c = 'Purchase Price';
    update discountGroup;

    dmpl__DiscountGroup__c fetchedGroup = DiscountGroupDataHelper.getDiscountGroup('Discount 1');

    System.assertEquals('Discount 1', fetchedGroup.Name, 'Name should match');
    System.assertEquals(partner.Id, fetchedGroup.dmpl__PartnerAccountId__c, 'Partner should match');
    System.assertEquals(branch.Id, fetchedGroup.dmpl__BranchId__c, 'Branch should match');
    System.assertEquals('Purchase Price', fetchedGroup.dmpl__DiscountType__c, 'Discount Type should match');

    Date fromDate = Date.newInstance(2025, 5, 1);
    Date tillDate = Date.newInstance(2025, 7, 30);

    dmpl__DiscountGroupRule__c rule = DiscountGroupRuleTestDataHelper.createDiscountGroupRule(
        discountGroup,
        4,
        fromDate,
        tillDate,
        null, null, null, null, null
    );
    Test.stopTest();

    List<dmpl__DiscountGroupRule__c> rules = DiscountGroupRuleTestDataHelper.getDiscountGroupRulesByGroupId(discountGroup.Id);

    dmpl__DiscountGroupRule__c fetchedRule = rules[0];

    System.assertEquals(discountGroup.Id, fetchedRule.dmpl__DiscountGroupId__c, 'Discount Group reference should match');
    System.assertEquals(4, fetchedRule.dmpl__DiscountPercent__c, 'Discount percent should be 4');
    System.assertEquals(fromDate, fetchedRule.dmpl__DateEffectiveFrom__c, 'Effective From date should match');
    System.assertEquals(tillDate, fetchedRule.dmpl__DateEffectiveTill__c, 'Effective Till date should match');
}
// Discount Group rule creation with Discount Percentage (Edit)
@isTest
static void UpdateDiscountGroupRuleWithUpdatedDiscountPercentPositive() {
    Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
    dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');

    dmpl__DiscountGroup__c discountGroup = DiscountGroupDataHelper.createDiscountGroup('Discount 1', partner, branch);
    discountGroup.dmpl__DiscountType__c = 'Purchase Price';
    update discountGroup;

    System.assertEquals('Discount 1', discountGroup.Name);
    System.assertEquals('Purchase Price', discountGroup.dmpl__DiscountType__c);
    System.assertEquals(partner.Id, discountGroup.dmpl__PartnerAccountId__c);
    System.assertEquals(branch.Id, discountGroup.dmpl__BranchId__c);

    Date fromDate = Date.newInstance(2025, 5, 1);
    Date tillDate = Date.newInstance(2025, 7, 30);

    Test.startTest();
    dmpl__DiscountGroupRule__c rule = DiscountGroupRuleTestDataHelper.createDiscountGroupRule(
        discountGroup,
        7,
        fromDate,
        tillDate,
        null, null, null, null, null
    );

    List<dmpl__DiscountGroupRule__c> rulesBeforeUpdate = DiscountGroupRuleTestDataHelper.getDiscountGroupRulesByGroupId(discountGroup.Id);

    dmpl__DiscountGroupRule__c fetchedRule = rulesBeforeUpdate[0];
    System.assertEquals(discountGroup.Id, fetchedRule.dmpl__DiscountGroupId__c);
    System.assertEquals(7, fetchedRule.dmpl__DiscountPercent__c);
    System.assertEquals(fromDate, fetchedRule.dmpl__DateEffectiveFrom__c);
    System.assertEquals(tillDate, fetchedRule.dmpl__DateEffectiveTill__c);

    fetchedRule.dmpl__DiscountPercent__c = 4;

    update fetchedRule;
    Test.stopTest();

    List<dmpl__DiscountGroupRule__c> rulesAfterUpdate = DiscountGroupRuleTestDataHelper.getDiscountGroupRulesByGroupId(discountGroup.Id);
    dmpl__DiscountGroupRule__c updatedRule = rulesAfterUpdate[0];

    System.assertEquals(4, updatedRule.dmpl__DiscountPercent__c);
    System.assertEquals(fromDate, updatedRule.dmpl__DateEffectiveFrom__c);
    System.assertEquals(tillDate, updatedRule.dmpl__DateEffectiveTill__c);
    System.assertEquals(discountGroup.Id, updatedRule.dmpl__DiscountGroupId__c);
}
// Discount Group rule creation with Date Effective form (New)
@isTest
static void CreateDiscountGroupRuleWithDateEffectivePositive() {
    Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
    dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');

    Test.startTest();
    dmpl__DiscountGroup__c discountGroup = DiscountGroupDataHelper.createDiscountGroup(
        'Discount 1',
        partner,
        branch
    );
    discountGroup.dmpl__DiscountType__c = 'Purchase Price';
    update discountGroup;

    dmpl__DiscountGroup__c fetchedGroup = DiscountGroupDataHelper.getDiscountGroup('Discount 1');

    System.assertEquals('Discount 1', fetchedGroup.Name, 'Name should match');
    System.assertEquals(partner.Id, fetchedGroup.dmpl__PartnerAccountId__c, 'Partner should match');
    System.assertEquals(branch.Id, fetchedGroup.dmpl__BranchId__c, 'Branch should match');
    System.assertEquals('Purchase Price', fetchedGroup.dmpl__DiscountType__c, 'Discount Type should match');

    Date fromDate = Date.newInstance(2025, 5, 1);

    dmpl__DiscountGroupRule__c rule = DiscountGroupRuleTestDataHelper.createDiscountGroupRule(
        discountGroup,
        4,
        fromDate,
        null,
        null, null, null, null, null
    );
    Test.stopTest();

    List<dmpl__DiscountGroupRule__c> rules = DiscountGroupRuleTestDataHelper.getDiscountGroupRulesByGroupId(discountGroup.Id);


    dmpl__DiscountGroupRule__c fetchedRule = rules[0];

    System.assertEquals(discountGroup.Id, fetchedRule.dmpl__DiscountGroupId__c, 'Discount Group reference should match');
    System.assertEquals(4, fetchedRule.dmpl__DiscountPercent__c, 'Discount percent should be 4');
    System.assertEquals(fromDate, fetchedRule.dmpl__DateEffectiveFrom__c, 'Effective From date should match');
}

@isTest
static void UpdateDiscountGroupRuleWithDateEffectiveFormPositive() {
    Account Partner4 = TestDataHelpers.getPartnerAccount('Partner 4');
    dmpl__Branch__c branch4 = TestDataHelpers.getBranch('Branch 4');
    Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
    dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
    dmpl__DiscountGroup__c discountGroup1 = DiscountGroupDataHelper.createDiscountGroup('Discount 1', partner4, branch4);
    discountGroup1.dmpl__DiscountType__c = 'Purchase Price';
    update discountGroup1;

    dmpl__DiscountGroup__c discountGroup2 = DiscountGroupDataHelper.createDiscountGroup('Discount 2', partner1, branch1);
    discountGroup2.dmpl__DiscountType__c = 'Purchase Price';
    update discountGroup2;

    Date fromDate = Date.newInstance(2025, 5, 1);
    Test.startTest();
    dmpl__DiscountGroupRule__c rule = DiscountGroupRuleTestDataHelper.createDiscountGroupRule(
        discountGroup1,
        4,
        fromDate,
        null, null, null, null, null,null
    );
    List<dmpl__DiscountGroupRule__c> rulesBeforeUpdate = DiscountGroupRuleTestDataHelper.getDiscountGroupRulesByGroupId(discountGroup1.Id);
    
    dmpl__DiscountGroupRule__c fetchedRule = rulesBeforeUpdate[0];

    System.assertEquals(discountGroup1.Id, fetchedRule.dmpl__DiscountGroupId__c, 'Initial Discount Group should match');
    System.assertEquals(fromDate, fetchedRule.dmpl__DateEffectiveFrom__c);

    Date newFromDate = Date.newInstance(2025, 1, 5);
    fetchedRule.dmpl__DateEffectiveFrom__c = newFromDate;

    update fetchedRule;
    Test.stopTest();

    List<dmpl__DiscountGroupRule__c> rulesAfterUpdate = DiscountGroupRuleTestDataHelper.getDiscountGroupRulesByGroupId(discountGroup1.Id);
   dmpl__DiscountGroupRule__c updatedRule = rulesAfterUpdate[0];

    System.assertEquals(newFromDate, updatedRule.dmpl__DateEffectiveFrom__c, 'Updated From Date should match');

}
@isTest
static void CreateDiscountGroupRuleWithNoDateEffectiveFromNegative() {
    Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
    dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');

    dmpl__DiscountGroup__c discountGroup = DiscountGroupDataHelper.createDiscountGroup(
        'Discount 1',
        partner,
        branch
    );

    dmpl__DiscountGroup__c fetchedGroup = DiscountGroupDataHelper.getDiscountGroup('Discount 1');
    System.assertEquals(partner.Id, fetchedGroup.dmpl__PartnerAccountId__c);
    System.assertEquals(branch.Id, fetchedGroup.dmpl__BranchId__c);
    System.assertEquals('Discount 1', fetchedGroup.Name);

    Boolean exceptionThrown = false;

    Test.startTest();
    try {
        DiscountGroupRuleTestDataHelper.createDiscountGroupRule(
            discountGroup,
            4,
            null,
            null,
            null,
            null,
            null,
            null,
            null
        );
    } catch (System.DmlException e) {
        exceptionThrown = true;
    }
    Test.stopTest();

    System.assertEquals(true, exceptionThrown, 'Exception should be thrown due to missing DateEffectiveFrom.');
}

// Discount Group rule creation with active item (New)
@isTest
static void CreateDiscountGroupRuleWithActiveItemPositive() {
    Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
    dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
    dmpl__Item__c Item8=TestDataHelpers.getItem('Item 8');

    Test.startTest();
    dmpl__DiscountGroup__c discountGroup = DiscountGroupDataHelper.createDiscountGroup(
        'Discount 1',
        partner,
        branch
    );
    discountGroup.dmpl__DiscountType__c = 'Purchase Price';
    update discountGroup;

    dmpl__DiscountGroup__c fetchedGroup = DiscountGroupDataHelper.getDiscountGroup('Discount 1');

    System.assertEquals('Discount 1', fetchedGroup.Name, 'Name should match');
    System.assertEquals(partner.Id, fetchedGroup.dmpl__PartnerAccountId__c, 'Partner should match');
    System.assertEquals(branch.Id, fetchedGroup.dmpl__BranchId__c, 'Branch should match');
    System.assertEquals('Purchase Price', fetchedGroup.dmpl__DiscountType__c, 'Discount Type should match');

    Date fromDate = Date.newInstance(2025, 5, 1);

    dmpl__DiscountGroupRule__c rule = DiscountGroupRuleTestDataHelper.createDiscountGroupRule(
        discountGroup,
        4,
        fromDate,
        null,
        Item8, null, null, null, null
    );
    Test.stopTest();

    List<dmpl__DiscountGroupRule__c> rules = DiscountGroupRuleTestDataHelper.getDiscountGroupRulesByGroupId(discountGroup.Id);

    dmpl__DiscountGroupRule__c fetchedRule = rules[0];

    System.assertEquals(discountGroup.Id, fetchedRule.dmpl__DiscountGroupId__c, 'Discount Group reference should match');
    System.assertEquals(4, fetchedRule.dmpl__DiscountPercent__c, 'Discount percent should be 4');
    System.assertEquals(fromDate, fetchedRule.dmpl__DateEffectiveFrom__c, 'Effective From date should match');
}
// Discount Group rule creation with active item (Edit)
@isTest
static void UpdateDiscountGroupRuleWithActiveItemPositive() {
    Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
    dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
    dmpl__Item__c Item8=TestDataHelpers.getItem('Item 8');
    dmpl__Item__c Item1=TestDataHelpers.getItem('Item 1');


    dmpl__DiscountGroup__c discountGroup = DiscountGroupDataHelper.createDiscountGroup('Discount 1', partner, branch);
    discountGroup.dmpl__DiscountType__c = 'Purchase Price';
    update discountGroup;

    System.assertEquals('Discount 1', discountGroup.Name);
    System.assertEquals('Purchase Price', discountGroup.dmpl__DiscountType__c);
    System.assertEquals(partner.Id, discountGroup.dmpl__PartnerAccountId__c);
    System.assertEquals(branch.Id, discountGroup.dmpl__BranchId__c);

    Date fromDate = Date.newInstance(2025, 5, 1);


    Test.startTest();
    dmpl__DiscountGroupRule__c rule = DiscountGroupRuleTestDataHelper.createDiscountGroupRule(
        discountGroup,
        4,
        fromDate,
        null,
        item1, null, null, null, null
    );

    List<dmpl__DiscountGroupRule__c> rulesBeforeUpdate = DiscountGroupRuleTestDataHelper.getDiscountGroupRulesByGroupId(discountGroup.Id);

    dmpl__DiscountGroupRule__c fetchedRule = rulesBeforeUpdate[0];
    System.assertEquals(discountGroup.Id, fetchedRule.dmpl__DiscountGroupId__c);
    System.assertEquals(4, fetchedRule.dmpl__DiscountPercent__c);
    System.assertEquals(fromDate, fetchedRule.dmpl__DateEffectiveFrom__c);

    fetchedRule.dmpl__ItemId__c = Item8.Id;

    update fetchedRule;
    Test.stopTest();

    List<dmpl__DiscountGroupRule__c> rulesAfterUpdate = DiscountGroupRuleTestDataHelper.getDiscountGroupRulesByGroupId(discountGroup.Id);
    dmpl__DiscountGroupRule__c updatedRule = rulesAfterUpdate[0];

    System.assertEquals(Item8.Id, fetchedRule.dmpl__ItemId__c = item8.Id);
    System.assertEquals(fromDate, updatedRule.dmpl__DateEffectiveFrom__c);
    System.assertEquals(discountGroup.Id, updatedRule.dmpl__DiscountGroupId__c);
}

// Discount Group rule creation with in-active item (New)
@isTest
static void createDiscountGroupRuleWithInactiveItemNegative() {

    Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
    dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
    dmpl__Item__c item2 = TestDataHelpers.getItem('Item 2'); // Inactive item


    dmpl__DiscountGroup__c discountGroup = DiscountGroupDataHelper.createDiscountGroup('Discount 1', partner, branch);
    discountGroup.dmpl__DiscountType__c = 'Purchase Price';
    update discountGroup;


    System.assertEquals('Discount 1', discountGroup.Name);
    System.assertEquals('Purchase Price', discountGroup.dmpl__DiscountType__c);
    System.assertEquals(partner.Id, discountGroup.dmpl__PartnerAccountId__c);
    System.assertEquals(branch.Id, discountGroup.dmpl__BranchId__c);

    Date fromDate = Date.newInstance(2025, 5, 1);


    Boolean exceptionThrown = false;

    Test.startTest();
    try {
        dmpl__DiscountGroupRule__c rule = DiscountGroupRuleTestDataHelper.createDiscountGroupRule(
            discountGroup,
            4,
            fromDate,
            null,
            item2, 
            null,
            null,
            null,
            null
        );
        insert rule; 
    } catch (Exception e) {
        exceptionThrown = true;
        System.debug('Expected exception caught: ' + e.getMessage());
    }
    Test.stopTest();

    System.assertEquals(true, exceptionThrown, 'Expected exception when creating rule with inactive item.');
}

@isTest
static void UpdateDiscountGroupRuleWithInactiveItemPositive() {
    Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
    dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
    dmpl__Item__c item8 = TestDataHelpers.getItem('Item 8');
    dmpl__Item__c item2 = TestDataHelpers.getItem('Item 2');

    dmpl__DiscountGroup__c discountGroup = DiscountGroupDataHelper.createDiscountGroup('Discount 1', partner, branch);
    discountGroup.dmpl__DiscountType__c = 'Purchase Price';
    update discountGroup;

    dmpl__DiscountGroup__c fetchedGroup = DiscountGroupDataHelper.getDiscountGroup('Discount 1');
    System.assertEquals(partner.Id, fetchedGroup.dmpl__PartnerAccountId__c);
    System.assertEquals('Purchase Price', discountGroup.dmpl__DiscountType__c);
    System.assertEquals(branch.Id, fetchedGroup.dmpl__BranchId__c);
    System.assertEquals('Discount 1', fetchedGroup.Name);

    Test.startTest();
    dmpl__DiscountGroupRule__c rule = DiscountGroupRuleTestDataHelper.createDiscountGroupRule(
        discountGroup,
        4,
        Date.newInstance(2025, 5, 1),
        null,
        item8,
        null,
        null,
        null,
        null
    );

    System.assertEquals(discountGroup.Id, rule.dmpl__DiscountGroupId__c);
    System.assertEquals(4, rule.dmpl__DiscountPercent__c);
    System.assertEquals(Date.newInstance(2025, 5, 1), rule.dmpl__DateEffectiveFrom__c);
    System.assertEquals(item8.Id, rule.dmpl__ItemId__c);

    rule.dmpl__ItemId__c = item2.Id;
    update rule;
    Test.stopTest();

    dmpl__DiscountGroupRule__c updatedRule = DiscountGroupRuleTestDataHelper.getDiscountGroupRulesByGroupId(discountGroup.Id)[0];
    System.assertEquals(item2.Id, updatedRule.dmpl__ItemId__c);
}

@isTest
static void CreateDiscountGroupRuleWithRequiredSKUPositive() {
    Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
    dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
    dmpl__Item__c item7 = TestDataHelpers.getItem('Item 7');
    dmpl__SKU__c sku1 = TestDataHelpers.getSKU('SKU 1');

    dmpl__DiscountGroup__c discountGroup = DiscountGroupDataHelper.createDiscountGroup('Discount 1', partner, branch);
    discountGroup.dmpl__DiscountType__c = 'Purchase Price';
    update discountGroup;

    System.assertEquals('Discount 1', discountGroup.Name);
    System.assertEquals('Purchase Price', discountGroup.dmpl__DiscountType__c);
    System.assertEquals(partner.Id, discountGroup.dmpl__PartnerAccountId__c);
    System.assertEquals(branch.Id, discountGroup.dmpl__BranchId__c);

    Date fromDate = Date.newInstance(2025, 5, 1);

    Test.startTest();
    dmpl__DiscountGroupRule__c rule = DiscountGroupRuleTestDataHelper.createDiscountGroupRule(
        discountGroup,
        4,
        fromDate,
        null,
        item7,
        sku1,
        null,
        null,
        null
    );
    Test.stopTest();

    List<dmpl__DiscountGroupRule__c> rules = DiscountGroupRuleTestDataHelper.getDiscountGroupRulesByGroupId(discountGroup.Id);
    dmpl__DiscountGroupRule__c createdRule = rules[0];

    System.assertEquals(discountGroup.Id, createdRule.dmpl__DiscountGroupId__c);
    System.assertEquals(4, createdRule.dmpl__DiscountPercent__c);
    System.assertEquals(fromDate, createdRule.dmpl__DateEffectiveFrom__c);
    System.assertEquals(item7.Id, createdRule.dmpl__ItemId__c);
    System.assertEquals(sku1.Id, createdRule.dmpl__SKUId__c);
}
// Discount Group rule creation with no-required SKU (New)
@isTest
static void CreateDiscountGroupRuleWithNoRequiredSKUPositive() {
    Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
    dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
    dmpl__Item__c Item8=TestDataHelpers.getItem('Item 8');

    Test.startTest();
    dmpl__DiscountGroup__c discountGroup = DiscountGroupDataHelper.createDiscountGroup(
        'Discount 1',
        partner,
        branch
    );
    discountGroup.dmpl__DiscountType__c = 'Purchase Price';
    update discountGroup;

    dmpl__DiscountGroup__c fetchedGroup = DiscountGroupDataHelper.getDiscountGroup('Discount 1');

    System.assertEquals('Discount 1', fetchedGroup.Name, 'Name should match');
    System.assertEquals(partner.Id, fetchedGroup.dmpl__PartnerAccountId__c, 'Partner should match');
    System.assertEquals(branch.Id, fetchedGroup.dmpl__BranchId__c, 'Branch should match');
    System.assertEquals('Purchase Price', fetchedGroup.dmpl__DiscountType__c, 'Discount Type should match');

    Date fromDate = Date.newInstance(2025, 5, 1);

    dmpl__DiscountGroupRule__c rule = DiscountGroupRuleTestDataHelper.createDiscountGroupRule(
        discountGroup,
        4,
        fromDate,
        null,
        Item8, null, null, null, null
    );
    Test.stopTest();

    List<dmpl__DiscountGroupRule__c> rules = DiscountGroupRuleTestDataHelper.getDiscountGroupRulesByGroupId(discountGroup.Id);

    dmpl__DiscountGroupRule__c fetchedRule = rules[0];

    System.assertEquals(discountGroup.Id, fetchedRule.dmpl__DiscountGroupId__c, 'Discount Group reference should match');
    System.assertEquals(4, fetchedRule.dmpl__DiscountPercent__c, 'Discount percent should be 4');
    System.assertEquals(fromDate, fetchedRule.dmpl__DateEffectiveFrom__c, 'Effective From date should match');
}
// Discount Group rule creation with no-required SKU (Edit)
@isTest
static void updateDiscountGroupRuleWithNoRequiredSKUPositive() {
    Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
    dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
    dmpl__Item__c item7 = TestDataHelpers.getItem('Item 7');
    dmpl__Item__c item8 = TestDataHelpers.getItem('Item 8');
    dmpl__SKU__c sku1 = TestDataHelpers.getSKU('SKU 1');

    dmpl__DiscountGroup__c discountGroup = DiscountGroupDataHelper.createDiscountGroup('Discount 1', partner, branch);
    discountGroup.dmpl__DiscountType__c = 'Purchase Price';
    update discountGroup;

    System.assertEquals('Discount 1', discountGroup.Name);
    System.assertEquals('Purchase Price', discountGroup.dmpl__DiscountType__c);
    System.assertEquals(partner.Id, discountGroup.dmpl__PartnerAccountId__c);
    System.assertEquals(branch.Id, discountGroup.dmpl__BranchId__c);

    Date fromDate = Date.newInstance(2025, 5, 1);

    Test.startTest();
    dmpl__DiscountGroupRule__c rule = DiscountGroupRuleTestDataHelper.createDiscountGroupRule(
        discountGroup,
        4,
        fromDate,
        null,
        item7,
        sku1,
        null,
        null,
        null
    );


    List<dmpl__DiscountGroupRule__c> rules = DiscountGroupRuleTestDataHelper.getDiscountGroupRulesByGroupId(discountGroup.Id);
    dmpl__DiscountGroupRule__c existingRule = rules[0];

    System.assertEquals(discountGroup.Id, existingRule.dmpl__DiscountGroupId__c);
    System.assertEquals(4, existingRule.dmpl__DiscountPercent__c);
    System.assertEquals(fromDate, existingRule.dmpl__DateEffectiveFrom__c);
    System.assertEquals(item7.Id, existingRule.dmpl__ItemId__c);
    System.assertEquals(sku1.Id, existingRule.dmpl__SKUId__c);

    existingRule.dmpl__ItemId__c = item8.Id;
    existingRule.dmpl__SKUId__c = null;

    update existingRule;
    Test.stopTest();

    List<dmpl__DiscountGroupRule__c> updatedRules = DiscountGroupRuleTestDataHelper.getDiscountGroupRulesByGroupId(discountGroup.Id);
    dmpl__DiscountGroupRule__c updatedRule = updatedRules[0];

    System.assertEquals(discountGroup.Id, updatedRule.dmpl__DiscountGroupId__c);
    System.assertEquals(4, updatedRule.dmpl__DiscountPercent__c);
    System.assertEquals(fromDate, updatedRule.dmpl__DateEffectiveFrom__c);
    System.assertEquals(item8.Id, updatedRule.dmpl__ItemId__c);
    System.assertEquals(null, updatedRule.dmpl__SKUId__c);
}
@isTest
static void updateDiscountGroupRuleWithRequiredSKUPositive() {
    Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
    dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
    dmpl__Item__c item7 = TestDataHelpers.getItem('Item 7');
    dmpl__Item__c item8 = TestDataHelpers.getItem('Item 8');
    dmpl__SKU__c sku1 = TestDataHelpers.getSKU('SKU 1');

    dmpl__DiscountGroup__c discountGroup = DiscountGroupDataHelper.createDiscountGroup('Discount 1', partner, branch);
    discountGroup.dmpl__DiscountType__c = 'Purchase Price';
    update discountGroup;

    System.assertEquals('Discount 1', discountGroup.Name);
    System.assertEquals('Purchase Price', discountGroup.dmpl__DiscountType__c);
    System.assertEquals(partner.Id, discountGroup.dmpl__PartnerAccountId__c);
    System.assertEquals(branch.Id, discountGroup.dmpl__BranchId__c);

    Date fromDate = Date.newInstance(2025, 5, 1);

    Test.startTest();
    dmpl__DiscountGroupRule__c rule = DiscountGroupRuleTestDataHelper.createDiscountGroupRule(
        discountGroup,
        4,
        fromDate,
        null,
        item8,
        null,
        null,
        null,
        null
    );

    List<dmpl__DiscountGroupRule__c> rules = DiscountGroupRuleTestDataHelper.getDiscountGroupRulesByGroupId(discountGroup.Id);
    dmpl__DiscountGroupRule__c existingRule = rules[0];

    System.assertEquals(discountGroup.Id, existingRule.dmpl__DiscountGroupId__c);
    System.assertEquals(4, existingRule.dmpl__DiscountPercent__c);
    System.assertEquals(fromDate, existingRule.dmpl__DateEffectiveFrom__c);
    System.assertEquals(item8.Id, existingRule.dmpl__ItemId__c);
    System.assertEquals(null, existingRule.dmpl__SKUId__c);

    existingRule.dmpl__ItemId__c = item7.Id;
    existingRule.dmpl__SKUId__c = sku1.Id;

    update existingRule;
    Test.stopTest();

    List<dmpl__DiscountGroupRule__c> updatedRules = DiscountGroupRuleTestDataHelper.getDiscountGroupRulesByGroupId(discountGroup.Id);
    dmpl__DiscountGroupRule__c updatedRule = updatedRules[0];

    System.assertEquals(item7.Id, updatedRule.dmpl__ItemId__c);
    System.assertEquals(sku1.Id, updatedRule.dmpl__SKUId__c);
    System.assertEquals(fromDate, updatedRule.dmpl__DateEffectiveFrom__c);
    System.assertEquals(discountGroup.Id, updatedRule.dmpl__DiscountGroupId__c);
}

@isTest
static void createDiscountGrouprulewithItemGroup() {
    Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
    dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');

    Test.startTest();
    dmpl__DiscountGroup__c discountGroup = DiscountGroupDataHelper.createDiscountGroup(
        'Discount 1',
        partner,
        branch
    );
    discountGroup.dmpl__DiscountType__c = 'Purchase Price';
    update discountGroup;

    dmpl__DiscountGroup__c fetchedGroup = DiscountGroupDataHelper.getDiscountGroup('Discount 1');

    System.assertEquals('Discount 1', fetchedGroup.Name, 'Name should match');
    System.assertEquals(partner.Id, fetchedGroup.dmpl__PartnerAccountId__c, 'Partner should match');
    System.assertEquals(branch.Id, fetchedGroup.dmpl__BranchId__c, 'Branch should match');
    System.assertEquals('Purchase Price', fetchedGroup.dmpl__DiscountType__c, 'Discount Type should match');

    Date fromDate = Date.newInstance(2025, 5, 1);

    dmpl__DiscountGroupRule__c rule = DiscountGroupRuleTestDataHelper.createDiscountGroupRule(
        discountGroup,
        4,
        fromDate,
        null,
        null, null, null, null, null
    );
    Test.stopTest();

    List<dmpl__DiscountGroupRule__c> rules = DiscountGroupRuleTestDataHelper.getDiscountGroupRulesByGroupId(discountGroup.Id);

    dmpl__DiscountGroupRule__c fetchedRule = rules[0];

    System.assertEquals(discountGroup.Id, fetchedRule.dmpl__DiscountGroupId__c, 'Discount Group reference should match');
    System.assertEquals(4, fetchedRule.dmpl__DiscountPercent__c, 'Discount percent should be 4');
    System.assertEquals(fromDate, fetchedRule.dmpl__DateEffectiveFrom__c, 'Effective From date should match');
    
}
// Discount Group rule creation without Item Group (New)
@isTest
static void CreateDiscountGroupRuleWithoutItemGroupPositive() {
    Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
    dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
    dmpl__Item__c Item8=TestDataHelpers.getItem('Item 8');

    Test.startTest();
    dmpl__DiscountGroup__c discountGroup = DiscountGroupDataHelper.createDiscountGroup(
        'Discount 1',
        partner,
        branch
    );
    discountGroup.dmpl__DiscountType__c = 'Purchase Price';
    update discountGroup;

    dmpl__DiscountGroup__c fetchedGroup = DiscountGroupDataHelper.getDiscountGroup('Discount 1');

    System.assertEquals('Discount 1', fetchedGroup.Name, 'Name should match');
    System.assertEquals(partner.Id, fetchedGroup.dmpl__PartnerAccountId__c, 'Partner should match');
    System.assertEquals(branch.Id, fetchedGroup.dmpl__BranchId__c, 'Branch should match');
    System.assertEquals('Purchase Price', fetchedGroup.dmpl__DiscountType__c, 'Discount Type should match');

    Date fromDate = Date.newInstance(2025, 5, 1);

    dmpl__DiscountGroupRule__c rule = DiscountGroupRuleTestDataHelper.createDiscountGroupRule(
        discountGroup,
        4,
        fromDate,
        null,
        null, null, null, null, null
    );
    Test.stopTest();

    List<dmpl__DiscountGroupRule__c> rules = DiscountGroupRuleTestDataHelper.getDiscountGroupRulesByGroupId(discountGroup.Id);

    dmpl__DiscountGroupRule__c fetchedRule = rules[0];

    System.assertEquals(discountGroup.Id, fetchedRule.dmpl__DiscountGroupId__c, 'Discount Group reference should match');
    System.assertEquals(4, fetchedRule.dmpl__DiscountPercent__c, 'Discount percent should be 4');
    System.assertEquals(fromDate, fetchedRule.dmpl__DateEffectiveFrom__c, 'Effective From date should match');
}
@isTest
static void createDiscountGroupRuleWithItemGroupPositive() {
    Account partner = TestDataHelpers.getPartnerAccount('Partner 4');
    dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 4');
    dmpl__ItemGroup__c itemGroup2 = TestDataHelpers.getItemGroup('Item Group 2');

    dmpl__DiscountGroup__c discountGroup = DiscountGroupDataHelper.createDiscountGroup('Discount 1', partner, branch);
    discountGroup.dmpl__DiscountType__c = 'Purchase Price';
    update discountGroup;

    System.assertEquals('Discount 1', discountGroup.Name);
    System.assertEquals('Purchase Price', discountGroup.dmpl__DiscountType__c);
    System.assertEquals(partner.Id, discountGroup.dmpl__PartnerAccountId__c);
    System.assertEquals(branch.Id, discountGroup.dmpl__BranchId__c);

    Date fromDate = Date.newInstance(2025, 5, 1);

    Test.startTest();
    dmpl__DiscountGroupRule__c rule = DiscountGroupRuleTestDataHelper.createDiscountGroupRule(
        discountGroup,
        4,
        fromDate,
        null,
        null,
        null,
        itemGroup2,
        null,
        null
    );
    Test.stopTest();

    List<dmpl__DiscountGroupRule__c> rules = DiscountGroupRuleTestDataHelper.getDiscountGroupRulesByGroupId(discountGroup.Id);
    dmpl__DiscountGroupRule__c createdRule = rules[0];

    System.assertEquals(discountGroup.Id, createdRule.dmpl__DiscountGroupId__c);
    System.assertEquals(4, createdRule.dmpl__DiscountPercent__c);
    System.assertEquals(fromDate, createdRule.dmpl__DateEffectiveFrom__c);
    System.assertEquals(itemGroup2.Id, createdRule.dmpl__ItemGroupId__c);
}
}