@isTest
public with sharing class ItemImageDetailDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults() {
        return new Map<String, Object>{
           'dmpl__LinkUrl__c' => 'https://test-image-url.com'
        };
    }
}