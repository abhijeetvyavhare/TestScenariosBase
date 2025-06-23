public with sharing class LeaveRequestDataHelper {
    public static dmpl__LeaveRequest__c createLeaveRequest(Id resourceId, Id leaveTypeId) {
        return (dmpl__LeaveRequest__c) TestFactory.createSObject(
            new dmpl__LeaveRequest__c(
                dmpl__ResourceId__c = resourceId,
                dmpl__LeaveTypeId__c = leaveTypeId
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

    public static dmpl__LeaveRequest__c getLeaveRequestById(Id leaveId) {
        return [
            SELECT Name, dmpl__ApplyFor__c, dmpl__FromDate__c, dmpl__ToDate__c,
                   dmpl__Reason__c, dmpl__Status__c
            FROM dmpl__LeaveRequest__c
            WHERE Id = :leaveId
            LIMIT 1
        ];
    }

    public static Boolean existsLeaveRequest(Id leaveId) {
        return [SELECT count() FROM dmpl__LeaveRequest__c WHERE Id = :leaveId] > 0;
    }
}