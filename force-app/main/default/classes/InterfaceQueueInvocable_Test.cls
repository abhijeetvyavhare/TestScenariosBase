@IsTest
public class InterfaceQueueInvocable_Test {
    
    @testSetup
    public static void setup() {
        CreateAccountGroup();
        CreateAccount();
        CreateBranch();
        CreateAccountGroupRule();
        CreateInterfaceServiceProvider();
        CreateInterfaceServiceProviderRequest();
        CreateInterfaceQueue();
    }
    
    @IsTest
    static void testExecuteActionSuccess() {
        dmpl__InterfaceQueue__c testQueue = [SELECT Id FROM dmpl__InterfaceQueue__c LIMIT 1];
        
        InterfaceQueueInvocable.ExecuteQueueActionRequest request = new InterfaceQueueInvocable.ExecuteQueueActionRequest();
        request.queueId = testQueue.Id;
        
        Test.startTest();
        List<InterfaceQueueInvocable.ExecuteQueueActionResult> results = InterfaceQueueInvocable.executeAction(new List<InterfaceQueueInvocable.ExecuteQueueActionRequest>{request});
        Test.stopTest();
        
        System.assertEquals(1, results.size(), 'There should be one result.');
        System.assertEquals(testQueue.Id, results[0].input.queueId, 'Queue ID should match.');
      
    }
    
    @IsTest
    static void testExecuteActionFailure() {
        InterfaceQueueInvocable.ExecuteQueueActionRequest request = new InterfaceQueueInvocable.ExecuteQueueActionRequest();
        
        Test.startTest();
        List<InterfaceQueueInvocable.ExecuteQueueActionResult> results = InterfaceQueueInvocable.executeAction(new List<InterfaceQueueInvocable.ExecuteQueueActionRequest>{request});
        Test.stopTest();
        
        System.assertEquals(1, results.size(), 'There should be one result.');
       
    }
    
