public with sharing class InterfaceQueueHelper {

    private static final string QUEUE_TYPE = 'Queueable';
    private static final string EVENT_TYPE = 'Event';
    private static final string SCHEDULE_TYPE = 'Schedulable';
    private static final string FLOW_TYPE = 'Flow';
    
    private static Boolean skipValidations = false;

    private static final List<String> LIST_FIELDS_SYSTEM = new List<String>
    {
        'dmpl__AttemptCount__c',
        'dmpl__IsPoison__c',
        'dmpl__ApexJobId__c',
        'dmpl__AttemptCount__c',
        'dmpl__IsSuccessful__c',
        'dmpl__SourceApexJobId__c'
    };

    public static void validateData(
        Boolean isInsert, 
        Boolean isDelete, 
        Boolean isUpdate,
        List<dmpl__InterfaceQueue__c> oldEntries, 
        List<dmpl__InterfaceQueue__c> newEntries)
    {
        try{
            if(isInsert){
                FieldMappingHelper.copyFieldMappingData(
                    newEntries);
            }
            if(skipValidations){
                return;
            }

            if(isInsert){
                DocumentHelper.validateChangeInSystemFields(LIST_FIELDS_SYSTEM, newEntries);
                ValidateMaxRetryCount(newEntries);
            }else if(isUpdate){
                DocumentHelper.validateChangeInSystemFields(LIST_FIELDS_SYSTEM, oldEntries, newEntries);
                ValidateMaxRetryCount(newEntries);
            }
        } catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }

    public static void postData(
        Boolean isInsert, 
        Boolean isDelete, 
        Boolean isUpdate, 
        List<dmpl__InterfaceQueue__c> oldEntries, 
        List<dmpl__InterfaceQueue__c> newEntries)
    {
        try{
            TimeZone tz = UserInfo.getTimeZone();
            if(isInsert){
                for(dmpl__InterfaceQueue__c entry : newEntries){
                    entry.dmpl__ExecutionLog__c = 
                        String.format(
                            '{0} - Queued',
                            new List<Object>
                            {
                                Datetime.now().format(
                                    'MM/dd/yyyy HH:mm:ss', 
                                    tz.getID())
                            });
                }
            }
            if(isInsert){
                for(dmpl__InterfaceQueue__c entry : newEntries){
                    if(entry.dmpl__QueueType__c == QUEUE_TYPE){
                        enqueueJob(entry);
                    }else if(entry.dmpl__QueueType__c == SCHEDULE_TYPE){
                        scheduleJob(entry);
                    }
                }    
            }
        } catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }

    public static void afterPostData(
        Boolean isInsert, 
        Boolean isDelete, 
        Boolean isUpdate, 
        List<dmpl__InterfaceQueue__c> oldEntries, 
        List<dmpl__InterfaceQueue__c> newEntries)
    {
        try{
            if(isInsert){
                for(dmpl__InterfaceQueue__c entry : newEntries){
                    if(entry.dmpl__QueueType__c == EVENT_TYPE){
                        raiseEvent(entry);
                    }
                }    
            }
        } catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }
    
    public static void addStatusUpdate(
        Id queueId,
        String status){
        try {
            if(queueId == null){
                return;
            }
            skipValidations = true;
            dmpl__InterfaceQueue__c queue = queryQueue(queueId);
            if(queue == null){
                return;
            }
            String executionLog = queue.dmpl__ExecutionLog__c 
                + String.format(
                    '\r\n{0} - Update: {1}',
                    new List<Object>
                    {
                        Datetime.now().format(
                            'MM/dd/yyyy HH:mm:ss', 
                            UserInfo.getTimeZone().getID()),
                        status
                    });
            queue.dmpl__ExecutionLog__c = executionLog.abbreviate(130000);
            SecurityHelper.ensureCanWriteFields(new string[]{
                    'dmpl__AttemptCount__c',
                    'dmpl__IsPoison__c',
                    'dmpl__SourceApexJobId__c'
            }, 'dmpl__InterfaceQueue__c');
            UPDATE queue;    
        }catch(Exception ex){
            ExceptionLogHelper.logException(ex, queueId);
        } finally {
            skipValidations = false;
        }
    }

    public static void markJobCompleted(
        Id queueId,
        String status){
        try {
            if(queueId == null){
                return;
            }
            skipValidations = true;
            dmpl__InterfaceQueue__c queue = queryQueue(queueId);
            if(queue == null){
                return;
            }
            String executionLog = queue.dmpl__ExecutionLog__c 
                + String.format(
                    '\r\n{0} - Update: {1}',
                    new List<Object>
                    {
                        Datetime.now().format(
                            'MM/dd/yyyy HH:mm:ss', 
                            UserInfo.getTimeZone().getID()),
                        status
                    });
            queue.dmpl__ExecutionLog__c = executionLog.abbreviate(131000);
            queue.dmpl__IsApexJobExecuted__c = true;
            SecurityHelper.ensureCanWriteFields(new string[]{
                    'dmpl__AttemptCount__c',
                    'dmpl__IsPoison__c',
                    'dmpl__SourceApexJobId__c'
            }, 'dmpl__InterfaceQueue__c');
            UPDATE queue;    
        }catch(Exception ex){
            ExceptionLogHelper.logException(ex, queueId);
        } finally {
            skipValidations = false;
        }
    }
    
    public static void updateAttemptCount(
        dmpl__InterfaceQueue__c queue,
        JobResponseResult result){
        try {
            skipValidations = true;
            queue.dmpl__AttemptCount__c = (queue.dmpl__AttemptCount__c == null?0:queue.dmpl__AttemptCount__c) +1;
            queue.dmpl__SourceApexJobId__c = queue.dmpl__ApexJobId__c;
            queue.dmpl__ExecutionLog__c = queue.dmpl__ExecutionLog__c 
                + String.format(
                    '\r\n{0} - Result: {1} Message: {2}',
                    new List<Object>
                    {
                        Datetime.now().format(
                            'MM/dd/yyyy HH:mm:ss', 
                            UserInfo.getTimeZone().getID()),
                        result?.isSuccessful,
                        result?.message
                    });
            if(queue.dmpl__AttemptCount__c >= (queue.dmpl__RetryCount__c == null? 0:queue.dmpl__RetryCount__c)){
                queue.dmpl__IsPoison__c = true;
            }else{
                enqueueJob(queue);
            }
            SecurityHelper.ensureCanWriteFields(new string[]{
                    'dmpl__AttemptCount__c',
                    'dmpl__IsPoison__c',
                    'dmpl__SourceApexJobId__c'
            }, 'dmpl__InterfaceQueue__c');
            UPDATE queue;    
        } finally {
            skipValidations = false;
        }
    }

    public static void completeQueJob(
        dmpl__InterfaceQueue__c queue,
        JobResponseResult result){
        try {
            skipValidations = true;
            queue.dmpl__AttemptCount__c = (queue.dmpl__AttemptCount__c == null?0:queue.dmpl__AttemptCount__c) +1;
            queue.dmpl__IsSuccessful__c = true;
            queue.dmpl__ExecutionLog__c = queue.dmpl__ExecutionLog__c 
                + String.format(
                    '\r\n{0} - Result: {1} Message: {2}',
                    new List<Object>
                    {
                        Datetime.now().format(
                            'MM/dd/yyyy HH:mm:ss', 
                            UserInfo.getTimeZone().getID()),
                        result?.isSuccessful,
                        result?.message
                    });
            SecurityHelper.ensureCanWriteFields(new string[]{
                'dmpl__AttemptCount__c',
                'dmpl__IsSuccessful__c'
            }, 'dmpl__InterfaceQueue__c');
            UPDATE queue;    
        } finally {
            skipValidations = false;
        }
    }

    public static void addFileToQueue(
        String fileContenet, 
        String fileName, 
        String title, 
        Id queueId){
        ContentVersion conVer = new ContentVersion();
        conVer.ContentLocation = 'S';
        conVer.PathOnClient = fileName;
        conVer.Title = title;
        conVer.VersionData = Blob.valueOf(fileContenet);
        insert conVer;

        Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id].ContentDocumentId;
        ContentDocumentLink conDocLink = New ContentDocumentLink();
        conDocLink.LinkedEntityId = queueId;
        conDocLink.ContentDocumentId = conDoc;
        conDocLink.shareType = 'V';
        insert conDocLink;
    }

    private static void raiseEvent(dmpl__InterfaceQueue__c entry){
        if(entry.dmpl__IsPoison__c){
            return;
        }
        dmpl__InterfaceQueueEvent__e qEvent = new dmpl__InterfaceQueueEvent__e(
            InterfaceQueueName__c = entry.Name,
            InterfaceQueueId__c = entry.Id
        );
        Database.SaveResult result = EventBus.publish(qEvent);
    }

    private static void enqueueJob(dmpl__InterfaceQueue__c entry){
        if(entry.dmpl__IsPoison__c){
            return;
        }
        InterfaceServiceProviderQueueable newQueue = new InterfaceServiceProviderQueueable();
        entry.dmpl__ApexJobId__c = System.enqueueJob(newQueue);        
    }

    @testVisible
    private static void scheduleJob(dmpl__InterfaceQueue__c entry){
        try {
            System.abortJob(entry.dmpl__ApexJobId__c);
        } catch (Exception e) {}
        InterfaceServiceProviderSchedulable newSchedule = new InterfaceServiceProviderSchedulable();
        String jobName = entry.dmpl__SchedulableJobName__c;
        entry.dmpl__ApexJobId__c = System.schedule(
            jobName, 
            entry.dmpl__CronExpression__c, 
            newSchedule);
    }

    private static dmpl__InterfaceQueue__c queryQueue(Id queueId){
        List<dmpl__InterfaceQueue__c> queues =  
        [
            SELECT Id, dmpl__ExecutionLog__c FROM dmpl__InterfaceQueue__c WHERE Id =:queueId
        ];
        if(queues!=null && queues.size()>0){
            return queues[0];
        }
        return null;
    }

    private static void ValidateMaxRetryCount(List<dmpl__InterfaceQueue__c> newEntries){
        for(dmpl__InterfaceQueue__c entry : newEntries){
            if(entry.dmpl__RetryCount__c > 4){
                entry.addError('Retry count should be less than or equal to 4!');
            }
        }
    }
}