public with sharing class ClaimLineDataHelper {
    public static dmpl__ClaimLine__c createClaimLine(dmpl__Claim__c claim, dmpl__Item__c item) {
        return (dmpl__ClaimLine__c) TestFactory.createSObject(
            new dmpl__ClaimLine__c(
                dmpl__ClaimId__c = claim.Id,
                dmpl__ItemId__c = item.Id
            ),
            'ClaimLineDefaults',
            true
        );
    }

    public static dmpl__ClaimLine__c getClaimLine() {
        return [
            SELECT Id, Name, dmpl__ExternalId__c, dmpl__ClaimId__c, dmpl__ItemId__c,
                   dmpl__ClaimQuantity__c, dmpl__ApproveQuantity__c, dmpl__Status__c
            FROM dmpl__ClaimLine__c
            LIMIT 1
        ];
    }

    public static dmpl__ClaimLine__c getClaimLineRecord(Id claimLineId) {
        return [
            SELECT Name, dmpl__ExternalId__c, dmpl__Status__c
            FROM dmpl__ClaimLine__c
            WHERE Id = :claimLineId
            LIMIT 1
        ];
    }

    public static Boolean existsClaimLine(Id claimLineId) {
        return [SELECT COUNT() FROM dmpl__ClaimLine__c WHERE Id = :claimLineId] > 0;
    }
}