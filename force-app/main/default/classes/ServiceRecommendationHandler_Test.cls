@isTest
public with sharing class ServiceRecommendationHandler_Test {
    @TestSetup
    static void createRequiredData() {
        dmpl__AccountGroup__c accountGroup = TestDataHelpers.createAccountGroup();
        Account account = TestDataHelpers.createAccount(accountGroup);
        Account customerAccount = TestDataHelpers.createCustomerAccount();
        Account partnerAccount = TestDataHelpers.createPartnerAccount();
        dmpl__Branch__c branch =TestDataHelpers.createBranch(partnerAccount);   
        dmpl__Resource__c resource =TestDataHelpers.createResource(partnerAccount, branch);
        dmpl__Item__c item = TestDataHelpers.createItem();
        dmpl__SKU__c sku =TestDataHelpers.createSKU(item);
        dmpl__BranchTimeSlot__c branchTimeSlot = TestDataHelpers.createBranchTimeSlot(branch, item);
        dmpl__StorageLocation__c storageLocation = TestDataHelpers.createStorageLocation(branch); 
        dmpl__ItemLot__c itemLot = TestDataHelpers.createItemLot(branch, item, sku, storageLocation);
        Asset asset = ServiceCampaignTestDataHelpers.CreateAsset(account, branch, item, itemLot, sku);
        dmpl__ChecklistTemplate__c checklistTemplate = ChecklistTemplateTestDataHelpers.createChecklistTemplate(resource, item, partnerAccount, account, accountGroup);
        dmpl__CheckListTemplateLine__c checklistTemplateLine =  ChecklistTemplateTestDataHelpers.createChecklistTemplateLine(checklistTemplate);
        dmpl__TaxGroup__c taxGroup = TestDataHelpers.createTaxGroup(partnerAccount, branch);
        dmpl__ItemServiceContract__c itemServiceContract = ServiceCampaignTestDataHelpers.createItemServiceContract(item, sku);
        dmpl__PriceList__c priceList = TestDataHelpers.createPriceList(partnerAccount, branch); 
        dmpl__PriceListRules__c priceListRules = TestDataHelpers.createPriceListRules(priceList, item);
        dmpl__ServiceRequest__c serviceRequest = ServiceRequestTestDataHelpers.createServiceRequest(customerAccount, branch, item, asset, branchTimeSlot);
        dmpl__ServiceRequestline__c serviceRequestLine = ServiceRequestTestDataHelpers.createServiceRequestLine(serviceRequest, item, sku);
        dmpl__Quote__c serviceEstimateQuote = QuoteTestDataHelpers.CreateServiceEstimate(branch, customerAccount, priceList, asset, serviceRequest, item, taxGroup);
        dmpl__QuoteLine__c quoteLine =  QuoteTestDataHelpers.CreateServiceEstimateLine(item, priceListRules, taxGroup, null, serviceEstimateQuote);
        dmpl__Complaint__c complaint = ComplaintTestDataHelpers.createComplaint();
        dmpl__ComplaintLine__c complaintLine =  ComplaintTestDataHelpers.createComplaintLine(serviceRequest, item, serviceEstimateQuote, complaint);
        dmpl__ComplaintFault__c complaintFault =  ComplaintTestDataHelpers.createComplaintFault(complaint);
        dmpl__ComplaintItem__c complaintItem = ComplaintItemDataHandler.createComplaintItem(complaint, complaintFault, item);
        dmpl__ServiceRecommendation__c serviceRecommendation = ServiceRecommendationTestDataHelper.createServiceRecommendation(serviceRequest, serviceRequestLine, quoteLine, serviceEstimateQuote, item, complaintLine, complaintItem, asset);
    }

    @isTest
    static void createServiceRecommendation() {
        dmpl__ServiceRecommendation__c serviceRecommendation = ServiceRecommendationTestDataHelper.getServiceRecommendation();
        System.assertNotEquals(serviceRecommendation, null, 'Service Recommendation should be created.');

        System.assertEquals(serviceRecommendation.dmpl__AcceptLabel__c, 'AceptanceLabel1', 'AcceptanceLabel should be AceptanceLabel1.');
        System.assertEquals(serviceRecommendation.dmpl__RecommendationRemarks__c, 'ActionReference1', 'Recommendation Remarks should be ActionReference1.');
        System.assertEquals(serviceRecommendation.dmpl__IsRejected__c, false, 'IsRejected should be false.');
        System.assertEquals(serviceRecommendation.dmpl__Recommendation__c, 'Recommendation1', 'Recommendation should be Recommendation1.');
        System.assertEquals(serviceRecommendation.dmpl__RejectLabel__c, 'RejectionLabel1', 'Rejection Label should be RejectionLabel1.');
    }

    @isTest
    static void updateServiceRecommendation() {
        dmpl__ServiceRecommendation__c serviceRecommendation = ServiceRecommendationTestDataHelper.getServiceRecommendation();
        System.assertNotEquals(serviceRecommendation, null, 'Service Recommendation should exist before update.');

        serviceRecommendation.dmpl__AcceptLabel__c = 'AceptanceLabel2';
        serviceRecommendation.dmpl__RecommendationRemarks__c = 'ActionReference2';
        serviceRecommendation.dmpl__IsRejected__c = true;
        serviceRecommendation.dmpl__Recommendation__c = 'Recommendation2';
        serviceRecommendation.dmpl__RejectLabel__c = 'RejectionLabel2';
        update serviceRecommendation;
        
        System.assertEquals(serviceRecommendation.dmpl__AcceptLabel__c, 'AceptanceLabel2', 'AcceptanceLabel should be AceptanceLabel2 after update.');
        System.assertEquals(serviceRecommendation.dmpl__RecommendationRemarks__c, 'ActionReference2', 'Recommendation Remarks should be ActionReference2 after update.');
        System.assertEquals(serviceRecommendation.dmpl__IsRejected__c, true, 'IsRejected should be true after update.');
        System.assertEquals(serviceRecommendation.dmpl__Recommendation__c, 'Recommendation2', 'Recommendation should be Recommendation2 after update.');
        System.assertEquals(serviceRecommendation.dmpl__RejectLabel__c, 'RejectionLabel2', 'RejectionLabel should be RejectionLabel2 after update.');
    }

    @isTest
    static void testDeleteServiceRecommendation() {
        dmpl__ServiceRecommendation__c serviceRecommendation = ServiceRecommendationTestDataHelper.getServiceRecommendation();
        System.assertNotEquals(serviceRecommendation, null, 'Service Recommendation should exist before delete.');
        Id serviceRecommendationId = serviceRecommendation.Id;
        
        delete serviceRecommendation;

        dmpl__ServiceRecommendation__c deletedServiceRecommendation = null;
        try {
            deletedServiceRecommendation = ServiceRecommendationTestDataHelper.getServiceRecommendation(serviceRecommendationId);
        } catch (Exception e) {
            deletedServiceRecommendation = null;
        }
        System.assertEquals(deletedServiceRecommendation, null, 'Service Request should be deleted and not found in query.');
    }
}