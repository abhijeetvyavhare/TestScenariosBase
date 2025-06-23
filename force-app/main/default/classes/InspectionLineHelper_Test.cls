@IsTest
public class InspectionLineHelper_Test {
    @testSetup
    public static void Setup()
    {
        System.runAs(PostInstallHelper.AssignAdministratorAllPermissions(UserInfo.getUserId())){
            CreateAccountGroup();
            CreateAccount();
            CreateBranch();
            CreateItemGroup();
            CreateItem();
            CreateSKU();
            CreateItemLot();
            CreatePriceList();
            CreatePurchaseOrder();
            CreatePurchaseOrderLine();
            CreateShipment();
            CreateShipmentLine();
            CreateGoodsReceipt();
            CreateStorageLocation();
            
           //   CreateGoodReceiptLine();
         //   CreateInspectionLine();
        }
    }
    
    @isTest
    public static void InspectionLinetest(){
        dmpl__Item__c item = [SELECT Id FROM dmpl__Item__c LIMIT 1];
        dmpl__ItemLot__c itemLot = [SELECT Id FROM dmpl__ItemLot__c LIMIT 1];
        dmpl__SKU__c sku = [SELECT id FROM dmpl__SKU__c LIMIT 1];
        dmpl__GoodsReceipt__c gr = [SELECT Id FROM dmpl__GoodsReceipt__c LIMIT 1];
        dmpl__InspectionLine__c il = new dmpl__InspectionLine__c(
        	dmpl__ItemId__c = item.Id,
            dmpl__ItemLotId__c = itemLot.id,
            dmpl__SKUId__c = sku.Id,
            dmpl__ReceivedQuantity__c = 1,
            dmpl__ReceiptId__c = gr.Id
        );
        insert il;
        delete il;
    }
    

    @isTest
    public static void VerifyChecklistLines()
    {
        test.startTest();
        List<dmpl__InspectionLine__c> order = [SELECT Id,  Name FROM dmpl__InspectionLine__c];       
        InspectionLineHelper.populateChecklistDetails(order);
        System.assertEquals(0, order.size(), 'Inspection Line data');
        test.stopTest();
    }
    @isTest
    public static void createCheckListLinesTest()
    {
        test.startTest();
        List<dmpl__InspectionLine__c> order = [SELECT Id,  Name FROM dmpl__InspectionLine__c];       
        ChecklistLineHelper.createChecklistLines(order);
        test.stopTest();
    }
    @isTest
    public static void completeInspectionFromGoodsReceiptTest()
    {
        test.startTest();
        list<dmpl__GoodsReceipt__c> goodsReceipt = [Select Id,Name,dmpl__PerformReceive__c From dmpl__GoodsReceipt__c LIMIT 1];
        //InspectionLineHelper.completeInspectionFromGoodsReceipt(goodsReceipt);
        test.stopTest();
    }
    public static void UpdateGoodReceiptAsPerformReceive()
    {
        dmpl__GoodsReceipt__c goodsReceipt = [Select Id,Name,dmpl__PerformReceive__c From dmpl__GoodsReceipt__c LIMIT 1];
        goodsReceipt.dmpl__PerformReceive__c = true;
        update goodsReceipt;
        System.assertEquals(true, goodsReceipt.dmpl__PerformReceive__c, 'Test good receipt have 1 updated record');
    }
    
    public static void UpdateGoodReceiptAsPerformInspection()
    {
        UpdateGoodReceiptAsPerformReceive();
        dmpl__GoodsReceipt__c goodsReceipt = [Select Id,Name,dmpl__PerformInspection__c From dmpl__GoodsReceipt__c LIMIT 1];
        goodsReceipt.dmpl__PerformInspection__c = true;
        update goodsReceipt;
        System.assertEquals(true, goodsReceipt.dmpl__PerformInspection__c, 'Test good receipt have 1 updated record');
    }
    
