@isTest
public class BulkOrderProcessingController_Test {
    @testSetup
    public static void Setup()
    {
        CreateAccountGroup();
		Account customerAccount = AccountDataHelper.createCustomerAccount('CustomerAccount');
        CreateBranch();     
        CreateItems();
        CreateSKu();
        CreateItemLot();
        CreateTaxGroup();
        CreateSaleOrder();
        Test.startTest();  
        CreateResource();
        CreateSaleInvoice();
        CreateFieldSales();
        CreateFieldSalesInvoice();
        CreateVisitRoutes();
        CreateVisitRouteStop();
        CreateVisitPlans();
        Test.stopTest();
    }
    
    @isTest
    private static void test1(){
        List<Account> accs=[Select Id,Name From Account WHERE dmpl__IsCustomerAccount__c = True LIMIT 1];
        List<Id> accIds=DocumentHelper.ExtractIds(accs);
        Id visitPlans=[SELECT Id FROM dmpl__VisitPlan__c LIMIT 1].Id;
        List<dmpl__VisitRoute__c> route = [SELECT Id FROM dmpl__VisitRoute__c LIMIT 1];
        List<Id> routes=DocumentHelper.ExtractIds(route);
        VisitRouteSearchController.getVisitPlanDocuments(visitPlans);
        VisitRouteSearchController.createVisit(accIds,visitPlans,routes);
        VisitRouteSearchController.getAllRelatedVisitRoutes('dmpl__VisitPlan__c',visitPlans);
    }
    
    @isTest
    private static void test2(){
        String groups = [Select Id,Name FROM dmpl__AccountGroup__c LIMIT 1].Id;
        String invoiceNumbers = [Select Id,Name From dmpl__SaleInvoice__c  Where dmpl__Status__c = 'Draft' LIMIT 1].Name;
        List<Account> accs=[Select Id,Name From Account WHERE dmpl__IsCustomerAccount__c = True LIMIT 1];
        List<Id> accIds=DocumentHelper.ExtractIds(accs);
        Id fieldSales=[SELECT Id FROM dmpl__FieldSales__c LIMIT 1].Id;
        List<dmpl__VisitRouteStop__c> stops = [SELECT Id FROM dmpl__VisitRouteStop__c LIMIT 1];
        List<Id> routeStops=DocumentHelper.ExtractIds(stops);
        Set<Id> routeStops1=new Set<Id>(routeStops);
        VisitRouteSearchController.queryAccounts(accIds,'123456','Chandigarh','Punjab');
        VisitRouteSearchController.getFieldSalesType(fieldSales);
        VisitRouteSearchController.getAllRelatedVisitRoutes('dmpl__FieldSales__c',fieldSales);
        VisitRouteSearchController.createFieldSalesInvoice(accIds,fieldSales,routeStops,new List<String>{invoiceNumbers});
        VisitRouteSearchController.getAccounts(fieldSales,'dmpl__FieldSales__c',routeStops,'123456','Chandigarh','Punjab',groups,date.today(),date.today());
    }

    
    @isTest
    public static void testUserDefaults(){
        String emptyJsonString = '[]';

        Test.startTest();
        Boolean result = BulkOrderProcessingController.bulkOrderLine(emptyJsonString);
        BulkOrderProcessingController.getUserDefaults();
        Test.stopTest();

    }
    @isTest
    public static void testgetLineRelatedRecords(){
        dmpl__SaleOrder__c saleOrder = [SELECT Id FROM dmpl__SaleOrder__c LIMIT 1];
        // dmpl__JobQueueRecord__c jobQueue = new dmpl__JobQueueRecord__c(
        //     dmpl__SaleOrderId__c = saleOrder.Id,
        //     Status__c = 'Pending'
        // );
        // insert jobQueue;

        dmpl__VisitRoute__c visitRoute = [SELECT Id FROM dmpl__VisitRoute__c LIMIT 1];
        String whereClause = 'dmpl__SaleOrderId__c != null';
        String orderByClause = ' ORDER BY CreatedDate DESC';
        Boolean doNotShowPartialOrder = false;
        String lineWhereClause = 'dmpl__ItemId__c != null';
        String relatedObjectApiName = 'dmpl__SaleOrderLine__c';
        List<String> queryFields = new List<String>{'dmpl__ItemId__c','dmpl__SaleOrderId__c','dmpl__SKUId__c'};
        List<String> selectedRecordIdsSalesPerson = new List<String>{UserInfo.getUserId()};
        List<String> selectedRecordIds = new List<String>{visitRoute.Id};
        List<String> visitRouteStopAccountIds = new List<String>();

        // Call method
        Test.startTest();
        Map<String, List<SObject>> result = BulkOrderProcessingController.getLineRelatedRecords(
            whereClause,
            orderByClause,
            doNotShowPartialOrder,
            lineWhereClause,
            relatedObjectApiName,
            queryFields,
            selectedRecordIdsSalesPerson,
            selectedRecordIds,
            visitRouteStopAccountIds
        );
    }

