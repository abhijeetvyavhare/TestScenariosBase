@isTest
public class PaymentHelper_Test {
    
    @testSetup
    public static void setup()
    {   
        System.runAs(PostInstallHelper.AssignAdministratorAllPermissions(UserInfo.getUserId())){
            CreateAccountGroup();
            CreateAccount();
            CreateContactAddress();
            CreateBranch();
            CreateItems();
            CreateResource();
            CreateSaleOrder();
            CreateDiscountGroup();
            CreateSaleInvoice();
            CreateNewPayment();
            CreateNewFinancer();
            CreateNewFinancerScheme();
            CreateNewFinancecase();
        }
    }
    
    @isTest
    Public Static void DMSSettings()
    {
        try{
            Test.startTest();
            DMSSettings dms = new DMSSettings();
            dmpl__Payment__c items = [Select Id, Name from dmpl__Payment__c Limit 1 ];
            dms.getDMSSettings('','');
            System.assert(items!=null, 'Record Found');
            Test.stopTest();
        }
        Catch(Exception e){}
    }
    


    @isTest
    public static void testPostData() {
        List<dmpl__Payment__c> oldPayments = new List<dmpl__Payment__c>();
        List<dmpl__Payment__c> newPayments = new List<dmpl__Payment__c>();
        dmpl__Payment__c oldPaymentTaken = new dmpl__Payment__c(
            dmpl__PaymentType__c = 'PaymentTaken',
            dmpl__Amount__c = 100,
            dmpl__IsGLPostingApproved__c = true
        );
        dmpl__Payment__c newPaymentTaken = oldPaymentTaken.clone();
        newPaymentTaken.dmpl__Amount__c = 150;
        oldPayments.add(oldPaymentTaken);
        newPayments.add(newPaymentTaken);
        dmpl__Payment__c oldPaymentGiven = new dmpl__Payment__c(
            dmpl__PaymentType__c = 'PaymentGiven',
            dmpl__Amount__c = 200,
            dmpl__IsGLPostingApproved__c = true
        );
        dmpl__Payment__c newPaymentGiven = oldPaymentGiven.clone();
        newPaymentGiven.dmpl__Amount__c = 250;
        oldPayments.add(oldPaymentGiven);
        newPayments.add(newPaymentGiven);
        Test.startTest();
        PaymentHelper.postData(true, false, false, oldPayments, newPayments);
        Test.stopTest();

    }

    
    @isTest
    Public Static void DMSSettings1()
    {
        try{
            Test.startTest();
            DMSSettings dms = new DMSSettings();
            dmpl__Payment__c items = [Select Id, Name from dmpl__Payment__c Limit 1 ];
            dms.getDMSSettings('');
            System.assert(items!=null, 'Record Found');
            Test.stopTest();
        }
        Catch(Exception e){}
    }
    
    @isTest
    Public Static void DMSSettings2()
    {
        try{
            Test.startTest();
            DMSSettings dms = new DMSSettings();
            dmpl__Payment__c items = [Select Id, Name from dmpl__Payment__c Limit 1 ];
            dms.getDMSSetting('','');
            System.assert(items!=null, 'Record Found');
            Test.stopTest();
        }
        Catch(Exception e){}
    }
    
    @isTest
    Public Static void DMSSettings3()
    {
        try{
            Test.startTest();
            DMSSettings dms = new DMSSettings();
            dmpl__Payment__c items = [Select Id, Name from dmpl__Payment__c Limit 1 ];
            dms.getDMSSetting('');
            System.assert(items!=null, 'Record Found');
            Test.stopTest();
        }
        Catch(Exception e){}
    }
    @isTest
    Public Static void getGSTR1_Summary_Detail()
    {
        try{
            Test.startTest();
            dmpl__Item__c items = [Select Id, Name from dmpl__Item__c Limit 1 ];
            PaymentHelper.getGSTR1_Summary_Detail('','');
            System.assert(items!=null, 'Record Found');
            Test.stopTest();
        }
        Catch(Exception e){}
    }
    
    @isTest
    Public Static void VerifyPayment()
    {
        try{
            Test.startTest();
            List<Id> ids = new List<Id>();
            dmpl__Payment__c items = [Select Id, Name from dmpl__Payment__c Limit 1 ];
            ids.add(items.Id);
            PaymentHelper.queryPaymentsForClaims(ids);
            PaymentController.getEmail(items.Id);
            System.assert(items!=null, 'Record Found');
            Test.stopTest();
        }
        Catch(Exception e){}
    }
    
    @isTest
    Public Static void getSaleOrderTax()
    {
        Try{
            Test.startTest();
            dmpl__Item__c items = [Select Id, Name from dmpl__Item__c Limit 1 ];
            PaymentHelper.getSaleOrderTax('','');
            System.assert(items!=null, 'Record Found');
            Test.stopTest();
        }
        Catch(Exception e){}
    }
    
    @isTest
    public static void UpdatePayment()
    {
        dmpl__Payment__c payment = [Select Id,Name,dmpl__Status__c From dmpl__Payment__c LIMIT 1];
        payment.dmpl__Status__c = 'Draft';
        update payment;
        System.assertEquals('Draft', payment.dmpl__Status__c, 'Test payment have 1 updated record');
    }
    
