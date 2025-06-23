@isTest
public with sharing class ServiceCampaignDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{ 
                'dmpl__IsActive__c'=>  true,
                'dmpl__ReportId__c'=> 'Sample Report',
                'dmpl__ApexJobId__c'=>  'Job1',
                'dmpl__CronExpression__c'=>'Cron Expression',
                'dmpl__Type__c'=>'Service',
                'Name'=>'Service - Campaign',
                'dmpl__ReminderDaysOffset1__c'=>3
        };
    }
}