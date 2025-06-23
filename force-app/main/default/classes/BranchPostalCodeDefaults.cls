@isTest
public with sharing class BranchPostalCodeDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{
            'dmpl__CoverageType__c' => 'Sale'
        };
    }
}