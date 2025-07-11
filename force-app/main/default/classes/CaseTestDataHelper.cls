@isTest
public class CaseTestDataHelper {
    public static dmpl__Case__c createCase(
        Account partnerAccount,
        Account CustomerAccount,
        dmpl__Branch__c branch,
        dmpl__Resource__c resource
    ){
        return (dmpl__Case__c)TestFactory.createSObject(
            new dmpl__Case__c(
                dmpl__PartnerAccountId__c =partnerAccount.Id,
                dmpl__AccountId__c=customerAccount.Id,
                dmpl__BranchId__c= branch.Id,
                dmpl__ResourceId__c=resource.Id,
                dmpl__AccountPhone__c='9733387909',
                dmpl__Priority__c='Medium',
                dmpl__CaseSource__c='Phone',
                dmpl__CaseReason__c='Performance',
                dmpl__Status__c='New',
                dmpl__DateTimeOpened__c=System.now(),
                dmpl__Mobile__c='9733387909',
                dmpl__AccountName__c='Test-Account',
                dmpl__Remarks__c='Test Remarks'),
            true
        );
    }

    public static dmpl__Case__c getCase(){
        return [
            SELECT 
                Id,
                Name,
                dmpl__PartnerAccountId__c,
                dmpl__PerformCreateLead__c,
                dmpl__AccountId__c,
                dmpl__BranchId__c,
                dmpl__ResourceId__c,
                dmpl__AccountPhone__c,
                dmpl__Priority__c,
                dmpl__CaseSource__c,
                dmpl__CaseReason__c,
                dmpl__Status__c,
                dmpl__DateTimeOpened__c,
                dmpl__Mobile__c,
                dmpl__AccountName__c,
                dmpl__Remarks__c 
            FROM dmpl__Case__c 
            LIMIT 1
        ];
    }

    public static dmpl__Case__c getCase(Id id){
        return [
            SELECT 
                Id,
                Name,
                dmpl__PartnerAccountId__c,
                dmpl__PerformCreateLead__c,
                dmpl__AccountId__c,
                dmpl__BranchId__c,
                dmpl__ResourceId__c,
                dmpl__AccountPhone__c,
                dmpl__Priority__c,
                dmpl__CaseSource__c,
                dmpl__CaseReason__c,
                dmpl__Status__c,
                dmpl__DateTimeOpened__c,
                dmpl__Mobile__c,
                dmpl__AccountName__c,
                dmpl__Remarks__c 
            FROM dmpl__Case__c 
            WHERE Id =: id 
            LIMIT 1
        ];
    }

    public static dmpl__Case__c CreateCaseById(
        Account partnerAccount,
        Account customerAccount,
        dmpl__Branch__c branch,
        Asset asset 
    ) {
        dmpl__Case__c caseRecord = new dmpl__Case__c(
            dmpl__PartnerAccountId__c = partnerAccount != null ? partnerAccount.Id : null,
            dmpl__AccountId__c       = customerAccount != null ? customerAccount.Id : null,
            dmpl__BranchId__c        = branch != null ? branch.Id : null,
            dmpl__AssetId__c         = asset != null ? asset.Id : null);

            return (dmpl__Case__c) TestFactory.createSObject(caseRecord, true);
    }
    public static dmpl__Case__c getCaseById(Id id) {
        return [
            SELECT 
                Id,
                Name,
                dmpl__PartnerAccountId__c,
                dmpl__AccountId__c,
                dmpl__BranchId__c,
                dmpl__AssetId__c,
                dmpl__DocumentDate__c
            FROM dmpl__Case__c
            WHERE Id = :id
            LIMIT 1];
    }

}