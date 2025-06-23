@isTest
public with sharing class ResourceHandler_Test {
    @TestSetup
	static void createRequiredData() {
        Account partnerAccount = TestDataHelpers.createPartnerAccount();
        dmpl__Branch__c branch =TestDataHelpers.createBranch(partnerAccount);    
		dmpl__Resource__c resource = ResourceDataHelper.createResource(partnerAccount, branch);
		dmpl__ResourceSkill__c resourceSkill = ResourceDataHelper.createResourceSkill(resource);
		dmpl__LeaveType__c type = ResourceDataHelper.createLeaveType();
		dmpl__ResourceLeave__c resourceLeave = ResourceDataHelper.createResourceLeave(resource, type);
		dmpl__PartnerResource__c partnerResource = ResourceDataHelper.CreatePartnerResources(branch, resource);
		dmpl__ResourceAssignmentRule__c resourceAssignmentRule = ResourceDataHelper.CreateResourceAssignmentRule(partnerResource);
		dmpl__ResourceBusinessHours__c resourceBusinessHours =  ResourceDataHelper.createResourceBusinessHours(resource, type);
	}
	
	@isTest
	static void createResourcePositive() {
		dmpl__Resource__c resource = ResourceDataHelper.getResource();
		System.assertNotEquals(resource, null, 'Expected Resource to be created.');
        System.assertEquals('Test - Resource', resource.Name, 'Resource Name must be Test - Resource');
        System.assertEquals('Manager', resource.dmpl__Type__c, 'Resource Type must be Service Advisor');
        System.assertEquals(true, resource.dmpl__IsActive__c, 'Resource Active state must be True');
        System.assertEquals('9999999999', resource.dmpl__Phone__c, 'Resource Phone must be 9999999999');
	}

	@isTest 
	static void createResourceSkillPositive(){
		dmpl__ResourceSkill__c resourceSkill = ResourceDataHelper.getResourceSkill();
		if(resourceSkill != null){
            System.assertNotEquals(resourceSkill, null, 'Expected Resource Skill to be created.');
        }
        System.assertEquals(1, resourceSkill.dmpl__SkillLevel__c, 'Skill Level Must be 1');
        System.assertEquals(Date.today(), resourceSkill.dmpl__StartDate__c, 'Resource Skill Name must be Test - Resource Skill');
	}

	@isTest 
	static void createResourceLeavePositive(){
		dmpl__ResourceLeave__c resourceLeave = ResourceDataHelper.getResourceLeave();
		if(resourceLeave != null){
			System.assertNotEquals(resourceLeave, null, 'Expected Resource Leave to be created.');
        }
		System.assertEquals(10, resourceLeave.dmpl__Available__c, 'Available Resource Leave Must be 10');
		System.assertEquals(10, resourceLeave.dmpl__Balance__c, 'Balance Resource Leave Must be 10');
	}

	@isTest 
	static void createResourceBusinessHoursPositive(){
		dmpl__ResourceBusinessHours__c resourceBusinessHours = ResourceDataHelper.getResourceBusinessHours();
		System.assertNotEquals(resourceBusinessHours, null, 'Expected Resource Business Hours to be created.');
		System.assertEquals(Date.today(), resourceBusinessHours.dmpl__FromDate__c, ' Resource Business Hours From Date Must be Todays');
	}

	@isTest 
	static void createResourceAssignmentRulePositive(){
		dmpl__ResourceAssignmentRule__c resourceAssignmentRule = ResourceDataHelper.getResourceAssignmentRule();
		if(resourceAssignmentRule != null){
			System.assertNotEquals(resourceAssignmentRule, null, 'Expected Resource Assignment Rule to be created.');
        }
		System.assertEquals('Lead', resourceAssignmentRule.dmpl__AssignmentType__c, 'Resource Assignment Rule From Assignment Type Must be Lead');
		System.assertEquals('dmpl__Remarks__c', resourceAssignmentRule.dmpl__FieldName__c, 'Resource Assignment Rule Field Name Must be Test Field');
		System.assertEquals('Test Remarks', resourceAssignmentRule.dmpl__FieldValue__c, 'Resource Assignment Rule Field Value Must be Test Value');
	}

	@isTest
	static void updateResourcePositive() {
		dmpl__Resource__c resource = ResourceDataHelper.getResource();
        System.assertNotEquals(resource, null, 'Resource should exist before update.');
		resource.dmpl__Type__c = 'Salesperson';
		update resource;
		dmpl__Resource__c resourceUpdated = ResourceDataHelper.getResource(resource.Id);
        System.assertEquals('Salesperson', resourceUpdated.dmpl__Type__c, 'Expected Resource Type to be updated to Salesperson.');
	}

	@isTest 
	static void updateResourceSkillPositive(){
		dmpl__ResourceSkill__c resourceSkill = ResourceDataHelper.getResourceSkill();
        System.assertNotEquals(resourceSkill, null, 'Resource Skill should exist before update.');
		resourceSkill.dmpl__SkillLevel__c = 2;
		update resourceSkill;
		dmpl__ResourceSkill__c resourceSkillUpdated = ResourceDataHelper.getResourceSkill(resourceSkill.Id);
		System.assertEquals(2, resourceSkill.dmpl__SkillLevel__c, 'Skill Level Must be 2');
	}

	@isTest 
	static void updateResourceLeavePositive(){
		dmpl__ResourceLeave__c resourceLeave = ResourceDataHelper.getResourceLeave();
        System.assertNotEquals(resourceLeave, null, 'Resource Leave should exist before update.');
		resourceLeave.dmpl__Available__c = 15;
		resourceLeave.dmpl__Balance__c = 5;
		update resourceLeave;
		dmpl__ResourceLeave__c resourceLeaveUpdated = ResourceDataHelper.getResourceLeave(resourceLeave.Id);
		System.assertEquals(15, resourceLeaveUpdated.dmpl__Available__c, 'Available Resource Leave Must be 15');
		System.assertEquals(5, resourceLeaveUpdated.dmpl__Balance__c, 'Balance Resource Leave Must be 5');
	}

	@isTest 
	static void updateResourceBusinessHoursPositive(){
		dmpl__ResourceBusinessHours__c resourceBusinessHours = ResourceDataHelper.getResourceBusinessHours();
        System.assertNotEquals(resourceBusinessHours, null, 'Resource Leave should exist before update.');
		resourceBusinessHours.dmpl__FromDate__c = Date.today().addDays(1);
		update resourceBusinessHours;
		dmpl__ResourceBusinessHours__c resourceBusinessHoursUpdated = ResourceDataHelper.getResourceBusinessHours(resourceBusinessHours.Id);
		System.assertEquals(Date.today().addDays(1), resourceBusinessHoursUpdated.dmpl__FromDate__c, 'Resource Business Hours From Date Must be Next Day');
	}
	
	@isTest 
	static void updateResourceAssignmentRulePositive(){
		dmpl__ResourceAssignmentRule__c resourceAssignmentRule = ResourceDataHelper.getResourceAssignmentRule();
        System.assertNotEquals(resourceAssignmentRule, null, 'Resource Leave should exist before update.');
		resourceAssignmentRule.dmpl__AssignmentType__c = 'Appointment';
		update resourceAssignmentRule;
		dmpl__ResourceAssignmentRule__c resourceAssignmentRuleUpdated = ResourceDataHelper.getResourceAssignmentRule(resourceAssignmentRule.Id);
		System.assertEquals('Appointment', resourceAssignmentRule.dmpl__AssignmentType__c, ' Resource Assignment Rule From Assignment Type Must be Appointment');
	}
	
	@isTest
	static void deleteResourceAssignmentRule() {
		dmpl__ResourceAssignmentRule__c resourceAssignmentRule = ResourceDataHelper.getResourceAssignmentRule();
		System.assertNotEquals(null, resourceAssignmentRule, 'ResourceAssignmentRule should exist before delete.');

		delete resourceAssignmentRule;

		dmpl__ResourceAssignmentRule__c deletedRule;
		try {
			deletedRule = ResourceDataHelper.getResourceAssignmentRule(resourceAssignmentRule.Id);
		} catch (Exception e) {
			deletedRule = null;
		}
		System.assertEquals(null, deletedRule, 'ResourceAssignmentRule should be deleted and not found in query.');
	}

	@isTest
	static void deleteResourceBusinessHours() {
		dmpl__ResourceBusinessHours__c resourceBusinessHours = ResourceDataHelper.getResourceBusinessHours();
		System.assertNotEquals(null, resourceBusinessHours, 'ResourceBusinessHours should exist before delete.');

		delete resourceBusinessHours;

		dmpl__ResourceBusinessHours__c deletedBusinessHours;
		try {
			deletedBusinessHours = ResourceDataHelper.getResourceBusinessHours(resourceBusinessHours.Id);
		} catch (Exception e) {
			deletedBusinessHours = null;
		}
		System.assertEquals(null, deletedBusinessHours, 'ResourceBusinessHours should be deleted and not found in query.');
	}

	@isTest
	static void deleteResourceLeave() {
		dmpl__ResourceLeave__c resourceLeave = ResourceDataHelper.getResourceLeave();
		System.assertNotEquals(null, resourceLeave, 'ResourceLeave should exist before delete.');

		delete resourceLeave;

		dmpl__ResourceLeave__c deletedLeave;
		try {
			deletedLeave = ResourceDataHelper.getResourceLeave(resourceLeave.Id);
		} catch (Exception e) {
			deletedLeave = null;
		}
		System.assertEquals(null, deletedLeave, 'ResourceLeave should be deleted and not found in query.');
	}

	@isTest
	static void deleteResourceSkill() {
		dmpl__ResourceSkill__c resourceSkill = ResourceDataHelper.getResourceSkill();
		System.assertNotEquals(null, resourceSkill, 'ResourceSkill should exist before delete.');

		delete resourceSkill;

		dmpl__ResourceSkill__c deletedSkill;
		try {
			deletedSkill = ResourceDataHelper.getResourceSkill(resourceSkill.Id);
		} catch (Exception e) {
			deletedSkill = null;
		}
		System.assertEquals(null, deletedSkill, 'ResourceSkill should be deleted and not found in query.');
	}

	@isTest
	static void deleteResource() {
		dmpl__Resource__c resource = ResourceDataHelper.getResource();
		System.assertNotEquals(null, resource, 'Resource should exist before delete.');

		delete resource;

		dmpl__Resource__c deletedResource;
		try {
			deletedResource = ResourceDataHelper.getResource(resource.Id);
		} catch (Exception e) {
			deletedResource = null;
		}
		System.assertEquals(null, deletedResource, 'Resource should be deleted and not found in query.');
	}
}