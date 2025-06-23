public with sharing class ComplaintLineDataHandler {
    public static dmpl__ComplaintLine__c createComplaintLine(
        dmpl__Complaint__c complaint,
    dmpl__ComplaintFault__c complaintFault
    ) {
        return (dmpl__ComplaintLine__c) TestFactory.createSObject(
            new dmpl__ComplaintLine__c(
                dmpl__ComplaintId__c = complaint.Id,
                dmpl__ComplaintFaultCodeId__c = complaintFault != null ? complaintFault.Id : null
            ),
            'ComplaintLineDefaults',
            true
        );
    }
    
    public static dmpl__ComplaintLine__c getComplaintLineByComplaint(Id complaintId) {
        return [
            SELECT 
                Id, 
                Name, 
                dmpl__ComplaintId__c, 
                dmpl__ComplaintFaultCodeId__c, 
                dmpl__ServiceEstimateId__c, 
                dmpl__ServiceRequestId__c, 
                dmpl__RepairOrderId__c, 
                dmpl__ExternalId__c, 
                OwnerId
            FROM dmpl__ComplaintLine__c
            WHERE dmpl__ComplaintId__c = :complaintId
            LIMIT 1
        ];
    }
    
    public static dmpl__ComplaintLine__c getComplaintLineById(Id lineId) {
        return [
            SELECT 
                Id, 
                Name, 
                dmpl__ComplaintId__c, 
                dmpl__ComplaintFaultCodeId__c, 
                dmpl__ServiceEstimateId__c, 
                dmpl__ServiceRequestId__c, 
                dmpl__RepairOrderId__c, 
                dmpl__ExternalId__c, 
                OwnerId
            FROM dmpl__ComplaintLine__c
            WHERE Id = :lineId
            LIMIT 1
        ];
    }
    
    public static Integer deleteComplaintLine(dmpl__ComplaintLine__c line) {
        Id lineId = line.Id;
        delete line;
        return [
            SELECT COUNT() FROM dmpl__ComplaintLine__c WHERE Id = :lineId
        ];
    }
}