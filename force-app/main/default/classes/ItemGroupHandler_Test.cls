@isTest
public with sharing class ItemGroupHandler_Test {
    @isTest
    static void createRequiredData() {
        Account partnerAccount = TestDataHelpers.createPartnerAccount();
        Account customerAccount = TestDataHelpers.createCustomerAccount();
        dmpl__Branch__c branch = TestDataHelpers.createBranch(partnerAccount);
        dmpl__Item__c item = ItemDataHelper.createItem('Test Item', 'TEST123');
        dmpl__SKU__c sku = TestDataHelpers.createSKU(item);
        dmpl__ItemGroup__c itemGroup = ItemGroupDataHelper.createItemGroup('Test Item Group');  
    }

    @isTest
    static void createItemGroupPositive() {
        Test.startTest();
        dmpl__ItemGroup__c itemGroup = ItemGroupDataHelper.createItemGroup('Test Item Group');
        Test.stopTest();

        System.assertNotEquals(null, itemGroup, 'Item Group should be created');
        System.assertEquals('Test Item Group', itemGroup.Name, 'Name should be Test Item Group');
        System.assertEquals('Test Description', itemGroup.dmpl__Description__c, 'Description should match');
    }

    @isTest
    static void updateItemGroupDescriptionPositive() {
        dmpl__ItemGroup__c itemGroup = ItemGroupDataHelper.createItemGroup('Test Item Group');
        
        Test.startTest();
        itemGroup.dmpl__Description__c = 'Updated Test Description';
        update itemGroup;
        Test.stopTest();

        dmpl__ItemGroup__c updatedItemGroup = ItemGroupDataHelper.getItemGroup('Test Item Group');
        System.assertEquals('Updated Test Description', updatedItemGroup.dmpl__Description__c, 'Description should be updated');
    }

    @isTest
    static void deleteItemGroupPositive() {
        dmpl__ItemGroup__c itemGroup = ItemGroupDataHelper.createItemGroup('Test Item Group');
        
        System.assertNotEquals(null, itemGroup, 'Item Group should be created before delete');
        System.assertNotEquals(null, itemGroup.Id, 'Item Group ID should not be null');
        
        Test.startTest();
        delete itemGroup;
        
        dmpl__ItemGroup__c deletedItemGroup = null;
        try {
            deletedItemGroup = ItemGroupDataHelper.getItemGroup('Test Item Group');
        } catch (Exception e) {
            deletedItemGroup = null;
        }
        Test.stopTest();
        
        System.assertEquals(null, deletedItemGroup, 'Item Group should be deleted and not found in query');
    }
    
    @isTest
    static void createItemGroupRulePositive() {
        dmpl__ItemGroup__c itemGroup = ItemGroupDataHelper.createItemGroup('Test Item Group');
        
        Test.startTest();
        dmpl__ItemGroupRule__c itemGroupRule = ItemGroupDataHelper.createItemGroupRule(itemGroup, 1);
        Test.stopTest();

        System.assertNotEquals(null, itemGroupRule, 'Item Group Rule should be created');
        System.assertEquals(itemGroup.Id, itemGroupRule.dmpl__ItemGroupId__c, 'Item Group ID should match');
        System.assertEquals(1, itemGroupRule.dmpl__SequenceNumber__c, 'Sequence number should be 1');
        System.assertEquals('Test Field Name', itemGroupRule.dmpl__FieldName__c, 'Field name should match');
        System.assertEquals('Test Field Value', itemGroupRule.dmpl__FieldValue__c, 'Field value should match');
    }

    @isTest
    static void updateItemGroupRulePositive() {
        dmpl__ItemGroup__c itemGroup = ItemGroupDataHelper.createItemGroup('Test Item Group');
        dmpl__ItemGroupRule__c itemGroupRule = ItemGroupDataHelper.createItemGroupRule(itemGroup, 1);
        
        Test.startTest();
        dmpl__ItemGroupRule__c updatedRule = ItemGroupDataHelper.updateItemGroupRule(itemGroup, 2);
        Test.stopTest();

        System.assertEquals('Updated Field Name', updatedRule.dmpl__FieldName__c, 'Field name should be updated');
        System.assertEquals('Updated Field Value', updatedRule.dmpl__FieldValue__c, 'Field value should be updated');
        System.assertEquals(2, updatedRule.dmpl__SequenceNumber__c, 'Sequence number should be updated to 2');
    }

    @isTest
    static void deleteItemGroupRulePositive() {
        dmpl__ItemGroup__c itemGroup = ItemGroupDataHelper.createItemGroup('Test Item Group');
        dmpl__ItemGroupRule__c itemGroupRule = ItemGroupDataHelper.createItemGroupRule(itemGroup, 1);
        
        System.assertNotEquals(null, itemGroupRule, 'Item Group Rule should be created before delete');
        System.assertNotEquals(null, itemGroupRule.Id, 'Item Group Rule ID should not be null');
        
        Test.startTest();
        delete itemGroupRule;
        
        dmpl__ItemGroupRule__c deletedRule = null;
        try {
            deletedRule = ItemGroupDataHelper.getItemGroupRule(itemGroup.Id);
        } catch (Exception e) {
            deletedRule = null;
        }
        Test.stopTest();
        
        System.assertEquals(null, deletedRule, 'Item Group Rule should be deleted and not found in query');
    }
    
    @isTest
    static void createItemGroupMemberPositive() {
        
        dmpl__Item__c item = ItemDataHelper.createItem('Test Item', 'TEST123');
        dmpl__ItemGroup__c itemGroup = ItemGroupDataHelper.createItemGroup('Test Item Group');
        
        Test.startTest();
        dmpl__ItemGroupMember__c itemGroupMember = ItemGroupDataHelper.createItemGroupMember(itemGroup);
        Test.stopTest();

        System.assertNotEquals(null, itemGroupMember, 'Item Group Member should be created');
        System.assertEquals(itemGroup.Id, itemGroupMember.dmpl__ItemGroupId__c, 'Item Group ID should match');
        System.assertEquals(item.Id, itemGroupMember.dmpl__ItemId__c, 'Item ID should match');
    }

    @isTest
    static void deleteItemGroupMemberPositive() {
        
        dmpl__Item__c item = ItemDataHelper.createItem('Test Item', 'TEST123');
        dmpl__ItemGroup__c itemGroup = ItemGroupDataHelper.createItemGroup('Test Item Group');
        dmpl__ItemGroupMember__c itemGroupMember = ItemGroupDataHelper.createItemGroupMember(itemGroup);
        
        System.assertNotEquals(null, itemGroupMember, 'Item Group Member should be created before delete');
        System.assertNotEquals(null, itemGroupMember.Id, 'Item Group Member ID should not be null');
        
        Test.startTest();
        delete itemGroupMember;
        
        dmpl__ItemGroupMember__c deletedMember = null;
        try {
            deletedMember = ItemGroupDataHelper.getItemGroupMember(itemGroup.Id);
        } catch (Exception e) {
            deletedMember = null;
        }
        Test.stopTest();
        
        System.assertEquals(null, deletedMember, 'Item Group Member should be deleted and not found in query');
    }
}