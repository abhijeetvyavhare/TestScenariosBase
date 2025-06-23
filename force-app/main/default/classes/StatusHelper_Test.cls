@isTest
public class StatusHelper_Test {
    
    @testSetup
    public static void Setup()
    {
        System.runAs(PostInstallHelper.AssignAdministratorAllPermissions(UserInfo.getUserId())){
            CreateAccountGroup();
            CreateAccount();
        }
    }
    
    @isTest
    Static void VerifyCreateAccount()
    {
        test.starttest();
        List<Account>  account = [Select Id, Name From Account];
        test.stoptest();
        System.assertNotEquals(null, account, 'Test Accounts are not found');
        System.assertEquals(3, account.size(), 'Test Accounts have more than 1 record');
    }
    
    @isTest
    public static void validateStatusEdit()
    {
        test.startTest();
        List<Account>  account = [Select Id, Name From Account];
        dmpl__AccountGroup__c accountGroup = [Select Id,Name From dmpl__AccountGroup__c LIMIT 1];
        StatusHelper.validateStatusEdit('dmpl__AccountGroup__c', 'Name', Account, Account);
        System.assert(account != null, 'Account data');
        test.stopTest();
    }
    
    @isTest
    public static void validateStatusNew()
    {
        test.startTest();
        List<Account>  account = [Select Id, Name From Account];
        dmpl__AccountGroup__c accountGroup = [Select Id,Name From dmpl__AccountGroup__c LIMIT 1];
        StatusHelper.validateStatusNew('dmpl__AccountGroup__c', 'Name', Account);
        System.assert(account != null, 'Account data');
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
    
    private static void CreateTaxGroup()
    {
        List<dmpl__TaxGroup__c> taxGroup = new List<dmpl__TaxGroup__c>();
        Account account=[Select Id,Name from Account Where Name='Partner-Test-Account'];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c]; 
        dmpl__AccountGroup__c accountGroup = [Select Id,Name From dmpl__AccountGroup__c ];
        taxGroup.Add(new dmpl__TaxGroup__c(Name = 'Test - Tax Group',
                                           dmpl__PartnerAccountId__c = account.Id,
                                           dmpl__BranchId__c = branch.Id,
                                           dmpl__PartnerAccountGroupId__c = accountGroup.Id,
                                           dmpl__Description__c = 'Description',
                                           dmpl__IsActive__c = true
                                          ));
        insert taxGroup;
    }
    
