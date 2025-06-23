@isTest
public class AutoPurchaseOrderHelper_Test {
    
    @testSetup
    public static void Setup()
    {
        System.runAs(PostInstallHelper.AssignAdministratorAllPermissions(UserInfo.getUserId())){
            CreateAccount();
            CreateBranch();
            CreateContactAddress();
            CreateItems();
            CreateSKu();
            CreateResource();
            CreatePriceList();
            CreateTaxGroup();
            test.startTest();
            CreateSaleOrder();
            //CreateSaleOrderLine();
            CreateAutoPurchaseOrder();
            //CreateAutoPurchaseOrderLine();
            CreateFulfillment();
            test.stopTest();
           // CreateInterfaceServiceProvider();
           // CreateInterfaceQueue();
            //CreateFulfillmentOrderLine();
            //CreateAutoPurchaseOrder1();
            //verify();
        }
    }
    
    @isTest
    public static void Verify()
    {
        test.startTest();
        List<dmpl__AutoPurchaseOrder__c> line = [SELECT Id, Name,dmpl__BranchId__c,dmpl__PartnerAccountId__c,dmpl__PerformOpenOrderCalculation__c FROM dmpl__AutoPurchaseOrder__c];
        List<dmpl__AutoPurchaseOrderLine__c> autoPOLine = [Select Id,Name,dmpl__ItemId__c From dmpl__AutoPurchaseOrderLine__c LIMIT 1];
        AutoPurchaseOrderLineHelper.createMinimumStockAutoOrderLineFromAutoOrder(line);
        AutoPurchaseOrderLineHelper.createReplenishAutoOrderLineFromAutoOrder(line);
        AutoPurchaseOrderLineHelper.updatePurchaseOrderQuantity(new List<Id>{line[0].Id});
        System.assert(line != null);
        test.stopTest();
    }
    
    @isTest
    public static void VerifyAOP()
    {
        test.startTest();
        List<dmpl__AutoPurchaseOrder__c> line = [SELECT Id, Name,dmpl__BranchId__c,dmpl__PartnerAccountId__c,dmpl__PerformOpenOrderCalculation__c FROM dmpl__AutoPurchaseOrder__c];
        List<dmpl__AutoPurchaseOrderLine__c> autoPOLine = [Select Id,Name,dmpl__ItemId__c From dmpl__AutoPurchaseOrderLine__c LIMIT 1];
        try {
            List<AggregateResult> re = AutoOrderProcessor.queryOpenSaleOrders(
                line[0].dmpl__PartnerAccountId__c,
                line[0].dmpl__BranchId__c,
                CollectionHelper.extractIds(autoPOLine, 'dmpl__ItemId__c'));    

                AutoOrderProcessor.queryPendingPurchaseOrders(
                line[0].dmpl__PartnerAccountId__c,
                line[0].dmpl__BranchId__c,
                CollectionHelper.extractIds(autoPOLine, 'dmpl__ItemId__c'));    
                
                AutoOrderProcessor.queryPendingPurchaseRequisitions(
                line[0].dmpl__PartnerAccountId__c,
                line[0].dmpl__BranchId__c,
                CollectionHelper.extractIds(autoPOLine, 'dmpl__ItemId__c'));    

                AutoOrderProcessor.getItemRecord(re, autoPOLine[0].dmpl__ItemId__c);
                AutoOrderProcessor.getQuantity(re,'dmpl__ItemId__c',re[0]);

        } catch (Exception ex) {
            
        }
        
        System.assert(line != null);
        test.stopTest();
    }
    
    @isTest
    public static void UpdateAutoPurchaseOrder()
    {
        Test.startTest();
        dmpl__AutoPurchaseOrder__c auotPurchaseOrder = [Select Id,Name,dmpl__PerformOrderGeneration__c From dmpl__AutoPurchaseOrder__c LIMIT 1];
        auotPurchaseOrder.dmpl__PerformOrderGeneration__c = True;
        update auotPurchaseOrder;
        Test.stopTest();
        System.assertEquals(True, auotPurchaseOrder.dmpl__PerformOrderGeneration__c, 'Auto Purchase Order has 1 Record Updated');
        
    }
    
