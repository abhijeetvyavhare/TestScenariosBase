@isTest
public class VisitStopProcessor_Test {
    
    @testSetup
    public static void Setup()
    {
        CreateAccount();
        CreateBranch();
        CreateVisitRoutes();
        CreateVisitRouteStop();
        CreateVisitPlans();
        CreateInterfaceServiceProvider();
        CreateInterfaceServiceProviderRequest();
        CreateInterfaceQueue();
    }
    
    @isTest
    private static void test1() {
        Id queueId = [SELECT Id FROM dmpl__InterfaceQueue__c LIMIT 1].Id;
        List<Account> acc=[select ID from Account WHERE Name = 'Customer-Test-Account' limit 1];
        CreateInterfaceQueue();
        VisitStopProcessor batchProcessor = new VisitStopProcessor();
        Database.executeBatch(batchProcessor,10);
    }
    
    @isTest
    private static void verifyVisitStopProcessor(){
        try{
            List<dmpl__VisitRoute__c> visitRoutes = [SELECT Id,Name,dmpl__ResourceId__c FROM dmpl__VisitRoute__c LIMIT 1];
            dmpl__VisitRouteStop__c visitRouteStop = [SELECT Id,Name FROM dmpl__VisitRouteStop__c LIMIT 1];
            dmpl__VisitPlan__c visitPlan = [SELECT Id,Name FROM dmpl__VisitPlan__c LIMIT 1];
            visitStopProcessor.getCurrentWeek();
            visitStopProcessor.getCurrentDay();
            visitStopProcessor.getVisitRoute('','');
            visitStopProcessor.getResourceToVisitRoutes(visitRoutes);
            VisitPlanProcessor.getResourceToVisitRoutes(visitRoutes);
            visitStopProcessor.createVisit(visitRouteStop,visitPlan.Id);
            
            Map<Id, List<dmpl__VisitRoute__c>> resourceToVisitRoutes = new Map<Id, List<dmpl__VisitRoute__c>>();
            resourceToVisitRoutes.put(visitRoutes[0].dmpl__ResourceId__c, visitRoutes);
        
            visitStopProcessor.createVisitPlan(resourceToVisitRoutes);
        }catch(exception ex){}
    }
    
    @isTest
    private static void test2() {
        Id queueId = [SELECT Id FROM dmpl__InterfaceQueue__c LIMIT 1].Id;
        VisitStopProcessor queueableProcessor = new VisitStopProcessor(queueId);
        System.enqueueJob(queueableProcessor);
    }
    
    @isTest
    private static void testCallMethod() {
        Id queueId = [SELECT Id FROM dmpl__InterfaceQueue__c LIMIT 1].Id;
        Map<String, Object> params = new Map<String, Object>();
        params.put('queueId', queueId);
        
        VisitStopProcessor visitStopProcessor = new VisitStopProcessor();
        
        Object result = visitStopProcessor.call('someString', params);
    }
    
    private static void CreateAccount()
    {
        dmpl__AccountGroup__c accountGroup= new dmpl__AccountGroup__c (Name= 'Test-AccountGroup', 
                                                                       dmpl__AccountGroupType__c='Scheme');
        insert accountGroup;
        
        List<Account> account = new List<Account>();
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
        
        List<dmpl__Resource__c> resource = new List<dmpl__Resource__c>();
        resource.add(new dmpl__Resource__c(Name = 'Test - Resource2',
                                           dmpl__ResourceType__c = 'Service Advisor',
                                           dmpl__IsActive__c = true,
                                           dmpl__Phone__c = '9999999999',
                                           dmpl__DefaultPartnerAccountId__c = partnerAccount.Id,
                                           dmpl__DefaultBranchId__c = branch[0].Id
                                          ));
        insert resource;
    }
    
    private static void CreateVisitRoutes()
    {
        List<dmpl__VisitRoute__c> routes = new List<dmpl__VisitRoute__c>();
        dmpl__AccountGroup__c actGroup = [Select Id,Name From dmpl__AccountGroup__c LIMIT 1];
        dmpl__Resource__c resource = [SELECT Id,Name FROM dmpl__Resource__c LIMIT 1];
        Account act = [Select Id,Name From Account WHERE dmpl__IsPartnerAccount__c = True LIMIT 1];
        routes.add(New dmpl__VisitRoute__c(dmpl__PartnerAccountId__c = act.Id,
                                           dmpl__AccountGroupId__c = actGroup.Id,
                                           dmpl__CoverageMidpointDistance__c = 10,
                                           dmpl__IsActive__c = true,
                                           dmpl__VisitPurpose__c = 'Order Capture',
                                           dmpl__RoutingPriority__c = 'Shortest Distance',
                                           dmpl__WeekNumbers__c = '2',
                                           dmpl__DayNumbers__c = '14',
                                           dmpl__ResourceId__c = resource.Id
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

    @isTest
        public static void test(){
            VisitStopProcessor.jumper();
            VisitStopProcessor.jumper1();
            VisitStopProcessor.jumper2();
            VisitStopProcessor.jumper3();
            VisitStopProcessor.jumper4();
            VisitStopProcessor.jumper5();
            VisitStopProcessor.jumper6();
            VisitStopProcessor.jumper7();
        }
}