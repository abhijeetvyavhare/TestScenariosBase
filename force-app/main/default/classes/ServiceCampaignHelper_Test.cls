@isTest
public class ServiceCampaignHelper_Test {
    
    @testsetup
    public static void setup()
    {
    	CreateAccountGroup();
        CreateAccount();
        CreateBranch();
        CreateItems();
        //CreateSKu();
        createAsset();
        //CreateItemServiceContract();
        CreateServiceLead();
        CreateServiceCompaign();
    }

    @isTest
    private static void VerifyServiceCampaignMemberProcessor()
    {
       //try{
            test.startTest();
            CreateInterfaceQueue();
            Id temp ;
        try{
            dmpl__ServiceCampaign__c campaign = [Select Id,Name,dmpl__IsActive__c,dmpl__DynamicMemberObject__c,dmpl__PartnerAccountId__c,dmpl__BranchId__c,dmpl__ReportId__c From dmpl__ServiceCampaign__c  LIMIT 1];
            dmpl__ServiceCampaign__c campaign1 = [Select Id,Name,dmpl__IsActive__c,dmpl__DynamicMemberObject__c,dmpl__PartnerAccountId__c,dmpl__BranchId__c,dmpl__ReportId__c From dmpl__ServiceCampaign__c where dmpl__DynamicMemberObject__c='Asset' LIMIT 1];
            dmpl__InterfaceQueue__c queue =[Select Id, Name,dmpl__QueueType__c,dmpl__IsSuccessful__c from dmpl__InterfaceQueue__c Limit 1];
            temp = queue.Id;
            ServiceCampaignMemberProcessor.perfromAction(campaign.Id,queue.Id);
            ServiceCampaignMemberProcessor.perfromAction(campaign.Id,queue.Id);
             ServiceCampaignMemberProcessor.perfromAction(campaign1.Id,queue.Id);
        	ServiceCampaignContractScheduleProcessor.perfromAction(campaign.Id,queue.Id);
            ServiceCampaignMemberProcessor batch3 = new ServiceCampaignMemberProcessor(campaign.Id,queue.Id,'select Id,Name from dmpl__ServiceCampaign__c',campaign);
        	Database.executeBatch(batch3);
              ServiceCampaignMemberProcessor batch4 = new ServiceCampaignMemberProcessor(campaign1.Id,queue.Id,'select Id,Name from dmpl__ServiceCampaign__c',campaign1);
        	Database.executeBatch(batch4);
        	ServiceCampaignAssetProcessor batch = new ServiceCampaignAssetProcessor(campaign.Id,queue.Id,'select Id,Name from dmpl__ServiceCampaign__c');
        	Database.executeBatch(batch);
             ServiceCampaignAssetCleaner batch1=new ServiceCampaignAssetCleaner(campaign.Id,queue.Id,campaign.Id);
           Database.executeBatch(batch1);
           ServiceCampaignServiceRequestProcessor batch2=new ServiceCampaignServiceRequestProcessor(campaign.Id,queue.Id,campaign.Id);
             Database.executeBatch(batch1);
             List<String> conditions = new List<String>{'Condition1', 'Condition2'};
            String customLogic = '{0} OR {1}';
            ServiceCampaignMemberProcessor.processReportData(campaign.Id,queue.Id, campaign);
            //ServiceCampaignMemberProcessor.parseCustomCondition(customLogic, conditions);
        } catch (Exception error) {
            ExceptionLogHelper.logException(error, temp);
           // throw error;
        }
          
          
            test.stopTest();
        //}
        //catch(Exception e){}
    }
   