     @isTest
     public static void testGetFilteredItemLot() {
         List<dmpl__ItemLot__c> itemLots = [SELECT Id, dmpl__ItemId__c, dmpl__BranchId__c, dmpl__PartnerAccountId__c, 
                                           dmpl__QuantityAvailable__c, dmpl__DateOfExpiry__c, 
                                           dmpl__ItemLotTypeId__c, 
                                           dmpl__ItemLotTypeId__r.dmpl__IsSample__c, 
                                           dmpl__ItemLotTypeId__r.dmpl__IsSaleable__c 
                                    FROM dmpl__ItemLot__c 
                                    ];

        Id itemId = itemLots[0].dmpl__ItemId__c;
        Id branchId = itemLots[0].dmpl__BranchId__c;
        Id partnerAccountId = itemLots[0].dmpl__PartnerAccountId__c;
        Id itemLotTypeId = itemLots[0].dmpl__ItemLotTypeId__c;
        Integer limitExpiryDays = 30;
        Id preferedLotId = itemLots[0].Id;
        Decimal pendingQuantity = 1;

        Map<Id, Decimal> currentQuantityMap = new Map<Id, Decimal>{
            itemLots[0].Id => 10
        };

        Test.startTest();
        dmpl__ItemLot__c result = BulkOrderProcessingController.getFilteredItemLot(
            itemLots,
            itemId,
            branchId,
            partnerAccountId,
            itemLotTypeId,
            currentQuantityMap,
            limitExpiryDays,
            preferedLotId,
            pendingQuantity
        );
        Test.stopTest();

    }

