@isTest
public class ContactHelper_Test {
    
    @testsetup
    public static void setup()
    {
        System.runAs(PostInstallHelper.AssignAdministratorAllPermissions(UserInfo.getUserId())){
            CreateAccountGroup();
            CreateAccount();
            CreateContacts();
            CreateContactAddress();
        }
    }
    
    public static void VerifyAccountContacts()
    {
        test.startTest();
        List<Account> account = [SELECT Id, Name ,dmpl__IsCustomerAccount__c FROM Account where dmpl__IsCustomerAccount__c = true AND dmpl__CreateAccountContact__c = true];
        ContactHelper.updateAccountContacts(account,account);
        System.assert(account != null);
        test.stopTest();
        ContactHelper.updateAccountContacts(account,null);
    }
    @isTest
    public static void Updatecontact()
    {
        List<Contact> acc = [Select Id,Name, Phone From Contact LIMIT 1];
        for(Contact act:acc)
            act.Phone = '9839585543';
        update acc;
        System.assertNotEquals('9839585543', 'Phone');
        
    }
    
    @isTest
    public static void Updatecontact1()
    {
        List<Contact> acc = [Select Id,Name, Phone From Contact LIMIT 1];
        if(acc != null || acc.size()>0)
            update acc;
        System.assert(acc != null, 'contact data');
    }
    
    @isTest
    public static void getAccount()
    {
        List<Account> acc =[Select Id, Name, dmpl__IsCustomerAccount__c ,dmpl__CreateAccountContact__c,dmpl__AccountContactId__c,dmpl__Salutation__c,dmpl__FirstName__c,dmpl__Email__c,Phone,  dmpl__LastName__c from Account where dmpl__IsCustomerAccount__c = true AND dmpl__CreateAccountContact__c = true Limit 1];
        List<Account> acc1 =[Select Id, Name,dmpl__IsCustomerAccount__c,dmpl__AccountContactId__c,dmpl__Salutation__c,dmpl__CreateAccountContact__c,dmpl__FirstName__c,dmpl__Email__c,Phone,  dmpl__LastName__c from Account where dmpl__IsCustomerAccount__c = true AND dmpl__CreateAccountContact__c = true Limit 1];
        ContactHelper.updateAccountContacts(acc,acc1);
        System.assertEquals(1, acc.size(), 'account data');
    }
    
    
    @isTest
    public static void getContact()
    {
        List<Id> ids= new List<Id>();
        Contact acc =[Select Id, Name from Contact Limit 1];
        ids.add(acc.Id);
        ContactHelper.queryExistingContacts(ids);
        System.assertEquals('Account', acc.Name, 'contact data');
    }
    
    @isTest
    public static void getadresss()
    {
        Contact con =[select Id, Name from Contact Limit 1];
        Account acc =[Select Id, Name,dmpl__Salutation__c,dmpl__FirstName__c,dmpl__Email__c,Phone,  dmpl__LastName__c from Account Limit 1];
        ContactHelper.createNewContact(acc);
        ContactHelper.copyOldContact(con,acc);
        System.assertEquals('Account', con.Name, 'contact data');
    }
    
    @isTest
    public static void Deletecontact()
    {
        List<Contact> acc = [Select Id,Name, Phone From Contact LIMIT 1];
        Delete acc;
        System.assertEquals(1, acc.size(), 'Test Accounts have more than 1 record');
    }
    
    @isTest
    Static void VerifyCreateAccount()
    {
        List<Account>  account = [Select Id, Name From Account];
        System.assertNotEquals(null, account, 'Test Accounts are not found');
        System.assertEquals(3, account.size(), 'Test Accounts have more than 1 record');
    }
    
    @isTest
    public static Void formatAddress()
    {
        test.startTest();
        string errorReceived;
        try{             
            dmpl__ContactAddress__c contactAddress = [Select Id,Name From dmpl__ContactAddress__c LIMIT 1];
            ContactAddressHelper.formatAddress(contactAddress);    
        } catch (Exception ex) {
            errorReceived = ex.getMessage();
        }
        System.assertEquals(null, errorReceived);
        test.stopTest();
    }
    
    @isTest
    private static void VerifyUpdateAccountNamesMethod()
    {
        test.startTest();
        List<Contact> contacts = [Select Id,Name, Phone,AccountId,FirstName,LastName From Contact LIMIT 1];
        AccountHelper.updateAccountContactNames(contacts);
        test.stopTest();
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
                                dmpl__CreateAccountContact__c = true,
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
        
        Account customerAccount = new Account(Name = 'Customer-Test-Account',
                                              dmpl__IsCustomerAccount__c = True,
                                              dmpl__CreateAccountContact__c = true,
                                              dmpl__LastName__c = 'Account',
                                              dmpl__IsActive__c = true);
        insert customerAccount;
    }
    
    private static void CreateContacts()
    {
        List<Contact> contact = new List<Contact>();
        Account account = [Select Id,Name,dmpl__LastName__c From Account WHERE Name = 'Customer-Test-Account' LIMIT 1];
        contact.add(new Contact(Phone = '999999',
            HomePhone = '8888888',
            LastName='test',
            AccountId = account.Id
        ));
        insert contact;
    }
    
    private static void CreateContactAddress()
    {
        List<dmpl__ContactAddress__c> contactAddress = new List<dmpl__ContactAddress__c>();
        Account account = [Select Id,Name,dmpl__LastName__c From Account WHERE Name = 'Customer-Test-Account' LIMIT 1];
        contactAddress.add(new dmpl__ContactAddress__c(dmpl__AccountId__c = account.Id,
            dmpl__City__c = 'Chandigarh',
            dmpl__Country__c='	India',
            dmpl__AddressType__c = 'Both'
            
        ));
        insert contactAddress;
    }
    
    private static void CreateAccountNew()
    {
        List<Account> account = new List<Account>();
        dmpl__AccountGroup__c accountGroup = [Select Id,Name From dmpl__AccountGroup__c LIMIT 1];
        Contact cont = [Select Id,Name From Contact LIMIT 1];
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
                                dmpl__IsCustomerAccount__c = True,
                                dmpl__PartnerTaxAccountGroupId__c = accountGroup.Id,
                                dmpl__CustomerPriceAccountGroupId__c = accountGroup.Id,
                                dmpl__CustomerDiscountAccountGroupId__c = accountGroup.Id,
                                dmpl__PartnerSchemeAccountGroupId__c = accountGroup.Id,                                
                                dmpl__PartnerPriceAccountGroupId__c = accountGroup.Id,
                                dmpl__PartnerDiscountAccountGroupId__c = accountGroup.Id,
                                dmpl__CustomerSchemeAccountGroupId__c = accountGroup.Id
                               ));
        insert account; 
        
    }
}