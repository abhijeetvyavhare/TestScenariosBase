@isTest
public class VisitPlanHelper_Test {
    
    
    @testSetup
    public static void Setup()
    {
        CreateAccount();
        CreateBranch();
        CreateResouce();
        CreateVisitRoutes();
        CreateVisitRouteStop();
        CreateVisitTaskTemplate();
        CreateVisitPlans();
        CreateVisits();
        CreateVisitTaskTemplateEntry();
		CreateVisitTaskTemplateActivity();
        CreateVisitTask();
        CreateVisitTaskActivity();
    }
    
  
    @isTest
    public static void updateVisitNew()
    {
        test.startTest();
        dmpl__VisitPlan__c plan = [Select Id,Name,dmpl__Status__c From dmpl__VisitPlan__c LIMIT 1];
        VisitPlanHelper.optimiseRoute(plan.Id); 
        test.stopTest();
    }
    
    @isTest
    public static void verifyuploadFile()
    {
        test.startTest();
        String str = 'Upload File';
        String fileName = 'FileName';
        dmpl__VisitPlan__c plan = [Select Id,Name,dmpl__Status__c From dmpl__VisitPlan__c LIMIT 1];
        VisitPlanController.uploadFile(plan.Id,str,fileName);
        test.stopTest();
    }
    
    @isTest
    public static void updateVisitNew2()
    {
        test.startTest();
        dmpl__VisitPlan__c plan = [Select Id,Name,dmpl__Status__c From dmpl__VisitPlan__c LIMIT 1];
        VisitPlanHelper.optimiseRoute(plan.Id); 
        test.stopTest();
    }
    
    @isTest
    public static void updateclearRoutes()
    {
        test.startTest();
        dmpl__VisitPlan__c plan = [Select Id,Name,dmpl__Status__c From dmpl__VisitPlan__c LIMIT 1];
        VisitPlanHelper.clearRoutes(plan.Id); 
        test.stopTest();
    }
    
    @isTest
    public static void queryVisits()
    {
        test.startTest();
        List<Id> ids = new List<Id>();
        dmpl__VisitPlan__c plan = [Select Id,Name,dmpl__Status__c From dmpl__VisitPlan__c LIMIT 1];
        ids.add(plan.Id);
        VisitPlanHelper.queryVisits(ids); 
        test.stopTest();
    }
    
    @isTest
    public static void queryPendingDeliveryOrders()
    {
        test.startTest();
        dmpl__VisitPlan__c plan = [Select Id,Name,dmpl__Status__c,
                                   dmpl__BranchId__c,dmpl__PartnerAccountId__c,
                                   dmpl__PlanStartDate__c,dmpl__PlanEndDate__c
                                   From dmpl__VisitPlan__c LIMIT 1];
        VisitPlanHelper.queryPendingDeliveryOrders(plan); 
        Id queueId = UserInfo.getUserId();
        JobResponseResult result = VisitPlanProcessor.perfromAction(plan.Id, queueId);
        test.stopTest();
    }
    
    @isTest
    public static void verifyVisit()
    {
        test.startTest();
        dmpl__Visit__c visit = [Select Id,Name From dmpl__Visit__c LIMIT 1];
        VisitPlanController.getVisitPlan(visit.Id);
        
        VisitPlanController.getVisitTasks(visit.Id);
        VisitHelper.getVisitTasks(visit.Id);
        System.assert(visit != null);
        test.stopTest();
    }
    
    @isTest
    public static void updateVisitTemplateId()
    {
        test.startTest();
        List<dmpl__Visit__c> visits = new List<dmpl__Visit__c>();
        Account act = [Select Id,Name From Account WHERE dmpl__IsCustomerAccount__c = True LIMIT 1];
        dmpl__VisitPlan__c plan = [Select Id,Name From dmpl__VisitPlan__c LIMIT 1];
        dmpl__VisitTaskTemplate__c template = [Select Id,Name from dmpl__VisitTaskTemplate__c LIMIT 1];
        visits.add(new dmpl__Visit__c(dmpl__SequenceNumber__c = 1,
                                      dmpl__GeofencingTolerance__c = 15,
                                      dmpl__AccountId__c = act.Id,
                                      dmpl__VisitTaskTemplateId__c =null,
                                      dmpl__DocumentDate__c = date.today(),
                                      dmpl__VisitPlanId__c = plan.Id,
                                      dmpl__VisitStatus__c = 'Planned'
                                     ));
        insert visits;
        visits[0].dmpl__VisitTaskTemplateId__c=template.Id;
        Update visits;
        System.assert(visits[0] != null);
        test.stopTest();
    }
    
