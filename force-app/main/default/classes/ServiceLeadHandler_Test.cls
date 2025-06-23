@isTest
public with sharing class ServiceLeadHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Account partnerAccount = TestDataHelpers.createPartnerAccount();
        Account customerAccount = TestDataHelpers.createCustomerAccount();        
        dmpl__Branch__c branch =TestDataHelpers.createBranch(partnerAccount);   
        dmpl__Resource__c resource =TestDataHelpers.createResource(partnerAccount, branch);  
        dmpl__ServiceLead__c serviceLead = ServiceLeadTestDataHelpers.createServiceLead(branch, customerAccount, resource);
    }

    @isTest
    static void createServiceLeadPositive() {
        dmpl__ServiceLead__c serviceLead = ServiceLeadTestDataHelpers.getServiceLead();
        System.assertNotEquals(serviceLead, null, 'Expected Service Lead to be created.');

        System.assertEquals(serviceLead.dmpl__ContactName__c, 'Contact1', 'Contact Name should be Contact1.');
        System.assertEquals(serviceLead.dmpl__LeadRating__c, 'Hot', 'Lead Rating should be Hot.');
        System.assertEquals(serviceLead.dmpl__ReminderOffsetNumber__c, 2, 'Reminder Off Set Number should be 2.');
        System.assertEquals(serviceLead.dmpl__Status__c, 'Draft', 'Lead Status should be Draft.');
        System.assertEquals(serviceLead.dmpl__LeadSource__c, 'None', 'Lead Source should be None.');
        System.assertEquals(serviceLead.dmpl__LeadType__c, 'Recall', 'Lead Type should be Recall.');
    }

    @isTest
    static void updateServiceLeadPositive() {
        dmpl__ServiceLead__c serviceLead = ServiceLeadTestDataHelpers.getServiceLead();
        System.assertNotEquals(serviceLead, null, 'Service Lead should exist before update.');
        serviceLead.dmpl__LeadRating__c = 'Warm';
        serviceLead.dmpl__ReminderOffsetNumber__c = 1;
        serviceLead.dmpl__Status__c = 'Qualified';
        serviceLead.dmpl__ContactName__c = 'Contact2';
        serviceLead.dmpl__LeadSource__c = 'None';
        serviceLead.dmpl__LeadType__c = 'Manual';
        update serviceLead;

        dmpl__ServiceLead__c UpdatedServiceLead = ServiceLeadTestDataHelpers.getServiceLead();
        System.assertEquals(UpdatedServiceLead.dmpl__LeadRating__c, 'Warm', 'Lead Rating should be Warm after update.');
        System.assertEquals(UpdatedServiceLead.dmpl__ReminderOffsetNumber__c, 1, 'Reminder Off Set Number should be 1 after update.');
        System.assertEquals(UpdatedServiceLead.dmpl__Status__c, 'Qualified', 'Lead Status should be Qualified after update.');
        System.assertEquals(UpdatedServiceLead.dmpl__ContactName__c, 'Contact2', 'Contact Name should be updated to Contact2');
        System.assertEquals(UpdatedServiceLead.dmpl__LeadSource__c, 'None', 'Lead Source should be updated to None');
        System.assertEquals(UpdatedServiceLead.dmpl__LeadType__c, 'Manual', 'Lead Type should be updated to Manual');
    }

    @isTest
    static void deleteServiceLead() {
        dmpl__ServiceLead__c serviceLead = ServiceLeadTestDataHelpers.getServiceLead();
        System.assertNotEquals(serviceLead, null, 'Service Lead should exist before delete.');
        Id serviceLeadId = serviceLead.Id;
        delete serviceLead;
        dmpl__ServiceLead__c deletedserviceLead = null;
        try {
            deletedserviceLead = ServiceLeadTestDataHelpers.getServiceLead(serviceLeadId);
        } catch (Exception e) {
            deletedserviceLead = null;
        }
        System.assertEquals(deletedserviceLead, null, 'Service Lead should be deleted and not found in query.');
    }
}