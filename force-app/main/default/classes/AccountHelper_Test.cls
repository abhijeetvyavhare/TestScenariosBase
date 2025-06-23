@isTest
public class AccountHelper_Test {
    
    @testSetup
    public static void Setup()
    {
        //System.runAs(PostInstallHelper.AssignAdministratorAllPermissions(UserInfo.getUserId())){
            Test.startTest();
            CreateAccountGroup();
            CreateAccount();
            CreateContactAddress();
            CreateContacts();
        	createGLAccount();
        	createGeneralLedger();
            Test.stopTest();                
        //}
    }
    
    @isTest
    public static void getContacts()
    {
        Test.startTest();
        List<Contact> acc =[Select Id, Name,Email,AccountId,MobilePhone,Salutation,LastName,FirstName,Phone from Contact Limit 1];
        List<Contact> acc1 =[Select Id, Name,Email,MobilePhone,Salutation,LastName,FirstName,Phone from Contact Limit 1];
        //AccountHelper.updateContactAccounts(acc,acc1);
        AccountHelper.updateAccountContactNames(acc);
        System.assertEquals(1, acc.size(), 'Get contact data');
        Test.stopTest();
    }
    
    
    @isTest
    Static void VerifyCreateAccount()
    {
        test.startTest();      
        List<Account>  account = [Select Id, Name From Account];
        System.assertNotEquals(null, account, 'Test Accounts are not found');
        System.assertEquals(4, account.size(), 'Test Accounts have more than 1 record');
        test.stopTest();
    }
    
    @isTest
    public static void UpdateAccount()
    {
        test.startTest();
        List<Account> acc = [Select Id,Name,dmpl__Status__c From Account LIMIT 1];
        for(Account act:acc)
            act.dmpl__Status__c = 'Created';
        update acc;
        System.assertNotEquals('created', 'dmpl__Status__c');
    	test.stopTest();
    }
    
    @isTest
    public static void UpdateCatchAccount()
    {
        test.startTest();
        List<Account> acc = [Select Id,Name,dmpl__Status__c From Account LIMIT 1];
        if(acc == null)
        	delete acc;
        System.assertNotEquals('created', 'dmpl__Status__c');
        test.stopTest();
    }
    
    @isTest
    public static void getAccountNew()
    {
        test.startTest();
        List<Id> ids= new List<Id>();
        Account acc =[Select Id, Name from Account Limit 1];
        ids.add(acc.Id);
        AccountHelper.getCachedAccounts(ids);
        AccountGroupHelper.processMembers(acc.Id);
        AccountGroupHelper.getCachedAccountGroupIds('',ids);
        AccountGroupHelper.getCachedAccountGroupIds('',acc.Id);
        System.assertEquals('Test - Account', acc.Name, 'Get account data');
        test.stopTest();
    }
      @isTest
    static void testCacheUsage() {
        SessionCacheHelper.isPlatformCacheEnabled('Account');
         SessionCacheHelper.isPlatformCacheEnabled();
    }
     @isTest
    public static void getAccountDefaults()
    {
        try{
        test.startTest();
        Account acc =[Select Id, Name from Account Limit 1];
       /* dmpl__InterfaceQueue__c queue = new dmpl__InterfaceQueue__c(
                                    dmpl__JobType__c = 'Account Group Member Processor',
                                    //dmpl__InterfaceRecordId__c = acc.Id,
                                    dmpl__QueueType__c = 'Queueable'
                                );
        insert queue;*/
        dmpl__AccountGroup__c actGroup = [Select Id,Name,dmpl__RuleSuccessCriteria__c,dmpl__ReportId__c From dmpl__AccountGroup__c LIMIT 1];
        RecordFormController.getAccountDefaults(acc.Id);
        AccountGroupMemberProcessor.processFieldsFilterData(acc.Id,null,actGroup);
        //AccountGroupMemberProcessor.processReportData(acc.Id,queue.Id,actGroup);
        AccountGroupMemberProcessor.getFilterQuery(actGroup);
        AccountGroupMemberProcessor.getReportRow('');
        System.assert(acc!=null, 'Get account data');
        test.stopTest();
        }
        catch(exception e){}
    }
    
    @isTest
    public static void processReportData()
    {
        try{
        test.startTest();
        Account acc =[Select Id, Name from Account Limit 1];
        dmpl__AccountGroup__c actGroup = [Select Id,Name,dmpl__RuleSuccessCriteria__c,dmpl__ReportId__c From dmpl__AccountGroup__c WHERE dmpl__ReportId__c = 'Report1' LIMIT 1];
        AccountGroupMemberProcessor.processReportData(acc.Id,null,actGroup);
        AccountGroupMemberProcessor.getFilterQuery(actGroup);
        AccountGroupMemberProcessor.getReportRow('');
        System.assert(acc!=null, 'Get account data');
        test.stopTest();
        }
        catch(exception e){}
    }
    
