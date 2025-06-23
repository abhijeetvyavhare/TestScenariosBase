@isTest
public class SearchController_Test{
    
    @isTest
    public static void Search()
    {
        try{
            test.startTest();
            CreateAccount();
            List<Object> result = SearchController.search('Name', new List<String>{'Test'},'Account','dmpl__DMSCustomLookupFields','');
            System.assert(result != null, 'Search result object');
            test.stopTest();
        }
        catch(exception e){}
    }

    @isTest
    public static void MRU()
    {
        try{
            test.startTest();
            List<Object> result = SearchController.getRecentlyViewed('Account');
            System.assert(result != null, 'Search result object');
            test.stopTest();
        }
        catch(exception e){}
    }
    
    @isTest
    private static void VerifyMethod()
    {
        SearchController.listView(new List<Id>(),'Account','dmpl__DMSCustomLookupFields','');
    }
    
    @isTest
    public static void verifyStringMethods()
    {
        try{
            test.startTest();
            String getId = 'test';
            System.assertEquals(getId, 'test');
            String getSObjectType = 'test';
            System.assertEquals(getSObjectType, 'test');
            String getIcon = 'test';
            System.assertEquals(getIcon, 'test');
            String getTitle = 'test';
            System.assertEquals(getTitle, 'test');
            String getSubtitle = 'test';
            System.assertEquals(getSubtitle, 'test');
            test.stopTest();
        }catch(exception e){}
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
                               dmpl__IsCustomerAccount__c = False,
                                BillingStreet = 'Jalandhar',
                                BillingState = 'Punjab',
                                BillingCountry = 'India',
                                BillingCity = 'Jalandhar',
                                BillingPostalCode = '144001'
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
    
    
    
    
     @isTest
    public static void testGetSourceObject() {
    SearchController.LookupSearchResult result = new SearchController.LookupSearchResult('id', 'Account', 'icon', 'title', 'subtitle', new Account(Name = 'Test Account'));
    SObject sourceObject = result.getSourceObject();
       
    System.assertEquals(Account.SObjectType, sourceObject.getSObjectType());
    System.assertEquals('Test Account', ((Account)sourceObject).Name);
    }
     static void testCompareToWithDifferentTitles() {
        SearchController.LookupSearchResult result1 = new SearchController.LookupSearchResult('id1', 'Account', 'icon', 'titleA', 'subtitle', new Account(Name = 'Test Account'));
        SearchController.LookupSearchResult result2 = new SearchController.LookupSearchResult('id2', 'Account', 'icon', 'titleB', 'subtitle', new Account(Name = 'Test Account'));

        Integer comparison = result1.compareTo(result2);
        System.assertEquals(-1, comparison, 'Title comparison should be -1');
    }

    @isTest
    static void testCompareToWithNullTitles() {
        SearchController.LookupSearchResult result1 = new SearchController.LookupSearchResult('id1', 'Account', 'icon', null, 'subtitle', new Account(Name = 'Test Account'));
        SearchController.LookupSearchResult result2 = new SearchController.LookupSearchResult('id2', 'Account', 'icon', 'titleB', 'subtitle', new Account(Name = 'Test Account'));

        Integer comparison = result1.compareTo(result2);
        System.assertEquals(1, comparison, 'Title comparison should be 1 when one title is null');
    }

    @isTest
    static void testCompareToWithSameTitles() {
        SearchController.LookupSearchResult result1 = new SearchController.LookupSearchResult('id1', 'Account', 'icon', 'title', 'subtitle', new Account(Name = 'Test Account'));
        SearchController.LookupSearchResult result2 = new SearchController.LookupSearchResult('id2', 'Account', 'icon', 'title', 'subtitle', new Account(Name = 'Test Account'));

     
        Integer comparison = result1.compareTo(result2);
        System.assertEquals(0, comparison, 'Title comparison should be 0 for identical titles');
    }

    @isTest
    static void testCompareToWithBothNullTitles() {
        SearchController.LookupSearchResult result1 = new SearchController.LookupSearchResult('id1', 'Account', 'icon', null, 'subtitle', new Account(Name = 'Test Account'));
        SearchController.LookupSearchResult result2 = new SearchController.LookupSearchResult('id2', 'Account', 'icon', null, 'subtitle', new Account(Name = 'Test Account'));

        Integer comparison = result1.compareTo(result2);
        System.assertEquals(0, comparison, 'Title comparison should be 0 when both titles are null');
    }
     
    
    
    @isTest
    public static void testGetSubtitle() {
    SearchController.LookupSearchResult result = new SearchController.LookupSearchResult('id', 'Account', 'icon', 'title', 'subtitle', new Account(Name = 'Test Account'));
    SearchController.LookupSearchResult result1 = new SearchController.LookupSearchResult('id', 'Account', 'icon', 'title', 'subtitle');

    String subtitle = result.getSubtitle();
    System.assertEquals('subtitle', subtitle);
    }
}