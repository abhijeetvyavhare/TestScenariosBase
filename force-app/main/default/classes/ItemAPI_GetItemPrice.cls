@RestResource(urlMapping='/Item/GetItemPrice/*')
global with sharing class ItemAPI_GetItemPrice 
{
    private static final string FIELD_PRICETYPE = 'priceType';
    private static final string FIELD_ACCOUNTID = 'accountId';
    private static final string FIELD_PARTNERID = 'partnerId';
    private static final string FIELD_BRANCHID = 'branchId';
    private static final string FIELD_ITEMID = 'itemId';
    private static final string FIELD_SKUID = 'SKUId';
    private static final string FIELD_DOCUMENTDATE = 'documentDate';

    @HttpGet
    global static Double getItemPrice()
    {
        try 
        {
            
            RestRequest req = RestContext.request;
            String priceType = req.params.containsKey(FIELD_PRICETYPE) && !String.IsBlank(req.params.get(FIELD_PRICETYPE)) ? String.valueOf(req.params.get(FIELD_PRICETYPE)) : null;
            String accountId = req.params.containsKey(FIELD_ACCOUNTID) && !String.IsBlank(req.params.get(FIELD_ACCOUNTID)) ? String.valueOf(req.params.get(FIELD_ACCOUNTID)) : null;
            String partnerId = req.params.containsKey(FIELD_PARTNERID) && !String.IsBlank(req.params.get(FIELD_PARTNERID)) ? String.valueOf(req.params.get(FIELD_PARTNERID)) : null;
            String branchId = req.params.containsKey(FIELD_BRANCHID) && !String.IsBlank(req.params.get(FIELD_BRANCHID)) ? String.valueOf(req.params.get(FIELD_BRANCHID)) : null;
            String itemId = req.params.containsKey(FIELD_ITEMID) && !String.IsBlank(req.params.get(FIELD_ITEMID)) ? String.valueOf(req.params.get(FIELD_ITEMID)) : null;
            String skuId = req.params.containsKey(FIELD_SKUID) && !String.IsBlank(req.params.get(FIELD_SKUID)) ? String.valueOf(req.params.get(FIELD_SKUID)) : null;
            Date documentDate = req.params.containsKey(FIELD_DOCUMENTDATE) && !String.IsBlank(req.params.get(FIELD_DOCUMENTDATE)) ? Date.valueOf(req.params.get(FIELD_DOCUMENTDATE)) : null;
            Id priceListId = PriceListHelper.getDefaultPriceListId(priceType, accountId, partnerId, branchId, documentDate);
            return PriceListHelper.getApplicablePrice(priceListId, itemId, SKUId, documentDate);
        } 
        catch (Exception error) 
        {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }
}