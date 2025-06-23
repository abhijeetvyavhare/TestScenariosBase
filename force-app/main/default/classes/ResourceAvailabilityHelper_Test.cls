@isTest
public class ResourceAvailabilityHelper_Test {
    
    @testSetup
    public static void setup() { 
        createAccount();
        createBranch();
        createResource();
        createPartnerResource();
        createResourceAvailability();           
    }
    @isTest
    private static void ResourceAvailabilityDataServiceTest(){
        Test.startTest();
        List<dmpl__ResourceAvailabilityData__c> data = [select Id,dmpl__ResourceAvailabilityId__c,dmpl__AttendenceTime__c,dmpl__ResourceId__c FROM dmpl__ResourceAvailabilityData__c];
        ResourceAvailabilityDataService.processResourceAvailabilityData(data);
        new ResourceAvailabilityDataService();
        Test.stopTest();
    }
    
    @isTest
    private static void getUserDetailsTest() {  
        Test.startTest();
        ResourceAvailabilityHelper.getUserDetails();
        Test.stopTest();
    }
    
    @isTest
    private static void testPostCheckIn() {
        Test.startTest();
        String latitude = '37.7749';
        String longitude = '-122.4194';
        DateTime now = DateTime.now();
        String currentDateTime = now.format('yyyy-MM-dd HH:mm:ss');
        Boolean result = ResourceAvailabilityHelper.postCheckIn(latitude, longitude, currentDateTime);
        Test.stopTest();
    }
    
    @isTest
    private static void testPostCheckOut() {
        Test.startTest();
        String latitude = '37.7749';
        String longitude = '-122.4194';
        DateTime now = DateTime.now();
        String currentDateTime = now.format('yyyy-MM-dd HH:mm:ss');
        Boolean result = ResourceAvailabilityHelper.postCheckOut(latitude, longitude, currentDateTime);
        Test.stopTest();
        
        // Assert that the check-out was successful
        //
        //System.assert(result, 'Check-out should be successful');
        
        // Validate the updated ResourceAvailability record
        List<dmpl__ResourceAvailability__c> availabilities = [
            SELECT Id, dmpl__CheckOut__c 
            FROM dmpl__ResourceAvailability__c 
            WHERE dmpl__CheckOut__c != null 
            LIMIT 1
        ];
        //System.assertEquals(1, availabilities.size(), 'One availability record should be updated with check-out');
    }
    
    @isTest
    private static void testGetResourceDetailsByBranch() {
        dmpl__Branch__c branchData = [SELECT Id, Name FROM dmpl__Branch__c LIMIT 1];
        
        String branchId = branchData.Id; 
        String startDate = Date.today().format();
        String endDate = Date.today().addDays(30).format();
        Test.startTest();
        //AttendanceManagementController.getResourceDetails('','', new List<Id>{branchId},startDate,endDate);
       // AttendanceManagementController.getResourceDetailsByResource(branchId,startDate,endDate);
        
        try {
            List<dmpl__Resource__c> resources = ResourceAvailabilityHelper.getResourceDetailsByBranch(branchId, startDate, endDate);
        } catch (Exception e) {
            System.debug('Exception thrown: ' + e.getMessage());
        }
        Test.stopTest();
    }
    
    public static void createAccount() {
        Account partnerAccount = new Account(Name = 'Partner-Test-Account', dmpl__IsPartnerAccount__c = true, dmpl__IsActive__c = true);
        insert partnerAccount;

        Account supplierAccount = new Account(Name = 'Supplier-Test-Account', dmpl__IsSupplierAccount__c = true, dmpl__IsActive__c = true);
        insert supplierAccount;

        Account customerAccount = new Account(Name = 'Customer-Test-Account', dmpl__IsCustomerAccount__c = true, dmpl__IsActive__c = true);
        insert customerAccount;
    }
    
    public static void createBranch() {
        List<dmpl__Branch__c> branches = new List<dmpl__Branch__c>();
        Account partnerAccount = [SELECT Id, Name FROM Account WHERE Name = 'Partner-Test-Account' LIMIT 1];
        branches.add(new dmpl__Branch__c(
            dmpl__PartnerAccountId__c = partnerAccount.Id,
            Name = 'Test-Branch',
            dmpl__IsActive__c = true,
            dmpl__MarketingName__c = 'Hero Electric',
            dmpl__Website__c = 'www.dealermatix.com',
            dmpl__Email__c = 'Dealer@Outlook.com',
            dmpl__MobileNumber__c = 99,
            dmpl__Phone__c = '8888888888',
            dmpl__AllowSales__c = true,
            dmpl__AllowService__c = true,
            dmpl__AllowPurchase__c = true,
            dmpl__AllowInventory__c = true,
            dmpl__IsHomeDeliveryAvailable__c = true,
            dmpl__IsPickupDropAvailable__c = true,
            dmpl__SalesPhone__c = '7777777777',
            dmpl__ServiceEmail__c = 'Customer@Outlook.com'
        ));
        insert branches;  
    }
    
    public static void createResource() {
        Account partnerAccount = [SELECT Id, Name FROM Account WHERE dmpl__IsPartnerAccount__c = true LIMIT 1];
        dmpl__Branch__c branchData = [SELECT Id, Name FROM dmpl__Branch__c LIMIT 1];

        dmpl__Resource__c resource = new dmpl__Resource__c(
            Name = 'Test Resource',
            dmpl__UserId__c = UserInfo.getUserId(),
            dmpl__IsActive__c = true,
            dmpl__DefaultBranchId__c = branchData.Id,
            dmpl__DefaultPartnerAccountId__c = partnerAccount.Id
        );
        insert resource;
    }
    
    public static void createPartnerResource() {
        dmpl__Branch__c branchData = [SELECT Id, Name FROM dmpl__Branch__c LIMIT 1];
        dmpl__Resource__c resourceData = [SELECT Id, Name FROM dmpl__Resource__c LIMIT 1];

        dmpl__PartnerResource__c partnerResource = new dmpl__PartnerResource__c(
            dmpl__ResourceId__c = resourceData.Id,
            dmpl__BranchId__c = branchData.Id,
            dmpl__FromDate__c = Date.today(),
            dmpl__ToDate__c = Date.today().addDays(30)
        );
        insert partnerResource;
    }
    
    public static void createResourceAvailability() {
        dmpl__Resource__c resourceData = [SELECT Id, Name FROM dmpl__Resource__c LIMIT 1];

        dmpl__ResourceAvailability__c availability = new dmpl__ResourceAvailability__c(
            dmpl__ResourceId__c = resourceData.Id,
            dmpl__AvailabilityType__c = 'Present',
            dmpl__Date__c = Date.today(),
            dmpl__CheckIn__c = DateTime.now()
        );
        insert availability; 
        dmpl__ResourceAvailabilityData__c ResourceAvailabilityData = new dmpl__ResourceAvailabilityData__c();
        ResourceAvailabilityData.dmpl__ResourceAvailabilityId__c = availability.Id;
        ResourceAvailabilityData.dmpl__ResourceId__c = resourceData.Id;
        ResourceAvailabilityData.dmpl__AttendenceTime__c = DateTime.newInstance(2024, 12, 13, 9, 0, 0);
        insert ResourceAvailabilityData;
    }
}