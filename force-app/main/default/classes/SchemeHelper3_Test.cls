@isTest
public class SchemeHelper3_Test {

    @testSetup
    public static void Setup()
    {
        test.startTest(); 
        CreateAccountGroup();
        CreateBranch();
        CreateItemGroup(); 
        CreateSKu();
        CreatePriceList();
        //CreateTaxGroup();
        CreateScheme1();
        CreateSchemeCondition();
        CreateSchemeBenefits();
        CreateBill();
        test.stopTest();
    }
    
    @isTest
    private static void VerifyProcessMethod()
    {
        test.startTest();
        List<dmpl__Bill__c> bills = [SELECT Id,Name,dmpl__SkipScheme__c,dmpl__PartnerAccountId__c,dmpl__DocumentDate__c,dmpl__SupplierAccountId__c,dmpl__TransactionType__c FROM dmpl__Bill__c limit 1];
        SchemeEngine.processSchemes(bills);
        SchemeEngine.getQualifiedSchemeLines(bills[0]);
        System.assert(bills != null, 'Sale Orders data found');
        test.stopTest();
    }
    
    @isTest
    private static void VerifyProcessMethodForPerPeriodSO()
    {
        test.startTest();
        CreateScheme2();
        List<dmpl__Bill__c> bills = [SELECT Id,dmpl__SkipScheme__c,Name,dmpl__PartnerAccountId__c,dmpl__DocumentDate__c,dmpl__SupplierAccountId__c,dmpl__TransactionType__c FROM dmpl__Bill__c];
        SchemeEngine.processSchemes(bills);
        System.assert(bills != null, 'Sale Orders data found');
        test.stopTest();
    }
    
    @isTest
    private static void VerifyGetMinBenefit()
    {
     dmpl__SchemeLine__c schemeLine =[Select Id, Name,(Select id,Name,dmpl__RewardPoints__c,dmpl__RewardType__c,DiscountAmount__c from dmpl__SchemeBenefits__r) from dmpl__SchemeLine__c WHERE dmpl__RewardApplicability__c = 'All Rewards'  Limit 1];
     test.startTest();
      SchemeEngine.getMinimumBenefit(schemeLine);
      SchemeEngine.getMaximumBenefit(schemeLine);
     test.stopTest();
    }
    
    @isTest
    private static void VerifyProcessMethodForPerPO()
    {
        test.startTest();
        CreateScheme3();
        List<dmpl__PurchaseOrder__c> po = CreatePurchaseOrder();
        SchemeEngine.processSchemes(po);
        System.assert(po != null, 'Sale Orders data found');
        test.stopTest();
    }
    
    @isTest
    private static void VerifyProcessMethodForPerPeriodPO()
    {
        test.startTest();
        CreateScheme5();
        List<dmpl__PurchaseOrder__c> po = CreatePurchaseOrder();
        SchemeEngine.processSchemes(po);
        System.assert(po != null, 'Sale Orders data found');
        test.stopTest();
    }
    
    @isTest
    private static void VerifyProcessMethodForPerRO()
    {
        test.startTest();
        try{
        CreateScheme6();
        List<dmpl__RepairOrder__c> ro = new List<dmpl__RepairOrder__c>{new dmpl__RepairOrder__c(dmpl__AccountId__c = '',dmpl__DocumentDate__c =date.today())};
        SchemeEngine.processSchemes(ro);
        System.assert(ro != null, 'Sale Orders data found');
        }catch(Exception e){}
        test.stopTest();
    }
    
    @isTest
   private static void VerifyApplySchemeBenefitMethod()
        {
            Test.startTest();
            try {
                List<dmpl__Bill__c> bills = [
                    SELECT Id, Name, dmpl__PartnerAccountId__c, dmpl__SkipScheme__c,
                           dmpl__DocumentDate__c, dmpl__SupplierAccountId__c, dmpl__TransactionType__c
                    FROM dmpl__Bill__c
                ];
                
                List<dmpl__SchemeBenefit__c> schemeBenefits = [
                    SELECT Id, Name FROM dmpl__SchemeBenefit__c
                ];
                
                List<dmpl__SchemeLine__c> schemeLines = [
                    SELECT Id, Name FROM dmpl__SchemeLine__c
                    WHERE dmpl__RewardApplicability__c = 'All Rewards'
                    LIMIT 1
                ];
                
                if (bills.isEmpty() || schemeBenefits.isEmpty() || schemeLines.isEmpty()) {
                    System.debug('Required data not found.');
                   
                } else {
                    SchemeEngine.applySchemeBenefit(
                        bills[0],
                        schemeLines[0].Id,
                        schemeBenefits[0].Id,
                        0,
                        new List<SourceObjectInfo>()
                    );
                }
            } catch (Exception e) {
                System.debug('Error during applySchemeBenefit: ' + e.getMessage());
               
            }
            Test.stopTest();
        }

    
    @isTest
    private static void VerifyApplySchemeBenefitMethod1()
    {
        test.startTest();
        List<dmpl__Bill__c> bills = [SELECT Id,Name,dmpl__SkipScheme__c,dmpl__PartnerAccountId__c,dmpl__DocumentDate__c,dmpl__SupplierAccountId__c,dmpl__TransactionType__c FROM dmpl__Bill__c limit 1];
        List<dmpl__SchemeBenefit__c> schemeBenefits = [SELECT Id,Name FROM dmpl__SchemeBenefit__c];
    dmpl__SchemeLine__c schemeLine =[Select Id, Name from dmpl__SchemeLine__c WHERE dmpl__RewardApplicability__c != 'All Rewards'  Limit 1];
        SchemeEngine.applySchemeBenefit(
            bills[0],
            schemeLine.Id,
            schemeBenefits[0].Id,
            0,
            new List<SourceObjectInfo>{});
        test.stopTest();
    }
    
