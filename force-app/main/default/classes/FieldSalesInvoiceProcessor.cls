public class FieldSalesInvoiceProcessor implements Database.Batchable<SObject> {
    public static Integer BATCH_SIZE = 200;
    private Id invokedQueueId;
    private Id fieldSalesId;
    private String batchQuery;

    public FieldSalesInvoiceProcessor(String query, Id queueId,Id fieldInvoiceId) {
        this.batchQuery = query;
        this.invokedQueueId = queueId;
        this.fieldSalesId = fieldInvoiceId;
    }

    public static JobResponseResult performAction(Id recordId, Id queueId) {
        try {
            return processFieldSaleInvoices(recordId, queueId);
        } catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }

    public static JobResponseResult processFieldSaleInvoices(Id recordId, Id queueId) {
        String query = buildQueryForFieldSaleInvoice(recordId);
        Id batchId = Database.executeBatch(
            new FieldSalesInvoiceProcessor(query, queueId,recordId), BATCH_SIZE);
        return new JobResponseResult(true, null, 'Apex Batch Job Enqueued With Job Id ' + batchId);
    }

    public Database.QueryLocator start(Database.BatchableContext bc) {
        try {
            InterfaceQueueHelper.addStatusUpdate(invokedQueueId, 'Starting Field Sale Batch');
            System.debug('Starting Batch Query: ' + batchQuery);
            return Database.getQueryLocator(batchQuery);
        } catch (Exception error) {
            ExceptionLogHelper.logException(error, invokedQueueId);
            throw error;
        }
    }

    public void execute(Database.BatchableContext bc, List<SObject> scope) {
        // Extract Invoice Ids from the scope
        List<Id> saleInvoiceIds = DocumentHelper.extractIds(scope, 'dmpl__InvoiceId__c');
    
        // Query SaleInvoiceLine records associated with the extracted Invoice Ids
        List<dmpl__SaleInvoiceLine__c> saleInvoiceLines = querySaleInvoiceLines(saleInvoiceIds);
    
        // Prepare lists for updates
        List<dmpl__SaleInvoiceLine__c> invoiceLineToUpdate = new List<dmpl__SaleInvoiceLine__c>();
        List<dmpl__SaleInvoice__c> invoicesToUpdate = new List<dmpl__SaleInvoice__c>();
    
        // Iterate over each invoice in the scope
        for (SObject invoice : scope) {
            Id invoiceId = (Id) invoice.get('dmpl__InvoiceId__c');
            Id fieldSalesId = (Id) invoice.get('dmpl__FieldSalesId__c');
    
            // Update SaleInvoiceLine records
            for (dmpl__SaleInvoiceLine__c line : saleInvoiceLines) {
                if (line.dmpl__SaleInvoiceId__c == invoiceId) {
                    dmpl__SaleInvoiceLine__c lineToUpdate = new dmpl__SaleInvoiceLine__c();
                    lineToUpdate.Id = line.Id;
                    lineToUpdate.dmpl__FieldSalesId__c = fieldSalesId;
                    invoiceLineToUpdate.add(lineToUpdate);
                }
            }
    
            // Update the SaleInvoice record
            dmpl__SaleInvoice__c invoiceToUpdate = new dmpl__SaleInvoice__c();
            invoiceToUpdate.Id = invoiceId;
            invoiceToUpdate.dmpl__FieldSalesId__c = fieldSalesId;
            invoicesToUpdate.add(invoiceToUpdate);
        }
    
        // Debug and perform DML updates
        if (!invoiceLineToUpdate.isEmpty()) {
            System.debug('Invoice Lines to Update: ' + invoiceLineToUpdate);
            update invoiceLineToUpdate;
        }
    
        if (!invoicesToUpdate.isEmpty()) {
            System.debug('Invoices to Update: ' + invoicesToUpdate);
            update invoicesToUpdate;
        }
    }    

    public void finish(Database.BatchableContext bc) {
        try {
            InterfaceQueueHelper.addStatusUpdate(invokedQueueId, 'Field Sales Batch Completed');
        } catch (Exception error) {
            ExceptionLogHelper.logException(error, invokedQueueId);
        }
    }

    private static String buildQueryForFieldSaleInvoice(Id fieldSalesId) {
        return 'SELECT Id, dmpl__FieldSalesId__c, dmpl__InvoiceId__c FROM dmpl__FieldSalesInvoice__c WHERE dmpl__FieldSalesId__c = :fieldSalesId';
    }
    private static List<dmpl__SaleinvoiceLine__c> querySaleInvoiceLines(List<Id>saleInvoiceIds){
        return [SELECT Id,dmpl__SaleInvoiceId__c FROM dmpl__SaleinvoiceLine__c WHERE dmpl__SaleInvoiceId__c IN: saleInvoiceIds];
    }
}