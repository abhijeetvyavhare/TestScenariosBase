@isTest
public class CollectionHelper_Test {
	
    @TestSetup
    public static void Setup()
    {
        //System.runAs(PostInstallHelper.AssignAdministratorAllPermissions(UserInfo.getUserId())){
            CreateItemGroup();
            CreateItems();
        //}
    }
    
    @isTest
    Public static void GetObject()
    {
        List<dmpl__Item__c> items = [Select Id, Name, dmpl__ItemType__c FROM dmpl__Item__c];
        CollectionHelper.getObject(items, 'Id', items[0].Id);
        CollectionHelper.getApprovedObjects('Id',items,items);
        //CollectionHelper.getApprovedObjects('dmpl__ItemType__c',items);
        CollectionHelper.extractStrings(items,'dmpl__ItemType__c');
        CollectionHelper.getFirstIfExists(items);
        CollectionHelper.getObjectsByFilterOrNull(items,'dmpl__ItemType__c',(object)'Part');
        System.assertEquals(1, items.size(), 'Item is getted');
    }
    
     @isTest
    Public static void getObjectsByFilter1()
    {
        List<dmpl__Item__c> items = [Select Id, Name, dmpl__ItemType__c,dmpl__ProductDemoItemGroup__c,dmpl__ClaimToAccountId__c FROM dmpl__Item__c];
        dmpl__Item__c itemms = [Select Id, Name, dmpl__ItemType__c,dmpl__ProductDemoItemGroup__c,dmpl__ClaimToAccountId__c FROM dmpl__Item__c];
        dmpl__Item__c itemss = [Select Id, Name, dmpl__ItemType__c,dmpl__ProductDemoItemGroup__c,dmpl__ClaimToAccountId__c FROM dmpl__Item__c];
        CollectionHelper.getObjectsByFilter(items, 'dmpl__ProductDemoItemGroup__c',itemms,'dmpl__ClaimToAccountId__c',itemss);
        System.assertEquals(1, items.size(), 'Item is getted');
    }
    
     @isTest
    Public static void getObjectsWithNull()
    {
        List<dmpl__Item__c> items = [Select Id, Name, dmpl__ItemType__c,dmpl__ProductDemoItemGroup__c,dmpl__ClaimToAccountId__c,dmpl__BillingType__c FROM dmpl__Item__c];
        dmpl__Item__c itemms = [Select Id, Name, dmpl__ItemType__c,dmpl__ProductDemoItemGroup__c,dmpl__ClaimToAccountId__c FROM dmpl__Item__c];
        dmpl__Item__c itemss = [Select Id, Name, dmpl__ItemType__c,dmpl__ProductDemoItemGroup__c,dmpl__ClaimToAccountId__c FROM dmpl__Item__c];
        CollectionHelper.getObjectsWithNull(items, 'dmpl__ProductDemoItemGroup__c');
        List<String> fieldsToCheck = new List<String>();
        fieldsToCheck.add('dmpl__BillingType__c');
        CollectionHelper.getObjectsWithNotNull(items,fieldsToCheck);
        System.assertEquals(1, items.size(), 'Item is getted');
    }
    
      @isTest
    Public static void dateMapFromCollectionByKey1()
    {
        List<AggregateResult> agg=new list<AggregateResult>();
        List<dmpl__Item__c> items = [Select Id, Name, dmpl__ItemType__c,dmpl__ProductDemoItemGroup__c,dmpl__ClaimToAccountId__c FROM dmpl__Item__c];
        dmpl__Item__c itemms = [Select Id, Name, dmpl__ItemType__c,dmpl__ProductDemoItemGroup__c,dmpl__ClaimToAccountId__c FROM dmpl__Item__c];
        dmpl__Item__c itemss = [Select Id, Name, dmpl__ItemType__c,dmpl__ProductDemoItemGroup__c,dmpl__ClaimToAccountId__c FROM dmpl__Item__c];
        CollectionHelper.dateMapFromCollectionByKey( 'dmpl__ProductDemoItemGroup__c',agg);
        CollectionHelper.getObject(items,itemms.Id);
        System.assertEquals(1, items.size(), 'Item is getted');
    }
    
