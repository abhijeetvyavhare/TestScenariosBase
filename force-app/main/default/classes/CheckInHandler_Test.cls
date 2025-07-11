@isTest
public with sharing class CheckInHandler_Test {
    @TestSetup
    static void createRequiredData(){
        DateTime checkInDateTime = DateTime.newInstance(2026, 10, 1, 10, 0, 0);
        dmpl__CheckInInspection__c checkInInspection = CheckInDataHelper.createCheckInInspection(checkInDateTime);
        dmpl__CheckInInspectionLine__c checkInInspectionLine = CheckInDataHelper.createCheckInInspectionLine(checkInInspection.Id, 'Exterior');
        String CheckInTemplateExternalId = 'ExternalIDTEST123';
        dmpl__CheckInTemplate__c CheckInTemplate = CheckInDataHelper.createCheckInTemplate(CheckInTemplateExternalId);
        dmpl__CheckInTemplateLine__c CheckInTemplateLine = CheckInDataHelper.createCheckInTemplateLine('Front',CheckInTemplate.Id);
        Account partnerAccount = TestDataHelpers.createPartnerAccount();
        Account customerAccount = TestDataHelpers.createCustomerAccount();
        dmpl__Branch__c branch = TestDataHelpers.createBranch(partnerAccount);
        dmpl__Resource__c serviceAdvisor=ResourceDataHelper.createServiceAdvisor();

        Account partnerAccount1 = TestDataHelpers.createPartnerAccount('Partner 1', false, true, false, true, 'MG Road', 'Bengaluru', 'Karnataka', 'India', '560001', '56 Industrial Layout', 'Bengaluru', 'Karnataka', 'India', '560095','9876543210');
        Account partnerAccount2 = TestDataHelpers.createPartnerAccount('Partner 2', false, true, false, false, '45 Residency Road', 'Pune', 'Maharashtra', 'India', '411001', '22 Commerce Avenue', 'Pune', 'Maharashtra', 'India', '411038','91-99665544433');
        Account partnerAccount3 = TestDataHelpers.createPartnerAccount('Partner 3', false, true, false, true, '78 Nehru Nagar Road', 'Chennai', 'Tamil Nadu', 'India', '600042', '78 Nehru Nagar Road', 'Chennai', 'Tamil Nadu', 'India', '600042', '91-9123456789');
    
        Account customerAccount1 = TestDataHelpers.createCustomerAccount('Customer 1', true, false, false, true, 'MG Road', 'Pune', 'Maharashtra', 'India', '411001', 'Ring Rd', 'Nagpur', 'Maharashtra', 'India', '440001','9876543210', 'Created');
        Account customerAccount6=TestDataHelpers.createCustomerAccount('Customer 6', true, false, false, true, 'Sector 18', 'Noida', 'Uttar Pradesh', 'India', '201301', 'Sector 62', 'Noida', 'Uttar Pradesh', 'India', '201309','9876501234', 'Created');
        Account customerAccount3 = TestDataHelpers.createCustomerAccount('Customer 3', true, false, false, true, 'Anna Salai', 'Chennai', 'Tamil Nadu', 'India', '600002', 'T Nagar', 'Chennai', 'Tamil Nadu', 'India', '600017','9012345678', 'Created');
        Account customerAccount7=TestDataHelpers.createCustomerAccount('Customer 7', true, false, false, false, 'Mission Road', 'Bengaluru', 'Karnataka', 'India', '560027', 'Indiranagar', 'Bengaluru', 'Karnataka', 'India', '560038','9811122233', 'Created');

        dmpl__Branch__c branch1=TestDataHelpers.createBranch('Branch 1', partnerAccount1.Id, true, true, false, true);
        // dmpl__Branch__c branch2 = TestDataHelpers.createBranch('Branch 2', partnerAccount2.Id, true, false, true, true);
        dmpl__Branch__c branch3 = TestDataHelpers.createBranch('Branch 3', partnerAccount1.Id, false, true, true, false);

        dmpl__Item__c  item1 = TestDataHelpers.createItem('Item 1','Product',true,false,false,'675654',false);
        dmpl__Item__c item2 = TestDataHelpers.createItem('Item 2','Product',false,false,false,'654345',false);
        dmpl__Item__c item3 = TestDataHelpers.createItem('Item 3','Charge Item',true, false, false ,'765434',true);
         dmpl__Item__c item5 = TestDataHelpers.createItem('Item 5', 'Product', true, false, false, '876543', false);
         dmpl__Item__c item8 = TestDataHelpers.createItem('Item 8','Product',true,false,false, '765456',false);
    }

    @isTest
    static void createCheckInInspectionPositive() {
        DateTime checkInDateTime = DateTime.newInstance(2026, 10, 1, 10, 0, 0);
        dmpl__CheckInInspection__c checkInInspection = CheckInDataHelper.getCheckInInspectionByDateTime(checkInDateTime);
        System.assertNotEquals(checkInInspection, null, 'Expected check-in inspection to be created.');
    }

    @isTest
    static void updateCheckInInspectionPositive() {
        DateTime checkInDateTime = DateTime.newInstance(2026, 10, 1, 10, 0, 0);
        dmpl__CheckInInspection__c checkInInspection = CheckInDataHelper.getCheckInInspectionByDateTime(checkInDateTime);
        checkInInspection.dmpl__CheckInDateTime__c = DateTime.newInstance(2026, 10, 1, 12, 0, 0);
        Test.startTest();
        update checkInInspection;
        Test.stopTest();
        dmpl__CheckInInspection__c updated = CheckInDataHelper.getCheckInInspectionById(checkInInspection.Id);
        System.assertEquals(updated.dmpl__CheckInDateTime__c, DateTime.newInstance(2026, 10, 1, 12, 0, 0), 'Check-in inspection date time should be updated.');
    }

    @isTest
    static void deleteCheckInInspectionPositive() {
        DateTime checkInDateTime = DateTime.newInstance(2026, 10, 1, 10, 0, 0);
        dmpl__CheckInInspection__c checkInInspection = CheckInDataHelper.getCheckInInspectionByDateTime(checkInDateTime);
        Test.startTest();
        delete checkInInspection;
        Test.stopTest();
        dmpl__CheckInInspection__c deletedInspection = CheckInDataHelper.getCheckInInspectionById(checkInInspection.Id);
        System.assertEquals(deletedInspection, null, 'Check-in inspection should be deleted.');
    }

    @isTest
    static void createCheckInInspectionLinePositive(){
        dmpl__CheckInInspectionLine__c checkInInspectionLine = CheckInDataHelper.getCheckInInspectionLineBySection('Exterior');
        System.assertNotEquals(checkInInspectionLine, null, 'Expected check-in inspection line to be created.');
    }

    @isTest
    static void updateCheckInInspectionLinePositive() {
        dmpl__CheckInInspectionLine__c checkInInspectionLine = CheckInDataHelper.getCheckInInspectionLineBySection('Exterior');
        checkInInspectionLine.dmpl__Section__c = 'Interior';
        Test.startTest();
        update checkInInspectionLine;
        Test.stopTest();
        dmpl__CheckInInspectionLine__c updatedLine = CheckInDataHelper.getCheckInInspectionLineById(checkInInspectionLine.Id);
        System.assertEquals(updatedLine.dmpl__Section__c, 'Interior', 'Check-in inspection line section should be updated.');
    }

    @isTest
    static void deleteCheckInInspectionLinePositive() {
        dmpl__CheckInInspectionLine__c checkInInspectionLine = CheckInDataHelper.getCheckInInspectionLineBySection('Exterior');
        Test.startTest();
        delete checkInInspectionLine;
        Test.stopTest();
        dmpl__CheckInInspectionLine__c deletedLine = CheckInDataHelper.getCheckInInspectionLineById(checkInInspectionLine.Id);
        System.assertEquals(deletedLine, null, 'Check-in inspection line should be deleted.');
    }

    @isTest
    static void createCheckInTemplatePositive() {
        String CheckInTemplateExternalId = 'ExternalIDTEST123';
        dmpl__CheckInTemplate__c CheckInTemplate = CheckInDataHelper.getCheckInTemplateByExternalId(CheckInTemplateExternalId);
        System.assertNotEquals(CheckInTemplate, null, 'Expected CheckIn template to be created.');
    }

    @isTest
    static void updateCheckInTemplatePositive() {
        String CheckInTemplateExternalId = 'ExternalIDTEST123';
        dmpl__CheckInTemplate__c CheckInTemplate = CheckInDataHelper.getCheckInTemplateByExternalId(CheckInTemplateExternalId);
        CheckInTemplate.dmpl__ExternalId__c = 'Updated ExternalID';
        Test.startTest();
        update CheckInTemplate;
        Test.stopTest();
        dmpl__CheckInTemplate__c updated = CheckInDataHelper.getCheckInTemplateById(CheckInTemplate.Id);
        System.assertEquals(updated.dmpl__ExternalId__c, 'Updated ExternalID', 'CheckIn template name should be updated.');
    }

    @isTest
    static void deleteCheckInTemplatePositive() {
        String CheckInTemplateExternalId = 'ExternalIDTEST123';
        dmpl__CheckInTemplate__c CheckInTemplate = CheckInDataHelper.getCheckInTemplateByExternalId(CheckInTemplateExternalId);
        Test.startTest();
        delete CheckInTemplate;
        Test.stopTest();
        dmpl__CheckInTemplate__c deletedTemplate = CheckInDataHelper.getCheckInTemplateById(CheckInTemplate.Id);
        System.assertEquals(deletedTemplate, null, 'CheckIn template should be deleted.');
    }

    @isTest 
    static void createCheckInTemplateLinePositive() {
        dmpl__CheckInTemplateLine__c CheckInTemplateLine = CheckInDataHelper.getCheckInTemplateLineBySectionName('Front');
        System.assertNotEquals(CheckInTemplateLine, null, 'Expected CheckIn template line to be created.');
    }

    @isTest 
    static void updateCheckInTemplateLinePositive() {
        dmpl__CheckInTemplateLine__c CheckInTemplateLine = CheckInDataHelper.getCheckInTemplateLineBySectionName('Front');
        CheckInTemplateLine.dmpl__SectionName__c = 'Back';
        Test.startTest();
        update CheckInTemplateLine;
        Test.stopTest();
        dmpl__CheckInTemplateLine__c updatedLine = CheckInDataHelper.getCheckInTemplateLineById(CheckInTemplateLine.Id);
        System.assertEquals(updatedLine.dmpl__SectionName__c, 'Back', 'CheckIn template line section name should be updated.');
    }
    
    @isTest
    static void deleteCheckInTemplateLinePositive() {
        dmpl__CheckInTemplateLine__c CheckInTemplateLine = CheckInDataHelper.getCheckInTemplateLineBySectionName('Front');
        Test.startTest();
        delete CheckInTemplateLine;
        Test.stopTest();
        dmpl__CheckInTemplateLine__c deletedLine = CheckInDataHelper.getCheckInTemplateLineById(CheckInTemplateLine.Id);
        System.assertEquals(deletedLine, null, 'CheckIn template line should be deleted.');
    }

    // Check-Ins creation with correct partner and branch (New)
    @isTest
    static void createCheckInsWithCorrectPartnerandbranchPositive() {

        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');

        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        Asset asset = TestDataHelpers.createAsset('Asset 1', customer.Id, item1.Id);

        Test.startTest();
        dmpl__CheckInInspection__c createdCheckIn = CheckInDataHelper.CreateCheckIn(partner, customer, branch, asset);
        createdCheckIn.dmpl__DocumentDate__c = Date.today();
        Test.stopTest();

        dmpl__CheckInInspection__c fetchedCheckIn = CheckInDataHelper.GetCheckIn(createdCheckIn.Id);

        System.assertEquals(partner.Id, fetchedCheckIn.dmpl__PartnerAccountId__c, 'Partner should match');
        System.assertEquals(branch.Id, fetchedCheckIn.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(customer.Id, fetchedCheckIn.dmpl__AccountId__c, 'Customer should match');
        System.assertEquals(asset.Id, fetchedCheckIn.dmpl__AssetId__c, 'Asset should match');
        System.assertEquals(Date.today(), fetchedCheckIn.dmpl__DocumentDate__c);
        System.assertEquals('9876543210', fetchedCheckIn.dmpl__MobileNumber__c, 'Mobile number should be auto-tagged from customer');
        System.assertEquals('Draft', fetchedCheckIn.dmpl__Status__c, 'Status should be Draft');
    }
    // Check-Ins creation with wrong partner account (New)
        @isTest
    static void createCheckInsWithWrongPartnerAccountNegative() {
        Account partner3 = TestDataHelpers.getPartnerAccount('Partner 3'); // Assume this is inactive
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        Asset asset = TestDataHelpers.createAsset('Asset 1', customer1.Id, item1.Id); 

        Boolean exceptionThrown = false;

        Test.startTest();
        try {
            dmpl__CheckInInspection__c checkIn = CheckInDataHelper.CreateCheckIn(partner3, customer1, branch1, asset);
        } catch (System.DmlException e) {
            exceptionThrown = true;
        }
        Test.stopTest();

        System.assertEquals(true, exceptionThrown, 'Exception should be thrown due to inactive partner account.');
    }

    // Check-Ins creation with wrong partner account (Edit)
    @isTest
    static void updateCheckInswithWrongPartnerAccountNeagtive() {
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account partner3 = TestDataHelpers.getPartnerAccount('Partner 3');
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        Asset asset = TestDataHelpers.createAsset('Asset 1', customer1.Id, item1.Id);

        Boolean exceptionThrown = false;

        Test.startTest();
        dmpl__CheckInInspection__c createdCheckIn = CheckInDataHelper.CreateCheckIn(partner1, customer1, branch, asset);


        dmpl__CheckInInspection__c fetchedCheckIn = CheckInDataHelper.GetCheckIn(createdCheckIn.Id);

        System.assertEquals(partner1.Id, fetchedCheckIn.dmpl__PartnerAccountId__c, 'Partner should be Partner 1');
        System.assertEquals(branch.Id, fetchedCheckIn.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(customer1.Id, fetchedCheckIn.dmpl__AccountId__c, 'Customer should match');
        System.assertEquals(asset.Id, fetchedCheckIn.dmpl__AssetId__c, 'Asset should match');
        System.assertEquals(Date.today(), fetchedCheckIn.dmpl__DocumentDate__c, 'Document Date should be today');
        System.assertEquals('9876543210', fetchedCheckIn.dmpl__MobileNumber__c, 'Mobile number should auto-tag from customer');
        System.assertEquals('Draft', fetchedCheckIn.dmpl__Status__c, 'Status should be Draft');

        try {
            dmpl__CheckInInspection__c checkInToUpdate = CheckInDataHelper.GetCheckIn(fetchedCheckIn.Id);
            checkInToUpdate.dmpl__PartnerAccountId__c = partner3.Id;
            update checkInToUpdate;
        } catch (System.DmlException e) {
            exceptionThrown = true;
        }
        Test.stopTest();

        System.assertEquals(true, exceptionThrown, 'Exception should be thrown when updating with wrong partner account.');
    }

    // Check-Ins creation with inactive partner account (New)
    @isTest
    static void createCheckInsWithInactivePartnerAccountNegative() {

    Account partner2 = TestDataHelpers.getPartnerAccount('Partner 2'); 
    Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
    // dmpl__Branch__c branch2 = TestDataHelpers.getBranch('Branch 2');
    dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
    Asset asset = TestDataHelpers.createAsset('Asset 1', customer1.Id, item1.Id);


    Boolean exceptionThrown = false;

    Test.startTest();
    try {
        dmpl__CheckInInspection__c checkIn = CheckInDataHelper.CreateCheckIn(partner2, customer1, null, asset);
    } catch (System.DmlException e) {
        exceptionThrown = true;

    }
    Test.stopTest();

    System.assertEquals(true, exceptionThrown, 'Exception should be thrown because partner account is inactive.');
}

// Check-Ins creation with inactive partner account (Edit)
@isTest
static void upadteCheckInsWithInactivePartnerAccountNegative() {

    Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
    Account partner2 = TestDataHelpers.getPartnerAccount('Partner 2');
    dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1'); 

    Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
    dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
    Asset asset = TestDataHelpers.createAsset('Asset 1', customer1.Id, item1.Id); 

    Boolean exceptionThrown = false;

    Test.startTest();
    dmpl__CheckInInspection__c createdCheckIn = CheckInDataHelper.CreateCheckIn(partner1, customer1, branch1, asset);

    dmpl__CheckInInspection__c fetchedCheckIn = CheckInDataHelper.GetCheckIn(createdCheckIn.Id);

    System.assertEquals(partner1.Id, fetchedCheckIn.dmpl__PartnerAccountId__c, 'Partner should be Partner 1');
    System.assertEquals(customer1.Id, fetchedCheckIn.dmpl__AccountId__c, 'Customer should be Customer 1');
    System.assertEquals(asset.Id, fetchedCheckIn.dmpl__AssetId__c, 'Asset should be Asset 1');
    System.assertEquals(Date.today(), fetchedCheckIn.dmpl__DocumentDate__c, 'Document Date should be today');
    System.assertEquals('9876543210', fetchedCheckIn.dmpl__MobileNumber__c, 'Mobile number should auto-tag from customer');
    System.assertEquals('Draft', fetchedCheckIn.dmpl__Status__c, 'Status should be Draft');

    try {
        dmpl__CheckInInspection__c checkInToUpdate = CheckInDataHelper.GetCheckIn(fetchedCheckIn.Id);
        checkInToUpdate.dmpl__PartnerAccountId__c = partner2.Id;
        update checkInToUpdate;
    } catch (System.DmlException e) {
        exceptionThrown = true;

    }
    Test.stopTest();

    System.assertEquals(true, exceptionThrown, 'Exception should be thrown when updating with inactive partner account.');
}

// Check-Ins creation with wrong branch (New)
@isTest
static void createCheckInswithWrongBranchPositive() {

        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');

        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        Asset asset = TestDataHelpers.createAsset('Asset 1', customer.Id, item1.Id);

        Test.startTest();
        dmpl__CheckInInspection__c createdCheckIn = CheckInDataHelper.CreateCheckIn(partner, customer, branch, asset);
        createdCheckIn.dmpl__DocumentDate__c = Date.today();
        Test.stopTest();

        dmpl__CheckInInspection__c fetchedCheckIn = CheckInDataHelper.GetCheckIn(createdCheckIn.Id);

        System.assertEquals(partner.Id, fetchedCheckIn.dmpl__PartnerAccountId__c, 'Partner should match');
        System.assertEquals(branch.Id, fetchedCheckIn.dmpl__BranchId__c, 'Branch should match');
        System.assertEquals(customer.Id, fetchedCheckIn.dmpl__AccountId__c, 'Customer should match');
        System.assertEquals(asset.Id, fetchedCheckIn.dmpl__AssetId__c, 'Asset should match');
        System.assertEquals(Date.today(), fetchedCheckIn.dmpl__DocumentDate__c);
        System.assertEquals('9876543210', fetchedCheckIn.dmpl__MobileNumber__c, 'Mobile number should be auto-tagged from customer');
        System.assertEquals('Draft', fetchedCheckIn.dmpl__Status__c, 'Status should be Draft');
    }
// Check-Ins creation with wrong branch (Edit)
    @isTest
    static void updateCheckInswithWrongBranchPositive() {

        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        Asset asset = TestDataHelpers.createAsset('Asset 1', customer1.Id, item1.Id); 

        Test.startTest();
        dmpl__CheckInInspection__c createdCheckIn = CheckInDataHelper.CreateCheckIn(partner1, customer1, branch1, asset);

        dmpl__CheckInInspection__c fetchedCheckIn = CheckInDataHelper.GetCheckIn(createdCheckIn.Id);

        System.assertEquals(partner1.Id, fetchedCheckIn.dmpl__PartnerAccountId__c, 'Partner should be Partner 1');
        System.assertEquals(branch1.Id, fetchedCheckIn.dmpl__BranchId__c, 'Branch should be Branch 1');
        System.assertEquals(customer1.Id, fetchedCheckIn.dmpl__AccountId__c, 'Customer should be Customer 1');
        System.assertEquals(asset.Id, fetchedCheckIn.dmpl__AssetId__c, 'Asset should be Asset 1');
        System.assertEquals(Date.today(), fetchedCheckIn.dmpl__DocumentDate__c, 'Document Date should be today');
        System.assertEquals('9876543210', fetchedCheckIn.dmpl__MobileNumber__c, 'Mobile number should auto-tag from customer');
        System.assertEquals('Draft', fetchedCheckIn.dmpl__Status__c, 'Status should be Draft');

        dmpl__CheckInInspection__c checkInToUpdate = CheckInDataHelper.GetCheckIn(fetchedCheckIn.Id);
        checkInToUpdate.dmpl__PartnerAccountId__c = partner1.Id;
        checkInToUpdate.dmpl__BranchId__c = branch1.Id;
        checkInToUpdate.dmpl__AccountId__c = customer1.Id;
        checkInToUpdate.dmpl__AssetId__c = asset.Id;
        update checkInToUpdate;
        Test.stopTest();

        dmpl__CheckInInspection__c updatedCheckIn = CheckInDataHelper.GetCheckIn(fetchedCheckIn.Id);

        System.assertEquals(partner1.Id, updatedCheckIn.dmpl__PartnerAccountId__c, 'Partner should remain Partner 1');
        System.assertEquals(branch1.Id, updatedCheckIn.dmpl__BranchId__c, 'Branch should remain Branch 1');
        System.assertEquals(customer1.Id, updatedCheckIn.dmpl__AccountId__c, 'Customer should remain Customer 1');
        System.assertEquals(asset.Id, updatedCheckIn.dmpl__AssetId__c, 'Asset should remain Asset 1');
        System.assertEquals(Date.today(), updatedCheckIn.dmpl__DocumentDate__c, 'Document Date should remain unchanged');
        System.assertEquals('9876543210', updatedCheckIn.dmpl__MobileNumber__c, 'Mobile number should remain unchanged');
        System.assertEquals('Draft', updatedCheckIn.dmpl__Status__c, 'Status should remain Draft');
}
// Check-Ins creation with inactive branch (New)
@isTest
static void createCheckInswithInactiveBranchNegative() {
    Account partner3 = TestDataHelpers.getPartnerAccount('Partner 3');
    Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
    dmpl__Branch__c branch3 = TestDataHelpers.getBranch('Branch 3'); 
    dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
    Asset asset = TestDataHelpers.createAsset('Asset 1', customer1.Id, item1.Id); 

    Boolean exceptionThrown = false;
    Test.startTest();
    try {
        dmpl__CheckInInspection__c checkIn = CheckInDataHelper.CreateCheckIn(partner3, customer1, branch3, asset);
    } catch (System.DmlException e) {
        exceptionThrown = true;
    }
    Test.stopTest();

    System.assertEquals(true, exceptionThrown, 'Exception should be thrown due to inactive branch.');
}
    // Check-Ins creation with inactive branch (Edit)
    @isTest
    static void updateCheckInswithInactiveBranchNegative() {
    
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account partner3 = TestDataHelpers.getPartnerAccount('Partner 3');
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');

        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__Branch__c branch3 = TestDataHelpers.getBranch('Branch 3');

        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
    Asset asset = TestDataHelpers.createAsset('Asset 1', customer1.Id, item1.Id);

        Boolean exceptionThrown = false;

    
        Test.startTest();
        dmpl__CheckInInspection__c createdCheckIn = CheckInDataHelper.CreateCheckIn(partner1, customer1, branch1, asset);



        dmpl__CheckInInspection__c fetchedCheckIn = CheckInDataHelper.GetCheckIn(createdCheckIn.Id);

        System.assertEquals(partner1.Id, fetchedCheckIn.dmpl__PartnerAccountId__c, 'Partner should be Partner 1');
        System.assertEquals(branch1.Id, fetchedCheckIn.dmpl__BranchId__c, 'Branch should be Branch 1');
        System.assertEquals(customer1.Id, fetchedCheckIn.dmpl__AccountId__c, 'Customer should be Customer 1');
        System.assertEquals(asset.Id, fetchedCheckIn.dmpl__AssetId__c, 'Asset should be Asset 1');
        System.assertEquals(Date.today(), fetchedCheckIn.dmpl__DocumentDate__c, 'Document Date should be today');
        System.assertEquals('9876543210', fetchedCheckIn.dmpl__MobileNumber__c, 'Mobile number should auto-tag from customer');
        System.assertEquals('Draft', fetchedCheckIn.dmpl__Status__c, 'Status should be Draft');

        try {
            dmpl__CheckInInspection__c checkInToUpdate = CheckInDataHelper.GetCheckIn(fetchedCheckIn.Id);
            checkInToUpdate.dmpl__PartnerAccountId__c = partner3.Id;
            checkInToUpdate.dmpl__BranchId__c = branch3.Id;
            update checkInToUpdate;
        } catch (System.DmlException e) {
            exceptionThrown = true;
        }
        Test.stopTest();

        System.assertEquals(true, exceptionThrown, 'Exception should be thrown due to inactive branch on update.');
    }
    // Check-Ins creation with Asset (New)
    @isTest
    static void createCheckInsWithAssetPositive() {

        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        Asset asset = TestDataHelpers.createAsset('Asset 1', customer1.Id, item1.Id); 
        
        Test.startTest();
        dmpl__CheckInInspection__c createdCheckIn = CheckInDataHelper.CreateCheckIn(partner1, customer1, branch1, asset);
        Test.stopTest();

        dmpl__CheckInInspection__c fetchedCheckIn = CheckInDataHelper.GetCheckIn(createdCheckIn.Id);

        System.assertEquals(partner1.Id, fetchedCheckIn.dmpl__PartnerAccountId__c, 'Partner should be Partner 1');
        System.assertEquals(branch1.Id, fetchedCheckIn.dmpl__BranchId__c, 'Branch should be Branch 1');
        System.assertEquals(customer1.Id, fetchedCheckIn.dmpl__AccountId__c, 'Customer should be Customer 1');
        System.assertEquals(asset.Id, fetchedCheckIn.dmpl__AssetId__c, 'Asset should be Asset 1');
        System.assertEquals(Date.today(), fetchedCheckIn.dmpl__DocumentDate__c, 'Document Date should be today');
        System.assertEquals('9876543210', fetchedCheckIn.dmpl__MobileNumber__c, 'Mobile number should auto-tag from customer');
        System.assertEquals('Draft', fetchedCheckIn.dmpl__Status__c, 'Status should be Draft');
    }

    // Check-Ins creation with Asset (Edit)
    @isTest
    static void updateCheckInsWithAssetPositive() {

        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        Asset asset = TestDataHelpers.createAsset('Asset 1', customer1.Id, item1.Id); // ✅ correct asset creation

        Test.startTest();
        dmpl__CheckInInspection__c createdCheckIn = CheckInDataHelper.CreateCheckIn(partner1, customer1, branch1, asset);


        dmpl__CheckInInspection__c fetchedCheckIn = CheckInDataHelper.GetCheckIn(createdCheckIn.Id);

        System.assertEquals(partner1.Id, fetchedCheckIn.dmpl__PartnerAccountId__c, 'Partner should be Partner 1');
        System.assertEquals(branch1.Id, fetchedCheckIn.dmpl__BranchId__c, 'Branch should be Branch 1');
        System.assertEquals(customer1.Id, fetchedCheckIn.dmpl__AccountId__c, 'Customer should be Customer 1');
        System.assertEquals(asset.Id, fetchedCheckIn.dmpl__AssetId__c, 'Asset should be Asset 1');
        System.assertEquals(Date.today(), fetchedCheckIn.dmpl__DocumentDate__c, 'Document Date should be today');
        System.assertEquals('9876543210', fetchedCheckIn.dmpl__MobileNumber__c, 'Mobile number should auto-tag from customer');
        System.assertEquals('Draft', fetchedCheckIn.dmpl__Status__c, 'Status should be Draft');

        dmpl__CheckInInspection__c checkInToUpdate = CheckInDataHelper.GetCheckIn(fetchedCheckIn.Id);
        checkInToUpdate.dmpl__PartnerAccountId__c = partner1.Id;
        checkInToUpdate.dmpl__BranchId__c = branch1.Id;
        checkInToUpdate.dmpl__AccountId__c = customer1.Id;
        checkInToUpdate.dmpl__AssetId__c = asset.Id;
        update checkInToUpdate;
        Test.stopTest();

        dmpl__CheckInInspection__c updatedCheckIn = CheckInDataHelper.GetCheckIn(fetchedCheckIn.Id);

        System.assertEquals(partner1.Id, updatedCheckIn.dmpl__PartnerAccountId__c, 'Partner should remain Partner 1');
        System.assertEquals(branch1.Id, updatedCheckIn.dmpl__BranchId__c, 'Branch should remain Branch 1');
        System.assertEquals(customer1.Id, updatedCheckIn.dmpl__AccountId__c, 'Customer should remain Customer 1');
        System.assertEquals(asset.Id, updatedCheckIn.dmpl__AssetId__c, 'Asset should remain Asset 1');
        System.assertEquals(Date.today(), updatedCheckIn.dmpl__DocumentDate__c, 'Document Date should remain unchanged');
        System.assertEquals('9876543210', updatedCheckIn.dmpl__MobileNumber__c, 'Mobile number should remain unchanged');
        System.assertEquals('Draft', updatedCheckIn.dmpl__Status__c, 'Status should remain Draft');
}

    // Check-Ins creation with Service Advisor (New)
    @isTest
    static void createCheckInsWithServiceAdvisorPositive() {
        Test.startTest();
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        Asset asset = TestDataHelpers.createAsset('Asset 1', customer1.Id, item1.Id); 
        dmpl__Resource__c serviceAdvisor=ResourceDataHelper.getServiceAdvisor('Service Advisor');
        dmpl__CheckInInspection__c createdCheckIn = CheckInDataHelper.CreateCheckIn(partner1, customer1, branch1, asset);
        createdCheckIn.dmpl__ServiceAdvisorId__c=serviceAdvisor.Id;
        update createdCheckIn;
        dmpl__CheckInInspection__c fetchedCheckIn = CheckInDataHelper.GetCheckIn(createdCheckIn.Id);
        Test.stopTest();
        System.assertEquals(partner1.Id, fetchedCheckIn.dmpl__PartnerAccountId__c, 'Partner should be Partner 1');
        System.assertEquals(branch1.Id, fetchedCheckIn.dmpl__BranchId__c, 'Branch should be Branch 1');
        System.assertEquals(customer1.Id, fetchedCheckIn.dmpl__AccountId__c, 'Customer should be Customer 1');
        System.assertEquals(asset.Id, fetchedCheckIn.dmpl__AssetId__c, 'Asset should be Asset 1');
        System.assertEquals(Date.today(), fetchedCheckIn.dmpl__DocumentDate__c, 'Document Date should be today');
        System.assertEquals('9876543210', fetchedCheckIn.dmpl__MobileNumber__c, 'Mobile number should auto-tag from customer');
        System.assertEquals('Draft', fetchedCheckIn.dmpl__Status__c, 'Status should be Draft');
        System.assertEquals(serviceAdvisor.Id,fetchedCheckIn.dmpl__ServiceAdvisorId__c,'service advisor should match');
    }
    @isTest
    static void updateCheckInsWithServiceAdvisorPositive() {
        Test.startTest();
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        Asset asset = TestDataHelpers.createAsset('Asset 1', customer1.Id, item1.Id); 
        dmpl__Resource__c serviceAdvisor=ResourceDataHelper.getServiceAdvisor('Service Advisor');
        dmpl__CheckInInspection__c createdCheckIn = CheckInDataHelper.CreateCheckIn(partner1, customer1, branch1, asset);


        createdCheckIn.dmpl__ServiceAdvisorId__c=serviceAdvisor.Id;
        update createdCheckIn;
        dmpl__CheckInInspection__c fetchedCheckIn = CheckInDataHelper.GetCheckIn(createdCheckIn.Id);
        Test.stopTest();
        System.assertEquals(partner1.Id, fetchedCheckIn.dmpl__PartnerAccountId__c, 'Partner should be Partner 1');
        System.assertEquals(branch1.Id, fetchedCheckIn.dmpl__BranchId__c, 'Branch should be Branch 1');
        System.assertEquals(customer1.Id, fetchedCheckIn.dmpl__AccountId__c, 'Customer should be Customer 1');
        System.assertEquals(asset.Id, fetchedCheckIn.dmpl__AssetId__c, 'Asset should be Asset 1');
        System.assertEquals(Date.today(), fetchedCheckIn.dmpl__DocumentDate__c, 'Document Date should be today');
        System.assertEquals('9876543210', fetchedCheckIn.dmpl__MobileNumber__c, 'Mobile number should auto-tag from customer');
        System.assertEquals('Draft', fetchedCheckIn.dmpl__Status__c, 'Status should be Draft');
        System.assertEquals(serviceAdvisor.Id,fetchedCheckIn.dmpl__ServiceAdvisorId__c,'service advisor should match');
    }


// Check-Ins creation with active customer account (New) 38

    @isTest
    static void createCheckInsWithActiveCustomerAccountPositive() {

        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        Asset asset = TestDataHelpers.createAsset('Asset 1', customer1.Id, item1.Id); 
        
        Test.startTest();
        dmpl__CheckInInspection__c createdCheckIn = CheckInDataHelper.CreateCheckIn(partner1, customer1, branch1, asset);
        Test.stopTest();

        dmpl__CheckInInspection__c fetchedCheckIn = CheckInDataHelper.GetCheckIn(createdCheckIn.Id);

        System.assertEquals(partner1.Id, fetchedCheckIn.dmpl__PartnerAccountId__c, 'Partner should be Partner 1');
        System.assertEquals(branch1.Id, fetchedCheckIn.dmpl__BranchId__c, 'Branch should be Branch 1');
        System.assertEquals(customer1.Id, fetchedCheckIn.dmpl__AccountId__c, 'Customer should be Customer 1');
        System.assertEquals(asset.Id, fetchedCheckIn.dmpl__AssetId__c, 'Asset should be Asset 1');
        System.assertEquals(Date.today(), fetchedCheckIn.dmpl__DocumentDate__c, 'Document Date should be today');
        System.assertEquals('9876543210', fetchedCheckIn.dmpl__MobileNumber__c, 'Mobile number should auto-tag from customer');
        System.assertEquals('Draft', fetchedCheckIn.dmpl__Status__c, 'Status should be Draft');
    }

    // 39 here :Check-Ins creation with active customer account (Edit)
    @isTest
    static void updateCheckInsWithActiveCustomerAccountPositive() {
    Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
    Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
    Account customer3 = TestDataHelpers.getCustomerAccount('Customer 3');
    dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');

    dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
    Asset asset = TestDataHelpers.createAsset('Asset 1', customer1.Id, item1.Id); 

    dmpl__Item__c item5 = TestDataHelpers.getItem('Item 5');


    dmpl__CheckInInspection__c createdCheckIn = CheckInDataHelper.CreateCheckIn(partner1, customer1, branch1, asset);


    dmpl__CheckInInspection__c fetchedCheckIn = CheckInDataHelper.GetCheckIn(createdCheckIn.Id);

    System.assertEquals(partner1.Id, fetchedCheckIn.dmpl__PartnerAccountId__c, 'Partner should be Partner 1');
    System.assertEquals(branch1.Id, fetchedCheckIn.dmpl__BranchId__c, 'Branch should be Branch 1');
    System.assertEquals(customer1.Id, fetchedCheckIn.dmpl__AccountId__c, 'Customer should be Customer 1');
    System.assertEquals(asset.Id, fetchedCheckIn.dmpl__AssetId__c, 'Asset should be Asset 1');
    System.assertEquals(Date.today(), fetchedCheckIn.dmpl__DocumentDate__c, 'Document Date should be today');
    System.assertEquals('9876543210', fetchedCheckIn.dmpl__MobileNumber__c, 'Mobile number should auto-tag from customer');
    System.assertEquals('Draft', fetchedCheckIn.dmpl__Status__c, 'Status should be Draft');

    Boolean exceptionThrown=false;

    Test.startTest();
    dmpl__CheckInInspection__c checkInToUpdate = CheckInDataHelper.GetCheckIn(fetchedCheckIn.Id);
    try{
        checkInToUpdate.dmpl__AccountId__c = customer3.Id;
        update checkInToUpdate;
    } catch (Exception e) {
            exceptionThrown = true;
        }
    Test.stopTest();
    System.assertEquals(true, exceptionThrown, 'Exception should be thrown due to inactive branch on update.');
}


    // Check-Ins creation with in-active customer account (New) 40
    @isTest
    static void createCheckInWithInactiveCustomerAccountNegative() {

        Account partner3 = TestDataHelpers.getPartnerAccount('Partner 3');
        Account customer7 = TestDataHelpers.getCustomerAccount('Customer 7'); 
        dmpl__Branch__c branch3 = TestDataHelpers.getBranch('Branch 3');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        Asset asset = TestDataHelpers.createAsset('Asset 1', customer7.Id, item1.Id); 
        
        Boolean exceptionThrown = false;

        Test.startTest();
        try {
            dmpl__CheckInInspection__c checkIn = CheckInDataHelper.CreateCheckIn(partner3, customer7, branch3, asset);
        } catch (System.DmlException e) {
            exceptionThrown = true;
        }
        Test.stopTest();

        System.assertEquals(true, exceptionThrown, 'Exception should be thrown due to inactive customer account.');
    }

    // Check-Ins creation with in-active customer account (Edit) 41
    @isTest
    static void updateheckInWithInactiveCustomerAccountNegative() {
    
        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account partner3 = TestDataHelpers.getPartnerAccount('Partner 3');
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account customer7 = TestDataHelpers.getCustomerAccount('Customer 7'); 

        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__Branch__c branch3 = TestDataHelpers.getBranch('Branch 3');

        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        Asset asset = TestDataHelpers.createAsset('Asset 1', customer1.Id, item1.Id); 

        Boolean exceptionThrown = false;

        dmpl__CheckInInspection__c createdCheckIn = CheckInDataHelper.CreateCheckIn(partner1, customer1, branch1, asset);
        dmpl__CheckInInspection__c fetchedCheckIn = CheckInDataHelper.GetCheckIn(createdCheckIn.Id);

        System.assertEquals(partner1.Id, fetchedCheckIn.dmpl__PartnerAccountId__c, 'Partner should be Partner 1');
        System.assertEquals(branch1.Id, fetchedCheckIn.dmpl__BranchId__c, 'Branch should be Branch 1');
        System.assertEquals(customer1.Id, fetchedCheckIn.dmpl__AccountId__c, 'Customer should be Customer 1');
        System.assertEquals(asset.Id, fetchedCheckIn.dmpl__AssetId__c, 'Asset should be Asset 1');
        System.assertEquals(Date.today(), fetchedCheckIn.dmpl__DocumentDate__c, 'Document Date should be today');
        System.assertEquals('9876543210', fetchedCheckIn.dmpl__MobileNumber__c, 'Mobile number should auto-tag from customer');
        System.assertEquals('Draft', fetchedCheckIn.dmpl__Status__c, 'Status should be Draft');


        Test.startTest();
        try {
            dmpl__CheckInInspection__c checkInToUpdate = CheckInDataHelper.GetCheckIn(fetchedCheckIn.Id);
            checkInToUpdate.dmpl__PartnerAccountId__c = partner3.Id;
            checkInToUpdate.dmpl__BranchId__c = branch3.Id;
            checkInToUpdate.dmpl__AccountId__c = customer7.Id;
            update checkInToUpdate;
        } catch (System.DmlException e) {
            exceptionThrown = true;
        }
        Test.stopTest();

        System.assertEquals(true, exceptionThrown, 'Exception should be thrown due to inactive customer account.');
    }
    
    // Check-In Inscpection Line with Check-in Reference (new)42
    @isTest
    static void createCheckInInspectionLineWithCheckInReferencePositive() {

        Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
        Asset asset = TestDataHelpers.createAsset('Asset 1', customer1.Id, item1.Id);

        dmpl__CheckInInspection__c checkIn = CheckInDataHelper.CreateCheckIn(partner1, customer1, branch1, asset);

        dmpl__CheckInInspection__c fetchedCheckIn = CheckInDataHelper.GetCheckIn(checkIn.Id);
        System.assertEquals(partner1.Id, fetchedCheckIn.dmpl__PartnerAccountId__c, 'Partner should be Partner 1');
        System.assertEquals(branch1.Id, fetchedCheckIn.dmpl__BranchId__c, 'Branch should be Branch 1');
        System.assertEquals(customer1.Id, fetchedCheckIn.dmpl__AccountId__c, 'Customer should be Customer 1');
        System.assertEquals(asset.Id, fetchedCheckIn.dmpl__AssetId__c, 'Asset should be Asset 1');
        System.assertEquals(Date.today(), fetchedCheckIn.dmpl__DocumentDate__c, 'Document Date should be today');
        System.assertEquals('9876543210', fetchedCheckIn.dmpl__MobileNumber__c, 'Mobile number should auto-tag from customer');
        System.assertEquals('Draft', fetchedCheckIn.dmpl__Status__c, 'Status should be Draft');


        Test.startTest();
        dmpl__CheckInInspectionLine__c line = CheckInDataHelper.createCheckInInspectionLineWithDefaults(fetchedCheckIn.Id);
        Test.stopTest();

        dmpl__CheckInInspectionLine__c fetchedLine = CheckInDataHelper.getCheckInInspectionLineById(line.Id);
        System.assertEquals(fetchedCheckIn.Id, fetchedLine.dmpl__CheckInInspectionId__c, 'Check-In reference should match');
    }

    // Check-In Inscpection Line with Check-in Reference (Edit) 43
@isTest
static void updateCheckInInspectionLineWithCheckInReferenceNegative() {
    Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
    Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
    dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
    dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
    Asset asset = TestDataHelpers.createAsset('Asset 1', customer1.Id, item1.Id);

    dmpl__CheckInInspection__c checkIn1 = CheckInDataHelper.CreateCheckIn(partner1, customer1, branch1, asset);
    dmpl__CheckInInspection__c fetchedCheckIn1 = CheckInDataHelper.GetCheckIn(checkIn1.Id);

    System.assertEquals(partner1.Id, fetchedCheckIn1.dmpl__PartnerAccountId__c);
    System.assertEquals(branch1.Id, fetchedCheckIn1.dmpl__BranchId__c);
    System.assertEquals(customer1.Id, fetchedCheckIn1.dmpl__AccountId__c);
    System.assertEquals(asset.Id, fetchedCheckIn1.dmpl__AssetId__c);
    System.assertEquals(Date.today(), fetchedCheckIn1.dmpl__DocumentDate__c);
    System.assertEquals('9876543210', fetchedCheckIn1.dmpl__MobileNumber__c);
    System.assertEquals('Draft', fetchedCheckIn1.dmpl__Status__c);

    dmpl__CheckInInspectionLine__c line = CheckInDataHelper.createCheckInInspectionLineWithDefaults(fetchedCheckIn1.Id);
    dmpl__CheckInInspection__c checkIn2 = CheckInDataHelper.CreateCheckIn(partner1, customer1, branch1, asset);
    dmpl__CheckInInspection__c fetchedCheckIn2 = CheckInDataHelper.GetCheckIn(checkIn2.Id);

    Boolean exceptionThrown = false;

    Test.startTest();
    try {
        line.dmpl__CheckInInspectionId__c = fetchedCheckIn2.Id;
        update line;
    } catch (Exception e) {
        exceptionThrown = true;
    }
    Test.stopTest();

    System.assertEquals(true, exceptionThrown);
}


    

// 44Check-In Inspection line with Section (New)
    @isTest 
    static void CreateCheckInInspectionLinewithSectionPositive() {

    Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
    Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
    dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
    dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
    Asset asset = TestDataHelpers.createAsset('Asset 1', customer1.Id, item1.Id);

    dmpl__CheckInInspection__c checkIn = CheckInDataHelper.CreateCheckIn(partner1, customer1, branch1, asset);
  
    dmpl__CheckInInspection__c fetchedCheckIn = CheckInDataHelper.GetCheckIn(checkIn.Id);
    System.assertEquals(partner1.Id, fetchedCheckIn.dmpl__PartnerAccountId__c);
    System.assertEquals(branch1.Id, fetchedCheckIn.dmpl__BranchId__c);
    System.assertEquals(customer1.Id, fetchedCheckIn.dmpl__AccountId__c);
    System.assertEquals(asset.Id, fetchedCheckIn.dmpl__AssetId__c);
    System.assertEquals(Date.today(), fetchedCheckIn.dmpl__DocumentDate__c);
    System.assertEquals('9876543210', fetchedCheckIn.dmpl__MobileNumber__c);
    System.assertEquals('Draft', fetchedCheckIn.dmpl__Status__c);

    Test.startTest();
    dmpl__CheckInInspectionLine__c line = CheckInDataHelper.createCheckInInspectionLine(checkIn.Id, 'SIde Panel');
    Test.stopTest();

    dmpl__CheckInInspectionLine__c fetchedLine = CheckInDataHelper.getCheckInInspectionLineById(line.Id);
    System.assertEquals(checkIn.Id, fetchedLine.dmpl__CheckInInspectionId__c, 'Check-In reference should match');
    System.assertEquals('SIde Panel', fetchedLine.dmpl__Section__c, 'Section should be SIde Panel');
}
//45
    @isTest
    static void updateCheckInInspectionLinewithSectionPositive() {

    Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
    Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
    dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
    dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
    Asset asset = TestDataHelpers.createAsset('Asset 1', customer1.Id, item1.Id);

    Test.startTest();
    dmpl__CheckInInspection__c checkIn = CheckInDataHelper.CreateCheckIn(partner1, customer1, branch1, asset);

    dmpl__CheckInInspection__c fetchedCheckIn = CheckInDataHelper.GetCheckIn(checkIn.Id);
    System.assertEquals(partner1.Id, fetchedCheckIn.dmpl__PartnerAccountId__c);
    System.assertEquals(branch1.Id, fetchedCheckIn.dmpl__BranchId__c);
    System.assertEquals(customer1.Id, fetchedCheckIn.dmpl__AccountId__c);
    System.assertEquals(asset.Id, fetchedCheckIn.dmpl__AssetId__c);
    System.assertEquals(Date.today(), fetchedCheckIn.dmpl__DocumentDate__c);
    System.assertEquals('9876543210', fetchedCheckIn.dmpl__MobileNumber__c);
    System.assertEquals('Draft', fetchedCheckIn.dmpl__Status__c);

    dmpl__CheckInInspectionLine__c line = CheckInDataHelper.createCheckInInspectionLine(checkIn.Id, 'SIde Panel');

    dmpl__CheckInInspectionLine__c lineToUpdate = CheckInDataHelper.getCheckInInspectionLineById(line.Id);
    lineToUpdate.dmpl__Section__c = 'Front Panel';
    update lineToUpdate;
    Test.stopTest();

    dmpl__CheckInInspectionLine__c updatedLine = CheckInDataHelper.getCheckInInspectionLineById(line.Id);
    System.assertEquals(checkIn.Id, updatedLine.dmpl__CheckInInspectionId__c, 'Check-In reference should match');
    System.assertEquals('Front Panel', updatedLine.dmpl__Section__c, 'Section should be updated to Front Panel');
}
    //46 Check-In Inspection line with Sub-Section (New)
    @isTest 
    static void createCheckInInspectionLinewithSubSectionPositive() {

    Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
    Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
    dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
    dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
    Asset asset = TestDataHelpers.createAsset('Asset 1', customer1.Id, item1.Id);

    dmpl__CheckInInspection__c checkIn = CheckInDataHelper.CreateCheckIn(partner1, customer1, branch1, asset);
  
    dmpl__CheckInInspection__c fetchedCheckIn = CheckInDataHelper.GetCheckIn(checkIn.Id);
    System.assertEquals(partner1.Id, fetchedCheckIn.dmpl__PartnerAccountId__c);
    System.assertEquals(branch1.Id, fetchedCheckIn.dmpl__BranchId__c);
    System.assertEquals(customer1.Id, fetchedCheckIn.dmpl__AccountId__c);
    System.assertEquals(asset.Id, fetchedCheckIn.dmpl__AssetId__c);
    System.assertEquals(Date.today(), fetchedCheckIn.dmpl__DocumentDate__c);
    System.assertEquals('9876543210', fetchedCheckIn.dmpl__MobileNumber__c);
    System.assertEquals('Draft', fetchedCheckIn.dmpl__Status__c);

    Test.startTest();
    dmpl__CheckInInspectionLine__c line = CheckInDataHelper.createCheckInInspectionLinWithSubsectionCondition(checkIn.Id, 'SIde Panel','Right Side Panel',null);
    Test.stopTest();

    dmpl__CheckInInspectionLine__c fetchedLine = CheckInDataHelper.getCheckInInspectionLineById(line.Id);
    System.assertEquals(checkIn.Id, fetchedLine.dmpl__CheckInInspectionId__c, 'Check-In reference should match');
    System.assertEquals('SIde Panel', fetchedLine.dmpl__Section__c, 'Section should be SIde Panel');
    System.assertEquals('Right Side Panel',fetchedLine.dmpl__SubSection__c);
    }
    
    //Check-In Inspection line with Condition (New) 47
    @isTest 
    static void createCheckInInspectionLinewithConditionPositive() {

    Account partner1 = TestDataHelpers.getPartnerAccount('Partner 1');
    Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
    dmpl__Branch__c branch1 = TestDataHelpers.getBranch('Branch 1');
    dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
    Asset asset = TestDataHelpers.createAsset('Asset 1', customer1.Id, item1.Id);
    

    dmpl__CheckInInspection__c checkIn = CheckInDataHelper.CreateCheckIn(partner1, customer1, branch1, asset);
  
    dmpl__CheckInInspection__c fetchedCheckIn = CheckInDataHelper.GetCheckIn(checkIn.Id);
    System.assertEquals(partner1.Id, fetchedCheckIn.dmpl__PartnerAccountId__c);
    System.assertEquals(branch1.Id, fetchedCheckIn.dmpl__BranchId__c);
    System.assertEquals(customer1.Id, fetchedCheckIn.dmpl__AccountId__c);
    System.assertEquals(asset.Id, fetchedCheckIn.dmpl__AssetId__c);
    System.assertEquals(Date.today(), fetchedCheckIn.dmpl__DocumentDate__c);
    System.assertEquals('9876543210', fetchedCheckIn.dmpl__MobileNumber__c);
    System.assertEquals('Draft', fetchedCheckIn.dmpl__Status__c);


    Test.startTest();
    dmpl__CheckInInspectionLine__c line = CheckInDataHelper.createCheckInInspectionLinWithSubsectionCondition(checkIn.Id, 'SIde Panel','Right Side Panel','Torn');
    Test.stopTest();

    dmpl__CheckInInspectionLine__c fetchedLine = CheckInDataHelper.getCheckInInspectionLineById(line.Id);
    System.assertEquals(checkIn.Id, fetchedLine.dmpl__CheckInInspectionId__c, 'Check-In reference should match');
    System.assertEquals('SIde Panel', fetchedLine.dmpl__Section__c, 'Section should be SIde Panel');
    System.assertEquals('Right Side Panel',fetchedLine.dmpl__SubSection__c);
    System.assertEquals('Torn',fetchedLine.dmpl__Condition__c);
    }

    // Check -In template with active applicable item (New)
    @isTest
    static void createcheckInTemplateWithActiveApplicableItemPositive() {
    dmpl__Item__c item = TestDataHelpers.getItem('Item 8');

    dmpl__CheckInTemplate__c template = new dmpl__CheckInTemplate__c(
        dmpl__ApplicableItemId__c = item.Id
    );
    System.assertEquals(item.Id, template.dmpl__ApplicableItemId__c);
}
@isTest
static void updatecheckInTemplateWithActiveApplicableItemPositive() {

    Test.startTest();
    dmpl__Item__c item8 = TestDataHelpers.getItem('Item 8');
    dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');

    dmpl__CheckInTemplate__c template = new dmpl__CheckInTemplate__c(

        dmpl__ApplicableItemId__c = item8.Id
    );
    insert template;


    System.assertEquals(item8.Id, template.dmpl__ApplicableItemId__c);

    template.dmpl__ApplicableItemId__c = item1.Id;
    update template;
    Test.stopTest();

    System.assertEquals(item1.Id, template.dmpl__ApplicableItemId__c);
}
@isTest
static void createCheckInTemplateWithInactiveApplicableItemNegative() {
    dmpl__Item__c item = TestDataHelpers.getItem('Item 2');

    dmpl__CheckInTemplate__c template = new dmpl__CheckInTemplate__c(
        dmpl__ApplicableItemId__c = item.Id
    );
    System.assertEquals(item.Id, template.dmpl__ApplicableItemId__c);
}
@isTest
static void updatecheckInTemplateWithInactiveApplicableItemNegative() {

    Test.startTest();
    dmpl__Item__c item8 = TestDataHelpers.getItem('Item 8');
    dmpl__Item__c item2 = TestDataHelpers.getItem('Item 2');

    dmpl__CheckInTemplate__c template = new dmpl__CheckInTemplate__c(

        dmpl__ApplicableItemId__c = item8.Id
    );
    insert template;


    System.assertEquals(item8.Id, template.dmpl__ApplicableItemId__c);

    template.dmpl__ApplicableItemId__c = item2.Id;
    update template;
    Test.stopTest();

    System.assertEquals(item2.Id, template.dmpl__ApplicableItemId__c,'applicable item should match');
}



}