    @isTest
    public static void updateVisit()
    {
        test.startTest();
        List<dmpl__Visit__c> visit = [Select Id,Name,dmpl__VisitStatus__c,dmpl__VisitTaskTemplateId__c From dmpl__Visit__c LIMIT 1];
        if(visit != null)
            visit[0].dmpl__VisitStatus__c = 'Assigned';
        update visit;
        System.assert(visit != null, 'Visit Data is Updated');
        test.stopTest();
    }
    
    @isTest
    public static void deleteVisit()
    {
        test.startTest();
        dmpl__Visit__c visit = [Select Id,Name,dmpl__VisitPlanId__c From dmpl__Visit__c LIMIT 1];
        delete visit;
        System.assert(visit != null);
        test.stopTest();
    }
    
    @isTest
    public static void updateVisitPlans()
    {
        test.startTest();
        dmpl__VisitPlan__c plan = [Select Id,Name,dmpl__Status__c From dmpl__VisitPlan__c LIMIT 1];
        if(plan != null)
            plan.dmpl__Status__c = 'Assigned';
        update plan;
        System.assert(plan != null, 'Plan Data');
        test.stopTest();
    }
    
    @isTest
    public static void updateVisitTask()
    {
        test.startTest();
        Date date1 = date.today();
        String str = 'DateTimeFormat';
        dmpl__DMSDocumentNameSetting__mdt settingsToInsert = new dmpl__DMSDocumentNameSetting__mdt();
        List<dmpl__VisitTask__c> task = [Select Id,Name,dmpl__Status__c From dmpl__VisitTask__c LIMIT 1];
        if(task != null)
            update task;
        VisitTaskHelper.setStatusTimeStamps(task,task);
        DocumentNameHelper.formatDatePart(date1,str);
        //DocumentNameHelper.formatAutoNumberPart(str,settingsToInsert);
        System.assert(task != null);
        test.stopTest();
    }
    
    @isTest
    public static void updateVisitTaskTemplate()
    {
        test.startTest();
        dmpl__VisitTaskActivity__c visitTaskActivity = [SELECT Id,Name,dmpl__NumericValue__c,dmpl__BooleanValue__c,dmpl__VisitTaskTemplateActivityId__c,dmpl__Status__c From dmpl__VisitTaskActivity__c LIMIT 1];
        List<dmpl__VisitTaskActivity__c> allVisitTaskActivities = [SELECT Id,Name,dmpl__NumericValue__c,dmpl__BooleanValue__c,dmpl__VisitTaskTemplateActivityId__c,dmpl__Status__c From dmpl__VisitTaskActivity__c];
        List<dmpl__VisitTaskTemplate__c> visit = [Select Id,Name From dmpl__VisitTaskTemplate__c LIMIT 1];
        dmpl__VisitTaskTemplateActivity__c visitTaskTemplateActivity = [SELECT Id,Name From dmpl__VisitTaskTemplateActivity__c];
        if(visit != null)
            update visit;
        VisitTaskActivityHelper.performRepeatAction(allVisitTaskActivities[0],visitTaskTemplateActivity,allVisitTaskActivities);
        VisitTaskActivityHelper.performVisibleAction(visitTaskActivity,visitTaskTemplateActivity,allVisitTaskActivities);
        VisitTaskActivityHelper.performEnabledAction(visitTaskActivity,visitTaskTemplateActivity,allVisitTaskActivities);
        VisitTaskActivityHelper.setStatusTimeStamps(allVisitTaskActivities,allVisitTaskActivities);
        System.assert(visit != null, 'Visit Data is Updated');
        test.stopTest();
    }	
    
    @isTest
    public static void updateTaskActivity()
    {
        test.startTest();
        List<dmpl__VisitTaskActivity__c> activity = [Select Id,Name From dmpl__VisitTaskActivity__c LIMIT 1];
        if(activity != null)
            update activity;
        System.assert(activity != null);
        test.stopTest();
    }
    
    @isTest
    public static void updateTaskTemplateEntry()
    {
        test.startTest();
        List<dmpl__VisitTaskTemplateEntry__c> activity = [Select Id,Name From dmpl__VisitTaskTemplateEntry__c LIMIT 1];
        if(activity != null)
            update activity;
        System.assert(activity != null);
        test.stopTest();
    }
    