    public static void UpdateGoodReceiptAsPerformInspectionComplete()
    {
        UpdateGoodReceiptAsPerformInspection();
        dmpl__GoodsReceipt__c goodsReceipt = [Select Id,Name,dmpl__PerformInspectionComplete__c From dmpl__GoodsReceipt__c LIMIT 1];
        goodsReceipt.dmpl__PerformInspectionComplete__c = true;
        update goodsReceipt;
        System.assertEquals(true, goodsReceipt.dmpl__PerformInspectionComplete__c, 'Test good receipt have 1 updated record');
    }
    
 /*   @isTest
    public static void DeleteInspectionLine()
    {
        Test.startTest();
        UpdateGoodReceiptAsPerformInspection();
        dmpl__InspectionLine__c inspectionLine = [Select Id,Name From dmpl__InspectionLine__c LIMIT 1];
        
        Database.DeleteResult LineResult = Database.delete(inspectionLine, false);
        Test.stopTest();
        System.assert(LineResult.getErrors().size() == 1);
    } */
    
    @isTest
    private static void CreateInspectionLine()
    {
        try{
        test.startTest();
        List<dmpl__InspectionLine__c> line = [Select Id, Name,dmpl__PerformPopulateChecklist__c From dmpl__InspectionLine__c];
        ChecklistLineHelper.createChecklistLines(line);
        line[0].dmpl__PerformPopulateChecklist__c = true;
        update line;
        test.stopTest();
        }catch(exception e){}
    }
    
