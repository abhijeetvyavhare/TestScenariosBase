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
     public static dmpl__ClaimReconciliation__c createClaimReconciliation(
    Id partnerAccountId,
    Id branchId,
    Id supplierId
) {
    return (dmpl__ClaimReconciliation__c) TestFactory.createSObject(
        new dmpl__ClaimReconciliation__c(
            dmpl__PartnerAccountId__c = partnerAccountId,
            dmpl__BranchId__c         = branchId,
            dmpl__SupplierId__c       = supplierId
        ),
        'ClaimReconciliationDefaults',
        true
    );
}


public static dmpl__ClaimReconciliation__c getClaimReconciliation(Id reconciliationId) {
    List<dmpl__ClaimReconciliation__c> results = [
        SELECT Id, Name, dmpl__Status__c, dmpl__DocumentDate__c,dmpl__ReconciledAmount__c, dmpl__CreditNoteAmount__c,
               dmpl__PartnerAccountId__c, dmpl__BranchId__c, dmpl__SupplierId__c
        FROM dmpl__ClaimReconciliation__c
        WHERE Id = :reconciliationId
        LIMIT 1
    ];
    return results.isEmpty() ? null : results[0];
}

public static dmpl__ClaimReconciliation__c createClaimReconciliationWithAmounts(
    Id partnerAccountId,
    Id branchId,
    Id supplierId,
    Decimal reconciledAmount
) {
    return (dmpl__ClaimReconciliation__c) TestFactory.createSObject(
        new dmpl__ClaimReconciliation__c(
            dmpl__PartnerAccountId__c  = partnerAccountId,
            dmpl__BranchId__c          = branchId,
            dmpl__SupplierId__c        = supplierId,
            dmpl__ReconciledAmount__c  = reconciledAmount
        ),
      //  'ClaimReconciliationDefaults',
        true
    );
}

public static dmpl__ClaimReconciliation__c createClaimReconciliationWithCreditNoteAmount(
    Id partnerAccountId,
    Id branchId,
    Id supplierId,
    Decimal creditNoteAmount
) {
    return (dmpl__ClaimReconciliation__c) TestFactory.createSObject(
        new dmpl__ClaimReconciliation__c(
            dmpl__PartnerAccountId__c  = partnerAccountId,
            dmpl__BranchId__c          = branchId,
            dmpl__SupplierId__c        = supplierId,
            dmpl__CreditNoteAmount__c  = creditNoteAmount
        ),
      //  'ClaimReconciliationDefaults',
        true
    );
}

   
   public static dmpl__Claim__c createClaim(
        Id partnerAccountId,
        Id branchId,
        Id supplierAccountId,
        String claimType,
        String status

    ) {
        return (dmpl__Claim__c) TestFactory.createSObject(
            new dmpl__Claim__c(
                dmpl__PartnerAccountId__c = partnerAccountId,
                dmpl__BranchId__c = branchId,
                dmpl__SupplierNameId__c = supplierAccountId,
                dmpl__ClaimType__c = claimType,
                dmpl__Status__c = status
            ),
            'ClaimDefaults',
            true
        );
    }

    public static dmpl__ClaimLine__c createClaimLine(
        Id claimId,
        Id itemId,
        Decimal claimQuantity,
        Decimal unitPrice
    ) {
        return (dmpl__ClaimLine__c) TestFactory.createSObject(
            new dmpl__ClaimLine__c(
                dmpl__ClaimId__c             = claimId,
                dmpl__ItemId__c              = itemId,
                dmpl__ClaimQuantity__c       = claimQuantity,
                dmpl__UnitPrice__c           = unitPrice
            ),
            //'ClaimLineDefaults',
            true
        );
    }

    public static dmpl__ClaimReconciliationLine__c createClaimReconciliationLine(
        Id reconciliation,
        Id claimId,
        Id claimLineId,
        Id itemId,
        Decimal claimQuantity,
        Decimal unitPrice,
        Decimal approveQuantity,
        Decimal approvedAmount
    ) {
        return (dmpl__ClaimReconciliationLine__c) TestFactory.createSObject(
            new dmpl__ClaimReconciliationLine__c(
                dmpl__ReconciliationId__c= reconciliation,
                dmpl__ClaimId__c         = claimId,
                dmpl__ClaimLineId__c     = claimLineId,
                dmpl__ItemId__c          = itemId,
                dmpl__ClaimQuantity__c   = claimQuantity,
                dmpl__UnitPrice__c       = unitPrice,
                dmpl__ApproveQuantity__c = approveQuantity,
                dmpl__ApprovedAmount__c  = approvedAmount
            ),
           // 'ClaimReconciliationLineDefaults',
            true
        );
    }

    public static dmpl__ClaimReconciliationLine__c getClaimReconciliationLine(Id reconciliationLineId) {
        return [
            SELECT Id,
                Name,
                dmpl__ReconciliationId__c,
                dmpl__ClaimId__c,
                dmpl__ClaimLineId__c,
                dmpl__ItemId__c,
                dmpl__ClaimQuantity__c,
                dmpl__UnitPrice__c,
                dmpl__ApproveQuantity__c,
                dmpl__ApprovedAmount__c
            FROM dmpl__ClaimReconciliationLine__c
            WHERE Id = :reconciliationLineId
            LIMIT 1
        ];
    }


}