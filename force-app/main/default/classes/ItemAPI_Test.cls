@IsTest
public class ItemAPI_Test {
    
    @isTest
    public static void ItemAPI_GetItemPrice_Success()
    {
        Test.startTest();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/dmpl/Item/GetItemPrice'; 
        req.params.put('priceType', 'Sale Price');
        req.params.put('accountId', '0019D00000LXFHdQAP');
        req.params.put('partnerId', '0019D00000LXIzkQAH');
        req.params.put('branchId', 'a0E9D000002btizUAA');
        req.params.put('itemId', 'a199D000001GvkXQAS');
        req.params.put('skuId', 'a1c9D0000020jcGQAQ');
        req.params.put('priceListId', 'a1G9D000001AvrRUAS');
        req.params.put('documentDate','2022-01-01');
        req.httpMethod = 'GET';
        req.addHeader('Content-Type', 'application/json'); 
        RestContext.request = req;
        RestContext.response = res;
        
        ItemAPI_GetItemPrice.getItemPrice();
        System.assert(req !=null, 'Item data');
        Test.stopTest();  
    }
    
    
    @isTest
    public static void ItemAPI_GetItemPrices_Success()
    {
        Test.startTest();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/dmpl/Item/GetItemPrices'; 
        req.params.put('priceType', 'Sale Price');
        req.params.put('accountId', '0019D00000LXFHdQAP');
        req.params.put('partnerId', '0019D00000LXIzkQAH');
        req.params.put('branchId', 'a0E9D000002btizUAA');
        req.params.put('itemIds', 'a199D000001GvkXQAS');
        req.params.put('skuIds', 'a1c9D0000020jcGQAQ');
        req.params.put('priceListId', 'a1G9D000001AvrRUAS');
        req.params.put('documentDate','2022-01-01');
        req.httpMethod = 'GET';
        req.addHeader('Content-Type', 'application/json'); 
        RestContext.request = req;
        RestContext.response = res;
        
        ItemAPI_GetItemPrices.getItemPrices();
        System.assert(req !=null, 'Item data');
        Test.stopTest();  
    }
    
    
    @isTest
    public static void ItemAPI_GetItem_Success()
    {
        Test.startTest();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/dmpl/Item/GetItem'; 
        req.params.put('itemId', 'a199D000001GvkXQAS');
        req.httpMethod = 'GET';
        req.addHeader('Content-Type', 'application/json'); 
        RestContext.request = req;
        RestContext.response = res;
        
        ItemAPI_GetItem.getItem();
        System.assert(req !=null, 'Item data');
        Test.stopTest();  
    }
    
     @isTest
    public static void ItemAPI_GetItems_Success()
    {
        Test.startTest();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/dmpl/Item/GetItems'; 
        req.params.put('postalCode', 'Service Appointment');
        req.params.put('itemType', 'Product');
        req.params.put('pageNumber', string.valueOf(3));
        req.params.put('pageSize', string.valueOf(10));
        req.httpMethod = 'GET';
        req.addHeader('Content-Type', 'application/json'); 
        RestContext.request = req;
        RestContext.response = res;
        
        ItemAPI_GetItems.getItems();
        System.assert(req !=null, 'Item data');
        Test.stopTest();  
    }

    @isTest
    public static void ItemAPI_GetItems_Error()
    {
        Test.startTest();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/dmpl/Item/GetItems'; 
        req.params.put('itemType', '10.2');
        req.params.put('pageNumber', '3');
        req.params.put('pageSize', '10');
        req.httpMethod = 'GET';
        req.addHeader('Content-Type', 'application/json'); 
        RestContext.request = req;
        RestContext.response = res;
        
        ItemAPI_GetItems.getItems();
        System.assert(req !=null, 'Item data');
        Test.stopTest();  
    }
    
}