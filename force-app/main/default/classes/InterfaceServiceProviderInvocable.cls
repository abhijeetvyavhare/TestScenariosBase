public with sharing class InterfaceServiceProviderInvocable {
    /**
     * @description Internal custom exception class
     */
    public class DMPLInvocableMethodException extends Exception {
    }

    /**
     *  @description inner class that represents an incoming search request
     */
    public class ExecuteActionRequest {
        @InvocableVariable(
            label='Generic SObject recordId - Input'
            description='Input variable for generic SObject Id'
            required=true
        )
        public Id input;
        
        @InvocableVariable(
            label='Interface Provider Id - Input'
            description='Id of the Interface provider to execute'
            required=true
        )
        public Id providerId;

        @InvocableVariable(
            label='Interface Request Id - Input'
            description='Request Id to execute'
            required=true
        )
        public Id requestId;

        @InvocableVariable(
            label='Job Type String - Input'
            description='Job Type to execute'
            required=true
        )
        
        public Id jobType;
    }

    /**
     *  @description Represents the output from the invocable method
     */
    public class ExecuteActionResult {
        @InvocableVariable(
            label='Http Response Received - Output'
            description='Http Response received on execution of the Request'
            required=true
        )
        public ExecuteActionRequest input;
        public String errorMessage;
        public JobResponseResult output;
        /**
         * @description    Constructor building output object from SObject
         * @param toOutput  Object to output
         */
        public ExecuteActionResult(
            ExecuteActionRequest request, 
            JobResponseResult toOutput) {
                this.input = request;
                this.output = toOutput;
        }

        public ExecuteActionResult(
            ExecuteActionRequest request, 
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
        description='Execute action as identified by the Service Provider and Request Id'
    )
    public static List<ExecuteActionResult> executeAction(
        List<ExecuteActionRequest> inputParams
    ) {
        List<ExecuteActionResult> results = new List<ExecuteActionResult>();
        for(ExecuteActionRequest inputParam : inputParams){
            try {
                results.add(new ExecuteActionResult(inputParam, executeActionInternal(inputParam)));
            } catch (Exception error) {
                results.add(new ExecuteActionResult(inputParam, error.getMessage()));
            }
        }
        return results;
    }

    public static JobResponseResult executeActionInternal(
        ExecuteActionRequest inputParam) {
        return JobTypeHelper.executeJob(
            inputParam.jobType,
            inputParam.providerId, 
            inputParam.requestId,
            inputParam.input);
    }

}