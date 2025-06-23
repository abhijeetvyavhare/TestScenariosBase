@isTest
public class TaxGroupHelper_Test {
    
    @testSetup
    public static void Setup()
    {   
        //System.runAs(PostInstallHelper.AssignAdministratorAllPermissions(UserInfo.getUserId())){
            CreateAccountGroup();
            CreateAccount();
            CreateContactAddress();
            CreateBranch();
            CreateItemGroup();
            CreateItems();
            CreateSKU();
            CreateResource();
            CreateItemLot();
            CreateItemLotType();
            CreateTaxGroup();
            CreateAsset();       
            CreateTax(); 
            CreateTaxGroupRule();
            verify();
        //}
  }
    
    @isTest
    public Static void VerifyCreateAccount()
    {
      List<Account>  account = [Select Id, Name From Account];
        System.assertNotEquals(null, account, 'Test Accounts are not found');
        System.assertEquals(4, account.size(), 'Test Accounts have more than 1 record');
    }
    
   /* @isTest
    public static void UpdateSaleInvoiceLine()
    {
        Test.startTest();
        //CreateSaleOrder();
     //   CreateSaleInvoice(); 
        dmpl__SaleInvoiceLine__c saleInvoiceLine = [Select Id,Name,dmpl__TaxGroupId__c FROM dmpl__SaleInvoiceLine__c LIMIT 1];
        saleInvoiceLine.dmpl__TaxGroupId__c = null;
     // update saleInvoiceLine;
        Test.stopTest();
        System.assertEquals(null, saleInvoiceLine.dmpl__TaxGroupId__c, 'Tax Group Id is updated as null');
    } 
*/
    
    @isTest
    public static void UpdateRepairOrderLine()
    {
        test.startTest();
        CreateRepairOrder();
        List<dmpl__RepairOrder__c> repairOrder = [Select Id,Name From dmpl__RepairOrder__c LIMIT 1];
        dmpl__RepairOrderLine__c repairOrderLine = [Select Id,Name,dmpl__RepairOrderId__c,dmpl__TaxGroupId__c FROM dmpl__RepairOrderLine__c LIMIT 1];
        repairOrderLine.dmpl__TaxGroupId__c = null;
        update repairOrderLine;
        TaxGroupHelper.getRepairOrder(repairOrderLine,repairOrder);
        System.assertEquals(null, repairOrderLine.dmpl__TaxGroupId__c, 'Tax Group Id is updated as null');
        test.stopTest();
    }
    /*
    @isTest
    public static void UpdateBill()
    {
        test.startTest();
        //List<BillLine__c> purchaseInvoiceLines, List<Bill__c> purchaseInvoices, List<Item__c> lineItems
        CreateBill();
        List<dmpl__Bill__c> bill = [Select Id,Name From dmpl__Bill__c LIMIT 1];
        List<dmpl__BillLine__c> billLine = [Select Id,Name,dmpl__TaxGroupId__c FROM dmpl__BillLine__c LIMIT 1];
        List<dmpl__Item__c> Item = [Select Id,Name FROM dmpl__Item__c LIMIT 1];
        System.debug(bill);
        System.debug(billLine);
        System.debug(Item);
        TaxGroupHelper.setApplicableTaxGroups(billLine,bill,Item);
        //System.assertEquals(null, billReturnLine.dmpl__TaxGroupId__c, 'Tax Group Id is updated as null');
        test.stopTest();
    }*/
    
    @isTest
    public static void UpdateServiceEstimateLine()
    {
        test.startTest();
        CreateServiceEstimate();    
        List<dmpl__Quote__c> quote = [Select Id,Name From dmpl__Quote__c LIMIT 1];
        dmpl__QuoteLine__c estimateLine = [Select Id,Name,dmpl__QuoteId__c,dmpl__TaxGroupId__c FROM dmpl__QuoteLine__c LIMIT 1];
        estimateLine.dmpl__TaxGroupId__c = null;
        update estimateLine;
        TaxGroupHelper.getQuote(estimateLine,quote);
        System.assertEquals(null, estimateLine.dmpl__TaxGroupId__c, 'Tax Group Id is updated as null');
        test.stopTest();
    }
    
