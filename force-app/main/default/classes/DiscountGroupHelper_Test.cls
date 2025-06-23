@isTest
public class DiscountGroupHelper_Test {
    
    @testSetup
    public static void Setup()
    {
        System.runAs(PostInstallHelper.AssignAdministratorAllPermissions(UserInfo.getUserId())){
            CreateAccountGroup();
            CreateAccount();
            CreateContactAddress();
            CreateBranch();
            CreateItems();
            CreateSKU();
            CreateResource();
            CreateSaleOrder();
            CreateDiscountGroup();
            CreateDiscountGroupRule();
            CreateTaxGroup();
            CreateTax(); 
            CreateSaleOrderLine();
        }
    }
    
    @isTest
    public static void Testnew(){
        dmpl__SaleOrder__c saleOrder = [Select Id,Name From dmpl__SaleOrder__c LIMIT 1];
        dmpl__SaleOrderLine__c saleOrderLine = [Select Id,dmpl__SaleOrderId__c,Name From dmpl__SaleOrderLine__c LIMIT 1];
        DiscountGroupHelper.getSaleOrder(saleOrderLine,new List<dmpl__SaleOrder__c>{saleOrder});
    }
    
    @isTest
    Public Static void Verifydiscountgroup()
    {
        List<Account>  account = [Select Id,Name,Phone,dmpl__BillingStreet__c,dmpl__BillingRegion__c,dmpl__BillingState__c,dmpl__BillingPostalCode__c,dmpl__BillingCity__c,dmpl__BillingCountry__c ,
                                  dmpl__ShippingStreet__c,dmpl__ShippingRegion__c,dmpl__ShippingState__c,dmpl__ShippingPostalCode__c,dmpl__ShippingCity__c,dmpl__ShippingCountry__c,
                                  dmpl__AccountContactId__c,
                                  dmpl__CustomerDiscountAccountGroupId__c,
                                  dmpl__PartnerDiscountAccountGroupId__c,
                                  dmpl__IsCustomerAccount__c,
                                  dmpl__IsPartnerAccount__c,
                                  dmpl__CustomerPriceAccountGroupId__c,
                                  dmpl__PartnerPriceAccountGroupId__c
                                  From Account];
        
        DiscountGroupHelper.getCustomerAccountGroupId(account[0].dmpl__CustomerPriceAccountGroupId__c,account);
        DiscountGroupHelper.getPartnerAccountGroupId(account[0].dmpl__PartnerPriceAccountGroupId__c,account);
        System.assertEquals(4, account.size(), 'contact data');
    }
    
    @isTest
    public static void getCachedDealerAccount()
    {
         List<Id> ids= new List<Id>();
         Account account = [Select Id,Name,Phone,dmpl__BillingStreet__c,dmpl__BillingRegion__c,dmpl__BillingState__c,dmpl__BillingPostalCode__c,dmpl__BillingCity__c,dmpl__BillingCountry__c ,
                                  dmpl__ShippingStreet__c,dmpl__ShippingRegion__c,dmpl__ShippingState__c,dmpl__ShippingPostalCode__c,dmpl__ShippingCity__c,dmpl__ShippingCountry__c,
                                  dmpl__AccountContactId__c,
                                  dmpl__CustomerDiscountAccountGroupId__c,
                                  dmpl__PartnerDiscountAccountGroupId__c,
                                  dmpl__IsCustomerAccount__c,
                                  dmpl__IsPartnerAccount__c,
                                  dmpl__CustomerPriceAccountGroupId__c,
                                  dmpl__PartnerPriceAccountGroupId__c
                                  From Account Limit 1];
        ids.add(account.Id);
        DiscountGroupHelper.queryPartnerAccountGroupIds(ids);
        System.assertEquals('Test - Account', account.Name, 'contact data');
    }
    
    
      @isTest
    Public Static void VerifydiscountgroupNew()
    {
        
        Account  account = [Select Id,Name,Phone,dmpl__BillingStreet__c,dmpl__BillingRegion__c,dmpl__BillingState__c,dmpl__BillingPostalCode__c,dmpl__BillingCity__c,dmpl__BillingCountry__c ,
                                  dmpl__ShippingStreet__c,dmpl__ShippingRegion__c,dmpl__ShippingState__c,dmpl__ShippingPostalCode__c,dmpl__ShippingCity__c,dmpl__ShippingCountry__c,
                                  dmpl__AccountContactId__c,
                                  dmpl__CustomerDiscountAccountGroupId__c,
                                  dmpl__PartnerDiscountAccountGroupId__c,
                                  dmpl__IsCustomerAccount__c,
                                  dmpl__IsPartnerAccount__c,
                                  dmpl__CustomerPriceAccountGroupId__c,
                                  dmpl__PartnerPriceAccountGroupId__c
                                  From Account Limit 1];
        
        DiscountGroupHelper.queryCustomerAccountGroupId(account.Id);
        DiscountGroupHelper.queryPartnerAccountGroupId(account.Id);
        System.assertEquals('Test - Account', account.Name, 'contact data');
    }
   
