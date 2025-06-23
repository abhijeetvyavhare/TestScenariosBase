@isTest
public class ItemHelper_Test {
    
    @testsetup   
    public static void setup()
    {
        //System.runAs(PostInstallHelper.AssignAdministratorAllPermissions(UserInfo.getUserId())){
            CreateAccountGroup();
            CreateAccount();
            CreateBranch();
            CreateItems();
            CreateSKu();
            CreateItemMaintenanceSchedule();
            CreateItemFeatures();
            CreateItemComponent();
            CreateItemInventoryAttribute();
        //}
    }
    
    @isTest
    public static void getItemAlternateStock()
    {
        dmpl__ItemComponent__c itemCom= [Select Id,
                                         Name,
                                         dmpl__ItemId__c,
                                         dmpl__PartnerAccountId__c,
                                         dmpl__PartnerAccountGroupId__c
                                         From  dmpl__ItemComponent__c Limit 1 ];
        List<Account> acc=[select Id from Account Limit 1];
        dmpl__Branch__c branch=[select Id, Name from dmpl__Branch__c Limit 1];
        ItemController.getItemAlternateStock(itemCom.dmpl__ItemId__c,itemCom.dmpl__PartnerAccountId__c,branch.Id);
        System.assertEquals(1, acc.size(), 'account data');
    }
   
    
    @isTest
    public static void VerifyPackageComponentLine()
    {
        dmpl__ItemComponent__c itemCom= [Select Id,
                                         Name,
                                         dmpl__ItemId__c,
                                         dmpl__ApplicableFor__c,
                                         dmpl__ComponentItemId__c,
                                         dmpl__ComponentItemId__r.dmpl__ItemCode__c,
                                         dmpl__ComponentItemId__r.dmpl__Description__c,
                                         dmpl__ComponentItemId__r.Name,
                                         dmpl__ComponentSKUId__c,
                                         dmpl__ComponentSKUId__r.Name,
                                         dmpl__FeatureId__c,
                                         dmpl__FeatureId__r.Name,
                                         dmpl__FeatureId__r.dmpl__FeatureGroup__c,
                                         dmpl__FeatureId__r.dmpl__MaxComponentCount__c,
                                         dmpl__FeatureId__r.dmpl__MinComponentCount__c,
                                         dmpl__FeatureId__r.dmpl__ShowinCatalog__c,
                                         dmpl__FeatureId__r.dmpl__SortOrder__c,
                                         dmpl__IsBundled__c,
                                         dmpl__IsMandatory__c,
                                         dmpl__IsQuantityEditable__c,
                                         dmpl__IsSelected__c,
                                         dmpl__SKUId__c,
                                         dmpl__MaxQuantity__c,
                                         dmpl__MinQuantity__c,
                                         dmpl__PackageType__c,
                                         dmpl__Quantity__c,
                                         dmpl__SortOrder__c,
                                         dmpl__PartnerAccountId__c,
                                         dmpl__PartnerAccountGroupId__c
                                         From  dmpl__ItemComponent__c Limit 1 ];
        List<Account> acc=[select Id from Account Limit 1];
        dmpl__Branch__c branch=[select Id, Name from dmpl__Branch__c Limit 1];
        PackageComponentLine package1 =new PackageComponentLine(itemCom);
        Packagehelper.getPackageConfiguration(itemCom.dmpl__ItemId__c,itemCom.dmpl__SKUId__c,itemCom.dmpl__PartnerAccountId__c,acc[0].Id,branch.Id);
        System.assertEquals(1, acc.size(), 'account data');
    }
    
    @isTest
    public static void getHealthCheckTemplates1()
    {
        test.startTest();
        List<dmpl__Item__c> order = [SELECT Id , Name,dmpl__ServiceDurationInMinutes__c FROM dmpl__Item__c];       
        HealthCheckController.getHealthCheckTemplates(order[0].Id);
        System.assert(order != null, 'Item data');
        test.stopTest();
    }
    
