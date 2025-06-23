@RestResource(urlMapping='/Branch/GetBranchDateSlots/*')
global with sharing class BranchAPI_GetBranchDateSlots 
{
    private static final Integer MAX_DAYS_COUNT = 30;

    private static final string FIELD_TRANSACTIONTYPE = 'transactionType';
    private static final string FIELD_BRANCHID = 'branchId';
    private static final string FIELD_ITEMID = 'itemId';
    private static final string FIELD_DAYSCOUNT = 'daysCount';
    private static final string FIELD_SERVICETYPE = 'serviceType';
    private static final string FIELD_SERVICEJOBTYPE = 'serviceJobType';
    
    @HttpGet
    global static List<dmpl__BranchDateSlotResult__c> getBranchDateSlots()
    {
        RestRequest req = RestContext.request;
        String transactionType = req.params.containsKey(FIELD_TRANSACTIONTYPE) ? String.valueOf(req.params.get(FIELD_TRANSACTIONTYPE)) : '';
        Id branchId = req.params.containsKey(FIELD_BRANCHID) ? (Id)String.valueOf(req.params.get(FIELD_BRANCHID)) : null;
        Id itemId = req.params.containsKey(FIELD_ITEMID) ? (Id)String.valueOf(req.params.get(FIELD_ITEMID)) : null;
        Integer daysCount = req.params.containsKey(FIELD_DAYSCOUNT) ? Integer.valueOf(req.params.get(FIELD_DAYSCOUNT)) : 0;
        Integer safeDaysCount = daysCount > MAX_DAYS_COUNT ? MAX_DAYS_COUNT : daysCount;
        String serviceType = req.params.containsKey(FIELD_SERVICETYPE) ? String.valueOf(req.params.get(FIELD_SERVICETYPE)) : null;
        String serviceJobType = req.params.containsKey(FIELD_SERVICEJOBTYPE) ? String.valueOf(req.params.get(FIELD_SERVICEJOBTYPE)) : null;

        try 
        {
            List<BranchDateSlotResult> result = BranchHelper.getBranchDateSlots(transactionType, branchId, itemId, serviceType, serviceJobType, safeDaysCount);
            return mapBranchDateSlots(result);
        } 
        catch (Exception error) 
        {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }

    @TestVisible private static List<dmpl__BranchDateSlotResult__c> mapBranchDateSlots(List<BranchDateSlotResult> branchDateSlotResults)
    {
        List<dmpl__BranchDateSlotResult__c> result = new List<dmpl__BranchDateSlotResult__c>();
        for(BranchDateSlotResult branchDateSlotResult : branchDateSlotResults)
        {
            result.Add(
                new dmpl__BranchDateSlotResult__c(
                    dmpl__BookingDate__c = branchDateSlotResult.bookingDate,
                    dmpl__Capacity__c =  branchDateSlotResult.capacity,
                    dmpl__CapacityUtilized__c = branchDateSlotResult.capacityUtilized));
        }
        return result;
    }
}