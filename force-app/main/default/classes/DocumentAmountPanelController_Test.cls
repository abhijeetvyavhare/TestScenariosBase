@isTest
public class DocumentAmountPanelController_Test {
    
    @testSetup
    public static void setup()
    {
        System.runAs(PostInstallHelper.AssignAdministratorAllPermissions(UserInfo.getUserId())){
            CreateAccountGroup();
            CreateBranch();
            CreateItems();
            CreateSKu();
            CreateTaxGroup();
            CreateSaleOrder();
            //CreateDiscountGroup();
            CreateSaleInvoice();
            test.startTest();
            CreatePurchaseOrder();
            test.stopTest();
        }
    }
    
    @isTest
    public static void getDocumentTaxes()
    {
        Test.startTest();
        //CreateRepairOrder();
        //CreateBillDocument();
        
        dmpl__SaleOrder__c  order = [Select Id, Name From dmpl__SaleOrder__c];
       //List<AggregateResult> result = DocumentAmountPanelController.getDocumentTaxes('dmpl__SaleOrder__c', order.Id);
        System.assert(order!=null,'Taxes needs to be more than 0');
        
        dmpl__PurchaseOrder__c  purchaseOrder = [Select Id, Name From dmpl__PurchaseOrder__c];
       // List<AggregateResult> result1 = DocumentAmountPanelController.getDocumentTaxes('dmpl__PurchaseOrder__c', purchaseOrder.Id);
        System.assert(purchaseOrder!=null,'Taxes needs to be more than 0');
        
        //dmpl__RepairOrder__c  repairOrder = [Select Id, Name From dmpl__RepairOrder__c];
        //List<AggregateResult> result2 = DocumentAmountPanelController.getDocumentTaxes('dmpl__RepairOrder__c', repairOrder.Id);
        //System.assert(repairOrder!=null,'Taxes needs to be more than 0');
        
        //dmpl__Bill__c  bill = [Select Id, Name From dmpl__Bill__c];
        //List<AggregateResult> result3 = DocumentAmountPanelController.getDocumentTaxes('dmpl__Bill__c', bill.Id);
        //System.assert(bill!=null,'Taxes needs to be more than 0');
        
        dmpl__SaleInvoice__c  invoice = [Select Id, Name From dmpl__SaleInvoice__c LIMIT 1];
      //  result = DocumentAmountPanelController.getDocumentTaxes('dmpl__SaleInvoice__c', invoice.Id);
        //DocumentAmountPanelController.getSaleOrderTaxes(order.Id);
        DocumentAmountPanelController.getRepairOrderTaxes(order.Id);
        DocumentAmountPanelController.getServiceRequestTaxes(order.Id);
        DocumentAmountPanelController.getDeliveryOrderTaxes(order.Id);
        DocumentAmountPanelController.getSaleReturnTaxes(order.Id);
        DocumentAmountPanelController.getBillReturnTaxes(order.Id);
       // DocumentAmountPanelController.getSaleInvoiceTaxes(order.Id);
        DocumentAmountPanelController.getServiceQuoteTaxes(order.Id);
        DocumentAmountPanelController.getPurchaseOrderTaxes(order.Id);
        DocumentAmountPanelController.getPurchaseInvoiceTaxes(order.Id);
        DocumentAmountPanelController.getClaimPayments(order.Id);
        Test.stopTest();
    }
    
