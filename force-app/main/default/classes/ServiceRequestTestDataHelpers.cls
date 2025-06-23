@isTest
public class ServiceRequestTestDataHelpers {
    public static dmpl__ServiceRequest__c createServiceRequest(
        Account customerAccount,
        dmpl__Branch__c branch,
        dmpl__Item__c item,
        Asset asset,
        dmpl__BranchTimeSlot__c brTimeSlot
    ) {
       return (dmpl__ServiceRequest__c)TestFactory.createSObject(
            new dmpl__ServiceRequest__c(
                dmpl__AccountId__c = customerAccount.Id,
                dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                dmpl__AssetId__c = asset.Id,
                dmpl__BranchId__c = branch.Id,
                dmpl__TCSEligibleAmount__c = 100,
                dmpl__AppointmentTimeSlotId__c = brTimeSlot.Id
            ),
            'ServiceRequestDefaults',
            true                      
       );
    }
   
    public static dmpl__ServiceRequest__c getServiceRequest() {
        return [
            SELECT 
                Id,
                Name,
                dmpl__PartnerAccountId__c,
                dmpl__AccountId__c,
                dmpl__AssetId__c,
                dmpl__BranchId__c,
                dmpl__Remarks__c,
                dmpl__UsageReading__c,
                dmpl__UsageReadingHours__c,
                dmpl__ItemServiceContractId__c,
                dmpl__ServiceAdvisorId__c,
                dmpl__ServiceContractItemId__c,
                dmpl__IsPickUpRequired__c,
                dmpl__IsDropOffRequired__c,
                dmpl__IsFieldService__c,
                dmpl__ServiceType__c,
                dmpl__QuoteForItemServiceContractId__c,
                dmpl__AppointmentDate__c,
                dmpl__CustomerVoice__c,
                dmpl__AccountName__c,
                dmpl__AdjustedAdvanceAmount__c,
                dmpl__AdvanceAmount__c,
                dmpl__Status__c,
            (SELECT Id,Name FROM dmpl__Service_Estimates__r LIMIT 1)
            FROM dmpl__ServiceRequest__c LIMIT 1
        ];
    }

    public static dmpl__ServiceRequest__c getServiceRequest(Id serviceRequestId) {
        return [
            SELECT 
                Id,
                Name,
                dmpl__PartnerAccountId__c,
                dmpl__AccountId__c,
                dmpl__AssetId__c,
                dmpl__BranchId__c,
                dmpl__Remarks__c,
                dmpl__UsageReading__c,
                dmpl__UsageReadingHours__c,
                dmpl__ItemServiceContractId__c,
                dmpl__ServiceAdvisorId__c,
                dmpl__ServiceContractItemId__c,
                dmpl__IsPickUpRequired__c,
                dmpl__IsDropOffRequired__c,
                dmpl__IsFieldService__c,
                dmpl__ServiceType__c,
                dmpl__QuoteForItemServiceContractId__c,
                dmpl__AppointmentDate__c,
                dmpl__CustomerVoice__c,
                dmpl__AccountName__c,
                dmpl__AdjustedAdvanceAmount__c,
                dmpl__AdvanceAmount__c,
                dmpl__Status__c,
            (SELECT Id,Name FROM dmpl__Service_Estimates__r LIMIT 1)
            FROM dmpl__ServiceRequest__c WHERE ID = :serviceRequestId LIMIT 1
        ];
    }
 
 
    public static dmpl__ServiceRequestline__c createServiceRequestLine(
        dmpl__ServiceRequest__c serviceRequsest,
        dmpl__Item__c item,
        dmpl__SKU__c sku
    ) {
        return (dmpl__ServiceRequestLine__c)TestFactory.createSObject(
            new dmpl__ServiceRequestLine__c(
                dmpl__ServiceRequestId__c = serviceRequsest.Id,
                dmpl__ItemId__c = item.Id,
                dmpl__Quantity__c = 1,
                dmpl__SKUId__c = sku.Id
            ),
            'ServiceRequestLineDefaults',
            true        
        );
       
    }
    public static dmpl__ServiceRequestLine__c getServiceRequestLine() {
        return [
            SELECT Id, Name
            FROM dmpl__ServiceRequestLine__c
            LIMIT 1
        ];
    }

    public static dmpl__ServiceRequestTax__c createServiceRequestTax(
        dmpl__ServiceRequest__c serviceRequest,
        dmpl__ServiceRequestLine__c serviceRequestLine,
        dmpl__TaxGroup__c taxGroup,
        dmpl__Tax__c tax
    ) {
        return (dmpl__ServiceRequestTax__c)TestFactory.createSObject(
            new dmpl__ServiceRequestTax__c(
                dmpl__ServiceRequestId__c = serviceRequest.Id,
                dmpl__ServiceRequestLineId__c = serviceRequestLine.Id,
                dmpl__TaxGroupId__c = taxGroup.Id,
                dmpl__TaxId__c = tax.Id
            ),
            true        
        );
    }

    public static dmpl__ServiceRequestTax__c getServiceRequestTax() {
        return [
            SELECT Id, Name
            FROM dmpl__ServiceRequestTax__c
            LIMIT 1
        ];
    }
}