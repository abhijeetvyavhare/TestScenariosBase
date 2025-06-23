@isTest
public with sharing class BranchDateSlotResultHandler_Test {
    @TestSetup
    static void createRequiredData() {
        dmpl__BranchDateSlotResult__c branchDateSlotResult = BranchTestDataHelper.createBranchDateSlotResult();
    }

    @isTest
    static void createBranchDateSlotResultPositive() {
        dmpl__BranchDateSlotResult__c branchDateSlotResult = BranchTestDataHelper.getBranchDateSlotResult();
        if(branchDateSlotResult != null){
            System.assertNotEquals(branchDateSlotResult, null, 'Expected BranchDateSlotResult to be created.');
        }
        System.assertEquals(Date.today(), branchDateSlotResult.dmpl__BookingDate__c, 'date not matched');
        System.assertEquals(6, branchDateSlotResult.dmpl__CapacityUtilized__c, 'CapacityUtilized must be 6');
        System.assertEquals(12, branchDateSlotResult.dmpl__Capacity__c, 'Capacity must be 12');
        System.assertEquals('Demo1', branchDateSlotResult.Name, 'Name should be Demo1');
    }
    
    @isTest
    static void updateBranchDateSlotResultPositive() {
        dmpl__BranchDateSlotResult__c branchDateSlotResult = BranchTestDataHelper.getBranchDateSlotResult();
        System.assertNotEquals(branchDateSlotResult, null, 'BranchDateSlotResult should exist before update.');
        branchDateSlotResult.dmpl__Capacity__c = 20;
        branchDateSlotResult.dmpl__CapacityUtilized__c = 10;
        update branchDateSlotResult;
        dmpl__BranchDateSlotResult__c updatedResult = BranchTestDataHelper.getBranchDateSlotResult(branchDateSlotResult.Id);
        System.assertEquals(20, updatedResult.dmpl__Capacity__c, 'Expected Capacity to be updated to 20');
        System.assertEquals(10, updatedResult.dmpl__CapacityUtilized__c, 'Expected CapacityUtilized to be updated to 10');
    }

    @isTest
    static void deleteBranchDateSlotResultPositive() {
        dmpl__BranchDateSlotResult__c branchDateSlotResult = BranchTestDataHelper.getBranchDateSlotResult();
        System.assertNotEquals(branchDateSlotResult, null, 'BranchDateSlotResult should exist before delete.');
        delete branchDateSlotResult;
        dmpl__BranchDateSlotResult__c deletedResult = null;
        try {
            deletedResult = BranchTestDataHelper.getBranchDateSlotResult(branchDateSlotResult.Id);
        } catch (Exception e) {
            deletedResult = null;
        }
        System.assertEquals(null, deletedResult, 'BranchDateSlotResult should be deleted and not found in query.');
    }

}