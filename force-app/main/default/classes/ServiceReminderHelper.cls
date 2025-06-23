public with sharing class ServiceReminderHelper {
    
    public static void execute(Id campaignId)
    {
        List<dmpl__ServiceLead__c> serviceLeadsToUpdate = new List<dmpl__ServiceLead__c>();
        List<dmpl__ServiceLead__c> serviceLeadsToCreate = new List<dmpl__ServiceLead__c>();
        dmpl__ServiceCampaign__c serviceCampaign = queryActiveServiceCampaign(campaignId);
        List<dmpl__ServiceLead__c> serviceLeads = queryServiceLeads(campaignId);

        if(serviceCampaign != null && serviceCampaign.dmpl__Type__c == 'Maintenance Schedule')
        {
            List<dmpl__AssetServiceContract__c> assetServiceContracts = queryAssetsContractForMaintenanceSchedule(serviceCampaign);
            for(dmpl__AssetServiceContract__c contract : assetServiceContracts)
            {
                dmpl__ServiceLead__c serviceLead = (dmpl__ServiceLead__c)DocumentHelper.getObjectByFilter(serviceLeads, 'dmpl__AssetId__c', contract.dmpl__AssetId__c);
                if((serviceLead == null || (serviceLead != null  
                        && (serviceLead.dmpl__ReminderOffsetNumber__c == null || serviceLead.dmpl__ReminderOffsetNumber__c == 0) 
                        && serviceCampaign.dmpl__ReminderDaysOffset1__c != null))
                        && contract.dmpl__DueDate__c == Date.today().addDays((Integer)serviceCampaign.dmpl__ReminderDaysOffset1__c)
                    )
                {
                    if(serviceLead == null){
                        serviceLeadsToCreate.add(createNewServiceLead(serviceCampaign, contract, 1));
                    }
                    else {
                        serviceLead.dmpl__ReminderOffsetNumber__c = 1;
                        serviceLeadsToUpdate.add(serviceLead);
                    }
                }
                else if((serviceLead == null || (serviceLead != null  
                        && (serviceLead.dmpl__ReminderOffsetNumber__c == null || serviceLead.dmpl__ReminderOffsetNumber__c < 2) 
                        && serviceCampaign.dmpl__ReminderDaysOffset2__c != null))
                        && contract.dmpl__DueDate__c == Date.today().addDays((Integer)serviceCampaign.dmpl__ReminderDaysOffset2__c))
                {
                    if(serviceLead == null){
                        serviceLeadsToCreate.add(createNewServiceLead(serviceCampaign, contract, 2));
                    }
                    else {
                        serviceLead.dmpl__ReminderOffsetNumber__c = 2;
                        serviceLeadsToUpdate.add(serviceLead);
                    }
                }
                else if((serviceLead == null || (serviceLead != null  
                        && (serviceLead.dmpl__ReminderOffsetNumber__c == null || serviceLead.dmpl__ReminderOffsetNumber__c < 3) 
                        && serviceCampaign.dmpl__ReminderDaysOffset3__c != null))
                        && contract.dmpl__DueDate__c == Date.today().addDays((Integer)serviceCampaign.dmpl__ReminderDaysOffset3__c))
                {

                    if(serviceLead == null){
                        serviceLeadsToCreate.add(createNewServiceLead(serviceCampaign, contract, 3));
                    }
                    else {
                        serviceLead.dmpl__ReminderOffsetNumber__c = 3;
                        serviceLeadsToUpdate.add(serviceLead);
                    }
                }
            }

            if(serviceLeadsToUpdate.size() > 0){
                SecurityHelper.ensureCanWriteFields(new List<String>{
                    'dmpl__ReminderOffsetNumber__c',
                    'dmpl__ReminderDaysOffset3__c'
                }, 'dmpl__ServiceLead__c');
                update serviceLeadsToUpdate;    
            }
            if(serviceLeadsToCreate.size() > 0){
                SecurityHelper.ensureCanCreateObject('dmpl__ServiceLead__c');
                SecurityHelper.ensureCanCreateFields(new List<String>{
                    'dmpl__AccountId__c',
                    'dmpl__AssetId__c',    
                    'dmpl__ServiceContractItemId__c',
                    'dmpl__ItemServiceContractId__c',
                    'dmpl__BranchId__c',
                    'dmpl__PartnerAccountId__c',
                    'dmpl__DocumentDate__c',
                    'dmpl__ServiceCampaignId__c',
                    'dmpl__LeadType__c',
                    'dmpl__Status__c'
                }, 'dmpl__ServiceLead__c');
                insert serviceLeadsToCreate;
            }
        }
        else if(serviceCampaign != null && serviceCampaign.dmpl__Type__c == 'Recall')
        {
            List<dmpl__ServiceLead__c> leadsToCreate =  new List<dmpl__ServiceLead__c>();
            
            for(Asset asset : queryAssetsForRecall(serviceCampaign))
            {
                dmpl__ServiceLead__c serviceLead = (dmpl__ServiceLead__c)DocumentHelper.getObjectByFilter(serviceLeads, 'dmpl__AssetId__c', asset.Id);
                if(serviceLead != null && serviceLead.dmpl__LeadType__c == 'Recall'){
                }
                else{
                    leadsToCreate.add(
                        createNewServiceLead(serviceCampaign,asset));
                }
            }
            if(leadsToCreate.size() > 0){
                SecurityHelper.ensureCanCreateObject('dmpl__ServiceLead__c');
                SecurityHelper.ensureCanCreateFields(new List<String>{
                    'dmpl__AccountId__c',
                    'dmpl__AssetId__c',    
                    'dmpl__ServiceContractItemId__c',
                    'dmpl__ItemServiceContractId__c',
                    'dmpl__BranchId__c',
                    'dmpl__PartnerAccountId__c',
                    'dmpl__DocumentDate__c',
                    'dmpl__ServiceCampaignId__c',
                    'dmpl__LeadType__c',
                    'dmpl__Status__c'
                }, 'dmpl__ServiceLead__c');
                insert leadsToCreate;
            }

            List<Task> tasksToCreate = new List<Task>();
            for(dmpl__ServiceLead__c lead :  leadsToCreate)
            {
                if(serviceCampaign.dmpl__ReminderDaysOffset1__c != null)
                    tasksToCreate.add(createReminderTask(lead, serviceCampaign, (Integer)serviceCampaign.dmpl__ReminderDaysOffset1__c));
                if(serviceCampaign.dmpl__ReminderDaysOffset2__c != null)
                    tasksToCreate.add(createReminderTask(lead, serviceCampaign, (Integer)serviceCampaign.dmpl__ReminderDaysOffset2__c));
                if(serviceCampaign.dmpl__ReminderDaysOffset3__c != null)
                    tasksToCreate.add(createReminderTask(lead, serviceCampaign, (Integer)serviceCampaign.dmpl__ReminderDaysOffset3__c));
            }
            if(tasksToCreate.size() > 0)
            {
                try{
                    System.debug(tasksToCreate);
                    SecurityHelper.ensureCanCreateObject('Task');
                    SecurityHelper.ensureCanCreateFields(new List<String>{
                        'Subject',
                        'Status',
                        'Priority',
                        'WhatId',
                        'OwnerId',
                        'ActivityDate'
                    }, 'Task');
                    insert tasksToCreate;
                } catch (Exception ex) {                
                    ExceptionLogHelper.logException(ex);
                }
            }
        }
    }

    @TestVisible
    private static Task createReminderTask(dmpl__ServiceLead__c lead, dmpl__ServiceCampaign__c serviceCampaign, Integer daysOffset)
    {
        Date reminderDate = serviceCampaign.dmpl__StartDate__c.addDays(daysOffset * -1);
        System.debug(lead.OwnerId);
        return (new Task
        (
            Subject = 'Service Reminder',
            Status = 'Open',
            Priority = 'Normal',
            WhatId = lead.ID,
            OwnerId = '0051y00000LnDPDAA3',
            ActivityDate = reminderDate
        ));
    }

    @TestVisible
    private static dmpl__ServiceLead__c createNewServiceLead(dmpl__ServiceCampaign__c serviceCampaign, Asset asset)
    {
        return new dmpl__ServiceLead__c(
            dmpl__AccountId__c = asset.AccountId,
            dmpl__AssetId__c = asset.Id,    
            dmpl__ServiceContractItemId__c = serviceCampaign.dmpl__ServiceContractItemId__c,
            dmpl__ItemServiceContractId__c = serviceCampaign.dmpl__ItemServiceContractId__c,
            dmpl__BranchId__c = asset.dmpl__LastServiceBranchId__c == null ? asset.dmpl__SellingBranchId__c : asset.dmpl__LastServiceBranchId__c,
            dmpl__PartnerAccountId__c = asset.dmpl__LastServicePartnerId__c == null ? asset.dmpl__SellingPartnerAccountId__c : asset.dmpl__LastServicePartnerId__c,
            dmpl__DocumentDate__c = serviceCampaign.dmpl__StartDate__c,
            dmpl__ServiceCampaignId__c = serviceCampaign.Id,
            dmpl__LeadType__c = 'Recall',
            dmpl__Status__c = 'Draft');
    }

    @TestVisible
    private static dmpl__ServiceLead__c createNewServiceLead(dmpl__ServiceCampaign__c serviceCampaign, dmpl__AssetServiceContract__c contract, Integer reminderCount)
    {
        return new dmpl__ServiceLead__c(
            dmpl__AccountId__c =  contract.dmpl__AssetId__r.AccountId,
            dmpl__AssetId__c = contract.dmpl__AssetId__c,
            dmpl__ServiceContractItemId__c = serviceCampaign.dmpl__ServiceContractItemId__c,
            dmpl__ItemServiceContractId__c = serviceCampaign.dmpl__ItemServiceContractId__c,
            dmpl__BranchId__c = contract.dmpl__AssetId__r.dmpl__LastServiceBranchId__c == null ? contract.dmpl__AssetId__r.dmpl__SellingBranchId__c : contract.dmpl__AssetId__r.dmpl__LastServiceBranchId__c,
            dmpl__PartnerAccountId__c = contract.dmpl__AssetId__r.dmpl__LastServicePartnerId__c == null ? contract.dmpl__AssetId__r.dmpl__SellingPartnerAccountId__c : contract.dmpl__AssetId__r.dmpl__LastServicePartnerId__c,
            dmpl__DocumentDate__c = Date.today(),
            dmpl__ServiceCampaignId__c = serviceCampaign.Id,
            dmpl__ReminderOffsetNumber__c = reminderCount,
            dmpl__LeadType__c = 'Maintenance Schedule',
            dmpl__Status__c = 'Draft');
    }

    public static dmpl__ServiceCampaign__c queryActiveServiceCampaign(Id campaignId)
    {
        SecurityHelper.ensureCanReadFields(new string[]{
            'dmpl__Type__c',
            'dmpl__ServiceContractItemId__c',
            'dmpl__ItemServiceContractId__c',
            'dmpl__StartDate__c',
            'dmpl__EndDate__c',
            'dmpl__FromEngineSeries__c',
            'dmpl__ToEngineSeries__c',
            'dmpl__FromChassisSeries__c',
            'dmpl__ToChassisSeries__c',
            'dmpl__FromManufacturingDate__c',
            'dmpl__ToManufacturingDate__c',
            'dmpl__FromSaleDate__c',
            'dmpl__ToSaleDate__c',
            'dmpl__IsActive__c',
            'dmpl__IsRecurring__c',
            'dmpl__RecurringType__c',
            'dmpl__Status__c',
            'dmpl__ReminderDaysOffset1__c',
            'dmpl__ReminderDaysOffset2__c',
            'dmpl__ReminderDaysOffset3__c'
        }, 'dmpl__ServiceCampaign__c');
        return [
            Select
                ID,
                Name,
                dmpl__Type__c,
                dmpl__ServiceContractItemId__c,
                dmpl__ItemServiceContractId__c,
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

    private static List<dmpl__ServiceLead__c> queryServiceLeads(Id campaignId)
    {
        SecurityHelper.ensureCanReadFields(new string[]
        {
            'dmpl__AssetId__c',
            'dmpl__ServiceContractItemId__c',
            'dmpl__ItemServiceContractId__c',
            'dmpl__Status__c',
            'dmpl__ServiceCampaignId__c',
            'dmpl__ReminderOffsetNumber__c',
            'dmpl__LeadType__c'
        }, 'dmpl__ServiceLead__c');
        return [
            Select
                ID,
                Name,
                dmpl__AssetId__c,
                dmpl__ServiceContractItemId__c,
                dmpl__ItemServiceContractId__c,
                dmpl__Status__c,
                dmpl__ServiceCampaignId__c,
                dmpl__ReminderOffsetNumber__c,
                dmpl__LeadType__c
            FROM
                dmpl__ServiceLead__c
            Where 
                dmpl__ServiceCampaignId__c =: campaignId
                AND dmpl__Status__c = 'Draft'
        ];
    }

    @TestVisible
    private static List<Asset> queryAssetsForRecall(dmpl__ServiceCampaign__c serviceCampaign)
    {
        String whereCondition = '';
        if(serviceCampaign.dmpl__FromChassisSeries__c != null)
            whereCondition = ' Where (SerialNumber >= \'' + serviceCampaign.dmpl__FromChassisSeries__c 
                                + '\' AND SerialNumber <= \'' + serviceCampaign.dmpl__ToChassisSeries__c + '\')';
        if(whereCondition == '' && serviceCampaign.dmpl__FromManufacturingDate__c != null){
            whereCondition = 'Where (ManufactureDate >= \'' + serviceCampaign.dmpl__FromManufacturingDate__c
                                + '\' AND ManufactureDate <= \'' + serviceCampaign.dmpl__ToManufacturingDate__c +'\')';
        }
        else if(whereCondition != '' && serviceCampaign.dmpl__FromManufacturingDate__c != null){
            whereCondition = whereCondition + ' AND (ManufactureDate >= ' + ((DateTime)serviceCampaign.dmpl__FromManufacturingDate__c).format('yyyy-MM-dd')
                                + ' AND ManufactureDate <= ' + ((DateTime)serviceCampaign.dmpl__ToManufacturingDate__c).format('yyyy-MM-dd') +')';
        }
        if(whereCondition == '' && serviceCampaign.dmpl__FromSaleDate__c != null){
            whereCondition = ' Where (dmpl__SaleDate__c >= ' + ((DateTime)serviceCampaign.dmpl__FromSaleDate__c).format('yyyy-MM-dd')
                                + ' AND dmpl__SaleDate__c <= ' + ((DateTime)serviceCampaign.dmpl__ToSaleDate__c).format('yyyy-MM-dd') + ')';
        }
        else if(whereCondition != '' && serviceCampaign.dmpl__FromSaleDate__c != null){
            whereCondition = whereCondition + ' AND (dmpl__SaleDate__c >= ' + ((DateTime)serviceCampaign.dmpl__FromSaleDate__c).format('yyyy-MM-dd')
                                    + ' AND dmpl__SaleDate__c <= ' + ((DateTime)serviceCampaign.dmpl__ToSaleDate__c).format('yyyy-MM-dd') + ')';
        }

        SecurityHelper.ensureCanReadFields(new string[]
        {
            'ID',
            'Name',
            'SerialNumber',
            'AccountId',
            'dmpl__LastServiceBranchId__c',
            'dmpl__SellingBranchId__c',
            'dmpl__LastServicePartnerId__c',
            'dmpl__SellingPartnerAccountId__c'
        }, 'Asset');
        return Database.query('Select ID,Name,SerialNumber,AccountId,dmpl__LastServiceBranchId__c,dmpl__SellingBranchId__c,dmpl__LastServicePartnerId__c,dmpl__SellingPartnerAccountId__c FROM Asset' + whereCondition);
    }

    public static List<dmpl__AssetServiceContract__c> queryAssetsContractForMaintenanceSchedule(dmpl__ServiceCampaign__c serviceCampaign)
    {
        Integer nextNDays = 0;
        if(serviceCampaign.dmpl__ReminderDaysOffset1__c != null)
            nextNDays = (Integer)serviceCampaign.dmpl__ReminderDaysOffset1__c;
        if (serviceCampaign.dmpl__ReminderDaysOffset2__c != null && serviceCampaign.dmpl__ReminderDaysOffset2__c > nextNDays)
            nextNDays = (Integer)serviceCampaign.dmpl__ReminderDaysOffset2__c;
        if (serviceCampaign.dmpl__ReminderDaysOffset3__c != null && serviceCampaign.dmpl__ReminderDaysOffset3__c > nextNDays)
            nextNDays = (Integer)serviceCampaign.dmpl__ReminderDaysOffset3__c;
        // else if (serviceCampaign.dmpl__ReminderDaysOffset4__c != null && serviceCampaign.dmpl__ReminderDaysOffset4__c > nextNDays)
        //     nextNDays = serviceCampaign.dmpl__ReminderDaysOffset4__c;
        // else if (serviceCampaign.dmpl__ReminderDaysOffset5__c != null && serviceCampaign.dmpl__ReminderDaysOffset5__c > nextNDays)
        //     nextNDays = serviceCampaign.dmpl__ReminderDaysOffset5__c;
        
        Date maxDate = Date.today().addDays(nextNDays);

        SecurityHelper.ensureCanReadFields(new string[]
        {
            'dmpl__DueDate__c',
            'dmpl__ValidTillDate__c',
            'dmpl__DueInHours__c',
            'dmpl__ValidTillHours__c',
            'dmpl__DueOnUsageReading__c',
            'dmpl__ValidTillUsageReading__c'
        }, 'dmpl__AssetServiceContract__c');
        SecurityHelper.ensureCanReadFields(new string[]
        {
            'AccountId',
            'dmpl__LastServiceBranchId__c',
            'dmpl__SellingBranchId__c',
            'dmpl__LastServicePartnerId__c',
            'dmpl__SellingPartnerAccountId__c',
            'dmpl__LastServiceDate__c',
            'dmpl__LastUsageReading__c'
        }, 'Asset');
        return [
            SELECT 
                ID,
                Name,
                dmpl__AssetId__r.AccountId,
                dmpl__AssetId__r.dmpl__LastServiceBranchId__c,
                dmpl__AssetId__r.dmpl__SellingBranchId__c,
                dmpl__AssetId__r.dmpl__LastServicePartnerId__c,
                dmpl__AssetId__r.dmpl__SellingPartnerAccountId__c,
                dmpl__AssetId__r.dmpl__LastServiceDate__c,
                dmpl__AssetId__r.dmpl__LastUsageReading__c,
                dmpl__DueDate__c,
                dmpl__ValidTillDate__c,
                dmpl__DueInHours__c,
                dmpl__ValidTillHours__c,
                dmpl__DueOnUsageReading__c,
                dmpl__ValidTillUsageReading__c
            FROM
                dmpl__AssetServiceContract__c
            WHERE 
                dmpl__ItemServiceContractId__c =: serviceCampaign.dmpl__ItemServiceContractId__c
            AND
                dmpl__ServiceContractItemId__c =: serviceCampaign.dmpl__ServiceContractItemId__c
            AND 
                dmpl__IsValid__c = true
            AND 
                dmpl__IsUtilized__c = false
            AND 
                dmpl__DueDate__c >=: Date.today()
            AND 
                dmpl__DueDate__c <=: maxDate
        ];
    }
}