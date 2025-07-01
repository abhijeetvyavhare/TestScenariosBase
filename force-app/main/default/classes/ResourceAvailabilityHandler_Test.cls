@isTest
public with sharing class ResourceAvailabilityHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Account partnerAccount = TestDataHelpers.createPartnerAccount();
        dmpl__Branch__c branch = TestDataHelpers.createBranch(partnerAccount);
        dmpl__Resource__c resource = ResourceDataHelper.createResource(partnerAccount, branch);
        dmpl__ResourceAvailability__c resourceAvailability = ResourceAvailabilityDataHelper.createResourceAvailability(resource);
        dmpl__ResourceAvailabilityData__c resourcAvailabilityData = ResourceAvailabilityDataHelper.createResourceAvailabilityData(
            resource,
        resourceAvailability
            );
        dmpl__ResourceAvailabilityCheckIn__c resourcAvailabilityCheckIn = ResourceAvailabilityDataHelper.createResourceAvailabilityCheckIn(
            resourceAvailability
            );
    }
    
    @isTest
    static void createResourceAvailabilityPositive() {
        dmpl__ResourceAvailability__c resourceAvailability = ResourceAvailabilityDataHelper.getResourceAvailability();
        System.assertNotEquals(resourceAvailability, null, 'Expected Resource Availability to be created.');
        System.assertEquals('Present', resourceAvailability.dmpl__AvailabilityType__c, 'Resource Availability Type must be Present');
    }
    
    @isTest
    static void createResourceAvailabilityDataPositive() {
        dmpl__ResourceAvailabilityData__c resourceAvailabilityData = ResourceAvailabilityDataHelper.getResourceAvailabilityData();
        if (resourceAvailabilityData != null) {
            System.assertNotEquals(resourceAvailabilityData, null, 'Expected Resource Availability Data to be created.');
        }
        System.assertEquals('Check-In', resourceAvailabilityData.dmpl__Type__c, 'Resource Availability Data Type must be Check-In');
    }
    
    @isTest
    static void createResourceAvailabilityCheckInPositive() {
        dmpl__ResourceAvailabilityCheckIn__c resourceAvailabilityCheckIn = ResourceAvailabilityDataHelper.getResourceAvailabilityCheckIn();
        System.assertNotEquals(resourceAvailabilityCheckIn, null, 'Expected Resource Availability CheckIn to be created.');
        System.assertEquals('Desktop', resourceAvailabilityCheckIn.dmpl__CheckInSource__c, 'Resource Availability CheckIn Source must be Desktop');
    }
    
    @isTest
    static void updateResourceAvailabilityPositive() {
        dmpl__ResourceAvailability__c resourceAvailability = ResourceAvailabilityDataHelper.getResourceAvailability();
        System.assertNotEquals(resourceAvailability, null, 'Resource Availability should exist before update.');
        resourceAvailability.dmpl__AvailabilityType__c = 'Leave';
        update resourceAvailability;
        dmpl__ResourceAvailability__c resourceAvailabilityUpdated = ResourceAvailabilityDataHelper.getResourceAvailability(
            resourceAvailability.Id
            );
        System.assertEquals(
            'Leave',
        resourceAvailabilityUpdated.dmpl__AvailabilityType__c,
        'Expected Resource Availability Type to be updated to Leave.'
            );
    }
    
    @isTest
    static void updateResourceAvailabilityDataPositive() {
        dmpl__ResourceAvailabilityData__c resourceAvailabilityData = ResourceAvailabilityDataHelper.getResourceAvailabilityData();
        System.assertNotEquals(resourceAvailabilityData, null, 'Resource Availability Data should exist before update.');
        resourceAvailabilityData.dmpl__Type__c = 'Check-Out';
        update resourceAvailabilityData;
        dmpl__ResourceAvailabilityData__c resourceAvailabilityDataUpdated = ResourceAvailabilityDataHelper.getResourceAvailabilityData(
            resourceAvailabilityData.Id
            );
        System.assertEquals(
            'Check-Out',
        resourceAvailabilityDataUpdated.dmpl__Type__c,
        'Expected Resource Availability Data Type to be updated to Check-Out.'
            );
    }
    
    @isTest
    static void updateResourceAvailabilityCheckInPositive() {
        dmpl__ResourceAvailabilityCheckIn__c resourceAvailabilityCheckIn = ResourceAvailabilityDataHelper.getResourceAvailabilityCheckIn();
        System.assertNotEquals(resourceAvailabilityCheckIn, null, 'Resource Availability Data should exist before update.');
        resourceAvailabilityCheckIn.dmpl__CheckInSource__c = 'Mobile';
        update resourceAvailabilityCheckIn;
        dmpl__ResourceAvailabilityCheckIn__c resourceAvailabilityCheckInUpdated = ResourceAvailabilityDataHelper.getResourceAvailabilityCheckIn(
            resourceAvailabilityCheckIn.Id
            );
        System.assertEquals(
            'Mobile',
        resourceAvailabilityCheckInUpdated.dmpl__CheckInSource__c,
        'Expected Resource Availability Data CheckIn Source to be updated to Mobile.'
            );
    }
    
    @isTest
    static void deleteResourceAvailabilityCheckIn() {
        dmpl__ResourceAvailabilityCheckIn__c resourceAvailabilityCheckIn = ResourceAvailabilityDataHelper.getResourceAvailabilityCheckIn();
        System.assertNotEquals(null, resourceAvailabilityCheckIn, 'ResourceAvailabilityCheckIn should exist before delete.');
        
        delete resourceAvailabilityCheckIn;
        
        dmpl__ResourceAvailabilityCheckIn__c deletedCheckIn;
        try {
            deletedCheckIn = ResourceAvailabilityDataHelper.getResourceAvailabilityCheckIn(resourceAvailabilityCheckIn.Id);
        } catch (Exception e) {
            deletedCheckIn = null;
        }
        System.assertEquals(null, deletedCheckIn, 'ResourceAvailabilityCheckIn should be deleted and not found in query.');
    }
    
    @isTest
    static void deleteResourceAvailabilityData() {
        dmpl__ResourceAvailabilityData__c resourceAvailabilityData = ResourceAvailabilityDataHelper.getResourceAvailabilityData();
        System.assertNotEquals(null, resourceAvailabilityData, 'ResourceAvailabilityData should exist before delete.');
        
        delete resourceAvailabilityData;
        
        dmpl__ResourceAvailabilityData__c deletedData;
        try {
            deletedData = ResourceAvailabilityDataHelper.getResourceAvailabilityData(resourceAvailabilityData.Id);
        } catch (Exception e) {
            deletedData = null;
        }
        System.assertEquals(null, deletedData, 'ResourceAvailabilityData should be deleted and not found in query.');
    }
    
    @isTest
    static void deleteResourceAvailability() {
        dmpl__ResourceAvailability__c resourceAvailability = ResourceAvailabilityDataHelper.getResourceAvailability();
        System.assertNotEquals(null, resourceAvailability, 'ResourceAvailability should exist before delete.');
        
        delete resourceAvailability;
        
        dmpl__ResourceAvailability__c deletedAvailability;
        try {
            deletedAvailability = ResourceAvailabilityDataHelper.getResourceAvailability(resourceAvailability.Id);
        } catch (Exception e) {
            deletedAvailability = null;
        }
        System.assertEquals(null, deletedAvailability, 'ResourceAvailability should be deleted and not found in query.');
    }
    
    //Availability Data with active ResourceAvailabilityId and ResourceId
    @isTest
    static void createAvailabilityDataWithActiveResourceAvailabilityIdAndResourceIdPositive(){
        Test.startTest();
        dmpl__ResourceAvailability__c resourceAvailability = ResourceAvailabilityDataHelper.getResourceAvailability();
        dmpl__Resource__c resource = ResourceDataHelper.getResource();
        dmpl__ResourceAvailabilityData__c availabilityData = ResourceAvailabilityDataHelper.createResourceAvailabilityData(
            resource.Id,
        resourceAvailability.Id,
        null,
        null,
        null
            );
        dmpl__ResourceAvailabilityData__c fetchedavAilabilityData = ResourceAvailabilityDataHelper.getResourceAvailabilityData(availabilityData.Id);
        Test.stopTest();
        System.assertNotEquals(null, fetchedavAilabilityData, 'Availability data should not be null');
        System.assertEquals(resource.Id, fetchedavAilabilityData.dmpl__ResourceId__c, 'Resource ID should match');
        System.assertEquals(resourceAvailability.Id, fetchedavAilabilityData.dmpl__ResourceAvailabilityId__c, 'Resource Availability ID should match');
        
    }
    
    //Record with Type = ‘Check-In’ and  AttendenceTime
    @isTest
    static void createAvailabilityDataWithTypeAndAttendanceTimePositive() {
        
        Test.startTest();
        dmpl__ResourceAvailability__c resourceAvailability = ResourceAvailabilityDataHelper.getResourceAvailability();
        dmpl__Resource__c resource = ResourceDataHelper.getResource();
        DateTime attendanceTime = DateTime.now();
        
        dmpl__ResourceAvailabilityData__c availabilityData = ResourceAvailabilityDataHelper.createResourceAvailabilityData(
            resource.Id,
        resourceAvailability.Id,
        null,
        'Check-In',
        attendanceTime
            );
        
        dmpl__ResourceAvailabilityData__c fetchedAvailabilityData = ResourceAvailabilityDataHelper.getResourceAvailabilityData(availabilityData.Id);
        
        Test.stopTest();
        
        System.assertNotEquals(null, fetchedAvailabilityData, 'Availability data should not be null');
        System.assertEquals(resource.Id, fetchedAvailabilityData.dmpl__ResourceId__c, 'Resource ID should match');
        System.assertEquals(resourceAvailability.Id, fetchedAvailabilityData.dmpl__ResourceAvailabilityId__c, 'Resource Availability ID should match');
        System.assertEquals('Check-In', fetchedAvailabilityData.dmpl__Type__c, 'Type should be Check-In');
        System.assertEquals(attendanceTime, fetchedAvailabilityData.dmpl__Time__c, 'Attendance time should match');
    }
    
    //Record with active BranchId Assigned to Resource
    @isTest
    static void createAvailabilityDataWithActiveBranchPositive() {
        
        Test.startTest();
        dmpl__ResourceAvailability__c resourceAvailability = ResourceAvailabilityDataHelper.getResourceAvailability();
        dmpl__Resource__c resource = ResourceDataHelper.getResource();
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        DateTime attendanceTime = DateTime.now();
        
        dmpl__ResourceAvailabilityData__c availabilityData = ResourceAvailabilityDataHelper.createResourceAvailabilityData(
            resource.Id,
        resourceAvailability.Id,
    branch.Id,
        'Check-In',
        attendanceTime
            );
        dmpl__ResourceAvailabilityData__c fetchedAvailabilityData = ResourceAvailabilityDataHelper.getResourceAvailabilityData(availabilityData.Id);
        
        Test.stopTest();
        
        System.assertNotEquals(null, fetchedAvailabilityData, 'Availability data should not be null');
        System.assertEquals(resource.Id, fetchedAvailabilityData.dmpl__ResourceId__c, 'Resource ID should match');
        System.assertEquals(resourceAvailability.Id, fetchedAvailabilityData.dmpl__ResourceAvailabilityId__c, 'Resource Availability ID should match');
        System.assertEquals('Check-In', fetchedAvailabilityData.dmpl__Type__c, 'Type should be Check-In');
        System.assertEquals(attendanceTime, fetchedAvailabilityData.dmpl__Time__c, 'Attendance time should match');
        System.assertEquals(branch.Id, fetchedAvailabilityData.dmpl__BranchId__c, 'Branch should match');
    }
    
    //Record Logged with Current Date and Time in AttendenceTime Field
    @isTest
    static void createAvailabilityDataWithcurrentAttendanceTimePositive() {
        
        Test.startTest();
        dmpl__ResourceAvailability__c resourceAvailability = ResourceAvailabilityDataHelper.getResourceAvailability();
        dmpl__Resource__c resource = ResourceDataHelper.getResource();
        DateTime attendanceTime = DateTime.now();
        
        dmpl__ResourceAvailabilityData__c availabilityData = ResourceAvailabilityDataHelper.createResourceAvailabilityData(
            resource.Id,
        resourceAvailability.Id,
        null,
        'Check-In',
        attendanceTime
            );
        dmpl__ResourceAvailabilityData__c fetchedAvailabilityData = ResourceAvailabilityDataHelper.getResourceAvailabilityData(availabilityData.Id);
        
        Test.stopTest();
        
        System.assertNotEquals(null, fetchedAvailabilityData, 'Availability data should not be null');
        System.assertEquals(resource.Id, fetchedAvailabilityData.dmpl__ResourceId__c, 'Resource ID should match');
        System.assertEquals(resourceAvailability.Id, fetchedAvailabilityData.dmpl__ResourceAvailabilityId__c, 'Resource Availability ID should match');
        System.assertEquals('Check-In', fetchedAvailabilityData.dmpl__Type__c, 'Type should be Check-In');
        System.assertEquals(attendanceTime, fetchedAvailabilityData.dmpl__Time__c, 'Attendance time should match');
    }
    
    //Multiple Entries for the Same Resource on Same Day with Different Types
    @isTest
    static void createAvailabilityDataWithMultipleEntriesforSameResourcePositive() {
        
        Test.startTest();
        dmpl__ResourceAvailability__c resourceAvailability = ResourceAvailabilityDataHelper.getResourceAvailability();
        dmpl__Resource__c resource = ResourceDataHelper.getResource();
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        DateTime attendanceTime = DateTime.now();
        DateTime checkOutTime = DateTime.now().addHours(3);
        
        dmpl__ResourceAvailabilityData__c availabilityData = ResourceAvailabilityDataHelper.createResourceAvailabilityData(
            resource.Id,
        resourceAvailability.Id,
        branch.Id,
        'Check-In',
        attendanceTime
            );
        
        dmpl__ResourceAvailabilityData__c availabilityData2 = ResourceAvailabilityDataHelper.createResourceAvailabilityData(
            resource.Id,
        resourceAvailability.Id,
        branch.Id,
        'Check-Out',
        checkOutTime
            );
        dmpl__ResourceAvailabilityData__c fetchedAvailabilityData = ResourceAvailabilityDataHelper.getResourceAvailabilityData(availabilityData.Id);
        dmpl__ResourceAvailabilityData__c fetchedAvailabilityData2 = ResourceAvailabilityDataHelper.getResourceAvailabilityData(availabilityData2.Id);
        
        Test.stopTest();
        
        System.assertNotEquals(null, fetchedAvailabilityData, 'Availability data should not be null');
        System.assertEquals(resource.Id, fetchedAvailabilityData.dmpl__ResourceId__c, 'Resource ID should match');
        System.assertEquals(resourceAvailability.Id, fetchedAvailabilityData.dmpl__ResourceAvailabilityId__c, 'Resource Availability ID should match');
        System.assertEquals('Check-In', fetchedAvailabilityData.dmpl__Type__c, 'Type should be Check-In');
        System.assertEquals(attendanceTime, fetchedAvailabilityData.dmpl__Time__c, 'Attendance time should match');
        System.assertEquals(branch.Id, fetchedAvailabilityData.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals('Check-Out', fetchedAvailabilityData2.dmpl__Type__c, 'Type should be Check-In');
        System.assertEquals(checkOutTime, fetchedAvailabilityData2.dmpl__Time__c, 'Attendance time should match');
        
    }
    
    //Time updated When Record is Edited
    @isTest
    static void updateAvailabilityDataWithAttendanceTimePositive() {
        
        Test.startTest();
        dmpl__ResourceAvailability__c resourceAvailability = ResourceAvailabilityDataHelper.getResourceAvailability();
        dmpl__Resource__c resource = ResourceDataHelper.getResource();
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        DateTime attendanceTime = DateTime.now();
        DateTime checkOutTime = DateTime.now().addHours(3);
        
        dmpl__ResourceAvailabilityData__c availabilityData = ResourceAvailabilityDataHelper.createResourceAvailabilityData(
            resource.Id,
        resourceAvailability.Id,
        branch.Id,
        'Check-In',
        attendanceTime
            );
        dmpl__ResourceAvailabilityData__c fetchedAvailabilityData = ResourceAvailabilityDataHelper.getResourceAvailabilityData(availabilityData.Id);
        fetchedAvailabilityData.dmpl__AttendenceTime__c = checkOutTime;
        fetchedAvailabilityData.dmpl__Time__c = checkOutTime;
        Update fetchedAvailabilityData;
        Test.stopTest();
        dmpl__ResourceAvailabilityData__c updaetdAvailabilityData = ResourceAvailabilityDataHelper.getResourceAvailabilityData(fetchedAvailabilityData.Id);
        
        System.assertNotEquals(null, updaetdAvailabilityData, 'Availability data should not be null');
        System.assertEquals(resource.Id, updaetdAvailabilityData.dmpl__ResourceId__c, 'Resource ID should match');
        System.assertEquals(resourceAvailability.Id, updaetdAvailabilityData.dmpl__ResourceAvailabilityId__c, 'Resource Availability ID should match');
        System.assertEquals('Check-In', updaetdAvailabilityData.dmpl__Type__c, 'Type should be Check-In');
        System.assertEquals(checkOutTime, updaetdAvailabilityData.dmpl__Time__c, 'Attendance time should match');
        System.assertEquals(branch.Id, updaetdAvailabilityData.dmpl__BranchId__c, 'Branch should match');
        
    }
    
    //Record Without ResourceAvailabilityId (mandatory field missing)
    @isTest
    static void createAvailabilityDataWithoutResourceAvailabilityNegative() {
        
        Test.startTest();
        dmpl__Resource__c resource = ResourceDataHelper.getResource();
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        DateTime attendanceTime = DateTime.now();
        dmpl__ResourceAvailabilityData__c availabilityData;
        try{
             availabilityData = ResourceAvailabilityDataHelper.createResourceAvailabilityData(
                resource.Id,
            null,
            branch.Id,
            'Check-In',
            attendanceTime
                );
        }catch(Exception e){}
        Test.stopTest();
        
        System.assertEquals(null, availabilityData, 'Availability data should not be created missing resource availability');
    }
}