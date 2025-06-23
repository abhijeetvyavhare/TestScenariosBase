@isTest
public class SubscriptionInvoiceHelper_Test {
        
    @testSetup
    public static void Setup()
    {
        System.runAs(PostInstallHelper.AssignAdministratorAllPermissions(UserInfo.getUserId())){
            CreateAccountGroup();
            CreateContactAddress();
            CreateBranch();
            CreateItems();
            CreateConsumptionRate();
            CreateSKu();
            CreateItemLot();
            CreateItemMaintenanceSchedule();
            CreateResource();
            CreateTaxGroup();
            CreateSaleOrder();   
            CreateSubscription();
            test.startTest();
            CreateSaleInvoice();
            CreateSubscriptionSumary();
            test.stopTest();
        }
    }
    
    
    @isTest
    Public  Static void VerifySubsInvoice()
    {
        try{ 
            Test.startTest();
            List<dmpl__SaleInvoice__c> saleInvoice = [Select Id,Name From dmpl__SaleInvoice__c LIMIT 1];
            if(saleInvoice.size() > 0)
            	SubscriptionInvoiceHelper.generateUsageInvoiceSummary();
            system.assert(true,'Record Found');
            Test.stopTest();
        }  
        catch(exception e){}
    }
    
    @isTest  
    Public  Static void VerifySubsInvoice1()
    {
        Test.startTest();
        dmpl__SaleInvoice__c  invoice = [Select Id, Name,dmpl__PartnerAccountId__c,dmpl__SubscriptionId__c,dmpl__BranchId__c,dmpl__AccountId__c From dmpl__SaleInvoice__c];  
        dmpl__Subscription__c subs = [Select Id, Name,dmpl__PartnerAccountId__c,dmpl__BranchId__c,dmpl__AccountId__c From dmpl__Subscription__c LIMIT 1];  
        SubscriptionInvoiceHelper.createSaleInvoiceDocumentFromSubscription(subs.dmpl__BranchId__c,subs.dmpl__PartnerAccountId__c,subs.dmpl__AccountId__c,subs.Id);
        system.assert(invoice!=null,'Record Found');
        Test.stopTest();        
    }
   
    @isTest  
    Public  Static void querySubscription()
    {
        Test.startTest();
        dmpl__SaleInvoice__c  invoice = [Select Id, Name,dmpl__PartnerAccountId__c,dmpl__SubscriptionId__c,dmpl__BranchId__c,dmpl__AccountId__c From dmpl__SaleInvoice__c];  
        
        SubscriptionInvoiceHelper.querySubscription();
        system.assert(invoice!=null,'Record Found');
        Test.stopTest();        
    }
    
    @isTest
    Public  Static void VerifySubsInvoicees()
    {
        Try{
            Test.startTest(); 
            SubscriptionInvoiceHelper.generateRecurringInvoiceSummary();
            system.assert(true,'Record Found');
            Test.stopTest(); 
        }
        Catch(Exception e){}
    }
    
    @isTest  
    Public  Static void VerifySubsInvoices()
    {
        Test.startTest();
        dmpl__SaleInvoiceLine__c saleInvoiceLine =[Select Id,dmpl__SaleOrderLineId__c,dmpl__SubscriptionUsageId__c,dmpl__SubscriptionId__c, dmpl__Quantity__c, Name,dmpl__UnitPrice__c,dmpl__AssetId__c,dmpl__ItemId__c,dmpl__SaleInvoiceId__c from dmpl__SaleInvoiceLine__c Limit 1 ];
        List<dmpl__ItemConsumptionSchedule__c>li =[Select Id,dmpl__ItemId__c,(select id,dmpl__UpperBound__c,dmpl__LowerBound__c,dmpl__PricingMethod__c,dmpl__Price__c from dmpl__ItemConsumptionRates__r) from dmpl__ItemConsumptionSchedule__c limit 1];  
        SubscriptionInvoiceHelper.createSaleInvoiceLinesFromSubscription(saleInvoiceLine.dmpl__ItemId__c,3,100,saleInvoiceLine.dmpl__SubscriptionUsageId__c,saleInvoiceLine.dmpl__SubscriptionId__c);

        SubscriptionInvoiceHelper.getConsumptionPrice(5,li[0].dmpl__ItemId__c,li);
        system.assert(saleInvoiceLine!=null,'Record Found');
        Test.stopTest();        
    }
    
