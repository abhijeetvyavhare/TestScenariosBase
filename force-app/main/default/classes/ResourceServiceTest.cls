@IsTest
public class ResourceServiceTest {
    
    @TestSetup
    static void setupTestData() {
        createTestData();

        ResourceService resourceService = new ResourceService();
        List<dmpl__Resource__c> resources = [SELECT Id FROM dmpl__Resource__c];
        resourceService.validateDefaultPartnerAndBranch(resources);
    }

    static void createTestData() {
        Account partnerAccount1 = new Account(Name = 'Partner Account 1');
        insert partnerAccount1;
        
        Account partnerAccount2 = new Account(Name = 'Partner Account 2');
        insert partnerAccount2;

        dmpl__Branch__c branch1 = new dmpl__Branch__c(Name = 'Branch 1');
        insert branch1;

        dmpl__Branch__c branch2 = new dmpl__Branch__c(Name = 'Branch 2');
        insert branch2;

        dmpl__Resource__c resource1 = new dmpl__Resource__c(
            Name = 'Resource 1',
            dmpl__DefaultPartnerAccountId__c = partnerAccount1.Id,
            dmpl__DefaultBranchId__c = branch1.Id
        );
        insert resource1;

        dmpl__Resource__c resource2 = new dmpl__Resource__c(
            Name = 'Resource 2',
            dmpl__DefaultPartnerAccountId__c = partnerAccount2.Id,
            dmpl__DefaultBranchId__c = branch2.Id
        );
        insert resource2;

        dmpl__PartnerResource__c partnerResource1 = new dmpl__PartnerResource__c(
            dmpl__ResourceId__c = resource1.Id,
            dmpl__PartnerAccountId__c = partnerAccount1.Id,
            dmpl__BranchId__c = branch1.Id,
            dmpl__FromDate__c = Date.today().addDays(-10),
            dmpl__ToDate__c = Date.today().addDays(10)
        );
        insert partnerResource1;

        dmpl__PartnerResource__c partnerResource2 = new dmpl__PartnerResource__c(
            dmpl__ResourceId__c = resource2.Id,
            dmpl__PartnerAccountId__c = partnerAccount2.Id,
            dmpl__BranchId__c = branch2.Id,
            dmpl__FromDate__c = Date.today().addDays(-5),
            dmpl__ToDate__c = Date.today().addDays(5)
        );
        insert partnerResource2;
    }

    @IsTest
    static void testValidateResource() {
        dmpl__Resource__c resource1 = [SELECT Id, Name, dmpl__DefaultPartnerAccountId__c, dmpl__DefaultBranchId__c FROM dmpl__Resource__c WHERE Name = 'Resource 1' LIMIT 1];
        dmpl__Resource__c resource2 = [SELECT Id, Name, dmpl__DefaultPartnerAccountId__c, dmpl__DefaultBranchId__c FROM dmpl__Resource__c WHERE Name = 'Resource 2' LIMIT 1];

        List<SObject> newEntries = new List<SObject>{resource1, resource2};

        ResourceService resourceService = new ResourceService();
        resourceService.validateResource('Id', newEntries);

        System.assertEquals(0, ((List<SObject>)newEntries).get(0).getErrors().size());
        System.assertEquals(0, ((List<SObject>)newEntries).get(1).getErrors().size());
    }
    
    @IsTest
    static void testValidateDefaultPartnerAndBranch() {
        List<dmpl__Resource__c> resources = [SELECT Id, Name, dmpl__DefaultPartnerAccountId__c, dmpl__DefaultBranchId__c FROM dmpl__Resource__c];

        ResourceService resourceService = new ResourceService();
        resourceService.validateDefaultPartnerAndBranch(resources);

        for (dmpl__Resource__c resource : resources) {
            System.assertEquals(0, resource.getErrors().size());
        }
    }
}