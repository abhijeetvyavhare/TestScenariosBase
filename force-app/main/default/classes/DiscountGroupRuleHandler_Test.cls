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

        DiscountGroupRuleTestDataHelper.createDiscountGroupRule(
            discountGroup,
            item,
            null,
            itemLotType,
            sku,
            priceList
        );
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
        System.assertEquals(0, ruleAfterDelete.size(), 'Discount Group Rule should be deleted and not found');
    }
}