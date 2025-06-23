@isTest
public with sharing class ComplaintLineHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Account partnerAccount = TestDataHelpers.createPartnerAccount();
        Account customerAccount = TestDataHelpers.createCustomerAccount();
        dmpl__Branch__c branch = TestDataHelpers.createBranch(partnerAccount);
        dmpl__ContactAddress__c contactAddress = TestDataHelpers.createContactAddress(customerAccount);
        dmpl__Item__c item = TestDataHelpers.createItem();
        dmpl__SKU__c sku = TestDataHelpers.createSKU(item);
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.createTaxGroup(partnerAccount, branch);
        dmpl__PriceList__c priceList = TestDataHelpers.createPriceList(partnerAccount, branch);
        dmpl__PriceListRules__c priceListRule = TestDataHelpers.createPriceListRules(priceList, item);
        dmpl__Complaint__c complaint = ComplaintTestDataHelpers.createComplaint();
        dmpl__ComplaintFault__c complaintFault = ComplaintTestDataHelpers.createComplaintFault(complaint);
        ComplaintLineDataHandler.createComplaintLine(complaint, complaintFault);
    }
    
    @isTest
    static void createComplaintLinePositive() {
        dmpl__Complaint__c complaint = ComplaintTestDataHelpers.getComplaint();
        dmpl__ComplaintLine__c line = ComplaintLineDataHandler.getComplaintLineByComplaint(complaint.Id);
        System.assertEquals(complaint.Id, line.dmpl__ComplaintId__c, 'ComplaintId should match.');
    }

     @isTest
    static void updateComplaintLinePositive() {
        dmpl__Complaint__c complaint = ComplaintTestDataHelpers.getComplaint();
        dmpl__ComplaintLine__c line = ComplaintLineDataHandler.getComplaintLineByComplaint(complaint.Id);
        System.assertNotEquals(null, line, 'ComplaintLine should exist before update.');

        
        line.dmpl__ExternalId__c = 'CL-EXT-UPDATED';
        update line;

        dmpl__ComplaintLine__c updatedLine = ComplaintLineDataHandler.getComplaintLineById(line.Id);
        System.assertEquals('CL-EXT-UPDATED', updatedLine.dmpl__ExternalId__c, 'ExternalId should be updated.');
    }
    
    @isTest
    static void deleteComplaintLine() {
        dmpl__Complaint__c complaint = ComplaintTestDataHelpers.getComplaint();
        dmpl__ComplaintLine__c line = ComplaintLineDataHandler.getComplaintLineByComplaint(complaint.Id);
        Integer count = ComplaintLineDataHandler.deleteComplaintLine(line);
        System.assertEquals(0, count, 'ComplaintLine should be deleted.');
    }
}