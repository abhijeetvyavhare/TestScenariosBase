@isTest
private class SubscriptionInvoiceScheduler_Test {
    @isTest
    static void testSchedulerExecution() {
        
        String cronExp = '0 0 0 * * ?'; // Run the job daily at midnight
        String jobId = System.schedule('Test Subscription Invoice Scheduler', cronExp, new SubscriptionInvoiceScheduler());
        
        Test.startTest();
        SubscriptionInvoiceHelper.generateRecurringInvoiceSummary();
        Test.stopTest();
    }
}