    @isTest
    private static void VerifySchemeController()
    {
        List<dmpl__ItemGroup__c> itemGroup = [SELECT Id,Name FROM dmpl__ItemGroup__c];
        SchemeController.getQualifiedBenefits(itemGroup[0].Id,'',DocumentHelper.extractIds(itemGroup,'Id'));
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
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c LIMIT 1];
        sku.add(new dmpl__SKU__c(Name = 'Test - SKU',
                                 dmpl__SKUCode__c = 'Test - SKU - Code',
                                 dmpl__UnitOfMeasureOfConversion__c = 10,
                                 dmpl__ProductColor__c = 'Sample',
                                 dmpl__IsDefault__c = false,
                                 dmpl__QuantityUnitOfMeasure__c ='Sample',
                                 dmpl__ItemId__c = item.Id));
        insert sku;
    
        /*List<dmpl__Resource__c> resource = new List<dmpl__Resource__c>();
        Account partnerAccount = [Select Id,Name From Account LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c LIMIT 1];
        resource.add(new dmpl__Resource__c(Name = 'Test - Resource',
                                           dmpl__ResourceType__c = 'Technician',
                                           dmpl__IsActive__c = true,
                                           dmpl__Phone__c = '9999999999',
                                           dmpl__DefaultPartnerAccountId__c = partnerAccount.Id,
                                           dmpl__DefaultBranchId__c = branch.Id
                                          ));
        insert resource;*/
    
        List<dmpl__TaxGroup__c> taxGroup = new List<dmpl__TaxGroup__c>();
        Account account=[Select Id,Name from Account Where Name='Partner-Test-Account'];
        //dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c Limit 1];
        dmpl__AccountGroup__c AccountGrp = [Select Id, Name FROM dmpl__AccountGroup__c LIMIT 1];
        taxGroup.Add(new dmpl__TaxGroup__c(Name = 'Test - Tax Group',
                                           dmpl__PartnerAccountId__c = account.Id,
                                           dmpl__BranchId__c = branch.Id,
                                           dmpl__PartnerAccountGroupId__c = AccountGrp.Id,
                                           dmpl__Description__c = 'Test-Description',
                                           dmpl__IsActive__c = true));
        insert taxGroup;
        
        List<dmpl__ItemLot__c> itemLot = new List<dmpl__ItemLot__c>();

