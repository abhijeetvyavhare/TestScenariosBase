@isTest
public with sharing class JobQueueDefaults implements  TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{
            'dmpl__JobType__c' => 'Interface Job',
            'dmpl__QueueType__c' => 'Queueable',
            'dmpl__RetryCount__c' => 1
        };
    }
}