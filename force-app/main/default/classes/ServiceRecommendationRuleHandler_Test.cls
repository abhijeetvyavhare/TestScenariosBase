@isTest
public with sharing class ServiceRecommendationRuleHandler_Test {
    @TestSetup
    static void createRequiredData() {
        dmpl__AccountGroup__c accountGroup = TestDataHelpers.createAccountGroup();
        Account account = TestDataHelpers.createAccount(accountGroup);
        Account partnerAccount = TestDataHelpers.createPartnerAccount();
        dmpl__Branch__c branch =TestDataHelpers.createBranch(partnerAccount);   
        dmpl__Item__c item = TestDataHelpers.createItem();
        dmpl__Resource__c resource = TestDataHelpers.createResource(partnerAccount, branch);
        dmpl__ChecklistTemplate__c checklistTemplate = ChecklistTemplateTestDataHelpers.createChecklistTemplate(resource, item, partnerAccount, account, accountGroup);
        dmpl__CheckListTemplateLine__c checklistTemplateLine =  ChecklistTemplateTestDataHelpers.createChecklistTemplateLine(checkListTemplate);
        dmpl__ServiceRecommendationRule__c serviceRecommendationRule = ServiceRecommendationRuleTestDataHelper.createServiceRecommendationRule(checklistTemplateLine, item);

        dmpl__Item__c  item1 = TestDataHelpers.createItem('Item 1','Product',true,false,false,'675654',false);
        dmpl__Item__c item2 = TestDataHelpers.createItem('Item 2','Product',false,false,false,'654345',false);
        dmpl__Item__c item8 = TestDataHelpers.createItem('Item 8','Product',true,false,false, '765456',false);
        dmpl__Item__c item5 = TestDataHelpers.createItem('Item 5', 'Product', true, false, false, '876543', false);
        dmpl__Item__c item3 = TestDataHelpers.createItem('Item 3','Charge Item',true, false, false ,'765434',true);
    }

    @isTest
    static void createServiceRecommendationRulePositive() {
        dmpl__ServiceRecommendationRule__c serviceRecommendationRule = ServiceRecommendationRuleTestDataHelper.getServiceRecommendationRule();
        System.assertNotEquals(serviceRecommendationRule, null, 'Expected Service Recommendation Rule to be created.');

        System.assertEquals(serviceRecommendationRule.dmpl__Quantity__c, 3, 'Quantity should be 3.');
        System.assertEquals(serviceRecommendationRule.dmpl__ValueGreaterThan__c, 5, 'Value greater than should be 5.');
        System.assertEquals(serviceRecommendationRule.dmpl__ValueLessThan__c, 2, 'Value less than should be 2.');
        System.assertEquals(serviceRecommendationRule.dmpl__RAGValue__c, 'Red', 'RAG Value should be Red.');
        System.assertEquals(serviceRecommendationRule.dmpl__RecommendationType__c, 'Mandatory', 'Recommendation Type should be Mandatory.');
    }

    @isTest
    static void updateServiceRecommendationRulePositive() {
        dmpl__ServiceRecommendationRule__c serviceRecommendationRule = ServiceRecommendationRuleTestDataHelper.getServiceRecommendationRule();
        System.assertNotEquals(serviceRecommendationRule, null, 'Service Recommendation Rule should exist before update.');
        serviceRecommendationRule.dmpl__Quantity__c = 4;
        serviceRecommendationRule.dmpl__ValueGreaterThan__c = 6;
        serviceRecommendationRule.dmpl__ValueLessThan__c = 3;
        serviceRecommendationRule.dmpl__RAGValue__c = 'Amber';
        serviceRecommendationRule.dmpl__RecommendationType__c = 'Optional';
        update serviceRecommendationRule;

        dmpl__ServiceRecommendationRule__c updatedServiceRecommendationRule = ServiceRecommendationRuleTestDataHelper.getServiceRecommendationRule();
        System.assertEquals(updatedServiceRecommendationRule.dmpl__Quantity__c, 4, 'Quantity should be 4 after update.');
        System.assertEquals(updatedServiceRecommendationRule.dmpl__ValueGreaterThan__c, 6, 'Value greater than should be 6 after update.');
        System.assertEquals(updatedServiceRecommendationRule.dmpl__ValueLessThan__c, 3, 'Value less than should be 3 after update.');
        System.assertEquals(updatedServiceRecommendationRule.dmpl__RAGValue__c, 'Amber', 'RAG Value should be Amber after update.');
        System.assertEquals(updatedServiceRecommendationRule.dmpl__RecommendationType__c, 'Optional', 'Recommendation Type should be Optional after update.');
    }

    @isTest
    static void deleteServiceRecommendationRule() {
        dmpl__ServiceRecommendationRule__c serviceRecommendationRule = ServiceRecommendationRuleTestDataHelper.getServiceRecommendationRule();
        System.assertNotEquals(serviceRecommendationRule, null, 'Service Recommendation Rule should exist before delete.');
        Id serviceRecommendationRuleId = serviceRecommendationRule.Id;
        delete serviceRecommendationRule;
        dmpl__ServiceRecommendationRule__c deletedServiceRecommendationRule = null;
        try {
            deletedServiceRecommendationRule = ServiceRecommendationRuleTestDataHelper.getServiceRecommendationRule(serviceRecommendationRuleId);
        } catch (Exception e) {
            deletedServiceRecommendationRule = null;
        }
        System.assertEquals(deletedServiceRecommendationRule, null, 'Service Recommendation Rule should be deleted and not found in query.');
    }
    // Service Recommendation Rule creation with Checklist line template (New)
    @isTest
static void CreateServiceRecommendationRuleWithChecklistLineTemplatePositive() {

    dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
    dmpl__ChecklistTemplate__c checklistTemplate = ChecklistTemplateTestDataHelpers.createChecklistTemplateWithIds(null,item,null,null,null);
    dmpl__CheckListTemplateLine__c checklistTemplateLine = ChecklistTemplateTestDataHelpers.createChecklistTemplateLine(
        checklistTemplate,
        'Was the delivery received on time and in good condition?'
    );

    dmpl__ServiceRecommendationRule__c rule = ServiceRecommendationRuleTestDataHelper.createServiceRecommendationRule(
        checklistTemplateLine,
        item
    );
    rule.dmpl__Quantity__c=1;
    update rule;


    dmpl__ServiceRecommendationRule__c fetched = ServiceRecommendationRuleTestDataHelper.getServiceRecommendationRule(rule.Id);

    System.assertNotEquals(null, fetched.Id, 'Service Recommendation Rule should be inserted');
    System.assertEquals(item.Id, fetched.dmpl__ItemId__c, 'Item should be Item 1');
    System.assertEquals(checklistTemplateLine.Id, fetched.dmpl__ChecklistTemplateLineId__c,
        'Checklist Template Line should be "Was the delivery received on time and in good condition?"');
    System.assertEquals(1, fetched.dmpl__Quantity__c, 'Quantity should be 1');
}

    

    // Service Recommendation Rule creation with Checklist line template (Edit)

    @isTest
    static void UpdateServiceRecommendationRuleWithChecklistLineTemplatePositive() {

    dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
    dmpl__ChecklistTemplate__c checklistTemplate = ChecklistTemplateTestDataHelpers.createChecklistTemplateWithIds(null,item,null,null,null);
    dmpl__CheckListTemplateLine__c checklistTemplateLine = ChecklistTemplateTestDataHelpers.createChecklistTemplateLine(
        checklistTemplate,
        'Was the delivery received on time and in good condition?'
    );

    dmpl__CheckListTemplateLine__c checklistTemplateLine2 = ChecklistTemplateTestDataHelpers.createChecklistTemplateLine(
        checklistTemplate,
        'How satisfied are you with the delivery service?'
    );

    dmpl__ServiceRecommendationRule__c rule = ServiceRecommendationRuleTestDataHelper.createServiceRecommendationRule(
        checklistTemplateLine,
        item
    );
    rule.dmpl__Quantity__c=1;
    update rule;


    dmpl__ServiceRecommendationRule__c fetched = ServiceRecommendationRuleTestDataHelper.getServiceRecommendationRule(rule.Id);
    fetched.dmpl__CheckListTemplateLineId__c=checklistTemplateLine2.Id;
    update fetched;

    System.assertNotEquals(null, fetched.Id, 'Service Recommendation Rule should be inserted');
    System.assertEquals(item.Id, fetched.dmpl__ItemId__c, 'Item should be Item 1');
    System.assertEquals(checklistTemplateLine2.Id, fetched.dmpl__ChecklistTemplateLineId__c,
        'Checklist Template Line should be "Was the delivery received on time and in good condition?"');
    System.assertEquals(1, fetched.dmpl__Quantity__c, 'Quantity should be 1');
}

    // Service Recommendation Rule creation without Checklist line template (New)
    @isTest
static void CreateServiceRecommendationRuleWithoutChecklistLinePositive() {
    dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
    dmpl__ChecklistTemplate__c checklistTemplate = ChecklistTemplateTestDataHelpers.createChecklistTemplateWithIds(null,item,null,null,null);
    dmpl__CheckListTemplateLine__c checklistTemplateLine = ChecklistTemplateTestDataHelpers.createChecklistTemplateLine(
        checklistTemplate,
        'Was the delivery received on time and in good condition?'
    );
    Boolean exceptionCaught = false;
    try{
        dmpl__ServiceRecommendationRule__c rule = ServiceRecommendationRuleTestDataHelper.createServiceRecommendationRule(
            null,
            item
        );
        rule.dmpl__Quantity__c=1;
        update rule;
        System.assertNotEquals(null, rule.Id, 'Service Recommendation Rule should be inserted without checklist line ');
        System.assertEquals(item.Id, rule.dmpl__ItemId__c, 'Item should be Item 8');
        System.assertEquals(1, rule.dmpl__Quantity__c, 'Quantity should be 1');
    }catch(Exception e){
        exceptionCaught = true;
    }
    System.assertEquals(true,exceptionCaught,'expected exception ');
    
}
// Service Recommendation Rule creation with active Item  (New)
 @isTest
static void CreateServiceRecommendationRuleWithActiveItem() {

    dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
    dmpl__ChecklistTemplate__c checklistTemplate = ChecklistTemplateTestDataHelpers.createChecklistTemplateWithIds(null,item,null,null,null);
    dmpl__CheckListTemplateLine__c checklistTemplateLine = ChecklistTemplateTestDataHelpers.createChecklistTemplateLine(
        checklistTemplate,
        'Was the delivery received on time and in good condition?'
    );

    dmpl__ServiceRecommendationRule__c rule = ServiceRecommendationRuleTestDataHelper.createServiceRecommendationRule(
        checklistTemplateLine,
        item
    );
    rule.dmpl__Quantity__c=1;


    System.assertNotEquals(null, rule.Id, 'Service Recommendation Rule should be inserted');
    System.assertEquals(item.Id, rule.dmpl__ItemId__c, 'Item should be Item 8');
}
// Service Recommendation Rule creation with active Item  (Edit)
@isTest
static void UpdateServiceRecommendationRuleWithActiveItemPositive() {

    dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
    dmpl__Item__c item3 = TestDataHelpers.getItem('Item 3');
    dmpl__ChecklistTemplate__c checklistTemplate = ChecklistTemplateTestDataHelpers.createChecklistTemplateWithIds(null,item,null,null,null);
    dmpl__CheckListTemplateLine__c checklistTemplateLine = ChecklistTemplateTestDataHelpers.createChecklistTemplateLine(
        checklistTemplate,
        'Was the delivery received on time and in good condition?'
    );

    dmpl__ServiceRecommendationRule__c rule = ServiceRecommendationRuleTestDataHelper.createServiceRecommendationRule(
        checklistTemplateLine,
        item
    );
    rule.dmpl__Quantity__c=1;
    update rule;

    dmpl__ServiceRecommendationRule__c fetchedrule = ServiceRecommendationRuleTestDataHelper.getServiceRecommendationRule(rule.Id);
    fetchedrule.dmpl__ItemId__c=item3.Id;
    fetchedrule.dmpl__Quantity__c=8;
    update rule;

    System.assertEquals(item.Id, rule.dmpl__ItemId__c, 'Item should be Item 8');
    System.assertEquals(8, fetchedrule.dmpl__Quantity__c, 'Quantity should be 1');
}

// Service Recommendation Rule creation with in- active Item (New)
@isTest
static void CreateServiceRecommendationRuleWithInActiveItemNegative(){
    dmpl__Item__c inactiveItem = TestDataHelpers.getItem('Item 2'); 
    dmpl__ChecklistTemplate__c checklistTemplate = ChecklistTemplateTestDataHelpers.createChecklistTemplateWithIds(null,inactiveItem,null,null,null);
    dmpl__CheckListTemplateLine__c checklistTemplateLine = ChecklistTemplateTestDataHelpers.createChecklistTemplateLine(
        checklistTemplate,
        'Was the delivery received on time and in good condition?'
    );

    Boolean exceptionThrown=false;

    Test.startTest();
    try {
        dmpl__ServiceRecommendationRule__c recommendationRule = 
            ServiceRecommendationRuleTestDataHelper.createServiceRecommendationRule(
                 checklistTemplateLine,inactiveItem
            );
    } catch (Exception e) {
        exceptionThrown = true;
    }
    Test.stopTest();

    System.assertEquals(true, exceptionThrown, 'Exception should be thrown for inactive item');
}

// Service Recommendation Rule creation with 0 quantity (New)
@isTest
static void CreateServiceRecommendationRuleWithZeroQuantityPositive() {

    dmpl__Item__c item = TestDataHelpers.getItem('Item 1');
    dmpl__ChecklistTemplate__c checklistTemplate = ChecklistTemplateTestDataHelpers.createChecklistTemplateWithIds(null,item,null,null,null);
    dmpl__CheckListTemplateLine__c checklistTemplateLine = ChecklistTemplateTestDataHelpers.createChecklistTemplateLine(
        checklistTemplate,
        'Was the delivery received on time and in good condition?'
    );

    dmpl__ServiceRecommendationRule__c rule = ServiceRecommendationRuleTestDataHelper.createServiceRecommendationRule(
        checklistTemplateLine,
        item
    );
    rule.dmpl__Quantity__c=0;
    update rule;


    System.assertNotEquals(null, rule.Id, 'Service Recommendation Rule should be inserted');
    System.assertEquals(item.Id, rule.dmpl__ItemId__c, 'Item should be Item 8');
    System.assertEquals(0, rule.dmpl__Quantity__c, 'Item should be Item 8');
}


}