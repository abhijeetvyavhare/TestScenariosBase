@isTest
public class KPIConfigurationHelper_Test {

    @testSetup
    public static void Setup(){
        CreateMessageRule();
        dmpl__InterfaceQueue__c queue = new dmpl__InterfaceQueue__c(
            dmpl__QueueType__c = 'Queueable',
            dmpl__JobType__c = 'Account Group Member Processor'
        );
        insert queue;
        
        dmpl__InterfaceQueue__c jobqueue = [select Id from dmpl__InterfaceQueue__c Limit 1];
        
        dmpl__KPIConfiguration__c kpiConfig = new dmpl__KPIConfiguration__c(
            Name = 'Test KPI Config',
            dmpl__IsActive__c = true,
            dmpl__TriggerEvent__c = 'SCHEDULED', 
            dmpl__TriggerObjectName__c = 'Account',
            dmpl__ValueFieldName__c = 'Test',
            dmpl__DateFieldName__c = 'Test',
            dmpl__RewardFieldName__c = 'Test',
            dmpl__ResourceFieldName__c = 'Test',
            dmpl__PartnerFieldName__c = 'Test',
            dmpl__ItemFieldName__c = 'Test',
            dmpl__BranchFieldName__c = 'Test',
            dmpl__AccountFieldName__c = 'Test',
            dmpl__MemberType__c = 'Branch',
            dmpl__RuleSuccessCriteria__c = 'All Rules Are Met',
            dmpl__JobQueueId__c = jobqueue.Id
        );
        insert kpiConfig;
    }

    @isTest
    public static void testEvaluateKPIConfigRules() {
        String objectApiName = 'Account';
        TriggerHandler.TriggerContext triggerContext = TriggerHandler.TriggerContext.BEFORE_INSERT;
        List<Id> recordIds = new List<Id>{};

        Test.startTest();
        KPIConfigurationHelper.evaluateKPIConfigRules(objectApiName, triggerContext, recordIds);
        Test.stopTest();

    }

    @isTest
    public static void testEvaluateTimerKPIConfigRules() {
        // Use a valid queueId for testing
        //dmpl__InterfaceQueue__c queue = [SELECT Id FROM dmpl__InterfaceQueue__c LIMIT 1];
        //Id queueId = queue.Id;
        
        dmpl__KPIConfiguration__c jobqueueid = [SELECT Id,dmpl__JobQueueId__c FROM dmpl__KPIConfiguration__c LIMIT 1];
        Id queueId = jobqueueid.dmpl__JobQueueId__c;
        
       Test.startTest();
        KPIConfigurationHelper.evaluateTimerKPIConfigRules(queueId);
       Test.stopTest();

        
    }
    
    @isTest
    public static void getSourceObjectsTest()
    {
        test.startTest();
        dmpl__KPIConfiguration__c config=[SELECT id,
                                              dmpl__JobQueueId__c,
                                              dmpl__ValueFieldName__c,
                                              dmpl__RewardFieldName__c,
                                              dmpl__ResourceFieldName__c,
                                              dmpl__PartnerFieldName__c,
                                              dmpl__ItemFieldName__c,
                                              dmpl__BranchFieldName__c,
                                              dmpl__AccountFieldName__c,
                                              dmpl__DateFieldName__c,
                                              dmpl__TriggerObjectName__c
                                              FROM dmpl__KPIConfiguration__c limit 1];
        List<Id> idList = new List<Id>();
        idList.add(config.Id);
        KPIConfigurationHelper.getSourceObjects(config,idList);
        test.stopTest();
    }
    
    @isTest
    public static void buildConditionTest() {
       test.startTest();
    
            dmpl__KPIRules__c MessageRule = [SELECT id,
                                      dmpl__FieldName__c,
                                      dmpl__FieldValue__c,
                                      dmpl__Operation__c
                                      FROM dmpl__KPIRules__c LIMIT 1];
    
    
    KPIConfigurationHelper.RuleEvaluator evaluator = new KPIConfigurationHelper.RuleEvaluator();
    evaluator.buildCondition(MessageRule);
    
    test.stopTest();
   }


