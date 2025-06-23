@RestResource(urlMapping='/Item/GetItem/*')
global with sharing class ItemAPI_GetItem 
{
    private static final string FIELD_ITEMID = 'itemId';

    @HttpGet
    global static dmpl__Item__c getItem()
    {
        try 
        {
            RestRequest req = RestContext.request;
            String itemId = req.params.containsKey(FIELD_ITEMID) ? String.valueOf(req.params.get(FIELD_ITEMID)) : null;
            return ItemHelper.getCachedItem(itemId);
        } 
        catch (Exception error) 
        {ExceptionLogHelper.logException(error);
            throw error;
        }
    }
}