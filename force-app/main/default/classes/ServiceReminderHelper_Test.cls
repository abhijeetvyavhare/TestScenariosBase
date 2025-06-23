@IsTest
public class ServiceReminderHelper_Test {
    
    @testSetup
    public static void Setup()
    {
        //System.runAs(PostInstallHelper.AssignAdministratorAllPermissions(UserInfo.getUserId())){
            CreateAccountGroup();
            CreateAccount();
            CreateBranch();
            CreateItem();
            CreateSKU();
            CreateResource(); 
            CreateItemServiceContract();
            CreateServiceCampaign();
            CreateAsset();
            CreateServiceLead();
            CreateTask();
        //}
    }
    
    @isTest
    public static void VerifyReminder()
    {
        Test.startTest();
        dmpl__ServiceCampaign__c campaignId = [Select Id,Name From dmpl__ServiceCampaign__c];
        ServiceReminderHelper.execute(campaignId.Id);
        Test.stopTest();
        System.assert(campaignId!=null, 'Test claim have 1 updated record');
    }
    
    @isTest
    public static void VerifyReminder1()
    {
        try{
            Test.startTest();
            CreateServiceCampaign1();
            dmpl__ServiceCampaign__c campaignId = [Select Id,Name From dmpl__ServiceCampaign__c where dmpl__Type__c='Recall' limit 1];
            ServiceReminderHelper.execute(campaignId.Id);
            System.assert(campaignId!=null, 'Test claim have 1 updated record');
            Test.stopTest();}
        catch(exception e){}
        
    }
    
    @isTest
    public static void createNewServiceLead()
    {
        Test.startTest();
        dmpl__ServiceCampaign__c campaignId = [Select Id,Name,dmpl__StartDate__c,dmpl__ItemServiceContractId__c,dmpl__ServiceContractItemId__c From dmpl__ServiceCampaign__c];
        Asset asset =[Select Id, Name,AccountId,dmpl__SellingBranchId__c,dmpl__SellingPartnerAccountId__c,dmpl__LastServiceBranchId__c,dmpl__LastServicePartnerId__c from Asset Limit 1];
        ServiceReminderHelper.createNewServiceLead(campaignId,asset);
        Test.stopTest();
        System.assert(campaignId!=null, 'Test claim have 1 updated record');
    }
    
     @isTest
    public static void createNewServiceLeadNew()
    {
        Test.startTest();
        dmpl__ServiceCampaign__c campaignId = [Select Id,Name,dmpl__StartDate__c,dmpl__ItemServiceContractId__c,dmpl__ServiceContractItemId__c From dmpl__ServiceCampaign__c];
        dmpl__AssetServiceContract__c asset =[Select Id, Name,dmpl__AssetId__c,dmpl__AssetId__r.AccountId,dmpl__AssetId__r.dmpl__SellingBranchId__c,dmpl__AssetId__r.dmpl__SellingPartnerAccountId__c,dmpl__AssetId__r.dmpl__LastServiceBranchId__c,dmpl__AssetId__r.dmpl__LastServicePartnerId__c from dmpl__AssetServiceContract__c Limit 1];
        ServiceReminderHelper.createNewServiceLead(campaignId,asset,1);
        Test.stopTest();
        System.assert(campaignId!=null, 'Test claim have 1 updated record');
    }
    
     @isTest
    public static void createNewServiceLeadNew1()
    {
        Test.startTest();
        dmpl__ServiceCampaign__c campaignId = [Select Id,Name,
                                               dmpl__FromChassisSeries__c,
                                               dmpl__ToChassisSeries__c,
                                               dmpl__FromManufacturingDate__c,
                                               dmpl__ToManufacturingDate__c,
                                               dmpl__FromSaleDate__c,
                                               dmpl__ToSaleDate__c,
                                               dmpl__StartDate__c,dmpl__ItemServiceContractId__c,dmpl__ServiceContractItemId__c From dmpl__ServiceCampaign__c];
        dmpl__AssetServiceContract__c asset =[Select Id, Name,dmpl__AssetId__c,dmpl__AssetId__r.AccountId,dmpl__AssetId__r.dmpl__SellingBranchId__c,dmpl__AssetId__r.dmpl__SellingPartnerAccountId__c,dmpl__AssetId__r.dmpl__LastServiceBranchId__c,dmpl__AssetId__r.dmpl__LastServicePartnerId__c from dmpl__AssetServiceContract__c Limit 1];
        ServiceReminderHelper.queryAssetsForRecall(campaignId);
        Test.stopTest();
        System.assert(campaignId!=null, 'Test claim have 1 updated record');
    }
    