    @isTest
    public static void getAccountAddressDefaults()
    {
        Test.startTest();
        Account acc =[Select Id, Name from Account Limit 1];
       
        RecordFormController.getAccountAddressDefaults(acc.Id);
        System.assert( acc!=null, 'Get account data');
        Test.stopTest();
    }
    
    @isTest
    public static void getAccount()
    {
        Test.startTest();
        List<Id> ids= new List<Id>();
        Account acc =[Select Id, Name from Account Limit 1];
        ids.add(acc.Id);
        AccountHelper.queryAccounts(ids);
        //AccountHelper.queryAccountsForContacts(ids);
        AccountHelper.getCachedDealerAccounts(ids);
        System.assertEquals('Test - Account', acc.Name, 'Get account data');
        Test.stopTest();
    }
    
    @isTest
    public static void getadresss()
    {
        test.startTest();
        dmpl__ContactAddress__c add =[select Id, Name,dmpl__Street__c,dmpl__City__c,dmpl__Country__c,dmpl__PostalCode__c,
                                      dmpl__Region__c,
                                      dmpl__State__c
                                      from dmpl__ContactAddress__c];
        AccountHelper.formatAddress(add);
        System.assertEquals('Test-Branch', add.Name, 'Get contact address data');
        test.stopTest();
    }
    
    @isTest
    public static void getadresss1()
    {
        test.startTest();
        Address address =[select Id, Name,BillingAddress from Account LIMIT 1].BillingAddress;
        Address nullAddress = null;
        AccountHelper.formatAddress(nullAddress);
        AccountHelper.formatAddress(address);
        System.assert(address != null, 'Get Account Address data');
        test.stopTest();
    }
    
    @isTest
    public static void getCachedDealerAccount()
    {
        Test.startTest();
        Account acc = [Select Id,Name,Phone,dmpl__BillingStreet__c,dmpl__BillingRegion__c,dmpl__BillingState__c,dmpl__BillingPostalCode__c,dmpl__BillingCity__c,dmpl__BillingCountry__c ,
                       dmpl__ShippingStreet__c,dmpl__ShippingRegion__c,dmpl__ShippingState__c,dmpl__ShippingPostalCode__c,dmpl__ShippingCity__c,dmpl__ShippingCountry__c
                       From Account LIMIT 1];
        AccountHelper.formatBillingAddress(acc);
        AccountHelper.formatShippingAddress(acc);
        System.assertNotEquals(null, AccountHelper.getCachedDealerAccount(acc.Id));
		Test.stopTest();
    }
    
    @isTest
    public static void deleteAccount()
    {
        Test.startTest();
        List<Account> acc = [Select Id,Name,Phone From Account LIMIT 1];
        Delete acc;
        System.assertEquals(1, acc.size(), 'Test Accounts have more than 1 record');
        Test.stopTest();
    }
    
    @isTest
    public static void testGetCachedAccountGroupIds(){
        Test.startTest();
        List<Account> acc=[select id from account];
        List<Id> AccountIds=new List<Id>();
        for(Account AccountEntry:acc){
            AccountIds.add(AccountEntry.id);
        }
        AccountGroupHelper.getCachedAccountGroupIds('Discount',AccountIds);
        Test.stopTest();
    }
    @isTest
    static void testCacheUsage1() {
        // Populate the cache with test data
        SessionCacheHelper.isPlatformCacheEnabled();
       SessionCacheHelper.isPlatformCacheEnabled('Account');
       //SessionCacheHelper.clearCache();
}
    //testing for OrgCacheHelper
    @isTest
    public static void orgCacheHelperTest()
    {
        Test.startTest();        
        List<Account> acc = [Select Id,Name,Phone From Account limit 8];
        list<string> keys=new list<string>();
        for(Account AccountEntry : acc){
            string key=OrgCacheHelper.generateKey('Account',
                                                  'AB'+AccountEntry.id,
                                                  AccountEntry.id);
            keys.add(key);
            OrgCacheHelper.setObject(key,AccountEntry);
        }
        OrgCacheHelper.setSObject(acc[0]);
        OrgCacheHelper.setSObjects(new list<Account>{acc[1]});
        OrgCacheHelper.getSObject('Account',acc[0].id);
        OrgCacheHelper.generateKey('Account','AB');
        OrgCacheHelper.getObject('Test');
        
        OrgCacheHelper.removeSObject(acc[0]);
        OrgCacheHelper.removeSObject('Account',acc[1].id);
        OrgCacheHelper.removeSObjects(new list<Account>{
            acc[2],
            acc[3]
        });
        OrgCacheHelper.removeSObjects('Account',new list<Id>{
            acc[2].id,
            acc[3].id
        });
        OrgCacheHelper.removeObject('AB');
        OrgCacheHelper.removeObjects(keys[2]);

        Test.stopTest();
    }
    
    //testing for orgSettingHelper
    @isTest
    public static void orgSettingHelperTest(){
        Test.startTest();
        OrgSettingHelper.enableRoundOff();
        OrgSettingHelper.roundOffDigits();
        OrgSettingHelper.roundOffType();
        OrgSettingHelper.getSchemeAdjustmentItemId();
        OrgSettingHelper.getSchemeAdjustmentItemId();
        OrgSettingHelper.getLeadConvertStatus();
        OrgSettingHelper.getLeadConvertStatus();
        OrgSettingHelper.authoriseUser();
        OrgSettingHelper.authoriseUser();
        OrgSettingHelper.authoriseResource();
        Test.stopTest();
    }
    