        itemLot.Add(new dmpl__ItemLot__c(dmpl__BranchId__c = branch.Id,
                                         dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                         dmpl__ItemId__c = item.Id,
                                         dmpl__SKUId__c =sku[0].Id,
                                         dmpl__BatchNo__c = 'AAA',
                                         dmpl__SerialNumber__c='BBB',
                                         dmpl__SupplierInvoiceNumber__c='CCC',
                                         dmpl__DateOfReceipt__c= date.today(),
                                         dmpl__DateOfMfg__c=date.today(),
                                         dmpl__TotalCost__c=10.2,
                                         dmpl__DateOfSupplierInvoice__c=date.today(),
                                         dmpl__Cost__c=38
                                        ));
        insert itemLot;       
   
    }
    
    private static void CreatePriceList()
    {
        List<dmpl__PriceList__c> priceList =new List<dmpl__PriceList__c>();
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c Limit 1];
        Account account=[Select Id,Name from Account Where Name='Partner-Test-Account'];
        
        priceList.Add(new dmpl__PriceList__c(Name='Test-Price - List',
                                             dmpl__BranchId__c = branch.Id,
                                             dmpl__PriceListType__c = 'Sale Price',
                                             dmpl__PartnerAccountId__c= account.Id,
                                             dmpl__IsActive__c = true));
        insert priceList;
    
        List<dmpl__PriceListRules__c> priceListRules =new List<dmpl__PriceListRules__c>();
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        priceListRules.Add(new dmpl__PriceListRules__c(dmpl__ItemId__c = item.Id,
                                                       dmpl__PriceListId__c=priceList[0].Id,
                                                       dmpl__Price__c=500,
                                                       dmpl__DateEffectiveFrom__c = date.today()
                                                      ));
        insert priceListRules;
        
    }
    
    private static void CreateScheme()
    {
        List<dmpl__Scheme__c> scheme = new List<dmpl__Scheme__c>();
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c Where Name = 'Test-Branch'];
        Account customerAccount = [Select Id,Name From Account WHERE dmpl__IsCustomerAccount__c = True LIMIT 1];
        dmpl__AccountGroup__c accountGroup = [Select Id,Name From dmpl__AccountGroup__c LIMIT 1];
        scheme.Add(new dmpl__Scheme__c(dmpl__PeriodType__c = 'Per Order',
                                       Name='Scheme1',
                                       dmpl__ValidTo__c= Datetime.now().addDays(365).Date(),
                                       dmpl__Status__c='Approved',
                                       dmpl__MultipleFulfilmentTreatment__c='Apply Last Fulfilled',
                                       dmpl__SchemeType__c='Per Repair Order',
                                       dmpl__BranchId__c = branch.Id,
                                       dmpl__ValidFrom__c = date.today()-(2),
                                       dmpl__PartnerAccountId__c = null,
                                       dmpl__PartnerAccountGroupId__c = null));
        insert scheme;

        List<dmpl__Scheme__c> scheme1 = new List<dmpl__Scheme__c>();
        scheme1.Add(new dmpl__Scheme__c(dmpl__PeriodType__c = 'Quarterly',
                                        Name='Scheme2',
                                        dmpl__ValidTo__c= Datetime.now().addDays(365).Date(),
                                        dmpl__Status__c='Approved',
                                        dmpl__MultipleFulfilmentTreatment__c='Apply First Fulfilled',
                                        dmpl__SchemeType__c='Per Repair Order And Invoice',
                                        dmpl__BranchId__c = branch.Id,
                                        dmpl__ValidFrom__c = date.today()-(2),
                                        dmpl__PartnerAccountId__c = null,
                                        dmpl__PartnerAccountGroupId__c = null));
        insert scheme1;
    
        List<dmpl__SchemeLine__c> schemeLine = new List<dmpl__SchemeLine__c>();
        //dmpl__Scheme__c scheme =[Select Id, Name,dmpl__SchemeType__c,dmpl__MultipleFulfilmentTreatment__c,dmpl__PeriodType__c from dmpl__Scheme__c 
          //                       where  dmpl__SchemeType__c='Per Sale Order'
            //                     Limit 1];
        schemeLine.Add(new dmpl__SchemeLine__c(dmpl__DefinitionFilterCriteria__c = 'All Conditions Are Met',
                                               dmpl__SchemeId__c = scheme1[0].Id,
                                               dmpl__SequenceNumber__c = 1,
                                               dmpl__RewardApplicability__c = 'All Rewards'));
        insert schemeLine;
        
        List<dmpl__SchemeLine__c> schemeLine1 = new List<dmpl__SchemeLine__c>();
        dmpl__Scheme__c scheme2 =[Select Id, Name,dmpl__SchemeType__c,dmpl__MultipleFulfilmentTreatment__c,dmpl__PeriodType__c from dmpl__Scheme__c where  dmpl__SchemeType__c='Sales Order Per Period' Limit 1];
        schemeLine1.Add(new dmpl__SchemeLine__c(dmpl__DefinitionFilterCriteria__c = 'Always (No Criteria)',
                                                dmpl__SchemeId__c = scheme2.Id,
                                                dmpl__SequenceNumber__c = 2,
                                                dmpl__RewardApplicability__c = 'Any One With Lowest Value'));
        insert schemeLine1;
    }
    
    private static void CreateScheme1()
    {
        List<dmpl__Scheme__c> scheme1 = new List<dmpl__Scheme__c>();
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c Where Name = 'Test-Branch'];
        Account partnerAccount = [Select Id,Name From Account WHERE Name = 'Partner-Test-Account' LIMIT 1];
        scheme1.Add(new dmpl__Scheme__c(dmpl__PeriodType__c = 'Monthly',
                                        Name = 'Per Bill',
                                        dmpl__ValidTo__c = date.today().addMonths(3),
                                        dmpl__Status__c = 'Approved',
                                        dmpl__MultipleFulfilmentTreatment__c = 'Apply Last Fulfilled',
                                        dmpl__SchemeType__c = 'Per Period Sale Order',
                                        dmpl__BranchId__c = branch.Id,
                                        dmpl__ValidFrom__c = date.today(),
                                        dmpl__PeriodStartDate__c = date.today(),
                                        dmpl__PeriodEndDate__c = date.today().addMonths(3),
                                        dmpl__PartnerAccountId__c = partnerAccount.Id,
                                        dmpl__PartnerAccountGroupId__c = null,
                                        dmpl__Application__c = 'Apply On Selection',
                                        dmpl__ValidCount__c = 1));
        insert scheme1;
        
        List<dmpl__SchemeLine__c> schemeLine = new List<dmpl__SchemeLine__c>();
        schemeLine.Add(new dmpl__SchemeLine__c(dmpl__Title__c = 'Buy 1 and Get 1 free',
                               dmpl__DefinitionFilterCriteria__c = 'All Conditions Are Met',
                                               dmpl__SchemeId__c = scheme1[0].Id,
                                               dmpl__SequenceNumber__c = 1,
                                               dmpl__RewardApplicability__c = 'Custom Logic',
                                               dmpl__RewardCustomLogic__c = '(1) OR (2)'));
        
        schemeLine.Add(new dmpl__SchemeLine__c(dmpl__Title__c = 'Buy 12 and Get 120 Off',
                               dmpl__DefinitionFilterCriteria__c = 'All Conditions Are Met',
                                               dmpl__SchemeId__c = scheme1[0].Id,
                                               dmpl__SequenceNumber__c = 2,
                                               dmpl__RewardApplicability__c = 'All Rewards'));
 
        insert schemeLine;
    }
    
    private static void CreateScheme2()
    {
        List<dmpl__Scheme__c> scheme1 = new List<dmpl__Scheme__c>();
        Account partnerAccount = [Select Id,Name From Account WHERE Name = 'Partner-Test-Account' LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c Where Name = 'Test-Branch'];
        scheme1.Add(new dmpl__Scheme__c(dmpl__PeriodType__c = 'Monthly',
                                        Name = 'Per Period Bill',
                                        dmpl__ValidTo__c = date.today().addMonths(3),
                                        dmpl__Status__c = 'Approved',
                                        dmpl__MultipleFulfilmentTreatment__c = 'Apply All Fulfilled',
                                        dmpl__SchemeType__c = 'Per Period Sale Invoice',
                                        dmpl__BranchId__c = branch.Id,
                                        dmpl__ValidFrom__c = date.today(),
                                        dmpl__PeriodStartDate__c = date.today(),
                                        dmpl__PeriodEndDate__c = date.today().addMonths(3),
                                        dmpl__PartnerAccountId__c = partnerAccount.Id,
                                        dmpl__PartnerAccountGroupId__c = null,
                                        dmpl__Application__c = 'Apply On Selection'));
        insert scheme1;
        
        List<dmpl__SchemeLine__c> schemeLine = new List<dmpl__SchemeLine__c>();
        schemeLine.Add(new dmpl__SchemeLine__c(dmpl__Title__c = 'Buy 12 and Get 120 Off',
                               dmpl__DefinitionFilterCriteria__c = 'All Conditions Are Met',
                                               dmpl__SchemeId__c = scheme1[0].Id,
                                               dmpl__SequenceNumber__c = 1,
                                               dmpl__RewardApplicability__c = 'Custom Logic',
                                               dmpl__RewardCustomLogic__c = '(1) OR (2)'));
        insert schemeLine;
    }
    
        private static void CreateScheme4()
    {
        List<dmpl__Scheme__c> scheme1 = new List<dmpl__Scheme__c>();
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c Where Name = 'Test-Branch'];
        scheme1.Add(new dmpl__Scheme__c(dmpl__PeriodType__c = 'Monthly',
                                        Name = 'Per Period Sale Invoice',
                                        dmpl__ValidTo__c = date.today().addMonths(3),
                                        dmpl__Status__c = 'Approved',
                                        dmpl__MultipleFulfilmentTreatment__c = 'Apply All Fulfilled',
                                        dmpl__SchemeType__c = 'Per Period Repair Order',
                                        dmpl__BranchId__c = branch.Id,
                                        dmpl__ValidFrom__c = date.today(),
                                        dmpl__PeriodStartDate__c = date.today(),
                                        dmpl__PeriodEndDate__c = date.today().addMonths(3),
                                        dmpl__PartnerAccountId__c = null,
                                        dmpl__PartnerAccountGroupId__c = null,
                                        dmpl__Application__c = 'Apply On Selection'));
        insert scheme1;
        
        List<dmpl__SchemeLine__c> schemeLine = new List<dmpl__SchemeLine__c>();
        schemeLine.Add(new dmpl__SchemeLine__c(dmpl__Title__c = 'Buy 12 and Get 120 Off',
                               dmpl__DefinitionFilterCriteria__c = 'All Conditions Are Met',
                                               dmpl__SchemeId__c = scheme1[0].Id,
                                               dmpl__SequenceNumber__c = 1,
                                               dmpl__RewardApplicability__c = 'Custom Logic',
                                               dmpl__RewardCustomLogic__c = '(1) OR (2)'));
        insert schemeLine;
    }
    
    private static void CreateScheme3()
    {
        List<dmpl__Scheme__c> scheme1 = new List<dmpl__Scheme__c>();
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c where dmpl__ItemType__c='Product'  LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c Where Name = 'Test-Branch'];
        scheme1.Add(new dmpl__Scheme__c(dmpl__PeriodType__c = 'Monthly',
                                        Name = 'Per Purchase Order',
                                        dmpl__ValidTo__c = date.today().addMonths(3),
                                        dmpl__Status__c = 'Approved',
                                        dmpl__MultipleFulfilmentTreatment__c = 'Apply All Fulfilled',
                                        dmpl__SchemeType__c = 'Per Purchase Order',
                                        dmpl__BranchId__c = branch.Id,
                                        dmpl__ValidFrom__c = date.today(),
                                        dmpl__PeriodStartDate__c = date.today(),
                                        dmpl__PeriodEndDate__c = date.today().addMonths(3),
                                        dmpl__PartnerAccountId__c = null,
                                        dmpl__PartnerAccountGroupId__c = null,
                                        dmpl__Application__c = 'Apply On Selection'));
        insert scheme1;
        
        List<dmpl__SchemeLine__c> schemeLine = new List<dmpl__SchemeLine__c>();
        schemeLine.Add(new dmpl__SchemeLine__c(dmpl__Title__c = 'Buy 12 and Get 120 Off',
                               dmpl__DefinitionFilterCriteria__c = 'All Conditions Are Met',
                                               dmpl__SchemeId__c = scheme1[0].Id,
                                               dmpl__SequenceNumber__c = 1,
                                               dmpl__RewardApplicability__c = 'All Rewards'));
        insert schemeLine;
        
        insert new dmpl__SchemeCondition__c(
                                                dmpl__SchemeId__c = scheme1[0].Id,
                                                dmpl__ItemId__c=item.Id,  
                                                dmpl__ConditionType__c='Item Quantity',
                                                dmpl__ConditionQuantity__c =5,
                                                dmpl__SequenceNumber__c = 1,
                                                dmpl__SchemeLineId__c = schemeLine[0].Id,
                                                dmpl__ConditionOperator__c = 'Greater Than');
        
         insert new dmpl__SchemeBenefit__c(
                                                 dmpl__DiscountPercent__c = 100,
                                                 dmpl__RewardType__c = 'Discounted Item',
                                                 dmpl__SequenceNumber__c = 1,
                                                 dmpl__RepeatReward__c =  true,
                                                 dmpl__SchemeLineId__c = schemeLine[0].Id,
                                                 dmpl__DiscountedItemId__c = item.id);
        
    }
    
    private static void CreateScheme5()
    {
        List<dmpl__Scheme__c> scheme1 = new List<dmpl__Scheme__c>();
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c where dmpl__ItemType__c='Product'  LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c Where Name = 'Test-Branch'];
        scheme1.Add(new dmpl__Scheme__c(dmpl__PeriodType__c = 'Monthly',
                                        Name = 'Per Purchase Order',
                                        dmpl__ValidTo__c = date.today().addMonths(3),
                                        dmpl__Status__c = 'Approved',
                                        dmpl__MultipleFulfilmentTreatment__c = 'Apply All Fulfilled',
                                        dmpl__SchemeType__c = 'Per Period Purchase Order',
                                        dmpl__BranchId__c = branch.Id,
                                        dmpl__ValidFrom__c = date.today(),
                                        dmpl__PeriodStartDate__c = date.today(),
                                        dmpl__PeriodEndDate__c = date.today().addMonths(3),
                                        dmpl__PartnerAccountId__c = null,
                                        dmpl__PartnerAccountGroupId__c = null,
                                        dmpl__Application__c = 'Apply On Selection'));
        insert scheme1;
        
        List<dmpl__SchemeLine__c> schemeLine = new List<dmpl__SchemeLine__c>();
        schemeLine.Add(new dmpl__SchemeLine__c(dmpl__Title__c = 'Buy 12 and Get 120 Off',
                               dmpl__DefinitionFilterCriteria__c = 'All Conditions Are Met',
                                               dmpl__SchemeId__c = scheme1[0].Id,
                                               dmpl__SequenceNumber__c = 1,
                                               dmpl__RewardApplicability__c = 'All Rewards'));
        insert schemeLine;
        
        insert new dmpl__SchemeCondition__c(
                                                dmpl__SchemeId__c = scheme1[0].Id,
                                                dmpl__ItemId__c=item.Id,  
                                                dmpl__ConditionType__c='Item Quantity',
                                                dmpl__ConditionQuantity__c =5,
                                                dmpl__SequenceNumber__c = 1,
                                                dmpl__SchemeLineId__c = schemeLine[0].Id,
                                                dmpl__ConditionOperator__c = 'Greater Than');
        
         insert new dmpl__SchemeBenefit__c(
                                                 dmpl__DiscountPercent__c = 100,
                                                 dmpl__RewardType__c = 'Discounted Item',
                                                 dmpl__SequenceNumber__c = 1,
                                                 dmpl__RepeatReward__c =  true,
                                                 dmpl__SchemeLineId__c = schemeLine[0].Id,
                                                 dmpl__DiscountedItemId__c = item.id);
        
    }
    
    private static void CreateScheme6()
    {
        List<dmpl__Scheme__c> scheme1 = new List<dmpl__Scheme__c>();
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c where dmpl__ItemType__c='Product'  LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c Where Name = 'Test-Branch'];
        scheme1.Add(new dmpl__Scheme__c(dmpl__PeriodType__c = 'Monthly',
                                        Name = 'Per Repair Order',
                                        dmpl__ValidTo__c = date.today().addMonths(3),
                                        dmpl__Status__c = 'Approved',
                                        dmpl__MultipleFulfilmentTreatment__c = 'Apply All Fulfilled',
                                        dmpl__SchemeType__c = 'Per Repair Order',
                                        dmpl__BranchId__c = branch.Id,
                                        dmpl__ValidFrom__c = date.today(),
                                        dmpl__PeriodStartDate__c = date.today(),
                                        dmpl__PeriodEndDate__c = date.today().addMonths(3),
                                        dmpl__PartnerAccountId__c = null,
                                        dmpl__PartnerAccountGroupId__c = null,
                                        dmpl__Application__c = 'Apply On Selection'));
        insert scheme1;
        
        List<dmpl__SchemeLine__c> schemeLine = new List<dmpl__SchemeLine__c>();
        schemeLine.Add(new dmpl__SchemeLine__c(dmpl__Title__c = 'Buy 12 and Get 120 Off',
                               dmpl__DefinitionFilterCriteria__c = 'All Conditions Are Met',
                                               dmpl__SchemeId__c = scheme1[0].Id,
                                               dmpl__SequenceNumber__c = 1,
                                               dmpl__RewardApplicability__c = 'All Rewards'));
        insert schemeLine;
        
        insert new dmpl__SchemeCondition__c(
                                                dmpl__SchemeId__c = scheme1[0].Id,
                                                dmpl__ItemId__c=item.Id,  
                                                dmpl__ConditionType__c='Item Quantity',
                                                dmpl__ConditionQuantity__c =5,
                                                dmpl__SequenceNumber__c = 1,
                                                dmpl__SchemeLineId__c = schemeLine[0].Id,
                                                dmpl__ConditionOperator__c = 'Greater Than');
        
         insert new dmpl__SchemeBenefit__c(
                                                 dmpl__DiscountPercent__c = 100,
                                                 dmpl__RewardType__c = 'Discounted Item',
                                                 dmpl__SequenceNumber__c = 1,
                                                 dmpl__RepeatReward__c =  true,
                                                 dmpl__SchemeLineId__c = schemeLine[0].Id,
                                                 dmpl__DiscountedItemId__c = item.id);
        
    }
    
    private static void CreateSchemeCondition()
    {
        List<dmpl__SchemeCondition__c> schemeCondition = new List<dmpl__SchemeCondition__c>();
        dmpl__Scheme__c scheme =[Select Id, Name from dmpl__Scheme__c Limit 1];
        dmpl__SchemeLine__c schemeLine =[Select Id, Name from dmpl__SchemeLine__c WHERE dmpl__RewardApplicability__c = 'All Rewards'  Limit 1];
         dmpl__SchemeLine__c schemeLine2 =[Select Id, Name from dmpl__SchemeLine__c WHERE dmpl__RewardApplicability__c != 'All Rewards'  Limit 1]; 
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c where dmpl__ItemType__c='Product'  LIMIT 1];
        schemeCondition.Add(new dmpl__SchemeCondition__c(
                                                         dmpl__SchemeId__c = scheme.Id,
                                                         dmpl__ItemId__c=item.Id,  
                                                         dmpl__ConditionType__c='Item Quantity',
                                                         dmpl__ConditionQuantity__c =5,
                                                         dmpl__SequenceNumber__c = 1,
                                                         dmpl__SchemeLineId__c = schemeLine.Id,
                                                         dmpl__ConditionOperator__c = 'Greater Than'));
        
        schemeCondition.Add(new dmpl__SchemeCondition__c(
                                                         dmpl__SchemeId__c = scheme.Id,
                                                         dmpl__ItemId__c = item.Id,  
                                                         dmpl__ConditionType__c='Item Value',
                                                         dmpl__ConditionValue__c = 500,
                                                         dmpl__SequenceNumber__c = 1,
                                                         dmpl__SchemeLineId__c = schemeLine2.Id,
                                                         dmpl__ConditionOperator__c = 'Greater Than'));
        insert schemeCondition;
    }
    
    private static void CreateSchemeBenefits()
    {
        List<dmpl__SchemeBenefit__c> schemeBenefit = new List<dmpl__SchemeBenefit__c>();
        dmpl__Scheme__c scheme =[Select Id, Name from dmpl__Scheme__c Limit 1];
    dmpl__SchemeLine__c schemeLine =[Select Id, Name from dmpl__SchemeLine__c WHERE dmpl__RewardApplicability__c = 'All Rewards'  Limit 1];
         dmpl__SchemeLine__c schemeLine2 =[Select Id, Name from dmpl__SchemeLine__c WHERE dmpl__RewardApplicability__c != 'All Rewards'  Limit 1];        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c where dmpl__ItemType__c='Product'  LIMIT 1];
        Account customerAccount = [Select Id,Name From Account WHERE dmpl__IsCustomerAccount__c = True LIMIT 1];
        schemeBenefit.Add(new dmpl__SchemeBenefit__c(
                                                     DiscountAmount__c = 100,
                                                     dmpl__RewardType__c = 'Line Level Discount Amount',
                                                     dmpl__SequenceNumber__c = 1,
                                                     dmpl__RepeatReward__c =  true,
                                                     dmpl__SchemeLineId__c = schemeLine.Id,
                                 dmpl__DiscountedItemId__c = item.id
                                                    ));
        schemeBenefit.Add(new dmpl__SchemeBenefit__c(
                                                    dmpl__DiscountPercent__c = 100,
                                                    dmpl__RewardType__c = 'Discounted Item',
                                                    dmpl__SequenceNumber__c = 1,
                                                    dmpl__RepeatReward__c =  true,
                                                    dmpl__SchemeLineId__c = schemeLine2.Id,
                                                    dmpl__DiscountedItemId__c = item.id
        ));
        
        insert schemeBenefit;
        
        /*List<dmpl__SchemeBenefit__c> schemeBenefit1 = new List<dmpl__SchemeBenefit__c>();
        dmpl__Scheme__c scheme1 =[Select Id, Name,dmpl__SchemeType__c,dmpl__MultipleFulfilmentTreatment__c,dmpl__PeriodType__c from dmpl__Scheme__c where  dmpl__SchemeType__c='Sales Order Per Period' Limit 1];
        dmpl__SchemeLine__c schemeLine1 =[Select Id, Name from dmpl__SchemeLine__c  where dmpl__DefinitionFilterCriteria__c = 'Always (No Criteria)' AND dmpl__RewardApplicability__c = 'Any One With Lowest Value' Limit 1];
        schemeBenefit1.Add(new dmpl__SchemeBenefit__c(dmpl__SchemeId__c = scheme1.Id, 
                                                      DiscountAmount__c=500,
                                                      DiscountPercent__c=4,
                                                      dmpl__RewardType__c='Line Level Discount Percent',
                                                      dmpl__SequenceNumber__c = 2,
                                                      dmpl__RepeatReward__c =  true,
                                                      dmpl__SchemeLineId__c=schemeLine1.Id       
                                                     ));
        insert schemeBenefit1;
        
        List<dmpl__SchemeBenefit__c> schemeBenefit3 = new List<dmpl__SchemeBenefit__c>();
        schemeBenefit3.Add(new dmpl__SchemeBenefit__c(dmpl__SchemeId__c = scheme1.Id, 
                                                      DiscountAmount__c=500,
                                                      DiscountPercent__c=4,
                                                      dmpl__DiscountedItemId__c = item.Id,
                                                      dmpl__RewardType__c='Discounted Item',
                                                      dmpl__SequenceNumber__c = 2,
                                                      dmpl__RepeatReward__c =  true,
                                                      dmpl__SchemeLineId__c=schemeLine1.Id       
                                                     ));
        insert schemeBenefit3;
        
        List<dmpl__SchemeBenefit__c> schemeBenefit4 = new List<dmpl__SchemeBenefit__c>();
        schemeBenefit4.Add(new dmpl__SchemeBenefit__c(dmpl__SchemeId__c = scheme1.Id, 
                                                      DiscountAmount__c=500,
                                                      DiscountPercent__c=4,
                                                      dmpl__DiscountedItemGroupId__c = itemGroup.Id,
                                                      dmpl__RewardType__c='Discounted Item Group',
                                                      dmpl__SequenceNumber__c = 2,
                                                      dmpl__RepeatReward__c =  true,
                                                      dmpl__SchemeLineId__c=schemeLine1.Id       
                                                     ));
        insert schemeBenefit4;*/
    }    
     
    private static void CreateBill()
    {
        List<dmpl__Bill__c> bill = new List<dmpl__Bill__c>();
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c Where Name = 'Test-Branch' LIMIT 1];
        Account partnerAccount = [Select Id,Name From Account WHERE Name = 'Partner-Test-Account' LIMIT 1];
        Account supplierAccount = [Select Id,Name From Account WHERE Name = 'Supplier-Test-Account' LIMIT 1];
        bill.add(new dmpl__Bill__c(dmpl__PartnerAccountId__c = partnerAccount.Id,
                                   dmpl__BranchId__c = branch.Id,
                                   dmpl__DocumentDate__c = date.today(),
                                   dmpl__TypeOfBill__c = 'Expense Bill',
                                   dmpl__SupplierAccountId__c = supplierAccount.Id,
                                   dmpl__SupplierInvoiceNumber__c = 'Test-SInvoice',
                                   dmpl__SupplierInvoiceDate__c = date.today(),
                                   dmpl__SupplierInvoiceAmount__c = 100,
                                   dmpl__PerformGLPosting__c = true,
                                   dmpl__TransactionType__c='Sample'
                                  ));
        insert bill;
      
        List<dmpl__BillLine__c> billLine = new List<dmpl__BillLine__c>();
        Account account=[Select Id,Name from Account Where Name='Customer-Test-Account' LIMIT 1];
        dmpl__Item__c item = [Select Id,Name FROM dmpl__Item__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id,Name From dmpl__SKU__c LIMIT 1];
        billLine.add(new dmpl__BillLine__c(dmpl__ItemId__c = item.Id,
                                           dmpl__SKUId__c = sku.Id,
                                           dmpl__AccountId__c = account.Id,
                                           dmpl__Quantity__c = 10,
                                           dmpl__UnitCost__c = 100,
                                           dmpl__ReturnedQuantity__c = 4,
                                           dmpl__IsCustomerBillable__c = true,
                                           dmpl__PurchaseInvoiceId__c = bill[0].Id,
                                           dmpl__SchemeRewardPoints__c = 10
                                          ));
        insert billLine;
        
    }
    
    private static List<dmpl__PurchaseOrder__c> CreatePurchaseOrder()
    {
        List<dmpl__PurchaseOrder__c> purchaseOrder = new List<dmpl__PurchaseOrder__c>();
        Account supplierAccount = [Select Id,Name From Account WHERE Name = 'Supplier-Test-Account' LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c LIMIT 1];
        purchaseOrder.add(new dmpl__PurchaseOrder__c(dmpl__BranchId__c = branch.Id,
                                                     dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                                     dmpl__SupplierAccountId__c = supplierAccount.Id,
                                                     dmpl__PurchaseOrderType__c ='VOR PO',
                                                     dmpl__DocumentDate__c = Date.today(),
                                                     dmpl__Remarks__c = 'Remark',
                                                     dmpl__PerformReleaseInvoice__c=true,
                                                     dmpl__IsInvoiceReleased__c=true,
                                                     dmpl__TransactionType__c='Sample'));
        insert purchaseOrder;
        
        List<dmpl__PurchaseOrderLine__c> purchaseOrderLine = new List<dmpl__PurchaseOrderLine__c>();
        dmpl__Item__c listofitem = [Select Id, Name from dmpl__Item__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id, Name from dmpl__SKU__c LIMIT 1];
        purchaseOrderLine.add(new dmpl__PurchaseOrderLine__c(dmpl__ItemId__c = listofitem.Id,
                                                             dmpl__SKUId__c = sku.Id,
                                                             dmpl__PurchaseOrderId__c = purchaseOrder[0].Id,
                                                             dmpl__Quantity__c = 1
                                                            ));
        insert purchaseOrderLine;
        return purchaseOrder;
    }

    
}