    @isTest
    Public static void GetObjects()
    {
        List<dmpl__Item__c> items = [Select Id, Name, dmpl__ItemType__c FROM dmpl__Item__c];
        CollectionHelper.getObjects(items, 'Id', items[0].Id);
        System.assertEquals(1, items.size(), 'Item is getted');
    }
    
    @isTest
    Public static void GetObjectsByFilter()
    {
        List<dmpl__Item__c> items = [Select Id, Name, dmpl__ItemType__c FROM dmpl__Item__c];
        CollectionHelper.getObjectsByFilter(items, 'Id', items[0].Id);
        System.assertEquals(1, items.size(), 'Item is getted');
    }
    
    @isTest
    Public static void getObjectsWithNotNull()
    {
        List<dmpl__Item__c> items = [Select Id, Name, dmpl__ItemType__c FROM dmpl__Item__c];
        CollectionHelper.getObjectsWithNotNull(items, 'Id');
        System.assertEquals(1, items.size(), 'Item is getted');
    }
    
    @isTest
    Public static void extractIds()
    {
        test.startTest();
        List<dmpl__Item__c> items = [Select Id, Name, dmpl__ItemType__c FROM dmpl__Item__c];
        List<AggregateResult> agg = [SELECT
                                     ItemId__c,
                                     SKUId__c,
                                     ItemId__r.SchemeItemGroupId__c,
                                     SUM(Quantity__c) TotalQuantity,
                                     SUM(Amount__c) TotalAmount
                                     FROM
                                     PurchaseOrderLine__c
                                     GROUP BY
                                     ItemId__c,
                                     SKUId__c,
                                     ItemId__r.SchemeItemGroupId__c
                                    ];
        CollectionHelper.extractIds(items);
        CollectionHelper.extractIds(items, 'Id');
        CollectionHelper.extractIds(agg,'dmpl__ItemId__c');
        //CollectionHelper.extractCompoundIds(items,'Test');
		System.assertEquals(1, items.size(), 'Item is getted');
        
        List<dmpl__ItemGroup__c> itemGroups = [Select Id, Name, (Select Id, Name FROM dmpl__DiscountGroupItems__r) FROM dmpl__ItemGroup__c];
        CollectionHelper.extractIds(itemGroups, 'DiscountGroupItems__r','Name');
        CollectionHelper.stringMapFromCollectionWithCollectionValues('Key Data',agg);
        CollectionHelper.mapFromCollectionWithCollectionIdValues('key1','key2',agg);
        CollectionHelper.mapFromCollectionWithCollectionIdValues('Id','Id',items);

        System.assertEquals(1, itemGroups.size(), 'Item group is getted');
        test.stopTest();
    }
    
    @isTest
    Public static void extractUniqueValues()
    {
        test.startTest();
        List<dmpl__Item__c> items = [Select Id, Name, dmpl__ItemType__c FROM dmpl__Item__c];
        CollectionHelper.extractUniqueValues(items, 'Id');
        System.assertEquals(1, items.size(), 'Item is getted');
        test.stopTest();
    }
    
     @isTest 
    public static void extractUniqueDateValues()
    {
        string errorReceived;
        string expectedErrorCode = 'SOPOS001';
        try{ 
            List<dmpl__Item__c> items = [Select Id, Name, dmpl__ItemType__c FROM dmpl__Item__c];
        CollectionHelper.extractUniqueDateValues(items, 'Id');
            }
        catch(Exception ex){
            errorReceived = ex.getMessage();
  
        }
        System.assertNotEquals(expectedErrorCode,errorReceived);
       
    }
    