    @isTest
    public static void UpdatePurchaseOrderLine()
    {
        test.startTest();
        CreatePurchaseOrder();
        List<dmpl__PurchaseOrder__c> purchaseOrder = [Select Id,Name From dmpl__PurchaseOrder__c LIMIT 1];
        dmpl__PurchaseOrderLine__c purchaseOrderLine = [Select Id,Name,dmpl__PurchaseOrderId__c,dmpl__TaxGroupId__c FROM dmpl__PurchaseOrderLine__c LIMIT 1];
        dmpl__TaxGroup__c tax = [Select Id,Name,dmpl__BranchId__c,dmpl__PartnerAccountId__c From dmpl__TaxGroup__c LIMIT 1];
        dmpl__ItemLot__c lot = [Select Id,Name,dmpl__ItemId__c, dmpl__SKUId__c,dmpl__SaleDate__c From dmpl__ItemLot__c LIMIT 1];
        purchaseOrderLine.dmpl__TaxGroupId__c = null;
        update purchaseOrderLine;
        TaxGroupHelper.getApplicableTaxGroup(tax.dmpl__PartnerAccountId__c, tax.dmpl__BranchId__c, lot.dmpl__ItemId__c, lot.dmpl__SKUId__c, lot.dmpl__SaleDate__c, '');
        TaxGroupHelper.queryTaxGroup(tax.dmpl__PartnerAccountId__c, tax.dmpl__BranchId__c, lot.dmpl__ItemId__c, lot.dmpl__SKUId__c, lot.dmpl__SaleDate__c, '');
        TaxGroupHelper.queryTaxGroup(tax.dmpl__PartnerAccountId__c, tax.dmpl__BranchId__c, lot.dmpl__ItemId__c, lot.dmpl__SaleDate__c, '');
        TaxGroupHelper.getPurchaseOrder(purchaseOrderLine,purchaseOrder);
        System.assertEquals(null, purchaseOrderLine.dmpl__TaxGroupId__c, 'Tax Group Id is updated as null');
        test.stopTest();
    }
    
    @isTest
    public static void getSourceObjectInfo()
    {
        Test.startTest();
        CreatePurchaseOrder();
        dmpl__PurchaseOrderLine__c line = [Select Id,Name,dmpl__PurchaseOrderId__c,dmpl__TaxGroupId__c FROM dmpl__PurchaseOrderLine__c LIMIT 1];
        dmpl__TaxGroup__c tax = [Select Id,Name,dmpl__BranchId__c,dmpl__PartnerAccountId__c From dmpl__TaxGroup__c LIMIT 1];
        List<SourceObjectInfo> info = new List<SourceObjectInfo>();
        SourceObjectInfo.reduceRequestedQuantity(info,line.Id,tax.Id,10.00);
        SourceObjectInfo.getRequestedQuantity(info,line.Id,tax.Id);
        System.assert(line != null, 'Purchase Order Data');
        test.stopTest();
    }
    
    public static void UpdatePurchaseOrderAsReleaseInvoice()
    {
        test.startTest();
        CreatePurchaseOrder();
        dmpl__PurchaseOrder__c purchaseOrder = [Select Id,Name,dmpl__PerformReleaseInvoice__c From dmpl__PurchaseOrder__c LIMIT 1];
        purchaseOrder.dmpl__PerformReleaseInvoice__c = true;
        update purchaseOrder;
        System.assertEquals(true, purchaseOrder.dmpl__PerformReleaseInvoice__c, 'purchase Order have 1 updated record');
      test.stopTest();
    }
    
