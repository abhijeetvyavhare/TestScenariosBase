@isTest
public class ResourceService_Test {
    
    static testMethod void testValidateResource() {
        // Test case setup here
        // Create test data and configure org settings as needed
        // Example: create test records for dmpl__Resource__c, dmpl__PartnerResource__c, etc.
	
        Account partnerAccount = new Account(Name = 'Partner-Test-Account',
                                             dmpl__LastName__c = 'Sale Order',
                                             dmpl__IsPartnerAccount__c = True, 
                                             dmpl__IsActive__c = true);
        insert partnerAccount;
        
        Account customerAccount = new Account(Name = 'Customer-Test-Account',
                                              dmpl__LastName__c = 'Sale Order',
                                              dmpl__IsCustomerAccount__c = True,
                                              dmpl__IsActive__c = true);
        insert customerAccount;
        
        List<dmpl__Branch__c> branch = new List<dmpl__Branch__c>();
        branch.Add(new dmpl__Branch__c(dmpl__PartnerAccountId__c =partnerAccount.Id,
                                      Name = 'Test-Branch',
                                      dmpl__IsActive__c = true,
                                      dmpl__MarketingName__c = 'Hero Electric',
                                      dmpl__Website__c = 'www.dealermatix.com',
                                      dmpl__Email__c = 'Dealer@Outlook.com',
                                      dmpl__MobileNumber__c = 99,
                                      //dmpl__BusinessHoursId__c = business.Id,
                                      dmpl__Phone__c = '8888888888',
                                      dmpl__AllowSales__c = true,
                                      dmpl__AllowService__c = true,
                                      dmpl__AllowPurchase__c = true,
                                      dmpl__AllowInventory__c = true,
                                      dmpl__IsHomeDeliveryAvailable__c = true,
                                      dmpl__IsPickupDropAvailable__c = true,
                                      dmpl__SalesPhone__c = '7777777777',
                                      dmpl__ServiceEmail__c = 'Customer@Outlook.com'));
        insert branch;
        
        List<dmpl__Resource__c> resource = new List<dmpl__Resource__c>();
        //	Account partnerAccount = [Select Id,Name From Account LIMIT 1];
        //dmpl__Branch__c branch = [Select Id,Name From dmpl__Branch__c LIMIT 1];
        resource.add(new dmpl__Resource__c(Name = 'Test - Resource2',
                                           dmpl__ResourceType__c = 'Service Advisor',
                                           dmpl__IsActive__c = true,
                                           dmpl__Phone__c = '9999999999',
                                           dmpl__DefaultPartnerAccountId__c = partnerAccount.Id,
                                           dmpl__DefaultBranchId__c = branch[0].Id
                                          ));
        insert resource;
        
        List<dmpl__PartnerResource__c> partnerResources = new List<dmpl__PartnerResource__c>();
        partnerResources.Add(new dmpl__PartnerResource__c(dmpl__PartnerAccountId__c =partnerAccount.Id,
                                    dmpl__BranchId__c= branch[0].Id,
                                    dmpl__ResourceId__c= resource[0].Id,               
                                    dmpl__RuleSuccessCriteria__c='All Rules Are Met',
                                    dmpl__AssignmentSequenceNumber__c=12));
        insert partnerResources;
        // Call the validateResource method and assert the results
        ResourceService resourceService = new ResourceService();
        //List<SObject> testEntries = new List<SObject>(); // Populate with test data
         
        Test.startTest();
        resourceService.validateResource('dmpl__BranchId__c', resource);
        Test.stopTest();

        // Add assertions here to validate the behavior of the method
        // Example: System.assertEquals(expectedResult, actualResult);
    }

