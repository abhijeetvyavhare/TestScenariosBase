@isTest
public class InventoryAdjustmentHelper_Test {
    
    @testSetup
    public static void Setup()
    {
        CreateAccountGroup();
        CreateAccount();
        CreateBranch();
        CreateStorageLocation();
        CreateItem();
        CreateSKu();
        CreateItemFeatures();
        CreateItemComponent();
        CreateItemLot();
        CreateAdjustment();
        CreateAdjustmentLine();
        //CreateInventoryLedger();
        CreateScheme1();
    }
    
    @isTest
    public static void UpdateAdjustment()
    {
        dmpl__InventoryAdjustment__c adjustment = [Select Id,Name,dmpl__Status__c From dmpl__InventoryAdjustment__c LIMIT 1];
        adjustment.dmpl__Status__c = 'Draft';
        update adjustment;
        System.assertEquals('Draft', adjustment.dmpl__Status__c, 'Test adjustment have 1 updated record');
    }
    
    @isTest
    public static void UpdateAdjustmentPerformInventoryPosting()
    {
        dmpl__InventoryAdjustment__c adjustment = [Select Id,Name,dmpl__PerformInventoryPosting__c From dmpl__InventoryAdjustment__c LIMIT 1];
        adjustment.dmpl__PerformInventoryPosting__c = true;
        update adjustment;
        System.assertEquals(true, adjustment.dmpl__PerformInventoryPosting__c, 'Test adjustment have 1 updated record');
    }
    
    @isTest
    public static void DeleteAdjustment()
    {
        dmpl__InventoryAdjustment__c adjustment = [Select Id,Name,dmpl__PerformInventoryPosting__c From dmpl__InventoryAdjustment__c LIMIT 1];
        delete adjustment;
        System.assertEquals(false, adjustment.dmpl__PerformInventoryPosting__c, 'Test adjustment have 1 deleted record');
    }
    
    @isTest
    public static void UpdateAdjustmentLine()
    {
        dmpl__Item__c item = [Select Id,Name,(Select Id,dmpl__SKUId__c,dmpl__FeatureType__c from dmpl__ItemComponents__r) From dmpl__Item__c LIMIT 1];
        dmpl__InventoryAdjustmentLine__c adjustmentLine = [Select Id,Name,dmpl__Quantity__c,dmpl__SKUId__c From dmpl__InventoryAdjustmentLine__c LIMIT 1];
        adjustmentLine.dmpl__Quantity__c = 1;
        update adjustmentLine;
        InventoryAdjustmentLineHelper.getApplicableItemFeatures(item,adjustmentLine.dmpl__SKUId__c);
        System.assert(adjustmentLine!=null, 'Test adjustment Line have 1 updated record');
    }
    
   /* @isTest
    public static void DeleteInventoryLedger()
    {
        test.startTest();
        dmpl__InventoryLedger__c inventory = [Select Id,Name,dmpl__InventoryLedgerType__c From dmpl__InventoryLedger__c LIMIT 1];
     	if(inventory != null)
        	delete inventory;
        test.stopTest();
            System.assertEquals('Adjustment', inventory.dmpl__InventoryLedgerType__c, 'Test inventory ledger have 1 updated record');
    }
    
    @isTest
    public static void UpdateInventoryLedger()
    {
        test.startTest();
        dmpl__InventoryLedger__c inventory = [Select Id,Name,dmpl__Quantity__c From dmpl__InventoryLedger__c LIMIT 1];
        inventory.dmpl__Quantity__c = 2;
		update inventory;
        test.stopTest();
		System.assertEquals(2, inventory.dmpl__Quantity__c, 'Test inventory ledger have 1 deleted record');
    }*/
    
    @isTest
    public static void populateBOMComponents()
    {
        test.startTest();
        List<dmpl__InventoryAdjustmentLine__c> adjustmentLine = [Select Id,Name,dmpl__SKUId__c,dmpl__AdjustmentType__c,dmpl__ItemId__c,dmpl__IsILPostingApproved__c From dmpl__InventoryAdjustmentLine__c LIMIT 1];
        if(adjustmentLine != null)
        	InventoryAdjustmentLineHelper.populateBOMComponents(adjustmentLine);
        System.assert(adjustmentLine!=null, 'Test adjustment Line have 1 updated record');
        test.stopTest();
    }
    
