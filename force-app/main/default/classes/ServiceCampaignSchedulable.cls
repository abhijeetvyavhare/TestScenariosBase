//Deprecated -- Not In Use
public with sharing class ServiceCampaignSchedulable implements Schedulable {

        public void execute(SchedulableContext sc) {
            executeSchedule(sc.getTriggerId());
        }
    
        private static void executeSchedule(Id scheduleId){
            try {
                dmpl__ServiceCampaign__c campaign = queryServiceCampaign(scheduleId);
                if(campaign == null){
                    throw new DMPLException('Queued Job Not Found');
                }
                ServiceReminderHelper.execute(campaign.Id);
                        
                } catch (Exception ex) {                
                    ExceptionLogHelper.logException(ex);
                }
            } 
    
        private static dmpl__ServiceCampaign__c queryServiceCampaign(Id queueId){
            return [
                SELECT 
                Id, 
                Name
                FROM dmpl__ServiceCampaign__c
                WHERE 
                dmpl__IsActive__c = true
                AND dmpl__ApexJobId__c =:queueId
                AND (dmpl__StartDate__c =  null OR dmpl__StartDate__c <= TODAY)
                AND (dmpl__EndDate__c =  null OR dmpl__EndDate__c >= TODAY)];
        }
    }