@RestResource(urlMapping='/Item/GetItems/*')
global with sharing class ItemAPI_GetItems 
{
    private static final string FIELD_ITEMTYPE = 'itemType';
    private static final string FIELD_PAGENUMBER = 'pageNumber';
    private static final string FIELD_PAGESIZE = 'pageSize';

    @HttpGet
    global static List<dmpl__Item__c> getItems()
    {
        try 
        {
            RestRequest req = RestContext.request;
            String itemType = req.params.containsKey(FIELD_ITEMTYPE) ? String.valueOf(req.params.get(FIELD_ITEMTYPE)) : '';
            Integer pageNumber =  req.params.containsKey(FIELD_PAGENUMBER) ? Integer.valueOf(req.params.get(FIELD_PAGENUMBER)) : 0;
            Integer pageSize = req.params.containsKey(FIELD_PAGESIZE) ? Integer.valueOf(req.params.get(FIELD_PAGESIZE)) : 0;
            return ItemHelper.queryItems(itemType, pageNumber, pageSize);
        } 
        catch (Exception error) 
        {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }
}