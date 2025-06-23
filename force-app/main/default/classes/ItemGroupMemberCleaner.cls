public with sharing class ItemGroupMemberCleaner implements Database.Batchable<SObject> {
    
        private Id batchInstanceId;
        private Id invokedQueueId;
        private Id itemGroupId;
    
        public ItemGroupMemberCleaner(
            Id batchId,
            Id queueId){
                invokedQueueId = queueId;
                batchInstanceId = batchId;
        }

        public ItemGroupMemberCleaner(
            Id batchId,
            Id queueId,
            Id groupId){
                invokedQueueId = queueId;
                batchInstanceId = batchId;
                itemGroupId = groupId;
        }
    
        public Database.QueryLocator start(
            Database.BatchableContext bc){
                ExceptionLogHelper.logMessage('STARTED');
            try {                
                String dbQuery = String.format('SELECT Id FROM dmpl__ItemGroupMember__c WHERE dmpl__BatchInstanceId__c != {0} AND dmpl__BatchInstanceId__c != null AND dmpl__ItemGroupId__c = {1}',
                    new List<String>{
                        '\''+ (batchInstanceId == null ? '' : batchInstanceId)+ '\'',
                        '\''+ (itemGroupId == null ? '' : itemGroupId)+ '\''
                    });
                ExceptionLogHelper.logMessage('STARTED Query ' + dbQuery);
                InterfaceQueueHelper.addStatusUpdate(
                    invokedQueueId,
                    'Starting IG Cleanup Batch'
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
                    'Processed IG Cleanup Batch Size ' + scope.size()
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
                    'Finished IG Cleanup Batch'
                );
        }
    }