public with sharing class DocumentSelectorProcessor implements Database.Batchable<SObject>, Database.Stateful {
    
    public static final Integer BATCH_SIZE = 50;
    private Id metadataId;
    private Id hostId;
    private Id invokedQueueId;
    private String batchQuery;
    public Map<String, Id> resultDocuments;

    public static JobResponseResult perfromAction(
        Id metadataId,
        Id hostId,
        Id queueId){
        try {
            dmpl__CreateRelatedSetting__mdt recordSetting = CreateRelatedSettingHelper.getCreateRelatedSetting(metadataId);
            Decimal asyncRecordCount = recordSetting.dmpl__AsyncRecordCount__c == null ? BATCH_SIZE : recordSetting.dmpl__AsyncRecordCount__c;
            Id batchId = Database.executeBatch(
                new DocumentSelectorProcessor(
                    metadataId,
                    hostId,
                    queueId,
                    getFilterQuery(queueId)
                ), 
                asyncRecordCount.intValue());
            return new JobResponseResult(
                true, 
                null, 
                'Apex Batch Job Enqueued With Job Id ' + batchId);
        } catch (Exception error) {
            ExceptionLogHelper.logException(
                error, 
                queueId);
            throw error;
        }
    }

    public DocumentSelectorProcessor(
        Id metadataId,
        Id hostId,
        Id queueId,
        String query) {
            this.metadataId = metadataId;
            this.hostId = hostId;
            this.invokedQueueId = queueId;
            this.batchQuery = query;
            this.resultDocuments = new Map<String, Id>(); 
    }
    
    public Database.QueryLocator start(
        Database.BatchableContext bc){
        try {
            InterfaceQueueHelper.addStatusUpdate(
                invokedQueueId,
                'Starting Document Processor '
            );
            return Database.getQueryLocator(batchQuery);
        } catch (Exception error) {
            ExceptionLogHelper.logException(
                error, 
                invokedQueueId);
            throw error;
        }
    }

    public void execute(
        Database.BatchableContext bc, 
        List<SObject> scope){
        try {
            for(String sourceKey : this.resultDocuments.keySet()){
                System.debug('Retreived ' + sourceKey + '-' + this.resultDocuments.get(sourceKey));
            }
            CreateRelatedResult result = DocumentSelectorController.releaseChildDocuments(
                metadataId, 
                hostId, 
                SourceObjectInfo.generateFromQueue(
                    scope,
                    this.resultDocuments));
            if(result.resultDocuments!=null){
                for(String sourceKey : result.resultDocuments.keySet()){
                    System.debug('Storing ' + sourceKey + '-' + result.resultDocuments.get(sourceKey).Id);
                    this.resultDocuments.put(
                        sourceKey, 
                        result.resultDocuments.get(sourceKey).Id);
                }
            }
            delete scope;
            Database.emptyRecycleBin(scope);
            InterfaceQueueHelper.addStatusUpdate(
                invokedQueueId,
                'Processed Record Count ' + scope.size()
            );
        } catch (Exception error) {
            ExceptionLogHelper.logException(
                error, 
                invokedQueueId);
            throw error;
        }
    }
  
    public void finish(
        Database.BatchableContext bc){
        try {
            setDocumentNotInQueue(this.hostId, this.invokedQueueId);
            InterfaceQueueHelper.markJobCompleted(
                invokedQueueId,
                'Apex Batch Job Completed.'
            );
        } catch (Exception error) {
            ExceptionLogHelper.logException(
                error, 
                invokedQueueId);
            throw error;
        }
    }
    
    private static void setDocumentNotInQueue(
        Id hostId,
        Id queueId){
            try{
                SObject host = hostId.getSobjectType().newSObject(hostId);
                if(host !=null ){
                    host.put('dmpl__IsInJobQueue__c', false);
                    update host;
                }
            }catch(Exception error){
                ExceptionLogHelper.logException(error, queueId);
            }
    }

    private static String getFilterQuery(Id jobQueueId){
        String dbQuery = 'SELECT Id, dmpl__RecordApiName__c, dmpl__RecordId__c, dmpl__Quantity__c, dmpl__HostId__c, dmpl__RecordData__c, dmpl__SettingId__c, dmpl__MetadataId__c FROM dmpl__JobQueueRecord__c WHERE dmpl__JobQueueId__c = \'' + jobQueueId + '\'';
        System.debug('Query ' + dbQuery);
        return dbQuery;
    }

}