@isTest
public with sharing class LeaveEntitlementHandler_Test {

    @TestSetup
    static void createRequiredData() {
        dmpl__LeaveType__c leaveType = new dmpl__LeaveType__c(Name = 'Sick Leave');
        insert leaveType;

        dmpl__Resource__c resource = new dmpl__Resource__c(Name = 'Test Resource');
        insert resource;

        dmpl__ResourceGroup__c resourceGroup = new dmpl__ResourceGroup__c(Name = 'Test Group');
        insert resourceGroup;

        LeaveEntitlementDataHelper.createLeaveEntitlement(leaveType, resource, resourceGroup);
    }

    @isTest
    static void testInsertLeaveEntitlement() {
        dmpl__LeaveEntitlement__c entitlement = LeaveEntitlementDataHelper.getLeaveEntitlement();
        System.assert(entitlement != null, 'Leave Entitlement should be retrieved');
        System.assert(entitlement.Id != null, 'Leave Entitlement should be inserted');
        System.assertEquals(12, entitlement.dmpl__FixedCount__c, 'Default Fixed Count should be 12');
    }

    @isTest
    static void testUpdateLeaveEntitlement() {
        dmpl__LeaveEntitlement__c entitlement = LeaveEntitlementDataHelper.getLeaveEntitlement();

        entitlement.dmpl__FixedCount__c = 15;
        update entitlement;

        dmpl__LeaveEntitlement__c updated = LeaveEntitlementDataHelper.getLeaveEntitlementRecord(entitlement.Id);
        System.assertEquals(15, updated.dmpl__FixedCount__c, 'Fixed Count should be updated to 15');
    }

    @isTest
    static void testDeleteLeaveEntitlement() {
        dmpl__LeaveEntitlement__c entitlement = LeaveEntitlementDataHelper.getLeaveEntitlement();
        delete entitlement;

        Boolean exists = LeaveEntitlementDataHelper.existsLeaveEntitlement(entitlement.Id);
        System.assertEquals(false, exists, 'Leave Entitlement should be deleted');
    }
}