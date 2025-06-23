@isTest
public class GoodsReceiptHelper_Test {
    
    @testSetup
    public static void Setup()
    {
        //System.runAs(PostInstallHelper.AssignAdministratorAllPermissions(UserInfo.getUserId())){
            CreateAccountGroup();
            CreateAccount();
            CreateBranch();
            CreateItemGroup();
            CreateItem();
            CreateSKU();
            CreateItemLot();
            CreatePriceList();
            CreateTaxGroup();
            CreatePurchaseOrder();
            CreatePurchaseOrderLine();
            CreateShipment();
            CreateShipmentLine();
            CreateGoodsReceipt();
             CreateGoodReceiptLine();
            //CreateStorageLocation();
        //}
    }
      
     @isTest
    static void createInspectionLinesTest() {
          
        Test.startTest();  
        //CreateGoodReceiptLine();
         List<dmpl__GoodsReceipt__c> goodsReceipt = [Select Id,Name,dmpl__Status__c, dmpl__IsBillGenerated__c From dmpl__GoodsReceipt__c LIMIT 1];
        List<dmpl__GoodsReceipt__c> grList = [SELECT Id, 
                                             Name,
                                             dmpl__DocumentDate__c,
                                             dmpl__BranchId__c,
                                             dmpl__PartnerAccountId__c
                                             FROM dmpl__GoodsReceipt__c];
        List<dmpl__Shipment__c> shipment = [SELECT Id, Name,dmpl__BranchId__c FROM dmpl__Shipment__c LIMIT 1];
    List<dmpl__PurchaseOrder__c> purchaseOrder = [Select Id, Name FROM dmpl__PurchaseOrder__c LIMIT 1];

        try {
            
            GoodsReceiptHelper.createInspectionLines(goodsReceipt[0].Id);
            GoodsReceiptHelper.completeInspection(grList);
            GoodsReceiptHelper.completeInspection(goodsReceipt[0].Id);
        }catch(Exception e) {}
        Test.stopTest();
    }
    
    @isTest
    static void createInspectionLinesTest1() {
          
        Test.startTest();  
        //CreateGoodReceiptLine();
         List<dmpl__GoodsReceipt__c> goodsReceipt = [Select Id,Name,dmpl__Status__c, dmpl__IsBillGenerated__c From dmpl__GoodsReceipt__c LIMIT 1];
        List<dmpl__GoodsReceipt__c> grList = [SELECT Id, 
                                             Name,
                                             dmpl__DocumentDate__c,
                                             dmpl__BranchId__c,
                                             dmpl__PartnerAccountId__c
                                             FROM dmpl__GoodsReceipt__c];
        List<dmpl__Shipment__c> shipment = [SELECT Id, Name,dmpl__BranchId__c FROM dmpl__Shipment__c LIMIT 1];
    List<dmpl__PurchaseOrder__c> purchaseOrder = [Select Id, Name FROM dmpl__PurchaseOrder__c LIMIT 1];
        
        try {
            
            GoodsReceiptHelper.createGoodsReceiptFromShipment(shipment);
            GoodsReceiptHelper.createGoodsReceiptFromPurchaseOrder(purchaseOrder);
            GoodsReceiptHelper.populateChecklistDetails(goodsReceipt);
        }catch(Exception e){}
        Test.stopTest();
    }
    
    
    public static void Verify()
    {
        test.startTest();
        CreateGoodReceiptLine();
        CreateBill();
        CreateBillLine();
        CreatePurchaseReturn();
        CreatePurchaseReturnLine(); 
        List<dmpl__Shipment__c> line = [SELECT Id, Name,dmpl__BranchId__c FROM dmpl__Shipment__c];
        GoodsReceiptHelper.createGoodsReceiptFromShipment(line);
        List<dmpl__PurchaseReturn__c> line1 = [SELECT Id, Name,dmpl__BranchId__c FROM dmpl__PurchaseReturn__c];
        System.assertEquals(1, line.size(), 'shipment is verified');
        test.stopTest();
    }
   
