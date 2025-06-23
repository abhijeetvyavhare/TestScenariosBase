@isTest
public with sharing class LeaveTypeHandler_Test {

    @TestSetup
    static void createRequiredData() {
        LeaveTypeDataHelper.createLeaveType();
    }

    @isTest
    static void createLeaveTypePositive() {
        dmpl__LeaveType__c lt = LeaveTypeDataHelper.getLeaveType();
        System.assert(lt != null, 'Leave Type should be retrieved');
        System.assert(lt.Id != null, 'Leave Type should be inserted');
    }

    @isTest
    static void updateLeaveTypePositive() {
        dmpl__LeaveType__c lt = LeaveTypeDataHelper.getLeaveType();

        lt.Name = 'Updated Leave Type Name';
        lt.dmpl__EntitlementType__c = 'Sick'; 
        lt.dmpl__Type__c = 'Unpaid';      

        update lt;

        dmpl__LeaveType__c updated = LeaveTypeDataHelper.getLeaveTypeRecord(lt.Id);

        System.assertEquals('Updated Leave Type Name', updated.Name);
        System.assertEquals('Sick', updated.dmpl__EntitlementType__c);
        System.assertEquals('Unpaid', updated.dmpl__Type__c);
    }

    @isTest
    static void deleteLeaveTypePositive() {
        dmpl__LeaveType__c lt = LeaveTypeDataHelper.getLeaveType();
        delete lt;

        Boolean exists = LeaveTypeDataHelper.existsLeaveType(lt.Id);
        System.assertEquals(false, exists, 'Leave Type should be deleted');
    }
}