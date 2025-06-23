public with sharing class ClaimBatchDataHelper {
    public static dmpl__ClaimBatch__c createClaimBatch(
        Account partnerAccount,
        Id branchId
    ) {
        return (dmpl__ClaimBatch__c) TestFactory.createSObject(
            new dmpl__ClaimBatch__c(
                dmpl__PartnerAccountId__c = partnerAccount.Id,
                dmpl__BranchId__c = branchId,
                dmpl__DocumentDate__c = Date.today(),
                dmpl__Remarks__c = 'Default Remarks'
            ),
            'ClaimBatchDefaults',
            true
        );
    }

    public static dmpl__Claim__c createClaim() {
        return (dmpl__Claim__c) TestFactory.createSObject(
            new dmpl__Claim__c(),
            'ClaimDefaults',
            true
        );
    }

    public static dmpl__ClaimBatchLine__c createClaimBatchLine(dmpl__ClaimBatch__c claimBatch, Id claimId) {
        return (dmpl__ClaimBatchLine__c) TestFactory.createSObject(
            new dmpl__ClaimBatchLine__c(
                dmpl__ClaimBatchId__c = claimBatch.Id,
                dmpl__ClaimId__c = claimId
            ),
            'ClaimBatchLineDefaults',
            true
        );
    }

    public static dmpl__ClaimBatchLine__c getClaimBatchLine() {
        return [
            SELECT Id, Name, dmpl__ClaimBatchId__c, dmpl__ClaimId__c
            FROM dmpl__ClaimBatchLine__c 
            LIMIT 1
        ];
    }

    public static dmpl__ClaimBatchLine__c getClaimBatchLine(Id batchLineId) {
        return [
            SELECT Id, Name, dmpl__ClaimBatchId__c, dmpl__ClaimId__c
            FROM dmpl__ClaimBatchLine__c
            WHERE Id = :batchLineId
            LIMIT 1
        ];
    }

    public static dmpl__ClaimBatch__c getClaimBatch() {
        return [
            SELECT Id, Name, dmpl__Status__c, dmpl__PartnerAccountId__c, dmpl__BranchId__c, dmpl__Remarks__c
            FROM dmpl__ClaimBatch__c
            LIMIT 1
        ];
    }

    public static dmpl__ClaimBatch__c getClaimBatch(Id batchId) {
        return [
            SELECT Id, Name, dmpl__ExternalId__c, dmpl__Status__c, dmpl__Remarks__c
            FROM dmpl__ClaimBatch__c
            WHERE Id = :batchId
            LIMIT 1
        ];
    }
}