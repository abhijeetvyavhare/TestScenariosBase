@isTest
public class SkuHelper_Test {
    
    @testsetup
    public static void setup()
    {
        System.runAs(PostInstallHelper.AssignAdministratorAllPermissions(UserInfo.getUserId())){
            CreateItems();
            CreateSKu();
        }
    }
    
    @isTest
    public static void UpdateSKU()
    {
        dmpl__SKU__c sku = [Select Id,Name,dmpl__UnitOfMeasureOfConversion__c From dmpl__SKU__c LIMIT 1];
        
        update sku;
        System.assertEquals(10, sku.dmpl__UnitOfMeasureOfConversion__c, 'SKU updated 1 record');
    }
    
    @isTest
    public static void DeleteSKU()
    {
        dmpl__SKU__c sku = [Select Id,Name,dmpl__UnitOfMeasureOfConversion__c From dmpl__SKU__c LIMIT 1];
        
        Delete sku;
        System.assertEquals(10, sku.dmpl__UnitOfMeasureOfConversion__c, 'SKU deleted 1 record');
    }
    
    private static void CreateItems()
    {
        List<dmpl__Item__c> item = new List<dmpl__Item__c>();
        item.Add(new dmpl__Item__c(Name = 'Test-Item',
                                   dmpl__ItemCode__c = 'DMPL',
                                   dmpl__ItemType__c = '',
                                   dmpl__ItemSubType__c = '', 
                                   dmpl__Description__c = '',
                                   dmpl__ItemFamily__c = 'Sample',
                                   dmpl__ItemSegment__c = 'Sample',
                                   dmpl__Make__c = 'Sample',
                                   dmpl__Model__c = 'Sample',
                                   dmpl__TrackInventory__c = true,
                                   dmpl__TrackLots__c = true,
                                   dmpl__IsSKURequired__c = true,
                                   dmpl__RequireInspectionOnReceipt__c = true,
                                   dmpl__RequireInspectionOnDelivery__c = true,
                                   dmpl__AllowService__c = true,
                                   dmpl__TrackAsset__c = true,                               
                                   dmpl__IsActive__c = true,
                                   dmpl__IsRegistrationRequired__c = true,
                                   dmpl__GTIN__c = 'BR123',
                                   dmpl__RFID__c = 'O1234fgh'
        ));
        insert item;
    }
    
    private static void CreateSKu()
    {
        List<dmpl__SKU__c> sku = new List<dmpl__SKU__c>();
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        sku.add(new dmpl__SKU__c(Name = 'Test - SKU',
                                 dmpl__SKUCode__c = 'Test - SKU - Code',
                                 dmpl__UnitOfMeasureOfConversion__c = 10,
                                 dmpl__ProductColor__c = 'Sample',
                                 dmpl__IsDefault__c = true,
                                 dmpl__QuantityUnitOfMeasure__c ='Sample',
                                 dmpl__ItemId__c = item.Id));
        insert sku;      
    }
}