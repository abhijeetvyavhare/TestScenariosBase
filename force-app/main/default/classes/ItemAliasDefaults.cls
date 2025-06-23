@isTest
public with sharing class ItemAliasDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults() {
        return new Map<String, Object>{
            'Name' => 'Test Alias',
            'dmpl__ItemId__c' => null,
            'dmpl__ItemLotTypeId__c' => null
            
        };
    }
}