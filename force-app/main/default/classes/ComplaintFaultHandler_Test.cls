@isTest
public with sharing class ComplaintFaultHandler_Test {
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
                ComplaintFaultDataHandler.createComplaintFault(complaint,item,null);

    }

    @isTest
    static void createComplaintFaultPositive() {
        dmpl__ComplaintFault__c fault = ComplaintFaultDataHandler.getComplaintFault();
        System.assertEquals('37592', fault.dmpl__FaultCode__c,'Complaint Code should match.');
        System.assertEquals('Text', fault.dmpl__Description__c, 'Complaint Description should match.');
    }

    @isTest
    static void updateComplaintFaultPositive() {
        dmpl__ComplaintFault__c fault = ComplaintFaultDataHandler.getComplaintFault();
        dmpl__ComplaintFault__c updated = ComplaintFaultDataHandler.updateComplaintFault(fault, 'Updated Description');
        System.assertEquals('Updated Description', updated.dmpl__Description__c, 'Description should be updated.');
    }

    @isTest
    static void deleteComplaintFault() {
        dmpl__ComplaintFault__c fault = ComplaintFaultDataHandler.getComplaintFault();
        Integer count = ComplaintFaultDataHandler.deleteComplaintFault(fault);
        System.assertEquals(0, count, 'ComplaintFault should be deleted.');
    }
}