@isTest
public with sharing class DiscountGroupRuleTestDataHelper {

    public static dmpl__DiscountGroupRule__c createDiscountGroupRule(
        dmpl__DiscountGroup__c discountGroup,
        dmpl__Item__c item,
        dmpl__ItemGroup__c itemGroup,
        dmpl__ItemLotType__c lotType,
        dmpl__SKU__c sku,
        dmpl__PriceList__c priceList
    ) {
        return (dmpl__DiscountGroupRule__c) TestFactory.createSObject(
            new dmpl__DiscountGroupRule__c(
                dmpl__DiscountGroupId__c = discountGroup.Id,
                dmpl__ItemId__c = item != null ? item.Id : null,
                dmpl__ItemGroupId__c = itemGroup != null ? itemGroup.Id : null,
                dmpl__ItemLotTypeId__c = lotType != null ? lotType.Id : null,
                dmpl__SKUId__c = sku != null ? sku.Id : null,
                dmpl__PriceListId__c = priceList != null ? priceList.Id : null
            ),
            'DiscountGroupRuleDefaults',
            true
        );
    }

    public static dmpl__DiscountGroupRule__c getDiscountGroupRule() {
        return [
            SELECT 
                Id,
                dmpl__DiscountGroupId__c,
                dmpl__ItemId__c,
                dmpl__ItemGroupId__c,
                dmpl__ItemLotTypeId__c,
                dmpl__SKUId__c,
                dmpl__PriceListId__c,
                dmpl__ClaimablePercentage__c,
                dmpl__DiscountPercent__c,
                dmpl__DateEffectiveFrom__c,
                dmpl__DateEffectiveTill__c,
                dmpl__ExternalId__c
            FROM dmpl__DiscountGroupRule__c
            LIMIT 1
        ];
    }

    public static dmpl__DiscountGroupRule__c createDiscountGroupRule(
    dmpl__DiscountGroup__c discountGroup,
    Decimal discountPercent,
    Date dateFrom,
    Date dateTill,
    dmpl__Item__c item,
    dmpl__SKU__c sku,
    dmpl__ItemGroup__c itemGroup,
    dmpl__ItemLotType__c lotType,
    dmpl__PriceList__c priceList
    ) {
        return (dmpl__DiscountGroupRule__c) TestFactory.createSObject(
        new dmpl__DiscountGroupRule__c(
            dmpl__DiscountGroupId__c     = discountGroup.Id,
            dmpl__DiscountPercent__c     = discountPercent,
            dmpl__DateEffectiveFrom__c   = dateFrom,
            dmpl__DateEffectiveTill__c   = dateTill,
            dmpl__ItemId__c              = item != null ? item.Id : null,
            dmpl__ItemGroupId__c         = itemGroup != null ? itemGroup.Id : null,
            dmpl__ItemLotTypeId__c       = lotType != null ? lotType.Id : null,
            dmpl__SKUId__c               = sku != null ? sku.Id : null,
            dmpl__PriceListId__c         = priceList != null ? priceList.Id : null
        ),
            'DiscountGroupRuleDefaults',
            true
        );
    }
    public static List<dmpl__DiscountGroupRule__c> getDiscountGroupRulesByGroupId(Id discountGroupId) {
    return [
        SELECT 
            Id,
            dmpl__DiscountGroupId__c,
            dmpl__DiscountPercent__c,
            dmpl__DateEffectiveFrom__c,
            dmpl__DateEffectiveTill__c,
            dmpl__ItemId__c,
            dmpl__SKUId__c,
            dmpl__ItemGroupId__c,
            dmpl__ItemLotTypeId__c,
            dmpl__PriceListId__c
        FROM dmpl__DiscountGroupRule__c
        WHERE dmpl__DiscountGroupId__c = :discountGroupId
    ];
}

}