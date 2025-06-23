@isTest
private class VisitRouteHandler_Test {
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
        dmpl__VisitTaskTemplate__c taskTemplate=VisitPlanTestDataHelpers.CreateVisitTaskTemplate();
        dmpl__VisitPlan__c plans=VisitPlanTestDataHelpers.CreateVisitPlan(partnerAccount,route,taskTemplate);
        dmpl__Visit__c visits=VisitPlanTestDataHelpers.CreateVisit(customerAccount,plans,taskTemplate);
        dmpl__VisitTaskTemplateEntry__c entry=VisitPlanTestDataHelpers.CreateVisitTaskTemplateEntry(taskTemplate);
        dmpl__VisitTaskTemplateActivity__c taskTempActivity=VisitPlanTestDataHelpers.CreateVisitTaskTemplateActivity(entry);
        dmpl__VisitTask__c task=VisitPlanTestDataHelpers.CreateVisitTask(visits,entry);
        dmpl__VisitTaskActivity__c taskActivity=VisitPlanTestDataHelpers.CreateVisitTaskActivity(task);
    }
    @isTest
    static void createVisitRoutePositive() {
        dmpl__VisitRoute__c route = VisitPlanTestDataHelpers.getVisitRoute();
        if(route !=null) {
            System.assertNotEquals(route, null, 'Expected Visit Route to be created.');
        }
        System.assertEquals(10,route.dmpl__CoverageMidpointDistance__c, 'Expected Cov. mid pt. distance to be 10.');
        System.assertEquals( 'Order Capture',route.dmpl__VisitPurpose__c, 'Expected Visit Purpose to be Order Capture.');

        dmpl__VisitRouteStop__c routeStop = VisitPlanTestDataHelpers.getVisitRouteStop();
        if(routeStop !=null) {
            System.assertNotEquals(routeStop, null, 'Expected Visit Route Stop to be created.');
        }
        System.assertEquals(10,routeStop.dmpl__AllowedGeofencingTolerance__c, 'Expected Geoefencing Tolerance to be 10.');
        System.assertEquals( 1,routeStop.dmpl__SequenceNumber__c, 'Expected Sequence Number to be 1.');
    }

    @isTest
    static void updateVisitRoutePositive() {
        dmpl__VisitRoute__c route = VisitPlanTestDataHelpers.getVisitRoute();
        System.assertNotEquals(route, null, 'Visit Route should exist before update.');
        route.dmpl__CoverageMidpointDistance__c = 20;
        route.dmpl__VisitPurpose__c = 'Order Delivery';
        update route;

        dmpl__VisitRoute__c updatedRoute = VisitPlanTestDataHelpers.getVisitRoute();
        System.assertEquals(20,updatedRoute.dmpl__CoverageMidpointDistance__c, 'Expected Cov. mid pt. distance to be 20.');  
        System.assertEquals( 'Order Delivery',updatedRoute.dmpl__VisitPurpose__c, 'Expected Visit Purpose to be Order Delivery.');

        dmpl__VisitRouteStop__c routeStop = VisitPlanTestDataHelpers.getVisitRouteStop();
        System.assertNotEquals(routeStop, null, 'Visit Route Stop should exist before update.');
        routeStop.dmpl__AllowedGeofencingTolerance__c = 15;
        routeStop.dmpl__SequenceNumber__c = 2;
        update routeStop;
        dmpl__VisitRouteStop__c updatedRouteStop = VisitPlanTestDataHelpers.getVisitRouteStop();
        System.assertEquals(15,updatedRouteStop.dmpl__AllowedGeofencingTolerance__c, 'Expected Geoefencing Tolerance to be 15.');
        System.assertEquals( 2,updatedRouteStop.dmpl__SequenceNumber__c, 'Expected Sequence Number to be 2.');
    }
}