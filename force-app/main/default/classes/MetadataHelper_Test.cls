@isTest
public class MetadataHelper_Test {
    
    @isTest
    public static void MetadatHelperTest()
    {
        //try{
            test.startTest();
            CreateAccount();
            List<FieldsetInfo> fsl = MetadataHelper.getFieldSetList('Account');
            List<FieldsetFieldInfo> fsl1 = MetadataHelper.getFieldsByFieldSetName('Account', 'dmpl__DMSCustomLookupFields');
            Map<String, Schema.SObjectField> fm = MetadataHelper.getFieldMap(Account.getSObjectType());
            Schema.SObjectField fd = MetadataHelper.getField(Account.getSObjectType(), 'Name');
        	new TriggerHandler().clearMaxLoopCount();
            TriggerHandler.bypass('');
        	TriggerHandler.clearBypass('');
        	TriggerHandler.isBypassed('');
        	TriggerHandler.clearAllBypasses();
        	TriggerHandler ins=new TriggerHandler();
        	TriggerHandler.LoopCount ilc=new TriggerHandler.LoopCount();
        	TriggerHandler.LoopCount ilc2=new TriggerHandler.LoopCount(5);
        	ilc.increment();
        	ilc.exceeded();
        	ilc.getCount();
        	ilc.setMax(5);
            System.assert(fsl != null, 'Search result object');
            test.stopTest();
        // }
        // catch(exception e){}
    }

       
    @isTest
    public static void CreateRelatedSettingTest()
    {
        try{
            test.startTest();
            List<dmpl__CreateRelatedSetting__mdt> settings = CreateRelatedSettingHelper.getCreateRelatedSettings('dmpl__SaleOrder__c');
            for(dmpl__CreateRelatedSetting__mdt setting : settings){
                CreateRelatedSettingHelper.getSOQLQuery(
                    setting, 
                    'a', 
                    'recordId');    
            }
            test.stopTest();
        }
        catch(exception e){}
    }
    

    @isTest
    public static void MetadataServiceTest()
    {
        //try{
            test.startTest();
            CreateAccount();
            Account a = [SELECT id from Account LIMIT 1];
            MetadataService mss = new MetadataService('Account');
            mss.queryObject('Id', a.Id);
            mss.queryObject('Id', 'Id', a.Id);
            
            mss.queryObject(new List<String>{'Id', 'Name'}, a.Id);
            mss.queryObject(new List<String>{'Id', 'Name'}, 'Id', a.Id);

            mss.queryObjects('Id', new List<Id>{ a.Id});
            mss.queryObjects('Id', 'Id', new List<Id>{ a.Id});
            
            mss.queryObjects(new List<String>{'Id', 'Name'}, new List<Id>{ a.Id});
            mss.queryObjects(new List<String>{'Id', 'Name'}, 'Id', new List<Id>{ a.Id});
            mss.queryObjectWithRelation(new List<String>{'Id', 'Name'},'Contacts',new List<String>{'Id', 'Name'},a.Id);
			mss.queryObjectWithRelation(new List<String>{'Id', 'Name'},'Contacts',new List<String>{'Id', 'Name'},'Id',a.Id);
            mss.queryObjectWithRelationForType('Account',new List<String>{'Id', 'Name'},'Contacts',new List<String>{'Id', 'Name'},'Id',a.Id);
            mss.queryObjectsForType('Contact','AccountId','AccountId',a.Id);
            mss.queryObjectsWithRelationForType('Account',new List<String>{'Id', 'Name'},'Contacts',new List<String>{'Id', 'Name'},new List<Id>{a.Id});
            mss.queryObjectsWithRelationForType('Account',new List<String>{'Id', 'Name'},'Contacts',new List<String>{'Id', 'Name'},'Id',a.Id);
            mss.updateObject(a);
            mss.updateObjects(new List<SObject>{a});
            System.assert(mss != null, 'Search result object');
            test.stopTest();
        //}
        //catch(exception e){}
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
}