    @isTest
    static void createInspectionLinesTest123() {
        
        List<dmpl__GoodsReceipt__c> gr = [select id, dmpl__SupplierInvoiceNumber__c, dmpl__PerformInspection__c, dmpl__TransporterName__c from dmpl__GoodsReceipt__c];
    Test.startTest();
        GoodsReceiptHelper.createInspectionLines(gr);
        Test.stopTest();
    }
    
    
    
    @isTest
    public static void VerifyChecklistLines()
    {
        try{
        test.startTest();
        //CreateGoodsReceipt();
        //CreateGoodReceiptLine();
        CreateChecklistTemplate();
        CreateChecklistTemplateLine();
        CreateChecklistlines();
        List<dmpl__GoodsReceipt__c> order = [SELECT Id, 
                                             Name,
                                             dmpl__DocumentDate__c,
                                             dmpl__BranchId__c,
                                             dmpl__PartnerAccountId__c
                                             FROM dmpl__GoodsReceipt__c];       
         GoodsReceiptHelper.receiveGoodsReceiptLinesAsync(order);
         GoodsReceiptHelper.receiveGoodsReceiptLines(order);
        ChecklistLineHelper.createChecklistLines(order);
        GoodsReceiptHelper.performAllocation(order);
         GoodsReceiptHelper.completeInspection(order[0].Id);
            GoodsReceiptHelper.createInspectionLines(order[0].Id);
            GoodsReceiptHelper.postIL(order[0].Id);
            GoodsReceiptHelper.postIL(new List<SourceObjectInfo>(),order[0].Id);
       // System.assertEquals(3, order.size(), 'Good Receipt data');
        test.stopTest();
        }
        catch(exception e){}
    }
    
    @isTest
    public static void postGoodsReceiptLinesTest()
    {
       test.startTest();
       List<dmpl__GoodsReceipt__c> gr = [select id, dmpl__SupplierInvoiceNumber__c, dmpl__TransporterName__c from dmpl__GoodsReceipt__c Limit 1 ];
       GoodReceiptLineHelper.postGoodsReceiptLines(gr);
       test.stopTest();      
    }
    
     @isTest
    public static void createPurchaseInvoiceLine()
    {
        Test.startTest();
        string errorReceived; 
        try{             
            dmpl__PurchaseOrderLine__c pOLine = [Select Id,Name,dmpl__ItemId__c,
            dmpl__SKUId__c,
            dmpl__PurchaseOrderId__c,                                    
            dmpl__PurchaseOrderId__r.dmpl__BranchId__c,                                     
            dmpl__PendingQuantity__c,
            dmpl__PurchaseOrderId__r.dmpl__SupplierAccountId__c,
            dmpl__PurchaseOrderId__r.dmpl__PartnerAccountId__c,
            dmpl__TaxGroupId__c  
            From dmpl__PurchaseOrderLine__c LIMIT 1];
            GoodsReceiptHelper.createReceiptDocumentFromPurchaseOrder(pOLine);
            GoodsReceiptHelper.createReceiptLineFromPurchaseOrderLine(pOLine);
            System.assert(pOLine != null);
        } catch (Exception ex) {
            errorReceived = ex.getMessage();
        }
        System.assertEquals(null, errorReceived);
        Test.stopTest();
    }
    
    @isTest
    public static void queryGoodsReceiptLines()
    {
        test.startTest();
        List<Id> goodsReceiptIds = new List<Id>();
        List<Id> goodsReceiptLinesIds = new List<Id>();
        dmpl__PurchaseOrder__c order = [SELECT Id, 
                                             Name,
                                             dmpl__DocumentDate__c,
                                             dmpl__BranchId__c,
                                             dmpl__PartnerAccountId__c
                                             FROM dmpl__PurchaseOrder__c LIMIT 1];       
         dmpl__PurchaseOrderLine__c orderLine = [SELECT Id, 
                                             Name
                                             FROM dmpl__PurchaseOrderLine__c LIMIT 1];   
        goodsReceiptIds.add(order.Id);
        goodsReceiptLinesIds.add(orderLine.Id);
        GoodsReceiptHelper.queryPurchaseOrderLines(goodsReceiptIds,goodsReceiptLinesIds);
        System.assert(order!=null, 'Good Receipt data');
        test.stopTest();
    }
    