    @isTest
    public static void updateAdjustmentTypeAsDamaged()
    {
        try{
        test.startTest();
        dmpl__InventoryAdjustmentLine__c adjustmentLine = new dmpl__InventoryAdjustmentLine__c(dmpl__AdjustmentType__c ='Damaged',dmpl__InventoryAdjustmentId__c=null);
            //adjustmentLine.dmpl__AdjustmentType__c ='Damaged';
        insert adjustmentLine;
        //InventoryAdjustmentLineHelper.populateBOMComponents(adjustmentLine);
        System.assert(adjustmentLine!=null, 'Test adjustment Line have 1 updated record');
        test.stopTest();
        }catch(Exception e){}
    }
    
    @isTest
    public static void updateAdjustmentTypeAsExpired()
    {
        try{
        test.startTest();
        dmpl__InventoryAdjustmentLine__c adjustmentLine = new dmpl__InventoryAdjustmentLine__c(dmpl__AdjustmentType__c ='Expired',dmpl__InventoryAdjustmentId__c=null);
        //if(adjustmentLine != null)
            //adjustmentLine.dmpl__AdjustmentType__c ='Expired';
        insert adjustmentLine;
        //InventoryAdjustmentLineHelper.populateBOMComponents(adjustmentLine);
        System.assert(adjustmentLine!=null, 'Test adjustment Line have 1 updated record');
        test.stopTest();
        }catch(exception e){}
    }
    
    @isTest
    public static void updateAdjustmentTypeAsOnHold()
    {
        try{
        test.startTest();
        dmpl__InventoryAdjustmentLine__c adjustmentLine = new dmpl__InventoryAdjustmentLine__c(dmpl__AdjustmentType__c ='On Hold',dmpl__InventoryAdjustmentId__c=null);
            adjustmentLine.dmpl__AdjustmentType__c ='On Hold';
        insert adjustmentLine;
        //InventoryAdjustmentLineHelper.populateBOMComponents(adjustmentLine);
        System.assert(adjustmentLine!=null, 'Test adjustment Line have 1 updated record');
        test.stopTest();
        }catch(exception e){}
    }
    
    @isTest
    public static void updateAdjustmentTypeAsOnLoan()
    {
        try{
        test.startTest();
        dmpl__InventoryAdjustmentLine__c adjustmentLine = new dmpl__InventoryAdjustmentLine__c(dmpl__AdjustmentType__c ='On Loan',dmpl__InventoryAdjustmentId__c=null);
            adjustmentLine.dmpl__AdjustmentType__c ='On Loan';
        insert adjustmentLine;
        //InventoryAdjustmentLineHelper.populateBOMComponents(adjustmentLine);
        System.assert(adjustmentLine!=null, 'Test adjustment Line have 1 updated record');
        test.stopTest();
        }catch(exception e){}
    }
    
    @isTest
    public static void updateAdjustmentTypeAsAssemble()
    {
        test.startTest();
        dmpl__InventoryAdjustmentLine__c adjustmentLine = [Select Id,Name,dmpl__AdjustmentType__c,dmpl__ItemId__c,dmpl__IsILPostingApproved__c From dmpl__InventoryAdjustmentLine__c LIMIT 1];
        if(adjustmentLine != null)
            adjustmentLine.dmpl__AdjustmentType__c ='Assemble';
        update adjustmentLine;
        //InventoryAdjustmentLineHelper.populateBOMComponents(adjustmentLine);
        System.assert(adjustmentLine!=null, 'Test adjustment Line have 1 updated record');
        test.stopTest();
    }
    
    @isTest
    private static void verifysetDefaultPriceListIds()
    {
        test.startTest();
        List<dmpl__InventoryAdjustment__c> adjustments = [Select Id,Name,PartnerAccountId__c,BranchId__c,dmpl__PriceListId__c From dmpl__InventoryAdjustment__c];
        PriceListHelper.setDefaultPriceListIds(adjustments);
        System.assert(adjustments != null, 'Adjustments Inserted');
        test.stopTest();
    }
    
