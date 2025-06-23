@isTest
public class BulkOrderLineBatch_Test {
    
    @testSetup
    public static void Setup()
    {
        CreateAccountGroup();
        CreateAccount();
        CreateBranch();
        CreateItems();
        CreateSKu();
        CreateItemLot();
        CreatePriceList();
        CreateResource();
        CreateInterfaceServiceProvider();
        CreateInterfaceServiceProviderRequest();
        CreateInterfaceQueue();
        CreateSaleOrder();
        CreateSaleOrderLine();
        test.starttest();
        CreateSaleInvoice();
        CreateSaleInvoiceLine();
        test.stoptest();
        CreateJobQueueRecord();
    }
    @isTest
    private static void test1(){
        Id order=[Select Id From dmpl__SaleOrder__c LIMIT 1].Id;
        Id queues = [Select Id,Name From dmpl__InterfaceQueue__c LIMIT 1].Id;
         dmpl__SaleInvoiceLine__c saleInvoiceLines = [SELECT Id,Name,dmpl__ItemId__c,dmpl__UnitPrice__c,dmpl__SaleOrderLineId__c,dmpl__UnitPrice2__c,dmpl__Quantity__c,dmpl__TaxGroupId__c,
                                                         dmpl__IsPriceBundled__c,dmpl__ItemComponentId__c,dmpl__PackageSaleOrderLineId__c,dmpl__Discount__c,
                                                         dmpl__Discount2__c,dmpl__DiscountGroupRuleId__c,dmpl__DiscountAmount__c,dmpl__DiscountAmount2__c,
                                                         dmpl__BillingType__c,dmpl__BillingFrequency__c,dmpl__ChargeType__c,dmpl__SaleInvoiceId__c
                                                         FROM dmpl__SaleInvoiceLine__c LIMIT 1];
            dmpl__SaleOrderLine__c saleOrderLines = [SELECT Id,Name,dmpl__ItemLotTypeId__c FROM dmpl__SaleOrderLine__c LIMIT 1];
            
           
        String batchQuery = 'SELECT Id, Name, dmpl__SaleOrderId__c, dmpl__SaleOrderLineId__c, dmpl__Status__c ' +
            'FROM dmpl__JobQueueRecord__c ' +
            'WHERE dmpl__Status__c = \'Pending\' ' +
            'AND dmpl__JobQueueId__c = \'' + queues + '\' ' +
            'ORDER BY CreatedDate DESC';
        
        BulkOrderLineBatch batch = new BulkOrderLineBatch(batchQuery, queues);
         BulkOrderLineBatch.createNewSaleInvoiceLine(saleInvoiceLines,saleOrderLines);
        
        Test.startTest();
        Id batchJobId = Database.executeBatch(batch, 200);
        BulkOrderLineBatch.perfromAction(order,queues);
        Test.stopTest();
    }
    
    @isTest
    private static void verifycreateNewSaleInvoiceLine()
    {
        Test.startTest();
        try{
           
        }catch(Exception ex){}
        Test.stopTest();
    }

