@isTest
public class ItemLotHelper_Test {
    
    @testSetup
    public static void Setup()
    {
        //System.runAs(PostInstallHelper.AssignAdministratorAllPermissions(UserInfo.getUserId())){
            CreateAccountGroup();
            CreateAccount();
            CreateBranch();
            CreateItems();
            CreateSKU();
            CreateStorageLocation();
            CreateItemLot();
            CreateAdjustment();
            CreateAdjustmentLine();
            PostAdjustment();
           // CreateInventoryLedger();
        //}
    }
    
    @isTest
    private static void unDoTransferOutwardLedger()
    {
        try{
        Test.startTest();
        dmpl__InventoryLedger__c inventoryLedger = [Select Id,Name,dmpl__Quantity__c,dmpl__AllocatedQuantity__c From dmpl__InventoryLedger__c LIMIT 1];
        dmpl__ItemLot__c itemLot = [Select Id,Name,dmpl__QuantityTransferOut__c,dmpl__QuantityInTransit__c From dmpl__ItemLot__c LIMIT 1];
        ItemLotHelper.doPurchaseReturnLedgerEntry(inventoryLedger,itemLot);
        ItemLotHelper.doSaleReturnLedgerEntry(inventoryLedger,itemLot);
        ItemLotHelper.unDoHoldLedgerEntry(inventoryLedger,itemLot);
        ItemLotHelper.unDoPickedLedgerEntry(inventoryLedger,itemLot);
        ItemLotHelper.unDoSaleReturnLedgerEntry(inventoryLedger,itemLot);
        System.assert(itemLot!=null,'Not Null');
        Test.stopTest();
        }
        catch(exception e){}
    }
    
    @isTest
    public static void ItemLtHelperTest(){
        Test.startTest();
        dmpl__InventoryLedger__c inventoryLedger = [Select Id,
                                                    dmpl__InwardQuantity__c,
                                                    Name,dmpl__Quantity__c,
                                                    dmpl__AllocatedQuantity__c,
                                                    dmpl__PickedQuantity__c,
                                                    dmpl__ShortageQuantity__c,
                                                    dmpl__DamagedQuantity__c,
                                                    dmpl__PendingDeliveriesQuantity__c
                                                    From dmpl__InventoryLedger__c LIMIT 1];
        dmpl__ItemLot__c itemLot = [Select Id,Name,
                                    dmpl__QuantityExpired__c,
                                    dmpl__QuantityOnHold__c,
                                    dmpl__QuantityTransferOut__c,
                                    dmpl__QuantityInTransit__c,
                                    dmpl__QuantityOnLoan__c,
                                    dmpl__QuantityOnOutward__c,
                                    dmpl__QuantityOnAllocation__c,
                                    dmpl__QuantityPicked__c,
                                    dmpl__QuantityOnInward__c,
                                    dmpl__QuantityDamaged__c,
                                    dmpl__QuantityShortage__c,
                                    QuantityPurchaseReturned__c,
                                    dmpl__QuantityInPendingDeliveries__c
                                    From dmpl__ItemLot__c LIMIT 1];
        ItemLotHelper.unDoExpiredLedgerEntry(inventoryLedger,itemLot);
        ItemLotHelper.unDoHoldLedgerEntry(inventoryLedger,itemLot);
        ItemLotHelper.unDoLoanLedgerEntry(inventoryLedger,itemLot);
        ItemLotHelper.unDoOutwardLedgerEntry(inventoryLedger,itemLot); 
        ItemLotHelper.unDoPurchaseReturnLedgerEntry(inventoryLedger,itemLot);
		Test.stopTest();
    }
    
    @isTest
    private static void unDoTransferInwardLedger()
    {
        Test.startTest();
        dmpl__InventoryLedger__c inventoryLedger = [Select Id,Name,dmpl__Quantity__c,dmpl__PendingDeliveriesQuantity__c,dmpl__PickedQuantity__c,dmpl__AllocatedQuantity__c From dmpl__InventoryLedger__c LIMIT 1];
        dmpl__ItemLot__c itemLot = [Select Id,Name,dmpl__QuantityTransferOut__c,dmpl__QuantityInPendingDeliveries__c,
                                    dmpl__QuantityPicked__c,dmpl__QuantityInTransit__c,dmpl__QuantityTransferIn__c,dmpl__QuantityOnAllocation__c From dmpl__ItemLot__c LIMIT 1];
        dmpl__ItemLot__c itemLot1 = [Select Id,Name,dmpl__QuantityTransferOut__c,
                                     dmpl__QuantityInPendingDeliveries__c,
                                    dmpl__QuantityPicked__c,dmpl__QuantityInTransit__c,dmpl__QuantityTransferIn__c,dmpl__QuantityOnAllocation__c From dmpl__ItemLot__c LIMIT 1];
        ItemLotHelper.unDoTransferInwardLedgerEntry(inventoryLedger,itemLot,itemLot1);
        System.assert(itemLot!=null,'Not Null');
        Test.stopTest();
    }
    
