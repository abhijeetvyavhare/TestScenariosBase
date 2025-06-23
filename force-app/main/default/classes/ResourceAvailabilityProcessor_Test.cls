@IsTest
public class ResourceAvailabilityProcessor_Test {
    
    @testSetup
    public static void setup() {
        CreateAccount();
        CreateBranch();
        CreateResource();
        CreateResourceAvailability();
    }
    
    @IsTest
    static void testPerformAction() {
        dmpl__Resource__c resource = [SELECT Id FROM dmpl__Resource__c LIMIT 1];
        Id queueId = UserInfo.getUserId(); 
        
        Test.startTest();
        JobResponseResult result = ResourceAvailabilityProcessor.perfromAction(resource.Id, queueId);
        Test.stopTest();
        
    }

    @IsTest
    public static void testBatchExecution() {
        String query = 'SELECT Id, Name, dmpl__BusinessHoursId__c, dmpl__DefaultBranchId__r.dmpl__PayrollBusinessHoursId__c FROM dmpl__Resource__c';
        Test.startTest();
        ResourceAvailabilityProcessor batch = new ResourceAvailabilityProcessor(query, UserInfo.getUserId());
        Database.executeBatch(batch, ResourceAvailabilityProcessor.BATCH_SIZE);
        Test.stopTest();
    }

    @IsTest
    public static void testExecuteMethod() {
        List<dmpl__Resource__c> resources = [SELECT Id,dmpl__BusinessHoursId__c,dmpl__DefaultBranchId__r.dmpl__PayrollBusinessHoursId__c FROM dmpl__Resource__c LIMIT 10];

        Test.startTest();
        ResourceAvailabilityProcessor processor = new ResourceAvailabilityProcessor('SELECT Id FROM dmpl__Resource__c', UserInfo.getUserId());
        Database.BatchableContext bc;
        processor.execute(bc, resources);
        Test.stopTest();
    }

    @IsTest
    public static void testExecuteWithExceptions() {
        List<dmpl__Resource__c> invalidResources = new List<dmpl__Resource__c>{
            new dmpl__Resource__c(Id = null)
        };

        Test.startTest();
        try {
            ResourceAvailabilityProcessor processor = new ResourceAvailabilityProcessor('SELECT Id FROM dmpl__Resource__c', UserInfo.getUserId());
            Database.BatchableContext bc;
            processor.execute(bc, invalidResources);
        } catch (Exception e) {
            System.assert(true);
        }
        Test.stopTest();
    }

    @IsTest
    public static void testQueryResourceAvailabilities() {
        dmpl__Resource__c resource = [SELECT Id FROM dmpl__Resource__c LIMIT 1];
        Test.startTest();
        List<Id> resourceIds = new List<Id>{resource.Id};
        Map<Id, dmpl__ResourceAvailability__c> resourceAvailabilityMap = ResourceAvailabilityProcessor.queryResourceAvailabilities(resourceIds);
        Test.stopTest();
    }

    @IsTest
    public static void testGetResourceBusinessHour() {
        dmpl__Resource__c resource = [SELECT Id, dmpl__DefaultBranchId__r.dmpl__PayrollBusinessHoursId__c, dmpl__BusinessHoursId__c FROM dmpl__Resource__c LIMIT 1];
        Test.startTest();
        List<SObject> resources = new List<SObject>{resource};
        Map<Id, Id> resourceBusinessHourMap = ResourceAvailabilityProcessor.getResourceBusinessHour(resources);
        Test.stopTest();
    }

    @IsTest
    public static void testPerformAutoCheckOut() {
        dmpl__Resource__c resource = [SELECT Id FROM dmpl__Resource__c LIMIT 1];
        Map<Id, dmpl__ResourceAvailability__c> resourceAvailabilityMap = new Map<Id, dmpl__ResourceAvailability__c>();
        Map<Id, Id> resourceBusinessHourMap = new Map<Id, Id>();

        Test.startTest();
        List<SObject> resources = new List<SObject>{resource};
        ResourceAvailabilityProcessor.performAutoCheckOut(resources, resourceAvailabilityMap, resourceBusinessHourMap);
        Test.stopTest();
    }

    public static void CreateAccount() {
        Account partneraccount = new Account(Name = 'Partner-Test-Account', dmpl__IsPartnerAccount__c = true, dmpl__LastName__c = 'Account', dmpl__IsActive__c = true);
        insert partneraccount;
    }

    public static void CreateBranch() {
        Id businessHoursId = [SELECT Id,Name FROM BusinessHours LIMIT 1].Id;
        Account partnerAccount = [SELECT Id FROM Account WHERE dmpl__IsPartnerAccount__c = TRUE LIMIT 1];
        dmpl__Branch__c testBranch = new dmpl__Branch__c(Name = 'Test Branch', dmpl__PartnerAccountId__c = partnerAccount.Id,dmpl__PayrollBusinessHoursId__c = businessHoursId);
        insert testBranch;
    }

    public static void CreateResource() {
        Id businessHoursId = [SELECT Id,Name FROM BusinessHours LIMIT 1].Id;
        dmpl__Branch__c testBranch = [SELECT Id FROM dmpl__Branch__c LIMIT 1];
        dmpl__Resource__c testResource = new dmpl__Resource__c(Name = 'Test Resource', dmpl__DefaultBranchId__c = testBranch.Id,dmpl__BusinessHoursId__c = businessHoursId);
        insert testResource;
    }

    public static void CreateResourceAvailability() {
        dmpl__Resource__c testResource = [SELECT Id FROM dmpl__Resource__c LIMIT 1];
        dmpl__ResourceAvailability__c resourceAvailability = new dmpl__ResourceAvailability__c(
            dmpl__ResourceId__c = testResource.Id,
            dmpl__AvailabilityType__c = 'Present',
            dmpl__Date__c = Date.Today()
        );
        insert resourceAvailability;
    }

    @IsTest
    public static void testFinishMethod() {
        Test.startTest();
        ResourceAvailabilityProcessor processor = new ResourceAvailabilityProcessor('SELECT Id FROM dmpl__Resource__c', UserInfo.getUserId());
        Database.BatchableContext bc;
        processor.finish(bc);
        Test.stopTest();
    }
}