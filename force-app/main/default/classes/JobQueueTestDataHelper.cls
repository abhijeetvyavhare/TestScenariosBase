@isTest
public with sharing class JobQueueTestDataHelper {
    public static dmpl__InterfaceQueue__c createJobQueue() {
        return (dmpl__InterfaceQueue__c) TestFactory.createSObject(
            new dmpl__InterfaceQueue__c(
                dmpl__JobType__c = 'Interface Job',
                dmpl__QueueType__c = 'Queueable',
                dmpl__RetryCount__c = 1
            ),
            'JobQueueDefaults',
            true
        );
    }

    public static dmpl__InterfaceQueue__c getJobQueue() {
        return [
            SELECT 
             dmpl__JobType__c,
             dmpl__QueueType__c,
             dmpl__RetryCount__c
            FROM dmpl__InterfaceQueue__c LIMIT 1
        ];
        
    }

    public static dmpl__JobQueueRecord__c createJobQueueRecord(dmpl__InterfaceQueue__c jobQueue) {
        return (dmpl__JobQueueRecord__c) TestFactory.createSObject(
            new dmpl__JobQueueRecord__c(
                dmpl__JobQueueId__c = jobQueue.Id,
                dmpl__Quantity__c = 12,
                dmpl__Message__c= 'This is job queue record message'
            ),
            'JobQueueRecordDefaults',
            true
        );
    }

    public static dmpl__JobQueueRecord__c getJobQueueRecord() {
        return [
            SELECT 
             dmpl__Message__c,
             dmpl__Quantity__c,
             dmpl__JobQueueId__c
            FROM dmpl__JobQueueRecord__c LIMIT 1
        ];
        
    }
}