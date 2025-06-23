@isTest
public with sharing class ClaimBatchLineDataHelper {

    // Create a ClaimBatchLine with required lookups set
    public static dmpl__ClaimBatchLine__c createClaimBatchLine(dmpl__Claim__c claim, dmpl__ClaimBatch__c claimBatch) {
        dmpl__ClaimBatchLine__c batchLine = (dmpl__ClaimBatchLine__c) TestFactory.createSObject(
            new dmpl__ClaimBatchLine__c(
                dmpl__ClaimId__c = claim.Id,
                dmpl__ClaimBatchId__c = claimBatch.Id
            ),
            'ClaimBatchLineDefaults',
            true
        );
        return batchLine;
    }

    public static dmpl__ClaimBatchLine__c getClaimBatchLine() {
        return [
            SELECT Id, Name, dmpl__ClaimId__c, dmpl__ClaimBatchId__c
            FROM dmpl__ClaimBatchLine__c
            LIMIT 1
        ];
    }

    public static dmpl__ClaimBatchLine__c getClaimBatchLineRecord(Id recordId) {
        return [
            SELECT Id, Name, dmpl__ClaimId__c, dmpl__ClaimBatchId__c
            FROM dmpl__ClaimBatchLine__c
            WHERE Id = :recordId
            LIMIT 1
        ];
    }

    public static Boolean existsClaimBatchLine(Id recordId) {
        return [SELECT COUNT() FROM dmpl__ClaimBatchLine__c WHERE Id = :recordId] > 0;
    }
}