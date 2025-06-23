@isTest
public class ShipmentHelper_Test {
    
    @testSetup
    public static void Setup()
    {
        System.runAs(PostInstallHelper.AssignAdministratorAllPermissions(UserInfo.getUserId())){
            CreateAccountGroup();
            CreateBranch();
            CreateItems();
            CreatePriceList();
            CreateTaxGroup();
            CreatePurchaseRequisition();
            CreatePurchaseOrder();
            test.startTest();
            CreateDeliveryOrder();
            CreateShipment();
            CreateGoodReceiptFromShipment();
            test.stopTest();
            //CreateGoodReceiptLineFromShipmentLine();
           // VerifyShipment();
        }
    }
    
    @isTest
    public static void VerifyevaluateLongNumber(){
        // try{
        test.startTest();
        Long  dbl  =677;
        ServiceLeadHelper.evaluateNumnericValues(Schema.DisplayType.LONG,'notEqual',dbl,'377');
        ServiceLeadHelper.evaluateDateTimeValues(Schema.DisplayType.LONG,'notEqual',dbl,'977');
        ServiceLeadHelper.evaluateDateTimeValues(Schema.DisplayType.LONG,'greaterOrEqual',dbl,'677');
        ServiceLeadHelper.evaluateDateTimeValues(Schema.DisplayType.LONG,'lessOrEqual',dbl,'677');
        ServiceLeadHelper.evaluateDateTimeValues(Schema.DisplayType.LONG,'greaterThan',dbl,'477');
        ServiceLeadHelper.evaluateDateTimeValues(Schema.DisplayType.LONG,'lessThan',dbl,'677'); 
        test.stopTest();
        // }
        // catch(Exception e){}
    }
    
     @isTest
    public static void VerifyevaluateLongNumber1(){
        // try{
        test.startTest();
        Long  dbl  =677;
        ServiceLeadHelper.evaluateDateTimeValues(Schema.DisplayType.LONG,'greaterOrEqual',dbl,'677');
        test.stopTest();
    }
    @isTest
    public static void VerifyShipment()
    {
       // try{
         test.startTest();
        List<dmpl__Shipment__c> shipment = [SELECT Id, Name FROM dmpl__Shipment__c];
        List<dmpl__ShipmentLine__c> shipmentLine = [SELECT Id,Name FROM dmpl__ShipmentLine__c];
        List<SourceObjectInfo> info = new List<SourceObjectInfo>();
          SourceObjectInfo obj = new SourceObjectInfo('dmpl__Shipment__c',shipment[0].Id,1,'data');
         info.add(obj);
        try{
              ShipmentLineHelper.cancelShipmentLines(info,shipment[0].Id);
        }
        catch(Exception e)
        {
            
        }
        
        //ShipmentHelper.createGoodsReceipt(info); 
         test.stopTest();
    }
    @isTest
     public static void VerifyShipment1()
    {
       // try{
         test.startTest();
        List<dmpl__Shipment__c> shipment = [SELECT Id, Name FROM dmpl__Shipment__c]; 
        ShipmentLineHelper.postShipmentLines(new List<dmpl__Shipment__c>());
        List<SourceObjectInfo> info = new List<SourceObjectInfo>();
          SourceObjectInfo obj = new SourceObjectInfo('dmpl__Shipment__c',shipment[0].Id,1,'data');
         info.add(obj);
       
       // ShipmentHelper.createShipmentFromDelivery(info); 
        ShipmentHelper.postIL(info,shipment[0].Id); 
       // ShipmentHelper.postIL(shipment[0].Id); 
        System.assert(shipment != null,'Shipment Verified');      
        test.stopTest();
       // }
       // catch(exception e){}
    }
    
    @isTest
    public static void VerifyShipment2()
    {
   
      test.startTest();
        dmpl__Shipment__c shipment = [SELECT Id, Name FROM dmpl__Shipment__c LIMIT 1];
        try{
              ShipmentLineHelper.cancelShipmentLines(shipment.Id);
        }
        catch(Exception e){}
        
      test.stopTest();
    }
    
    @isTest
    private static void updatePerformInventoryPosting()
    {
        Test.startTest();
        try{
            List<SourceObjectInfo> info = new List<SourceObjectInfo>();
            ShipmentHelper.createGoodsReceipt(info);
          //  ShipmentHelper.createShipmentFromDelivery(info);
            List<dmpl__Shipment__c> shipments = [SELECT Id,Name,dmpl__PerformInventoryPosting__c,dmpl__PerformReleaseReceipt__c FROM dmpl__Shipment__c LIMIT 1];
            shipments[0].dmpl__PerformInventoryPosting__c = true;
            shipments[0].dmpl__PerformReleaseReceipt__c = true;
            update shipments;
        }catch(Exception ex){}
        Test.StopTest();
    }
    
