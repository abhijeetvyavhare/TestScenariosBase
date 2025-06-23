@isTest
public class InventoryCycleCountHelper_Test {
    
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
            //CreateItemLot();
            CreateResource();
           // CreateStock();
            CreateCycleCount();
            CreateCycleCountLine();
        }
    }
    
    @isTest
    private static void ItemGroupMemberProcessor1()
    {
        test.startTest();
        CreateCycleCount1();
        CreateInterfaceQueue();
        dmpl__InventoryCycleCount__c campaign = [Select Id,Name From dmpl__InventoryCycleCount__c where dmpl__DynamicMemberType__c='Report Data' LIMIT 1];
        dmpl__InventoryCycleCountRule__c rule = [Select Id,Name,dmpl__Operation__c From dmpl__InventoryCycleCountRule__c LIMIT 1];
        dmpl__InterfaceQueue__c queue =[Select Id, Name,dmpl__QueueType__c from dmpl__InterfaceQueue__c Limit 1];
        InventoryCycleCountCleaner obj = new InventoryCycleCountCleaner(campaign.Id,queue.Id,rule.Id);
        Database.executeBatch(obj);
        test.stopTest();
    }
    
    @isTest
    private static void VerifyServiceCampaignMemberProcessor()
    {
        try{
            test.startTest();
            CreateInterfaceQueue();
            dmpl__InventoryCycleCount__c campaign = [Select Id,Name From dmpl__InventoryCycleCount__c LIMIT 1];
            dmpl__InterfaceQueue__c queue =[Select Id, Name,dmpl__QueueType__c,dmpl__IsSuccessful__c from dmpl__InterfaceQueue__c Limit 1];
            InventoryCycleCountProcessor.perfromAction(campaign.Id,queue.Id);
            test.stopTest();
        }
        catch(Exception e){}
    }
    
    @isTest
    private static void VerifyServiceCampaignMember()
    {
        try{
            test.startTest();
            CreateCycleCount1();
            CreateInterfaceQueue();
            dmpl__InventoryCycleCount__c campaign = [Select Id,Name From dmpl__InventoryCycleCount__c where dmpl__DynamicMemberType__c='Report Data' LIMIT 1];
            dmpl__InterfaceQueue__c queue =[Select Id, Name,dmpl__QueueType__c,dmpl__IsSuccessful__c from dmpl__InterfaceQueue__c Limit 1];
            InventoryCycleCountProcessor.perfromAction(campaign.Id,queue.Id);
            test.stopTest();
        }
        catch(Exception e){}
    } 
    
    @IsTest
    Public static void verifyCycleCountLine()
    {
        Test.startTest();
        string errorReceived;
        try{             
            List<dmpl__InventoryStock__c> stock=[Select Id, dmpl__ItemId__c,dmpl__SKUId__c,dmpl__StorageLocationId__c, Name From dmpl__InventoryStock__c Limit 1];
            dmpl__InventoryCycleCount__c cycleCount =[Select Id, Name From dmpl__InventoryCycleCount__c Limit 1];
            List<dmpl__ItemLot__c> newLots=[Select Id, dmpl__UnitCost__c, Name,dmpl__StorageLocationId__c, dmpl__ItemId__c,dmpl__SKUId__c,dmpl__QuantityInHand__c,dmpl__ItemLotTypeId__c from  dmpl__ItemLot__c Limit 1];
            List<dmpl__ItemLot__c> filterLots=[Select Id,dmpl__UnitCost__c, dmpl__StorageLocationId__c, Name,dmpl__ItemId__c,dmpl__SKUId__c,dmpl__QuantityInHand__c,dmpl__ItemLotTypeId__c from  dmpl__ItemLot__c Limit 1];
            //InventoryCycleCountLineHelper.getNewCycleCountLines(cycleCount,newLots,5,stock,'','',filterLots,3);    
        } catch (Exception ex) {
            errorReceived = ex.getMessage();
        }
        System.assertEquals(null, errorReceived);
        Test.stopTest();
        
    }
    
     @IsTest
    Public static void createCycleCountLines()
    {
        Test.startTest();
        string errorReceived;
        try{             
          //  List<dmpl__InventoryStock__c> stock=[Select Id, dmpl__ItemId__c,dmpl__SKUId__c,dmpl__StorageLocationId__c, Name From dmpl__InventoryStock__c Limit 1];
            List<dmpl__InventoryCycleCount__c> cycleCounts =[Select Id, Name,
                                                             dmpl__BranchId__c,
                                                             dmpl__StorageLocationId__c,
                                                             dmpl__MaximumItems__c,
                                                             dmpl__PartnerAccountId__c,
                                                             dmpl__ItemGroupId__c,
                                                             dmpl__AdjustmentId__c,
                                                             dmpl__CountQuantityType__c,
                                                             dmpl__FilterABC__c,dmpl__FilterFSN__c,dmpl__ItemId__c From dmpl__InventoryCycleCount__c];
           // List<dmpl__ItemLot__c> newLots=[Select Id, dmpl__UnitCost__c, Name,dmpl__StorageLocationId__c, dmpl__ItemId__c,dmpl__SKUId__c,dmpl__QuantityInHand__c,dmpl__ItemLotTypeId__c from  dmpl__ItemLot__c Limit 1];
           // List<dmpl__ItemLot__c> filterLots=[Select Id,dmpl__UnitCost__c, dmpl__StorageLocationId__c, Name,dmpl__ItemId__c,dmpl__SKUId__c,dmpl__QuantityInHand__c,dmpl__ItemLotTypeId__c from  dmpl__ItemLot__c Limit 1];
           (new InventoryCycleCountHelper()).createCycleCountLines(cycleCounts);    
            (new InventoryCycleCountHelper()).startCounting(cycleCounts);    
            (new InventoryCycleCountHelper()).finishCounting(cycleCounts);    
            (new InventoryCycleCountHelper()).releaseAdjustment(cycleCounts);    
        } catch (Exception ex) {
            errorReceived = ex.getMessage();
        }
        System.assertEquals(null, errorReceived);
        Test.stopTest();
        
    }
    
    @isTest
    public static void UpdateCycleCountAsStartCounting()
    {
        test.startTest();
        string errorReceived;
        try{
        dmpl__InventoryCycleCount__c cycleCount = [Select Id,Name,dmpl__PerformStartCounting__c From dmpl__InventoryCycleCount__c LIMIT 1];
        cycleCount.dmpl__PerformStartCounting__c = False;
        cycleCount.dmpl__PerformStartCounting__c = True;
        update cycleCount;
        System.assert(cycleCount != null, 'Sale Order has 1 Record Updated');
            } catch (Exception ex) {
            errorReceived = ex.getMessage();
        }
        test.stopTest();
    } 
    
    @isTest
    public static void UpdateCycleCountAsReleasedAdjustment()
    {
        test.startTest();
        dmpl__InventoryCycleCount__c cycleCount = [Select Id,Name,dmpl__PerformReleaseAdjustment__c From dmpl__InventoryCycleCount__c LIMIT 1];
        cycleCount.dmpl__PerformReleaseAdjustment__c = True;
        update cycleCount;
        System.assertEquals(True, cycleCount.dmpl__PerformReleaseAdjustment__c, 'Sale Order has 1 Record Updated');
        test.stopTest();
    }
    
    @isTest
    public static void UpdateCycleCountAsFinishCounting()
    {
        test.startTest();
        dmpl__InventoryCycleCount__c cycleCount = [Select Id,Name,dmpl__PerformFinishCounting__c From dmpl__InventoryCycleCount__c LIMIT 1];
        cycleCount.dmpl__PerformFinishCounting__c = True;
        update cycleCount;
        System.assertEquals(True, cycleCount.dmpl__PerformFinishCounting__c, 'Sale Order has 1 Record Updated');
        test.stopTest();
    } 
    
    @isTest
    public static void DeleteCycleCount()
    {
        test.startTest();
        List<dmpl__InventoryCycleCount__c> cycleCount = [Select Id,Name From dmpl__InventoryCycleCount__c LIMIT 1];
        if(cycleCount != null)
            Delete cycleCount;
        System.assert(cycleCount.size() != 0);
        test.stopTest();
    } 
    
    @isTest
    public static void VerifyCyceleCOuntLine()
    {
        test.startTest();
        dmpl__InventoryCycleCountLine__c inventoryCycleCountLine = [Select Id,Name,dmpl__PickedQuantity__c From dmpl__InventoryCycleCountLine__c LIMIT 1];
        if(inventoryCycleCountLine != null)
            inventoryCycleCountLine.dmpl__PickedQuantity__c = 5;
        update inventoryCycleCountLine;
        System.assertEquals(5, inventoryCycleCountLine.dmpl__PickedQuantity__c, 'Sale Order has 1 Record Deleted');
        test.stopTest();
    }
    
    @isTest
    private static void VerifyHeadlessActionMethod()
    {
        test.startTest();
        dmpl__InventoryCycleCount__c cycleCount = [Select Id,Name From dmpl__InventoryCycleCount__c LIMIT 1];
        HeadlessCallableController.callHeadlessAction('headlessAction','dmpl__InventoryCycleCount__c',cycleCount.Id);
        test.stopTest();
    }
     @isTest
    private static void InventoryCycleCountCleanerConstructorTest()
    {
        test.startTest();
        InventoryCycleCountCleaner instance=new InventoryCycleCountCleaner(null,null);
        test.stopTest();
    }
     @isTest
    private static void createCycleCountLineTest()
    {
        test.startTest();
        dmpl__InventoryCycleCount__c cycleCount = [Select Id,Name From dmpl__InventoryCycleCount__c  LIMIT 1];
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        InventoryCycleCountHelper instanceInventoryCycleCountHelper=new InventoryCycleCountHelper();
        instanceInventoryCycleCountHelper.createCycleCountLine(cycleCount,item);
        instanceInventoryCycleCountHelper.createCycleCountLineForStock(cycleCount,item);
        instanceInventoryCycleCountHelper.createCycleCountLinesForLot(cycleCount,item);
        instanceInventoryCycleCountHelper.deleteCycleCountLinesFromCycleCount(new list<dmpl__InventoryCycleCount__c>{cycleCount});
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
                                dmpl__LastName__c = 'Cycle Count',
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
                                             dmpl__LastName__c = 'Cycle Count',
                                             dmpl__IsPartnerAccount__c = True, 
                                             dmpl__IsActive__c = true);
        insert partneraccount;
        
        
        Account customerAccount = new Account(Name = 'Customer-Test-Account',
                                              dmpl__LastName__c = 'Cycle Count',
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
    
    private static void CreateStorageLocation()
    {
        List<dmpl__StorageLocation__c> storageLocation =  new List<dmpl__StorageLocation__c>();
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
    
   /* private static void CreateItemLot()
    {
        List<dmpl__ItemLot__c> itemLot = new List<dmpl__ItemLot__c>();
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        dmpl__StorageLocation__c storageLocation = [Select Id, Name FROM dmpl__StorageLocation__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id ,Name,dmpl__ItemId__c From dmpl__SKU__c LIMIT 1 ];
        itemLot.Add(new dmpl__ItemLot__c(dmpl__BranchId__c = branch.Id,
                                         dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                         dmpl__ItemId__c = sku.dmpl__ItemId__c,
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
                                       //  dmpl__QuantityAdjustedIn__c = 20,
                                       //  dmpl__QuantityAdjustedOut__c = 5,
                                       //  dmpl__QuantityAssembledIn__c = 10,
                                       //  dmpl__QuantityAssembledOut__c = 8,
                                       //  dmpl__QuantityPurchased__c = 10,
                                       //  dmpl__QuantitySold__c = 5,
                                       //  dmpl__QuantityTransferIn__c = 8,
                                       //  dmpl__QuantityTransferOut__c = 3,
                                       //  dmpl__QuantityOnInward__c =5,
                                       // dmpl__QuantityOnOutward__c = 2,
                                       // dmpl__QuantityInTransit__c = 10
                                        ));
        insert itemLot;
        
    }
    
    Private static void CreateStock()
    {
        List<dmpl__InventoryStock__c> stock = new List<dmpl__InventoryStock__c>();
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        dmpl__StorageLocation__c storageLocation = [Select Id, Name FROM dmpl__StorageLocation__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id,Name From dmpl__SKU__c LIMIT 1];
        stock.add(new dmpl__InventoryStock__c(
                                                //dmpl__BranchId__c = branch.Id,
                                               // dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c
                                              //dmpl__BranchId__c = branch.Id,
                                              //dmpl__FinancialYear__c = 2,
                                              //dmpl__ItemId__c = item.Id,
                                              //dmpl__SKUId__c = sku.id,
                                             // dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c
                                             // dmpl__QuantityAdjustedIn__c = 20,
                                             // dmpl__QuantityAdjustedOut__c = 5,
                                             // dmpl__QuantityAssembledIn__c = 10,
                                             // dmpl__QuantityAssembledOut__c = 8,
                                             // dmpl__QuantityPurchased__c = 10,
                                             // dmpl__QuantitySold__c = 5,
                                             // dmpl__QuantityTransferIn__c = 8,
                                             // dmpl__QuantityTransferOut__c = 3,
                                             // dmpl__QuantityOnInward__c =5,
                                             // dmpl__QuantityOnOutward__c = 2,
                                             // dmpl__QuantityInTransit__c = 10,
                                             // dmpl__QuantityInPipeline__c = 7
                                             ));
        insert stock;
    }*/
    
    private static void CreateCycleCount()
    {
        List<dmpl__InventoryCycleCount__c> cycleCount = new List<dmpl__InventoryCycleCount__c>();
        Account account = [Select Id,Name From Account LIMIT 1];
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c LIMIT 1];
        //dmpl__StorageLocation__c storageLocation = [Select Id,Name From dmpl__StorageLocation__c LIMIT 1];
        //dmpl__Resource__c resource = [Select Id,Name From dmpl__Resource__c LIMIT 1];
        cycleCount.add(new dmpl__InventoryCycleCount__c(dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                                        dmpl__BranchId__c = branch.Id,
                                                        //dmpl__AssignedToId__c = resource.Id,
                                                        //dmpl__StorageLocationId__c = storageLocation.Id,
                                                        dmpl__PerformStartCounting__c = false,
                                                        dmpl__PerformFinishCounting__c = false,                                                 
                                                        dmpl__PerformReleaseAdjustment__c = false,                                                 
                                                        dmpl__ItemId__c = item.Id,
                                                        dmpl__MaximumItems__c = 2,
                                                        dmpl__ManufacturingDateFrom__c = date.today(),
                                                        dmpl__ManufacturingDateTo__c = date.today(),
                                                        dmpl__PartCostFrom__c = 40,
                                                        dmpl__PartCostTo__c = 50,
                                                        dmpl__PartStockFrom__c = 40,
                                                        dmpl__PartStockTo__c = 50));
        insert cycleCount;
        
    }
    
    private static void CreateCycleCountLine()
    {
        List<dmpl__InventoryCycleCountLine__c> cycleCountLine = new List<dmpl__InventoryCycleCountLine__c>();
        dmpl__InventoryCycleCount__c cycleCount = [Select Id,Name From dmpl__InventoryCycleCount__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id,Name From dmpl__SKU__c LIMIT 1];
        dmpl__StorageLocation__c storageLocation = [Select Id,Name From dmpl__StorageLocation__c LIMIT 1];
        //dmpl__ItemLot__c itemLot = [Select Id,Name,dmpl__ItemId__c,dmpl__SKUId__c From dmpl__ItemLot__c LIMIT 1];
        cycleCountLine.add(new dmpl__InventoryCycleCountLine__c(dmpl__IsApproved__c = true,
                                                               // dmpl__ItemId__c = itemLot.dmpl__ItemId__c,
                                                               // dmpl__SKUId__c = itemLot.dmpl__SKUId__c,
                                                                //dmpl__ItemLotId__c = itemLot.Id,
                                                                dmpl__UnitCost__c = 100,
                                                                dmpl__OnHandQuantity__c = 10,
                                                                dmpl__PickedQuantity__c = 5,
                                                                dmpl__RecordedQuantity__c = 10,
                                                                dmpl__RecordedDamagedQuantity__c = 1,
                                                                dmpl__RecordedExpiredQuantity__c = 2,
                                                                //dmpl__StorageLocationId__c = storageLocation.Id,
                                                                dmpl__CycleCountId__c = cycleCount.Id,
                                                                dmpl__Remarks__c = 'Successfully Created'));
        insert cycleCountLine;
        
    }
    
     private static void CreateCycleCount1()
    {
        List<dmpl__InventoryCycleCount__c> cycleCount = new List<dmpl__InventoryCycleCount__c>();
        Account account = [Select Id,Name From Account LIMIT 1];
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c LIMIT 1];
        dmpl__StorageLocation__c storageLocation = [Select Id,Name From dmpl__StorageLocation__c LIMIT 1];
        //dmpl__Resource__c resource = [Select Id,Name From dmpl__Resource__c LIMIT 1];
        cycleCount.add(new dmpl__InventoryCycleCount__c(dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                                        dmpl__BranchId__c = branch.Id,
                                                        //dmpl__AssignedToId__c = resource.Id,
                                                        dmpl__StorageLocationId__c = storageLocation.Id,
                                                        dmpl__PerformStartCounting__c = false,
                                                        dmpl__PerformFinishCounting__c = false,                                                 
                                                        dmpl__PerformReleaseAdjustment__c = false,                                                 
                                                        dmpl__ItemId__c = item.Id,
                                                        dmpl__DynamicMemberType__c = 'Report Data',
                                                        dmpl__MaximumItems__c = 2,
                                                        dmpl__ManufacturingDateFrom__c = date.today(),
                                                        dmpl__ManufacturingDateTo__c = date.today(),
                                                        dmpl__PartCostFrom__c = 40,
                                                        dmpl__PartCostTo__c = 50,
                                                        dmpl__PartStockFrom__c = 40,
                                                        dmpl__PartStockTo__c = 50));
        insert cycleCount;
        List<dmpl__InventoryCycleCountLine__c> cycleCountLine = new List<dmpl__InventoryCycleCountLine__c>();
        dmpl__SKU__c sku = [Select Id,Name From dmpl__SKU__c LIMIT 1];
        //dmpl__StorageLocation__c storageLocation = [Select Id,Name From dmpl__StorageLocation__c LIMIT 1];
       // dmpl__ItemLot__c itemLot = [Select Id,Name,dmpl__ItemId__c,dmpl__SKUId__c From dmpl__ItemLot__c LIMIT 1];
        cycleCountLine.add(new dmpl__InventoryCycleCountLine__c(dmpl__IsApproved__c = true,
                                                               // dmpl__ItemId__c = itemLot.dmpl__ItemId__c,
                                                               // dmpl__SKUId__c = itemLot.dmpl__SKUId__c,
                                                               // dmpl__ItemLotId__c = itemLot.Id,
                                                                dmpl__UnitCost__c = 100,
                                                                dmpl__OnHandQuantity__c = 10,
                                                                dmpl__PickedQuantity__c = 5,
                                                                dmpl__RecordedQuantity__c = 10,
                                                                dmpl__RecordedDamagedQuantity__c = 1,
                                                                dmpl__RecordedExpiredQuantity__c = 2,
                                                                dmpl__StorageLocationId__c = storageLocation.Id,
                                                                dmpl__CycleCountId__c = cycleCount[0].Id,
                                                                dmpl__Remarks__c = 'Successfully Created'));
        insert cycleCountLine;
        
        List<dmpl__InventoryCycleCountRule__c> cycleCountRules= new List<dmpl__InventoryCycleCountRule__c>();
        cycleCountRules.add(new dmpl__InventoryCycleCountRule__c(dmpl__CycleCountId__c = cycleCount[0].Id,
                                                             dmpl__FieldValue__c ='Test-1',
                                                             dmpl__SequenceNumber__c = 1,
                                                             dmpl__Operation__c='equals',    
                                                             dmpl__FieldName__c = 'Service - Campaign'
                                                        ));
        
        insert cycleCountRules;
        
        
    }
    
    public static void CreateInterfaceQueue()
    {
        List<dmpl__InterfaceQueue__c> interfaceQueue1 =new List<dmpl__InterfaceQueue__c>();
        interfaceQueue1.Add(new dmpl__InterfaceQueue__c(dmpl__QueueType__c = 'Queueable',
                                                        dmpl__JobType__c = 'Item Group Member Processor'));
        insert interfaceQueue1;
    }
}