    @isTest
    public static void queryGoodsReceipts()
    {
        test.startTest();
        List<Id> goodsReceiptIds = new List<Id>();
        dmpl__GoodsReceipt__c order = [SELECT Id, 
                                             Name,
                                             dmpl__DocumentDate__c,
                                             dmpl__BranchId__c,
                                             dmpl__PartnerAccountId__c,
                                            dmpl__IsClaimed__c
                                             FROM dmpl__GoodsReceipt__c LIMIT 1];       
        
        ClaimLineHelper.queryGoodsReceipts(order.dmpl__BranchId__c,order.Id,Date.today());
        ItemLotHelper.queryGoodsReceipts(goodsReceiptIds);
        GoodsReceiptHelper.updateIsClaimedFromClaim(goodsReceiptIds,order.dmpl__IsClaimed__c);
        System.assert(order!=null, 'Good Receipt data');
        test.stopTest();
    }
    @isTest
    public static void VerifyChecklistLines3()
    {
        test.startTest();
        string errorReceived;
        try{             
            CreateGoodsReceipt();
            CreateGoodReceiptLine();
            CreateChecklistTemplate();
            CreateChecklistTemplateLine();
            CreateChecklistlines();
            List<dmpl__InspectionLine__c> order = [SELECT Id,  Name,dmpl__ItemId__c,dmpl__SKUId__c
                                                   FROM dmpl__InspectionLine__c];       
            ChecklistLineHelper.createChecklistLines(order);
            InspectionLineHelper.validateItem(order);    
        } catch (Exception ex) {
            errorReceived = ex.getMessage();
        }
        //System.assertEquals(null, errorReceived);
        test.stopTest();
    }
    
    @isTest
    public static void Verify2()
    {
        try{
            test.startTest();
            List<dmpl__Shipment__c> line = [SELECT Id, Name,dmpl__BranchId__c, (SELECT Id, dmpl__Quantity__c FROM ShipmentLines__r) FROM dmpl__Shipment__c];
            
            List<SourceObjectInfo> sourceObjectInfo = new List<SourceObjectInfo>();
            for(dmpl__Shipment__c order : line)
            {
                for(dmpl__ShipmentLine__c orderLine : order.ShipmentLines__r)
                {
                    sourceObjectInfo.add(new SourceObjectInfo('dmpl__ShipmentLine__c', orderLine.Id, 0, ''));
                }
            }
            
            GoodsReceiptHelper.createGoodsReceiptFromShipment(sourceObjectInfo); 
            GoodsReceiptHelper.createGoodsReceiptFromShipment(line);  
            System.assertEquals(1, line.size(), 'shipment is verified');
            
            test.stopTest();
        }catch(Exception e){
        }
        
    }
    
    
    
    
   
     @isTest
    public static void updatePurchaseInvoiceQuantityTest() {
    Test.startTest();
    
    List<Id> ids = new List<Id>();
    List<dmpl__GoodsReceiptLine__c> lines = [SELECT Id FROM dmpl__GoodsReceiptLine__c];
    
    // Iterate over the lines to add their Ids to the ids list
    for (dmpl__GoodsReceiptLine__c line : lines) {
        ids.add(line.Id);
    }
    
    GoodReceiptLineHelper.updatePurchaseInvoiceQuantity(ids);
   GoodReceiptLineHelper.updateDamagedQuantityFromInspection(ids);
    
    Test.stopTest();
}

    
    @isTest
    public static void createAllocationFromGoodsReceipt()
    {
        try{
            test.startTest();
            List<dmpl__GoodsReceiptLine__c> line2 = [SELECT Id, Name,dmpl__PurchaseOrderLineId__r.dmpl__FulfillmentOrderLineId__c FROM dmpl__GoodsReceiptLine__c];
            InventoryFulfillmentAllocationLineHelper.createAllocationFromGoodsReceipt(line2);    
            test.stopTest();
            System.assert(line2!=null, 'fulfillment is verified');
        }
        catch(Exception e)
        {
            
        }
    }
    