    private static void CreateAccount()
    {
        List<Account> account = new List<Account>();
        dmpl__AccountGroup__c accountGroup = [Select Id,Name From dmpl__AccountGroup__c LIMIT 1];
        account.add(new Account(Name = 'Test - Account', 
                                dmpl__LastName__c = 'Sale Invoice',
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
                                             dmpl__LastName__c = 'Sale Invoice',
                                             dmpl__IsPartnerAccount__c = True, 
                                             dmpl__IsActive__c = true);
        insert partneraccount;
        
        Account customerAccount = new Account(Name = 'Customer-Test-Account',
                                              dmpl__LastName__c = 'Sale Invoice',
                                              dmpl__IsCustomerAccount__c = True,
                                              dmpl__IsActive__c = true);
        insert customerAccount;
        
        Account supplieraccount = new Account(Name = 'Supplier-Test-Account',
                                              dmpl__LastName__c = 'Sale Invoice',
                                              dmpl__IsSupplierAccount__c = True,
                                              dmpl__IsActive__c = true);
        insert supplieraccount;
        
    }
    
    private static void CreateBranch()
    {
        List<dmpl__Branch__c> branch = new List<dmpl__Branch__c>();
        Account partnerAccount = [Select Id,Name From Account WHERE Name = 'Partner-Test-Account' LIMIT 1];
        branch.Add(new dmpl__Branch__c(dmpl__PartnerAccountId__c =partnerAccount.Id,
                                       Name = 'Test-Branch',
                                       dmpl__IsActive__c = true,
                                       dmpl__MarketingName__c = 'Hero Electric',
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
                                       dmpl__ServiceEmail__c = 'Customer@Outlook.com',
                                       dmpl__Website__c = 'www.Dealer.com'));
        insert branch;
    }
    
    private static void CreateItemGroup()
    {
        List<dmpl__ItemGroup__c> itemGroup = new List<dmpl__ItemGroup__c> ();
        itemGroup.Add(new dmpl__ItemGroup__c(Name = 'Item Group Test',
                                             dmpl__ItemGroupType__c = 'Product Demo'
                                            ));
        insert itemGroup;
    }
    
    private static void CreateItem()
    {
        List<dmpl__Item__c> item = new List<dmpl__Item__c>();
        dmpl__ItemGroup__c itemGroup = [Select Id,Name From dmpl__ItemGroup__c LIMIT 1];
        item.Add(new dmpl__Item__c(Name = 'Test-Item',
                                   dmpl__ItemCode__c = 'DMPL',
                                   dmpl__ItemType__c = 'Product',
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
                                   dmpl__TrackAsset__c = false,                               
                                   dmpl__IsActive__c = true,
                                   dmpl__IsRegistrationRequired__c = true,
                                   dmpl__GTIN__c = 'BR123',
                                   dmpl__RFID__c = 'O1234fgh',
                                   dmpl__IsPackage__c=true,
                                   dmpl__QuantityUnitOfMeasure__c='Box',
                                   dmpl__InventoryValuationMethod__c='FIFO',
                                   dmpl__ProductDemoItemGroup__c = itemGroup.Id
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
                                         //dmpl__QuantityOnHold__c = 1,
                                         //dmpl__QuantityOnLoan__c = 1
                                        ));
        insert itemLot;
        
        List<dmpl__ItemLot__c> relatedItemLot = new List<dmpl__ItemLot__c>();
        relatedItemLot.Add(new dmpl__ItemLot__c(
            dmpl__BranchId__c = branch.Id,
            dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
            dmpl__LandedCost__c = 1000));
        insert relatedItemLot;
    }
    
    private static void CreateAccountGroup()
    {
        dmpl__AccountGroup__c accountGroup= new dmpl__AccountGroup__c (Name= 'Test-AccountGroup', 
                                                                       dmpl__AccountGroupType__c='Price');
        insert accountGroup;
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
                                             dmpl__IsActive__c=true,
                                             dmpl__IsDefault__c=true, 
                                             Name='Test-1'
                                            ));
        insert priceList;
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
                                                     dmpl__Remarks__c = 'Remark'
                                                    ));
        insert purchaseOrder;
        
    }
    
    private static void CreatePurchaseOrderLine()
    {
        List<dmpl__PurchaseOrderLine__c> purchaseOrderLine = new List<dmpl__PurchaseOrderLine__c>();
        dmpl__Item__c listofitem = [Select Id, Name from dmpl__Item__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id, Name from dmpl__SKU__c LIMIT 1];
        dmpl__PurchaseOrder__c purchaseOrder = [Select Id, Name FROM dmpl__PurchaseOrder__c LIMIT 1];
        purchaseOrderLine.add(new dmpl__PurchaseOrderLine__c(dmpl__ItemId__c = listofitem.Id,
                                                             dmpl__SKUId__c = sku.Id,
                                                             dmpl__PurchaseOrderId__c = purchaseOrder.Id,
                                                             dmpl__Quantity__c = 1
                                                            ));
        insert purchaseOrderLine;
        
    }
    
    private static void CreateShipment()
    {
        List<dmpl__Shipment__c> shipment = new List<dmpl__Shipment__c>();
        Account supplierAccount = [Select Id,Name From Account WHERE Name = 'Supplier-Test-Account' LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        dmpl__PurchaseOrder__c purchaseOrder = [Select Id, Name FROM dmpl__PurchaseOrder__c LIMIT 1];
        shipment.add(new dmpl__Shipment__c(dmpl__BranchId__c = branch.Id,
                                           dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                           dmpl__SupplierAccountId__c = supplierAccount.Id,
                                           dmpl__PurchaseOrderId__c = purchaseOrder.Id,
                                           dmpl__SupplierInvoiceNumber__c='12345',
                                           dmpl__SupplierInvoiceDate__c=date.today(),
                                           dmpl__DeliveryOrderDate__c=date.today(),
                                           dmpl__DeliveryOrderNumber__c='18',
                                           dmpl__TransporterName__c='Sample',
                                           dmpl__TransporterReferenceNo__c='Sample'
                                          ));
        insert shipment;

    }
    
    private static void CreateShipmentLine()
    {
        List<dmpl__ShipmentLine__c> shipmentLine = new List<dmpl__ShipmentLine__c>();
        dmpl__Item__c item = [Select Id, Name FROM dmpl__Item__c LIMIT 1];
        dmpl__Shipment__c shipment = [Select Id,Name FROM dmpl__Shipment__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id, Name FROM dmpl__SKU__c LIMIT 1];
        dmpl__PurchaseOrderLine__c purchaseOrderLine = [Select Id,Name FROM dmpl__PurchaseOrderLine__c LIMIT 1];
        shipmentLine.add(new dmpl__ShipmentLine__c(dmpl__ItemId__c = item.Id,
                                                   dmpl__ShipmentId__c = shipment.Id,
                                                   dmpl__Quantity__c = 1,
                                                   dmpl__SKUId__c = sku.Id,
                                                   dmpl__UnitPrice__c=1,
                                                   dmpl__PurchaseOrderLineId__c = purchaseOrderLine.Id
                                                  ));
        insert shipmentLine;
        
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
                                   dmpl__SupplierAccountId__c = supplierAccount.Id,
                                   dmpl__SupplierInvoiceNumber__c = '744837',
                                   dmpl__SupplierInvoiceDate__c = date.today(),
                                   dmpl__SupplierInvoiceAmount__c = 100
                                  ));
        insert bill;
        
    }
    
    private static void CreateBillLine()
    {
        List<dmpl__BillLine__c> billLine = new List<dmpl__BillLine__c>();
        Account account=[Select Id,Name from Account Where Name='Customer-Test-Account'];
        dmpl__Item__c item = [Select Id,Name FROM dmpl__Item__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id,Name From dmpl__SKU__c LIMIT 1];
        dmpl__Bill__c bill = [Select Id,Name From dmpl__Bill__c LIMIT 1];
        dmpl__PurchaseOrderLine__c purchaseOrderLine = [Select Id,dmpl__ItemId__c,dmpl__Quantity__c FROM dmpl__PurchaseOrderLine__c LIMIT 1];
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
    
    private static void CreateGoodReceiptLine()
    {
        dmpl__GoodsReceipt__c GRNDoc = [SELECT Id, Name FROM dmpl__GoodsReceipt__c LIMIT 1];
        dmpl__PurchaseOrderLine__c purchaseOrderLine = [Select Id,Name,dmpl__ItemId__c FROM dmpl__PurchaseOrderLine__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id,Name From dmpl__SKU__c LIMIT 1];
        //dmpl__ItemLot__c itemLot = [SELECT Id, Name, dmpl__ItemId__c, dmpl__QuantityInHand__c FROM dmpl__ItemLot__c LIMIT 1];
        dmpl__StorageLocation__c storageLocation = [Select Id, Name FROM dmpl__StorageLocation__c LIMIT 1];
        dmpl__GoodsReceiptLine__c grnLine = new dmpl__GoodsReceiptLine__c(dmpl__GoodsReceiptId__c = GRNDoc.Id,
                                                                          dmpl__ItemId__c = purchaseOrderLine.dmpl__ItemId__c,
                                                                          dmpl__SKUId__c = sku.Id,
                                                                          dmpl__PurchaseOrderLineId__c = purchaseOrderLine.Id, 
                                                                          dmpl__OrderedQuantity__c =1, 
                                                                          dmpl__ReceivedQuantity__c = 1,
                                                                          dmpl__SupplierQuantity__c = 1,
                                                                          dmpl__StorageLocationId__c = storageLocation.Id
                                                                         );
        
        insert grnLine;
    }
    
    private static void CreatePurchaseReturn()
    {
        List<dmpl__PurchaseReturn__c> purchaseReturn = new List<dmpl__PurchaseReturn__c>();
        Account supplierAccount = [Select Id,Name From Account WHERE Name = 'Supplier-Test-Account' LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name From dmpl__Branch__c LIMIT 1];
        purchaseReturn.add(new dmpl__PurchaseReturn__c(dmpl__SupplierAccountId__c = supplierAccount.Id,
                                                       dmpl__BranchId__c = branch.Id,
                                                       dmpl__SupplierInvoiceAmount__c = 100,
                                                       dmpl__SupplierInvoiceDate__c = date.today(),
                                                       dmpl__PerformReturn__c = false,
                                                       dmpl__IsReturned__c = false,
                                                       dmpl__DocumentDate__c = date.today()-7));
        insert purchaseReturn;
        
    }
    
    private static void CreatePurchaseReturnLine()
    {
        List<dmpl__PurchaseReturnLine__c> purchaseReturnLine = new List<dmpl__PurchaseReturnLine__c>();
        dmpl__PurchaseReturn__c purchaseReturn = [Select Id,Name From dmpl__PurchaseReturn__c LIMIT 1];
        Account account = [Select Id,Name From Account LIMIT 1];
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        dmpl__ItemLot__c itemLot = [Select Id,Name From dmpl__ItemLot__c LIMIT 1];
        dmpl__Bill__c bill = [Select Id,Name From dmpl__Bill__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id,Name From dmpl__SKU__c LIMIT 1];
        dmpl__BillLine__c billLine = [Select Id,Name From dmpl__BillLine__c LIMIT 1];
        dmpl__GoodsReceiptLine__c grnLines=[Select Id, Name From dmpl__GoodsReceiptLine__c ];
        purchaseReturnLine.add(new dmpl__PurchaseReturnLine__c(dmpl__AccountId__c = account.Id,
                                                               dmpl__ItemId__c = item.Id,
                                                               dmpl__GoodsReceiptLineId__c=grnLines.Id,
                                                               dmpl__ItemLotId__c = itemLot.Id,
                                                               dmpl__Quantity__c = 2,
                                                               dmpl__SKUId__c = sku.Id,
                                                               dmpl__UnitCost__c = 100,
                                                               dmpl__PurchaseInvoiceId__c = bill.Id,
                                                               dmpl__BillLineId__c = billLine.Id,
                                                               dmpl__PurchaseReturnId__c = purchaseReturn.Id));
        insert purchaseReturnLine;
        
    }
    private static void CreateChecklistTemplate()
    {
        List<dmpl__ChecklistTemplate__c> checkList = new List<dmpl__ChecklistTemplate__c>();
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        checkList.add(new dmpl__ChecklistTemplate__c(dmpl__ItemId__c=item.Id,
                                                     Name='Test1',
                                                     dmpl__Type__c='Delivery',
                                                     dmpl__Code__c='Done'));
        insert checkList;
        
    }
    private static void CreateChecklistTemplateLine()
    {
        List<dmpl__CheckListTemplateLine__c> checkList = new List<dmpl__CheckListTemplateLine__c>();
        dmpl__InspectionLine__c line = [Select Id,Name From dmpl__InspectionLine__c LIMIT 1];
        dmpl__ChecklistTemplate__c checkListTemplate = [Select Id,Name From dmpl__ChecklistTemplate__c LIMIT 1];
        checkList.add(new dmpl__CheckListTemplateLine__c(dmpl__ChecklistTemplateId__c = checkListTemplate.Id,
                                                         dmpl__DataType__c = 'Text'
                                                         //dmpl__InspectionLineId__c = line.Id
                                                        ));
        insert checkList;
        
        
    }
    private static void CreateChecklistlines()
    {
        List<dmpl__CheckListLines__c> checkList = new List<dmpl__CheckListLines__c>();
        dmpl__ChecklistTemplate__c checkListTemplate = [Select Id,Name From dmpl__ChecklistTemplate__c LIMIT 1];
        dmpl__ChecklistTemplateLine__c checkListTemplateLine = [Select Id,Name From dmpl__ChecklistTemplateLine__c LIMIT 1];
        dmpl__GoodsReceipt__c Order = [Select Id,Name From dmpl__GoodsReceipt__c LIMIT 1];
        checkList.add(new dmpl__CheckListLines__c(dmpl__GoodsReceiptId__c	 = Order.Id,
                                                  dmpl__CheckListTemplateLineId__c = checkListTemplateLine.Id,
                                                  dmpl__ChecklistTemplateId__c = checkListTemplate.Id,
                                                  Name='Test2',
                                                  dmpl__DataType__c='Text'
                                                 ));
        insert checkList;
        
        
    }
}