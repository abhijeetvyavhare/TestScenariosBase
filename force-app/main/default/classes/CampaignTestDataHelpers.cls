@isTest
public class CampaignTestDataHelpers {

    public static dmpl__ServiceCampaign__c CreateServiceCompaign(
        dmpl__ItemServiceContract__c contract,
        dmpl__ServiceLead__c lead,
        dmpl__Item__c items
    )
    {   
            return (dmpl__ServiceCampaign__c)TestFactory.createSObject(
                new dmpl__ServiceCampaign__c(
                    dmpl__ItemServiceContractId__c = contract.Id,
                    dmpl__ServiceLeadId__c = lead.Id,
                    dmpl__ServiceContractItemId__c = items.Id,
                    dmpl__IsActive__c = true,
                    dmpl__ReportId__c='Sample Report',
                    dmpl__ApexJobId__c = 'Job1',
                    dmpl__CronExpression__c = 'Cron Expression',
                    dmpl__Type__c = 'Service',
                    Name = 'Service - Campaign',
                    dmpl__ReminderDaysOffset1__c = 3
                ),
                true
            );
    }
    public static dmpl__ServiceCampaign__c getServiceCompaign(){
        return [
            select 
                dmpl__ApexJobId__c,
                dmpl__BranchId__c,
                Name,
                CreatedById,
                dmpl__CronExpression__c,
                dmpl__DynamicMemberObject__c,
                dmpl__DynamicMemberType__c,
                dmpl__EndDate__c,
                dmpl__FromChassisSeries__c,
                dmpl__FromEngineSeries__c,
                dmpl__FromManufacturingDate__c,
                dmpl__FromSaleDate__c,
                dmpl__IsActive__c,
                dmpl__IsRecurring__c,
                dmpl__ItemMaintenanceScheduleId__c,
                LastModifiedById,
                OwnerId,
                dmpl__ParentServiceCampaignId__c,
                dmpl__PartnerAccountId__c,
                dmpl__RecurringType__c,
                dmpl__ReminderDaysOffset1__c,
                dmpl__ReminderDaysOffset2__c,
                dmpl__ReminderDaysOffset3__c,
                dmpl__ReportId__c,
                dmpl__RuleSuccessCriteria__c,
                dmpl__RuleSuccessCustomLogic__c,
                dmpl__ItemServiceContractId__c,
                dmpl__ServiceContractItemId__c,
                dmpl__ServiceLeadId__c,
                dmpl__StartDate__c,
                dmpl__Status__c,
                dmpl__ToChassisSeries__c,
                dmpl__ToEngineSeries__c,
                dmpl__ToManufacturingDate__c,
                dmpl__ToSaleDate__c,
                dmpl__Type__c
            from 
                dmpl__ServiceCampaign__c
            limit 1];
    }

		
}