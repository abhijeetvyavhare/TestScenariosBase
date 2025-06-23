global class SusbcriptionUsageInvoiceScheduler implements Schedulable{
    global void execute(SchedulableContext sc){
        SubscriptionInvoiceHelper.generateUsageInvoiceSummary();
    }
}