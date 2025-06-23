@isTest
public with sharing class PartnerResourceHandler_Test {
    @TestSetup
    static void createRequiredData(){
        Account partnerAccount = TestDataHelpers.createPartnerAccount();
        dmpl__Branch__c branch = TestDataHelpers.createBranch(partnerAccount);
        dmpl__Resource__c resource = TestDataHelpers.createResource(partnerAccount, branch);
        dmpl__PartnerResource__c partnerResource = PartnerResourceDataHelper.createPartnerResource(partnerAccount, branch, resource);
    }

    @isTest
    static void testInsertPartnerResource() {
        dmpl__PartnerResource__c partnerResource = PartnerResourceDataHelper.getPartnerResource();
        System.assert(partnerResource != null && partnerResource.Id != null, 'Partner Resource should be inserted.');
    }

    @isTest
    static void testUpdatePartnerResource() {
        dmpl__PartnerResource__c partnerResource = PartnerResourceDataHelper.getPartnerResource();
        partnerResource.dmpl__FromDate__c = Date.today().addMonths(1);
        partnerResource.dmpl__ToDate__c = Date.today().addMonths(3);
        partnerResource.dmpl__AssignmentSequenceNumber__c = 4;
        update partnerResource;

        dmpl__PartnerResource__c updatedResource = PartnerResourceDataHelper.getPartnerResource();

        System.assertEquals(Date.today().addMonths(1), updatedResource.dmpl__FromDate__c, 'FromDate should be updated.');
        System.assertEquals(Date.today().addMonths(3), updatedResource.dmpl__ToDate__c, 'ToDate should be updated.');
        System.assertEquals(4, updatedResource.dmpl__AssignmentSequenceNumber__c, 'AssignmentSequenceNumber should be updated.');
    }

    @isTest
    static void testDeletePartnerResource() {
        dmpl__PartnerResource__c partnerResource = PartnerResourceDataHelper.getPartnerResource();
        String resourceId = (String) partnerResource.Id;
        delete partnerResource;
        dmpl__PartnerResource__c deletedResource;
        try {
            deletedResource = PartnerResourceDataHelper.getPartnerResource();
        } catch (Exception e) {
            deletedResource = null;
        }
        System.assert(deletedResource == null, 'Partner Resource should be deleted.');
    }
}