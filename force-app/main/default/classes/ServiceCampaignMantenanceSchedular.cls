public with sharing class ServiceCampaignMantenanceSchedular implements Database.Batchable<SObject> {
    
    public static final Integer BATCH_SIZE = 200;
    private Id invokedQueueId;
    private Id serviceCampaignId;
    private String batchQuery;
    private dmpl__ServiceCampaign__c serviceCampaign;

    public static JobResponseResult perfromAction(
        Id recordId,
        Id queueId){
        try {
            dmpl__ServiceCampaign__c serviceCampaign = queryActiveServiceCampaign(recordId);

            Id batchId = Database.executeBatch(
                new ServiceCampaignMantenanceSchedular(
                    recordId,
                    queueId,
                    queryAssetsForMaintenanceSchedule(serviceCampaign),
                    serviceCampaign
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

    public ServiceCampaignMantenanceSchedular(
        Id agId,
        Id queueId,
        String query,
        dmpl__ServiceCampaign__c campaign){
            invokedQueueId  =queueId;
            serviceCampaignId = agId;
            batchQuery = query;
            serviceCampaign = campaign;
    }

    public Database.QueryLocator start(
        Database.BatchableContext bc){
        try {
            InterfaceQueueHelper.addStatusUpdate(
                invokedQueueId,
                'Starting Service Campaign Contract Batch '
            );
            System.debug('batchQuery ' + batchQuery);
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
            List<dmpl__ServiceLead__c> serviceLeadsToCreate = new List<dmpl__ServiceLead__c>();
            List<dmpl__ItemMaintenanceScheduleDetails__c> assetMaintenanceSchedules = new List<dmpl__ItemMaintenanceScheduleDetails__c>();
            assetMaintenanceSchedules.addAll((List<dmpl__ItemMaintenanceScheduleDetails__c>)scope);

            for(dmpl__ItemMaintenanceScheduleDetails__c schedule : assetMaintenanceSchedules){

                if((serviceCampaign.dmpl__ReminderDaysOffset1__c != null)
                        && schedule.dmpl__NextServiceDate__c
                         == Date.today().addDays((Integer)serviceCampaign.dmpl__ReminderDaysOffset1__c)){
                            serviceLeadsToCreate.add(createNewServiceLead(serviceCampaign, schedule, 1));
                        }
                else if((serviceCampaign.dmpl__ReminderDaysOffset2__c != null)
                        && schedule.dmpl__NextServiceDate__c == Date.today().addDays((Integer)serviceCampaign.dmpl__ReminderDaysOffset2__c)){
                        serviceLeadsToCreate.add(createNewServiceLead(serviceCampaign, schedule, 2));
                        }
                else if((serviceCampaign.dmpl__ReminderDaysOffset3__c != null)
                        && schedule.dmpl__NextServiceDate__c == Date.today().addDays((Integer)serviceCampaign.dmpl__ReminderDaysOffset3__c)){
                        serviceLeadsToCreate.add(createNewServiceLead(serviceCampaign, schedule, 3));
                        }
                }

                if(serviceLeadsToCreate.size() > 0)
                    insert serviceLeadsToCreate;


            List<Task> tasksToCreate = new List<Task>();
            for(dmpl__ServiceLead__c lead :  serviceLeadsToCreate)
            {
                if(serviceCampaign.dmpl__ReminderDaysOffset1__c != null)
                    tasksToCreate.add(createReminderTask(lead, serviceCampaign, (Integer)serviceCampaign.dmpl__ReminderDaysOffset1__c));
                if(serviceCampaign.dmpl__ReminderDaysOffset2__c != null)
                    tasksToCreate.add(createReminderTask(lead, serviceCampaign, (Integer)serviceCampaign.dmpl__ReminderDaysOffset2__c));
                if(serviceCampaign.dmpl__ReminderDaysOffset3__c != null)
                    tasksToCreate.add(createReminderTask(lead, serviceCampaign, (Integer)serviceCampaign.dmpl__ReminderDaysOffset3__c));
            }
            if(tasksToCreate.size() > 0)
                insert tasksToCreate;
            
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
	
    @testVisible
    private static dmpl__ServiceLead__c createNewServiceLead(dmpl__ServiceCampaign__c serviceCampaign, dmpl__ItemMaintenanceScheduleDetails__c schedule, Integer reminderCount)
    {
        return new dmpl__ServiceLead__c(
            dmpl__AccountId__c =  schedule.dmpl__AssetId__r.AccountId,
            dmpl__AssetId__c = schedule.dmpl__AssetId__c,
            dmpl__ItemMaintenanceScheduleId__c = serviceCampaign.dmpl__ItemMaintenanceScheduleId__c,
            dmpl__BranchId__c = schedule.dmpl__AssetId__r.dmpl__LastServiceBranchId__c == null ? 
                                    schedule.dmpl__AssetId__r.dmpl__SellingBranchId__c : 
                                    schedule.dmpl__AssetId__r.dmpl__LastServiceBranchId__c,

            dmpl__PartnerAccountId__c = schedule.dmpl__AssetId__r.dmpl__LastServicePartnerId__c == null ? 
                                        schedule.dmpl__AssetId__r.dmpl__SellingPartnerAccountId__c : 
                                        schedule.dmpl__AssetId__r.dmpl__LastServicePartnerId__c,
            dmpl__DocumentDate__c = Date.today(),
            dmpl__LeadDueDate__c = schedule.dmpl__NextServiceDate__c,
            dmpl__ServiceCampaignId__c = serviceCampaign.Id,
            dmpl__ReminderOffsetNumber__c = reminderCount,
            dmpl__LeadType__c = 'Maintenance Schedule',
            dmpl__Status__c = 'Draft');
    }

    private static Task createReminderTask(dmpl__ServiceLead__c lead, dmpl__ServiceCampaign__c serviceCampaign, Integer daysOffset)
    {
        // Date reminderDate = serviceCampaign.dmpl__StartDate__c.addDays(daysOffset * -1);
        Date reminderDate = lead.dmpl__LeadDueDate__c.addDays(daysOffset * -1);
        System.debug(lead.OwnerId);
        return (new Task
        (
            Subject = 'Service Reminder',
            Status = 'Open',
            Priority = 'Normal',
            WhatId = lead.ID,
            ActivityDate = reminderDate
        ));
    }

    public static dmpl__ServiceCampaign__c queryActiveServiceCampaign(Id campaignId)
    {
        return [
            Select
                ID,
                Name,
                dmpl__Type__c,
                dmpl__ItemServiceContractId__c,
                dmpl__ItemMaintenanceScheduleId__c,
                dmpl__StartDate__c,
                dmpl__EndDate__c,
                dmpl__FromEngineSeries__c,
                dmpl__ToEngineSeries__c,
                dmpl__FromChassisSeries__c,
                dmpl__ToChassisSeries__c,
                dmpl__FromManufacturingDate__c,
                dmpl__ToManufacturingDate__c,
                dmpl__FromSaleDate__c,
                dmpl__ToSaleDate__c,
                dmpl__IsActive__c,
                dmpl__IsRecurring__c,
                dmpl__RecurringType__c,
                dmpl__Status__c,
                dmpl__ReminderDaysOffset1__c,
                dmpl__ReminderDaysOffset2__c,
                dmpl__ReminderDaysOffset3__c
            FROM
                dmpl__ServiceCampaign__c
            Where 
                dmpl__IsActive__c = true
                AND Id =: campaignId
                AND (dmpl__StartDate__c =  null OR dmpl__StartDate__c <= TODAY)
                AND (dmpl__EndDate__c =  null OR dmpl__EndDate__c >= TODAY)
        ];
    }

    public static String queryAssetsForMaintenanceSchedule(dmpl__ServiceCampaign__c serviceCampaign)
    {
        Integer nextNDays = 0;
        if(serviceCampaign.dmpl__ReminderDaysOffset1__c != null)
            nextNDays = (Integer)serviceCampaign.dmpl__ReminderDaysOffset1__c;
        if (serviceCampaign.dmpl__ReminderDaysOffset2__c != null && serviceCampaign.dmpl__ReminderDaysOffset2__c > nextNDays)
            nextNDays = (Integer)serviceCampaign.dmpl__ReminderDaysOffset2__c;
        if (serviceCampaign.dmpl__ReminderDaysOffset3__c != null && serviceCampaign.dmpl__ReminderDaysOffset3__c > nextNDays)
            nextNDays = (Integer)serviceCampaign.dmpl__ReminderDaysOffset3__c;
        Date maxDate = Date.today().addDays(nextNDays);

        String maxDt = DateTime.newInstance(maxDate.year(),maxDate.month(),maxDate.day()).format('YYYY-MM-dd');
        String todayDt = DateTime.newInstance(Date.today().year(),Date.today().month(),Date.today().day()).format('YYYY-MM-dd');

        String query =  'SELECT ID,Name,dmpl__AssetId__c,dmpl__LastServiceDate__c,dmpl__AssetId__r.AccountId, dmpl__AssetId__r.dmpl__LastServiceBranchId__c,dmpl__AssetId__r.dmpl__SellingBranchId__c,dmpl__AssetId__r.dmpl__LastServicePartnerId__c,dmpl__AssetId__r.dmpl__SellingPartnerAccountId__c,dmpl__ItemId__c, dmpl__ItemMaintenanceScheduleId__c,dmpl__NextServiceDate__c'
                + ' FROM dmpl__ItemMaintenanceScheduleDetails__c ' 
                + 'WHERE dmpl__ItemMaintenanceScheduleId__c = \'' + serviceCampaign.dmpl__ItemMaintenanceScheduleId__c + '\'' 
                + ' AND dmpl__NextServiceDate__c >= ' +  todayDt + ' AND dmpl__NextServiceDate__c <= '  + maxDt;

                System.debug('query ' + query);
                return query;
    }
}