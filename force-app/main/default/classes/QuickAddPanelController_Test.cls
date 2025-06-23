@isTest
public class QuickAddPanelController_Test {
    
    @testSetup
    public static void Setup()
    {
        System.runAs(PostInstallHelper.AssignAdministratorAllPermissions(UserInfo.getUserId())){
            CreateAccountGroup();
            CreateAccount();
            CreateBranch();
            CreateItems();
            CreateItemPrice();
            CreateItemDiscount();
            CreateItemLot();
            CreateAdjustment();
            CreateAdjustmentLine();
            UpdateAdjustment();
        }
    }
    
    @isTest
    Static void VerifyCreateAccount()
    {
        List<Account>  account = [Select Id, Name From Account];
        System.assertNotEquals(null, account, 'Test Accounts are not found');
        System.assertEquals(3, account.size(), 'Test Accounts have more than 1 record');
    }
    
    @isTest
    Static void getAlternateItemTypesTest()
    {
        List<dmpl__Item__c>  item = [Select Id, Name From dmpl__Item__c Limit 1];
        ItemController.getAlternateItemTypes(item[0].Id);
        ItemController.getItem(item[0].Id);
        ItemController.getItemPrice(item[0].Id,item[0].Id,item[0].Id,System.Today());
        ItemController.getItems('Part',10,5);
    }
    
    @isTest
    public static void getFieldsByFieldSetName()
    {
        List<dmpl__Item__c>  item = [Select Id, Name From dmpl__Item__c Limit 1];
        List<Id> itemIds = DocumentHelper.extractIds(item,'Id');
        List<FieldsetFieldInfo> fInfo = QuickAddPanelController.getFieldsByFieldSetName('dmpl__SaleOrderLine__c','dmpl__dmsquickaddpanelpartfieldset');
        System.assertNotEquals(fInfo.size(),0, 'FieldSets not found');
        ItemController.getItemLotTypeStock(item[0].Id,item[0].Id,item[0].Id);
        ItemController.getItemLotTypesStock(item[0].Id,item[0].Id);
        ItemController.getItemStocks(itemIds,itemIds,itemIds);
        ItemController.getItemAlternateStock(item[0].Id,item[0].Id,item[0].Id);
    } 
    
    @isTest
    public static void getItemStock()
    {
        Id itemId = [Select Id From dmpl__Item__c LIMIT 1]?.Id;
        Id partnerId=[Select Id From Account LIMIT 1]?.Id;
        Id branchId=[Select Id From dmpl__Branch__c LIMIT 1]?.Id;
        
        List<AggregateResult> fInfo = QuickAddPanelController.getItemStock(itemId,partnerId,branchId);
        System.assertEquals(fInfo.size(),0, 'result not found');
    } 
    
    @isTest
    public static void getItemSKUStock()
    {
        Id itemId = [Select Id From dmpl__Item__c LIMIT 1]?.Id;
        Id skuId = [Select Id From dmpl__SKU__c LIMIT 1]?.Id;
        Id partnerId=[Select Id From Account LIMIT 1]?.Id;
        Id branchId=[Select Id From dmpl__Branch__c LIMIT 1]?.Id;
        
        List<AggregateResult> fInfo = QuickAddPanelController.getItemSKUStock(itemId,partnerId,branchId);
        System.assertEquals(fInfo.size(),0, 'result not found');
    } 
    
    @isTest
    public static void getItemSKUBranchStock()
    {
        Id itemId = [Select Id From dmpl__Item__c LIMIT 1]?.Id;
        Id skuId = [Select Id From dmpl__SKU__c LIMIT 1]?.Id;
        Id partnerId=[Select Id From Account LIMIT 1]?.Id;
        Id branchId=[Select Id From dmpl__Branch__c LIMIT 1]?.Id;
        
        List<AggregateResult> fInfo = QuickAddPanelController.getItemSKUBranchStock(itemId,skuId,partnerId);
        System.assertEquals(fInfo.size(),0, 'result not found');
    } 
    @isTest
    public static void getItemLotTypesStock()
    {
        Id itemId = [Select Id From dmpl__Item__c LIMIT 1]?.Id;
        Id branchId=[Select Id From dmpl__Branch__c LIMIT 1]?.Id;
        
        List<AggregateResult> fInfo = QuickAddPanelController.getItemLotTypesStock(itemId,branchId);
        System.assertEquals(fInfo.size(),0, 'result not found');
    } 
    
    
    @isTest
    public static void getTaxGroup()
    {
        Id itemId = [Select Id From dmpl__Item__c LIMIT 1]?.Id;
        Id skuId = [Select Id From dmpl__SKU__c LIMIT 1]?.Id;
        Id partnerId=[Select Id From Account LIMIT 1]?.Id;
        Id branchId=[Select Id From dmpl__Branch__c LIMIT 1]?.Id;
        
        Id txId = QuickAddPanelController.getTaxGroup(itemId,skuId,partnerId,branchId, Date.today(), null);
        System.assertEquals(txId,null, 'result not found');
    } 
    
    @isTest
    public static void getItemPrice()
    {
        Id itemId = [Select Id From dmpl__Item__c LIMIT 1]?.Id;
        Id skuId = [Select Id From dmpl__SKU__c LIMIT 1]?.Id;
        Id partnerId=[Select Id From Account LIMIT 1]?.Id;
        Id branchId=[Select Id From dmpl__Branch__c LIMIT 1]?.Id;
        Id plId=[Select Id From dmpl__PriceList__c LIMIT 1]?.Id;
        Double result = QuickAddPanelController.getItemPrice(itemId,skuId,plId, Date.today());
        System.assertNotEquals(result,0, 'result not found');
    } 
    
