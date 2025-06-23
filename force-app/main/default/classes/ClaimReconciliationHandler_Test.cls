@isTest
public with sharing class ClaimReconciliationHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Account partnerAccount = TestDataHelpers.createPartnerAccount();
        dmpl__Branch__c branch = TestDataHelpers.createBranch(partnerAccount);    
        dmpl__Claim__c claim = ClaimDataHelper.createClaim(partnerAccount.Id);
        dmpl__ClaimLine__c claimLine = ClaimDataHelper.createClaimLine(claim.Id);
        dmpl__ClaimReconciliation__c reconciliation = ClaimReconciliationDataHelper.createClaimReconciliation(branch.Id, partnerAccount.Id);
        dmpl__ClaimReconciliationLine__c  line = ClaimReconciliationDataHelper.createClaimReconciliationLine(reconciliation.Id, claim.Id, claimLine.Id);
    }

    @isTest
    static void createClaimReconciliationPositive() {
        dmpl__ClaimReconciliation__c reconciliation = ClaimReconciliationDataHelper.getClaimReconciliations();
        System.assertNotEquals(null, reconciliation.Id, 'Claim Reconciliation should be inserted');
        System.assertEquals('Draft', reconciliation.dmpl__Status__c, 'Status should be Draft');
        System.assertEquals(Date.today(), reconciliation.dmpl__DocumentDate__c, 'Document date should match today');
    }

    @isTest
    static void createClaimReconciliationLinePositive() {
        dmpl__ClaimReconciliationLine__c line = ClaimReconciliationDataHelper.getClaimReconciliationLines()[0];
        System.assertNotEquals(null, line.Id, 'Claim Reconciliation Line should be created');
        System.assertEquals('Pending', line.dmpl__Status__c, 'Status should be Draft');
        System.assertEquals(2, line.dmpl__RejectQuantity__c, 'Reject Quantity should be 2');
    }

    @isTest
    static void updateClaimReconciliationLinePositive() {
        dmpl__ClaimReconciliationLine__c line = ClaimReconciliationDataHelper.getClaimReconciliationLines()[0];
        
        Test.startTest();
        line.dmpl__Status__c = 'Approved';
        line.dmpl__RejectQuantity__c = 5;
        line.dmpl__Remarks__c = 'Updated Test Remarks';
        update line;
        Test.stopTest();

        dmpl__ClaimReconciliationLine__c updated = ClaimReconciliationDataHelper.getClaimReconciliationLines(line.Id);
        System.assertEquals('Approved', updated.dmpl__Status__c, 'Status should be updated to Draft');
        System.assertEquals(5, updated.dmpl__RejectQuantity__c, 'Reject Quantity should be updated to 5');
        System.assertEquals('Updated Test Remarks', updated.dmpl__Remarks__c, 'Remarks should be updated');
    }

    @isTest
    static void updateClaimReconciliationPositive() {
        dmpl__ClaimReconciliation__c reconciliation = ClaimReconciliationDataHelper.getClaimReconciliations();
        reconciliation.dmpl__Status__c = 'Draft';
        reconciliation.dmpl__DocumentDate__c = Date.today().addDays(5);
        update reconciliation;
        dmpl__ClaimReconciliation__c updated = ClaimReconciliationDataHelper.getClaimReconciliations(reconciliation.Id);
        System.assertEquals('Draft', updated.dmpl__Status__c, 'Status should be updated to Draft');
        System.assertEquals(Date.today().addDays(5), updated.dmpl__DocumentDate__c, 'Document date should be updated');
    }

    @isTest
    static void deleteClaimReconciliationLinePositive() {
        dmpl__ClaimReconciliationLine__c line = ClaimReconciliationDataHelper.getClaimReconciliationLines()[0];
        
        Test.startTest();
        delete line;
        Test.stopTest();

        dmpl__ClaimReconciliationLine__c deletedLine;
        try {
            deletedLine = ClaimReconciliationDataHelper.getClaimReconciliationLines(line.Id);
        } catch (QueryException e) {
            deletedLine = null;
        }
        System.assertEquals(null, deletedLine, 'Claim Reconciliation Line should be deleted');
    }

    @isTest
    static void deleteClaimReconciliationPositive() {
        dmpl__ClaimReconciliation__c reconciliation = ClaimReconciliationDataHelper.getClaimReconciliations();
        
        Test.startTest();
        delete reconciliation;
        Test.stopTest();

        dmpl__ClaimReconciliation__c deletedReconciliation;
        try {
            deletedReconciliation = ClaimReconciliationDataHelper.getClaimReconciliations(reconciliation.Id);
        } catch (QueryException e) {
            deletedReconciliation = null;
        }
        System.assertEquals(null, deletedReconciliation, 'Claim Reconciliation should be deleted');
    }
}