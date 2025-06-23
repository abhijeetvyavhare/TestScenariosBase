@RestResource(urlMapping='/Item/GetItemPrices/*')
global with sharing class ItemAPI_GetItemPrices 
{
    private static final string FIELD_PRICETYPE = 'priceType';
    private static final string FIELD_ACCOUNTID = 'accountId';
    private static final string FIELD_PARTNERID = 'partnerId';
    private static final string FIELD_BRANCHID = 'branchId';
    private static final string FIELD_ITEMIDS = 'itemIds';
    private static final string FIELD_SKUIDS = 'skuIds';
    private static final string FIELD_DOCUMENTDATE = 'documentDate';

    @HttpGet
    global static List<dmpl__PriceListRules__c> getItemPrices()
    {
        try 
        {
            RestRequest req = RestContext.request;
            String priceType = req.params.containsKey(FIELD_PRICETYPE) && !String.IsBlank(req.params.get(FIELD_PRICETYPE)) ? String.valueOf(req.params.get(FIELD_PRICETYPE)) : null;
            String accountId = req.params.containsKey(FIELD_ACCOUNTID) && !String.IsBlank(req.params.get(FIELD_ACCOUNTID)) ? String.valueOf(req.params.get(FIELD_ACCOUNTID)) : null;
            String partnerId = req.params.containsKey(FIELD_PARTNERID) && !String.IsBlank(req.params.get(FIELD_PARTNERID)) ? String.valueOf(req.params.get(FIELD_PARTNERID)) : null;
            String branchId = req.params.containsKey(FIELD_BRANCHID) && !String.IsBlank(req.params.get(FIELD_BRANCHID)) ? String.valueOf(req.params.get(FIELD_BRANCHID)) : null;
            List<Id> itemIds = req.params.containsKey(FIELD_ITEMIDS) && !String.IsBlank(req.params.get(FIELD_ITEMIDS)) ? String.valueOf(req.params.get(FIELD_ITEMIDS)).split(',') : null;
            List<Id> skuIds = req.params.containsKey(FIELD_SKUIDS) && !String.IsBlank(req.params.get(FIELD_SKUIDS)) ? String.valueOf(req.params.get(FIELD_SKUIDS)).split(',') : null;
            Date documentDate = req.params.containsKey(FIELD_DOCUMENTDATE) && !String.IsBlank(req.params.get(FIELD_DOCUMENTDATE)) ? Date.valueOf(req.params.get(FIELD_DOCUMENTDATE)) : null;
            Id priceListId = PriceListHelper.getDefaultPriceListId(priceType, accountId, partnerId, branchId, documentDate);
            return PriceListHelper.getApplicablePrice(priceListId, itemIds, SKUIds, documentDate);
        } 
        catch (Exception error) 
        {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }
}