    @isTest
    public static void getItemDiscount()
    {
        Id itemId = [Select Id From dmpl__Item__c LIMIT 1]?.Id;
        Id skuId = [Select Id From dmpl__SKU__c LIMIT 1]?.Id;
        Id partnerId=[Select Id From Account LIMIT 1]?.Id;
        Id branchId=[Select Id From dmpl__Branch__c LIMIT 1]?.Id;
        Id dgIds=[Select Id From dmpl__DiscountGroup__c LIMIT 1]?.Id;
        
        Double result = QuickAddPanelController.getItemDiscount(itemId,skuId,dgIds, Date.today());
        System.assertNotEquals(result,0, 'result not found');
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
                                dmpl__LastName__c = 'Sale Order',
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
                                             dmpl__LastName__c = 'Sale Order',
                                             dmpl__IsPartnerAccount__c = True, 
                                             dmpl__IsActive__c = true);
        insert partneraccount;
        
        Account customerAccount = new Account(Name = 'Customer-Test-Account',
                                              dmpl__LastName__c = 'Sale Order',
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
        dmpl__Item__c item = new dmpl__Item__c(Name = 'Test-Item',
                                               dmpl__IsActive__c = true,
                                               dmpl__TrackInventory__c=true);
        insert item;
        
        dmpl__SKU__c sku =new dmpl__SKU__c(Name = 'SKU-Item',dmpl__SKUCode__c = 'Code',
                                           dmpl__ItemId__c = item.Id);
        insert sku;
    }
    
    private static void CreateItemDiscount(){
        dmpl__DiscountGroup__c dg = new dmpl__DiscountGroup__c(Name = 'Test-Item',
                                                               dmpl__IsActive__c = true,
                                                               dmpl__DiscountType__c='Sale Price');
        insert dg;
        
        Id itemId = [Select Id From dmpl__Item__c LIMIT 1]?.Id;
        dmpl__DiscountGroupRule__c dgr =new dmpl__DiscountGroupRule__c(dmpl__ItemId__c = itemId, dmpl__DiscountGroupId__c=dg.Id, dmpl__DiscountPercent__c = 0.20, dmpl__DateEffectiveFrom__c = Date.today());
        insert dgr;
    }
    
    private static void CreateItemPrice(){
        dmpl__PriceList__c pl = new dmpl__PriceList__c(Name = 'PL-Item',
                                                       dmpl__IsActive__c = true,
                                                       dmpl__IsDefault__c=true,
                                                       dmpl__PriceListType__c = 'Sale Price');
        insert pl;
        
        Id itemId = [Select Id From dmpl__Item__c LIMIT 1]?.Id;
        dmpl__PriceListRules__c pr =new dmpl__PriceListRules__c(dmpl__PriceListId__c = pl.Id,
                                                                dmpl__ItemId__c = itemId, dmpl__Price__c = 500, dmpl__DateEffectiveFrom__c = Date.today());
        insert pr;
    }
    
    private static void CreateItemLot()
    {
        Id itemId = [Select Id From dmpl__Item__c LIMIT 1]?.Id;
        Id partnerId=[Select Id From Account WHERE dmpl__IsPartnerAccount__c = True LIMIT 1]?.Id;
        Id branchId=[Select Id From dmpl__Branch__c LIMIT 1]?.Id;
        Id skuId = [Select Id,Name From dmpl__SKU__c LIMIT 1]?.Id;
        List<dmpl__ItemLot__c> item = new List<dmpl__ItemLot__c>();
        item.Add(new dmpl__ItemLot__c(
            dmpl__BranchId__c = branchId,
            dmpl__PartnerAccountId__c = partnerId,
            dmpl__ItemId__c = itemId,
            dmpl__SKUId__c = skuId));
        insert item;
    }
    
    private static void CreateAdjustment()
    {
        List<dmpl__InventoryAdjustment__c> adjustment = new List<dmpl__InventoryAdjustment__c>();
        Account account = [Select Id,Name From Account WHERE dmpl__IsPartnerAccount__c = True LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        adjustment.add(new dmpl__InventoryAdjustment__c(dmpl__BranchId__c = branch.Id,
                                                        dmpl__PartnerAccountId__c = account.Id
                                                       ));
        insert adjustment;
    }
    
    private static void CreateAdjustmentLine()
    {
        Id itemLotId = [SELECT Id FROM dmpl__ItemLot__c LIMIT 1]?.Id;
        List<dmpl__InventoryAdjustmentLine__c> adjustmentLine = new List<dmpl__InventoryAdjustmentLine__c>();
        Account account = [Select Id,Name From Account WHERE dmpl__IsPartnerAccount__c = True LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id,Name From dmpl__SKU__c LIMIT 1];
        dmpl__InventoryAdjustment__c adjustment = [Select Id, Name FROM dmpl__InventoryAdjustment__c];
        adjustmentLine.Add(new dmpl__InventoryAdjustmentLine__c(dmpl__ItemId__c = item.Id,
                                                                dmpl__SKUId__c = sku.Id,
                                                                dmpl__InventoryAdjustmentId__c = adjustment.Id,
                                                                dmpl__Quantity__c = 1,
                                                                dmpl__ItemLotId__c = itemLotId
                                                               ));
        insert adjustmentLine;
    }
    
    private static void UpdateAdjustment()
    {
        dmpl__InventoryAdjustment__c adjustment = [SELECT Id, dmpl__PerformInventoryPosting__c FROM dmpl__InventoryAdjustment__c LIMIT1];
        adjustment.dmpl__PerformInventoryPosting__c = true;
        update adjustment;
    }
    
}