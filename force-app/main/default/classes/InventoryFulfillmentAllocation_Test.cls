@Istest
public class InventoryFulfillmentAllocation_Test {
      @testSetup
    public static void Setup(){
         CreateAccountGroup();
         CreateAccount();
         CreateBranch();
        
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
    @istest
    public static void createFullFillment(){
        Account partnerAccount1 = [Select Id,Name From Account WHERE Name = 'Partner-Test-Account' LIMIT 1]; 
        dmpl__Branch__c Branch = [Select Id,Name From dmpl__Branch__c WHERE Name = 'Test-Branch' LIMIT 1];
        List<dmpl__InventoryFulfillment__c>inv = new List<dmpl__InventoryFulfillment__c>();
        inv.add(new dmpl__InventoryFulfillment__c (dmpl__PartnerAccountId__c = partnerAccount1.Id,
                                                   dmpl__BranchId__c = Branch.Id));
        insert inv;
    }
    

}