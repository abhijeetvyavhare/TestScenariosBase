@isTest
public with sharing class ServiceLeadDefaults implements TestFactory.FieldDefaults {
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{ 
            'dmpl__AccountName__c' => 'Account1',
            'dmpl__ContactName__c' => 'Contact1',
            'dmpl__DateTimeOpened__c' => null,
            'dmpl__LeadDueDate__c' => null,
            'dmpl__LeadRating__c' => 'Hot',
            'dmpl__LeadSource__c' => 'None',
            'dmpl__LeadType__c' => 'Recall',
            'dmpl__LostReason__c' => null,
            'dmpl__Remarks__c' => null,
            'dmpl__ReminderOffsetNumber__c' => 2,
            'dmpl__ServiceCampaignBatchInstanceId__c' => null,
            'dmpl__Status__c' => 'Draft'
        };
    }
}