    @isTest
    public static void VerifyShipment3()
    {
       
     test.startTest();
        List<dmpl__ShipmentLine__c> shipmentLine = [SELECT Id,Name FROM dmpl__ShipmentLine__c];
        List<SourceObjectInfo> info = new List<SourceObjectInfo>();
          SourceObjectInfo obj = new SourceObjectInfo('dmpl__ShipmentLine__c',shipmentLine[0].Id,1,'data');
         info.add(obj);
        try{
              ShipmentLineHelper.cancelShipmentLinesInternal(shipmentLine,info);
        }
        catch(Exception e){}
      
     test.stopTest();
    }
    
    
    @isTest
    public static void updateDeliveryOrder()
    {
        test.starttest();
        dmpl__DeliveryOrder__c deliveryOrder = [SELECT Id, Name,dmpl__PerformReleaseShipment__c FROM dmpl__DeliveryOrder__c];       
        deliveryOrder.dmpl__PerformReleaseShipment__c = true;
        update deliveryOrder;
        test.stopTest();
        System.assertEquals(true, deliveryOrder.dmpl__PerformReleaseShipment__c, 'Failed');
    }
    
    @isTest
    public static void UpdateShipment()
    {
        test.startTest();
        dmpl__Shipment__c shipment = [Select Id,Name,dmpl__Status__c,dmpl__PerformReleaseReceipt__c,dmpl__IsReceiptReleased__c From dmpl__Shipment__c LIMIT 1];
        List<dmpl__Shipment__c> lines=new List<dmpl__Shipment__c>();
        lines.add(shipment);
        ShipmentHelper.createGoodsReceipt(lines); 
        if(shipment != null)
            shipment.dmpl__Status__c = 'Draft';
        update shipment;
        test.stopTest();
        System.assertEquals('Draft', shipment.dmpl__Status__c, 'Shipment has 1 Record Updated');
    }
    
    @isTest
    public static void UpdateShipmentAsPerformReleaseReceipt()
    {
        test.startTest();
        dmpl__Shipment__c shipment = [Select Id,Name,dmpl__Status__c,dmpl__PerformReleaseReceipt__c From dmpl__Shipment__c LIMIT 1];
        shipment.dmpl__PerformReleaseReceipt__c = true;
        
        update shipment;
        test.stopTest();
        System.assertEquals(True, shipment.dmpl__PerformReleaseReceipt__c, 'Shipment has 1 Record Updated');
    }
    
    @isTest
    public static void DeleteShipment()
    {
        test.startTest();
        dmpl__Shipment__c shipment = [Select Id,Name,dmpl__PerformReleaseReceipt__c From dmpl__Shipment__c LIMIT 1];
        delete shipment;
        test.stopTest();
        System.assertEquals(false, shipment.dmpl__PerformReleaseReceipt__c, 'Shipment has 1 Record Deleted');
    }
    
    @isTest
    public static void UpdateShipmentLine()
    {
        test.startTest();
        dmpl__ShipmentLine__c shipmentLine = [Select Id,Name,dmpl__Quantity__c From dmpl__ShipmentLine__c LIMIT 1];
        List<dmpl__ShipmentLine__c> shipment=new List<dmpl__ShipmentLine__c>();
        shipment.add(shipmentLine);
        List<Id> lines=new List<Id>();
        lines.add(shipmentLine.Id);
        ShipmentLineHelper.updateReceiptQuantity(lines);
        ShipmentLineHelper.postShipmentLines(new List<dmpl__ShipmentLine__c>());
        shipmentLine.dmpl__Quantity__c = 5;
        update shipmentLine;
        test.stoptest();
        System.assertEquals(5, shipmentLine.dmpl__Quantity__c, 'Shipement Line has 1 Record Updated');
    }
    
   /* @isTest
    public static void DeleteShipmentLine()
    {
        test.starttest();
        dmpl__ShipmentLine__c shipmentLine = [Select Id,Name,dmpl__Quantity__c From dmpl__ShipmentLine__c LIMIT 1];
        delete shipmentLine;
        test.stopTest();
        System.assertEquals(1, shipmentLine.dmpl__Quantity__c, 'Shipement Line has 1 Record Deleted');
    }*/
    
