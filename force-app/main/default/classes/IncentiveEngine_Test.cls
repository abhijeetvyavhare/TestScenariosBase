@isTest
public class IncentiveEngine_Test {
    
    @testSetup
    public static void Setup()
    {
        
        CreateAccount();
        CreateBranch();
        CreateItems();
        CreateSKu();
        CreateIncentivePlansNew();
        CreateResource();
        CreateIncentivePeriod();
      //  CreateKPI_Data();
        CreateIncentiveLine();
        CreateIncentiveCompensationSlab();
        CreateIncentiveTarget();
        CreatePerformanceKPI();
        
       
        CreateCompensation();
        CreateIncentiveResourceTarget();
        CreateCompensationLine();
    }
    private static void CreatePerformanceKPI()
    {
        dmpl__Item__c listofitem = [Select Id, Name from dmpl__Item__c LIMIT 1];
        //dmpl__Scheme__c scheme = [SELECT Id,Name from dmpl__Scheme__c LIMIT 1];
        Account act = [Select Id,Name From Account WHERE dmpl__IsCustomerAccount__c = true LIMIT 1];
        Account supplierAccount = [Select Id,Name From Account WHERE dmpl__IsSupplierAccount__c = true LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        dmpl__IncentivePlan__c plan = [Select Id,Name From dmpl__IncentivePlan__c LIMIT 1];
        dmpl__IncentivePeriod__c period = [Select Id,Name From dmpl__IncentivePeriod__c LIMIT 1];
        dmpl__IncentiveTarget__c it = [select id from dmpl__IncentiveTarget__c limit 1];
        dmpl__Resource__c r = [select id from dmpl__Resource__c limit 1];
        dmpl__PerformanceKPI__c newRecord =  new dmpl__PerformanceKPI__c(
                                                dmpl__SupplierAccountId__c = supplierAccount.Id,
                                                dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                                dmpl__BranchId__c = branch.Id,
                                                dmpl__AccountId__c = act.id,
            									dmpl__IncentiveTargetId__c = it.Id,
            									dmpl__ResourceId__c = r.Id,
                                                //dmpl__SchemeId__c = scheme.Id,
                                                dmpl__SchemePeriodId__c = null,
                                                dmpl__ItemId__c = listofitem.Id,
                                                dmpl__TotalAmount__c = 0,
                                                dmpl__TotalTaxAmount__c = 0,
                                                dmpl__TotalQuantity__c = 0,
                                                dmpl__TotalSaleOrderAmount__c = 0,
                                                dmpl__TotalSaleInvoiceAmount__c =  0,
                                                dmpl__TotalPurchaseOrderAmount__c =  1000,
                                                dmpl__TotalBillAmount__c = 0,
                                                dmpl__TotalRepairOrderAmount__c = 0,
                                                dmpl__TotalSaleOrderQuantity__c =  0,
                                                dmpl__TotalSaleInvoiceQuantity__c = 0,
                                                dmpl__TotalPurchaseOrderQuantity__c = 1000,
                                                dmpl__TotalBillQuantity__c =  0,
                                                dmpl__TotalRepairOrderQuantity__c = 0,
                                                dmpl__PostingType__c = 'KPI',
            									dmpl__IncentivePlanId__c = plan.Id,
            									dmpl__IncentivePeriodId__c = period.Id
                                                );
     insert newRecord;
    }
    private static void CreateIncentiveTarget()
    {
        List<dmpl__IncentiveTarget__c> target = new List<dmpl__IncentiveTarget__c>();
        dmpl__IncentivePlan__c plan = [Select Id,Name From dmpl__IncentivePlan__c LIMIT 1];
        Account act = [Select Id,Name From Account LIMIT 1];
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id,Name From dmpl__SKU__c LIMIT 1];
        dmpl__IncentivePeriod__c period = [Select Id,Name From dmpl__IncentivePeriod__c LIMIT 1];
        dmpl__IncentiveLine__c line = [Select Id,Name From dmpl__IncentiveLine__c LIMIT 1];
        target.add(new dmpl__IncentiveTarget__c(//dmpl__AccountId__c = act.Id,
                                                dmpl__SequenceNumber__c = 10,
                                                dmpl__ServiceContractId__c = item.Id,
                                                dmpl__SKUId__c = sku.Id,
                                                dmpl__Value__c = 100,
                                                dmpl__TargetType__c = 'No of Leads',
                                                dmpl__IncentivePlanId__c = plan.Id,
                                                dmpl__IncentiveTargetType__c ='Purchase Order Quantity',
                                                dmpl__IncentivePeriodId__c = period.Id,
                                                dmpl__IncentiveLineId__c = line.Id,
                                                dmpl__ItemId__c = item.Id
                                               ));
        
        insert target;
    }
    private static void CreateItems()
    {
        List<dmpl__Item__c> productItem = new List<dmpl__Item__c>();
        //dmpl__ItemGroup__c itemGroup =[Select Id, Name from dmpl__ItemGroup__c Limit 1];
        productItem.Add(new dmpl__Item__c(Name = 'Test-Item',
                                          dmpl__ItemCode__c = 'DMPL',
                                          dmpl__ItemType__c = 'Product',
                                          dmpl__ItemSubType__c = '',
                                          //dmpl__SchemeItemGroupId__c=itemGroup.Id,
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
    private static void CreateCompensation()
    {
        dmpl__IncentivePlan__c plan = [Select Id,Name From dmpl__IncentivePlan__c LIMIT 1];
        insert new dmpl__IncentiveCompensation__c(dmpl__IncentivePlanId__c = plan.Id);
    }
    private static void CreateCompensationLine()
    {
        dmpl__IncentiveCompensation__c compensation = [SELECT Id,Name FROM dmpl__IncentiveCompensation__c];
        dmpl__IncentivePlan__c plan = [Select Id,Name From dmpl__IncentivePlan__c LIMIT 1];
        dmpl__IncentivePeriod__c period = [Select Id,Name From dmpl__IncentivePeriod__c LIMIT 1];
        dmpl__IncentiveResource__c incentiveRes = [Select Id,Name,dmpl__ResourceId__c From dmpl__IncentiveResource__c LIMIT 1];
        insert new dmpl__IncentiveCompensationLine__c(dmpl__CompensationId__c = compensation.Id,
                                                      dmpl__NoofSaleOrders__c=3,
                                                      dmpl__IncentivePlanId__c = plan.Id ,
                                                      dmpl__IncentivePeriodId__c = period.Id,
                                                     dmpl__IncentiveResourceId__c = incentiveRes.Id);
    }
    public static void CreateIncentivePlansNew()
    {
        List<dmpl__IncentivePlan__c> plans = new List<dmpl__IncentivePlan__c>();
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c Where Name = 'Test-Branch'];
        Account customerAccount = [Select Id,Name From Account WHERE dmpl__IsCustomerAccount__c = True LIMIT 1];
        plans.Add(new dmpl__IncentivePlan__c(dmpl__PeriodType__c = 'Bi Weekly',
                                       Name='Plan1',
                                       dmpl__ValidTo__c= Datetime.now().addDays(365).Date(),
                                       dmpl__Status__c='Draft',
                                       dmpl__ValidFrom__c = date.today(),
                                       dmpl__PeriodEndDate__c = date.today()+7,
                                       dmpl__PartnerAccountId__c = null,
                                       dmpl__PartnerAccountGroupId__c = null,
                                       dmpl__MemberResourceType__c = 'None',
                                       MemberType__c = 'Resource'));
        insert plans;
        
        List<dmpl__IncentivePlan__c> plan1 = new List<dmpl__IncentivePlan__c>();
        plan1.Add(new dmpl__IncentivePlan__c(dmpl__PeriodType__c = 'Weekly',
                                       Name='Plan1',
                                       dmpl__ValidTo__c= Datetime.now().addDays(365).Date(),
                                       dmpl__Status__c='Draft',
                                       dmpl__ValidFrom__c = date.today(),
                                       dmpl__PeriodEndDate__c = date.today()+7,
                                       dmpl__PartnerAccountId__c = null,
                                       dmpl__PartnerAccountGroupId__c = null,
                                       dmpl__MemberResourceType__c = 'Salesperson',
                                       MemberType__c = 'Branch'));
        insert plan1;
        
        List<dmpl__IncentivePlan__c> plan2 = new List<dmpl__IncentivePlan__c>();
        plan2.Add(new dmpl__IncentivePlan__c(dmpl__PeriodType__c = 'Daily',
                                       Name='Plan1',
                                       dmpl__ValidTo__c= Datetime.now().addDays(365).Date(),
                                       dmpl__Status__c='Draft',
                                       dmpl__ValidFrom__c = date.today(),
                                       dmpl__PeriodEndDate__c = date.today()+7,
                                       dmpl__PartnerAccountId__c = null,
                                       dmpl__PartnerAccountGroupId__c = null,
                                       dmpl__MemberResourceType__c = 'None',
                                       MemberType__c = 'Partner'));
        insert plan2;
        
        List<dmpl__IncentivePlan__c> ip = [select id,dmpl__Status__c from dmpl__IncentivePlan__c ];
        for(dmpl__IncentivePlan__c i: ip)
        	i.dmpl__Status__c = 'Approved';
        update ip;
    }
    
    private static void CreateAccount()
    {
        dmpl__AccountGroup__c accountGroup1= new dmpl__AccountGroup__c (Name= 'Test-AccountGroup', 
                                                                       dmpl__AccountGroupType__c='Scheme');
        insert accountGroup1;
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
    
    private static void CreateIncentivePeriod()
    {
       dmpl__IncentivePlan__c plan = [Select Id,Name From dmpl__IncentivePlan__c LIMIT 1];
        insert new dmpl__IncentivePeriod__c(dmpl__IncentivePlanId__c = plan.Id , 
                                            Name='Test' ,dmpl__DateFrom__c=date.today(),
                                          dmpl__Status__c = 'Approved',
                                            dmpl__DateTo__c =date.today().addMonths(3));
    }
    
    private static void CreateIncentiveLine()
    {
        dmpl__IncentivePlan__c plan = [Select Id,Name From dmpl__IncentivePlan__c where dmpl__Status__c = 'Approved' LIMIT 1];
        insert new dmpl__IncentiveLine__c(dmpl__IncentivePlanId__c = plan.Id,
                                          dmpl__SequenceNumber__c = 1,
                                         dmpl__DefinitionFilterCriteria__c = 'Custom Logic Is Met',
                                         dmpl__DefinitionCustomLogic__c = '(1)');
        
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
    private static void CreateIncentiveCompensationSlab()
    {
        dmpl__IncentivePlan__c plan = [Select Id,Name From dmpl__IncentivePlan__c LIMIT 1];
        dmpl__IncentiveLine__c line = [Select Id,Name From dmpl__IncentiveLine__c LIMIT 1];
        insert new dmpl__IncentiveCompensationSlab__c(dmpl__CompensationType__c = 'Fixed Amount',
                                                      dmpl__Gifts__c='Amazon Vouchers',
                                                      dmpl__IncentiveLineId__c =line.Id,
                                                      dmpl__IncentivePlanId__c = plan.Id,
                                                      dmpl__TargetCondition__c = 'All',
                                                      dmpl__SequenceNumber__c=1,
                                                     dmpl__FromPercentage__c =5,
                                                     dmpl__IncentiveFixedAmount__c=100
                                                     );
    }
    private static void CreateResource()
    {
        List<dmpl__Resource__c> resource = new List<dmpl__Resource__c>();
        Account partnerAccount = [Select Id,Name From Account LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name From dmpl__Branch__c LIMIT 1];
        resource.add(new dmpl__Resource__c(Name = 'Test - Resource',
                                           dmpl__Type__c = 'None',
                                           dmpl__IsActive__c = true,
                                           dmpl__Phone__c = '9999999999',
                                           dmpl__DefaultPartnerAccountId__c = partnerAccount.Id,
                                           dmpl__DefaultBranchId__c = branch.Id
                                          ));
        insert resource;
        
    }
    
    private static void CreateIncentiveResourceTarget()
    {
        CreateResource();
        Account act = [Select Id,Name From Account WHERE dmpl__IsCustomerAccount__c = true LIMIT 1];
        Account partner = [Select Id,Name From Account WHERE dmpl__IsPartnerAccount__c = true LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name From dmpl__Branch__c LIMIT 1];
        dmpl__IncentivePlan__c plan = [Select Id,Name From dmpl__IncentivePlan__c LIMIT 1]; 
        dmpl__Resource__c res = [Select Id,Name From dmpl__Resource__c LIMIT 1];
        insert new dmpl__IncentiveResource__c(dmpl__AccountId__c = act.Id,
                                             dmpl__BranchId__c = branch.Id,
                                             dmpl__IncentivePlanId__c = plan.Id,
                                             dmpl__ResourceId__c = res.Id,
                                             dmpl__PartnerAccountId__c = partner.Id
                                             );
        List<dmpl__IncentiveResourceTarget__c> resTarget = new List<dmpl__IncentiveResourceTarget__c>();
        dmpl__IncentiveTarget__c target = [Select Id,Name From dmpl__IncentiveTarget__c LIMIT 1];
        dmpl__IncentiveResource__c incentiveRes = [Select Id,Name,dmpl__ResourceId__c From dmpl__IncentiveResource__c LIMIT 1];
    	resTarget.add(new dmpl__IncentiveResourceTarget__c(dmpl__IncentiveTargetId__c = target.Id,
                                                           //Name = 'Incentive Resource Target',
                                                           dmpl__Value__c = 200,
                                                           dmpl__IncentiveResourceId__c = incentiveRes.Id
        												   ));
        insert resTarget;
    }
    
    
    @isTest
    static void testProcessIncentives() {
        // 1. Setup test data
        
        // Create test records for IncentiveCompensationLine__c
        List<dmpl__IncentiveCompensationLine__c> testDocuments = new List<dmpl__IncentiveCompensationLine__c>();
        

        
        insert testDocuments;
        List<dmpl__IncentiveCompensationLine__c> d  = [select id,dmpl__IncentiveResourceId__c,dmpl__IncentivePeriodId__c,dmpl__IncentivePlanId__c,dmpl__NoofSaleOrders__c,dmpl__CompensationId__c from dmpl__IncentiveCompensationLine__c];
        
        // Create any additional test records required by the IncentiveEngine logic
        // For example, IncentiveTargetResource, IncentiveLine, etc.
        // For simplicity, they are not included here but should be created as necessary.
        
        // 2. Execute the method
        Test.startTest();
        IncentiveEngine.processIncentives(d);
        Test.stopTest();
        
        // 3. Assertions
        // Validate that the processing has happened as expected
        // This could involve checking if records were created or updated correctly.
        
        // Example: Check if some records are updated or created.
        List<IncentiveLine__c> processedIncentiveLines = [SELECT Id, Name FROM IncentiveLine__c WHERE Name = 'Test Incentive Line'];
        
        // Additional assertions depending on the outcome expected from your IncentiveEngine class.
    }
    
    
    
}