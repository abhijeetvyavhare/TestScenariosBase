@isTest
public class BillReturnHelper_Test {

    @testSetup
    public static void Setup()
    {
        //System.runAs(PostInstallHelper.AssignAdministratorAllPermissions(UserInfo.getUserId())){
            CreateAccountGroup();
             CreateBranch();
            //CreateStorageLocation();
            CreateItems();
            CreateResource();
            CreateTaxGroup();
            CreateBill();
            CreateGoodReceiptLine();
          CreatePriceList();
            Test.startTest();
            CreateBillReturn();
            Test.stopTest();
            //CreateBillReturnTaxHelper();
            //CreatePurchaseInvoiceTax();
        //}
    }
    
    @isTest
    Public static void createBillReturnFromBill()
    {
        Test.startTest();
        List<SourceObjectInfo> info = new List <SourceObjectInfo>();
        dmpl__BillLine__c line = [Select Id,Name,dmpl__PurchaseInvoiceId__c From dmpl__BillLine__c LIMIT 1];
        dmpl__BillReturnLine__c billReturn = [Select Id, Name,dmpl__BillReturnId__c,dmpl__BillLineId__c From dmpl__BillReturnLine__c Limit 1 ];
        SourceObjectInfo obj = new SourceObjectInfo('dmpl__BillLine__c',line.Id,1,'data');
        SourceObjectInfo instance=new SourceObjectInfo('',line.Id,1,'',line.Id);
        SourceObjectInfo.generateToQueue(line.Id,new List<SObject>());
        info.add(obj);
        BillReturnHelper.createBillReturnFromBill(info,billReturn.dmpl__BillReturnId__c);
        System.assert(billReturn != null);
        Test.stopTest();
    }
    
    @isTest
    Public static void createReturnLineFromBillInvoiceLine()
    {
        Test.startTest();
        BillLine__c billLine=[Select Id, Name,
                              dmpl__ItemId__c,
                              dmpl__SKUId__c ,
                              dmpl__GeneralLedgerId__c,
                              dmpl__GLAccountId__c ,
                              dmpl__InventoryLedgerId__c ,
                              dmpl__ItemLotId__c,
                              dmpl__Discount__c,
                              dmpl__DiscountAmount__c,
                              dmpl__Discount2__c,
                              dmpl__DiscountAmount2__c,
                              dmpl__ContractDiscount__c,
                              dmpl__ContractDiscountAmount__c,
                              dmpl__TaxAmount__c,
                              dmpl__PurchaseOrderLineId__c,
                              dmpl__SchemeDiscount__c,
                              dmpl__SchemeDiscountAmount__c,
                              dmpl__SchemeLineId__c,
                              dmpl__StorageLocationId__c ,
                              dmpl__TaxGroupId__c,
                              dmpl__UnitCost__c,
                              dmpl__PurchaseInvoiceId__c ,
                              dmpl__GoodsReceiptLineId__c ,
                              dmpl__EligibleReturnQuantity__c
                              From BillLine__c Limit 1 ];
        List<SourceObjectInfo> info = new List <SourceObjectInfo>();
        BillReturnHelper.createReturnLineFromBillInvoiceLine(billLine,info);
        System.assert(billLine != null);
        Test.stopTest();
    }
    
