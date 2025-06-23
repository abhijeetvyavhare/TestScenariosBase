@isTest
public with sharing class CycleCountHandler_Test {

    @TestSetup
    static void makeData() {
        Account partnerAccount = TestDataHelpers.createPartnerAccount();
        TestDataHelpers.createBranch(partnerAccount);
        
    }
    
    @isTest
    static void createCycleCountTestPositive() {
        dmpl__InventoryCycleCount__c cycleCount = (dmpl__InventoryCycleCount__c) TestFactory.createSObject(
            new dmpl__InventoryCycleCount__c(
                dmpl__MaximumItems__c = 2,
                dmpl__PartnerAccountId__c = TestDataHelpers.getPartnerAccount().Id,
                dmpl__BranchId__c = TestDataHelpers.getBranch().Id),
            'InventoryCycleCountDefaults'
        );

        Test.startTest();
        insert cycleCount;
        Test.stopTest();

        dmpl__InventoryCycleCount__c checkCycleCount = [SELECT Id, Name FROM dmpl__InventoryCycleCount__c LIMIT 1];
        System.assertNotEquals(
            String.valueOf(checkCycleCount.Name),
            null,
            'Expected to see that the Cycle Count Created Wiht Custom Name.'
        );
    }
}