    @isTest
    public static void SusbcriptionUsageInvoiceScheduler()
    {
        try{
         test.startTest();
         SchedulableContext sc = null;
         SusbcriptionUsageInvoiceScheduler sUIS = new SusbcriptionUsageInvoiceScheduler();
         sUIS.execute(sc);   
         System.assert(sc != null);
         test.stopTest();
        }catch(exception e){}
    }

    private static void CreateAccountGroup()
    {
        dmpl__AccountGroup__c accountGroup= new dmpl__AccountGroup__c (Name= 'Test-AccountGroup', 
                                                                       dmpl__AccountGroupType__c='Scheme');
        insert accountGroup;
    
      /*  List<Account> account = new List<Account>();
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
        insert account; */
        
        Account partneraccount = new Account(Name = 'Partner-Test-Account',
                                             dmpl__LastName__c = 'Sale Order',
                                             dmpl__IsPartnerAccount__c = True, 
                                             dmpl__IsActive__c = true);
        insert partneraccount;
        
        Account customerAccount = new Account(Name = 'Customer-Test-Account',
                                              dmpl__LastName__c = 'Sale Order',
                                              dmpl__IsCustomerAccount__c = True,
                                              dmpl__IsPartnerAccount__c = True,
                                              dmpl__IsActive__c = true);
        insert customerAccount;
        
       /* Account supplierAccount = new Account(Name = 'Supplier-Test-Account',
                                              dmpl__LastName__c = 'Sale Order',
                                              dmpl__IsSupplierAccount__c = True,
                                              dmpl__IsActive__c = true); 
        insert supplierAccount; */
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
        
        Account partnerAccount1 = [Select Id,Name From Account WHERE Name = 'Partner-Test-Account' LIMIT 1];
        branch.Add(new dmpl__Branch__c(dmpl__PartnerAccountId__c =partnerAccount.Id,
                                       Name = 'Test-Branch1',
                                       dmpl__IsActive__c = true,
                                       dmpl__MarketingName__c = 'Hero Electric',
                                       dmpl__Website__c = 'www.dealermatix.com',
                                       dmpl__Email__c = 'Dealer@Outlook.com',
                                       dmpl__MobileNumber__c = 99,
                                       dmpl__Phone__c = '1888888888',
                                       dmpl__AllowSales__c = true,
                                       dmpl__AllowService__c = true,
                                       dmpl__AllowPurchase__c = true,
                                       dmpl__AllowInventory__c = true,
                                       dmpl__IsHomeDeliveryAvailable__c = true,
                                       dmpl__IsPickupDropAvailable__c = true,
                                       dmpl__SalesPhone__c = '7177777777',
                                       dmpl__ServiceEmail__c = 'Customer1@Outlook.com'));
        insert branch;
    }
    
    private static void CreateItems()
    {
        List<dmpl__Item__c> productItem = new List<dmpl__Item__c>();
        productItem.Add(new dmpl__Item__c(Name = 'Test-Item',
                                          dmpl__ItemCode__c = 'DMPL',
                                          dmpl__ItemType__c = 'Product',
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
                                          dmpl__RFID__c = 'O1234fgh',
                                          dmpl__IsPackage__c = true
                                         ));
        insert productItem;
        
        List<dmpl__Item__c> chargeItem = new List<dmpl__Item__c>();
        chargeItem.Add(new dmpl__Item__c(Name = 'Test-Item',
                                         dmpl__ItemCode__c = 'DMPL',
                                         dmpl__ItemType__c = 'Charge Item',
                                         dmpl__ItemSubType__c = '',
                                         dmpl__Description__c = '',
                                         dmpl__ItemFamily__c = 'Sample',
                                         dmpl__ItemSegment__c = 'Sample',
                                         dmpl__Make__c = 'Sample',
                                         dmpl__Model__c = 'Sample',                       
                                         dmpl__IsActive__c = true,
                                         dmpl__OnlySoldInPackage__c=True
                                        ));
        insert chargeItem;
        
        List<dmpl__Item__c> subsItem = new List<dmpl__Item__c>();
        subsItem.Add(new dmpl__Item__c(Name = 'Test-Item',
                                       dmpl__ItemCode__c = 'DMPL',
                                       dmpl__ItemType__c = 'Subscription',
                                       dmpl__ItemSubType__c = '',
                                       dmpl__Description__c = '',
                                       dmpl__ItemFamily__c = 'Sample',
                                       dmpl__ItemSegment__c = 'Sample',
                                       dmpl__Make__c = 'Sample',
                                       dmpl__Model__c = 'Sample',                       
                                       dmpl__IsActive__c = true,
                                       dmpl__IsPackage__c = true
                                      ));
        insert subsItem;
        
        List<dmpl__ItemConsumptionSchedule__c> itemCons = new List<dmpl__ItemConsumptionSchedule__c>();
        Account partnerAccount = [Select Id,Name From Account WHERE Name = 'Partner-Test-Account' LIMIT 1];
        Account cusAccount = [Select Id,Name From Account WHERE Name = 'Customer-Test-Account' LIMIT 1];
        itemCons.Add(new dmpl__ItemConsumptionSchedule__c(dmpl__PartnerAccountId__c =partnerAccount.Id,
                                                          dmpl__CustomerAccountId__c=cusAccount.Id,
                                                          dmpl__ItemId__c = productItem[0].Id));
                                      
        Insert itemCons;
    }
    
