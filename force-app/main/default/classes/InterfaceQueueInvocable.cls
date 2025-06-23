public with sharing class InterfaceQueueInvocable {
    /**
     * @description Internal custom exception class
     */
    @TestVisible
    public class DMPLInvocableMethodException extends Exception {
    }

    /**
     *  @description inner class that represents an incoming search request
     */
    @TestVisible
    public class ExecuteQueueActionRequest {
        @InvocableVariable(
            label='Queue Id String - Input'
            description='Queue to execute'
            required=true
        )
        
        public Id queueId;
    }

    /**
     *  @description Represents the output from the invocable method
     */
    @TestVisible
    public class ExecuteQueueActionResult {
        @InvocableVariable(
            label='Http Response Received - Output'
            description='Http Response received on execution of the Request'
            required=true
        )
        public ExecuteQueueActionRequest input;
        public String errorMessage;
        public JobResponseResult output;
        /**
         * @description    Constructor building output object from SObject
         * @param toOutput  Object to output
         */
        public ExecuteQueueActionResult(
            ExecuteQueueActionRequest request, 
            JobResponseResult toOutput) {
                this.input = request;
                this.output = toOutput;
        }

        public ExecuteQueueActionResult(
            ExecuteQueueActionRequest request, 
            String error) {
                this.input = request;
                this.errorMessage = error;
        }
    }

     /**
     * @param inputParams A ExecuteActionRequest object
     * @return ExecuteActionResult
     * @example
     **/
    @InvocableMethod(
        label='Execute Action'
        description='Execute action as identified by the Queue Id'
    )
    public static List<ExecuteQueueActionResult> executeAction(
        List<ExecuteQueueActionRequest> inputParams
    ) {
        List<ExecuteQueueActionResult> results = new List<ExecuteQueueActionResult>();
        for(ExecuteQueueActionRequest inputParam : inputParams){
            try {
                results.add(new ExecuteQueueActionResult(inputParam, executeActionInternal(inputParam)));
            } catch (Exception error) {
                results.add(new ExecuteQueueActionResult(inputParam, error.getMessage()));
            }
        }
        return results;
    }

    @TestVisible
    private static JobResponseResult executeActionInternal(ExecuteQueueActionRequest inputParam){
        Id queueId = inputParam.queueId;
        Id queueObjectId = null;
        try {
            dmpl__InterfaceQueue__c queue = queryInterfaceQueue(queueId);
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
            return result;
        } catch (Exception error) {
            ExceptionLogHelper.logException(
                error, 
                queueObjectId);
            throw error;
        }
    }

    @TestVisible
    private static dmpl__InterfaceQueue__c queryInterfaceQueue(Id queueId){

        SecurityHelper.ensureCanReadFields(new string[]{
            'dmpl__ApexJobId__c',
            'dmpl__InterfaceProviderId__c',
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
            dmpl__InterfaceRecordData__c,
            dmpl__CustomProcessorName__c,
            dmpl__CustomActionName__c
            FROM dmpl__InterfaceQueue__c
            WHERE Id =:queueId];
    }
}