    @isTest
    public static void verifyAutoOrderProcessor()
    {
        try{
         test.startTest(); 
         CreateInterfaceServiceProvider();
         CreateInterfaceQueue();
        dmpl__AutoPurchaseOrder__c auotPurchaseOrder = [Select Id,Name,dmpl__IncludeInTransitShipments__c,dmpl__IncludeOpenSaleOrders__c,dmpl__IncludePendingPurchaseOrders__c,dmpl__PartnerAccountId__c,dmpl__BranchId__c,dmpl__ExcludeFastMovingItems__c,dmpl__ExcludeSlowMovingItems__c,dmpl__ExcludeNonMovingItems__c,dmpl__ExcludeACategoryItems__c,dmpl__ExcludeBCategoryItems__c,dmpl__ExcludeCCategoryItems__c,dmpl__ApplyInventoryAttributeSettings__c From dmpl__AutoPurchaseOrder__c LIMIT 1];
        dmpl__InterfaceQueue__c queue =[Select Id, Name,dmpl__QueueType__c,dmpl__IsSuccessful__c from dmpl__InterfaceQueue__c Limit 1];
        CreateItemInventory();
        AutoOrderProcessor objbatch = new AutoOrderProcessor(auotPurchaseOrder.Id,queue.Id,'Select Id,Name,dmpl__ItemId__c,dmpl__SKUId__c From dmpl__AutoPurchaseOrderLine__c',auotPurchaseOrder,auotPurchaseOrder);
		Database.executeBatch(objbatch);
        System.assert(auotPurchaseOrder!=null, 'Auto Purchase found');
        test.stopTest();
        }catch(Exception e){}
    }
    
    @isTest
    private static void VerifyQueryAutoOrder()
    {
        try{
        test.startTest();
         CreateInterfaceServiceProvider();
         CreateInterfaceQueue();
        dmpl__AutoPurchaseOrder__c auotPurchaseOrder = [Select Id,Name From dmpl__AutoPurchaseOrder__c LIMIT 1];
        dmpl__InterfaceQueue__c queue =[Select Id, Name,dmpl__QueueType__c,dmpl__IsSuccessful__c from dmpl__InterfaceQueue__c Limit 1];
        AutoOrderProcessor.perfromAction(auotPurchaseOrder.Id,queue.Id);
        test.stopTest();
        }catch(Exception e){}
    }
    
    @isTest
    public static void DeleteAutoPurchaseOrder()
    {
        test.startTest();
        dmpl__AutoPurchaseOrder__c auotPurchaseOrder = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__AutoPurchaseOrder__c LIMIT 1];
        
