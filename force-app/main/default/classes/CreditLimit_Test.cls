@isTest
public class CreditLimit_Test {
    
     
    @testSetup
    public static void Setup()
    {
            CreateAccount();
            CreateCreditLimit();
    }

  	@isTest
    Static void VerifyCreateAccount()
    {
        Test.startTest();
        List<Account>  account = [Select Id, Name From Account];
        System.assertNotEquals(null, account, 'Test Accounts are not found');
        System.assertEquals(4, account.size(), 'Test Accounts have more than 1 record');
        Test.stopTest();
    }
    
   @isTest
   Public Static void VerifyUpdate()
    {
        Test.startTest();
        dmpl__CreditLimit__c  credit = [Select Id, Name,dmpl__CreditDays__c From dmpl__CreditLimit__c Limit 1];
        credit.dmpl__CreditDays__c=24;
        Update credit;
        System.assert(credit!=null, 'Test Accounts have more than 1 record');
        Test.stopTest();
    }
    
   @isTest
   Public Static void VerifyDelete()
   {
        Test.startTest();
        dmpl__CreditLimit__c  credit = [Select Id, Name,dmpl__CreditDays__c From dmpl__CreditLimit__c Limit 1];
        delete credit;
        System.assert(credit!=null, 'Test Accounts have more than 1 record');
        Test.stopTest();
   }

 private static void CreateAccount()
    {
        List<Account> account = new List<Account>();
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
                               dmpl__IsCustomerAccount__c = False
                             
                               ));
        insert account;
        
        Account partneraccount = new Account(Name = 'Partner-Test-Account',
                                             dmpl__LastName__c = 'Account',
                                             dmpl__IsPartnerAccount__c = True, 
                                             dmpl__IsActive__c = true);
        insert partneraccount;
        
        Account supplieraccount = new Account(Name = 'Supplier-Test-Account',
                                              dmpl__LastName__c = 'Account',
                                              dmpl__IsSupplierAccount__c = True,
                                              dmpl__IsActive__c = true);
        insert supplieraccount;
        
        Account customerAccount = new Account(Name = 'Customer-Test-Account',
                                              dmpl__IsCustomerAccount__c = True,
                                              dmpl__LastName__c = 'Account',
                                              dmpl__IsActive__c = true);
        insert customerAccount;
    }
   

    private static void CreateCreditLimit()
    {
        List<dmpl__CreditLimit__c> creditLimit = new List<dmpl__CreditLimit__c>();
        Account customerAcc =[select Id , Name from Account Where dmpl__IsCustomerAccount__C=true Limit 1];
        Account partnerAcc =[select Id , Name from Account Where dmpl__IsPartnerAccount__C=true Limit 1];
        creditLimit.add(new dmpl__CreditLimit__c(dmpl__AccountId__c = customerAcc.Id, 
            					                 dmpl__CreditDays__c = 30,
                                                 dmpl__PartnerAccountId__c =partnerAcc.Id
                                                 ));
        Insert creditLimit;
    }
        
}