@isTest
public with sharing class ItemLotTypeDefaults implements  TestFactory.FieldDefaults{ 
    public Map<String, Object> getFieldDefaults() {
        return new Map<String, Object>{ 
            'dmpl__IsSample__c' => false,
            'dmpl__IsSaleable__c' => true,
            'dmpl__IsPromo__c' => false,
            'Name' => 'Test Lot Type',
            'dmpl__ItemId__c' => null
        };
    }
}