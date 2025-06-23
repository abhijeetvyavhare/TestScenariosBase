@isTest
public class IncentiveProcessor_Test {

    @testSetup
    public static void Setup()
    {
        CreateAccount();
        CreateBranch();
        CreateItems();
        CreateSKu();
        CreateIncentivePlan();
        CreateResource();
        CreateIncentivePeriod();
      //  CreateKPI_Data();
        CreateIncentiveLine();
        CreateIncentiveCompensationSlab();
        CreateIncentiveTarget();
        CreatePerformanceKPI();
        CreateIncentiveResourceTarget();
    }
    
    @isTest
    private static void IncentiveprocessTest()
    {
        try{
            test.StartTest();
            dmpl__IncentivePeriod__c per = [SELECT Id, Name FROM dmpl__IncentivePeriod__c LIMIT 1];
            
            List<dmpl__IncentiveResource__c> res = [SELECT Id FROM dmpl__IncentiveResource__c LIMIT 1];
            dmpl__IncentivePlan__c incentivePlan = [Select Id From dmpl__IncentivePlan__c LIMIT 1];
            List<Id> idList = new List<Id>();
            for (dmpl__IncentiveResource__c resource : res) {
                idList.add(resource.Id);
            }
            IncentiveProcessor processor = new IncentiveProcessor();
            List<AggregateResult> results = IncentiveController.getIncentiveKPI(incentivePlan.Id);
            List<dmpl__IncentivePeriod__c> result1 = IncentiveController.getIncentivePeriods(per.Id);
             Boolean result2 = IncentiveController.processCompensation(per.Id);
             //List<dmpl__IncentiveResourceTarget__c> result3 = IncentiveController.getIncentiveResourcesTargets(per.Id,per.Id);
             List<dmpl__IncentiveResourceTarget__c> result4 = IncentiveController.getIncentiveKPITargets(per.Id,per.Id);
            Boolean result = processor.process(per.Id, idList);
            dmpl__KPIConfiguration__c kpiConfig = new dmpl__KPIConfiguration__c(
           	 Name = 'Test KPI Config',
             dmpl__IsActive__c = true,
             dmpl__TriggerEvent__c = 'Scheduled',
          	 dmpl__TriggerObjectName__c = 'Account',
             dmpl__DateFieldName__c='TestName', 
             dmpl__MemberType__c='Partner'
      		);
         	insert kpiConfig;
            KPIConfigurationService obj = new KPIConfigurationService();
            Account acc = new Account(Name = 'test');
            insert acc;
            obj.createKPIData(kpiConfig,new List<dmpl__IncentiveTarget__c>(),new List<dmpl__IncentivePeriod__c>{per},new List<Account>{acc});
            test.stopTest();
        }catch(exception e){}
    }
    
    @isTest
    private static void IncentiveResourceTest()
    {
        try{
            test.StartTest();
            dmpl__IncentiveResource__c resource = [SELECT Id, Name FROM dmpl__IncentiveResource__c LIMIT 1];
           // List<dmpl__IncentiveResource__c> result = IncentiveController.getIncentiveResources(resource.Id);
            
            test.stopTest();
        }catch(exception e){}
    }
    
    @isTest
    private static void IncentiveObject()
    {
        try{
            test.StartTest();
            dmpl__IncentiveResource__c resource = [SELECT Id, Name FROM dmpl__IncentiveResource__c LIMIT 1];
            List<Object> data = new List<Object>();
            Map<String, Object> target1Data = new Map<String, Object>();
            target1Data.put('Id', resource.Id);
            data.add(target1Data);
            String result = IncentiveController.updateIncentiveResourcesTargets(data);
             dmpl__KPIConfiguration__c config = [SELECT Id, dmpl__LastExecutedSystemModstamp__c FROM dmpl__KPIConfiguration__c LIMIT 1];
        List<dmpl__IncentiveTarget__c> targets = [SELECT Id FROM dmpl__IncentiveTarget__c];
        List<dmpl__IncentivePeriod__c> periods = [SELECT Id FROM dmpl__IncentivePeriod__c];
        String query = 'SELECT Id FROM Account WHERE CreatedDate >= :lastSystemModstamp';
        Id queueId = UserInfo.getUserId();
        Datetime executionDateTime = Datetime.now();
        
        KPIConfigurationDataProcessor batchInstance = new KPIConfigurationDataProcessor(
            config, targets, periods, query, queueId, executionDateTime);
        
        Database.executeBatch(batchInstance, 200);
            
            test.stopTest();
        }catch(exception e){}
    }
    
   @istest
    private static void IncentiveResourceTargetTest()
    {        dmpl__KPIConfiguration__c kpiConfig = new dmpl__KPIConfiguration__c(
            Name = 'Test KPI Config',
            dmpl__IsActive__c = true,
            dmpl__TriggerEvent__c = 'AFTER_INSERT',
            dmpl__MemberType__c = 'Partner',
            dmpl__DateFieldName__c = 'test',
            dmpl__TriggerObjectName__c = 'Account'
        );
        insert kpiConfig;
        
            test.StartTest();
              dmpl__KPIConfiguration__c config = [SELECT Id,dmpl__MemberType__c,dmpl__PartnerFieldName__c,dmpl__TriggerEvent__c,dmpl__DateFieldName__c, dmpl__TriggerObjectName__c,dmpl__LastExecutedSystemModstamp__c FROM dmpl__KPIConfiguration__c LIMIT 1];
        List<dmpl__IncentiveTarget__c> targets = [SELECT Id FROM dmpl__IncentiveTarget__c];
        List<dmpl__IncentivePeriod__c> periods = [SELECT Id FROM dmpl__IncentivePeriod__c];
        String query = 'SELECT Id FROM Account WHERE CreatedDate >= :lastSystemModstamp';
        Id queueId = UserInfo.getUserId();
        Datetime executionDateTime = Datetime.now();
        
        KPIConfigurationDataProcessor batchInstance = new KPIConfigurationDataProcessor(
            config, targets, periods, query, queueId, executionDateTime);
        
        Database.executeBatch(batchInstance, 200);
            

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
                                       dmpl__MemberType__c='Branch'
                                       ));
        
        insert plans;
    }
    /*  private static void CreateKPI_Data()
    {
        List<dmpl__KPIData__c> kpi = new List<dmpl__KPIData__c>();
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c Where Name = 'Test-Branch'];
        Account customerAccount = [Select Id,Name From Account WHERE dmpl__IsCustomerAccount__c = True LIMIT 1];
         dmpl__IncentivePlan__c Plan = [Select Id,Name From dmpl__IncentivePlan__c Limit 1];
         dmpl__IncentivePeriod__c Per = [Select Id,Name From dmpl__IncentivePeriod__c Limit 1];
        kpi.Add(new dmpl__KPIData__c(
                                       Name='Plan1',
                                       dmpl__AccountId__c = customerAccount.Id,
                                       dmpl__BranchId__c = branch.Id,
                                       dmpl__IncentivePlanId__c=Plan.Id,
                                       dmpl__IncentivePeriodId__c=Per.Id
                                       ));
        
        insert kpi;
    }
*/
    
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
    
    private static void CreateCompensationSlab()
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
                                                     dmpl__IncentiveFixedAmount__c=100
                                                     );
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

   
}