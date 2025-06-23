@isTest
public with sharing class ResourceAvailabilityDataHelper {
	public static dmpl__ResourceAvailability__c createResourceAvailability(
		dmpl__Resource__c resource
	){
		return (dmpl__ResourceAvailability__c) TestFactory.createSObject(
			new dmpl__ResourceAvailability__c (
				dmpl__ResourceId__c = resource.Id,
				dmpl__AvailabilityType__c = 'Present',
				dmpl__Date__c = Date.Today()
			),
			'ResourceAvailabilityDefaults',
			true
		);
	}

	public static dmpl__ResourceAvailability__c getResourceAvailability(){
		return [SELECT Id, Name, dmpl__ResourceId__c, dmpl__AvailabilityType__c, dmpl__Date__c FROM dmpl__ResourceAvailability__c LIMIT 1 ];
	}

	public static dmpl__ResourceAvailability__c getResourceAvailability(Id id){
		return [SELECT Id, Name, dmpl__ResourceId__c, dmpl__AvailabilityType__c, dmpl__Date__c FROM dmpl__ResourceAvailability__c WHERE Id = :id LIMIT 1 ];
	}

	public static dmpl__ResourceAvailabilityData__c createResourceAvailabilityData(
		dmpl__Resource__c resource,
		dmpl__ResourceAvailability__c resourceAvailability
	){
		return (dmpl__ResourceAvailabilityData__c) TestFactory.createSObject(
			new dmpl__ResourceAvailabilityData__c (
				dmpl__Type__c = 'Check-In',
                dmpl__ResourceId__c = resource.Id,
                dmpl__AttendenceTime__c = DateTime.valueOf(datetime.now()),
                dmpl__ResourceAvailabilityId__c = resourceAvailability.Id
			),
			'ResourceAvailabilityDataDefaults',
			true
		);
	}

	public static dmpl__ResourceAvailabilityData__c getResourceAvailabilityData(){
		return [SELECT Id, Name, dmpl__ResourceId__c, dmpl__Type__c, dmpl__AttendenceTime__c, dmpl__ResourceAvailabilityId__c FROM dmpl__ResourceAvailabilityData__c LIMIT 1 ];
	}

	public static dmpl__ResourceAvailabilityData__c getResourceAvailabilityData(Id id){
		return [SELECT Id, Name, dmpl__ResourceId__c, dmpl__Type__c, dmpl__AttendenceTime__c, dmpl__ResourceAvailabilityId__c FROM dmpl__ResourceAvailabilityData__c WHERE Id = :id LIMIT 1 ];
	}

	public static dmpl__ResourceAvailabilityCheckIn__c createResourceAvailabilityCheckIn(
		dmpl__ResourceAvailability__c resourceAvailability
	){
		return (dmpl__ResourceAvailabilityCheckIn__c) TestFactory.createSObject(
			new dmpl__ResourceAvailabilityCheckIn__c (
                dmpl__ResourceAvailabilityId__c = resourceAvailability.Id,
				dmpl__CheckInSource__c = 'Desktop'
			),
			'ResourceAvailabilityCheckInDefaults',
			true
		);
	}

	public static dmpl__ResourceAvailabilityCheckIn__c getResourceAvailabilityCheckIn(){
		return [SELECT Id, Name, dmpl__CheckInSource__c, dmpl__ResourceAvailabilityId__c FROM dmpl__ResourceAvailabilityCheckIn__c LIMIT 1 ];
	}

	public static dmpl__ResourceAvailabilityCheckIn__c getResourceAvailabilityCheckIn(Id id){
		return [SELECT Id, Name, dmpl__CheckInSource__c, dmpl__ResourceAvailabilityId__c FROM dmpl__ResourceAvailabilityCheckIn__c WHERE Id = :id LIMIT 1 ];
	}
}