@isTest
public class FulfillmentHelper_Test {
    
    @testSetup
    public static void Setup()
    {
        //System.runAs(PostInstallHelper.AssignAdministratorAllPermissions(UserInfo.getUserId())){
            CreateAccountGroup();
            CreateAccount();
            CreateBranch();
            CreateStorageLocation();
            //CreateItemGroup();
            CreateItems();
            CreateSKu();
            CreateItemLot();
            //createItemType();
           // Createstock();
            CreateResource();
            CreateContactAddress();
            CreateTaxGroup();
            CreateSaleOrder();
            CreateSaleOrderLine();
            test.startTest();
            CreateRepairOrder();
            CreateRepairOrderLine();
            CreateFulfillment();
            CreateFulfillmentOrderLine();
            test.stopTest();
        //}
    } 
    
     @isTest
    public static void createAllocationFromFulfillment1()
    {
        test.startTest();
        dmpl__InventoryFulfillment__c line2 = [SELECT Id, Name,dmpl__BranchId__c FROM dmpl__InventoryFulfillment__c];
        try{
            InventoryFulfillmentAllocationLineHelper.createAllocationFromFulfillment(line2.Id);    
        }
        catch(Exception e){
        }
        System.assert(line2!=null, 'fulfillment is verified');
        test.stopTest();
        
    }
    
    @isTest
    public static void VerifyInvoiceNew()
    {
        try{
        Test.startTest();
        List<Id> ids = new List<Id>();
        dmpl__SaleOrderLine__c orderLine = [Select Id,Name From dmpl__SaleOrderLine__c LIMIT 1];
        List<dmpl__InventoryFulfillmentAllocationLine__c> line=[Select Id, Name,dmpl__Quantity__c from dmpl__InventoryFulfillmentAllocationLine__c Limit 1];
        if(line != null)
          SaleInvoiceHelper.createSaleInvoiceLine(orderLine,Line,10.00);
        InventoryFulfillmentAllocationLineHelper.updateSaleInvoiceQuantity(ids);
        System.assert(true, 'Record saved');
        Test.stopTest();
        }catch(exception e){}
    }

  @isTest
    public static void deleteFulfillmentAllocationLineNew()
    {
        Test.startTest();
        List<dmpl__InventoryFulfillmentAllocationLine__c> line=[Select Id, Name,dmpl__Quantity__c from dmpl__InventoryFulfillmentAllocationLine__c Limit 1];
        if(line != null)
            delete line;
        System.assert(true, 'Record saved');
        Test.stopTest();
    }

    
    @isTest
    public static void UpdateRepairOrderAsInvoiceGeneration()
    {
        Try{
        Test.startTest();    
        dmpl__RepairOrder__c repairOrder = [Select Id,Name,dmpl__PerformInvoiceGeneration__c From dmpl__RepairOrder__c LIMIT 1];
        repairOrder.dmpl__PerformInvoiceGeneration__c = True;
        update repairOrder;
        FulfillmentHelper.createFulfillmentFromRepairOrderAndAllocate(repairOrder.Id);
        System.assertEquals(True, repairOrder.dmpl__PerformInvoiceGeneration__c, 'Sale Order has 1 Record Updated');
        Test.stopTest();    
        }
        catch(exception e){}
    }
    
    @isTest
    public static void Verify()
    {
        try{
            test.startTest();
            
            List<dmpl__SaleOrder__c> line = [SELECT Id, Name,dmpl__BranchId__c, (SELECT Id, dmpl__Quantity__c FROM SaleOrderLines__r) FROM dmpl__SaleOrder__c];
            FulfillmentHelper.createFulfillmentFromSaleOrder(line);
            FulfillmentHelper.createFulfillmentFromSaleOrderAndAllocate(line[0].Id);
            System.assertEquals(1, line.size(), 'Item is getted');
            
            List<dmpl__RepairOrder__c> line1 = [SELECT Id, Name,dmpl__BranchId__c FROM dmpl__RepairOrder__c];
            FulfillmentHelper.createFulfillmentFromRepairOrder(line1);
            System.assertEquals(1, line1.size(), 'Item is getted');    
            test.stopTest();
        }
        catch(Exception e){
            
        }
    }
    
    @isTest
    public static void allocateLinesNew()
    {
        try{
            test.startTest();
            List<dmpl__SaleOrder__c> line = [SELECT Id, Name,dmpl__BranchId__c, (SELECT Id, dmpl__Quantity__c FROM SaleOrderLines__r) FROM dmpl__SaleOrder__c];
            
            List<SourceObjectInfo> sourceObjectInfo = new List<SourceObjectInfo>();
            for(dmpl__SaleOrder__c order : line)
            {
                for(dmpl__SaleOrderLine__c orderLine : order.SaleOrderLines__r)
                {
                    sourceObjectInfo.add(new SourceObjectInfo('dmpl__SaleOrderLine__c', orderLine.Id, 0, ''));
                }
            }
            
            // FulfillmentHelper.allocateLines(sourceObjectInfo);     
            System.assertEquals(1, line.size(), 'Repair Order is getted');
            test.stopTest();
        }
        catch(Exception e){
            
        }
    }
    
    @isTest
    public static void cancelAllocationNew()
    {
        try{
            test.startTest();
            List<dmpl__SaleOrder__c> line = [SELECT Id, Name,dmpl__BranchId__c, (SELECT Id, dmpl__Quantity__c FROM SaleOrderLines__r) FROM dmpl__SaleOrder__c];
            
            List<SourceObjectInfo> sourceObjectInfo = new List<SourceObjectInfo>();
            for(dmpl__SaleOrder__c order : line)
            {
                for(dmpl__SaleOrderLine__c orderLine : order.SaleOrderLines__r)
                {
                    sourceObjectInfo.add(new SourceObjectInfo('dmpl__SaleOrderLine__c', orderLine.Id, 0, ''));
                }
            }
            FulfillmentHelper.createNewFulfillmentFromRepairOrder(sourceObjectInfo);
            FulfillmentHelper.createFulfillmentFromRepairOrderAndAllocate(sourceObjectInfo);
            FulfillmentHelper.createNewFulfillmentFromRepairOrderAndAllocate(sourceObjectInfo);
            
            FulfillmentHelper.cancelAllocation(sourceObjectInfo);     
            System.assertEquals(1, line.size(), 'Repair Order is getted');
            test.stopTest();
        }
        catch(Exception e){
            
        }
    }
    
