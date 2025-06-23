@isTest
public class PurchaseReturnHelper_Test {
    
    @testSetup
    public static void Setup()
    {
        System.runAs(PostInstallHelper.AssignAdministratorAllPermissions(UserInfo.getUserId())){
            CreateAccountGroup();
            CreateAccount();
            CreateBranch();
            CreateStorageLocation();
            CreateItems();
            CreateSKu();
            CreateResource();
            CreateTaxGroup();
            CreatePurchaseReturn();
            CreateBill();
            CreateBillLine();
            test.startTest();
            CreateGoodReceiptLine();
            test.stopTest();
            CreatePurchaseReturnLine();  
        }
    }
    
    @isTest
    Public static void createPurchaseReturnFromPurchaseInvoice()
    {
        Test.startTest();
        
        string errorReceived;
        try{  
            List<SourceObjectInfo> info = new List <SourceObjectInfo>();
            List<dmpl__PurchaseReturn__c> sOrder=[Select Id, Name From dmpl__PurchaseReturn__c Limit 1 ];
            SourceObjectInfo sourceObject = new SourceObjectInfo('dmpl__PurchaseReturn__c', sOrder[0].Id, 10, '');
            info.add(sourceObject);
            PurchaseReturnHelper.createPurchaseReturnFromPurchaseInvoice(info,sOrder[0].Id);
        } catch (Exception ex) {
            errorReceived = ex.getMessage();
        }
        System.assertNotEquals(null, errorReceived);
        
        Test.stopTest();
    }
    
    @isTest
    Public static void createReturnLineFromPurchaseInvoiceLine()
    {
        Test.startTest();
        string errorReceived;
        try{             
            List<SourceObjectInfo> info = new List <SourceObjectInfo>();
            BillLine__c sOrder=[Select Id, Name,
                                dmpl__ItemId__c,
                                dmpl__SKUId__c ,
                                dmpl__GeneralLedgerId__c,
                                dmpl__GLAccountId__c ,
                                dmpl__InventoryLedgerId__c ,
                                dmpl__ItemLotId__c,
                                dmpl__PurchaseOrderLineId__c,
                                dmpl__StorageLocationId__c ,
                                dmpl__TaxGroupId__c,
                                dmpl__UnitCost__c,
                                dmpl__PurchaseInvoiceId__c ,
                                dmpl__GoodsReceiptLineId__c ,
                                dmpl__EligibleReturnQuantity__c
                                From BillLine__c Limit 1 ];
            PurchaseReturnHelper.createReturnLineFromPurchaseInvoiceLine(sOrder,info);    
        } catch (Exception ex) {
            errorReceived = ex.getMessage();
        }
        System.assertEquals(null, errorReceived);
        Test.stopTest();
    }
    
    @isTest 
    public static void VerifyReturn()
    {
        test.startTest();
        string errorReceived;
        string expectedErrorCode = 'SOPOS001';
        try{
            List<dmpl__PurchaseReturn__c> purchaseReturn = [SELECT Id, Name,(Select Id, Name,dmpl__GoodsReceiptLineId__c,
                                                                             dmpl__Quantity__c,
                                                                             dmpl__PurchaseReturnId__c,
                                                                             dmpl__BillLineId__c,
                                                                             dmpl__PurchaseInvoiceId__c
                                                                             From
                                                                             PurchaseReturnLine__r
                                                                            ) 
                                                            FROM dmpl__PurchaseReturn__c];
            
        }
        catch(Exception ex){
            errorReceived = ex.getMessage();
        }
        test.stopTest();
        System.assertNotEquals(expectedErrorCode,errorReceived);
        
    }
    
