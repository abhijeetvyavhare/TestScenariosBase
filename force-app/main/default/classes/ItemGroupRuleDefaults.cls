@isTest
public with sharing class ItemGroupRuleDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults() {
        return new Map<String, Object>{
          'dmpl__FieldName__c' => 'Test Field Name',
          'dmpl__FieldValue__c' => 'Test Field Value'
        };
    }
}