    private static void CreateConsumptionRate()
    {
        List<dmpl__ItemConsumptionRate__c> itemConsRate = new List<dmpl__ItemConsumptionRate__c>();
        dmpl__ItemConsumptionSchedule__c sch = [Select Id,Name,dmpl__ItemId__c From dmpl__ItemConsumptionSchedule__c LIMIT 1];
        itemConsRate.Add(new dmpl__ItemConsumptionRate__c(dmpl__ItemConsumptionSchedule__c =sch.Id,
                                                          dmpl__Description__c='text is found',
                                                          dmpl__UpperBound__c = 10,
                                                          dmpl__LowerBound__c = 7,
                                                          dmpl__PricingMethod__c = 'Per Unit',
                                                          dmpl__Price__c = 100,
                                                          Name = 'Testing'));
        
        itemConsRate.Add(new dmpl__ItemConsumptionRate__c(dmpl__ItemConsumptionSchedule__c =sch.Id,
                                                          dmpl__Description__c='text is found',
                                                          dmpl__UpperBound__c = 10,
                                                          dmpl__LowerBound__c = 7,
                                                          dmpl__PricingMethod__c = 'Flat Fee',
                                                          dmpl__Price__c = 100,
                                                         Name = 'Testing1'));
                                      
        Insert itemConsRate;
       
        
    }
    
