@isTest
public with sharing class PostalCodeDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults() {
        return new Map<String, Object>{
            'dmpl__City__c' => 'Chandigarh',
            'dmpl__Country__c' => 'India',
            'Name' => 'Test Postal Code',
            'dmpl__Region__c' => 'North',
            'dmpl__State__c' => 'Punjab'
        };
    }
}