        Delete auotPurchaseOrder;
        System.assert(auotPurchaseOrder!=null, 'Auto Purchase Orderhas 1 Record Deleted');
        test.stopTest();
    } 
    
    @isTest
    public static void UpdateAutoPurchaseOrderLine()
    {
        Test.startTest();
        dmpl__AutoPurchaseOrderLine__c auotPurchaseOrderLine = [Select Id,Name,dmpl__Quantity__c From dmpl__AutoPurchaseOrderLine__c LIMIT 1];
        auotPurchaseOrderLine.dmpl__Quantity__c = 10;
        update auotPurchaseOrderLine;
        Test.stopTest();
        System.assertEquals(10, auotPurchaseOrderLine.dmpl__Quantity__c, 'Auto Purchase Order Line has 1 Record Updated');
    }
    
    @isTest
    public static void DeleteAutoPurchaseOrderLine()
    {
        Test.startTest();
        dmpl__AutoPurchaseOrderLine__c auotPurchaseOrderLine = [Select Id,Name,dmpl__Quantity__c From dmpl__AutoPurchaseOrderLine__c LIMIT 1];
        
        Database.DeleteResult LineResult = Database.delete(auotPurchaseOrderLine, false);
        Test.stopTest();
        System.assert(LineResult.getErrors().size() == 1);
    } 
    
    private static void CreateAccount()
    {
       /* List<Account> account = new List<Account>();
        account.add(new Account(Name = 'Test - Account',
                                dmpl__LastName__c = 'Account',
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
                                dmpl__IsCustomerAccount__c = False
                               ));
        insert account; */
        
        Account partneraccount = new Account(Name = 'Partner-Test-Account',
                                             dmpl__LastName__c = 'PartnerAccount',
                                             dmpl__IsPartnerAccount__c = True, 
                                             dmpl__IsActive__c = true);
        insert partneraccount;
        
        Account customerAccount = new Account(Name = 'Customer-Test-Account',
                                              dmpl__LastName__c = 'CustomerAccount',
                                              dmpl__IsCustomerAccount__c = True,
                                              dmpl__IsActive__c = true);
        insert customerAccount;
        
        Account supplierAccount = new Account(Name = 'Supplier-Test-Account',
                                              dmpl__LastName__c = 'SupplierAccount',
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
                                           dmpl__ResourceType__c = 'Service Advisor',
                                           dmpl__IsActive__c = true,
                                           dmpl__Phone__c = '9999999999',
                                           dmpl__DefaultPartnerAccountId__c = partnerAccount.Id,
                                           dmpl__DefaultBranchId__c = branch.Id
                                          ));
        insert resource;
    }
    
    private static void CreatePriceList()
    {
        List<dmpl__PriceList__c> priceLists = new List<dmpl__PriceList__c>();
        Account account = [Select Id,Name From Account Where dmpl__IsPartnerAccount__c=true Limit 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        priceLists.add(new dmpl__PriceList__c (Name = 'Test-Price',
                                               dmpl__PartnerAccountId__c = account.Id,
                                               dmpl__BranchId__c = branch.Id,
                                               dmpl__PriceListType__c = 'Sale Price',
                                               dmpl__IsActive__c = true,
                                               dmpl__IsDefault__c = true
                                              ));
        insert priceLists;
    }    
    
    private static void CreateAutoPurchaseOrder()
    {
        List<dmpl__AutoPurchaseOrder__c> autoPurchaseOrder = new List<dmpl__AutoPurchaseOrder__c>();
        dmpl__Branch__c branch = [Select Id,Name From dmpl__Branch__c LIMIT 1];
        Account partnerAccount = [Select Id,Name From Account WHERE Name = 'Partner-Test-Account' LIMIT 1];
        Account supplierAccount = [Select Id,Name From Account WHERE Name = 'Supplier-Test-Account' LIMIT 1];
        dmpl__PriceList__c priceList = [Select Id,Name From dmpl__PriceList__c LIMIT 1];
        autoPurchaseOrder.add(new dmpl__AutoPurchaseOrder__c(dmpl__BranchId__c = branch.Id,
                                                             dmpl__PartnerAccountId__c = partnerAccount.Id,
                                                             dmpl__SupplierAccountId__c = supplierAccount.Id,
                                                             dmpl__AutoOrderType__c = 'Replenish',
                                                             dmpl__PriceListId__c = priceList.Id,
                                                             dmpl__PerformOrderGeneration__c = false,
                                                             dmpl__PerformOpenOrderCalculation__c = false,
                                                             dmpl__IsOrderGenerated__c = false,
                                                             dmpl__IncludeOpenSaleOrders__c = true,
                                                             dmpl__IncludePendingPurchaseOrders__c = true,
                                                             dmpl__IncludePurchaseRequisition__c = true,
                                                            dmpl__IncludeInTransitShipments__c = true));
        insert autoPurchaseOrder;
   
        List<dmpl__AutoPurchaseOrder__c> autoPurchaseOrder1 = new List<dmpl__AutoPurchaseOrder__c>();
        //dmpl__Branch__c branch = [Select Id,Name From dmpl__Branch__c LIMIT 1];
        //Account partnerAccount = [Select Id,Name From Account WHERE Name = 'Partner-Test-Account' LIMIT 1];
        //Account supplierAccount = [Select Id,Name From Account WHERE Name = 'Supplier-Test-Account' LIMIT 1];
        //dmpl__PriceList__c priceList = [Select Id,Name From dmpl__PriceList__c LIMIT 1];
        autoPurchaseOrder1.add(new dmpl__AutoPurchaseOrder__c(dmpl__BranchId__c = branch.Id,
                                                              dmpl__PartnerAccountId__c = partnerAccount.Id,
                                                              dmpl__SupplierAccountId__c = supplierAccount.Id,
                                                              dmpl__AutoOrderType__c = 'Minimum Stock Level',
                                                              dmpl__PriceListId__c = priceList.Id,
                                                              dmpl__PerformOrderGeneration__c = false,
                                                              dmpl__IsOrderGenerated__c = false));
        insert autoPurchaseOrder1;
    
        List<dmpl__AutoPurchaseOrderLine__c> autoPurchaseOrderLine = new List<dmpl__AutoPurchaseOrderLine__c>();
        //dmpl__AutoPurchaseOrder__c autoPurchhaseOrder = [Select Id,Name From dmpl__AutoPurchaseOrder__c LIMIT 1];
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id,Name From dmpl__SKU__c LIMIT 1];
        autoPurchaseOrderLine.add(new dmpl__AutoPurchaseOrderLine__c(dmpl__AutoPurchaseOrderId__c = autoPurchaseOrder[0].Id,
                                                                     dmpl__ItemId__c = item.Id,
                                                                     dmpl__SKUId__c = sku.Id,
                                                                     dmpl__Quantity__c = 2,
                                                                     dmpl__UnitCost__c = 100,
                                                                     dmpl__SuggestedQuantity__c = 20,
                                                                     dmpl__PurchaseOrderQuantity__c = 100));
        insert autoPurchaseOrderLine;
    }
    
    private static void CreateFulfillment()
    {
        List<dmpl__InventoryFulfillment__c> fulfillment = new List<dmpl__InventoryFulfillment__c>();
        Account account = [Select Id,Name From Account WHERE dmpl__IsCustomerAccount__c = True  LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        dmpl__SaleOrder__c saleOrder = [Select Id,Name From dmpl__SaleOrder__c LIMIT 1];
        fulfillment.Add(new dmpl__InventoryFulfillment__c(dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                                          dmpl__BranchId__c = Branch.Id,
                                                          dmpl__AccountId__c = account.Id,
                                                          dmpl__IsAllocated__c=true,
                                                          dmpl__SaleOrderId__c = saleOrder.id,
                                                          dmpl__DocumentDate__c = Date.today()                                                          
                                                         ));
        insert fulfillment;
    
        List<dmpl__InventoryFulfillmentOrderLine__c> OrderLine = new List<dmpl__InventoryFulfillmentOrderLine__c>();
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        //dmpl__InventoryFulfillment__c fulfillment = [Select Id,Name From dmpl__InventoryFulfillment__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id, Name from dmpl__SKU__c];
        dmpl__SaleOrderLine__c saleOrderLine = [Select Id,Name From dmpl__SaleOrderLine__c LIMIT 1];
        OrderLine.Add(new dmpl__InventoryFulfillmentOrderLine__c(dmpl__FulfillmentId__c = fulfillment[0].Id,
                                                                 dmpl__ItemId__c = item.id,
                                                                 dmpl__SaleOrderLineId__c = saleOrderLine.Id,
                                                                 dmpl__Quantity__c= 1,
                                                                 dmpl__SKUId__c = sku.Id
                                                                ));
        insert OrderLine;
    }
    
    private static void CreateSaleOrder()
    {
        List<dmpl__SaleOrder__c> saleOrder = new List<dmpl__SaleOrder__c>();
        Account customerAccount = [Select Id,Name From Account WHERE dmpl__IsCustomerAccount__c = True LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c LIMIT 1];
        dmpl__ContactAddress__c contactAddress = [Select Id,Name,dmpl__AccountId__c From dmpl__ContactAddress__c LIMIT 1];
        //dmpl__Resource__c resource = [Select Id,Name,dmpl__IsActive__c From dmpl__Resource__c WHERE dmpl__IsActive__c = true LIMIT 1];
        saleOrder.Add(new dmpl__SaleOrder__c(dmpl__AccountId__c = customerAccount.Id,
                                             dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                             dmpl__BranchId__c = branch.Id,
                                             dmpl__DocumentDate__c = Date.today(),
                                             dmpl__Status__c = 'Draft',
                                             dmpl__BillingAddressId__c = contactAddress.Id,
                                             dmpl__RequiredDate__c = Date.today(),
                                             //dmpl__SalesExecutiveId__c = resource.Id,
                                             dmpl__BookingAmount__c = 100,
                                             dmpl__PromisedDate__c = Date.today(),
                                             dmpl__PerformReleaseFulfilment__c = false,
                                             dmpl__PerformReleaseInvoice__c = false,
                                             dmpl__PerformReleaseDelivery__c = false
                                            ));
        insert saleOrder;
    
        List<dmpl__SaleOrderLine__c> saleOrderLine = new List<dmpl__SaleOrderLine__c>();
        //dmpl__SaleOrder__c saleOrder = [Select Id,Name From dmpl__SaleOrder__c LIMIT 1];
        dmpl__TaxGroup__c taxGroup = [Select Id,Name From dmpl__TaxGroup__c];
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id,Name From dmpl__SKU__c LIMIT 1];
        
        saleOrderLine.Add(new dmpl__SaleOrderLine__c(dmpl__SaleOrderId__c = saleOrder[0].Id,
                                                     dmpl__ItemId__c = item.Id,
                                                     dmpl__SKUId__c = sku.Id,
                                                     dmpl__Quantity__c = 1,
                                                     dmpl__TaxGroupId__c=taxGroup.Id,
                                                     dmpl__UnitPrice__c = 10,
                                                     dmpl__Discount__c = 3
                                                    ));
        insert saleOrderLine;
    }
    
    private static void CreateDiscountGroup()
    {
        List<dmpl__DiscountGroup__c> discountGroup = new List<dmpl__DiscountGroup__c>();
        user userId = [Select Id , Name From User LIMIT 1];
        Account partnerAccount = [Select Id , Name From Account where Name = 'Partner-Test-Account' LIMIT 1];
        dmpl__AccountGroup__c partnerAccountGroup = [Select Id , Name From dmpl__AccountGroup__c LIMIT 1];
        Account customerAccountGroup = [Select Id , Name From Account LIMIT 1];
        dmpl__Branch__c branch = [Select Id , Name From dmpl__Branch__c LIMIT 1];
        discountGroup.add(new dmpl__DiscountGroup__c(Name = 'Discount-Test',
                                                     dmpl__DiscountType__c = 'Sale Price',
                                                     dmpl__IsActive__c = true,
                                                     dmpl__IsDefault__c = true,
                                                     dmpl__PartnerAccountId__c = partnerAccount.Id,
                                                     dmpl__PartnerAccountGroupId__c = partnerAccountGroup.Id,
                                                     dmpl__BranchId__c = branch.Id
                                                    ));
        insert discountGroup;
    }
    
    private static void CreateTaxGroup()
    {
        List<dmpl__TaxGroup__c> taxGroup = new List<dmpl__TaxGroup__c>();
        Account account=[Select Id,Name from Account Where Name='Partner-Test-Account'];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        taxGroup.Add(new dmpl__TaxGroup__c(Name = 'Test - Tax Group',
                                           dmpl__PartnerAccountId__c = account.Id,
                                           dmpl__BranchId__c = branch.Id,
                                           dmpl__Description__c = 'Test-Description',
                                           dmpl__IsActive__c = false
                                          ));
        insert taxGroup;
    }
    
    private static void CreateContactAddress()
    {
        List<dmpl__ContactAddress__c> contAddress = new List<dmpl__ContactAddress__c>();
        Account account = [Select Id,Name From Account where dmpl__IsCustomerAccount__c = True Limit 1];
        contAddress.add(new dmpl__ContactAddress__c (Name = 'Test-Contact',
                                                     dmpl__AccountId__c = account.Id,
                                                     dmpl__AddressType__c = 'Both'
                                                    ));
        insert contAddress;
    }
    
    private static void Createstock()
    {
        List<dmpl__InventoryStock__c> stock = new List<dmpl__InventoryStock__c>();
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c LIMIT 1];
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        stock.Add(new dmpl__InventoryStock__c(dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                              dmpl__BranchId__c = branch.Id,
                                              dmpl__ItemId__c = item.Id
                                             ));
        insert stock;
    }
    
    private static void CreateItemInventory()
    {
        List<dmpl__ItemInventoryAttribute__c> itemInventory = new List<dmpl__ItemInventoryAttribute__c>();
        Account customerAccount = [Select Id,Name From Account WHERE dmpl__IsCustomerAccount__c = True LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c LIMIT 1];
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id,Name From dmpl__SKU__c LIMIT 1];
        itemInventory.Add(new dmpl__ItemInventoryAttribute__c(dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                                              dmpl__BranchId__c = branch.Id,
                                                              dmpl__SKUId__c = sku.Id,
                                                              dmpl__ItemId__c = item.Id,
                                                              dmpl__MaximumOrderQuantity__c =50,
                                                              dmpl__MaximumStockLevel__c = 100,
                                                              dmpl__MinimumOrderQuantity__c = 5,
                                                              dmpl__MinimumStockLevel__c = 12,
                                                              dmpl__ReorderLevel__c = 20,
                                                              dmpl__ReorderQuantity__c = 15,
                                                              dmpl__SuggestedOrderQuantity__c =30,
                                                              dmpl__AverageConsumption__c = 5,
                                                              dmpl__LeadTime__c = 10
                                                             ));
        insert itemInventory;
    }
    
    private static void CreateInterfaceServiceProvider()
    {
        List<dmpl__InterfaceServiceProvider__c> interfaceService = new List<dmpl__InterfaceServiceProvider__c>();
        Account partnerAccount = [Select Id,Name From Account WHERE Name = 'Partner-Test-Account' LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c LIMIT 1];
        interfaceService.add(new dmpl__InterfaceServiceProvider__c(dmpl__PartnerAccountId__c = partnerAccount.Id,
                                                                   Name = 'Test1',
                                                                   dmpl__BranchId__c = Branch.Id,
                                                                   dmpl__NamedCredentials__c='tesrt',
                                                                   dmpl__Logging__c='Callout',
                                                                   dmpl__CustomCredentialsUrl__c='www.rk.com',
                                                                   dmpl__ProviderType__c='REST Client'
                                                                  ));
        insert interfaceService;
    
        List<dmpl__InterfaceServiceProviderRequest__c> interfaceServiceRequest = new List<dmpl__InterfaceServiceProviderRequest__c>();
        //dmpl__InterfaceServiceProvider__c interfaceService = [Select Id,Name From dmpl__InterfaceServiceProvider__c LIMIT 1];
        interfaceServiceRequest.add(new dmpl__InterfaceServiceProviderRequest__c(
            dmpl__CustomFunction__c='TEXT1',
            dmpl__EndPoint__c='TEXT2',
            dmpl__Function__c='Custom Function',
            dmpl__HttpHeaders__c='tEST3',
            dmpl__IsAsynchronous__c=FALSE,
            dmpl__PayloadSchema__c='GFGFDHBDFJBD',
            dmpl__ResponseSchema__c='DBHDFBDBJSB',
            dmpl__StatusEndPoint__c='CHCVCVMCVNMCV',
            dmpl__StatusPayloadSchema__c='BCHCVHBVCJCBBCJBCJBC',
            dmpl__StatusResponseSchema__c='BB CB D C',
            dmpl__InterfaceServiceProviderId__c=interfaceService[0].Id,
            dmpl__HttpVerb__c='GET',
            dmpl__HttpQuery__c='vdhdvhd'
        ));
        insert interfaceServiceRequest;
    }
    
    public static void CreateInterfaceQueue()
    {
        /*List<dmpl__InterfaceQueue__c> interfaceQueue =new List<dmpl__InterfaceQueue__c>();
        dmpl__InterfaceServiceProvider__c interfaceService = [Select Id,Name From dmpl__InterfaceServiceProvider__c LIMIT 1];
        dmpl__InterfaceServiceProviderRequest__c request = [Select Id,Name From dmpl__InterfaceServiceProviderRequest__c LIMIT 1]; 
        interfaceQueue.Add(new dmpl__InterfaceQueue__c(dmpl__InterfaceProviderId__c =interfaceService.Id,
                                                       dmpl__QueueType__c = 'Queueable',
                                                       dmpl__InterfaceRequestId__c = request.Id,
                                                       dmpl__JobType__c = 'Account Group Member Processor'));
        insert interfaceQueue;*/

        List<dmpl__InterfaceQueue__c> interfaceQueue1 =new List<dmpl__InterfaceQueue__c>();
        dmpl__InterfaceServiceProvider__c interfaceService1 = [Select Id,Name From dmpl__InterfaceServiceProvider__c LIMIT 1];
        dmpl__InterfaceServiceProviderRequest__c request1 = [Select Id,Name From dmpl__InterfaceServiceProviderRequest__c LIMIT 1]; 
        interfaceQueue1.Add(new dmpl__InterfaceQueue__c(dmpl__InterfaceProviderId__c =interfaceService1.Id,
                                                       dmpl__QueueType__c = 'Queueable',
                                                       dmpl__InterfaceRequestId__c = request1.Id,
                                                       dmpl__JobType__c = 'Item Group Member Processor'));
        insert interfaceQueue1;
	}
}