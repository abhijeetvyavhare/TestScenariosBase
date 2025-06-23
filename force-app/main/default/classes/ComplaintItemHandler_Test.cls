@isTest
public with sharing class ComplaintItemHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Account partnerAccount = TestDataHelpers.createPartnerAccount();
        Account customerAccount = TestDataHelpers.createCustomerAccount();
        dmpl__Branch__c branch = TestDataHelpers.createBranch(partnerAccount);
        dmpl__Item__c item = TestDataHelpers.createItem();
        dmpl__Complaint__c complaint = ComplaintTestDataHelpers.createComplaint();
        dmpl__ComplaintFault__c complaintFault = ComplaintTestDataHelpers.createComplaintFault(complaint);

        ComplaintItemDataHandler.createComplaintItem(complaint, complaintFault, item);
    }

    @isTest
    static void createComplaintItemPositive() {
        dmpl__Complaint__c complaint = ComplaintTestDataHelpers.getComplaint();
        dmpl__ComplaintItem__c complaintItem = ComplaintItemDataHandler.getComplaintItemByComplaint(complaint.Id);
        System.assertNotEquals(null, complaintItem, 'ComplaintItem should be created.');
        System.assertEquals(complaint.Id, complaintItem.dmpl__ComplaintId__c, 'ComplaintId should match.');
    }

    @isTest
    static void updateComplaintItemPositive() {
        dmpl__ComplaintItem__c complaintItem = ComplaintItemDataHandler.getComplaintItem();
        System.assertNotEquals(null, complaintItem, 'ComplaintItem should exist before update.');

        complaintItem.dmpl__Quantity__c = 5;
        update complaintItem;

        dmpl__ComplaintItem__c updatedItem = ComplaintItemDataHandler.getComplaintItemByComplaint(complaintItem.dmpl__ComplaintId__c);
        System.assertEquals(5, updatedItem.dmpl__Quantity__c, 'Quantity should be updated.');
    }

    @isTest
    static void deleteComplaintItem() {
        dmpl__ComplaintItem__c complaintItem = ComplaintItemDataHandler.getComplaintItem();
        System.assertNotEquals(null, complaintItem, 'ComplaintItem should exist before delete.');

        delete complaintItem;

        dmpl__ComplaintItem__c deletedItem = null;
        try {
            deletedItem = ComplaintItemDataHandler.getComplaintItemByComplaint(complaintItem.dmpl__ComplaintId__c);
        } catch (Exception e) {
            deletedItem = null;
        }
        System.assertEquals(null, deletedItem, 'ComplaintItem should be deleted and not found in query.');
    }
}