    @isTest
    public static void getDocumentPayments()
    {
        Test.startTest();
       // CreatePurchaseOrder();
        CreateBillDocument();
        
        dmpl__SaleOrder__c  order = [Select Id, Name From dmpl__SaleOrder__c];
        List<Payment__c> payments = DocumentAmountPanelController.getDocumentPayments('dmpl__SaleOrder__c', order.Id);
        System.assert(order!=null, 'Payments needs to be more than 0');
        
        /*dmpl__SaleInvoice__c  invoice = [Select Id, Name From dmpl__SaleInvoice__c LIMIT 1];
        payments = DocumentAmountPanelController.getDocumentPayments('dmpl__SaleInvoice__c', invoice.Id);
        System.assert(invoice!=null, 'Taxes needs to be more than 0');
        
        dmpl__PurchaseOrder__c  purchaseOrder = [Select Id, Name From dmpl__PurchaseOrder__c];
        List<Payment__c> payments1 = DocumentAmountPanelController.getDocumentPayments('dmpl__PurchaseOrder__c', purchaseOrder.Id);
        System.assert(purchaseOrder!=null, 'Payments needs to be more than 0');*/
        
       /* dmpl__Bill__c  bill = [Select Id, Name From dmpl__Bill__c];
        List<Payment__c> payments2 = DocumentAmountPanelController.getDocumentPayments('dmpl__Bill__c', bill.Id);
        System.assert(bill!=null, 'Payments needs to be more than 0'); */
        
        Test.stopTest();
    }
    
     @isTest
    public static void getAssetDefaults()
    {
        Test.startTest();
        dmpl__SaleOrder__c  order = [Select Id, Name From dmpl__SaleOrder__c];
        RecordFormController.getAssetDefaults(order.Id);
        System.assert(order!=null, 'Payments needs to be more than 0');
    Test.stopTest();
    }
    
    @isTest
    public static void getFieldMappingsData()
    {
        try{
        Test.startTest();
        dmpl__SaleOrder__c  order = [Select Id, Name From dmpl__SaleOrder__c];
        RecordFormController.getFieldMappingsData('dmpl__SaleOrder__c','dmpl__SaleInvoice__c',order.Id);
        System.assert(order!=null, 'Payments needs to be more than 0');
    Test.stopTest();
        }
        Catch(exception e){}
    }
    
    @isTest
    public static void getDocumentAdjustments()
    {
        Test.startTest();
        dmpl__SaleOrder__c  order = [Select Id, Name From dmpl__SaleOrder__c];
        List<dmpl__PaymentAdjustment__c> payments = DocumentAmountPanelController.getDocumentAdjustments('dmpl__SaleOrder__c', order.Id);
        System.assert(order!=null, 'Payments needs to be more than 0');
    Test.stopTest();
    }
     @isTest
    public static void getPaymentAdjustments()
    {
        Test.startTest();
        dmpl__SaleOrder__c  order = [Select Id, Name From dmpl__SaleOrder__c];
        List<dmpl__PaymentAdjustment__c> payments = DocumentAmountPanelController.getPaymentAdjustments(order.Id);
        System.assert(order!=null, 'Payments needs to be more than 0');
    Test.stopTest();
    }
    
    @isTest
    public static void getDocumentAdjustments1()
    {
        Test.startTest();
        dmpl__SaleOrder__c  order = [Select Id, Name From dmpl__SaleOrder__c];
        List<dmpl__PaymentAdjustment__c> payments = DocumentAmountPanelController.getDocumentAdjustments('dmpl__SaleInvoice__c', order.Id);
        System.assert(order!=null, 'Payments needs to be more than 0');
    Test.stopTest();
    }
    @isTest
    public static void getDocumentAdjustments2()
    {
        Test.startTest();
        dmpl__SaleOrder__c  order = [Select Id, Name From dmpl__SaleOrder__c];
        List<dmpl__PaymentAdjustment__c> payments = DocumentAmountPanelController.getDocumentAdjustments('dmpl__RepairOrder__c', order.Id);
        System.assert(order!=null, 'Payments needs to be more than 0');
    Test.stopTest();
    }
    @isTest
    public static void getDocumentAdjustments3()
    {
        Test.startTest();
        dmpl__SaleOrder__c  order = [Select Id, Name From dmpl__SaleOrder__c];
        List<dmpl__PaymentAdjustment__c> payments = DocumentAmountPanelController.getDocumentAdjustments('dmpl__Bill__c', order.Id);
        System.assert(order!=null, 'Payments needs to be more than 0');
    Test.stopTest();
    }
    @isTest
    public static void getDocumentAdjustments4()
    {
        Test.startTest();
        dmpl__SaleOrder__c  order = [Select Id, Name From dmpl__SaleOrder__c];
        List<dmpl__PaymentAdjustment__c> payments = DocumentAmountPanelController.getDocumentAdjustments('dmpl__CreditNote__c', order.Id);
        System.assert(order!=null, 'Payments needs to be more than 0');
    Test.stopTest();
    }
    @isTest
    public static void getDocumentAdjustments5()
    {
        Test.startTest();
        dmpl__SaleOrder__c  order = [Select Id, Name From dmpl__SaleOrder__c];
        List<dmpl__PaymentAdjustment__c> payments = DocumentAmountPanelController.getDocumentAdjustments('dmpl__DebitNote__c', order.Id);
        System.assert(order!=null, 'Payments needs to be more than 0');
    Test.stopTest();
    }
    