    private static void CreateSaleOrder()
    {
        List<dmpl__SaleOrder__c> saleOrder = new List<dmpl__SaleOrder__c>();
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c LIMIT 1];
        dmpl__ContactAddress__c contactAddress = [Select Id,Name,dmpl__AccountId__c From dmpl__ContactAddress__c LIMIT 1];
        dmpl__Resource__c resource = [Select Id,Name From dmpl__Resource__c LIMIT 1];
        saleOrder.Add(new dmpl__SaleOrder__c(dmpl__AccountId__c = contactAddress.dmpl__AccountId__c,
                                             dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                             dmpl__BranchId__c = branch.Id,
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
                                             dmpl__PerformReleaseDelivery__c = false));
        insert saleOrder;
    }
    
    private static void CreateSaleOrderLine()
    {
        List<dmpl__SaleOrderLine__c> saleOrderLine = new List<dmpl__SaleOrderLine__c>();
        dmpl__SaleOrder__c saleOrder = [Select Id,Name From dmpl__SaleOrder__c LIMIT 1];
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id,Name From dmpl__SKU__c LIMIT 1];
        dmpl__TaxGroup__c taxGroup = [Select Id,Name From dmpl__TaxGroup__c LIMIT 1];
        saleOrderLine.Add(new dmpl__SaleOrderLine__c(dmpl__SaleOrderId__c = saleOrder.Id,
                                                     dmpl__ItemId__c = item.Id,
                                                     dmpl__SKUId__c = sku.Id,
                                                     dmpl__Quantity__c = 1,
                                                     dmpl__TaxGroupId__c = taxGroup.Id,
                                                     dmpl__UnitPrice__c = 100,
                                                     dmpl__Discount__c = 5));
        insert saleOrderLine;
    }
    
    private static void CreateSaleInvoice()
    {
        List<dmpl__SaleInvoice__c> saleInvoice = new List<dmpl__SaleInvoice__c>();
        Account account = [Select Id,Name From Account WHERE Name = 'Customer-Test-Account' LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c LIMIT 1];
        dmpl__SaleOrder__c saleOrder = [Select Id,Name From dmpl__SaleOrder__c LIMIT 1];
        dmpl__Resource__c resource = [Select Id,Name From dmpl__Resource__c LIMIT 1];
        saleInvoice.Add(new dmpl__SaleInvoice__c(dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                                 dmpl__BranchId__c = Branch.Id,
                                                 dmpl__DocumentDate__c = date.today(),
                                                 dmpl__AccountId__c = account.Id,
                                                 dmpl__SalesExecutiveId__c = resource.Id,
                                                 dmpl__SaleOrderId__c = saleOrder.Id,
                                                 dmpl__FinanceAmount__c=100,
                                                 dmpl__AmountPaid__C =1 
                                                ));
        insert saleInvoice;
    }
    
    private static void CreateSaleInvoiceLine()
    {
        List<dmpl__SaleInvoiceLine__c> saleInvoiceLine = new List<dmpl__SaleInvoiceLine__c>();
        dmpl__SaleInvoice__c SaleInvoice = [Select Id,Name From dmpl__SaleInvoice__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id ,Name From dmpl__SKU__c LIMIT 1 ];
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        dmpl__TaxGroup__c taxGroup = [Select Id,Name From dmpl__TaxGroup__c LIMIT 1];
        saleInvoiceLine.Add(new dmpl__SaleInvoiceLine__c(dmpl__SaleInvoiceId__c = SaleInvoice.id,
                                                         dmpl__ItemId__c = item.Id,
                                                         dmpl__SKUId__c = sku.Id,
                                                         dmpl__Quantity__c = 100,
                                                         dmpl__UnitPrice__c = 100,
                                                         dmpl__SchemeDiscountAmount__c = 100,
                                                         dmpl__TaxGroupId__c = taxGroup.Id ));
        insert saleInvoiceLine;
    }
    
    private static void CreateNewPayment()
    {
        List<dmpl__Payment__c> payment = new List<dmpl__Payment__c>();
        dmpl__SaleOrder__c saleOrder = [Select Id,Name From dmpl__SaleOrder__c LIMIT 1];
        dmpl__SaleInvoice__c saleInvoice = [Select Id,Name From dmpl__SaleInvoice__c LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        Account customerAccount = [Select Id,Name From Account WHERE dmpl__IsCustomerAccount__c = True LIMIT 1];
        payment.Add(new dmpl__Payment__c(dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                         dmpl__BranchId__c = branch.Id,
                                         dmpl__AccountId__c = customerAccount.Id,
                                         dmpl__PaymentDate__c = Date.today(),
                                         dmpl__Amount__c = 1000,
                                         dmpl__PaymentMode__c = 'Cash',
                                         dmpl__SaleInvoiceId__c = saleInvoice.Id,
                                         dmpl__SaleOrderId__c = saleOrder.Id));
        insert payment;
    }
    
    private static void CreateFinanceCase()
    {
        CreateFinancer();
        CreateFinancerScheme();
        List<dmpl__FinanceCase__c> financeCase = new List<dmpl__FinanceCase__c>();
        dmpl__Financer__c financer = [Select Id,Name From dmpl__Financer__c LIMIT 1];
        dmpl__FinancerScheme__c financerScheme = [Select Id,Name From dmpl__FinancerScheme__c LIMIT 1];
        dmpl__SaleOrder__c saleOrder = [Select Id,Name From dmpl__SaleOrder__c LIMIT 1];
        dmpl__SaleInvoice__c saleInvoice = [Select Id,Name From dmpl__SaleInvoice__c LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        financeCase.Add(new dmpl__FinanceCase__c(dmpl__SaleOrderId__c = saleOrder.Id,
                                                 dmpl__BranchId__c = branch.Id,
                                                 dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                                 dmpl__FinanceSchemeId__c = financerScheme.Id,
                                                 dmpl__FinanceProviderId__c = financer.Id,
                                                 dmpl__RequestedDownPayment__c = 100,
                                                 dmpl__RequestedAmount__c =100,
                                                 dmpl__RequestedTenureMonths__c = 12,
                                                 dmpl__RequestedInterestRate__c = 5,
                                                 dmpl__EMIOnRequestedAmount__c =20,
                                                 dmpl__SaleInvoiceId__c = saleInvoice.Id
                                                ));
        insert financeCase;
    }
    
    private static void CreateFinancer()
    {
        List<dmpl__Financer__c> financer = new List<dmpl__Financer__c>();
        Account customerAccount = [Select Id,Name From Account WHERE dmpl__IsCustomerAccount__c = True LIMIT 1];
        financer.Add(new dmpl__Financer__c(Name = 'Test-Financer',
                                           dmpl__AccountId__c = customerAccount.Id
                                          ));
        insert financer;
    }
    
    private static void CreateFinancerScheme()
    {
        List<dmpl__FinancerScheme__c> financerScheme = new List<dmpl__FinancerScheme__c>();
        dmpl__Financer__c financer = [Select Id,Name From dmpl__Financer__c LIMIT 1];
        financerScheme.Add(new dmpl__FinancerScheme__c(Name = 'Test-FinancerScheme',
                                                       dmpl__FinancerId__c = financer.Id));
        insert financerScheme;
    }
}