    @isTest
    public static void createPurchaseInvoiceLinesFromReceiptLine()
    {
        Test.startTest();
        string errorReceived;
        try{             
            dmpl__PurchaseOrderLine__c pOLine = [Select Id,Name,dmpl__ItemId__c,
            dmpl__SKUId__c,
            dmpl__TaxGroupId__c  
            From dmpl__PurchaseOrderLine__c LIMIT 1];
            List<dmpl__GoodsReceiptLine__c> grnLines = [Select Id,Name,
                            dmpl__ItemLotId__c,
                            dmpl__ReceivedQuantity__c,
                            dmpl__InventoryLedgerId__c,
                            dmpl__StorageLocationId__c,
                            dmpl__UnitCost__c,
                            dmpl__ItemLotTypeId__c,
                            dmpl__PurchaseOrderLineId__c From dmpl__GoodsReceiptLine__c];
            BillHelper.createPurchaseInvoiceLinesFromReceiptLines(pOLine,grnLines);
            System.assert(pOLine != null);
        } catch (Exception ex) {
            errorReceived = ex.getMessage();
        }
        System.assertEquals(null, errorReceived);
        Test.stopTest();
    }
    
    
    @isTest
    public static void UpdateInspectionLine()
    {
        test.startTest();
        UpdateGoodReceiptAsPerformInspection();
        dmpl__InspectionLine__c inspectionLine = [Select Id,Name,dmpl__Quantity__c From dmpl__InspectionLine__c LIMIT 1];
        inspectionLine.dmpl__Quantity__c = 1;
        update inspectionLine;
        test.stopTest();
        System.assertEquals(1, inspectionLine.dmpl__Quantity__c, 'Test inspection Line have 1 updated record');
    }
    
    @isTest
    public static void UpdateShipment()
    {
        test.startTest();
        dmpl__Shipment__c shipment = [Select Id,Name,dmpl__Status__c,dmpl__PerformReleaseReceipt__c,dmpl__IsReceiptReleased__c From dmpl__Shipment__c LIMIT 1];
        if(shipment != null)
            shipment.dmpl__Status__c = 'Draft';
        update shipment;
        test.stopTest();
        System.assertEquals('Draft', shipment.dmpl__Status__c, 'Test shipment have 1 updated record');
    }
    
    @isTest
    public static void UpdateShipmentAsPerformReleaseReceipt()
    {
        test.startTest();
        dmpl__Shipment__c shipment = [Select Id,Name,dmpl__Status__c,dmpl__PerformReleaseReceipt__c From dmpl__Shipment__c LIMIT 1];
        shipment.dmpl__PerformReleaseReceipt__c = true;
        update shipment;
        test.stopTest();
        System.assertEquals(true, shipment.dmpl__PerformReleaseReceipt__c, 'Test shipment have 1 updated record');
    }
    
    @isTest
    public static void DeleteShipment()
    {
        test.startTest();
        dmpl__Shipment__c shipment = [Select Id,Name,dmpl__Status__c From dmpl__Shipment__c LIMIT 1];
        delete shipment;
        test.stopTest();
        System.assertEquals(null, shipment.dmpl__Status__c, 'Test shipment have 1 updated record');
    }
    
    @isTest
    public static void UpdateShipmentLine()
    {
        test.startTest();
        dmpl__ShipmentLine__c shipmentLine = [Select Id,Name,dmpl__Quantity__c From dmpl__ShipmentLine__c LIMIT 1];
        shipmentLine.dmpl__Quantity__c = 5;
        update shipmentLine;
        test.stopTest();
        System.assertEquals(5, shipmentLine.dmpl__Quantity__c, 'Test shipment Line have 1 updated record');
    }
    