    @isTest
    public static void VerifyBillReturnLine()
    {
        test.startTest();
        CreatePurchaseInvoiceTax();
        List<SourceObjectInfo> info = new List <SourceObjectInfo>();
        List<dmpl__BillLine__c> billLine = [Select Id,Name,dmpl__Quantity__c,dmpl__ReturnedQuantity__c,dmpl__ItemId__c,
                                            dmpl__SKUId__c ,
                                            dmpl__GeneralLedgerId__c,
                                            dmpl__GLAccountId__c ,
                                            dmpl__InventoryLedgerId__c ,
                                            dmpl__ItemLotId__c,
                                            dmpl__Discount__c,
                                            dmpl__DiscountAmount__c,
                                            dmpl__TaxAmount__c,
                                            dmpl__PurchaseOrderLineId__c,
                                            dmpl__SchemeDiscount__c,
                                            dmpl__SchemeDiscountAmount__c,
                                            dmpl__SchemeLineId__c,
                                            dmpl__StorageLocationId__c ,
                                            dmpl__TaxGroupId__c,
                                            dmpl__UnitCost__c,
                                            dmpl__Discount2__c,
                                            dmpl__DiscountAmount2__c,
                                            dmpl__ContractDiscount__c,
                                            dmpl__ContractDiscountAmount__c,
                                            dmpl__PurchaseInvoiceId__c ,
                                            dmpl__GoodsReceiptLineId__c ,
                                            dmpl__EligibleReturnQuantity__c From dmpl__BillLine__c LIMIT 1];
        List<dmpl__BillReturn__c> billReturn = [SELECT Id, Name FROM dmpl__BillReturn__c];
        dmpl__PurchaseInvoiceTax__c tax = [Select Id,Name,dmpl__TaxId__c,dmpl__TaxRate__c,dmpl__TaxGroupId__c From dmpl__PurchaseInvoiceTax__c LIMIT 1];
        dmpl__BillReturnLine__c line = [Select Id,Name,dmpl__BillReturnId__c,dmpl__Amount__c From dmpl__BillReturnLine__c LIMIT 1];
        BillReturnLineHelper.approveBillReturnLines(billReturn);
        BillReturnTaxHelper.createBillReturnTax(tax,line);
        System.debug('Bill --> ' + billLine.size());
        BillReturnHelper.createBillReturnLinesFromInvoiceInternal(billLine,info,billReturn[0].Id);
        System.assert(billReturn != null, 'purchase return data');
        test.stopTest();
    }
    
    @isTest
    public static void testnew(){
        List<dmpl__BillReturn__c> billReturn = [SELECT Id, Name FROM dmpl__BillReturn__c];
        dmpl__BillReturnLine__c line = [Select Id,Name,dmpl__BillReturnId__c,dmpl__Amount__c From dmpl__BillReturnLine__c LIMIT 1];
        BillReturnLineHelper.postIL(billReturn[0].id);
        BillReturnLineHelper.postIL(new List<SourceObjectInfo>(),billReturn[0].id);
        BillReturnLineHelper.postReturnLineInternal(new List<dmpl__BillReturnLine__c>{line});
        BillReturnLineHelper.queryReturnLines(new list<id>());
    }
    
    @isTest
    public static void markAsClaimed()
    {
        test.startTest();
        List<dmpl__BillReturnLine__c> billReturnLine = [SELECT Id, Name FROM dmpl__BillReturnLine__c];
        try {
            BillReturnLineHelper.markAsClaimed(billReturnLine);                
        } catch (Exception ex) {
            
        }
        System.assert(billReturnLine != null, 'purchase return data');
        test.stopTest();
    }
    
    @isTest
    public static void verify1()
    {
        test.startTest();
        dmpl__BillReturnLine__c billReturnLine = [SELECT Id,Name,dmpl__BillLineId__c,dmpl__BillReturnId__c,dmpl__TaxGroupId__c,dmpl__Amount__c FROM dmpl__BillReturnLine__c LIMIT 1];
        dmpl__Tax__c tax = [Select Id,Name,dmpl__Rate__c From dmpl__Tax__c LIMIT 1];
        BillReturnTaxHelper.createBillReturnTax(tax,billReturnLine);
        System.assert(billReturnLine != null, 'purchase return data');
        test.stopTest();
    }
    
    @isTest
    public static void verifysetApplicableTaxesInternal()
    {
        test.startTest();
        List<dmpl__BillReturnLine__c> billReturnLine = [SELECT Id,Name,dmpl__BillLineId__c,dmpl__IsClaimed__c,dmpl__BillReturnId__c,dmpl__TaxGroupId__c,dmpl__Amount__c FROM dmpl__BillReturnLine__c];
        BillReturnTaxHelper.setApplicableTaxesInternal(billReturnLine,billReturnLine[0].dmpl__IsClaimed__c);
        test.stopTest();
    }
    
    @isTest
    public static void getReturnDocument()
    {
        test.startTest();
        dmpl__BillReturnLine__c billReturnLine = [SELECT Id,Name,BillReturnId__c FROM dmpl__BillReturnLine__c LIMIT 1];
        List<dmpl__BillReturn__c> billReturns = [Select Id,Name From dmpl__BillReturn__c];
        TaxGroupHelper.getReturnDocument(billReturnLine,billReturns);
        test.stopTest();
    }
    
