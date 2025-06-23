@isTest
public with sharing class PriceListRuleDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{ 
            'dmpl__DateEffectiveFrom__c' => Date.today(),
            'dmpl__DateEffectiveTill__c' => Date.today().addYears(1),
            'dmpl__Price__c' => 100.00,
            'dmpl__Price2__c' => 95.1234
        };
    }
}