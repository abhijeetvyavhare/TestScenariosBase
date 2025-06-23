@isTest
public class KPIConfigurationService_Test {

     @testSetup
    public static void setup() {
         Test.startTest();
        
       // Ensure KPI Configuration record exists
        CreateKPIConfiguration();
        
      Test.stopTest();
    }

    @isTest
   public static void testGetKPIConfigs() {
        KPIConfigurationService service = new KPIConfigurationService();
        
        // Call the method to test
        Test.startTest();
       
        List<dmpl__KPIConfiguration__c> kpiConfigs = service.getKPIConfigs();
        List<dmpl__KPIConfiguration__c> kpiConfigs1 = service.getKPIConfigs('TestApiName');
       
        Test.stopTest();
         System.assertEquals(1, kpiConfigs.size(), 'There should be one KPI configuration.');
     }

    @isTest
    public static void testEvaluateTimerKPIConfigRules() {
         // Insert a queue record to get a valid queueId
         dmpl__InterfaceQueue__c queue = new dmpl__InterfaceQueue__c(
           dmpl__QueueType__c = 'Queueable',
           dmpl__JobType__c = 'Account Group Member Processor'
         );
       insert queue;
        Id queueId = queue.Id;

        Test.startTest();
      //  KPIConfigurationService.getIncentivePeriods(queueId);
         Test.stopTest();

   }

     private static void CreateKPIConfiguration() {
         dmpl__KPIConfiguration__c kpiConfig = new dmpl__KPIConfiguration__c(
           Name = 'Test KPI Config',
            dmpl__IsActive__c = true,
             dmpl__TriggerEvent__c = 'Scheduled',
          dmpl__TriggerObjectName__c = 'Account',
             dmpl__DateFieldName__c='TestName', 
             dmpl__MemberType__c='Partner'
      );
         insert kpiConfig;
     }
    
}


/*
@isTest
public class KPIConfigurationService_Test {

//     @testSetup
//     public static void setup() {
//         Test.startTest();
        
//         // Ensure KPI Configuration record exists
//         CreateKPIConfiguration();
        
//         Test.stopTest();
//     }

//     @isTest
//     public static void testGetKPIConfigs() {
//         List<dmpl__KPIConfiguration__c> kpiConfigs = [SELECT Id FROM dmpl__KPIConfiguration__c];
//         System.assertEquals(1, kpiConfigs.size(), 'There should be one KPI configuration.');
//     }

//     @isTest
//     public static void testEvaluateTimerKPIConfigRules() {
//         // Insert a queue record to get a valid queueId
//         dmpl__InterfaceQueue__c queue = new dmpl__InterfaceQueue__c(
//             dmpl__QueueType__c = 'Queueable',
//             dmpl__JobType__c = 'Account Group Member Processor'
//         );
//         insert queue;
//         Id queueId = queue.Id;

//         Test.startTest();
//         KPIConfigurationService.evaluateTimerKPIConfigRules(queueId);
//         Test.stopTest();

//         // Add assertions if needed to verify the behavior, e.g., check if messages were created
//     }

//     private static void CreateKPIConfiguration() {
//         dmpl__KPIConfiguration__c kpiConfig = new dmpl__KPIConfiguration__c(
//             Name = 'Test KPI Config',
//             dmpl__IsActive__c = true,
//             dmpl__TriggerEvent__c = 'Scheduled',
//             dmpl__TriggerObjectName__c = 'Account'
//         );
//         insert kpiConfig;
//     }
}

*/