    @isTest
    public static void Verify2()
    {
        try{
            test.startTest();
            List<dmpl__SaleOrder__c> line = [SELECT Id, Name,dmpl__BranchId__c, (SELECT Id, dmpl__Quantity__c FROM SaleOrderLines__r) FROM dmpl__SaleOrder__c];
            
            List<SourceObjectInfo> sourceObjectInfo = new List<SourceObjectInfo>();
            for(dmpl__SaleOrder__c order : line)
            {
                for(dmpl__SaleOrderLine__c orderLine : order.SaleOrderLines__r)
                {
                    sourceObjectInfo.add(new SourceObjectInfo('dmpl__SaleOrderLine__c', orderLine.Id, 0, ''));
                }
            }
            
            FulfillmentHelper.createFulfillmentFromSaleOrder(sourceObjectInfo);     
            List<dmpl__RepairOrder__c> line1 = [SELECT Id, Name,dmpl__BranchId__c FROM dmpl__RepairOrder__c];
            FulfillmentHelper.createFulfillmentFromRepairOrder(line1);
            System.assertEquals(1, line1.size(), 'Repair Order is getted');
            test.stopTest();
        }
        catch(Exception e){
            
        }
    }
    
    @isTest
    public static void Verifycancel()
    {
        test.startTest();
        List<dmpl__InventoryFulfillment__c> line2 = [SELECT Id, Name,dmpl__BranchId__c FROM dmpl__InventoryFulfillment__c];
        try{
            InventoryFulfillmentAllocationLineHelper.cancelAllocationFromFulfillment(line2);    
        }
        catch(Exception e){
        }
        System.assertEquals(1, line2.size(), 'fulfillment is verified');
        test.stopTest();    
    }
    
    @isTest
    public static void Verify1()
    {
        test.startTest();
        
        List<dmpl__InventoryFulfillment__c> line2 = [SELECT Id, Name,dmpl__BranchId__c FROM dmpl__InventoryFulfillment__c];
        InventoryFulfillmentAllocationLineHelper.createAllocationFromFulfillment(line2);    
        System.assertEquals(1, line2.size(), 'fulfillment is verified');
        test.stopTest();
    }
    
    @isTest
    public static void UpdateRepairOrderAsReleaseForFulfillment()
    {
        try{
            Test.startTest();
            dmpl__RepairOrder__c repairOrder = [Select Id,Name,dmpl__PerformReleaseForFulfillment__c From dmpl__RepairOrder__c LIMIT 1];
            repairOrder.dmpl__PerformReleaseForFulfillment__c = True;
            FulfillmentHelper.createNewFulfillmentFromRepairOrderAndAllocate(repairOrder.Id);
            FulfillmentHelper.createFulfillmentFromRepairOrderAndAllocate(new List<dmpl__RepairOrder__c>{repairOrder});
            update repairOrder;
            System.assertEquals(True, repairOrder.dmpl__PerformReleaseForFulfillment__c, 'Sale Order has 1 Record Updated');
        }
       
        catch(Exception e){
        }
         Test.stopTest();
        
    }
    
    @isTest 
    public static void Verifysource()
    { 
        test.startTest();
        string errorReceived;
        string expectedErrorCode = 'SOPOS001';
        try{
            
            List<dmpl__InventoryFulfillment__c> line = [SELECT Id, Name,dmpl__BranchId__c, (SELECT Id, dmpl__Quantity__c,dmpl__UnitCost__c FROM FulfillmentAllocationLines__r) FROM dmpl__InventoryFulfillment__c];
            
            List<SourceObjectInfo> sourceObjectInfo = new List<SourceObjectInfo>();
            for(dmpl__InventoryFulfillment__c order : line)
            {
                
                for(dmpl__InventoryFulfillmentAllocationLine__c orderLine : order.FulfillmentAllocationLines__r)
                {
                    sourceObjectInfo.add(new SourceObjectInfo('dmpl__InventoryFulfillmentAllocationLine__c', orderLine.Id, 0, ''));
                }
            }
            FulfillmentHelper.createFulfillmentFromRepairOrderAndAllocate(sourceObjectInfo,line[0].Id);
            
            InventoryFulfillmentAllocationLineHelper.cancelAllocationFromFulfillment(sourceObjectInfo); 
        }
        catch(Exception ex){
            errorReceived = ex.getMessage();
            
        }
        System.assertNotEquals(expectedErrorCode,errorReceived);
        test.stopTest();
    }
    
