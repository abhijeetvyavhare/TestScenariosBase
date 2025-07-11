@isTest
public with sharing class SchemeEngine_Test {
    @testSetup
    public static void Setup()
    {
        CreateAccountGroup();
        createAccount();
        CreateBranch();
        CreatePriceList();
        CreatePurchaseOrder();
        CreateItems();
        CreateBill();
        // CreateBillLine();
        
        createScheme();
    }
    
    @isTest
    static void processSchemesTest() {
        List<dmpl__Bill__c> billList = [SELECT 
                                                Id, 
                                                Name, 
                                                dmpl__DocumentDate__c,
                                                dmpl__Status__c,
                                                dmpl__PriceListId__c,
                                                dmpl__PartnerAccountId__c,
                                                dmpl__BranchId__c,
                                                dmpl__TaxSupplyType__c,
                                                dmpl__TaxGroupId__c,
                                                dmpl__TaxId__c,
                                                dmpl__TotalLineAmount__c,
                                                dmpl__DiscountGroupId__c,
                                                dmpl__SupplierAccountId__c,
                                                dmpl__PriceAsOnDate__c,
                                                dmpl__TransactionType__c,
                                                dmpl__TCSEligibleAmount__c,
                                                dmpl__SkipScheme__c
                                            FROM dmpl__Bill__c Limit 1];
            Test.startTest();
            SchemeEngine.processSchemes(billList);
            Test.stopTest();
    }

    @isTest
    static void applySchemeBenefitTest() {
        dmpl__Bill__c document = [SELECT 
                                                Id, 
                                                Name, 
                                                dmpl__DocumentDate__c,
                                                dmpl__Status__c,
                                                dmpl__PriceListId__c,
                                                dmpl__PartnerAccountId__c,
                                                dmpl__BranchId__c,
                                                dmpl__TaxSupplyType__c,
                                                dmpl__TaxGroupId__c,
                                                dmpl__TaxId__c,
                                                dmpl__TotalLineAmount__c,
                                                dmpl__DiscountGroupId__c,
                                                dmpl__SupplierAccountId__c,
                                                dmpl__PriceAsOnDate__c,
                                                dmpl__TransactionType__c,
                                                dmpl__TCSEligibleAmount__c,
                                                dmpl__SkipScheme__c
                                            FROM dmpl__Bill__c Limit 1];
        Id schemeLineId = [Select Id from dmpl__SchemeLine__c Limit 1].Id;   
        Id benefitId = [Select Id from dmpl__SchemeBenefit__c Limit 1].Id;   
        Integer benefitCustomIndex = 0;
        Test.startTest();
        SchemeEngine.applySchemeBenefit(document, schemeLineId, benefitId, benefitCustomIndex, null);
        Test.stopTest();

    }

     private static void CreateItems()
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
                                   dmpl__RFID__c = 'O1234fgh'
                                   
                                  ));
        insert item;
    }

    private static void CreateAccountGroup()
    {
        dmpl__AccountGroup__c accountGroup= new dmpl__AccountGroup__c (Name= 'Test-AccountGroup', 
                                                                       dmpl__AccountGroupType__c='Price');
        insert accountGroup;
    }
     private static void CreateBranch()
    {
        List<dmpl__Branch__c> branch = new List<dmpl__Branch__c>();
        Account partnerAccount = [Select Id,Name From Account WHERE Name = 'Partner-Test-Account' AND dmpl__IsPartnerAccount__c = true LIMIT 1];
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
    private static void CreatePurchaseOrder()
    {
        List<dmpl__PurchaseOrder__c> purchaseOrder = new List<dmpl__PurchaseOrder__c>();
        Account supplierAccount = [Select Id,Name From Account WHERE Name = 'Supplier-Test-Account' LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        purchaseOrder.add(new dmpl__PurchaseOrder__c(dmpl__BranchId__c = branch.Id,
        dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
        dmpl__SupplierAccountId__c = supplierAccount.Id,
        dmpl__PurchaseOrderType__c ='VOR PO',
        dmpl__DocumentDate__c = Date.today(),
        dmpl__Remarks__c = 'Remark',
        dmpl__PerformReleaseInvoice__c=true,
        dmpl__IsInvoiceReleased__c=true));
        insert purchaseOrder;
    }
    private static void CreatePriceList()
    {
        List<dmpl__PriceList__c> priceList =new List<dmpl__PriceList__c>();
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        Account account=[Select Id,Name from Account Where Name='Partner-Test-Account' LIMIT 1];
        dmpl__AccountGroup__c accountGroup=[Select Id,Name From dmpl__AccountGroup__c LIMIT 1];
        priceList.Add(new dmpl__PriceList__c(dmpl__PartnerAccountId__c = account.Id,
                                             dmpl__BranchId__c = Branch.Id,
                                             dmpl__PartnerAccountGroupId__c= accountGroup.Id,
                                             dmpl__PartnerGroupId__c=accountGroup.Id,
                                             dmpl__CustomerAccountGroupId__c=accountGroup.Id,
                                             dmpl__CustomerGroupId__c=accountGroup.Id,
                                             dmpl__IsActive__c=true,
                                             dmpl__IsDefault__c=true, 
                                             Name='Test-1'
                                            ));
        insert priceList;
    }
    private static void CreateBill()
    {
        List<dmpl__Bill__c> bill = new List<dmpl__Bill__c>();
        dmpl__PurchaseOrder__c purchaseOrder = [Select Id,Name,dmpl__PartnerAccountId__c,dmpl__BranchId__c FROM dmpl__PurchaseOrder__c LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        Account partnerAccount = [Select Id,Name From Account WHERE Name = 'Partner-Test-Account' LIMIT 1];
        dmpl__PriceList__c priceList = [Select Id,Name From dmpl__PriceList__c LIMIT 1];
        Account supplierAccount = [Select Id,Name From Account WHERE Name = 'Supplier-Test-Account' LIMIT 1];
        bill.add(new dmpl__Bill__c(dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
        dmpl__BranchId__c = branch.Id,
        dmpl__PurchaseOrderId__c = purchaseOrder.Id,
        dmpl__DocumentDate__c = date.today(),
        dmpl__TypeOfBill__c = 'Expense Bill',
        dmpl__PriceListId__c = priceList.Id,
        dmpl__SupplierAccountId__c = supplierAccount.Id,
        dmpl__SupplierInvoiceNumber__c = 'Test-InvoiceNumber',
        dmpl__SupplierInvoiceDate__c = date.today(),
        dmpl__SupplierInvoiceAmount__c = 100
            ));
        insert bill;
    }
    
    private static void CreateBillLine()
    {
        List<dmpl__BillLine__c> billLine = new List<dmpl__BillLine__c>();
        Account customerAccount=[Select Id,Name from Account WHERE Name = 'Customer-Test-Account' LIMIT 1];
        dmpl__Item__c item = [Select Id,Name FROM dmpl__Item__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id,Name From dmpl__SKU__c LIMIT 1];
        dmpl__Bill__c bill = [Select Id,Name From dmpl__Bill__c LIMIT 1];
        dmpl__TaxGroup__c taxGroup = [Select Id,Name From dmpl__TaxGroup__c LIMIT 1];
        billLine.add(new dmpl__BillLine__c(dmpl__ItemId__c = item.Id,
        dmpl__SKUId__c = sku.Id,
        dmpl__AccountId__c = customerAccount.Id,
        dmpl__Quantity__c = 10,
        dmpl__UnitCost__c = 100,
        dmpl__IsCustomerBillable__c = true,
        dmpl__PurchaseInvoiceId__c = bill.Id,
        dmpl__TaxGroupId__c = taxGroup.Id
            ));
        insert billLine;
    }
    
    private static void CreateAccount()
    {
        List<Account> account = new List<Account>();
        dmpl__AccountGroup__c accountGroup = [Select Id,Name From dmpl__AccountGroup__c LIMIT 1];
        account.add(new Account(Name = 'Test - Account',
        Fax = '09876',
        dmpl__LastName__c = 'Account',
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
        dmpl__LastName__c = 'Account',
        dmpl__IsPartnerAccount__c = True,
        dmpl__IsActive__c = true);
        insert partneraccount;
        
        Account supplieraccount = new Account(Name = 'Supplier-Test-Account',
        dmpl__LastName__c = 'Account',
        dmpl__IsSupplierAccount__c = True,
        dmpl__IsActive__c = true);
        insert supplieraccount;
        
        Account customerAccount = new Account(Name = 'Customer-Test-Account',
        dmpl__IsCustomerAccount__c = True,
        dmpl__LastName__c = 'Account',
        dmpl__IsActive__c = true);
        insert customerAccount;
    }
    
    private static void createScheme(){
        List<dmpl__ItemGroup__c> itemGroup = new List<dmpl__ItemGroup__c> ();
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c limit 1];
        Account customerAccount = [Select Id,Name From Account WHERE Name = 'Customer-Test-Account' LIMIT 1];

        itemGroup.Add(new dmpl__ItemGroup__c(Name = 'Item Group Test',
                                             dmpl__ItemGroupType__c = 'Scheme'
                                            ));
        insert itemGroup;
    
        
        List<dmpl__SKU__c> sku = new List<dmpl__SKU__c>();
        dmpl__Item__c item = [Select Id from dmpl__Item__c limit 1];
        sku.add(new dmpl__SKU__c(Name = 'Test - SKU',
                                 dmpl__SKUCode__c = 'Test - SKU - Code',
                                 dmpl__UnitOfMeasureOfConversion__c = 10,
                                 dmpl__ProductColor__c = 'Sample',
                                 dmpl__IsDefault__c = false,
                                 dmpl__QuantityUnitOfMeasure__c ='Sample',
                                 dmpl__ItemId__c = item.Id));
        insert sku;

        List<dmpl__Scheme__c> scheme = new List<dmpl__Scheme__c>();
        scheme.Add(new dmpl__Scheme__c(dmpl__PeriodType__c = 'Per Order',
                                       Name='Scheme1',
                                       dmpl__ValidTo__c= Datetime.now().addDays(365).Date(),
                                       dmpl__Status__c='Approved',
                                       dmpl__MultipleFulfilmentTreatment__c='Apply Last Fulfilled',
                                       dmpl__SchemeType__c='Per Sale Invoice',
                                       dmpl__BranchId__c = branch.Id,
                                       dmpl__ValidFrom__c = date.today()-(2),
                                       dmpl__PartnerAccountId__c = null,
                                       dmpl__PartnerAccountGroupId__c = null,
                                       dmpl__Application__c = 'Auto Apply'));
        insert scheme;
    
        List<dmpl__SchemeLine__c> schemeLine = new List<dmpl__SchemeLine__c>();
        schemeLine.Add(new dmpl__SchemeLine__c(dmpl__DefinitionFilterCriteria__c = 'Any Condition Is Met',
                                               dmpl__SchemeId__c = scheme[0].Id,
                                               dmpl__SequenceNumber__c = 1,
                                               dmpl__RewardApplicability__c = 'All Rewards'));
        
        insert schemeLine;
        
        List<dmpl__SchemeLine__c> schemeLine1 = new List<dmpl__SchemeLine__c>();
        schemeLine1.Add(new dmpl__SchemeLine__c(dmpl__DefinitionFilterCriteria__c = 'Any Condition Is Met',
                                               dmpl__SchemeId__c = scheme[0].Id,
                                               dmpl__SequenceNumber__c = 1,
                                               dmpl__RewardApplicability__c = 'Any One With Lowest Value'));
        
        insert schemeLine1;
        
        List<dmpl__SchemeLine__c> schemeLine2 = new List<dmpl__SchemeLine__c>();
        schemeLine2.Add(new dmpl__SchemeLine__c(dmpl__DefinitionFilterCriteria__c = 'Any Condition Is Met',
                                               dmpl__SchemeId__c = scheme[0].Id,
                                               dmpl__SequenceNumber__c = 1,
                                               dmpl__RewardApplicability__c = 'Any One With Highest Value'));
        
        insert schemeLine2;
    
    
        List<dmpl__SchemeCondition__c> schemeCondition = new List<dmpl__SchemeCondition__c>();
        schemeCondition.Add(new dmpl__SchemeCondition__c(dmpl__AccountId__c =customerAccount.Id,
                                                         dmpl__SchemeId__c = scheme[0].Id,
                                                         dmpl__ItemId__c=item.Id,
                                                         dmpl__ItemGroupId__c=itemGroup[0].Id,         
                                                         dmpl__ItemSKUId__c=sku[0].Id,         
                                                         dmpl__ConditionType__c='Quantity',
                                                         dmpl__ConditionQuantity__c =1,
                                                         dmpl__ConditionValue__c = 100,
                                                         dmpl__SequenceNumber__c = 1,
                                                         dmpl__SchemeLineId__c= schemeLine[0].Id,
                                                         dmpl__ConditionOperator__c = 'Greater Than'));
        insert schemeCondition;
        
        List<dmpl__SchemeCondition__c> schemeCondition1 = new List<dmpl__SchemeCondition__c>();
        schemeCondition1.Add(new dmpl__SchemeCondition__c(dmpl__AccountId__c =customerAccount.Id,
                                                          dmpl__SchemeId__c = scheme[0].Id,
                                                          dmpl__ItemId__c=item.Id,
                                                          dmpl__ItemGroupId__c=itemGroup[0].Id,         
                                                          dmpl__ItemSKUId__c=sku[0].Id,         
                                                          dmpl__ConditionType__c='Value',
                                                          dmpl__ConditionValue__c = 100,
                                                          dmpl__SequenceNumber__c = 2,
                                                          //dmpl__SchemeLineId__c=schemeLine1.Id,
                                                          dmpl__ConditionOperator__c = 'Greater Than'));
        //insert schemeCondition1;
        
        List<dmpl__SchemeCondition__c> schemeCondition3 = new List<dmpl__SchemeCondition__c>();
        schemeCondition3.Add(new dmpl__SchemeCondition__c(dmpl__AccountId__c =customerAccount.Id,
                                                          dmpl__SchemeId__c = scheme[0].Id,
                                                          dmpl__ItemId__c=item.Id,
                                                          dmpl__ItemGroupId__c=itemGroup[0].Id, 
                                                          dmpl__ConditionType__c='Item Group Value',
                                                          dmpl__ConditionValue__c = 100,
                                                          dmpl__SequenceNumber__c = 3,
                                                          dmpl__SchemeLineId__c=schemeLine[0].Id,        
                                                          dmpl__ConditionOperator__c = 'Greater Than'));

        schemeCondition3.Add(new dmpl__SchemeCondition__c(dmpl__AccountId__c =customerAccount.Id,
        dmpl__SchemeId__c = scheme[0].Id,
        dmpl__ItemId__c=item.Id,
        dmpl__ItemGroupId__c=itemGroup[0].Id, 
        dmpl__ConditionType__c='Quantity',
        dmpl__ConditionValue__c = 100,
        dmpl__SequenceNumber__c = 3,
        dmpl__SchemeLineId__c=schemeLine[0].Id,        
        dmpl__ConditionOperator__c = 'Equals'));
        schemeCondition3.Add(new dmpl__SchemeCondition__c(dmpl__AccountId__c =customerAccount.Id,
        dmpl__SchemeId__c = scheme[0].Id,
        dmpl__ItemId__c=item.Id,
        dmpl__ItemGroupId__c=itemGroup[0].Id, 
        dmpl__ConditionType__c='Value',
        dmpl__ConditionValue__c = 100,
        dmpl__SequenceNumber__c = 3,
        dmpl__SchemeLineId__c=schemeLine[0].Id,        
        dmpl__ConditionOperator__c = 'Equals'));
        schemeCondition3.Add(new dmpl__SchemeCondition__c(dmpl__AccountId__c =customerAccount.Id,
        dmpl__SchemeId__c = scheme[0].Id,
        dmpl__ItemId__c=item.Id,
        dmpl__ItemGroupId__c=itemGroup[0].Id, 
        dmpl__ConditionType__c='Value With Tax',
        dmpl__ConditionValue__c = 100,
        dmpl__SequenceNumber__c = 3,
        dmpl__SchemeLineId__c=schemeLine[0].Id,        
        dmpl__ConditionOperator__c = 'Equals'));
        schemeCondition3.Add(new dmpl__SchemeCondition__c(dmpl__AccountId__c =customerAccount.Id,
        dmpl__SchemeId__c = scheme[0].Id,
        dmpl__ItemId__c=item.Id,
        dmpl__ItemGroupId__c=itemGroup[0].Id, 
        dmpl__ConditionType__c='Item Quantity',
        dmpl__ConditionValue__c = 100,
        dmpl__SequenceNumber__c = 3,
        dmpl__SchemeLineId__c=schemeLine[0].Id,        
        dmpl__ConditionOperator__c = 'Equals'));
        schemeCondition3.Add(new dmpl__SchemeCondition__c(dmpl__AccountId__c =customerAccount.Id,
        dmpl__SchemeId__c = scheme[0].Id,
        dmpl__ItemId__c=item.Id,
        dmpl__ItemGroupId__c=itemGroup[0].Id, 
        dmpl__ConditionType__c='Item Value',
        dmpl__ConditionValue__c = 100,
        dmpl__SequenceNumber__c = 3,
        dmpl__SchemeLineId__c=schemeLine[0].Id,        
        dmpl__ConditionOperator__c = 'Less Than Or Equal'));
        schemeCondition3.Add(new dmpl__SchemeCondition__c(dmpl__AccountId__c =customerAccount.Id,
        dmpl__SchemeId__c = scheme[0].Id,
        dmpl__ItemId__c=item.Id,
        dmpl__ItemGroupId__c=itemGroup[0].Id, 
        dmpl__ConditionType__c='Item Value With Tax',
        dmpl__ConditionValue__c = 100,
        dmpl__SequenceNumber__c = 3,
        dmpl__SchemeLineId__c=schemeLine[0].Id,        
        dmpl__ConditionOperator__c = 'Does Not Equal'));
        schemeCondition3.Add(new dmpl__SchemeCondition__c(dmpl__AccountId__c =customerAccount.Id,
        dmpl__SchemeId__c = scheme[0].Id,
        dmpl__ItemId__c=item.Id,
        dmpl__ItemGroupId__c=itemGroup[0].Id, 
        dmpl__ConditionType__c='Item Group Quantity',
        dmpl__ConditionValue__c = 100,
        dmpl__SequenceNumber__c = 3,
        dmpl__SchemeLineId__c=schemeLine[0].Id,        
        dmpl__ConditionOperator__c = 'Greater Than'));
        schemeCondition3.Add(new dmpl__SchemeCondition__c(dmpl__AccountId__c =customerAccount.Id,
        dmpl__SchemeId__c = scheme[0].Id,
        dmpl__ItemId__c=item.Id,
        dmpl__ItemGroupId__c=itemGroup[0].Id, 
        dmpl__ConditionType__c='Item Group Value',
        dmpl__ConditionValue__c = 100,
        dmpl__SequenceNumber__c = 3,
        dmpl__SchemeLineId__c=schemeLine[0].Id,        
        dmpl__ConditionOperator__c = 'Greater Than Or Equal'));
        schemeCondition3.Add(new dmpl__SchemeCondition__c(dmpl__AccountId__c =customerAccount.Id,
        dmpl__SchemeId__c = scheme[0].Id,
        dmpl__ItemId__c=item.Id,
        dmpl__ItemGroupId__c=itemGroup[0].Id, 
        dmpl__ConditionType__c='Item Group Value With Tax',
        dmpl__ConditionValue__c = 100,
        dmpl__SequenceNumber__c = 3,
        dmpl__SchemeLineId__c=schemeLine[0].Id,        
        dmpl__ConditionOperator__c = 'Less Than'));

        insert schemeCondition3;
    
        List<dmpl__SchemeBenefit__c> schemeBenefit = new List<dmpl__SchemeBenefit__c>();
        schemeBenefit.Add(new dmpl__SchemeBenefit__c(dmpl__SchemeId__c = scheme[0].Id, 
                                                    DiscountPercent__c=5,
                                                     DiscountAmount__c=100,
                                                     dmpl__RewardType__c='Reward Points',
                                                     dmpl__SequenceNumber__c = 1,
                                                     dmpl__RepeatReward__c =  true,
                                                     dmpl__SchemeLineId__c=schemeLine[0].Id       
                                                    ));
        insert schemeBenefit;
        
        List<dmpl__SchemeBenefit__c> schemeBenefit1 = new List<dmpl__SchemeBenefit__c>();
        dmpl__SchemeLine__c schemeLine3 =[Select Id, Name from dmpl__SchemeLine__c  Limit 1];
        schemeBenefit1.Add(new dmpl__SchemeBenefit__c(dmpl__SchemeId__c = scheme[0].Id, 
                                                      DiscountAmount__c=500,
                                                      DiscountPercent__c=4,
                                                      dmpl__RewardType__c='Line Level Discount Amount',
                                                      dmpl__SequenceNumber__c = 2,
                                                      dmpl__RepeatReward__c =  true,
                                                      dmpl__SchemeLineId__c=schemeLine3.Id       
                                                     ));
        insert schemeBenefit1;
        
        List<dmpl__SchemeBenefit__c> schemeBenefit3 = new List<dmpl__SchemeBenefit__c>();
        schemeBenefit3.Add(new dmpl__SchemeBenefit__c(dmpl__SchemeId__c = scheme[0].Id, 
                                                      DiscountAmount__c=500,
                                                      DiscountPercent__c=4,
                                                      dmpl__DiscountedItemId__c = item.Id,
                                                      dmpl__RewardType__c='Discounted Item',
                                                      dmpl__SequenceNumber__c = 2,
                                                      dmpl__RepeatReward__c =  true,
                                                      dmpl__SchemeLineId__c=schemeLine3.Id       
                                                     ));
        insert schemeBenefit3;
        
        List<dmpl__SchemeBenefit__c> schemeBenefit4 = new List<dmpl__SchemeBenefit__c>();
        schemeBenefit4.Add(new dmpl__SchemeBenefit__c(dmpl__SchemeId__c = scheme[0].Id, 
                                                      DiscountAmount__c=500,
                                                      DiscountPercent__c=4,
                                                      dmpl__DiscountedItemGroupId__c = itemGroup[0].Id,
                                                      dmpl__RewardType__c='Discounted Item Group',
                                                      dmpl__SequenceNumber__c = 2,
                                                      dmpl__RepeatReward__c =  true,
                                                      dmpl__SchemeLineId__c=schemeLine3.Id       
                                                     ));
        insert schemeBenefit4;

    }
    

    
    
    
}