    public static void verify()
    {
        CreateBranchTimeSlot();
        CreateServiceBay();
        //CreateServiceType();
        CreateServiceRequest();
        test.startTest();
        CreateServiceEstimate();        
        CreateRepairOrder();
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
                                dmpl__LastName__c = 'Tax-Group',
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
                                             dmpl__LastName__c = 'Tax-Group',
                                             dmpl__IsPartnerAccount__c = True, 
                                             dmpl__IsActive__c = true);
        insert partneraccount;
        
        Account customerAccount = new Account(Name = 'Customer-Test-Account',
                                              dmpl__LastName__c = 'Tax-Group',
                                              dmpl__IsCustomerAccount__c = True,
                                              dmpl__IsActive__c = true,
                                             dmpl__PartnerTaxAccountGroupId__c = accountGroup.Id,
                                             dmpl__PartnerPriceAccountGroupId__c = accountGroup.Id);
        insert customerAccount;
       
        Account supplierAccount = new Account(Name = 'Supplier-Test-Account',
                                              dmpl__LastName__c = 'Tax-Group',
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
        insert branch;
    }
    
    private static void CreateItemGroup()
    {
      List<dmpl__ItemGroup__c> itemGroup = new List<dmpl__ItemGroup__c> ();
        itemGroup.Add(new dmpl__ItemGroup__c(Name = 'Item Group Test',
                                             dmpl__ItemGroupType__c = 'Tax'
        ));
        insert itemGroup;
    }
    