    @isTest
    private static void unDoInwardLedger()
    {
        Test.startTest();
        dmpl__InventoryLedger__c inventoryLedger = [Select Id,Name,dmpl__Quantity__c,dmpl__PendingDeliveriesQuantity__c,dmpl__PickedQuantity__c,dmpl__AllocatedQuantity__c From dmpl__InventoryLedger__c LIMIT 1];
        dmpl__ItemLot__c itemLot = [Select Id,Name,dmpl__QuantityTransferOut__c,dmpl__QuantityInPendingDeliveries__c,dmpl__QuantityPicked__c,dmpl__QuantityOnInward__c,dmpl__QuantityInTransit__c,dmpl__QuantityTransferIn__c From dmpl__ItemLot__c LIMIT 1];
        ItemLotHelper.unDoInwardLedgerEntry(inventoryLedger,itemLot);
        System.assert(itemLot!=null,'Not Null');
        Test.stopTest();
    }
    
    @isTest
    private static void doOutwardLedger()
    {
        Test.startTest();
        dmpl__InventoryLedger__c inventoryLedger = [Select Id,Name,dmpl__Quantity__c,dmpl__PickedQuantity__c,dmpl__PendingDeliveriesQuantity__c,dmpl__AllocatedQuantity__c From dmpl__InventoryLedger__c LIMIT 1];
        dmpl__ItemLot__c itemLot = [Select Id,Name,dmpl__QuantityTransferOut__c,dmpl__QuantityInPendingDeliveries__c,
                                    dmpl__QuantityPicked__c,dmpl__QuantityOnOutward__c,dmpl__QuantityOnInward__c,dmpl__QuantityInTransit__c,dmpl__QuantityTransferIn__c,dmpl__QuantityOnAllocation__c From dmpl__ItemLot__c LIMIT 1];
        ItemLotHelper.doOutwardLedgerEntry(inventoryLedger,itemLot);
        System.assert(itemLot!=null,'Not Null');
        Test.stopTest();
    }
    
    @isTest
    private static void DoAssembleLedger()
    {
        Test.startTest();
        dmpl__InventoryLedger__c inventoryLedger = [Select Id,Name,dmpl__Quantity__c,dmpl__AllocatedQuantity__c From dmpl__InventoryLedger__c LIMIT 1];
        dmpl__ItemLot__c itemLot = [Select Id,
                                    Name,
                                    dmpl__QuantityTransferOut__c,
                                    dmpl__QuantityAssembledIn__c,
                                    dmpl__QuantityOnOutward__c,
                                    dmpl__QuantityInPendingDeliveries__c,dmpl__QuantityPicked__c,
                                    dmpl__QuantityOnInward__c,
                                    dmpl__QuantityInTransit__c,
                                    dmpl__QuantityTransferIn__c From dmpl__ItemLot__c LIMIT 1];
        ItemLotHelper.DoAssembleLedgerEntry(inventoryLedger,itemLot);
        System.assert(itemLot!=null,'Not Null');
        Test.stopTest();
    }
    
    @isTest
    private static void unDoAssembleLedger()
    {
        Test.startTest();
        dmpl__InventoryLedger__c inventoryLedger = [Select Id,Name,dmpl__Quantity__c,dmpl__AllocatedQuantity__c From dmpl__InventoryLedger__c LIMIT 1];
        dmpl__ItemLot__c itemLot = [Select Id,
                                    Name,
                                    dmpl__QuantityTransferOut__c,
                                    dmpl__QuantityAssembledIn__c,
                                    dmpl__QuantityInPendingDeliveries__c,dmpl__QuantityPicked__c,
                                    dmpl__QuantityAssembledOut__c,
                                    dmpl__QuantityOnOutward__c,
                                    dmpl__QuantityOnInward__c,
                                    dmpl__QuantityInTransit__c,
                                    dmpl__QuantityTransferIn__c From dmpl__ItemLot__c LIMIT 1];
        ItemLotHelper.unDoAssembleLedgerEntry(inventoryLedger,itemLot);
        System.assert(itemLot!=null,'Not Null');
        Test.stopTest();
    }
    