    @isTest
    public static void VerifyValidations()
    {
        test.startTest();
        List<dmpl__Item__c> order = [SELECT Id , Name,dmpl__ServiceDurationInMinutes__c FROM dmpl__Item__c];       
        ValidationHelper.validatePostiveDecimal('dmpl__ServiceDurationInMinutes__c',order);
        System.assert(order != null, 'Item data');
        test.stopTest();
    }
    
    
    @isTest
    public static void getAllItemWithImages()
    { 
        test.startTest();
        dmpl__Item__c order = [SELECT Id , Name,dmpl__ServiceDurationInMinutes__c FROM dmpl__Item__c limit 1];       
        ItemIamgeController.getAllItemWithImages();
        System.assert(order != null, 'Item data');
        test.stopTest();
    }
    
    @isTest
    public static void getCheckInTemplates()
    { 
        test.startTest();
        dmpl__Item__c order = [SELECT Id , Name,dmpl__ServiceDurationInMinutes__c FROM dmpl__Item__c limit 1];       
        CheckInController.getCheckInTemplates(Order.Id);
        System.assert(order != null, 'Item data');
        test.stopTest();
    }
    
     @isTest
    public static void getCheckInTemplatess()
    { 
        Try{
        test.startTest();
        dmpl__Branch__c order = [SELECT Id , Name FROM dmpl__Branch__c limit 1];       
        CheckInController.getCheckInInspection(Order.Id);
        System.assert(order != null, 'Item data');
        test.stopTest();
        }
        Catch(Exception e)
        {}
    }
   
    @isTest
    public static void getCheckInTemplates1()
    { 
        test.startTest();
        dmpl__Item__c order = [SELECT Id , Name,dmpl__ServiceDurationInMinutes__c FROM dmpl__Item__c limit 1];       
        CheckInController.getCheckInAttachments(Order.Id);
        CheckInController.getCheckInTemplateLineAttachments(Order.Id);
        
        System.assert(order != null, 'Item data');
        test.stopTest();
    }
    
    @isTest
    public static void getFieldsByFieldSetName()
    { 
        try{
            test.startTest();
            dmpl__Item__c order = [SELECT Id , Name,dmpl__ServiceDurationInMinutes__c FROM dmpl__Item__c];       
            MetadataHelper.getFieldsByFieldSetName('dmpl__Item__c','');
            System.assert(order != null, 'Item data');
            test.stopTest();
        }
        catch(Exception e){}
    }
    
    @isTest
    public static void applyProductConfiguration()
    { 
        try{
            test.startTest();
            //dmpl__Item__c order = [SELECT Id , Name,dmpl__ServiceDurationInMinutes__c FROM dmpl__Item__c];
            ConfigAPI_GetProductConfigurator.applyProductConfiguration();
            //System.assert(order != null, 'Item data');
            test.stopTest();
        }
        catch(Exception e){}
    }
    
    @isTest
    public static void getCheckInInspection()
    {
        try{
            test.startTest();
            dmpl__Item__c order = [SELECT Id , Name,dmpl__ServiceDurationInMinutes__c FROM dmpl__Item__c];       
            CheckInController.getCheckInInspection(order.Id);
            
            System.assert(order != null, 'Item data');
            test.stopTest();
        }
        catch(exception e){}
    }
    
    @isTest
    public static void getCheckInAttachments()
    {
        try{
            test.startTest();
            dmpl__Item__c order = [SELECT Id , Name,dmpl__ServiceDurationInMinutes__c FROM dmpl__Item__c];       
            CheckInController.getCheckInAttachments(order.Id);
            
            System.assert(order != null, 'Item data');
            test.stopTest();
        }
        catch(exception e){}
    }
    
    @isTest
    public static void getHealthCheckTemplates()
    {
        try{
            test.startTest();
            dmpl__Item__c order = [SELECT Id , Name,dmpl__ServiceDurationInMinutes__c FROM dmpl__Item__c];       
            HealthCheckController.getHealthCheckTemplates(order.Id);
            
            System.assert(order != null, 'Item data');
            test.stopTest();
        }
        catch(exception e){}
    }
    
