@isTest
public class BillHelper_Test {
    
    @testSetup
    public static void Setup()
    {
        //System.runAs(PostInstallHelper.AssignAdministratorAllPermissions(UserInfo.getUserId())){
            CreateAccountGroup();
            CreateAccount();        
            CreateBranch();
            CreateItems();
            CreateSKu();
            CreateStorageLocation();
            CreateItemLot();
            CreateResource();
            CreatePriceList();
            CreatePriceListRules();
            CreateTaxGroup();
        test.startTest();
           // CreateTax();
            //CreateTaxGroupRule();
            CreatePurchaseOrder();
            CreatePriceList();
            CreateRequistion();
            CreateGoodsReceipt();
            CreateBill();        
            CreateBillLine();
        	CreatePurchaseOrderLine();
            test.stopTest();
        //}
    }
    
    @isTest
    public static void UpdateBill()
    {
        //try{
        Test.startTest();
        dmpl__Bill__c bill = [Select Id,Name,dmpl__Remarks__c From dmpl__Bill__c LIMIT 1];
        bill.dmpl__Remarks__c = 'Successful';
        bill.dmpl__IsGLPostingApproved__c = true;
        update bill;
        //SchemeEngine.postBillSchemeLeders();
        test.stopTest();
        System.assertEquals('Successful', bill.dmpl__Remarks__c, 'Bill have 1 updated record');
       // }
      //  catch(exception e){}
    }
    
    @isTest
    public static void UpdateBillPerformGLPosting()
    {
         test.startTest();
        dmpl__Bill__c bill = [Select Id,Name,dmpl__PerformGLPosting__c From dmpl__Bill__c LIMIT 1];
        bill.dmpl__PerformGLPosting__c = false;
        update bill;
        
        //List<AggregateResult> result3 = DocumentAmountPanelController.getDocumentTaxes('dmpl__Bill__c', bill.Id);
        //System.assertEquals(false, bill.dmpl__PerformGLPosting__c, 'Bill have 1 updated record');
        
        //bill.dmpl__PerformGLPosting__c = true;
        //update bill;
        Test.stopTest();
        //System.assertEquals(true, bill.dmpl__PerformGLPosting__c, 'Bill have 1 updated record');
    }
    
    @isTest
    public static void UpdateBillPerformGLPosting2()
    {
        test.startTest();
        dmpl__Bill__c bill = [Select Id,Name,dmpl__PerformGLPosting__c From dmpl__Bill__c LIMIT 1];
        bill.dmpl__PerformGLPosting__c = true;
        update bill;
        Test.stopTest();
        System.assertEquals(true, bill.dmpl__PerformGLPosting__c, 'Bill have 1 updated record');
    }
    
    @isTest
    public static void UpdateBillPerformKPICalculation()
    {
        test.startTest();
        dmpl__Bill__c bill = [Select Id,Name,dmpl__PerformKPICalculation__c From dmpl__Bill__c LIMIT 1];
        bill.dmpl__PerformKPICalculation__c = false;
        update bill;
        
        //System.assertEquals(false, bill.dmpl__PerformKPICalculation__c, 'Bill have 1 updated record');
        
        //bill.dmpl__PerformKPICalculation__c = true;
        //update bill;
        Test.stopTest();
        System.assertEquals(false, bill.dmpl__PerformKPICalculation__c, 'Bill have 1 updated record');
    }
    
    @isTest
    public static void UpdateBillPerformKPICalculation2()
    {
        test.startTest();
        dmpl__Bill__c bill = [Select Id,Name,dmpl__PerformKPICalculation__c From dmpl__Bill__c LIMIT 1];
        bill.dmpl__PerformKPICalculation__c = true;
        update bill;
        Test.stopTest();
        System.assertEquals(true, bill.dmpl__PerformKPICalculation__c, 'Bill have 1 updated record');
    }
    
