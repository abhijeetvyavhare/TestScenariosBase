public with sharing class CustomProcessor implements Callable, Database.Batchable<SObject> {
    
    public static final Integer BATCH_SIZE = 200;
    private Id invokedQueueId;
    private Id recordId;

    public Object call(
        String action, 
        Map<String, Object> args){
        switch on action {
            when 'performAction' {
                return perfromAction(
                    (Id)args.get('recordId'),
                    (Id)args.get('queueId'));
            }
            when else {
                throw new DMPLException('Method not implemented');
            }
        }
    }

    public JobResponseResult perfromAction(
        Id recordId,
        Id queueId){
        try {
            Id batchId = Database.executeBatch(
                new CustomProcessor(
                    recordId,
                    queueId), 
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

    public CustomProcessor(){
        this.invokedQueueId = null;
        this.recordId = null;
    }

    public CustomProcessor(
        Id recordId,
        Id queueId){
            this.invokedQueueId = queueId;
            this.recordId = recordId;
    }

    public Database.QueryLocator start(
        Database.BatchableContext bc){
        try {
            InterfaceQueueHelper.addStatusUpdate(
                invokedQueueId,
                'Starting Processor Batch '
            );
            return Database.getQueryLocator('SELECT Id FROM Account');
        } catch (Exception error) {
            ExceptionLogHelper.logException(error, invokedQueueId);
            throw error;
        }
    }

    public void execute(
        Database.BatchableContext bc, 
        List<SObject> scope){
        try {
            for(SObject account : scope){

            }      
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
                'Finished Batch '
            );
    }
}