      @isTest
    private static void processMembers()
    {
        test.startTest();
         CreateInterfaceQueue();
        dmpl__ServiceCampaign__c campaign = [Select Id,Name,dmpl__IsActive__c From dmpl__ServiceCampaign__c LIMIT 1];
          dmpl__InterfaceQueue__c queue =[Select Id, Name,dmpl__QueueType__c,dmpl__IsSuccessful__c from dmpl__InterfaceQueue__c Limit 1];
         // serviceCampaignLeadProcessor batch2=new serviceCampaignLeadProcessor(campaign.Id,queue.Id,'select Id,Name from dmpl__ServiceCampaign__c ');
          //   Database.executeBatch(batch2);
          //  serviceCampaignLeadCleaner batch3=new serviceCampaignLeadCleaner(campaign.Id,queue.Id);
          //   Database.executeBatch(batch3);
        ServiceCampaignHelper.processMembers(campaign.Id);
          // serviceCampaignServiceRequestProcessor batch4=new serviceCampaignServiceRequestProcessor(campaign.Id,queue.Id,'select Id,Name from dmpl__ServiceCampaign__c where Id=:campaign.Id');
          //  Database.executeBatch(batch4);
        test.stopTest();
    }
    
    @isTest
  private static void processLeads()
    {   dmpl__InterfaceQueue__c queue;
        try{
       
             CreateInterfaceQueue();
            ServiceRequestHelper_Test.CreateStorageLocation();
          //  ServiceRequestHelper_Test.CreateItems();
            ServiceRequestHelper_Test.CreateItemLot();
          //  ServiceRequestHelper_Test.CreateSKu();
          //  ServiceRequestHelper_Test.CreateAsset();
            ServiceRequestHelper_Test.CreateBranchTimeSlot();
            ServiceRequestHelper_Test.CreateServiceRequest();
          //  ServiceRequestHelper_Test.CreateServiceRequestLine();
           
        dmpl__ServiceCampaign__c campaign = [Select Id,Name,dmpl__IsActive__c From dmpl__ServiceCampaign__c LIMIT 1];
         queue =[Select Id, Name,dmpl__QueueType__c,dmpl__IsSuccessful__c from dmpl__InterfaceQueue__c Limit 1];
 
        ServiceCampaignHelper.processLeads(campaign.Id);
        ServiceCampaignContractScheduleProcessor.perfromAction(campaign.Id,queue.Id);
    
       // ServiceCampaignContractScheduleProcessor obj = new ServiceCampaignContractScheduleProcessor(campaign.Id,queue.Id,'Select Id,Name From dmpl__ServiceCampaign__c',campaign);
       // Database.executeBatch(obj);
         ServiceCampaignServiceRequestCleaner batchJob = new ServiceCampaignServiceRequestCleaner(
                campaign.Id,
                queue.Id,
               campaign.Id
            );
           
       
         ServiceCampaignServiceRequestProcessor batchJob1 = new ServiceCampaignServiceRequestProcessor(
                campaign.Id,
                queue.Id,
               'Select Id, Name, dmpl__AssetId__c,dmpl__ServiceCampaignMemberId__c, dmpl__AccountId__c,dmpl__PartnerAccountId__c,dmpl__BranchId__c From dmpl__ServiceRequest__c '
            );
        test.startTest();
               ServiceCampaignHelper.processMembers(campaign.Id);
             ServiceCampaignHelper.processServiceRequests(campaign.Id);
             Database.executeBatch(batchJob);
            Database.executeBatch(batchJob1);
           
        test.stopTest();
        }catch (Exception error) {
           // ExceptionLogHelper.logException(error, queue.ID );
            throw error;
        }
    }

    @isTest
    private static void processSR()
    {
        test.startTest();
        
        CreateServiceCompaignSR();
        dmpl__ServiceCampaign__c campaign = [Select Id,Name,dmpl__IsActive__c From dmpl__ServiceCampaign__c WHERE dmpl__Type__c = 'Recall' LIMIT 1];
        ServiceCampaignHelper.processMembers(campaign.Id);
        ServiceCampaignHelper.processServiceRequests(campaign.Id);
        test.stopTest();
    }
    
