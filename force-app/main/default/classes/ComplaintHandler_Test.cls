@isTest
public with sharing class ComplaintHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Account partnerAccount = TestDataHelpers.createPartnerAccount();
        Account customerAccount = TestDataHelpers.createCustomerAccount();
        dmpl__Branch__c branch = TestDataHelpers.createBranch(partnerAccount);
        dmpl__ContactAddress__c contactAddress = TestDataHelpers.createContactAddress(customerAccount);
        dmpl__Complaint__c complaint = ComplaintTestDataHelpers.createComplaint();
    }
    
    @isTest
    static void createComplaintPositive() {
        dmpl__Complaint__c complaint = ComplaintTestDataHelpers.getComplaint();
        System.assertNotEquals(null, complaint, 'Complaint should be created.');
        System.assertEquals('Complaint-Test', complaint.Name, 'Complaint Name should match.');
        System.assertEquals('37592', complaint.dmpl__Code__c, 'Complaint Code should match.');
        System.assertEquals('Text', complaint.dmpl__Description__c, 'Complaint Description should match.');
    }
    
    @isTest
    static void updateComplaintPositive() {
        dmpl__Complaint__c complaint = ComplaintTestDataHelpers.getComplaint();
        complaint.dmpl__Description__c = 'Updated Description';
        update complaint;
        dmpl__Complaint__c updated = ComplaintTestDataHelpers.getComplaintById(complaint.Id);
        System.assertEquals('Updated Description', updated.dmpl__Description__c, 'Description should be updated.');
    }
    
    @isTest
    static void deleteComplaint() {
        dmpl__Complaint__c complaint = ComplaintTestDataHelpers.getComplaint();
        delete complaint;
        Integer count = ComplaintTestDataHelpers.getComplaintCountById(complaint.Id);
        System.assertEquals(0, count, 'Complaint should be deleted.');
    }
}