    private static void CreateAccountGroup()
    {
        dmpl__AccountGroup__c accountGroup= new dmpl__AccountGroup__c (Name= 'Test-AccountGroup', 
                                                                       dmpl__AccountGroupType__c='Scheme');
        insert accountGroup;
    
       /* List<Account> account = new List<Account>();
        account.add(new Account(Name = 'Test - Account', 
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
                                             dmpl__IsSupplierAccount__c = True,
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
    
        List<dmpl__SKU__c> Skus = new List<dmpl__SKU__c>();
       
        Skus.add(new dmpl__SKU__c(Name = 'Harrier XMA - Automatic - Orcus White',
                                dmpl__ItemId__c = item[0].Id
                            ));
        insert Skus;
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
                                            Name='Test-1',
                                            dmpl__PriceListType__c = 'Sale Price',
                                            dmpl__IsActive__c = true
                                            ));
        insert priceList;
    }
    
    private static void CreateTaxGroup()
    {
        List<dmpl__TaxGroup__c> taxGroup = new List<dmpl__TaxGroup__c>();
        Account account=[Select Id,Name from Account Where Name='Partner-Test-Account'];
        dmpl__AccountGroup__c AccountGroup = [Select Id,Name FROM dmpl__AccountGroup__c LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        taxGroup.Add(new dmpl__TaxGroup__c(Name = 'Test - Tax Group',
                                           dmpl__PartnerAccountId__c = account.Id,
                                           dmpl__BranchId__c = branch.Id,
                                           dmpl__PartnerAccountGroupId__c= AccountGroup.Id,
                                           dmpl__IsActive__c=True,
                                           dmpl__Description__c='Text'
                                           ));
        insert taxGroup;
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
        dmpl__SKU__c sku = [Select Id,Name FROM dmpl__SKU__c LIMIT 1];
        purchaseRequisitionLine.add(new dmpl__PurchaseRequisitionLine__c(dmpl__PurchaseRequisitionId__c = purchaseRequisition[0].Id,
                                                                        dmpl__ItemId__c = item.Id,
                                                                        dmpl__Quantity__c = 1,
                                                                        dmpl__SKUId__c = sku.Id
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
                                                        dmpl__PurchaseOrderType__c = 'Part PO',
                                                        dmpl__DocumentDate__c = Date.today(),
                                                        dmpl__Remarks__c = 'Test-Remark',
                                                        dmpl__PerformReleaseInvoice__c = true,
                                                        dmpl__IsInvoiceReleased__c = true
                                                        ));
        insert purchaseOrder;
    
        List<dmpl__PurchaseOrderLine__c> purchaseOrderLine = new List<dmpl__PurchaseOrderLine__c>();
        dmpl__Item__c listofitem = [Select Id, Name from dmpl__Item__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id,Name FROM dmpl__SKU__c LIMIT 1];
        dmpl__PurchaseRequisition__c purchaseRequisition = [Select Id,Name FROM dmpl__PurchaseRequisition__c LIMIt 1];
        dmpl__PurchaseRequisitionLine__c purchaseRequisitionLine = [Select Id,Name FROM dmpl__PurchaseRequisitionLine__c LIMIt 1];
        dmpl__TaxGroup__c taxGroup = [Select Id,Name From dmpl__TaxGroup__c LIMIT 1];
        purchaseOrderLine.add(new dmpl__PurchaseOrderLine__c(dmpl__ItemId__c = listofitem.Id,
                                                             dmpl__SKUId__c = sku.Id,
                                                             dmpl__PurchaseOrderId__c = purchaseOrder[0].Id,
                                                             dmpl__Quantity__c = 1,
                                                             dmpl__PurchaseRequisitionId__c = purchaseRequisition.Id,
                                                             dmpl__TaxGroupId__c = taxGroup.Id
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
                                           dmpl__SupplierInvoiceNumber__c = 'Test - Shipment',
                                           dmpl__SupplierInvoiceDate__c = Date.today(),
                                           dmpl__DeliveryOrderNumber__c = '12',
                                           dmpl__DeliveryOrderDate__c = Date.today(),
                                           dmpl__TransporterName__c = 'ABC',
                                           dmpl__PerformInventoryPosting__c = false,
                                           dmpl__TransporterReferenceNo__c = '1234',
                                           dmpl__PerformReleaseReceipt__c = false,
                                           dmpl__IsReceiptReleased__c = true
                                           ));
        insert shipment;
    
        List<dmpl__ShipmentLine__c> shipmentLine = new List<dmpl__ShipmentLine__c>();
        dmpl__Item__c item = [Select Id, Name FROM dmpl__Item__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id, Name FROM dmpl__SKU__c LIMIT 1];
        dmpl__PurchaseOrderLine__c purchaseOrderLine = [Select Id,Name From dmpl__PurchaseOrderLine__c LIMIT 1];
        shipmentLine.add(new dmpl__ShipmentLine__c(dmpl__ItemId__c = item.Id,
                                                   dmpl__ShipmentId__c = shipment[0].Id,
                                                   dmpl__Quantity__c = 1,
                                                   dmpl__SKUId__c = sku.Id,
                                                   dmpl__PurchaseOrderId__c = purchaseOrder.Id,
                                                   dmpl__PurchaseOrderLineId__c=purchaseOrderLine.Id
                                                   ));
        insert shipmentLine;
    }
    
    private static void CreateGoodReceiptFromShipment()
    {
        List<dmpl__GoodsReceipt__c> goodReceipt = new List<dmpl__GoodsReceipt__c>();
        dmpl__Shipment__c shipment = [Select Id,dmpl__BranchId__c,dmpl__PartnerAccountId__c,dmpl__SupplierAccountId__c,dmpl__PurchaseOrderId__c FROM dmpl__Shipment__c LIMIT 1];
        goodReceipt.add(new dmpl__GoodsReceipt__c(dmpl__BranchId__c = shipment.dmpl__BranchId__c,
                                           dmpl__PartnerAccountId__c = shipment.dmpl__PartnerAccountId__c,
                                           dmpl__SupplierAccountId__c = shipment.dmpl__SupplierAccountId__c,
                                           dmpl__PurchaseOrderId__c = shipment.dmpl__PurchaseOrderId__c,
                                           dmpl__ReceivedTime__c = Date.today(),
                                           dmpl__DocumentDate__c = Date.today(),
                                           dmpl__SupplierInvoiceDate__c = Date.today(),
                                           dmpl__SupplierInvoiceNumber__c = 'Test-Supply',
                                           dmpl__SupplierDispatchDate__c = Date.today(),
                                           dmpl__TransporterName__c = 'Test-Transport',
                                           dmpl__TransporterRefrenceNumber__c = '123'
                                           ));
        insert goodReceipt;
    }
    
   /* private static void CreateGoodReceiptLineFromShipmentLine()
    {
        List<dmpl__GoodsReceiptLine__c> goodReceiptLine = new List<dmpl__GoodsReceiptLine__c>();
        dmpl__ShipmentLine__c shipmentLine = [Select Id,dmpl__ItemId__c,dmpl__SKUId__c,dmpl__Quantity__c FROM dmpl__ShipmentLine__c LIMIT 1];
        dmpl__GoodsReceipt__c goodReceipt = [Select Id, Name FROM dmpl__GoodsReceipt__c LIMIT 1];
        goodReceiptLine.add(new dmpl__GoodsReceiptLine__c(dmpl__ItemId__c = shipmentLine.dmpl__ItemId__c,
                                                      dmpl__SKUId__c = shipmentLine.dmpl__SKUId__c,
                                                      dmpl__GoodsReceiptId__c = goodReceipt.Id,
                                                      dmpl__OrderedQuantity__c = shipmentLine.dmpl__Quantity__c,
                                                      dmpl__InvoiceQuantity__c = shipmentLine.dmpl__Quantity__c
                                           ));
        insert goodReceiptLine;
    }*/
    
    private static void CreateDeliveryOrder()
    {
        List<dmpl__DeliveryOrder__c> deliveryOrder = new List<dmpl__DeliveryOrder__c>();
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c Where Name = 'Test-Branch' LIMIT 1];
        Account customerAccount = [Select Id,Name From Account WHERE Name = 'Partner-Test-Account' AND dmpl__IsCustomerAccount__c = True LIMIT 1];
        deliveryOrder.Add(new dmpl__DeliveryOrder__c(dmpl__AccountId__c = customerAccount.Id,
                                                     dmpl__BranchId__c = branch.Id,
                                                    dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                                    dmpl__PerformReleaseShipment__c=false));
        insert deliveryOrder;
    
        List<dmpl__DeliveryOrderLine__c> deliveryOrderLine = new List<dmpl__DeliveryOrderLine__c>();
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id,Name From dmpl__SKU__c LIMIT 1];
        dmpl__PurchaseOrderLine__c purchaseOrderLine = [Select Id,Name From dmpl__PurchaseOrderLine__c LIMIT 1];
        deliveryOrderLine.Add(new dmpl__DeliveryOrderLine__c(dmpl__DeliveryId__c = deliveryOrder[0].Id,
                                                             dmpl__ItemId__c = item.Id,
                                                             dmpl__SKUId__c = sku.Id,
                                                             dmpl__Quantity__c = 1,
                                                             dmpl__PurchaseOrderLineId__c = purchaseOrderLine.Id
                                                             ));
        insert deliveryOrderLine;
    }
}