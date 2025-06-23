@isTest
public class ComplaintLineHelper_Test {

    @testsetup
    public static void setup()
    {
        //System.runAs(PostInstallHelper.AssignAdministratorAllPermissions(UserInfo.getUserId())){
            CreateAccountGroup();
            CreateAccount();
            CreateBranch();
            CreateStorageLocation();
            CreateItems();
            CreateSKu();
            CreatePriceList();
            CreateItemComponent();
            CreateItemLot();        
            CreateResource();
            CreateItemServiceContract();
            CreateAsset();
            CreateServiceBay();
            CreateBranchTimeSlot();
            CreateTaxGroup();
            test.startTest();
            CreateServiceRequest();
            CreateServiceRequestLine();
            CreateServiceEstimate();
            CreateComplaintLine();
            test.stopTest();
     //}
    }
    
    @isTest
    private static void VerifyComplaintLineUpdate()
    {
        test.startTest();
        
        List<dmpl__ServiceRecommendation__c> currentServiceRecommendation = [SELECT Id,Name,dmpl__ComplaintItemId__c,dmpl__ComplaintLineId__c FROM dmpl__ServiceRecommendation__c];
        System.debug('recomm'+currentServiceRecommendation.size());
        currentServiceRecommendation[0].dmpl__ComplaintItemId__c = null;
        currentServiceRecommendation[0].dmpl__ComplaintLineId__c = null;
        update currentServiceRecommendation;
        
        List<dmpl__Complaint__c> newComplaints = new List<dmpl__Complaint__c>();
        dmpl__Item__c item = [SELECT Id,Name FROM dmpl__Item__c LIMIT 1];
        newComplaints.add(new dmpl__Complaint__c(dmpl__Code__c = 'COMPL-002',Name = 'Test1'));
        insert newComplaints;
        
        insert new dmpl__ComplaintItem__c(
           dmpl__ComplaintId__c = newComplaints[0].Id,
           dmpl__ItemId__c = item.Id
       );
        
        List<dmpl__ComplaintLine__c> complaintLines = [SELECT Id,Name,dmpl__ComplaintId__c FROM dmpl__ComplaintLine__c];
        complaintLines[0].dmpl__ComplaintId__c = newComplaints[0].Id;
        update complaintLines;
        test.stopTest();
    }
    
    @isTest
    private static void VerifyGetServiceRecommendations()
    {
         dmpl__Quote__c quote = [SELECT Id,Name FROM dmpl__Quote__c LIMIT 1];
        List<dmpl__ServiceRecommendation__c> currentServiceRecommendation = [SELECT Id,Name,dmpl__ComplaintItemId__c,dmpl__ComplaintLineId__c FROM dmpl__ServiceRecommendation__c];
        ServiceRecommendationController.getServiceRecommendations('Id',currentServiceRecommendation[0].Id);
        ServiceRecommendationController.performAction(currentServiceRecommendation[0].Id,'reject',null);
        ServiceRecommendationController.getChecklistServiceRecommendations(currentServiceRecommendation[0].Id,quote.Id);
    }
    
    @isTest
    private static void VerifyComplaintLineDelete()
    {
        test.startTest();
       
        List<dmpl__ComplaintLine__c> complaintLines = [SELECT Id,Name,dmpl__ComplaintId__c FROM dmpl__ComplaintLine__c];
        delete complaintLines;
        
        test.stopTest();
    }
        
    private static void CreateAccountGroup()
    {
    	dmpl__AccountGroup__c accountGroup= new dmpl__AccountGroup__c (Name= 'Test-AccountGroup', 
                                                                       dmpl__AccountGroupType__c='Discount');
        insert accountGroup;
    }
    
    private static void CreateAccount()
    {
        List<Account> account = new List<Account>();
        dmpl__AccountGroup__c accountGroup = [Select Id,Name From dmpl__AccountGroup__c where dmpl__AccountGroupType__c='Discount' LIMIT 1];
        account.add(new Account(Name = 'Test - Account', 
                               dmpl__LastName__c = 'Service Request',
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
                                             dmpl__LastName__c = 'Service Request',
                                             dmpl__IsPartnerAccount__c = True, 
                                             dmpl__IsActive__c = true);
        insert partneraccount;
        
        Account customerAccount = new Account(Name = 'Customer-Test-Account',
                                              dmpl__LastName__c = 'Service Request',
                                              dmpl__IsCustomerAccount__c = True,
                                              dmpl__IsActive__c = true);
        insert customerAccount;
        
         dmpl__AccountGroupMember__c partnerAccountGroupMember = new dmpl__AccountGroupMember__c
            (dmpl__AccountGroupId__c=accountGroup.Id,
             dmpl__AccountId__c=partneraccount.Id
            );
        Insert partnerAccountGroupMember;
        
        dmpl__AccountGroupMember__c customerAccountGroupMember = new dmpl__AccountGroupMember__c
            (dmpl__AccountGroupId__c=accountGroup.Id,
             dmpl__AccountId__c=customerAccount.Id
            );
        Insert customerAccountGroupMember;
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
                                   dmpl__RFID__c = 'O1234fgh'
        ));
        
