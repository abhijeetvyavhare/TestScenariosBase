public with sharing class ComplaintTestDataHelpers {
public static dmpl__Complaint__c createComplaint() {
    return (dmpl__Complaint__c) TestFactory.createSObject(
        new dmpl__Complaint__c(
            Name = 'Complaint-Test',
            dmpl__Code__c = '37592',
            dmpl__Description__c = 'Text'                                 
        ),
        'ComplaintDefaults',
        true
    );
}
public static dmpl__Complaint__c getComplaint() {
    return [
        SELECT Id, Name, dmpl__Code__c, dmpl__Description__c
        FROM dmpl__Complaint__c
        WHERE Name = 'Complaint-Test' AND dmpl__Code__c = '37592'
        LIMIT 1
    ];
}


public static dmpl__ComplaintLine__c createComplaintLine(dmpl__ServiceRequest__c serviceRequest,dmpl__Item__c item,dmpl__Quote__c quote,dmpl__Complaint__c complaint) {
    return (dmpl__ComplaintLine__c) TestFactory.createSObject(
        new dmpl__ComplaintLine__c(
           dmpl__ComplaintId__c = complaint.Id,
           dmpl__ServiceRequestId__c = serviceRequest.Id,
           dmpl__ServiceEstimateId__c = quote.Id
       ),
        'CompalintLineDefaults',
        true
    );
}
public static dmpl__ComplaintLine__c getComplaintLine() {
    return [
        SELECT Id, Name
        FROM dmpl__ComplaintLine__c
        LIMIT 1
    ];
}


public static dmpl__ComplaintFault__c createComplaintFault(dmpl__Complaint__c complaint) {
    return (dmpl__ComplaintFault__c) TestFactory.createSObject(
        new dmpl__ComplaintFault__c(
            Name = 'Test-Complaint-Fault-Code',
            dmpl__ComplaintId__c = complaint.Id
        ),
        'ComplaintFaultDefaults',
        true
    );
}
public static dmpl__ComplaintFault__c getComplaintFault() {
    return [
        SELECT Id, Name
        FROM dmpl__ComplaintFault__c
        LIMIT 1
    ];
}


 public static dmpl__Complaint__c getComplaintById(Id complaintId) {
        return [
            SELECT Id, dmpl__Description__c
            FROM dmpl__Complaint__c
            WHERE Id = :complaintId
            LIMIT 1
        ];
    }

    public static Integer getComplaintCountById(Id complaintId) {
        return [
            SELECT COUNT() FROM dmpl__Complaint__c WHERE Id = :complaintId
        ];
    }


}