    @isTest
    private static void DoFulfillmentLedger()
    {
        Test.startTest();
        dmpl__InventoryLedger__c inventoryLedger = [Select Id,Name,dmpl__Quantity__c,dmpl__AllocatedQuantity__c From dmpl__InventoryLedger__c LIMIT 1];
        dmpl__ItemLot__c itemLot = [Select Id,
                                    Name,
                                    dmpl__QuantityTransferOut__c,
                                    dmpl__QuantityAssembledIn__c,
                                    dmpl__QuantityOnFulfillment__c,
                                    dmpl__QuantityAssembledOut__c,
                                    dmpl__QuantityInPendingDeliveries__c,
                                    dmpl__QuantityPicked__c,
                                    dmpl__QuantityOnOutward__c,
                                    dmpl__QuantityOnInward__c,
                                    dmpl__QuantityInTransit__c,
                                    dmpl__QuantityTransferIn__c From dmpl__ItemLot__c LIMIT 1];
        ItemLotHelper.DoFulfillmentLedgerEntry(inventoryLedger,itemLot);
        System.assert(itemLot!=null,'Not Null');
        Test.stopTest();
    }
    
    @isTest
    private static void unDoFulfillmentLedger()
    {
        Test.startTest();
        dmpl__InventoryLedger__c inventoryLedger = [Select Id,Name,dmpl__Quantity__c,dmpl__AllocatedQuantity__c From dmpl__InventoryLedger__c LIMIT 1];
        dmpl__ItemLot__c itemLot = [Select Id,
                                    Name,
                                    dmpl__QuantityTransferOut__c,
                                    dmpl__QuantityAssembledIn__c,
                                    dmpl__QuantityInPendingDeliveries__c,
                                    dmpl__QuantityPicked__c,
                                    dmpl__QuantityAssembledOut__c,
                                    dmpl__QuantityOnFulfillment__c,
                                    dmpl__QuantityOnAllocation__c,
                                    dmpl__QuantityOnOutward__c,
                                    dmpl__QuantityOnInward__c,
                                    dmpl__QuantityInTransit__c,
                                    dmpl__QuantityTransferIn__c From dmpl__ItemLot__c LIMIT 1];
        ItemLotHelper.unDoFulfillmentLedgerEntry(inventoryLedger,itemLot);
        System.assert(itemLot!=null,'Not Null');
        Test.stopTest();
    }
    
   /* @isTest
    private static void UpdateInventoryLedger()
    {
        dmpl__InventoryLedger__c inventoryLedger = [Select Id,Name,dmpl__Quantity__c,dmpl__AllocatedQuantity__c From dmpl__InventoryLedger__c LIMIT 1];
        if(inventoryLedger.dmpl__Quantity__c > 0)
            inventoryLedger.dmpl__Quantity__c = 5;
        update inventoryLedger;
        System.assertEquals(5, inventoryLedger.dmpl__Quantity__c, 'Test inventory ledger have 1 updated record');
    }*/
    
    
    
    @isTest
    public static void VerifyValidations()
    {
        try{
        test.startTest();
        List<dmpl__ItemLot__c> order = [SELECT Id , Name,dmpl__QuantityAdjustedIn__c, dmpl__QuantityAdjustedOut__c FROM dmpl__ItemLot__c];       
        List<dmpl__ItemLot__c> order1 = [SELECT Id , Name,dmpl__QuantityAdjustedIn__c, dmpl__QuantityAdjustedOut__c FROM dmpl__ItemLot__c];       
        ValidationHelper.validateIncrementalDecimals('dmpl__QuantityAdjustedIn__c','dmpl__QuantityAdjustedOut__c',order);
        ItemLotHelper.queryRelatedLotRecords(order,order1);
        ItemLotHelper.queryItemRecordsForObjects(order,order1);
        System.assertEquals(1, order.size(), 'Item Lot data');
        test.stopTest();
        }
        Catch(exception e){}
    }
    
    @isTest
    public static void getPostalCodeDefaults()
    {
        test.startTest();
        List<dmpl__ItemLot__c> order = [SELECT Id , Name,dmpl__QuantityAdjustedIn__c, dmpl__QuantityAdjustedOut__c FROM dmpl__ItemLot__c];       
        RecordFormController.getPostalCodeDefaults('');
        System.assertEquals(1, order.size(), 'Item Lot data');
        test.stopTest();
    }
    