    @isTest
    public static void getServiceQuoteDiscounts()
    {
        Test.startTest();
        dmpl__PurchaseOrder__c  order = [Select Id, Name From dmpl__PurchaseOrder__c];
         DocumentAmountPanelController.getServiceQuoteDiscounts(order.Id);
        System.assert(order!=null, 'Payments needs to be more than 0'); 
    Test.stopTest();
    }
    
     @isTest
    public static void getQuoteTaxes()
    {
        Test.startTest();
        dmpl__PurchaseOrder__c  order = [Select Id, Name From dmpl__PurchaseOrder__c];
         DocumentAmountPanelController.getQuoteTaxes(order.Id);
        System.assert(order!=null, 'Payments needs to be more than 0'); 
    Test.stopTest();
    }
    
    @isTest
    public static void getConfigurableItems()
    {
        Test.startTest();
        dmpl__PurchaseOrder__c  order = [Select Id, Name From dmpl__PurchaseOrder__c];
         ProductConfiguratorController.getConfigurableItems('dmpl__PurchaseOrder__c',order.Id);
        System.assert(order!=null, 'Payments needs to be more than 0'); 
    Test.stopTest();
    }
     @isTest
    public static void getConfigurableItems1()
    {
        Test.startTest();
        dmpl__PurchaseOrder__c  order = [Select Id, Name From dmpl__PurchaseOrder__c];
         ProductConfiguratorController.getConfigurableItems('dmpl__Quote__c',order.Id);
        System.assert(order!=null, 'Payments needs to be more than 0'); 
    Test.stopTest();
    }

     @isTest
    public static void getConfigurableItemsNew()
    {
        Test.startTest();
        dmpl__PurchaseOrder__c  order = [Select Id, Name From dmpl__PurchaseOrder__c];
         ProductConfiguratorController.getConfigurableItems('dmpl__ServiceRequest__c',order.Id);
        System.assert(order!=null, 'Payments needs to be more than 0'); 
    Test.stopTest();
    }
    
     @isTest
    public static void getDocumentPaymentNew1()
    { 
        Test.startTest();
        List<String> components= new List<String>{'DocumentTaxes','DocumentFinanceCases','DocumentPayments','DocumentAdjustments'};
        dmpl__PurchaseOrder__c  order = [Select Id, Name From dmpl__PurchaseOrder__c];
         DocumentAmountPanelController.getDocumentAmounts('dmpl__PurchaseOrder__c', order.Id,components);
        System.assert(order!=null, 'Payments needs to be more than 0');
        
    Test.stopTest();
    } 
    
    @isTest
    public static void getDocumentPayments2()
    {
        Test.startTest();
        CreateBillDocument();
        
        //dmpl__SaleOrder__c  order = [Select Id, Name From dmpl__SaleOrder__c];
        //List<Payment__c> payments = DocumentAmountPanelController.getDocumentPayments('dmpl__SaleOrder__c', order.Id);
        //System.assert(order!=null, 'Payments needs to be more than 0');
        
        dmpl__SaleInvoice__c  invoice = [Select Id, Name From dmpl__SaleInvoice__c LIMIT 1];
        List<Payment__c> payments = DocumentAmountPanelController.getDocumentPayments('dmpl__SaleInvoice__c', invoice.Id);
        System.assert(invoice!=null, 'Taxes needs to be more than 0');
        
        //dmpl__PurchaseOrder__c  purchaseOrder = [Select Id, Name From dmpl__PurchaseOrder__c];
        //List<Payment__c> payments1 = DocumentAmountPanelController.getDocumentPayments('dmpl__PurchaseOrder__c', purchaseOrder.Id);
        //System.assert(purchaseOrder!=null, 'Payments needs to be more than 0');
        
       /* dmpl__Bill__c  bill = [Select Id, Name From dmpl__Bill__c];
        List<Payment__c> payments2 = DocumentAmountPanelController.getDocumentPayments('dmpl__Bill__c', bill.Id);
        System.assert(bill!=null, 'Payments needs to be more than 0'); */
        
        Test.stopTest();
    }
    