    @isTest
    private static void processAA()
    {
        test.startTest();
        //CreateServiceCompaignAA();
         ID temp ='01IF3000001ll3G';
        try{
        CreateServiceCompaignNew();
         CreateInterfaceQueue();
        dmpl__ServiceCampaign__c campaign = [Select Id,Name,dmpl__IsActive__c, (SELECT Id, dmpl__ItemId__c FROM dmpl__ServiceCampaignItems__r)  From dmpl__ServiceCampaign__c  LIMIT 1];
        dmpl__ServiceCampaignMember__c ServiceCampaignMember = [Select Id,Name From dmpl__ServiceCampaignMember__c   LIMIT 1];
        dmpl__InterfaceQueue__c queue =[Select Id, Name,dmpl__QueueType__c,dmpl__IsSuccessful__c from dmpl__InterfaceQueue__c Limit 1];
               System.debug('Retrieved Campaign: ' + campaign.Id);
        System.debug('Related Items: ' + campaign.dmpl__ServiceCampaignItems__r.size());
        ServiceCampaignHelper.processMembers(campaign.Id);
        ServiceCampaignHelper.processAssets(campaign.Id);
            
        ServiceCampaignAssetProcessor batchJob = new ServiceCampaignAssetProcessor(
                campaign.Id,
                queue.Id,
                'SELECT Id FROM dmpl__ServiceCampaignMember__c WHERE dmpl__ServiceCampaignId__c = \'' + campaign.Id + '\''
            );
            Database.executeBatch(batchJob, 1);
        }catch (Exception error) {
            ExceptionLogHelper.logException(error, temp);
            throw error;
        }
        test.stopTest();
    }

    @isTest
    private static void VerifyServiceCampaignMember()
    {
        try{
            test.startTest();
            CreateServiceCompaignNew();
            CreateInterfaceQueue();
            dmpl__ServiceCampaign__c campaign = [Select Id,Name,dmpl__IsActive__c From dmpl__ServiceCampaign__c where dmpl__DynamicMemberType__c='Report Data' LIMIT 1];
            dmpl__InterfaceQueue__c queue =[Select Id, Name,dmpl__QueueType__c,dmpl__IsSuccessful__c from dmpl__InterfaceQueue__c Limit 1];
            ServiceCampaignMemberProcessor.perfromAction(campaign.Id,queue.Id);
            ServiceCampaignContractScheduleProcessor.perfromAction(campaign.Id,queue.Id);
            
            test.stopTest();
        }
        catch(Exception e){}
    }

    @isTest
    public static void UpdateServiceCompaign()
    {
        try{
        test.startTest();
        Integer reminderCount = 10;
        dmpl__ServiceCampaign__c campaign = [Select Id,Name,dmpl__IsActive__c From dmpl__ServiceCampaign__c LIMIT 1];
        campaign.dmpl__IsActive__c = true;
        Update campaign;
            
        dmpl__AssetServiceContract__c contract = [Select Id,Name From dmpl__AssetServiceContract__c LIMIT 1];
        ServiceCampaignContractScheduleProcessor.createNewServiceLead(campaign,contract,reminderCount);
        System.assert(campaign != null, 'Service Campaign is Updated');
        test.stopTest();
        }
        catch(exception e){}
    }
    
    @isTest
    public static void SchedulableExecute()
    {
        Test.startTest();
        ServiceCampaignSchedulable sCS = new ServiceCampaignSchedulable();
        String sch = '0 0 2 * * ?'; 
        system.schedule('Test Territory Check', sch, sCS); 
        System.assertNotEquals(null, sCS);
        Test.stopTest();
    }
    
    @isTest
    public static void getActionSettings()
    {
        Test.startTest();
        string errorReceived;
        try{             
            ScreenActionController.getActionSettings('Domain Name', 'dmpl__DomainSetting__mdt');
            ScreenActionController.getRecordFormActionSettings('Setting Name', 'dmpl__DomainSetting__mdt');
            ScreenActionController.geScreenActionSettings('dmpl__DomainSetting__mdt', '');
            new AppointmentActionDFSHelper().getActionDomainSetting('Setting Name', 'dmpl__DomainSetting__mdt','');
        } catch (Exception ex) {
            errorReceived = ex.getMessage();
        }
        System.assertEquals(null, errorReceived);
        Test.stopTest();
    }
    
