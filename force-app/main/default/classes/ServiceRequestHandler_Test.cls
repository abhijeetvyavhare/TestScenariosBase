@isTest
public with sharing class ServiceRequestHandler_Test {
    @TestSetup
    static void createRequiredData() {
        dmpl__AccountGroup__c accountGroup = TestDataHelpers.createAccountGroup();
        Account account = TestDataHelpers.createAccount(accountGroup);
        Account partnerAccount = TestDataHelpers.createPartnerAccount();
        Account customerAccount = TestDataHelpers.createCustomerAccount();        
        dmpl__Branch__c branch =TestDataHelpers.createBranch(partnerAccount);   
        dmpl__Item__c item = TestDataHelpers.createItem();
        dmpl__SKU__c sku =TestDataHelpers.createSKU(item);
        dmpl__StorageLocation__c storageLocation = TestDataHelpers.createStorageLocation(branch); 
        dmpl__ItemLot__c itemLot = TestDataHelpers.createItemLot(branch, item, sku, storageLocation);
        Asset asset = ServiceCampaignTestDataHelpers.CreateAsset(account, branch, item, itemLot, sku);
        dmpl__BranchTimeSlot__c branchTimeSlot = TestDataHelpers.createBranchTimeSlot(branch, item);
        dmpl__ServiceRequest__c serviceRequest = ServiceRequestTestDataHelpers.createServiceRequest(customerAccount, branch, item, asset, branchTimeSlot);
        dmpl__ServiceRequestline__c serviceRequestLine = ServiceRequestTestDataHelpers.createServiceRequestLine(serviceRequest, item, sku);
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.createTaxGroup(partnerAccount, branch);
        dmpl__Tax__c tax = TestDataHelpers.createTax(taxGroup);
        dmpl__ServiceRequestTax__c ServiceRequestTax = ServiceRequestTestDataHelpers.createServiceRequestTax(serviceRequest, serviceRequestLine, taxGroup, tax);

    }

    @isTest
    static void createServiceRequestPositive() {
        dmpl__ServiceRequest__c serviceRequest = ServiceRequestTestDataHelpers.getServiceRequest();
        System.assertNotEquals(serviceRequest, null, 'Expected Service Request to be created.');
        System.assertEquals(serviceRequest.dmpl__AccountName__c, 'Account1', 'Account Name should be Account1.');
        System.assertEquals(serviceRequest.dmpl__AdjustedAdvanceAmount__c, 2000, 'Adjusted Amount should be 2000.');
        System.assertEquals(serviceRequest.dmpl__AdvanceAmount__c, 1000, 'Advance Amount should be 1000.');
        System.assertEquals(serviceRequest.dmpl__Status__c, 'Customer Requested', 'Status should be Customer Requested.');
        System.assertEquals(serviceRequest.dmpl__CustomerVoice__c, 'CustomerVoice1', 'Customer Voice should be CustomerVoice1.');
        
        dmpl__ServiceRequestline__c serviceRequestLine = ServiceRequestTestDataHelpers.getServiceRequestLine();
        System.assertNotEquals(serviceRequestLine, null, 'Expected Service Request Line to be created.');
        
        dmpl__ServiceRequestTax__c ServiceRequestTax = ServiceRequestTestDataHelpers.getServiceRequestTax();
        System.assertNotEquals(ServiceRequestTax, null, 'Expected Service Request Tax to be created.');

    }

    @isTest
    static void updateServiceRequestPositive() {
        dmpl__ServiceRequest__c serviceRequest = ServiceRequestTestDataHelpers.getServiceRequest();
        System.assertNotEquals(serviceRequest, null, 'Service Request should exist before update.');
        serviceRequest.dmpl__AccountName__c = 'Account 1 Updated';
        serviceRequest.dmpl__AdjustedAdvanceAmount__c = 3000 ;
        serviceRequest.dmpl__AdvanceAmount__c = 2000;
        serviceRequest.dmpl__Status__c = 'Confirmed';
        serviceRequest.dmpl__CustomerVoice__c = 'CustomerVoice2';
        update serviceRequest;

        dmpl__ServiceRequest__c updatedServiceRequest = ServiceRequestTestDataHelpers.getServiceRequest();
        System.assertEquals(updatedServiceRequest.dmpl__AccountName__c, 'Account 1 Updated', 'Account Name should be Account 1 Updated after update.');
        System.assertEquals(updatedServiceRequest.dmpl__AdjustedAdvanceAmount__c, 3000, 'Adjusted Amount should be 3000 after update.');
        System.assertEquals(updatedServiceRequest.dmpl__AdvanceAmount__c, 2000, 'Advance Amount should be 2000 after update.');
        System.assertEquals(updatedServiceRequest.dmpl__Status__c, 'Confirmed', 'Status should be Confirmed after update.');
        System.assertEquals(updatedServiceRequest.dmpl__CustomerVoice__c, 'CustomerVoice2', 'Customer Voice should be CustomerVoice2 after update.');
    }

    @isTest
    static void deleteServiceRequest() {
        dmpl__ServiceRequest__c serviceRequest = ServiceRequestTestDataHelpers.getServiceRequest();
        System.assertNotEquals(serviceRequest, null, 'Service Request should exist before delete.');
        Id serviceRequestId = serviceRequest.Id;
        delete serviceRequest;
        dmpl__ServiceRequest__c deletedServiceRequest = null;
        try {
            deletedServiceRequest = ServiceRequestTestDataHelpers.getServiceRequest(serviceRequestId);
        } catch (Exception e) {
            deletedServiceRequest = null;
        }
        System.assertEquals(deletedServiceRequest, null, 'Service Request should be deleted and not found in query.');
    }
}