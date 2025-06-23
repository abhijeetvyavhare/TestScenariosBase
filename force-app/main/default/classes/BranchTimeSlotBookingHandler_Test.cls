@isTest
public with sharing class BranchTimeSlotBookingHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Account partnerAccount = TestDataHelpers.createPartnerAccount();
        dmpl__Item__c item =TestDataHelpers.createItem();
        dmpl__ItemGroup__c itemGroup =BranchTestDataHelper.createItemGroup();
        dmpl__Branch__c branch = TestDataHelpers.createBranch(partnerAccount);
        dmpl__BranchTimeSlot__c branchTimeSlot = BranchTestDataHelper.createBranchTimeSlot(item,branch);
        dmpl__BranchTimeSlotBooking__c branchTimeSlotBooking = BranchTestDataHelper.createBranchTimeSlotBooking(branchTimeSlot);
    }

    @isTest
    static void createBranchTimeSlotBookingPositive() {
        dmpl__BranchTimeSlotBooking__c branchTimeSlotBooking = BranchTestDataHelper.getBranchTimeSlotBooking();
        if(branchTimeSlotBooking != null){
            System.assertNotEquals(branchTimeSlotBooking, null, 'Expected branchTimeSlotBooking to be created.');
        }
        System.assertEquals(Date.today(), branchTimeSlotBooking.dmpl__BookingDate__c, 'date not matched');
        System.assertEquals(5, branchTimeSlotBooking.dmpl__CapacityUtilized__c, 'CapacityUtilized must be 5');
        System.assertEquals(10, branchTimeSlotBooking.dmpl__Capacity__c, 'Capacity must be 10');
        System.assertNotEquals(branchTimeSlotBooking.dmpl__BranchTimeSlotId__c, null, 'Expected dmpl__BranchTimeSlotId__c to be set');
        System.assertNotEquals(branchTimeSlotBooking.Name,null,'Name cannot be null');
    }

    @isTest
    static void updateBranchTimeSlotBookingPositive() {
        dmpl__BranchTimeSlotBooking__c branchTimeSlotBooking = BranchTestDataHelper.getBranchTimeSlotBooking();
        System.assertNotEquals(branchTimeSlotBooking, null, 'BranchTimeSlotBooking should exist before update.');
        branchTimeSlotBooking.dmpl__BookingDate__c = Date.today().addDays(1);
        branchTimeSlotBooking.dmpl__CapacityUtilized__c = 15;
        branchTimeSlotBooking.dmpl__Capacity__c = 20;
        update branchTimeSlotBooking;
        dmpl__BranchTimeSlotBooking__c updatedBooking = BranchTestDataHelper.getBranchTimeSlotBooking(branchTimeSlotBooking.Id);
        System.assertEquals(Date.today().addDays(1), updatedBooking.dmpl__BookingDate__c, 'Expected BookingDate to be updated to tomorrow.');
        System.assertEquals(15, updatedBooking.dmpl__CapacityUtilized__c, 'Expected dmpl__CapacityUtilized__c must be 15');
        System.assertEquals(20, updatedBooking.dmpl__Capacity__c, 'Expected dmpl__Capacity__c must be 20');
    }

    @isTest
    static void deleteBranchTimeSlotBookingPositive() {
        dmpl__BranchTimeSlotBooking__c branchTimeSlotBooking = BranchTestDataHelper.getBranchTimeSlotBooking();
        System.assertNotEquals(branchTimeSlotBooking, null, 'BranchTimeSlotBooking should exist before delete.');
        delete branchTimeSlotBooking;
        dmpl__BranchTimeSlotBooking__c deletedBooking = null;
        try {
            deletedBooking = BranchTestDataHelper.getBranchTimeSlotBooking(branchTimeSlotBooking.Id);
        } catch (Exception e) {
            deletedBooking = null;
        }

        System.assertEquals(null, deletedBooking, 'BranchTimeSlotBooking should be deleted and not found in query.');
    }





    
}