@isTest
public class SchemeCloneHelper_Test {
    
    @testSetup
    public static void Setup()
    {
        test.startTest();
        CreateAccountGroup();
        CreateBranch();
        CreateItemGroup(); 
        CreateSKu();
        CreateScheme();
        CreateSchemeLine();
        CreateSchemeCondition();
        CreateSchemeBenefits();
        test.stopTest();
    }
    
    @isTest
    private static void verifySchemeController()
    {
        Test.startTest();
        try{
        List<Id> Ids = new List<Id>();
        	SchemeController.getROSchemeLedgerEntries(Ids[0]);
        }catch(exception ex){}
        Test.stopTest();
    }
    
    @isTest
    private static void verifySchemeBenefits()
    {
        Test.startTest();
        try{
        List<dmpl__SchemeBenefit__c> schemeBenefits = [SELECT Id,Name,dmpl__DiscountedItemQuantity__c FROM dmpl__SchemeBenefit__c LIMIT 1];
            schemeBenefits[0].dmpl__DiscountedItemQuantity__c = 25;
            update schemeBenefits; 
        }catch(exception ex){}
        Test.stopTest();
    }
    
    @isTest
    Static void VerifyCreateAccount()
    {
        List<Account>  account = [Select Id, Name From Account];
        System.assertNotEquals(null, account, 'Test Accounts are not found');
        System.assertEquals(4, account.size(), 'Test Accounts have more than 1 record');
        
    }
 
    
    @isTest
    public static void VerifyScheme()
    {
        test.startTest();
        
        dmpl__Scheme__c scheme = [SELECT Id, 
                                  Name,
                                  dmpl__PerformCloneScheme__c,
                                  dmpl__BranchId__c,
                                  dmpl__BusinessHoursId__c,
                                  dmpl__IsClaimable__c,
                                  dmpl__ClaimablePercentage__c,
                                  dmpl__MultipleFulfilmentTreatment__c,
                                  dmpl__OriginalSchemeId__c,
                                  dmpl__PartnerAccountId__c,
                                  dmpl__PartnerAccountGroupId__c, 
                                  dmpl__PeriodType__c,
                                  dmpl__SchemeQuota__c,
                                  dmpl__SchemeType__c,
                                  dmpl__Status__c,
                                  dmpl__SupplierAccountId__c,
                                  dmpl__ValidFrom__c,
                                  dmpl__ValidTo__c 
                                  FROM dmpl__Scheme__c];
        SchemeCloneHelper.CloneScheme(scheme);   
        System.assertNotEquals(null, scheme);
        test.stopTest();
    }
    
    @isTest
    public static void updateScheme()
    {
        test.startTest();
        
        dmpl__Scheme__c scheme = [SELECT Id, 
                                  Name,
                                  dmpl__PerformCloneScheme__c 
                                  FROM dmpl__Scheme__c LIMIT 1];
        if(scheme != null)
        	scheme.dmpl__PerformCloneScheme__c = true;
        //CreateScheme();
        update scheme; 
        System.assert(scheme != null, scheme);
        test.stopTest();
    }
    
    @isTest
    public static void VerifySchemeLine()
    {
        test.startTest();
        List<dmpl__Scheme__c> scheme = [Select Id,Name,dmpl__PerformCloneScheme__c From dmpl__Scheme__c LIMIT 1];
        list<dmpl__SchemeLine__c> schemeLine = [SELECT Id, 
                                                Name,
                                                dmpl__DefinitionFilterCriteria__c,
                                                dmpl__DefinitionCustomLogic__c,
                                                dmpl__RewardApplicability__c,
                                                dmpl__RewardAccountGroup__c,
                                                dmpl__RewardCustomLogic__c,
                                                dmpl__SchemeId__c,
                                                dmpl__SequenceNumber__c,
                                                dmpl__ParentSchemeLine__c
                                                FROM dmpl__SchemeLine__c Limit 1];
        SchemeCloneHelper.CloneSchemeLine(schemeLine,schemeLine[0].id);   
        SchemeCloneHelper.deepClone(scheme);
        SchemeCloneHelper.deepCloneCheck(scheme);
        System.assertNotEquals(null, schemeLine);
        test.stopTest();
    }
    