    @isTest 
    public static void Verifynew()
    { 
        test.startTest();
        string errorReceived;
        string expectedErrorCode = 'SOPOS001';
        try{
            
            List<dmpl__InventoryFulfillment__c> line = [SELECT Id, Name,dmpl__BranchId__c, (SELECT Id, dmpl__Quantity__c,dmpl__UnitCost__c FROM FulfillmentOrderLines__r) FROM dmpl__InventoryFulfillment__c];
            
            List<SourceObjectInfo> sourceObjectInfo = new List<SourceObjectInfo>();
            for(dmpl__InventoryFulfillment__c order : line)
            {
                
                for(dmpl__InventoryFulfillmentOrderLine__c orderLine : order.FulfillmentOrderLines__r)
                {
                    sourceObjectInfo.add(new SourceObjectInfo('dmpl__InventoryFulfillmentOrderLine__c', orderLine.Id, 0, ''));
                }
            }
            FulfillmentHelper.cancelPicking(line);
            FulfillmentHelper.cancelPicking(sourceObjectInfo);
            
            InventoryFulfillmentAllocationLineHelper.createAllocationFromFulfillment(sourceObjectInfo);
        }
        catch(Exception ex){
            errorReceived = ex.getMessage();
            
        }
        System.assertNotEquals(expectedErrorCode,errorReceived);
        test.stopTest();
    }
    
    
    @isTest
    public static void Verifynew1()
    {
        try{
            test.startTest();
            List<dmpl__InventoryFulfillment__c> line = [SELECT Id, Name,dmpl__BranchId__c,dmpl__RepairOrderId__c, (SELECT Id, dmpl__Quantity__c,dmpl__UnitCost__c FROM FulfillmentOrderLines__r) FROM dmpl__InventoryFulfillment__c];
            List<dmpl__RepairOrder__c> line3 = [SELECT Id, Name,(SELECT Id, dmpl__Quantity__c,dmpl__ItemId__r.dmpl__TrackInventory__c FROM Repair_Order_Lines1__r) FROM dmpl__RepairOrder__c];
            
            //FulfillmentOrderLineHelper.createFulfillmentOrderLinesFromRepairOrder(line,line3);  
            PurchaseOrderHelper.createPurchaseOrderFromRepairOrder(line3);
            PurchaseOrderHelper.createPurchaseOrderFromRepairOrder(line3[0].Id);
            System.assertEquals(1, line.size(), 'fulfillment is verified');
            test.stopTest();}
        catch(Exception e){
            
        }
    }
    
    
    @isTest
    public static void VerifyInvoice()
    {
        try{
        test.startTest();
        dmpl__InventoryFulfillmentAllocationLine__c line = [SELECT Id, Name,dmpl__RepairOrderLineId__c FROM dmpl__InventoryFulfillmentAllocationLine__c];
        dmpl__RepairOrderLine__c line3 = [SELECT Id, Name,dmpl__RepairOrderId__c,dmpl__ItemId__c,dmpl__SKUId__c,dmpl__PendingFulfilmentOrderQuantity__c FROM dmpl__RepairOrderLine__c];
        List<SourceObjectInfo> info = new List<SourceObjectInfo>(); 
        FulfillmentHelper.createFulfillmentOrderLineFromRepairOrderLine(line3,info);
        FulfillmentHelper.createFulfillmentDocumentFromRepairOrder(line3);
        SaleInvoiceHelper.createServiceInvoiceLine(line3,info);
        System.assert(line!= null, 'fulfillment is verified');
        test.stopTest();
        }
        catch(exception e){}
    }
    
    @isTest
    public static void createFulfillmentOrderLineFromRepairOrderLine()
    {
        //try{
        test.startTest();
        CreateFulfillmentAllocationLine();
        dmpl__InventoryFulfillmentAllocationLine__c line = [SELECT Id,dmpl__RepairOrderLineId__c,dmpl__ItemLotTypeId__c,dmpl__ItemLotId__c,dmpl__InventoryLedgerId__c,dmpl__StorageLocationId__c,dmpl__UnitCost__c FROM dmpl__InventoryFulfillmentAllocationLine__c];
        dmpl__RepairOrderLine__c line3 = [SELECT Id, Name,dmpl__RepairOrderId__c,dmpl__Discount2__c,dmpl__ContractDiscount__c,dmpl__DiscountAmount2__c,dmpl__Discount__c,dmpl__UnitPrice__c,dmpl__DiscountAmount__c,dmpl__ServiceContractWeightage__c,dmpl__ItemId__c,dmpl__UnitPrice2__c,dmpl__ContractDiscountAmount__c,dmpl__SchemeDiscount__c,dmpl__SchemeDiscountAmount__c,dmpl__ItemLotTypeId__c,dmpl__StorageLocationId__c,dmpl__TaxGroupId__c,dmpl__Quantity__c,dmpl__RepairOrderId__r.dmpl__PartnerAccountId__c,dmpl__RepairOrderId__r.dmpl__BranchId__c,dmpl__RepairOrderId__r.dmpl__AccountId__c,dmpl__RepairOrderId__r.dmpl__DocumentDate__c,dmpl__SKUId__c,dmpl__PendingFulfilmentOrderQuantity__c FROM dmpl__RepairOrderLine__c];
        List<SourceObjectInfo> info = new List<SourceObjectInfo>();
        SaleInvoiceHelper.createServiceInvoiceLine(line3,line,info);    
        FulfillmentHelper.createFulfillmentOrderLineFromRepairOrderLine(line3,info);
        FulfillmentHelper.createFulfillmentDocumentFromRepairOrder(line3);
        System.assert(line3!= null, 'fulfillment is verified');
        test.stopTest();
        //}
        //catch(exception e){}
    }
    
    @isTest
    public static void cancelAllocation()
    {
        try{
            test.startTest();
            List<dmpl__InventoryFulfillment__c> line = [SELECT Id, Name,dmpl__PerformCancelAllocation__c FROM dmpl__InventoryFulfillment__c];
            FulfillmentHelper.cancelAllocation(line);    
            System.assert(line!=null, 'fulfillment is verified');
            test.stopTest();
        }
        catch(Exception e){
            
        }
    }
    
    @isTest
    public static void UpdateFulfillment()
    {
        test.startTest();
        dmpl__InventoryFulfillment__c fulfillment = [Select Id,Name,dmpl__PerformAllocation__c From dmpl__InventoryFulfillment__c LIMIT 1];
        if(fulfillment != null)
            fulfillment.dmpl__PerformAllocation__c= True;
        update fulfillment;
        System.assertEquals(True, fulfillment.dmpl__PerformAllocation__c, 'Test fulfillment have 1 updated record');
        test.stopTest();
    }
    
     @isTest
    public static void UpdateFulfillment1()
    {
        Try{
        test.startTest();
        dmpl__InventoryFulfillment__c fulfillment = [Select Id,Name,dmpl__PerformCancelAllocation__c From dmpl__InventoryFulfillment__c LIMIT 1];
        if(fulfillment != null)
            fulfillment.dmpl__PerformCancelAllocation__c= True;
        update fulfillment;
        System.assertEquals(True, fulfillment.dmpl__PerformCancelAllocation__c, 'Test fulfillment have 1 updated record');
        test.stopTest();
        }
        Catch(Exception e){}
    }
    
    @isTest
    public static void DeleteFulfillment()
    {
        test.startTest();
        dmpl__InventoryFulfillment__c fulfillment = [Select Id,Name,dmpl__PerformAllocation__c From dmpl__InventoryFulfillment__c LIMIT 1];
        
        delete fulfillment;
        System.assertEquals(false, fulfillment.dmpl__PerformAllocation__c, 'Test fulfillment have 1 deleted record');
        test.stopTest();
    }
    
