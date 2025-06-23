@isTest
public with sharing class PartnerResourceDataHelper {
    public static dmpl__PartnerResource__c createPartnerResource(Account partnerAcc, dmpl__Branch__c branch, dmpl__Resource__c resource){
        return (dmpl__PartnerResource__c) TestFactory.createSObject(
            new dmpl__PartnerResource__c(
                dmpl__BranchId__c = branch.Id,
                dmpl__PartnerAccountId__c = partnerAcc.Id,
                dmpl__ResourceId__c = resource.Id
            ),
            'PartnerResourceDefaults',
            true
        );
    }
    
    public static dmpl__PartnerResource__c getPartnerResource() {
        return [
            SELECT Id, Name, dmpl__BranchId__c, dmpl__PartnerAccountId__c, dmpl__AssignmentSequenceNumber__c, dmpl__FromDate__c, dmpl__RuleSuccessCriteria__c, dmpl__ToDate__c
            FROM dmpl__PartnerResource__c
            LIMIT 1
        ];
    }
}