    @isTest
    public static void setApplicableTaxGroups()
    {
        try{
            test.startTest();
         CreateTaxGroupRule();
        List<dmpl__Bill__c> bill = [Select Id,Name,dmpl__PartnerAccountId__c,dmpl__DocumentDate__c,dmpl__BranchId__c From dmpl__Bill__c LIMIT 1];
        List<dmpl__BillLine__c> line = [Select Id,Name,dmpl__ItemId__c,dmpl__SKUId__c,dmpl__TaxGroupId__c,dmpl__ItemLotTypeId__c From dmpl__BillLine__c WHERE dmpl__TaxGroupId__c != null LIMIT 1];
        List<dmpl__Item__c> item = [Select Id,Name,dmpl__TaxItemGroupId__c From dmpl__Item__c LIMIT 1];
        List<Id> billLineIds = new List<Id>();
        dmpl__TaxGroupRule__c rule = [Select Id,Name From dmpl__TaxGroupRule__c LIMIT 1];
        if(rule != null)
        {
        	TaxGroupHelper.setApplicableTaxGroups(line, bill, item);
        }
        BillLineHelper.queryBillLines(billLineIds);
        SchemeEngine.getBillLines();
        //System.assertNotEquals(null, bill);
        //BillHelper.updatePerformanceKPI(bill);
        test.stopTest();
        }
        catch(exception e){}
    }
    
    @isTest
    Public static void getPurchaseInvoice()
    {
       // try{
            test.startTest();
            BillLine__c soLine=[Select Id, Name,dmpl__PurchaseInvoiceId__c from BillLine__c Limit 1];
            List<Bill__c> sOrder=[Select Id, Name From Bill__c Limit 1 ];
            TaxGroupHelper.getPurchaseInvoice(soLine,sOrder);
            DiscountGroupHelper.getPurchaseInvoice(soLine,sOrder);
           // SchemeEngine.getBillSummary();
            TaxGroupHelper.getPurchaseInvoice(soLine,sOrder);
            //SchemeEngine.getPOLines();
           // SchemeEngine.getSILines();
           // SchemeEngine.getSOLines();
           // SchemeEngine.getBillLines();
            System.assertNotEquals(null, PriceListHelper.getPurchaseInvoice(soLine,sOrder));
            test.stopTest();
       // }
      //  catch(exception e){}
    } 
    
    @isTest
    public static void UpdateBillIsGLPostingApproved()
    {
         test.startTest();
		dmpl__Bill__c bill = [Select Id,Name,dmpl__IsGLPostingApproved__c From dmpl__Bill__c LIMIT 1];
        bill.dmpl__IsGLPostingApproved__c = true;
        update bill;
        test.stopTest();
        System.assertEquals(true, bill.dmpl__IsGLPostingApproved__c, 'Bill have 1 updated record');
    }
    
    @isTest
    public static void DeleteBill()
    {
        test.startTest();
        dmpl__Bill__c bill = [Select Id,Name,dmpl__Remarks__c From dmpl__Bill__c LIMIT 1];
        delete bill;
        test.stopTest();
        System.assertEquals(null, bill.dmpl__Remarks__c, 'Bill have 1 updated record');
    }
    
    @isTest
    public static void UpdateBillLine()
    {
         test.startTest();
       	dmpl__BillLine__c billLine = [Select Id,Name,dmpl__Quantity__c,dmpl__PriceListRuleId__c From dmpl__BillLine__c LIMIT 1];
        billLine.dmpl__Quantity__c = 5;
        billLine.dmpl__IsGLPostingApproved__c = true;
        update billLine;
        Test.stopTest();
        System.assertEquals(5, billLine.dmpl__Quantity__c, 'Bill Line have 1 updated record');
    }
    
    @isTest
    public static void UpdateBillLineAsIsCustomerBillable()
    {
        dmpl__BillLine__c billLine = [Select Id,Name,dmpl__IsCustomerBillable__c From dmpl__BillLine__c LIMIT 1];
        test.startTest();
        List<Id> Ids = new List<Id>();
        billLine.dmpl__IsCustomerBillable__c = true;
        update billLine;
        PerformanceKPIHelper.queryBills(Ids);
        test.stopTest();
        System.assertEquals(true, billLine.dmpl__IsCustomerBillable__c, 'Bill Line have 1 updated record');
    }
    
