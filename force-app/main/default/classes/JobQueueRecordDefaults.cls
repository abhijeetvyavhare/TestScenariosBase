@isTest
public with sharing class JobQueueRecordDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{
            'dmpl__Quantity__c' => 12,
            'dmpl__Message__c' => 'This is job queue record message'
        };
    }
}