     @isTest
     public static void testcreateBulkOrderLines(){
        List<dmpl__SaleOrderLine__c> saleOrderLines = [SELECT Id, dmpl__SaleOrderId__c, dmpl__ItemId__c, 
                                                        dmpl__SKUId__c, dmpl__Quantity__c, dmpl__PendingInvoiceQuantity__c,dmpl__ItemLotId__c,
                                                        dmpl__TaxGroupId__c, dmpl__UnitPrice__c, 
                                                        dmpl__Discount__c 
                                                 FROM dmpl__SaleOrderLine__c ];
        Test.startTest();
        List<dmpl__JobQueueRecord__c> records = BulkOrderProcessingController.createBulkOrderLines(saleOrderLines);
        Test.stopTest();
     }
    // @isTest
    // public static void testTagItemLots(){
    //     List<dmpl__saleOrderLine__c> saleOrderLines = [SELECT Id,
    //                                                         dmpl__SaleOrderId__c,
    //                                                         dmpl__ItemId__c,
    //                                                         dmpl__SKUId__c,
    //                                                         dmpl__Quantity__c,
    //                                                         dmpl__TaxGroupId__c,
    //                                                         dmpl__UnitPrice__c,
    //                                                         dmpl__Discount__c
    //                                                     FROM dmpl__SaleOrderLine__c LIMIT 1];
    //     List<dmpl__item__C> items = [SELECT 
    //                                         Id, 
    //                                         Name, 
    //                                         dmpl__ItemCode__c, 
    //                                         dmpl__ItemType__c, 
    //                                         dmpl__ItemSubType__c, 
    //                                         dmpl__Description__c, 
    //                                         dmpl__ItemFamily__c, 
    //                                         dmpl__ItemSegment__c, 
    //                                         dmpl__Make__c, 
    //                                         dmpl__Model__c, 
    //                                         dmpl__TrackInventory__c, 
    //                                         dmpl__TrackLots__c, 
    //                                         dmpl__IsSKURequired__c, 
    //                                         dmpl__RequireInspectionOnReceipt__c, 
    //                                         dmpl__RequireInspectionOnDelivery__c, 
    //                                         dmpl__AllowService__c, 
    //                                         dmpl__TrackAsset__c, 
    //                                         dmpl__IsActive__c, 
    //                                         dmpl__IsRegistrationRequired__c, 
    //                                         dmpl__GTIN__c, 
    //                                         dmpl__RFID__c 
    //                                     FROM 
    //                                         dmpl__Item__c  limit 1];
    //     Map<Id, dmpl__Item__c> mapName = new Map<Id, dmpl__Item__c>(items);
    //     List<dmpl__ItemLot__c> itemLots = [SELECT Id,
    //                                                 dmpl__BranchId__c,
    //                                                 dmpl__PartnerAccountId__c,
    //                                                 dmpl__ItemId__c,
    //                                                 dmpl__SKUId__c,
    //                                                 dmpl__BatchNo__c,
    //                                                 dmpl__SerialNumber__c,
    //                                                 dmpl__SupplierInvoiceNumber__c,
    //                                                 dmpl__DateOfReceipt__c,
    //                                                 dmpl__DateOfMfg__c,
    //                                                 dmpl__TotalCost__c,
    //                                                 dmpl__DateOfSupplierInvoice__c,
    //                                                 dmpl__Cost__c,
    //                                                 dmpl__HoldCode__c
    //                                             FROM dmpl__ItemLot__c limit 1
    //                                                     ];
    //     Test.startTest();
    //     BulkOrderProcessingController.tagItemLots(saleOrderLines, mapName, itemLots);
    //     Test.stopTest();
    // }
    
    
    
    @isTest
    public static void testVisitRoute(){
        List<dmpl__VisitRoute__c> route1=[select Id,dmpl__DayNumbers__c,dmpl__MondayAvailable__c,dmpl__TuesdayAvailable__c,dmpl__WednesdayAvailable__c,dmpl__FridayAvailable__c,dmpl__ThursdayAvailable__c,dmpl__SaturdayAvailable__c,dmpl__SundayAvailable__c from dmpl__VisitRoute__c limit 1];
        Test.startTest();
        VisitRouteService.syncDayNumbers(route1);
        VisitRouteService.syncUpdateDayNumbers(route1,route1);
        Test.stopTest();
    }
    