    @IsTest
    static void testExecuteActionExceptionHandling() {
        dmpl__InterfaceQueue__c testQueue = [SELECT Id FROM dmpl__InterfaceQueue__c LIMIT 1];
        
        Test.startTest();
        InterfaceQueueInvocable.ExecuteQueueActionRequest request = new InterfaceQueueInvocable.ExecuteQueueActionRequest();
        request.queueId = testQueue.Id;
        List<InterfaceQueueInvocable.ExecuteQueueActionResult> results = InterfaceQueueInvocable.executeAction(new List<InterfaceQueueInvocable.ExecuteQueueActionRequest>{request});
        Test.stopTest();
        
        System.assertEquals(1, results.size(), 'There should be one result.');
     
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
        
        dmpl__ItemGroup__c itemGroup= new dmpl__ItemGroup__c (Name= 'Test-AccountGroup', 
                                                                       dmpl__ItemGroupType__c='Scheme',
                                                                       dmpl__DynamicMemberType__c = 'Report Data',
                                                                       dmpl__ReportId__c = 'flow_screen_prebuilt_report',
                                                                       dmpl__RuleSuccessCriteria__c = 'Custom Logic Is Met',
                                                                       dmpl__RuleSuccessCustomLogic__c = 'Test'
                                                                      );
        insert itemGroup;
        
        List<dmpl__Item__c> productItem = new List<dmpl__Item__c>();
        productItem.Add(new dmpl__Item__c(Name = 'Test-Item',
                                          dmpl__ItemCode__c = 'DMPL',
                                          dmpl__ItemType__c = 'Product',
                                          dmpl__ItemSubType__c = '',
                                          dmpl__SchemeItemGroupId__c=itemGroup.Id,
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
    }
    
    public static void CreateAccountGroup2()
    {
        dmpl__AccountGroup__c accountGroup1= new dmpl__AccountGroup__c (Name= 'Test-AccountGroup', 
                                                                       dmpl__AccountGroupType__c='Scheme',
                                                                       dmpl__DynamicMemberType__c = 'Report Data',
                                                                       dmpl__ReportId__c = 'flow_screen_prebuilt_report',
                                                                       dmpl__RuleSuccessCriteria__c = 'All Rules Are Met',
                                                                       dmpl__RuleSuccessCustomLogic__c = 'Test'
                                                                      );
        insert accountGroup1;
        
        dmpl__AccountGroup__c accountGroup2= new dmpl__AccountGroup__c (Name= 'Test-AccountGroup', 
                                                                       dmpl__AccountGroupType__c='Scheme',
                                                                       dmpl__DynamicMemberType__c = 'Report Data',
                                                                       dmpl__ReportId__c = 'flow_screen_prebuilt_report',
                                                                       dmpl__RuleSuccessCriteria__c = 'Any Rule Is Met',
                                                                       dmpl__RuleSuccessCustomLogic__c = 'Test'
                                                                      );
        insert accountGroup2;
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
    
    private static void CreateAccountGroupRule()
    {
        List<dmpl__AccountGroupRule__c> accountGroupRule = new List<dmpl__AccountGroupRule__c>();
        dmpl__AccountGroup__c accountGroup = [Select Id,Name From dmpl__AccountGroup__c WHERE Name = 'Test-AccountGroup' LIMIT 1];
        accountGroupRule.Add(new dmpl__AccountGroupRule__c(dmpl__AccountGroupId__c =accountGroup.Id,
                                                           dmpl__SequenceNumber__c = 10,
                                                           dmpl__Operation__c='equals'
                                                          ));
        insert accountGroupRule;
        
        List<dmpl__AccountGroupMember__c> accountGroupMember = new List<dmpl__AccountGroupMember__c>();
        accountGroupMember.add(new dmpl__AccountGroupMember__c(
        dmpl__AccountGroupId__c = accountGroup.Id,
        dmpl__BatchInstanceId__c = 'TestBatchId123'));
        insert accountGroupMember;
        
        List<dmpl__ItemGroupRule__c> itemGroupRule = new List<dmpl__ItemGroupRule__c>();
        dmpl__ItemGroup__c itemGroup = [Select Id,Name From dmpl__ItemGroup__c WHERE Name = 'Test-AccountGroup' LIMIT 1];
        itemGroupRule.Add(new dmpl__ItemGroupRule__c(dmpl__ItemGroupId__c =itemGroup.Id,
                                                           dmpl__SequenceNumber__c = 10
                                                          ));
        insert itemGroupRule;
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

   
}



/*@IsTest
public class InterfaceQueueInvocable_Test {
	
    @testSetup
    public static void Setup()
    {
        //System.runAs(PostInstallHelper.AssignAdministratorAllPermissions(UserInfo.getUserId())){
            CreateAccountGroup();
        	CreateAccount();
        	CreateBranch();
            CreateAccountGroupRule();
        	CreateInterfaceServiceProvider();
        	CreateInterfaceServiceProviderRequest();
            CreateInterfaceQueue();
        //}
    }
    
    @IsTest
    static void queryInterfaceQueueTest() {
        
      	dmpl__InterfaceQueue__c queue =[Select Id, Name,dmpl__AttemptCount__c,dmpl__SchedulableJobName__c,dmpl__CronExpression__c from dmpl__InterfaceQueue__c Limit 1];
       	Test.startTest();
        dmpl__InterfaceQueue__c result = InterfaceQueueInvocable.queryInterfaceQueue(queue.Id);
        System.assertEquals(result.Id, queue.Id, 'No same Queues');
        Test.stopTest();

    }
    
    @IsTest
    private static void executeActionInternalTest() {
        	CreateInterfaceQueue();
 			dmpl__InterfaceQueue__c queue =[Select Id, Name,dmpl__AttemptCount__c,dmpl__SchedulableJobName__c,dmpl__CronExpression__c from dmpl__InterfaceQueue__c Limit 1];
			Test.startTest();
          	InterfaceQueueInvocable.ExecuteQueueActionRequest queqeAction = new InterfaceQueueInvocable.ExecuteQueueActionRequest();
        	InterfaceQueueInvocable.executeActionInternal(queqeAction);
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
        
        dmpl__ItemGroup__c itemGroup= new dmpl__ItemGroup__c (Name= 'Test-AccountGroup', 
                                                                       dmpl__ItemGroupType__c='Scheme',
                                                                       dmpl__DynamicMemberType__c = 'Report Data',
                                                                       dmpl__ReportId__c = 'flow_screen_prebuilt_report',
                                                                       dmpl__RuleSuccessCriteria__c = 'Custom Logic Is Met',
                                                                       dmpl__RuleSuccessCustomLogic__c = 'Test'
                                                                      );
        insert itemGroup;
        
        List<dmpl__Item__c> productItem = new List<dmpl__Item__c>();
        productItem.Add(new dmpl__Item__c(Name = 'Test-Item',
                                          dmpl__ItemCode__c = 'DMPL',
                                          dmpl__ItemType__c = 'Product',
                                          dmpl__ItemSubType__c = '',
                                          dmpl__SchemeItemGroupId__c=itemGroup.Id,
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
    }
    
    public static void CreateAccountGroup2()
    {
        dmpl__AccountGroup__c accountGroup1= new dmpl__AccountGroup__c (Name= 'Test-AccountGroup', 
                                                                       dmpl__AccountGroupType__c='Scheme',
                                                                       dmpl__DynamicMemberType__c = 'Report Data',
                                                                       dmpl__ReportId__c = 'flow_screen_prebuilt_report',
                                                                       dmpl__RuleSuccessCriteria__c = 'All Rules Are Met',
                                                                       dmpl__RuleSuccessCustomLogic__c = 'Test'
                                                                      );
        insert accountGroup1;
        
        dmpl__AccountGroup__c accountGroup2= new dmpl__AccountGroup__c (Name= 'Test-AccountGroup', 
                                                                       dmpl__AccountGroupType__c='Scheme',
                                                                       dmpl__DynamicMemberType__c = 'Report Data',
                                                                       dmpl__ReportId__c = 'flow_screen_prebuilt_report',
                                                                       dmpl__RuleSuccessCriteria__c = 'Any Rule Is Met',
                                                                       dmpl__RuleSuccessCustomLogic__c = 'Test'
                                                                      );
        insert accountGroup2;
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
    
    private static void CreateAccountGroupRule()
    {
        List<dmpl__AccountGroupRule__c> accountGroupRule = new List<dmpl__AccountGroupRule__c>();
        dmpl__AccountGroup__c accountGroup = [Select Id,Name From dmpl__AccountGroup__c WHERE Name = 'Test-AccountGroup' LIMIT 1];
        accountGroupRule.Add(new dmpl__AccountGroupRule__c(dmpl__AccountGroupId__c =accountGroup.Id,
                                                           dmpl__SequenceNumber__c = 10,
                                                           dmpl__Operation__c='equals'
                                                          ));
        insert accountGroupRule;
        
        List<dmpl__AccountGroupMember__c> accountGroupMember = new List<dmpl__AccountGroupMember__c>();
        accountGroupMember.add(new dmpl__AccountGroupMember__c(
        dmpl__AccountGroupId__c = accountGroup.Id,
        dmpl__BatchInstanceId__c = 'TestBatchId123'));
        insert accountGroupMember;
        
        List<dmpl__ItemGroupRule__c> itemGroupRule = new List<dmpl__ItemGroupRule__c>();
        dmpl__ItemGroup__c itemGroup = [Select Id,Name From dmpl__ItemGroup__c WHERE Name = 'Test-AccountGroup' LIMIT 1];
        itemGroupRule.Add(new dmpl__ItemGroupRule__c(dmpl__ItemGroupId__c =itemGroup.Id,
                                                           dmpl__SequenceNumber__c = 10
                                                          ));
        insert itemGroupRule;
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
}
*/