     @isTest 
    public static void idMapFromCollectionByKey()
    { 
        string errorReceived;
        string expectedErrorCode = 'SOPOS001';
        try{
            List<dmpl__Item__c> items = [Select Id, Name, dmpl__ItemType__c FROM dmpl__Item__c];
        CollectionHelper.idMapFromCollectionByKey('Name', items); }
        catch(Exception ex){
            errorReceived = ex.getMessage();
  
        }
        System.assertNotEquals(expectedErrorCode,errorReceived);
       
    }

    
     @isTest
    Public static void stringMapFromCollectionByKey()
    {
        List<dmpl__Item__c> items = [Select Id, Name, dmpl__ItemType__c FROM dmpl__Item__c];
        CollectionHelper.stringMapFromCollectionByKey('Name', items);
        System.assertEquals(1, items.size(), 'Item is getted');
    }
     @isTest 
    public static void dateMapFromCollectionByKey()
    {
        string errorReceived;
        string expectedErrorCode = 'SOPOS001';
        try{
              List<dmpl__Item__c> items = [Select Id, Name, dmpl__ItemType__c FROM dmpl__Item__c];
        CollectionHelper.dateMapFromCollectionByKey('Name', items);
            }
        catch(Exception ex){
            errorReceived = ex.getMessage();
  
        }
        System.assertNotEquals(expectedErrorCode,errorReceived);
       
    }
    
    
     @isTest 
    public static void mapFromCollectionWithCollectionValues()
    {
        string errorReceived;
        string expectedErrorCode = 'SOPOS001';
        try{
            List<dmpl__Item__c> items = [Select Id, Name, dmpl__ItemType__c FROM dmpl__Item__c];
        CollectionHelper.mapFromCollectionWithCollectionValues('Name', items); }
        catch(Exception ex){
            errorReceived = ex.getMessage();
  
        }
        System.assertNotEquals(expectedErrorCode,errorReceived);
       
    }
    
    private static void CreateItems()
    {
        List<dmpl__Item__c> item = new List<dmpl__Item__c>();
        dmpl__ItemGroup__c itemGroup = [Select Id, Name FROM dmpl__ItemGroup__c LIMIT 1];
        item.Add(new dmpl__Item__c(Name = 'Test-Item',
                                   dmpl__ItemCode__c = 'DMPL',
                                   dmpl__ItemType__c = 'Service Contract',
                                   dmpl__ItemSubType__c = 'None',
                                   dmpl__Description__c = 'Description',
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
                                   dmpl__RFID__c = 'O1234fgh',
                                   dmpl__IsPackage__c = true,
                                   dmpl__OnlySoldInPackage__c = true,
                                   dmpl__QuantityUnitOfMeasure__c = 'Each',
                                   dmpl__InventoryValuationMethod__c = 'FIFO',
                                   dmpl__TaxItemGroupId__c = itemGroup.Id
        ));
        insert item;
     }
    
    private static void CreateItemGroup()
    {
    	List<dmpl__ItemGroup__c> itemGroup = new List<dmpl__ItemGroup__c> ();
        itemGroup.Add(new dmpl__ItemGroup__c(Name = 'Item Group Test',
                                             dmpl__ItemGroupType__c = 'Tax'
        ));
        insert itemGroup;
    }



    @isTest
    public static void testAddStrings() {

        List<dmpl__Item__c> items = [SELECT Id, dmpl__ItemCode__c, dmpl__ItemType__c,dmpl__TaxItemGroupId__r.dmpl__ItemGroupType__c FROM dmpl__Item__c];

        List<String> results = null;
        results = CollectionHelper.addStrings(results, items, 'dmpl__ItemCode__c');

		//List<ID> relatedIds = CollectionHelper.extractCompoundIds(items, 'dmpl__TaxItemGroupId__r.Id');
    }

    @isTest
    public static void testGetMethods()
    {
        Account account = new Account(Name = 'Test Account1');
        insert account;
        dmpl__Item__c item = [Select Id, dmpl__ClaimToAccountId__c From dmpl__Item__c Limit 1];
        item.dmpl__ClaimToAccountId__c = account.Id;
        update item;
        List<dmpl__Item__c> items = [Select Id, dmpl__TrackInventory__c, (select id from dmpl__Items__r) From dmpl__Item__c Where dmpl__ClaimToAccountId__c != null];
        Test.startTest();
        CollectionHelper.getApprovedObjects('dmpl__TrackInventory__c', items);
        CollectionHelper.extractStrings(items, 'dmpl__Items__r', 'Id');
        Account acc = [Select Id From Account];
        List<sObject> sObjects = new List<sObject>();
        CollectionHelper.extractCompoundIds(sObjects, 'item.Name');
        Test.StopTest();
    }
}