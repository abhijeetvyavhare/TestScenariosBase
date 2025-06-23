@isTest
public class FileClient_Test {
	
    @testSetup
    public static void Setup()
    {
        CreateAccountGroup();
        CreateAccount();
        CreateBranch();
        CreateInterfaceServiceProvider();
        CreateInterfaceServiceProviderRequest();
    }
    
    @isTest
    public static void verifyFileClient()
    {
        
        test.startTest();
        Account act = [Select Id,Name From Account LIMIT 1];
        dmpl__InterfaceServiceProviderRequest__c req = [Select Id,Name From dmpl__InterfaceServiceProviderRequest__c LIMIT 1];
        dmpl__InterfaceServiceProvider__c provider = [Select Id,Name,dmpl__Logging__c,dmpl__BranchId__c,(Select Id,Name,dmpl__LastExtractionTimestamp__c,dmpl__FileName__c,dmpl__FileTitle__c,dmpl__Function__c,dmpl__CustomFunction__c,dmpl__PayloadSchema__c,dmpl__SourceDataType__c,dmpl__RequestSOQL__c From dmpl__InterfaceServiceProviderRequests__r),dmpl__PartnerAccountId__c From dmpl__InterfaceServiceProvider__c LIMIT 1];
        FileClient client = new FileClient(provider);
       // client.startRequest('Custom Function',act.Id);
        client.startRequest('Custom Function','TEXT1',act.Id);
        client.startRequest(req.Id,act.Id);
        client.startRequest(req.Id,act.Id,'');
        client.startRequest(provider.dmpl__InterfaceServiceProviderRequests__r,req.Id);
        client.startRequest(provider.dmpl__InterfaceServiceProviderRequests__r,req.Id,'');
        client.getPayloadDataSource(provider.dmpl__InterfaceServiceProviderRequests__r,req.Id);
        client.executeRequestSOQL(provider.dmpl__InterfaceServiceProviderRequests__r,req.Id);
        client.executeRequestSOQL(provider.dmpl__InterfaceServiceProviderRequests__r,dateTime.now());
        test.stopTest();
        //}catch(exception e){}
    }
    
    @isTest
      public static void verifyFileClient1()
    {
        
        test.startTest();
        Account act = [Select Id,Name From Account LIMIT 1];
        dmpl__InterfaceServiceProviderRequest__c req = [Select Id,Name From dmpl__InterfaceServiceProviderRequest__c LIMIT 1];
        dmpl__InterfaceServiceProvider__c provider = [Select Id,Name,dmpl__Logging__c,dmpl__BranchId__c,(Select Id,Name,dmpl__LastExtractionTimestamp__c,dmpl__FileName__c,dmpl__FileTitle__c,dmpl__Function__c,dmpl__CustomFunction__c,dmpl__PayloadSchema__c,dmpl__SourceDataType__c,dmpl__RequestSOQL__c From dmpl__InterfaceServiceProviderRequests__r),dmpl__PartnerAccountId__c From dmpl__InterfaceServiceProvider__c LIMIT 1];
        FileClient client1 = new FileClient(provider,req.Id);
        //client1.startRequest('Request',req.Id);
        test.stopTest();
        //}catch(exception e){}
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
    
    private static void CreateAccount()
    {
        List<Account> account = new List<Account>();
        dmpl__AccountGroup__c accountGroup = [Select Id,Name From dmpl__AccountGroup__c LIMIT 1];
        account.add(new Account(Name = 'Test - Account', 
            					Fax = '09876',
                               dmpl__LastName__c = 'Cycle Count',
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
                                             dmpl__IsPartnerAccount__c = True, 
                                             dmpl__LastName__c = 'Cycle Count',
                                             dmpl__IsActive__c = true);
        insert partneraccount;
        
        Account customerAccount = new Account(Name = 'Customer-Test-Account',
                                              dmpl__IsCustomerAccount__c = True,
                                              dmpl__LastName__c = 'Cycle Count',
                                              dmpl__IsActive__c = true);
        insert customerAccount;
        
        Account supplierAccount = new Account(Name = 'Supplier-Test-Account',
                                              dmpl__IsSupplierAccount__c = True,
                                              dmpl__LastName__c = 'Cycle Count',
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
            dmpl__HttpQuery__c='vdhdvhd',
            dmpl__FileName__c = 'tally{!timeStamp}.xml',
            dmpl__FileTitle__c = 'Tally Export for {!timeStamp}'
            //dmpl__SourceDataType__c = 'Incremental'
        ));
        insert interfaceServiceRequest;
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
}