public with sharing class InterfaceQueueService extends MetadataService {
    public static final String OBJECT_INTERFACE_QUEUE = 'dmpl__InterfaceQueue__c';

    public static final String FIELD_INTERFACE_QUEUE_JOB_TYPE = 'dmpl__JobType__c';
    public static final String FIELD_INTERFACE_QUEUE_INTERFACERECORDID = 'dmpl__InterfaceRecordId__c';
    public static final String FIELD_INTERFACE_QUEUE_QUEUE_TYPE = 'dmpl__QueueType__c';
    
    public static final String QUEUE_TYPE_QUEUEABLE = 'Queueable';
    public static final String JOBTYPE_TYPE_CYCLECOUNT_MP = 'Cycle Count Member Processor';

    public InterfaceQueueService(){
        super(OBJECT_INTERFACE_QUEUE);
    }

    public static HeadlessActionResult queueJobType(
        String jobType,
        Id recordId){
        dmpl__InterfaceQueue__c queue = new dmpl__InterfaceQueue__c(
            dmpl__JobType__c = jobType,
            dmpl__InterfaceRecordId__c = recordId,
            dmpl__QueueType__c = QUEUE_TYPE_QUEUEABLE
        );
        SecurityHelper.ensureCanCreateObject(OBJECT_INTERFACE_QUEUE);
        SecurityHelper.ensureCanCreateFields(
            new string[]{
                FIELD_INTERFACE_QUEUE_JOB_TYPE,
                FIELD_INTERFACE_QUEUE_INTERFACERECORDID,
                FIELD_INTERFACE_QUEUE_QUEUE_TYPE
            }, OBJECT_INTERFACE_QUEUE);
        
        insert queue;
        return new HeadlessActionResult(
            true, 
            'The operation was Queued. Please check back in some time. (Queue Id : ' 
                + queue.Id 
                + ')');
    }

    public static CreateRelatedResult queueDocumentAction(
        Id metadataId,
        Id hostId,
        List<SourceObjectInfo> childObjectsInfo){
        dmpl__InterfaceQueue__c queue = new dmpl__InterfaceQueue__c(
            dmpl__JobType__c = 'Document Selector Processor',
            dmpl__InterfaceRecordId__c = metadataId,
            dmpl__InterfaceRecordData__c = hostId,
            dmpl__QueueType__c = QUEUE_TYPE_QUEUEABLE
        );
        SecurityHelper.ensureCanCreateObject(OBJECT_INTERFACE_QUEUE);
        SecurityHelper.ensureCanCreateFields(
            new string[]{
                FIELD_INTERFACE_QUEUE_JOB_TYPE,
                FIELD_INTERFACE_QUEUE_INTERFACERECORDID,
                FIELD_INTERFACE_QUEUE_QUEUE_TYPE
            }, OBJECT_INTERFACE_QUEUE);
        
        insert queue;
        List<dmpl__JobQueueRecord__c> recordsQueue = SourceObjectInfo.generateToQueue(
            queue.Id, 
            childObjectsInfo);
        insert recordsQueue;
        setDocumentInQueue(
            hostId,
            queue.Id);
        return new CreateRelatedResult(
            queue.Id);
    }

    public static CreateRelatedResult queueDocumentAction(
        Id metadataId,
        Id hostId){
        dmpl__InterfaceQueue__c queue = new dmpl__InterfaceQueue__c(
            dmpl__JobType__c = 'Document Selector Processor',
            dmpl__InterfaceRecordId__c = metadataId,
            dmpl__InterfaceRecordData__c = hostId,
            dmpl__QueueType__c = QUEUE_TYPE_QUEUEABLE
        );
        SecurityHelper.ensureCanCreateObject(OBJECT_INTERFACE_QUEUE);
        SecurityHelper.ensureCanCreateFields(
            new string[]{
                FIELD_INTERFACE_QUEUE_JOB_TYPE,
                FIELD_INTERFACE_QUEUE_INTERFACERECORDID,
                FIELD_INTERFACE_QUEUE_QUEUE_TYPE
            }, OBJECT_INTERFACE_QUEUE);
        
        insert queue;
        List<dmpl__JobQueueRecord__c> recordsQueue = SourceObjectInfo.generateToQueue(
            queue.Id, 
            DocumentSelectorController.getChildObjects(metadataId, hostId, null));
        insert recordsQueue;
        setDocumentInQueue(
            hostId,
            queue.Id);
        return new CreateRelatedResult(
            queue.Id);
    }

    private static void setDocumentInQueue(
        Id hostId,
        Id queueId){
            try{
                SObject host = hostId.getSobjectType().newSObject(hostId);
                if(host !=null ){
                    host.put('dmpl__JobQueueId__c', queueId);
                    host.put('dmpl__IsInJobQueue__c', true);
                    update host;
                }
            }catch(Exception error){
                ExceptionLogHelper.logException(error, queueId);
            }
    }
}