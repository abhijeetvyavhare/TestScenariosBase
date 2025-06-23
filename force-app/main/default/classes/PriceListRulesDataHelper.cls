public with sharing class PriceListRulesDataHelper {

    public static dmpl__PriceListRules__c createRequiredData() {
        dmpl__PriceList__c priceList = new dmpl__PriceList__c(Name = 'Test Price List');
        insert priceList;

        dmpl__Item__c item = new dmpl__Item__c(Name = 'Test Item');
        insert item;

        // dmpl__Lot_Type__c lotType = new dmpl__Lot_Type__c(Name = 'Test Lot Type');
        // insert lotType;

        dmpl__SKU__c sku = new dmpl__SKU__c(Name = 'Test SKU');
        insert sku;

        dmpl__PriceListRules__c rule = new dmpl__PriceListRules__c(
            dmpl__PriceListId__c = priceList.Id,
            dmpl__ItemId__c = item.Id,
            // dmpl__ItemLotTypeId__c = lotType.Id,
            dmpl__SKUId__c = sku.Id,
            dmpl__DateEffectiveFrom__c = Date.today(),
            dmpl__DateEffectiveTill__c = Date.today().addDays(10),
            dmpl__Price__c = 100.00,
            dmpl__Price2__c = 120.1234,
            dmpl__ExternalId__c = 'EXT-RULE-001'
        );
        insert rule;

        return rule;
    }

    public static dmpl__PriceListRules__c getRule() {
        return [
            SELECT Id, Name, dmpl__Price__c, dmpl__Price2__c 
            FROM dmpl__PriceListRules__c 
            LIMIT 1
        ];
    }

    
    public static dmpl__PriceListRules__c getRuleById(Id ruleId) {
        return [
            SELECT Id, Name, dmpl__Price__c, dmpl__Price2__c
            FROM dmpl__PriceListRules__c
            WHERE Id = :ruleId
            LIMIT 1
        ];
    }

    public static Boolean existsRule(Id ruleId) {
        return [SELECT count() FROM dmpl__PriceListRules__c WHERE Id = :ruleId] > 0;
    }
}