@isTest
public with sharing class LeaveHandler_Test {
    @TestSetup
    static void createRequiredData() {
        dmpl__LeaveType__c leaveType = LeaveDataHelper.createLeaveType();
		Account partnerAccount = TestDataHelpers.createPartnerAccount();
        dmpl__Branch__c branch =TestDataHelpers.createBranch(partnerAccount);    
		dmpl__Resource__c resource = LeaveDataHelper.createResource(partnerAccount, branch);
		dmpl__ResourceLeave__c resourceLeave = LeaveDataHelper.createResourceLeave(resource, leaveType);
		dmpl__LeaveRequest__c leaveRequest = LeaveDataHelper.createLeaveRequest(resource, leaveType);
		dmpl__ResourceGroup__c resourceGroup = LeaveDataHelper.createResourceGroup();
		dmpl__LeaveEntitlement__c leaveEntitlement = LeaveDataHelper.createLeaveEntitlement(leaveType, resource, resourceGroup);
    }

    @isTest
    static void createLeaveTypePositive() {
        dmpl__LeaveType__c leaveType = LeaveDataHelper.getLeaveType();
		System.assertNotEquals(leaveType, null, 'Expected LeaveType to be created.');
        System.assertEquals('Grant', leaveType.dmpl__EntitlementType__c , 'LeaveType EntitlementType should be Grant');
        System.assertEquals('Paid', leaveType.dmpl__Type__c, 'LeaveType Type should be Paid');
    }

    @isTest
    static void updateLeaveTypePositive() {
        dmpl__LeaveType__c leaveType = LeaveDataHelper.getLeaveType();
        System.assertNotEquals(leaveType, null, 'Expected LeaveType should be Exisit.');
        leaveType.dmpl__EntitlementType__c = 'Fixed'; 
        leaveType.dmpl__Type__c = 'Unpaid';      
        update leaveType;
        dmpl__LeaveType__c updatedLeaveType = LeaveDataHelper.getLeaveType(leaveType.Id);
        System.assertEquals('Fixed', updatedLeaveType.dmpl__EntitlementType__c, 'LeaveType EntitlementType should be Fixed');
        System.assertEquals('Unpaid', updatedLeaveType.dmpl__Type__c, 'LeaveType Type should be Unpaid');
    }

	@isTest 
	static void createLeaveRequestPositive(){
		dmpl__LeaveRequest__c leaveRequest = LeaveDataHelper.getLeaveRequest();
		System.assertNotEquals(null, leaveRequest, 'Expected LeaveRequest to be created.');
		System.assertEquals('Full Day',leaveRequest.dmpl__ApplyFor__c, 'Expected LeaveRequest Apply For should be Full Day');
		System.assertEquals('Pending Approval', leaveRequest.dmpl__Status__c, 'Expected LeaveRequest Status should be Pending Approval');
	}

	@isTest 
	static void updateLeaveRequestPositive(){
		dmpl__LeaveRequest__c leaveRequest = LeaveDataHelper.getLeaveRequest();
		System.AssertNotEquals(null, leaveRequest, 'Expected LeaveRequest should be exist.');
		leaveRequest.dmpl__Status__c = 'Draft';
		update leaveRequest;
		dmpl__LeaveRequest__c updatedLeaveRequest = LeaveDataHelper.getLeaveRequest(leaveRequest.Id);
		System.assertEquals('Draft', updatedLeaveRequest.dmpl__Status__c, 'Expected LeaveRequest Status should be Draft');
	}

	@isTest
    static void createLeaveEntitlementPositive() {
        dmpl__LeaveEntitlement__c leaveEntitlement = LeaveDataHelper.getLeaveEntitlement();
		System.AssertNotEquals(null, leaveEntitlement, 'Expected LeaveEntitlement to be created.');
		System.assertEquals(12, leaveEntitlement.dmpl__FixedCount__c, 'Expected FixedCount to be 12');	
    }

	@isTest
    static void UpdateLeaveEntitlementPositive() {
        dmpl__LeaveEntitlement__c leaveEntitlement = LeaveDataHelper.getLeaveEntitlement();
		System.AssertNotEquals(null, leaveEntitlement, 'Expected LeaveEntitlement should be exist.');
        leaveEntitlement.dmpl__FixedCount__c = 15;
        update leaveEntitlement;
        dmpl__LeaveEntitlement__c updatedLeaveEntitlement = LeaveDataHelper.getLeaveEntitlement(leaveEntitlement.Id);
        System.assertEquals(15, updatedLeaveEntitlement.dmpl__FixedCount__c, 'Fixed Count should be updated to 15');
    }

	@isTest
	static void deleteLeaveEntitlementById() {
		dmpl__LeaveEntitlement__c leaveEntitlement = LeaveDataHelper.getLeaveEntitlement();
		System.assertNotEquals(null, leaveEntitlement, 'LeaveEntitlement should exist before deletion.');
		
		delete leaveEntitlement;

		dmpl__LeaveEntitlement__c deletedLeaveEntitlement;
		try {
			deletedLeaveEntitlement = LeaveDataHelper.getLeaveEntitlement(leaveEntitlement.Id);
		} catch (Exception e) {
			deletedLeaveEntitlement = null;
		}
		System.assertEquals(null, deletedLeaveEntitlement, 'LeaveEntitlement should be deleted and not found.');
	}

	@isTest
	static void deleteLeaveRequest() {
		dmpl__LeaveRequest__c leaveRequest = LeaveDataHelper.getLeaveRequest();
		System.assertNotEquals(null, leaveRequest, 'LeaveRequest should exist before deletion.');

		delete leaveRequest;

		dmpl__LeaveRequest__c deletedLeaveRequest;
		try {
			deletedLeaveRequest = LeaveDataHelper.getLeaveRequest(leaveRequest.Id);
		} catch (Exception e) {
			deletedLeaveRequest = null;
		}
		System.assertEquals(null, deletedLeaveRequest, 'LeaveRequest should be deleted and not found.');
	}

   @isTest
	static void deleteLeaveType() {
		dmpl__LeaveType__c leaveType = LeaveDataHelper.getLeaveType();
		System.assertNotEquals(null, leaveType, 'LeaveType should exist before deletion.');

		delete leaveType;

		dmpl__LeaveType__c deletedLeaveType;
		try {
			deletedLeaveType = LeaveDataHelper.getLeaveType(leaveType.Id);
		} catch (Exception e) {
			deletedLeaveType = null;
		}
		System.assertEquals(null, deletedLeaveType, 'LeaveType should be deleted and not found.');
	}
}