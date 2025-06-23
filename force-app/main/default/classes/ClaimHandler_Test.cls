@isTest 
public with sharing class ClaimHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Account partnerAccount = TestDataHelpers.createPartnerAccount();
        dmpl__Claim__c claim = ClaimDataHelper.createClaim(partnerAccount.Id);
        dmpl__ClaimLine__c claimLine = ClaimDataHelper.createClaimLine(claim.Id);
    }

    @isTest
    static void createClaimPositive() {
        dmpl__Claim__c claim = ClaimDataHelper.getClaims();
        System.assertNotEquals(null, claim.Id, 'Claim should be inserted');
        System.assertEquals('Draft', claim.dmpl__Status__c, 'Status should be Draft');
        System.assertEquals(Date.today(), claim.dmpl__DocumentDate__c, 'Document date should match today');
    }

    @isTest
    static void createClaimLinePositive() {
        dmpl__ClaimLine__c line = ClaimDataHelper.getClaimLines();
        System.assertNotEquals(null, line.Id, 'Claim Line should be created');
        System.assertEquals('Approved', line.dmpl__Status__c, 'Status should be Draft');
        System.assertEquals(2, line.dmpl__ClaimQuantity__c, 'Claim Quantity should be 2');
    }
    
    @isTest
    static void updateClaimPositive() {
        dmpl__Claim__c claim = ClaimDataHelper.getClaims();
        
        Test.startTest();
        claim.dmpl__Status__c = 'Reconcile';
        claim.dmpl__DocumentDate__c = Date.today().addDays(5);
        update claim;
        Test.stopTest();

        dmpl__Claim__c updated = ClaimDataHelper.getClaims(claim.Id);
        System.assertEquals('Reconcile', updated.dmpl__Status__c, 'Status should be updated to Draft');
        System.assertEquals(Date.today().addDays(5), updated.dmpl__DocumentDate__c, 'Document date should be updated');
    }

    @isTest
    static void updateClaimLinePositive() {
        dmpl__ClaimLine__c line = ClaimDataHelper.getClaimLines();
        
        Test.startTest();
        line.dmpl__Status__c = 'Rejected';
        line.dmpl__ClaimQuantity__c = 5;
        line.dmpl__UnitPrice__c = 1000;
        update line;
        Test.stopTest();

        dmpl__ClaimLine__c updated = ClaimDataHelper.getClaimLines(line.Id);
        System.assertEquals('Rejected', updated.dmpl__Status__c, 'Status should be updated to Draft');
        System.assertEquals(5, updated.dmpl__ClaimQuantity__c, 'Claim Quantity should be updated to 5');
        System.assertEquals(1000, updated.dmpl__UnitPrice__c, 'Unit Price should be updated');
    }

    @isTest 
    static void deleteClaimLinePositive() {
        dmpl__ClaimLine__c line = ClaimDataHelper.getClaimLines();
        
        Test.startTest();
        delete line;
        Test.stopTest();

        dmpl__ClaimLine__c deletedLine;
        try {
            deletedLine = ClaimDataHelper.getClaimLines(line.Id);
        } catch (QueryException e) {
            deletedLine = null;
        }
        System.assertEquals(null, deletedLine, 'Claim Line should be deleted');
    }

    @isTest
    static void deleteClaimPositive() {
        dmpl__Claim__c claim = ClaimDataHelper.getClaims();
        
        Test.startTest();
        delete claim;
        Test.stopTest();

        dmpl__Claim__c deletedClaim;
        try {
            deletedClaim = ClaimDataHelper.getClaims(claim.Id);
        } catch (QueryException e) {
            deletedClaim = null;
        }
        System.assertEquals(null, deletedClaim, 'Claim should be deleted');
    }
}