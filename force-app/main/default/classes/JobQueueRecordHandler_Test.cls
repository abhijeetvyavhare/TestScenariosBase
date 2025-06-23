@isTest
public with sharing class JobQueueRecordHandler_Test {
    @TestSetup
    static void createRequiredData() {
        dmpl__InterfaceQueue__c jobQueue = JobQueueTestDataHelper.createJobQueue();
        dmpl__JobQueueRecord__c jobQueueRecord = JobQueueTestDataHelper.createJobQueueRecord(jobQueue);
    }

    @isTest
    static void createJobQueueRecordPositive() {
    dmpl__JobQueueRecord__c jobQueueRecord = JobQueueTestDataHelper.getJobQueueRecord();
    if (jobQueueRecord != null) {
        System.assertNotEquals(jobQueueRecord, null, 'Expected JobQueueRecord to be created.');
    }
    System.assertEquals('This is job queue record message', jobQueueRecord.dmpl__Message__c, 'Message should match');
    System.assertEquals(12, jobQueueRecord.dmpl__Quantity__c, 'Quantity should be 12');
    System.assertNotEquals(jobQueueRecord.dmpl__JobQueueId__c, null, 'JobQueueId should be set');
}

    @isTest
    static void updateJobQueueRecordPositive() {
        dmpl__JobQueueRecord__c jobQueueRecord = JobQueueTestDataHelper.getJobQueueRecord();
        System.assertNotEquals(jobQueueRecord, null, 'JobQueueRecord should exist before update.');

        jobQueueRecord.dmpl__Quantity__c = 30;
        jobQueueRecord.dmpl__Message__c = 'Updated Job Queue Message';
        update jobQueueRecord;

        dmpl__JobQueueRecord__c updatedJobQueueRecord = JobQueueTestDataHelper.getJobQueueRecord();
        System.assertEquals(30, updatedJobQueueRecord.dmpl__Quantity__c, 'Expected updated quantity to be 30');
        System.assertEquals('Updated Job Queue Message', updatedJobQueueRecord.dmpl__Message__c, 'Expected updated message');
    }

    @isTest
    static void deleteJobQueueRecordPositive() {
        dmpl__JobQueueRecord__c jobQueueRecord = JobQueueTestDataHelper.getJobQueueRecord();
        System.assertNotEquals(jobQueueRecord, null, 'JobQueueRecord should exist before delete.');
        delete jobQueueRecord;
        dmpl__JobQueueRecord__c deletedJobQueueRecord = null;
        try {
            deletedJobQueueRecord = JobQueueTestDataHelper.getJobQueueRecord();
        } catch (Exception e) {
            deletedJobQueueRecord = null;
        }

        System.assertEquals(null, deletedJobQueueRecord, 'JobQueueRecord should be deleted and not found in query.');
    }

}