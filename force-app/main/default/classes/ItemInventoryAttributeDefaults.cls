@isTest
public with sharing class ItemInventoryAttributeDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults() {
        return new Map<String, Object>{
            'dmpl__MaximumStockLevel__c' => 1000.00,
            'dmpl__MinimumOrderQuantity__c' => 10.00,
            'dmpl__MinimumStockLevel__c' => 500.00,
            'dmpl__MaximumOrderQuantity__c' => 2000.00
        };
    }
}