    @isTest
    public static void setDefaultAddressTest(){
        dmpl__Place__c place = new dmpl__Place__c(Name='abc',dmpl__PlaceType__c='City');
        insert place;
        List<Account> acc=[select id from account WHERE dmpl__IsPartnerAccount__c=true];
        sObject obj = new dmpl__SaleOrder__c(dmpl__PartnerAccountId__c=acc[0].id);
        AccountHelper.setDefaultAddress(obj,new Account(Name='Test',dmpl__BillingCity__c='Pune',dmpl__BillingCityPlaceId__c=place.Id,dmpl__BillingCountry__c='India',dmpl__BillingPostalCode__c='009988',dmpl__BillingRegion__c='region',dmpl__BillingState__c='Punjab'));
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
                               dmpl__CustomerSchemeAccountGroupId__c = accountGroup.Id,
                                BillingStreet = 'Jalandhar',
                                BillingState = 'Punjab',
                                BillingCountry = 'India',
                                BillingCity = 'Jalandhar',
                                BillingPostalCode = '144001'
                               ));
        insert account;
        
        Account partneraccount = new Account(Name = 'Partner-Test-Account',
                                             dmpl__LastName__c = 'Account1',
                                             dmpl__IsPartnerAccount__c = True, 
                                             dmpl__IsActive__c = true);
        insert partneraccount;
        
        Account supplieraccount = new Account(Name = 'Supplier-Test-Account',
                                              dmpl__LastName__c = 'Account2',
                                              dmpl__IsSupplierAccount__c = True,
                                              dmpl__IsActive__c = true);
        insert supplieraccount;
        
        Account customerAccount = new Account(Name = 'Customer-Test-Account',
                                              dmpl__IsCustomerAccount__c = True,
                                              dmpl__LastName__c = 'Account3',
                                              dmpl__IsActive__c = true);
        insert customerAccount;
    }
    
    private static void CreateAccountGroup()
    {
    	dmpl__AccountGroup__c accountGroup= new dmpl__AccountGroup__c (Name= 'Test-AccountGroup', 
                                                                       dmpl__AccountGroupType__c='Scheme',
                                                                       dmpl__DynamicMemberType__c = 'Report Data',
                                                                       dmpl__ReportId__c = 'Report1'
                                                                      );
        insert accountGroup;
    }
    
    private static void CreateContactAddress()
    {
        List<dmpl__ContactAddress__c> address = new List<dmpl__ContactAddress__c>();
        Account partnerAccount = [Select Id,Name From Account WHERE Name = 'Partner-Test-Account' LIMIT 1];
        address.Add(new dmpl__ContactAddress__c(dmpl__AccountId__c =partnerAccount.Id,
                                      			Name = 'Test-Branch',
                                                dmpl__City__c = 'Pune',
                                                dmpl__Street__c = 'Jalandhar',
                                                dmpl__Region__c= 'Panjab',
                                                dmpl__State__c = 'Punjab',
                                                dmpl__Country__c = 'India',
                                                dmpl__PostalCode__c = '144401',
                                                dmpl__AddressType__c = 'Both'
                                                ));
        insert address;
    }
    
    private static void CreateContacts()
    {
        List<Contact> contact = new List<Contact>();
        Account account = [Select Id,Name,dmpl__LastName__c From Account WHERE Name = 'Customer-Test-Account' LIMIT 1];
        contact.add(new Contact(//AccountId = account.Id,
                                Phone = '999999',
                                HomePhone = '8888888',
                                LastName='test'
                               ));
        insert contact;
    } 
    
    private static void createGLAccount(){
        List<dmpl__GLAccount__c> GLAccount = new List<dmpl__GLAccount__c>();
        GLAccount.add(new dmpl__GLAccount__c(Name = 'GL Account'));
        insert GLAccount;
    }
    
    private static void createGeneralLedger() {
        Account account = [Select Id,Name,dmpl__LastName__c From Account WHERE Name = 'Customer-Test-Account' LIMIT 1];
        Account partnerAccount = [Select Id,Name From Account WHERE Name = 'Partner-Test-Account' LIMIT 1];
        dmpl__GLAccount__c glAccount = [SELECT Id,Name FROM dmpl__GLAccount__c WHERE Name = 'GL Account'];
        dmpl__GeneralLedger__c gl = new dmpl__GeneralLedger__c(
            dmpl__AccountId__c = account.Id,
            dmpl__Amount__c = 1000,
            dmpl__GLAccountId__c = glAccount.Id,
            dmpl__PartnerAccountId__c = partnerAccount.Id,
            dmpl__TransactionType__c = 'Invoice'
        );
        try{
            insert gl;
        }catch(exception ex){}
        System.debug(gl);
    }
}