    @isTest
    public static void VerifySchemeCondition()
    {
        test.startTest();
        
        list<dmpl__SchemeCondition__c> schemeCondition = [SELECT Id,
                                                          Name,
                                                          dmpl__AccountId__c,
                                                          dmpl__AccountGroupId__c,
                                                          dmpl__ConditionOperator__c,
                                                          dmpl__ConditionQuantity__c,
                                                          dmpl__ConditionType__c,
                                                          dmpl__ConditionValue__c,
                                                          dmpl__ItemGroupId__c,
                                                          dmpl__PartnerAccountId__c,
                                                          dmpl__RewardGroup__c,
                                                          dmpl__SchemeId__c,
                                                          dmpl__ItemId__c,
                                                          dmpl__SchemeLineId__c,
                                                          dmpl__SequenceNumber__c,
                                                          dmpl__ItemSKUId__c
                                                          FROM dmpl__SchemeCondition__c Limit 1];
        SchemeCloneHelper.CloneSchemeCondition(schemeCondition,schemeCondition[0].id);   
        System.assertNotEquals(null, schemeCondition);
        test.stopTest();
    }
    
    @isTest
    public static void VerifySchemeBenefit()
    {
        test.startTest();
        
        list<dmpl__SchemeBenefit__c> schemeBenefit = [SELECT Id,
                                                      Name,
                                                      dmpl__DiscountAmount__c,
                                                      dmpl__DiscountPercent__c,
                                                      dmpl__DiscountedItemId__c,
                                                      dmpl__DiscountedItemGroupId__c,
                                                      dmpl__DiscountedItemQuantity__c,
                                                      dmpl__DiscountedItemRanking__c,
                                                      dmpl__DiscountedItemSKUId__c,
                                                      dmpl__ExcludeQualifyingItems__c,
                                                      dmpl__RepeatReward__c,
                                                      dmpl__RewardPoints__c,
                                                      dmpl__RewardType__c,
                                                      dmpl__SchemeId__c,
                                                      dmpl__SchemeLineId__c,
                                                      dmpl__RecommendationText__c,
                                                      dmpl__SequenceNumber__c
                                                      FROM dmpl__SchemeBenefit__c Limit 1];
        SchemeCloneHelper.CloneSchemeBenefit(schemeBenefit,schemeBenefit[0].id);   
        System.assertNotEquals(null, schemeBenefit);
        test.stopTest();
    }
    
    
    private static void CreateAccountGroup()
    {
        dmpl__AccountGroup__c accountGroup= new dmpl__AccountGroup__c (Name= 'Test-AccountGroup', 
                                                                       dmpl__AccountGroupType__c='Scheme');
        insert accountGroup;
        
        List<Account> account = new List<Account>();
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
                                              dmpl__IsPartnerAccount__c = True,
                                              dmpl__IsActive__c = true);
        insert customerAccount;
        
        Account supplierAccount = new Account(Name = 'Supplier-Test-Account',
                                              dmpl__LastName__c = 'Sale Order',
                                              dmpl__IsSupplierAccount__c = True,
                                              dmpl__IsActive__c = true);
        insert supplierAccount;
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
        