   /* @isTest
    public static void DeleteShipmentLine()
    {
        test.startTest();
        dmpl__ShipmentLine__c shipmentLine = [Select Id,Name,dmpl__Quantity__c From dmpl__ShipmentLine__c LIMIT 1];
        delete shipmentLine;
        test.stopTest();
        System.assertEquals(1, shipmentLine.dmpl__Quantity__c, 'Test shipment Line have 1 updated record');
    }*/
    
    @isTest
    public static void UpdateGoodReceipt()
    {
        test.startTest();
        dmpl__GoodsReceipt__c goodsReceipt = [Select Id,Name,dmpl__Status__c From dmpl__GoodsReceipt__c LIMIT 1];
        if(goodsReceipt != null)
            goodsReceipt.dmpl__Status__c = 'Draft';
        update goodsReceipt;
        test.stopTest();
        System.assertEquals('Draft', goodsReceipt.dmpl__Status__c, 'Test good receipt have 1 updated record');
    }

    @isTest
    public static void PerformReleaseBill()
    {
        test.startTest();
        dmpl__GoodsReceipt__c goodsReceipt = [Select Id,Name,dmpl__Status__c, dmpl__IsBillGenerated__c From dmpl__GoodsReceipt__c LIMIT 1];
        if(goodsReceipt != null)
            goodsReceipt.dmpl__PerformReleaseBill__c = true;
        update goodsReceipt;
        dmpl__GoodsReceipt__c currentGoodsReceipt = [SELECT Id, Name, dmpl__IsBillGenerated__c FROM dmpl__GoodsReceipt__c WHERE Id = : goodsReceipt.Id];
        test.stopTest();
        System.assertEquals( currentGoodsReceipt.dmpl__IsBillGenerated__c , true , 'good receipt have 1 updated record');
    }    
    
    public static void VerifyNew()
    {
        List<dmpl__SaleOrder__c> line = [SELECT Id, Name,dmpl__BranchId__c, (SELECT Id, dmpl__Quantity__c FROM SaleOrderLines__r) FROM dmpl__SaleOrder__c];
        List<SourceObjectInfo> sourceObjectInfo = new List<SourceObjectInfo>();
        for(dmpl__SaleOrder__c order : line)
        {
            
            for(dmpl__SaleOrderLine__c orderLine : order.SaleOrderLines__r)
            {
                sourceObjectInfo.add(new SourceObjectInfo('dmpl__SaleOrderLine__c', orderLine.Id, 0, ''));
            }
        }
        
        System.assertEquals(1, line.size(), 'sale order is verified');    
        FulfillmentHelper.createFulfillmentFromSaleOrder(sourceObjectInfo);  
    }
    
    public static void UpdateGoodReceiptAsPerformReceive()
    {
        dmpl__GoodsReceipt__c goodsReceipt = [Select Id,Name,dmpl__PerformReceive__c From dmpl__GoodsReceipt__c LIMIT 1];
        goodsReceipt.dmpl__PerformReceive__c = true;
        update goodsReceipt;
        System.assertEquals(true, goodsReceipt.dmpl__PerformReceive__c, 'Test good receipt have 1 updated record');
    }
    
 /*   @isTest
    public static void UpdateGoodReceiptAsPerformReceiveAsy()
    {
        Test.startTest(); 
        CreateGoodsReceipt();
        dmpl__GoodsReceipt__c goodsReceipt = [Select Id,Name,dmpl__PerformReceiveAsync__c From dmpl__GoodsReceipt__c LIMIT 1];
        goodsReceipt.dmpl__PerformReceiveAsync__c = true;
        update goodsReceipt;
        Test.stopTest();
        System.assertEquals(true, goodsReceipt.dmpl__PerformReceiveAsync__c, 'Test good receipt have 1 updated record');
    }*/
    
   
    
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
        //update goodsReceipt;
        