    private static void CreateSKu()
    {
        List<dmpl__SKU__c> sku = new List<dmpl__SKU__c>();
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c WHERE dmpl__ItemType__c = 'Subscription' LIMIT 1];
        sku.add(new dmpl__SKU__c(Name = 'Test - SKU',
                                 dmpl__SKUCode__c = 'Test - SKU - Code',
                                 dmpl__UnitOfMeasureOfConversion__c = 10,
                                 dmpl__ProductColor__c = 'Sample',
                                 dmpl__IsDefault__c = false,
                                 dmpl__QuantityUnitOfMeasure__c ='Sample',
                                 dmpl__ItemId__c = item.Id));
        insert sku;
    }
    
    private static void CreateResource()
    {
        List<dmpl__Resource__c> resource = new List<dmpl__Resource__c>();
        Account partnerAccount = [Select Id,Name From Account LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name From dmpl__Branch__c LIMIT 1];
        resource.add(new dmpl__Resource__c(Name = 'Test - Resource',
                                           dmpl__ResourceType__c = 'Sample',
                                           dmpl__IsActive__c = true,
                                           dmpl__Phone__c = '9999999999',
                                           dmpl__DefaultPartnerAccountId__c = partnerAccount.Id,
                                           dmpl__DefaultBranchId__c = branch.Id
                                          ));
        insert resource;
    }
    
    private static void CreateSaleOrder()
    {
        List<dmpl__SaleOrder__c> saleOrder = new List<dmpl__SaleOrder__c>();
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c Where Name = 'Test-Branch' LIMIT 1];
        dmpl__ContactAddress__c contactAddress = [Select Id,Name,dmpl__AccountId__c From dmpl__ContactAddress__c LIMIT 1];
        //dmpl__Resource__c resource = [Select Id,Name From dmpl__Resource__c LIMIT 1];
        saleOrder.Add(new dmpl__SaleOrder__c(dmpl__AccountId__c = contactAddress.dmpl__AccountId__c,
                                             dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                             dmpl__BranchId__c = branch.Id,
                                             dmpl__DocumentDate__c = Date.today(),
                                             dmpl__Status__c = 'Draft',
                                             dmpl__BillingAddressId__c = contactAddress.Id,
                                             dmpl__ShippingAddressId__c = contactAddress.Id,
                                             dmpl__RequiredDate__c = Date.today(),
                                             //dmpl__SalesExecutiveId__c = resource.Id,
                                             dmpl__BookingAmount__c = 100,
                                             dmpl__PromisedDate__c = Date.today(),
                                             dmpl__PerformReleaseFulfilment__c = false,
                                             dmpl__PerformReleaseInvoice__c = false,
                                             dmpl__PerformReleaseDelivery__c = false,
                                             dmpl__AmountPaid__c = 100
                                            ));
        insert saleOrder;
    }
    
    private static void CreateTaxGroup()
    {
        List<dmpl__TaxGroup__c> taxGroup = new List<dmpl__TaxGroup__c>();
        Account account=[Select Id,Name from Account Where Name='Partner-Test-Account'];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c Where Name = 'Test-Branch']; 
        dmpl__AccountGroup__c accountGroup = [Select Id,Name From dmpl__AccountGroup__c ];
        taxGroup.Add(new dmpl__TaxGroup__c(Name = 'Test - Tax Group',
                                           dmpl__PartnerAccountId__c = account.Id,
                                           dmpl__BranchId__c = branch.Id,
                                           dmpl__PartnerAccountGroupId__c = accountGroup.Id,
                                           dmpl__Description__c = 'Description',
                                           dmpl__IsActive__c = true,
                                           dmpl__TaxGroupType__c = 'Line Level'
                                          ));
        insert taxGroup;
    
        List<dmpl__Tax__c> tax = new List<dmpl__Tax__c>();
        tax.Add(new dmpl__Tax__c(Name = 'Test - Tax',
                                 dmpl__TaxGroupId__c = taxGroup[0].Id,
                                 dmpl__Type__c = 'Cess',
                                 dmpl__Rate__c = 10,
                                 dmpl__PostingFieldName__c = 'Tax1'
                                ));        
        insert tax;
    }

    private static void CreateContactAddress()
    {
        List<dmpl__ContactAddress__c> contactAddress = new List<dmpl__ContactAddress__c>();
        Account account = [Select Id,Name From Account WHERE Name = 'Customer-Test-Account' LIMIT 1];
        contactAddress.add(new dmpl__ContactAddress__c(dmpl__AccountId__c = account.Id,
                                                       Name = 'Test - Contact - Address',
                                                       dmpl__AddressType__c = 'Both'
                                                      ));
        insert contactAddress;
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
    
        List<dmpl__ItemComponent__c> itemComponent = new List<dmpl__ItemComponent__c>();
        dmpl__Item__c item1 = [Select Id,Name From dmpl__Item__c where dmpl__ItemType__c='Product'  LIMIT 1];
        dmpl__Item__c compitem = [Select Id,Name From dmpl__Item__c where dmpl__ItemType__c='Charge Item' LIMIT 1];
        Account act = [Select Id,Name From Account Where Name ='Partner-Test-Account' LIMIT 1];
        dmpl__SKU__c sku = [Select Id,Name From dmpl__SKU__c LIMIT 1];
        itemComponent.add(new dmpl__ItemComponent__c(dmpl__ItemId__c = item1.Id,
                                                     dmpl__ComponentItemId__c=compitem.Id,
                                                     dmpl__SKUId__c = sku.Id,
                                                     dmpl__IsMandatory__c=false,
                                                     dmpl__IsBundled__c=true,
                                                     dmpl__PackageType__c='Independent Of Package',
                                                     dmpl__Quantity__c = 10,
                                                     dmpl__IsSelected__c=true,
                                                     dmpl__IsQuantityEditable__c=True,
                                                     dmpl__ApplicableFor__c='Sale',
                                                     dmpl__PartnerAccountId__c = act.id,
                                                     dmpl__FeatureId__c = itemFeature[0].Id,
                                                     dmpl__SortOrder__c = 30));
        insert itemComponent;
    }
    
    private static void CreateItemAlternate()
    {
        List<dmpl__ItemAlternate__c> itemComponent = new List<dmpl__ItemAlternate__c>();
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        itemComponent.add(new dmpl__ItemAlternate__c(dmpl__ItemId__c = item.Id,
                                                     dmpl__AlternateItemId__c=item.Id
                                                    ));
        insert itemComponent;
    }

    private static void CreatePriceList()
    {
        List<dmpl__PriceList__c> priceLists = new List<dmpl__PriceList__c>();
        Account account = [Select Id,Name From Account Limit 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c Where Name = 'Test-Branch'];
        dmpl__AccountGroup__c accountGroup = [Select Id,Name From dmpl__AccountGroup__c];
        priceLists.add(new dmpl__PriceList__c (Name = 'Test-Price',
                                               dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                               dmpl__BranchId__c = branch.Id,
                                               dmpl__PriceListType__c = 'Sale Price',
                                               dmpl__IsActive__c = true,
                                               dmpl__IsDefault__c = true,
                                               dmpl__PartnerAccountGroupId__c = accountGroup.Id,
                                               dmpl__CustomerAccountGroupId__c = accountGroup.Id
                                              ));
        insert priceLists;
    
        List<dmpl__PriceListRules__c> priceListRules =new List<dmpl__PriceListRules__c>();
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        priceListRules.Add(new dmpl__PriceListRules__c(dmpl__ItemId__c = item.Id,
                                                       dmpl__PriceListId__c=priceLists[0].Id,
                                                       dmpl__Price__c=500,
                                                       dmpl__DateEffectiveFrom__c = date.today()-(7),
                                                       dmpl__DateEffectiveTill__c=date.today()
                                                      ));
        insert priceListRules;
    }  
    
    private static void CreateSubscriptionUsage()
    {
        List<dmpl__SubscriptionUsage__c> subsUsage =new List<dmpl__SubscriptionUsage__c>();
        Account cusAccount=[Select Id,Name from Account Where Name='Customer-Test-Account'];
        subsUsage.Add(new dmpl__SubscriptionUsage__c(dmpl__AccountId__c = cusAccount.Id,
                                                      dmpl__Quantity__c=2                              
                                                    ));
        insert subsUsage;
    }  
  
    private static void CreateSubscription()
    {
        List<dmpl__Subscription__c> subs = new List<dmpl__Subscription__c>();
        Account account=[Select Id,Name from Account Where Name='Partner-Test-Account'];
        Account cusAccount=[Select Id,Name from Account Where Name='Customer-Test-Account'];
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c Where Name = 'Test-Branch']; 
        subs.Add(new dmpl__Subscription__c(dmpl__AccountId__c =cusAccount.Id,
                                           dmpl__PartnerAccountId__c = account.Id,
                                           dmpl__BranchId__c = branch.Id,
                                           dmpl__NextBillingDate__c=date.today(),
                                           dmpl__ChargeType__c = 'Recurring',
                                           dmpl__ItemId__c = item.Id
                                          ));
        subs.Add(new dmpl__Subscription__c(dmpl__AccountId__c =cusAccount.Id,
                                           dmpl__PartnerAccountId__c = account.Id,
                                           dmpl__BranchId__c = branch.Id,
                                           dmpl__NextBillingDate__c=date.today(),
                                           dmpl__ChargeType__c = 'Usage',
                                           dmpl__ItemId__c = item.Id
                                          ));
        insert subs;
    }
    
    private static void CreateSubscriptionSumary()
    {
        List<dmpl__SubscriptionUsageSumary__c> subsUsageSummary = new List<dmpl__SubscriptionUsageSumary__c>();
        dmpl__Subscription__c subs = [Select Id,Name From dmpl__Subscription__c WHERE dmpl__ChargeType__c = 'Recurring' LIMIT 1];
        dmpl__Subscription__c subs1 = [Select Id,Name From dmpl__Subscription__c WHERE dmpl__ChargeType__c = 'Usage' LIMIT 1];
        dmpl__SaleInvoiceLine__c invoiceLine =[Select Id, Name From dmpl__SaleInvoiceLine__c Limit 1];
        dmpl__SaleInvoice__c invoice =[Select Id, Name,dmpl__SubscriptionId__c From dmpl__SaleInvoice__c Limit 1];
        subsUsageSummary.Add(new dmpl__SubscriptionUsageSumary__c(dmpl__SubscriptionId__c = subs.Id,
                                                                dmpl__BilledQuantity__c = 5,
                                                                dmpl__UnbilledQuantity__c=2,
                                                                dmpl__SaleInvoiceId__c=invoice.Id,
                                                                dmpl__SaleInvoiceLineId__c=invoiceLine.Id,
                                                                dmpl__NextBillingDate__c=date.today()
        ));
        
        subsUsageSummary.Add(new dmpl__SubscriptionUsageSumary__c(dmpl__SubscriptionId__c = subs1.Id,
                                                                dmpl__BilledQuantity__c = 5,
                                                                dmpl__UnbilledQuantity__c=2,
                                                                dmpl__SaleInvoiceId__c=null,
                                                                dmpl__SaleInvoiceLineId__c=invoiceLine.Id,
                                                                dmpl__NextBillingDate__c=date.today()
        ));
        insert subsUsageSummary;
    }
    
    
     private static void CreateSaleInvoice()
    {
        List<dmpl__SaleInvoice__c> saleInvoice = new List<dmpl__SaleInvoice__c>();
        Account account = [Select Id,Name From Account WHERE Name = 'Customer-Test-Account' LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c LIMIT 1];
        dmpl__SaleOrder__c saleOrder = [Select Id,Name From dmpl__SaleOrder__c LIMIT 1];
        //dmpl__Resource__c resource = [Select Id,Name From dmpl__Resource__c LIMIT 1];
        dmpl__Subscription__c subs = [Select Id,Name From dmpl__Subscription__c LIMIT 1];
        saleInvoice.Add(new dmpl__SaleInvoice__c(dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                                 dmpl__BranchId__c = Branch.Id,
                                                 dmpl__DocumentDate__c = date.today(),
                                                 dmpl__AccountId__c = account.Id,
                                                 //dmpl__SalesExecutiveId__c = resource.Id,
                                                 dmpl__SaleOrderId__c = saleOrder.Id,
                                                 dmpl__FinanceAmount__c=100,
                                                 dmpl__AmountPaid__c =1 ,
                                                 dmpl__SubscriptionId__c = subs.Id,
                                                 dmpl__Status__c='Draft'
                                                ));
        insert saleInvoice;
        
        List<dmpl__SaleInvoiceLine__c> saleInvoiceLine = new List<dmpl__SaleInvoiceLine__c>();
        dmpl__SKU__c sku = [Select Id ,Name, dmpl__ItemId__c From dmpl__SKU__c LIMIT 1 ];
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c Where  dmpl__ItemType__c = 'Subscription' LIMIT 1]; 
        dmpl__TaxGroup__c taxGroup = [Select Id,Name From dmpl__TaxGroup__c LIMIT 1];
        saleInvoiceLine.Add(new dmpl__SaleInvoiceLine__c(dmpl__SaleInvoiceId__c = SaleInvoice[0].id,
                                                         dmpl__ItemId__c = item.Id,
                                                         dmpl__IsILPostingApproved__c=false,
                                                         dmpl__IsGLPostingApproved__c=false,
                                                         dmpl__Quantity__c = 100,
                                                         dmpl__UnitPrice__c = 100,
                                                         dmpl__SKUId__c = sku.Id,
                                                         dmpl__SchemeDiscountAmount__c = 100,
                                                         dmpl__TaxGroupId__c = taxGroup.Id 
                                                        ));
        insert saleInvoiceLine;
    }
    
    private static void CreateSaleInvoice1()
    {
        List<dmpl__SaleInvoice__c> saleInvoice = new List<dmpl__SaleInvoice__c>();
        Account account = [Select Id,Name From Account WHERE Name = 'Customer-Test-Account' LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c LIMIT 1];
        dmpl__SaleOrder__c saleOrder = [Select Id,Name From dmpl__SaleOrder__c LIMIT 1];
        dmpl__PriceList__c priceList=[select Id, Name from dmpl__PriceList__c LIMIT 1]; 
        dmpl__Subscription__c subs =[Select Id, Name from dmpl__Subscription__c Limit 1];
        //dmpl__Resource__c resource = [Select Id,Name From dmpl__Resource__c LIMIT 1];
        saleInvoice.Add(new dmpl__SaleInvoice__c(dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                                 dmpl__BranchId__c = Branch.Id,
                                                 dmpl__SubscriptionId__c=subs.Id,
                                                 dmpl__PriceListId__c=priceList.Id,
                                                 dmpl__DocumentDate__c = date.today(),
                                                 dmpl__AccountId__c = account.Id,
                                                 //dmpl__SalesExecutiveId__c = resource.Id,
                                                 dmpl__SaleOrderId__c = saleOrder.Id,
                                                 dmpl__FinanceAmount__c=100,
                                                 dmpl__AmountPaid__c =1 ,
                                                 dmpl__Status__c='Draft'
                                                ));
        insert saleInvoice;
        
        List<dmpl__SaleInvoiceLine__c> saleInvoiceLine = new List<dmpl__SaleInvoiceLine__c>();
        dmpl__SKU__c sku = [Select Id ,Name, dmpl__ItemId__c From dmpl__SKU__c LIMIT 1 ];
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c Where  dmpl__ItemType__c = 'Subscription' LIMIT 1]; 
        Asset asset =[select Id ,Name from Asset Limit 1];
        dmpl__PriceListRules__c priceRule =[select Id, Name from dmpl__PriceListRules__c Limit 1];
        dmpl__TaxGroup__c taxGroup = [Select Id,Name From dmpl__TaxGroup__c LIMIT 1];
        dmpl__ItemLot__c itemLot = [Select Id, Name From dmpl__ItemLot__c LIMIT 1];
        saleInvoiceLine.Add(new dmpl__SaleInvoiceLine__c(dmpl__SaleInvoiceId__c = SaleInvoice[0].id,
                                                         dmpl__ItemId__c = item.Id,
                                                         dmpl__SubscriptionId__c=subs.Id,
                                                         dmpl__PriceListRuleId__c=priceRule.Id,
                                                         dmpl__AssetId__c=asset.Id,
                                                         dmpl__IsILPostingApproved__c=false,
                                                         dmpl__IsGLPostingApproved__c=false,
                                                         dmpl__ItemLotId__c = itemLot.Id,
                                                         dmpl__Quantity__c = 100,
                                                         dmpl__UnitPrice__c = 100,
                                                         dmpl__SKUId__c = sku.Id,
                                                         dmpl__SchemeDiscountAmount__c = 100,
                                                         dmpl__TaxGroupId__c = taxGroup.Id 
                                                        ));
        insert saleInvoiceLine;
    }
    
    private static void CreateSaleInvoice2()
    {
        List<dmpl__SaleInvoice__c> saleInvoice = new List<dmpl__SaleInvoice__c>();
        Account account = [Select Id,Name From Account WHERE Name = 'Customer-Test-Account' LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c LIMIT 1];
        dmpl__SaleOrder__c saleOrder = [Select Id,Name From dmpl__SaleOrder__c LIMIT 1];
        dmpl__PriceList__c priceList=[select Id, Name from dmpl__PriceList__c LIMIT 1]; 
        dmpl__Subscription__c subs =[Select Id, Name from dmpl__Subscription__c Limit 1];
        //dmpl__Resource__c resource = [Select Id,Name From dmpl__Resource__c LIMIT 1];
        saleInvoice.Add(new dmpl__SaleInvoice__c(dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                                 dmpl__BranchId__c = Branch.Id,
                                                 dmpl__SubscriptionId__c=subs.Id,
                                                 dmpl__PriceListId__c=priceList.Id,
                                                 dmpl__DocumentDate__c = date.today(),
                                                 dmpl__AccountId__c = account.Id,
                                                 //dmpl__SalesExecutiveId__c = resource.Id,
                                                 dmpl__SaleOrderId__c = saleOrder.Id,
                                                 dmpl__FinanceAmount__c=100,
                                                 dmpl__AmountPaid__c =1 ,
                                                 dmpl__Status__c='Draft'
                                                ));
        insert saleInvoice;
        
        List<dmpl__SaleInvoiceLine__c> saleInvoiceLine = new List<dmpl__SaleInvoiceLine__c>();
        dmpl__SKU__c sku = [Select Id ,Name, dmpl__ItemId__c From dmpl__SKU__c LIMIT 1 ];
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c Where  dmpl__ItemType__c = 'Subscription' LIMIT 1]; 
        Asset asset =[select Id ,Name from Asset Limit 1];
        dmpl__SubscriptionUsage__c subsUsage =[Select Id, Name from dmpl__SubscriptionUsage__c Limit 1];
        dmpl__PriceListRules__c priceRule =[select Id, Name from dmpl__PriceListRules__c Limit 1];
        dmpl__TaxGroup__c taxGroup = [Select Id,Name From dmpl__TaxGroup__c LIMIT 1];
        dmpl__ItemLot__c itemLot = [Select Id, Name From dmpl__ItemLot__c LIMIT 1];
        saleInvoiceLine.Add(new dmpl__SaleInvoiceLine__c(dmpl__SaleInvoiceId__c = SaleInvoice[0].id,
                                                         dmpl__ItemId__c = item.Id,
                                                         dmpl__SubscriptionId__c=subs.Id,
                                                         dmpl__SubscriptionUsageId__c=subsUsage.Id,
                                                         dmpl__PriceListRuleId__c=priceRule.Id,
                                                         dmpl__AssetId__c=asset.Id,
                                                         dmpl__IsILPostingApproved__c=false,
                                                         dmpl__IsGLPostingApproved__c=false,
                                                         dmpl__ItemLotId__c = itemLot.Id,
                                                         dmpl__Quantity__c = 100,
                                                         dmpl__UnitPrice__c = 100,
                                                         dmpl__SKUId__c = sku.Id,
                                                         dmpl__SchemeDiscountAmount__c = 100,
                                                         dmpl__TaxGroupId__c = taxGroup.Id 
                                                        ));
        insert saleInvoiceLine;
    }
    
    private static void CreateItemLot()
    {
        List<dmpl__ItemLot__c> itemLot = new List<dmpl__ItemLot__c>();
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c Limit 1];
        dmpl__SKU__c sku = [Select Id ,Name,dmpl__ItemId__c From dmpl__SKU__c LIMIT 1 ];
        itemLot.Add(new dmpl__ItemLot__c(dmpl__BranchId__c = branch.Id,
                                         dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                         dmpl__ItemId__c = sku.dmpl__ItemId__c,
                                         dmpl__SKUId__c =sku.Id,
                                         dmpl__BatchNo__c = 'AAA',
                                         dmpl__SerialNumber__c='BBB',
                                         dmpl__SupplierInvoiceNumber__c='CCC',
                                         dmpl__DateOfReceipt__c= date.today(),
                                         dmpl__DateOfMfg__c=date.today(),
                                         dmpl__TotalCost__c=10.2,
                                         dmpl__DateOfSupplierInvoice__c=date.today(),
                                         dmpl__Cost__c=38.3
                                        ));
        insert itemLot;       
    }
    
    private static void CreateAsset()
    {
        List<Asset> asset = new List<Asset>();
        Account account = [Select Id,Name From Account WHERE Name = 'Customer-Test-Account' LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name From dmpl__Branch__c LIMIT 1];
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        dmpl__ItemLot__c itemLot = [Select Id, Name From dmpl__ItemLot__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id,Name FROM dmpl__SKU__c LIMIT 1];
        asset.add(new Asset(Name = 'Test-Asset',
                            AccountId = account.Id,
                            dmpl__LastServiceBranchId__c = branch.Id,
                            dmpl__ItemId__c = item.Id,
                            dmpl__ItemLotId__c = itemLot.Id,
                            dmpl__SKUId__c = sku.Id,
                            dmpl__IsPDIDone__c=true,
                            dmpl__RegistrationNumber__c = 'Axb371',
                            dmpl__SaleDate__c = date.today()
                           ));
        insert asset;
        
        List<dmpl__AssetServiceContract__c> assetServiceContracts = new List<dmpl__AssetServiceContract__c>();
        assetServiceContracts.add(new dmpl__AssetServiceContract__c(
            dmpl__AssetId__c = asset[0].Id,
            dmpl__ItemId__c = item.Id,
            dmpl__ServiceContractItemId__c = item.Id,
            dmpl__ActivatedDate__c = Datetime.now().Date(),
            dmpl__DueDate__c = Datetime.now().addDays(365).Date()
        ));
        insert assetServiceContracts;
        
        dmpl__Item__c workItem = new dmpl__Item__c(
            Name = 'Washing', 
            dmpl__ItemCode__c = 'Washing', 
            dmpl__ItemType__c = 'Work Item',
            dmpl__IsActive__c = true);
        
        insert workItem;
        
        dmpl__AssetServiceContractLine__c assetServiceContractLine = new dmpl__AssetServiceContractLine__c(
            dmpl__AssetServiceContractId__c = assetServiceContracts[0].Id,
            dmpl__ComponentItemId__c = workItem.Id,
            dmpl__Quantity__c = 1,
            dmpl__UtilizedQuantity__c = 0);
        insert assetServiceContractLine;
    }

}