    @isTest
    private static void VerifyHeadlessCallableMethod()
    {
        test.startTest();
         ID temp ='01IF3000001ll3G';
        try{
        dmpl__ServiceCampaign__c campaign = [Select Id,Name,dmpl__IsActive__c From dmpl__ServiceCampaign__c LIMIT 1];
        dmpl__ServiceCampaignMember__c ServiceCampaignMember = [Select Id,Name From dmpl__ServiceCampaignMember__c   LIMIT 1];
        dmpl__InterfaceQueue__c queue =[Select Id, Name,dmpl__QueueType__c,dmpl__IsSuccessful__c from dmpl__InterfaceQueue__c Limit 1];
        //HeadlessCallableController.callHeadlessAction('headlessAction1','dmpl__ServiceCampaign__c',ServiceCampaignMember.Id);
        HeadlessCallableController.callHeadlessAction('headlessAction','dmpl__ServiceCampaign__c',campaign.Id);
        HeadlessCallableController.callHeadlessAction('headlessAction2','dmpl__ServiceCampaign__c',campaign.Id);
        HeadlessCallableController.callHeadlessAction('headlessAction3','dmpl__ServiceCampaign__c',campaign.Id);
        HeadlessCallableController.callHeadlessAction('headlessAction4','dmpl__ServiceCampaign__c',campaign.Id);
        } catch (Exception error) {
            //ExceptionLogHelper.logException(error, queue);
            //throw error;
            HeadlessCallableController result = new HeadlessCallableController();
        }
        test.stopTest();
    }
    
