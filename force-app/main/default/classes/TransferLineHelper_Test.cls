@isTest
public with sharing class TransferLineHelper_Test {
    @testSetup
    public static void Setup()
    {
        Test.startTest();
        CreateAccountGroup();
        CreateAccount();
        CreateBranch();
        CreateItems();
        CreateSKu();
        CreateItemLot();
        CreateTransfer();
        CreateTransferLine();
        Test.stopTest();
    }

    @isTest
    public static void postTransferLinesTest(){
        List<dmpl__Transfer__c> transfers=[select dmpl__PartnerAccountId__c,dmpl__BranchId__c,dmpl__ToBranchId__c,dmpl__TransferTime__c,dmpl__PerformInwardReceive__c,dmpl__PerformInwardPosting__c from dmpl__Transfer__c ];
        Test.startTest();
        TransferLineHelper.postTransferLines(transfers);
        Test.stopTest();

    }
    @isTest
    public static void postTransferLinesInternalTest(){
        List<dmpl__TransferLine__c> transferLines = [SELECT Id,dmpl__IsILPostingApproved__c,dmpl__ItemLotId__c,dmpl__ItemId__c,dmpl__TransferId__c from dmpl__TransferLine__c];
        Test.startTest();
        TransferLineHelper.postTransferLinesInternal(transferLines);
        Test.stopTest();
    }

    private static void CreateAccountGroup()
    {
    	dmpl__AccountGroup__c accountGroup= new dmpl__AccountGroup__c (Name= 'Test-AccountGroup', 
                                                                       dmpl__AccountGroupType__c='Price');
        insert accountGroup;
    }
    
    private static void CreateAccount()
    {
        List<Account> account = new List<Account>();
        dmpl__AccountGroup__c accountGroup = [Select Id,Name From dmpl__AccountGroup__c LIMIT 1];
        account.add(new Account(Name = 'Test - Account', 
            					Fax = '09876',
                               Phone = '1234567891',
                               dmpl__LastName__c = 'Account',
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
        
        account.add(new Account(Name = 'Partner-Test-Account',
                                             dmpl__IsPartnerAccount__c = True,
                                             dmpl__LastName__c = 'Account',
                                             dmpl__IsActive__c = true));
        
        account.add(new Account(Name = 'Customer-Test-Account',
                                              dmpl__IsCustomerAccount__c = True,
                                              dmpl__LastName__c = 'Account',
                                              dmpl__IsActive__c = true));
        account.add(new Account(Name = 'Supplier-Test-Account',
                                              dmpl__IsSupplierAccount__c = True,
                                              dmpl__LastName__c = 'Account',
                                              dmpl__IsActive__c = true));
        
        insert account;
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
        
        branch.Add(new dmpl__Branch__c(dmpl__PartnerAccountId__c =partnerAccount.Id,
                                      Name = 'Test11-Branch',
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

    private static void CreateItemLot()
    {
        List<dmpl__ItemLot__c> itemLot = new List<dmpl__ItemLot__c>();
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c limit 1];
        dmpl__SKU__c sku = [Select Id ,Name From dmpl__SKU__c LIMIT 1 ];
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        itemLot.Add(new dmpl__ItemLot__c(dmpl__BranchId__c = branch.Id,
                                         dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                         dmpl__ItemId__c = item.Id,
                                         dmpl__SKUId__c =sku.Id,
                                         dmpl__BatchNo__c = 'AAA',
                                         dmpl__SerialNumber__c='BBB',
                                         dmpl__SupplierInvoiceNumber__c='CCC',
                                         dmpl__DateOfReceipt__c= date.today(),
                                         dmpl__DateOfMfg__c=date.today(),
                                         dmpl__TotalCost__c=10.2,
                                         dmpl__DateOfSupplierInvoice__c=date.today(),
                                         dmpl__Cost__c=38.3
        ));
        insert itemLot;       
    }
    
    

    private static void CreateTransfer()
    {
        List<dmpl__Transfer__c> transfer = new List<dmpl__Transfer__c>();
        dmpl__Branch__c branch1 = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c limit 1];
        
        
        //dmpl__Resource__c Resource = [Select Id,Name From dmpl__Resource__c LIMIT 1];
        transfer.Add(new dmpl__Transfer__c(dmpl__PartnerAccountId__c = branch1.dmpl__PartnerAccountId__c,
                                          dmpl__BranchId__c = branch1.Id,
                                          dmpl__ToBranchId__c = branch1.id,
                                          dmpl__PerformInwardPosting__c = false,
                                          dmpl__PerformInwardReceive__c = false,
                                           dmpl__TransferTime__c = Date.today()
                                           //dmpl__TransferredById__c = Resource.Id
                                          ));
        insert transfer;
    }

    private static void CreateTransferLine(){
         dmpl__Transfer__c transfer=[select Id from dmpl__Transfer__c limit 1];
         dmpl__ItemLot__c item=[select Id,dmpl__ItemId__c from dmpl__ItemLot__c limit 1];
         dmpl__SKU__c itemSKU = [Select Id,Name From dmpl__SKU__c LIMIT 1];
         dmpl__TransferLine__c line=new dmpl__TransferLine__c(dmpl__TransferId__c=transfer.Id,
                                                             dmpl__ItemId__c=item.dmpl__ItemId__c,
                                                              dmpl__ItemLotId__c=item.Id,
                                                             dmpl__Quantity__c=1,
                                                             dmpl__SKUId__c = itemSKU.id,
                                                             dmpl__IsILPostingApproved__c = False
                                                           );
         insert line;
         

         line.dmpl__IsILPostingApproved__c = True;
         update line;

     }
}