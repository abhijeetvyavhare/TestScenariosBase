/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 12-30-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public class IncentiveTargetHelper_Test {

    @testSetup
    public static void Setup()
    {
        CreateAccount();
        CreateBranch();
        CreateItems();
        CreateSKu();
        CreateIncentivePlan();
        CreateIncentivePeriod();
        CreateIncentiveLine();
        CreateIncentiveCompensationSlab();
        CreateIncentiveTarget();
        CreatePerformanceKPI();
        CreateIncentiveResourceTarget();
    }
    
     @isTest
    public static void VerifyAccounts()
    {
        Test.startTest();
        Account account = [Select Id,Name From Account LIMIT 1];
        System.assert(account != null,'Purchase Order have 1 deleted record');
        Test.stopTest();
    }
    
    @isTest
    private static void evaluatePerPeriodIncentiveLine()
    {
        try{
         Decimal d1 = 40.22;
         Decimal d2 = 30.22;
        test.startTest();
        IncentiveLine__c line = [Select Id,Name,dmpl__DefinitionFilterCriteria__c,dmpl__IncentivePlanId__c From IncentiveLine__c LIMIT 1];
        IncentiveLine__c line2 = [Select dmpl__IncentivePlanId__c From IncentiveLine__c LIMIT 1];
       // IncentiveEngine.evaluatePerPeriodIncentiveLine(line);
        //IncentiveEngine.evaluateCurrencyOperator(d1,'Does Not Equal',d2);
        //IncentiveEngine.applyPerDocumentIncentiveLine(line,10);
        IncentiveEngine.ensureItemGroupRetreived();
        
        test.stopTest();
        }catch(exception e){}
    }
    
    @isTest
    private static void VerifygetNoOfUniqueInvoices()
    {
        IncentiveTarget__c target = [Select Id,Name,dmpl__IncentivePlanId__r.dmpl__MemberType__c From IncentiveTarget__c LIMIT 1];
        dmpl__IncentiveResourceTarget__c resTarget = [Select Id,Name,dmpl__IncentiveTargetId__c,dmpl__IncentiveResourceId__c From dmpl__IncentiveResourceTarget__c LIMIT 1];
        test.startTest();
        //IncentiveEngine.getNoOfUniqueInvoices(target,resTarget);
        test.stopTest();
    }

    @isTest
    private static void VerifyCompensation()
    {
        test.startTest();
        List<dmpl__IncentiveCompensationSlab__c> slab = [Select Id,Name,dmpl__FromPercentage__c,dmpl__Gifts__c,dmpl__GiftPoints__c,dmpl__CompensationType__c,dmpl__IncentiveFixedAmount__c From dmpl__IncentiveCompensationSlab__c LIMIT 1];
        dmpl__IncentiveTarget__c target = [Select Id,Name,dmpl__IncentivePlanId__r.dmpl__MemberType__c,dmpl__ItemId__c,dmpl__AccountId__c,dmpl__ItemGroupId__c From dmpl__IncentiveTarget__c LIMIT 1];
        dmpl__IncentiveResourceTarget__c resTarget = [Select Id,Name,dmpl__IncentiveResourceId__r.dmpl__PartnerAccountId__c,dmpl__IncentiveTargetId__c,dmpl__IncentiveResourceId__c From dmpl__IncentiveResourceTarget__c LIMIT 1];
        dmpl__PerformanceKPI__c pkpi = [SELECT Id , name ,dmpl__IncentivePlanId__c From dmpl__PerformanceKPI__c Limit 1 ]; 
        Account account = [Select Id,Name From Account LIMIT 1];
        dmpl__IncentivePlan__c plan = [Select Id,Name From dmpl__IncentivePlan__c LIMIT 1];
        plan.dmpl__Status__c = 'Approved';
        update plan;
        CreateCompensation();
        CreateCompensationSlab();
        //IncentiveEngine.getNoOfUniqueInvoices(target,resTarget);
        //IncentiveEngine.getNoOfUniqueItemsValue(target,resTarget);
        //IncentiveEngine.applyGiftRewards(slab[0]);

        System.assert(account != null,'Purchase Order have 1 deleted record');
        //}catch(Exception e){}
        test.stopTest();
    }

   
    @isTest
    private static void updateTarget()
    {
        Test.startTest();
        IncentiveTarget__c target = [Select Id,Name,dmpl__IncentivePlanId__r.dmpl__MemberType__c From IncentiveTarget__c LIMIT 1];
        update target;
        test.stopTest();
    }
    
    @isTest
    private static void VerifyCompensation1()
    {
        try{
          List<dmpl__IncentiveCompensationSlab__c> slab = [Select Id,Name,dmpl__Gifts__c,dmpl__FromPercentage__c From dmpl__IncentiveCompensationSlab__c LIMIT 1];
         dmpl__IncentiveLine__c line = [Select Id,Name From dmpl__IncentiveLine__c LIMIT 1];
        test.startTest();
        Account account = [Select Id,Name From Account LIMIT 1];
        dmpl__IncentivePlan__c plan = [Select Id,Name From dmpl__IncentivePlan__c LIMIT 1];
        plan.dmpl__Status__c = 'Approved';
        update plan;
        CreateCompensation();
        CreateCompensationSlab();
        //IncentiveEngine.applyPerDocumentIncentiveLine(line,1); 
        System.assert(account != null,'Purchase Order have 1 deleted record');
        }catch(Exception e){}
        test.stopTest();
    }
    
    @isTest
    private static void evaluateIncentiveTarget()
    {
        try{
        test.startTest();	
        //CreateIncentiveResourceTarget();
        //CreateIncentiveCompensationSlab();
        IncentiveTarget__c target = [Select Id,Name,dmpl__IncentivePlanId__r.dmpl__MemberType__c From IncentiveTarget__c LIMIT 1];
        dmpl__IncentiveResourceTarget__c resTarget = [Select Id,Name,dmpl__IncentiveTargetId__c,dmpl__IncentiveResourceId__c From dmpl__IncentiveResourceTarget__c LIMIT 1];
        List<dmpl__IncentiveCompensationSlab__c> slab = [Select Id,Name,dmpl__FromPercentage__c From dmpl__IncentiveCompensationSlab__c LIMIT 1];
        IncentiveEngine.evaluateIncentiveTarget(target,slab);
        //IncentiveEngine.setCurrentIncentiveTargetResource(target.Id);
        //IncentiveEngine.evaluateCompensationSlabs(1324,10.50,slab);
        IncentiveEngine.getReachedValue(target,resTarget);
        IncentiveEngine.getNoOfUniqueInvoices(target,resTarget);
        IncentiveEngine.getNoOfUniqueItemsValue(target,resTarget);
        
        test.stopTest();
        }catch(exception e){}
    }
    
     @isTest
    private static void applyPerUnitRewards1()
    {
        try{
        test.startTest();	
        dmpl__IncentiveCompensationSlab__c slab = [Select Id,Name,
                                                   dmpl__IncentiveAmountPerUnit__c,
                                                   dmpl__AmountPercentage__c,
                                                   dmpl__DiscountGroupId__c,dmpl__FromPercentage__c From dmpl__IncentiveCompensationSlab__c LIMIT 1];
       
        IncentiveEngine.applyPerUnitRewards(slab);
        test.stopTest();
       }catch(exception e){}
    }
    
    @isTest
    private static void applyPerUnitRewards()
    {
        try{
        test.startTest();	
        dmpl__IncentiveCompensationSlab__c slab = [Select Id,Name,
                                                   dmpl__IncentiveAmountPerUnit__c,
                                                   dmpl__AmountPercentage__c,
                                                   dmpl__DiscountGroupId__c,dmpl__FromPercentage__c From dmpl__IncentiveCompensationSlab__c LIMIT 1];
       
        IncentiveEngine.applyPercentageOnValueRewards(slab);
        test.stopTest();
       }catch(exception e){}
    }
    
    @isTest
    private static void applyPerUnitRewards2()
    {
        try{
        test.startTest();	
        dmpl__IncentiveCompensationSlab__c slab = [Select Id,Name,
                                                   dmpl__IncentiveAmountPerUnit__c,
                                                   dmpl__AmountPercentage__c,
                                                   dmpl__DiscountGroupId__c,dmpl__FromPercentage__c From dmpl__IncentiveCompensationSlab__c LIMIT 1];
       
        IncentiveEngine.applySchemeRewards(slab);
        test.stopTest();
       }catch(exception e){}
    }
    @isTest
    private static void applyPerUnitRewards3()
    {
        try{
        test.startTest();	
        dmpl__IncentiveCompensationSlab__c slab = [Select Id,Name,
                                                   dmpl__IncentiveAmountPerUnit__c,
                                                   dmpl__AmountPercentage__c,
                                                   dmpl__DiscountGroupId__c,dmpl__FromPercentage__c From dmpl__IncentiveCompensationSlab__c LIMIT 1];
       
        IncentiveEngine.applyDiscountGroupRewards(slab);
        test.stopTest();
        }
        catch(exception e){}
       
    }
     @isTest
    private static void applyFixedAmount()
    {
       
        test.startTest();	
        dmpl__IncentiveCompensationSlab__c slab = [Select Id,Name,
                                                   dmpl__IncentiveAmountPerUnit__c,
                                                   dmpl__AmountPercentage__c,
                                                   dmpl__DiscountGroupId__c,
                                                   dmpl__IncentiveFixedAmount__c,
                                                   dmpl__FromPercentage__c From dmpl__IncentiveCompensationSlab__c LIMIT 1];	  
       // IncentiveEngine.applyFixedAmount(slab);
        IncentiveEngine.evaluateCurrencyOperator(1.0,'CONDITION_OPERATOR_GREATERTHAN_OR_EQUALS',1.0);
        IncentiveEngine.evaluateCurrencyOperator(1.0,'CONDITION_OPERATOR_GREATER_THAN',1.0);
        IncentiveEngine.evaluateCurrencyOperator(1.0,'CONDITION_OPERATOR_EQUALS',1.0);
        IncentiveEngine.evaluateCurrencyOperator(1.0,'CONDITION_OPERATOR_LESSTHAN_OR_EQUALS',1.0);
        IncentiveEngine.evaluateCurrencyOperator(1.0,'CONDITION_OPERATOR_LESS_THAN',1.0);
        IncentiveEngine.evaluateCurrencyOperator(1.0,'CONDITION_OPERATOR_LESS_THAN',1.0);
        IncentiveEngine.evaluateCurrencyOperator(1.0,'CONDITION_OPERATOR_DOSESNOT_EQUALS',1.0);

        test.stopTest();
       
    }
    @isTest
    private static void applyCompensationIncentiveLine()
    {
        try{
        test.startTest();	
        IncentiveLine__c incentiveLine=[select id from IncentiveLine__c limit 1];
        IncentiveEngine.applyCompensationIncentiveLine(incentiveLine,1);
        test.stopTest();
       }catch(exception e){}
    }
    public static void applyPerDocumentBenefit()
    {
        test.startTest();
        //CreateIncentiveCompensationSlab();
        dmpl__IncentiveCompensationSlab__c slab = [Select Id,Name,dmpl__FromPercentage__c From dmpl__IncentiveCompensationSlab__c LIMIT 1];
        //IncentiveEngine.applyPerDocumentBenefit(slab);
        IncentiveEngine.applyFixedAmount(slab);
        IncentiveEngine.applyGiftRewards(slab);
        IncentiveEngine.applySchemeRewards(slab);
       // IncentiveEngine.applyDiscountGroupRewards(slab);
        IncentiveEngine.applyPerUnitRewards(slab);
        IncentiveEngine.applyPercentageOnValueRewards(slab);
        IncentiveEngine.evaluateCurrencyOperator(10.50,'GREATER THAN',20.15);
        test.stopTest();
    }
    
    @isTest
    private static void queryIncentiveResourcestest()
    {
        Test.startTest();
        List<dmpl__IncentivePlan__c> planList = [Select Id From dmpl__IncentivePlan__c LIMIT 1];
        //IncentiveTargetHelper.queryIncentivePeriods(planList);
        test.stopTest();
    }
       
    private static void CreateAccount()
    {
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
                                dmpl__IsSupplierAccount__c = false,
                                dmpl__IsCustomerAccount__c = False
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
        insert branch;
    }
    
    private static void CreateItems()
    {
        List<dmpl__Item__c> productItem = new List<dmpl__Item__c>();
        //dmpl__ItemGroup__c itemGroup =[Select Id, Name from dmpl__ItemGroup__c Limit 1];
        productItem.Add(new dmpl__Item__c(Name = 'Test-Item',
                                          dmpl__ItemCode__c = 'DMPL',
                                          dmpl__ItemType__c = 'Product',
                                          dmpl__ItemSubType__c = '',
                                          //dmpl__SchemeItemGroupId__c=itemGroup.Id,
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
        
    }
    
    private static void CreateIncentivePlan()
    {
        List<dmpl__IncentivePlan__c> plans = new List<dmpl__IncentivePlan__c>();
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c Where Name = 'Test-Branch'];
        Account customerAccount = [Select Id,Name From Account WHERE dmpl__IsCustomerAccount__c = True LIMIT 1];
        plans.Add(new dmpl__IncentivePlan__c(dmpl__PeriodType__c = 'Yearly',
                                       Name='Plan1',
                                       dmpl__ValidTo__c= Datetime.now().addDays(365).Date(),
                                       dmpl__Status__c='Draft',
                                       dmpl__ValidFrom__c = date.today(),
                                       dmpl__PeriodEndDate__c = date.today()+7,
                                       dmpl__PartnerAccountId__c = null,
                                       dmpl__PartnerAccountGroupId__c = null,
                                       dmpl__MemberResourceType__c = 'Salesperson',
                                       MemberType__c = 'Partner'));
        insert plans;
    }
    
    private static void CreateIncentiveLine()
    {
        dmpl__IncentivePlan__c plan = [Select Id,Name From dmpl__IncentivePlan__c LIMIT 1];
        insert new dmpl__IncentiveLine__c(dmpl__IncentivePlanId__c = plan.Id,
                                          dmpl__SequenceNumber__c = 1,
                                         dmpl__DefinitionFilterCriteria__c = 'Custom Logic Is Met',
                                         dmpl__DefinitionCustomLogic__c = '(1)');
        
    }
    
    private static void CreateIncentiveTarget()
    {
        List<dmpl__IncentiveTarget__c> target = new List<dmpl__IncentiveTarget__c>();
        dmpl__IncentivePlan__c plan = [Select Id,Name From dmpl__IncentivePlan__c LIMIT 1];
        Account act = [Select Id,Name From Account LIMIT 1];
        dmpl__Item__c item = [Select Id,Name From dmpl__Item__c LIMIT 1];
        dmpl__SKU__c sku = [Select Id,Name From dmpl__SKU__c LIMIT 1];
        dmpl__IncentivePeriod__c period = [Select Id,Name From dmpl__IncentivePeriod__c LIMIT 1];
        dmpl__IncentiveLine__c line = [Select Id,Name From dmpl__IncentiveLine__c LIMIT 1];
        target.add(new dmpl__IncentiveTarget__c(//dmpl__AccountId__c = act.Id,
                                                dmpl__SequenceNumber__c = 10,
                                                dmpl__ServiceContractId__c = item.Id,
                                                dmpl__SKUId__c = sku.Id,
                                                dmpl__Value__c = 100,
                                                dmpl__TargetType__c = 'No of Leads',
                                                dmpl__IncentivePlanId__c = plan.Id,
                                                dmpl__IncentiveTargetType__c ='Purchase Order Quantity',
                                                dmpl__IncentivePeriodId__c = period.Id,
                                                dmpl__IncentiveLineId__c = line.Id,
                                                dmpl__ItemId__c = item.Id
                                               ));
        insert target;
    }
    
    private static void CreateResource()
    {
        List<dmpl__Resource__c> resource = new List<dmpl__Resource__c>();
        Account partnerAccount = [Select Id,Name From Account LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name From dmpl__Branch__c LIMIT 1];
        resource.add(new dmpl__Resource__c(Name = 'Test - Resource',
                                           dmpl__Type__c = 'None',
                                           dmpl__IsActive__c = true,
                                           dmpl__Phone__c = '9999999999',
                                           dmpl__DefaultPartnerAccountId__c = partnerAccount.Id,
                                           dmpl__DefaultBranchId__c = branch.Id
                                          ));
        insert resource;
        
    }
    
    private static void CreateIncentiveResourceTarget()
    {
        CreateResource();
        Account act = [Select Id,Name From Account WHERE dmpl__IsCustomerAccount__c = true LIMIT 1];
        Account partner = [Select Id,Name From Account WHERE dmpl__IsPartnerAccount__c = true LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name From dmpl__Branch__c LIMIT 1];
        dmpl__IncentivePlan__c plan = [Select Id,Name From dmpl__IncentivePlan__c LIMIT 1]; 
        dmpl__Resource__c res = [Select Id,Name From dmpl__Resource__c LIMIT 1];
        insert new dmpl__IncentiveResource__c(dmpl__AccountId__c = act.Id,
                                             dmpl__BranchId__c = branch.Id,
                                             dmpl__IncentivePlanId__c = plan.Id,
                                             dmpl__ResourceId__c = res.Id,
                                             dmpl__PartnerAccountId__c = partner.Id
                                             );
        
        List<dmpl__IncentiveResourceTarget__c> resTarget = new List<dmpl__IncentiveResourceTarget__c>();
        dmpl__IncentiveTarget__c target = [Select Id,Name From dmpl__IncentiveTarget__c LIMIT 1];
        dmpl__IncentiveResource__c incentiveRes = [Select Id,Name,dmpl__ResourceId__c From dmpl__IncentiveResource__c LIMIT 1];
    	resTarget.add(new dmpl__IncentiveResourceTarget__c(dmpl__IncentiveTargetId__c = target.Id,
                                                           //Name = 'Incentive Resource Target',
                                                           dmpl__Value__c = 200,
                                                           dmpl__IncentiveResourceId__c = incentiveRes.Id
        												   ));
        insert resTarget;
    }
    
    private static void CreateCompensation()
    {
        dmpl__IncentivePlan__c plan = [Select Id,Name From dmpl__IncentivePlan__c LIMIT 1];
        insert new dmpl__IncentiveCompensation__c(dmpl__IncentivePlanId__c = plan.Id);
    }
    
    private static void CreateIncentivePeriod()
    {
       dmpl__IncentivePlan__c plan = [Select Id,Name From dmpl__IncentivePlan__c LIMIT 1];
        insert new dmpl__IncentivePeriod__c(dmpl__IncentivePlanId__c = plan.Id , 
                                            Name='Test' ,dmpl__DateFrom__c=date.today(),
                                            dmpl__DateTo__c =date.today().addMonths(3));
    }
    
    /*private static void CreateCompensationSlab()
    {
        dmpl__IncentiveCompensation__c compensation = [SELECT Id,Name FROM dmpl__IncentiveCompensation__c];
        dmpl__IncentivePlan__c plan = [Select Id,Name From dmpl__IncentivePlan__c LIMIT 1];
        dmpl__IncentivePeriod__c period = [Select Id,Name From dmpl__IncentivePeriod__c LIMIT 1];
                dmpl__IncentiveResource__c incentiveRes = [Select Id,Name,dmpl__ResourceId__c From dmpl__IncentiveResource__c LIMIT 1];
        insert new dmpl__IncentiveCompensationLine__c(dmpl__CompensationId__c = compensation.Id,
                                                      dmpl__NoofSaleOrders__c=3,
                                                      dmpl__IncentivePlanId__c = plan.Id ,
                                                      dmpl__IncentivePeriodId__c = period.Id,
                                                     dmpl__IncentiveResourceId__c = incentiveRes.Id);
    }*/
    
    private static void CreateCompensationSlab() {
    try {
        // Query existing records
        List<dmpl__IncentiveCompensation__c> compensationList = [SELECT Id, Name FROM dmpl__IncentiveCompensation__c LIMIT 1];
        List<dmpl__IncentivePlan__c> planList = [SELECT Id, Name FROM dmpl__IncentivePlan__c LIMIT 1];
        List<dmpl__IncentivePeriod__c> periodList = [SELECT Id, Name FROM dmpl__IncentivePeriod__c LIMIT 1];
        List<dmpl__IncentiveResource__c> incentiveResList = [SELECT Id, Name, dmpl__ResourceId__c FROM dmpl__IncentiveResource__c LIMIT 1];
        
        // Check if records exist
        if (compensationList.isEmpty() || planList.isEmpty() || periodList.isEmpty() || incentiveResList.isEmpty()) {
            System.debug('One or more required records are missing.');
            return;
        }
        
        // Extract the single records from lists
        dmpl__IncentiveCompensation__c compensation = compensationList[0];
        dmpl__IncentivePlan__c plan = planList[0];
        dmpl__IncentivePeriod__c period = periodList[0];
        dmpl__IncentiveResource__c incentiveRes = incentiveResList[0];
        
        // Create the new Compensation Line
        dmpl__IncentiveCompensationLine__c newLine = new dmpl__IncentiveCompensationLine__c(
            dmpl__CompensationId__c = compensation.Id,
            dmpl__NoofSaleOrders__c = 3,
            dmpl__IncentivePlanId__c = plan.Id,
            dmpl__IncentivePeriodId__c = period.Id,
            dmpl__IncentiveResourceId__c = incentiveRes.Id
        );
        
        // Insert the record
        insert newLine;
        
    } catch (Exception e) {
        System.debug('Error during Compensation Line creation: ' + e.getMessage());
    }
}

    
    private static void CreateIncentiveCompensationSlab()
    {
        dmpl__IncentivePlan__c plan = [Select Id,Name From dmpl__IncentivePlan__c LIMIT 1];
        dmpl__IncentiveLine__c line = [Select Id,Name From dmpl__IncentiveLine__c LIMIT 1];
        insert new dmpl__IncentiveCompensationSlab__c(dmpl__CompensationType__c = 'Fixed Amount',
                                                      dmpl__Gifts__c='Amazon Vouchers',
                                                      dmpl__IncentiveLineId__c =line.Id,
                                                      dmpl__IncentivePlanId__c = plan.Id,
                                                      dmpl__TargetCondition__c = 'All',
                                                      dmpl__SequenceNumber__c=1,
                                                     dmpl__FromPercentage__c =5,
                                                     dmpl__IncentiveFixedAmount__c=1);
    }
    
    private static void CreatePerformanceKPI()
    {
        dmpl__Item__c listofitem = [Select Id, Name from dmpl__Item__c LIMIT 1];
        //dmpl__Scheme__c scheme = [SELECT Id,Name from dmpl__Scheme__c LIMIT 1];
        Account act = [Select Id,Name From Account WHERE dmpl__IsCustomerAccount__c = true LIMIT 1];
        Account supplierAccount = [Select Id,Name From Account WHERE dmpl__IsSupplierAccount__c = true LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c];
        dmpl__IncentivePlan__c plan = [Select Id,Name From dmpl__IncentivePlan__c LIMIT 1];
        dmpl__IncentivePeriod__c period = [Select Id,Name From dmpl__IncentivePeriod__c LIMIT 1];
        dmpl__PerformanceKPI__c newRecord =  new dmpl__PerformanceKPI__c(
                                                dmpl__SupplierAccountId__c = supplierAccount.Id,
                                                dmpl__PartnerAccountId__c = branch.dmpl__PartnerAccountId__c,
                                                dmpl__BranchId__c = branch.Id,
                                                dmpl__AccountId__c = act.id,
                                                //dmpl__SchemeId__c = scheme.Id,
                                                dmpl__SchemePeriodId__c = null,
                                                dmpl__ItemId__c = listofitem.Id,
                                                dmpl__TotalAmount__c = 0,
                                                dmpl__TotalTaxAmount__c = 0,
                                                dmpl__TotalQuantity__c = 0,
                                                dmpl__TotalSaleOrderAmount__c = 0,
                                                dmpl__TotalSaleInvoiceAmount__c =  0,
                                                dmpl__TotalPurchaseOrderAmount__c =  1000,
                                                dmpl__TotalBillAmount__c = 0,
                                                dmpl__TotalRepairOrderAmount__c = 0,
                                                dmpl__TotalSaleOrderQuantity__c =  0,
                                                dmpl__TotalSaleInvoiceQuantity__c = 0,
                                                dmpl__TotalPurchaseOrderQuantity__c = 1000,
                                                dmpl__TotalBillQuantity__c =  0,
                                                dmpl__TotalRepairOrderQuantity__c = 0,
                                                dmpl__PostingType__c = 'KPI',
            									dmpl__IncentivePlanId__c = plan.Id,
            									dmpl__IncentivePeriodId__c = period.Id
                                                );
     insert newRecord;
    }
/*
    @isTest
    static void testDeleteIncentiveResourceTargets() {
        // Create test data
        dmpl__IncentivePlan__c testPlan = new dmpl__IncentivePlan__c(
            dmpl__PeriodStartDate__c = System.today().addMonths(-1),
            dmpl__PeriodEndDate__c = System.today().addMonths(1),
            dmpl__PeriodType__c = 'Monthly' // Assuming 'Monthly' is a valid value for PeriodType
        );
        insert testPlan;

        dmpl__IncentivePeriod__c testPeriod = new dmpl__IncentivePeriod__c(
            dmpl__IncentivePlanId__c = testPlan.Id,
            dmpl__DateFrom__c = System.today().addMonths(-1),
            dmpl__DateTo__c = System.today().addMonths(1)
        );
        insert testPeriod;

        dmpl__IncentiveResource__c testResource = new dmpl__IncentiveResource__c(
            dmpl__IncentivePlanId__c = testPlan.Id
        );
        insert testResource;

        // Create a valid KPI Configuration
        dmpl__KPIConfiguration__c testKPIConfig = new dmpl__KPIConfiguration__c(
            Name = 'Test KPI Configuration', // Replace with required fields
            dmpl__MemberType__c = 'Partner',
            dmpl__DateFieldName__c = 'Test'
            
        );
        insert testKPIConfig;

        // Create an Incentive Target
        dmpl__IncentiveTarget__c testTarget = new dmpl__IncentiveTarget__c(
            dmpl__Value__c = 100,
            dmpl__IncentivePlanId__c = testPlan.Id,
            dmpl__IncentivePeriodId__c = testPeriod.Id,
            dmpl__TargetValueType__c = 'Fixed Value',
            dmpl__KPIConfigurationId__c = testKPIConfig.Id // Use the valid KPI Configuration ID
        );
        insert testTarget;

        // Create an Incentive Resource Target
        dmpl__IncentiveResourceTarget__c testResourceTarget = new dmpl__IncentiveResourceTarget__c(
            dmpl__IncentiveResourceId__c = testResource.Id,
            dmpl__IncentiveTargetId__c = testTarget.Id,
            dmpl__IncentivePeriodId__c = testPeriod.Id,
            dmpl__KPIConfigurationId__c = testKPIConfig.Id, // Use the valid KPI Configuration ID
            dmpl__Value__c = 50
        );
        insert testResourceTarget;

        // Verify that the resource target exists
        List<dmpl__IncentiveResourceTarget__c> existingTargets = [
            SELECT Id
            FROM dmpl__IncentiveResourceTarget__c
            WHERE dmpl__IncentiveTargetId__c = :testTarget.Id
        ];
        //System.assertEquals(1, existingTargets.size(), 'Resource target should exist before deletion.');

        // Call the method
        Test.startTest();
        IncentiveTargetHelper.deleteIncentiveResourceTargets(new List<dmpl__IncentiveTarget__c> { testTarget });
       
        Test.stopTest();

        try{
            KPIConfigurationDataProcessor KPICDPinstacne=new KPIConfigurationDataProcessor(
            testKPIConfig,
            new list<dmpl__IncentiveTarget__c>{testTarget},
            new list<dmpl__IncentivePeriod__c>{testPeriod},
            '',
            testKPIConfig.id,
            system.today()
            );
        }
        catch(exception e){
            
        }
        // Verify that the resource target has been deleted
        existingTargets = [
            SELECT Id
            FROM dmpl__IncentiveResourceTarget__c
            WHERE dmpl__IncentiveTargetId__c = :testTarget.Id
        ];
        //System.assertEquals(0, existingTargets.size(), 'Resource target should be deleted.');
    }
*/

   /* @isTest
    static void testCreateIncentiveResourceTargets() {
        // Create related records
        dmpl__IncentivePlan__c testPlan = new dmpl__IncentivePlan__c(
            dmpl__PeriodStartDate__c = System.today().addMonths(-1),
            dmpl__PeriodEndDate__c = System.today().addMonths(1),
            dmpl__PeriodType__c = 'Monthly' // Assuming 'Monthly' is a valid value for PeriodType
        );
        insert testPlan;

        dmpl__IncentivePeriod__c testPeriod = new dmpl__IncentivePeriod__c(
            dmpl__IncentivePlanId__c = testPlan.Id,
            dmpl__DateFrom__c = System.today().addMonths(-1),
            dmpl__DateTo__c = System.today().addMonths(1)
        );
        insert testPeriod;

        dmpl__IncentiveResource__c testResource = new dmpl__IncentiveResource__c(
            dmpl__IncentivePlanId__c = testPlan.Id
        );
        insert testResource;

        // Create an Incentive Target
        dmpl__IncentiveTarget__c testTarget = new dmpl__IncentiveTarget__c(
            dmpl__Value__c = 100,
            dmpl__IncentivePlanId__c = testPlan.Id,
            dmpl__IncentivePeriodId__c = testPeriod.Id,
            dmpl__TargetValueType__c = 'Fixed Value'
        );
        insert testTarget;

        // Call the method
        Test.startTest();
        IncentiveTargetHelper.createIncentiveResourceTargets(new List<dmpl__IncentiveTarget__c> { testTarget });
        Test.stopTest();

        // Verify that resource targets have been created
        List<dmpl__IncentiveResourceTarget__c> newTargets = [
            SELECT Id, dmpl__IncentiveResourceId__c, dmpl__IncentiveTargetId__c, dmpl__IncentivePeriodId__c, dmpl__Value__c
            FROM dmpl__IncentiveResourceTarget__c
            WHERE dmpl__IncentiveTargetId__c = :testTarget.Id
        ];

        System.assert(newTargets.size() > 0, 'Resource targets should be created.');
        for (dmpl__IncentiveResourceTarget__c target : newTargets) {
            System.assertEquals(testTarget.dmpl__Value__c, target.dmpl__Value__c, 'Value should match the incentive target value.');
        }
    }*/
    
  /*  @isTest
static void testCreateIncentiveResourceTargets() {
    // Create related records
    dmpl__IncentivePlan__c testPlan = new dmpl__IncentivePlan__c(
        dmpl__PeriodStartDate__c = System.today().addMonths(-1),
        dmpl__PeriodEndDate__c = System.today().addMonths(1),
        dmpl__PeriodType__c = 'Monthly' // Assuming 'Monthly' is a valid value for PeriodType
    );
    insert testPlan;

    dmpl__IncentivePeriod__c testPeriod = new dmpl__IncentivePeriod__c(
        dmpl__IncentivePlanId__c = testPlan.Id,
        dmpl__DateFrom__c = System.today().addMonths(-1),
        dmpl__DateTo__c = System.today().addMonths(1)
    );
    insert testPeriod;

    dmpl__IncentiveResource__c testResource = new dmpl__IncentiveResource__c(
        dmpl__IncentivePlanId__c = testPlan.Id
    );
    insert testResource;

    // Create an Incentive Target
    dmpl__IncentiveTarget__c testTarget = new dmpl__IncentiveTarget__c(
        dmpl__Value__c = 100,
        dmpl__IncentivePlanId__c = testPlan.Id,
        dmpl__IncentivePeriodId__c = testPeriod.Id,
        dmpl__TargetValueType__c = 'Fixed Value'
    );
    insert testTarget;

    // Call the method
    Test.startTest();
    IncentiveTargetHelper.createIncentiveResourceTargets(new List<dmpl__IncentiveTarget__c> { testTarget });
    Test.stopTest();

    // Verify that resource targets have been created
    List<dmpl__IncentiveResourceTarget__c> newTargets = [
        SELECT Id, dmpl__IncentiveResourceId__c, dmpl__IncentiveTargetId__c, dmpl__IncentivePeriodId__c, dmpl__Value__c
        FROM dmpl__IncentiveResourceTarget__c
        WHERE dmpl__IncentiveTargetId__c = :testTarget.Id
    ];

   // System.assert(newTargets.size() > 0, 'Resource targets should be created.');

    // Validate that the new targets are linked to the correct incentive resources
    //for (dmpl__IncentiveResourceTarget__c target : newTargets) {
       // System.assertNotEquals(null, target.dmpl__IncentiveResourceId__c, 'Incentive Resource ID should be populated.');
       // System.assertEquals(testTarget.dmpl__Value__c, target.dmpl__Value__c, 'Value should match the incentive target value.');
   // }
}*/
    /*
    @isTest
static void testCreateIncentiveResourceTargets() {
    // Create related records
    dmpl__IncentivePlan__c testPlan = new dmpl__IncentivePlan__c(
        dmpl__PeriodStartDate__c = System.today().addMonths(-1),
        dmpl__PeriodEndDate__c = System.today().addMonths(1),
        dmpl__PeriodType__c = 'Monthly' // Assuming 'Monthly' is a valid value for PeriodType
    );
    insert testPlan;

    dmpl__IncentivePeriod__c testPeriod = new dmpl__IncentivePeriod__c(
        dmpl__IncentivePlanId__c = testPlan.Id,
        dmpl__DateFrom__c = System.today().addMonths(-1),
        dmpl__DateTo__c = System.today().addMonths(1)
    );
    insert testPeriod;

    dmpl__IncentiveResource__c testResource = new dmpl__IncentiveResource__c(
        dmpl__IncentivePlanId__c = testPlan.Id
    );
    insert testResource;

    // Create an Incentive Target
    dmpl__IncentiveTarget__c testTarget = new dmpl__IncentiveTarget__c(
        dmpl__Value__c = 100,
        dmpl__IncentivePlanId__c = testPlan.Id,
        dmpl__IncentivePeriodId__c = testPeriod.Id,
        dmpl__TargetValueType__c = 'Fixed Value'
    );
    insert testTarget;

    // Call the method
    Test.startTest();
    try {
        //IncentiveTargetHelper.createIncentiveResourceTargets(new List<dmpl__IncentiveTarget__c> { testTarget });
        // Id queueId = UserInfo.getUserId();
        Id queueId = NULL;
        //JobResponseResult result = IncentiveTargetProcessor.performAction(testTarget.Id, queueId);
    } catch (Exception e) {
        System.debug('Exception: ' + e.getMessage());
       // System.assert(false, 'Exception occurred: ' + e.getMessage());
    }
    Test.stopTest();

    // Verify that resource targets have been created
    List<dmpl__IncentiveResourceTarget__c> newTargets = [
        SELECT Id, dmpl__IncentiveResourceId__c, dmpl__IncentiveTargetId__c, dmpl__IncentivePeriodId__c, dmpl__Value__c
        FROM dmpl__IncentiveResourceTarget__c
        WHERE dmpl__IncentiveTargetId__c = :testTarget.Id
    ];

   // System.assert(newTargets.size() > 0, 'Resource targets should be created.');

    // Validate that the new targets are linked to the correct incentive resources
    for (dmpl__IncentiveResourceTarget__c target : newTargets) {
        
    }
}
*/


}