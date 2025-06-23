public with sharing class ServiceCampaignServiceRequestProcessor implements Database.Batchable<SObject> {
    
    public static final Integer BATCH_SIZE = 200;
    private Id invokedQueueId;
    private Id serviceCampaignId;
    private String batchQuery;
    private dmpl__ServiceCampaign__c serviceCampaign;

    public static JobResponseResult perfromAction(
        Id recordId,
        Id queueId){
        try {
            Id batchId = Database.executeBatch(
                new ServiceCampaignServiceRequestProcessor(
                    recordId,
                    queueId,
                    getFilterQuery(recordId)
                ), 
                BATCH_SIZE);
        return new JobResponseResult(
            true, 
            null, 
            'Apex Batch Job Enqueued With Job Id ' + batchId);
        } catch (Exception error) {
            ExceptionLogHelper.logException(error, queueId);
            throw error;
        }
    }

    public ServiceCampaignServiceRequestProcessor(
        Id agId,
        Id queueId,
        String query){
            invokedQueueId  =queueId;
            serviceCampaignId = agId;
            batchQuery = query;
            serviceCampaign = queryServiceCampaign(serviceCampaignId);
    }

    public Database.QueryLocator start(
        Database.BatchableContext bc){
        try {
            InterfaceQueueHelper.addStatusUpdate(
                invokedQueueId,
                'Starting AG Batch '
            );
            return Database.getQueryLocator(batchQuery);
        } catch (Exception error) {
            ExceptionLogHelper.logException(error, invokedQueueId);
            throw error;
        }
    }

    public void execute(
        Database.BatchableContext bc, 
        List<SObject> scope){
        try {
            List<dmpl__ServiceRequest__c> requests = new List<dmpl__ServiceRequest__c>();
            for(SObject a : scope){
                requests.add(
                    new dmpl__ServiceRequest__c(
                        dmpl__ServiceCampaignId__c = serviceCampaignId,
                        dmpl__AssetId__c = (Id)a.get('dmpl__AssetId__c'),
                        dmpl__ServiceCampaignMemberId__c = a.Id,
                        dmpl__AccountId__c = (Id)a.get('dmpl__AccountId__c'),
                        dmpl__ServiceCampaignBatchInstanceId__c = bc.getJobId(),
                        dmpl__PartnerAccountId__c = (Id)a.get('dmpl__PartnerAccountId__c'),
                        dmpl__BranchId__c = (Id)a.get('dmpl__BranchId__c')
                    )
                );
            }      

            insert requests;

            List<dmpl__ServiceRequestLine__c> requestLines = new List<dmpl__ServiceRequestLine__c>();
            for(dmpl__ServiceRequest__c request : requests){
                for(dmpl__ServiceCampaignItem__c item : serviceCampaign.dmpl__ServiceCampaignItems__r){
                    requestLines.add(new dmpl__ServiceRequestLine__c(
                        dmpl__ServiceRequestId__c = request.Id,
                        dmpl__ItemId__c = item.dmpl__ItemId__c,
                        dmpl__ItemServiceContractId__c = item.dmpl__ItemServiceContractId__c,
                        dmpl__Quantity__c = item.dmpl__Quantity__c,
                        dmpl__IsServiceCampaignMandatory__c = item.dmpl__IsMandatory__c
                    ));
                }
            }

            if(requestLines.size()>0){
                insert requestLines;
            }
            InterfaceQueueHelper.addStatusUpdate(
                invokedQueueId,
                'Processed Batch Count ' + scope.size()
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
                'Finished AG Batch '
            );
        try {
            Database.executeBatch(
                new ServiceCampaignServiceRequestCleaner(
                    bc.getJobId(),
                    invokedQueueId,
                    serviceCampaignId
                ), 
                BATCH_SIZE);
        } catch (Exception error) {
            ExceptionLogHelper.logException(error, invokedQueueId);
            throw error;
        }
    }

    private static String getFilterQuery(Id recordId){
        return 'SELECT Id, dmpl__AccountId__c, dmpl__AssetId__c, dmpl__BranchId__c, dmpl__PartnerAccountId__c FROM dmpl__ServiceCampaignMember__c WHERE dmpl__ServiceCampaignId__c = \'' + recordId + '\'';
    }

    private static dmpl__ServiceCampaign__c queryServiceCampaign(Id serviceCampaignId){
        return [
            SELECT 
                Id,
                (SELECT
                    Id,
                    dmpl__IsMandatory__c,
                    dmpl__ItemId__c,
                    dmpl__ItemServiceContractId__c,
                    dmpl__Quantity__c
                FROM
                    dmpl__ServiceCampaignItems__r)
            FROM 
                dmpl__ServiceCampaign__c
            WHERE 
                dmpl__IsActive__c = true
                AND Id =: serviceCampaignId
                AND (dmpl__StartDate__c =  null OR dmpl__StartDate__c <= TODAY)
                AND (dmpl__EndDate__c =  null OR dmpl__EndDate__c >= TODAY)
        ];
    }
}