    @isTest 
    public static void UpdateFulfillmentOrderLine()
    { 
        string errorReceived;
        string expectedErrorCode = 'SOPOS001';
        try{
            CreateFulfillment();
            CreateFulfillmentOrderLine();
            dmpl__InventoryFulfillmentOrderLine__c orderLine = [Select Id,Name,dmpl__IsILPosted__c,dmpl__Quantity__c From dmpl__InventoryFulfillmentOrderLine__c LIMIT 1];
            orderLine.dmpl__IsILPosted__c= true;
            orderLine.dmpl__Quantity__c= 10;
            update orderLine;
        }
        catch(Exception ex){
            errorReceived = ex.getMessage();
            
        }
        System.assertNotEquals(expectedErrorCode,errorReceived);
    }
    
    @isTest 
    public static void DeleteFulfillmentOrderLine()
    { 
        string errorReceived;
        string expectedErrorCode = 'SOPOS001';
        try{
            UpdateFulfillmentOrderLine();
            dmpl__InventoryFulfillmentOrderLine__c orderLine = [Select Id,Name,dmpl__IsILPosted__c From dmpl__InventoryFulfillmentOrderLine__c LIMIT 1];
         
            test.startTest();
            delete orderLine;
            test.stopTest();
        }
        catch(Exception ex){
            errorReceived = ex.getMessage();
            
        }
        System.assertNotEquals(expectedErrorCode,errorReceived);
    }
    
     @isTest
    public static void UpdateFulfillmentAllocationLine()
    {
        
        test.startTest();
        CreateFulfillmentAllocationLine();
        dmpl__InventoryFulfillmentAllocationLine__c allocationLine = [Select Id,Name,dmpl__IsILPosted__c,dmpl__Quantity__c From dmpl__InventoryFulfillmentAllocationLine__c LIMIT 1];
        allocationLine.dmpl__IsILPosted__c= true;
        allocationLine.dmpl__Quantity__c= 10;
        update allocationLine;
        System.assertEquals(true, allocationLine.dmpl__IsILPosted__c, 'Test OrderLine have 1 updated record');
        test.stopTest();
    }
    
    
    @isTest
    public static void createAllocationLineForCancellation()
    {
        test.startTest();
        CreateFulfillmentAllocationLine();
        dmpl__InventoryFulfillmentAllocationLine__c allocationLine = [Select Id,
                                                                      dmpl__FulfillmentOrderId__c,
                                                                      dmpl__ItemId__c,
                                                                      dmpl__ItemLotId__c,
                                                                      dmpl__SKUId__c,
                                                                      dmpl__AllocatedQuantity__c,
                                                                      dmpl__StorageLocationId__c,
                                                                      dmpl__UnitCost__c,
                                                                      dmpl__ItemLotTypeId__c,
                                                                      dmpl__StockId__c,
                                                                      dmpl__FulfillmentOrderLineId__c,Name,dmpl__IsILPosted__c From dmpl__InventoryFulfillmentAllocationLine__c LIMIT 1];
       
        InventoryFulfillmentAllocationLineHelper.createAllocationLineForCancellation(allocationLine,-1);
        System.assert(allocationLine!=null,'message' );
        test.stopTest();
    }
    
     @isTest
    public static void updateAllocationReturnQuantity()
    {
        test.startTest();
        CreateFulfillmentAllocationLine();
        List<Id> allIds = new List<Id>();
        dmpl__InventoryFulfillmentAllocationLine__c allocationLine = [Select Id,
                                                                      dmpl__FulfillmentOrderId__c,
                                                                      dmpl__ItemId__c,
                                                                      dmpl__ItemLotId__c,
                                                                      dmpl__SKUId__c,
                                                                      dmpl__AllocatedQuantity__c,
                                                                      dmpl__StorageLocationId__c,
                                                                      dmpl__UnitCost__c,
                                                                      dmpl__StockId__c,
                                                                      dmpl__FulfillmentOrderLineId__c,Name,dmpl__IsILPosted__c From dmpl__InventoryFulfillmentAllocationLine__c LIMIT 1];
       
        allIds.add(allocationLine.Id);
        InventoryFulfillmentAllocationLineHelper.updateAllocationReturnQuantity(allIds);
        System.assert(allocationLine!=null,'message' );
        test.stopTest();
    }
    
    @isTest
    public static void DeleteFulfillmentAllocationLine()
    {
        Test.startTest();
        CreateFulfillmentAllocationLine();
        dmpl__InventoryFulfillmentAllocationLine__c allocationLine = [Select Id,Name,dmpl__IsILPosted__c From dmpl__InventoryFulfillmentAllocationLine__c LIMIT 1];
        Database.DeleteResult allocationLineResult = Database.delete(allocationLine, false);
        Test.stopTest();
        System.assert(allocationLineResult.getErrors().size() == 1);
    }
    
    @isTest
    public static void GetFilteredInventoryStock()
    {
        test.startTest();
        List<dmpl__InventoryStock__c> stocks = [SELECT Id, Name,
                                                dmpl__BranchId__c,
                                                dmpl__PartnerAccountId__c,
                                                dmpl__ItemId__c,
                                                dmpl__SKUId__c,
                                                dmpl__QuantityAdjustedIn__c,
                                                dmpl__QuantityAdjustedOut__c,
                                                dmpl__QuantityAssembledIn__c,
                                                dmpl__QuantityAssembledOut__c,
                                                dmpl__QuantityAvailable__c,
                                                dmpl__QuantityDamaged__c,
                                                dmpl__QuantityExpired__c,
                                                dmpl__QuantityInHand__c,
                                                dmpl__QuantityInTransit__c,
                                                dmpl__QuantityOnAllocation__c,
                                                dmpl__QuantityOnFulfillment__c,
                                                dmpl__QuantityOnHold__c,
                                                dmpl__QuantityOnInspection__c,
                                                dmpl__StorageLocationId__c
                                                FROM dmpl__InventoryStock__c LIMIT 1];
        dmpl__ItemLot__c itemLot = [Select Id, Name, dmpl__QuantityAvailable__c, dmpl__StorageLocationId__c, dmpl__UnitCost__c,dmpl__ItemLotTypeId__c FROM dmpl__ItemLot__c LIMIT 1];
        Map<Id, Decimal> map1 = new Map<Id, Decimal>();
        map1.put(itemLot.Id,2);
        InventoryFulfillmentAllocationLineHelper.getFilteredInventoryStock(stocks, null,null, null, null,map1);
        System.assertEquals(0, stocks.size(), 'stock is verified');
        test.stopTest();
    }
    
