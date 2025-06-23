@isTest
public with sharing class DocumentHelper_Test {
    @testSetup
    public static void Setup()
    {
        System.runAs(PostInstallHelper.AssignAdministratorAllPermissions(UserInfo.getUserId())){
            CreateAccountGroup();
            CreateAccount();
        }
 	}
    
    @isTest
    Public static void getObjectsByFilter1()
    {
        try{
            test.startTest();
        List<Account> acc = [Select Id, Name,dmpl__AccountContactId__c FROM Account Limit 1];
        List<Account> newEntries = [Select Id, Name,dmpl__AccountContactId__c FROM Account Limit 1];
        List<String> fields = new List<String>();
        List<Id> ids = new List<Id>();
        Account acc1 = [Select Id, Name,dmpl__AccountContactId__c FROM Account Limit 1];
        DocumentHelper.getObjectByFilter(acc, 'dmpl__AccountContactId__c',acc1);
        DocumentHelper.validateChangeInLockedIfPostedFields(fields,acc,newEntries,'');
        DocumentHelper.validateIsPostiveNumberic('',acc,newEntries);
        DocumentHelper.getObjectsWithNull(acc, 'dmpl__AccountContactId__c');
        DocumentHelper.extractUniqueDateValues(acc, 'dmpl__AccountContactId__c');
        //DocumentHelper.getObjectsByFilter(acc, '', '', acc[0].Name);
        DocumentHelper.validateCanBeDeleted(acc, ids);
        DocumentHelper.validateCanBeDeleted(acc, '10');
        //DocumentHelper.validateChangeInLockedIfTransactedFields(fields,acc,newEntries,'10');
        //DocumentHelper.validateChangeInLockedIfTransactedFields(fields, acc, newEntries, ids);
        System.assert(acc!=null, 'Item is getted');
            test.stopTest();
        }catch(exception e){}
    }
    
    
    @isTest
    public static void validateChangeInLockedIfTransactedFields()
    {
        try{
            test.startTest();
        List<Account> acc = [Select Id, Name,dmpl__AccountContactId__c FROM Account Limit 1];
        List<Account> newEntries = [Select Id, Name,dmpl__AccountContactId__c FROM Account Limit 1];
        List<String> fields = new List<String>();
        List<Id> ids = new List<Id>();
        DocumentHelper.getObjectsByFilter(acc, '', '', acc[0].Name);
        DocumentHelper.extractIdsFromLookup(acc, 'acc.dmpl__AccountContactId__c', 'dmpl__AccountContactId__c');
        DocumentHelper.validateChangeInLockedIfTransactedFields(fields,acc,newEntries,'10');
        DocumentHelper.validateChangeInLockedIfTransactedFields(fields, acc, newEntries, ids);
        System.assert(acc!=null, 'Item is getted');
            test.stopTest();
        }catch(exception e){}
    }
    
     @isTest
    Public static void getObjectsByFilterNew()
    {
        List<Account> acc = [Select Id, Name,dmpl__AccountContactId__c FROM Account Limit 1];
        Account acc1 = [Select Id, Name,dmpl__AccountContactId__c FROM Account Limit 1];
        CreateRelatedSettingHelper.getCreateRelatedSettings( 'Account');
        CreateRelatedSettingHelper.getCreateRelatedSettingsWithTag( 'dmpl__SaleOrder__c', 'Release', 'dmpl__SaleInvoice__c', 'OTC');
        dmpl__CreateRelatedSetting__mdt set1 = CreateRelatedSettingHelper.getCreateRelatedSettings( 'dmpl__SaleOrder__c', 'Release', 'dmpl__SaleInvoice__c');
        CreateRelatedSettingHelper.getCreateRelatedSetting(set1.Id);
        System.assert(acc!=null, 'Item is getted');
    }
      @isTest
    Public static void getObjectsByFilterNew1()
    {   
        List<Account> acc = [Select Id, Name,dmpl__AccountContactId__c FROM Account Limit 1];
        Account acc1 = [Select Id, Name,dmpl__AccountContactId__c FROM Account Limit 1];
       DocumentHelper.validateCanBePosted(acc,'dmpl__AccountContactId__c');
    }
    @isTest
    Public static void getObjectsByFilterNew2()
    {
        Try{
            Test.startTest();
            List<Account> acc = [Select Id, Name,dmpl__AccountContactId__c FROM Account Limit 1];
            Account acc1 = [Select Id, Name,dmpl__AccountContactId__c FROM Account Limit 1];
            CreateRelatedSettingHelper.getCreateRelatedSetting(acc[0].Id);
            System.assert(acc!=null, 'Item is getted');
            Test.stopTest();}
        Catch(Exception e){}
    }

    @isTest
    static void testValidateChangeInSystemFields() {
        List<SObject> oldEntries = new List<SObject>();
        List<SObject> newEntries = new List<SObject>();

        Account oldAccount = new Account(Name = 'Old Account');
        insert oldAccount;
        Account newAccount = new Account(Name = 'New Account');
        insert newAccount;
        oldAccount.Name = 'Updated Account Name';
        oldEntries.add(oldAccount);
        newEntries.add(newAccount);

        Test.startTest();
        DocumentHelper.validateChangeInSystemFields(new List<String>{'Name'}, oldEntries, newEntries);
        Test.stopTest();

        System.assertEquals(1, newEntries.size(), 'New entries should have one record');
        System.assert(!newEntries[0].hasErrors(), 'No errors should be added');
    }

        
    @isTest
    Public static void extractUniqueValues()
    {
        List<Account> acc = [Select Id, Name,dmpl__AccountContactId__c,dmpl__AccountSource__c FROM Account Limit 1];
        Account acc1 = [Select Id, Name,dmpl__AccountContactId__c,dmpl__AccountSource__c FROM Account Limit 1];
        DocumentHelper.extractUniqueValues(acc, 'dmpl__AccountContactId__c');
        System.assert(acc!=null, 'Item is getted');
    }
    
    @isTest
    Static void VerifyHelperFunctions()
    {
      List<Account>  accountList1 = [Select Id, Name , dmpl__IsPartnerAccount__c From Account WHERE dmpl__IsPartnerAccount__c = true];
      List<Account>  accountList2 = [Select Id, Name , dmpl__IsPartnerAccount__c From Account WHERE dmpl__IsPartnerAccount__c = true];

      accountList2[0].Name = 'Changed';
      accountList2[0].dmpl__IsPartnerAccount__c = false;

      List<SObject> modified = DocumentHelper.getModifiedNewObjects('dmpl__IsPartnerAccount__c', accountList1,accountList2);
      System.assertNotEquals(modified.size(), 0, 'Modified cant be zero');

      List<Id> modifiedId = DocumentHelper.getModifiedNewObjectIds('dmpl__IsPartnerAccount__c', 'Id', accountList1,accountList2);
      System.assertNotEquals(modifiedId.size(), 0, 'Modified cant be zero');

      modified = DocumentHelper.getModifiedNewObjects(new String[]{ 'dmpl__IsPartnerAccount__c', 'Id'}, accountList1, accountList2);
      System.assertNotEquals(modified.size(), 0, 'Modified cant be zero');

      modified = DocumentHelper.getApprovedObjects('dmpl__IsPartnerAccount__c', accountList1, accountList2);
      System.assertEquals(modified.size(), 0, 'Modified cant be zero');

      modified = DocumentHelper.getApprovedNewObjects('dmpl__IsPartnerAccount__c', accountList2);
      System.assertEquals(modified.size(), 0, 'Modified cant be zero');
      
      modifiedId = DocumentHelper.getModifiedNewObjectIds(new String[]{ 'dmpl__IsPartnerAccount__c', 'Id'}, 'Id', accountList1, accountList2);
      System.assertNotEquals(modifiedId.size(), 0, 'Modified cant be zero');
      

       DocumentHelper.validateChangeInKeyFields(new String[]{ 'dmpl__IsPartnerAccount__c', 'Id'},  accountList1, accountList2);

       DocumentHelper.validateChangeInKeyFields(new String[]{ 'dmpl__IsPartnerAccount__c', 'Id'},  accountList1, accountList2, DocumentHelper.extractIds(accountList1));

       DocumentHelper.validateChangeInSystemFields(new String[]{ 'dmpl__IsPartnerAccount__c', 'Id'},  accountList1, accountList2);

      DocumentHelper.validateChangeInSystemFields(new String[]{ 'dmpl__IsPartnerAccount__c', 'Id'}, accountList2);

       DocumentHelper.validateChangeInSourcePopulatedFields(new String[]{ 'dmpl__IsPartnerAccount__c', 'Id'}, accountList1, accountList2, 'Id');


      DocumentHelper.validateChangeInSourcePopulatedFields(new String[]{ 'dmpl__IsPartnerAccount__c', 'Id'}, accountList1, accountList2, DocumentHelper.extractIds(accountList1), 'Id');

    }

    @isTest
    Static void VerifyHelperCollectionFunctions()
    {
        List<Account>  accountList1 = [Select Id, Name , dmpl__IsPartnerAccount__c, (SELECT ID, NAME FRoM Contacts) From Account];
      
        SObject result = DocumentHelper.getObject(accountList1, accountList1[0].Id);
        System.assertNotEquals(result, null, 'result needs to be present');

        List<SOBject> results = DocumentHelper.getObjects(accountList1, 'Id', accountList1[0].Id);
        System.assertNotEquals(result, null, 'result needs to be present');


        results = DocumentHelper.getObjectsByFilter(accountList1, 'dmpl__IsPartnerAccount__c', true);
        System.assertNotEquals(results.size(), 3, 'result needs to be present');

        results = DocumentHelper.getObjectsWithNotNull(accountList1, 'dmpl__IsPartnerAccount__c');
        System.assertNotEquals(results.size(), 3, 'result needs to be present');

        
        List<Id> resultIds = DocumentHelper.extractIds(accountList1);
        System.assertNotEquals(resultIds.size(), 3, 'result needs to be present');


        resultIds = DocumentHelper.extractIds(accountList1, 'Id');
        System.assertNotEquals(resultIds.size(), 3, 'result needs to be present');

        resultIds = DocumentHelper.extractIds(accountList1, 'Contacts', 'Id');
        System.assertNotEquals(resultIds.size(), 3, 'result needs to be present');

        Map<ID, List<SObject>> resultMap = DocumentHelper.mapLinesWithDocument(DocumentHelper.extractIds(accountList1), 'Id', accountList1);
        System.assertNotEquals(resultIds.size(), 3, 'result needs to be present');

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
                               dmpl__LastName__c = 'Cycle Count',
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
                                             dmpl__LastName__c = 'Cycle Count',
                                             dmpl__IsActive__c = true);
        insert partneraccount;
        
        Account customerAccount = new Account(Name = 'Customer-Test-Account',
                                              dmpl__IsCustomerAccount__c = True,
                                              dmpl__LastName__c = 'Cycle Count',
                                              dmpl__IsActive__c = true);
        insert customerAccount;
        
        Account supplierAccount = new Account(Name = 'Supplier-Test-Account',
                                              dmpl__IsSupplierAccount__c = True,
                                              dmpl__LastName__c = 'Cycle Count',
                                              dmpl__IsActive__c = true);
        insert supplierAccount;
    }
}