public with sharing class ServiceRecommendationHelper {
    private static final string FIELD_REPAIRORDER_SERVICERECOMMENDATIONID = 'dmpl__ServiceRecommendationId__c';

    public static void postData(Boolean isInsert, Boolean isUpdate, Boolean isDelete, List<dmpl__ServiceRecommendation__c> newEntries, List<dmpl__ServiceRecommendation__c> oldEntries)
    {
        if(isInsert)
        {
            setAssetId(newEntries);
        }
    }

    public static Boolean performAction(
        Id recommendationId, 
        String actionName,
        Object tag){
            dmpl__ServiceRecommendation__c recomendation = [SELECT 
            dmpl__AssetId__c,
            dmpl__ChecklistLineId__c,
            dmpl__ComplaintLineId__c,
            dmpl__Condition__c,
            dmpl__ExternalId__c,
            dmpl__IsConsumed__c,
            dmpl__IsUtilized__c,
            dmpl__ItemId__c,
            dmpl__Quantity__c,
            dmpl__NumericValue__c,
            dmpl__QuoteId__c,
            dmpl__QuoteLineId__c,
            dmpl__RecommendationRemarks__c,
            dmpl__RepairOrderId__c,
            dmpl__RepairOrderLineId__c,
            dmpl__ServiceRequestId__c,
            dmpl__ServiceRequestLineId__c,
            dmpl__TextValue__c,
            dmpl__ValueType__c,
            dmpl__Source__c,
            Id,
            Name
            FROM dmpl__ServiceRecommendation__c WHERE Id = :recommendationId];
            if(actionName == 'reject'){
                recomendation.dmpl__IsRejected__c = true;
            }else if(actionName == 'accept'){
                if(recomendation.dmpl__Source__c == 'Repair Order Complaint'){
                    RepairOrderLineHelper.applyRecommendation(recomendation);
                }
                recomendation.dmpl__IsAccepted__c = true;
            }
            update recomendation;
            return true;
        }

    private static void setAssetId(List<dmpl__ServiceRecommendation__c> newEntries)
    {
        Map<Id, dmpl__ServiceRequest__c> serviceRequests = new Map<Id, dmpl__ServiceRequest__c>(queryServiceRequests(DocumentHelper.extractIds(newEntries, 'dmpl__ServiceRequestId__c')));
        for(dmpl__ServiceRecommendation__c lineEntry : newEntries)
        {
            if(lineEntry.dmpl__ServiceRequestId__c != null)
                lineEntry.dmpl__AssetId__c = serviceRequests.get(lineEntry.dmpl__ServiceRequestId__c)?.dmpl__AssetId__c;
        }
    }

    private static List<dmpl__ServiceRequest__c> queryServiceRequests(List<Id> serviceRequestIds)
    {
        return [SELECT Id, Name, dmpl__AssetId__c FROM dmpl__ServiceRequest__c WHERE Id IN : serviceRequestIds];
    }

    public static void updateServiceRecommendationFromRepairOrder(List<dmpl__RepairOrder__c> repairOrders)
    {
        List<dmpl__RepairOrderLine__c> repairOrderLines = queryRepairOrderLines(DocumentHelper.extractIds(repairOrders));
        Map<Id,dmpl__ServiceRecommendation__c> serviceRecommendations = queryServiceRecommendations(DocumentHelper.extractIds(repairOrderLines, FIELD_REPAIRORDER_SERVICERECOMMENDATIONID));

        for(dmpl__RepairOrderLine__c repairOrderLine : repairOrderLines)
        {
            dmpl__ServiceRecommendation__c serviceRecommendation = serviceRecommendations.get(repairOrderLine.dmpl__ServiceRecommendationId__c);
            if(serviceRecommendation != null)
            {
                serviceRecommendation.dmpl__IsUtilized__c = true;
                serviceRecommendation.dmpl__RepairOrderId__c = repairOrderLine.dmpl__RepairOrderId__c;
                serviceRecommendation.dmpl__RepairOrderLineId__c = repairOrderLine.Id;
            }
        }
        if(serviceRecommendations.size() > 0)
            update serviceRecommendations.values();
    }

    private static List<dmpl__RepairOrderLine__c> queryRepairOrderLines(List<Id> repairOrderIds)
    {
        SecurityHelper.ensureCanReadFields(new List<string>{'dmpl__RepairOrderId__c','dmpl__ServiceRecommendationId__c'}, 'dmpl__RepairOrderLine__c');
        return [SELECT Id, 
        Name,
        dmpl__RepairOrderId__c,
        dmpl__ServiceRecommendationId__c
        FROM dmpl__RepairOrderLine__c
        WHERE dmpl__RepairOrderId__c IN : repairOrderIds];
    }

    private static Map<Id, dmpl__ServiceRecommendation__c> queryServiceRecommendations(List<Id> serviceRecommendationIds)
    {
        SecurityHelper.ensureCanReadFields(new List<string>{'dmpl__RepairOrderId__c','dmpl__RepairOrderLineId__c','dmpl__IsUtilized__c'}, 'dmpl__ServiceRecommendation__c');
        return new Map<Id, dmpl__ServiceRecommendation__c>([SELECT Id, 
        Name,
        dmpl__RepairOrderId__c,
        dmpl__RepairOrderLineId__c,
        dmpl__IsUtilized__c
        FROM dmpl__ServiceRecommendation__c
        WHERE Id IN : serviceRecommendationIds]);
    }
}