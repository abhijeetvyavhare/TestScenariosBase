@isTest
private class VisitRouteGroupHandler_Test {
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
        dmpl__VisitRouteGroup__c routeGroup=VisitPlanTestDataHelpers.CreateVisitRouteGroup(partnerAccount,resource,branch);
    }
    
    @isTest
    static void createVisitRouteGroupPositive(){
        dmpl__VisitRouteGroup__c routeGroup=VisitPlanTestDataHelpers.getVisitRouteGroup();
        if(routeGroup !=null) {
            System.assertNotEquals(routeGroup, null, 'Expected Visit Route Group to be created.');
        }
        System.assertEquals( 'Order Delivery',routeGroup.dmpl__VisitPurpose__c, 'Expected Visit Purpose to be Order Delivery.');
    }

    @isTest
    static void updateVisitRouteGroupPositive(){
        dmpl__VisitRouteGroup__c routeGroup=VisitPlanTestDataHelpers.getVisitRouteGroup();
        System.assertNotEquals(routeGroup, null, 'Visit Route Group should exist before update.');
        routeGroup.dmpl__VisitPurpose__c='Field Service';
        update routeGroup;

        dmpl__VisitRouteGroup__c updatedRouteGroup = VisitPlanTestDataHelpers.getVisitRouteGroup();
        System.assertEquals( 'Field Service',updatedRouteGroup.dmpl__VisitPurpose__c, 'Expected Visit Purpose to be Field Service.');
    }
}