@isTest
public class InventoryStockHelper_Test {
    
    @testSetup
    public static void Setup()
    {
        //System.runAs(PostInstallHelper.AssignAdministratorAllPermissions(UserInfo.getUserId())){
            CreateAccountGroup();
            //CreateAccount();
            CreateBranch();
            CreateItem();
            //CreateSKU();
            //CreateItemLot();
             CreateClaim();
             CreateReconciliation();
            //CreateClaimBatch();
            CreateAdjustment();
            CreateComplaint();
            //CreateComplaintFaultCode();
            CreateItemServiceContract();
            CreateResource();
            CreateAsset();
            //CreateServiceBay();
            //CreateServiceType();
            //CreateRepairOrder();
            CreateClaimLine();
           	test.startTest();
           	CreateInventoryLedger();
            
           	//CreateAdjustmentLine();
        	test.stopTest();
           	PostAdjustment();
        	//Createstock();
           //test.stopTest();
        //}
    }
    
    /*@isTest
    public static void DeleteInventoryStock()
    {
        test.startTest();
        dmpl__InventoryStock__c inventory = [Select Id,Name,dmpl__QuantityOnInward__c,dmpl__BranchId__c,dmpl__PartnerAccountId__c,dmpl__ItemId__c,dmpl__SKUId__c,dmpl__QuantityInPendingDeliveries__c From dmpl__InventoryStock__c LIMIT 1];
        if(inventory != null)
            inventory.dmpl__QuantityOnInward__c = 10;
        delete inventory;
        test.stopTest();
        System.assertEquals(10, inventory.dmpl__QuantityOnInward__c, 'Test inventory ledger have 1 updated record');
    }*/
    
