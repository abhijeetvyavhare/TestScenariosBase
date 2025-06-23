@isTest
public with sharing class BranchDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{ 
           'Name' => 'TheBestAccount',
           'dmpl__IsActive__c'=>true 
        };
    }
}