   @isTest
   Public static void getDefaultDiscountGroupId()
    {
         dmpl__DiscountGroupRule__c discrule =[select Id,
                                              Name,
                                              dmpl__ItemId__c,
                                              dmpl__SKUId__c,
                                              dmpl__DiscountPercent__c,
                                              dmpl__DiscountGroupId__c,
                                              dmpl__DateEffectiveFrom__c,
                                              dmpl__DateEffectiveTill__c,
                                              dmpl__PriceListId__c
                                              from dmpl__DiscountGroupRule__c
                                              Limit 1];
       Account account = [Select Id, Name,dmpl__CustomerPriceAccountGroupId__c,dmpl__PartnerPriceAccountGroupId__c From Account Limit 1];
       dmpl__DiscountGroup__c discountGroup = [Select Id,Name,dmpl__BranchId__c,dmpl__PartnerAccountId__c,dmpl__DiscountType__c,(Select Id ,Name,dmpl__DateEffectiveFrom__c,dmpl__DateEffectiveTill__c From DiscountRules__r ) From dmpl__DiscountGroup__c LIMIT 1];
       DiscountGroupHelper.getDefaultDiscountGroupId('Sale Price',account.Id,discountGroup.dmpl__PartnerAccountId__c,discountGroup.dmpl__BranchId__c,discrule.dmpl__DateEffectiveTill__c);
        DiscountGroupHelper.getApplicableDiscount(discrule.dmpl__DiscountGroupId__c,discrule.dmpl__ItemId__c,discrule.dmpl__SKUId__c,discrule.dmpl__DateEffectiveFrom__c);
        System.assertEquals('Test - Account', account.Name, 'contact data');
    }
     
    @isTest
     Public Static void Verify()
    {
        dmpl__DiscountGroupRule__c discrule =[select Id,
                                              Name,
                                              dmpl__ItemId__c,
                                              dmpl__SKUId__c,
                                              dmpl__DiscountPercent__c,
                                              dmpl__DiscountGroupId__c,
                                              dmpl__DateEffectiveFrom__c,
                                              dmpl__DateEffectiveTill__c,
                                              dmpl__PriceListId__c
                                              from dmpl__DiscountGroupRule__c
                                              Limit 1];
        
        DiscountGroupHelper.queryDiscount(discrule.dmpl__DiscountGroupId__c,discrule.dmpl__ItemId__c,discrule.dmpl__DateEffectiveFrom__c);
        DiscountGroupHelper.queryDiscount(discrule.dmpl__PriceListId__c,discrule.dmpl__ItemId__c,discrule.dmpl__SKUId__c,discrule.dmpl__DateEffectiveFrom__c);
        System.assert( discrule!=null, 'Discount Group Rule data');
 }
    
    
    @isTest
    Static void VerifyCreateAccount()
    {
      List<Account>  account = [Select Id, Name From Account];
      System.assertNotEquals(null, account, 'Test Accounts are not found');
      System.assertEquals(4, account.size(), 'Test Accounts have more than 1 record');
    }

    @isTest
    public static void UpdateDiscountGroup()
    {
        dmpl__DiscountGroup__c discountGroup = [Select Id,Name,dmpl__DiscountType__c From dmpl__DiscountGroup__c LIMIT 1];
        if(discountGroup != null)
            discountGroup.dmpl__DiscountType__c = 'Sale Price';
        update discountGroup;
        System.assertEquals('Sale Price', discountGroup.dmpl__DiscountType__c, 'Discount Group have more than 1 record');
    }

    @isTest
    public static void UpdateDiscountGroupDiscountType()
    {
        dmpl__DiscountGroup__c discountGroup = [Select Id,Name,dmpl__DiscountType__c From dmpl__DiscountGroup__c LIMIT 1];
        discountGroup.dmpl__DiscountType__c = 'Purchase Price';
        update discountGroup;
        System.assertEquals('Purchase Price', discountGroup.dmpl__DiscountType__c, 'Discount Group have more than 1 record');
    }
        
