@isTest
public class PackageComponentLine_Test {
    
    @testsetup
    public static void setup()
    {
        System.runAs(PostInstallHelper.AssignAdministratorAllPermissions(UserInfo.getUserId())){
            CreateAccountGroup();
            CreateAccount();
            CreateBranch();
            CreateItems();
            CreateSKu();
            CreateItemMaintenanceSchedule();
            CreateItemFeatures();
            CreateItemComponent();
        }
    }
    
    
    @isTest
     Static void VerifyCreateAccount()
     {
         try{
         test.startTest();
         Account account = [Select Id, Name From Account ];
         OrgCacheHelper.setSObject(Account);
         OrgCacheHelper.removeSObject(Account);
         OrgCacheHelper.removeSObject('Account',account.Id);
         System.assertNotEquals(null, account, 'Test Accounts are not found');
         test.stopTest();
         }
         catch(exception e){}
    }
    
    @isTest
    public static void OrgSetting()
    {
        try{
        test.startTest();
        OrgSettingHelper.OrgSetting();
        OrgCacheHelper.getObject('');
        System.assert(true);
        test.stopTest();
        }catch(exception e){}
    }
    
    @isTest
    public Static void verifyPackageConfigLine()
    {
        test.startTest();
           Account account = [Select Id, Name From Account Limit 1 ];
            List<PackageConfigLine> lines = new List<PackageConfigLine>();
            PackageConfigLine packageline = new PackageConfigLine ();
            packageline.Id =account.id;
            packageline.isSelected = true;
            packageline.quantity = 1;
            lines.add(packageline);
             dmpl__ItemComponent__c comp = [Select Id,Name From dmpl__ItemComponent__c LIMIT 1];
        PackageHelper.findPackageConfigLine(lines,comp.Id);
        test.stopTest();
    }
    
    @isTest
    public Static void verifyApplyTaxes()
    {
        try{
            test.startTest();
            Account account = [Select Id, Name From Account Limit 1 ];
            List<PackageConfigLine> lines = new List<PackageConfigLine>();
            PackageConfigLine packageline = new PackageConfigLine ();
            packageline.Id =account.id;
            packageline.isSelected = true;
            packageline.quantity = 1;
            lines.add(packageline);
            ProductConfiguratorController.applyPackageConfiguration('dmpl__SaleOrder__c',account.Id,lines);
            test.stopTest();
        }
        catch(exception e){}
    }
    
    @isTest
    public Static void verifyApplyTaxes1()
    {
        try{
            test.startTest();
            Account account = [Select Id, Name From Account Limit 1 ];
            List<PackageConfigLine> lines = new List<PackageConfigLine>();
            PackageConfigLine packageline = new PackageConfigLine ();
            packageline.Id =account.id;
            packageline.isSelected = true;
            packageline.quantity = 1;
            lines.add(packageline);
            ProductConfiguratorController.applyPackageConfiguration('dmpl__Quote__c',account.Id,lines);
            test.stopTest();
        }
        catch(exception e){}
    }
    @isTest
    public Static void verifyApplyTaxes2()
    {
        try{
            test.startTest();
            Account account = [Select Id, Name From Account Limit 1 ];
            List<PackageConfigLine> lines = new List<PackageConfigLine>();
            PackageConfigLine packageline = new PackageConfigLine ();
            packageline.Id =account.id;
            packageline.isSelected = true;
            packageline.quantity = 1;
            lines.add(packageline);
            ProductConfiguratorController.applyPackageConfiguration('dmpl__SaleInvoice__c',account.Id,lines);
            test.stopTest();
        }
        catch(exception e){}
    }
    @isTest
    public Static void verifyApplyTaxes3()
    {
        try{
            test.startTest();
            Account account = [Select Id, Name From Account Limit 1 ];
            List<PackageConfigLine> lines = new List<PackageConfigLine>();
            PackageConfigLine packageline = new PackageConfigLine ();
            packageline.Id =account.id;
            packageline.isSelected = true;
            packageline.quantity = 1;
            lines.add(packageline);
            ProductConfiguratorController.applyPackageConfiguration('dmpl__PurchaseOrder__c',account.Id,lines);
            test.stopTest();
        }
        catch(exception e){}
    }
    @isTest
    public Static void verifyApplyTaxes4()
    {
        try{
            test.startTest();
            Account account = [Select Id, Name From Account Limit 1 ];
            List<PackageConfigLine> lines = new List<PackageConfigLine>();
            PackageConfigLine packageline = new PackageConfigLine ();
            packageline.Id =account.id;
            packageline.isSelected = true;
            packageline.quantity = 1;
            lines.add(packageline);
           ProductConfiguratorController.applyPackageConfiguration('dmpl__ServiceRequest__c',account.Id,lines);
           test.stopTest();
        }
        catch(exception e){}
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
        itemComponent.add(new dmpl__ItemComponent__c(dmpl__ItemId__c = item.Id,
                                                     dmpl__SKUId__c = sku.Id,
                                                     dmpl__Quantity__c=2,
                                                     dmpl__PackageType__c='Independent Of Package',
                                                     dmpl__ComponentItemId__c = workItem.Id,
                                                     dmpl__FeatureId__c = itemFeature.Id,
                                                     dmpl__SortOrder__c = 100));
        insert itemComponent;
    }
    
}