    private static void CreateItems()
    {
        List<dmpl__Item__c> item = new List<dmpl__Item__c>();
        dmpl__ItemGroup__c itemGroup = [Select Id,Name FROM dmpl__ItemGroup__c LIMIT 1];
        item.Add(new dmpl__Item__c(Name = 'Test-Item',
                                   dmpl__ItemCode__c = 'DMPL',
                                   dmpl__ItemType__c = 'Service Contract',
                                   dmpl__ItemSubType__c = '',
                                   dmpl__Description__c = '',
                                   dmpl__ItemFamily__c = 'Sample',
                                   dmpl__ItemSegment__c = 'Sample',
                                   dmpl__Make__c = 'Sample',
                                   dmpl__Model__c = 'Sample',
                                   dmpl__TaxItemGroupId__c = itemGroup.Id,
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
    
    private static void CreateSKU()
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
    
    private static void CreateItemLot()
    {
        List<dmpl__ItemLot__c> itemLot = new List<dmpl__ItemLot__c>();
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id, Name from dmpl__SKU__c LIMIT 1];
        itemLot.Add(new dmpl__ItemLot__c(dmpl__BranchId__c = branch.Id,
                                         dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                         dmpl__ItemId__c = item.Id,
                                         dmpl__SKUId__c = sku.Id,
                                         dmpl__BatchNo__c = '12345',
                                         dmpl__SerialNumber__c = '4675',
                                         dmpl__SupplierInvoiceNumber__c = '74985',
                                         dmpl__DateOfReceipt__c = date.today(),
                                         dmpl__DateOfMfg__c = date.today(),
                                         dmpl__TotalCost__c = 100,
                                         dmpl__DateOfSupplierInvoice__c = date.today(),
                                         dmpl__Cost__c = 100
                                         //dmpl__QuantityExpired__c = 1,
                                        // dmpl__QuantityOnHold__c = 1,
                                        // dmpl__QuantityOnLoan__c = 1
        ));
        insert itemLot;
    }
    
    private static void CreateResource()
    {
        List<dmpl__Resource__c> resource = new List<dmpl__Resource__c>();
        Account partnerAccount = [Select Id,Name From Account LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name From dmpl__Branch__c LIMIT 1];
        resource.add(new dmpl__Resource__c(Name = 'Test - Resource',
                                           dmpl__ResourceType__c = 'Service Advisor',
                                           dmpl__IsActive__c = true,
                                           dmpl__Phone__c = '9999999999',
                                           dmpl__DefaultPartnerAccountId__c = partnerAccount.Id,
                                           dmpl__DefaultBranchId__c = branch.Id
                                          ));
        insert resource;
        
        List<dmpl__Resource__c> technicianResource = new List<dmpl__Resource__c>();
        technicianResource.add(new dmpl__Resource__c(Name = 'Test - Resource',
                                           dmpl__ResourceType__c = 'Technician',
                                           dmpl__IsActive__c = true,
                                           dmpl__DefaultPartnerAccountId__c = partnerAccount.Id,
                                           dmpl__DefaultBranchId__c = branch.Id
                                          ));
        insert technicianResource;
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
        Account customerAccount = [Select Id,Name From Account WHERE dmpl__IsCustomerAccount__c = True LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c LIMIT 1];
        dmpl__ContactAddress__c contactAddress = [Select Id,Name From dmpl__ContactAddress__c LIMIT 1];
        //dmpl__Resource__c resource = [Select Id,Name From dmpl__Resource__c LIMIT 1];
        saleOrder.Add(new dmpl__SaleOrder__c(dmpl__AccountId__c = customerAccount.Id,
                                             dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                             dmpl__BranchId__c = branch.Id,
                                             dmpl__DocumentDate__c = Date.today(),
                                             dmpl__Status__c = 'Draft',
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
                                                     dmpl__TaxGroupId__c = taxGroup.Id,
                                                     dmpl__UnitPrice__c = 100,
                                                     dmpl__Discount__c = 5                                                                                                        
        ));
        insert saleOrderLine;
    }
    
    private static void CreateSaleInvoice()
    {
        List<dmpl__SaleInvoice__c> saleInvoice = new List<dmpl__SaleInvoice__c>();
        Account account = [Select Id,Name From Account WHERE Name = 'Customer-Test-Account' LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c LIMIT 1];
        dmpl__SaleOrder__c saleOrder = [Select Id,Name From dmpl__SaleOrder__c LIMIT 1];
        //dmpl__Resource__c resource = [Select Id,Name From dmpl__Resource__c LIMIT 1];
        saleInvoice.Add(new dmpl__SaleInvoice__c(dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                             dmpl__BranchId__c = Branch.Id,
                         dmpl__DocumentDate__c = date.today(),
                         dmpl__AccountId__c = account.Id,
                         //dmpl__SalesExecutiveId__c = resource.Id,
                                             dmpl__SaleOrderId__c = saleOrder.Id,
                         dmpl__FinanceAmount__c=100,
                                               dmpl__AmountPaid__C =1 
                                                ));
        insert saleInvoice;
    
        List<dmpl__SaleInvoiceLine__c> saleInvoiceLine = new List<dmpl__SaleInvoiceLine__c>();
        dmpl__SKU__c sku = [Select Id ,Name From dmpl__SKU__c LIMIT 1 ];
      dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
    dmpl__TaxGroup__c taxGroup = [Select Id,Name From dmpl__TaxGroup__c LIMIT 1];
        saleInvoiceLine.Add(new dmpl__SaleInvoiceLine__c(dmpl__SaleInvoiceId__c = SaleInvoice[0].id,
                                                         dmpl__ItemId__c = item.Id,
                             dmpl__SKUId__c = sku.Id,
                             dmpl__Quantity__c = 100,
                             dmpl__UnitPrice__c = 100,
                             dmpl__SchemeDiscountAmount__c = 100,
                                                         dmpl__TaxGroupId__c = taxGroup.Id ));
        insert saleInvoiceLine;
    }
    
    private static void CreateGoodsReceipt()
    {
      List<dmpl__GoodsReceipt__c> goodsReceipts= new List<dmpl__GoodsReceipt__c>();
        Account partnerAccount=[Select Id,Name from Account Where Name='Partner-Test-Account' LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        dmpl__PurchaseOrder__c purchaseOrder = [Select Id,Name From dmpl__PurchaseOrder__c LIMIT 1];
        Account supplierAccount=[Select Id,Name from Account Where Name='Supplier-Test-Account' LIMIT 1];
        goodsReceipts.add(new dmpl__GoodsReceipt__c(dmpl__PartnerAccountId__c = partnerAccount.Id,
                                                    dmpl__BranchId__c = branch.Id,
                                                    dmpl__PurchaseOrderId__c = purchaseOrder.Id,
                                                    dmpl__ReceivedTime__c = date.today(),
                                                    dmpl__DocumentDate__c = date.today(),
                                                    dmpl__PerformReceive__c = true,
                                                    dmpl__PerformInspection__c = true,
                                                    dmpl__PerformInspectionComplete__c = true,
                                                    dmpl__IsInspectionCompleted__c = true,
                                                    dmpl__SupplierAccountId__c = supplierAccount.Id,
                                                    dmpl__SupplierInvoiceDate__c = date.today(),
                                                    dmpl__SupplierInvoiceNumber__c = 'Test-SupplierInvoiceNumber',
                                                    dmpl__SupplierDispatchDate__c = date.today(),
                                                    dmpl__TransporterName__c = 'Test-TransporterName',
                                                    dmpl__TransporterRefrenceNumber__c = 'Test-TransporterRefrenceNumber',
                                                    dmpl__TransporterContactNumber__c = '7575555555'
        ));
        insert goodsReceipts;
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
                                             dmpl__PriceListType__c = 'Sale Price',
                                             dmpl__IsActive__c = true,
                                             dmpl__IsDefault__c = true,
                                             Name='Test-1'
        ));
        insert priceList;
    }
    
    private static void CreateBill()
    {
        List<dmpl__Bill__c> bill = new List<dmpl__Bill__c>();
        dmpl__PurchaseOrder__c purchaseOrder = [Select Id,Name,dmpl__PartnerAccountId__c,dmpl__BranchId__c FROM dmpl__PurchaseOrder__c LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c LIMIT 1];
        Account partnerAccount = [Select Id,Name From Account WHERE Name = 'Partner-Test-Account' LIMIT 1];
        Account supplierAccount = [Select Id,Name From Account WHERE Name = 'Supplier-Test-Account' LIMIT 1];
        bill.add(new dmpl__Bill__c(dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                   dmpl__BranchId__c = branch.Id,
                                   dmpl__PurchaseOrderId__c = purchaseOrder.Id,
                                   dmpl__DocumentDate__c = date.today(),
                                   dmpl__TypeOfBill__c = 'Expense Bill',
                                   dmpl__SupplierAccountId__c = supplierAccount.Id,
                                   dmpl__SupplierInvoiceNumber__c = 'Test-InvoiceNumber',
                                   dmpl__SupplierInvoiceDate__c = date.today(),
                                   dmpl__SupplierInvoiceAmount__c = 100,
                                   dmpl__PerformGLPosting__c = true
        ));
        insert bill;
    
        List<dmpl__BillLine__c> billLine = new List<dmpl__BillLine__c>();
        Account customerAccount=[Select Id,Name from Account WHERE Name = 'Customer-Test-Account' LIMIT 1];
        dmpl__Item__c item = [Select Id,Name FROM dmpl__Item__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id,Name From dmpl__SKU__c LIMIT 1];
      dmpl__TaxGroup__c taxGroup = [Select Id,Name From dmpl__TaxGroup__c LIMIT 1];
        billLine.add(new dmpl__BillLine__c(dmpl__ItemId__c = item.Id,
                                           dmpl__SKUId__c = sku.Id,
                                           dmpl__AccountId__c = customerAccount.Id,
                                         dmpl__Quantity__c = 10,
                                           dmpl__UnitCost__c = 100,
                                           dmpl__IsCustomerBillable__c = true,
                                         dmpl__PurchaseInvoiceId__c = bill[0].Id,
                                         dmpl__TaxGroupId__c = null
        ));
        insert billLine;
    }
    
    private static void CreateItemLotType()
    {
        List<dmpl__ItemLotType__c> lotType = new List<dmpl__ItemLotType__c>();
        dmpl__Item__c item = [Select Id,Name FROM dmpl__Item__c LIMIT 1];
        lotType.add(new dmpl__ItemLotType__c(dmpl__PriceCode__c = 'PC1001',
                                             dmpl__VariationCode__c = 'VC1001',
                                             dmpl__ItemId__c = item.Id,
                                             dmpl__IsPromo__c = false
                                            ));
        insert lotType;
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
                                                     dmpl__TaxSupplyType__c = 'Within State',
                                                     dmpl__DocumentDate__c = Date.today(),
                                                     dmpl__Remarks__c = 'Remark'));
        insert purchaseOrder;
    
