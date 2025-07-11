@isTest
private class VisitPlanHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Account partnerAccount = TestDataHelpers.createPartnerAccount();
        Account customerAccount = TestDataHelpers.createCustomerAccount();
        dmpl__AccountGroup__c AccountGroup = TestDataHelpers.createAccountGroup();      
        dmpl__Branch__c branch =TestDataHelpers.createBranch(partnerAccount);  
        dmpl__Resource__c resource =TestDataHelpers.createResource(partnerAccount,branch);  
        dmpl__ContactAddress__c contactAddress =TestDataHelpers.CreateContactAddress(customerAccount);
        dmpl__Item__c item =TestDataHelpers.createItem();
        dmpl__SKU__c sku =TestDataHelpers.createSKU(item);
        dmpl__VisitRoute__c route =VisitPlanTestDataHelpers.CreateVisitRoute(accountGroup,partnerAccount,resource);
        dmpl__VisitRouteStop__c routeStop=VisitPlanTestDataHelpers.CreateVisitRouteStop(customerAccount,route);
        dmpl__VisitTaskTemplate__c taskTemplate=VisitPlanTestDataHelpers.CreateVisitTaskTemplate('Temp1');
        dmpl__VisitPlan__c plans=VisitPlanTestDataHelpers.CreateVisitPlan(partnerAccount,route,taskTemplate);
        dmpl__Visit__c visits=VisitPlanTestDataHelpers.CreateVisit(customerAccount,plans,taskTemplate);
        dmpl__VisitTaskTemplateEntry__c entry=VisitPlanTestDataHelpers.CreateVisitTaskTemplateEntry(taskTemplate);
        dmpl__VisitTaskTemplateActivity__c taskTempActivity=VisitPlanTestDataHelpers.CreateVisitTaskTemplateActivity(entry);
        dmpl__VisitTask__c task=VisitPlanTestDataHelpers.CreateVisitTask(visits,entry);
        dmpl__VisitTaskActivity__c taskActivity=VisitPlanTestDataHelpers.CreateVisitTaskActivity(task);
        Account partnerAccount1 = TestDataHelpers.createPartnerAccount('Partner 1', false, true, false, true, 'MG Road', 'Bengaluru', 'Karnataka', 'India', '560001', '56 Industrial Layout', 'Bengaluru', 'Karnataka', 'India', '560095','9876543210');
        Account partnerAccount2 = TestDataHelpers.createPartnerAccount('Partner 2', false, true, false, false, '45 Residency Road', 'Pune', 'Maharashtra', 'India', '411001', '22 Commerce Avenue', 'Pune', 'Maharashtra', 'India', '411038','91-99665544433');
        Account partnerAccount6 = TestDataHelpers.createPartnerAccount('Partner 6', false, true, false, true, 'MS Road', 'Bengaluru','Karnataka', 'India', '560001', '56 Industrial Layout', 'Bengaluru', 'Karnataka', 'India','560095','9845543210');
        dmpl__Branch__c branch6 =TestDataHelpers.createBranch('Branch 6',partnerAccount6.Id,true,true,false,true);
        dmpl__Branch__c branch1=TestDataHelpers.createBranch('Branch 1', partnerAccount1.Id, true, true, false, true);
        dmpl__Branch__c branch3 = TestDataHelpers.createBranch('Branch 3', partnerAccount1.Id, false, true, true, false);
        dmpl__VisitPlan__c plan = VisitPlanTestDataHelpers.createVisitPlanNew(partnerAccount1,'Test Plan','Order Capture',Date.Today(),branch1);
        
    }
 
    @isTest
    static void createVisitPlanPositive() {
        dmpl__VisitPlan__c plans=VisitPlanTestDataHelpers.getVisitPlan();
        if(plans !=null) {
            System.assertNotEquals(plans, null, 'Expected Visit Plan to be created.');
        }
        System.assertEquals( 'Task',plans.dmpl__Status__c, 'Expected Status to be Task.');
        System.assertEquals( 'Order Capture',plans.dmpl__VisitPurpose__c, 'Expected Visit Purpose to be Order Capture.');
       
        dmpl__Visit__c visits=VisitPlanTestDataHelpers.getVisit();
        if(visits!=null) {
            System.assertNotEquals(visits, null, 'Expected Visit to be created.');
        }
        System.assertEquals( 1,visits.dmpl__SequenceNumber__c, 'Expected Sequence no. to be 1.');
       
        dmpl__VisitTask__c task=VisitPlanTestDataHelpers.getVisitTask();
        if(task!=null) {
            System.assertNotEquals(task, null, 'Expected Visit Task to be created.');
        }
        System.assertEquals( 5,task.dmpl__SequenceNumber__c, 'Expected Sequence no. to be 5.');
        System.assertEquals( 'Planned',task.dmpl__Status__c, 'Expected Status to be Planned.');
       
        dmpl__VisitTaskActivity__c taskActivity=VisitPlanTestDataHelpers.getVisitTaskActivity();
        System.debug(taskActivity);
        if(taskActivity!=null) {
            System.assertNotEquals(taskActivity, null, 'Expected Visit Task Activity to be created.');
        }
        System.assertEquals(1,taskActivity.dmpl__SequenceNumber__c, 'Expected Sequence no. here also to be 1.');
        System.assertEquals(true,taskActivity.dmpl__PerformAutomatically__c, 'Expected Perform Automatically to be false.');
        System.assertEquals('http://www.example.com', taskActivity.dmpl__URL__c, 'URL mismatch');
    }
 
    @isTest
    static void updateVisitPlanPositive() {
        dmpl__VisitPlan__c plans=VisitPlanTestDataHelpers.getVisitPlan();
        System.assertNotEquals(plans, null, 'Visit Plan should exist before update.');
        plans.dmpl__Status__c = 'Completed';
        plans.dmpl__VisitPurpose__c = 'Order Delivery';
        update plans;
 
        dmpl__VisitPlan__c updatedPlans = VisitPlanTestDataHelpers.getVisitPlan();
        System.assertEquals( 'Completed',updatedPlans.dmpl__Status__c, 'Expected Status to be Completed.');  
        System.assertEquals( 'Order Delivery',updatedPlans.dmpl__VisitPurpose__c, 'Expected Visit Purpose to be Order Delivery.');
       
        dmpl__Visit__c visits=VisitPlanTestDataHelpers.getVisit();
        System.assertNotEquals(visits, null, 'Visit should exist before update.');
        visits.dmpl__SequenceNumber__c = 2;
        visits.dmpl__VisitStatus__c = 'Assigned';
        update visits;
       
        dmpl__Visit__c updatedVisits=VisitPlanTestDataHelpers.getVisit();
        System.assertEquals( 2,updatedVisits.dmpl__SequenceNumber__c, 'Expected Sequence no. to be 2.');  
        System.assertEquals( 'Assigned',updatedVisits.dmpl__VisitStatus__c, 'Expected Visit Status to be Assigned.');
       
        dmpl__VisitTask__c task=VisitPlanTestDataHelpers.getVisitTask();
        System.assertNotEquals(task, null, 'Visit Task should exist before update.');
        task.dmpl__SequenceNumber__c = 6;
        task.dmpl__Status__c='Started';
        update task;
       
        dmpl__VisitTask__c updatedTask=VisitPlanTestDataHelpers.getVisitTask();
        System.assertEquals( 6,updatedTask.dmpl__SequenceNumber__c, 'Expected Sequence no. to be 6.');  
        System.assertEquals( 'Started',updatedTask.dmpl__Status__c, 'Expected Status to be Started.');
       
        dmpl__VisitTaskActivity__c taskActivity=VisitPlanTestDataHelpers.getVisitTaskActivity();
        System.assertNotEquals(taskActivity, null, 'Visit Task Activity should exist before update.');
        taskActivity.dmpl__SequenceNumber__c=11;
        taskActivity.dmpl__PerformAutomatically__c=true;
        update taskActivity;
       
        dmpl__VisitTaskActivity__c updatedTaskActivity=VisitPlanTestDataHelpers.getVisitTaskActivity();
        System.assertEquals(11,updatedTaskActivity.dmpl__SequenceNumber__c, 'Expected Sequence no. to be 11.');
        System.assertEquals(true,updatedTaskActivity.dmpl__PerformAutomatically__c, 'Expected Perform Automatically to be true.');
    }
 
    @isTest
    static void createVisitPlanWithActivePartnerPositive() {
        Account partnerAccount1 = TestDataHelpers.createPartnerAccount('Partner 1', false, true, false, true, 'MG Road', 'Bengaluru', 'Karnataka', 'India', '560001', '56 Industrial Layout', 'Bengaluru', 'Karnataka', 'India', '560095','9876543210');
        dmpl__Branch__c branch1=TestDataHelpers.createBranch('Branch 1', partnerAccount1.Id, true, true, false, true);
 
        dmpl__VisitPlan__c plan = VisitPlanTestDataHelpers.createVisitPlanNew(partnerAccount1,'Test Plan','Order Capture',Date.Today(),branch1);
        Test.startTest();
        dmpl__VisitPlan__c fetchedPlan = VisitPlanTestDataHelpers.getVisitPlanNew(plan.Id);
        Test.stopTest();
 
     
        System.assertEquals('Test Plan', fetchedPlan.Name, 'Plan Name should match.');
        System.assertEquals('Order Capture', fetchedPlan.dmpl__VisitPurpose__c, 'Visit Purpose should match.');
        System.assertEquals(Date.today(), fetchedPlan.dmpl__PlanStartDate__c, 'Plan Start Date should be today.');
    }
 
    @isTest
        static void createVisitPlanWithInactivePartnerNegative() {
        Test.startTest();
 
        Account inactivePartner = TestDataHelpers.getPartnerAccount('Partner 2');
        dmpl__Branch__c branch = TestDataHelpers.getBranch();
 
        try {
            dmpl__VisitPlan__c plan = VisitPlanTestDataHelpers.createVisitPlanNew(
                inactivePartner,
                'Test Plan',
                'Order Capture',
                Date.today(),
                branch
            );
            System.assert(false, 'Expected exception for inactive partner account.');
        } catch (Exception e) {
            System.debug('Expected exception: ' + e.getMessage());
            System.assert(
                e.getMessage().containsIgnoreCase('inactive') ||
                e.getMessage().containsIgnoreCase('cannot create'),
                'Error should mention inactive partner or restriction.'
            );
        }
 
        Test.stopTest();
    }
 
 
    @isTest
        static void createVisitPlanWithWrongBranchNegative() {
        Test.startTest();
        Account partnerAccount = TestDataHelpers.getPartnerAccount();
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 3');
 
        try {
            dmpl__VisitPlan__c plan = VisitPlanTestDataHelpers.createVisitPlanNew(
                partnerAccount,
                'Test Plan',
                'Order Capture',
                Date.today(),
                branch
            );
            System.assert(false, 'Expected exception for inactive partner account.');
        } catch (Exception e) {
            System.debug('Expected exception: ' + e.getMessage());
            System.assert(
                e.getMessage().containsIgnoreCase('inactive') ||
                e.getMessage().containsIgnoreCase('cannot create'),
                'Error should mention inactive partner or restriction.'
            );
        }
 
    }
    @isTest
    static void createVisitPlanWithActiveBranchPositive() {
        Account partnerAccount1 = TestDataHelpers.createPartnerAccount('Partner 6', false, true, false, true, 'MS Road', 'Bengaluru','Karnataka', 'India', '560001', '56 Industrial Layout', 'Bengaluru', 'Karnataka', 'India','560095','9845543210');
        dmpl__Branch__c branch6 =TestDataHelpers.createBranch('Branch 6',partnerAccount1.Id,true,true,false,true);
  
        dmpl__VisitPlan__c plan = VisitPlanTestDataHelpers.createVisitPlanNew(partnerAccount1,'Test Plan','Order Capture',Date.Today(),branch6);
        Test.startTest();
        dmpl__VisitPlan__c fetchedPlan = VisitPlanTestDataHelpers.getVisitPlanNew(plan.Id);
        Test.stopTest();
 
     
        System.assertEquals('Test Plan', fetchedPlan.Name, 'Plan Name should match.');
        System.assertEquals('Order Capture', fetchedPlan.dmpl__VisitPurpose__c, 'Visit Purpose should match.');
        System.assertEquals(Date.today(), fetchedPlan.dmpl__PlanStartDate__c, 'Plan Start Date should be today.');
    }
    @isTest
        static void createVisitPlanWithInactiveBranchNegative() {
        Test.startTest();
         Account partnerAccount = TestDataHelpers.getPartnerAccount();
        dmpl__Branch__c branch3 = TestDataHelpers.createBranch('Branch 3', partnerAccount.Id, false, true, true, false);
 
 
        try {
            dmpl__VisitPlan__c plan = VisitPlanTestDataHelpers.createVisitPlanNew(
                partnerAccount,
                'Test Plan',
                'Order Capture',
                Date.today(),
                branch3
            );
            System.assert(false, 'Expected exception for inactive partner account.');
        } catch (Exception e) {
            System.debug('Expected exception: ' + e.getMessage());
            System.assert(
                e.getMessage().containsIgnoreCase('inactive') ||
                e.getMessage().containsIgnoreCase('cannot create'),
                'Error should mention inactive partner or restriction.'
            );
        }
 
    }
 
    @isTest
        static void createVisitPlanWithPlanNamePositive() {
            Account partnerAccount1 = TestDataHelpers.createPartnerAccount('Partner 1', false, true, false, true, 'MG Road', 'Bengaluru', 'Karnataka', 'India', '560001', '56 Industrial Layout', 'Bengaluru', 'Karnataka', 'India', '560095','9876543210');
            dmpl__Branch__c branch1=TestDataHelpers.createBranch('Branch 1', partnerAccount1.Id, true, true, false, true);
 
            dmpl__VisitPlan__c plan = VisitPlanTestDataHelpers.createVisitPlanNew(partnerAccount1,'Test Plan','Order Capture',Date.Today(),branch1);
            Test.startTest();
            dmpl__VisitPlan__c fetchedPlan = VisitPlanTestDataHelpers.getVisitPlanNew(plan.Id);
            Test.stopTest();
 
       
            System.assertEquals('Test Plan', fetchedPlan.Name, 'Plan Name should match.');
            System.assertEquals('Order Capture', fetchedPlan.dmpl__VisitPurpose__c, 'Visit Purpose should match.');
            System.assertEquals(Date.today(), fetchedPlan.dmpl__PlanStartDate__c, 'Plan Start Date should be today.');
        }
       
    @isTest
        static void createVisitPlanWithoutPlanNameNegative() {
        Test.startTest();
 
        Account partnerAccount6 = TestDataHelpers.createPartnerAccount('Partner 6', false, true, false, true, 'MS Road', 'Bengaluru','Karnataka', 'India', '560001', '56 Industrial Layout', 'Bengaluru', 'Karnataka', 'India','560095','9845543210');
        dmpl__Branch__c branch6 =TestDataHelpers.createBranch('Branch 6',partnerAccount6.Id,true,true,false,true);
 
        try {
            dmpl__VisitPlan__c plan = VisitPlanTestDataHelpers.createVisitPlanNew(
                partnerAccount6,
                null,
                'Order Capture',
                Date.today(),
                branch6
            );
            System.assert(false, 'Expected exception for inactive partner account.');
        } catch (Exception e) {
            System.debug('Expected exception: ' + e.getMessage());
            System.assert(
                e.getMessage().containsIgnoreCase('inactive') ||
                e.getMessage().containsIgnoreCase('cannot create'),
                'Error should mention inactive partner or restriction.'
            );
        }
 
    }
 
    @isTest
        static void createVisitPlanWithTaskTemplatePositive() {
            Account partnerAccount = TestDataHelpers.getPartnerAccount();
            dmpl__Branch__c branch= TestDataHelpers.getBranch();
            dmpl__VisitPlan__c plan = VisitPlanTestDataHelpers.createVisitPlanNew(partnerAccount,'Test Plan','Order Capture',Date.Today(),branch);
            Test.startTest();
            dmpl__VisitPlan__c fetchedPlan = VisitPlanTestDataHelpers.getVisitPlanNew(plan.Id);
            Test.stopTest();
 
       
            System.assertEquals('Test Plan', fetchedPlan.Name, 'Plan Name should match.');
            System.assertEquals('Order Capture', fetchedPlan.dmpl__VisitPurpose__c, 'Visit Purpose should match.');
            System.assertEquals(Date.today(), fetchedPlan.dmpl__PlanStartDate__c, 'Plan Start Date should be today.');
        }
 
    @isTest
        static void createVisitPlanWithoutVisitTaskTemplatePositive() {
             Account partnerAccount = TestDataHelpers.getPartnerAccount();
             dmpl__Branch__c branch = TestDataHelpers.getBranch();
            dmpl__VisitPlan__c plan = VisitPlanTestDataHelpers.createVisitPlanNew(partnerAccount,'Test Plan','Order Capture',Date.Today(),branch);
            Test.startTest();
            dmpl__VisitPlan__c fetchedPlan = VisitPlanTestDataHelpers.getVisitPlanNew(plan.Id);
            Test.stopTest();
 
       
            System.assertEquals('Test Plan', fetchedPlan.Name, 'Plan Name should match.');
            System.assertEquals('Order Capture', fetchedPlan.dmpl__VisitPurpose__c, 'Visit Purpose should match.');
            System.assertEquals(Date.today(), fetchedPlan.dmpl__PlanStartDate__c, 'Plan Start Date should be today.');
        }
 
       
    @isTest
        static void createVisitPlanWithVisitPositive() {
             Account partnerAccount = TestDataHelpers.getPartnerAccount();
               dmpl__Branch__c branch1 = TestDataHelpers.getBranch();
            dmpl__VisitPlan__c plan = VisitPlanTestDataHelpers.createVisitPlanNew(partnerAccount,'Test Plan','Order Capture',Date.Today(),branch1);
            Test.startTest();
            dmpl__VisitPlan__c fetchedPlan = VisitPlanTestDataHelpers.getVisitPlanNew(plan.Id);
            Test.stopTest();
 
       
            System.assertEquals('Test Plan', fetchedPlan.Name, 'Plan Name should match.');
            System.assertEquals(Date.today(), fetchedPlan.dmpl__PlanStartDate__c, 'Plan Start Date should be today.');
        }
 
       
    @isTest
        static void createVisitPlanWithVisitPurposePositive() {
             Account partnerAccount = TestDataHelpers.getPartnerAccount();
             dmpl__Branch__c branch = TestDataHelpers.getBranch();
            dmpl__VisitPlan__c plan = VisitPlanTestDataHelpers.createVisitPlanNew(partnerAccount,'Test Plan 2','Order Capture',Date.Today(),branch);
            Test.startTest();
            dmpl__VisitPlan__c fetchedPlan = VisitPlanTestDataHelpers.getVisitPlanNew(plan.Id);
            Test.stopTest();
 
       
            System.assertEquals('Test Plan 2', fetchedPlan.Name, 'Plan Name should match.');
            System.assertEquals('Order Capture', fetchedPlan.dmpl__VisitPurpose__c, 'Visit Purpose should match.');
            System.assertEquals(Date.today(), fetchedPlan.dmpl__PlanStartDate__c, 'Plan Start Date should be today.');
        }
 
    @isTest
    static void createVisitRouteWithActivePartnerAccountPositive() {
        Account partnerAccount = TestDataHelpers.getPartnerAccount();
        dmpl__AccountGroup__c accountGroup = TestDataHelpers.getAccountGroup();
        dmpl__VisitTaskTemplate__c taskTemplate=VisitPlanTestDataHelpers.CreateVisitTaskTemplate('Temp1');
       
        dmpl__VisitRoute__c route =VisitPlanTestDataHelpers.CreateVisitRoute(accountGroup,partnerAccount,taskTemplate);
 
        system.assertEquals(accountGroup.id, route.dmpl__AccountGroupId__c,'should match');
        system.assertEquals(partnerAccount.id, route.dmpl__PartnerAccountId__c,'should match');
        system.assertEquals(taskTemplate.id, route.dmpl__VisitTaskTemplateId__c,'should match');
       
    }
 
    @isTest
        static void createVisitRouteWithInactivePartnerAccountNegative() {
            Test.startTest();
            try {
                Account inactivePartner = TestDataHelpers.getPartnerAccount('Partner 2');
    
                dmpl__AccountGroup__c accountGroup = TestDataHelpers.getAccountGroup();
                dmpl__VisitTaskTemplate__c taskTemplate = VisitPlanTestDataHelpers.CreateVisitTaskTemplate('Temp1');
    
                dmpl__VisitRoute__c route = VisitPlanTestDataHelpers.CreateVisitRoute(accountGroup, inactivePartner, taskTemplate);
                System.assert(false, 'Expected an exception when creating route with inactive partner.');
            } catch (Exception e) {
                System.debug('Expected exception: ' + e.getMessage());
    
                System.assert(
                    e.getMessage().toLowerCase().contains('inactive') ||
                    e.getMessage().toLowerCase().contains('not allowed') ||
                    e.getMessage().toLowerCase().contains('cannot create'),
                    'Exception should mention inactive partner restriction.'
                );
            }
            Test.stopTest();
        }

    @isTest
        static void testVisitRouteStopCreationWithActiveAccountPositive() {
            Account partnerAccount = TestDataHelpers.createPartnerAccount();
            Account customerAccount = TestDataHelpers.createCustomerAccount();
            dmpl__AccountGroup__c accountGroup = TestDataHelpers.createAccountGroup();      
            dmpl__Branch__c branch = TestDataHelpers.createBranch(partnerAccount);  
            dmpl__Resource__c resource = TestDataHelpers.createResource(partnerAccount, branch);  
            dmpl__VisitRoute__c route = VisitPlanTestDataHelpers.CreateVisitRoute(accountGroup, partnerAccount, resource);

            dmpl__VisitRouteStop__c routeStop = VisitPlanTestDataHelpers.CreateVisitRouteStop(customerAccount, route);
            System.assertNotEquals(null, routeStop.Id, 'Route Stop should be inserted');
            System.assertEquals(route.Id, routeStop.dmpl__VisitRouteId__c, 'Route Stop should be linked to the correct Visit Route');
            System.assertEquals(customerAccount.Id, routeStop.dmpl__AccountId__c, 'Route Stop should be linked to the correct Account');
    }

    @isTest
        static void testVisitRouteStopCreationWithInactiveAccountNegative() {
            Test.startTest();
            try {
            
                Account inactiveCustomer = TestDataHelpers.getPartnerAccount('Partner 2');
                Account partnerAccount = TestDataHelpers.createPartnerAccount();
                dmpl__AccountGroup__c accountGroup = TestDataHelpers.createAccountGroup();      
                dmpl__Branch__c branch = TestDataHelpers.createBranch(partnerAccount);  
                dmpl__Resource__c resource = TestDataHelpers.createResource(partnerAccount, branch);  

                dmpl__VisitRoute__c route = VisitPlanTestDataHelpers.CreateVisitRoute(accountGroup, partnerAccount, resource);

                dmpl__VisitRouteStop__c routeStop = VisitPlanTestDataHelpers.CreateVisitRouteStop(inactiveCustomer, route);

                System.assert(false, 'Expected an exception when creating Visit Route Stop with inactive account.');

            } catch (Exception e) {
            
                System.debug('Expected exception: ' + e.getMessage());

                System.assert(
                    e.getMessage().toLowerCase().contains('inactive') ||
                    e.getMessage().toLowerCase().contains('not allowed') ||
                    e.getMessage().toLowerCase().contains('cannot create'),
                    'Exception should mention inactive account restriction.'
                );
            }
            Test.stopTest();
        }

    
    @isTest
        static void testVisitRouteStopCreationWithVisitPurposePositive() {
            Test.startTest();

            Account partnerAccount = TestDataHelpers.createPartnerAccount();
            Account customerAccount = TestDataHelpers.createCustomerAccount();

            dmpl__AccountGroup__c accountGroup = TestDataHelpers.createAccountGroup();      
            dmpl__Branch__c branch = TestDataHelpers.createBranch(partnerAccount);  
            dmpl__Resource__c resource = TestDataHelpers.createResource(partnerAccount, branch); 
            dmpl__VisitRoute__c route = VisitPlanTestDataHelpers.CreateVisitRoute(accountGroup, partnerAccount, resource);
            dmpl__VisitRouteStop__c routeStop = VisitPlanTestDataHelpers.CreateVisitRouteStop(customerAccount, route);

            Test.stopTest();
            System.assertNotEquals(null, routeStop.Id, 'Route Stop should be inserted');
            System.assertEquals(route.Id, routeStop.dmpl__VisitRouteId__c, 'Route Stop should be linked to the correct Visit Route');
            System.assertEquals(customerAccount.Id, routeStop.dmpl__AccountId__c, 'Route Stop should be linked to the correct Customer Account');
            System.assertEquals('Order Capture', routeStop.dmpl__VisitPurpose__c, 'Visit Purpose should be set to Order Capture');
        }

    @isTest
        static void testVisitRouteStopCreationWithoutVisitPurposePositive() {
            Test.startTest();

            Account partnerAccount = TestDataHelpers.createPartnerAccount();
            Account customerAccount = TestDataHelpers.createCustomerAccount();

            dmpl__AccountGroup__c accountGroup = TestDataHelpers.createAccountGroup();      
            dmpl__Branch__c branch = TestDataHelpers.createBranch(partnerAccount);  
            dmpl__Resource__c resource = TestDataHelpers.createResource(partnerAccount, branch); 
            dmpl__VisitRoute__c route = VisitPlanTestDataHelpers.CreateVisitRoute(accountGroup, partnerAccount, resource);
            dmpl__VisitRouteStop__c routeStop = VisitPlanTestDataHelpers.CreateVisitRouteStop(customerAccount, route);

            Test.stopTest();
            System.assertNotEquals(null, routeStop.Id, 'Route Stop should be inserted');
            System.assertEquals(route.Id, routeStop.dmpl__VisitRouteId__c, 'Route Stop should be linked to the correct Visit Route');
            System.assertEquals(customerAccount.Id, routeStop.dmpl__AccountId__c, 'Route Stop should be linked to the correct Customer Account');
            System.assertEquals('Order Capture', routeStop.dmpl__VisitPurpose__c, 'Visit Purpose should be set to Order Capture');
        }

        @isTest
            static void testVisitRouteStopCreationWithVisitTaskTemplatePositive() {
                Test.startTest();
                Account partnerAccount = TestDataHelpers.createPartnerAccount();
                Account customerAccount = TestDataHelpers.createCustomerAccount();
                dmpl__AccountGroup__c accountGroup = TestDataHelpers.createAccountGroup();      
                dmpl__Branch__c branch = TestDataHelpers.createBranch(partnerAccount);  
                dmpl__Resource__c resource = TestDataHelpers.createResource(partnerAccount, branch); 
                dmpl__VisitTaskTemplate__c taskTemplate = VisitPlanTestDataHelpers.CreateVisitTaskTemplate('Order Capturing');
                dmpl__VisitRoute__c route = VisitPlanTestDataHelpers.CreateVisitRoute(accountGroup, partnerAccount, resource);
                dmpl__VisitRouteStop__c routeStop = VisitPlanTestDataHelpers.CreateVisitRouteStopWithTaskTemplate(customerAccount, route, taskTemplate);

                Test.stopTest();
                System.assertNotEquals(null, routeStop.Id, 'Route Stop should be inserted');
                System.assertEquals(route.Id, routeStop.dmpl__VisitRouteId__c, 'Should be linked to correct Visit Route');
                System.assertEquals(customerAccount.Id, routeStop.dmpl__AccountId__c, 'Should be linked to correct Customer Account');
                System.assertEquals(taskTemplate.Id, routeStop.dmpl__VisitTaskTemplateId__c, 'Should be linked to correct Visit Task Template');
                System.assertEquals('Order Capture', routeStop.dmpl__VisitPurpose__c, 'Visit Purpose should be set correctly');
            }

        @isTest
            static void testVisitRouteStopCreationWithoutVisitTaskTemplatePositive() {
                Test.startTest();
                Account partnerAccount = TestDataHelpers.createPartnerAccount();
                Account customerAccount = TestDataHelpers.createCustomerAccount();
                dmpl__AccountGroup__c accountGroup = TestDataHelpers.createAccountGroup();      
                dmpl__Branch__c branch = TestDataHelpers.createBranch(partnerAccount);  
                dmpl__Resource__c resource = TestDataHelpers.createResource(partnerAccount, branch); 
                dmpl__VisitRoute__c route = VisitPlanTestDataHelpers.CreateVisitRoute(accountGroup, partnerAccount, resource);
                dmpl__VisitRouteStop__c routeStop = VisitPlanTestDataHelpers.CreateVisitRouteStop(customerAccount, route);

                Test.stopTest();
                System.assertNotEquals(null, routeStop.Id, 'Route Stop should be inserted');
                System.assertEquals(route.Id, routeStop.dmpl__VisitRouteId__c, 'Should be linked to correct Visit Route');
                System.assertEquals(customerAccount.Id, routeStop.dmpl__AccountId__c, 'Should be linked to correct Customer Account');
                System.assertEquals(null, routeStop.dmpl__VisitTaskTemplateId__c, 'Visit Task Template should be blank');
                System.assertEquals('Order Capture', routeStop.dmpl__VisitPurpose__c, 'Visit Purpose should be set to Order Capture');
            }

        @isTest
            static void testVisitRouteStopCreationWithVisitRoutePositive() {
                Test.startTest();
                Account partnerAccount = TestDataHelpers.createPartnerAccount();
                Account customerAccount = TestDataHelpers.createCustomerAccount();
                dmpl__AccountGroup__c accountGroup = TestDataHelpers.createAccountGroup();      
                dmpl__Branch__c branch = TestDataHelpers.createBranch(partnerAccount);  
                dmpl__Resource__c resource = TestDataHelpers.createResource(partnerAccount, branch); 
                dmpl__VisitRoute__c route = VisitPlanTestDataHelpers.CreateVisitRoute(accountGroup, partnerAccount, resource);
                dmpl__VisitRouteStop__c routeStop = VisitPlanTestDataHelpers.CreateVisitRouteStop(customerAccount, route);

                Test.stopTest();
                System.assertNotEquals(null, routeStop.Id, 'Route Stop should be inserted');
                System.assertEquals(route.Id, routeStop.dmpl__VisitRouteId__c, 'Should be linked to correct Visit Route');
                System.assertEquals(customerAccount.Id, routeStop.dmpl__AccountId__c, 'Should be linked to correct Customer Account');
                System.assertEquals(null, routeStop.dmpl__VisitTaskTemplateId__c, 'Visit Task Template should be blank');
                System.assertEquals('Order Capture', routeStop.dmpl__VisitPurpose__c, 'Visit Purpose should be set to Order Capture');
            }

        @isTest
            static void testVisitRouteStopCreationWithoutVisitRouteNegative() {
                Test.startTest();
                try {
                    Account customer = TestDataHelpers.createCustomerAccount();
                    VisitPlanTestDataHelpers.CreateVisitRouteStop(customer, null);

                    System.assert(false, 'Expected exception when Visit Route is null');
                } catch (Exception e) {
                    System.debug('Expected exception: ' + e.getMessage());
                    System.assert(
                        e.getMessage().toLowerCase().contains('route') ||
                        e.getMessage().toLowerCase().contains('null'),
                        'Exception should indicate missing Visit Route'
                    );
                }
                Test.stopTest();
            }

        @isTest
            static void testVisitRouteStopCreationWithStopNamePositive() {
                Test.startTest();

                Account partnerAccount = TestDataHelpers.createPartnerAccount();
                dmpl__AccountGroup__c accountGroup = TestDataHelpers.createAccountGroup();      
                dmpl__Branch__c branch = TestDataHelpers.createBranch(partnerAccount);  
                dmpl__Resource__c resource = TestDataHelpers.createResource(partnerAccount, branch); 
                dmpl__VisitRoute__c route = VisitPlanTestDataHelpers.CreateVisitRoute(accountGroup, partnerAccount, resource);
                dmpl__VisitRouteStop__c routeStop = VisitPlanTestDataHelpers.CreateVisitRouteStopWithNameOnly('Amar Tech Park', route);

                Test.stopTest();

                System.assertNotEquals(null, routeStop.Id, 'Route Stop should be inserted');
                System.assertEquals('Amar Tech Park', routeStop.Name, 'Route Stop name should be "Amar Tech Park"');
                System.assertEquals(route.Id, routeStop.dmpl__VisitRouteId__c, 'Should be linked to the correct Visit Route');
                System.assertEquals(null, routeStop.dmpl__AccountId__c, 'Account should be blank');
                System.assertEquals(null, routeStop.dmpl__VisitTaskTemplateId__c, 'Visit Task Template should be blank');
                System.assertEquals(null, routeStop.dmpl__VisitPurpose__c, 'Visit Purpose should be blank');
            }

        @isTest
            static void testVisitRouteStopCreationWithStopNameNegative() {
                Test.startTest();
                try {
                    Account partnerAccount = TestDataHelpers.createPartnerAccount();
                    dmpl__AccountGroup__c accountGroup = TestDataHelpers.createAccountGroup();      
                    dmpl__Branch__c branch = TestDataHelpers.createBranch(partnerAccount);  
                    dmpl__Resource__c resource = TestDataHelpers.createResource(partnerAccount, branch);  
                    dmpl__VisitRoute__c route = VisitPlanTestDataHelpers.CreateVisitRoute(accountGroup, partnerAccount, resource);
                    VisitPlanTestDataHelpers.CreateVisitRouteStopWithNameOnly(null, route);

                    System.assert(false, 'Expected exception when Stop Name is blank');

                } catch (Exception e) {
                    System.debug('Expected exception: ' + e.getMessage());

                    System.assert(
                        e.getMessage().toLowerCase().contains('name') ||
                        e.getMessage().toLowerCase().contains('stop') ||
                        e.getMessage().toLowerCase().contains('required') ||
                        e.getMessage().toLowerCase().contains('review fields'),
                        'Exception should mention missing or blank stop name'
                    );
                }
                Test.stopTest();
            }

 
 
 
 
}