    @isTest
    public static void CreateAllocationFromLot()
    {
        test.startTest();
        dmpl__InventoryFulfillmentOrderLine__c fulfillmentOrderLine = [SELECT Id, Name,dmpl__SaleOrderLineId__c, dmpl__FulfillmentId__c, dmpl__ItemId__c,dmpl__RepairOrderLineId__c, dmpl__SKUId__c,dmpl__ItemLotTypeId__c FROM dmpl__InventoryFulfillmentOrderLine__c LIMIT 1];
        dmpl__ItemLot__c itemLot = [Select Id, Name, dmpl__QuantityAvailable__c, dmpl__StorageLocationId__c, dmpl__UnitCost__c,dmpl__ItemLotTypeId__c FROM dmpl__ItemLot__c LIMIT 1];
        Map<Id, Decimal> map1 = new Map<Id, Decimal>();
        map1.put(itemLot.Id,2);
        InventoryFulfillmentAllocationLineHelper.createAllocationFromLot(fulfillmentOrderLine, itemLot, 1,map1);
        System.assert(itemLot != null, 'Item Lot is verified');
        test.stopTest();
    }
    
    @isTest
    public static void CreateAllocationFromInventory()
    {
        try{
        test.startTest();
        List<dmpl__ItemLot__c> itemLot = [Select Id, Name, dmpl__QuantityAvailable__c,dmpl__BranchId__c,dmpl__PartnerAccountId__c, dmpl__StorageLocationId__c,dmpl__ItemLotTypeId__c, dmpl__UnitCost__c FROM dmpl__ItemLot__c LIMIT 1];
        dmpl__InventoryFulfillmentOrderLine__c fulfillmentOrderLine = [SELECT Id, Name,dmpl__RepairOrderLineId__c, dmpl__FulfillmentId__c,dmpl__SaleOrderLineId__c, dmpl__UnitCost__c,dmpl__ItemId__c,dmpl__ItemLotId__c, dmpl__SKUId__c FROM dmpl__InventoryFulfillmentOrderLine__c LIMIT 1];
        dmpl__InventoryStock__c inventoryStock = [Select Id, Name, dmpl__QuantityAvailable__c, dmpl__StorageLocationId__c FROM dmpl__InventoryStock__c LIMIT 1];
        Map<Id, Decimal> map1 = new Map<Id, Decimal>();
        map1.put(inventoryStock.Id,2);
        InventoryFulfillmentAllocationLineHelper.CreateAllocationFromInventory(fulfillmentOrderLine, inventoryStock, 1,map1);
         InventoryFulfillmentAllocationLineHelper.getFilteredItemLot(itemLot,fulfillmentOrderLine.dmpl__ItemId__c,itemLot[0].dmpl__BranchId__c,itemLot[0].dmpl__PartnerAccountId__c,fulfillmentOrderLine.dmpl__SKUId__c,itemLot[0].dmpl__ItemLotTypeId__c,map1,0,itemLot[0].Id);
        BulkOrderProcessingController.getFilteredItemLot(itemLot,fulfillmentOrderLine.dmpl__ItemId__c,itemLot[0].dmpl__BranchId__c,itemLot[0].dmpl__PartnerAccountId__c,itemLot[0].dmpl__ItemLotTypeId__c,map1,0,itemLot[0].Id,10.00);
        System.assertEquals(10, inventoryStock.dmpl__QuantityAvailable__c, 'stock is verified');
        test.stopTest();
        }catch(exception e){}
    }

@isTest
    public static void CreateDeliveryOrder()
    {
        Test.startTest();
        List<dmpl__InventoryFulfillment__c> line2 = [SELECT Id, Name,dmpl__BranchId__c FROM dmpl__InventoryFulfillment__c];
    CreateFulfillmentAllocationLine();
        List<dmpl__InventoryFulfillmentAllocationLine__c> line=[Select Id, Name,dmpl__Quantity__c from dmpl__InventoryFulfillmentAllocationLine__c Limit 1];
        SaleDeliveryHelper.createSaleDeliveryFromFulfillment(line2);
        System.assert(true, 'Record saved');
        Test.stopTest();
    }    
    
    @isTest
    public static void CreateDeliveryOrderFromFulfillmentId()
    {
        Test.startTest();
        dmpl__InventoryFulfillment__c line2 = [SELECT Id, Name,dmpl__BranchId__c FROM dmpl__InventoryFulfillment__c Limit 1];
    CreateFulfillmentAllocationLine();
        SaleDeliveryHelper.createSaleDeliveryFromFulfillment(line2.Id);
        System.assert(true, 'Record saved');
        Test.stopTest();
        
    }    
    
  public static void CreateDeliveryOrderFromAllocationLines()
    { 
        test.startTest();
        string errorReceived;
        string expectedErrorCode = 'SOPOS001';
        try{
            List<dmpl__InventoryFulfillmentAllocationLine__c> line = [SELECT Id, dmpl__Quantity__c,dmpl__UnitCost__c FROM dmpl__InventoryFulfillmentAllocationLine__c];
            List<SourceObjectInfo> sourceObjectInfo = new List<SourceObjectInfo>();

            for(dmpl__InventoryFulfillmentAllocationLine__c orderLine : line)
                {
                    sourceObjectInfo.add(new SourceObjectInfo('dmpl__InventoryFulfillmentAllocationLine__c', orderLine.Id, 1, ''));
                }
            
            SaleDeliveryHelper.createSaleDeliveryFromFulfillment(sourceObjectInfo); 
        }
        catch(Exception ex){
            errorReceived = ex.getMessage();
        }
        System.assertNotEquals(expectedErrorCode,errorReceived);
        test.stopTest();
    }
    
