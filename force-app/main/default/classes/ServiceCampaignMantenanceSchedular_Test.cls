@isTest
public class ServiceCampaignMantenanceSchedular_Test {
	@testSetup
    public static void Setup()
    {
        	CreateAccountGroup();
            CreateAccount();
            CreateContactAddress();
            CreateBranch();
            CreateItems();
            CreateSKu();
        	CreateItemMaintenanceSchedule();
            CreateItemServiceContract();
        	CreateServiceLead();
        	CreateServiceCompaign();
        	CreateInterfaceQueue();
    }
    
    @istest
    public static void test(){
        test.startTest();
        list <Account> acc=[select id,name from Account limit 1];
     	System.assert(acc != null, 'Account data');
        test.stopTest();
    }
    
    @isTest
    private static void VerifyBatchClass()
    {
        test.startTest();
        CreateServiceRequest();
        dmpl__ServiceCampaign__c serviceCampaign = [SELECT Id,Name FROM dmpl__ServiceCampaign__c LIMIT 1];
        JobResponseResult result = ServiceCampaignMantenanceSchedular.perfromAction(serviceCampaign.Id,null);
        ServiceCampaignServiceRequestCleaner batchJob = new ServiceCampaignServiceRequestCleaner(
                serviceCampaign.Id,
                serviceCampaign.Id,
               serviceCampaign.Id 
               
            );
            Database.executeBatch(batchJob, 1);
        test.stopTest();
    }

    
    private static void CreateAccountGroup()
    {
        dmpl__AccountGroup__c accountGroup= new dmpl__AccountGroup__c (Name= 'Test-AccountGroup', 
                                                                       dmpl__AccountGroupType__c='Price');
        insert accountGroup;
        
    }
    
