@isTest
public class SaleOrderLineHelper_Test { 
    
    @testSetup
    public static void Setup()
    {
        System.runAs(PostInstallHelper.AssignAdministratorAllPermissions(UserInfo.getUserId())){
            CreateAccount();
            CreateBranch();
            CreateItems();
            CreateSKu();
            CreatePriceList();
            CreateDiscountGroup();
            CreateResource();
            CreateTaxGroup(); 
            CreateSaleOrder();
            CreateSaleOrderLine(); 
            CreateTax();
        }
    }
    
    @isTest
    public static void DeleteSaleOrdertax()
    {
        test.startTest();
        CreateSaleOrderTax(); 
        CreateSaleOrderTax1();
        dmpl__SaleOrderTax__c saleOrderTax = [Select Id,Name,dmpl__ExternalId__c From dmpl__SaleOrderTax__c LIMIT 1];
        Delete saleOrderTax;
        test.stopTest();
        System.assertEquals(null,saleOrderTax.dmpl__ExternalId__c , 'Sale Order Tax has 1 Record Deleted');
    }
    
    @isTest
    public static void VerifyDeleteExistingSaleOrderTaxes()
    {
        test.startTest();
        CreateSaleOrderTax(); 
       CreateSaleOrderTax1();
        dmpl__SaleOrderTax__c saleOrderTax = [Select Id,Name,dmpl__SaleOrderLineId__c,dmpl__ExternalId__c From dmpl__SaleOrderTax__c LIMIt 1];
        
        delete saleOrderTax;
        test.stopTest();
        System.assertEquals(null, saleOrderTax.dmpl__ExternalId__c, 'Sale Order Tax has 1 Record Deleted');
    }
    
    
    @isTest
    public static void VerifyDeleteExistingSaleOrderLine()
    {
        test.startTest();
        dmpl__SaleOrderLine__c saleOrderLine = [Select Id,Name,dmpl__Quantity__c,dmpl__ExternalId__c From dmpl__SaleOrderLine__c LIMIt 1];
        
        delete saleOrderLine;
        test.stopTest();
        System.assertEquals(null, saleOrderLine.dmpl__ExternalId__c, 'Sale Order Line has 1 Record Deleted');
    }
    