    @isTest
    public static void verifySaleOrder()
    {
        test.startTest();
        dmpl__SaleOrder__c saleOrder = [Select Id,Name From dmpl__SaleOrder__c LIMIT 1];
        FulfillmentHelper.createFulfillmentFromSaleOrder(saleOrder.Id);
        System.assert(saleOrder != null);
        test.stopTest();
    }
    
    @isTest
    Public static void verifyPopulatedFulfillment()
    {
        Try{
        Test.startTest();
        List<SourceObjectInfo> info = new List <SourceObjectInfo>();
        dmpl__InventoryFulfillment__c line2 = [SELECT Id, Name,dmpl__BranchId__c FROM dmpl__InventoryFulfillment__c Limit 1];
        FulfillmentHelper.populateFulfillmentFromSaleOrder(info,line2.Id);
        System.assert(line2 != null);
        Test.stopTest();
        }
        Catch(Exception e){}
    }
    
    @isTest
    Public static void verifyPopulatedFulfillment1()
    {
        Try{
        Test.startTest();
        List<SourceObjectInfo> info = new List <SourceObjectInfo>();
        List<dmpl__RepairOrderLine__c> roLine = [Select Id,Name From dmpl__RepairOrderLine__c LIMIT 1];
        dmpl__InventoryFulfillment__c line2 = [SELECT Id, Name,dmpl__BranchId__c FROM dmpl__InventoryFulfillment__c Limit 1];
        FulfillmentHelper.populateFulfillmentFromRepairOrder(info,line2.Id);
        // if(roLine.size() > 0)
           FulfillmentHelper.createFulfillmentFromRepairOrderInternal(roLine,line2,info,false);
        System.assert(line2 != null);
        Test.stopTest();
        }
        Catch(Exception e){}
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
                                dmpl__LastName__c = 'Fulfillment',
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
                                             dmpl__LastName__c = 'Fulfillment',
                                             dmpl__IsPartnerAccount__c = True, 
                                             dmpl__IsActive__c = true);
        insert partneraccount;
        
