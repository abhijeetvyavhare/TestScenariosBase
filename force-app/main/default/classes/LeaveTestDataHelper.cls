public with sharing class LeaveTestDataHelper {
    public static dmpl__LeaveType__c createLeaveType() {
        return (dmpl__LeaveType__c) TestFactory.createSObject(
            new dmpl__LeaveType__c(
				    Name = 'Leave Type Insert Test',
					dmpl__EntitlementType__c = 'Grant',  
					dmpl__Type__c = 'Paid' 
			),
            'LeaveTypeDefaults',
            true
        );
    }

    public static dmpl__LeaveType__c getLeaveType() {
        return [
            SELECT Id, Name, dmpl__EntitlementType__c, dmpl__Type__c, OwnerId, CreatedById
            FROM dmpl__LeaveType__c
            LIMIT 1
        ];
    }

    public static dmpl__LeaveType__c getLeaveType(Id id) {
        return [
            SELECT Name, dmpl__EntitlementType__c, dmpl__Type__c, OwnerId, CreatedById
            FROM dmpl__LeaveType__c
            WHERE Id = :id
            LIMIT 1
        ];
    }

	public static dmpl__LeaveRequest__c createLeaveRequest(dmpl__Resource__c resource, dmpl__LeaveType__c leaveType) {
        return (dmpl__LeaveRequest__c) TestFactory.createSObject(
            new dmpl__LeaveRequest__c(
                dmpl__ResourceId__c = resource.Id,
                dmpl__LeaveTypeId__c = leaveType.Id
            ),
            'LeaveRequestDefaults',
            true
        );
    }

    public static dmpl__LeaveRequest__c getLeaveRequest() {
        return [
            SELECT Id, Name, dmpl__ApplyFor__c, dmpl__FromDate__c, dmpl__ToDate__c,
                   dmpl__Reason__c, dmpl__Status__c, dmpl__ResourceId__c, dmpl__LeaveTypeId__c
            FROM dmpl__LeaveRequest__c
            LIMIT 1
        ];
    }

    public static dmpl__LeaveRequest__c getLeaveRequest(Id leaveId) {
        return [
            SELECT Name, dmpl__ApplyFor__c, dmpl__FromDate__c, dmpl__ToDate__c,
                   dmpl__Reason__c, dmpl__Status__c
            FROM dmpl__LeaveRequest__c
            WHERE Id = :leaveId
            LIMIT 1
        ];
    }

	public static dmpl__LeaveEntitlement__c createLeaveEntitlement(dmpl__LeaveType__c leaveType, dmpl__Resource__c resource, dmpl__ResourceGroup__c resourceGroup) {
        return (dmpl__LeaveEntitlement__c) TestFactory.createSObject(
            new dmpl__LeaveEntitlement__c(
                dmpl__LeaveTypeId__c = leaveType.Id,
                dmpl__ResourceId__c = resource.Id,
                dmpl__ResourceGroupId__c = resourceGroup.Id
            ),
            'LeaveEntitlementDefault',
            true
        );
    }

    public static dmpl__LeaveEntitlement__c getLeaveEntitlement() {
        return [
            SELECT Id, Name, dmpl__FixedCount__c, dmpl__LeaveTypeId__c,
                   dmpl__ResourceId__c, dmpl__ResourceGroupId__c
            FROM dmpl__LeaveEntitlement__c
            LIMIT 1
        ];
    }

    public static dmpl__LeaveEntitlement__c getLeaveEntitlement(Id entitlementId) {
        return [
            SELECT Id, Name, dmpl__FixedCount__c, dmpl__LeaveTypeId__c,
                   dmpl__ResourceId__c, dmpl__ResourceGroupId__c
            FROM dmpl__LeaveEntitlement__c
            WHERE Id = :entitlementId
            LIMIT 1
        ];
    }
}