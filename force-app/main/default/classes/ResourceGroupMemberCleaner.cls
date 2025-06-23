public with sharing class ResourceGroupMemberCleaner implements Database.Batchable<SObject> {
    
    private Id batchInstanceId;
    private Id invokedQueueId;
    private Id ResourceGroupId;

    public ResourceGroupMemberCleaner(
        Id batchId,
        Id queueId){
            invokedQueueId = queueId;
            batchInstanceId = batchId;
    }

    public ResourceGroupMemberCleaner(
        Id batchId,
        Id queueId,
        Id groupId){
            invokedQueueId = queueId;
            batchInstanceId = batchId;
            ResourceGroupId = groupId;
    }

    public Database.QueryLocator start(
        Database.BatchableContext bc){
        try {
            String dbQuery = String.format('SELECT Id FROM dmpl__ResourceGroupMember__c WHERE dmpl__BatchInstanceId__c != {0} AND dmpl__BatchInstanceId__c != null AND dmpl__ResourceGroupId__c = {1}',
                new List<String>{
                    '\''+ batchInstanceId + '\'',
                    '\''+ ResourceGroupId + '\''
                });
            System.debug('Query ' + dbQuery);
            InterfaceQueueHelper.addStatusUpdate(
                invokedQueueId,
                'Starting AG Cleanup Batch '
            );
            return Database.getQueryLocator(dbQuery);
        } catch (Exception error) {
            ExceptionLogHelper.logException(error, invokedQueueId);
            throw error;
        }
    }

    public void execute(
        Database.BatchableContext bc, 
        List<SObject> scope){
        try {
            delete scope;
            DataBase.emptyRecycleBin(scope);
            InterfaceQueueHelper.addStatusUpdate(
                invokedQueueId,
                'Processed AG Cleanup Batch Size ' + scope.size()
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
                'Finished AG Cleanup Batch '
            );
    }
}