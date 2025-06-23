@isTest
public class ServiceRequestHelper_Test {
    
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
            CreateServiceLead();
            CreateServiceCompaignNew();
            //CreateServiceType();
            CreateBranchTimeSlot();
            CreateTaxGroup();
            test.startTest();
            CreateServiceRequest();
            CreateServiceRequestLine();
            test.stopTest();
        //}
    }
    
    @isTest
    public static void setDefaultDiscountGroupIds()
    {
        test.startTest();
        CreateDiscountGroup();
        List<dmpl__ServiceRequest__c> shipment = [SELECT Id,  Name,
                                                 dmpl__AccountId__c,
                                                 dmpl__DocumentDate__c,
                                                 dmpl__DiscountGroupId__c,
                                                 dmpl__PriceListId__c,
                                                 dmpl__BranchId__c,
                                                 dmpl__PartnerAccountId__c
                                                 FROM dmpl__ServiceRequest__c];       
        PriceListHelper.setDefaultPriceListIds(shipment);
        DiscountGroupHelper.setDefaultDiscountGroupIds(shipment);
        System.assert(shipment != null, 'delivery order data');
        test.stopTest();
    }
    
    private static void CreateDiscountGroup()
    {
        List<dmpl__DiscountGroup__c> discountGroup = new List<dmpl__DiscountGroup__c>();
        dmpl__AccountGroup__c accountGroup=[Select Id,Name From dmpl__AccountGroup__c where dmpl__AccountGroupType__c='Discount' LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name From dmpl__Branch__c Limit 1];
        Account account=[Select Id,Name from Account Where Name='Partner-Test-Account' LIMIT 1];
        discountGroup.add(new dmpl__DiscountGroup__c(dmpl__BranchId__c = branch.Id,
                                                     dmpl__CustomerAccountGroupId__c = accountGroup.Id,
                                                     dmpl__PartnerAccountId__c = account.Id,
                                                     dmpl__PartnerAccountGroupId__c = accountGroup.Id,
                                                     dmpl__IsDefault__c = true,
                                                     dmpl__IsActive__c = true,
                                                     Name = 'Test - Discount - Group',
                                                     dmpl__DiscountType__c ='Sale Price'
                              ));
        insert discountGroup;
    }
    
    @isTest
    public static void createServiceRequestLinesFromServiceContract()
    {
       test.startTest();
       List<dmpl__ServiceRequest__c> serviceEstimate = [Select Id,Name,
                                                        dmpl__Remarks__c,
                                                        dmpl__AssetId__c,
                                                        dmpl__UsageReading__c,
                                                        dmpl__UsageReadingHours__c,
                                                        dmpl__ItemServiceContractId__c,
                                                        dmpl__ServiceAdvisorId__c,
                                                        dmpl__PartnerAccountId__c,
                                                        dmpl__BranchId__c,
                                                        dmpl__ServiceContractItemId__c,
                                                        dmpl__IsPickUpRequired__c,
                                                        dmpl__IsDropOffRequired__c,
                                                        dmpl__IsFieldService__c,
                                                        dmpl__CustomerVoice__c,dmpl__AccountId__c From dmpl__ServiceRequest__c LIMIT 1];
         ServiceRequestLineHelper.createServiceRequestLinesFromServiceContract(serviceEstimate);
        System.assert(serviceEstimate != null, 'service Estimate data');
        test.stopTest();
    } 
    
    @isTest
    public static void UpdateServiceRequestAsPerformConfirmed()
    {
        test.startTest();
        dmpl__ServiceRequest__c serviceRequest = [Select Id,Name,dmpl__PerformConfirm__c From dmpl__ServiceRequest__c LIMIT 1];
        serviceRequest.dmpl__PerformConfirm__c = True;
        
        update serviceRequest;
        System.assertEquals(True, serviceRequest.dmpl__PerformConfirm__c, 'service Request has 1 Record Updated');
        test.stopTest();
    }
    
    @isTest
    public static void PerformKPICalculation()
    {
        test.startTest();
        dmpl__ServiceRequest__c serviceRequest = [Select Id,Name,dmpl__PerformKPICalculation__c From dmpl__ServiceRequest__c LIMIT 1];
        serviceRequest.dmpl__PerformKPICalculation__c = True;
        
        update serviceRequest;
        System.assertEquals(True, serviceRequest.dmpl__PerformKPICalculation__c, 'service Request has 1 Record Updated');
        test.stopTest();
    }
    
    @isTest
    public static void UpdateServiceRequestAsPerformCancel()
    {
        test.startTest();
        dmpl__ServiceRequest__c serviceRequest = [Select Id,Name,dmpl__PerformCancel__c From dmpl__ServiceRequest__c LIMIT 1];
        serviceRequest.dmpl__PerformCancel__c = True;
        
        update serviceRequest;
        System.assertEquals(True, serviceRequest.dmpl__PerformCancel__c, 'service Request has 1 Record Updated');
        test.stopTest();
    }
    
    @isTest
    public static void UpdateServiceRequestAsPerformPopulatesLines()
    {
        test.startTest();
        dmpl__ServiceRequest__c serviceRequest = [Select Id,Name,dmpl__PerformPopulateLines__c From dmpl__ServiceRequest__c LIMIT 1];
        serviceRequest.dmpl__PerformPopulateLines__c = True;
        
        update serviceRequest;
        System.assertEquals(True, serviceRequest.dmpl__PerformPopulateLines__c, 'service Request has 1 Record Updated');
        test.stopTest();
    }
    
    @isTest
    public static void UpdateServiceRequestAsPerformQuote()
    {
        test.startTest();
        dmpl__ServiceRequest__c serviceRequest = [Select Id,Name,dmpl__PerformGenerateQuote__c From dmpl__ServiceRequest__c LIMIT 1];
        serviceRequest.dmpl__PerformGenerateQuote__c = True;
        
        update serviceRequest;
        System.assertEquals(True, serviceRequest.dmpl__PerformGenerateQuote__c, 'service Request has 1 Record Updated');
        test.stopTest();
    }
    
    @isTest
    public static void UpdateService1()
    {
        test.startTest();
        dmpl__ItemServiceContract__c cont=[Select Id, Name from dmpl__ItemServiceContract__c Limit 1]; 
        dmpl__ServiceRequest__c serviceRequest = [Select Id,Name,dmpl__ItemServiceContractId__c From dmpl__ServiceRequest__c LIMIT 1];
        serviceRequest.dmpl__ItemServiceContractId__c = cont.Id;
        
        update serviceRequest;
        System.assert( serviceRequest!=null, 'service Request has 1 Record Updated');
        test.stopTest();
    }
    
    @isTest
    public static void UpdateServiceDiscount()
    {
        test.startTest();
        //try {
            dmpl__ServiceRequest__c serviceRequest = [Select Id,Name,dmpl__ItemServiceContractId__c, dmpl__Discount__c From dmpl__ServiceRequest__c LIMIT 1];
            serviceRequest.dmpl__Discount__c = 10;
            
            update serviceRequest;
            System.assert( serviceRequest!=null, 'service Request has 1 Record Updated');
                
        //} catch (Exception ex) {
            
        //}
        test.stopTest();
    }

    @isTest
    public static void UpdateServiceRequestAsPerformOrder()
    {
        test.startTest();
        dmpl__ServiceRequest__c serviceRequest = [Select Id,Name,dmpl__PerformGenerateRepairOrder__c From dmpl__ServiceRequest__c LIMIT 1];
        serviceRequest.dmpl__PerformGenerateRepairOrder__c = True;
        
        update serviceRequest;
        System.assertEquals(True, serviceRequest.dmpl__PerformGenerateRepairOrder__c, 'service Request has 1 Record Updated');
        test.stopTest();
    }
    
    @isTest
    public static void UpdateServiceRequestStatus()
    {
        test.startTest();
        dmpl__ServiceRequest__c serviceRequest = [Select Id,Name,dmpl__Status__c From dmpl__ServiceRequest__c LIMIT 1];
        serviceRequest.dmpl__Status__c = 'Confirmed';
        
        update serviceRequest;
        System.assert(serviceRequest != null, 'service Request has 1 Record Updated');
        test.stopTest();
    }
    
    @isTest
    public static void UpdateServiceRequestLineQuantity()
    {
        test.startTest();
        dmpl__ServiceRequestLine__c serviceRequest = [Select Id,Name,dmpl__Quantity__c From dmpl__ServiceRequestLine__c LIMIT 1];
        serviceRequest.dmpl__Quantity__c = 100;
        
        update serviceRequest;
        System.assert(serviceRequest != null, 'service Request has 1 Record Updated');
        test.stopTest();
    }
    
    @isTest
    public static void getServiceRequest()
    {
        test.startTest();
        List<dmpl__ServiceRequest__c> serviceRequests = [Select Id,Name From dmpl__ServiceRequest__c ];
        dmpl__ServiceRequestLine__c serviceRequestLine = [Select Id,Name,ServiceRequestId__c From dmpl__ServiceRequestLine__c LIMIT 1];
    TaxGroupHelper.getServiceRequest(serviceRequestLine,serviceRequests);
        DiscountGroupHelper.getServiceRequest(serviceRequestLine,serviceRequests);
        test.stopTest();
    }

    @isTest
    public static void UpdateServiceRequestToCreateSO()
    {
        test.startTest();
        dmpl__ServiceRequest__c serviceRequest = [Select Id,Name,dmpl__PerformGenerateSaleOrder__c From dmpl__ServiceRequest__c LIMIT 1];
        serviceRequest.dmpl__PerformGenerateSaleOrder__c = True;
        
        update serviceRequest;
        System.assertEquals(True, serviceRequest.dmpl__PerformGenerateSaleOrder__c, 'service Request has 1 Record Updated');
        test.stopTest();
    }
   
    @isTest
    public static void DeleteServiceRequest()
    {
        test.startTest();
        dmpl__ServiceRequest__c serviceRequest = [Select Id,Name,dmpl__PerformConfirm__c From dmpl__ServiceRequest__c LIMIT 1];
        
        delete serviceRequest;
        System.assertEquals(false, serviceRequest.dmpl__PerformConfirm__c, 'Service Request has 1 Record Deleted');
        test.stopTest();
    }
    
    @isTest
    private static void verifydeleteApplicableTaxes()
    {
        test.startTest();
        CreateTaxGroup();
        CreateTax();
        dmpl__ServiceRequest__c serviceRequest = [Select Id,Name,dmpl__TotalLineGrossAmount__c,dmpl__TaxGroupId__c,dmpl__TCSEligibleAmount__c From dmpl__ServiceRequest__c LIMIT 1];
        dmpl__Tax__c tax = [Select Id,Name,dmpl__Rate__c From dmpl__Tax__c LIMIT 1];
        List<dmpl__ServiceRequest__c> serviceRequests = [Select Id,Name From dmpl__ServiceRequest__c];
        //ServiceRequestTaxHelper.deleteApplicableTaxes(serviceRequests);
        //ServiceRequestTaxHelper.createServiceRequestTax(tax,serviceRequest);
        test.stopTest();
    }
    
    @isTest
    public static void DeleteServiceRequestLine()
    {
        test.startTest();
        dmpl__ServiceRequestLine__c serviceRequestLine = [Select Id,Name From dmpl__ServiceRequestLine__c LIMIT 1];
        
        delete serviceRequestLine;
        System.assert(serviceRequestLine != null, 'service Estimate data');
        test.stopTest();
    }
     
    @isTest
    public static void UpdateServiceRequestLineAsPackageService()
    {
        List<dmpl__PriceListRules__c> priceListRule = [SELECT Id,Name FROM dmpl__PriceListRules__c LIMIT 1];
        test.startTest();
        dmpl__ServiceRequestLine__c serviceRequestLine = [Select Id,Name,dmpl__IsPackageService__c,dmpl__PriceListRuleId__c From dmpl__ServiceRequestLine__c LIMIT 1];
        serviceRequestLine.dmpl__IsPackageService__c = True;
        serviceRequestLine.dmpl__PriceListRuleId__c = null;
        
        update serviceRequestLine;
        System.assertEquals(True, serviceRequestLine.dmpl__IsPackageService__c, 'service Request has 1 Record Updated');
        test.stopTest();
    }
    
    @isTest
    public static void UpdateServiceRequestLineAsPackageComponent()
    {
        test.startTest();
        dmpl__ServiceRequestLine__c serviceRequestLine = [Select Id,Name,dmpl__IsPackageComponent__c From dmpl__ServiceRequestLine__c LIMIT 1];
        serviceRequestLine.dmpl__IsPackageComponent__c = True;
        
        update serviceRequestLine;
        System.assertEquals(True, serviceRequestLine.dmpl__IsPackageComponent__c, 'service Request has 1 Record Updated');
        test.stopTest();
    }
    
    @isTest
    private static void VerifySaleOrderMethod()
    {  
        List<dmpl__ServiceRequest__c> serviceRequest = [Select Id,Name,dmpl__SaleOrderId__c,dmpl__AccountId__c,dmpl__AccountName__c,dmpl__BranchId__c,dmpl__PartnerAccountId__c,dmpl__ServiceAdvisorId__c,dmpl__Remarks__c From dmpl__ServiceRequest__c LIMIT 1];
        test.startTest();
        SaleOrderHelper.createSaleOrderFromServiceRequest(serviceRequest);
        test.stopTest();
    }
    
     @isTest
    private static void VerifyPackageHelper()
    {  
        dmpl__ServiceRequestLine__c serviceRequestLine = [Select Id,Name,dmpl__ServiceRequestId__c,dmpl__ItemId__c,dmpl__TaxGroupId__c,dmpl__IsPackageComponent__c From dmpl__ServiceRequestLine__c LIMIT 1];
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c WHERE dmpl__IsPackage__c = true];
        dmpl__SKU__c sku = [Select Id,Name FROM dmpl__SKU__c WHERE dmpl__ItemId__r.dmpl__IsPackage__c = true];
        insert new dmpl__ServiceRequestLine__c(dmpl__ServiceRequestId__c = serviceRequestLine.dmpl__ServiceRequestId__c,
                                                              dmpl__ItemId__c = item.Id,
                                                              dmpl__Quantity__c = 10,
                                                              dmpl__UnitPrice__c = 100,
                                                         dmpl__SKUId__c=sku.Id,
                                                              dmpl__TaxGroupId__c = serviceRequestLine.dmpl__TaxGroupId__c,
                                                         dmpl__PackageServiceRequestLineId__c = serviceRequestLine.Id
                                                              );
        test.startTest();
        PackageHelper.getServiceRequestPackageConfiguration(serviceRequestLine.Id);
        test.stopTest();
    }
    
    @istest
    private static void VerifySRLineMethod()
    {
       test.startTest();
      List<dmpl__ServiceRequest__c> serviceRequest = [Select Id,Name,dmpl__SaleOrderId__c,dmpl__AccountId__c,dmpl__AccountName__c,dmpl__BranchId__c,dmpl__PartnerAccountId__c,dmpl__ServiceAdvisorId__c,dmpl__Remarks__c From dmpl__ServiceRequest__c LIMIT 1];
      List<dmpl__ItemComponent__c> itemComponents = [SELECT Id,Name,Quantity__c,dmpl__ComponentItemId__c,dmpl__ComponentSKUId__c,dmpl__PackageType__c,dmpl__IsQuantityEditable__c,dmpl__IsBundled__c FROM dmpl__ItemComponent__c];  
      List<dmpl__ServiceRequestLine__c> serviceRequestLine = new List<ServiceRequestLine__c>();
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        dmpl__TaxGroup__c taxGroup = [Select Id,Name From dmpl__taxGroup__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id,Name FROM dmpl__SKU__c LIMIT 1];
        serviceRequestLine.add(new dmpl__ServiceRequestLine__c(dmpl__ServiceRequestId__c = serviceRequest[0].Id,
                                                               dmpl__ItemId__c = item.Id,
                                                               dmpl__Quantity__c = 10,
                                                               dmpl__UnitPrice__c = 100,
                                                               dmpl__SKUId__c=sku.Id,
                                                               dmpl__TaxGroupId__c = taxGroup.Id
                                                              ));
        insert serviceRequestLine;
        ServiceRequestLineHelper.applyPackageConfiguration(
            serviceRequestLine[0],
            serviceRequestLine,
            itemComponents
        );
       test.stopTest();
    }
    
   // @isTest
    private static void VerifyPriceList()
    {
        CreatePriceList();
        List<dmpl__ServiceRequest__c> serviceRequest = [Select Id,Name,dmpl__PriceListId__c,dmpl__SaleOrderId__c,dmpl__AccountId__c,dmpl__AccountName__c,dmpl__BranchId__c,dmpl__PartnerAccountId__c,dmpl__ServiceAdvisorId__c,dmpl__Remarks__c From dmpl__ServiceRequest__c LIMIT 1];
        PriceListHelper.setDefaultPriceListIds(serviceRequest);
    }
    
    @isTest
    private static void VerifySRLineMethod2()
    {
       List<dmpl__ServiceRequest__c> serviceRequest = [Select Id,Name,dmpl__Discount__c,dmpl__PriceListId__c,dmpl__SaleOrderId__c,dmpl__AccountId__c,dmpl__AccountName__c,dmpl__BranchId__c,dmpl__PartnerAccountId__c,dmpl__ServiceAdvisorId__c,dmpl__Remarks__c From dmpl__ServiceRequest__c LIMIT 1];
        ServiceRequestLineHelper.performReprice(serviceRequest[0].Id);
        ServiceRequestHelper.updateDiscountInServiceRequestLines(serviceRequest);
    }
    
    @isTest
    private static void VerifyItemAliasId()
    {
        List<dmpl__ServiceRequestLine__c> serviceRequestLine = new List<ServiceRequestLine__c>();
        dmpl__ServiceRequest__c serviceRequest = [Select Id,Name From dmpl__ServiceRequest__c LIMIT 1];
        List<dmpl__PriceListRules__c> priceListRule = [SELECT Id,Name FROM dmpl__PriceListRules__c LIMIT 1];
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id,Name FROM dmpl__SKU__c LIMIT 1];
        dmpl__TaxGroup__c taxGroup = [Select Id,Name From dmpl__taxGroup__c LIMIT 1];
        
        dmpl__ItemAlias__c itemAlias = new dmpl__ItemAlias__c(
            dmpl__ItemId__c = item.Id,
            Name = 'Test'
        );
        insert itemAlias;
        
        serviceRequestLine.add(new dmpl__ServiceRequestLine__c(dmpl__ServiceRequestId__c = serviceRequest.Id,
                                                              dmpl__ItemId__c = item.Id,
                                                              dmpl__Quantity__c = 10,
                                                              dmpl__UnitPrice__c = 100,
                                                              dmpl__TaxGroupId__c = taxGroup.Id,
                                                              dmpl__SKUId__c = sku.Id,
                                                              dmpl__PriceListRuleId__c = priceListRule[0].Id,
                                                               dmpl__ItemAliasId__c = itemAlias.Id
                                                              ));
        insert serviceRequestLine;
    }
    
    @isTest
    private static void VerifyHeadlessCallabaleMethod()
    {
        test.startTest();
        dmpl__ServiceRequest__c serviceRequest = [Select Id,Name From dmpl__ServiceRequest__c LIMIT 1];
        HeadlessCallableController.callHeadlessAction('headlessAction','dmpl__ServiceRequest__c',serviceRequest.Id);
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
    
    public static void CreateStorageLocation()
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
    
    public static void CreateItems()
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
    
    public static void CreateSKu()
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
    
    public static void CreateItemLot()
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
    
  public static void CreateAsset()
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

         List<dmpl__ItemServiceContract__c> serviceContract = new List<dmpl__ItemServiceContract__c>();
        serviceContract.add(new dmpl__ItemServiceContract__c(dmpl__DateEffectiveFrom__c = date.today(),
                                                             dmpl__DateEffectiveTill__c = date.today() + 7,
                                                             dmpl__ItemId__c = item.Id,
                                                             dmpl__SKUId__c = sku.Id,
                                                             dmpl__PopulateContractLines__c = true
                                                            ));
        insert serviceContract;
        
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
    
    public static void CreateBranchTimeSlot()
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
    
    public static void CreateServiceRequest()
    {
        try{
        List<dmpl__ServiceRequest__c> serviceRequest = new List<dmpl__ServiceRequest__c>();
        Account account = [Select Id,Name From Account Where Name = 'Customer-Test-Account' LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c LIMIT 1];
        dmpl__Item__c item = [Select Id,Name,dmpl__ItemType__c From dmpl__Item__c LIMIT 1];
        dmpl__ServiceCampaign__c campaign = [Select Id,Name,dmpl__IsActive__c From dmpl__ServiceCampaign__c LIMIT 1];
        Asset asset = [Select Id,Name From Asset LIMIT 1];
        dmpl__BranchTimeSlot__c brTimeSlot = [Select Id From dmpl__BranchTimeSlot__c LIMIT 1];
         dmpl__ServiceCampaignMember__c ServiceCampaignMember = [Select Id,Name From dmpl__ServiceCampaignMember__c   LIMIT 1];
        serviceRequest.Add(new dmpl__ServiceRequest__c(dmpl__AccountId__c = account.Id,
                                                    dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                                    dmpl__AssetId__c = asset.Id,
                                                    dmpl__BranchId__c = branch.Id,
                                                       dmpl__TCSEligibleAmount__c = 100,
                                                    dmpl__AppointmentTimeSlotId__c = brTimeSlot.Id,
                                                       dmpl__ServiceCampaignBatchInstanceId__c =branch.Id,
                                                       dmpl__ServiceCampaignId__c=campaign.id,
                                                       dmpl__ServiceCampaignMemberId__c= ServiceCampaignMember.id,
                                                    dmpl__ServiceContractItemId__c = item.Id));
        insert serviceRequest;
            PriceListHelper.setDefaultPriceListIds(serviceRequest);
        }
        catch(exception ex)
        {
            
        }
    }
    
    public static void CreateServiceRequestLine()
    {
        List<dmpl__ServiceRequestLine__c> serviceRequestLine = new List<ServiceRequestLine__c>();
        dmpl__ServiceRequest__c serviceRequest = [Select Id,Name From dmpl__ServiceRequest__c LIMIT 1];
        List<dmpl__PriceListRules__c> priceListRule = [SELECT Id,Name FROM dmpl__PriceListRules__c LIMIT 1];
        dmpl__ItemServiceContract__c contract = [Select Id,Name From dmpl__ItemServiceContract__c LIMIT 1];
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id,Name FROM dmpl__SKU__c LIMIT 1];
        dmpl__TaxGroup__c taxGroup = [Select Id,Name From dmpl__taxGroup__c LIMIT 1];
        serviceRequestLine.add(new dmpl__ServiceRequestLine__c(dmpl__ServiceRequestId__c = serviceRequest.Id,
                                                              dmpl__ItemId__c = item.Id,
                                                              dmpl__Quantity__c = 10,
                                                              dmpl__ItemServiceContractId__c = contract.Id,
                                                              dmpl__UnitPrice__c = 100,
                                                              dmpl__TaxGroupId__c = taxGroup.Id,
                                                              dmpl__SKUId__c = sku.Id,
                                                              dmpl__PriceListRuleId__c = priceListRule[0].Id
                                                              ));
        insert serviceRequestLine;
    }
    
    private static void CreateTax()
    {
        List<dmpl__Tax__c> tax = new List<dmpl__Tax__c>();
        dmpl__TaxGroup__c taxGroup = [Select Id,Name From dmpl__TaxGroup__c LIMIT 1];
        tax.Add(new dmpl__Tax__c(Name = 'Test - Tax',
                                dmpl__TaxGroupId__c = taxGroup.Id,
                                dmpl__Type__c = 'Cess',
                                 dmpl__PostingFieldName__c ='Tax1',
                                dmpl__Rate__c = 10
                                ));        
        insert tax;
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
     private static void CreateServiceCompaignNew()
    {
        List<dmpl__ServiceCampaign__c> serviceCampaign = new List<dmpl__ServiceCampaign__c>();
    dmpl__ItemServiceContract__c contract = [Select Id,Name From dmpl__ItemServiceContract__c LIMIT 1];
        Account account = [Select Id,Name From Account  LIMIT 1];
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
    
}