public with sharing class ComplaintItemDataHandler {
    public static dmpl__ComplaintItem__c createComplaintItem(
        dmpl__Complaint__c complaint,
        dmpl__ComplaintFault__c complaintFault,
        dmpl__Item__c item
    ) {
        return (dmpl__ComplaintItem__c) TestFactory.createSObject(
            new dmpl__ComplaintItem__c(
                dmpl__ComplaintId__c = complaint.Id,
                dmpl__ComplaintFaultCodeId__c = complaintFault.Id,
                dmpl__ItemId__c = item.Id,
                dmpl__IsMandatory__c = false,
                dmpl__Quantity__c = 1
            ),
            'ComplaintItemDefaults',
            true
        );
    }

    public static dmpl__ComplaintItem__c getComplaintItemByComplaint(Id complaintId) {
        return [
            SELECT 
                Id, 
                Name, 
                dmpl__ComplaintId__c, 
                dmpl__ComplaintFaultCodeId__c, 
                dmpl__ItemId__c, 
                dmpl__IsMandatory__c, 
                dmpl__Quantity__c, 
                dmpl__ExternalId__c, OwnerId
            FROM dmpl__ComplaintItem__c
            WHERE dmpl__ComplaintId__c = :complaintId
            LIMIT 1
        ];
    }

    public static dmpl__ComplaintItem__c getComplaintItem() {
        return [
            SELECT 
                Id, 
                Name, 
                dmpl__ComplaintId__c, 
                dmpl__ComplaintFaultCodeId__c, 
                dmpl__ItemId__c, 
                dmpl__IsMandatory__c, 
                dmpl__Quantity__c, 
                dmpl__ExternalId__c, OwnerId
            FROM dmpl__ComplaintItem__c
            LIMIT 1
        ];
    }
}