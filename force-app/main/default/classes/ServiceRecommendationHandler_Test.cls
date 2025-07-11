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

        dmpl__Item__c  item1 = TestDataHelpers.createItem('Item 1','Product',true,false,false,'675654',false);
        dmpl__Item__c item2 = TestDataHelpers.createItem('Item 2','Product',false,false,false,'654345',false);
        dmpl__Item__c item8 = TestDataHelpers.createItem('Item 8','Product',true,false,false, '765456',false);
        dmpl__Item__c item5 = TestDataHelpers.createItem('Item 5', 'Product', true, false, false, '876543', false);
        Account customerAccount1 = TestDataHelpers.createCustomerAccount('Customer 1', true, false, false, true, 'MG Road', 'Pune', 'Maharashtra', 'India', '411001', 'Ring Rd', 'Nagpur', 'Maharashtra', 'India', '440001','9876543210', 'Created');
        Account customerAccount2 = TestDataHelpers.createCustomerAccount('Customer 2', true, false, false, true, 'Park St', 'Kolkata', 'West Bengal', 'India', '700016', 'Lake Rd', 'Kolkata', 'West Bengal', 'India', '700029','9876543210', 'Created');
        Account customerAccount3 = TestDataHelpers.createCustomerAccount('Customer 3', true, false, false, true, 'Anna Salai', 'Chennai', 'Tamil Nadu', 'India', '600002', 'T Nagar', 'Chennai', 'Tamil Nadu', 'India', '600017','9012345678', 'Created');


        Asset asset1 = AssetDataHelper.createAsset('Asset 1', customerAccount1.Id, item1.Id);
        Asset asset3 = AssetDataHelper.createAsset('Asset 3', customerAccount3.Id, item5.Id);
 


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
    @isTest
        static void createServiceRecommendationWithActiveItemPositive() {

        dmpl__Item__c item = TestDataHelpers.getItem('Item 8'); 
        Decimal quantity = 1;


        Test.startTest();
        dmpl__ServiceRecommendation__c createdRecommendation = 
            ServiceRecommendationTestDataHelper.createServiceRecommendationWithChecklistFields(
                 
                null, 
                quantity,
                item,null
            );
        Test.stopTest();

        dmpl__ServiceRecommendation__c fetchedRecommendation = 
            ServiceRecommendationTestDataHelper.getServiceRecommendationWithChecklistFields(createdRecommendation.Id);


        System.assertEquals(item.Id, fetchedRecommendation.dmpl__ItemId__c, 'Item should be Item 8');
        System.assertEquals(quantity, fetchedRecommendation.dmpl__Quantity__c, 'Quantity should be 1');
    }
    @isTest
    static void updateServiceRecommendationWithActiveItemPositive() {
    
    dmpl__Item__c item8 = TestDataHelpers.getItem('Item 8');
    dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
    Decimal initialQuantity = 10;

    
    Test.startTest();
    dmpl__ServiceRecommendation__c recommendation = 
        ServiceRecommendationTestDataHelper.createServiceRecommendationWithChecklistFields(
             null, initialQuantity, item8,null
            
        );



    recommendation.dmpl__ItemId__c = item1.Id;
    recommendation.dmpl__Quantity__c = initialQuantity;

    update recommendation;
    Test.stopTest();


    dmpl__ServiceRecommendation__c updatedRec =
        ServiceRecommendationTestDataHelper.getServiceRecommendationWithChecklistFields(recommendation.Id);

    System.assertEquals(item1.Id, updatedRec.dmpl__ItemId__c, 'Item should be updated to Item 1');
    System.assertEquals(initialQuantity, updatedRec.dmpl__Quantity__c, 'Quantity should remain 10');
}
@isTest
static void createServiceRecommendationWithInactiveItemNegative() {
    
    dmpl__Item__c inactiveItem = TestDataHelpers.getItem('Item 2'); 
    Decimal quantity = 1;
    Boolean exceptionThrown = false;

    Test.startTest();
    try {
        dmpl__ServiceRecommendation__c recommendation = 
            ServiceRecommendationTestDataHelper.createServiceRecommendationWithChecklistFields(
                 null, quantity, inactiveItem,null
            );
    } catch (Exception e) {
        exceptionThrown = true;
    }
    Test.stopTest();

    System.assertEquals(true, exceptionThrown, 'Exception should be thrown for inactive item');
}
@isTest
static void updateServiceRecommendationWithInactiveItemNegative() {
    dmpl__Item__c activeItem = TestDataHelpers.getItem('Item 8');
    dmpl__Item__c inactiveItem = TestDataHelpers.getItem('Item 2');
    Decimal quantity = 1;

    dmpl__ServiceRecommendation__c recommendation = 
        ServiceRecommendationTestDataHelper.createServiceRecommendationWithChecklistFields(
             null, quantity, activeItem,null
        );

    Boolean exceptionThrown = false;

    Test.startTest();
    try {
        recommendation.dmpl__ItemId__c = inactiveItem.Id;
        update recommendation;
    } catch (Exception e) {
        exceptionThrown = true;
    }
    Test.stopTest();

    System.assertEquals(true, exceptionThrown, 'Exception should be thrown while updating to inactive item');
}
// Service Recommendation creation with 0 quantity (New)
    @isTest
    static void createServiceRecommendationWithZeroQuantityNegative() {

        dmpl__Item__c item = TestDataHelpers.getItem('Item 8'); 
        Decimal quantity = 0;
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        Asset Asset=AssetDataHelper.getAsset('Asset 1');


        Test.startTest();
        dmpl__ServiceRecommendation__c createdRecommendation = 
            ServiceRecommendationTestDataHelper.createServiceRecommendationWithChecklistFields(
                
                null, 
                quantity,
                item1,
                asset
            );
        Test.stopTest();

        dmpl__ServiceRecommendation__c fetchedRecommendation = 
            ServiceRecommendationTestDataHelper.getServiceRecommendationWithChecklistFields(createdRecommendation.Id);


        System.assertEquals(item1.Id, fetchedRecommendation.dmpl__ItemId__c, 'Item should be Item 8');
        System.assertEquals(quantity, fetchedRecommendation.dmpl__Quantity__c, 'Quantity should be 1');
        System.assertEquals(asset.Id,fetchedRecommendation.dmpl__AssetId__c,'Asset should match ');
    }
    // Service Recommendation creation with Asset (New)
        @isTest
        static void createServiceRecommendationWithAssetPositive() {

        dmpl__Item__c item = TestDataHelpers.getItem('Item 1'); 
        Decimal quantity = 1;
         
         Asset asset=AssetDataHelper.getAsset('Asset 1');


        Test.startTest();
        dmpl__ServiceRecommendation__c createdRecommendation = 
            ServiceRecommendationTestDataHelper.createServiceRecommendationWithChecklistFields(
                
                null, 
                quantity,
                item,asset
            );
        Test.stopTest();

        dmpl__ServiceRecommendation__c fetchedRecommendation = 
            ServiceRecommendationTestDataHelper.getServiceRecommendationWithChecklistFields(createdRecommendation.Id);


        System.assertEquals(item.Id, fetchedRecommendation.dmpl__ItemId__c, 'Item should be Item 8');
        System.assertEquals(quantity, fetchedRecommendation.dmpl__Quantity__c, 'Quantity should be 1');
    }
    // Service Recommendation creation without Asset (New)
    @isTest
        static void createServiceRecommendationWithoutAssetPositive() {

        dmpl__Item__c item = TestDataHelpers.getItem('Item 8'); 
        Decimal quantity = 1;


        Test.startTest();
        dmpl__ServiceRecommendation__c createdRecommendation = 
            ServiceRecommendationTestDataHelper.createServiceRecommendationWithChecklistFields(
                
                null, 
                quantity,
                item,null
            );
        Test.stopTest();

        dmpl__ServiceRecommendation__c fetchedRecommendation = 
            ServiceRecommendationTestDataHelper.getServiceRecommendationWithChecklistFields(createdRecommendation.Id);


        System.assertEquals(item.Id, fetchedRecommendation.dmpl__ItemId__c, 'Item should be Item 8');
        System.assertEquals(quantity, fetchedRecommendation.dmpl__Quantity__c, 'Quantity should be 1');
    }
    // Service Recommendation creation with Checklist line (New)
    @isTest
