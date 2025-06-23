@isTest
private class VisitTaskTemplateHandler_Test {
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
    static void createVisitTaskTemplatePositive() {
        dmpl__VisitTaskTemplate__c taskTemplate = VisitPlanTestDataHelpers.getVisitTaskTemplate();
        if(taskTemplate != null) {
            System.assertNotEquals(taskTemplate, null, 'Expected Visit Task Template to be created.');
        }
        System.assertEquals(10, taskTemplate.dmpl__Duration__c, 'Expected Duration to be 10.');

        dmpl__VisitTaskTemplateEntry__c entry = VisitPlanTestDataHelpers.getVisitTaskTemplateEntry();
        if(entry != null) {
            System.assertNotEquals(entry, null, 'Expected Visit Task Template Entry to be created.');
        }
        System.assertEquals(1, entry.dmpl__SequenceNumber__c, 'Expected Sequence Number to be 1.');  
        
        dmpl__VisitTaskTemplateActivity__c taskTempActivity = VisitPlanTestDataHelpers.getVisitTaskTemplateActivity();
        if(taskTempActivity != null) {
            System.assertNotEquals(taskTempActivity, null, 'Expected Visit Task Template Activity to be created.');
        }
        System.assertEquals(false, taskTempActivity.dmpl__PerformAutomatically__c, 'Expected PerformAutomatically field to be false.');
        System.assertEquals(1, taskTempActivity.dmpl__SequenceNumber__c, 'Expected Sequence Number to be 1.'); 
    }

    @isTest
    static void updateVisitTaskTemplatePositive() {
        dmpl__VisitTaskTemplate__c taskTemplate = VisitPlanTestDataHelpers.getVisitTaskTemplate();
        System.assertNotEquals(taskTemplate, null, 'Visit Task Template should exist before update.');
        taskTemplate.dmpl__Duration__c = 20; 
        update taskTemplate;

        dmpl__VisitTaskTemplate__c updatedTaskTemplate = VisitPlanTestDataHelpers.getVisitTaskTemplate();
        System.assertEquals(20, updatedTaskTemplate.dmpl__Duration__c, 'Expected Duration to be updated to 20.');

        dmpl__VisitTaskTemplateEntry__c entry = VisitPlanTestDataHelpers.getVisitTaskTemplateEntry();
        System.assertNotEquals(entry, null, 'Visit Task Template Entry should exist before update.');
        entry.dmpl__SequenceNumber__c = 2;
        update entry;
        
        dmpl__VisitTaskTemplateEntry__c updatedEntry = VisitPlanTestDataHelpers.getVisitTaskTemplateEntry();
        System.assertEquals(2, updatedEntry.dmpl__SequenceNumber__c, 'Expected Sequence Number to be updated to 2.');

        dmpl__VisitTaskTemplateActivity__c taskTempActivity = VisitPlanTestDataHelpers.getVisitTaskTemplateActivity();
        System.assertNotEquals(taskTempActivity, null, 'Visit Task Template Activity should exist before update.');
        taskTempActivity.dmpl__PerformAutomatically__c = true;
        taskTempActivity.dmpl__SequenceNumber__c = 4;
        update taskTempActivity;

        dmpl__VisitTaskTemplateActivity__c updatedTaskTempActivity = VisitPlanTestDataHelpers.getVisitTaskTemplateActivity();
        System.assertEquals(true, updatedTaskTempActivity.dmpl__PerformAutomatically__c, 'Expected Perform Automatically to be true.');
        System.assertEquals(4, updatedTaskTempActivity.dmpl__SequenceNumber__c, 'Expected Sequence Number to be updated to 4.');
    }
}