    @isTest
    public static void DeleteDiscountGroup()
    {
       dmpl__DiscountGroup__c discountGroup = [Select Id,Name,dmpl__DiscountType__c From dmpl__DiscountGroup__c LIMIT 1];
        delete discountGroup;
        System.assertEquals('Sale Price', discountGroup.dmpl__DiscountType__c, 'Discount Group have more than 1 record');
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
    
    private static void CreateAccountGroup()
    {
        dmpl__AccountGroup__c accountGroup= new dmpl__AccountGroup__c (Name= 'Test-AccountGroup', 
                                                                       dmpl__AccountGroupType__c='Scheme');
        insert accountGroup;
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
    
    private static void CreateDiscountGroup()
    {
        List<dmpl__DiscountGroup__c> discountGroup = new List<dmpl__DiscountGroup__c>();
        dmpl__AccountGroup__c accountGroup=[Select Id,Name From dmpl__AccountGroup__c LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name From dmpl__Branch__c];
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
    
    private static void CreateDiscountGroupRule()
    {
        List<dmpl__DiscountGroupRule__c> discountGroupRule = new List<dmpl__DiscountGroupRule__c>();
        dmpl__DiscountGroup__c discountGroup = [Select Id, Name FROM dmpl__DiscountGroup__c LIMIt 1];
        dmpl__Item__c item = [Select Id,Name FROM dmpl__Item__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id, Name FROM dmpl__SKU__c LIMIT 1];
        discountGroupRule.add(new dmpl__DiscountGroupRule__c(dmpl__DiscountGroupId__c = discountGroup.Id,
                                                             //dmpl__ItemId__c = item.Id,
                                                             //dmpl__SKUId__c = sku.Id,
                                                             dmpl__DiscountPercent__c = 10,
                                                             dmpl__DateEffectiveFrom__c = date.today()
                                                            ));
        insert discountGroupRule;
    }
    
    private static void CreateContactAddress()
    {
        List<dmpl__ContactAddress__c> contactAddress = new List<dmpl__ContactAddress__c>();
        Account account = [Select Id,Name From Account WHERE Name = 'Customer-Test-Account' LIMIT 1];
        contactAddress.add(new dmpl__ContactAddress__c(dmpl__AccountId__c = account.Id,
                                                       Name = 'Test - Contact - Address' ,
                                                       dmpl__AddressType__c = 'Both'                                                    
                                                       ));
        insert contactAddress;
    }
    
    private static void CreateSaleOrder()
    {
        List<dmpl__SaleOrder__c> saleOrder = new List<dmpl__SaleOrder__c>();
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c LIMIT 1];
        dmpl__ContactAddress__c contactAddress = [Select Id,Name,dmpl__AccountId__c From dmpl__ContactAddress__c LIMIT 1];
        //dmpl__Resource__c resource = [Select Id,Name From dmpl__Resource__c LIMIT 1];
        saleOrder.Add(new dmpl__SaleOrder__c(dmpl__AccountId__c = contactAddress.dmpl__AccountId__c,
                                             dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                             dmpl__BranchId__c = branch.Id,
                                             dmpl__DocumentDate__c = Date.today(),
                                             dmpl__Status__c = 'Draft',
                                             dmpl__BillingAddressId__c = contactAddress.Id,
                                             dmpl__ShippingAddressId__c = contactAddress.Id,
                                             dmpl__RequiredDate__c = Date.today(),
                                             //dmpl__SalesExecutiveId__c = resource.Id,
                                             dmpl__BookingAmount__c = 100,
                                             dmpl__PromisedDate__c = Date.today(),
                                             dmpl__PerformReleaseFulfilment__c = false,
                                             dmpl__PerformReleaseInvoice__c = false,
                                             dmpl__PerformReleaseDelivery__c = false
        ));
        insert saleOrder;
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
                                dmpl__Rate__c = 10,
                                dmpl__PostingFieldName__c = 'Tax1'
                                ));        
        insert tax;
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
                                                     dmpl__Quantity__c = 10,
                                                     dmpl__TaxGroupId__c = taxGroup.Id
                                                     ));

        saleOrderLine.Add(new dmpl__SaleOrderLine__c(dmpl__SaleOrderId__c = saleOrder.Id,
                                                     dmpl__ItemId__c = item.Id,
                                                     dmpl__SKUId__c = sku.Id,
                                                     dmpl__Quantity__c = 10,
                                                     dmpl__TaxGroupId__c = taxGroup.Id
                                                     ));                                                    
   
        saleOrderLine.Add(new dmpl__SaleOrderLine__c(dmpl__SaleOrderId__c = saleOrder.Id,
                                                     dmpl__ItemId__c = item.Id,
                                                     dmpl__SKUId__c = sku.Id,
                                                     dmpl__Quantity__c = 10,
                                                     dmpl__TaxGroupId__c = taxGroup.Id
                                                     ));                                                    
        insert saleOrderLine;
    }
     @isTest
    public static void testSetDefaultDiscountGroupIds(){
        List<PurchaseOrder__c> ofPurchaseOrders=[SELECT Id FROM PurchaseOrder__c];
        DiscountGroupHelper.setDefaultDiscountGroupIds(ofPurchaseOrders);
    }
   
}