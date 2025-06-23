@isTest
public with sharing class ClaimReconciliationDataHelper {

    public static dmpl__ClaimReconciliation__c createClaimReconciliation(
        Id branchId,
        Id partnerAccountId
    ){
        return (dmpl__ClaimReconciliation__c) TestFactory.createSObject(
            new dmpl__ClaimReconciliation__c(
                dmpl__BranchId__c = branchId,
                dmpl__PartnerAccountId__c = partnerAccountId,
                dmpl__Status__c = 'Draft',
                dmpl__DocumentDate__c = Date.today()
            ),
            'ClaimReconciliationDefaults',
            true
        );
    }

    public static dmpl__ClaimReconciliationLine__c createClaimReconciliationLine(
        Id reconciliationId,
        Id claimId,
        Id claimLineId
    ){
        dmpl__ClaimReconciliationLine__c line = (dmpl__ClaimReconciliationLine__c) TestFactory.createSObject(
            new dmpl__ClaimReconciliationLine__c(
                dmpl__ReconciliationId__c = reconciliationId,
                dmpl__ClaimId__c = claimId,
                dmpl__ClaimLineId__c = claimLineId,
                dmpl__Status__c = 'Pending',
                dmpl__RejectQuantity__c = 2,
                dmpl__Remarks__c = 'Test Reconciliation Line'
            ),
            'ClaimReconciliationLineDefaults',
            true
        );
        return line;
    }

    public static dmpl__ClaimReconciliation__c getClaimReconciliations() {
        return [
            SELECT Id, Name, dmpl__BranchId__c, dmpl__Status__c, dmpl__DocumentDate__c, dmpl__PartnerAccountId__c
            FROM dmpl__ClaimReconciliation__c
            LIMIT 1
        ];
    }

    public static dmpl__ClaimReconciliation__c getClaimReconciliations(Id claimReconciliationId) {
        return [
            SELECT Id, Name, dmpl__BranchId__c, dmpl__Status__c, dmpl__DocumentDate__c, dmpl__PartnerAccountId__c
            FROM dmpl__ClaimReconciliation__c
            WHERE Id = :claimReconciliationId
            LIMIT 1
        ];
    }

    public static List<dmpl__ClaimReconciliationLine__c> getClaimReconciliationLines() {
        return [
            SELECT Id, Name, dmpl__ReconciliationId__c, dmpl__ClaimId__c, dmpl__ClaimLineId__c,
                   dmpl__ClaimAmount__c, dmpl__ClaimQuantity__c, dmpl__UnitPrice__c,
                   dmpl__Status__c, dmpl__RejectQuantity__c, dmpl__Remarks__c
            FROM dmpl__ClaimReconciliationLine__c
        ];
    }

    public static dmpl__ClaimReconciliationLine__c getClaimReconciliationLines(Id reconciliationLineId) {
        return [
            SELECT Id, Name, dmpl__ReconciliationId__c, dmpl__ClaimId__c, dmpl__ClaimLineId__c,
                   dmpl__ItemId__c, dmpl__ClaimAmount__c, dmpl__ClaimQuantity__c, dmpl__UnitPrice__c,
                   dmpl__Status__c, dmpl__ApprovedAmount__c, dmpl__ApproveQuantity__c,
                   dmpl__RejectedAmount__c, dmpl__RejectQuantity__c, dmpl__Remarks__c
            FROM dmpl__ClaimReconciliationLine__c
            WHERE Id = :reconciliationLineId
            LIMIT 1
        ];
    }
}