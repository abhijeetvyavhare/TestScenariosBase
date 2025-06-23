@RestResource(urlMapping='/ProductConfiguration/*')
global with sharing class ConfigAPI_GetProductConfigurator 
{
    private static final string FIELD_RECORDID = 'recordId';   
    
    @HttpGet
    global static void getProductConfiguration()
    {
        try 
        {
            
            RestRequest req = RestContext.request;
            String recordId = req.params.containsKey(FIELD_RECORDID) && !String.IsBlank(req.params.get(FIELD_RECORDID)) ? String.valueOf(req.params.get(FIELD_RECORDID)) : null;
            JSONGenerator gen = JSON.createGenerator(false);
            gen.writeStartObject();
            gen.writeObjectField('productConfiguration', PackageHelper.getSaleOrderPackageConfiguration(recordId));
            gen.writeEndObject();
            String jsonStr = gen.getAsString();
            RestContext.response.addHeader('Content-Type', 'application/json');
            RestContext.response.responseBody = Blob.valueOf(jsonStr);
        } 
        catch (Exception error) 
        {
            ExceptionLogHelper.logException(error);
            throw error;
        }
    }

    @HttpPost
    global static void applyProductConfiguration()
    {
        Map<String,object> request = (Map<String,object>)JSON.deserializeUntyped(RestContext.request.requestBody.toString());
        String recordId = (Id)request.get(FIELD_RECORDID);
        List<PackageConfigLine> componentSettings = (List<PackageConfigLine>)JSON.deserializeStrict(JSON.serialize(request.get('componentSettings')), Type.forName('List<PackageConfigLine>'));
        PackageHelper.applySaleOrderPackageConfiguration(recordId, componentSettings);
        Id saleOrderId = [SELECT Id, Name, dmpl__SaleOrderId__c FROM dmpl__SaleOrderLine__c WHERE Id = : recordId LIMIT 1].dmpl__SaleOrderId__c;
        JSONGenerator gen = JSON.createGenerator(false);
        gen.writeStartObject();
        gen.writeObjectField('saleOrderLines', querySaleOrderLines(saleOrderId));
        gen.writeEndObject();
        String jsonStr = gen.getAsString();
        RestContext.response.addHeader('Content-Type', 'application/json');
        RestContext.response.responseBody = Blob.valueOf(jsonStr);
    }

    @TestVisible
    private static List<dmpl__SaleOrderLine__c> querySaleOrderLines(Id saleOrderId)
    {
        return [Select 
        Id,Name,dmpl__ItemId__c,dmpl__SKUId__c,dmpl__Quantity__c,dmpl__TaxGroupId__c,dmpl__UnitPrice__c,dmpl__Discount__c,dmpl__SchemeDiscount__c,dmpl__DiscountAmount__c,dmpl__SchemeDiscountAmount__c,dmpl__PackageSaleOrderLineId__c,dmpl__SaleOrderId__c 
        FROM dmpl__SaleOrderLine__c 
        WHERE dmpl__SaleOrderId__c = : saleOrderId];
    }
}