        Account partnerAccount1 = [Select Id,Name From Account WHERE Name = 'Customer-Test-Account' LIMIT 1];
        branch.Add(new dmpl__Branch__c(dmpl__PartnerAccountId__c =partnerAccount.Id,
                                       Name = 'Test-Branch1',
                                       dmpl__IsActive__c = true,
                                       dmpl__MarketingName__c = 'Hero Electric',
                                       dmpl__Website__c = 'www.dealermatix.com',
                                       dmpl__Email__c = 'Dealer@Outlook.com',
                                       dmpl__MobileNumber__c = 99,
                                       dmpl__Phone__c = '1888888888',
                                       dmpl__AllowSales__c = true,
                                       dmpl__AllowService__c = true,
                                       dmpl__AllowPurchase__c = true,
                                       dmpl__AllowInventory__c = true,
                                       dmpl__IsHomeDeliveryAvailable__c = true,
                                       dmpl__IsPickupDropAvailable__c = true,
                                       dmpl__SalesPhone__c = '7177777777',
                                       dmpl__ServiceEmail__c = 'Customer1@Outlook.com'));
        insert branch;
    }
    
    private static void CreateItemGroup()
    {
        List<dmpl__ItemGroup__c> itemGroup = new List<dmpl__ItemGroup__c> ();
        itemGroup.Add(new dmpl__ItemGroup__c(Name = 'Item Group Test',
                                             dmpl__ItemGroupType__c = 'Scheme'
                                            ));
        insert itemGroup;
        
        List<dmpl__Item__c> productItem = new List<dmpl__Item__c>();
        productItem.Add(new dmpl__Item__c(Name = 'Test-Item',
                                          dmpl__ItemCode__c = 'DMPL',
                                          dmpl__ItemType__c = 'Product',
                                          dmpl__ItemSubType__c = '',
                                          dmpl__SchemeItemGroupId__c=itemGroup[0].Id,
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
                                          dmpl__RFID__c = 'O1234fgh',
                                          dmpl__IsPackage__c = true
                                         ));
        insert productItem;
        
        List<dmpl__Item__c> chargeItem = new List<dmpl__Item__c>();
        chargeItem.Add(new dmpl__Item__c(Name = 'Test-Item',
                                         dmpl__ItemCode__c = 'DMPL',
                                         dmpl__ItemType__c = 'Charge Item',
                                         dmpl__ItemSubType__c = '',
                                         dmpl__Description__c = '',
                                         dmpl__ItemFamily__c = 'Sample',
                                         dmpl__ItemSegment__c = 'Sample',
                                         dmpl__Make__c = 'Sample',
                                         dmpl__Model__c = 'Sample',                       
                                         dmpl__IsActive__c = true,
                                         dmpl__OnlySoldInPackage__c=True
                                        ));
        insert chargeItem;
        
        List<dmpl__Item__c> subsItem = new List<dmpl__Item__c>();
        subsItem.Add(new dmpl__Item__c(Name = 'Test-Item',
                                       dmpl__ItemCode__c = 'DMPL',
                                       dmpl__ItemType__c = 'Subscription',
                                       dmpl__ItemSubType__c = '',
                                       dmpl__Description__c = '',
                                       dmpl__ItemFamily__c = 'Sample',
                                       dmpl__ItemSegment__c = 'Sample',
                                       dmpl__Make__c = 'Sample',
                                       dmpl__Model__c = 'Sample',                       
                                       dmpl__IsPackage__c = true
                                      ));
        insert subsItem;
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
        
        List<dmpl__Resource__c> resource = new List<dmpl__Resource__c>();
        Account partnerAccount = [Select Id,Name From Account LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name From dmpl__Branch__c LIMIT 1];
        resource.add(new dmpl__Resource__c(Name = 'Test - Resource',
                                           dmpl__ResourceType__c = 'Technician',
                                           dmpl__IsActive__c = true,
                                           dmpl__Phone__c = '9999999999',
                                           dmpl__DefaultPartnerAccountId__c = partnerAccount.Id,
                                           dmpl__DefaultBranchId__c = branch.Id
                                          ));
        insert resource;
        
        List<dmpl__TaxGroup__c> taxGroup = new List<dmpl__TaxGroup__c>();
        Account account=[Select Id,Name from Account Where Name='Partner-Test-Account'];
        dmpl__AccountGroup__c AccountGrp = [Select Id, Name FROM dmpl__AccountGroup__c LIMIT 1];
        taxGroup.Add(new dmpl__TaxGroup__c(Name = 'Test - Tax Group',
                                           dmpl__PartnerAccountId__c = account.Id,
                                           dmpl__BranchId__c = branch.Id,
                                           dmpl__PartnerAccountGroupId__c = AccountGrp.Id,
                                           dmpl__Description__c = 'Test-Description',
                                           dmpl__IsActive__c = true));
        insert taxGroup;
    }
    
    private static void CreateScheme()
    {
        List<dmpl__Scheme__c> scheme = new List<dmpl__Scheme__c>();
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c Where Name = 'Test-Branch'];
        Account customerAccount = [Select Id,Name From Account WHERE dmpl__IsCustomerAccount__c = True LIMIT 1];
        dmpl__AccountGroup__c accountGroup = [Select Id,Name From dmpl__AccountGroup__c LIMIT 1];
        scheme.Add(new dmpl__Scheme__c(Name='Scheme1',
                                       dmpl__ValidTo__c= Datetime.now().addDays(365).Date(),
                                       dmpl__Status__c='Approved',
                                       dmpl__MultipleFulfilmentTreatment__c='Apply All Fulfilled',
                                       dmpl__SchemeType__c='Per Period Sale Order',
                                       dmpl__BranchId__c = branch.Id,
                                       dmpl__ValidFrom__c = date.today()-(2),
                                       dmpl__PartnerAccountId__c = null,
                                       dmpl__PeriodType__c = 'Yearly',
                                       dmpl__PerformCloneScheme__c= False,
                                       dmpl__OriginalSchemeId__c = '',
                                       dmpl__PartnerAccountGroupId__c = null));
        insert scheme;
    }
    private static void CreateSchemeLine()
    {
        
        List<dmpl__SchemeLine__c> schemeLine = new List<dmpl__SchemeLine__c>();
        dmpl__Scheme__c scheme =[Select Id, Name from dmpl__Scheme__c Limit 1];
        dmpl__AccountGroup__c accountGroup = [Select Id,Name From dmpl__AccountGroup__c LIMIT 1];
        schemeLine.Add(new dmpl__SchemeLine__c(dmpl__DefinitionFilterCriteria__c = 'All Conditions Are Met',
                                               dmpl__SchemeId__c = scheme.Id,
                                               dmpl__SequenceNumber__c = 1,
                                               dmpl__DefinitionCustomLogic__c = 'Logic',
                                               dmpl__RewardAccountGroup__c = accountGroup.id,
                                               dmpl__RewardCustomLogic__c = 'Custom',
                                               //dmpl__ParentSchemeLine__c = 'a2G1y000000OH2mEAG',
                                               dmpl__RewardApplicability__c = 'All Rewards'));
        insert schemeLine;
    }
    
    private static void CreateSchemeCondition()
    {
        List<dmpl__SchemeCondition__c> schemeCondition = new List<dmpl__SchemeCondition__c>();
        dmpl__Scheme__c scheme =[Select Id, Name from dmpl__Scheme__c Limit 1];
        dmpl__SchemeLine__c schemeLine =[Select Id, Name from dmpl__SchemeLine__c WHERE dmpl__DefinitionFilterCriteria__c = 'All Conditions Are Met'  Limit 1];
        Account customerAccount = [Select Id,Name From Account WHERE dmpl__IsCustomerAccount__c = True LIMIT 1];
        Account partneraccount = [Select Id,Name From Account WHERE dmpl__IsPartneraccount__c = True LIMIT 1];
        dmpl__AccountGroup__c accountGroup = [Select Id,Name From dmpl__AccountGroup__c LIMIT 1];
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c where dmpl__ItemType__c='Product'  LIMIT 1];
        dmpl__ItemGroup__c itemGroup =[Select Id, Name from dmpl__ItemGroup__c Limit 1];
        dmpl__SKU__c sku = [Select Id,Name From dmpl__SKU__c LIMIT 1];
        schemeCondition.Add(new dmpl__SchemeCondition__c(dmpl__AccountId__c =customerAccount.Id,
                                                         dmpl__SchemeId__c = scheme.Id,
                                                         dmpl__ItemId__c=item.Id,
                                                         dmpl__ItemGroupId__c=itemGroup.Id,         
                                                         dmpl__AccountGroupId__c =accountGroup.Id,
                                                         dmpl__ItemSKUId__c=sku.Id,         
                                                         dmpl__ConditionType__c='Quantity',
                                                         dmpl__ConditionQuantity__c =5,
                                                         dmpl__ConditionValue__c = 100,
                                                         dmpl__SequenceNumber__c = 1,
                                                         dmpl__SchemeLineId__c=schemeLine.Id,
                                                         dmpl__RewardGroup__c = 'Reward',
                                                         dmpl__PartnerAccountId__c = partneraccount.Id, 
                                                         dmpl__ConditionOperator__c = 'Greater Than'));
        insert schemeCondition;
    }
    
    private static void CreateSchemeBenefits()
    {
        List<dmpl__SchemeBenefit__c> schemeBenefit = new List<dmpl__SchemeBenefit__c>();
        dmpl__Scheme__c scheme =[Select Id, Name from dmpl__Scheme__c Limit 1];
        dmpl__SchemeLine__c schemeLine =[Select Id, Name from dmpl__SchemeLine__c WHERE dmpl__RewardApplicability__c = 'All Rewards' Limit 1];
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c where dmpl__ItemType__c='Product'  LIMIT 1];
        dmpl__ItemGroup__c itemGroup =[Select Id, Name from dmpl__ItemGroup__c Limit 1];
        dmpl__SKU__c sku = [Select Id,Name From dmpl__SKU__c LIMIT 1];
        Account customerAccount = [Select Id,Name From Account WHERE dmpl__IsCustomerAccount__c = True LIMIT 1];
        schemeBenefit.Add(new dmpl__SchemeBenefit__c(dmpl__SchemeId__c = scheme.Id,
                                                     dmpl__RewardType__c='Line Level Discount Amount',
                                                     dmpl__SequenceNumber__c = 1,
                                                     dmpl__DiscountAmount__c = 100,
                                                     dmpl__DiscountPercent__c = 6,
                                                     dmpl__DiscountedItemId__c = item.id,
                                                     dmpl__DiscountedItemGroupId__c = itemGroup.id,
                                                     dmpl__DiscountedItemQuantity__c = 9,
                                                     dmpl__DiscountedItemRanking__c = 'High To Low',
                                                     dmpl__DiscountedItemSKUId__c = sku.Id,
                                                     dmpl__ExcludeQualifyingItems__c = True,
                                                     dmpl__RepeatReward__c= True,
                                                     dmpl__RewardPoints__c = 100,
                                                     dmpl__SchemeLineId__c = schemeLine.Id,
                                                     dmpl__RecommendationText__c = 'Test'   
                                                    ));
        insert schemeBenefit;
    }
    
}