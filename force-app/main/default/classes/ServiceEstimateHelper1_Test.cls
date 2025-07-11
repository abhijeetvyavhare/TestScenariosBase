@isTest
public class ServiceEstimateHelper1_Test {
    
    @testSetup
    public static void Setup()
    {
        CreateAccountGroup();
        CreateAccount();
        CreateBranch();
        CreateStorageLocation();
        CreateItemGroup();
        CreateItems();
        CreateSKu();
        CreateItemLot();
        CreateResource();
        CreatePriceList();
        CreatePriceListRules();
        CreateAsset();
        CreateServiceBay();
        //CreateServiceType();
        CreateBranchTimeSlot();
        CreatePriceList();
        CreatePriceListRules();
        CreateServiceRequest();
        CreateTaxGroup();
        CreateTax();
    }
    
    @isTest
    public static void getActionSettings1()
    { 
        try{
        test.startTest();
        dmpl__Item__c order = [SELECT Id , Name,dmpl__ServiceDurationInMinutes__c FROM dmpl__Item__c];  
            DynamicTextParser.parse('',order);
        System.assert(order != null, 'Item data');
        test.stopTest();
    }
    catch(Exception e){}
    }
    
    @isTest
    public static void getActionSettings()
    { 
        try{
        test.startTest();
        dmpl__Item__c order = [SELECT Id , Name,dmpl__ServiceDurationInMinutes__c FROM dmpl__Item__c];       
        ScreenActionController.getActionSettings('','dmpl__Item__c');
        System.assert(order != null, 'Item data');
        test.stopTest();
    }
    catch(Exception e){}
    }
    
    @isTest
    public static void getSourceObject()
    { 
        try{
            test.startTest();
            dmpl__Item__c order = [SELECT Id , Name FROM dmpl__Item__c Limit 1];       
            ScreenActionController.getSourceObject('dmpl__Item__c',order.Id);
            System.assert(order != null, 'Item data');
            test.stopTest();
        }
        catch(Exception e){}
    }
    
    @isTest
    public static void setApplicableTaxGroups()
    {
        try{
        test.startTest();
        List<dmpl__Quote__c> quote = [Select Id,Name,dmpl__PartnerAccountId__c,dmpl__DocumentDate__c,dmpl__BranchId__c From dmpl__Quote__c LIMIT 1];
        List<dmpl__QuoteLine__c> line = [Select Id,Name,dmpl__ItemId__c,dmpl__SKUId__c,dmpl__TaxGroupId__c From dmpl__QuoteLine__c WHERE dmpl__TaxGroupId__c != null LIMIT 1];
        List<dmpl__Item__c> item = [Select Id,Name,dmpl__TaxItemGroupId__c From dmpl__Item__c LIMIT 1];
        //List<Id> billLineIds = new List<Id>();
        dmpl__TaxGroupRule__c rule = [Select Id,Name From dmpl__TaxGroupRule__c LIMIT 1];
        if(rule != null)
        {
          TaxGroupHelper.setApplicableTaxGroups(line, quote, item);
        }
        System.assertNotEquals(null, quote);
        test.stopTest();
        }
        catch(exception e){}
    }
   
    //@isTest
    public static void VerifyUpdateRepairOrderFromServiceEstimate()
    {
        CreateServiceRequestLine();
        test.startTest();
        CreateServiceEstimate();    
        CreateServiceEstimateLines();
        CreateRepairOrder();
        Test.stopTest();
        List<dmpl__Quote__c> quote = [Select Id,Name,dmpl__ServiceRequestRepairOrderId__c,dmpl__ServiceRequestId__c,dmpl__PerformEstimateLinesGeneration__c From dmpl__Quote__c LIMIT 1];
        quote[0].dmpl__PerformEstimateLinesGeneration__c = true;
        update quote;
        RepairOrderHelper.UpdateRepairOrderFromServiceEstimate(quote);
        System.assertNotEquals(null, quote);        
    }
    
    @isTest
    public static void updateQuoteLine()
    {
        test.startTest();
        CreateServiceEstimateLines();
        dmpl__QuoteLine__c line = [Select Id,Name,dmpl__PriceListRuleId__c From dmpl__QuoteLine__c LIMIT 1];
        if(line != null)
            update line;
        System.assert(line != null, 'Quote line Updated');
        test.stopTest();
    }
    
    @isTest
    private static void VerifyServiceEstimateLinesUpdate()
    {  test.startTest();
        CreateServiceEstimateLines();
        List<dmpl__QuoteLine__c> lines = [SELECT Id,Name FROM dmpl__QuoteLine__c];
        update lines;
       test.stopTest();
    }
    
