@isTest
public with sharing class CreditLimitDataHelper {
    public static dmpl__CreditLimit__c createCreditLimit(Id partnerAccountId, Id customerAccountId) {
        return (dmpl__CreditLimit__c) TestFactory.createSObject(
            new dmpl__CreditLimit__c(
                dmpl__PartnerAccountId__c = partnerAccountId,
                dmpl__AccountId__c = customerAccountId
            ),
            'CreditLimitDefaults',
            true
        );
    }

    public static dmpl__CreditLimit__c getCreditLimit() {
        return [
            SELECT Id, Name, dmpl__PartnerAccountId__c, dmpl__AccountId__c,
                   dmpl__CreditLimitAmount__c, dmpl__UtilizedLimit__c, dmpl__CreditDays__c
            FROM dmpl__CreditLimit__c
            LIMIT 1
        ];
    }

    public static dmpl__CreditLimit__c getCreditLimit(Id creditLimitId) {
    return [
        SELECT Id, Name, dmpl__PartnerAccountId__c, dmpl__AccountId__c,
               dmpl__CreditLimitAmount__c, dmpl__UtilizedLimit__c, dmpl__CreditDays__c
        FROM dmpl__CreditLimit__c
        WHERE Id = :creditLimitId
        LIMIT 1
    ];
}
}