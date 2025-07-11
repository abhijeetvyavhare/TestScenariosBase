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

     public static dmpl__InterfaceQueue__c createJobQueue(
        String jobType,
        String queueType,
        Integer retryCount,
       // Integer attemptCount,
        dmpl__InterfaceServiceProvider__c interfaceServiceProvider,
        dmpl__InterfaceServiceProviderRequest__c interfaceServiceProviderRequest
     ) {
        return (dmpl__InterfaceQueue__c) TestFactory.createSObject(
            new dmpl__InterfaceQueue__c(
                dmpl__JobType__c = jobType,
                dmpl__QueueType__c = queueType,
                dmpl__CronExpression__c = queueType=='Schedulable'?'0 0 1 * * ?':null,
                dmpl__SchedulableJobName__c = queueType=='Schedulable'?'Test':null,
                dmpl__RetryCount__c = retryCount,
                //dmpl__AttemptCount__c = attemptCount,
                dmpl__InterfaceProviderId__c = interfaceServiceProvider?.Id,
                dmpl__InterfaceRequestId__c = interfaceServiceProviderRequest?.Id
            ),
           // 'JobQueueDefaults',
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

    public static dmpl__InterfaceQueue__c getJobQueue(id jobQueueId) {
        return [
            SELECT
             Id,
             dmpl__JobType__c,
             dmpl__QueueType__c,
             dmpl__RetryCount__c,
             dmpl__AttemptCount__c,
             dmpl__InterfaceProviderId__c,
             dmpl__InterfaceRequestId__c
            FROM dmpl__InterfaceQueue__c WHERE Id=:jobQueueId LIMIT 1
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
    public static dmpl__JobQueueRecord__c createJobQueueRecord(
        String hostId,
        String message,
        Integer quantity,
        String recordId,
        dmpl__InterfaceQueue__c jobQueue
    ) {
        return (dmpl__JobQueueRecord__c) TestFactory.createSObject(
            new dmpl__JobQueueRecord__c(
                dmpl__JobQueueId__c = jobQueue?.Id,
                dmpl__Quantity__c = quantity,
                dmpl__HostId__c = hostId,
                dmpl__RecordId__c = recordId,
                dmpl__Message__c= message
            ),
          //  'JobQueueRecordDefaults',
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

    public static dmpl__JobQueueRecord__c getJobQueueRecord(Id jobQueueRecordId) {
        return [
            SELECT 
             Id,
             dmpl__Message__c,
             dmpl__Quantity__c,
             dmpl__JobQueueId__c,
             dmpl__HostId__c,
             dmpl__RecordId__c
            FROM dmpl__JobQueueRecord__c where Id =: jobQueueRecordId  LIMIT 1
        ];
        
    }
}