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

    public static dmpl__ServiceRequestline__c createServiceRequestLineById(
    dmpl__ServiceRequest__c serviceRequsest,
    dmpl__Item__c item,
    dmpl__SKU__c sku
) {
    return (dmpl__ServiceRequestLine__c)TestFactory.createSObject(
        new dmpl__ServiceRequestLine__c(
            dmpl__ServiceRequestId__c = serviceRequsest != null ? serviceRequsest.Id : null,
            dmpl__ItemId__c           = item != null ? item.Id : null,
            dmpl__Quantity__c         = 1,
            dmpl__SKUId__c            = sku != null ? sku.Id : null
        ),
        //'ServiceRequestLineDefaults',
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
                dmpl__ServiceRequestId__c = serviceRequest?.Id,
                dmpl__ServiceRequestLineId__c = serviceRequestLine?.Id,
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
    public static dmpl__ServiceRequest__c createServiceRequestWithId(
    Account partnerAccount,
    Account customerAccount,
    dmpl__Branch__c branch,
    Asset asset
) {
    return (dmpl__ServiceRequest__c) TestFactory.createSObject(
        new dmpl__ServiceRequest__c(
            dmpl__PartnerAccountId__c  = partnerAccount != null ? partnerAccount.Id : null,
            dmpl__AccountId__c         = customerAccount != null ? customerAccount.Id : null,
            dmpl__BranchId__c          = branch != null ? branch.Id : null,
            dmpl__Status__c            = 'Customer Requested',
            dmpl__AssetId__c           = asset != null ? asset.Id : null
        ),
        //'ServiceRequestDefaults',
        true
    );
}
public static dmpl__ServiceRequest__c getServiceRequestById(Id id) {
    return [
        SELECT 
            Id,
            dmpl__PartnerAccountId__c,
            dmpl__AccountId__c,
			dmpl__AccountName__c,
            dmpl__BranchId__c,
            dmpl__Status__c,
			dmpl__PriceListId__c,
            dmpl__AssetId__c,dmpl__BillingAddressId__c,dmpl__BillingStreet__c,dmpl__ShippingPostalCode__c,dmpl__ShippingCountry__c,dmpl__ShippingState__c,dmpl__ShippingCity__c,dmpl__ShippingStreet__c,dmpl__BillingPostalCode__c,dmpl__BillingCountry__c,dmpl__BillingState__c,dmpl__BillingCity__c        
		FROM dmpl__ServiceRequest__c
        WHERE Id = :id
        LIMIT 1
    ];
}
    public static dmpl__ServiceRequest__c createServiceRequestWithId(
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
                dmpl__AppointmentTimeSlotId__c = brTimeSlot?.Id
            ),
            // 'ServiceRequestDefaults',
            true                      
       );
    }

    public static dmpl__ServiceRequestLine__c createServiceRequestLineWithId(
    dmpl__ServiceRequest__c  serviceRequest,
    dmpl__Item__c  item,
    Decimal quantity,
    Decimal unitPrice
    ) {
       return (dmpl__ServiceRequestLine__c)TestFactory.createSObject(
            new dmpl__ServiceRequestLine__c(
        dmpl__ServiceRequestId__c = serviceRequest != null ? serviceRequest.Id : null,
        dmpl__ItemId__c           = item != null ? item.Id : null,
        dmpl__Quantity__c         = quantity,
        dmpl__UnitPrice__c        = unitPrice
            ),
            //'ServiceRequestDefaults',
            true                      
       );
    }
        public static dmpl__ServiceRequestLine__c getServiceRequestLineById(Id id) {
        return [
SELECT Id, dmpl__Amount__c, dmpl__BaseAmount__c, dmpl__GrossAmount__c,
           dmpl__Quantity__c, dmpl__ServiceContractWeightage__c,
           dmpl__ServiceRequestId__c, dmpl__UnitPrice__c, dmpl__ItemId__c, dmpl__PriceListId__c
    FROM dmpl__ServiceRequestLine__c
    WHERE Id = :Id
        ];
    }
    

}