    @isTest
    public static void testEvaluateKPIConfigRulesInternal() {
        
        String objectApiName = 'Account';
        String triggerContext = String.ValueOf(TriggerHandler.TriggerContext.BEFORE_INSERT);
        List<Id> recordIds = new List<Id>();

        Test.startTest();
        KPIConfigurationHelper.evaluateKPIConfigRulesInternal(objectApiName, triggerContext, recordIds);
        Test.stopTest();

        
    }
    
    @isTest
    public static void KPIHelperTest(){
        KPIConfigurationHelper.RuleEvaluator child=new KPIConfigurationHelper.RuleEvaluator();
        dmpl__KPIRules__c MessageRule=[SELECT id,
                                          dmpl__FieldName__c,
                                          dmpl__FieldValue__c,
                                          dmpl__Operation__c
                                          FROM dmpl__KPIRules__c LIMIT 1];
        dmpl__KPIConfiguration__c config=[SELECT id,
                                              dmpl__ValueFieldName__c,
                                              dmpl__JobQueueId__c,
                                              dmpl__TriggerEvent__c,
                                              dmpl__TriggerObjectName__c,
                                              dmpl__RewardFieldName__c,
                                              dmpl__ResourceFieldName__c,
                                              dmpl__PartnerFieldName__c,
                                              dmpl__ItemFieldName__c,
                                              dmpl__BranchFieldName__c,
                                              dmpl__AccountFieldName__c,
                                              dmpl__MemberType__c,
                                              dmpl__DateFieldName__c,
                                              dmpl__RuleSuccessCriteria__c
                                              FROM dmpl__KPIConfiguration__c limit 1];
        dmpl__InterfaceQueue__c queue =[Select Id, Name,dmpl__QueueType__c,dmpl__IsSuccessful__c from dmpl__InterfaceQueue__c Limit 1];
        KPIConfigurationHelper.evaluateKPIConfigRules('Account',TriggerHandler.TriggerContext.BEFORE_INSERT,new List<Id>{});
        KPIConfigurationHelper.evaluateTimerKPIConfigRules(queue.Id);
        KPIConfigurationHelper.evaluateKPIConfigRulesInternal('Account',String.Valueof(TriggerHandler.TriggerContext.BEFORE_INSERT),new List<Id>{});
        //MessageHelper.getSourceObjects(config,new List<Id>{});
        child.evaluateRules(config);
        child.buildCondition(MessageRule);
        child.getOperator(MessageRule);
        MessageRule.dmpl__Operation__c='equals';
        child.getOperator(MessageRule);   
        MessageRule.dmpl__Operation__c='notEqual';
        child.getOperator(MessageRule);
        MessageRule.dmpl__Operation__c='lessThan';
        child.getOperator(MessageRule);
        MessageRule.dmpl__Operation__c='greaterThan';
        child.getOperator(MessageRule);
        MessageRule.dmpl__Operation__c='lessOrEqual';
        child.getOperator(MessageRule);
        MessageRule.dmpl__Operation__c='greaterOrEqual';
        child.getOperator(MessageRule);
        MessageRule.dmpl__Operation__c='like';
        child.getOperator(MessageRule);
        MessageRule.dmpl__Operation__c='in';
        child.getOperator(MessageRule);
        MessageRule.dmpl__Operation__c='notIn';
        child.getOperator(MessageRule);
        MessageRule.dmpl__Operation__c='includes';
        child.getOperator(MessageRule);
        MessageRule.dmpl__Operation__c='excludes';
        child.getOperator(MessageRule);
    }
    private static void CreateMessageRule(){
        dmpl__KPIConfiguration__c messageConfig= new dmpl__KPIConfiguration__c(
          Name='test1',
          dmpl__TriggerObjectName__c='Account',
          dmpl__DateFieldName__c = 'Test',
          dmpl__MemberType__c = 'Branch'
        );
        insert messageConfig;
        dmpl__KPIRules__c MessageRule=new dmpl__KPIRules__c(
            dmpl__FieldName__c='feildName1',
            dmpl__KPIConfigurationId__c=messageConfig.id
        );
        insert MessageRule;
    }
}