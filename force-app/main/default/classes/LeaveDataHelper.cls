@isTest
public with sharing class LeaveDataHelper {
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

    public static dmpl__Resource__c createResource(
        Account partnerAccount,
        dmpl__Branch__c branch
    ) {
        return (dmpl__Resource__c) TestFactory.createSObject(
            new dmpl__Resource__c(
                Name = 'Test - Resource',
                dmpl__Type__c = 'Manager',
                dmpl__IsActive__c = true,
                dmpl__Phone__c = '9999999999',
                dmpl__DefaultPartnerAccountId__c = partnerAccount.Id,
                dmpl__DefaultBranchId__c = branch.Id
            ),
            'ResourceDefaults',
            true
        );
    }

    public static dmpl__ResourceGroup__c createResourceGroup() {
    return (dmpl__ResourceGroup__c) TestFactory.createSObject(
      new dmpl__ResourceGroup__c(Name = 'Test-ResourceGroup', dmpl__ResourceGroupType__c = 'Incentive', dmpl__DynamicMemberType__c = 'Field Filter'),
      'ResourceGroupDefaults',
	  true
    );
  }

    public static dmpl__ResourceLeave__c createResourceLeave(
		dmpl__Resource__c resource,
		dmpl__LeaveType__c type
	){
		return (dmpl__ResourceLeave__c) TestFactory.createSObject(
            new dmpl__ResourceLeave__c(
				dmpl__LeaveTypeId__c = type.Id,
				dmpl__Available__c = 10,
				dmpl__Balance__c = 10,
				dmpl__ResourceId__c = resource.Id
        	),
			'ResourceLeaveDefaults',
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
    public static dmpl__LeaveType__c getLeaveType(String name) {
        return [
            SELECT Name, dmpl__EntitlementType__c, dmpl__Type__c, OwnerId, CreatedById
            FROM dmpl__LeaveType__c
            WHERE Name = :name
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

	public static dmpl__LeaveType__c createLeaveType(
		String name,
		String entitlementType,
		String type
	){
		return (dmpl__LeaveType__c) TestFactory.createSObject(
            new dmpl__LeaveType__c(
				Name=name,
				dmpl__EntitlementType__c = entitlementType,
				dmpl__Type__c = type
        	),
            true
        );
	}
}