    @isTest
    public static void getDocumentPayments3()
    {
        Test.startTest();
        CreateBillDocument();
        
        /*dmpl__SaleOrder__c  order = [Select Id, Name From dmpl__SaleOrder__c];
        List<Payment__c> payments = DocumentAmountPanelController.getDocumentPayments('dmpl__SaleOrder__c', order.Id);
        System.assert(order!=null, 'Payments needs to be more than 0');
        
        dmpl__SaleInvoice__c  invoice = [Select Id, Name From dmpl__SaleInvoice__c LIMIT 1];
        payments = DocumentAmountPanelController.getDocumentPayments('dmpl__SaleInvoice__c', invoice.Id);
        System.assert(invoice!=null, 'Taxes needs to be more than 0');*/
        
        dmpl__PurchaseOrder__c  purchaseOrder = [Select Id, Name From dmpl__PurchaseOrder__c];
        List<Payment__c> payments1 = DocumentAmountPanelController.getDocumentPayments('dmpl__PurchaseOrder__c', purchaseOrder.Id);
        System.assert(purchaseOrder!=null, 'Payments needs to be more than 0');
        
       /* dmpl__Bill__c  bill = [Select Id, Name From dmpl__Bill__c];
        List<Payment__c> payments2 = DocumentAmountPanelController.getDocumentPayments('dmpl__Bill__c', bill.Id);
        System.assert(bill!=null, 'Payments needs to be more than 0'); */
        
        Test.stopTest();
    }
    
    
    @isTest
    public static void getDocumentPayment3()
    {
        Test.startTest();
       
        CreateBillDocument();
        
      /*  dmpl__SaleOrder__c  order = [Select Id, Name From dmpl__SaleOrder__c];
        List<Payment__c> payments = DocumentAmountPanelController.getDocumentPayments('dmpl__SaleOrder__c', order.Id);
        System.assert(order!=null, 'Payments needs to be more than 0');
        
        dmpl__SaleInvoice__c  invoice = [Select Id, Name From dmpl__SaleInvoice__c LIMIT 1];
        payments = DocumentAmountPanelController.getDocumentPayments('dmpl__SaleInvoice__c', invoice.Id);
        System.assert(invoice!=null, 'Taxes needs to be more than 0');
        
        dmpl__PurchaseOrder__c  purchaseOrder = [Select Id, Name From dmpl__PurchaseOrder__c];
        List<Payment__c> payments1 = DocumentAmountPanelController.getDocumentPayments('dmpl__PurchaseOrder__c', purchaseOrder.Id);
        System.assert(purchaseOrder!=null, 'Payments needs to be more than 0');*/
        
        dmpl__Bill__c  bill = [Select Id, Name From dmpl__Bill__c];
        List<Payment__c> payments2 = DocumentAmountPanelController.getDocumentPayments('dmpl__Bill__c', bill.Id);
        System.assert(bill!=null, 'Payments needs to be more than 0');
        
        Test.stopTest();
    }
    
    
    @isTest
    public static void getDocumentPayments1()
    {
        Test.startTest();
        CreateBillDocument();
        CreateReconciliationDocument();
        CreateRepairOrder();

        dmpl__ClaimReconciliation__c claimReconciliation = [Select Id, Name From dmpl__ClaimReconciliation__c];
        List<Payment__c>  payments = DocumentAmountPanelController.getDocumentPayments('dmpl__ClaimReconciliation__c', claimReconciliation.Id);
        System.assert( claimReconciliation!=null, 'Payments needs to be more than 0');
        
        dmpl__RepairOrder__c  repairOrder = [Select Id, Name From dmpl__RepairOrder__c LIMIT 1];
        List<Payment__c> payments4 = DocumentAmountPanelController.getDocumentPayments('dmpl__RepairOrder__c', repairOrder.Id);
        System.assert( repairOrder!=null, 'Payments needs to be more than 0');
        
        Test.stopTest();
    }
  
    
    @isTest
    public static void getDocumentFinanceCase()
    {
        Test.startTest();
        //CreateDiscountGroup();
      //  CreateSaleInvoice();
        CreateNewFinancer();
        //CreateNewFinancerScheme();
        
        dmpl__SaleOrder__c  order = [Select Id, Name From dmpl__SaleOrder__c];
        List<dmpl__FinanceCase__c> payments = DocumentAmountPanelController.getDocumentFinanceCases('dmpl__SaleOrder__c', order.Id);
        System.assert(order!=null, 'Payments needs to be more than 0');
        
        dmpl__SaleInvoice__c  invoice = [Select Id, Name From dmpl__SaleInvoice__c LIMIT 1];
        payments = DocumentAmountPanelController.getDocumentFinanceCases('dmpl__SaleInvoice__c', invoice.Id);
        System.assert(invoice!=null,  'Taxes needs to be more than 0');
        test.stopTest();
    }
    
