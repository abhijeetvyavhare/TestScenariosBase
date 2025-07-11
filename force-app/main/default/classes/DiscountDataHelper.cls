public with sharing class DiscountDataHelper {
    public static dmpl__DiscountGroup__c createDiscountGroup(
        String name,
        Id partnerAccountId,
        Id branchId,
        Id customerAccountGroupId,
        Boolean isActive,
        String discountType
    ) {
        return (dmpl__DiscountGroup__c) TestFactory.createSObject(
            new dmpl__DiscountGroup__c(
                Name = name,
                dmpl__PartnerAccountId__c = partnerAccountId,
                dmpl__BranchId__c = branchId,
                dmpl__CustomerAccountGroupId__c = customerAccountGroupId,
                dmpl__IsActive__c = isActive,
                dmpl__DiscountType__c = discountType
            ),
            'DiscountGroupDefaults',
            true
        );
    }

    
    public static dmpl__DiscountGroupRule__c createDiscountGroupRule(
        Id discountGroupId,
        Id itemId,
        Id skuId,
        Id itemGroupId,
        Id priceListId,
        Decimal discountPercent,
        Date dateEffectiveFrom,
        Date dateEffectiveTill
    ) {
        return (dmpl__DiscountGroupRule__c) TestFactory.createSObject(
            new dmpl__DiscountGroupRule__c(
                dmpl__DiscountGroupId__c = discountGroupId,
                dmpl__ItemId__c = itemId,
                dmpl__SKUId__c = skuId,
                dmpl__ItemGroupId__c = itemGroupId,
                dmpl__PriceListId__c = priceListId,
                dmpl__DiscountPercent__c = discountPercent,
                dmpl__DateEffectiveFrom__c = dateEffectiveFrom,
                dmpl__DateEffectiveTill__c = dateEffectiveTill
            ),
            'DiscountGroupRuleDefaults',
            true
        );
    }

    public static dmpl__DiscountGroupRule__c getDiscountGroupRule(Id discountGroupId) {
        return [
            SELECT 
                Id,
                dmpl__DiscountGroupId__c,
                dmpl__ItemId__c,
                dmpl__SKUId__c,
                dmpl__ItemGroupId__c,
                dmpl__PriceListId__c,
                dmpl__DiscountPercent__c,
                dmpl__DateEffectiveFrom__c,
                dmpl__DateEffectiveTill__c
            FROM dmpl__DiscountGroupRule__c
            WHERE  dmpl__DiscountGroupId__c= :discountGroupId
        ];
    }
     public static dmpl__DiscountGroup__c createDiscountGroup(
        String name,
        Id partnerAccountId,
        Id branchId
    ) {
        return (dmpl__DiscountGroup__c) TestFactory.createSObject(
            new dmpl__DiscountGroup__c(
                Name = name,
                dmpl__PartnerAccountId__c = partnerAccountId,
                dmpl__BranchId__c = branchId
            ),
            'DiscountGroupDefaults',
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

    public static dmpl__DiscountGroup__c getDiscountGroup(Id id) {
        return [SELECT 
        id,
        name 
        FROM dmpl__DiscountGroup__c LIMIT 1];
    }

    
}