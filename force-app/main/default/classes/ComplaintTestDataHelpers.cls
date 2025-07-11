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
    

    //New Methods
    public static dmpl__Complaint__c createComplaint(String name, String code, String description) {
        return (dmpl__Complaint__c) TestFactory.createSObject(
            new dmpl__Complaint__c(
                Name = name,
                dmpl__Code__c = code, 
                dmpl__Description__c = description
            ),
            //'ComplaintDefaults',
            true
        );
    }
        
    public static dmpl__Complaint__c getComplaint(String name, String code) {
        return [
            SELECT Id, Name, dmpl__Code__c, dmpl__Description__c
            FROM dmpl__Complaint__c
            WHERE Name = :name AND dmpl__Code__c = :code
            LIMIT 1
        ];
    }
	
    public static dmpl__ComplaintFault__c createComplaintFault(
        String name,
        dmpl__Complaint__c complaint,
        String faultCode,
        dmpl__Item__c item,
        dmpl__ItemGroup__c itemGroup,
        String description
    ) {
        return (dmpl__ComplaintFault__c) TestFactory.createSObject(
            new dmpl__ComplaintFault__c(
                Name = name,
                dmpl__ComplaintId__c = complaint != null ? complaint.Id : null,
                dmpl__FaultCode__c = faultCode,
                dmpl__ApplicableToItemId__c = item != null ? item.Id : null,
                dmpl__ApplicableToItemGroupId__c = itemGroup != null ? itemGroup.Id : null,
                dmpl__Description__c = description
            ),
            //'ComplaintFaultDefaults',
            true
        );
    }
    
    public static dmpl__ComplaintFault__c getComplaintFault(String name) {
        return [
            SELECT Id, Name, dmpl__ApplicableToItemId__c, dmpl__ComplaintId__c
            FROM dmpl__ComplaintFault__c
            WHERE Name = :name
            LIMIT 1
        ];
    }

    public static dmpl__ComplaintItem__c createComplaintItem(
        dmpl__Item__c item,
        dmpl__Complaint__c complaint,
        dmpl__ComplaintFault__c fault,
        Decimal quantity,
        Boolean isMandatory
    ) {
        return (dmpl__ComplaintItem__c) TestFactory.createSObject(
            new dmpl__ComplaintItem__c(
                dmpl__ItemId__c = item != null ? item.Id : null,
                dmpl__ComplaintId__c = complaint != null ? complaint.Id : null,
                dmpl__ComplaintFaultCodeId__c = fault != null ? fault.Id : null,
                dmpl__Quantity__c = quantity,
                dmpl__IsMandatory__c = isMandatory
            ),
            //'ComplaintItemDefaults',
            true
        );
    }
    
    public static dmpl__ComplaintItem__c getComplaintItem(Id complaintId) {
        return [
            SELECT Id, Name, dmpl__ItemId__c, dmpl__ComplaintId__c, dmpl__ComplaintFaultCodeId__c
            FROM dmpl__ComplaintItem__c
            WHERE dmpl__ComplaintId__c = :complaintId
            LIMIT 1
        ];
    }
    
    public static dmpl__ComplaintLine__c createComplaintLine(
        dmpl__Complaint__c complaint,
        dmpl__ComplaintFault__c fault,
        dmpl__RepairOrder__c repairOrder,
        dmpl__Quote__c serviceEstimate,
        dmpl__ServiceRequest__c serviceRequest
    ) {
        return (dmpl__ComplaintLine__c) TestFactory.createSObject(
            new dmpl__ComplaintLine__c(
                dmpl__ComplaintId__c = complaint != null ? complaint.Id : null,
                dmpl__ComplaintFaultCodeId__c = fault != null ? fault.Id : null,
                dmpl__RepairOrderId__c = repairOrder != null ? repairOrder.Id : null,
                dmpl__ServiceEstimateId__c = serviceEstimate != null ? serviceEstimate.Id : null,
                dmpl__ServiceRequestId__c = serviceRequest != null ? serviceRequest.Id : null
            ),
            //'ComplaintLineDefaults',
            true
        );
    }
    
    public static dmpl__ComplaintLine__c getComplaintLine(Id complaintId) {
        return [
            SELECT Id, Name, dmpl__ComplaintId__c, dmpl__ComplaintFaultCodeId__c
            FROM dmpl__ComplaintLine__c
            WHERE dmpl__ComplaintId__c = :complaintId
            LIMIT 1
        ];
    }

    public static dmpl__RepairOrder__c createRepairOrder(
        dmpl__Item__c item,
        dmpl__branch__c branch,
        //Asset asset,
        //dmpl__QuoteLine__c quoteLine,
        //dmpl__Quote__c serviceEstimate,
        Account customerAccount
       ) {
       
        return (dmpl__RepairOrder__c) TestFactory.createSObject(
            new dmpl__RepairOrder__c (
            dmpl__BranchId__c = branch.Id,
            dmpl__AccountId__c = customerAccount.Id,
            dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c
            //dmpl__ServiceEstimateId__c = serviceEstimate.Id,
            //dmpl__UsageReading__c = 65.00,
            //dmpl__ServiceContractItemId__c=quoteLine.dmpl__ServiceContractId__c,
            //dmpl__ResetUsageReading__c = false,
            //dmpl__ResetUsageHours__c = false
        ),
            //'RepairOrderDefaults',
            true
        );
    }
 
    public static List<dmpl__RepairOrder__c> getRepairOrder(Id repairOrderId) {
        return [SELECT
            Id,
            Name,
            dmpl__BranchId__c,
            dmpl__AccountId__c,
            dmpl__PartnerAccountId__c,
            dmpl__AssetId__c,
            dmpl__ServiceEstimateId__c,
            dmpl__ServiceAdvisorId__c,
            dmpl__UsageReading__c,
            dmpl__AccountName__c,
            dmpl__PriceListId__c,
            dmpl__PriceListId__r.Name,
            dmpl__TaxGroupId__c,
            dmpl__TaxGroupId__r.Name,
            dmpl__TaxSupplyType__c,
            dmpl__Status__c,
            dmpl__DocumentDate__c,
            dmpl__BillingAddress__c,
            dmpl__BillingStreet__c,
            dmpl__BillingCity__c,
            dmpl__BillingState__c,
            dmpl__BillingCountry__c,
            dmpl__BillingPostalCode__c,
            dmpl__ShippingAddress__c,
            dmpl__ShippingStreet__c,
            dmpl__ShippingCity__c,
            dmpl__ShippingState__c,
            dmpl__ShippingPostalCode__c,
            dmpl__ShippingCountry__c
        FROM dmpl__RepairOrder__c
        WHERE Id = :repairOrderId
        LIMIT 1
        ];
    }

    public static dmpl__Quote__c createQuote(Account customer, dmpl__Branch__c branch) {
        return (dmpl__Quote__c) TestFactory.createSObject(
            new dmpl__Quote__c(
                dmpl__AccountId__c = customer != null ? customer.Id : null,
                dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                dmpl__BranchId__c = branch.Id, 
                dmpl__DocumentDate__c = Date.today()
            ),
            'QuoteDefaults',
            true
        );
    }

    public static dmpl__QuoteLine__c createQuoteLine(dmpl__Quote__c quote, dmpl__Item__c item) {
        return (dmpl__QuoteLine__c) TestFactory.createSObject(
            new dmpl__QuoteLine__c(
                dmpl__QuoteId__c = quote != null ? quote.Id : null,
                dmpl__ItemId__c = item != null ? item.Id : null,
                dmpl__Quantity__c = 1,
                dmpl__UnitPrice__c = 100
            ),
            'QuoteLineDefaults',
            true
        );
    }


    public static dmpl__Quote__c getQuote(String name) {
        return [
            SELECT Id, Name, dmpl__AccountId__c, dmpl__DocumentDate__c
            FROM dmpl__Quote__c
            WHERE Name = :name
            LIMIT 1
        ];
    }


    public static dmpl__QuoteLine__c getQuoteLine(String name) {
        return [
            SELECT Id, Name, dmpl__QuoteId__c, dmpl__ItemId__c, dmpl__Quantity__c, dmpl__UnitPrice__c
            FROM dmpl__QuoteLine__c
            WHERE Name = :name
            LIMIT 1
        ];
    }

    public static Asset createAsset(
        String name,
        Account account,
        dmpl__Item__c item
    ){
        return (Asset) TestFactory.createSObject(
            new Asset(
                Name = name,
                AccountId = account.Id,
                dmpl__ItemId__c = item.Id,
                dmpl__SaleDate__c =  Date.today()
            ),
            true
        );
    }

    public static Asset getAsset(String name){ 
        return [
            SELECT Id, name, AccountId, dmpl__ItemId__c, dmpl__SaleDate__c 
				FROM Asset 
				WHERE name = :name LIMIT 1
        ];
    }

    public static dmpl__Resource__c createResource(
        String name,
        Id defaultPartnerAccountId,
        Id defaultBranchId,
        Boolean isActive
    ) {
        return (dmpl__Resource__c) TestFactory.createSObject(
            new dmpl__Resource__c(
                Name = name,
                dmpl__DefaultPartnerAccountId__c = defaultPartnerAccountId,
                dmpl__DefaultBranchId__c = defaultBranchId,
                dmpl__IsActive__c = isActive
            ),
            'ResourceDefaults',
            true
        );
    }
 
    public static dmpl__Resource__c getResource(String name) {
        return [
            SELECT
            Id,
            Name,
            dmpl__DefaultPartnerAccountId__c,
            dmpl__DefaultBranchId__c,
            dmpl__IsActive__c
            FROM dmpl__Resource__c
            WHERE Name = :name
            LIMIT 1
        ];
    }
}