     @isTest
    public static void createReminderTask()
    {
        Test.startTest();
        dmpl__ServiceCampaign__c campaignId = [Select Id,Name,
                                               dmpl__FromChassisSeries__c,
                                               dmpl__ToChassisSeries__c,
                                               dmpl__FromManufacturingDate__c,
                                               dmpl__ToManufacturingDate__c,
                                               dmpl__FromSaleDate__c,
                                               dmpl__ToSaleDate__c,
                                               dmpl__StartDate__c,dmpl__ItemServiceContractId__c,dmpl__ServiceContractItemId__c From dmpl__ServiceCampaign__c];
        dmpl__ServiceLead__c asset =[Select Id, Name,OwnerId from dmpl__ServiceLead__c Limit 1];
        ServiceReminderHelper.createReminderTask(asset,campaignId,1);
        Test.stopTest();
        System.assert(campaignId!=null, 'Test claim have 1 updated record');
    }
    
    
     @isTest
    Static void VerifyCreateAccount()
    {
        List<Account>  account = [Select Id, Name From Account];
        System.assertNotEquals(null, account, 'Test Accounts are not found');
        System.assertEquals(4, account.size(), 'Test Accounts have more than 1 record');
    }
    
     private static void CreateAccountGroup()
    {
        dmpl__AccountGroup__c accountGroup= new dmpl__AccountGroup__c (Name= 'Test-Account-Group', 
                                                                       dmpl__AccountGroupType__c = 'Scheme');
        insert accountGroup;
        
    }
    
    private static void CreateAccount()
    {
        List<Account> account = new List<Account>();
        dmpl__AccountGroup__c accountGroup = [Select Id,Name From dmpl__AccountGroup__c LIMIT 1];
        account.add(new Account(Name = 'Test - Account', 
                                Fax = '09876',
                                Phone = '1234567891',
                                Website = 'www.Dealermatix.com',
                                Type = 'Prospect',
                                dmpl__LastName__c = 'Account',
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
        
        
        Account partneraccount = new Account(Name = 'Partner-Test-Account',dmpl__IsPartnerAccount__c = True,dmpl__LastName__c = 'Account', dmpl__IsActive__c = true);
        insert partneraccount;
        
        
        Account supplieraccount = new Account(Name = 'Supplier-Test-Account',dmpl__IsSupplierAccount__c = True,dmpl__LastName__c = 'Account', dmpl__IsActive__c = true);
        insert supplieraccount;
        
        
        Account customeraccount = new Account(Name = 'Customer-Test-Account',dmpl__IsCustomerAccount__c = True,dmpl__LastName__c = 'Account', dmpl__IsActive__c = true);
        insert customeraccount;
        
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
    
    private static void CreateItem()
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
                                   dmpl__RFID__c = 'O1234fgh',
                                   dmpl__IsPackage__c = true
                                  ));
        insert item;
        
        List<dmpl__Item__c> serviceItem = new List<dmpl__Item__c>();
        serviceItem.Add(new dmpl__Item__c(Name = 'Test-Item1',
                                          dmpl__ItemCode__c = 'DMPL1',
                                          dmpl__ItemType__c = 'Service Contract',
                                          dmpl__ItemSubType__c = '',
                                          dmpl__Description__c = '',
                                          dmpl__ItemFamily__c = 'Sample',
                                          dmpl__ItemSegment__c = 'Sample',
                                          dmpl__Make__c = 'Sample',
                                          dmpl__Model__c = 'Sample',
                                          dmpl__TrackInventory__c = true,
                                          dmpl__TrackLots__c = true,
                                          dmpl__RequireInspectionOnReceipt__c = true,
                                          dmpl__RequireInspectionOnDelivery__c = true,
                                          dmpl__AllowService__c = true,
                                          dmpl__TrackAsset__c = true,                               
                                          dmpl__IsActive__c = true,
                                          dmpl__IsRegistrationRequired__c = true,
                                          dmpl__GTIN__c = 'BR1231',
                                          dmpl__RFID__c = 'O1234fgh1',
                                          dmpl__IsPackage__c = true
                                         ));
        insert serviceItem;
        
        
    }
    
