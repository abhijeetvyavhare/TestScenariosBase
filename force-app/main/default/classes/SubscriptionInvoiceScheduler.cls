global class SubscriptionInvoiceScheduler implements Schedulable{
    global void execute(SchedulableContext sc){
        SubscriptionInvoiceHelper.generateRecurringInvoiceSummary();
    }
}