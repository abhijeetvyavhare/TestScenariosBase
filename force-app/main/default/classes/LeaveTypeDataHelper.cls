public with sharing class LeaveTypeDataHelper {
    public static dmpl__LeaveType__c createLeaveType() {
        return (dmpl__LeaveType__c) TestFactory.createSObject(
            new dmpl__LeaveType__c(),
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

    public static dmpl__LeaveType__c getLeaveTypeRecord(Id leaveTypeId) {
        return [
            SELECT Name, dmpl__EntitlementType__c, dmpl__Type__c, OwnerId, CreatedById
            FROM dmpl__LeaveType__c
            WHERE Id = :leaveTypeId
            LIMIT 1
        ];
    }

    public static Boolean existsLeaveType(Id leaveTypeId) {
        return [SELECT count() FROM dmpl__LeaveType__c WHERE Id = :leaveTypeId] > 0;
    }
}