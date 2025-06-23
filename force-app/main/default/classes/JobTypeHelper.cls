public with sharing class JobTypeHelper {
    
    public static JobResponseResult executeJob(
        dmpl__InterfaceQueue__c queue){
        switch on queue.dmpl__JobType__c {
            when 'Interface Job' {
                return InterfaceServiceProvider.perfromAction2(
                    queue?.dmpl__InterfaceProviderId__c, 
                    queue?.dmpl__InterfaceRequestId__c,
                    queue?.dmpl__InterfaceRecordId__c,
                    queue.Id);        
            }
            when 'Message Evaluator' {
                return MessageHelper.evaluateTimerMessageRules(
                    queue.Id);        
            }
            when 'Document Selector Processor' {
                return DocumentSelectorProcessor.perfromAction(
                    queue?.dmpl__InterfaceRecordId__c,
                    queue?.dmpl__InterfaceRecordData__c,
                    queue.Id);
            }
            when 'Account Group Member Processor' {
                return AccountGroupMemberProcessor.perfromAction(
                    queue?.dmpl__InterfaceRecordId__c,
                    queue.Id);        
            }
            when 'Field Sales Invoice Processor' {
                return FieldSalesInvoiceProcessor.performAction(
                    queue?.dmpl__InterfaceRecordId__c,
                    queue.Id);       
            }
            when 'Resource Group Member Processor' {
                return ResourceGroupMemberProcessor.perfromAction(
                    queue?.dmpl__InterfaceRecordId__c,
                    queue.Id);        
            }
            when 'Item Group Member Processor' {
                return ItemGroupMemberProcessor.perfromAction(
                    queue?.dmpl__InterfaceRecordId__c,
                    queue.Id);        
            }
            when 'Incentive Target Processor' {
                return IncentiveTargetProcessor.performAction(
                    queue?.dmpl__InterfaceRecordId__c,
                    queue.Id);        
            }

            when 'Incentive Resource Processor' {
                return IncentiveResourceProcessor.performAction(
                    queue?.dmpl__InterfaceRecordId__c,
                    queue.Id);        
            }

            when 'Auto Order Generator' {
                return AutoOrderProcessor.perfromAction(
                    queue?.dmpl__InterfaceRecordId__c,
                    queue.Id);  
                
            }
            when 'Receive Goods Receipt Line Processor' {
                return ReceiveGoodsBatch.perfromAction(
                    queue?.dmpl__InterfaceRecordId__c,
                    queue.Id
                );
            }
            when 'Service Campaign Member Processor' {
                return ServiceCampaignMemberProcessor.perfromAction(
                    queue?.dmpl__InterfaceRecordId__c,
                    queue.Id
                );
            }
            when 'Service Campaign Lead Processor' {
                return ServiceCampaignLeadProcessor.perfromAction(
                    queue?.dmpl__InterfaceRecordId__c,
                    queue.Id
                );
            }
            when 'Service Campaign Asset Processor' {
                return ServiceCampaignAssetProcessor.perfromAction(
                    queue?.dmpl__InterfaceRecordId__c,
                    queue.Id
                );
            }
            when 'Service Campaign Service Request Processor' {
                return ServiceCampaignServiceRequestProcessor.perfromAction(
                    queue?.dmpl__InterfaceRecordId__c,
                    queue.Id
                );
            }
            when 'Service Campaign Contract Schedule Processor' {
                return ServiceCampaignContractScheduleProcessor.perfromAction(
                    queue?.dmpl__InterfaceRecordId__c,
                    queue.Id
                );
            }
            when 'Service Campaign Maintenance Schedular' {
                return ServiceCampaignMantenanceSchedular.perfromAction(
                    queue?.dmpl__InterfaceRecordId__c,
                    queue.Id
                );
            }
            when 'Resource Availability Processor' {
                return ResourceAvailabilityProcessor.perfromAction(
                    queue?.dmpl__InterfaceRecordId__c,
                    queue.Id
                );
            }
            when 'KPI Data Processor' {
                return KPIConfigurationHelper.evaluateTimerKPIConfigRules(
                    queue.Id
                );
            }
            when 'Incentive Compensation Processor' {
                return IncentiveProcessor.perfromAction(
                    Id.valueOf(queue?.dmpl__InterfaceRecordId__c),
                    queue.Id
                );
            }
            when 'Custom Processor' {
                return perfromCustomProcessorAction(
                    queue?.dmpl__CustomProcessorName__c,
                    queue?.dmpl__CustomActionName__c,
                    queue?.dmpl__InterfaceRecordId__c,
                    queue.Id
                );
            }
            when 'Visit Plan Generator' {
                return VisitPlanProcessor.perfromAction(
                    queue?.dmpl__InterfaceRecordId__c,
                    queue.Id
                );
            }
            when 'Bulk Order Processor' {
                return BulkOrderLineBatch.perfromAction(
                    queue?.dmpl__InterfaceRecordId__c,
                    queue.Id
                );
            }
            when else {
                throw new DMPLException('Method not implemented');
            }
        }
    }

    public static JobResponseResult executeJob(
        String jobType,
        Id interfaceProviderId, 
        Id interfaceRequestId,
        Id interfaceRecordId){
            switch on jobType {
                when 'Interface Job' {
                    return InterfaceServiceProvider.perfromAction2(
                        interfaceProviderId, 
                        interfaceRequestId,
                        interfaceRecordId);      
                }
                when 'Account Group Member Processor' {
                    return AccountGroupMemberProcessor.perfromAction(
                        interfaceRecordId,
                        null);        
                }
                when 'Item Group Member Processor' {
                    return ItemGroupMemberProcessor.perfromAction(
                        interfaceRecordId,
                        null);        
                }
                when 'Auto Order Generator' {
                    return AutoOrderProcessor.perfromAction(
                        interfaceRecordId,
                        null);  
                    
                }
                when 'Receive Goods Receipt Line Processor' {
                    return ReceiveGoodsBatch.perfromAction(
                        interfaceRecordId,
                        null
                    );
                }
                when else {
                    throw new DMPLException('Method not implemented');
                }
            }
    }

    public static void executeQueue(Id queueId){
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
        } catch (Exception error) {
            ExceptionLogHelper.logException(
                error, 
                queueObjectId);
            throw error;
        }
    }

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
    
    @TestVisible
    private static JobResponseResult perfromCustomProcessorAction(
        String handlerName,
        String actionName,
        Id recordId,
        Id queueId){
    try
        {
            if(String.isBlank(actionName)){
                actionName = 'perfromAction';
            }
            System.Type typeName = Type.forName(handlerName);
            if(typeName == null){
                throw new CalloutException(
                    'Type not found!. Please ensure that the controller class named is valid');
            }
            
            Object dynamicObject =  typeName.newInstance();
            if(dynamicObject == null){
                throw new CalloutException(
                    'Failed to create Dynamic Controller!. Please ensure that the controller class named \"' 
                    + handlerName 
                    + '\" is creatable.');
            }

            Callable callable =  (Callable)dynamicObject;
            if(callable == null){
                throw new CalloutException(
                    'Callable Type Cast Failed!. Please ensure that the controller class named \"' 
                    + handlerName 
                    + '\" implements Callable Interface.');
            }

            return (JobResponseResult)callable.call(
                actionName,
                new Map<String, Object> {
                    'recordId' => recordId,
                    'queueId' => queueId
                });
        }
        catch(Exception e)
        {
            throw e;
        }
    }
}