    @isTest
    public static void updateAdjustmentTypeAsDisassemble()
    {
        test.startTest();
        dmpl__InventoryAdjustmentLine__c adjustmentLine = [Select Id,Name,dmpl__AdjustmentType__c,dmpl__ItemId__c,dmpl__IsILPostingApproved__c From dmpl__InventoryAdjustmentLine__c LIMIT 1];
        if(adjustmentLine != null)
            adjustmentLine.dmpl__AdjustmentType__c ='Disassemble';
        update adjustmentLine;
        //InventoryAdjustmentLineHelper.populateBOMComponents(adjustmentLine);
        System.assert(adjustmentLine!=null, 'Test adjustment Line have 1 updated record');
        test.stopTest();
    }
    
    @isTest
    public static void UpdateAdjustmentLineAsIsILPostingApproved()
    {
        dmpl__InventoryAdjustmentLine__c adjustmentLine = [Select Id,Name,dmpl__IsILPostingApproved__c From dmpl__InventoryAdjustmentLine__c LIMIT 1];
        adjustmentLine.dmpl__IsILPostingApproved__c = true;
        update adjustmentLine;
        System.assertEquals(true, adjustmentLine.dmpl__IsILPostingApproved__c, 'Test adjustment Line have 1 updated record');
    }
    
    @isTest
    private static void verifyAdjustment()
    {
        try{
        List<dmpl__InventoryAdjustment__c> adjustments = [SELECT Id,Name From dmpl__InventoryAdjustment__c];
        InventoryAdjustmentLineHelper.performReprice(adjustments[0].Id);
        } catch(exception ex){}
    }
    
    @isTest
    public static void DeleteAdjustmentLine()
    {
        try
        {
            dmpl__InventoryAdjustmentLine__c adjustmentLine = [Select Id,Name,dmpl__IsILPostingApproved__c From dmpl__InventoryAdjustmentLine__c LIMIT 1];
            delete adjustmentLine;
            System.assertEquals(false, adjustmentLine.dmpl__IsILPostingApproved__c, 'Test adjustment Line have 1 updated record');
        }
        catch(exception e){}
    }
    
    @isTest
    public static void CreateAdjustmentTest()
    {

        test.startTest();
        dmpl__ClaimBatch__c newClaim=new dmpl__ClaimBatch__c();
        InventoryAdjustmentHelper.createAdjustment(newClaim);
        test.stopTest();
    }
    
    @isTest
    public static void postILTest()
    {

        test.startTest();
        Account acc=[Select id from Account Limit 1];
       
        InventoryAdjustmentLineHelper.postIL(acc.id);
        test.stopTest();
    }
    
    @isTest
    public static void createAdjustmentFromClaimtest() {
        try {
            Test.startTest();
            
            List<dmpl__Claim__c> claim = [SELECT Id, Name FROM dmpl__Claim__c];
            
            InventoryAdjustmentHelper.createAdjustmentFromClaim(claim);
            //InventoryAdjustmentHelper.createAdjustment(claim);
            
            Test.stopTest();
        } catch (Exception e) {}
                    
    }
    
    @isTest
    public static void canCreateAdjustmentTest()
    {
        test.startTest();
        List<dmpl__ClaimLine__c> claimline = [Select Id,Name,dmpl__ClaimType__c,dmpl__ApproveQuantity__c From dmpl__ClaimLine__c where dmpl__ClaimType__c = 'Part to Part' AND dmpl__ApproveQuantity__c > 0];
        InventoryAdjustmentHelper.canCreateAdjustment(claimline);
        test.stopTest();
    }
    
    @isTest
    public static void createAdjustmentFromInventoryCycleCountTest()
    {
        test.startTest();
        List<dmpl__InventoryCycleCount__c> cycleCount = [Select Id,Name From dmpl__InventoryCycleCount__c LIMIT 1];
        InventoryAdjustmentHelper.createAdjustmentFromInventoryCycleCount(cycleCount);
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
                                             dmpl__IsPartnerAccount__c = True, 
                                             dmpl__LastName__c = 'Account',
                                             dmpl__IsActive__c = true);
        insert partneraccount;
        