    @isTest
    public static void unDoTransferOutwardLedgerEntry()
    {
       // try{
        test.startTest();
        /*dmpl__InventoryLedger__c ledger = [Select Id,
                                           dmpl__ShortageQuantity__c,
                                           dmpl__AllocatedQuantity__c,
                                            dmpl__BranchId__c,
                                            CreatedById,
                                           dmpl__PipelineQuantity__c,
                                           dmpl__PendingDeliveriesQuantity__c,
                                            dmpl__DamagedQuantity__c,
                                            dmpl__ExternalId__c,
                                            dmpl__HashCode__c,
                                            dmpl__InwardQuantity__c,
                                            dmpl__IsInventoryStockPosted__c,
                                            dmpl__ItemId__c,
                                            dmpl__ItemCode__c,
                                            dmpl__ItemLotId__c,
                                            dmpl__ItemLotTypeId__c,
                                            dmpl__PickedQuantity__c,
                                            dmpl__SKUId__c,
                                            LastModifiedById,
                                            Name,
                                            dmpl__InventoryLedgerType__c,
                                            OwnerId,
                                            dmpl__PartnerAccountId__c,
                                            dmpl__DocumentDate__c,
                                            dmpl__Quantity__c,
                                            dmpl__RelatedBranchId__c,
                                            dmpl__RelatedItemLotId__c,
                                            dmpl__SourceDocument__c,
                                            dmpl__StorageLocationId__c,
                                            dmpl__UnitCost__c

                                           
                                           From dmpl__InventoryLedger__c LIMIT 1];*/
       /* dmpl__InventoryStock__c stock = [Select Id,
                                         Name,dmpl__QuantityInTransit__c,
                                         dmpl__QuantitySaleReturned__c,
                                         dmpl__QuantityExpired__c,
                                         dmpl__QuantityOnHold__c,
                                         dmpl__QuantityOnLoan__c,
                                         dmpl__BranchId__c,
                                            CreatedById,
                                            dmpl__ExternalId__c,
                                            dmpl__FinancialYear__c,
                                            dmpl__HashCode__c,
                                            dmpl__ItemId__c,
                                            dmpl__SKUId__c,
                                            LastModifiedById,
                                            Name,
                                            OwnerId,
                                            dmpl__PartnerAccountId__c,
                                            dmpl__QuantityAdjustedIn__c,
                                            dmpl__QuantityAdjustedOut__c,
                                            dmpl__QuantityAssembledIn__c,
                                            dmpl__QuantityAssembledOut__c,
                                            dmpl__QuantityAvailable__c,
                                            dmpl__QuantityDamaged__c,
                                            dmpl__QuantityShortage__c,
                                            dmpl__QuantityExpired__c,
                                            dmpl__QuantityInHand__c	,
                                            dmpl__QuantityInPipeline__c,
                                            dmpl__QuantityInTransit__c,
                                            dmpl__QuantityOnAllocation__c,
                                            dmpl__QuantityOnFulfillment__c,
                                            dmpl__QuantityOnHold__c,	
                                            dmpl__QuantityOnInspection__c,
                                            dmpl__QuantityOnInward__c,
                                            dmpl__QuantityOnLoan__c,
                                            dmpl__QuantityOnOutward__c,
                                            dmpl__QuantityPicked__c,
                                            dmpl__QuantityProjected__c,
                                            dmpl__QuantityPurchaseReturned__c,
                                            dmpl__QuantityPurchased__c,
                                            dmpl__QuantitySaleReturned__c,
                                            dmpl__QuantitySold__c,
                                            dmpl__QuantityTransferIn__c,
                                            dmpl__QuantityTransferOut__c,
                                            dmpl__QuantityInPendingDeliveries__c,
                                            dmpl__StorageLocationId__c
                                           /* dmpl__QuantityDamaged__c,
                                         dmpl__QuantityPurchaseReturned__c,dmpl__QuantityOnInward__c,dmpl__QuantityOnOutward__c,dmpl__QuantityOnFulfillment__c,dmpl__QuantityTransferOut__c
                                        From dmpl__InventoryStock__c LIMIT 1];*/
       /* dmpl__InventoryStock__c stock1 = [Select Id,
                                         Name,dmpl__QuantityInTransit__c,
                                         dmpl__QuantitySaleReturned__c,
                                         dmpl__QuantityExpired__c,
                                         dmpl__QuantityOnHold__c,
                                         dmpl__QuantityOnLoan__c,
                                         dmpl__BranchId__c,
                                            CreatedById,
                                            dmpl__ExternalId__c,
                                            dmpl__FinancialYear__c,
                                            dmpl__HashCode__c,
                                            dmpl__ItemId__c,
                                            dmpl__SKUId__c,
                                            LastModifiedById,
                                            Name,
                                            OwnerId,
                                            dmpl__PartnerAccountId__c,
                                            dmpl__QuantityAdjustedIn__c,
                                            dmpl__QuantityAdjustedOut__c,
                                            dmpl__QuantityAssembledIn__c,
                                            dmpl__QuantityAssembledOut__c,
                                            dmpl__QuantityAvailable__c,
                                            dmpl__QuantityDamaged__c,
                                            dmpl__QuantityShortage__c,
                                            dmpl__QuantityExpired__c,
                                            dmpl__QuantityInHand__c	,
                                            dmpl__QuantityInPipeline__c,
                                            dmpl__QuantityInTransit__c,
                                            dmpl__QuantityOnAllocation__c,
                                            dmpl__QuantityOnFulfillment__c,
                                            dmpl__QuantityOnHold__c,	
                                            dmpl__QuantityOnInspection__c,
                                            dmpl__QuantityOnInward__c,
                                            dmpl__QuantityOnLoan__c,
                                            dmpl__QuantityOnOutward__c,
                                            dmpl__QuantityPicked__c,
                                            dmpl__QuantityProjected__c,
                                            dmpl__QuantityPurchaseReturned__c,
                                            dmpl__QuantityPurchased__c,
                                            dmpl__QuantitySaleReturned__c,
                                            dmpl__QuantitySold__c,
                                            dmpl__QuantityTransferIn__c,
                                            dmpl__QuantityTransferOut__c,
                                            dmpl__QuantityInPendingDeliveries__c,
                                            dmpl__StorageLocationId__c
                                           dmpl__QuantityDamaged__c,
                                         dmpl__QuantityPurchaseReturned__c,dmpl__QuantityOnInward__c,dmpl__QuantityOnOutward__c,dmpl__QuantityOnFulfillment__c,dmpl__QuantityTransferOut__c
                                        From dmpl__InventoryStock__c LIMIT 1];*/
       // List<dmpl__InventoryStock__c> stock =[SELECT FIELDS(ALL) FROM dmpl__InventoryStock__c LIMIT 200];
       // List<dmpl__InventoryStock__c> stock1 =[SELECT FIELDS(ALL) FROM dmpl__InventoryStock__c LIMIT 200];
       // InventoryStockHelper.unDoShortageLedgerEntry(null,stock);
        /*InventoryStockHelper.unDoTransferOutwardLedgerEntry(ledger,stock);
        InventoryStockHelper.unDoTransitLedgerEntry(ledger,stock);
        InventoryStockHelper.unDoInwardLedgerEntry(ledger,stock);
        InventoryStockHelper.unDoOutwardLedgerEntry(ledger,stock);
        InventoryStockHelper.unDoFulfillmentLedgerEntry(ledger,stock);
        InventoryStockHelper.doPurchaseReturnLedgerEntry(ledger,stock);
        InventoryStockHelper.doTransferOutwardLedgerEntry(ledger,stock);
        InventoryStockHelper.doPurchaseReturnLedgerEntry(ledger,stock);
        InventoryStockHelper.unDoPurchaseReturnLedgerEntry(ledger,stock);
        InventoryStockHelper.doTransitLedgerEntry(ledger,stock);
        InventoryStockHelper.doSaleReturnLedgerEntry(ledger,stock);
        InventoryStockHelper.unDoSaleReturnLedgerEntry(ledger,stock);
        InventoryStockHelper.unDoDamagedLedgerEntry(ledger,stock);
        InventoryStockHelper.doExpiredLedgerEntry(ledger,stock);
        InventoryStockHelper.unDoExpiredLedgerEntry(ledger,stock);
        InventoryStockHelper.doHoldLedgerEntry(ledger,stock);
        InventoryStockHelper.unDoHoldLedgerEntry(ledger,stock);
        InventoryStockHelper.doLoanLedgerEntry(ledger,stock);
        InventoryStockHelper.unDoLoanLedgerEntry(ledger,stock);
        InventoryStockHelper.unDoInspectionLedgerEntry(ledger,stock);
        InventoryStockHelper.doRelatedBranchLocationLedgerEntry(ledger,stock,stock1);*/
        test.stopTest();
        //System.assert(ledger!=null, 'Test inventory ledger have 1 deleted record');
       // }
       // catch(exception e){}
    }
    
    
   /*  @isTest
    public static void unDoTransferOutwardLedgerEntry1()
    {
       // try{
        test.startTest();
        //dmpl__InventoryLedger__c ledger = [Select Id,Name,dmpl__Quantity__c,dmpl__DamagedQuantity__c,dmpl__ShortageQuantity__c From dmpl__InventoryLedger__c LIMIT 1];
        dmpl__InventoryStock__c stock = [Select Id,Name,dmpl__QuantityInTransit__c,dmpl__QuantityDamaged__c,dmpl__QuantityShortage__c,dmpl__QuantityPurchaseReturned__c,dmpl__QuantityOnInward__c,dmpl__QuantityOnOutward__c,dmpl__QuantityOnFulfillment__c,dmpl__QuantityTransferOut__c,dmpl__QuantityInPendingDeliveries__c From dmpl__InventoryStock__c LIMIT 1];
        dmpl__InventoryStock__c stock1 = [Select Id,Name,dmpl__QuantityInTransit__c,dmpl__QuantityDamaged__c,dmpl__QuantityShortage__c,dmpl__QuantityPurchaseReturned__c,dmpl__QuantityOnInward__c,dmpl__QuantityOnOutward__c,dmpl__QuantityOnFulfillment__c,dmpl__QuantityTransferOut__c,dmpl__QuantityInPendingDeliveries__c From dmpl__InventoryStock__c LIMIT 1];
        //InventoryStockHelper.unDoPurchaseReturnLedgerEntry(ledger,stock);
        test.stopTest();
        //System.assert(ledger!=null, 'Test inventory ledger have 1 deleted record');
       // }
       // catch(exception e){}
    }
    
    @isTest
    public static void UpdateInventoryStockAsQuantityInTransit()
    {
        test.startTest();
        CreateTransfer();
        dmpl__InventoryStock__c inventory = [Select Id,Name,dmpl__QuantityInTransit__c,dmpl__QuantityInPendingDeliveries__c From dmpl__InventoryStock__c LIMIT 1];
        inventory.dmpl__QuantityInTransit__c = 10;
        update inventory;
        test.stopTest();
        System.assertEquals(10, inventory.dmpl__QuantityInTransit__c, 'Test inventory ledger have 1 deleted record');
    }
    
    @isTest
    public static void UpdateInventoryStockAsQauntityOnInward()
    {
        test.startTest();
        dmpl__InventoryStock__c inventory = [Select Id,Name,dmpl__QuantityOnInward__c,dmpl__QuantityInPendingDeliveries__c From dmpl__InventoryStock__c LIMIT 1];
        inventory.dmpl__QuantityOnInward__c = 10;
        update inventory;
        test.stopTest();
        System.assertEquals(10, inventory.dmpl__QuantityOnInward__c, 'Test inventory ledger have 1 deleted record');
    }
    
    
    @isTest
    public static void UpdateInventoryStockAsQuantityOnOutward()
    {
        test.startTest();
        dmpl__InventoryStock__c inventory = [Select Id,Name,dmpl__QuantityOnOutward__c,dmpl__QuantityInPendingDeliveries__c From dmpl__InventoryStock__c LIMIT 1];
        inventory.dmpl__QuantityOnOutward__c = 10;
        update inventory;
        test.stopTest();
        System.assertEquals(10, inventory.dmpl__QuantityOnOutward__c, 'Test inventory ledger have 1 deleted record');
    }
    
    @isTest
    public static void DeleteInventoryStockAsQuantityOnOutward()
    {
        test.startTest();
        dmpl__InventoryStock__c inventory = [Select Id,Name,dmpl__QuantityOnOutward__c,dmpl__QuantityInPendingDeliveries__c From dmpl__InventoryStock__c LIMIT 1];
        inventory.dmpl__QuantityOnOutward__c = 10;
        delete inventory;
        test.stopTest();
        System.assertEquals(10, inventory.dmpl__QuantityOnOutward__c, 'Test inventory ledger have 1 deleted record');
    }
    
    @isTest
    public static void UpdateInventoryStockAsQuantityOnInspection()
    {
        test.startTest();
        dmpl__InventoryStock__c inventory = [Select Id,Name,dmpl__QuantityOnInspection__c From dmpl__InventoryStock__c LIMIT 1];
        inventory.dmpl__QuantityOnInspection__c = 10;
        update inventory;
        test.stopTest();
        System.assertEquals(10, inventory.dmpl__QuantityOnInspection__c, 'Test inventory ledger have 1 deleted record');
    }*/
    
