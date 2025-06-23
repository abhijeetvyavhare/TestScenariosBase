public with sharing class ProductHealthCheckRecommendationHelper {

    private static final string FIELD_REPAIRORDER_ASSETID = 'dmpl__AssetId__c';

    public static void identityAndTagRepairOrder(List<dmpl__RepairOrder__c> repairOrders)
    {
        List<dmpl__ProductHealthCheckRecommendation__c> productRecommendations = new List<dmpl__ProductHealthCheckRecommendation__c>();
        repairOrders = queryRepairOrders(DocumentHelper.extractIds(repairOrders));
        List<dmpl__ProductHealthCheck__c> productHealthChecks = queryProductHealthCheck(DocumentHelper.extractIds(repairOrders,FIELD_REPAIRORDER_ASSETID));

        for(dmpl__RepairOrder__c repairOrder : repairOrders)
        {
            for(dmpl__ProductHealthCheck__c productHealthCheck : productHealthChecks)
            {
                if(productHealthCheck.dmpl__AssetId__c == repairOrder.dmpl__AssetId__c)
                {
                    for(dmpl__ProductHealthCheckRecommendation__c recommendation : productHealthCheck.VehicleHealthCheckDetailsPosting__r)
                    {
                        for(dmpl__RepairOrderLine__c repairOrderLine : repairOrder.Repair_Order_Lines1__r)
                        {
                            if(recommendation.dmpl__ItemId__c == repairOrderLine.dmpl__ItemId__c)
                            {
                                recommendation.dmpl__RepairOrderId__c = repairOrder.Id;
                                recommendation.dmpl__RepairOrderLineId__c = repairOrderLine.Id;
                                recommendation.dmpl__IsUtilized__c = true;
                                if(!productRecommendations.contains(recommendation))
                                    productRecommendations.add(recommendation);
                            }
                        }
                    }
                }
            }
        }

        if(productRecommendations.size() > 0)
        {
            try{
                update productRecommendations;
            } catch(Exception error){
                ExceptionLogHelper.logException(error);
                throw error;
            } finally {

            }
        }
    }

    private static List<dmpl__RepairOrder__c> queryRepairOrders(List<Id> repairOrderIds)
    {
        SecurityHelper.ensureCanReadFields(new List<String>{
            'Name', 
            'dmpl__AssetId__c',
            'dmpl__BranchId__c'
        },'dmpl__RepairOrder__c');
        return [SELECT 
        Id,
        Name,
        dmpl__AssetId__c,
        (
            SELECT Id,
            Name, 
            dmpl__ItemId__c
            FROM Repair_Order_Lines1__r
        )
        FROM dmpl__RepairOrder__c
        WHERE Id IN : repairOrderIds];
    }

    private static List<dmpl__ProductHealthCheck__c> queryProductHealthCheck(List<Id> assetIds)
    {
        SecurityHelper.ensureCanReadFields(new List<String>{
            'Name', 
            'dmpl__AssetId__c',
            'dmpl__BranchId__c',
            'dmpl__Status__c'
        },'dmpl__ProductHealthCheck__c');
        return [SELECT Id,
        Name, 
        dmpl__AssetId__c,
        dmpl__BranchId__c,
        dmpl__Status__c,
        (
            SELECT Id,
            dmpl__ComplaintPostingId__c,
            dmpl__Condition__c,
            dmpl__IsConsumed__c,
            dmpl__ItemId__c,
            dmpl__VehicleHealthCheckPostingId__c,
            dmpl__ItemHealthCheckId__c,
            dmpl__NumericValue__c,
            dmpl__RecommendationRemarks__c,
            dmpl__RepairOrderId__c,
            dmpl__RepairOrderLineId__c,
            dmpl__ServiceEstimateId__c,
            dmpl__ServiceEstimateLineId__c,
            dmpl__TextValue__c,
            dmpl__ValueType__c
            FROM VehicleHealthCheckDetailsPosting__r
        )
        FROM dmpl__ProductHealthCheck__c
        WHERE dmpl__AssetId__c IN : assetIds];
    }
}