static void CreateServiceRecommendationWithChecklistLinePositive() {
    dmpl__Item__c item8 = TestDataHelpers.getItem('Item 8');
    dmpl__CheckListLines__c checklistLine1 = ChecklistDataHelper.createChecklistLine('Checklist line 1');

    Test.startTest();
    dmpl__ServiceRecommendation__c recommendation = ServiceRecommendationTestDataHelper.createServiceRecommendationWithChecklistFields(
    checklistLine1,
    1,
    item8,null
    );
    dmpl__ServiceRecommendation__c fetchedRecommendation = ServiceRecommendationTestDataHelper.getServiceRecommendation(recommendation.Id);
    Test.stopTest();

    System.assertEquals(item8.Id, fetchedRecommendation.dmpl__ItemId__c, 'Item should be Item 8');
    System.assertEquals(1, fetchedRecommendation.dmpl__Quantity__c, 'Quantity should be 1');
    System.assertEquals(checklistLine1.Id, fetchedRecommendation.dmpl__ChecklistLineId__c, 'Checklist line should be Checklist line 1');
}

    @isTest
static void UpdateServiceRecommendationWithChecklistLinePositive() {
    dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
    dmpl__Item__c item8 = TestDataHelpers.getItem('Item 8');
    dmpl__CheckListLines__c checklistLine1 = ChecklistDataHelper.createChecklistLine('Checklist line 1');
    dmpl__CheckListLines__c checklistLine2 = ChecklistDataHelper.createChecklistLine('Checklist line 2');

    dmpl__ServiceRecommendation__c recommendation = ServiceRecommendationTestDataHelper.createServiceRecommendationWithChecklistFields(
        checklistLine2,1,item1,null
    );

    Test.startTest();
    dmpl__ServiceRecommendation__c fetchedRecommendation = ServiceRecommendationTestDataHelper.getServiceRecommendation(recommendation.Id);
    fetchedRecommendation.dmpl__ChecklistLineId__c=checklistLine2.Id;
    update fetchedRecommendation;
    Test.stopTest();

    dmpl__ServiceRecommendation__c updatedRecommendation = ServiceRecommendationTestDataHelper.getServiceRecommendation(recommendation.Id);

    System.assertEquals(item1.Id, updatedRecommendation.dmpl__ItemId__c, 'Item should be updated to Item 8');
    System.assertEquals(1, updatedRecommendation.dmpl__Quantity__c, 'Quantity should remain 1');
    System.assertEquals(checklistLine2.Id, updatedRecommendation.dmpl__ChecklistLineId__c, 'Checklist line should remain Checklist line 1');
}

}