@isTest
public class ItemGroupHelper_Test {

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
            CreateItemLotType();
            CreateInterfaceQueue(); 
            CreateItemGroup(); 
            CreateItemGroupMember();
        //}
    }
    
     @isTest
    static void verifyBatchApex() {
        try{ 
             CreateItemGroupMember();
        }
        catch(Exception ex){}
       }
    
    @isTest
    static void testCallHeadlessAction() {
        try{ 
            ItemGroupController itemCont = new ItemGroupController();
            Map<String, Object> mapObject = new Map<String, Object>();
         itemCont.call('headlessAction',mapObject);
            //ItemGroupController.call(null);

        }
        catch(Exception ex){}
      // ItemGroupController result = new ItemGroupController();
        
    }
    
    @isTest
    static void testCallHeadlessActio2() {
        try{ 
            List<dmpl__Item__c> items =[Select Id, Name from dmpl__Item__c ];
            List<Id> itemIds= new List<Id>();
            itemIds.add(items[0].Id);
            ItemGroupController itemCont = new ItemGroupController();
            //Map<String, Object> mapObject = new Map<String, Object>();
            ItemGroupHelper.getCachedItemGroupIds('Discount',items[0].Id);
            ItemGroupHelper.getCachedItemGroupIds('Discount',items[0].Id);
            //ItemGroupController.call(null);

        }
        catch(Exception ex){}
      // ItemGroupController result = new ItemGroupController();
        
    }
    
     @isTest
    static void testCallHeadlessActio1() {
        try{ 
            List<dmpl__Item__c> items =[Select Id, Name from dmpl__Item__c ];
            List<Id> itemIds= new List<Id>();
            itemIds.add(items[0].Id);
            ItemGroupController itemCont = new ItemGroupController();
            //Map<String, Object> mapObject = new Map<String, Object>();
            ItemGroupHelper.getCachedItemGroupIds('Discount',itemIds);
            //ItemGroupController.call(null);

        }
        catch(Exception ex){}
      // ItemGroupController result = new ItemGroupController();
        
    }
    
    
    
    @isTest
    Static void VerifyCreateAccount()
    {
        List<Account>  account = [Select Id, Name From Account];
        update account;
        System.assertNotEquals(null, account, 'Test Accounts are not found');
        System.assertEquals(4, account.size(), 'Test Accounts have more than 1 record');
    }
    
    @isTest
    private static void unDoInwardLedger()
    {
        try{
        Test.startTest();
        dmpl__ItemGroup__c itemGrp = [Select Id,Name,dmpl__ReportId__c FROM dmpl__ItemGroup__c LIMIT 1];
        dmpl__ItemGroupMember__c inventoryLedger = [Select Id,Name,dmpl__ItemId__c,dmpl__SKUId__c,dmpl__LotTypeId__c,dmpl__ItemGroupId__c From dmpl__ItemGroupMember__c LIMIT 1];
        ItemGroupHelper.getCachedItemGroupIds('Discount',inventoryLedger.dmpl__ItemGroupId__c);
        System.assert(itemGrp==null,'Not Null');
        Test.stopTest();
        }catch(exception e){}
    }
    
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
    
    private static void CreateItemLotType()
    {
        List<dmpl__ItemLotType__c> itemLotType = new List<dmpl__ItemLotType__c>();
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        itemLotType.add(new dmpl__ItemLotType__c(Name = 'Test-ItemLotType',
                                                 dmpl__ItemId__c = item.Id));
        insert itemLotType; 
    }
    
    private static void CreateInterfaceQueue()
    {
        List<dmpl__InterfaceQueue__c> interfaceQueue = new List<dmpl__InterfaceQueue__c>();
        interfaceQueue.add(new dmpl__InterfaceQueue__c(dmpl__JobType__c = 'Item Group Member Processor',
                                                       dmpl__QueueType__c = 'Queueable',
                                                       dmpl__InterfaceRecordId__c = 'Interface Record Id'
                                                      ));
        insert interfaceQueue;
    }
    
    private static void CreateItemGroup()
    {
        List<dmpl__ItemGroup__c> itemGroup = new List<dmpl__ItemGroup__c>();
        itemGroup.add(new dmpl__ItemGroup__c(Name = 'Test-ItemLotType',
                                             dmpl__ReportId__c = 'Report 1'));
        insert itemGroup; 
    }
    
    private static void CreateItemGroupMember()
    {
        List<dmpl__ItemGroupMember__c> itemGroupMember = new List<dmpl__ItemGroupMember__c>();
        dmpl__Item__c item = [Select Id, Name From dmpl__Item__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id, Name From dmpl__SKU__c LIMIT 1];
        dmpl__ItemLotType__c lotType = [Select Id, Name From dmpl__ItemLotType__c LIMIT 1];
        dmpl__ItemGroup__c itemGroup = [Select Id, Name From dmpl__ItemGroup__c LIMIT 1];
        itemGroupMember.add(new dmpl__ItemGroupMember__c(
                                                         dmpl__ItemId__c = item.Id,
                                                         dmpl__SKUId__c = sku.Id,
                                                         dmpl__BatchInstanceId__c = 'TestBatchId123',
                                                         dmpl__LotTypeId__c = lotType.Id,
                                                         dmpl__ItemGroupId__c = itemGroup.Id
        												));
    }
}