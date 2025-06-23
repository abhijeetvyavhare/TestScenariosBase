@IsTest
public class ResourceAvailabilityController_Test {
    
    @testSetup
    public static void setup()
    {
        Test.startTest();
        
        CreateAccount();
        CreateBranch();
        CreateResouce();
        CreatePartnerResources();
        Test.stopTest();
    }

    @IsTest
    public static void testGetUserDetails() {
        Test.startTest();
       
        ResourceInfo result = ResourceAvailabilityController.getUserDetails();
        
        Test.stopTest();
    }

    @IsTest
    public static void testPostCheckIn() {
        Test.startTest();  
        
        Boolean result = ResourceAvailabilityController.postCheckIn('34.052235', '118.243683', '2024-09-23T10:00:00');
        
        Test.stopTest();
    }

    @IsTest
    public static void testPostCheckOut() {
        Test.startTest(); 
        
        Boolean result = ResourceAvailabilityController.postCheckOut('34.052235', '118.243683', '2024-09-23T18:00:00');
        
        Test.stopTest();
    }

    @IsTest
    public static void testGetResourceDetailsByBranch() {
        Test.startTest();
        
        dmpl__Branch__c branch = [SELECT Id FROM dmpl__Branch__c LIMIT 1];
        
        List<dmpl__Resource__c> resources = ResourceAvailabilityController.getResourceDetailsByBranch(
            branch.Id, 
            '2024-09-01', 
            '2024-09-30'
        );
        
        Test.stopTest();
    }
    
    @IsTest
    public static void testgetCheckInLocationTolerance() {
        Decimal tolerance = ResourceAvailabilityController.getCheckInLocationTolerance();
    }
    
    public static void CreateAccount()
    {
        Account partneraccount = new Account(Name = 'Partner-Test-Account',dmpl__IsPartnerAccount__c = true,dmpl__LastName__c = 'Account', dmpl__IsActive__c = true);
        insert partneraccount;
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
    
    private static void CreatePartnerResources(){
        List<dmpl__PartnerResource__c> partnerResources = new List<dmpl__PartnerResource__c>();
        Account partnerAccount = [Select Id,Name From Account  where dmpl__IsPartnerAccount__c = TRUE LIMIT 1];
        dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c LIMIT 1];
        dmpl__Resource__c resource = [Select Id,Name From dmpl__Resource__c LIMIT 1];
        partnerResources.Add(new dmpl__PartnerResource__c(dmpl__PartnerAccountId__c =partnerAccount.Id,
                                    dmpl__BranchId__c= branch.Id,
                                    dmpl__ResourceId__c= resource.Id,               
                                    dmpl__RuleSuccessCriteria__c='All Rules Are Met',
                                    dmpl__AssignmentSequenceNumber__c=12,
                                    dmpl__FromDate__c = Date.valueOf('2024-09-01'),
                                    dmpl__ToDate__c = Date.valueOf('2024-09-10')));
        partnerResources.Add(new dmpl__PartnerResource__c(dmpl__PartnerAccountId__c =partnerAccount.Id,
                                    dmpl__BranchId__c= branch.Id,
                                    dmpl__ResourceId__c= resource.Id,               
                                    dmpl__RuleSuccessCriteria__c='Any Rule Is Met',
                                    dmpl__AssignmentSequenceNumber__c=13,
                                    dmpl__FromDate__c = Date.valueOf('2024-09-11')));
        insert partnerResources; 
    }
 }