@isTest
public class BranchHelper_Test {
    
    @testSetup
    public static void Setup()
    {
        //System.runAs(PostInstallHelper.AssignAdministratorAllPermissions(UserInfo.getUserId())){
            CreateAccountGroup();
            CreateAccount();
            CreateContactAddress();
            CreateBranch();
            CreateItems();
            CreateBranchTimeSlot();
        //}
    }
    
    @isTest
    public static void VerifyBranch()
    {
        List<dmpl__Branch__c> branch = [Select Id, Name From dmpl__Branch__c];
        System.assertNotEquals(null, branch, 'Test Accounts are not found');
        System.assertEquals(1, branch.size(), 'Test Accounts have more than 1 record');
    }
    
     
    @isTest
    public static void VerifyBranch101()
    {
        try {
            List<dmpl__Branch__c> branch = [Select Id, dmpl__PartnerAccountId__c, Name From dmpl__Branch__c];
            List<dmpl__Item__c> item = [SELECT Id FROM dmpl__Item__c];
            BranchController.getStock(
                CollectionHelper.extractIds(branch),
                CollectionHelper.extractIds(item)
            );
       
            BranchController.getBranches(branch[0].dmpl__PartnerAccountId__c);

            BranchController.getRelatedBranches(branch[0].dmpl__PartnerAccountId__c);
            
            BranchController.getAllBranches();
        } catch (Exception ex) {
            
        }
    }

    @isTest
    public static void UpdateBranch()
    {
        List<dmpl__Branch__c> branch = [Select Id, Name From dmpl__Branch__c];
        if(branch != null)
            Update branch;
        System.assertEquals(1, branch.size(), 'Test Accounts have more than 1 record');
    }
    
    @isTest
    public static void DeleteBranch()
    {
        List<dmpl__Branch__c> branch = [Select Id, Name From dmpl__Branch__c];
        if(branch != null)
            Delete branch;
        System.assertEquals(1, branch.size(), 'Test Accounts have more than 1 record');
    }
    
    @isTest
    public static void VerifyBranchDateSlots()
    {
        List<Branch__c> branch = [SELECT Id, Name FROM dmpl__Branch__c LIMIT 1];
        Item__c item = [SELECT Id, Name FROM dmpl__Item__c LIMIT 1];
        BranchHelper.getBranchDateSlots('Service Appointment',branch[0].Id, item.Id,'','',10);
        System.assertEquals(1, branch.size(), 'Test Accounts have more than 1 record');
    }
    
    @isTest
    public static void VerifyBranchTimeSlots()
    {
        List<Branch__c> branch = [SELECT Id, Name FROM dmpl__Branch__c LIMIT 1];
        Item__c item = [SELECT Id, Name FROM dmpl__Item__c LIMIT 1];
        BranchHelper.getBranchTimeSlots('Service Appointment',branch[0].Id, item.Id,'','',Datetime.now().date());
        System.assertEquals(1, branch.size(), 'Test Accounts have more than 1 record');
    }
    
    @isTest
    public static void VerifyNearbyBranches1()
    {
        List<dmpl__Branch__c> res = BranchHelper.getNearbyBranches('', '', 100);
        System.assert(res.size() != 0);
    }
    
    @isTest
    public static void VerifyNearbyBranches2()
    {
        List<dmpl__Branch__c> res = BranchHelper.getNearbyBranches('444603', '', 0);
        System.assert(res.size() == 0, 'branch data');
    }
    
    @isTest
    public static void VerifyNearbyBranches3()
    {
        List<dmpl__Branch__c> res = BranchHelper.getNearbyBranches('', 'Amravati', 0);
        System.assert(res.size() == 0, 'branch data');
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
    
    private static void CreateContactAddress()
    {
        List<dmpl__ContactAddress__c> contactAddress = new List<dmpl__ContactAddress__c>();
        Account account = [Select Id,Name From Account WHERE Name = 'Customer-Test-Account' LIMIT 1];
        contactAddress.add(new dmpl__ContactAddress__c(dmpl__AccountId__c = account.Id,
                                                       Name = 'Test - Contact - Address',
                                                       dmpl__PostalCode__c = '465291',
                                                       dmpl__Street__c = 'Model-Town',
                                                       dmpl__AddressType__c = 'Both'
                                                      ));
        insert contactAddress;
    }
    
    private static void CreateBranch()
    {
        List<dmpl__Branch__c> branch = new List<dmpl__Branch__c>();
        Account partnerAccount = [Select Id,Name From Account WHERE Name = 'Partner-Test-Account' LIMIT 1];
        dmpl__ContactAddress__c contactAddress = [Select Id,Name FROM dmpl__ContactAddress__c LIMIT 1];
        branch.Add(new dmpl__Branch__c(dmpl__PartnerAccountId__c =partnerAccount.Id,
                                       Name = 'Test-Branch',
                                       dmpl__IsActive__c = true,
                                       dmpl__BranchType__c = 'SalesBranch',
                                       dmpl__AddressId__c = contactAddress.Id,
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
                                   dmpl__TrackAsset__c = true,                               
                                   dmpl__IsActive__c = true,
                                   dmpl__IsRegistrationRequired__c = true,
                                   dmpl__GTIN__c = 'BR123',
                                   dmpl__RFID__c = 'O1234fgh'
                                  ));
        insert item;
    }
    
    private static void CreateBranchTimeSlot()
    {
        List<dmpl__BranchTimeSlot__c> branchTimeSlot = new List<dmpl__BranchTimeSlot__c>();
        dmpl__Branch__c branch = [Select Id,Name From dmpl__Branch__c LIMIT 1];
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        branchTimeSlot.Add(new dmpl__BranchTimeSlot__c(dmpl__BranchId__c = branch.Id,
                                                       dmpl__TransactionType__c = 'Product Demo',
                                                       Name = 'Test - Name',
                                                       dmpl__IsActive__c = True,
                                                       dmpl__ApplicableToItem__c= item.Id,
                                                       dmpl__StartTime__c = time.newInstance(10, 20, 5, 200),
                                                       dmpl__MaximumCapacity__c = 30,                                                    
                                                       dmpl__MondayCapacity__c = 30,
                                                       dmpl__TuesdayCapacity__c = 30,
                                                       dmpl__WednesdayCapacity__c = 30,
                                                       dmpl__ThursdayCapacity__c = 30,
                                                       dmpl__FridayCapacity__c = 30,
                                                       dmpl__SaturdayCapacity__c = 30,
                                                       dmpl__SundayCapacity__c = 30
                                                      ));
        insert branchTimeSlot;
    }
}