public with sharing class InterfaceServiceProviderSchedulable implements Schedulable {
    
    public void execute(SchedulableContext sc) {
        executeSchedule(sc.getTriggerId().to15());
    }

    @testvisible
    public static void executeSchedule(String scheduleId){
        Id queueObjectId = null;
        try {
            dmpl__InterfaceQueue__c queue = queryInterfaceQueue(scheduleId);
            if(queue == null){
                throw new DMPLException('Queued Job Not Found');
            }
            queueObjectId = queue.Id;
            JobResponseResult result = null;
            try {
                result = JobTypeHelper.executeJob(queue);
                    
            } catch (Exception ex) {                
                ExceptionLogHelper.logException(
                    ex,
                    queueObjectId);
            }
            //
            if(result!=null && result.isSuccessful){
                if(result instanceof FileResponseResult){
                    FileResponseResult fileResult = (FileResponseResult)result;
                    if(fileResult.hasIncrementalData){
                        InterfaceQueueHelper.addFileToQueue(
                            (String)fileResult.fileContent,
                            fileResult.fileName,
                            fileResult.fileTitle,
                            queue.Id);    
                    }
                }
                InterfaceQueueHelper.completeQueJob(
                    queue,
                    result);
            }else{
                InterfaceQueueHelper.updateAttemptCount(
                    queue,
                    result);
            }
        } catch (Exception error) {
            ExceptionLogHelper.logException(
                error,
                queueObjectId);
            throw error;
        }
    }

    @testvisible
    private static dmpl__InterfaceQueue__c queryInterfaceQueue(String queueId){
        SecurityHelper.ensureCanReadFields(new string[]{
            'dmpl__ApexJobId__c',
            'dmpl__InterfaceProviderId__c',
            'dmpl__InterfaceRequestId__c',
            'dmpl__InterfaceRecordId__c',
            'dmpl__AttemptCount__c',
            'dmpl__RetryCount__c',
            'dmpl__IsPoison__c',
            'dmpl__IsSuccessful__c'}, 
            'dmpl__InterfaceQueue__c');
        return [
            SELECT 
            Id, 
            Name, 
            dmpl__ApexJobId__c,
            dmpl__InterfaceProviderId__c, 
            dmpl__InterfaceRequestId__c, 
            dmpl__InterfaceRecordId__c,
            dmpl__AttemptCount__c, 
            dmpl__RetryCount__c,
            dmpl__IsPoison__c,
            dmpl__ExecutionLog__c,
            dmpl__JobType__c,
            dmpl__IsSuccessful__c,
            dmpl__CustomProcessorName__c,
            dmpl__CustomActionName__c
            FROM dmpl__InterfaceQueue__c
            WHERE dmpl__ApexJobId__c =:queueId];
    }
}