public with sharing class InventoryCycleCountProcessor implements Database.Batchable<SObject> {
    
    public static final Integer BATCH_SIZE = 200;
    private Id invokedQueueId;
    private Id cycleCountId;
    private String batchQuery;

    public static JobResponseResult perfromAction(
        Id recordId,
        Id queueId){
        try {
            dmpl__InventoryCycleCount__c cc = queryCycleCount(recordId);
            Id batchId = Database.executeBatch(
                new InventoryCycleCountProcessor(
                    recordId,
                    queueId,
                    getFilterQuery(cc)
                ), 
                BATCH_SIZE);
            return new JobResponseResult(
                true, 
                null, 
                'Apex Batch Job Enqueued With Job Id ' + batchId);
        } catch (Exception error) {
            ExceptionLogHelper.logException(error, queueId);
            throw error;
        }
    }

    public InventoryCycleCountProcessor(
        Id ccId,
        Id queueId,
        String query){
            invokedQueueId  =queueId;
            cycleCountId = ccId;
            batchQuery = query;
    }

    public Database.QueryLocator start(
        Database.BatchableContext bc){
        try {
            InterfaceQueueHelper.addStatusUpdate(
                invokedQueueId,
                'Starting CycleCount Batch '
            );
            System.debug('Starting Batch Query' + batchQuery);
            return Database.getQueryLocator(batchQuery);
        } catch (Exception error) {
            ExceptionLogHelper.logException(error, invokedQueueId);
            throw error;
        }
    }

    public void execute(
        Database.BatchableContext bc, 
        List<SObject> scope){
        try {
            List<dmpl__InventoryCycleCountLine__c> items = new List<dmpl__InventoryCycleCountLine__c>();
            for(SObject a : scope){
                items.add(
                    new dmpl__InventoryCycleCountLine__c(
                        dmpl__CycleCountId__c = cycleCountId
                    )
                );
            }      
            System.debug('Inserting' + items);
            insert items;
            InterfaceQueueHelper.addStatusUpdate(
                invokedQueueId,
                'Processed Batch Count ' + scope.size()
            );
        } catch (Exception error) {
            ExceptionLogHelper.logException(error, invokedQueueId);
            throw error;
        }
    }
  
    public void finish(
        Database.BatchableContext bc){
            InterfaceQueueHelper.addStatusUpdate(
                invokedQueueId,
                'Finished CycleCount Batch '
            );
        try {
            Database.executeBatch(
                new InventoryCycleCountCleaner(
                    bc.getJobId(),
                    invokedQueueId,
                    cycleCountId
                ), 
                BATCH_SIZE);
        } catch (Exception error) {
            ExceptionLogHelper.logException(error, invokedQueueId);
            throw error;
        }
    }

    @testVisible
    private static String getFilterQuery(dmpl__InventoryCycleCount__c cc){
        String dbQuery = 'SELECT Id FROM Account ';
        System.debug('Query ' + dbQuery);
        return dbQuery;
    }

    private static dmpl__InventoryCycleCount__c queryCycleCount(Id cycleCountId){
        return [
            SELECT 
                Id
            FROM dmpl__InventoryCycleCount__c
            WHERE 
                Id =:cycleCountId
        ];
    }
}