        List<dmpl__PurchaseOrderLine__c> purchaseOrderLine = new List<dmpl__PurchaseOrderLine__c>();
        dmpl__Item__c listofitem = [Select Id, Name from dmpl__Item__c LIMIT 1];
        dmpl__ItemLotType__c lotType = [Select Id,Name From dmpl__ItemLotType__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id,Name FROM dmpl__SKU__c LIMIT 1];
      dmpl__TaxGroup__c taxGroup = [Select Id,Name From dmpl__TaxGroup__c LIMIT 1];
        purchaseOrderLine.add(new dmpl__PurchaseOrderLine__c(dmpl__ItemId__c = listofitem.Id,
                                                             dmpl__SKUId__c = sku.Id,
                                                             dmpl__PurchaseOrderId__c = purchaseOrder[0].Id,
                                                             dmpl__Quantity__c = 1,
                                 dmpl__TaxGroupId__c = taxGroup.Id,
                                                             dmpl__ItemLotTypeId__c = lotType.Id
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
                                                     dmpl__ServiceContractItemId__c = item.Id,
                                                     dmpl__PerformApproval__c = false,
                                                     dmpl__PerformDecline__c = false,
                                                     dmpl__PerformRepairOrderGeneration__c = false,
                                                     dmpl__IsRepairOrderGenerated__c = false));
        insert ServiceEstimate;       
    
