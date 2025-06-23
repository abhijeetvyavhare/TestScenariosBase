@isTest
public with sharing class IncentivePlanHelper_Test {
    @testSetup
    public static void Setup()
    {
        test.startTest();
        CreateAccountGroup();
        CreateAccount();
        CreateBranch();
        CreateItemGroup(); 
        CreateItems();
        CreateSKu();
        CreateResource();
        CreateScheme();
        CreatePerformanceKPI();
        test.stopTest();
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
                                dmpl__IsSupplierAccount__c = false,
                                dmpl__IsCustomerAccount__c = False
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
                                              dmpl__IsPartnerAccount__c = True,
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
        /*
        Account partnerAccount1 = [Select Id,Name From Account WHERE Name = 'Customer-Test-Account' LIMIT 1];
        branch.Add(new dmpl__Branch__c(dmpl__PartnerAccountId__c =partnerAccount.Id,
                                       Name = 'Test-Branch1',
                                       dmpl__IsActive__c = true,
                                       dmpl__MarketingName__c = 'Hero Electric',
                                       dmpl__Website__c = 'www.dealermatix.com',
                                       dmpl__Email__c = 'Dealer@Outlook.com',
                                       dmpl__MobileNumber__c = 99,
                                       dmpl__Phone__c = '1888888888',
                                       dmpl__AllowSales__c = true,
                                       dmpl__AllowService__c = true,
                                       dmpl__AllowPurchase__c = true,
                                       dmpl__AllowInventory__c = true,
                                       dmpl__IsHomeDeliveryAvailable__c = true,
                                       dmpl__IsPickupDropAvailable__c = true,
                                       dmpl__SalesPhone__c = '7177777777',
                                       dmpl__ServiceEmail__c = 'Customer1@Outlook.com'));
*/
        insert branch;
        
    }
    
    private static void CreateItemGroup()
    {
        List<dmpl__ItemGroup__c> itemGroup = new List<dmpl__ItemGroup__c> ();
        itemGroup.Add(new dmpl__ItemGroup__c(Name = 'Item Group Test',
                                             dmpl__ItemGroupType__c = 'Scheme'
                                            ));
        insert itemGroup;
    }
    
    private static void CreateItems()
    {
        List<dmpl__Item__c> productItem = new List<dmpl__Item__c>();
        dmpl__ItemGroup__c itemGroup =[Select Id, Name from dmpl__ItemGroup__c Limit 1];
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
    
    private static void CreateTaxGroup()
    {
        List<dmpl__TaxGroup__c> taxGroup = new List<dmpl__TaxGroup__c>();
        Account account=[Select Id,Name from Account Where Name='Partner-Test-Account'];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c Limit 1];
        dmpl__AccountGroup__c AccountGrp = [Select Id, Name FROM dmpl__AccountGroup__c LIMIT 1];
        taxGroup.Add(new dmpl__TaxGroup__c(Name = 'Test - Tax Group',
                                           dmpl__PartnerAccountId__c = account.Id,
                                           dmpl__BranchId__c = branch.Id,
                                           dmpl__PartnerAccountGroupId__c = AccountGrp.Id,
                                           dmpl__Description__c = 'Test-Description',
                                           dmpl__IsActive__c = true));
        insert taxGroup;
        
    }
    
    private static void CreatePerformanceKPI()
    {
        dmpl__Item__c listofitem = [Select Id, Name from dmpl__Item__c LIMIT 1];
        dmpl__Scheme__c scheme = [SELECT Id,Name from dmpl__Scheme__c LIMIT 1];
        Account supplierAccount = [Select Id,Name From Account WHERE dmpl__IsSupplierAccount__c = true LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        dmpl__PerformanceKPI__c newRecord =  new dmpl__PerformanceKPI__c(
                                                dmpl__SupplierAccountId__c = supplierAccount.Id,
                                                dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                                dmpl__BranchId__c = branch.Id,
                                                dmpl__AccountId__c = null,
                                                dmpl__SchemeId__c = scheme.Id,
                                                dmpl__SchemePeriodId__c = null,
                                                dmpl__ItemId__c = listofitem.Id,
                                                dmpl__TotalAmount__c = 0,
                                                dmpl__TotalTaxAmount__c = 0,
                                                dmpl__TotalQuantity__c = 0,
                                                dmpl__TotalSaleOrderAmount__c = 0,
                                                dmpl__TotalSaleInvoiceAmount__c =  0,
                                                dmpl__TotalPurchaseOrderAmount__c =  0,
                                                dmpl__TotalBillAmount__c = 0,
                                                dmpl__TotalRepairOrderAmount__c = 0,
                                                dmpl__TotalSaleOrderQuantity__c =  0,
                                                dmpl__TotalSaleInvoiceQuantity__c = 0,
                                                dmpl__TotalPurchaseOrderQuantity__c =  0,
                                                dmpl__TotalBillQuantity__c =  0,
                                                dmpl__TotalRepairOrderQuantity__c = 0,
                                                dmpl__PostingType__c = 'KPI'
                                                );
     insert newRecord;
    }
    
    @isTest 
public static void CreateIncentivePlan()
{
    // Setup Purchase Order
    List<dmpl__PurchaseOrder__c> po = CreatePurchaseOrder();
    System.assertNotEquals(0, po.size(), 'Purchase Order should be created');
    
    // Retrieve Purchase Order with related Purchase Order Lines
    po = [SELECT Id, Name, dmpl__DocumentDate__c, dmpl__PartnerAccountId__r.dmpl__PartnerSchemeAccountGroupId__c,
                 dmpl__AccountName__c, dmpl__BranchId__c, dmpl__PartnerAccountId__c, dmpl__SupplierAccountId__c,
                 dmpl__TotalAmount__c, dmpl__TotalLineAmount__c, dmpl__TotalPendingInvoiceQuantity__c,
                 dmpl__TotalQuantityPending__c, (SELECT Id, Name, dmpl__Amount__c, dmpl__BaseAmount__c, dmpl__ItemId__c,
                 dmpl__ItemId__r.dmpl__SchemeItemGroupId__c, dmpl__OriginalItemId__c, dmpl__PurchaseOrderId__c,
                 dmpl__Quantity__c, dmpl__SKUId__c, dmpl__UnitCost__c FROM dmpl__PurchaseOrderLines__r)
          FROM dmpl__PurchaseOrder__c];
    
    // Create Incentive Plans
    List<dmpl__IncentivePlan__c> plans = new List<dmpl__IncentivePlan__c>();
    dmpl__Branch__c branch = [SELECT Id, Name, dmpl__PartnerAccountId__c FROM dmpl__Branch__c WHERE Name = 'Test-Branch' LIMIT 1];
    Account supplierAccount = [SELECT Id, Name FROM Account WHERE dmpl__IsSupplierAccount__c = True LIMIT 1];
    dmpl__AccountGroup__c accGroup = [SELECT Id,Name FROM dmpl__AccountGroup__c WHERE Name = 'Test-AccountGroup' LIMIT 1];
    
    // Add a Quarterly Incentive Plan
    plans.add(new dmpl__IncentivePlan__c(
        dmpl__PeriodType__c = 'Quarterly',
        Name = 'Plan1',
        dmpl__Status__c = 'Draft',
        dmpl__PeriodEndDate__c = Date.today() + 7,
        dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
        dmpl__SupplierAccountId__c = supplierAccount.Id,
        dmpl__AccountGroupId__c = accGroup.Id,
        dmpl__ValidFrom__c = null,
        dmpl__ValidTo__c = null,
        dmpl__PartnerAccountGroupId__c = null,
        dmpl__MemberResourceType__c = 'None',
        dmpl__MemberType__c = 'Resource'
    ));
    
    insert plans;
    
    // Assert Incentive Plan Created
    System.assertNotEquals(0, [SELECT COUNT() FROM dmpl__IncentivePlan__c], 'Incentive Plan should be created');
    
    // Update and Verify
    plans[0].dmpl__Status__c = 'Approved';
    update plans;
    
    // Assert Plan Status Updated
    dmpl__IncentivePlan__c updatedPlan = [SELECT dmpl__Status__c FROM dmpl__IncentivePlan__c WHERE Id = :plans[0].Id];
    System.assertEquals('Approved', updatedPlan.dmpl__Status__c, 'Incentive Plan status should be updated to Approved');
    
    // Run and verify other logic
    PerformanceKPIHelper.upsertSchemePerformanceKPIInternal('dmpl__PurchaseOrder__c', po);
}

    
    private static List<dmpl__PurchaseOrder__c> CreatePurchaseOrder()
    {
        List<dmpl__PurchaseOrder__c> purchaseOrder = new List<dmpl__PurchaseOrder__c>();
        Account supplierAccount = [Select Id,Name From Account WHERE dmpl__IsSupplierAccount__c = true LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        //dmpl__PriceList__c priceList=[select Id, Name from dmpl__PriceList__c WHERE dmpl__PriceListType__c = 'Sale Price' LIMIT 1];
        purchaseOrder.add(new dmpl__PurchaseOrder__c(dmpl__BranchId__c = branch.Id,
                                                     dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                                     dmpl__SupplierAccountId__c = supplierAccount.Id,
                                                     dmpl__PurchaseOrderType__c ='VOR PO',
                                                     dmpl__DocumentDate__c = Date.today(),
                                                     //dmpl__PriceListId__c=priceList.Id,
                                                     //dmpl__AmountPaid__c =1 ,
                                                     dmpl__Status__c='Draft',
                                                     dmpl__Remarks__c = 'Remark'));
        insert purchaseOrder;
        
        List<dmpl__PurchaseOrderLine__c> purchaseOrderLine = new List<dmpl__PurchaseOrderLine__c>();
        dmpl__Item__c listofitem = [Select Id, Name from dmpl__Item__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id,Name FROM dmpl__SKU__c LIMIT 1];
        //dmpl__TaxGroup__c taxGroup = [Select Id,Name From dmpl__TaxGroup__c LIMIT 1];
        purchaseOrderLine.add(new dmpl__PurchaseOrderLine__c(dmpl__ItemId__c = listofitem.Id,
                                                             dmpl__SKUId__c = sku.Id,
                                                             dmpl__PurchaseOrderId__c = purchaseOrder[0].Id,
                                                             //dmpl__PurchaseRequisitionId__c = purchaseRequisition.Id,
                                                             //dmpl__TaxGroupId__c = taxGroup.Id,
                                                             //dmpl__ItemLotId__c = itemLot.Id,
                                                             dmpl__Quantity__c = 100,
                                                             //dmpl__UnitPrice__c = 10,
                                                             //dmpl__IsClaimed__c = false,
                                                             dmpl__SchemeDiscountAmount__c = 100
                                                            ));
        insert purchaseOrderLine;
        return purchaseOrder;
    }
    
    private static void CreateScheme()
    {
        List<dmpl__Scheme__c> scheme1 = new List<dmpl__Scheme__c>();
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c where dmpl__ItemType__c='Product'  LIMIT 1];
        dmpl__ItemGroup__c itemGroup = [Select Id,Name from dmpl__ItemGroup__c LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c Where Name = 'Test-Branch'];
        scheme1.Add(new dmpl__Scheme__c(dmpl__PeriodType__c = 'Monthly',
                                        Name = 'Per Purchase Order',
                                        dmpl__ValidTo__c = date.today().addMonths(3),
                                        dmpl__Status__c = 'Approved',
                                        dmpl__MultipleFulfilmentTreatment__c = 'Apply All Fulfilled',
                                        dmpl__SchemeType__c = 'Per Purchase Order',
                                        dmpl__BranchId__c = branch.Id,
                                        dmpl__ValidFrom__c = date.today(),
                                        dmpl__PeriodStartDate__c = date.today(),
                                        dmpl__PeriodEndDate__c = date.today().addMonths(3),
                                        dmpl__PartnerAccountId__c = null,
                                        dmpl__PartnerAccountGroupId__c = null,
                                        dmpl__Application__c = 'Apply On Selection'));
        insert scheme1;
        
        List<dmpl__SchemeLine__c> schemeLine = new List<dmpl__SchemeLine__c>();
        schemeLine.Add(new dmpl__SchemeLine__c(dmpl__Title__c = 'Buy 12 and Get 120 Off',
            								   dmpl__DefinitionFilterCriteria__c = 'All Conditions Are Met',
                                               dmpl__SchemeId__c = scheme1[0].Id,
                                               dmpl__SequenceNumber__c = 1,
                                               dmpl__RewardApplicability__c = 'All Rewards'));
        insert schemeLine;
        
        insert new dmpl__SchemeCondition__c(
                                                dmpl__SchemeId__c = scheme1[0].Id,
                                                dmpl__ItemId__c=item.Id,  
                                                dmpl__ConditionType__c='Item Quantity',
                                                dmpl__ConditionQuantity__c =5,
                                                dmpl__SequenceNumber__c = 1,
                                                dmpl__SchemeLineId__c = schemeLine[0].Id,
                                                dmpl__ConditionOperator__c = 'Greater Than',
        										dmpl__ItemGroupId__c = itemGroup.Id);
        
         insert new dmpl__SchemeBenefit__c(
                                                 dmpl__DiscountPercent__c = 100,
                                                 dmpl__RewardType__c = 'Discounted Item',
                                                 dmpl__SequenceNumber__c = 1,
                                                 dmpl__RepeatReward__c =  true,
                                                 dmpl__SchemeLineId__c = schemeLine[0].Id,
                                                 dmpl__DiscountedItemId__c = item.id);
        
    }
    
    @isTest
    public static void CreateIncentivePlansNew()
    {
        List<dmpl__IncentivePlan__c> plans = new List<dmpl__IncentivePlan__c>();
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c Where Name = 'Test-Branch'];
        dmpl__AccountGroup__c accg = [select id from dmpl__AccountGroup__c WHERE Name = 'Test-AccountGroup' limit 1];
        Account customerAccount = [Select Id,Name From Account WHERE dmpl__IsCustomerAccount__c = True LIMIT 1];
        plans.Add(new dmpl__IncentivePlan__c(dmpl__PeriodType__c = 'Yearly',
        Name='Plan1',
        dmpl__ValidTo__c= Datetime.now().addDays(365).Date(),
        dmpl__Status__c='Draft',
        dmpl__ValidFrom__c = date.today(),
        dmpl__AccountGroupId__c = accg.Id,
        dmpl__PeriodEndDate__c = date.today()+7,
        dmpl__PartnerAccountId__c = null,
        dmpl__PartnerAccountGroupId__c = null,
        dmpl__MemberResourceType__c = 'Salesperson',
        MemberType__c = 'Partner'));
        insert plans;

        /*
        List<dmpl__IncentivePlan__c> plan1 = new List<dmpl__IncentivePlan__c>();
        plan1.Add(new dmpl__IncentivePlan__c(dmpl__PeriodType__c = 'Weekly',
                                       Name='Plan1',
                                       dmpl__ValidTo__c= Datetime.now().addDays(365).Date(),
                                       dmpl__Status__c='Draft',
                                       dmpl__ValidFrom__c = date.today(),
                                       dmpl__PeriodEndDate__c = date.today()+7,
                                       dmpl__PartnerAccountId__c = null,
                                       dmpl__PartnerAccountGroupId__c = null,
                                             dmpl__AccountGroupId__c = accg.Id,
                                       dmpl__MemberResourceType__c = 'Salesperson',
                                       dmpl__MemberType__c = 'Branch'));
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
                                             dmpl__AccountGroupId__c = accg.Id,
                                       dmpl__MemberResourceType__c = 'None',
                                       dmpl__MemberType__c = 'Resource'));
        plan2.Add(new dmpl__IncentivePlan__c(dmpl__PeriodType__c = 'Daily',
                                       Name='Plan1',
                                       dmpl__ValidTo__c= Datetime.now().addDays(365).Date(),
                                       dmpl__Status__c='Draft',
                                       dmpl__ValidFrom__c = date.today(),
                                       dmpl__PeriodEndDate__c = date.today()+7,
                                       dmpl__PartnerAccountId__c = null,
                                       dmpl__PartnerAccountGroupId__c = null,
                                             dmpl__AccountGroupId__c = accg.Id,
                                       dmpl__MemberResourceType__c = 'None',
                                       dmpl__MemberType__c = 'Customer'));
        plan2.Add(new dmpl__IncentivePlan__c(dmpl__PeriodType__c = 'Daily',
                                       Name='Del',
                                       dmpl__ValidTo__c= Datetime.now().addDays(365).Date(),
                                       dmpl__Status__c='Draft',
                                       dmpl__ValidFrom__c = date.today(),
                                       dmpl__PeriodEndDate__c = date.today()+7,
                                       dmpl__PartnerAccountId__c = null,
                                       dmpl__PartnerAccountGroupId__c = null,
                                             dmpl__AccountGroupId__c = accg.Id,
                                       dmpl__MemberResourceType__c = 'None'
                                       ));
        insert plan2;
        */
    }
    /*
    @isTest
    public static void deleteIncentivePlans()
    {
        test.startTest();
        CreateIncentivePlansNew();
        dmpl__IncentivePlan__c plan = [Select Id,Name,dmpl__PeriodStartDate__c,dmpl__PeriodEndDate__c,dmpl__BusinessHoursId__c From dmpl__IncentivePlan__c where dmpl__MemberType__c = 'Resource' LIMIT 1];
        
        Integer startDate = 5;
        IncentivePlanHelper.createQuarterlyPeriods(plan);
        IncentivePlanHelper.createMonthlyPeriods(plan);
        IncentivePlanHelper.createWeeklyPeriods(plan,startDate);
        IncentivePlanHelper.createDailyPeriods(plan);
        dmpl__IncentivePlan__c plan2 = [Select Id,Name,dmpl__PeriodStartDate__c,dmpl__PeriodEndDate__c,dmpl__BusinessHoursId__c From dmpl__IncentivePlan__c where Name = 'Del' LIMIT 1];
        if(plan2 != null)
            delete plan2;
        System.Assert(plan!=null,'incentive plan data');
        test.stopTest();
    }
    */
     @isTest
    public static void verifyIncentivePlans()
    {
        test.startTest();
        CreateIncentivePlan();
         dmpl__IncentivePlan__c plan1 = [Select Id,Name,dmpl__PeriodStartDate__c,dmpl__PeriodEndDate__c,dmpl__BusinessHoursId__c From dmpl__IncentivePlan__c where dmpl__MemberType__c = 'Resource' LIMIT 1];
        
        Integer startDate = 5;
        IncentivePlanHelper.createQuarterlyPeriods(plan1);
        //IncentivePlanHelper.createYearlyPeriods(plan1);
        //IncentivePlanHelper.copyResourceTargets(plan1);
         Map<Object, Object> inputData = new Map<Object, Object>{
             'dmpl__IncentivePlanId__c' => plan1.Id};
        IncentivePlanHelper.createSimulation(inputData);
        
        List<SObject> modifiedOjects = new List<SObject>();
        Id Ids;
        IncentiveResourceProcessor processor = new IncentiveResourceProcessor('',Ids,Ids,'','');
        processor.createCustomers(modifiedOjects);
        processor.createAGCustomers(modifiedOjects);
        IncentiveEngine.applyIncentiveBenefit(new dmpl__IncentiveCompensationSlab__c());
        dmpl__IncentivePlan__c plan = [Select Id,Name,dmpl__PeriodStartDate__c,dmpl__PeriodEndDate__c,dmpl__BusinessHoursId__c,dmpl__AccountGroupId__c From dmpl__IncentivePlan__c WHERE dmpl__AccountGroupId__c != null LIMIT 1];
        IncentiveResourceProcessor.createCustomersQuery(plan);
        IncentiveController.getIncentiveLines(plan.Id);
        test.stopTest();
    }
    
}