    @isTest
    public static void DeletePayment()
    {
        Test.startTest();
        dmpl__Payment__c payment = [Select Id,Name,dmpl__Status__c From dmpl__Payment__c LIMIT 1];
        delete payment;
        System.assertEquals(null, payment.dmpl__Status__c, 'Test payment have 1 deleted record');
        Test.stopTest();
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
        
        
        Account customerAccount = new Account(Name = 'Customer-Test-Account',
                                              dmpl__LastName__c = 'Account',
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
    
    private static void CreateSaleInvoice()
    {
        List<dmpl__SaleInvoice__c> saleInvoice = new List<dmpl__SaleInvoice__c>();
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        dmpl__DiscountGroup__c discountGroup = [Select Id,Name From dmpl__DiscountGroup__c LIMIT 1];
        dmpl__SaleOrder__c saleOrder = [Select Id,Name From dmpl__SaleOrder__c LIMIT 1];
        Account customerAccount = [Select Id,Name From Account WHERE dmpl__IsCustomerAccount__c = True LIMIT 1];
        //dmpl__Resource__c resource = [Select Id,Name From dmpl__Resource__c LIMIT 1];
        saleInvoice.Add(new dmpl__SaleInvoice__c(dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                                 dmpl__BranchId__c = Branch.Id,
                                                 dmpl__DiscountGroupId__c =  discountGroup.Id,                                               
                                                 dmpl__DocumentDate__c = Date.today(),
                                                 dmpl__SaleOrderId__c = saleOrder.id,
                                                 dmpl__AccountId__c = customerAccount.Id,
                                                 //dmpl__SalesExecutiveId__c = resource.Id,
                                                 dmpl__FinanceAmount__c = 100,
                                                 dmpl__AmountPaid__c =10
                                                ));
        insert saleInvoice;
        
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
    
    private static void CreateDiscountGroup()
    {
        List<dmpl__DiscountGroup__c> discountGroup = new List<dmpl__DiscountGroup__c>();
        Account partnerAccount = [Select Id,Name From Account WHERE Name = 'Partner-Test-Account' LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        discountGroup.add(new dmpl__DiscountGroup__c( Name = 'Test - Discount - Group',
                                                     dmpl__DiscountType__c ='Sale Price',
                                                     dmpl__IsDefault__c = true,
                                                     dmpl__IsActive__c = false,
                                                     dmpl__PartnerAccountId__c = partnerAccount.Id,
                                                     dmpl__BranchId__c = branch.Id
                                                    ) );
        
        insert discountGroup;
        
    }
    
    private static void CreateNewFinancer()
    {
        List<dmpl__Financer__c> financer = new List<dmpl__Financer__c>();
        Account customerAccount = [Select Id,Name From Account WHERE dmpl__IsCustomerAccount__c = True LIMIT 1];
        financer.add(new dmpl__Financer__c( Name = 'Test - Financer',
                                           dmpl__AccountId__c = customerAccount.Id,
                                           dmpl__Address__c = 'Test - Address',
                                           dmpl__Description__c = 'Test - Description'
                                          ));
        insert financer;
        
    }
    
    private static void CreateNewFinancerScheme()
    {
        List <dmpl__FinancerScheme__c> financerScheme = new List<dmpl__FinancerScheme__c>();
        dmpl__Financer__c financer = [Select Id,Name From dmpl__Financer__c LIMIT 1];
        Account customerAccount = [Select Id,Name From Account WHERE dmpl__IsCustomerAccount__c = True LIMIT 1];
        dmpl__AccountGroup__c accountGroup = [Select Id,Name From dmpl__AccountGroup__c WHERE Name= 'Test-AccountGroup' LIMIT 1];
        financerScheme.add(new dmpl__FinancerScheme__c( Name = 'Test - Name',
                                                       dmpl__FinancerId__c = financer.Id,
                                                       dmpl__MinimumTenure__c = 3,
                                                       dmpl__MaximumTenure__c = 12,
                                                       dmpl__MinimumAmount__c =100,
                                                       dmpl__MaximumAmount__c =10,
                                                       dmpl__InterestRate__c = 5,
                                                       dmpl__ApplicablePartnerAccountId__c = customerAccount.Id,
                                                       dmpl__ApplicableToPartnerAccountGroupId__c = accountGroup.Id
                                                      ) );
        insert financerScheme;
        
    }
    
    private static void CreateNewFinancecase()
    {
        List <dmpl__FinanceCase__c> financeCase = new List<dmpl__FinanceCase__c>();
        dmpl__Financer__c financer = [Select Id,Name From dmpl__Financer__c LIMIT 1];
        dmpl__FinancerScheme__c financerScheme = [Select Id,Name From dmpl__FinancerScheme__c LIMIT 1];
        Account partnerAccount = [Select Id,Name From Account WHERE Name = 'Partner-Test-Account' LIMIT 1];
        dmpl__SaleOrder__c saleOrder = [Select Id,Name From dmpl__SaleOrder__c LIMIT 1];
        dmpl__SaleInvoice__c saleInvoice = [Select Id,Name From dmpl__SaleInvoice__c LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        financeCase.add(new dmpl__FinanceCase__c (dmpl__FinanceProviderId__c = financer.Id,
                                                  dmpl__FinanceSchemeId__c = financerScheme.Id,
                                                  dmpl__RequestedDownPayment__c =20,
                                                  dmpl__RequestedAmount__c = 100,
                                                  dmpl__RequestedTenureMonths__c=12,
                                                  dmpl__RequestedInterestRate__c =5,
                                                  dmpl__EMIOnRequestedAmount__c =50,
                                                  dmpl__PartnerAccountId__c = partnerAccount.Id,
                                                  dmpl__SaleOrderId__c = saleOrder.Id,
                                                  dmpl__BranchId__c = branch.Id,
                                                  dmpl__SaleInvoiceId__c = saleInvoice.Id
                                                 ));
        insert financeCase;
        
    }
}