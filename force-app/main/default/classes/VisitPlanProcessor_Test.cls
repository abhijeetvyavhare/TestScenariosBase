@isTest
private class VisitPlanProcessor_Test {
    
    @testSetup
    static void setupTestData() {
        dmpl__Resource__c resource = new dmpl__Resource__c(Name='Test Resource');
        insert resource;

        dmpl__VisitRoute__c visitRoute = new dmpl__VisitRoute__c(
            Name = 'Test Route',
            dmpl__ResourceId__c = resource.Id,
            dmpl__VisitPurpose__c = 'Order Delivery',
            //dmpl__VisitTaskTemplateId__c = 'TestTemplate',
            dmpl__StartTime__c = System.now().time()
        );
        insert visitRoute;

        dmpl__VisitRouteStop__c visitRouteStop = new dmpl__VisitRouteStop__c(
            dmpl__VisitRouteId__c = visitRoute.Id,
            dmpl__AccountId__c = null 
        );
        insert visitRouteStop;

        visitRoute = [SELECT Id, (SELECT Id FROM dmpl__VisitRouteStops__r) FROM dmpl__VisitRoute__c WHERE Id = :visitRoute.Id];
    }

    @isTest
    static void testBatchExecution() {
        Test.startTest();
        
        String testQuery = 'SELECT Id, Name, dmpl__ResourceId__c FROM dmpl__VisitRoute__c';
        Id testQueueId; 
        
        VisitPlanProcessor batchInstance = new VisitPlanProcessor(testQuery, testQueueId);
        Id batchJobId = Database.executeBatch(batchInstance, VisitPlanProcessor.BATCH_SIZE);
        
        Test.stopTest();
        
        System.assertNotEquals(batchJobId, null, 'Batch job should be successfully enqueued.');
    }

    @isTest
    static void testPerformAction() {
        Test.startTest();
        
        Id recordId = [SELECT Id FROM dmpl__VisitRoute__c LIMIT 1].Id;
        Id queueId;
        
        JobResponseResult response = VisitPlanProcessor.perfromAction(recordId, queueId);
        
        Test.stopTest();
        
        System.assert(response != null, 'JobResponseResult should not be null.');
        //System.assert(response.success, 'The batch job should be enqueued successfully.');
        System.assert(response.message.contains('Apex Batch Job Enqueued'), 'Success message should indicate job was enqueued.');
    }

    @isTest
    static void testHelperMethods() {
        List<dmpl__VisitRoute__c> visitRoutes = [SELECT Id, dmpl__ResourceId__c FROM dmpl__VisitRoute__c];

        Map<Id, List<dmpl__VisitRoute__c>> result = VisitPlanProcessor.getResourceToVisitRoutes(visitRoutes);

        System.assert(result != null, 'Result should not be null.');
        System.assert(result.size() > 0, 'Result map should have at least one entry.');
    }
}