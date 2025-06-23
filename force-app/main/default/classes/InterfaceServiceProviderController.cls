public with sharing class InterfaceServiceProviderController {

    public static final String PROVIDERTYPE_REST = 'REST Client';
    public static final String JOBTYPE_INTERFACE = 'Interface Job';
    public static final String QUEUETYPE_QUEUE = 'Queueable';
    public static final String QUEUETYPE_SCHEDULE = 'Schedulable';
    public static final String QUEUETYPE_MANUAL = 'Manual';
    
    @AuraEnabled
    public static RestResponseResult testAction(
        Id providerId,
        Id requestId,
        Id recordId,
        String headers,
        String query,
        String payload){
        try {
            dmpl__InterfaceServiceProvider__c tsProvider = InterfaceServiceProviderHelper.getProvider(
                providerId
            );

            if(tsProvider == null){
                throw new DMPLException(
                    String.format(
                        String.valueOf(
                            System.Label.Generic_MissingObject), 
                            new String[]
                            {
                                dmpl__InterfaceServiceProvider__c.class.getName()
                            }));    
            }

            if(tsProvider.dmpl__ProviderType__c == GenericRestClient.PROVIDERTYPE_REST){
                GenericRestClient client = new GenericRestClient(tsProvider);
                return client.startRequest(
                    requestId,
                    recordId,
                    payload,
                    headers,
                    query);
            }else if(tsProvider.dmpl__ProviderType__c == FileClient.PROVIDERTYPE_FILE){
                FileClient client = new FileClient(tsProvider);
                FileResponseResult result = client.startRequest(
                    requestId,
                    recordId,
                    payload);
                return new RestResponseResult(
                    null,
                    (String)result.fileContent,
                    result.isSuccessful?200:500,
                    result.isSuccessful?'Success':'Failed',                    
                    result.parsedRequest
                );
            } else {
                throw new DMPLException(
                    String.format(
                        String.valueOf(
                            System.Label.Generic_BadArgument), 
                            new String[]
                            {
                                dmpl__InterfaceServiceProvider__c.class.getName()
                            }));
            }     
        } catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }

    @AuraEnabled
    public static void performAction(
        Id queueId){
        try {
            
            dmpl__InterfaceQueue__c queue = [SELECT dmpl__QueueType__c, dmpl__JobType__c, dmpl__ApexJobId__c FROM dmpl__InterfaceQueue__c WHERE Id=:queueId];
            if(queue.dmpl__QueueType__c == QUEUETYPE_QUEUE){
                InterfaceServiceProviderQueueable.executeQueue(queue.dmpl__ApexJobId__c);
            }else if(queue.dmpl__QueueType__c == QUEUETYPE_SCHEDULE){
                InterfaceServiceProviderSchedulable.executeSchedule(queue.dmpl__ApexJobId__c);
            }else if(queue.dmpl__QueueType__c == QUEUETYPE_MANUAL){
                JobTypeHelper.executeQueue(queueId);
            } else {
                InterfaceServiceProviderSchedulable.executeSchedule(queue.dmpl__ApexJobId__c);
            }
        } catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }

    @AuraEnabled
    public static dmpl__InterfaceQueue__c getQueueStatus(Id queueId){
        List<dmpl__InterfaceQueue__c> queues = [SELECT dmpl__IsApexJobExecuted__c, dmpl__IsSuccessful__c, dmpl__IsPoison__c, dmpl__ExecutionLog__c FROM dmpl__InterfaceQueue__c WHERE Id = :queueId];
        if(queues.size()>0){
            return queues[0];
        }
        return null;
    }
}