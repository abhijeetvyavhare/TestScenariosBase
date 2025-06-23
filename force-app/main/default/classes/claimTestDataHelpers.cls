public with sharing class claimTestDataHelpers {
    public static dmpl__Claim__c createClaim(Account supplierAccount,dmpl__Branch__c branch) {
        
        return (dmpl__Claim__c) TestFactory.createSObject(
            new dmpl__Claim__c(dmpl__BranchId__c = branch.Id,
                                     dmpl__ClaimType__c='Service',
                                     dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                     dmpl__DocumentDate__c = date.today(),
                                     dmpl__SupplierNameId__c = supplierAccount.Id,
                                     dmpl__AsonDate__c = date.today(), 
                                     dmpl__ApproveAll__c = true
                                    ),
            'ClaimDefaults',
            true
        );
    }

  
    public static dmpl__Claim__c getClaim() {
        return [
            SELECT Id, Name
            FROM dmpl__Claim__c
            LIMIT 1
        ];
    }

    public static dmpl__ClaimBatch__c createClaimBatch(Account partnerAccount,Account supplierAccount,dmpl__Branch__c branch){
        return (dmpl__ClaimBatch__c) TestFactory.createSObject(
            new dmpl__ClaimBatch__c(dmpl__BranchId__c = branch.Id,
            dmpl__PartnerAccountId__c = partnerAccount.Id,
            dmpl__DocumentDate__c = date.today(),
            dmpl__SupplierNameId__c = supplierAccount.Id
           ),
            'ClaimBatchDefaults',
            true
        );
    }
    public static dmpl__ClaimBatch__c getClaimBatch() {
        return [
            SELECT Id, Name
            FROM dmpl__ClaimBatch__c
            LIMIT 1
        ];
    }

    public static dmpl__ClaimLine__c createClaimLine(Account partnerAccount,Account supplierAccount,dmpl__Branch__c branch,dmpl__ClaimBatch__c claimBatch, dmpl__Claim__c claim,dmpl__Item__c item){
        return (dmpl__ClaimLine__c) TestFactory.createSObject(
            new dmpl__ClaimLine__c(dmpl__BranchId__c = branch.Id,
            dmpl__ClaimId__c = claim.Id,
            dmpl__ItemCode__c = 'bxfs543',
            dmpl__PartnerAccountId__c = partnerAccount.Id,
            dmpl__ItemId__c = item.Id,
            dmpl__ClaimQuantity__c = 2,
            dmpl__UnitPrice__c =100,
            dmpl__ApproveQuantity__c = 10,
            dmpl__RejectQuantity__c = 2,
            dmpl__ClaimBatchId__c = claimBatch.Id
           ),
            'ClaimLineDefaults',
            true
        );
    }
    public static dmpl__ClaimLine__c getClaimLine() {
        return [
            SELECT Id, Name
            FROM dmpl__ClaimLine__c
            LIMIT 1
        ];
    }

    public static dmpl__ClaimReconciliation__c CreateReconciliation(dmpl__Branch__c branch,Account supplierAccount){
        return (dmpl__ClaimReconciliation__c)TestFactory.createSObject(
            new dmpl__ClaimReconciliation__c(
                dmpl__BranchId__c = branch.Id,
                dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                dmpl__SupplierId__c = supplierAccount.Id,
                dmpl__CreditNoteAmount__c = 100
            ),
            // 'claimReconcilationDefaults',
            true
        );
    }

    public static dmpl__ClaimReconciliation__c getReconciliation(){
        return [SELECT 
        Id,
        Name
        FROM dmpl__ClaimReconciliation__c LIMIT 1];
    }

}