    private static void CreateAccountGroup()
    {
        dmpl__AccountGroup__c accountGroup= new dmpl__AccountGroup__c (Name= 'Test-AccountGroup', 
                                                                       dmpl__AccountGroupType__c='Scheme');
        insert accountGroup;
        
       /* List<Account> account = new List<Account>();
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
                                dmpl__IsSupplierAccount__c = True,
                                dmpl__IsCustomerAccount__c = False,
                                dmpl__PartnerTaxAccountGroupId__c = accountGroup.Id,
                                dmpl__CustomerPriceAccountGroupId__c = accountGroup.Id,
                                dmpl__CustomerDiscountAccountGroupId__c = accountGroup.Id,
                                dmpl__PartnerSchemeAccountGroupId__c = accountGroup.Id,                                
                                dmpl__PartnerPriceAccountGroupId__c = accountGroup.Id,
                                dmpl__PartnerDiscountAccountGroupId__c = accountGroup.Id,
                                dmpl__CustomerSchemeAccountGroupId__c = accountGroup.Id
                               ));
        insert account; */
        
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
                                              dmpl__IsSupplierAccount__c = True,
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
      
        List<dmpl__ContactAddress__c> contactAddress = new List<dmpl__ContactAddress__c>();
        Account customerAccount = [Select Id,Name From Account WHERE Name = 'Customer-Test-Account' LIMIT 1];
        contactAddress.add(new dmpl__ContactAddress__c(dmpl__AccountId__c = customerAccount.Id,
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
    
        List<dmpl__SaleOrderLine__c> saleOrderLine = new List<dmpl__SaleOrderLine__c>();
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id,Name From dmpl__SKU__c LIMIT 1];
        dmpl__TaxGroup__c taxGroup = [Select Id,Name From dmpl__TaxGroup__c LIMIT 1];
        saleOrderLine.Add(new dmpl__SaleOrderLine__c(dmpl__SaleOrderId__c = saleOrder[0].Id,
                                                     dmpl__ItemId__c = item.Id,
                                                     dmpl__SKUId__c = sku.Id,
                                                     dmpl__Quantity__c = 10,
                                                     dmpl__TaxGroupId__c = taxGroup.Id
                                                    ));
        
        saleOrderLine.Add(new dmpl__SaleOrderLine__c(dmpl__SaleOrderId__c = saleOrder[0].Id,
                                                     dmpl__ItemId__c = item.Id,
                                                     dmpl__SKUId__c = sku.Id,
                                                     dmpl__Quantity__c = 10,
                                                     dmpl__TaxGroupId__c = taxGroup.Id
                                                    ));                                                    
        
        
        saleOrderLine.Add(new dmpl__SaleOrderLine__c(dmpl__SaleOrderId__c = saleOrder[0].Id,
                                                     dmpl__ItemId__c = item.Id,
                                                     dmpl__SKUId__c = sku.Id,
                                                     dmpl__Quantity__c = 10,
                                                     dmpl__TaxGroupId__c = taxGroup.Id
                                                    ));                                                    
        
        insert saleOrderLine;
    }

    
    private static void CreatePurchaseOrder()
    {
        List<dmpl__PurchaseOrder__c> purchase = new List<dmpl__PurchaseOrder__c>();
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c LIMIT 1];
        dmpl__ContactAddress__c contactAddress = [Select Id,Name,dmpl__AccountId__c From dmpl__ContactAddress__c LIMIT 1];
        dmpl__Resource__c resource = [Select Id,Name From dmpl__Resource__c LIMIT 1];
        purchase.Add(new dmpl__PurchaseOrder__c(dmpl__SupplierAccountId__c = contactAddress.dmpl__AccountId__c,
                                                dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                                dmpl__BranchId__c = branch.Id,
                                                dmpl__DocumentDate__c = Date.today()
                                               ));
        insert purchase;
    }
    
