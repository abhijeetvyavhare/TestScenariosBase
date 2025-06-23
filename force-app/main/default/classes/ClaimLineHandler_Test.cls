@isTest
public with sharing class ClaimLineHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Account partnerAccount = TestDataHelpers.createPartnerAccount();
        dmpl__Claim__c claim = ClaimDataHelper.createClaim(partnerAccount);
        dmpl__Item__c item = TestDataHelpers.createItem();
        ClaimLineDataHelper.createClaimLine(claim, item);
    }

    @isTest
    static void testInsertClaimLine() {
        dmpl__ClaimLine__c claimLine = ClaimLineDataHelper.getClaimLine();
        System.assert(claimLine != null, 'Claim Line should be retrieved');
        System.assert(claimLine.Id != null, 'Claim Line should be inserted');
    }

    @isTest
    static void testUpdateClaimLine() {
        dmpl__ClaimLine__c claimLine = ClaimLineDataHelper.getClaimLine();
        claimLine.dmpl__Status__c = 'Approved';
        claimLine.dmpl__ExternalId__c = 'CLAIMLINE-UPDATED-001';
        update claimLine;

        dmpl__ClaimLine__c updated = ClaimLineDataHelper.getClaimLineRecord(claimLine.Id);
        System.assertEquals('Approved', updated.dmpl__Status__c);
        System.assertEquals('CLAIMLINE-UPDATED-001', updated.dmpl__ExternalId__c);
    }

    @isTest
    static void testDeleteClaimLine() {
        dmpl__ClaimLine__c claimLine = ClaimLineDataHelper.getClaimLine();
        delete claimLine;
        Boolean exists = ClaimLineDataHelper.existsClaimLine(claimLine.Id);
        System.assertEquals(false, exists, 'Claim Line should be deleted');
    }
}