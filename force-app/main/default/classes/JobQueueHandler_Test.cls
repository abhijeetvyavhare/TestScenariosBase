@isTest
public with sharing class JobQueueHandler_Test {
    @TestSetup
    static void createRequiredData() {
        dmpl__InterfaceQueue__c jobQueue = JobQueueTestDataHelper.createJobQueue();
         Account partnerAccount1 = TestDataHelpers.createPartnerAccount(
			'Partner 1',
			false,
			true,
			false,
			true,
			'MG Road',
			'Bengaluru',
			'Karnataka',
			'India',
			'560001',
			'56 Industrial Layout',
			'Bengaluru',
			'Karnataka',
			'India',
			'560095',
            '91-9876543210'
		);
        Account partnerAccount2 = TestDataHelpers.createPartnerAccount(
			'Partner 2',
			false,
			true,
			false,
			false,
			'45 Residency Road',
			'Pune',
			'Maharashtra',
			'India',
			'411001',
			'22 Commerce Avenue',
			'Pune',
			'Maharashtra',
			'India',
			'411038',
            '91-9966554433'
		);
        Account partnerAccount3 = TestDataHelpers.createPartnerAccount(
			'Partner 3',
			false,
			true,
			false,
			true,
			'78 Nehru Nagar Road',
			'Chennai',
			'Tamil Nadu',
			'India',
			'600042',
			'78 Nehru Nagar Road',
			'Chennai',
			'Tamil Nadu',
			'India',
			'600042',
            '91-9988776655'
		);
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

    //new methods for testing
    // Job Queue record creation with Job Type ( New)
    @isTest
    static void createJobQueueWithJobTypePositive() {
        Test.startTest();
        dmpl__InterfaceQueue__c jobQueue = JobQueueTestDataHelper.createJobQueue('Interface Job', 'Queueable', 0, null, null);
        Test.stopTest();
        System.assertNotEquals(null, jobQueue, 'Expected JobQueue to be created with specified JobType.');
        System.assertEquals('Interface Job', jobQueue.dmpl__JobType__c, 'JobType should be Interface Job');
        System.assertEquals('Queueable', jobQueue.dmpl__QueueType__c, 'QueueType should be Queueable');
    }

    //Job Queue record creation with Job Type ( Edit)
    @isTest
    static void updateJobQueueWithJobTypePositive() {
        Test.startTest();
        dmpl__InterfaceQueue__c jobQueue = JobQueueTestDataHelper.createJobQueue('Interface Job', 'Queueable', 0, null, null);
        dmpl__InterfaceQueue__c createdJobQueue = JobQueueTestDataHelper.getJobQueue(jobQueue.Id);
        jobQueue.dmpl__JobType__c = 'Custom Processor';
        update jobQueue;
        dmpl__InterfaceQueue__c updatedJobQueue = JobQueueTestDataHelper.getJobQueue(jobQueue.Id);  
        Test.stopTest();
        System.assertNotEquals(null, updatedJobQueue, 'Expected JobQueue to be updated with specified JobType.');
        System.assertEquals('Interface Job', createdJobQueue.dmpl__JobType__c, 'JobType should be Interface Job when Initially created');
        System.assertEquals('Custom Processor', updatedJobQueue.dmpl__JobType__c, 'JobType should be updated to Custom Processor');
    }

    //New Job Queue creation with Queue Type as Queueable
    @isTest
    static void createJobQueueWithQueueTypeQueueablePositive() {
        Test.startTest();
        dmpl__InterfaceQueue__c jobQueue = JobQueueTestDataHelper.createJobQueue('Interface Job', 'Queueable', 0, null, null);
        Test.stopTest();
        System.assertNotEquals(null, jobQueue, 'Expected JobQueue to be created with QueueType as Queueable.');
        System.assertEquals('Queueable', jobQueue.dmpl__QueueType__c, 'QueueType should be Queueable');
        System.assertEquals('Interface Job', jobQueue.dmpl__JobType__c, 'JobType should be Interface Job');
    }

    //New Job Queue creation with Queue Type as Schedulable
    @isTest
    static void createJobQueueWithQueueTypeSchedulablePositive() {
        Test.startTest();
        dmpl__InterfaceQueue__c jobQueue = JobQueueTestDataHelper.createJobQueue('Interface Job', 'Schedulable', 0, null, null);
        Test.stopTest();
        System.assertNotEquals(null, jobQueue, 'Expected JobQueue to be created with QueueType as Schedulable.');
        System.assertEquals('Schedulable', jobQueue.dmpl__QueueType__c, 'QueueType should be Schedulable');
        System.assertEquals('Interface Job', jobQueue.dmpl__JobType__c, 'JobType should be Interface Job');
    }

    //New Job Queue creation with Queue Type as Event
    @isTest
    static void createJobQueueWithQueueTypeEventPositive() {
        Test.startTest();
        dmpl__InterfaceQueue__c jobQueue = JobQueueTestDataHelper.createJobQueue('Interface Job', 'Event', 0, null, null);
        Test.stopTest();
        System.assertNotEquals(null, jobQueue, 'Expected JobQueue to be created with QueueType as Event.');
        System.assertEquals('Event', jobQueue.dmpl__QueueType__c, 'QueueType should be Event');
        System.assertEquals('Interface Job', jobQueue.dmpl__JobType__c, 'JobType should be Interface Job');
    }

    //New Job Queue creation with Queue Type as Manual
    @isTest
    static void createJobQueueWithQueueTypeManualPositive() {
        Test.startTest();
        dmpl__InterfaceQueue__c jobQueue = JobQueueTestDataHelper.createJobQueue('Interface Job', 'Manual', 0, null, null);
        Test.stopTest();
        System.assertNotEquals(null, jobQueue, 'Expected JobQueue to be created with QueueType as Manual.');
        System.assertEquals('Manual', jobQueue.dmpl__QueueType__c, 'QueueType should be Manual');
        System.assertEquals('Interface Job', jobQueue.dmpl__JobType__c, 'JobType should be Interface Job');
    }

    //New Job Queue creation with Retry Count
    @isTest
    static void createJobQueueWithRetryCountPositive() {
        Test.startTest();
        dmpl__InterfaceQueue__c jobQueue = JobQueueTestDataHelper.createJobQueue('Interface Job', 'Queueable', 1, null, null);
        Test.stopTest();
        System.assertNotEquals(null, jobQueue, 'Expected JobQueue to be created with specified RetryCount.');
        System.assertEquals(1, jobQueue.dmpl__RetryCount__c, 'RetryCount should be 3');
        System.assertEquals('Interface Job', jobQueue.dmpl__JobType__c, 'JobType should be Interface Job');
        System.assertEquals('Queueable', jobQueue.dmpl__QueueType__c, 'QueueType should be Queueable');
    }

    //New Job Queue creation with Interface Provider
    @isTest
    static void createJobQueueWithInterfaceProviderPositive() {
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__InterfaceServiceProvider__c interfaceServiceProvider = InterfaceTestDataHelper.createInterfaceServiceProvider(partner);
        dmpl__InterfaceQueue__c jobQueue = JobQueueTestDataHelper.createJobQueue('Interface Job', 'Queueable', 1, interfaceServiceProvider, null);
        Test.stopTest();
        System.assertNotEquals(null, jobQueue, 'Expected JobQueue to be created with specified InterfaceServiceProvider.');
        System.assertEquals(interfaceServiceProvider.Id, jobQueue.dmpl__InterfaceProviderId__c, 'InterfaceServiceProviderId should be set');
        System.assertEquals('Interface Job', jobQueue.dmpl__JobType__c, 'JobType should be Interface Job');
        System.assertEquals('Queueable', jobQueue.dmpl__QueueType__c, 'QueueType should be Queueable');
    }

    //Existing  job queue creation with execute action (New)
    //Existing job queue creation with execute action (Edit)

    //Delete Job queue
    @isTest
static void deleteJobQueueScenarioPositive() {
    Test.startTest();
    dmpl__InterfaceQueue__c jobQueue = JobQueueTestDataHelper.createJobQueue('Interface Job', 'Manual', 1, null, null);
    delete jobQueue;
    dmpl__InterfaceQueue__c deletedJobQueue=null;
    try {
        deletedJobQueue = JobQueueTestDataHelper.getJobQueue(jobQueue.Id);
    } catch (QueryException e) {
        deletedJobQueue = null;
    }
    System.assertEquals(null, deletedJobQueue, 'JobQueue should be deleted.');
    Test.stopTest();
}

    //New Job Queue creation with Retry Count as negative number
    @isTest
    static void createJobQueueWithNegativeRetryCountNegative() {
        Test.startTest();
        try {
            dmpl__InterfaceQueue__c jobQueue = JobQueueTestDataHelper.createJobQueue('Interface Job', 'Queueable', -1, null, null);
            System.assertNotEquals(null, jobQueue, 'Expected JobQueue creation with negative RetryCount.');
        } catch (DmlException e) {
            System.debug('Expected exception: ' + e.getMessage());
        }
        Test.stopTest();
    }

    //New Job Queue creation with removing Interface Provider (Edit)
    @isTest
    static void updateJobQueueWithRemovingInterfaceProviderNegative() {
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__InterfaceServiceProvider__c interfaceServiceProvider = InterfaceTestDataHelper.createInterfaceServiceProvider(partner);
        dmpl__InterfaceQueue__c jobQueue = JobQueueTestDataHelper.createJobQueue('Interface Job', 'Queueable', 1, interfaceServiceProvider, null);
        dmpl__InterfaceQueue__c createdJobQueue = JobQueueTestDataHelper.getJobQueue(jobQueue.Id);
        jobQueue.dmpl__InterfaceProviderId__c = null;
        update jobQueue;
        dmpl__InterfaceQueue__c updatedJobQueue = JobQueueTestDataHelper.getJobQueue(jobQueue.Id);
        Test.stopTest();
        System.assertNotEquals(null, updatedJobQueue, 'Expected JobQueue to be updated with removing InterfaceServiceProvider.');
        System.assertEquals(interfaceServiceProvider.Id, createdJobQueue.dmpl__InterfaceProviderId__c, 'InterfaceServiceProviderId should be set when initially created');
        System.assertEquals(null, updatedJobQueue.dmpl__InterfaceProviderId__c, 'InterfaceServiceProviderId should be null after update');
    }

    //New Job Queue creation with removing Interface Provider Request (Edit)
    @isTest
    static void updateJobQueueWithRemovingInterfaceProviderRequestNegative() {
        Test.startTest();
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        dmpl__InterfaceServiceProvider__c interfaceServiceProvider = InterfaceTestDataHelper.createInterfaceServiceProvider(partner);
        dmpl__InterfaceServiceProviderRequest__c interfaceServiceProviderRequest = InterfaceTestDataHelper.createInterfaceServiceProviderRequest(interfaceServiceProvider);
        dmpl__InterfaceQueue__c jobQueue = JobQueueTestDataHelper.createJobQueue('Interface Job', 'Queueable', 1, interfaceServiceProvider, interfaceServiceProviderRequest);
        dmpl__InterfaceQueue__c createdJobQueue = JobQueueTestDataHelper.getJobQueue(jobQueue.Id);
        jobQueue.dmpl__InterfaceRequestId__c = null;
        update jobQueue;
        dmpl__InterfaceQueue__c updatedJobQueue = JobQueueTestDataHelper.getJobQueue(jobQueue.Id);
        Test.stopTest();
        System.assertNotEquals(null, updatedJobQueue, 'Expected JobQueue to be updated with removing InterfaceServiceProviderRequest.');
        System.assertEquals(interfaceServiceProviderRequest.Id, createdJobQueue.dmpl__InterfaceRequestId__c, 'InterfaceServiceProviderRequestId should be set when initially created');
        System.assertEquals(null, updatedJobQueue.dmpl__InterfaceRequestId__c, 'InterfaceServiceProviderRequestId should be null after update');
    }

    //New Job Queue creation with invalid Interface Request
    @isTest
    static void createJobQueueWithInvalidInterfaceRequestNegative() {
        Test.startTest();
        try {
            dmpl__InterfaceServiceProvider__c interfaceServiceProvider = InterfaceTestDataHelper.createInterfaceServiceProvider(null);
            dmpl__InterfaceServiceProviderRequest__c interfaceServiceProviderRequest = InterfaceTestDataHelper.createInterfaceServiceProviderRequest(interfaceServiceProvider);
            dmpl__InterfaceQueue__c jobQueue = JobQueueTestDataHelper.createJobQueue('Interface Job', 'Queueable', 1,interfaceServiceProvider, interfaceServiceProviderRequest);
            System.assertNotEquals(null, jobQueue, 'Expected JobQueue creation with invalid InterfaceServiceProviderRequest.');
        } catch (DmlException e) {
            System.debug('Expected exception: ' + e.getMessage());
        }
        Test.stopTest();
    }

    //New Job Queue creation with deleting Interface Request- duplicate
    //delete valid Job Queue- duplicate

    //Job Queue record creation with correct Job Queue ID
    @isTest
    static void createJobQueueWithCorrectJobQueueIdPositive() {
        Test.startTest();
        dmpl__InterfaceQueue__c jobQueue = JobQueueTestDataHelper.createJobQueue('Interface Job', 'Queueable', 1,null, null);
        dmpl__JobQueueRecord__c jobQueueRecord = JobQueueTestDataHelper.createJobQueueRecord(null, null, 0, null, jobQueue);
        Test.stopTest();
        System.assertNotEquals(null, jobQueueRecord, 'Expected Job Queue Record should get created');
    }

    //Job Queue record creation with correct selction of currency- Blocked
    //Job Queue record creation with host Id, Quantity , message, Record Id

    //Job Queue record creation without Job Queue ID
    @isTest
    static void createJobQueueRecordWithoutJobQueueIdNegative() {
        Test.startTest();
        try {
            dmpl__JobQueueRecord__c jobQueueRecord = JobQueueTestDataHelper.createJobQueueRecord(null, null, 0, null, null);
            System.assertEquals(null, jobQueueRecord, 'Expected Job Queue Record creation to fail without Job Queue ID.');
        } catch (DmlException e) {
            System.debug('Expected exception: ' + e.getMessage());
        }
        Test.stopTest();
    }

    //Job Queue record creation with host Id, Quantity , message, Record Id
    @isTest
    static void createJobQueueRecordWithHostIdQuantityMessageRecordIdPositive() {
        Test.startTest();
        dmpl__InterfaceQueue__c jobQueue = JobQueueTestDataHelper.createJobQueue('Interface Job', 'Queueable', 1, null, null);
        dmpl__JobQueueRecord__c jobQueueRecord = JobQueueTestDataHelper.createJobQueueRecord('Host123', 'Test Message', 10, 'Record123', jobQueue);
        Test.stopTest();
        System.assertNotEquals(null, jobQueueRecord, 'Expected Job Queue Record to be created with specified Job Queue ID.');
        System.assertEquals(jobQueue.Id, jobQueueRecord.dmpl__JobQueueId__c, 'Job Queue ID should match');
    }
}