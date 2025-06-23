@isTest
public with sharing class ItemGroupMemberDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults() {
        return new Map<String, Object>{
          'dmpl__ItemGroupId__c' => 'Test Item Group',
          'dmpl__ItemId__c' => 'Test Item'
        };
    }
}