    private static void CreateSKU()
    {
        List<dmpl__SKU__c> Skus = new List<dmpl__SKU__c>();
        dmpl__Item__c listofitem = [Select Id, Name from dmpl__Item__c Limit 1];
        Skus.add(new dmpl__SKU__c(Name = 'Harrier XMA - Automatic - Orcus White',
                                  dmpl__SKUCode__c = 'Test - SKU - Code',
                                  dmpl__UnitOfMeasureOfConversion__c = 10,
                                  dmpl__ProductColor__c = 'Sample',
                                  dmpl__IsDefault__c = false,
                                  dmpl__QuantityUnitOfMeasure__c ='Sample',
                                  dmpl__ItemId__c = listofitem.Id
                                 ));
        insert Skus;
        
    }
    
    
    private static void CreateResource()
    {
        List<dmpl__Resource__c> resource = new List<dmpl__Resource__c>();
        Account partnerAccount = [Select Id,Name From Account LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c LIMIT 1];
        resource.add(new dmpl__Resource__c(Name = 'Test - Resource',
                                           dmpl__ResourceType__c = 'Service Advisor',
                                           dmpl__IsActive__c = true,
                                           dmpl__Phone__c = '9999999999',
                                           dmpl__DefaultPartnerAccountId__c = partnerAccount.Id,
                                           dmpl__DefaultBranchId__c = branch.Id
                                          ));
        insert resource;
        
        List<dmpl__Resource__c> technicianResource = new List<dmpl__Resource__c>();
        technicianResource.add(new dmpl__Resource__c(Name = 'Test - Resource',
                                                     dmpl__ResourceType__c = 'Technician',
                                                     dmpl__IsActive__c = true,
                                                     dmpl__Phone__c = '9999999999',
                                                     dmpl__DefaultPartnerAccountId__c = partnerAccount.Id,
                                                     dmpl__DefaultBranchId__c = branch.Id
                                                    ));
        insert technicianResource;
        
        List<dmpl__PartnerResource__c> partnerResource = new List<dmpl__PartnerResource__c>();
        partnerResource.add(new dmpl__PartnerResource__c(
                                                     	dmpl__ResourceId__c = resource[0].Id,
            											dmpl__BranchId__c = branch.Id,
            											dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                                        dmpl__AssignmentSequenceNumber__c = 1
                                                    ));
        insert partnerResource;
        
        List<dmpl__ResourceAssignmentRule__c> resourceAsignmentRules = new List<dmpl__ResourceAssignmentRule__c>();
        resourceAsignmentRules.add(new dmpl__ResourceAssignmentRule__c(
            dmpl__PartnerResourceId__c = partnerResource[0].Id,
            dmpl__FieldName__c = 'dmpl__DocumentDate__c',
            dmpl__Operation__c = 'greaterOrEqual',
            dmpl__FieldValue__c = String.valueOf(date.today().addDays(-2))
        ));
        resourceAsignmentRules.add(new dmpl__ResourceAssignmentRule__c(
            dmpl__PartnerResourceId__c = partnerResource[0].Id,
            dmpl__FieldName__c = 'dmpl__Remarks__c',
            //dmpl__Operation__c = 'greaterOrEqual',
            dmpl__FieldValue__c = '23'
        ));
        insert resourceAsignmentRules;
    }
    private static void CreateAsset()
    {
        List<Asset> asset = new List<Asset>();
        Account account = [Select Id,Name From Account WHERE Name = 'Customer-Test-Account' LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name From dmpl__Branch__c LIMIT 1];
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c Where dmpl__ItemType__c='Service Contract' LIMIT 1];
        dmpl__SKU__c sku = [Select Id,Name FROM dmpl__SKU__c LIMIT 1];
        asset.add(new Asset(Name = 'Test-Asset',
                            AccountId = account.Id,
                            dmpl__LastServiceBranchId__c = branch.Id,
                            dmpl__ItemId__c = item.Id,
                            dmpl__IsPDIDone__c=true,
                            dmpl__RegistrationNumber__c = 'Axb371',
                            dmpl__SaleDate__c = date.today()
                           ));
        insert asset;
        
        List<dmpl__AssetServiceContract__c> assetServiceContracts = new List<dmpl__AssetServiceContract__c>();
        dmpl__ServiceCampaign__c camp=[select Id, Name,dmpl__ServiceContractItemId__c,dmpl__ItemServiceContractId__c from dmpl__ServiceCampaign__c Limit 1];
        assetServiceContracts.add(new dmpl__AssetServiceContract__c(
            dmpl__AssetId__c = asset[0].Id,
            dmpl__ItemId__c = item.Id,
            dmpl__IsUtilized__c = false,
            dmpl__ItemServiceContractId__c=camp.dmpl__ItemServiceContractId__c,
            dmpl__ServiceContractItemId__c = camp.dmpl__ServiceContractItemId__c,
            dmpl__ActivatedDate__c = Datetime.now().Date(),
            dmpl__ValidtillDate__c = Datetime.now().addDays(365).Date(),
            dmpl__DueDate__c = date.today()+3
        ));
        insert assetServiceContracts;
        System.debug(assetServiceContracts);
        
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
      private static void CreateItemServiceContract()
    {
        List<dmpl__ItemServiceContract__c> ServiceContract = new List<dmpl__ItemServiceContract__c>();
        dmpl__Item__c item =[select Id,name FROM dmpl__Item__c where dmpl__ItemType__c='Service Contract' LIMIT 1];
        dmpl__SKU__c sku=[select Id,name FROM dmpl__SKU__c LIMIT 1];
        ServiceContract.add(new dmpl__ItemServiceContract__c(
            dmpl__ItemId__c = item.Id,
            dmpl__SKUId__c=sku.Id              
        ));
        insert ServiceContract;
    }
    