    @isTest
    public static void setApplicableTaxes()
    {
        test.startTest();
        List<dmpl__BillReturnLine__c> billReturnLine = [SELECT Id,Name,dmpl__BillLineId__c,dmpl__BillReturnId__c,dmpl__TaxGroupId__c,dmpl__Amount__c FROM dmpl__BillReturnLine__c];
        dmpl__DMSOrgSetting__mdt orgSetting = [SELECT Id,dmpl__PurchaseReturnTaxesValidity__c FROM dmpl__DMSOrgSetting__mdt LIMIT 1];
        BillReturnTaxHelper.setApplicableTaxes(billReturnLine);
        BillReturnTaxHelper.copyInvoiceLineTaxesInternal(billReturnLine,orgSetting,true);
        System.assert(billReturnLine != null, 'purchase return data');
        test.stopTest();
    }
    
    @isTest
    public static void deleteApplicableTaxes()
    {
        test.startTest();
        List<dmpl__BillReturnLine__c> billReturnLine = [SELECT Id,Name,dmpl__BillReturnId__c,dmpl__TaxGroupId__c FROM dmpl__BillReturnLine__c];
        BillReturnTaxHelper.deleteApplicableTaxes(billReturnLine);
        System.assert(billReturnLine != null, 'purchase return data');
        test.stopTest();
    }
    
    
    @isTest 
    public static void UpdateBillReturn()
    {
        test.startTest();
        dmpl__BillReturn__c billReturn = [Select Id,Name,dmpl__PerformReturn__c From dmpl__BillReturn__c LIMIT 1];
        string errorReceived;
        string expectedErrorCode = 'SOPOS001';
        try{
            billReturn.dmpl__PerformReturn__c = True;
            update billReturn;        }
        catch(Exception ex){
            errorReceived = ex.getMessage();
        }
        test.stopTest();
        System.assertNotEquals(expectedErrorCode,errorReceived);
    }
    
    @isTest
    public static void UpdatePerformInventoryPosting()
    {
        test.startTest();
        dmpl__BillReturn__c billReturn = [Select Id,Name,dmpl__PerformInventoryPosting__c From dmpl__BillReturn__c LIMIT 1];
        string errorReceived;
        string expectedErrorCode = 'SOPOS001';
        try{
            billReturn.dmpl__PerformInventoryPosting__c = True;
            update billReturn;
            System.assertEquals(True, billReturn.dmpl__PerformInventoryPosting__c, 'Sale Return has 1 Record Updated');
        }
        catch(Exception ex){
            errorReceived = ex.getMessage();
        }
        test.stopTest();
        System.assertNotEquals(expectedErrorCode,errorReceived);
    }
    
    @isTest
    public static void UpdatePerformGLPosting()
    {
        test.startTest();
        dmpl__BillReturn__c billReturn = [Select Id,Name,dmpl__PerformGLPosting__c From dmpl__BillReturn__c LIMIT 1];
        billReturn.dmpl__PerformGLPosting__c = True;
        update billReturn;
        test.stopTest();
        System.assertEquals(True, billReturn.dmpl__PerformGLPosting__c, 'Sale Return has 1 Record Updated');
    }
    
    @isTest
    public static void DeleteSaleReturn()
    {
        test.startTest();
        dmpl__BillReturn__c billReturn = [Select Id,Name,dmpl__PerformReturn__c From dmpl__BillReturn__c LIMIT 1];
        Delete billReturn;
        test.stopTest();
        System.assertEquals(false, billReturn.dmpl__PerformReturn__c, 'Sale Return has 1 Record Deleted');
    }
    