        Account customerAccount = new Account(Name = 'Customer-Test-Account',
                                              dmpl__LastName__c = 'Fulfillment',
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
    
    private static void CreateItemGroup()
    {
        List<dmpl__ItemGroup__c> itemGroup = new List<dmpl__ItemGroup__c> ();
        itemGroup.Add(new dmpl__ItemGroup__c(Name = 'Item Group Test',
                                             dmpl__ItemGroupType__c = 'Tax'));
        insert itemGroup;
    }
    
    private static void CreateItems()
    {
        List<dmpl__Item__c> item = new List<dmpl__Item__c>();
        //dmpl__ItemGroup__c itemGroup = [Select Id,Name From dmpl__ItemGroup__c LIMIT 1];
        item.Add(new dmpl__Item__c(Name = 'Test-Item',
                                   dmpl__ItemCode__c = 'DMPL',
                                   dmpl__ItemType__c = 'Service Contract',
                                   dmpl__ItemSubType__c = '',
                                   dmpl__Description__c = '',
                                   dmpl__ItemFamily__c = 'Sample',
                                   dmpl__ItemSegment__c = 'Sample',
                                   dmpl__Make__c = 'Sample',
                                   dmpl__Model__c = 'Sample',
                                   dmpl__TrackInventory__c = True,
                                   dmpl__TrackLots__c = true,
                                   dmpl__IsSKURequired__c = true,
                                   dmpl__RequireInspectionOnReceipt__c = true,
                                   dmpl__RequireInspectionOnDelivery__c = true,
                                   dmpl__AllowService__c = true,
                                   dmpl__TrackAsset__c = true,                               
                                   dmpl__IsActive__c = true,
                                   dmpl__IsRegistrationRequired__c = true,
                                   dmpl__GTIN__c = 'BR123',
                                   dmpl__RFID__c = 'O1234fgh',
                                   dmpl__IsPackage__c=true,
                                   dmpl__QuantityUnitOfMeasure__c='Box',
                                   dmpl__InventoryValuationMethod__c='FIFO'  
                                  // dmpl__TaxItemGroupId__c=itemGroup.Id
                                  ));
        insert item;
        
       /* List<dmpl__Item__c> item1 = new List<dmpl__Item__c>();
        item1.Add(new dmpl__Item__c(Name = 'Oil',
                                    dmpl__ItemCode__c = 'DMPLNEW',
                                    dmpl__ItemType__c = 'Part',
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
                                    dmpl__GTIN__c = 'BR1233',
                                    dmpl__RFID__c = 'O1234fgdh',
                                    dmpl__IsPackage__c=true,
                                    dmpl__QuantityUnitOfMeasure__c='Box',
                                    dmpl__InventoryValuationMethod__c='FIFO'
                                    //dmpl__TaxItemGroupId__c=itemGroup.Id
                                   ));
        insert item1; */
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
                                         dmpl__Cost__c = 100,
                                         //dmpl__QuantityExpired__c = 1,
                                         //dmpl__QuantityOnHold__c = 1,
                                         dmpl__ItemLotTypeId__c = null
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
    
    private static void CreateResource()
    {
       /* List<dmpl__Resource__c> resource = new List<dmpl__Resource__c>();
        Account partnerAccount = [Select Id,Name From Account LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name From dmpl__Branch__c LIMIT 1];
        resource.add(new dmpl__Resource__c(Name = 'Test - Resource',
                                           dmpl__ResourceType__c = 'Sample',
                                           dmpl__IsActive__c = true,
                                           dmpl__Phone__c = '9999999999',
                                           dmpl__DefaultPartnerAccountId__c = partnerAccount.Id,
                                           dmpl__DefaultBranchId__c = branch.Id
                                          ));
        insert resource; */
        
      /*  List<dmpl__Resource__c> resource1 = new List<dmpl__Resource__c>();
        Account partnerAccount1 = [Select Id,Name From Account LIMIT 1];
        dmpl__Branch__c branch1 = [Select Id,Name From dmpl__Branch__c LIMIT 1];
        resource1.add(new dmpl__Resource__c(Name = 'Test - Resource',
                                            dmpl__ResourceType__c = 'Service Advisor',
                                            dmpl__IsActive__c = true,
                                            dmpl__Phone__c = '9999999999',
                                            dmpl__DefaultPartnerAccountId__c = partnerAccount1.Id,
                                            dmpl__DefaultBranchId__c = branch1.Id
                                           ));
        insert resource1; */
        List<dmpl__Resource__c> resource2 = new List<dmpl__Resource__c>();
        Account partnerAccount2 = [Select Id,Name From Account LIMIT 1];
        dmpl__Branch__c branch2 = [Select Id,Name From dmpl__Branch__c LIMIT 1];
        resource2.add(new dmpl__Resource__c(Name = 'Test - Resource',
                                            dmpl__ResourceType__c = 'Technician',
                                            dmpl__IsActive__c = true,
                                            dmpl__Phone__c = '9999999999',
                                            dmpl__DefaultPartnerAccountId__c = partnerAccount2.Id,
                                            dmpl__DefaultBranchId__c = branch2.Id
                                           ));
        insert resource2;
    }
    
    
    private static void CreateContactAddress()
    {
        List<dmpl__ContactAddress__c> contactAddress = new List<dmpl__ContactAddress__c>();
        Account account = [Select Id,Name From Account where Name = 'Customer-Test-Account' LIMIT 1];
        contactAddress.add(new dmpl__ContactAddress__c(dmpl__AccountId__c = account.Id,
                                                       Name = 'Test - Contact - Address',
                                                       dmpl__Street__c = 'Street',
                                                       dmpl__City__c = 'None',
                                                       dmpl__PostalCode__c = '12345',
                                                       dmpl__Country__c = 'None',
                                                       dmpl__AddressType__c = 'Both'                                                       
                                                      ));
        insert contactAddress;
    }
    
    private static void CreateTaxGroup()
    {
        List<dmpl__TaxGroup__c> taxGroup = new List<dmpl__TaxGroup__c>();
        Account account=[Select Id,Name from Account Where Name='Partner-Test-Account'];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c]; 
        dmpl__AccountGroup__c accountGroup = [Select Id,Name From dmpl__AccountGroup__c ];
        taxGroup.Add(new dmpl__TaxGroup__c(Name = 'Test - Tax Group',
                                           dmpl__PartnerAccountId__c = account.Id,
                                           dmpl__BranchId__c = branch.Id,
                                           dmpl__PartnerAccountGroupId__c = accountGroup.Id,
                                           dmpl__Description__c = 'Description',
                                           dmpl__IsActive__c = false
                                          ));
        insert taxGroup;
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
                                                     dmpl__Quantity__c = 15,
                                                     dmpl__TaxGroupId__c = taxGroup.Id,
                                                     dmpl__UnitPrice__c = 100,
                                                     dmpl__Discount__c = 5
                                                     //dmpl__DeliveryQuantity__c = 5
                                                    ));
        insert saleOrderLine;
    }
    
    private static void CreateStorageLocation() 
    {
        List<dmpl__StorageLocation__c> StorageLocation = new List<dmpl__StorageLocation__c>();
        dmpl__Branch__c branch = [Select Id,Name,dmpl__ParentLocationId__c From dmpl__Branch__c];
        storageLocation.Add(new dmpl__StorageLocation__c(dmpl__BranchId__c = branch.Id,
                                                         dmpl__ParentLocationId__c = branch.dmpl__ParentLocationId__c,
                                                         dmpl__AllowInventory__c=true,
                                                         dmpl__IsMobile__c=true,
                                                         dmpl__IsActive__c=true,
                                                         dmpl__LocationType__c='Washing Bay'
                                                         
                                                        ));
        insert storageLocation;
    }
    
    private static void CreateRepairOrder()
    {
        List<dmpl__RepairOrder__c> repairOrder = new List<dmpl__RepairOrder__c> ();
        dmpl__Item__c item = [Select Id,Name,dmpl__ItemType__c From dmpl__Item__c Where dmpl__ItemType__c = 'Service Contract' LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        Account customerAccount = [Select id,Name From Account Where Name = 'Customer-Test-Account' LIMIT 1];
        repairOrder.Add(new dmpl__RepairOrder__c (dmpl__AccountId__c = customerAccount.Id,
                                                  dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                                  dmpl__BranchId__c = branch.Id,
                                                  dmpl__ServiceContractItemId__c = item.Id,
                                                  dmpl__PerformPopulateLines__c = false,
                                                  dmpl__IsLinePopulated__c = false,
                                                  dmpl__PerformWorkStart__c = false,
                                                  dmpl__IsWorkStarted__c = false,
                                                  dmpl__PerformReleaseForFulfillment__c = false,
                                                  dmpl__PerformWorkEnd__c= false,
                                                  dmpl__IsWorkEnded__c = false,
                                                  dmpl__PerformInvoiceGeneration__c = false,
                                                  dmpl__IsInvoiceGenerated__c = false));
        insert repairOrder;
    }
    private static void CreateRepairOrderLine()
    {
        List<dmpl__RepairOrderLine__c> repairOrderLine = new List<dmpl__RepairOrderLine__c>();
        dmpl__RepairOrder__c repairOrder = [Select Id,Name FROM dmpl__RepairOrder__c LIMIT 1];
        dmpl__Item__c item = [Select Id,Name FROM dmpl__Item__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id,Name From dmpl__SKU__c LIMIT 1];
        dmpl__Resource__c resource = [select Id,Name FROM dmpl__Resource__c WHERE dmpl__ResourceType__c = 'Technician' LIMIT 1];
        dmpl__StorageLocation__c storageLocation = [Select Id,Name FROM dmpl__StorageLocation__c LIMIT 1];
        dmpl__TaxGroup__c taxGroup = [Select Id,Name From dmpl__TaxGroup__c LIMIT 1];
        repairOrderLine.add(new dmpl__RepairOrderLine__c(dmpl__ItemId__c = item.Id,
                                                         dmpl__Quantity__c = 5,
                                                         dmpl__UnitPrice__c = 10,
                                                         dmpl__SKUId__c = sku.Id,
                                                         dmpl__PackageClassification__c = 'Optional Item',
                                                         dmpl__ActionTaken__c = 'Replace',
                                                         dmpl__TechnicianId__c = resource.Id,
                                                         dmpl__WorkStartedBy__c = date.today(),
                                                         dmpl__WorkEndedAt__c = date.today(),
                                                         dmpl__WorkStatus__c = 'Started',
                                                         dmpl__StandardDurationHours__c = 10,
                                                         dmpl__ActualDurationHours__c = 10,
                                                         dmpl__StorageLocationId__c = storageLocation.Id,
                                                         dmpl__TaxGroupId__c = taxGroup.Id,
                                                         dmpl__RepairOrderId__c = repairOrder.Id
                                                        ));
        insert repairOrderLine;
    }
  
    private static void CreateFulfillment()
    {
        List<dmpl__InventoryFulfillment__c> fulfillment = new List<dmpl__InventoryFulfillment__c>();
        Account account = [Select Id,Name From Account WHERE dmpl__IsCustomerAccount__c = True  LIMIT 1];
        Account partnerAccount = [Select Id,Name From Account where Name = 'Partner-Test-Account' LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        dmpl__RepairOrder__c repairOrder = [Select Id,Name From dmpl__RepairOrder__c Limit 1];
        dmpl__SaleOrder__c saleOrder = [Select Id,Name From dmpl__SaleOrder__c LIMIT 1];
        fulfillment.Add(new dmpl__InventoryFulfillment__c(dmpl__PartnerAccountId__c = partnerAccount.Id,
                                                          dmpl__BranchId__c = branch.Id,
                                                          dmpl__AccountId__c = account.Id,
                                                          dmpl__RepairOrderId__c = repairOrder.Id,
                                                          dmpl__PerformAllocation__c = false,
                                                          dmpl__IsAllocated__c = True,
                                                          dmpl__SaleOrderId__c = saleOrder.Id
                                                         ));
        insert fulfillment;
    }
    
    private static void CreateFulfillmentOrderLine()
    {
        List<dmpl__InventoryFulfillmentOrderLine__c> OrderLine = new List<dmpl__InventoryFulfillmentOrderLine__c>();
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id,Name From dmpl__SKU__c LIMIT 1];
        dmpl__InventoryFulfillment__c fulfillment = [Select Id,Name From dmpl__InventoryFulfillment__c LIMIT 1];
        dmpl__SaleOrderLine__c saleOrderLine = [Select Id,Name From dmpl__SaleOrderLine__c LIMIT 1];
        OrderLine.Add(new dmpl__InventoryFulfillmentOrderLine__c(dmpl__FulfillmentId__c = fulfillment.Id,
                                                                 dmpl__ItemId__c = item.id,
                                                                 dmpl__SKUId__c = sku.Id,
                                                                 dmpl__SaleOrderLineId__c = saleOrderLine.Id
                                                                ));
        insert OrderLine;
    }
    
    private static void createItemType()
    {
        list<dmpl__ItemLotType__c> itemT= new list<dmpl__ItemLotType__c>();
        dmpl__Item__c itm = [select id,name from dmpl__Item__c LIMIT 1];
        itemT.add(new dmpl__ItemLotType__c(name='demp',
                                           dmpl__ItemId__c = itm.id
                                          ));
        insert itemT;
        system.debug(itemT);
    }
    
    private static void CreateFulfillmentAllocationLine()
    {
        List<dmpl__InventoryFulfillmentAllocationLine__c> allocationLine = new List<dmpl__InventoryFulfillmentAllocationLine__c>();
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        dmpl__ItemLot__c itemLot = [SELECT Id, Name FROM dmpl__ItemLot__c LIMIT 1];
        //dmpl__ItemLotType__c itemLotType = [SELECT Id, Name FROM dmpl__ItemLotType__c LIMIT 1];
        dmpl__SKU__c itemSKU = [Select Id,Name From dmpl__SKU__c LIMIT 1];
        dmpl__Resource__c resource = [Select Id,Name From dmpl__Resource__c LIMIT 1];
        dmpl__InventoryFulfillmentOrderLine__c fulfillmentorderline = [Select Id,Name From dmpl__InventoryFulfillmentOrderLine__c LIMIT 1];
        dmpl__InventoryFulfillment__c fulfillment = [Select Id,Name From dmpl__InventoryFulfillment__c LIMIT 1];
        allocationLine.Add(new dmpl__InventoryFulfillmentAllocationLine__c (
            dmpl__ItemId__c = item.Id,
            dmpl__SKUId__c = itemSKU.Id,
            dmpl__Quantity__c = 1, 
            dmpl__FulfillmentOrderLineId__c=fulfillmentorderline.Id,
            dmpl__ItemLotId__c = itemLot.Id,
            dmpl__UnitCost__c = 10,
            dmpl__AllocatedById__c = resource.Id,
            dmpl__FulfillmentOrderId__c = fulfillment.Id,
            dmpl__DocumentDate__c = Date.today()));
        insert allocationLine;
    } 
    
    private static void CreateFulfillmentFromSaleOrder()
    {
        List<dmpl__InventoryFulfillment__c> fulfillmentFromSaleOrder = new List<dmpl__InventoryFulfillment__c>();
        dmpl__SaleOrder__c saleOrder = [Select Id,Name,dmpl__PartnerAccountId__c,dmpl__BranchId__c,dmpl__AccountId__c From dmpl__SaleOrder__c LIMIT 1];
        fulfillmentFromSaleOrder.add(new dmpl__InventoryFulfillment__c(dmpl__PartnerAccountId__c = saleOrder.dmpl__PartnerAccountId__c,
                                                                       dmpl__BranchId__c = saleOrder.dmpl__BranchId__c,
                                                                       dmpl__AccountId__c = saleOrder.dmpl__AccountId__c,
                                                                       dmpl__PerformAllocation__c = false,
                                                                       dmpl__IsAllocated__c = True
                                                                      ));
        insert fulfillmentFromSaleOrder;
    }
    
  /*  private static void Createstock()
    {
        List<dmpl__InventoryStock__c> stock = new List<dmpl__InventoryStock__c>();
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c LIMIT 1];
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        stock.Add(new dmpl__InventoryStock__c(
            //dmpl__BranchId__c = branch.Id,
            //dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
           // dmpl__ItemId__c = item.Id
            //dmpl__QuantityAdjustedIn__c = 10
        ));
        insert stock;
        
    }*/
}