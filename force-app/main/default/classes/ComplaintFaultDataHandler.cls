public with sharing class ComplaintFaultDataHandler {
    public static dmpl__ComplaintFault__c createComplaintFault(dmpl__Complaint__c complaint, dmpl__Item__c item, dmpl__ItemGroup__c itemGroup) {
        return (dmpl__ComplaintFault__c) TestFactory.createSObject(
            new dmpl__ComplaintFault__c(
                Name = 'Test-Complaint-Fault-Code',
                dmpl__ComplaintId__c = complaint.Id,
                dmpl__ApplicableToItemId__c = item != null ? item.Id : null,
                dmpl__ApplicableToItemGroupId__c = itemGroup != null ? itemGroup.Id : null,
                dmpl__Description__c = 'Text',
                dmpl__FaultCode__c = '37592'
            ),
            'ComplaintFaultDefaults',
            true
        );
    }

    public static dmpl__ComplaintFault__c getComplaintFault() {
        return [
            SELECT 
                Id, 
                Name, 
                dmpl__FaultCode__c, 
                dmpl__Description__c, 
                dmpl__ComplaintId__c, 
                dmpl__ApplicableToItemId__c, 
                dmpl__ApplicableToItemGroupId__c
            FROM dmpl__ComplaintFault__c
            WHERE Name = 'Test-Complaint-Fault-Code'
            LIMIT 1
        ];
    }

    public static dmpl__ComplaintFault__c getComplaintFault(Id faultId) {
        return [
            SELECT 
                Id, 
                Name,
                dmpl__FaultCode__c, 
                dmpl__Description__c, 
                dmpl__ComplaintId__c, 
                dmpl__ApplicableToItemId__c, 
                dmpl__ApplicableToItemGroupId__c
            FROM dmpl__ComplaintFault__c
            WHERE Id = :faultId
            LIMIT 1
        ];
    }

    public static dmpl__ComplaintFault__c updateComplaintFault(dmpl__ComplaintFault__c fault, String newDescription) {
        fault.dmpl__Description__c = newDescription;
        update fault;
        return getComplaintFault(fault.Id);
    }

    public static Integer deleteComplaintFault(dmpl__ComplaintFault__c fault) {
        Id faultId = fault.Id;
        delete fault;
        return [
            SELECT COUNT() FROM dmpl__ComplaintFault__c WHERE Id = :faultId
        ];
    }
}