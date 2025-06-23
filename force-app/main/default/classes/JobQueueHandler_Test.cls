@isTest
public with sharing class JobQueueHandler_Test {
    @TestSetup
    static void createRequiredData() {
        dmpl__InterfaceQueue__c jobQueue = JobQueueTestDataHelper.createJobQueue();
    }

    @isTest
    static void createJobQueuePositive() {
        dmpl__InterfaceQueue__c jobQueue = JobQueueTestDataHelper.getJobQueue();
        if (jobQueue != null) {
            System.assertNotEquals(jobQueue, null, 'Expected JobQueue to be created.');
        }
        System.assertEquals('Interface Job', jobQueue.dmpl__JobType__c, 'JobType should be Interface Job');
        System.assertEquals('Queueable', jobQueue.dmpl__QueueType__c, 'QueueType should be Queueable');
        System.assertEquals(1, jobQueue.dmpl__RetryCount__c, 'RetryCount should be 1');
    }

    @isTest
    static void updateJobQueuePositive() {
        dmpl__InterfaceQueue__c jobQueue = JobQueueTestDataHelper.getJobQueue();
        System.assertNotEquals(jobQueue, null, 'JobQueue should exist before update.');

        jobQueue.dmpl__RetryCount__c = 3;
        jobQueue.dmpl__QueueType__c = 'Manual';
        update jobQueue;

        dmpl__InterfaceQueue__c updatedJobQueue = JobQueueTestDataHelper.getJobQueue();
        System.assertEquals(3, updatedJobQueue.dmpl__RetryCount__c, 'RetryCount should be updated to 3');
        System.assertEquals('Manual', updatedJobQueue.dmpl__QueueType__c, 'QueueType should be updated to Manual');
    }

    @isTest
    static void deleteJobQueuePositive() {
        dmpl__InterfaceQueue__c jobQueue = JobQueueTestDataHelper.getJobQueue();
        System.assertNotEquals(jobQueue, null, 'JobQueue should exist before delete.');
        delete jobQueue;
        dmpl__InterfaceQueue__c deletedJobQueue = null;
        try {
            deletedJobQueue = JobQueueTestDataHelper.getJobQueue();
        } catch (Exception e) {
            deletedJobQueue = null;
        }

        System.assertEquals(null, deletedJobQueue, 'JobQueue should be deleted and not found in query.');
    }
}