        item.Add(new dmpl__Item__c(Name = 'Test-Item',
                                   dmpl__ItemCode__c = 'DMPL-2',
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
                                   dmpl__IsPackage__c = true
        ));
        insert item;
       
        dmpl__Item__c workItem = new dmpl__Item__c(Name = 'Washing',
                                   dmpl__ItemCode__c = 'Washing',
                                   dmpl__ItemType__c = 'Work Item',
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
                                   dmpl__GTIN__c = 'BR1234',
                                   dmpl__RFID__c = 'O1234fghi');
        insert workItem;
    }
    private static void CreatePriceList()
    {
        List<dmpl__PriceList__c> priceList =new List<dmpl__PriceList__c>();
        //dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
       // Account account=[Select Id,Name from Account Where Name='Partner-Test-Account' LIMIT 1];
        priceList.Add(new dmpl__PriceList__c(//dmpl__PartnerAccountId__c = account.Id,
                                           // dmpl__BranchId__c = Branch.Id,
                                            //dmpl__PartnerAccountGroupId__c= accountGroup.Id,
                                            //dmpl__PartnerGroupId__c=accountGroup.Id,
                                            //dmpl__CustomerAccountGroupId__c=accountGroup.Id,
                                            //dmpl__CustomerGroupId__c=accountGroup.Id,
                                            Name='Test-1',
                                            dmpl__PriceListType__c = 'Sale Price',
                                            dmpl__IsActive__c = true
                                            ));
        insert priceList;
        
        List<dmpl__PriceListRules__c> priceListRules =new List<dmpl__PriceListRules__c>();
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        priceListRules.Add(new dmpl__PriceListRules__c(dmpl__ItemId__c = item.Id,
                                                       dmpl__PriceListId__c = priceList[0].Id,
                                                       dmpl__Price__c = 500,
                                                       dmpl__DateEffectiveFrom__c = date.today()
                                                      ));
        insert priceListRules;
        
    }
    
    private static void CreateItemComponent()
    {
        List<dmpl__ItemComponent__c> itemComponent = new List<dmpl__ItemComponent__c>();
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id,Name From dmpl__SKU__c LIMIT 1];
        itemComponent.add(new dmpl__ItemComponent__c(dmpl__ItemId__c = item.Id,
                                                     dmpl__SKUId__c = sku.Id,
                                                     dmpl__PackageType__c='Multiple Of Package',
                                                     dmpl__ComponentItemId__c=item.Id,
                                                     dmpl__Quantity__c=2,
                                                     dmpl__SortOrder__c = 100));
        insert itemComponent;
    }
    
    private static void CreateSKu()
    {
        List<dmpl__SKU__c> sku = new List<dmpl__SKU__c>();
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        dmpl__Item__c item2 = [Select Id,Name From dmpl__Item__c WHERE dmpl__IsPackage__c = true];
        sku.add(new dmpl__SKU__c(Name = 'Test - SKU',
                                 dmpl__SKUCode__c = 'Test - SKU - Code',
                                 dmpl__UnitOfMeasureOfConversion__c = 10,
                                 dmpl__ProductColor__c = 'Sample',
                                 dmpl__IsDefault__c = false,
                                 dmpl__QuantityUnitOfMeasure__c ='Sample',
                                 dmpl__ItemId__c = item.Id));
        sku.add(new dmpl__SKU__c(Name = 'Test - SKU2',
                                 dmpl__SKUCode__c = 'Test - SKU - Code',
                                 dmpl__UnitOfMeasureOfConversion__c = 10,
                                 dmpl__ProductColor__c = 'Sample',
                                 dmpl__IsDefault__c = false,
                                 dmpl__QuantityUnitOfMeasure__c ='Sample',
                                 dmpl__ItemId__c = item2.Id));
        insert sku;      
    }
    
    private static void CreateResource()
    {
        List<dmpl__Resource__c> resource = new List<dmpl__Resource__c>();
        Account partnerAccount = [Select Id,Name From Account LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c LIMIT 1];
        resource.add(new dmpl__Resource__c(Name = 'Test - Resource',
                                           dmpl__ResourceType__c = 'Sample',
                                           dmpl__IsActive__c = true,
                                           dmpl__Phone__c = '9999999999',
                                           dmpl__DefaultPartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                           dmpl__DefaultBranchId__c = branch.Id
                                          ));
        insert resource;
        
        List<dmpl__PartnerResource__c> partnerResources = new List<dmpl__PartnerResource__c>();
        partnerResources.Add(new dmpl__PartnerResource__c(dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                    dmpl__BranchId__c= branch.Id,
                                    dmpl__ResourceId__c= resource[0].Id,               
                                    dmpl__RuleSuccessCriteria__c='Any Rule Is Met',
                                    dmpl__AssignmentSequenceNumber__c=12));
        insert partnerResources;
        
        List<dmpl__ResourceAssignmentRule__c> assignmentRule = new List<dmpl__ResourceAssignmentRule__c>();
        assignmentRule.Add(new dmpl__ResourceAssignmentRule__c(dmpl__PartnerResourceId__c = partnerResources[0].Id,
                                                               dmpl__FieldName__c = 'dmpl__Remarks__c',	
                                                              dmpl__FieldValue__c = 'Test Remarks',
                                                               dmpl__Operation__c = 'equals',
                                                               dmpl__SequenceNumber__c=1));
        insert assignmentRule;    
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
                                                                    dmpl__ValidtillDate__c = Datetime.now().Date() + 365,
                                                                    dmpl__DueDate__c = Datetime.now().addDays(365).Date()
        ));
        insert assetServiceContracts;

        dmpl__Item__c workItem = new dmpl__Item__c(Name = 'Washing', 
                                                    dmpl__ItemCode__c = 'Washing', 
                                                    dmpl__ItemType__c = 'Work Item',
                                                    dmpl__IsActive__c = true);
        insert workItem;

        dmpl__AssetServiceContractLine__c assetServiceContractLine = new dmpl__AssetServiceContractLine__c(dmpl__AssetServiceContractId__c = assetServiceContracts[0].Id,
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
    
    private static void CreateTaxGroup()
    {
        List<dmpl__TaxGroup__c> taxGroup = new List<dmpl__TaxGroup__c>();
        Account account=[Select Id,Name from Account Where Name='Partner-Test-Account'];
        dmpl__AccountGroup__c accountGroup = [Select Id,Name From dmpl__AccountGroup__c];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        taxGroup.Add(new dmpl__TaxGroup__c(Name = 'Test - Tax Group',
                                           dmpl__PartnerAccountId__c = account.Id,
                                           dmpl__BranchId__c = branch.Id,
                                           dmpl__PartnerAccountGroupId__c = accountGroup.Id,
                                           dmpl__Description__c = 'Test-Description',
                                           dmpl__IsActive__c = true));
        insert taxGroup;
    }
    
    private static void CreateItemServiceContract()
    {
        List<dmpl__ItemServiceContract__c> serviceContract = new List<dmpl__ItemServiceContract__c>();
        dmpl__Item__c item = [Select Id,Name FROm dmpl__Item__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id,Name FROM dmpl__SKU__c LIMIT 1];
        serviceContract.add(new dmpl__ItemServiceContract__c(dmpl__ItemId__c = item.Id,
                                                             dmpl__SKUId__c = sku.Id,
                                                             dmpl__MaximumUsageHours__c = 10,
                                                             dmpl__MaximumUsageReading__c = 10,
                                                             dmpl__MinimumUsageHours__c = 10,
                                                             dmpl__MinimumUsageReading__c = 10,
                                                             dmpl__GraceUsageDays__c = 2,
                                                             dmpl__FromDays__c = 2,
                                                             dmpl__GraceUsageHours__c = 5,
                                                             dmpl__GraceUsageReading__c = 5,
                                                             dmpl__ToDays__c = 5
                                                            ));
        insert serviceContract;
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
    
    private static void CreateServiceRequestLine()
    {
        List<dmpl__ServiceRequestLine__c> serviceRequestLine = new List<ServiceRequestLine__c>();
        dmpl__ServiceRequest__c serviceRequest = [Select Id,Name From dmpl__ServiceRequest__c LIMIT 1];
        List<dmpl__PriceListRules__c> priceListRule = [SELECT Id,Name FROM dmpl__PriceListRules__c LIMIT 1];
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id,Name FROM dmpl__SKU__c LIMIT 1];
        dmpl__TaxGroup__c taxGroup = [Select Id,Name From dmpl__taxGroup__c LIMIT 1];
        serviceRequestLine.add(new dmpl__ServiceRequestLine__c(dmpl__ServiceRequestId__c = serviceRequest.Id,
                                                              dmpl__ItemId__c = item.Id,
                                                              dmpl__Quantity__c = 10,
                                                              dmpl__UnitPrice__c = 100,
                                                              dmpl__TaxGroupId__c = taxGroup.Id,
                                                              dmpl__SKUId__c = sku.Id,
                                                              dmpl__PriceListRuleId__c = priceListRule[0].Id
                                                              ));
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
    
    private static void CreateComplaintLine()
    {
       dmpl__ServiceRequest__c serviceRequest = [Select Id,Name From dmpl__ServiceRequest__c LIMIT 1];
       dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
       dmpl__Quote__c quote = [SELECT Id,Name FROM dmpl__Quote__c LIMIT 1];
        
       List<dmpl__Complaint__c> newComplaints = new List<dmpl__Complaint__c>();
       newComplaints.add(new dmpl__Complaint__c(dmpl__Code__c = 'COMPL-001',Name = 'Test'));
       insert newComplaints;
        
       insert new dmpl__ComplaintItem__c(
           dmpl__ComplaintId__c = newComplaints[0].Id,
           dmpl__ItemId__c = item.Id
       );
       
       insert new dmpl__ComplaintLine__c(
           dmpl__ComplaintId__c = newComplaints[0].Id,
           dmpl__ServiceRequestId__c = serviceRequest.Id,
           dmpl__ServiceEstimateId__c = quote.Id
       );
    }
}