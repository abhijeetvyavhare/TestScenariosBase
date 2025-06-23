@isTest
public class VisitRouteSearchController_Test {
    @testSetup
    public static void Setup()
    {
        CreateAccountGroup();
        CreateBranch();       
        CreateResource();
        CreateSaleInvoice();
        CreateFieldSales();
        CreateFieldSalesInvoice();
        CreateVisitRoutes();
        CreateVisitRouteStop();
        CreateVisitPlans();
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
        set<Id> accountIds = new set<Id>(accIds);
        Set<Id> routeStops1=new Set<Id>(routeStops);
        VisitRouteSearchController.queryAccounts(accIds,'123456','Chandigarh','Punjab');
        VisitRouteSearchController.getFieldSalesType(fieldSales);
        VisitRouteSearchController.getFieldSalesDocuments(fieldSales);
        VisitRouteSearchController.getSaleInvoices(accountIds,routeStops,'123456','Chandigarh','Punjab',date.today(),date.today());
        VisitRouteSearchController.getOutletsForVisitPlan(fieldSales,accountIds,routeStops,'123456','Chandigarh','Punjab',date.today(),date.today());
        VisitRouteSearchController.getOutletsForFieldSales(fieldSales,accountIds,routeStops,'123456','Chandigarh','Punjab','',date.today(),null);
        VisitRouteSearchController.getAllRelatedVisitRoutes('dmpl__FieldSales__c',fieldSales);
        VisitRouteSearchController.createFieldSalesInvoice(accIds,fieldSales,routeStops,new List<String>{invoiceNumbers});
        VisitRouteSearchController.getAccounts(fieldSales,'dmpl__FieldSales__c',routeStops,'123456','Chandigarh','Punjab',groups,date.today(),date.today());
    }
    @isTest
    public static void testVisitRoute(){
        List<dmpl__VisitRoute__c> route1=[select Id,dmpl__DayNumbers__c,dmpl__MondayAvailable__c,dmpl__TuesdayAvailable__c,dmpl__WednesdayAvailable__c,dmpl__FridayAvailable__c,dmpl__ThursdayAvailable__c,dmpl__SaturdayAvailable__c,dmpl__SundayAvailable__c from dmpl__VisitRoute__c limit 1];
        Test.startTest();
        VisitRouteService.syncDayNumbers(route1);
        VisitRouteService.syncUpdateDayNumbers(route1,route1);
        Test.stopTest();
    }
      @isTest
    public static void testVisitRouteUpdate(){
        List<dmpl__VisitRoute__c> route1=[select Id,dmpl__DayNumbers__c,dmpl__MondayAvailable__c,dmpl__TuesdayAvailable__c,dmpl__WednesdayAvailable__c,dmpl__FridayAvailable__c,dmpl__ThursdayAvailable__c,dmpl__SaturdayAvailable__c,dmpl__SundayAvailable__c from dmpl__VisitRoute__c limit 1];
        Test.startTest();
        route1[0].dmpl__DayNumbers__c='2';
        update route1;
        VisitRouteService.syncDayNumbers(route1);
        VisitRouteService.syncUpdateDayNumbers(route1,route1);
        Test.stopTest();
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