    private static void CreateAccount()
    {
        List<Account> account = new List<Account>();
        dmpl__AccountGroup__c accountGroup = [Select Id,Name From dmpl__AccountGroup__c LIMIT 1];
        account.add(new Account(Name = 'Test - Account', 
                                Fax = '09876',
                                dmpl__LastName__c = 'Account',
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
                                             dmpl__LastName__c = 'Account',
                                             dmpl__IsPartnerAccount__c = True, 
                                             dmpl__IsActive__c = true);
        insert partneraccount;
        
        Account supplieraccount = new Account(Name = 'Supplier-Test-Account',
                                              dmpl__LastName__c = 'Account',
                                              dmpl__IsSupplierAccount__c = True,
                                              dmpl__IsActive__c = true);
        insert supplieraccount;
        
        Account customerAccount = new Account(Name = 'Customer-Test-Account',
                                              dmpl__IsCustomerAccount__c = True,
                                              dmpl__LastName__c = 'Account',
                                              dmpl__IsActive__c = true);
        insert customerAccount;
    }
    
    private static void CreateAccountGroup()
    {
        dmpl__AccountGroup__c accountGroup= new dmpl__AccountGroup__c (Name= 'Test-AccountGroup', 
                                                                       dmpl__AccountGroupType__c='Scheme',
                                                                       dmpl__DynamicMemberType__c = 'Report Data',
                                                                       dmpl__ReportId__c = 'flow_screen_prebuilt_report',
                                                                       dmpl__RuleSuccessCriteria__c = 'Custom Logic Is Met',
                                                                       dmpl__RuleSuccessCustomLogic__c = 'Test'
                                                                      );
        insert accountGroup;
    }
    
    private static void CreateBranch()
    {
        List<dmpl__Branch__c> branch = new List<dmpl__Branch__c>();
        Account partnerAccount = [Select Id,Name From Account WHERE Name = 'Partner-Test-Account' LIMIT 1];
        branch.Add(new dmpl__Branch__c(dmpl__PartnerAccountId__c =partnerAccount.Id,
                                       Name = 'Test-Branch',
                                       dmpl__IsActive__c = true,
                                       dmpl__MarketingName__c = 'Hero Electric',
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
                                       dmpl__ServiceEmail__c = 'Customer@Outlook.com',
                                       dmpl__Website__c = 'www.Dealer.com'));
        insert branch;
    }
    
    private static void CreateItems()
    {
        List<dmpl__Item__c> item = new List<dmpl__Item__c>();
        item.Add(new dmpl__Item__c(Name = 'Test-Item1',
                                   dmpl__ItemCode__c = 'DMPL',
                                   dmpl__ItemType__c = 'Charge Item',
                                   dmpl__ItemSubType__c = 'Insurance',
                                   dmpl__Description__c = 'NA',
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
                                   dmpl__GTIN__c = 'BR12311',
                                   dmpl__RFID__c = 'O1234fgh234'
                                   
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
    
    private static void CreateItemLot()
    {
        List<dmpl__ItemLot__c> itemLot = new List<dmpl__ItemLot__c>();
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c Limit 1];
        dmpl__SKU__c sku = [Select Id ,Name From dmpl__SKU__c LIMIT 1 ];
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        itemLot.Add(new dmpl__ItemLot__c(dmpl__BranchId__c = branch.Id,
                                         dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                         dmpl__ItemId__c = item.Id,
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
    }
    
    private static void CreateResource()
    {
        List<dmpl__Resource__c> resource = new List<dmpl__Resource__c>();
        Account partnerAccount = [Select Id,Name From Account LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name From dmpl__Branch__c LIMIT 1];
        resource.add(new dmpl__Resource__c(Name = 'Test - Resource',
                                           dmpl__Type__c = 'None',
                                           dmpl__IsActive__c = true,
                                           dmpl__Phone__c = '9999999999',
                                           dmpl__DefaultPartnerAccountId__c = partnerAccount.Id,
                                           dmpl__DefaultBranchId__c = branch.Id
                                          ));
        insert resource;
        
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
    }
    
    private static void CreateInterfaceServiceProviderRequest()
    {
        List<dmpl__InterfaceServiceProviderRequest__c> interfaceServiceRequest = new List<dmpl__InterfaceServiceProviderRequest__c>();
        dmpl__InterfaceServiceProvider__c interfaceService = [Select Id,Name From dmpl__InterfaceServiceProvider__c LIMIT 1];
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
            dmpl__InterfaceServiceProviderId__c=interfaceService.Id,
            dmpl__HttpVerb__c='GET',
            dmpl__HttpQuery__c='vdhdvhd'
        ));
        insert interfaceServiceRequest;
    }
    
    public static void CreateInterfaceQueue()
    {
        List<dmpl__InterfaceQueue__c> interfaceQueue =new List<dmpl__InterfaceQueue__c>();
        dmpl__InterfaceServiceProvider__c interfaceService = [Select Id,Name From dmpl__InterfaceServiceProvider__c LIMIT 1];
        dmpl__InterfaceServiceProviderRequest__c request = [Select Id,Name From dmpl__InterfaceServiceProviderRequest__c LIMIT 1]; 
        interfaceQueue.Add(new dmpl__InterfaceQueue__c(dmpl__InterfaceProviderId__c =interfaceService.Id,
                                                       dmpl__QueueType__c = 'Queueable',
                                                       dmpl__InterfaceRequestId__c = request.Id,
                                                       dmpl__JobType__c = 'Account Group Member Processor'));
        insert interfaceQueue;
        
        List<dmpl__InterfaceQueue__c> interfaceQueue1 =new List<dmpl__InterfaceQueue__c>();
        dmpl__InterfaceServiceProvider__c interfaceService1 = [Select Id,Name From dmpl__InterfaceServiceProvider__c LIMIT 1];
        dmpl__InterfaceServiceProviderRequest__c request1 = [Select Id,Name From dmpl__InterfaceServiceProviderRequest__c LIMIT 1]; 
        interfaceQueue1.Add(new dmpl__InterfaceQueue__c(dmpl__InterfaceProviderId__c =interfaceService1.Id,
                                                        dmpl__QueueType__c = 'Queueable',
                                                        dmpl__InterfaceRequestId__c = request1.Id,
                                                        dmpl__JobType__c = 'Item Group Member Processor'));
        insert interfaceQueue1;
    }
    
    private static void CreateSaleOrder()
    {
        List<dmpl__SaleOrder__c> saleOrder = new List<dmpl__SaleOrder__c>();
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c Where Name = 'Test-Branch' LIMIT 1];
        dmpl__Resource__c resource = [Select Id,Name From dmpl__Resource__c LIMIT 1];
        dmpl__PriceList__c priceList = [Select Id,Name From dmpl__PriceList__c LIMIT 1];
        Account partnerAccount1 = [Select Id,Name From Account WHERE Name = 'Customer-Test-Account' LIMIT 1];
        saleOrder.Add(new dmpl__SaleOrder__c(dmpl__AccountId__c = partnerAccount1.Id,
                                             dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                             dmpl__BranchId__c = branch.Id,
                                             dmpl__DocumentDate__c = Date.today(),
                                             dmpl__Status__c = 'Draft',
                                             dmpl__RequiredDate__c = Date.today(),
                                             dmpl__SalesExecutiveId__c = resource.Id,
                                             dmpl__PriceListId__c = priceList.Id,
                                             dmpl__BookingAmount__c = 100,
                                             dmpl__PromisedDate__c = Date.today(),
                                             dmpl__PerformReleaseFulfilment__c = false,
                                             dmpl__PerformReleaseInvoice__c = false,
                                             dmpl__PerformReleaseDelivery__c = false,
                                             dmpl__AmountPaid__c = 100
                                            ));
        insert saleOrder;
    }
    
    private static void CreateJobQueueRecord()
    {
        List<dmpl__JobQueueRecord__c> queueRecord = new List<dmpl__JobQueueRecord__c>();
        dmpl__SaleOrder__c order = [Select Id,Name From dmpl__SaleOrder__c LIMIT 1];
        dmpl__SaleOrderLine__c orderLine = [Select Id,Name From dmpl__SaleOrderLine__c LIMIT 1];
        dmpl__InterfaceQueue__c queue= [Select Id,Name From dmpl__InterfaceQueue__c LIMIT 1];
        queueRecord.Add(new dmpl__JobQueueRecord__c(dmpl__SaleOrderId__c  = order.Id,
                                                    dmpl__JobQueueId__c  = queue.Id,
                                                    Status__c='Pending',
                                                    dmpl__SaleOrderLineId__c = orderLine.Id
                                                   ));
        insert queueRecord;
    }
    
    private static void CreateSaleOrderLine()
    {
        List<dmpl__SaleOrderLine__c> saleOrderLine = new List<dmpl__SaleOrderLine__c>();
        dmpl__SaleOrder__c saleOrder = [Select Id,Name From dmpl__SaleOrder__c LIMIT 1];
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        dmpl__ItemLot__c itemLot = [Select Id,Name From dmpl__ItemLot__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id,Name From dmpl__SKU__c LIMIT 1];
        saleOrderLine.Add(new dmpl__SaleOrderLine__c(dmpl__SaleOrderId__c = saleOrder.Id,
                                                     dmpl__ItemId__c = item.Id,
                                                     dmpl__SKUId__c = sku.Id,
                                                     dmpl__Quantity__c = 10,
                                                     dmpl__IsPriceBundled__c=false,
                                                     dmpl__ItemLotId__c = itemLot.Id
                                                    ));
        insert saleOrderLine;
    }
    
    private static void CreateSaleInvoice()
    {
        List<dmpl__SaleInvoice__c> saleInvoice = new List<dmpl__SaleInvoice__c>();
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        dmpl__SaleOrder__c saleOrder = [Select Id,Name From dmpl__SaleOrder__c LIMIT 1];
        saleInvoice.Add(new dmpl__SaleInvoice__c(dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                                 dmpl__BranchId__c = branch.Id,
                                                 dmpl__SaleOrderId__c = saleOrder.id,
                                                 dmpl__AmountPaid__C =1,
                                                 dmpl__DocumentDate__c = Date.today(),
                                                 dmpl__FinanceAmount__c = 10.00
                                                ));
        insert saleInvoice;
    }
    
    private static void CreateSaleInvoiceLine()
    {
        CreateSaleInvoice();
        List<dmpl__SaleInvoiceLine__c> saleInvoiceLine = new List<dmpl__SaleInvoiceLine__c>();
        dmpl__SaleInvoice__c saleInvoice = [Select Id,Name From dmpl__SaleInvoice__c LIMIT 1];
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        dmpl__ItemLot__c itemLot = [Select Id,Name From dmpl__ItemLot__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id,Name From dmpl__SKU__c LIMIT 1];
        dmpl__SaleOrderLine__c orderLine = [Select Id,Name From dmpl__SaleOrderLine__c LIMIT 1];
        saleInvoiceLine.Add(new dmpl__SaleInvoiceLine__c(dmpl__SaleInvoiceId__c = saleInvoice.id,
                                                         dmpl__ItemId__c = item.Id,
                                                         dmpl__SKUId__c = sku.Id,
                                                         dmpl__Quantity__c = 9,
                                                         dmpl__SaleOrderLineId__c = orderLine.Id,
                                                         dmpl__ItemLotId__c = itemLot.Id
                                                        ));
        insert saleInvoiceLine;
    }
}