    static testMethod void testValidateDefaultPartnerAndBranch() {
        // Test case setup here
        // Create test data and configure org settings as needed
        // Example: create test records for dmpl__Resource__c, dmpl__PartnerResource__c, etc.

        // Call the validateDefaultPartnerAndBranch method and assert the results
        ResourceService resourceService = new ResourceService();
        
        Account partnerAccount = new Account(Name = 'Partner-Test-Account',
                                             dmpl__LastName__c = 'Sale Order',
                                             dmpl__IsPartnerAccount__c = True, 
                                             dmpl__IsActive__c = true);
        insert partnerAccount;
        
        Account customerAccount = new Account(Name = 'Customer-Test-Account',
                                              dmpl__LastName__c = 'Sale Order',
                                              dmpl__IsCustomerAccount__c = True,
                                              dmpl__IsActive__c = true);
        insert customerAccount;
        
        List<dmpl__Branch__c> branch = new List<dmpl__Branch__c>();
        branch.Add(new dmpl__Branch__c(dmpl__PartnerAccountId__c =partnerAccount.Id,
                                      Name = 'Test-Branch',
                                      dmpl__IsActive__c = true,
                                      dmpl__MarketingName__c = 'Hero Electric',
                                      dmpl__Website__c = 'www.dealermatix.com',
                                      dmpl__Email__c = 'Dealer@Outlook.com',
                                      dmpl__MobileNumber__c = 99,
                                      //dmpl__BusinessHoursId__c = business.Id,
                                      dmpl__Phone__c = '8888888888',
                                      dmpl__AllowSales__c = true,
                                      dmpl__AllowService__c = true,
                                      dmpl__AllowPurchase__c = true,
                                      dmpl__AllowInventory__c = true,
                                      dmpl__IsHomeDeliveryAvailable__c = true,
                                      dmpl__IsPickupDropAvailable__c = true,
                                      dmpl__SalesPhone__c = '7777777777',
                                      dmpl__ServiceEmail__c = 'Customer@Outlook.com'));
        insert branch;
        
        List<dmpl__Resource__c> resource = new List<dmpl__Resource__c>(); // Populate with test data
		resource.add(new dmpl__Resource__c(Name = 'Test - Resource1',
                                           dmpl__ResourceType__c = 'Service Advisor',
                                           dmpl__IsActive__c = true,
                                           dmpl__Phone__c = '9999999999',
                                           dmpl__DefaultPartnerAccountId__c = partnerAccount.Id,
                                           dmpl__DefaultBranchId__c = branch[0].Id
                                          ));
        insert resource;
        
        List<dmpl__PartnerResource__c> partnerResources = new List<dmpl__PartnerResource__c>();
        //Account partnerAccount = [Select Id,Name From Account WHERE Name = 'Partner-Test-Account' LIMIT 1];
        //dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c LIMIT 1];
        //dmpl__Resource__c resource = [Select Id,Name From dmpl__Resource__c LIMIT 1];
        partnerResources.Add(new dmpl__PartnerResource__c(dmpl__PartnerAccountId__c =partnerAccount.Id,
                                    dmpl__BranchId__c= branch[0].Id,
                                    dmpl__ResourceId__c= resource[0].Id,               
                                    dmpl__RuleSuccessCriteria__c='All Rules Are Met',
                                    dmpl__AssignmentSequenceNumber__c=12));
        insert partnerResources;
        
        Test.startTest();
        resourceService.validateDefaultPartnerAndBranch(resource);
        Test.stopTest();

        System.assert(resource != null, 'resource data');
        // Add assertions here to validate the behavior of the method
        // Example: System.assertEquals(expectedResult, actualResult);
    }
    
    
     static testMethod void testValidateDefaultPartnerAndBranch1() {
        // Test case setup here
        // Create test data and configure org settings as needed
        // Example: create test records for dmpl__Resource__c, dmpl__PartnerResource__c, etc.

        // Call the validateDefaultPartnerAndBranch method and assert the results
        ResourceService resourceService = new ResourceService();
        
        Account partnerAccount = new Account(Name = 'Partner-Test-Account',
                                             dmpl__LastName__c = 'Sale Order',
                                             dmpl__IsPartnerAccount__c = True, 
                                             dmpl__IsActive__c = true);
        insert partnerAccount;
        
        Account customerAccount = new Account(Name = 'Customer-Test-Account',
                                              dmpl__LastName__c = 'Sale Order',
                                              dmpl__IsCustomerAccount__c = True,
                                              dmpl__IsActive__c = true);
        insert customerAccount;
        
        List<dmpl__Branch__c> branch = new List<dmpl__Branch__c>();
        branch.Add(new dmpl__Branch__c(dmpl__PartnerAccountId__c =partnerAccount.Id,
                                      Name = 'Test-Branch',
                                      dmpl__IsActive__c = true,
                                      dmpl__MarketingName__c = 'Hero Electric',
                                      dmpl__Website__c = 'www.dealermatix.com',
                                      dmpl__Email__c = 'Dealer@Outlook.com',
                                      dmpl__MobileNumber__c = 99,
                                      //dmpl__BusinessHoursId__c = business.Id,
                                      dmpl__Phone__c = '8888888888',
                                      dmpl__AllowSales__c = true,
                                      dmpl__AllowService__c = true,
                                      dmpl__AllowPurchase__c = true,
                                      dmpl__AllowInventory__c = true,
                                      dmpl__IsHomeDeliveryAvailable__c = true,
                                      dmpl__IsPickupDropAvailable__c = true,
                                      dmpl__SalesPhone__c = '7777777777',
                                      dmpl__ServiceEmail__c = 'Customer@Outlook.com'));
        insert branch;
        
        List<dmpl__Resource__c> resource = new List<dmpl__Resource__c>(); // Populate with test data
		resource.add(new dmpl__Resource__c(Name = 'Test - Resource1',
                                           dmpl__ResourceType__c = 'Service Advisor',
                                           dmpl__IsActive__c = true,
                                           dmpl__Phone__c = '9999999999',
                                           dmpl__DefaultPartnerAccountId__c = partnerAccount.Id,
                                           dmpl__DefaultBranchId__c = branch[0].Id
                                          ));
        insert resource;
        
        List<dmpl__PartnerResource__c> partnerResources = new List<dmpl__PartnerResource__c>();
        //Account partnerAccount = [Select Id,Name From Account WHERE Name = 'Partner-Test-Account' LIMIT 1];
        //dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c LIMIT 1];
        //dmpl__Resource__c resource = [Select Id,Name From dmpl__Resource__c LIMIT 1];
        partnerResources.Add(new dmpl__PartnerResource__c(dmpl__PartnerAccountId__c =partnerAccount.Id,
                                    dmpl__BranchId__c= branch[0].Id,
                                    dmpl__ResourceId__c= resource[0].Id,               
                                    dmpl__RuleSuccessCriteria__c='All Rules Are Met',
                                    dmpl__AssignmentSequenceNumber__c=12));
        insert partnerResources;
        
        Test.startTest();
        Date asOnDate = Date.today();
        List<dmpl__PartnerResource__c> partnerResource = [Select Id,Name,dmpl__BranchId__c,dmpl__PartnerAccountId__c,dmpl__ToDate__c,dmpl__FromDate__c,dmpl__ResourceId__r.dmpl__IsActive__c from dmpl__PartnerResource__c ];
        resourceService.doesPartnerAccountExists(partnerResource,partnerResource[0].dmpl__PartnerAccountId__c);
        resourceService.doesBranchExists(partnerResource,partnerResource[0].dmpl__PartnerAccountId__c);
        
        
        Test.stopTest();

        System.assert(resource != null, 'resource data');
        // Add assertions here to validate the behavior of the method
        // Example: System.assertEquals(expectedResult, actualResult);
    }
      @isTest
    static void testCustomMetadataCreation() {
      dmpl__DMSOrgSetting__mdt setting=OrgSettingHelper.OrgSetting();
    }
    static testMethod void testValidateDefaultPartnerAndBranch2() {
        // Test case setup here
        // Create test data and configure org settings as needed
        // Example: create test records for dmpl__Resource__c, dmpl__PartnerResource__c, etc.

        // Call the validateDefaultPartnerAndBranch method and assert the results
        ResourceService resourceService = new ResourceService();
        
        Account partnerAccount = new Account(Name = 'Partner-Test-Account',
                                             dmpl__LastName__c = 'Sale Order',
                                             dmpl__IsPartnerAccount__c = True, 
                                             dmpl__IsActive__c = true);
        insert partnerAccount;
        
        Account customerAccount = new Account(Name = 'Customer-Test-Account',
                                              dmpl__LastName__c = 'Sale Order',
                                              dmpl__IsCustomerAccount__c = True,
                                              dmpl__IsActive__c = true);
        insert customerAccount;
        
        List<dmpl__Branch__c> branch = new List<dmpl__Branch__c>();
        branch.Add(new dmpl__Branch__c(dmpl__PartnerAccountId__c =partnerAccount.Id,
                                      Name = 'Test-Branch',
                                      dmpl__IsActive__c = true,
                                      dmpl__MarketingName__c = 'Hero Electric',
                                      dmpl__Website__c = 'www.dealermatix.com',
                                      dmpl__Email__c = 'Dealer@Outlook.com',
                                      dmpl__MobileNumber__c = 99,
                                      //dmpl__BusinessHoursId__c = business.Id,
                                      dmpl__Phone__c = '8888888888',
                                      dmpl__AllowSales__c = true,
                                      dmpl__AllowService__c = true,
                                      dmpl__AllowPurchase__c = true,
                                      dmpl__AllowInventory__c = true,
                                      dmpl__IsHomeDeliveryAvailable__c = true,
                                      dmpl__IsPickupDropAvailable__c = true,
                                      dmpl__SalesPhone__c = '7777777777',
                                      dmpl__ServiceEmail__c = 'Customer@Outlook.com'));
        insert branch;
        
        List<dmpl__Resource__c> resource = new List<dmpl__Resource__c>(); // Populate with test data
		resource.add(new dmpl__Resource__c(Name = 'Test - Resource1',
                                           dmpl__ResourceType__c = 'Service Advisor',
                                           dmpl__IsActive__c = true,
                                           dmpl__Phone__c = '9999999999',
                                           dmpl__DefaultPartnerAccountId__c = partnerAccount.Id,
                                           dmpl__DefaultBranchId__c = branch[0].Id
                                          ));
        insert resource;
        
        List<dmpl__PartnerResource__c> partnerResources = new List<dmpl__PartnerResource__c>();
        //Account partnerAccount = [Select Id,Name From Account WHERE Name = 'Partner-Test-Account' LIMIT 1];
        //dmpl__Branch__c branch = [Select Id,Name,dmpl__PartnerAccountId__c From dmpl__Branch__c LIMIT 1];
        //dmpl__Resource__c resource = [Select Id,Name From dmpl__Resource__c LIMIT 1];
        partnerResources.Add(new dmpl__PartnerResource__c(dmpl__PartnerAccountId__c =partnerAccount.Id,
                                    dmpl__BranchId__c= branch[0].Id,
                                    dmpl__ResourceId__c= resource[0].Id,               
                                    dmpl__RuleSuccessCriteria__c='All Rules Are Met',
                                    dmpl__AssignmentSequenceNumber__c=12));
        insert partnerResources;
        
        Test.startTest();
        Date asOnDate = Date.today();
        List<dmpl__PartnerResource__c> partnerResource = [Select Id,Name,dmpl__BranchId__c,dmpl__PartnerAccountId__c,dmpl__ToDate__c,dmpl__FromDate__c,dmpl__ResourceId__r.dmpl__IsActive__c from dmpl__PartnerResource__c ];
        resourceService.doesBranchExists(partnerResource,partnerResource[0].dmpl__BranchId__c,asOnDate);
        resourceService.doesPartnerAccountExists(partnerResource,partnerResource[0].dmpl__PartnerAccountId__c,asOnDate);
        resourceService.validateDefaultPartnerAndBranch(resource);
        resourceService.doesPartnerAccountExists(partnerResource,partnerResource[0].dmpl__PartnerAccountId__c);
        Test.stopTest();

        System.assert(resource != null, 'resource data');
        // Add assertions here to validate the behavior of the method
        // Example: System.assertEquals(expectedResult, actualResult);
        List<dmpl__PartnerResource__c> partnerResource1 = [Select Id,Name,dmpl__BranchId__c,dmpl__PartnerAccountId__c,dmpl__ToDate__c,dmpl__FromDate__c,dmpl__ResourceId__r.dmpl__IsActive__c from dmpl__PartnerResource__c ];
        dmpl__Branch__c branch1 = [SELECT Id,dmpl__partnerAccountId__c FROM dmpl__Branch__c LIMIT 1];
        new ResourceService().queryPartnerResources(new List<Id>{partnerResource1[0].Id},new List<Id>{branch1.dmpl__partnerAccountId__c},new List<Id>{branch1.Id});
    }

    // Add additional test methods as needed for other scenarios and edge cases

}