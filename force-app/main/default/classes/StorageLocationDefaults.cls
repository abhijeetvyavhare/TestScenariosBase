public with sharing class StorageLocationDefaults implements TestFactory.FieldDefaults{
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{ 
            'dmpl__IsActive__c' => false,
            'dmpl__AllowInventory__c' => false,
            'dmpl__IsMobile__c' => false
        };
    }
}