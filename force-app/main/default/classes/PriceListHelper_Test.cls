/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-30-2024h
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public class PriceListHelper_Test {
    
    @testSetup
    public static void Setup()
    {
        System.runAs(PostInstallHelper.AssignAdministratorAllPermissions(UserInfo.getUserId())){
            CreateAccountGroup();
            CreateAccount();
            CreateContactAddress();
            CreateBranch();
            CreateDiscountGroup();
            CreateItems();
            CreateSKu();
            CreateResource();
            CreatePriceList();
            CreatePriceListRules();
            CreateContactAddress();
            CreateTaxGroup();
            CreateTax();
        }
    }
    
    @isTest
    public Static void Verifymethod()
    {
        test.startTest();
        string errorReceived;
        try{             
            CreateAsset();
            CreateServiceEstimateLines();    
        } catch (Exception ex) {
            errorReceived = ex.getMessage();
        }
        System.assertEquals(null, errorReceived);
        test.stopTest();
    }
   
    public Static void Verifymethod1()
    {
        test.startTest();
        string errorReceived;
        try{             
            CreateBillLine();
            CreateRepairOrderLine();    
        } catch (Exception ex) {
            errorReceived = ex.getMessage();
        }
        System.assertEquals(null, errorReceived);
        test.stopTest();
    }
    @isTest
    public Static void VerifyItemController()
    {
        Test.startTest();
        dmpl__DiscountGroup__c dis  = [select Id, Name from dmpl__DiscountGroup__c Limit 1];
        List<Id> ids= new List<Id>();
        List<Id> idss= new List<Id>();    
        dmpl__PriceList__c priceList = [Select Id, Name From dmpl__PriceList__c LIMIT 1];
        dmpl__SKU__c  sku = [Select Id, Name, dmpl__ItemId__c From dmpl__SKU__c LIMIT 1];
        dmpl__Item__c  items = [Select Id, Name From dmpl__Item__c LIMIT 1];
        ids.add(sku.Id);
        idss.add(items.Id);
        Id  partnerId = [Select Id, Name From Account WHERE dmpl__IsPartnerAccount__c = true LIMIT 1]?.Id;
        Id  branchId = [Select Id, Name From dmpl__Branch__c LIMIT 1]?.Id;
        Id  accountId = [Select Id, Name From Account WHERE dmpl__IsCustomerAccount__c = true LIMIT 1]?.Id;
        dmpl__PriceListRules__c priceRule=[Select Id, Name ,dmpl__PriceListId__c,dmpl__ItemId__c,dmpl__SKUId__c from dmpl__PriceListRules__c];
        ItemController.getItemPrice(priceRule.dmpl__ItemId__c,priceRule.dmpl__SKUId__c,priceRule.dmpl__PriceListId__c, Date.today());
        ItemController.getItemPrice('Sale Price',accountId,partnerId,branchId,priceRule.dmpl__ItemId__c,priceRule.dmpl__SKUId__c, Date.today());
        ItemController.getItemPrices(idss,ids,priceRule.dmpl__PriceListId__c, Date.today());
        ItemController.getItemPrices('Sale Price',accountId,partnerId,branchId,idss,ids, Date.today());
        ItemController.getTaxGroup(priceRule.dmpl__ItemId__c, priceRule.dmpl__SKUId__c, partnerId,branchId, Date.today(), null);
        ItemController.getItemDiscount(priceRule.dmpl__ItemId__c, priceRule.dmpl__SKUId__c,dis.Id,  Date.today());
        Test.stopTest();
        System.assert(dis != null, 'discount group data');
    }
    
    @isTest
    public static void VerifyValidations()
    {
        test.startTest();
        List<dmpl__PriceListRules__c> order = [SELECT Id, dmpl__DateEffectiveFrom__c,dmpl__DateEffectiveTill__c, Name FROM dmpl__PriceListRules__c];       
        ValidationHelper.validateIncrementalDates('dmpl__DateEffectiveTill__c','dmpl__DateEffectiveFrom__c',order);
        System.assertEquals(1, order.size(), 'Inspection Line data');
        test.stopTest();
    }
    
    @isTest
    public Static void VerifyRepairOrder()
    {
        Test.startTest();
        string errorReceived;
        
        CreateRepairOrderLine();
        List<dmpl__RepairOrder__c>  order = [Select Id, Name,dmpl__PriceListId__c,dmpl__PartnerAccountId__c,dmpl__AccountId__c,dmpl__BranchId__c From dmpl__RepairOrder__c];
        PriceListHelper.setDefaultPriceListIds(order);    
        
        Test.stopTest();
        System.assert(order != null, 'Repair Order found');
    }
    
    @isTest
    public Static void VerifyBill()
    {
        Test.startTest();
        CreateBillLine();
        List<dmpl__Bill__c>  bill = [Select Id, Name,dmpl__PriceListId__c,dmpl__PartnerAccountId__c,dmpl__BranchId__c From dmpl__Bill__c];
        PriceListHelper.setDefaultPriceListIds(bill);    
        Test.stopTest();
        System.assert(bill != null, 'bill found');
    }
    
    @isTest
    public static void verifySaleOrder()
    {
        Test.startTest();
        CreateSaleOrder();
        List<dmpl__SaleOrder__c>  saleOrders = [Select Id, Name, dmpl__PartnerAccountId__c, dmpl__AccountId__c, dmpl__BranchId__c, dmpl__PriceListId__c From dmpl__SaleOrder__c];
        PriceListHelper.setDefaultPriceListIds(saleOrders);    
        Test.stopTest();

        System.assert(saleOrders != null, 'Sale Order found');
    }

    @isTest
    public static void verifySaleInvoice()
    {
        Test.startTest();
        CreateSaleOrder();
        CreateSaleInvoice();
        List<dmpl__SaleInvoice__c>  saleInvoices = [Select Id, Name, dmpl__PartnerAccountId__c, dmpl__AccountId__c, dmpl__BranchId__c, dmpl__PriceListId__c From dmpl__SaleInvoice__c];
        PriceListHelper.setDefaultPriceListIds(saleInvoices);    
        Test.stopTest();

        System.assert(saleInvoices != null, 'Sale Order found');
    }
    
    @isTest
    public Static void VerifyQuery()
    {
        Test.startTest();
        Id  accountId = [Select Id, Name From Account WHERE dmpl__IsCustomerAccount__c = true LIMIT 1]?.Id;
        Id  partnerId = [Select Id, Name From Account WHERE dmpl__IsPartnerAccount__c = true LIMIT 1]?.Id;
        Id  branchId = [Select Id, Name From dmpl__Branch__c LIMIT 1]?.Id;
        
        String priceListId = PriceListHelper.getDefaultPriceListId('Sale Price', accountId, partnerId, branchId, Date.today());
        Test.stopTest();
        System.assert(priceListId != null, 'PriceList found');
    }
    
    @isTest
    public static void verifyGetApplicablePrice()
    {
        Test.startTest();
        dmpl__PriceList__c  priceList = [Select Id, Name From dmpl__PriceList__c LIMIT 1];
        dmpl__SKU__c  sku = [Select Id, Name, dmpl__ItemId__c From dmpl__SKU__c LIMIT 1];
        
        Double getApplicablePrice = PriceListHelper.getApplicablePrice(priceList.Id, sku.dmpl__ItemId__c, sku.Id, Date.today());
        Double getApplicablePrice2 = PriceListHelper.getApplicablePrice(priceList.Id, sku.dmpl__ItemId__c, null, Date.today());
       Test.stopTest();
        System.assert(priceList != null, 'price list data');
    }

    @isTest
    public static void getQuoteusingDiscountGroupHelper()
    {
        test.startTest();         
        CreateAsset();
        CreateServiceEstimate();
        CreateServiceEstimateLines();
        List<Quote__c> quote = [SELECT Id, Name FROM Quote__c Limit 1];       
        QuoteLine__c quoteLine=[SELECT Id,Name,QuoteId__c FROM QuoteLine__c Limit 1];       
        Quote__c q = DiscountGroupHelper.getQuote(quoteLine,quote);
        System.assertEquals(q.Name,quote[0].Name,'Inspection Line data');
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
                                Fax = '09876',
                                Phone = '1234567891',
                                dmpl__LastName__c = 'Account',
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
                                dmpl__PartnerDiscountAccountGroupId__c = accountGroup.Id,
                                dmpl__CustomerSchemeAccountGroupId__c = accountGroup.Id,
                                dmpl__PartnerPriceAccountGroupId__c = accountGroup.Id
                               ));
        insert account;
        
        
        Account partneraccount = new Account(Name = 'Partner-Test-Account',
                                             dmpl__IsPartnerAccount__c = True, 
                                             dmpl__LastName__c = 'Account',
                                             dmpl__IsActive__c = true,
                                            dmpl__PartnerPriceAccountGroupId__c =accountGroup.Id);
        insert partneraccount;
        Account supplieraccount = new Account(Name = 'Supplier-Test-Account',
                                              dmpl__IsSupplierAccount__c = True, 
                                              dmpl__LastName__c = 'Account',
                                              dmpl__IsActive__c = true);
        insert supplieraccount;
        
        
        Account customerAccount = new Account(Name = 'Customer-Test-Account',
                                              dmpl__IsCustomerAccount__c = True,
                                              dmpl__LastName__c = 'Account',
                                              dmpl__IsActive__c = true);
        insert customerAccount;
        
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
                                   dmpl__ItemType__c = 'Charge Item',
                                   dmpl__ItemSubType__c = 'Insurance',
                                   dmpl__Description__c = 'NA',
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
                                           dmpl__ResourceType__c = 'Sample',
                                           dmpl__IsActive__c = true,
                                           dmpl__Phone__c = '9999999999',
                                           dmpl__DefaultPartnerAccountId__c = partnerAccount.Id,
                                           dmpl__DefaultBranchId__c = branch.Id
                                          ));
        insert resource;
        
    }
    
    private static void CreatePriceList()
    {
        List<dmpl__PriceList__c> priceList =new List<dmpl__PriceList__c>();
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        Account account=[Select Id,Name from Account Where Name='Partner-Test-Account'];
        dmpl__AccountGroup__c accountGroup=[Select Id,Name From dmpl__AccountGroup__c];
        priceList.Add(new dmpl__PriceList__c(dmpl__PartnerAccountId__c = account.Id,
                                             dmpl__BranchId__c = branch.Id,
                                             //dmpl__PartnerAccountGroupId__c= accountGroup.Id,
                                             dmpl__PartnerGroupId__c=accountGroup.Id,
                                             //dmpl__CustomerAccountGroupId__c=accountGroup.Id,
                                             dmpl__CustomerGroupId__c=accountGroup.Id,
                                             Name='Test-1',
                                             dmpl__PriceListType__c = 'Sale Price',
                                             dmpl__IsActive__c = true,
                                             dmpl__IsDefault__c = true
                                            ));
        priceList.Add(new dmpl__PriceList__c(dmpl__PartnerAccountId__c = account.Id,
                                             dmpl__BranchId__c = branch.Id,
                                             //dmpl__PartnerAccountGroupId__c= accountGroup.Id,
                                             dmpl__PartnerGroupId__c=accountGroup.Id,
                                             //dmpl__CustomerAccountGroupId__c=accountGroup.Id,
                                             dmpl__CustomerGroupId__c=accountGroup.Id,
                                             Name='Test-1',
                                             dmpl__PriceListType__c = 'Purchase Price',
                                             dmpl__IsActive__c = true,
                                             dmpl__IsDefault__c = true
                                            ));
        priceList.Add(new dmpl__PriceList__c(dmpl__PartnerAccountId__c = account.Id,
                                             dmpl__BranchId__c = branch.Id,
                                             //dmpl__PartnerAccountGroupId__c= accountGroup.Id,
                                             dmpl__PartnerGroupId__c=accountGroup.Id,
                                             //dmpl__CustomerAccountGroupId__c=accountGroup.Id,
                                             dmpl__CustomerGroupId__c=accountGroup.Id,
                                             Name='Test-1',
                                             dmpl__PriceListType__c = 'Cost Price',
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
        priceListRules.Add(new dmpl__PriceListRules__c(dmpl__ItemId__c = item.Id,
                                                       dmpl__PriceListId__c=priceList.Id,
                                                       dmpl__Price__c=500,
                                                       dmpl__DateEffectiveFrom__c = date.today()-(7),
                                                       dmpl__DateEffectiveTill__c=date.today()
                                                      ));
        insert priceListRules;       
    }  
    
    private static void CreateDiscountGroup()
    {
        List<dmpl__DiscountGroup__c> discountGroup = new List<dmpl__DiscountGroup__c>();
        user userId = [Select Id , Name From User LIMIT 1];
        Account partnerAccount = [Select Id , Name From Account where Name = 'Partner-Test-Account' LIMIT 1];
        dmpl__AccountGroup__c partnerAccountGroup = [Select Id , Name From dmpl__AccountGroup__c LIMIT 1];
        Account customerAccountGroup = [Select Id , Name From Account LIMIT 1];
        dmpl__Branch__c branch = [Select Id , Name From dmpl__Branch__c LIMIT 1];
        discountGroup.add(new dmpl__DiscountGroup__c(Name = 'Discount-Test',
                                                     dmpl__DiscountType__c = 'Sale Price',
                                                     dmpl__IsActive__c = true,
                                                     dmpl__IsDefault__c = true,
                                                     dmpl__PartnerAccountId__c = partnerAccount.Id,
                                                     dmpl__PartnerAccountGroupId__c = partnerAccountGroup.Id,
                                                     dmpl__BranchId__c = branch.Id
                                                    ));
        
        insert discountGroup;
        
        List<dmpl__AutoPurchaseOrder__c> autoP = new List<dmpl__AutoPurchaseOrder__c>();
        autoP.add(new dmpl__AutoPurchaseOrder__c(dmpl__PartnerAccountId__c = partnerAccount.Id,
                                                     dmpl__BranchId__c = branch.Id
                                                    ));
        
        insert autoP;
        PriceListHelper.setDefaultPriceListIds(autoP);
        
    }
    
    private static void CreateSaleOrder()
    {
        List<dmpl__SaleOrder__c> saleOrder = new List<dmpl__SaleOrder__c>();
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c LIMIT 1];
        dmpl__PriceList__c priceList = [Select Id,Name,dmpl__PartnerAccountId__c,dmpl__BranchId__c From dmpl__PriceList__c LIMIT 1];
        dmpl__ContactAddress__c contactAddress = [Select Id,Name,dmpl__AccountId__c From dmpl__ContactAddress__c LIMIT 1];
        dmpl__Resource__c resource = [Select Id,Name From dmpl__Resource__c LIMIT 1];
        saleOrder.Add(new dmpl__SaleOrder__c(dmpl__AccountId__c = contactAddress.dmpl__AccountId__c,
                                             dmpl__PartnerAccountId__c =priceList.dmpl__PartnerAccountId__c,
                                             dmpl__BranchId__c = priceList.dmpl__BranchId__c,
                                             dmpl__DocumentDate__c = Date.today(),
                                             dmpl__Status__c = 'Draft',
                                             dmpl__BillingAddressId__c = contactAddress.Id,
                                             dmpl__ShippingAddressId__c = contactAddress.Id,
                                             dmpl__RequiredDate__c = Date.today(),
                                             dmpl__SalesExecutiveId__c = resource.Id,
                                             dmpl__BookingAmount__c = 100,
                                             dmpl__PromisedDate__c = Date.today(),
                                             dmpl__PerformReleaseFulfilment__c = false,
                                             dmpl__PerformReleaseInvoice__c = false,
                                             dmpl__PerformReleaseDelivery__c = false
                                             
                                            ));
        insert saleOrder;
        PriceListHelper.setDefaultPriceListIds(saleOrder); 
        
    }
    
    private static void CreateSaleOrderLine()
    {
        CreateSaleOrder();
        List<dmpl__SaleOrderLine__c> saleOrderLine = new List<dmpl__SaleOrderLine__c>();
        dmpl__SaleOrder__c saleOrder = [Select Id,Name From dmpl__SaleOrder__c LIMIT 1];
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id,Name From dmpl__SKU__c LIMIT 1];
        dmpl__TaxGroup__c taxGroup = [Select Id,Name From dmpl__TaxGroup__c LIMIT 1];
        saleOrderLine.Add(new dmpl__SaleOrderLine__c(dmpl__SaleOrderId__c = saleOrder.Id,
                                                     dmpl__ItemId__c = item.Id,
                                                     dmpl__SKUId__c = sku.Id,
                                                     dmpl__Quantity__c = 10,
                                                     dmpl__TaxGroupId__c = taxGroup.Id,
                                                     dmpl__IsPriceBundled__c=false
                                                    ));
        insert saleOrderLine;
        
    }
    
    private static void CreateSaleInvoice()
    {
        List<dmpl__SaleInvoice__c> saleInvoice = new List<dmpl__SaleInvoice__c>();
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        dmpl__SaleOrder__c saleOrder = [Select Id,Name From dmpl__SaleOrder__c LIMIT 1];
        dmpl__DiscountGroup__c discountGroup = [Select Id,Name From dmpl__DiscountGroup__c LIMIT 1];
        dmpl__Resource__c saleExecutive = [Select Id,Name From dmpl__Resource__c LIMIT 1];
        saleInvoice.Add(new dmpl__SaleInvoice__c(dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                                 dmpl__BranchId__c = branch.Id,
                                                 dmpl__SaleOrderId__c = saleOrder.id,
                                                 dmpl__AmountPaid__C =1,
                                                 dmpl__DiscountGroupId__c = discountGroup.Id,
                                                 dmpl__DocumentDate__c = Date.today(),
                                                 dmpl__SalesExecutiveId__c = saleExecutive.Id,
                                                 dmpl__FinanceAmount__c = 10.00
                                                ));
        insert saleInvoice;
        
    }
    
    private static void CreateSaleInvoiceLine()
    {
        CreateSaleInvoice();
        List<dmpl__SaleInvoiceLine__c> saleInvoiceLine = new List<dmpl__SaleInvoiceLine__c>();
        dmpl__SaleInvoice__c saleInvoice = [Select Id,Name From dmpl__SaleInvoice__c LIMIT 1];
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id,Name From dmpl__SKU__c LIMIT 1];
        dmpl__TaxGroup__c taxGroup = [Select Id,Name From dmpl__TaxGroup__c LIMIT 1];
        saleInvoiceLine.Add(new dmpl__SaleInvoiceLine__c(dmpl__SaleInvoiceId__c = saleInvoice.id,
                                                         dmpl__ItemId__c = item.Id,
                                                         dmpl__SKUId__c = sku.Id,
                                                         dmpl__TaxGroupId__c = taxGroup.Id
                                                        ));
        insert saleInvoiceLine;
        
    }
    
    private static void CreateTaxGroup()
    {
        List<dmpl__TaxGroup__c> taxGroup = new List<dmpl__TaxGroup__c>();
        Account account=[Select Id,Name from Account Where Name='Partner-Test-Account'];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        dmpl__AccountGroup__c accountGroup = [Select Id, Name FROM dmpl__AccountGroup__c LIMIT 1];
        taxGroup.Add(new dmpl__TaxGroup__c(Name = 'Test - Tax Group',
                                           dmpl__PartnerAccountId__c = account.Id,
                                           dmpl__BranchId__c = branch.Id,
                                           dmpl__PartnerAccountGroupId__c = accountGroup.Id,
                                           dmpl__Description__c = 'Test-Description',
                                           dmpl__IsActive__c = true
                                          ));
        insert taxGroup;
        
    }
    
    private static void CreateTax()
    {
        List<dmpl__Tax__c> tax = new List<dmpl__Tax__c>();
        dmpl__TaxGroup__c taxGroup = [Select Id,Name From dmpl__TaxGroup__c];
        tax.Add(new dmpl__Tax__c(Name = 'Test - Tax',
                                 dmpl__TaxGroupId__c = taxGroup.Id,
                                 dmpl__Type__c = 'Cess',
                                 dmpl__PostingFieldName__c = 'Tax1',
                                 dmpl__Rate__c = 10
                                ));        
        insert tax;
        
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
                                                     dmpl__Remarks__c = 'Remark'));
        insert purchaseOrder;
        
    }
    
    private static void CreatePurchaseOrderLine()   
    {
        CreatePurchaseOrder() ;
        List<dmpl__PurchaseOrderLine__c> purchaseOrderLine = new List<dmpl__PurchaseOrderLine__c>();
        dmpl__Item__c listofitem = [Select Id, Name from dmpl__Item__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id,Name FROM dmpl__SKU__c LIMIT 1];
        dmpl__PurchaseOrder__c purchaseOrder = [Select Id, Name FROM dmpl__PurchaseOrder__c LIMIT 1];
        dmpl__TaxGroup__c taxGroup = [Select Id,Name From dmpl__TaxGroup__c LIMIT 1];
        purchaseOrderLine.add(new dmpl__PurchaseOrderLine__c(dmpl__ItemId__c = listofitem.Id,
                                                             dmpl__SKUId__c = sku.Id,
                                                             dmpl__PurchaseOrderId__c = purchaseOrder.Id,
                                                             dmpl__Quantity__c = 1,
                                                             dmpl__TaxGroupId__c = taxGroup.Id
                                                            ));
        insert purchaseOrderLine;
        
    }
    
    private static void CreateServiceEstimate()
    { 
        List<dmpl__Quote__c> ServiceEstimate = new List<dmpl__Quote__c>();
        Account account = [Select Id,Name From Account Where Name = 'Customer-Test-Account' LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c LIMIT 1];
        dmpl__Item__c item = [Select Id,Name,dmpl__ItemType__c From dmpl__Item__c LIMIT 1];
        Asset asset = [Select Id,Name From Asset LIMIT 1];
        ServiceEstimate.Add(new dmpl__Quote__c(dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                               dmpl__BranchId__c = branch.Id,
                                               dmpl__AccountId__c = account.Id,
                                               dmpl__AssetId__c = asset.Id,
                                               dmpl__PerformEstimateLinesGeneration__c = false,
                                               dmpl__PerformApproval__c = false,
                                               dmpl__PerformDecline__c = false,
                                               dmpl__PerformRepairOrderGeneration__c = false,
                                               dmpl__IsRepairOrderGenerated__c = false));
        insert ServiceEstimate;       
    } 
    
    private static void CreateServiceEstimateLines()
    {
        CreateServiceEstimate();
        List<dmpl__QuoteLine__c> ServiceEstimateLine = new List<dmpl__QuoteLine__c>();
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        dmpl__TaxGroup__c taxGroup = [Select Id,Name From dmpl__TaxGroup__c LIMIT 1];
        dmpl__Quote__c serviceEstimate = [Select Id,Name From dmpl__Quote__c LIMIT 1];
        ServiceEstimateLine.Add(new dmpl__QuoteLine__c(dmpl__ItemId__c = item.Id,
                                                       dmpl__Quantity__c = 50,
                                                       dmpl__UnitPrice__c = 10,
                                                       dmpl__TaxGroupId__c=taxGroup.Id,
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
    
    private static void CreateAsset()
    {
        List<Asset> asset = new List<Asset>();
        Account account = [Select Id,Name From Account WHERE Name = 'Customer-Test-Account' LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name From dmpl__Branch__c LIMIT 1];
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        asset.add(new Asset(Name = 'Test-Asset',
                            AccountId = account.Id,
                            dmpl__LastServiceBranchId__c = branch.Id,
                            dmpl__ItemId__c = item.Id,
                            dmpl__RegistrationNumber__c = 'Axb371',
                            dmpl__SaleDate__c = date.today()
                           ));
        insert asset;
    }
    
    private static void CreateBill()
    {
        CreatePurchaseOrder() ;
        
        List<dmpl__Bill__c> bill = new List<dmpl__Bill__c>();
        dmpl__PurchaseOrder__c purchaseOrder = [Select Id,Name,dmpl__PartnerAccountId__c,dmpl__BranchId__c FROM dmpl__PurchaseOrder__c LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        Account partnerAccount = [Select Id,Name From Account WHERE Name = 'Partner-Test-Account' LIMIT 1];
        dmpl__PriceList__c priceList = [Select Id,Name From dmpl__PriceList__c Where dmpl__PriceListType__c = 'Purchase Price'];
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
                                   dmpl__SupplierInvoiceAmount__c = 100,
                                   dmpl__PerformGLPosting__c = true
                                  ));
        insert bill;
    }
    
    private static void CreateBillLine()
    {
        CreateBill();
        List<dmpl__BillLine__c> billLine = new List<dmpl__BillLine__c>();
        Account customerAccount=[Select Id,Name from Account WHERE Name = 'Customer-Test-Account' LIMIT 1];
        dmpl__Item__c item = [Select Id,Name FROM dmpl__Item__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id,Name From dmpl__SKU__c LIMIT 1];
        dmpl__Bill__c bill = [Select Id,Name From dmpl__Bill__c LIMIT 1];
        dmpl__PriceListRules__c rule=[select Id, Name From dmpl__PriceListRules__c];
        dmpl__TaxGroup__c taxGroup = [Select Id,Name From dmpl__TaxGroup__c LIMIT 1];
        billLine.add(new dmpl__BillLine__c(dmpl__ItemId__c = item.Id,
                                           dmpl__SKUId__c = sku.Id,
                                           dmpl__PriceListRuleId__c=rule.Id,
                                           dmpl__AccountId__c = customerAccount.Id,
                                           dmpl__Quantity__c = 10,
                                           dmpl__UnitCost__c = 100,
                                           dmpl__IsCustomerBillable__c = true,
                                           dmpl__PurchaseInvoiceId__c = bill.Id,
                                           dmpl__TaxGroupId__c = taxGroup.Id
                                          ));
        insert billLine;
    }
    private static void CreateRepairOrder()
    {
        CreateAsset();
        CreateServiceEstimate();
        List<dmpl__RepairOrder__c> repairOrder = new List<dmpl__RepairOrder__c> ();
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        //dmpl__Resource__c resource = [select Id,Name FROM dmpl__Resource__c LIMIT 1];
        Asset asset = [Select Id,Name From Asset LIMIT 1];
        dmpl__Quote__c serviceEstimate = [Select Id,Name From dmpl__Quote__c LIMIT 1];
        Account customerAccount = [Select id,Name From Account Where Name = 'Customer-Test-Account' LIMIT 1];
        repairOrder.Add(new dmpl__RepairOrder__c (
            dmpl__BranchId__c = branch.Id,
            dmpl__AccountId__c = customerAccount.Id,
            dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
            dmpl__AssetId__c = asset.Id,
            dmpl__ServiceEstimateId__c = serviceEstimate.Id,
            dmpl__UsageReading__c = 8
            //dmpl__ServiceAdvisorId__c = resource.Id
        ));
        insert repairOrder;
    }
    
    private static void CreateRepairOrderLine()
    {
        CreateRepairOrder();
        List<dmpl__RepairOrderLine__c> repairOrderLine = new List<dmpl__RepairOrderLine__c>();
        dmpl__RepairOrder__c repairOrder = [Select Id,Name FROM dmpl__RepairOrder__c LIMIT 1];
        dmpl__Item__c item = [Select Id,Name FROM dmpl__Item__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id,Name FROM dmpl__SKU__c LIMIT 1];
        dmpl__TaxGroup__c taxGroup = [Select Id,Name From dmpl__TaxGroup__c LIMIT 1];
        repairOrderLine.add(new dmpl__RepairOrderLine__c(dmpl__ItemId__c = item.Id,
                                                         dmpl__Quantity__c = 5,
                                                         dmpl__CancelledQuantity__c=3,
                                                         dmpl__SKUId__c=sku.Id,
                                                         dmpl__PackageClassification__c = 'Optional Item',
                                                         dmpl__ActionTaken__c = 'Replace',
                                                         dmpl__WorkStartedBy__c = date.today(),
                                                         dmpl__WorkEndedAt__c = date.today(),
                                                         dmpl__WorkStatus__c = 'Started',
                                                         dmpl__StandardDurationHours__c = 10,
                                                         dmpl__ActualDurationHours__c = 10,
                                                         dmpl__TaxGroupId__c = taxGroup.Id,
                                                         dmpl__RepairOrderId__c = repairOrder.Id
                                                        ));
        insert repairOrderLine;
    }
}