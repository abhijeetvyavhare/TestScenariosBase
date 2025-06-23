@isTest
public with sharing class ClaimBatchHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Account partnerAccount = TestDataHelpers.createPartnerAccount();
        dmpl__Branch__c branch = TestDataHelpers.createBranch(partnerAccount);
        dmpl__ClaimBatch__c claimBatch = ClaimBatchDataHelper.createClaimBatch(partnerAccount, branch.Id);
        dmpl__Claim__c claim = ClaimBatchDataHelper.createClaim();
        dmpl__ClaimBatchLine__c claimBatchLine = ClaimBatchDataHelper.createClaimBatchLine(claimBatch, claim.Id);
    }

    @isTest
    static void createClaimBatchPositive() {
        dmpl__ClaimBatch__c claimBatch = ClaimBatchDataHelper.getClaimBatch();
        System.assertNotEquals(claimBatch, null, 'Expected claim batch to be created.');
        System.assertEquals('Draft', claimBatch.dmpl__Status__c, 'Status should be Draft');
        System.assertNotEquals(null, claimBatch.dmpl__PartnerAccountId__c, 'Partner Account ID should not be null');
        System.assertNotEquals(null, claimBatch.dmpl__BranchId__c, 'Branch ID should not be null');
    }

    @isTest
    static void createClaimBatchLinePositive() {
        dmpl__ClaimBatchLine__c batchLine = ClaimBatchDataHelper.getClaimBatchLine();        
        System.assertNotEquals(batchLine, null, 'Expected claim batch line to be created');
        System.assertNotEquals(null, batchLine.dmpl__ClaimBatchId__c, 'Claim Batch ID should not be null');
        System.assertNotEquals(null, batchLine.dmpl__ClaimId__c, 'Claim ID should not be null');
    }

    @isTest
    static void updateClaimBatchPositive() {
        dmpl__ClaimBatch__c batch = ClaimBatchDataHelper.getClaimBatch();
        
        Test.startTest();
        batch.dmpl__Status__c = 'Invoice';
        batch.dmpl__Remarks__c = 'Test Remarks';
        update batch;
        Test.stopTest();

        dmpl__ClaimBatch__c updatedBatch = ClaimBatchDataHelper.getClaimBatch(batch.Id);
        System.assertEquals('Invoice', updatedBatch.dmpl__Status__c, 'Status should be updated to Draft');
        System.assertEquals('Test Remarks', updatedBatch.dmpl__Remarks__c, 'Remarks should be updated to Test Remarks');
    }

    @isTest
    static void updateClaimBatchLinePositive() {
        dmpl__ClaimBatchLine__c batchLine = ClaimBatchDataHelper.getClaimBatchLine();
        Account partnerAccount = TestDataHelpers.getPartnerAccount();
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
        dmpl__Claim__c newClaim = ClaimBatchDataHelper.createClaim();
        
        Test.startTest();
        batchLine.dmpl__ClaimId__c = newClaim.Id;
        update batchLine;
        Test.stopTest();

        dmpl__ClaimBatchLine__c updatedBatchLine = ClaimBatchDataHelper.getClaimBatchLine(batchLine.Id);
        System.assertEquals(newClaim.Id, updatedBatchLine.dmpl__ClaimId__c, 'Claim ID should be updated');
    }

    @isTest
    static void deleteClaimBatchPositive() {
        dmpl__ClaimBatch__c batch = ClaimBatchDataHelper.getClaimBatch();
        
        Test.startTest();
        delete batch;
        Test.stopTest();

        dmpl__ClaimBatch__c deletedBatch;
        try {
            deletedBatch = ClaimBatchDataHelper.getClaimBatch(batch.Id);
        } catch (QueryException e) {
            deletedBatch = null; 
        }
        System.assertEquals(null, deletedBatch, 'Claim Batch should be deleted');
    }

    @isTest
    static void deleteClaimBatchLinePositive() {
        dmpl__ClaimBatchLine__c batchLine = ClaimBatchDataHelper.getClaimBatchLine();
        
        Test.startTest();
        delete batchLine;
        Test.stopTest();

        dmpl__ClaimBatchLine__c deletedBatchLine;
        try {
            deletedBatchLine = ClaimBatchDataHelper.getClaimBatchLine(batchLine.Id);
        } catch (QueryException e) {
            deletedBatchLine = null;
        }
        System.assertEquals(null, deletedBatchLine, 'Claim Batch Line should be deleted');
    }
}