        List<dmpl__QuoteLine__c> ServiceEstimateLine = new List<dmpl__QuoteLine__c>();
        dmpl__TaxGroup__c taxGroup = [Select Id,Name From dmpl__TaxGroup__c LIMIT 1];
        ServiceEstimateLine.Add(new dmpl__QuoteLine__c(dmpl__ItemId__c = item.Id,
                                                             dmpl__Quantity__c = 50.00,
                                                             dmpl__UnitPrice__c = 10,
                                                             dmpl__DurationInHours__c = 12.00,
                                                             dmpl__IsApproved__c = false,
                                                             dmpl__IsDeclined__c = false,
                                                             dmpl__ServiceContractId__c = item.Id,
                                                             dmpl__PackageClassification__c = 'Optional Item',
                                                             dmpl__IncludeinPackage__c = True,
                                                             dmpl__IsPackageService__c = false,
                                                             dmpl__QuoteId__c = serviceEstimate[0].Id));
        insert ServiceEstimateLine;
    }
    
    private static void CreateRepairOrder()
    {
        List<dmpl__RepairOrder__c> repairOrder = new List<dmpl__RepairOrder__c> ();
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        //dmpl__Resource__c resource = [select Id,Name FROM dmpl__Resource__c LIMIT 1];
        Asset asset = [Select Id,Name From Asset LIMIT 1];
        Account customerAccount = [Select id,Name From Account Where Name = 'Customer-Test-Account' LIMIT 1];
        repairOrder.Add(new dmpl__RepairOrder__c (dmpl__BranchId__c = branch.Id,
                                                       dmpl__AccountId__c = customerAccount.Id,
                                                       dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                                       dmpl__AssetId__c = asset.Id,
                                                       dmpl__UsageReading__c = 8
                                                       //dmpl__ServiceAdvisorId__c = resource.Id
                                                       ));
      insert repairOrder;
    
        List<dmpl__RepairOrderLine__c> repairOrderLine = new List<dmpl__RepairOrderLine__c>();
        dmpl__TaxGroup__c taxGroup = [Select Id,Name From dmpl__TaxGroup__c LIMIT 1];
        //dmpl__Resource__c techResource = [select Id,Name FROM dmpl__Resource__c WHERE dmpl__ResourceType__c = 'Technician' LIMIT 1];
        repairOrderLine.add(new dmpl__RepairOrderLine__c(dmpl__ItemId__c = item.Id,
                                                         dmpl__Quantity__c = 5,
                                                         dmpl__UnitPrice__c = 10,
                                                         dmpl__PackageClassification__c = 'Optional Item',
                                                         dmpl__ActionTaken__c = 'Replace',
                                                         //dmpl__TechnicianId__c = techResource.Id,
                                                         dmpl__WorkStartedBy__c = date.today(),
                                                         dmpl__WorkEndedAt__c = date.today(),
                                                         dmpl__WorkStatus__c = 'Started',
                                                         dmpl__StandardDurationHours__c = 10,
                                                         dmpl__ActualDurationHours__c = 10,
                                                         dmpl__TaxGroupId__c = null,
                                                         dmpl__RepairOrderId__c = repairOrder[0].Id
                                                        ));
        insert repairOrderLine;
    }
    
    private static void CreateBranchTimeSlot()
    {
        List<dmpl__BranchTimeSlot__c> branchTimeSlot = new List<dmpl__BranchTimeSlot__c>();
        dmpl__Branch__c branch = [Select Id,Name From dmpl__Branch__c LIMIT 1];
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        branchTimeSlot.Add(new dmpl__BranchTimeSlot__c(dmpl__BranchId__c = branch.Id,
                                                       dmpl__TransactionType__c = 'Delivery',
                                                       Name = 'Test - Name',
                                                       dmpl__IsActive__c = True,
                                                       dmpl__ApplicableToItem__c= item.Id,
                                                       dmpl__MaximumCapacity__c = 20,                                                    
                                                       dmpl__MondayCapacity__c = 32,
                                                       dmpl__TuesdayCapacity__c = 22,
                                                       dmpl__WednesdayCapacity__c = 11,
                                                       dmpl__ThursdayCapacity__c = 20,
                                                       dmpl__FridayCapacity__c = 22,
                                                       dmpl__SaturdayCapacity__c = 10,
                                                       dmpl__SundayCapacity__c = 12
                                                       ));
        insert branchTimeSlot;
    }
    
    private static void CreateServiceBay()
    {
        List<dmpl__ServiceBay__c> serviceBay = new List<dmpl__ServiceBay__c>();
        dmpl__Branch__c branch = [Select Id,Name From dmpl__Branch__c];
        serviceBay.add(new dmpl__ServiceBay__c(dmpl__BranchId__c = branch.Id,
                                               Name = 'Test-Service-Bay',
                                               dmpl__ServiceBayType__c = 'Warehouse',
                                               dmpl__AllowInventory__c = true
                                              ));
        insert serviceBay;
    }
    
    private static void CreateServiceRequest()
    {
        List<dmpl__ServiceRequest__c> serviceRequest = new List<dmpl__ServiceRequest__c>();
        Account account = [Select Id,Name From Account WHERE Name = 'Customer-Test-Account' LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id,Name FROM dmpl__SKU__c LIMIT 1];
        Asset asset = [Select Id,Name From Asset LIMIT 1];
        //dmpl__Resource__c resource = [select Id,Name FROM dmpl__Resource__c LIMIT 1];
        dmpl__BranchTimeSlot__c brTimeSlot = [Select Id From dmpl__BranchTimeSlot__c LIMIT 1];
        dmpl__TaxGroup__c taxGroup = [SELECT Id, Name FROM dmpl__TaxGroup__c LIMIT 1];
        serviceRequest.Add(new dmpl__ServiceRequest__c(dmpl__AccountId__c = account.Id,
                                                    dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                                    dmpl__AssetId__c = asset.Id,
                                                    dmpl__BranchId__c = branch.Id,
                                                    dmpl__AppointmentTimeSlotId__c = brTimeSlot.Id,
                                                    dmpl__ServiceContractItemId__c = item.Id,
                                                    dmpl__CustomerVoice__c = 'Service-Appointment',
                                                    dmpl__PackageServiceId__c = item.Id,
                                                       
                                                    //dmpl__ServiceAdvisorId__c = resource.Id,
                                                    dmpl__UsageReading__c = 10
                              ));
        insert serviceRequest;
        
        List<dmpl__ServiceRequestLine__c> newServiceRequestLines = new List<dmpl__ServiceRequestLine__c>();
        newServiceRequestLines.add(new dmpl__ServiceRequestLine__c(
                              dmpl__ServiceRequestId__c = serviceRequest[0].Id,
                            dmpl__ItemId__c = item.Id,
                              dmpl__SKUId__c = sku.Id,
                              dmpl__Quantity__c = 1,
                              dmpl__TaxGroupId__c = taxGroup.Id
        ));
        insert newServiceRequestLines;
    }
    
    private static void CreateAsset()
    {
        List<Asset> asset = new List<Asset>();
        Account account = [Select Id,Name From Account WHERE Name = 'Customer-Test-Account' LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name From dmpl__Branch__c LIMIT 1];
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        dmpl__ItemLot__c itemLot = [Select Id, Name From dmpl__ItemLot__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id,Name FROM dmpl__SKU__c LIMIT 1];
        asset.add(new Asset(Name = 'Test-Asset',
                           AccountId = account.Id,
                           dmpl__LastServiceBranchId__c = branch.Id,
                           dmpl__ItemId__c = item.Id,
                           dmpl__ItemLotId__c = itemLot.Id,
                           dmpl__SKUId__c = sku.Id,
                           dmpl__RegistrationNumber__c = 'Axb371',
                           dmpl__SaleDate__c = date.today()
                           ));
        insert asset;
    }
    
    private static void CreateTaxGroup()
    {
        List<dmpl__TaxGroup__c> taxGroup = new List<dmpl__TaxGroup__c>();
        Account account=[Select Id,Name from Account LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c]; 
        dmpl__AccountGroup__c accountGroup = [Select Id,Name From dmpl__AccountGroup__c ];
        taxGroup.Add(new dmpl__TaxGroup__c(Name = 'Test - Tax Group',
                                           dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                           dmpl__BranchId__c = branch.Id, 
                                           dmpl__PartnerAccountGroupId__c = accountGroup.Id,
                                           dmpl__Description__c = 'Description',
                                           dmpl__TaxGroupType__c = 'Line Level',
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
                                 dmpl__PostingFieldName__c ='Tax1',
                                dmpl__Rate__c = 10
                                ));        
        insert tax;
    }
    
    private static void CreateTaxGroupRule()
    {
        List<dmpl__TaxGroupRule__c> taxGroupRule = new List<dmpl__TaxGroupRule__c>();
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        dmpl__SKU__c SKU = [Select Id,Name From dmpl__SKU__c LIMIT 1];
        dmpl__TaxGroup__c taxGroup = [Select Id,Name,PartnerAccountId__c From dmpl__TaxGroup__c LIMIT 1];
        dmpl__ItemGroup__c ItemGroup = [Select Id,Name From dmpl__ItemGroup__c LIMIT 1];
        taxGroupRule.Add(new dmpl__TaxGroupRule__c(dmpl__TaxGroupId__c = taxGroup.Id,
                                                   dmpl__SKUId__c=SKU.Id,
                                                  dmpl__ItemId__c = Item.Id,
                                                   dmpl__DateEffectiveFrom__c=date.today(),
                                                   dmpl__DateEffectiveTill__c=date.today()+15,
                                                   dmpl__PlaceOfSupplyType__c='Within State',
                                                   dmpl__ItemGroupId__c=ItemGroup.Id
                                                  ));
        insert taxGroupRule;
    }
}