    @isTest
    private static void VerifyHeadlessCallableMethod()
    {
        test.startTest();
        dmpl__VisitPlan__c plan = [Select Id,Name From dmpl__VisitPlan__c LIMIT 1];
        HeadlessCallableController.callHeadlessAction('headlessAction','dmpl__VisitPlan__c',plan.Id);
        HeadlessCallableController.callHeadlessAction('headlessAction2','dmpl__VisitPlan__c',plan.Id);
        test.stopTest();
    }
    
    @isTest
    private static void verifyData()
    {
        test.startTest();
        List<Object> testDataToUpdate = new List<Object>();
        Account account = [Select Id,Name,dmpl__IsCustomerAccount__c From Account WHERE dmpl__IsCustomerAccount__c = true LIMIT 1];
        Map<Object, Object> record1Data = new Map<Object, Object>();
        record1Data.put('Id', account.Id); 
        record1Data.put('Name', 'Updated Account Name');
        record1Data.put('dmpl__TimeValue__c','2023-10-05');     
        testDataToUpdate.add(record1Data);
       // try{
            Boolean success = VisitPlanController.postQueuedValues(testDataToUpdate);
            //VisitPlanController.createContentLink('uhvcwiu','iweiched');
            VisitPlanController.createContentVersion('uhvcwiu','iweiched');
       // }
       // catch(Exception e){
            
      //  }
    }
    
    @isTest
    private static void verifyData1()
    {
        test.startTest();
        List<Object> testDataToUpdate = new List<Object>();
        Account account = [Select Id,Name,dmpl__IsCustomerAccount__c From Account WHERE dmpl__IsCustomerAccount__c = true LIMIT 1];
        Map<Object, Object> record1Data = new Map<Object, Object>();
        record1Data.put('Id', account.Id); 
        record1Data.put('Name', 'Updated Account Name');
       // record1Data.put('dmpl__DateValue__c','2023-10-05');     
        testDataToUpdate.add(record1Data);
       // try{
            Boolean success = VisitPlanController.postQueuedValues(testDataToUpdate);
       // }
      //  catch(Exception e){
            
      //  }
    }
    @isTest
    private static void verifyData2()
    {
        test.startTest();
        List<Object> testDataToUpdate = new List<Object>();
        Account account = [Select Id,Name,dmpl__IsCustomerAccount__c From Account WHERE dmpl__IsCustomerAccount__c = true LIMIT 1];
        Map<Object, Object> record1Data = new Map<Object, Object>();
        decimal db=10.6;
        record1Data.put('Id', account.Id); 
        record1Data.put('Name', 'Updated Account Name');
        record1Data.put('dmpl__DateTimeValue__c','2023-10-05');     
        record1Data.put('dmpl__DateValue__c','2023-10-05');
        record1Data.put('dmpl__DecimalValue__c',db);     
        testDataToUpdate.add(record1Data);
      try{
            VisitPlanController.postQueuedValues(testDataToUpdate);
        }
        catch(Exception e){
        system.debug(e); 
        }
        test.stopTest();
    }
    
    @isTest
    static void testExecuteMethod() 
    {
        List<dmpl__VisitRoute__c> visitRoutes = [SELECT Id, dmpl__ResourceId__c, (SELECT Id, dmpl__AccountId__c FROM dmpl__VisitRouteStops__r) FROM dmpl__VisitRoute__c];
        VisitPlanProcessor batchJob = new VisitPlanProcessor('', null);

        Test.startTest();
        batchJob.execute(null, visitRoutes);
        Test.stopTest();

        List<dmpl__VisitPlan__c> visitPlans = [SELECT Id FROM dmpl__VisitPlan__c];
        System.assert(visitPlans.size() > 0, 'Visit Plans should be created');
        List<dmpl__Visit__c> visits = [SELECT Id FROM dmpl__Visit__c];
        System.assert(visits.size() > 0, 'Visits should be created');
    }