    @isTest
    public static void getChecklistLines()
    {
        test.startTest();
        dmpl__Item__c order = [SELECT Id , Name,dmpl__ServiceDurationInMinutes__c FROM dmpl__Item__c limit 1];       
        HealthCheckController.getChecklistLines(order.Id);
        
        System.assert(order != null, 'Item data');
        test.stopTest();
    }
    
    @isTest
    public static void getCheckInTemplateLineAttachments()
    {
        try{
            test.startTest();
            dmpl__Item__c order = [SELECT Id , Name,dmpl__ServiceDurationInMinutes__c FROM dmpl__Item__c];       
            CheckInController.getCheckInTemplateLineAttachments(order.Id);
            
            System.assert(order != null, 'Item data');
            test.stopTest();
        }
        catch(exception e){}
    }
    
    
    @isTest
    public static void Itemcontroller()
    {
        List<dmpl__Item__c> item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        ItemController.getItem(item[0].Id);
        System.assertEquals(1, item.size(), 'item data');
    }
    
    @isTest
    public static void GetProductConfigurator()
    {
        string errorReceived;
        try{             
            ConfigAPI_GetProductConfigurator.getProductConfiguration();
            ConfigAPI_GetProductConfigurator.applyProductConfiguration();
        } catch (Exception ex) {
            errorReceived = ex.getMessage();
        }
        System.assertNotEquals(null, errorReceived);
    }
    
    @isTest
    public static void Itemcontroller1()
    {
        dmpl__Item__c item = [Select Id,Name,dmpl__ItemCode__c From dmpl__Item__c LIMIT 1];
        dmpl__Branch__c order = [SELECT Id , Name FROM dmpl__Branch__c limit 1];
        dmpl__ItemLotType__c itemT = new dmpl__ItemLotType__c(name='demp',
                                           dmpl__ItemId__c = item.id
                                          );  
        ItemController.getItems('s',4,2);
        System.assert(item != null, 'Item data');
        ItemController.getItemLotTypeStock(item.Id,itemT.id,order.id);
    }
    
    @isTest
    public static void UpdateItem()
    {
        dmpl__Item__c item = [Select Id,Name,dmpl__ItemCode__c From dmpl__Item__c LIMIT 1];
        item.dmpl__ItemCode__c = 'DMS';
        
        update item;
        System.assertEquals('DMS', item.dmpl__ItemCode__c, 'Item updated 1 record');
    }
    
    @isTest
    public static void DeleteItem()
    {
        dmpl__Item__c item = [Select Id,Name,dmpl__ItemCode__c From dmpl__Item__c LIMIT 1];
        
        Delete item;
        System.assertEquals('DMPL', item.dmpl__ItemCode__c, 'Item deleted 1 record');
    }
    
    @isTest
    public static void UpdateItemMaintenanceSchedule()
    {
        dmpl__ItemMaintenanceSchedule__c itemMaintenanceSchedule = [Select Id,Name,dmpl__ReminderDaysOffset1__c From dmpl__ItemMaintenanceSchedule__c LIMIT 1];
        itemMaintenanceSchedule.dmpl__ReminderDaysOffset1__c = 49;
        
        update itemMaintenanceSchedule;
        System.assertEquals(49, itemMaintenanceSchedule.dmpl__ReminderDaysOffset1__c, 'Item updated 1 record');
    }
    
    @isTest
    public static void DeleteitemMaintenanceSchedule()
    {
        dmpl__ItemMaintenanceSchedule__c itemMaintenanceSchedule = [Select Id,Name,dmpl__ReminderDaysOffset1__c From dmpl__ItemMaintenanceSchedule__c LIMIT 1];
        
        Delete itemMaintenanceSchedule;
        System.assertEquals(10, itemMaintenanceSchedule.dmpl__ReminderDaysOffset1__c, 'Item deleted 1 record');
    }
    @isTest
    public static void Verifycancel()
    {
        test.startTest();
        List<dmpl__Item__c> line2 = [SELECT Id, Name FROM dmpl__Item__c];
        ItemHelper.queryItems('Part',1,2);    
        System.assertEquals(2, line2.size(), 'fulfillment is verified');
        test.stopTest();
    }
    