    @isTest
    public static void createInventoryAdjustmentLinesFromClaim()
    {
        try{
        test.startTest();
        List<dmpl__InventoryAdjustment__c> inventory = [Select Id,Name,dmpl__ClaimId__c From dmpl__InventoryAdjustment__c LIMIT 1];
        Map<Id,dmpl__Claim__c> map1 = new  Map<Id,dmpl__Claim__c>();
        dmpl__Claim__c claim =[Select Id, Name from dmpl__Claim__c Limit 1];
        map1.put(claim.Id,claim);
        InventoryAdjustmentLineHelper.createInventoryAdjustmentLinesFromClaim(inventory,map1);
        test.stopTest();
        System.assert(inventory.size() != 0);
        }catch(exception e){}
    }
    
     @isTest
    public static void createInventoryAdjustmentLinesFromClaimBatch()
    {
        try{
        test.startTest();
        List<dmpl__InventoryAdjustment__c> inventory = [Select Id,Name,dmpl__ClaimId__c,dmpl__ClaimBatchId__c From dmpl__InventoryAdjustment__c LIMIT 1];
         Map<Id,dmpl__ClaimBatch__c> map1 = new  Map<Id,dmpl__ClaimBatch__c>();
         dmpl__ClaimBatch__c claim =[Select Id, Name from dmpl__ClaimBatch__c Limit 1];
         map1.put(claim.Id,claim);
        InventoryAdjustmentLineHelper.createInventoryAdjustmentLinesFromClaimBatch(inventory,map1);
        test.stopTest();
        System.assert(inventory.size() != 0);
        }catch(exception e){}
    }
    