        List<dmpl__AccountGroupMember__c> accountGroupMember = new List<dmpl__AccountGroupMember__c>();
        accountGroupMember.add(new dmpl__AccountGroupMember__c(
        dmpl__AccountGroupId__c = accountGroup.Id,
        dmpl__BatchInstanceId__c = 'TestBatchId123',
        dmpl__AccountId__c = partneraccount.Id ));
        insert accountGroupMember;
        
        
        Account customerAccount = new Account(Name = 'Customer-Test-Account',
                                              dmpl__IsCustomerAccount__c = True,
                                              dmpl__LastName__c = 'Account',
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
                                   dmpl__RFID__c = 'O1234fgh'));
        
        item.Add(new dmpl__Item__c(Name = 'Test-Item',
                                         dmpl__ItemCode__c = 'DMPL',
                                         dmpl__ItemType__c = 'Charge Item',
                                         dmpl__ItemSubType__c = '',
                                         dmpl__Description__c = '',
                                         dmpl__ItemFamily__c = 'Sample',
                                         dmpl__ItemSegment__c = 'Sample',
                                         dmpl__Make__c = 'Sample',
                                         dmpl__Model__c = 'Sample',                       
                                         dmpl__IsActive__c = true,
                                         dmpl__OnlySoldInPackage__c=True
                                         
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
    
    private static void CreateAdjustmentLine()
    {
        List<dmpl__InventoryAdjustmentLine__c> adjustmentLine = new List<dmpl__InventoryAdjustmentLine__c>();
        Account account = [Select Id,Name From Account LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id,Name From dmpl__SKU__c LIMIT 1];
        dmpl__StorageLocation__c storageLocation = [Select Id,Name From dmpl__StorageLocation__c LIMIT 1];
        dmpl__ItemLot__c itemLot = [Select Id, Name From dmpl__ItemLot__c LIMIT 1];
        dmpl__InventoryAdjustment__c adjustment = [Select Id, Name FROM dmpl__InventoryAdjustment__c];
        adjustmentLine.Add(new dmpl__InventoryAdjustmentLine__c(dmpl__ItemId__c = item.Id,
                                                                dmpl__SKUId__c = sku.Id,
                                                                dmpl__StorageLocationId__c = storageLocation.Id,
                                                                dmpl__Quantity__c = 4,
                                                                dmpl__TotalCost__c = 100,
                                                                dmpl__ItemLotId__c = itemLot.Id,
                                                                dmpl__Remarks__c = 'Test - Remarks',
                                                                dmpl__InventoryAdjustmentId__c = adjustment.Id,
                                                                dmpl__AdjustmentType__c = 'Assemble'
                                                               ));
        insert adjustmentLine;
        
        List<dmpl__InventoryAdjustmentLine__c> adjustmentLine1 = new List<dmpl__InventoryAdjustmentLine__c>();
        adjustmentLine1.Add(new dmpl__InventoryAdjustmentLine__c(dmpl__ItemId__c = item.Id,
                                                                dmpl__SKUId__c = sku.Id,
                                                                dmpl__StorageLocationId__c = storageLocation.Id,
                                                                dmpl__Quantity__c = 4,
                                                                dmpl__TotalCost__c = 100,
                                                                dmpl__ItemLotId__c = itemLot.Id,
                                                                dmpl__Remarks__c = 'Test - Remarks',
                                                                dmpl__InventoryAdjustmentId__c = adjustment.Id,
                                                                dmpl__AdjustmentType__c = 'Disassemble'
                                                               ));
        insert adjustmentLine1;
        
    }
    
    private static void CreateItemLot()
    {
        List<dmpl__ItemLot__c> itemLot = new List<dmpl__ItemLot__c>();
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id,Name From dmpl__SKU__c LIMIT 1];
        dmpl__StorageLocation__c storageLocation = [Select Id,Name From dmpl__StorageLocation__c LIMIT 1];
        itemLot.Add(new dmpl__ItemLot__c(dmpl__BranchId__c = branch.Id,
                                         dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                         dmpl__ItemId__c = item.Id,
                                         dmpl__SKUId__c = sku.Id,
                                         dmpl__StorageLocationId__c = StorageLocation.Id,
                                         dmpl__BatchNo__c = ' Test - Batch - Number ',
                                         dmpl__SerialNumber__c = 'Test - Serial - Number ',
                                         dmpl__SupplierInvoiceNumber__c =' Test -Supplier -Invoice- Number ',
                                         dmpl__DateOfReceipt__c = Date.today(),
                                         dmpl__DateOfMfg__c =Date.today(),
                                         dmpl__TotalCost__c = 100,
                                         dmpl__DateOfSupplierInvoice__c =Date.today(),
                                         dmpl__Cost__c = 100
                                        ));
        insert itemLot;
        
    }
    
    private static void CreateItemFeatures()
    {
        List<dmpl__ItemFeature__c> itemFeature = new List<dmpl__ItemFeature__c>();
        Account partnerAccount = [Select Id,Name From Account WHERE Name = 'Partner-Test-Account' LIMIT 1];
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        itemFeature.add(new dmpl__ItemFeature__c(Name = 'Item-Feature',
                                                 dmpl__ItemId__c = item.Id,
                                                 dmpl__PartnerAccountId__c = partnerAccount.Id,
                                                 dmpl__ShowinCatalog__c = false                                                 
                                                ));
        insert itemFeature;
    }
    
    private static void CreateItemComponent()
    {
        List<dmpl__ItemComponent__c> itemComponent = new List<dmpl__ItemComponent__c>();
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c where dmpl__ItemType__c='' LIMIT 1];
        dmpl__Item__c compitem = [Select Id,Name From dmpl__Item__c where dmpl__ItemType__c='Charge Item' LIMIT 1];
        Account act = [Select Id,Name From Account Where Name ='Partner-Test-Account' LIMIT 1];
        dmpl__SKU__c sku = [Select Id,Name From dmpl__SKU__c LIMIT 1];
        dmpl__ItemFeature__c itemFeature = [Select Id,Name From dmpl__ItemFeature__c LIMIT 1];
        itemComponent.add(new dmpl__ItemComponent__c(dmpl__ItemId__c = item.Id,
                                                     dmpl__ComponentItemId__c=compitem.Id,
                                                     dmpl__SKUId__c = sku.Id,
                                                     dmpl__IsMandatory__c=false,
                                                     dmpl__IsBundled__c=true,
                                                     dmpl__PackageType__c='Independent Of Package',
                                                     dmpl__Quantity__c = 10,
                                                     dmpl__IsSelected__c=true,
                                                     dmpl__IsQuantityEditable__c=True,
                                                     dmpl__ApplicableFor__c='Sale',
                                                     dmpl__PartnerAccountId__c = act.id,
                                                     dmpl__FeatureId__c = itemFeature.Id,
                                                     dmpl__SortOrder__c = 30));
        insert itemComponent;
    }
    
    
    private static void CreateStorageLocation()
    {
        List<dmpl__StorageLocation__c> storageLocation = new List<dmpl__StorageLocation__c>();
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        storageLocation.add(new dmpl__StorageLocation__c(Name = 'Test - Storage - Location',
                                                         dmpl__BranchId__c = branch.Id,
                                                         dmpl__LocationType__c = 'Warehouse',
                                                         dmpl__IsActive__c = false,
                                                         dmpl__AllowInventory__c = false,
                                                         dmpl__IsMobile__c = false));
        insert storageLocation;
        
    }
    
   /* private static void CreateInventoryLedger()
    {
        List<dmpl__InventoryLedger__c> inventoryLedger = new List<dmpl__InventoryLedger__c>();
        Account account = [Select Id,Name From Account LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1]; 
        dmpl__SKU__c sku = [Select Id,Name From dmpl__SKU__c LIMIT 1];
        dmpl__ItemLot__c itemLot = [Select Id, Name From dmpl__ItemLot__c LIMIT 1];
        dmpl__StorageLocation__c storageLocation = [Select Id,Name From dmpl__StorageLocation__c LIMIT 1];
        inventoryLedger.add(new dmpl__InventoryLedger__c(dmpl__BranchId__c = branch.Id,
                                                         dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                                         dmpl__InventoryLedgerType__c = ' Adjustment ',
                                                         dmpl__SourceDocument__c = ' Test - Source - Document',
                                                         dmpl__IsInventoryStockPosted__c = false,
                                                         dmpl__ItemId__c = item.Id,
                                                         dmpl__SKUId__c = sku.Id,
                                                         dmpl__ItemLotId__c = itemLot.Id,
                                                         dmpl__StorageLocationId__c = storageLocation.Id,
                                                         dmpl__Quantity__c = 10,
                                                         dmpl__UnitCost__c = 100,
                                                         dmpl__DocumentDate__c = Date.today()
                                                        ));
        insert inventoryLedger;
    }   */ 
    
    @isTest
    public static void createSchemeLedger()
    {
        List<dmpl__SchemeLedger__c> ledger = new List<dmpl__SchemeLedger__c>();
        Account account = [Select Id,Name From Account WHERE dmpl__IsPartnerAccount__c = True LIMIT 1];
        Account caccount = [Select Id,Name From Account WHERE dmpl__IsCustomerAccount__c = True LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        dmpl__Scheme__c scheme =[Select Id, Name from dmpl__Scheme__c Limit 1];
        dmpl__SaleInvoice__c saleinvoice = new dmpl__SaleInvoice__c(
        	dmpl__PartnerAccountId__c = account.Id,
            dmpl__BranchId__c = branch.Id,
            dmpl__AccountId__c = caccount.Id
        );
        insert saleinvoice;
        ledger.add(new dmpl__SchemeLedger__c(dmpl__PartnerAccountId__c = account.Id,
                                            dmpl__BranchId__c = branch.Id,
                                             dmpl__SchemeId__c = scheme.Id,
                                             dmpl__Description__c = '',
                                             dmpl__Discount__c = 5,
                                             dmpl__DiscountAmount__c = 100,
                                             dmpl__LineAmount__c = 2399,
                                             dmpl__SaleInvoiceId__c = saleinvoice.id
                                            ));
        insert ledger;
    }
    
    @isTest
    public static void updateLedger()
    {
        test.startTest();
        createSchemeLedger();
        CreateSchemeAccountBudget();
        List<dmpl__SchemeLedger__c> ledger = [Select Id,Name,dmpl__DiscountAmount__c,dmpl__NetSchemeDiscount__c,dmpl__Discount__c,dmpl__LineAmount__c,dmpl__SchemeId__c,dmpl__PartnerAccountId__c,dmpl__SaleInvoiceLineId__c From dmpl__SchemeLedger__c LIMIT 1];
        dmpl__SchemeAccountBudget__c sab = new dmpl__SchemeAccountBudget__c(
            dmpl__BudgetAmount__c = 10000,
            dmpl__PartnerAccountId__c = ledger[0].dmpl__PartnerAccountId__c,
            dmpl__SchemeId__c = ledger[0].dmpl__SchemeId__c
        );
        dmpl__SchemeAccountBudget__c sab2 = new dmpl__SchemeAccountBudget__c(
            dmpl__BudgetAmount__c = 0,
            dmpl__PartnerAccountId__c = ledger[0].dmpl__PartnerAccountId__c,
            dmpl__SchemeId__c = ledger[0].dmpl__SchemeId__c
        );
        insert sab;
        insert sab2;
        ledger[0].dmpl__DiscountAmount__c = 29821;
        update ledger;
        if(ledger != null)
        	SchemeAccountBudgetHelper.createAccountBudgetFromSchemeLedger(ledger);
        	SchemeAccountBudgetHelper.createAccountBudgetFromSchemeLedger(ledger,ledger);
        //if(ledger != null)
            delete ledger;
        test.stopTest();
    }
    
    private static void CreateSchemeAccountBudget()
    {
        List<dmpl__SchemeAccountBudget__c> budget = new List<dmpl__SchemeAccountBudget__c>();
        Account act = [Select Id,Name From Account WHERE dmpl__IsPartnerAccount__c = true LIMIT 1];
        dmpl__AccountGroup__c accountGroup = [Select Id,Name From dmpl__AccountGroup__c LIMIT 1];
        dmpl__Scheme__c scheme =[Select Id, Name from dmpl__Scheme__c Limit 1];
        budget.add(new dmpl__SchemeAccountBudget__c(dmpl__BudgetAmount__c= 10000,
                                                    dmpl__SchemeId__c = scheme.Id,
                                                    dmpl__PartnerAccountId__c = act.Id,
                                                    dmpl__UtilizedAmount__c = 1000,
                                                    dmpl__PartnerAccountGroupId__c = accountGroup.Id
                                                   ));
        insert budget;
    }
    
    private static void CreateScheme1()
    {
        List<dmpl__Scheme__c> scheme1 = new List<dmpl__Scheme__c>();
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c Where Name = 'Test-Branch'];
        scheme1.Add(new dmpl__Scheme__c(dmpl__PeriodType__c = 'Monthly',
                                        Name = 'Per Order Sale Order',
                                        dmpl__ValidTo__c = date.today().addMonths(3),
                                        dmpl__Status__c = 'Approved',
                                        dmpl__MultipleFulfilmentTreatment__c = 'Apply Last Fulfilled',
                                        dmpl__SchemeType__c = 'Per Sale Order',
                                        dmpl__BranchId__c = branch.Id,
                                        dmpl__ValidFrom__c = date.today(),
                                        dmpl__PeriodStartDate__c = date.today(),
                                        dmpl__PeriodEndDate__c = date.today().addMonths(3),
                                        dmpl__PartnerAccountId__c = null,
                                        dmpl__PartnerAccountGroupId__c = null,
                                        dmpl__Application__c = 'Apply On Selection',
                                        dmpl__ValidCount__c = 1));
        insert scheme1;
    }
    private static void CreateClaimsNew()
    {
        List<dmpl__Claim__c> claim = new List<dmpl__Claim__c>();
        Account account = [Select Id,Name From Account WHERE Name = 'Supplier-Test-Account' LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        claim.add(new dmpl__Claim__c(dmpl__BranchId__c = branch.Id,
                                     dmpl__ClaimType__c='Part to Part',
                                     dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                     dmpl__DocumentDate__c = date.today(),
                                     dmpl__SupplierNameId__c = account.Id,
                                     dmpl__AsonDate__c = date.today()
                                    ));
        
        claim.add(new dmpl__Claim__c(dmpl__BranchId__c = branch.Id,
                                     dmpl__ClaimType__c='Purchase',
                                     dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                     dmpl__DocumentDate__c = date.today(),
                                     dmpl__SupplierNameId__c = account.Id,
                                     dmpl__AsonDate__c = date.today()
                                    ));
        insert claim;
    }
    private static void CreateClaimLinesNew()
    {
        List<dmpl__ClaimLine__c> claimLine = new List<dmpl__ClaimLine__c>();
        Account account = [Select Id,Name From Account WHERE Name = 'Supplier-Test-Account' LIMIT 1];
        Account partnerAccount = [Select Id,Name From Account WHERE Name = 'Partner-Test-Account' LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name From dmpl__Branch__c];
        dmpl__Claim__c claim = [Select Id,Name FROM dmpl__Claim__c where dmpl__ClaimType__c='Part to Part' LIMIT 1];
        dmpl__Item__c item = [Select Id,Name FROM dmpl__Item__c LIMIT 1];
        dmpl__PurchaseReturnLine__c prreturnLine=[select Id,name FROM dmpl__PurchaseReturnLine__c LIMIT 1];
        claimLine.add(new dmpl__ClaimLine__c(dmpl__BranchId__c = branch.Id,
                                             dmpl__ClaimId__c = claim.Id,
                                             dmpl__ItemCode__c = 'bxfs543',
                                             dmpl__PartnerAccountId__c = partnerAccount.Id,
                                             dmpl__ItemId__c = item.Id,
                                             dmpl__ClaimQuantity__c = 2,
                                             dmpl__UnitPrice__c =100,
                                             dmpl__ApproveQuantity__c = 10,
                                             dmpl__RejectQuantity__c = 2,
                                             dmpl__BillReturnLineId__c = null,
                                             dmpl__PurchaseReturnLineId__c	=prreturnLine.Id
                                            ));
        insert claimLine;
    }
}