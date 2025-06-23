@isTest
public with sharing class ServiceRecommendationTestDataHelper {
    public static dmpl__ServiceRecommendation__c createServiceRecommendation(
        dmpl__ServiceRequest__c serviceRequest,
        dmpl__ServiceRequestLine__c serviceRequestLine,
        dmpl__QuoteLine__c quoteLine,
        dmpl__Quote__c serviceEstimate,
        dmpl__Item__c item,
        dmpl__ComplaintLine__c complaintLine,
        dmpl__ComplaintItem__c complaintItem,
        Asset asset
    ) {
        return (dmpl__ServiceRecommendation__c) TestFactory.createSObject(
            new dmpl__ServiceRecommendation__c (
                dmpl__ServiceRequestId__c = serviceRequest.Id,
                dmpl__ServiceRequestLineId__c=serviceRequestLine.Id,
                dmpl__QuoteLineId__c=quoteLine.Id,
                dmpl__QuoteId__c = serviceEstimate.Id,
                dmpl__ItemId__c = item.Id,
                dmpl__ComplaintLineId__c = complaintLine.Id,
                dmpl__ComplaintItemId__c = complaintItem.Id,
                dmpl__AssetId__c = asset.Id
            ),
            'ServiceRecommendationDefaults',
            true
        );
    }

    public static dmpl__ServiceRecommendation__c getServiceRecommendation() {
        return [
            SELECT 
                Id, 
                dmpl__AcceptLabel__c,
                dmpl__Recommendation__c,
                dmpl__RecommendationRemarks__c,
                dmpl__IsRejected__c,
                dmpl__RejectLabel__c,
                dmpl__ServiceRequestId__c,
                dmpl__ServiceRequestLineId__c,
                dmpl__RepairOrderId__c,
                dmpl__QuoteLineId__c,
                dmpl__RepairOrderLineId__c,
                dmpl__QuoteId__c,
                dmpl__ItemId__c,
                dmpl__ComplaintLineId__c,
                dmpl__ComplaintItemId__c,
                dmpl__AssetId__c
            FROM dmpl__ServiceRecommendation__c 
            LIMIT 1
        ];
    }

    public static dmpl__ServiceRecommendation__c getServiceRecommendation(Id serviceRecommendationId) {
        return [
            SELECT 
                Id, 
                dmpl__AcceptLabel__c,
                dmpl__Recommendation__c,
                dmpl__RecommendationRemarks__c,
                dmpl__IsRejected__c,
                dmpl__RejectLabel__c,
                dmpl__ServiceRequestId__c,
                dmpl__ServiceRequestLineId__c,
                dmpl__RepairOrderId__c,
                dmpl__QuoteLineId__c,
                dmpl__RepairOrderLineId__c,
                dmpl__QuoteId__c,
                dmpl__ItemId__c,
                dmpl__ComplaintLineId__c,
                dmpl__ComplaintItemId__c,
                dmpl__AssetId__c
            FROM dmpl__ServiceRecommendation__c 
            WHERE Id = :serviceRecommendationId 
            LIMIT 1
        ];
    }
}