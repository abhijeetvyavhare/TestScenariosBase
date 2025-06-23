@isTest
public with sharing class TaxGroupRuleTestDataHelper {
    public static dmpl__TaxGroupRule__c createTaxGroupRule(
        dmpl__Item__c item,
        dmpl__SKU__c SKU,
        dmpl__TaxGroup__c taxGroup,
        dmpl__ItemGroup__c ItemGroup
    ) {
        return (dmpl__TaxGroupRule__c) TestFactory.createSObject(
            new dmpl__TaxGroupRule__c(
                dmpl__TaxGroupId__c = taxGroup.Id,
                dmpl__SKUId__c = SKU.Id,
                dmpl__ItemId__c = Item.Id,
                dmpl__DateEffectiveFrom__c = date.today(),
                dmpl__DateEffectiveTill__c = date.today() + 15,
                dmpl__PlaceOfSupplyType__c = 'Within State',
                dmpl__ItemGroupId__c = ItemGroup.Id
            ),
            true
        );
    }
    
    public static dmpl__TaxGroupRule__c getTaxGroupRule() {
        return [
            SELECT 
                Id, 
                dmpl__PlaceOfSupplyType__c, 
                dmpl__DateEffectiveFrom__c, 
                dmpl__DateEffectiveTill__c 
            FROM dmpl__TaxGroupRule__c 
            LIMIT 1
        ];
    }
    
    public static dmpl__ItemGroup__c createItemGroup() {
        return (dmpl__ItemGroup__c) TestFactory.createSObject(
            new dmpl__ItemGroup__c(
                Name = 'Item Group Test',
                dmpl__ItemGroupType__c = 'Tax'
            ),
            'ItemGroupDefaults',
            true
        );
    }
    public static dmpl__ItemGroup__c getItemGroup() {
        return [SELECT Id, Name FROM dmpl__ItemGroup__c LIMIT 1];
    }
}