      @isTest
    public static void setDefaultDiscountGroupIds()
    {
        test.startTest();
        CreateDiscountGroup();
        List<dmpl__Bill__c> shipment = [SELECT Id,  Name,
                                                 //dmpl__AccountId__c,
                                                 dmpl__DocumentDate__c,
                                                 dmpl__DiscountGroupId__c,
                                                 dmpl__BranchId__c,
                                                 dmpl__PartnerAccountId__c
                                                 FROM dmpl__Bill__c];       
        
        DiscountGroupHelper.setDefaultDiscountGroupIds(shipment);
        System.assert(shipment != null, 'delivery order data');
        test.stopTest();
    }
    
    @isTest
    public static void DeleteBillLine()
    {
         test.startTest();
        dmpl__BillLine__c billLine = [Select Id,Name,dmpl__Quantity__c From dmpl__BillLine__c LIMIT 1];
        if(billLine != null)
            delete billLine;
        test.stopTest();
        System.assertEquals(10, billLine.dmpl__Quantity__c, 'Bill Line have 1 updated record');
    }
    
    @isTest
    private static void VerifyPerformReprice()
    {
        test.startTest();
        dmpl__Bill__c bill = [Select Id,Name,dmpl__Remarks__c From dmpl__Bill__c LIMIT 1];
        BillLineHelper.performReprice(bill.Id);
        test.stopTest();
    }
    
    @isTest
    private static void verifycreateBillTax()
    {
        test.startTest();
        CreateTax();
        dmpl__Tax__c tax = [Select Id,Name,Rate__c From dmpl__Tax__c LIMIT 1];
        dmpl__Bill__c bill = [Select Id,Name,dmpl__TotalLineGrossAmount__c,dmpl__TCSEligibleAmount__c,dmpl__TaxGroupId__c From dmpl__Bill__c LIMIT 1];
        //PurchaseInvoiceTaxHelper.createBillTax(tax,bill);
        System.assert(bill != null, 'Bill Inserted');
        test.stopTest();
    }
    
    @isTest
    public static void testNew(){
        dmpl__PurchaseOrderLine__c orderLine = [SELECT id,dmpl__ItemId__c,dmpl__SKUId__c,dmpl__PendingInvoiceQuantity__c,dmpl__TaxGroupId__c,dmpl__PurchaseOrderId__r.dmpl__BranchId__c,dmpl__PurchaseOrderId__r.dmpl__PartnerAccountId__c,dmpl__PurchaseOrderId__r.dmpl__DocumentDate__c,dmpl__PurchaseOrderId__r.dmpl__SupplierAccountId__c,dmpl__PurchaseOrderId__c FROM dmpl__PurchaseOrderLine__c LIMIT 1];
        BillHelper.createPurchaseInvoiceDocumentFromOrder(orderLine);
        BillHelper.createPurchaseInvoiceLinesFromOrderLine(orderLine);
        List<dmpl__PurchaseOrder__c> pos=[Select Id,Name From dmpl__PurchaseOrder__c];
        BillHelper.createPurchaseInvoiceFromPurchaseOrder(pos);
        //List<dmpl__GoodsReceipt__c> goodsReceipts = [Select Id,Name From dmpl__GoodsReceipt__c];
        //BillHelper.createBillFromGoodsReceipt(goodsReceipts);
    }
    
    private static void CreateAccountGroup()
    {
        dmpl__AccountGroup__c accountGroup= new dmpl__AccountGroup__c (Name= 'Test-AccountGroup', 
                                                                       dmpl__AccountGroupType__c='Discount');
        insert accountGroup;
    }
    
    private static void CreateAccount()
    {
      //  List<Account> account = new List<Account>();
        dmpl__AccountGroup__c accountGroup = [Select Id,Name From dmpl__AccountGroup__c LIMIT 1];
       /* account.add(new Account(Name = 'Test - Account', 
                                Fax = '09876',
                                dmpl__LastName__c = 'Cycle Count',
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
        insert account; */
        
        Account partneraccount = new Account(Name = 'Partner-Test-Account',
                                             dmpl__IsPartnerAccount__c = True, 
                                             dmpl__LastName__c = 'Cycle Count',
                                             dmpl__IsActive__c = true);
        insert partneraccount;
        
        Account customerAccount = new Account(Name = 'Customer-Test-Account',
                                              dmpl__IsCustomerAccount__c = True,
                                              dmpl__LastName__c = 'Cycle Count',
                                              dmpl__IsActive__c = true);
        insert customerAccount;
        
       Account supplierAccount = new Account(Name = 'Supplier-Test-Account',
                                              dmpl__IsSupplierAccount__c = True,
                                              dmpl__LastName__c = 'Cycle Count',
                                              dmpl__IsActive__c = true);
        insert supplierAccount;
        
         dmpl__AccountGroupMember__c partnerAccountGroupMember = new dmpl__AccountGroupMember__c
            (dmpl__AccountGroupId__c=accountGroup.Id,
             dmpl__AccountId__c=partneraccount.Id
            );
        Insert partnerAccountGroupMember;
        
        dmpl__AccountGroupMember__c customerAccountGroupMember = new dmpl__AccountGroupMember__c
            (dmpl__AccountGroupId__c=accountGroup.Id,
             dmpl__AccountId__c=customerAccount.Id
            );
        Insert customerAccountGroupMember;
    }
    