    private static void CreateAccount()
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
                                              dmpl__IsActive__c = true);
        insert customerAccount;
    }
    
    public static void CreateBranch()
    {
        Account partnerAccount = [SELECT Id,Name from Account where dmpl__IsPartnerAccount__c = TRUE LIMIT 1];
        dmpl__Branch__c testBranch = new dmpl__Branch__c(
            Name = 'Test Branch',
            dmpl__PartnerAccountId__c = partneraccount.Id,
            dmpl__GeoLocation__Latitude__s = 78.052235,
            dmpl__GeoLocation__Longitude__s = 38.243683
        );
        insert testBranch;
	}
    
    public static void CreateResouce()
    {
        dmpl__Branch__c testBranch = [SELECT Id,Name from dmpl__Branch__c LIMIT 1];
        dmpl__Resource__c testResource = new dmpl__Resource__c(
            Name = 'Test Resource',
            dmpl__DefaultBranchId__c = testBranch.Id  
        );
        insert testResource;
	}
    
    private static void CreateVisitRouteStop()
    {
        List<dmpl__VisitRouteStop__c> routeStop = new List<dmpl__VisitRouteStop__c>();
        Account act = [Select Id,Name From Account WHERE dmpl__IsCustomerAccount__c = True LIMIT 1];
        dmpl__VisitRoute__c route = [Select Id,name from dmpl__VisitRoute__c LIMIT 1];
        routeStop.add(new dmpl__VisitRouteStop__c(dmpl__AllowedGeofencingTolerance__c = 10,
                                                  dmpl__AccountId__c = act.Id,
                                                  dmpl__StartTime__c = time.newInstance(5, 20, 30, 60),
                                                  dmpl__EndTime__c = time.newInstance(25, 10, 50, 10),
                                                  dmpl__VisitPurpose__c = 'Order Capture',
                                                  dmpl__VisitRouteId__c = route.Id,
                                                  dmpl__SequenceNumber__c = 1,
												  dmpl__WeekNumbers__c = '2',
                                      			  dmpl__DayNumbers__c = '5'
                                                 ));
        insert routeStop;
    }
    
    private static void CreateVisits()
    {
        List<dmpl__Visit__c> visits = new List<dmpl__Visit__c>();
        Account act = [Select Id,Name From Account WHERE dmpl__IsCustomerAccount__c = True LIMIT 1];
        dmpl__VisitPlan__c plan = [Select Id,Name From dmpl__VisitPlan__c LIMIT 1];
        dmpl__VisitTaskTemplate__c template = [Select Id,Name from dmpl__VisitTaskTemplate__c LIMIT 1];
        visits.add(new dmpl__Visit__c(dmpl__SequenceNumber__c = 1,
                                      dmpl__GeofencingTolerance__c = 15,
                                      dmpl__AccountId__c = act.Id,
                                      dmpl__VisitTaskTemplateId__c = template.Id,
                                      //dmpl__PlannedDate__c = ,
                                      //dmpl__PlannedStartTime__c,
                                      //dmpl__PlannedEndTime__c,
                                      //dmpl__PlannedDuration__c,
                                      dmpl__DocumentDate__c = date.today(),
                                      dmpl__VisitPlanId__c = plan.Id,
                                      //dmpl__StartTime__c,
                                      //dmpl__EndTime__c,
                                      //dmpl__VisitDuration__c,
                                      //dmpl__VisitLocation__c,
                                      dmpl__VisitStatus__c = 'Planned'
                                      //dmpl__VisitTimeDeviation__c
                                     ));
        insert visits;
    }
    
    private static void CreateVisitRoutes()
    {
        List<dmpl__VisitRoute__c> routes = new List<dmpl__VisitRoute__c>();
        dmpl__AccountGroup__c actGroup = [Select Id,Name From dmpl__AccountGroup__c LIMIT 1];
        Account act = [Select Id,Name From Account WHERE dmpl__IsPartnerAccount__c = True LIMIT 1];
        dmpl__Resource__c resource = [Select Id From dmpl__Resource__c LIMIT 1];
        routes.add(New dmpl__VisitRoute__c(dmpl__PartnerAccountId__c = act.Id,
                                           dmpl__AccountGroupId__c = actGroup.Id,
                                           dmpl__ResourceId__c = resource.Id,
                                           dmpl__CoverageMidpointDistance__c = 10,
                                           dmpl__IsActive__c = true,
                                           dmpl__VisitPurpose__c = 'Order Capture',
                                           dmpl__RoutingPriority__c = 'Shortest Distance',
										   dmpl__WeekNumbers__c = '2',
                                      	   dmpl__DayNumbers__c = '5'
                                          ));
        insert routes;
    }
    
    private static void CreateVisitPlans()
    {
        List<dmpl__VisitPlan__c> plans = new List<dmpl__VisitPlan__c>();
        dmpl__VisitRoute__c route = [Select Id,name from dmpl__VisitRoute__c LIMIT 1];
        Account act = [Select Id,Name From Account WHERE dmpl__IsPartnerAccount__c = True LIMIT 1];
        dmpl__VisitTaskTemplate__c temp = [Select Id,Name From dmpl__VisitTaskTemplate__c LIMIT 1];
        plans.add(new dmpl__VisitPlan__c(dmpl__PartnerAccountId__c = act.Id,
                                         dmpl__Status__c = 'Task',
                                         dmpl__VisitPurpose__c = 'Order Capture',
                                         dmpl__VisitRouteId__c = route.Id,
                                         dmpl__VisitTaskTemplateId__c = temp.Id
                                        ));
        insert plans;
    }
    
    private static void CreateVisitTask()
    {
        List<dmpl__VisitTask__c> task = new List<dmpl__VisitTask__c>();
        dmpl__Visit__c visit = [Select Id,Name From dmpl__Visit__c LIMIT 1];
        dmpl__VisitTaskTemplateEntry__c entry = [Select Id,Name From dmpl__VisitTaskTemplateEntry__c LIMIT 1];
        task.add(new dmpl__VisitTask__c(dmpl__VisitId__c = visit.Id,
                                        dmpl__TaskType__c = 'Perform Visit Activities',
                                        dmpl__SequenceNumber__c = 1,
                                        dmpl__VisitTaskTemplateEntryId__c = entry.Id
                                       ));
        insert task;
    }
    
    private static void CreateVisitTaskTemplate()
    {
        List<dmpl__VisitTaskTemplate__c> taskTemplate = new List<dmpl__VisitTaskTemplate__c>();
        taskTemplate.add(new dmpl__VisitTaskTemplate__c(dmpl__Description__c = 'Visit Task Template1',
                                                        dmpl__Duration__c = 10,
                                                        Name = 'Task Template'
                                                       ));
        insert taskTemplate;
    }
    
    private static void CreateVisitTaskTemplateEntry()
    {
        List<dmpl__VisitTaskTemplateEntry__c> entry = new List<dmpl__VisitTaskTemplateEntry__c>();
        dmpl__VisitTaskTemplate__c task = [Select Id,Name From dmpl__VisitTaskTemplate__c LIMIT 1];
        entry.add(new dmpl__VisitTaskTemplateEntry__c(dmpl__TaskType__c = 'Perform Visit Activities',
                                                      dmpl__SequenceNumber__c = 1,
                                                      dmpl__VisitTaskTemplateId__c = task.Id
                                                     ));
        insert entry;
    }
    
    private static void CreateVisitTaskActivity()
    {
        List<dmpl__VisitTaskActivity__c> taskActivity = new List<dmpl__VisitTaskActivity__c>();
        dmpl__VisitTask__c task = [Select Id,Name from dmpl__VisitTask__c LIMIT 1];
        taskActivity.add(new dmpl__VisitTaskActivity__c(dmpl__VisitTaskId__c = task.Id,
                                                        dmpl__Status__c = 'Planned',
                                                        dmpl__NumericValue__c = 100,
                                                        dmpl__SequenceNumber__c = 1,
                                                        dmpl__PerformAutomatically__c = false,
                                                        dmpl__ActivityType__c = 'Record Text Value',
                                                        dmpl__URL__c = 'http://www.example.com'
                                                       ));
        insert taskActivity;
        system.debug('Activity: '+taskActivity);
    }
        
    private static void CreateVisitTaskTemplateActivity()
    {
        List<dmpl__VisitTaskTemplateActivity__c> taskActivity = new List<dmpl__VisitTaskTemplateActivity__c>();
        dmpl__VisitTaskTemplateEntry__c taskEntry = [Select Id,Name from dmpl__VisitTaskTemplateEntry__c LIMIT 1];
        taskActivity.add(new dmpl__VisitTaskTemplateActivity__c(dmpl__VisitTaskTemplateEntryId__c = taskEntry.Id,
                                                                dmpl__SequenceNumber__c = 2,
                                                                dmpl__PerformAutomatically__c = true,
                                                                dmpl__ActivityType__c = 'Record Text Value',
                                                                dmpl__ReportURL__c = 'http://www.example.com'
                                                               ));
        insert taskActivity;
    }
}