    @isTest
    public static void VerifySessioncache()
    {
        test.startTest();
        List<dmpl__Item__c> items = [SELECT Id, Name FROM dmpl__Item__c];
        SessioncacheHelper.setSObjects(items);  
        SessioncacheHelper.removeSObjects(items);
        System.assertEquals(2, items.size(), 'fulfillment is verified');
        test.stopTest();
    }
    
    @isTest
    public static void VerifySessioncacheNew()
    {
        test.startTest();
        List<Id> ids= new List<Id>();
        dmpl__Item__c items = [SELECT Id, Name FROM dmpl__Item__c limit 1];
        ids.add(items.Id);
        SessioncacheHelper.removeSObjects('dmpl__Item__c',ids);
        SessioncacheHelper.isPlatformCacheEnabled('dmpl__Item__c');
        SessioncacheHelper.removeSObject(items);
        SessioncacheHelper.setSObject(items);
        SessioncacheHelper.getSObject('dmpl__Item__c',items.Id);
        System.assert(items != null, 'Item data');
        test.stopTest();
    }
    
    @isTest
    public static void UpdateitemFeature()
    {
        dmpl__ItemFeature__c itemFeature = [Select Id,Name,dmpl__ShowinCatalog__c From dmpl__ItemFeature__c LIMIT 1];
        itemFeature.dmpl__ShowinCatalog__c = True;
        
        update itemFeature;
        System.assertEquals(true, itemFeature.dmpl__ShowinCatalog__c, 'Item updated 1 record');
    }
    
    @isTest
    public static void DeleteitemFeature()
    {
        dmpl__ItemFeature__c itemFeature = [Select Id,Name,dmpl__ShowinCatalog__c From dmpl__ItemFeature__c LIMIT 1];
        
        Delete itemFeature;
        System.assertEquals(false, itemFeature.dmpl__ShowinCatalog__c, 'Item deleted 1 record');
    }
    
    @isTest
    public static void UpdateitemComponent()
    {
        dmpl__ItemComponent__c itemComponent = [Select Id,Name,dmpl__SortOrder__c From dmpl__ItemComponent__c LIMIT 1];
        itemComponent.dmpl__SortOrder__c = 200;
        
        update itemComponent;
        System.assertEquals(200, itemComponent.dmpl__SortOrder__c, 'Item updated 1 record');
    }
    
    @isTest
    public static void DeleteitemComponent()
    {
        dmpl__ItemComponent__c itemComponent = [Select Id,Name,dmpl__SortOrder__c From dmpl__ItemComponent__c LIMIT 1];
        
        Delete itemComponent;
        System.assertEquals(100, itemComponent.dmpl__SortOrder__c, 'Item deleted 1 record');
    }
    
    @isTest
    public static void UpdateitemInventoryAttribute()
    {
        dmpl__itemInventoryAttribute__c itemInventoryAttribute = [Select Id,Name,dmpl__ReorderQuantity__c From dmpl__itemInventoryAttribute__c LIMIT 1];
        itemInventoryAttribute.dmpl__ReorderQuantity__c = 200;
        
        update itemInventoryAttribute;
        System.assertEquals(200, itemInventoryAttribute.dmpl__ReorderQuantity__c, 'Item updated 1 record');
    }
    
    @isTest
    public static void DeleteitemInventoryAttribute()
    {
        dmpl__itemInventoryAttribute__c itemInventoryAttribute = [Select Id,Name,dmpl__ReorderQuantity__c From dmpl__itemInventoryAttribute__c LIMIT 1];
        
        Delete itemInventoryAttribute;
        System.assertEquals(50, itemInventoryAttribute.dmpl__ReorderQuantity__c, 'Item deleted 1 record');
    }
    
