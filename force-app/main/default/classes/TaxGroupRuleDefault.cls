public with sharing class TaxGroupRuleDefault implements TestFactory.FieldDefaults {
  public Map<String, Object> getFieldDefaults() {
        return new Map<String, Object>{
            'dmpl__TaxGroupId__c'       => null,
            'dmpl__SKUId__c'            => null,
            'dmpl__ItemId__c'           => null,
            'dmpl__ItemGroupId__c'      => null,
            'dmpl__DateEffectiveFrom__c'=> Date.today(),
            'dmpl__DateEffectiveTill__c'=> Date.today().addDays(15),
            'dmpl__PlaceOfSupplyType__c'=> 'Within State'
        };
    }
}