    @isTest
    public static void Verifynew()
    {
        try{
            test.startTest();
            List<dmpl__PurchaseReturn__c> purchaseReturn = [SELECT Id, Name,(Select Id, Name,dmpl__GoodsReceiptLineId__c,
                                                                             dmpl__Quantity__c,
                                                                             dmpl__PurchaseReturnId__c,
                                                                             dmpl__BillLineId__c,
                                                                             dmpl__PurchaseInvoiceId__c
                                                                             From
                                                                             PurchaseReturnLine__r
                                                                            ) 
                                                            FROM dmpl__PurchaseReturn__c];
            System.assert(purchaseReturn != null, 'purchase return data');
            test.stopTest();}
        catch(Exception e){}
    }
    
    public static void VerifyPurchaseReturnLine()
    {
        test.startTest();
        List<dmpl__PurchaseReturn__c> purchaseReturn = [SELECT Id, Name FROM dmpl__PurchaseReturn__c];
        PurchaseReturnLineHelper.approvePurchaseReturnLines(purchaseReturn);
        System.assert(purchaseReturn != null, 'purchase return data');
        test.stopTest();
    }
    
   
    
    @isTest 
    public static void UpdatePurchaseReturn()
    {
        test.startTest();
        string errorReceived;
        string expectedErrorCode = 'SOPOS001';
        try{
            dmpl__PurchaseReturn__c purchaseReturn = [Select Id,Name,dmpl__PerformReturn__c From dmpl__PurchaseReturn__c LIMIT 1];
            purchaseReturn.dmpl__PerformReturn__c = True;
            
            update purchaseReturn;        }
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
        string errorReceived;
        string expectedErrorCode = 'SOPOS001';
        try{
            dmpl__PurchaseReturn__c purchaseReturn = [Select Id,Name,dmpl__PerformInventoryPosting__c From dmpl__PurchaseReturn__c LIMIT 1];
            purchaseReturn.dmpl__PerformInventoryPosting__c = True;
            
            update purchaseReturn;
            System.assertEquals(True, purchaseReturn.dmpl__PerformInventoryPosting__c, 'Sale Return has 1 Record Updated');
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
        	Test.startTest();
            try {
                dmpl__PurchaseReturn__c purchaseReturn = [
                    SELECT Id, Name, dmpl__PerformGLPosting__c 
                    FROM dmpl__PurchaseReturn__c 
                    LIMIT 1
                ];
                
                purchaseReturn.dmpl__PerformGLPosting__c = true;
                //update purchaseReturn;
            } catch (QueryException qe) {
                System.debug(qe.getMessage());
                
            }
		Test.stopTest();

        //System.assertEquals(True, purchaseReturn.dmpl__PerformGLPosting__c, 'Sale Return has 1 Record Updated');
    }
    
    @isTest
    public static void PerformInventoryPosting1()
    {
        try{
        test.startTest();
        dmpl__PurchaseReturn__c purchaseReturn = [Select Id,Name,dmpl__PerformInventoryPosting__c From dmpl__PurchaseReturn__c LIMIT 1];
        purchaseReturn.dmpl__PerformInventoryPosting__c = false;
        purchaseReturn.dmpl__PerformInventoryPosting__c = true;
        update purchaseReturn;
        test.stopTest();
        System.assertEquals(True, purchaseReturn.dmpl__PerformInventoryPosting__c, 'Sale Return has 1 Record Updated');
        }catch(exception e){}
    }
    
    @isTest
    public static void DeleteSaleReturn()
    {
        test.startTest();
        dmpl__PurchaseReturn__c purchaseReturn = [Select Id,Name,dmpl__PerformReturn__c From dmpl__PurchaseReturn__c LIMIT 1];
        
        Delete purchaseReturn;
        test.stopTest();
        System.assertEquals(false, purchaseReturn.dmpl__PerformReturn__c, 'Sale Return has 1 Record Deleted');
    }
    
    @isTest
    public static void CreateDeliveryOrderFromShipmentId()
    {
        Test.startTest();
        string errorReceived;
        try{             
            dmpl__PurchaseReturn__c line2 = [SELECT Id, Name,dmpl__BranchId__c FROM dmpl__PurchaseReturn__c Limit 1];
            SaleDeliveryHelper.createSaleDeliveryFromPurchaseReturn(line2.Id);    
        } catch (Exception ex) {
            errorReceived = ex.getMessage();
        }
        //System.assertEquals(null, errorReceived);
        Test.stopTest();
    }  
    
    @isTest
    public static void UpdatePurchaseReturnLine()
    {
        try{
        List<Id> purchaseReturnIds = new List<Id>();
        dmpl__PurchaseReturnLine__c purchaseReturnLine = [Select Id,Name,dmpl__Quantity__c From dmpl__PurchaseReturnLine__c LIMIT 1];
            
        test.startTest();
        
        purchaseReturnLine.dmpl__Quantity__c = 0;
        
        update purchaseReturnLine;
        BillLineHelper.queryPurchaseReturnLines(purchaseReturnIds);
        GoodReceiptLineHelper.queryPurchaseReturnLines(purchaseReturnIds);
            
        test.stopTest();
        System.assertEquals(0, purchaseReturnLine.dmpl__Quantity__c, 'Sale Return has 1 Record Updated');
        }
        catch(exception e){}
    }
    
    @isTest
    public static void DeletePurchaseReturnLine()
    {
        string errorReceived;
        string expectedErrorCode = 'SOPOS001';
        try{
            //UpdatePurchaseReturnLine();
            dmpl__PurchaseReturnLine__c purchaseReturnLine = [Select Id,Name,dmpl__Quantity__c From dmpl__PurchaseReturnLine__c LIMIT 1];
            purchaseReturnLine.dmpl__Quantity__c = 0;
            
            test.startTest();
            
            update purchaseReturnLine;
            Delete purchaseReturnLine;
            
            test.stopTest();
          
            System.assertEquals(0, purchaseReturnLine.dmpl__Quantity__c, 'Purchase Return Line has 1 Record Deleted');
        }
        catch(Exception ex){
            errorReceived = ex.getMessage();
        }
        
        System.assertNotEquals(expectedErrorCode,errorReceived);
    }
    
    @isTest
    private static void VerifyCreateSaleDeiveryFromPurchaseReturnLines()
    {
        test.startTest();
       List<dmpl__PurchaseReturnLine__c> purchaseReturnLines = [SELECT Id, Name FROM dmpl__PurchaseReturnLine__c];
	   List<SourceObjectInfo> objList = new List<SourceObjectInfo>();

            try {
                if (!purchaseReturnLines.isEmpty()) {
                    SourceObjectInfo obj = new SourceObjectInfo('dmpl__PurchaseReturnLine__c', purchaseReturnLines[0].Id, 1, null);
                    objList.add(obj);
                    SaleDeliveryHelper.createSaleDeliveryFromPurchaseReturn(objList);
                } else {
                    System.debug('No dmpl__PurchaseReturnLine__c records found.');
                }
            } catch (Exception e) {
                System.debug('Error in createSaleDeliveryFromPurchaseReturn: ' + e.getMessage());
               
            }

        test.stopTest();
    }
    
     private static void CreateCreditNote()
    {
        dmpl__CreditNote__c creditNote= new dmpl__CreditNote__c ( 
                                              dmpl__DocumentDate__c=date.today());
        insert creditNote;
         dmpl__DebitNote__c debitNote= new dmpl__DebitNote__c ( 
                                              dmpl__DocumentDate__c=date.today());
        insert debitNote;
    }
    private static void CreateAccountGroup()
    {
        dmpl__AccountGroup__c accountGroup= new dmpl__AccountGroup__c (Name= 'Test-AccountGroup', 
                                                                       dmpl__AccountGroupType__c='Scheme');
        insert accountGroup;
    }
    
    private static void CreateAccount()
    {
       /* List<Account> account = new List<Account>();
        dmpl__AccountGroup__c accountGroup = [Select Id,Name From dmpl__AccountGroup__c LIMIT 1];
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
        
    }
    
    private static void CreateItemLot()
    {
        List<dmpl__ItemLot__c> itemLot = new List<dmpl__ItemLot__c>();
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        dmpl__StorageLocation__c storageLocation = [Select Id, Name FROM dmpl__StorageLocation__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id ,Name From dmpl__SKU__c LIMIT 1 ];
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        itemLot.Add(new dmpl__ItemLot__c(dmpl__BranchId__c = branch.Id,
                                         dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                         dmpl__ItemId__c = item.Id,
                                         dmpl__StorageLocationId__c = storageLocation.Id,
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
                                           dmpl__IsActive__c = false
                                          ));
        insert taxGroup;
        
    }
    
    private static void CreatePriceList()
    {
        List<dmpl__PriceList__c> priceList =new List<dmpl__PriceList__c>();
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        Account account=[Select Id,Name from Account Where Name='Partner-Test-Account'];
        dmpl__AccountGroup__c accountGroup=[Select Id,Name From dmpl__AccountGroup__c];
        priceList.Add(new dmpl__PriceList__c(dmpl__PartnerAccountId__c = account.Id,
                                             dmpl__BranchId__c = Branch.Id,
                                             dmpl__PartnerAccountGroupId__c= accountGroup.Id,
                                             dmpl__PartnerGroupId__c=accountGroup.Id,
                                             dmpl__CustomerAccountGroupId__c=accountGroup.Id,
                                             dmpl__CustomerGroupId__c=accountGroup.Id,
                                             Name='Test - Price List',
                                             dmpl__PriceListType__c = 'Sale Price',
                                             dmpl__IsActive__c = true,
                                             dmpl__IsDefault__c = true
                                            ));
        insert priceList;
        
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
        
    }
    
    private static void CreatePurchaseRequisitionLine()
    {
        List<dmpl__PurchaseRequisitionLine__c> purchaseRequisitionLine = new List<dmpl__PurchaseRequisitionLine__c>();
        dmpl__Item__c item = [Select Id, Name from dmpl__Item__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id,Name From dmpl__SKU__c LIMIT 1];
        dmpl__PurchaseRequisition__c purchaseRequisition = [Select Id, Name FROM dmpl__PurchaseRequisition__c LIMIT 1];
        purchaseRequisitionLine.add(new dmpl__PurchaseRequisitionLine__c(dmpl__PurchaseRequisitionId__c = purchaseRequisition.Id,
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
        
    }
    
    private static void CreatePurchaseOrderLine()   
    {
        List<dmpl__PurchaseOrderLine__c> purchaseOrderLine = new List<dmpl__PurchaseOrderLine__c>();
        dmpl__Item__c listofitem = [Select Id, Name from dmpl__Item__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id,Name From dmpl__SKU__c LIMIT 1];
        dmpl__PurchaseOrder__c purchaseOrder = [Select Id, Name FROM dmpl__PurchaseOrder__c LIMIT 1];
        dmpl__TaxGroup__c taxGroup = [Select Id,Name From dmpl__TaxGroup__c LIMIT 1];
        purchaseOrderLine.add(new dmpl__PurchaseOrderLine__c(dmpl__ItemId__c = listofitem.Id,
                                                             dmpl__SKUId__c = sku.Id,
                                                             dmpl__PurchaseOrderId__c = purchaseOrder.Id,
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
        
    }
    
    private static void CreateBillLine()
    {
        List<dmpl__BillLine__c> billLine = new List<dmpl__BillLine__c>();
        Account account=[Select Id,Name from Account Where Name='Customer-Test-Account' LIMIT 1];
        dmpl__Item__c item = [Select Id,Name FROM dmpl__Item__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id,Name From dmpl__SKU__c LIMIT 1];
        dmpl__Bill__c bill = [Select Id,Name From dmpl__Bill__c LIMIT 1];
        dmpl__PurchaseReturn__c po=[SELECT Id FROM dmpl__PurchaseReturn__c limit 1];
        billLine.add(new dmpl__BillLine__c(dmpl__ItemId__c = item.Id,
                                           dmpl__SKUId__c = sku.Id,
                                           dmpl__AccountId__c = account.Id,
                                           dmpl__Quantity__c = 5,
                                           dmpl__UnitCost__c = 100,
                                           dmpl__ReturnedQuantity__c = 4,
                                           dmpl__IsCustomerBillable__c = true,
                                           dmpl__PurchaseInvoiceId__c = bill.Id
                                          ));

        insert billLine;
        
    }
    
    private static void CreatePurchaseReturn()
    {
        List<dmpl__PurchaseReturn__c> purchaseReturn = new List<dmpl__PurchaseReturn__c>();
        Account supplierAccount = [Select Id,Name From Account WHERE Name = 'Supplier-Test-Account' LIMIT 1];
        Account partnerAccount = [Select Id,Name From Account WHERE Name = 'Partner-Test-Account' LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name From dmpl__Branch__c LIMIT 1];
        purchaseReturn.add(new dmpl__PurchaseReturn__c(dmpl__SupplierAccountId__c = supplierAccount.Id,
                                                       dmpl__BranchId__c = branch.Id,
                                                       dmpl__PartnerAccountId__c = partnerAccount.Id,
                                                       dmpl__SupplierInvoiceDate__c = date.today(),
                                                       dmpl__PerformReturn__c = false,
                                                       dmpl__IsReturned__c = false,
                                                       dmpl__PerformInventoryPosting__c=false,
                                                       dmpl__DocumentDate__c = date.today()));
        insert purchaseReturn;
        
    }
    
    private static void CreatePurchaseReturnLine()
    {
        CreatePurchaseReturn();
        List<dmpl__PurchaseReturnLine__c> purchaseReturnLine = new List<dmpl__PurchaseReturnLine__c>();
        dmpl__PurchaseReturn__c purchaseReturn = [Select Id,Name From dmpl__PurchaseReturn__c LIMIT 1];
        Account account = [Select Id,Name From Account WHERE Name = 'Customer-Test-Account' LIMIT 1];
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id,Name From dmpl__SKU__c LIMIT 1];
        dmpl__Bill__c bill = [Select Id,Name From dmpl__Bill__c LIMIT 1];
        dmpl__BillLine__c billLine = [Select Id,Name From dmpl__BillLine__c LIMIT 1];
        dmpl__GoodsReceiptLine__c grnLines = [SELECT Id, Name FROM dmpl__GoodsReceiptLine__c LIMIT 1];
        purchaseReturnLine.add(new dmpl__PurchaseReturnLine__c(dmpl__AccountId__c = account.Id,
                                                               dmpl__ItemId__c = item.Id,
                                                               dmpl__Quantity__c = 2,
                                                               dmpl__UnitCost__c = 100,
                                                               dmpl__SKUId__c = sku.Id,
                                                               dmpl__BillLineId__c=billLine.Id,
                                                               dmpl__GoodsReceiptLineId__c=grnLines.Id,
                                                               dmpl__PurchaseInvoiceId__c = bill.Id,
                                                               dmpl__PurchaseReturnId__c = purchaseReturn.Id));
        insert purchaseReturnLine;
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
        dmpl__StorageLocation__c storageLocation = [Select Id, Name FROM dmpl__StorageLocation__c LIMIT 1];
        dmpl__GoodsReceiptLine__c grnLine = new dmpl__GoodsReceiptLine__c(dmpl__GoodsReceiptId__c = GRNDoc.Id,
                                                                          dmpl__ItemId__c = item.Id,
                                                                          dmpl__SKUId__c = sku.Id,
                                                                          dmpl__OrderedQuantity__c =1, 
                                                                          dmpl__ReceivedQuantity__c = 1,
                                                                          dmpl__SupplierQuantity__c = 1,
                                                                          dmpl__StorageLocationId__c = storageLocation.Id
                                                                         );
        insert grnLine;
    }
}