    // @isTest
    // public static void createQuoteLine()
    // {
    //     test.startTest();
    //     CreateServiceEstimate();
    //     dmpl__Quote__c serviceEstimate = [SELECT Id, Name FROM dmpl__Quote__c LIMIT 1];
    //     dmpl__ItemComponent__c comp = [Select Id,Name,dmpl__ComponentItemId__c,dmpl__ComponentSKUId__c,
    //                                    dmpl__Quantity__c,dmpl__IsBundled__c From dmpl__ItemComponent__c LIMIT 1];
    //        ServiceEstimateLineHelper.createQuoteLine(serviceEstimate,comp);
    //     test.stopTest();
    //     System.assert(serviceEstimate != null, 'Quote Data');
    // }
    
    private static void CreateAccountGroup()
    {
        dmpl__AccountGroup__c accountGroup= new dmpl__AccountGroup__c (Name= 'Test-AccountGroup', 
                                                                       dmpl__AccountGroupType__c='Scheme');
        insert accountGroup;
        
    }
    
    private static void CreateAccount()
    {
        List<Account> account = new List<Account>();
        dmpl__AccountGroup__c accountGroup = [Select Id,Name From dmpl__AccountGroup__c LIMIT 1];
        account.add(new Account(Name = 'Test - Account', 
                                dmpl__LastName__c = 'Sale Order',
                                Fax = '09876',
                                Phone = '1234567891',
                                Website = 'www.Dealermatix.com',
                                Type = 'Prospect',
                                NumberOfEmployees = 2,
                                Industry = 'Education',
                                AnnualRevenue = 1000,
                                Description = 'Accounts added',
                                dmpl__IsPartnerAccount__c = false,
                                dmpl__IsActive__c = True,
                                dmpl__IsTaxExempted__c = True,
                                dmpl__IsSupplierAccount__c = false,
                                dmpl__IsCustomerAccount__c = False,
                                dmpl__PartnerTaxAccountGroupId__c = accountGroup.Id,
                                dmpl__CustomerPriceAccountGroupId__c = accountGroup.Id,
                                dmpl__CustomerDiscountAccountGroupId__c = accountGroup.Id,
                                dmpl__PartnerSchemeAccountGroupId__c = accountGroup.Id,                                
                                dmpl__PartnerPriceAccountGroupId__c = accountGroup.Id,
                                dmpl__PartnerDiscountAccountGroupId__c = accountGroup.Id,
                                dmpl__CustomerSchemeAccountGroupId__c = accountGroup.Id
                               ));
        insert account;
        
        
        Account partneraccount = new Account(Name = 'Partner-Test-Account',
                                             dmpl__LastName__c = 'Sale Order',
                                             dmpl__IsPartnerAccount__c = True, 
                                             dmpl__IsActive__c = true);
        insert partneraccount;
        
        
        Account customerAccount = new Account(Name = 'Customer-Test-Account',
                                              dmpl__LastName__c = 'Sale Order',
                                              dmpl__IsCustomerAccount__c = True,
                                              dmpl__IsActive__c = true);
        insert customerAccount;
        
        
        Account supplierAccount = new Account(Name = 'Supplier-Test-Account',
                                              dmpl__LastName__c = 'Sale Order',
                                              dmpl__IsSupplierAccount__c = True,
                                              dmpl__IsActive__c = true);
        insert supplierAccount;
        
    }
    
