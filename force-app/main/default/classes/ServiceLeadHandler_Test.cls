@isTest
    public with sharing class ServiceLeadHandler_Test {
    @TestSetup
    static void createRequiredData() {
        Account partnerAccount = TestDataHelpers.createPartnerAccount();
        Account customerAccount = TestDataHelpers.createCustomerAccount();        
        dmpl__Branch__c branch =TestDataHelpers.createBranch(partnerAccount);   
        dmpl__Resource__c resource =TestDataHelpers.createResource(partnerAccount, branch);  
        dmpl__ServiceLead__c serviceLead = ServiceLeadTestDataHelpers.createServiceLead(branch, customerAccount, resource);

        Account partnerAccount1 = TestDataHelpers.createPartnerAccount('Partner 1', false, true, false, true, 'MG Road', 'Bengaluru', 'Karnataka', 'India', '560001', '56 Industrial Layout', 'Bengaluru', 'Karnataka', 'India', '560095','9876543210');
        Account partnerAccount2 = TestDataHelpers.createPartnerAccount('Partner 2', false, true, false, false, '45 Residency Road', 'Pune', 'Maharashtra', 'India', '411001', '22 Commerce Avenue', 'Pune', 'Maharashtra', 'India', '411038','91-99665544433');
        Account partnerAccount3 = TestDataHelpers.createPartnerAccount('Partner 3', false, true, false, true, '78 Nehru Nagar Road', 'Chennai', 'Tamil Nadu', 'India', '600042', '78 Nehru Nagar Road', 'Chennai', 'Tamil Nadu', 'India', '600042', '91-9123456789');
        Account partnerAccount4 = TestDataHelpers.createPartnerAccount('Partner 4', false, true, false, true, '12 Industrial Zone', 'Hyderabad','Telangana', 'India', '500032', '12 Industrial Zone', 'Hyderabad', 'Telangana', 'India','500032','9876012345');
        Account partnerAccount6 = TestDataHelpers.createPartnerAccount('Partner 6', false, true, false, true, 'MS Road', 'Bengaluru','Karnataka', 'India', '560001', '56 Industrial Layout', 'Bengaluru', 'Karnataka', 'India','560095','9845543210');

        Account customerAccount1 = TestDataHelpers.createCustomerAccount('Customer 1', true, false, false, true, 'MG Road', 'Pune', 'Maharashtra', 'India', '411001', 'Ring Rd', 'Nagpur', 'Maharashtra', 'India', '440001','9876543210', 'Created');
        Account customerAccount2 = TestDataHelpers.createCustomerAccount('Customer 2', true, false, false, true, 'Park St', 'Kolkata', 'West Bengal', 'India', '700016', 'Lake Rd', 'Kolkata', 'West Bengal', 'India', '700029','9876543210', 'Created');
        Account customerAccount3 = TestDataHelpers.createCustomerAccount('Customer 3', true, false, false, true, 'Anna Salai', 'Chennai', 'Tamil Nadu', 'India', '600002', 'T Nagar', 'Chennai', 'Tamil Nadu', 'India', '600017','9012345678', 'Created');
            Account customerAccount7=TestDataHelpers.createCustomerAccount('Customer 7', true, false, false, false, 'Mission Road', 'Bengaluru', 'Karnataka', 'India', '560027', 'Indiranagar', 'Bengaluru', 'Karnataka', 'India', '560038','9811122233', 'Created');
        Account customerAccount6=TestDataHelpers.createCustomerAccount('Customer 6', true, false, false, true, 'Sector 18', 'Noida', 'Uttar Pradesh', 'India', '201301', 'Sector 62', 'Noida', 'Uttar Pradesh', 'India', '201309','9876501234', 'Created');
        Account customerAccount4 = TestDataHelpers.createCustomerAccount('Customer 4', true, false, false, true, 'SG Highway', 'Ahmedabad', 'GJ', 'India', '380054', 'C G Road', 'Ahmedabad', 'GJ', 'India', '380009','9988776655', 'Created');
        Account customerAccount5 = TestDataHelpers.createCustomerAccount('Customer 5', true, false, false, true, 'MG Road', 'Pune', 'Maharashtra', 'India', '411001', 'Ring Rd', 'Nagpur', 'Maharashtra', 'India', '440001','9876543210', 'Created');
        
        
        dmpl__Branch__c branch1=TestDataHelpers.createBranch('Branch 1', partnerAccount1.Id, true, true, false, true);
        dmpl__Branch__c branch3 = TestDataHelpers.createBranch('Branch 3', partnerAccount3.Id, false, true, true, false);
        dmpl__Branch__c branch4 =TestDataHelpers.createBranch('Branch 4',partnerAccount4.Id,true,true,false,false);
        dmpl__Branch__c branch6 =TestDataHelpers.createBranch('Branch 6',partnerAccount6.Id,true,true,false,true);

        dmpl__Item__c  item1 = TestDataHelpers.createItem('Item 1','Product',true,false,false,'675654',false);
        dmpl__Item__c item5 = TestDataHelpers.createItem('Item 5', 'Product', true, false, false, '876543', false);

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
    @isTest
    static void CreateServiceLeadWithCorrectPartnerAndBranchPositive() {
    // Arrange
    Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
    Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
    dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');

    Date documentDate = Date.today();
    String status = 'Draft';

    // Act
    Test.startTest();
    dmpl__ServiceLead__c serviceLead = ServiceLeadTestDataHelpers.createServiceLeadbyId(
        partner,
        branch,
        customer,
        null,   
        null,   
        null,   
        null,
        documentDate
    );
    dmpl__ServiceLead__c fetched = ServiceLeadTestDataHelpers.getServiceLeadbyId(serviceLead.Id);
    Test.stopTest();

    System.assertEquals(partner.Id, fetched.dmpl__PartnerAccountId__c, 'Partner should match');
    System.assertEquals(branch.Id, fetched.dmpl__BranchId__c, 'Branch should match');
    System.assertEquals(customer.Id, fetched.dmpl__AccountId__c, 'Customer should match');
    System.assertEquals(status, fetched.dmpl__Status__c, 'Status should be Draft');
    System.assertEquals(documentDate, fetched.dmpl__DocumentDate__c, 'Document date should be today');
    }
    @isTest
    static void CreateServiceLeadWithWrongPartnerNegative() {
    Account wrongPartner = TestDataHelpers.getPartnerAccount('Partner 3');
    Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
    dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
    Date documentDate = Date.today();

    Boolean exceptionThrown = false;

    Test.startTest();
    try {
        ServiceLeadTestDataHelpers.createServiceLeadbyId(
            wrongPartner,
            branch,
            customer,
            null,
            null,
            null,
            null,
            documentDate
        );
    } catch (DmlException e) {
        exceptionThrown = true;
    }
    Test.stopTest();

    System.assertEquals(true, exceptionThrown, 'expected exception due to wrong branch ');
    }
    @isTest
    static void UpdateServiceLeadWithWrongPartnerNegative() {
    Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
    Account wrongPartner = TestDataHelpers.getPartnerAccount('Partner 3');
    Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
    dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
    Date documentDate = Date.today();

    dmpl__ServiceLead__c lead = ServiceLeadTestDataHelpers.createServiceLeadbyId(
        partner,
        branch,
        customer,
        null,
        null,
        null,
        null,
        documentDate
    );

    dmpl__ServiceLead__c fetched = ServiceLeadTestDataHelpers.getServiceLeadById(lead.Id);

    System.assertEquals(partner.Id, fetched.dmpl__PartnerAccountId__c);
    System.assertEquals(branch.Id, fetched.dmpl__BranchId__c);
    System.assertEquals(customer.Id, fetched.dmpl__AccountId__c);
    System.assertEquals('Draft', fetched.dmpl__Status__c);
    System.assertEquals(Date.today(), fetched.dmpl__DocumentDate__c);

    Boolean exceptionThrown = false;

    Test.startTest();
    try {
        fetched.dmpl__PartnerAccountId__c = wrongPartner.Id;
        update fetched;
    } catch (DmlException e) {
        exceptionThrown = true;
    }
    Test.stopTest();

    System.assertEquals(true, exceptionThrown, 'expected exception due to wrong partner ');
    }
    // Service Lead creation with inactive partner account (New)
    @isTest
    static void CreateServiceLeadWithinactivePartnerNegative() {
    Account wrongPartner = TestDataHelpers.getPartnerAccount('Partner 2');
    Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
    Date documentDate = Date.today();

    Boolean exceptionThrown = false;

    Test.startTest();
    try {
        ServiceLeadTestDataHelpers.createServiceLeadbyId(
            wrongPartner,
            null,
            customer,
            null,
            null,
            null,
            null,
            documentDate
        );
    } catch (DmlException e) {
        exceptionThrown = true;
    }
    Test.stopTest();

    System.assertEquals(true, exceptionThrown, 'expected exception due to wrong branch ');
    }
    // Service Lead creation with inactive partner account (Edit)
    @isTest
    static void UpdateServiceLeadWithInactivePartnerNegative() {
    Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
    Account wrongPartner = TestDataHelpers.getPartnerAccount('Partner 2');
    Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
    dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
    Date documentDate = Date.today();

    dmpl__ServiceLead__c lead = ServiceLeadTestDataHelpers.createServiceLeadbyId(
        partner,
        branch,
        customer,
        null,
        null,
        null,
        null,
        documentDate
    );

    dmpl__ServiceLead__c fetched = ServiceLeadTestDataHelpers.getServiceLeadById(lead.Id);

    System.assertEquals(partner.Id, fetched.dmpl__PartnerAccountId__c);
    System.assertEquals(branch.Id, fetched.dmpl__BranchId__c);
    System.assertEquals(customer.Id, fetched.dmpl__AccountId__c);
    System.assertEquals('Draft', fetched.dmpl__Status__c);
    System.assertEquals(Date.today(), fetched.dmpl__DocumentDate__c);

    Boolean exceptionThrown = false;

    Test.startTest();
    try {
        fetched.dmpl__PartnerAccountId__c = wrongPartner.Id;
        fetched.dmpl__BranchId__c=null;
        update fetched;
    } catch (DmlException e) {
        exceptionThrown = true;
    }
    Test.stopTest();

    System.assertEquals(true, exceptionThrown, 'expected exception due to inactive partner ');
    }

    // Service Lead creation with wrong branch (New)
    @isTest
    static void CreateServiceLeadWithWrongBranchNegative() {
    Account Partner = TestDataHelpers.getPartnerAccount('Partner 1');
    Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
    dmpl__Branch__c wrongbranch = TestDataHelpers.getBranch('Branch 4');
    Date documentDate = Date.today();
    Boolean exceptionThrown = false;

    Test.startTest();
    try {
        ServiceLeadTestDataHelpers.createServiceLeadbyId(
            Partner,
            wrongbranch,
            customer,
            null,
            null,
            null,
            null,
            documentDate
        );
    } catch (DmlException e) {
        exceptionThrown = true;
    }
    Test.stopTest();

    System.assertEquals(true, exceptionThrown, 'expected exception due to wrong branch ');
    }
    // Service Lead creation with wrong branch (Edit)
    @isTest
    static void UpdateServiceLeadWithWrongBranchNegative() {
    Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
    Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
    dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
    dmpl__Branch__c branch3 = TestDataHelpers.getBranch('Branch 3');
    Date documentDate = Date.today();

    dmpl__ServiceLead__c lead = ServiceLeadTestDataHelpers.createServiceLeadbyId(
        partner,
        branch,
        customer,
        null,
        null,
        null,
        null,
        documentDate
    );

    dmpl__ServiceLead__c fetched = ServiceLeadTestDataHelpers.getServiceLeadById(lead.Id);

    System.assertEquals(partner.Id, fetched.dmpl__PartnerAccountId__c);
    System.assertEquals(branch.Id, fetched.dmpl__BranchId__c);
    System.assertEquals(customer.Id, fetched.dmpl__AccountId__c);
    System.assertEquals('Draft', fetched.dmpl__Status__c);
    System.assertEquals(Date.today(), fetched.dmpl__DocumentDate__c);

    Boolean exceptionThrown = false;

    Test.startTest();
    try {
        fetched.dmpl__BranchId__c=branch3.Id;
        update fetched;
    } catch (DmlException e) {
        exceptionThrown = true;
    }
    Test.stopTest();

    System.assertEquals(true, exceptionThrown, 'expected exception due to wrong branch ');
    }
    // Service Lead creation with inactive branch (New)
    @isTest
    static void CreateServiceLeadWithInactiveBranchNegative() {
    Account Partner = TestDataHelpers.getPartnerAccount('Partner 3');
    Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
    dmpl__Branch__c wrongbranch = TestDataHelpers.getBranch('Branch 3');
    Date documentDate = Date.today();

    Boolean exceptionThrown = false;

    Test.startTest();
    try {
        ServiceLeadTestDataHelpers.createServiceLeadbyId(
            Partner,
            wrongbranch,
            customer,
            null,
            null,
            null,
            null,
            documentDate
        );
    } catch (DmlException e) {
        exceptionThrown = true;
    }
    Test.stopTest();

    System.assertEquals(true, exceptionThrown, 'expected exception due to Inactive branch ');
    }
    // Service Lead creation with inactive branch (Edit)
    @isTest
    static void UpdateServiceLeadWithInactiveBranchNegative() {
    Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
    Account partner3 = TestDataHelpers.getPartnerAccount('Partner 3');
    Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
    dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
    dmpl__Branch__c branch3 = TestDataHelpers.getBranch('Branch 3');
    Date documentDate = Date.today();

    dmpl__ServiceLead__c lead = ServiceLeadTestDataHelpers.createServiceLeadbyId(
        partner,
        branch,
        customer,
        null,
        null,
        null,
        null,
        documentDate
    );

    dmpl__ServiceLead__c fetched = ServiceLeadTestDataHelpers.getServiceLeadById(lead.Id);

    System.assertEquals(partner.Id, fetched.dmpl__PartnerAccountId__c);
    System.assertEquals(branch.Id, fetched.dmpl__BranchId__c);
    System.assertEquals(customer.Id, fetched.dmpl__AccountId__c);
    System.assertEquals('Draft', fetched.dmpl__Status__c);
    System.assertEquals(Date.today(), fetched.dmpl__DocumentDate__c);

    Boolean exceptionThrown = false;

    Test.startTest();
    try {
        fetched.dmpl__BranchId__c=branch3.Id;
        update fetched;
    } catch (DmlException e) {
        exceptionThrown = true;
    }
    Test.stopTest();

    System.assertEquals(true, exceptionThrown, 'expected exception due to inactive branch ');
    }
    // Service Lead with active customer account (New)
    @isTest
    static void CreateServiceLeadWithActiveCustomerAccountPositive() {
    // Arrange
    Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
    Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
    dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');


    Date documentDate = Date.today();
    String status = 'Draft';

    // Act
    Test.startTest();
    dmpl__ServiceLead__c serviceLead = ServiceLeadTestDataHelpers.createServiceLeadbyId(
        partner,
        branch,
        customer,
        null,   
        null,   
        null,   
        null,
        documentDate
    );
    dmpl__ServiceLead__c fetched = ServiceLeadTestDataHelpers.getServiceLeadbyId(serviceLead.Id);
    Test.stopTest();

    System.assertEquals(partner.Id, fetched.dmpl__PartnerAccountId__c, 'Partner should match');
    System.assertEquals(branch.Id, fetched.dmpl__BranchId__c, 'Branch should match');
    System.assertEquals(customer.Id, fetched.dmpl__AccountId__c, 'Customer should match');
    System.assertEquals(status, fetched.dmpl__Status__c, 'Status should be Draft');
    System.assertEquals(documentDate, fetched.dmpl__DocumentDate__c, 'Document date should be today');
    }

    // Service Lead with active customer account (Edit)
    @isTest
    static void updateServiceLeadWithActiveCustomerAccountPositive() {
    Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
    Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
    Account customer2 = TestDataHelpers.getCustomerAccount('Customer 2');
    dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');

    Date documentDate = Date.today();
    String status = 'Draft';

    Test.startTest();
    dmpl__ServiceLead__c serviceLead = ServiceLeadTestDataHelpers.createServiceLeadbyId(
        partner,
        branch,
        customer1,
        null,
        null,
        null,
        null,
        documentDate
    );
    dmpl__ServiceLead__c fetchedBefore = ServiceLeadTestDataHelpers.getServiceLeadbyId(serviceLead.Id);

    System.assertEquals(partner.Id, fetchedBefore.dmpl__PartnerAccountId__c);
    System.assertEquals(branch.Id, fetchedBefore.dmpl__BranchId__c);
    System.assertEquals(customer1.Id, fetchedBefore.dmpl__AccountId__c);
    System.assertEquals(status, fetchedBefore.dmpl__Status__c);
    System.assertEquals(documentDate, fetchedBefore.dmpl__DocumentDate__c);

    fetchedBefore.dmpl__AccountId__c = customer2.Id;

    update fetchedBefore;
    dmpl__ServiceLead__c fetchedAfter = ServiceLeadTestDataHelpers.getServiceLeadbyId(fetchedBefore.Id);
    Test.stopTest();

    System.assertEquals(partner.Id, fetchedAfter.dmpl__PartnerAccountId__c);
    System.assertEquals(branch.Id, fetchedAfter.dmpl__BranchId__c);
    System.assertEquals(customer2.Id, fetchedAfter.dmpl__AccountId__c);
    System.assertEquals(status, fetchedAfter.dmpl__Status__c);
    System.assertEquals(documentDate, fetchedAfter.dmpl__DocumentDate__c);
    }
    // Service Lead with in-active customer account (New)
    @isTest
    static void CreateServiceLeadWithInactiveCustomerNegative() {
    Account Partner = TestDataHelpers.getPartnerAccount('Partner 1');
    Account customer = TestDataHelpers.getCustomerAccount('Customer 7');
    dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
    Date documentDate = Date.today();

    Boolean exceptionThrown = false;

    Test.startTest();
    try {
        ServiceLeadTestDataHelpers.createServiceLeadbyId(
            Partner,
            branch,
            customer,
            null,
            null,
            null,
            null,
            documentDate
        );
    } catch (DmlException e) {
        exceptionThrown = true;
    }
    Test.stopTest();

    System.assertEquals(true, exceptionThrown, 'expected exception due to Inactive customer account ');
    }
    // Service Lead with in-active customer account (Edit)
    @isTest
    static void UpdateServiceLeadWithInactiveCustomerAccountNegative() {
    Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
    Account partner3 = TestDataHelpers.getPartnerAccount('Partner 3');
    Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
    Account customer7 = TestDataHelpers.getCustomerAccount('Customer 7');
    dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
    dmpl__Branch__c branch3 = TestDataHelpers.getBranch('Branch 3');
    Date documentDate = Date.today();

    dmpl__ServiceLead__c lead = ServiceLeadTestDataHelpers.createServiceLeadbyId(
        partner,
        branch,
        customer,
        null,
        null,
        null,
        null,
        documentDate
    );

    dmpl__ServiceLead__c fetched = ServiceLeadTestDataHelpers.getServiceLeadById(lead.Id);

    System.assertEquals(partner.Id, fetched.dmpl__PartnerAccountId__c);
    System.assertEquals(branch.Id, fetched.dmpl__BranchId__c);
    System.assertEquals(customer.Id, fetched.dmpl__AccountId__c);
    System.assertEquals('Draft', fetched.dmpl__Status__c);
    System.assertEquals(Date.today(), fetched.dmpl__DocumentDate__c);

    Boolean exceptionThrown = false;

    Test.startTest();
    try {
        fetched.dmpl__AccountId__c=customer7.Id;
        update fetched;
    } catch (DmlException e) {
        exceptionThrown = true;
    }
    Test.stopTest();

    System.assertEquals(true, exceptionThrown, 'expected exception due to inactive customer account ');
    }
    // Service Lead creation with asset (New)
    @isTest
    static void CreateServiceLeadWithAssetPositive() {
    Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
    Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
    dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
    dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');

    Asset asset1 = AssetDataHelper.createAsset('Asset 1', customer.Id, item1.Id);

    Date documentDate = Date.today();
    String status = 'Draft';

    Test.startTest();
    dmpl__ServiceLead__c serviceLead = ServiceLeadTestDataHelpers.createServiceLeadbyId(
        partner,
        branch,
        customer,
        asset1,   
        null,   
        null,   
        null,
        documentDate
    );
    dmpl__ServiceLead__c fetched = ServiceLeadTestDataHelpers.getServiceLeadbyId(serviceLead.Id);
    Test.stopTest();

    System.assertEquals(partner.Id, fetched.dmpl__PartnerAccountId__c, 'Partner should match');
    System.assertEquals(branch.Id, fetched.dmpl__BranchId__c, 'Branch should match');
    System.assertEquals(customer.Id, fetched.dmpl__AccountId__c, 'Customer should match');
    System.assertEquals(asset1.id,fetched.dmpl__AssetId__c,'asset should match');
    System.assertEquals(status, fetched.dmpl__Status__c, 'Status should be Draft');
    System.assertEquals(documentDate, fetched.dmpl__DocumentDate__c, 'Document date should be today');
    }

    // Service Lead creation with asset (Edit)
    @isTest
    static void updateServiceLeadWithAssetNegative() {
        Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
        Account customer1 = TestDataHelpers.getCustomerAccount('Customer 1');
        Account customer2 = TestDataHelpers.getCustomerAccount('Customer 2');
        Account customer3 = TestDataHelpers.getCustomerAccount('Customer 3');
        dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
        dmpl__Item__c item1 = TestDataHelpers.getItem('Item 1');
         dmpl__Item__c item5 = TestDataHelpers.getItem('Item 5'); 
        Asset asset1 = AssetDataHelper.createAsset('Asset 1', customer1.Id, item1.Id);
        Asset asset3 = AssetDataHelper.createAsset('Asset 3', customer3.Id, item5.Id);

        Date documentDate = Date.today();
        String status = 'Draft';

        Test.startTest();
        dmpl__ServiceLead__c serviceLead = ServiceLeadTestDataHelpers.createServiceLeadbyId(
            partner,
            branch,
            customer1,
            asset1,
            null,
            null,
            null,
            null
        );
        dmpl__ServiceLead__c fetched = ServiceLeadTestDataHelpers.getServiceLeadbyId(serviceLead.Id);

        System.assertEquals(partner.Id, fetched.dmpl__PartnerAccountId__c);
        System.assertEquals(branch.Id, fetched.dmpl__BranchId__c);
        System.assertEquals(customer1.Id, fetched.dmpl__AccountId__c);
        System.assertEquals(asset1.Id, fetched.dmpl__AssetId__c,'asset should match');
        System.assertEquals('Draft', fetched.dmpl__Status__c);
        System.assertEquals(documentDate, fetched.dmpl__DocumentDate__c);

        Boolean exceptionThrown=false;

        try{
            fetched.dmpl__AssetId__c = asset3.Id;
            update fetched;
        }catch(Exception e){
            exceptionThrown=true;
        }
        System.assertEquals(true,exceptionThrown,'exception should be thrown de to wrong asset on edit');
        
        
        Test.stopTest();
    }
    // Service Lead creation without asset (New)
    @isTest
    static void CreateServiceLeadWithoutAssetPositive() {
    // Arrange
    Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
    Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
    dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');

    Date documentDate = Date.today();
    String status = 'Draft';

    Test.startTest();
    dmpl__ServiceLead__c serviceLead = ServiceLeadTestDataHelpers.createServiceLeadbyId(
        partner,
        branch,
        customer,
        null,   
        null,   
        null,   
        null,
        documentDate
    );
    dmpl__ServiceLead__c fetched = ServiceLeadTestDataHelpers.getServiceLeadbyId(serviceLead.Id);
    Test.stopTest();

    System.assertEquals(partner.Id, fetched.dmpl__PartnerAccountId__c, 'Partner should match');
    System.assertEquals(branch.Id, fetched.dmpl__BranchId__c, 'Branch should match');
    System.assertEquals(customer.Id, fetched.dmpl__AccountId__c, 'Customer should match');
    System.assertEquals(status, fetched.dmpl__Status__c, 'Status should be Draft');
    System.assertEquals(documentDate, fetched.dmpl__DocumentDate__c, 'Document date should be today');
    }
    // Service Lead creation with Case reference (New)
    @isTest
    static void createServiceLeadWithCaseReferencePositive() {
    Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
    Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
    dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
    Date documentDate = Date.today();

    Test.startTest();
    dmpl__Case__c createdCase = CaseTestDataHelper.CreateCaseById(partner, customer, branch, null);


    dmpl__Case__c fetchedCase = CaseTestDataHelper.getCaseById(createdCase.Id);

    System.assertEquals(partner.Id, fetchedCase.dmpl__PartnerAccountId__c);
    System.assertEquals(branch.Id, fetchedCase.dmpl__BranchId__c);
    System.assertEquals(customer.Id, fetchedCase.dmpl__AccountId__c);
    System.assertEquals(Date.today(), fetchedCase.dmpl__DocumentDate__c);

    dmpl__ServiceLead__c serviceLead = ServiceLeadTestDataHelpers.createServiceLeadbyId(
        partner,
        branch,
        customer,
        null,
        fetchedCase,
        null,
        null,
        documentDate
    );
    Test.stopTest();

    dmpl__ServiceLead__c fetchedLead = ServiceLeadTestDataHelpers.getServiceLeadbyId(serviceLead.Id);

    System.assertEquals(partner.Id, fetchedLead.dmpl__PartnerAccountId__c);
    System.assertEquals(branch.Id, fetchedLead.dmpl__BranchId__c);
    System.assertEquals(customer.Id, fetchedLead.dmpl__AccountId__c);
    System.assertEquals(fetchedCase.Id, fetchedLead.dmpl__CaseId__c);
    System.assertEquals('Draft', fetchedLead.dmpl__Status__c);
    System.assertEquals(Date.today(), fetchedLead.dmpl__DocumentDate__c);
    }
    // Service Lead creation with Case reference (Edit)
    @isTest
    static void updateServiceLeadWithCaseReferencePositive() {
    Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
    Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
    dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');
    Date documentDate = Date.today();

    Test.startTest();
    dmpl__Case__c case1 = CaseTestDataHelper.CreateCaseById(partner, customer, branch, null);
    dmpl__Case__c case2 = CaseTestDataHelper.CreateCaseById(partner, customer, branch, null);


    dmpl__Case__c fetchedCase1 = CaseTestDataHelper.getCaseById(case1.Id);
    dmpl__Case__c fetchedCase2 = CaseTestDataHelper.getCaseById(case2.Id);

    System.assertEquals(partner.Id, fetchedCase1.dmpl__PartnerAccountId__c);
    System.assertEquals(customer.Id, fetchedCase1.dmpl__AccountId__c);
    System.assertEquals(branch.Id, fetchedCase1.dmpl__BranchId__c);
    System.assertEquals(Date.today(), fetchedCase1.dmpl__DocumentDate__c);

    dmpl__ServiceLead__c serviceLead = ServiceLeadTestDataHelpers.createServiceLeadbyId(
        partner,
        branch,
        customer,
        null,
        fetchedCase1,
        null,
        null,
        documentDate
    );


    dmpl__ServiceLead__c fetchedLeadBefore = ServiceLeadTestDataHelpers.getServiceLeadbyId(serviceLead.Id);

    System.assertEquals(fetchedCase1.Id, fetchedLeadBefore.dmpl__CaseId__c);
    System.assertEquals(partner.Id, fetchedLeadBefore.dmpl__PartnerAccountId__c);
    System.assertEquals(branch.Id, fetchedLeadBefore.dmpl__BranchId__c);
    System.assertEquals(customer.Id, fetchedLeadBefore.dmpl__AccountId__c);
    System.assertEquals('Draft', fetchedLeadBefore.dmpl__Status__c);
    System.assertEquals(Date.today(), fetchedLeadBefore.dmpl__DocumentDate__c);

    fetchedLeadBefore.dmpl__CaseId__c = fetchedCase2.Id;

    update fetchedLeadBefore;
    Test.stopTest();

    dmpl__ServiceLead__c fetchedLeadAfter = ServiceLeadTestDataHelpers.getServiceLeadbyId(fetchedLeadBefore.Id);

    System.assertEquals(fetchedCase2.Id, fetchedLeadAfter.dmpl__CaseId__c);
    System.assertEquals(partner.Id, fetchedLeadAfter.dmpl__PartnerAccountId__c);
    System.assertEquals(branch.Id, fetchedLeadAfter.dmpl__BranchId__c);
    System.assertEquals(customer.Id, fetchedLeadAfter.dmpl__AccountId__c);
    System.assertEquals('Draft', fetchedLeadAfter.dmpl__Status__c);
    System.assertEquals(Date.today(), fetchedLeadAfter.dmpl__DocumentDate__c);
    }



    // Service Lead creation without Case reference (New)

    @isTest
    static void CreateServiceLeadWithoutCaseReferencePositive() {
    // Arrange
    Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
    Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
    dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');

    Date documentDate = Date.today();
    String status = 'Draft';

    // Act
    Test.startTest();
    dmpl__ServiceLead__c serviceLead = ServiceLeadTestDataHelpers.createServiceLeadbyId(
        partner,
        branch,
        customer,
        null,   
        null,   
        null,   
        null,
        documentDate
    );
    dmpl__ServiceLead__c fetched = ServiceLeadTestDataHelpers.getServiceLeadbyId(serviceLead.Id);
    Test.stopTest();

    System.assertEquals(partner.Id, fetched.dmpl__PartnerAccountId__c, 'Partner should match');
    System.assertEquals(branch.Id, fetched.dmpl__BranchId__c, 'Branch should match');
    System.assertEquals(customer.Id, fetched.dmpl__AccountId__c, 'Customer should match');
    System.assertEquals(status, fetched.dmpl__Status__c, 'Status should be Draft');
    System.assertEquals(documentDate, fetched.dmpl__DocumentDate__c, 'Document date should be today');
    }

    // Service Lead creation with Campaign reference (New)
    @isTest
    static void createServiceLeadWithCampaignReferencePositive() {
    Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
    Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
    dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');

    Date startDate = Date.newInstance(2025, 6, 10);
    Date endDate = Date.newInstance(2025, 7, 30);

    Test.startTest();
    dmpl__ServiceCampaign__c campaign = CampaignTestDataHelpers.createServiceCampaign(
        'Campaign 1',
        'Field Filter',
        null,
        null,
        'All Rules Are Met',
        'Marketing',
        startDate,
        endDate
    );


    dmpl__ServiceCampaign__c fetchedCampaign = CampaignTestDataHelpers.getServiceCampaignById(campaign.Id);

    System.assertEquals('Campaign 1', fetchedCampaign.Name);
    System.assertEquals('Field Filter', fetchedCampaign.dmpl__DynamicMemberType__c);
    System.assertEquals('Marketing', fetchedCampaign.dmpl__Type__c);
    System.assertEquals('All Rules Are Met', fetchedCampaign.dmpl__RuleSuccessCriteria__c);
    System.assertEquals(startDate, fetchedCampaign.dmpl__StartDate__c);
    System.assertEquals(endDate, fetchedCampaign.dmpl__EndDate__c);

    dmpl__ServiceLead__c serviceLead = ServiceLeadTestDataHelpers.createServiceLeadbyId(
        partner,
        branch,
        customer,
        null,
        null,
        fetchedCampaign,
        null,
        null
    );
    Test.stopTest();

    dmpl__ServiceLead__c fetchedLead = ServiceLeadTestDataHelpers.getServiceLeadbyId(serviceLead.Id);

    System.assertEquals(partner.Id, fetchedLead.dmpl__PartnerAccountId__c);
    System.assertEquals(branch.Id, fetchedLead.dmpl__BranchId__c);
    System.assertEquals(customer.Id, fetchedLead.dmpl__AccountId__c);
    System.assertEquals(fetchedCampaign.Id, fetchedLead.dmpl__ServiceCampaignId__c);
    System.assertEquals('Draft', fetchedLead.dmpl__Status__c);
    System.assertEquals(Date.today(), fetchedLead.dmpl__DocumentDate__c);
    }

    @isTest
    static void updateServiceLeadWithCampaignReferencePositive() {
    Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
    Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
    dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');

    Date startDate = Date.newInstance(2025, 6, 10);
    Date endDate = Date.newInstance(2025, 7, 30);

    Test.startTest();
    dmpl__ServiceCampaign__c campaign1 = CampaignTestDataHelpers.createServiceCampaign(
        'Campaign 1',
        'Field Filter',
        null,
        null,
        'All Rules Are Met',
        'Marketing',
        startDate,
        endDate
    );

    dmpl__ServiceCampaign__c campaign2 = CampaignTestDataHelpers.createServiceCampaign(
        'Campaign 2',
        'Field Filter',
        null,
        null,
        'All Rules Are Met',
        'Marketing',
        startDate,
        endDate
    );

    dmpl__ServiceCampaign__c fetchedCampaign1 = CampaignTestDataHelpers.getServiceCampaignById(campaign1.Id);
    dmpl__ServiceCampaign__c fetchedCampaign2 = CampaignTestDataHelpers.getServiceCampaignById(campaign2.Id);

    System.assertEquals('Campaign 1', fetchedCampaign1.Name);
    System.assertEquals('Campaign 2', fetchedCampaign2.Name);

    dmpl__ServiceLead__c serviceLead = ServiceLeadTestDataHelpers.createServiceLeadbyId(
        partner,
        branch,
        customer,
        null,
        null,
        fetchedCampaign1,
        null,
        null
    );
    dmpl__ServiceLead__c fetchedLeadBefore = ServiceLeadTestDataHelpers.getServiceLeadbyId(serviceLead.Id);

    System.assertEquals(fetchedCampaign1.Id, fetchedLeadBefore.dmpl__ServiceCampaignId__c);
    System.assertEquals(partner.Id, fetchedLeadBefore.dmpl__PartnerAccountId__c);
    System.assertEquals(branch.Id, fetchedLeadBefore.dmpl__BranchId__c);
    System.assertEquals(customer.Id, fetchedLeadBefore.dmpl__AccountId__c);
    System.assertEquals('Draft', fetchedLeadBefore.dmpl__Status__c);
    System.assertEquals(Date.today(), fetchedLeadBefore.dmpl__DocumentDate__c);

    fetchedLeadBefore.dmpl__ServiceCampaignId__c = fetchedCampaign2.Id;

    update fetchedLeadBefore;
    Test.stopTest();

    dmpl__ServiceLead__c fetchedLeadAfter = ServiceLeadTestDataHelpers.getServiceLeadbyId(fetchedLeadBefore.Id);

    System.assertEquals(fetchedCampaign2.Id, fetchedLeadAfter.dmpl__ServiceCampaignId__c);
    System.assertEquals(partner.Id, fetchedLeadAfter.dmpl__PartnerAccountId__c);
    System.assertEquals(branch.Id, fetchedLeadAfter.dmpl__BranchId__c);
    System.assertEquals(customer.Id, fetchedLeadAfter.dmpl__AccountId__c);
    System.assertEquals('Draft', fetchedLeadAfter.dmpl__Status__c);
    System.assertEquals(Date.today(), fetchedLeadAfter.dmpl__DocumentDate__c);
    }
    // Service Lead creation without Campaign reference (New)
    @isTest
    static void CreateServiceLeadwithoutCampaignReferencePositive() {

    Account partner = TestDataHelpers.getPartnerAccount('Partner 1');
    Account customer = TestDataHelpers.getCustomerAccount('Customer 1');
    dmpl__Branch__c branch = TestDataHelpers.getBranch('Branch 1');

    Date todayDate = Date.today();

    Test.startTest();
    dmpl__CreditNote__c creditNote = CreditNoteDataHelper.createCreditNoteWithDate(
        partner.Id,
        branch.Id,
        customer.Id,
        todayDate
    );


    dmpl__CreditNote__c fetchedCreditNote = CreditNoteDataHelper.getCreditNoteWithDate(creditNote.Id);

    Test.stopTest();
    System.assertEquals(partner.Id, fetchedCreditNote.dmpl__PartnerAccountId__c, 'Partner should match');
    System.assertEquals(branch.Id, fetchedCreditNote.dmpl__BranchId__c, 'Branch should match');
    System.assertEquals(customer.Id, fetchedCreditNote.dmpl__AccountId__c, 'Customer should match');
    System.assertEquals(todayDate, fetchedCreditNote.dmpl__DocumentDate__c, 'Document date should match today');
    System.assertEquals(0, fetchedCreditNote.dmpl__Amount__c, 'Initial Amount should be 0');
    System.assertEquals(0, fetchedCreditNote.dmpl__GLAmount__c, 'Initial GL Amount should be 0');
    System.assertEquals(0, fetchedCreditNote.dmpl__OpenAmount__c, 'Initial Open Amount should be 0');
    }

    }