       @isTest
    public static void testFetchVisitRout(){
        List<dmpl__VisitRoute__c> route1=[select Id,dmpl__DayNumbers__c,dmpl__MondayAvailable__c,dmpl__TuesdayAvailable__c,dmpl__WednesdayAvailable__c,dmpl__FridayAvailable__c,dmpl__ThursdayAvailable__c,dmpl__SaturdayAvailable__c,dmpl__SundayAvailable__c from dmpl__VisitRoute__c limit 1];
        Test.startTest();
            List<dmpl__VisitRoute__c> vc =BulkOrderProcessingController.fetchVisitRoute('','','',new list<Id>{});
        try{
       List<dmpl__VisitRoute__c> visitRoutes = BulkOrderProcessingController.fetchVisitRoute(
            'NonexistentRoute', 'somePartnerAccountId', 'someBranchId', new list<Id>{}
        ); 
        }
        catch(exception e){ 
            
        }
        BulkOrderProcessingController.fetchSalesPerson('','','');
        try{
                List<dmpl__Resource__c> salesPersons = BulkOrderProcessingController.fetchSalesPerson('Nonexistent', 'somePartnerAccountId', 'someBranchId'); 
        }
       catch(exception e){ 
            
        }
        Test.stopTest();
    }
    
   
      @isTest
    public static void testVisitRouteUpdate(){
        List<dmpl__VisitRoute__c> route1=[select Id,dmpl__DayNumbers__c,dmpl__MondayAvailable__c,dmpl__TuesdayAvailable__c,dmpl__WednesdayAvailable__c,dmpl__FridayAvailable__c,dmpl__ThursdayAvailable__c,dmpl__SaturdayAvailable__c,dmpl__SundayAvailable__c from dmpl__VisitRoute__c limit 1];
        Test.startTest();
        route1[0].dmpl__DayNumbers__c='2';
        update route1;
        VisitRouteService.syncDayNumbers(route1);
        
        try{
            BulkOrderProcessingController.getLineRelatedRecords('','',true,'','',new list<string>(),new list<string>(),new list<string>{string.valueof(route1[0].id)},new list< string>());
            List<dmpl__VisitRoute__c> vc =BulkOrderProcessingController.fetchVisitRoute('','','',new list<Id>{});
      
      
        }
        catch(exception e){
            
        }
        VisitRouteService.syncUpdateDayNumbers(route1,route1);
        Test.stopTest();
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

	private static void CreateItemLot()
    {
        List<dmpl__ItemLot__c> itemLot = new List<dmpl__ItemLot__c>();
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        dmpl__ItemLotType__c itemLot1 = TestDataHelpers.createItemLotType(item);
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        dmpl__SKU__c sku = [Select Id, Name from dmpl__SKU__c LIMIT 1];
        itemLot.Add(new dmpl__ItemLot__c(dmpl__BranchId__c = branch.Id,
                                         dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                         dmpl__ItemId__c = item.Id,
                                         dmpl__SKUId__c = sku.Id,
                                         dmpl__BatchNo__c = '12345',
										 dmpl__SerialNumber__c = 'BBBC',
                                         dmpl__SupplierInvoiceNumber__c = '74985',
                                         dmpl__DateOfReceipt__c = date.today(),
                                         dmpl__DateOfMfg__c = date.today(),
                                         dmpl__TotalCost__c = 100,
                                         dmpl__DateOfSupplierInvoice__c = date.today(),
                                         dmpl__Cost__c = 100,
                                         dmpl__ItemLotTypeId__c = itemLot1.Id,
										 dmpl__HoldCode__c = null
                                         //dmpl__QuantityExpired__c = 1,
                                         //dmpl__QuantityOnHold__c = 1,
                                         //dmpl__QuantityOnLoan__c = 1
                                        ));
        insert itemLot;
        
        List<dmpl__ItemLot__c> relatedItemLot = new List<dmpl__ItemLot__c>();
        relatedItemLot.Add(new dmpl__ItemLot__c(dmpl__LandedCost__c = 1000,
                                               dmpl__BranchId__c = branch.Id,
            dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c));
        insert relatedItemLot;
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


    private static void CreateSaleOrder()
    {
        List<dmpl__SaleOrder__c> saleOrder = new List<dmpl__SaleOrder__c>();
        Account customerAccount = [Select Id,Name From Account WHERE dmpl__IsCustomerAccount__c = True LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c LIMIT 1];
        //dmpl__ContactAddress__c contactAddress = [Select Id,Name,dmpl__AccountId__c From dmpl__ContactAddress__c LIMIT 1];
        //dmpl__Resource__c resource = [Select Id,Name,dmpl__IsActive__c From dmpl__Resource__c WHERE dmpl__IsActive__c = true LIMIT 1];
        saleOrder.Add(new dmpl__SaleOrder__c(dmpl__AccountId__c = customerAccount.Id,
                                             dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                             dmpl__BranchId__c = branch.Id,
                                             dmpl__DocumentDate__c = Date.today(),
                                             dmpl__Status__c = 'Draft',
                                             //dmpl__BillingAddressId__c = contactAddress.Id,
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

    
    private static void CreateAccountGroup()
    {
        dmpl__AccountGroup__c priceAccountGroup= new dmpl__AccountGroup__c (Name= 'Test-AccountGroup', 
                                                                            dmpl__AccountGroupType__c='Price');
        insert priceAccountGroup;
        
        dmpl__AccountGroup__c schemeAccountGroup= new dmpl__AccountGroup__c (Name= 'Test-AccountGroup1', 
                                                                             dmpl__AccountGroupType__c='Scheme');
        insert schemeAccountGroup;
        
        dmpl__AccountGroup__c discountAccountGroup= new dmpl__AccountGroup__c (Name= 'Test-AccountGroup2', 
                                                                               dmpl__AccountGroupType__c='Discount');
        insert discountAccountGroup;        
        
        dmpl__AccountGroup__c itemFeatureAccountGroup= new dmpl__AccountGroup__c (Name= 'Test-AccountGroup3', 
                                                                                  dmpl__AccountGroupType__c='Item Feature');
        insert itemFeatureAccountGroup;        
        
        List<Account> account = new List<Account>();
        account.add(new Account(Name = 'lastName1',
                                dmpl__LastName__c = 'Service Estimate',
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
                                dmpl__CustomerPriceAccountGroupId__c = priceAccountGroup.Id,
                                dmpl__CustomerDiscountAccountGroupId__c = discountAccountGroup.Id,
                                dmpl__PartnerSchemeAccountGroupId__c = schemeAccountGroup.Id,                                
                                dmpl__PartnerPriceAccountGroupId__c = priceAccountGroup.Id,
                                dmpl__PartnerDiscountAccountGroupId__c = discountAccountGroup.Id,
                                dmpl__CustomerSchemeAccountGroupId__c = schemeAccountGroup.Id));
        insert account; 
        Account supplieraccount = new Account(Name = 'Supplier-Test-Account',dmpl__IsSupplierAccount__c = True,dmpl__LastName__c = 'Account', dmpl__IsActive__c = true);
        insert supplieraccount;
        Account partnerAccount = new Account(Name = 'Partner-Test-Account',
                                             dmpl__LastName__c = 'Service Estimate',
                                             dmpl__IsPartnerAccount__c = True,
                                             dmpl__PartnerSchemeAccountGroupId__c = schemeAccountGroup.Id,                                
                                             dmpl__PartnerPriceAccountGroupId__c = priceAccountGroup.Id,
                                             dmpl__PartnerDiscountAccountGroupId__c = discountAccountGroup.Id,
                                             dmpl__IsActive__c = true);
        insert partneraccount;
        
        Account  customerAccount = new Account(Name = 'Customer-Test-Account',
                                               dmpl__LastName__c = 'Service Estimate',
                                               dmpl__IsCustomerAccount__c = True,
                                               dmpl__BillingPostalCode__c ='123456',
                                               dmpl__BillingCity__c='Chandigarh',
                                               dmpl__BillingState__c='Punjab',
                                               dmpl__CustomerPriceAccountGroupId__c = priceAccountGroup.Id,
                                               dmpl__CustomerDiscountAccountGroupId__c = discountAccountGroup.Id,
                                               dmpl__CustomerSchemeAccountGroupId__c = schemeAccountGroup.Id,
                                               dmpl__IsActive__c = true);
        insert customerAccount;
        
        dmpl__AccountGroupMember__c partnerAccountGroupMember = new dmpl__AccountGroupMember__c
            (dmpl__AccountGroupId__c=discountAccountGroup.Id,
             dmpl__AccountId__c=partnerAccount.Id
            );
        Insert partnerAccountGroupMember;
        
        dmpl__AccountGroupMember__c customerAccountGroupMember = new dmpl__AccountGroupMember__c
            (dmpl__AccountGroupId__c=discountAccountGroup.Id,
             dmpl__AccountId__c=customerAccount.Id
            );
        Insert customerAccountGroupMember;
        
        
    }
    
    private static void CreateBranch()
    {
        List<dmpl__Branch__c> branches = new List<dmpl__Branch__c>();
        Account partnerAccount = [Select Id,Name From Account WHERE Name = 'Partner-Test-Account' LIMIT 1];
        branches.Add(new dmpl__Branch__c(dmpl__PartnerAccountId__c =partnerAccount.Id,
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
        insert branches;
    }
    
    private static void CreateResource()
    {
        List<dmpl__Resource__c> resource = new List<dmpl__Resource__c>();
        Account partnerAccount = [Select Id,Name From Account WHERE Name = 'Partner-Test-Account' LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name From dmpl__Branch__c WHERE Name = 'Test-Branch' LIMIT 1];
        resource.add(new dmpl__Resource__c(Name = 'Test - Resource',
                                           dmpl__Type__c = 'None',
                                           dmpl__IsActive__c = true,
                                           dmpl__Phone__c = '9999999999',
                                           dmpl__DefaultPartnerAccountId__c = partnerAccount.Id,
                                           dmpl__DefaultBranchId__c = branch.Id,
                                           dmpl__UserId__c = userInfo.getUserId()));
        insert resource;
        
    }
    
    private static void CreateSaleInvoice()
    {
        Account account = [SELECT Id FROM Account WHERE Name = 'Customer-Test-Account' LIMIT 1];
        Account partner = [SELECT Id FROM Account WHERE Name = 'Partner-Test-Account' LIMIT 1];
        dmpl__Branch__c branch = [SELECT Id FROM dmpl__Branch__c LIMIT 1];
        
        List<dmpl__SaleInvoice__c> saleInvoice = new List<dmpl__SaleInvoice__c>();
        saleInvoice.add(new dmpl__SaleInvoice__c(dmpl__AccountId__c = account.Id,
                                                 dmpl__PartnerAccountId__c = partner.Id,
                                                 dmpl__BranchId__c = branch.Id,
                                                 dmpl__Status__c = 'Draft',
                                                 dmpl__DocumentDate__c = Date.today()));
        insert saleInvoice;
    }
    
    private static void CreateFieldSales(){
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c limit 1];
        dmpl__Resource__c resource=[Select Id from dmpl__Resource__c limit 1];
        List<dmpl__FieldSales__c> fieldSales=new List<dmpl__FieldSales__c>();
        fieldSales.add(new dmpl__FieldSales__c(dmpl__BranchId__c=branch.Id,
                                               dmpl__Type__c = 'Van Delivery',
                                               dmpl__PartnerAccountId__c=branch.dmpl__PartnerAccountId__c,
                                               dmpl__ResourceId__c=resource.Id,
                                               dmpl__PerformReleaseUnload__c=false,
                                               dmpl__PerformReleaseLoad__c=false,
                                               dmpl__PerformReleaseVisitPlan__c=false,
                                               dmpl__IsLoadReleased__c=false,
                                               dmpl__DocumentDate__c=system.Today()));
        insert fieldSales;
    }
    
    private static void CreateFieldSalesInvoice(){
        List<dmpl__FieldSalesInvoice__c> fieldSalesInvoice=new List<dmpl__FieldSalesInvoice__c>();
        Account partnerAccount = [Select Id,Name From Account WHERE Name = 'Partner-Test-Account' LIMIT 1];
        dmpl__FieldSales__c fieldSales=[SELECT Id FROM dmpl__FieldSales__c LIMIT 1];
        fieldSalesInvoice.add(new dmpl__FieldSalesInvoice__c(dmpl__AccountId__c  = partnerAccount.Id,
                                                             dmpl__FieldSalesId__c  = fieldSales.Id
                                                            ));
        insert fieldSalesInvoice;
    }    
    
    private static void CreateVisitRoutes()
    {
        List<dmpl__VisitRoute__c> routes = new List<dmpl__VisitRoute__c>();
        dmpl__AccountGroup__c actGroup = [Select Id,Name From dmpl__AccountGroup__c LIMIT 1];
        Account act = [Select Id,Name From Account WHERE dmpl__IsPartnerAccount__c = True LIMIT 1];
        routes.add(New dmpl__VisitRoute__c(dmpl__PartnerAccountId__c = act.Id,
                                           dmpl__AccountGroupId__c = actGroup.Id,
                                           dmpl__CoverageMidpointDistance__c = 10,
                                           dmpl__IsActive__c = true,
                                           dmpl__MondayAvailable__c=true,
                                           dmpl__VisitPurpose__c = 'Order Capture',
                                           dmpl__RoutingPriority__c = 'Shortest Distance'
                                          ));
         routes.add(New dmpl__VisitRoute__c(dmpl__PartnerAccountId__c = act.Id,
                                           dmpl__AccountGroupId__c = actGroup.Id,
                                           dmpl__CoverageMidpointDistance__c = 10,
                                           dmpl__IsActive__c = true,
                                           dmpl__TuesdayAvailable__c=true,
                                           dmpl__VisitPurpose__c = 'Order Capture',
                                           dmpl__RoutingPriority__c = 'Shortest Distance'
                                          ));
         routes.add(New dmpl__VisitRoute__c(dmpl__PartnerAccountId__c = act.Id,
                                           dmpl__AccountGroupId__c = actGroup.Id,
                                           dmpl__CoverageMidpointDistance__c = 10,
                                           dmpl__IsActive__c = true,
                                           dmpl__WednesdayAvailable__c=true,
                                           dmpl__VisitPurpose__c = 'Order Capture',
                                           dmpl__RoutingPriority__c = 'Shortest Distance'
                                          ));
         routes.add(New dmpl__VisitRoute__c(dmpl__PartnerAccountId__c = act.Id,
                                           dmpl__AccountGroupId__c = actGroup.Id,
                                           dmpl__CoverageMidpointDistance__c = 10,
                                           dmpl__IsActive__c = true,
                                           dmpl__FridayAvailable__c=true,
                                           dmpl__VisitPurpose__c = 'Order Capture',
                                           dmpl__RoutingPriority__c = 'Shortest Distance'
                                          ));
           routes.add(New dmpl__VisitRoute__c(dmpl__PartnerAccountId__c = act.Id,
                                           dmpl__AccountGroupId__c = actGroup.Id,
                                           dmpl__CoverageMidpointDistance__c = 10,
                                           dmpl__IsActive__c = true,
                                           dmpl__SaturdayAvailable__c=true,
                                           dmpl__VisitPurpose__c = 'Order Capture',
                                           dmpl__RoutingPriority__c = 'Shortest Distance'
                                          ));
           routes.add(New dmpl__VisitRoute__c(dmpl__PartnerAccountId__c = act.Id,
                                           dmpl__AccountGroupId__c = actGroup.Id,
                                           dmpl__CoverageMidpointDistance__c = 10,
                                           dmpl__IsActive__c = true,
                                           dmpl__SundayAvailable__c=true,
                                           dmpl__VisitPurpose__c = 'Order Capture',
                                           dmpl__RoutingPriority__c = 'Shortest Distance'
                                          ));
           routes.add(New dmpl__VisitRoute__c(dmpl__PartnerAccountId__c = act.Id,
                                           dmpl__AccountGroupId__c = actGroup.Id,
                                           dmpl__CoverageMidpointDistance__c = 10,
                                           dmpl__IsActive__c = true,
                                           dmpl__ThursdayAvailable__c=true,
                                           dmpl__VisitPurpose__c = 'Order Capture',
                                           dmpl__RoutingPriority__c = 'Shortest Distance'
                                          ));
        insert routes;
    }
    
    private static void CreateVisitRouteStop()
    {
        List<dmpl__VisitRouteStop__c> routeStop = new List<dmpl__VisitRouteStop__c>();
        Account act = [Select Id,Name From Account WHERE dmpl__IsCustomerAccount__c = True LIMIT 1];
        dmpl__VisitRoute__c route = [Select Id,name from dmpl__VisitRoute__c LIMIT 1];
        routeStop.add(new dmpl__VisitRouteStop__c(dmpl__AllowedGeofencingTolerance__c = 10,
                                                  dmpl__AccountId__c = act.Id,
                                                  dmpl__StartTime__c = time.newInstance(5, 20, 30, 60),
                                                  dmpl__EndTime__c = time.newInstance(25, 10, 50, 10),
                                                  dmpl__VisitPurpose__c = 'Order Capture',
                                                  dmpl__VisitRouteId__c = route.Id,
                                                  dmpl__SequenceNumber__c = 1
                                                 ));
        insert routeStop;
    }
    
    private static void CreateVisitPlans()
    {
        List<dmpl__VisitPlan__c> plans = new List<dmpl__VisitPlan__c>();
        dmpl__VisitRoute__c route = [Select Id,name from dmpl__VisitRoute__c LIMIT 1];
        Account act = [Select Id,Name From Account WHERE dmpl__IsPartnerAccount__c = True LIMIT 1];
        plans.add(new dmpl__VisitPlan__c(dmpl__PartnerAccountId__c = act.Id,
                                         dmpl__Status__c = 'Task',
                                         dmpl__VisitPurpose__c = 'Order Capture',
                                         dmpl__VisitRouteId__c = route.Id
                                        ));
        insert plans;
    }
}