    private static void CreateBranch()
    {
        List<dmpl__Branch__c> branch = new List<dmpl__Branch__c>();
        Account partnerAccount = [Select Id,Name From Account WHERE Name = 'Partner-Test-Account' LIMIT 1];
        branch.Add(new dmpl__Branch__c(dmpl__PartnerAccountId__c =partnerAccount.Id,
                                       Name = 'Test-Branch',
                                       dmpl__IsActive__c = true,
                                       dmpl__MarketingName__c = 'Hero Electric',
                                       dmpl__Website__c = 'www.dealermatix.com',
                                       dmpl__Email__c = 'Dealer@Outlook.com',
                                       dmpl__MobileNumber__c = 99,
                                       dmpl__Phone__c = '8888888888',
                                       dmpl__AllowSales__c = true,
                                       dmpl__AllowService__c = true,
                                       dmpl__AllowPurchase__c = true,
                                       dmpl__AllowInventory__c = true,
                                       dmpl__IsHomeDeliveryAvailable__c = true,
                                       dmpl__IsPickupDropAvailable__c = true,
                                       dmpl__SalesPhone__c = '7777777777',
                                       dmpl__ServiceEmail__c = 'Customer@Outlook.com'));
        insert branch;
        
    }
    
    private static void CreateItems()
    {
        List<dmpl__Item__c> item = new List<dmpl__Item__c>();
        item.Add(new dmpl__Item__c(Name = 'Test-Item',
                                   dmpl__ItemCode__c = 'DMPL',
                                   dmpl__ItemType__c = 'Service Contract',
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
                                   dmpl__ServiceDurationInMinutes__c=-3,
                                   dmpl__RFID__c = 'O1234fgh'
                                  ));
        insert item;
        
        dmpl__Item__c workItem = new dmpl__Item__c(
            Name = 'Washing', 
            dmpl__ItemCode__c = 'Washing', 
            dmpl__ItemType__c = 'Work Item',
            dmpl__IsActive__c = true);
        
        insert workItem;
    }
    
    private static void CreateSKu()
    {
        List<dmpl__SKU__c> sku = new List<dmpl__SKU__c>();
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        sku.add(new dmpl__SKU__c(Name = 'Test - SKU',
                                 dmpl__SKUCode__c = 'Test - SKU - Code',
                                 dmpl__UnitOfMeasureOfConversion__c = 10,
                                 dmpl__ProductColor__c = 'Sample',
                                 dmpl__IsDefault__c = false,
                                 dmpl__QuantityUnitOfMeasure__c ='Sample',
                                 dmpl__ItemId__c = item.Id));
        insert sku; 
    }
    
