@isTest
public with sharing class PriceListDataHelperTest {
    public static dmpl__PriceList__c createPriceList(Account partnerAccount, dmpl__Branch__c branch) {
        return (dmpl__PriceList__c) TestFactory.createSObject(
            new dmpl__PriceList__c(
                Name = 'Test-Price',
                dmpl__PartnerAccountId__c = partnerAccount.Id,
                dmpl__BranchId__c = branch.Id,
                dmpl__PriceListType__c = 'Sale Price',
                dmpl__IsActive__c = true,
                dmpl__IsDefault__c = true,
                dmpl__CustomerAccountGroupId__c = null,
                dmpl__PartnerAccountGroupId__c = null,
                dmpl__ExternalId__c = 'TEST-001',
                dmpl__SequenceNumber__c = 1
            ),
            'PriceListDefaults',
            true
        );
    }

    public static dmpl__PriceList__c getPriceList() {
        return [SELECT 
                Id, 
                Name,
                dmpl__PartnerAccountId__c,
                dmpl__BranchId__c,
                dmpl__PriceListType__c,
                dmpl__IsActive__c,
                dmpl__IsDefault__c,
                dmpl__CustomerAccountGroupId__c,
                dmpl__PartnerAccountGroupId__c,
                dmpl__ExternalId__c,
                dmpl__SequenceNumber__c
                FROM dmpl__PriceList__c 
                LIMIT 1];
    }

    public static dmpl__PriceList__c getPriceList(Id priceListId) {
        return [SELECT 
                Id, 
                Name,
                dmpl__PartnerAccountId__c,
                dmpl__BranchId__c,
                dmpl__PriceListType__c,
                dmpl__IsActive__c,
                dmpl__IsDefault__c,
                dmpl__CustomerAccountGroupId__c,
                dmpl__PartnerAccountGroupId__c,
                dmpl__ExternalId__c,
                dmpl__SequenceNumber__c
                FROM dmpl__PriceList__c 
                WHERE Id = :priceListId 
                LIMIT 1];
    }
    
    public static dmpl__PriceListRules__c createPriceListRule(
        dmpl__PriceList__c priceList,
        dmpl__Item__c item,
        dmpl__SKU__c sku
    ) {
        return (dmpl__PriceListRules__c) TestFactory.createSObject(
            new dmpl__PriceListRules__c(
                dmpl__PriceListId__c = priceList.Id,
                dmpl__ItemId__c = item.Id,
                dmpl__SKUId__c = sku.Id,
                dmpl__DateEffectiveFrom__c = Date.today(),
                dmpl__Price__c = 100.00,
                dmpl__Price2__c = 95.1234
            ),
            'PriceListRuleDefaults',
            true
        );
    }

    public static dmpl__PriceListRules__c getPriceListRule() {
        return [
            SELECT Id, dmpl__PriceListId__c, dmpl__ItemId__c, dmpl__SKUId__c,
                dmpl__DateEffectiveFrom__c, dmpl__DateEffectiveTill__c,
                dmpl__Price__c, dmpl__Price2__c
            FROM dmpl__PriceListRules__c
            LIMIT 1
        ];
    }

    public static dmpl__PriceListRules__c getPriceListRule(Id priceListRuleId) {
        return [
            SELECT Id, dmpl__PriceListId__c, dmpl__ItemId__c, dmpl__SKUId__c,
                dmpl__DateEffectiveFrom__c, dmpl__DateEffectiveTill__c,
                dmpl__Price__c, dmpl__Price2__c
            FROM dmpl__PriceListRules__c
            WHERE Id = :priceListRuleId
            LIMIT 1
        ];
    }

    public static dmpl__PriceListRules__c getPriceListRules() {
        return [SELECT 
                Id, 
                Name,
                dmpl__ItemId__c,
                dmpl__SKUId__c,
                dmpl__PriceListId__c,
                dmpl__DateEffectiveTill__c,
                dmpl__DateEffectiveFrom__c
            FROM dmpl__PriceListRules__c 
            LIMIT 1];
    }
}