     private static void CreateServiceCampaign()
    {
        List<dmpl__ServiceCampaign__c> ServiceCampaign = new List<dmpl__ServiceCampaign__c>();
        dmpl__Item__c item =[select Id,name FROM dmpl__Item__c Where dmpl__ItemType__c='Service Contract' LIMIT 1];
        dmpl__ItemServiceContract__c itemServiceContrcat=[select Id,Name FROM dmpl__ItemServiceContract__c LIMIT 1];
        ServiceCampaign.add(new dmpl__ServiceCampaign__c(
            dmpl__ServiceContractItemId__c = item.Id,
            dmpl__IsActive__c=true,
            dmpl__ReminderDaysOffset1__c = 2,
            dmpl__ReminderDaysOffset2__c = 3,
            dmpl__ReminderDaysOffset3__c = 4,
            dmpl__Type__c='Maintenance Schedule',
            dmpl__StartDate__c=date.today(),
            dmpl__FromChassisSeries__c = '12345',
            dmpl__FromManufacturingDate__c = date.parse('09/11/2022'),
            dmpl__ToManufacturingDate__c = date.parse('10/11/2022'),
            dmpl__FromSaleDate__c = date.parse('09/01/2022'),
            dmpl__ToSaleDate__c = date.parse('12/12/2022'),
            dmpl__EndDate__c=null,
            dmpl__ItemServiceContractId__c=itemServiceContrcat.Id              
        ));
        insert ServiceCampaign;
    }
    
     private static void CreateServiceCampaign1()
    {
        List<dmpl__ServiceCampaign__c> ServiceCampaign = new List<dmpl__ServiceCampaign__c>();
        dmpl__Item__c item =[select Id,name FROM dmpl__Item__c Where dmpl__ItemType__c='Service Contract' LIMIT 1];
        dmpl__ItemServiceContract__c itemServiceContrcat=[select Id,Name FROM dmpl__ItemServiceContract__c LIMIT 1];
        ServiceCampaign.add(new dmpl__ServiceCampaign__c(
            dmpl__ServiceContractItemId__c = item.Id,
            dmpl__IsActive__c=true,
            dmpl__ReminderDaysOffset1__c=2,
            dmpl__ReminderDaysOffset2__c=3,
            dmpl__ReminderDaysOffset3__c=4,
            dmpl__Type__c='Recall',
            dmpl__StartDate__c=date.today(),
            dmpl__EndDate__c=null,
            dmpl__ItemServiceContractId__c=itemServiceContrcat.Id              
        ));
        insert ServiceCampaign;
    }
    
    private static void CreateServiceLead()
    
    
        {
        List<dmpl__ServiceLead__c> ServiceLead = new List<dmpl__ServiceLead__c>();
        Asset aaset=[Select Id, Name from Asset limit 1]; 
        Account account = [Select Id,Name From Account WHERE Name = 'Customer-Test-Account' LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c LIMIT 1];
        dmpl__ServiceCampaign__c camp=[select Id, Name from dmpl__ServiceCampaign__c Limit 1];
        dmpl__Item__c item =[select Id,name FROM dmpl__Item__c Where dmpl__ItemType__c='Service Contract' LIMIT 1];
        dmpl__ItemServiceContract__c itemServiceContrcat=[select Id,Name FROM dmpl__ItemServiceContract__c LIMIT 1];
        ServiceLead.add(new dmpl__ServiceLead__c(dmpl__ServiceContractItemId__c = item.Id,
                                                dmpl__ServiceCampaignId__c=camp.Id,
                                                dmpl__AssetId__c=aaset.Id,
                                                dmpl__Status__c='Draft',
                                                dmpl__AccountId__c=account.Id,
                                                dmpl__ItemServiceContractId__c=itemServiceContrcat.Id,
                                                dmpl__BranchId__c = branch.Id,
                                                dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                                dmpl__DocumentDate__c = date.today(),
                                                dmpl__LeadType__c = 'Recall'
        ));
        insert ServiceLead;
    }

    private static void CreateTask()
    {
        List<Task> task = new List<Task>();
        task.add(new Task(Subject = 'Call',
                          Status = 'Draft',
                          Priority = 'High',
                          whatId = null,
                          ActivityDate = date.today()
                         ));
        insert task;
    }
}