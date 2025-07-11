@isTest
public with sharing class DiscountGroupDataHelper {
    public static dmpl__DiscountGroup__c createDiscountGroup(
        String name,
        Account partnerAccount,
        dmpl__Branch__c branch
    ) {
        return (dmpl__DiscountGroup__c) TestFactory.createSObject(
            new dmpl__DiscountGroup__c(
                Name = name,
                dmpl__PartnerAccountId__c = partnerAccount != null ? partnerAccount.Id : null,
                dmpl__BranchId__c        = branch != null ? branch.Id : null
            ),
            //'DiscountGroupDefaults',
            true
        );
    }




    public static dmpl__DiscountGroup__c getDiscountGroup(String Name) {
        return [
            SELECT 
                Id,
                Name,
                dmpl__PartnerAccountId__c,
                dmpl__BranchId__c,
                dmpl__CustomerAccountGroupId__c,
                dmpl__IsActive__c,
                dmpl__DiscountType__c
            FROM dmpl__DiscountGroup__c
            WHERE Name = :Name
        ];
    }
    public static dmpl__DiscountGroup__c getDiscountGroup(Id id) {
        return [SELECT 
        id,
        name 
        FROM dmpl__DiscountGroup__c LIMIT 1];
    }
}