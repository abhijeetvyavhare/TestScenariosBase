@isTest
private class LeaveEntitlementHandler_Test {

    @isTest
    static void createLeaveEntitlementwithLeaveTypePositive() {
        Test.startTest();

        dmpl__LeaveType__c leaveType = (dmpl__LeaveType__c) TestFactory.createSObject(
            new dmpl__LeaveType__c(Name = 'Maternity Leave'),
            'LeaveTypeDefault',
            true
        );

        dmpl__Resource__c resource = (dmpl__Resource__c) TestFactory.createSObject(
            new dmpl__Resource__c(Name = 'Test Resource'),
            'ResourceDefault',
            true
        );

        dmpl__ResourceGroup__c resourceGroup = (dmpl__ResourceGroup__c) TestFactory.createSObject(
            new dmpl__ResourceGroup__c(Name = 'Test Group'),
            'ResourceGroupDefault',
            true
        );

        dmpl__LeaveEntitlement__c entitlement = LeaveEntitlementDataHelper.createLeaveEntitlement(leaveType, resource, resourceGroup);

        System.assertNotEquals(null, entitlement, 'Leave Entitlement should be created');
        System.assertEquals(leaveType.Id, entitlement.dmpl__LeaveTypeId__c, 'Leave Type should match');

        Test.stopTest();
    }
}