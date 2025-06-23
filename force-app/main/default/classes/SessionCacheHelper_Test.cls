@isTest
public class SessionCacheHelper_Test {

    @testSetup
    public static void Setup()
    {
        CreateAccount(); 
    }
    
    @isTest
    public static void isPlatformCacheEnabled()
    {
        test.startTest();
        string errorReceived;
        try{             
        	SessionCacheHelper.isPlatformCacheEnabled('Account');
        } catch (Exception ex) {
            errorReceived = ex.getMessage();
        }
        System.assertEquals(null, errorReceived);
        test.stopTest();
    }
    
    @isTest
    public static void removeSObjects()
    {
        test.startTest();
        string errorReceived;
        try{             
        	SessionCacheHelper.removeObject('Key');
        } catch (Exception ex) {
            errorReceived = ex.getMessage();
        }
        System.assertEquals(null, errorReceived);

        	
        test.stopTest();
    }
    
    @isTest
    public static void setSObjects()
    {
        test.startTest();
        string errorReceived;
        try{             
            List<Account> account = [Select Id,Name From Account LIMIT 1];
        	SessionCacheHelper.setSObjects(account);

        } catch (Exception ex) {
            errorReceived = ex.getMessage();
        }
        System.assertEquals(null, errorReceived);

        test.stopTest();
    }
    
    @isTest
    public static void removeSObjects1()
    {
        test.startTest();
        string errorReceived;
        try{             
            List<Account> account = [Select Id,Name From Account LIMIT 1];
        	SessionCacheHelper.removeSObjects(account);

        } catch (Exception ex) {
            errorReceived = ex.getMessage();
        }
        System.assertEquals(null, errorReceived);

        test.stopTest();
    }
    
    @isTest
    public static void setSObject()
    {
        test.startTest();
        string errorReceived;
        try{             
            Account account = [Select Id,Name From Account LIMIT 1];
        	SessionCacheHelper.setSObject(account);

        } catch (Exception ex) {
            errorReceived = ex.getMessage();
        }
        System.assertEquals(null, errorReceived);

        test.stopTest();
    }
    
    @isTest
    public static void removeSObject()
    {
        test.startTest();
        string errorReceived;
        try{             
            Account account = [Select Id,Name From Account LIMIT 1];
        	SessionCacheHelper.removeSObject(account);

        } catch (Exception ex) {
            errorReceived = ex.getMessage();
        }
        System.assertEquals(null, errorReceived);

        test.stopTest();
    }
    
    @isTest
    public static void getSObject()
    {
        test.startTest();
        //string errorReceived;
        //try{             
            Account account = [Select Id,Name From Account LIMIT 1];
        	SessionCacheHelper.getSObject('Account', account.Id);

        //} catch (Exception ex) {
         //   errorReceived = ex.getMessage();
        //}
        System.assert(account != null, 'Account Data');

        test.stopTest();
    }
    
    private static void CreateAccount()
    {
        List<Account> account = new List<Account>();
        account.add(new Account(Name = 'Test - Account', 
                                dmpl__LastName__c = 'Sale Invoice',
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
                                dmpl__IsCustomerAccount__c = False
                               ));
        insert account;
        
        
        Account partneraccount = new Account(Name = 'Partner-Test-Account',
                                             dmpl__LastName__c = 'Sale Invoice',
                                             dmpl__IsPartnerAccount__c = True, 
                                             dmpl__IsActive__c = true);
        insert partneraccount;
        
        
        Account customerAccount = new Account(Name = 'Customer-Test-Account',
                                              dmpl__LastName__c = 'Sale Invoice',
                                              dmpl__IsCustomerAccount__c = True,
                                              dmpl__IsActive__c = true);
        insert customerAccount;
    }
}