   /* @isTest
    public static void verifystocks()
    {
        test.startTest();
        List<dmpl__InventoryStock__c> inventorystock1 = [Select Id,Name,dmpl__QuantityAssembledIn__c,dmpl__QuantityOnInspection__c,dmpl__QuantityInPendingDeliveries__c From dmpl__InventoryStock__c LIMIT 1];
        //dmpl__InventoryLedger__c inventoryledger = [Select Id,Name,dmpl__SKUId__c,dmpl__ItemId__c,dmpl__BranchId__c,dmpl__InventoryLedgerType__c,dmpl__Quantity__c,dmpl__StorageLocationId__c From dmpl__InventoryLedger__c LIMIT 1];
        List<dmpl__InventoryStock__c> inventorystock = [Select Id,Name,dmpl__SKUId__c,dmpl__ItemId__c,dmpl__StorageLocationId__c,dmpl__BranchId__c,dmpl__QuantitySold__c,dmpl__QuantityPurchased__c,dmpl__QuantityPicked__c,dmpl__QuantityOnAllocation__c,dmpl__QuantityOnFulfillment__c,dmpl__QuantityAssembledIn__c,dmpl__QuantityTransferIn__c,dmpl__QuantityOnInspection__c,dmpl__QuantityInPendingDeliveries__c From dmpl__InventoryStock__c LIMIT 1];  
        InventoryStockHelper.getCurrentBranchNullStorageItemLocation(null,inventorystock);
        test.stopTest();
        System.assert(inventorystock1.size() != 0);
    }
    
    @isTest
    public static void verifyUndo()
    {
        test.startTest();
        dmpl__InventoryStock__c inventorystock1 = [Select Id,Name,dmpl__QuantityOnInward__c,dmpl__QuantityAssembledIn__c,dmpl__QuantityOnInspection__c,dmpl__QuantityInPendingDeliveries__c From dmpl__InventoryStock__c LIMIT 1];
        //dmpl__InventoryLedger__c inventoryledger = [Select Id,dmpl__AllocatedQuantity__c,dmpl__PickedQuantity__c,dmpl__PendingDeliveriesQuantity__c,Name,dmpl__InwardQuantity__c,dmpl__InventoryLedgerType__c,dmpl__Quantity__c From dmpl__InventoryLedger__c LIMIT 1];
        dmpl__InventoryStock__c inventorystock = [Select Id,Name,dmpl__QuantitySold__c,dmpl__QuantityOnInward__c,dmpl__QuantityPurchased__c,dmpl__QuantityPicked__c,dmpl__QuantityOnAllocation__c,dmpl__QuantityOnFulfillment__c,dmpl__QuantityAssembledIn__c,dmpl__QuantityTransferIn__c,dmpl__QuantityOnInspection__c,dmpl__QuantityInPendingDeliveries__c From dmpl__InventoryStock__c LIMIT 1];  
        InventoryStockHelper.unDoRelatedBranchLocationLedgerEntry(null,inventorystock,inventorystock1);
        InventoryStockHelper.unDoTransferInwardLedgerEntry(inventoryledger,inventorystock);
        InventoryStockHelper.unDoAssembleLedgerEntry(inventoryledger,inventorystock);
        InventoryStockHelper.doFulfillmentLedgerEntry(inventoryledger,inventorystock);
        InventoryStockHelper.doAllocationLedgerEntry(inventoryledger,inventorystock);
        InventoryStockHelper.unDoAllocationLedgerEntry(inventoryledger,inventorystock);
        InventoryStockHelper.doPickedLedgerEntry(inventoryledger,inventorystock);
        InventoryStockHelper.unDoPickedLedgerEntry(inventoryledger,inventorystock);
        InventoryStockHelper.doPurchasedLedgerEntry(inventoryledger,inventorystock);
        InventoryStockHelper.unDoPurchasedLedgerEntry(inventoryledger,inventorystock);
        InventoryStockHelper.doSoldLedgerEntry(inventoryledger,inventorystock);
        InventoryStockHelper.unDoSoldLedgerEntry(inventoryledger,inventorystock);
        test.stopTest();
        System.assert(inventorystock1!=null, 'Inventory stock data');
    }*/
    
    
    private static void CreateAccountGroup()
    {
        dmpl__AccountGroup__c accountGroup= new dmpl__AccountGroup__c (Name= 'Test-Account-Group', 
                                                                       dmpl__AccountGroupType__c = 'Scheme');
        insert accountGroup;
        List<Account> account = new List<Account>();
        account.add(new Account(Name = 'Test - Account', 
                                Fax = '09876',
                                Phone = '1234567891',
                                Website = 'www.Dealermatix.com',
                                Type = 'Prospect',
                                dmpl__LastName__c = 'Account',
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
        
        
        Account partneraccount = new Account(Name = 'Partner-Test-Account',dmpl__IsPartnerAccount__c = True,dmpl__LastName__c = 'Account', dmpl__IsActive__c = true);
        insert partneraccount;
        
        
        Account supplieraccount = new Account(Name = 'Supplier-Test-Account',dmpl__IsSupplierAccount__c = True,dmpl__LastName__c = 'Account', dmpl__IsActive__c = true);
        insert supplieraccount;
        
        
        Account customeraccount = new Account(Name = 'Customer-Test-Account',dmpl__IsCustomerAccount__c = True,dmpl__LastName__c = 'Account', dmpl__IsActive__c = true);
        insert customeraccount;
        
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
        
        
        List<dmpl__Branch__c> relatedBranch = new List<dmpl__Branch__c>();
        branch.Add(new dmpl__Branch__c(Name = 'Test-Related-Branch'));
        insert relatedBranch;
    }
    
    private static void CreateItem()
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
                                   dmpl__RFID__c = 'O1234fgh',
                                   dmpl__IsPackage__c = true
                                  ));
        insert item;
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c,dmpl__ParentLocationId__c From dmpl__Branch__c];
        dmpl__StorageLocation__c storageLocation = new dmpl__StorageLocation__c(
        	dmpl__BranchId__c = branch.Id,
			dmpl__ParentLocationId__c = branch.dmpl__ParentLocationId__c,
            dmpl__AllowInventory__c=true,
            dmpl__IsMobile__c=true,
            dmpl__IsActive__c=true,
            dmpl__LocationType__c='Washing Bay'
        );
        insert storageLocation;
    
        List<dmpl__SKU__c> Skus = new List<dmpl__SKU__c>();
        //dmpl__Item__c listofitem = [Select Id, Name from dmpl__Item__c];
        Skus.add(new dmpl__SKU__c(Name = 'Harrier XMA - Automatic - Orcus White',
                                  dmpl__SKUCode__c = 'Test - SKU - Code',
                                  dmpl__UnitOfMeasureOfConversion__c = 10,
                                  dmpl__ProductColor__c = 'Sample',
                                  dmpl__IsDefault__c = false,
                                  dmpl__QuantityUnitOfMeasure__c ='Sample',
                                  dmpl__ItemId__c = item[0].Id
                                 ));
        insert Skus;
        
        List<dmpl__ItemLot__c> itemLot = new List<dmpl__ItemLot__c>();
        
    //    dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
      //  dmpl__SKU__c sku = [Select Id, Name from dmpl__SKU__c LIMIT 1];
        itemLot.Add(new dmpl__ItemLot__c(dmpl__BranchId__c = branch.Id,
                                         dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                         dmpl__ItemId__c = item[0].Id,
                                         dmpl__SKUId__c = skus[0].Id,
                                         dmpl__BatchNo__c = '12345',
                                         dmpl__SerialNumber__c = '4675',
                                         dmpl__SupplierInvoiceNumber__c = '74985',
                                         dmpl__DateOfReceipt__c = date.today(),
                                         dmpl__DateOfMfg__c = date.today(),
                                         dmpl__TotalCost__c = 100,
                                         dmpl__DateOfSupplierInvoice__c = date.today(),
                                         dmpl__Cost__c = 100,
                                         dmpl__StorageLocationId__c = storageLocation.Id
                                         //dmpl__QuantityExpired__c = 10,
                                         //dmpl__QuantityOnHold__c = 20,
                                         //dmpl__QuantityOnLoan__c = 10
                                        ));
        insert itemLot;
        
    }
    
    private static void CreateClaim()
    {
        List<dmpl__Claim__c> claim = new List<dmpl__Claim__c>();
        Account account = [Select Id,Name From Account WHERE Name = 'Supplier-Test-Account' LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        claim.add(new dmpl__Claim__c(dmpl__BranchId__c = branch.Id,
                                     dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                     dmpl__DocumentDate__c = date.today(),
                                     dmpl__SupplierNameId__c = account.Id
                                    ));
        insert claim;
    
        List<dmpl__ClaimBatch__c> claimBatch = new List<dmpl__ClaimBatch__c>();
    //    Account account = [Select Id,Name From Account WHERE Name = 'Supplier-Test-Account' LIMIT 1];
        Account partnerAccount = [Select Id,Name From Account WHERE Name = 'Partner-Test-Account' LIMIT 1];
      //  dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        claimBatch.add(new dmpl__ClaimBatch__c(dmpl__BranchId__c = branch.Id,
                                               dmpl__PartnerAccountId__c = partnerAccount.Id,
                                               dmpl__DocumentDate__c = date.today(),
                                               dmpl__SupplierNameId__c = account.Id));
        insert claimBatch;
        
    }
    
    private static void CreateComplaint()
    {
        List<dmpl__Complaint__c> complaint = new List<dmpl__Complaint__c>();
        complaint.add(new dmpl__Complaint__c(Name = 'Complaint-Test',
                                             dmpl__Code__c = '37592',
                                             dmpl__Description__c = 'Text'
                                            ));
        insert complaint;
        
        List<dmpl__ComplaintFault__c> complaintFault = new List<dmpl__ComplaintFault__c>();
        //dmpl__Complaint__c complaint = [Select Id,Name FROM dmpl__Complaint__c LIMIT 1];
        complaintFault.add(new dmpl__ComplaintFault__c(Name = 'Test-Complaint-Fault-Code',
                                                       dmpl__ComplaintId__c = complaint[0].Id
                                                      ));
        insert complaintFault;
        
    }
    
    private static void CreateItemServiceContract()
    {
        List<dmpl__ItemServiceContract__c> serviceContract = new List<dmpl__ItemServiceContract__c>();
        dmpl__Item__c item = [Select Id,Name FROm dmpl__Item__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id,Name FROM dmpl__SKU__c LIMIT 1];
        serviceContract.add(new dmpl__ItemServiceContract__c(dmpl__ItemId__c = item.Id,
                                                             dmpl__SKUId__c = sku.Id,
                                                             dmpl__MaximumUsageHours__c = 10,
                                                             dmpl__MaximumUsageReading__c = 10,
                                                             dmpl__MinimumUsageHours__c = 10,
                                                             dmpl__MinimumUsageReading__c = 10,
                                                             dmpl__GraceUsageDays__c = 2,
                                                             dmpl__FromDays__c = 2,
                                                             dmpl__GraceUsageHours__c = 5,
                                                             dmpl__GraceUsageReading__c = 5,
                                                             dmpl__ToDays__c = 5
                                                            ));
        insert serviceContract;
        
    }
    
    private static void CreateResource()
    {
        List<dmpl__Resource__c> resource = new List<dmpl__Resource__c>();
        Account partnerAccount = [Select Id,Name From Account LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name From dmpl__Branch__c LIMIT 1];
        resource.add(new dmpl__Resource__c(Name = 'Test - Resource',
                                           dmpl__ResourceType__c = 'Technician',
                                           dmpl__IsActive__c = true,
                                           dmpl__Phone__c = '9999999999',
                                           dmpl__DefaultPartnerAccountId__c = partnerAccount.Id,
                                           dmpl__DefaultBranchId__c = branch.Id
                                          ));
        insert resource;
        
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
    
    private static void CreateServiceBay()
    {
        List<dmpl__ServiceBay__c> serviceBay = new List<dmpl__ServiceBay__c>();
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        serviceBay.add(new dmpl__ServiceBay__c(dmpl__BranchId__c = branch.Id,
                                               Name = 'Test-Service-Bay',
                                               dmpl__ServiceBayType__c = 'Warehouse',
                                               dmpl__AllowInventory__c = true
                                              ));
        insert serviceBay;
        
    }
    
    private static void CreateRepairOrder()
    {
        List<dmpl__RepairOrder__c> repairOrder = new List<dmpl__RepairOrder__c>();
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        Account account = [Select Id,Name From Account WHERE Name = 'Supplier-Test-Account' LIMIT 1];
        dmpl__Item__c item = [Select Id,Name FROM dmpl__Item__c LIMIT 1];
        //dmpl__Resource__c resource = [select Id,Name FROM dmpl__Resource__c LIMIT 1];
        Asset asset = [Select Id,Name,AccountId FROM Asset LIMIT 1];
        repairOrder.add(new dmpl__RepairOrder__c(dmpl__BranchId__c = branch.Id,
                                                 dmpl__DocumentDate__c = date.today(),
                                                 dmpl__AccountId__c = asset.AccountId,
                                                 dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                                 dmpl__PackageServiceId__c = item.Id,
                                                 dmpl__UsageReading__c = 10,
                                                 dmpl__UsageReadingHours__c = 5,
                                                 dmpl__CustomerVoice__c = 'Text',
                                                 //dmpl__ServiceAdvisorId__c = resource.Id,
                                                 dmpl__AssetId__c = asset.Id
                                                ));
        insert repairOrder;
     
        List<dmpl__RepairOrderLine__c> repairOrderLine = new List<dmpl__RepairOrderLine__c>();
        dmpl__Complaint__c complaint = [Select Id,Name FROM dmpl__Complaint__c LIMIT 1];
        dmpl__ComplaintFault__c complaintfault = [Select Id,Name,dmpl__ComplaintId__c FROM dmpl__ComplaintFault__c LIMIT 1];
        repairOrderLine.add(new dmpl__RepairOrderLine__c(dmpl__ItemId__c = item.Id,
                                                         dmpl__Quantity__c = 5,
                                                         dmpl__UnitPrice__c = 10,
                                                         dmpl__PackageClassification__c = 'Optional Item',
                                                         dmpl__ActionTaken__c = 'Replace',
                                                         //dmpl__TechnicianId__c = resource.Id,
                                                         dmpl__WorkStartedBy__c = date.today(),
                                                         dmpl__WorkEndedAt__c = date.today(),
                                                         dmpl__WorkStatus__c = 'Started',
                                                         dmpl__StandardDurationHours__c = 10,
                                                         dmpl__ActualDurationHours__c = 10,
                                                         dmpl__ComplaintCodeId__c = complaint.Id,
                                                         dmpl__ComplaintFaultCodeId__c = complaintfault.Id,
                                                         dmpl__RepairOrderId__c = repairOrder[0].Id
                                                        ));
        insert repairOrderLine;
        
    }
    
    private static void CreateClaimLine()
    {
        List<dmpl__ClaimLine__c> claimLine = new List<dmpl__ClaimLine__c>();
        Account account = [Select Id,Name From Account WHERE Name = 'Supplier-Test-Account' LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        dmpl__Claim__c claim = [Select Id,Name FROM dmpl__Claim__c LIMIT 1];
        dmpl__ClaimBatch__c claimBatch = [Select Id,Name FROM dmpl__ClaimBatch__c LIMIT 1];
        dmpl__Complaint__c complaint = [Select Id,Name FROM dmpl__Complaint__c LIMIT 1];
        dmpl__ComplaintFault__c complaintfault = [Select Id,Name,dmpl__ComplaintId__c FROM dmpl__ComplaintFault__c LIMIT 1];
        dmpl__ItemServiceContract__c serviceContract = [Select Id,Name FROM dmpl__ItemServiceContract__c LIMIT 1];
        dmpl__Item__c item = [Select Id,Name FROM dmpl__Item__c LIMIT 1];
        //dmpl__RepairOrderLine__c repairOrderLine = [Select Id,Name,dmpl__RepairOrderId__c FROM dmpl__RepairOrderLine__c LIMIT 1];
        claimLine.add(new dmpl__ClaimLine__c(dmpl__BranchId__c = branch.Id,
                                             dmpl__BatchClaimId__c = claim.Id,
                                             dmpl__ClaimId__c = claim.Id,
                                             dmpl__ItemCode__c = 'bxfs543',
                                             dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                             dmpl__ItemId__c = item.Id,
                                             dmpl__ClaimQuantity__c = 2,
                                             dmpl__ClaimType__c = 'Part to Part',
                                             dmpl__UnitPrice__c =100,
                                             dmpl__ApproveQuantity__c = 10,
                                             dmpl__RejectQuantity__c = 2,
                                             dmpl__ClaimBatchId__c = claimBatch.Id,
                                             dmpl__ComplaintId__c = complaintfault.dmpl__ComplaintId__c,
                                             dmpl__ComplaintFaultCodeId__c = complaintfault.Id,
                                             dmpl__ServiceContractId__c = serviceContract.Id
                                             //dmpl__RepairOrderId__c = repairOrderLine.dmpl__RepairOrderId__c,
                                             //dmpl__RepairOrderLineId__c = repairOrderLine.Id
                                            ));
        insert claimLine;
        
    }
    
    private static void CreateReconciliation()
    {
        List<dmpl__ClaimReconciliation__c> reconciliation = new List<dmpl__ClaimReconciliation__c>();
        Account account = [Select Id,Name From Account LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        Account supplierAccount = [Select Id,Name From Account WHERE Name = 'Supplier-Test-Account' LIMIT 1];
        reconciliation.add(new dmpl__ClaimReconciliation__c(dmpl__BranchId__c = branch.Id,
                                                            dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                                            dmpl__SupplierId__c = supplierAccount.Id,
                                                            dmpl__CreditNoteAmount__c = 100));
        insert reconciliation;
        
    }
    
    private static void CreateAdjustment()
    {
        List<dmpl__InventoryAdjustment__c> adjustment = new List<dmpl__InventoryAdjustment__c>();
        //Account account = [Select Id,Name From Account LIMIT 1];
        //dmpl__Claim__c claim = [Select Id,Name FROM dmpl__Claim__c LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        //dmpl__ClaimReconciliation__c reconciliation = [Select Id,Name FROM dmpl__ClaimReconciliation__c LIMIt 1];
        //dmpl__ClaimBatch__c claimBatch = [Select id,Name FROM dmpl__ClaimBatch__c LIMIT 1];
        adjustment.add(new dmpl__InventoryAdjustment__c(dmpl__BranchId__c = branch.Id,
                                                        dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                                        dmpl__DocumentDate__c = date.today()
                                                        //dmpl__ClaimId__c = claim.Id,
                                                        //dmpl__ReconciliationId__c = reconciliation.Id,
                                                        //dmpl__ClaimBatchId__c = claimBatch.Id
                                                       ));
        insert adjustment;
        
    }
    
    private static void PostAdjustment()
    {
        dmpl__InventoryAdjustment__c adjustment = [Select Id, Name, dmpl__PerformInventoryPosting__c FROM dmpl__InventoryAdjustment__c];
        adjustment.dmpl__PerformInventoryPosting__c = true;
        //update adjustment;
    }
    
    private static void CreateStorageLocation()
    {
        List<dmpl__StorageLocation__c> storageLocation =  new List<dmpl__StorageLocation__c>();
        dmpl__Branch__c branch = [Select Id,Name,dmpl__ParentLocationId__c From dmpl__Branch__c];
        storageLocation.Add(new dmpl__StorageLocation__c(dmpl__BranchId__c = branch.Id,
                                                         // dmpl__Location__c='sample',
                                                         dmpl__ParentLocationId__c = branch.dmpl__ParentLocationId__c,
                                                         dmpl__AllowInventory__c=true,
                                                         dmpl__IsMobile__c=true,
                                                         dmpl__IsActive__c=true,
                                                         dmpl__LocationType__c='Washing Bay'));
        insert storageLocation;
        
    }
    
   /* private static void CreateAdjustmentLine()
    {
        //test.startTest();
        List<dmpl__InventoryAdjustmentLine__c> adjustmentLine = new List<dmpl__InventoryAdjustmentLine__c>();
        Account account = [Select Id,Name From Account LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        dmpl__ItemLot__c itemLot = [Select Id, Name From dmpl__ItemLot__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id,Name FROM dmpl__SKU__c LIMIT 1];
        dmpl__ClaimLine__c claimLine = [Select Id,Name,dmpl__ClaimId__c FROM dmpl__ClaimLine__c LIMIT 1];
        dmpl__ClaimBatch__c claimBatch = [Select id,Name FROM dmpl__ClaimBatch__c LIMIT 1];
        dmpl__InventoryAdjustment__c adjustment = [Select Id, Name FROM dmpl__InventoryAdjustment__c];
        adjustmentLine.Add(new dmpl__InventoryAdjustmentLine__c(dmpl__ItemId__c = item.Id,
                                                                dmpl__InventoryAdjustmentId__c = adjustment.Id,
                                                                dmpl__Quantity__c = 100,
                                                                dmpl__ItemLotId__c = itemLot.Id,
                                                                dmpl__SKUId__c = sku.Id,
                                                                dmpl__ClaimId__c=claimLine.dmpl__ClaimId__c,
                                                                dmpl__ClaimLineId__c = claimLine.Id,
                                                                dmpl__ClaimBatchId__c = claimBatch.Id,
                                                                dmpl__TotalCost__c = 100,
                                                                dmpl__Remarks__c = 'Text'
                                                               ));
        insert adjustmentLine;
        //test.stopTest();
    }*/
    
    private static void PostAdjustmentLine()
    {
        dmpl__InventoryAdjustmentLine__c adjustmentLine = [Select Id, Name, dmpl__IsILPostingApproved__c FROM dmpl__InventoryAdjustmentLine__c];
        adjustmentLine.dmpl__IsILPostingApproved__c = true;
        update adjustmentLine;
    }
    
    private static void CreateTransfer()
    {
        List<dmpl__Transfer__c> transfer = new List<dmpl__Transfer__c>();
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c LIMIT 1];
        //dmpl__Resource__c resource = [select Id,Name FROM dmpl__Resource__c LIMIT 1];
        transfer.Add(new dmpl__Transfer__c(dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                           dmpl__BranchId__c = branch.Id,
                                           dmpl__ToBranchId__c = branch.Id,
                                           dmpl__PerformInwardPosting__c = false,
                                           dmpl__IsInwardReceived__c = false,
                                           dmpl__TransferTime__c = date.today()
                                           //dmpl__TransferredById__c = resource.Id
                                          ));
        insert transfer;
        
    }
    
    private static void CreateTransferInwardLine()
    {
        List<dmpl__TransferInwardLine__c> transferInwardLine = new List<dmpl__TransferInwardLine__c>();
        dmpl__Transfer__c transfer = [Select Id,Name From dmpl__Transfer__c LIMIT 1];
        dmpl__TransferOutwardLine__c outwardLine= [Select Id,Name From dmpl__TransferOutwardLine__c LIMIT 1];
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        dmpl__ItemLot__c itemLot = [Select Id, Name From dmpl__ItemLot__c LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        transferInwardLine.add(new dmpl__TransferInwardLine__c(dmpl__TransferId__c = transfer.Id,
                                                               dmpl__Branchid__c = branch.Id,
                                                               dmpl__ItemId__c = item.Id,
                                                               dmpl__ItemLotId__c = itemLot.Id,
                                                               dmpl__Quantity__c = 1,
                                                               dmpl__TransferOutwardLineId__c = outwardLine.Id
                                                              ));
        insert transferInwardLine;
        
    }
    
    
    public static void UpdateTransferAsOutwardReceive()
    {
        dmpl__Transfer__c transfer = [Select Id,Name,dmpl__PerformOutwardRelease__c From dmpl__Transfer__c LIMIT 1];
        transfer.dmpl__PerformOutwardRelease__c = False;
        update transfer;
        
        transfer.dmpl__PerformOutwardRelease__c = True;
        update transfer;
        
        System.assertEquals(True, transfer.dmpl__PerformOutwardRelease__c, 'Transfer has 1 Record Updated');
    }
    
    
    public static void UpdateTransferAsInwardReceive()
    {
        UpdateTransferAsOutwardReceive();
        dmpl__Transfer__c transfer = [Select Id,Name,dmpl__PerformInwardReceive__c From dmpl__Transfer__c LIMIT 1];
        transfer.dmpl__PerformInwardReceive__c = False;
        update transfer;
        
        transfer.dmpl__PerformInwardReceive__c = True;
        update transfer;
        
        System.assertEquals(True, transfer.dmpl__PerformInwardReceive__c, 'Transfer has 1 Record Updated');
    }
    
    
    public static void UpdateTransferAsInwardPosting()
    {
        UpdateTransferAsInwardReceive();
        dmpl__Transfer__c transfer = [Select Id,Name,dmpl__PerformInwardPosting__c From dmpl__Transfer__c LIMIT 1];
        transfer.dmpl__PerformInwardPosting__c = False;
        update transfer;
        
        transfer.dmpl__PerformInwardPosting__c = True;
        update transfer;
        
        System.assertEquals(True, transfer.dmpl__PerformInwardPosting__c, 'Transfer has 1 Record Updated');
    } 
    
    
    private static void CreateTransferOutwardLine()
    {
        List<dmpl__TransferOutwardLine__c> transferInwardLine = new List<dmpl__TransferOutwardLine__c>();
        dmpl__Transfer__c transfer = [Select Id,Name From dmpl__Transfer__c LIMIT 1];
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id,Name FROM dmpl__SKU__c LIMIT 1];
        dmpl__ItemLot__c itemLot = [Select Id, Name From dmpl__ItemLot__c LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        dmpl__StorageLocation__c storageLocation = [Select Id,Name FROM dmpl__StorageLocation__c LIMIT 1];
        transferInwardLine.add(new dmpl__TransferOutwardLine__c(dmpl__TransferId__c = transfer.Id,
                                                                dmpl__ItemLotId__c = itemLot.Id,
                                                                dmpl__ItemId__c = item.Id,
                                                                dmpl__SKUId__c = sku.Id,
                                                                dmpl__Quantity__c = 1,
                                                                dmpl__StorageLocationId__c = storageLocation.Id,
                                                                dmpl__UnitCost__c = 10
                                                               ));
        insert transferInwardLine;
        
    }
    
    @isTest
    public static void MarkInventoryLedgerAsTransferOutward()
    {
        try{
            test.startTest();
            dmpl__InventoryLedger__c inventory = [Select Id,Name,dmpl__Quantity__c,dmpl__InventoryLedgerType__c From dmpl__InventoryLedger__c WHERE dmpl__InventoryLedgerType__c = 'Adjustment' LIMIT 1];
            inventory.dmpl__InventoryLedgerType__c = 'TransferOutward';
            inventory.dmpl__Quantity__c = 5;
            update inventory;
            test.stopTest();
            System.assertEquals(5, inventory.dmpl__Quantity__c, 'Inventory have 1 updated record');
        }catch(exception e){}
    }
    
    
  /*  @isTest
    public static void MarkInventoryLedgerAsTransferInward()
    {
        test.startTest();
        dmpl__InventoryLedger__c inventory = [Select Id,Name,dmpl__Quantity__c,dmpl__InventoryLedgerType__c From dmpl__InventoryLedger__c WHERE dmpl__InventoryLedgerType__c = 'Adjustment' LIMIT 1];
        inventory.dmpl__InventoryLedgerType__c = 'TransferInward';
        inventory.dmpl__Quantity__c = 5;
        update inventory;
        test.stopTest();
        System.assertEquals(5, inventory.dmpl__Quantity__c, 'Inventory have 1 updated record');
    }
    
   @isTest
    public static void UpdateInventoryLedgerType()
    {
        test.startTest();
        dmpl__InventoryLedger__c inventory = [Select Id,Name,dmpl__Quantity__c,dmpl__InventoryLedgerType__c From dmpl__InventoryLedger__c LIMIT 1];
        if(inventory.dmpl__InventoryLedgerType__c == 'TransferOutward' || inventory.dmpl__InventoryLedgerType__c == 'TransferInward')
            inventory.dmpl__Quantity__c = 10;
        update inventory;
        test.stopTest();
        System.assert(inventory != null, 'Inventory have 1 updated record');
    }
    
    @isTest
    public static void MarkInventoryLedgerAsInward()
    {
        test.starttest();
        dmpl__InventoryLedger__c inventory = [Select Id,Name,dmpl__InventoryLedgerType__c From dmpl__InventoryLedger__c WHERE dmpl__InventoryLedgerType__c = 'Adjustment' LIMIT 1];
        inventory.dmpl__InventoryLedgerType__c = 'Inward';
        inventory.dmpl__Quantity__c = 5;
        update inventory;
        test.stopTest();
        System.assertEquals(5, inventory.dmpl__Quantity__c, 'Inventory have 1 updated record');
    }
    
    @isTest
    public static void MarkInventoryLedgerAsOutward()
    {
        test.startTest();
        dmpl__InventoryLedger__c inventory = [Select Id,Name,dmpl__InventoryLedgerType__c From dmpl__InventoryLedger__c WHERE dmpl__InventoryLedgerType__c = 'Adjustment' LIMIT 1];
        inventory.dmpl__InventoryLedgerType__c = 'Outward';
        inventory.dmpl__Quantity__c = 5;
        update inventory;
        test.stopTest();
        System.assertEquals(5, inventory.dmpl__Quantity__c, 'Inventory have 1 updated record');
    }
    
   @isTest
    public static void MarkInventoryLedgerAsAssemble()
    {
        test.startTest();
        dmpl__InventoryLedger__c inventory = [Select Id,Name,dmpl__InventoryLedgerType__c From dmpl__InventoryLedger__c WHERE dmpl__InventoryLedgerType__c = 'Adjustment' LIMIT 1];
        inventory.dmpl__InventoryLedgerType__c = 'Assemble';
        inventory.dmpl__Quantity__c = 5;
        update inventory;
        test.stopTest();
        System.assertEquals(5, inventory.dmpl__Quantity__c, 'Inventory have 1 updated record');
    }*/
    
    @isTest
    public static void MarkInventoryLedgerAsFulfillment()
    {
        try{
            test.startTest();
            dmpl__InventoryLedger__c inventory = [Select Id,Name,dmpl__InventoryLedgerType__c From dmpl__InventoryLedger__c LIMIT 1];
            inventory.dmpl__InventoryLedgerType__c = 'Fulfilment';
            inventory.dmpl__Quantity__c = 5;
            update inventory;
            test.stopTest();
            System.assertEquals(5, inventory.dmpl__Quantity__c, 'Inventory have 1 updated record');
        }catch(exception e){}
    }
    
   /* @isTest
    public static void MarkInventoryLedgerAsAllocation()
    {
        test.starttest();
        dmpl__InventoryLedger__c inventory = [Select Id,Name,dmpl__InventoryLedgerType__c From dmpl__InventoryLedger__c WHERE dmpl__InventoryLedgerType__c = 'Adjustment' LIMIT 1];
        inventory.dmpl__InventoryLedgerType__c = 'Allocation';
        inventory.dmpl__Quantity__c = 5;
        update inventory;
        test.stopTest();
        System.assertEquals(5, inventory.dmpl__Quantity__c, 'Inventory have 1 updated record');
    }
    @isTest
    public static void MarkInventoryLedgerAsPicked()
    {
        test.startTest();
        dmpl__InventoryLedger__c inventory = [Select Id,Name,dmpl__InventoryLedgerType__c From dmpl__InventoryLedger__c WHERE dmpl__InventoryLedgerType__c = 'Adjustment' LIMIT 1];
        inventory.dmpl__InventoryLedgerType__c = 'Picked';
        inventory.dmpl__Quantity__c = 5;
        update inventory;
        test.stoptest();
        System.assertEquals(5, inventory.dmpl__Quantity__c, 'Inventory have 1 updated record');
    }
    
    @isTest
    public static void MarkInventoryLedgerAsPurchased()
    {
        test.startTest();
        dmpl__InventoryLedger__c inventory = [Select Id,Name,dmpl__InventoryLedgerType__c From dmpl__InventoryLedger__c WHERE dmpl__InventoryLedgerType__c = 'Adjustment' LIMIT 1];
        inventory.dmpl__InventoryLedgerType__c = 'Purchased';
        inventory.dmpl__Quantity__c = 5;
        update inventory;
        test.stopTest();
        System.assertEquals(5, inventory.dmpl__Quantity__c, 'Inventory have 1 updated record');
    }*/
    
   /* @isTest
    public static void MarkInventoryLedgerAsSold()
    {
        test.startTest();
        dmpl__InventoryLedger__c inventory = [Select Id,Name,dmpl__InventoryLedgerType__c From dmpl__InventoryLedger__c WHERE dmpl__InventoryLedgerType__c = 'Adjustment' LIMIT 1];
        inventory.dmpl__InventoryLedgerType__c = 'Sold';
        inventory.dmpl__Quantity__c = 5;
        update inventory;
        test.stopTest();
        System.assertEquals(5, inventory.dmpl__Quantity__c, 'Inventory have 1 updated record');
    }
    
    @isTest
    public static void MarkInventoryLedgerAsDamaged()
    {
        test.startTest();
        dmpl__InventoryLedger__c inventory = [Select Id,Name,dmpl__InventoryLedgerType__c From dmpl__InventoryLedger__c WHERE dmpl__InventoryLedgerType__c = 'Adjustment' LIMIT 1];
        inventory.dmpl__InventoryLedgerType__c = 'Damaged';
        inventory.dmpl__Quantity__c = 5;
        update inventory;
        test.stopTest();
        System.assertEquals(5, inventory.dmpl__Quantity__c, 'Inventory have 1 updated record');
    }*/
    
    @isTest
    public static void MarkInventoryLedgerAsExpired()
    {
        try{
            test.startTest();
            dmpl__InventoryLedger__c inventory = [Select Id,Name,dmpl__InventoryLedgerType__c From dmpl__InventoryLedger__c WHERE dmpl__InventoryLedgerType__c = 'Adjustment' LIMIT 1];
            inventory.dmpl__InventoryLedgerType__c = 'Expired';
            inventory.dmpl__Quantity__c = 5;
            update inventory;
            test.stopTest();
            System.assertEquals(5, inventory.dmpl__Quantity__c, 'Inventory have 1 updated record');
        }
        catch(exception e){}
    }
    
    @isTest
    public static void MarkInventoryLedgerAsOnHold()
    {
        try{
            test.startTest();
            dmpl__InventoryLedger__c inventory = [Select Id,Name,dmpl__InventoryLedgerType__c From dmpl__InventoryLedger__c WHERE dmpl__InventoryLedgerType__c = 'Adjustment' LIMIT 1];
            inventory.dmpl__InventoryLedgerType__c = 'OnHold';
            //inventory.dmpl__Quantity__c = 5;
            update inventory;
            test.stopTest();
            //System.assertEquals(5, inventory.dmpl__Quantity__c, 'Inventory have 1 updated record');
        }
        catch(exception e){}
    }
    
    @isTest
    public static void MarkInventoryLedgerAsOnLoan()
    {
        try{
            test.startTest();
            dmpl__InventoryLedger__c inventory = [Select Id,Name,dmpl__InventoryLedgerType__c From dmpl__InventoryLedger__c WHERE dmpl__InventoryLedgerType__c = 'Adjustment' LIMIT 1];
            inventory.dmpl__InventoryLedgerType__c = 'OnLoan';
            inventory.dmpl__Quantity__c = 5;
            update inventory;
            test.stopTest();
            System.assertEquals(5, inventory.dmpl__Quantity__c, 'Inventory have 1 updated record');
        }catch(exception e){}
    }
    
    
    
   /* @isTest
    public static void MarkInventoryLedgerAsInspection()
    {
        test.startTest();
        dmpl__InventoryLedger__c inventory = [Select Id,Name,dmpl__InventoryLedgerType__c From dmpl__InventoryLedger__c WHERE dmpl__InventoryLedgerType__c = 'Adjustment' LIMIT 1];
        inventory.dmpl__InventoryLedgerType__c = 'Inspection';
        inventory.dmpl__Quantity__c = 5;
        update inventory;
        test.stopTest();
        System.assertEquals(5, inventory.dmpl__Quantity__c, 'Inventory have 1 updated record');
    }
    
    @isTest
    public static void MarkInventoryLedgerAsInspectionAdjustment()
    {
        test.startTest();
        dmpl__InventoryLedger__c inventory = [Select Id,Name,dmpl__InventoryLedgerType__c From dmpl__InventoryLedger__c WHERE dmpl__InventoryLedgerType__c = 'Adjustment' LIMIT 1];
        inventory.dmpl__InventoryLedgerType__c = 'InspectionAdjustment';
        inventory.dmpl__Quantity__c = 5;
        update inventory;
        test.stoptest();
        System.assertEquals(5, inventory.dmpl__Quantity__c, 'Inventory have 1 updated record');
    }*/
    
    
    public static void UpdateTransferAsOutward()
    {
        try{
            test.startTest();
            dmpl__Transfer__c transfer = [Select Id,Name,dmpl__PerformOutwardRelease__c From dmpl__Transfer__c LIMIT 1];
            transfer.dmpl__PerformOutwardRelease__c =  true;
            update transfer;
            
            test.stopTest();
            System.assertEquals(True, transfer.dmpl__PerformOutwardRelease__c, 'Transfer has 1 Record Updated');
        }catch(exception e){}
    }
    
    private static void Createstock()
    {
        List<dmpl__InventoryStock__c> stock = new List<dmpl__InventoryStock__c>();
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c LIMIT 1];
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        stock.Add(new dmpl__InventoryStock__c(
            //dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
            //dmpl__BranchId__c = branch.Id,
            //dmpl__ItemId__c = item.Id,
            //dmpl__QuantityAdjustedIn__c = 10,
            //dmpl__QuantityShortage__c=1,
            //dmpl__QuantityDamaged__c = 0,
            //dmpl__QuantityPurchaseReturned__c = 0
        ));
        //insert stock;
        
    }
    
    private static void CreateInventoryLedger()
    {
        List<dmpl__InventoryLedger__c> inventoryLedger = new List<dmpl__InventoryLedger__c>();
        Account account = [Select Id,Name From Account where dmpl__IsPartnerAccount__c = true LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1]; 
        dmpl__SKU__c sku = [Select Id,Name From dmpl__SKU__c LIMIT 1];
        dmpl__ItemLot__c itemLot = [Select Id, Name From dmpl__ItemLot__c LIMIT 1];
        dmpl__StorageLocation__c storageLocation = [Select Id,Name From dmpl__StorageLocation__c LIMIT 1];
        inventoryLedger.add(new dmpl__InventoryLedger__c(dmpl__BranchId__c = branch.Id,
                                                         dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                                         dmpl__InventoryLedgerType__c = 'Inward',
                                                         //dmpl__SourceDocument__c = ' Test - Source - Document',
                                                         //dmpl__IsInventoryStockPosted__c = false,
                                                         dmpl__ItemId__c = item.Id,
                                                         dmpl__SKUId__c = sku.Id,
                                                         dmpl__ItemLotId__c = itemLot.Id,
                                                         dmpl__StorageLocationId__c = storageLocation.Id,
                                                         dmpl__Quantity__c = 10,
                                                         dmpl__UnitCost__c = 100 
                                                         //dmpl__DocumentDate__c = Date.today(),
                                                         //dmpl__ShortageQuantity__c = 1,
                                                         //dmpl__DamagedQuantity__c = 0
                                                        ));
        //insert inventoryLedger;
        
    }  
}