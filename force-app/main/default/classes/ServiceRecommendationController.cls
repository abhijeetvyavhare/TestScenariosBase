public with sharing class ServiceRecommendationController {
    @AuraEnabled(cacheable = true)
    public static List<dmpl__ServiceRecommendation__c> getServiceRecommendations(
        String fieldApiName,
        Id recordId)
    {
        MetadataService ms = new MetadataService('dmpl__ServiceRecommendation__c');
        return ms.queryObjects(
            new List<String>{
                'dmpl__RecommendationType__c',
                'dmpl__Recommendation__c',
                'dmpl__RecommendationRemarks__c',
                'dmpl__Title__c',
                'dmpl__AcceptLabel__c',
                'dmpl__RejectLabel__c',
                'dmpl__IsAccepted__c',
                'dmpl__IsRejected__c',
                'dmpl__IconName__c'},
            fieldApiName,
            recordId);
    }

    @AuraEnabled
    public static Boolean performAction(
        Id recommendationId, 
        String actionName,
        Object tag)
    {
        try {
            return ServiceRecommendationHelper.performAction(recommendationId, actionName, tag);
        } catch (Exception error) {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }

    @AuraEnabled(cacheable = false)
    public static List<dmpl__ServiceRecommendation__c> getChecklistServiceRecommendations(Id assetId, Id parentId)
    {
        SecurityHelper.ensureCanCreateFields(new string[]
        {
            'dmpl__AssetId__c',
            'dmpl__ChecklistLineId__c',
            'dmpl__ComplaintLineId__c',
            'dmpl__Condition__c',
            'dmpl__ExternalId__c',
            'dmpl__IsConsumed__c',
            'dmpl__IsUtilized__c',
            'dmpl__ItemId__c',
            'dmpl__NumericValue__c',
            'dmpl__QuoteId__c',
            'dmpl__QuoteLineId__c',
            'dmpl__RecommendationRemarks__c',
            'dmpl__RecommendationType__c',
            'dmpl__RepairOrderId__c',
            'dmpl__RepairOrderLineId__c',
            'dmpl__ServiceRequestId__c',
            'dmpl__ServiceRequestLineId__c',
            'dmpl__TextValue__c',
            'dmpl__ValueType__c'
        }, 'dmpl__ServiceRecommendation__c');
        return [
            SELECT
            dmpl__AssetId__c,
            dmpl__ChecklistLineId__c,
            dmpl__ComplaintLineId__c,
            dmpl__Condition__c,
            dmpl__ExternalId__c,
            dmpl__IsConsumed__c,
            dmpl__IsUtilized__c,
            dmpl__ItemId__c,
            dmpl__ItemId__r.Name,
            dmpl__NumericValue__c,
            dmpl__QuoteId__c,
            dmpl__QuoteLineId__c,
            dmpl__RecommendationRemarks__c,
            dmpl__RecommendationType__c,
            dmpl__RepairOrderId__c,
            dmpl__RepairOrderLineId__c,
            dmpl__ServiceRequestId__c,
            dmpl__ServiceRequestLineId__c,
            dmpl__TextValue__c,
            dmpl__ValueType__c,
            Id,
            Name
        FROM
            dmpl__ServiceRecommendation__c
        WHERE
        (dmpl__AssetId__c = : assetId AND dmpl__IsUtilized__c = false AND dmpl__RepairOrderId__c = null AND dmpl__RepairOrderLineId__c = null AND dmpl__QuoteId__c = null AND dmpl__QuoteLineId__c = null)
        OR
        (dmpl__RepairOrderId__c = : parentId OR dmpl__QuoteId__c = : parentId)
        ];
    }
}