    private static void CreateBillDocument()
    {
        List<dmpl__Bill__c> bill = new List<dmpl__Bill__c>();
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c LIMIT 1];
        dmpl__ContactAddress__c contactAddress = [Select Id,Name,dmpl__AccountId__c From dmpl__ContactAddress__c LIMIT 1];
        dmpl__Resource__c resource = [Select Id,Name From dmpl__Resource__c LIMIT 1];
        bill.Add(new dmpl__Bill__c(dmpl__SupplierAccountId__c = contactAddress.dmpl__AccountId__c,
                                   dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                   dmpl__BranchId__c = branch.Id,
                                   dmpl__DocumentDate__c = Date.today()
                                  ));
        insert bill;
    
        List<dmpl__Claim__c> claim = new List<dmpl__Claim__c>();
        claim.Add(new dmpl__Claim__c(dmpl__SupplierNameId__c = contactAddress.dmpl__AccountId__c,
                                     dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                     dmpl__BranchId__c = branch.Id,
                                     dmpl__DocumentDate__c = Date.today()
                                    ));
        insert claim;
    }
    
    private static void CreateReconciliationDocument()
    {
        List<dmpl__ClaimReconciliation__c > claim = new List<dmpl__ClaimReconciliation__c >();
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c LIMIT 1];
        dmpl__ContactAddress__c contactAddress = [Select Id,Name,dmpl__AccountId__c From dmpl__ContactAddress__c LIMIT 1];
        dmpl__Resource__c resource = [Select Id,Name From dmpl__Resource__c LIMIT 1];
        claim.Add(new dmpl__ClaimReconciliation__c(dmpl__SupplierId__c = contactAddress.dmpl__AccountId__c,
                                                   dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                                   dmpl__BranchId__c = branch.Id,
                                                   dmpl__DocumentDate__c = Date.today()
                                                  ));
        insert claim;
    }
    
    private static void CreateRepairOrder()
    {
        List<dmpl__RepairOrder__c > repairOrder = new List<dmpl__RepairOrder__c >();
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c LIMIT 1];
        dmpl__ContactAddress__c contactAddress = [Select Id,Name,dmpl__AccountId__c From dmpl__ContactAddress__c LIMIT 1];
        dmpl__Resource__c resource = [Select Id,Name From dmpl__Resource__c LIMIT 1];
        repairOrder.Add(new dmpl__RepairOrder__c(dmpl__AccountId__c = contactAddress.dmpl__AccountId__c,
                                                 dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                                 dmpl__BranchId__c = branch.Id,
                                                 dmpl__DocumentDate__c = Date.today()
                                                ));
        insert repairOrder;
    }
    
    private static void UpdateSaleOrder()
    {
        dmpl__SaleOrder__c saleOrder = [Select Id,Name, dmpl__PerformReleaseInvoice__c From dmpl__SaleOrder__c LIMIT 1];
        saleOrder.dmpl__PerformReleaseInvoice__c = true;
        update saleOrder;
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
    
        List<dmpl__Tax__c> tax = new List<dmpl__Tax__c>();
        tax.Add(new dmpl__Tax__c(Name = 'Test - Tax',
                                 dmpl__TaxGroupId__c = taxGroup[0].Id,
                                 dmpl__Type__c = 'Cess',
                                 dmpl__PostingFieldName__c='Tax1',
                                 dmpl__Rate__c = 10
                                ));        
        insert tax;
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
    }
    
    private static void CreateSaleInvoice()
    {
        List<dmpl__SaleInvoice__c> saleInvoice = new List<dmpl__SaleInvoice__c>();
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        dmpl__SaleOrder__c saleOrder = [Select Id,Name From dmpl__SaleOrder__c LIMIT 1];
        Account customerAccount = [Select Id,Name From Account WHERE dmpl__IsCustomerAccount__c = True LIMIT 1];
        //dmpl__Resource__c resource = [Select Id,Name From dmpl__Resource__c LIMIT 1];
        saleInvoice.Add(new dmpl__SaleInvoice__c(dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                                 dmpl__BranchId__c = Branch.Id,
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
        dmpl__PurchaseOrder__c purchaseOrder = [Select Id,Name From dmpl__PurchaseOrder__c LIMIT 1];
        dmpl__Bill__c bill = [Select Id,Name From dmpl__Bill__c LIMIT 1];
        dmpl__Claim__c claim = [Select Id,Name From dmpl__Claim__c LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        Account customerAccount = [Select Id,Name From Account WHERE dmpl__IsCustomerAccount__c = True LIMIT 1];
        payment.Add(new dmpl__Payment__c(dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                         dmpl__BranchId__c = branch.Id,
                                         dmpl__AccountId__c = customerAccount.Id,
                                         dmpl__PaymentDate__c = Date.today(),
                                         dmpl__Amount__c = 1000,
                                         dmpl__PaymentMode__c = 'Cash',
                                         dmpl__SaleInvoiceId__c = saleInvoice.Id,
                                         dmpl__PurchaseOrderId__c = purchaseOrder.Id,
                                         dmpl__ClaimId__c = claim.Id,
                                         dmpl__BillId__c = bill.Id,
                                         dmpl__SaleOrderId__c = saleOrder.Id));
        insert payment;
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
       
        List <dmpl__FinancerScheme__c> financerScheme = new List<dmpl__FinancerScheme__c>();
        //dmpl__Financer__c financer = [Select Id,Name From dmpl__Financer__c LIMIT 1];
        //Account customerAccount = [Select Id,Name From Account WHERE dmpl__IsCustomerAccount__c = True LIMIT 1];
        dmpl__AccountGroup__c accountGroup = [Select Id,Name From dmpl__AccountGroup__c WHERE Name= 'Test-AccountGroup' LIMIT 1];
        financerScheme.add(new dmpl__FinancerScheme__c( Name = 'Test - Name',
                                                       dmpl__FinancerId__c = financer[0].Id,
                                                       dmpl__MinimumTenure__c = 3,
                                                       dmpl__MaximumTenure__c = 12,
                                                       dmpl__MinimumAmount__c =100,
                                                       dmpl__MaximumAmount__c =10,
                                                       dmpl__InterestRate__c = 5,
                                                       dmpl__ApplicablePartnerAccountId__c = customerAccount.Id,
                                                       dmpl__ApplicableToPartnerAccountGroupId__c = accountGroup.Id
                                                      ) );
        insert financerScheme;
    
        List <dmpl__FinanceCase__c> financeCase = new List<dmpl__FinanceCase__c>();
        Account partnerAccount = [Select Id,Name From Account WHERE Name = 'Partner-Test-Account' LIMIT 1];
        dmpl__SaleOrder__c saleOrder = [Select Id,Name From dmpl__SaleOrder__c LIMIT 1];
        dmpl__SaleInvoice__c saleInvoice = [Select Id,Name From dmpl__SaleInvoice__c LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        financeCase.add(new dmpl__FinanceCase__c (dmpl__FinanceProviderId__c = financer[0].Id,
                                                  dmpl__FinanceSchemeId__c = financerScheme[0].Id,
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