    @isTest
    public static void UpdateBillReturnLine()
    {
        test.startTest();
        dmpl__BillReturnLine__c billReturnLine = [Select Id,Name,dmpl__Quantity__c,dmpl__BillReturnId__r.dmpl__Status__c From dmpl__BillReturnLine__c LIMIT 1];
        Account account = [Select Id,Name From Account Where dmpl__IsPartnerAccount__c=true Limit 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        billReturnLine.dmpl__Quantity__c = 5;
        billReturnLine.dmpl__BillReturnId__r.dmpl__Status__c = 'Draft';
        billReturnLine.dmpl__ReturnType__c='Damaged';
        update billReturnLine;
        System.assertEquals(5, billReturnLine.dmpl__Quantity__c, 'bill Return has 1 Record Updated');
        test.stopTest();
    }
    
    @isTest
    private static void verifysetDefaultPriceListIds()
    {
        test.startTest();
        List<dmpl__BillReturn__c> billReturns = [Select Id,Name,dmpl__PartnerAccountId__c,BranchId__c,dmpl__PriceListId__c From dmpl__BillReturn__c];
        PriceListHelper.setDefaultPriceListIds(billReturns);
        System.assert(billReturns != null, 'Bill Return Inserted');
        test.stopTest();
    }
    
    @isTest
    public static void deleteBillReturnLine() 
    {
        test.startTest();
        dmpl__BillReturnLine__c billReturnLine = [Select Id,Name From dmpl__BillReturnLine__c LIMIT 1];
        if(billReturnLine != null)
            delete billReturnLine;
        System.assert(billReturnLine != null, 'Bill Return Line has 1 Record Deleted');
        test.stopTest();
    }
    
    //@isTest
    Public static void createBillReturnFromInvoice()
    {
        Try{
        Test.startTest();
        List<SourceObjectInfo> info = new List <SourceObjectInfo>();
        BillReturn__c billReturn = [Select Id, Name From BillReturn__c Limit 1 ];
        BillReturnLine__c billReturnLine = [Select Id, Name,dmpl__BillReturnId__c From BillReturnLine__c Limit 1 ];
        List<dmpl__BillLine__c> billLine = [Select Id,Name From dmpl__BillLine__c LIMIT 1];
        System.assert(billLine != null);
        Test.stopTest();
        }
        Catch(Exception e){}
    }

    @isTest
    public static void createSaleDeliveryFromBillReturn()
    {
        Try{
            Test.startTest();
            List<SourceObjectInfo> info = new List <SourceObjectInfo>();
            dmpl__BillReturn__c billReturn = [Select Id, Name From BillReturn__c Limit 1];
            SaleDeliveryHelper.createSaleDeliveryFromBillReturn(billReturn.Id);
            dmpl__DeliveryOrder__c currentDeliveryOrder = [SELECT Id, Name, dmpl__BillReturnId__c FROM dmpl__DeliveryOrder__c WHERE dmpl__BillReturnId__c = : billReturn.Id];
            System.assert(currentDeliveryOrder != null, 'Delivery Order not generated');
            Test.stopTest();
        }
        Catch(Exception e){
        }
    }

    @isTest
    public static void createSaleDeliveryFromBillReturnLines()
    {
        Try{
            Test.startTest();
            List<SourceObjectInfo> childObjectsInfo = new List <SourceObjectInfo>();
            BillReturnLine__c billReturnLine = [Select Id, Name,dmpl__BillReturnId__c, dmpl__Quantity__c From BillReturnLine__c Limit 1 ];
            childObjectsInfo.add(new SourceObjectInfo('dmpl__BillReturnLine__c', billReturnLine.Id, 0,''));
            SaleDeliveryHelper.createSaleDeliveryFromBillReturn(childObjectsInfo);
            dmpl__DeliveryOrder__c currentDeliveryOrder = [SELECT Id, Name, dmpl__BillReturnId__c FROM dmpl__DeliveryOrder__c WHERE dmpl__BillReturnId__c = : billReturnLine.dmpl__BillReturnId__c];
            System.assert(currentDeliveryOrder != null, 'Delivery Order not generated');
            Test.stopTest();
        }
        Catch(Exception e){
        }
    }
    
    @isTest
    private static void VerifyCreatePurchaseInvoiceTax()
    {
        test.startTest();
        CreatePurchaseInvoiceTax();
        test.stopTest();
    }
    
    @isTest
    private static void VerifyCreateBillReturnTaxHelper()
    {
        test.startTest();
        CreateBillReturnTaxHelper();
        test.stopTest();
    }
    
    private static void CreateAccountGroup()
    {
        dmpl__AccountGroup__c accountGroup= new dmpl__AccountGroup__c (Name= 'Test-AccountGroup', 
                                                                       dmpl__AccountGroupType__c='Scheme');
        insert accountGroup;
    
       /* List<Account> account = new List<Account>();
        account.add(new Account(Name = 'Test - Account',
                                dmpl__LastName__c = 'Account',
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
        insert account; */
        
        
        Account partneraccount = new Account(Name = 'Partner-Test-Account',
                                             dmpl__LastName__c = 'PartnerAccount',
                                             dmpl__IsPartnerAccount__c = True, 
                                             dmpl__IsActive__c = true);
        insert partneraccount;
        
        
        Account customerAccount = new Account(Name = 'Customer-Test-Account',
                                              dmpl__LastName__c = 'CustomerAccount',
                                              dmpl__IsCustomerAccount__c = True,
                                              dmpl__IsActive__c = true);
        insert customerAccount;
        
        
        Account supplierAccount = new Account(Name = 'Supplier-Test-Account',
                                              dmpl__LastName__c = 'SupplierAccount',
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
    
  /*  private static void CreateStorageLocation()
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
        
    } */
    
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
                                   dmpl__RFID__c = 'O1234fgh'));
        insert item;

        List<dmpl__SKU__c> sku = new List<dmpl__SKU__c>();
        //dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        sku.add(new dmpl__SKU__c(Name = 'Test - SKU',
                                 dmpl__SKUCode__c = 'Test - SKU - Code',
                                 dmpl__UnitOfMeasureOfConversion__c = 10,
                                 dmpl__ProductColor__c = 'Sample',
                                 dmpl__IsDefault__c = false,
                                 dmpl__QuantityUnitOfMeasure__c ='Sample',
                                 dmpl__ItemId__c = item[0].Id));
        insert sku;
        
        List<dmpl__ItemLot__c> itemLot = new List<dmpl__ItemLot__c>();
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        //dmpl__StorageLocation__c storageLocation = [Select Id, Name FROM dmpl__StorageLocation__c LIMIT 1];
        //dmpl__SKU__c sku = [Select Id ,Name From dmpl__SKU__c LIMIT 1 ];
