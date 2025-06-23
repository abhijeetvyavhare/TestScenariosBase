public with sharing class FinancierSchemeDataHelper {
    public static dmpl__FinancerScheme__c createFinancerScheme(Account partnerAccount, dmpl__AccountGroup__c accountGroup, dmpl__Financer__c financer) {
        return (dmpl__FinancerScheme__c) TestFactory.createSObject(
            new dmpl__FinancerScheme__c(
                dmpl__FinancerId__c = financer.Id,
                dmpl__ApplicablePartnerAccountId__c = partnerAccount.Id,
                dmpl__ApplicableToPartnerAccountGroupId__c = accountGroup.Id
            ),
            'FinancerSchemeDefaults',
            true
        );
    }

    public static dmpl__FinancerScheme__c getFinancerScheme() {
        return [
            SELECT Id, Name, dmpl__Description__c, dmpl__ExternalId__c, dmpl__Features__c,
                   dmpl__InterestRate__c, dmpl__MaximumAmount__c, dmpl__MinimumAmount__c,
                   dmpl__MaximumTenure__c, dmpl__MinimumTenure__c,
                   dmpl__FinancerId__c, dmpl__ApplicablePartnerAccountId__c, dmpl__ApplicableToPartnerAccountGroupId__c
            FROM dmpl__FinancerScheme__c
            LIMIT 1
        ];
    }

     public static dmpl__FinancerScheme__c getFinancerSchemeRecord(Id schemeId) {
        return [
            SELECT Name, dmpl__Description__c, dmpl__ExternalId__c, dmpl__Features__c,
                   dmpl__InterestRate__c, dmpl__MaximumAmount__c, dmpl__MinimumAmount__c,
                   dmpl__MaximumTenure__c, dmpl__MinimumTenure__c
            FROM dmpl__FinancerScheme__c
            WHERE Id = :schemeId
            LIMIT 1
        ];
    }
    
    public static Boolean existsFinancerScheme(Id schemeId) {
        return [SELECT count() FROM dmpl__FinancerScheme__c WHERE Id = :schemeId] > 0;
    }
}