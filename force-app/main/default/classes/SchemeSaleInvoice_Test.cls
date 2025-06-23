@isTest
public class SchemeSaleInvoice_Test {
    /*
    @testSetup
    public static void Setup()
    {
        System.runAs(PostInstallHelper.AssignAdministratorAllPermissions(UserInfo.getUserId())){
            CreateAccountGroup();
            CreateAccount();
            CreateBranch();
            CreateItemGroup(); 
            CreateItems();
            CreateSKu();
            CreateResource();
            CreateTaxGroup();
            CreateScheme();
            CreateSchemeLine();
            CreateSchemeCondition();
            CreateSchemeBenefits();
            CreateSaleOrder();
            CreateSaleOrderLine();
            CreateSaleInvoice();
            CreateSaleInvoiceLine();
            
        }
        
    }
    
    
    @isTest
    Static void VerifyCreateAccount()
    {
        List<Account>  account = [Select Id, Name From Account];
        System.assertNotEquals(null, account, 'Test Accounts are not found');
        System.assertEquals(4, account.size(), 'Test Accounts have more than 1 record');
    }
    
    public static void VerifyScheme()
    {
        test.startTest();
        
        List<PurchaseOrderLine__c> line2 = [SELECT Id, Name,dmpl__PurchaseOrderId__c FROM PurchaseOrderLine__c];
        SchemeHelper.processPurchaseOrderLines(line2);   
        System.assertEquals(2, line2.size(), 'Purchase order line data');
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
        
        List<dmpl__Item__c> subsItem = new List<dmpl__Item__c>();
        subsItem.Add(new dmpl__Item__c(Name = 'Test-Item',
                                       dmpl__ItemCode__c = 'DMPL',
                                       dmpl__ItemType__c = 'Subscription',
                                       dmpl__ItemSubType__c = '',
                                       dmpl__Description__c = '',
                                       dmpl__ItemFamily__c = 'Sample',
                                       dmpl__ItemSegment__c = 'Sample',
                                       dmpl__Make__c = 'Sample',
                                       dmpl__Model__c = 'Sample',                       
                                       // dmpl__IsActive__c = true,
                                       dmpl__IsPackage__c = true
                                       //dmpl__OnlySoldInPackage__c=True
                                      ));
        insert subsItem;
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
                                           dmpl__ResourceType__c = 'Technician',
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
    
    
    private static void CreateScheme()
    {
        List<dmpl__Scheme__c> scheme = new List<dmpl__Scheme__c>();
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c Where Name = 'Test-Branch'];
        Account customerAccount = [Select Id,Name From Account WHERE dmpl__IsCustomerAccount__c = True LIMIT 1];
        dmpl__AccountGroup__c accountGroup = [Select Id,Name From dmpl__AccountGroup__c LIMIT 1];
        scheme.Add(new dmpl__Scheme__c(dmpl__PeriodType__c = 'Quarterly',
                                       Name='Scheme1',
                                       dmpl__ValidTo__c= Datetime.now().addDays(365).Date(),
                                       dmpl__Status__c='Approved',
                                       dmpl__MultipleFulfilmentTreatment__c='Apply All Fulfilled',
                                       dmpl__SchemeType__c='Sales Per Order',
                                       dmpl__BranchId__c = branch.Id,
                                       dmpl__ValidFrom__c = date.today()-(2),
                                       dmpl__PartnerAccountId__c = null,
                                       dmpl__PartnerAccountGroupId__c = null));
        insert scheme;
        List<dmpl__Scheme__c> scheme1 = new List<dmpl__Scheme__c>();
            //dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c Where Name = 'Test-Branch'];
           // Account customerAccount = [Select Id,Name From Account WHERE dmpl__IsCustomerAccount__c = True LIMIT 1];
           // dmpl__AccountGroup__c accountGroup = [Select Id,Name From dmpl__AccountGroup__c LIMIT 1];
                                    scheme1.Add(new dmpl__Scheme__c(dmpl__PeriodType__c = 'Quarterly',
                                    Name='Scheme2',
                                    dmpl__ValidTo__c= Datetime.now().addDays(365).Date(),
                                    dmpl__Status__c='Approved',
                                    dmpl__MultipleFulfilmentTreatment__c='Apply First Fulfilled',
                                    dmpl__SchemeType__c='Sales Per Period',
                                    dmpl__BranchId__c = branch.Id,
                                    dmpl__ValidFrom__c = date.today()-(2),
                                    dmpl__PartnerAccountId__c = null,
                                    dmpl__PartnerAccountGroupId__c = null));
            insert scheme1;
            

        
    }
    
    private static void CreateSchemeLine()
    {
        List<dmpl__SchemeLine__c> schemeLine = new List<dmpl__SchemeLine__c>();
        dmpl__Scheme__c scheme =[Select Id, Name,dmpl__SchemeType__c,dmpl__MultipleFulfilmentTreatment__c,dmpl__PeriodType__c from dmpl__Scheme__c 
                                 where  dmpl__SchemeType__c='Sales Per Order'
                                 Limit 1];
        schemeLine.Add(new dmpl__SchemeLine__c(dmpl__DefinitionFilterCriteria__c = 'Always (No Criteria)',
                                               dmpl__SchemeId__c = scheme.Id,
                                               dmpl__SequenceNumber__c = 1,
                                               dmpl__RewardApplicability__c = 'All Rewards'));
        insert schemeLine;
        List<dmpl__SchemeLine__c> schemeLine1 = new List<dmpl__SchemeLine__c>();
        dmpl__Scheme__c scheme1 =[Select Id, Name,dmpl__SchemeType__c,dmpl__MultipleFulfilmentTreatment__c,dmpl__PeriodType__c from dmpl__Scheme__c where  dmpl__SchemeType__c='Sales Per Period' Limit 1];
        schemeLine1.Add(new dmpl__SchemeLine__c(dmpl__DefinitionFilterCriteria__c = 'Always (No Criteria)',
        dmpl__SchemeId__c = scheme1.Id,
        dmpl__RewardApplicability__c = 'Any One With Lowest Value'));
        insert schemeLine1;


        
    }
    
    
    private static void CreateSchemeCondition()
    {
        List<dmpl__SchemeCondition__c> schemeCondition = new List<dmpl__SchemeCondition__c>();
        dmpl__Scheme__c scheme =[Select Id, Name from dmpl__Scheme__c Limit 1];
        dmpl__SchemeLine__c schemeLine =[Select Id, Name from dmpl__SchemeLine__c   Limit 1];
        Account customerAccount = [Select Id,Name From Account WHERE dmpl__IsCustomerAccount__c = True LIMIT 1];
        dmpl__AccountGroup__c accountGroup = [Select Id,Name From dmpl__AccountGroup__c LIMIT 1];
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c where dmpl__ItemType__c='Product'  LIMIT 1];
        dmpl__ItemGroup__c itemGroup =[Select Id, Name from dmpl__ItemGroup__c Limit 1];
        dmpl__SKU__c sku = [Select Id,Name From dmpl__SKU__c LIMIT 1];
        schemeCondition.Add(new dmpl__SchemeCondition__c(dmpl__AccountId__c =customerAccount.Id,
                                                         dmpl__SchemeId__c = scheme.Id,
                                                         dmpl__ItemId__c=item.Id,
                                                         dmpl__ItemGroupId__c=itemGroup.Id,         
                                                         dmpl__AccountGroupId__c =accountGroup.Id,
                                                         dmpl__ItemSKUId__c=sku.Id,         
                                                         dmpl__ConditionType__c='Quantity',
                                                         dmpl__ConditionQuantity__c =5,
                                                         dmpl__ConditionValue__c = 100,
                                                         //dmpl__SequenceNumber__c = 1,
                                                         dmpl__SchemeLineId__c=schemeLine.Id,        
                                                         dmpl__ConditionOperator__c = 'Equals'));
        insert schemeCondition;
        
         List<dmpl__SchemeCondition__c> schemeCondition1 = new List<dmpl__SchemeCondition__c>();
        dmpl__Scheme__c scheme1 =[Select Id, Name from dmpl__Scheme__c  where  dmpl__SchemeType__c='Sales Per Period'  Limit 1];
        dmpl__SchemeLine__c schemeLine1 =[Select Id, Name from dmpl__SchemeLine__c where dmpl__DefinitionFilterCriteria__c = 'Always (No Criteria)' Limit 1];
        schemeCondition1.Add(new dmpl__SchemeCondition__c(dmpl__AccountId__c =customerAccount.Id,
                                                         dmpl__SchemeId__c = scheme1.Id,
                                                         dmpl__ItemId__c=item.Id,
                                                         dmpl__ItemGroupId__c=itemGroup.Id,         
                                                         dmpl__AccountGroupId__c =accountGroup.Id,
                                                         dmpl__ItemSKUId__c=sku.Id,         
                                                         dmpl__ConditionType__c='	Value',
                                                         //dmpl__ConditionQuantity__c =5,
                                                         dmpl__ConditionValue__c = 10000,
                                                         //dmpl__SequenceNumber__c = 1,
                                                         dmpl__SchemeLineId__c=schemeLine1.Id,        
                                                         dmpl__ConditionOperator__c = 'Greater Than'));
        insert schemeCondition1;
       
        
    }
    
    private static void CreateSchemeBenefits()
    {
        List<dmpl__SchemeBenefit__c> schemeBenefit = new List<dmpl__SchemeBenefit__c>();
        dmpl__Scheme__c scheme =[Select Id, Name from dmpl__Scheme__c Limit 1];
        dmpl__SchemeLine__c schemeLine =[Select Id, Name from dmpl__SchemeLine__c Limit 1];
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c where dmpl__ItemType__c='Product'  LIMIT 1];
        dmpl__ItemGroup__c itemGroup =[Select Id, Name from dmpl__ItemGroup__c Limit 1];
        dmpl__SKU__c sku = [Select Id,Name From dmpl__SKU__c LIMIT 1];
        Account customerAccount = [Select Id,Name From Account WHERE dmpl__IsCustomerAccount__c = True LIMIT 1];
        schemeBenefit.Add(new dmpl__SchemeBenefit__c(dmpl__SchemeId__c = scheme.Id, 
                                                     DiscountAmount__c=500,
                                                     DiscountPercent__c=5,
                                                     DiscountedItemId__c=item.Id,
                                                     DiscountedItemSKUId__c=sku.Id,
                                                     DiscountedItemGroupId__c=itemGroup.Id,
                                                     DiscountedItemQuantity__c=4,
                                                     dmpl__RewardType__c='Discounted Item',
                                                     dmpl__RewardPoints__c =500,
                                                     //dmpl__SequenceNumber__c = 1,
                                                     dmpl__SchemeLineId__c=schemeLine.Id       
                                                    ));
        insert schemeBenefit;
        
         List<dmpl__SchemeBenefit__c> schemeBenefit1 = new List<dmpl__SchemeBenefit__c>();
        dmpl__Scheme__c scheme1 =[Select Id, Name,dmpl__SchemeType__c,dmpl__MultipleFulfilmentTreatment__c,dmpl__PeriodType__c from dmpl__Scheme__c where  dmpl__SchemeType__c='Sales Per Period' Limit 1];
        dmpl__SchemeLine__c schemeLine1 =[Select Id, Name from dmpl__SchemeLine__c  where dmpl__DefinitionFilterCriteria__c = 'Always (No Criteria)' Limit 1];
        schemeBenefit1.Add(new dmpl__SchemeBenefit__c(dmpl__SchemeId__c = scheme1.Id, 
                                                      //DiscountAmount__c=500,
                                                     DiscountPercent__c=2,
                                                     //DiscountedItemId__c=item.Id,
                                                     //DiscountedItemSKUId__c=sku.Id,
                                                     //DiscountedItemGroupId__c=itemGroup.Id,
                                                    // DiscountedItemQuantity__c=4,
                                                     dmpl__RewardType__c='Line Level Discount Percent',
                                                     //dmpl__RewardPoints__c =500,
                                                     //dmpl__SequenceNumber__c = 1,
                                                     dmpl__SchemeLineId__c=schemeLine1.Id       
                                                    ));
        insert schemeBenefit1;
        
    }    
    
    
    private static void CreateRepairOrder()
    {
        List<dmpl__RepairOrder__c> repairOrder = new List<dmpl__RepairOrder__c> ();
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c limit 1];
        dmpl__Resource__c resource = [select Id,Name FROM dmpl__Resource__c LIMIT 1];
        dmpl__Scheme__c scheme = [Select Id,Name,dmpl__ValidFrom__c From dmpl__Scheme__c LIMIT 1];
        Account customerAccount = [Select id,Name From Account Where Name = 'Customer-Test-Account' LIMIT 1];
        repairOrder.Add(new dmpl__RepairOrder__c (
            dmpl__BranchId__c = branch.Id,
            dmpl__AccountId__c = customerAccount.Id,
            dmpl__DocumentDate__c=date.today(),
            dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
            dmpl__UsageReading__c = 8,
            dmpl__ServiceAdvisorId__c = resource.Id
        ));
        insert repairOrder;
    }
    
    private static void CreateRepairOrderLine()
    {
        List<dmpl__RepairOrderLine__c> repairOrderLine = new List<dmpl__RepairOrderLine__c>();
        dmpl__RepairOrder__c repairOrder = [Select Id,Name FROM dmpl__RepairOrder__c ];
        dmpl__Item__c item = [Select Id,Name FROM dmpl__Item__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id,Name FROM dmpl__SKU__c LIMIT 1];
        dmpl__Resource__c resource = [select Id,Name FROM dmpl__Resource__c WHERE dmpl__ResourceType__c = 'Technician' LIMIT 1];
        dmpl__SchemeLine__c schemeLine =[Select Id, Name from dmpl__SchemeLine__c Limit 1 ];
        dmpl__TaxGroup__c taxGroup = [Select Id,Name From dmpl__TaxGroup__c LIMIT 1];
        repairOrderLine.add(new dmpl__RepairOrderLine__c(dmpl__ItemId__c = item.Id,
                                                         dmpl__Quantity__c = 5,
                                                         dmpl__CancelledQuantity__c=3,
                                                         dmpl__SKUId__c=sku.Id,
                                                         dmpl__UnitPrice__c = 10,
                                                         dmpl__SchemeLineId__c=schemeLine.Id,
                                                         dmpl__PackageClassification__c = 'Optional Item',
                                                         dmpl__ActionTaken__c = 'Replace',
                                                         dmpl__TechnicianId__c = resource.Id,
                                                         dmpl__WorkStartedBy__c = date.today(),
                                                         dmpl__WorkEndedAt__c = date.today(),
                                                         dmpl__WorkStatus__c = 'Started',
                                                         dmpl__StandardDurationHours__c = 10,
                                                         dmpl__ActualDurationHours__c = 10,
                                                         dmpl__TaxGroupId__c = taxGroup.Id,
                                                         dmpl__RepairOrderId__c = repairOrder.Id
                                                        ));
        insert repairOrderLine;
        
         List<dmpl__RepairOrderLine__c> repairOrderLine1 = new List<dmpl__RepairOrderLine__c>();
     dmpl__SchemeLine__c schemeLine1 =[Select Id, Name from dmpl__SchemeLine__c where dmpl__SchemeId__r.dmpl__SchemeType__c='Sales Per Period'  ];
        repairOrderLine1.add(new dmpl__RepairOrderLine__c(dmpl__ItemId__c = item.Id,
                                                         dmpl__Quantity__c = 5,
                                                         dmpl__CancelledQuantity__c=3,
                                                         dmpl__SKUId__c=sku.Id,
                                                         dmpl__UnitPrice__c = 10,
                                                         dmpl__SchemeLineId__c=schemeLine1.Id,
                                                         dmpl__PackageClassification__c = 'Optional Item',
                                                         dmpl__ActionTaken__c = 'Replace',
                                                         dmpl__TechnicianId__c = resource.Id,
                                                         dmpl__WorkStartedBy__c = date.today(),
                                                         dmpl__WorkEndedAt__c = date.today(),
                                                         dmpl__WorkStatus__c = 'Started',
                                                         dmpl__StandardDurationHours__c = 10,
                                                         dmpl__ActualDurationHours__c = 10,
                                                         dmpl__TaxGroupId__c = taxGroup.Id,
                                                         dmpl__RepairOrderId__c = repairOrder.Id
                                                        ));
        insert repairOrderLine1;
       
        
    }
    
    
    
 private static void CreateSaleOrder()
    {
        List<dmpl__SaleOrder__c> saleOrder = new List<dmpl__SaleOrder__c>();
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c Where Name = 'Test-Branch' LIMIT 1];
       dmpl__Resource__c resource = [Select Id,Name From dmpl__Resource__c LIMIT 1];
         Account partnerAccount1 = [Select Id,Name From Account WHERE Name = 'Customer-Test-Account' LIMIT 1];
        saleOrder.Add(new dmpl__SaleOrder__c(dmpl__AccountId__c = partnerAccount1.Id,
                                             dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                             dmpl__BranchId__c = branch.Id,
                                             dmpl__DocumentDate__c = Date.today(),
                                             dmpl__Status__c = 'Draft',
                                            // dmpl__BillingAddressId__c = contactAddress.Id,
                                            // dmpl__ShippingAddressId__c = contactAddress.Id,
                                             dmpl__RequiredDate__c = Date.today(),
                                             dmpl__SalesExecutiveId__c = resource.Id,
                                             dmpl__BookingAmount__c = 100,
                                             dmpl__PromisedDate__c = Date.today(),
                                             dmpl__PerformReleaseFulfilment__c = false,
                                             dmpl__PerformReleaseInvoice__c = false,
                                             dmpl__PerformReleaseDelivery__c = false,
                                             dmpl__AmountPaid__c = 100
                                            ));
        insert saleOrder;
        
    }
    
    private static void CreateSaleOrderLine()
    {
        List<dmpl__SaleOrderLine__c> saleOrderLine = new List<dmpl__SaleOrderLine__c>();
        dmpl__SaleOrder__c saleOrder = [Select Id,Name From dmpl__SaleOrder__c LIMIT 1];
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id,Name From dmpl__SKU__c LIMIT 1];
        dmpl__SchemeLine__c schemeLine =[Select Id, Name from dmpl__SchemeLine__c Limit 1 ];
        dmpl__TaxGroup__c taxGroup = [Select Id,Name From dmpl__TaxGroup__c LIMIT 1];
        saleOrderLine.Add(new dmpl__SaleOrderLine__c(dmpl__SaleOrderId__c = saleOrder.Id,
                                                     dmpl__ItemId__c = item.Id,
                                                     dmpl__SKUId__c = sku.Id,
                                                    // dmpl__OriginalItemId__c=item.Id,
                                                     //dmpl__ItemComponentId__c=itemcomp.Id,
                                                     dmpl__Quantity__c = 4,
                                                     dmpl__SchemeLineId__c=schemeLine.Id,
                                                     dmpl__TaxGroupId__c = taxGroup.Id,
                                                     dmpl__UnitPrice__c = 100
                                                   //  dmpl__Discount__c = 5
                                                    ));
        insert saleOrderLine;
        
    }
    
     private static void CreateSaleInvoice()
    {
        List<dmpl__SaleInvoice__c> saleInvoice = new List<dmpl__SaleInvoice__c>();
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c Where Name = 'Test-Branch'];
        dmpl__SaleOrder__c saleOrder = [Select Id,Name From dmpl__SaleOrder__c LIMIT 1];
        saleInvoice.Add(new dmpl__SaleInvoice__c(dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                                 dmpl__BranchId__c = Branch.Id,
                                                 dmpl__SaleOrderId__c = saleOrder.id,
                                                 dmpl__DocumentDate__c = Date.today()                                        
                                                ));
        insert saleInvoice;
        
    }
    
    private static void CreateSaleInvoiceLine()
    {
        CreateSaleInvoice();
        List<dmpl__SaleInvoiceLine__c> saleInvoiceLine = new List<dmpl__SaleInvoiceLine__c>();
        dmpl__SaleInvoice__c SaleInvoice = [Select Id,Name From dmpl__SaleInvoice__c LIMIT 1];
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
         dmpl__SchemeLine__c schemeLine =[Select Id, Name from dmpl__SchemeLine__c Limit 1 ];
        dmpl__SKU__c sku = [Select Id,Name FROM dmpl__SKU__c LIMIT 1];
        saleInvoiceLine.Add(new dmpl__SaleInvoiceLine__c(dmpl__SaleInvoiceId__c = SaleInvoice.id,
                                                         dmpl__ItemId__c = item.Id,
                                                          dmpl__SchemeLineId__c=schemeLine.Id,
                                                         dmpl__SKUId__c = sku.Id
                                                        ));
        insert saleInvoiceLine;
        
    }
   
*/    
}