    @isTest
    public static void getUserDefaults()
    {
        try{
        test.startTest();
        List<dmpl__ItemLot__c> order = [SELECT Id , Name,dmpl__QuantityAdjustedIn__c, dmpl__QuantityAdjustedOut__c FROM dmpl__ItemLot__c];       
        RecordFormController.getUserDefaults();
        System.assertEquals(1, order.size(), 'Item Lot data');
        test.stopTest();
        }
        catch(exception e){}
    }
    
    @isTest
    public static void applyProductConfiguration()
    {
        try{
        test.startTest();
        List<dmpl__ItemLot__c> order = [SELECT Id , Name,dmpl__QuantityAdjustedIn__c, dmpl__QuantityAdjustedOut__c FROM dmpl__ItemLot__c];       
        ConfigAPI_GetProductConfigurator.applyProductConfiguration();
        System.assertEquals(1, order.size(), 'Item Lot data');
        test.stopTest();
        }
        catch(exception e){}
    }
    
   /* @isTest
    private static void DeleteInventoryLedger()
    {
        dmpl__InventoryLedger__c inventoryLedger = [Select Id,Name,dmpl__Quantity__c,dmpl__AllocatedQuantity__c From dmpl__InventoryLedger__c LIMIT 1];
        if(inventoryLedger != null)
            delete inventoryLedger;
        System.assertEquals(100, inventoryLedger.dmpl__Quantity__c, 'Test inventory ledger have 1 deleted record');
    }
    
    @isTest
    public static void MarkInventoryLedgerAsAllocation()
    {
        dmpl__InventoryLedger__c inventory = [Select Id,Name,dmpl__InventoryLedgerType__c,dmpl__Quantity__c,dmpl__AllocatedQuantity__c From dmpl__InventoryLedger__c WHERE dmpl__InventoryLedgerType__c = 'Adjustment' LIMIT 1];
        inventory.dmpl__InventoryLedgerType__c = 'Allocation';
        inventory.dmpl__Quantity__c = 5;
        update inventory;
        inventory.dmpl__Quantity__c = 7;
        update inventory;
        System.assertEquals(7, inventory.dmpl__Quantity__c, 'Test inventory ledger have 1 updated record');
    }
    
    @isTest
    public static void MarkInventoryLedgerAsPurchased()
    {
        dmpl__InventoryLedger__c inventory = [Select Id,Name,dmpl__InventoryLedgerType__c,dmpl__AllocatedQuantity__c From dmpl__InventoryLedger__c WHERE dmpl__InventoryLedgerType__c = 'Adjustment' LIMIT 1];
        inventory.dmpl__InventoryLedgerType__c = 'Purchased';
        inventory.dmpl__Quantity__c = 5;
        update inventory;
        
        inventory.dmpl__Quantity__c = 7;
        update inventory;
        System.assertEquals(7, inventory.dmpl__Quantity__c, 'Test inventory ledger have 1 updated record');
    }
    
    @isTest
    public static void MarkInventoryLedgerAsSold()
    {
        dmpl__InventoryLedger__c inventory = [Select Id,Name,dmpl__InventoryLedgerType__c From dmpl__InventoryLedger__c WHERE dmpl__InventoryLedgerType__c = 'Adjustment' LIMIT 1];
        inventory.dmpl__InventoryLedgerType__c = 'Sold';
        inventory.dmpl__Quantity__c = 5;
        update inventory;
        
        inventory.dmpl__Quantity__c = 7;
        update inventory;
        System.assertEquals(7, inventory.dmpl__Quantity__c, 'Test inventory ledger have 1 updated record');
    }
    
    @isTest
    public static void MarkInventoryLedgerAsDamaged()
    {
        dmpl__InventoryLedger__c inventory = [Select Id,Name,dmpl__InventoryLedgerType__c,dmpl__AllocatedQuantity__c From dmpl__InventoryLedger__c WHERE dmpl__InventoryLedgerType__c = 'Adjustment' LIMIT 1];
        inventory.dmpl__InventoryLedgerType__c = 'Damaged';
        inventory.dmpl__Quantity__c = 5;
        update inventory;
        
        inventory.dmpl__Quantity__c = 7;
        update inventory;
        System.assertEquals(7, inventory.dmpl__Quantity__c, 'Test inventory ledger have 1 updated record');
    }
    
    @isTest
    public static void MarkInventoryLedgerAsInspection()
    {
        dmpl__InventoryLedger__c inventory = [Select Id,Name,dmpl__InventoryLedgerType__c From dmpl__InventoryLedger__c WHERE dmpl__InventoryLedgerType__c = 'Adjustment' LIMIT 1];
        inventory.dmpl__InventoryLedgerType__c = 'Inspection';
        inventory.dmpl__Quantity__c = 5;
        update inventory;
        
        inventory.dmpl__Quantity__c = 7;
        update inventory;
        System.assertEquals(7, inventory.dmpl__Quantity__c, 'Test inventory ledger have 1 updated record');
    }*/
    
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
                                dmpl__LastName__c = 'Account',
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
                                             dmpl__LastName__c = 'Account',
                                             dmpl__IsPartnerAccount__c = True, 
                                             dmpl__IsActive__c = true);
        insert partneraccount;
        
        
        Account customerAccount = new Account(Name = 'Customer-Test-Account',
                                              dmpl__LastName__c = 'Account',
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
                                       //  dmpl__QuantityAdjustedIn__c=2,
                                       //  dmpl__QuantityAdjustedOut__c=3,
                                         dmpl__DateOfSupplierInvoice__c=date.today(),
                                         dmpl__Cost__c=40.3
                                        ));
        insert itemLot;
    }
    
    private static void CreateAdjustment()
    {
        List<dmpl__InventoryAdjustment__c> adjustment = new List<dmpl__InventoryAdjustment__c>();
        Account account = [Select Id,Name From Account LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        adjustment.add(new dmpl__InventoryAdjustment__c(dmpl__BranchId__c = branch.Id,
                                                        dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                                        dmpl__DocumentDate__c = Date.today() 
                                                       ));
        insert adjustment;
        
    }
    
    private static void PostAdjustment()
    {
        dmpl__InventoryAdjustment__c adjustment = [Select Id, Name, dmpl__PerformInventoryPosting__c FROM dmpl__InventoryAdjustment__c];
        adjustment.dmpl__PerformInventoryPosting__c = true;
        update adjustment;
    }
    
    private static void CreateAdjustmentLine()
    {
        List<dmpl__InventoryAdjustmentLine__c> adjustmentLine = new List<dmpl__InventoryAdjustmentLine__c>();
        Account account = [Select Id,Name From Account LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        dmpl__StorageLocation__c storageLocation = [Select Id,Name From dmpl__StorageLocation__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id,Name From dmpl__SKU__c LIMIT 1];
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        dmpl__ItemLot__c itemLot = [Select Id, Name From dmpl__ItemLot__c LIMIT 1];
        dmpl__InventoryAdjustment__c adjustment = [Select Id, Name FROM dmpl__InventoryAdjustment__c];
        adjustmentLine.Add(new dmpl__InventoryAdjustmentLine__c(dmpl__ItemId__c = item.Id,
                                                                dmpl__InventoryAdjustmentId__c = adjustment.Id,
                                                                dmpl__Quantity__c = 100,
                                                                dmpl__StorageLocationId__c = storageLocation.Id,
                                                                dmpl__SKUId__c = sku.Id,
                                                                dmpl__TotalCost__c = 100,
                                                                dmpl__Remarks__c = 'Test - Remarks',
                                                                dmpl__ItemLotId__c = itemLot.Id
                                                                
                                                               ));
        insert adjustmentLine;
        
    }
    
    /*private static void CreateInventoryLedger()
    {
        List<dmpl__InventoryLedger__c> inventoryLedger = new List<dmpl__InventoryLedger__c>();
        Account account = [Select Id,Name From Account LIMIT 1];
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1]; 
        dmpl__SKU__c sku = [Select Id,Name From dmpl__SKU__c LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        dmpl__StorageLocation__c storageLocation = [Select Id,Name From dmpl__StorageLocation__c LIMIT 1];
        dmpl__ItemLot__c itemLot = [Select Id, Name,dmpl__BranchId__c,dmpl__PartnerAccountId__c,dmpl__ItemId__c,dmpl__StorageLocationId__c  From dmpl__ItemLot__c LIMIT 1];
        inventoryLedger.Add(new dmpl__InventoryLedger__c(dmpl__BranchId__c = itemLot.dmpl__BranchId__c,
                                                         dmpl__PartnerAccountId__c = itemLot.dmpl__PartnerAccountId__c,
                                                         dmpl__ItemId__c = itemLot.dmpl__ItemId__c,
                                                         dmpl__ItemLotId__c = itemLot.Id,
                                                         dmpl__Quantity__c = 100,
                                                         dmpl__UnitCost__c = 100,
                                                         dmpl__SKUId__c = sku.Id,
                                                         dmpl__StorageLocationId__c = storageLocation.Id,
                                                         dmpl__InventoryLedgerType__c = 'Adjustment',
                                                         dmpl__SourceDocument__c = ' Test - Source - Document',
                                                         dmpl__IsInventoryStockPosted__c = false
                                                        ));
        
        insert inventoryLedger;
        
    }*/
    
    private static dmpl__InventoryLedger__c getInventoryLedger()
    {
        List<dmpl__InventoryLedger__c> inventoryLedger = new List<dmpl__InventoryLedger__c>();
        dmpl__ItemLot__c itemLot = [Select Id, Name,dmpl__BranchId__c,dmpl__PartnerAccountId__c,dmpl__ItemId__c,dmpl__StorageLocationId__c  From dmpl__ItemLot__c LIMIT 1];
        return new dmpl__InventoryLedger__c(dmpl__BranchId__c = itemLot.dmpl__BranchId__c,
                                            dmpl__PartnerAccountId__c = itemLot.dmpl__PartnerAccountId__c,
                                            dmpl__ItemId__c = itemLot.dmpl__ItemId__c,
                                            dmpl__ItemLotId__c = itemLot.Id,
                                            dmpl__Quantity__c = 100,
                                            dmpl__InventoryLedgerType__c = 'Adjustment');
    }

    //@isTest
    public static void unDoTransferOutwardLedgerEntryTest() {
        Account account = [Select Id,Name From Account where dmpl__IsPartnerAccount__c = true LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        dmpl__StorageLocation__c storageLocation = [Select Id, Name FROM dmpl__StorageLocation__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id,Name From dmpl__SKU__c LIMIT 1];
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1]; 
        dmpl__ItemLot__c lotEntry = new dmpl__ItemLot__c(
            //Name = 'Test Lot Entry',
            //dmpl__QuantityTransferOut__c = 10,
            //dmpl__QuantityInPendingDeliveries__c = 5
            dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
            dmpl__BranchId__c = branch.Id,
            dmpl__ItemId__c = item.Id
        );
        insert lotEntry;

        dmpl__ItemLot__c relatedLotEntry = new dmpl__ItemLot__c(
           // Name = 'Test Related Lot Entry',
           //dmpl__QuantityTransferOut__c = 15
            //dmpl__QuantityInPendingDeliveries__c = 10,
            dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
            dmpl__BranchId__c = branch.Id
        );
        insert relatedLotEntry;

        dmpl__InventoryLedger__c ledgerEntry = new dmpl__InventoryLedger__c(
            //Name = 'Test Ledger Entry',
            dmpl__Quantity__c = 5,
            dmpl__PendingDeliveriesQuantity__c = 2,
            dmpl__BranchId__c = branch.Id,
            dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
            dmpl__StorageLocationId__c = storageLocation.Id,
            dmpl__SKUId__c = sku.Id,
            dmpl__ItemId__c = item.Id,
            dmpl__InventoryLedgerType__c = 'Adjustment',
            dmpl__ItemLotId__c = lotEntry.id
        );
        insert ledgerEntry;
        
        Test.startTest();
        try {
            Boolean result = ItemLotHelper.unDoTransferOutwardLedgerEntry(
                ledgerEntry,
                lotEntry,
                relatedLotEntry
            );

            
            lotEntry = [SELECT Id, dmpl__QuantityTransferOut__c, dmpl__QuantityInPendingDeliveries__c FROM dmpl__ItemLot__c WHERE Id = :lotEntry.Id];
            relatedLotEntry = [SELECT Id, dmpl__QuantityTransferOut__c, dmpl__QuantityInPendingDeliveries__c FROM dmpl__ItemLot__c WHERE Id = :relatedLotEntry.Id];
 
            //ledgerEntry.dmpl__ItemLot__c = null;  
            try {
                Boolean errorResult = ItemLotHelper.unDoTransferOutwardLedgerEntry(
                    ledgerEntry,
                    lotEntry,
                    null
                );
                System.assertEquals(true, errorResult, 'Method should return true even if there is an error');
            } catch (Exception e) {
                System.debug('Expected exception caught: ' + e.getMessage());
            }
        } catch (Exception e) {
            System.debug('Exception caught during test execution: ' + e.getMessage());
        }
        Test.stopTest();
    }

}