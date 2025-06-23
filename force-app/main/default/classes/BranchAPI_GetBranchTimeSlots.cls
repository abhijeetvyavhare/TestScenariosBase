@RestResource(urlMapping='/Branch/GetBranchTimeSlots/*')
global with sharing class BranchAPI_GetBranchTimeSlots 
{
    private static final string FIELD_TRANSACTIONTYPE = 'transactionType';
    private static final string FIELD_BRANCHID = 'branchId';
    private static final string FIELD_ITEMID = 'itemId';
    private static final string FIELD_BOOKINGDATE = 'bookingDate';
    private static final string FIELD_SERVICETYPE = 'serviceType';
    private static final string FIELD_SERVICEJOBTYPE = 'serviceJobType';
    
    @HttpGet
    global static List<dmpl__BranchTimeSlot__c> getBranchTimeSlots()
    {
        try 
        {
            RestRequest req = RestContext.request;
            String transactionType = req.params.containsKey(FIELD_TRANSACTIONTYPE) ? String.valueOf(req.params.get(FIELD_TRANSACTIONTYPE)) : '';
            Id branchId = req.params.containsKey(FIELD_BRANCHID) ? (Id)String.valueOf(req.params.get(FIELD_BRANCHID)) : null;
            Id itemId = req.params.containsKey(FIELD_ITEMID) ? (Id)String.valueOf(req.params.get(FIELD_ITEMID)) : null;
            Date bookingDate = req.params.containsKey(FIELD_BOOKINGDATE) ? Date.valueOf(req.params.get(FIELD_BOOKINGDATE)) : null;
            String serviceType = req.params.containsKey(FIELD_SERVICETYPE) ? String.valueOf(req.params.get(FIELD_SERVICETYPE)) : null;
            String serviceJobType = req.params.containsKey(FIELD_SERVICEJOBTYPE) ? String.valueOf(req.params.get(FIELD_SERVICEJOBTYPE)) : null;
    
            return BranchHelper.getBranchTimeSlots(transactionType, branchId, itemId, serviceType, serviceJobType, bookingDate);
        } 
        catch (Exception error) 
        {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }
}