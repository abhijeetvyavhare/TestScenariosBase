public with sharing class ClaimDataHelper {
    public static dmpl__Claim__c createClaim(Id partnerAccountId){
        return (dmpl__Claim__c) TestFactory.createSObject(
            new dmpl__Claim__c(
                dmpl__Status__c = 'Draft',
                dmpl__DocumentDate__c = Date.today(),
                dmpl__ClaimType__c = 'Damaged',
                dmpl__InvoiceGroup__c = 'Service',
                dmpl__Remarks__c = 'Test Claim',
                dmpl__ApproveAll__c = true,
                dmpl__RejectAll__c = false,
                dmpl__AsOnDate__c = Date.today(),
                dmpl__ServiceInvoiceAsOnDate__c = Date.today(),
                dmpl__WorkOrderAsonDate__c = Date.today().addDays(-5),
                dmpl__PartnerAccountId__c = partnerAccountId
            ),
            'ClaimDefaults',
            true
        );
    }
    
    public static dmpl__Claim__c getClaims(){
        return [
            SELECT Id, Name, dmpl__ExternalId__c, dmpl__Status__c, dmpl__DocumentDate__c, 
                   dmpl__ClaimType__c, dmpl__InvoiceGroup__c, dmpl__Remarks__c, dmpl__ApproveAll__c,
                   dmpl__RejectAll__c, dmpl__AsOnDate__c, dmpl__ServiceInvoiceAsOnDate__c,
                   dmpl__WorkOrderAsonDate__c
            FROM dmpl__Claim__c
            LIMIT 1
        ];
    }

    public static dmpl__Claim__c getClaims(Id claimId) {
        return [
            SELECT Id, Name, dmpl__ExternalId__c, dmpl__Status__c, dmpl__DocumentDate__c, 
                   dmpl__ClaimType__c, dmpl__InvoiceGroup__c, dmpl__Remarks__c, dmpl__ApproveAll__c,
                   dmpl__RejectAll__c, dmpl__AsOnDate__c, dmpl__ServiceInvoiceAsOnDate__c,
                   dmpl__WorkOrderAsonDate__c
            FROM dmpl__Claim__c
            WHERE Id = :claimId
            LIMIT 1
        ];
    }

    public static dmpl__ClaimLine__c createClaimLine(
        Id claimId
    ){
        return (dmpl__ClaimLine__c) TestFactory.createSObject(
            new dmpl__ClaimLine__c(
                dmpl__ClaimId__c = claimId,
                dmpl__ClaimType__c = 'Part To Part',
                dmpl__Status__c = 'Approved',
                dmpl__UnitPrice2__c = 1000,
                dmpl__UnitPrice__c = 900
            ),
            'ClaimLineDefaults',
            true
        );
    }

    public static dmpl__ClaimLine__c getClaimLines() {
        return [
            SELECT Id, Name, dmpl__ExternalId__c, dmpl__Status__c, dmpl__ClaimType__c,
                   dmpl__ItemCode__c, dmpl__UnitPrice2__c, dmpl__UnitPrice__c,
                   dmpl__ApproveAmount__c, dmpl__ApproveBaseAmount__c, dmpl__ApproveDiscount__c,
                   dmpl__ApproveDiscountAmount__c, dmpl__ApproveNetDiscount__c, dmpl__ApproveQuantity__c,
                   dmpl__BaseAmount__c, dmpl__ClaimAmount__c, dmpl__ClaimQuantity__c,
                   dmpl__Discount__c, dmpl__DiscountAmount__c, dmpl__NetDiscount__c
            FROM dmpl__ClaimLine__c
            LIMIT 1
        ];
    }

    public static dmpl__ClaimLine__c getClaimLines(Id claimLineId) {
        return [
            SELECT Id, Name, dmpl__ExternalId__c, dmpl__Status__c, dmpl__ClaimType__c,
                   dmpl__ItemCode__c, dmpl__UnitPrice2__c, dmpl__UnitPrice__c,
                   dmpl__ApproveAmount__c, dmpl__ApproveBaseAmount__c, dmpl__ApproveDiscount__c,
                   dmpl__ApproveDiscountAmount__c, dmpl__ApproveNetDiscount__c, dmpl__ApproveQuantity__c,
                   dmpl__BaseAmount__c, dmpl__ClaimAmount__c, dmpl__ClaimQuantity__c,
                   dmpl__Discount__c, dmpl__DiscountAmount__c, dmpl__NetDiscount__c
            FROM dmpl__ClaimLine__c
            WHERE Id = :claimLineId
            LIMIT 1
        ];
    }
}