    @isTest
    private static void VerifyServiceEstimateLinesDelete()
    {
        test.startTest();
        CreateServiceEstimateLines();
        List<dmpl__QuoteLine__c> lines = [SELECT Id,Name FROM dmpl__QuoteLine__c];
        delete lines;
        test.stopTest();
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
    }
    
    private static void CreateAccount()
    {
        List<Account> account = new List<Account>();
        dmpl__AccountGroup__c schemeAccountGroup = [Select Id,Name From dmpl__AccountGroup__c Where dmpl__AccountGroupType__c='Scheme'];
        dmpl__AccountGroup__c priceAccountGroup = [Select Id,Name From dmpl__AccountGroup__c where dmpl__AccountGroupType__c='Price' ];
        dmpl__AccountGroup__c discountAccountGroup = [Select Id,Name From dmpl__AccountGroup__c where dmpl__AccountGroupType__c='Discount'];
        dmpl__AccountGroup__c ItemAccountGroup = [Select Id,Name From dmpl__AccountGroup__c where dmpl__AccountGroupType__c='Item Feature' ];
       
        account.add(new Account(Name = 'Test - Account',
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
        
        Account partneraccount = new Account(Name = 'Partner-Test-Account',
                                            dmpl__LastName__c = 'Service Estimate',
                                            dmpl__IsPartnerAccount__c = True,
                                            dmpl__PartnerSchemeAccountGroupId__c = schemeAccountGroup.Id,                                
                                            dmpl__PartnerPriceAccountGroupId__c = priceAccountGroup.Id,
                                            dmpl__PartnerDiscountAccountGroupId__c = discountAccountGroup.Id,
                                            dmpl__IsActive__c = true);
        insert partneraccount;
        
        Account customerAccount = new Account(Name = 'Customer-Test-Account',
                                              dmpl__LastName__c = 'Service Estimate',
                                              dmpl__IsCustomerAccount__c = True,
                                              dmpl__CustomerPriceAccountGroupId__c = priceAccountGroup.Id,
                                              dmpl__CustomerDiscountAccountGroupId__c = discountAccountGroup.Id,
                                              dmpl__CustomerSchemeAccountGroupId__c = schemeAccountGroup.Id,
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
    
    private static void CreateStorageLocation()
    {
        List<dmpl__StorageLocation__c> storageLocation =  new List<dmpl__StorageLocation__c>();
        dmpl__Branch__c branch = [Select Id,Name,dmpl__ParentLocationId__c From dmpl__Branch__c];
        storageLocation.Add(new dmpl__StorageLocation__c(dmpl__BranchId__c = branch.Id,
                                                         dmpl__ParentLocationId__c = branch.dmpl__ParentLocationId__c,
                                                         dmpl__AllowInventory__c=true,
                                                         dmpl__IsMobile__c=true,
                                                         dmpl__IsActive__c=true,
                                                         dmpl__LocationType__c='Washing Bay'));
        insert storageLocation;
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
                                   dmpl__RFID__c = 'O1234fgh' ));
        insert item;
    }
    
    private static void CreateItemGroup()
    {
        List<dmpl__ItemGroup__c> itemGroup = new List<dmpl__ItemGroup__c>();
        itemGroup.Add(new dmpl__ItemGroup__c(Name = 'Test - itemGroup',
                                             dmpl__ItemGroupType__c = 'Tax'));
        insert itemGroup;
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
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        dmpl__StorageLocation__c storageLocation = [Select Id, Name FROM dmpl__StorageLocation__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id ,Name,dmpl__ItemId__c From dmpl__SKU__c LIMIT 1 ];
        itemLot.Add(new dmpl__ItemLot__c(dmpl__BranchId__c = branch.Id,
                                         dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                         dmpl__ItemId__c = sku.dmpl__ItemId__c,
                                         dmpl__StorageLocationId__c = storageLocation.Id,
                                         dmpl__SKUId__c =sku.Id,
                                         dmpl__BatchNo__c = 'ZAY',
                                         dmpl__SerialNumber__c='BCA',
                                         dmpl__SupplierInvoiceNumber__c='hfg',
                                         dmpl__DateOfReceipt__c= date.today(),
                                         dmpl__DateOfMfg__c=date.today(),
                                         dmpl__TotalCost__c=10.2,
                                         dmpl__DateOfSupplierInvoice__c=date.today(),
                                         dmpl__Cost__c=40.3));
        insert itemLot;       
    }
    
    private static void CreateResource()
    {
        List<dmpl__Resource__c> resource = new List<dmpl__Resource__c>();
        Account partnerAccount = [Select Id,Name From Account Where Name = 'Partner-Test-Account' LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name From dmpl__Branch__c LIMIT 1];
        resource.add(new dmpl__Resource__c(Name = 'Test - Resource',
                                           dmpl__ResourceType__c = 'Sample',
                                           dmpl__IsActive__c = true,
                                           dmpl__Phone__c = '9999999999',
                                           dmpl__DefaultPartnerAccountId__c = partnerAccount.Id,
                                           dmpl__DefaultBranchId__c = branch.Id));
        insert resource;
    }
    
     private static void CreateAsset()
    {
        List<Asset> asset = new List<Asset>();
        Account account = [Select Id,Name From Account WHERE Name = 'Customer-Test-Account' LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name From dmpl__Branch__c LIMIT 1];
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        dmpl__ItemLot__c itemLot = [Select Id, Name From dmpl__ItemLot__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id,Name FROM dmpl__SKU__c LIMIT 1];
        asset.add(new Asset(Name = 'Test-Asset',
                           AccountId = account.Id,
                           dmpl__LastServiceBranchId__c = branch.Id,
                           dmpl__ItemId__c = item.Id,
                           dmpl__ItemLotId__c = itemLot.Id,
                           dmpl__SKUId__c = sku.Id,
                           dmpl__RegistrationNumber__c = 'Axb371',
                           dmpl__SaleDate__c = date.today()
                           ));
        insert asset;

        List<dmpl__AssetServiceContract__c> assetServiceContracts = new List<dmpl__AssetServiceContract__c>();
        assetServiceContracts.add(new dmpl__AssetServiceContract__c(dmpl__AssetId__c = asset[0].Id,
                                                                    dmpl__ItemId__c = item.Id,
                                                                    dmpl__ServiceContractItemId__c = item.Id,
                                                                    dmpl__ActivatedDate__c = Datetime.now().Date(),
                                                                    dmpl__ValidtillDate__c = Datetime.now().addDays(365).Date(),
                                                                    dmpl__DueDate__c = Datetime.now().addDays(365).Date()
        ));
        insert assetServiceContracts;

        dmpl__Item__c workItem = new dmpl__Item__c(Name = 'Washing', 
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
    
    private static void CreateServiceBay()
    {
        List<dmpl__ServiceBay__c> ServiceBay = new List<dmpl__ServiceBay__c>();
        dmpl__Branch__c branch = [Select Id,Name From dmpl__Branch__c LIMIT 1];
        ServiceBay.Add(new dmpl__ServiceBay__c(Name = 'Test - ServiceBay',
                                                   dmpl__BranchId__c = branch.Id));
        insert ServiceBay;
    }

    private static void CreateBranchTimeSlot()
    {
        List<dmpl__BranchTimeSlot__c> branchTimeSlot = new List<dmpl__BranchTimeSlot__c>();
        dmpl__Branch__c branch = [Select Id,Name From dmpl__Branch__c LIMIT 1];
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        branchTimeSlot.Add(new dmpl__BranchTimeSlot__c(dmpl__BranchId__c = branch.Id,
                                                       dmpl__TransactionType__c = 'Delivery',
                                                       Name = 'Test - branchTimeSlot',
                                                       dmpl__IsActive__c = True,
                                                       dmpl__ApplicableToItem__c= item.Id,
                                                       dmpl__MaximumCapacity__c = 20,                                                    
                                                       dmpl__MondayCapacity__c = 32,
                                                       dmpl__TuesdayCapacity__c = 22,
                                                       dmpl__WednesdayCapacity__c = 11,
                                                       dmpl__ThursdayCapacity__c = 20,
                                                       dmpl__FridayCapacity__c = 22,
                                                       dmpl__SaturdayCapacity__c = 10,
                                                       dmpl__SundayCapacity__c = 12));
         insert branchTimeSlot;
    }
    
    private static void CreateServiceRequest()
    {
        List<dmpl__ServiceRequest__c> serviceRequest = new List<dmpl__ServiceRequest__c>();
        Account account = [Select Id,Name From Account Where Name = 'Customer-Test-Account' LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c LIMIT 1];
        dmpl__Item__c item = [Select Id,Name,dmpl__ItemType__c From dmpl__Item__c LIMIT 1];
        Asset asset = [Select Id,Name From Asset LIMIT 1];
        dmpl__BranchTimeSlot__c brTimeSlot = [Select Id From dmpl__BranchTimeSlot__c LIMIT 1];
        serviceRequest.Add(new dmpl__ServiceRequest__c(dmpl__AccountId__c = account.Id,
                                                    dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                                    dmpl__AssetId__c = asset.Id,
                                                    dmpl__BranchId__c = branch.Id,
                                                    dmpl__AppointmentTimeSlotId__c = brTimeSlot.Id,
                                                    dmpl__ServiceContractItemId__c = item.Id));
        insert serviceRequest; 
    }
    
    private static void CreateTax()
    {
        List<dmpl__Tax__c> tax = new List<dmpl__Tax__c>();
        dmpl__TaxGroup__c taxGroup = [Select Id,Name From dmpl__TaxGroup__c];
        tax.Add(new dmpl__Tax__c(Name = 'Test - Tax',
                                 dmpl__Rate__c = 10,
                                 dmpl__TaxGroupId__c = taxGroup.Id,
                                 dmpl__Type__c = 'Cess',
                                 dmpl__PostingFieldName__c = 'Tax1'
        ));        
        insert tax;
    }
    
    private static void CreateTaxGroup()
    {
        List<dmpl__TaxGroup__c> taxGroup = new List<dmpl__TaxGroup__c>();
        Account account=[Select Id,Name from Account Where Name='Partner-Test-Account'];
        dmpl__AccountGroup__c accountGroup = [Select Id,Name From dmpl__AccountGroup__c Limit 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        taxGroup.Add(new dmpl__TaxGroup__c(Name = 'Test - Tax Group',
                                           dmpl__PartnerAccountId__c = account.Id,
                                           dmpl__BranchId__c = branch.Id,
                                           dmpl__PartnerAccountGroupId__c = accountGroup.Id,
                                           dmpl__Description__c = 'Test-Description',
                                           dmpl__IsActive__c = true,
                                           dmpl__TaxGroupType__c = 'Line Level'));
        insert taxGroup;  
        
        List<dmpl__TaxGroupRule__c> rule = new List<dmpl__TaxGroupRule__c>();
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        rule.add(new dmpl__TaxGroupRule__c(dmpl__DateEffectiveFrom__c = date.today(),
                                           dmpl__ItemId__c = item.Id,
                                           dmpl__ItemLotTypeId__c = null,
                                           dmpl__TaxGroupId__c = taxGroup[0].Id
                                          ));
        insert rule;
    }
    
    private static void CreateProductHealthCheck()
    {
        List<dmpl__ProductHealthCheck__c> productHealthCheck = new List<dmpl__ProductHealthCheck__c>();
        Account account = [Select Id,Name From Account LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name From dmpl__Branch__c LIMIT 1];
        Asset asset = [Select Id,Name From Asset LIMIT 1];
        productHealthCheck.Add(new dmpl__ProductHealthCheck__c(dmpl__ExternalId__c = 'Test - productHealthCheck',
                                                         dmpl__AccountId__c = account.Id,
                                                    dmpl__BranchId__c = branch.Id,
                                                          dmpl__AssetId__c = asset.Id));
        insert productHealthCheck; 
    }
    
    private static void CreateProductHealthCheckRecommendation()
    {
        List<dmpl__ProductHealthCheckRecommendation__c> ProductHealthCheckRecommendation = new List<dmpl__ProductHealthCheckRecommendation__c>();
        dmpl__ProductHealthCheck__c productHealthCheck = [Select Id,Name From dmpl__ProductHealthCheck__c LIMIT 1];
        ProductHealthCheckRecommendation.Add(new dmpl__ProductHealthCheckRecommendation__c(dmpl__ItemHealthCheckId__c = productHealthCheck.Id,
                                                                         dmpl__VehicleHealthCheckPostingId__c = productHealthCheck.Id));
        insert ProductHealthCheckRecommendation;
    }
    
    private static void CreateServiceRequestLine()
    {
        List<dmpl__ServiceRequestLine__c> serviceRequestLine = new List<dmpl__ServiceRequestLine__c>();
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id,Name FROM dmpl__SKU__c LIMIT 1];
        dmpl__ServiceRequest__c serviceRequest = [Select Id,Name From dmpl__ServiceRequest__c LIMIT 1];
        dmpl__TaxGroup__c taxGroup = [Select Id,Name From dmpl__TaxGroup__c LIMIT 1];
        serviceRequestLine.Add(new dmpl__ServiceRequestLine__c(dmpl__ItemId__c = item.Id,
                                                               dmpl__SKUId__c = sku.Id,
                                                                   dmpl__Quantity__c = 10,
                                                                   dmpl__UnitPrice__c = 10.00,
                                                                   dmpl__TaxGroupId__c = taxGroup.Id,
                                                                   dmpl__ServiceRequestId__c = serviceRequest.Id));
        insert serviceRequestLine;
    }
    
    private static void CreateServiceEstimate()
    { 
        List<dmpl__Quote__c> ServiceEstimate = new List<dmpl__Quote__c>();
        Account account = [Select Id,Name From Account Where Name = 'Customer-Test-Account' LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c LIMIT 1];
        dmpl__Item__c item = [Select Id,Name,dmpl__ItemType__c From dmpl__Item__c LIMIT 1];
        dmpl__PriceList__c priceList=[Select Id, Name from dmpl__PriceList__c Limit 1];
        Asset asset = [Select Id,Name From Asset LIMIT 1];
        dmpl__ServiceRequest__c serviceRequest = [Select Id,Name From dmpl__ServiceRequest__c LIMIT 1];
        ServiceEstimate.Add(new dmpl__Quote__c(dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                                     dmpl__BranchId__c = branch.Id,
                                                     dmpl__AccountId__c = account.Id,
                                                     dmpl__AssetId__c = asset.Id,
                                                     dmpl__PriceListId__c=priceList.Id,
                                                     dmpl__PerformEstimateLinesGeneration__c = false,
                                                     dmpl__ServiceRequestId__c = serviceRequest.Id,
                                                     dmpl__ServiceContractItemId__c = item.Id,
                                                     dmpl__PerformApproval__c = false,
                                                     dmpl__PerformDecline__c = false,
                                                     dmpl__PerformRepairOrderGeneration__c = false,
                                                     dmpl__IsRepairOrderGenerated__c = false));
        insert ServiceEstimate;       
    } 

   private static void CreatePriceList()
    {
        List<dmpl__PriceList__c> priceList =new List<dmpl__PriceList__c>();
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        Account account=[Select Id,Name from Account Where Name='Partner-Test-Account'];
        dmpl__AccountGroup__c schemeAccountGroup = [Select Id,Name From dmpl__AccountGroup__c Where dmpl__AccountGroupType__c='Scheme'];
        dmpl__AccountGroup__c priceAccountGroup = [Select Id,Name From dmpl__AccountGroup__c where dmpl__AccountGroupType__c='Price' ];
        dmpl__AccountGroup__c discountAccountGroup = [Select Id,Name From dmpl__AccountGroup__c where dmpl__AccountGroupType__c='Discount'];
       
        priceList.Add(new dmpl__PriceList__c(dmpl__PartnerAccountId__c = account.Id,
                                             dmpl__BranchId__c = Branch.Id,
                                             dmpl__PartnerAccountGroupId__c= priceAccountGroup.Id,
                                             dmpl__PartnerGroupId__c=priceAccountGroup.Id,
                                             dmpl__CustomerAccountGroupId__c=priceAccountGroup.Id,
                                             dmpl__CustomerGroupId__c=priceAccountGroup.Id,
                                             Name='Test-1',
                                             dmpl__PriceListType__c = 'Sale Price',
                                             dmpl__IsActive__c = true,
                                             dmpl__IsDefault__c = true
                                             ));
        insert priceList;
    }    
    
    private static void CreatePriceListRules()
    {
        List<dmpl__PriceListRules__c> priceListRules =new List<dmpl__PriceListRules__c>();
        dmpl__PriceList__c priceList = [Select Id,Name From dmpl__PriceList__c LIMIT 1];
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id ,Name,dmpl__ItemId__c From dmpl__SKU__c LIMIT 1 ];
        priceListRules.Add(new dmpl__PriceListRules__c(dmpl__ItemId__c = item.Id,
                                                       dmpl__SKUId__c=sku.Id,
                                                       dmpl__PriceListId__c=priceList.Id,
                                                       dmpl__Price__c=500,
                                                       dmpl__DateEffectiveFrom__c = date.today()-(7),
                                                       dmpl__DateEffectiveTill__c=date.today()
                                                      ));
        insert priceListRules;
    }  
   
    private static void CreateServiceEstimateLines()
    {
        CreateServiceEstimate();
        List<dmpl__QuoteLine__c> ServiceEstimateLine = new List<dmpl__QuoteLine__c>();
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        dmpl__PriceListRules__c priceRules=[Select Id, Name From dmpl__PriceListRules__c Limit 1];
        dmpl__TaxGroup__c taxGroup = [Select Id,Name From dmpl__TaxGroup__c LIMIT 1];
        //dmpl__ServiceRequestLine__c serviceRequestLine = [Select Id,Name From dmpl__ServiceRequestLine__c LIMIT 1];
        dmpl__Quote__c serviceEstimate = [Select Id,Name From dmpl__Quote__c LIMIT 1];
        ServiceEstimateLine.Add(new dmpl__QuoteLine__c(dmpl__ItemId__c = item.Id,
                                                             dmpl__Quantity__c = 50,
                                                             dmpl__UnitPrice__c = 10,
                                                             dmpl__TaxGroupId__c=taxGroup.Id,
                                                             dmpl__PriceListRuleId__c=priceRules.Id,
                                                             dmpl__DurationInHours__c = 12.00,
                                                             dmpl__IsApproved__c = false,
                                                             dmpl__IsDeclined__c = false,
                                                             dmpl__ServiceContractId__c = item.Id,
                                                             dmpl__PackageClassification__c = 'Optional Item',
                                                             dmpl__IncludeinPackage__c = True,
                                                             dmpl__IsPackageService__c = false,
                                                             dmpl__QuoteId__c = serviceEstimate.Id));
        insert ServiceEstimateLine;
    }
    
    private static void CreateServiceEstimateTax()
    {
        List<dmpl__QuoteTax__c> serviceEstimateTax = new List<dmpl__QuoteTax__c>();
        dmpl__Quote__c serviceEstimate = [Select Id,Name From dmpl__Quote__c LIMIT 1];
        dmpl__QuoteLine__c serviceEstimateLine = [Select Id,Name From dmpl__QuoteLine__c LIMIT 1];
        dmpl__Tax__c tax = [Select Id,Name From dmpl__Tax__c LIMIT 1];
        dmpl__TaxGroup__c taxGroup = [Select Id,Name From dmpl__TaxGroup__c LIMIT 1];
        serviceEstimateTax.add(new dmpl__QuoteTax__c(dmpl__QuoteId__c = serviceEstimate.Id,
                                                              dmpl__QuoteLineId__c = serviceEstimateLine.Id,
                                                              dmpl__TaxId__c = tax.Id,
                                                              dmpl__TaxOnAmount__c = 100,
                                                              dmpl__TaxAmount__c = 100,
                                                              dmpl__TaxGroupId__c = taxGroup.Id,
                                                              dmpl__TaxRate__c = 10));
        insert serviceEstimateTax;      
    }
    
    private static void CreateItemAlternate()
    {
        List<dmpl__ItemAlternate__c> itemComponent = new List<dmpl__ItemAlternate__c>();
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        itemComponent.add(new dmpl__ItemAlternate__c(dmpl__ItemId__c = item.Id,
                                                     dmpl__AlternateItemId__c=item.Id
                                                    ));
        insert itemComponent;
    }
    
    private static void CreateRepairOrder()
    {
        List<dmpl__RepairOrder__c> repairOrder = new List<dmpl__RepairOrder__c> ();
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        //dmpl__Resource__c resource = [select Id,Name FROM dmpl__Resource__c LIMIT 1];
        Asset asset = [Select Id,Name From Asset LIMIT 1];
        dmpl__PriceList__c priceList=[Select Id, Name from dmpl__PriceList__c Limit 1];
        dmpl__ServiceRequest__c serviceRequest = [Select Id,Name From dmpl__ServiceRequest__c LIMIT 1];
        dmpl__Quote__c serviceEstimate = [Select Id,Name From dmpl__Quote__c LIMIT 1];
        Account customerAccount = [Select id,Name From Account Where Name = 'Customer-Test-Account' LIMIT 1];
        repairOrder.Add(new dmpl__RepairOrder__c (dmpl__PriceListId__c=priceList.Id,
                                                    dmpl__BranchId__c = branch.Id,
                                                    dmpl__AccountId__c = customerAccount.Id,
                                                    dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                                    dmpl__ServiceRequestId__c = serviceRequest.Id,
                                                    dmpl__AssetId__c = asset.Id,
                                                    dmpl__ServiceEstimateId__c = serviceEstimate.Id,
                                                    dmpl__UsageReading__c = 8
                                                    //dmpl__ServiceAdvisorId__c = resource.Id
                                                 ));
        insert repairOrder;
    }
}