    private static void CreateItemMaintenanceSchedule()
    {
        List<dmpl__ItemMaintenanceSchedule__c> itemMaintenanceSchedule = new List<dmpl__ItemMaintenanceSchedule__c>();
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id,Name From dmpl__SKU__c LIMIT 1];
        itemMaintenanceSchedule.add(new dmpl__ItemMaintenanceSchedule__c(dmpl__ItemId__c = item.Id,
                                                                         dmpl__SKUId__c = sku.Id,
                                                                         dmpl__ReminderDaysOffset1__c = 10,
                                                                         dmpl__ReminderDaysOffset2__c = 15,
                                                                         dmpl__ReminderDaysOffset3__c = 20,
                                                                         dmpl__ReminderDaysOffset4__c = 25,
                                                                         dmpl__ReminderDaysOffset5__c = 30,
                                                                         dmpl__DueInDays__c = 35,
                                                                         dmpl__DueinUsageHours__c = 40,
                                                                         dmpl__DueOnUsage__c = 45,
                                                                         dmpl__FromDurationDays__c = 50,
                                                                         dmpl__ToDurationDays__c = 60,                                                                         
                                                                         dmpl__FromUsageHours__c = 65,
                                                                         dmpl__ToUsageHours__c = 70,
                                                                         dmpl__FromUsageReading__c = 75,
                                                                         dmpl__ToUsageReading__c = 80
                                                                        ));
        insert itemMaintenanceSchedule;
    }
    
    private static void CreateItemFeatures()
    {
        List<dmpl__ItemFeature__c> itemFeature = new List<dmpl__ItemFeature__c>();
        Account partnerAccount = [Select Id,Name From Account WHERE Name = 'Partner-Test-Account' LIMIT 1];
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        itemFeature.add(new dmpl__ItemFeature__c(Name = 'Item-Feature',
                                                 dmpl__ItemId__c = item.Id,
                                                 dmpl__PartnerAccountId__c = partnerAccount.Id,
                                                 dmpl__ShowinCatalog__c = false                                                 
                                                ));
        insert itemFeature;
    }
    
    private static void CreateItemComponent()
    {
        List<dmpl__ItemComponent__c> itemComponent = new List<dmpl__ItemComponent__c>();
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        dmpl__Item__c workItem=[Select Id, Name From dmpl__Item__c where dmpl__ItemType__c='Work Item' Limit 1];
        dmpl__SKU__c sku = [Select Id,Name From dmpl__SKU__c LIMIT 1];
        dmpl__ItemFeature__c itemFeature = [Select Id,Name From dmpl__ItemFeature__c LIMIT 1];
        itemComponent.add(new dmpl__ItemComponent__c(dmpl__ComponentItemId__c = workItem.Id,
                                                     dmpl__SKUId__c = sku.Id,
                                                     dmpl__Quantity__c=2,
                                                     dmpl__ItemId__c=item.Id,
                                                     dmpl__PackageType__c='Independent Of Package',
                                                     dmpl__FeatureId__c = itemFeature.Id,
                                                     dmpl__SortOrder__c = 100));
        insert itemComponent;
    }
    
    private static void CreateItemInventoryAttribute()
    {
        List<dmpl__ItemInventoryAttribute__c> ItemInventoryAttribute = new List<dmpl__ItemInventoryAttribute__c>();
        dmpl__Branch__c branch = [Select Id,Name From dmpl__Branch__c LIMIT 1];
        Account partnerAccount = [Select Id,Name From Account WHERE Name = 'Partner-Test-Account' LIMIT 1];
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id,Name From dmpl__SKU__c LIMIT 1];
        ItemInventoryAttribute.add(new dmpl__ItemInventoryAttribute__c(dmpl__ItemId__c = item.Id,
                                                                       dmpl__SKUId__c = sku.Id,
                                                                       dmpl__BranchId__c = branch.Id,
                                                                       dmpl__PartnerAccountId__c = partnerAccount.Id,
                                                                       dmpl__FSNCategory__c = 'Fast Moving',
                                                                       dmpl__ReorderQuantity__c = 50,
                                                                       dmpl__MinimumOrderQuantity__c = 10,
                                                                       dmpl__MaximumOrderQuantity__c = 100));
        insert ItemInventoryAttribute;
    }
    
    private static void CreateServiceEstimate()
    { 
        List<dmpl__Quote__c> ServiceEstimate = new List<dmpl__Quote__c>();
        Account account = [Select Id,Name From Account Where Name = 'Customer-Test-Account' LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c LIMIT 1];
        dmpl__Item__c item = [Select Id,Name,dmpl__ItemType__c From dmpl__Item__c LIMIT 1];
        //dmpl__PriceList__c priceList=[Select Id, Name from dmpl__PriceList__c Limit 1];
        //Asset asset = [Select Id,Name From Asset LIMIT 1];
        //dmpl__ServiceRequest__c serviceRequest = [Select Id,Name From dmpl__ServiceRequest__c LIMIT 1];
        ServiceEstimate.Add(new dmpl__Quote__c(dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                                     dmpl__BranchId__c = branch.Id,
                                                     dmpl__AccountId__c = account.Id,
                                                     //dmpl__AssetId__c = asset.Id,
                                                     //dmpl__PriceListId__c=priceList.Id,
                                                     dmpl__PerformEstimateLinesGeneration__c = false,
                                                     //dmpl__ServiceRequestId__c = serviceRequest.Id,
                                                     dmpl__ServiceContractItemId__c = item.Id,
                                                     dmpl__PerformApproval__c = false,
                                                     dmpl__PerformDecline__c = false,
                                                     dmpl__PerformRepairOrderGeneration__c = false,
                                                     dmpl__IsRepairOrderGenerated__c = false));
        insert ServiceEstimate;       
    }
}