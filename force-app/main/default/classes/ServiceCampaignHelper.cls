public with sharing class ServiceCampaignHelper {
    
    private static final string FIELD_ISACTIVE = 'dmpl__IsActive__c';

    public static void postData(
        Boolean isInsert, 
        Boolean isUpdate, 
        Boolean isDelete, 
        List<dmpl__ServiceCampaign__c> newEntries, 
        List<dmpl__ServiceCampaign__c> oldEntries){ 
        if(isUpdate)
        {
        }
    }

    public static HeadlessActionResult processMembers(
        Id recordId){
        dmpl__InterfaceQueue__c queue = new dmpl__InterfaceQueue__c(
            dmpl__JobType__c = 'Service Campaign Member Processor',
            dmpl__InterfaceRecordId__c = recordId,
            dmpl__QueueType__c = 'Queueable'
        );
        SecurityHelper.ensureCanCreateObject(
            'dmpl__InterfaceQueue__c');
        SecurityHelper.ensureCanCreateFields(
            new string[]{
                'dmpl__JobType__c',
                'dmpl__InterfaceRecordId__c',
                'dmpl__QueueType__c'
            }, 'dmpl__InterfaceQueue__c');
        
        insert queue;

        return new HeadlessActionResult(
            true, 
            'The operation was Queued. Please check back in some time. (Queue Id : ' + queue.Id + ')');
    }

   public static HeadlessActionResult processLeads(
        Id recordId){
        dmpl__InterfaceQueue__c queue = new dmpl__InterfaceQueue__c(
            dmpl__JobType__c = 'Service Campaign Lead Processor',
            dmpl__InterfaceRecordId__c = recordId,
            dmpl__QueueType__c = 'Queueable'
        );
        SecurityHelper.ensureCanCreateObject(
            'dmpl__InterfaceQueue__c');
        SecurityHelper.ensureCanCreateFields(
            new string[]{
                'dmpl__JobType__c',
                'dmpl__InterfaceRecordId__c',
                'dmpl__QueueType__c'
            }, 'dmpl__InterfaceQueue__c');
        
        insert queue;

        return new HeadlessActionResult(
            true, 
            'The operation was Queued. Please check back in some time. (Queue Id : ' + queue.Id + ')');
    }

    public static HeadlessActionResult processServiceRequests(
        Id recordId){
        dmpl__InterfaceQueue__c queue = new dmpl__InterfaceQueue__c(
            dmpl__JobType__c = 'Service Campaign Service Request Processor',
            dmpl__InterfaceRecordId__c = recordId,
            dmpl__QueueType__c = 'Queueable'
        );
        SecurityHelper.ensureCanCreateObject(
            'dmpl__InterfaceQueue__c');
        SecurityHelper.ensureCanCreateFields(
            new string[]{
                'dmpl__JobType__c',
                'dmpl__InterfaceRecordId__c',
                'dmpl__QueueType__c'
            }, 'dmpl__InterfaceQueue__c');
        
        insert queue;

        return new HeadlessActionResult(
            true, 
            'The operation was Queued. Please check back in some time. (Queue Id : ' + queue.Id + ')');
    }
    
    public static HeadlessActionResult processAssets(
        Id recordId){
        dmpl__InterfaceQueue__c queue = new dmpl__InterfaceQueue__c(
            dmpl__JobType__c = 'Service Campaign Asset Processor',
            dmpl__InterfaceRecordId__c = recordId,
            dmpl__QueueType__c = 'Queueable'
        );
        SecurityHelper.ensureCanCreateObject(
            'dmpl__InterfaceQueue__c');
        SecurityHelper.ensureCanCreateFields(
            new string[]{
                'dmpl__JobType__c',
                'dmpl__InterfaceRecordId__c',
                'dmpl__QueueType__c'
            }, 'dmpl__InterfaceQueue__c');
        
        insert queue;

        return new HeadlessActionResult(
            true, 
            'The operation was Queued. Please check back in some time. (Queue Id : ' + queue.Id + ')');
    }
}