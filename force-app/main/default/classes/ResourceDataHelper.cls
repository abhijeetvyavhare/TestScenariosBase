@isTest
public with sharing class ResourceDataHelper {
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

    public static dmpl__Resource__c getResource() {
        return [SELECT Id, Name, dmpl__ResourceType__c, dmpl__IsActive__c, dmpl__Phone__c, dmpl__Type__c FROM dmpl__Resource__c LIMIT 1];
    }
    
	public static dmpl__Resource__c getResource(Id id) {
        return [SELECT Id, Name, dmpl__ResourceType__c, dmpl__IsActive__c, dmpl__Phone__c, dmpl__Type__c FROM dmpl__Resource__c WHERE Id = :id LIMIT 1];
    }

	public static dmpl__ResourceSkill__c createResourceSkill(
		dmpl__Resource__c resource
	){
		return (dmpl__ResourceSkill__c) TestFactory.createSObject(
            new dmpl__ResourceSkill__c(
                dmpl__IsActive__c = true,
                dmpl__ResourceId__c = resource.Id,
				dmpl__SkillLevel__c = 1,
				dmpl__StartDate__c = Date.today(),
				dmpl__EndDate__c = Date.today().addDays(7)
            ),
			'ResourceSkillDefaults',
            true
        );
	}

	public static dmpl__ResourceSkill__c getResourceSkill(){
		return [SELECT Id, Name, dmpl__IsActive__c, dmpl__SkillLevel__c, dmpl__StartDate__c FROM dmpl__ResourceSkill__c LIMIT 1 ];
	}

	public static dmpl__ResourceSkill__c getResourceSkill(Id id){
		return [SELECT Id, Name, dmpl__IsActive__c, dmpl__SkillLevel__c, dmpl__StartDate__c FROM dmpl__ResourceSkill__c WHERE Id = :id LIMIT 1 ];
	}

	public static dmpl__LeaveType__c createLeaveType(){
		return (dmpl__LeaveType__c) TestFactory.createSObject(
            new dmpl__LeaveType__c(
				Name='Test'
        	),
			'LeaveTypeDefaults',
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
	
	public static dmpl__ResourceLeave__c getResourceLeave(){
		return [ SELECT Id, 
                Name, 
                dmpl__Available__c, 
                dmpl__Balance__c, 
                dmpl__LeaveTypeId__c, 
                dmpl__ResourceId__c 
				FROM dmpl__ResourceLeave__c LIMIT 1 ];
	}

	public static dmpl__ResourceLeave__c getResourceLeave(Id id){
				return [ SELECT Id, 
                Name, 
                dmpl__Available__c, 
                dmpl__Balance__c, 
                dmpl__LeaveTypeId__c, 
                dmpl__ResourceId__c
				FROM dmpl__ResourceLeave__c WHERE Id = :id LIMIT 1 ];
	}

	public static dmpl__ResourceBusinessHours__c createResourceBusinessHours(
		dmpl__Resource__c resource,
		dmpl__LeaveType__c type
		){
		return (dmpl__ResourceBusinessHours__c) TestFactory.createSObject(
            new dmpl__ResourceBusinessHours__c(
				dmpl__ResourceId__c = resource.Id,
				dmpl__FromDate__c = Date.today()
			),
			'ResourceBusinessHoursDefaults',
			true
        );
	}

	public static dmpl__ResourceBusinessHours__c getResourceBusinessHours(){
		return [SELECT Id, Name, dmpl__ResourceId__c, dmpl__FromDate__c FROM dmpl__ResourceBusinessHours__c LIMIT 1];
	}
	public static dmpl__ResourceBusinessHours__c getResourceBusinessHours(Id id){
		return [SELECT Id, Name, dmpl__ResourceId__c, dmpl__FromDate__c,dmpl__ToDate__c FROM dmpl__ResourceBusinessHours__c WHERE Id = :id LIMIT 1];
	}
	
	public static dmpl__PartnerResource__c CreatePartnerResources(
		dmpl__Branch__c branch,
		dmpl__Resource__c resource
	){
		return (dmpl__PartnerResource__c) TestFactory.createSObject(
            new dmpl__PartnerResource__c(
				dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
				dmpl__BranchId__c= branch.Id,
				dmpl__ResourceId__c= resource.Id,               
				dmpl__RuleSuccessCriteria__c='Any Rule Is Met',
				dmpl__AssignmentSequenceNumber__c=12
			),
			'PartnerResourceDefaults',
			true
        );
	}

	public static dmpl__ResourceAssignmentRule__c CreateResourceAssignmentRule(
		dmpl__PartnerResource__c partnerResource
		){
			return (dmpl__ResourceAssignmentRule__c) TestFactory.createSObject(
				new dmpl__ResourceAssignmentRule__c(
					dmpl__PartnerResourceId__c=partnerResource.Id,
					dmpl__FieldName__c='dmpl__Remarks__c',	
					dmpl__FieldValue__c='Test Remarks',
					dmpl__Operation__c='equals',
					dmpl__SequenceNumber__c=12,
					dmpl__AssignmentType__c='Lead'
				),
				'ResourceAssignmentRuleDefaults',
			true
		);
	}
						
	public static dmpl__ResourceAssignmentRule__c getResourceAssignmentRule(){
		return [SELECT Id, Name, dmpl__PartnerResourceId__c, dmpl__FieldName__c, dmpl__FieldValue__c, dmpl__Operation__c, dmpl__SequenceNumber__c, dmpl__AssignmentType__c FROM dmpl__ResourceAssignmentRule__c LIMIT 1];
	}
	
	public static dmpl__ResourceAssignmentRule__c getResourceAssignmentRule(Id id){
		return [SELECT Id, Name, dmpl__PartnerResourceId__c, dmpl__FieldName__c, dmpl__FieldValue__c, dmpl__Operation__c, dmpl__SequenceNumber__c, dmpl__AssignmentType__c FROM dmpl__ResourceAssignmentRule__c WHERE Id = :id LIMIT 1];
	}

	public static dmpl__ResourceLeave__c createResourceLeave(
		Id resourceId,
		Id typeId,
		Integer Balance
	){
		return (dmpl__ResourceLeave__c) TestFactory.createSObject(
            new dmpl__ResourceLeave__c(
				dmpl__LeaveTypeId__c = type.Id,
				dmpl__Available__c = 10,
				dmpl__Balance__c = Balance,
				dmpl__ResourceId__c = resource.Id
        	),
            true
        );
	}

	public static dmpl__LeaveType__c getLeaveType(){
		return [SELECT Id, Name, dmpl__EntitlementType__c, dmpl__Type__c FROM dmpl__LeaveType__c LIMIT 1];
	}

	public static dmpl__ResourceBusinessHours__c createResourceBusinessHours(
		Id resourceId,
		Date dateFrom,
		Date dateTo
		){
		return (dmpl__ResourceBusinessHours__c) TestFactory.createSObject(
            new dmpl__ResourceBusinessHours__c(
				dmpl__ResourceId__c = resourceId,
				dmpl__FromDate__c = dateFrom,
				dmpl__ToDate__c = dateTo
			),
			true
        );
	}
}