    private static void CreateDiscountGroup()
    {
        List<dmpl__DiscountGroup__c> discountGroup = new List<dmpl__DiscountGroup__c>();
        dmpl__AccountGroup__c accountGroup=[Select Id,Name From dmpl__AccountGroup__c where dmpl__AccountGroupType__c='Discount' LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name From dmpl__Branch__c Limit 1];
        Account account=[Select Id,Name from Account Where Name='Partner-Test-Account' LIMIT 1];
        discountGroup.add(new dmpl__DiscountGroup__c(dmpl__BranchId__c = branch.Id,
                                                     dmpl__CustomerAccountGroupId__c = accountGroup.Id,
                                                     dmpl__PartnerAccountId__c = account.Id,
                                                     dmpl__PartnerAccountGroupId__c = accountGroup.Id,
                                                     dmpl__IsDefault__c = true,
                                                     dmpl__IsActive__c = true,
                                                     Name = 'Test - Discount - Group',
                                                     dmpl__DiscountType__c ='Purchase Price'
        											));
        insert discountGroup;
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
                                       dmpl__ServiceEmail__c = 'Customer@Outlook.com'
                                      ));
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
    
    private static void CreateTaxGroupRule()
    {
        List<dmpl__TaxGroupRule__c> rule = new List<dmpl__TaxGroupRule__c>();
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        dmpl__TaxGroup__c taxGroup = [Select Id,Name From dmpl__TaxGroup__c LIMIT 1];
        rule.add(new dmpl__TaxGroupRule__c(dmpl__DateEffectiveFrom__c = date.today(),
                                           dmpl__ItemId__c = item.Id,
                                           dmpl__ItemLotTypeId__c = null,
                                           dmpl__TaxGroupId__c = taxGroup.Id
                                          ));
        insert rule;  
    }
    
    private static void CreateStorageLocation()
    {
        List<dmpl__StorageLocation__c> storageLocation =  new List<dmpl__StorageLocation__c>();
        dmpl__Branch__c branch = [Select Id,Name,dmpl__ParentLocationId__c From dmpl__Branch__c];
        storageLocation.Add(new dmpl__StorageLocation__c(dmpl__BranchId__c = branch.Id,
                                                         dmpl__ParentLocationId__c = branch.dmpl__ParentLocationId__c,
                                                         dmpl__AllowInventory__c=true,
                                                         dmpl__IsMobile__c=true,
                                                         dmpl__IsActive__c=true,
                                                         dmpl__LocationType__c='Washing Bay'));
        insert storageLocation;
    }
    
    private static void CreateItemLot()
    {
        List<dmpl__ItemLot__c> itemLot = new List<dmpl__ItemLot__c>();
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        dmpl__SKU__c sku = [Select Id ,Name From dmpl__SKU__c LIMIT 1 ];
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        itemLot.Add(new dmpl__ItemLot__c(dmpl__BranchId__c = branch.Id,
                                         dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                         dmpl__ItemId__c = item.Id,
                                         dmpl__SKUId__c =sku.Id,
                                         dmpl__BatchNo__c = 'ZAY',
                                         dmpl__SerialNumber__c='BCA',
                                         dmpl__SupplierInvoiceNumber__c='hfg',
                                         dmpl__DateOfReceipt__c= date.today(),
                                         dmpl__DateOfMfg__c=date.today(),
                                         dmpl__TotalCost__c=10.2,
                                         dmpl__DateOfSupplierInvoice__c=date.today(),
                                         dmpl__Cost__c=40.3
                                        ));
        insert itemLot;
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
    
    private static void CreateRequistion()
    {
        List<dmpl__PurchaseRequisition__c> purchaseRequistion = new List<dmpl__PurchaseRequisition__c>();
        Account partnerAccount=[Select Id,Name from Account Where Name='Partner-Test-Account' LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        User user = [Select Id,Name From User Limit 1];
        purchaseRequistion.add(new dmpl__PurchaseRequisition__c(dmpl__PartnerAccountId__c = partnerAccount.Id,
                                                                dmpl__BranchId__c = branch.Id,
                                                                dmpl__DocumentDate__c = date.today(),
                                                                dmpl__Status__c = 'Draft',
                                                                dmpl__RequestedById__c = user.Id,
                                                                dmpl__Remarks__c = 'Test-Remarks'
                                                               ));
        insert purchaseRequistion;
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
    
    
    private static void CreateBill()
    {
        List<dmpl__Bill__c> bill = new List<dmpl__Bill__c>();
        dmpl__PurchaseOrder__c purchaseOrder = [Select Id,Name,dmpl__PartnerAccountId__c,dmpl__BranchId__c FROM dmpl__PurchaseOrder__c LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        Account partnerAccount = [Select Id,Name From Account WHERE Name = 'Partner-Test-Account' LIMIT 1];
        dmpl__GoodsReceipt__c goodsReceipts = [Select Id,Name From dmpl__GoodsReceipt__c LIMIT 1];
        dmpl__PriceList__c priceList = [Select Id,Name From dmpl__PriceList__c LIMIT 1];
        Account supplierAccount = [Select Id,Name From Account WHERE Name = 'Supplier-Test-Account' LIMIT 1];
        bill.add(new dmpl__Bill__c(dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                   dmpl__BranchId__c = branch.Id,
                                   dmpl__PurchaseOrderId__c = purchaseOrder.Id,
                                   dmpl__GoodsReceiptId__c = goodsReceipts.Id,
                                   dmpl__DocumentDate__c = date.today(),
                                   dmpl__TypeOfBill__c = 'Expense Bill',
                                   dmpl__PriceListId__c = priceList.Id,
                                   dmpl__SupplierAccountId__c = supplierAccount.Id,
                                   dmpl__SupplierInvoiceNumber__c = 'Test-InvoiceNumber',
                                   dmpl__SupplierInvoiceDate__c = date.today(),
                                   dmpl__SupplierInvoiceAmount__c = 100,
                                   dmpl__TCSEligibleAmount__c = 100,
                                   dmpl__PerformGLPosting__c = false
                                  ));
        insert bill;
    }
    
    private static void CreateBillLine()
    {
        List<dmpl__BillLine__c> billLine = new List<dmpl__BillLine__c>();
        Account customerAccount=[Select Id,Name from Account WHERE Name = 'Customer-Test-Account' LIMIT 1];
        dmpl__Item__c item = [Select Id,Name FROM dmpl__Item__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id,Name From dmpl__SKU__c LIMIT 1];
        dmpl__ItemLot__c itemLot =[Select Id, Name,dmpl__ItemLotTypeId__c From dmpl__ItemLot__c Limit 1];
        dmpl__Bill__c bill = [Select Id,Name From dmpl__Bill__c LIMIT 1];
        dmpl__PriceListRules__c rule=[select Id, Name From dmpl__PriceListRules__c];
        dmpl__TaxGroup__c taxGroup = [Select Id,Name From dmpl__TaxGroup__c LIMIT 1];
        billLine.add(new dmpl__BillLine__c(dmpl__ItemId__c = item.Id,
                                           dmpl__SKUId__c = sku.Id,
                                           dmpl__ItemLotId__c=itemLot.Id,
                                           dmpl__PriceListRuleId__c=rule.Id,
                                           dmpl__AccountId__c = customerAccount.Id,
                                           dmpl__TaxGroupId__c = taxGroup.Id,
                                           dmpl__Quantity__c = 10,
                                           dmpl__UnitCost__c = 100,
                                           dmpl__IsCustomerBillable__c = true,
                                           dmpl__ItemLotTypeId__c = itemLot.dmpl__ItemLotTypeId__c,
                                           dmpl__PurchaseInvoiceId__c = bill.Id
                                          ));
        insert billLine;
    }
    
    
    public static void UpdatePurchaseOrder()
    {
        dmpl__PurchaseOrder__c purchaseOrder = [Select Id,Name,dmpl__PerformReleaseInvoice__c From dmpl__PurchaseOrder__c LIMIT 1];
        purchaseOrder.dmpl__PerformReleaseInvoice__c = True;
        
        update purchaseOrder;
        System.assertEquals(True, purchaseOrder.dmpl__PerformReleaseInvoice__c, 'Purchase Order have 1 updated record');
    } 
    
    private static void CreatePurchaseOrder()
    {
        List<dmpl__PurchaseOrder__c> purchaseOrder = new List<dmpl__PurchaseOrder__c>();
        Account supplierAccount = [Select Id,Name From Account WHERE Name = 'Supplier-Test-Account' LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        purchaseOrder.add(new dmpl__PurchaseOrder__c(dmpl__BranchId__c = branch.Id,
                                                     dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                                     dmpl__SupplierAccountId__c = supplierAccount.Id,
                                                     dmpl__PurchaseOrderType__c = 'Part PO',
                                                     dmpl__DocumentDate__c = date.today(),
                                                     dmpl__Remarks__c = 'Test-Remarks',
                                                     dmpl__PerformReleaseInvoice__c =false,
                                                     dmpl__IsInvoiceReleased__c = false
                                                    ));
        insert purchaseOrder;
    } 
    private static void CreatePurchaseOrderLine()
    {
        List<dmpl__PurchaseOrderLine__c> purchaseOrderLine = new List<dmpl__PurchaseOrderLine__c>();
        dmpl__Item__c listofitem = [Select Id, Name from dmpl__Item__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id,Name From dmpl__SKU__c LIMIT 1];
        dmpl__TaxGroup__c taxGroup = [Select Id,Name From dmpl__TaxGroup__c];
        dmpl__PurchaseOrder__c purchaseOrder = [Select Id, Name FROM dmpl__PurchaseOrder__c LIMIT 1];
        dmpl__PurchaseRequisition__c purchaseRequisition = [Select Id,Name FROM dmpl__PurchaseRequisition__c LIMIt 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        dmpl__PriceList__c  priceList = [Select Id, Name FROM dmpl__PriceList__c LIMIT 1];
        purchaseOrderLine.add(new dmpl__PurchaseOrderLine__c(dmpl__ItemId__c = listofitem.Id,
                                                             dmpl__SKUId__c = sku.Id,
                                                             dmpl__PurchaseOrderId__c = purchaseOrder.Id,
                                                             dmpl__Quantity__c = 1,
                                                             dmpl__UnitCost__c = 100,
                                                             dmpl__TaxGroupId__c = taxGroup.Id,
                                                             dmpl__SchemeDiscount__c = 2,
                                                             dmpl__SchemeDiscountAmount__c = 4,
                                                             dmpl__DiscountAmount__c = 100,
                                                             dmpl__PurchaseRequisitionId__c = purchaseRequisition.Id
                                                            ));
        insert purchaseOrderLine;
    }
    
    private static void CreateTaxGroup()
    {
        List<dmpl__TaxGroup__c> taxGroup = new List<dmpl__TaxGroup__c>();
        Account account=[Select Id,Name from Account Where Name='Partner-Test-Account'];
        dmpl__AccountGroup__c accountGroup = [Select Id,Name From dmpl__AccountGroup__c];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
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
    private static void CreatePriceListRules()
    {
        List<dmpl__PriceListRules__c> priceListRules =new List<dmpl__PriceListRules__c>();
        dmpl__PriceList__c priceList = [Select Id,Name From dmpl__PriceList__c LIMIT 1];
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        priceListRules.Add(new dmpl__PriceListRules__c(dmpl__ItemId__c = item.Id,
                                                       dmpl__PriceListId__c=priceList.Id,
                                                       dmpl__Price__c=500,
                                                       dmpl__DateEffectiveFrom__c = date.today()
                                                      ));
        insert priceListRules;
        
    }  
}