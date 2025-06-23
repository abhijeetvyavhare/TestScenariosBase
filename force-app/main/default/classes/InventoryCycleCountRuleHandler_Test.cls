@isTest
public with sharing class InventoryCycleCountRuleHandler_Test {
   
    @TestSetup
    static void createRequiredData() {
       dmpl__AccountGroup__c accountGroup=TestDataHelpers.createAccountGroup();
        Account partnerAccount=TestDataHelpers.createPartnerAccount();
        dmpl__Branch__c branch=TestDataHelpers.createBranch(partnerAccount);
        dmpl__Item__c item=TestDataHelpers.createItem();
        dmpl__InventoryCycleCount__c cycleCount=CycleCountTestDataHelpers.createCycleCount(branch,item);
        dmpl__InventoryCycleCountRule__c cycleCountRule = CycleCountTestDataHelpers.createCycleCountRule(cycleCount);
    }

    @isTest
    static void createInventoryCycleCountRulePositive() {
        dmpl__InventoryCycleCountRule__c cycleCountRule = CycleCountTestDataHelpers.getCycleCountRule();
        if (cycleCountRule != null) {
            System.assertNotEquals(cycleCountRule, null, 'Expected cycleCountRule to be created.');
        }
        System.assertNotEquals(cycleCountRule.name, null, 'Name should not be null');
        System.assertNotEquals(cycleCountRule.dmpl__CycleCountId__c, null, 'Expected dmpl__CycleCountId__c to be set.');
        System.assertEquals('dmpl__ItemId__c', cycleCountRule.dmpl__FieldName__c, 'Expected dmpl__FieldName__c to be dmpl__ItemId__c');
        System.assertEquals('TestValue', cycleCountRule.dmpl__FieldValue__c, 'Expected dmpl__FieldValue__c to be TestValue');
        System.assertEquals('equals', cycleCountRule.dmpl__Operation__c, 'Expected dmpl__Operation__c to be equals');
    }

    @isTest
    static void updateInventoryCycleCountRulePositive() {
        dmpl__InventoryCycleCountRule__c cycleCountRule = CycleCountTestDataHelpers.getCycleCountRule();
        if (cycleCountRule != null) {
            System.assertNotEquals(cycleCountRule, null, 'Expected cycleCountRule to be created before update.');
            cycleCountRule.dmpl__FieldName__c = 'dmpl__ItemLotId__c';
            cycleCountRule.dmpl__FieldValue__c = 'UpdatedValue';
            cycleCountRule.dmpl__Operation__c = 'notEqual';
            update cycleCountRule;
        }
        dmpl__InventoryCycleCountRule__c updatedCycleCountRule = CycleCountTestDataHelpers.getCycleCountRule(cycleCountRule.Id);
        if (updatedCycleCountRule != null) {
            System.assertNotEquals(updatedCycleCountRule, null, 'Expected cycleCountRule to be updated.');
        }
        System.assertEquals('dmpl__ItemLotId__c', updatedCycleCountRule.dmpl__FieldName__c, 'Expected dmpl__FieldName__c to be dmpl__ItemLotId__c');
        System.assertEquals('UpdatedValue', updatedCycleCountRule.dmpl__FieldValue__c, 'Expected dmpl__FieldValue__c to be UpdatedValue');
        System.assertEquals('notEqual', updatedCycleCountRule.dmpl__Operation__c, 'Expected dmpl__Operation__c to be notEqual');
    }

    @isTest
    static void deleteInventoryCycleCountRulePositive() {
        dmpl__InventoryCycleCountRule__c cycleCountRule = CycleCountTestDataHelpers.getCycleCountRule();
        System.assertNotEquals(cycleCountRule, null, 'Expected cycleCountRule to be created before delete.');
        dmpl__InventoryCycleCountRule__c deletedCycleCountRule = null;
        delete cycleCountRule;
        try {
            deletedCycleCountRule = CycleCountTestDataHelpers.getCycleCountRule(cycleCountRule.Id);
        } catch (Exception e) {
           	deletedCycleCountRule=null;
        }
        System.assertEquals(null, deletedCycleCountRule, 'Expected cycleCountRule to be deleted.');
    }
}