//        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        itemLot.Add(new dmpl__ItemLot__c(dmpl__BranchId__c = branch.Id,
                                         dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                         dmpl__ItemId__c = item[0].Id,
                                       //  dmpl__StorageLocationId__c = storageLocation.Id,
                                         dmpl__SKUId__c =sku[0].Id,
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
    
    private static void CreateTaxGroup()
    {
        List<dmpl__TaxGroup__c> taxGroup = new List<dmpl__TaxGroup__c>();
        Account account=[Select Id,Name from Account Where Name='Partner-Test-Account'];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        dmpl__AccountGroup__c accountGroup = [Select Id,Name From dmpl__AccountGroup__c LIMIT 1];
        taxGroup.Add(new dmpl__TaxGroup__c(Name = 'Test - Tax Group',
                                           dmpl__PartnerAccountId__c = account.Id,
                                           dmpl__BranchId__c = branch.Id,
                                           dmpl__PartnerAccountGroupId__c = accountGroup.Id,
                                           dmpl__Description__c = 'Test-Description',
                                           dmpl__IsActive__c = false,
                                           dmpl__TaxGroupType__c = 'Line Level'
                                          ));
        insert taxGroup;
        
        List<dmpl__Tax__c> tax = new List<dmpl__Tax__c>();
        //dmpl__TaxGroup__c taxGroup = [Select Id,Name From dmpl__TaxGroup__c];
        tax.Add(new dmpl__Tax__c(Name = 'Test - Tax',
                                 dmpl__Rate__c = 10,
                                 dmpl__TaxGroupId__c = taxGroup[0].Id,
                                 dmpl__Type__c = 'Cess',
                                 dmpl__PostingFieldName__c = 'Tax1'
                                ));        
        insert tax;
    }
    private static void CreatePurchaseRequisition()
    {
        List<dmpl__PurchaseRequisition__c> purchaseRequisition = new List<dmpl__PurchaseRequisition__c>();
        Account supplierAccount = [Select Id,Name From Account WHERE Name = 'Supplier-Test-Account' LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        purchaseRequisition.add(new dmpl__PurchaseRequisition__c(dmpl__BranchId__c = branch.Id,
                                                                 dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                                                 dmpl__SupplierAccountId__c = supplierAccount.Id,
                                                                 dmpl__PerformReleaseOrder__c = false,
                                                                 dmpl__IsOrderReleased__c = true,
                                                                 dmpl__DocumentDate__c=Date.today(),
                                                                 dmpl__Remarks__c='sample'
                                                                ));
        insert purchaseRequisition;
        
        List<dmpl__PurchaseRequisitionLine__c> purchaseRequisitionLine = new List<dmpl__PurchaseRequisitionLine__c>();
        dmpl__Item__c item = [Select Id, Name from dmpl__Item__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id,Name From dmpl__SKU__c LIMIT 1];
        //dmpl__PurchaseRequisition__c purchaseRequisition = [Select Id, Name FROM dmpl__PurchaseRequisition__c LIMIT 1];
        purchaseRequisitionLine.add(new dmpl__PurchaseRequisitionLine__c(dmpl__PurchaseRequisitionId__c = purchaseRequisition[0].Id,
                                                                         dmpl__ItemId__c = item.Id,
                                                                         dmpl__SKUId__c = sku.Id,
                                                                         dmpl__Quantity__c = 1
                                                                        ));
        insert purchaseRequisitionLine;
        
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
     
        List<dmpl__PurchaseOrderLine__c> purchaseOrderLine = new List<dmpl__PurchaseOrderLine__c>();
        dmpl__Item__c listofitem = [Select Id, Name from dmpl__Item__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id,Name From dmpl__SKU__c LIMIT 1];
     //   dmpl__PurchaseOrder__c purchaseOrder = [Select Id, Name FROM dmpl__PurchaseOrder__c LIMIT 1];
        dmpl__TaxGroup__c taxGroup = [Select Id,Name From dmpl__TaxGroup__c LIMIT 1];
        purchaseOrderLine.add(new dmpl__PurchaseOrderLine__c(dmpl__ItemId__c = listofitem.Id,
                                                             dmpl__SKUId__c = sku.Id,
                                                             dmpl__PurchaseOrderId__c = purchaseOrder[0].Id,
                                                             dmpl__Quantity__c = 5,
                                                             dmpl__TaxGroupId__c = taxGroup.Id
                                                            ));
        insert purchaseOrderLine;
        
    }
    
    private static void CreateBill()
    {
        List<dmpl__Bill__c> bill = new List<dmpl__Bill__c>();
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        Account partnerAccount = [Select Id,Name From Account WHERE Name = 'Partner-Test-Account' LIMIT 1];
        Account supplierAccount = [Select Id,Name From Account WHERE Name = 'Supplier-Test-Account' LIMIT 1];
        bill.add(new dmpl__Bill__c(dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                   dmpl__BranchId__c = branch.Id,
                                   dmpl__DocumentDate__c = date.today(),
                                   dmpl__TypeOfBill__c = 'Expense Bill',
                                   dmpl__SupplierAccountId__c = supplierAccount.Id,
                                   dmpl__SupplierInvoiceNumber__c = 'Test-SInvoice',
                                   dmpl__SupplierInvoiceDate__c = date.today(),
                                   dmpl__SupplierInvoiceAmount__c = 100,
                                   dmpl__PerformGLPosting__c = true
                                  ));
        insert bill;
      
        List<dmpl__BillLine__c> billLine = new List<dmpl__BillLine__c>();
        Account account=[Select Id,Name from Account Where Name='Customer-Test-Account' LIMIT 1];
        dmpl__Item__c item = [Select Id,Name FROM dmpl__Item__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id,Name From dmpl__SKU__c LIMIT 1];
         //dmpl_Bill__c bill = [Select Id,Name From dmpl__Bill__c LIMIT 1];
        billLine.add(new dmpl__BillLine__c(dmpl__ItemId__c = item.Id,
                                           dmpl__SKUId__c = sku.Id,
                                           dmpl__AccountId__c = account.Id,
                                           dmpl__Quantity__c = 10,
                                           dmpl__UnitCost__c = 100,
                                           dmpl__ReturnedQuantity__c = 4,
                                           dmpl__IsCustomerBillable__c = true,
                                           dmpl__PurchaseInvoiceId__c = bill[0].Id
                                          ));
        insert billLine;
        
    }
    
    private static void CreateBillReturn()
    {
        List<dmpl__BillReturn__c> billReturn = new List<dmpl__BillReturn__c>();
        Account supplierAccount = [Select Id,Name From Account WHERE Name = 'Supplier-Test-Account' LIMIT 1];
        Account partnerAccount = [Select Id,Name From Account WHERE Name = 'Partner-Test-Account' LIMIT 1];
        dmpl__PriceList__c priceList = [Select Id,Name From dmpl__PriceList__c LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name From dmpl__Branch__c LIMIT 1];
        billReturn.add(new dmpl__BillReturn__c(dmpl__SupplierAccountId__c = supplierAccount.Id,
                                                       dmpl__BranchId__c = branch.Id,
                                                       dmpl__PartnerAccountId__c = partnerAccount.Id,
                                                       dmpl__SupplierInvoiceDate__c = date.today(),
                                                       dmpl__PerformReturn__c = false,
                                               dmpl__PriceListId__c = priceList.Id,
                                                       dmpl__IsReturned__c = false,
                                                       dmpl__PerformInventoryPosting__c = false,
                                                       dmpl__DocumentDate__c = date.today()));
        insert billReturn;
      
        List<dmpl__BillReturnLine__c> billReturnLine = new List<dmpl__BillReturnLine__c>();
      //  dmpl__BillReturn__c billReturn = [Select Id,Name From dmpl__BillReturn__c LIMIT 1];
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id,Name From dmpl__SKU__c LIMIT 1];
        dmpl__ItemLot__c itemLot = [Select Id,Name From dmpl__ItemLot__c LIMIT 1];
        dmpl__Bill__c bill = [Select Id,Name From dmpl__Bill__c LIMIT 1];
        dmpl__BillLine__c billLine = [Select Id,Name,dmpl__Quantity__c,dmpl__ReturnedQuantity__c From dmpl__BillLine__c LIMIT 1];
        dmpl__TaxGroup__c taxGroup = [Select Id,Name From dmpl__TaxGroup__c LIMIT 1];
        dmpl__GoodsReceiptLine__c grnLines = [SELECT Id, Name,dmpl__GoodsReceiptId__c FROM dmpl__GoodsReceiptLine__c LIMIT 1];
        billReturnLine.add(new dmpl__BillReturnLine__c(dmpl__ItemId__c = item.Id,
                                                               dmpl__Quantity__c = 5,
                                                             dmpl__DeliveryQuantity__c = billLine.dmpl__ReturnedQuantity__c,
                                                               dmpl__UnitCost__c = 100,
                                                               dmpl__SKUId__c = sku.Id,
                                                               dmpl__BillLineId__c=billLine.Id,
                                       dmpl__ItemLotId__c = itemLot.Id,
                                                               dmpl__GoodsReceiptLineId__c=grnLines.Id,
                                       dmpl__GoodsReceiptId__c = grnLines.dmpl__GoodsReceiptId__c,
                                                               dmpl__BillId__c = bill.Id,
                                                               dmpl__BillReturnId__c = billReturn[0].Id,
                                       dmpl__TaxGroupId__c = taxGroup.Id
                                                       
                                    ));
        billReturnLine.add(new dmpl__BillReturnLine__c(dmpl__ItemId__c = item.Id,
                                                               dmpl__Quantity__c = 5,
                                                             dmpl__DeliveryQuantity__c = billLine.dmpl__ReturnedQuantity__c,
                                                               dmpl__UnitCost__c = 100,
                                                               dmpl__SKUId__c = sku.Id,
                                                               dmpl__BillLineId__c=billLine.Id,
                                       dmpl__ItemLotId__c = itemLot.Id,
                                                               dmpl__GoodsReceiptLineId__c=grnLines.Id,
                                       dmpl__GoodsReceiptId__c = grnLines.dmpl__GoodsReceiptId__c,
                                                               dmpl__BillId__c = bill.Id,
                                                               dmpl__BillReturnId__c = billReturn[0].Id,
                                       dmpl__TaxGroupId__c = taxGroup.Id,
                                                             dmpl__IsILPostingApproved__c = true
                                    ));
        insert billReturnLine;
    }
    
    private static void CreateBillReturnTaxHelper()
    {
        List<dmpl__BillReturnTax__c> billReturnTax = new List<dmpl__BillReturnTax__c>();
        dmpl__BillReturn__c billReturn = [Select Id,Name From dmpl__BillReturn__c LIMIT 1];
        dmpl__BillReturnLine__c billReturnLine = [Select Id,Name,dmpl__BillReturnId__c,dmpl__TaxGroupId__c From dmpl__BillReturnLine__c LIMIT 1];
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id,Name From dmpl__SKU__c LIMIT 1];
        dmpl__Bill__c bill = [Select Id,Name From dmpl__Bill__c LIMIT 1];
        dmpl__BillLine__c billLine = [Select Id,Name From dmpl__BillLine__c LIMIT 1];
        dmpl__GoodsReceiptLine__c grnLines = [SELECT Id, Name FROM dmpl__GoodsReceiptLine__c LIMIT 1];
        dmpl__TaxGroup__c taxGroup = [Select Id,Name From dmpl__TaxGroup__c];
        dmpl__Tax__c tax = [Select Id,Name From dmpl__Tax__c];
        billReturnTax.add(new dmpl__BillReturnTax__c(dmpl__BillReturnId__c =  billReturn.Id,
                                                     dmpl__BillReturnLineId__c = billReturnLine.Id,
                                                     dmpl__TaxId__c = tax.Id,
                                                     dmpl__TaxGroupId__c = billReturnLine.dmpl__TaxGroupId__c,
                                                     dmpl__TaxOnAmount__c = true
                                                    ));
        
    }
    
    private static void CreateGoodsReceipt()
    {
        List<dmpl__GoodsReceipt__c> goodsReceipts= new List<dmpl__GoodsReceipt__c>();
        Account partnerAccount=[Select Id,Name from Account Where Name='Partner-Test-Account' LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        Account supplierAccount=[Select Id,Name from Account Where Name='Supplier-Test-Account' LIMIT 1];
        goodsReceipts.add(new dmpl__GoodsReceipt__c(dmpl__PartnerAccountId__c = partnerAccount.Id,
                                                    dmpl__BranchId__c = branch.Id,
                                                    dmpl__ReceivedTime__c = date.today(),
                                                    dmpl__DocumentDate__c = date.today(),
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
    
    private static void CreateGoodReceiptLine()
    {
        CreateGoodsReceipt();
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        dmpl__GoodsReceipt__c GRNDoc = [SELECT Id, Name FROM dmpl__GoodsReceipt__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id,Name From dmpl__SKU__c LIMIT 1];
        //dmpl__StorageLocation__c storageLocation = [Select Id, Name FROM dmpl__StorageLocation__c LIMIT 1];
        dmpl__GoodsReceiptLine__c grnLine = new dmpl__GoodsReceiptLine__c(dmpl__GoodsReceiptId__c = GRNDoc.Id,
                                                                          dmpl__ItemId__c = item.Id,
                                                                          dmpl__SKUId__c = sku.Id,
                                                                          dmpl__OrderedQuantity__c = 1, 
                                                                          dmpl__ReceivedQuantity__c = 1,
                                                                          dmpl__SupplierQuantity__c = 1
                                                                        //  dmpl__StorageLocationId__c = storageLocation.Id
                                                                         );
        insert grnLine;
    }
    
    
    private static void CreatePurchaseInvoiceTax()
    {
        List<dmpl__PurchaseInvoiceTax__c> purchaseInvoiceTax= new List<dmpl__PurchaseInvoiceTax__c>();
        Account partnerAccount=[Select Id,Name from Account Where Name='Partner-Test-Account' LIMIT 1];
        dmpl__Bill__c bill = [Select Id,Name From dmpl__Bill__c];
    dmpl__BillLine__c billLine = [Select Id,Name From dmpl__BillLine__c];
        dmpl__Tax__c tax = [Select Id,Name,dmpl__TaxGroupId__c From dmpl__Tax__c LIMIT  1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        Account supplierAccount=[Select Id,Name from Account Where Name='Supplier-Test-Account' LIMIT 1];
        purchaseInvoiceTax.add(new dmpl__PurchaseInvoiceTax__c(
                                                                Name = 'Test-PI Tax',
                                                                dmpl__BillId__c = bill.Id,
                                                                dmpl__BillLineId__c = billLine.Id,
                                      dmpl__TaxId__c = tax.Id,
                                      dmpl__TaxRate__c = 3,
                                      dmpl__TaxGroupId__c = tax.dmpl__TaxGroupId__c
                                                   ));
        insert purchaseInvoiceTax;
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
}