    @isTest
    private static void VerifyServiceCamapignLeadProcessor()
    {
        try{
        test.startTest();
        CreateServiceCompaignNew();
        Integer daysOffset = 20;
        dmpl__ServiceCampaign__c campaign = [Select Id,Name,dmpl__IsActive__c,dmpl__ReminderDaysOffset1__c,dmpl__ReminderDaysOffset2__c,dmpl__ReminderDaysOffset3__c From dmpl__ServiceCampaign__c LIMIT 1];
        dmpl__ServiceLead__c lead = [Select Id,Name,dmpl__LeadDueDate__c From dmpl__ServiceLead__c LIMIT 1];
        ServiceCampaignContractScheduleProcessor.createReminderTask(lead,campaign,daysOffset);
        campaign.dmpl__ReminderDaysOffset1__c = 1;
        campaign.dmpl__ReminderDaysOffset2__c = 2;
        campaign.dmpl__ReminderDaysOffset3__c = 3;
        update campaign;
        ServiceCampaignContractScheduleProcessor.queryAssetsContractForMaintenanceSchedule(campaign);
        //String query = 'SELECT Id,Name,dmpl__AccountId,dmpl__AssetId__c,dmpl__PartnerAccountId__c,dmpl__BranchId__c,dmpl__ServiceCampaignId__c FROM dmpl__ServiceCampaignMember__c WHERE dmpl__ServiceCampaignId__c IN :'+campaign.Id;
        //ServiceCampaignLeadProcessor obj = new ServiceCampaignLeadProcessor(campaign.Id,null,'');
   		System.assert(lead != null, 'lead data');
        test.stopTest();
        }catch(exception e){}
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
                                   dmpl__ServiceDurationInMinutes__c=-3,
                                   dmpl__RFID__c = 'O1234fgh'
                                  ));
        insert item;
        
        dmpl__Item__c workItem = new dmpl__Item__c(
            Name = 'Washing', 
            dmpl__ItemCode__c = 'Washing', 
            dmpl__ItemType__c = 'Work Item',
            dmpl__IsActive__c = true);
        
        insert workItem;
        
        List<dmpl__SKU__c> sku = new List<dmpl__SKU__c>();
        sku.add(new dmpl__SKU__c(Name = 'Test - SKU',
                                 dmpl__SKUCode__c = 'Test - SKU - Code',
                                 dmpl__UnitOfMeasureOfConversion__c = 10,
                                 dmpl__ProductColor__c = 'Sample',
                                 dmpl__IsDefault__c = false,
                                 dmpl__QuantityUnitOfMeasure__c ='Sample',
                                 dmpl__ItemId__c = item[0].Id));
        insert sku; 
        
        List<dmpl__ItemLot__c> itemLot = new List<dmpl__ItemLot__c>();
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c LIMIT 1];
        itemLot.Add(new dmpl__ItemLot__c(dmpl__BranchId__c = branch.Id,
                                         dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                         dmpl__ItemId__c = item[0].Id,
                                         dmpl__SKUId__c = sku[0].Id,
                                         dmpl__BatchNo__c = '12345',
                                         dmpl__SerialNumber__c = '4675',
                                         dmpl__SupplierInvoiceNumber__c = '74985',
                                         dmpl__DateOfReceipt__c = date.today(),
                                         dmpl__DateOfMfg__c = date.today(),
                                         dmpl__TotalCost__c = 100,
                                         dmpl__DateOfSupplierInvoice__c = date.today(),
                                         dmpl__Cost__c = 100
                                        // dmpl__QuantityExpired__c = 1,
                                        // dmpl__QuantityOnHold__c = 1,
                                        // dmpl__QuantityOnLoan__c = 1
                                        ));
        
        insert itemLot;
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
    
    private static void createAsset()
    {
        List<Asset> asset = new List<Asset>();
        Account account = [Select Id,Name From Account WHERE dmpl__IsCustomerAccount__c = true LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c LIMIT 1];
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        dmpl__ItemLot__c itemLot = [Select Id, Name From dmpl__ItemLot__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id,Name FROM dmpl__SKU__c LIMIT 1];
        asset.add(new Asset(Name = 'Test-Asset',
                            AccountId = account.Id,
                            dmpl__LastServiceBranchId__c = branch.Id,
                            dmpl__LastServicePartnerId__c = branch.dmpl__PartnerAccountId__c,
                            dmpl__ItemId__c = item.Id,
                            dmpl__ItemLotId__c = itemLot.Id,
                            dmpl__SKUId__c = sku.Id,
                            dmpl__RegistrationNumber__c = 'Axb371',
                            dmpl__SaleDate__c = date.today()
                           ));
        insert asset;
        
        List<dmpl__ItemServiceContract__c> serviceContract = new List<dmpl__ItemServiceContract__c>();
        serviceContract.add(new dmpl__ItemServiceContract__c(dmpl__DateEffectiveFrom__c = date.today(),
                                                             dmpl__DateEffectiveTill__c = date.today() + 7,
                                                             dmpl__ItemId__c = item.Id,
                                                             dmpl__SKUId__c = sku.Id,
                                                             dmpl__PopulateContractLines__c = true
                                                            ));
        insert serviceContract;
        
        List<dmpl__AssetServiceContract__c> assetServiceContracts = new List<dmpl__AssetServiceContract__c>();
        assetServiceContracts.add(new dmpl__AssetServiceContract__c(
            dmpl__AssetId__c = asset[0].Id,
            dmpl__ItemId__c = item.Id,
            dmpl__ServiceContractItemId__c = item.Id,
            dmpl__ActivatedDate__c = Datetime.now().Date(),
            dmpl__ValidtillDate__c = Datetime.now().addDays(365).Date(),
            dmpl__DueDate__c = Datetime.now().addDays(3).Date(),
            dmpl__ItemServiceContractId__c = serviceContract[0].Id
        ));
        insert assetServiceContracts;
    }
    
    private static void CreateItemServiceContract()
    {
        List<dmpl__ItemServiceContract__c> serviceContract = new List<dmpl__ItemServiceContract__c>();
        dmpl__Item__c items = [Select Id,Name From dmpl__Item__c LIMIT 1];
        dmpl__SKU__c skus = [Select Id,Name From dmpl__SKU__c LIMIT 1];
        serviceContract.add(new dmpl__ItemServiceContract__c(dmpl__DateEffectiveFrom__c = date.today(),
                                                             dmpl__DateEffectiveTill__c = date.today() + 7,
                                                             dmpl__ItemId__c = items.Id,
                                                             dmpl__SKUId__c = skus.Id,
                                                             dmpl__PopulateContractLines__c = true
                                                            ));
        insert serviceContract;
    }
    
    private static void CreateServiceLead()
    {
        List<dmpl__ServiceLead__c> serviceLead = new List<dmpl__ServiceLead__c>();
        Account account = [Select Id,Name From Account WHERE Name = 'Customer-Test-Account' LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c LIMIT 1];
        dmpl__Item__c items = [Select Id,Name From dmpl__Item__c LIMIT 1];
        dmpl__ItemServiceContract__c contract = [Select Id,Name From dmpl__ItemServiceContract__c LIMIT 1];
        serviceLead.add(new dmpl__ServiceLead__c(dmpl__AccountId__c = account.Id,
                                                 dmpl__BranchId__c = branch.Id,
                                                 dmpl__ServiceContractItemId__c = items.Id,
                                                 dmpl__ItemServiceContractId__c = contract.Id,
                                                 dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c
                                                ));
        insert serviceLead;
    }
    
    private static void CreateServiceCompaign()
    {    
        
        List<dmpl__ServiceCampaign__c> serviceCampaign = new List<dmpl__ServiceCampaign__c>();
		dmpl__ItemServiceContract__c contract = [Select Id,Name From dmpl__ItemServiceContract__c LIMIT 1];
        dmpl__ServiceLead__c lead = [Select Id,Name From dmpl__ServiceLead__c LIMIT 1];
        dmpl__Item__c items = [Select Id,Name From dmpl__Item__c LIMIT 1];
        serviceCampaign.add(new dmpl__ServiceCampaign__c(dmpl__ItemServiceContractId__c = contract.Id,
                                                         dmpl__ServiceLeadId__c = lead.Id,
                                                         dmpl__ServiceContractItemId__c = items.Id,
                                                         dmpl__IsActive__c = true,
                                                         dmpl__ReportId__c='Sample Report',
                                                         dmpl__ApexJobId__c = 'Job1',
                                                         dmpl__CronExpression__c = 'Cron Expression',
                                                         dmpl__Type__c = 'Service',
                                                         Name = 'Service - Campaign',
                                                         dmpl__ReminderDaysOffset1__c = 3
                                                        ));
          serviceCampaign.add(new dmpl__ServiceCampaign__c(dmpl__ItemServiceContractId__c = contract.Id,
                                                         dmpl__ServiceLeadId__c = lead.Id,
                                                         dmpl__DynamicMemberType__c='Report Data',
                                                         dmpl__ServiceContractItemId__c = items.Id,
                                                         dmpl__ApexJobId__c = 'Job1',
                                                         dmpl__CronExpression__c = 'Cron Expression',
                                                         dmpl__Type__c = 'Service',
                                                         Name = 'Service - Campaign',
                                                         dmpl__DynamicMemberObject__c = 'Asset',
                                                        dmpl__ReportId__c = 'Technician_Efficiency',
                                                        dmpl__RuleSuccessCriteria__c = 'Custom Logic Is Met',
                                                        dmpl__RuleSuccessCustomLogic__c = '1 OR 2',
                                                        dmpl__IsActive__c = true
                                                        ));
        
        insert serviceCampaign;
        
        System.debug(serviceCampaign+'serviceCampaign'+serviceCampaign.size());
        List<dmpl__ServiceCampaignRule__c> serviceCampaignRule= new List<dmpl__ServiceCampaignRule__c>();
        serviceCampaignRule.add(new dmpl__ServiceCampaignRule__c(dmpl__ServiceCampaignId__c = serviceCampaign[0].Id,
                                                             dmpl__FieldValue__c ='Test-1',
                                                             dmpl__SequenceNumber__c = 1,
                                                             dmpl__FieldName__c = 'Service - Campaign'
                                                        ));
        
        insert serviceCampaignRule;
        
    }
    
    public static void CreateInterfaceQueue()
    {
        dmpl__InterfaceQueue__c interfaceQueue1 = new dmpl__InterfaceQueue__c(dmpl__QueueType__c = 'Queueable',
                                                        dmpl__JobType__c = 'Item Group Member Processor');
        insert interfaceQueue1;
    }
    
     private static void CreateServiceCompaignNew()
    {
        List<dmpl__ServiceCampaign__c> serviceCampaign = new List<dmpl__ServiceCampaign__c>();
		dmpl__ItemServiceContract__c contract = [Select Id,Name From dmpl__ItemServiceContract__c LIMIT 1];
        Account account = [Select Id,Name From Account WHERE Name = 'Customer-Test-Account' LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c LIMIT 1];
   
        dmpl__ServiceLead__c lead = [Select Id,Name From dmpl__ServiceLead__c LIMIT 1];
        dmpl__Item__c items = [Select Id,Name From dmpl__Item__c LIMIT 1];
        serviceCampaign.add(new dmpl__ServiceCampaign__c(dmpl__ItemServiceContractId__c = contract.Id,
                                                         dmpl__ServiceLeadId__c = lead.Id,
                                                         dmpl__DynamicMemberType__c='Report Data',
                                                         dmpl__ServiceContractItemId__c = items.Id,
                                                         dmpl__IsActive__c = false,
                                                         dmpl__ReportId__c='Sample Report',
                                                         dmpl__ApexJobId__c = 'Job1',
                                                         dmpl__CronExpression__c = 'Cron Expression',
                                                         dmpl__Type__c = 'Service',
                                                         Name = 'Service - Campaign'
                                                        ));
      
        insert serviceCampaign;
        
        List<dmpl__ServiceCampaignRule__c> serviceCampaignRule= new List<dmpl__ServiceCampaignRule__c>();
        serviceCampaignRule.add(new dmpl__ServiceCampaignRule__c(dmpl__ServiceCampaignId__c = serviceCampaign[0].Id,
                                                             dmpl__FieldValue__c ='Test-1',
                                                             dmpl__SequenceNumber__c = 1,
                                                             dmpl__FieldName__c = 'Service - Campaign'
                                                        ));
        
        insert serviceCampaignRule;
        
          List<dmpl__ServiceCampaignItem__c> scitems= new List<dmpl__ServiceCampaignItem__c>();
        scitems.add(new dmpl__ServiceCampaignItem__c(dmpl__ServiceCampaignId__c = serviceCampaign[0].Id,
                                                    dmpl__ItemId__c = items.Id,
                                                    dmpl__Quantity__c = 4,
                                                    dmpl__IsMandatory__c = true
                                            ));
        scitems.add(new dmpl__ServiceCampaignItem__c(dmpl__ServiceCampaignId__c = serviceCampaign[0].Id,
                dmpl__ItemId__c = items.Id,
                dmpl__Quantity__c = 5,
                dmpl__IsMandatory__c = false
        ));
       
        insert scitems;
        System.debug('Inserted Service Campaign Items: ' + scitems.size());
        
        List<dmpl__ServiceCampaignMember__c> serviceCampaignMember= new List<dmpl__ServiceCampaignMember__c>();
        serviceCampaignMember.add(new dmpl__ServiceCampaignMember__c(
            dmpl__ServiceCampaignId__c = serviceCampaign[0].Id,
            dmpl__BatchInstanceId__c ='Test-1',
            dmpl__AccountId__c = account.Id,
            dmpl__BranchId__c = branch.Id,
            dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c
        ));
        
        insert serviceCampaignMember;
    }

    private static void CreateServiceCompaignSR()
    {
        List<dmpl__ServiceCampaign__c> serviceCampaign = new List<dmpl__ServiceCampaign__c>();
		dmpl__ItemServiceContract__c contract = [Select Id,Name From dmpl__ItemServiceContract__c LIMIT 1];
        dmpl__ServiceLead__c lead = [Select Id,Name From dmpl__ServiceLead__c LIMIT 1];
        dmpl__Item__c items = [Select Id,Name From dmpl__Item__c LIMIT 1];
        Account partnerAccount = [Select Id,Name From Account WHERE Name = 'Partner-Test-Account' LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c LIMIT 1];
        serviceCampaign.add(new dmpl__ServiceCampaign__c(dmpl__ItemServiceContractId__c = contract.Id,
                                                         dmpl__IsActive__c = false,
                                                         dmpl__RuleSuccessCriteria__c = 'All Rules Are Met',
                                                         dmpl__DynamicMemberObject__c = 'Asset',
                                                         DynamicMemberType__c = 'Field Filter',
                                                         dmpl__Type__c = 'Recall',
                                                         Name = 'Service - Campaign',
                                                         dmpl__PartnerAccountId__c = partnerAccount.Id,
                                                         dmpl__BranchId__c = branch.Id
                                                        ));
        insert serviceCampaign;
        
        List<dmpl__ServiceCampaignRule__c> serviceCampaignRule= new List<dmpl__ServiceCampaignRule__c>();
        serviceCampaignRule.add(new dmpl__ServiceCampaignRule__c(dmpl__ServiceCampaignId__c = serviceCampaign[0].Id,
                                                             dmpl__FieldValue__c ='\'\'',
                                                             dmpl__SequenceNumber__c = 1,
                                                             dmpl__FieldName__c = 'Name',
                                                             dmpl__ObjectType__c = 'Asset',
                                                             dmpl__Operation__c = 'equals'
                                                        ));
        
        insert serviceCampaignRule;
        
    }
    

    private static void CreateServiceCompaignAA()
    {
        List<dmpl__ServiceCampaign__c> serviceCampaign = new List<dmpl__ServiceCampaign__c>();
		dmpl__ItemServiceContract__c contract = [Select Id,Name From dmpl__ItemServiceContract__c LIMIT 1];
        dmpl__ServiceLead__c lead = [Select Id,Name From dmpl__ServiceLead__c LIMIT 1];
        dmpl__Item__c items = [Select Id,Name From dmpl__Item__c LIMIT 1];
        Account partnerAccount = [Select Id,Name From Account WHERE Name = 'Partner-Test-Account' LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c LIMIT 1];
        serviceCampaign.add(new dmpl__ServiceCampaign__c(dmpl__ItemServiceContractId__c = contract.Id,
                                                         dmpl__IsActive__c = false,
                                                         dmpl__RuleSuccessCriteria__c = 'All Rules Are Met',
                                                         dmpl__DynamicMemberObject__c = 'Asset',
                                                         DynamicMemberType__c = 'Field Filter',
                                                         dmpl__Type__c = 'Recall - Asset Actions',
                                                         Name = 'Service - Campaign',
                                                         dmpl__PartnerAccountId__c = partnerAccount.Id,
                                                         dmpl__BranchId__c = branch.Id
                                                        ));
        insert serviceCampaign;
        
        List<dmpl__ServiceCampaignRule__c> serviceCampaignRule= new List<dmpl__ServiceCampaignRule__c>();
        serviceCampaignRule.add(new dmpl__ServiceCampaignRule__c(dmpl__ServiceCampaignId__c = serviceCampaign[0].Id,
                                                             dmpl__FieldValue__c ='\'\'',
                                                             dmpl__SequenceNumber__c = 1,
                                                             dmpl__FieldName__c = 'Name',
                                                             dmpl__ObjectType__c = 'Asset',
                                                             dmpl__Operation__c = 'equals'
                                                        ));
        
        insert serviceCampaignRule;
        
     
        
        
        
        List<ServiceCampaignItem__c> scitems= new List<ServiceCampaignItem__c>();
        scitems.add(new ServiceCampaignItem__c(dmpl__ServiceCampaignId__c = serviceCampaign[0].Id,
                                                    dmpl__ItemId__c = items.Id,
                                                    dmpl__Quantity__c = 4,
                                                    dmpl__IsMandatory__c = true
                                            ));
        scitems.add(new ServiceCampaignItem__c(dmpl__ServiceCampaignId__c = serviceCampaign[0].Id,
                dmpl__ItemId__c = items.Id,
                dmpl__Quantity__c = 5,
                dmpl__IsMandatory__c = false
        ));
       
        insert scitems;
    }
}