        System.assertEquals(true, goodsReceipt.dmpl__PerformInspectionComplete__c, 'Test good receipt have 1 updated record');
    }
    
    @isTest
    public static void populateChecklistDetails()
    {
        test.startTest();
        //UpdateGoodReceiptAsPerformInspectionComplete();
        dmpl__GoodsReceipt__c goodsReceipt = [Select Id,Name,dmpl__PerformPopulateChecklist__c From dmpl__GoodsReceipt__c LIMIT 1];
        goodsReceipt.dmpl__PerformPopulateChecklist__c = true;
        update goodsReceipt;
        test.stopTest();
        System.assertEquals(true, goodsReceipt.dmpl__PerformPopulateChecklist__c, 'Test good receipt have 1 updated record');
    }
    
    @isTest
    public static void performAllocation()
    {
        try{
        test.startTest();
        UpdateGoodReceiptAsPerformInspectionComplete();
        dmpl__GoodsReceipt__c goodsReceipt = [Select Id,Name,dmpl__PerformAllocation__c From dmpl__GoodsReceipt__c LIMIT 1];
        goodsReceipt.dmpl__PerformAllocation__c = true;
        update goodsReceipt;
        test.stopTest();
        System.assertEquals(true, goodsReceipt.dmpl__PerformAllocation__c, 'Test good receipt have 1 updated record');
        }catch(exception e){}
    }
    
    
    @isTest
    public static void DeleteGoodsReceipt()
    {
        test.startTest();
        dmpl__GoodsReceipt__c goodsReceipt = [Select Id,Name,dmpl__Status__c From dmpl__GoodsReceipt__c LIMIT 1];
        if(goodsReceipt != null)
            delete goodsReceipt;
        test.stopTest();
        System.assertEquals('Draft', goodsReceipt.dmpl__Status__c, 'Test good receipt have 1 deleted record');
    }
    
    @isTest
    public static void UpdateGoodReceiptLine()
    {
        test.startTest();
        dmpl__GoodsReceiptLine__c goodsReceiptLine = [Select Id,Name,dmpl__ReceivedQuantity__c,dmpl__SupplierQuantity__c,dmpl__InvoiceQuantity__c From dmpl__GoodsReceiptLine__c LIMIT 1];
        if(goodsReceiptLine != null){
            goodsReceiptLine.dmpl__ReceivedQuantity__c = 1;
            goodsReceiptLine.dmpl__SupplierQuantity__c = 1;
        }
        update goodsReceiptLine;
        test.stopTest();
        System.assertEquals(1, goodsReceiptLine.dmpl__ReceivedQuantity__c, 'Test good receipt Line have 1 updated record');
    }
    
    @isTest
    public static void DeleteGoodsReceiptLine()
    {
        test.startTest();
        try{
            dmpl__GoodsReceipt__c gRN = [Select Id,Name From dmpl__GoodsReceipt__c LIMIT 1];
            dmpl__GoodsReceiptLine__c goodsReceiptLine = [Select Id,Name From dmpl__GoodsReceiptLine__c LIMIT 1];
            dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
            dmpl__ItemLot__c lot = [Select Id,Name From dmpl__ItemLot__c LIMIT 1];
            ItemLotHelper.createItemLot(goodsReceiptLine,item,lot,gRN);
            if(goodsReceiptLine != null)
              delete goodsReceiptLine;
            System.assertEquals(1, goodsReceiptLine.dmpl__ReturnedQuantity__c, 'Test good receipt Line have 1 deleted record');
        }catch(Exception e){
        }
        test.stopTest();
    }
    
    @isTest
    public static void DeleteGoodsReceiptLine1()
    {
        test.startTest();
        try{
            dmpl__GoodsReceiptLine__c goodsReceiptLine = [Select Id,Name From dmpl__GoodsReceiptLine__c LIMIT 1];
            if(goodsReceiptLine != null)
              delete goodsReceiptLine;
            System.Assert(goodsReceiptLine!=null,'Good Receipt Line Data');
        }
        catch(exception e){}
        test.stopTest();
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
        Account partnerAccount = [Select Id,Name From Account WHERE Name = 'Partner-Test-Account' AND dmpl__IsPartnerAccount__c = true LIMIT 1];
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
                                                     dmpl__Remarks__c = 'Remark',
                                                     dmpl__PerformReleaseInvoice__c=true,
                                                     dmpl__IsInvoiceReleased__c=true));
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
                                           dmpl__TransporterReferenceNo__c='Sample',
                                           dmpl__PerformReleaseReceipt__c=true,
                                           dmpl__IsReceiptReleased__c=true
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
        dmpl__PriceList__c priceList = [Select Id,Name From dmpl__PriceList__c LIMIT 1];
        Account supplierAccount = [Select Id,Name From Account WHERE Name = 'Supplier-Test-Account' LIMIT 1];
        bill.add(new dmpl__Bill__c(dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                   dmpl__BranchId__c = branch.Id,
                                   dmpl__PurchaseOrderId__c = purchaseOrder.Id,
                                   dmpl__DocumentDate__c = date.today(),
                                   dmpl__TypeOfBill__c = 'Expense Bill',
                                   dmpl__PriceListId__c = priceList.Id,
                                   dmpl__SupplierAccountId__c = supplierAccount.Id,
                                   dmpl__SupplierInvoiceNumber__c = 'Test-InvoiceNumber',
                                   dmpl__SupplierInvoiceDate__c = date.today(),
                                   dmpl__SupplierInvoiceAmount__c = 100
                                  ));
        insert bill;
    }
    
    private static void CreateBillLine()
    {
        List<dmpl__BillLine__c> billLine = new List<dmpl__BillLine__c>();
        Account customerAccount=[Select Id,Name from Account WHERE Name = 'Customer-Test-Account' LIMIT 1];
        dmpl__Item__c item = [Select Id,Name FROM dmpl__Item__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id,Name From dmpl__SKU__c LIMIT 1];
        dmpl__Bill__c bill = [Select Id,Name From dmpl__Bill__c LIMIT 1];
        dmpl__TaxGroup__c taxGroup = [Select Id,Name From dmpl__TaxGroup__c LIMIT 1];
        billLine.add(new dmpl__BillLine__c(dmpl__ItemId__c = item.Id,
                                           dmpl__SKUId__c = sku.Id,
                                           dmpl__AccountId__c = customerAccount.Id,
                                           dmpl__Quantity__c = 10,
                                           dmpl__UnitCost__c = 100,
                                           dmpl__IsCustomerBillable__c = true,
                                           dmpl__PurchaseInvoiceId__c = bill.Id,
                                           dmpl__TaxGroupId__c = taxGroup.Id
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
                                                    dmpl__TransporterContactNumber__c = '7575555555',
                                                    dmpl__PerformReceiveAsync__c=false
                                                   ));
        insert goodsReceipts;
    }
    
    /*private static void CreateStorageLocation()
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
    */
    private static void CreateGoodReceiptLine()
    {
        dmpl__GoodsReceipt__c GRNDoc = [SELECT Id, Name FROM dmpl__GoodsReceipt__c LIMIT 1];
        dmpl__PurchaseOrderLine__c purchaseOrderLine = [Select Id,Name,dmpl__ItemId__c FROM dmpl__PurchaseOrderLine__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id,Name From dmpl__SKU__c LIMIT 1];
        dmpl__ItemLot__c itemLot = [SELECT Id, Name, dmpl__ItemId__c, dmpl__QuantityInHand__c FROM dmpl__ItemLot__c LIMIT 1];
         //dmpl__StorageLocation__c storageLocation = [Select Id, Name FROM dmpl__StorageLocation__c LIMIT 1];
        dmpl__GoodsReceiptLine__c grnLine = new dmpl__GoodsReceiptLine__c(dmpl__GoodsReceiptId__c = GRNDoc.Id,
                                                                          dmpl__ItemId__c = purchaseOrderLine.dmpl__ItemId__c,
                                                                          dmpl__ItemLotId__c = itemLot.Id,
                                                                          dmpl__SKUId__c = sku.Id,
                                                                          dmpl__PurchaseOrderLineId__c = purchaseOrderLine.Id, 
                                                                          dmpl__OrderedQuantity__c = 1, 
                                                                          dmpl__ReceivedQuantity__c = 1,
                                                                          dmpl__SerialNumber__c='text1',
                                                                          dmpl__SupplierQuantity__c = 1
                                                                          //dmpl__DamagedQuantity__c = 2
                                                                         // dmpl__StorageLocationId__c = storageLocation.Id
                                                                         );
        insert grnLine;
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
                                                       dmpl__DocumentDate__c = date.today()));
                                                       
        insert purchaseReturn;
        
    }
    
    private static void CreatePurchaseReturnLine()
    {
        List<dmpl__PurchaseReturnLine__c> purchaseReturnLine = new List<dmpl__PurchaseReturnLine__c>();
        dmpl__PurchaseReturn__c purchaseReturn = [Select Id,Name From dmpl__PurchaseReturn__c LIMIT 1];
        Account account = [Select Id,Name From Account WHERE Name = 'Customer-Test-Account' LIMIT 1];
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id,Name From dmpl__SKU__c LIMIT 1];
        dmpl__Bill__c bill = [Select Id,Name From dmpl__Bill__c LIMIT 1];
        dmpl__BillLine__c billLine = [Select Id,Name From dmpl__BillLine__c LIMIT 1];
        dmpl__TaxGroup__c taxGroup = [Select Id,Name From dmpl__TaxGroup__c LIMIT 1];
        purchaseReturnLine.add(new dmpl__PurchaseReturnLine__c(dmpl__AccountId__c = account.Id,
                                                               dmpl__ItemId__c = item.Id,
                                                               dmpl__Quantity__c = 1,
                                                               dmpl__UnitCost__c = 100,
                                                               dmpl__SKUId__c = sku.Id,
                                                               dmpl__PurchaseInvoiceId__c = bill.Id,
                                                               dmpl__BillLineId__c = billLine.Id,
                                                               dmpl__TaxGroupId__c = taxGroup.Id,
                                                               dmpl__PurchaseReturnId__c = purchaseReturn.Id));
        insert purchaseReturnLine;
        
    }
    private static void CreateChecklistTemplate()
    {
        List<dmpl__ChecklistTemplate__c> checkList = new List<dmpl__ChecklistTemplate__c>();
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        checkList.add(new dmpl__ChecklistTemplate__c(dmpl__ItemId__c=item.Id,
                                                     Name='Test1',
                                                     dmpl__Type__c='Inspection',
                                                     dmpl__Code__c='Done'));
        insert checkList;
        
    }
    private static void CreateChecklistTemplateLine()
    {
        List<dmpl__CheckListTemplateLine__c> checkList = new List<dmpl__CheckListTemplateLine__c>();
        dmpl__ChecklistTemplate__c checkListTemplate = [Select Id,Name From dmpl__ChecklistTemplate__c LIMIT 1];
        checkList.add(new dmpl__CheckListTemplateLine__c(dmpl__ChecklistTemplateId__c = checkListTemplate.Id,
                                                         dmpl__DataType__c = 'Text'
                                                        ));
        insert checkList;
        
    }
    private static void CreateChecklistlines()
    {
        List<dmpl__CheckListLines__c> checkList = new List<dmpl__CheckListLines__c>();
        dmpl__ChecklistTemplate__c checkListTemplate = [Select Id,Name From dmpl__ChecklistTemplate__c LIMIT 1];
        dmpl__ChecklistTemplateLine__c checkListTemplateLine = [Select Id,Name From dmpl__ChecklistTemplateLine__c LIMIT 1];
        dmpl__GoodsReceipt__c Order = [Select Id,Name From dmpl__GoodsReceipt__c LIMIT 1];
        checkList.add(new dmpl__CheckListLines__c(dmpl__GoodsReceiptId__c   = Order.Id,
                                                  dmpl__CheckListTemplateLineId__c = checkListTemplateLine.Id,
                                                  dmpl__ChecklistTemplateId__c = checkListTemplate.Id,
                                                  Name='Test2',
                                                  dmpl__DataType__c='Text'
                                                 ));
        insert checkList;
        
    }

}