    private static void CreateAccount()
    {
        dmpl__AccountGroup__c accountGroup = [Select Id,Name From dmpl__AccountGroup__c LIMIT 1];
       
        Account partneraccount = new Account(Name = 'Partner-Test-Account',
                                             dmpl__LastName__c = 'Sale Order',
                                             dmpl__IsPartnerAccount__c = True, 
                                             dmpl__IsActive__c = true,
                                             dmpl__PartnerTaxAccountGroupId__c = accountGroup.Id,
                                             dmpl__CustomerPriceAccountGroupId__c = accountGroup.Id,
                                             dmpl__CustomerDiscountAccountGroupId__c = accountGroup.Id,
                                             dmpl__PartnerSchemeAccountGroupId__c = accountGroup.Id,                                
                                             dmpl__PartnerPriceAccountGroupId__c = accountGroup.Id,
                                             dmpl__PartnerDiscountAccountGroupId__c = accountGroup.Id,
                                             dmpl__CustomerSchemeAccountGroupId__c = accountGroup.Id
                                            );
        insert partneraccount;
        
        
        Account customerAccount = new Account(Name = 'Customer-Test-Account',
                                              dmpl__LastName__c = 'Sale Order',
                                              dmpl__IsCustomerAccount__c = True,
                                              dmpl__IsPartnerAccount__c = True,
                                              dmpl__IsActive__c = true,
                                              dmpl__PartnerTaxAccountGroupId__c = accountGroup.Id,
                                              dmpl__CustomerPriceAccountGroupId__c = accountGroup.Id,
                                              dmpl__CustomerDiscountAccountGroupId__c = accountGroup.Id,
                                              dmpl__PartnerSchemeAccountGroupId__c = accountGroup.Id,                                
                                              dmpl__PartnerPriceAccountGroupId__c = accountGroup.Id,
                                              dmpl__PartnerDiscountAccountGroupId__c = accountGroup.Id,
                                              dmpl__CustomerSchemeAccountGroupId__c = accountGroup.Id
                                             );
        insert customerAccount;
        
        
        Account supplierAccount = new Account(Name = 'Supplier-Test-Account',
                                              dmpl__LastName__c = 'Sale Order',
                                              dmpl__IsSupplierAccount__c = True,
                                              dmpl__IsActive__c = true,
                                              dmpl__PartnerTaxAccountGroupId__c = accountGroup.Id,
                                              dmpl__CustomerPriceAccountGroupId__c = accountGroup.Id,
                                              dmpl__CustomerDiscountAccountGroupId__c = accountGroup.Id,
                                              dmpl__PartnerSchemeAccountGroupId__c = accountGroup.Id,                                
                                              dmpl__PartnerPriceAccountGroupId__c = accountGroup.Id,
                                              dmpl__PartnerDiscountAccountGroupId__c = accountGroup.Id,
                                              dmpl__CustomerSchemeAccountGroupId__c = accountGroup.Id
                                             );
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
      private static void CreateServiceRequest(){
          Account partnerAccount = [Select Id,Name From Account WHERE Name = 'Partner-Test-Account' LIMIT 1];
          Account customerAccount = [Select Id,Name From Account WHERE Name = 'Customer-Test-Account' LIMIT 1];
          dmpl__Branch__c branch = [SELECT Id FROM dmpl__Branch__c WHERE Name = 'Test-Branch' LIMIT 1];
          
        dmpl__ServiceRequest__c serviceRequest = new dmpl__ServiceRequest__c( dmpl__AccountId__c=customerAccount.id,
                                                                            dmpl__PartnerAccountId__c = partnerAccount.id,
                                                                            dmpl__BranchId__c = branch.id);
        insert serviceRequest;
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
        
        List<dmpl__ItemLot__c> itemLot = new List<dmpl__ItemLot__c>();
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        Account partnerAccount = [Select Id,Name From Account WHERE Name = 'Partner-Test-Account' LIMIT 1];
        //dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        //dmpl__SKU__c sku = [Select Id, Name from dmpl__SKU__c LIMIT 1];
        itemLot.Add(new dmpl__ItemLot__c(dmpl__BranchId__c = branch.Id,
                                         dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                         dmpl__ItemId__c = item.Id,
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
        
        List<Asset> asset = new List<Asset>();
        Account account = [Select Id,Name From Account WHERE Name = 'Customer-Test-Account' LIMIT 1];
        //dmpl__Branch__c branch = [Select Id,Name From dmpl__Branch__c LIMIT 1];
        //dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        //dmpl__ItemLot__c itemLot = [Select Id, Name From dmpl__ItemLot__c LIMIT 1];
        //dmpl__SKU__c sku = [Select Id,Name FROM dmpl__SKU__c LIMIT 1];
        asset.add(new Asset(Name = 'Test-Asset',
                            AccountId = account.Id,
                            dmpl__LastServiceBranchId__c = branch.Id,
                            dmpl__ItemId__c = item.Id,
                            dmpl__ItemLotId__c = itemLot[0].Id,
                            dmpl__SKUId__c = sku[0].Id,
                            dmpl__SellingBranchId__c = branch.Id,
                            dmpl__LastServicePartnerId__c = partnerAccount.Id,
                            dmpl__SellingPartnerAccountId__c = partnerAccount.Id,
                            //dmpl__NextServiceDate__c date.today(),
                            dmpl__RegistrationNumber__c = 'Axb371',
                            dmpl__SaleDate__c = date.today()
                           ));
        insert asset;
        
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
    
    @istest
    public static void test1(){
        test.startTest();
        list <dmpl__ServiceCampaign__c> acc=[select id,name from dmpl__ServiceCampaign__c limit 1];
     System.assert(acc != null, 'Account data');
        test.stopTest();
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
                                                                         dmpl__DueInDays__c = 3,
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
        
        Asset aset = [SELECT Id,Name,AccountId FROM Asset LIMIT 1];
        List<dmpl__ItemMaintenanceScheduleDetails__c> ItemMaintenanceScheduleDetails= new List<dmpl__ItemMaintenanceScheduleDetails__c>();
        ItemMaintenanceScheduleDetails.add(new dmpl__ItemMaintenanceScheduleDetails__c(
            																			dmpl__AssetId__c = aset.Id,
           																				dmpl__ItemId__c = item.Id,
            																			//dmpl__NextServiceDate__c = date.today() + 3,
            																			dmpl__ItemMaintenanceScheduleId__c = itemMaintenanceSchedule[0].Id,
            																			dmpl__LastServiceDate__c = date.today()));
        
        insert ItemMaintenanceScheduleDetails;
    }
    
    private static void CreateServiceCompaign()
    {
        List<dmpl__ServiceCampaign__c> serviceCampaign = new List<dmpl__ServiceCampaign__c>();
		dmpl__ItemServiceContract__c contract = [Select Id,Name From dmpl__ItemServiceContract__c LIMIT 1];
        dmpl__ServiceLead__c lead = [Select Id,Name From dmpl__ServiceLead__c LIMIT 1];
        dmpl__ItemMaintenanceSchedule__c itemSchedule = [SELECT Id,Name FROM dmpl__ItemMaintenanceSchedule__c LIMIT 1];
        dmpl__ItemMaintenanceScheduleDetails__c itemMaintenanceDetails = [Select Id,Name,dmpl__NextServiceDate__c,dmpl__AssetId__r.AccountId,dmpl__AssetId__r.dmpl__LastServiceBranchId__c,dmpl__AssetId__r.dmpl__SellingBranchId__c,dmpl__AssetId__r.dmpl__LastServicePartnerId__c,dmpl__AssetId__r.dmpl__SellingPartnerAccountId__c From dmpl__ItemMaintenanceScheduleDetails__c LIMIT 1];
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
                                                         dmpl__ReminderDaysOffset1__c = 3,
                                                         dmpl__ReminderDaysOffset3__c  = 3,
                                                         dmpl__ReminderDaysOffset2__c = 3,
                                                         dmpl__ItemMaintenanceScheduleId__c = itemSchedule.Id
                                                        ));
        insert serviceCampaign;
        ServiceCampaignMantenanceSchedular.queryAssetsForMaintenanceSchedule(serviceCampaign[0]);
        ServiceCampaignMantenanceSchedular.queryActiveServiceCampaign(serviceCampaign[0].Id);
        //ServiceCampaignMantenanceSchedular.createReminderTask(lead,serviceCampaign[0],5);
        ServiceCampaignMantenanceSchedular.createNewServiceLead(serviceCampaign[0],itemMaintenanceDetails,5);
        List<dmpl__ServiceCampaignRule__c> serviceCampaignRule= new List<dmpl__ServiceCampaignRule__c>();
        serviceCampaignRule.add(new dmpl__ServiceCampaignRule__c(dmpl__ServiceCampaignId__c = serviceCampaign[0].Id,
                                                             dmpl__FieldValue__c ='Test-1',
                                                             dmpl__SequenceNumber__c = 1,
                                                             dmpl__FieldName__c = 'Service - Campaign'
                                                        ));
        
        insert serviceCampaignRule;
        
    }
    
    private static void CreateInterfaceQueue()
    {
        dmpl__ServiceCampaign__c sericeCamp = [Select Id,Name From dmpl__ServiceCampaign__c LIMIT 1];
        dmpl__InterfaceQueue__c interfaceQueue1 = new dmpl__InterfaceQueue__c(dmpl__QueueType__c = 'Queueable',
                                                        dmpl__JobType__c = 'Item Group Member Processor');
        insert interfaceQueue1;
    }
}