    @isTest
    private static void verifycreateSaleOrderTax()
    {
        test.startTest();
        List<dmpl__SaleOrder__c> lstOfSaleOrders = [Select Id,Name,dmpl__TCSEligibleAmount__c,dmpl__TaxGroupId__c From dmpl__SaleOrder__c];
        dmpl__SaleOrder__c saleOrders = [Select Id,Name,dmpl__TCSEligibleAmount__c,dmpl__TaxGroupId__c From dmpl__SaleOrder__c LIMIT 1];
        dmpl__Tax__c taxes = [Select Id,Name,Rate__c From dmpl__Tax__C LIMIT 1];
        // SaleOrderTaxHelper.createSaleOrderTax(taxes,saleOrders);
        // SaleOrderTaxHelper.deleteApplicableTaxes(lstOfSaleOrders);
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
                                dmpl__IsCustomerAccount__c = False
                               ));
        insert account;
        
        Account partneraccount = new Account(Name = 'Partner-Test-Account',
                                             dmpl__IsPartnerAccount__c = True, 
                                             dmpl__LastName__c = 'Account',
                                             dmpl__IsActive__c = true);
        insert partneraccount;
        
        Account customerAccount = new Account(Name = 'Customer-Test-Account',
                                              dmpl__IsCustomerAccount__c = True,
                                              dmpl__LastName__c = 'Account',
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
    
    private static void CreateContactAddress()
    {
        List<dmpl__ContactAddress__c> contAddress = new List<dmpl__ContactAddress__c>();
        Account account = [Select Id,Name From Account where dmpl__IsCustomerAccount__c = True Limit 1];
        contAddress.add(new dmpl__ContactAddress__c (Name = 'Test-Contact',
                                                     dmpl__AccountId__c = account.Id,
                                                     dmpl__AddressType__c = 'Both'
                                                    ));
        insert contAddress;
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
                                 dmpl__ItemId__c = item.Id));
        insert sku;
    }
    
    private static void CreatePriceList()
    {
        List<dmpl__PriceList__c> priceList =new List<dmpl__PriceList__c>();
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        Account account=[Select Id,Name from Account Where Name='Partner-Test-Account'];
        priceList.Add(new dmpl__PriceList__c(dmpl__PartnerAccountId__c = account.Id,
                                             dmpl__BranchId__c = Branch.Id,
                                             Name='Test-1',
                                             dmpl__PriceListType__c = 'Sale Price',
                                             dmpl__IsActive__c = true,
                                             dmpl__IsDefault__c = true
                                            ));
        insert priceList;
    }
    
    private static void CreateDiscountGroup()
    {
        List<dmpl__DiscountGroup__c> discountGroup = new List<dmpl__DiscountGroup__c>();
        user userId = [Select Id , Name From User LIMIT 1];
        Account partnerAccount = [Select Id , Name From Account where Name = 'Partner-Test-Account' LIMIT 1];
        Account customerAccountGroup = [Select Id , Name From Account LIMIT 1];
        dmpl__Branch__c branch = [Select Id , Name From dmpl__Branch__c LIMIT 1];
        discountGroup.add(new dmpl__DiscountGroup__c(Name = 'Discount-Test',
                                                     dmpl__DiscountType__c = 'Sale Price',
                                                     dmpl__IsActive__c = true,
                                                     dmpl__IsDefault__c = true,
                                                     dmpl__PartnerAccountId__c = partnerAccount.Id,
                                                     dmpl__BranchId__c = branch.Id
                                                    ));
        insert discountGroup;
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
    
    private static void CreateTaxGroup()
    {
        List<dmpl__TaxGroup__c> taxGroup = new List<dmpl__TaxGroup__c>();
        Account account=[Select Id,Name from Account Where Name='Partner-Test-Account'];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        taxGroup.Add(new dmpl__TaxGroup__c(Name = 'Test - Tax Group',
                                           dmpl__PartnerAccountId__c = account.Id,
                                           dmpl__BranchId__c = branch.Id,
                                           dmpl__Description__c = 'Test-Description',
                                           dmpl__IsActive__c = false
                                          ));
        insert taxGroup;
    }
    
    private static void CreateSaleOrder()
    {
        List<dmpl__SaleOrder__c> saleOrder = new List<dmpl__SaleOrder__c>();
        Account customerAccount = [Select Id,Name From Account WHERE dmpl__IsCustomerAccount__c = True LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c LIMIT 1];
        //dmpl__Resource__c resource = [Select Id,Name From dmpl__Resource__c LIMIT 1];
        saleOrder.Add(new dmpl__SaleOrder__c(dmpl__AccountId__c = customerAccount.Id,
                                             dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                             dmpl__BranchId__c = branch.Id,
                                             dmpl__DocumentDate__c = Date.today(),
                                             dmpl__Status__c = 'Draft',
                                             dmpl__RequiredDate__c = Date.today(),
                                             //dmpl__SalesExecutiveId__c = resource.Id,
                                             dmpl__BookingAmount__c = 100,
                                             dmpl__TCSEligibleAmount__c = 100,
                                             dmpl__PromisedDate__c = Date.today(),
                                             dmpl__PerformReleaseFulfilment__c = false,
                                             dmpl__PerformReleaseInvoice__c = false,
                                             dmpl__PerformReleaseDelivery__c = false
                                            ));
        insert saleOrder;
    }
    
    private static void CreateSaleOrderLine()
    {
        List<dmpl__SaleOrderLine__c> saleOrderLine = new List<dmpl__SaleOrderLine__c>();
        dmpl__SaleOrder__c saleOrder = [Select Id,Name From dmpl__SaleOrder__c LIMIT 1];
        dmpl__TaxGroup__c taxGroup = [Select Id,Name From dmpl__TaxGroup__c];
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id,Name From dmpl__SKU__c LIMIT 1];
        
        saleOrderLine.Add(new dmpl__SaleOrderLine__c(dmpl__SaleOrderId__c = saleOrder.Id,
                                                     dmpl__ItemId__c = item.Id,
                                                     dmpl__SKUId__c = sku.Id,
                                                     dmpl__Quantity__c = 1,
                                                     dmpl__TaxGroupId__c=taxGroup.Id,
                                                     dmpl__UnitPrice__c = 10,
                                                     dmpl__Discount__c = 3
                                                    ));
        insert saleOrderLine;
    }
    
    private static void CreateSaleInvoice()
    {
        List<dmpl__SaleInvoice__c> saleInvoice = new List<dmpl__SaleInvoice__c>();
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        Account account=[Select Id,Name from Account Where Name='Partner-Test-Account'];
        Account account1=[Select Id,Name from Account Where Name='Customer-Test-Account'];
        dmpl__DiscountGroup__c discountGroup = [Select Id,Name From dmpl__DiscountGroup__c LIMIT 1 ];
        //dmpl__Resource__c resource = [Select Id,Name From dmpl__Resource__c LIMIT 1];
        dmpl__SaleOrder__c saleOrder = [Select Id,Name From dmpl__SaleOrder__c LIMIT 1];
        saleInvoice.Add(new dmpl__SaleInvoice__c(dmpl__PartnerAccountId__c = account.Id,
                                                 dmpl__BranchId__c = Branch.Id,
                                                 dmpl__DiscountGroupId__c = discountGroup.Id,
                                                 dmpl__DocumentDate__c = date.today(),
                                                 dmpl__SaleOrderId__c = saleOrder.Id,
                                                 dmpl__AccountId__c=account1.Id,
                                                 //dmpl__SalesExecutiveId__c = resource.Id,
                                                 dmpl__FinanceAmount__c = 100,
                                                 dmpl__AmountPaid__c = 100        
                                                ));
        insert saleInvoice;
    }
    
    private static void CreateSaleInvoiceLine()
    {
        CreateSaleInvoice();
        List<dmpl__SaleInvoiceLine__c> saleInvoiceLine = new List<dmpl__SaleInvoiceLine__c>();
        dmpl__SaleInvoice__c SaleInvoice = [Select Id,Name From dmpl__SaleInvoice__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id,Name From dmpl__SKU__c LIMIT 1];
        dmpl__TaxGroup__c taxGroup = [Select Id,Name From dmpl__TaxGroup__c];
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        saleInvoiceLine.Add(new dmpl__SaleInvoiceLine__c(dmpl__SaleInvoiceId__c = SaleInvoice.id,
                                                         dmpl__ItemId__c = item.Id,
                                                         dmpl__SKUId__c = sku.Id,
                                                         dmpl__TaxGroupId__c=taxGroup.Id,
                                                         dmpl__Quantity__c=3,
                                                         dmpl__UnitPrice__c  = 100,
                                                         dmpl__SchemeDiscountAmount__c = 100
                                                        ));
        insert saleInvoiceLine;
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
    
    Private static void CreateSaleOrderTax()
    {
        List<dmpl__SaleOrderTax__c> saleOrderTax = new List<dmpl__SaleOrderTax__c>();
        dmpl__TaxGroup__c taxGroup = [Select Id,Name From dmpl__TaxGroup__c];
        dmpl__Tax__c taxes =[Select Id,Name,dmpl__Rate__c from dmpl__Tax__c];
        dmpl__SaleOrder__c SaleOrder = [Select Id,Name From dmpl__SaleOrder__c LIMIT 1];
        dmpl__SaleOrderLine__c SaleOrderLine = [Select Id,Name From dmpl__SaleOrderLine__c LIMIT 1];
        saleOrderTax.Add(new dmpl__SaleOrderTax__c(dmpl__SaleOrderId__c = SaleOrder.Id,
                                                   dmpl__TaxGroupId__c = taxGroup.Id,
                                                   dmpl__SaleOrderLineId__c = SaleOrderLine.Id,
                                                  dmpl__TaxId__c=taxes.Id,
                                                   dmpl__TaxRate__c = 3,
                                                   dmpl__TaxAmount__c = 150,
                                                   dmpl__TaxOnAmount__c = 100
                                                  ));
        insert saleOrderTax;
    }

    Private static void CreateSaleOrderTax1()
    {
        List<dmpl__SaleOrderTax__c> saleOrderTax = new List<dmpl__SaleOrderTax__c>();
        dmpl__TaxGroup__c taxGroup = [Select Id,Name From dmpl__TaxGroup__c];
        dmpl__Tax__c taxes =[Select Id,Name,dmpl__Rate__c from dmpl__Tax__c];
        dmpl__SaleOrder__c SaleOrder = [Select Id,Name From dmpl__SaleOrder__c LIMIT 1];
        dmpl__SaleOrderLine__c SaleOrderLine = [Select Id,Name From dmpl__SaleOrderLine__c LIMIT 1];
        saleOrderTax.Add(new dmpl__SaleOrderTax__c(dmpl__SaleOrderId__c = SaleOrder.Id,
                                                   dmpl__TaxGroupId__c = taxGroup.Id,
                                                   dmpl__SaleOrderLineId__c = SaleOrderLine.Id,
                                                   dmpl__TaxId__c=taxes.Id,
                                                   dmpl__TaxRate__c = 3,
                                                   dmpl__TaxAmount__c = 100,
                                                   dmpl__TaxOnAmount__c = 100
                                                  ));
        insert saleOrderTax;
    }
}